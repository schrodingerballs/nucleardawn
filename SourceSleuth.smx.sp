public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "04/02/2016",
	time = "16:55:25"
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
	required = 0,
};
new Handle:hDatabase;
new Handle:g_hAllowedArray;
new ConVar:g_cVar_actions;
new ConVar:g_cVar_banduration;
new ConVar:g_cVar_sbprefix;
new ConVar:g_cVar_bansAllowed;
new ConVar:g_cVar_bantype;
new ConVar:g_cVar_bypass;
new bool:CanUseSourcebans;
public Plugin:myinfo =
{
	name = "SourceSleuth",
	description = "Useful for TF2 servers. Plugin will check for banned ips and ban the player.",
	author = "ecca, Sarabveer(VEER™)",
	version = "(SB++) 1.5.4.3",
	url = "http://sourcemod.net"
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

public __pl_sourcebans_SetNTVOptional()
{
	MarkNativeAsOptional("SBBanPlayer");
	return 0;
}

public void:OnPluginStart()
{
	LoadTranslations("sourcesleuth.phrases");
	CreateConVar("sm_sourcesleuth_version", "(SB++) 1.5.4.3", "SourceSleuth plugin version", 401728, false, 0.0, false, 0.0);
	g_cVar_actions = CreateConVar("sm_sleuth_actions", "3", "Sleuth Ban Type: 1 - Original Length, 2 - Custom Length, 3 - Double Length, 4 - Notify Admins Only", 262144, true, 1.0, true, 4.0);
	g_cVar_banduration = CreateConVar("sm_sleuth_duration", "0", "Required: sm_sleuth_actions 1: Bantime to ban player if we got a match (0 = permanent (defined in minutes) )", 262144, false, 0.0, false, 0.0);
	g_cVar_sbprefix = CreateConVar("sm_sleuth_prefix", "sb", "Prexfix for sourcebans tables: Default sb", 262144, false, 0.0, false, 0.0);
	g_cVar_bansAllowed = CreateConVar("sm_sleuth_bansallowed", "0", "How many active bans are allowed before we act", 262144, false, 0.0, false, 0.0);
	g_cVar_bantype = CreateConVar("sm_sleuth_bantype", "0", "0 - ban all type of lengths, 1 - ban only permanent bans", 262144, true, 0.0, true, 1.0);
	g_cVar_bypass = CreateConVar("sm_sleuth_adminbypass", "0", "0 - Inactivated, 1 - Allow all admins with ban flag to pass the check", 262144, true, 0.0, true, 1.0);
	g_hAllowedArray = CreateArray(256, 0);
	AutoExecConfig(true, "Sm_SourceSleuth", "sourcemod");
	SQL_TConnect(SQL_OnConnect, "sourcebans", any:0);
	RegAdminCmd("sm_sleuth_reloadlist", ReloadListCallBack, 16384, "", "", 0);
	LoadWhiteList();
	return void:0;
}

public void:OnAllPluginsLoaded()
{
	CanUseSourcebans = LibraryExists("sourcebans");
	return void:0;
}

public void:OnLibraryAdded(String:name[])
{
	if (StrEqual("sourcebans", name, true))
	{
		CanUseSourcebans = true;
	}
	return void:0;
}

public void:OnLibraryRemoved(String:name[])
{
	if (StrEqual("sourcebans", name, true))
	{
		CanUseSourcebans = false;
	}
	return void:0;
}

public SQL_OnConnect(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		hDatabase = hndl;
	}
	else
	{
		LogError("SourceSleuth: Database connection error: %s", error);
	}
	return 0;
}

public Action:ReloadListCallBack(client, args)
{
	ClearArray(g_hAllowedArray);
	LoadWhiteList();
	LogMessage("%L reloaded the whitelist", client);
	if (client)
	{
		PrintToChat(client, "[SourceSleuth] WhiteList has been reloaded!");
	}
	return Action:0;
}

