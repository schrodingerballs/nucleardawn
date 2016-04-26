public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "04:34:21"
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
public SharedPlugin:__pl_mapchooser =
{
	name = "mapchooser",
	file = "mapchooser.smx",
	required = 0,
};
public Plugin:myinfo =
{
	name = "Basic Info Triggers",
	description = "Adds ff, timeleft, thetime, and others.",
	author = "AlliedModders LLC",
	version = "1.7.0",
	url = "http://www.sourcemod.net/"
};
new ConVar:g_Cvar_TriggerShow;
new ConVar:g_Cvar_TimeleftInterval;
new ConVar:g_Cvar_FriendlyFire;
new Handle:g_Timer_TimeShow;
new ConVar:g_Cvar_WinLimit;
new ConVar:g_Cvar_FragLimit;
new ConVar:g_Cvar_MaxRounds;
new bool:mapchooser;
new g_TotalRounds;
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

public __pl_mapchooser_SetNTVOptional()
{
	MarkNativeAsOptional("NominateMap");
	MarkNativeAsOptional("RemoveNominationByMap");
	MarkNativeAsOptional("RemoveNominationByOwner");
	MarkNativeAsOptional("GetExcludeMapList");
	MarkNativeAsOptional("GetNominatedMapList");
	MarkNativeAsOptional("CanMapChooserStartVote");
	MarkNativeAsOptional("InitiateMapChooserVote");
	MarkNativeAsOptional("HasEndOfMapVoteFinished");
	MarkNativeAsOptional("EndOfMapVoteEnabled");
	return 0;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("basetriggers.phrases");
	g_Cvar_TriggerShow = CreateConVar("sm_trigger_show", "0", "Display triggers message to all players? (0 off, 1 on, def. 0)", 0, true, 0.0, true, 1.0);
	g_Cvar_TimeleftInterval = CreateConVar("sm_timeleft_interval", "0.0", "Display timeleft every x seconds. Default 0.", 0, true, 0.0, true, 1800.0);
	g_Cvar_FriendlyFire = FindConVar("mp_friendlyfire");
	RegConsoleCmd("timeleft", Command_Timeleft, "", 0);
	RegConsoleCmd("nextmap", Command_Nextmap, "", 0);
	RegConsoleCmd("motd", Command_Motd, "", 0);
	RegConsoleCmd("ff", Command_FriendlyFire, "", 0);
	ConVar.AddChangeHook(g_Cvar_TimeleftInterval, ConVarChange_TimeleftInterval);
	decl String:folder[64];
	GetGameFolderName(folder, 64);
	if (strcmp(folder, "insurgency", true))
	{
		HookEvent("game_start", Event_GameStart, EventHookMode:1);
	}
	else
	{
		HookEvent("game_newmap", Event_GameStart, EventHookMode:1);
	}
	if (strcmp(folder, "nucleardawn", true))
	{
		HookEvent("round_end", Event_RoundEnd, EventHookMode:1);
	}
	else
	{
		HookEvent("round_win", Event_RoundEnd, EventHookMode:1);
	}
	HookEventEx("teamplay_win_panel", Event_TeamPlayWinPanel, EventHookMode:1);
	HookEventEx("teamplay_restart_round", Event_TFRestartRound, EventHookMode:1);
	HookEventEx("arena_win_panel", Event_TeamPlayWinPanel, EventHookMode:1);
	g_Cvar_WinLimit = FindConVar("mp_winlimit");
	g_Cvar_FragLimit = FindConVar("mp_fraglimit");
	g_Cvar_MaxRounds = FindConVar("mp_maxrounds");
	mapchooser = LibraryExists("mapchooser");
	return void:0;
}

public void:OnMapStart()
{
	g_TotalRounds = 0;
	return void:0;
}

public Event_TFRestartRound(Handle:event, String:name[], bool:dontBroadcast)
{
	g_TotalRounds = 0;
	return 0;
}

public Event_GameStart(Handle:event, String:name[], bool:dontBroadcast)
{
	g_TotalRounds = 0;
	return 0;
}

public Event_TeamPlayWinPanel(Event:event, String:name[], bool:dontBroadcast)
{
	new var1;
	if (Event.GetInt(event, "round_complete", 0) == 1 || StrEqual(name, "arena_win_panel", true))
	{
		g_TotalRounds += 1;
	}
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	g_TotalRounds += 1;
	return 0;
}

public void:OnLibraryRemoved(String:name[])
{
	if (StrEqual(name, "mapchooser", true))
	{
		mapchooser = false;
	}
	return void:0;
}

