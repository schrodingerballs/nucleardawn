public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "03/01/2016",
	time = "20:02:06"
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
public Extension:__ext_cprefs =
{
	name = "Client Preferences",
	file = "clientprefs.ext",
	autoload = 1,
	required = 1,
};
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
new bool:option_team_breakdown[66] =
{
	1, ...
};
new Handle:cookie_team_breakdown;
new bool:roundStarted;
new bool:statusChanged;
new g_Layout[2][6];
public Plugin:myinfo =
{
	name = "[ND] Team Breakdown",
	description = "Provides troop count display",
	author = "databomb edited by stickz",
	version = "1.0.6",
	url = ""
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

bool:NDC_IsCommanderOnTeam(client, team)
{
	if (!GetFeatureStatus(FeatureType:0, "GetCommanderTeam") == 0)
	{
		new clientTeam = GetClientTeam(client);
		new var1;
		return team == clientTeam && client == GameRules_GetPropEnt("m_hCommanders", clientTeam + -2);
	}
	return team == GetCommanderTeam(client);
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
	LoadTranslations("nd_team_breakdown.phrases");
	LoadTranslations("common.phrases");
	cookie_team_breakdown = RegClientCookie("Team Breakdown On/Off", "", CookieAccess:1);
	new info;
	SetCookieMenuItem(CookieMenuHandler_TeamBreakdown, info, "Troop Counts");
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("promoted_to_commander", Event_CommanderPromote, EventHookMode:1);
	HookEvent("round_win", Event_RoundEnd, EventHookMode:0);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	startPlugin();
	AddUpdaterLibrary();
	return 0;
}

public CookieMenuHandler_TeamBreakdown(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	switch (action)
	{
		case 0:
		{
			decl String:status[12];
			new var2;
			if (option_team_breakdown[client])
			{
				var2[0] = 1864;
			}
			else
			{
				var2[0] = 1868;
			}
			Format(status, 10, "%T", var2, client);
			Format(buffer, maxlen, "%T: %s", "Cookie Team Breakdown", client, status);
		}
		case 1:
		{
			option_team_breakdown[client] = !option_team_breakdown[client];
			new var1;
			if (option_team_breakdown[client])
			{
				var1[0] = 1904;
			}
			else
			{
				var1[0] = 1908;
			}
			SetClientCookie(client, cookie_team_breakdown, var1);
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
	option_team_breakdown[client] = GetCookieTeamBreakdown(client);
	return 0;
}

bool:GetCookieTeamBreakdown(client)
{
	decl String:buffer[12];
	GetClientCookie(client, cookie_team_breakdown, buffer, 10);
	return StrEqual(buffer, "On", true);
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	startPlugin();
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	disableBreakdowns();
	return 0;
}

public Event_ChangeClass(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!statusChanged)
	{
		new client = GetClientOfUserId(GetEventInt(event, "userid"));
		if (IsClientInGame(client))
		{
			statusChanged = true;
		}
	}
	return 0;
}

public Event_PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new userID = GetEventInt(event, "userid");
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new var1;
	if (IsValidClient(client, true) && option_team_breakdown[client] && !NDC_IsCommander(client))
	{
		CreateTimer(1.5, DisplayBreakdownsClients, userID, 3);
	}
	return 0;
}

public Event_CommanderPromote(Handle:event, String:name[], bool:dontBroadcast)
{
	CreateTimer(1.5, DisplayBreakdownsCommander, GetEventInt(event, "userid"), 3);
	return 0;
}

public Action:DisplayBreakdownsCommander(Handle:timer, any:Userid)
{
	if (!roundStarted)
	{
		return Action:4;
	}
	new client = GetClientOfUserId(Userid);
	new var1;
	if (client && !IsValidClient(client, true))
	{
		return Action:4;
	}
	new clientTeam = GetClientTeam(client);
	if (clientTeam > 1)
	{
		if (NDC_IsCommanderOnTeam(client, clientTeam))
		{
			ShowTeamBreakdown(client, clientTeam, 1.0, 0.115, 255, 128, 0, 175);
			return Action:0;
		}
	}
	return Action:4;
}

public Action:DisplayBreakdownsClients(Handle:timer, any:Userid)
{
	if (!roundStarted)
	{
		return Action:4;
	}
	new client = GetClientOfUserId(Userid);
	new var1;
	if (client && !IsValidClient(client, true))
	{
		return Action:4;
	}
	new clientTeam = GetClientTeam(client);
	if (clientTeam > 1)
	{
		if (!IsPlayerAlive(client))
		{
			switch (clientTeam)
			{
				case 2:
				{
					ShowTeamBreakdown(client, clientTeam, 1.0, 0.425, 51, 153, 255, 175);
				}
				case 3:
				{
					ShowTeamBreakdown(client, clientTeam, 1.0, 0.425, 255, 0, 0, 255);
				}
				default:
				{
				}
			}
			return Action:0;
		}
	}
	return Action:4;
}

ShowTeamBreakdown(client, clientTeam, Float:x, Float:y, r, g, b, a)
{
	new arrayIdx = clientTeam + -2;
	new Handle:hHudText = CreateHudSynchronizer();
	SetHudTextParams(x, y, 1.5, r, g, b, a, 0, 6.0, 0.1, 0.2);
	ShowSyncHudText(client, hHudText, "%t %d\n%t %d\n%t %d\n%t %d\n%t %d\n%t %d", "Combat", g_Layout[arrayIdx], "Anti-Structure", g_Layout[arrayIdx][2], "Sniper", g_Layout[arrayIdx][1], "Stealth", g_Layout[arrayIdx][3], "Medic", g_Layout[arrayIdx][4], "Engineer", g_Layout[arrayIdx][5]);
	CloseHandle(hHudText);
	return 0;
}

public Action:UpdateBreakdowns(Handle:timer)
{
	if (!roundStarted)
	{
		return Action:4;
	}
	if (statusChanged)
	{
		new i;
		while (i < 2)
		{
			new y;
			while (y < 6)
			{
				g_Layout[i][y] = 0;
				y++;
			}
			i++;
		}
		new client = 1;
		while (client <= MaxClients)
		{
			if (IsClientInGame(client))
			{
				new clientTeam = GetClientTeam(client);
				new cTeamIDX = clientTeam + -2;
				new iClass = GetEntProp(client, PropType:0, "m_iPlayerClass", 4, 0);
				new iSubClass = GetEntProp(client, PropType:0, "m_iPlayerSubclass", 4, 0);
				switch (iClass)
				{
					case 0:
					{
						switch (iSubClass)
						{
							case 0:
							{
								g_Layout[cTeamIDX]++;
							}
							case 1:
							{
								g_Layout[cTeamIDX][2]++;
							}
							case 2:
							{
								g_Layout[cTeamIDX][1]++;
							}
							default:
							{
							}
						}
					}
					case 1:
					{
						switch (iSubClass)
						{
							case 0:
							{
								g_Layout[cTeamIDX]++;
							}
							case 1:
							{
								g_Layout[cTeamIDX][2]++;
							}
							default:
							{
							}
						}
					}
					case 2:
					{
						g_Layout[cTeamIDX][3]++;
						switch (iSubClass)
						{
							case 0:
							{
								g_Layout[cTeamIDX]++;
							}
							case 1:
							{
								g_Layout[cTeamIDX][1]++;
							}
							case 2:
							{
								g_Layout[cTeamIDX][2]++;
							}
							default:
							{
							}
						}
					}
					case 3:
					{
						switch (iSubClass)
						{
							case 0:
							{
								g_Layout[cTeamIDX][4]++;
							}
							case 1:
							{
								g_Layout[cTeamIDX][5]++;
							}
							case 2:
							{
								g_Layout[cTeamIDX][2]++;
							}
							default:
							{
							}
						}
					}
					default:
					{
					}
				}
			}
			client++;
		}
		statusChanged = false;
	}
	return Action:0;
}

disableBreakdowns()
{
	if (roundStarted)
	{
		roundStarted = false;
		UnhookEvent("player_changeclass", Event_ChangeClass, EventHookMode:1);
		UnhookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
	}
	return 0;
}

startPlugin()
{
	roundStarted = true;
	statusChanged = true;
	CreateTimer(1.5, UpdateBreakdowns, any:0, 3);
	HookEvent("player_changeclass", Event_ChangeClass, EventHookMode:1);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
	return 0;
}

public Native_GetSniperCount(Handle:plugin, numParams)
{
	new teamIDX = GetNativeCell(1);
	new sniperCount = g_Layout[teamIDX + -2][1];
	return sniperCount;
}

public Native_GetStealthCount(Handle:plugin, numParams)
{
	new teamIDX = GetNativeCell(1);
	new stealthCount = g_Layout[teamIDX + -2][3];
	return stealthCount;
}

public Native_GetAntiStructureCount(Handle:plugin, numParams)
{
	new teamIDX = GetNativeCell(1);
	new AntiStructureCount = g_Layout[teamIDX + -2][2];
	return AntiStructureCount;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("GetSniperCount", Native_GetSniperCount);
	CreateNative("GetStealthCount", Native_GetStealthCount);
	CreateNative("GetAntiStructureCount", Native_GetAntiStructureCount);
	return APLRes:0;
}

