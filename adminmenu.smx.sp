public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "03/24/2016",
	time = "14:44:33"
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
public Plugin:myinfo =
{
	name = "Admin Menu",
	description = "Administration Menu",
	author = "AlliedModders LLC",
	version = "1.7.3-dev+5255",
	url = "http://www.sourcemod.net/"
};
new Handle:hOnAdminMenuReady;
new Handle:hOnAdminMenuCreated;
new TopMenu:hAdminMenu;
new TopMenuObject:obj_playercmds;
new TopMenuObject:obj_servercmds;
new TopMenuObject:obj_votingcmds;
new g_groupList[2];
new g_groupCount;
new SMCParser:g_configParser;
new String:g_command[66][256];
new g_currentPlace[66][3];
new Handle:g_DataArray;
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

FindCharInString(String:str[], String:c, bool:reverse)
{
	new len = strlen(str);
	if (!reverse)
	{
		new i;
		while (i < len)
		{
			if (c == str[i])
			{
				return i;
			}
			i++;
		}
	}
	else
	{
		new i = len + -1;
		while (0 <= i)
		{
			if (c == str[i])
			{
				return i;
			}
			i--;
		}
	}
	return -1;
}

BuildDynamicMenu()
{
	new itemInput[258];
	g_DataArray = CreateArray(258, 0);
	new String:executeBuffer[32];
	new KeyValues:kvMenu = KeyValues.KeyValues("Commands", "", "");
	KeyValues.SetEscapeSequences(kvMenu, true);
	new String:file[256];
	BuildPath(PathType:0, file, 255, "configs/dynamicmenu/menu.ini");
	if (FileExists(file, false, "GAME"))
	{
		LogError("Warning! configs/dynamicmenu/menu.ini is now configs/adminmenu_custom.txt.");
		LogError("Read the 1.0.2 release notes, as the dynamicmenu folder has been removed.");
	}
	else
	{
		BuildPath(PathType:0, file, 255, "configs/adminmenu_custom.txt");
	}
	FileToKeyValues(kvMenu, file);
	new String:name[64];
	new String:buffer[64];
	if (!KeyValues.GotoFirstSubKey(kvMenu, true))
	{
		return 0;
	}
	decl String:admin[32];
	new TopMenuObject:categoryId;
	do {
		KeyValues.GetSectionName(kvMenu, buffer, 64);
		KeyValues.GetString(kvMenu, "admin", admin, 30, "sm_admin");
		if (!((categoryId = TopMenu.FindCategory(hAdminMenu, buffer))))
		{
			categoryId = TopMenu.AddCategory(hAdminMenu, buffer, DynamicMenuCategoryHandler, admin, 2, name);
		}
		decl String:category_name[64];
		strcopy(category_name, 64, buffer);
		if (!KeyValues.GotoFirstSubKey(kvMenu, true))
		{
			return 0;
		}
		KeyValues.GetSectionName(kvMenu, buffer, 64);
		KeyValues.GetString(kvMenu, "admin", admin, 30, "");
		while (admin[0])
		{
			decl String:temp[64];
			KeyValues.GetString(kvMenu, "cmd", temp, 64, "");
			BreakString(temp, admin, 30);
			KeyValues.GetString(kvMenu, "cmd", itemInput, 256, "");
			KeyValues.GetString(kvMenu, "execute", executeBuffer, 32, "");
			if (StrEqual(executeBuffer, "server", true))
			{
				itemInput[256] = 1;
			}
			else
			{
				itemInput[256] = 0;
			}
			new count = 1;
			decl String:countBuffer[12];
			decl String:inputBuffer[48];
			while (KeyValues.JumpToKey(kvMenu, countBuffer, false))
			{
				new submenuInput[36];
				if (count == 1)
				{
					itemInput[257] = CreateArray(36, 0);
				}
				KeyValues.GetString(kvMenu, "type", inputBuffer, 48, "");
				if (strncmp(inputBuffer, "group", 5, true))
				{
					if (StrEqual(inputBuffer, "mapcycle", true))
					{
						submenuInput[0] = 3;
						KeyValues.GetString(kvMenu, "path", inputBuffer, 48, "mapcycle.txt");
						submenuInput[35] = CreateDataPack();
						WritePackString(submenuInput[35], inputBuffer);
						ResetPack(submenuInput[35], false);
					}
					if (StrContains(inputBuffer, "player", true) != -1)
					{
						submenuInput[0] = 2;
					}
					if (StrEqual(inputBuffer, "onoff", true))
					{
						submenuInput[0] = 5;
					}
					submenuInput[0] = 4;
					submenuInput[35] = CreateDataPack();
					new String:temp[8];
					new String:value[64];
					new String:text[64];
					new String:subadm[32];
					new i = 1;
					new bool:more = 1;
					new listcount;
					Format(temp, 3, "%i", i);
					KeyValues.GetString(kvMenu, temp, value, 64, "");
					Format(temp, 5, "%i.", i);
					KeyValues.GetString(kvMenu, temp, text, 64, value);
					Format(temp, 5, "%i*", i);
					KeyValues.GetString(kvMenu, temp, subadm, 30, "");
					while (value[0])
					{
						more = false;
						i++;
						if (!more)
						{
							ResetPack(submenuInput[35], false);
							submenuInput[34] = listcount;
						}
					}
					listcount++;
					WritePackString(submenuInput[35], value);
					WritePackString(submenuInput[35], text);
					WritePackString(submenuInput[35], subadm);
					i++;
					if (!more)
					{
						ResetPack(submenuInput[35], false);
						submenuInput[34] = listcount;
					}
				}
				else
				{
					if (StrContains(inputBuffer, "player", true) != -1)
					{
						submenuInput[0] = 1;
					}
					else
					{
						submenuInput[0] = 0;
					}
				}
				new var1;
				if (submenuInput[0] == 2 || submenuInput[0] == 1)
				{
					KeyValues.GetString(kvMenu, "method", inputBuffer, 48, "");
					if (StrEqual(inputBuffer, "clientid", true))
					{
						submenuInput[33] = 0;
					}
					if (StrEqual(inputBuffer, "steamid", true))
					{
						submenuInput[33] = 3;
					}
					if (StrEqual(inputBuffer, "userid2", true))
					{
						submenuInput[33] = 5;
					}
					if (StrEqual(inputBuffer, "userid", true))
					{
						submenuInput[33] = 1;
					}
					if (StrEqual(inputBuffer, "ip", true))
					{
						submenuInput[33] = 4;
					}
					submenuInput[33] = 2;
				}
				KeyValues.GetString(kvMenu, "title", inputBuffer, 48, "");
				strcopy(submenuInput[1], 32, inputBuffer);
				count++;
				Format(countBuffer, 10, "%i", count);
				PushArrayArray(itemInput[257], submenuInput, -1);
				KeyValues.GoBack(kvMenu);
			}
			new location = PushArrayArray(g_DataArray, itemInput, -1);
			decl String:locString[12];
			IntToString(location, locString, 10);
			if (!(TopMenu.AddItem(hAdminMenu, buffer, DynamicMenuItemHandler, categoryId, admin, 2, locString)))
			{
				LogError("Duplicate command name \"%s\" in adminmenu_custom.txt category \"%s\"", buffer, category_name);
			}
			if (!(KeyValues.GotoNextKey(kvMenu, true)))
			{
				KeyValues.GoBack(kvMenu);
				if (!(KeyValues.GotoNextKey(kvMenu, true)))
				{
					CloseHandle(kvMenu);
					kvMenu = MissingTAG:0;
					return 0;
				}
			}
		}
		KeyValues.GetString(kvMenu, "cmd", itemInput, 256, "");
		KeyValues.GetString(kvMenu, "execute", executeBuffer, 32, "");
		if (StrEqual(executeBuffer, "server", true))
		{
			itemInput[256] = 1;
		}
		else
		{
			itemInput[256] = 0;
		}
		new count = 1;
		decl String:countBuffer[12];
		decl String:inputBuffer[48];
		while (KeyValues.JumpToKey(kvMenu, countBuffer, false))
		{
			new submenuInput[36];
			if (count == 1)
			{
				itemInput[257] = CreateArray(36, 0);
			}
			KeyValues.GetString(kvMenu, "type", inputBuffer, 48, "");
			if (strncmp(inputBuffer, "group", 5, true))
			{
				if (StrEqual(inputBuffer, "mapcycle", true))
				{
					submenuInput[0] = 3;
					KeyValues.GetString(kvMenu, "path", inputBuffer, 48, "mapcycle.txt");
					submenuInput[35] = CreateDataPack();
					WritePackString(submenuInput[35], inputBuffer);
					ResetPack(submenuInput[35], false);
				}
				if (StrContains(inputBuffer, "player", true) != -1)
				{
					submenuInput[0] = 2;
				}
				if (StrEqual(inputBuffer, "onoff", true))
				{
					submenuInput[0] = 5;
				}
				submenuInput[0] = 4;
				submenuInput[35] = CreateDataPack();
				new String:temp[8];
				new String:value[64];
				new String:text[64];
				new String:subadm[32];
				new i = 1;
				new bool:more = 1;
				new listcount;
				Format(temp, 3, "%i", i);
				KeyValues.GetString(kvMenu, temp, value, 64, "");
				Format(temp, 5, "%i.", i);
				KeyValues.GetString(kvMenu, temp, text, 64, value);
				Format(temp, 5, "%i*", i);
				KeyValues.GetString(kvMenu, temp, subadm, 30, "");
				while (value[0])
				{
					more = false;
					i++;
					if (!more)
					{
						ResetPack(submenuInput[35], false);
						submenuInput[34] = listcount;
					}
				}
				listcount++;
				WritePackString(submenuInput[35], value);
				WritePackString(submenuInput[35], text);
				WritePackString(submenuInput[35], subadm);
				i++;
				if (!more)
				{
					ResetPack(submenuInput[35], false);
					submenuInput[34] = listcount;
				}
			}
			else
			{
				if (StrContains(inputBuffer, "player", true) != -1)
				{
					submenuInput[0] = 1;
				}
				else
				{
					submenuInput[0] = 0;
				}
			}
			new var1;
			if (submenuInput[0] == 2 || submenuInput[0] == 1)
			{
				KeyValues.GetString(kvMenu, "method", inputBuffer, 48, "");
				if (StrEqual(inputBuffer, "clientid", true))
				{
					submenuInput[33] = 0;
				}
				if (StrEqual(inputBuffer, "steamid", true))
				{
					submenuInput[33] = 3;
				}
				if (StrEqual(inputBuffer, "userid2", true))
				{
					submenuInput[33] = 5;
				}
				if (StrEqual(inputBuffer, "userid", true))
				{
					submenuInput[33] = 1;
				}
				if (StrEqual(inputBuffer, "ip", true))
				{
					submenuInput[33] = 4;
				}
				submenuInput[33] = 2;
			}
			KeyValues.GetString(kvMenu, "title", inputBuffer, 48, "");
			strcopy(submenuInput[1], 32, inputBuffer);
			count++;
			Format(countBuffer, 10, "%i", count);
			PushArrayArray(itemInput[257], submenuInput, -1);
			KeyValues.GoBack(kvMenu);
		}
		new location = PushArrayArray(g_DataArray, itemInput, -1);
		decl String:locString[12];
		IntToString(location, locString, 10);
		if (!(TopMenu.AddItem(hAdminMenu, buffer, DynamicMenuItemHandler, categoryId, admin, 2, locString)))
		{
			LogError("Duplicate command name \"%s\" in adminmenu_custom.txt category \"%s\"", buffer, category_name);
		}
		if (!(KeyValues.GotoNextKey(kvMenu, true)))
		{
			KeyValues.GoBack(kvMenu);
			if (!(KeyValues.GotoNextKey(kvMenu, true)))
			{
				CloseHandle(kvMenu);
				kvMenu = MissingTAG:0;
				return 0;
			}
		}
		KeyValues.GoBack(kvMenu);
	} while (KeyValues.GotoNextKey(kvMenu, true));
	CloseHandle(kvMenu);
	kvMenu = MissingTAG:0;
	return 0;
}

