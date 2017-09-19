Marbar = {

	title = 	"MarkBar";
	author = 	"BrainInBlack";
	version = 	"4.0.2b - RC1";
	vid = 		3;

	function OnLoad(self)
		self:RegisterEvent("ADDON_LOADED");
		self:RegisterEvent("PARTY_MEMBERS_CHANGED");
		self:RegisterEvent("PARTY_LEADER_CHANGED");

		LastUpdate = 0;
		InRaid = false;
		InParty = false;
		Solo = true;
		ClosedByUser = false;
		PermaMarks = nil;
		PermaMarksRun = false;
		ConfigLoaded = false;

		SLASH_MARKBAR1 = "/markbar";
		SLASH_MARKBAR2 = "/mb";
		SlashCmdList["MARKBAR"] = function(msg)
			SlashCommands(self, msg);
		end
	end

}


-- OnEvent ->
	function MarkBar.OnEvent(self, event, ...)
		local arg1 = ...;

		-- PartyChanged ->
		if(event == "PARTY_MEMBERS_CHANGED" or event == "PARTY_LEADER_CHANGED") then
			MarkBar.PartyChanged(self);
			return;
		end

		-- AddonLoaded ->
		if(event == "ADDON_LOADED" and arg1 == "MarkBar") then
			MarkBar.AddonLoaded();
			return;
		end

	end

	-- AddonLoaded ->
		function MarkBar.AddonLoaded()
			-- WelcomeMessage ->
			MarkBar.Print(MarkBar_GENERAL_WELCOME_PART1..COLOR_ORANGE.." v"..MarkBar.version..COLOR_END..MarkBar_GENERAL_WELCOME_PART2..COLOR_CLASS["DEATHKNIGHT"]..MarkBar.author..COLOR_END);

			-- Settings ->
			if(not MarkBarSettings) then
				MarkBar.Print(MarkBar_GENERAL_FIRST_RUN);
				MarkBarSettings = {}
				MarkBarSettings.vid = "2";
				MarkBarSettings.ToolbarAutoShow = true;
				MarkBarSettings.ToolbarFade = false;
				MarkBarSettings.ToolbarLock = false;
				MarkBarSettings.ToolbarTooltip = true;
				MarkBarSettings.ToolbarScale = 1.15;
				MarkBarSettings.ToolbarAlpha = .95;
				MarkBarSettings.ToolbarAlphaFade = .55;
				MarkBarSettings.ToolbarBackground = {r = .1, g = .1, b = .1}
				MarkBarSettings.ToolbarBorder = {r = .3, g = .3, b = .3}
				MarkBarSettings.MarkAlpha = .95;
				MarkBarSettings.MarkAlphaFade = .55;
				MarkBarSettings.MarkBorder = {r = .3, g = .3, b = .3}
				MarkBarSettings.PermaMarkBorder = {r = .1, g = .5, b = .1}
				MarkBarSettings.FlareToolbar = true; --2
				MarkBarSettings.ReadyCheck = true; --2
			elseif(MarkBar.vid ~= MarkBarSettings.vid) then
				MarkBarSettings.FlareToolbar = true; --2
				MarkBarSettings.ReadyCheck = true; --2
				MarkBarSettings.vid = "2";
			end

			-- ToolbarScale ->
			MarkBarToolbar:SetScale(MarkBarSettings.ToolbarScale);

			-- ToolbarAlpha ->
			if(MarkBarSettings.ToolbarFade) then
				MarkBarToolbar:SetAlpha(MarkBarSettings.ToolbarAlphaFade);
			else
				MarkBarToolbar:SetAlpha(MarkBarSettings.ToolbarAlpha);
			end

			-- ToolbarColors ->
			MarkBarToolbar:SetBackdropColor(MarkBarSettings.ToolbarBackground.r, MarkBarSettings.ToolbarBackground.g, MarkBarSettings.ToolbarBackground.b);
			MarkBarToolbar:SetBackdropBorderColor(MarkBarSettings.ToolbarBorder.r, MarkBarSettings.ToolbarBorder.g, MarkBarSettings.ToolbarBorder.b);

			-- MarkButtonsSetup ->
			local markbuttons = {MarkBarMarkM1, MarkBarMarkM2, MarkBarMarkM3, MarkBarMarkM4, MarkBarMarkM5, MarkBarMarkM6, MarkBarMarkM7, MarkBarMarkM8}
			for i, v in pairs(markbuttons) do
				v:SetBackdropColor(MarkBarSettings.ToolbarBackground.r, MarkBarSettings.ToolbarBackground.g, MarkBarSettings.ToolbarBackground.b);
				v:SetBackdropBorderColor(MarkBarSettings.MarkBorder.r, MarkBarSettings.MarkBorder.g, MarkBarSettings.MarkBorder.g);
				v.icon:SetTexture("Interface\\AddOns\\MarkBar\\tex\\"..i..".blp");
				v:SetAlpha(MarkBarSettings.MarkAlphaFade);
			end

			-- MiniButtonSetup ->
			local minibuttons = {close = MarkBarMiniButtonClose, settings = MarkBarMiniButtonSettings}
			for i, v in pairs(minibuttons) do
				v:SetBackdropColor(MarkBarSettings.ToolbarBackground.r, MarkBarSettings.ToolbarBackground.g, MarkBarSettings.ToolbarBackground.b);
				v:SetBackdropBorderColor(MarkBarSettings.MarkBorder.r, MarkBarSettings.MarkBorder.g, MarkBarSettings.MarkBorder.g);
				v.icon:SetTexture("Interface\\AddOns\\MarkBar\\tex\\"..i..".blp");
				v:SetAlpha(MarkBarSettings.MarkAlphaFade);
			end

			-- PermaControlButtonSetup ->
			local permabuttons = {MarkBarPermaControlDelete, MarkBarPermaControlRun, MarkBarPermaProfile}
			for i, v in pairs(permabuttons) do
				v:SetBackdropColor(MarkBarSettings.ToolbarBackground.r, MarkBarSettings.ToolbarBackground.g, MarkBarSettings.ToolbarBackground.b);
				v:SetBackdropBorderColor(MarkBarSettings.MarkBorder.r, MarkBarSettings.MarkBorder.g, MarkBarSettings.MarkBorder.g);
				v:SetAlpha(MarkBarSettings.MarkAlphaFade);
			end

			-- UnregisterEvent ->
			MarkBarToolbar:UnregisterEvent("ADDON_LOADED");
		end

	-- PartyMemberChanged ->
	function MarkBar.PartyChanged(self)

		-- InRaid ->
		if(UnitInRaid("player") and (IsRaidLeader("player") or IsRaidOfficer("player")) and not UnitInBattleground("player")) then
			MarkBar.InRaid = true;
			MarkBar.InGroup = false;
			MarkBar.Solo = false;
			if(MarkBarSettings.ToolbarAutoShow) then
				self:Show();
			end
			if(MarkBarSettings.FlareToolbar) then
				MarkBarFlareBar:Show();
			end
			if(MarkBarSettings.ReadyCheck) then
				MarkBarReadyCheckBar:Show();
			end
			return;
		end

		-- InParty ->
		if(GetRealNumPartyMembers() >= 1 and not UnitInRaid("player")) then
			MarkBar.InRaid = false;
			MarkBar.InParty = true;
			MarkBar.Solo = false;
			if(MarkBarSettings.ToolbarAutoShow) then
				self:Show();
			end
			if(MarkBarFlareBar:IsVisible()) then
				MarkBarFlareBar:Hide();
			end
			if(MarkBarSettings.ReadyCheck) then
				MarkBarReadyCheckBar:Show();
			end
			return;
		end

		-- Solo ->
		MarkBar.InRaid = false;
		MarkBar.InParty = false;
		if(MarkBarSettings.ToolbarAutoShow) then
			self:Hide();
		end
		if(MarkBarFlareBar:IsVisible()) then
			MarkBarFlareBar:Hide();
		end
		if(MarkBarReadyCheckBar:IsVisible()) then
			MarkBarReadyCheckBar:Hide();
		end
		if(UnitInRaid("player")) then
			MarkBar.Solo = false;
		else
			MarkBar.Solo = true;
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


