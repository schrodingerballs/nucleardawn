public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "03/14/2015",
	time = "00:30:40"
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
new g_iLimit[3];
new Handle:g_hTimerHandle;
new bool:g_bValidClient[66][2];
new g_iClientChoke[66][2];
new g_iClientLatency[66][2];
new g_iClientLoss[66][2];
new bool:g_bEnabled = 1;
new bool:g_bChokeEnabled = 1;
new bool:g_bLatencyEnabled = 1;
new bool:g_bLossEnabled = 1;
new bool:g_bKickVocalize = 1;
new bool:g_bWarningVocalize = 1;
new bool:g_bLiamMethod;
new bool:g_bLoggingEnabled;
new String:g_sBasePath[256];
new String:g_sLogTimeString[2][64];
new g_iCmdRate[2];
new g_iChokeAddition = 30;
new g_iLatencyAddition = 250;
new g_iLossAddition = 15;
new g_iChokeThreashold = 6;
new g_iLatencyThreashold = 6;
new g_iLossThreashold = 6;
new g_iMinPCount = 12;
new g_iCheckRate = 30;
public Plugin:myinfo =
{
	name = "Network Tools",
	description = "A NonStatic Network Data Tool.",
	author = "Kyle Sanderson",
	version = "1.3",
	url = "http://SourceMod.net"
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

RoundFloat(Float:value)
{
	return RoundToNearest(value);
}

Float:operator*(Float:,_:)(Float:oper1, oper2)
{
	return oper1 * float(oper2);
}

Float:operator/(Float:,_:)(Float:oper1, oper2)
{
	return oper1 / float(oper2);
}

Float:operator+(Float:,_:)(Float:oper1, oper2)
{
	return oper1 + float(oper2);
}

Float:operator-(_:,Float:)(oper1, Float:oper2)
{
	return float(oper1) - oper2;
}

PrintToChatAll(String:format[])
{
	decl String:buffer[192];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			SetGlobalTransTarget(i);
			VFormat(buffer, 192, format, 2);
			PrintToChat(i, "%s", buffer);
		}
		i++;
	}
	return 0;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	if (late)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			if (IsClientInGame(i))
			{
				OnClientPostAdminCheck(i);
			}
			i++;
		}
	}
	return APLRes:0;
}

