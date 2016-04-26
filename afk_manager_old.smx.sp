public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "04:59:12"
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
new bool:bEventIsHooked[6];
new bool:bCvarIsHooked[6];
new String:AFKM_LogFile[256];
new Float:fAFKTime[66];
new Float:fEyePosition[66][3];
new Float:fMapPosition[66][3];
new Float:fSpawnPosition[66][3];
new bool:bAFKSpawn[66];
new iSpecMode[66];
new iSpecTarget[66];
new iPlayerTeam[66] =
{
	-1, ...
};
new iTeamPlayers[66];
new bool:bJoinedTeam[66];
new bool:bLogWarnings;
new bool:bExcludeBots;
new iNumPlayers;
new g_TF2_WFP_StartTime;
new g_Spec_FL_Mode;
new g_sTeam_Index = 1;
new bool:bTF2Arena;
new bool:bWaitRound;
new bool:bMovePlayers = 1;
new bool:bKickPlayers = 1;
new Handle:hCvarVersion;
new Handle:hCvarEnabled;
new Handle:hCvarAutoUpdate;
new Handle:hCvarPrefixShort;
new Handle:hCvarLogWarnings;
new Handle:hCvarLogMoves;
new Handle:hCvarLogKicks;
new Handle:hCvarLogDays;
new Handle:hCvarMinPlayersMove;
new Handle:hCvarMinPlayersKick;
new Handle:hCvarAdminsImmune;
new Handle:hCvarAdminsFlag;
new Handle:hCvarMoveSpec;
new Handle:hCvarTimeToMove;
new Handle:hCvarWarnTimeToMove;
new Handle:hCvarKickPlayers;
new Handle:hCvarTimeToKick;
new Handle:hCvarWarnTimeToKick;
new Handle:hCvarSpawnTime;
new Handle:hCvarWarnSpawnTime;
new Handle:hCvarExcludeBots;
new Handle:hCvarExcludeDead;
new Handle:hCvarLocationThreshold;
new Handle:hAFKTimers[66];
new Handle:hCvarAFK;
new Handle:hCvarTF2Arena;
new Handle:hCvarTF2WFPTime;
new bool:Insurgency;
new bool:Synergy;
new bool:TF2;
new bool:CSTRIKE;
new bool:NUCLEARDAWN;
new SDKEngine;
public Plugin:myinfo =
{
	name = "AFK Manager",
	description = "Handles AFK Players",
	author = "Rothgar (Modded by Calystos)",
	version = "3.5.2",
	url = "http://www.dawgclan.net"
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

bool:operator>(_:,Float:)(oper1, Float:oper2)
{
	return float(oper1) > oper2;
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
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

BuildLogFilePath()
{
	new String:sLogPath[256];
	BuildPath(PathType:0, sLogPath, 256, "logs");
	if (!DirExists(sLogPath, false, "GAME"))
	{
		CreateDirectory(sLogPath, 511, false, "DEFAULT_WRITE_PATH");
	}
	decl String:cTime[64];
	FormatTime(cTime, 64, "logs/afkm_%Y%m%d.log", -1);
	new String:sLogFile[256] = AFKM_LogFile;
	BuildPath(PathType:0, AFKM_LogFile, 256, cTime);
	if (!StrEqual(AFKM_LogFile, sLogFile, true))
	{
		LogAction(0, -1, "[AFK Manager] Log File: %s", AFKM_LogFile);
		if (hCvarLogDays)
		{
			if (0 < GetConVarInt(hCvarLogDays))
			{
				PurgeOldLogs();
			}
		}
	}
	return 0;
}

PurgeOldLogs()
{
	new String:sLogPath[256];
	new String:buffer[256];
	new Handle:hDirectory;
	new FileType:type;
	BuildPath(PathType:0, sLogPath, 256, "logs");
	if (DirExists(sLogPath, false, "GAME"))
	{
		hDirectory = OpenDirectory(sLogPath, false, "GAME");
		if (hDirectory)
		{
			while (ReadDirEntry(hDirectory, buffer, 256, type))
			{
				if (type == FileType:2)
				{
					if (StrContains(buffer, "afkm_", false) != -1)
					{
						decl String:file[256];
						Format(file, 256, "%s/%s", sLogPath, buffer);
						if (GetTime({0,0}) - GetConVarInt(hCvarLogDays) * 86400 + 30 > GetFileTime(file, FileTimeMode:2))
						{
							if (DeleteFile(file, false, "DEFAULT_WRITE_PATH"))
							{
								LogAction(0, -1, "[AFK Manager] Deleted Old Log File: %s", file);
							}
						}
					}
				}
			}
		}
	}
	if (hDirectory)
	{
		CloseHandle(hDirectory);
		hDirectory = MissingTAG:0;
	}
	return 0;
}

AFK_PrintToChat(client, String:szMessage[])
{
	decl String:szBuffer[252];
	VFormat(szBuffer, 250, szMessage, 3);
	if (GetConVarBool(hCvarPrefixShort))
	{
		PrintToChat(client, "[AFK] %s", szBuffer);
	}
	else
	{
		PrintToChat(client, "[AFK Manager] %s", szBuffer);
	}
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

AFK_GetClientCount(bool:ExcludeBots, bool:inGameOnly)
{
	new clients;
	if (!ExcludeBots)
	{
		clients = GetClientCount(inGameOnly);
	}
	else
	{
		new i = 1;
		while (GetMaxClients() >= i)
		{
			new var1;
			if (inGameOnly)
			{
				var1 = IsClientInGame(i);
			}
			else
			{
				var1 = IsClientConnected(i);
			}
			new var2;
			if (var1 && !IsFakeClient(i))
			{
				clients++;
			}
			i++;
		}
	}
	return clients;
}

bool:CheckPlayerCount(type)
{
	decl MinPlayers;
	new bool:EnableMode;
	new String:strType[8] = "move";
	switch (type)
	{
		case 0:
		{
			MinPlayers = GetConVarInt(hCvarMinPlayersMove);
			EnableMode = bMovePlayers;
		}
		case 1:
		{
			MinPlayers = GetConVarInt(hCvarMinPlayersKick);
			EnableMode = bKickPlayers;
		}
		default:
		{
		}
	}
	if (iNumPlayers >= MinPlayers)
	{
		if (!EnableMode)
		{
			if (bLogWarnings)
			{
				LogToFile(AFKM_LogFile, "Minimum player count for AFK %s is reached, feature is now enabled: sm_afk_%s_min_players = %i Current Players = %i", strType, strType, MinPlayers, iNumPlayers);
			}
		}
		EnableMode = true;
	}
	else
	{
		if (EnableMode)
		{
			if (bLogWarnings)
			{
				LogToFile(AFKM_LogFile, "Minimum player count for AFK %s has not been reached, feature is now disabled: sm_afk_%s_min_players = %i Current Players = %i", strType, strType, MinPlayers, iNumPlayers);
			}
		}
		EnableMode = false;
	}
	return EnableMode;
}

public void:OnPluginStart()
{
	BuildLogFilePath();
	LoadTranslations("common.phrases");
	LoadTranslations("afk_manager.phrases");
	SDKEngine = GuessSDKVersion();
	if (SDKEngine > 35)
	{
		g_Spec_FL_Mode = 6;
	}
	else
	{
		if (SDKEngine > 20)
		{
			g_Spec_FL_Mode = 6;
		}
		g_Spec_FL_Mode = 5;
	}
	new String:game_mod[32];
	GetGameFolderName(game_mod, 32);
	if (strcmp(game_mod, "insurgency", false))
	{
		if (strcmp(game_mod, "synergy", false))
		{
			if (strcmp(game_mod, "tf", false))
			{
				new var1;
				if (strcmp(game_mod, "cstrike", false) && strcmp(game_mod, "csgo", false))
				{
					LogAction(0, -1, "[AFK Manager] %T", "CSTRIKE", 0);
					CSTRIKE = true;
					hCvarAFK = FindConVar("mp_autokick");
				}
				if (!(strcmp(game_mod, "nucleardawn", false)))
				{
					LogAction(0, -1, "[AFK Manager] %T", "NUCLEARDAWN", 0);
					NUCLEARDAWN = true;
					HookEvent("structure_built", Event_StructBuilt, EventHookMode:1);
				}
			}
			LogAction(0, -1, "[AFK Manager] %T", "TF2", 0);
			TF2 = true;
			hCvarAFK = FindConVar("mp_idledealmethod");
			hCvarTF2Arena = FindConVar("tf_gamemode_arena");
			hCvarTF2WFPTime = FindConVar("mp_waitingforplayers_time");
		}
		LogAction(0, -1, "[AFK Manager] %T", "Synergy", 0);
		Synergy = true;
	}
	else
	{
		LogAction(0, -1, "[AFK Manager] %T", "Insurgency", 0);
		Insurgency = true;
		g_sTeam_Index = 3;
	}
	RegisterCvars();
	SetConVarInt(hCvarLogWarnings, 0, false, false);
	SetConVarInt(hCvarEnabled, 0, false, false);
	RegisterHooks();
	AutoExecConfig(true, "afk_manager", "sourcemod");
	RegisterCmds();
	if (hCvarLogDays)
	{
		if (0 < GetConVarInt(hCvarLogDays))
		{
			PurgeOldLogs();
		}
	}
	return void:0;
}

public void:OnAllPluginsLoaded()
{
	return void:0;
}

public void:OnLibraryAdded(String:name[])
{
	return void:0;
}

public void:OnPluginEnd()
{
	return void:0;
}

RegisterCvars()
{
	hCvarVersion = CreateConVar("sm_afkm_version", "3.5.2", "Current version of the AFK Manager", 401728, false, 0.0, false, 0.0);
	SetConVarString(hCvarVersion, "3.5.2", false, false);
	hCvarEnabled = CreateConVar("sm_afk_enable", "1", "Is the AFK manager enabled or disabled? [0 = FALSE, 1 = TRUE]", 0, true, 0.0, true, 1.0);
	hCvarAutoUpdate = CreateConVar("sm_afk_autoupdate", "0", "Is the AFK manager automatic plugin update enabled or disabled? (Requires SourceMod Autoupdate plugin) [0 = FALSE, 1 = TRUE]", 0, true, 0.0, true, 1.0);
	hCvarPrefixShort = CreateConVar("sm_afk_prefix_short", "0", "Should the AFK manager use a short prefix? [0 = FALSE, 1 = TRUE, DEFAULT: 0]", 0, true, 0.0, true, 1.0);
	hCvarLogWarnings = CreateConVar("sm_afk_log_warnings", "1", "Should the AFK manager log plugin warning messages. [0 = FALSE, 1 = TRUE, DEFAULT: 1]", 0, true, 0.0, true, 1.0);
	hCvarLogMoves = CreateConVar("sm_afk_log_moves", "1", "Should the AFK manager log client moves. [0 = FALSE, 1 = TRUE, DEFAULT: 1]", 0, true, 0.0, true, 1.0);
	hCvarLogKicks = CreateConVar("sm_afk_log_kicks", "1", "Should the AFK manager log client kicks. [0 = FALSE, 1 = TRUE, DEFAULT: 1]", 0, true, 0.0, true, 1.0);
	hCvarLogDays = CreateConVar("sm_afk_log_days", "0", "How many days should we keep AFK manager log files. [0 = INFINITE, DEFAULT: 0]", 0, false, 0.0, false, 0.0);
	hCvarMinPlayersMove = CreateConVar("sm_afk_move_min_players", "4", "Minimum number of connected clients required for AFK move to be enabled. [DEFAULT: 4]", 0, false, 0.0, false, 0.0);
	hCvarMinPlayersKick = CreateConVar("sm_afk_kick_min_players", "6", "Minimum number of connected clients required for AFK kick to be enabled. [DEFAULT: 6]", 0, false, 0.0, false, 0.0);
	hCvarAdminsImmune = CreateConVar("sm_afk_admins_immune", "1", "Should admins be immune to the AFK Manager? [0 = DISABLED, 1 = COMPLETE IMMUNITY, 2 = KICK IMMUNITY, 3 = MOVE IMMUNITY]", 0, false, 0.0, false, 0.0);
	hCvarAdminsFlag = CreateConVar("sm_afk_admins_flag", "", "Admin Flag for immunity? Leave Blank for any flag.", 0, false, 0.0, false, 0.0);
	hCvarMoveSpec = CreateConVar("sm_afk_move_spec", "1", "Should the AFK Manager move AFK clients to spectator team? [0 = FALSE, 1 = TRUE]", 0, true, 0.0, true, 1.0);
	hCvarTimeToMove = CreateConVar("sm_afk_move_time", "60.0", "Time in seconds (total) client must be AFK before being moved to spectator. [0 = DISABLED, DEFAULT: 60.0 seconds]", 0, false, 0.0, false, 0.0);
	hCvarWarnTimeToMove = CreateConVar("sm_afk_move_warn_time", "30.0", "Time in seconds remaining, player should be warned before being moved for AFK. [DEFAULT: 30.0 seconds]", 0, false, 0.0, false, 0.0);
	hCvarKickPlayers = CreateConVar("sm_afk_kick_players", "1", "Should the AFK Manager kick AFK clients? [0 = DISABLED, 1 = KICK ALL, 2 = ALL EXCEPT SPECTATORS, 3 = SPECTATORS ONLY]", 0, false, 0.0, false, 0.0);
	hCvarTimeToKick = CreateConVar("sm_afk_kick_time", "120.0", "Time in seconds (total) client must be AFK before being kicked. [0 = DISABLED, DEFAULT: 120.0 seconds]", 0, false, 0.0, false, 0.0);
	hCvarWarnTimeToKick = CreateConVar("sm_afk_kick_warn_time", "30.0", "Time in seconds remaining, player should be warned before being kicked for AFK. [DEFAULT: 30.0 seconds]", 0, false, 0.0, false, 0.0);
	hCvarSpawnTime = CreateConVar("sm_afk_spawn_time", "20.0", "Time in seconds (total) that player should have moved from their spawn position. [0 = DISABLED, DEFAULT: 20.0 seconds]", 0, false, 0.0, false, 0.0);
	hCvarWarnSpawnTime = CreateConVar("sm_afk_spawn_warn_time", "15.0", "Time in seconds remaining, player should be warned for being AFK in spawn. [DEFAULT: 15.0 seconds]", 0, false, 0.0, false, 0.0);
	hCvarExcludeBots = CreateConVar("sm_afk_exclude_bots", "0", "Should the AFK manager exclude counting bots in player counts? [0 = FALSE, 1 = TRUE]", 0, true, 0.0, true, 1.0);
	hCvarExcludeDead = CreateConVar("sm_afk_exclude_dead", "0", "Should the AFK manager exclude checking dead players? [0 = FALSE, 1 = TRUE]", 0, true, 0.0, true, 1.0);
	hCvarLocationThreshold = CreateConVar("sm_afk_location_threshold", "30.0", "Threshold for amount of movement required to mark a player as AFK. [0 = NONE, DEFAULT: 30.0]", 0, false, 0.0, false, 0.0);
	return 0;
}

RegisterHooks()
{
	if (!bCvarIsHooked[0])
	{
		HookConVarChange(hCvarVersion, CvarChange_Version);
		bCvarIsHooked[0] = 1;
	}
	if (!bCvarIsHooked[1])
	{
		HookConVarChange(hCvarEnabled, CvarChange_Enabled);
		bCvarIsHooked[1] = 1;
	}
	if (!bCvarIsHooked[2])
	{
		HookConVarChange(hCvarLogWarnings, CvarChange_Warnings);
		bCvarIsHooked[2] = 1;
		if (GetConVarBool(hCvarLogWarnings))
		{
			bLogWarnings = true;
		}
	}
	if (!bCvarIsHooked[3])
	{
		HookConVarChange(hCvarExcludeBots, CvarChange_ExcludeBots);
		bCvarIsHooked[3] = 1;
		if (GetConVarBool(hCvarExcludeBots))
		{
			bExcludeBots = true;
		}
	}
	if (hCvarAFK)
	{
		if (!bCvarIsHooked[4])
		{
			HookConVarChange(hCvarAFK, CvarChange_AFK);
			bCvarIsHooked[4] = 1;
			SetConVarInt(hCvarAFK, 0, false, false);
		}
	}
	if (TF2)
	{
		if (hCvarTF2Arena)
		{
			if (!bCvarIsHooked[5])
			{
				HookConVarChange(hCvarTF2Arena, CvarChange_TF2_Arena);
				bCvarIsHooked[5] = 1;
				if (GetConVarBool(hCvarTF2Arena))
				{
					bTF2Arena = true;
				}
			}
		}
	}
	return 0;
}

RegisterCmds()
{
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say_team");
	RegAdminCmd("sm_afk_spec", Command_Spec, 4, "sm_afk_spec <#userid|name>", "", 0);
	return 0;
}

TF2_HookRoundStart(bool:Arena)
{
	if (Arena)
	{
		if (bEventIsHooked[3])
		{
			UnhookEvent("teamplay_round_start", Event_RoundStart, EventHookMode:1);
			bEventIsHooked[3] = 0;
		}
		if (!bEventIsHooked[4])
		{
			HookEvent("arena_round_start", Event_RoundStart, EventHookMode:1);
			bEventIsHooked[4] = 1;
		}
	}
	else
	{
		if (bEventIsHooked[4])
		{
			UnhookEvent("arena_round_start", Event_RoundStart, EventHookMode:1);
			bEventIsHooked[4] = 0;
		}
		if (!bEventIsHooked[3])
		{
			HookEvent("teamplay_round_start", Event_RoundStart, EventHookMode:1);
			bEventIsHooked[3] = 1;
		}
	}
	return 0;
}

EnablePlugin()
{
	if (!bEventIsHooked[0])
	{
		HookEvent("player_team", Event_PlayerTeamPost, EventHookMode:1);
		bEventIsHooked[0] = 1;
	}
	if (!bEventIsHooked[1])
	{
		HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode:1);
		bEventIsHooked[1] = 1;
	}
	if (!bEventIsHooked[2])
	{
		HookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
		bEventIsHooked[2] = 1;
	}
	if (TF2)
	{
		TF2_HookRoundStart(bTF2Arena);
		if (!bEventIsHooked[5])
		{
			HookEvent("teamplay_round_stalemate", Event_StaleMate, EventHookMode:2);
			bEventIsHooked[5] = 1;
		}
	}
	AFK_Start();
	return 0;
}

DisablePlugin()
{
	if (bEventIsHooked[0])
	{
		UnhookEvent("player_team", Event_PlayerTeamPost, EventHookMode:1);
		bEventIsHooked[0] = 0;
	}
	if (bEventIsHooked[1])
	{
		UnhookEvent("player_spawn", Event_PlayerSpawn, EventHookMode:1);
		bEventIsHooked[1] = 0;
	}
	if (bEventIsHooked[2])
	{
		UnhookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
		bEventIsHooked[2] = 0;
	}
	if (TF2)
	{
		if (bEventIsHooked[3])
		{
			UnhookEvent("teamplay_round_start", Event_RoundStart, EventHookMode:1);
			bEventIsHooked[3] = 0;
		}
		if (bEventIsHooked[4])
		{
			UnhookEvent("arena_round_start", Event_RoundStart, EventHookMode:1);
			bEventIsHooked[4] = 0;
		}
		if (bEventIsHooked[5])
		{
			UnhookEvent("teamplay_round_stalemate", Event_StaleMate, EventHookMode:2);
			bEventIsHooked[5] = 0;
		}
	}
	AFK_Stop();
	return 0;
}

public CvarChange_Version(Handle:cvar, String:oldvalue[], String:newvalue[])
{
	if (!StrEqual(newvalue, "3.5.2", true))
	{
		SetConVarString(cvar, "3.5.2", false, false);
	}
	return 0;
}

public CvarChange_Enabled(Handle:cvar, String:oldvalue[], String:newvalue[])
{
	if (!StrEqual(oldvalue, newvalue, true))
	{
		if (StringToInt(newvalue, 10) == 1)
		{
			EnablePlugin();
		}
		if (!(StringToInt(newvalue, 10)))
		{
			DisablePlugin();
		}
	}
	return 0;
}

public CvarChange_Warnings(Handle:cvar, String:oldvalue[], String:newvalue[])
{
	if (!StrEqual(oldvalue, newvalue, true))
	{
		if (StringToInt(newvalue, 10) == 1)
		{
			bLogWarnings = true;
		}
		if (!(StringToInt(newvalue, 10)))
		{
			bLogWarnings = false;
		}
	}
	return 0;
}

public CvarChange_ExcludeBots(Handle:cvar, String:oldvalue[], String:newvalue[])
{
	if (!StrEqual(oldvalue, newvalue, true))
	{
		if (StringToInt(newvalue, 10) == 1)
		{
			bExcludeBots = true;
		}
		else
		{
			if (!(StringToInt(newvalue, 10)))
			{
				bExcludeBots = false;
			}
		}
		iNumPlayers = AFK_GetClientCount(bExcludeBots, true);
	}
	return 0;
}

public CvarChange_AFK(Handle:cvar, String:oldvalue[], String:newvalue[])
{
	if (0 < StringToInt(newvalue, 10))
	{
		SetConVarInt(cvar, 0, false, false);
	}
	return 0;
}

public CvarChange_TF2_Arena(Handle:cvar, String:oldvalue[], String:newvalue[])
{
	if (!StrEqual(oldvalue, newvalue, true))
	{
		if (StringToInt(newvalue, 10))
		{
			bTF2Arena = true;
			TF2_HookRoundStart(bTF2Arena);
		}
		bTF2Arena = false;
		TF2_HookRoundStart(bTF2Arena);
	}
	return 0;
}

public Action:Command_Spec(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[AFK Manager] Usage: sm_afk_spec <#userid|name>");
		return Action:3;
	}
	decl String:arg[68];
	GetCmdArg(1, arg, 65);
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 1, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	new i;
	while (i < target_count)
	{
		if (MoveAFKClient(target_list[i]) == 4)
		{
			if (hAFKTimers[target_list[i]])
			{
				CloseHandle(hAFKTimers[target_list[i]]);
				hAFKTimers[target_list[i]] = 0;
			}
		}
		i++;
	}
	if (tn_is_ml)
	{
		if (GetConVarBool(hCvarPrefixShort))
		{
			ShowActivity2(client, "[AFK] ", "%t", "Spectate_Force", target_name);
		}
		else
		{
			ShowActivity2(client, "[AFK Manager] ", "%t", "Spectate_Force", target_name);
		}
		LogToFile(AFKM_LogFile, "%L: %T", client, "Spectate_Force", 0, target_name);
	}
	else
	{
		if (GetConVarBool(hCvarPrefixShort))
		{
			ShowActivity2(client, "[AFK] ", "%t", "Spectate_Force", "_s", target_name);
		}
		else
		{
			ShowActivity2(client, "[AFK Manager] ", "%t", "Spectate_Force", "_s", target_name);
		}
		LogToFile(AFKM_LogFile, "%L: %T", client, "Spectate_Force", 0, "_s", target_name);
	}
	return Action:3;
}

public void:OnMapStart()
{
	BuildLogFilePath();
	GetConVarBool(hCvarAutoUpdate);
	AutoExecConfig(true, "afk_manager", "sourcemod");
	if (TF2)
	{
		if (bTF2Arena)
		{
			g_TF2_WFP_StartTime = 0;
			bWaitRound = false;
			if (hCvarTF2WFPTime)
			{
				if (GetConVarFloat(hCvarTF2WFPTime) - 1.0 > 0.0)
				{
					g_TF2_WFP_StartTime = GetTime({0,0});
					bWaitRound = true;
				}
			}
		}
		else
		{
			g_TF2_WFP_StartTime = 0;
			bWaitRound = false;
		}
	}
	else
	{
		g_TF2_WFP_StartTime = 0;
		bWaitRound = false;
	}
	return void:0;
}

public void:OnMapEnd()
{
	bWaitRound = true;
	return void:0;
}

ResetSpawn(index)
{
	bAFKSpawn[index] = 0;
	return 0;
}

ResetPlayer(index)
{
	fAFKTime[index] = 0;
	if (Insurgency)
	{
	}
	iSpecMode[index] = 0;
	iSpecTarget[index] = 0;
	ResetSpawn(index);
	return 0;
}

InitializePlayer(index)
{
	bJoinedTeam[index] = 0;
	if (!IsFakeClient(index))
	{
		if (hAFKTimers[index])
		{
			CloseHandle(hAFKTimers[index]);
			hAFKTimers[index] = 0;
		}
		new bool:FullImmunity;
		if (GetConVarInt(hCvarAdminsImmune) == 1)
		{
			if (CheckAdminImmunity(index))
			{
				FullImmunity = true;
			}
		}
		if (!FullImmunity)
		{
			hAFKTimers[index] = CreateTimer(5.0, Timer_CheckPlayer, index, 1);
			ResetPlayer(index);
		}
	}
	return 0;
}

UnInitializePlayer(index)
{
	bJoinedTeam[index] = 0;
	if (hAFKTimers[index])
	{
		CloseHandle(hAFKTimers[index]);
		hAFKTimers[index] = 0;
	}
	ResetPlayer(index);
	return 0;
}

AFK_Start()
{
	iNumPlayers = AFK_GetClientCount(bExcludeBots, true);
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientConnected(i))
		{
			if (IsClientInGame(i))
			{
				if (iPlayerTeam[i] == -1)
				{
					iPlayerTeam[i] = GetClientTeam(i);
					iTeamPlayers[iPlayerTeam[i]]++;
				}
				InitializePlayer(i);
			}
		}
		i++;
	}
	bMovePlayers = CheckPlayerCount(0);
	bKickPlayers = CheckPlayerCount(1);
	return 0;
}

