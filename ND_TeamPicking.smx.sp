public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "01/31/2016",
	time = "11:25:51"
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
public Plugin:myinfo =
{
	name = "ND_TeamPicking",
	description = "Lets the two selected commanders pick their team",
	author = "ND Battle Coders edited by stickz",
	version = "1.0",
	url = "<- URL ->"
};
new last_choice[2];
new cur_team_choosing;
new comm_con;
new comm_emp;
new next_team;
new next_comm;
new bool:g_bEnabled;
new bool:g_bPickStarted;
new bool:doublePlace = 1;
new bool:firstPlace = 1;
new bool:checkPlacement = 1;
new bool:roundStarted;
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

String:ND_GetTeamName(team, _arg1)
{
	new String:TeamName[12] = "Unknown";
	switch (team)
	{
		case 0:
		{
		}
		case 1:
		{
		}
		case 2:
		{
		}
		case 3:
		{
		}
		default:
		{
		}
	}
	return TeamName;
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

public void:OnPluginStart()
{
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("round_end", Event_RoundEnd, EventHookMode:2);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	LoadTranslations("common.phrases");
	RegAdminCmd("PlayerPicking", StartPicking, 2, "", "", 0);
	RegAdminCmd("ToggleLocks", DisableTeamChg, 2, "", "", 0);
	RegAdminCmd("ShowPickMenu", ShowPickMenu, 2, "", "", 0);
	RegAdminCmd("ReloadPicker", ReloadPlugin, 2, "", "", 0);
	AddCommandListener(Command_JoinTeam, "jointeam");
	PrintToChatAll("\x05[xG] Team picker plugin reloaded successfully");
	return void:0;
}

public Action:ReloadPlugin(client, args)
{
	decl String:Name[32];
	GetClientName(client, Name, 32);
	PrintToChatAll("\x05[xG] %s reloaded the team picker plugin!", Name);
	ServerCommand("sm plugins reload ND_TeamPicking");
	return Action:3;
}

public Action:DisableTeamChg(client, args)
{
	new var1;
	if (g_bEnabled)
	{
		var1 = 3004;
	}
	else
	{
		var1 = 3012;
	}
	PrintToChatAll("Team Changing is now %s!", var1);
	g_bEnabled = !g_bEnabled;
	return Action:3;
}

public Action:ShowPickMenu(client, args)
{
	if (g_bPickStarted)
	{
		ReplyToCommand(client, "[SM] Cannot use while picking is running!");
		return Action:3;
	}
	if (!args)
	{
		ReplyToCommand(client, "[SM] Usage: ShowPickMenu <2 or 3>  2=Consortium, 3=Empire.");
		return Action:3;
	}
	decl String:team_str[64];
	GetCmdArg(2, team_str, 64);
	if (!IsVoteInProgress(Handle:0))
	{
		decl teamNum;
		new var1;
		if (StringToInt(team_str, 10) == 2)
		{
			var1 = 2;
		}
		else
		{
			var1 = 3;
		}
		teamNum = var1;
		Menu_PlayerPick(comm_con, teamNum);
	}
	return Action:3;
}

public Action:StartPicking(client, args)
{
	if (CatchCommonFailure(args))
	{
		return Action:3;
	}
	decl String:con_name[64];
	GetCmdArg(1, con_name, 64);
	new target1 = FindTarget(client, con_name, false, false);
	decl String:emp_name[64];
	GetCmdArg(2, emp_name, 64);
	new target2 = FindTarget(client, emp_name, false, false);
	if (TargetingIsInvalid(target1, con_name, target2, emp_name))
	{
		return Action:3;
	}
	new teamName = 2;
	new teamCaptain = target1;
	if (args == 3)
	{
		decl String:startTeam[16];
		GetCmdArg(3, startTeam, 16);
		if (StrContains(startTeam, "con", false) > -1)
		{
			teamName = 2;
			teamCaptain = target1;
		}
		else
		{
			if (StrContains(startTeam, "emp", false) > -1)
			{
				teamName = 3;
				teamCaptain = target2;
			}
			PrintToChatAll("\x05[xG] !PlayerPicking Failure: '%s' was specified, but is an invalid starting team!", startTeam);
			return Action:3;
		}
	}
	PrintToChatAll("\x05Player Picking has Started!");
	BeforePicking(client, target1, target2);
	Menu_PlayerPick(teamCaptain, teamName);
	return Action:3;
}

bool:CatchCommonFailure(args)
{
	if (g_bPickStarted)
	{
		PrintToChatAll("\x05[xG] !PlayerPicking Failure: Already running or glitched. Use !ReloadPicker if required.");
		return true;
	}
	if (roundStarted)
	{
		PrintToChatAll("\x05[xG] !PlayerPicking Failure: Use '!Nexpick on' then Reload the map!");
		return true;
	}
	if (GetClientCount(false) < 4)
	{
		PrintToChatAll("\x05[xG] !PlayerPicking Failure: Four players required to use!");
		return true;
	}
	new var1;
	if (args < 2 || args > 3)
	{
		PrintToChatAll("\x05[xG] !PlayerPicking Failure: Format Incorrect. Usage: !PlayerPicking captain1 captain2 startingTeam");
		return true;
	}
	if (IsVoteInProgress(Handle:0))
	{
		PrintToChatAll("\x05[xG] !PlayerPicking Failure: Is a !vote or mapvote currently in progress?");
		return true;
	}
	return false;
}

bool:TargetingIsInvalid(target1, String:con_name[], target2, String:emp_name[])
{
	if (target1 == -1)
	{
		PrintToChatAll("\x05[xG] !PlayerPicking Failure: '%s' name segment invalid OR found multiple times!", con_name);
		return true;
	}
	if (target2 == -1)
	{
		PrintToChatAll("\x05[xG] !PlayerPicking Failure: '%s' name segment invalid OR found multiple times!", emp_name);
		return true;
	}
	if (target2 == target1)
	{
		decl String:pickerName[64];
		GetClientName(target1, pickerName, 64);
		PrintToChatAll("\x05[xG] !PlayerPicking Failure: '%s' targeted as picker on both teams!", pickerName);
		return true;
	}
	return false;
}

public BeforePicking(client, consortTarget, empireTarget)
{
	SetVarriableDefaults();
	PutEveryoneInSpectate();
	SetCaptainTeams(consortTarget, empireTarget);
	return 0;
}

SetVarriableDefaults()
{
	last_choice[0] = 0;
	last_choice[1] = 0;
	doublePlace = true;
	firstPlace = true;
	checkPlacement = true;
	g_bEnabled = true;
	g_bPickStarted = true;
	return 0;
}

PutEveryoneInSpectate()
{
	new idx = 1;
	while (idx <= MaxClients)
	{
		if (IsValidClient(idx, false))
		{
			ChangeClientTeam(idx, 1);
		}
		idx++;
	}
	return 0;
}

SetCaptainTeams(consortTarget, empireTarget)
{
	comm_con = consortTarget;
	comm_emp = empireTarget;
	ChangeClientTeam(consortTarget, 2);
	ChangeClientTeam(empireTarget, 3);
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	roundStarted = true;
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	roundStarted = false;
	return 0;
}

public void:OnMapEnd()
{
	roundStarted = false;
	return void:0;
}

public Handle_PickPlayerMenu(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:selectedItem[32];
			GetMenuItem(menu, param2, selectedItem, 32, 0, "", 0);
			new selectedPlayer = StringToInt(selectedItem, 10);
			new client = GetClientOfUserId(selectedPlayer);
			last_choice[cur_team_choosing + -2] = selectedPlayer;
			if (checkPlacement)
			{
				if (firstPlace)
				{
					firstPlace = false;
					SwitchPickingTeam();
					new otherTeam = getOtherTeam(cur_team_choosing);
					PrintToChatAll("\x05[xG] %s got the first pick!", ND_GetTeamName(cur_team_choosing));
					PrintToChatAll("\x05[xG] %s gets the next two picks!", ND_GetTeamName(otherTeam));
				}
				else
				{
					if (doublePlace)
					{
						doublePlace = false;
						checkPlacement = false;
						SetConstantPickingTeam();
					}
				}
			}
			else
			{
				SwitchPickingTeam();
			}
			if (selectedPlayer != -1)
			{
				decl String:name[64];
				GetClientName(client, name, 64);
				PrintToChatAll("%s was choosen to join %s.", name, ND_GetTeamName(cur_team_choosing));
				ChangeClientTeam(client, cur_team_choosing);
			}
			if (PickingComplete())
			{
				FinishPicking();
				if (menu)
				{
					CloseHandle(menu);
				}
			}
			else
			{
				Menu_PlayerPick(next_comm, next_team);
			}
		}
		case 8:
		{
			SwitchPickingTeam();
			last_choice[cur_team_choosing + -2] = -1;
			if (PickingComplete())
			{
				FinishPicking();
				if (menu)
				{
					CloseHandle(menu);
				}
			}
			else
			{
				Menu_PlayerPick(next_comm, next_team);
			}
		}
		default:
		{
		}
	}
	return 0;
}

