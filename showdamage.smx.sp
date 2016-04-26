public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "04/24/2016",
	time = "01:31:45"
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
	name = "Show Damage",
	description = "Shows damage in the center of the screen.",
	author = "exvel, stickz",
	version = "537525d",
	url = "www.sourcemod.net"
};
new player_damage[66];
new bool:block_timer[66];
new String:DamageEventName[16];
new MaxDamage = 10000000;
new bool:option_show_damage[66] =
{
	1, ...
};
new Handle:cookie_show_damage;
new ConVar:gcvar_enabled;
new ConVar:gcvar_ff;
new ConVar:gcvar_own_dmg;
new ConVar:gcvar_text_area;
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
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/showdamage/showdamage.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/showdamage/showdamage.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	CreateConvars();
	AddUpdaterLibrary();
	AddClientPrefs();
	LoadTranslations("showdamage.phrases");
	AutoExecConfig(true, "showdamage", "sourcemod");
	SetupEvents();
	return void:0;
}

public CookieMenuHandler_ShowDamage(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	if (action)
	{
		option_show_damage[client] = !option_show_damage[client];
		new var2;
		if (option_show_damage[client])
		{
			var2[0] = 3584;
		}
		else
		{
			var2[0] = 3588;
		}
		SetClientCookie(client, cookie_show_damage, var2);
		ShowCookieMenu(client);
	}
	else
	{
		decl String:status[12];
		new var1;
		if (option_show_damage[client])
		{
			var1[0] = 3548;
		}
		else
		{
			var1[0] = 3552;
		}
		Format(status, 10, "%T", var1, client);
		Format(buffer, maxlen, "%T: %s", "Cookie Show Damage", client, status);
	}
	return 0;
}

public void:OnClientCookiesCached(client)
{
	option_show_damage[client] = GetCookieShowDamage(client);
	return void:0;
}

bool:GetCookieShowDamage(client)
{
	decl String:buffer[12];
	GetClientCookie(client, cookie_show_damage, buffer, 10);
	return !StrEqual(buffer, "Off", true);
}

public void:OnClientConnected(client)
{
	block_timer[client] = 0;
	return void:0;
}

public Action:Event_PlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	block_timer[client] = 0;
	return Action:0;
}

public Action:ShowDamage(Handle:timer, any:client)
{
	block_timer[client] = 0;
	new var1;
	if (player_damage[client] <= 0 || !client || !IsClientInGame(client))
	{
		return Action:0;
	}
	switch (ConVar.IntValue.get(gcvar_text_area))
	{
		case 1:
		{
			PrintCenterText(client, "%t", "CenterText Damage Text", player_damage[client]);
		}
		case 2:
		{
			PrintHintText(client, "%t", "HintText Damage Text", player_damage[client]);
		}
		case 3:
		{
			PrintToChat(client, "%t", "Chat Damage Text", player_damage[client]);
		}
		default:
		{
		}
	}
	player_damage[client] = 0;
	return Action:0;
}

public Action:Event_PlayerHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new client_attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new damage = GetEventInt(event, DamageEventName, 0);
	CalcDamage(client, client_attacker, damage);
	return Action:0;
}

public Action:Event_InfectedHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new client_attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new damage = GetEventInt(event, "amount", 0);
	CalcDamage(0, client_attacker, damage);
	return Action:0;
}

CalcDamage(client, client_attacker, damage)
{
	new var1;
	if (!ConVar.BoolValue.get(gcvar_enabled) || !option_show_damage[client_attacker] || client_attacker || IsFakeClient(client_attacker) || !IsClientInGame(client_attacker) || damage > MaxDamage)
	{
		return 0;
	}
	if (client)
	{
		new var2;
		if (client_attacker == client && !ConVar.BoolValue.get(gcvar_own_dmg))
		{
			return 0;
		}
		new var3;
		if (GetClientTeam(client_attacker) == GetClientTeam(client) && !ConVar.BoolValue.get(gcvar_ff))
		{
			return 0;
		}
	}
	new var4 = player_damage[client_attacker];
	var4 = var4[damage];
	if (block_timer[client_attacker])
	{
		return 0;
	}
	CreateTimer(0.01, ShowDamage, client_attacker, 0);
	block_timer[client_attacker] = 1;
	return 0;
}

AddClientPrefs()
{
	LoadTranslations("common.phrases");
	cookie_show_damage = RegClientCookie("Show Damage On/Off", "", CookieAccess:1);
	new info;
	SetCookieMenuItem(CookieMenuHandler_ShowDamage, info, "Show Damage");
	return 0;
}

CreateConvars()
{
	gcvar_enabled = CreateConVar("sm_show_damage", "1", "Enabled/Disabled show damage functionality, 0 = off/1 = on", 0, true, 0.0, true, 1.0);
	gcvar_ff = CreateConVar("sm_show_damage_ff", "0", "Show friendly fire damage, 0 = off/1 = on", 0, true, 0.0, true, 1.0);
	gcvar_own_dmg = CreateConVar("sm_show_damage_own_dmg", "0", "Show your own damage, 0 = off/1 = on", 0, true, 0.0, true, 1.0);
	gcvar_text_area = CreateConVar("sm_show_damage_text_area", "1", "Defines the area for damage text:\n 1 = in the center of the screen\n 2 = in the hint text area \n 3 = in chat area of screen", 0, true, 1.0, true, 3.0);
	return 0;
}

SetupEvents()
{
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode:1);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode:1);
	decl String:gameName[80];
	GetGameFolderName(gameName, 80);
	new var1;
	if (StrEqual(gameName, "left4dead", true) || StrEqual(gameName, "left4dead2", true))
	{
		HookEvent("infected_hurt", Event_InfectedHurt, EventHookMode:1);
		MaxDamage = 2000;
	}
	new var2;
	if (StrEqual(gameName, "dod", true) || StrEqual(gameName, "hidden", true))
	{
		var3 = 4228;
	}
	else
	{
		var3 = 4236;
	}
	return 0;
}

