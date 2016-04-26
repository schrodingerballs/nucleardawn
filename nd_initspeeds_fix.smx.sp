public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "04/21/2016",
	time = "15:50:41"
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
public Extension:__ext_sdkhooks =
{
	name = "SDKHooks",
	file = "sdkhooks.ext",
	autoload = 1,
	required = 1,
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

getOtherTeam(team)
{
	new var1;
	if (team == 2)
	{
		var1 = 3;
	}
	else
	{
		var1 = 2;
	}
	return var1;
}

public OnPluginStart()
{
	HookEvent("structure_death", Event_StructDeath, EventHookMode:1);
	HookEvent("structure_damage_sparse", Event_BunkerDamage, EventHookMode:1);
	return 0;
}

public Event_StructDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!(GetEventInt(event, "type")))
	{
		new client = GetClientOfUserId(GetEventInt(event, "attacker"));
		new team = getOtherTeam(GetClientTeam(client));
		RemoveTransportGates(team);
	}
	return 0;
}

public Event_BunkerDamage(Handle:event, String:name[], bool:dontBroadcast)
{
	if (GetEventBool(event, "bunker"))
	{
		new bunkerIDX = GetEventInt(event, "entindex");
		new health = GetEntProp(bunkerIDX, PropType:0, "m_iHealth", 4, 0);
		if (health < 1500)
		{
			new team = GetEventInt(event, "ownerteam");
			RemoveTransportGates(team);
		}
	}
	return 0;
}

RemoveTransportGates(team)
{
	new loopEntity = -1;
	while ((loopEntity = FindEntityByClassname(loopEntity, "struct_transport_gate")) != -1)
	{
		if (team == GetEntProp(loopEntity, PropType:0, "m_iTeamNum", 4, 0))
		{
			SDKHooks_TakeDamage(loopEntity, 0, 0, 10000.0, 0, -1, NULL_VECTOR, NULL_VECTOR);
		}
	}
	return 0;
}

