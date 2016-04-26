public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "03/17/2016",
	time = "18:31:00"
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
new Handle:cookie_lost_connection_message;
new bool:option_lost_connection_message[66] =
{
	1, ...
};
public Plugin:myinfo =
{
	name = "[ND] Disconnect Messages",
	description = "N/A",
	author = "stickz",
	version = "f126680",
	url = "N/A"
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

bool:IsValidClient(client, bool:nobots)
{
	new var2;
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
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
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_disconnect/nd_disconnect.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_disconnect/nd_disconnect.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	HookEvent("player_disconnect", Event_PlayerDisconnected, EventHookMode:0);
	LoadTranslations("nd_disconnect.phrases");
	AddClientPrefsSupport();
	AddUpdaterLibrary();
	return void:0;
}

public Event_PlayerDisconnected(Handle:event, String:name[], bool:dontBroadcast)
{
	decl String:steam_id[32];
	GetEventString(event, "networkid", steam_id, 32, "");
	if (!(strncmp(steam_id, "STEAM_", 6, true)))
	{
		new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
		decl String:reason[64];
		GetEventString(event, "reason", reason, 64, "");
		if (StrContains(reason, "timed out", false) != -1)
		{
			PrintLostConnection(client);
		}
	}
	return 0;
}

PrintLostConnection(client)
{
	decl String:clientName[64];
	GetClientName(client, clientName, 64);
	new idx = 1;
	while (idx <= MaxClients)
	{
		new var1;
		if (IsValidClient(idx, true) && option_lost_connection_message[idx])
		{
			PrintToChat(idx, "\x05%t", "Lost Connection", clientName);
		}
		idx++;
	}
	return 0;
}

public CookieMenuHandler_LostConnectionMessage(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	switch (action)
	{
		case 0:
		{
			decl String:status[12];
			new var2;
			if (option_lost_connection_message[client])
			{
				var2[0] = 3024;
			}
			else
			{
				var2[0] = 3028;
			}
			Format(status, 10, "%T", var2, client);
			Format(buffer, maxlen, "%T: %s", "Cookie Lost Connect", client, status);
		}
		case 1:
		{
			option_lost_connection_message[client] = !option_lost_connection_message[client];
			new var1;
			if (option_lost_connection_message[client])
			{
				var1[0] = 3060;
			}
			else
			{
				var1[0] = 3064;
			}
			SetClientCookie(client, cookie_lost_connection_message, var1);
			ShowCookieMenu(client);
		}
		default:
		{
		}
	}
	return 0;
}

public void:OnClientCookiesCached(client)
{
	option_lost_connection_message[client] = GetCookieLostConnectionMessage(client);
	return void:0;
}

bool:GetCookieLostConnectionMessage(client)
{
	decl String:buffer[12];
	GetClientCookie(client, cookie_lost_connection_message, buffer, 10);
	return !StrEqual(buffer, "Off", true);
}

AddClientPrefsSupport()
{
	LoadTranslations("common.phrases");
	cookie_lost_connection_message = RegClientCookie("Lost Connection Message On/Off", "", CookieAccess:1);
	new info;
	SetCookieMenuItem(CookieMenuHandler_LostConnectionMessage, info, "Lost Connection Message");
	return 0;
}

