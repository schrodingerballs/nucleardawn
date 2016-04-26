public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "12/13/2015",
	time = "17:21:00"
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
	name = "Basic Commands",
	description = "Basic Admin Commands",
	author = "AlliedModders LLC",
	version = "1.7.3-dev+5255",
	url = "http://www.sourcemod.net/"
};
new TopMenu:hTopMenu;
new Menu:g_MapList;
new Handle:g_ProtectedVars;
new Handle:g_map_array;
new g_map_serial = -1;
new Menu:g_ConfigMenu;
new SMCParser:config_parser;
new String:g_FlagNames[14][20] =
{
	"res",
	"admin",
	"kick",
	"ban",
	"unban",
	"slay",
	"map",
	"cvars",
	"cfg",
	"chat",
	"vote",
	"pass",
	"rcon",
	"cheat"
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

ImplodeStrings(String:strings[][], numStrings, String:join[], String:buffer[], maxLength)
{
	new total;
	new length;
	new part_length;
	new join_length = strlen(join);
	new i;
	while (i < numStrings)
	{
		length = strcopy(buffer[total], maxLength - total, strings[i]);
		total = length + total;
		if (!(length < part_length))
		{
			if (numStrings + -1 != i)
			{
				length = strcopy(buffer[total], maxLength - total, join);
				total = length + total;
				if (length < join_length)
				{
					return total;
				}
			}
			i++;
		}
		return total;
	}
	return total;
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

bool:RedisplayAdminMenu(Handle:topmenu, client)
{
	if (topmenu)
	{
		return DisplayTopMenu(topmenu, client, TopMenuPosition:3);
	}
	return false;
}

public __pl_adminmenu_SetNTVOptional()
{
	MarkNativeAsOptional("GetAdminTopMenu");
	MarkNativeAsOptional("AddTargetsToMenu");
	MarkNativeAsOptional("AddTargetsToMenu2");
	return 0;
}

PerformKick(client, target, String:reason[])
{
	LogAction(client, target, "\"%L\" kicked \"%L\" (reason \"%s\")", client, target, reason);
	if (reason[0])
	{
		KickClient(target, "%s", reason);
	}
	else
	{
		KickClient(target, "%t", "Kicked by admin");
	}
	return 0;
}

DisplayKickMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_Kick, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T:", "Kick player", client);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	AddTargetsToMenu(menu, client, false, false);
	Menu.Display(menu, client, 0);
	return 0;
}

public AdminMenu_Kick(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			DisplayKickMenu(param);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Kick player", param);
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
			new userid;
			new target;
			Menu.GetItem(menu, param2, info, 32, 0, "", 0);
			userid = StringToInt(info, 10);
			if ((target = GetClientOfUserId(userid)))
			{
				if (!CanUserTarget(param1, target))
				{
					PrintToChat(param1, "[SM] %t", "Unable to target");
				}
				decl String:name[32];
				GetClientName(target, name, 32);
				ShowActivity2(param1, "[SM] ", "%t", "Kicked target", "_s", name);
				PerformKick(param1, target, "");
			}
			else
			{
				PrintToChat(param1, "[SM] %t", "Player no longer available");
			}
			new var2;
			if (IsClientInGame(param1) && !IsClientInKickQueue(param1))
			{
				DisplayKickMenu(param1);
			}
		}
	}
	return 0;
}

public Action:Command_Kick(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_kick <#userid|name> [reason]");
		return Action:3;
	}
	decl String:Arguments[256];
	GetCmdArgString(Arguments, 256);
	decl String:arg[68];
	new len = BreakString(Arguments, arg, 65);
	if (len == -1)
	{
		len = 0;
		Arguments[0] = MissingTAG:0;
	}
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 < (target_count = ProcessTargetString(arg, client, target_list, 65, 4, target_name, 64, tn_is_ml)))
	{
		decl String:reason[64];
		Format(reason, 64, Arguments[len]);
		if (tn_is_ml)
		{
			if (reason[0])
			{
				ShowActivity2(client, "[SM] ", "%t", "Kicked target reason", target_name, reason);
			}
			else
			{
				ShowActivity2(client, "[SM] ", "%t", "Kicked target", target_name);
			}
		}
		else
		{
			if (reason[0])
			{
				ShowActivity2(client, "[SM] ", "%t", "Kicked target reason", "_s", target_name, reason);
			}
			ShowActivity2(client, "[SM] ", "%t", "Kicked target", "_s", target_name);
		}
		new kick_self;
		new i;
		while (i < target_count)
		{
			if (client == target_list[i])
			{
				kick_self = client;
			}
			else
			{
				PerformKick(client, target_list[i], reason);
			}
			i++;
		}
		if (kick_self)
		{
			PerformKick(client, client, reason);
		}
	}
	else
	{
		ReplyToTargetError(client, target_count);
	}
	return Action:3;
}