AFK_Stop()
{
	iNumPlayers = 0;
	new i = 1;
	while (i <= MaxClients)
	{
		UnInitializePlayer(i);
		if (IsClientConnected(i))
		{
			if (IsClientInGame(i))
			{
				if (iPlayerTeam[i] != -1)
				{
					iTeamPlayers[iPlayerTeam[i]]--;
					iPlayerTeam[i] = -1;
				}
			}
		}
		i++;
	}
	return 0;
}

public void:OnClientPutInServer(client)
{
	if (GetConVarBool(hCvarEnabled))
	{
		iNumPlayers = AFK_GetClientCount(bExcludeBots, true);
		iPlayerTeam[client] = GetClientTeam(client);
		iTeamPlayers[iPlayerTeam[client]]++;
		bMovePlayers = CheckPlayerCount(0);
		bKickPlayers = CheckPlayerCount(1);
	}
	return void:0;
}

public void:OnClientPostAdminCheck(client)
{
	if (GetConVarBool(hCvarEnabled))
	{
		InitializePlayer(client);
	}
	return void:0;
}

public void:OnClientDisconnect(client)
{
	if (GetConVarBool(hCvarEnabled))
	{
		UnInitializePlayer(client);
	}
	return void:0;
}

public void:OnClientDisconnect_Post(client)
{
	if (GetConVarBool(hCvarEnabled))
	{
		iNumPlayers = AFK_GetClientCount(bExcludeBots, true);
		if (iPlayerTeam[client] != -1)
		{
			iTeamPlayers[iPlayerTeam[client]]--;
			iPlayerTeam[client] = -1;
		}
		bMovePlayers = CheckPlayerCount(0);
		bKickPlayers = CheckPlayerCount(1);
	}
	return void:0;
}

