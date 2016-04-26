public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5255",
	date = "03/10/2016",
	time = "00:29:58"
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
public SharedPlugin:__pl_gameme =
{
	name = "gameme",
	file = "gameme.smx",
	required = 1,
};
public Extension:__ext_cstrike =
{
	name = "cstrike",
	file = "games/game.cstrike.ext",
	autoload = 0,
	required = 0,
};
public Extension:__ext_cprefs =
{
	name = "Client Preferences",
	file = "clientprefs.ext",
	autoload = 1,
	required = 0,
};
public Extension:__ext_sdkhooks =
{
	name = "SDKHooks",
	file = "sdkhooks.ext",
	autoload = 1,
	required = 0,
};
new TFHoliday:TFHoliday_Birthday;
new TFHoliday:TFHoliday_Halloween;
new TFHoliday:TFHoliday_Christmas;
new TFHoliday:TFHoliday_EndOfTheLine;
new TFHoliday:TFHoliday_ValentinesDay;
new TFHoliday:TFHoliday_MeetThePyro;
new TFHoliday:TFHoliday_SpyVsEngyWar;
new TFHoliday:TFHoliday_FullMoon;
new TFHoliday:TFHoliday_HalloweenOrFullMoon;
new TFHoliday:TFHoliday_HalloweenOrFullMoonOrValentines;
new TFHoliday:TFHoliday_AprilFools;
public Extension:__ext_tf2 =
{
	name = "TF2 Tools",
	file = "game.tf2.ext",
	autoload = 0,
	required = 0,
};
new String:TFResourceNames[18][0];
public Extension:__ext_smsock =
{
	name = "Socket",
	file = "socket.ext",
	autoload = 1,
	required = 0,
};
public Plugin:myinfo =
{
	name = "gameME Plugin",
	description = "gameME Plugin",
	author = "TTS Oetzel & Goerz GmbH",
	version = "9889faf",
	url = "http://www.gameme.com"
};
new String:team_list[16][32];
new gameme_plugin[160];
new player_messages[66][66][256];
new gameme_players[66][14];
new player_weapons[66][52][16];
new player_damage[66][66][8];
new ColorSlotArray[6] =
{
	-1, ...
};
new String:csgo_code_models[15][0];
new String:csgo_weapon_list[52][0];
new String:css_code_models[8][0];
new String:css_ct_models[4][112] =
{
	"models/player/ct_urban.mdl",
	"models/player/ct_gsg9.mdl",
	"models/player/ct_sas.mdl",
	"models/player/ct_gign.mdl"
};
new String:css_ts_models[4][0];
new String:css_weapon_list[28][0];
new css_data[1];
new String:dods_weapon_list[26][0];
new String:l4d_weapon_list[23][0];
new l4dii_data[1];
new String:hl2mp_weapon_list[6][0];
new hl2mp_data[4];
new hl2mp_players[66][2];
new String:zps_weapon_list[11][0];
new zps_players[66][1];
new String:insmod_weapon_list[30][0];
new insmod_players[66][64];
new String:tf2_weapon_list[28][0];
new tf2_data[10];
new tf2_players[66][23];
new Handle:gameMEStatsRankForward;
new Handle:gameMEStatsPublicCommandForward;
new Handle:gameMEStatsTop10Forward;
new Handle:gameMEStatsNextForward;
new global_query_id;
new Handle:QueryCallbackArray;
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

RoundFloat(Float:value)
{
	return RoundToNearest(value);
}

bool:operator>(Float:,_:)(Float:oper1, oper2)
{
	return oper1 > float(oper2);
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

ExplodeString(String:text[], String:split[], String:buffers[][], maxStrings, maxStringLength, bool:copyRemainder)
{
	new reloc_idx;
	new idx;
	new total;
	new var1;
	if (maxStrings < 1 || !split[0])
	{
		return 0;
	}
	while ((idx = SplitString(text[reloc_idx], split, buffers[total], maxStringLength)) != -1)
	{
		reloc_idx = idx + reloc_idx;
		total++;
		if (maxStrings == total)
		{
			if (copyRemainder)
			{
				strcopy(buffers[total + -1], maxStringLength, text[reloc_idx - idx]);
			}
			return total;
		}
	}
	total++;
	strcopy(buffers[total], maxStringLength, text[reloc_idx]);
	return total;
}

Handle:StartMessageOne(String:msgname[], client, flags)
{
	new players[1];
	players[0] = client;
	return StartMessage(msgname, players, 1, flags);
}

PrintCenterTextAll(String:format[])
{
	decl String:buffer[192];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			SetGlobalTransTarget(i);
			VFormat(buffer, 192, format, 2);
			PrintCenterText(i, "%s", buffer);
		}
		i++;
	}
	return 0;
}

ShowMOTDPanel(client, String:title[], String:msg[], type)
{
	new String:num[4];
	IntToString(type, num, 3);
	new KeyValues:kv = KeyValues.KeyValues("data", "", "");
	KeyValues.SetString(kv, "title", title);
	KeyValues.SetString(kv, "type", num);
	KeyValues.SetString(kv, "msg", msg);
	ShowVGUIPanel(client, "info", kv, true);
	CloseHandle(kv);
	kv = MissingTAG:0;
	return 0;
}

DisplayAskConnectBox(client, Float:time, String:ip[], String:password[])
{
	new String:destination[288];
	FormatEx(destination, 288, "%s/%s", ip, password);
	new KeyValues:kv = KeyValues.KeyValues("data", "", "");
	KeyValues.SetFloat(kv, "time", time);
	KeyValues.SetString(kv, "title", destination);
	CreateDialog(client, kv, DialogType:4);
	CloseHandle(kv);
	kv = MissingTAG:0;
	return 0;
}

bool:PopStack(Handle:stack)
{
	new value;
	return PopStackCell(stack, value, 0, false);
}

public __ext_cstrike_SetNTVOptional()
{
	MarkNativeAsOptional("CS_RespawnPlayer");
	MarkNativeAsOptional("CS_SwitchTeam");
	MarkNativeAsOptional("CS_DropWeapon");
	MarkNativeAsOptional("CS_TerminateRound");
	MarkNativeAsOptional("CS_GetTranslatedWeaponAlias");
	MarkNativeAsOptional("CS_GetWeaponPrice");
	MarkNativeAsOptional("CS_GetClientClanTag");
	MarkNativeAsOptional("CS_SetClientClanTag");
	MarkNativeAsOptional("CS_GetTeamScore");
	MarkNativeAsOptional("CS_SetTeamScore");
	MarkNativeAsOptional("CS_GetMVPCount");
	MarkNativeAsOptional("CS_SetMVPCount");
	MarkNativeAsOptional("CS_GetClientContributionScore");
	MarkNativeAsOptional("CS_SetClientContributionScore");
	MarkNativeAsOptional("CS_GetClientAssists");
	MarkNativeAsOptional("CS_SetClientAssists");
	MarkNativeAsOptional("CS_AliasToWeaponID");
	MarkNativeAsOptional("CS_WeaponIDToAlias");
	MarkNativeAsOptional("CS_IsValidWeaponID");
	MarkNativeAsOptional("CS_UpdateClientModel");
	return 0;
}

public __ext_cprefs_SetNTVOptional()
{
	MarkNativeAsOptional("RegClientCookie");
	MarkNativeAsOptional("FindClientCookie");
	MarkNativeAsOptional("SetClientCookie");
	MarkNativeAsOptional("GetClientCookie");
	MarkNativeAsOptional("AreClientCookiesCached");
	MarkNativeAsOptional("SetCookiePrefabMenu");
	MarkNativeAsOptional("SetCookieMenuItem");
	MarkNativeAsOptional("ShowCookieMenu");
	MarkNativeAsOptional("GetCookieIterator");
	MarkNativeAsOptional("ReadCookieIterator");
	MarkNativeAsOptional("GetCookieAccess");
	MarkNativeAsOptional("GetClientCookieTime");
	return 0;
}

public __ext_tf2_SetNTVOptional()
{
	MarkNativeAsOptional("TF2_IgnitePlayer");
	MarkNativeAsOptional("TF2_RespawnPlayer");
	MarkNativeAsOptional("TF2_RegeneratePlayer");
	MarkNativeAsOptional("TF2_AddCondition");
	MarkNativeAsOptional("TF2_RemoveCondition");
	MarkNativeAsOptional("TF2_SetPlayerPowerPlay");
	MarkNativeAsOptional("TF2_DisguisePlayer");
	MarkNativeAsOptional("TF2_RemovePlayerDisguise");
	MarkNativeAsOptional("TF2_StunPlayer");
	MarkNativeAsOptional("TF2_MakeBleed");
	MarkNativeAsOptional("TF2_GetResourceEntity");
	MarkNativeAsOptional("TF2_GetClass");
	MarkNativeAsOptional("TF2_IsPlayerInDuel");
	MarkNativeAsOptional("TF2_IsHolidayActive");
	MarkNativeAsOptional("TF2_RemoveWearable");
	return 0;
}

bool:TF2_IsPlayerInCondition(client, TFCond:cond)
{
	if (cond < TFCond:32)
	{
		new bit = 1 << cond;
		if (bit == bit & GetEntProp(client, PropType:0, TFResourceNames, 4, 0))
		{
			return true;
		}
		if (bit == bit & GetEntProp(client, PropType:0, "_condition_bits", 4, 0))
		{
			return true;
		}
	}
	else
	{
		if (cond < TFCond:64)
		{
			new bit = 1 << cond + -32;
			if (bit == bit & GetEntProp(client, PropType:0, "m_nPlayerCondEx", 4, 0))
			{
				return true;
			}
		}
		if (cond < TFCond:96)
		{
			new bit = 1 << cond + -64;
			if (bit == bit & GetEntProp(client, PropType:0, "m_nPlayerCondEx2", 4, 0))
			{
				return true;
			}
		}
		new bit = 1 << cond + -96;
		if (bit == bit & GetEntProp(client, PropType:0, "m_nPlayerCondEx3", 4, 0))
		{
			return true;
		}
	}
	return false;
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
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/gameme/gameme.txt");
	}
	return void:0;
}

AddUpdaterLibrary()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("https://github.com/stickz/Redstone/raw/build/updater/gameme/gameme.txt");
	}
	return 0;
}

public void:OnPluginStart()
{
	LogToGame("gameME Plugin %s (http://www.gameme.com), copyright (c) 2007-2016 TTS Oetzel & Goerz GmbH", "4.7.2");
	AddUpdaterLibrary();
	gameme_plugin[146] = 1;
	gameme_plugin[147] = 0;
	gameme_plugin[148] = 1;
	gameme_plugin[149] = 0;
	gameme_plugin[150] = 1045220557;
	gameme_plugin[159] = 0;
	LoadTranslations("gameme.phrases");
	gameme_plugin[34] = CreateTrie();
	SetTrieValue(gameme_plugin[34], "rank", any:1, true);
	SetTrieValue(gameme_plugin[34], "/rank", any:1, true);
	SetTrieValue(gameme_plugin[34], "!rank", any:1, true);
	SetTrieValue(gameme_plugin[34], "skill", any:1, true);
	SetTrieValue(gameme_plugin[34], "/skill", any:1, true);
	SetTrieValue(gameme_plugin[34], "!skill", any:1, true);
	SetTrieValue(gameme_plugin[34], "points", any:1, true);
	SetTrieValue(gameme_plugin[34], "/points", any:1, true);
	SetTrieValue(gameme_plugin[34], "!points", any:1, true);
	SetTrieValue(gameme_plugin[34], "place", any:1, true);
	SetTrieValue(gameme_plugin[34], "/place", any:1, true);
	SetTrieValue(gameme_plugin[34], "!place", any:1, true);
	SetTrieValue(gameme_plugin[34], "session", any:1, true);
	SetTrieValue(gameme_plugin[34], "/session", any:1, true);
	SetTrieValue(gameme_plugin[34], "!session", any:1, true);
	SetTrieValue(gameme_plugin[34], "sdata", any:1, true);
	SetTrieValue(gameme_plugin[34], "/sdata", any:1, true);
	SetTrieValue(gameme_plugin[34], "!sdata", any:1, true);
	SetTrieValue(gameme_plugin[34], "kpd", any:1, true);
	SetTrieValue(gameme_plugin[34], "/kpd", any:1, true);
	SetTrieValue(gameme_plugin[34], "!kpd", any:1, true);
	SetTrieValue(gameme_plugin[34], "kdratio", any:1, true);
	SetTrieValue(gameme_plugin[34], "/kdratio", any:1, true);
	SetTrieValue(gameme_plugin[34], "!kdratio", any:1, true);
	SetTrieValue(gameme_plugin[34], "kdeath", any:1, true);
	SetTrieValue(gameme_plugin[34], "/kdeath", any:1, true);
	SetTrieValue(gameme_plugin[34], "!kdeath", any:1, true);
	SetTrieValue(gameme_plugin[34], "next", any:1, true);
	SetTrieValue(gameme_plugin[34], "/next", any:1, true);
	SetTrieValue(gameme_plugin[34], "!next", any:1, true);
	SetTrieValue(gameme_plugin[34], "load", any:1, true);
	SetTrieValue(gameme_plugin[34], "/load", any:1, true);
	SetTrieValue(gameme_plugin[34], "!load", any:1, true);
	SetTrieValue(gameme_plugin[34], "status", any:1, true);
	SetTrieValue(gameme_plugin[34], "/status", any:1, true);
	SetTrieValue(gameme_plugin[34], "!status", any:1, true);
	SetTrieValue(gameme_plugin[34], "top20", any:1, true);
	SetTrieValue(gameme_plugin[34], "/top20", any:1, true);
	SetTrieValue(gameme_plugin[34], "!top20", any:1, true);
	SetTrieValue(gameme_plugin[34], "top10", any:1, true);
	SetTrieValue(gameme_plugin[34], "/top10", any:1, true);
	SetTrieValue(gameme_plugin[34], "!top10", any:1, true);
	SetTrieValue(gameme_plugin[34], "top5", any:1, true);
	SetTrieValue(gameme_plugin[34], "/top5", any:1, true);
	SetTrieValue(gameme_plugin[34], "!top5", any:1, true);
	SetTrieValue(gameme_plugin[34], "maps", any:1, true);
	SetTrieValue(gameme_plugin[34], "/maps", any:1, true);
	SetTrieValue(gameme_plugin[34], "!maps", any:1, true);
	SetTrieValue(gameme_plugin[34], "map_stats", any:1, true);
	SetTrieValue(gameme_plugin[34], "/map_stats", any:1, true);
	SetTrieValue(gameme_plugin[34], "!map_stats", any:1, true);
	SetTrieValue(gameme_plugin[34], "clans", any:1, true);
	SetTrieValue(gameme_plugin[34], "/clans", any:1, true);
	SetTrieValue(gameme_plugin[34], "!clans", any:1, true);
	SetTrieValue(gameme_plugin[34], "cheaters", any:1, true);
	SetTrieValue(gameme_plugin[34], "/cheaters", any:1, true);
	SetTrieValue(gameme_plugin[34], "!cheaters", any:1, true);
	SetTrieValue(gameme_plugin[34], "statsme", any:1, true);
	SetTrieValue(gameme_plugin[34], "/statsme", any:1, true);
	SetTrieValue(gameme_plugin[34], "!statsme", any:1, true);
	SetTrieValue(gameme_plugin[34], "weapons", any:1, true);
	SetTrieValue(gameme_plugin[34], "/weapons", any:1, true);
	SetTrieValue(gameme_plugin[34], "!weapons", any:1, true);
	SetTrieValue(gameme_plugin[34], "weapon", any:1, true);
	SetTrieValue(gameme_plugin[34], "/weapon", any:1, true);
	SetTrieValue(gameme_plugin[34], "!weapon", any:1, true);
	SetTrieValue(gameme_plugin[34], "action", any:1, true);
	SetTrieValue(gameme_plugin[34], "/action", any:1, true);
	SetTrieValue(gameme_plugin[34], "!action", any:1, true);
	SetTrieValue(gameme_plugin[34], "actions", any:1, true);
	SetTrieValue(gameme_plugin[34], "/actions", any:1, true);
	SetTrieValue(gameme_plugin[34], "!actions", any:1, true);
	SetTrieValue(gameme_plugin[34], "accuracy", any:1, true);
	SetTrieValue(gameme_plugin[34], "/accuracy", any:1, true);
	SetTrieValue(gameme_plugin[34], "!accuracy", any:1, true);
	SetTrieValue(gameme_plugin[34], "targets", any:1, true);
	SetTrieValue(gameme_plugin[34], "/targets", any:1, true);
	SetTrieValue(gameme_plugin[34], "!targets", any:1, true);
	SetTrieValue(gameme_plugin[34], "target", any:1, true);
	SetTrieValue(gameme_plugin[34], "/target", any:1, true);
	SetTrieValue(gameme_plugin[34], "!target", any:1, true);
	SetTrieValue(gameme_plugin[34], "kills", any:1, true);
	SetTrieValue(gameme_plugin[34], "/kills", any:1, true);
	SetTrieValue(gameme_plugin[34], "!kills", any:1, true);
	SetTrieValue(gameme_plugin[34], "kill", any:1, true);
	SetTrieValue(gameme_plugin[34], "/kill", any:1, true);
	SetTrieValue(gameme_plugin[34], "!kill", any:1, true);
	SetTrieValue(gameme_plugin[34], "player_kills", any:1, true);
	SetTrieValue(gameme_plugin[34], "/player_kills", any:1, true);
	SetTrieValue(gameme_plugin[34], "!player_kills", any:1, true);
	SetTrieValue(gameme_plugin[34], "cmds", any:1, true);
	SetTrieValue(gameme_plugin[34], "/cmds", any:1, true);
	SetTrieValue(gameme_plugin[34], "!cmds", any:1, true);
	SetTrieValue(gameme_plugin[34], "commands", any:1, true);
	SetTrieValue(gameme_plugin[34], "/commands", any:1, true);
	SetTrieValue(gameme_plugin[34], "!commands", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme_display 0", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme_display 0", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme_display 0", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme_display 1", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme_display 1", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme_display 1", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme_atb 0", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme_atb 0", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme_atb 0", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme_atb 1", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme_atb 1", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme_atb 1", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme_hideranking", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme_hideranking", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme_hideranking", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme_reset", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme_reset", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme_reset", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme_chat 0", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme_chat 0", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme_chat 0", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme_chat 1", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme_chat 1", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme_chat 1", any:1, true);
	SetTrieValue(gameme_plugin[34], "gstats", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gstats", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gstats", any:1, true);
	SetTrieValue(gameme_plugin[34], "global_stats", any:1, true);
	SetTrieValue(gameme_plugin[34], "/global_stats", any:1, true);
	SetTrieValue(gameme_plugin[34], "!global_stats", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme", any:1, true);
	SetTrieValue(gameme_plugin[34], "gameme_menu", any:1, true);
	SetTrieValue(gameme_plugin[34], "/gameme_menu", any:1, true);
	SetTrieValue(gameme_plugin[34], "!gameme_menu", any:1, true);
	CreateConVar("gameme_plugin_version", "4.7.2", "gameME Plugin", 256, false, 0.0, false, 0.0);
	CreateConVar("gameme_webpage", "http://www.gameme.com", "http://www.gameme.com", 256, false, 0.0, false, 0.0);
	gameme_plugin[33] = CreateConVar("gameme_block_commands", "1", "If activated gameME commands are blocked from the chat area", 0, false, 0.0, false, 0.0);
	gameme_plugin[35] = CreateConVar("gameme_block_commands_values", "", "Define which commands should be blocked from the chat area", 0, false, 0.0, false, 0.0);
	HookConVarChange(gameme_plugin[35], OnBlockChatCommandsValuesChange);
	gameme_plugin[36] = CreateConVar("gameme_message_prefix", "", "Define the prefix displayed on every gameME ingame message", 0, false, 0.0, false, 0.0);
	HookConVarChange(gameme_plugin[36], OnMessagePrefixChange);
	gameme_plugin[69] = CreateConVar("gameme_protect_address", "", "Address to be protected for logging/forwarding", 0, false, 0.0, false, 0.0);
	HookConVarChange(gameme_plugin[69], OnProtectAddressChange);
	gameme_plugin[109] = CreateConVar("gameme_log_locations", "1", "If activated the gameserver logs players locations", 0, false, 0.0, false, 0.0);
	HookConVarChange(gameme_plugin[109], OnLogLocationsChange);
	gameme_plugin[103] = CreateConVar("gameme_display_spectatorinfo", "0", "If activated gameME Stats data are displayed while spectating a player", 0, false, 0.0, false, 0.0);
	HookConVarChange(gameme_plugin[103], OnDisplaySpectatorinfoChange);
	gameme_plugin[110] = CreateConVar("gameme_damage_display", "0", "If activated the damage summary is display on player_death (1 = menu, 2 = chat)", 0, false, 0.0, false, 0.0);
	HookConVarChange(gameme_plugin[110], OnDamageDisplayChange);
	gameme_plugin[111] = CreateConVar("gameme_live", "0", "If activated gameME Live! is enabled", 0, false, 0.0, false, 0.0);
	HookConVarChange(gameme_plugin[111], OngameMELiveChange);
	gameme_plugin[112] = CreateConVar("gameme_live_address", "", "Network address of gameME Live!", 0, false, 0.0, false, 0.0);
	HookConVarChange(gameme_plugin[112], OnLiveAddressChange);
	get_server_mod();
	if (gameme_plugin[0] == 11)
	{
		if (GetUserMessageType() == 1)
		{
			gameme_plugin[159] = 1;
			LogToGame("gameME Protobuf user messages detected");
		}
	}
	CreateGameMEMenuMain(4364 + 416);
	CreateGameMEMenuAuto(4364 + 420);
	CreateGameMEMenuEvents(4364 + 424);
	RegServerCmd("gameme_raw_message", gameme_raw_message, "", 0);
	RegServerCmd("gameme_psay", gameme_psay, "", 0);
	RegServerCmd("gameme_csay", gameme_csay, "", 0);
	RegServerCmd("gameme_msay", gameme_msay, "", 0);
	RegServerCmd("gameme_tsay", gameme_tsay, "", 0);
	RegServerCmd("gameme_hint", gameme_hint, "", 0);
	RegServerCmd("gameme_khint", gameme_khint, "", 0);
	RegServerCmd("gameme_browse", gameme_browse, "", 0);
	RegServerCmd("gameme_swap", gameme_swap, "", 0);
	RegServerCmd("gameme_redirect", gameme_redirect, "", 0);
	RegServerCmd("gameme_player_action", gameme_player_action, "", 0);
	RegServerCmd("gameme_team_action", gameme_team_action, "", 0);
	RegServerCmd("gameme_world_action", gameme_world_action, "", 0);
	RegConsoleCmd("say", gameme_block_commands, "", 0);
	RegConsoleCmd("say_team", gameme_block_commands, "", 0);
	if (gameme_plugin[0] == 7)
	{
		RegConsoleCmd("say2", gameme_block_commands, "", 0);
	}
	RegServerCmd("log", ProtectLoggingChange, "", 0);
	RegServerCmd("logaddress_del", ProtectForwardingChange, "", 0);
	RegServerCmd("logaddress_delall", ProtectForwardingDelallChange, "", 0);
	RegServerCmd("gameme_message_prefix_clear", MessagePrefixClear, "", 0);
	gameme_plugin[155] = CreateArray(128, 0);
	gameme_plugin[156] = FindConVar("sv_tags");
	gameme_plugin[153] = GetEngineVersion();
	if (gameme_plugin[156])
	{
		AddPluginServerTag("gameME");
		HookConVarChange(gameme_plugin[156], OnTagsChange);
	}
	new var1;
	if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1 || gameme_plugin[0] == 3 || gameme_plugin[0] == 4 || gameme_plugin[0] == 5 || gameme_plugin[0] == 6 || gameme_plugin[0] == 7)
	{
		HookEvent("player_team", gameME_Event_PlyTeamChange, EventHookMode:0);
	}
	switch (gameme_plugin[0])
	{
		case 3:
		{
			hl2mp_data[3] = FindSendPropInfo("CCrossbowBolt", "m_hOwnerEntity", 0, 0, 0);
			hl2mp_data[0] = FindConVar("mp_teamplay");
			if (hl2mp_data[0])
			{
				hl2mp_data[1] = GetConVarBool(hl2mp_data[0]);
				HookConVarChange(hl2mp_data[0], OnTeamPlayChange);
			}
			hl2mp_data[2] = CreateStack(1);
		}
		case 4:
		{
			tf2_data[7] = FindConVar("tf_weapon_criticals");
			HookConVarChange(tf2_data[7], OnTF2CriticalHitsChange);
			tf2_data[4] = CreateStack(1);
			tf2_data[5] = CreateStack(1);
			tf2_data[1] = CreateKeyValues("items_game", "", "");
			if (FileToKeyValues(tf2_data[1], "scripts/items/items_game.txt"))
			{
				KvJumpToKey(tf2_data[1], "items", false);
			}
			tf2_data[2] = CreateTrie();
			SetTrieValue(tf2_data[2], "primary", any:0, true);
			SetTrieValue(tf2_data[2], "secondary", any:1, true);
			SetTrieValue(tf2_data[2], "melee", any:2, true);
			SetTrieValue(tf2_data[2], "pda", any:3, true);
			SetTrieValue(tf2_data[2], "pda2", any:4, true);
			SetTrieValue(tf2_data[2], "building", any:5, true);
			SetTrieValue(tf2_data[2], "head", any:6, true);
			SetTrieValue(tf2_data[2], "misc", any:7, true);
			new i;
			while (i <= 65)
			{
				tf2_players[i][17] = CreateStack(1);
				tf2_players[i][22] = 0;
				tf2_players[i][19] = 0;
				i++;
			}
			init_tf2_weapon_trie();
			AddGameLogHook(OnTF2GameLog);
		}
		case 6:
		{
			l4dii_data[0] = FindSendPropInfo("CTerrorPlayer", "m_hActiveWeapon", 0, 0, 0);
		}
		default:
		{
		}
	}
	GetConVarString(gameme_plugin[36], 4364 + 148, 32);
	color_gameme_entities(4364 + 148);
	if (gameme_plugin[69])
	{
		decl String:protect_address_cvar_value[32];
		GetConVarString(gameme_plugin[69], protect_address_cvar_value, 32);
		if (strcmp(protect_address_cvar_value, "", true))
		{
			new String:ProtectSplitArray[2][16] = "\x08";
			new protect_split_count = ExplodeString(protect_address_cvar_value, ":", ProtectSplitArray, 2, 16, false);
			if (protect_split_count == 2)
			{
				strcopy(4364 + 280, 32, ProtectSplitArray[0][ProtectSplitArray]);
				gameme_plugin[102] = StringToInt(ProtectSplitArray[1], 10);
			}
		}
	}
	if (gameme_plugin[112])
	{
		decl String:gameme_live_address_cvar_value[32];
		GetConVarString(gameme_plugin[112], gameme_live_address_cvar_value, 32);
		if (strcmp(gameme_live_address_cvar_value, "", true))
		{
			new String:LiveSplitArray[2][16] = "\x08";
			new live_split_count = ExplodeString(gameme_live_address_cvar_value, ":", LiveSplitArray, 2, 16, false);
			if (live_split_count == 2)
			{
				strcopy(4364 + 452, 32, LiveSplitArray[0][LiveSplitArray]);
				gameme_plugin[145] = StringToInt(LiveSplitArray[1], 10);
			}
		}
	}
	new Handle:server_hostport = FindConVar("hostport");
	if (server_hostport)
	{
		decl String:temp_port[16];
		GetConVarString(server_hostport, temp_port, 16);
		gameme_plugin[158] = StringToInt(temp_port, 10);
	}
	gameme_plugin[107] = CreateArray(1, 0);
	gameme_plugin[108] = CreateStack(1);
	QueryCallbackArray = CreateArray(7, 0);
	gameMEStatsRankForward = CreateGlobalForward("onGameMEStatsRank", ExecType:2, 2, 2, 7, 9, 9, 9, 9, 7, 9, 9, 7);
	gameMEStatsPublicCommandForward = CreateGlobalForward("onGameMEStatsPublicCommand", ExecType:2, 2, 2, 7, 9, 9, 9, 9, 7, 9, 9, 7);
	gameMEStatsTop10Forward = CreateGlobalForward("onGameMEStatsTop10", ExecType:2, 2, 2, 7, 9, 9, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7);
	gameMEStatsNextForward = CreateGlobalForward("onGameMEStatsNext", ExecType:2, 2, 2, 7, 9, 9, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7);
	return void:0;
}

