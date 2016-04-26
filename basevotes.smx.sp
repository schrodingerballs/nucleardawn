public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "12/27/2015",
	time = "15:06:25"
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
public Extension:__ext_topmenus =
{
	name = "TopMenus",
	file = "topmenus.ext",
	autoload = 1,
	required = 0,
};
public SharedPlugin:__pl_adminmenu =
{
	name = "adminmenu",
	file = "adminmenu.smx",
	required = 0,
};
public Plugin:myinfo =
{
	name = "Basic Votes",
	description = "Basic Vote Commands",
	author = "AlliedModders LLC",
	version = "1.7.3-dev+5255",
	url = "http://www.sourcemod.net/"
};
new Menu:g_hVoteMenu;
new ConVar:g_Cvar_Limits[3];
new voteType:g_voteType = 3;
new g_voteClient[2];
new String:g_voteInfo[3][68];
new String:g_voteArg[256];
new TopMenu:hTopMenu;
new Menu:g_MapList;
new g_mapCount;
new Handle:g_SelectedMaps;
new bool:g_VoteMapInUse;
new Handle:g_map_array;
new g_map_serial = -1;
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

Handle:CreateDataTimer(Float:interval, Timer:func, &Handle:datapack, flags)
{
	datapack = CreateDataPack();
	flags |= 512;
	return CreateTimer(interval, func, datapack, flags);
}

bool:Menu.DisplayVoteToAll(Menu:this, time, flags)
{
	new total;
	new players[MaxClients];
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
		}
		else
		{
			total++;
			players[total] = i;
		}
		i++;
	}
	return Menu.DisplayVote(this, players, total, time, flags);
}

void:GetMenuVoteInfo(param2, &winningVotes, &totalVotes)
{
	winningVotes = param2 & 65535;
	totalVotes = param2 >>> 16;
	return void:0;
}

bool:IsNewVoteAllowed()
{
	new var1;
	if (IsVoteInProgress(Handle:0) || CheckVoteDelay())
	{
		return false;
	}
	return true;
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

public __ext_topmenus_SetNTVOptional()
{
	MarkNativeAsOptional("CreateTopMenu");
	MarkNativeAsOptional("LoadTopMenuConfig");
	MarkNativeAsOptional("AddToTopMenu");
	MarkNativeAsOptional("RemoveFromTopMenu");
	MarkNativeAsOptional("DisplayTopMenu");
	MarkNativeAsOptional("DisplayTopMenuCategory");
	MarkNativeAsOptional("FindTopMenuCategory");
	MarkNativeAsOptional("SetTopMenuTitleCaching");
	return 0;
}

public __pl_adminmenu_SetNTVOptional()
{
	MarkNativeAsOptional("GetAdminTopMenu");
	MarkNativeAsOptional("AddTargetsToMenu");
	MarkNativeAsOptional("AddTargetsToMenu2");
	return 0;
}

DisplayVoteKickMenu(client, target)
{
	g_voteClient[0] = target;
	g_voteClient[1] = GetClientUserId(target);
	new var1 = g_voteInfo;
	GetClientName(target, var1[0][var1], 65);
	LogAction(client, target, "\"%L\" initiated a kick vote against \"%L\"", client, target);
	new var2 = g_voteInfo;
	ShowActivity(client, "%t", "Initiated Vote Kick", var2[0][var2]);
	g_voteType = MissingTAG:1;
	g_hVoteMenu = CreateMenu(Handler_VoteCallback, MenuAction:-1);
	Menu.SetTitle(g_hVoteMenu, "Votekick Player");
	Menu.AddItem(g_hVoteMenu, "###yes###", "Yes", 0);
	Menu.AddItem(g_hVoteMenu, "###no###", "No", 0);
	Menu.ExitButton.set(g_hVoteMenu, false);
	Menu.DisplayVoteToAll(g_hVoteMenu, 20, 0);
	return 0;
}

DisplayKickTargetMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_Kick, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T:", "Kick vote", client);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	AddTargetsToMenu(menu, client, false, false);
	Menu.Display(menu, client, 0);
	return 0;
}

