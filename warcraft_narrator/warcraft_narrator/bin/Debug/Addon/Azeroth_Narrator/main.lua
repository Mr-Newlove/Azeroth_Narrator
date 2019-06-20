--message('<Azeroth Narrator>\r\nThank you for installing this addon, please make sure the companion application is running.')
--ForceGossip = function() return true end

ChatFrame1:AddMessage("Thank you for installing Azeroth Narrator, please make sure our companion app is running on your PC.")

local x = 600
local y = 1
local counter = 0;


local byte_pixel = {}
for i = 0, x*y-1 do
	byte_pixel[i+1] = CreateFrame("Frame", "narrator_frame", UIParent)
	byte_pixel[i+1]:SetSize(1,1);
	byte_pixel[i+1]:SetPoint("TOPLEFT", (i % x), (-1 * math.floor(i/x)));
	byte_pixel[i+1].texture = byte_pixel[i+1]:CreateTexture(nil, "OVERLAY")
	byte_pixel[i+1].texture:SetAllPoints(true)
	byte_pixel[i+1].texture:SetColorTexture(0, 0, 0, 1)
end


function set_byte(i,v)
	v = v - 30;
	byte_pixel[i].texture:SetColorTexture(v/100, v/100, v/100, 1)
end
function set_byte_3(i,v1,v2,v3)
	v1 = v1 - 30;
	v2 = v2 - 30;
	v3 = v3 - 30;
	byte_pixel[i].texture:SetColorTexture(v1/100, v2/100, v3/100, 1)
end


function string_out(str,ln)
	for i = 0, x*y-1 do
		byte_pixel[i+1].texture:SetColorTexture(0, 0, 0, 1)
	end
	for i = 1, x*y do
		set_byte_3(i,0,0,0)	
	end
	--ChatFrame1:AddMessage(strlen(str))
	str = str:gsub("\n"," ")
	str = str:gsub("\r"," ")
	str = str:gsub("\r\n"," ")
	local out_str = ""
	for i = 1, strlen(str) do
		local c = string.sub(str,i,i)
		if (strlen(string.trim(c)) == 0) then
				out_str = out_str .. " "
		else
			out_str = out_str .. c
		end
	end
	out_str = out_str:gsub("  "," ")
	out_str = out_str:gsub("  "," ")
	out_str = out_str:gsub("  "," ")
	
	out_str = "WoW(" .. tostring(counter) .. "){" .. out_str .. "}"
	--ChatFrame1:AddMessage(out_str)
	counter = counter + 1
	for i = 1, strlen(out_str) do
		if ((i-1)%3 == 0) then
			local c1 = string.sub(out_str,i,i)
			local c2 = string.sub(out_str,i+1,i+1)
			local c3 = string.sub(out_str,i+2,i+2)
			if (string.byte(c1) == nil) then c1 = " " end
			if (string.byte(c2) == nil) then c2 = " " end
			if (string.byte(c3) == nil) then c3 = " " end
			set_byte_3(((i-1)/3)+1,string.byte(c1),string.byte(c2),string.byte(c3))
			--ChatFrame1:AddMessage("\"" .. c1 .. c2 .. c3 .. "\"")
		end

	end
end


local fq = CreateFrame("Frame")
fq:SetScript("OnEvent",function(self,event)
  
	ChatFrame1:AddMessage("Quest Text: ")
	string_out(GetQuestText() .. " " .. GetObjectiveText(),0)
end)
fq:RegisterEvent("QUEST_DETAIL")

local fc = CreateFrame("Frame")
fc:SetScript("OnEvent",function(self,event)
  
	ChatFrame1:AddMessage("Quest Turnin: ")
	string_out(GetRewardText(),0)
end)
fc:RegisterEvent("QUEST_COMPLETE")
---fq:RegisterEvent("QUEST_PROGRESS")

local fd = CreateFrame("Frame")
fd:SetScript("OnEvent",function(self,event)
	string_out(GetGossipText(),0)
end)
fd:RegisterEvent("GOSSIP_SHOW")