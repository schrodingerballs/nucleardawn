public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "03/17/2016",
	time = "18:31:03"
};
new Float:NULL_VECTOR[3];
new String:NULL_STRING[4];
public Extension:__ext_core =
{
	name = "Core",
	file = "core",
	autoload = 0,
	required = 0,
};
new MaxClients;
public Extension:__ext_sdktools =
{
	name = "SDKTools",
	file = "sdktools.ext",
	autoload = 1,
	required = 1,
};
public SharedPlugin:__pl_sourcecomms =
{
	name = "sourcecomms",
	file = "sourcecomms.smx",
	required = 1,
};
public Extension:__ext_topmenus =
{
	name = "TopMenus",
	file = "topmenus.ext",
	autoload = 1,
	required = 0,
};
public SharedPlugin:__pl_adminmenu =
{
	name = "adminmenu",
	file = "adminmenu.smx",
	required = 0,
};
new ConVar:g_Cvar_Limits;
new ConVar:g_Cvar_Admins;
new ConVar:g_Cvar_Duration;
new Handle:g_hVoteMenu;
new g_voteClient[2];
new String:g_voteInfo[3][68];
new g_votetype;
public Plugin:myinfo =
{
	name = "Vote Gag, Mute, Silence",
	description = "Allows vote gag, mute and silencing for sourcecomms",
	author = "<eVa>Dog, Stickz",
	version = "f96fca4",
	url = "http://www.theville.org"
};
public SharedPlugin:__pl_updater =
{
	name = "updater",
	file = "updater.smx",
	required = 0,
};
public __ext_core_SetNTVOptional()
{
	MarkNativeAsOptional("GetFeatureStatus");
	MarkNativeAsOptional("RequireFeature");
	MarkNativeAsOptional("AddCommandListener");
	MarkNativeAsOptional("RemoveCommandListener");
	MarkNativeAsOptional("BfWriteBool");
	MarkNativeAsOptional("BfWriteByte");
	MarkNativeAsOptional("BfWriteChar");
	MarkNativeAsOptional("BfWriteShort");
	MarkNativeAsOptional("BfWriteWord");
	MarkNativeAsOptional("BfWriteNum");
	MarkNativeAsOptional("BfWriteFloat");
	MarkNativeAsOptional("BfWriteString");
	MarkNativeAsOptional("BfWriteEntity");
	MarkNativeAsOptional("BfWriteAngle");
	MarkNativeAsOptional("BfWriteCoord");
	MarkNativeAsOptional("BfWriteVecCoord");
	MarkNativeAsOptional("BfWriteVecNormal");
	MarkNativeAsOptional("BfWriteAngles");
	MarkNativeAsOptional("BfReadBool");
	MarkNativeAsOptional("BfReadByte");
	MarkNativeAsOptional("BfReadChar");
	MarkNativeAsOptional("BfReadShort");
	MarkNativeAsOptional("BfReadWord");
	MarkNativeAsOptional("BfReadNum");
	MarkNativeAsOptional("BfReadFloat");
	MarkNativeAsOptional("BfReadString");
	MarkNativeAsOptional("BfReadEntity");
	MarkNativeAsOptional("BfReadAngle");
	MarkNativeAsOptional("BfReadCoord");
	MarkNativeAsOptional("BfReadVecCoord");
	MarkNativeAsOptional("BfReadVecNormal");
	MarkNativeAsOptional("BfReadAngles");
	MarkNativeAsOptional("BfGetNumBytesLeft");
	MarkNativeAsOptional("BfWrite.WriteBool");
	MarkNativeAsOptional("BfWrite.WriteByte");
	MarkNativeAsOptional("BfWrite.WriteChar");
	MarkNativeAsOptional("BfWrite.WriteShort");
	MarkNativeAsOptional("BfWrite.WriteWord");
	MarkNativeAsOptional("BfWrite.WriteNum");
	MarkNativeAsOptional("BfWrite.WriteFloat");
	MarkNativeAsOptional("BfWrite.WriteString");
	MarkNativeAsOptional("BfWrite.WriteEntity");
	MarkNativeAsOptional("BfWrite.WriteAngle");
	MarkNativeAsOptional("BfWrite.WriteCoord");
	MarkNativeAsOptional("BfWrite.WriteVecCoord");
	MarkNativeAsOptional("BfWrite.WriteVecNormal");
	MarkNativeAsOptional("BfWrite.WriteAngles");
	MarkNativeAsOptional("BfRead.ReadBool");
	MarkNativeAsOptional("BfRead.ReadByte");
	MarkNativeAsOptional("BfRead.ReadChar");
	MarkNativeAsOptional("BfRead.ReadShort");
	MarkNativeAsOptional("BfRead.ReadWord");
	MarkNativeAsOptional("BfRead.ReadNum");
	MarkNativeAsOptional("BfRead.ReadFloat");
	MarkNativeAsOptional("BfRead.ReadString");
	MarkNativeAsOptional("BfRead.ReadEntity");
	MarkNativeAsOptional("BfRead.ReadAngle");
	MarkNativeAsOptional("BfRead.ReadCoord");
	MarkNativeAsOptional("BfRead.ReadVecCoord");
	MarkNativeAsOptional("BfRead.ReadVecNormal");
	MarkNativeAsOptional("BfRead.ReadAngles");
	MarkNativeAsOptional("BfRead.GetNumBytesLeft");
	MarkNativeAsOptional("PbReadInt");
	MarkNativeAsOptional("PbReadFloat");
	MarkNativeAsOptional("PbReadBool");
	MarkNativeAsOptional("PbReadString");
	MarkNativeAsOptional("PbReadColor");
	MarkNativeAsOptional("PbReadAngle");
	MarkNativeAsOptional("PbReadVector");
	MarkNativeAsOptional("PbReadVector2D");
	MarkNativeAsOptional("PbGetRepeatedFieldCount");
	MarkNativeAsOptional("PbSetInt");
	MarkNativeAsOptional("PbSetFloat");
	MarkNativeAsOptional("PbSetBool");
	MarkNativeAsOptional("PbSetString");
	MarkNativeAsOptional("PbSetColor");
	MarkNativeAsOptional("PbSetAngle");
	MarkNativeAsOptional("PbSetVector");
	MarkNativeAsOptional("PbSetVector2D");
	MarkNativeAsOptional("PbAddInt");
	MarkNativeAsOptional("PbAddFloat");
	MarkNativeAsOptional("PbAddBool");
	MarkNativeAsOptional("PbAddString");
	MarkNativeAsOptional("PbAddColor");
	MarkNativeAsOptional("PbAddAngle");
	MarkNativeAsOptional("PbAddVector");
	MarkNativeAsOptional("PbAddVector2D");
	MarkNativeAsOptional("PbRemoveRepeatedFieldValue");
	MarkNativeAsOptional("PbReadMessage");
	MarkNativeAsOptional("PbReadRepeatedMessage");
	MarkNativeAsOptional("PbAddMessage");
	MarkNativeAsOptional("Protobuf.ReadInt");
	MarkNativeAsOptional("Protobuf.ReadFloat");
	MarkNativeAsOptional("Protobuf.ReadBool");
	MarkNativeAsOptional("Protobuf.ReadString");
	MarkNativeAsOptional("Protobuf.ReadColor");
	MarkNativeAsOptional("Protobuf.ReadAngle");
	MarkNativeAsOptional("Protobuf.ReadVector");
	MarkNativeAsOptional("Protobuf.ReadVector2D");
	MarkNativeAsOptional("Protobuf.GetRepeatedFieldCount");
	MarkNativeAsOptional("Protobuf.SetInt");
	MarkNativeAsOptional("Protobuf.SetFloat");
	MarkNativeAsOptional("Protobuf.SetBool");
	MarkNativeAsOptional("Protobuf.SetString");
	MarkNativeAsOptional("Protobuf.SetColor");
	MarkNativeAsOptional("Protobuf.SetAngle");
	MarkNativeAsOptional("Protobuf.SetVector");
	MarkNativeAsOptional("Protobuf.SetVector2D");
	MarkNativeAsOptional("Protobuf.AddInt");
	MarkNativeAsOptional("Protobuf.AddFloat");
	MarkNativeAsOptional("Protobuf.AddBool");
	MarkNativeAsOptional("Protobuf.AddString");
	MarkNativeAsOptional("Protobuf.AddColor");
	MarkNativeAsOptional("Protobuf.AddAngle");
	MarkNativeAsOptional("Protobuf.AddVector");
	MarkNativeAsOptional("Protobuf.AddVector2D");
	MarkNativeAsOptional("Protobuf.RemoveRepeatedFieldValue");
	MarkNativeAsOptional("Protobuf.ReadMessage");
	MarkNativeAsOptional("Protobuf.ReadRepeatedMessage");
	MarkNativeAsOptional("Protobuf.AddMessage");
	VerifyCoreVersion();
	return 0;
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

bool:VoteMenuToAll(Handle:menu, time, flags)
{
	new total;
	decl players[MaxClients];
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
		}
		else
		{
			total++;
			players[total] = i;
		}
		i++;
	}
	return VoteMenu(menu, players, total, time, flags);
}

