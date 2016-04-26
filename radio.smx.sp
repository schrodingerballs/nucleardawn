public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "05:39:26"
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
public Extension:__ext_cprefs =
{
	name = "Client Preferences",
	file = "clientprefs.ext",
	autoload = 1,
	required = 1,
};
public Plugin:myinfo =
{
	name = "SourceMod Radio",
	description = "Radio stations plugin for sourcemod",
	author = "dubbeh",
	version = "1.0.0.13",
	url = "http://www.yegods.net/"
};
new Handle:g_cVarRadioEnable;
new Handle:g_cVarRadioStationAdvert;
new Handle:g_cVarWelcomeMsg;
new Handle:g_cVarLogging;
new Handle:g_hRadioStationsMenu;
new String:g_szRadioOffPage[128] = "about:blank";
new Handle:g_hArrayRadioStationNames;
new Handle:g_hArrayRadioStationURLs;
new String:g_szConfigFile[28] = "sourcemod/plugin.radio.cfg";
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

ShowMOTDPanel(client, String:title[], String:msg[], type)
{
	new String:num[4];
	IntToString(type, num, 3);
	new KeyValues:kv = KeyValues.KeyValues("data", "", "");
	KeyValues.SetString(kv, "title", title);
	KeyValues.SetString(kv, "type", num);
	KeyValues.SetString(kv, "msg", msg);
	ShowVGUIPanel(client, "info", kv, true);
	CloseHandle(kv);
	kv = MissingTAG:0;
	return 0;
}

public void:OnPluginStart()
{
	CreateConVar("sm_radio_version", "1.0.0.13", "SourceMod Radio version", 401728, false, 0.0, false, 0.0);
	g_cVarRadioEnable = CreateConVar("sm_radio_enable", "1.0", "Enable SourceMod Radio", 0, true, 0.0, true, 1.0);
	g_cVarRadioStationAdvert = CreateConVar("sm_radio_advert", "0.0", "Enable advertising the users radio station choice", 0, true, 0.0, true, 1.0);
	g_cVarWelcomeMsg = CreateConVar("sm_radio_welcome", "0.0", "Enable the welcome message", 0, true, 0.0, true, 1.0);
	g_cVarLogging = CreateConVar("sm_radio_logging", "0.0", "Enable logging to the server console and log file", 0, true, 0.0, true, 1.0);
	new var1;
	if (g_cVarRadioEnable && g_cVarRadioStationAdvert && g_cVarWelcomeMsg && g_cVarLogging)
	{
		SetFailState("Error - Unable to create a console var");
	}
	new var2;
	if ((g_hArrayRadioStationNames = CreateArray(33, 0)) && (g_hArrayRadioStationURLs = CreateArray(129, 0)))
	{
		SetFailState("Error - Unable to create the station arrays");
	}
	LoadTranslations("radio.phrases");
	RegConsoleCmd("sm_radio", Command_Radio, "", 0);
	RegConsoleCmd("sm_radiooff", Command_RadioOff, "", 0);
	RegConsoleCmd("sm_browse", Command_Browse, "", 0);
	ServerCommand("exec %s", g_szConfigFile);
	return void:0;
}

public void:OnPluginEnd()
{
	ClearArray(g_hArrayRadioStationNames);
	FreeHandle(g_hArrayRadioStationNames);
	ClearArray(g_hArrayRadioStationURLs);
	FreeHandle(g_hArrayRadioStationURLs);
	return void:0;
}

public void:OnMapStart()
{
	ServerCommand("exec %s", g_szConfigFile);
	strcopy(g_szRadioOffPage, 128, "about:blank");
	GetRadioStationsFromFile();
	if (!((g_hRadioStationsMenu = CreateRadioStationsMenu())))
	{
		SetFailState("Error - Radio stations menu handle is invalid");
	}
	return void:0;
}

public void:OnMapEnd()
{
	FreeHandle(g_hRadioStationsMenu);
	return void:0;
}

public void:OnClientPutInServer(client)
{
	new var1;
	if (client && !GetConVarInt(g_cVarRadioEnable) && !IsClientConnected(client))
	{
		return void:0;
	}
	CreateTimer(30.0, WelcomeAdvertTimer, client, 0);
	return void:0;
}

FreeHandle(Handle:hHandle)
{
	if (hHandle)
	{
		CloseHandle(hHandle);
		hHandle = MissingTAG:0;
	}
	return 0;
}

