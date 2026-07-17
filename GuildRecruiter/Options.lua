--[[
local panel = CreateFrame("Frame", "GuildRecruitConfig", UIParent)
panel.name = "Guild Recruiter"
InterfaceOptions_AddCategory(panel)

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Guild Recruiter Settings")

local delaySlider = CreateFrame("Slider", "GuildRecruitDelaySlider", panel, "OptionsSliderTemplate")
delaySlider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -30)
delaySlider:SetMinMaxValues(30, 300)
delaySlider:SetValueStep(10)
delaySlider:SetObeyStepOnDrag(true)
delaySlider:SetWidth(300)

_G[delaySlider:GetName().."Low"]:SetText("30s")
_G[delaySlider:GetName().."High"]:SetText("300s")
_G[delaySlider:GetName().."Text"]:SetText("Message Delay (seconds)")

delaySlider:SetScript("OnValueChanged", function(self, value)
	GuildRecruitDB.delay = value
end)

local msgBox = CreateFrame("EditBox", "GuildRecruitMsgBox", panel, "InputBoxTemplate")
msgBox:SetPoint("TOPLEFT", delaySlider, "BOTTOMLEFT", 0, -40)
msgBox:SetSize(400, 30)
msgBox:SetAutoFocus(false)

local msgLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
msgLabel:SetPoint("BOTTOMLEFT", msgBox, "TOPLEFT", 0, 4)
msgLabel:SetText("Recruitment Message")

msgBox:SetScript("OnTextChanged", function(self)
	GuildRecruitDB.message = self:GetText()
end)

local enableCheck = CreateFrame("CheckButton", "GuildRecruitEnableCheck", panel, "InterfaceOptionsCheckButtonTemplate")
enableCheck:SetPoint("TOPLEFT", msgBox, "BOTTOMLEFT", 0, -10)
_G[enableCheck:GetName().."Text"]:SetText("Enable Recruitment Messages")

enableCheck:SetScript("OnClick", function(self)
	GuildRecruitDB.enabled = self:GetChecked()
end)

panel:SetScript("OnShow", function()
	delaySlider:SetValue(GuildRecruitDB.delay or 300)
	msgBox:SetText(GuildRecruitDB.message or "")
	enableCheck:SetChecked(GuildRecruitDB.enabled)
end)
]]
