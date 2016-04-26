public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "03/11/2016",
	time = "14:53:51"
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
	required = 1,
};
public SharedPlugin:__pl_adminmenu =
{
	name = "adminmenu",
	file = "adminmenu.smx",
	required = 1,
};
public Extension:__ext_sdktools =
{
	name = "SDKTools",
	file = "sdktools.ext",
	autoload = 1,
	required = 1,
};
public Plugin:myinfo =
{
	name = "Ban disconnected players",
	description = "Lets you ban players that recently disconnected",
	author = "mad_hamster",
	version = "fe639b0",
	url = "http://pro-css.co.il"
};
new Handle:hTopMenu;
new String:disconnected_player_names[100][32];
new String:disconnected_player_authids[100][32];
new disconnected_player_times[100];
public SharedPlugin:__pl_updater =
{
	name = "updater",
	file = "updater.smx",
	required = 0,
};
new queue_max_size = 100;
new queue_size;
new queue_start;
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

ExplodeString(String:text[], String:split[], String:buffers[][], maxStrings, maxStringLength, bool:copyRemainder)
{
	new reloc_idx;
	new idx;
	new total;
	new var1;
	if (maxStrings < 1 || !split[0])
	{
		return 0;
	}
	while ((idx = SplitString(text[reloc_idx], split, buffers[total], maxStringLength)) != -1)
	{
		reloc_idx = idx + reloc_idx;
		total++;
		if (maxStrings == total)
		{
			if (copyRemainder)
			{
				strcopy(buffers[total + -1], maxStringLength, text[reloc_idx - idx]);
			}
			return total;
		}
	}
	total++;
	strcopy(buffers[total], maxStringLength, text[reloc_idx]);
	return total;
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
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/ban_disconnected/ban_disconnected.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/ban_disconnected/ban_disconnected.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	RegAdminCmd("sm_bandisconnected", BanDisconnected, 8, "", "", 0);
	HookEvent("player_disconnect", OnEventPlayerDisconnect, EventHookMode:1);
	new Handle:topmenu;
	new var1;
	if (LibraryExists("adminmenu") && (topmenu = GetAdminTopMenu()))
	{
		OnAdminMenuReady(topmenu);
	}
	AddUpdaterLibrary();
	return void:0;
}

public Action:OnEventPlayerDisconnect(Handle:event, String:name[], bool:dont_broadcast)
{
	decl String:steam_id[32];
	GetEventString(event, "networkid", steam_id, 32, "");
	new var3;
	if (strncmp(steam_id, "STEAM_", 6, true) && (queue_get_size() && (strcmp(steam_id, disconnected_player_authids[queue_translate_pos(queue_get_size() + -1)], true) || GetTime({0,0}) == disconnected_player_times[queue_translate_pos(queue_get_size() + -1)])))
	{
		new pos = queue_push();
		strcopy(disconnected_player_authids[pos], 32, steam_id);
		GetEventString(event, "name", disconnected_player_names[pos], 32, "");
		disconnected_player_times[pos] = GetTime({0,0});
	}
	return Action:0;
}

public Action:BanDisconnected(client, args)
{
	new var1;
	if (args < 2 || args > 3)
	{
		ReplyToCommand(client, "[SM] Usage: sm_bandisconnected <\"steamid\"> <minutes|0> [\"reason\"]");
	}
	else
	{
		decl String:steamid[20];
		decl String:minutes[12];
		decl String:reason[256];
		GetCmdArg(1, steamid, 20);
		GetCmdArg(2, minutes, 10);
		GetCmdArg(3, reason, 256);
		CheckAndPerformBan(client, steamid, StringToInt(minutes, 10), reason);
	}
	return Action:3;
}

CheckAndPerformBan(client, String:steamid[], minutes, String:reason[])
{
	new AdminId:source_aid = GetUserAdmin(client);
	new AdminId:target_aid;
	new var1;
	if ((target_aid = FindAdminByIdentity("steam", steamid)) == -1 || CanAdminTarget(source_aid, target_aid))
	{
		new bool:has_root_flag = GetAdminFlag(source_aid, AdminFlag:14, AdmAccessMode:1);
		SetAdminFlag(source_aid, AdminFlag:14, true);
		FakeClientCommand(client, "sm_addban %d \"%s\" %s", minutes, steamid, reason);
		SetAdminFlag(source_aid, AdminFlag:14, has_root_flag);
	}
	else
	{
		ReplyToCommand(client, "[sm_bandisconnected] You can't ban an admin with higher immunity than yourself");
	}
	return 0;
}

public void:OnAdminMenuReady(Handle:topmenu)
{
	if (hTopMenu != topmenu)
	{
		hTopMenu = topmenu;
		new TopMenuObject:player_commands = FindTopMenuCategory(hTopMenu, "PlayerCommands");
		if (player_commands)
		{
			AddToTopMenu(hTopMenu, "sm_bandisconnected", TopMenuObjectType:1, AdminMenu_Ban, player_commands, "sm_bandisconnected", 8, "");
		}
	}
	return void:0;
}

public AdminMenu_Ban(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			DisplayBanTargetMenu(param);
		}
	}
	else
	{
		Format(buffer, maxlength, "Ban disconnected player");
	}
	return 0;
}

DisplayBanTargetMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandler_BanPlayerList, MenuAction:28);
	SetMenuTitle(menu, "Ban disconnected player");
	SetMenuExitBackButton(menu, true);
	new i = queue_get_size() + -1;
	while (0 <= i)
	{
		new pos = queue_translate_pos(i);
		decl String:client_info[100];
		new delta = GetTime({0,0}) - disconnected_player_times[pos];
		Format(client_info, 100, "%s (%s) (%dd:%02dh:%02dm:%02ds ago)", disconnected_player_names[pos], disconnected_player_authids[pos], delta / 86400, delta % 86400 / 3600, delta % 3600 / 60, delta % 60);
		AddMenuItem(menu, disconnected_player_authids[pos], client_info, 0);
		i--;
	}
	DisplayMenu(menu, client, 0);
	return 0;
}

public MenuHandler_BanPlayerList(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:state_[128];
			GetMenuItem(menu, param2, state_, 128, 0, "", 0);
			DisplayBanTimeMenu(param1, state_);
		}
		case 8:
		{
			new var1;
			if (param2 == -6 && hTopMenu)
			{
				DisplayTopMenu(hTopMenu, param1, TopMenuPosition:3);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

AddMenuItemWithState(Handle:menu, String:state_[], String:addstate[], String:display[])
{
	decl String:newstate[128];
	Format(newstate, 128, "%s\n%s", state_, addstate);
	AddMenuItem(menu, newstate, display, 0);
	return 0;
}

DisplayBanTimeMenu(client, String:state_[])
{
	new Handle:menu = CreateMenu(MenuHandler_BanTimeList, MenuAction:28);
	SetMenuTitle(menu, "Ban disconnected player");
	SetMenuExitBackButton(menu, true);
	AddMenuItemWithState(menu, state_, "0", "Permanent");
	AddMenuItemWithState(menu, state_, "10", "10 Minutes");
	AddMenuItemWithState(menu, state_, "30", "30 Minutes");
	AddMenuItemWithState(menu, state_, "60", "1 Hour");
	AddMenuItemWithState(menu, state_, "240", "4 Hours");
	AddMenuItemWithState(menu, state_, "1440", "1 Day");
	AddMenuItemWithState(menu, state_, "10080", "1 Week");
	AddMenuItemWithState(menu, state_, "20160", "2 Weeks");
	AddMenuItemWithState(menu, state_, "30240", "3 Weeks");
	AddMenuItemWithState(menu, state_, "43200", "1 Month");
	AddMenuItemWithState(menu, state_, "129600", "3 Months");
	DisplayMenu(menu, client, 0);
	return 0;
}

public MenuHandler_BanTimeList(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:state_[128];
			GetMenuItem(menu, param2, state_, 128, 0, "", 0);
			DisplayBanReasonMenu(param1, state_);
		}
		case 8:
		{
			new var1;
			if (param2 == -6 && hTopMenu)
			{
				DisplayTopMenu(hTopMenu, param1, TopMenuPosition:3);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

DisplayBanReasonMenu(client, String:state_[])
{
	new Handle:menu = CreateMenu(MenuHandler_BanReasonList, MenuAction:28);
	SetMenuTitle(menu, "Ban reason");
	SetMenuExitBackButton(menu, true);
	AddMenuItemWithState(menu, state_, "Abusive", "Abusive");
	AddMenuItemWithState(menu, state_, "Racism", "Racism");
	AddMenuItemWithState(menu, state_, "General cheating/exploits", "General cheating/exploits");
	AddMenuItemWithState(menu, state_, "Wallhack", "Wallhack");
	AddMenuItemWithState(menu, state_, "Aimbot", "Aimbot");
	AddMenuItemWithState(menu, state_, "Speedhacking", "Speedhacking");
	AddMenuItemWithState(menu, state_, "Mic spamming", "Mic spamming");
	AddMenuItemWithState(menu, state_, "Admin disrepect", "Admin disrepect");
	AddMenuItemWithState(menu, state_, "Camping", "Camping");
	AddMenuItemWithState(menu, state_, "Team killing", "Team killing");
	AddMenuItemWithState(menu, state_, "Unacceptable Spray", "Unacceptable Spray");
	AddMenuItemWithState(menu, state_, "Breaking Server Rules", "Breaking Server Rules");
	AddMenuItemWithState(menu, state_, "Other", "Other");
	DisplayMenu(menu, client, 0);
	return 0;
}

public MenuHandler_BanReasonList(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case 4:
		{
			decl String:state_[128];
			new String:state_parts[4][32] = "";
			GetMenuItem(menu, param2, state_, 128, 0, "", 0);
			if (ExplodeString(state_, "\n", state_parts, 4, 32, false) != 3)
			{
				SetFailState("Bug in menu handlers");
			}
			else
			{
				CheckAndPerformBan(param1, state_parts[0][state_parts], StringToInt(state_parts[1], 10), state_parts[2]);
			}
		}
		case 8:
		{
			new var1;
			if (param2 == -6 && hTopMenu)
			{
				DisplayTopMenu(hTopMenu, param1, TopMenuPosition:3);
			}
		}
		case 16:
		{
			CloseHandle(menu);
		}
		default:
		{
		}
	}
	return 0;
}

queue_get_size()
{
	return queue_size;
}

queue_translate_pos(pos)
{
	if (pos >= queue_max_size)
	{
		return pos - queue_max_size;
	}
	return pos;
}

queue_push()
{
	if (queue_max_size == queue_size)
	{
		queue_pop();
	}
	queue_size += 1;
	return queue_translate_pos(queue_size);
}

queue_pop()
{
	if (queue_size)
	{
		new pos = queue_start;
		queue_start = queue_translate_pos(1);
		queue_size -= 1;
		return pos;
	}
	SetFailState("Can't pop from an empty queue!");
	return -1;
}