-- OnClick ->
	function MarkBar.OnClick(self, button)
		local id = self:GetID();

		if(button == "LeftButton") then
			MarkBar.SetMark(id);
		elseif(button == "RightButton") then
			MarkBar.SetPermaMark(self, id);
		end
	end


-- OnEnter ->
	function MarkBar.OnEnter(self)
		local frame = self:GetName();

		-- Buttons ->
		if(frame ~= "MarkBarToolbar" and frame ~= "MarkBarFlareBar" and frame ~= "MarkBarReadyCheckBar") then
			self:SetAlpha(MarkBarSettings.MarkAlpha);
			if(MarkBarSettings.ToolbarTooltip) then
				MarkBar.Tooltip(self);
				GameTooltip:Show();
			end
		end

		-- ToolbarAlpha ->
		if(MarkBarSettings.ToolbarFade) then
			MarkBarToolbar:SetAlpha(MarkBarSettings.ToolbarAlpha);
		end

	end


-- OnLeave ->
	function MarkBar.OnLeave(self)
		local frame = self:GetName();

		-- MarkButtons ->
		if(frame ~= "MarkBarToolbar" and frame ~= "MarkBarFlareBar" and frame ~= "MarkBarReadyCheckBar") then
			self:SetAlpha(MarkBarSettings.MarkAlphaFade);
			if(MarkBarSettings.ToolbarTooltip) then
				GameTooltip:Hide();
			end
		end

		-- ToolbarAlpha ->
		if(MarkBarSettings.ToolbarFade) then
			MarkBarToolbar:SetAlpha(MarkBarSettings.ToolbarAlphaFade);
		end

	end


