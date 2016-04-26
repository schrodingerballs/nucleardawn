public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "03/05/2016",
	time = "19:51:02"
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
public SharedPlugin:__pl_balancer =
{
	name = "nd_balance",
	file = "nd_team_balancer.smx",
	required = 0,
};
public Plugin:myinfo =
{
	name = "[ND] Dynamic Sever Slots",
	description = "Controls server slots by map and reserved",
	author = "Stickz",
	version = "1.0.5",
	url = "N/A"
};
new String:nd_donator_players[14][80] =
{
	"STEAM_1:0:7181974",
	"STEAM_1:1:6054662",
	"STEAM_1:0:16654629",
	"STEAM_1:0:15404626",
	"STEAM_1:0:26518082",
	"STEAM_1:0:33349943",
	"STEAM_1:1:64900059",
	"STEAM_1:0:33657626",
	"STEAM_1:1:22680603",
	"STEAM_1:0:58794469",
	"STEAM_1:0:2324797",
	"STEAM_1:1:26929916",
	"STEAM_1:0:53362273",
	"STEAM_0:1:24162803"
};
new g_Integer[2];
new g_Bool[5];
new Handle:g_Cvar[4];
new bool:g_isDonator[66];
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

RoundFloat(Float:value)
{
	return RoundToNearest(value);
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
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

public __pl_balancer_SetNTVOptional()
{
	MarkNativeAsOptional("GetAverageSkill");
	MarkNativeAsOptional("WB_BalanceTeams");
	MarkNativeAsOptional("RefreshTBCache");
	return 0;
}

AddUpdaterLibrary()
{
	return 0;
}

public OnPluginStart()
{
	HookEvent("round_win", Event_RoundEnd, EventHookMode:0);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("timeleft_1m", Event_TimeOneMinute, EventHookMode:2);
	RegAdminCmd("sm_BoostSlots", Command_BoostSlots, 4, "Boosts the server slots by two", "", 0);
	RegAdminCmd("sm_ClampSlots", Command_ClampSlots, 4, "Sets the server slots a specified value", "", 0);
	g_Cvar[0] = CreateConVar("sm_serverslots_max", "32", "Set Maximum  slots", 0, false, 0.0, false, 0.0);
	g_Cvar[1] = CreateConVar("sm_serverslots_hskill", "85", "Set the skill to decrease slots", 0, false, 0.0, false, 0.0);
	g_Cvar[2] = CreateConVar("sm_serverslots_lskill", "65", "Set the skill to decrease slots", 0, false, 0.0, false, 0.0);
	g_Cvar[3] = CreateConVar("sm_serverslots_pmin", "14", "Set min amount of players to decrease slots", 0, false, 0.0, false, 0.0);
	LoadTranslations("nd_managed_slots.phrases");
	AddUpdaterLibrary();
	InitializeVariables();
	CreateTimer(5.0, TIMER_SetAfkKickPlayers, any:0, 2);
	AutoExecConfig(true, "nd_server_slots", "sourcemod");
	SignalFirstMap();
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	g_Bool[1] = 0;
	return 0;
}

public OnClientPutInServer(client)
{
	new var1;
	if (g_Bool[0] && g_isDonator[client])
	{
		PrintToChat(client, "\x05[xG] %t!", "Slot Used");
		g_Bool[0] = 0;
	}
	return 0;
}

public OnClientAuthorized(client)
{
	if (!IsFakeClient(client))
	{
		new var1;
		if (GetClientCount(false) >= g_Integer[0] && g_Bool[2])
		{
			decl String:gAuth[32];
			GetClientAuthId(client, AuthIdType:1, gAuth, 32, true);
			g_isDonator[client] = HasReversedSlot(gAuth);
			if (!g_isDonator[client])
			{
				KickClient(client, "%t", "Donors Only");
			}
			else
			{
				1708/* ERROR unknown load Constant */++;
				g_Bool[0] = 1;
			}
		}
	}
	return 0;
}

public OnClientDisconnect(client)
{
	g_isDonator[client] = 0;
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!g_Bool[1])
	{
		InitiateRoundEnd();
	}
	return 0;
}

public Event_TimeOneMinute(Handle:event, String:name[], bool:dontBroadcast)
{
	new NextMapCount = GetNextMapCount();
	if (g_Integer[1] <= NextMapCount)
	{
		BoostServerSlots(-1);
		if (g_Integer[1] + 2 <= NextMapCount)
		{
			CreateTimer(30.0, TIMER_DoubleBoostCount, any:0, 2);
		}
	}
	return 0;
}

public Event_PlayerDisconnected(Handle:event, String:name[], bool:dontBroadcast)
{
	decl String:steam_id[32];
	GetEventString(event, "networkid", steam_id, 32);
	if (!(strncmp(steam_id, "STEAM_", 6, true)))
	{
		if (g_Integer[1] < g_Integer[0])
		{
			1708/* ERROR unknown load Constant */--;
		}
	}
	return 0;
}

public Action:TIMER_SetNextMapCount(Handle:timer)
{
	SetNextMapCount();
	return Action:3;
}

public Action:TIMER_DoubleBoostCount(Handle:timer)
{
	if (!g_Bool[1])
	{
		BoostServerSlots(-1);
	}
	return Action:3;
}

public Action:Command_BoostSlots(client, args)
{
	if (g_Integer[1] > 30)
	{
		ReplyToCommand(client, "Error: You cannot boost slots past 32");
		return Action:3;
	}
	if (g_Bool[3])
	{
		ReplyToCommand(client, "Error: You may only boost slots once");
		return Action:3;
	}
	BoostServerSlots(client);
	return Action:3;
}

