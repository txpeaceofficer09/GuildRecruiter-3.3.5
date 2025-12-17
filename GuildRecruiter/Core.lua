local f = CreateFrame("frame", "GuildRecruiterFrame", UIParent)

local GuildRecruiterDB = {
	["timer"] = 30,
	["message"] = "_GUILD_ is recruiting new players for our raid team.",
	["status"] = "off"
}

local function DecimalToHexColor(r, g, b, a)
	return ("|c%02x%02x%02x%02x"):format(a*255, r*255, g*255, b*255)
end

local function GetMessage()
	if not GuildRosterDB then GuildRosterDB = {} end
	if not GuildRosterDB.message then GuildRosterDB.message = "_GUILD_ is recruiting new members for our raid team. Whisper a member for more information." end

	local msg = GuildRosterDB.message
	local guildName = GetGuildInfo("player")

	msg = msg:gsub("_GUILD_", guildName)

	return msg
end

local function SendAddOnMessage()
	if GetChannelName("World") == 0 then JoinChannelByName("World") end

	local msg = GetMessage()

	if GuildRecruiterDB.status == "on" then
		SendChatMessage(msg, "CHANNEL", nil, GetChannelName("World"))
	end
end

local function OnEvent(self, event, ...)
	--[[
	if ( event == "CHAT_MSG_WHISPER" ) then
		local msg, name, _, _, _, _, _, _, _, _, _, guid = ...
		local cmd, target = string.split(" ", string.lower(msg), 2)

	end
	]]

	if event == "VARIABLES_LOADED" then
		if GuildRecruiterDB.status == "on" then
			SendAddOnMessage()
		end
	end
end

local function OnUpdate(self, elapsed)
	self.timer = ( self.timer or 0 ) + elapsed

	if self.timer >= GuildRecruiterDB.timer then
		SendAddOnMessage()

		self.timer = 0
	end
end

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)

--f:RegisterEvent("CHAT_MSG_WHISPER")
f:RegisterEvent("VARIABLES_LOADED")
--f:RegisterEvent("PLAYER_ENTERING_WORLD")

local function SlashCmd(...)
	local cmd, params = string.split(" ", (...), 2)

	if string.lower(cmd) == "msg" then
		if params ~= "" then
			GuildRecruiterDB.message = params
		end

		local msg = GetMessage()

		print(("|cffffaa00[GuildRecruiter]:|r message: %s"):format(msg))
	elseif string.lower(cmd) == "toggle" then
		if GuildRecruiterDB.status == "on" then
			GuildRecruiterDB.status = "off"
			print("|cffffaa00[GuildRecruiter]:|r off")
		else
			GuildRecruiterDB.status = "on"
			print(("|cffffaa00[GuildRecruiter]:|r on (timer: %d sec)"):format(GuildRecruiterDB.timer))
			SendAddOnMessage()
		end
	elseif string.lower(cmd) == "timer" then
		GuildRecruiterDB.timer = params
		f.timer = 0
		print(("|cffffaa00[GuildRecruiter]:|r timer set to: %s sec"):format(GuildRecruiterDB.timer))
	end
end

SLASH_GUILDRECRUITER1 = "/gr"
SLASH_GUILDRECRUITER2 = "/grecruit"
SLASH_GUILDRECRUITER3 = "/guildrecruiter"
SlashCmdList["GUILDRECRUITER"] = SlashCmd