-- MarkHandler ->

	-- SetMark ->
	function MarkBar.SetMark(id)
		if(MarkBar.InRaid or MarkBar.InParty) then
			SetRaidTargetIcon("target", id);
			return;
		elseif(MarkBar.Solo) then
			SetRaidTargetIcon("target", id);
			return;
		end
		MarkBar.Print(MarkBar_MARK_NO_LEADER);
	end

	-- PermaMark ->
	function MarkBar.PermaMark()
		if(MarkBar.PermaMarks and (MarkBar.InRaid or MarkBar.InParty)) then
			for id, player in pairs(MarkBar.PermaMarks) do
				if(GetRaidTargetIndex(player) ~= id) then
					SetRaidTarget(player, id);
				end
			end
		end
	end

	--SetPermaMark ->
	function MarkBar.SetPermaMark(self, id)
		if(MarkBar.InRaid or MarkBar.InParty) then
			if(not MarkBar.Solo) then
				if(UnitIsPlayer("target")) then
					if(UnitInParty("target") or UnitInRaid("target")) then
						if(not MarkBar.PermaMarks) then
							MarkBar.PermaMarks = {
									[id] = UnitName("target")
								}
						else
							for mark, player in pairs(MarkBar.PermaMarks) do
								if(mark == id) then
									local playerClass, realClass = UnitClass(player);
									MarkBar.Print(MarkBar_RT[mark]..MarkBar_MARK_ALREADY_SET_TO..COLOR_CLASS[realClass]..player..COLOR_END);
									return;
								elseif(player == UnitName("target")) then
									local playerClass, realClass = UnitClass(player);
									MarkBar.Print(COLOR_CLASS[realClass]..UnitName(player)..COLOR_END..MarkBar_MARK_PLAYER_ALREADY_SET_TO..MarkBar_RT[mark]);
									return;
								end
							end
							MarkBar.PermaMarks[id] = UnitName("target");
						end
						self:SetBackdropBorderColor(MarkBarSettings.PermaMarkBorder.r, MarkBarSettings.PermaMarkBorder.g, MarkBarSettings.PermaMarkBorder.b);
						return;
					end
					local playerClass, realClass = UnitClass("target");
					MarkBar.Print(COLOR_CLASS[realClass]..UnitName("target")..COLOR_END..MarkBar_MARK_TARGET_NOT_IN_RAID);
					return;
				end
				MarkBar.Print(UnitName("target")..MarkBar_MARK_TARGET_NO_PLAYER);
				return;
			end
			MarkBar.Print(MarkBar_MARK_NO_LEADER);
			return;
		end
		MarkBar.Print(MarkBar_ERROR_NO_PARTY);
	end

	-- ResetPermaMark ->
	function MarkBar.ResetPermaMark()
		if(MarkBar.PermaMarks) then
			for mark, player in pairs(MarkBar.PermaMarks) do
				MarkBar.ResetMarkBorder(mark);
			end
			if(MarkBar.PermaMarksRun) then
				MarkBar.TogglePermaMarks();
			end
			MarkBar.PermaMarks = nil;
		end
	end

	-- MarkResetBorder ->
	function MarkBar.ResetMarkBorder(mark)
		local alias = {MarkBarMarkM1, MarkBarMarkM2, MarkBarMarkM3, MarkBarMarkM4, MarkBarMarkM5, MarkBarMarkM6, MarkBarMarkM7, MarkBarMarkM8}
		alias[mark]:SetBackdropBorderColor(MarkBarSettings.MarkBorder.r, MarkBarSettings.MarkBorder.g, MarkBarSettings.MarkBorder.b);
	end