public AdminMenu_VoteKick(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			DisplayKickTargetMenu(param);
		}
		if (action == TopMenuAction:3)
		{
			new var1;
			if (!IsNewVoteAllowed())
			{
				var1 = 6;
			}
			else
			{
				var1 = 0;
			}
			buffer[0] = var1;
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Kick vote", param);
	}
	return 0;
}

public MenuHandler_Kick(Menu:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:16)
	{
		CloseHandle(menu);
		menu = MissingTAG:0;
	}
	else
	{
		if (action == MenuAction:8)
		{
			new var1;
			if (param2 == -6 && hTopMenu)
			{
				TopMenu.Display(hTopMenu, param1, TopMenuPosition:3);
			}
		}
		if (action == MenuAction:4)
		{
			decl String:info[32];
			decl String:name[32];
			new userid;
			new target;
			Menu.GetItem(menu, param2, info, 32, 0, name, 32);
			userid = StringToInt(info, 10);
			if ((target = GetClientOfUserId(userid)))
			{
				if (!CanUserTarget(param1, target))
				{
					PrintToChat(param1, "[SM] %t", "Unable to target");
				}
				g_voteArg[0] = 0;
				DisplayVoteKickMenu(param1, target);
			}
			else
			{
				PrintToChat(param1, "[SM] %t", "Player no longer available");
			}
		}
	}
	return 0;
}

public Action:Command_Votekick(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_votekick <player> [reason]");
		return Action:3;
	}
	if (IsVoteInProgress(Handle:0))
	{
		ReplyToCommand(client, "[SM] %t", "Vote in Progress");
		return Action:3;
	}
	if (!TestVoteDelay(client))
	{
		return Action:3;
	}
	decl String:text[256];
	decl String:arg[64];
	GetCmdArgString(text, 256);
	new len = BreakString(text, arg, 64);
	new target = FindTarget(client, arg, false, true);
	if (target == -1)
	{
		return Action:3;
	}
	if (len != -1)
	{
		strcopy(g_voteArg, 256, text[len]);
	}
	else
	{
		g_voteArg[0] = 0;
	}
	DisplayVoteKickMenu(client, target);
	return Action:3;
}

DisplayVoteBanMenu(client, target)
{
	g_voteClient[0] = target;
	g_voteClient[1] = GetClientUserId(target);
	new var1 = g_voteInfo;
	GetClientName(target, var1[0][var1], 65);
	GetClientIP(target, g_voteInfo[2], 65, true);
	LogAction(client, target, "\"%L\" initiated a ban vote against \"%L\"", client, target);
	new var2 = g_voteInfo;
	ShowActivity2(client, "[SM] ", "%t", "Initiated Vote Ban", var2[0][var2]);
	g_voteType = MissingTAG:2;
	g_hVoteMenu = CreateMenu(Handler_VoteCallback, MenuAction:-1);
	Menu.SetTitle(g_hVoteMenu, "Voteban Player");
	Menu.AddItem(g_hVoteMenu, "###yes###", "Yes", 0);
	Menu.AddItem(g_hVoteMenu, "###no###", "No", 0);
	Menu.ExitButton.set(g_hVoteMenu, false);
	Menu.DisplayVoteToAll(g_hVoteMenu, 20, 0);
	return 0;
}

DisplayBanTargetMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_Ban, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T:", "Ban vote", client);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	AddTargetsToMenu(menu, client, false, false);
	Menu.Display(menu, client, 0);
	return 0;
}

public AdminMenu_VoteBan(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			DisplayBanTargetMenu(param);
		}
		if (action == TopMenuAction:3)
		{
			new var1;
			if (!IsNewVoteAllowed())
			{
				var1 = 6;
			}
			else
			{
				var1 = 0;
			}
			buffer[0] = var1;
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Ban vote", param);
	}
	return 0;
}

public MenuHandler_Ban(Menu:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:16)
	{
		CloseHandle(menu);
		menu = MissingTAG:0;
	}
	else
	{
		if (action == MenuAction:8)
		{
			new var1;
			if (param2 == -6 && hTopMenu)
			{
				TopMenu.Display(hTopMenu, param1, TopMenuPosition:3);
			}
		}
		if (action == MenuAction:4)
		{
			decl String:info[32];
			decl String:name[32];
			new userid;
			new target;
			Menu.GetItem(menu, param2, info, 32, 0, name, 32);
			userid = StringToInt(info, 10);
			if ((target = GetClientOfUserId(userid)))
			{
				if (!CanUserTarget(param1, target))
				{
					PrintToChat(param1, "[SM] %t", "Unable to target");
				}
				g_voteArg[0] = 0;
				DisplayVoteBanMenu(param1, target);
			}
			else
			{
				PrintToChat(param1, "[SM] %t", "Player no longer available");
			}
		}
	}
	return 0;
}

