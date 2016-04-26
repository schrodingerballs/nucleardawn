public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "02/28/2016",
	time = "22:49:25"
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
public Plugin:myinfo =
{
	name = "[ND] Bot Slaying",
	description = "Allows killing of bots on a particular team",
	author = "Stickz",
	version = "1.0.2",
	url = "N/A"
};
new bool:CanKillBots[2] =
{
	1, ...
};
new bool:BotsReset;
new bool:RoundStarted;
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

bool:IsValidClient(client, bool:nobots)
{
	new var2;
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
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
	RegisterCommands();
	AddUpdaterLibrary();
	HookEvents();
	return 0;
}

public OnMapEnd()
{
	ResetKillBots();
	RoundStarted = false;
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	RoundStarted = true;
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	ResetKillBots();
	RoundStarted = false;
	return 0;
}

public Action:CMD_KillBots(client, args)
{
	if (!RoundStarted)
	{
		ReplyToCommand(client, "[SM] This command requires the round to be running!");
		return Action:3;
	}
	if (!NDC_IsCommander(client))
	{
		ReplyToCommand(client, "[SM] This command for commanders only!");
		return Action:3;
	}
	new team = GetClientTeam(client);
	if (!CanKillBots[team + -2])
	{
		ReplyToCommand(client, "[SM] This has a five minute cooldown!");
		return Action:3;
	}
	CreateCooldown(team);
	PerformKillBots(team);
	return Action:3;
}

public Action:CMD_AdminKillBots(client, args)
{
	if (!RoundStarted)
	{
		ReplyToCommand(client, "[SM] This command requires the round to be running!");
		return Action:3;
	}
	if (!args)
	{
		ReplyToCommand(client, "Usage: sm_aKillBots <empire/consort>");
		return Action:3;
	}
	decl String:teamArg[16];
	GetCmdArg(1, teamArg, 16);
	new team;
	if (StrContains(teamArg, "emp", false) > -1)
	{
		team = 3;
	}
	else
	{
		if (StrContains(teamArg, "con", false) > -1)
		{
			team = 2;
		}
		ReplyToCommand(client, "Invalid team name.");
		return Action:3;
	}
	PerformKillBots(team);
	return Action:3;
}

public Action:Timer_EnableBotKill(Handle:timer, any:team)
{
	CanKillBots[team + -2] = 1;
	return Action:0;
}

PerformKillBots(team)
{
	new client = 1;
	while (client <= MaxClients)
	{
		new var1;
		if (IsValidClient(client, false) && IsFakeClient(client) && IsPlayerAlive(client) && team == GetClientTeam(client))
		{
			ForcePlayerSuicide(client);
		}
		client++;
	}
	return 0;
}

CreateCooldown(team)
{
	CanKillBots[team + -2] = 0;
	CreateTimer(300.0, Timer_EnableBotKill, team, 2);
	return 0;
}

ResetKillBots()
{
	if (!BotsReset)
	{
		CanKillBots[0] = 1;
		CanKillBots[1] = 1;
		BotsReset = true;
	}
	return 0;
}

RegisterCommands()
{
	RegConsoleCmd("sm_KillBots", CMD_KillBots, "Allows a commander to kill their bots", 0);
	RegAdminCmd("sm_aKillBots", CMD_AdminKillBots, 4, "Allows a command to kill bots on a team", "", 0);
	return 0;
}

HookEvents()
{
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("round_end", Event_RoundEnd, EventHookMode:2);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	return 0;
}

