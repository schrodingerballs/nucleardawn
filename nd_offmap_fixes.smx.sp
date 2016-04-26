public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "03/11/2016",
	time = "14:53:54"
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
new bool:validMap;
new Handle:HAX;
new tmpAxisCount;
new tmpAxisViolated;
public Plugin:myinfo =
{
	name = "[ND] Off Map Buildings Fixes",
	description = "Prevents building things in glitched locations",
	author = "yed_, stickz",
	version = "fe639b0",
	url = "git@vanyli.net:nd-plugins"
};
public SharedPlugin:__pl_updater =
{
	name = "updater",
	file = "updater.smx",
	required = 0,
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
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_offmap_fixes/nd_offmap_fixes.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_offmap_fixes/nd_offmap_fixes.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	HAX = CreateArray(4, 0);
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	HookEvent("round_end", Event_RoundEnd, EventHookMode:2);
	AddUpdaterLibrary();
	return void:0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	decl String:map[64];
	GetCurrentMap(map, 64);
	ClearArray(HAX);
	if (StrEqual(map, "hydro", true))
	{
		HandleHydro();
	}
	else
	{
		if (StrEqual(map, "coast", true))
		{
			HandleCoast();
		}
		if (StrEqual(map, "gate", true))
		{
			HandleGate();
		}
	}
	validMap = GetArraySize(HAX) > 0;
	return 0;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	validMap = false;
	return 0;
}

public void:OnMapEnd()
{
	validMap = false;
	return void:0;
}

HandleGate()
{
	new Float:hax[4] = 0.0;
	hax[0] = 4000.0;
	PushArrayArray(HAX, hax, -1);
	return 0;
}

HandleHydro()
{
	new Float:hax[4] = {0.0,1.7710895E-38,0.0,4.404E-41};
	PushArrayArray(HAX, hax, -1);
	return 0;
}

HandleCoast()
{
	new Float:hax[4] = 0.0;
	hax[0] = 4466.0;
	hax[1] = 5246.0;
	hax[2] = 0.0;
	hax[3] = 52.0;
	PushArrayArray(HAX, hax, -1);
	hax[0] = 3518.0;
	hax[1] = 5217.0;
	hax[2] = 6597.0;
	hax[3] = 0.0;
	PushArrayArray(HAX, hax, -1);
	return 0;
}

public void:OnEntityCreated(entity, String:classname[])
{
	if (!validMap)
	{
		return void:0;
	}
	if (!(strncmp(classname, "struct_", 7, true)))
	{
		CreateTimer(0.1, CheckBorders, entity, 0);
	}
	return void:0;
}

public Action:CheckBorders(Handle:timer, any:entity)
{
	new Float:position[3] = 0.0;
	GetEntPropVector(entity, PropType:1, "m_vecOrigin", position, 0);
	new Float:hax[4] = 0.0;
	new i;
	while (GetArraySize(HAX) > i)
	{
		tmpAxisCount = 0;
		tmpAxisViolated = 0;
		GetArrayArray(HAX, i, hax, -1);
		if (0.0 != hax[0])
		{
			tmpAxisCount += 1;
			if (hax[0] < position[0])
			{
				tmpAxisViolated += 1;
			}
		}
		if (0.0 != hax[1])
		{
			tmpAxisCount += 1;
			if (hax[1] > position[0])
			{
				tmpAxisViolated += 1;
			}
		}
		if (0.0 != hax[2])
		{
			tmpAxisCount += 1;
			if (hax[2] < position[1])
			{
				tmpAxisViolated += 1;
			}
		}
		if (0.0 != hax[3])
		{
			tmpAxisCount += 1;
			if (hax[3] > position[1])
			{
				tmpAxisViolated += 1;
			}
		}
		new var1;
		if (tmpAxisViolated && tmpAxisViolated == tmpAxisCount)
		{
			SDKHooks_TakeDamage(entity, 0, 0, 10000.0, 0, -1, NULL_VECTOR, NULL_VECTOR);
		}
		i++;
	}
	return Action:0;
}

