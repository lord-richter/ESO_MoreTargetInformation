-- ESO MoreTargetInformation

-- This Add-on is not created by, affiliated with or sponsored by ZeniMax Media Inc. or its affiliates. 
-- The Elder Scrolls® and related logos are registered trademarks or trademarks of ZeniMax Media Inc. in the United States and/or other countries. 
-- All rights reserved

----------------------------------------------------------------------------------------------------------------------------------------
local AddonInfo = {
  addon = "MoreTargetInformation",
  version = "3.39",
  author = "Lord Richter",
  savename = "MoreTargetInformation"
}

local MTI = {}

-- define some colors for commonality
local white={r=1,g=1, b=1}
local darkcyan={r=0,g=0.8,b=0.8}
local cyan={r=0,g=1,b=1}
local darkred={r=0.5,g=0,b=0}
local red={r=1,g=0,b=0}
local pink={r=1,g=0.7,b=0.8}
local babyblue={r=0.45,g=0.75,b=0.93}
local darkblue={r=0,g=0,b=0.7}
local blue={r=0,g=0.25,b=1}
local purple={r=1,g=0,b=1}
local gold={r=1,g=0.8,b=0}
local yellow={r=1,g=1,b=0}
local gray={r=0.5,g=0.5,b=0.5}
local green={r=0,g=0.7,b=0}
local aquamarine={r=0.5,g=1,b=0.7}

local gender = { "Female" , "Male" }


MTI.textcolor = white
MTI.namecolor = white
MTI.captioncolor = white
MTI.targetuniquename = ""
MTI.topline = ""
MTI.bottomline = ""
MTI.level = ""
MTI.champrank = ""
MTI.title = ""
MTI.type = 0
MTI.updated = 0
MTI.reaction = 0
MTI.debugstring = ""

-- debug
MTI.announceguard = false
MTI.guard = false

MTI.zo_nameplate = {}
MTI.zo_caption = {}
MTI.guild = {}
MTI.alliance = {}


-- localize calls to ESO API
local GetUniqueNameForCharacter = GetUniqueNameForCharacter
local GetUnitType = GetUnitType
local GetUnitName = GetUnitName
local GetUnitReaction = GetUnitReaction
local GetUnitLevel = GetUnitLevel
local GetMapName = GetMapName
local GetUnitZone = GetUnitZone
local GetUnitTitle = GetUnitTitle
local GetUnitRace = GetUnitRace
local GetUnitClass = GetUnitClass
local GetUnitGender = GetUnitGender 
local GetUnitChampionPoints = GetUnitChampionPoints
local GetUnitAvARank = GetUnitAvARank
local GetAvARankName = GetAvARankName
local GetUnitAlliance = GetUnitAlliance
local GetAllianceName = GetAllianceName 
local GetUnitCaption = GetUnitCaption
local GetGuildMemberInfo = GetGuildMemberInfo
local GetGuildMemberCharacterInfo = GetGuildMemberCharacterInfo
local GetGuildId = GetGuildId
local GetGuildName = GetGuildName
local GetNumGuildMembers = GetNumGuildMembers
local IsUnitIgnored = IsUnitIgnored
local IsUnitFriend = IsUnitFriend

