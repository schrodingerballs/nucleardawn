public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "04/24/2016",
	time = "01:31:44"
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
public Extension:__ext_sdkhooks =
{
	name = "SDKHooks",
	file = "sdkhooks.ext",
	autoload = 1,
	required = 1,
};
new g_weapon_stats[66][28][15];
new String:g_weapon_list[28][20] =
{
	"avenger",
	"bag90",
	"chaingun",
	"daisy cutter",
	"f2000",
	"grenade launcher",
	"m95",
	"mp500",
	"mp7",
	"nx300",
	"p900",
	"paladin",
	"pp22",
	"psg",
	"shotgun",
	"sp5",
	"x01",
	"medpack",
	"armblade",
	"mine",
	"emp grenade",
	"p12 grenade",
	"remote grenade",
	"repair tool",
	"svr grenade",
	"u23 grenade",
	"armknives",
	"frag grenade"
};
new String:g_team_list[16][64];
new Handle:g_weapon_trie;
new g_bReadyToShoot[66];
new g_iBunkerAttacked[2];
public Plugin:myinfo =
{
	name = "[ND] Superlogs",
	description = "Advanced Nuclear Dawn logging designed for various statistical plugins",
	author = "Peace-Maker, stickz",
	version = "2a72ac9",
	url = "http://www.hlxcommunity.com"
};
public SharedPlugin:__pl_updater =
{
	name = "updater",
	file = "updater.smx",
	required = 0,
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
	MarkNativeAsOptional("BfWrite.WriteBool");
	MarkNativeAsOptional("BfWrite.WriteByte");
	MarkNativeAsOptional("BfWrite.WriteChar");
	MarkNativeAsOptional("BfWrite.WriteShort");
	MarkNativeAsOptional("BfWrite.WriteWord");
	MarkNativeAsOptional("BfWrite.WriteNum");
	MarkNativeAsOptional("BfWrite.WriteFloat");
	MarkNativeAsOptional("BfWrite.WriteString");
	MarkNativeAsOptional("BfWrite.WriteEntity");
	MarkNativeAsOptional("BfWrite.WriteAngle");
	MarkNativeAsOptional("BfWrite.WriteCoord");
	MarkNativeAsOptional("BfWrite.WriteVecCoord");
	MarkNativeAsOptional("BfWrite.WriteVecNormal");
	MarkNativeAsOptional("BfWrite.WriteAngles");
	MarkNativeAsOptional("BfRead.ReadBool");
	MarkNativeAsOptional("BfRead.ReadByte");
	MarkNativeAsOptional("BfRead.ReadChar");
	MarkNativeAsOptional("BfRead.ReadShort");
	MarkNativeAsOptional("BfRead.ReadWord");
	MarkNativeAsOptional("BfRead.ReadNum");
	MarkNativeAsOptional("BfRead.ReadFloat");
	MarkNativeAsOptional("BfRead.ReadString");
	MarkNativeAsOptional("BfRead.ReadEntity");
	MarkNativeAsOptional("BfRead.ReadAngle");
	MarkNativeAsOptional("BfRead.ReadCoord");
	MarkNativeAsOptional("BfRead.ReadVecCoord");
	MarkNativeAsOptional("BfRead.ReadVecNormal");
	MarkNativeAsOptional("BfRead.ReadAngles");
	MarkNativeAsOptional("BfRead.GetNumBytesLeft");
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
	MarkNativeAsOptional("Protobuf.ReadInt");
	MarkNativeAsOptional("Protobuf.ReadFloat");
	MarkNativeAsOptional("Protobuf.ReadBool");
	MarkNativeAsOptional("Protobuf.ReadString");
	MarkNativeAsOptional("Protobuf.ReadColor");
	MarkNativeAsOptional("Protobuf.ReadAngle");
	MarkNativeAsOptional("Protobuf.ReadVector");
	MarkNativeAsOptional("Protobuf.ReadVector2D");
	MarkNativeAsOptional("Protobuf.GetRepeatedFieldCount");
	MarkNativeAsOptional("Protobuf.SetInt");
	MarkNativeAsOptional("Protobuf.SetFloat");
	MarkNativeAsOptional("Protobuf.SetBool");
	MarkNativeAsOptional("Protobuf.SetString");
	MarkNativeAsOptional("Protobuf.SetColor");
	MarkNativeAsOptional("Protobuf.SetAngle");
	MarkNativeAsOptional("Protobuf.SetVector");
	MarkNativeAsOptional("Protobuf.SetVector2D");
	MarkNativeAsOptional("Protobuf.AddInt");
	MarkNativeAsOptional("Protobuf.AddFloat");
	MarkNativeAsOptional("Protobuf.AddBool");
	MarkNativeAsOptional("Protobuf.AddString");
	MarkNativeAsOptional("Protobuf.AddColor");
	MarkNativeAsOptional("Protobuf.AddAngle");
	MarkNativeAsOptional("Protobuf.AddVector");
	MarkNativeAsOptional("Protobuf.AddVector2D");
	MarkNativeAsOptional("Protobuf.RemoveRepeatedFieldValue");
	MarkNativeAsOptional("Protobuf.ReadMessage");
	MarkNativeAsOptional("Protobuf.ReadRepeatedMessage");
	MarkNativeAsOptional("Protobuf.AddMessage");
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

getOtherTeam(team)
{
	new var1;
	if (team == 2)
	{
		var1 = 3;
	}
	else
	{
		var1 = 2;
	}
	return var1;
}

GetTeams()
{
	new max_teams_count = GetTeamCount();
	new team_index;
	while (team_index < max_teams_count)
	{
		decl String:team_name[64];
		GetTeamName(team_index, team_name, 64);
		if (strcmp(team_name, "", true))
		{
		}
		team_index++;
	}
	return 0;
}

LogPlayerEvent(client, String:verb[], String:event[], bool:display_location, String:properties[])
{
	if (IsValidPlayer(client))
	{
		decl String:player_authid[32];
		if (!GetClientAuthId(client, AuthIdType:1, player_authid, 32, true))
		{
			strcopy(player_authid, 32, "UNKNOWN");
		}
		if (display_location)
		{
			decl Float:player_origin[3];
			GetClientAbsOrigin(client, player_origin);
			LogToGame("\"%N<%d><%s><%s>\" %s \"%s\"%s (position \"%d %d %d\")", client, GetClientUserId(client), player_authid, g_team_list[GetClientTeam(client)], verb, event, properties, RoundFloat(player_origin[0]), RoundFloat(player_origin[1]), RoundFloat(player_origin[2]));
		}
		else
		{
			LogToGame("\"%N<%d><%s><%s>\" %s \"%s\"%s", client, GetClientUserId(client), player_authid, g_team_list[GetClientTeam(client)], verb, event, properties);
		}
	}
	return 0;
}

LogTeamEvent(team, String:verb[], String:event[], String:properties[])
{
	if (team > -1)
	{
		LogToGame("Team \"%s\" %s \"%s\"%s", g_team_list[team], verb, event, properties);
	}
	return 0;
}

LogMapLoad()
{
	decl String:map[64];
	GetCurrentMap(map, 64);
	LogToGame("Loading map \"%s\"", map);
	return 0;
}

IsValidPlayer(client)
{
	new var1;
	return client > 0 && client <= MaxClients && IsClientInGame(client);
}

CreatePopulateWeaponTrie()
{
	g_weapon_trie = CreateTrie();
	new i;
	while (i < 28)
	{
		if (g_weapon_list[i][0])
		{
			SetTrieValue(g_weapon_trie, g_weapon_list[i], i, true);
		}
		else
		{
			decl String:randomKey[8];
			Format(randomKey, 6, "%c%c%c%c%c%c", GetURandomInt(), GetURandomInt(), GetURandomInt(), GetURandomInt(), GetURandomInt(), GetURandomInt());
			SetTrieValue(g_weapon_trie, randomKey, i, true);
		}
		i++;
	}
	return 0;
}

dump_player_stats(client)
{
	new var1;
	if (IsClientInGame(client) && IsClientConnected(client))
	{
		decl String:player_authid[64];
		if (!GetClientAuthId(client, AuthIdType:1, player_authid, 64, true))
		{
			strcopy(player_authid, 64, "UNKNOWN");
		}
		new player_team_index = GetClientTeam(client);
		new player_userid = GetClientUserId(client);
		new is_logged;
		new i;
		while (i < 28)
		{
			if (0 < g_weapon_stats[client][i][0])
			{
				LogToGame("\"%N<%d><%s><%s>\" triggered \"weaponstats\" (weapon \"%s\") (shots \"%d\") (hits \"%d\") (kills \"%d\") (headshots \"%d\") (tks \"%d\") (damage \"%d\") (deaths \"%d\")", client, player_userid, player_authid, g_team_list[player_team_index], g_weapon_list[i], g_weapon_stats[client][i], g_weapon_stats[client][i][1], g_weapon_stats[client][i][2], g_weapon_stats[client][i][3], g_weapon_stats[client][i][4], g_weapon_stats[client][i][5], g_weapon_stats[client][i][6]);
				LogToGame("\"%N<%d><%s><%s>\" triggered \"weaponstats2\" (weapon \"%s\") (head \"%d\") (chest \"%d\") (stomach \"%d\") (leftarm \"%d\") (rightarm \"%d\") (leftleg \"%d\") (rightleg \"%d\")", client, player_userid, player_authid, g_team_list[player_team_index], g_weapon_list[i], g_weapon_stats[client][i][8], g_weapon_stats[client][i][9], g_weapon_stats[client][i][10], g_weapon_stats[client][i][11], g_weapon_stats[client][i][12], g_weapon_stats[client][i][13], g_weapon_stats[client][i][14]);
				is_logged++;
			}
			i++;
		}
		if (0 < is_logged)
		{
			reset_player_stats(client);
		}
	}
	return 0;
}

reset_player_stats(client)
{
	new i;
	while (i < 28)
	{
		g_weapon_stats[client][i][0] = 0;
		g_weapon_stats[client][i][1] = 0;
		g_weapon_stats[client][i][2] = 0;
		g_weapon_stats[client][i][3] = 0;
		g_weapon_stats[client][i][4] = 0;
		g_weapon_stats[client][i][5] = 0;
		g_weapon_stats[client][i][6] = 0;
		g_weapon_stats[client][i][7] = 0;
		g_weapon_stats[client][i][8] = 0;
		g_weapon_stats[client][i][9] = 0;
		g_weapon_stats[client][i][10] = 0;
		g_weapon_stats[client][i][11] = 0;
		g_weapon_stats[client][i][12] = 0;
		g_weapon_stats[client][i][13] = 0;
		g_weapon_stats[client][i][14] = 0;
		i++;
	}
	return 0;
}

get_weapon_index(String:weapon_name[])
{
	new index = -1;
	GetTrieValue(g_weapon_trie, weapon_name, index);
	return index;
}

WstatsDumpAll()
{
	new i = 1;
	while (i <= MaxClients)
	{
		dump_player_stats(i);
		i++;
	}
	return 0;
}

OnPlayerDisconnect(client)
{
	new var1;
	if (client > 0 && IsClientInGame(client))
	{
		dump_player_stats(client);
		reset_player_stats(client);
	}
	return 0;
}

public __pl_updater_SetNTVOptional()
{
	MarkNativeAsOptional("Updater_AddPlugin");
	MarkNativeAsOptional("Updater_RemovePlugin");
	MarkNativeAsOptional("Updater_ForceUpdate");
	return 0;
}

public void:OnLibraryAdded(String:name[])
{
	if (StrEqual(name, "updater", true))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_superlogs/nd_superlogs.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_superlogs/nd_superlogs.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	CreatePopulateWeaponTrie();
	HookEvents();
	CreateTimer(1.0, LogMap, any:0, 0);
	SetupTeams();
	AccountForLateLoading();
	AddUpdaterLibrary();
	return void:0;
}

public void:OnMapStart()
{
	SetupTeams();
	g_iBunkerAttacked[0] = 0;
	g_iBunkerAttacked[1] = 0;
	return void:0;
}

public void:OnClientPutInServer(client)
{
	g_bReadyToShoot[client] = 0;
	if (!IsFakeClient(client))
	{
		SDKHook(client, SDKHookType:12, Hook_TraceAttackPost);
		SDKHook(client, SDKHookType:5, Hook_PostThink);
		SDKHook(client, SDKHookType:20, Hook_PostThinkPost);
	}
	reset_player_stats(client);
	return void:0;
}

public Action:Event_PlayerDeathPre(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	decl String:weapon[20];
	GetEventString(event, "weapon", weapon, 20, "");
	new var1;
	if (attacker <= 0 || victim <= 0)
	{
		return Action:0;
	}
	if (StrEqual(weapon, "commander ability", true))
	{
		new damagebits = GetEventInt(event, "damagebits", 0);
		if (damagebits & 1024)
		{
			Format(weapon, 20, "commander poison");
			SetEventString(event, "weapon", weapon);
		}
		else
		{
			if (damagebits & 64)
			{
				Format(weapon, 20, "commander damage");
				SetEventString(event, "weapon", weapon);
			}
		}
	}
	new victim_team = GetClientTeam(victim);
	if (victim != attacker)
	{
		if (victim == GameRules_GetPropEnt("m_hCommanders", victim_team + -2))
		{
			LogPlayerEvent(attacker, "triggered", "killed_commander", false, "");
		}
	}
	new weapon_index = get_weapon_index(weapon);
	if (weapon_index > -1)
	{
		g_weapon_stats[attacker][weapon_index][2]++;
		g_weapon_stats[victim][weapon_index][6]++;
		if (victim_team == GetClientTeam(attacker))
		{
			g_weapon_stats[attacker][weapon_index][4]++;
		}
		dump_player_stats(victim);
	}
	return Action:0;
}

public Hook_PostThink(client)
{
	if (!IsPlayerAlive(client))
	{
		return 0;
	}
	new iWeapon = GetEntPropEnt(client, PropType:0, "m_hActiveWeapon", 0);
	if (IsInvalid(iWeapon))
	{
		g_bReadyToShoot[client] = 0;
		return 0;
	}
	decl String:sWeapon[32];
	GetEdictClassname(iWeapon, sWeapon, 32);
	if (StrContains(sWeapon, "weapon_", false))
	{
		return 0;
	}
	new var1;
	g_bReadyToShoot[client] = GetEntPropFloat(iWeapon, PropType:0, "m_flNextPrimaryAttack", 0) <= GetGameTime() && GetEntProp(iWeapon, PropType:0, "m_iClip1", 4, 0) > 0;
	return 0;
}

public Hook_PostThinkPost(client)
{
	if (!IsPlayerAlive(client))
	{
		return 0;
	}
	new iWeapon = GetEntPropEnt(client, PropType:0, "m_hActiveWeapon", 0);
	if (IsInvalid(iWeapon))
	{
		return 0;
	}
	decl String:sWeapon[32];
	GetEdictClassname(iWeapon, sWeapon, 30);
	if (StrContains(sWeapon, "weapon_", false))
	{
		return 0;
	}
	ReplaceString(sWeapon, 30, "weapon_", "", false);
	FixWeaponLoggingName(sWeapon, 30);
	new var1;
	if (g_bReadyToShoot[client] && GetEntPropFloat(iWeapon, PropType:0, "m_flNextPrimaryAttack", 0) > GetGameTime())
	{
		new weapon_index = get_weapon_index(sWeapon);
		new var2;
		if (weapon_index > -1 && weapon_index < 16)
		{
			g_weapon_stats[client][weapon_index]++;
		}
		g_bReadyToShoot[client] = 0;
	}
	return 0;
}

public Hook_TraceAttackPost(victim, attacker, inflictor, Float:damage, damagetype, ammotype, hitbox, hitgroup)
{
	if (IsClientInGame(victim))
	{
		new var1;
		if (1 <= attacker <= MaxClients && IsClientInGame(attacker))
		{
			new iWeapon = GetEntPropEnt(attacker, PropType:0, "m_hActiveWeapon", 0);
			new String:sWeapon[64];
			if (0 < iWeapon)
			{
				GetEdictClassname(iWeapon, sWeapon, 64);
			}
			ReplaceString(sWeapon, 64, "weapon_", "", false);
			FixWeaponLoggingName(sWeapon, 64);
			new weapon_index = get_weapon_index(sWeapon);
			if (0 > GetClientHealth(victim) - RoundToCeil(damage))
			{
				if (hitgroup == 1)
				{
					LogPlayerEvent(attacker, "triggered", "headshot", false, "");
					if (weapon_index > -1)
					{
						g_weapon_stats[attacker][weapon_index][3]++;
					}
				}
			}
			else
			{
				if (weapon_index > -1)
				{
					g_weapon_stats[attacker][weapon_index][1]++;
					new var2 = g_weapon_stats[attacker][weapon_index][5];
					var2 = var2[RoundToCeil(damage)];
					if (hitgroup < 8)
					{
						g_weapon_stats[attacker][weapon_index][hitgroup + 7]++;
					}
				}
			}
		}
	}
	return 0;
}

public Event_PlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < client)
	{
		reset_player_stats(client);
	}
	return 0;
}

