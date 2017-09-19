MarkBar.Print("Settings Loaded");
MarkBar.ConfigLoaded = true;

-- OnShow ->
function MarkBarConfig.OnShow()

	-- ConfigFrame ->
	MarkBarConfig:SetBackdropColor(.1, .1, .1, .95);
	MarkBarConfig:SetBackdropBorderColor(.3, .3, .3);
	MarkBarConfig.title:SetText(MarkBar_SETTINGS_TITLE);
	MarkBarConfig.version:SetText(MarkBar.version);

	-- ToolbarLock ->
	MarkBarConfigLock.text:SetText(MarkBar_SETTINGS_LOCK);
	MarkBarConfigLock:SetChecked(MarkBarSettings.ToolbarLock);

	-- Autoshow ->
	MarkBarConfigAutoshow.text:SetText(MarkBar_SETTINGS_AUTOSHOW);
	MarkBarConfigAutoshow:SetChecked(MarkBarSettings.ToolbarAutoShow);

	-- Tooltips ->
	MarkBarConfigTooltips.text:SetText(MarkBar_SETTINGS_TOOLTIPS);
	MarkBarConfigTooltips:SetChecked(MarkBarSettings.ToolbarTooltip);

	-- Fade ->
	MarkBarConfigFade.text:SetText(MarkBar_SETTINGS_FADE);
	MarkBarConfigFade:SetChecked(MarkBarSettings.ToolbarFade);

	-- Alpha ->
	MarkBarConfigAlpha.option:SetText(MarkBar_SETTINGS_ALPHA);
	MarkBarConfigAlpha.min:SetText("Min");
	MarkBarConfigAlpha.max:SetText("Max");
	MarkBarConfigAlpha:SetMinMaxValues(0,1);
	MarkBarConfigAlpha:SetValueStep(.01);
	MarkBarConfigAlpha:SetValue(MarkBarSettings.ToolbarAlpha);

	-- FadeAlpha ->
	MarkBarConfigAlphaFade.option:SetText(MarkBar_SETTINGS_FALPHA);
	MarkBarConfigAlphaFade.min:SetText("Min");
	MarkBarConfigAlphaFade.max:SetText("Max");
	MarkBarConfigAlphaFade:SetMinMaxValues(0,1);
	MarkBarConfigAlphaFade:SetValueStep(.01);
	MarkBarConfigAlphaFade:SetValue(MarkBarSettings.ToolbarAlphaFade);

	-- Scale ->
	MarkBarConfigScale.option:SetText(MarkBar_SETTINGS_SCALE);
	MarkBarConfigScale.min:SetText("Min");
	MarkBarConfigScale.max:SetText("Max");
	MarkBarConfigScale:SetMinMaxValues(.85,1.5);
	MarkBarConfigScale:SetValueStep(.01);
	MarkBarConfigScale:SetValue(MarkBarSettings.ToolbarScale);

	-- ReadyCheck ->
	MarkBarConfigReadyCheck.text:SetText(MarkBar_SETTINGS_READY);
	MarkBarConfigReadyCheck:SetChecked(MarkBarSettings.ReadyCheck);

	-- Flares ->
	MarkBarConfigFlare.text:SetText(MarkBar_SETTINGS_FLARE);
	MarkBarConfigFlare:SetChecked(MarkBarSettings.FlareToolbar);
end

-- OnClick ->
function MarkBarConfig.OnClick(self, button)
	local frame = self:GetName();

	-- ToolbarLock ->
	if(frame == "MarkBarConfigLock") then
		if(self:GetChecked()) then
			MarkBarSettings.ToolbarLock = true;
		else
			MarkBarSettings.ToolbarLock = false;
		end
		return;
	end

	-- Autoshow ->
	if(frame == "MarkBarConfigAutoshow") then
		if(self:GetChecked()) then
			MarkBarSettings.ToolbarAutoShow = true;
		else
			MarkBarSettings.ToolbarAutoShow = false;
		end
	end

	-- Tooltips ->
	if(frame == "MarkBarConfigTooltips") then
		if(self:GetChecked()) then
			MarkBarSettings.ToolbarTooltip = true;
		else
			MarkBarSettings.ToolbarTooltip = false;
		end
	end

	-- Fade ->
	if(frame == "MarkBarConfigFade") then
		if(self:GetChecked()) then
			MarkBarSettings.ToolbarFade = true;
			MarkBarToolbar:SetAlpha(MarkBarSettings.ToolbarAlphaFade);
		else
			MarkBarSettings.ToolbarFade = false;
			MarkBarToolbar:SetAlpha(MarkBarSettings.ToolbarAlpha);
		end
	end

	-- ReadyCheck ->
	if(frame == "MarkBarConfigReadyCheck") then
		if(self:GetChecked()) then
			MarkBarSettings.ReadyCheck = true;
			if(MarkBar.InRaid or MarkBar.InParty) then
				MarkBarReadyCheckBar:Show();
			end
		else
			MarkBarSettings.ReadyCheck = false;
			if(MarkBar.InRaid or MarkBar.InParty) then
				MarkBarReadyCheckBar:Hide();
			end
		end
	end

	-- Flare ->
	if(frame == "MarkBarConfigFlare") then
		if(self:GetChecked()) then
			MarkBarSettings.FlareToolbar = true;
			if(MarkBar.InRaid) then
				MarkBarFlareBar:Show();
			end
		else
			MarkBarSettings.FlareToolbar = false;
			if(MarkBar.InRaid) then
				MarkBarFlareBar:Hide();
			end
		end
	end