public void:OnPluginEnd()
{
	if (gameme_plugin[107])
	{
		CloseHandle(gameme_plugin[107]);
	}
	if (gameme_plugin[108])
	{
		CloseHandle(gameme_plugin[108]);
	}
	if (QueryCallbackArray)
	{
		CloseHandle(QueryCallbackArray);
	}
	if (gameme_plugin[34])
	{
		CloseHandle(gameme_plugin[34]);
	}
	new var1;
	if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			if (gameme_players[i][11])
			{
				KillTimer(gameme_players[i][11], false);
				gameme_players[i][11] = 0;
			}
			i++;
		}
	}
	return void:0;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	RegPluginLibrary("gameme");
	CreateNative("DisplayGameMEStatsMenu", native_display_menu);
	CreateNative("QueryGameMEStats", native_query_gameme_stats);
	CreateNative("QueryGameMEStatsTop10", native_query_gameme_stats);
	CreateNative("QueryGameMEStatsNext", native_query_gameme_stats);
	CreateNative("QueryIntGameMEStats", native_query_gameme_stats);
	CreateNative("gameMEStatsColorEntities", native_color_gameme_entities);
	MarkNativeAsOptional("CS_SwitchTeam");
	MarkNativeAsOptional("CS_RespawnPlayer");
	MarkNativeAsOptional("SetCookieMenuItem");
	MarkNativeAsOptional("SDKHook");
	MarkNativeAsOptional("SocketCreate");
	MarkNativeAsOptional("SocketSendTo");
	MarkNativeAsOptional("GetUserMessageType");
	MarkNativeAsOptional("PbSetInt");
	MarkNativeAsOptional("PbSetBool");
	MarkNativeAsOptional("PbSetString");
	MarkNativeAsOptional("PbAddString");
	return APLRes:0;
}

public void:OnAllPluginsLoaded()
{
	if (LibraryExists("clientprefs"))
	{
		SetCookieMenuItem(gameMESettingsMenu, any:0, "gameME Settings");
	}
	if (LibraryExists("sdkhooks"))
	{
		LogToGame("gameME Extension SDK Hooks is available");
		gameme_plugin[152] = 1;
	}
	new var1;
	if (gameme_plugin[0] == 1 || gameme_plugin[0] == 11)
	{
		new var2;
		if (strcmp(4364 + 452, "", true) && strcmp(4364 + 580, "", true))
		{
			new enable_gameme_live_cvar = GetConVarInt(gameme_plugin[111]);
			if (enable_gameme_live_cvar == 1)
			{
				gameme_plugin[149] = 1;
				start_gameme_live();
				LogToGame("gameME Live! activated");
			}
			else
			{
				if (!enable_gameme_live_cvar)
				{
					gameme_plugin[149] = 0;
					LogToGame("gameME Live! not active");
				}
			}
		}
		gameme_plugin[149] = 0;
		LogToGame("gameME Live! cannot be activated, no gameME Live! address assigned");
	}
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			if (gameme_plugin[152])
			{
				switch (gameme_plugin[0])
				{
					case 3:
					{
						SDKHook(i, SDKHookType:1, OnHL2MPFireBullets);
						SDKHook(i, SDKHookType:12, OnHL2MPTraceAttack);
						SDKHook(i, SDKHookType:3, OnHL2MPTakeDamage);
					}
					case 4:
					{
						SDKHook(i, SDKHookType:3, OnTF2TakeDamage_Post);
						SDKHook(i, SDKHookType:2, OnTF2TakeDamage);
						tf2_players[i][16] = 1;
						tf2_players[i][22] = 0;
						tf2_players[i][18] = 0;
						tf2_players[i][21] = 0;
						new j;
						while (j < 8)
						{
							tf2_players[i][j] = -1;
							tf2_players[i][8][j] = -1;
							j++;
						}
					}
					case 10:
					{
						SDKHook(i, SDKHookType:1, OnZPSFireBullets);
						SDKHook(i, SDKHookType:12, OnZPSTraceAttack);
						SDKHook(i, SDKHookType:3, OnZPSTakeDamage);
					}
					default:
					{
					}
				}
			}
			if (!IsFakeClient(i))
			{
				QueryClientConVar(i, "cl_language", ClientConVar, i);
				new var3;
				if (gameme_plugin[0] == 4 || gameme_plugin[0] == 1 || gameme_plugin[0] == 2 || gameme_plugin[0] == 3)
				{
					QueryClientConVar(i, "cl_connectmethod", ClientConVar, i);
				}
			}
			new var4;
			if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1)
			{
				gameme_players[i][11] = 0;
				new j;
				while (j <= 65)
				{
					player_messages[j][i][255] = 1;
					strcopy(player_messages[j][i], 255, "");
					j++;
				}
			}
		}
		i++;
	}
	return void:0;
}

public gameMESettingsMenu(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	if (action == CookieMenuAction:1)
	{
		DisplayMenu(gameme_plugin[104], client, 0);
	}
	return 0;
}

public void:OnMapStart()
{
	get_server_mod();
	new i;
	while (i <= 65)
	{
		reset_player_data(i);
		gameme_players[i][0] = -1;
		gameme_players[i][10] = 0;
		i++;
	}
	new var1;
	if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1 || gameme_plugin[0] == 4 || gameme_plugin[0] == 2 || gameme_plugin[0] == 3 || gameme_plugin[0] == 7 || gameme_plugin[0] == 8 || gameme_plugin[0] == 5 || gameme_plugin[0] == 6 || gameme_plugin[0] == 9)
	{
		decl String:map_name[64];
		GetCurrentMap(map_name, 64);
		new max_teams_count = GetTeamCount();
		new team_index;
		while (team_index < max_teams_count)
		{
			decl String:team_name[32];
			GetTeamName(team_index, team_name, 32);
			if (strcmp(team_name, "", true))
			{
			}
			team_index++;
		}
	}
	new var2;
	if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1 || gameme_plugin[0] == 3 || gameme_plugin[0] == 4 || gameme_plugin[0] == 5 || gameme_plugin[0] == 6 || gameme_plugin[0] == 7)
	{
		find_player_team_slot(2);
		find_player_team_slot(3);
	}
	ClearArray(QueryCallbackArray);
	return void:0;
}

get_server_mod()
{
	if (!(strcmp(4364 + 4, "", true)))
	{
		new String:game_description[64];
		GetGameDescription(game_description, 64, true);
		if (StrContains(game_description, "Counter-Strike", false) != -1)
		{
			strcopy(4364 + 4, 32, "CSS");
			gameme_plugin[0] = 1;
		}
		if (StrContains(game_description, "Counter-Strike: Global Offensive", false) != -1)
		{
			strcopy(4364 + 4, 32, "CSGO");
			gameme_plugin[0] = 11;
		}
		if (StrContains(game_description, "Day of Defeat", false) != -1)
		{
			strcopy(4364 + 4, 32, "DODS");
			gameme_plugin[0] = 2;
		}
		if (StrContains(game_description, "Half-Life 2 Deathmatch", false) != -1)
		{
			strcopy(4364 + 4, 32, "HL2MP");
			gameme_plugin[0] = 3;
		}
		if (StrContains(game_description, "Team Fortress", false) != -1)
		{
			strcopy(4364 + 4, 32, "TF2");
			gameme_plugin[0] = 4;
		}
		if (StrContains(game_description, "Insurgency", false) != -1)
		{
			strcopy(4364 + 4, 32, "INSMOD");
			gameme_plugin[0] = 7;
		}
		if (StrContains(game_description, "L4D", false) != -1)
		{
			strcopy(4364 + 4, 32, "L4D");
			gameme_plugin[0] = 5;
		}
		if (StrContains(game_description, "Left 4 Dead 2", false) != -1)
		{
			strcopy(4364 + 4, 32, "L4DII");
			gameme_plugin[0] = 6;
		}
		if (StrContains(game_description, "Fortress Forever", false) != -1)
		{
			strcopy(4364 + 4, 32, "FF");
			gameme_plugin[0] = 8;
		}
		if (StrContains(game_description, "CSPromod", false) != -1)
		{
			strcopy(4364 + 4, 32, "CSP");
			gameme_plugin[0] = 9;
		}
		if (StrContains(game_description, "ZPS", false) != -1)
		{
			strcopy(4364 + 4, 32, "ZPS");
			gameme_plugin[0] = 10;
		}
		if (!(strcmp(4364 + 4, "", true)))
		{
			new String:game_folder[64];
			GetGameFolderName(game_folder, 64);
			if (StrContains(game_folder, "cstrike", false) != -1)
			{
				strcopy(4364 + 4, 32, "CSS");
				gameme_plugin[0] = 1;
			}
			if (StrContains(game_folder, "csgo", false) != -1)
			{
				strcopy(4364 + 4, 32, "CSGO");
				gameme_plugin[0] = 11;
			}
			if (StrContains(game_folder, "dod", false) != -1)
			{
				strcopy(4364 + 4, 32, "DODS");
				gameme_plugin[0] = 2;
			}
			if (StrContains(game_folder, "hl2mp", false) != -1)
			{
				strcopy(4364 + 4, 32, "HL2MP");
				gameme_plugin[0] = 3;
			}
			if (StrContains(game_folder, "tf", false) != -1)
			{
				strcopy(4364 + 4, 32, "TF2");
				gameme_plugin[0] = 4;
			}
			if (StrContains(game_folder, "insurgency", false) != -1)
			{
				strcopy(4364 + 4, 32, "INSMOD");
				gameme_plugin[0] = 7;
			}
			if (StrContains(game_folder, "left4dead", false) != -1)
			{
				strcopy(4364 + 4, 32, "L4D");
				gameme_plugin[0] = 5;
			}
			if (StrContains(game_folder, "left4dead2", false) != -1)
			{
				strcopy(4364 + 4, 32, "L4DII");
				gameme_plugin[0] = 6;
			}
			if (StrContains(game_folder, "FortressForever", false) != -1)
			{
				strcopy(4364 + 4, 32, "FF");
				gameme_plugin[0] = 8;
			}
			if (StrContains(game_folder, "cspromod", false) != -1)
			{
				strcopy(4364 + 4, 32, "CSP");
				gameme_plugin[0] = 9;
			}
			if (StrContains(game_folder, "zps", false) != -1)
			{
				strcopy(4364 + 4, 32, "ZPS");
				gameme_plugin[0] = 10;
			}
			if (strcmp(4364 + 4, "", true))
			{
			}
			else
			{
				LogToGame("gameME Game Detection: Failed (%s, %s)", game_description, game_folder);
			}
		}
		switch (gameme_plugin[0])
		{
			case 1:
			{
				HookEvent("weapon_fire", Event_CSSPlayerFire, EventHookMode:1);
				HookEvent("player_hurt", Event_CSSPlayerHurt, EventHookMode:1);
				HookEvent("player_death", Event_CSSPlayerDeath, EventHookMode:1);
				HookEvent("player_spawn", Event_CSSPlayerSpawn, EventHookMode:1);
				HookEvent("round_start", Event_CSSRoundStart, EventHookMode:1);
				HookEvent("round_end", Event_CSSRoundEnd, EventHookMode:1);
				HookEvent("round_mvp", Event_RoundMVP, EventHookMode:1);
				HookEvent("bomb_dropped", gameME_Event_PlyBombDropped, EventHookMode:0);
				HookEvent("bomb_pickup", gameME_Event_PlyBombPickup, EventHookMode:0);
				HookEvent("bomb_planted", gameME_Event_PlyBombPlanted, EventHookMode:0);
				HookEvent("bomb_defused", gameME_Event_PlyBombDefused, EventHookMode:0);
				HookEvent("hostage_killed", gameME_Event_PlyHostageKill, EventHookMode:0);
				HookEvent("hostage_rescued", gameME_Event_PlyHostageResc, EventHookMode:0);
			}
			case 2:
			{
				HookEvent("dod_stats_weapon_attack", Event_DODSWeaponAttack, EventHookMode:1);
				HookEvent("player_hurt", Event_DODSPlayerHurt, EventHookMode:1);
				HookEvent("player_death", Event_DODSPlayerDeath, EventHookMode:1);
				HookEvent("round_end", Event_DODSRoundEnd, EventHookMode:1);
			}
			case 3:
			{
				HookEvent("player_death", Event_HL2MPPlayerDeath, EventHookMode:1);
				HookEvent("player_spawn", Event_HL2MPPlayerSpawn, EventHookMode:1);
				HookEvent("round_end", Event_HL2MPRoundEnd, EventHookMode:2);
			}
			case 4:
			{
				HookEvent("player_death", Event_TF2PlayerDeath, EventHookMode:1);
				HookEvent("object_destroyed", Event_TF2ObjectDestroyedPre, EventHookMode:0);
				HookEvent("player_builtobject", Event_TF2PlayerBuiltObjectPre, EventHookMode:0);
				HookEvent("player_spawn", Event_TF2PlayerSpawn, EventHookMode:1);
				HookEvent("round_start", Event_TF2RoundStart, EventHookMode:1);
				HookEvent("round_end", Event_TF2RoundEnd, EventHookMode:1);
				HookEvent("object_removed", Event_TF2ObjectRemoved, EventHookMode:1);
				HookEvent("post_inventory_application", Event_TF2PostInvApp, EventHookMode:1);
				HookEvent("teamplay_win_panel", Event_TF2WinPanel, EventHookMode:1);
				HookEvent("arena_win_panel", Event_TF2WinPanel, EventHookMode:1);
				HookEvent("player_teleported", Event_TF2PlayerTeleported, EventHookMode:1);
				HookEvent("rocket_jump", Event_TF2RocketJump, EventHookMode:1);
				HookEvent("rocket_jump_landed", Event_TF2JumpLanded, EventHookMode:1);
				HookEvent("sticky_jump", Event_TF2StickyJump, EventHookMode:1);
				HookEvent("sticky_jump_landed", Event_TF2JumpLanded, EventHookMode:1);
				HookEvent("object_deflected", Event_TF2ObjectDeflected, EventHookMode:1);
				HookEvent("player_stealsandvich", Event_TF2StealSandvich, EventHookMode:1);
				HookEvent("player_stunned", Event_TF2Stunned, EventHookMode:1);
				HookEvent("player_escort_score", Event_TF2EscortScore, EventHookMode:1);
				HookEvent("deploy_buff_banner", Event_TF2DeployBuffBanner, EventHookMode:1);
				HookEvent("medic_defended", Event_TF2MedicDefended, EventHookMode:1);
				HookUserMessage(GetUserMessageId("PlayerJarated"), Event_TF2Jarated, false, MsgPostHook:-1);
				HookUserMessage(GetUserMessageId("PlayerShieldBlocked"), Event_TF2ShieldBlocked, false, MsgPostHook:-1);
				AddNormalSoundHook(Event_TF2SoundHook);
				tf2_data[6] = FindSendPropInfo("CTFPlayer", "m_bCarryingObject", 0, 0, 0);
			}
			case 5, 6:
			{
				HookEvent("weapon_fire", Event_L4DPlayerFire, EventHookMode:1);
				HookEvent("weapon_fire_on_empty", Event_L4DPlayerFire, EventHookMode:1);
				HookEvent("player_hurt", Event_L4DPlayerHurt, EventHookMode:1);
				HookEvent("infected_hurt", Event_L4DInfectedHurt, EventHookMode:1);
				HookEvent("player_death", Event_L4DPlayerDeath, EventHookMode:1);
				HookEvent("player_spawn", Event_L4DPlayerSpawn, EventHookMode:1);
				HookEvent("round_end_message", Event_L4DRoundEnd, EventHookMode:2);
				HookEvent("survivor_rescued", Event_L4DRescueSurvivor, EventHookMode:1);
				HookEvent("heal_success", Event_L4DHeal, EventHookMode:1);
				HookEvent("revive_success", Event_L4DRevive, EventHookMode:1);
				HookEvent("witch_harasser_set", Event_L4DStartleWitch, EventHookMode:1);
				HookEvent("lunge_pounce", Event_L4DPounce, EventHookMode:1);
				HookEvent("player_now_it", Event_L4DBoomered, EventHookMode:1);
				HookEvent("friendly_fire", Event_L4DFF, EventHookMode:1);
				HookEvent("witch_killed", Event_L4DWitchKilled, EventHookMode:1);
				HookEvent("award_earned", Event_L4DAward, EventHookMode:1);
				if (gameme_plugin[0] == 6)
				{
					HookEvent("defibrillator_used", Event_L4DDefib, EventHookMode:1);
					HookEvent("adrenaline_used", Event_L4DAdrenaline, EventHookMode:1);
					HookEvent("jockey_ride", Event_L4DJockeyRide, EventHookMode:1);
					HookEvent("charger_pummel_start", Event_L4DChargerPummelStart, EventHookMode:1);
					HookEvent("vomit_bomb_tank", Event_L4DVomitBombTank, EventHookMode:1);
					HookEvent("scavenge_match_finished", Event_L4DScavengeEnd, EventHookMode:1);
					HookEvent("versus_match_finished", Event_L4DVersusEnd, EventHookMode:1);
					HookEvent("charger_killed", Event_L4dChargerKilled, EventHookMode:1);
				}
			}
			case 7:
			{
				HookEvent("player_death", Event_INSMODPlayerDeath, EventHookMode:1);
				HookEvent("player_hurt", Event_INSMODPlayerHurt, EventHookMode:1);
				HookEvent("weapon_fire", Event_INSMODEventFired, EventHookMode:1);
				HookEvent("player_spawn", Event_INSMODPlayerSpawn, EventHookMode:1);
				HookEvent("player_pick_squad", Event_INSMODPlayerPickSquad, EventHookMode:1);
				HookEvent("round_end", Event_INSMODRoundEnd, EventHookMode:1);
			}
			case 9:
			{
				HookEvent("round_start", Event_CSPRoundStart, EventHookMode:1);
				HookEvent("round_end", Event_CSPRoundEnd, EventHookMode:1);
			}
			case 10:
			{
				HookEvent("player_death", Event_ZPSPlayerDeath, EventHookMode:1);
				HookEvent("player_spawn", Event_ZPSPlayerSpawn, EventHookMode:1);
				HookEvent("round_end", Event_ZPSRoundEnd, EventHookMode:2);
			}
			case 11:
			{
				HookEvent("weapon_fire", Event_CSGOPlayerFire, EventHookMode:1);
				HookEvent("weapon_fire_on_empty", Event_CSGOPlayerFire, EventHookMode:1);
				HookEvent("player_hurt", Event_CSGOPlayerHurt, EventHookMode:1);
				HookEvent("player_death", Event_CSGOPlayerDeath, EventHookMode:1);
				HookEvent("player_spawn", Event_CSGOPlayerSpawn, EventHookMode:1);
				HookEvent("round_start", Event_CSGORoundStart, EventHookMode:1);
				HookEvent("round_end", Event_CSGORoundEnd, EventHookMode:1);
				HookEvent("round_announce_warmup", Event_CSGOAnnounceWarmup, EventHookMode:1);
				HookEvent("round_announce_match_start", Event_CSGOAnnounceMatchStart, EventHookMode:1);
				HookEvent("gg_player_levelup", Event_CSGOGGLevelUp, EventHookMode:1);
				HookEvent("ggtr_player_levelup", Event_CSGOGGLevelUp, EventHookMode:1);
				HookEvent("ggprogressive_player_levelup", Event_CSGOGGLevelUp, EventHookMode:1);
				HookEvent("gg_final_weapon_achieved", Event_CSGOGGWin, EventHookMode:1);
				HookEvent("gg_leader", Event_CSGOGGLeader, EventHookMode:1);
				HookEvent("round_mvp", Event_RoundMVP, EventHookMode:1);
				HookEvent("bomb_dropped", gameME_Event_PlyBombDropped, EventHookMode:0);
				HookEvent("player_given_c4", gameME_Event_PlyBombPickup, EventHookMode:0);
				HookEvent("bomb_planted", gameME_Event_PlyBombPlanted, EventHookMode:0);
				HookEvent("bomb_defused", gameME_Event_PlyBombDefused, EventHookMode:0);
				HookEvent("hostage_killed", gameME_Event_PlyHostageKill, EventHookMode:0);
				HookEvent("hostage_rescued", gameME_Event_PlyHostageResc, EventHookMode:0);
			}
			default:
			{
			}
		}
		HookEvent("player_death", gameME_Event_PlyDeath, EventHookMode:0);
		new var1;
		if (gameme_plugin[0] == 5 || gameme_plugin[0] == 6 || gameme_plugin[0] == 7)
		{
			CreateTimer(180.0, flush_weapon_logs, any:0, 1);
		}
		if (gameme_plugin[109])
		{
			new enable_log_locations_cvar = GetConVarInt(gameme_plugin[109]);
			if (enable_log_locations_cvar == 1)
			{
				gameme_plugin[146] = 1;
				LogToGame("gameME location logging activated");
			}
			else
			{
				if (!enable_log_locations_cvar)
				{
					gameme_plugin[146] = 0;
					LogToGame("gameME location logging deactivated");
				}
			}
		}
		else
		{
			gameme_plugin[146] = 0;
		}
		LogToGame("gameME Game Detection: %s [%s]", game_description, 4364 + 4);
	}
	return 0;
}

public void:OnClientPutInServer(client)
{
	if (0 < client)
	{
		if (gameme_plugin[152])
		{
			switch (gameme_plugin[0])
			{
				case 3:
				{
					SDKHook(client, SDKHookType:1, OnHL2MPFireBullets);
					SDKHook(client, SDKHookType:12, OnHL2MPTraceAttack);
					SDKHook(client, SDKHookType:3, OnHL2MPTakeDamage);
				}
				case 4:
				{
					SDKHook(client, SDKHookType:3, OnTF2TakeDamage_Post);
					SDKHook(client, SDKHookType:2, OnTF2TakeDamage);
					tf2_players[client][16] = 1;
					tf2_players[client][22] = 0;
					tf2_players[client][18] = 0;
					tf2_players[client][21] = 0;
					new i;
					while (i < 8)
					{
						tf2_players[client][i] = -1;
						tf2_players[client][8][i] = -1;
						i++;
					}
				}
				case 10:
				{
					SDKHook(client, SDKHookType:1, OnZPSFireBullets);
					SDKHook(client, SDKHookType:12, OnZPSTraceAttack);
					SDKHook(client, SDKHookType:3, OnZPSTakeDamage);
				}
				default:
				{
				}
			}
		}
		reset_player_data(client);
		gameme_players[client][0] = -1;
		gameme_players[client][10] = 0;
		if (!IsFakeClient(client))
		{
			QueryClientConVar(client, "cl_language", ClientConVar, client);
			new var1;
			if (gameme_plugin[0] == 4 || gameme_plugin[0] == 1 || gameme_plugin[0] == 2 || gameme_plugin[0] == 3)
			{
				QueryClientConVar(client, "cl_connectmethod", ClientConVar, client);
			}
		}
		new var2;
		if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1)
		{
			if (gameme_plugin[151] == 1)
			{
				gameme_players[client][11] = 0;
				new j;
				while (j <= 65)
				{
					player_messages[j][client][255] = 1;
					strcopy(player_messages[j][client], 255, "");
					j++;
				}
			}
		}
	}
	return void:0;
}

public ClientConVar(QueryCookie:cookie, client, ConVarQueryResult:result, String:cvarName[], String:cvarValue[])
{
	if (IsClientConnected(client))
	{
		log_player_settings(client, "setup", cvarName, cvarValue);
	}
	return 0;
}

start_gameme_live()
{
	new var1;
	if (gameme_plugin[0] == 1 || gameme_plugin[0] == 11)
	{
		if (gameme_plugin[149] == 1)
		{
			if (GetExtensionFileStatus("socket.ext", "", 0) == 1)
			{
				LogToGame("Extension Socket is available");
				if (gameme_plugin[0] == 1)
				{
					css_data[0] = FindSendPropInfo("CCSPlayer", "m_iAccount", 0, 0, 0);
				}
				gameme_plugin[157] = SocketCreate(SocketType:2, OnSocketError);
				CreateTimer(gameme_plugin[150], CollectData, any:0, 1);
			}
			LogToGame("gameME Live! not activated, Socket extension not available");
		}
	}
	else
	{
		LogToGame("gameME Live! not enabled, not supported yet");
		gameme_plugin[149] = 0;
	}
	return 0;
}

get_weapon_index(String:weapon_list[][], weapon_list_count, String:weapon_name[])
{
	new loop_break;
	new index;
	while (loop_break && index < weapon_list_count)
	{
		if (strcmp(weapon_name, weapon_list[index], true))
		{
			index++;
		}
		else
		{
			loop_break++;
		}
	}
	if (loop_break)
	{
		return index;
	}
	return -1;
}

init_tf2_weapon_trie()
{
	tf2_data[0] = CreateTrie();
	new i;
	while (i < 28)
	{
		SetTrieValue(tf2_data[0], tf2_weapon_list[i], i, true);
		i++;
	}
	new index;
	if (GetTrieValue(tf2_data[0], "ball", index))
	{
		SetTrieValue(tf2_data[0], "tf_projectile_stun_ball", index, true);
		tf2_data[3] = index;
	}
	return 0;
}

get_tf2_weapon_index(String:weapon_name[], client, weapon)
{
	new weapon_index = -1;
	new bool:unlockable_weapon;
	new reflect_index = -1;
	if (strlen(weapon_name) < 15)
	{
		return -1;
	}
	if (GetTrieValue(tf2_data[0], weapon_name, weapon_index))
	{
		if (weapon_index & 1073741824)
		{
			weapon_index &= -1073741825;
			unlockable_weapon = true;
		}
		new var1;
		if (weapon_name[0] == 'p' && weapon > -1)
		{
			if (GetEntProp(weapon, PropType:0, "m_iDeflected", 4, 0) == client)
			{
				switch (weapon_name[3])
				{
					case 97:
					{
						reflect_index = get_tf2_weapon_index("deflect_arrow", 0, -1);
					}
					case 102:
					{
						reflect_index = get_tf2_weapon_index("deflect_flare", 0, -1);
					}
					case 112:
					{
						if (weapon_name[4])
						{
						}
						else
						{
							reflect_index = get_tf2_weapon_index("deflect_promode", 0, -1);
						}
					}
					case 114:
					{
						reflect_index = get_tf2_weapon_index("deflect_rocket", 0, -1);
					}
					default:
					{
					}
				}
			}
		}
		if (reflect_index > -1)
		{
			return reflect_index;
		}
		new var2;
		if (unlockable_weapon && client > 0)
		{
			new slot;
			if (tf2_players[client][21] == 4)
			{
				slot = 1;
			}
			new item_index = tf2_players[client][slot];
			switch (item_index)
			{
				case 36, 41, 45, 61, 127, 130:
				{
					weapon_index++;
				}
				default:
				{
				}
			}
		}
	}
	return weapon_index;
}

