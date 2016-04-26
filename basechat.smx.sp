public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "04:34:20"
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
	name = "Basic Chat",
	description = "Basic Communication Commands",
	author = "AlliedModders LLC",
	version = "1.7.0",
	url = "http://www.sourcemod.net/"
};
new String:g_ColorNames[13][12];
new g_Colors[13][3] =
{
	{
		255, ...
	},
	{
		255, 0, 0
	},
	{
		0, 255, 0
	},
	{
		0, 0, 255
	},
	{
		255, 255, 0
	},
	{
		255, 0, 255
	},
	{
		0, 255, 255
	},
	{
		255, 128, 0
	},
	{
		255, 0, 128
	},
	{
		128, 255, 0
	},
	{
		0, 255, 128
	},
	{
		128, 0, 255
	},
	{
		0, 128, 255
	}
};
new ConVar:g_Cvar_Chatmode;
new EngineVersion:g_GameEngine;
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

ReplyToTargetError(client, reason)
{
	switch (reason)
	{
		case -7:
		{
			ReplyToCommand(client, "[SM] %t", "More than one client matched");
		}
		case -6:
		{
			ReplyToCommand(client, "[SM] %t", "Cannot target bot");
		}
		case -5:
		{
			ReplyToCommand(client, "[SM] %t", "No matching clients");
		}
		case -4:
		{
			ReplyToCommand(client, "[SM] %t", "Unable to target");
		}
		case -3:
		{
			ReplyToCommand(client, "[SM] %t", "Target is not in game");
		}
		case -2:
		{
			ReplyToCommand(client, "[SM] %t", "Target must be dead");
		}
		case -1:
		{
			ReplyToCommand(client, "[SM] %t", "Target must be alive");
		}
		case 0:
		{
			ReplyToCommand(client, "[SM] %t", "No matching client");
		}
		default:
		{
		}
	}
	return 0;
}

FindTarget(client, String:target[], bool:nobots, bool:immunity)
{
	decl String:target_name[64];
	decl target_list[1];
	decl target_count;
	decl bool:tn_is_ml;
	new flags = 16;
	if (nobots)
	{
		flags |= 32;
	}
	if (!immunity)
	{
		flags |= 8;
	}
	if (0 < (target_count = ProcessTargetString(target, client, target_list, 1, flags, target_name, 64, tn_is_ml)))
	{
		return target_list[0];
	}
	ReplyToTargetError(client, target_count);
	return -1;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	g_GameEngine = GetEngineVersion();
	g_Cvar_Chatmode = CreateConVar("sm_chat_mode", "1", "Allows player's to send messages to admin chat.", 0, true, 0.0, true, 1.0);
	RegAdminCmd("sm_say", Command_SmSay, 512, "sm_say <message> - sends message to all players", "", 0);
	RegAdminCmd("sm_csay", Command_SmCsay, 512, "sm_csay <message> - sends centered message to all players", "", 0);
	if (g_GameEngine != EngineVersion:5)
	{
		RegAdminCmd("sm_hsay", Command_SmHsay, 512, "sm_hsay <message> - sends hint message to all players", "", 0);
	}
	RegAdminCmd("sm_tsay", Command_SmTsay, 512, "sm_tsay [color] <message> - sends top-left message to all players", "", 0);
	RegAdminCmd("sm_chat", Command_SmChat, 512, "sm_chat <message> - sends message to admins", "", 0);
	RegAdminCmd("sm_psay", Command_SmPsay, 512, "sm_psay <name or #userid> <message> - sends private message", "", 0);
	RegAdminCmd("sm_msay", Command_SmMsay, 512, "sm_msay <message> - sends message as a menu panel", "", 0);
	return void:0;
}

