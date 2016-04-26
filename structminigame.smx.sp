public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "03/17/2016",
	time = "18:31:02"
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
new String:CTag[6][0];
new String:CTagCode[6][16] =
{
	"\x01",
	"\x04",
	"\x03",
	"\x03",
	"\x03",
	"\x05"
};
new bool:CTagReqSayText2[6] =
{
	0, 0, 1, 1, 1, 0
};
new bool:CEventIsHooked;
new bool:CSkipList[66];
new bool:CProfile_Colors[6] =
{
	1, 1, 0, 0, 0, 0
};
new CProfile_TeamIndex[6] =
{
	-1, ...
};
new bool:CProfile_SayText2;
public Extension:__ext_cprefs =
{
	name = "Client Preferences",
	file = "clientprefs.ext",
	autoload = 1,
	required = 1,
};
public SharedPlugin:__pl_commander =
{
	name = "nd_commander",
	file = "nd_commander_restrictions.smx",
	required = 0,
};
public Plugin:myinfo =
{
	name = "[ND] Structure Killings",
	description = "Provides a mini-game and announcement for structure killing",
	author = "databomb edited by stickz",
	version = "cd83fe5",
	url = "vintagejailbreak.org"
};
public SharedPlugin:__pl_updater =
{
	name = "updater",
	file = "updater.smx",
	required = 0,
};
new StructuresKilled[4];
new Handle:cookie_structure_killings;
new bool:option_structure_killings[66] =
{
	1, ...
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

Handle:StartMessageOne(String:msgname[], client, flags)
{
	new players[1];
	players[0] = client;
	return StartMessage(msgname, players, 1, flags);
}

SetEntityHealth(entity, amount)
{
	static bool:gotconfig;
	static String:prop[32];
	if (!gotconfig)
	{
		new Handle:gc = LoadGameConfigFile("core.games");
		new bool:exists = GameConfGetKeyValue(gc, "m_iHealth", prop, 32);
		CloseHandle(gc);
		if (!exists)
		{
			strcopy(prop, 32, "m_iHealth");
		}
		gotconfig = true;
	}
	decl String:cls[64];
	new PropFieldType:type;
	new offset;
	if (!GetEntityNetClass(entity, cls, 64))
	{
		ThrowError("SetEntityHealth not supported by this mod: Could not get serverclass name");
		return 0;
	}
	offset = FindSendPropInfo(cls, prop, type, 0, 0);
	if (0 >= offset)
	{
		ThrowError("SetEntityHealth not supported by this mod");
		return 0;
	}
	if (type == PropFieldType:2)
	{
		SetEntDataFloat(entity, offset, float(amount), false);
	}
	else
	{
		SetEntProp(entity, PropType:0, prop, amount, 4, 0);
	}
	return 0;
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

CPrintToChat(client, String:szMessage[])
{
	new var1;
	if (client <= 0 || client > MaxClients)
	{
		ThrowError("Invalid client index %d", client);
	}
	if (!IsClientInGame(client))
	{
		ThrowError("Client %d is not in game", client);
	}
	decl String:szBuffer[252];
	decl String:szCMessage[252];
	SetGlobalTransTarget(client);
	Format(szBuffer, 250, "\x01%s", szMessage);
	VFormat(szCMessage, 250, szBuffer, 3);
	new index = CFormat(szCMessage, 250, -1);
	if (index == -1)
	{
		PrintToChat(client, szCMessage);
	}
	else
	{
		CSayText2(client, index, szCMessage);
	}
	return 0;
}

CFormat(String:szMessage[], maxlength, author)
{
	if (!CEventIsHooked)
	{
		CSetupProfile();
		HookEvent("server_spawn", CEvent_MapStart, EventHookMode:2);
		CEventIsHooked = true;
	}
	new iRandomPlayer = -1;
	if (author != -1)
	{
		if (CProfile_SayText2)
		{
			ReplaceString(szMessage, maxlength, "{teamcolor}", "\x03", true);
			iRandomPlayer = author;
		}
		else
		{
			ReplaceString(szMessage, maxlength, "{teamcolor}", CTagCode[1], true);
		}
	}
	else
	{
		ReplaceString(szMessage, maxlength, "{teamcolor}", "", true);
	}
	new i;
	while (i < 6)
	{
		if (!(StrContains(szMessage, CTag[i], true) == -1))
		{
			if (!CProfile_Colors[i])
			{
				ReplaceString(szMessage, maxlength, CTag[i], CTagCode[1], true);
			}
			else
			{
				if (!CTagReqSayText2[i])
				{
					ReplaceString(szMessage, maxlength, CTag[i], CTagCode[i], true);
				}
				if (!CProfile_SayText2)
				{
					ReplaceString(szMessage, maxlength, CTag[i], CTagCode[1], true);
				}
				if (iRandomPlayer == -1)
				{
					iRandomPlayer = CFindRandomPlayerByTeam(CProfile_TeamIndex[i]);
					if (iRandomPlayer == -2)
					{
						ReplaceString(szMessage, maxlength, CTag[i], CTagCode[1], true);
					}
					else
					{
						ReplaceString(szMessage, maxlength, CTag[i], CTagCode[i], true);
					}
				}
				ThrowError("Using two team colors in one message is not allowed");
			}
		}
		i++;
	}
	return iRandomPlayer;
}

CFindRandomPlayerByTeam(color_team)
{
	if (color_team)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			new var1;
			if (IsClientInGame(i) && color_team == GetClientTeam(i))
			{
				return i;
			}
			i++;
		}
		return -2;
	}
	return 0;
}

