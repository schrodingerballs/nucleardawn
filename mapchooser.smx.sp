public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "01/17/2015",
	time = "12:29:20"
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
	name = "MapChooser",
	description = "Automated Map Voting",
	author = "AlliedModders LLC",
	version = "1.6.4-dev+4616",
	url = "http://www.sourcemod.net/"
};
new Handle:g_Cvar_Winlimit;
new Handle:g_Cvar_Maxrounds;
new Handle:g_Cvar_Fraglimit;
new Handle:g_Cvar_Bonusroundtime;
new Handle:g_Cvar_StartTime;
new Handle:g_Cvar_StartRounds;
new Handle:g_Cvar_StartFrags;
new Handle:g_Cvar_ExtendTimeStep;
new Handle:g_Cvar_ExtendRoundStep;
new Handle:g_Cvar_ExtendFragStep;
new Handle:g_Cvar_ExcludeMaps;
new Handle:g_Cvar_IncludeMaps;
new Handle:g_Cvar_NoVoteMode;
new Handle:g_Cvar_Extend;
new Handle:g_Cvar_DontChange;
new Handle:g_Cvar_EndOfMapVote;
new Handle:g_Cvar_VoteDuration;
new Handle:g_Cvar_RunOff;
new Handle:g_Cvar_RunOffPercent;
new Handle:g_VoteTimer;
new Handle:g_RetryTimer;
new Handle:g_MapList;
new Handle:g_NominateList;
new Handle:g_NominateOwners;
new Handle:g_OldMapList;
new Handle:g_NextMapList;
new Handle:g_VoteMenu;
new g_Extends;
new g_TotalRounds;
new bool:g_HasVoteStarted;
new bool:g_WaitingForVote;
new bool:g_MapVoteCompleted;
new bool:g_ChangeMapAtRoundEnd;
new bool:g_ChangeMapInProgress;
new g_mapFileSerial = -1;
new MapChange:g_ChangeTime;
new Handle:g_NominationsResetForward;
new Handle:g_MapVoteStartedForward;
new g_winCount[10];
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