public void:OnPluginStart()
{
	CreateConVar("sm_nt_verison", "1.3", "A NonStatic Network Data Tool.", 403776, false, 0.0, false, 0.0);
	new Handle:hRandom;
	new var1 = CreateConVar("nt_enabled", "1", "Should I even be running?", 0, true, 0.0, true, 1.0);
	hRandom = var1;
	HookConVarChange(var1, OnEnabledChange);
	g_bEnabled = GetConVarBool(hRandom);
	new var2 = CreateConVar("nt_minplayercount", "12", "How many players need to be ingame for any check to occur.", 0, true, 0.0, false, 0.0);
	hRandom = var2;
	HookConVarChange(var2, OnMinPlayChange);
	g_iMinPCount = GetConVarInt(hRandom);
	new var3 = CreateConVar("nt_checkrate", "30", "How many seconds between each check.", 0, true, 0.0, false, 0.0);
	hRandom = var3;
	HookConVarChange(var3, OnCheckRateChange);
	g_iCheckRate = GetConVarInt(hRandom);
	new var4 = CreateConVar("nt_logenabled", "0", "Should I be logging kicks?", 0, true, 0.0, true, 1.0);
	hRandom = var4;
	HookConVarChange(var4, OnLoggingChange);
	g_bLoggingEnabled = GetConVarBool(hRandom);
	new var5 = CreateConVar("nt_logformatext", "%Y_%m_%d", "Log Filename Format.", 0, false, 0.0, false, 0.0);
	hRandom = var5;
	HookConVarChange(var5, OnExtLogFormatChange);
	new var6 = g_sLogTimeString;
	GetConVarString(hRandom, var6[0][var6], 64);
	new var7 = CreateConVar("nt_logformatint", "%x", "Internal File logging format.", 0, false, 0.0, false, 0.0);
	hRandom = var7;
	HookConVarChange(var7, OnIntLogFormatChange);
	GetConVarString(hRandom, g_sLogTimeString[1], 64);
	new var8 = CreateConVar("nt_kickvocalize", "1", "Should Kick Messages be Printed to Chat?", 0, true, 0.0, true, 1.0);
	hRandom = var8;
	HookConVarChange(var8, OnKickMessageChange);
	g_bKickVocalize = GetConVarBool(hRandom);
	new var9 = CreateConVar("nt_warningvocalize", "1", "Warn the player that he has an impending kick comming up.", 0, true, 0.0, true, 1.0);
	hRandom = var9;
	HookConVarChange(var9, OnWarningMessageChange);
	g_bWarningVocalize = GetConVarBool(hRandom);
	new var10 = CreateConVar("nt_choke_enable", "1", "Should this plugin be checking Clients for Choke?", 0, true, 0.0, true, 1.0);
	hRandom = var10;
	HookConVarChange(var10, OnChokeEnableChange);
	g_bChokeEnabled = GetConVarBool(hRandom);
	new var11 = CreateConVar("nt_choke_addition", "30", "How high should I be increasing the Choke Kick value?", 0, true, 0.0, false, 0.0);
	hRandom = var11;
	HookConVarChange(var11, OnChokeAdditionChange);
	g_iChokeAddition = GetConVarInt(hRandom);
	new var12 = CreateConVar("nt_choke_threashold", "6", "How many checks until a client is kicked for High Choke.", 0, true, 0.0, false, 0.0);
	hRandom = var12;
	HookConVarChange(var12, OnChokeThreasholdChange);
	g_iChokeThreashold = GetConVarInt(hRandom);
	new var13 = CreateConVar("nt_latency_enable", "1", "Should this plugin be checking Client Latencies?", 0, true, 0.0, true, 1.0);
	hRandom = var13;
	HookConVarChange(var13, OnLatencyEnableChange);
	g_bLatencyEnabled = GetConVarBool(hRandom);
	new var14 = CreateConVar("nt_latency_addition", "250", "How high should I be increasing the Latency Kick value?", 0, true, 0.0, false, 0.0);
	hRandom = var14;
	HookConVarChange(var14, OnLatencyAdditionChange);
	g_iLatencyAddition = GetConVarInt(hRandom);
	new var15 = CreateConVar("nt_lat_threashold", "6", "How many checks until a client is kicked for High Latency.", 0, true, 0.0, false, 0.0);
	hRandom = var15;
	HookConVarChange(var15, OnLatencyThreasholdChange);
	g_iLatencyThreashold = GetConVarInt(hRandom);
	new var16 = CreateConVar("nt_liammethod", "0", "Are we using Liam's method from HPK-Lite for getting client latency?", 0, true, 0.0, true, 1.0);
	hRandom = var16;
	HookConVarChange(var16, OnLiamMethodChange);
	g_bLiamMethod = GetConVarBool(hRandom);
	new var17 = CreateConVar("nt_loss_enable", "1", "Should this plugin be checking Clients for Loss?", 0, true, 0.0, true, 1.0);
	hRandom = var17;
	HookConVarChange(var17, OnLossEnableChange);
	g_bLossEnabled = GetConVarBool(hRandom);
	new var18 = CreateConVar("nt_loss_addition", "15", "How high should I be increasing the Loss Kick value?", 0, true, 0.0, false, 0.0);
	hRandom = var18;
	HookConVarChange(var18, OnLossAdditionChange);
	g_iLossAddition = GetConVarInt(hRandom);
	new var19 = CreateConVar("nt_loss_threashold", "6", "How many checks until a client is kicked for High Loss.", 0, true, 0.0, false, 0.0);
	hRandom = var19;
	HookConVarChange(var19, OnLossThreasholdChange);
	g_iLossThreashold = GetConVarInt(hRandom);
	RegAdminCmd("nt_display", DisplayInformation, 1, "Display stored client information.", "", 0);
	RegAdminCmd("nt_toggle", ToggleImmune, 16384, "Toggles whether or not this plugin is active on a specific client.", "", 0);
	AutoExecConfig(true, "networktools", "sourcemod");
	if ((hRandom = FindConVar("sv_mincmdrate")))
	{
		g_iCmdRate[0] = GetConVarInt(hRandom);
		HookConVarChange(hRandom, OnMinCmdRateChange);
	}
	else
	{
		LogError("Warning. Missing sv_mincmdrate.");
	}
	if ((hRandom = FindConVar("sv_maxcmdrate")))
	{
		g_iCmdRate[1] = GetConVarInt(hRandom);
		HookConVarChange(hRandom, OnMaxCmdRateChange);
	}
	else
	{
		LogError("Warning. Missing sv_maxcmdrate.");
	}
	CloseHandle(hRandom);
	BuildPath(PathType:0, g_sBasePath, 256, "");
	return void:0;
}