CSayText2(client, author, String:szMessage[])
{
	new Handle:hBuffer = StartMessageOne("SayText2", client, 0);
	if (GetUserMessageType() == 1)
	{
		PbSetInt(hBuffer, "ent_idx", author, -1);
		PbSetBool(hBuffer, "chat", true, -1);
		PbSetString(hBuffer, "msg_name", szMessage, -1);
		PbAddString(hBuffer, "params", "");
		PbAddString(hBuffer, "params", "");
		PbAddString(hBuffer, "params", "");
		PbAddString(hBuffer, "params", "");
	}
	else
	{
		BfWriteByte(hBuffer, author);
		BfWriteByte(hBuffer, 1);
		BfWriteString(hBuffer, szMessage);
	}
	EndMessage();
	return 0;
}

CSetupProfile()
{
	decl String:szGameName[32];
	GetGameFolderName(szGameName, 30);
	if (StrEqual(szGameName, "cstrike", false))
	{
		CProfile_Colors[2] = 1;
		CProfile_Colors[3] = 1;
		CProfile_Colors[4] = 1;
		CProfile_Colors[5] = 1;
		CProfile_TeamIndex[2] = 0;
		CProfile_TeamIndex[3] = 2;
		CProfile_TeamIndex[4] = 3;
		CProfile_SayText2 = true;
	}
	else
	{
		if (StrEqual(szGameName, "tf", false))
		{
			CProfile_Colors[2] = 1;
			CProfile_Colors[3] = 1;
			CProfile_Colors[4] = 1;
			CProfile_Colors[5] = 1;
			CProfile_TeamIndex[2] = 0;
			CProfile_TeamIndex[3] = 2;
			CProfile_TeamIndex[4] = 3;
			CProfile_SayText2 = true;
		}
		new var1;
		if (StrEqual(szGameName, "left4dead", false) || StrEqual(szGameName, "left4dead2", false))
		{
			CProfile_Colors[2] = 1;
			CProfile_Colors[3] = 1;
			CProfile_Colors[4] = 1;
			CProfile_Colors[5] = 1;
			CProfile_TeamIndex[2] = 0;
			CProfile_TeamIndex[3] = 3;
			CProfile_TeamIndex[4] = 2;
			CProfile_SayText2 = true;
		}
		if (StrEqual(szGameName, "hl2mp", false))
		{
			if (GetConVarBool(FindConVar("mp_teamplay")))
			{
				CProfile_Colors[3] = 1;
				CProfile_Colors[4] = 1;
				CProfile_Colors[5] = 1;
				CProfile_TeamIndex[3] = 3;
				CProfile_TeamIndex[4] = 2;
				CProfile_SayText2 = true;
			}
			else
			{
				CProfile_SayText2 = false;
				CProfile_Colors[5] = 1;
			}
		}
		if (StrEqual(szGameName, "dod", false))
		{
			CProfile_Colors[5] = 1;
			CProfile_SayText2 = false;
		}
		if (GetUserMessageId("SayText2") == -1)
		{
			CProfile_SayText2 = false;
		}
		CProfile_Colors[3] = 1;
		CProfile_Colors[4] = 1;
		CProfile_TeamIndex[3] = 2;
		CProfile_TeamIndex[4] = 3;
		CProfile_SayText2 = true;
	}
	return 0;
}

public Action:CEvent_MapStart(Handle:event, String:name[], bool:dontBroadcast)
{
	CSetupProfile();
	new i = 1;
	while (i <= MaxClients)
	{
		CSkipList[i] = 0;
		i++;
	}
	return Action:0;
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
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/structminigame/structminigame.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/structminigame/structminigame.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	HookEvent("structure_death", Event_StructDeath, EventHookMode:1);
	AddClientPrefSupport();
	LoadTranslations("structminigame.phrases");
	AddUpdaterLibrary();
	return void:0;
}

public void:OnMapStart()
{
	ClearKills();
	return void:0;
}

public CookieMenuHandler_StructureKillings(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	switch (action)
	{
		case 0:
		{
			decl String:status[12];
			new var2;
			if (!option_structure_killings[client])
			{
				var2[0] = 4212;
			}
			else
			{
				var2[0] = 4216;
			}
			Format(status, 10, "%T", var2, client);
			Format(buffer, maxlen, "%T: %s", "Cookie Structure Killings", client, status);
		}
		case 1:
		{
			option_structure_killings[client] = !option_structure_killings[client];
			new var1;
			if (!option_structure_killings[client])
			{
				var1[0] = 4256;
			}
			else
			{
				var1[0] = 4260;
			}
			SetClientCookie(client, cookie_structure_killings, var1);
			ShowCookieMenu(client);
		}
		default:
		{
		}
	}
	return 0;
}