public Action:Command_Voteban(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_voteban <player> [reason]");
		return Action:3;
	}
	if (IsVoteInProgress(Handle:0))
	{
		ReplyToCommand(client, "[SM] %t", "Vote in Progress");
		return Action:3;
	}
	if (!TestVoteDelay(client))
	{
		return Action:3;
	}
	decl String:text[256];
	decl String:arg[64];
	GetCmdArgString(text, 256);
	new len = BreakString(text, arg, 64);
	if (len != -1)
	{
		strcopy(g_voteArg, 256, text[len]);
	}
	else
	{
		g_voteArg[0] = 0;
	}
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 48, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	DisplayVoteBanMenu(client, target_list[0]);
	return Action:3;
}

DisplayVoteMapMenu(client, mapCount, String:maps[20][])
{
	LogAction(client, -1, "\"%L\" initiated a map vote.", client);
	ShowActivity2(client, "[SM] ", "%t", "Initiated Vote Map");
	g_voteType = MissingTAG:0;
	g_hVoteMenu = CreateMenu(Handler_VoteCallback, MenuAction:-1);
	if (mapCount == 1)
	{
		new var1 = g_voteInfo;
		strcopy(var1[0][var1], 65, maps[0]);
		Menu.SetTitle(g_hVoteMenu, "Change Map To");
		Menu.AddItem(g_hVoteMenu, maps[0], "Yes", 0);
		Menu.AddItem(g_hVoteMenu, "###no###", "No", 0);
	}
	else
	{
		new var2 = g_voteInfo;
		var2[0][var2] = MissingTAG:0;
		Menu.SetTitle(g_hVoteMenu, "Map Vote");
		new i;
		while (i < mapCount)
		{
			Menu.AddItem(g_hVoteMenu, maps[i], maps[i], 0);
			i++;
		}
	}
	Menu.ExitButton.set(g_hVoteMenu, false);
	Menu.DisplayVoteToAll(g_hVoteMenu, 20, 0);
	return 0;
}

ResetMenu()
{
	g_VoteMapInUse = false;
	ClearArray(g_SelectedMaps);
	return 0;
}

ConfirmVote(client)
{
	new Menu:menu = CreateMenu(MenuHandler_Confirm, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T:", "Confirm Vote", client);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	decl String:itemtext[256];
	Format(itemtext, 256, "%T", "Start the Vote", client);
	Menu.AddItem(menu, "Confirm", itemtext, 0);
	Menu.Display(menu, client, 0);
	return 0;
}

public MenuHandler_Confirm(Menu:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:16)
	{
		CloseHandle(menu);
		menu = MissingTAG:0;
		g_VoteMapInUse = false;
	}
	else
	{
		if (action == MenuAction:8)
		{
			ResetMenu();
			new var1;
			if (param2 == -6 && hTopMenu)
			{
				TopMenu.Display(hTopMenu, param1, TopMenuPosition:3);
			}
		}
		if (action == MenuAction:4)
		{
			new String:maps[5][64] = "";
			new selectedmaps = GetArraySize(g_SelectedMaps);
			new i;
			while (i < selectedmaps)
			{
				GetArrayString(g_SelectedMaps, i, maps[i], 64);
				i++;
			}
			DisplayVoteMapMenu(param1, selectedmaps, maps);
			ResetMenu();
		}
	}
	return 0;
}

