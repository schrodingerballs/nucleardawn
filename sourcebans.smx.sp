public PlVers:__version =
{
	version = 5,
	filevers = "1.8.0.5848",
	date = "02/23/2016",
	time = "21:08:48"
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
public SharedPlugin:__pl_sourcebans =
{
	name = "SourceBans",
	file = "sourcebans.smx",
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
new g_BanTarget[66] =
{
	-1, ...
};
new g_BanTime[66] =
{
	-1, ...
};
new State:ConfigState;
new Handle:ConfigParser;
new Handle:hTopMenu;
new String:Prefix[16] = "[SourceBans] ";
new String:ServerIp[24];
new String:ServerPort[8];
new String:DatabasePrefix[12] = "sb";
new String:WebsiteAddress[128];
new AdminCachePart:loadPart;
new bool:loadAdmins;
new bool:loadGroups;
new bool:loadOverrides;
new curLoading;
new AdminFlag:g_FlagLetters[26];
new String:groupsLoc[128];
new String:adminsLoc[128];
new String:overridesLoc[128];
new Handle:CvarHostIp;
new Handle:CvarPort;
new Handle:DB;
new Handle:SQLiteDB;
new Handle:ReasonMenuHandle;
new Handle:HackingMenuHandle;
new Handle:PlayerRecheck[66];
new Handle:PlayerDataPack[66];
new bool:PlayerStatus[66];
new CommandDisable;
new bool:backupConfig = 1;
new bool:enableAdmins = 1;
new bool:requireSiteLogin;
new String:logFile[256];
new g_ownReasons[66];
new Float:RetryTime = 1097859072;
new ProcessQueueTime = 5;
new bool:LateLoaded;
new bool:AutoAdd;
new bool:g_bConnecting;
new serverID = -1;
public Plugin:myinfo =
{
	name = "SourceBans++",
	description = "Advanced ban management for the Source engine",
	author = "SourceBans Development Team, Sarabveer(VEER™)",
	version = "1.5.4",
	url = "https://sarabveer.github.io/SourceBans-Fork/"
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

public .2920.StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

public .2920.StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

public .2972.SQLite_UseDatabase(String:database[], String:error[], maxlength)
{
	new KeyValues:kv = CreateKeyValues("", "", "");
	KeyValues.SetString(kv, "driver", "sqlite");
	KeyValues.SetString(kv, "database", database);
	new Database:db = SQL_ConnectCustom(kv, error, maxlength, false);
	CloseHandle(kv);
	kv = MissingTAG:0;
	return db;
}

public .2972.SQLite_UseDatabase(String:database[], String:error[], maxlength)
{
	new KeyValues:kv = CreateKeyValues("", "", "");
	KeyValues.SetString(kv, "driver", "sqlite");
	KeyValues.SetString(kv, "database", database);
	new Database:db = SQL_ConnectCustom(kv, error, maxlength, false);
	CloseHandle(kv);
	kv = MissingTAG:0;
	return db;
}

public .3220.ReplyToTargetError(client, reason)
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

public .3220.ReplyToTargetError(client, reason)
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

public .3684.FindTarget(client, String:target[], bool:nobots, bool:immunity)
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
	.3220.ReplyToTargetError(client, target_count);
	return -1;
}

public .3684.FindTarget(client, String:target[], bool:nobots, bool:immunity)
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
	.3220.ReplyToTargetError(client, target_count);
	return -1;
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

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	RegPluginLibrary("sourcebans");
	CreateNative("SBBanPlayer", Native_SBBanPlayer);
	LateLoaded = late;
	return APLRes:0;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("plugin.basecommands");
	LoadTranslations("sourcebans.phrases");
	LoadTranslations("basebans.phrases");
	new var1 = false;
	loadOverrides = var1;
	loadGroups = var1;
	loadAdmins = var1;
	CvarHostIp = FindConVar("hostip");
	CvarPort = FindConVar("hostport");
	CreateConVar("sb_version", "1.5.4F", "", 8512, false, 0.0, false, 0.0);
	CreateConVar("sbr_version", "1.5.4", "", 8512, false, 0.0, false, 0.0);
	RegServerCmd("sm_rehash", sm_rehash, "Reload SQL admins", 0);
	RegAdminCmd("sm_ban", CommandBan, 8, "sm_ban <#userid|name> <minutes|0> [reason]", "sourcebans", 0);
	RegAdminCmd("sm_banip", CommandBanIp, 8, "sm_banip <ip|#userid|name> <time> [reason]", "sourcebans", 0);
	RegAdminCmd("sm_addban", CommandAddBan, 4096, "sm_addban <time> <steamid> [reason]", "sourcebans", 0);
	RegAdminCmd("sm_unban", CommandUnban, 16, "sm_unban <steamid|ip> [reason]", "sourcebans", 0);
	RegAdminCmd("sb_reload", _CmdReload, 4096, "Reload sourcebans config and ban reason menu options", "sourcebans", 0);
	RegConsoleCmd("say", ChatHook, "", 0);
	RegConsoleCmd("say_team", ChatHook, "", 0);
	if ((ReasonMenuHandle = CreateMenu(ReasonSelected, MenuAction:28)))
	{
		SetMenuPagination(ReasonMenuHandle, 8);
		SetMenuExitBackButton(ReasonMenuHandle, true);
	}
	if ((HackingMenuHandle = CreateMenu(HackingSelected, MenuAction:28)))
	{
		SetMenuPagination(HackingMenuHandle, 8);
		SetMenuExitBackButton(HackingMenuHandle, true);
	}
	.48596.CreateFlagLetters();
	BuildPath(PathType:0, logFile, 256, "logs/sourcebans.log");
	g_bConnecting = true;
	if (!SQL_CheckConfig("sourcebans"))
	{
		if (ReasonMenuHandle)
		{
			CloseHandle(ReasonMenuHandle);
		}
		if (HackingMenuHandle)
		{
			CloseHandle(HackingMenuHandle);
		}
		LogToFile(logFile, "Database failure: Could not find Database conf \"sourcebans\". See FAQ: https://sarabveer.github.io/SourceBans-Fork/faq/");
		SetFailState("Database failure: Could not find Database conf \"sourcebans\"");
		return void:0;
	}
	SQL_TConnect(GotDatabase, "sourcebans", any:0);
	BuildPath(PathType:0, groupsLoc, 128, "configs/sourcebans/sb_admin_groups.cfg");
	BuildPath(PathType:0, adminsLoc, 128, "configs/sourcebans/sb_admins.cfg");
	BuildPath(PathType:0, overridesLoc, 128, "configs/sourcebans/overrides_backup.cfg");
	InitializeBackupDB();
	CreateTimer(float(ProcessQueueTime * 60), ProcessQueue, any:0, 0);
	if (LateLoaded)
	{
		.49416.AccountForLateLoading();
	}
	return void:0;
}

public void:OnAllPluginsLoaded()
{
	new Handle:topmenu;
	new var1;
	if (LibraryExists("adminmenu") && (topmenu = GetAdminTopMenu()))
	{
		OnAdminMenuReady(topmenu);
	}
	return void:0;
}

public void:OnConfigsExecuted()
{
	decl String:filename[200];
	BuildPath(PathType:0, filename, 200, "plugins/basebans.smx");
	if (FileExists(filename, false, "GAME"))
	{
		decl String:newfilename[200];
		BuildPath(PathType:0, newfilename, 200, "plugins/disabled/basebans.smx");
		ServerCommand("sm plugins unload basebans");
		if (FileExists(newfilename, false, "GAME"))
		{
			DeleteFile(newfilename, false, "DEFAULT_WRITE_PATH");
		}
		RenameFile(newfilename, filename, false, "DEFAULT_WRITE_PATH");
		LogToFile(logFile, "plugins/basebans.smx was unloaded and moved to plugins/disabled/basebans.smx");
	}
	return void:0;
}

public void:OnMapStart()
{
	.47724.ResetSettings();
	return void:0;
}

public void:OnMapEnd()
{
	new i;
	while (i <= MaxClients)
	{
		if (PlayerDataPack[i])
		{
			CloseHandle(PlayerDataPack[i]);
			PlayerDataPack[i] = 0;
		}
		i++;
	}
	return void:0;
}

public Action:OnClientPreAdminCheck(client)
{
	new var1;
	if (!DB || GetUserAdmin(client) == -1)
	{
		return Action:0;
	}
	new var2;
	if (curLoading > 0)
	{
		var2 = MissingTAG:3;
	}
	else
	{
		var2 = MissingTAG:0;
	}
	return var2;
}

public void:OnClientDisconnect(client)
{
	if (PlayerRecheck[client])
	{
		KillTimer(PlayerRecheck[client], false);
		PlayerRecheck[client] = 0;
	}
	g_ownReasons[client] = 0;
	return void:0;
}

public bool:OnClientConnect(client, String:rejectmsg[], maxlen)
{
	PlayerStatus[client] = 0;
	return true;
}

public void:OnClientAuthorized(client, String:auth[])
{
	new var1;
	if (auth[0] == 'B' || auth[2] == 'L' || DB)
	{
		PlayerStatus[client] = 1;
		return void:0;
	}
	decl String:Query[256];
	decl String:ip[32];
	GetClientIP(client, ip, 30, true);
	FormatEx(Query, 256, "SELECT bid FROM %s_bans WHERE ((type = 0 AND authid REGEXP '^STEAM_[0-9]:%s$') OR (type = 1 AND ip = '%s')) AND (length = '0' OR ends > UNIX_TIMESTAMP()) AND RemoveType IS NULL", DatabasePrefix, auth[2], ip);
	SQL_TQuery(DB, VerifyBan, Query, GetClientUserId(client), DBPriority:0);
	return void:0;
}

public void:OnRebuildAdminCache(AdminCachePart:part)
{
	loadPart = part;
	switch (loadPart)
	{
		case 0:
		{
			loadOverrides = true;
		}
		case 1:
		{
			loadGroups = true;
		}
		case 2:
		{
			loadAdmins = true;
		}
		default:
		{
		}
	}
	if (DB)
	{
		GotDatabase(DB, DB, "", any:0);
	}
	else
	{
		if (!g_bConnecting)
		{
			g_bConnecting = true;
			SQL_TConnect(GotDatabase, "sourcebans", any:0);
		}
	}
	return void:0;
}

public Action:ChatHook(client, args)
{
	if (g_ownReasons[client])
	{
		decl String:reason[512];
		GetCmdArgString(reason, 512);
		StripQuotes(reason);
		g_ownReasons[client] = 0;
		if (.2920.StrEqual(reason, "!noreason", true))
		{
			PrintToChat(client, "%c[%cSourceBans%c]%c %t", '\x04', '\x02', '\x04', '\x02', "Chat Reason Aborted");
			return Action:3;
		}
		.46364.PrepareBan(client, g_BanTarget[client], g_BanTime[client], reason, 512);
		return Action:3;
	}
	return Action:0;
}

public Action:_CmdReload(client, args)
{
	.47724.ResetSettings();
	return Action:3;
}

public Action:CommandBan(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "%sUsage: sm_ban <#userid|name> <time|0> [reason]", Prefix);
		return Action:3;
	}
	new admin = client;
	decl String:buffer[100];
	GetCmdArg(1, buffer, 100);
	new target = .3684.FindTarget(client, buffer, true, true);
	if (target == -1)
	{
		return Action:3;
	}
	GetCmdArg(2, buffer, 100);
	new time = StringToInt(buffer, 10);
	new var1;
	if (!time && client && !CheckCommandAccess(client, "sm_unban", 16400, false))
	{
		ReplyToCommand(client, "You do not have Perm Ban Permission");
		return Action:3;
	}
	new String:reason[128];
	if (args >= 3)
	{
		GetCmdArg(3, reason, 128);
		new i = 4;
		while (i <= args)
		{
			GetCmdArg(i, buffer, 100);
			Format(reason, 128, "%s %s", reason, buffer);
			i++;
		}
	}
	else
	{
		reason[0] = MissingTAG:0;
	}
	g_BanTarget[client] = target;
	g_BanTime[client] = time;
	if (!PlayerStatus[target])
	{
		ReplyToCommand(admin, "%c[%cSourceBans%c]%c %t", '\x04', '\x02', '\x04', '\x02', "Ban Not Verified");
		return Action:3;
	}
	CreateBan(client, target, time, reason);
	return Action:3;
}