void:GetMenuVoteInfo(param2, &winningVotes, &totalVotes)
{
	winningVotes = param2 & 65535;
	totalVotes = param2 >>> 16;
	return void:0;
}

PrintToChatAll(String:format[])
{
	decl String:buffer[192];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			SetGlobalTransTarget(i);
			VFormat(buffer, 192, format, 2);
			PrintToChat(i, "%s", buffer);
		}
		i++;
	}
	return 0;
}

ReplyToTargetError(client, reason)
{
	switch (reason)
	{
		case -7:
		{
			ReplyToCommand(client, "[SM] %t", "More than one client matched");
		}
		case -6:
		{
			ReplyToCommand(client, "[SM] %t", "Cannot target bot");
		}
		case -5:
		{
			ReplyToCommand(client, "[SM] %t", "No matching clients");
		}
		case -4:
		{
			ReplyToCommand(client, "[SM] %t", "Unable to target");
		}
		case -3:
		{
			ReplyToCommand(client, "[SM] %t", "Target is not in game");
		}
		case -2:
		{
			ReplyToCommand(client, "[SM] %t", "Target must be dead");
		}
		case -1:
		{
			ReplyToCommand(client, "[SM] %t", "Target must be alive");
		}
		case 0:
		{
			ReplyToCommand(client, "[SM] %t", "No matching client");
		}
		default:
		{
		}
	}
	return 0;
}

