public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "05:11:00"
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
public Extension:__ext_topmenus =
{
	name = "TopMenus",
	file = "topmenus.ext",
	autoload = 1,
	required = 1,
};
public SharedPlugin:__pl_adminmenu =
{
	name = "adminmenu",
	file = "adminmenu.smx",
	required = 1,
};
public Plugin:myinfo =
{
	name = "ND Commander Actions",
	description = "A rewrite of 1Swat's 'Commander Management' using keyvalues instead of SQL to save bans.",
	author = "Xander (Player 1)",
	version = "1.3",
	url = "https://forums.alliedmods.net/showthread.php?t=192858"
};
new Handle:hAdminMenu;
new g_CommanderBans[66] =
{
	-1, ...
};
new g_BanQueue[66];
new String:g_sKeyValuesPath[256];
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

public void:OnPluginStart()
{
	CreateConVar("sm_nd_commander_actions_version", "1.3", "ND Commander Actions", 8448, false, 0.0, false, 0.0);
	RegAdminCmd("sm_promote", Cmd_SetCommander, 32, "<Name|#UserID> - Promote a player to commander.", "", 0);
	RegAdminCmd("sm_forcedemote", Cmd_Demote, 32, "<ct | emp> - Remove a team's commander.", "", 0);
	RegAdminCmd("sm_bancommander", Cmd_BanCommander, 8, "<minutes> <Name|#UserID|SteamID> - Ban connected players from commanding.", "", 0);
	RegAdminCmd("sm_unbancommander", Cmd_UnBan, 8, "<Name|#UserID|SteamID> - Remove a SteamID from the ban list. (Unban by name only works on connected players.)", "", 0);
	RegAdminCmd("sm_listcommanderbans", Cmd_ListBans, 2, "Prints all commander bans in a list format.", "", 0);
	AddCommandListener(CMD_Apply, "applyforcommander");
	LoadTranslations("common.phrases");
	BuildPath(PathType:0, g_sKeyValuesPath, 256, "commanderbans.txt");
	if (!FileExists(g_sKeyValuesPath, false, "GAME"))
	{
		new Handle:fileHandle = OpenFile(g_sKeyValuesPath, "w", false, "GAME");
		CloseHandle(fileHandle);
	}
	new Handle:topmenu;
	new var1;
	if (LibraryExists("adminmenu") && (topmenu = GetAdminTopMenu()))
	{
		OnAdminMenuReady(topmenu);
	}
	return void:0;
}

public void:OnLibraryRemoved(String:name[])
{
	if (StrEqual(name, "adminmenu", true))
	{
		hAdminMenu = MissingTAG:0;
	}
	return void:0;
}

public OnAdminMenuReady(Handle:topmenu)
{
	if (hAdminMenu == topmenu)
	{
		return 0;
	}
	hAdminMenu = topmenu;
	new TopMenuObject:CMCategory = AddToTopMenu(topmenu, "Commander Actions", TopMenuObjectType:0, CategoryHandler, TopMenuObject:0, "", 0, "");
	AddToTopMenu(topmenu, "Set Commander", TopMenuObjectType:1, CMHandleSETCommander, CMCategory, "sm_setcommander", 32, "");
	AddToTopMenu(topmenu, "Demote Commander", TopMenuObjectType:1, CMHandleDEMOTECommander, CMCategory, "sm_demotecommander", 32, "");
	AddToTopMenu(topmenu, "Ban Commander", TopMenuObjectType:1, CMHandleBANCommander, CMCategory, "sm_bancommander", 8, "");
	AddToTopMenu(topmenu, "Unban Commander", TopMenuObjectType:1, CMHandleUNBANCommander, CMCategory, "sm_unbancommander", 8, "");
	return 0;
}

public Action:Cmd_SetCommander(client, args)
{
	if (!args)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setcommander <Name|#Userid>");
		return Action:3;
	}
	decl String:arg1[64];
	GetCmdArg(1, arg1, 64);
	new target = FindTarget(client, arg1, true, true);
	if (!(target == -1))
	{
		PerformPromote(client, target);
	}
	return Action:3;
}