public Action:CommandBanIp(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "%sUsage: sm_banip <ip|#userid|name> <time> [reason]", Prefix);
		return Action:3;
	}
	decl len;
	decl next_len;
	decl String:Arguments[256];
	decl String:arg[52];
	decl String:time[20];
	GetCmdArgString(Arguments, 256);
	len = BreakString(Arguments, arg, 50);
	if ((next_len = BreakString(Arguments[len], time, 20)) != -1)
	{
		len = next_len + len;
	}
	else
	{
		len = 0;
		Arguments[0] = MissingTAG:0;
	}
	decl String:target_name[64];
	decl target_list[1];
	decl bool:tn_is_ml;
	new target = -1;
	if (0 < ProcessTargetString(arg, client, target_list, 1, 20, target_name, 64, tn_is_ml))
	{
		target = target_list[0];
		new var1;
		if (!IsFakeClient(target) && CanUserTarget(client, target))
		{
			GetClientIP(target, arg, 50, true);
		}
	}
	decl String:adminIp[24];
	decl String:adminAuth[64];
	new minutes = StringToInt(time, 10);
	new var2;
	if (!minutes && client && !CheckCommandAccess(client, "sm_unban", 16400, false))
	{
		ReplyToCommand(client, "You do not have Perm Ban Permission");
		return Action:3;
	}
	if (!client)
	{
		strcopy(adminAuth, 64, "STEAM_ID_SERVER");
		strcopy(adminIp, 24, ServerIp);
	}
	else
	{
		GetClientIP(client, adminIp, 24, true);
		GetClientAuthId(client, AuthIdType:1, adminAuth, 64, true);
	}
	new Handle:dataPack = CreateDataPack();
	WritePackCell(dataPack, client);
	WritePackCell(dataPack, minutes);
	WritePackString(dataPack, Arguments[len]);
	WritePackString(dataPack, arg);
	WritePackString(dataPack, adminAuth);
	WritePackString(dataPack, adminIp);
	decl String:Query[256];
	FormatEx(Query, 256, "SELECT bid FROM %s_bans WHERE type = 1 AND ip     = '%s' AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemoveType IS NULL", DatabasePrefix, arg);
	SQL_TQuery(DB, SelectBanIpCallback, Query, dataPack, DBPriority:0);
	return Action:3;
}

public Action:CommandUnban(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "%sUsage: sm_unban <steamid|ip> [reason]", Prefix);
		return Action:3;
	}
	if (CommandDisable & 2)
	{
		ReplyToCommand(client, "%s%t", Prefix, "Can Not Unban", WebsiteAddress);
		return Action:3;
	}
	decl len;
	decl String:Arguments[256];
	decl String:arg[52];
	decl String:adminAuth[64];
	GetCmdArgString(Arguments, 256);
	if ((len = BreakString(Arguments, arg, 50)) == -1)
	{
		len = 0;
		Arguments[0] = MissingTAG:0;
	}
	if (!client)
	{
		strcopy(adminAuth, 64, "STEAM_ID_SERVER");
	}
	else
	{
		GetClientAuthId(client, AuthIdType:1, adminAuth, 64, true);
	}
	new Handle:dataPack = CreateDataPack();
	WritePackCell(dataPack, client);
	WritePackString(dataPack, Arguments[len]);
	WritePackString(dataPack, arg);
	WritePackString(dataPack, adminAuth);
	decl String:query[200];
	if (strncmp(arg, "STEAM_", 6, true))
	{
		Format(query, 200, "SELECT bid FROM %s_bans WHERE (type = 1 AND ip     = '%s') AND (length = '0' OR ends > UNIX_TIMESTAMP()) AND RemoveType IS NULL", DatabasePrefix, arg);
	}
	else
	{
		Format(query, 200, "SELECT bid FROM %s_bans WHERE (type = 0 AND authid = '%s') AND (length = '0' OR ends > UNIX_TIMESTAMP()) AND RemoveType IS NULL", DatabasePrefix, arg);
	}
	SQL_TQuery(DB, SelectUnbanCallback, query, dataPack, DBPriority:1);
	return Action:3;
}

public Action:CommandAddBan(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "%sUsage: sm_addban <time> <steamid> [reason]", Prefix);
		return Action:3;
	}
	if (CommandDisable & 1)
	{
		ReplyToCommand(client, "%s%t", Prefix, "Can Not Add Ban", WebsiteAddress);
		return Action:3;
	}
	decl String:arg_string[256];
	decl String:time[52];
	decl String:authid[52];
	GetCmdArgString(arg_string, 256);
	new len;
	new total_len;
	if ((len = BreakString(arg_string, time, 50)) == -1)
	{
		ReplyToCommand(client, "%sUsage: sm_addban <time> <steamid> [reason]", Prefix);
		return Action:3;
	}
	total_len = len + total_len;
	if ((len = BreakString(arg_string[total_len], authid, 50)) != -1)
	{
		total_len = len + total_len;
	}
	else
	{
		total_len = 0;
		arg_string[0] = MissingTAG:0;
	}
	decl String:adminIp[24];
	decl String:adminAuth[64];
	new minutes = StringToInt(time, 10);
	new var1;
	if (!minutes && client && !CheckCommandAccess(client, "sm_unban", 16400, false))
	{
		ReplyToCommand(client, "You do not have Perm Ban Permission");
		return Action:3;
	}
	if (!client)
	{
		strcopy(adminAuth, 64, "STEAM_ID_SERVER");
		strcopy(adminIp, 24, ServerIp);
	}
	else
	{
		GetClientIP(client, adminIp, 24, true);
		GetClientAuthId(client, AuthIdType:1, adminAuth, 64, true);
	}
	new Handle:dataPack = CreateDataPack();
	WritePackCell(dataPack, client);
	WritePackCell(dataPack, minutes);
	WritePackString(dataPack, arg_string[total_len]);
	WritePackString(dataPack, authid);
	WritePackString(dataPack, adminAuth);
	WritePackString(dataPack, adminIp);
	decl String:Query[256];
	FormatEx(Query, 256, "SELECT bid FROM %s_bans WHERE type = 0 AND authid = '%s' AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemoveType IS NULL", DatabasePrefix, authid);
	SQL_TQuery(DB, SelectAddbanCallback, Query, dataPack, DBPriority:0);
	return Action:3;
}

public Action:sm_rehash(args)
{
	if (enableAdmins)
	{
		DumpAdminCache(AdminCachePart:1, true);
	}
	DumpAdminCache(AdminCachePart:0, true);
	return Action:3;
}

public void:OnAdminMenuReady(Handle:topmenu)
{
	if (hTopMenu == topmenu)
	{
		return void:0;
	}
	hTopMenu = topmenu;
	new TopMenuObject:player_commands = FindTopMenuCategory(hTopMenu, "PlayerCommands");
	if (player_commands)
	{
		AddToTopMenu(hTopMenu, "sm_ban", TopMenuObjectType:1, AdminMenu_Ban, player_commands, "sm_ban", 8, "");
	}
	return void:0;
}

public AdminMenu_Ban(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	g_ownReasons[param] = 0;
	switch (action)
	{
		case 0:
		{
			Format(buffer, maxlength, "%T", "Ban player", param);
		}
		case 2:
		{
			.16984.DisplayBanTargetMenu(param);
		}
		default:
		{
		}
	}
	return 0;
}

public ReasonSelected(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:info[128];
			decl String:key[128];
			GetMenuItem(menu, param2, key, 128, 0, info, 128);
			if (.2920.StrEqual("Hacking", key, true))
			{
				DisplayMenu(HackingMenuHandle, param1, 0);
				return 0;
			}
			if (.2920.StrEqual("Own Reason", key, true))
			{
				g_ownReasons[param1] = 1;
				PrintToChat(param1, "%c[%cSourceBans%c]%c %t", '\x04', '\x02', '\x04', '\x02', "Chat Reason");
				return 0;
			}
			new var1;
			if (g_BanTarget[param1] != -1 && g_BanTime[param1] != -1)
			{
				.46364.PrepareBan(param1, g_BanTarget[param1], g_BanTime[param1], info, 128);
			}
		}
		case 8:
		{
			if (param2 == -1)
			{
				if (PlayerDataPack[param1])
				{
					CloseHandle(PlayerDataPack[param1]);
					PlayerDataPack[param1] = 0;
				}
			}
			else
			{
				.17260.DisplayBanTimeMenu(param1);
			}
		}
		default:
		{
		}
	}
	return 0;
}

public HackingSelected(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:info[128];
			decl String:key[128];
			GetMenuItem(menu, param2, key, 128, 0, info, 128);
			new var1;
			if (g_BanTarget[param1] != -1 && g_BanTime[param1] != -1)
			{
				.46364.PrepareBan(param1, g_BanTarget[param1], g_BanTime[param1], info, 128);
			}
		}
		case 8:
		{
			if (param2 == -1)
			{
				new Handle:Pack = PlayerDataPack[param1];
				if (Pack)
				{
					ReadPackCell(Pack);
					ReadPackCell(Pack);
					ReadPackCell(Pack);
					ReadPackCell(Pack);
					ReadPackCell(Pack);
					new Handle:ReasonPack = ReadPackCell(Pack);
					if (ReasonPack)
					{
						CloseHandle(ReasonPack);
					}
					CloseHandle(Pack);
					PlayerDataPack[param1] = 0;
				}
			}
			else
			{
				DisplayMenu(ReasonMenuHandle, param1, 0);
			}
		}
		default:
		{
		}
	}
	return 0;
}

