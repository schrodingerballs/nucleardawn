public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "04:34:23"
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
	name = "Player Commands",
	description = "Misc. Player Commands",
	author = "AlliedModders LLC",
	version = "1.7.0",
	url = "http://www.sourcemod.net/"
};
new TopMenu:hTopMenu;
new EngineVersion:g_ModVersion;
new g_SlapDamage[66];
new String:g_NewName[66][32];
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

PerformSlay(client, target)
{
	LogAction(client, target, "\"%L\" slayed \"%L\"", client, target);
	ForcePlayerSuicide(target);
	return 0;
}

DisplaySlayMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_Slay, MenuAction:28);
	new String:title[100];
	Format(title, 100, "%T:", "Slay player", client);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	AddTargetsToMenu(menu, client, true, true);
	Menu.Display(menu, client, 0);
	return 0;
}

public AdminMenu_Slay(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			DisplaySlayMenu(param);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Slay player", param);
	}
	return 0;
}

public MenuHandler_Slay(Menu:menu, MenuAction:action, param1, param2)
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
			new String:info[32];
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
				if (!IsPlayerAlive(target))
				{
					ReplyToCommand(param1, "[SM] %t", "Player has since died");
				}
				decl String:name[32];
				GetClientName(target, name, 32);
				PerformSlay(param1, target);
				ShowActivity2(param1, "[SM] ", "%t", "Slayed target", "_s", name);
			}
			else
			{
				PrintToChat(param1, "[SM] %t", "Player no longer available");
			}
			DisplaySlayMenu(param1);
		}
	}
	return 0;
}

public Action:Command_Slay(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_slay <#userid|name>");
		return Action:3;
	}
	decl String:arg[68];
	GetCmdArg(1, arg, 65);
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 1, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	new i;
	while (i < target_count)
	{
		PerformSlay(client, target_list[i]);
		i++;
	}
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Slayed target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Slayed target", "_s", target_name);
	}
	return Action:3;
}

PerformSlap(client, target, damage)
{
	LogAction(client, target, "\"%L\" slapped \"%L\" (damage \"%d\")", client, target, damage);
	SlapPlayer(target, damage, true);
	return 0;
}

DisplaySlapDamageMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_SlapDamage, MenuAction:28);
	new String:title[100];
	Format(title, 100, "%T:", "Slap damage", client);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	Menu.AddItem(menu, "0", "0", 0);
	Menu.AddItem(menu, "1", "1", 0);
	Menu.AddItem(menu, "5", "5", 0);
	Menu.AddItem(menu, "10", "10", 0);
	Menu.AddItem(menu, "20", "20", 0);
	Menu.AddItem(menu, "50", "50", 0);
	Menu.AddItem(menu, "99", "99", 0);
	Menu.Display(menu, client, 0);
	return 0;
}

DisplaySlapTargetMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_Slap, MenuAction:28);
	new String:title[100];
	Format(title, 100, "%T: %d damage", "Slap player", client, g_SlapDamage[client]);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	AddTargetsToMenu(menu, client, true, true);
	Menu.Display(menu, client, 0);
	return 0;
}

public AdminMenu_Slap(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			DisplaySlapDamageMenu(param);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Slap player", param);
	}
	return 0;
}

public MenuHandler_SlapDamage(Menu:menu, MenuAction:action, param1, param2)
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
			new String:info[32];
			Menu.GetItem(menu, param2, info, 32, 0, "", 0);
			g_SlapDamage[param1] = StringToInt(info, 10);
			DisplaySlapTargetMenu(param1);
		}
	}
	return 0;
}

public MenuHandler_Slap(Menu:menu, MenuAction:action, param1, param2)
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
			if (param2 == -6)
			{
				TopMenu.Display(hTopMenu, param1, TopMenuPosition:3);
			}
		}
		if (action == MenuAction:4)
		{
			new String:info[32];
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
				if (!IsPlayerAlive(target))
				{
					ReplyToCommand(param1, "[SM] %t", "Player has since died");
				}
				decl String:name[32];
				GetClientName(target, name, 32);
				PerformSlap(param1, target, g_SlapDamage[param1]);
				ShowActivity2(param1, "[SM] ", "%t", "Slapped target", "_s", name);
			}
			else
			{
				PrintToChat(param1, "[SM] %t", "Player no longer available");
			}
			DisplaySlapTargetMenu(param1);
		}
	}
	return 0;
}

public Action:Command_Slap(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_slap <#userid|name> [damage]");
		return Action:3;
	}
	decl String:arg[68];
	GetCmdArg(1, arg, 65);
	new damage;
	if (args > 1)
	{
		decl String:arg2[20];
		GetCmdArg(2, arg2, 20);
		new var1;
		if (StringToIntEx(arg2, damage, 10) && damage < 0)
		{
			ReplyToCommand(client, "[SM] %t", "Invalid Amount");
			return Action:3;
		}
	}
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 1, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	new i;
	while (i < target_count)
	{
		PerformSlap(client, target_list[i], damage);
		i++;
	}
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Slapped target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Slapped target", "_s", target_name);
	}
	return Action:3;
}