public Action:Cmd_Demote(client, args)
{
	if (!args)
	{
		ReplyToCommand(client, "[SM] Usage: sm_demotecommander <ct | emp>");
		return Action:3;
	}
	new target = -1;
	decl String:arg1[64];
	GetCmdArg(1, arg1, 64);
	if (StrEqual(arg1, "ct", false))
	{
		target = GameRules_GetPropEnt("m_hCommanders", 0);
	}
	else
	{
		if (StrEqual(arg1, "emp", false))
		{
			target = GameRules_GetPropEnt("m_hCommanders", 1);
		}
		ReplyToCommand(client, "[SM] Unknown argument: %s. Usage: sm_demotecommander <ct | emp>", arg1);
		return Action:3;
	}
	if (target == -1)
	{
		ReplyToCommand(client, "[SM] No commander on team %s", arg1);
	}
	else
	{
		PerformDemote(client, target);
	}
	return Action:3;
}

public Action:Cmd_BanCommander(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_bancommander <Name|#Userid|SteamID>");
		return Action:3;
	}
	decl String:arg1[64];
	new target;
	GetCmdArg(1, arg1, 64);
	if (StrContains(arg1, "STEAM_1:", true) != -1)
	{
		StripQuotes(arg1);
		TrimString(arg1);
		target = -1;
	}
	else
	{
		target = FindTarget(client, arg1, true, true);
		if (target == -1)
		{
			return Action:3;
		}
		GetClientAuthId(target, AuthIdType:1, arg1, 64, true);
	}
	PerformCommanderBan(client, target, arg1);
	return Action:3;
}

public Action:Cmd_UnBan(client, args)
{
	if (!args)
	{
		ReplyToCommand(client, "Usage: sm_unbancommander <Name|#Userid|SteamID>");
		return Action:3;
	}
	decl String:arg1[64];
	new target;
	GetCmdArgString(arg1, 64);
	if (StrContains(arg1, "STEAM_1:0:", true) != -1)
	{
		StripQuotes(arg1);
		TrimString(arg1);
		target = -1;
	}
	else
	{
		target = FindTarget(client, arg1, true, true);
		if (target == -1)
		{
			return Action:3;
		}
		GetClientAuthId(target, AuthIdType:1, arg1, 64, true);
	}
	PerformUnban(client, target, arg1, GetCmdReplySource());
	return Action:3;
}

public Action:CMD_Apply(client, String:command[], args)
{
	if (!client)
	{
		return Action:3;
	}
	if (g_CommanderBans[client] == -1)
	{
		decl String:authid[32];
		GetClientAuthId(client, AuthIdType:1, authid, 32, true);
		new Handle:kv = CreateKeyValues("bans", "", "");
		FileToKeyValues(kv, g_sKeyValuesPath);
		if (KvJumpToKey(kv, authid, false))
		{
			new unbantime = KvGetNum(kv, "unbantime", -1);
			if (unbantime == -1)
			{
				g_CommanderBans[client] = 0;
			}
			else
			{
				g_CommanderBans[client] = unbantime;
			}
		}
		else
		{
			g_CommanderBans[client] = -2;
		}
		CloseHandle(kv);
	}
	if (g_CommanderBans[client] == -2)
	{
		return Action:0;
	}
	new var1;
	if (g_CommanderBans[client] && g_CommanderBans[client] > 0)
	{
		PrintToChat(client, "[SM] You are permanently banned from commanding.");
	}
	return Action:3;
}

PerformPromote(client, target)
{
	ServerCommand("_promote_to_commander %d", target);
	LogAction(client, target, "\"%L\" promoted \"%L\" to commander.", client, target);
	ShowActivity2(client, "[SM] ", "Promoted %N to commander.", target);
	return 0;
}

PerformDemote(client, target)
{
	if (target == -1)
	{
		return 0;
	}
	LogAction(client, target, "\"%L\" demoted \"%L\" from commander.", client, target);
	FakeClientCommand(target, "startmutiny");
	FakeClientCommand(target, "rtsview");
	ShowActivity2(client, "[SM] ", "Demoted %N from commander.", target);
	return 0;
}