public MenuHandler_Map(Menu:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:8)
	{
		new var1;
		if (param2 == -6 && hTopMenu)
		{
			ConfirmVote(param1);
		}
		else
		{
			ResetMenu();
		}
	}
	else
	{
		if (action == MenuAction:256)
		{
			decl String:info[32];
			decl String:name[32];
			Menu.GetItem(menu, param2, info, 32, 0, name, 32);
			if (FindStringInArray(g_SelectedMaps, info) != -1)
			{
				return 6;
			}
			return 0;
		}
		if (action == MenuAction:4)
		{
			decl String:info[32];
			decl String:name[32];
			Menu.GetItem(menu, param2, info, 32, 0, name, 32);
			PushArrayString(g_SelectedMaps, info);
			if (GetArraySize(g_SelectedMaps) < 5)
			{
				Menu.Display(g_MapList, param1, 0);
			}
			else
			{
				ConfirmVote(param1);
			}
		}
		if (action == MenuAction:2)
		{
			decl String:title[128];
			Format(title, 128, "%T", "Please select a map", param1);
			SetPanelTitle(param2, title, false);
		}
	}
	return 0;
}

public AdminMenu_VoteMap(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			if (!g_VoteMapInUse)
			{
				ResetMenu();
				g_VoteMapInUse = true;
				Menu.Display(g_MapList, param, 0);
			}
			else
			{
				PrintToChat(param, "[SM] %T", "Map Vote In Use", param);
			}
		}
		if (action == TopMenuAction:3)
		{
			new var1;
			if (!IsNewVoteAllowed() || g_mapCount < 1 || g_VoteMapInUse)
			{
				var2 = 6;
			}
			else
			{
				var2 = 0;
			}
			buffer[0] = var2;
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Map vote", param);
	}
	return 0;
}

public Action:Command_Votemap(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_votemap <mapname> [mapname2] ... [mapname5]");
		return Action:3;
	}
	if (IsVoteInProgress(Handle:0))
	{
		ReplyToCommand(client, "[SM] %t", "Vote in Progress");
		return Action:3;
	}
	if (!TestVoteDelay(client))
	{
		return Action:3;
	}
	decl String:text[256];
	GetCmdArgString(text, 256);
	new String:maps[5][64] = "";
	new mapCount;
	new len;
	new pos;
	while (pos != -1 && mapCount < 5)
	{
		pos = BreakString(text[len], maps[mapCount], 64);
		if (!IsMapValid(maps[mapCount]))
		{
			ReplyToCommand(client, "[SM] %t", "Map was not found", maps[mapCount]);
			return Action:3;
		}
		mapCount++;
		if (pos != -1)
		{
			len = pos + len;
		}
	}
	DisplayVoteMapMenu(client, mapCount, maps);
	return Action:3;
}

LoadMapList(Menu:menu)
{
	new Handle:map_array;
	if ((map_array = ReadMapList(g_map_array, g_map_serial, "sm_votemap menu", 7)))
	{
		g_map_array = map_array;
	}
	if (g_map_array)
	{
		RemoveAllMenuItems(menu);
		new String:map_name[64];
		new map_count = GetArraySize(g_map_array);
		new i;
		while (i < map_count)
		{
			GetArrayString(g_map_array, i, map_name, 64);
			Menu.AddItem(menu, map_name, map_name, 0);
			i++;
		}
		return map_count;
	}
	return 0;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("basevotes.phrases");
	LoadTranslations("plugin.basecommands");
	LoadTranslations("basebans.phrases");
	RegAdminCmd("sm_votemap", Command_Votemap, 1088, "sm_votemap <mapname> [mapname2] ... [mapname5] ", "", 0);
	RegAdminCmd("sm_votekick", Command_Votekick, 1028, "sm_votekick <player> [reason]", "", 0);
	RegAdminCmd("sm_voteban", Command_Voteban, 1032, "sm_voteban <player> [reason]", "", 0);
	RegAdminCmd("sm_vote", Command_Vote, 1024, "sm_vote <question> [Answer1] [Answer2] ... [Answer5]", "", 0);
	g_Cvar_Limits[0] = CreateConVar("sm_vote_map", "0.60", "percent required for successful map vote.", 0, true, 0.05, true, 1.0);
	g_Cvar_Limits[1] = CreateConVar("sm_vote_kick", "0.60", "percent required for successful kick vote.", 0, true, 0.05, true, 1.0);
	g_Cvar_Limits[2] = CreateConVar("sm_vote_ban", "0.60", "percent required for successful ban vote.", 0, true, 0.05, true, 1.0);
	new TopMenu:topmenu;
	new var1;
	if (LibraryExists("adminmenu") && (topmenu = GetAdminTopMenu()))
	{
		OnAdminMenuReady(topmenu);
	}
	g_SelectedMaps = CreateArray(33, 0);
	g_MapList = CreateMenu(MenuHandler_Map, MenuAction:258);
	Menu.SetTitle(g_MapList, "%T", "Please select a map", 0);
	Menu.ExitBackButton.set(g_MapList, true);
	decl String:mapListPath[256];
	BuildPath(PathType:0, mapListPath, 256, "configs/adminmenu_maplist.ini");
	SetMapListCompatBind("sm_votemap menu", mapListPath);
	return void:0;
}

