public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "04:34:20"
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
	name = "Basic Comm Control",
	description = "Provides methods of controlling communication.",
	author = "AlliedModders LLC",
	version = "1.7.0",
	url = "http://www.sourcemod.net/"
};
new bool:g_Muted[66];
new bool:g_Gagged[66];
new ConVar:g_Cvar_Deadtalk;
new ConVar:g_Cvar_Alltalk;
new bool:g_Hooked;
new TopMenu:hTopMenu;
new g_GagTarget[66];
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

DisplayGagTypesMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_GagTypes, MenuAction:28);
	decl String:title[100];
	Format(title, 100, "%T: %N", "Choose Type", client, g_GagTarget[client]);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	new target = g_GagTarget[client];
	if (!g_Muted[target])
	{
		AddTranslatedMenuItem(menu, "0", "Mute Player", client);
	}
	else
	{
		AddTranslatedMenuItem(menu, "1", "UnMute Player", client);
	}
	if (!g_Gagged[target])
	{
		AddTranslatedMenuItem(menu, "2", "Gag Player", client);
	}
	else
	{
		AddTranslatedMenuItem(menu, "3", "UnGag Player", client);
	}
	new var1;
	if (!g_Muted[target] || !g_Gagged[target])
	{
		AddTranslatedMenuItem(menu, "4", "Silence Player", client);
	}
	else
	{
		AddTranslatedMenuItem(menu, "5", "UnSilence Player", client);
	}
	Menu.Display(menu, client, 0);
	return 0;
}

void:AddTranslatedMenuItem(Menu:menu, String:opt[], String:phrase[], client)
{
	new String:buffer[128];
	Format(buffer, 128, "%T", phrase, client);
	Menu.AddItem(menu, opt, buffer, 0);
	return void:0;
}

void:DisplayGagPlayerMenu(client)
{
	new Menu:menu = CreateMenu(MenuHandler_GagPlayer, MenuAction:28);
	new String:title[100];
	Format(title, 100, "%T:", "Gag/Mute player", client);
	Menu.SetTitle(menu, title);
	Menu.ExitBackButton.set(menu, true);
	AddTargetsToMenu(menu, client, true, false);
	Menu.Display(menu, client, 0);
	return void:0;
}

public AdminMenu_Gag(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			DisplayGagPlayerMenu(param);
		}
	}
	else
	{
		Format(buffer, maxlength, "%T", "Gag/Mute player", param);
	}
	return 0;
}

public MenuHandler_GagPlayer(Menu:menu, MenuAction:action, param1, param2)
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
				g_GagTarget[param1] = GetClientOfUserId(userid);
				DisplayGagTypesMenu(param1);
			}
			else
			{
				PrintToChat(param1, "[SM] %t", "Player no longer available");
			}
		}
	}
	return 0;
}

public MenuHandler_GagTypes(Menu:menu, MenuAction:action, param1, param2)
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
			new CommType:type;
			Menu.GetItem(menu, param2, info, 32, 0, "", 0);
			type = StringToInt(info, 10);
			decl String:name[32];
			GetClientName(g_GagTarget[param1], name, 32);
			switch (type)
			{
				case 0:
				{
					PerformMute(param1, g_GagTarget[param1], false);
					ShowActivity2(param1, "[SM] ", "%t", "Muted target", "_s", name);
				}
				case 1:
				{
					PerformUnMute(param1, g_GagTarget[param1], false);
					ShowActivity2(param1, "[SM] ", "%t", "Unmuted target", "_s", name);
				}
				case 2:
				{
					PerformGag(param1, g_GagTarget[param1], false);
					ShowActivity2(param1, "[SM] ", "%t", "Gagged target", "_s", name);
				}
				case 3:
				{
					PerformUnGag(param1, g_GagTarget[param1], false);
					ShowActivity2(param1, "[SM] ", "%t", "Ungagged target", "_s", name);
				}
				case 4:
				{
					PerformSilence(param1, g_GagTarget[param1]);
					ShowActivity2(param1, "[SM] ", "%t", "Silenced target", "_s", name);
				}
				case 5:
				{
					PerformUnSilence(param1, g_GagTarget[param1]);
					ShowActivity2(param1, "[SM] ", "%t", "Unsilenced target", "_s", name);
				}
				default:
				{
				}
			}
		}
	}
	return 0;
}

