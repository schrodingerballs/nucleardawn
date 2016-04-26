public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "03/02/2016",
	time = "22:52:48"
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
public SharedPlugin:__pl_commander =
{
	name = "nd_commander",
	file = "nd_commander_restrictions.smx",
	required = 0,
};
public Extension:__ext_cprefs =
{
	name = "Client Preferences",
	file = "clientprefs.ext",
	autoload = 1,
	required = 1,
};
new Handle:hSuicideDelay;
new bool:roundStarted;
new Handle:cookie_solution_assist;
new bool:option_solution_assist[66] =
{
	1, ...
};
new String:nd_kill_commands[6][0];
new String:nd_respawn_commands[6][0];
public Plugin:myinfo =
{
	name = "ND Useful Tols",
	description = "Provides useful tools for nuclear dawn",
	author = "stickz",
	version = "1.1.2",
	url = "xenogamers.com"
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

String:GetTransNumber(value, _arg1)
{
	new String:number[32];
	switch (value)
	{
		case 1:
		{
			Format(number, 32, "%t", "one");
		}
		case 2:
		{
			Format(number, 32, "%t", "two");
		}
		case 3:
		{
			Format(number, 32, "%t", "three");
		}
		case 4:
		{
			Format(number, 32, "%t", "four");
		}
		case 5:
		{
			Format(number, 32, "%t", "five");
		}
		case 6:
		{
			Format(number, 32, "%t", "six");
		}
		case 7:
		{
			Format(number, 32, "%t", "seven");
		}
		case 8:
		{
			Format(number, 32, "%t", "eight");
		}
		case 9:
		{
			Format(number, 32, "%t", "nine");
		}
		case 10:
		{
			Format(number, 32, "%t", "ten");
		}
		case 11:
		{
			Format(number, 32, "%t", "eleven");
		}
		case 12:
		{
			Format(number, 32, "%t", "twelve");
		}
		default:
		{
		}
	}
	return number;
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
	RegConsoleCmd("sm_kill", Command_killme, "", 0);
	RegConsoleCmd("sm_die", Command_killme, "", 0);
	RegConsoleCmd("sm_suicide", Command_killme, "", 0);
	RegConsoleCmd("sm_stuck", Command_killme, "", 0);
	RegServerCmd("quit", OnDown, "", 0);
	AddCommandListener(Command_InterceptSuicide, "kill");
	hSuicideDelay = CreateConVar("sm_suicide_delay", "3", "set suicide delay between 0-8 seconds.", 0, false, 0.0, false, 0.0);
	cookie_solution_assist = RegClientCookie("Solution Assist On/Off", "", CookieAccess:1);
	new info;
	SetCookieMenuItem(CookieMenuHandler_SolutionAssist, info, "Solution Assist");
	LoadTranslations("common.phrases");
	AddUpdaterLibrary();
	LoadTranslations("nd_tools.phrases");
	LoadTranslations("numbers.phrases");
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	return 0;
}

public OnMapStart()
{
	roundStarted = false;
	return 0;
}

public Action:Command_killme(client, args)
{
	commitSucide(client);
	return Action:3;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	roundStarted = true;
	return 0;
}

public Action:OnDown(args)
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			ClientCommand(i, "retry");
		}
		i++;
	}
	return Action:0;
}

public Action:OnClientSayCommand(client, String:command[], String:sArgs[])
{
	if (client)
	{
		if (!option_solution_assist[client])
		{
			return Action:0;
		}
		if (GetClientTeam(client) > 1)
		{
			new idx;
			while (idx < 6)
			{
				if (strcmp(sArgs, nd_kill_commands[idx], false))
				{
					if (StrContains(sArgs, nd_respawn_commands[idx], false) > -1)
					{
						new ReplySource:old = SetCmdReplySource(ReplySource:1);
						PrintToChat(client, "\x05[xG] %t!", "Spawn Bug");
						SetCmdReplySource(old);
						return Action:4;
					}
					idx++;
				}
				new ReplySource:old = SetCmdReplySource(ReplySource:1);
				commitSucide(client);
				SetCmdReplySource(old);
				return Action:4;
			}
		}
	}
	return Action:0;
}

public Action:Command_InterceptSuicide(client, String:command[], args)
{
	if (client)
	{
		if (GetClientTeam(client) > 1)
		{
			commitSucide(client);
			return Action:3;
		}
	}
	return Action:0;
}

commitSucide(client)
{
	if (IsPlayerAlive(client))
	{
		new delay = GetConVarInt(hSuicideDelay);
		new var1;
		if (delay && NDC_IsCommander(client) && !roundStarted)
		{
			ForcePlayerSuicide(client);
			return 0;
		}
		PrintToChat(client, "\x05[xG] %t", "Suicide Request", GetTransNumber(delay));
		CreateTimer(float(delay), TIMER_DelayedSucide, GetClientUserId(client), 2);
	}
	return 0;
}

public Action:TIMER_DelayedSucide(Handle:timer, any:Userid)
{
	new client = GetClientOfUserId(Userid);
	if (client)
	{
		if (IsPlayerAlive(client))
		{
			ForcePlayerSuicide(client);
		}
		return Action:3;
	}
	return Action:3;
}

public CookieMenuHandler_SolutionAssist(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	switch (action)
	{
		case 0:
		{
			decl String:status[12];
			new var2;
			if (option_solution_assist[client])
			{
				var2[0] = 2228;
			}
			else
			{
				var2[0] = 2232;
			}
			Format(status, 10, "%T", var2, client);
			Format(buffer, maxlen, "%T: %s", "Cookie Solution Assist", client, status);
		}
		case 1:
		{
			option_solution_assist[client] = !option_solution_assist[client];
			new var1;
			if (option_solution_assist[client])
			{
				var1[0] = 2268;
			}
			else
			{
				var1[0] = 2272;
			}
			SetClientCookie(client, cookie_solution_assist, var1);
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
	option_solution_assist[client] = GetCookieSolutionAssist(client);
	return 0;
}

bool:GetCookieSolutionAssist(client)
{
	decl String:buffer[12];
	GetClientCookie(client, cookie_solution_assist, buffer, 10);
	return !StrEqual(buffer, "Off", true);
}