local ICON_SIZE = 24
local CHARACTER_NAME_ICON = "/esoui/art/miscellaneous/gamepad/gp_charnameicon.dds"
local FRIEND_ICON_TEXTURE = "/esoui/art/campaign/campaignbrowser_friends.dds"
local GUILD_ICON_TEXTURE = "/esoui/art/campaign/campaignbrowser_guild.dds"
local IGNORE_ICON_TEXTURE = "/esoui/art/contacts/tabicon_ignored_up.dds"
local LEADER_ICON_TEXTURE = "/esoui/art/unitframes/groupicon_leader.dds"
local GROUP_LEADER_ICON = "/esoui/art/icons/mapkey/mapkey_groupleader.dds"
local GROUP_MEMBER_ICON = "/esoui/art/icons/mapkey/mapkey_groupmember.dds"
local RACE_ALTMER_ICON = "/esoui/art/charactercreate/charactercreate_altmericon_down.dds"
local RACE_ARGONIAN_ICON = "/esoui/art/charactercreate/charactercreate_argonianicon_down.dds"
local RACE_BOSMER_ICON = "/esoui/art/charactercreate/charactercreate_bosmericon_down.dds"
local RACE_BRETON_ICON = "/esoui/art/charactercreate/charactercreate_bretonicon_down.dds"
local RACE_DUNMER_ICON = "/esoui/art/charactercreate/charactercreate_dunmericon_down.dds"
local RACE_IMPERIAL_ICON = "/esoui/art/charactercreate/charactercreate_imperialicon_down.dds"
local RACE_KHAJIIT_ICON = "/esoui/art/charactercreate/charactercreate_khajiiticon_down.dds"
local RACE_NORD_ICON = "/esoui/art/charactercreate/charactercreate_nordicon_down.dds"
local RACE_ORC_ICON = "/esoui/art/charactercreate/charactercreate_orcicon_down.dds"
local RACE_REDGUARD_ICON =  "/esoui/art/charactercreate/charactercreate_redguardicon_down.dds"
local RACE_ICONS = { RACE_BRETON_ICON, RACE_REDGUARD_ICON, RACE_ORC_ICON, RACE_DUNMER_ICON, RACE_NORD_ICON, RACE_ARGONIAN_ICON, RACE_ALTMER_ICON, RACE_BOSMER_ICON, RACE_KHAJIIT_ICON, RACE_IMPERIAL_ICON }

-- ESO 2.4 top line:  (CHAMPIONICON) (LEVEL) (NAME) (RANKICON)
--	  bottom line:  (CAPTION)

local GUARD_ANNOUNCE_SOUND = SOUNDS.JUSTICE_STATE_CHANGED
local guardnotification = false

-- ----------------------------------------------------------------------------------------------------------------------

function ZO_GetPrimaryPlayerNameWithSecondary(displayName, characterName)
	local primaryName = ZO_GetPrimaryPlayerName(displayName, characterName, true)
	return primaryName
end

-- ----------------------------------------------------------------------------------------------------------------------
function MTIUpdate()
	if MTI.updated == 1 then
		MTI.updated = 0
		if (MTI.type==UNIT_TYPE_PLAYER) then
			ZO_TargetUnitFramereticleoverName:SetColor(MTI.namecolor["r"],MTI.namecolor["g"],MTI.namecolor["b"],1)
			ZO_TargetUnitFramereticleoverName:SetText(MTI.topline)
			ZO_TargetUnitFramereticleoverLevel:SetHidden(false)
			ZO_TargetUnitFramereticleoverLevel:SetColor(MTI.textcolor["r"],MTI.textcolor["g"],MTI.textcolor["b"],1)
			ZO_TargetUnitFramereticleoverLevel:SetText(MTI.level)
			ZO_TargetUnitFramereticleoverCaption:SetHidden(false)
			ZO_TargetUnitFramereticleoverCaption:SetColor(MTI.captioncolor["r"],MTI.captioncolor["g"],MTI.captioncolor["b"],1)
			ZO_TargetUnitFramereticleoverCaption:SetText(MTI.bottomline)
		elseif (MTI.type==UNIT_TYPE_MONSTER) then 
			ZO_TargetUnitFramereticleoverName:SetColor(MTI.namecolor["r"],MTI.namecolor["g"],MTI.namecolor["b"],1)
			ZO_TargetUnitFramereticleoverName:SetText(MTI.topline)
			if (string.len(MTI.bottomline)>0) then
				ZO_TargetUnitFramereticleoverCaption:SetHidden(false)
				ZO_TargetUnitFramereticleoverCaption:SetColor(MTI.captioncolor["r"],MTI.captioncolor["g"],MTI.captioncolor["b"],1)
				ZO_TargetUnitFramereticleoverCaption:SetText(MTI.bottomline)
			end
		end
		
		if MTI.guard and MTI.announceguard and GetFullBountyPayoffAmount()>0 and guardnotification then
			guardnotification = false
			PlaySound( GUARD_ANNOUNCE_SOUND )
		end
	end
end

-- ----------------------------------------------------------------------------------------------------------------------
local function initializeTable(template)
  local t2 = {}
  local k,v
  for k,v in pairs(template) do
	t2[k] = v
  end
  return t2 
end

-- ----------------------------------------------------------------------------------------------------------------------
local function clearGuildTable()
	local index
	for index in pairs (MTI.guild.member) do
		MTI.guild.member[index].character = nil
		MTI.guild.member[index].firstguild = { size = 0, name="" }
		MTI.guild.member[index].size = { }
		MTI.guild.member[index].guildlist = nil
		MTI.guild.member[index].guild = nil
		MTI.guild.member[index] = false
	end
