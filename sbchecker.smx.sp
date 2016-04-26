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
new String:g_DatabasePrefix[12] = "sb";
new Handle:g_ConfigParser;
new Handle:g_DB;
new ConVar:ShortMessage;
public Plugin:myinfo =
{
	name = "SourceBans Checker",
	description = "Notifies admins of prior bans from Sourcebans upon player connect.",
	author = "psychonic, Ca$h Munny, Sarabveer(VEER™)",
	version = "(SB++) 1.5.4",
	url = "http://www.nicholashastings.com"
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

public .2920.ReplyToTargetError(client, reason)
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

public .2920.ReplyToTargetError(client, reason)
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

public .3384.FindTarget(client, String:target[], bool:nobots, bool:immunity)
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
	.2920.ReplyToTargetError(client, target_count);
	return -1;
}

public .3384.FindTarget(client, String:target[], bool:nobots, bool:immunity)
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
	.2920.ReplyToTargetError(client, target_count);
	return -1;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	CreateConVar("sbchecker_version", "(SB++) 1.5.4", "", 256, false, 0.0, false, 0.0);
	ShortMessage = CreateConVar("sb_short_message", "0", "Use shorter message for displying prev bans", 0, true, 0.0, true, 1.0);
	RegAdminCmd("sm_listsbbans", OnListSourceBansCmd, 8, "sm_listsbbans <#userid|name> - Lists a user's prior bans from Sourcebans", "", 0);
	RegAdminCmd("sb_reload", OnReloadCmd, 4096, "Reload sourcebans config and ban reason menu options", "", 0);
	SQL_TConnect(OnDatabaseConnected, "sourcebans", any:0);
	return void:0;
}

public void:OnMapStart()
{
	.9556.ReadConfig();
	return void:0;
}

public Action:OnReloadCmd(client, args)
{
	.9556.ReadConfig();
	return Action:3;
}

public OnDatabaseConnected(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (!hndl)
	{
		SetFailState("Failed to connect to SourceBans DB, %s", error);
	}
	g_DB = hndl;
	return 0;
}

public void:OnClientAuthorized(client, String:auth[])
{
	if (g_DB)
	{
		new var1;
		if (auth[0] == 'B' || auth[2] == 'L')
		{
			return void:0;
		}
		decl String:query[512];
		decl String:ip[32];
		GetClientIP(client, ip, 30, true);
		FormatEx(query, 512, "SELECT COUNT(bid) FROM %s_bans WHERE ((type = 0 AND authid REGEXP '^STEAM_[0-9]:%s$') OR (type = 1 AND ip = '%s')) AND ((length > '0' AND ends > UNIX_TIMESTAMP()) OR RemoveType IS NOT NULL)", g_DatabasePrefix, auth[2], ip);
		SQL_TQuery(g_DB, OnConnectBanCheck, query, GetClientUserId(client), DBPriority:2);
		return void:0;
	}
	return void:0;
}

public OnConnectBanCheck(Handle:owner, Handle:hndl, String:error[], any:userid)
{
	new client = GetClientOfUserId(userid);
	new var1;
	if (!client || hndl || !SQL_FetchRow(hndl))
	{
		return 0;
	}
	new bancount = SQL_FetchInt(hndl, 0, 0);
	if (0 < bancount)
	{
		if (ConVar.BoolValue.get(ShortMessage))
		{
			new var2;
			if (bancount > 0)
			{
				var2 = 3264;
			}
			else
			{
				var2 = 3268;
			}
			.9224.PrintToBanAdmins("\x04[SB]\x01Player \"%N\" has %d previous ban%s.", client, bancount, var2);
		}
		new var3;
		if (bancount > 0)
		{
			var3 = 3344;
		}
		else
		{
			var3 = 3348;
		}
		.9224.PrintToBanAdmins("\x04[SourceBans]\x01 Warning: Player \"%N\" has %d previous SB ban%s on record.", client, bancount, var3);
	}
	return 0;
}

