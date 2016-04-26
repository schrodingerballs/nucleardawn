public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "03/25/2016",
	time = "17:08:02"
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
new bool:roundStarted;
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

bool:IsPlayerBot(client)
{
	new var1;
	GetClientAuthId(client, AuthIdType:1, var1, 64, true);
	new var2;
	new idx;
	while (idx < 6)
	{
		if (StrContains(var2[idx], var1, false) > -1)
		{
			return true;
		}
		idx++;
	}
	return false;
}

public OnPluginStart()
{
	AddEventHooks();
	return 0;
}

public OnMapEnd()
{
	roundStarted = false;
	return 0;
}

public OnClientPutInServer(client)
{
	new var1;
	if (roundStarted && IsVirtualBox(client))
	{
		CreateTimer(3.0, TIMER_SetBotSpectate, GetClientUserId(client), 2);
	}
	return 0;
}

public Action:TIMER_SetBotSpectate(Handle:timer, any:userid)
{
	new client = GetClientOfUserId(client);
	if (client)
	{
		ChangeClientTeam(client, 1);
		return Action:3;
	}
	return Action:3;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	roundStarted = true;
	new client = 1;
	while (client <= MaxClients)
	{
		if (IsVirtualBox(client))
		{
			CreateTimer(3.0, TIMER_SetBotSpectate, GetClientUserId(client), 2);
		}
		client++;
	}
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	roundStarted = false;
	return 0;
}

bool:IsVirtualBox(client)
{
	new var1;
	return IsClientInGame(client) && !IsFakeClient(client) && IsPlayerBot(client);
}

AddEventHooks()
{
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	HookEvent("round_win", Event_RoundEnd, EventHookMode:0);
	return 0;
}