public MenuHandler_BanPlayerList(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:info[32];
			decl String:name[32];
			new userid;
			new target;
			GetMenuItem(menu, param2, info, 32, 0, name, 32);
			userid = StringToInt(info, 10);
			if ((target = GetClientOfUserId(userid)))
			{
				if (!CanUserTarget(param1, target))
				{
					PrintToChat(param1, "%s%t", Prefix, "Unable to target");
				}
				g_BanTarget[param1] = target;
				.17260.DisplayBanTimeMenu(param1);
			}
			else
			{
				PrintToChat(param1, "%s%t", Prefix, "Player no longer available");
			}
		}
		case 8:
		{
			new var1;
			if (param2 == -6 && hTopMenu)
			{
				DisplayTopMenu(hTopMenu, param1, TopMenuPosition:3);
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

public MenuHandler_BanTimeList(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:info[32];
			GetMenuItem(menu, param2, info, 32, 0, "", 0);
			g_BanTime[param1] = StringToInt(info, 10);
			DisplayMenu(ReasonMenuHandle, param1, 0);
		}
		case 8:
		{
			new var1;
			if (param2 == -6 && hTopMenu)
			{
				DisplayTopMenu(hTopMenu, param1, TopMenuPosition:3);
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

public .16984.DisplayBanTargetMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandler_BanPlayerList, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T:", "Ban player", client);
	SetMenuTitle(menu, title);
	SetMenuExitBackButton(menu, true);
	AddTargetsToMenu(menu, client, false, false);
	DisplayMenu(menu, client, 0);
	return 0;
}

public .16984.DisplayBanTargetMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandler_BanPlayerList, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T:", "Ban player", client);
	SetMenuTitle(menu, title);
	SetMenuExitBackButton(menu, true);
	AddTargetsToMenu(menu, client, false, false);
	DisplayMenu(menu, client, 0);
	return 0;
}

public .17260.DisplayBanTimeMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandler_BanTimeList, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T:", "Ban player", client);
	SetMenuTitle(menu, title);
	SetMenuExitBackButton(menu, true);
	if (CheckCommandAccess(client, "sm_unban", 16400, false))
	{
		AddMenuItem(menu, "0", "Permanent", 0);
	}
	AddMenuItem(menu, "10", "10 Minutes", 0);
	AddMenuItem(menu, "30", "30 Minutes", 0);
	AddMenuItem(menu, "60", "1 Hour", 0);
	AddMenuItem(menu, "240", "4 Hours", 0);
	AddMenuItem(menu, "1440", "1 Day", 0);
	AddMenuItem(menu, "10080", "1 Week", 0);
	DisplayMenu(menu, client, 0);
	return 0;
}

public .17260.DisplayBanTimeMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandler_BanTimeList, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T:", "Ban player", client);
	SetMenuTitle(menu, title);
	SetMenuExitBackButton(menu, true);
	if (CheckCommandAccess(client, "sm_unban", 16400, false))
	{
		AddMenuItem(menu, "0", "Permanent", 0);
	}
	AddMenuItem(menu, "10", "10 Minutes", 0);
	AddMenuItem(menu, "30", "30 Minutes", 0);
	AddMenuItem(menu, "60", "1 Hour", 0);
	AddMenuItem(menu, "240", "4 Hours", 0);
	AddMenuItem(menu, "1440", "1 Day", 0);
	AddMenuItem(menu, "10080", "1 Week", 0);
	DisplayMenu(menu, client, 0);
	return 0;
}

public .17824.ResetMenu()
{
	if (ReasonMenuHandle)
	{
		RemoveAllMenuItems(ReasonMenuHandle);
	}
	return 0;
}

public .17824.ResetMenu()
{
	if (ReasonMenuHandle)
	{
		RemoveAllMenuItems(ReasonMenuHandle);
	}
	return 0;
}

public GotDatabase(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		DB = hndl;
		decl String:query[1024];
		FormatEx(query, 1024, "SET NAMES \"UTF8\"");
		SQL_TQuery(DB, ErrorCheckCallback, query, any:0, DBPriority:1);
		.45752.InsertServerInfo();
		if (loadOverrides)
		{
			Format(query, 1024, "SELECT type, name, flags FROM %s_overrides", DatabasePrefix);
			SQL_TQuery(DB, OverridesDone, query, any:0, DBPriority:1);
			loadOverrides = false;
		}
		new var1;
		if (loadGroups && enableAdmins)
		{
			FormatEx(query, 1024, "SELECT name, flags, immunity, groups_immune   FROM %s_srvgroups ORDER BY id", DatabasePrefix);
			curLoading += 1;
			SQL_TQuery(DB, GroupsDone, query, any:0, DBPriority:1);
			loadGroups = false;
		}
		new var2;
		if (loadAdmins && enableAdmins)
		{
			new String:queryLastLogin[52] = "lastvisit IS NOT NULL AND lastvisit != '' AND";
			if (!requireSiteLogin)
			{
			}
			if (serverID == -1)
			{
				FormatEx(query, 1024, "SELECT authid, srv_password, (SELECT name FROM %s_srvgroups WHERE name = srv_group AND flags != '') AS srv_group, srv_flags, user, immunity  FROM %s_admins_servers_groups AS asg LEFT JOIN %s_admins AS a ON a.aid = asg.admin_id WHERE %s (server_id = (SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s' LIMIT 0,1)  OR srv_group_id = ANY (SELECT group_id FROM %s_servers_groups WHERE server_id = (SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s' LIMIT 0,1))) GROUP BY aid, authid, srv_password, srv_group, srv_flags, user", DatabasePrefix, DatabasePrefix, DatabasePrefix, queryLastLogin, DatabasePrefix, ServerIp, ServerPort, DatabasePrefix, DatabasePrefix, ServerIp, ServerPort);
			}
			else
			{
				FormatEx(query, 1024, "SELECT authid, srv_password, (SELECT name FROM %s_srvgroups WHERE name = srv_group AND flags != '') AS srv_group, srv_flags, user, immunity  FROM %s_admins_servers_groups AS asg LEFT JOIN %s_admins AS a ON a.aid = asg.admin_id WHERE %s server_id = %d  OR srv_group_id = ANY (SELECT group_id FROM %s_servers_groups WHERE server_id = %d) GROUP BY aid, authid, srv_password, srv_group, srv_flags, user", DatabasePrefix, DatabasePrefix, DatabasePrefix, queryLastLogin, serverID, DatabasePrefix, serverID);
			}
			curLoading += 1;
			SQL_TQuery(DB, AdminsDone, query, any:0, DBPriority:1);
			loadAdmins = false;
		}
		g_bConnecting = false;
		return 0;
	}
	LogToFile(logFile, "Database failure: %s. See FAQ: https://sarabveer.github.io/SourceBans-Fork/faq/", error);
	g_bConnecting = false;
	.47792.ParseBackupConfig_Overrides();
	return 0;
}

public VerifyInsert(Handle:owner, Handle:hndl, String:error[], any:dataPack)
{
	if (dataPack)
	{
		new var1;
		if (hndl && error[0])
		{
			LogToFile(logFile, "Verify Insert Query Failed: %s", error);
			new admin = ReadPackCell(dataPack);
			ReadPackCell(dataPack);
			ReadPackCell(dataPack);
			ReadPackCell(dataPack);
			new time = ReadPackCell(dataPack);
			new Handle:reasonPack = ReadPackCell(dataPack);
			decl String:reason[128];
			ReadPackString(reasonPack, reason, 128);
			decl String:name[52];
			ReadPackString(dataPack, name, 50);
			decl String:auth[32];
			ReadPackString(dataPack, auth, 30);
			decl String:ip[20];
			ReadPackString(dataPack, ip, 20);
			decl String:adminAuth[32];
			ReadPackString(dataPack, adminAuth, 30);
			decl String:adminIp[20];
			ReadPackString(dataPack, adminIp, 20);
			ResetPack(dataPack, false);
			ResetPack(reasonPack, false);
			PlayerDataPack[admin] = 0;
			.44708.UTIL_InsertTempBan(time, name, auth, ip, reason, adminAuth, adminIp, dataPack);
			return 0;
		}
		new admin = ReadPackCell(dataPack);
		new client = ReadPackCell(dataPack);
		new var2;
		if (!IsClientConnected(client) || IsFakeClient(client))
		{
			return 0;
		}
		ReadPackCell(dataPack);
		new UserId = ReadPackCell(dataPack);
		new time = ReadPackCell(dataPack);
		new Handle:ReasonPack = ReadPackCell(dataPack);
		decl String:Name[64];
		decl String:Reason[128];
		ReadPackString(dataPack, Name, 64);
		ReadPackString(ReasonPack, Reason, 128);
		if (!time)
		{
			if (Reason[0])
			{
				ShowActivityEx(admin, Prefix, "%t", "Permabanned player reason", Name, Reason);
			}
			else
			{
				ShowActivityEx(admin, Prefix, "%t", "Permabanned player", Name);
			}
		}
		else
		{
			if (Reason[0])
			{
				ShowActivityEx(admin, Prefix, "%t", "Banned player reason", Name, time, Reason);
			}
			ShowActivityEx(admin, Prefix, "%t", "Banned player", Name, time);
		}
		LogAction(admin, client, "\"%L\" banned \"%L\" (minutes \"%d\") (reason \"%s\")", admin, client, time, Reason);
		if (PlayerDataPack[admin])
		{
			CloseHandle(PlayerDataPack[admin]);
			CloseHandle(ReasonPack);
			PlayerDataPack[admin] = 0;
		}
		if (UserId == GetClientUserId(client))
		{
			KickClient(client, "%t", "Banned Check Site", WebsiteAddress);
		}
		return 0;
	}
	LogToFile(logFile, "Ban Failed: %s", error);
	return 0;
}

public SelectBanIpCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	decl admin;
	decl minutes;
	decl String:adminAuth[32];
	decl String:adminIp[32];
	decl String:banReason[256];
	decl String:ip[16];
	decl String:Query[512];
	decl String:reason[128];
	ResetPack(data, false);
	admin = ReadPackCell(data);
	minutes = ReadPackCell(data);
	ReadPackString(data, reason, 128);
	ReadPackString(data, ip, 16);
	ReadPackString(data, adminAuth, 30);
	ReadPackString(data, adminIp, 30);
	SQL_EscapeString(DB, reason, banReason, 256, 0);
	if (error[0])
	{
		LogToFile(logFile, "Ban IP Select Query Failed: %s", error);
		new var1;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%sFailed to ban %s.", Prefix, ip);
		}
		else
		{
			PrintToServer("%sFailed to ban %s.", Prefix, ip);
		}
		return 0;
	}
	if (SQL_GetRowCount(hndl))
	{
		new var2;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%s%s is already banned.", Prefix, ip);
		}
		else
		{
			PrintToServer("%s%s is already banned.", Prefix, ip);
		}
		return 0;
	}
	if (serverID == -1)
	{
		FormatEx(Query, 512, "INSERT INTO %s_bans (type, ip, name, created, ends, length, reason, aid, adminIp, sid, country) VALUES (1, '%s', '', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', (SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), '%s', (SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s' LIMIT 0,1), ' ')", DatabasePrefix, ip, minutes * 60, minutes * 60, banReason, DatabasePrefix, adminAuth, adminAuth[2], adminIp, DatabasePrefix, ServerIp, ServerPort);
	}
	else
	{
		FormatEx(Query, 512, "INSERT INTO %s_bans (type, ip, name, created, ends, length, reason, aid, adminIp, sid, country) VALUES (1, '%s', '', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', (SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), '%s', %d, ' ')", DatabasePrefix, ip, minutes * 60, minutes * 60, banReason, DatabasePrefix, adminAuth, adminAuth[2], adminIp, serverID);
	}
	SQL_TQuery(DB, InsertBanIpCallback, Query, data, DBPriority:0);
	return 0;
}

public InsertBanIpCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new admin;
	new minutes;
	decl String:reason[128];
	decl String:arg[32];
	if (data)
	{
		ResetPack(data, false);
		admin = ReadPackCell(data);
		minutes = ReadPackCell(data);
		ReadPackString(data, reason, 128);
		ReadPackString(data, arg, 30);
		CloseHandle(data);
	}
	else
	{
		ThrowError("Invalid Handle in InsertBanIpCallback");
	}
	if (error[0])
	{
		LogToFile(logFile, "Ban IP Insert Query Failed: %s", error);
		new var1;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%ssm_banip failed", Prefix);
		}
		return 0;
	}
	LogAction(admin, -1, "\"%L\" added ban (minutes \"%d\") (ip \"%s\") (reason \"%s\")", admin, minutes, arg, reason);
	new var2;
	if (admin && IsClientInGame(admin))
	{
		PrintToChat(admin, "%s%s successfully banned", Prefix, arg);
	}
	else
	{
		PrintToServer("%s%s successfully banned", Prefix, arg);
	}
	return 0;
}

public SelectUnbanCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	decl admin;
	decl String:arg[32];
	decl String:adminAuth[32];
	decl String:unbanReason[256];
	decl String:reason[128];
	ResetPack(data, false);
	admin = ReadPackCell(data);
	ReadPackString(data, reason, 128);
	ReadPackString(data, arg, 30);
	ReadPackString(data, adminAuth, 30);
	SQL_EscapeString(DB, reason, unbanReason, 256, 0);
	if (error[0])
	{
		LogToFile(logFile, "Unban Select Query Failed: %s", error);
		new var1;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%ssm_unban failed", Prefix);
		}
		return 0;
	}
	new var2;
	if (hndl && !SQL_GetRowCount(hndl))
	{
		new var3;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%sNo active bans found for that filter", Prefix);
		}
		else
		{
			PrintToServer("%sNo active bans found for that filter", Prefix);
		}
		return 0;
	}
	new var4;
	if (hndl && SQL_FetchRow(hndl))
	{
		new bid = SQL_FetchInt(hndl, 0, 0);
		decl String:query[1000];
		Format(query, 1000, "UPDATE %s_bans SET RemovedBy = (SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), RemoveType = 'U', RemovedOn = UNIX_TIMESTAMP(), ureason = '%s' WHERE bid = %d", DatabasePrefix, DatabasePrefix, adminAuth, adminAuth[2], unbanReason, bid);
		SQL_TQuery(DB, InsertUnbanCallback, query, data, DBPriority:1);
	}
	return 0;
}

public InsertUnbanCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	decl admin;
	decl String:reason[128];
	decl String:arg[32];
	if (data)
	{
		ResetPack(data, false);
		admin = ReadPackCell(data);
		ReadPackString(data, reason, 128);
		ReadPackString(data, arg, 30);
		CloseHandle(data);
	}
	else
	{
		ThrowError("Invalid Handle in InsertUnbanCallback");
	}
	if (error[0])
	{
		LogToFile(logFile, "Unban Insert Query Failed: %s", error);
		new var1;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%ssm_unban failed", Prefix);
		}
		return 0;
	}
	LogAction(admin, -1, "\"%L\" removed ban (filter \"%s\") (reason \"%s\")", admin, arg, reason);
	new var2;
	if (admin && IsClientInGame(admin))
	{
		PrintToChat(admin, "%s%s successfully unbanned", Prefix, arg);
	}
	else
	{
		PrintToServer("%s%s successfully unbanned", Prefix, arg);
	}
	return 0;
}

public SelectAddbanCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	decl admin;
	decl minutes;
	decl String:adminAuth[32];
	decl String:adminIp[32];
	decl String:authid[20];
	decl String:banReason[256];
	decl String:Query[512];
	decl String:reason[128];
	ResetPack(data, false);
	admin = ReadPackCell(data);
	minutes = ReadPackCell(data);
	ReadPackString(data, reason, 128);
	ReadPackString(data, authid, 20);
	ReadPackString(data, adminAuth, 30);
	ReadPackString(data, adminIp, 30);
	SQL_EscapeString(DB, reason, banReason, 256, 0);
	if (error[0])
	{
		LogToFile(logFile, "Add Ban Select Query Failed: %s", error);
		new var1;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%sFailed to ban %s.", Prefix, authid);
		}
		else
		{
			PrintToServer("%sFailed to ban %s.", Prefix, authid);
		}
		return 0;
	}
	if (SQL_GetRowCount(hndl))
	{
		new var2;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%s%s is already banned.", Prefix, authid);
		}
		else
		{
			PrintToServer("%s%s is already banned.", Prefix, authid);
		}
		return 0;
	}
	if (serverID == -1)
	{
		FormatEx(Query, 512, "INSERT INTO %s_bans (authid, name, created, ends, length, reason, aid, adminIp, sid, country) VALUES ('%s', '', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', (SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), '%s', (SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s' LIMIT 0,1), ' ')", DatabasePrefix, authid, minutes * 60, minutes * 60, banReason, DatabasePrefix, adminAuth, adminAuth[2], adminIp, DatabasePrefix, ServerIp, ServerPort);
	}
	else
	{
		FormatEx(Query, 512, "INSERT INTO %s_bans (authid, name, created, ends, length, reason, aid, adminIp, sid, country) VALUES ('%s', '', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', (SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), '%s', %d, ' ')", DatabasePrefix, authid, minutes * 60, minutes * 60, banReason, DatabasePrefix, adminAuth, adminAuth[2], adminIp, serverID);
	}
	SQL_TQuery(DB, InsertAddbanCallback, Query, data, DBPriority:0);
	return 0;
}

public InsertAddbanCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	decl admin;
	decl minutes;
	decl String:authid[20];
	decl String:reason[128];
	ResetPack(data, false);
	admin = ReadPackCell(data);
	minutes = ReadPackCell(data);
	ReadPackString(data, reason, 128);
	ReadPackString(data, authid, 20);
	if (error[0])
	{
		LogToFile(logFile, "Add Ban Insert Query Failed: %s", error);
		new var1;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%ssm_addban failed", Prefix);
		}
		return 0;
	}
	LogAction(admin, -1, "\"%L\" added ban (minutes \"%i\") (id \"%s\") (reason \"%s\")", admin, minutes, authid, reason);
	new var2;
	if (admin && IsClientInGame(admin))
	{
		PrintToChat(admin, "%s%s successfully banned", Prefix, authid);
	}
	else
	{
		PrintToServer("%s%s successfully banned", Prefix, authid);
	}
	return 0;
}

public ProcessQueueCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new var1;
	if (hndl && strlen(error) > 0)
	{
		LogToFile(logFile, "Failed to retrieve queued bans from sqlite database, %s", error);
		return 0;
	}
	decl String:auth[32];
	decl time;
	decl startTime;
	decl String:reason[128];
	decl String:name[64];
	decl String:ip[20];
	decl String:adminAuth[32];
	decl String:adminIp[20];
	decl String:query[1024];
	decl String:banName[128];
	decl String:banReason[256];
	while (SQL_MoreRows(hndl))
	{
		if (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, auth, 30, 0);
			time = SQL_FetchInt(hndl, 1, 0);
			startTime = SQL_FetchInt(hndl, 2, 0);
			SQL_FetchString(hndl, 3, reason, 128, 0);
			SQL_FetchString(hndl, 4, name, 64, 0);
			SQL_FetchString(hndl, 5, ip, 20, 0);
			SQL_FetchString(hndl, 6, adminAuth, 30, 0);
			SQL_FetchString(hndl, 7, adminIp, 20, 0);
			SQL_EscapeString(SQLiteDB, name, banName, 128, 0);
			SQL_EscapeString(SQLiteDB, reason, banReason, 256, 0);
			new var2;
			if (time * 60 + startTime > GetTime({0,0}) || time)
			{
				if (serverID == -1)
				{
					FormatEx(query, 1024, "INSERT INTO %s_bans (ip, authid, name, created, ends, length, reason, aid, adminIp, sid) VALUES  ('%s', '%s', '%s', %d, %d, %d, '%s', (SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), '%s', (SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s' LIMIT 0,1))", DatabasePrefix, ip, auth, banName, startTime, time * 60 + startTime, time * 60, banReason, DatabasePrefix, adminAuth, adminAuth[2], adminIp, DatabasePrefix, ServerIp, ServerPort);
				}
				else
				{
					FormatEx(query, 1024, "INSERT INTO %s_bans (ip, authid, name, created, ends, length, reason, aid, adminIp, sid) VALUES  ('%s', '%s', '%s', %d, %d, %d, '%s', (SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), '%s', %d)", DatabasePrefix, ip, auth, banName, startTime, time * 60 + startTime, time * 60, banReason, DatabasePrefix, adminAuth, adminAuth[2], adminIp, serverID);
				}
				new Handle:authPack = CreateDataPack();
				WritePackString(authPack, auth);
				ResetPack(authPack, false);
				SQL_TQuery(DB, AddedFromSQLiteCallback, query, authPack, DBPriority:1);
			}
			else
			{
				FormatEx(query, 1024, "DELETE FROM queue WHERE steam_id = '%s'", auth);
				SQL_TQuery(SQLiteDB, ErrorCheckCallback, query, any:0, DBPriority:1);
			}
		}
	}
	CreateTimer(float(ProcessQueueTime * 60), ProcessQueue, any:0, 0);
	return 0;
}

public AddedFromSQLiteCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	decl String:buffer[512];
	decl String:auth[40];
	ReadPackString(data, auth, 40);
	if (error[0])
	{
		FormatEx(buffer, 512, "banid %d %s", ProcessQueueTime, auth);
		ServerCommand(buffer);
	}
	else
	{
		FormatEx(buffer, 512, "DELETE FROM queue WHERE steam_id = '%s'", auth);
		SQL_TQuery(SQLiteDB, ErrorCheckCallback, buffer, any:0, DBPriority:1);
		RemoveBan(auth, 4, "", any:0);
	}
	CloseHandle(data);
	return 0;
}

public ServerInfoCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (error[0])
	{
		LogToFile(logFile, "Server Select Query Failed: %s", error);
		return 0;
	}
	new var1;
	if (hndl && SQL_GetRowCount(hndl))
	{
		decl String:desc[64];
		decl String:query[200];
		GetGameFolderName(desc, 64);
		FormatEx(query, 200, "INSERT INTO %s_servers (ip, port, rcon, modid) VALUES ('%s', '%s', '', (SELECT mid FROM %s_mods WHERE modfolder = '%s'))", DatabasePrefix, ServerIp, ServerPort, DatabasePrefix, desc);
		SQL_TQuery(DB, ErrorCheckCallback, query, any:0, DBPriority:1);
	}
	return 0;
}

public ErrorCheckCallback(Handle:owner, Handle:hndle, String:error[], any:data)
{
	if (error[0])
	{
		LogToFile(logFile, "Query Failed: %s", error);
	}
	return 0;
}

public VerifyBan(Handle:owner, Handle:hndl, String:error[], any:userid)
{
	decl String:clientName[64];
	decl String:clientAuth[64];
	decl String:clientIp[64];
	new client = GetClientOfUserId(userid);
	if (!client)
	{
		return 0;
	}
	if (hndl)
	{
		GetClientIP(client, clientIp, 64, true);
		GetClientAuthId(client, AuthIdType:1, clientAuth, 64, true);
		GetClientName(client, clientName, 64);
		if (0 < SQL_GetRowCount(hndl))
		{
			decl String:buffer[40];
			decl String:Name[128];
			decl String:Query[512];
			SQL_EscapeString(DB, clientName, Name, 128, 0);
			if (serverID == -1)
			{
				FormatEx(Query, 512, "INSERT INTO %s_banlog (sid ,time ,name ,bid) VALUES  ((SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s' LIMIT 0,1), UNIX_TIMESTAMP(), '%s', (SELECT bid FROM %s_bans WHERE ((type = 0 AND authid REGEXP '^STEAM_[0-9]:%s$') OR (type = 1 AND ip = '%s')) AND RemoveType IS NULL LIMIT 0,1))", DatabasePrefix, DatabasePrefix, ServerIp, ServerPort, Name, DatabasePrefix, clientAuth[2], clientIp);
			}
			else
			{
				FormatEx(Query, 512, "INSERT INTO %s_banlog (sid ,time ,name ,bid) VALUES  (%d, UNIX_TIMESTAMP(), '%s', (SELECT bid FROM %s_bans WHERE ((type = 0 AND authid REGEXP '^STEAM_[0-9]:%s$') OR (type = 1 AND ip = '%s')) AND RemoveType IS NULL LIMIT 0,1))", DatabasePrefix, serverID, Name, DatabasePrefix, clientAuth[2], clientIp);
			}
			SQL_TQuery(DB, ErrorCheckCallback, Query, client, DBPriority:0);
			FormatEx(buffer, 40, "banid 5 %s", clientAuth);
			ServerCommand(buffer);
			KickClient(client, "%t", "Banned Check Site", WebsiteAddress);
			return 0;
		}
		PlayerStatus[client] = 1;
		return 0;
	}
	LogToFile(logFile, "Verify Ban Query Failed: %s", error);
	PlayerRecheck[client] = CreateTimer(RetryTime, ClientRecheck, client, 0);
	return 0;
}

public AdminsDone(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new var1;
	if (hndl && strlen(error) > 0)
	{
		curLoading -= 1;
		.45528.CheckLoadAdmins();
		LogToFile(logFile, "Failed to retrieve admins from the database, %s", error);
		return 0;
	}
	new String:authType[8] = "steam";
	decl String:identity[68];
	decl String:password[68];
	decl String:groups[256];
	decl String:flags[32];
	decl String:name[68];
	new admCount;
	new Immunity;
	new AdminId:curAdm = -1;
	new Handle:adminsKV = CreateKeyValues("Admins", "", "");
	while (SQL_MoreRows(hndl))
	{
		SQL_FetchRow(hndl);
		if (!(SQL_IsFieldNull(hndl, 0)))
		{
			SQL_FetchString(hndl, 0, identity, 66, 0);
			SQL_FetchString(hndl, 1, password, 66, 0);
			SQL_FetchString(hndl, 2, groups, 256, 0);
			SQL_FetchString(hndl, 3, flags, 32, 0);
			SQL_FetchString(hndl, 4, name, 66, 0);
			Immunity = SQL_FetchInt(hndl, 5, 0);
			TrimString(name);
			TrimString(identity);
			TrimString(groups);
			TrimString(flags);
			if (backupConfig)
			{
				KvJumpToKey(adminsKV, name, true);
				KvSetString(adminsKV, "auth", authType);
				KvSetString(adminsKV, "identity", identity);
				if (0 < strlen(flags))
				{
					KvSetString(adminsKV, "flags", flags);
				}
				if (0 < strlen(groups))
				{
					KvSetString(adminsKV, "group", groups);
				}
				if (0 < strlen(password))
				{
					KvSetString(adminsKV, "password", password);
				}
				if (0 < Immunity)
				{
					KvSetNum(adminsKV, "immunity", Immunity);
				}
				KvRewind(adminsKV);
			}
			if ((curAdm = FindAdminByIdentity(authType, identity)) == -1)
			{
				curAdm = CreateAdmin(name);
				if (!BindAdminIdentity(curAdm, authType, identity))
				{
					LogToFile(logFile, "Unable to bind admin %s to identity %s", name, identity);
					RemoveAdmin(curAdm);
				}
			}
			new curPos;
			new GroupId:curGrp = -1;
			new numGroups;
			decl String:iterGroupName[64];
			if (strcmp(groups[curPos], "", true))
			{
				curGrp = FindAdmGroup(groups[curPos]);
				if (curGrp == GroupId:-1)
				{
					LogToFile(logFile, "Unknown group \"%s\"", groups[curPos]);
				}
				numGroups = GetAdminGroupCount(curAdm);
				new i;
				while (i < numGroups)
				{
					GetAdminGroup(curAdm, i, iterGroupName, 64);
					if (.2920.StrEqual(iterGroupName, groups[curPos], true))
					{
						numGroups = -2;
						new var2;
						if (numGroups != -2 && !AdminInheritGroup(curAdm, curGrp))
						{
							LogToFile(logFile, "Unable to inherit group \"%s\"", groups[curPos]);
						}
						if (GetAdminImmunityLevel(curAdm) < Immunity)
						{
							SetAdminImmunityLevel(curAdm, Immunity);
						}
					}
					i++;
				}
				new var2;
				if (numGroups != -2 && !AdminInheritGroup(curAdm, curGrp))
				{
					LogToFile(logFile, "Unable to inherit group \"%s\"", groups[curPos]);
				}
				if (GetAdminImmunityLevel(curAdm) < Immunity)
				{
					SetAdminImmunityLevel(curAdm, Immunity);
				}
			}
			if (0 < strlen(password))
			{
				SetAdminPassword(curAdm, password);
			}
			new i;
			while (strlen(flags) > i)
			{
				new var3;
				if (flags[i] < 'a' || flags[i] > 'z')
				{
				}
				else
				{
					if (!(AdminFlag:0 > g_FlagLetters[flags[i] + -97]))
					{
						SetAdminFlag(curAdm, g_FlagLetters[flags[i] + -97], true);
					}
				}
				i++;
			}
			admCount++;
		}
	}
	if (backupConfig)
	{
		KeyValuesToFile(adminsKV, adminsLoc);
	}
	CloseHandle(adminsKV);
	curLoading -= 1;
	.45528.CheckLoadAdmins();
	return 0;
}

public GroupsDone(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		decl String:grpName[128];
		decl String:immuneGrpName[128];
		decl String:grpFlags[32];
		new Immunity;
		new grpCount;
		new Handle:groupsKV = CreateKeyValues("Groups", "", "");
		new GroupId:curGrp = -1;
		while (SQL_MoreRows(hndl))
		{
			SQL_FetchRow(hndl);
			if (!(SQL_IsFieldNull(hndl, 0)))
			{
				SQL_FetchString(hndl, 0, grpName, 128, 0);
				SQL_FetchString(hndl, 1, grpFlags, 32, 0);
				Immunity = SQL_FetchInt(hndl, 2, 0);
				SQL_FetchString(hndl, 3, immuneGrpName, 128, 0);
				TrimString(grpName);
				TrimString(grpFlags);
				TrimString(immuneGrpName);
				if (strlen(grpName))
				{
					curGrp = CreateAdmGroup(grpName);
					if (backupConfig)
					{
						KvJumpToKey(groupsKV, grpName, true);
						if (0 < strlen(grpFlags))
						{
							KvSetString(groupsKV, "flags", grpFlags);
						}
						if (0 < Immunity)
						{
							KvSetNum(groupsKV, "immunity", Immunity);
						}
						KvRewind(groupsKV);
					}
					if (curGrp == GroupId:-1)
					{
						curGrp = FindAdmGroup(grpName);
					}
					new i;
					while (strlen(grpFlags) > i)
					{
						new var1;
						if (grpFlags[i] < 'a' || grpFlags[i] > 'z')
						{
						}
						else
						{
							if (!(AdminFlag:0 > g_FlagLetters[grpFlags[i] + -97]))
							{
								SetAdmGroupAddFlag(curGrp, g_FlagLetters[grpFlags[i] + -97], true);
							}
						}
						i++;
					}
					if (0 < Immunity)
					{
						SetAdmGroupImmunityLevel(curGrp, Immunity);
					}
					grpCount++;
				}
			}
		}
		if (backupConfig)
		{
			KeyValuesToFile(groupsKV, groupsLoc);
		}
		CloseHandle(groupsKV);
		decl String:query[512];
		FormatEx(query, 512, "SELECT sg.name, so.type, so.name, so.access FROM %s_srvgroups_overrides so LEFT JOIN %s_srvgroups sg ON sg.id = so.group_id ORDER BY sg.id", DatabasePrefix, DatabasePrefix);
		SQL_TQuery(DB, LoadGroupsOverrides, query, any:0, DBPriority:1);
		return 0;
	}
	curLoading -= 1;
	.45528.CheckLoadAdmins();
	LogToFile(logFile, "Failed to retrieve groups from the database, %s", error);
	return 0;
}

public GroupsSecondPass(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		decl String:grpName[128];
		decl String:immunityGrpName[128];
		new GroupId:curGrp = -1;
		new GroupId:immuneGrp = -1;
		while (SQL_MoreRows(hndl))
		{
			SQL_FetchRow(hndl);
			if (!(SQL_IsFieldNull(hndl, 0)))
			{
				SQL_FetchString(hndl, 0, grpName, 128, 0);
				TrimString(grpName);
				if (strlen(grpName))
				{
					SQL_FetchString(hndl, 2, immunityGrpName, 128, 0);
					TrimString(immunityGrpName);
					curGrp = FindAdmGroup(grpName);
					if (!(curGrp == GroupId:-1))
					{
						immuneGrp = FindAdmGroup(immunityGrpName);
						if (!(immuneGrp == GroupId:-1))
						{
							SetAdmGroupImmuneFrom(curGrp, immuneGrp);
						}
					}
				}
			}
		}
		curLoading -= 1;
		.45528.CheckLoadAdmins();
		return 0;
	}
	curLoading -= 1;
	.45528.CheckLoadAdmins();
	LogToFile(logFile, "Failed to retrieve groups from the database, %s", error);
	return 0;
}