FindTarget(client, String:target[], bool:nobots, bool:immunity)
{
	decl String:target_name[64];
	decl target_list[1];
	decl target_count;
	decl bool:tn_is_ml;
	new flags = 16;
	if (nobots)
	{
		flags |= 32;
	}
	if (!immunity)
	{
		flags |= 8;
	}
	if (0 < (target_count = ProcessTargetString(target, client, target_list, 1, flags, target_name, 64, tn_is_ml)))
	{
		return target_list[0];
	}
	ReplyToTargetError(client, target_count);
	return -1;
}

public __pl_sourcecomms_SetNTVOptional()
{
	MarkNativeAsOptional("SourceComms_SetClientMute");
	MarkNativeAsOptional("SourceComms_SetClientGag");
	MarkNativeAsOptional("SourceComms_GetClientMuteType");
	MarkNativeAsOptional("SourceComms_GetClientGagType");
	return 0;
}

bool:IsValidClient(client, bool:nobots)
{
	new var2;
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
}

bool:IsValidAdmin(client, String:flags[])
{
	new ibFlags = ReadFlagString(flags, 0);
	new var1;
	return ibFlags != ibFlags & GetUserFlagBits(client) && GetUserFlagBits(client) & 16384;
}

PrintToAdmins(String:message[], String:flags[])
{
	new x = 1;
	while (x <= MaxClients)
	{
		new var1;
		if (IsValidClient(x, true) && IsValidAdmin(x, flags))
		{
			PrintToChat(x, message);
		}
		x++;
	}
	return 0;
}