Float:operator*(Float:,_:)(Float:oper1, oper2)
{
	return oper1 * float(oper2);
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

Handle:CreateDataTimer(Float:interval, Timer:func, &Handle:datapack, flags)
{
	datapack = CreateDataPack();
	flags |= 512;
	return CreateTimer(interval, func, datapack, flags);
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

ValidClientCount()
{
	new clientCount;
	new idx = 1;
	while (idx <= MaxClients)
	{
		if (IsValidClient(idx, true))
		{
			clientCount++;
		}
		idx++;
	}
	return clientCount;
}

public OnPluginStart()
{
	LoadTranslations("mapchooser.phrases");
	LoadTranslations("common.phrases");
	new arraySize = ByteCountToCells(256);
	g_MapList = CreateArray(arraySize, 0);
	g_NominateList = CreateArray(arraySize, 0);
	g_NominateOwners = CreateArray(1, 0);
	g_OldMapList = CreateArray(arraySize, 0);
	g_NextMapList = CreateArray(arraySize, 0);
	g_Cvar_EndOfMapVote = CreateConVar("sm_mapvote_endvote", "1", "Specifies if MapChooser should run an end of map vote", 0, true, 0.0, true, 1.0);
	g_Cvar_StartTime = CreateConVar("sm_mapvote_start", "3.0", "Specifies when to start the vote based on time remaining.", 0, true, 1.0, false, 0.0);
	g_Cvar_StartRounds = CreateConVar("sm_mapvote_startround", "2.0", "Specifies when to start the vote based on rounds remaining. Use 0 on TF2 to start vote during bonus round time", 0, true, 0.0, false, 0.0);
	g_Cvar_StartFrags = CreateConVar("sm_mapvote_startfrags", "5.0", "Specifies when to start the vote base on frags remaining.", 0, true, 1.0, false, 0.0);
	g_Cvar_ExtendTimeStep = CreateConVar("sm_extendmap_timestep", "15", "Specifies how much many more minutes each extension makes", 0, true, 5.0, false, 0.0);
	g_Cvar_ExtendRoundStep = CreateConVar("sm_extendmap_roundstep", "5", "Specifies how many more rounds each extension makes", 0, true, 1.0, false, 0.0);
	g_Cvar_ExtendFragStep = CreateConVar("sm_extendmap_fragstep", "10", "Specifies how many more frags are allowed when map is extended.", 0, true, 5.0, false, 0.0);
	g_Cvar_ExcludeMaps = CreateConVar("sm_mapvote_exclude", "5", "Specifies how many past maps to exclude from the vote.", 0, true, 0.0, false, 0.0);
	g_Cvar_IncludeMaps = CreateConVar("sm_mapvote_include", "5", "Specifies how many maps to include in the vote.", 0, true, 2.0, true, 6.0);
	g_Cvar_NoVoteMode = CreateConVar("sm_mapvote_novote", "1", "Specifies whether or not MapChooser should pick a map if no votes are received.", 0, true, 0.0, true, 1.0);
	g_Cvar_Extend = CreateConVar("sm_mapvote_extend", "0", "Number of extensions allowed each map.", 0, true, 0.0, false, 0.0);
	g_Cvar_DontChange = CreateConVar("sm_mapvote_dontchange", "1", "Specifies if a 'Don't Change' option should be added to early votes", 0, true, 0.0, false, 0.0);
	g_Cvar_VoteDuration = CreateConVar("sm_mapvote_voteduration", "20", "Specifies how long the mapvote should be available for.", 0, true, 5.0, false, 0.0);
	g_Cvar_RunOff = CreateConVar("sm_mapvote_runoff", "0", "Hold run of votes if winning choice is less than a certain margin", 0, true, 0.0, true, 1.0);
	g_Cvar_RunOffPercent = CreateConVar("sm_mapvote_runoffpercent", "50", "If winning choice has less than this percent of votes, hold a runoff", 0, true, 0.0, true, 100.0);
	RegAdminCmd("sm_mapvote", Command_Mapvote, 64, "sm_mapvote - Forces MapChooser to attempt to run a map vote now.", "", 0);
	RegAdminCmd("sm_setnextmap", Command_SetNextmap, 64, "sm_setnextmap <map>", "", 0);
	g_Cvar_Winlimit = FindConVar("mp_winlimit");
	g_Cvar_Maxrounds = FindConVar("mp_maxrounds");
	g_Cvar_Fraglimit = FindConVar("mp_fraglimit");
	g_Cvar_Bonusroundtime = FindConVar("mp_bonusroundtime");
	new var1;
	if (g_Cvar_Winlimit || g_Cvar_Maxrounds)
	{
		decl String:folder[64];
		GetGameFolderName(folder, 64);
		if (strcmp(folder, "tf", true))
		{
			if (strcmp(folder, "nucleardawn", true))
			{
				HookEvent("round_end", Event_RoundEnd, EventHookMode:1);
			}
			HookEvent("round_win", Event_RoundEnd, EventHookMode:1);
		}
		else
		{
			HookEvent("teamplay_win_panel", Event_TeamPlayWinPanel, EventHookMode:1);
			HookEvent("teamplay_restart_round", Event_TFRestartRound, EventHookMode:1);
			HookEvent("arena_win_panel", Event_TeamPlayWinPanel, EventHookMode:1);
		}
	}
	if (g_Cvar_Fraglimit)
	{
		HookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
	}
	AutoExecConfig(true, "mapchooser", "sourcemod");
	if (g_Cvar_Bonusroundtime)
	{
		SetConVarBounds(g_Cvar_Bonusroundtime, ConVarBounds:0, true, 30.0);
	}
	g_NominationsResetForward = CreateGlobalForward("OnNominationRemoved", ExecType:0, 7, 2);
	g_MapVoteStartedForward = CreateGlobalForward("OnMapVoteStarted", ExecType:0);
	return 0;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	RegPluginLibrary("mapchooser");
	CreateNative("NominateMap", Native_NominateMap);
	CreateNative("RemoveNominationByMap", Native_RemoveNominationByMap);
	CreateNative("RemoveNominationByOwner", Native_RemoveNominationByOwner);
	CreateNative("InitiateMapChooserVote", Native_InitiateVote);
	CreateNative("CanMapChooserStartVote", Native_CanVoteStart);
	CreateNative("HasEndOfMapVoteFinished", Native_CheckVoteDone);
	CreateNative("GetExcludeMapList", Native_GetExcludeMapList);
	CreateNative("GetNominatedMapList", Native_GetNominatedMapList);
	CreateNative("EndOfMapVoteEnabled", Native_EndOfMapVoteEnabled);
	return APLRes:0;
}

public OnConfigsExecuted()
{
	if (ReadMapList(g_MapList, g_mapFileSerial, "mapchooser", 3))
	{
		if (g_mapFileSerial == -1)
		{
			LogError("Unable to create a valid map list.");
		}
	}
	CreateNextVote();
	SetupTimeleftTimer();
	g_TotalRounds = 0;
	g_Extends = 0;
	g_MapVoteCompleted = false;
	ClearArray(g_NominateList);
	ClearArray(g_NominateOwners);
	new i;
	while (i < 10)
	{
		g_winCount[i] = 0;
		i++;
	}
	new var1;
	if (g_Cvar_Bonusroundtime && !GetConVarInt(g_Cvar_StartRounds))
	{
		if (GetConVarFloat(g_Cvar_Bonusroundtime) <= GetConVarFloat(g_Cvar_VoteDuration))
		{
			LogError("Warning - Bonus Round Time shorter than Vote Time. Votes during bonus round may not have time to complete");
		}
	}
	return 0;
}

public OnMapEnd()
{
	g_HasVoteStarted = false;
	g_WaitingForVote = false;
	g_ChangeMapAtRoundEnd = false;
	g_ChangeMapInProgress = false;
	g_VoteTimer = MissingTAG:0;
	g_RetryTimer = MissingTAG:0;
	decl String:map[256];
	GetCurrentMap(map, 256);
	PushArrayString(g_OldMapList, map);
	if (GetConVarInt(g_Cvar_ExcludeMaps) < GetArraySize(g_OldMapList))
	{
		RemoveFromArray(g_OldMapList, 0);
	}
	return 0;
}

public OnClientDisconnect(client)
{
	new index = FindValueInArray(g_NominateOwners, client);
	if (index == -1)
	{
		return 0;
	}
	new String:oldmap[256];
	GetArrayString(g_NominateList, index, oldmap, 256);
	Call_StartForward(g_NominationsResetForward);
	Call_PushString(oldmap);
	Call_PushCell(GetArrayCell(g_NominateOwners, index, 0, false));
	Call_Finish(0);
	RemoveFromArray(g_NominateOwners, index);
	RemoveFromArray(g_NominateList, index);
	return 0;
}

public Action:Command_SetNextmap(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setnextmap <map>");
		return Action:3;
	}
	decl String:map[256];
	GetCmdArg(1, map, 256);
	if (!IsMapValid(map))
	{
		ReplyToCommand(client, "[SM] %t", "Map was not found", map);
		return Action:3;
	}
	ShowActivity(client, "%t", "Changed Next Map", map);
	LogAction(client, -1, "\"%L\" changed nextmap to \"%s\"", client, map);
	SetNextMap(map);
	g_MapVoteCompleted = true;
	return Action:3;
}

public OnMapTimeLeftChanged()
{
	if (GetArraySize(g_MapList))
	{
		SetupTimeleftTimer();
	}
	return 0;
}

SetupTimeleftTimer()
{
	new time;
	new var1;
	if (GetMapTimeLeft(time) && time > 0)
	{
		new startTime = GetConVarInt(g_Cvar_StartTime) * 60;
		new var2;
		if (time - startTime < 0 && GetConVarBool(g_Cvar_EndOfMapVote) && !g_MapVoteCompleted && !g_HasVoteStarted)
		{
			InitiateVote(MapChange:2, Handle:0);
		}
		else
		{
			if (g_VoteTimer)
			{
				KillTimer(g_VoteTimer, false);
				g_VoteTimer = MissingTAG:0;
			}
			new Handle:data;
			g_VoteTimer = CreateDataTimer(float(time - startTime), Timer_StartMapVote, data, 2);
			WritePackCell(data, any:2);
			WritePackCell(data, any:0);
			ResetPack(data, false);
		}
	}
	return 0;
}

public Action:Timer_StartMapVote(Handle:timer, Handle:data)
{
	if (g_RetryTimer == timer)
	{
		g_WaitingForVote = false;
		g_RetryTimer = MissingTAG:0;
	}
	else
	{
		g_VoteTimer = MissingTAG:0;
	}
	new var1;
	if (!GetArraySize(g_MapList) || !GetConVarBool(g_Cvar_EndOfMapVote) || g_MapVoteCompleted || g_HasVoteStarted)
	{
		return Action:4;
	}
	new MapChange:mapChange = ReadPackCell(data);
	new Handle:hndl = ReadPackCell(data);
	InitiateVote(mapChange, hndl);
	return Action:4;
}

public Event_TFRestartRound(Handle:event, String:name[], bool:dontBroadcast)
{
	g_TotalRounds = 0;
	return 0;
}

public Event_TeamPlayWinPanel(Handle:event, String:name[], bool:dontBroadcast)
{
	if (g_ChangeMapAtRoundEnd)
	{
		g_ChangeMapAtRoundEnd = false;
		decl Float:delayTime;
		new var1;
		if (ValidClientCount() < 12)
		{
			var1 = 1090519040;
		}
		else
		{
			var1 = 1098907648;
		}
		delayTime = var1;
		CreateTimer(delayTime, Timer_ChangeMap, any:0, 2);
		g_ChangeMapInProgress = true;
	}
	new bluescore = GetEventInt(event, "blue_score");
	new redscore = GetEventInt(event, "red_score");
	new var2;
	if (GetEventInt(event, "round_complete") == 1 || StrEqual(name, "arena_win_panel", true))
	{
		g_TotalRounds += 1;
		new var3;
		if (!GetArraySize(g_MapList) || g_HasVoteStarted || g_MapVoteCompleted || !GetConVarBool(g_Cvar_EndOfMapVote))
		{
			return 0;
		}
		CheckMaxRounds(g_TotalRounds);
		switch (GetEventInt(event, "winning_team"))
		{
			case 2:
			{
				CheckWinLimit(redscore);
			}
			case 3:
			{
				CheckWinLimit(bluescore);
			}
			default:
			{
				return 0;
			}
		}
	}
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	if (g_ChangeMapAtRoundEnd)
	{
		g_ChangeMapAtRoundEnd = false;
		decl Float:delayTime;
		new var1;
		if (ValidClientCount() < 12)
		{
			var1 = 1090519040;
		}
		else
		{
			var1 = 1098907648;
		}
		delayTime = var1;
		CreateTimer(delayTime, Timer_ChangeMap, any:0, 2);
		g_ChangeMapInProgress = true;
	}
	new winner;
	if (strcmp(name, "round_win", true))
	{
		winner = GetEventInt(event, "winner");
	}
	else
	{
		winner = GetEventInt(event, "team");
	}
	new var2;
	if (winner && winner == 1 && !GetConVarBool(g_Cvar_EndOfMapVote))
	{
		return 0;
	}
	if (winner >= 10)
	{
		SetFailState("Mod exceed maximum team count - Please file a bug report.");
	}
	g_TotalRounds += 1;
	g_winCount[winner]++;
	new var3;
	if (!GetArraySize(g_MapList) || g_HasVoteStarted || g_MapVoteCompleted)
	{
		return 0;
	}
	CheckWinLimit(g_winCount[winner]);
	CheckMaxRounds(g_TotalRounds);
	return 0;
}

public CheckWinLimit(winner_score)
{
	if (g_Cvar_Winlimit)
	{
		new winlimit = GetConVarInt(g_Cvar_Winlimit);
		if (winlimit)
		{
			if (winlimit - GetConVarInt(g_Cvar_StartRounds) <= winner_score)
			{
				InitiateVote(MapChange:2, Handle:0);
			}
		}
	}
	return 0;
}

public CheckMaxRounds(roundcount)
{
	if (g_Cvar_Maxrounds)
	{
		new maxrounds = GetConVarInt(g_Cvar_Maxrounds);
		if (maxrounds)
		{
			if (maxrounds - GetConVarInt(g_Cvar_StartRounds) <= roundcount)
			{
				InitiateVote(MapChange:2, Handle:0);
			}
		}
	}
	return 0;
}

public Event_PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new var1;
	if (!GetArraySize(g_MapList) || g_Cvar_Fraglimit || g_HasVoteStarted)
	{
		return 0;
	}
	new var2;
	if (!GetConVarInt(g_Cvar_Fraglimit) || !GetConVarBool(g_Cvar_EndOfMapVote))
	{
		return 0;
	}
	if (g_MapVoteCompleted)
	{
		return 0;
	}
	new fragger = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (!fragger)
	{
		return 0;
	}
	if (GetConVarInt(g_Cvar_Fraglimit) - GetConVarInt(g_Cvar_StartFrags) <= GetClientFrags(fragger))
	{
		InitiateVote(MapChange:2, Handle:0);
	}
	return 0;
}