public Action:Event_PlayerDisconnect(Handle:event, String:name[], bool:dontBroadcast)
{
	OnPlayerDisconnect(GetClientOfUserId(GetEventInt(event, "userid", 0)));
	return Action:0;
}

public Event_RoundWin(Handle:event, String:name[], bool:dontBroadcast)
{
	new team = GetEventInt(event, "team", 0);
	if (team >= 2)
	{
		LogTeamEvent(team, "triggered", "round_win", "");
		LogTeamEvent(getOtherTeam(team), "triggered", "round_lose", "");
	}
	g_iBunkerAttacked[0] = 0;
	g_iBunkerAttacked[1] = 0;
	WstatsDumpAll();
	return 0;
}

public Event_PromotedToCommander(Handle:event, String:name[], bool:dontBroadcast)
{
	LogPlayerEvent(GetClientOfUserId(GetEventInt(event, "userid", 0)), "triggered", "promoted_to_commander", false, "");
	return 0;
}

public Event_ResourceCaptured(Handle:event, String:name[], bool:dontBroadcast)
{
	new team = GetEventInt(event, "team", 0);
	if (team >= 2)
	{
		LogTeamEvent(team, "triggered", "resource_captured", "");
	}
	return 0;
}

public Event_StructureDamageSparse(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!GetEventBool(event, "bunker", false))
	{
		return 0;
	}
	new team = GetEventInt(event, "ownerteam", 0);
	if (team >= 2)
	{
		g_iBunkerAttacked[team + -2]++;
		if (g_iBunkerAttacked[team + -2] == 10)
		{
			LogTeamEvent(getOtherTeam(team), "triggered", "damaged_opposite_bunker", "");
			g_iBunkerAttacked[team + -2] = 0;
		}
	}
	return 0;
}