-- Toggle ->

	-- ToggleToolbar ->
	function MarkBar.ToggleToolbar()
		if(MarkBarToolbar:IsVisible()) then
			if(MarkBar.InRaid or MarkBar.InParty) then
				MarkBar.ClosedByUser = true;
			end
			MarkBarToolbar:Hide();
		else
			MarkBar.ClosedByUser = false;
			MarkBarToolbar:Show();
		end
	end

	-- ToggleToolbarLock ->
	function MarkBar.ToggleToolbarLock()
		if(MarkBarSettings.ToolbarLock) then
			MarkBarSettings.ToolbarLock = false;
			MarkBar.Print(MarkBar_TOOLBAR_UNLOCKED);
		else
			MarkBarSettings.ToolbarLock = true;
			MarkBar.Print(MarkBar_TOOLBAR_LOCKED);
		end
	end

	-- ToggleAutoShow ->
	function MarkBar.ToggleAutoShow(self)
		if(MarkBarSettings.ToolbarAutoShow and not MarkBar.ClosedByUser) then
			if((MarkBar.InRaid or MarkBar.InParty) and not self:IsVisible()) then
				self:Show();
				return;
			elseif(self:IsVisible()) then
				self:Hide();
				return;
			end
		end
	end

	-- TogglePermaMarks ->
	function MarkBar.TogglePermaMarks()
		if(MarkBar.PermaMarks) then
			if(MarkBar.PermaMarksRun) then
				MarkBar.PermaMarksRun = false;
				MarkBarPermaControlRun.text:SetText(MarkBar_TOOLTIP_PMARK_START);
			else
				MarkBar.PermaMarksRun = true;
				MarkBarPermaControlRun.text:SetText(MarkBar_TOOLTIP_PMARK_STOP);
			end
		end
	end

	-- ToggleSettings ->
	function MarkBar.ToggleSettings()
		if(not IsAddOnLoaded("MarkBarConfig") and not LoadAddOn("MarkBarConfig")) then
			MarkBar.Print(MarkBar_ERROR_CONFIG_LOAD);
			return;
		end
		if(MarkBar.ConfigLoaded) then
			if(MarkBarConfig:IsVisible()) then
				MarkBarConfig:Hide();
			else
				MarkBarConfig:Show();
			end
		else
			MarkBar.Print(MarkBar_ERROR_CONFIG_LOAD);
		end
	end