public Action:Event_PlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < client)
	{
		if (!IsFakeClient(client))
		{
			if (CSTRIKE)
			{
				if (!(GetClientTeam(client)))
				{
					return Action:0;
				}
			}
			if (!IsClientObserver(client))
			{
				if (IsPlayerAlive(client))
				{
					if (0 < GetClientHealth(client))
					{
						if (GetConVarFloat(hCvarSpawnTime) > 0.0)
						{
							InitializePlayer(client);
							if (!Insurgency)
							{
								GetClientEyeAngles(client, fSpawnPosition[client]);
							}
							else
							{
								GetClientAbsOrigin(client, fSpawnPosition[client]);
							}
							bAFKSpawn[client] = 1;
						}
						ResetPlayer(client);
					}
				}
			}
		}
	}
	return Action:0;
}

public Action:Event_PlayerTeamPost(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < client)
	{
		new team = GetEventInt(event, "team", 0);
		if (TF2)
		{
			if (!bTF2Arena)
			{
				new var1;
				if (team == 2 || team == 3)
				{
					new var2;
					if (iTeamPlayers[2] && iTeamPlayers[3])
					{
						g_TF2_WFP_StartTime = 0;
						bWaitRound = false;
						if (hCvarTF2WFPTime)
						{
							if (GetConVarFloat(hCvarTF2WFPTime) - 1.0 > 0.0)
							{
								g_TF2_WFP_StartTime = GetTime({0,0});
								bWaitRound = true;
							}
						}
					}
				}
			}
		}
		iTeamPlayers[iPlayerTeam[client]]--;
		iPlayerTeam[client] = team;
		iTeamPlayers[iPlayerTeam[client]]++;
		bJoinedTeam[client] = 1;
		if (!IsFakeClient(client))
		{
			if (team > g_sTeam_Index)
			{
				if (hAFKTimers[client])
				{
					ResetPlayer(client);
				}
				else
				{
					InitializePlayer(client);
				}
			}
			if (!Insurgency)
			{
				GetClientEyeAngles(client, fEyePosition[client]);
			}
			else
			{
				GetClientAbsOrigin(client, fMapPosition[client]);
			}
			iSpecMode[client] = GetEntProp(client, PropType:0, "m_iObserverMode", 4, 0);
			iSpecTarget[client] = GetEntPropEnt(client, PropType:0, "m_hObserverTarget", 0);
		}
	}
	return Action:0;
}