PerformReloadAdmins(client)
{
	DumpAdminCache(AdminCachePart:1, true);
	DumpAdminCache(AdminCachePart:0, true);
	LogAction(client, -1, "\"%L\" refreshed the admin cache.", client);
	ReplyToCommand(client, "[SM] %t", "Admin cache refreshed");
	return 0;
}

public AdminMenu_ReloadAdmins(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			PerformReloadAdmins(param);
			RedisplayAdminMenu(topmenu, param);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Reload admins", param);
	}
	return 0;
}

public Action:Command_ReloadAdmins(client, args)
{
	PerformReloadAdmins(client);
	return Action:3;
}

PerformCancelVote(client)
{
	if (!IsVoteInProgress(Handle:0))
	{
		ReplyToCommand(client, "[SM] %t", "Vote Not In Progress");
		return 0;
	}
	ShowActivity2(client, "[SM] ", "%t", "Cancelled Vote");
	CancelVote();
	return 0;
}

public AdminMenu_CancelVote(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			PerformCancelVote(param);
			RedisplayAdminMenu(topmenu, param);
		}
		if (action == TopMenuAction:3)
		{
			new var1;
			if (IsVoteInProgress(Handle:0))
			{
				var1 = 0;
			}
			else
			{
				var1 = 6;
			}
			buffer[0] = var1;
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Cancel vote", param);
	}
	return 0;
}

public Action:Command_CancelVote(client, args)
{
	PerformCancelVote(client);
	return Action:3;
}

PerformWho(client, target, ReplySource:reply, bool:is_admin)
{
	decl String:name[32];
	GetClientName(target, name, 32);
	new bool:show_name;
	new String:admin_name[32];
	new AdminId:id = GetUserAdmin(target);
	new var1;
	if (id != AdminId:-1 && GetAdminUsername(id, admin_name, 32))
	{
		show_name = true;
	}
	new ReplySource:old_reply = SetCmdReplySource(reply);
	if (id == AdminId:-1)
	{
		ReplyToCommand(client, "[SM] %t", "Player is not an admin", name);
	}
	else
	{
		if (!is_admin)
		{
			ReplyToCommand(client, "[SM] %t", "Player is an admin", name);
		}
		new flags = GetUserFlagBits(target);
		decl String:flagstring[256];
		if (flags)
		{
			if (flags & 16384)
			{
				strcopy(flagstring, 255, "root");
			}
			FlagsToString(flagstring, 255, flags);
		}
		else
		{
			strcopy(flagstring, 255, "none");
		}
		if (show_name)
		{
			ReplyToCommand(client, "[SM] %t", "Admin logged in as", name, admin_name, flagstring);
		}
		else
		{
			ReplyToCommand(client, "[SM] %t", "Admin logged in anon", name, flagstring);
		}
	}
	SetCmdReplySource(old_reply);
	return 0;
}

DisplayWhoMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_Who, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T:", "Identify player", client);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	AddTargetsToMenu2(menu, 0, 4);
	Menu.Display(menu, client, 0);
	return 0;
}

public AdminMenu_Who(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			DisplayWhoMenu(param);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Identify player", param);
	}
	return 0;
}

public MenuHandler_Who(Menu:menu, MenuAction:action, param1, param2)
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
			new userid;
			new target;
			Menu.GetItem(menu, param2, info, 32, 0, "", 0);
			userid = StringToInt(info, 10);
			if ((target = GetClientOfUserId(userid)))
			{
				if (!CanUserTarget(param1, target))
				{
					PrintToChat(param1, "[SM] %t", "Unable to target");
				}
				new var2;
				if (GetUserFlagBits(param1))
				{
					var2 = true;
				}
				else
				{
					var2 = false;
				}
				PerformWho(param1, target, ReplySource:1, var2);
			}
			else
			{
				PrintToChat(param1, "[SM] %t", "Player no longer available");
			}
		}
	}
	return 0;
}