-- MoveHandler ->

	-- MoveOnDown ->
	function MarkBar.MoveOnDown(self, button)
		local frame = self:GetName();
		if(button == "LeftButton") then
			if(frame == "MarkBarToolbar" and MarkBarSettings.ToolbarLock) then
				return;
			end
			self:StartMoving();
		end
	end

	-- MoveOnUp ->
	function MarkBar.MoveOnUp(self, button)
		local frame = self:GetName();
		if(button == "LeftButton") then
			if(frame == "MarkBarToolbar" and MarkBarSettings.ToolbarLock) then
				return;
			end
			self:StopMovingOrSizing();
		end
	end


-- Tooltip ->
function MarkBar.Tooltip(self)
	local frame = self:GetName();
	GameTooltip:SetOwner(MarkBarToolbar, "ANCHOR_TOPLEFT");

	-- MarkButtons ->
	if(string.find(frame, "MarkBarMarkM")) then
		local id = self:GetID();
		GameTooltip:SetText(MarkBar_RT[id]);
		if(MarkBar.InRaid or MarkBar.InParty) then
			if(MarkBar.PermaMarks and MarkBar.PermaMarks[id]) then
				local name = MarkBar.PermaMarks[id];
				if(UnitExists(name)) then
					local playerClass, realClass = UnitClass(name);
					GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_ASSIGNED_TO..COLOR_CLASS[realClass]..name..COLOR_END);
				else
					GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_ASSIGNED_TO..COLOR_GREY..name..MarkBar_TOOLTIP_PMARK_OFFLINE..COLOR_END);
				end
				GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_HINT_SOLO);
			else
				GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_HINT_SOLO);
				GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_HINT_RAID);
			end
		elseif(not MarkBar.Solo) then
			GameTooltip:SetText(MarkBar_TOOLTIP_PMARK_HINT_NO_LEADER);
		else
			GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_HINT_SOLO);
		end
		return;
	end

	-- CloseButton ->
	if(frame == "MarkBarMiniButtonClose") then
		GameTooltip:SetText(MarkBar_TOOLTIP_CLOSE);
		GameTooltip:AddLine(MarkBar_TOOLTIP_CLOSE_HINT);
		return;
	end

	-- SettingsButton ->
	if(frame == "MarkBarMiniButtonSettings") then
		GameTooltip:SetText(MarkBar_TOOLTIP_SETTINGS);
		GameTooltip:AddLine(MarkBar_TOOLTIP_SETTINGS_HINT);
		return;
	end

	-- Start/StopButton ->
	if(frame == "MarkBarPermaControlRun") then
		if(MarkBar.PermaMarks) then
			if(MarkBar.PermaMarksRun) then
				GameTooltip:SetText(MarkBar_TOOLTIP_PMARK_STOP);
				GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_STOP_HINT);
				return;
			else
				GameTooltip:SetText(MarkBar_TOOLTIP_PMARK_START);
				GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_START_HINT);
				return;
			end
		else
			GameTooltip:SetText(MarkBar_TOOLTIP_PMARK_START);
			GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_NOT_SET);
			return;
		end
	end

	-- DeleteButton ->
	if(frame == "MarkBarPermaControlDelete") then
		if(MarkBar.PermaMarks) then
			GameTooltip:SetText(MarkBar_TOOLTIP_PMARK_DELETE);
			GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_DELETE_HINT);
			return;
		else
			GameTooltip:SetText(MarkBar_TOOLTIP_PMARK_DELETE);
			GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_NOT_SET);
			return;
		end
	end

	-- ProfileButton ->
	if(frame == "MarkBarPermaProfile") then
		GameTooltip:SetText(MarkBar_TOOLTIP_PMARK_PROFILE);
		GameTooltip:AddLine(MarkBar_TOOLTIP_PMARK_PROFILE_HINT);
		return;
	end

	-- ReadyCheck ->
	if(frame == "MarkBarReadyCheckBarButton") then
		GameTooltip:SetText(MarkBar_TOOLTIP_READY);
		GameTooltip:AddLine(MarkBar_TOOLTIP_READY_HINT);
		return;
	end

	-- FlareBlue ->
	if(frame == "MarkBarFlareBarBlue") then
		GameTooltip:SetText(MarkBar_TOOLTIP_FLARE_BLUE);
		GameTooltip:AddLine(MarkBar_TOOLTIP_FLARE_BLUE_HINT);
		return;
	end

	-- FlareGreen ->
	if(frame == "MarkBarFlareBarGreen") then
		GameTooltip:SetText(MarkBar_TOOLTIP_FLARE_GREEN);
		GameTooltip:AddLine(MarkBar_TOOLTIP_FLARE_GREEN_HINT);
		return;
	end

	-- FlarePurple ->
	if(frame == "MarkBarFlareBarPurple") then
		GameTooltip:SetText(MarkBar_TOOLTIP_FLARE_PURPLE);
		GameTooltip:AddLine(MarkBar_TOOLTIP_FLARE_PURPLE_HINT);
		return;
	end

	-- FlareRed ->
	if(frame == "MarkBarFlareBarRed") then
		GameTooltip:SetText(MarkBar_TOOLTIP_FLARE_RED);
		GameTooltip:AddLine(MarkBar_TOOLTIP_FLARE_RED_HINT);
		return;
	end

	-- FlareWhite ->
	if(frame == "MarkBarFlareBarWhite") then
		GameTooltip:SetText(MarkBar_TOOLTIP_FLARE_WHITE);
		GameTooltip:AddLine(MarkBar_TOOLTIP_FLARE_WHITE_HINT);
		return;
	end

	-- FlareDelete ->
	if(frame == "MarkBarFlareBarDelete") then
		GameTooltip:SetText(MarkBar_TOOLTIP_FLARE_DELETE);
		GameTooltip:AddLine(MarkBar_TOOLTIP_FLARE_DELETE_HINT);
		return;
	end
