public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "04:34:19"
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
	name = "Admin Help",
	description = "Display command information",
	author = "AlliedModders LLC",
	version = "1.7.0",
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

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("adminhelp.phrases");
	RegConsoleCmd("sm_help", HelpCmd, "Displays SourceMod commands and descriptions", 0);
	RegConsoleCmd("sm_searchcmd", HelpCmd, "Searches SourceMod commands", 0);
	return void:0;
}

public Action:HelpCmd(client, args)
{
	decl String:arg[64];
	decl String:CmdName[20];
	new PageNum = 1;
	new bool:DoSearch;
	GetCmdArg(0, CmdName, 20);
	if (GetCmdArgs() >= 1)
	{
		GetCmdArg(1, arg, 64);
		StringToIntEx(arg, PageNum, 10);
		new var1;
		if (PageNum <= 0)
		{
			var1 = 1;
		}
		else
		{
			var1 = PageNum;
		}
		PageNum = var1;
	}
	new var2;
	if (strcmp("sm_help", CmdName, true))
	{
		var2 = 1;
	}
	else
	{
		var2 = 0;
	}
	DoSearch = var2;
	if (GetCmdReplySource() == 1)
	{
		ReplyToCommand(client, "[SM] %t", "See console for output");
	}
	decl String:Name[64];
	decl String:Desc[256];
	decl String:NoDesc[128];
	new Flags;
	new Handle:CmdIter = GetCommandIterator();
	FormatEx(NoDesc, 128, "%T", "No description available", client);
	if (DoSearch)
	{
		new i = 1;
		while (ReadCommandIterator(CmdIter, Name, 64, Flags, Desc, 255))
		{
			new var3;
			if (StrContains(Name, arg, false) != -1 && CheckCommandAccess(client, Name, Flags, false))
			{
				new var4;
				if (Desc[0])
				{
					var4[0] = Desc;
				}
				else
				{
					var4[0] = NoDesc;
				}
				i++;
				PrintToConsole(client, "[%03d] %s - %s", i, Name, var4);
			}
		}
		if (i == 1)
		{
			PrintToConsole(client, "%t", "No matching results found");
		}
	}
	else
	{
		PrintToConsole(client, "%t", "SM help commands");
		if (PageNum > 1)
		{
			new i;
			new EndCmd = PageNum + -1 * 10 + -1;
			i = 0;
			while (ReadCommandIterator(CmdIter, Name, 64, Flags, Desc, 255) && i < EndCmd)
			{
				if (CheckCommandAccess(client, Name, Flags, false))
				{
					i++;
				}
			}
			if (!i)
			{
				PrintToConsole(client, "%t", "No commands available");
				CloseHandle(CmdIter);
				CmdIter = MissingTAG:0;
				return Action:3;
			}
		}
		new i;
		new StartCmd = PageNum + -1 * 10;
		i = 0;
		while (ReadCommandIterator(CmdIter, Name, 64, Flags, Desc, 255) && i < 10)
		{
			if (CheckCommandAccess(client, Name, Flags, false))
			{
				i++;
				new var7;
				if (Desc[0])
				{
					var7[0] = Desc;
				}
				else
				{
					var7[0] = NoDesc;
				}
				PrintToConsole(client, "[%03d] %s - %s", StartCmd + i, Name, var7);
			}
		}
		if (i)
		{
			PrintToConsole(client, "%t", "Entries n - m in page k", StartCmd + 1, StartCmd + i, PageNum);
		}
		else
		{
			PrintToConsole(client, "%t", "No commands available");
		}
		new var8;
		if (ReadCommandIterator(CmdIter, Name, 64, Flags, Desc, 255) && CheckCommandAccess(client, Name, Flags, false))
		{
			PrintToConsole(client, "%t", "Type sm_help to see more", PageNum + 1);
		}
	}
	CloseHandle(CmdIter);
	CmdIter = MissingTAG:0;
	return Action:3;
}