public Action:Command_Who(client, args)
{
	new bool:is_admin;
	new var2;
	if (!client || (client && GetUserFlagBits(client)))
	{
		is_admin = true;
	}
	if (args < 1)
	{
		decl String:t_access[16];
		decl String:t_name[16];
		decl String:t_username[16];
		Format(t_access, 16, "%T", "Admin access", client);
		Format(t_name, 16, "%T", "Name", client);
		Format(t_username, 16, "%T", "Username", client);
		if (is_admin)
		{
			PrintToConsole(client, "    %-24.23s %-18.17s %s", t_name, t_username, t_access);
		}
		else
		{
			PrintToConsole(client, "    %-24.23s %s", t_name, t_access);
		}
		decl String:flagstring[256];
		new i = 1;
		while (i <= MaxClients)
		{
			if (IsClientInGame(i))
			{
				new flags = GetUserFlagBits(i);
				new AdminId:id = GetUserAdmin(i);
				if (flags)
				{
					if (flags & 16384)
					{
						strcopy(flagstring, 255, "root");
					}
					FlagsToString(flagstring, 255, flags);
				}
				else
				{
					strcopy(flagstring, 255, "none");
				}
				decl String:name[32];
				new String:username[32];
				GetClientName(i, name, 32);
				if (id != AdminId:-1)
				{
					GetAdminUsername(id, username, 32);
				}
				if (is_admin)
				{
					PrintToConsole(client, "%2d. %-24.23s %-18.17s %s", i, name, username, flagstring);
				}
				else
				{
					if (flags)
					{
						PrintToConsole(client, "%2d. %-24.23s %t", i, name, "Yes");
					}
					PrintToConsole(client, "%2d. %-24.23s %t", i, name, "No");
				}
			}
			i++;
		}
		if (GetCmdReplySource() == 1)
		{
			ReplyToCommand(client, "[SM] %t", "See console for output");
		}
		return Action:3;
	}
	decl String:arg[68];
	GetCmdArg(1, arg, 65);
	new target = FindTarget(client, arg, false, false);
	if (target == -1)
	{
		return Action:3;
	}
	PerformWho(client, target, GetCmdReplySource(), is_admin);
	return Action:3;
}

public MenuHandler_ChangeMap(Menu:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:8)
	{
		new var1;
		if (param2 == -6 && hTopMenu)
		{
			TopMenu.Display(hTopMenu, param1, TopMenuPosition:3);
		}
	}
	else
	{
		if (action == MenuAction:4)
		{
			decl String:map[64];
			Menu.GetItem(menu, param2, map, 64, 0, "", 0);
			ChangeMap(param1, map);
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

public AdminMenu_Map(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			Menu.Display(g_MapList, param, 0);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Choose Map", param);
	}
	return 0;
}

public Action:Command_Map(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_map <map>");
		return Action:3;
	}
	new String:map[64];
	GetCmdArg(1, map, 64);
	if (IsMapValid(map))
	{
		ChangeMap(client, map);
	}
	else
	{
		ReplyToCommand(client, "[SM] %t", "Map was not found", map);
	}
	return Action:3;
}

ChangeMap(client, String:map[])
{
	ShowActivity2(client, "[SM] ", "%t", "Changing map", map);
	LogAction(client, -1, "\"%L\" changed map to \"%s\"", client, map);
	ForceChangeLevel(map, "sm_map Command");
	return 0;
}

LoadMapList(Menu:menu)
{
	new Handle:map_array;
	if ((map_array = ReadMapList(g_map_array, g_map_serial, "sm_map menu", 7)))
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

PerformExec(client, String:path[])
{
	if (!FileExists(path, false, "GAME"))
	{
		ReplyToCommand(client, "[SM] %t", "Config not found", path[1]);
		return 0;
	}
	ShowActivity2(client, "[SM] ", "%t", "Executed config", path[1]);
	LogAction(client, -1, "\"%L\" executed config (file \"%s\")", client, path[1]);
	ServerCommand("exec \"%s\"", path[1]);
	return 0;
}

public AdminMenu_ExecCFG(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			Menu.Display(g_ConfigMenu, param, 0);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Exec CFG", param);
	}
	return 0;
}