public Action:OnClientSayCommand(client, String:command[], String:sArgs[])
{
	new startidx;
	if (sArgs[startidx] != '@')
	{
		return Action:0;
	}
	startidx++;
	if (strcmp(command, "say", false))
	{
		new var2;
		if (strcmp(command, "say_team", false) && strcmp(command, "say_squad", false))
		{
			new var3;
			if (!CheckCommandAccess(client, "sm_chat", 512, false) && !ConVar.BoolValue.get(g_Cvar_Chatmode))
			{
				return Action:0;
			}
			SendChatToAdmins(client, sArgs[startidx]);
			LogAction(client, -1, "\"%L\" triggered sm_chat (text %s)", client, sArgs[startidx]);
			return Action:4;
		}
		return Action:0;
	}
	if (sArgs[startidx] != '@')
	{
		if (!CheckCommandAccess(client, "sm_say", 512, false))
		{
			return Action:0;
		}
		SendChatToAll(client, sArgs[startidx]);
		LogAction(client, -1, "\"%L\" triggered sm_say (text %s)", client, sArgs[startidx]);
		return Action:4;
	}
	startidx++;
	if (sArgs[startidx] != '@')
	{
		if (!CheckCommandAccess(client, "sm_psay", 512, false))
		{
			return Action:0;
		}
		decl String:arg[64];
		new len = BreakString(sArgs[startidx], arg, 64);
		new target = FindTarget(client, arg, true, false);
		new var1;
		if (target == -1 || len == -1)
		{
			return Action:4;
		}
		SendPrivateChat(client, target, sArgs[len + startidx]);
		return Action:4;
	}
	startidx++;
	if (!CheckCommandAccess(client, "sm_csay", 512, false))
	{
		return Action:0;
	}
	DisplayCenterTextToAll(client, sArgs[startidx]);
	LogAction(client, -1, "\"%L\" triggered sm_csay (text %s)", client, sArgs[startidx]);
	return Action:4;
}

public Action:Command_SmSay(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_say <message>");
		return Action:3;
	}
	decl String:text[192];
	GetCmdArgString(text, 192);
	SendChatToAll(client, text);
	LogAction(client, -1, "\"%L\" triggered sm_say (text %s)", client, text);
	return Action:3;
}

public Action:Command_SmCsay(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_csay <message>");
		return Action:3;
	}
	decl String:text[192];
	GetCmdArgString(text, 192);
	DisplayCenterTextToAll(client, text);
	LogAction(client, -1, "\"%L\" triggered sm_csay (text %s)", client, text);
	return Action:3;
}

public Action:Command_SmHsay(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_hsay <message>");
		return Action:3;
	}
	decl String:text[192];
	GetCmdArgString(text, 192);
	decl String:nameBuf[32];
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
		}
		else
		{
			FormatActivitySource(client, i, nameBuf, 32);
			PrintHintText(i, "%s: %s", nameBuf, text);
		}
		i++;
	}
	LogAction(client, -1, "\"%L\" triggered sm_hsay (text %s)", client, text);
	return Action:3;
}

public Action:Command_SmTsay(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_tsay <message>");
		return Action:3;
	}
	decl String:text[192];
	decl String:colorStr[16];
	GetCmdArgString(text, 192);
	new len = BreakString(text, colorStr, 16);
	new color = FindColor(colorStr);
	new String:nameBuf[32];
	if (color == -1)
	{
		color = 0;
		len = 0;
	}
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
		}
		else
		{
			FormatActivitySource(client, i, nameBuf, 32);
			SendDialogToOne(i, color, "%s: %s", nameBuf, text[len]);
		}
		i++;
	}
	LogAction(client, -1, "\"%L\" triggered sm_tsay (text %s)", client, text);
	return Action:3;
}

public Action:Command_SmChat(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_chat <message>");
		return Action:3;
	}
	decl String:text[192];
	GetCmdArgString(text, 192);
	SendChatToAdmins(client, text);
	LogAction(client, -1, "\"%L\" triggered sm_chat (text %s)", client, text);
	return Action:3;
}

