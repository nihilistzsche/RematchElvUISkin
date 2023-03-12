local _, skin = ...

local rematch

local E, L, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local ES
if IsAddOnLoaded("ProjectAzilroka") or IsAddOnLoaded("ElvUI_NihilsitzscheUI") then
	ES = _G.EnhancedShadows
end

skin.panels = {
	Frame = function(self)
		Mixin(self, BackdropTemplateMixin)
		self:StripTextures()
		self:SetTemplate("Default")
		if ES then
			self:CreateShadow()
			ES:RegisterFrameShadows(self)
		end
		self.TitleBar:StripTextures()
		S:HandleCloseButton(self.TitleBar.MinimizeButton, nil, "-")
		S:HandleCloseButton(self.TitleBar.LockButton, nil, "")
		S:HandleCloseButton(self.TitleBar.SinglePanelButton, nil, "=")
		skin:SetButtonIcon(self.TitleBar.LockButton, "Locked")
		for _, tab in ipairs(self.PanelTabs.Tabs) do
			skin:HandlePanelTab(tab)
		end
		hooksecurefunc(Rematch.Frame, "Update", function()
			local titlebar = rematch.Frame.TitleBar
			skin:SetButtonIcon(titlebar.LockButton, RematchSettings.LockPosition and "Locked" or "Unlocked")
			titlebar.SinglePanelButton:SetShown(not RematchSettings.Minimized)
			skin:SetButtonIcon(titlebar.MinimizeButton, RematchSettings.Minimized and "Maximized" or "Minimized")
			skin:SetButtonIcon(titlebar.SinglePanelButton, RematchSettings.SinglePanel and "DualPanel" or "SinglePanel")
		end)
	end,
	Journal = function(self)
		Mixin(self, BackdropTemplateMixin)
		self:StripTextures()
		self:SetTemplate("Default")
		if ES then
			self:CreateShadow()
			ES:RegisterFrameShadows(self)
		end
		for _, tab in ipairs(self.PanelTabs.Tabs) do
			skin:HandlePanelTab(tab)
		end
		RematchJournalPortrait:Hide()
		S:HandleCloseButton(self.CloseButton)
		local handled
		self:HookScript("OnEvent", function()
			if not handled and UseRematchButton then
				S:HandleCheckBox(UseRematchButton)
				handled = true
			end
		end)
		-- added in Rematch 4.3.4
		if self.OtherAddonJournalStuff then
			hooksecurefunc(self, "OtherAddonJournalStuff", function()
				if self.CollectMeButton then
					S:HandleButton(self.CollectMeButton, true)
					self.CollectMeButton:SetHeight(20)
					self.CollectMeButton:SetPoint("RIGHT", rematch.BottomPanel.SaveButton, "LEFT", -2, 0)
				end
				if self.PetTrackerJournalButton then
					S:HandleCheckBox(self.PetTrackerJournalButton)
				end
			end)
		end
	end,
	BottomPanel = function(self)
		for _, button in ipairs({ "SummonButton", "SaveButton", "SaveAsButton", "FindBattleButton" }) do
			S:HandleButton(self[button], true)
			self[button]:SetHeight(20)
		end
		S:HandleCheckBox(self.UseDefault)
	end,
	Toolbar = function(self)
		for _, button in ipairs(self.Buttons) do
			S:HandleButton(button)
			button.IconBorder:SetAlpha(0)
		end
		S:HandleButton(self.PetCount, true)
	end,
	PetCard = function(self)
		Mixin(self, BackdropTemplateMixin)
		self:StripTextures()
		self:SetTemplate("Default")
		if ES then
			self:CreateShadow()
			ES:RegisterFrameShadows(self)
		end
		S:HandleCloseButton(self.CloseButton)
		S:HandleCloseButton(self.PinButton, nil, "")
		skin:SetButtonIcon(self.PinButton, "Pinned")
		self.Title.TitleBG:SetDrawLayer("BACKGROUND", 2)
		local r, g, b = 0.05, 0.05, 0.05
		Mixin(self.Front, BackdropTemplateMixin)
		self.Front:SetBackdrop({ edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 4 })
		self.Front:SetBackdropBorderColor(r, g, b)
		Mixin(self.Back, BackdropTemplateMixin)
		self.Back:SetBackdrop({})
		self.Back:SetBackdrop({ edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 4 })
		self.Back:SetBackdropBorderColor(r, g, b)
		-- also reskinning ability card here
		local abilityCard = RematchAbilityCard
		Mixin(abilityCard, BackdropTemplateMixin)
		abilityCard:SetBackdrop({ edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 4 })
		abilityCard:SetBackdropBorderColor(r, g, b)
		-- change all the horizontal divider lines to solid black lines
		for _, frame in ipairs({
			self.Front.Bottom,
			self.Front.Middle,
			self.Back.Source,
			self.Back.Bottom,
			self.Back.Middle,
			abilityCard,
			abilityCard.Hints,
		}) do
			for _, region in ipairs({ frame:GetRegions() }) do
				local anchorPoint, relativeTo = region:GetPoint()
				if
					region:GetObjectType() == "Texture"
					and region:GetDrawLayer() == "ARTWORK"
					and anchorPoint == "LEFT"
					and relativeTo == frame
				then
					region:SetTexture(r, g, b)
					region:SetHeight(4)
				end
			end
		end
	end,
	LoadoutPanel = function(self)
		Mixin(self, BackdropTemplateMixin)
		self:StripTextures()
		Mixin(self.Target, BackdropTemplateMixin)
		self.Target:StripTextures()
		self.Target:SetTemplate("Default")
		if ES then
			self:CreateShadow()
			ES:RegisterFrameShadows(self)
		end
		for i = 1, 3 do
			Mixin(self.Loadouts[i], BackdropTemplateMixin)
			self.Loadouts[i]:StripTextures()
			self.Loadouts[i]:SetTemplate("Default")
		end
		S:HandleButton(self.Target.TargetButton)
		S:HandleButton(self.Target.LoadSaveButton)
		for i = 1, 3 do
			for j = 1, 3 do
				S:HandleButton(self.Loadouts[i].Abilities[j])
				self.Loadouts[i].Abilities[j].IconBorder:Hide()
			end
		end
		self.Flyout:SetTemplate("Default")
		for i = 1, 2 do
			S:HandleButton(self.Flyout.Abilities[i])
			self.Flyout.Abilities[i].IconBorder:Hide()
		end
	end,
	LoadedTeamPanel = function(self)
		Mixin(self, BackdropTemplateMixin)
		self:StripTextures()
		self:SetTemplate("Default")
		Mixin(self.Footnotes, BackdropTemplateMixin)
		self.Footnotes:StripTextures()
		S:HandleCloseButton(self.Footnotes.Close)
		S:HandleCloseButton(self.Footnotes.Maximize, nil, "-")
	end,
	PetPanel = function(self)
		skin:HandleAutoScrollFrame(self.List)
		-- top
		Mixin(self.Top, BackdropTemplateMixin)
		self.Top:StripTextures()
		Mixin(self.Top.TypeBar, BackdropTemplateMixin)
		self.Top.TypeBar:StripTextures()
		for _, tab in ipairs(self.Top.TypeBar.Tabs) do
			skin:HandlePanelTab(tab)
		end
		S:HandleButton(self.Top.Filter)
		S:HandleButton(self.Top.Toggle)
		S:HandleEditBox(self.Top.SearchBox, true)
		Mixin(self.Top.SearchBox, BackdropTemplateMixin)
		self.Top.SearchBox:SetBackdrop({})
		for _, region in ipairs({ self.Top.SearchBox:GetRegions() }) do
			if region:GetDrawLayer() == "BACKGROUND" then
				region:Hide()
			end
		end
		self.Top.SearchBox:SetHeight(22)
		self.Top.SearchBox:SetPoint("LEFT", self.Top.Toggle, "RIGHT", 4, 0)
		self.Top.SearchBox:SetPoint("RIGHT", self.Top.Filter, "LEFT", -4, 0)
		Mixin(self.Results, BackdropTemplateMixin)
		self.Results:StripTextures()
		self.Results:SetTemplate("Default")
		-- typebar requires a bit of extra work
		self.Top.TypeBar:SetPoint("BOTTOM", 0, -2)

		for _, button in ipairs(self.Top.TypeBar.Buttons) do
			S:HandleButton(button)
			button.IconBorder:Hide()
		end

		for _, button in ipairs({ "HealthButton", "PowerButton", "SpeedButton", "RareButton", "Level25Button" }) do
			local btn = self.Top.TypeBar.QualityBar[button]
			S:HandleButton(btn)
			btn.IconBorder:Hide()
		end
	end,
	TeamPanel = function(self)
		skin:HandleAutoScrollFrame(self.List)
		Mixin(self, BackdropTemplateMixin)
		self:StripTextures()
		Mixin(self.Top, BackdropTemplateMixin)
		self.Top:StripTextures()
		S:HandleButton(self.Top.Teams)
		S:HandleEditBox(self.Top.SearchBox, true)
		Mixin(self.Top.SearchBox, BackdropTemplateMixin)
		self.Top.SearchBox:SetBackdrop({})
		for _, region in ipairs({ self.Top.SearchBox:GetRegions() }) do
			if region:GetDrawLayer() == "BACKGROUND" then
				region:Hide()
			end
		end
		self.Top.SearchBox:SetHeight(22)
		self.Top.SearchBox:SetPoint("RIGHT", self.Top.Teams, "LEFT", -4, 0)
	end,
	MiniQueue = function(self)
		skin:HandleAutoScrollFrame(self.List)
		Mixin(self.Top, BackdropTemplateMixin)
		self.Top:StripTextures()
		S:HandleButton(self.Top.QueueButton)
		Mixin(self.Status, BackdropTemplateMixin)
		self.Status:StripTextures()
		self.Status:SetTemplate("Default")
	end,
	MiniPanel = function(self)
		Mixin(self.Background, BackdropTemplateMixin)
		self.Background:StripTextures()
		self.Background:SetTemplate("Default")
		Mixin(self.Target, BackdropTemplateMixin)
		self.Target:StripTextures()
		self.Target:SetTemplate("Default")
		S:HandleButton(self.Target.LoadButton)
		for i = 1, 3 do
			for j = 1, 3 do
				S:HandleButton(self.Pets[i].Abilities[j])
				self.Pets[i].Abilities[j].IconBorder:Hide()
			end
		end
		self.Flyout:SetTemplate("Default")
		for i = 1, 2 do
			S:HandleButton(self.Flyout.Abilities[i])
			self.Flyout.Abilities[i].IconBorder:Hide()
		end
	end,
	QueuePanel = function(self)
		skin:HandleAutoScrollFrame(self.List)
		Mixin(self.Top, BackdropTemplateMixin)
		self.Top:StripTextures()
		S:HandleButton(self.Top.QueueButton)
		Mixin(self.Status, BackdropTemplateMixin)
		self.Status:StripTextures()
		self.Status:SetTemplate("Default")
	end,
	OptionPanel = function(self)
		skin:HandleAutoScrollFrame(self.List)
	end,
	TeamTabs = function(self)
		hooksecurefunc(self, "Update", function(self)
			if
				RematchSettings.TeamTabsToLeft
				and RematchSettings.AlwaysTeamTabs
				and self:GetParent() == rematch.Frame
			then
				local anchorPoint, relativeTo, relativePoint, x, y = self:GetPoint()
				self:SetPoint(anchorPoint, relativeTo, relativePoint, x + 5, y)
			end
			for _, button in ipairs(self.Tabs) do
				S:HandleButton(button)
				button:SetSize(40, 40)
				button.Icon:SetPoint("CENTER")
				if ES then
					if not button.shadow then
						button:CreateShadow()
					end
					ES:RegisterFrameShadows(button)
				end
				-- if button:GetID()==RematchSettings.SelectedTab then
				--   button.backdropTexture:SetVertexColor(1,0.82,0)
				-- else
				--   button.backdropTexture:SetVertexColor(0.1,0.1,0.1)
				-- end
			end
			S:HandleButton(self.UpButton)
			self.UpButton:SetSize(40, 40)
			self.UpButton.Icon:SetPoint("CENTER")
			if ES then
				if not self.UpButton.shadow then
					self.UpButton:CreateShadow()
				end
				ES:RegisterFrameShadows(self.UpButton)
			end
			S:HandleButton(self.DownButton)
			self.DownButton:SetSize(40, 40)
			self.DownButton.Icon:SetPoint("CENTER")
			if ES then
				if not self.DownButton.shadow then
					self.DownButton:CreateShadow()
				end
				ES:RegisterFrameShadows(self.DownButton)
			end
		end)
	end,
	Dialog = function(self)
		Mixin(self, BackdropTemplateMixin)
		self:StripTextures()
		self:SetTemplate("Default")
		if ES then
			self:CreateShadow()
			ES:RegisterFrameShadows(self)
		end
		S:HandleCloseButton(self.CloseButton)
		S:HandleButton(self.Accept, true)
		S:HandleButton(self.Cancel, true)
		S:HandleButton(self.Other, true)
		Mixin(self.Prompt, BackdropTemplateMixin)
		self.Prompt:StripTextures()
		self.Prompt:SetTemplate("Default")
		S:HandleEditBox(self.EditBox)
		--self.EditBox:SetBackdrop({})
		--S:HandleButton(self.TabPicker)
		Mixin(self.TabPicker, BackdropTemplateMixin)
		self.TabPicker:StripTextures()
		self.TabPicker:SetTemplate(nil, true)
		self.TabPicker.isSkinned = true
		self.TabPicker.Icon:SetDrawLayer("ARTWORK")
		Mixin(self.TeamTabIconPicker, BackdropTemplateMixin)
		self.TeamTabIconPicker:StripTextures()
		self.TeamTabIconPicker:SetTemplate("Default")
		if ES then
			self.TeamTabIconPicker:CreateShadow()
			ES:RegisterFrameShadows(self.TeamTabIconPicker)
		end
		S:HandleScrollBar(self.TeamTabIconPicker.ScrollFrame.ScrollBar)
		S:HandleEditBox(self.MultiLine)
		Mixin(self.MultiLine, BackdropTemplateMixin)
		self.MultiLine:SetTemplate("Default")
		S:HandleScrollBar(self.MultiLine.ScrollBar)
		for _, child in ipairs({ self.MultiLine:GetChildren() }) do
			if child:GetObjectType() == "Button" then
				child:SetBackdrop({})
			end
		end
		S:HandleCheckBox(self.CheckButton)
		--self.CollectionReport.ChartTypeComboBox:SetBackdrop({})
		--self.CollectionReport.Chart:SetBackdrop({})
		S:HandleEditBox(self.SaveAs.Name)
		--self.SaveAs.Name:SetBackdrop({})
		S:HandleEditBox(self.SaveAs.Target)
		Mixin(self.SaveAs.Target, BackdropTemplateMixin)
		self.SaveAs.Target:StripTextures()
		self.SaveAs.Target:SetTemplate("Default")
		S:HandleEditBox(self.ScriptFilter.Name)
		--self.ScriptFilter.Name:SetBackdrop({})
		for i = 1, 3 do
			S:HandleButton(self.ScriptFilter.ReferenceButtons[i])
		end
		for _, button in ipairs({ "MinHP", "MaxHP", "MinXP", "MaxXP" }) do
			S:HandleEditBox(self.Preferences[button])
			--self.Preferences[button]:SetBackdrop({})
		end
		S:HandleCheckBox(self.Preferences.AllowMM)
		local handledExpectedDD
		hooksecurefunc(Rematch, "ShowPreferencesDialog", function()
			if not handledExpectedDD then
				for i = 1, 10 do
					S:HandleButton(self.Preferences.expectedDD[i])
					self.Preferences.expectedDD[i].IconBorder:Hide()
				end
				handledExpectedDD = true
			end
		end)
	end,
	Notes = function(self)
		Mixin(self, BackdropTemplateMixin)
		self:StripTextures()
		self:SetTemplate("Default")
		if ES then
			self:CreateShadow()
			ES:RegisterFrameShadows(self)
		end
		S:HandleButton(self.Controls.SaveButton)
		S:HandleButton(self.Controls.UndoButton)
		S:HandleButton(self.Controls.DeleteButton)
		S:HandleCloseButton(self.CloseButton)
		S:HandleCloseButton(self.LockButton, nil, "")
		hooksecurefunc(self, "UpdateLockState", function()
			skin:SetButtonIcon(self.LockButton, RematchSettings.LockNotesPosition and "Locked" or "Unlocked")
		end)
		self.Content:StripTextures()
		self.Content:SetTemplate("Default")
		for _, region in ipairs({ self.Content:GetRegions() }) do
			if region:GetDrawLayer() == "ARTWORK" then
				if region:GetObjectType() == "Texture" then -- restore thin gold border around icons
					region:SetTexture("Interface\\PetBattles\\PetBattleHUD")
					region:SetTexCoord(0.884765625, 0.943359375, 0.681640625, 0.798828125)
				end
			end
		end
	end,
}