PerformCommanderBan(client, target, String:authid[])
{
	new Handle:kv = CreateKeyValues("bans", "", "");
	FileToKeyValues(kv, g_sKeyValuesPath);
	KvJumpToKey(kv, authid, true);
	if (target != -1)
	{
		decl String:name[64];
		GetClientName(target, name, 64);
		KvSetString(kv, "name", name);
	}
	KvSetNum(kv, "unbantime", -1);
	KvRewind(kv);
	KeyValuesToFile(kv, g_sKeyValuesPath);
	CloseHandle(kv);
	if (target != -1)
	{
		new var1;
		if (GetClientTeam(target) > 1 && GameRules_GetPropEnt("m_hCommanders", GetClientTeam(target) + -2) == target)
		{
			FakeClientCommand(target, "startmutiny");
		}
		FakeClientCommand(target, "unapplyforcommander");
		g_CommanderBans[target] = 0;
		ShowActivity2(client, "[SM] ", "Permanently banned %N from commanding.", target);
		LogAction(client, target, "\"%L\" permanently banned \"%L\" from commanding.", client, target);
	}
	else
	{
		LogAction(client, -1, "\"%L\" banned identity <%s> from commanding.", client, authid);
		ShowActivity2(client, "[SM] ", "Added commander ban on identity <%s>", authid);
	}
	return 0;
}

PerformUnban(client, target, String:authid[], ReplySource:source)
{
	new Handle:kv = CreateKeyValues("bans", "", "");
	FileToKeyValues(kv, g_sKeyValuesPath);
	if (KvJumpToKey(kv, authid, false))
	{
		decl String:targetName[64];
		KvGetString(kv, "name", targetName, 64, "");
		KvDeleteThis(kv);
		KvRewind(kv);
		KeyValuesToFile(kv, g_sKeyValuesPath);
		ShowActivity2(client, "[SM] ", "Removed commander ban on %s <%s>", targetName, authid);
		LogAction(client, -1, "\"%L\" removed a commander ban on identity <%s> <%s>", client, targetName, authid);
		if (target != -1)
		{
			g_CommanderBans[target] = -2;
		}
	}
	else
	{
		source = SetCmdReplySource(source);
		ReplyToCommand(client, "No ban on SteamId: <%s>. (Unban by name only works on connected players.)", authid);
		SetCmdReplySource(source);
	}
	CloseHandle(kv);
	return 0;
}

public void:OnClientDisconnect(client)
{
	g_CommanderBans[client] = -1;
	return void:0;
}

public Action:Cmd_ListBans(client, args)
{
	new ReplySource:Source;
	if (client)
	{
		Source = SetCmdReplySource(ReplySource:0);
	}
	decl String:name[64];
	decl String:authid[64];
	decl String:FormatedTime[100];
	new Handle:kv = CreateKeyValues("bans", "", "");
	new UnbanTime;
	FileToKeyValues(kv, g_sKeyValuesPath);
	if (KvGotoFirstSubKey(kv, true))
	{
		ReplyToCommand(client, "** List of commander bans: **");
		ReplyToCommand(client, "SteamID -- Name -- Banned Until");
		ReplyToCommand(client, "");
		do {
			KvGetSectionName(kv, authid, 64);
			KvGetString(kv, "name", name, 64, "UNKNOWN");
			UnbanTime = KvGetNum(kv, "unbantime", -1);
			if (UnbanTime == -1)
			{
				Format(FormatedTime, 100, "Permanent");
			}
			else
			{
				FormatTime(FormatedTime, 100, "%d %b %Y - %X %Z", UnbanTime);
			}
			ReplyToCommand(client, "# %s    %s    %s", authid, name, FormatedTime);
		} while (KvGotoNextKey(kv, true));
		ReplyToCommand(client, "");
		ReplyToCommand(client, "** End Ban List **");
		new var1;
		if (client && Source == ReplySource:1)
		{
			PrintToChat(client, "[SM] See console for output.");
		}
	}
	else
	{
		SetCmdReplySource(Source);
		ReplyToCommand(client, "No Bans!");
	}
	CloseHandle(kv);
	return Action:3;
}