public Action:Event_PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	ResetPlayer(attacker);
	return Action:0;
}

public Action:Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	new bool:FullReset = GetEventBool(event, "full_reset", false);
	if (bWaitRound)
	{
		if (0 < g_TF2_WFP_StartTime)
		{
			if (hCvarTF2WFPTime)
			{
				if (GetTime({0,0}) - g_TF2_WFP_StartTime > GetConVarFloat(hCvarTF2WFPTime) - 1.0)
				{
					g_TF2_WFP_StartTime = 0;
					bWaitRound = false;
				}
			}
		}
		bWaitRound = false;
	}
	return Action:0;
}

public Action:Event_StaleMate(Handle:event, String:name[], bool:dontBroadcast)
{
	bWaitRound = true;
	return Action:0;
}

public Action:Event_StructBuilt(Handle:event, String:name[], bool:dontBroadcast)
{
	new entIndex = GetEventInt(event, "entindex", 0);
	new owner = GetEntPropEnt(entIndex, PropType:0, "m_hOwnerEntity", 0);
	decl String:Name[32];
	GetClientName(owner, Name, 32);
	new x = 1;
	while (x <= MaxClients)
	{
		new var1;
		if (IsValidClient(x, true) && GetUserFlagBits(x))
		{
			PrintToChat(x, "\x05[AFK DEBUG] %s built an structure!", Name);
		}
		x++;
	}
	return Action:0;
}