reset_player_data(player_index)
{
	new i;
	while (i < 52)
	{
		player_weapons[player_index][i][0] = 0;
		player_weapons[player_index][i][1] = 0;
		player_weapons[player_index][i][2] = 0;
		player_weapons[player_index][i][3] = 0;
		player_weapons[player_index][i][4] = 0;
		player_weapons[player_index][i][5] = 0;
		player_weapons[player_index][i][6] = 0;
		player_weapons[player_index][i][8] = 0;
		player_weapons[player_index][i][9] = 0;
		player_weapons[player_index][i][10] = 0;
		player_weapons[player_index][i][11] = 0;
		player_weapons[player_index][i][12] = 0;
		player_weapons[player_index][i][13] = 0;
		player_weapons[player_index][i][14] = 0;
		player_weapons[player_index][i][15] = 0;
		i++;
	}
	if (gameme_plugin[147] == 1)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			player_damage[player_index][i][0] = 0;
			player_damage[player_index][i][1] = 0;
			player_damage[player_index][i][2] = 0;
			player_damage[player_index][i][3] = 0;
			player_damage[player_index][i][4] = 0;
			player_damage[player_index][i][5] = 0;
			player_damage[player_index][i][6] = 0;
			player_damage[player_index][i][7] = 0;
			i++;
		}
	}
	if (gameme_plugin[149] == 1)
	{
		gameme_players[player_index][1] = 0;
		gameme_players[player_index][2] = 0;
		gameme_players[player_index][3] = 0;
		gameme_players[player_index][4] = 0;
		gameme_players[player_index][5] = 0;
		gameme_players[player_index][6] = 0;
		gameme_players[player_index][7] = 0;
		gameme_players[player_index][8] = 0;
	}
	return 0;
}

dump_player_data(player_index)
{
	if (IsClientInGame(player_index))
	{
		new is_logged;
		new i;
		while (i < 52)
		{
			if (0 < player_weapons[player_index][i][0])
			{
				switch (gameme_plugin[0])
				{
					case 1:
					{
						LogToGame("\"%L\" triggered \"weaponstats\" (weapon \"%s\") (shots \"%d\") (hits \"%d\") (kills \"%d\") (headshots \"%d\") (tks \"%d\") (damage \"%d\") (deaths \"%d\")", player_index, css_weapon_list[i], player_weapons[player_index][i], player_weapons[player_index][i][1], player_weapons[player_index][i][2], player_weapons[player_index][i][3], player_weapons[player_index][i][4], player_weapons[player_index][i][5], player_weapons[player_index][i][6]);
						if (0 < player_weapons[player_index][i][1])
						{
							LogToGame("\"%L\" triggered \"weaponstats2\" (weapon \"%s\") (head \"%d\") (chest \"%d\") (stomach \"%d\") (leftarm \"%d\") (rightarm \"%d\") (leftleg \"%d\") (rightleg \"%d\")", player_index, css_weapon_list[i], player_weapons[player_index][i][9], player_weapons[player_index][i][10], player_weapons[player_index][i][11], player_weapons[player_index][i][12], player_weapons[player_index][i][13], player_weapons[player_index][i][14], player_weapons[player_index][i][15]);
						}
					}
					case 2:
					{
						LogToGame("\"%L\" triggered \"weaponstats\" (weapon \"%s\") (shots \"%d\") (hits \"%d\") (kills \"%d\") (headshots \"%d\") (tks \"%d\") (damage \"%d\") (deaths \"%d\")", player_index, dods_weapon_list[i], player_weapons[player_index][i], player_weapons[player_index][i][1], player_weapons[player_index][i][2], player_weapons[player_index][i][3], player_weapons[player_index][i][4], player_weapons[player_index][i][5], player_weapons[player_index][i][6]);
						if (0 < player_weapons[player_index][i][1])
						{
							LogToGame("\"%L\" triggered \"weaponstats2\" (weapon \"%s\") (head \"%d\") (chest \"%d\") (stomach \"%d\") (leftarm \"%d\") (rightarm \"%d\") (leftleg \"%d\") (rightleg \"%d\")", player_index, dods_weapon_list[i], player_weapons[player_index][i][9], player_weapons[player_index][i][10], player_weapons[player_index][i][11], player_weapons[player_index][i][12], player_weapons[player_index][i][13], player_weapons[player_index][i][14], player_weapons[player_index][i][15]);
						}
					}
					case 3:
					{
						LogToGame("\"%L\" triggered \"weaponstats\" (weapon \"%s\") (shots \"%d\") (hits \"%d\") (kills \"%d\") (headshots \"%d\") (tks \"%d\") (damage \"%d\") (deaths \"%d\")", player_index, hl2mp_weapon_list[i], player_weapons[player_index][i], player_weapons[player_index][i][1], player_weapons[player_index][i][2], player_weapons[player_index][i][3], player_weapons[player_index][i][4], player_weapons[player_index][i][5], player_weapons[player_index][i][6]);
						if (0 < player_weapons[player_index][i][1])
						{
							LogToGame("\"%L\" triggered \"weaponstats2\" (weapon \"%s\") (head \"%d\") (chest \"%d\") (stomach \"%d\") (leftarm \"%d\") (rightarm \"%d\") (leftleg \"%d\") (rightleg \"%d\")", player_index, hl2mp_weapon_list[i], player_weapons[player_index][i][9], player_weapons[player_index][i][10], player_weapons[player_index][i][11], player_weapons[player_index][i][12], player_weapons[player_index][i][13], player_weapons[player_index][i][14], player_weapons[player_index][i][15]);
						}
					}
					case 4:
					{
						LogToGame("\"%L\" triggered \"weaponstats\" (weapon \"%s\") (shots \"%d\") (hits \"%d\") (kills \"%d\") (headshots \"%d\") (tks \"%d\") (damage \"%d\") (deaths \"%d\")", player_index, tf2_weapon_list[i], player_weapons[player_index][i], player_weapons[player_index][i][1], player_weapons[player_index][i][2], player_weapons[player_index][i][3], player_weapons[player_index][i][4], player_weapons[player_index][i][5], player_weapons[player_index][i][6]);
					}
					case 5, 6:
					{
						LogToGame("\"%L\" triggered \"weaponstats\" (weapon \"%s\") (shots \"%d\") (hits \"%d\") (kills \"%d\") (headshots \"%d\") (tks \"%d\") (damage \"%d\") (deaths \"%d\")", player_index, l4d_weapon_list[i], player_weapons[player_index][i], player_weapons[player_index][i][1], player_weapons[player_index][i][2], player_weapons[player_index][i][3], player_weapons[player_index][i][4], player_weapons[player_index][i][5], player_weapons[player_index][i][6]);
						if (0 < player_weapons[player_index][i][1])
						{
							LogToGame("\"%L\" triggered \"weaponstats2\" (weapon \"%s\") (head \"%d\") (chest \"%d\") (stomach \"%d\") (leftarm \"%d\") (rightarm \"%d\") (leftleg \"%d\") (rightleg \"%d\")", player_index, l4d_weapon_list[i], player_weapons[player_index][i][9], player_weapons[player_index][i][10], player_weapons[player_index][i][11], player_weapons[player_index][i][12], player_weapons[player_index][i][13], player_weapons[player_index][i][14], player_weapons[player_index][i][15]);
						}
					}
					case 7:
					{
						LogToGame("\"%L\" triggered \"weaponstats\" (weapon \"%s\") (shots \"%d\") (hits \"%d\") (kills \"%d\") (headshots \"%d\") (tks \"%d\") (damage \"%d\") (deaths \"%d\")", player_index, insmod_weapon_list[i], player_weapons[player_index][i], player_weapons[player_index][i][1], player_weapons[player_index][i][2], player_weapons[player_index][i][3], player_weapons[player_index][i][4], player_weapons[player_index][i][5], player_weapons[player_index][i][6]);
						if (0 < player_weapons[player_index][i][1])
						{
							LogToGame("\"%L\" triggered \"weaponstats2\" (weapon \"%s\") (head \"%d\") (chest \"%d\") (stomach \"%d\") (leftarm \"%d\") (rightarm \"%d\") (leftleg \"%d\") (rightleg \"%d\")", player_index, insmod_weapon_list[i], player_weapons[player_index][i][9], player_weapons[player_index][i][10], player_weapons[player_index][i][11], player_weapons[player_index][i][12], player_weapons[player_index][i][13], player_weapons[player_index][i][14], player_weapons[player_index][i][15]);
						}
					}
					case 10:
					{
						LogToGame("\"%L\" triggered \"weaponstats\" (weapon \"%s\") (shots \"%d\") (hits \"%d\") (kills \"%d\") (headshots \"%d\") (tks \"%d\") (damage \"%d\") (deaths \"%d\")", player_index, zps_weapon_list[i], player_weapons[player_index][i], player_weapons[player_index][i][1], player_weapons[player_index][i][2], player_weapons[player_index][i][3], player_weapons[player_index][i][4], player_weapons[player_index][i][5], player_weapons[player_index][i][6]);
						if (0 < player_weapons[player_index][i][1])
						{
							LogToGame("\"%L\" triggered \"weaponstats2\" (weapon \"%s\") (head \"%d\") (chest \"%d\") (stomach \"%d\") (leftarm \"%d\") (rightarm \"%d\") (leftleg \"%d\") (rightleg \"%d\")", player_index, zps_weapon_list[i], player_weapons[player_index][i][9], player_weapons[player_index][i][10], player_weapons[player_index][i][11], player_weapons[player_index][i][12], player_weapons[player_index][i][13], player_weapons[player_index][i][14], player_weapons[player_index][i][15]);
						}
					}
					case 11:
					{
						LogToGame("\"%L\" triggered \"weaponstats\" (weapon \"%s\") (shots \"%d\") (hits \"%d\") (kills \"%d\") (headshots \"%d\") (tks \"%d\") (damage \"%d\") (deaths \"%d\")", player_index, csgo_weapon_list[i], player_weapons[player_index][i], player_weapons[player_index][i][1], player_weapons[player_index][i][2], player_weapons[player_index][i][3], player_weapons[player_index][i][4], player_weapons[player_index][i][5], player_weapons[player_index][i][6]);
						if (0 < player_weapons[player_index][i][1])
						{
							LogToGame("\"%L\" triggered \"weaponstats2\" (weapon \"%s\") (head \"%d\") (chest \"%d\") (stomach \"%d\") (leftarm \"%d\") (rightarm \"%d\") (leftleg \"%d\") (rightleg \"%d\")", player_index, csgo_weapon_list[i], player_weapons[player_index][i][9], player_weapons[player_index][i][10], player_weapons[player_index][i][11], player_weapons[player_index][i][12], player_weapons[player_index][i][13], player_weapons[player_index][i][14], player_weapons[player_index][i][15]);
						}
					}
					default:
					{
					}
				}
				is_logged++;
			}
			i++;
		}
		if (0 < is_logged)
		{
			reset_player_data(player_index);
		}
	}
	return 0;
}

public Action:flush_weapon_logs(Handle:timer, any:index)
{
	new i = 1;
	while (i <= MaxClients)
	{
		dump_player_data(i);
		i++;
	}
	return Action:0;
}

public Action:spectator_player_timer(Handle:timer, any:caller)
{
	new var1;
	if ((gameme_plugin[0] == 11 || gameme_plugin[0] == 1) && IsValidEntity(caller) && (!IsFakeClient(caller) && (observer_mode == 4 || observer_mode == 5)) && (target > 0 && target <= MaxClients && IsClientInGame(target)) && (player_messages[caller][target][255] == 1 || gameme_players[caller][13]))
	{
		player_messages[i][target][255] = 0;
		i++;
		while (i <= 65)
		{
			player_messages[i][target][255] = 0;
			i++;
		}
	}
	QueryIntGameMEStats("spectatorinfo", target, gameMEStatsIntCallback:249, 1001, 0);
	if (gameme_players[caller][13] != target)
	{
		gameme_players[caller][12] = 0;
	}
	if (strcmp(player_messages[caller][target], "", true))
	{
		new var7;
		if (caller > any:0 && caller <= MaxClients && !IsFakeClient(caller) && IsClientInGame(caller))
		{
			if (GetGameTime() - gameme_players[caller][12] > 5)
			{
				new Handle:message_handle = StartMessageOne("KeyHintText", caller, 0);
				if (message_handle)
				{
					if (gameme_plugin[159] == 1)
					{
						PbAddString(message_handle, "hints", player_messages[caller][target]);
					}
					else
					{
						BfWriteByte(message_handle, 1);
						BfWriteString(message_handle, player_messages[caller][target]);
					}
					EndMessage();
				}
				gameme_players[caller][12] = GetGameTime();
			}
		}
	}
	else
	{
		if (gameme_players[caller][13] != target)
		{
			if (gameme_plugin[0] != 11)
			{
				new Handle:message_handle = StartMessageOne("KeyHintText", caller, 0);
				if (message_handle)
				{
					if (gameme_plugin[159] == 1)
					{
						PbAddString(message_handle, "hints", "");
					}
					else
					{
						BfWriteByte(message_handle, 1);
						BfWriteString(message_handle, "");
					}
					EndMessage();
				}
			}
			gameme_players[caller][12] = GetGameTime();
		}
	}
	gameme_players[caller][13] = target;
	return Action:0;
}

public QuerygameMEStatsIntCallback(query_command, query_payload, query_caller[66], query_target[66], String:query_message_prefix[], String:query_message[])
{
	new var1;
	if (query_caller[0] > 0 && query_command == 1001)
	{
		new var2;
		if (query_payload == 1001 && query_target[0] > 0)
		{
			new i;
			while (i <= 65)
			{
				if (query_caller[i] > -1)
				{
					strcopy(player_messages[query_caller[i]][query_target[0]], 255, query_message);
					ReplaceString(player_messages[query_caller[i]][query_target[0]], 255, "\n", "\n", true);
					gameme_players[query_caller[i]][12] = 0;
				}
				i++;
			}
		}
	}
	return 0;
}

public OnSocketError(Handle:socket, errorType, errorNum, any:arg)
{
	LogError("socket error %d (errno %d)", errorType, errorNum);
	CloseHandle(socket);
	gameme_plugin[157] = SocketCreate(SocketType:2, OnSocketError);
	return 0;
}

public Action:CollectData(Handle:timer, any:index)
{
	new var1;
	if (gameme_plugin[149] == 1 && gameme_plugin[157])
	{
		new String:network_packet[1500];
		new i = 1;
		while (i <= MaxClients)
		{
			new player_index = i;
			if (IsClientInGame(player_index))
			{
				if (gameme_players[player_index][8] == 1)
				{
					new Float:player_origin_float[3] = 0.0;
					GetClientAbsOrigin(player_index, player_origin_float);
					new player_origin[3];
					player_origin[0] = RoundFloat(player_origin_float[0]);
					player_origin[1] = RoundFloat(player_origin_float[1]);
					player_origin[2] = RoundFloat(player_origin_float[2]);
					new Float:player_angles_float[3] = 0.0;
					GetClientAbsAngles(player_index, player_angles_float);
					new player_angle = RoundFloat(player_angles_float[1]);
					new var2;
					if (gameme_players[player_index][3] == player_origin[0] && gameme_players[player_index][4] == player_origin[1] && gameme_players[player_index][5] == player_origin[2] && gameme_players[player_index][6] == player_angle)
					{
						gameme_players[player_index][3] = player_origin[0];
						gameme_players[player_index][4] = player_origin[1];
						gameme_players[player_index][5] = player_origin[2];
						gameme_players[player_index][6] = player_angle;
						decl String:send_message[128];
						Format(send_message, 128, "��R�%d�%d�%d�%d�%d�%d�", 4364 + 632, GetClientUserId(player_index), gameme_players[player_index][3], gameme_players[player_index][4], gameme_players[player_index][5], gameme_players[player_index][6]);
						new send_message_len = strlen(send_message);
						new network_packet_len = strlen(network_packet);
						if (send_message_len + network_packet_len <= 1500)
						{
							strcopy(network_packet[network_packet_len], 1500, send_message);
						}
						else
						{
							if (strcmp(network_packet, "", true))
							{
								SocketSendTo(gameme_plugin[157], network_packet, strlen(network_packet), 4364 + 452, gameme_plugin[145]);
								network_packet[0] = MissingTAG:0;
								if (strcmp(send_message, "", true))
								{
									strcopy(network_packet[0], 1500, send_message);
								}
							}
						}
					}
					new health = GetClientHealth(player_index);
					new armor = GetClientArmor(player_index);
					decl String:player_weapon[32];
					GetClientWeapon(player_index, player_weapon, 32);
					new weapon_index;
					if (gameme_plugin[0] == 1)
					{
						weapon_index = get_weapon_index(css_weapon_list, 28, player_weapon[1]);
					}
					else
					{
						if (gameme_plugin[0] == 11)
						{
							weapon_index = get_weapon_index(csgo_weapon_list, 52, player_weapon[1]);
						}
						weapon_index = -1;
					}
					new money;
					if (gameme_plugin[0] == 1)
					{
						if (css_data[0] != -1)
						{
							money = GetEntData(player_index, css_data[0], 4);
						}
					}
					else
					{
						if (gameme_plugin[0] == 11)
						{
							money = 0;
						}
						money = 0;
					}
					new var4;
					if (gameme_players[player_index][2] == health && gameme_players[player_index][1] == armor && gameme_players[player_index][7] == money && (weapon_index > -1 && gameme_players[player_index][9] != weapon_index))
					{
						gameme_players[player_index][2] = health;
						gameme_players[player_index][1] = armor;
						gameme_players[player_index][7] = money;
						gameme_players[player_index][9] = weapon_index;
						new String:weapon_name[32];
						if (gameme_players[player_index][9] > -1)
						{
							if (gameme_plugin[0] == 1)
							{
								Format(weapon_name, 32, css_weapon_list[gameme_players[player_index][9]]);
							}
							if (gameme_plugin[0] == 11)
							{
								Format(weapon_name, 32, csgo_weapon_list[gameme_players[player_index][9]]);
							}
						}
						decl String:send_message[128];
						Format(send_message, 128, "��S�%d�%d�%d�%d�%s�%d�", 4364 + 632, GetClientUserId(player_index), gameme_players[player_index][2], gameme_players[player_index][1], weapon_name, gameme_players[player_index][7]);
						new send_message_len = strlen(send_message);
						new network_packet_len = strlen(network_packet);
						if (send_message_len + network_packet_len <= 1500)
						{
							strcopy(network_packet[network_packet_len], 1500, send_message);
						}
						else
						{
							if (strcmp(network_packet, "", true))
							{
								SocketSendTo(gameme_plugin[157], network_packet, strlen(network_packet), 4364 + 452, gameme_plugin[145]);
								network_packet[0] = MissingTAG:0;
								if (strcmp(send_message, "", true))
								{
									strcopy(network_packet[0], 1500, send_message);
								}
							}
						}
					}
				}
			}
			i++;
		}
		if (strcmp(network_packet, "", true))
		{
			SocketSendTo(gameme_plugin[157], network_packet, strlen(network_packet), 4364 + 452, gameme_plugin[145]);
		}
	}
	return Action:0;
}

public PanelDamageHandler(Handle:menu, MenuAction:action, param1, param2)
{
	return 0;
}

public build_damage_panel(player_index)
{
	new var2;
	if (gameme_plugin[147] && (!IsClientInGame(player_index) || IsFakeClient(player_index)))
	{
		return 0;
	}
	new max_clients = GetMaxClients();
	new String:attacked[8][128] = " ";
	new attacked_index;
	new String:wounded[8][128] = " ";
	new wounded_index;
	new String:killed[8][128] = " ";
	new killed_index;
	new String:killer[8][128] = " ";
	new killer_index;
	new i = 1;
	while (i <= max_clients)
	{
		if (i == player_index)
		{
			new j = 1;
			while (j <= max_clients)
			{
				new wounded_damage;
				new wounded_hits;
				new is_kill;
				if (0 < player_damage[i][j][0])
				{
					wounded_hits = player_damage[i][j][0];
					wounded_damage = player_damage[i][j][3];
					if (0 < player_damage[i][j][1])
					{
						is_kill++;
					}
				}
				if (0 < wounded_hits)
				{
					if (IsClientConnected(j))
					{
						if (is_kill)
						{
							decl String:victim_name[32];
							GetClientName(j, victim_name, 32);
							if (killed_index < 8)
							{
								if (wounded_hits == 1)
								{
									Format(killed[killed_index], 128, "  %s - %d %T, %d %T", victim_name, wounded_damage, "DamagePanel_Dmg", player_index, wounded_hits, "DamagePanel_Hit", player_index);
								}
								else
								{
									Format(killed[killed_index], 128, "  %s - %d %T, %d %T", victim_name, wounded_damage, "DamagePanel_Dmg", player_index, wounded_hits, "DamagePanel_Hits", player_index);
								}
								killed_index++;
							}
						}
						decl String:victim_name[64];
						GetClientName(j, victim_name, 64);
						if (wounded_index < 8)
						{
							if (wounded_hits == 1)
							{
								Format(wounded[wounded_index], 128, "  %s - %d %T, %d Hit", victim_name, wounded_damage, "DamagePanel_Dmg", player_index, wounded_hits, "DamagePanel_Hit", player_index);
							}
							else
							{
								Format(wounded[wounded_index], 128, "  %s - %d %T, %d Hits", victim_name, wounded_damage, "DamagePanel_Dmg", player_index, wounded_hits, "DamagePanel_Hits", player_index);
							}
							wounded_index++;
						}
					}
				}
				j++;
			}
		}
		else
		{
			new j = 1;
			while (j <= max_clients)
			{
				if (player_index == j)
				{
					new attacked_damage;
					new attacked_hits;
					new is_killer;
					new killer_hpleft;
					new killer_weapon;
					if (0 < player_damage[i][j][0])
					{
						attacked_hits = player_damage[i][j][0];
						attacked_damage = player_damage[i][j][3];
						if (0 < player_damage[i][j][4])
						{
							is_killer++;
							killer_hpleft = player_damage[i][j][5];
							killer_weapon = player_damage[i][j][7];
							player_damage[i][j][4] = 0;
							player_damage[i][j][5] = 0;
							player_damage[i][j][7] = -1;
						}
					}
					if (0 < attacked_hits)
					{
						if (IsClientConnected(i))
						{
							if (is_killer)
							{
								decl String:killer_name[64];
								GetClientName(i, killer_name, 64);
								if (killer_index < 8)
								{
									if (gameme_plugin[0] == 11)
									{
										if (attacked_hits == 1)
										{
											Format(killer[killer_index], 128, "  %s - %d %T, %d %T, %s", killer_name, killer_hpleft, "DamagePanel_Hp", player_index, attacked_damage, "DamagePanel_Dmg", player_index, csgo_weapon_list[killer_weapon]);
										}
										else
										{
											Format(killer[killer_index], 128, "  %s - %d %T, %d %T, %s", killer_name, killer_hpleft, "DamagePanel_Hp", player_index, attacked_damage, "DamagePanel_Dmg", player_index, csgo_weapon_list[killer_weapon]);
										}
									}
									else
									{
										if (gameme_plugin[0] == 1)
										{
											if (attacked_hits == 1)
											{
												Format(killer[killer_index], 128, "  %s - %d %T, %d %T, %s", killer_name, killer_hpleft, "DamagePanel_Hp", player_index, attacked_damage, "DamagePanel_Dmg", player_index, css_weapon_list[killer_weapon]);
											}
											else
											{
												Format(killer[killer_index], 128, "  %s - %d %T, %d %T, %s", killer_name, killer_hpleft, "DamagePanel_Hp", player_index, attacked_damage, "DamagePanel_Dmg", player_index, css_weapon_list[killer_weapon]);
											}
										}
										if (gameme_plugin[0] == 2)
										{
											if (attacked_hits == 1)
											{
												Format(killer[killer_index], 128, "  %s - %d %T, %d %T, %s", killer_name, killer_hpleft, "DamagePanel_Hp", player_index, attacked_damage, "DamagePanel_Dmg", player_index, dods_weapon_list[killer_weapon]);
											}
											Format(killer[killer_index], 128, "  %s - %d %T, %d %T, %s", killer_name, killer_hpleft, "DamagePanel_Hp", player_index, attacked_damage, "DamagePanel_Dmg", player_index, dods_weapon_list[killer_weapon]);
										}
									}
									killer_index++;
								}
							}
							decl String:attacker_name[64];
							GetClientName(i, attacker_name, 64);
							if (attacked_index < 8)
							{
								if (attacked_hits == 1)
								{
									Format(attacked[attacked_index], 128, "  %s - %d %T, %d %T", attacker_name, attacked_damage, "DamagePanel_Dmg", player_index, attacked_hits, "DamagePanel_Hit", player_index);
								}
								else
								{
									Format(attacked[attacked_index], 128, "  %s - %d %T, %d %T", attacker_name, attacked_damage, "DamagePanel_Dmg", player_index, attacked_hits, "DamagePanel_Hits", player_index);
								}
								attacked_index++;
							}
						}
					}
				}
				j++;
			}
		}
		i++;
	}
	new var3;
	if (attacked_index > 0 || wounded_index > 0 || killed_index > 0 || killer_index > 0)
	{
		new Handle:panel = CreatePanel(Handle:0);
		SetPanelKeys(panel, 1023);
		new is_attacked;
		new i;
		while (i < 8)
		{
			if (strcmp(attacked[i], "", true))
			{
				is_attacked++;
				if (is_attacked == 1)
				{
					decl String:attackers_caption[32];
					Format(attackers_caption, 32, "%T", "DamagePanel_Attackers", player_index);
					DrawPanelItem(panel, attackers_caption, 0);
				}
				DrawPanelText(panel, attacked[i]);
				i++;
			}
			new is_killed;
			new i;
			while (i < 8)
			{
				if (strcmp(killed[i], "", true))
				{
					is_killed++;
					if (is_killed == 1)
					{
						decl String:killed_caption[32];
						Format(killed_caption, 32, "%T", "DamagePanel_Killed", player_index);
						DrawPanelItem(panel, killed_caption, 0);
					}
					DrawPanelText(panel, killed[i]);
					i++;
				}
				new is_wounded;
				new i;
				while (i < 8)
				{
					if (strcmp(wounded[i], "", true))
					{
						is_wounded++;
						if (is_wounded == 1)
						{
							decl String:wounded_caption[32];
							Format(wounded_caption, 32, "%T", "DamagePanel_Wounded", player_index);
							DrawPanelItem(panel, wounded_caption, 0);
						}
						DrawPanelText(panel, wounded[i]);
						i++;
					}
					new is_killer;
					new i;
					while (i < 8)
					{
						if (strcmp(killer[i], "", true))
						{
							is_killer++;
							if (is_killer == 1)
							{
								decl String:killer_caption[32];
								Format(killer_caption, 32, "%T", "DamagePanel_Killer", player_index);
								DrawPanelItem(panel, killer_caption, 0);
							}
							DrawPanelText(panel, killer[i]);
							i++;
						}
						SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
						CloseHandle(panel);
					}
					SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
					CloseHandle(panel);
				}
				new is_killer;
				new i;
				while (i < 8)
				{
					if (strcmp(killer[i], "", true))
					{
						is_killer++;
						if (is_killer == 1)
						{
							decl String:killer_caption[32];
							Format(killer_caption, 32, "%T", "DamagePanel_Killer", player_index);
							DrawPanelItem(panel, killer_caption, 0);
						}
						DrawPanelText(panel, killer[i]);
						i++;
					}
					SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
					CloseHandle(panel);
				}
				SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
				CloseHandle(panel);
			}
			new is_wounded;
			new i;
			while (i < 8)
			{
				if (strcmp(wounded[i], "", true))
				{
					is_wounded++;
					if (is_wounded == 1)
					{
						decl String:wounded_caption[32];
						Format(wounded_caption, 32, "%T", "DamagePanel_Wounded", player_index);
						DrawPanelItem(panel, wounded_caption, 0);
					}
					DrawPanelText(panel, wounded[i]);
					i++;
				}
				new is_killer;
				new i;
				while (i < 8)
				{
					if (strcmp(killer[i], "", true))
					{
						is_killer++;
						if (is_killer == 1)
						{
							decl String:killer_caption[32];
							Format(killer_caption, 32, "%T", "DamagePanel_Killer", player_index);
							DrawPanelItem(panel, killer_caption, 0);
						}
						DrawPanelText(panel, killer[i]);
						i++;
					}
					SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
					CloseHandle(panel);
				}
				SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
				CloseHandle(panel);
			}
			new is_killer;
			new i;
			while (i < 8)
			{
				if (strcmp(killer[i], "", true))
				{
					is_killer++;
					if (is_killer == 1)
					{
						decl String:killer_caption[32];
						Format(killer_caption, 32, "%T", "DamagePanel_Killer", player_index);
						DrawPanelItem(panel, killer_caption, 0);
					}
					DrawPanelText(panel, killer[i]);
					i++;
				}
				SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
				CloseHandle(panel);
			}
			SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
			CloseHandle(panel);
		}
		new is_killed;
		new i;
		while (i < 8)
		{
			if (strcmp(killed[i], "", true))
			{
				is_killed++;
				if (is_killed == 1)
				{
					decl String:killed_caption[32];
					Format(killed_caption, 32, "%T", "DamagePanel_Killed", player_index);
					DrawPanelItem(panel, killed_caption, 0);
				}
				DrawPanelText(panel, killed[i]);
				i++;
			}
			new is_wounded;
			new i;
			while (i < 8)
			{
				if (strcmp(wounded[i], "", true))
				{
					is_wounded++;
					if (is_wounded == 1)
					{
						decl String:wounded_caption[32];
						Format(wounded_caption, 32, "%T", "DamagePanel_Wounded", player_index);
						DrawPanelItem(panel, wounded_caption, 0);
					}
					DrawPanelText(panel, wounded[i]);
					i++;
				}
				new is_killer;
				new i;
				while (i < 8)
				{
					if (strcmp(killer[i], "", true))
					{
						is_killer++;
						if (is_killer == 1)
						{
							decl String:killer_caption[32];
							Format(killer_caption, 32, "%T", "DamagePanel_Killer", player_index);
							DrawPanelItem(panel, killer_caption, 0);
						}
						DrawPanelText(panel, killer[i]);
						i++;
					}
					SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
					CloseHandle(panel);
				}
				SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
				CloseHandle(panel);
			}
			new is_killer;
			new i;
			while (i < 8)
			{
				if (strcmp(killer[i], "", true))
				{
					is_killer++;
					if (is_killer == 1)
					{
						decl String:killer_caption[32];
						Format(killer_caption, 32, "%T", "DamagePanel_Killer", player_index);
						DrawPanelItem(panel, killer_caption, 0);
					}
					DrawPanelText(panel, killer[i]);
					i++;
				}
				SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
				CloseHandle(panel);
			}
			SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
			CloseHandle(panel);
		}
		new is_wounded;
		new i;
		while (i < 8)
		{
			if (strcmp(wounded[i], "", true))
			{
				is_wounded++;
				if (is_wounded == 1)
				{
					decl String:wounded_caption[32];
					Format(wounded_caption, 32, "%T", "DamagePanel_Wounded", player_index);
					DrawPanelItem(panel, wounded_caption, 0);
				}
				DrawPanelText(panel, wounded[i]);
				i++;
			}
			new is_killer;
			new i;
			while (i < 8)
			{
				if (strcmp(killer[i], "", true))
				{
					is_killer++;
					if (is_killer == 1)
					{
						decl String:killer_caption[32];
						Format(killer_caption, 32, "%T", "DamagePanel_Killer", player_index);
						DrawPanelItem(panel, killer_caption, 0);
					}
					DrawPanelText(panel, killer[i]);
					i++;
				}
				SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
				CloseHandle(panel);
			}
			SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
			CloseHandle(panel);
		}
		new is_killer;
		new i;
		while (i < 8)
		{
			if (strcmp(killer[i], "", true))
			{
				is_killer++;
				if (is_killer == 1)
				{
					decl String:killer_caption[32];
					Format(killer_caption, 32, "%T", "DamagePanel_Killer", player_index);
					DrawPanelItem(panel, killer_caption, 0);
				}
				DrawPanelText(panel, killer[i]);
				i++;
			}
			SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
			CloseHandle(panel);
		}
		SendPanelToClient(panel, player_index, PanelDamageHandler, 15);
		CloseHandle(panel);
	}
	return 0;
}

