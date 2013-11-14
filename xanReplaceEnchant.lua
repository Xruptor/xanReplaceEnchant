
local f = CreateFrame("frame","xanReplaceEnchant",UIParent)
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

----------------------
--      Enable      --
----------------------

function f:PLAYER_LOGIN()

	if not XanRE_DB then XanRE_DB = {} end
	if XanRE_DB.enable == nil then XanRE_DB.enable = 1 end

	self:RegisterEvent("REPLACE_ENCHANT")

	SLASH_XANREPLACEENCHANT1 = "/xanre";
	SlashCmdList["XANREPLACEENCHANT"] = xanRE_SlashCommand;
	
	local ver = GetAddOnMetadata("xanReplaceEnchant","Version") or '1.0'
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r [v|cFFDF2B2B%s|r] loaded:   /xanre", "xanReplaceEnchant", ver or "1.0"))
	
	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

function xanRE_SlashCommand(cmd)
	if XanRE_DB.enable == 1 then
		XanRE_DB.enable = 0
		DEFAULT_CHAT_FRAME:AddMessage("xanReplaceEnchant: Auto replace is OFF");
	else
		XanRE_DB.enable = 1
		DEFAULT_CHAT_FRAME:AddMessage("xanReplaceEnchant: Auto replace is ON");
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function f:REPLACE_ENCHANT(self, oldE, newE)
	if XanRE_DB.enable == 0 then return end
	
	--TODO:
	--there seems to be an issue with temp enchants, such as shaman temp enchants or these Imbue ones
	--http://www.wowwiki.com/Imbue
	--The only thing I can think of is check the oldE vrs the newE for temp enchants.
	--I suppose if someone is just spamming the same enchant we can always do oldE = newE, but that would sorta suck if we are doing different ones
	--Maybe a list of possible enchants?
	
	-- ReplaceEnchant()
	-- StaticPopup1Button1:Click()
	
	--temporary fix for the popup, code from tekAccept author tekkub
	for i = 1, STATICPOPUP_NUMDIALOGS do
		 local frame = _G["StaticPopup"..i]
		 if (frame:IsVisible() and frame.which == "REPLACE_ENCHANT") then 
			  StaticPopup_OnClick(frame, 1) 
		 end
	end
			
end

if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
