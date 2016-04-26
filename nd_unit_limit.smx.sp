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
public Extension:__ext_sdktools =
{
	name = "SDKTools",
	file = "sdktools.ext",
	autoload = 1,
	required = 1,
};
public SharedPlugin:__pl_commander =
{
	name = "nd_commander",
	file = "nd_commander_restrictions.smx",
	required = 0,
};
public SharedPlugin:__pl_updater =
{
	name = "updater",
	file = "updater.smx",
	required = 0,
};
new Handle:eCommanders;
new UnitLimit[2][3];
new bool:SetLimit[2][3];
public Plugin:myinfo =
{
	name = "[ND] Unit Limiter",
	description = "Limit the number of units by class type on a team",
	author = "stickz, yed_",
	version = "e044582",
	url = "https://github.com/stickz/Redstone/"
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

bool:operator>(Float:,_:)(Float:oper1, oper2)
{
	return oper1 > float(oper2);
}

bool:operator>=(Float:,_:)(Float:oper1, oper2)
{
	return oper1 >= float(oper2);
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

bool:IsSniperClass(class, subClass)
{
	new var1;
	return (class && subClass == 2) || (class == 2 && subClass == 1);
}

bool:IsStealthClass(class)
{
	return class == 2;
}

String:NumberInEnglish(num, _arg1)
{
	decl String:englishNumber[16];
	switch (num)
	{
		case 1:
		{
			Format(englishNumber, 16, "one");
		}
		case 2:
		{
			Format(englishNumber, 16, "two");
		}
		case 3:
		{
			Format(englishNumber, 16, "three");
		}
		case 4:
		{
			Format(englishNumber, 16, "four");
		}
		case 5:
		{
			Format(englishNumber, 16, "five");
		}
		case 6:
		{
			Format(englishNumber, 16, "six");
		}
		case 7:
		{
			Format(englishNumber, 16, "seven");
		}
		case 8:
		{
			Format(englishNumber, 16, "eight");
		}
		case 9:
		{
			Format(englishNumber, 16, "nine");
		}
		case 10:
		{
			Format(englishNumber, 16, "ten");
		}
		default:
		{
		}
	}
	return englishNumber;
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

ValidTeamCount(teamName)
{
	new clientCount;
	new idx = 1;
	while (idx <= MaxClients)
	{
		new var1;
		if (IsValidClient(idx, true) && teamName == GetClientTeam(idx))
		{
			clientCount++;
		}
		idx++;
	}
	return clientCount;
}

bool:NDC_IsCommander(client)
{
	if (!GetFeatureStatus(FeatureType:0, "GetCommanderTeam") == 0)
	{
		return client == GameRules_GetPropEnt("m_hCommanders", GetClientTeam(client) + -2);
	}
	return GetCommanderTeam(client) != -1;
}

public __pl_commander_SetNTVOptional()
{
	MarkNativeAsOptional("GetCommanderTeam");
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
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_unit_limit/nd_unit_limit.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/nd_unit_limit/nd_unit_limit.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	eCommanders = CreateConVar("sm_allow_commander_setting", "1", "Sets wetheir to allow commanders to set their own limits.", 0, false, 0.0, false, 0.0);
	RegAdminCmd("sm_maxsnipers_admin", CMD_ChangeSnipersLimit, 2, "!maxsnipers_admin <team> <amount>", "", 0);
	RegConsoleCmd("sm_maxsnipers", CMD_ChangeTeamSnipersLimit, "Change the maximum number of snipers in the team: !maxsnipers <amount>", 0);
	RegConsoleCmd("sm_maxsniper", CMD_ChangeTeamSnipersLimit, "Change the maximum number of snipers in the team: !maxsnipers <amount>", 0);
	RegConsoleCmd("sm_maxstealths", CMD_ChangeTeamStealthLimit, "Change the maximum number of stealth in the team: !maxsteaths <amount>", 0);
	RegConsoleCmd("sm_maxstealth", CMD_ChangeTeamStealthLimit, "Change the maximum number of stealth in the team: !maxsteaths <amount>", 0);
	RegConsoleCmd("sm_MaxAntiStructures", CMD_ChangeTeamAntiStructureLimit, "Change the maximum percent of antistrcture in the team: !MaxAntiStructure <amount>", 0);
	RegConsoleCmd("sm_MaxAntiStructure", CMD_ChangeTeamAntiStructureLimit, "Change the maximum percent of antistrcture in the team: !MaxAntiStructure <amount>", 0);
	HookEvent("player_changeclass", Event_SelectClass, EventHookMode:0);
	AddUpdaterLibrary();
	LoadTranslations("nd_unit_limit.phrases");
	LoadTranslations("numbers.phrases");
	return void:0;
}

public void:OnMapStart()
{
	new x;
	while (x < 2)
	{
		new y;
		while (y < 2)
		{
			UnitLimit[x][y] = -1;
			SetLimit[x][y] = false;
			y++;
		}
		x++;
	}
	return void:0;
}

public Action:Event_SelectClass(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!ND_RoundStarted())
	{
		return Action:0;
	}
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new cls = GetEventInt(event, "class", 0);
	new subcls = GetEventInt(event, "subclass", 0);
	if (IsSniperClass(cls, subcls))
	{
		if (IsTooMuchSnipers(client))
		{
			ResetClass(client);
			PrintToChat(client, "\x05[xG] %t.", "Sniper Limit Reached");
			return Action:0;
		}
	}
	else
	{
		if (IsStealthClass(cls))
		{
			if (IsTooMuchStealth(client))
			{
				ResetClass(client);
				PrintToChat(client, "\x05[xG] %t.", "Stealth Limit Reached");
				return Action:0;
			}
		}
		if (IsAntiStructure(cls, subcls))
		{
			if (IsTooMuchAntiStructure(client))
			{
				ResetClass(client);
				PrintToChat(client, "\x05[xG] %t.", "AntiStructure Limit Reached");
				return Action:0;
			}
		}
	}
	return Action:0;
}

public Action:CMD_ChangeSnipersLimit(client, args)
{
	if (!IsValidClient(client, true))
	{
		return Action:3;
	}
	if (args != 2)
	{
		PrintToChat(client, "\x05[xG] %t", "Invalid Args");
		return Action:3;
	}
	decl String:strteam[32];
	GetCmdArg(1, strteam, 32);
	new team = StringToInt(strteam, 10) + 2;
	if (team < 2)
	{
		PrintToChat(client, "\x05[xG] %t", "Invalid Team");
		return Action:3;
	}
	decl String:strvalue[32];
	GetCmdArg(2, strvalue, 32);
	new value = StringToInt(strvalue, 10);
	SetUnitLimit(team, 0, value);
	return Action:3;
}

public Action:CMD_ChangeTeamSnipersLimit(client, args)
{
	if (CheckCommonFailure(client, 0, args))
	{
		return Action:3;
	}
	decl String:strvalue[32];
	GetCmdArg(1, strvalue, 32);
	new value = StringToInt(strvalue, 10);
	if (value > 10)
	{
		value = 10;
	}
	else
	{
		if (value < 1)
		{
			value = 1;
		}
	}
	SetUnitLimit(GetClientTeam(client), 0, value);
	return Action:3;
}

public Action:CMD_ChangeTeamStealthLimit(client, args)
{
	if (CheckCommonFailure(client, 1, args))
	{
		return Action:3;
	}
	decl String:strvalue[32];
	GetCmdArg(1, strvalue, 32);
	new value = StringToInt(strvalue, 10);
	if (value > 10)
	{
		value = 10;
	}
	else
	{
		if (value < 2)
		{
			value = 2;
		}
	}
	SetUnitLimit(GetClientTeam(client), 1, value);
	return Action:3;
}

public Action:CMD_ChangeTeamAntiStructureLimit(client, args)
{
	if (CheckCommonFailure(client, 2, args))
	{
		return Action:3;
	}
	decl String:strvalue[32];
	GetCmdArg(1, strvalue, 32);
	new value = StringToInt(strvalue, 10);
	if (value > 100)
	{
		value = 100;
	}
	else
	{
		if (value < 60)
		{
			value = 60;
		}
	}
	SetUnitLimit(GetClientTeam(client), 2, value);
	return Action:3;
}

bool:CheckCommonFailure(client, type, args)
{
	if (!GetConVarBool(eCommanders))
	{
		PrintToChat(client, "\x05[xG] %t", "Commander Disabled");
		return true;
	}
	if (!IsValidClient(client, true))
	{
		return true;
	}
	new client_team = GetClientTeam(client);
	if (client_team < 2)
	{
		PrintToChat(client, "\x05[xG] %t", "Invalid Team");
		return true;
	}
	if (!args)
	{
		switch (type)
		{
			case 0:
			{
				PrintToChat(client, "[xG] %t", "Proper Sniper Usage");
			}
			case 1:
			{
				PrintToChat(client, "[xG] %t", "Proper Stealth Usage");
			}
			case 2:
			{
				PrintToChat(client, "[xG] %t", "Proper Structure Usage");
			}
			default:
			{
			}
		}
		return true;
	}
	if (!NDC_IsCommander(client))
	{
		PrintToChat(client, "\x05[xG] %t", "Only Commanders");
		return true;
	}
	return false;
}

bool:IsTooMuchSnipers(client)
{
	new clientTeam = GetClientTeam(client);
	new clientCount = ValidTeamCount(client);
	new sniperCount = GetSniperCount(clientTeam);
	new teamIDX = clientTeam + -2;
	if (!SetLimit[teamIDX][0])
	{
		new var1;
		return (clientCount < 6 && sniperCount >= 2) || (clientCount < 13 && sniperCount >= 3) || sniperCount >= 4;
	}
	return sniperCount >= UnitLimit[teamIDX][0];
}

bool:IsTooMuchStealth(client)
{
	new clientTeam = GetClientTeam(client);
	new teamIDX = clientTeam + -2;
	if (!SetLimit[teamIDX][1])
	{
		return false;
	}
	new stealthCount = GetStealthCount(clientTeam);
	new unitLimit = UnitLimit[teamIDX][1];
	new stealthMin = GetMinStealthValue(clientTeam);
	decl stealthLimit;
	new var1;
	if (stealthMin > unitLimit)
	{
		var1 = stealthMin;
	}
	else
	{
		var1 = unitLimit;
	}
	stealthLimit = var1;
	return stealthCount >= stealthLimit;
}

bool:IsTooMuchAntiStructure(client)
{
	new clientTeam = GetClientTeam(client);
	new teamIDX = clientTeam + -2;
	if (!SetLimit[teamIDX][2])
	{
		return false;
	}
	new Float:AntiStructureFloat = float(GetAntiStructureCount(clientTeam));
	new Float:teamFloat = float(ValidTeamCount(clientTeam));
	new Float:AntiStructurePercent = AntiStructureFloat / teamFloat * 100.0;
	new percentLimit = UnitLimit[clientTeam + -2][2];
	new var1;
	return AntiStructurePercent >= percentLimit && AntiStructureFloat > 5.6E-45;
}

bool:IsAntiStructure(class, subClass)
{
	new var1;
	return (class == 1 && subClass == 1) || (class == 3 && subClass == 2);
}

GetMinStealthValue(team)
{
	new var1;
	if (ValidTeamCount(team) < 7)
	{
		var1 = 2;
	}
	else
	{
		var1 = 2;
	}
	return var1;
}

ResetClass(client)
{
	SetEntProp(client, PropType:0, "m_iPlayerClass", any:0, 4, 0);
	SetEntProp(client, PropType:0, "m_iPlayerSubclass", any:0, 4, 0);
	SetEntProp(client, PropType:0, "m_iDesiredPlayerClass", any:0, 4, 0);
	SetEntProp(client, PropType:0, "m_iDesiredPlayerSubclass", any:0, 4, 0);
	SetEntProp(client, PropType:0, "m_iDesiredGizmo", any:0, 4, 0);
	return 0;
}

SetUnitLimit(team, type, value)
{
	new teamIDX = team + -2;
	UnitLimit[teamIDX][type] = value;
	SetLimit[teamIDX][type] = true;
	PrintLimitSet(team, type, value);
	return 0;
}

String:GetLimitPhrase(type, _arg1)
{
	new String:LimitPhrase[32] = "Set Sniper Limit";
	switch (type)
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
		default:
		{
		}
	}
	return LimitPhrase;
}

PrintLimitSet(team, type, limit)
{
	if (type == 2)
	{
		new client = 1;
		while (client <= MaxClients)
		{
			new var1;
			if (IsValidClient(client, true) && team == GetClientTeam(client))
			{
				PrintToChat(client, "\x05[xG] %t.", "Set Structure Limit", limit);
			}
			client++;
		}
	}
	else
	{
		decl String:Phrase[32];
		Format(Phrase, 32, GetLimitPhrase(type));
		new client = 1;
		while (client <= MaxClients)
		{
			new var2;
			if (IsValidClient(client, true) && team == GetClientTeam(client))
			{
				decl String:TranslatedLimit[32];
				Format(TranslatedLimit, 32, "%T", NumberInEnglish(limit), client);
				decl String:Message[64];
				Format(Message, 64, "\x05[xG] %T.", Phrase, client, TranslatedLimit);
				PrintToChat(client, Message);
			}
			client++;
		}
	}
	return 0;
}