PerformMute(client, target, bool:silent)
{
	g_Muted[target] = 1;
	SetClientListeningFlags(target, 1);
	FireOnClientMute(target, true);
	if (!silent)
	{
		LogAction(client, target, "\"%L\" muted \"%L\"", client, target);
	}
	return 0;
}

PerformUnMute(client, target, bool:silent)
{
	g_Muted[target] = 0;
	new var1;
	if (ConVar.IntValue.get(g_Cvar_Deadtalk) == 1 && !IsPlayerAlive(target))
	{
		SetClientListeningFlags(target, 4);
	}
	else
	{
		new var2;
		if (ConVar.IntValue.get(g_Cvar_Deadtalk) == 2 && !IsPlayerAlive(target))
		{
			SetClientListeningFlags(target, 8);
		}
		SetClientListeningFlags(target, 0);
	}
	FireOnClientMute(target, false);
	if (!silent)
	{
		LogAction(client, target, "\"%L\" unmuted \"%L\"", client, target);
	}
	return 0;
}

PerformGag(client, target, bool:silent)
{
	g_Gagged[target] = 1;
	FireOnClientGag(target, true);
	if (!silent)
	{
		LogAction(client, target, "\"%L\" gagged \"%L\"", client, target);
	}
	return 0;
}

PerformUnGag(client, target, bool:silent)
{
	g_Gagged[target] = 0;
	FireOnClientGag(target, false);
	if (!silent)
	{
		LogAction(client, target, "\"%L\" ungagged \"%L\"", client, target);
	}
	return 0;
}

PerformSilence(client, target)
{
	if (!g_Gagged[target])
	{
		g_Gagged[target] = 1;
		FireOnClientGag(target, true);
	}
	if (!g_Muted[target])
	{
		g_Muted[target] = 1;
		SetClientListeningFlags(target, 1);
		FireOnClientMute(target, true);
	}
	LogAction(client, target, "\"%L\" silenced \"%L\"", client, target);
	return 0;
}

PerformUnSilence(client, target)
{
	if (g_Gagged[target])
	{
		g_Gagged[target] = 0;
		FireOnClientGag(target, false);
	}
	if (g_Muted[target])
	{
		g_Muted[target] = 0;
		new var1;
		if (ConVar.IntValue.get(g_Cvar_Deadtalk) == 1 && !IsPlayerAlive(target))
		{
			SetClientListeningFlags(target, 4);
		}
		else
		{
			new var2;
			if (ConVar.IntValue.get(g_Cvar_Deadtalk) == 2 && !IsPlayerAlive(target))
			{
				SetClientListeningFlags(target, 8);
			}
			SetClientListeningFlags(target, 0);
		}
		FireOnClientMute(target, false);
	}
	LogAction(client, target, "\"%L\" unsilenced \"%L\"", client, target);
	return 0;
}

public Action:Command_Mute(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_mute <player>");
		return Action:3;
	}
	decl String:arg[64];
	GetCmdArg(1, arg, 64);
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 0, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	new i;
	while (i < target_count)
	{
		new target = target_list[i];
		PerformMute(client, target, false);
		i++;
	}
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Muted target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Muted target", "_s", target_name);
	}
	return Action:3;
}

public Action:Command_Gag(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_gag <player>");
		return Action:3;
	}
	decl String:arg[64];
	GetCmdArg(1, arg, 64);
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 0, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	new i;
	while (i < target_count)
	{
		new target = target_list[i];
		PerformGag(client, target, false);
		i++;
	}
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Gagged target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Gagged target", "_s", target_name);
	}
	return Action:3;
}

public Action:Command_Silence(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_silence <player>");
		return Action:3;
	}
	decl String:arg[64];
	GetCmdArg(1, arg, 64);
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 0, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	new i;
	while (i < target_count)
	{
		new target = target_list[i];
		PerformSilence(client, target);
		i++;
	}
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Silenced target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Silenced target", "_s", target_name);
	}
	return Action:3;
}

public Action:Command_Unmute(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_unmute <player>");
		return Action:3;
	}
	decl String:arg[64];
	GetCmdArg(1, arg, 64);
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 0, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	new i;
	while (i < target_count)
	{
		new target = target_list[i];
		if (g_Muted[target])
		{
			PerformUnMute(client, target, false);
		}
		i++;
	}
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Unmuted target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Unmuted target", "_s", target_name);
	}
	return Action:3;
}