public MenuHandler_ExecCFG(Menu:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:8)
	{
		new var1;
		if (param2 == -6 && hTopMenu)
		{
			TopMenu.Display(hTopMenu, param1, TopMenuPosition:3);
		}
	}
	else
	{
		if (action == MenuAction:4)
		{
			decl String:path[256];
			Menu.GetItem(menu, param2, path, 256, 0, "", 0);
			PerformExec(param1, path);
		}
		if (action == MenuAction:2)
		{
			decl String:title[128];
			Format(title, 128, "%T", "Choose Config", param1);
			SetPanelTitle(param2, title, false);
		}
	}
	return 0;
}

public Action:Command_ExecCfg(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_execcfg <filename>");
		return Action:3;
	}
	new String:path[64];
	GetCmdArg(1, path[1], 60);
	PerformExec(client, path);
	return Action:3;
}

ParseConfigs()
{
	if (!config_parser)
	{
		config_parser = SMCParser.SMCParser();
	}
	SMCParser.OnEnterSection.set(config_parser, NewSection);
	SMCParser.OnLeaveSection.set(config_parser, EndSection);
	SMCParser.OnKeyValue.set(config_parser, KeyValue);
	if (g_ConfigMenu)
	{
		CloseHandle(g_ConfigMenu);
		g_ConfigMenu = MissingTAG:0;
	}
	g_ConfigMenu = CreateMenu(MenuHandler_ExecCFG, MenuAction:2);
	Menu.SetTitle(g_ConfigMenu, "%T", "Choose Config", 0);
	Menu.ExitBackButton.set(g_ConfigMenu, true);
	decl String:configPath[256];
	BuildPath(PathType:0, configPath, 256, "configs/adminmenu_cfgs.txt");
	if (!FileExists(configPath, false, "GAME"))
	{
		LogError("Unable to locate exec config file, no maps loaded.");
		return 0;
	}
	new line;
	new SMCError:err = SMCParser.ParseFile(config_parser, configPath, line, 0);
	if (err)
	{
		decl String:error[256];
		SMC_GetErrorString(err, error, 256);
		LogError("Could not parse file (line %d, file \"%s\"):", line, configPath);
		LogError("Parser encountered error: %s", error);
	}
	return 0;
}

public SMCResult:NewSection(SMCParser:smc, String:name[], bool:opt_quotes)
{
	return SMCResult:0;
}

public SMCResult:KeyValue(SMCParser:smc, String:key[], String:value[], bool:key_quotes, bool:value_quotes)
{
	Menu.AddItem(g_ConfigMenu, key, value, 0);
	return SMCResult:0;
}

public SMCResult:EndSection(SMCParser:smc)
{
	return SMCResult:0;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("plugin.basecommands");
	RegAdminCmd("sm_kick", Command_Kick, 4, "sm_kick <#userid|name> [reason]", "", 0);
	RegAdminCmd("sm_map", Command_Map, 64, "sm_map <map>", "", 0);
	RegAdminCmd("sm_rcon", Command_Rcon, 4096, "sm_rcon <args>", "", 0);
	RegAdminCmd("sm_cvar", Command_Cvar, 128, "sm_cvar <cvar> [value]", "", 0);
	RegAdminCmd("sm_resetcvar", Command_ResetCvar, 128, "sm_resetcvar <cvar>", "", 0);
	RegAdminCmd("sm_execcfg", Command_ExecCfg, 256, "sm_execcfg <filename>", "", 0);
	RegAdminCmd("sm_who", Command_Who, 2, "sm_who [#userid|name]", "", 0);
	RegAdminCmd("sm_reloadadmins", Command_ReloadAdmins, 8, "sm_reloadadmins", "", 0);
	RegAdminCmd("sm_cancelvote", Command_CancelVote, 1024, "sm_cancelvote", "", 0);
	RegConsoleCmd("sm_revote", Command_ReVote, "", 0);
	new TopMenu:topmenu;
	new var1;
	if (LibraryExists("adminmenu") && (topmenu = GetAdminTopMenu()))
	{
		OnAdminMenuReady(topmenu);
	}
	g_MapList = CreateMenu(MenuHandler_ChangeMap, MenuAction:2);
	Menu.SetTitle(g_MapList, "%T", "Please select a map", 0);
	Menu.ExitBackButton.set(g_MapList, true);
	new String:mapListPath[256];
	BuildPath(PathType:0, mapListPath, 256, "configs/adminmenu_maplist.ini");
	SetMapListCompatBind("sm_map menu", mapListPath);
	g_ProtectedVars = CreateTrie();
	ProtectVar("rcon_password");
	ProtectVar("sm_show_activity");
	ProtectVar("sm_immunity_mode");
	return void:0;
}

