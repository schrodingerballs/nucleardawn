public PlVers:__version =
{
	version = 5,
	filevers = "1.6.0",
	date = "07/14/2014",
	time = "11:06:17"
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
new Handle:g_hEnabled;
new Handle:g_hVoice;
new Handle:g_hConnect;
new Handle:g_hDisconnect;
new Handle:g_hChangeClass;
new Handle:g_hTeam;
new Handle:g_hArena;
new Handle:g_hMaxStreak;
new Handle:g_hCvar;
new Handle:g_hAllText;
new bool:bTF2;
public Plugin:myinfo =
{
	name = "Tidy Chat",
	description = "Cleans up the chat area.",
	author = "linux_lover",
	version = "0.4",
	url = "http://sourcemod.net"
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
	VerifyCoreVersion();
	return 0;
}

public OnPluginStart()
{
	CreateConVar("sm_tidychat_version", "0.4", "Tidy Chat Version", 270656, false, 0.0, false, 0.0);
	g_hEnabled = CreateConVar("sm_tidychat_on", "1", "0/1 On/off", 0, false, 0.0, false, 0.0);
	g_hVoice = CreateConVar("sm_tidychat_voice", "1", "0/1 Tidy (Voice) messages", 0, false, 0.0, false, 0.0);
	g_hConnect = CreateConVar("sm_tidychat_connect", "1", "0/1 Tidy connect messages", 0, false, 0.0, false, 0.0);
	g_hDisconnect = CreateConVar("sm_tidychat_disconnect", "1", "0/1 Tidy disconnect messsages", 0, false, 0.0, false, 0.0);
	g_hChangeClass = CreateConVar("sm_tidychat_class", "1", "0/1 Tidy class change messages", 0, false, 0.0, false, 0.0);
	g_hTeam = CreateConVar("sm_tidychat_team", "1", "0/1 Tidy team join messages", 0, false, 0.0, false, 0.0);
	g_hArena = CreateConVar("sm_tidychat_arena", "1", "0/1 Tidy arena team resize messages", 0, false, 0.0, false, 0.0);
	g_hMaxStreak = CreateConVar("sm_tidychat_streak", "1", "0/1 Tidy (arena) team scramble messages", 0, false, 0.0, false, 0.0);
	g_hCvar = CreateConVar("sm_tidychat_cvar", "1", "0/1 Tidy cvar messages", 0, false, 0.0, false, 0.0);
	g_hAllText = CreateConVar("sm_tidychat_alltext", "0", "0/1 Tidy all chat messages from plugins", 0, false, 0.0, false, 0.0);
	HookEvent("player_connect", Event_PlayerConnect, EventHookMode:0);
	HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode:0);
	HookEvent("player_team", Event_PlayerTeam, EventHookMode:0);
	HookEvent("server_cvar", Event_Cvar, EventHookMode:0);
	HookUserMessage(GetUserMessageId("TextMsg"), UserMessageHook_Class, true, MsgPostHook:-1);
	new String:strGame[12];
	GetGameFolderName(strGame, 10);
	if (!(strcmp(strGame, "tf", true)))
	{
		bTF2 = true;
		HookUserMessage(GetUserMessageId("VoiceSubtitle"), UserMessageHook, true, MsgPostHook:-1);
		HookEvent("player_changeclass", Event_ChangeClass, EventHookMode:0);
		HookEvent("arena_match_maxstreak", Event_MaxStreak, EventHookMode:0);
	}
	return 0;
}

public Action:Event_PlayerConnect(Handle:event, String:name[], bool:dontBroadcast)
{
	new var1;
	if (GetConVarInt(g_hEnabled) && GetConVarInt(g_hConnect))
	{
		SetEventBroadcast(event, true);
	}
	return Action:0;
}

public Action:Event_PlayerDisconnect(Handle:event, String:name[], bool:dontBroadcast)
{
	new var1;
	if (GetConVarInt(g_hEnabled) && GetConVarInt(g_hDisconnect))
	{
		SetEventBroadcast(event, true);
	}
	return Action:0;
}

public Action:Event_ChangeClass(Handle:event, String:name[], bool:dontBroadcast)
{
	new var1;
	if (GetConVarInt(g_hEnabled) && GetConVarInt(g_hChangeClass))
	{
		SetEventBroadcast(event, true);
	}
	return Action:0;
}

public Action:Event_PlayerTeam(Handle:event, String:name[], bool:dontBroadcast)
{
	new var1;
	if (GetConVarInt(g_hEnabled) && GetConVarInt(g_hTeam))
	{
		if (!GetEventBool(event, "silent"))
		{
			SetEventBroadcast(event, true);
		}
	}
	return Action:0;
}

public Action:Event_MaxStreak(Handle:event, String:name[], bool:dontBroadcast)
{
	new var1;
	if (GetConVarInt(g_hEnabled) && GetConVarInt(g_hMaxStreak))
	{
		SetEventBroadcast(event, true);
	}
	return Action:0;
}

public Action:Event_Cvar(Handle:event, String:name[], bool:dontBroadcast)
{
	new var1;
	if (GetConVarInt(g_hEnabled) && GetConVarInt(g_hCvar))
	{
		SetEventBroadcast(event, true);
	}
	return Action:0;
}

public Action:UserMessageHook(UserMsg:msg_id, Handle:bf, players[], playersNum, bool:reliable, bool:init)
{
	new var1;
	if (GetConVarInt(g_hEnabled) && GetConVarInt(g_hVoice))
	{
		return Action:3;
	}
	return Action:0;
}

public Action:UserMessageHook_Class(UserMsg:msg_id, Handle:bf, players[], playersNum, bool:reliable, bool:init)
{
	if (GetConVarInt(g_hEnabled))
	{
		if (GetConVarInt(g_hAllText))
		{
			return Action:3;
		}
		if (bTF2)
		{
			new String:strMessage[52];
			BfReadString(bf, strMessage, 50, true);
			new var1;
			if (GetConVarInt(g_hTeam) && StrContains(strMessage, "#game_", true) == 1)
			{
				return Action:3;
			}
			new var2;
			if (GetConVarInt(g_hArena) && StrContains(strMessage, "#TF_Arena_Team", true) == 1)
			{
				return Action:3;
			}
		}
	}
	return Action:0;
}