ParseConfigs()
{
	if (!g_configParser)
	{
		g_configParser = SMCParser.SMCParser();
	}
	SMCParser.OnEnterSection.set(g_configParser, NewSection);
	SMCParser.OnKeyValue.set(g_configParser, KeyValue);
	SMCParser.OnLeaveSection.set(g_configParser, EndSection);
	if (g_groupList[0])
	{
		CloseHandle(g_groupList[0]);
	}
	if (g_groupList[1])
	{
		CloseHandle(g_groupList[1]);
	}
	g_groupList[0] = CreateArray(32, 0);
	g_groupList[1] = CreateArray(32, 0);
	decl String:configPath[256];
	BuildPath(PathType:0, configPath, 256, "configs/dynamicmenu/adminmenu_grouping.txt");
	if (FileExists(configPath, false, "GAME"))
	{
		LogError("Warning! configs/dynamicmenu/adminmenu_grouping.txt is now configs/adminmenu_grouping.txt.");
		LogError("Read the 1.0.2 release notes, as the dynamicmenu folder has been removed.");
	}
	else
	{
		BuildPath(PathType:0, configPath, 256, "configs/adminmenu_grouping.txt");
	}
	if (!FileExists(configPath, false, "GAME"))
	{
		LogError("Unable to locate admin menu groups file: %s", configPath);
		return 0;
	}
	new line;
	new SMCError:err = SMCParser.ParseFile(g_configParser, configPath, line, 0);
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
	PushArrayString(g_groupList[0], key);
	PushArrayString(g_groupList[1], value);
	return SMCResult:0;
}

