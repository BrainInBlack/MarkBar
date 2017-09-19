-- Globals ->
MarkBar = {}
MarkBar.title = "MarkBar";
MarkBar.author = "BrainInBlack";
MarkBar.version = "4.0.1 Alpha1";
MarkBar.vid = "1";

-- OnLoad ->
	function MarkBar.OnLoad(self)

		-- Registerevents ->
		self:RegisterEvent("VARIABLES_LOADED");
		self:RegisterEvent("PARTY_MEMBERS_CHANGED");
		self:RegisterEvent("PARTY_LEADER_CHANGED");

		-- TempVars ->
		MarkBar.LastUpdate = 0;
		MarkBar.GroupMode = false;
		MarkBar.ClosedByUser = false;
		MarkBar.PermaMarks = nil;
		MarkBar.PermaMarksRun = false;

		-- SlashCommands ->
		SLASH_MARKBAR1 = "/markbar";
		SLASH_MARKBAR2 = "/mb";
		SlashCmdList["MARKBAR"] = function(msg)
			MarkBar.SlashCommands(self, msg);
		end

	end

-- OnVariablesLoaded ->
	function MarkBar.OnVariablesLoaded(self)
		local frame = self:GetName();

		-- Settings ->
		if(not MarkBarSettings) then
			MarkBar.Print(MarkBar_FIRST_RUN);
			MarkBarSettings = {}
			MarkBarSettings.vid = "1";
			MarkBarSettings.ToolbarAutoShow = false;
			MarkBarSettings.ToolbarFade = false;
			MarkBarSettings.ToolbarLock = false;
			MarkBarSettings.ToolbarTooltip = true;
			MarkBarSettings.ToolbarScale = 1;
			MarkBarSettings.ToolbarAlpha = .95;
			MarkBarSettings.ToolbarAlphaFade = .55;
			MarkBarSettings.ToolbarBackground = {r = .1, g = .1, b = .1}
			MarkBarSettings.ToolbarBorder = {r = .3, g = .3, b = .3}
			MarkBarSettings.MarkAlpha = 1;
			MarkBarSettings.MarkAlphaFade = .55;
			MarkBarSettings.MarkBorder = {r = .3, g = .3, b = .3}
			MarkBarSettings.PermaMarkBorder = {r = .1, g = .5, b = .1}
		elseif(MarkBar.vid ~= MarkBarSettings.vid) then
			-- AddChanges NYI
		end

		-- DefaultOptions ->
		MarkBarSettings = {}
		MarkBarSettings.vid = "1";
		MarkBarSettings.ToolbarAutoShow = false;
		MarkBarSettings.ToolbarFade = false;
		MarkBarSettings.ToolbarLock = false;
		MarkBarSettings.ToolbarTooltip = true;
		MarkBarSettings.ToolbarScale = 1;
		MarkBarSettings.ToolbarAlpha = .95;
		MarkBarSettings.ToolbarAlphaFade = .55;
		MarkBarSettings.ToolbarBackground = {r = .1, g = .1, b = .1}
		MarkBarSettings.ToolbarBorder = {r = .3, g = .3, b = .3}
		MarkBarSettings.MarkAlpha = 1;
		MarkBarSettings.MarkAlphaFade = .55;
		MarkBarSettings.MarkBorder = {r = .3, g = .3, b = .3}
		MarkBarSettings.PermaMarkBorder = {r = .1, g = .5, b = .1}

		-- FrameSettings ->
		if(frame == "MarkBarToolbar") then
			self:SetBackdropColor(MarkBarSettings.ToolbarBackground["r"],
								  MarkBarSettings.ToolbarBackground["g"],
								  MarkBarSettings.ToolbarBackground["b"]);
			self:SetBackdropBorderColor(MarkBarSettings.ToolbarBorder["r"],
										MarkBarSettings.ToolbarBorder["g"],
										MarkBarSettings.ToolbarBorder["b"]);
			self:SetScale(MarkBarSettings.ToolbarScale);
			if(MarkBarSettings.ToolbarFade) then
				self:SetAlpha(MarkBarSettings.ToolbarAlphaFade);
			else
				self:SetAlpha(MarkBarSettings.ToolbarAlpha);
			end
		else
			self:SetBackdropBorderColor(MarkBarSettings.MarkBorder["r"],
										MarkBarSettings.MarkBorder["g"],
										MarkBarSettings.MarkBorder["b"]);
			self:SetAlpha(MarkBarSettings.MarkAlphaFade);
		end

	end

