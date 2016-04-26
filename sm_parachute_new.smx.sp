public PlVers:__version =
{
	version = 5,
	filevers = "1.7.2",
	date = "07/31/2015",
	time = "14:19:47"
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
public SharedPlugin:__pl_updater =
{
	name = "updater",
	file = "updater.smx",
	required = 0,
};
new g_iVelocity = -1;
new g_maxplayers = -1;
new String:path_model[256];
new String:path_pack[256];
new String:path_texture[256];
new ConVar:g_fallspeed;
new ConVar:g_linear;
new ConVar:g_version;
new ConVar:g_model;
new ConVar:g_decrease;
new cl_flags;
new Float:speed[3];
new bool:isfallspeed;
new bool:inUse[66];
new bool:hasModel[66];
new Parachute_Ent[66];
public Plugin:myinfo =
{
	name = "SM Parachute",
	description = "To use your parachute press and hold your E(+use) button while falling.",
	author = "SWAT_88 edited by Stickz",
	version = "1.0.8",
	url = "http://www.sourcemod.net/"
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

Float:operator*(Float:,_:)(Float:oper1, oper2)
{
	return oper1 * float(oper2);
}

bool:operator>=(Float:,_:)(Float:oper1, oper2)
{
	return oper1 >= float(oper2);
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

StrCat(String:buffer[], maxlength, String:source[])
{
	new len = strlen(buffer);
	if (len >= maxlength)
	{
		return 0;
	}
	return Format(buffer[len], maxlength - len, "%s", source);
}

SetEntityMoveType(entity, MoveType:mt)
{
	static bool:gotconfig;
	static String:datamap[32];
	if (!gotconfig)
	{
		new Handle:gc = LoadGameConfigFile("core.games");
		new bool:exists = GameConfGetKeyValue(gc, "m_MoveType", datamap, 32);
		CloseHandle(gc);
		if (!exists)
		{
			strcopy(datamap, 32, "m_MoveType");
		}
		gotconfig = true;
	}
	SetEntProp(entity, PropType:1, datamap, mt, 4, 0);
	return 0;
}

SetEntityGravity(entity, Float:amount)
{
	static bool:gotconfig;
	static String:datamap[32];
	if (!gotconfig)
	{
		new Handle:gc = LoadGameConfigFile("core.games");
		new bool:exists = GameConfGetKeyValue(gc, "m_flGravity", datamap, 32);
		CloseHandle(gc);
		if (!exists)
		{
			strcopy(datamap, 32, "m_flGravity");
		}
		gotconfig = true;
	}
	SetEntPropFloat(entity, PropType:1, datamap, amount, 0);
	return 0;
}

AddFileToDownloadsTable(String:filename[])
{
	static table = -1;
	if (table == -1)
	{
		table = FindStringTable("downloadables");
	}
	new bool:save = LockStringTables(false);
	AddToStringTable(table, filename, "", -1);
	LockStringTables(save);
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
	LoadTranslations("sm_parachute.phrases");
	g_fallspeed = CreateConVar("sm_parachute_fallspeed", "125", "", 0, false, 0.0, false, 0.0);
	g_linear = CreateConVar("sm_parachute_linear", "1", "", 0, false, 0.0, false, 0.0);
	g_version = CreateConVar("sm_parachute_version", "1.0.8", "SM Parachute Version", 256, false, 0.0, false, 0.0);
	g_model = CreateConVar("sm_parachute_model", "1", "", 0, false, 0.0, false, 0.0);
	g_decrease = CreateConVar("sm_parachute_decrease", "50", "", 0, false, 0.0, false, 0.0);
	g_iVelocity = FindSendPropOffs("CBasePlayer", "m_vecVelocity[0]");
	g_maxplayers = GetMaxClients();
	SetConVarString(g_version, "1.0.8", false, false);
	InitModel();
	HookEvent("player_death", PlayerDeath, EventHookMode:1);
	ConVar.AddChangeHook(g_linear, CvarChange_Linear);
	ConVar.AddChangeHook(g_model, CvarChange_Model);
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("");
	}
	return void:0;
}

public InitModel()
{
	Format(path_model, 255, "models/parachute/%s", "parachute_carbon");
	Format(path_pack, 255, "materials/models/parachute/%s", "pack_carbon");
	Format(path_texture, 255, "materials/models/parachute/%s", "parachute_carbon");
	return 0;
}

public void:OnMapStart()
{
	new String:path[256];
	strcopy(path, 255, path_model);
	StrCat(path, 255, ".mdl");
	PrecacheModel(path, true);
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_model);
	StrCat(path, 255, ".dx80.vtx");
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_model);
	StrCat(path, 255, ".dx90.vtx");
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_model);
	StrCat(path, 255, ".mdl");
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_model);
	StrCat(path, 255, ".sw.vtx");
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_model);
	StrCat(path, 255, ".vvd");
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_model);
	StrCat(path, 255, ".xbox.vtx");
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_pack);
	StrCat(path, 255, ".vmt");
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_pack);
	StrCat(path, 255, ".vtf");
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_texture);
	StrCat(path, 255, ".vmt");
	AddFileToDownloadsTable(path);
	strcopy(path, 255, path_texture);
	StrCat(path, 255, ".vtf");
	AddFileToDownloadsTable(path);
	return void:0;
}

public OnEventShutdown()
{
	UnhookEvent("player_death", PlayerDeath, EventHookMode:1);
	return 0;
}

public void:OnClientPutInServer(client)
{
	inUse[client] = 0;
	hasModel[client] = 0;
	g_maxplayers = GetMaxClients();
	return void:0;
}

public void:OnClientDisconnect(client)
{
	g_maxplayers = GetMaxClients();
	CloseParachute(client);
	return void:0;
}