end

-- ----------------------------------------------------------------------------------------------------------------------
local function getGuildMembership()
	
	local guildnum = 0
		
	MTI.guild = {}
	MTI.guild.member = {}
	
	for guildnum = 1,5,1 do
		local id = GetGuildId(guildnum)
		
		if id then 
			local members = GetNumGuildMembers(id)
			local guildname = GetGuildName(id)
		
			-- update character history based on the member information
			local member = 0
			
			for member = 1,members,1 do
				local player, note, rank, status, activelast = GetGuildMemberInfo(id,member)
				local hasCharacter, characterName, zoneName, classid, alliance, level, championRank = GetGuildMemberCharacterInfo(id,member)

				if hasCharacter and members>1 then
					local caret = string.len(characterName) - 3
					local character = ""
					if caret>0 then
						character = string.sub(characterName,1,caret)
					end
					-- add player in database
					MTI.guild.member[player]={}
					MTI.guild.member[player].character = character
					MTI.guild.member[player].firstguild = MTI.guild.member[player].firstguild or { size = 0, name = "" }
					if MTI.guild.member[player].firstguild.size<members then
						MTI.guild.member[player].firstguild.name = guildname
						MTI.guild.member[player].firstguild.size = members
					end			
				end
			end
		end
	end
end   

-- ----------------------------------------------------------------------------------------------------------------------
local function guildMemberAdded(eventCode, guildId, displayName)
	clearGuildTable()
	getGuildMembership()
end 

-- ----------------------------------------------------------------------------------------------------------------------
local function guildMemberRemoved(eventCode, guildId, displayName, characterName)
	clearGuildTable()
	getGuildMembership()
end   
   
 -- ----------------------------------------------------------------------------------------------------------------------
local function guildSelfLeft(eventCode, guildId, guildName)
	clearGuildTable()
	getGuildMembership()
end   

-- ----------------------------------------------------------------------------------------------------------------------
local function guildSelfJoined(eventCode, guildId, guildName)
	clearGuildTable()
	getGuildMembership()
end 

-- ----------------------------------------------------------------------------------------------------------------------
local function IsUnitGuild(player)
	local guild = nil
	local maxrank = 0
	local inguild = player and MTI and MTI.guild and MTI.guild.member and MTI.guild.member[player]
	if inguild then
		guild = MTI.guild.member[player].firstguild.name
	end
	
	return inguild, guild
end

-- ----------------------------------------------------------------------------------------------------------------------   

local function getNamesWithClassRace(unitTag)
	local usename = tonumber(GetSetting(SETTING_TYPE_UI, IsInGamepadPreferredMode() and UI_SETTING_PRIMARY_PLAYER_NAME_GAMEPAD or UI_SETTING_PRIMARY_PLAYER_NAME_KEYBOARD)) == PRIMARY_PLAYER_NAME_SETTING_PREFER_CHARACTER
	local character = GetUnitName(unitTag)
	local userid = GetUnitDisplayName(unitTag)

end