public Action:Command_ClampSlots(client, args)
{
	if (args != 1)
	{
		ReplyToCommand(client, "Ussage: !ClampSlots <count>");
		return Action:3;
	}
	decl String:slot_count[64];
	GetCmdArg(1, slot_count, 64);
	new slots = StringToInt(slot_count, 10);
	if (slots > 32)
	{
		ReplyToCommand(client, "Error: Cannot clamp slots above 32");
		return Action:3;
	}
	if (slots < 16)
	{
		ReplyToCommand(client, "Error: Cannot clamp slots bellow 16");
		return Action:3;
	}
	setMapPlayerCount(slots);
	PrintToChat(client, "\x05[xG] Server slots successfully clamped!");
	return Action:3;
}

BoostServerSlots(client)
{
	g_Integer[1] += 2;
	if (g_Integer[1] > g_Integer[0])
	{
		g_Integer[0] = g_Integer[1];
	}
	g_Bool[3] = 1;
	ServerCommand("sv_visiblemaxplayers %d", 1708 + 4);
	ServerCommand("sm_cvar sm_afk_kick_min_players %d", g_Integer[1] + -3);
	if (client != -1)
	{
		PrintToChat(client, "\x05[xG] Server slots successfully boosted!");
	}
	return 0;
}

SignalFirstMap()
{
	g_Bool[4] = 1;
	decl String:currentMap[64];
	GetCurrentMap(currentMap, 64);
	GetMapPlayerCount(currentMap);
	return 0;
}

InitiateRoundEnd()
{
	g_Bool[1] = 1;
	CreateTimer(1.5, TIMER_SetNextMapCount, any:0, 2);
	return 0;
}

InitializeVariables()
{
	g_Integer[0] = 30;
	g_Integer[1] = 30;
	g_Bool[0] = 0;
	g_Bool[2] = 1;
	g_Bool[3] = 0;
	return 0;
}

SetNextMapCount()
{
	new PlayerCount = GetNextMapCount();
	setMapPlayerCount(PlayerCount);
	return 0;
}

setMapPlayerCount(cap)
{
	new newCap = cap;
	new maxSlots = GetConVarInt(g_Cvar[0]);
	if (newCap > maxSlots)
	{
		newCap = maxSlots;
	}
	new var1;
	if (g_Integer[0] > newCap)
	{
		var1 = g_Integer[0];
	}
	else
	{
		var1 = newCap;
	}
	g_Integer[0] = var1;
	g_Integer[1] = newCap;
	ServerCommand("sv_visiblemaxplayers %d", newCap);
	ServerCommand("sm_cvar sm_afk_kick_min_players %d", newCap + -3);
	g_Bool[3] = 0;
	return 0;
}

GetNextMapCount()
{
	decl String:nextMap[32];
	GetNextMap(nextMap, 32);
	return GetMapPlayerCount(nextMap);
}

GetMapPlayerCount(String:checkMap[])
{
	if (StrEqual(checkMap, "oilfield", false))
	{
		return GetSlotCount(28, 30, 32);
	}
	new var1;
	if (StrEqual(checkMap, "clocktower", false) || StrEqual(checkMap, "downtown", false) || StrEqual(checkMap, "gate", false) || StrContains(checkMap, "rock", false))
	{
		return GetSlotCount(26, 28, 30);
	}
	new var2;
	if (StrContains(checkMap, "corner", false) && StrContains(checkMap, "mars", false) && StrContains(checkMap, "sandbrick", false) && StrContains(checkMap, "port", false))
	{
		return GetSlotCount(20, 22, 24);
	}
	return GetSlotCount(24, 26, 28);
}

GetSlotCount(min, med, max)
{
	new var1;
	if (!GetFeatureStatus(FeatureType:0, "GetAverageSkill") == 0 || eSkillBasedSlots() || g_Bool[4])
	{
		if (g_Bool[4])
		{
			g_Bool[4] = 0;
		}
		return max;
	}
	new avSkill = RoundFloat(GetAverageSkill());
	new hSkill = GetConVarInt(g_Cvar[1]);
	new lSkill = GetConVarInt(g_Cvar[2]);
	new var2;
	if (avSkill < lSkill)
	{
		var2 = max;
	}
	else
	{
		if (avSkill < hSkill)
		{
			var2 = med;
		}
		var2 = min;
	}
	return var2;
}

bool:eSkillBasedSlots()
{
	return ValidClientCount(false) < GetConVarInt(g_Cvar[3]);
}

bool:HasReversedSlot(String:gAuth[])
{
	new id;
	while (id <= 13)
	{
		if (StrEqual(nd_donator_players[id], gAuth, false))
		{
			return true;
		}
		id++;
	}
	return false;
}

public Action:TIMER_SetAfkKickPlayers(Handle:timer)
{
	ServerCommand("sm_cvar sm_afk_kick_min_players 24");
	return Action:3;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("ToggleDynamicSlots", Native_ToggleDynamicSlots);
	CreateNative("GetDynamicSlotStatus", Native_GetDynamicSlotStatus);
	CreateNative("GetDynamicSlotCount", Native_GetDynamicSlotCount);
	return APLRes:0;
}

public Native_ToggleDynamicSlots(Handle:plugin, numParams)
{
	new bool:state = GetNativeCell(1);
	new var1;
	if (state)
	{
		var1 = g_Integer[1];
	}
	else
	{
		var1 = 32;
	}
	ServerCommand("sv_visiblemaxplayers %d", var1);
	g_Bool[2] = state;
	return 0;
}

public Native_GetDynamicSlotStatus(Handle:plugin, numParams)
{
	return g_Bool[2];
}

public Native_GetDynamicSlotCount(Handle:plugin, numParams)
{
	return g_Integer[1];
}

