public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "04/23/2016",
	time = "02:59:35"
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
public Plugin:myinfo =
{
	name = "SourceBans++: Admin Config Loader",
	description = "Reads admin files",
	author = "AlliedModders LLC, Sarabveer(VEER™)",
	version = "1.5.4.1",
	url = "https://github.com/Sarabveer/SourceBans-Fork"
};
new bool:g_LoggedFileName;
new g_ErrorCount;
new g_IgnoreLevel;
new g_CurrentLine;
new String:g_Filename[256];
new SMCParser:g_hGroupParser;
new GroupId:g_CurGrp = -1;
new g_GroupState;
new g_GroupPass;
new bool:g_NeedReparse;
new SMCParser:g_hUserParser;
new g_UserState;
new String:g_CurAuth[64];
new String:g_CurIdent[64];
new String:g_CurName[64];
new String:g_CurPass[64];
new Handle:g_GroupArray;
new g_CurFlags;
new g_CurImmunity;
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

FlagToBit(AdminFlag:flag)
{
	return 1 << flag;
}

public SMCResult:ReadGroups_NewSection(SMCParser:smc, String:name[], bool:opt_quotes)
{
	if (g_IgnoreLevel)
	{
		g_IgnoreLevel += 1;
		return SMCResult:0;
	}
	if (g_GroupState)
	{
		if (g_GroupState == 1)
		{
			if ((g_CurGrp = CreateAdmGroup(name)) == -1)
			{
				g_CurGrp = FindAdmGroup(name);
			}
			g_GroupState = 2;
		}
		if (g_GroupState == 2)
		{
			if (StrEqual(name, "Overrides", false))
			{
				g_GroupState = 3;
			}
			else
			{
				g_IgnoreLevel += 1;
			}
		}
		g_IgnoreLevel += 1;
	}
	else
	{
		if (StrEqual(name, "Groups", false))
		{
			g_GroupState = 1;
		}
		else
		{
			g_IgnoreLevel += 1;
		}
	}
	return SMCResult:0;
}

public SMCResult:ReadGroups_KeyValue(SMCParser:smc, String:key[], String:value[], bool:key_quotes, bool:value_quotes)
{
	new var1;
	if (g_CurGrp == GroupId:-1 || g_IgnoreLevel)
	{
		return SMCResult:0;
	}
	new AdminFlag:flag;
	if (g_GroupPass == 1)
	{
		if (g_GroupState == 2)
		{
			if (StrEqual(key, "flags", false))
			{
				new len = strlen(value);
				new i;
				while (i < len)
				{
					if (FindFlagByChar(value[i], flag))
					{
						SetAdmGroupAddFlag(g_CurGrp, flag, true);
					}
					i++;
				}
			}
			else
			{
				if (StrEqual(key, "immunity", false))
				{
					g_NeedReparse = true;
				}
			}
		}
		else
		{
			if (g_GroupState == 3)
			{
				new OverrideRule:rule;
				if (StrEqual(value, "allow", false))
				{
					rule = MissingTAG:1;
				}
				if (key[0] == '@')
				{
					AddAdmGroupCmdOverride(g_CurGrp, key[0], OverrideType:2, rule);
				}
				else
				{
					AddAdmGroupCmdOverride(g_CurGrp, key, OverrideType:1, rule);
				}
			}
		}
	}
	else
	{
		new var2;
		if (g_GroupPass == 2 && g_GroupState == 2)
		{
			if (StrEqual(key, "immunity", false))
			{
				if (StrEqual(value, "*", true))
				{
					SetAdmGroupImmunityLevel(g_CurGrp, 2);
				}
				if (StrEqual(value, "$", true))
				{
					SetAdmGroupImmunityLevel(g_CurGrp, 1);
				}
				new level;
				if (StringToIntEx(value, level, 10))
				{
					SetAdmGroupImmunityLevel(g_CurGrp, level);
				}
				else
				{
					new GroupId:id;
					if (value[0] == '@')
					{
						id = FindAdmGroup(value[0]);
					}
					else
					{
						id = FindAdmGroup(value);
					}
					if (id != GroupId:-1)
					{
						SetAdmGroupImmuneFrom(g_CurGrp, id);
					}
					else
					{
						ParseError("Unable to find group: \"%s\"", value);
					}
				}
			}
		}
	}
	return SMCResult:0;
}