public Action:OnListSourceBansCmd(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "sm_listsbbans <#userid|name> - Lists a user's prior bans from Sourcebans");
	}
	if (g_DB)
	{
		decl String:targetarg[64];
		GetCmdArg(1, targetarg, 64);
		new target = .3384.FindTarget(client, targetarg, true, true);
		if (target == -1)
		{
			ReplyToCommand(client, "Error: Could not find a target matching '%s'.", targetarg);
			return Action:3;
		}
		decl String:auth[32];
		new var1;
		if (!GetClientAuthId(target, AuthIdType:1, auth, 32, true) || auth[0] == 'B' || auth[2] == 'L')
		{
			ReplyToCommand(client, "Error: Could not retrieve %N's steam id.", target);
			return Action:3;
		}
		decl String:query[1024];
		decl String:ip[32];
		GetClientIP(target, ip, 30, true);
		FormatEx(query, 1024, "SELECT created, %s_admins.user, ends, length, reason, RemoveType FROM %s_bans LEFT JOIN %s_admins ON %s_bans.aid = %s_admins.aid WHERE ((type = 0 AND %s_bans.authid REGEXP '^STEAM_[0-9]:%s$') OR (type = 1 AND ip = '%s')) AND ((length > '0' AND ends > UNIX_TIMESTAMP()) OR RemoveType IS NOT NULL)", g_DatabasePrefix, g_DatabasePrefix, g_DatabasePrefix, g_DatabasePrefix, g_DatabasePrefix, g_DatabasePrefix, auth[2], ip);
		decl String:targetName[32];
		GetClientName(target, targetName, 32);
		new Handle:pack = CreateDataPack();
		new var2;
		if (client)
		{
			var2 = GetClientUserId(client);
		}
		else
		{
			var2 = MissingTAG:0;
		}
		WritePackCell(pack, var2);
		WritePackString(pack, targetName);
		SQL_TQuery(g_DB, OnListBans, query, pack, DBPriority:2);
		if (client)
		{
			ReplyToCommand(client, "\x04[SourceBans]\x01 Look for %N's ban results in console.", target);
		}
		else
		{
			ReplyToCommand(client, "[SourceBans] Note: if you are using this command through an rcon tool, you will not see results.");
		}
		return Action:3;
	}
	ReplyToCommand(client, "Error: Database not ready.");
	return Action:3;
}

public OnListBans(Handle:owner, Handle:hndl, String:error[], any:pack)
{
	ResetPack(pack, false);
	new clientuid = ReadPackCell(pack);
	new client = GetClientOfUserId(clientuid);
	decl String:targetName[32];
	ReadPackString(pack, targetName, 32);
	CloseHandle(pack);
	new var1;
	if (clientuid > 0 && client)
	{
		return 0;
	}
	if (hndl)
	{
		if (SQL_GetRowCount(hndl))
		{
			.9040.PrintListResponse(clientuid, client, "[SourceBans] Listing bans for %s", targetName);
			.9040.PrintListResponse(clientuid, client, "Ban Date    Banned By   Length      End Date    R  Reason");
			.9040.PrintListResponse(clientuid, client, "-------------------------------------------------------------------------------");
			while (SQL_FetchRow(hndl))
			{
				new String:createddate[12] = "<Unknown> ";
				new String:bannedby[12] = "<Unknown> ";
				new String:lenstring[12] = "N/A       ";
				new String:enddate[12] = "N/A       ";
				decl String:reason[28];
				decl String:RemoveType[4];
				if (!SQL_IsFieldNull(hndl, 0))
				{
					FormatTime(createddate, 11, "%Y-%m-%d", SQL_FetchInt(hndl, 0, 0));
				}
				if (!SQL_IsFieldNull(hndl, 1))
				{
					new size_bannedby = 11;
					SQL_FetchString(hndl, 1, bannedby, size_bannedby, 0);
					new len = SQL_FetchSize(hndl, 1);
					if (size_bannedby + -1 < len)
					{
						reason[size_bannedby + -4] = MissingTAG:46;
						reason[size_bannedby + -3] = MissingTAG:46;
						reason[size_bannedby + -2] = MissingTAG:46;
					}
					else
					{
						new i = len;
						while (size_bannedby + -1 > i)
						{
							bannedby[i] = MissingTAG:32;
							i++;
						}
					}
				}
				new size_lenstring = 11;
				new length = SQL_FetchInt(hndl, 3, 0);
				if (length)
				{
					new len = IntToString(length, lenstring, size_lenstring);
					if (size_lenstring + -1 > len)
					{
						lenstring[len] = MissingTAG:32;
					}
				}
				else
				{
					strcopy(lenstring, size_lenstring, "Permanent ");
				}
				if (!SQL_IsFieldNull(hndl, 2))
				{
					FormatTime(enddate, 11, "%Y-%m-%d", SQL_FetchInt(hndl, 2, 0));
				}
				new reason_size = 28;
				SQL_FetchString(hndl, 4, reason, reason_size, 0);
				new len = SQL_FetchSize(hndl, 4);
				if (reason_size + -1 < len)
				{
					reason[reason_size + -4] = MissingTAG:46;
					reason[reason_size + -3] = MissingTAG:46;
					reason[reason_size + -2] = MissingTAG:46;
				}
				else
				{
					new i = len;
					while (reason_size + -1 > i)
					{
						reason[i] = MissingTAG:32;
						i++;
					}
				}
				if (!SQL_IsFieldNull(hndl, 5))
				{
					SQL_FetchString(hndl, 5, RemoveType, 2, 0);
				}
				.9040.PrintListResponse(clientuid, client, "%s  %s  %s  %s  %s  %s", createddate, bannedby, lenstring, enddate, RemoveType, reason);
			}
			return 0;
		}
		.9040.PrintListResponse(clientuid, client, "[SourceBans] No bans found for %s.", targetName);
		return 0;
	}
	.9040.PrintListResponse(clientuid, client, "[SourceBans] DB error while retrieving bans for %s:\n%s", targetName, error);
	return 0;
}

