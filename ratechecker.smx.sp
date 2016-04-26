public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "04/26/2015",
	time = "00:04:23"
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
new g_current[65];
public Plugin:myinfo =
{
	name = "RateChecker",
	description = "Displays Clients Rates in a Panel",
	author = "pRED*",
	version = "0.2",
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

SearchForClients(String:pattern[], clients[], maxClients)
{
	new total;
	if (maxClients)
	{
		if (pattern[0] == '#')
		{
			new input = StringToInt(pattern[0], 10);
			if (!input)
			{
				new String:name[68];
				new i = 1;
				while (i <= MaxClients)
				{
					if (IsClientInGame(i))
					{
						GetClientName(i, name, 65);
						if (!(strcmp(name, pattern, false)))
						{
							clients[0] = i;
							return 1;
						}
					}
					i++;
				}
			}
			else
			{
				new client = GetClientOfUserId(input);
				if (client)
				{
					clients[0] = client;
					return 1;
				}
			}
		}
		new String:name[68];
		new i = 1;
		while (i <= MaxClients)
		{
			if (IsClientInGame(i))
			{
				GetClientName(i, name, 65);
				if (StrContains(name, pattern, false) != -1)
				{
					total++;
					clients[total] = i;
					if (total >= maxClients)
					{
						return total;
					}
				}
			}
			i++;
		}
		return total;
	}
	return 0;
}

public void:OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("core.phrases");
	CreateConVar("sm_rate_version", "0.2", "RateChecker Version", 270656, false, 0.0, false, 0.0);
	RegConsoleCmd("sm_rate", Cmd_Rate, "", 0);
	RegAdminCmd("sm_ratelist", Cmd_RateList, 2, "", "", 0);
	return void:0;
}

public Action:Cmd_RateList(client, args)
{
	new maxplayers = GetMaxClients();
	new String:interp[12];
	new String:update[12];
	new String:cmd[12];
	new String:rate[12];
	new String:name[32];
	PrintToConsole(client, "Name Rate UpdateRate CmdRate Interp");
	new i = 1;
	while (i <= maxplayers)
	{
		if (IsClientInGame(i))
		{
			GetClientName(i, name, 31);
			GetClientInfo(i, "cl_interp", interp, 9);
			GetClientInfo(i, "cl_updaterate", update, 9);
			GetClientInfo(i, "cl_cmdrate", cmd, 9);
			GetClientInfo(i, "rate", rate, 9);
			PrintToConsole(client, "%s %s %s %s %s", name, rate, update, cmd, interp);
		}
		i++;
	}
	return Action:0;
}

public Action:Cmd_Rate(client, args)
{
	if (args > 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_rate <name or #userid>");
		return Action:3;
	}
	if (args)
	{
		new String:name[68];
		GetCmdArg(1, name, 65);
		new Clients[2];
		new NumClients = SearchForClients(name, Clients, 2);
		if (NumClients)
		{
			if (NumClients > 1)
			{
				ReplyToCommand(client, "[SM] %t", "More than one client matches", name);
				return Action:3;
			}
			if (!CanUserTarget(client, Clients[0]))
			{
				ReplyToCommand(client, "[SM] %t", "Unable to target");
				return Action:3;
			}
			RatesPrint(client, Clients[0]);
			return Action:3;
		}
		ReplyToCommand(client, "[SM] %t", "No matching client");
		return Action:3;
	}
	RatesPrint(client, client);
	return Action:3;
}

public RatesPrint(client, target)
{
	new String:interp[12];
	new String:update[12];
	new String:cmd[12];
	new String:rate[12];
	GetClientInfo(target, "cl_interp", interp, 9);
	GetClientInfo(target, "cl_updaterate", update, 9);
	GetClientInfo(target, "cl_cmdrate", cmd, 9);
	GetClientInfo(target, "rate", rate, 9);
	new Float:finterp = StringToFloat(interp);
	new iupdate = StringToInt(update, 10);
	new icmd = StringToInt(cmd, 10);
	new irate = StringToInt(rate, 10);
	new Handle:Panel = CreatePanel(GetMenuStyleHandle(MenuStyle:2));
	new String:targetname[32];
	new String:text[60];
	GetClientName(target, targetname, 31);
	Format(text, 59, "Rates for: %s", targetname);
	SetPanelTitle(Panel, text, false);
	DrawPanelItem(Panel, " ", 10);
	Format(text, 59, "Rate: %i", irate);
	DrawPanelItem(Panel, text, 0);
	Format(text, 59, "cl_updaterate: %i", iupdate);
	DrawPanelItem(Panel, text, 0);
	Format(text, 59, "cl_cmdrate: %i", icmd);
	DrawPanelItem(Panel, text, 0);
	Format(text, 59, "cl_interp: %f", finterp);
	DrawPanelItem(Panel, text, 0);
	DrawPanelItem(Panel, " ", 10);
	Format(text, 59, "%t", "Previous");
	DrawPanelItem(Panel, text, 0);
	Format(text, 59, "%t", "Next");
	DrawPanelItem(Panel, text, 0);
	Format(text, 59, "%t", "Exit");
	DrawPanelItem(Panel, text, 0);
	SendPanelToClient(Panel, client, RateMenu, 20);
	CloseHandle(Panel);
	g_current[client] = target;
	return 0;
}

public RateMenu(Handle:menu, MenuAction:action, param1, param2)
{
	new next;
	if (action == MenuAction:4)
	{
		if (param2 == 5)
		{
			next = FindPrevPlayer(g_current[param1]);
			if (next != -1)
			{
				RatesPrint(param1, next);
			}
			else
			{
				PrintToChat(param1, "[SM] %t", "No matching client");
			}
		}
		if (param2 == 6)
		{
			next = FindNextPlayer(g_current[param1]);
			if (next != -1)
			{
				RatesPrint(param1, next);
			}
			PrintToChat(param1, "[SM] %t", "No matching client");
		}
	}
	return 0;
}

FindNextPlayer(player)
{
	new maxclients = GetMaxClients();
	new temp = player;
	do {
		temp++;
		if (temp > maxclients)
		{
			temp = 1;
		}
		if (player == temp)
		{
			return -1;
		}
		new var1;
		if (!(IsClientInGame(temp) && !IsFakeClient(temp)))
		{
			return temp;
		}
	} while (!var1);
	return temp;
}

FindPrevPlayer(player)
{
	new maxclients = GetMaxClients();
	new temp = player;
	do {
		temp--;
		if (temp < 1)
		{
			temp = maxclients;
		}
		if (player == temp)
		{
			return -1;
		}
		new var1;
		if (!(IsClientInGame(temp) && !IsFakeClient(temp)))
		{
			return temp;
		}
	} while (!var1);
	return temp;
}

