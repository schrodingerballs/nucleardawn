public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "04:34:22"
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
public Plugin:myinfo =
{
	name = "Nextmap",
	description = "Provides nextmap and sm_nextmap",
	author = "AlliedModders LLC",
	version = "1.7.0",
	url = "http://www.sourcemod.net/"
};
new g_MapPos = -1;
new Handle:g_MapList;
new g_MapListSerial = -1;
new g_CurrentMapStartTime;
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

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	new String:game[128];
	GetGameFolderName(game, 128);
	new var1;
	if (StrEqual(game, "left4dead", false) || StrEqual(game, "dystopia", false) || StrEqual(game, "synergy", false) || StrEqual(game, "left4dead2", false) || StrEqual(game, "garrysmod", false) || StrEqual(game, "swarm", false) || StrEqual(game, "dota", false) || GetEngineVersion() == 21)
	{
		strcopy(error, err_max, "Nextmap is incompatible with this game");
		return APLRes:2;
	}
	return APLRes:0;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("nextmap.phrases");
	g_MapList = CreateArray(32, 0);
	RegAdminCmd("sm_maphistory", Command_MapHistory, 64, "Shows the most recent maps played", "", 0);
	RegConsoleCmd("listmaps", Command_List, "", 0);
	new String:currentMap[64];
	GetCurrentMap(currentMap, 64);
	SetNextMap(currentMap);
	return void:0;
}

public void:OnMapStart()
{
	g_CurrentMapStartTime = GetTime({0,0});
	return void:0;
}

public void:OnConfigsExecuted()
{
	new String:lastMap[64];
	new String:currentMap[64];
	GetNextMap(lastMap, 64);
	GetCurrentMap(currentMap, 64);
	if (!(strcmp(lastMap, currentMap, true)))
	{
		FindAndSetNextMap();
	}
	return void:0;
}

public Action:Command_List(client, args)
{
	PrintToConsole(client, "Map Cycle:");
	new mapCount = GetArraySize(g_MapList);
	new String:mapName[32];
	new i;
	while (i < mapCount)
	{
		GetArrayString(g_MapList, i, mapName, 32);
		PrintToConsole(client, "%s", mapName);
		i++;
	}
	return Action:3;
}

void:FindAndSetNextMap()
{
	if (!(ReadMapList(g_MapList, g_MapListSerial, "mapcyclefile", 6)))
	{
		if (g_MapListSerial == -1)
		{
			LogError("FATAL: Cannot load map cycle. Nextmap not loaded.");
			SetFailState("Mapcycle Not Found");
		}
	}
	new mapCount = GetArraySize(g_MapList);
	new String:mapName[32];
	if (g_MapPos == -1)
	{
		new String:current[64];
		GetCurrentMap(current, 64);
		new i;
		while (i < mapCount)
		{
			GetArrayString(g_MapList, i, mapName, 32);
			if (!(strcmp(current, mapName, false)))
			{
				g_MapPos = i;
				if (g_MapPos == -1)
				{
					g_MapPos = 0;
				}
			}
			i++;
		}
		if (g_MapPos == -1)
		{
			g_MapPos = 0;
		}
	}
	g_MapPos += 1;
	if (g_MapPos >= mapCount)
	{
		g_MapPos = 0;
	}
	GetArrayString(g_MapList, g_MapPos, mapName, 32);
	SetNextMap(mapName);
	return void:0;
}

public Action:Command_MapHistory(client, args)
{
	new mapCount = GetMapHistorySize();
	new String:mapName[32];
	new String:changeReason[100];
	new String:timeString[100];
	new String:playedTime[100];
	new startTime;
	new lastMapStartTime = g_CurrentMapStartTime;
	PrintToConsole(client, "Map History:\n");
	PrintToConsole(client, "Map : Started : Played Time : Reason for ending");
	GetCurrentMap(mapName, 32);
	PrintToConsole(client, "%02i. %s (Current Map)", 0, mapName);
	new i;
	while (i < mapCount)
	{
		GetMapHistory(i, mapName, 32, changeReason, 100, startTime);
		FormatTimeDuration(timeString, 100, GetTime({0,0}) - startTime);
		FormatTimeDuration(playedTime, 100, lastMapStartTime - startTime);
		PrintToConsole(client, "%02i. %s : %s ago : %s : %s", i + 1, mapName, timeString, playedTime, changeReason);
		lastMapStartTime = startTime;
		i++;
	}
	return Action:3;
}

FormatTimeDuration(String:buffer[], maxlen, time)
{
	new days = time / 86400;
	new hours = time / 3600 % 24;
	new minutes = time / 60 % 60;
	new seconds = time % 60;
	if (0 < days)
	{
		new var1;
		if (seconds >= 30)
		{
			var1 = minutes + 1;
		}
		else
		{
			var1 = minutes;
		}
		return Format(buffer, maxlen, "%id %ih %im", days, hours, var1);
	}
	if (0 < hours)
	{
		new var2;
		if (seconds >= 30)
		{
			var2 = minutes + 1;
		}
		else
		{
			var2 = minutes;
		}
		return Format(buffer, maxlen, "%ih %im", hours, var2);
	}
	if (0 < minutes)
	{
		new var3;
		if (seconds >= 30)
		{
			var3 = minutes + 1;
		}
		else
		{
			var3 = minutes;
		}
		return Format(buffer, maxlen, "%im", var3);
	}
	return Format(buffer, maxlen, "%is", seconds);
}