public Action:Command_Say(client, String:command[], args)
{
	if (GetConVarBool(hCvarEnabled))
	{
		ResetPlayer(client);
	}
	return Action:0;
}

public Action:Timer_CheckPlayer(Handle:Timer, any:client)
{
	if (GetConVarBool(hCvarEnabled))
	{
		if (bWaitRound)
		{
			return Action:0;
		}
		new var1;
		if ((bMovePlayers = CheckPlayerCount(0)) && (bKickPlayers = CheckPlayerCount(1)))
		{
			return Action:0;
		}
		if (IsClientInGame(client))
		{
			new Action:timer_result = CheckForAFK(client);
			if (timer_result != Action:4)
			{
				return timer_result;
			}
		}
		return Action:0;
	}
	hAFKTimers[client] = 0;
	return Action:4;
}

bool:CheckObserverAFK(client)
{
	new var1;
	if (!Synergy && bJoinedTeam[client])
	{
		return true;
	}
	if (TF2)
	{
		if (bTF2Arena)
		{
			if (!(GetEntProp(client, PropType:0, "m_bArenaSpectator", 4, 0)))
			{
				return false;
			}
		}
	}
	new g_Last_Mode = iSpecMode[client];
	iSpecMode[client] = GetEntProp(client, PropType:0, "m_iObserverMode", 4, 0);
	if (0 < g_Last_Mode)
	{
		if (g_Last_Mode != iSpecMode[client])
		{
			return false;
		}
	}
	decl Float:f_Map_Loc[3];
	new var6 = fMapPosition[client];
	f_Map_Loc = var6;
	decl Float:f_Eye_Loc[3];
	new var7 = fEyePosition[client];
	f_Eye_Loc = var7;
	if (g_Spec_FL_Mode == iSpecMode[client])
	{
		if (!Insurgency)
		{
			GetClientEyeAngles(client, fEyePosition[client]);
		}
		else
		{
			GetClientAbsOrigin(client, fMapPosition[client]);
		}
	}
	else
	{
		new g_Last_Spec = iSpecTarget[client];
		iSpecTarget[client] = GetEntPropEnt(client, PropType:0, "m_hObserverTarget", 0);
		new var2;
		if (g_Last_Mode && g_Last_Spec)
		{
			return true;
		}
		if (0 < g_Last_Spec)
		{
			if (g_Last_Spec != iSpecTarget[client])
			{
				new var3;
				if (IsValidClient(g_Last_Spec, false) && !IsPlayerAlive(g_Last_Spec))
				{
					return true;
				}
				return false;
			}
		}
	}
	new var4;
	if (fMapPosition[client][0] == f_Map_Loc[0] && fMapPosition[client][1] == f_Map_Loc[1] && fMapPosition[client][2] == f_Map_Loc[2])
	{
		new var5;
		if (fEyePosition[client][0] == f_Eye_Loc[0] && fEyePosition[client][1] == f_Eye_Loc[1] && fEyePosition[client][2] == f_Eye_Loc[2])
		{
			return true;
		}
	}
	return false;
}