public void:OnConfigsExecuted()
{
	if (g_bEnabled)
	{
		g_hTimerHandle = CreateTimer(float(g_iCheckRate), RefreshData, any:0, 3);
	}
	return void:0;
}

public void:OnClientPostAdminCheck(client)
{
	if ((g_bValidClient[client][0] = !IsFakeClient(client)))
	{
		g_bValidClient[client][1] = !CheckCommandAccess(client, "nt_display", 1, false);
	}
	return void:0;
}

public void:OnClientDisconnect(client)
{
	if (g_bValidClient[client][0])
	{
		g_iClientChoke[client][1] = 0;
		g_iClientLatency[client][1] = 0;
		g_iClientLoss[client][1] = 0;
		g_bValidClient[client][0] = false;
	}
	return void:0;
}

public void:OnMapEnd()
{
	g_hTimerHandle = MissingTAG:0;
	return void:0;
}

public Action:DisplayInformation(client, args)
{
	if (args < 1)
	{
		new var3 = g_sLogTimeString;
		ReplyToCommand(client, "%s\nPlugin Enabled: \x04%i\x03\nPlugin Kicking: \x04%i\x03\nMin Player Count: \x04%i\x03\nKick Vocalization: \x04%i\x03\nLogging Enabled: \x04%i\x03\nFile Logging Format: \x04%s\x03\nInternal File Logging Format: \x04%s\x03", "\x04[Network Tools]\x03", g_bEnabled, PlayerCountIsCorrect(), g_iMinPCount, g_bKickVocalize, g_bLoggingEnabled, var3[0][var3], g_sLogTimeString[1]);
		ReplyToCommand(client, "\x03Choke Enabled: \x04%i\x03\nChoke Limit: \x04%i\x03\nChoke Slide: \x04%i\x03\nLatency Enabled: \x04%i\x03\nLatency Limit: \x04%i\x03\nLatency Slide: \x04%i\x03\nLoss Enabled: \x04%i\x03\nLoss Limit: \x04%i\x03\nLoss Slide: \x04%i\x03", g_bChokeEnabled, g_iLimit, g_iChokeAddition, g_bLatencyEnabled, 2220 + 4, g_iLatencyAddition, g_bLossEnabled, 2220 + 8, g_iLossAddition);
		return Action:3;
	}
	decl String:Arg[128];
	new String:sClientChecking[4];
	GetCmdArgString(Arg, 128);
	decl iTarget_list[66];
	decl String:iTarget_name[68];
	decl bool:iTarget_ml;
	new ListSize = ProcessTargetString(Arg, client, iTarget_list, 65, 32, iTarget_name, 66, iTarget_ml);
	if (0 < ListSize)
	{
		new iTarget;
		ReplyToCommand(client, "%s", "\x04[Network Tools]\x03");
		new i;
		while (i < ListSize)
		{
			iTarget = iTarget_list[i];
			switch (g_bValidClient[iTarget][1])
			{
				case 0:
				{
					new var2;
					if (sClientChecking[0] == 'N' && sClientChecking[0])
					{
						strcopy(sClientChecking, 4, "No");
					}
				}
				case 1:
				{
					new var1;
					if (sClientChecking[0] == 'Y' && sClientChecking[0])
					{
						strcopy(sClientChecking, 4, "Yes");
					}
				}
				default:
				{
				}
			}
			ReplyToCommand(client, "\x03Name: \x04%N\x03\nReported Choke: (\x04%i\x03|\x04%i\x03/\x04%i\x03).\nReported Latency: (\x04%i\x03|\x04%i\x03/\x04%i\x03).\nReported Loss: (\x04%i\x03|\x04%i\x03/\x04%i\x03).\nChecking Enabled on Client: \x04%s\x03.", iTarget, g_iClientChoke[iTarget], g_iClientChoke[iTarget][1], g_iChokeThreashold, g_iClientLatency[iTarget], g_iClientLatency[iTarget][1], g_iLatencyThreashold, g_iClientLoss[iTarget], g_iClientLoss[iTarget][1], g_iLossThreashold, sClientChecking);
			i++;
		}
		return Action:3;
	}
	ReplyToCommand(client, "%s Could not find %s.", "\x04[Network Tools]\x03", Arg);
	return Action:3;
}