public Action:Command_Ungag(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_ungag <player>");
		return Action:3;
	}
	decl String:arg[64];
	GetCmdArg(1, arg, 64);
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 0, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	new i;
	while (i < target_count)
	{
		new target = target_list[i];
		PerformUnGag(client, target, false);
		i++;
	}
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Ungagged target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Ungagged target", "_s", target_name);
	}
	return Action:3;
}

public Action:Command_Unsilence(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_unsilence <player>");
		return Action:3;
	}
	decl String:arg[64];
	GetCmdArg(1, arg, 64);
	decl String:target_name[64];
	decl target_list[65];
	decl target_count;
	decl bool:tn_is_ml;
	if (0 >= (target_count = ProcessTargetString(arg, client, target_list, 65, 0, target_name, 64, tn_is_ml)))
	{
		ReplyToTargetError(client, target_count);
		return Action:3;
	}
	new i;
	while (i < target_count)
	{
		new target = target_list[i];
		PerformUnSilence(client, target);
		i++;
	}
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Unsilenced target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Unsilenced target", "_s", target_name);
	}
	return Action:3;
}

public Native_IsClientGagged(Handle:hPlugin, numParams)
{
	new client = GetNativeCell(1);
	new var1;
	if (client < 1 || client > MaxClients)
	{
		return ThrowNativeError(23, "Invalid client index %d", client);
	}
	if (!IsClientInGame(client))
	{
		return ThrowNativeError(23, "Client %d is not in game", client);
	}
	return g_Gagged[client];
}

public Native_IsClientMuted(Handle:hPlugin, numParams)
{
	new client = GetNativeCell(1);
	new var1;
	if (client < 1 || client > MaxClients)
	{
		return ThrowNativeError(23, "Invalid client index %d", client);
	}
	if (!IsClientInGame(client))
	{
		return ThrowNativeError(23, "Client %d is not in game", client);
	}
	return g_Muted[client];
}

public Native_SetClientGag(Handle:hPlugin, numParams)
{
	new client = GetNativeCell(1);
	new var1;
	if (client < 1 || client > MaxClients)
	{
		return ThrowNativeError(23, "Invalid client index %d", client);
	}
	if (!IsClientInGame(client))
	{
		return ThrowNativeError(23, "Client %d is not in game", client);
	}
	new bool:gagState = GetNativeCell(2);
	if (gagState)
	{
		if (g_Gagged[client])
		{
			return 0;
		}
		PerformGag(-1, client, true);
	}
	else
	{
		if (!g_Gagged[client])
		{
			return 0;
		}
		PerformUnGag(-1, client, true);
	}
	return 1;
}

public Native_SetClientMute(Handle:hPlugin, numParams)
{
	new client = GetNativeCell(1);
	new var1;
	if (client < 1 || client > MaxClients)
	{
		return ThrowNativeError(23, "Invalid client index %d", client);
	}
	if (!IsClientInGame(client))
	{
		return ThrowNativeError(23, "Client %d is not in game", client);
	}
	new bool:muteState = GetNativeCell(2);
	if (muteState)
	{
		if (g_Muted[client])
		{
			return 0;
		}
		PerformMute(-1, client, true);
	}
	else
	{
		if (!g_Muted[client])
		{
			return 0;
		}
		PerformUnMute(-1, client, true);
	}
	return 1;
}

FireOnClientMute(client, bool:muteState)
{
	static Handle:hForward;
	if (!hForward)
	{
		hForward = CreateGlobalForward("BaseComm_OnClientMute", ExecType:0, 2, 2);
	}
	Call_StartForward(hForward);
	Call_PushCell(client);
	Call_PushCell(muteState);
	Call_Finish(0);
	return 0;
}