public LoadGroupsOverrides(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		decl String:sGroupName[128];
		decl String:sType[16];
		decl String:sCommand[64];
		decl String:sAllowed[16];
		decl OverrideRule:iRule;
		decl OverrideType:iType;
		new Handle:groupsKV = CreateKeyValues("Groups", "", "");
		FileToKeyValues(groupsKV, groupsLoc);
		new GroupId:curGrp = -1;
		while (SQL_MoreRows(hndl))
		{
			SQL_FetchRow(hndl);
			if (!(SQL_IsFieldNull(hndl, 0)))
			{
				SQL_FetchString(hndl, 0, sGroupName, 128, 0);
				TrimString(sGroupName);
				if (strlen(sGroupName))
				{
					SQL_FetchString(hndl, 1, sType, 16, 0);
					SQL_FetchString(hndl, 2, sCommand, 64, 0);
					SQL_FetchString(hndl, 3, sAllowed, 16, 0);
					curGrp = FindAdmGroup(sGroupName);
					if (!(curGrp == GroupId:-1))
					{
						new var1;
						if (.2920.StrEqual(sAllowed, "allow", true))
						{
							var1 = 1;
						}
						else
						{
							var1 = 0;
						}
						iRule = var1;
						new var2;
						if (.2920.StrEqual(sType, "group", true))
						{
							var2 = 2;
						}
						else
						{
							var2 = 1;
						}
						iType = var2;
						if (KvJumpToKey(groupsKV, sGroupName, false))
						{
							KvJumpToKey(groupsKV, "Overrides", true);
							if (iType == OverrideType:1)
							{
								KvSetString(groupsKV, sCommand, sAllowed);
							}
							else
							{
								Format(sCommand, 64, "@%s", sCommand);
								KvSetString(groupsKV, sCommand, sAllowed);
							}
							KvRewind(groupsKV);
						}
						AddAdmGroupCmdOverride(curGrp, sCommand, iType, iRule);
					}
				}
			}
		}
		curLoading -= 1;
		.45528.CheckLoadAdmins();
		if (backupConfig)
		{
			KeyValuesToFile(groupsKV, groupsLoc);
		}
		CloseHandle(groupsKV);
		return 0;
	}
	curLoading -= 1;
	.45528.CheckLoadAdmins();
	LogToFile(logFile, "Failed to retrieve group overrides from the database, %s", error);
	return 0;
}

public OverridesDone(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		new Handle:hKV = CreateKeyValues("SB_Overrides", "", "");
		decl String:sFlags[32];
		decl String:sName[64];
		decl String:sType[64];
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, sType, 64, 0);
			SQL_FetchString(hndl, 1, sName, 64, 0);
			SQL_FetchString(hndl, 2, sFlags, 32, 0);
			if (!sFlags[0])
			{
				sFlags[0] = MissingTAG:32;
				sFlags[0] = MissingTAG:0;
			}
			if (.2920.StrEqual(sType, "command", true))
			{
				AddCommandOverride(sName, OverrideType:1, ReadFlagString(sFlags, 0));
				KvJumpToKey(hKV, "override_commands", true);
				KvSetString(hKV, sName, sFlags);
				KvGoBack(hKV);
			}
			else
			{
				if (.2920.StrEqual(sType, "group", true))
				{
					AddCommandOverride(sName, OverrideType:2, ReadFlagString(sFlags, 0));
					KvJumpToKey(hKV, "override_groups", true);
					KvSetString(hKV, sName, sFlags);
					KvGoBack(hKV);
				}
			}
		}
		KvRewind(hKV);
		if (backupConfig)
		{
			KeyValuesToFile(hKV, overridesLoc);
		}
		CloseHandle(hKV);
		return 0;
	}
	LogToFile(logFile, "Failed to retrieve overrides from the database, %s", error);
	.47792.ParseBackupConfig_Overrides();
	return 0;
}

public Action:ClientRecheck(Handle:timer, any:client)
{
	decl String:Authid[64];
	new var1;
	if (!PlayerStatus[client] && IsClientConnected(client) && GetClientAuthId(client, AuthIdType:1, Authid, 64, true))
	{
		OnClientAuthorized(client, Authid);
	}
	PlayerRecheck[client] = 0;
	return Action:4;
}

public Action:ProcessQueue(Handle:timer, any:data)
{
	decl String:buffer[512];
	Format(buffer, 512, "SELECT steam_id, time, start_time, reason, name, ip, admin_id, admin_ip FROM queue");
	SQL_TQuery(SQLiteDB, ProcessQueueCallback, buffer, any:0, DBPriority:1);
	return Action:0;
}

public .39264.InitializeConfigParser()
{
	if (!ConfigParser)
	{
		ConfigParser = SMC_CreateParser();
		SMC_SetReaders(ConfigParser, ReadConfig_NewSection, ReadConfig_KeyValue, ReadConfig_EndSection);
	}
	return 0;
}

public .39264.InitializeConfigParser()
{
	if (!ConfigParser)
	{
		ConfigParser = SMC_CreateParser();
		SMC_SetReaders(ConfigParser, ReadConfig_NewSection, ReadConfig_KeyValue, ReadConfig_EndSection);
	}
	return 0;
}

public .39384.InternalReadConfig(String:path[])
{
	ConfigState = MissingTAG:0;
	new SMCError:err = SMC_ParseFile(ConfigParser, path, 0, 0);
	if (err)
	{
		decl String:buffer[64];
		new var1;
		if (SMC_GetErrorString(err, buffer, 64))
		{
			var1[0] = buffer;
		}
		else
		{
			var1[0] = 14380;
		}
		PrintToServer("%s", var1);
	}
	return 0;
}

public .39384.InternalReadConfig(String:path[])
{
	ConfigState = MissingTAG:0;
	new SMCError:err = SMC_ParseFile(ConfigParser, path, 0, 0);
	if (err)
	{
		decl String:buffer[64];
		new var1;
		if (SMC_GetErrorString(err, buffer, 64))
		{
			var1[0] = buffer;
		}
		else
		{
			var1[0] = 14380;
		}
		PrintToServer("%s", var1);
	}
	return 0;
}

public SMCResult:ReadConfig_NewSection(Handle:smc, String:name[], bool:opt_quotes)
{
	if (name[0])
	{
		if (strcmp("Config", name, false))
		{
			if (strcmp("BanReasons", name, false))
			{
				if (!(strcmp("HackingReasons", name, false)))
				{
					ConfigState = MissingTAG:3;
				}
			}
			ConfigState = MissingTAG:2;
		}
		ConfigState = MissingTAG:1;
	}
	return SMCResult:0;
}

public SMCResult:ReadConfig_KeyValue(Handle:smc, String:key[], String:value[], bool:key_quotes, bool:value_quotes)
{
	if (!key[0])
	{
		return SMCResult:0;
	}
	switch (ConfigState)
	{
		case 1:
		{
			if (strcmp("website", key, false))
			{
				if (strcmp("Addban", key, false))
				{
					if (strcmp("AutoAddServer", key, false))
					{
						if (strcmp("Unban", key, false))
						{
							if (strcmp("DatabasePrefix", key, false))
							{
								if (strcmp("RetryTime", key, false))
								{
									if (strcmp("ProcessQueueTime", key, false))
									{
										if (strcmp("BackupConfigs", key, false))
										{
											if (strcmp("EnableAdmins", key, false))
											{
												if (strcmp("RequireSiteLogin", key, false))
												{
													if (!(strcmp("ServerID", key, false)))
													{
														serverID = StringToInt(value, 10);
													}
												}
												requireSiteLogin = StringToInt(value, 10) == 1;
											}
											enableAdmins = StringToInt(value, 10) == 1;
										}
										backupConfig = StringToInt(value, 10) == 1;
									}
									ProcessQueueTime = StringToInt(value, 10);
								}
								RetryTime = StringToFloat(value);
								if (RetryTime < 15.0)
								{
									RetryTime = 15.0;
								}
								else
								{
									if (RetryTime > 60.0)
									{
										RetryTime = 60.0;
									}
								}
							}
							strcopy(DatabasePrefix, 10, value);
							if (DatabasePrefix[0])
							{
							}
						}
						if (StringToInt(value, 10))
						{
						}
						else
						{
							CommandDisable = CommandDisable | 2;
						}
					}
					AutoAdd = StringToInt(value, 10) == 1;
				}
				if (StringToInt(value, 10))
				{
				}
				else
				{
					CommandDisable = CommandDisable | 1;
				}
			}
			else
			{
				strcopy(WebsiteAddress, 128, value);
			}
		}
		case 2:
		{
			if (ReasonMenuHandle)
			{
				AddMenuItem(ReasonMenuHandle, key, value, 0);
			}
		}
		case 3:
		{
			if (HackingMenuHandle)
			{
				AddMenuItem(HackingMenuHandle, key, value, 0);
			}
		}
		default:
		{
		}
	}
	return SMCResult:0;
}

public SMCResult:ReadConfig_EndSection(Handle:smc)
{
	return SMCResult:0;
}

public Native_SBBanPlayer(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new target = GetNativeCell(2);
	new time = GetNativeCell(3);
	decl String:reason[128];
	GetNativeString(4, reason, 128, 0);
	if (!reason[0])
	{
		strcopy(reason, 128, "Banned by SourceBans");
	}
	new var1;
	if (client && IsClientInGame(client))
	{
		new AdminId:aid = GetUserAdmin(client);
		if (aid == AdminId:-1)
		{
			ThrowNativeError(1, "Ban Error: Player is not an admin.");
			return 0;
		}
		if (!GetAdminFlag(aid, AdminFlag:3, AdmAccessMode:1))
		{
			ThrowNativeError(2, "Ban Error: Player does not have BAN flag.");
			return 0;
		}
	}
	.46364.PrepareBan(client, target, time, reason, 128);
	return 1;
}

public InitializeBackupDB()
{
	decl String:error[256];
	SQLiteDB = .2972.SQLite_UseDatabase("sourcebans-queue", error, 255);
	if (!SQLiteDB)
	{
		SetFailState(error);
	}
	SQL_LockDatabase(SQLiteDB);
	SQL_FastQuery(SQLiteDB, "CREATE TABLE IF NOT EXISTS queue (steam_id TEXT PRIMARY KEY ON CONFLICT REPLACE, time INTEGER, start_time INTEGER, reason TEXT, name TEXT, ip TEXT, admin_id TEXT, admin_ip TEXT);", -1);
	SQL_UnlockDatabase(SQLiteDB);
	return 0;
}