PerformRename(client, target)
{
	LogAction(client, target, "\"%L\" renamed \"%L\" to \"%s\")", client, target, g_NewName[target]);
	if (g_ModVersion != EngineVersion:2)
	{
		SetClientInfo(target, "name", g_NewName[target]);
	}
	else
	{
		if (!IsPlayerAlive(target))
		{
			decl String:m_TargetName[32];
			GetClientName(target, m_TargetName, 32);
			ReplyToCommand(client, "[SM] %t", "Dead Player Rename", m_TargetName);
		}
		ClientCommand(target, "name %s", g_NewName[target]);
	}
	g_NewName[target][0] = MissingTAG:0;
	return 0;
}

public AdminMenu_Rename(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			DisplayRenameTargetMenu(param);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Rename player", param);
	}
	return 0;
}

DisplayRenameTargetMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_Rename, MenuAction:28);
	new String:title[100];
	Format(title, 100, "%T:", "Rename player", client);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	AddTargetsToMenu(menu, client, true, false);
	Menu.Display(menu, client, 0);
	return 0;
}

public MenuHandler_Rename(Menu:menu, MenuAction:action, param1, param2)
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
				RandomizeName(target);
				ShowActivity2(param1, "[SM] ", "%t", "Renamed target", "_s", name);
				PerformRename(param1, target);
			}
			else
			{
				PrintToChat(param1, "[SM] %t", "Player no longer available");
			}
			DisplayRenameTargetMenu(param1);
		}
	}
	return 0;
}

RandomizeName(client)
{
	decl String:name[32];
	GetClientName(client, name, 32);
	new len = strlen(name);
	g_NewName[client][0] = MissingTAG:0;
	new i;
	while (i < len)
	{
		g_NewName[client][i] = name[GetRandomInt(0, len + -1)];
		i++;
	}
	g_NewName[client][len] = MissingTAG:0;
	return 0;
}

public Action:Command_Rename(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_rename <#userid|name> [newname]");
		return Action:3;
	}
	decl String:arg[32];
	decl String:arg2[32];
	GetCmdArg(1, arg, 32);
	new bool:randomize;
	if (args > 1)
	{
		GetCmdArg(2, arg2, 32);
	}
	else
	{
		randomize = true;
	}
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 < (target_count = ProcessTargetString(arg, client, target_list, 65, 0, target_name, 64, tn_is_ml)))
	{
		if (tn_is_ml)
		{
			ShowActivity2(client, "[SM] ", "%t", "Renamed target", target_name);
		}
		else
		{
			ShowActivity2(client, "[SM] ", "%t", "Renamed target", "_s", target_name);
		}
		if (target_count > 1)
		{
			randomize = true;
		}
		new i;
		while (i < target_count)
		{
			if (randomize)
			{
				RandomizeName(target_list[i]);
			}
			else
			{
				Format(g_NewName[target_list[i]], 32, "%s", arg2);
			}
			PerformRename(client, target_list[i]);
			i++;
		}
	}
	else
	{
		ReplyToTargetError(client, target_count);
	}
	return Action:3;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("playercommands.phrases");
	RegAdminCmd("sm_slap", Command_Slap, 32, "sm_slap <#userid|name> [damage]", "", 0);
	RegAdminCmd("sm_slay", Command_Slay, 32, "sm_slay <#userid|name>", "", 0);
	RegAdminCmd("sm_rename", Command_Rename, 32, "sm_rename <#userid|name>", "", 0);
	g_ModVersion = GetEngineVersion();
	new TopMenu:topmenu;
	new var1;
	if (LibraryExists("adminmenu") && (topmenu = GetAdminTopMenu()))
	{
		OnAdminMenuReady(topmenu);
	}
	return void:0;
}

public OnAdminMenuReady(Handle:aTopMenu)
{
	new TopMenu:topmenu = TopMenu.FromHandle(aTopMenu);
	if (hTopMenu == topmenu)
	{
		return 0;
	}
	hTopMenu = topmenu;
	new TopMenuObject:player_commands = TopMenu.FindCategory(hTopMenu, "PlayerCommands");
	if (player_commands)
	{
		TopMenu.AddItem(hTopMenu, "sm_slay", AdminMenu_Slay, player_commands, "sm_slay", 32, "");
		TopMenu.AddItem(hTopMenu, "sm_slap", AdminMenu_Slap, player_commands, "sm_slap", 32, "");
		TopMenu.AddItem(hTopMenu, "sm_rename", AdminMenu_Rename, player_commands, "sm_rename", 32, "");
	}
	return 0;
}