public void:OnConfigsExecuted()
{
	g_mapCount = LoadMapList(g_MapList);
	return void:0;
}

public void:OnAdminMenuReady(Handle:aTopMenu)
{
	new TopMenu:topmenu = TopMenu.FromHandle(aTopMenu);
	if (hTopMenu == topmenu)
	{
		return void:0;
	}
	hTopMenu = topmenu;
	new TopMenuObject:voting_commands = TopMenu.FindCategory(hTopMenu, "VotingCommands");
	if (voting_commands)
	{
		TopMenu.AddItem(hTopMenu, "sm_votekick", AdminMenu_VoteKick, voting_commands, "sm_votekick", 1028, "");
		TopMenu.AddItem(hTopMenu, "sm_voteban", AdminMenu_VoteBan, voting_commands, "sm_voteban", 1032, "");
		TopMenu.AddItem(hTopMenu, "sm_votemap", AdminMenu_VoteMap, voting_commands, "sm_votemap", 1088, "");
	}
	return void:0;
}

public Action:Command_Vote(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_vote <question> [Answer1] [Answer2] ... [Answer5]");
		return Action:3;
	}
	if (IsVoteInProgress(Handle:0))
	{
		ReplyToCommand(client, "[SM] %t", "Vote in Progress");
		return Action:3;
	}
	if (!TestVoteDelay(client))
	{
		return Action:3;
	}
	decl String:text[256];
	GetCmdArgString(text, 256);
	new String:answers[5][64] = "";
	new answerCount;
	new len = BreakString(text, g_voteArg, 256);
	new pos = len;
	while (args > 1 && pos != -1 && answerCount < 5)
	{
		pos = BreakString(text[len], answers[answerCount], 64);
		answerCount++;
		if (pos != -1)
		{
			len = pos + len;
		}
	}
	LogAction(client, -1, "\"%L\" initiated a generic vote.", client);
	ShowActivity2(client, "[SM] ", "%t", "Initiate Vote", g_voteArg);
	g_voteType = MissingTAG:3;
	g_hVoteMenu = CreateMenu(Handler_VoteCallback, MenuAction:-1);
	Menu.SetTitle(g_hVoteMenu, "%s?", g_voteArg);
	if (answerCount < 2)
	{
		Menu.AddItem(g_hVoteMenu, "###yes###", "Yes", 0);
		Menu.AddItem(g_hVoteMenu, "###no###", "No", 0);
	}
	else
	{
		new i;
		while (i < answerCount)
		{
			Menu.AddItem(g_hVoteMenu, answers[i], answers[i], 0);
			i++;
		}
	}
	Menu.ExitButton.set(g_hVoteMenu, false);
	Menu.DisplayVoteToAll(g_hVoteMenu, 20, 0);
	return Action:3;
}