public Action:ToggleImmune(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "%s nt_toggle [client|#userid]", "\x04[Network Tools]\x03");
		return Action:3;
	}
	decl String:ArgString[128];
	GetCmdArgString(ArgString, 128);
	decl iTarget_list[66];
	decl String:iTarget_name[68];
	decl bool:iTarget_ml;
	new ListSize = ProcessTargetString(ArgString, client, iTarget_list, 65, 32, iTarget_name, 66, iTarget_ml);
	if (0 < ListSize)
	{
		new iTarget;
		ReplyToCommand(client, "%s", "\x04[Network Tools]\x03");
		new i;
		while (i < ListSize)
		{
			iTarget = iTarget_list[i];
			switch (g_bValidClient[iTarget][1])
			{
				case 0:
				{
					g_bValidClient[iTarget][1] = true;
					ReplyToCommand(client, "\x04%N\x03 will now be checked by this plugin.", iTarget);
				}
				case 1:
				{
					g_bValidClient[iTarget][1] = false;
					ReplyToCommand(client, "\x04%N\x03 will no longer be checked by this plugin.", iTarget);
				}
				default:
				{
				}
			}
			i++;
		}
	}
	return Action:3;
}

public Action:RefreshData(Handle:Timer)
{
	new var1;
	if (g_bEnabled && PlayerCountIsCorrect())
	{
		GetData();
		ProcessData();
	}
	return Action:3;
}

public ProcessData()
{
	new iMaxChoke = g_iLimit[0];
	new iMaxLatency = g_iLimit[1];
	new iMaxLoss = g_iLimit[2];
	new bool:bWarned;
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (g_bValidClient[i][0] && g_bValidClient[i][1])
		{
			if (g_bChokeEnabled)
			{
				if (g_iClientChoke[i][0] < iMaxChoke)
				{
					g_iClientChoke[i][1] = 0;
				}
				new var5 = g_iClientChoke[i][1];
				var5++;
				if (g_iChokeThreashold == var5)
				{
					if (g_bKickVocalize)
					{
						PrintToChatAll("%s Kicking %N for High Choke", "\x04[Network Tools]\x03", i);
					}
					LogKick(i, 0);
					KickClient(i, "High Choke.");
					i++;
				}
				new var2;
				if (g_bWarningVocalize && !bWarned)
				{
					PrintToChat(i, "%s Warning, you've failed check \x04%i\x03 for Choke.\nYou have \x04%i\x03 left until you're kicked.", "\x04[Network Tools]\x03", g_iClientChoke[i][1], g_iChokeThreashold - g_iClientChoke[i][1]);
					bWarned = true;
				}
			}
			if (g_bLatencyEnabled)
			{
				if (g_iClientLatency[i][0] < iMaxLatency)
				{
					if (g_iClientLatency[i][1])
					{
						g_iClientLatency[i][1] = 0;
					}
				}
				new var6 = g_iClientLatency[i][1];
				var6++;
				if (g_iLatencyThreashold == var6)
				{
					if (g_bKickVocalize)
					{
						PrintToChatAll("%s Kicking %N for High Latency.", "\x04[Network Tools]\x03", i);
					}
					LogKick(i, 1);
					KickClient(i, "High Latency.");
					i++;
				}
				new var3;
				if (g_bWarningVocalize && !bWarned)
				{
					PrintToChat(i, "%s Warning, you've failed check \x04%i\x03 for Latency.\nYou have \x04%i\x03 left until you're kicked.", "\x04[Network Tools]\x03", g_iClientLatency[i][1], g_iLatencyThreashold - g_iClientLatency[i][1]);
					bWarned = true;
				}
			}
			if (g_bLossEnabled)
			{
				if (g_iClientLoss[i][0] < iMaxLoss)
				{
					if (g_iClientLoss[i][1])
					{
						g_iClientLoss[i][1] = 0;
					}
				}
				new var7 = g_iClientLoss[i][1];
				var7++;
				if (g_iLossThreashold == var7)
				{
					if (g_bKickVocalize)
					{
						PrintToChatAll("%s Kicking %N for High Loss.", "\x04[Network Tools]\x03", i);
					}
					LogKick(i, 2);
					KickClient(i, "High Loss.");
					i++;
				}
				new var4;
				if (g_bWarningVocalize && !bWarned)
				{
					PrintToChat(i, "%s Warning, you've failed check \x04%i\x03 for Packet Loss.\nYou have \x04%i\x03 left until you're kicked.", "\x04[Network Tools]\x03", g_iClientLoss[i][1], g_iLossThreashold - g_iClientLoss[i][1]);
				}
			}
			if (bWarned)
			{
				bWarned = false;
			}
		}
		i++;
	}
	return 0;
}