public __ext_topmenus_SetNTVOptional()
{
	MarkNativeAsOptional("CreateTopMenu");
	MarkNativeAsOptional("LoadTopMenuConfig");
	MarkNativeAsOptional("AddToTopMenu");
	MarkNativeAsOptional("RemoveFromTopMenu");
	MarkNativeAsOptional("DisplayTopMenu");
	MarkNativeAsOptional("DisplayTopMenuCategory");
	MarkNativeAsOptional("FindTopMenuCategory");
	MarkNativeAsOptional("SetTopMenuTitleCaching");
	return 0;
}

public __pl_adminmenu_SetNTVOptional()
{
	MarkNativeAsOptional("GetAdminTopMenu");
	MarkNativeAsOptional("AddTargetsToMenu");
	MarkNativeAsOptional("AddTargetsToMenu2");
	return 0;
}

public __pl_updater_SetNTVOptional()
{
	MarkNativeAsOptional("Updater_AddPlugin");
	MarkNativeAsOptional("Updater_RemovePlugin");
	MarkNativeAsOptional("Updater_ForceUpdate");
	return 0;
}

public void:OnLibraryAdded(String:name[])
{
	if (StrEqual(name, "updater", true))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/votemute_p/votemute_p.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/votemute_p/votemute_p.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	g_Cvar_Limits = CreateConVar("sm_votemute_limit", "0.51", "percent required for successful mute vote or mute silence.", 0, false, 0.0, false, 0.0);
	g_Cvar_Admins = CreateConVar("sm_votemute_adminonly", "0", "1= admins only, 0 = regular players allowed", 0, false, 0.0, false, 0.0);
	g_Cvar_Duration = CreateConVar("sm_votemute_duration", "60", "set punishment duration, 0 = permanent", 0, false, 0.0, false, 0.0);
	AutoExecConfig(true, "votemute_p", "sourcemod");
	RegConsoleCmd("sm_votemute", Command_Votemute, "sm_votemute <player> ", 0);
	RegConsoleCmd("sm_votesilence", Command_Votesilence, "sm_votesilence <player> ", 0);
	RegConsoleCmd("sm_votegag", Command_Votegag, "sm_votegag <player> ", 0);
	LoadTranslations("common.phrases");
	LoadTranslations("votemute_p.phrases");
	AddUpdaterLibrary();
	return void:0;
}

public Action:Command_Votemute(client, args)
{
	if (!CanStartVote(client))
	{
		return Action:3;
	}
	if (args < 1)
	{
		g_votetype = 1;
		DisplayVoteTargetMenu(client);
	}
	else
	{
		decl String:arg[64];
		GetCmdArg(1, arg, 64);
		new target = FindTarget(client, arg, false, true);
		if (target == -1)
		{
			return Action:3;
		}
		if (SourceComms_GetClientMuteType(target))
		{
			PrintToChat(client, "\x05[xG] %t!", "Already Muted");
			return Action:3;
		}
		g_votetype = 1;
		DisplayVoteMuteMenu(client, target);
	}
	return Action:3;
}

public Action:Command_Votesilence(client, args)
{
	if (!CanStartVote(client))
	{
		return Action:3;
	}
	if (args < 1)
	{
		g_votetype = 2;
		DisplayVoteTargetMenu(client);
	}
	else
	{
		decl String:arg[64];
		GetCmdArg(1, arg, 1);
		new target = FindTarget(client, arg, false, true);
		if (target == -1)
		{
			return Action:3;
		}
		if (isSilenced(target))
		{
			PrintToChat(client, "\x05[xG] %t!", "Already Silenced");
			return Action:3;
		}
		g_votetype = 2;
		DisplayVoteMuteMenu(client, target);
	}
	return Action:3;
}