public void:OnClientPostAdminCheck(client)
{
	new var1;
	if (CanUseSourcebans && !IsFakeClient(client))
	{
		new String:steamid[32];
		GetClientAuthId(client, AuthIdType:1, steamid, 32, true);
		new var2;
		if (ConVar.BoolValue.get(g_cVar_bypass) && CheckCommandAccess(client, "sleuth_admin", 8, false))
		{
			return void:0;
		}
		if (FindStringInArray(g_hAllowedArray, steamid) == -1)
		{
			new String:IP[32];
			new String:Prefix[64];
			GetClientIP(client, IP, 32, true);
			ConVar.GetString(g_cVar_sbprefix, Prefix, 64);
			new String:query[1024];
			new var3;
			if (ConVar.IntValue.get(g_cVar_bantype))
			{
				var3 = 0;
			}
			else
			{
				var3 = GetTime({0,0});
			}
			FormatEx(query, 1024, "SELECT * FROM %s_bans WHERE ip='%s' AND RemoveType IS NULL AND ends > %d", Prefix, IP, var3);
			new Handle:datapack = CreateDataPack();
			WritePackCell(datapack, GetClientUserId(client));
			WritePackString(datapack, steamid);
			WritePackString(datapack, IP);
			ResetPack(datapack, false);
			SQL_TQuery(hDatabase, SQL_CheckHim, query, datapack, DBPriority:1);
		}
	}
	return void:0;
}

public SQL_CheckHim(Handle:owner, Handle:hndl, String:error[], any:datapack)
{
	new client;
	decl String:steamid[32];
	decl String:IP[32];
	if (datapack)
	{
		client = GetClientOfUserId(ReadPackCell(datapack));
		ReadPackString(datapack, steamid, 32);
		ReadPackString(datapack, IP, 32);
		CloseHandle(datapack);
	}
	if (hndl)
	{
		if (SQL_FetchRow(hndl))
		{
			new TotalBans = SQL_GetRowCount(hndl);
			if (ConVar.IntValue.get(g_cVar_bansAllowed) < TotalBans)
			{
				switch (ConVar.IntValue.get(g_cVar_actions))
				{
					case 1:
					{
						new length = SQL_FetchInt(hndl, 6, 0);
						new time = length * 60;
						BanPlayer(client, time);
					}
					case 2:
					{
						new time = ConVar.IntValue.get(g_cVar_banduration);
						BanPlayer(client, time);
					}
					case 3:
					{
						new length = SQL_FetchInt(hndl, 6, 0);
						new time = length / 60 * 2;
						BanPlayer(client, time);
					}
					case 4:
					{
						PrintToAdmins("[SourceSleuth] %t", "sourcesleuth_admintext", client, steamid, IP);
					}
					default:
					{
					}
				}
			}
		}
		return 0;
	}
	LogError("SourceSleuth: Database query error: %s", error);
	return 0;
}

BanPlayer(client, time)
{
	decl String:Reason[256];
	Format(Reason, 255, "[SourceSleuth] %t", "sourcesleuth_banreason");
	SBBanPlayer(0, client, time, Reason);
	return 0;
}

PrintToAdmins(String:format[])
{
	new String:g_Buffer[256];
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (CheckCommandAccess(i, "sm_sourcesleuth_printtoadmins", 8, false) && IsClientInGame(i))
		{
			VFormat(g_Buffer, 256, format, 2);
			PrintToChat(i, "%s", g_Buffer);
		}
		i++;
	}
	return 0;
}

public LoadWhiteList()
{
	decl String:path[256];
	decl String:line[256];
	BuildPath(PathType:0, path, 256, "configs/sourcesleuth_whitelist.cfg");
	new Handle:fileHandle = OpenFile(path, "r", false, "GAME");
	while (!IsEndOfFile(fileHandle) && ReadFileLine(fileHandle, line, 256))
	{
		ReplaceString(line, 256, "\n", "", false);
		PushArrayString(g_hAllowedArray, line);
	}
	CloseHandle(fileHandle);
	return 0;
}