public GetData()
{
	decl CmdRate;
	decl RandomVariable;
	new MinCmdRate = g_iCmdRate[0];
	new MaxCmdRate = g_iCmdRate[1];
	new iTickRate;
	new i;
	while (i < 3)
	{
		g_iLimit[i] = 999;
		i++;
	}
	decl String:sCmdClientInfo[4];
	if (g_bLiamMethod)
	{
		iTickRate = RoundToNearest(GetTickInterval());
	}
	new i = 1;
	while (i <= MaxClients)
	{
		if (g_bValidClient[i][0])
		{
			new var3 = RoundFloat(GetClientAvgChoke(i, NetFlow:0) * 100.0);
			g_iClientChoke[i][0] = var3;
			if (g_iLimit[0] > var3 & -1 < var3)
			{
				g_iLimit[0] = g_iClientChoke[i][0];
			}
			switch (g_bLiamMethod)
			{
				case 0:
				{
					new var6 = RoundFloat(GetClientAvgLatency(i, NetFlow:0) * 1000.0);
					g_iClientLatency[i][0] = var6;
					if (g_iLimit[1] > var6 & -1 < var6)
					{
						g_iLimit[1] = g_iClientLatency[i][0];
					}
				}
				case 1:
				{
					new var1;
					if (GetClientInfo(i, "cl_cmdrate", sCmdClientInfo, 4) && (CmdRate = StringToInt(sCmdClientInfo, 10)))
					{
						if (CmdRate > MaxCmdRate)
						{
							CmdRate = MaxCmdRate;
						}
						else
						{
							if (CmdRate < MinCmdRate)
							{
								CmdRate = MinCmdRate;
							}
						}
						RandomVariable = RoundFloat(GetClientAvgLatency(i, NetFlow:0));
						new var2;
						if (CmdRate < 20)
						{
							var2 = 20;
						}
						else
						{
							var2 = CmdRate;
						}
						RandomVariable -= 1056964608 / var2 + iTickRate;
						RandomVariable -= 1056964608 * iTickRate;
						new var4 = RandomVariable * 1000;
						RandomVariable *= 1000;
						g_iClientLatency[i][0] = var4;
						if (g_iLimit[1] > var4 & -1 < var4)
						{
							g_iLimit[1] = RandomVariable;
						}
					}
					else
					{
						new var5 = RoundFloat(GetClientAvgLatency(i, NetFlow:0) * 1000.0);
						g_iClientLatency[i][0] = var5;
						if (g_iLimit[1] > var5 & -1 < var5)
						{
							g_iLimit[1] = g_iClientLatency[i][0];
						}
					}
				}
				default:
				{
				}
			}
			new var7 = RoundFloat(GetClientAvgLoss(i, NetFlow:0) * 100.0);
			g_iClientLoss[i][0] = var7;
			if (g_iLimit[2] > var7 & -1 < var7)
			{
				g_iLimit[2] = g_iClientLoss[i][0];
			}
		}
		i++;
	}
	new var8 = g_iLimit;
	var8[0] = var8[0] + g_iChokeAddition;
	g_iLimit[1] += g_iLatencyAddition;
	g_iLimit[2] += g_iLossAddition;
	return 0;
}

PlayerCountIsCorrect()
{
	new k;
	new i = 1;
	while (i <= MaxClients)
	{
		if (g_bValidClient[i][0])
		{
			k++;
			if (k >= g_iMinPCount)
			{
				return 1;
			}
		}
		i++;
	}
	return 0;
}