end

-- OnChange ->
function MarkBarConfig.OnChange(self)
	local frame = self:GetName();

	-- Alpha ->
	if(frame == "MarkBarConfigAlpha") then
		MarkBarSettings.ToolbarAlpha = self:GetValue();
		if(not MarkBarSettings.ToolbarFade) then
			MarkBarToolbar:SetAlpha(self:GetValue());
		end
		return;
	end

	-- FadeAlpha ->
	if(frame == "MarkBarConfigAlphaFade") then
		MarkBarSettings.ToolbarAlphaFade = self:GetValue();
		if(MarkBarSettings.ToolbarFade) then
			MarkBarToolbar:SetAlpha(self:GetValue());
		end
		return;
	end

	-- Scale ->
	if(frame == "MarkBarConfigScale") then
		MarkBarSettings.ToolbarScale = self:GetValue();
		MarkBarToolbar:SetScale(self:GetValue());
		return;
	end
end

-- Tooltip ->
function MarkBarConfig.Tooltip(self)
	local frame = self:GetName();
	GameTooltip:SetOwner(MarkBarConfig, "ANCHOR_BOTTOMRIGHT", -308, -10);

	-- ToolbarLock ->
	if(frame == "MarkBarConfigLock") then
		GameTooltip:SetText(MarkBar_SETTINGS_LOCK_TIP);
		GameTooltip:AddLine(MarkBar_SETTINGS_LOCK_HINT);
		return;
	end

	-- Autoshow ->
	if(frame == "MarkBarConfigAutoshow") then
		GameTooltip:SetText(MarkBar_SETTINGS_AUTOSHOW_TIP);
		GameTooltip:AddLine(MarkBar_SETTINGS_AUTOSHOW_HINT);
		return;
	end

	-- Tooltips ->
	if(frame == "MarkBarConfigTooltips") then
		GameTooltip:SetText(MarkBar_SETTINGS_TOOLTIPS_TIP);
		GameTooltip:AddLine(MarkBar_SETTINGS_TOOLTIPS_HINT);
		return;
	end

	-- Fade ->
	if(frame == "MarkBarConfigFade") then
		GameTooltip:SetText(MarkBar_SETTINGS_FADE_TIP);
		GameTooltip:AddLine(MarkBar_SETTINGS_FADE_HINT);
		return;
	end

	-- Alpha ->
	if(frame == "MarkBarConfigAlpha") then
		GameTooltip:SetText(MarkBar_SETTINGS_ALPHA_TIP);
		GameTooltip:AddLine(MarkBar_SETTINGS_ALPHA_HINT);
		return;
	end

	-- ReadyCheck ->
	if(frame == "MarkBarConfigReadyCheck") then
		GameTooltip:SetText(MarkBar_SETTINGS_READY_TIP);
		GameTooltip:AddLine(MarkBar_SETTINGS_READY_HINT);
		return;
	end

	-- Flare ->
	if(frame == "MarkBarConfigFlare") then
		GameTooltip:SetText(MarkBar_SETTINGS_FLARE_TIP);
		GameTooltip:AddLine(MarkBar_SETTINGS_FLARE_HINT);
		return;
	end

	-- FadeAlpha ->
	if(frame == "MarkBarConfigAlphaFade") then
		GameTooltip:SetText(MarkBar_SETTINGS_FALPHA_TIP);
		GameTooltip:AddLine(MarkBar_SETTINGS_FALPHA_HINT);
		return;
	end

	-- Scale ->
	if(frame == "MarkBarConfigScale") then
		GameTooltip:SetText(MarkBar_SETTINGS_SCALE_TIP);
		GameTooltip:AddLine(MarkBar_SETTINGS_SCALE_HINT);
		return;
	end
end