public Action:Command_Mapvote(client, args)
{
	InitiateVote(MapChange:2, Handle:0);
	return Action:3;
}

InitiateVote(MapChange:when, Handle:inputlist)
{
	g_WaitingForVote = true;
	if (IsVoteInProgress(Handle:0))
	{
		new Handle:data;
		g_RetryTimer = CreateDataTimer(5.0, Timer_StartMapVote, data, 2);
		WritePackCell(data, when);
		WritePackCell(data, inputlist);
		ResetPack(data, false);
		return 0;
	}
	new var1;
	if (g_MapVoteCompleted && g_ChangeMapInProgress)
	{
		return 0;
	}
	g_ChangeTime = when;
	g_WaitingForVote = false;
	g_HasVoteStarted = true;
	g_VoteMenu = CreateMenu(Handler_MapVoteMenu, MenuAction:-1);
	SetMenuTitle(g_VoteMenu, "Vote Nextmap");
	SetVoteResultCallback(g_VoteMenu, Handler_MapVoteFinished);
	Call_StartForward(g_MapVoteStartedForward);
	Call_Finish(0);
	decl String:map[256];
	if (inputlist)
	{
		new size = GetArraySize(inputlist);
		new i;
		while (i < size)
		{
			GetArrayString(inputlist, i, map, 256);
			if (IsMapValid(map))
			{
				AddMenuItem(g_VoteMenu, map, map, 0);
			}
			i++;
		}
	}
	else
	{
		new nominateCount = GetArraySize(g_NominateList);
		new voteSize = GetConVarInt(g_Cvar_IncludeMaps);
		decl nominationsToAdd;
		new var2;
		if (nominateCount >= voteSize)
		{
			var2 = voteSize;
		}
		else
		{
			var2 = nominateCount;
		}
		nominationsToAdd = var2;
		new i;
		while (i < nominationsToAdd)
		{
			GetArrayString(g_NominateList, i, map, 256);
			AddMenuItem(g_VoteMenu, map, map, 0);
			RemoveStringFromArray(g_NextMapList, map);
			Call_StartForward(g_NominationsResetForward);
			Call_PushString(map);
			Call_PushCell(GetArrayCell(g_NominateOwners, i, 0, false));
			Call_Finish(0);
			i++;
		}
		new i = nominationsToAdd;
		while (i < nominateCount)
		{
			GetArrayString(g_NominateList, i, map, 256);
			Call_StartForward(g_NominationsResetForward);
			Call_PushString(map);
			Call_PushCell(GetArrayCell(g_NominateOwners, i, 0, false));
			Call_Finish(0);
			i++;
		}
		new i = nominationsToAdd;
		new count;
		new availableMaps = GetArraySize(g_NextMapList);
		while (i < voteSize)
		{
			if (!(count >= availableMaps))
			{
				GetArrayString(g_NextMapList, count, map, 256);
				count++;
				AddMenuItem(g_VoteMenu, map, map, 0);
				i++;
			}
			ClearArray(g_NominateOwners);
			ClearArray(g_NominateList);
		}
		ClearArray(g_NominateOwners);
		ClearArray(g_NominateList);
	}
	new var3;
	if ((when && when == MapChange:1) && GetConVarBool(g_Cvar_DontChange))
	{
		AddMenuItem(g_VoteMenu, "##dontchange##", "Don't Change", 0);
	}
	else
	{
		new var5;
		if (GetConVarBool(g_Cvar_Extend) && g_Extends < GetConVarInt(g_Cvar_Extend))
		{
			AddMenuItem(g_VoteMenu, "##extend##", "Extend Map", 0);
		}
	}
	if (GetMenuItemCount(g_VoteMenu))
	{
		new voteDuration = GetConVarInt(g_Cvar_VoteDuration);
		SetMenuExitButton(g_VoteMenu, false);
		VoteMenuToAll(g_VoteMenu, voteDuration, 0);
		LogAction(-1, -1, "Voting for next map has started.");
		return 0;
	}
	g_HasVoteStarted = false;
	CloseHandle(g_VoteMenu);
	g_VoteMenu = MissingTAG:0;
	return 0;
}