public bool:CreateBan(client, target, time, String:reason[])
{
	decl String:adminIp[24];
	decl String:adminAuth[64];
	new admin = client;
	if (!admin)
	{
		if (reason[0])
		{
			strcopy(adminAuth, 64, "STEAM_ID_SERVER");
			strcopy(adminIp, 24, ServerIp);
		}
		PrintToServer("%s%T", Prefix, "Include Reason", 0);
		return false;
	}
	else
	{
		GetClientIP(admin, adminIp, 24, true);
		GetClientAuthId(admin, AuthIdType:1, adminAuth, 64, true);
	}
	decl String:ip[24];
	decl String:auth[64];
	decl String:name[64];
	GetClientName(target, name, 64);
	GetClientIP(target, ip, 24, true);
	if (!GetClientAuthId(target, AuthIdType:1, auth, 64, true))
	{
		return false;
	}
	decl userid;
	new var1;
	if (admin)
	{
		var1 = GetClientUserId(admin);
	}
	else
	{
		var1 = 0;
	}
	userid = var1;
	new Handle:dataPack = CreateDataPack();
	new Handle:reasonPack = CreateDataPack();
	WritePackString(reasonPack, reason);
	WritePackCell(dataPack, admin);
	WritePackCell(dataPack, target);
	WritePackCell(dataPack, userid);
	WritePackCell(dataPack, GetClientUserId(target));
	WritePackCell(dataPack, time);
	WritePackCell(dataPack, reasonPack);
	WritePackString(dataPack, name);
	WritePackString(dataPack, auth);
	WritePackString(dataPack, ip);
	WritePackString(dataPack, adminAuth);
	WritePackString(dataPack, adminIp);
	ResetPack(dataPack, false);
	ResetPack(reasonPack, false);
	if (reason[0])
	{
		if (DB)
		{
			.44008.UTIL_InsertBan(time, name, auth, ip, reason, adminAuth, adminIp, dataPack);
		}
		else
		{
			.44708.UTIL_InsertTempBan(time, name, auth, ip, reason, adminAuth, adminIp, dataPack);
		}
	}
	else
	{
		PlayerDataPack[admin] = dataPack;
		DisplayMenu(ReasonMenuHandle, admin, 0);
		ReplyToCommand(admin, "%c[%cSourceBans++%c]%c %t", '\x04', '\x02', '\x04', '\x02', "Check Menu");
	}
	return true;
}

public .44008.UTIL_InsertBan(time, String:Name[], String:Authid[], String:Ip[], String:Reason[], String:AdminAuthid[], String:AdminIp[], Handle:Pack)
{
	decl String:banName[128];
	decl String:banReason[256];
	decl String:Query[1024];
	SQL_EscapeString(DB, Name, banName, 128, 0);
	SQL_EscapeString(DB, Reason, banReason, 256, 0);
	if (serverID == -1)
	{
		FormatEx(Query, 1024, "INSERT INTO %s_bans (ip, authid, name, created, ends, length, reason, aid, adminIp, sid, country) VALUES ('%s', '%s', '%s', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', IFNULL((SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'),'0'), '%s', (SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s' LIMIT 0,1), ' ')", DatabasePrefix, Ip, Authid, banName, time * 60, time * 60, banReason, DatabasePrefix, AdminAuthid, AdminAuthid[2], AdminIp, DatabasePrefix, ServerIp, ServerPort);
	}
	else
	{
		FormatEx(Query, 1024, "INSERT INTO %s_bans (ip, authid, name, created, ends, length, reason, aid, adminIp, sid, country) VALUES ('%s', '%s', '%s', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', IFNULL((SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'),'0'), '%s', %d, ' ')", DatabasePrefix, Ip, Authid, banName, time * 60, time * 60, banReason, DatabasePrefix, AdminAuthid, AdminAuthid[2], AdminIp, serverID);
	}
	SQL_TQuery(DB, VerifyInsert, Query, Pack, DBPriority:0);
	return 0;
}

public .44008.UTIL_InsertBan(time, String:Name[], String:Authid[], String:Ip[], String:Reason[], String:AdminAuthid[], String:AdminIp[], Handle:Pack)
{
	decl String:banName[128];
	decl String:banReason[256];
	decl String:Query[1024];
	SQL_EscapeString(DB, Name, banName, 128, 0);
	SQL_EscapeString(DB, Reason, banReason, 256, 0);
	if (serverID == -1)
	{
		FormatEx(Query, 1024, "INSERT INTO %s_bans (ip, authid, name, created, ends, length, reason, aid, adminIp, sid, country) VALUES ('%s', '%s', '%s', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', IFNULL((SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'),'0'), '%s', (SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s' LIMIT 0,1), ' ')", DatabasePrefix, Ip, Authid, banName, time * 60, time * 60, banReason, DatabasePrefix, AdminAuthid, AdminAuthid[2], AdminIp, DatabasePrefix, ServerIp, ServerPort);
	}
	else
	{
		FormatEx(Query, 1024, "INSERT INTO %s_bans (ip, authid, name, created, ends, length, reason, aid, adminIp, sid, country) VALUES ('%s', '%s', '%s', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', IFNULL((SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'),'0'), '%s', %d, ' ')", DatabasePrefix, Ip, Authid, banName, time * 60, time * 60, banReason, DatabasePrefix, AdminAuthid, AdminAuthid[2], AdminIp, serverID);
	}
	SQL_TQuery(DB, VerifyInsert, Query, Pack, DBPriority:0);
	return 0;
}

public .44708.UTIL_InsertTempBan(time, String:name[], String:auth[], String:ip[], String:reason[], String:adminAuth[], String:adminIp[], Handle:dataPack)
{
	ReadPackCell(dataPack);
	new client = ReadPackCell(dataPack);
	ReadPackCell(dataPack);
	ReadPackCell(dataPack);
	ReadPackCell(dataPack);
	new Handle:reasonPack = ReadPackCell(dataPack);
	if (reasonPack)
	{
		CloseHandle(reasonPack);
	}
	CloseHandle(dataPack);
	decl String:buffer[52];
	Format(buffer, 50, "banid %d %s", ProcessQueueTime, auth);
	ServerCommand(buffer);
	if (IsClientInGame(client))
	{
		KickClient(client, "%t", "Banned Check Site", WebsiteAddress);
	}
	decl String:banName[128];
	decl String:banReason[256];
	decl String:query[512];
	SQL_EscapeString(SQLiteDB, name, banName, 128, 0);
	SQL_EscapeString(SQLiteDB, reason, banReason, 256, 0);
	FormatEx(query, 512, "INSERT INTO queue VALUES ('%s', %i, %i, '%s', '%s', '%s', '%s', '%s')", auth, time, GetTime({0,0}), banReason, banName, ip, adminAuth, adminIp);
	SQL_TQuery(SQLiteDB, ErrorCheckCallback, query, any:0, DBPriority:1);
	return 0;
}

public .44708.UTIL_InsertTempBan(time, String:name[], String:auth[], String:ip[], String:reason[], String:adminAuth[], String:adminIp[], Handle:dataPack)
{
	ReadPackCell(dataPack);
	new client = ReadPackCell(dataPack);
	ReadPackCell(dataPack);
	ReadPackCell(dataPack);
	ReadPackCell(dataPack);
	new Handle:reasonPack = ReadPackCell(dataPack);
	if (reasonPack)
	{
		CloseHandle(reasonPack);
	}
	CloseHandle(dataPack);
	decl String:buffer[52];
	Format(buffer, 50, "banid %d %s", ProcessQueueTime, auth);
	ServerCommand(buffer);
	if (IsClientInGame(client))
	{
		KickClient(client, "%t", "Banned Check Site", WebsiteAddress);
	}
	decl String:banName[128];
	decl String:banReason[256];
	decl String:query[512];
	SQL_EscapeString(SQLiteDB, name, banName, 128, 0);
	SQL_EscapeString(SQLiteDB, reason, banReason, 256, 0);
	FormatEx(query, 512, "INSERT INTO queue VALUES ('%s', %i, %i, '%s', '%s', '%s', '%s', '%s')", auth, time, GetTime({0,0}), banReason, banName, ip, adminAuth, adminIp);
	SQL_TQuery(SQLiteDB, ErrorCheckCallback, query, any:0, DBPriority:1);
	return 0;
}

public .45528.CheckLoadAdmins()
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && IsClientAuthorized(i))
		{
			RunAdminCacheChecks(i);
			NotifyPostAdminCheck(i);
		}
		i++;
	}
	return 0;
}

public .45528.CheckLoadAdmins()
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && IsClientAuthorized(i))
		{
			RunAdminCacheChecks(i);
			NotifyPostAdminCheck(i);
		}
		i++;
	}
	return 0;
}

public .45752.InsertServerInfo()
{
	if (DB)
	{
		decl String:query[100];
		decl pieces[4];
		new longip = GetConVarInt(CvarHostIp);
		pieces[0] = longip >>> 24 & 255;
		pieces[1] = longip >>> 16 & 255;
		pieces[2] = longip >>> 8 & 255;
		pieces[3] = longip & 255;
		FormatEx(ServerIp, 24, "%d.%d.%d.%d", pieces, pieces[1], pieces[2], pieces[3]);
		GetConVarString(CvarPort, ServerPort, 7);
		if (AutoAdd)
		{
			FormatEx(query, 100, "SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s'", DatabasePrefix, ServerIp, ServerPort);
			SQL_TQuery(DB, ServerInfoCallback, query, any:0, DBPriority:1);
		}
		return 0;
	}
	return 0;
}

public .45752.InsertServerInfo()
{
	if (DB)
	{
		decl String:query[100];
		decl pieces[4];
		new longip = GetConVarInt(CvarHostIp);
		pieces[0] = longip >>> 24 & 255;
		pieces[1] = longip >>> 16 & 255;
		pieces[2] = longip >>> 8 & 255;
		pieces[3] = longip & 255;
		FormatEx(ServerIp, 24, "%d.%d.%d.%d", pieces, pieces[1], pieces[2], pieces[3]);
		GetConVarString(CvarPort, ServerPort, 7);
		if (AutoAdd)
		{
			FormatEx(query, 100, "SELECT sid FROM %s_servers WHERE ip = '%s' AND port = '%s'", DatabasePrefix, ServerIp, ServerPort);
			SQL_TQuery(DB, ServerInfoCallback, query, any:0, DBPriority:1);
		}
		return 0;
	}
	return 0;
}