public build_damage_chat(player_index)
{
	new var2;
	if (gameme_plugin[147] && (!IsClientInGame(player_index) || IsFakeClient(player_index)))
	{
		return 0;
	}
	new max_clients = GetMaxClients();
	decl String:killed_message[192];
	new killer_index;
	new i = 1;
	while (i <= max_clients)
	{
		if (player_index != i)
		{
			new j = 1;
			while (j <= max_clients)
			{
				if (player_index == j)
				{
					new attacked_damage;
					new killer_hpleft;
					new is_killer;
					if (0 < player_damage[i][j][0])
					{
						attacked_damage = player_damage[i][j][3];
						if (0 < player_damage[i][j][4])
						{
							killer_hpleft = player_damage[i][j][5];
							is_killer++;
							player_damage[i][j][4] = 0;
							player_damage[i][j][5] = 0;
							player_damage[i][j][7] = -1;
						}
					}
					if (0 < is_killer)
					{
						if (IsClientConnected(i))
						{
							decl String:killer_name[64];
							GetClientName(i, killer_name, 64);
							if (strcmp(4364 + 148, "", true))
							{
								Format(killed_message, 192, "%s %T", 4364 + 148, "DamageChat_Killedyou", player_index, killer_name, attacked_damage, killer_hpleft);
							}
							else
							{
								Format(killed_message, 192, "%T", "DamageChat_Killedyou", player_index, killer_name, attacked_damage, killer_hpleft);
							}
							killer_index++;
						}
					}
				}
				j++;
			}
		}
		i++;
	}
	if (0 < killer_index)
	{
		new var3;
		if (player_index > 0 && !IsFakeClient(player_index) && IsClientInGame(player_index))
		{
			new var4;
			if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1 || gameme_plugin[0] == 2)
			{
				color_gameme_entities(killed_message);
				if (!(gameme_plugin[0] == 2))
				{
					new Handle:message_handle = StartMessageOne("SayText2", player_index, 0);
					if (message_handle)
					{
						if (gameme_plugin[159] == 1)
						{
							PbSetInt(message_handle, "ent_idx", player_index, -1);
							PbSetBool(message_handle, "chat", false, -1);
							PbSetString(message_handle, "msg_name", killed_message, -1);
							PbAddString(message_handle, "params", "");
							PbAddString(message_handle, "params", "");
							PbAddString(message_handle, "params", "");
							PbAddString(message_handle, "params", "");
						}
						else
						{
							BfWriteByte(message_handle, player_index);
							BfWriteByte(message_handle, 0);
							BfWriteString(message_handle, killed_message);
						}
						EndMessage();
					}
				}
			}
		}
	}
	return 0;
}

public Event_CSGOPlayerFire(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < userid)
	{
		decl String:weapon_str[32];
		GetEventString(event, "weapon", weapon_str, 32, "");
		ReplaceString(weapon_str, 32, "weapon_", "", false);
		new weapon_index = get_weapon_index(csgo_weapon_list, 52, weapon_str);
		if (weapon_index > -1)
		{
			new var1;
			if (weapon_index != 22 && weapon_index != 32 && weapon_index != 33 && weapon_index != 34 && weapon_index != 35 && weapon_index != 36 && weapon_index != 37)
			{
				player_weapons[userid][weapon_index]++;
			}
		}
	}
	return 0;
}

public Event_CSSPlayerFire(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < userid)
	{
		decl String:weapon_str[32];
		GetEventString(event, "weapon", weapon_str, 32, "");
		new weapon_index = get_weapon_index(css_weapon_list, 28, weapon_str);
		if (weapon_index > -1)
		{
			new var1;
			if (weapon_index != 27 && weapon_index != 11 && weapon_index != 26)
			{
				player_weapons[userid][weapon_index]++;
			}
		}
	}
	return 0;
}

public Event_DODSWeaponAttack(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	if (0 < userid)
	{
		new log_weapon_index = GetEventInt(event, "weapon", 0);
		new weapon_index = -1;
		switch (log_weapon_index)
		{
			case 1:
			{
				weapon_index = 20;
			}
			case 2:
			{
				weapon_index = 16;
			}
			case 3:
			{
				weapon_index = 7;
			}
			case 4:
			{
				weapon_index = 15;
			}
			case 5:
			{
				weapon_index = 10;
			}
			case 6:
			{
				weapon_index = 8;
			}
			case 7:
			{
				weapon_index = 1;
			}
			case 8:
			{
				weapon_index = 2;
			}
			case 9:
			{
				weapon_index = 9;
			}
			case 10:
			{
				weapon_index = 3;
			}
			case 11:
			{
				weapon_index = 0;
			}
			case 12:
			{
				weapon_index = 4;
			}
			case 13:
			{
				weapon_index = 6;
			}
			case 14:
			{
				weapon_index = 11;
			}
			case 15:
			{
				weapon_index = 12;
			}
			case 16:
			{
				weapon_index = 5;
			}
			case 17:
			{
				weapon_index = 13;
			}
			case 18:
			{
				weapon_index = 14;
			}
			case 19:
			{
				weapon_index = 19;
			}
			case 20:
			{
				weapon_index = 17;
			}
			case 23:
			{
				weapon_index = 24;
			}
			case 24:
			{
				weapon_index = 23;
			}
			case 25:
			{
				weapon_index = 22;
			}
			case 26:
			{
				weapon_index = 21;
			}
			case 31:
			{
				weapon_index = 8;
			}
			case 33:
			{
				weapon_index = 9;
			}
			case 34:
			{
				weapon_index = 3;
			}
			case 35:
			{
				weapon_index = 12;
			}
			case 36:
			{
				weapon_index = 5;
			}
			case 38:
			{
				weapon_index = 6;
			}
			default:
			{
			}
		}
		if (weapon_index > -1)
		{
			new var1;
			if (weapon_index != 25 && weapon_index != 21 && weapon_index != 22 && weapon_index != 23 && weapon_index != 24)
			{
				player_weapons[userid][weapon_index]++;
			}
		}
	}
	return 0;
}

public Event_L4DPlayerFire(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < userid)
	{
		decl String:weapon_str[32];
		GetEventString(event, "weapon", weapon_str, 32, "");
		new weapon_index = get_weapon_index(l4d_weapon_list, 23, weapon_str);
		if (weapon_index > -1)
		{
			new var1;
			if (weapon_index != 12 && weapon_index != 6)
			{
				player_weapons[userid][weapon_index]++;
			}
		}
	}
	return 0;
}

public Event_CSGOPlayerHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (attacker > 0 && victim != attacker)
	{
		decl String:weapon_str[32];
		GetEventString(event, "weapon", weapon_str, 32, "");
		new weapon_index = get_weapon_index(csgo_weapon_list, 52, weapon_str);
		if (weapon_index > -1)
		{
			if (!player_weapons[attacker][weapon_index][0])
			{
				player_weapons[attacker][weapon_index]++;
			}
			player_weapons[attacker][weapon_index][1]++;
			new var2 = player_weapons[attacker][weapon_index][5];
			var2 = var2[GetEventInt(event, "dmg_health", 0)];
			new hitgroup = GetEventInt(event, "hitgroup", 0);
			if (hitgroup < 8)
			{
				player_weapons[attacker][weapon_index][hitgroup + 8]++;
			}
			if (gameme_plugin[147] == 1)
			{
				player_damage[attacker][victim]++;
				new var3 = player_damage[attacker][victim][3];
				var3 = var3[GetEventInt(event, "dmg_health", 0)];
			}
		}
	}
	return 0;
}

public Event_CSSPlayerHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (attacker > 0 && victim != attacker)
	{
		decl String:weapon_str[32];
		GetEventString(event, "weapon", weapon_str, 32, "");
		new weapon_index = get_weapon_index(css_weapon_list, 28, weapon_str);
		if (weapon_index > -1)
		{
			if (!player_weapons[attacker][weapon_index][0])
			{
				player_weapons[attacker][weapon_index]++;
			}
			player_weapons[attacker][weapon_index][1]++;
			new var2 = player_weapons[attacker][weapon_index][5];
			var2 = var2[GetEventInt(event, "dmg_health", 0)];
			new hitgroup = GetEventInt(event, "hitgroup", 0);
			if (hitgroup < 8)
			{
				player_weapons[attacker][weapon_index][hitgroup + 8]++;
			}
			if (gameme_plugin[147] == 1)
			{
				player_damage[attacker][victim]++;
				new var3 = player_damage[attacker][victim][3];
				var3 = var3[GetEventInt(event, "dmg_health", 0)];
			}
		}
	}
	return 0;
}

public Event_DODSPlayerHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (attacker > 0 && victim != attacker)
	{
		decl String:weapon_str[32];
		GetEventString(event, "weapon", weapon_str, 32, "");
		new weapon_index = get_weapon_index(dods_weapon_list, 26, weapon_str);
		if (weapon_index > -1)
		{
			if (!player_weapons[attacker][weapon_index][0])
			{
				player_weapons[attacker][weapon_index]++;
			}
			player_weapons[attacker][weapon_index][1]++;
			new var2 = player_weapons[attacker][weapon_index][5];
			var2 = var2[GetEventInt(event, "health", 0)];
			new hitgroup = GetEventInt(event, "hitgroup", 0);
			if (hitgroup < 8)
			{
				player_weapons[attacker][weapon_index][hitgroup + 8]++;
			}
			if (gameme_plugin[147] == 1)
			{
				player_damage[attacker][victim]++;
				new var3 = player_damage[attacker][victim][3];
				var3 = var3[GetEventInt(event, "damage", 0)];
			}
		}
	}
	return 0;
}

public Event_L4DPlayerHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (attacker > 0 && victim != attacker)
	{
		decl String:weapon_str[32];
		GetEventString(event, "weapon", weapon_str, 32, "");
		new weapon_index = get_weapon_index(l4d_weapon_list, 23, weapon_str);
		if (weapon_index > -1)
		{
			if (!player_weapons[attacker][weapon_index][0])
			{
				player_weapons[attacker][weapon_index]++;
			}
			player_weapons[attacker][weapon_index][1]++;
			new var3 = player_weapons[attacker][weapon_index][5];
			var3 = var3[GetEventInt(event, "dmg_health", 0)];
			new hitgroup = GetEventInt(event, "hitgroup", 0);
			if (hitgroup < 8)
			{
				player_weapons[attacker][weapon_index][hitgroup + 8]++;
			}
		}
		else
		{
			if (!strcmp(weapon_str, "insect_swarm", true))
			{
				new var2;
				if (victim > 0 && IsClientInGame(victim) && GetClientTeam(victim) == 2 && !GetEntProp(victim, PropType:0, "m_isIncapacitated", 4, 0))
				{
					log_player_player_event(attacker, victim, "triggered", "spit_hurt", 0);
				}
			}
		}
	}
	return 0;
}

public Event_L4DInfectedHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	if (0 < attacker)
	{
		decl String:weapon_str[32];
		GetClientWeapon(attacker, weapon_str, 32);
		new weapon_index = get_weapon_index(l4d_weapon_list, 23, weapon_str[1]);
		if (weapon_index > -1)
		{
			if (!player_weapons[attacker][weapon_index][0])
			{
				player_weapons[attacker][weapon_index]++;
			}
			player_weapons[attacker][weapon_index][1]++;
			new var1 = player_weapons[attacker][weapon_index][5];
			var1 = var1[GetEventInt(event, "amount", 0)];
			new hitgroup = GetEventInt(event, "hitgroup", 0);
			if (hitgroup < 8)
			{
				player_weapons[attacker][weapon_index][hitgroup + 8]++;
			}
		}
	}
	return 0;
}

public Event_CSGOPlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (victim > 0 && attacker > 0)
	{
		if (victim != attacker)
		{
			decl String:weapon_str[32];
			GetEventString(event, "weapon", weapon_str, 32, "");
			new weapon_index = get_weapon_index(csgo_weapon_list, 52, weapon_str);
			if (weapon_index > -1)
			{
				player_weapons[attacker][weapon_index][2]++;
				new headshot = GetEventBool(event, "headshot", false);
				if (headshot == 1)
				{
					player_weapons[attacker][weapon_index][3]++;
				}
				player_weapons[victim][weapon_index][6]++;
				if (GetEventInt(event, "dominated", 0))
				{
					log_player_player_event(attacker, victim, "triggered", "domination", 0);
				}
				else
				{
					if (GetEventInt(event, "revenge", 0))
					{
						log_player_player_event(attacker, victim, "triggered", "revenge", 0);
					}
				}
				if (GetClientTeam(victim) == GetClientTeam(attacker))
				{
					player_weapons[attacker][weapon_index][4]++;
					if (gameme_plugin[147] == 1)
					{
						player_damage[attacker][victim][6] += 1;
					}
				}
				else
				{
					new assister = GetClientOfUserId(GetEventInt(event, "assister", 0));
					new var2;
					if (assister > 0 && victim != assister)
					{
						log_player_player_event(assister, victim, "triggered", "kill_assist", 0);
					}
				}
				if (gameme_plugin[147] == 1)
				{
					player_damage[attacker][victim][5] = GetClientHealth(attacker);
					player_damage[attacker][victim][1] += 1;
					player_damage[attacker][victim][4] = attacker;
					player_damage[attacker][victim][7] = weapon_index;
					if (headshot == 1)
					{
						player_damage[attacker][victim][2] += 1;
					}
					if (gameme_plugin[148] == 2)
					{
						build_damage_chat(victim);
					}
					build_damage_panel(victim);
				}
			}
		}
		dump_player_data(victim);
		gameme_players[victim][8] = 0;
		if (gameme_plugin[151] == 1)
		{
			new var3;
			if (IsClientInGame(victim) && !IsFakeClient(victim))
			{
				gameme_players[victim][11] = CreateTimer(0.5, spectator_player_timer, victim, 3);
			}
			new j;
			while (j <= 65)
			{
				player_messages[j][attacker][255] = 1;
				player_messages[j][victim][255] = 1;
				j++;
			}
		}
	}
	return 0;
}

public Event_CSSPlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (victim > 0 && attacker > 0)
	{
		if (victim != attacker)
		{
			decl String:weapon_str[32];
			GetEventString(event, "weapon", weapon_str, 32, "");
			new weapon_index = get_weapon_index(css_weapon_list, 28, weapon_str);
			if (weapon_index > -1)
			{
				player_weapons[attacker][weapon_index][2]++;
				new headshot = GetEventBool(event, "headshot", false);
				if (headshot == 1)
				{
					player_weapons[attacker][weapon_index][3]++;
				}
				player_weapons[victim][weapon_index][6]++;
				if (GetEventInt(event, "dominated", 0))
				{
					log_player_player_event(attacker, victim, "triggered", "domination", 0);
				}
				else
				{
					if (GetEventInt(event, "revenge", 0))
					{
						log_player_player_event(attacker, victim, "triggered", "revenge", 0);
					}
				}
				if (GetClientTeam(victim) == GetClientTeam(attacker))
				{
					player_weapons[attacker][weapon_index][4]++;
					if (gameme_plugin[147] == 1)
					{
						player_damage[attacker][victim][6] += 1;
					}
				}
				if (gameme_plugin[147] == 1)
				{
					player_damage[attacker][victim][5] = GetClientHealth(attacker);
					player_damage[attacker][victim][1] += 1;
					player_damage[attacker][victim][4] = attacker;
					player_damage[attacker][victim][7] = weapon_index;
					if (headshot == 1)
					{
						player_damage[attacker][victim][2] += 1;
					}
					if (gameme_plugin[148] == 2)
					{
						build_damage_chat(victim);
					}
					build_damage_panel(victim);
				}
			}
		}
		dump_player_data(victim);
		gameme_players[victim][8] = 0;
		if (gameme_plugin[151] == 1)
		{
			new var2;
			if (IsClientInGame(victim) && !IsFakeClient(victim))
			{
				gameme_players[victim][11] = CreateTimer(0.5, spectator_player_timer, victim, 3);
			}
			new j;
			while (j <= 65)
			{
				player_messages[j][attacker][255] = 1;
				player_messages[j][victim][255] = 1;
				j++;
			}
		}
	}
	return 0;
}

public Event_DODSPlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (victim > 0 && attacker > 0)
	{
		if (victim != attacker)
		{
			decl String:weapon_str[32];
			GetEventString(event, "weapon", weapon_str, 32, "");
			new weapon_index = get_weapon_index(dods_weapon_list, 26, weapon_str);
			if (weapon_index > -1)
			{
				player_weapons[attacker][weapon_index][2]++;
				player_weapons[victim][weapon_index][6]++;
				if (GetClientTeam(victim) == GetClientTeam(attacker))
				{
					player_weapons[attacker][weapon_index][4]++;
					if (gameme_plugin[147] == 1)
					{
						player_damage[attacker][victim][6] += 1;
					}
				}
				if (gameme_plugin[147] == 1)
				{
					player_damage[attacker][victim][5] = GetClientHealth(attacker);
					player_damage[attacker][victim][1] += 1;
					player_damage[attacker][victim][4] = attacker;
					player_damage[attacker][victim][7] = weapon_index;
					if (gameme_plugin[148] == 2)
					{
						build_damage_chat(victim);
					}
					build_damage_panel(victim);
				}
			}
		}
		dump_player_data(victim);
	}
	return 0;
}

public Event_L4DPlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (victim > 0 && attacker > 0)
	{
		if (victim != attacker)
		{
			decl String:weapon_str[32];
			GetEventString(event, "weapon", weapon_str, 32, "");
			new weapon_index = get_weapon_index(l4d_weapon_list, 23, weapon_str);
			if (weapon_index > -1)
			{
				player_weapons[attacker][weapon_index][2]++;
				new headshot = GetEventBool(event, "headshot", false);
				if (headshot == 1)
				{
					player_weapons[attacker][weapon_index][3]++;
				}
				player_weapons[victim][weapon_index][6]++;
				if (GetClientTeam(victim) == GetClientTeam(attacker))
				{
					player_weapons[attacker][weapon_index][4]++;
				}
			}
		}
		dump_player_data(victim);
	}
	return 0;
}

public Event_HL2MPPlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (victim > 0 && attacker > 0)
	{
		if (victim != attacker)
		{
			decl String:weapon_str[32];
			GetEventString(event, "weapon", weapon_str, 32, "");
			new weapon_index = get_weapon_index(hl2mp_weapon_list, 6, weapon_str);
			if (weapon_index > -1)
			{
				player_weapons[attacker][weapon_index][2]++;
				player_weapons[victim][weapon_index][6]++;
				new var2;
				if (hl2mp_data[1] && GetClientTeam(victim) == GetClientTeam(attacker))
				{
					player_weapons[attacker][weapon_index][4]++;
				}
			}
		}
		dump_player_data(victim);
	}
	return 0;
}

public Event_ZPSPlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (victim > 0 && attacker > 0)
	{
		if (victim != attacker)
		{
			decl String:weapon_str[32];
			GetEventString(event, "weapon", weapon_str, 32, "");
			new weapon_index = get_weapon_index(zps_weapon_list, 11, weapon_str);
			if (weapon_index > -1)
			{
				player_weapons[attacker][weapon_index][2]++;
				player_weapons[victim][weapon_index][6]++;
				if (GetClientTeam(victim) == GetClientTeam(attacker))
				{
					player_weapons[attacker][weapon_index][4]++;
				}
			}
		}
		dump_player_data(victim);
	}
	return 0;
}

public Event_CSGOPlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < userid)
	{
		reset_player_data(userid);
		if (gameme_plugin[151] == 1)
		{
			if (gameme_players[userid][11])
			{
				KillTimer(gameme_players[userid][11], false);
				gameme_players[userid][11] = 0;
			}
		}
		if (IsClientInGame(userid))
		{
			new client_team = GetClientTeam(userid);
			new var1;
			if (client_team == 2 || client_team == 3)
			{
				decl String:client_model[128];
				GetClientModel(userid, client_model, 128);
				new role_index = -1;
				new i;
				while (i < 15)
				{
					if (StrContains(client_model, csgo_code_models[i], true) != -1)
					{
						role_index = i;
					}
					i++;
				}
				if (role_index > -1)
				{
					if (role_index != gameme_players[userid][0])
					{
						gameme_players[userid][0] = role_index;
						LogToGame("\"%L\" changed role to \"%s\"", userid, csgo_code_models[role_index]);
					}
				}
			}
			else
			{
				if (!client_team)
				{
					if (gameme_plugin[151] == 1)
					{
						gameme_players[userid][13] = 0;
						if (!IsFakeClient(userid))
						{
							gameme_players[userid][11] = CreateTimer(0.5, spectator_player_timer, userid, 3);
						}
					}
				}
			}
		}
	}
	return 0;
}

public Event_CSSPlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < userid)
	{
		reset_player_data(userid);
		if (gameme_plugin[151] == 1)
		{
			if (gameme_players[userid][11])
			{
				KillTimer(gameme_players[userid][11], false);
				gameme_players[userid][11] = 0;
			}
		}
		if (IsClientInGame(userid))
		{
			new client_team = GetClientTeam(userid);
			new var1;
			if (client_team == 2 || client_team == 3)
			{
				decl String:client_model[128];
				GetClientModel(userid, client_model, 128);
				new role_index = -1;
				if (client_team == 2)
				{
					new i;
					while (i < 4)
					{
						if (strcmp(css_ts_models[i], client_model, true))
						{
						}
						else
						{
							role_index = i;
						}
						i++;
					}
				}
				else
				{
					if (client_team == 3)
					{
						new i;
						while (i < 4)
						{
							if (strcmp(css_ct_models[i], client_model, true))
							{
							}
							else
							{
								role_index = i + 4;
							}
							i++;
						}
					}
				}
				if (role_index > -1)
				{
					if (role_index != gameme_players[userid][0])
					{
						gameme_players[userid][0] = role_index;
						LogToGame("\"%L\" changed role to \"%s\"", userid, css_code_models[role_index]);
					}
				}
			}
			else
			{
				if (!client_team)
				{
					if (gameme_plugin[151] == 1)
					{
						gameme_players[userid][13] = 0;
						if (!IsFakeClient(userid))
						{
							gameme_players[userid][11] = CreateTimer(0.5, spectator_player_timer, userid, 3);
						}
					}
				}
			}
		}
	}
	return 0;
}

public Event_L4DPlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < userid)
	{
		reset_player_data(userid);
	}
	return 0;
}

public Event_HL2MPPlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < userid)
	{
		reset_player_data(userid);
	}
	return 0;
}

public Event_ZPSPlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < userid)
	{
		reset_player_data(userid);
	}
	return 0;
}

public Action:Event_CSPRoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	LogToGame("World triggered \"Round_Start\"");
	return Action:0;
}

public Event_CSGORoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	if (gameme_plugin[151] == 1)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			if (gameme_players[i][11])
			{
				KillTimer(gameme_players[i][11], false);
				gameme_players[i][11] = 0;
			}
			new j;
			while (j <= 65)
			{
				player_messages[i][j][255] = 1;
				j++;
			}
			new var1;
			if (i > 0 && IsClientInGame(i) && !IsFakeClient(i) && IsClientObserver(i))
			{
				gameme_players[i][11] = CreateTimer(0.5, spectator_player_timer, i, 3);
			}
			i++;
		}
	}
	if (gameme_plugin[149] == 1)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			gameme_players[i][8] = 1;
			i++;
		}
	}
	return 0;
}