public CategoryHandler(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action == TopMenuAction:1)
	{
		Format(buffer, maxlength, "Commander Actions:");
	}
	else
	{
		if (!action)
		{
			Format(buffer, maxlength, "Commander Actions");
		}
	}
	return 0;
}

public CMHandleSETCommander(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			new Handle:menu = CreateMenu(Handle_SetCommander_SelectTeam, MenuAction:28);
			SetMenuTitle(menu, "Select a Team:");
			AddMenuItem(menu, "2", "Consortium", 0);
			AddMenuItem(menu, "3", "Empire", 0);
			DisplayMenu(menu, param, 0);
		}
	}
	else
	{
		Format(buffer, maxlength, "Set");
	}
	return 0;
}

public Handle_SetCommander_SelectTeam(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:4)
	{
		decl String:item[8];
		GetMenuItem(menu, param2, item, 8, 0, "", 0);
		Display_SetCommander_TeamList(param1, StringToInt(item, 10));
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

Display_SetCommander_TeamList(client, SelectedTeam)
{
	decl String:UserID[8];
	decl String:Name[64];
	new Handle:menu = CreateMenu(Handle_SetCommander_ClientSelection, MenuAction:28);
	SetMenuTitle(menu, "Select A Player:");
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			new var1;
			if (!IsFakeClient(i) && SelectedTeam == GetClientTeam(i) && CanUserTarget(client, i))
			{
				IntToString(GetClientUserId(i), UserID, 8);
				GetClientName(i, Name, 64);
				AddMenuItem(menu, UserID, Name, 0);
			}
		}
		i++;
	}
	DisplayMenu(menu, client, 0);
	return 0;
}

public Handle_SetCommander_ClientSelection(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:4)
	{
		decl String:item[8];
		GetMenuItem(menu, param2, item, 8, 0, "", 0);
		new target = StringToInt(item, 10);
		target = GetClientOfUserId(target);
		if (target)
		{
			PerformPromote(param1, target);
		}
		else
		{
			PrintToChat(param1, "[SM] That player is no longer available.");
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public CMHandleDEMOTECommander(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			new Handle:menu = CreateMenu(Handle_DemoteCommander_SelectTeam, MenuAction:28);
			SetMenuTitle(menu, "Demote Which Commander?");
			if (GameRules_GetPropEnt("m_hCommanders", 0) == -1)
			{
				AddMenuItem(menu, "", "Consortium", 1);
			}
			else
			{
				AddMenuItem(menu, "0", "Consortium", 0);
			}
			if (GameRules_GetPropEnt("m_hCommanders", 1) == -1)
			{
				AddMenuItem(menu, "1", "Empire", 1);
			}
			else
			{
				AddMenuItem(menu, "1", "Empire", 0);
			}
			DisplayMenu(menu, param, 0);
		}
	}
	else
	{
		Format(buffer, maxlength, "Demote");
	}
	return 0;
}

public Handle_DemoteCommander_SelectTeam(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:4)
	{
		decl String:item[8];
		GetMenuItem(menu, param2, item, 8, 0, "", 0);
		new target = GameRules_GetPropEnt("m_hCommanders", StringToInt(item, 10));
		if (target == -1)
		{
			return 0;
		}
		if (!CanUserTarget(param1, target))
		{
			PrintToChat(param1, "[SM] You cannon target this client.");
			return 0;
		}
		PerformDemote(param1, GameRules_GetPropEnt("m_hCommanders", StringToInt(item, 10)));
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public CMHandleBANCommander(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			new Handle:menu = CreateMenu(Handle_BanCommander_SelectPlayer, MenuAction:28);
			new i;
			decl Commanders[2];
			decl String:UserID[8];
			decl String:Name[64];
			Commanders[0] = GameRules_GetPropEnt("m_hCommanders", 0);
			Commanders[1] = GameRules_GetPropEnt("m_hCommanders", 1);
			SetMenuTitle(menu, "Select A Player To Ban:");
			i = 0;
			while (i <= 1)
			{
				new var1;
				if (Commanders[i] != -1 && CanUserTarget(param, Commanders[i]))
				{
					IntToString(GetClientUserId(Commanders[i]), UserID, 8);
					GetClientName(Commanders[i], Name, 64);
					AddMenuItem(menu, UserID, Name, 0);
				}
				i++;
			}
			i = 1;
			while (i <= MaxClients)
			{
				new var2;
				if (IsClientInGame(i) && CanUserTarget(param, i) && Commanders[0] != i && Commanders[1] != i)
				{
					IntToString(GetClientUserId(i), UserID, 8);
					GetClientName(i, Name, 64);
					AddMenuItem(menu, UserID, Name, 0);
				}
				i++;
			}
			DisplayMenu(menu, param, 0);
		}
	}
	else
	{
		Format(buffer, maxlength, "Ban");
	}
	return 0;
}