public .46364.PrepareBan(client, target, time, String:reason[], size)
{
	new var1;
	if (!target || !IsClientInGame(target))
	{
		return 0;
	}
	decl String:authid[64];
	decl String:name[32];
	decl String:bannedSite[512];
	if (!GetClientAuthId(target, AuthIdType:1, authid, 64, true))
	{
		return 0;
	}
	GetClientName(target, name, 32);
	if (CreateBan(client, target, time, reason))
	{
		if (!time)
		{
			if (reason[0])
			{
				ShowActivity(client, "%t", "Permabanned player reason", name, reason);
			}
			else
			{
				ShowActivity(client, "%t", "Permabanned player", name);
			}
		}
		else
		{
			if (reason[0])
			{
				ShowActivity(client, "%t", "Banned player reason", name, time, reason);
			}
			ShowActivity(client, "%t", "Banned player", name, time);
		}
		LogAction(client, target, "\"%L\" banned \"%L\" (minutes \"%d\") (reason \"%s\")", client, target, time, reason);
		new var2;
		if (time > 5 || time)
		{
			time = 5;
		}
		Format(bannedSite, 512, "%T", "Banned Check Site", target, WebsiteAddress);
		BanClient(target, time, 1, bannedSite, bannedSite, "sm_ban", client);
	}
	g_BanTarget[client] = -1;
	g_BanTime[client] = -1;
	return 0;
}

public .46364.PrepareBan(client, target, time, String:reason[], size)
{
	new var1;
	if (!target || !IsClientInGame(target))
	{
		return 0;
	}
	decl String:authid[64];
	decl String:name[32];
	decl String:bannedSite[512];
	if (!GetClientAuthId(target, AuthIdType:1, authid, 64, true))
	{
		return 0;
	}
	GetClientName(target, name, 32);
	if (CreateBan(client, target, time, reason))
	{
		if (!time)
		{
			if (reason[0])
			{
				ShowActivity(client, "%t", "Permabanned player reason", name, reason);
			}
			else
			{
				ShowActivity(client, "%t", "Permabanned player", name);
			}
		}
		else
		{
			if (reason[0])
			{
				ShowActivity(client, "%t", "Banned player reason", name, time, reason);
			}
			ShowActivity(client, "%t", "Banned player", name, time);
		}
		LogAction(client, target, "\"%L\" banned \"%L\" (minutes \"%d\") (reason \"%s\")", client, target, time, reason);
		new var2;
		if (time > 5 || time)
		{
			time = 5;
		}
		Format(bannedSite, 512, "%T", "Banned Check Site", target, WebsiteAddress);
		BanClient(target, time, 1, bannedSite, bannedSite, "sm_ban", client);
	}
	g_BanTarget[client] = -1;
	g_BanTime[client] = -1;
	return 0;
}

public .47356.ReadConfig()
{
	.39264.InitializeConfigParser();
	if (ConfigParser)
	{
		decl String:ConfigFile[256];
		BuildPath(PathType:0, ConfigFile, 256, "configs/sourcebans/sourcebans.cfg");
		if (FileExists(ConfigFile, false, "GAME"))
		{
			.39384.InternalReadConfig(ConfigFile);
			PrintToServer("%sLoading configs/sourcebans.cfg config file", Prefix);
		}
		else
		{
			decl String:Error[320];
			FormatEx(Error, 320, "%sFATAL *** ERROR *** can not find %s", Prefix, ConfigFile);
			LogToFile(logFile, "FATAL *** ERROR *** can not find %s", ConfigFile);
			SetFailState(Error);
		}
		return 0;
	}
	return 0;
}

public .47356.ReadConfig()
{
	.39264.InitializeConfigParser();
	if (ConfigParser)
	{
		decl String:ConfigFile[256];
		BuildPath(PathType:0, ConfigFile, 256, "configs/sourcebans/sourcebans.cfg");
		if (FileExists(ConfigFile, false, "GAME"))
		{
			.39384.InternalReadConfig(ConfigFile);
			PrintToServer("%sLoading configs/sourcebans.cfg config file", Prefix);
		}
		else
		{
			decl String:Error[320];
			FormatEx(Error, 320, "%sFATAL *** ERROR *** can not find %s", Prefix, ConfigFile);
			LogToFile(logFile, "FATAL *** ERROR *** can not find %s", ConfigFile);
			SetFailState(Error);
		}
		return 0;
	}
	return 0;
}

public .47724.ResetSettings()
{
	CommandDisable = 0;
	.17824.ResetMenu();
	.47356.ReadConfig();
	return 0;
}

public .47724.ResetSettings()
{
	CommandDisable = 0;
	.17824.ResetMenu();
	.47356.ReadConfig();
	return 0;
}

public .47792.ParseBackupConfig_Overrides()
{
	new Handle:hKV = CreateKeyValues("SB_Overrides", "", "");
	if (!FileToKeyValues(hKV, overridesLoc))
	{
		return 0;
	}
	if (!KvGotoFirstSubKey(hKV, true))
	{
		return 0;
	}
	decl String:sSection[16];
	decl String:sFlags[32];
	decl String:sName[64];
	decl OverrideType:type;
	do {
		KvGetSectionName(hKV, sSection, 16);
		if (.2920.StrEqual(sSection, "override_commands", true))
		{
			type = MissingTAG:1;
		}
		else
		{
			if (.2920.StrEqual(sSection, "override_groups", true))
			{
				type = MissingTAG:2;
			}
		}
		if (KvGotoFirstSubKey(hKV, false))
		{
			do {
				KvGetSectionName(hKV, sName, 64);
				KvGetString(hKV, NULL_STRING, sFlags, 32, "");
				AddCommandOverride(sName, type, ReadFlagString(sFlags, 0));
			} while (KvGotoNextKey(hKV, false));
			KvGoBack(hKV);
		}
	} while (KvGotoNextKey(hKV, true));
	CloseHandle(hKV);
	return 0;
}

public .47792.ParseBackupConfig_Overrides()
{
	new Handle:hKV = CreateKeyValues("SB_Overrides", "", "");
	if (!FileToKeyValues(hKV, overridesLoc))
	{
		return 0;
	}
	if (!KvGotoFirstSubKey(hKV, true))
	{
		return 0;
	}
	decl String:sSection[16];
	decl String:sFlags[32];
	decl String:sName[64];
	decl OverrideType:type;
	do {
		KvGetSectionName(hKV, sSection, 16);
		if (.2920.StrEqual(sSection, "override_commands", true))
		{
			type = MissingTAG:1;
		}
		else
		{
			if (.2920.StrEqual(sSection, "override_groups", true))
			{
				type = MissingTAG:2;
			}
		}
		if (KvGotoFirstSubKey(hKV, false))
		{
			do {
				KvGetSectionName(hKV, sName, 64);
				KvGetString(hKV, NULL_STRING, sFlags, 32, "");
				AddCommandOverride(sName, type, ReadFlagString(sFlags, 0));
			} while (KvGotoNextKey(hKV, false));
			KvGoBack(hKV);
		}
	} while (KvGotoNextKey(hKV, true));
	CloseHandle(hKV);
	return 0;
}

public .48596.CreateFlagLetters(_arg0)
{
	new AdminFlag:FlagLetters[26];
	FlagLetters + 4/* ERROR unknown load Binary */ = 1;
	FlagLetters + 8/* ERROR unknown load Binary */ = 2;
	FlagLetters + 12/* ERROR unknown load Binary */ = 3;
	FlagLetters + 16/* ERROR unknown load Binary */ = 4;
	FlagLetters + 20/* ERROR unknown load Binary */ = 5;
	FlagLetters + 24/* ERROR unknown load Binary */ = 6;
	FlagLetters + 28/* ERROR unknown load Binary */ = 7;
	FlagLetters + 32/* ERROR unknown load Binary */ = 8;
	FlagLetters + 36/* ERROR unknown load Binary */ = 9;
	FlagLetters + 40/* ERROR unknown load Binary */ = 10;
	FlagLetters + 44/* ERROR unknown load Binary */ = 11;
	FlagLetters + 48/* ERROR unknown load Binary */ = 12;
	FlagLetters + 52/* ERROR unknown load Binary */ = 13;
	FlagLetters + 56/* ERROR unknown load Binary */ = 15;
	FlagLetters + 60/* ERROR unknown load Binary */ = 16;
	FlagLetters + 64/* ERROR unknown load Binary */ = 17;
	FlagLetters + 68/* ERROR unknown load Binary */ = 18;
	FlagLetters + 72/* ERROR unknown load Binary */ = 19;
	FlagLetters + 76/* ERROR unknown load Binary */ = 20;
	FlagLetters + 100/* ERROR unknown load Binary */ = 14;
	return FlagLetters;
}

public .48596.CreateFlagLetters(_arg0)
{
	new AdminFlag:FlagLetters[26];
	FlagLetters + 4/* ERROR unknown load Binary */ = 1;
	FlagLetters + 8/* ERROR unknown load Binary */ = 2;
	FlagLetters + 12/* ERROR unknown load Binary */ = 3;
	FlagLetters + 16/* ERROR unknown load Binary */ = 4;
	FlagLetters + 20/* ERROR unknown load Binary */ = 5;
	FlagLetters + 24/* ERROR unknown load Binary */ = 6;
	FlagLetters + 28/* ERROR unknown load Binary */ = 7;
	FlagLetters + 32/* ERROR unknown load Binary */ = 8;
	FlagLetters + 36/* ERROR unknown load Binary */ = 9;
	FlagLetters + 40/* ERROR unknown load Binary */ = 10;
	FlagLetters + 44/* ERROR unknown load Binary */ = 11;
	FlagLetters + 48/* ERROR unknown load Binary */ = 12;
	FlagLetters + 52/* ERROR unknown load Binary */ = 13;
	FlagLetters + 56/* ERROR unknown load Binary */ = 15;
	FlagLetters + 60/* ERROR unknown load Binary */ = 16;
	FlagLetters + 64/* ERROR unknown load Binary */ = 17;
	FlagLetters + 68/* ERROR unknown load Binary */ = 18;
	FlagLetters + 72/* ERROR unknown load Binary */ = 19;
	FlagLetters + 76/* ERROR unknown load Binary */ = 20;
	FlagLetters + 100/* ERROR unknown load Binary */ = 14;
	return FlagLetters;
}

public .49416.AccountForLateLoading()
{
	decl String:auth[32];
	new i = 1;
	while (GetMaxClients() >= i)
	{
		if (!IsFakeClient(i))
		{
			if (IsClientConnected(i))
			{
				PlayerStatus[i] = 0;
			}
			new var1;
			if (IsClientInGame(i) && IsClientAuthorized(i) && GetClientAuthId(i, AuthIdType:1, auth, 30, true))
			{
				OnClientAuthorized(i, auth);
			}
		}
		i++;
	}
	return 0;
}

public .49416.AccountForLateLoading()
{
	decl String:auth[32];
	new i = 1;
	while (GetMaxClients() >= i)
	{
		if (!IsFakeClient(i))
		{
			if (IsClientConnected(i))
			{
				PlayerStatus[i] = 0;
			}
			new var1;
			if (IsClientInGame(i) && IsClientAuthorized(i) && GetClientAuthId(i, AuthIdType:1, auth, 30, true))
			{
				OnClientAuthorized(i, auth);
			}
		}
		i++;
	}
	return 0;
}

