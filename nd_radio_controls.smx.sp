public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "03/02/2016",
	time = "16:37:30"
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
public SharedPlugin:__pl_sourcecomms =
{
	name = "sourcecomms",
	file = "sourcecomms.smx",
	required = 0,
};
public Plugin:myinfo =
{
	name = "ND Radio Control",
	description = "Blocks default sounds and prevents radio spam",
	author = "databomb edited by stickz",
	version = "1.0.0",
	url = "vintagejailbreak.org"
};
new enemySpottedCount;
new enemySpottedTolerance = 15;
new bool:enemySpottedDisabled;
new last_radio_use[66];
new note[66];
new Handle:cvar_radio_spam_block;
new Handle:cvar_radio_spam_block_time;
new Handle:cvar_radio_spam_block_all;
new Handle:cvar_radio_spam_block_notify;
new bool:notify = 1;
new bool:g_IsRadioBlocked[66];
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

bool:IsValidClient(client, bool:nobots)
{
	new var2;
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
}

public __pl_sourcecomms_SetNTVOptional()
{
	MarkNativeAsOptional("SourceComms_SetClientMute");
	MarkNativeAsOptional("SourceComms_SetClientGag");
	MarkNativeAsOptional("SourceComms_GetClientMuteType");
	MarkNativeAsOptional("SourceComms_GetClientGagType");
	return 0;
}

AddUpdaterLibrary()
{
	return 0;
}

public OnPluginStart()
{
	CreateConVar("sm_radio_spam_block_version", "1.0.0", "Radio Spam Block Version", 270656, false, 0.0, false, 0.0);
	cvar_radio_spam_block = CreateConVar("sm_radio_spam_block", "1", "0 = disabled, 1 = enabled Radio Spam Block functionality", 262144, true, 0.0, true, 1.0);
	cvar_radio_spam_block_time = CreateConVar("sm_radio_spam_block_time", "5", "Time in seconds between radio messages", 262144, true, 1.0, true, 60.0);
	cvar_radio_spam_block_all = CreateConVar("sm_radio_spam_block_all", "0", "0 = disabled, 1 = block all radio messages", 262144, true, 0.0, true, 1.0);
	cvar_radio_spam_block_notify = CreateConVar("sm_radio_spam_block_notify", "1", "0 = disabled, 1 = show a chat message to the player when his radio spam blocked", 262144, true, 0.0, true, 1.0);
	new i;
	while (i < MaxClients)
	{
		last_radio_use[i] = -1;
		i++;
	}
	AddCommandListener(RestrictRadio, "vocalize");
	HookUserMessage(GetUserMessageId("SendAudio"), Message_SendAudio, true, MsgPostHook:-1);
	RegAdminCmd("sm_radioblock", Command_RadioBlock, 4, "Blocks client from using radio", "", 0);
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	LoadTranslations("nd_radio_controls.phrases");
	AddUpdaterLibrary();
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	CreateTimer(900.0, TIMER_ResetEnemySpottedCount, any:0, 3);
	return 0;
}

public Action:TIMER_ResetEnemySpottedCount(Handle:timer)
{
	if (!enemySpottedDisabled)
	{
		new var1;
		if (enemySpottedCount > 10)
		{
			var1 = 5;
		}
		else
		{
			var1 = 0;
		}
		enemySpottedCount = var1;
		return Action:0;
	}
	return Action:3;
}

public OnMapEnd()
{
	enemySpottedCount = 0;
	enemySpottedTolerance = 15;
	enemySpottedDisabled = false;
	return 0;
}

public Action:Command_RadioBlock(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_radioblock <player>");
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
		PerformRadioBlock(target);
		i++;
	}
	return Action:3;
}

PerformRadioBlock(target)
{
	if (!g_IsRadioBlocked[target])
	{
		g_IsRadioBlocked[target] = 1;
	}
	else
	{
		g_IsRadioBlocked[target] = 0;
	}
	return 0;
}

public OnClientDisconnect(client)
{
	g_IsRadioBlocked[client] = 0;
	return 0;
}

public Action:Message_SendAudio(UserMsg:msg_hd, Handle:bf, players[], playersNum, bool:reliable, bool:init)
{
	decl String:sUserMessage[400];
	BfReadString(bf, sUserMessage, 400, false);
	if (StrContains(sUserMessage, "potte", true) != -1)
	{
		enemySpottedCount += 1;
		if (isSilencedClientPresent())
		{
			return Action:3;
		}
		if (enemySpottedCount >= enemySpottedTolerance)
		{
			if (!enemySpottedDisabled)
			{
				enemySpottedDisabled = true;
			}
		}
	}
	return Action:0;
}

public Action:RestrictRadio(client, String:command[], args)
{
	if (isSilenced(client))
	{
		return Action:3;
	}
	if (g_IsRadioBlocked[client])
	{
		return Action:3;
	}
	if (!GetConVarBool(cvar_radio_spam_block))
	{
		return Action:0;
	}
	notify = GetConVarBool(cvar_radio_spam_block_notify);
	if (GetConVarBool(cvar_radio_spam_block_all))
	{
		if (notify)
		{
			PrintToChat(client, "\x05[xG] %t", "Radio Disabled");
		}
		return Action:3;
	}
	if (last_radio_use[client] == -1)
	{
		last_radio_use[client] = GetTime({0,0});
		return Action:0;
	}
	new time = GetTime({0,0}) - last_radio_use[client];
	new block_time = GetConVarInt(cvar_radio_spam_block_time);
	if (time >= block_time)
	{
		last_radio_use[client] = GetTime({0,0});
		return Action:0;
	}
	new wait_time = block_time - time;
	new var1;
	if (wait_time != note[client] && notify)
	{
		decl wTime;
		new var2;
		if (wait_time <= 1)
		{
			var2 = 1;
		}
		else
		{
			var2 = wait_time;
		}
		wTime = var2;
		PrintToChat(client, "\x05[xG] %t", "Radio Wait", wTime);
	}
	note[client] = wait_time;
	return Action:3;
}

bool:isSilenced(client)
{
	new var1;
	return SourceComms_GetClientMuteType(client) && SourceComms_GetClientGagType(client);
}

bool:isSilencedClientPresent()
{
	new client = 1;
	while (client <= MaxClients)
	{
		new var2;
		if (IsValidClient(client, true) && (isSilenced(client) || g_IsRadioBlocked[client]))
		{
			return true;
		}
		client++;
	}
	return false;
}