public Event_CSSRoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	if (gameme_plugin[151] == 1)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			if (gameme_players[i][11])
			{
				KillTimer(gameme_players[i][11], false);
				gameme_players[i][11] = 0;
			}
			new j;
			while (j <= 65)
			{
				player_messages[i][j][255] = 1;
				j++;
			}
			new var1;
			if (i > 0 && IsClientInGame(i) && !IsFakeClient(i) && IsClientObserver(i))
			{
				gameme_players[i][11] = CreateTimer(0.5, spectator_player_timer, i, 3);
			}
			i++;
		}
	}
	if (gameme_plugin[149] == 1)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			gameme_players[i][8] = 1;
			i++;
		}
	}
	return 0;
}

public Event_CSGORoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
		{
			if (gameme_plugin[148] == 1)
			{
				build_damage_panel(i);
			}
		}
		dump_player_data(i);
		i++;
	}
	return 0;
}

public Event_CSSRoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
		{
			if (gameme_plugin[148] == 1)
			{
				build_damage_panel(i);
			}
		}
		dump_player_data(i);
		i++;
	}
	return 0;
}

public Event_DODSRoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
		{
			if (gameme_plugin[148] == 1)
			{
				build_damage_panel(i);
			}
		}
		dump_player_data(i);
		i++;
	}
	return 0;
}

public Event_L4DRoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		dump_player_data(i);
		i++;
	}
	return 0;
}

public Event_HL2MPRoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		dump_player_data(i);
		i++;
	}
	return 0;
}

public Event_ZPSRoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		dump_player_data(i);
		i++;
	}
	return 0;
}

public Event_CSPRoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new team_index = GetEventInt(event, "winners", 0);
	if (strcmp(team_list[team_index], "", true))
	{
		log_team_event(team_list[team_index], "Round_Win", "");
	}
	LogToGame("World triggered \"Round_End\"");
	return 0;
}

public Event_CSGOAnnounceWarmup(Handle:event, String:name[], bool:dontBroadcast)
{
	LogToGame("World triggered \"Round_Warmup_Start\"");
	return 0;
}

public Event_CSGOAnnounceMatchStart(Handle:event, String:name[], bool:dontBroadcast)
{
	new i;
	while (i <= 65)
	{
		reset_player_data(i);
		gameme_players[i][10] = 0;
		i++;
	}
	LogToGame("World triggered \"Round_Match_Start\"");
	return 0;
}

public Event_CSGOGGLevelUp(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		new level = GetEventInt(event, "weaponrank", 0);
		if (0 <= level)
		{
			if (gameme_players[player][10] < level)
			{
				log_player_event(player, "triggered", "gg_levelup", 0, 0);
			}
			else
			{
				if (gameme_players[player][10] > level)
				{
					log_player_event(player, "triggered", "gg_leveldown", 0, 0);
				}
			}
			gameme_players[player][10] = level;
		}
	}
	return 0;
}

public Event_CSGOGGWin(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "playerid", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "gg_win", 0, 0);
	}
	return 0;
}

public Event_CSGOGGLeader(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "playerid", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "gg_leader", 0, 0);
	}
	return 0;
}

public Event_RoundMVP(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "mvp", 0, 0);
	}
	return 0;
}

public Event_TF2PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new death_flags = GetEventInt(event, "death_flags", 0);
	if (death_flags & 32 == 32)
	{
		return 0;
	}
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (attacker > 0 && victim > 0 && attacker <= MaxClients)
	{
		tf2_players[victim][19] = 0;
		tf2_players[victim][22] = 0;
		new custom_kill = GetEventInt(event, "customkill", 0);
		if (0 < custom_kill)
		{
			new victim_team_index = GetClientTeam(victim);
			new player_team_index = GetClientTeam(attacker);
			if (player_team_index == victim_team_index)
			{
				if (custom_kill == 6)
				{
					log_player_event(attacker, "triggered", "force_suicide", 0, 0);
				}
			}
			else
			{
				if (custom_kill == 1)
				{
					log_player_event(attacker, "triggered", "headshot", 0, 0);
				}
				if (custom_kill == 2)
				{
					log_player_player_event(attacker, victim, "triggered", "backstab", 0);
				}
			}
		}
		if (victim != attacker)
		{
			switch (tf2_players[attacker][19])
			{
				case 2:
				{
					log_player_event(attacker, "triggered", "rocket_jump_kill", 0, 0);
				}
				case 3:
				{
					log_player_event(attacker, "triggered", "sticky_jump_kill", 0, 0);
				}
				default:
				{
				}
			}
			new bits = GetEventInt(event, "damagebits", 0);
			new var2;
			if (bits & 1048576 && attacker > 0 && custom_kill != 1)
			{
				log_player_event(attacker, "triggered", "crit_kill", 0, 0);
			}
			else
			{
				if (bits & 16384)
				{
					log_player_event(attacker, "triggered", "drowned", 0, 0);
				}
			}
			if (death_flags & 16 == 16)
			{
				log_player_event(attacker, "triggered", "first_blood", 0, 0);
			}
			new var3;
			if (custom_kill == 1 && victim <= MaxClients && IsClientInGame(victim) && GetEntityFlags(victim) & 513)
			{
				log_player_event(attacker, "triggered", "airshot_headshot", 0, 0);
			}
		}
		decl String:weapon_log_name[64];
		GetEventString(event, "weapon_logclassname", weapon_log_name, 64, "");
		new weapon_index = get_tf2_weapon_index(weapon_log_name, attacker, -1);
		if (weapon_index != -1)
		{
			player_weapons[attacker][weapon_index][2]++;
			if (custom_kill == 1)
			{
				player_weapons[attacker][weapon_index][3]++;
			}
			player_weapons[victim][weapon_index][6]++;
			if (GetClientTeam(attacker) == GetClientTeam(victim))
			{
				player_weapons[attacker][weapon_index][4]++;
			}
		}
		dump_player_data(victim);
		gameme_players[victim][8] = 0;
	}
	return 0;
}

public Event_TF2PlayerTeleported(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new builder = GetClientOfUserId(GetEventInt(event, "builderid", 0));
	new var1;
	if ((player > 0 && builder > 0) && builder != player)
	{
		log_player_player_event(builder, player, "triggered", "player_teleported", 1);
	}
	return 0;
}

public void:OnGameFrame()
{
	switch (gameme_plugin[0])
	{
		case 3:
		{
			new bow_entity;
			while (PopStackCell(hl2mp_data[2], bow_entity, 0, false))
			{
				if (IsValidEntity(bow_entity))
				{
					new owner = GetEntDataEnt2(bow_entity, hl2mp_data[3]);
					new var6;
					if (!(owner < 0 || owner > MaxClients))
					{
						player_weapons[owner][0]++;
					}
				}
			}
		}
		case 4:
		{
			new entity;
			new var1;
			if (gameme_plugin[152] && tf2_data[3] > -1)
			{
				while (PopStackCell(tf2_data[4], entity, 0, false))
				{
					if (IsValidEntity(entity))
					{
						new owner = GetEntPropEnt(entity, PropType:0, "m_hThrower", 0);
						new var2;
						if (owner > 0 && owner <= MaxClients)
						{
							player_weapons[owner][tf2_data[3]]++;
						}
					}
				}
			}
			while (PopStackCell(tf2_data[5], entity, 0, false))
			{
				if (IsValidEntity(entity))
				{
					new owner = GetEntPropEnt(entity, PropType:0, "m_hOwnerEntity", 0);
					new var3;
					if (owner > 0 && owner <= MaxClients)
					{
						new item_index = GetEntProp(entity, PropType:0, "m_iItemDefinitionIndex", 4, 0);
						decl String:tmp_str[16];
						Format(tmp_str, 16, "%d", item_index);
						if (KvJumpToKey(tf2_data[1], tmp_str, false))
						{
							KvGetString(tf2_data[1], "item_slot", tmp_str, 16, "");
							new slot;
							if (GetTrieValue(tf2_data[2], tmp_str, slot))
							{
								new var4;
								if (slot && tf2_players[owner][21] == 4)
								{
									slot++;
								}
								if (item_index != tf2_players[owner][slot])
								{
									tf2_players[owner][slot] = item_index;
									tf2_players[owner][16] = 1;
								}
								tf2_players[owner][8][slot] = entity;
							}
							KvGoBack(tf2_data[1]);
						}
					}
				}
			}
			new client_count = GetClientCount(true);
			new i = 1;
			while (i <= client_count)
			{
				new var5;
				if (IsClientInGame(i) && GetEntData(i, tf2_data[6], 1))
				{
					tf2_players[i][22] = 1;
				}
				i++;
			}
		}
		default:
		{
		}
	}
	return void:0;
}

public void:OnEntityCreated(entity, String:classname[])
{
	switch (gameme_plugin[0])
	{
		case 3:
		{
			if (strcmp(classname, "crossbow_bolt", true))
			{
			}
			else
			{
				PushStackCell(hl2mp_data[2], entity);
			}
		}
		case 4:
		{
			if (StrEqual(classname, "tf_projectile_stun_ball", true))
			{
				PushStackCell(tf2_data[4], EntIndexToEntRef(entity));
			}
			else
			{
				new var1;
				if (StrEqual(classname, "tf_wearable_item_demoshield", true) || StrEqual(classname, "tf_wearable_item", true))
				{
					PushStackCell(tf2_data[5], EntIndexToEntRef(entity));
				}
			}
		}
		default:
		{
		}
	}
	return void:0;
}

public Action:OnTF2GameLog(String:message[])
{
	if (tf2_data[9])
	{
		tf2_data[9] = 0;
		return Action:3;
	}
	return Action:0;
}

public OnLogLocationsChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	if (strcmp(newVal, "", true))
	{
		new var1;
		if (strcmp(newVal, "0", true) && strcmp(newVal, "1", true))
		{
			new var2;
			if ((strcmp(newVal, "1", true) && strcmp(oldVal, "1", true)) || (strcmp(newVal, "0", true) && strcmp(oldVal, "0", true)))
			{
				if (gameme_plugin[109])
				{
					new enable_log_locations_cvar = GetConVarInt(gameme_plugin[109]);
					if (enable_log_locations_cvar == 1)
					{
						gameme_plugin[146] = 1;
						LogToGame("gameME location logging activated");
					}
					else
					{
						if (!enable_log_locations_cvar)
						{
							gameme_plugin[146] = 0;
							LogToGame("gameME location logging deactivated");
						}
					}
				}
				gameme_plugin[146] = 0;
			}
		}
	}
	return 0;
}

public OnDisplaySpectatorinfoChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	if (strcmp(newVal, "", true))
	{
		new var1;
		if (strcmp(newVal, "0", true) && strcmp(newVal, "1", true))
		{
			new var2;
			if ((strcmp(newVal, "1", true) && strcmp(oldVal, "1", true)) || (strcmp(newVal, "0", true) && strcmp(oldVal, "0", true)))
			{
				if (gameme_plugin[103])
				{
					new display_info = GetConVarInt(gameme_plugin[103]);
					if (display_info == 1)
					{
						gameme_plugin[151] = 1;
						LogToGame("gameME spectator displaying activated");
					}
					else
					{
						if (!display_info)
						{
							gameme_plugin[151] = 0;
							new i;
							while (i <= 65)
							{
								if (gameme_players[i][11])
								{
									KillTimer(gameme_players[i][11], false);
									gameme_players[i][11] = 0;
								}
								i++;
							}
							LogToGame("gameME spectator displaying deactivated");
						}
					}
				}
				gameme_plugin[151] = 0;
			}
		}
	}
	return 0;
}

public OnDamageDisplayChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	if (strcmp(newVal, "", true))
	{
		new var1;
		if (strcmp(newVal, "0", true) && strcmp(newVal, "1", true) && strcmp(newVal, "2", true))
		{
			new var2;
			if ((strcmp(newVal, "2", true) && strcmp(oldVal, "2", true)) || (strcmp(newVal, "1", true) && strcmp(oldVal, "1", true)) || (strcmp(newVal, "0", true) && strcmp(oldVal, "0", true)))
			{
				if (gameme_plugin[110])
				{
					new enable_damage_display_cvar = GetConVarInt(gameme_plugin[110]);
					if (enable_damage_display_cvar == 1)
					{
						gameme_plugin[147] = 1;
						gameme_plugin[148] = 1;
						LogToGame("gameME damage display activated [Mode: Menu]");
					}
					else
					{
						if (enable_damage_display_cvar == 2)
						{
							gameme_plugin[147] = 1;
							gameme_plugin[148] = 2;
							LogToGame("gameME damage display activated [Mode: Chat]");
						}
						if (!enable_damage_display_cvar)
						{
							gameme_plugin[147] = 0;
							LogToGame("gameME damage display deactivated");
						}
					}
				}
				gameme_plugin[147] = 0;
			}
		}
	}
	return 0;
}

public OngameMELiveChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	if (strcmp(newVal, "", true))
	{
		new var1;
		if (strcmp(newVal, "0", true) && strcmp(newVal, "1", true))
		{
			new var2;
			if ((strcmp(newVal, "1", true) && strcmp(oldVal, "1", true)) || (strcmp(newVal, "0", true) && strcmp(oldVal, "0", true)))
			{
				if (gameme_plugin[111])
				{
					new var5;
					if (gameme_plugin[0] == 1 || gameme_plugin[0] == 11)
					{
						new var6;
						if (strcmp(4364 + 452, "", true) && strcmp(4364 + 580, "", true))
						{
							new enable_gameme_live_cvar = GetConVarInt(gameme_plugin[111]);
							if (enable_gameme_live_cvar == 1)
							{
								gameme_plugin[149] = 1;
								start_gameme_live();
								LogToGame("gameME Live! activated");
							}
							else
							{
								if (!enable_gameme_live_cvar)
								{
									gameme_plugin[149] = 0;
									if (gameme_plugin[157])
									{
										CloseHandle(gameme_plugin[157]);
									}
									LogToGame("gameME Live! disabled");
								}
							}
						}
						if (strcmp(newVal, "1", true))
						{
							LogToGame("gameME Live! cannot be activated, no gameME Live! address assigned");
						}
						else
						{
							SetConVarInt(gameme_plugin[111], 0, false, false);
						}
						gameme_plugin[149] = 0;
					}
				}
			}
		}
	}
	return 0;
}

public OnLiveAddressChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	if (strcmp(newVal, "", true))
	{
		if (gameme_plugin[112])
		{
			decl String:gameme_live_cvar_value[32];
			GetConVarString(gameme_plugin[112], gameme_live_cvar_value, 32);
			if (strcmp(gameme_live_cvar_value, "", true))
			{
				new String:SplitArray[2][16] = "\x08";
				new split_count = ExplodeString(gameme_live_cvar_value, ":", SplitArray, 2, 16, false);
				if (split_count == 2)
				{
					strcopy(4364 + 452, 32, SplitArray[0][SplitArray]);
					gameme_plugin[145] = StringToInt(SplitArray[1], 10);
				}
			}
		}
	}
	return 0;
}

public OnTagsChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	if (gameme_plugin[154])
	{
		return 0;
	}
	new count = GetArraySize(gameme_plugin[155]);
	new i;
	while (i < count)
	{
		decl String:tag[128];
		GetArrayString(gameme_plugin[155], i, tag, 128);
		AddPluginServerTag(tag);
		i++;
	}
	return 0;
}

public OnProtectAddressChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	if (strcmp(newVal, "", true))
	{
		if (gameme_plugin[69])
		{
			decl String:protect_address_cvar_value[32];
			GetConVarString(gameme_plugin[69], protect_address_cvar_value, 32);
			if (strcmp(protect_address_cvar_value, "", true))
			{
				new String:SplitArray[2][16] = "\x08";
				new split_count = ExplodeString(protect_address_cvar_value, ":", SplitArray, 2, 16, false);
				if (split_count == 2)
				{
					strcopy(4364 + 280, 32, SplitArray[0][SplitArray]);
					gameme_plugin[102] = StringToInt(SplitArray[1], 10);
				}
			}
			decl String:log_command[192];
			Format(log_command, 192, "logaddress_add %s", newVal);
			ServerCommand(log_command);
			new i;
			while (i <= 65)
			{
				gameme_players[i][0] = -1;
				i++;
			}
		}
	}
	return 0;
}

public Action:ProtectLoggingChange(args)
{
	if (gameme_plugin[69])
	{
		decl String:protect_address_cvar_value[192];
		GetConVarString(gameme_plugin[69], protect_address_cvar_value, 192);
		if (args >= 1)
		{
			decl String:log_action[192];
			GetCmdArg(1, log_action, 192);
			new var1;
			if (strcmp(log_action, "off", true) && strcmp(log_action, "0", true))
			{
				if (strcmp(protect_address_cvar_value, "", true))
				{
					LogToGame("gameME address protection active, logging reenabled!");
					ServerCommand("log 1");
				}
			}
			else
			{
				new var2;
				if (strcmp(log_action, "on", true) && strcmp(log_action, "1", true))
				{
					new i;
					while (i <= 65)
					{
						gameme_players[i][0] = -1;
						i++;
					}
				}
			}
		}
	}
	return Action:0;
}

public Action:ProtectForwardingChange(args)
{
	if (gameme_plugin[69])
	{
		decl String:protect_address_cvar_value[32];
		GetConVarString(gameme_plugin[69], protect_address_cvar_value, 32);
		if (strcmp(protect_address_cvar_value, "", true))
		{
			if (args == 1)
			{
				decl String:log_action[192];
				GetCmdArg(1, log_action, 192);
				if (strcmp(log_action, protect_address_cvar_value, true))
				{
				}
				else
				{
					decl String:log_command[192];
					Format(log_command, 192, "logaddress_add %s", protect_address_cvar_value);
					LogToGame("gameME address protection active, logaddress readded!");
					ServerCommand(log_command);
				}
			}
			if (args > 1)
			{
				new String:log_action[192];
				new i = 1;
				while (i <= args)
				{
					decl String:temp_argument[192];
					GetCmdArg(i, temp_argument, 192);
					strcopy(log_action[strlen(log_action)], 192, temp_argument);
					i++;
				}
				if (strcmp(log_action, protect_address_cvar_value, true))
				{
				}
				else
				{
					decl String:log_command[192];
					Format(log_command, 192, "logaddress_add %s", protect_address_cvar_value);
					LogToGame("gameME address protection active, logaddress readded!");
					ServerCommand(log_command);
				}
			}
		}
	}
	return Action:0;
}

public Action:ProtectForwardingDelallChange(args)
{
	if (gameme_plugin[69])
	{
		decl String:protect_address_cvar_value[32];
		GetConVarString(gameme_plugin[69], protect_address_cvar_value, 32);
		if (strcmp(protect_address_cvar_value, "", true))
		{
			decl String:log_command[192];
			Format(log_command, 192, "logaddress_add %s", protect_address_cvar_value);
			LogToGame("gameME address protection active, logaddress readded!");
			ServerCommand(log_command);
		}
	}
	return Action:0;
}

public OnBlockChatCommandsValuesChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	if (strcmp(newVal, "clear", true))
	{
		if (strcmp(newVal, "", true))
		{
			new String:BlockedCommands[32][64] = "�";
			new block_commands_count = ExplodeString(newVal, " ", BlockedCommands, 32, 64, false);
			new i;
			while (i < block_commands_count)
			{
				SetTrieValue(gameme_plugin[34], BlockedCommands[i], any:1, true);
				i++;
			}
		}
	}
	else
	{
		ClearTrie(gameme_plugin[34]);
		LogToGame("Server triggered \"%s\"", "blocked_commands_cleared");
	}
	return 0;
}

public OnMessagePrefixChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	strcopy(4364 + 148, 32, newVal);
	color_gameme_entities(4364 + 148);
	return 0;
}

public Action:MessagePrefixClear(args)
{
	strcopy(4364 + 148, 32, "");
	return Action:0;
}

public OnTeamPlayChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	if (gameme_plugin[0] == 3)
	{
		hl2mp_data[1] = GetConVarBool(hl2mp_data[0]);
	}
	return 0;
}

public OnTF2CriticalHitsChange(Handle:cvar, String:oldVal[], String:newVal[])
{
	tf2_data[8] = GetConVarBool(tf2_data[7]);
	if (!tf2_data[8])
	{
		new i = 1;
		while (i <= MaxClients)
		{
			dump_player_data(i);
			i++;
		}
	}
	return 0;
}

public Action:TF2_CalcIsAttackCritical(attacker, weapon, String:weaponname[], &bool:result)
{
	new var1;
	if (gameme_plugin[152] && attacker > 0 && attacker <= MaxClients)
	{
		new weapon_index = get_tf2_weapon_index(weaponname[2], attacker, -1);
		if (weapon_index != -1)
		{
			player_weapons[attacker][weapon_index]++;
		}
	}
	return Action:0;
}

log_player_settings(client, String:verb[32], String:settings_name[], String:settings_value[])
{
	if (0 < client)
	{
		LogToGame("\"%L\" %s \"%s\" (value \"%s\")", client, verb, settings_name, settings_value);
	}
	else
	{
		LogToGame("\"%s\" %s \"%s\" (value \"%s\")", "Server", verb, settings_name, settings_value);
	}
	return 0;
}

log_player_event(client, String:verb[32], String:player_event[192], additional_player, display_location)
{
	if (0 < client)
	{
		if (0 < display_location)
		{
			new Float:player_origin[3] = 0.0;
			GetClientAbsOrigin(client, player_origin);
			new var1;
			if (additional_player > 0 && additional_player != client)
			{
				LogToGame("\"%L\" %s \"%s\" (position \"%d %d %d\") (player \"%L\")", client, verb, player_event, RoundFloat(player_origin[0]), RoundFloat(player_origin[1]), RoundFloat(player_origin[2]), additional_player);
			}
			else
			{
				LogToGame("\"%L\" %s \"%s\" (position \"%d %d %d\")", client, verb, player_event, RoundFloat(player_origin[0]), RoundFloat(player_origin[1]), RoundFloat(player_origin[2]));
			}
		}
		new var2;
		if (additional_player > 0 && additional_player != client)
		{
			LogToGame("\"%L\" %s \"%s\" (player \"%L\")", client, verb, player_event, additional_player);
		}
		LogToGame("\"%L\" %s \"%s\"", client, verb, player_event);
	}
	return 0;
}

log_player_player_event(client, victim, String:verb[32], String:player_event[192], display_location)
{
	new var1;
	if (client > 0 && victim > 0)
	{
		if (0 < display_location)
		{
			new Float:player_origin[3] = 0.0;
			GetClientAbsOrigin(client, player_origin);
			new Float:victim_origin[3] = 0.0;
			GetClientAbsOrigin(victim, victim_origin);
			LogToGame("\"%L\" %s \"%s\" against \"%L\" (position \"%d %d %d\") (victim_position \"%d %d %d\")", client, verb, player_event, victim, RoundFloat(player_origin[0]), RoundFloat(player_origin[1]), RoundFloat(player_origin[2]), RoundFloat(victim_origin[0]), RoundFloat(victim_origin[1]), RoundFloat(victim_origin[2]));
		}
		LogToGame("\"%L\" %s \"%s\" against \"%L\"", client, verb, player_event, victim);
	}
	return 0;
}

log_team_event(String:team_name[32], String:team_action[192], String:team_objective[192])
{
	if (strcmp(team_name, "", true))
	{
		if (strcmp(team_objective, "", true))
		{
			LogToGame("Team \"%s\" triggered \"%s\" (object \"%s\")", team_name, team_action, team_objective);
		}
		LogToGame("Team \"%s\" triggered \"%s\"", team_name, team_action);
	}
	return 0;
}

log_player_location(String:event[32], client, additional_player)
{
	if (0 < client)
	{
		new Float:player_origin[3] = 0.0;
		GetClientAbsOrigin(client, player_origin);
		new var1;
		if (additional_player > 0 && additional_player != client)
		{
			new Float:additional_player_origin[3] = 0.0;
			GetClientAbsOrigin(additional_player, additional_player_origin);
			LogToGame("\"%L\" located on \"%s\" (position \"%d %d %d\") against \"%L\" (victim_position \"%d %d %d\")", client, event, RoundFloat(player_origin[0]), RoundFloat(player_origin[1]), RoundFloat(player_origin[2]), additional_player, RoundFloat(additional_player_origin[0]), RoundFloat(additional_player_origin[1]), RoundFloat(additional_player_origin[2]));
		}
		else
		{
			LogToGame("\"%L\" located on \"%s\" (position \"%d %d %d\")", client, event, RoundFloat(player_origin[0]), RoundFloat(player_origin[1]), RoundFloat(player_origin[2]));
		}
	}
	return 0;
}

find_player_team_slot(team_index)
{
	if (team_index > -1)
	{
		ColorSlotArray[team_index] = -1;
		new i = 1;
		while (i <= MaxClients)
		{
			new var1;
			if (IsClientInGame(i) && team_index == GetClientTeam(i))
			{
				ColorSlotArray[team_index] = i;
			}
			i++;
		}
	}
	return 0;
}

validate_team_colors()
{
	new i;
	while (i < 6)
	{
		new color_client = ColorSlotArray[i];
		if (0 < color_client)
		{
			new var1;
			if (IsClientInGame(color_client) && color_client != GetClientTeam(color_client))
			{
				find_player_team_slot(i);
			}
		}
		else
		{
			new var2;
			if (i == 2 || i == 3)
			{
				find_player_team_slot(i);
			}
		}
		i++;
	}
	return 0;
}

public native_color_gameme_entities(Handle:plugin, numParams)
{
	if (numParams < 1)
	{
		return 0;
	}
	new message_length;
	GetNativeStringLength(1, message_length);
	if (0 >= message_length)
	{
		return 0;
	}
	new message[message_length + 1];
	GetNativeString(1, message, message_length + 1, 0);
	color_gameme_entities(message);
	SetNativeString(1, message, strlen(message) + 1, true, 0);
	return 1;
}

color_gameme_entities(String:message[])
{
	ReplaceString(message, 192, "x08", "\x08", true);
	ReplaceString(message, 192, "x07", "\x07", true);
	ReplaceString(message, 192, "x05", "\x05", true);
	ReplaceString(message, 192, "x04", "\x04", true);
	ReplaceString(message, 192, "x03", "\x03", true);
	ReplaceString(message, 192, "x01", "\x01", true);
	ReplaceString(message, 192, "x||0", "x0", true);
	return 0;
}

public void:OnClientDisconnect(client)
{
	if (0 < client)
	{
		new var1;
		if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1 || gameme_plugin[0] == 2 || gameme_plugin[0] == 5 || gameme_plugin[0] == 6 || gameme_plugin[0] == 7 || gameme_plugin[0] == 3 || gameme_plugin[0] == 4 || gameme_plugin[0] == 10)
		{
			dump_player_data(client);
			reset_player_data(client);
		}
		if (IsClientInGame(client))
		{
			new var2;
			if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1 || gameme_plugin[0] == 3 || gameme_plugin[0] == 4 || gameme_plugin[0] == 5 || gameme_plugin[0] == 6 || gameme_plugin[0] == 7)
			{
				new team_index = GetClientTeam(client);
				if (ColorSlotArray[team_index] == client)
				{
					ColorSlotArray[team_index] = -1;
				}
			}
		}
		new var3;
		if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1)
		{
			if (gameme_players[client][11])
			{
				KillTimer(gameme_players[client][11], false);
				gameme_players[client][11] = 0;
			}
			new j;
			while (j <= 65)
			{
				player_messages[j][client][255] = 1;
				strcopy(player_messages[j][client], 255, "");
				j++;
			}
		}
	}
	return void:0;
}

public native_display_menu(Handle:plugin, numParams)
{
	if (numParams < 4)
	{
		return 0;
	}
	new client = GetNativeCell(1);
	new time = GetNativeCell(2);
	new message_length;
	GetNativeStringLength(3, message_length);
	if (0 >= message_length)
	{
		return 0;
	}
	new message[message_length + 1];
	GetNativeString(3, message, message_length + 1, 0);
	new handler = GetNativeCell(4);
	display_menu(client, time, message, handler);
	return 0;
}

