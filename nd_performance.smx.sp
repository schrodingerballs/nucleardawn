public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "11/04/2015",
	time = "00:14:43"
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
new Handle:cvarDecreaseBandwidth;
new bool:g_ratesDecreased = 1;
new bool:g_roundStarted;
new DecreaseValue;
public Plugin:myinfo =
{
	name = "[ND] Performance Tweaks",
	description = "Reduces bandwidth with higher player counts",
	author = "Stickz",
	version = "1.0.7",
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

bool:IsValidAdmin(client, String:flags[])
{
	new ibFlags = ReadFlagString(flags, 0);
	new var1;
	return ibFlags != ibFlags & GetUserFlagBits(client) && GetUserFlagBits(client) & 16384;
}

PrintToAdmins(String:message[], String:flags[])
{
	new x = 1;
	while (x <= MaxClients)
	{
		new var1;
		if (IsValidClient(x, true) && IsValidAdmin(x, flags))
		{
			PrintToChat(x, message);
		}
		x++;
	}
	return 0;
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

public __pl_slot_SetNTVOptional()
{
	MarkNativeAsOptional("ToggleDynamicSlots");
	MarkNativeAsOptional("GetDynamicSlotStatus");
	return 0;
}

AddUpdaterLibrary()
{
	return 0;
}

public OnPluginStart()
{
	cvarDecreaseBandwidth = CreateConVar("sm_decreaserates", "24", "set count to decrease bandwidth", 0, false, 0.0, false, 0.0);
	HookConVarChange(cvarDecreaseBandwidth, OnDecreaseChanged);
	DecreaseValue = GetConVarInt(cvarDecreaseBandwidth);
	AddCommandListener(PlayerJoinTeam, "jointeam");
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("round_win", Event_RoundEnd, EventHookMode:0);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	AddUpdaterLibrary();
	return 0;
}

public OnDecreaseChanged(Handle:cvar, String:oldVal[], String:newVal[])
{
	DecreaseValue = GetConVarInt(cvarDecreaseBandwidth);
	return 0;
}

public OnPluginEnd()
{
	setHighRates();
	return 0;
}

public OnClientDisconnect_Post(client)
{
	checkRates();
	return 0;
}

public Action:PlayerJoinTeam(client, String:command[], argc)
{
	new var1;
	if (IsValidClient(client, true) && GetClientTeam(client) < 2)
	{
		checkRates();
	}
	return Action:0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	g_roundStarted = true;
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	if (g_roundStarted)
	{
		g_roundStarted = false;
	}
	return 0;
}

checkRates()
{
	if (g_roundStarted)
	{
		new TeamCount = OnTeamCount();
		decl bool:BotsAreEnabled;
		new var1;
		BotsAreEnabled = GetFeatureStatus(FeatureType:0, "GetDynamicSlotStatus") && !GetDynamicSlotStatus();
		new var3;
		if (!g_ratesDecreased && (TeamCount >= DecreaseValue || BotsAreEnabled))
		{
			setLowRates();
		}
		else
		{
			new var4;
			if (g_ratesDecreased && TeamCount < DecreaseValue && !BotsAreEnabled)
			{
				setHighRates();
			}
		}
	}
	return 0;
}

setHighRates()
{
	ServerCommand("sv_minupdaterate 61");
	ServerCommand("sv_mincmdrate 61");
	ServerCommand("sv_client_max_interp_ratio 1");
	ServerCommand("fps_max 1000");
	g_ratesDecreased = false;
	PrintToAdmins("Networking Rates Increased", "b");
	return 0;
}

setLowRates()
{
	ServerCommand("sv_minupdaterate 33");
	ServerCommand("sv_mincmdrate 33");
	ServerCommand("sv_client_max_interp_ratio 2");
	ServerCommand("fps_max 80");
	g_ratesDecreased = true;
	PrintToAdmins("Networking Rates Reduced", "b");
	return 0;
}