public Handler_VoteFinishedGeneric(Handle:menu, num_votes, num_clients, client_info[][2], num_items, item_info[][2])
{
	decl String:map[256];
	GetMenuItem(menu, item_info[0][0], map, 256, 0, "", 0);
	if (strcmp(map, "##extend##", false))
	{
		if (strcmp(map, "##dontchange##", false))
		{
			if (g_ChangeTime == MapChange:2)
			{
				SetNextMap(map);
			}
			else
			{
				if (g_ChangeTime)
				{
					SetNextMap(map);
					g_ChangeMapAtRoundEnd = true;
				}
				new Handle:data;
				CreateDataTimer(2.0, Timer_ChangeMap, data, 0);
				WritePackString(data, map);
				g_ChangeMapInProgress = false;
			}
			g_HasVoteStarted = false;
			g_MapVoteCompleted = true;
			LogAction(-1, -1, "Voting for next map has finished. Nextmap: %s.", map);
		}
		LogAction(-1, -1, "Voting for next map has finished. 'No Change' was the winner");
		g_HasVoteStarted = false;
		CreateNextVote();
		SetupTimeleftTimer();
	}
	else
	{
		g_Extends += 1;
		new time;
		if (GetMapTimeLimit(time))
		{
			if (0 < time)
			{
				ExtendMapTimeLimit(GetConVarInt(g_Cvar_ExtendTimeStep) * 60);
			}
		}
		if (g_Cvar_Winlimit)
		{
			new winlimit = GetConVarInt(g_Cvar_Winlimit);
			if (winlimit)
			{
				SetConVarInt(g_Cvar_Winlimit, GetConVarInt(g_Cvar_ExtendRoundStep) + winlimit, false, false);
			}
		}
		if (g_Cvar_Maxrounds)
		{
			new maxrounds = GetConVarInt(g_Cvar_Maxrounds);
			if (maxrounds)
			{
				SetConVarInt(g_Cvar_Maxrounds, GetConVarInt(g_Cvar_ExtendRoundStep) + maxrounds, false, false);
			}
		}
		if (g_Cvar_Fraglimit)
		{
			new fraglimit = GetConVarInt(g_Cvar_Fraglimit);
			if (fraglimit)
			{
				SetConVarInt(g_Cvar_Fraglimit, GetConVarInt(g_Cvar_ExtendFragStep) + fraglimit, false, false);
			}
		}
		LogAction(-1, -1, "Voting for next map has finished. The current map has been extended.");
		g_HasVoteStarted = false;
		CreateNextVote();
		SetupTimeleftTimer();
	}
	return 0;
}