public SMCResult:ReadGroups_EndSection(SMCParser:smc)
{
	if (g_IgnoreLevel)
	{
		g_IgnoreLevel -= 1;
		return SMCResult:0;
	}
	if (g_GroupState == 3)
	{
		g_GroupState = 2;
	}
	else
	{
		if (g_GroupState == 2)
		{
			g_GroupState = 1;
			g_CurGrp = MissingTAG:-1;
		}
		if (g_GroupState == 1)
		{
			g_GroupState = 0;
		}
	}
	return SMCResult:0;
}

public SMCResult:ReadGroups_CurrentLine(SMCParser:smc, String:line[], lineno)
{
	g_CurrentLine = lineno;
	return SMCResult:0;
}

InitializeGroupParser()
{
	if (!g_hGroupParser)
	{
		g_hGroupParser = SMCParser.SMCParser();
		SMCParser.OnEnterSection.set(g_hGroupParser, ReadGroups_NewSection);
		SMCParser.OnKeyValue.set(g_hGroupParser, ReadGroups_KeyValue);
		SMCParser.OnLeaveSection.set(g_hGroupParser, ReadGroups_EndSection);
		SMCParser.OnRawLine.set(g_hGroupParser, ReadGroups_CurrentLine);
	}
	return 0;
}

InternalReadGroups(String:path[], pass)
{
	InitGlobalStates();
	g_GroupState = 0;
	g_CurGrp = MissingTAG:-1;
	g_GroupPass = pass;
	g_NeedReparse = false;
	new SMCError:err = SMCParser.ParseFile(g_hGroupParser, path, 0, 0);
	if (err)
	{
		new String:buffer[64];
		if (SMCParser.GetErrorString(g_hGroupParser, err, buffer, 64))
		{
			ParseError("%s", buffer);
		}
		else
		{
			ParseError("Fatal parse error");
		}
	}
	return 0;
}

ReadGroups()
{
	InitializeGroupParser();
	BuildPath(PathType:0, g_Filename, 256, "configs/sourcebans/sb_admin_groups.cfg");
	InternalReadGroups(g_Filename, 1);
	if (g_NeedReparse)
	{
		InternalReadGroups(g_Filename, 2);
	}
	return 0;
}

public SMCResult:ReadUsers_NewSection(Handle:smc, String:name[], bool:opt_quotes)
{
	if (g_IgnoreLevel)
	{
		g_IgnoreLevel += 1;
		return SMCResult:0;
	}
	if (g_UserState)
	{
		if (g_UserState == 1)
		{
			g_UserState = 2;
			strcopy(g_CurName, 64, name);
			g_CurAuth[0] = 0;
			g_CurIdent[0] = 0;
			g_CurPass[0] = 0;
			ClearArray(g_GroupArray);
			g_CurFlags = 0;
			g_CurImmunity = 0;
		}
		g_IgnoreLevel += 1;
	}
	else
	{
		if (StrEqual(name, "Admins", false))
		{
			g_UserState = 1;
		}
		else
		{
			g_IgnoreLevel += 1;
		}
	}
	return SMCResult:0;
}

public SMCResult:ReadUsers_KeyValue(Handle:smc, String:key[], String:value[], bool:key_quotes, bool:value_quotes)
{
	new var1;
	if (g_UserState == 2 && g_IgnoreLevel)
	{
		return SMCResult:0;
	}
	if (StrEqual(key, "auth", false))
	{
		strcopy(g_CurAuth, 64, value);
	}
	else
	{
		if (StrEqual(key, "identity", false))
		{
			strcopy(g_CurIdent, 64, value);
		}
		if (StrEqual(key, "password", false))
		{
			strcopy(g_CurPass, 64, value);
		}
		if (StrEqual(key, "group", false))
		{
			new GroupId:id = FindAdmGroup(value);
			if (id == GroupId:-1)
			{
				ParseError("Unknown group \"%s\"", value);
			}
			PushArrayCell(g_GroupArray, id);
		}
		if (StrEqual(key, "flags", false))
		{
			new len = strlen(value);
			new AdminFlag:flag;
			new i;
			while (i < len)
			{
				if (!FindFlagByChar(value[i], flag))
				{
					ParseError("Invalid flag detected: %c", value[i]);
				}
				else
				{
					g_CurFlags = FlagToBit(flag) | g_CurFlags;
				}
				i++;
			}
		}
		if (StrEqual(key, "immunity", false))
		{
			g_CurImmunity = StringToInt(value, 10);
		}
	}
	return SMCResult:0;
}