public void:OnLibraryAdded(String:name[])
{
	if (StrEqual(name, "mapchooser", true))
	{
		mapchooser = true;
	}
	return void:0;
}

public ConVarChange_TimeleftInterval(Handle:convar, String:oldValue[], String:newValue[])
{
	new Float:newval = StringToFloat(newValue);
	if (newval < 1.0)
	{
		if (g_Timer_TimeShow)
		{
			KillTimer(g_Timer_TimeShow, false);
		}
		return 0;
	}
	if (g_Timer_TimeShow)
	{
		KillTimer(g_Timer_TimeShow, false);
		g_Timer_TimeShow = CreateTimer(newval, Timer_DisplayTimeleft, any:0, 1);
	}
	else
	{
		g_Timer_TimeShow = CreateTimer(newval, Timer_DisplayTimeleft, any:0, 1);
	}
	return 0;
}

public Action:Timer_DisplayTimeleft(Handle:timer)
{
	ShowTimeLeft(0, 0);
	return Action:0;
}

public Action:Command_Timeleft(client, args)
{
	ShowTimeLeft(client, 2);
	return Action:3;
}

public Action:Command_Nextmap(client, args)
{
	new var1;
	if (client && !IsClientInGame(client))
	{
		return Action:3;
	}
	decl String:map[64];
	GetNextMap(map, 64);
	new var2;
	if (mapchooser && EndOfMapVoteEnabled() && !HasEndOfMapVoteFinished())
	{
		ReplyToCommand(client, "[SM] %t", "Pending Vote");
	}
	else
	{
		ReplyToCommand(client, "[SM] %t", "Next Map", map);
	}
	return Action:3;
}

public Action:Command_Motd(client, args)
{
	if (client)
	{
		if (!IsClientInGame(client))
		{
			return Action:3;
		}
		ShowMOTDPanel(client, "Message Of The Day", "motd", 1);
		return Action:3;
	}
	ReplyToCommand(client, "[SM] %t", "Command is in-game only");
	return Action:3;
}

public Action:Command_FriendlyFire(client, args)
{
	if (client)
	{
		if (!IsClientInGame(client))
		{
			return Action:3;
		}
		ShowFriendlyFire(client);
		return Action:3;
	}
	ReplyToCommand(client, "[SM] %t", "Command is in-game only");
	return Action:3;
}

public void:OnClientSayCommand_Post(client, String:command[], String:sArgs[])
{
	if (strcmp(sArgs, "timeleft", false))
	{
		if (strcmp(sArgs, "thetime", false))
		{
			if (strcmp(sArgs, "ff", false))
			{
				if (strcmp(sArgs, "currentmap", false))
				{
					if (strcmp(sArgs, "nextmap", false))
					{
						if (!(strcmp(sArgs, "motd", false)))
						{
							ShowMOTDPanel(client, "Message Of The Day", "motd", 1);
						}
					}
					new String:map[32];
					GetNextMap(map, 32);
					if (ConVar.IntValue.get(g_Cvar_TriggerShow))
					{
						new var1;
						if (mapchooser && EndOfMapVoteEnabled() && !HasEndOfMapVoteFinished())
						{
							PrintToChatAll("[SM] %t", "Pending Vote");
						}
						else
						{
							PrintToChatAll("[SM] %t", "Next Map", map);
						}
					}
					else
					{
						new var2;
						if (mapchooser && EndOfMapVoteEnabled() && !HasEndOfMapVoteFinished())
						{
							PrintToChat(client, "[SM] %t", "Pending Vote");
						}
						PrintToChat(client, "[SM] %t", "Next Map", map);
					}
				}
				new String:map[64];
				GetCurrentMap(map, 64);
				if (ConVar.IntValue.get(g_Cvar_TriggerShow))
				{
					PrintToChatAll("[SM] %t", "Current Map", map);
				}
				else
				{
					PrintToChat(client, "[SM] %t", "Current Map", map);
				}
			}
			ShowFriendlyFire(client);
		}
		new String:ctime[64];
		FormatTime(ctime, 64, NULL_STRING, -1);
		if (ConVar.IntValue.get(g_Cvar_TriggerShow))
		{
			PrintToChatAll("[SM] %t", "Thetime", ctime);
		}
		else
		{
			PrintToChat(client, "[SM] %t", "Thetime", ctime);
		}
	}
	else
	{
		ShowTimeLeft(client, 1);
	}
	return void:0;
}

