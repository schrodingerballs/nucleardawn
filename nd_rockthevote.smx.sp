public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "02/04/2016",
	time = "18:13:22"
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
new voteCount;
new bool:g_Bool[4];
new bool:g_hasVoted[66];
new Handle:RtvDisableTimer;
public Plugin:myinfo =
{
	name = "Rock the Vote",
	description = "Vote to change map on ND",
	author = "Stickz",
	version = "1.1.2",
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

AddUpdaterLibrary()
{
	return 0;
}

public OnPluginStart()
{
	RegConsoleCmd("sm_rtv", CMD_RockTheVote, "", 0);
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("round_end", Event_RoundEnd, EventHookMode:2);
	LoadTranslations("nd_rockthevote.phrases");
	AddUpdaterLibrary();
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	g_Bool[3] = 1;
	RtvDisableTimer = CreateTimer(480.0, TIMER_DisableRTV, any:0, 2);
	return 0;
}

public Action:OnClientSayCommand(client, String:command[], String:sArgs[])
{
	if (client)
	{
		new var1;
		if (strcmp(sArgs, "rtv", false) && strcmp(sArgs, "change map", false) && strcmp(sArgs, "changemap", false))
		{
			new ReplySource:old = SetCmdReplySource(ReplySource:1);
			callRockTheVote(client);
			SetCmdReplySource(old);
			return Action:4;
		}
	}
	return Action:0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new var1;
	if (!g_Bool[0] && RtvDisableTimer)
	{
		CloseHandle(RtvDisableTimer);
	}
	g_Bool[2] = 1;
	return 0;
}

public OnMapStart()
{
	voteCount = 0;
	g_Bool[0] = 1;
	g_Bool[1] = 0;
	g_Bool[2] = 0;
	g_Bool[3] = 0;
	new client = 1;
	while (client <= MaxClients)
	{
		g_hasVoted[client] = 0;
		client++;
	}
	return 0;
}

public Action:CMD_RockTheVote(client, args)
{
	callRockTheVote(client);
	return Action:3;
}

public OnClientDisconnected(client)
{
	resetValues(client);
	return 0;
}

public Action:TIMER_DisableRTV(Handle:timer)
{
	g_Bool[0] = 0;
	return Action:0;
}

callRockTheVote(client)
{
	new clientCount = ValidClientCount(true);
	if (!g_Bool[0])
	{
		if (clientCount > 8)
		{
			PrintToChat(client, "\x05[xG] %t", "Too Late");
		}
	}
	else
	{
		if (g_Bool[1])
		{
			PrintToChat(client, "\x05[xG] %t!", "Already Passed");
		}
		if (g_hasVoted[client])
		{
			PrintToChat(client, "\x05[xG] %t!", "Already RTVed");
		}
		if (g_Bool[2])
		{
			PrintToChat(client, "\x05[xG] %t!", "Round Ended");
		}
		if (!g_Bool[3])
		{
			PrintToChat(client, "\x05[xG] %t!", "Round Start");
		}
		voteCount += 1;
		g_hasVoted[client] = 1;
		checkForPass(clientCount, true, client);
	}
	return 0;
}

checkForPass(clientCount, bool:display, client)
{
	new Float:countFloat = 0.51 * clientCount;
	new Remainder = RoundToNearest(countFloat) - voteCount;
	if (0 >= Remainder)
	{
		prepMapChange();
	}
	else
	{
		if (display)
		{
			displayVotes(Remainder, client);
		}
	}
	return 0;
}

resetValues(client)
{
	if (g_hasVoted[client])
	{
		g_hasVoted[client] = 0;
		checkForPass(ValidClientCount(true), false, -1);
	}
	return 0;
}

prepMapChange()
{
	g_Bool[1] = 1;
	if (!CanMapChooserStartVote())
	{
		PrintToChatAll("\x05[xG] %t", "RTV Wait");
		CreateTimer(1.0, Timer_DelayMapChange, any:0, 3);
	}
	else
	{
		FiveSecondChange();
	}
	return 0;
}

public Action:Timer_DelayMapChange(Handle:timer)
{
	if (!CanMapChooserStartVote())
	{
		return Action:0;
	}
	FiveSecondChange();
	return Action:4;
}

FiveSecondChange()
{
	ServerCommand("mp_roundtime 1");
	PrintToChatAll("\x05[xG] %t", "RTV Changing");
	return 0;
}

displayVotes(Remainder, client)
{
	decl String:name[64];
	GetClientName(client, name, 64);
	PrintToChatAll("\x05%s typed change map: %s more required.", name, NumberInEnglish(Remainder));
	return 0;
}