public .9040.PrintListResponse(userid, client, String:format[])
{
	decl String:msg[192];
	VFormat(msg, 192, format, 4);
	if (userid)
	{
		PrintToConsole(client, "%s", msg);
	}
	else
	{
		PrintToServer("%s", msg);
	}
	return 0;
}

public .9040.PrintListResponse(userid, client, String:format[])
{
	decl String:msg[192];
	VFormat(msg, 192, format, 4);
	if (userid)
	{
		PrintToConsole(client, "%s", msg);
	}
	else
	{
		PrintToServer("%s", msg);
	}
	return 0;
}

public .9224.PrintToBanAdmins(String:format[])
{
	decl String:msg[128];
	VFormat(msg, 128, format, 2);
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i) && CheckCommandAccess(i, "sm_listsourcebans", 8, false))
		{
			PrintToChat(i, "%s", msg);
		}
		i++;
	}
	return 0;
}

public .9224.PrintToBanAdmins(String:format[])
{
	decl String:msg[128];
	VFormat(msg, 128, format, 2);
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i) && CheckCommandAccess(i, "sm_listsourcebans", 8, false))
		{
			PrintToChat(i, "%s", msg);
		}
		i++;
	}
	return 0;
}

public .9556.ReadConfig()
{
	.9856.InitializeConfigParser();
	if (g_ConfigParser)
	{
		decl String:ConfigFile[256];
		BuildPath(PathType:0, ConfigFile, 256, "configs/sourcebans/sourcebans.cfg");
		if (FileExists(ConfigFile, false, "GAME"))
		{
			.9976.InternalReadConfig(ConfigFile);
		}
		else
		{
			decl String:Error[320];
			FormatEx(Error, 320, "FATAL *** ERROR *** can not find %s", ConfigFile);
			SetFailState(Error);
		}
		return 0;
	}
	return 0;
}

public .9556.ReadConfig()
{
	.9856.InitializeConfigParser();
	if (g_ConfigParser)
	{
		decl String:ConfigFile[256];
		BuildPath(PathType:0, ConfigFile, 256, "configs/sourcebans/sourcebans.cfg");
		if (FileExists(ConfigFile, false, "GAME"))
		{
			.9976.InternalReadConfig(ConfigFile);
		}
		else
		{
			decl String:Error[320];
			FormatEx(Error, 320, "FATAL *** ERROR *** can not find %s", ConfigFile);
			SetFailState(Error);
		}
		return 0;
	}
	return 0;
}

public .9856.InitializeConfigParser()
{
	if (!g_ConfigParser)
	{
		g_ConfigParser = SMC_CreateParser();
		SMC_SetReaders(g_ConfigParser, ReadConfig_NewSection, ReadConfig_KeyValue, ReadConfig_EndSection);
	}
	return 0;
}

public .9856.InitializeConfigParser()
{
	if (!g_ConfigParser)
	{
		g_ConfigParser = SMC_CreateParser();
		SMC_SetReaders(g_ConfigParser, ReadConfig_NewSection, ReadConfig_KeyValue, ReadConfig_EndSection);
	}
	return 0;
}

public .9976.InternalReadConfig(String:path[])
{
	new SMCError:err = SMC_ParseFile(g_ConfigParser, path, 0, 0);
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
			var1[0] = 4492;
		}
		PrintToServer("%s", var1);
	}
	return 0;
}

public .9976.InternalReadConfig(String:path[])
{
	new SMCError:err = SMC_ParseFile(g_ConfigParser, path, 0, 0);
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
			var1[0] = 4492;
		}
		PrintToServer("%s", var1);
	}
	return 0;
}

public SMCResult:ReadConfig_NewSection(Handle:smc, String:name[], bool:opt_quotes)
{
	return SMCResult:0;
}

public SMCResult:ReadConfig_KeyValue(Handle:smc, String:key[], String:value[], bool:key_quotes, bool:value_quotes)
{
	if (!(strcmp("DatabasePrefix", key, false)))
	{
		strcopy(g_DatabasePrefix, 10, value);
		if (!g_DatabasePrefix[0])
		{
		}
	}
	return SMCResult:0;
}

public SMCResult:ReadConfig_EndSection(Handle:smc)
{
	return SMCResult:0;
}