public void:OnClientCookiesCached(client)
{
	option_structure_killings[client] = GetCookieStructureKillings(client);
	return void:0;
}

bool:GetCookieStructureKillings(client)
{
	decl String:buffer[12];
	GetClientCookie(client, cookie_structure_killings, buffer, 10);
	return !StrEqual(buffer, "Off", true);
}

ClearKills()
{
	new idx;
	while (idx < 4)
	{
		StructuresKilled[idx] = 0;
		idx++;
	}
	return 0;
}

public Event_StructDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new team = GetClientTeam(attacker);
	new type = GetEventInt(event, "type", 0);
	decl String:buildingname[32];
	switch (type)
	{
		case 0:
		{
			Format(buildingname, 32, "Command Bunker");
		}
		case 1:
		{
			Format(buildingname, 32, "MG Turret");
		}
		case 2:
		{
			Format(buildingname, 32, "Transport Gate");
		}
		case 3:
		{
			Format(buildingname, 32, "Power Station");
		}
		case 4:
		{
			Format(buildingname, 32, "Wireless Repeater");
		}
		case 5:
		{
			Format(buildingname, 32, "Relay Tower");
		}
		case 6:
		{
			Format(buildingname, 32, "Supply Station");
		}
		case 7:
		{
			Format(buildingname, 32, "Assembler");
		}
		case 8:
		{
			Format(buildingname, 32, "Armory");
		}
		case 9:
		{
			Format(buildingname, 32, "Artillery");
		}
		case 10:
		{
			Format(buildingname, 32, "Radar Station");
		}
		case 11:
		{
			Format(buildingname, 32, "Flamethrower Turret");
		}
		case 12:
		{
			Format(buildingname, 32, "Sonic Turret");
		}
		case 13:
		{
			Format(buildingname, 32, "Rocket Turret");
		}
		case 14:
		{
			Format(buildingname, 32, "Wall");
		}
		case 15:
		{
			Format(buildingname, 32, "Barrier");
		}
		default:
		{
		}
	}
	StructuresKilled[team]++;
	decl String:attackerName[128];
	GetClientName(attacker, attackerName, 128);
	decl String:teamColour[16];
	switch (team)
	{
		case 2:
		{
			Format(teamColour, 16, "{red}");
		}
		case 3:
		{
			Format(teamColour, 16, "{blue}");
		}
		default:
		{
		}
	}
	new client = 1;
	while (client <= MaxClients)
	{
		new var1;
		if (IsValidClient(client, true) && !option_structure_killings[client])
		{
			decl String:structure[32];
			Format(structure, 32, "%T", buildingname, client);
			decl String:message[128];
			Format(message, 128, "%T", "Building Destoryed", client, teamColour, attackerName, structure);
			CPrintToChat(client, message);
		}
		client++;
	}
	if (StructuresKilled[2] + StructuresKilled[3] >= 20)
	{
		ClearKills();
		decl String:teamTrans[16];
		switch (team)
		{
			case 2:
			{
				Format(teamTrans, 16, "Consort");
			}
			case 3:
			{
				Format(teamTrans, 16, "Empire");
			}
			default:
			{
			}
		}
		decl String:colourGreen[32];
		Format(colourGreen, 32, "{lightgreen}");
		new client = 1;
		while (client <= MaxClients)
		{
			if (IsValidClient(client, true))
			{
				decl String:teamName[32];
				Format(teamName, 32, "%T", teamTrans, client);
				decl String:chatMessage[128];
				Format(chatMessage, 128, "%T", "Advantage Message", client, teamColour, attackerName, colourGreen, teamColour, teamName, colourGreen);
				CPrintToChat(client, chatMessage);
				decl String:centerMessage[64];
				Format(centerMessage, 64, "%T", "Advantage Center", client, teamName);
				PrintCenterText(client, centerMessage);
			}
			client++;
		}
		new idx = 1;
		while (idx <= MaxClients)
		{
			if (GiveAdvantage(idx, team))
			{
				SetEntityHealth(idx, GetClientHealth(idx) + 175);
			}
			idx++;
		}
		return 0;
	}
	return 0;
}

bool:GiveAdvantage(client, team)
{
	new var1;
	return IsClientInGame(client) && IsPlayerAlive(client) && !NDC_IsCommander(client) && team == GetClientTeam(client);
}

AddClientPrefSupport()
{
	cookie_structure_killings = RegClientCookie("Structure Killings On/Off", "", CookieAccess:1);
	new info;
	SetCookieMenuItem(CookieMenuHandler_StructureKillings, info, "Structure Killings");
	LoadTranslations("common.phrases");
	return 0;
}

