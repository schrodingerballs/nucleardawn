public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "05:49:06"
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
new Handle:HudMessage;
new bool:CanHUD;
new Handle:g_cvars_HUDTIME;
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
public Plugin:myinfo =
{
	name = "Advanced Menu Say",
	description = "Menu's for admins only, private msgs and coloured hud msgs",
	author = "MoggieX",
	version = "2.1",
	url = "http://www.UKManDown.co.uk/"
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
	CreateConVar("sm_mpsay_version", "2.1", "Menu's for admins only and private msgs", 270656, false, 0.0, false, 0.0);
	RegConsoleCmd("sm_pm", Command_SmmPsay, "", 0);
	RegAdminCmd("sm_pmahud", Command_SmAMsay, 512, "sm_amsay <message> - sends message to admins as a menu panel", "", 0);
	RegAdminCmd("sm_pmnahud", Command_SmNAmsay, 512, "sm_namsay <message> - sends message to non-admins as a menu panel", "", 0);
	RegAdminCmd("sm_hudsay", Command_SmHUDsay, 512, "sm_hudsay [colour] <message>. Valid colours: White, Red, Green, Blue, Yellow, Purple, Cyan, Orange, Pink, Olive, Lime, Violet, Lightblue", "", 0);
	RegAdminCmd("sm_teamhudsay", Command_SmHUDsayTeam, 512, "sm_namsay <message> - sends message a HUD message to your team", "", 0);
	g_cvars_HUDTIME = CreateConVar("sm_amsay_hudtime", "15.0", "How long the HUD messages are displayed.", 0, false, 0.0, false, 0.0);
	new String:gamename[32];
	GetGameFolderName(gamename, 32);
	new var1;
	CanHUD = StrEqual(gamename, "tf", false) || StrEqual(gamename, "hl2mp", false) || StrEqual(gamename, "sourceforts", false) || StrEqual(gamename, "obsidian", false) || StrEqual(gamename, "left4dead", false) || StrEqual(gamename, "l4d", false);
	if (CanHUD)
	{
		HudMessage = CreateHudSynchronizer();
	}
	return void:0;
}

public Action:Command_SmmPsay(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_pmsay <name or #userid> <message> - sends private message as a menu panel");
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
	new String:name[64] = "Console";
	decl String:name2[64];
	if (client)
	{
		GetClientName(client, name, 64);
	}
	GetClientName(target, name2, 64);
	PrintToChat(target, "\x03(Private Message: %s) %s:\x04 %s", name2, name, message);
	PrintToChat(client, "\x03(Private Message: %s) %s:\x04 %s", name2, name, message);
	new identifier = 1;
	SendPanelToTargets(name, target, client, message, identifier);
	return Action:3;
}

public Action:Command_SmAMsay(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_amsay <message> - sends message to admins as a menu panel");
		return Action:3;
	}
	decl String:message[192];
	GetCmdArgString(message, 192);
	decl String:name[64];
	GetClientName(client, name, 64);
	new identifier = 2;
	new target;
	SendPanelToTargets(name, target, client, message, identifier);
	return Action:3;
}

public Action:Command_SmNAmsay(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_namsay <message> - sends message to non-admins as a menu panel");
		return Action:3;
	}
	decl String:message[192];
	GetCmdArgString(message, 192);
	decl String:name[64];
	GetClientName(client, name, 64);
	new identifier = 3;
	new target;
	SendPanelToTargets(name, target, client, message, identifier);
	return Action:3;
}