-- OnUpdate ->
	function MarkBar.OnUpdate(elapsed)
		MarkBar.LastUpdate = MarkBar.LastUpdate+elapsed;
		if(MarkBar.LastUpdate > 1.0) then
			MarkBar.PermaMark();
			MarkBar.LastUpdate = 0;
		end
	end

-- OnEvent ->
	function MarkBar.OnEvent(self, event, ...)
		local frame = self:GetName();
		-- VariablesLoaded ->
		if(event == "VARIABLES_LOADED") then
			MarkBar.OnVariablesLoaded(self);
			return;
		end
		-- PartyMembersChanged ->
		if(event == "PARTY_MEMBERS_CHANGED" or event == "PARTY_LEADER_CHANGED") then
			MarkBar.PartyMembersChanged(self);
			return;
		end
	end

-- PartyMemberChanged ->
function MarkBar.PartyMembersChanged(self)
	if((GetRealNumRaidMembers and (IsRaidLeader("player") or IsRaidOfficer("Player"))) or (GetRealNumPartyMembers())) then
		MarkBar.GroupMode = true;
		if(MarkBarSettings.ToolbarAutoShow and not self:IsVisible() and not MarkBar.ClosedByUser) then
			self:Show();
		end
	else
		MarkBar.GroupMode = false;
		if(MarkBarSettings.ToolbarAutoShow and self:IsVisible() and not MarkBar.ClosedByUser) then
			self:Hide();
		end
	end
end


-- MarkRuntime ->

	-- PermaMark ->
	function MarkBar.PermaMark()
		if(MarkBar.PermaMarks) then
			for id, player in pairs(MarkBar.PermaMarks) do
				if(GetRaidTargetIndex(player) ~= id) then
					SetRaidTarget(player, id);
				end
			end
		end
	end

	-- PermaToggle ->
	function MarkBar.PermaToggle()
		if(MarkBar.PermaMarks) then
			if(MarkBar.PermaMarksRun) then
				MarkBar.PermaMarksRun = false;
				MarkBarStart:Show();
				MarkBarStop:Hide();
			else
				MarkBar.PermaMarksRun = true;
				MarkBarStart:Hide();
				MarkBarStop:Show();
			end
		end
	end

	-- SetMark ->
	function MarkBar.SetMark(id)
		if(MarkBar.GroupMode) then
			SetRaidTargetIcon("target", id);
			return;
		elseif(not GetRealNumRaidMembers() or not GetRealNumPartyMembers()) then
			SetRaidTargetIcon("target", id);
			return;
		end
		MarkBar.Print(COLOR_RED..MarkBar_MARK_NO_LEAD..COLOR_END);
	end

	-- ResetPermaMark ->
	function MarkBar.ResetPermaMark()
		if(MarkBar.PermaMarks) then
			for mark, player in pairs(MarkBar.PermaMarks) do
				MarkBar.MarkResetBorder(mark);
			end
			MarkBar.PermaMarks = nil;
		end
	end

	--SetPermaMark ->
	function MarkBar.SetPermaMark(self, id)
		if(MarkBar.GroupMode) then
			if(UnitIsPlayer("target") and (UnitInParty("target") or UnitInRaid("target"))) then
				if(not MarkBar.PermaMarks) then
					MarkBar.PermaMarks = {
							[id] = UnitName("target")
						}
				else
					for mark, player in pairs(MarkBar.PermaMarks) do
						if(mark == id) then
							MarkBar.Print(MarkBar_RT[id]..COLOR_RED..MarkBar_MARK_ALLREADY_SET..COLOR_END);
							return;
						elseif(player == UnitName("target")) then
							MarkBar.Print(COLOR_RED..MarkBar_MARK_PLAYER_ALLREADY_SET..MarkBar_RT[mark]..COLOR_END);
							return;
						end
					end
					MarkBar.PermaMarks[id] = UnitName("target");
				end
				self:SetBackdropBorderColor(MarkBarSettings.PermaMarkBorder["r"],
											MarkBarSettings.PermaMarkBorder["g"],
											MarkBarSettings.PermaMarkBorder["b"]);
				return;
			end
			MarkBar.Print(COLOR_RED..MarkBar_MARK_NO_PLAYER..COLOR_END);
		end
		MarkBar.Print(COLOR_RED..MarkBar_MARK_NO_PARTY..COLOR_END);
	end


