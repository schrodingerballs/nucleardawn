public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "03/11/2016",
	time = "14:53:54"
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
public SharedPlugin:__pl_balancer =
{
	name = "nd_balance",
	file = "nd_team_balancer.smx",
	required = 0,
};
public SharedPlugin:__pl_commander =
{
	name = "nd_commander",
	file = "nd_commander_restrictions.smx",
	required = 0,
};
public Plugin:myinfo =
{
	name = "[ND] Dead Weights",
	description = "Allows assigning players to exo seige kit",
	author = "stickz",
	version = "fe639b0",
	url = "https://github.com/stickz/Redstone/"
};
new Handle:eDeadWeights;
new Handle:pDeadWeightArray;
new bool:player_forced_seige[66];
new bool:advancedKitsAvailable[2];
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

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

ReplyToTargetError(client, reason)
{
	switch (reason)
	{
		case -7:
		{
			ReplyToCommand(client, "[SM] %t", "More than one client matched");
		}
		case -6:
		{
			ReplyToCommand(client, "[SM] %t", "Cannot target bot");
		}
		case -5:
		{
			ReplyToCommand(client, "[SM] %t", "No matching clients");
		}
		case -4:
		{
			ReplyToCommand(client, "[SM] %t", "Unable to target");
		}
		case -3:
		{
			ReplyToCommand(client, "[SM] %t", "Target is not in game");
		}
		case -2:
		{
			ReplyToCommand(client, "[SM] %t", "Target must be dead");
		}
		case -1:
		{
			ReplyToCommand(client, "[SM] %t", "Target must be alive");
		}
		case 0:
		{
			ReplyToCommand(client, "[SM] %t", "No matching client");
		}
		default:
		{
		}
	}
	return 0;
}