public Event_StructureDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new iEnt = GetEventInt(event, "entindex", 0);
	new iAttacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (iAttacker > 0 && iAttacker <= MaxClients && iEnt != -1 && IsValidEntity(iEnt))
	{
		new type = GetEventInt(event, "type", 0);
		switch (type)
		{
			case 1:
			{
				LogPlayerEvent(iAttacker, "triggered", "machineguneturret_destroyed", false, "");
			}
			case 2:
			{
				LogPlayerEvent(iAttacker, "triggered", "transportgate_destroyed", false, "");
			}
			case 3:
			{
				LogPlayerEvent(iAttacker, "triggered", "powerstation_destroyed", false, "");
			}
			case 4:
			{
				LogPlayerEvent(iAttacker, "triggered", "wirelessrepeater_destroyed", false, "");
			}
			case 5:
			{
				LogPlayerEvent(iAttacker, "triggered", "powerrelay_destroyed", false, "");
			}
			case 6:
			{
				LogPlayerEvent(iAttacker, "triggered", "supply_destroyed", false, "");
			}
			case 7:
			{
				LogPlayerEvent(iAttacker, "triggered", "assembler_destroyed", false, "");
			}
			case 8:
			{
				LogPlayerEvent(iAttacker, "triggered", "armoury_destroyed", false, "");
			}
			case 9:
			{
				LogPlayerEvent(iAttacker, "triggered", "artillery_destroyed", false, "");
			}
			case 10:
			{
				LogPlayerEvent(iAttacker, "triggered", "radar_destroyed", false, "");
			}
			case 11:
			{
				LogPlayerEvent(iAttacker, "triggered", "flamethrowerturret_destroyed", false, "");
			}
			case 12:
			{
				LogPlayerEvent(iAttacker, "triggered", "sonicturret_destroyed", false, "");
			}
			case 13:
			{
				LogPlayerEvent(iAttacker, "triggered", "rocketturret_destroyed", false, "");
			}
			case 14:
			{
				LogPlayerEvent(iAttacker, "triggered", "wall_destroyed", false, "");
			}
			case 15:
			{
				LogPlayerEvent(iAttacker, "triggered", "barrier_destroyed", false, "");
			}
			default:
			{
			}
		}
	}
	return 0;
}