public void:OnMapStart()
{
	ParseConfigs();
	return void:0;
}

public void:OnConfigsExecuted()
{
	LoadMapList(g_MapList);
	return void:0;
}

ProtectVar(String:cvar[])
{
	SetTrieValue(g_ProtectedVars, cvar, any:1, true);
	return 0;
}

bool:IsVarProtected(String:cvar[])
{
	decl dummy_value;
	return GetTrieValue(g_ProtectedVars, cvar, dummy_value);
}

bool:IsClientAllowedToChangeCvar(client, String:cvarname[])
{
	new ConVar:hndl = FindConVar(cvarname);
	new bool:allowed;
	decl client_flags;
	new var1;
	if (client)
	{
		var1 = GetUserFlagBits(client);
	}
	else
	{
		var1 = 16384;
	}
	client_flags = var1;
	if (client_flags & 16384)
	{
		allowed = true;
	}
	else
	{
		if (ConVar.Flags.get(hndl) & 32)
		{
			allowed = client_flags & 2048 == 2048;
		}
		if (StrEqual(cvarname, "sv_cheats", true))
		{
			allowed = client_flags & 8192 == 8192;
		}
		if (!IsVarProtected(cvarname))
		{
			allowed = true;
		}
	}
	return allowed;
}

public void:OnAdminMenuReady(Handle:aTopMenu)
{
	new TopMenu:topmenu = TopMenu.FromHandle(aTopMenu);
	if (hTopMenu == topmenu)
	{
		return void:0;
	}
	hTopMenu = topmenu;
	new TopMenuObject:player_commands = TopMenu.FindCategory(hTopMenu, "PlayerCommands");
	if (player_commands)
	{
		TopMenu.AddItem(hTopMenu, "sm_kick", AdminMenu_Kick, player_commands, "sm_kick", 4, "");
		TopMenu.AddItem(hTopMenu, "sm_who", AdminMenu_Who, player_commands, "sm_who", 2, "");
	}
	new TopMenuObject:server_commands = TopMenu.FindCategory(hTopMenu, "ServerCommands");
	if (server_commands)
	{
		TopMenu.AddItem(hTopMenu, "sm_reloadadmins", AdminMenu_ReloadAdmins, server_commands, "sm_reloadadmins", 8, "");
		TopMenu.AddItem(hTopMenu, "sm_map", AdminMenu_Map, server_commands, "sm_map", 64, "");
		TopMenu.AddItem(hTopMenu, "sm_execcfg", AdminMenu_ExecCFG, server_commands, "sm_execcfg", 256, "");
	}
	new TopMenuObject:voting_commands = TopMenu.FindCategory(hTopMenu, "VotingCommands");
	if (voting_commands)
	{
		TopMenu.AddItem(hTopMenu, "sm_cancelvote", AdminMenu_CancelVote, voting_commands, "sm_cancelvote", 1024, "");
	}
	return void:0;
}

public void:OnLibraryRemoved(String:name[])
{
	if (!(strcmp(name, "adminmenu", true)))
	{
		hTopMenu = MissingTAG:0;
	}
	return void:0;
}

CustomFlagsToString(String:buffer[], maxlength, flags)
{
	new String:joins[6][8] = "";
	new total;
	new i = 15;
	while (i <= 20)
	{
		if (1 << i & flags)
		{
			total++;
			IntToString(i + -14, joins[total], 6);
		}
		i++;
	}
	ImplodeStrings(joins, total, ",", buffer, maxlength);
	return total;
}

FlagsToString(String:buffer[], maxlength, flags)
{
	new String:joins[15][32] = "<";
	new total;
	new i;
	while (i < 14)
	{
		if (1 << i & flags)
		{
			total++;
			strcopy(joins[total], 32, g_FlagNames[i]);
		}
		i++;
	}
	new String:custom_flags[32];
	if (CustomFlagsToString(custom_flags, 32, flags))
	{
		total++;
		Format(joins[total], 32, "custom(%s)", custom_flags);
	}
	ImplodeStrings(joins, total, ", ", buffer, maxlength);
	return 0;
}