public Action:Command_SmPsay(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_psay <name or #userid> <message>");
		return Action:3;
	}
	decl String:text[192];
	decl String:arg[64];
	decl String:message[192];
	GetCmdArgString(text, 192);
	new len = BreakString(text, arg, 64);
	BreakString(text[len], message, 192);
	new target = FindTarget(client, arg, true, false);
	if (target == -1)
	{
		return Action:3;
	}
	SendPrivateChat(client, target, message);
	return Action:3;
}

public Action:Command_SmMsay(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_msay <message>");
		return Action:3;
	}
	decl String:text[192];
	GetCmdArgString(text, 192);
	SendPanelToAll(client, text);
	LogAction(client, -1, "\"%L\" triggered sm_msay (text %s)", client, text);
	return Action:3;
}

FindColor(String:color[])
{
	new i;
	while (i < 13)
	{
		if (!(strcmp(color, g_ColorNames[i], false)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

SendChatToAll(client, String:message[])
{
	new String:nameBuf[32];
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
		}
		else
		{
			FormatActivitySource(client, i, nameBuf, 32);
			PrintToChat(i, "\x04(ALL) %s: \x01%s", nameBuf, message);
		}
		i++;
	}
	return 0;
}

DisplayCenterTextToAll(client, String:message[])
{
	new String:nameBuf[32];
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
		}
		else
		{
			FormatActivitySource(client, i, nameBuf, 32);
			PrintCenterText(i, "%s: %s", nameBuf, message);
		}
		i++;
	}
	return 0;
}

SendChatToAdmins(from, String:message[])
{
	new fromAdmin = CheckCommandAccess(from, "sm_chat", 512, false);
	new i = 1;
	while (i <= MaxClients)
	{
		new var2;
		if (IsClientInGame(i) && (i != from && CheckCommandAccess(i, "sm_chat", 512, false)))
		{
			new var3;
			if (fromAdmin)
			{
				var3[0] = 4228;
			}
			else
			{
				var3[0] = 4232;
			}
			PrintToChat(i, "\x04(%sADMINS) %N: \x01%s", var3, from, message);
		}
		i++;
	}
	return 0;
}

SendDialogToOne(client, color, String:text[])
{
	new String:message[100];
	VFormat(message, 100, text, 4);
	new KeyValues:kv = KeyValues.KeyValues("Stuff", "title", message);
	KeyValues.SetColor(kv, "color", g_Colors[color][0], g_Colors[color][1], g_Colors[color][2], 255);
	KeyValues.SetNum(kv, "level", 1);
	KeyValues.SetNum(kv, "time", 10);
	CreateDialog(client, kv, DialogType:0);
	CloseHandle(kv);
	kv = MissingTAG:0;
	return 0;
}

SendPrivateChat(client, target, String:message[])
{
	if (!client)
	{
		PrintToServer("(Private to %N) %N: %s", target, client, message);
	}
	else
	{
		if (client != target)
		{
			PrintToChat(client, "\x04(Private to %N) %N: \x01%s", target, client, message);
		}
	}
	PrintToChat(target, "\x04(Private to %N) %N: \x01%s", target, client, message);
	LogAction(client, -1, "\"%L\" triggered sm_psay to \"%L\" (text %s)", client, target, message);
	return 0;
}

void:SendPanelToAll(from, String:message[])
{
	new String:title[100];
	Format(title, 64, "%N:", from);
	ReplaceString(message, 192, "\n", "\n", true);
	new Panel:mSayPanel = CreatePanel(Handle:0);
	Panel.SetTitle(mSayPanel, title, false);
	DrawPanelItem(mSayPanel, "", 8);
	DrawPanelText(mSayPanel, message);
	DrawPanelItem(mSayPanel, "", 8);
	SetPanelCurrentKey(mSayPanel, 10);
	DrawPanelItem(mSayPanel, "Exit", 16);
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			SendPanelToClient(mSayPanel, i, Handler_DoNothing, 10);
		}
		i++;
	}
	CloseHandle(mSayPanel);
	mSayPanel = MissingTAG:0;
	return void:0;
}

public Handler_DoNothing(Menu:menu, MenuAction:action, param1, param2)
{
	return 0;
}