public Action:LogMap(Handle:timer)
{
	LogMapLoad();
	return Action:0;
}

bool:IsInvalid(iWeapon)
{
	new var1;
	return iWeapon == -1 || !IsValidEdict(iWeapon);
}

FixWeaponLoggingName(String:sWeapon[], maxlength)
{
	if (StrEqual(sWeapon, "daisycutter", true))
	{
		strcopy(sWeapon, maxlength, "daisy cutter");
	}
	else
	{
		if (StrEqual(sWeapon, "emp_grenade", true))
		{
			strcopy(sWeapon, maxlength, "emp grenade");
		}
		if (StrEqual(sWeapon, "frag_grenade", true))
		{
			strcopy(sWeapon, maxlength, "frag grenade");
		}
		if (StrEqual(sWeapon, "grenade_launcher", true))
		{
			strcopy(sWeapon, maxlength, "grenade launcher");
		}
		if (StrEqual(sWeapon, "p12_grenade", true))
		{
			strcopy(sWeapon, maxlength, "p12 grenade");
		}
		if (StrEqual(sWeapon, "remote_grenade", true))
		{
			strcopy(sWeapon, maxlength, "remote grenade");
		}
		if (StrEqual(sWeapon, "u23_grenade", true))
		{
			strcopy(sWeapon, maxlength, "u23 grenade");
		}
	}
	return 0;
}

HookEvents()
{
	HookEvent("player_death", Event_PlayerDeathPre, EventHookMode:0);
	HookEvent("promoted_to_commander", Event_PromotedToCommander, EventHookMode:1);
	HookEvent("resource_captured", Event_ResourceCaptured, EventHookMode:1);
	HookEvent("structure_damage_sparse", Event_StructureDamageSparse, EventHookMode:1);
	HookEvent("structure_death", Event_StructureDeath, EventHookMode:1);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode:1);
	HookEvent("round_win", Event_RoundWin, EventHookMode:1);
	HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode:0);
	return 0;
}

SetupTeams()
{
	GetTeams();
	strcopy(g_team_list[2], 64, "CONSORTIUM");
	strcopy(g_team_list[3], 64, "EMPIRE");
	return 0;
}

AccountForLateLoading()
{
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			OnClientPutInServer(i);
		}
		i++;
	}
	return 0;
}