-- MainFrame ->

	-- Toggle ->
	function MarkBar.ToolbarToggle()
		if(MarkBarToolbar:IsVisible()) then
			MarkBarToolbar:Hide();
			if(MarkBar.GroupMode) then
				MarkBar.ClosedByUser = true;
			end
		else
			MarkBarToolbar:Show();
			MarkBar.ClosedByUser = false;
		end
	end

	-- Lock ->
	function MarkBar.ToolbarLock()
		if(MarkBarSettings.ToolbarLock) then
			MarkBarSettings.ToolbarLock = false;
			MarkBar.Print(MarkBar_UNLOCKED);
		else
			MarkBarSettings.ToolbarLock = true;
			MarkBar.Print(MarkBar_LOCKED);
		end
	end

	-- MoveOnDown ->
	function MarkBar.MoveOnDown(self, button)
		if(button == "LeftButton" and not MarkBarSettings.ToolbarLock) then
			self:StartMoving();
		end
	end

	-- MoveOnUp ->
	function MarkBar.MoveOnUp(self, button)
		if(button == "LeftButton" and not MarkBarSettings.ToolbarLock) then
			self:StopMovingOrSizing();
		end
	end

	-- ToolbarMouseOver ->
	function MarkBar.ToolbarMouseIn(self) -- Over
		if(MarkBarSettings.ToolbarFade) then
			self:SetAlpha(MarkBarSettings.ToolbarAlpha);
		end
	end

	function MarkBar.ToolbarMouseOut(self) -- Normal
		if(MarkBarSettings.ToolbarFade) then
			self:SetAlpha(MarkBarSettings.ToolbarAlphaFade);
		end
	end