--[[ Stuff that needs to be done on login that has no panel goes here (menus, tooltips, etc) ]]
skin.misc = {
	Menu = function()
		-- menu framepool is local, going to force the creation of three levels of menus and skin them
		for i = 1, 3 do
			local menu = rematch:GetMenuFrame(i, UIParent)
			menu:Hide()
			Mixin(menu, BackdropTemplateMixin)
			menu:StripTextures()
			menu:SetTemplate("Default")
			for _, region in ipairs({ menu.Title:GetRegions() }) do
				if region:GetObjectType() == "Texture" and region:GetDrawLayer() == "BACKGROUND" then
					region:SetTexture()
				end
			end
		end
	end,
	Tooltip = function()
		Mixin(RematchTooltip, BackdropTemplateMixin)
		RematchTooltip:StripTextures()
		RematchTooltip:SetTemplate("Default")
		if ES then
			RematchTooltip:CreateShadow()
			ES:RegisterFrameShadows(RematchTooltip)
		end
		Mixin(RematchTableTooltip, BackdropTemplateMixin)
		RematchTableTooltip:StripTextures()
		RematchTableTooltip:SetTemplate("Default")
	end,
	WinRecordCard = function()
		local self = RematchWinRecordCard
		Mixin(self, BackdropTemplateMixin)
		self:StripTextures()
		self:SetTemplate("Default")
		if ES then
			self:CreateShadow()
			ES:RegisterFrameShadows(self)
		end
		for _, button in ipairs({ "SaveButton", "CancelButton", "ResetButton" }) do
			S:HandleButton(self.Controls[button])
			self.Controls[button]:SetHeight(20)
		end
		S:HandleCloseButton(self.CloseButton)
		Mixin(self.Content, BackdropTemplateMixin)
		self.Content:StripTextures()
		self.Content:SetTemplate("Default")
		for _, stat in ipairs({ "Wins", "Losses", "Draws" }) do
			S:HandleEditBox(self.Content[stat].EditBox)
			--[[self.Content[stat].EditBox:SetBackdrop(
				{bgFile = "Interface\\ChatFrame\\ChatFrameBackground", insets = {left = 3, right = 3, top = 3, bottom = 3}}
			)
			self.Content[stat].EditBox:SetBackdropColor(0, 0, 0)]]
			S:HandleButton(self.Content[stat].Add)
			self.Content[stat].Add.IconBorder:Hide()
		end
	end,
}