public Handler_MapVoteFinished(Handle:menu, num_votes, num_clients, client_info[][2], num_items, item_info[][2])
{
	new var1;
	if (GetConVarBool(g_Cvar_RunOff) && num_items > 1)
	{
		new Float:winningvotes = float(item_info[0][1]);
		new Float:required = GetConVarFloat(g_Cvar_RunOffPercent) / 100.0 * num_votes;
		if (winningvotes < required)
		{
			g_VoteMenu = CreateMenu(Handler_MapVoteMenu, MenuAction:-1);
			SetMenuTitle(g_VoteMenu, "Runoff Vote Nextmap");
			SetVoteResultCallback(g_VoteMenu, Handler_VoteFinishedGeneric);
			decl String:map[256];
			decl String:info1[256];
			decl String:info2[256];
			GetMenuItem(menu, item_info[0][0], map, 256, 0, info1, 256);
			AddMenuItem(g_VoteMenu, map, info1, 0);
			GetMenuItem(menu, item_info[1], map, 256, 0, info2, 256);
			AddMenuItem(g_VoteMenu, map, info2, 0);
			new voteDuration = GetConVarInt(g_Cvar_VoteDuration);
			SetMenuExitButton(g_VoteMenu, false);
			VoteMenuToAll(g_VoteMenu, voteDuration, 0);
			LogMessage("Voting for next map was indecisive, beginning runoff vote");
			return 0;
		}
	}
	Handler_VoteFinishedGeneric(menu, num_votes, num_clients, client_info, num_items, item_info);
	return 0;
}