bool:CheckSamePosition(client)
{
	decl Float:f_Eye_Loc[3];
	new var5 = fEyePosition[client];
	f_Eye_Loc = var5;
	decl Float:f_Map_Loc[3];
	new var6 = fMapPosition[client];
	f_Map_Loc = var6;
	if (!Insurgency)
	{
		GetClientEyeAngles(client, fEyePosition[client]);
	}
	GetClientAbsOrigin(client, fMapPosition[client]);
	if (GetEntityFlags(client) & 32)
	{
		return false;
	}
	if (bAFKSpawn[client])
	{
		if (!Insurgency)
		{
			new var1;
			if (fEyePosition[client][0] == fSpawnPosition[client][0] && fEyePosition[client][1] == fSpawnPosition[client][1] && fEyePosition[client][2] == fSpawnPosition[client][2])
			{
				return true;
			}
			ResetSpawn(client);
		}
		new var2;
		if (fMapPosition[client][0] == fSpawnPosition[client][0] && fMapPosition[client][1] == fSpawnPosition[client][1] && fMapPosition[client][2] == fSpawnPosition[client][2])
		{
			return true;
		}
		ResetSpawn(client);
	}
	new Float:Threshold = GetConVarFloat(hCvarLocationThreshold);
	new var3;
	if (FloatAbs(fMapPosition[client][0] - f_Map_Loc[0]) < Threshold && FloatAbs(fMapPosition[client][1] - f_Map_Loc[1]) < Threshold && FloatAbs(fMapPosition[client][2] - f_Map_Loc[2]) < Threshold)
	{
		if (Synergy)
		{
			new UseEntity = GetEntPropEnt(client, PropType:0, "m_hUseEntity", 0);
			if (UseEntity != -1)
			{
				GetEntPropVector(UseEntity, PropType:0, "m_angRotation", fEyePosition[3], 0);
			}
		}
		new var4;
		if (fEyePosition[client][0] == f_Eye_Loc[0] && fEyePosition[client][1] == f_Eye_Loc[1] && fEyePosition[client][2] == f_Eye_Loc[2])
		{
			if (Insurgency)
			{
				if (!IsPlayerAlive(client))
				{
					new waves = FindSendPropInfo("CPlayTeam", "numwaves", 0, 0, 0);
					if (0 >= waves)
					{
						return false;
					}
				}
				return true;
			}
			return true;
		}
	}
	return false;
}