--[[ Helper functions ]]
local icons = {
	Locked = { 0, 0.5, 0, 0.25 },
	Unlocked = { 0.5, 1, 0, 0.25 },
	Minimized = { 0, 0.5, 0.25, 0.5 },
	Maximized = { 0.5, 1, 0.25, 0.5 },
	SinglePanel = { 0, 0.5, 0.5, 0.75 },
	DualPanel = { 0.5, 1, 0.5, 0.75 },
	Pinned = { 0, 0.5, 0.75, 1 },
}

function skin:SetButtonIcon(button, icon)
	if not button.RematchElvUISkinIcon then
		button.RematchElvUISkinIcon = button:CreateTexture(nil, "ARTWORK")
		button.RematchElvUISkinIcon:SetPoint("TOPLEFT", button, "TOPLEFT", 10, -10)
		button.RematchElvUISkinIcon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -10, 10)
		button.RematchElvUISkinIcon:SetTexture("Interface\\AddOns\\RematchElvUISkin\\icons.tga")
		button:HookScript("OnEnter", function(self)
			button.RematchElvUISkinIcon:SetVertexColor(1, 0.48235, 0.17255)
		end)
		button:HookScript("OnLeave", function(self)
			button.RematchElvUISkinIcon:SetVertexColor(0.9, 0.9, 0.9)
		end)
		button.RematchElvUISkinIcon:SetVertexColor(0.9, 0.9, 0.9)
	end
	if icons[icon] then
		button.RematchElvUISkinIcon:SetTexCoord(unpack(icons[icon]))
		button.RematchElvUISkinIcon:SetAlpha(1)
		if button.Texture then -- hide ElvUI's icon texture; it's being replaced with RematchElvUISkinIcon
			button.Texture:SetAlpha(0)
		end
	end