display_menu(player_index, time, String:full_message[], need_handler)
{
	ReplaceString(full_message, 1024, "\n", "\n", true);
	if (need_handler)
	{
		InternalShowMenu(player_index, full_message, time, 1023, InternalMenuHandler);
	}
	else
	{
		InternalShowMenu(player_index, full_message, time, -1, MenuHandler:-1);
	}
	return 0;
}

public InternalMenuHandler(Handle:menu, MenuAction:action, param1, param2)
{
	new client = param1;
	if (IsClientInGame(client))
	{
		if (action == MenuAction:4)
		{
			decl String:player_event[192];
			IntToString(param2, player_event, 192);
			log_player_event(client, "selected", player_event, 0, 0);
		}
		if (action == MenuAction:8)
		{
			new String:player_event[192] = "cancel";
			log_player_event(client, "selected", player_event, 0, 0);
		}
	}
	return 0;
}

get_param(index, argument_count)
{
	decl String:param[128];
	if (index <= argument_count)
	{
		GetCmdArg(index, param, 128);
		return StringToInt(param, 10);
	}
	return -1;
}

get_query_id()
{
	global_query_id += 1;
	if (global_query_id > 65535)
	{
		global_query_id = 1;
	}
	return global_query_id;
}

find_callback(query_id)
{
	new index = -1;
	new size = GetArraySize(QueryCallbackArray);
	new i;
	while (i < size)
	{
		decl data[7];
		GetArrayArray(QueryCallbackArray, i, data, 7);
		new var1;
		if (query_id == data[0] && data[3] && data[4] != -1)
		{
			index = i;
			return index;
		}
		i++;
	}
	return index;
}

public native_query_gameme_stats(Handle:plugin, numParams)
{
	if (numParams < 4)
	{
		return 0;
	}
	decl String:cb_type[256];
	GetNativeString(1, cb_type, 255, 0);
	new cb_client = GetNativeCell(2);
	new Function:cb_function = GetNativeCell(3);
	new cb_payload = GetNativeCell(4);
	new cb_limit = 1;
	if (numParams >= 5)
	{
		cb_limit = GetNativeCell(5);
	}
	if (cb_client < 1)
	{
		new queryid = get_query_id();
		decl data[7];
		data[0] = queryid;
		data[1] = GetGameTime();
		data[2] = cb_client;
		data[3] = plugin;
		data[4] = cb_function;
		data[5] = cb_payload;
		data[6] = cb_limit;
		if (QueryCallbackArray)
		{
			PushArrayArray(QueryCallbackArray, data, -1);
		}
		new String:query_payload[32];
		IntToString(queryid, query_payload, 32);
		log_player_settings(cb_client, "requested", cb_type, query_payload);
	}
	else
	{
		if (IsClientInGame(cb_client))
		{
			new userid = GetClientUserId(cb_client);
			if (0 < userid)
			{
				new queryid = get_query_id();
				decl data[7];
				data[0] = queryid;
				data[1] = GetGameTime();
				data[2] = cb_client;
				data[3] = plugin;
				data[4] = cb_function;
				data[5] = cb_payload;
				data[6] = cb_limit;
				if (QueryCallbackArray)
				{
					PushArrayArray(QueryCallbackArray, data, -1);
					new String:query_payload[32];
					IntToString(queryid, query_payload, 32);
					log_player_settings(cb_client, "requested", cb_type, query_payload);
				}
			}
		}
	}
	return 0;
}

public Action:gameme_raw_message(args)
{
	if (args < 1)
	{
		PrintToServer("Usage: gameme_raw_message <type><array> - retrieve internal gameME Stats data");
		return Action:3;
	}
	new argument_count = GetCmdArgs();
	new type = get_param(1, argument_count);
	switch (type)
	{
		case 1, 2, 3, 4, 101:
		{
			if (argument_count >= 48)
			{
				new query_id = get_param(2, argument_count);
				new userid = get_param(3, argument_count);
				new client = GetClientOfUserId(userid);
				if (0 < client)
				{
					new Handle:pack = CreateDataPack();
					WritePackCell(pack, get_param(4, argument_count));
					WritePackCell(pack, get_param(5, argument_count));
					WritePackCell(pack, get_param(6, argument_count));
					WritePackCell(pack, get_param(7, argument_count));
					WritePackCell(pack, get_param(8, argument_count));
					decl String:kpd_param[16];
					GetCmdArg(9, kpd_param, 16);
					WritePackFloat(pack, StringToFloat(kpd_param));
					WritePackCell(pack, get_param(10, argument_count));
					WritePackCell(pack, get_param(11, argument_count));
					decl String:hpk_param[16];
					GetCmdArg(12, hpk_param, 16);
					WritePackFloat(pack, StringToFloat(hpk_param));
					decl String:acc_param[16];
					GetCmdArg(13, acc_param, 16);
					WritePackFloat(pack, StringToFloat(acc_param));
					WritePackCell(pack, get_param(14, argument_count));
					WritePackCell(pack, get_param(15, argument_count));
					WritePackCell(pack, get_param(16, argument_count));
					WritePackCell(pack, get_param(17, argument_count));
					WritePackCell(pack, get_param(18, argument_count));
					WritePackCell(pack, get_param(19, argument_count));
					WritePackCell(pack, get_param(20, argument_count));
					WritePackCell(pack, get_param(21, argument_count));
					WritePackCell(pack, get_param(22, argument_count));
					WritePackCell(pack, get_param(23, argument_count));
					WritePackCell(pack, get_param(24, argument_count));
					WritePackCell(pack, get_param(25, argument_count));
					decl String:session_kpd_param[16];
					GetCmdArg(26, session_kpd_param, 16);
					WritePackFloat(pack, StringToFloat(session_kpd_param));
					WritePackCell(pack, get_param(27, argument_count));
					WritePackCell(pack, get_param(28, argument_count));
					decl String:session_hpk_param[16];
					GetCmdArg(29, session_hpk_param, 16);
					WritePackFloat(pack, StringToFloat(hpk_param));
					decl String:session_acc_param[16];
					GetCmdArg(30, session_acc_param, 16);
					WritePackFloat(pack, StringToFloat(session_acc_param));
					WritePackCell(pack, get_param(31, argument_count));
					WritePackCell(pack, get_param(32, argument_count));
					WritePackCell(pack, get_param(33, argument_count));
					WritePackCell(pack, get_param(34, argument_count));
					WritePackCell(pack, get_param(35, argument_count));
					WritePackCell(pack, get_param(36, argument_count));
					WritePackCell(pack, get_param(37, argument_count));
					WritePackCell(pack, get_param(38, argument_count));
					new String:session_fav_weapon[32] = "No Fav Weapon";
					GetCmdArg(39, session_fav_weapon, 32);
					if (!(StrEqual(session_fav_weapon, "-", true)))
					{
					}
					WritePackString(pack, session_fav_weapon);
					WritePackCell(pack, get_param(40, argument_count));
					WritePackCell(pack, get_param(41, argument_count));
					WritePackCell(pack, get_param(42, argument_count));
					WritePackCell(pack, get_param(43, argument_count));
					decl String:global_kpd_param[16];
					GetCmdArg(44, global_kpd_param, 16);
					WritePackFloat(pack, StringToFloat(global_kpd_param));
					WritePackCell(pack, get_param(45, argument_count));
					decl String:global_hpk_param[16];
					GetCmdArg(46, global_hpk_param, 16);
					WritePackFloat(pack, StringToFloat(global_hpk_param));
					decl String:country_code[16];
					GetCmdArg(47, country_code, 16);
					WritePackString(pack, country_code);
					decl Action:result;
					if (type == 101)
					{
						if (0 < query_id)
						{
							new cb_array_index = find_callback(query_id);
							if (0 <= cb_array_index)
							{
								decl data[7];
								GetArrayArray(QueryCallbackArray, cb_array_index, data, 7);
								new var9;
								if (data[3] && data[4] != -1)
								{
									Call_StartFunction(data[3], data[4]);
									Call_PushCell(any:101);
									Call_PushCell(data[5]);
									Call_PushCell(client);
									Call_PushCellRef(pack);
									Call_Finish(result);
									if (data[6] == 1)
									{
										RemoveFromArray(QueryCallbackArray, cb_array_index);
									}
								}
							}
						}
					}
					else
					{
						switch (type)
						{
							case 1:
							{
								Call_StartForward(gameMEStatsRankForward);
								Call_PushCell(any:1);
							}
							case 2:
							{
								Call_StartForward(gameMEStatsPublicCommandForward);
								Call_PushCell(any:2);
							}
							case 3:
							{
								Call_StartForward(gameMEStatsPublicCommandForward);
								Call_PushCell(any:3);
							}
							case 4:
							{
								Call_StartForward(gameMEStatsPublicCommandForward);
								Call_PushCell(any:4);
							}
							default:
							{
							}
						}
						Call_PushCell(client);
						Call_PushString(4364 + 148);
						Call_PushCellRef(pack);
						Call_Finish(result);
					}
					CloseHandle(pack);
				}
			}
		}
		case 5, 102:
		{
			if (argument_count >= 4)
			{
				new query_id = get_param(2, argument_count);
				new userid = get_param(3, argument_count);
				new var4;
				if ((userid > 0 && type == 5) || (userid == -1 && type == 102))
				{
					new client = GetClientOfUserId(userid);
					new var7;
					if (client < 1 && type == 5)
					{
						return Action:3;
					}
					new Handle:pack = CreateDataPack();
					if (argument_count == 4)
					{
						WritePackCell(pack, any:-1);
					}
					else
					{
						new count;
						new i = 4;
						while (i <= argument_count)
						{
							if (i + 3 <= argument_count)
							{
								count++;
								i += 3;
							}
							i++;
						}
						WritePackCell(pack, count);
						new rank;
						new i = 4;
						while (i <= argument_count)
						{
							if (i + 3 <= argument_count)
							{
								rank++;
								WritePackCell(pack, rank);
								WritePackCell(pack, get_param(i, argument_count));
								decl String:name[64];
								GetCmdArg(i + 1, name, 64);
								WritePackString(pack, name);
								decl String:kpd_param[16];
								GetCmdArg(i + 2, kpd_param, 16);
								WritePackFloat(pack, StringToFloat(kpd_param));
								decl String:hpk_param[16];
								GetCmdArg(i + 3, hpk_param, 16);
								WritePackFloat(pack, StringToFloat(hpk_param));
								i += 3;
							}
							i++;
						}
					}
					decl Action:result;
					if (type == 102)
					{
						if (0 < query_id)
						{
							new cb_array_index = find_callback(query_id);
							if (0 <= cb_array_index)
							{
								decl data[7];
								GetArrayArray(QueryCallbackArray, cb_array_index, data, 7);
								new var8;
								if (data[3] && data[4] != -1)
								{
									Call_StartFunction(data[3], data[4]);
									Call_PushCell(any:102);
									Call_PushCell(data[5]);
									Call_PushCellRef(pack);
									Call_Finish(result);
									if (data[6] == 1)
									{
										RemoveFromArray(QueryCallbackArray, cb_array_index);
									}
								}
							}
						}
					}
					else
					{
						Call_StartForward(gameMEStatsTop10Forward);
						Call_PushCell(any:5);
						Call_PushCell(client);
						Call_PushString(4364 + 148);
						Call_PushCellRef(pack);
						Call_Finish(result);
					}
					CloseHandle(pack);
				}
			}
		}
		case 6, 103:
		{
			if (argument_count >= 4)
			{
				new query_id = get_param(2, argument_count);
				new userid = get_param(3, argument_count);
				new client = GetClientOfUserId(userid);
				if (0 < client)
				{
					new Handle:pack = CreateDataPack();
					if (argument_count == 4)
					{
						WritePackCell(pack, any:-1);
					}
					else
					{
						new count;
						new i = 4;
						while (i <= argument_count)
						{
							if (i + 4 <= argument_count)
							{
								count++;
								i += 4;
							}
							i++;
						}
						WritePackCell(pack, count);
						new i = 4;
						while (i <= argument_count)
						{
							if (i + 4 <= argument_count)
							{
								WritePackCell(pack, get_param(i, argument_count));
								WritePackCell(pack, get_param(i + 1, argument_count));
								decl String:name[64];
								GetCmdArg(i + 2, name, 64);
								WritePackString(pack, name);
								decl String:kpd_param[16];
								GetCmdArg(i + 3, kpd_param, 16);
								WritePackFloat(pack, StringToFloat(kpd_param));
								decl String:hpk_param[16];
								GetCmdArg(i + 4, hpk_param, 16);
								WritePackFloat(pack, StringToFloat(hpk_param));
								i += 4;
							}
							i++;
						}
					}
					decl Action:result;
					if (type == 103)
					{
						if (0 < query_id)
						{
							new cb_array_index = find_callback(query_id);
							if (0 <= cb_array_index)
							{
								decl data[7];
								GetArrayArray(QueryCallbackArray, cb_array_index, data, 7);
								new var3;
								if (data[3] && data[4] != -1)
								{
									Call_StartFunction(data[3], data[4]);
									Call_PushCell(any:103);
									Call_PushCell(data[5]);
									Call_PushCell(client);
									Call_PushCellRef(pack);
									Call_Finish(result);
									if (data[6] == 1)
									{
										RemoveFromArray(QueryCallbackArray, cb_array_index);
									}
								}
							}
						}
					}
					else
					{
						Call_StartForward(gameMEStatsNextForward);
						Call_PushCell(any:6);
						Call_PushCell(client);
						Call_PushString(4364 + 148);
						Call_PushCellRef(pack);
						Call_Finish(result);
					}
					CloseHandle(pack);
				}
			}
		}
		case 1000:
		{
			if (argument_count >= 2)
			{
				new query_id = get_param(2, argument_count);
				new cb_array_index = find_callback(query_id);
				if (0 <= cb_array_index)
				{
					RemoveFromArray(QueryCallbackArray, cb_array_index);
				}
			}
		}
		case 1001:
		{
			if (argument_count >= 5)
			{
				new query_id = get_param(2, argument_count);
				decl caller[66];
				decl String:caller_id[512];
				GetCmdArg(3, caller_id, 512);
				if (StrContains(caller_id, ",", true) > -1)
				{
					decl CallerRecipients[MaxClients][16];
					new recipient_count = ExplodeString(caller_id, ",", CallerRecipients, MaxClients, 16, false);
					new i;
					while (i < recipient_count)
					{
						caller[i] = GetClientOfUserId(StringToInt(CallerRecipients[i], 10));
						i++;
					}
				}
				else
				{
					caller[0] = GetClientOfUserId(StringToInt(caller_id, 10));
				}
				decl target[66];
				decl String:target_id[512];
				GetCmdArg(4, target_id, 512);
				if (StrContains(target_id, ",", true) > -1)
				{
					decl TargetRecipients[MaxClients][16];
					new recipient_count = ExplodeString(target_id, ",", TargetRecipients, MaxClients, 16, false);
					new i;
					while (i < recipient_count)
					{
						target[i] = GetClientOfUserId(StringToInt(TargetRecipients[i], 10));
						i++;
					}
				}
				else
				{
					target[0] = GetClientOfUserId(StringToInt(target_id, 10));
				}
				new var1;
				if (caller[0] > -1 && target[0] > -1 && query_id > 0)
				{
					decl String:message[1024];
					GetCmdArg(5, message, 1024);
					new cb_array_index = find_callback(query_id);
					if (0 <= cb_array_index)
					{
						decl data[7];
						GetArrayArray(QueryCallbackArray, cb_array_index, data, 7);
						new var2;
						if (data[3] && data[4] != -1)
						{
							decl Action:result;
							Call_StartFunction(data[3], data[4]);
							Call_PushCell(any:1001);
							Call_PushCell(data[5]);
							Call_PushArray(caller, 66);
							Call_PushArray(target, 66);
							Call_PushString(4364 + 148);
							Call_PushString(message);
							Call_Finish(result);
							if (data[6] == 1)
							{
								RemoveFromArray(QueryCallbackArray, cb_array_index);
							}
						}
					}
				}
			}
		}
		default:
		{
		}
	}
	return Action:3;
}

public Action:gameme_psay(args)
{
	if (args < 2)
	{
		PrintToServer("Usage: gameme_psay <userid><colored><message> - sends private message");
		return Action:3;
	}
	decl String:client_id[192];
	GetCmdArg(1, client_id, 192);
	if (StrContains(client_id, ",", true) > -1)
	{
		decl MessageRecipients[MaxClients][16];
		new recipient_count = ExplodeString(client_id, ",", MessageRecipients, MaxClients, 16, false);
		new i;
		while (i < recipient_count)
		{
			PushStackCell(gameme_plugin[108], StringToInt(MessageRecipients[i], 10));
			i++;
		}
	}
	else
	{
		PushStackCell(gameme_plugin[108], StringToInt(client_id, 10));
	}
	decl String:colored_param[32];
	GetCmdArg(2, colored_param, 32);
	new is_colored;
	new ignore_param;
	if (strcmp(colored_param, "1", true))
	{
		if (strcmp(colored_param, "2", true))
		{
			if (strcmp(colored_param, "3", true))
			{
				if (!(strcmp(colored_param, "0", true)))
				{
					ignore_param = 1;
				}
			}
			is_colored = 3;
			ignore_param = 1;
		}
		is_colored = 2;
		ignore_param = 1;
	}
	else
	{
		is_colored = 1;
		ignore_param = 1;
	}
	decl String:argument_string[1024];
	GetCmdArgString(argument_string, 1024);
	new copy_start_length = strlen(client_id) + 3;
	if (ignore_param == 1)
	{
		copy_start_length = strlen(colored_param) + 1 + copy_start_length;
	}
	copy_start_length += 1;
	new String:client_message[192];
	strcopy(client_message, 192, argument_string[copy_start_length]);
	while (strlen(client_message) > 0 && client_message[strlen(client_message) + -1] == '"')
	{
		client_message[strlen(client_message) + -1] = MissingTAG:0;
	}
	if (!(IsStackEmpty(gameme_plugin[108])))
	{
		new color_index = -1;
		new var2;
		if (gameme_plugin[0] == 11 || gameme_plugin[0] == 1 || gameme_plugin[0] == 2 || gameme_plugin[0] == 3 || gameme_plugin[0] == 4 || gameme_plugin[0] == 5 || gameme_plugin[0] == 6 || gameme_plugin[0] == 7)
		{
			if (is_colored > 1)
			{
				validate_team_colors();
				if (is_colored == 2)
				{
					if (ColorSlotArray[2] > -1)
					{
						color_index = ColorSlotArray[2];
					}
				}
				else
				{
					if (is_colored == 3)
					{
						if (ColorSlotArray[3] > -1)
						{
							color_index = ColorSlotArray[3];
						}
					}
				}
				color_gameme_entities(client_message);
			}
			else
			{
				if (is_colored == 1)
				{
					color_gameme_entities(client_message);
				}
			}
			new bool:setupColorForRecipients;
			if (color_index == -1)
			{
				setupColorForRecipients = true;
			}
			while (IsStackEmpty(gameme_plugin[108]))
			{
				new recipient_client = -1;
				PopStackCell(gameme_plugin[108], recipient_client, 0, false);
				new player_index = GetClientOfUserId(recipient_client);
				new var3;
				if (player_index > 0 && !IsFakeClient(player_index) && IsClientInGame(player_index))
				{
					if (setupColorForRecipients == true)
					{
						color_index = player_index;
					}
					if (!(gameme_plugin[0] == 2))
					{
						new Handle:message_handle = StartMessageOne("SayText2", player_index, 0);
						if (message_handle)
						{
							if (gameme_plugin[159] == 1)
							{
								PbSetInt(message_handle, "ent_idx", color_index, -1);
								PbSetBool(message_handle, "chat", false, -1);
								PbSetString(message_handle, "msg_name", client_message, -1);
								PbAddString(message_handle, "params", "");
								PbAddString(message_handle, "params", "");
								PbAddString(message_handle, "params", "");
								PbAddString(message_handle, "params", "");
							}
							else
							{
								BfWriteByte(message_handle, color_index);
								BfWriteByte(message_handle, 0);
								BfWriteString(message_handle, client_message);
							}
							EndMessage();
						}
					}
				}
			}
		}
	}
	return Action:3;
}

public Action:gameme_csay(args)
{
	if (args < 1)
	{
		PrintToServer("Usage: gameme_csay <message> - display center message");
		return Action:3;
	}
	new String:display_message[192];
	GetCmdArg(1, display_message, 192);
	if (strcmp(display_message, "", true))
	{
		PrintCenterTextAll(display_message);
	}
	return Action:3;
}

public Action:gameme_msay(args)
{
	if (args < 3)
	{
		PrintToServer("Usage: gameme_msay <time><userid><message> - sends hud message");
		return Action:3;
	}
	if (gameme_plugin[0] == 3)
	{
		return Action:3;
	}
	decl String:display_time[16];
	GetCmdArg(1, display_time, 16);
	decl String:client_id[32];
	GetCmdArg(2, client_id, 32);
	decl String:handler_param[32];
	GetCmdArg(3, handler_param, 32);
	new need_handler;
	new var1;
	if (strcmp(handler_param, "1", true) && strcmp(handler_param, "0", true))
	{
		need_handler = 1;
	}
	decl String:argument_string[1024];
	GetCmdArgString(argument_string, 1024);
	new copy_start_length = strlen(client_id) + strlen(display_time) + 3 + 3;
	if (need_handler == 1)
	{
		copy_start_length += 2;
	}
	copy_start_length += 1;
	new String:client_message[1024];
	strcopy(client_message, 1024, argument_string[copy_start_length]);
	while (strlen(client_message) > 0 && client_message[strlen(client_message) + -1] == '"')
	{
		client_message[strlen(client_message) + -1] = MissingTAG:0;
	}
	new time = StringToInt(display_time, 10);
	if (0 >= time)
	{
		time = 10;
	}
	new client = StringToInt(client_id, 10);
	if (0 < client)
	{
		new player_index = GetClientOfUserId(client);
		new var3;
		if (player_index > 0 && !IsFakeClient(player_index) && IsClientInGame(player_index))
		{
			if (strcmp(client_message, "", true))
			{
				display_menu(player_index, time, client_message, need_handler);
			}
		}
	}
	return Action:3;
}

public Action:gameme_tsay(args)
{
	if (args < 3)
	{
		PrintToServer("Usage: gameme_tsay <time><userid><message> - sends hud message");
		return Action:3;
	}
	decl String:display_time[16];
	GetCmdArg(1, display_time, 16);
	decl String:client_id[32];
	GetCmdArg(2, client_id, 32);
	decl String:argument_string[1024];
	GetCmdArgString(argument_string, 1024);
	new copy_start_length = strlen(client_id) + strlen(display_time) + 3 + 3;
	copy_start_length += 1;
	new String:client_message[192];
	strcopy(client_message, 192, argument_string[copy_start_length]);
	while (strlen(client_message) > 0 && client_message[strlen(client_message) + -1] == '"')
	{
		client_message[strlen(client_message) + -1] = MissingTAG:0;
	}
	new client = StringToInt(client_id, 10);
	new var2;
	if (client > 0 && strcmp(client_message, "", true))
	{
		new player_index = GetClientOfUserId(client);
		new var3;
		if (player_index > 0 && !IsFakeClient(player_index) && IsClientInGame(player_index))
		{
			new Handle:values = CreateKeyValues("msg", "", "");
			KvSetString(values, "title", client_message);
			KvSetNum(values, "level", 1);
			KvSetString(values, "time", display_time);
			CreateDialog(player_index, values, DialogType:0);
			CloseHandle(values);
		}
	}
	return Action:3;
}

public Action:gameme_hint(args)
{
	if (args < 2)
	{
		PrintToServer("Usage: gameme_hint <userid><message> - send hint message");
		return Action:3;
	}
	if (gameme_plugin[0] == 3)
	{
		return Action:3;
	}
	decl String:client_id[512];
	GetCmdArg(1, client_id, 512);
	if (StrContains(client_id, ",", true) > -1)
	{
		decl MessageRecipients[MaxClients][16];
		new recipient_count = ExplodeString(client_id, ",", MessageRecipients, MaxClients, 16, false);
		new i;
		while (i < recipient_count)
		{
			PushStackCell(gameme_plugin[108], StringToInt(MessageRecipients[i], 10));
			i++;
		}
	}
	else
	{
		PushStackCell(gameme_plugin[108], StringToInt(client_id, 10));
	}
	decl String:argument_string[1024];
	GetCmdArgString(argument_string, 1024);
	new copy_start_length = strlen(client_id) + 3;
	copy_start_length++;
	new String:client_message[192];
	strcopy(client_message, 192, argument_string[copy_start_length]);
	while (strlen(client_message) > 0 && client_message[strlen(client_message) + -1] == '"')
	{
		client_message[strlen(client_message) + -1] = MissingTAG:0;
	}
	if (!(IsStackEmpty(gameme_plugin[108])))
	{
		if (strcmp(client_message, "", true))
		{
			while (IsStackEmpty(gameme_plugin[108]))
			{
				new recipient_client = -1;
				PopStackCell(gameme_plugin[108], recipient_client, 0, false);
				new player_index = GetClientOfUserId(recipient_client);
				new var2;
				if (player_index > 0 && !IsFakeClient(player_index) && IsClientInGame(player_index))
				{
					PrintHintText(player_index, client_message);
				}
			}
		}
	}
	return Action:3;
}

public Action:gameme_khint(args)
{
	if (args < 2)
	{
		PrintToServer("Usage: gameme_khint <userid><message> - send khint message");
		return Action:3;
	}
	decl String:client_id[512];
	GetCmdArg(1, client_id, 512);
	if (StrContains(client_id, ",", true) > -1)
	{
		decl MessageRecipients[MaxClients][16];
		new recipient_count = ExplodeString(client_id, ",", MessageRecipients, MaxClients, 16, false);
		new i;
		while (i < recipient_count)
		{
			PushStackCell(gameme_plugin[108], StringToInt(MessageRecipients[i], 10));
			i++;
		}
	}
	else
	{
		PushStackCell(gameme_plugin[108], StringToInt(client_id, 10));
	}
	decl String:argument_string[1024];
	GetCmdArgString(argument_string, 1024);
	new copy_start_length = strlen(client_id) + 3;
	copy_start_length++;
	new String:client_message[256];
	strcopy(client_message, 255, argument_string[copy_start_length]);
	while (strlen(client_message) > 0 && client_message[strlen(client_message) + -1] == '"')
	{
		client_message[strlen(client_message) + -1] = MissingTAG:0;
	}
	ReplaceString(client_message, 255, "\n", "\n", true);
	if (!(IsStackEmpty(gameme_plugin[108])))
	{
		if (strcmp(client_message, "", true))
		{
			while (IsStackEmpty(gameme_plugin[108]))
			{
				new recipient_client = -1;
				PopStackCell(gameme_plugin[108], recipient_client, 0, false);
				new player_index = GetClientOfUserId(recipient_client);
				new var2;
				if (player_index > 0 && !IsFakeClient(player_index) && IsClientInGame(player_index))
				{
					new Handle:message_handle = StartMessageOne("KeyHintText", player_index, 0);
					if (message_handle)
					{
						if (gameme_plugin[159] == 1)
						{
							PbAddString(message_handle, "hints", client_message);
						}
						else
						{
							BfWriteByte(message_handle, 1);
							BfWriteString(message_handle, client_message);
						}
						EndMessage();
					}
				}
			}
		}
	}
	return Action:3;
}