FindTarget(client, String:target[], bool:nobots, bool:immunity)
{
	decl String:target_name[64];
	decl target_list[1];
	decl target_count;
	decl bool:tn_is_ml;
	new flags = 16;
	if (nobots)
	{
		flags |= 32;
	}
	if (!immunity)
	{
		flags |= 8;
	}
	if (0 < (target_count = ProcessTargetString(target, client, target_list, 1, flags, target_name, 64, tn_is_ml)))
	{
		return target_list[0];
	}
	ReplyToTargetError(client, target_count);
	return -1;
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

public __pl_balancer_SetNTVOptional()
{
	MarkNativeAsOptional("GetAverageSkill");
	MarkNativeAsOptional("WB_BalanceTeams");
	MarkNativeAsOptional("RefreshTBCache");
	return 0;
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
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_deadweights/nd_deadweights.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_deadweights/nd_deadweights.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	eDeadWeights = CreateConVar("sm_enable_deadweights", "1", "Sets wetheir to allow commanders to set their own limits.", 0, false, 0.0, false, 0.0);
	RegAdminCmd("sm_SetPlayerSiege", CMD_SetPlayerClass, 2, "!SetPlayerSeige <player>", "", 0);
	RegConsoleCmd("sm_LockSeige", CMD_LockPlayerSeige, "!LockSeige <player>", 0);
	HookEvent("player_changeclass", Event_SetClass, EventHookMode:0);
	HookEvent("player_death", Event_SetClass, EventHookMode:1);
	HookEvent("research_complete", Event_ResearchComplete, EventHookMode:1);
	pDeadWeightArray = CreateArray(23, 0);
	AddUpdaterLibrary();
	LoadTranslations("nd_dead_weight.phrases");
	return void:0;
}

public void:OnMapStart()
{
	ClearArray(pDeadWeightArray);
	advancedKitsAvailable[0] = 0;
	advancedKitsAvailable[1] = 0;
	new client = 1;
	while (client <= MaxClients)
	{
		if (IsValidClient(client, true))
		{
			ResetVars(client);
		}
		client++;
	}
	return void:0;
}

public void:OnClientAuthorized(client)
{
	ResetVars(client);
	decl String:gAuth[32];
	GetClientAuthId(client, AuthIdType:1, gAuth, 32, true);
	if (FindStringInArray(pDeadWeightArray, gAuth) != -1)
	{
		player_forced_seige[client] = 1;
	}
	return void:0;
}

public void:OnClientDisconnect(client)
{
	ResetVars(client);
	return void:0;
}

public Action:CMD_LockPlayerSeige(client, args)
{
	if (!GetConVarBool(eDeadWeights))
	{
		PrintToChat(client, "\x05[xG] %t", "Disabled Feature");
		return Action:3;
	}
	if (!IsValidClient(client, true))
	{
		return Action:3;
	}
	if (args != 1)
	{
		PrintToChat(client, "/x05[xG] %t", "Proper Usage");
		return Action:3;
	}
	new client_team = GetClientTeam(client);
	if (client_team < 2)
	{
		return Action:3;
	}
	if (!NDC_IsCommander(client))
	{
		PrintToChat(client, "\x05[xG] %t", "Only Commanders");
		return Action:3;
	}
	decl String:targetArg[52];
	GetCmdArg(1, targetArg, 50);
	new target = FindTarget(client, targetArg, false, true);
	if (target == -1)
	{
		PrintToChat(client, "/x05[xG] %t", "Cannot Find Player");
		return Action:3;
	}
	if (player_forced_seige[target])
	{
		SeigeLockPlayer(client, target, false);
		return Action:3;
	}
	SeigeLockPlayer(client, target, false);
	return Action:3;
}

public Action:CMD_SetPlayerClass(client, args)
{
	if (!IsValidClient(client, true))
	{
		return Action:3;
	}
	if (args != 1)
	{
		ReplyToCommand(client, "[xG] Usage: !SetPlayerSeige <player>");
		return Action:3;
	}
	decl String:targetArg[52];
	GetCmdArg(1, targetArg, 50);
	new target = FindTarget(client, targetArg, false, true);
	if (target == -1)
	{
		PrintToChat(client, "/x05[xG] %t", "Cannot Find Player");
		return Action:3;
	}
	SeigeLockPlayer(client, target, true);
	return Action:3;
}

public Action:Event_SetClass(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new class = GetEventInt(event, "subclass", 0);
	new subclass = GetEventInt(event, "subclass", 0);
	if (player_forced_seige[client])
	{
		if (advancedKitsAvailable[GetClientTeam(client) + -2])
		{
			if (!PlayerIsSeige(class, subclass))
			{
				SetPlayerSeige(client);
				return Action:0;
			}
		}
	}
	return Action:0;
}

public Action:Event_ResearchComplete(Handle:event, String:name[], bool:dontBroadcast)
{
	new team = GetEventInt(event, "teamid", 0);
	new researchID = GetEventInt(event, "researchid", 0);
	if (researchID == 1)
	{
		advancedKitsAvailable[team + -2] = 1;
	}
	return Action:0;
}

bool:PlayerIsSeige(class, subclass)
{
	new var1;
	return class == 1 && subclass == 1;
}

SetPlayerSeige(client)
{
	SetEntProp(client, PropType:0, "m_iPlayerClass", any:1, 4, 0);
	SetEntProp(client, PropType:0, "m_iPlayerSubclass", any:1, 4, 0);
	SetEntProp(client, PropType:0, "m_iDesiredPlayerClass", any:1, 4, 0);
	SetEntProp(client, PropType:0, "m_iDesiredPlayerSubclass", any:1, 4, 0);
	SetEntProp(client, PropType:0, "m_iDesiredGizmo", any:0, 4, 0);
	PrintToChat(client, "\x05[xG] %t.", "Locked Siege");
	return 0;
}

SeigeLockPlayer(admin, target, bool:AdminUsed)
{
	player_forced_seige[target] = !player_forced_seige[target];
	decl String:gAuth[32];
	GetClientAuthId(target, AuthIdType:1, gAuth, 32, true);
	if (player_forced_seige[target])
	{
		PrintToChat(admin, "\x05[xG] %t.", "Enabled Seige Lock");
		new var1;
		if (AdminUsed)
		{
			var1[0] = 4104;
		}
		else
		{
			var1[0] = 4124;
		}
		PrintToChat(target, "\x05[xG] %t.", var1);
		PushArrayString(pDeadWeightArray, gAuth);
	}
	else
	{
		PrintToChat(admin, "\x05[xG] %t.", "Disabled Seige Lock");
		new var2;
		if (AdminUsed)
		{
			var2[0] = 4192;
		}
		else
		{
			var2[0] = 4212;
		}
		PrintToChat(target, "\x05[xG] %t.", var2);
		new ArrayIndex = FindStringInArray(pDeadWeightArray, gAuth);
		if (ArrayIndex != -1)
		{
			RemoveFromArray(pDeadWeightArray, ArrayIndex);
		}
	}
	return 0;
}

ResetVars(client)
{
	player_forced_seige[client] = 0;
	return 0;
}