-- MarkButtons ->

	-- MarkOnClick ->
	function MarkBar.MarkOnClick(self, button)
		local id = self:GetID();

		if(button == "LeftButton") then
			SetRaidTargetIcon("target", id);
		elseif(button == "RightButton") then
			MarkBar.SetPermaMark(self, id);
		end
	end

	-- MarkOnLoad ->
	function MarkBar.MarkOnLoad(self)
		self:RegisterEvent("VARIABLES_LOADED");
		self:RegisterForClicks("LeftButtonUp","RightButtonUp");
	end

	-- MarkMouseOver ->
	function MarkBar.MarkMouseIn(self) -- Over
		local id = self:GetID();

		-- Alpha ->
		self:SetAlpha(MarkBarSettings.MarkAlpha);
		if(MarkBarSettings.ToolbarFade) then
			MarkBarToolbar:SetAlpha(MarkBarSettings.ToolbarAlpha);
		end

		-- ToolTip ->
		MarkBar.MarkTooltip(self, id);

	end

	function MarkBar.MarkMouseOut(self) -- Out
		local id = self:GetID();

		-- Alpha ->
		self:SetAlpha(MarkBarSettings.MarkAlphaFade);
		if(MarkBarSettings.ToolbarFade) then
			MarkBarToolbar:SetAlpha(MarkBarSettings.ToolbarAlphaFade);
		end

		-- Tooltip ->
		GameTooltip:Hide();
	end

	-- MarkTooltip ->
	function MarkBar.MarkTooltip(self, id)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
		if(MarkBar.PermaMarks and MarkBar.PermaMarks[id]) then
			local name = MarkBar.PermaMarks[id];
			if(UnitExists(name)) then
				local playerClass, realClass = UnitClass(name);
				local pmarkText = MarkBar_TIP_MARKED..name;
				GameTooltip:AddLine(pmarkText,
									RAID_CLASS_COLORS[realClass].r,
									RAID_CLASS_COLORS[realClass].g,
									RAID_CLASS_COLORS[realClass].b);
			else
				GameTooltip:AddLine(MarkBar_TIP_MARKED..name..MarkBar_TIP_UNKNOWN, .5, .5, .5);
			end
		else
			GameTooltip:AddLine(MarkBar_TIP_MARK_NOTSET , 1, 1, 1);
		end
		GameTooltip:Show();
	end

	-- MarkResetBorder ->
	function MarkBar.MarkResetBorder(mark)
		local alias = {MarkBarMarkM1, MarkBarMarkM2, MarkBarMarkM3, MarkBarMarkM4, MarkBarMarkM5, MarkBarMarkM6, MarkBarMarkM7, MarkBarMarkM8}
		alias[mark]:SetBackdropBorderColor(MarkBarSettings.MarkBorder["r"],
										   MarkBarSettings.MarkBorder["g"],
										   MarkBarSettings.MarkBorder["b"]);
	end


-- SettingsFrame ->

	-- SettingsToggle ->
	function MarkBar.SettingsToggle()
		MarkBar.Print("Settings NYI");
	end


-- SlashCmdParser ->
function MarkBar.ParamParser(msg)
 	if msg then
 		local a,b,c=strfind(msg, "(%S+)");
 		if a then
 			return c, strsub(msg, b+2);
 		else	
 			return "";
 		end
 	end
end

-- SlashCommands ->
	function MarkBar.SlashCommands(self, msg)
		local cmd, param = MarkBar.ParamParser(msg);

		if(cmd == "") then
			MarkBar.ToolbarToggle();
		elseif(cmd == "lock") then
			MarkBar.ToolbarLock();
		elseif(cmd == "config" or cmd == "settings") then
			-- SettingsFrame
			MarkBar.SettingsToggle();
		elseif(cmd == "start") then
			MarkBar.PermaMarksRun = true;
			MarkBar.Print(MarkBar_MARK_RUN_START);
		elseif(cmd == "stop") then
			MarkBar.PermaMarksRun = false;
			MarkBar.Print(MarkBar_MARK_RUN_STOP);
		elseif(cmd == "reset") then
			MarkBar.ResetPermaMark()
			if(MarkBar.PermaMarksRun) then
				MarkBar.PermaMarksRun = false;
			end
			MarkBar.Print(MarkBar_MARK_RESET);
		elseif(cmd == "mark") then
			if(param == "" or type(tonumber(param)) ~= "number") then
				MarkBar.Print(COLOR_RED..MarkBar_MARK_PARAM_MISSING..COLOR_END);
				return;
			elseif(tonumber(param) >= 0 and tonumber(param) <= 8) then
				SetRaidTargetIcon("target", tonumber(param));
				return;
			end
			MarkBar.Print(COLOR_RED..MarkBar_MARK_WRONG_NUMBER);
		else
			MarkBar.Print(COLOR_RED..MarkBar_UNKNOWN_COMMAND..COLOR_END);
		end
	end


-- Print ->
	function MarkBar.Print(msg)
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_ORANGE..MarkBar.title..": "..COLOR_END..msg);
	end