public Handler_MapVoteMenu(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 2:
		{
			decl String:buffer[256];
			Format(buffer, 255, "%T", "Vote Nextmap", param1);
			new Handle:panel = param2;
			SetPanelTitle(panel, buffer, false);
		}
		case 16:
		{
			g_VoteMenu = MissingTAG:0;
			CloseHandle(menu);
		}
		case 128:
		{
			new var1;
			if (param1 == -2 && GetConVarBool(g_Cvar_NoVoteMode))
			{
				new count = GetMenuItemCount(menu);
				decl String:map[256];
				GetMenuItem(menu, 0, map, 256, 0, "", 0);
				new var2;
				if (strcmp(map, "##extend##", false) && strcmp(map, "##dontchange##", false))
				{
					new item = GetRandomInt(0, count + -1);
					GetMenuItem(menu, item, map, 256, 0, "", 0);
					while (strcmp(map, "##extend##", false) && strcmp(map, "##dontchange##", false))
					{
						item = GetRandomInt(0, count + -1);
						GetMenuItem(menu, item, map, 256, 0, "", 0);
					}
					SetNextMap(map);
					g_MapVoteCompleted = true;
				}
			}
			g_HasVoteStarted = false;
		}
		case 512:
		{
			if (param2 == GetMenuItemCount(menu) + -1)
			{
				decl String:map[256];
				decl String:buffer[256];
				GetMenuItem(menu, param2, map, 256, 0, "", 0);
				if (strcmp(map, "##extend##", false))
				{
					if (!(strcmp(map, "##dontchange##", false)))
					{
						Format(buffer, 255, "%T", "Dont Change", param1);
						return RedrawMenuItem(buffer);
					}
				}
				Format(buffer, 255, "%T", "Extend Map", param1);
				return RedrawMenuItem(buffer);
			}
		}
		default:
		{
		}
	}
	return 0;
}