public SMCResult:ReadUsers_EndSection(Handle:smc)
{
	if (g_IgnoreLevel)
	{
		g_IgnoreLevel -= 1;
		return SMCResult:0;
	}
	if (g_UserState == 2)
	{
		new var1;
		if (g_CurIdent[0] && g_CurAuth[0])
		{
			decl AdminFlag:flags[26];
			new AdminId:id;
			new i;
			new num_groups;
			new num_flags;
			if ((id = FindAdminByIdentity(g_CurAuth, g_CurIdent)) == -1)
			{
				id = CreateAdmin(g_CurName);
				if (!BindAdminIdentity(id, g_CurAuth, g_CurIdent))
				{
					RemoveAdmin(id);
					ParseError("Failed to bind auth \"%s\" to identity \"%s\"", g_CurAuth, g_CurIdent);
					return SMCResult:0;
				}
			}
			num_groups = GetArraySize(g_GroupArray);
			i = 0;
			while (i < num_groups)
			{
				AdminInheritGroup(id, GetArrayCell(g_GroupArray, i, 0, false));
				i++;
			}
			SetAdminPassword(id, g_CurPass);
			if (GetAdminImmunityLevel(id) < g_CurImmunity)
			{
				SetAdminImmunityLevel(id, g_CurImmunity);
			}
			num_flags = FlagBitsToArray(g_CurFlags, flags, 26);
			i = 0;
			while (i < num_flags)
			{
				SetAdminFlag(id, flags[i], true);
				i++;
			}
		}
		else
		{
			ParseError("Failed to create admin: did you forget either the auth or identity properties?");
		}
		g_UserState = 1;
	}
	else
	{
		if (g_UserState == 1)
		{
			g_UserState = 0;
		}
	}
	return SMCResult:0;
}

public SMCResult:ReadUsers_CurrentLine(Handle:smc, String:line[], lineno)
{
	g_CurrentLine = lineno;
	return SMCResult:0;
}

InitializeUserParser()
{
	if (!g_hUserParser)
	{
		g_hUserParser = SMCParser.SMCParser();
		SMCParser.OnEnterSection.set(g_hUserParser, ReadUsers_NewSection);
		SMCParser.OnKeyValue.set(g_hUserParser, ReadUsers_KeyValue);
		SMCParser.OnLeaveSection.set(g_hUserParser, ReadUsers_EndSection);
		SMCParser.OnRawLine.set(g_hUserParser, ReadUsers_CurrentLine);
		g_GroupArray = CreateArray(1, 0);
	}
	return 0;
}

ReadUsers()
{
	InitializeUserParser();
	BuildPath(PathType:0, g_Filename, 256, "configs/sourcebans/sb_admins.cfg");
	InitGlobalStates();
	g_UserState = 0;
	new SMCError:err = SMCParser.ParseFile(g_hUserParser, g_Filename, 0, 0);
	if (err)
	{
		new String:buffer[64];
		if (SMCParser.GetErrorString(g_hUserParser, err, buffer, 64))
		{
			ParseError("%s", buffer);
		}
		else
		{
			ParseError("Fatal parse error");
		}
	}
	return 0;
}

public OnRebuildAdminCache(AdminCachePart:part)
{
	if (part == AdminCachePart:1)
	{
		ReadGroups();
	}
	else
	{
		if (part == AdminCachePart:2)
		{
			ReadUsers();
		}
	}
	return 0;
}

ParseError(String:format[])
{
	decl String:buffer[512];
	if (!g_LoggedFileName)
	{
		LogError("Error(s) detected parsing %s", g_Filename);
		g_LoggedFileName = true;
	}
	VFormat(buffer, 512, format, 2);
	LogError(" (line %d) %s", g_CurrentLine, buffer);
	g_ErrorCount += 1;
	return 0;
}

InitGlobalStates()
{
	g_ErrorCount = 0;
	g_IgnoreLevel = 0;
	g_CurrentLine = 0;
	g_LoggedFileName = false;
	return 0;
}

