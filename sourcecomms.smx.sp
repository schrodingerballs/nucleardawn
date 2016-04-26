public PlVers:__version =
{
	version = 5,
	filevers = "1.8.0.5848",
	date = "02/23/2016",
	time = "21:08:49"
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
public SharedPlugin:__pl_basecomm =
{
	name = "basecomm",
	file = "basecomm.smx",
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
new iNumReasons;
new String:g_sReasonDisplays[32][64];
new String:g_sReasonKey[32][192];
new iNumTimes;
new g_iTimeMinutes[32];
new String:g_sTimeDisplays[32][64];
new DatabaseState:g_DatabaseState;
new g_iConnectLock;
new g_iSequence;
new State:ConfigState;
new Handle:ConfigParser;
new Handle:hTopMenu;
new Handle:CvarHostIp;
new Handle:CvarPort;
new String:ServerIp[24];
new String:ServerPort[8];
new Handle:g_hDatabase;
new Handle:SQLiteDB;
new String:DatabasePrefix[12] = "sb";
new Handle:g_hPlayerRecheck[66];
new Handle:g_hGagExpireTimer[66];
new Handle:g_hMuteExpireTimer[66];
new Float:RetryTime = 1097859072;
new DefaultTime = 30;
new DisUBImCheck;
new ConsoleImmunity;
new ConfigMaxLength;
new ConfigWhiteListOnly;
new serverID;
new g_iPeskyPanels[66][5];
new bool:g_bPlayerStatus[66];
new String:g_sName[66][32];
new bType:g_MuteType[66];
new g_iMuteTime[66];
new g_iMuteLength[66];
new g_iMuteLevel[66];
new String:g_sMuteAdminName[66][32];
new String:g_sMuteReason[66][256];
new String:g_sMuteAdminAuth[66][64];
new bType:g_GagType[66];
new g_iGagTime[66];
new g_iGagLength[66];
new g_iGagLevel[66];
new String:g_sGagAdminName[66][32];
new String:g_sGagReason[66][256];
new String:g_sGagAdminAuth[66][64];
new Handle:g_hServersWhiteList;
public Plugin:myinfo =
{
	name = "SourceComms",
	description = "Advanced punishments management for the Source engine in SourceBans style",
	author = "Alex, Sarabveer(VEER™)",
	version = "(SB++) 1.5.4",
	url = "https://forums.alliedmods.net/showthread.php?t=207176"
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

public .2972.ExplodeString(String:text[], String:split[], String:buffers[][], maxStrings, maxStringLength, bool:copyRemainder)
{
	new reloc_idx;
	new idx;
	new total;
	new var1;
	if (maxStrings < 1 || !split[0])
	{
		return 0;
	}
	while ((idx = SplitString(text[reloc_idx], split, buffers[total], maxStringLength)) != -1)
	{
		reloc_idx = idx + reloc_idx;
		total++;
		if (maxStrings == total)
		{
			if (copyRemainder)
			{
				strcopy(buffers[total + -1], maxStringLength, text[reloc_idx - idx]);
			}
			return total;
		}
	}
	total++;
	strcopy(buffers[total], maxStringLength, text[reloc_idx]);
	return total;
}

public .2972.ExplodeString(String:text[], String:split[], String:buffers[][], maxStrings, maxStringLength, bool:copyRemainder)
{
	new reloc_idx;
	new idx;
	new total;
	new var1;
	if (maxStrings < 1 || !split[0])
	{
		return 0;
	}
	while ((idx = SplitString(text[reloc_idx], split, buffers[total], maxStringLength)) != -1)
	{
		reloc_idx = idx + reloc_idx;
		total++;
		if (maxStrings == total)
		{
			if (copyRemainder)
			{
				strcopy(buffers[total + -1], maxStringLength, text[reloc_idx - idx]);
			}
			return total;
		}
	}
	total++;
	strcopy(buffers[total], maxStringLength, text[reloc_idx]);
	return total;
}

public .3576.SQLite_UseDatabase(String:database[], String:error[], maxlength)
{
	new KeyValues:kv = CreateKeyValues("", "", "");
	KeyValues.SetString(kv, "driver", "sqlite");
	KeyValues.SetString(kv, "database", database);
	new Database:db = SQL_ConnectCustom(kv, error, maxlength, false);
	CloseHandle(kv);
	kv = MissingTAG:0;
	return db;
}

public .3576.SQLite_UseDatabase(String:database[], String:error[], maxlength)
{
	new KeyValues:kv = CreateKeyValues("", "", "");
	KeyValues.SetString(kv, "driver", "sqlite");
	KeyValues.SetString(kv, "database", database);
	new Database:db = SQL_ConnectCustom(kv, error, maxlength, false);
	CloseHandle(kv);
	kv = MissingTAG:0;
	return db;
}

public .3824.ReplyToTargetError(client, reason)
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

public .3824.ReplyToTargetError(client, reason)
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

public __pl_sourcecomms_SetNTVOptional()
{
	MarkNativeAsOptional("SourceComms_SetClientMute");
	MarkNativeAsOptional("SourceComms_SetClientGag");
	MarkNativeAsOptional("SourceComms_GetClientMuteType");
	MarkNativeAsOptional("SourceComms_GetClientGagType");
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

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("SourceComms_SetClientMute", Native_SetClientMute);
	CreateNative("SourceComms_SetClientGag", Native_SetClientGag);
	CreateNative("SourceComms_GetClientMuteType", Native_GetClientMuteType);
	CreateNative("SourceComms_GetClientGagType", Native_GetClientGagType);
	MarkNativeAsOptional("SQL_SetCharset");
	RegPluginLibrary("sourcecomms");
	return APLRes:0;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("sourcecomms.phrases");
	new Handle:hTemp;
	new var1;
	if (LibraryExists("adminmenu") && (hTemp = GetAdminTopMenu()))
	{
		OnAdminMenuReady(hTemp);
	}
	CvarHostIp = FindConVar("hostip");
	CvarPort = FindConVar("hostport");
	g_hServersWhiteList = CreateArray(1, 0);
	CreateConVar("sourcecomms_version", "(SB++) 1.5.4", "", 8512, false, 0.0, false, 0.0);
	AddCommandListener(CommandCallback, "sm_gag");
	AddCommandListener(CommandCallback, "sm_mute");
	AddCommandListener(CommandCallback, "sm_silence");
	AddCommandListener(CommandCallback, "sm_ungag");
	AddCommandListener(CommandCallback, "sm_unmute");
	AddCommandListener(CommandCallback, "sm_unsilence");
	RegServerCmd("sc_fw_block", FWBlock, "Blocking player comms by command from sourceban web site", 0);
	RegServerCmd("sc_fw_ungag", FWUngag, "Ungagging player by command from sourceban web site", 0);
	RegServerCmd("sc_fw_unmute", FWUnmute, "Unmuting player by command from sourceban web site", 0);
	RegConsoleCmd("sm_comms", CommandComms, "Shows current player communications status", 0);
	HookEvent("player_changename", Event_OnPlayerName, EventHookMode:1);
	if (!SQL_CheckConfig("sourcebans"))
	{
		SetFailState("Database failure: could not find database conf  %s", "sourcebans");
		return void:0;
	}
	.45012.DB_Connect();
	.45452.InitializeBackupDB();
	.56732.ServerInfo();
	return void:0;
}

public void:OnLibraryRemoved(String:name[])
{
	if (.2920.StrEqual(name, "adminmenu", true))
	{
		hTopMenu = MissingTAG:0;
	}
	return void:0;
}

public void:OnMapStart()
{
	.57180.ReadConfig();
	return void:0;
}

public void:OnMapEnd()
{
	if (g_hDatabase)
	{
		CloseHandle(g_hDatabase);
	}
	g_hDatabase = MissingTAG:0;
	return void:0;
}

public void:OnClientDisconnect(client)
{
	new var1;
	if (g_hPlayerRecheck[client] && CloseHandle(g_hPlayerRecheck[client]))
	{
		g_hPlayerRecheck[client] = 0;
	}
	.62140.CloseMuteExpireTimer(client);
	.62320.CloseGagExpireTimer(client);
	return void:0;
}

public bool:OnClientConnect(client, String:rejectmsg[], maxlen)
{
	g_bPlayerStatus[client] = 0;
	return true;
}

public void:OnClientConnected(client)
{
	g_sName[client][0] = MissingTAG:0;
	.59884.MarkClientAsUnMuted(client);
	.60260.MarkClientAsUnGagged(client);
	return void:0;
}

public void:OnClientPostAdminCheck(client)
{
	decl String:clientAuth[64];
	GetClientAuthId(client, AuthIdType:1, clientAuth, 64, true);
	GetClientName(client, g_sName[client], 32);
	new var1;
	if (clientAuth[0] == 'B' || clientAuth[2] == 'L' || !.45012.DB_Connect())
	{
		g_bPlayerStatus[client] = 1;
		return void:0;
	}
	new var2;
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client))
	{
		if (BaseComm_IsClientMuted(client))
		{
			.60636.MarkClientAsMuted(client, 0, -1, "CONSOLE", "STEAM_ID_SERVER", 0, "");
		}
		if (BaseComm_IsClientGagged(client))
		{
			.61388.MarkClientAsGagged(client, 0, -1, "CONSOLE", "STEAM_ID_SERVER", 0, "");
		}
		decl String:sClAuthYZEscaped[132];
		SQL_EscapeString(g_hDatabase, clientAuth[2], sClAuthYZEscaped, 129, 0);
		decl String:Query[4096];
		FormatEx(Query, 4096, "SELECT      (c.ends - UNIX_TIMESTAMP()) AS remaining, c.length, c.type, c.created, c.reason, a.user, IF (a.immunity>=g.immunity, a.immunity, IFNULL(g.immunity,0)) AS immunity, c.aid, c.sid, a.authid FROM        %s_comms     AS c LEFT JOIN   %s_admins    AS a  ON a.aid = c.aid LEFT JOIN   %s_srvgroups AS g  ON g.name = a.srv_group WHERE       RemoveType IS NULL AND c.authid REGEXP '^STEAM_[0-9]:%s$' AND (length = '0' OR ends > UNIX_TIMESTAMP())", DatabasePrefix, DatabasePrefix, DatabasePrefix, sClAuthYZEscaped);
		SQL_TQuery(g_hDatabase, Query_VerifyBlock, Query, GetClientUserId(client), DBPriority:0);
	}
	return void:0;
}

public Action:Event_OnPlayerName(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (client > 0 && IsClientInGame(client))
	{
		GetEventString(event, "newname", g_sName[client], 32, "");
	}
	return Action:0;
}

public void:BaseComm_OnClientMute(client, bool:muteState)
{
	new var1;
	if (client > 0 && client <= MaxClients)
	{
		if (muteState)
		{
			if (g_MuteType[client])
			{
			}
			else
			{
				.60636.MarkClientAsMuted(client, 0, -1, "CONSOLE", "STEAM_ID_SERVER", 0, "Muted through BaseComm natives");
				.63724.SavePunishment(0, client, 1, -1, "Muted through BaseComm natives");
			}
		}
		if (bType:0 < g_MuteType[client])
		{
			.59884.MarkClientAsUnMuted(client);
		}
	}
	return void:0;
}

public void:BaseComm_OnClientGag(client, bool:gagState)
{
	new var1;
	if (client > 0 && client <= MaxClients)
	{
		if (gagState)
		{
			if (g_GagType[client])
			{
			}
			else
			{
				.61388.MarkClientAsGagged(client, 0, -1, "CONSOLE", "STEAM_ID_SERVER", 0, "Gagged through BaseComm natives");
				.63724.SavePunishment(0, client, 2, -1, "Gagged through BaseComm natives");
			}
		}
		if (bType:0 < g_GagType[client])
		{
			.60260.MarkClientAsUnGagged(client);
		}
	}
	return void:0;
}

public Action:CommandComms(client, args)
{
	if (!client)
	{
		ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "CommandComms_na");
		return Action:0;
	}
	new var1;
	if (g_MuteType[client] > bType:0 || g_GagType[client] > bType:0)
	{
		.23128.AdminMenu_ListTarget(client, client, 0, 0, 0);
	}
	else
	{
		ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "CommandComms_nb");
	}
	return Action:3;
}

public Action:FWBlock(args)
{
	decl String:arg_string[256];
	new String:sArg[3][64] = "";
	GetCmdArgString(arg_string, 256);
	decl type;
	decl length;
	new var1;
	if (.2972.ExplodeString(arg_string, " ", sArg, 3, 64, false) == 3 && !StringToIntEx(sArg[0][sArg], type, 10) && type < 1 && type > 3 && !StringToIntEx(sArg[1], length, 10))
	{
		LogError("Wrong usage of sc_fw_block");
		return Action:4;
	}
	LogMessage("Received block command from web: steam %s, type %d, length %d", sArg[2], type, length);
	decl String:clientAuth[64];
	new i = 1;
	while (i <= MaxClients)
	{
		new var2;
		if (IsClientInGame(i) && IsClientAuthorized(i) && !IsFakeClient(i))
		{
			GetClientAuthId(i, AuthIdType:1, clientAuth, 64, true);
			if (!(strcmp(clientAuth, sArg[2], false)))
			{
				switch (type)
				{
					case 1:
					{
						.44800.setMute(i, length, clientAuth);
					}
					case 2:
					{
						.44588.setGag(i, length, clientAuth);
					}
					case 3:
					{
						.44800.setMute(i, length, clientAuth);
						.44588.setGag(i, length, clientAuth);
					}
					default:
					{
					}
				}
				return Action:3;
			}
		}
		i++;
	}
	return Action:3;
}

public Action:FWUngag(args)
{
	decl String:arg_string[256];
	decl String:sArg[1][64];
	GetCmdArgString(arg_string, 256);
	if (!.2972.ExplodeString(arg_string, " ", sArg, 1, 64, false))
	{
		LogError("Wrong usage of sc_fw_ungag");
		return Action:4;
	}
	LogMessage("Received ungag command from web: steam %s", sArg[0][sArg]);
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && IsClientAuthorized(i) && !IsFakeClient(i))
		{
			decl String:clientAuth[64];
			GetClientAuthId(i, AuthIdType:1, clientAuth, 64, true);
			if (!(strcmp(clientAuth, sArg[0][sArg], false)))
			{
				if (bType:0 < g_GagType[i])
				{
					.63348.PerformUnGag(i);
					PrintToChat(i, "%s%t", "\x04[SourceComms]\x01 ", "FWUngag");
					LogMessage("%s is ungagged from web", clientAuth);
				}
				else
				{
					LogError("Can't ungag %s from web, it isn't gagged", clientAuth);
				}
				return Action:3;
			}
		}
		i++;
	}
	return Action:3;
}

public Action:FWUnmute(args)
{
	decl String:arg_string[256];
	decl String:sArg[1][64];
	GetCmdArgString(arg_string, 256);
	if (!.2972.ExplodeString(arg_string, " ", sArg, 1, 64, false))
	{
		LogError("Wrong usage of sc_fw_ungag");
		return Action:4;
	}
	LogMessage("Received unmute command from web: steam %s", sArg[0][sArg]);
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && IsClientAuthorized(i) && !IsFakeClient(i))
		{
			decl String:clientAuth[64];
			GetClientAuthId(i, AuthIdType:1, clientAuth, 64, true);
			if (!(strcmp(clientAuth, sArg[0][sArg], false)))
			{
				if (bType:0 < g_MuteType[i])
				{
					.63244.PerformUnMute(i);
					PrintToChat(i, "%s%t", "\x04[SourceComms]\x01 ", "FWUnmute");
					LogMessage("%s is unmuted from web", clientAuth);
				}
				else
				{
					LogError("Can't unmute %s from web, it isn't muted", clientAuth);
				}
				return Action:3;
			}
		}
		i++;
	}
	return Action:3;
}

public Action:CommandCallback(client, String:command[], args)
{
	new var1;
	if (client && !CheckCommandAccess(client, command, 512, false))
	{
		return Action:0;
	}
	new type;
	if (.2920.StrEqual(command, "sm_gag", false))
	{
		type = 2;
	}
	else
	{
		if (.2920.StrEqual(command, "sm_mute", false))
		{
			type = 1;
		}
		if (.2920.StrEqual(command, "sm_ungag", false))
		{
			type = 5;
		}
		if (.2920.StrEqual(command, "sm_unmute", false))
		{
			type = 4;
		}
		if (.2920.StrEqual(command, "sm_silence", false))
		{
			type = 3;
		}
		if (.2920.StrEqual(command, "sm_unsilence", false))
		{
			type = 6;
		}
		return Action:4;
	}
	if (args < 1)
	{
		new var2;
		if (type <= 3)
		{
			var2[0] = 71284;
		}
		else
		{
			var2[0] = 71304;
		}
		ReplyToCommand(client, "%sUsage: %s <#userid|name> %s", "\x04[SourceComms]\x01 ", command, var2);
		if (type <= 3)
		{
			ReplyToCommand(client, "%sUsage: %s <#userid|name> [reason]", "\x04[SourceComms]\x01 ", command);
		}
		return Action:4;
	}
	decl String:sBuffer[256];
	GetCmdArgString(sBuffer, 256);
	if (type <= 3)
	{
		.45632.CreateBlock(client, 0, -1, type, "", sBuffer);
	}
	else
	{
		.49280.ProcessUnBlock(client, 0, type, "", sBuffer);
	}
	return Action:4;
}