SetConstantPickingTeam()
{
	switch (cur_team_choosing)
	{
		case 2:
		{
			next_comm = comm_con;
			next_team = 2;
		}
		case 3:
		{
			next_comm = comm_emp;
			next_team = 3;
		}
		default:
		{
		}
	}
	return 0;
}

SwitchPickingTeam()
{
	switch (cur_team_choosing)
	{
		case 2:
		{
			next_comm = comm_emp;
			next_team = 3;
		}
		case 3:
		{
			next_comm = comm_con;
			next_team = 2;
		}
		default:
		{
		}
	}
	return 0;
}

bool:PickingComplete()
{
	new var1;
	return last_choice[0] == -1 && last_choice[1] == -1;
}

FinishPicking()
{
	g_bEnabled = false;
	g_bPickStarted = false;
	PrintToChatAll("\x05Player Picking has been completed.");
	return 0;
}

public Action:Menu_PlayerPick(client, args)
{
	new clientTeam = GetClientTeam(client);
	cur_team_choosing = clientTeam;
	new Handle:menu = CreateMenu(Handle_PickPlayerMenu, MenuAction:28);
	SetMenuTitle(menu, "Choose next person to add to %s", ND_GetTeamName(clientTeam));
	SetMenuExitButton(menu, false);
	decl String:currentName[60];
	decl String:currentUser[32];
	new player;
	while (player <= MaxClients)
	{
		new var1;
		if (IsValidClient(player, false) && GetClientTeam(player) < 2)
		{
			GetClientName(player, currentName, 60);
			IntToString(GetClientUserId(player), currentUser, 30);
			AddMenuItem(menu, currentUser, currentName, 0);
		}
		player++;
	}
	AddMenuItem(menu, "-1", "End/Skip", 0);
	DisplayMenu(menu, client, 300);
	return Action:3;
}

public Action:Command_JoinTeam(client, String:command[], argc)
{
	if (g_bEnabled)
	{
		PrintToChat(client, "\x05Please stay in spectator until you're chosen.");
		return Action:3;
	}
	return Action:0;
}