public SMCResult:EndSection(SMCParser:smc)
{
	g_groupCount = GetArraySize(g_groupList[0]);
	return SMCResult:0;
}

public DynamicMenuCategoryHandler(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	new var1;
	if (action == TopMenuAction:1 || action)
	{
		GetTopMenuObjName(topmenu, object_id, buffer, maxlength);
	}
	return 0;
}

public DynamicMenuItemHandler(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action)
	{
		if (action == TopMenuAction:2)
		{
			new String:locString[12];
			GetTopMenuInfoString(topmenu, object_id, locString, 10);
			new location = StringToInt(locString, 10);
			new output[258];
			GetArrayArray(g_DataArray, location, output, -1);
			strcopy(g_command[param], 255, output);
			g_currentPlace[param][1] = location;
			g_currentPlace[param][2] = 1;
			ParamCheck(param);
		}
	}
	else
	{
		GetTopMenuObjName(topmenu, object_id, buffer, maxlength);
	}
	return 0;
}

public ParamCheck(client)
{
	new String:buffer[8];
	new String:buffer2[8];
	new outputItem[258];
	new outputSubmenu[36];
	GetArrayArray(g_DataArray, g_currentPlace[client][1], outputItem, -1);
	if (g_currentPlace[client][2] < 1)
	{
		g_currentPlace[client][2] = 1;
	}
	Format(buffer, 5, "#%i", g_currentPlace[client][2]);
	Format(buffer2, 5, "@%i", g_currentPlace[client][2]);
	new var1;
	if (StrContains(g_command[client], buffer, true) == -1 && StrContains(g_command[client], buffer2, true) == -1)
	{
		GetArrayArray(outputItem[257], g_currentPlace[client][2][0], outputSubmenu, -1);
		new Menu:itemMenu = CreateMenu(Menu_Selection, MenuAction:28);
		Menu.ExitBackButton.set(itemMenu, true);
		new var2;
		if (outputSubmenu[0] && outputSubmenu[0] == 1)
		{
			decl String:nameBuffer[32];
			decl String:commandBuffer[32];
			new i;
			while (i < g_groupCount)
			{
				GetArrayString(g_groupList[0], i, nameBuffer, 32);
				GetArrayString(g_groupList[1], i, commandBuffer, 32);
				Menu.AddItem(itemMenu, commandBuffer, nameBuffer, 0);
				i++;
			}
		}
		if (outputSubmenu[0] == 3)
		{
			decl String:path[200];
			ReadPackString(outputSubmenu[35], path, 200);
			ResetPack(outputSubmenu[35], false);
			new File:file = OpenFile(path, "rt", false, "GAME");
			new String:readData[128];
			if (file)
			{
				while (!File.EndOfFile(file) && File.ReadLine(file, readData, 128))
				{
					TrimString(readData);
					if (IsMapValid(readData))
					{
						Menu.AddItem(itemMenu, readData, readData, 0);
					}
				}
			}
		}
		else
		{
			new var4;
			if (outputSubmenu[0] == 2 || outputSubmenu[0] == 1)
			{
				new PlayerMethod:playermethod = outputSubmenu[33];
				new String:nameBuffer[32];
				new String:infoBuffer[32];
				new String:temp[4];
				new i = 1;
				while (i <= MaxClients)
				{
					if (IsClientInGame(i))
					{
						GetClientName(i, nameBuffer, 31);
						switch (playermethod)
						{
							case 1:
							{
								new userid = GetClientUserId(i);
								Format(infoBuffer, 32, "#%i", userid);
								Menu.AddItem(itemMenu, infoBuffer, nameBuffer, 0);
							}
							case 2:
							{
								Menu.AddItem(itemMenu, nameBuffer, nameBuffer, 0);
							}
							case 3:
							{
								if (GetClientAuthId(i, AuthIdType:1, infoBuffer, 32, true))
								{
									Menu.AddItem(itemMenu, infoBuffer, nameBuffer, 0);
								}
							}
							case 4:
							{
								GetClientIP(i, infoBuffer, 32, true);
								Menu.AddItem(itemMenu, infoBuffer, nameBuffer, 0);
							}
							case 5:
							{
								new userid = GetClientUserId(i);
								Format(infoBuffer, 32, "%i", userid);
								Menu.AddItem(itemMenu, infoBuffer, nameBuffer, 0);
							}
							default:
							{
								Format(temp, 3, "%i", i);
								Menu.AddItem(itemMenu, temp, nameBuffer, 0);
							}
						}
					}
					i++;
				}
			}
			if (outputSubmenu[0] == 5)
			{
				Menu.AddItem(itemMenu, "1", "On", 0);
				Menu.AddItem(itemMenu, "0", "Off", 0);
			}
			new String:value[64];
			new String:text[64];
			new String:admin[64];
			new i;
			while (outputSubmenu[34] > i)
			{
				ReadPackString(outputSubmenu[35], value, 64);
				ReadPackString(outputSubmenu[35], text, 64);
				ReadPackString(outputSubmenu[35], admin, 64);
				if (CheckCommandAccess(client, admin, 0, false))
				{
					Menu.AddItem(itemMenu, value, text, 0);
				}
				i++;
			}
			ResetPack(outputSubmenu[35], false);
		}
		Menu.SetTitle(itemMenu, outputSubmenu[1]);
		Menu.Display(itemMenu, client, 0);
	}
	else
	{
		TopMenu.Display(hAdminMenu, client, TopMenuPosition:3);
		decl String:unquotedCommand[256];
		UnQuoteString(g_command[client], unquotedCommand, 255, "#@");
		if (outputItem[256])
		{
			InsertServerCommand(unquotedCommand);
			ServerExecute();
		}
		else
		{
			FakeClientCommand(client, unquotedCommand);
		}
		g_command[client][0] = MissingTAG:0;
		g_currentPlace[client][2] = 1;
	}
	return 0;
}