Action:CheckForAFK(client)
{
	new g_TeamNum = GetClientTeam(client);
	if (IsClientObserver(client))
	{
		new var1;
		if (Synergy || g_TeamNum > 0)
		{
			if (!IsPlayerAlive(client))
			{
				if (g_TeamNum > g_sTeam_Index)
				{
					if (GetConVarBool(hCvarExcludeDead))
					{
						return Action:0;
					}
				}
			}
		}
		if (CheckObserverAFK(client))
		{
			fAFKTime[client] = fAFKTime[client][5.0];
		}
		else
		{
			fAFKTime[client] = 0;
		}
	}
	else
	{
		if (CheckSamePosition(client))
		{
			fAFKTime[client] = fAFKTime[client][5.0];
		}
		fAFKTime[client] = 0;
	}
	new AdminsImmune = GetConVarInt(hCvarAdminsImmune);
	if (fAFKTime[client] > 0.0)
	{
		if (GetConVarBool(hCvarMoveSpec))
		{
			if (g_TeamNum > g_sTeam_Index)
			{
				if (bMovePlayers == true)
				{
					new var2;
					if (AdminsImmune && AdminsImmune == 2 && !CheckAdminImmunity(client))
					{
						if (bAFKSpawn[client])
						{
							new Float:afk_spawn_timeleft = GetConVarFloat(hCvarSpawnTime) - fAFKTime[client];
							if (afk_spawn_timeleft <= GetConVarFloat(hCvarWarnSpawnTime))
							{
								if (afk_spawn_timeleft > 0.0)
								{
									AFK_PrintToChat(client, "%t", "Spawn_Move_Warning", RoundToFloor(afk_spawn_timeleft));
									return Action:0;
								}
								if (NUCLEARDAWN)
								{
									new team = GetClientTeam(client);
									new var3;
									if ((team == 2 || team == 3) && ND_GetCommander(team) == client)
									{
										ND_DemoteCommander(client, team);
									}
								}
								if (g_TeamNum)
								{
									bAFKSpawn[client] = 0;
									return MoveAFKClient(client);
								}
								bAFKSpawn[client] = 0;
								return MoveAFKClient(client);
							}
						}
						new Float:afk_move_time = GetConVarFloat(hCvarTimeToMove);
						if (afk_move_time > 0.0)
						{
							new Float:afk_move_timeleft = afk_move_time - fAFKTime[client];
							if (afk_move_timeleft <= GetConVarFloat(hCvarWarnTimeToMove))
							{
								if (afk_move_timeleft > 0.0)
								{
									AFK_PrintToChat(client, "%t", "Move_Warning", RoundToFloor(afk_move_timeleft));
									return Action:0;
								}
								if (NUCLEARDAWN)
								{
									new team = GetClientTeam(client);
									new var5;
									if ((team == 2 || team == 3) && ND_GetCommander(team) == client)
									{
										ND_DemoteCommander(client, team);
									}
								}
								if (g_TeamNum)
								{
									return MoveAFKClient(client);
								}
								return MoveAFKClient(client);
							}
							return Action:0;
						}
						return Action:0;
					}
				}
			}
		}
		new KickPlayers = GetConVarInt(hCvarKickPlayers);
		if (0 < KickPlayers)
		{
			if (bKickPlayers == true)
			{
				new var7;
				if (AdminsImmune && AdminsImmune == 3 && !CheckAdminImmunity(client))
				{
					if (KickPlayers == 3)
					{
						if (g_TeamNum > g_sTeam_Index)
						{
							return Action:0;
						}
					}
					if (bAFKSpawn[client])
					{
						new Float:afk_spawn_timeleft = GetConVarFloat(hCvarSpawnTime) - fAFKTime[client];
						if (afk_spawn_timeleft <= GetConVarFloat(hCvarWarnSpawnTime))
						{
							if (afk_spawn_timeleft > 0.0)
							{
								AFK_PrintToChat(client, "%t", "Spawn_Kick_Warning", RoundToFloor(afk_spawn_timeleft));
								return Action:0;
							}
							return KickAFKClient(client);
						}
					}
					new Float:afk_kick_time = GetConVarFloat(hCvarTimeToKick);
					if (afk_kick_time > 0.0)
					{
						new Float:afk_kick_timeleft = afk_kick_time - fAFKTime[client];
						if (afk_kick_timeleft <= GetConVarFloat(hCvarWarnTimeToKick))
						{
							if (afk_kick_timeleft > 0.0)
							{
								AFK_PrintToChat(client, "%t", "Kick_Warning", RoundToFloor(afk_kick_timeleft));
								return Action:0;
							}
							return KickAFKClient(client);
						}
					}
				}
			}
		}
	}
	return Action:0;
}