FireOnClientGag(client, bool:gagState)
{
	static Handle:hForward;
	if (!hForward)
	{
		hForward = CreateGlobalForward("BaseComm_OnClientGag", ExecType:0, 2, 2);
	}
	Call_StartForward(hForward);
	Call_PushCell(client);
	Call_PushCell(gagState);
	Call_Finish(0);
	return 0;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("BaseComm_IsClientGagged", Native_IsClientGagged);
	CreateNative("BaseComm_IsClientMuted", Native_IsClientMuted);
	CreateNative("BaseComm_SetClientGag", Native_SetClientGag);
	CreateNative("BaseComm_SetClientMute", Native_SetClientMute);
	RegPluginLibrary("basecomm");
	return APLRes:0;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("basecomm.phrases");
	g_Cvar_Deadtalk = CreateConVar("sm_deadtalk", "0", "Controls how dead communicate. 0 - Off. 1 - Dead players ignore teams. 2 - Dead players talk to living teammates.", 0, true, 0.0, true, 2.0);
	g_Cvar_Alltalk = FindConVar("sv_alltalk");
	RegAdminCmd("sm_mute", Command_Mute, 512, "sm_mute <player> - Removes a player's ability to use voice.", "", 0);
	RegAdminCmd("sm_gag", Command_Gag, 512, "sm_gag <player> - Removes a player's ability to use chat.", "", 0);
	RegAdminCmd("sm_silence", Command_Silence, 512, "sm_silence <player> - Removes a player's ability to use voice or chat.", "", 0);
	RegAdminCmd("sm_unmute", Command_Unmute, 512, "sm_unmute <player> - Restores a player's ability to use voice.", "", 0);
	RegAdminCmd("sm_ungag", Command_Ungag, 512, "sm_ungag <player> - Restores a player's ability to use chat.", "", 0);
	RegAdminCmd("sm_unsilence", Command_Unsilence, 512, "sm_unsilence <player> - Restores a player's ability to use voice and chat.", "", 0);
	ConVar.AddChangeHook(g_Cvar_Deadtalk, ConVarChange_Deadtalk);
	ConVar.AddChangeHook(g_Cvar_Alltalk, ConVarChange_Alltalk);
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
		TopMenu.AddItem(hTopMenu, "sm_gag", AdminMenu_Gag, player_commands, "sm_gag", 512, "");
	}
	return 0;
}

public ConVarChange_Deadtalk(Handle:convar, String:oldValue[], String:newValue[])
{
	if (ConVar.IntValue.get(g_Cvar_Deadtalk))
	{
		HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode:1);
		HookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
		g_Hooked = true;
	}
	else
	{
		if (g_Hooked)
		{
			UnhookEvent("player_spawn", Event_PlayerSpawn, EventHookMode:1);
			UnhookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
			g_Hooked = false;
		}
	}
	return 0;
}

public bool:OnClientConnect(client, String:rejectmsg[], maxlen)
{
	g_Gagged[client] = 0;
	g_Muted[client] = 0;
	return true;
}

public Action:OnClientSayCommand(client, String:command[], String:sArgs[])
{
	new var1;
	if (client && g_Gagged[client])
	{
		return Action:4;
	}
	return Action:0;
}

public void:ConVarChange_Alltalk(ConVar:convar, String:oldValue[], String:newValue[])
{
	new mode = ConVar.IntValue.get(g_Cvar_Deadtalk);
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			if (g_Muted[i])
			{
				SetClientListeningFlags(i, 1);
			}
			else
			{
				if (ConVar.BoolValue.get(g_Cvar_Alltalk))
				{
					SetClientListeningFlags(i, 0);
				}
				if (!IsPlayerAlive(i))
				{
					if (mode == 1)
					{
						SetClientListeningFlags(i, 4);
					}
					if (mode == 2)
					{
						SetClientListeningFlags(i, 8);
					}
				}
			}
		}
		i++;
	}
	return void:0;
}

public Event_PlayerSpawn(Event:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(Event.GetInt(event, "userid", 0));
	if (!client)
	{
		return 0;
	}
	if (g_Muted[client])
	{
		SetClientListeningFlags(client, 1);
	}
	else
	{
		SetClientListeningFlags(client, 0);
	}
	return 0;
}

public Event_PlayerDeath(Event:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(Event.GetInt(event, "userid", 0));
	if (!client)
	{
		return 0;
	}
	if (g_Muted[client])
	{
		SetClientListeningFlags(client, 1);
		return 0;
	}
	if (ConVar.BoolValue.get(g_Cvar_Alltalk))
	{
		SetClientListeningFlags(client, 0);
		return 0;
	}
	new mode = ConVar.IntValue.get(g_Cvar_Deadtalk);
	if (mode == 1)
	{
		SetClientListeningFlags(client, 4);
	}
	else
	{
		if (mode == 2)
		{
			SetClientListeningFlags(client, 8);
		}
	}
	return 0;
}

