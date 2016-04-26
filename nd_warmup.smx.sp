public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "02/03/2016",
	time = "15:06:11"
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
	name = "[ND] Warmup Round",
	description = "Creates a warmup round on map change",
	author = "Stickz",
	version = "1.0.7",
	url = "N/A"
};
new bool:g_Bool[8];
new g_Integer[2];
new Handle:enableWarmupBalance;
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

ReadyToBalanceCount()
{
	new clientCount;
	new idx = 1;
	while (idx <= MaxClients)
	{
		new var1;
		if (IsValidClient(idx, true) && GetClientTeam(idx) > 0)
		{
			clientCount++;
		}
		idx++;
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
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	HookEvent("round_win", Event_RoundEnd, EventHookMode:0);
	LoadTranslations("nd_warmup.phrases");
	enableWarmupBalance = CreateConVar("sm_warmup_balance", "1", "Warmup Balancer: 0 to disable, 1 to enable", 0, false, 0.0, false, 0.0);
	RegAdminCmd("sm_NextPick", CMD_TriggerPicking, 1, "enable/disable picking for next map", "", 0);
	g_Bool[4] = 0;
	g_Bool[5] = 0;
	g_Bool[6] = 0;
	AddUpdaterLibrary();
	return 0;
}

public OnMapStart()
{
	SetVarDefaults();
	SetMapWarmupTime();
	ServerCommand("bot_quota 0");
	StartWarmupRound();
	CreateLongGameTimer();
	return 0;
}

public OnMapEnd()
{
	InitiateRoundEnd();
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	InitiateRoundEnd();
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	g_Bool[6] = 1;
	if (g_Bool[5])
	{
		ServerCommand("sm_cvar mp_friendlyfire 0");
	}
	else
	{
		ToogleWarmupConvars(0);
	}
	return 0;
}

public Action:TIMER_WarmupRound(Handle:timer)
{
	1252/* ERROR unknown load Constant */--;
	switch (g_Integer[0])
	{
		case 1:
		{
			SetWarmupEndType();
			return Action:4;
		}
		case 3:
		{
			g_Integer[1] = 1;
		}
		case 4:
		{
			ServerCommand("bot_quota 0");
		}
		case 5:
		{
			new var1;
			if (!g_Bool[1] && g_Bool[2] && ReadyToBalanceCount() >= 6)
			{
				new var2 = g_Integer;
				var2[0] = var2[0] + 15;
				g_Bool[1] = 1;
			}
		}
		default:
		{
		}
	}
	DisplayHudText();
	return Action:0;
}

public Action:TIMER_LongGame(Handle:timer)
{
	g_Bool[7] = 1;
	return Action:3;
}

public Action:CMD_TriggerPicking(client, args)
{
	if (args != 1)
	{
		ReplyToCommand(client, "[SM] Usage: !NextPick <on or off>");
		return Action:3;
	}
	new var1;
	if (!g_Bool[6] && g_Bool[5])
	{
		ReplyToCommand(client, "[SM] Cannot disable team picking until after round start.");
		return Action:3;
	}
	decl String:arg1[64];
	GetCmdArg(1, arg1, 64);
	decl String:Name[32];
	GetClientName(client, Name, 32);
	if (StrEqual(arg1, "on", false))
	{
		g_Bool[5] = 1;
		PrintToChatAll("\x05[xG] %s triggered picking game(s) next map!", Name);
	}
	else
	{
		if (StrEqual(arg1, "off", false))
		{
			g_Bool[5] = 0;
			PrintToChatAll("\x05[xG] %s triggered regular game(s) next map!", Name);
		}
		ReplyToCommand(client, "[SM] Usage: !NextPick <on or off>");
		return Action:3;
	}
	return Action:3;
}

bool:RunWarmupBalancer()
{
	new var1;
	if (GetFeatureStatus(FeatureType:0, "WB_BalanceTeams") && g_Bool[2] && g_Bool[3])
	{
		new readyToBalance = ReadyToBalanceCount();
		new var2;
		return readyToBalance >= 8 || readyToBalance == 6;
	}
	return false;
}

DisplayHudText()
{
	new Handle:HudText = CreateHudSynchronizer();
	SetHudTextParams(-1.0, 0.4, 1.0, 220, 20, 60, 255, 0, 6.0, 0.1, 0.2);
	decl String:hudTXT[32];
	switch (g_Integer[1])
	{
		case 0, 1:
		{
			Format(hudTXT, 32, "%t", "Waiting");
		}
		case 2:
		{
			Format(hudTXT, 32, "%t...", "Please Wait");
		}
		default:
		{
		}
	}
	new idx = 1;
	while (idx <= MaxClients)
	{
		if (IsClientInGame(idx))
		{
			ShowSyncHudText(idx, HudText, "%s", hudTXT);
		}
		idx++;
	}
	CloseHandle(HudText);
	return 0;
}

SetWarmupEndType()
{
	if (g_Bool[5])
	{
		ServerCommand("sm_cvar sv_alltalk 0");
		PrintToAdmins("\x05[xG] Team Picking is now availible!", "b");
	}
	else
	{
		if (RunWarmupBalancer())
		{
			WB_BalanceTeams();
		}
		StartRound();
	}
	return 0;
}

InitiateRoundEnd()
{
	if (!g_Bool[0])
	{
		g_Bool[0] = 1;
		ServerCommand("mp_minplayers 32");
		g_Bool[4] = ValidClientCount() < 4;
		g_Bool[6] = 0;
		ServerCommand("sm_cvar sv_alltalk 1");
	}
	return 0;
}

CreateLongGameTimer()
{
	new time = 2700;
	CreateTimer(float(time), TIMER_LongGame, any:0, 2);
	return 0;
}

StartWarmupRound()
{
	CreateTimer(1.0, TIMER_WarmupRound, any:0, 3);
	ToogleWarmupConvars(1);
	return 0;
}

SetMapWarmupTime()
{
	new var1;
	if (g_Bool[4])
	{
		var1 = 15;
	}
	else
	{
		var1 = 45;
	}
	g_Integer[0] = var1;
	decl String:currentMap[32];
	GetCurrentMap(currentMap, 32);
	new var2;
	if (StrContains(currentMap, "rock", false) && StrEqual(currentMap, "roadwork_w01", false) && StrContains(currentMap, "corner", false) && StrContains(currentMap, "frost", false) && StrContains(currentMap, "metro_imp", false) && StrContains(currentMap, "nuclear_forest", false))
	{
		new var3 = g_Integer;
		var3[0] = var3[0] + 15;
		if (g_Bool[7])
		{
			new var4 = g_Integer;
			var4[0] = var4[0] + 15;
		}
	}
	else
	{
		if (g_Bool[7])
		{
			new var5 = g_Integer;
			var5[0] = var5[0] + 30;
			g_Bool[7] = 0;
		}
	}
	return 0;
}

StartRound()
{
	ServerCommand("mp_minplayers 1");
	PrintToChatAll("\x05[TB] %t", "Balancer Off");
	return 0;
}

SetVarDefaults()
{
	g_Bool[0] = 0;
	g_Bool[1] = 0;
	g_Bool[2] = 1;
	g_Bool[7] = 0;
	g_Bool[3] = GetConVarBool(enableWarmupBalance);
	g_Integer[1] = 0;
	return 0;
}

ToogleWarmupConvars(value)
{
	ServerCommand("sm_cvar sv_alltalk %d", value);
	ServerCommand("sm_cvar mp_friendlyfire %d", value);
	return 0;
}