public Handle_BanCommander_SelectPlayer(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:4)
	{
		decl String:item[8];
		GetMenuItem(menu, param2, item, 8, 0, "", 0);
		g_BanQueue[param1] = StringToInt(item, 10);
		DisplayMenu_BanCommander_SelectBanTime(param1);
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

DisplayMenu_BanCommander_SelectBanTime(client)
{
	new Handle:menu = CreateMenu(Handle_BanCommander_SelectBanTime, MenuAction:28);
	SetMenuTitle(menu, "Ban For How Long?");
	AddMenuItem(menu, "0", "Permanently", 0);
	DisplayMenu(menu, client, 0);
	return 0;
}

public Handle_BanCommander_SelectBanTime(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:4)
	{
		decl String:item[8];
		GetMenuItem(menu, param2, item, 8, 0, "", 0);
		new BanTime = StringToInt(item, 10);
		new target = GetClientOfUserId(g_BanQueue[param1]);
		if (target)
		{
			if (BanTime == -1)
			{
				g_CommanderBans[target] = 0;
				new var1;
				if (GetClientTeam(target) > 1 && GameRules_GetPropEnt("m_hCommanders", GetClientTeam(target) + -2) == target)
				{
					FakeClientCommand(target, "startmutiny");
				}
				FakeClientCommand(target, "unapplyforcommander");
				ShowActivity2(param1, "[SM] ", "Banned %N from commanding for the length of this map.", target);
			}
			else
			{
				decl String:authid[32];
				GetClientAuthId(target, AuthIdType:1, authid, 32, true);
				PerformCommanderBan(param1, target, authid);
			}
		}
		else
		{
			PrintToChat(param1, "[SM] That player is no longer available.");
		}
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public CMHandleUNBANCommander(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			decl String:name[64];
			decl String:authid[64];
			new Handle:menu = CreateMenu(Handle_UnBanCommander_SelectPlayer, MenuAction:28);
			new Handle:kv = CreateKeyValues("bans", "", "");
			SetMenuTitle(menu, "Remove A Commander Ban:");
			FileToKeyValues(kv, g_sKeyValuesPath);
			if (KvGotoFirstSubKey(kv, true))
			{
				do {
					KvGetSectionName(kv, authid, 64);
					KvGetString(kv, "name", name, 64, "");
					if (StrEqual(name, "", true))
					{
						AddMenuItem(menu, authid, authid, 0);
					}
					else
					{
						AddMenuItem(menu, authid, name, 0);
					}
				} while (KvGotoNextKey(kv, true));
			}
			else
			{
				AddMenuItem(menu, "", "No Bans!", 1);
			}
			DisplayMenu(menu, param, 0);
			CloseHandle(kv);
		}
	}
	else
	{
		Format(buffer, maxlength, "Unban");
	}
	return 0;
}

public Handle_UnBanCommander_SelectPlayer(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:4)
	{
		decl String:item[64];
		GetMenuItem(menu, param2, item, 64, 0, "", 0);
		PerformUnban(param1, -1, item, ReplySource:1);
	}
	else
	{
		if (action == MenuAction:16)
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