end

function skin:ColorPetListBorders()
	for _, button in ipairs(self.buttons) do
		button:SetBackdropBorderColor(0, 0, 0)
		if button.slim then
			local petID = button.petID
			local r, g, b = 0.3, 0.3, 0.3
			if type(petID) == "string" then
				local rarity = select(5, C_PetJournal.GetPetStats(petID))
				if rarity then
					local c = ITEM_QUALITY_COLORS[rarity - 1]
					r, g, b = c.r, c.g, c.b
				end
			end
			button.backdropTexture:SetVertexColor(r / 3, g / 3, b / 3)
		end
	end
end

function skin:HandlePanelTab(tab)
	if not tab then
		return
	end
	Mixin(tab, BackdropTemplateMixin)

	for _, texture in ipairs({ tab:GetRegions() }) do
		if texture:GetDrawLayer() == "BACKGROUND" then
			texture:SetTexture(nil)
		end
	end
	-- following is taken from ElvUI\modules\skins\skins.lua S:HandleTab(tab) function
	-- (custom tabs don't have named textures it's looking for)
	if tab.GetHighlightTexture and tab:GetHighlightTexture() then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		Mixin(tab, BackdropTemplateMixin)
		tab:StripTextures()
	end

	tab.backdrop = CreateFrame("Frame", nil, tab)
	Mixin(tab.backdrop, BackdropTemplateMixin)
	tab.backdrop:SetTemplate("Default")
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
	tab.backdrop:Point("BOTTOMRIGHT", -10, 3)

	if tab.GetHighlightTexture and tab:GetHighlightTexture() then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		tab:StripTextures()
	end
