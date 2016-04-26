public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "03/02/2016",
	time = "13:51:05"
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
public Extension:__ext_cprefs =
{
	name = "Client Preferences",
	file = "clientprefs.ext",
	autoload = 1,
	required = 1,
};
public SharedPlugin:__pl_commander =
{
	name = "nd_commander",
	file = "nd_commander_restrictions.smx",
	required = 0,
};
public Plugin:myinfo =
{
	name = "TimeLimit Features",
	description = "Provides time limit features for Nuclear Dawn.",
	author = "Stickz",
	version = "1.2.0",
	url = "N/A"
};
new String:nd_timelimit_commands[2][0];
new g_Integer[2];
new bool:g_Bool[8];
new Handle:cookie_timelimit_features;
new bool:option_timelimit_features[66] =
{
	1, ...
};
new voteCount[2];
new bool:g_hasVotedEmpire[66];
new bool:g_hasVotedConsort[66];
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

bool:operator>=(Float:,_:)(Float:oper1, oper2)
{
	return oper1 >= float(oper2);
}

bool:operator<=(Float:,_:)(Float:oper1, oper2)
{
	return oper1 <= float(oper2);
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

ValidTeamCount(teamName)
{
	new clientCount;
	new idx = 1;
	while (idx <= MaxClients)
	{
		new var1;
		if (IsValidClient(idx, true) && teamName == GetClientTeam(idx))
		{
			clientCount++;
		}
		idx++;
	}
	return clientCount;
}

bool:NDC_IsCommander(client)
{
	if (!GetFeatureStatus(FeatureType:0, "GetCommanderTeam") == 0)
	{
		return client == GameRules_GetPropEnt("m_hCommanders", GetClientTeam(client) + -2);
	}
	return GetCommanderTeam(client) != -1;
}

public __pl_commander_SetNTVOptional()
{
	MarkNativeAsOptional("GetCommanderTeam");
	return 0;
}

AddUpdaterLibrary()
{
	return 0;
}

public OnPluginStart()
{
	RegConsoleCmd("sm_timeleft", CMD_Time, "", 0);
	RegConsoleCmd("sm_time", CMD_Time, "", 0);
	RegConsoleCmd("sm_extend", CMD_Extend, "", 0);
	AddCommandListener(PlayerJoinTeam, "jointeam");
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("round_end", Event_RoundEnd, EventHookMode:2);
	HookEvent("timeleft_1m", Event_MinuteLeft, EventHookMode:2);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	cookie_timelimit_features = RegClientCookie("TimeLimit Features On/Off", "", CookieAccess:1);
	new info;
	SetCookieMenuItem(CookieMenuHandler_TimeLimitFeatures, info, "TimeLimit Features");
	LoadTranslations("common.phrases");
	LoadTranslations("nd_timelimit.phrases");
	AddUpdaterLibrary();
	return 0;
}

public OnMapStart()
{
	setVarriableDefaults();
	return 0;
}

public OnClientPutInServer(client)
{
	new var1;
	if (g_Bool[0] && g_Bool[1] && !g_Bool[2] && ValidClientCount(true) > 12)
	{
		PrintToChatAll("\x05[xG] %t!", "Limit Effect");
		new var2;
		if (g_Bool[7])
		{
			var2 = float(45);
		}
		else
		{
			var2 = float(60);
		}
		CreateTimer(var2, TIMER_TotalTimeLeft, any:0, 3);
		g_Bool[2] = 1;
	}
	return 0;
}

public OnClientDisconnect(client)
{
	resetValues(client);
	return 0;
}

public Action:CMD_Time(client, args)
{
	printTime(client);
	return Action:0;
}

public Action:OnClientSayCommand(client, String:command[], String:sArgs[])
{
	if (client)
	{
		if (GetClientTeam(client) > 1)
		{
			new idx;
			while (idx < 2)
			{
				if (!(strcmp(sArgs, nd_timelimit_commands[idx], false)))
				{
					new ReplySource:old = SetCmdReplySource(ReplySource:1);
					printTime(client);
					SetCmdReplySource(old);
					return Action:4;
				}
				idx++;
			}
			if (!(strcmp(sArgs, "extend", false)))
			{
				new ReplySource:old = SetCmdReplySource(ReplySource:1);
				callExtend(client);
				SetCmdReplySource(old);
				return Action:4;
			}
		}
	}
	return Action:0;
}

public Action:PlayerJoinTeam(client, String:command[], argc)
{
	resetValues(client);
	return Action:0;
}

public Action:CMD_Extend(client, args)
{
	callExtend(client);
	return Action:3;
}

public Action:TIMER_ChangeResumeTime(Handle:timer)
{
	g_Bool[7] = 1;
	return Action:0;
}

public Action:TIMER_ShowMinLeft(Handle:timer)
{
	if (g_Bool[5])
	{
		g_Bool[5] = 0;
		return Action:4;
	}
	1516 + 4/* ERROR unknown load Binary */--;
	switch (g_Integer[1])
	{
		case 0:
		{
			if (g_Bool[0])
			{
				PrintToChatAll("\x05[xG] %t.", "Time End");
			}
			ServerCommand("mp_roundtime 1");
			return Action:4;
		}
		default:
		{
			new Handle:HudText = CreateHudSynchronizer();
			SetHudTextParams(-1.0, 0.4, 1.0, 220, 20, 60, 255, 0, 6.0, 0.1, 0.2);
			new idx = 1;
			while (idx <= MaxClients)
			{
				new var1;
				if (IsClientInGame(idx) && option_timelimit_features[idx] && !NDC_IsCommander(idx))
				{
					ShowSyncHudText(idx, HudText, "%d", 1516 + 4);
				}
				idx++;
			}
			CloseHandle(HudText);
			return Action:0;
		}
	}
}

public Action:TIMER_TotalTimeLeft(Handle:timer)
{
	1516/* ERROR unknown load Constant */--;
	switch (g_Integer[0])
	{
		case 1:
		{
			PrintToChatAll("\x05 One minute remaining!");
			CreateTimer(1.0, TIMER_ShowMinLeft, any:0, 3);
			return Action:4;
		}
		case 5:
		{
			g_Bool[3] = 1;
			PrintToChatAll("\x05 %d Minutes remaining!", g_Integer);
		}
		case 15, 30, 45:
		{
			PrintToChatAll("\x05 %d Minutes remaining!", g_Integer);
		}
		default:
		{
		}
	}
	return Action:0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	new clientCount = ValidClientCount(true);
	decl String:currentMap[32];
	GetCurrentMap(currentMap, 32);
	if (clientCount > 10)
	{
		new fiveMinutesRemaining = 60;
		if (StrContains(currentMap, "corner", false))
		{
			ServerCommand("mp_roundtime %d", 60);
			fiveMinutesRemaining *= 55;
		}
		else
		{
			ServerCommand("mp_roundtime %d", 75);
			fiveMinutesRemaining *= 70;
		}
		CreateTimer(float(fiveMinutesRemaining), TIMER_FiveMinLeft, any:0, 2);
	}
	else
	{
		g_Bool[0] = 1;
		CreateTimer(float(20), TIMER_ChangeResumeTime, any:0, 2);
	}
	g_Bool[1] = 1;
	return 0;
}

public Event_MinuteLeft(Handle:event, String:name[], bool:dontBroadcast)
{
	CreateTimer(1.0, TIMER_ShowMinLeft, any:0, 3);
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	g_Bool[6] = 1;
	return 0;
}

public Action:TIMER_FiveMinLeft(Handle:timer)
{
	g_Bool[3] = 1;
	if (!g_Bool[4])
	{
		PrintExtendToEnabled();
	}
	return Action:0;
}

PrintExtendToEnabled()
{
	new idx;
	while (idx < 65)
	{
		new var1;
		if (IsValidClient(idx, true) && option_timelimit_features[idx])
		{
			PrintToChat(idx, "\x05[xG] %t!", "Extend Availible");
		}
		idx++;
	}
	return 0;
}

callExtend(client)
{
	new team = GetClientTeam(client);
	if (ValidTeamCount(team) < 6)
	{
		PrintToChat(client, "\x05[xG] %t!", "Six Required");
	}
	else
	{
		if (!g_Bool[3])
		{
			PrintToChat(client, "\x05[xG] %t!", "Wait End");
		}
		if (g_Bool[4])
		{
			PrintToChat(client, "\x05[xG] %t!", "Already Extended");
		}
		if (team < 2)
		{
			PrintToChat(client, "\x05[xG] %t!", "On Team");
		}
		new var1;
		if (g_hasVotedEmpire[client] || g_hasVotedConsort[client])
		{
			PrintToChat(client, "\x05[xG] %t!", "You Extended");
		}
		if (g_Bool[6])
		{
			PrintToChat(client, "\x05[xG] %t!", "Round Ended");
		}
		voteCount[team + -2]++;
		switch (team)
		{
			case 2:
			{
				g_hasVotedConsort[client] = 1;
			}
			case 3:
			{
				g_hasVotedEmpire[client] = 1;
			}
			default:
			{
			}
		}
		checkVotes(true, team, client);
	}
	return 0;
}

resetValues(client)
{
	new team;
	if (g_hasVotedConsort[client])
	{
		team = 2;
		g_hasVotedConsort[client] = 0;
	}
	else
	{
		if (g_hasVotedEmpire[client])
		{
			team = 3;
			g_hasVotedEmpire[client] = 0;
		}
	}
	if (team > 1)
	{
		voteCount[team + -2]--;
		new var1;
		if (ValidClientCount(true) < 6 && !g_Bool[6] && !g_Bool[4] && g_Bool[3])
		{
			checkVotes(false, -1, -1);
		}
	}
	return 0;
}

checkVotes(bool:display, team, client)
{
	new Float:teamEmpireCount = 0.51 * ValidTeamCount(3);
	new Float:teamConsortCount = 0.51 * ValidTeamCount(2);
	new Float:empireRemainder = teamEmpireCount - float(voteCount[1]);
	new Float:consortRemainder = teamConsortCount - float(voteCount[0]);
	new var1;
	if (empireRemainder <= 0.0 && consortRemainder <= 0.0)
	{
		extendTime();
	}
	else
	{
		if (display)
		{
			displayVotes(team, empireRemainder, consortRemainder, client);
		}
	}
	return 0;
}

extendTime()
{
	decl String:currentMap[32];
	GetCurrentMap(currentMap, 32);
	if (!g_Bool[0])
	{
		new roundTime = 15;
		new var1;
		if (StrContains(currentMap, "corner", false))
		{
			var1 = 60;
		}
		else
		{
			var1 = 75;
		}
		roundTime = var1 + roundTime;
		ServerCommand("mp_roundtime %d", roundTime);
	}
	else
	{
		g_Integer[0] = 15;
	}
	g_Bool[4] = 1;
	g_Bool[5] = 1;
	PrintToChatAll("\x05[xG] %t!", "Round Extended");
	return 0;
}

displayVotes(team, Float:empireRemainder, Float:consortRemainder, client)
{
	decl String:name[64];
	GetClientName(client, name, 64);
	new var1;
	if (empireRemainder >= 1.4E-45 && consortRemainder >= 1.4E-45)
	{
		PrintToChatAll("\x05%t", "Extend Both", name, RoundToCeil(consortRemainder), RoundToCeil(empireRemainder));
		return 0;
	}
	switch (team)
	{
		case 2:
		{
			if (empireRemainder <= 0.0)
			{
				PrintToChatAll("\x05%t", "Extend Consort", name, RoundToCeil(consortRemainder));
			}
		}
		case 3:
		{
			if (consortRemainder <= 0.0)
			{
				PrintToChatAll("\x05%t", "Extend Empire", name, RoundToCeil(empireRemainder));
			}
		}
		default:
		{
		}
	}
	return 0;
}

setVarriableDefaults()
{
	g_Integer[0] = 60;
	g_Integer[1] = 61;
	g_Bool[0] = 0;
	g_Bool[1] = 0;
	g_Bool[2] = 0;
	g_Bool[6] = 0;
	g_Bool[4] = 0;
	g_Bool[5] = 0;
	g_Bool[3] = 0;
	g_Bool[7] = 0;
	return 0;
}

printTime(client)
{
	if (!g_Bool[0])
	{
		PrintToChat(client, "\x05[xG] %t!", "Regular Time");
	}
	else
	{
		if (g_Bool[2])
		{
			PrintToChat(client, "\x05[xG] There are %d minutes remaining!", g_Integer);
		}
		if (g_Bool[1])
		{
			PrintToChat(client, "\x05[xG] %t!", "Time Disabled");
		}
	}
	return 0;
}

public CookieMenuHandler_TimeLimitFeatures(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	switch (action)
	{
		case 0:
		{
			decl String:status[12];
			new var2;
			if (option_timelimit_features[client])
			{
				var2[0] = 3136;
			}
			else
			{
				var2[0] = 3140;
			}
			Format(status, 10, "%T", var2, client);
			Format(buffer, maxlen, "%T: %s", "Cookie TimeLimit Features", client, status);
		}
		case 1:
		{
			option_timelimit_features[client] = !option_timelimit_features[client];
			new var1;
			if (option_timelimit_features[client])
			{
				var1[0] = 3180;
			}
			else
			{
				var1[0] = 3184;
			}
			SetClientCookie(client, cookie_timelimit_features, var1);
			ShowCookieMenu(client);
		}
		default:
		{
		}
	}
	return 0;
}

public OnClientCookiesCached(client)
{
	option_timelimit_features[client] = GetCookieTimeLimitFeautres(client);
	return 0;
}

bool:GetCookieTimeLimitFeautres(client)
{
	decl String:buffer[12];
	GetClientCookie(client, cookie_timelimit_features, buffer, 10);
	return StrEqual(buffer, "On", true);
}