-- ----------------------------------------------------------------------------------------------------------------------   
-- this fires when the target changes, then sets everything up for the next UI update   
function OnTargetChange(eventCode)
	local unitTag = "reticleover"
	local type = GetUnitType(unitTag)
	local name = GetUnitName(unitTag)
	local player = GetUnitDisplayName(unitTag)
	
	MTI.prefernamesetting = tonumber(GetSetting(SETTING_TYPE_UI,((not IsInGamepadPreferredMode()) and UI_SETTING_PRIMARY_PLAYER_NAME_KEYBOARD) or UI_SETTING_PRIMARY_PLAYER_NAME_GAMEPAD)) == PRIMARY_PLAYER_NAME_SETTING_PREFER_CHARACTER
	MTI.captioncolor = white
	
	-- catch instances where there is no longer anything to look at
	if name == nil or name == "" then 
		MTI.topline = ""
		MTI.type = 0
		MTI.updated = 1
		return
	end

	MTI.reaction = GetUnitReaction(unitTag);
	MTI.type = type
	
	-- NPCs are type 2, Players are type 1
	if type == UNIT_TYPE_PLAYER then
		MTI.namecolor = white
		local genderstr = "Genderless"	
		local gendernum = GetUnitGender(unitTag)
		if gendernum>0 and gendernum<3 then
			genderstr = gender[gendernum]
		end

	  
	local inguild, guild = IsUnitGuild(player) 
	  
	MTI.level = "Level " .. GetUnitLevel(unitTag)
	   
	local rank = GetUnitChampionPoints(unitTag)
	MTI.champrank = rank
	 
	if rank>0 then
		MTI.level = MTI.champrank
	end

	MTI.title = GetUnitTitle(unitTag)
	  
	local classname = GetUnitClass(unitTag)
    local classicon = GetPlatformClassIcon(GetUnitClassId(unitTag))	
	local racename = GetUnitRace(unitTag)
    local raceicon = RACE_ICONS[(GetUnitRaceId(unitTag))]
	local raceclass = GetUnitRace(unitTag) .. " " .. zo_iconFormat(classicon,ICON_SIZE,ICON_SIZE) .. " " .. GetUnitClass(unitTag)
	  
	local avarank = GetUnitAvARank(unitTag)
	local avarankname = GetAvARankName(gendernum,avarank)
	local alliance = GetUnitAlliance(unitTag)
	local alliancename = ""
	local allianceicon = ""

	if alliance>0 then
		alliancename = alliancename ..GetAllianceName(alliance) .. " "
		local allianceiconname = GetAllianceSymbolIcon(alliance)
		allianceicon = zo_iconFormat(allianceiconname,ICON_SIZE,ICON_SIZE)
	end
		
		
	local nameicon = "" --MTI.playericon
	--local primary = ZO_GetPrimaryPlayerNameFromUnitTag(unitTag, true)
	--local secondary = ZO_GetSecondaryPlayerNameFromUnitTag(unitTag, true)
	local primary = name
	local secondary = GetUnitDisplayName(unitTag)
	local guildname = ""
	  
	if IsUnitIgnored(unitTag) then
		nameicon = MTI.ignoreicon
	   	MTI.namecolor = pink
	   	MTI.topline = zo_strformat("<<1>><<2>> (<<3>>) ",nameicon,primary,secondary)
	   	MTI.bottomline = ""
	else
		MTI.namecolor = darkcyan
		MTI.captioncolor = white

	  	if inguild then
	  		nameicon = MTI.guildicon
	  		guildname = "<"..guild..">"
	  		MTI.captioncolor = green
	  	end
	  
	  	if IsUnitFriend(unitTag) then
	  		MTI.namecolor = cyan
	  		nameicon = MTI.friendicon
	  	end
	  	
		if IsUnitGrouped(unitTag) then
			MTI.namecolor = babyblue
			if IsUnitGroupLeader(unitTag) then nameicon = MTI.groupleadericon
			else nameicon = MTI.groupmembericon
			end
		end
	  	
  		if MTI.prefernamesetting then
  			if MTI.title ~= "" then
  				MTI.topline = zo_strformat("<<1>><<2>>, <<3>> ",nameicon,primary,MTI.title)
  			else
  				MTI.topline = zo_strformat("<<1>><<2>> ",nameicon,primary)
  			end
  				MTI.bottomline = zo_strformat("<<1>> <<2>>",raceclass,guildname)
  			else
  				if MTI.title ~= "" then
  					MTI.topline = zo_strformat("<<1>><<2>>, <<3>> ",nameicon,primary,MTI.title)
  				else
  					MTI.topline = zo_strformat("<<1>><<2>> ",nameicon,primary)
  				end
  				MTI.bottomline = zo_strformat("(<<1>>) <<2>> <<3>>",secondary,raceclass,guildname)
  			end
	  end
	elseif type == UNIT_TYPE_MONSTER then
		MTI.namecolor = white
		-- just the name for now	   
		MTI.topline = name
		MTI.bottomline = ""
		MTI.guard = IsUnitInvulnerableGuard(unitTag) or IsUnitJusticeGuard(unitTag)
		guardnotification = MTI.guard
		
		MTI.level = "Level " .. GetUnitLevel(unitTag)
		local rank = GetUnitChampionPoints(unitTag)
		MTI.champrank = rank
	  
		if rank>0 then
	  	MTI.level = MTI.champrank
	end
	  
		-- shopkeepers and other non-combat units just show name
   		if MTI.reaction == UNIT_REACTION_NEUTRAL then
   		  MTI.level = ""
   			MTI.namecolor = yellow
   		elseif MTI.reaction == UNIT_REACTION_HOSTILE then
   		  MTI.level = ""
   			MTI.namecolor = red
   		elseif MTI.reaction == UNIT_REACTION_DEAD then
   		  MTI.level = ""
   			MTI.namecolor = gray
		--elseif MTI.reaction == UNIT_REACTION_COMPANION then
		elseif MTI.reaction == 6 then
			nameicon = MTI.friendicon
			MTI.namecolor = babyblue
			MTI.topline = zo_strformat("<<1>><<2>> ",nameicon,name)
			MTI.bottomline = MTI.level .. " Companion"
		else
			MTI.level = ""
			MTI.namecolor = green   	
		end
	else 
		MTI.topline = name
  	end
  	MTI.updated = 1