Action:MoveAFKClient(client)
{
	decl String:f_Name[32];
	GetClientName(client, f_Name, 32);
	AFK_PrintToChat(client, "%t", "Move_Announce", f_Name);
	if (GetConVarBool(hCvarLogMoves))
	{
		LogToFile(AFKM_LogFile, "%T", "Move_Log", 0, client);
	}
	if (CSTRIKE)
	{
		ForcePlayerSuicide(client);
	}
	if (TF2)
	{
		new iEnt = -1;
		while ((iEnt = FindEntityByClassname(iEnt, "item_teamflag")) > -1)
		{
			if (IsValidEntity(iEnt))
			{
				if (client == GetEntPropEnt(iEnt, PropType:1, "m_hMoveParent", 0))
				{
					AcceptEntityInput(iEnt, "ForceDrop", -1, -1, 0);
				}
			}
		}
		if (bTF2Arena)
		{
			SetEntProp(client, PropType:0, "m_nNextThinkTick", any:-1, 4, 0);
			SetEntProp(client, PropType:0, "m_iDesiredPlayerClass", any:0, 4, 0);
			SetEntProp(client, PropType:0, "m_bArenaSpectator", any:1, 4, 0);
		}
	}
	ChangeClientTeam(client, g_sTeam_Index);
	if (Insurgency)
	{
		if (IsPlayerAlive(client))
		{
			ClientCommand(client, "kill");
		}
	}
	new KickPlayers = GetConVarInt(hCvarKickPlayers);
	new var1;
	if (KickPlayers && KickPlayers == 2)
	{
		ResetPlayer(client);
		return Action:4;
	}
	return Action:0;
}

Action:KickAFKClient(client)
{
	decl String:f_Name[32];
	GetClientName(client, f_Name, 32);
	if (NUCLEARDAWN)
	{
		new team = GetClientTeam(client);
		new var1;
		if ((team == 2 || team == 3) && ND_GetCommander(team) == client)
		{
			ND_DemoteCommander(client, team);
		}
	}
	if (GetConVarBool(hCvarLogKicks))
	{
		LogToFile(AFKM_LogFile, "%T", "Kick_Log", 0, client);
	}
	if (GetConVarBool(hCvarPrefixShort))
	{
		KickClient(client, "[AFK] %t", "Kick_Message");
	}
	else
	{
		KickClient(client, "[AFK Manager] %t", "Kick_Message");
	}
	return Action:0;
}

bool:CheckAdminImmunity(client)
{
	decl String:name[32];
	GetClientName(client, name, 32);
	new AdminId:admin = GetUserAdmin(client);
	if (admin != AdminId:-1)
	{
		decl String:flags[8];
		decl AdminFlag:flag;
		GetConVarString(hCvarAdminsFlag, flags, 8);
		if (!StrEqual(flags, "", false))
		{
			if (!FindFlagByChar(flags[0], flag))
			{
			}
			else
			{
				if (GetAdminFlag(admin, flag, AdmAccessMode:1))
				{
					return true;
				}
			}
		}
		return true;
	}
	return false;
}

ND_GetCommander(team)
{
	new var1;
	if (team != 2 && team != 3)
	{
		ThrowError("Invalid team index specified: got %i expected [2,3]", team);
	}
	new ret = GameRules_GetPropEnt("m_hCommanders", team + -2);
	new var2;
	if (IsValidClient(ret, true))
	{
		var2 = ret;
	}
	else
	{
		var2 = -1;
	}
	return var2;
}

ND_DemoteCommander(client, team)
{
	new var1;
	if (team != 2 && team != 3)
	{
		ThrowError("Invalid team index specified: got %i expected [2,3]", team);
	}
	new target = ND_GetCommander(team);
	if (target == -1)
	{
		return -1;
	}
	LogAction(client, target, "\"%L\" demoted \"%L\" from commander.", client, target);
	FakeClientCommand(target, "rtsview");
	FakeClientCommand(target, "startmutiny");
	PrintToChatAll("\x05%N was demoted for being afk!", target);
	return target;
}

