public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "03/10/2016",
	time = "16:57:03"
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
public SharedPlugin:__pl_slot =
{
	name = "nd_slot",
	file = "nd_managed_slots.smx",
	required = 0,
};
new bool:roundGoing;
new bool:visibleBoosted;
new bool:hasSignaled;
new g_cvar[6];
public Plugin:myinfo =
{
	name = "Bot Features",
	description = "Give more control over the bots on the server",
	author = "Stickz",
	version = "1.2.8",
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

OnTeamCount()
{
	new clientCount;
	new idx = 1;
	while (idx <= MaxClients)
	{
		new var1;
		if (IsValidClient(idx, true) && GetClientTeam(idx) > 1)
		{
			clientCount++;
		}
		idx++;
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

getOverBalance()
{
	new clientCount[2];
	new team;
	new idx = 1;
	while (idx <= MaxClients)
	{
		if (IsValidClient(idx, true))
		{
			team = GetClientTeam(idx);
			if (team > 1)
			{
				clientCount[team + -2]++;
			}
		}
		idx++;
	}
	return clientCount[1] - clientCount[0];
}

getPositiveOverBalance()
{
	new overBalance = getOverBalance();
	if (0 > overBalance)
	{
		overBalance *= -1;
	}
	return overBalance;
}

public __pl_slot_SetNTVOptional()
{
	MarkNativeAsOptional("ToggleDynamicSlots");
	MarkNativeAsOptional("GetDynamicSlotStatus");
	MarkNativeAsOptional("GetDynamicSlotCount");
	return 0;
}

AddUpdaterLibrary()
{
	return 0;
}

public OnClientDisconnect_Post(client)
{
	checkCount();
	return 0;
}

public OnPluginStart()
{
	g_cvar[1] = CreateConVar("sm_boost_bots", "1", "0 to disable, 1 to enable (server count - 2 bots)", 0, false, 0.0, false, 0.0);
	g_cvar[0] = CreateConVar("sm_botcount", "20", "sets the regular bot count.", 0, false, 0.0, false, 0.0);
	g_cvar[2] = CreateConVar("sm_booster_bot_quota", getMaxPlayersMinus(2), "sets the bota bot quota", 0, false, 0.0, false, 0.0);
	g_cvar[3] = CreateConVar("sm_disable_bots_at", "8", "sets when disable bots", 0, false, 0.0, false, 0.0);
	g_cvar[4] = CreateConVar("sm_bot_overbalance", "3", "sets team difference allowed with bots enabled", 0, false, 0.0, false, 0.0);
	g_cvar[5] = CreateConVar("sm_reg_overbalance", "1", "sets team difference allowed with bots disabled", 0, false, 0.0, false, 0.0);
	HookConVarChange(g_cvar[1], OnBotBoostChange);
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	AddCommandListener(PlayerJoinTeam, "jointeam");
	HookEvent("round_win", Event_RoundEnd, EventHookMode:0);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	AddUpdaterLibrary();
	AutoExecConfig(true, "nd_bot_features", "sourcemod");
	return 0;
}

public OnMapEnd()
{
	if (!hasSignaled)
	{
		SignalMapChange();
	}
	hasSignaled = false;
	return 0;
}

public OnBotBoostChange(Handle:convar, String:oldValue[], String:newValue[])
{
	new var1;
	if ((!GetConVarBool(convar) && visibleBoosted) || (GetConVarBool(convar) && !visibleBoosted && OnTeamCount() < GetConVarInt(g_cvar[3])))
	{
		if (!(GetFeatureStatus(FeatureType:0, "ToggleDynamicSlots")))
		{
			ToggleDynamicSlots(visibleBoosted);
			visibleBoosted = GetConVarBool(convar);
		}
	}
	return 0;
}

public Action:PlayerJoinTeam(client, String:command[], argc)
{
	if (IsValidClient(client, true))
	{
		CreateTimer(0.1, TIMER_CC, any:0, 2);
	}
	return Action:0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	SignalMapChange();
	return 0;
}

checkCount()
{
	if (roundGoing)
	{
		new quota;
		new teamCount = OnTeamCount();
		if (GetConVarInt(g_cvar[3]) > teamCount)
		{
			new var1;
			if (GetConVarBool(g_cvar[1]) && GetFeatureStatus(FeatureType:0, "ToggleDynamicSlots"))
			{
				quota = getUnassignedAdjustment() + quota;
				if (!visibleBoosted)
				{
					toggleBooster(true, true);
				}
				CreateTimer(0.1, TIMER_CBK, quota, 2);
			}
			else
			{
				quota = GetConVarInt(g_cvar[0]) + quota;
				ServerCommand("mp_limitteams %d", GetConVarInt(g_cvar[4]));
			}
		}
		else
		{
			new bool:excludeSpecs = ValidClientCount(true) < GetDynamicSlotCount() + -2;
			quota = getTeamDiff(teamCount, !excludeSpecs, excludeSpecs);
			if (ValidTeamCount(2) == ValidTeamCount(3))
			{
				quota = 0;
			}
			else
			{
				new var2;
				if (GetFeatureStatus(FeatureType:0, "GetDynamicSlotCount") && quota >= GetDynamicSlotCount() + -2 && getPositiveOverBalance() >= 3)
				{
					quota = getTeamDiff(teamCount, true, false);
					if (!visibleBoosted)
					{
						toggleBooster(true, false);
					}
				}
				if (visibleBoosted)
				{
					toggleBooster(false, true);
				}
			}
		}
		ServerCommand("bot_quota %d", quota);
	}
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	roundGoing = true;
	new quota;
	new var1;
	if (GetConVarBool(g_cvar[1]) && GetFeatureStatus(FeatureType:0, "ToggleDynamicSlots"))
	{
		if (GetConVarInt(g_cvar[3]) > OnTeamCount())
		{
			if (!visibleBoosted)
			{
				toggleBooster(true, true);
			}
			quota = getUnassignedAdjustment();
		}
	}
	else
	{
		quota = GetConVarInt(g_cvar[0]);
	}
	ServerCommand("bot_quota %d", quota);
	return 0;
}

public Action:TIMER_CBK(Handle:timer, any:quota)
{
	CheckBotKick(quota);
	return Action:3;
}

public Action:TIMER_CC(Handle:timer)
{
	checkCount();
	return Action:3;
}

toggleBooster(bool:state, bool:teamCaps)
{
	visibleBoosted = state;
	if (!(GetFeatureStatus(FeatureType:0, "ToggleDynamicSlots")))
	{
		ToggleDynamicSlots(!state);
	}
	if (teamCaps)
	{
		new var1;
		if (state)
		{
			var1 = GetConVarInt(g_cvar[4]);
		}
		else
		{
			var1 = GetConVarInt(g_cvar[5]);
		}
		ServerCommand("mp_limitteams %d", var1);
	}
	return 0;
}

CheckBotKick(quota)
{
	new empCount = GetTeamClientCount(3);
	new ctCount = GetTeamClientCount(2);
	new difference = empCount - ctCount;
	if (difference > 1)
	{
		ServerCommand("bot_quota %d", quota - difference);
	}
	else
	{
		if (difference < -1)
		{
			difference *= -1;
			ServerCommand("bot_quota %d", quota - difference);
		}
	}
	return 0;
}

SignalMapChange()
{
	roundGoing = false;
	if (visibleBoosted)
	{
		toggleBooster(false, true);
	}
	ServerCommand("bot_quota 0");
	hasSignaled = true;
	return 0;
}

getTeamDiff(teamCount, bool:excludeSpectators, bool:addSpectators)
{
	new overbalance = getOverBalance();
	new spectatorCount = ValidTeamCount(1);
	if (0 > overbalance)
	{
		overbalance *= -1;
	}
	new total = overbalance + teamCount + -1;
	if (addSpectators)
	{
		total = spectatorCount + total;
	}
	if (excludeSpectators)
	{
		total -= spectatorCount;
	}
	return total;
}

getUnassignedAdjustment()
{
	new NotAssignedCount = ValidTeamCount(0);
	new specCount = ValidTeamCount(1);
	new toSubtract;
	switch (NotAssignedCount)
	{
		case 0, 1:
		{
			toSubtract = 0;
		}
		case 2, 3:
		{
			toSubtract = 2;
		}
		default:
		{
			toSubtract = 4;
		}
	}
	new var1;
	if (specCount % 2)
	{
		var1 = 1;
	}
	else
	{
		var1 = 2;
	}
	specCount = var1;
	return GetConVarInt(g_cvar[2]) - specCount - toSubtract;
}

String:getMaxPlayersMinus(size, _arg1)
{
	new String:maxMinus[4];
	Format(maxMinus, 4, "%d", 32 - size);
	return maxMinus;
}

