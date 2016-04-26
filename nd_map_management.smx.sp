public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "04/17/2016",
	time = "14:39:11"
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
public SharedPlugin:__pl_mapchooser =
{
	name = "mapchooser",
	file = "mapchooser.smx",
	required = 1,
};
public Plugin:myinfo =
{
	name = "[ND] Map Management",
	description = "Controls various map based things.",
	author = "Stickz",
	version = "1.1.1",
	url = "N/A"
};
new roundWin;
new Handle:g_ExcludeMapList;
new String:nd_text_file[6][80] =
{
	"data/lastmap.txt",
	"data/lastmap2.txt",
	"data/lastmap3.txt",
	"data/lastmap4.txt",
	"data/lastmap5.txt",
	"data/lastmap6.txt"
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

ByteCountToCells(size)
{
	if (!size)
	{
		return 1;
	}
	return size + 3 / 4;
}

public __pl_mapchooser_SetNTVOptional()
{
	MarkNativeAsOptional("NominateMap");
	MarkNativeAsOptional("RemoveNominationByMap");
	MarkNativeAsOptional("RemoveNominationByOwner");
	MarkNativeAsOptional("GetExcludeMapList");
	MarkNativeAsOptional("GetNominatedMapList");
	MarkNativeAsOptional("CanMapChooserStartVote");
	MarkNativeAsOptional("InitiateMapChooserVote");
	MarkNativeAsOptional("HasEndOfMapVoteFinished");
	MarkNativeAsOptional("EndOfMapVoteEnabled");
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

bool:IsPlayerBot(client)
{
	new var1;
	GetClientAuthId(client, AuthIdType:1, var1, 64, true);
	new var2;
	new idx;
	while (idx < 6)
	{
		if (StrContains(var2[idx], var1, false) > -1)
		{
			return true;
		}
		idx++;
	}
	return false;
}

ValidClientCount(bool:ExcludeAlts)
{
	new clientCount;
	if (!ExcludeAlts)
	{
		new idx = 1;
		while (idx <= MaxClients)
		{
			if (IsValidClient(idx, true))
			{
				clientCount++;
			}
			idx++;
		}
	}
	else
	{
		new ix = 1;
		while (ix <= MaxClients)
		{
			new var1;
			if (IsValidClient(ix, true) && !IsPlayerBot(ix))
			{
				clientCount++;
			}
			ix++;
		}
	}
	return clientCount;
}

bool:RegularServerType()
{
	new var1;
	return GetFeatureStatus(FeatureType:0, "GameME_GetServerType") && GameME_GetServerType();
}

bool:RookieServerType()
{
	new var1;
	return GetFeatureStatus(FeatureType:0, "GameME_GetServerType") && GameME_GetServerType() == 1;
}

AddUpdaterLibrary()
{
	return 0;
}

public OnPluginStart()
{
	new arraySize = ByteCountToCells(256);
	g_ExcludeMapList = CreateArray(arraySize, 0);
	RegAdminCmd("sm_TriggerMapVote", CMD_TriggerMapVote, 4, "Triggers a map vote", "", 0);
	RegAdminCmd("sm_AddMapExclude", CMD_AddMapExclude, 4, "Adds a map exclude", "", 0);
	RegAdminCmd("sm_WriteMapExcludes", CMD_WriteMapExcludes, 4, "Writes map excludes", "", 0);
	RegAdminCmd("sm_PrintMapExcludes", CMD_PrintMapExcludes, 4, "Prints map excludes", "", 0);
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	HookEvent("round_win", Event_RoundEnd, EventHookMode:0);
	LoadTranslations("nd_map_management.phrases");
	AddUpdaterLibrary();
	CreateTextFile();
	ReadTextFile();
	return 0;
}

public OnMapStart()
{
	roundWin = 0;
	WriteTextFile();
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	AddMapToExclude();
	ParseExcludedMaps();
	StartAndSetupMapVoter();
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!roundWin)
	{
		InitiateRoundEnd();
	}
	return 0;
}

public Action:CMD_AddMapExclude(client, args)
{
	if (args != 1)
	{
		PrintToChat(client, "\x05[xG] Incorrect arg count");
		return Action:3;
	}
	decl String:MapArg[52];
	GetCmdArg(1, MapArg, 50);
	PushArrayString(g_ExcludeMapList, MapArg);
	PrintToChat(client, "\x05[xG] %s added to excludes", MapArg);
	return Action:3;
}

public Action:CMD_TriggerMapVote(client, args)
{
	if (IsVoteInProgress(Handle:0))
	{
		PrintToChat(client, "\x05[xG] Vote in Progress");
		return Action:3;
	}
	if (!TestVoteDelay(client))
	{
		return Action:3;
	}
	StartAndSetupMapVoter();
	return Action:3;
}

public Action:CMD_WriteMapExcludes(client, args)
{
	PrintToChat(client, "\x05[xG] Maps written to the text file");
	WriteTextFile();
	return Action:3;
}

public Action:CMD_PrintMapExcludes(client, args)
{
	new idx;
	while (GetArraySize(g_ExcludeMapList) > idx)
	{
		decl String:lastMap[32];
		GetArrayString(g_ExcludeMapList, idx, lastMap, 32);
		PrintToChat(client, "\x05[xG] This is index %d", idx);
		PrintToChat(client, "\x05[xG] The value here is %s", lastMap);
		idx++;
	}
	return Action:3;
}

bool:TestVoteDelay(client)
{
	new delay = CheckVoteDelay();
	if (0 < delay)
	{
		PrintToChat(client, "\x05[xG] Please wait %d seconds", delay);
		return false;
	}
	return true;
}

InitiateRoundEnd()
{
	roundWin = 1;
	checkMapExcludes();
	return 0;
}

checkMapExcludes()
{
	decl String:nextMap[32];
	GetNextMap(nextMap, 32);
	new clientCount = ValidClientCount(true);
	if (clientCount < 16)
	{
		if (clientCount < 14)
		{
			if (clientCount < 12)
			{
				if (StrEqual(nextMap, "roadwork_w01", false))
				{
					ChangeMapByPlayerCount(0, nextMap);
					return 0;
				}
			}
			new var1;
			if (StrEqual(nextMap, "gate", false) || StrEqual(nextMap, "downtown", false))
			{
				ChangeMapByPlayerCount(0, nextMap);
				return 0;
			}
		}
		new var2;
		if (StrEqual(nextMap, "rockv18", false) || StrEqual(nextMap, "oilfield", false))
		{
			ChangeMapByPlayerCount(0, nextMap);
			return 0;
		}
	}
	else
	{
		if (clientCount > 17)
		{
			new var3;
			if (StrEqual(nextMap, "corner_intermediate_04", false) || StrEqual(nextMap, "mars_102", false) || StrEqual(nextMap, "sandbrick_03", false))
			{
				ChangeMapByPlayerCount(1, nextMap);
			}
			if (StrEqual(nextMap, "metro", false))
			{
				SetNextMap("metro_imp2");
			}
		}
	}
	return 0;
}

ChangeMapByPlayerCount(type, String:nextMap[])
{
	decl String:currentMap[32];
	GetCurrentMap(currentMap, 32);
	decl String:setMap[32];
	switch (type)
	{
		case 0:
		{
			new bool:UseHydro = IncludeMap("hydro");
			new bool:UseMetro = IncludeMap("metro_imp2");
			decl bool:CycleHydro;
			new var5;
			CycleHydro = UseHydro || (!UseHydro && !UseMetro);
			new var6;
			if (CycleHydro)
			{
				var6[0] = 2272;
			}
			else
			{
				var6[0] = 2280;
			}
			Format(setMap, 32, var6);
			PrintToChatAll("\x05[xG] %t", "Not Enough Players", nextMap, setMap);
		}
		case 1:
		{
			new bool:UseClocktower = IncludeMap("clocktower");
			new bool:UseDowntown = IncludeMap("downtown");
			decl bool:CycleClocktower;
			new var2;
			CycleClocktower = UseClocktower || (!UseClocktower && !UseDowntown);
			new var3;
			if (CycleClocktower)
			{
				var3[0] = 2348;
			}
			else
			{
				var3[0] = 2360;
			}
			Format(setMap, 32, var3);
			PrintToChatAll("\x05[xG] %t", "Too Many Players", nextMap, setMap);
		}
		default:
		{
		}
	}
	SetNextMap(setMap);
	return 0;
}

StartAndSetupMapVoter()
{
	new clientCount = ValidClientCount(true);
	new includeNumber = 5;
	if (clientCount >= 4)
	{
		if (clientCount >= 8)
		{
			if (IncludeMap("clocktower"))
			{
				NominateMap("clocktower", true, 0);
			}
		}
		if (clientCount >= 14)
		{
			if (IncludeMap("roadwork_w01"))
			{
				NominateMap("roadwork_w01", true, 0);
			}
			if (IncludeMap("nuclear_forest02"))
			{
				NominateMap("nuclear_forest02", true, 0);
			}
			if (RegularServerType())
			{
				if (IncludeMap("rockv18"))
				{
					NominateMap("rockv18", true, 0);
				}
			}
			if (clientCount >= 16)
			{
				if (IncludeMap("downtown"))
				{
					NominateMap("downtown", true, 0);
				}
				if (clientCount >= 20)
				{
					includeNumber++;
					if (IncludeMap("gate"))
					{
						NominateMap("gate", true, 0);
					}
					if (clientCount >= 22)
					{
						if (IncludeMap("oilfiled"))
						{
							NominateMap("oilfield", true, 0);
						}
					}
				}
			}
		}
		if (IncludeMap("corner_intermediate_04"))
		{
			NominateMap("corner_intermediate_04", true, 0);
		}
		if (IncludeMap("sandbrick_03"))
		{
			NominateMap("sandbrick_03", true, 0);
		}
		if (RookieServerType())
		{
			includeNumber++;
			new var1;
			if (IncludeMap("mars_102") && clientCount >= 8)
			{
				NominateMap("mars_102", true, 0);
			}
		}
	}
	ServerCommand("sm_mapvote_include %d", includeNumber);
	ServerCommand("sm_mapvote_exclude %d", GetExcludeNumber(clientCount));
	InitiateMapChooserVote(MapChange:2, Handle:0);
	return 0;
}

GetExcludeNumber(clientCount)
{
	if (clientCount >= 14)
	{
		return 6;
	}
	if (clientCount >= 4)
	{
		return 4;
	}
	return 3;
}

bool:IncludeMap(String:checkMap[])
{
	return FindStringInArray(g_ExcludeMapList, checkMap) == -1;
}

AddMapToExclude()
{
	decl String:map[32];
	GetCurrentMap(map, 32);
	PushArrayString(g_ExcludeMapList, map);
	return 0;
}

ParseExcludedMaps()
{
	if (GetArraySize(g_ExcludeMapList) > 6)
	{
		RemoveFromArray(g_ExcludeMapList, 0);
	}
	return 0;
}

CreateTextFile()
{
	new idx;
	while (idx < 6)
	{
		decl String:path[256];
		BuildPath(PathType:0, path, 256, nd_text_file[idx]);
		if (!FileExists(path, false))
		{
			new Handle:fileHandle = OpenFile(path, "w");
			CloseHandle(fileHandle);
		}
		idx++;
	}
	return 0;
}

ReadTextFile()
{
	ClearArray(g_ExcludeMapList);
	new idx;
	while (idx < 6)
	{
		decl String:path[256];
		BuildPath(PathType:0, path, 256, nd_text_file[idx]);
		new Handle:fileHandle = OpenFile(path, "r");
		decl String:map[32];
		ReadFileString(fileHandle, map, 32, -1);
		PushArrayString(g_ExcludeMapList, map);
		CloseHandle(fileHandle);
		idx++;
	}
	return 0;
}

WriteTextFile()
{
	new idx;
	while (idx < 6)
	{
		decl String:path[256];
		BuildPath(PathType:0, path, 256, nd_text_file[idx]);
		DeleteFile(path);
		new Handle:fileHandle = OpenFile(path, "w");
		decl String:lastMap[32];
		GetArrayString(g_ExcludeMapList, idx, lastMap, 32);
		WriteFileString(fileHandle, lastMap, true);
		CloseHandle(fileHandle);
		idx++;
	}
	return 0;
}