end

-- ----------------------------------------------------------------------------------------------------------------------
local function LoadAddon(eventCode, addOnName)
	
	if(addOnName == AddonInfo.addon) then
		getGuildMembership()
		MTI.ignoreicon=""
		if zo_iconFormat(IGNORE_ICON_TEXTURE,ICON_SIZE,ICON_SIZE) then
			MTI.ignoreicon = zo_iconFormat(IGNORE_ICON_TEXTURE,ICON_SIZE,ICON_SIZE)
		end

		MTI.friendicon=""	
		if zo_iconFormat(FRIEND_ICON_TEXTURE,ICON_SIZE,ICON_SIZE) then
			MTI.friendicon = zo_iconFormat(FRIEND_ICON_TEXTURE,ICON_SIZE,ICON_SIZE)
		end
		
		MTI.guildicon=""	
		if zo_iconFormat(GUILD_ICON_TEXTURE,ICON_SIZE,ICON_SIZE) then
			MTI.guildicon = zo_iconFormat(GUILD_ICON_TEXTURE,ICON_SIZE,ICON_SIZE)
		end		
		
		MTI.playericon=""	
		if zo_iconFormat(CHARACTER_NAME_ICON,ICON_SIZE,ICON_SIZE) then
			MTI.playericon = zo_iconFormat(CHARACTER_NAME_ICON,ICON_SIZE,ICON_SIZE)
		end		

		MTI.groupleadericon=""	
		if zo_iconFormat(GROUP_LEADER_ICON,ICON_SIZE,ICON_SIZE) then
			MTI.groupleadericon = zo_iconFormat(GROUP_LEADER_ICON,ICON_SIZE,ICON_SIZE)
		end		

		MTI.groupmembericon=""	
		if zo_iconFormat(GROUP_MEMBER_ICON,ICON_SIZE,ICON_SIZE) then
			MTI.groupmembericon = zo_iconFormat(GROUP_MEMBER_ICON,ICON_SIZE,ICON_SIZE)
		end	

	    if (LibNorthCastle) then LibNorthCastle:Register(AddonInfo.addon,AddonInfo.version) end
		
		EVENT_MANAGER:RegisterForEvent(AddonInfo.addon, EVENT_GUILD_MEMBER_CHARACTER_UPDATED, guildMemberAdded)
		EVENT_MANAGER:RegisterForEvent(AddonInfo.addon, EVENT_GUILD_MEMBER_ADDED, guildMemberAdded)
		EVENT_MANAGER:RegisterForEvent(AddonInfo.addon, EVENT_GUILD_MEMBER_REMOVED, guildMemberRemoved)
		EVENT_MANAGER:RegisterForEvent(AddonInfo.addon, EVENT_GUILD_SELF_JOINED_GUILD, guildSelfJoined)
		EVENT_MANAGER:RegisterForEvent(AddonInfo.addon, EVENT_GUILD_SELF_LEFT_GUILD, guildSelfLeft) 
		EVENT_MANAGER:RegisterForEvent(AddonInfo.addon, EVENT_RETICLE_TARGET_CHANGED, OnTargetChange)
		EVENT_MANAGER:UnregisterForEvent(AddonInfo.addon, EVENT_ADD_ON_LOADED)
	end
	
end
   
-- ----------------------------------------------------------------------------------------------------------------------

EVENT_MANAGER:RegisterForEvent(AddonInfo.addon, EVENT_ADD_ON_LOADED, LoadAddon)