public Action:Command_Cvar(client, args)
{
	if (args < 1)
	{
		if (client)
		{
			ReplyToCommand(client, "[SM] Usage: sm_cvar <cvar> [value]");
		}
		else
		{
			ReplyToCommand(client, "[SM] Usage: sm_cvar <cvar|protect> [value]");
		}
		return Action:3;
	}
	new String:cvarname[64];
	GetCmdArg(1, cvarname, 64);
	new var1;
	if (client && StrEqual(cvarname, "protect", true))
	{
		if (args < 2)
		{
			ReplyToCommand(client, "[SM] Usage: sm_cvar <protect> <cvar>");
			return Action:3;
		}
		GetCmdArg(2, cvarname, 64);
		ProtectVar(cvarname);
		ReplyToCommand(client, "[SM] %t", "Cvar is now protected", cvarname);
		return Action:3;
	}
	new ConVar:hndl = FindConVar(cvarname);
	if (hndl)
	{
		if (!IsClientAllowedToChangeCvar(client, cvarname))
		{
			ReplyToCommand(client, "[SM] %t", "No access to cvar");
			return Action:3;
		}
		new String:value[256];
		if (args < 2)
		{
			ConVar.GetString(hndl, value, 255);
			ReplyToCommand(client, "[SM] %t", "Value of cvar", cvarname, value);
			return Action:3;
		}
		GetCmdArg(2, value, 255);
		if (ConVar.Flags.get(hndl) & 32 != 32)
		{
			ShowActivity2(client, "[SM] ", "%t", "Cvar changed", cvarname, value);
		}
		else
		{
			ReplyToCommand(client, "[SM] %t", "Cvar changed", cvarname, value);
		}
		LogAction(client, -1, "\"%L\" changed cvar (cvar \"%s\") (value \"%s\")", client, cvarname, value);
		ConVar.SetString(hndl, value, true, false);
		return Action:3;
	}
	ReplyToCommand(client, "[SM] %t", "Unable to find cvar", cvarname);
	return Action:3;
}

public Action:Command_ResetCvar(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_resetcvar <cvar>");
		return Action:3;
	}
	new String:cvarname[64];
	GetCmdArg(1, cvarname, 64);
	new ConVar:hndl = FindConVar(cvarname);
	if (hndl)
	{
		if (!IsClientAllowedToChangeCvar(client, cvarname))
		{
			ReplyToCommand(client, "[SM] %t", "No access to cvar");
			return Action:3;
		}
		ConVar.RestoreDefault(hndl, false, false);
		new String:value[256];
		ConVar.GetString(hndl, value, 255);
		if (ConVar.Flags.get(hndl) & 32 != 32)
		{
			ShowActivity2(client, "[SM] ", "%t", "Cvar changed", cvarname, value);
		}
		else
		{
			ReplyToCommand(client, "[SM] %t", "Cvar changed", cvarname, value);
		}
		LogAction(client, -1, "\"%L\" reset cvar (cvar \"%s\") (value \"%s\")", client, cvarname, value);
		return Action:3;
	}
	ReplyToCommand(client, "[SM] %t", "Unable to find cvar", cvarname);
	return Action:3;
}

public Action:Command_Rcon(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_rcon <args>");
		return Action:3;
	}
	new String:argstring[256];
	GetCmdArgString(argstring, 255);
	LogAction(client, -1, "\"%L\" console command (cmdline \"%s\")", client, argstring);
	if (client)
	{
		new String:responseBuffer[4096];
		ServerCommandEx(responseBuffer, 4096, "%s", argstring);
		ReplyToCommand(client, responseBuffer);
	}
	else
	{
		ServerCommand("%s", argstring);
	}
	return Action:3;
}

public Action:Command_ReVote(client, args)
{
	if (client)
	{
		if (!IsVoteInProgress(Handle:0))
		{
			ReplyToCommand(client, "[SM] %t", "Vote Not In Progress");
			return Action:3;
		}
		if (!IsClientInVotePool(client))
		{
			ReplyToCommand(client, "[SM] %t", "Cannot participate in vote");
			return Action:3;
		}
		if (!RedrawClientVoteMenu(client, true))
		{
			ReplyToCommand(client, "[SM] %t", "Cannot change vote");
		}
		return Action:3;
	}
	ReplyToCommand(client, "[SM] %t", "Command is in-game only");
	return Action:3;
}