public Action:gameme_browse(args)
{
	if (args < 2)
	{
		PrintToServer("Usage: gameme_browse <userid><url> - open client ingame browser");
		return Action:3;
	}
	decl String:client_id[512];
	GetCmdArg(1, client_id, 512);
	if (StrContains(client_id, ",", true) > -1)
	{
		decl MessageRecipients[MaxClients][16];
		new recipient_count = ExplodeString(client_id, ",", MessageRecipients, MaxClients, 16, false);
		new i;
		while (i < recipient_count)
		{
			PushStackCell(gameme_plugin[108], StringToInt(MessageRecipients[i], 10));
			i++;
		}
	}
	else
	{
		PushStackCell(gameme_plugin[108], StringToInt(client_id, 10));
	}
	new String:client_url[192];
	GetCmdArg(2, client_url, 192);
	if (!(IsStackEmpty(gameme_plugin[108])))
	{
		if (strcmp(client_url, "", true))
		{
			while (IsStackEmpty(gameme_plugin[108]))
			{
				new recipient_client = -1;
				PopStackCell(gameme_plugin[108], recipient_client, 0, false);
				new player_index = GetClientOfUserId(recipient_client);
				new var1;
				if (player_index > 0 && !IsFakeClient(player_index) && IsClientInGame(player_index))
				{
					ShowMOTDPanel(player_index, "gameME", client_url, 2);
				}
			}
		}
	}
	return Action:3;
}

public Action:gameme_swap(args)
{
	if (args < 1)
	{
		PrintToServer("Usage: gameme_swap <userid> - swaps players to the opposite team (css only)");
		return Action:3;
	}
	if (gameme_plugin[0] != 1)
	{
		return Action:3;
	}
	decl String:client_id[32];
	GetCmdArg(1, client_id, 32);
	new client = StringToInt(client_id, 10);
	if (0 < client)
	{
		new player_index = GetClientOfUserId(client);
		new var1;
		if (player_index > 0 && IsClientInGame(player_index))
		{
			swap_player(player_index);
		}
	}
	return Action:3;
}

public Action:gameme_redirect(args)
{
	if (args < 3)
	{
		PrintToServer("Usage: gameme_redirect <time><userid><address><reason> - asks player to be redirected to specified gameserver");
		return Action:3;
	}
	decl String:display_time[16];
	GetCmdArg(1, display_time, 16);
	decl String:client_id[512];
	GetCmdArg(2, client_id, 512);
	if (StrContains(client_id, ",", true) > -1)
	{
		decl MessageRecipients[MaxClients][16];
		new recipient_count = ExplodeString(client_id, ",", MessageRecipients, MaxClients, 16, false);
		new i;
		while (i < recipient_count)
		{
			PushStackCell(gameme_plugin[108], StringToInt(MessageRecipients[i], 10));
			i++;
		}
	}
	else
	{
		PushStackCell(gameme_plugin[108], StringToInt(client_id, 10));
	}
	new String:server_address[192];
	GetCmdArg(3, server_address, 192);
	decl String:argument_string[1024];
	GetCmdArgString(argument_string, 1024);
	new copy_start_length = strlen(server_address) + strlen(client_id) + strlen(display_time) + 3 + 3 + 3;
	copy_start_length++;
	new String:redirect_reason[192];
	strcopy(redirect_reason, 192, argument_string[copy_start_length]);
	while (strlen(redirect_reason) > 0 && redirect_reason[strlen(redirect_reason) + -1] == '"')
	{
		redirect_reason[strlen(redirect_reason) + -1] = MissingTAG:0;
	}
	if (!(IsStackEmpty(gameme_plugin[108])))
	{
		if (strcmp(server_address, "", true))
		{
			while (IsStackEmpty(gameme_plugin[108]))
			{
				new recipient_client = -1;
				PopStackCell(gameme_plugin[108], recipient_client, 0, false);
				new player_index = GetClientOfUserId(recipient_client);
				new var2;
				if (player_index > 0 && !IsFakeClient(player_index) && IsClientInGame(player_index))
				{
					new Handle:top_values = CreateKeyValues("msg", "", "");
					KvSetString(top_values, "title", redirect_reason);
					KvSetNum(top_values, "level", 1);
					KvSetString(top_values, "time", display_time);
					CreateDialog(player_index, top_values, DialogType:0);
					CloseHandle(top_values);
					new Float:display_time_float = StringToFloat(display_time);
					DisplayAskConnectBox(player_index, display_time_float, server_address, "");
				}
			}
		}
	}
	return Action:3;
}

public Action:gameme_player_action(args)
{
	if (args < 2)
	{
		PrintToServer("Usage: gameme_player_action <client><action> - trigger player action to be handled from gameME");
		return Action:3;
	}
	decl String:client_id[32];
	GetCmdArg(1, client_id, 32);
	decl String:player_action[192];
	GetCmdArg(2, player_action, 192);
	new client = StringToInt(client_id, 10);
	if (0 < client)
	{
		log_player_event(client, "triggered", player_action, 0, 0);
	}
	return Action:3;
}

public Action:gameme_team_action(args)
{
	if (args < 2)
	{
		PrintToServer("Usage: gameme_team_action <team_name><action>(objective) - trigger team action to be handled from gameME");
		return Action:3;
	}
	decl String:team_name[32];
	GetCmdArg(1, team_name, 32);
	decl String:team_action[192];
	GetCmdArg(2, team_action, 192);
	if (args > 2)
	{
		decl String:team_objective[192];
		GetCmdArg(3, team_objective, 192);
		log_team_event(team_name, team_action, team_objective);
	}
	else
	{
		log_team_event(team_name, team_action, "");
	}
	return Action:3;
}

public Action:gameme_world_action(args)
{
	if (args < 1)
	{
		PrintToServer("Usage: gameme_world_action <action> - trigger world action to be handled from gameME");
		return Action:3;
	}
	decl String:world_action[192];
	GetCmdArg(1, world_action, 192);
	LogToGame("World triggered \"%s\"", world_action);
	return Action:3;
}

is_command_blocked(String:command[])
{
	new index;
	if (GetTrieValue(gameme_plugin[34], command, index))
	{
		return 1;
	}
	return 0;
}

public Action:gameme_block_commands(client, args)
{
	if (client)
	{
		if (client)
		{
			new block_chat_commands_enabled = GetConVarInt(gameme_plugin[33]);
			decl String:user_command[192];
			GetCmdArgString(user_command, 192);
			decl String:origin_command[192];
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
				strcopy(origin_command, 192, user_command[start_index]);
			}
			new String:command_type[32];
			if (0 < command_length)
			{
				if (0 < block_chat_commands_enabled)
				{
					if (IsClientInGame(client))
					{
						if (0 < is_command_blocked(user_command[start_index]))
						{
							new var1;
							if (strcmp("gameme", user_command[start_index], true) && strcmp("/gameme", user_command[start_index], true) && strcmp("!gameme", user_command[start_index], true) && strcmp("gameme_menu", user_command[start_index], true) && strcmp("/gameme_menu", user_command[start_index], true) && strcmp("!gameme_menu", user_command[start_index], true))
							{
								DisplayMenu(gameme_plugin[104], client, 0);
							}
							log_player_event(client, command_type, origin_command, 0, 0);
							return Action:4;
						}
						new var2;
						if (strcmp("gameme", user_command[start_index], true) && strcmp("/gameme", user_command[start_index], true) && strcmp("!gameme", user_command[start_index], true) && strcmp("gameme_menu", user_command[start_index], true) && strcmp("/gameme_menu", user_command[start_index], true) && strcmp("!gameme_menu", user_command[start_index], true))
						{
							DisplayMenu(gameme_plugin[104], client, 0);
						}
					}
				}
				if (IsClientInGame(client))
				{
					new var3;
					if (strcmp("gameme", user_command[start_index], true) && strcmp("/gameme", user_command[start_index], true) && strcmp("!gameme", user_command[start_index], true) && strcmp("gameme_menu", user_command[start_index], true) && strcmp("/gameme_menu", user_command[start_index], true) && strcmp("!gameme_menu", user_command[start_index], true))
					{
						DisplayMenu(gameme_plugin[104], client, 0);
					}
				}
				return Action:0;
			}
		}
		return Action:0;
	}
	return Action:0;
}

public Action:gameME_Event_PlyDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < attacker)
	{
		new headshot = GetEventBool(event, "headshot", false);
		new var1;
		if ((gameme_plugin[0] == 11 || gameme_plugin[0] == 1 || gameme_plugin[0] == 9) && victim > 0)
		{
			if (headshot == 1)
			{
				new player_team_index = GetClientTeam(attacker);
				new victim_team_index = GetClientTeam(victim);
				if (player_team_index != victim_team_index)
				{
					log_player_event(attacker, "triggered", "headshot", 0, 0);
				}
			}
			new var3;
			if (gameme_plugin[146] == 1 && gameme_plugin[0] != 9)
			{
				if (victim != attacker)
				{
					log_player_location("kill", attacker, victim);
				}
				log_player_location("suicide", attacker, 0);
			}
		}
		new var4;
		if (gameme_plugin[0] == 5 || gameme_plugin[0] == 6)
		{
			if (headshot == 1)
			{
				log_player_event(attacker, "triggered", "headshot", 0, 0);
			}
			if (gameme_plugin[0] == 6)
			{
				decl String:weapon[32];
				GetEventString(event, "weapon", weapon, 32, "");
				if (strncmp(weapon, "melee", 5, true))
				{
				}
				else
				{
					new new_weapon_index = GetEntDataEnt2(attacker, l4dii_data[0]);
					if (IsValidEdict(new_weapon_index))
					{
						GetEdictClassname(new_weapon_index, weapon, 32);
						if (!(strncmp(weapon[1], "melee", 5, true)))
						{
							GetEntPropString(new_weapon_index, PropType:1, "m_strMapSetScriptName", weapon, 32, 0);
							SetEventString(event, "weapon", weapon);
						}
					}
				}
			}
		}
		if (gameme_plugin[0] == 3)
		{
			decl String:weapon[32];
			GetEventString(event, "weapon", weapon, 32, "");
			if (strcmp(weapon, "crossbow_bolt", true))
			{
				if (hl2mp_players[victim][0] == 1)
				{
					log_player_event(attacker, "triggered", "headshot", 0, 0);
				}
			}
			else
			{
				if (hl2mp_players[victim][1] == 1)
				{
					log_player_event(attacker, "triggered", "headshot", 0, 0);
				}
			}
		}
		if (gameme_plugin[0] == 10)
		{
			if (zps_players[victim][0] == 1)
			{
				log_player_event(attacker, "triggered", "headshot", 0, 0);
			}
		}
		if (gameme_plugin[0] == 4)
		{
			new customkill = GetEventInt(event, "customkill", 0);
			new weapon = GetEventInt(event, "weaponid", 0);
			switch (customkill)
			{
				case 17, 18:
				{
					decl String:log_weapon[64];
					GetEventString(event, "weapon_logclassname", log_weapon, 64, "");
					if (log_weapon[0] != 'd')
					{
						SetEventString(event, "weapon_logclassname", "tf_projectile_arrow_fire");
					}
				}
				case 29:
				{
					if (weapon == 11)
					{
						SetEventString(event, "weapon_logclassname", "taunt_medic");
						SetEventString(event, "weapon", "taunt_medic");
					}
				}
				case 41:
				{
					log_player_event(attacker, "triggered", "killed_by_horseman", 0, 0);
				}
				default:
				{
				}
			}
		}
		if (gameme_plugin[146] == 1)
		{
			new var5;
			if ((gameme_plugin[0] == 7 || gameme_plugin[0] == 3 || gameme_plugin[0] == 2) && victim > 0)
			{
				if (victim != attacker)
				{
					log_player_location("kill", attacker, victim);
				}
			}
		}
	}
	return Action:0;
}

public Action:gameME_Event_PlyTeamChange(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid", 0);
	if (0 < userid)
	{
		new player_index = GetClientOfUserId(userid);
		if (0 < player_index)
		{
			new i;
			while (i < 6)
			{
				new color_client = ColorSlotArray[i];
				if (color_client > -1)
				{
					if (player_index == color_client)
					{
						ColorSlotArray[i] = -1;
					}
				}
				i++;
			}
		}
	}
	return Action:0;
}

public Action:gameME_Event_PlyBombDropped(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		if (gameme_plugin[146] == 1)
		{
			log_player_location("Dropped_The_Bomb", player, 0);
		}
		if (gameme_plugin[151] == 1)
		{
			new i;
			while (i <= 65)
			{
				player_messages[i][player][255] = 1;
				i++;
			}
		}
	}
	return Action:0;
}

public Action:gameME_Event_PlyBombPickup(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		if (gameme_plugin[146] == 1)
		{
			log_player_location("Got_The_Bomb", player, 0);
		}
		if (gameme_plugin[151] == 1)
		{
			new i;
			while (i <= 65)
			{
				player_messages[i][player][255] = 1;
				i++;
			}
		}
	}
	return Action:0;
}

public Action:gameME_Event_PlyBombPlanted(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		if (gameme_plugin[146] == 1)
		{
			log_player_location("Planted_The_Bomb", player, 0);
		}
		if (gameme_plugin[151] == 1)
		{
			new i;
			while (i <= 65)
			{
				player_messages[i][player][255] = 1;
				i++;
			}
		}
	}
	return Action:0;
}

public Action:gameME_Event_PlyBombDefused(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		if (gameme_plugin[146] == 1)
		{
			log_player_location("Defused_The_Bomb", player, 0);
		}
		if (gameme_plugin[151] == 1)
		{
			new i;
			while (i <= 65)
			{
				player_messages[i][player][255] = 1;
				i++;
			}
		}
	}
	return Action:0;
}

public Action:gameME_Event_PlyHostageKill(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		if (gameme_plugin[146] == 1)
		{
			log_player_location("Killed_A_Hostage", player, 0);
		}
		if (gameme_plugin[151] == 1)
		{
			new i;
			while (i <= 65)
			{
				player_messages[i][player][255] = 1;
				i++;
			}
		}
	}
	return Action:0;
}

public Action:gameME_Event_PlyHostageResc(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		if (gameme_plugin[146] == 1)
		{
			log_player_location("Rescued_A_Hostage", player, 0);
		}
		if (gameme_plugin[151] == 1)
		{
			new i;
			while (i <= 65)
			{
				player_messages[i][player][255] = 1;
				i++;
			}
		}
	}
	return Action:0;
}

swap_player(player_index)
{
	if (IsClientInGame(player_index))
	{
		new player_team_index = GetClientTeam(player_index);
		decl String:player_team[32];
		new var1 = team_list[player_team_index];
		player_team = var1;
		if (strcmp(player_team, "CT", true))
		{
			if (!(strcmp(player_team, "TERRORIST", true)))
			{
				if (IsPlayerAlive(player_index))
				{
					CS_SwitchTeam(player_index, 3);
					CS_RespawnPlayer(player_index);
					new new_model = GetRandomInt(0, 3);
					SetEntityModel(player_index, css_ct_models[new_model]);
					new weapon_entity = GetPlayerWeaponSlot(player_index, 4);
					if (0 < weapon_entity)
					{
						decl String:class_name[32];
						GetEdictClassname(weapon_entity, class_name, 32);
						if (strcmp(class_name, "weapon_c4", true))
						{
						}
						else
						{
							RemovePlayerItem(player_index, weapon_entity);
						}
					}
				}
				CS_SwitchTeam(player_index, 3);
			}
		}
		else
		{
			if (IsPlayerAlive(player_index))
			{
				CS_SwitchTeam(player_index, 2);
				CS_RespawnPlayer(player_index);
				new new_model = GetRandomInt(0, 3);
				SetEntityModel(player_index, css_ts_models[new_model]);
			}
			else
			{
				CS_SwitchTeam(player_index, 2);
			}
		}
	}
	return 0;
}

public CreateGameMEMenuMain(&Handle:MenuHandle)
{
	MenuHandle = CreateMenu(gameMEMainCommandHandler, MenuAction:526);
	if (gameme_plugin[0] == 3)
	{
		SetMenuTitle(MenuHandle, "gameME - Main Menu");
		AddMenuItem(MenuHandle, "IngameMenu_Menu1", "Display Rank", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu2", "Next Players", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu3", "Top10 Players", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu4", "Auto Ranking", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu5", "Console Events", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu6", "Toggle Ranking Display", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu16", "Reset Statistics", 0);
	}
	else
	{
		SetMenuTitle(MenuHandle, "gameME - Main Menu");
		AddMenuItem(MenuHandle, "IngameMenu_Menu1", "Display Rank", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu2", "Next Players", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu3", "Top10 Players", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu7", "Clans Ranking", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu8", "Server Status", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu9", "Statsme", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu4", "Auto Ranking", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu5", "Console Events", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu10", "Weapon Usage", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu11", "Weapons Accuracy", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu12", "Weapons Targets", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu13", "Player Kills", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu6", "Toggle Ranking Display", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu16", "Reset Statistics", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu14", "VAC Cheaterlist", 0);
		AddMenuItem(MenuHandle, "IngameMenu_Menu15", "Display Help", 0);
	}
	SetMenuPagination(MenuHandle, 8);
	return 0;
}

public CreateGameMEMenuAuto(&Handle:MenuHandle)
{
	MenuHandle = CreateMenu(gameMEAutoCommandHandler, MenuAction:526);
	SetMenuTitle(MenuHandle, "gameME - Auto-Ranking");
	AddMenuItem(MenuHandle, "AutoMenu_Menu1", "Enable on round-start", 0);
	AddMenuItem(MenuHandle, "AutoMenu_Menu2", "Enable on round-end", 0);
	AddMenuItem(MenuHandle, "AutoMenu_Menu3", "Enable on player death", 0);
	AddMenuItem(MenuHandle, "AutoMenu_Menu4", "Disable", 0);
	SetMenuPagination(MenuHandle, 8);
	return 0;
}

public CreateGameMEMenuEvents(&Handle:MenuHandle)
{
	MenuHandle = CreateMenu(gameMEEventsCommandHandler, MenuAction:526);
	SetMenuTitle(MenuHandle, "gameME - Console Events");
	AddMenuItem(MenuHandle, "ConsoleMenu_Menu1", "Enable Events", 0);
	AddMenuItem(MenuHandle, "ConsoleMenu_Menu2", "Disable Events", 0);
	AddMenuItem(MenuHandle, "ConsoleMenu_Menu3", "Enable Global Chat", 0);
	AddMenuItem(MenuHandle, "ConsoleMenu_Menu4", "Disable Global Chat", 0);
	SetMenuPagination(MenuHandle, 8);
	return 0;
}

make_player_command(client, String:player_command[192])
{
	if (0 < client)
	{
		log_player_event(client, "say", player_command, 0, 0);
	}
	return 0;
}

public gameMEMainCommandHandler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:512)
	{
		decl String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		decl String:buffer[256];
		Format(buffer, 255, "%T", info, param1);
		return RedrawMenuItem(buffer);
	}
	if (action == MenuAction:2)
	{
		decl String:buffer[256];
		Format(buffer, 255, "%T", "IngameMenu_Caption", param1);
		new Handle:panel = param2;
		SetPanelTitle(panel, buffer, false);
	}
	else
	{
		if (action == MenuAction:4)
		{
			if (IsClientInGame(param1))
			{
				if (gameme_plugin[0] == 3)
				{
					switch (param2)
					{
						case 0:
						{
							make_player_command(param1, "/rank");
						}
						case 1:
						{
							make_player_command(param1, "/next");
						}
						case 2:
						{
							make_player_command(param1, "/top10");
						}
						case 3:
						{
							DisplayMenu(gameme_plugin[105], param1, 0);
						}
						case 4:
						{
							DisplayMenu(gameme_plugin[106], param1, 0);
						}
						case 5:
						{
							make_player_command(param1, "/gameme_hideranking");
						}
						case 6:
						{
							make_player_command(param1, "/gameme_reset");
						}
						default:
						{
						}
					}
				}
				switch (param2)
				{
					case 0:
					{
						make_player_command(param1, "/rank");
					}
					case 1:
					{
						make_player_command(param1, "/next");
					}
					case 2:
					{
						make_player_command(param1, "/top10");
					}
					case 3:
					{
						make_player_command(param1, "/clans");
					}
					case 4:
					{
						make_player_command(param1, "/status");
					}
					case 5:
					{
						make_player_command(param1, "/statsme");
					}
					case 6:
					{
						DisplayMenu(gameme_plugin[105], param1, 0);
					}
					case 7:
					{
						DisplayMenu(gameme_plugin[106], param1, 0);
					}
					case 8:
					{
						make_player_command(param1, "/weapons");
					}
					case 9:
					{
						make_player_command(param1, "/accuracy");
					}
					case 10:
					{
						make_player_command(param1, "/targets");
					}
					case 11:
					{
						make_player_command(param1, "/kills");
					}
					case 12:
					{
						make_player_command(param1, "/gameme_hideranking");
					}
					case 13:
					{
						make_player_command(param1, "/gameme_reset");
					}
					case 14:
					{
						make_player_command(param1, "/cheaters");
					}
					case 15:
					{
						make_player_command(param1, "/help");
					}
					default:
					{
					}
				}
			}
		}
	}
	return 0;
}

public gameMEAutoCommandHandler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:512)
	{
		decl String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		decl String:buffer[256];
		Format(buffer, 255, "%T", info, param1);
		return RedrawMenuItem(buffer);
	}
	if (action == MenuAction:2)
	{
		decl String:buffer[256];
		Format(buffer, 255, "%T", "IngameMenu_Caption", param1);
		new Handle:panel = param2;
		SetPanelTitle(panel, buffer, false);
	}
	else
	{
		if (action == MenuAction:4)
		{
			if (IsClientInGame(param1))
			{
				switch (param2)
				{
					case 0:
					{
						make_player_command(param1, "/gameme_auto start rank");
					}
					case 1:
					{
						make_player_command(param1, "/gameme_auto end rank");
					}
					case 2:
					{
						make_player_command(param1, "/gameme_auto kill rank");
					}
					case 3:
					{
						make_player_command(param1, "/gameme_auto clear");
					}
					default:
					{
					}
				}
			}
		}
	}
	return 0;
}

public gameMEEventsCommandHandler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction:512)
	{
		decl String:info[64];
		GetMenuItem(menu, param2, info, 64, 0, "", 0);
		decl String:buffer[256];
		Format(buffer, 255, "%T", info, param1);
		return RedrawMenuItem(buffer);
	}
	if (action == MenuAction:2)
	{
		decl String:buffer[256];
		Format(buffer, 255, "%T", "IngameMenu_Caption", param1);
		new Handle:panel = param2;
		SetPanelTitle(panel, buffer, false);
	}
	else
	{
		if (action == MenuAction:4)
		{
			if (IsClientInGame(param1))
			{
				switch (param2)
				{
					case 0:
					{
						make_player_command(param1, "/gameme_display 1");
					}
					case 1:
					{
						make_player_command(param1, "/gameme_display 0");
					}
					case 2:
					{
						make_player_command(param1, "/gameme_chat 1");
					}
					case 3:
					{
						make_player_command(param1, "/gameme_chat 0");
					}
					default:
					{
					}
				}
			}
		}
	}
	return 0;
}

public Event_L4DRescueSurvivor(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "rescuer", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "rescued_survivor", 0, 0);
	}
	return 0;
}

public Event_L4DHeal(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (player > 0 && GetClientOfUserId(GetEventInt(event, "subject", 0)) != player)
	{
		log_player_event(player, "triggered", "healed_teammate", 0, 0);
	}
	return 0;
}

public Event_L4DRevive(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "revived_teammate", 0, 0);
	}
	return 0;
}

public Event_L4DStartleWitch(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var2;
	if (player > 0 && (gameme_plugin[0] == 6 && GetEventBool(event, "first", false)))
	{
		log_player_event(player, "triggered", "startled_witch", 0, 0);
	}
	return 0;
}

public Event_L4DPounce(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "victim", 0));
	if (0 < victim)
	{
		log_player_player_event(player, victim, "triggered", "pounce", 0);
	}
	else
	{
		log_player_event(player, "triggered", "pounce", 0, 0);
	}
	return 0;
}

public Event_L4DBoomered(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var2;
	if (player > 0 && (gameme_plugin[0] == 6 && GetEventBool(event, "by_boomer", false)))
	{
		if (0 < victim)
		{
			log_player_player_event(player, victim, "triggered", "vomit", 0);
		}
		log_player_event(player, "triggered", "vomit", 0, 0);
	}
	return 0;
}

public Event_L4DFF(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "victim", 0));
	new var1;
	if (player > 0 && GetClientOfUserId(GetEventInt(event, "guilty", 0)) == player)
	{
		if (0 < victim)
		{
			log_player_player_event(player, victim, "triggered", "friendly_fire", 0);
		}
		log_player_event(player, "triggered", "friendly_fire", 0, 0);
	}
	return 0;
}

public Event_L4DWitchKilled(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (player > 0 && GetEventBool(event, "oneshot", false))
	{
		log_player_event(player, "triggered", "cr0wned", 0, 0);
	}
	return 0;
}

public Event_L4DDefib(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "defibrillated_teammate", 0, 0);
	}
	return 0;
}

public Event_L4DAdrenaline(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "used_adrenaline", 0, 0);
	}
	return 0;
}

public Event_L4DJockeyRide(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "victim", 0));
	if (0 < player)
	{
		if (0 < victim)
		{
			log_player_player_event(player, victim, "triggered", "jockey_ride", 0);
		}
		log_player_event(player, "triggered", "jockey_ride", 0, 0);
	}
	return 0;
}

public Event_L4DChargerPummelStart(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "victim", 0));
	if (0 < player)
	{
		if (0 < victim)
		{
			log_player_player_event(player, victim, "triggered", "charger_pummel", 0);
		}
		log_player_event(player, "triggered", "charger_pummel", 0, 0);
	}
	return 0;
}

public Event_L4DVomitBombTank(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "bilebomb_tank", 0, 0);
	}
	return 0;
}

public Event_L4DScavengeEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new team_index = GetEventInt(event, "winners", 0);
	if (strcmp(team_list[team_index], "", true))
	{
		log_team_event(team_list[team_index], "scavenge_win", "");
	}
	return 0;
}

public Event_L4DVersusEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new team_index = GetEventInt(event, "winners", 0);
	if (strcmp(team_list[team_index], "", true))
	{
		log_team_event(team_list[team_index], "versus_win", "");
	}
	return 0;
}

public Event_L4dChargerKilled(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "charger", 0));
	new var1;
	if (attacker > 0 && IsClientInGame(attacker))
	{
		new var2;
		if (GetEventBool(event, "melee", false) && GetEventBool(event, "charging", false))
		{
			new var3;
			if (victim > 0 && IsClientInGame(victim))
			{
				log_player_player_event(attacker, victim, "triggered", "level_a_charge", 0);
			}
			log_player_event(attacker, "triggered", "level_a_charge", 0, 0);
		}
	}
	return 0;
}

public Event_L4DAward(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		switch (GetEventInt(event, "award", 0))
		{
			case 21:
			{
				log_player_event(player, "triggered", "hunter_punter", 0, 0);
			}
			case 27:
			{
				log_player_event(player, "triggered", "tounge_twister", 0, 0);
			}
			case 67:
			{
				log_player_event(player, "triggered", "protect_teammate", 0, 0);
			}
			case 80:
			{
				log_player_event(player, "triggered", "no_death_on_tank", 0, 0);
			}
			case 136:
			{
				log_player_event(player, "triggered", "killed_all_survivors", 0, 0);
			}
			default:
			{
			}
		}
	}
	return 0;
}