public Menu_Selection(Menu:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:16)
	{
		CloseHandle(menu);
		menu = MissingTAG:0;
	}
	if (action == MenuAction:4)
	{
		new String:unquotedinfo[64];
		new bool:found = Menu.GetItem(menu, param2, unquotedinfo, 64, 0, "", 0);
		if (!found)
		{
			return 0;
		}
		new String:info[132];
		QuoteString(unquotedinfo, info, 129, "#@");
		new String:buffer[8];
		new String:infobuffer[68];
		Format(infobuffer, 66, "\"%s\"", info);
		Format(buffer, 5, "#%i", g_currentPlace[param1][2]);
		ReplaceString(g_command[param1], 255, buffer, infobuffer, true);
		Format(buffer, 5, "@%i", g_currentPlace[param1][2]);
		ReplaceString(g_command[param1], 255, buffer, info, true);
		g_currentPlace[param1][2]++;
		ParamCheck(param1);
	}
	new var1;
	if (action == MenuAction:8 && param2 == -6)
	{
		TopMenu.Display(hAdminMenu, param1, TopMenuPosition:3);
	}
	return 0;
}

bool:QuoteString(String:input[], String:output[], maxlen, String:quotechars[])
{
	new count;
	new len = strlen(input);
	new i;
	while (i < len)
	{
		output[count] = input[i];
		count++;
		if (count >= maxlen)
		{
			output[maxlen + -1] = MissingTAG:0;
			return false;
		}
		new var1;
		if (FindCharInString(quotechars, input[i], false) == -1 && input[i] == '\')
		{
			output[count] = MissingTAG:92;
			count++;
			if (count >= maxlen)
			{
				output[maxlen + -1] = MissingTAG:0;
				return false;
			}
		}
		i++;
	}
	output[count] = MissingTAG:0;
	return true;
}

bool:UnQuoteString(String:input[], String:output[], maxlen, String:quotechars[])
{
	new count = 1;
	new len = strlen(input);
	output[0] = input[0];
	new i = 1;
	while (i < len)
	{
		output[count] = input[i];
		count++;
		new var2;
		if (input[i + 1] == '\' && (input[i] == '\' || FindCharInString(quotechars, input[i], false) == -1))
		{
			i++;
		}
		if (count >= maxlen)
		{
			output[maxlen + -1] = MissingTAG:0;
			return false;
		}
		i++;
	}
	output[count] = MissingTAG:0;
	return true;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("GetAdminTopMenu", __GetAdminTopMenu);
	CreateNative("AddTargetsToMenu", __AddTargetsToMenu);
	CreateNative("AddTargetsToMenu2", __AddTargetsToMenu2);
	RegPluginLibrary("adminmenu");
	return APLRes:0;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("adminmenu.phrases");
	hOnAdminMenuCreated = CreateGlobalForward("OnAdminMenuCreated", ExecType:0, 2);
	hOnAdminMenuReady = CreateGlobalForward("OnAdminMenuReady", ExecType:0, 2);
	RegAdminCmd("sm_admin", Command_DisplayMenu, 2, "Displays the admin menu", "", 0);
	return void:0;
}

public void:OnConfigsExecuted()
{
	decl String:path[256];
	decl String:error[256];
	BuildPath(PathType:0, path, 256, "configs/adminmenu_sorting.txt");
	if (!TopMenu.LoadConfig(hAdminMenu, path, error, 256))
	{
		LogError("Could not load admin menu config (file \"%s\": %s)", path, error);
		return void:0;
	}
	return void:0;
}

public void:OnMapStart()
{
	ParseConfigs();
	return void:0;
}

public void:OnAllPluginsLoaded()
{
	hAdminMenu = TopMenu.TopMenu(DefaultCategoryHandler);
	obj_playercmds = TopMenu.AddCategory(hAdminMenu, "PlayerCommands", DefaultCategoryHandler, "", 0, "");
	obj_servercmds = TopMenu.AddCategory(hAdminMenu, "ServerCommands", DefaultCategoryHandler, "", 0, "");
	obj_votingcmds = TopMenu.AddCategory(hAdminMenu, "VotingCommands", DefaultCategoryHandler, "", 0, "");
	BuildDynamicMenu();
	Call_StartForward(hOnAdminMenuCreated);
	Call_PushCell(hAdminMenu);
	Call_Finish(0);
	Call_StartForward(hOnAdminMenuReady);
	Call_PushCell(hAdminMenu);
	Call_Finish(0);
	return void:0;
}

public DefaultCategoryHandler(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength)
{
	if (action == TopMenuAction:1)
	{
		if (object_id)
		{
			if (obj_playercmds == object_id)
			{
				Format(buffer, maxlength, "%T:", "Player Commands", param);
			}
			if (obj_servercmds == object_id)
			{
				Format(buffer, maxlength, "%T:", "Server Commands", param);
			}
			if (obj_votingcmds == object_id)
			{
				Format(buffer, maxlength, "%T:", "Voting Commands", param);
			}
		}
		else
		{
			Format(buffer, maxlength, "%T:", "Admin Menu", param);
		}
	}
	else
	{
		if (!action)
		{
			if (obj_playercmds == object_id)
			{
				Format(buffer, maxlength, "%T", "Player Commands", param);
			}
			if (obj_servercmds == object_id)
			{
				Format(buffer, maxlength, "%T", "Server Commands", param);
			}
			if (obj_votingcmds == object_id)
			{
				Format(buffer, maxlength, "%T", "Voting Commands", param);
			}
		}
	}
	return 0;
}

public __GetAdminTopMenu(Handle:plugin, numParams)
{
	return hAdminMenu;
}

public __AddTargetsToMenu(Handle:plugin, numParams)
{
	new bool:alive_only;
	if (numParams >= 4)
	{
		alive_only = GetNativeCell(4);
	}
	return UTIL_AddTargetsToMenu(GetNativeCell(1), GetNativeCell(2), GetNativeCell(3), alive_only);
}

public __AddTargetsToMenu2(Handle:plugin, numParams)
{
	return UTIL_AddTargetsToMenu2(GetNativeCell(1), GetNativeCell(2), GetNativeCell(3));
}

public Action:Command_DisplayMenu(client, args)
{
	if (client)
	{
		TopMenu.Display(hAdminMenu, client, TopMenuPosition:0);
		return Action:3;
	}
	ReplyToCommand(client, "[SM] %t", "Command is in-game only");
	return Action:3;
}

UTIL_AddTargetsToMenu2(Menu:menu, source_client, flags)
{
	new String:user_id[12];
	new String:name[32];
	new String:display[44];
	new num_clients;
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (!IsClientConnected(i) || IsClientInKickQueue(i))
		{
		}
		else
		{
			new var2;
			if (!(flags & 32 == 32 && IsFakeClient(i)))
			{
				new var3;
				if (!(flags & 4 != 4 && !IsClientInGame(i)))
				{
					new var4;
					if (!(flags & 1 == 1 && !IsPlayerAlive(i)))
					{
						new var5;
						if (!(flags & 2 == 2 && IsPlayerAlive(i)))
						{
							new var6;
							if (!((source_client && flags & 8 != 8) && !CanUserTarget(source_client, i)))
							{
								IntToString(GetClientUserId(i), user_id, 12);
								GetClientName(i, name, 32);
								Format(display, 44, "%s (%s)", name, user_id);
								Menu.AddItem(menu, user_id, display, 0);
								num_clients++;
							}
						}
					}
				}
			}
		}
		i++;
	}
	return num_clients;
}

UTIL_AddTargetsToMenu(Menu:menu, source_client, bool:in_game_only, bool:alive_only)
{
	new flags;
	if (!in_game_only)
	{
		flags |= 4;
	}
	if (alive_only)
	{
		flags |= 1;
	}
	return UTIL_AddTargetsToMenu2(menu, source_client, flags);
}