ShowTimeLeft(client, who)
{
	new bool:lastround;
	new bool:written;
	new bool:notimelimit;
	new String:finalOutput[1024];
	new var2;
	if (who && (who == 1 && ConVar.IntValue.get(g_Cvar_TriggerShow)))
	{
		client = 0;
	}
	new timeleft;
	if (GetMapTimeLeft(timeleft))
	{
		new mins;
		new secs;
		new timelimit;
		if (0 < timeleft)
		{
			mins = timeleft / 60;
			secs = timeleft % 60;
			written = true;
			FormatEx(finalOutput, 1024, "%T %d:%02d", "Timeleft", client, mins, secs);
		}
		else
		{
			new var3;
			if (GetMapTimeLimit(timelimit) && timelimit)
			{
				notimelimit = true;
			}
			lastround = true;
		}
	}
	if (!lastround)
	{
		if (g_Cvar_WinLimit)
		{
			new winlimit = ConVar.IntValue.get(g_Cvar_WinLimit);
			if (0 < winlimit)
			{
				if (written)
				{
					new len = strlen(finalOutput);
					if (len < 1024)
					{
						if (winlimit > 1)
						{
							FormatEx(finalOutput[len], 1024 - len, "%T", "WinLimitAppendPlural", client, winlimit);
						}
						FormatEx(finalOutput[len], 1024 - len, "%T", "WinLimitAppend", client);
					}
				}
				if (winlimit > 1)
				{
					FormatEx(finalOutput, 1024, "%T", "WinLimitPlural", client, winlimit);
				}
				else
				{
					FormatEx(finalOutput, 1024, "%T", "WinLimit", client);
				}
				written = true;
			}
		}
		if (g_Cvar_FragLimit)
		{
			new fraglimit = ConVar.IntValue.get(g_Cvar_FragLimit);
			if (0 < fraglimit)
			{
				if (written)
				{
					new len = strlen(finalOutput);
					if (len < 1024)
					{
						if (fraglimit > 1)
						{
							FormatEx(finalOutput[len], 1024 - len, "%T", "FragLimitAppendPlural", client, fraglimit);
						}
						FormatEx(finalOutput[len], 1024 - len, "%T", "FragLimitAppend", client);
					}
				}
				if (fraglimit > 1)
				{
					FormatEx(finalOutput, 1024, "%T", "FragLimitPlural", client, fraglimit);
				}
				else
				{
					FormatEx(finalOutput, 1024, "%T", "FragLimit", client);
				}
				written = true;
			}
		}
		if (g_Cvar_MaxRounds)
		{
			new maxrounds = ConVar.IntValue.get(g_Cvar_MaxRounds);
			if (0 < maxrounds)
			{
				new remaining = maxrounds - g_TotalRounds;
				if (written)
				{
					new len = strlen(finalOutput);
					if (len < 1024)
					{
						if (remaining > 1)
						{
							FormatEx(finalOutput[len], 1024 - len, "%T", "MaxRoundsAppendPlural", client, remaining);
						}
						FormatEx(finalOutput[len], 1024 - len, "%T", "MaxRoundsAppend", client);
					}
				}
				else
				{
					if (remaining > 1)
					{
						FormatEx(finalOutput, 1024, "%T", "MaxRoundsPlural", client, remaining);
					}
					else
					{
						FormatEx(finalOutput, 1024, "%T", "MaxRounds", client);
					}
					written = true;
				}
			}
		}
	}
	if (lastround)
	{
		FormatEx(finalOutput, 1024, "%T", "LastRound", client);
	}
	else
	{
		new var4;
		if (notimelimit && !written)
		{
			FormatEx(finalOutput, 1024, "%T", "NoTimelimit", client);
		}
	}
	new var6;
	if (who && (who == 1 && ConVar.IntValue.get(g_Cvar_TriggerShow)))
	{
		PrintToChatAll("[SM] %s", finalOutput);
	}
	else
	{
		new var7;
		if (client && IsClientInGame(client))
		{
			PrintToChat(client, "[SM] %s", finalOutput);
		}
	}
	if (!client)
	{
		PrintToServer("[SM] %s", finalOutput);
	}
	return 0;
}

ShowFriendlyFire(client)
{
	if (g_Cvar_FriendlyFire)
	{
		new String:phrase[24];
		if (ConVar.BoolValue.get(g_Cvar_FriendlyFire))
		{
			strcopy(phrase, 24, "Friendly Fire On");
		}
		else
		{
			strcopy(phrase, 24, "Friendly Fire Off");
		}
		if (ConVar.IntValue.get(g_Cvar_TriggerShow))
		{
			PrintToChatAll("[SM] %t", phrase);
		}
		else
		{
			PrintToChat(client, "[SM] %t", phrase);
		}
	}
	return 0;
}