public Action:Command_Votegag(client, args)
{
	if (!CanStartVote(client))
	{
		return Action:3;
	}
	if (args < 1)
	{
		g_votetype = 0;
		DisplayVoteTargetMenu(client);
	}
	else
	{
		decl String:arg[64];
		GetCmdArg(1, arg, 64);
		new target = FindTarget(client, arg, false, true);
		if (target == -1)
		{
			return Action:3;
		}
		if (SourceComms_GetClientGagType(target))
		{
			PrintToChat(client, "\x05[xG] %t!", "Already Gagged");
			return Action:3;
		}
		g_votetype = 0;
		DisplayVoteMuteMenu(client, target);
	}
	return Action:3;
}

bool:CanStartVote(client)
{
	if (IsVoteInProgress(Handle:0))
	{
		PrintToChat(client, "\x05[xG] %t.", "Vote in Progress");
		return false;
	}
	new var1;
	if (ConVar.BoolValue.get(g_Cvar_Admins) && !IsValidAdmin(client, "k"))
	{
		PrintToChat(client, "\x05[xG] %t.", "Moderater Only");
		return false;
	}
	if (!TestVoteDelay(client))
	{
		return false;
	}
	if (isSilenced(client))
	{
		PrintToChat(client, "\x05[xG] %t!", "Silence Use");
		return false;
	}
	return true;
}

DisplayVoteMuteMenu(client, target)
{
	g_voteClient[0] = target;
	g_voteClient[1] = GetClientUserId(target);
	new var1 = g_voteInfo;
	GetClientName(target, var1[0][var1], 65);
	decl String:Name[8];
	switch (g_votetype)
	{
		case 0:
		{
			Format(Name, 8, "Gag");
		}
		case 1:
		{
			Format(Name, 8, "Mute");
		}
		case 2:
		{
			Format(Name, 8, "Silence");
		}
		default:
		{
		}
	}
	decl String:Message[64];
	Format(Message, 64, "\"%L\" initiated a %s vote against \"%L\"", client, Name, target);
	PrintToAdmins(Message, "a");
	LogAction(client, target, Message);
	g_hVoteMenu = CreateMenu(Handler_VoteCallback, MenuAction:-1);
	SetMenuTitle(g_hVoteMenu, "%s Player:", Name);
	AddMenuItem(g_hVoteMenu, "###yes###", "Yes", 0);
	AddMenuItem(g_hVoteMenu, "###no###", "No", 0);
	SetMenuExitButton(g_hVoteMenu, false);
	VoteMenuToAll(g_hVoteMenu, 20, 0);
	return 0;
}

DisplayVoteTargetMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandler_Vote, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%s", "Choose player:");
	SetMenuTitle(menu, title);
	SetMenuExitBackButton(menu, true);
	new String:playername[128];
	new String:identifier[64];
	new i = 1;
	while (GetMaxClients() > i)
	{
		new var1;
		if (IsClientInGame(i) && !GetUserFlagBits(i) & 512)
		{
			GetClientName(i, playername, 128);
			IntToString(i, identifier, 64);
			AddMenuItem(menu, identifier, playername, 0);
		}
		i++;
	}
	DisplayMenu(menu, client, 0);
	return 0;
}

