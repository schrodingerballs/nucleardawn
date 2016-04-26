public PlVers:__version =
{
	version = 5,
	filevers = "1.7.2",
	date = "06/27/2015",
	time = "19:23:01"
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
public SharedPlugin:__pl_updater =
{
	name = "updater",
	file = "updater.smx",
	required = 0,
};
public Plugin:myinfo =
{
	name = "Server Hop",
	description = "Allows redirecting clients between servers.",
	author = "Stickz",
	version = "1.0.2",
	url = "xenogamers.com"
};
new bool:g_Bool[3];
new serverInt;
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
		Updater_AddPlugin("");
	}
	return void:0;
}

public void:OnPluginStart()
{
	g_Bool[0] = 0;
	g_Bool[2] = 0;
	g_Bool[2] = 0;
	RegAdminCmd("sm_cast", CMD_SwitchAsk, 16384, "ask players to switch server", "", 0);
	RegAdminCmd("sm_reb", CMD_RebAsk, 16384, "ask players to switch server", "", 0);
	HookEvent("round_win", EventRoundWin, EventHookMode:0);
	HookEvent("timeleft_5s", Event_TimeLimit, EventHookMode:2);
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("");
	}
	return void:0;
}

public void:OnMapStart()
{
	g_Bool[0] = 0;
	return void:0;
}

public Action:CMD_RebAsk(client, args)
{
	if (!args)
	{
		PrintToChat(client, "[SM] Usage: !reb <uk1 | uk2| la | nyc>");
		return Action:3;
	}
	decl String:arg1[16];
	GetCmdArg(1, arg1, 16);
	serverInt = getServerInt(arg1);
	if (serverInt == -1)
	{
		PrintToChat(client, "[SM] Usage: !reb <uk1 | uk2| la | nyc>");
	}
	else
	{
		PrintToChatAll("\x05[xG] This server will be shut down for maintenance at round end. Consider pressing f3 to switch to Redstone %s!", getServerName(serverInt));
		g_Bool[0] = 1;
		g_Bool[1] = 1;
	}
	return Action:3;
}

public Action:CMD_SwitchAsk(client, args)
{
	if (!args)
	{
		PrintToChat(client, "[SM] Usage: !cast <uk1 | uk2| la | nyc>");
		return Action:3;
	}
	decl String:arg1[16];
	GetCmdArg(1, arg1, 16);
	serverInt = getServerInt(arg1);
	if (serverInt == -1)
	{
		PrintToChat(client, "[SM] Usage: !cast <uk1 | uk2| la | nyc>");
	}
	else
	{
		PrintToChatAll("\x05[xG] Consider pressing f3 (at round end) to switch to Redstone %s! This server will be passworded!", getServerName(serverInt));
		g_Bool[0] = 1;
		g_Bool[2] = 1;
	}
	return Action:3;
}

public EventRoundWin(Handle:event, String:name[], bool:dontBroadcast)
{
	checkSwitch();
	return 0;
}

public Event_TimeLimit(Handle:event, String:name[], bool:dontBroadcast)
{
	checkSwitch();
	return 0;
}

String:getServerName(sInt, _arg1)
{
	new String:ServerName[16] = "New York";
	switch (sInt)
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
		default:
		{
		}
	}
	return ServerName;
}

String:getServerAddress(sInt, _arg1)
{
	new String:ServerAddress[32] = "70.42.74.73:27015";
	switch (sInt)
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
		default:
		{
		}
	}
	return ServerAddress;
}

getServerInt(String:Arg[])
{
	if (StrEqual(Arg, "nyc", false))
	{
		return 0;
	}
	if (StrEqual(Arg, "ff", false))
	{
		return 1;
	}
	if (StrEqual(Arg, "ff2", false))
	{
		return 2;
	}
	return -1;
}

public Action:TIMER_UnlockServer(Handle:timer)
{
	new String:disablePassword[8];
	ServerCommand("sv_password %s", disablePassword);
	return Action:0;
}

checkSwitch()
{
	if (g_Bool[2])
	{
		g_Bool[2] = 0;
		ServerCommand("sv_password closed");
		CreateTimer(3600.0, TIMER_UnlockServer, any:0, 0);
	}
	if (g_Bool[0])
	{
		askSwitch();
	}
	return 0;
}

askSwitch()
{
	if (g_Bool[1])
	{
		CreateTimer(8.0, TIMER_ShutdownServer, any:0, 0);
	}
	decl String:serverName[16];
	decl String:serverAddress[32];
	getServerName(serverInt);
	getServerAddress(serverInt);
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			new String:display_time[16];
			new Handle:top_values = CreateKeyValues("msg", "", "");
			KvSetString(top_values, "title", "New IP");
			KvSetNum(top_values, "level", 1);
			KvSetString(top_values, "time", display_time);
			CreateDialog(i, top_values, DialogType:0);
			CloseHandle(top_values);
			new Handle:values = CreateKeyValues("msg", "", "");
			KvSetString(values, "time", display_time);
			KvSetString(values, "title", serverAddress);
			CreateDialog(i, values, DialogType:4);
			CloseHandle(values);
			PrintToChat(i, "\x05Redstone %s: Press F3 to accept, or ignore to decline!", serverName);
		}
		i++;
	}
	return 0;
}

public Action:TIMER_ShutdownServer(Handle:timer)
{
	ServerCommand("quit");
	return Action:0;
}