end


-- SlashCmdParser ->
function MarkBar.ParamParser(msg)
 	if msg then
 		local a,b,c = strfind(msg, "(%S+)");
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
			MarkBar.ToggleToolbar();
		elseif(cmd == "lock") then
			MarkBar.ToggleToolbarLock();
		elseif(cmd == "config" or cmd == "settings") then
			MarkBar.ToggleSettings();
		elseif(cmd == "start") then
			if(not MarkBar.PermaMarksRun) then
				MarkBar.TogglePermaMarks();
			end
			MarkBar.Print(MarkBar_COMMAND_PMARK_START);
		elseif(cmd == "stop") then
			if(MarkBar.PermaMarksRun) then
				MarkBar.TogglePermaMarks();
			end
			MarkBar.Print(MarkBar_COMMAND_PMARK_STOP);
		elseif(cmd == "reset") then
			MarkBar.ResetPermaMark()
			if(MarkBar.PermaMarksRun) then
				MarkBar.PermaMarksRun = false;
			end
			MarkBar.Print(MarkBar_COMMAND_PMARK_DELETE);
		elseif(cmd == "mark") then
			if(param == "" or type(tonumber(param)) ~= "number") then
				MarkBar.Print(MarkBar_COMMAND_MARK_MISSING);
				return;
			elseif(tonumber(param) >= 0 and tonumber(param) <= 8) then
				local id = tonumber(param);
				MarkBar.SetMark("target", id);
				return;
			end
			MarkBar.Print(MarkBar_COMMAND_MARK_INVALID);
		else
			MarkBar.Print(MarkBar_COMMAND_UNKNOWN);
		end
	end


-- Print ->
	function MarkBar.Print(msg)
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_ORANGE..MarkBar.title..": "..COLOR_END..msg);
	end