public void:OnAdminMenuReady(Handle:topmenu)
{
	if (hTopMenu == topmenu)
	{
		return void:0;
	}
	hTopMenu = topmenu;
	new TopMenuObject:MenuObject = AddToTopMenu(hTopMenu, "sourcecomm_cmds", TopMenuObjectType:0, Handle_Commands, TopMenuObject:0, "", 0, "");
	if (MenuObject)
	{
		AddToTopMenu(hTopMenu, "sourcecomm_gag", TopMenuObjectType:1, Handle_MenuGag, MenuObject, "sm_gag", 512, "");
		AddToTopMenu(hTopMenu, "sourcecomm_ungag", TopMenuObjectType:1, Handle_MenuUnGag, MenuObject, "sm_ungag", 512, "");
		AddToTopMenu(hTopMenu, "sourcecomm_mute", TopMenuObjectType:1, Handle_MenuMute, MenuObject, "sm_mute", 512, "");
		AddToTopMenu(hTopMenu, "sourcecomm_unmute", TopMenuObjectType:1, Handle_MenuUnMute, MenuObject, "sm_unmute", 512, "");
		AddToTopMenu(hTopMenu, "sourcecomm_silence", TopMenuObjectType:1, Handle_MenuSilence, MenuObject, "sm_silence", 512, "");
		AddToTopMenu(hTopMenu, "sourcecomm_unsilence", TopMenuObjectType:1, Handle_MenuUnSilence, MenuObject, "sm_unsilence", 512, "");
		AddToTopMenu(hTopMenu, "sourcecomm_list", TopMenuObjectType:1, Handle_MenuList, MenuObject, "sm_commlist", 512, "");
		return void:0;
	}
	return void:0;
}

public Handle_Commands(Handle:menu, TopMenuAction:action, TopMenuObject:object_id, param1, String:buffer[], maxlength)
{
	switch (action)
	{
		case 0:
		{
			Format(buffer, maxlength, "%T", "AdminMenu_Main", param1);
		}
		case 1:
		{
			Format(buffer, maxlength, "%T", "AdminMenu_Select_Main", param1);
		}
		default:
		{
		}
	}
	return 0;
}

public Handle_MenuGag(Handle:menu, TopMenuAction:action, TopMenuObject:object_id, param1, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			.14552.AdminMenu_Target(param1, 2);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "AdminMenu_Gag", param1);
	}
	return 0;
}

public Handle_MenuUnGag(Handle:menu, TopMenuAction:action, TopMenuObject:object_id, param1, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			.14552.AdminMenu_Target(param1, 5);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "AdminMenu_UnGag", param1);
	}
	return 0;
}

public Handle_MenuMute(Handle:menu, TopMenuAction:action, TopMenuObject:object_id, param1, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			.14552.AdminMenu_Target(param1, 1);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "AdminMenu_Mute", param1);
	}
	return 0;
}

public Handle_MenuUnMute(Handle:menu, TopMenuAction:action, TopMenuObject:object_id, param1, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			.14552.AdminMenu_Target(param1, 4);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "AdminMenu_UnMute", param1);
	}
	return 0;
}

public Handle_MenuSilence(Handle:menu, TopMenuAction:action, TopMenuObject:object_id, param1, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			.14552.AdminMenu_Target(param1, 3);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "AdminMenu_Silence", param1);
	}
	return 0;
}

public Handle_MenuUnSilence(Handle:menu, TopMenuAction:action, TopMenuObject:object_id, param1, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			.14552.AdminMenu_Target(param1, 6);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "AdminMenu_UnSilence", param1);
	}
	return 0;
}

public Handle_MenuList(Handle:menu, TopMenuAction:action, TopMenuObject:object_id, param1, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			g_iPeskyPanels[param1][4] = 0;
			.21484.AdminMenu_List(param1, 0);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "AdminMenu_List", param1);
	}
	return 0;
}