public Action:Timer_ChangeMap(Handle:hTimer, Handle:dp)
{
	g_ChangeMapInProgress = false;
	new String:map[256];
	if (dp)
	{
		ResetPack(dp, false);
		ReadPackString(dp, map, 256);
	}
	else
	{
		if (!GetNextMap(map, 256))
		{
			return Action:4;
		}
	}
	ForceChangeLevel(map, "Map Vote");
	return Action:4;
}

bool:RemoveStringFromArray(Handle:array, String:str[])
{
	new index = FindStringInArray(array, str);
	if (index != -1)
	{
		RemoveFromArray(array, index);
		return true;
	}
	return false;
}

CreateNextVote()
{
	ClearArray(g_NextMapList);
	decl String:map[256];
	new Handle:tempMaps = CloneArray(g_MapList);
	GetCurrentMap(map, 256);
	RemoveStringFromArray(tempMaps, map);
	new var1;
	if (GetConVarInt(g_Cvar_ExcludeMaps) && GetArraySize(tempMaps) > GetConVarInt(g_Cvar_ExcludeMaps))
	{
		new i;
		while (GetArraySize(g_OldMapList) > i)
		{
			GetArrayString(g_OldMapList, i, map, 256);
			RemoveStringFromArray(tempMaps, map);
			i++;
		}
	}
	decl limit;
	new var2;
	if (GetConVarInt(g_Cvar_IncludeMaps) < GetArraySize(tempMaps))
	{
		var2 = GetConVarInt(g_Cvar_IncludeMaps);
	}
	else
	{
		var2 = GetArraySize(tempMaps);
	}
	limit = var2;
	new i;
	while (i < limit)
	{
		new b = GetRandomInt(0, GetArraySize(tempMaps) + -1);
		GetArrayString(tempMaps, b, map, 256);
		PushArrayString(g_NextMapList, map);
		RemoveFromArray(tempMaps, b);
		i++;
	}
	CloseHandle(tempMaps);
	return 0;
}

bool:CanVoteStart()
{
	new var1;
	if (g_WaitingForVote || g_HasVoteStarted)
	{
		return false;
	}
	return true;
}

NominateResult:InternalNominateMap(String:map[], bool:force, owner)
{
	if (!IsMapValid(map))
	{
		return NominateResult:3;
	}
	if (FindStringInArray(g_NominateList, map) != -1)
	{
		return NominateResult:2;
	}
	new index;
	new var1;
	if (owner && (index = FindValueInArray(g_NominateOwners, owner)) != -1)
	{
		new String:oldmap[256];
		GetArrayString(g_NominateList, index, oldmap, 256);
		Call_StartForward(g_NominationsResetForward);
		Call_PushString(oldmap);
		Call_PushCell(owner);
		Call_Finish(0);
		SetArrayString(g_NominateList, index, map);
		return NominateResult:1;
	}
	new var2;
	if (GetArraySize(g_NominateList) >= GetConVarInt(g_Cvar_IncludeMaps) && !force)
	{
		return NominateResult:4;
	}
	PushArrayString(g_NominateList, map);
	PushArrayCell(g_NominateOwners, owner);
	while (GetConVarInt(g_Cvar_IncludeMaps) < GetArraySize(g_NominateList))
	{
		new String:oldmap[256];
		GetArrayString(g_NominateList, 0, oldmap, 256);
		Call_StartForward(g_NominationsResetForward);
		Call_PushString(oldmap);
		Call_PushCell(GetArrayCell(g_NominateOwners, 0, 0, false));
		Call_Finish(0);
		RemoveFromArray(g_NominateList, 0);
		RemoveFromArray(g_NominateOwners, 0);
	}
	return NominateResult:0;
}