SendPanelToTargets(String:name[], target, client, String:message[], identifier)
{
	decl String:title[100];
	if (identifier == 1)
	{
		Format(title, 64, "Private Message From: %s:", name);
	}
	if (identifier == 2)
	{
		Format(title, 64, "Admin Only Message From: %s:", name);
	}
	if (identifier == 3)
	{
		Format(title, 64, "Message From: %s:", name);
	}
	ReplaceString(message, 192, "\n", "\n", true);
	new Handle:mSayPanel = CreatePanel(Handle:0);
	SetPanelTitle(mSayPanel, title, false);
	DrawPanelItem(mSayPanel, "", 8);
	DrawPanelText(mSayPanel, message);
	DrawPanelItem(mSayPanel, "", 8);
	SetPanelCurrentKey(mSayPanel, 10);
	DrawPanelItem(mSayPanel, "Exit", 16);
	if (identifier == 1)
	{
		new var1;
		if (IsClientInGame(target) && !IsFakeClient(target))
		{
			SendPanelToClient(mSayPanel, target, Handler_DoNothing, 30);
		}
		new var2;
		if (IsClientInGame(client) && !IsFakeClient(client))
		{
			SendPanelToClient(mSayPanel, client, Handler_DoNothing, 30);
		}
		LogAction(client, -1, "%L triggered sm_pmsay to %L (text %s)", client, target, message);
	}
	if (identifier == 2)
	{
		new i = 1;
		while (i < MaxClients)
		{
			new var3;
			if (IsClientInGame(i) && !IsFakeClient(i) && CheckCommandAccess(i, "sm_chat", 512, false))
			{
				SendPanelToClient(mSayPanel, i, Handler_DoNothing, 30);
			}
			i++;
		}
		LogAction(client, -1, "%L triggered sm_amsay (text %s)", client, message);
	}
	if (identifier == 3)
	{
		new i = 1;
		while (i < MaxClients)
		{
			new var4;
			if (IsClientInGame(i) && !IsFakeClient(i) && !CheckCommandAccess(i, "sm_chat", 512, false))
			{
				SendPanelToClient(mSayPanel, i, Handler_DoNothing, 30);
			}
			i++;
		}
		LogAction(client, -1, "%L triggered sm_namsay (text %s)", client, message);
	}
	CloseHandle(mSayPanel);
	return 0;
}

public Handler_DoNothing(Handle:menu, MenuAction:action, param1, param2)
{
	return 0;
}

public Action:Command_SmHUDsay(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_hudsay [colour] <message>. Valid colours: White, Red, Green, Blue, Yellow, Purple, Cyan, Orange, Pink, Olive, Lime, Violet, Lightblue");
		return Action:3;
	}
	decl String:text[192];
	decl String:colorStr[16];
	GetCmdArgString(text, 192);
	new len = BreakString(text, colorStr, 16);
	decl String:name[64];
	GetClientName(client, name, 64);
	new color = FindColor(colorStr);
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
			SetHudTextParams(0.04, 0.4, GetConVarFloat(g_cvars_HUDTIME), g_Colors[color][0], g_Colors[color][1], g_Colors[color][2], 255, 0, 6.0, 0.1, 0.2);
			ShowSyncHudText(i, HudMessage, "%s \nFrom: %s", text[len], name);
		}
		i++;
	}
	LogAction(client, -1, "%L triggered sm_hudsay (text %s)", client, text);
	return Action:3;
}

public Action:Command_SmHUDsayTeam(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_hudsay [colour] <message>. Valid colours: White, Red, Green, Blue, Yellow, Purple, Cyan, Orange, Pink, Olive, Lime, Violet, Lightblue");
		return Action:3;
	}
	decl String:text[192];
	decl String:colorStr[16];
	GetCmdArgString(text, 192);
	new len = BreakString(text, colorStr, 16);
	new team = GetClientTeam(client);
	decl String:name[64];
	GetClientName(client, name, 64);
	new color = FindColor(colorStr);
	if (color == -1)
	{
		color = 0;
		len = 0;
	}
	SetHudTextParams(0.04, 0.4, GetConVarFloat(g_cvars_HUDTIME), g_Colors[color][0], g_Colors[color][1], g_Colors[color][2], 255, 0, 6.0, 0.1, 0.2);
	ShowSyncHudText(team, HudMessage, "%s", text[len]);
	LogAction(client, -1, "%L triggered sm_hudsayteam (text %s)", client, text);
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