end

function skin:HandleAutoScrollFrame(listFrame)
	if not listFrame then
		return
	end
	Mixin(listFrame, BackdropTemplateMixin)
	Mixin(listFrame.Background, BackdropTemplateMixin)
	listFrame:StripTextures()
	listFrame.Background:StripTextures()

	Mixin(listFrame.ScrollFrame, BackdropTemplateMixin)
	Mixin(listFrame.ScrollFrame.ScrollBar, BackdropTemplateMixin)
	listFrame.ScrollFrame:StripTextures()
	listFrame.ScrollFrame.ScrollBar:StripTextures()

	local upButton = listFrame.ScrollFrame.ScrollBar.UpButton
	S:HandleNextPrevButton(upButton) --, true) -- , true)
	--upButton:SetSize(upButton:GetWidth()+7,upButton:GetHeight()+7)

	local downButton = listFrame.ScrollFrame.ScrollBar.DownButton
	S:HandleNextPrevButton(downButton) -- , true) -- , false)
	--downButton:SetSize(downButton:GetWidth()+7,downButton:GetHeight()+7)

	local scrollBar = listFrame.ScrollFrame.ScrollBar
	scrollBar:GetThumbTexture():SetTexture(nil)
	-- if not thumbTrimY then thumbTrimY = 3 end
	-- if not thumbTrimX then thumbTrimX = 2 end
	-- scrollBar.thumbbg = CreateFrame("Frame", nil, scrollBar)
	-- scrollBar.thumbbg:Point("TOPLEFT", scrollBar:GetThumbTexture(), "TOPLEFT", 2, -thumbTrimY)
	-- scrollBar.thumbbg:Point("BOTTOMRIGHT", scrollBar:GetThumbTexture(), "BOTTOMRIGHT", -thumbTrimX, thumbTrimY)
	scrollBar:SetThumbTexture("Interface\\AddOns\\ElvUI\\core\\media\\textures\\melli")
	scrollBar:GetThumbTexture():SetVertexColor(0.5, 0.5, 0.5)
	scrollBar:GetThumbTexture():Size(14, 14)

	--scrollBar.thumbbg:SetTemplate("Default", true, true)
	--	scrollBar.thumbbg.backdropTexture:SetVertexColor(0.6, 0.6, 0.6)
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	rematch = Rematch
	local majorVersion, minorVersion = (GetAddOnMetadata("Rematch", "Version") or ""):match("^(%d+)%.(%d+)")
	if majorVersion then -- keeping this so dialog appears when Rematch 5.0 eventually released
		majorVersion, minorVersion = tonumber(majorVersion), tonumber(minorVersion)
		if majorVersion < 4 or majorVersion > 4 or (majorVersion == 4 and minorVersion < 3) then
			local dialog = rematch:ShowDialog("CantElvUISkin", 300, 164, "Rematch Needs Updated", nil, nil, nil, OKAY)
			dialog:ShowText(
				format(
					"This version of Rematch ElvUI Skin supports Rematch version 4.3 through 4.9.\n\nYour Rematch is version %d.%d",
					majorVersion,
					minorVersion
				),
				260,
				96,
				"TOP",
				0,
				-32
			)
			return
		else
			C_Timer.After(0, function()
				-- wait a frame for rematch to do its initialization
				if rematch.isLoaded and not self.skinDone then
					for panel, func in pairs(skin.panels) do
						func(rematch[panel])
					end
					for _, func in pairs(skin.misc) do
						func()
					end
					self.skinDone = true
					self:UnregisterAllEvents()
				end
			end)
		end
	end
end)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