public Native_NominateMap(Handle:plugin, numParams)
{
	new len;
	GetNativeStringLength(1, len);
	if (0 >= len)
	{
		return 0;
	}
	new map[len + 1];
	GetNativeString(1, map, len + 1, 0);
	return InternalNominateMap(map, GetNativeCell(2), GetNativeCell(3));
}

bool:InternalRemoveNominationByMap(String:map[])
{
	new i;
	while (GetArraySize(g_NominateList) > i)
	{
		new String:oldmap[256];
		GetArrayString(g_NominateList, i, oldmap, 256);
		if (!(strcmp(map, oldmap, false)))
		{
			Call_StartForward(g_NominationsResetForward);
			Call_PushString(oldmap);
			Call_PushCell(GetArrayCell(g_NominateOwners, i, 0, false));
			Call_Finish(0);
			RemoveFromArray(g_NominateList, i);
			RemoveFromArray(g_NominateOwners, i);
			return true;
		}
		i++;
	}
	return false;
}

public Native_RemoveNominationByMap(Handle:plugin, numParams)
{
	new len;
	GetNativeStringLength(1, len);
	if (0 >= len)
	{
		return 0;
	}
	new map[len + 1];
	GetNativeString(1, map, len + 1, 0);
	return InternalRemoveNominationByMap(map);
}

bool:InternalRemoveNominationByOwner(owner)
{
	new index;
	new var1;
	if (owner && (index = FindValueInArray(g_NominateOwners, owner)) != -1)
	{
		new String:oldmap[256];
		GetArrayString(g_NominateList, index, oldmap, 256);
		Call_StartForward(g_NominationsResetForward);
		Call_PushString(oldmap);
		Call_PushCell(owner);
		Call_Finish(0);
		RemoveFromArray(g_NominateList, index);
		RemoveFromArray(g_NominateOwners, index);
		return true;
	}
	return false;
}

public Native_RemoveNominationByOwner(Handle:plugin, numParams)
{
	return InternalRemoveNominationByOwner(GetNativeCell(1));
}

public Native_InitiateVote(Handle:plugin, numParams)
{
	new MapChange:when = GetNativeCell(1);
	new Handle:inputarray = GetNativeCell(2);
	LogAction(-1, -1, "Starting map vote because outside request");
	InitiateVote(when, inputarray);
	return 0;
}

public Native_CanVoteStart(Handle:plugin, numParams)
{
	return CanVoteStart();
}

public Native_CheckVoteDone(Handle:plugin, numParams)
{
	return g_MapVoteCompleted;
}

public Native_EndOfMapVoteEnabled(Handle:plugin, numParams)
{
	return GetConVarBool(g_Cvar_EndOfMapVote);
}

public Native_GetExcludeMapList(Handle:plugin, numParams)
{
	new Handle:array = GetNativeCell(1);
	if (array)
	{
		new size = GetArraySize(g_OldMapList);
		decl String:map[256];
		new i;
		while (i < size)
		{
			GetArrayString(g_OldMapList, i, map, 256);
			PushArrayString(array, map);
			i++;
		}
		return 0;
	}
	return 0;
}

public Native_GetNominatedMapList(Handle:plugin, numParams)
{
	new Handle:maparray = GetNativeCell(1);
	new Handle:ownerarray = GetNativeCell(2);
	if (maparray)
	{
		decl String:map[256];
		new i;
		while (GetArraySize(g_NominateList) > i)
		{
			GetArrayString(g_NominateList, i, map, 256);
			PushArrayString(maparray, map);
			if (ownerarray)
			{
				new index = GetArrayCell(g_NominateOwners, i, 0, false);
				PushArrayCell(ownerarray, index);
			}
			i++;
		}
		return 0;
	}
	return 0;
}