public Action:PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	EndPara(client);
	return Action:0;
}

public StartPara(client, bool:open)
{
	if (g_iVelocity == -1)
	{
		return 0;
	}
	decl Float:velocity[3];
	new Float:fallspeed = -1082130432 * ConVar.IntValue.get(g_fallspeed);
	GetEntDataVector(client, g_iVelocity, velocity);
	if (velocity[2] >= fallspeed)
	{
		isfallspeed = true;
	}
	if (velocity[2] < 0.0)
	{
		if (isfallspeed)
		{
			if (ConVar.IntValue.get(g_linear))
			{
				new var1;
				if (ConVar.IntValue.get(g_linear) == 1 || 0.0 == ConVar.FloatValue.get(g_decrease))
				{
					velocity[2] = fallspeed;
				}
			}
		}
		else
		{
			velocity[2] += ConVar.FloatValue.get(g_decrease);
		}
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velocity);
		SetEntDataVector(client, g_iVelocity, velocity, false);
		SetEntityGravity(client, 0.1);
		if (open)
		{
			OpenParachute(client);
		}
	}
	return 0;
}

public EndPara(client)
{
	SetEntityGravity(client, 1.0);
	inUse[client] = 0;
	CloseParachute(client);
	return 0;
}

public OpenParachute(client)
{
	decl String:path[256];
	strcopy(path, 255, path_model);
	StrCat(path, 255, ".mdl");
	if (ConVar.IntValue.get(g_model) == 1)
	{
		decl String:sTempName[64];
		Format(sTempName, 64, "Parachute_%d", GetClientUserId(client));
		DispatchKeyValue(client, "targetname", sTempName);
		Parachute_Ent[client] = CreateEntityByName("prop_dynamic_override", -1);
		DispatchKeyValue(Parachute_Ent[client], "parentname", sTempName);
		DispatchKeyValue(Parachute_Ent[client], "model", path);
		SetEntityMoveType(Parachute_Ent[client], MoveType:8);
		DispatchSpawn(Parachute_Ent[client]);
		hasModel[client] = 1;
		decl Float:Client_Origin[3];
		decl Float:Client_Angles[3];
		new Float:Parachute_Angles[3] = 0.0;
		GetClientAbsOrigin(client, Client_Origin);
		GetClientAbsAngles(client, Client_Angles);
		Parachute_Angles[1] = Client_Angles[1];
		TeleportEntity(Parachute_Ent[client], Client_Origin, Parachute_Angles, NULL_VECTOR);
		SetVariantString(sTempName);
		AcceptEntityInput(Parachute_Ent[client], "SetParent", Parachute_Ent[client], Parachute_Ent[client], 0);
		SDKHook(Parachute_Ent[client], SDKHookType:6, Hook_SetTransmit);
	}
	return 0;
}

public CloseParachute(client)
{
	new var1;
	if (hasModel[client] && IsValidEntity(Parachute_Ent[client]))
	{
		SDKUnhook(Parachute_Ent[client], SDKHookType:6, Hook_SetTransmit);
		AcceptEntityInput(Parachute_Ent[client], "Kill", -1, -1, 0);
		hasModel[client] = 0;
	}
	return 0;
}

public Check(client)
{
	GetEntDataVector(client, g_iVelocity, speed);
	cl_flags = GetEntityFlags(client);
	new var1;
	if (speed[2] >= 0.0 || cl_flags & 1)
	{
		EndPara(client);
	}
	return 0;
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	new var1;
	if (IsClientInGame(client) && !IsFakeClient(client))
	{
		new var3;
		if (IsPlayerAlive(client) && (buttons & 32 || buttons & 2))
		{
			if (!inUse[client])
			{
				inUse[client] = 1;
				isfallspeed = false;
				StartPara(client, true);
			}
			StartPara(client, false);
		}
		else
		{
			if (inUse[client])
			{
				inUse[client] = 0;
				EndPara(client);
			}
		}
		Check(client);
	}
	return Action:0;
}

public CvarChange_Linear(ConVar:cvar, String:oldvalue[], String:newvalue[])
{
	if (!(StringToInt(newvalue, 10)))
	{
		new client = 1;
		while (client <= g_maxplayers)
		{
			new var1;
			if (IsClientInGame(client) && IsPlayerAlive(client))
			{
				SetEntityMoveType(client, MoveType:2);
			}
			client++;
		}
	}
	return 0;
}

public CvarChange_Model(ConVar:cvar, String:oldvalue[], String:newvalue[])
{
	if (!(StringToInt(newvalue, 10)))
	{
		new client = 1;
		while (client <= g_maxplayers)
		{
			new var1;
			if (IsClientInGame(client) && IsPlayerAlive(client))
			{
				CloseParachute(client);
			}
			client++;
		}
	}
	return 0;
}

public Action:Hook_SetTransmit(entity)
{
	new owner = -1;
	new loopClient = 1;
	while (loopClient <= MaxClients)
	{
		if (IsClientInGame(loopClient))
		{
			if (Parachute_Ent[loopClient] == entity)
			{
				owner = loopClient;
				if (owner == -1)
				{
					return Action:0;
				}
				new owner_condition = GetEntProp(owner, PropType:0, "m_nPlayerCond", 4, 0);
				if (owner_condition & 2)
				{
					return Action:3;
				}
				return Action:0;
			}
		}
		loopClient++;
	}
	if (owner == -1)
	{
		return Action:0;
	}
	new owner_condition = GetEntProp(owner, PropType:0, "m_nPlayerCond", 4, 0);
	if (owner_condition & 2)
	{
		return Action:3;
	}
	return Action:0;
}

public bool:TraceEntityFilter(entity, contentsMask)
{
	new var1;
	return entity && entity > MaxClients;
}