LogKick(client, KickVal)
{
	if (!g_bLoggingEnabled)
	{
		return 0;
	}
	new var1 = g_sLogTimeString;
	if (!var1[0][var1])
	{
		LogError("nt_logformatext cannot be blank. Falling back to defaults.");
		new var2 = g_sLogTimeString;
		strcopy(var2[0][var2], 64, "%Y_%m_%d");
	}
	if (!g_sLogTimeString[1])
	{
		LogError("nt_logformatint cannot be blank. Falling back to defaults.");
		strcopy(g_sLogTimeString[1], 64, "%x");
	}
	new var3;
	new var4 = g_sLogTimeString;
	FormatTime(var3 + var3, 512, var4[0][var4], -1);
	new var5 = var3 + 4;
	FormatTime(var5 + var5, 512, g_sLogTimeString[1], -1);
	Format(var3 + var3, 512, "%slogs/NetworkTools.%s.log", g_sBasePath, var3 + var3);
	switch (KickVal)
	{
		case 0:
		{
			new var8 = var3 + 4;
			LogToFile(var3 + var3, "%s: Kicked %N for High Choke (%i/%i).", var8 + var8, client, g_iClientChoke[client], g_iLimit);
		}
		case 1:
		{
			new var7 = var3 + 4;
			LogToFile(var3 + var3, "%s: Kicked %N for High Latency (%i/%i).", var7 + var7, client, g_iClientLatency[client], 2220 + 4);
		}
		case 2:
		{
			new var6 = var3 + 4;
			LogToFile(var3 + var3, "%s: Kicked %N for High Loss (%i/%i).", var6 + var6, client, g_iClientLoss[client], 2220 + 8);
		}
		default:
		{
		}
	}
	return 0;
}

public OnEnabledChange(Handle:convar, String:oldValue[], String:newValue[])
{
	switch (GetConVarBool(convar))
	{
		case 0:
		{
			g_bEnabled = false;
			if (g_hTimerHandle)
			{
				KillTimer(g_hTimerHandle, false);
				g_hTimerHandle = MissingTAG:0;
			}
		}
		case 1:
		{
			g_bEnabled = true;
			if (g_hTimerHandle)
			{
				KillTimer(g_hTimerHandle, false);
			}
			g_hTimerHandle = CreateTimer(float(g_iCheckRate), RefreshData, any:0, 3);
		}
		default:
		{
		}
	}
	return 0;
}

public OnChokeAdditionChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iChokeAddition = GetConVarInt(convar);
	return 0;
}

public OnLatencyAdditionChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iLatencyAddition = GetConVarInt(convar);
	return 0;
}

public OnLossAdditionChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iLossAddition = GetConVarInt(convar);
	return 0;
}

public OnChokeThreasholdChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iChokeThreashold = GetConVarInt(convar);
	return 0;
}

public OnLatencyThreasholdChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iLatencyThreashold = GetConVarInt(convar);
	return 0;
}

public OnLossThreasholdChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iLossThreashold = GetConVarInt(convar);
	return 0;
}

public OnMinPlayChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iMinPCount = GetConVarInt(convar);
	return 0;
}

public OnLoggingChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_bLoggingEnabled = GetConVarBool(convar);
	return 0;
}

public OnExtLogFormatChange(Handle:convar, String:oldValue[], String:newValue[])
{
	new var1 = g_sLogTimeString;
	GetConVarString(convar, var1[0][var1], 64);
	return 0;
}

public OnIntLogFormatChange(Handle:convar, String:oldValue[], String:newValue[])
{
	GetConVarString(convar, g_sLogTimeString[1], 64);
	return 0;
}

public OnCheckRateChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iCheckRate = GetConVarInt(convar);
	switch (g_bEnabled)
	{
		case 0:
		{
			if (g_hTimerHandle)
			{
				KillTimer(g_hTimerHandle, false);
				g_hTimerHandle = MissingTAG:0;
			}
		}
		case 1:
		{
			if (g_hTimerHandle)
			{
				KillTimer(g_hTimerHandle, false);
			}
			g_hTimerHandle = CreateTimer(float(g_iCheckRate), RefreshData, any:0, 3);
		}
		default:
		{
		}
	}
	return 0;
}

public OnKickMessageChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_bKickVocalize = GetConVarBool(convar);
	return 0;
}

public OnWarningMessageChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_bWarningVocalize = GetConVarBool(convar);
	return 0;
}

public OnChokeEnableChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_bChokeEnabled = GetConVarBool(convar);
	return 0;
}

public OnLatencyEnableChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_bLatencyEnabled = GetConVarBool(convar);
	return 0;
}

public OnLossEnableChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_bLossEnabled = GetConVarBool(convar);
	return 0;
}

public OnLiamMethodChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_bLiamMethod = GetConVarBool(convar);
	return 0;
}

public OnMinCmdRateChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iCmdRate[0] = GetConVarInt(convar);
	return 0;
}

public OnMaxCmdRateChange(Handle:convar, String:oldValue[], String:newValue[])
{
	g_iCmdRate[1] = GetConVarInt(convar);
	return 0;
}