GetRadioStationsFromFile()
{
	new String:szLineBuffer[256];
	new String:szTempBuffer[128];
	static iNumOfStations;
	static iPos = -1;
	static iIndex;
	new Handle:hMapFile;
	if (GetConVarInt(g_cVarLogging))
	{
		LogMessage("Loading the radio stations from \"%s\"", "cfg/sourcemod/radiostations.ini");
	}
	ClearArray(g_hArrayRadioStationNames);
	ClearArray(g_hArrayRadioStationURLs);
	iNumOfStations = 0;
	if (!((hMapFile = OpenFile("cfg/sourcemod/radiostations.ini", "r", false, "GAME"))))
	{
		if (GetConVarInt(g_cVarLogging))
		{
			LogMessage("Unable to open \"%s\"", "cfg/sourcemod/radiostations.ini");
		}
		SetFailState("Unable to open the radiostations.ini file");
		return 0;
	}
	while (!IsEndOfFile(hMapFile) && ReadFileLine(hMapFile, szLineBuffer, 256))
	{
		TrimString(szLineBuffer);
		new var2;
		if (szLineBuffer[0] && szLineBuffer[0] != ';' && szLineBuffer[0] != '/' && szLineBuffer[0] != '/' && szLineBuffer[0] == '"' && szLineBuffer[0] != '
' && szLineBuffer[0] != '
')
		{
			iIndex = 0;
			if ((iPos = BreakString(szLineBuffer[iIndex], szTempBuffer, 128)) != -1)
			{
				iIndex = iPos + iIndex;
				if (!strcmp("Off Page", szTempBuffer, false))
				{
					strcopy(g_szRadioOffPage, 128, szLineBuffer[iIndex]);
				}
				PushArrayString(g_hArrayRadioStationNames, szTempBuffer);
				PushArrayString(g_hArrayRadioStationURLs, szLineBuffer[iIndex]);
				iNumOfStations += 1;
			}
		}
	}
	CloseHandle(hMapFile);
	if (GetConVarInt(g_cVarLogging))
	{
		LogMessage("Finishing parsing \"%s\" - Found %d radio stations", "cfg/sourcemod/radiostations.ini", iNumOfStations);
	}
	return 0;
}

public Handler_PlayRadioStation(Handle:menu, MenuAction:action, client, param)
{
	if (action == MenuAction:4)
	{
		new String:szRadioStationIndex[12];
		new String:szClientName[32];
		new String:szStationName[32];
		new String:szStationURL[128];
		static iStation;
		GetMenuItem(menu, param, szRadioStationIndex, 10, 0, "", 0);
		iStation = StringToInt(szRadioStationIndex, 10);
		GetArrayString(g_hArrayRadioStationNames, iStation, szStationName, 32);
		GetArrayString(g_hArrayRadioStationURLs, iStation, szStationURL, 128);
		if (GetConVarInt(g_cVarRadioStationAdvert))
		{
			GetClientName(client, szClientName, 32);
			PrintToChatAll("\x01\x04[SM-RADIO]\x01 %T", "Started Listening", 0, szClientName, szStationName);
		}
		ShowMOTDPanel(client, "SourceMod Radio", szStationURL, 2);
	}
	return 0;
}

Handle:CreateRadioStationsMenu()
{
	new Handle:hMenu;
	static iArraySize;
	static iIndex;
	new String:szStationIndex[12];
	new String:szTranslation[64];
	new String:szStationName[32];
	hMenu = CreateMenu(Handler_PlayRadioStation, MenuAction:28);
	Format(szTranslation, 64, "%T:", "Stations Menu Title", 0);
	SetMenuTitle(hMenu, szTranslation);
	iArraySize = GetArraySize(g_hArrayRadioStationNames);
	iIndex = 0;
	while (iIndex < iArraySize)
	{
		GetArrayString(g_hArrayRadioStationNames, iIndex, szStationName, 32);
		Format(szStationIndex, 11, "%d", iIndex);
		AddMenuItem(hMenu, szStationIndex, szStationName, 0);
		iIndex += 1;
	}
	return hMenu;
}

public Action:Command_Radio(client, args)
{
	if (GetConVarInt(g_cVarRadioEnable))
	{
		DisplayMenu(g_hRadioStationsMenu, client, 0);
	}
	return Action:3;
}

public Action:Command_Browse(client, args)
{
	if (GetConVarInt(g_cVarRadioEnable))
	{
		if (args == 1)
		{
			new String:szWebsite[128];
			GetCmdArg(1, szWebsite, 128);
			ShowMOTDPanel(client, "SourceMod Browse", szWebsite, 2);
		}
		ReplyToCommand(client, "[SM-RADIO] Invalid browse format");
		ReplyToCommand(client, "[SM-RADIO] Usage: sm_browse \"www.website.com\"");
	}
	return Action:3;
}

public Action:Command_RadioOff(client, args)
{
	new String:szClientName[32];
	if (GetConVarInt(g_cVarRadioEnable))
	{
		LoadMOTDPanel(client, "SourceMod Radio", g_szRadioOffPage, false);
		if (GetConVarInt(g_cVarRadioStationAdvert))
		{
			GetClientName(client, szClientName, 32);
			PrintToChatAll("\x01\x04[SM-RADIO]\x01 %T", "Stopped Listening", 0, szClientName);
		}
	}
	return Action:3;
}

public Action:WelcomeAdvertTimer(Handle:timer, any:client)
{
	new String:szClientName[32];
	new var1;
	if (IsClientConnected(client) && IsClientInGame(client))
	{
		if (GetConVarInt(g_cVarWelcomeMsg))
		{
			GetClientName(client, szClientName, 32);
			PrintToChat(client, "\x01\x04[SM-RADIO]\x01 %T", "Welcome", 0, szClientName);
			PrintToChat(client, "\x01\x04[SM-RADIO]\x01 %T", "Radio Command Info", 0);
		}
	}
	return Action:4;
}

public LoadMOTDPanel(client, String:title[], String:page[], bool:display)
{
	new Handle:kv = CreateKeyValues("data", "", "");
	KvSetString(kv, "title", title);
	KvSetNum(kv, "type", 2);
	KvSetString(kv, "msg", page);
	ShowVGUIPanel(client, "info", kv, display);
	CloseHandle(kv);
	return 0;
}

