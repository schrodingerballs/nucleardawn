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
public Extension:__ext_geoip =
{
	name = "GeoIP",
	file = "geoip.ext",
	autoload = 1,
	required = 1,
};
new String:aAfrica[57][4];
new String:aEurope[54][4];
new String:aAsia[54][4];
new String:aNorthAmerica[39][4];
new String:aAustralia[26][4];
new String:aSouthAmerica[14][4];
new String:aAntarctica[5][4];
public Plugin:myinfo =
{
	name = "[ND] Continents",
	description = "Show a player's continent based on their IP.",
	author = "Stickz",
	version = "f96fca4",
	url = "https://github.com/stickz/Redstone/"
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

StrCat(String:buffer[], maxlength, String:source[])
{
	new len = strlen(buffer);
	if (len >= maxlength)
	{
		return 0;
	}
	return Format(buffer[len], maxlength - len, "%s", source);
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
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_continents/nd_continents.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_continents/nd_continents.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	RegConsoleCmd("sm_locations", CMD_CheckLocations, "", 0);
	LoadTranslations("nd_continents.phrases");
	AddUpdaterLibrary();
	return void:0;
}

public Action:CMD_CheckLocations(client, args)
{
	new counter[8];
	decl String:playerContinent[66][4];
	new idx;
	while (idx <= MaxClients)
	{
		if (IsValidClient(idx, true))
		{
			getContient(idx);
			counter[contientTOInteger(playerContinent[idx])]++;
		}
		idx++;
	}
	decl String:printOut[128];
	new i;
	while (i < 8)
	{
		if (!isContinentEmpty(counter[i]))
		{
			decl String:contient[16];
			Format(contient, 16, " %s: %d", conientIntegerTOName(i), counter[i]);
			StrCat(printOut, 128, contient);
		}
		i++;
	}
	PrintToChat(client, "\x05[xG] %t", "Player Locations", printOut);
	return Action:0;
}

public bool:isContinentEmpty(contientNumber)
{
	return contientNumber == 0;
}

String:conientIntegerTOName(value, _arg1)
{
	new String:Name[4] = "XX";
	switch (value)
	{
		case 0:
		{
		}
		case 1:
		{
		}
		case 2:
		{
		}
		case 3:
		{
		}
		case 4:
		{
		}
		case 5:
		{
		}
		case 6:
		{
		}
		default:
		{
		}
	}
	return Name;
}

contientTOInteger(String:contString[4])
{
	if (StrEqual(contString, "EU", true))
	{
		return 1;
	}
	if (StrEqual(contString, "NA", true))
	{
		return 2;
	}
	if (StrEqual(contString, "AU", true))
	{
		return 3;
	}
	if (StrEqual(contString, "AS", true))
	{
		return 4;
	}
	if (StrEqual(contString, "SA", true))
	{
		return 5;
	}
	if (StrEqual(contString, "AF", true))
	{
		return 6;
	}
	if (StrEqual(contString, "AN", true))
	{
		return 7;
	}
	return 0;
}

String:getContient(client, _arg1)
{
	new String:code[4] = "XX";
	decl String:clientIp[16];
	if (!GetClientIP(client, clientIp, 16, true))
	{
		return code;
	}
	decl String:countryCode[4];
	if (!GeoipCode2(clientIp, countryCode))
	{
		return code;
	}
	new i;
	while (i < 53)
	{
		if (StrEqual(aEurope[i], countryCode, true))
		{
			return code;
		}
		i++;
	}
	new i;
	while (i < 38)
	{
		if (StrEqual(aNorthAmerica[i], countryCode, true))
		{
			return code;
		}
		i++;
	}
	new i;
	while (i < 25)
	{
		if (StrEqual(aAustralia[i], countryCode, true))
		{
			return code;
		}
		i++;
	}
	new i;
	while (i < 53)
	{
		if (StrEqual(aAsia[i], countryCode, true))
		{
			return code;
		}
		i++;
	}
	new i;
	while (i < 13)
	{
		if (StrEqual(aSouthAmerica[i], countryCode, true))
		{
			return code;
		}
		i++;
	}
	new i;
	while (i < 56)
	{
		if (StrEqual(aAfrica[i], countryCode, true))
		{
			return code;
		}
		i++;
	}
	new i;
	while (i < 4)
	{
		if (StrEqual(aAntarctica[i], countryCode, true))
		{
			return code;
		}
		i++;
	}
	return code;
}

