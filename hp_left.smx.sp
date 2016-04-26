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
new String:deathInfo[66][2][32];
new hpleft[66];
new distances[66];
new bool:headshots[66];
new Handle:weaponNames;
new Handle:cookie_hpleft;
new bool:option_hpleft[66] =
{
	1, ...
};
public Plugin:myinfo =
{
	name = "HP Left",
	description = "Shows how many hp an attacker has left",
	author = "InterWave Studios team",
	version = "1.2.1",
	url = "http://www.interwavestudios.com/"
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

public void:OnPluginStart()
{
	HookEvent("player_death", playerDeath, EventHookMode:1);
	CreateConVar("sm_hpl_version", "1.2.1", "HP left version", 270656, false, 0.0, false, 0.0);
	RegConsoleCmd("say", printInfoChat, "", 0);
	RegConsoleCmd("say_team", printInfoChat, "", 0);
	LoadTranslations("hp_left.phrases");
	LoadTranslations("common.phrases");
	weaponNames = CreateKeyValues("Weapons", "", "");
	cookie_hpleft = RegClientCookie("HP Left On/Off", "", CookieAccess:1);
	new info;
	SetCookieMenuItem(CookieMenuHandler_hpleft, info, "HP Left");
	return void:0;
}

public Action:printInfoChat(client, args)
{
	if (client)
	{
		new String:user_command[192];
		GetCmdArgString(user_command, 192);
		new start_index;
		new command_length = strlen(user_command);
		if (0 < command_length)
		{
			if (user_command[0] == '"')
			{
				start_index = 1;
				if (user_command[command_length + -1] == '"')
				{
					user_command[command_length + -1] = MissingTAG:0;
				}
			}
			if (user_command[start_index] == '/')
			{
				start_index++;
			}
		}
		new var1;
		if (strcmp(user_command[start_index], "hp", false) && strcmp(user_command[start_index], "/hp", false))
		{
			if (distances[client])
			{
				printInfo(client);
			}
			PrintToChat(client, "%t", "Notdied");
		}
		return Action:0;
	}
	return Action:0;
}

public printInfo(client)
{
	if (!option_hpleft[client])
	{
		if (headshots[client])
		{
			PrintToChat(client, "%t", "Killedhs", 3, deathInfo[client][0], 1, deathInfo[client][1], hpleft[client]);
		}
		PrintToChat(client, "%t", "Killed", 3, deathInfo[client][0], 1, deathInfo[client][1], hpleft[client]);
	}
	return 0;
}

public Action:playerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (victim != attacker && attacker)
	{
		return Action:0;
	}
	new String:attackerName[32];
	GetClientName(attacker, attackerName, 32);
	new String:weapon[32];
	GetEventString(event, "weapon", weapon, 32, "");
	if (strlen(weapon))
	{
		KvGetString(weaponNames, weapon, weapon, 32, weapon);
		ReplaceString(weapon, 32, "WEAPON_", "", true);
		strcopy(deathInfo[victim][0], 32, attackerName);
		strcopy(deathInfo[victim][1], 32, weapon);
		if (attacker)
		{
			if (IsClientConnected(attacker))
			{
				hpleft[victim] = GetClientHealth(attacker);
			}
		}
		printInfo(victim);
		return Action:0;
	}
	return Action:0;
}

public void:OnMapStart()
{
	decl String:sPath[256];
	BuildPath(PathType:0, sPath, 256, "configs/hp_left_weapons.txt");
	FileToKeyValues(weaponNames, sPath);
	return void:0;
}

public CookieMenuHandler_hpleft(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	if (action)
	{
		option_hpleft[client] = !option_hpleft[client];
		if (!option_hpleft[client])
		{
			SetClientCookie(client, cookie_hpleft, "Off");
			PrintToChat(client, "\x04HP Left Enabled!");
		}
		else
		{
			SetClientCookie(client, cookie_hpleft, "On");
			PrintToChat(client, "\x04HP Left Disabled!");
		}
		ShowCookieMenu(client);
	}
	else
	{
		decl String:status[12];
		if (!option_hpleft[client])
		{
			Format(status, 10, "%T", "On", client);
		}
		else
		{
			Format(status, 10, "%T", "Off", client);
		}
		Format(buffer, maxlen, "%T: %s", "Cookie HP Left", client, status);
	}
	return 0;
}

public OnClientCookiesCached(client)
{
	option_hpleft[client] = GetCookiehpleft(client);
	return 0;
}

bool:GetCookiehpleft(client)
{
	decl String:buffer[12];
	GetClientCookie(client, cookie_hpleft, buffer, 10);
	return !StrEqual(buffer, "Off", true);
}

