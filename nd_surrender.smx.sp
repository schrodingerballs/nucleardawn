public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "03/03/2016",
	time = "20:34:31"
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
new voteCount[2];
new bool:g_Bool[3];
new bool:g_hasVotedEmpire[66];
new bool:g_hasVotedConsort[66];
new Handle:SurrenderDelayTimer;
public Plugin:myinfo =
{
	name = "Surrender Feature",
	description = "Allow alternative methods of surrendering.",
	author = "Stickz",
	version = "1.1.3",
	url = "N/A"
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

Float:operator*(Float:,_:)(Float:oper1, oper2)
{
	return oper1 * float(oper2);
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

String:NumberInEnglish(num, _arg1)
{
	decl String:englishNumber[16];
	switch (num)
	{
		case 1:
		{
			Format(englishNumber, 16, "one");
		}
		case 2:
		{
			Format(englishNumber, 16, "two");
		}
		case 3:
		{
			Format(englishNumber, 16, "three");
		}
		case 4:
		{
			Format(englishNumber, 16, "four");
		}
		case 5:
		{
			Format(englishNumber, 16, "five");
		}
		case 6:
		{
			Format(englishNumber, 16, "six");
		}
		case 7:
		{
			Format(englishNumber, 16, "seven");
		}
		case 8:
		{
			Format(englishNumber, 16, "eight");
		}
		case 9:
		{
			Format(englishNumber, 16, "nine");
		}
		case 10:
		{
			Format(englishNumber, 16, "ten");
		}
		case 11:
		{
			Format(englishNumber, 16, "eleven");
		}
		case 12:
		{
			Format(englishNumber, 16, "twelve");
		}
		default:
		{
		}
	}
	return englishNumber;
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

AddUpdaterLibrary()
{
	return 0;
}

public OnPluginStart()
{
	RegConsoleCmd("sm_surrender", CMD_Surrender, "", 0);
	AddCommandListener(PlayerJoinTeam, "jointeam");
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("round_end", Event_RoundEnd, EventHookMode:2);
	HookEvent("timeleft_5s", Event_TimeLimit, EventHookMode:2);
	LoadTranslations("nd_surrender.phrases");
	LoadTranslations("numbers.phrases");
	AddUpdaterLibrary();
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	voteCount[0] = 0;
	voteCount[1] = 0;
	SurrenderDelayTimer = CreateTimer(480.0, TIMER_surrenderDelay, any:0, 2);
	g_Bool[0] = 0;
	g_Bool[1] = 0;
	g_Bool[2] = 0;
	new client = 1;
	while (client <= MaxClients)
	{
		g_hasVotedEmpire[client] = 0;
		g_hasVotedConsort[client] = 0;
		client++;
	}
	return 0;
}

public Event_TimeLimit(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!g_Bool[2])
	{
		roundEnd();
	}
	return 0;
}

public Action:OnClientSayCommand(client, String:command[], String:sArgs[])
{
	if (client)
	{
		new var1;
		if (strcmp(sArgs, "surrender", false) && strcmp(sArgs, "SURRENDER", false))
		{
			new ReplySource:old = SetCmdReplySource(ReplySource:1);
			callSurrender(client);
			SetCmdReplySource(old);
			return Action:4;
		}
	}
	return Action:0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!g_Bool[2])
	{
		roundEnd();
	}
	return 0;
}

roundEnd()
{
	if (!g_Bool[2])
	{
		new var1;
		if (!g_Bool[0] && SurrenderDelayTimer)
		{
			CloseHandle(SurrenderDelayTimer);
		}
		g_Bool[2] = 1;
	}
	return 0;
}

public Action:PlayerJoinTeam(client, String:command[], argc)
{
	resetValues(client);
	return Action:0;
}

public Action:CMD_Surrender(client, args)
{
	callSurrender(client);
	return Action:3;
}

public OnClientDisconnect(client)
{
	resetValues(client);
	return 0;
}

public Action:TIMER_surrenderDelay(Handle:timer)
{
	g_Bool[0] = 1;
	return Action:0;
}

public Action:TIMER_DisplaySurrender(Handle:timer, any:team)
{
	switch (team)
	{
		case 2:
		{
			PrintToChatAll("\x05%t!", "Consort Surrendered");
		}
		case 3:
		{
			PrintToChatAll("\x05%t!", "Empire Surrendered");
		}
		default:
		{
		}
	}
	return Action:0;
}

callSurrender(client)
{
	new team = GetClientTeam(client);
	new teamCount = ValidTeamCount(team);
	if (teamCount < 4)
	{
		PrintToChat(client, "\x05[xG] %t!", "Four Required");
	}
	else
	{
		if (!g_Bool[0])
		{
			PrintToChat(client, "\x05[xG] %t", "Too Soon");
		}
		if (g_Bool[1])
		{
			PrintToChat(client, "\x05[xG] %t!", "Team Surrendered");
		}
		if (team < 2)
		{
			PrintToChat(client, "\x05[xG] %t!", "On Team");
		}
		new var1;
		if (g_hasVotedEmpire[client] || g_hasVotedConsort[client])
		{
			PrintToChat(client, "\x05[xG] %t!", "You Surrendered");
		}
		if (g_Bool[2])
		{
			PrintToChat(client, "\x05[xG] %t!", "Round Ended");
		}
		new teamIDX = team + -2;
		new Float:teamFloat = 0.51 * teamCount;
		if (teamFloat < 4.0)
		{
			teamFloat = 4.0;
		}
		voteCount[teamIDX]++;
		new Remainder = RoundToCeil(teamFloat) - voteCount[teamIDX];
		if (0 >= Remainder)
		{
			endGame(team);
		}
		else
		{
			displayVotes(team, Remainder, client);
		}
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
	}
	return 0;
}

checkQuitSurrender(team)
{
	new Float:teamFloat = 0.51 * ValidTeamCount(team);
	new Remainder = RoundToCeil(teamFloat) - voteCount[team + -2];
	if (0 >= Remainder)
	{
		endGame(team);
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
		if (ValidClientCount(false) < 4 && !g_Bool[2] && !g_Bool[1])
		{
			checkQuitSurrender(2);
		}
	}
	return 0;
}

endGame(team)
{
	g_Bool[1] = 1;
	ServerCommand("mp_roundtime 1");
	CreateTimer(0.5, TIMER_DisplaySurrender, team, 2);
	return 0;
}

displayVotes(team, Remainder, client)
{
	decl String:name[64];
	GetClientName(client, name, 64);
	decl String:number[32];
	Format(number, 32, NumberInEnglish(Remainder));
	new idx = 1;
	while (idx <= MaxClients)
	{
		new var1;
		if (IsValidClient(idx, true) && team == GetClientTeam(idx))
		{
			PrintToChat(idx, "\x05%t", "Typed Surrender", name, number);
		}
		idx++;
	}
	return 0;
}