public Action:Event_INSMODObjMsg(UserMsg:msg_id, Handle:bf, players[], playersNum, bool:reliable, bool:init)
{
	new objective_point = BfReadByte(bf);
	new cap_status = BfReadByte(bf);
	new team_index = BfReadByte(bf);
	new var1;
	if (cap_status == 2 && strcmp(team_list[team_index], "", true))
	{
		switch (objective_point)
		{
			case 1:
			{
				log_team_event(team_list[team_index], "point_captured", "point_a");
			}
			case 2:
			{
				log_team_event(team_list[team_index], "point_captured", "point_b");
			}
			case 3:
			{
				log_team_event(team_list[team_index], "point_captured", "point_c");
			}
			case 4:
			{
				log_team_event(team_list[team_index], "point_captured", "point_d");
			}
			case 5:
			{
				log_team_event(team_list[team_index], "point_captured", "point_e");
			}
			default:
			{
			}
		}
	}
	return Action:0;
}

public Event_TF2StealSandvich(Handle:event, String:name[], bool:dontBroadcast)
{
	new owner = GetClientOfUserId(GetEventInt(event, "owner", 0));
	new target = GetClientOfUserId(GetEventInt(event, "target", 0));
	new var1;
	if (owner > 0 && target > 0)
	{
		log_player_player_event(target, owner, "triggered", "steal_sandvich", 0);
	}
	return 0;
}

public Event_TF2Stunned(Handle:event, String:name[], bool:dontBroadcast)
{
	new stunner = GetClientOfUserId(GetEventInt(event, "stunner", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "victim", 0));
	new var1;
	if (stunner > 0 && victim > 0)
	{
		log_player_player_event(stunner, victim, "triggered", "stun", 0);
		if (!(GetEntityFlags(victim) & 513))
		{
			log_player_event(stunner, "triggered", "airshot_stun", 0, 0);
		}
	}
	return 0;
}

public Action:Event_TF2Jarated(UserMsg:msg_id, Handle:bf, players[], playersNum, bool:reliable, bool:init)
{
	new client = BfReadByte(bf);
	new victim = BfReadByte(bf);
	new var1;
	if (client > 0 && victim > 0 && IsClientInGame(client) && IsClientInGame(victim))
	{
		if (TF2_IsPlayerInCondition(victim, TFCond:24))
		{
			log_player_player_event(client, victim, "triggered", "jarate", 0);
		}
		if (TF2_IsPlayerInCondition(victim, TFCond:27))
		{
			log_player_player_event(client, victim, "triggered", "madmilk", 0);
		}
	}
	return Action:0;
}

public Action:Event_TF2ShieldBlocked(UserMsg:msg_id, Handle:bf, players[], playersNum, bool:reliable, bool:init)
{
	new victim = BfReadByte(bf);
	new client = BfReadByte(bf);
	new var1;
	if (client > 0 && victim > 0)
	{
		log_player_player_event(client, victim, "triggered", "shield_blocked", 0);
	}
	return Action:0;
}

public Action:Event_TF2SoundHook(clients[64], &numClients, String:sample[256], &entity, &channel, &Float:volume, &level, &pitch, &flags)
{
	new var1;
	if (entity <= MaxClients && entity == clients[0] && tf2_players[entity][21] == 6 && StrEqual(sample, "vo/SandwichEat09.wav", true))
	{
		switch (tf2_players[entity][1])
		{
			case 159:
			{
				log_player_event(entity, "triggered", "dalokohs", 0, 0);
				new Float:time = GetGameTime();
				if (time - tf2_players[entity][20] > 30)
				{
					log_player_event(entity, "triggered", "dalokohs_healthboost", 0, 0);
				}
				tf2_players[entity][20] = time;
				if (GetClientHealth(entity) < 350)
				{
					log_player_event(entity, "triggered", "dalokohs_healself", 0, 0);
				}
			}
			case 311:
			{
				log_player_event(entity, "triggered", "steak", 0, 0);
			}
			default:
			{
				log_player_event(entity, "triggered", "sandvich", 0, 0);
				if (GetClientHealth(entity) < 300)
				{
					log_player_event(entity, "triggered", "sandvich_healself", 0, 0);
				}
			}
		}
	}
	return Action:0;
}

public Event_TF2WinPanel(Handle:event, String:name[], bool:dontBroadcast)
{
	new player1 = GetEventInt(event, "player_1", 0);
	new player2 = GetEventInt(event, "player_2", 0);
	new player3 = GetEventInt(event, "player_3", 0);
	new var1;
	if (player1 > 0 && IsClientInGame(player1))
	{
		log_player_event(player1, "triggered", "mvp1", 0, 0);
	}
	new var2;
	if (player2 > 0 && IsClientInGame(player2))
	{
		log_player_event(player2, "triggered", "mvp2", 0, 0);
	}
	new var3;
	if (player3 > 0 && IsClientInGame(player3))
	{
		log_player_event(player3, "triggered", "mvp3", 0, 0);
	}
	return 0;
}

public Event_TF2EscortScore(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetEventInt(event, "player", 0);
	if (0 < player)
	{
		log_player_event(player, "triggered", "escort_score", 0, 0);
	}
	return 0;
}

public Event_TF2DeployBuffBanner(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "buff_owner", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "buff_deployed", 0, 0);
	}
	return 0;
}

public Event_TF2MedicDefended(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < player)
	{
		log_player_event(player, "triggered", "defended_medic", 0, 0);
	}
	return 0;
}

public Action:Event_TF2ObjectDestroyedPre(Handle:event, String:name[], bool:dontBroadcast)
{
	if (GetEntProp(GetEventInt(event, "index", 0), PropType:0, "m_bMiniBuilding", 1, 0))
	{
		new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
		new userid = GetEventInt(event, "userid", 0);
		new victim = GetClientOfUserId(userid);
		new var1;
		if (attacker > 0 && victim > 0 && attacker <= 65 && victim <= 65 && IsClientInGame(victim) && IsClientInGame(attacker))
		{
			decl String:weapon_str[32];
			GetEventString(event, "weapon", weapon_str, 32, "");
			new Float:player_origin[3] = 0.0;
			GetClientAbsOrigin(attacker, player_origin);
			LogToGame("\"%L\" %s \"%s\" (object \"%s\") (weapon \"%s\") (objectowner \"%L\") (attacker_position \"%d %d %d\")", attacker, "triggered", "killedobject", "OBJ_SENTRYGUN_MINI", weapon_str, victim, RoundFloat(player_origin[0]), RoundFloat(player_origin[1]), RoundFloat(player_origin[2]));
		}
		tf2_data[9] = 1;
	}
	return Action:0;
}

public Action:Event_TF2PlayerBuiltObjectPre(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < client)
	{
		if (tf2_players[client][22])
		{
			tf2_players[client][22] = 0;
			tf2_data[9] = 1;
		}
		if (GetEntProp(GetEventInt(event, "index", 0), PropType:0, "m_bMiniBuilding", 1, 0))
		{
			new var1;
			if (client > 0 && client <= 65 && IsClientInGame(client))
			{
				new Float:player_origin[3] = 0.0;
				GetClientAbsOrigin(client, player_origin);
				LogToGame("\"%L\" %s \"%s\" (object \"%s\") (position \"%d %d %d\")", client, "triggered", "builtobject", "OBJ_SENTRYGUN_MINI", RoundFloat(player_origin[0]), RoundFloat(player_origin[1]), RoundFloat(player_origin[2]));
			}
			tf2_data[9] = 1;
		}
	}
	return Action:0;
}

public Event_TF2PlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new Float:time = GetGameTime();
	new userid = GetEventInt(event, "userid", 0);
	new client = GetClientOfUserId(userid);
	new TFClassType:spawn_class = GetEventInt(event, "class", 0);
	tf2_players[client][19] = 0;
	dump_player_data(client);
	if (time == tf2_players[client][18])
	{
		new obj_type;
		new String:obj_name[24] = "OBJ_DISPENSER";
		while (PopStackCell(tf2_players[client][17], obj_type, 0, false))
		{
			switch (obj_type)
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
				case 20:
				{
				}
				default:
				{
				}
			}
			new Float:player_origin[3] = 0.0;
			GetClientAbsOrigin(client, player_origin);
			LogToGame("\"%L\" %s \"%s\" (object \"%s\") (weapon \"%s\") (objectowner \"%L\") (attacker_position \"%d %d %d\")", client, "triggered", "killedobject", obj_name, "pda_engineer", client, RoundFloat(player_origin[0]), RoundFloat(player_origin[1]), RoundFloat(player_origin[2]));
		}
	}
	tf2_players[client][21] = spawn_class;
	tf2_players[client][20] = -1041235968;
	return 0;
}

public Event_TF2RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	if (gameme_plugin[149] == 1)
	{
		new i;
		while (i <= 65)
		{
			gameme_players[i][8] = 1;
			i++;
		}
	}
	return 0;
}

public Event_TF2RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		dump_player_data(i);
		i++;
	}
	return 0;
}

public Event_TF2ObjectRemoved(Handle:event, String:name[], bool:dontBroadcast)
{
	new Float:time = GetGameTime();
	new userid = GetEventInt(event, "userid", 0);
	new client = GetClientOfUserId(userid);
	if (time != tf2_players[client][18])
	{
		tf2_players[client][18] = time;
		do {
		} while (PopStack(tf2_players[client][17]));
	}
	new obj_type = GetEventInt(event, "objecttype", 0);
	new obj_index = GetEventInt(event, "index", 0);
	new var1;
	if (IsValidEdict(obj_index) && GetEntProp(GetEventInt(event, "index", 0), PropType:0, "m_bMiniBuilding", 1, 0))
	{
		obj_type = 20;
	}
	PushStackCell(tf2_players[client][17], obj_type);
	return 0;
}

public Event_TF2PostInvApp(Handle:event, String:name[], bool:dontBroadcast)
{
	CreateTimer(0.2, check_player_loadout, GetEventInt(event, "userid", 0), 0);
	return 0;
}

public Action:check_player_loadout(Handle:timer, any:userid)
{
	new client = GetClientOfUserId(userid);
	new var1;
	if (client && !IsClientInGame(client))
	{
		return Action:4;
	}
	new bool:is_new_loadout;
	new check_slot;
	while (check_slot <= 5)
	{
		new var2;
		if (tf2_players[client][8][check_slot] && IsValidEntity(tf2_players[client][8][check_slot]))
		{
		}
		else
		{
			new entity = GetPlayerWeaponSlot(client, check_slot);
			if (entity == -1)
			{
				new var4;
				if (gameme_plugin[152] && check_slot < 3 && (tf2_players[client][21] == 3 || tf2_players[client][21] == 4))
				{
					tf2_players[client][8][check_slot] = -1;
				}
				if (!(tf2_players[client][check_slot] == -1))
				{
					tf2_players[client][check_slot] = -1;
					tf2_players[client][8][check_slot] = -1;
					is_new_loadout = true;
				}
			}
			else
			{
				new item_index = GetEntProp(entity, PropType:0, "m_iItemDefinitionIndex", 4, 0);
				if (item_index != tf2_players[client][check_slot])
				{
					tf2_players[client][check_slot] = item_index;
					is_new_loadout = true;
				}
				tf2_players[client][8][check_slot] = EntIndexToEntRef(entity);
			}
		}
		check_slot++;
	}
	if (gameme_plugin[152])
	{
		if (is_new_loadout)
		{
			tf2_players[client][16] = 1;
		}
		CreateTimer(0.2, log_weapon_loadout, userid, 0);
	}
	else
	{
		if (is_new_loadout)
		{
			log_weapon_loadout(Handle:0, userid);
		}
	}
	return Action:4;
}

public Action:log_weapon_loadout(Handle:timer, any:userid)
{
	new client = GetClientOfUserId(userid);
	new var1;
	if (client > 0 && IsClientInGame(client))
	{
		new i;
		while (i < 8)
		{
			new var2;
			if ((tf2_players[client][i] != -1 && !IsValidEntity(tf2_players[client][8][i])) || tf2_players[client][8][i])
			{
				tf2_players[client][i] = -1;
				tf2_players[client][8][i] = -1;
				tf2_players[client][16] = 1;
			}
			i++;
		}
		if (tf2_players[client][16])
		{
			tf2_players[client][16] = 0;
			LogToGame("\"%L\" %s \"%s\" (primary \"%d\") (secondary \"%d\") (melee \"%d\") (pda \"%d\") (pda2 \"%d\") (building \"%d\") (head \"%d\") (misc \"%d\")", client, "triggered", "player_loadout", tf2_players[client], tf2_players[client][1], tf2_players[client][2], tf2_players[client][3], tf2_players[client][4], tf2_players[client][5], tf2_players[client][6], tf2_players[client][7]);
		}
		return Action:4;
	}
	return Action:4;
}

public Action:OnTF2TakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	new var1;
	if (attacker > 0 && attacker <= MaxClients && victim != attacker && inflictor > MaxClients && damage > 0.0 && IsValidEntity(inflictor) && GetEntityFlags(victim) & 513)
	{
		decl String:weapon_str[64];
		GetEdictClassname(inflictor, weapon_str, 64);
		new var2;
		if (weapon_str[0] == 'p' && weapon_str[1] == 'r')
		{
			switch (weapon_str[3])
			{
				case 97:
				{
					log_player_event(attacker, "triggered", "airshot_arrow", 0, 0);
				}
				case 102:
				{
					if (damage > 10.0)
					{
						log_player_event(attacker, "triggered", "airshot_flare", 0, 0);
					}
				}
				case 112:
				{
					if (weapon_str[4])
					{
						log_player_event(attacker, "triggered", "airshot_sticky", 0, 0);
						if (tf2_players[attacker][19] == 3)
						{
							log_player_event(attacker, "triggered", "air2airshot_sticky", 0, 0);
						}
					}
					else
					{
						log_player_event(attacker, "triggered", "airshot_pipebomb", 0, 0);
						if (tf2_players[attacker][19] == 3)
						{
							log_player_event(attacker, "triggered", "air2airshot_pipebomb", 0, 0);
						}
					}
				}
				case 114:
				{
					log_player_event(attacker, "triggered", "airshot_rocket", 0, 0);
					if (tf2_players[attacker][19] == 2)
					{
						log_player_event(attacker, "triggered", "air2airshot_rocket", 0, 0);
					}
				}
				default:
				{
				}
			}
		}
	}
	return Action:0;
}

public OnTF2TakeDamage_Post(victim, attacker, inflictor, Float:damage, damagetype)
{
	new var1;
	if (attacker > 0 && attacker <= MaxClients)
	{
		new weapon_index = -1;
		new idamage = RoundFloat(damage);
		decl String:weapon_str[64];
		if (inflictor <= MaxClients)
		{
			if (damagetype & 8)
			{
				return 0;
			}
			new var2;
			if (attacker == inflictor && damagetype & 1 && 1000.0 == damage)
			{
				return 0;
			}
			GetClientWeapon(attacker, weapon_str, 64);
			weapon_index = get_tf2_weapon_index(weapon_str[2], attacker, -1);
		}
		else
		{
			if (IsValidEdict(inflictor))
			{
				GetEdictClassname(inflictor, weapon_str, 64);
				if (weapon_str[2] == 'g')
				{
					return 0;
				}
				if (weapon_str[0] == 'p')
				{
					weapon_index = get_tf2_weapon_index(weapon_str, attacker, inflictor);
				}
				new var3;
				if (!damagetype & 1 && damagetype & 128 && StrEqual(weapon_str, "tf_weapon_bat_wood", true))
				{
					weapon_index = get_tf2_weapon_index("ball", attacker, -1);
				}
				weapon_index = get_tf2_weapon_index(weapon_str[2], attacker, -1);
			}
		}
		if (weapon_index > -1)
		{
			new var4 = player_weapons[attacker][weapon_index][5];
			var4 = var4[idamage];
			player_weapons[attacker][weapon_index][1]++;
		}
	}
	return 0;
}

public Event_TF2RocketJump(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < client)
	{
		new status = tf2_players[client][19];
		if (status == 1)
		{
			tf2_players[client][19] = 2;
			log_player_event(client, "triggered", "rocket_jump", 0, 0);
		}
		else
		{
			if (status != 2)
			{
				tf2_players[client][19] = 1;
			}
		}
	}
	return 0;
}

public Event_TF2StickyJump(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < client)
	{
		if (tf2_players[client][19] != 3)
		{
			tf2_players[client][19] = 3;
			log_player_event(client, "triggered", "sticky_jump", 0, 0);
		}
	}
	return 0;
}

public Event_TF2JumpLanded(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < client)
	{
		tf2_players[client][19] = 0;
	}
	return 0;
}

public Event_TF2ObjectDeflected(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new owner = GetClientOfUserId(GetEventInt(event, "ownerid", 0));
	new var1;
	if (client > 0 && owner > 0)
	{
		new weapon_id = GetEventInt(event, "weaponid", 0);
		switch (weapon_id)
		{
			case 0:
			{
				log_player_player_event(client, owner, "triggered", "airblast_player", 1);
			}
			case 22:
			{
				if (gameme_plugin[152])
				{
					new weapon_index = get_tf2_weapon_index("deflect_rocket", 0, -1);
					if (weapon_index > -1)
					{
						player_weapons[client][weapon_index]++;
					}
				}
			}
			case 53:
			{
				if (gameme_plugin[152])
				{
					new weapon_index = get_tf2_weapon_index("deflect_promode", 0, -1);
					if (weapon_index > -1)
					{
						player_weapons[client][weapon_index]++;
					}
				}
			}
			case 58:
			{
				if (gameme_plugin[152])
				{
					new weapon_index = get_tf2_weapon_index("deflect_flare", 0, -1);
					if (weapon_index > -1)
					{
						player_weapons[client][weapon_index]++;
					}
				}
			}
			case 61:
			{
				if (gameme_plugin[152])
				{
					new weapon_index = get_tf2_weapon_index("deflect_arrow", 0, -1);
					if (weapon_index > -1)
					{
						player_weapons[client][weapon_index]++;
					}
				}
			}
			case 65:
			{
				if (gameme_plugin[152])
				{
					new weapon_index = get_tf2_weapon_index("deflect_rocket", 0, -1);
					if (weapon_index > -1)
					{
						player_weapons[client][weapon_index]++;
					}
				}
			}
			default:
			{
			}
		}
	}
	return 0;
}

public OnHL2MPFireBullets(attacker, shots, String:weapon_str[])
{
	new var1;
	if (attacker > 0 && attacker <= MaxClients)
	{
		decl String:weapon_name[32];
		GetClientWeapon(attacker, weapon_name, 32);
		new weapon_index = get_weapon_index(hl2mp_weapon_list, 6, weapon_name[1]);
		if (weapon_index > -1)
		{
			player_weapons[attacker][weapon_index]++;
		}
	}
	return 0;
}

public OnHL2MPTraceAttack(victim, attacker, inflictor, Float:damage, damagetype, ammotype, hitbox, hitgroup)
{
	new var1;
	if (hitgroup > 0 && attacker > 0 && attacker <= MaxClients && victim > 0 && victim <= MaxClients)
	{
		if (IsValidEntity(inflictor))
		{
			decl String:inflictorclsname[64];
			new var2;
			if (GetEntityNetClass(inflictor, inflictorclsname, 64) && strcmp(inflictorclsname, "CCrossbowBolt", true))
			{
				hl2mp_players[victim][1] = hitgroup;
				return 0;
			}
		}
		hl2mp_players[victim][0] = hitgroup;
	}
	return 0;
}

public OnHL2MPTakeDamage(victim, attacker, inflictor, Float:damage, damagetype)
{
	new var1;
	if (attacker > 0 && attacker <= MaxClients && victim > 0 && victim <= MaxClients)
	{
		decl String:weapon_str[32];
		GetClientWeapon(attacker, weapon_str, 32);
		new weapon_index = -1;
		if (IsValidEntity(inflictor))
		{
			decl String:inflictorclsname[64];
			new var2;
			if (GetEntityNetClass(inflictor, inflictorclsname, 64) && strcmp(inflictorclsname, "CCrossbowBolt", true))
			{
				weapon_index = 0;
			}
		}
		if (weapon_index == -1)
		{
			weapon_index = get_weapon_index(hl2mp_weapon_list, 6, weapon_str[1]);
		}
		decl hitgroup;
		new var3;
		if (weapon_index)
		{
			var3 = hl2mp_players[victim][0];
		}
		else
		{
			var3 = hl2mp_players[victim][1];
		}
		hitgroup = var3;
		if (hitgroup < 8)
		{
			hitgroup += 8;
		}
		decl bool:headshot;
		new var4;
		headshot = GetClientHealth(victim) <= 0 && hitgroup == 1;
		if (weapon_index > -1)
		{
			player_weapons[attacker][weapon_index][1]++;
			new var5 = player_weapons[attacker][weapon_index][5];
			var5 = var5[RoundToNearest(damage)];
			player_weapons[attacker][weapon_index][hitgroup]++;
			if (headshot)
			{
				player_weapons[attacker][weapon_index][3]++;
			}
		}
		if (weapon_index)
		{
			hl2mp_players[victim][0] = 0;
		}
		else
		{
			hl2mp_players[victim][1] = 0;
		}
	}
	return 0;
}

public OnZPSFireBullets(attacker, shots, String:weapon[])
{
	new var1;
	if (attacker > 0 && attacker <= MaxClients)
	{
		decl String:weapon_name[32];
		GetClientWeapon(attacker, weapon_name, 32);
		new weapon_index = get_weapon_index(zps_weapon_list, 11, weapon_name);
		if (weapon_index > -1)
		{
			player_weapons[attacker][weapon_index]++;
		}
	}
	return 0;
}

public OnZPSTraceAttack(victim, attacker, inflictor, Float:damage, damagetype, ammotype, hitbox, hitgroup)
{
	new var1;
	if (hitgroup > 0 && attacker > 0 && attacker <= MaxClients && victim > 0 && victim <= MaxClients)
	{
		zps_players[victim][0] = hitgroup;
	}
	return 0;
}

public OnZPSTakeDamage(victim, attacker, inflictor, Float:damage, damagetype)
{
	new var1;
	if (attacker > 0 && attacker <= MaxClients && victim > 0 && victim <= MaxClients)
	{
		new hitgroup = zps_players[victim][0];
		if (hitgroup < 8)
		{
			hitgroup += 8;
		}
		decl bool:headshot;
		new var2;
		headshot = GetClientHealth(victim) <= 0 && hitgroup == 1;
		decl String:weapon_str[32];
		GetClientWeapon(attacker, weapon_str, 32);
		new weapon_index = get_weapon_index(zps_weapon_list, 11, weapon_str);
		if (weapon_index > -1)
		{
			player_weapons[attacker][weapon_index][1]++;
			new var3 = player_weapons[attacker][weapon_index][5];
			var3 = var3[RoundToNearest(damage)];
			if (headshot)
			{
				player_weapons[attacker][weapon_index][3]++;
			}
		}
		zps_players[victim][0] = 0;
	}
	return 0;
}

AddPluginServerTag(String:tag[])
{
	new var2;
	if (gameme_plugin[156] && (gameme_plugin[153] != 13 && gameme_plugin[153] != 15 && gameme_plugin[153] != 16 && gameme_plugin[153] != 17 && gameme_plugin[153] != 18 && gameme_plugin[153] != 4 && gameme_plugin[153] != 7 && gameme_plugin[153] != 12 && gameme_plugin[153] != 21))
	{
		return 0;
	}
	if (FindStringInArray(gameme_plugin[155], tag) == -1)
	{
		PushArrayString(gameme_plugin[155], tag);
	}
	decl String:current_tags[128];
	GetConVarString(gameme_plugin[156], current_tags, 128);
	if (StrContains(current_tags, tag, true) > -1)
	{
		LogToGame("gameME gameserver tag already exists [%s]", current_tags);
		return 0;
	}
	decl String:new_tags[128];
	new var3;
	if (current_tags[0])
	{
		var3[0] = 4926636;
	}
	else
	{
		var3[0] = 4926640;
	}
	Format(new_tags, 128, "%s%s%s", current_tags, var3, tag);
	new flags = GetConVarFlags(gameme_plugin[156]);
	SetConVarFlags(gameme_plugin[156], flags & -257);
	gameme_plugin[154] = 1;
	SetConVarString(gameme_plugin[156], new_tags, false, false);
	gameme_plugin[154] = 0;
	SetConVarFlags(gameme_plugin[156], flags);
	LogToGame("Added gameME gameserver tag [%s]", new_tags);
	return 0;
}

public Event_INSMODPlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (victim > 0 && attacker > 0)
	{
		if (victim != attacker)
		{
			decl String:weapon_str[32];
			GetEventString(event, "weapon", weapon_str, 32, "");
			ReplaceString(weapon_str, 32, "weapon_", "", false);
			new weapon_index = get_weapon_index(insmod_weapon_list, 30, weapon_str);
			if (weapon_index > -1)
			{
				player_weapons[attacker][weapon_index][2]++;
				player_weapons[victim][weapon_index][6]++;
				if (GetClientTeam(victim) == GetClientTeam(attacker))
				{
					player_weapons[attacker][weapon_index][4]++;
				}
			}
			new assister = GetClientOfUserId(GetEventInt(event, "assister", 0));
			new var2;
			if (assister > 0 && victim != assister)
			{
				log_player_player_event(assister, victim, "triggered", "kill_assist", 0);
			}
		}
		dump_player_data(victim);
	}
	return 0;
}

public Event_INSMODPlayerHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new victim = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new var1;
	if (attacker > 0 && victim != attacker)
	{
		decl String:weapon_str[32];
		GetEventString(event, "weapon", weapon_str, 32, "");
		ReplaceString(weapon_str, 32, "weapon_", "", false);
		new weapon_index = get_weapon_index(insmod_weapon_list, 30, weapon_str);
		if (weapon_index > -1)
		{
			player_weapons[attacker][weapon_index]++;
			player_weapons[attacker][weapon_index][1]++;
			new var2 = player_weapons[attacker][weapon_index][5];
			var2 = var2[GetEventInt(event, "dmg_health", 0)];
			new hitgroup = GetEventInt(event, "hitgroup", 0);
			if (hitgroup < 8)
			{
				player_weapons[attacker][weapon_index][hitgroup + 8]++;
			}
			else
			{
				player_weapons[attacker][weapon_index][hitgroup]++;
			}
			if (hitgroup == 1)
			{
				player_weapons[attacker][weapon_index][3]++;
				if (IsClientInGame(attacker))
				{
					log_player_event(attacker, "triggered", "headshot", 0, 0);
				}
			}
		}
	}
	return 0;
}

public Event_INSMODEventFired(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new String:weapon_str[32];
	GetClientWeapon(client, weapon_str, 32);
	ReplaceString(weapon_str, 32, "weapon_", "", false);
	new weapon_index = get_weapon_index(insmod_weapon_list, 30, weapon_str);
	if (weapon_index > -1)
	{
		player_weapons[client][weapon_index]++;
	}
	return 0;
}

public Event_INSMODPlayerSpawn(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (0 < userid)
	{
		reset_player_data(userid);
	}
	return 0;
}

public Event_INSMODRoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new i = 1;
	while (i <= MaxClients)
	{
		dump_player_data(i);
		i++;
	}
	new team_index = GetEventInt(event, "winner", 0);
	if (0 < team_index)
	{
		log_team_event(team_list[team_index], "Round_Win", "");
	}
	return 0;
}

public Event_INSMODPlayerPickSquad(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (client)
	{
		decl String:class_template[64];
		GetEventString(event, "class_template", class_template, 64, "");
		ReplaceString(class_template, 64, "template_", "", false);
		ReplaceString(class_template, 64, "_training", "", false);
		ReplaceString(class_template, 64, "_coop", "", false);
		ReplaceString(class_template, 64, "coop_", "", false);
		ReplaceString(class_template, 64, "_security", "", false);
		ReplaceString(class_template, 64, "_insurgent", "", false);
		ReplaceString(class_template, 64, "_survival", "", false);
		if (!StrEqual(insmod_players[client], class_template, true))
		{
			LogToGame("\"%L\" changed role to \"%s\"", client, class_template);
			strcopy(insmod_players[client], 64, class_template);
		}
		return 0;
	}
	return 0;
}

