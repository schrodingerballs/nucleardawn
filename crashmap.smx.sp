public PlVers:__version =
{
	version = 5,
	filevers = "1.6.0",
	date = "10/12/2014",
	time = "09:46:29"
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
new String:FileLoc[128];
new String:logPath[256];
new Handle:logFileHandle;
new Handle:dataFileHandle;
new Handle:sm_crashmap_enabled;
new Handle:sm_crashmap_recovertime;
new Handle:sm_crashmap_interval;
new Handle:sm_crashmap_maxrestarts;
new Handle:TimeleftHandle;
new bool:Recovered;
new bool:TimelimitChanged;
new bool:Overwrite;
new newTimelimit;
new g_PlyrCount;
new Handle:g_hPlyrData;
new String:g_DefaultMap[128];
public Plugin:myinfo =
{
	name = "Crashed Map Recovery",
	description = "Reloads map that was being played before server crash",
	author = "Crazydog",
	version = "1.5",
	url = "http://theelders.net"
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
	VerifyCoreVersion();
	return 0;
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

public OnPluginStart()
{
	CreateConVar("sm_crashmap_version", "1.5", "Crashed Map Recovery Version", 393536, false, 0.0, false, 0.0);
	sm_crashmap_enabled = CreateConVar("sm_crashmap_enabled", "1", "Enable Crashed Map Recovery? (1=yes 0=no)", 256, true, 0.0, true, 1.0);
	sm_crashmap_recovertime = CreateConVar("sm_crashmap_recovertime", "0", "Recover timelimit? (1=yes 0=no)", 256, true, 0.0, true, 1.0);
	sm_crashmap_interval = CreateConVar("sm_crashmap_interval", "20", "Interval between timeleft updates (in seconds)", 256, true, 1.0, false, 0.0);
	sm_crashmap_maxrestarts = CreateConVar("sm_crashmap_maxrestarts", "1", "How many consecutive crashes until server loads the default map", 256, true, 3.0, false, 0.0);
	AutoExecConfig(true, "plugin.crashmap", "sourcemod");
	HookConVarChange(sm_crashmap_recovertime, TimerState);
	HookConVarChange(sm_crashmap_interval, IntervalChange);
	if (GetConVarInt(sm_crashmap_recovertime) == 1)
	{
		TimeleftHandle = CreateTimer(GetConVarFloat(sm_crashmap_interval), SaveTimeleft, any:0, 1);
	}
	BuildPath(PathType:0, FileLoc, 128, "data/crashmap.txt");
	if (!FileExists(FileLoc, false))
	{
		dataFileHandle = OpenFile(FileLoc, "a");
		WriteFileLine(dataFileHandle, "SavedMap");
		WriteFileLine(dataFileHandle, "{");
		WriteFileLine(dataFileHandle, "}");
		CloseHandle(dataFileHandle);
	}
	BuildPath(PathType:0, logPath, 256, "/logs/CMR.log");
	if (!FileExists(logPath, false))
	{
		logFileHandle = OpenFile(logPath, "a");
		CloseHandle(logFileHandle);
	}
	GetCurrentMap(g_DefaultMap, 128);
	g_hPlyrData = CreateTrie();
	HookEvent("player_disconnect", EventPlayerDisconnect, EventHookMode:0);
	return 0;
}

public OnMapStart()
{
	if (GetConVarInt(sm_crashmap_enabled))
	{
		if (Recovered)
		{
			new String:CurrentMap[256];
			GetCurrentMap(CurrentMap, 256);
			new Handle:SavedMap = CreateKeyValues("SavedMap", "", "");
			FileToKeyValues(SavedMap, FileLoc);
			KvJumpToKey(SavedMap, "Map", true);
			KvSetString(SavedMap, "Map", CurrentMap);
			KvRewind(SavedMap);
			KeyValuesToFile(SavedMap, FileLoc);
			CloseHandle(SavedMap);
			CreateTimer(45.0, TIMER_CheckDefaultMap, any:0, 2);
			return 0;
		}
		if (!Recovered)
		{
			new String:MapToLoad[256];
			new String:nextmap[256];
			new timeleft;
			new restarts;
			new Handle:SavedMap = CreateKeyValues("SavedMap", "", "");
			FileToKeyValues(SavedMap, FileLoc);
			KvJumpToKey(SavedMap, "Map", true);
			KvGetString(SavedMap, "Map", MapToLoad, 256, "");
			restarts = KvGetNum(SavedMap, "restarts", 0);
			restarts++;
			LogToFile(logPath, "Restarts is %i", restarts);
			KvSetNum(SavedMap, "restarts", restarts);
			timeleft = KvGetNum(SavedMap, "Timeleft", 30);
			KvGetString(SavedMap, "Nextmap", nextmap, 256, "");
			SetNextMap(nextmap);
			newTimelimit = timeleft / 60;
			Recovered = true;
			if (GetConVarInt(sm_crashmap_maxrestarts) < restarts)
			{
				LogToFile(logPath, "[CMR] Error! %s is causing the server to crash. Please fix!", MapToLoad);
				KvSetNum(SavedMap, "restarts", 0);
				KvRewind(SavedMap);
				KeyValuesToFile(SavedMap, FileLoc);
				CloseHandle(SavedMap);
				return 0;
			}
			KvRewind(SavedMap);
			KeyValuesToFile(SavedMap, FileLoc);
			CloseHandle(SavedMap);
			if (GetConVarInt(sm_crashmap_recovertime) == 1)
			{
				LogToFile(logPath, "[CMR] %s loaded after server crash. Timelimit set to %i", MapToLoad, timeleft / 60);
			}
			else
			{
				LogToFile(logPath, "[CMR] %s loaded after server crash.", MapToLoad);
			}
			ForceChangeLevel(MapToLoad, "Crashed Map Recovery");
			return 0;
		}
		return 0;
	}
	return 0;
}

public OnMapEnd()
{
	return 0;
}

public Action:SaveTimeleft(Handle:timer)
{
	if (Overwrite)
	{
		new timeleft;
		if (!GetMapTimeLeft(timeleft))
		{
			if (!GetMapTimeLimit(timeleft))
			{
				timeleft = 30;
			}
		}
		new String:nextmap[256];
		GetNextMap(nextmap, 256);
		new Handle:SavedMap = CreateKeyValues("SavedMap", "", "");
		FileToKeyValues(SavedMap, FileLoc);
		KvJumpToKey(SavedMap, "Map", true);
		KvSetNum(SavedMap, "Timeleft", timeleft);
		KvSetString(SavedMap, "Nextmap", nextmap);
		KvRewind(SavedMap);
		KeyValuesToFile(SavedMap, FileLoc);
		CloseHandle(SavedMap);
	}
	return Action:0;
}

public OnClientAuthorized(client)
{
	new Handle:SavedMap = CreateKeyValues("SavedMap", "", "");
	FileToKeyValues(SavedMap, FileLoc);
	KvJumpToKey(SavedMap, "Map", true);
	KvSetNum(SavedMap, "restarts", 0);
	KvRewind(SavedMap);
	KeyValuesToFile(SavedMap, FileLoc);
	CloseHandle(SavedMap);
	new var1;
	if (!TimelimitChanged && GetConVarInt(sm_crashmap_recovertime) == 1)
	{
		ServerCommand("mp_timelimit %i", newTimelimit);
		TimelimitChanged = true;
		Overwrite = true;
	}
	return 0;
}

public TimerState(Handle:convar, String:oldValue[], String:newValue[])
{
	if (GetConVarInt(sm_crashmap_recovertime) < 1)
	{
		if (TimeleftHandle)
		{
			KillTimer(TimeleftHandle, false);
			TimeleftHandle = MissingTAG:0;
		}
	}
	if (0 < GetConVarInt(sm_crashmap_recovertime))
	{
		new Float:newTime = GetConVarFloat(sm_crashmap_interval);
		TimeleftHandle = CreateTimer(newTime, SaveTimeleft, any:0, 1);
		Overwrite = true;
	}
	return 0;
}

public IntervalChange(Handle:convar, String:oldValue[], String:newValue[])
{
	if (TimeleftHandle)
	{
		new Float:newTime = StringToFloat(newValue);
		KillTimer(TimeleftHandle, false);
		TimeleftHandle = MissingTAG:0;
		TimeleftHandle = CreateTimer(newTime, SaveTimeleft, any:0, 1);
	}
	return 0;
}

public OnClientConnected(client)
{
	decl String:index[8];
	new var1;
	if (!client || IsFakeClient(client))
	{
		return 0;
	}
	IntToString(GetClientUserId(client), index, 6);
	new var2;
	if (SetTrieValue(g_hPlyrData, index, any:0, false) && !g_PlyrCount)
	{
		new time;
		new var3;
		if (GetMapTimeLimit(time) && time && GetMapTimeLeft(time) && time < 0)
		{
			ServerCommand("mp_restartgame 1");
		}
	}
	return 0;
}

public Action:EventPlayerDisconnect(Handle:event, String:name[], bool:dontBroadcast)
{
	decl String:index[8];
	new userid = GetEventInt(event, "userid");
	if (!userid)
	{
		return Action:0;
	}
	IntToString(userid, index, 6);
	new var1;
	if (RemoveFromTrie(g_hPlyrData, index) && g_PlyrCount < 1)
	{
		CreateTimer(45.0, TIMER_CheckDefaultMap, any:0, 2);
	}
	return Action:0;
}

public Action:TIMER_CheckDefaultMap(Handle:timer)
{
	if (!g_PlyrCount)
	{
		SetDefaultMap();
	}
	return Action:0;
}

SetDefaultMap()
{
	decl String:buffer[128];
	GetCurrentMap(buffer, 128);
	if (!StrEqual(buffer, g_DefaultMap, true))
	{
		ForceChangeLevel(g_DefaultMap, "Server empty. Going to default map...");
	}
	return 0;
}

