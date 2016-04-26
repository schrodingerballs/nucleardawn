public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "11/28/2015",
	time = "22:00:52"
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
	name = "[ND] Server Commands",
	description = "Adds adminstrative commands for server operators",
	author = "Stickz",
	version = "1.0.2",
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
	RegisterCommands();
	AddUpdaterLibrary();
	return 0;
}

public Action:Command_Swap(client, args)
{
	if (!args)
	{
		ReplyToCommand(client, "Usage: sm_swap [player name]");
		return Action:3;
	}
	decl String:targetArg[52];
	GetCmdArg(1, targetArg, 50);
	new target = FindTarget(client, targetArg, false, true);
	if (target != -1)
	{
		if (GetClientTeam(target) > 1)
		{
			PerformSwap(target);
		}
		else
		{
			ReplyToCommand(client, "Target is not on a playable team.");
		}
	}
	else
	{
		ReplyToCommand(client, "Unable to locate target.");
	}
	return Action:3;
}

PerformSwap(client)
{
	new CurrentTeam = GetClientTeam(client);
	decl TargetTeam;
	new var1;
	if (CurrentTeam == 2)
	{
		var1 = 3;
	}
	else
	{
		var1 = 2;
	}
	TargetTeam = var1;
	ChangeClientTeam(client, 1);
	ChangeClientTeam(client, TargetTeam);
	UpdateCaches();
	return 0;
}

public Action:Command_Spec(client, args)
{
	if (!args)
	{
		ReplyToCommand(client, "Usage: sm_spec [player name]");
		return Action:3;
	}
	decl String:targetArg[52];
	GetCmdArg(1, targetArg, 50);
	new target = FindTarget(client, targetArg, false, true);
	if (target != -1)
	{
		if (GetClientTeam(target) > 1)
		{
			ChangeClientTeam(target, 1);
			UpdateCaches();
		}
		else
		{
			ReplyToCommand(client, "Target is not on a playable team.");
		}
	}
	else
	{
		ReplyToCommand(client, "Unable to locate target.");
	}
	return Action:3;
}

public Action:Command_SetTeam(client, args)
{
	if (args != 2)
	{
		ReplyToCommand(client, "Usage: sm_setteam <player> <empire/consort/spec>");
		return Action:3;
	}
	decl String:playerArg[52];
	GetCmdArg(1, playerArg, 50);
	new target = FindTarget(client, playerArg, false, true);
	if (target == -1)
	{
		ReplyToCommand(client, "Invalid player name.");
		return Action:3;
	}
	decl String:teamArg[16];
	GetCmdArg(2, teamArg, 16);
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
		if (StrContains(teamArg, "spec", false) > -1)
		{
			team = 1;
		}
		ReplyToCommand(client, "Invalid team name.");
		return Action:3;
	}
	PerformTeamChange(target, team);
	return Action:3;
}

PerformTeamChange(target, team)
{
	ChangeClientTeam(target, 1);
	if (team > 1)
	{
		ChangeClientTeam(target, team);
	}
	UpdateCaches();
	return 0;
}

public Action:CMD_GetID(client, args)
{
	if (!args)
	{
		ReplyToCommand(client, "[SM] Usage: sm_pid <Name|#UserID>");
		return Action:3;
	}
	decl String:player[64];
	GetCmdArg(1, player, 64);
	new target = FindTarget(client, player, true, true);
	if (target == -1)
	{
		ReplyToCommand(client, "Invalid player name.");
		return Action:3;
	}
	PerformGetID(client, target);
	return Action:3;
}

PerformGetID(client, target)
{
	if (target == -1)
	{
		return 0;
	}
	new pID = GetClientUserId(target);
	decl String:pName[64];
	GetClientName(target, pName, 64);
	decl String:gAuth[64];
	GetClientAuthString(target, gAuth, 64, true);
	decl String:gIP[64];
	GetClientIP(target, gIP, 64, true);
	PrintToChat(client, "Name: %s\nPID: %d\nSTEAMID: %s\nIP: %s", pName, pID, gAuth, gIP);
	return 0;
}

RegisterCommands()
{
	RegAdminCmd("sm_pid", CMD_GetID, 4, "Checks player ID", "", 0);
	RegAdminCmd("sm_swap", Command_Swap, 4, "Swaps the team of targeted player.", "", 0);
	RegAdminCmd("sm_forcespec", Command_Spec, 4, "Swaps the targeted player to spectator team.", "", 0);
	RegAdminCmd("sm_SetTeam", Command_SetTeam, 4, "Sets the team of a target player", "", 0);
	return 0;
}

UpdateCaches()
{
	if (!(GetFeatureStatus(FeatureType:0, "RefreshTBCache")))
	{
		RefreshTBCache();
	}
	return 0;
}