public MenuHandler_Vote(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:info[32];
			decl String:name[32];
			GetMenuItem(menu, param2, info, 32, 0, name, 32);
			new target = StringToInt(info, 10);
			if (target)
			{
				DisplayVoteMuteMenu(param1, target);
			}
			else
			{
				PrintToChat(param1, "[SM] %s", "Player no longer available");
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

public Handler_VoteCallback(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 2:
		{
			decl String:title[64];
			GetMenuTitle(menu, title, 64);
			decl String:buffer[256];
			new var9 = g_voteInfo;
			Format(buffer, 255, "%s %s", title, var9[0][var9]);
			new Handle:panel = param2;
			SetPanelTitle(panel, buffer, false);
		}
		case 16:
		{
			VoteMenuClose();
		}
		case 32:
		{
			decl String:item[64];
			decl String:display[64];
			new Float:percent = 0.0;
			new Float:limit = 0.0;
			new votes;
			new totalVotes;
			GetMenuVoteInfo(param2, votes, totalVotes);
			GetMenuItem(menu, param1, item, 64, 0, display, 64);
			new var2;
			if (strcmp(item, "###no###", true) && param1 == 1)
			{
				votes = totalVotes - votes;
			}
			percent = GetVotePercent(votes, totalVotes);
			limit = ConVar.FloatValue.get(g_Cvar_Limits);
			new var3;
			if ((strcmp(item, "###yes###", true) && FloatCompare(percent, limit) < 0 && param1) || (strcmp(item, "###no###", true) && param1 == 1))
			{
				LogAction(-1, -1, "Vote failed.");
				PrintToChatAll("[SM] %s", "Vote Failed", RoundToNearest(limit * 100.0), RoundToNearest(percent * 100.0), totalVotes);
			}
			else
			{
				PrintToChatAll("[SM] %s", "Vote Successful", RoundToNearest(percent * 100.0), totalVotes);
				switch (g_votetype)
				{
					case 0:
					{
						new var8 = g_voteInfo;
						PrintToChatAll("[SM] %s", "Gagged target", "_s", var8[0][var8]);
						LogAction(-1, g_voteClient[0], "Vote gag successful, gagged \"%L\" ", g_voteClient);
						SourceComms_SetClientGag(g_voteClient[0], true, ConVar.IntValue.get(g_Cvar_Duration), true, "Voted by players");
					}
					case 1:
					{
						new var7 = g_voteInfo;
						PrintToChatAll("[SM] %s", "Muted target", "_s", var7[0][var7]);
						LogAction(-1, g_voteClient[0], "Vote mute successful, muted \"%L\" ", g_voteClient);
						SourceComms_SetClientMute(g_voteClient[0], true, ConVar.IntValue.get(g_Cvar_Duration), true, "Voted by players");
					}
					case 2:
					{
						new var6 = g_voteInfo;
						PrintToChatAll("[SM] %s", "Silenced target", "_s", var6[0][var6]);
						LogAction(-1, g_voteClient[0], "Vote silence successful, silenced \"%L\" ", g_voteClient);
						SourceComms_SetClientGag(g_voteClient[0], true, ConVar.IntValue.get(g_Cvar_Duration), true, "Voted by players");
						SourceComms_SetClientMute(g_voteClient[0], true, ConVar.IntValue.get(g_Cvar_Duration), true, "Voted by players");
					}
					default:
					{
					}
				}
			}
		}
		case 128:
		{
			if (param1 == -2)
			{
				PrintToChatAll("[SM] %s", "No Votes Cast");
			}
		}
		case 512:
		{
			decl String:display[64];
			GetMenuItem(menu, param2, "", 0, 0, display, 64);
			new var1;
			if (strcmp(display, "No", true) && strcmp(display, "Yes", true))
			{
				decl String:buffer[256];
				Format(buffer, 255, "%s", display);
				return RedrawMenuItem(buffer);
			}
		}
		default:
		{
		}
	}
	return 0;
}

bool:isSilenced(client)
{
	new var1;
	return SourceComms_GetClientMuteType(client) && SourceComms_GetClientGagType(client);
}

VoteMenuClose()
{
	CloseHandle(g_hVoteMenu);
	g_hVoteMenu = MissingTAG:0;
	return 0;
}

Float:GetVotePercent(votes, totalVotes)
{
	return float(votes) / float(totalVotes);
}

bool:TestVoteDelay(client)
{
	new delay = CheckVoteDelay();
	if (0 < delay)
	{
		PrintToChat(client, "\x05[xG] %t.", "Wait Seconds", delay);
		return false;
	}
	return true;
}

