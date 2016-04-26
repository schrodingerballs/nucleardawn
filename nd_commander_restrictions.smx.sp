public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "02/25/2016",
	time = "14:49:00"
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
public SharedPlugin:__pl_sourcecomms =
{
	name = "sourcecomms",
	file = "sourcecomms.smx",
	required = 0,
};
public SharedPlugin:__pl_balancer =
{
	name = "nd_balance",
	file = "nd_team_balancer.smx",
	required = 0,
};
public Plugin:myinfo =
{
	name = "[ND] Commander Restrictions",
	description = "Sets conditions for players to apply for commander",
	author = "Stickz",
	version = "1.2.1",
	url = "N/A"
};
new voteCount[2];
new g_cvar[9];
new bool:g_Bool[5];
new bool:g_hasEnteredBunker[2];
new bool:g_hasVoted[2][66];
new bool:g_hasBeenDemoted[66];
new bool:g_hasResigned[66];
new bool:g_isCommander[66];
new commander[2];
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

bool:operator>(_:,Float:)(oper1, Float:oper2)
{
	return float(oper1) > oper2;
}

bool:operator<(Float:,_:)(Float:oper1, oper2)
{
	return oper1 < float(oper2);
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

RetreiveLevel(client, PlayerManEnt)
{
	decl PlayerManager;
	new var1;
	if (PlayerManEnt != -1)
	{
		var1 = PlayerManEnt;
	}
	else
	{
		var1 = FindEntityByClassname(-1, "nd_player_manager");
	}
	PlayerManager = var1;
	return GetEntProp(PlayerManager, PropType:0, "m_iPlayerRank", 1, client);
}

bool:IsSourceCommSilenced(client)
{
	new var1;
	return GetFeatureStatus(FeatureType:0, "SourceComms_GetClientMuteType") && SourceComms_GetClientMuteType(client) && SourceComms_GetClientGagType(client);
}

public __pl_sourcecomms_SetNTVOptional()
{
	MarkNativeAsOptional("SourceComms_SetClientMute");
	MarkNativeAsOptional("SourceComms_SetClientGag");
	MarkNativeAsOptional("SourceComms_GetClientMuteType");
	MarkNativeAsOptional("SourceComms_GetClientGagType");
	return 0;
}

public __pl_balancer_SetNTVOptional()
{
	MarkNativeAsOptional("GetAverageSkill");
	MarkNativeAsOptional("WB_BalanceTeams");
	MarkNativeAsOptional("RefreshTBCache");
	return 0;
}

bool:GameME_SkillAvailible(client)
{
	new var1;
	return GetFeatureStatus(FeatureType:0, "GameME_GetClientSkill") && GameME_GetClientSkill(client) > 0;
}

AddUpdaterLibrary()
{
	return 0;
}

public OnPluginStart()
{
	g_cvar[0] = CreateConVar("sm_commander_restrictions", "1", "0 to disable the restrictions, 1 to enable restrictions.", 0, false, 0.0, false, 0.0);
	g_cvar[1] = CreateConVar("sm_commander_level", "10", "Sets the minimum level threshold required to command", 0, false, 0.0, false, 0.0);
	g_cvar[2] = CreateConVar("sm_restrict_highply", "18", "Sets the amount of players for high command requirements", 0, false, 0.0, false, 0.0);
	g_cvar[3] = CreateConVar("sm_restrict_highlvl", "40", "Sets the maximum threshold required to command", 0, false, 0.0, false, 0.0);
	g_cvar[4] = CreateConVar("sm_restrict_disable", "35", "Sets the skill average to disable all restrictions", 0, false, 0.0, false, 0.0);
	g_cvar[5] = CreateConVar("sm_bunker_demote", "180", "Set the time to demote a commander which doesn't enter the bunker", 0, false, 0.0, false, 0.0);
	g_cvar[6] = CreateConVar("sm_commander_lskill", "5000", "Sets the minimum skill threshold required to command", 0, false, 0.0, false, 0.0);
	g_cvar[7] = CreateConVar("sm_commander_hskill", "15000", "Sets the maximum skill threshold required to command", 0, false, 0.0, false, 0.0);
	g_cvar[8] = CreateConVar("sm_restrict_enable", "8", "Sets number of players on team to enable commadner restrictions", 0, false, 0.0, false, 0.0);
	AddCommandListener(Command_Apply, "applyforcommander");
	AddCommandListener(startmutiny, "startmutiny");
	AddCommandListener(PlayerJoinTeam, "jointeam");
	RegConsoleCmd("sm_mutiny", CMD_Demote, "", 0);
	RegConsoleCmd("sm_demote", CMD_Demote, "", 0);
	RegConsoleCmd("sm_unmutiny", CMD_UnDemote, "", 0);
	RegConsoleCmd("sm_undemote", CMD_UnDemote, "", 0);
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("round_end", Event_RoundEnd, EventHookMode:2);
	HookEvent("promoted_to_commander", Event_CommanderPromo, EventHookMode:1);
	HookEvent("player_entered_bunker_building", Event_EnterBunker, EventHookMode:1);
	LoadTranslations("nd_commander_restrictions.phrases");
	AddUpdaterLibrary();
	AutoExecConfig(true, "nd_commander_restrictions", "sourcemod");
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	CreateTimer(105.0, TIMER_DisableRestrictions, any:0, 2);
	g_Bool[2] = 1;
	g_Bool[1] = 0;
	return 0;
}

resetForGameStart()
{
	g_Bool[4] = 0;
	new i;
	while (i < 2)
	{
		commander[i] = -1;
		voteCount[i] = -1;
		g_hasEnteredBunker[i] = 0;
		i++;
	}
	new client = 1;
	while (client <= MaxClients)
	{
		g_hasBeenDemoted[client] = 0;
		g_hasResigned[client] = 0;
		g_isCommander[client] = 0;
		new var1 = g_hasVoted;
		var1[0][var1][client] = false;
		g_hasVoted[1][client] = false;
		client++;
	}
	return 0;
}

public OnMapStart()
{
	ServerCommand("nd_commander_mutiny_vote_threshold 51.0");
	resetForGameStart();
	return 0;
}

public Action:OnClientSayCommand(client, String:command[], String:sArgs[])
{
	if (client)
	{
		new var1;
		if (strcmp(sArgs, "demote", false) && strcmp(sArgs, "DEMOTE", false) && strcmp(sArgs, "mutiny", false) && strcmp(sArgs, "MUTINY", false))
		{
			new ReplySource:old = SetCmdReplySource(ReplySource:1);
			callMutiny(client, GetClientTeam(client));
			SetCmdReplySource(old);
			return Action:4;
		}
	}
	return Action:0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	g_Bool[2] = 0;
	g_Bool[3] = 0;
	g_Bool[1] = 1;
	g_Bool[4] = 0;
	return 0;
}

public Event_CommanderPromo(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	new team = GetEventInt(event, "teamid") + -2;
	new demoteTime = GetConVarInt(g_cvar[5]);
	CreateTimer(float(demoteTime), TIMER_CheckCommanderDemote, userid, 2);
	commander[team] = client;
	g_isCommander[client] = 1;
	return 0;
}

public Event_EnterBunker(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (client)
	{
		new clientTeam = GetClientTeam(client);
		if (clientTeam > 1)
		{
			new cTeamIDX = clientTeam + -2;
			if (!g_hasEnteredBunker[cTeamIDX])
			{
				g_hasEnteredBunker[cTeamIDX] = 1;
			}
		}
	}
	return 0;
}

public Action:PlayerJoinTeam(client, String:command[], argc)
{
	resetValues(client);
	return Action:0;
}

public Action:CMD_Demote(client, args)
{
	callMutiny(client, GetClientTeam(client));
	return Action:3;
}

public Action:CMD_UnDemote(client, args)
{
	PrintToChat(client, "\x05[xG] This feature is incomplete but coming soon!");
	return Action:3;
}

public OnClientDisconnect(client)
{
	resetValues(client);
	return 0;
}

public Action:TIMER_CheckCommanderDemote(Handle:timer, any:userid)
{
	new client = GetClientOfUserId(userid);
	if (client)
	{
		new commanderTeam = getCommanderTeam(client);
		if (commanderTeam != -1)
		{
			if (!g_hasEnteredBunker[commanderTeam + -2])
			{
				demoteCommander(commanderTeam);
			}
		}
		return Action:3;
	}
	return Action:3;
}

public Action:TIMER_DisableRestrictions(Handle:timer)
{
	if (getCommanderCount() != 2)
	{
		g_Bool[4] = 1;
		g_Bool[3] = 1;
		ServerCommand("nd_commander_mutiny_vote_threshold 65.0");
		if (ValidClientCount(false) > 10)
		{
			PrintToChatAll("\x05[xG] %t!", "Restrictions Relaxed");
		}
	}
	return Action:0;
}

public Action:TIMER_DisableApplyRestriction(Handle:timer, any:Userid)
{
	new player = GetClientOfUserId(Userid);
	g_hasResigned[player] = 0;
	return Action:3;
}

public Action:Command_Apply(client, String:command[], argc)
{
	if (IsSourceCommSilenced(client))
	{
		PrintToChat(client, "\x05[xG] %t!", "Silence Command");
		return Action:3;
	}
	if (g_hasBeenDemoted[client])
	{
		PrintToChat(client, "\x05[xG] %t.", "Demotion Reapply");
		return Action:3;
	}
	if (g_hasResigned[client])
	{
		PrintToChat(client, "\x05[xG] %t.", "Resignation Reapply");
		return Action:3;
	}
	if (GetConVarBool(g_cvar[0]))
	{
		if (GameME_RankedClient(client))
		{
			return Action:0;
		}
		new var1;
		if (g_Bool[2] && GetFeatureStatus(FeatureType:0, "GetAverageSkill") && GetAverageSkill() < GetConVarInt(g_cvar[4]))
		{
			return Action:0;
		}
		new count = OnTeamCount();
		if (GetConVarInt(g_cvar[8]) > count)
		{
			return Action:0;
		}
		new clientLevel = RetreiveLevel(client, -1);
		switch (clientLevel)
		{
			case 0, 1:
			{
				new var3;
				if (GameME_SkillAvailible(client) && GameME_GetClientSkill(client) > GetConVarInt(g_cvar[6]))
				{
					return Action:0;
				}
				PrintToChat(client, "\x05[xG] %t.", "Spawn Before Apply");
				return Action:3;
			}
			case 2, 3, 4, 5, 6, 7, 8, 9:
			{
				if (GetConVarInt(g_cvar[1]) < count)
				{
					PrintToChat(client, "\x05[xG] %t.", "Bellow Ten");
					return Action:3;
				}
				new lowSkill = GetConVarInt(g_cvar[6]);
				new var2;
				if (GameME_SkillAvailible(client) && GameME_GetClientSkill(client) < lowSkill)
				{
					PrintToChat(client, "\x05[xG] %d skill on server stats required to command!", lowSkill);
					return Action:3;
				}
			}
			default:
			{
				if (g_Bool[4])
				{
					return Action:0;
				}
				if (GetConVarInt(g_cvar[2]) < count)
				{
					if (GetConVarInt(g_cvar[3]) > clientLevel)
					{
						PrintToChat(client, "\x05[xG] %t.", "Fifty Five Required");
						return Action:3;
					}
					new highSkill = GetConVarInt(g_cvar[7]);
					new var4;
					if (GameME_SkillAvailible(client) && GameME_GetClientSkill(client) < highSkill)
					{
						PrintToChat(client, "\x05[xG] %d skill on server stats required to command!", highSkill);
						return Action:3;
					}
				}
				else
				{
					if (clientLevel < count)
					{
						PrintToChat(client, "\x05[xG] %t.", "Total Level");
						return Action:3;
					}
				}
			}
		}
	}
	return Action:0;
}

public Action:startmutiny(client, String:command[], argc)
{
	new var1;
	if (client && !IsClientInGame(client))
	{
		return Action:0;
	}
	new team = GetClientTeam(client);
	if (team < 2)
	{
		return Action:0;
	}
	new teamIDX = team + -2;
	if (commander[teamIDX] == -1)
	{
		return Action:0;
	}
	if (g_isCommander[client])
	{
		new Float:canReapply = 0.15 * ValidTeamCount(team);
		if (voteCount[teamIDX] > canReapply)
		{
			g_hasResigned[client] = 1;
			CreateTimer(30.0, TIMER_DisableApplyRestriction, GetClientUserId(client), 2);
		}
		resetVotes(team);
		setCommanderStatus(false, client, teamIDX);
		new var2;
		if (GetConVarBool(g_cvar[0]) && !g_Bool[3])
		{
			CreateTimer(60.0, TIMER_DisableRestrictions, any:0, 2);
		}
		return Action:0;
	}
	callMutiny(client, team);
	return Action:3;
}

setCommanderStatus(bool:status, client, teamIDX)
{
	g_isCommander[client] = status;
	new var1;
	if (status)
	{
		var1 = client;
	}
	else
	{
		var1 = -1;
	}
	commander[teamIDX] = var1;
	return 0;
}

getCommanderCount()
{
	new commanderCount;
	new client = 1;
	while (client <= MaxClients)
	{
		if (IsValidClient(client, true))
		{
			new var1;
			if (commander[0] != client && commander[1] != client)
			{
				commanderCount++;
			}
		}
		client++;
	}
	return commanderCount;
}

callMutiny(client, team)
{
	new teamIDX = team + -2;
	new com = commander[teamIDX];
	if (com == -1)
	{
		PrintToChat(client, "\x05[xG] %t.", "No Commander");
	}
	else
	{
		if (CheckCommandAccess(com, "mutiny_immunity", 2, true))
		{
			return 0;
		}
		if (team < 2)
		{
			PrintToChat(client, "\x05[xG] %t.", "On Team");
		}
		if (g_hasVoted[teamIDX][client])
		{
			PrintToChat(client, "\x05[xG] %t.", "Already Voted");
		}
		if (g_Bool[1])
		{
			PrintToChat(client, "\x05[xG] %t.", "Round End");
		}
		if (!g_Bool[2])
		{
			PrintToChat(client, "\x05[xG] %t.", "Round Started");
		}
		new var1;
		if (g_hasBeenDemoted[client] && voteCount[teamIDX])
		{
			PrintToChat(client, "\x05[xG] %t!", "Demote First");
		}
		new var2;
		if (IsSourceCommSilenced(client) && voteCount[teamIDX])
		{
			PrintToChat(client, "\x05[xG] %t!", "Silence First");
		}
		if (ValidTeamCount(team) < 4)
		{
			PrintToChat(client, "\x05[xG] %t.", "Four Required");
		}
		new Float:teamFloat = 0.51 * ValidTeamCount(team);
		voteCount[teamIDX]++;
		new Remainder = RoundToCeil(teamFloat) - voteCount[teamIDX];
		if (0 >= Remainder)
		{
			demoteCommander(team);
		}
		else
		{
			displayVotes(team, Remainder, client);
		}
		g_hasVoted[teamIDX][client] = true;
	}
	return 0;
}

resetValues(client)
{
	new team;
	while (team < 2)
	{
		if (g_hasVoted[team][client])
		{
			g_hasVoted[team][client] = false;
			voteCount[team]--;
		}
		team++;
	}
	return 0;
}

resetVotes(team)
{
	new teamIDX = team + -2;
	new client;
	while (client <= 65)
	{
		g_hasVoted[teamIDX][client] = false;
		client++;
	}
	voteCount[teamIDX] = 0;
	return 0;
}

demoteCommander(team)
{
	new teamIDX = team + -2;
	new client;
	while (client <= 65)
	{
		if (IsValidClient(client, true))
		{
			if (team == GetClientTeam(client))
			{
				if (commander[teamIDX] == client)
				{
					FakeClientCommand(client, "startmutiny");
					FakeClientCommand(client, "rtsview");
					g_hasBeenDemoted[client] = 1;
					resetVotes(team);
					setCommanderStatus(false, client, teamIDX);
				}
				PrintToChat(client, "\x05[xG] %t!", "Commander Demoted");
			}
		}
		client++;
	}
	return 0;
}

displayVotes(team, remainder, client)
{
	decl String:name[64];
	GetClientName(client, name, 64);
	new idx = 1;
	while (idx <= MaxClients)
	{
		new var1;
		if (IsValidClient(idx, true) && team == GetClientTeam(idx))
		{
			PrintToChat(idx, "\x05 %t", "Demote Vote", name, remainder);
		}
		idx++;
	}
	return 0;
}

getCommanderTeam(client)
{
	new var1;
	if (g_isCommander[client])
	{
		var1 = GetClientTeam(client);
	}
	else
	{
		var1 = -1;
	}
	return var1;
}

public Native_GetCommanderTeam(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	return getCommanderTeam(client);
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("GetCommanderTeam", Native_GetCommanderTeam);
	return APLRes:0;
}