public Handler_VoteCallback(Menu:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:16)
	{
		VoteMenuClose();
	}
	else
	{
		if (action == MenuAction:2)
		{
			if (g_voteType != voteType:3)
			{
				new String:title[64];
				Menu.GetTitle(menu, title, 64);
				new String:buffer[256];
				new var8 = g_voteInfo;
				Format(buffer, 255, "%T", title, param1, var8[0][var8]);
				new Panel:panel = param2;
				Panel.SetTitle(panel, buffer, false);
			}
		}
		if (action == MenuAction:512)
		{
			decl String:display[64];
			Menu.GetItem(menu, param2, "", 0, 0, display, 64);
			new var1;
			if (strcmp(display, "No", true) && strcmp(display, "Yes", true))
			{
				decl String:buffer[256];
				Format(buffer, 255, "%T", display, param1);
				return RedrawMenuItem(buffer);
			}
		}
		new var2;
		if (action == MenuAction:128 && param1 == -2)
		{
			PrintToChatAll("[SM] %t", "No Votes Cast");
		}
		if (action == MenuAction:32)
		{
			new String:item[64];
			new String:display[64];
			new Float:percent = 0.0;
			new Float:limit = 0.0;
			new votes;
			new totalVotes;
			GetMenuVoteInfo(param2, votes, totalVotes);
			Menu.GetItem(menu, param1, item, 64, 0, display, 64);
			new var3;
			if (strcmp(item, "###no###", true) && param1 == 1)
			{
				votes = totalVotes - votes;
			}
			percent = GetVotePercent(votes, totalVotes);
			if (g_voteType != voteType:3)
			{
				limit = ConVar.FloatValue.get(g_Cvar_Limits[g_voteType]);
			}
			new var4;
			if ((strcmp(item, "###yes###", true) && FloatCompare(percent, limit) < 0 && param1) || (strcmp(item, "###no###", true) && param1 == 1))
			{
				LogAction(-1, -1, "Vote failed.");
				PrintToChatAll("[SM] %t", "Vote Failed", RoundToNearest(limit * 100.0), RoundToNearest(percent * 100.0), totalVotes);
			}
			else
			{
				PrintToChatAll("[SM] %t", "Vote Successful", RoundToNearest(percent * 100.0), totalVotes);
				switch (g_voteType)
				{
					case 0:
					{
						LogAction(-1, -1, "Changing map to %s due to vote.", item);
						PrintToChatAll("[SM] %t", "Changing map", item);
						new Handle:dp;
						CreateDataTimer(5.0, Timer_ChangeMap, dp, 0);
						WritePackString(dp, item);
					}
					case 1:
					{
						if (!g_voteArg[0])
						{
							strcopy(g_voteArg, 256, "Votekicked");
						}
						new var10 = g_voteInfo;
						PrintToChatAll("[SM] %t", "Kicked target", "_s", var10[0][var10]);
						LogAction(-1, g_voteClient[0], "Vote kick successful, kicked \"%L\" (reason \"%s\")", g_voteClient, g_voteArg);
						ServerCommand("kickid %d \"%s\"", 2904 + 4, g_voteArg);
					}
					case 2:
					{
						if (!g_voteArg[0])
						{
							strcopy(g_voteArg, 256, "Votebanned");
						}
						new var9 = g_voteInfo;
						PrintToChatAll("[SM] %t", "Banned player", var9[0][var9], 30);
						LogAction(-1, g_voteClient[0], "Vote ban successful, banned \"%L\" (minutes \"30\") (reason \"%s\")", g_voteClient, g_voteArg);
						BanClient(g_voteClient[0], 30, 1, g_voteArg, "Banned by vote", "sm_voteban", any:0);
					}
					case 3:
					{
						new var7;
						if (strcmp(item, "###no###", true) && strcmp(item, "###yes###", true))
						{
							strcopy(item, 64, display);
						}
						PrintToChatAll("[SM] %t", "Vote End", g_voteArg, item);
					}
					default:
					{
					}
				}
			}
		}
	}
	return 0;
}

VoteMenuClose()
{
	CloseHandle(g_hVoteMenu);
	g_hVoteMenu = MissingTAG:0;
	g_hVoteMenu = MissingTAG:0;
	return 0;
}

Float:GetVotePercent(votes, totalVotes)
{
	return float(votes) / float(totalVotes);
}

bool:TestVoteDelay(client)
{
	new delay = CheckVoteDelay();
	if (0 < delay)
	{
		if (delay > 60)
		{
			ReplyToCommand(client, "[SM] %t", "Vote Delay Minutes", delay % 60);
		}
		else
		{
			ReplyToCommand(client, "[SM] %t", "Vote Delay Seconds", delay);
		}
		return false;
	}
	return true;
}

public Action:Timer_ChangeMap(Handle:timer, Handle:dp)
{
	decl String:mapname[68];
	ResetPack(dp, false);
	ReadPackString(dp, mapname, 65);
	ForceChangeLevel(mapname, "sm_votemap Result");
	return Action:4;
}