public .14552.AdminMenu_Target(client, type)
{
	decl String:Title[192];
	decl String:Option[32];
	switch (type)
	{
		case 1:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Mute", client);
		}
		case 2:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Gag", client);
		}
		case 3:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Silence", client);
		}
		case 4:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Unmute", client);
		}
		case 5:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Ungag", client);
		}
		case 6:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Unsilence", client);
		}
		default:
		{
		}
	}
	new Handle:hMenu = CreateMenu(MenuHandler_MenuTarget, MenuAction:28);
	SetMenuTitle(hMenu, Title);
	SetMenuExitBackButton(hMenu, true);
	new iClients;
	if (type <= 3)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			new var1;
			if (IsClientInGame(i) && !IsFakeClient(i))
			{
				switch (type)
				{
					case 1:
					{
						if (bType:0 < g_MuteType[i])
						{
							i++;
						}
					}
					case 2:
					{
						if (bType:0 < g_GagType[i])
						{
							i++;
						}
					}
					case 3:
					{
						new var2;
						if (g_MuteType[i] > bType:0 || g_GagType[i] > bType:0)
						{
							i++;
						}
					}
					default:
					{
					}
				}
				iClients++;
				strcopy(Title, 192, g_sName[i]);
				.57832.AdminMenu_GetPunishPhrase(client, i, Title, 192);
				Format(Option, 32, "%d %d", GetClientUserId(i), type);
				new var3;
				if (CanUserTarget(client, i))
				{
					var3 = 0;
				}
				else
				{
					var3 = 1;
				}
				AddMenuItem(hMenu, Option, Title, var3);
			}
			i++;
		}
	}
	else
	{
		new i = 1;
		while (i <= MaxClients)
		{
			new var4;
			if (IsClientInGame(i) && !IsFakeClient(i))
			{
				switch (type)
				{
					case 4:
					{
						if (bType:0 < g_MuteType[i])
						{
							iClients++;
							strcopy(Title, 192, g_sName[i]);
							Format(Option, 32, "%d %d", GetClientUserId(i), type);
							new var8;
							if (CanUserTarget(client, i))
							{
								var8 = 0;
							}
							else
							{
								var8 = 1;
							}
							AddMenuItem(hMenu, Option, Title, var8);
						}
					}
					case 5:
					{
						if (bType:0 < g_GagType[i])
						{
							iClients++;
							strcopy(Title, 192, g_sName[i]);
							Format(Option, 32, "%d %d", GetClientUserId(i), type);
							new var7;
							if (CanUserTarget(client, i))
							{
								var7 = 0;
							}
							else
							{
								var7 = 1;
							}
							AddMenuItem(hMenu, Option, Title, var7);
						}
					}
					case 6:
					{
						new var5;
						if (g_MuteType[i] > bType:0 && g_GagType[i] > bType:0)
						{
							iClients++;
							strcopy(Title, 192, g_sName[i]);
							Format(Option, 32, "%d %d", GetClientUserId(i), type);
							new var6;
							if (CanUserTarget(client, i))
							{
								var6 = 0;
							}
							else
							{
								var6 = 1;
							}
							AddMenuItem(hMenu, Option, Title, var6);
						}
					}
					default:
					{
					}
				}
			}
			i++;
		}
	}
	if (!iClients)
	{
		switch (type)
		{
			case 4:
			{
				Format(Title, 192, "%T", "AdminMenu_Option_Mute_Empty", client);
			}
			case 5:
			{
				Format(Title, 192, "%T", "AdminMenu_Option_Gag_Empty", client);
			}
			case 6:
			{
				Format(Title, 192, "%T", "AdminMenu_Option_Silence_Empty", client);
			}
			default:
			{
				Format(Title, 192, "%T", "AdminMenu_Option_Empty", client);
			}
		}
		AddMenuItem(hMenu, "0", Title, 1);
	}
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public .14552.AdminMenu_Target(client, type)
{
	decl String:Title[192];
	decl String:Option[32];
	switch (type)
	{
		case 1:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Mute", client);
		}
		case 2:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Gag", client);
		}
		case 3:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Silence", client);
		}
		case 4:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Unmute", client);
		}
		case 5:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Ungag", client);
		}
		case 6:
		{
			Format(Title, 192, "%T", "AdminMenu_Select_Unsilence", client);
		}
		default:
		{
		}
	}
	new Handle:hMenu = CreateMenu(MenuHandler_MenuTarget, MenuAction:28);
	SetMenuTitle(hMenu, Title);
	SetMenuExitBackButton(hMenu, true);
	new iClients;
	if (type <= 3)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			new var1;
			if (IsClientInGame(i) && !IsFakeClient(i))
			{
				switch (type)
				{
					case 1:
					{
						if (bType:0 < g_MuteType[i])
						{
							i++;
						}
					}
					case 2:
					{
						if (bType:0 < g_GagType[i])
						{
							i++;
						}
					}
					case 3:
					{
						new var2;
						if (g_MuteType[i] > bType:0 || g_GagType[i] > bType:0)
						{
							i++;
						}
					}
					default:
					{
					}
				}
				iClients++;
				strcopy(Title, 192, g_sName[i]);
				.57832.AdminMenu_GetPunishPhrase(client, i, Title, 192);
				Format(Option, 32, "%d %d", GetClientUserId(i), type);
				new var3;
				if (CanUserTarget(client, i))
				{
					var3 = 0;
				}
				else
				{
					var3 = 1;
				}
				AddMenuItem(hMenu, Option, Title, var3);
			}
			i++;
		}
	}
	else
	{
		new i = 1;
		while (i <= MaxClients)
		{
			new var4;
			if (IsClientInGame(i) && !IsFakeClient(i))
			{
				switch (type)
				{
					case 4:
					{
						if (bType:0 < g_MuteType[i])
						{
							iClients++;
							strcopy(Title, 192, g_sName[i]);
							Format(Option, 32, "%d %d", GetClientUserId(i), type);
							new var8;
							if (CanUserTarget(client, i))
							{
								var8 = 0;
							}
							else
							{
								var8 = 1;
							}
							AddMenuItem(hMenu, Option, Title, var8);
						}
					}
					case 5:
					{
						if (bType:0 < g_GagType[i])
						{
							iClients++;
							strcopy(Title, 192, g_sName[i]);
							Format(Option, 32, "%d %d", GetClientUserId(i), type);
							new var7;
							if (CanUserTarget(client, i))
							{
								var7 = 0;
							}
							else
							{
								var7 = 1;
							}
							AddMenuItem(hMenu, Option, Title, var7);
						}
					}
					case 6:
					{
						new var5;
						if (g_MuteType[i] > bType:0 && g_GagType[i] > bType:0)
						{
							iClients++;
							strcopy(Title, 192, g_sName[i]);
							Format(Option, 32, "%d %d", GetClientUserId(i), type);
							new var6;
							if (CanUserTarget(client, i))
							{
								var6 = 0;
							}
							else
							{
								var6 = 1;
							}
							AddMenuItem(hMenu, Option, Title, var6);
						}
					}
					default:
					{
					}
				}
			}
			i++;
		}
	}
	if (!iClients)
	{
		switch (type)
		{
			case 4:
			{
				Format(Title, 192, "%T", "AdminMenu_Option_Mute_Empty", client);
			}
			case 5:
			{
				Format(Title, 192, "%T", "AdminMenu_Option_Gag_Empty", client);
			}
			case 6:
			{
				Format(Title, 192, "%T", "AdminMenu_Option_Silence_Empty", client);
			}
			default:
			{
				Format(Title, 192, "%T", "AdminMenu_Option_Empty", client);
			}
		}
		AddMenuItem(hMenu, "0", Title, 1);
	}
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandler_MenuTarget(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:Option[32];
			new String:Temp[2][8] = "\x08";
			GetMenuItem(menu, param2, Option, 32, 0, "", 0);
			.2972.ExplodeString(Option, " ", Temp, 2, 8, false);
			new target = GetClientOfUserId(StringToInt(Temp[0][Temp], 10));
			if (.58376.Bool_ValidMenuTarget(param1, target))
			{
				new type = StringToInt(Temp[1], 10);
				if (type <= 3)
				{
					.18468.AdminMenu_Duration(param1, target, type);
				}
				else
				{
					.49280.ProcessUnBlock(param1, target, type, "", "");
				}
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

public .18468.AdminMenu_Duration(client, target, type)
{
	new Handle:hMenu = CreateMenu(MenuHandler_MenuDuration, MenuAction:28);
	decl String:sBuffer[192];
	decl String:sTemp[64];
	Format(sBuffer, 192, "%T", "AdminMenu_Title_Durations", client);
	SetMenuTitle(hMenu, sBuffer);
	SetMenuExitBackButton(hMenu, true);
	new i;
	while (i <= iNumTimes)
	{
		if (.58708.IsAllowedBlockLength(client, g_iTimeMinutes[i], 1))
		{
			Format(sTemp, 64, "%d %d %d", GetClientUserId(target), type, i);
			AddMenuItem(hMenu, sTemp, g_sTimeDisplays[i], 0);
		}
		i++;
	}
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public .18468.AdminMenu_Duration(client, target, type)
{
	new Handle:hMenu = CreateMenu(MenuHandler_MenuDuration, MenuAction:28);
	decl String:sBuffer[192];
	decl String:sTemp[64];
	Format(sBuffer, 192, "%T", "AdminMenu_Title_Durations", client);
	SetMenuTitle(hMenu, sBuffer);
	SetMenuExitBackButton(hMenu, true);
	new i;
	while (i <= iNumTimes)
	{
		if (.58708.IsAllowedBlockLength(client, g_iTimeMinutes[i], 1))
		{
			Format(sTemp, 64, "%d %d %d", GetClientUserId(target), type, i);
			AddMenuItem(hMenu, sTemp, g_sTimeDisplays[i], 0);
		}
		i++;
	}
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandler_MenuDuration(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:sOption[32];
			new String:sTemp[3][8] = "";
			GetMenuItem(menu, param2, sOption, 32, 0, "", 0);
			.2972.ExplodeString(sOption, " ", sTemp, 3, 8, false);
			new target = GetClientOfUserId(StringToInt(sTemp[0][sTemp], 10));
			if (.58376.Bool_ValidMenuTarget(param1, target))
			{
				new type = StringToInt(sTemp[1], 10);
				new lengthIndex = StringToInt(sTemp[2], 10);
				if (iNumReasons)
				{
					.19912.AdminMenu_Reason(param1, target, type, lengthIndex);
				}
				else
				{
					.45632.CreateBlock(param1, target, g_iTimeMinutes[lengthIndex], type, "", "");
				}
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

public .19912.AdminMenu_Reason(client, target, type, lengthIndex)
{
	new Handle:hMenu = CreateMenu(MenuHandler_MenuReason, MenuAction:28);
	decl String:sBuffer[192];
	decl String:sTemp[64];
	Format(sBuffer, 192, "%T", "AdminMenu_Title_Reasons", client);
	SetMenuTitle(hMenu, sBuffer);
	SetMenuExitBackButton(hMenu, true);
	new i;
	while (i <= iNumReasons)
	{
		Format(sTemp, 64, "%d %d %d %d", GetClientUserId(target), type, i, lengthIndex);
		AddMenuItem(hMenu, sTemp, g_sReasonDisplays[i], 0);
		i++;
	}
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public .19912.AdminMenu_Reason(client, target, type, lengthIndex)
{
	new Handle:hMenu = CreateMenu(MenuHandler_MenuReason, MenuAction:28);
	decl String:sBuffer[192];
	decl String:sTemp[64];
	Format(sBuffer, 192, "%T", "AdminMenu_Title_Reasons", client);
	SetMenuTitle(hMenu, sBuffer);
	SetMenuExitBackButton(hMenu, true);
	new i;
	while (i <= iNumReasons)
	{
		Format(sTemp, 64, "%d %d %d %d", GetClientUserId(target), type, i, lengthIndex);
		AddMenuItem(hMenu, sTemp, g_sReasonDisplays[i], 0);
		i++;
	}
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandler_MenuReason(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:sOption[64];
			new String:sTemp[4][8] = "";
			GetMenuItem(menu, param2, sOption, 64, 0, "", 0);
			.2972.ExplodeString(sOption, " ", sTemp, 4, 8, false);
			new target = GetClientOfUserId(StringToInt(sTemp[0][sTemp], 10));
			if (.58376.Bool_ValidMenuTarget(param1, target))
			{
				new type = StringToInt(sTemp[1], 10);
				new reasonIndex = StringToInt(sTemp[2], 10);
				new lengthIndex = StringToInt(sTemp[3], 10);
				new length;
				new var2;
				if (lengthIndex >= 0 && lengthIndex <= iNumTimes)
				{
					length = g_iTimeMinutes[lengthIndex];
				}
				else
				{
					length = DefaultTime;
					LogError("Wrong length index in menu - using default time");
				}
				.45632.CreateBlock(param1, target, length, type, g_sReasonKey[reasonIndex], "");
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

public .21484.AdminMenu_List(client, index)
{
	decl String:sTitle[192];
	decl String:sOption[32];
	Format(sTitle, 192, "%T", "AdminMenu_Select_List", client);
	new iClients;
	new Handle:hMenu = CreateMenu(MenuHandler_MenuList, MenuAction:28);
	SetMenuTitle(hMenu, sTitle);
	if (!g_iPeskyPanels[client][4])
	{
		SetMenuExitBackButton(hMenu, true);
	}
	new i = 1;
	while (i <= MaxClients)
	{
		new var2;
		if (IsClientInGame(i) && !IsFakeClient(i) && (g_MuteType[i] > bType:0 || g_GagType[i] > bType:0))
		{
			iClients++;
			strcopy(sTitle, 192, g_sName[i]);
			.57832.AdminMenu_GetPunishPhrase(client, i, sTitle, 192);
			Format(sOption, 32, "%d", GetClientUserId(i));
			AddMenuItem(hMenu, sOption, sTitle, 0);
		}
		i++;
	}
	if (!iClients)
	{
		Format(sTitle, 192, "%T", "ListMenu_Option_Empty", client);
		AddMenuItem(hMenu, "0", sTitle, 1);
	}
	DisplayMenuAtItem(hMenu, client, index, 0);
	return 0;
}

public .21484.AdminMenu_List(client, index)
{
	decl String:sTitle[192];
	decl String:sOption[32];
	Format(sTitle, 192, "%T", "AdminMenu_Select_List", client);
	new iClients;
	new Handle:hMenu = CreateMenu(MenuHandler_MenuList, MenuAction:28);
	SetMenuTitle(hMenu, sTitle);
	if (!g_iPeskyPanels[client][4])
	{
		SetMenuExitBackButton(hMenu, true);
	}
	new i = 1;
	while (i <= MaxClients)
	{
		new var2;
		if (IsClientInGame(i) && !IsFakeClient(i) && (g_MuteType[i] > bType:0 || g_GagType[i] > bType:0))
		{
			iClients++;
			strcopy(sTitle, 192, g_sName[i]);
			.57832.AdminMenu_GetPunishPhrase(client, i, sTitle, 192);
			Format(sOption, 32, "%d", GetClientUserId(i));
			AddMenuItem(hMenu, sOption, sTitle, 0);
		}
		i++;
	}
	if (!iClients)
	{
		Format(sTitle, 192, "%T", "ListMenu_Option_Empty", client);
		AddMenuItem(hMenu, "0", sTitle, 1);
	}
	DisplayMenuAtItem(hMenu, client, index, 0);
	return 0;
}

public MenuHandler_MenuList(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:sOption[32];
			GetMenuItem(menu, param2, sOption, 32, 0, "", 0);
			new target = GetClientOfUserId(StringToInt(sOption, 10));
			if (.58376.Bool_ValidMenuTarget(param1, target))
			{
				.23128.AdminMenu_ListTarget(param1, target, GetMenuSelectionPosition(), 0, 0);
			}
			else
			{
				.21484.AdminMenu_List(param1, GetMenuSelectionPosition());
			}
		}
		case 8:
		{
			if (!g_iPeskyPanels[param1][4])
			{
				new var1;
				if (param2 == -6 && hTopMenu)
				{
					DisplayTopMenu(hTopMenu, param1, TopMenuPosition:3);
				}
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

public .23128.AdminMenu_ListTarget(client, target, index, viewMute, viewGag)
{
	new userid = GetClientUserId(target);
	new Handle:hMenu = CreateMenu(MenuHandler_MenuListTarget, MenuAction:28);
	decl String:sBuffer[192];
	decl String:sOption[32];
	SetMenuTitle(hMenu, g_sName[target]);
	SetMenuPagination(hMenu, 0);
	SetMenuExitButton(hMenu, true);
	SetMenuExitBackButton(hMenu, false);
	if (bType:0 < g_MuteType[target])
	{
		Format(sBuffer, 192, "%T", "ListMenu_Option_Mute", client);
		Format(sOption, 32, "0 %d %d %b %b", userid, index, viewMute, viewGag);
		AddMenuItem(hMenu, sOption, sBuffer, 0);
		if (viewMute)
		{
			Format(sBuffer, 192, "%T", "ListMenu_Option_Admin", client, g_sMuteAdminName[target]);
			AddMenuItem(hMenu, "", sBuffer, 1);
			decl String:sMuteTemp[192];
			decl String:_sMuteTime[192];
			Format(sMuteTemp, 192, "%T", "ListMenu_Option_Duration", client);
			switch (g_MuteType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Duration_Temp", client);
				}
				case 2:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Duration_Time", client, g_iMuteLength[target]);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Duration_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			AddMenuItem(hMenu, "", sBuffer, 1);
			FormatTime(_sMuteTime, 192, NULL_STRING, g_iMuteTime[target]);
			Format(sBuffer, 192, "%T", "ListMenu_Option_Issue", client, _sMuteTime);
			AddMenuItem(hMenu, "", sBuffer, 1);
			Format(sMuteTemp, 192, "%T", "ListMenu_Option_Expire", client);
			switch (g_MuteType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Expire_Temp_Reconnect", client);
				}
				case 2:
				{
					FormatTime(_sMuteTime, 192, NULL_STRING, g_iMuteTime[target][g_iMuteLength[target] * 60]);
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Expire_Time", client, _sMuteTime);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Expire_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			AddMenuItem(hMenu, "", sBuffer, 1);
			if (0 < strlen(g_sMuteReason[target]))
			{
				Format(sBuffer, 192, "%T", "ListMenu_Option_Reason", client);
				Format(sOption, 32, "1 %d %d %b %b", userid, index, viewMute, viewGag);
				AddMenuItem(hMenu, sOption, sBuffer, 0);
			}
			else
			{
				Format(sBuffer, 192, "%T", "ListMenu_Option_Reason_None", client);
				AddMenuItem(hMenu, "", sBuffer, 1);
			}
		}
	}
	if (bType:0 < g_GagType[target])
	{
		Format(sBuffer, 192, "%T", "ListMenu_Option_Gag", client);
		Format(sOption, 32, "2 %d %d %b %b", userid, index, viewMute, viewGag);
		AddMenuItem(hMenu, sOption, sBuffer, 0);
		if (viewGag)
		{
			Format(sBuffer, 192, "%T", "ListMenu_Option_Admin", client, g_sGagAdminName[target]);
			AddMenuItem(hMenu, "", sBuffer, 1);
			decl String:sGagTemp[192];
			decl String:_sGagTime[192];
			Format(sGagTemp, 192, "%T", "ListMenu_Option_Duration", client);
			switch (g_GagType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Duration_Temp", client);
				}
				case 2:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Duration_Time", client, g_iGagLength[target]);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Duration_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			AddMenuItem(hMenu, "", sBuffer, 1);
			FormatTime(_sGagTime, 192, NULL_STRING, g_iGagTime[target]);
			Format(sBuffer, 192, "%T", "ListMenu_Option_Issue", client, _sGagTime);
			AddMenuItem(hMenu, "", sBuffer, 1);
			Format(sGagTemp, 192, "%T", "ListMenu_Option_Expire", client);
			switch (g_GagType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Expire_Temp_Reconnect", client);
				}
				case 2:
				{
					FormatTime(_sGagTime, 192, NULL_STRING, g_iGagTime[target][g_iGagLength[target] * 60]);
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Expire_Time", client, _sGagTime);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Expire_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			AddMenuItem(hMenu, "", sBuffer, 1);
			if (0 < strlen(g_sGagReason[target]))
			{
				Format(sBuffer, 192, "%T", "ListMenu_Option_Reason", client);
				Format(sOption, 32, "3 %d %d %b %b", userid, index, viewMute, viewGag);
				AddMenuItem(hMenu, sOption, sBuffer, 0);
			}
			else
			{
				Format(sBuffer, 192, "%T", "ListMenu_Option_Reason_None", client);
				AddMenuItem(hMenu, "", sBuffer, 1);
			}
		}
	}
	g_iPeskyPanels[client][1] = index;
	g_iPeskyPanels[client][0] = target;
	g_iPeskyPanels[client][3] = viewGag;
	g_iPeskyPanels[client][2] = viewMute;
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public .23128.AdminMenu_ListTarget(client, target, index, viewMute, viewGag)
{
	new userid = GetClientUserId(target);
	new Handle:hMenu = CreateMenu(MenuHandler_MenuListTarget, MenuAction:28);
	decl String:sBuffer[192];
	decl String:sOption[32];
	SetMenuTitle(hMenu, g_sName[target]);
	SetMenuPagination(hMenu, 0);
	SetMenuExitButton(hMenu, true);
	SetMenuExitBackButton(hMenu, false);
	if (bType:0 < g_MuteType[target])
	{
		Format(sBuffer, 192, "%T", "ListMenu_Option_Mute", client);
		Format(sOption, 32, "0 %d %d %b %b", userid, index, viewMute, viewGag);
		AddMenuItem(hMenu, sOption, sBuffer, 0);
		if (viewMute)
		{
			Format(sBuffer, 192, "%T", "ListMenu_Option_Admin", client, g_sMuteAdminName[target]);
			AddMenuItem(hMenu, "", sBuffer, 1);
			decl String:sMuteTemp[192];
			decl String:_sMuteTime[192];
			Format(sMuteTemp, 192, "%T", "ListMenu_Option_Duration", client);
			switch (g_MuteType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Duration_Temp", client);
				}
				case 2:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Duration_Time", client, g_iMuteLength[target]);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Duration_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			AddMenuItem(hMenu, "", sBuffer, 1);
			FormatTime(_sMuteTime, 192, NULL_STRING, g_iMuteTime[target]);
			Format(sBuffer, 192, "%T", "ListMenu_Option_Issue", client, _sMuteTime);
			AddMenuItem(hMenu, "", sBuffer, 1);
			Format(sMuteTemp, 192, "%T", "ListMenu_Option_Expire", client);
			switch (g_MuteType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Expire_Temp_Reconnect", client);
				}
				case 2:
				{
					FormatTime(_sMuteTime, 192, NULL_STRING, g_iMuteTime[target][g_iMuteLength[target] * 60]);
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Expire_Time", client, _sMuteTime);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sMuteTemp, "ListMenu_Option_Expire_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			AddMenuItem(hMenu, "", sBuffer, 1);
			if (0 < strlen(g_sMuteReason[target]))
			{
				Format(sBuffer, 192, "%T", "ListMenu_Option_Reason", client);
				Format(sOption, 32, "1 %d %d %b %b", userid, index, viewMute, viewGag);
				AddMenuItem(hMenu, sOption, sBuffer, 0);
			}
			else
			{
				Format(sBuffer, 192, "%T", "ListMenu_Option_Reason_None", client);
				AddMenuItem(hMenu, "", sBuffer, 1);
			}
		}
	}
	if (bType:0 < g_GagType[target])
	{
		Format(sBuffer, 192, "%T", "ListMenu_Option_Gag", client);
		Format(sOption, 32, "2 %d %d %b %b", userid, index, viewMute, viewGag);
		AddMenuItem(hMenu, sOption, sBuffer, 0);
		if (viewGag)
		{
			Format(sBuffer, 192, "%T", "ListMenu_Option_Admin", client, g_sGagAdminName[target]);
			AddMenuItem(hMenu, "", sBuffer, 1);
			decl String:sGagTemp[192];
			decl String:_sGagTime[192];
			Format(sGagTemp, 192, "%T", "ListMenu_Option_Duration", client);
			switch (g_GagType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Duration_Temp", client);
				}
				case 2:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Duration_Time", client, g_iGagLength[target]);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Duration_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			AddMenuItem(hMenu, "", sBuffer, 1);
			FormatTime(_sGagTime, 192, NULL_STRING, g_iGagTime[target]);
			Format(sBuffer, 192, "%T", "ListMenu_Option_Issue", client, _sGagTime);
			AddMenuItem(hMenu, "", sBuffer, 1);
			Format(sGagTemp, 192, "%T", "ListMenu_Option_Expire", client);
			switch (g_GagType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Expire_Temp_Reconnect", client);
				}
				case 2:
				{
					FormatTime(_sGagTime, 192, NULL_STRING, g_iGagTime[target][g_iGagLength[target] * 60]);
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Expire_Time", client, _sGagTime);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sGagTemp, "ListMenu_Option_Expire_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			AddMenuItem(hMenu, "", sBuffer, 1);
			if (0 < strlen(g_sGagReason[target]))
			{
				Format(sBuffer, 192, "%T", "ListMenu_Option_Reason", client);
				Format(sOption, 32, "3 %d %d %b %b", userid, index, viewMute, viewGag);
				AddMenuItem(hMenu, sOption, sBuffer, 0);
			}
			else
			{
				Format(sBuffer, 192, "%T", "ListMenu_Option_Reason_None", client);
				AddMenuItem(hMenu, "", sBuffer, 1);
			}
		}
	}
	g_iPeskyPanels[client][1] = index;
	g_iPeskyPanels[client][0] = target;
	g_iPeskyPanels[client][3] = viewGag;
	g_iPeskyPanels[client][2] = viewMute;
	DisplayMenu(hMenu, client, 0);
	return 0;
}

public MenuHandler_MenuListTarget(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:sOption[64];
			new String:sTemp[5][8] = "";
			GetMenuItem(menu, param2, sOption, 64, 0, "", 0);
			.2972.ExplodeString(sOption, " ", sTemp, 5, 8, false);
			new target = GetClientOfUserId(StringToInt(sTemp[1], 10));
			new var1;
			if (target != param1 && .58376.Bool_ValidMenuTarget(param1, target))
			{
				switch (StringToInt(sTemp[0][sTemp], 10))
				{
					case 0:
					{
						.23128.AdminMenu_ListTarget(param1, target, StringToInt(sTemp[2], 10), !StringToInt(sTemp[3], 10), 0);
					}
					case 1, 3:
					{
						.28760.AdminMenu_ListTargetReason(param1, target, g_iPeskyPanels[param1][2], g_iPeskyPanels[param1][3]);
					}
					case 2:
					{
						.23128.AdminMenu_ListTarget(param1, target, StringToInt(sTemp[2], 10), 0, !StringToInt(sTemp[4], 10));
					}
					default:
					{
					}
				}
			}
			else
			{
				.21484.AdminMenu_List(param1, StringToInt(sTemp[2], 10));
			}
		}
		case 8:
		{
			if (param2 == -6)
			{
				.21484.AdminMenu_List(param1, g_iPeskyPanels[param1][1]);
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

public .28760.AdminMenu_ListTargetReason(client, target, showMute, showGag)
{
	decl String:sTemp[192];
	decl String:sBuffer[192];
	new Handle:hPanel = CreatePanel(Handle:0);
	SetPanelTitle(hPanel, g_sName[target], false);
	DrawPanelItem(hPanel, " ", 10);
	if (showMute)
	{
		Format(sTemp, 192, "%T", "ReasonPanel_Punishment_Mute", client);
		switch (g_MuteType[target])
		{
			case 1:
			{
				Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Temp", client);
			}
			case 2:
			{
				Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Time", client, g_iMuteLength[target]);
			}
			case 3:
			{
				Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Perm", client);
			}
			default:
			{
				Format(sBuffer, 192, "error");
			}
		}
		DrawPanelText(hPanel, sBuffer);
		Format(sBuffer, 192, "%T", "ReasonPanel_Reason", client, g_sMuteReason[target]);
		DrawPanelText(hPanel, sBuffer);
	}
	else
	{
		if (showGag)
		{
			Format(sTemp, 192, "%T", "ReasonPanel_Punishment_Gag", client);
			switch (g_GagType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Temp", client);
				}
				case 2:
				{
					Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Time", client, g_iGagLength[target]);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			DrawPanelText(hPanel, sBuffer);
			Format(sBuffer, 192, "%T", "ReasonPanel_Reason", client, g_sGagReason[target]);
			DrawPanelText(hPanel, sBuffer);
		}
	}
	DrawPanelItem(hPanel, " ", 10);
	SetPanelCurrentKey(hPanel, 10);
	Format(sBuffer, 192, "%T", "ReasonPanel_Back", client);
	DrawPanelItem(hPanel, sBuffer, 0);
	SendPanelToClient(hPanel, client, PanelHandler_ListTargetReason, 0);
	CloseHandle(hPanel);
	return 0;
}

public .28760.AdminMenu_ListTargetReason(client, target, showMute, showGag)
{
	decl String:sTemp[192];
	decl String:sBuffer[192];
	new Handle:hPanel = CreatePanel(Handle:0);
	SetPanelTitle(hPanel, g_sName[target], false);
	DrawPanelItem(hPanel, " ", 10);
	if (showMute)
	{
		Format(sTemp, 192, "%T", "ReasonPanel_Punishment_Mute", client);
		switch (g_MuteType[target])
		{
			case 1:
			{
				Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Temp", client);
			}
			case 2:
			{
				Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Time", client, g_iMuteLength[target]);
			}
			case 3:
			{
				Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Perm", client);
			}
			default:
			{
				Format(sBuffer, 192, "error");
			}
		}
		DrawPanelText(hPanel, sBuffer);
		Format(sBuffer, 192, "%T", "ReasonPanel_Reason", client, g_sMuteReason[target]);
		DrawPanelText(hPanel, sBuffer);
	}
	else
	{
		if (showGag)
		{
			Format(sTemp, 192, "%T", "ReasonPanel_Punishment_Gag", client);
			switch (g_GagType[target])
			{
				case 1:
				{
					Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Temp", client);
				}
				case 2:
				{
					Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Time", client, g_iGagLength[target]);
				}
				case 3:
				{
					Format(sBuffer, 192, "%s%T", sTemp, "ReasonPanel_Perm", client);
				}
				default:
				{
					Format(sBuffer, 192, "error");
				}
			}
			DrawPanelText(hPanel, sBuffer);
			Format(sBuffer, 192, "%T", "ReasonPanel_Reason", client, g_sGagReason[target]);
			DrawPanelText(hPanel, sBuffer);
		}
	}
	DrawPanelItem(hPanel, " ", 10);
	SetPanelCurrentKey(hPanel, 10);
	Format(sBuffer, 192, "%T", "ReasonPanel_Back", client);
	DrawPanelItem(hPanel, sBuffer, 0);
	SendPanelToClient(hPanel, client, PanelHandler_ListTargetReason, 0);
	CloseHandle(hPanel);
	return 0;
}

public PanelHandler_ListTargetReason(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:4)
	{
		.23128.AdminMenu_ListTarget(param1, g_iPeskyPanels[param1][0], g_iPeskyPanels[param1][1], g_iPeskyPanels[param1][2], g_iPeskyPanels[param1][3]);
	}
	return 0;
}

public GotDatabase(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new var1;
	if (g_iConnectLock == data && g_hDatabase)
	{
		if (hndl)
		{
			CloseHandle(hndl);
		}
		return 0;
	}
	g_iConnectLock = 0;
	g_DatabaseState = MissingTAG:3;
	g_hDatabase = hndl;
	if (!g_hDatabase)
	{
		LogError("Connecting to database failed: %s", error);
		return 0;
	}
	if (GetFeatureStatus(FeatureType:0, "SQL_SetCharset"))
	{
		decl String:query[128];
		FormatEx(query, 128, "SET NAMES 'UTF8'");
		SQL_TQuery(g_hDatabase, Query_ErrorCheck, query, any:0, DBPriority:1);
	}
	else
	{
		SQL_SetCharset(g_hDatabase, "utf8");
	}
	SQL_TQuery(SQLiteDB, Query_ProcessQueue, "SELECT  id, steam_id, time, start_time, reason, name, admin_id, admin_ip, type FROM    queue2", any:0, DBPriority:1);
	.59412.ForcePlayersRecheck();
	return 0;
}

public Query_AddBlockInsert(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new var1;
	if (.45224.DB_Conn_Lost(hndl) || error[0])
	{
		LogError("Query_AddBlockInsert failed: %s", error);
		ResetPack(data, false);
		new length = ReadPackCell(data);
		new type = ReadPackCell(data);
		new String:reason[256];
		decl String:name[32];
		decl String:auth[64];
		decl String:adminAuth[32];
		decl String:adminIp[20];
		ReadPackString(data, name, 32);
		ReadPackString(data, auth, 64);
		ReadPackString(data, reason, 256);
		ReadPackString(data, adminAuth, 32);
		ReadPackString(data, adminIp, 20);
		.55632.InsertTempBlock(length, type, name, auth, reason, adminAuth, adminIp);
	}
	CloseHandle(data);
	return 0;
}

public Query_UnBlockSelect(Handle:owner, Handle:hndl, String:error[], any:data)
{
	decl String:adminAuth[32];
	decl String:targetAuth[32];
	new String:reason[256];
	ResetPack(data, false);
	new adminUserID = ReadPackCell(data);
	new targetUserID = ReadPackCell(data);
	new type = ReadPackCell(data);
	ReadPackString(data, adminAuth, 30);
	ReadPackString(data, targetAuth, 30);
	ReadPackString(data, reason, 256);
	new admin = GetClientOfUserId(adminUserID);
	new target = GetClientOfUserId(targetUserID);
	decl String:targetName[32];
	new var1;
	if (target && IsClientInGame(target))
	{
		var2[0] = g_sName[target];
	}
	else
	{
		var2[0] = targetAuth;
	}
	strcopy(targetName, 32, var2);
	new bool:hasErrors;
	new var3;
	if (.45224.DB_Conn_Lost(hndl) || error[0])
	{
		LogError("Query_UnBlockSelect failed: %s", error);
		new var4;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%s%T", "\x04[SourceComms]\x01 ", "Unblock Select Failed", admin, targetAuth);
			PrintToConsole(admin, "%s%T", "\x04[SourceComms]\x01 ", "Unblock Select Failed", admin, targetAuth);
		}
		else
		{
			PrintToServer("%s%T", "\x04[SourceComms]\x01 ", "Unblock Select Failed", 0, targetAuth);
		}
		hasErrors = true;
	}
	new var5;
	if (!.45224.DB_Conn_Lost(hndl) && !SQL_GetRowCount(hndl))
	{
		new var6;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%s%t", "\x04[SourceComms]\x01 ", "No blocks found", targetAuth);
			PrintToConsole(admin, "%s%t", "\x04[SourceComms]\x01 ", "No blocks found", targetAuth);
		}
		else
		{
			PrintToServer("%s%T", "\x04[SourceComms]\x01 ", "No blocks found", 0, targetAuth);
		}
		hasErrors = true;
	}
	if (hasErrors)
	{
		.53388.TempUnBlock(data);
		return 0;
	}
	new bool:b_success;
	while (SQL_MoreRows(hndl))
	{
		if (SQL_FetchRow(hndl))
		{
			new bid = SQL_FetchInt(hndl, 0, 0);
			new iAID = SQL_FetchInt(hndl, 1, 0);
			new cAID = SQL_FetchInt(hndl, 2, 0);
			new cImmunity = SQL_FetchInt(hndl, 3, 0);
			new cType = SQL_FetchInt(hndl, 4, 0);
			new var9;
			if (cAID != iAID && (!admin && .2920.StrEqual(adminAuth, "STEAM_ID_SERVER", true)) && .59096.AdmHasFlag(admin) && (DisUBImCheck && .59192.GetAdmImmunity(admin) > cImmunity))
			{
				b_success = true;
				new var10;
				if (target && IsClientInGame(target))
				{
					switch (cType)
					{
						case 1:
						{
							.63244.PerformUnMute(target);
							LogAction(admin, target, "\"%L\" unmuted \"%L\" (reason \"%s\")", admin, target, reason);
						}
						case 2:
						{
							.63348.PerformUnGag(target);
							LogAction(admin, target, "\"%L\" ungagged \"%L\" (reason \"%s\")", admin, target, reason);
						}
						default:
						{
						}
					}
				}
				new Handle:dataPack = CreateDataPack();
				WritePackCell(dataPack, adminUserID);
				WritePackCell(dataPack, cType);
				WritePackString(dataPack, g_sName[target]);
				WritePackString(dataPack, targetAuth);
				new String:unbanReason[516];
				SQL_EscapeString(g_hDatabase, reason, unbanReason, 513, 0);
				decl String:query[2048];
				Format(query, 2048, "UPDATE  %s_comms SET     RemovedBy = %d, RemoveType = 'U', RemovedOn = UNIX_TIMESTAMP(), ureason = '%s' WHERE   bid = %d", DatabasePrefix, iAID, unbanReason, bid);
				SQL_TQuery(g_hDatabase, Query_UnBlockUpdate, query, dataPack, DBPriority:1);
			}
			else
			{
				switch (cType)
				{
					case 1:
					{
						new var12;
						if (admin && IsClientInGame(admin))
						{
							PrintToChat(admin, "%s%t", "\x04[SourceComms]\x01 ", "No permission unmute", targetName);
							PrintToConsole(admin, "%s%t", "\x04[SourceComms]\x01 ", "No permission unmute", targetName);
						}
						LogAction(admin, target, "\"%L\" tried (and didn't have permission) to unmute %s (reason \"%s\")", admin, targetAuth, reason);
					}
					case 2:
					{
						new var11;
						if (admin && IsClientInGame(admin))
						{
							PrintToChat(admin, "%s%t", "\x04[SourceComms]\x01 ", "No permission ungag", targetName);
							PrintToConsole(admin, "%s%t", "\x04[SourceComms]\x01 ", "No permission ungag", targetName);
						}
						LogAction(admin, target, "\"%L\" tried (and didn't have permission) to ungag %s (reason \"%s\")", admin, targetAuth, reason);
					}
					default:
					{
					}
				}
			}
		}
	}
	new var13;
	if (b_success && target && IsClientInGame(target))
	{
		.65888.ShowActivityToServer(admin, type, 0, "", g_sName[target], false);
		if (type == 6)
		{
			SetPackPosition(data, DataPackPos:16);
			if (bType:0 < g_MuteType[target])
			{
				WritePackCell(data, any:4);
				.53388.TempUnBlock(data);
				data = MissingTAG:0;
			}
			if (bType:0 < g_GagType[target])
			{
				WritePackCell(data, any:5);
				.53388.TempUnBlock(data);
				data = MissingTAG:0;
			}
		}
	}
	if (data)
	{
		CloseHandle(data);
	}
	return 0;
}

public Query_UnBlockUpdate(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new admin;
	new type;
	decl String:targetName[32];
	decl String:targetAuth[32];
	ResetPack(data, false);
	admin = GetClientOfUserId(ReadPackCell(data));
	type = ReadPackCell(data);
	ReadPackString(data, targetName, 32);
	ReadPackString(data, targetAuth, 30);
	CloseHandle(data);
	new var1;
	if (.45224.DB_Conn_Lost(hndl) || error[0])
	{
		LogError("Query_UnBlockUpdate failed: %s", error);
		new var2;
		if (admin && IsClientInGame(admin))
		{
			PrintToChat(admin, "%s%t", "\x04[SourceComms]\x01 ", "Unblock insert failed");
			PrintToConsole(admin, "%s%t", "\x04[SourceComms]\x01 ", "Unblock insert failed");
		}
		return 0;
	}
	switch (type)
	{
		case 1:
		{
			LogAction(admin, -1, "\"%L\" removed mute for %s from DB", admin, targetAuth);
			new var4;
			if (admin && IsClientInGame(admin))
			{
				PrintToChat(admin, "%s%t", "\x04[SourceComms]\x01 ", "successfully unmuted", targetName);
				PrintToConsole(admin, "%s%t", "\x04[SourceComms]\x01 ", "successfully unmuted", targetName);
			}
			else
			{
				PrintToServer("%s%T", "\x04[SourceComms]\x01 ", "successfully unmuted", 0, targetName);
			}
		}
		case 2:
		{
			LogAction(admin, -1, "\"%L\" removed gag for %s from DB", admin, targetAuth);
			new var3;
			if (admin && IsClientInGame(admin))
			{
				PrintToChat(admin, "%s%t", "\x04[SourceComms]\x01 ", "successfully ungagged", targetName);
				PrintToConsole(admin, "%s%t", "\x04[SourceComms]\x01 ", "successfully ungagged", targetName);
			}
			else
			{
				PrintToServer("%s%T", "\x04[SourceComms]\x01 ", "successfully ungagged", 0, targetName);
			}
		}
		default:
		{
		}
	}
	return 0;
}

public Query_ProcessQueue(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new var1;
	if (hndl && error[0])
	{
		LogError("Query_ProcessQueue failed: %s", error);
		return 0;
	}
	decl String:auth[64];
	decl String:name[32];
	new String:reason[256];
	decl String:adminAuth[64];
	decl String:adminIp[20];
	decl String:query[4096];
	while (SQL_MoreRows(hndl))
	{
		if (SQL_FetchRow(hndl))
		{
			decl String:sAuthEscaped[132];
			decl String:banName[68];
			new String:banReason[516];
			decl String:sAdmAuthEscaped[132];
			decl String:sAdmAuthYZEscaped[132];
			new id = SQL_FetchInt(hndl, 0, 0);
			SQL_FetchString(hndl, 1, auth, 64, 0);
			new time = SQL_FetchInt(hndl, 2, 0);
			new startTime = SQL_FetchInt(hndl, 3, 0);
			SQL_FetchString(hndl, 4, reason, 256, 0);
			SQL_FetchString(hndl, 5, name, 32, 0);
			SQL_FetchString(hndl, 6, adminAuth, 64, 0);
			SQL_FetchString(hndl, 7, adminIp, 20, 0);
			new type = SQL_FetchInt(hndl, 8, 0);
			if (.45012.DB_Connect())
			{
				SQL_EscapeString(g_hDatabase, auth, sAuthEscaped, 129, 0);
				SQL_EscapeString(g_hDatabase, name, banName, 65, 0);
				SQL_EscapeString(g_hDatabase, reason, banReason, 513, 0);
				SQL_EscapeString(g_hDatabase, adminAuth, sAdmAuthEscaped, 129, 0);
				SQL_EscapeString(g_hDatabase, adminAuth[2], sAdmAuthYZEscaped, 129, 0);
				FormatEx(query, 4096, "INSERT INTO     %s_comms (authid, name, created, ends, length, reason, aid, adminIp, sid, type) VALUES         ('%s', '%s', %d, %d, %d, '%s', IFNULL((SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), '0'), '%s', %d, %d)", DatabasePrefix, sAuthEscaped, banName, startTime, time * 60 + startTime, time * 60, banReason, DatabasePrefix, sAdmAuthEscaped, sAdmAuthYZEscaped, adminIp, serverID, type);
				SQL_TQuery(g_hDatabase, Query_AddBlockFromQueue, query, id, DBPriority:1);
			}
		}
	}
	return 0;
}

public Query_AddBlockFromQueue(Handle:owner, Handle:hndl, String:error[], any:data)
{
	decl String:query[512];
	if (!error[0])
	{
		FormatEx(query, 512, "DELETE FROM queue2 WHERE       id = %d", data);
		SQL_TQuery(SQLiteDB, Query_ErrorCheck, query, any:0, DBPriority:1);
	}
	return 0;
}

public Query_ErrorCheck(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new var1;
	if (.45224.DB_Conn_Lost(hndl) || error[0])
	{
		LogError("%T (%s)", "Failed to query database", 0, error);
	}
	return 0;
}

public Query_VerifyBlock(Handle:owner, Handle:hndl, String:error[], any:userid)
{
	decl String:clientAuth[64];
	new client = GetClientOfUserId(userid);
	if (!client)
	{
		return 0;
	}
	if (.45224.DB_Conn_Lost(hndl))
	{
		LogError("Query_VerifyBlock failed: %s", error);
		if (!g_hPlayerRecheck[client])
		{
			g_hPlayerRecheck[client] = CreateTimer(RetryTime, ClientRecheck, userid, 0);
		}
		return 0;
	}
	GetClientAuthId(client, AuthIdType:1, clientAuth, 64, true);
	if (0 < SQL_GetRowCount(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			if (!(.59780.NotApplyToThisServer(SQL_FetchInt(hndl, 8, 0))))
			{
				new String:sReason[256];
				decl String:sAdmName[32];
				decl String:sAdmAuth[64];
				new remaining_time = SQL_FetchInt(hndl, 0, 0);
				new length = SQL_FetchInt(hndl, 1, 0);
				new type = SQL_FetchInt(hndl, 2, 0);
				new time = SQL_FetchInt(hndl, 3, 0);
				SQL_FetchString(hndl, 4, sReason, 256, 0);
				SQL_FetchString(hndl, 5, sAdmName, 32, 0);
				new immunity = SQL_FetchInt(hndl, 6, 0);
				new aid = SQL_FetchInt(hndl, 7, 0);
				SQL_FetchString(hndl, 9, sAdmAuth, 64, 0);
				new var1;
				if (!aid && ConsoleImmunity > immunity)
				{
					immunity = ConsoleImmunity;
				}
				switch (type)
				{
					case 1:
					{
						if (g_MuteType[client] < bType:2)
						{
							.63452.PerformMute(client, time, length / 60, sAdmName, sAdmAuth, immunity, sReason, remaining_time);
							PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Muted on connect");
						}
					}
					case 2:
					{
						if (g_GagType[client] < bType:2)
						{
							.63588.PerformGag(client, time, length / 60, sAdmName, sAdmAuth, immunity, sReason, remaining_time);
							PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Gagged on connect");
						}
					}
					default:
					{
					}
				}
			}
		}
	}
	g_bPlayerStatus[client] = 1;
	return 0;
}

public Action:ClientRecheck(Handle:timer, any:userid)
{
	new client = GetClientOfUserId(userid);
	if (!client)
	{
		return Action:0;
	}
	if (IsClientConnected(client))
	{
		OnClientPostAdminCheck(client);
	}
	g_hPlayerRecheck[client] = 0;
	return Action:0;
}

public Action:Timer_MuteExpire(Handle:timer, any:userid)
{
	new client = GetClientOfUserId(userid);
	if (!client)
	{
		return Action:0;
	}
	PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Mute expired");
	g_hMuteExpireTimer[client] = 0;
	.59884.MarkClientAsUnMuted(client);
	if (IsClientInGame(client))
	{
		BaseComm_SetClientMute(client, false);
	}
	return Action:0;
}

public Action:Timer_GagExpire(Handle:timer, any:userid)
{
	new client = GetClientOfUserId(userid);
	if (!client)
	{
		return Action:0;
	}
	PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Gag expired");
	g_hGagExpireTimer[client] = 0;
	.60260.MarkClientAsUnGagged(client);
	if (IsClientInGame(client))
	{
		BaseComm_SetClientGag(client, false);
	}
	return Action:0;
}

public Action:Timer_StopWait(Handle:timer, any:data)
{
	g_DatabaseState = MissingTAG:0;
	.45012.DB_Connect();
	return Action:0;
}

public .41860.InitializeConfigParser()
{
	if (!ConfigParser)
	{
		ConfigParser = SMC_CreateParser();
		SMC_SetReaders(ConfigParser, ReadConfig_NewSection, ReadConfig_KeyValue, ReadConfig_EndSection);
	}
	return 0;
}

public .41860.InitializeConfigParser()
{
	if (!ConfigParser)
	{
		ConfigParser = SMC_CreateParser();
		SMC_SetReaders(ConfigParser, ReadConfig_NewSection, ReadConfig_KeyValue, ReadConfig_EndSection);
	}
	return 0;
}

public .41980.InternalReadConfig(String:path[])
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
			var1[0] = 75956;
		}
		PrintToServer("%s", var1);
	}
	return 0;
}

public .41980.InternalReadConfig(String:path[])
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
			var1[0] = 75956;
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
			if (strcmp("CommsReasons", name, false))
			{
				if (strcmp("CommsTimes", name, false))
				{
					if (!(strcmp("ServersWhiteList", name, false)))
					{
						ConfigState = MissingTAG:4;
					}
				}
				ConfigState = MissingTAG:3;
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
			if (strcmp("DatabasePrefix", key, false))
			{
				if (strcmp("RetryTime", key, false))
				{
					if (strcmp("ServerID", key, false))
					{
						if (strcmp("DefaultTime", key, false))
						{
							if (strcmp("DisableUnblockImmunityCheck", key, false))
							{
								if (strcmp("ConsoleImmunity", key, false))
								{
									if (strcmp("MaxLength", key, false))
									{
										if (!(strcmp("OnlyWhiteListServers", key, false)))
										{
											ConfigWhiteListOnly = StringToInt(value, 10);
											if (ConfigWhiteListOnly != 1)
											{
												ConfigWhiteListOnly = 0;
											}
										}
									}
									ConfigMaxLength = StringToInt(value, 10);
								}
								ConsoleImmunity = StringToInt(value, 10);
								new var2;
								if (ConsoleImmunity < 0 || ConsoleImmunity > 100)
								{
									ConsoleImmunity = 0;
								}
							}
							DisUBImCheck = StringToInt(value, 10);
							if (DisUBImCheck != 1)
							{
								DisUBImCheck = 0;
							}
						}
						DefaultTime = StringToInt(value, 10);
						if (0 > DefaultTime)
						{
							DefaultTime = -1;
						}
						if (DefaultTime)
						{
						}
						else
						{
							DefaultTime = 30;
						}
					}
					new var1;
					if (!StringToIntEx(value, serverID, 10) || serverID < 1)
					{
						serverID = 0;
					}
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
			else
			{
				strcopy(DatabasePrefix, 10, value);
				if (DatabasePrefix[0])
				{
				}
			}
		}
		case 2:
		{
			Format(g_sReasonKey[iNumReasons], 192, "%s", key);
			Format(g_sReasonDisplays[iNumReasons], 64, "%s", value);
			iNumReasons += 1;
		}
		case 3:
		{
			Format(g_sTimeDisplays[iNumTimes], 64, "%s", value);
			g_iTimeMinutes[iNumTimes] = StringToInt(key, 10);
			iNumTimes += 1;
		}
		case 4:
		{
			if (strcmp("id", key, false))
			{
			}
			else
			{
				new srvID = StringToInt(value, 10);
				if (0 <= srvID)
				{
					PushArrayCell(g_hServersWhiteList, srvID);
				}
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

public .44588.setGag(client, length, String:clientAuth[])
{
	if (!g_GagType[client])
	{
		.63588.PerformGag(client, 0, length / 60, "CONSOLE", "STEAM_ID_SERVER", 0, "", 0);
		PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Gagged on connect");
		LogMessage("%s is gagged from web", clientAuth);
	}
	return 0;
}

public .44588.setGag(client, length, String:clientAuth[])
{
	if (!g_GagType[client])
	{
		.63588.PerformGag(client, 0, length / 60, "CONSOLE", "STEAM_ID_SERVER", 0, "", 0);
		PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Gagged on connect");
		LogMessage("%s is gagged from web", clientAuth);
	}
	return 0;
}

public .44800.setMute(client, length, String:clientAuth[])
{
	if (!g_MuteType[client])
	{
		.63452.PerformMute(client, 0, length / 60, "CONSOLE", "STEAM_ID_SERVER", 0, "", 0);
		PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Muted on connect");
		LogMessage("%s is muted from web", clientAuth);
	}
	return 0;
}

public .44800.setMute(client, length, String:clientAuth[])
{
	if (!g_MuteType[client])
	{
		.63452.PerformMute(client, 0, length / 60, "CONSOLE", "STEAM_ID_SERVER", 0, "", 0);
		PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Muted on connect");
		LogMessage("%s is muted from web", clientAuth);
	}
	return 0;
}

public .45012.DB_Connect()
{
	if (g_hDatabase)
	{
		return 1;
	}
	if (g_DatabaseState == DatabaseState:1)
	{
		return 0;
	}
	if (g_DatabaseState != DatabaseState:2)
	{
		g_DatabaseState = MissingTAG:2;
		g_iSequence += 1;
		g_iConnectLock = g_iSequence;
		SQL_TConnect(GotDatabase, "sourcebans", g_iConnectLock);
	}
	return 0;
}

public .45012.DB_Connect()
{
	if (g_hDatabase)
	{
		return 1;
	}
	if (g_DatabaseState == DatabaseState:1)
	{
		return 0;
	}
	if (g_DatabaseState != DatabaseState:2)
	{
		g_DatabaseState = MissingTAG:2;
		g_iSequence += 1;
		g_iConnectLock = g_iSequence;
		SQL_TConnect(GotDatabase, "sourcebans", g_iConnectLock);
	}
	return 0;
}

public .45224.DB_Conn_Lost(Handle:hndl)
{
	if (hndl)
	{
		return 0;
	}
	if (g_hDatabase)
	{
		LogError("Lost connection to DB. Reconnect after delay.");
		CloseHandle(g_hDatabase);
		g_hDatabase = MissingTAG:0;
	}
	if (g_DatabaseState != DatabaseState:1)
	{
		g_DatabaseState = MissingTAG:1;
		CreateTimer(RetryTime, Timer_StopWait, any:0, 2);
	}
	return 1;
}

public .45224.DB_Conn_Lost(Handle:hndl)
{
	if (hndl)
	{
		return 0;
	}
	if (g_hDatabase)
	{
		LogError("Lost connection to DB. Reconnect after delay.");
		CloseHandle(g_hDatabase);
		g_hDatabase = MissingTAG:0;
	}
	if (g_DatabaseState != DatabaseState:1)
	{
		g_DatabaseState = MissingTAG:1;
		CreateTimer(RetryTime, Timer_StopWait, any:0, 2);
	}
	return 1;
}

public .45452.InitializeBackupDB()
{
	decl String:error[256];
	SQLiteDB = .3576.SQLite_UseDatabase("sourcecomms-queue", error, 255);
	if (!SQLiteDB)
	{
		SetFailState(error);
	}
	SQL_TQuery(SQLiteDB, Query_ErrorCheck, "CREATE TABLE IF NOT EXISTS queue2 ( id INTEGER PRIMARY KEY, steam_id TEXT, time INTEGER, start_time INTEGER, reason TEXT, name TEXT, admin_id TEXT, admin_ip TEXT, type INTEGER)", any:0, DBPriority:1);
	return 0;
}

public .45452.InitializeBackupDB()
{
	decl String:error[256];
	SQLiteDB = .3576.SQLite_UseDatabase("sourcecomms-queue", error, 255);
	if (!SQLiteDB)
	{
		SetFailState(error);
	}
	SQL_TQuery(SQLiteDB, Query_ErrorCheck, "CREATE TABLE IF NOT EXISTS queue2 ( id INTEGER PRIMARY KEY, steam_id TEXT, time INTEGER, start_time INTEGER, reason TEXT, name TEXT, admin_id TEXT, admin_ip TEXT, type INTEGER)", any:0, DBPriority:1);
	return 0;
}

public .45632.CreateBlock(client, targetId, length, type, String:sReason[], String:sArgs[])
{
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	decl String:target_name[32];
	new String:reason[256];
	new bool:skipped;
	if (targetId)
	{
		target_list[0] = targetId;
		target_count = 1;
		tn_is_ml = false;
		strcopy(target_name, 32, g_sName[targetId]);
		strcopy(reason, 256, sReason);
	}
	else
	{
		if (strlen(sArgs))
		{
			new String:sArg[3][192] = "";
			new var1;
			if (.2972.ExplodeString(sArgs, "\"", sArg, 3, 192, true) == 3 && strlen(sArg[0][sArg]))
			{
				new String:sTempArg[2][192] = "\x08";
				TrimString(sArg[2]);
				.2972.ExplodeString(sArg[2], " ", sTempArg, 2, 192, true);
			}
			else
			{
				.2972.ExplodeString(sArgs, " ", sArg, 3, 192, true);
			}
			if (0 >= (target_count = ProcessTargetString(sArg[0][sArg], client, target_list, 65, 32, target_name, 32, tn_is_ml)))
			{
				.3824.ReplyToTargetError(client, target_count);
				return 0;
			}
			if (!StringToIntEx(sArg[1], length, 10))
			{
				length = DefaultTime;
				Format(reason, 256, "%s %s", sArg[1], sArg[2]);
			}
			else
			{
				strcopy(reason, 256, sArg[2]);
			}
			TrimString(reason);
			StripQuotes(reason);
			if (!.58708.IsAllowedBlockLength(client, length, target_count))
			{
				ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "no access");
				return 0;
			}
		}
		return 0;
	}
	new admImmunity = .59192.GetAdmImmunity(client);
	decl String:adminAuth[64];
	new var2;
	if (client && IsClientInGame(client))
	{
		GetClientAuthId(client, AuthIdType:1, adminAuth, 64, true);
	}
	else
	{
		strcopy(adminAuth, 64, "STEAM_ID_SERVER");
	}
	new i;
	while (i < target_count)
	{
		new target = target_list[i];
		if (!g_bPlayerStatus[target])
		{
			ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player Comms Not Verified");
			skipped = true;
		}
		else
		{
			switch (type)
			{
				case 1:
				{
					if (!BaseComm_IsClientMuted(target))
					{
						.63452.PerformMute(target, 0, length, g_sName[client], adminAuth, admImmunity, reason, 0);
						LogAction(client, target, "\"%L\" muted \"%L\" (minutes \"%d\") (reason \"%s\")", client, target, length, reason);
					}
					ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player already muted", g_sName[target]);
					skipped = true;
				}
				case 2:
				{
					if (!BaseComm_IsClientGagged(target))
					{
						.63588.PerformGag(target, 0, length, g_sName[client], adminAuth, admImmunity, reason, 0);
						LogAction(client, target, "\"%L\" gagged \"%L\" (minutes \"%d\") (reason \"%s\")", client, target, length, reason);
					}
					ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player already gagged", g_sName[target]);
					skipped = true;
				}
				case 3:
				{
					new var3;
					if (!BaseComm_IsClientGagged(target) && !BaseComm_IsClientMuted(target))
					{
						.63452.PerformMute(target, 0, length, g_sName[client], adminAuth, admImmunity, reason, 0);
						.63588.PerformGag(target, 0, length, g_sName[client], adminAuth, admImmunity, reason, 0);
						LogAction(client, target, "\"%L\" silenced \"%L\" (minutes \"%d\") (reason \"%s\")", client, target, length, reason);
					}
					ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player already silenced", g_sName[target]);
					skipped = true;
				}
				default:
				{
				}
			}
		}
		i++;
	}
	new var4;
	if (target_count == 1 && !skipped)
	{
		.63724.SavePunishment(client, target_list[0], type, length, reason);
	}
	new var5;
	if (target_count > 1 || !skipped)
	{
		.65888.ShowActivityToServer(client, type, length, reason, target_name, tn_is_ml);
	}
	return 0;
}

public .45632.CreateBlock(client, targetId, length, type, String:sReason[], String:sArgs[])
{
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	decl String:target_name[32];
	new String:reason[256];
	new bool:skipped;
	if (targetId)
	{
		target_list[0] = targetId;
		target_count = 1;
		tn_is_ml = false;
		strcopy(target_name, 32, g_sName[targetId]);
		strcopy(reason, 256, sReason);
	}
	else
	{
		if (strlen(sArgs))
		{
			new String:sArg[3][192] = "";
			new var1;
			if (.2972.ExplodeString(sArgs, "\"", sArg, 3, 192, true) == 3 && strlen(sArg[0][sArg]))
			{
				new String:sTempArg[2][192] = "\x08";
				TrimString(sArg[2]);
				.2972.ExplodeString(sArg[2], " ", sTempArg, 2, 192, true);
			}
			else
			{
				.2972.ExplodeString(sArgs, " ", sArg, 3, 192, true);
			}
			if (0 >= (target_count = ProcessTargetString(sArg[0][sArg], client, target_list, 65, 32, target_name, 32, tn_is_ml)))
			{
				.3824.ReplyToTargetError(client, target_count);
				return 0;
			}
			if (!StringToIntEx(sArg[1], length, 10))
			{
				length = DefaultTime;
				Format(reason, 256, "%s %s", sArg[1], sArg[2]);
			}
			else
			{
				strcopy(reason, 256, sArg[2]);
			}
			TrimString(reason);
			StripQuotes(reason);
			if (!.58708.IsAllowedBlockLength(client, length, target_count))
			{
				ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "no access");
				return 0;
			}
		}
		return 0;
	}
	new admImmunity = .59192.GetAdmImmunity(client);
	decl String:adminAuth[64];
	new var2;
	if (client && IsClientInGame(client))
	{
		GetClientAuthId(client, AuthIdType:1, adminAuth, 64, true);
	}
	else
	{
		strcopy(adminAuth, 64, "STEAM_ID_SERVER");
	}
	new i;
	while (i < target_count)
	{
		new target = target_list[i];
		if (!g_bPlayerStatus[target])
		{
			ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player Comms Not Verified");
			skipped = true;
		}
		else
		{
			switch (type)
			{
				case 1:
				{
					if (!BaseComm_IsClientMuted(target))
					{
						.63452.PerformMute(target, 0, length, g_sName[client], adminAuth, admImmunity, reason, 0);
						LogAction(client, target, "\"%L\" muted \"%L\" (minutes \"%d\") (reason \"%s\")", client, target, length, reason);
					}
					ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player already muted", g_sName[target]);
					skipped = true;
				}
				case 2:
				{
					if (!BaseComm_IsClientGagged(target))
					{
						.63588.PerformGag(target, 0, length, g_sName[client], adminAuth, admImmunity, reason, 0);
						LogAction(client, target, "\"%L\" gagged \"%L\" (minutes \"%d\") (reason \"%s\")", client, target, length, reason);
					}
					ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player already gagged", g_sName[target]);
					skipped = true;
				}
				case 3:
				{
					new var3;
					if (!BaseComm_IsClientGagged(target) && !BaseComm_IsClientMuted(target))
					{
						.63452.PerformMute(target, 0, length, g_sName[client], adminAuth, admImmunity, reason, 0);
						.63588.PerformGag(target, 0, length, g_sName[client], adminAuth, admImmunity, reason, 0);
						LogAction(client, target, "\"%L\" silenced \"%L\" (minutes \"%d\") (reason \"%s\")", client, target, length, reason);
					}
					ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player already silenced", g_sName[target]);
					skipped = true;
				}
				default:
				{
				}
			}
		}
		i++;
	}
	new var4;
	if (target_count == 1 && !skipped)
	{
		.63724.SavePunishment(client, target_list[0], type, length, reason);
	}
	new var5;
	if (target_count > 1 || !skipped)
	{
		.65888.ShowActivityToServer(client, type, length, reason, target_name, tn_is_ml);
	}
	return 0;
}

public .49280.ProcessUnBlock(client, targetId, type, String:sReason[], String:sArgs[])
{
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	decl String:target_name[32];
	new String:reason[256];
	if (targetId)
	{
		target_list[0] = targetId;
		target_count = 1;
		tn_is_ml = false;
		strcopy(target_name, 32, g_sName[targetId]);
		strcopy(reason, 256, sReason);
	}
	else
	{
		decl String:sBuffer[256];
		new String:sArg[3][192] = "";
		GetCmdArgString(sBuffer, 256);
		new var1;
		if (.2972.ExplodeString(sBuffer, "\"", sArg, 3, 192, true) == 3 && strlen(sArg[0][sArg]))
		{
			TrimString(sArg[2]);
		}
		else
		{
			.2972.ExplodeString(sBuffer, " ", sArg, 2, 192, true);
		}
		strcopy(reason, 256, sArg[1]);
		TrimString(reason);
		StripQuotes(reason);
		if (0 >= (target_count = ProcessTargetString(sArg[0][sArg], client, target_list, 65, 32, target_name, 32, tn_is_ml)))
		{
			.3824.ReplyToTargetError(client, target_count);
			return 0;
		}
	}
	decl String:adminAuth[64];
	decl String:targetAuth[64];
	new var2;
	if (client && IsClientInGame(client))
	{
		GetClientAuthId(client, AuthIdType:1, adminAuth, 64, true);
	}
	else
	{
		strcopy(adminAuth, 64, "STEAM_ID_SERVER");
	}
	if (target_count > 1)
	{
		new i;
		while (i < target_count)
		{
			new target = target_list[i];
			if (IsClientInGame(target))
			{
				GetClientAuthId(target, AuthIdType:1, targetAuth, 64, true);
				new Handle:dataPack = CreateDataPack();
				WritePackCell(dataPack, .59348.GetClientUserId2(client));
				WritePackCell(dataPack, GetClientUserId(target));
				WritePackCell(dataPack, type);
				WritePackString(dataPack, adminAuth);
				WritePackString(dataPack, targetAuth);
				WritePackString(dataPack, reason);
				.53388.TempUnBlock(dataPack);
			}
			i++;
		}
		.65888.ShowActivityToServer(client, type + 10, 0, "", target_name, tn_is_ml);
	}
	else
	{
		decl String:typeWHERE[100];
		new bool:dontCheckDB;
		new target = target_list[0];
		if (IsClientInGame(target))
		{
			GetClientAuthId(target, AuthIdType:1, targetAuth, 64, true);
			switch (type)
			{
				case 4:
				{
					if (!BaseComm_IsClientMuted(target))
					{
						ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player not muted");
						return 0;
					}
					FormatEx(typeWHERE, 100, "c.type = '%d'", 1);
					if (g_MuteType[target] == bType:1)
					{
						dontCheckDB = true;
					}
				}
				case 5:
				{
					if (!BaseComm_IsClientGagged(target))
					{
						ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player not gagged");
						return 0;
					}
					FormatEx(typeWHERE, 100, "c.type = '%d'", 2);
					if (g_GagType[target] == bType:1)
					{
						dontCheckDB = true;
					}
				}
				case 6:
				{
					new var3;
					if (!BaseComm_IsClientMuted(target) || !BaseComm_IsClientGagged(target))
					{
						ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player not silenced");
						return 0;
					}
					FormatEx(typeWHERE, 100, "(c.type = '%d' OR c.type = '%d')", 1, 2);
					new var4;
					if (g_MuteType[target] == bType:1 && g_GagType[target] == bType:1)
					{
						dontCheckDB = true;
					}
				}
				default:
				{
				}
			}
			new Handle:dataPack = CreateDataPack();
			WritePackCell(dataPack, .59348.GetClientUserId2(client));
			WritePackCell(dataPack, GetClientUserId(target));
			WritePackCell(dataPack, type);
			WritePackString(dataPack, adminAuth);
			WritePackString(dataPack, targetAuth);
			WritePackString(dataPack, reason);
			new var5;
			if (!dontCheckDB && .45012.DB_Connect())
			{
				decl String:sAdminAuthEscaped[132];
				decl String:sAdminAuthYZEscaped[132];
				decl String:sTargetAuthEscaped[132];
				decl String:sTargetAuthYZEscaped[132];
				SQL_EscapeString(g_hDatabase, adminAuth, sAdminAuthEscaped, 129, 0);
				SQL_EscapeString(g_hDatabase, adminAuth[2], sAdminAuthYZEscaped, 129, 0);
				SQL_EscapeString(g_hDatabase, targetAuth, sTargetAuthEscaped, 129, 0);
				SQL_EscapeString(g_hDatabase, targetAuth[2], sTargetAuthYZEscaped, 129, 0);
				decl String:query[4096];
				Format(query, 4096, "SELECT      c.bid, IFNULL((SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), '0') as iaid, c.aid, IF (a.immunity>=g.immunity, a.immunity, IFNULL(g.immunity,0)) as immunity, c.type FROM        %s_comms     AS c LEFT JOIN   %s_admins    AS a ON a.aid = c.aid LEFT JOIN   %s_srvgroups AS g ON g.name = a.srv_group WHERE       RemoveType IS NULL AND (c.authid = '%s' OR c.authid REGEXP '^STEAM_[0-9]:%s$') AND (length = '0' OR ends > UNIX_TIMESTAMP()) AND %s", DatabasePrefix, sAdminAuthEscaped, sAdminAuthYZEscaped, DatabasePrefix, DatabasePrefix, DatabasePrefix, sTargetAuthEscaped, sTargetAuthYZEscaped, typeWHERE);
				SQL_TQuery(g_hDatabase, Query_UnBlockSelect, query, dataPack, DBPriority:1);
			}
			else
			{
				if (.53388.TempUnBlock(dataPack))
				{
					.65888.ShowActivityToServer(client, type + 10, 0, "", g_sName[target], false);
				}
			}
		}
		return 0;
	}
	return 0;
}

public .49280.ProcessUnBlock(client, targetId, type, String:sReason[], String:sArgs[])
{
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	decl String:target_name[32];
	new String:reason[256];
	if (targetId)
	{
		target_list[0] = targetId;
		target_count = 1;
		tn_is_ml = false;
		strcopy(target_name, 32, g_sName[targetId]);
		strcopy(reason, 256, sReason);
	}
	else
	{
		decl String:sBuffer[256];
		new String:sArg[3][192] = "";
		GetCmdArgString(sBuffer, 256);
		new var1;
		if (.2972.ExplodeString(sBuffer, "\"", sArg, 3, 192, true) == 3 && strlen(sArg[0][sArg]))
		{
			TrimString(sArg[2]);
		}
		else
		{
			.2972.ExplodeString(sBuffer, " ", sArg, 2, 192, true);
		}
		strcopy(reason, 256, sArg[1]);
		TrimString(reason);
		StripQuotes(reason);
		if (0 >= (target_count = ProcessTargetString(sArg[0][sArg], client, target_list, 65, 32, target_name, 32, tn_is_ml)))
		{
			.3824.ReplyToTargetError(client, target_count);
			return 0;
		}
	}
	decl String:adminAuth[64];
	decl String:targetAuth[64];
	new var2;
	if (client && IsClientInGame(client))
	{
		GetClientAuthId(client, AuthIdType:1, adminAuth, 64, true);
	}
	else
	{
		strcopy(adminAuth, 64, "STEAM_ID_SERVER");
	}
	if (target_count > 1)
	{
		new i;
		while (i < target_count)
		{
			new target = target_list[i];
			if (IsClientInGame(target))
			{
				GetClientAuthId(target, AuthIdType:1, targetAuth, 64, true);
				new Handle:dataPack = CreateDataPack();
				WritePackCell(dataPack, .59348.GetClientUserId2(client));
				WritePackCell(dataPack, GetClientUserId(target));
				WritePackCell(dataPack, type);
				WritePackString(dataPack, adminAuth);
				WritePackString(dataPack, targetAuth);
				WritePackString(dataPack, reason);
				.53388.TempUnBlock(dataPack);
			}
			i++;
		}
		.65888.ShowActivityToServer(client, type + 10, 0, "", target_name, tn_is_ml);
	}
	else
	{
		decl String:typeWHERE[100];
		new bool:dontCheckDB;
		new target = target_list[0];
		if (IsClientInGame(target))
		{
			GetClientAuthId(target, AuthIdType:1, targetAuth, 64, true);
			switch (type)
			{
				case 4:
				{
					if (!BaseComm_IsClientMuted(target))
					{
						ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player not muted");
						return 0;
					}
					FormatEx(typeWHERE, 100, "c.type = '%d'", 1);
					if (g_MuteType[target] == bType:1)
					{
						dontCheckDB = true;
					}
				}
				case 5:
				{
					if (!BaseComm_IsClientGagged(target))
					{
						ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player not gagged");
						return 0;
					}
					FormatEx(typeWHERE, 100, "c.type = '%d'", 2);
					if (g_GagType[target] == bType:1)
					{
						dontCheckDB = true;
					}
				}
				case 6:
				{
					new var3;
					if (!BaseComm_IsClientMuted(target) || !BaseComm_IsClientGagged(target))
					{
						ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Player not silenced");
						return 0;
					}
					FormatEx(typeWHERE, 100, "(c.type = '%d' OR c.type = '%d')", 1, 2);
					new var4;
					if (g_MuteType[target] == bType:1 && g_GagType[target] == bType:1)
					{
						dontCheckDB = true;
					}
				}
				default:
				{
				}
			}
			new Handle:dataPack = CreateDataPack();
			WritePackCell(dataPack, .59348.GetClientUserId2(client));
			WritePackCell(dataPack, GetClientUserId(target));
			WritePackCell(dataPack, type);
			WritePackString(dataPack, adminAuth);
			WritePackString(dataPack, targetAuth);
			WritePackString(dataPack, reason);
			new var5;
			if (!dontCheckDB && .45012.DB_Connect())
			{
				decl String:sAdminAuthEscaped[132];
				decl String:sAdminAuthYZEscaped[132];
				decl String:sTargetAuthEscaped[132];
				decl String:sTargetAuthYZEscaped[132];
				SQL_EscapeString(g_hDatabase, adminAuth, sAdminAuthEscaped, 129, 0);
				SQL_EscapeString(g_hDatabase, adminAuth[2], sAdminAuthYZEscaped, 129, 0);
				SQL_EscapeString(g_hDatabase, targetAuth, sTargetAuthEscaped, 129, 0);
				SQL_EscapeString(g_hDatabase, targetAuth[2], sTargetAuthYZEscaped, 129, 0);
				decl String:query[4096];
				Format(query, 4096, "SELECT      c.bid, IFNULL((SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), '0') as iaid, c.aid, IF (a.immunity>=g.immunity, a.immunity, IFNULL(g.immunity,0)) as immunity, c.type FROM        %s_comms     AS c LEFT JOIN   %s_admins    AS a ON a.aid = c.aid LEFT JOIN   %s_srvgroups AS g ON g.name = a.srv_group WHERE       RemoveType IS NULL AND (c.authid = '%s' OR c.authid REGEXP '^STEAM_[0-9]:%s$') AND (length = '0' OR ends > UNIX_TIMESTAMP()) AND %s", DatabasePrefix, sAdminAuthEscaped, sAdminAuthYZEscaped, DatabasePrefix, DatabasePrefix, DatabasePrefix, sTargetAuthEscaped, sTargetAuthYZEscaped, typeWHERE);
				SQL_TQuery(g_hDatabase, Query_UnBlockSelect, query, dataPack, DBPriority:1);
			}
			else
			{
				if (.53388.TempUnBlock(dataPack))
				{
					.65888.ShowActivityToServer(client, type + 10, 0, "", g_sName[target], false);
				}
			}
		}
		return 0;
	}
	return 0;
}

public .53388.TempUnBlock(Handle:data)
{
	decl String:adminAuth[32];
	decl String:targetAuth[32];
	new String:reason[256];
	ResetPack(data, false);
	new adminUserID = ReadPackCell(data);
	new targetUserID = ReadPackCell(data);
	new type = ReadPackCell(data);
	ReadPackString(data, adminAuth, 30);
	ReadPackString(data, targetAuth, 30);
	ReadPackString(data, reason, 256);
	CloseHandle(data);
	new admin = GetClientOfUserId(adminUserID);
	new target = GetClientOfUserId(targetUserID);
	if (!target)
	{
		return 0;
	}
	new AdmImmunity = .59192.GetAdmImmunity(admin);
	decl bool:AdmImCheck;
	new var5;
	AdmImCheck = DisUBImCheck && ((type == 1 && AdmImmunity > g_iMuteLevel[target]) || (type == 2 && AdmImmunity > g_iGagLevel[target]) || (type == 3 && AdmImmunity > g_iMuteLevel[target] && AdmImmunity > g_iGagLevel[target]));
	decl bool:bHasPermission;
	new var6;
	bHasPermission = (!admin && .2920.StrEqual(adminAuth, "STEAM_ID_SERVER", true)) || (.59096.AdmHasFlag(admin) || AdmImCheck);
	if (!bHasPermission)
	{
		switch (type)
		{
			case 4:
			{
				bHasPermission = .2920.StrEqual(adminAuth, g_sMuteAdminAuth[target], true);
			}
			case 5:
			{
				bHasPermission = .2920.StrEqual(adminAuth, g_sGagAdminAuth[target], true);
			}
			case 6:
			{
				new var8;
				if (.2920.StrEqual(adminAuth, g_sMuteAdminAuth[target], true) && .2920.StrEqual(adminAuth, g_sGagAdminAuth[target], true))
				{
				}
			}
			default:
			{
			}
		}
	}
	if (bHasPermission)
	{
		switch (type)
		{
			case 4:
			{
				.63244.PerformUnMute(target);
				LogAction(admin, target, "\"%L\" temporary unmuted \"%L\" (reason \"%s\")", admin, target, reason);
			}
			case 5:
			{
				.63348.PerformUnGag(target);
				LogAction(admin, target, "\"%L\" temporary ungagged \"%L\" (reason \"%s\")", admin, target, reason);
			}
			case 6:
			{
				.63244.PerformUnMute(target);
				.63348.PerformUnGag(target);
				LogAction(admin, target, "\"%L\" temporary unsilenced \"%L\" (reason \"%s\")", admin, target, reason);
			}
			default:
			{
				return 0;
			}
		}
		return 1;
	}
	new var9;
	if (admin && IsClientInGame(admin))
	{
		PrintToChat(admin, "%s%t", "\x04[SourceComms]\x01 ", "No db error unlock perm");
		PrintToConsole(admin, "%s%t", "\x04[SourceComms]\x01 ", "No db error unlock perm");
	}
	return 0;
}

public .53388.TempUnBlock(Handle:data)
{
	decl String:adminAuth[32];
	decl String:targetAuth[32];
	new String:reason[256];
	ResetPack(data, false);
	new adminUserID = ReadPackCell(data);
	new targetUserID = ReadPackCell(data);
	new type = ReadPackCell(data);
	ReadPackString(data, adminAuth, 30);
	ReadPackString(data, targetAuth, 30);
	ReadPackString(data, reason, 256);
	CloseHandle(data);
	new admin = GetClientOfUserId(adminUserID);
	new target = GetClientOfUserId(targetUserID);
	if (!target)
	{
		return 0;
	}
	new AdmImmunity = .59192.GetAdmImmunity(admin);
	decl bool:AdmImCheck;
	new var5;
	AdmImCheck = DisUBImCheck && ((type == 1 && AdmImmunity > g_iMuteLevel[target]) || (type == 2 && AdmImmunity > g_iGagLevel[target]) || (type == 3 && AdmImmunity > g_iMuteLevel[target] && AdmImmunity > g_iGagLevel[target]));
	decl bool:bHasPermission;
	new var6;
	bHasPermission = (!admin && .2920.StrEqual(adminAuth, "STEAM_ID_SERVER", true)) || (.59096.AdmHasFlag(admin) || AdmImCheck);
	if (!bHasPermission)
	{
		switch (type)
		{
			case 4:
			{
				bHasPermission = .2920.StrEqual(adminAuth, g_sMuteAdminAuth[target], true);
			}
			case 5:
			{
				bHasPermission = .2920.StrEqual(adminAuth, g_sGagAdminAuth[target], true);
			}
			case 6:
			{
				new var8;
				if (.2920.StrEqual(adminAuth, g_sMuteAdminAuth[target], true) && .2920.StrEqual(adminAuth, g_sGagAdminAuth[target], true))
				{
				}
			}
			default:
			{
			}
		}
	}
	if (bHasPermission)
	{
		switch (type)
		{
			case 4:
			{
				.63244.PerformUnMute(target);
				LogAction(admin, target, "\"%L\" temporary unmuted \"%L\" (reason \"%s\")", admin, target, reason);
			}
			case 5:
			{
				.63348.PerformUnGag(target);
				LogAction(admin, target, "\"%L\" temporary ungagged \"%L\" (reason \"%s\")", admin, target, reason);
			}
			case 6:
			{
				.63244.PerformUnMute(target);
				.63348.PerformUnGag(target);
				LogAction(admin, target, "\"%L\" temporary unsilenced \"%L\" (reason \"%s\")", admin, target, reason);
			}
			default:
			{
				return 0;
			}
		}
		return 1;
	}
	new var9;
	if (admin && IsClientInGame(admin))
	{
		PrintToChat(admin, "%s%t", "\x04[SourceComms]\x01 ", "No db error unlock perm");
		PrintToConsole(admin, "%s%t", "\x04[SourceComms]\x01 ", "No db error unlock perm");
	}
	return 0;
}

public .55632.InsertTempBlock(length, type, String:name[], String:auth[], String:reason[], String:adminAuth[], String:adminIp[])
{
	LogMessage("Saving punishment for %s into queue", auth);
	decl String:banName[68];
	new String:banReason[516];
	decl String:sAuthEscaped[132];
	decl String:sAdminAuthEscaped[132];
	decl String:sQuery[4096];
	decl String:sQueryVal[2048];
	decl String:sQueryMute[2048];
	decl String:sQueryGag[2048];
	SQL_EscapeString(SQLiteDB, name, banName, 65, 0);
	SQL_EscapeString(SQLiteDB, reason, banReason, 513, 0);
	SQL_EscapeString(SQLiteDB, auth, sAuthEscaped, 129, 0);
	SQL_EscapeString(SQLiteDB, adminAuth, sAdminAuthEscaped, 129, 0);
	FormatEx(sQueryVal, 2048, "'%s', %d, %d, '%s', '%s', '%s', '%s'", sAuthEscaped, length, GetTime({0,0}), banReason, banName, sAdminAuthEscaped, adminIp);
	switch (type)
	{
		case 1:
		{
			FormatEx(sQueryMute, 2048, "(%s, %d)", sQueryVal, type);
		}
		case 2:
		{
			FormatEx(sQueryGag, 2048, "(%s, %d)", sQueryVal, type);
		}
		case 3:
		{
			FormatEx(sQueryMute, 2048, "(%s, %d)", sQueryVal, 1);
			FormatEx(sQueryGag, 2048, "(%s, %d)", sQueryVal, 2);
		}
		default:
		{
		}
	}
	new var1;
	if (type == 3)
	{
		var1[0] = 78328;
	}
	else
	{
		var1[0] = 78332;
	}
	FormatEx(sQuery, 4096, "INSERT INTO queue2 (steam_id, time, start_time, reason, name, admin_id, admin_ip, type) VALUES %s%s%s", sQueryMute, var1, sQueryGag);
	SQL_TQuery(SQLiteDB, Query_ErrorCheck, sQuery, any:0, DBPriority:1);
	return 0;
}

public .55632.InsertTempBlock(length, type, String:name[], String:auth[], String:reason[], String:adminAuth[], String:adminIp[])
{
	LogMessage("Saving punishment for %s into queue", auth);
	decl String:banName[68];
	new String:banReason[516];
	decl String:sAuthEscaped[132];
	decl String:sAdminAuthEscaped[132];
	decl String:sQuery[4096];
	decl String:sQueryVal[2048];
	decl String:sQueryMute[2048];
	decl String:sQueryGag[2048];
	SQL_EscapeString(SQLiteDB, name, banName, 65, 0);
	SQL_EscapeString(SQLiteDB, reason, banReason, 513, 0);
	SQL_EscapeString(SQLiteDB, auth, sAuthEscaped, 129, 0);
	SQL_EscapeString(SQLiteDB, adminAuth, sAdminAuthEscaped, 129, 0);
	FormatEx(sQueryVal, 2048, "'%s', %d, %d, '%s', '%s', '%s', '%s'", sAuthEscaped, length, GetTime({0,0}), banReason, banName, sAdminAuthEscaped, adminIp);
	switch (type)
	{
		case 1:
		{
			FormatEx(sQueryMute, 2048, "(%s, %d)", sQueryVal, type);
		}
		case 2:
		{
			FormatEx(sQueryGag, 2048, "(%s, %d)", sQueryVal, type);
		}
		case 3:
		{
			FormatEx(sQueryMute, 2048, "(%s, %d)", sQueryVal, 1);
			FormatEx(sQueryGag, 2048, "(%s, %d)", sQueryVal, 2);
		}
		default:
		{
		}
	}
	new var1;
	if (type == 3)
	{
		var1[0] = 78328;
	}
	else
	{
		var1[0] = 78332;
	}
	FormatEx(sQuery, 4096, "INSERT INTO queue2 (steam_id, time, start_time, reason, name, admin_id, admin_ip, type) VALUES %s%s%s", sQueryMute, var1, sQueryGag);
	SQL_TQuery(SQLiteDB, Query_ErrorCheck, sQuery, any:0, DBPriority:1);
	return 0;
}

public .56732.ServerInfo()
{
	decl pieces[4];
	new longip = GetConVarInt(CvarHostIp);
	pieces[0] = longip >>> 24 & 255;
	pieces[1] = longip >>> 16 & 255;
	pieces[2] = longip >>> 8 & 255;
	pieces[3] = longip & 255;
	FormatEx(ServerIp, 24, "%d.%d.%d.%d", pieces, pieces[1], pieces[2], pieces[3]);
	GetConVarString(CvarPort, ServerPort, 7);
	return 0;
}

public .56732.ServerInfo()
{
	decl pieces[4];
	new longip = GetConVarInt(CvarHostIp);
	pieces[0] = longip >>> 24 & 255;
	pieces[1] = longip >>> 16 & 255;
	pieces[2] = longip >>> 8 & 255;
	pieces[3] = longip & 255;
	FormatEx(ServerIp, 24, "%d.%d.%d.%d", pieces, pieces[1], pieces[2], pieces[3]);
	GetConVarString(CvarPort, ServerPort, 7);
	return 0;
}

public .57180.ReadConfig()
{
	.41860.InitializeConfigParser();
	if (ConfigParser)
	{
		decl String:ConfigFile1[256];
		decl String:ConfigFile2[256];
		BuildPath(PathType:0, ConfigFile1, 256, "configs/sourcebans/sourcebans.cfg");
		BuildPath(PathType:0, ConfigFile2, 256, "configs/sourcebans/sourcecomms.cfg");
		if (FileExists(ConfigFile1, false, "GAME"))
		{
			PrintToServer("%sLoading configs/sourcebans/sourcebans.cfg config file", "\x04[SourceComms]\x01 ");
			.41980.InternalReadConfig(ConfigFile1);
		}
		else
		{
			SetFailState("FATAL *** ERROR *** can't find %s", ConfigFile1);
		}
		if (FileExists(ConfigFile2, false, "GAME"))
		{
			PrintToServer("%sLoading configs/sourcecomms.cfg config file", "\x04[SourceComms]\x01 ");
			iNumReasons = 0;
			iNumTimes = 0;
			.41980.InternalReadConfig(ConfigFile2);
			if (iNumReasons)
			{
				iNumReasons -= 1;
			}
			if (iNumTimes)
			{
				iNumTimes -= 1;
			}
			if (serverID)
			{
			}
			else
			{
				LogError("You must set valid `ServerID` value in sourcebans.cfg!");
				if (ConfigWhiteListOnly)
				{
					LogError("ServersWhiteList feature disabled!");
					ConfigWhiteListOnly = 0;
				}
			}
		}
		else
		{
			SetFailState("FATAL *** ERROR *** can't find %s", ConfigFile2);
		}
		return 0;
	}
	return 0;
}

public .57180.ReadConfig()
{
	.41860.InitializeConfigParser();
	if (ConfigParser)
	{
		decl String:ConfigFile1[256];
		decl String:ConfigFile2[256];
		BuildPath(PathType:0, ConfigFile1, 256, "configs/sourcebans/sourcebans.cfg");
		BuildPath(PathType:0, ConfigFile2, 256, "configs/sourcebans/sourcecomms.cfg");
		if (FileExists(ConfigFile1, false, "GAME"))
		{
			PrintToServer("%sLoading configs/sourcebans/sourcebans.cfg config file", "\x04[SourceComms]\x01 ");
			.41980.InternalReadConfig(ConfigFile1);
		}
		else
		{
			SetFailState("FATAL *** ERROR *** can't find %s", ConfigFile1);
		}
		if (FileExists(ConfigFile2, false, "GAME"))
		{
			PrintToServer("%sLoading configs/sourcecomms.cfg config file", "\x04[SourceComms]\x01 ");
			iNumReasons = 0;
			iNumTimes = 0;
			.41980.InternalReadConfig(ConfigFile2);
			if (iNumReasons)
			{
				iNumReasons -= 1;
			}
			if (iNumTimes)
			{
				iNumTimes -= 1;
			}
			if (serverID)
			{
			}
			else
			{
				LogError("You must set valid `ServerID` value in sourcebans.cfg!");
				if (ConfigWhiteListOnly)
				{
					LogError("ServersWhiteList feature disabled!");
					ConfigWhiteListOnly = 0;
				}
			}
		}
		else
		{
			SetFailState("FATAL *** ERROR *** can't find %s", ConfigFile2);
		}
		return 0;
	}
	return 0;
}

public .57832.AdminMenu_GetPunishPhrase(client, target, String:name[], length)
{
	decl String:Buffer[192];
	new var1;
	if (g_MuteType[target] > bType:0 && g_GagType[target] > bType:0)
	{
		Format(Buffer, 192, "%T", "AdminMenu_Display_Silenced", client, name);
	}
	else
	{
		if (bType:0 < g_MuteType[target])
		{
			Format(Buffer, 192, "%T", "AdminMenu_Display_Muted", client, name);
		}
		if (bType:0 < g_GagType[target])
		{
			Format(Buffer, 192, "%T", "AdminMenu_Display_Gagged", client, name);
		}
		Format(Buffer, 192, "%T", "AdminMenu_Display_None", client, name);
	}
	strcopy(name, length, Buffer);
	return 0;
}

public .57832.AdminMenu_GetPunishPhrase(client, target, String:name[], length)
{
	decl String:Buffer[192];
	new var1;
	if (g_MuteType[target] > bType:0 && g_GagType[target] > bType:0)
	{
		Format(Buffer, 192, "%T", "AdminMenu_Display_Silenced", client, name);
	}
	else
	{
		if (bType:0 < g_MuteType[target])
		{
			Format(Buffer, 192, "%T", "AdminMenu_Display_Muted", client, name);
		}
		if (bType:0 < g_GagType[target])
		{
			Format(Buffer, 192, "%T", "AdminMenu_Display_Gagged", client, name);
		}
		Format(Buffer, 192, "%T", "AdminMenu_Display_None", client, name);
	}
	strcopy(name, length, Buffer);
	return 0;
}

public .58376.Bool_ValidMenuTarget(client, target)
{
	if (0 >= target)
	{
		if (client)
		{
			PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "AdminMenu_Not_Available");
		}
		else
		{
			ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "AdminMenu_Not_Available");
		}
		return 0;
	}
	if (!CanUserTarget(client, target))
	{
		if (client)
		{
			PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Command_Target_Not_Targetable");
		}
		else
		{
			ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Command_Target_Not_Targetable");
		}
		return 0;
	}
	return 1;
}

public .58376.Bool_ValidMenuTarget(client, target)
{
	if (0 >= target)
	{
		if (client)
		{
			PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "AdminMenu_Not_Available");
		}
		else
		{
			ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "AdminMenu_Not_Available");
		}
		return 0;
	}
	if (!CanUserTarget(client, target))
	{
		if (client)
		{
			PrintToChat(client, "%s%t", "\x04[SourceComms]\x01 ", "Command_Target_Not_Targetable");
		}
		else
		{
			ReplyToCommand(client, "%s%t", "\x04[SourceComms]\x01 ", "Command_Target_Not_Targetable");
		}
		return 0;
	}
	return 1;
}

public .58708.IsAllowedBlockLength(admin, length, target_count)
{
	if (target_count == 1)
	{
		new var1;
		if (!ConfigMaxLength || !admin || .59096.AdmHasFlag(admin))
		{
			return 1;
		}
		new var2;
		return !length || length > ConfigMaxLength;
	}
	if (0 > length)
	{
		return 1;
	}
	new var3;
	return !length || length > 30 || length > DefaultTime;
}

public .58708.IsAllowedBlockLength(admin, length, target_count)
{
	if (target_count == 1)
	{
		new var1;
		if (!ConfigMaxLength || !admin || .59096.AdmHasFlag(admin))
		{
			return 1;
		}
		new var2;
		return !length || length > ConfigMaxLength;
	}
	if (0 > length)
	{
		return 1;
	}
	new var3;
	return !length || length > 30 || length > DefaultTime;
}

public .59096.AdmHasFlag(admin)
{
	new var1;
	return admin && CheckCommandAccess(admin, "", 65536, true);
}

public .59096.AdmHasFlag(admin)
{
	new var1;
	return admin && CheckCommandAccess(admin, "", 65536, true);
}

public .59192.GetAdmImmunity(admin)
{
	new var1;
	if (admin > 0 && GetUserAdmin(admin) != -1)
	{
		var2 = GetAdminImmunityLevel(GetUserAdmin(admin));
	}
	else
	{
		var2 = 0;
	}
	return var2;
}

public .59192.GetAdmImmunity(admin)
{
	new var1;
	if (admin > 0 && GetUserAdmin(admin) != -1)
	{
		var2 = GetAdminImmunityLevel(GetUserAdmin(admin));
	}
	else
	{
		var2 = 0;
	}
	return var2;
}

public .59348.GetClientUserId2(client)
{
	new var1;
	if (client)
	{
		var1 = GetClientUserId(client);
	}
	else
	{
		var1 = 0;
	}
	return var1;
}

public .59348.GetClientUserId2(client)
{
	new var1;
	if (client)
	{
		var1 = GetClientUserId(client);
	}
	else
	{
		var1 = 0;
	}
	return var1;
}

public .59412.ForcePlayersRecheck()
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && IsClientAuthorized(i) && !IsFakeClient(i) && g_hPlayerRecheck[i])
		{
			g_hPlayerRecheck[i] = CreateTimer(float(i), ClientRecheck, GetClientUserId(i), 0);
		}
		i++;
	}
	return 0;
}

public .59412.ForcePlayersRecheck()
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && IsClientAuthorized(i) && !IsFakeClient(i) && g_hPlayerRecheck[i])
		{
			g_hPlayerRecheck[i] = CreateTimer(float(i), ClientRecheck, GetClientUserId(i), 0);
		}
		i++;
	}
	return 0;
}

public .59780.NotApplyToThisServer(srvID)
{
	new var1;
	return ConfigWhiteListOnly && FindValueInArray(g_hServersWhiteList, srvID, 0) == -1;
}

public .59780.NotApplyToThisServer(srvID)
{
	new var1;
	return ConfigWhiteListOnly && FindValueInArray(g_hServersWhiteList, srvID, 0) == -1;
}

public .59884.MarkClientAsUnMuted(target)
{
	g_MuteType[target] = 0;
	g_iMuteTime[target] = 0;
	g_iMuteLength[target] = 0;
	g_iMuteLevel[target] = -1;
	g_sMuteAdminName[target][0] = MissingTAG:0;
	g_sMuteReason[target][0] = MissingTAG:0;
	g_sMuteAdminAuth[target][0] = MissingTAG:0;
	return 0;
}

public .59884.MarkClientAsUnMuted(target)
{
	g_MuteType[target] = 0;
	g_iMuteTime[target] = 0;
	g_iMuteLength[target] = 0;
	g_iMuteLevel[target] = -1;
	g_sMuteAdminName[target][0] = MissingTAG:0;
	g_sMuteReason[target][0] = MissingTAG:0;
	g_sMuteAdminAuth[target][0] = MissingTAG:0;
	return 0;
}

public .60260.MarkClientAsUnGagged(target)
{
	g_GagType[target] = 0;
	g_iGagTime[target] = 0;
	g_iGagLength[target] = 0;
	g_iGagLevel[target] = -1;
	g_sGagAdminName[target][0] = MissingTAG:0;
	g_sGagReason[target][0] = MissingTAG:0;
	g_sGagAdminAuth[target][0] = MissingTAG:0;
	return 0;
}

public .60260.MarkClientAsUnGagged(target)
{
	g_GagType[target] = 0;
	g_iGagTime[target] = 0;
	g_iGagLength[target] = 0;
	g_iGagLevel[target] = -1;
	g_sGagAdminName[target][0] = MissingTAG:0;
	g_sGagReason[target][0] = MissingTAG:0;
	g_sGagAdminAuth[target][0] = MissingTAG:0;
	return 0;
}

public .60636.MarkClientAsMuted(target, time, length, String:adminName[], String:adminAuth[], adminImmunity, String:reason[])
{
	if (time)
	{
		g_iMuteTime[target] = time;
	}
	else
	{
		g_iMuteTime[target] = GetTime({0,0});
	}
	g_iMuteLength[target] = length;
	new var1;
	if (adminImmunity)
	{
		var1 = adminImmunity;
	}
	else
	{
		var1 = ConsoleImmunity;
	}
	g_iMuteLevel[target] = var1;
	strcopy(g_sMuteAdminName[target], 32, adminName);
	strcopy(g_sMuteReason[target], 256, reason);
	strcopy(g_sMuteAdminAuth[target], 64, adminAuth);
	if (0 < length)
	{
		g_MuteType[target] = 2;
	}
	else
	{
		if (length)
		{
			g_MuteType[target] = 1;
		}
		g_MuteType[target] = 3;
	}
	return 0;
}

public .60636.MarkClientAsMuted(target, time, length, String:adminName[], String:adminAuth[], adminImmunity, String:reason[])
{
	if (time)
	{
		g_iMuteTime[target] = time;
	}
	else
	{
		g_iMuteTime[target] = GetTime({0,0});
	}
	g_iMuteLength[target] = length;
	new var1;
	if (adminImmunity)
	{
		var1 = adminImmunity;
	}
	else
	{
		var1 = ConsoleImmunity;
	}
	g_iMuteLevel[target] = var1;
	strcopy(g_sMuteAdminName[target], 32, adminName);
	strcopy(g_sMuteReason[target], 256, reason);
	strcopy(g_sMuteAdminAuth[target], 64, adminAuth);
	if (0 < length)
	{
		g_MuteType[target] = 2;
	}
	else
	{
		if (length)
		{
			g_MuteType[target] = 1;
		}
		g_MuteType[target] = 3;
	}
	return 0;
}

public .61388.MarkClientAsGagged(target, time, length, String:adminName[], String:adminAuth[], adminImmunity, String:reason[])
{
	if (time)
	{
		g_iGagTime[target] = time;
	}
	else
	{
		g_iGagTime[target] = GetTime({0,0});
	}
	g_iGagLength[target] = length;
	new var1;
	if (adminImmunity)
	{
		var1 = adminImmunity;
	}
	else
	{
		var1 = ConsoleImmunity;
	}
	g_iGagLevel[target] = var1;
	strcopy(g_sGagAdminName[target], 32, adminName);
	strcopy(g_sGagReason[target], 256, reason);
	strcopy(g_sGagAdminAuth[target], 64, adminAuth);
	if (0 < length)
	{
		g_GagType[target] = 2;
	}
	else
	{
		if (length)
		{
			g_GagType[target] = 1;
		}
		g_GagType[target] = 3;
	}
	return 0;
}

public .61388.MarkClientAsGagged(target, time, length, String:adminName[], String:adminAuth[], adminImmunity, String:reason[])
{
	if (time)
	{
		g_iGagTime[target] = time;
	}
	else
	{
		g_iGagTime[target] = GetTime({0,0});
	}
	g_iGagLength[target] = length;
	new var1;
	if (adminImmunity)
	{
		var1 = adminImmunity;
	}
	else
	{
		var1 = ConsoleImmunity;
	}
	g_iGagLevel[target] = var1;
	strcopy(g_sGagAdminName[target], 32, adminName);
	strcopy(g_sGagReason[target], 256, reason);
	strcopy(g_sGagAdminAuth[target], 64, adminAuth);
	if (0 < length)
	{
		g_GagType[target] = 2;
	}
	else
	{
		if (length)
		{
			g_GagType[target] = 1;
		}
		g_GagType[target] = 3;
	}
	return 0;
}

public .62140.CloseMuteExpireTimer(target)
{
	new var1;
	if (g_hMuteExpireTimer[target] && CloseHandle(g_hMuteExpireTimer[target]))
	{
		g_hMuteExpireTimer[target] = 0;
	}
	return 0;
}

public .62140.CloseMuteExpireTimer(target)
{
	new var1;
	if (g_hMuteExpireTimer[target] && CloseHandle(g_hMuteExpireTimer[target]))
	{
		g_hMuteExpireTimer[target] = 0;
	}
	return 0;
}

public .62320.CloseGagExpireTimer(target)
{
	new var1;
	if (g_hGagExpireTimer[target] && CloseHandle(g_hGagExpireTimer[target]))
	{
		g_hGagExpireTimer[target] = 0;
	}
	return 0;
}

public .62320.CloseGagExpireTimer(target)
{
	new var1;
	if (g_hGagExpireTimer[target] && CloseHandle(g_hGagExpireTimer[target]))
	{
		g_hGagExpireTimer[target] = 0;
	}
	return 0;
}

public .62500.CreateMuteExpireTimer(target, remainingTime)
{
	if (0 < g_iMuteLength[target])
	{
		if (remainingTime)
		{
			g_hMuteExpireTimer[target] = CreateTimer(float(remainingTime), Timer_MuteExpire, GetClientUserId(target), 2);
		}
		g_hMuteExpireTimer[target] = CreateTimer(float(g_iMuteLength[target] * 60), Timer_MuteExpire, GetClientUserId(target), 2);
	}
	return 0;
}

public .62500.CreateMuteExpireTimer(target, remainingTime)
{
	if (0 < g_iMuteLength[target])
	{
		if (remainingTime)
		{
			g_hMuteExpireTimer[target] = CreateTimer(float(remainingTime), Timer_MuteExpire, GetClientUserId(target), 2);
		}
		g_hMuteExpireTimer[target] = CreateTimer(float(g_iMuteLength[target] * 60), Timer_MuteExpire, GetClientUserId(target), 2);
	}
	return 0;
}

public .62872.CreateGagExpireTimer(target, remainingTime)
{
	if (0 < g_iGagLength[target])
	{
		if (remainingTime)
		{
			g_hGagExpireTimer[target] = CreateTimer(float(remainingTime), Timer_GagExpire, GetClientUserId(target), 2);
		}
		g_hGagExpireTimer[target] = CreateTimer(float(g_iGagLength[target] * 60), Timer_GagExpire, GetClientUserId(target), 2);
	}
	return 0;
}

public .62872.CreateGagExpireTimer(target, remainingTime)
{
	if (0 < g_iGagLength[target])
	{
		if (remainingTime)
		{
			g_hGagExpireTimer[target] = CreateTimer(float(remainingTime), Timer_GagExpire, GetClientUserId(target), 2);
		}
		g_hGagExpireTimer[target] = CreateTimer(float(g_iGagLength[target] * 60), Timer_GagExpire, GetClientUserId(target), 2);
	}
	return 0;
}

public .63244.PerformUnMute(target)
{
	.59884.MarkClientAsUnMuted(target);
	BaseComm_SetClientMute(target, false);
	.62140.CloseMuteExpireTimer(target);
	return 0;
}

public .63244.PerformUnMute(target)
{
	.59884.MarkClientAsUnMuted(target);
	BaseComm_SetClientMute(target, false);
	.62140.CloseMuteExpireTimer(target);
	return 0;
}

public .63348.PerformUnGag(target)
{
	.60260.MarkClientAsUnGagged(target);
	BaseComm_SetClientGag(target, false);
	.62320.CloseGagExpireTimer(target);
	return 0;
}

public .63348.PerformUnGag(target)
{
	.60260.MarkClientAsUnGagged(target);
	BaseComm_SetClientGag(target, false);
	.62320.CloseGagExpireTimer(target);
	return 0;
}

public .63452.PerformMute(target, time, length, String:adminName[], String:adminAuth[], adminImmunity, String:reason[], remaining_time)
{
	.60636.MarkClientAsMuted(target, time, length, adminName, adminAuth, adminImmunity, reason);
	BaseComm_SetClientMute(target, true);
	.62500.CreateMuteExpireTimer(target, remaining_time);
	return 0;
}

public .63452.PerformMute(target, time, length, String:adminName[], String:adminAuth[], adminImmunity, String:reason[], remaining_time)
{
	.60636.MarkClientAsMuted(target, time, length, adminName, adminAuth, adminImmunity, reason);
	BaseComm_SetClientMute(target, true);
	.62500.CreateMuteExpireTimer(target, remaining_time);
	return 0;
}

public .63588.PerformGag(target, time, length, String:adminName[], String:adminAuth[], adminImmunity, String:reason[], remaining_time)
{
	.61388.MarkClientAsGagged(target, time, length, adminName, adminAuth, adminImmunity, reason);
	BaseComm_SetClientGag(target, true);
	.62872.CreateGagExpireTimer(target, remaining_time);
	return 0;
}

public .63588.PerformGag(target, time, length, String:adminName[], String:adminAuth[], adminImmunity, String:reason[], remaining_time)
{
	.61388.MarkClientAsGagged(target, time, length, adminName, adminAuth, adminImmunity, reason);
	BaseComm_SetClientGag(target, true);
	.62872.CreateGagExpireTimer(target, remaining_time);
	return 0;
}

public .63724.SavePunishment(admin, target, type, length, String:reason[])
{
	new var1;
	if (type < 1 || type > 3)
	{
		return 0;
	}
	decl String:targetAuth[64];
	if (IsClientInGame(target))
	{
		GetClientAuthId(target, AuthIdType:1, targetAuth, 64, true);
		decl String:adminIp[24];
		decl String:adminAuth[64];
		new var2;
		if (admin && IsClientInGame(admin))
		{
			GetClientIP(admin, adminIp, 24, true);
			GetClientAuthId(admin, AuthIdType:1, adminAuth, 64, true);
		}
		else
		{
			strcopy(adminAuth, 64, "STEAM_ID_SERVER");
			strcopy(adminIp, 24, ServerIp);
		}
		decl String:sName[32];
		strcopy(sName, 32, g_sName[target]);
		if (.45012.DB_Connect())
		{
			decl String:banName[68];
			new String:banReason[516];
			decl String:sAuthidEscaped[132];
			decl String:sAdminAuthIdEscaped[132];
			decl String:sAdminAuthIdYZEscaped[132];
			decl String:sQuery[4096];
			decl String:sQueryAdm[512];
			decl String:sQueryVal[1024];
			decl String:sQueryMute[1024];
			decl String:sQueryGag[1024];
			SQL_EscapeString(g_hDatabase, sName, banName, 65, 0);
			SQL_EscapeString(g_hDatabase, reason, banReason, 513, 0);
			SQL_EscapeString(g_hDatabase, targetAuth, sAuthidEscaped, 129, 0);
			SQL_EscapeString(g_hDatabase, adminAuth, sAdminAuthIdEscaped, 129, 0);
			SQL_EscapeString(g_hDatabase, adminAuth[2], sAdminAuthIdYZEscaped, 129, 0);
			FormatEx(sQueryAdm, 512, "IFNULL((SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), 0)", DatabasePrefix, sAdminAuthIdEscaped, sAdminAuthIdYZEscaped);
			FormatEx(sQueryVal, 1024, "'%s', '%s', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', %s, '%s', %d", sAuthidEscaped, banName, length * 60, length * 60, banReason, sQueryAdm, adminIp, serverID);
			switch (type)
			{
				case 1:
				{
					FormatEx(sQueryMute, 1024, "(%s, %d)", sQueryVal, type);
				}
				case 2:
				{
					FormatEx(sQueryGag, 1024, "(%s, %d)", sQueryVal, type);
				}
				case 3:
				{
					FormatEx(sQueryMute, 1024, "(%s, %d)", sQueryVal, 1);
					FormatEx(sQueryGag, 1024, "(%s, %d)", sQueryVal, 2);
				}
				default:
				{
				}
			}
			new var3;
			if (type == 3)
			{
				var3[0] = 79428;
			}
			else
			{
				var3[0] = 79432;
			}
			FormatEx(sQuery, 4096, "INSERT INTO %s_comms (authid, name, created, ends, length, reason, aid, adminIp, sid, type) VALUES %s%s%s", DatabasePrefix, sQueryMute, var3, sQueryGag);
			new Handle:dataPack = CreateDataPack();
			WritePackCell(dataPack, length);
			WritePackCell(dataPack, type);
			WritePackString(dataPack, sName);
			WritePackString(dataPack, targetAuth);
			WritePackString(dataPack, reason);
			WritePackString(dataPack, adminAuth);
			WritePackString(dataPack, adminIp);
			SQL_TQuery(g_hDatabase, Query_AddBlockInsert, sQuery, dataPack, DBPriority:0);
		}
		else
		{
			.55632.InsertTempBlock(length, type, sName, targetAuth, reason, adminAuth, adminIp);
		}
		return 0;
	}
	return 0;
}

public .63724.SavePunishment(admin, target, type, length, String:reason[])
{
	new var1;
	if (type < 1 || type > 3)
	{
		return 0;
	}
	decl String:targetAuth[64];
	if (IsClientInGame(target))
	{
		GetClientAuthId(target, AuthIdType:1, targetAuth, 64, true);
		decl String:adminIp[24];
		decl String:adminAuth[64];
		new var2;
		if (admin && IsClientInGame(admin))
		{
			GetClientIP(admin, adminIp, 24, true);
			GetClientAuthId(admin, AuthIdType:1, adminAuth, 64, true);
		}
		else
		{
			strcopy(adminAuth, 64, "STEAM_ID_SERVER");
			strcopy(adminIp, 24, ServerIp);
		}
		decl String:sName[32];
		strcopy(sName, 32, g_sName[target]);
		if (.45012.DB_Connect())
		{
			decl String:banName[68];
			new String:banReason[516];
			decl String:sAuthidEscaped[132];
			decl String:sAdminAuthIdEscaped[132];
			decl String:sAdminAuthIdYZEscaped[132];
			decl String:sQuery[4096];
			decl String:sQueryAdm[512];
			decl String:sQueryVal[1024];
			decl String:sQueryMute[1024];
			decl String:sQueryGag[1024];
			SQL_EscapeString(g_hDatabase, sName, banName, 65, 0);
			SQL_EscapeString(g_hDatabase, reason, banReason, 513, 0);
			SQL_EscapeString(g_hDatabase, targetAuth, sAuthidEscaped, 129, 0);
			SQL_EscapeString(g_hDatabase, adminAuth, sAdminAuthIdEscaped, 129, 0);
			SQL_EscapeString(g_hDatabase, adminAuth[2], sAdminAuthIdYZEscaped, 129, 0);
			FormatEx(sQueryAdm, 512, "IFNULL((SELECT aid FROM %s_admins WHERE authid = '%s' OR authid REGEXP '^STEAM_[0-9]:%s$'), 0)", DatabasePrefix, sAdminAuthIdEscaped, sAdminAuthIdYZEscaped);
			FormatEx(sQueryVal, 1024, "'%s', '%s', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + %d, %d, '%s', %s, '%s', %d", sAuthidEscaped, banName, length * 60, length * 60, banReason, sQueryAdm, adminIp, serverID);
			switch (type)
			{
				case 1:
				{
					FormatEx(sQueryMute, 1024, "(%s, %d)", sQueryVal, type);
				}
				case 2:
				{
					FormatEx(sQueryGag, 1024, "(%s, %d)", sQueryVal, type);
				}
				case 3:
				{
					FormatEx(sQueryMute, 1024, "(%s, %d)", sQueryVal, 1);
					FormatEx(sQueryGag, 1024, "(%s, %d)", sQueryVal, 2);
				}
				default:
				{
				}
			}
			new var3;
			if (type == 3)
			{
				var3[0] = 79428;
			}
			else
			{
				var3[0] = 79432;
			}
			FormatEx(sQuery, 4096, "INSERT INTO %s_comms (authid, name, created, ends, length, reason, aid, adminIp, sid, type) VALUES %s%s%s", DatabasePrefix, sQueryMute, var3, sQueryGag);
			new Handle:dataPack = CreateDataPack();
			WritePackCell(dataPack, length);
			WritePackCell(dataPack, type);
			WritePackString(dataPack, sName);
			WritePackString(dataPack, targetAuth);
			WritePackString(dataPack, reason);
			WritePackString(dataPack, adminAuth);
			WritePackString(dataPack, adminIp);
			SQL_TQuery(g_hDatabase, Query_AddBlockInsert, sQuery, dataPack, DBPriority:0);
		}
		else
		{
			.55632.InsertTempBlock(length, type, sName, targetAuth, reason, adminAuth, adminIp);
		}
		return 0;
	}
	return 0;
}

public .65888.ShowActivityToServer(admin, type, length, String:reason[], String:targetName[], bool:ml)
{
	decl String:actionName[32];
	decl String:translationName[64];
	switch (type)
	{
		case 1:
		{
			if (0 < length)
			{
				strcopy(actionName, 32, "Muted");
			}
			else
			{
				if (length)
				{
					strcopy(actionName, 32, "Temp muted");
				}
				strcopy(actionName, 32, "Permamuted");
			}
		}
		case 2:
		{
			if (0 < length)
			{
				strcopy(actionName, 32, "Gagged");
			}
			else
			{
				if (length)
				{
					strcopy(actionName, 32, "Temp gagged");
				}
				strcopy(actionName, 32, "Permagagged");
			}
		}
		case 3:
		{
			if (0 < length)
			{
				strcopy(actionName, 32, "Silenced");
			}
			else
			{
				if (length)
				{
					strcopy(actionName, 32, "Temp silenced");
				}
				strcopy(actionName, 32, "Permasilenced");
			}
		}
		case 4:
		{
			strcopy(actionName, 32, "Unmuted");
		}
		case 5:
		{
			strcopy(actionName, 32, "Ungagged");
		}
		case 14:
		{
			strcopy(actionName, 32, "Temp unmuted");
		}
		case 15:
		{
			strcopy(actionName, 32, "Temp ungagged");
		}
		case 16:
		{
			strcopy(actionName, 32, "Temp unsilenced");
		}
		default:
		{
			return 0;
		}
	}
	new var1;
	if (reason[0])
	{
		var1[0] = 79628;
	}
	else
	{
		var1[0] = 79620;
	}
	Format(translationName, 64, "%s %s", actionName, var1);
	if (0 < length)
	{
		if (ml)
		{
			ShowActivity2(admin, "\x04[SourceComms]\x01 ", "%t", translationName, targetName, length, reason);
		}
		else
		{
			ShowActivity2(admin, "\x04[SourceComms]\x01 ", "%t", translationName, "_s", targetName, length, reason);
		}
	}
	else
	{
		if (ml)
		{
			ShowActivity2(admin, "\x04[SourceComms]\x01 ", "%t", translationName, targetName, reason);
		}
		ShowActivity2(admin, "\x04[SourceComms]\x01 ", "%t", translationName, "_s", targetName, reason);
	}
	return 0;
}

public .65888.ShowActivityToServer(admin, type, length, String:reason[], String:targetName[], bool:ml)
{
	decl String:actionName[32];
	decl String:translationName[64];
	switch (type)
	{
		case 1:
		{
			if (0 < length)
			{
				strcopy(actionName, 32, "Muted");
			}
			else
			{
				if (length)
				{
					strcopy(actionName, 32, "Temp muted");
				}
				strcopy(actionName, 32, "Permamuted");
			}
		}
		case 2:
		{
			if (0 < length)
			{
				strcopy(actionName, 32, "Gagged");
			}
			else
			{
				if (length)
				{
					strcopy(actionName, 32, "Temp gagged");
				}
				strcopy(actionName, 32, "Permagagged");
			}
		}
		case 3:
		{
			if (0 < length)
			{
				strcopy(actionName, 32, "Silenced");
			}
			else
			{
				if (length)
				{
					strcopy(actionName, 32, "Temp silenced");
				}
				strcopy(actionName, 32, "Permasilenced");
			}
		}
		case 4:
		{
			strcopy(actionName, 32, "Unmuted");
		}
		case 5:
		{
			strcopy(actionName, 32, "Ungagged");
		}
		case 14:
		{
			strcopy(actionName, 32, "Temp unmuted");
		}
		case 15:
		{
			strcopy(actionName, 32, "Temp ungagged");
		}
		case 16:
		{
			strcopy(actionName, 32, "Temp unsilenced");
		}
		default:
		{
			return 0;
		}
	}
	new var1;
	if (reason[0])
	{
		var1[0] = 79628;
	}
	else
	{
		var1[0] = 79620;
	}
	Format(translationName, 64, "%s %s", actionName, var1);
	if (0 < length)
	{
		if (ml)
		{
			ShowActivity2(admin, "\x04[SourceComms]\x01 ", "%t", translationName, targetName, length, reason);
		}
		else
		{
			ShowActivity2(admin, "\x04[SourceComms]\x01 ", "%t", translationName, "_s", targetName, length, reason);
		}
	}
	else
	{
		if (ml)
		{
			ShowActivity2(admin, "\x04[SourceComms]\x01 ", "%t", translationName, targetName, reason);
		}
		ShowActivity2(admin, "\x04[SourceComms]\x01 ", "%t", translationName, "_s", targetName, reason);
	}
	return 0;
}

public Native_SetClientMute(Handle:hPlugin, numParams)
{
	new target = GetNativeCell(1);
	new var1;
	if (target < 1 || target > MaxClients)
	{
		return ThrowNativeError(23, "Invalid client index %d", target);
	}
	if (!IsClientInGame(target))
	{
		return ThrowNativeError(23, "Client %d is not in game", target);
	}
	new bool:muteState = GetNativeCell(2);
	new muteLength = GetNativeCell(3);
	new var2;
	if (muteState && muteLength)
	{
		return ThrowNativeError(23, "Permanent mute is not allowed!");
	}
	new bool:bSaveToDB = GetNativeCell(4);
	new var3;
	if (!muteState && bSaveToDB)
	{
		return ThrowNativeError(23, "Removing punishments from DB is not allowed!");
	}
	new String:sReason[256];
	GetNativeString(5, sReason, 256, 0);
	if (muteState)
	{
		if (bType:0 < g_MuteType[target])
		{
			return 0;
		}
		.63452.PerformMute(target, 0, muteLength, "CONSOLE", "STEAM_ID_SERVER", 0, sReason, 0);
		if (bSaveToDB)
		{
			.63724.SavePunishment(0, target, 1, muteLength, sReason);
		}
	}
	else
	{
		if (g_MuteType[target])
		{
			.63244.PerformUnMute(target);
		}
		return 0;
	}
	return 1;
}

public Native_SetClientGag(Handle:hPlugin, numParams)
{
	new target = GetNativeCell(1);
	new var1;
	if (target < 1 || target > MaxClients)
	{
		return ThrowNativeError(23, "Invalid client index %d", target);
	}
	if (!IsClientInGame(target))
	{
		return ThrowNativeError(23, "Client %d is not in game", target);
	}
	new bool:gagState = GetNativeCell(2);
	new gagLength = GetNativeCell(3);
	new var2;
	if (gagState && gagLength)
	{
		return ThrowNativeError(23, "Permanent gag is not allowed!");
	}
	new bool:bSaveToDB = GetNativeCell(4);
	new var3;
	if (!gagState && bSaveToDB)
	{
		return ThrowNativeError(23, "Removing punishments from DB is not allowed!");
	}
	new String:sReason[256];
	GetNativeString(5, sReason, 256, 0);
	if (gagState)
	{
		if (bType:0 < g_GagType[target])
		{
			return 0;
		}
		.63588.PerformGag(target, 0, gagLength, "CONSOLE", "STEAM_ID_SERVER", 0, sReason, 0);
		if (bSaveToDB)
		{
			.63724.SavePunishment(0, target, 2, gagLength, sReason);
		}
	}
	else
	{
		if (g_GagType[target])
		{
			.63348.PerformUnGag(target);
		}
		return 0;
	}
	return 1;
}

public Native_GetClientMuteType(Handle:hPlugin, numParams)
{
	new target = GetNativeCell(1);
	new var1;
	if (target < 1 || target > MaxClients)
	{
		return ThrowNativeError(23, "Invalid client index %d", target);
	}
	if (!IsClientInGame(target))
	{
		return ThrowNativeError(23, "Client %d is not in game", target);
	}
	return g_MuteType[target];
}

public Native_GetClientGagType(Handle:hPlugin, numParams)
{
	new target = GetNativeCell(1);
	new var1;
	if (target < 1 || target > MaxClients)
	{
		return ThrowNativeError(23, "Invalid client index %d", target);
	}
	if (!IsClientInGame(target))
	{
		return ThrowNativeError(23, "Client %d is not in game", target);
	}
	return g_GagType[target];
}

