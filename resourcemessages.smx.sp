public PlVers:__version =
{
	version = 5,
	filevers = "1.6.1",
	date = "10/19/2014",
	time = "21:25:20"
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
public Extension:__ext_cprefs =
{
	name = "Client Preferences",
	file = "clientprefs.ext",
	autoload = 1,
	required = 1,
};
public SharedPlugin:__pl_updater =
{
	name = "updater",
	file = "updater.smx",
	required = 0,
};
new bool:show_messages = 1;
new Handle:cookie_resmsg;
new bool:option_resmsg[66];
new resCount;
new resEnts[30];
new bool:resCapturers[30][66];
new teamEnts[4];
new rotation;
new Float:posCenter[3];
new Float:posBase[4][3];
public Plugin:myinfo =
{
	name = "Resource Messages",
	description = "Messages about resource capture with !settings menu integration.",
	author = "Vaskrist",
	version = "1.0.2",
	url = "http://vaskrist.source-code.my/nd-plugin-resource-messsages"
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
	VerifyCoreVersion();
	return 0;
}

Float:operator-(Float:)(Float:oper)
{
	return oper ^ -2147483648;
}

Float:operator*(Float:,_:)(Float:oper1, oper2)
{
	return oper1 * float(oper2);
}

Float:RadToDeg(Float:angle)
{
	return angle * 180 / 3.1415927;
}

SubtractVectors(Float:vec1[3], Float:vec2[3], Float:result[3])
{
	result[0] = vec1[0] - vec2[0];
	result[1] = vec1[1] - vec2[1];
	result[2] = vec1[2] - vec2[2];
	return 0;
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

ImplodeStrings(String:strings[][], numStrings, String:join[], String:buffer[], maxLength)
{
	new total;
	new length;
	new part_length;
	new join_length = strlen(join);
	new i;
	while (i < numStrings)
	{
		length = strcopy(buffer[total], maxLength - total, strings[i]);
		total = length + total;
		if (!(length < part_length))
		{
			if (numStrings + -1 != i)
			{
				length = strcopy(buffer[total], maxLength - total, join);
				total = length + total;
				if (length < join_length)
				{
					return total;
				}
			}
			i++;
		}
		return total;
	}
	return total;
}

public __pl_updater_SetNTVOptional()
{
	MarkNativeAsOptional("Updater_AddPlugin");
	MarkNativeAsOptional("Updater_RemovePlugin");
	MarkNativeAsOptional("Updater_ForceUpdate");
	return 0;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("GetResourcesTotal", Native_GetResourcesTotal);
	CreateNative("GetResourcesExpended", Native_GetResourcesExpended);
	CreateNative("GetResourcesAmount", Native_GetResourcesAmount);
	return APLRes:0;
}

public Native_GetResourcesTotal(Handle:plugin, numParams)
{
	new team = GetNativeCell(1);
	new var1;
	if (team != 2 && team != 3)
	{
		return ThrowNativeError(23, "Invalid team (%d). Accepting only 2 for CON, 3 for EMP.", team);
	}
	new teament = teamEnts[team];
	if (teament != -1)
	{
		new amount = GetEntProp(teament, PropType:0, "m_iResourcePoints", 4, 0);
		new expended = GetEntProp(teament, PropType:0, "m_iExpendedResources", 4, 0);
		return expended + amount;
	}
	return -1;
}

public Native_GetResourcesExpended(Handle:plugin, numParams)
{
	new team = GetNativeCell(1);
	new var1;
	if (team != 2 && team != 3)
	{
		return ThrowNativeError(23, "Invalid team (%d). Accepting only 2 for CON, 3 for EMP.", team);
	}
	new teament = teamEnts[team];
	if (teament != -1)
	{
		new expended = GetEntProp(teament, PropType:0, "m_iExpendedResources", 4, 0);
		return expended;
	}
	return -1;
}

public Native_GetResourcesAmount(Handle:plugin, numParams)
{
	new team = GetNativeCell(1);
	new var1;
	if (team != 2 && team != 3)
	{
		return ThrowNativeError(23, "Invalid team (%d). Accepting only 2 for CON, 3 for EMP.", team);
	}
	new teament = teamEnts[team];
	if (teament != -1)
	{
		new amount = GetEntProp(teament, PropType:0, "m_iResourcePoints", 4, 0);
		return amount;
	}
	return -1;
}

ReadCompassRotation(String:mapName[])
{
	new result;
	new String:filePath[64];
	Format(filePath, 64, "scripts/maps/%s.txt", mapName);
	new Handle:kv = CreateKeyValues(mapName, "", "");
	if (FileToKeyValues(kv, filePath))
	{
		result = KvGetNum(kv, "compass_rotation", 0);
		LogMessage("Read compass_rotation = %d from map script file of '%s'", result, mapName);
	}
	else
	{
		LogError("ReadMapCompassRotation - could not read KeyValue file: %s holding script for map: %s.", filePath, mapName);
	}
	CloseHandle(kv);
	return result;
}

public OnLibraryAdded(String:name[])
{
	if (StrEqual(name, "updater", true))
	{
		Updater_AddPlugin("http://vaskrist.source-code.my/nd-plugin-resource-messsages/raw/master/updatefile.txt");
	}
	return 0;
}

public OnPluginStart()
{
	LoadTranslations("resourcemessages.phrases");
	LoadTranslations("common.phrases");
	cookie_resmsg = RegClientCookie("Resource Messages On/Off", "", CookieAccess:1);
	new info;
	SetCookieMenuItem(CookieMenuHandler_resmsg, info, "Resource Messages");
	new client = 1;
	while (client <= MaxClients)
	{
		if (IsValidClient(client, true))
		{
			OnClientCookiesCached(client);
		}
		client++;
	}
	HookEvent("resource_start_capture", Event_ResourceStartCapture, EventHookMode:1);
	HookEvent("resource_end_capture", Event_ResourceEndCapture, EventHookMode:1);
	HookEvent("resource_captured", Event_ResourceCaptured, EventHookMode:1);
	HookEvent("round_start", Event_RoundStart, EventHookMode:1);
	HookEvent("enter_pregame", Event_EnterPregame, EventHookMode:1);
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin("http://vaskrist.source-code.my/nd-plugin-resource-messsages/raw/master/updatefile.txt");
	}
	PrintToServer("Plugin %s started successfully.", "Resource Messages");
	return 0;
}

public OnMapStart()
{
	GetFirstEntityOrigin("nd_info_primary_resource_point", posCenter);
	GetFirstEntityOrigin("nd_info_command_bunker_ct", posBase[2]);
	GetFirstEntityOrigin("nd_info_command_bunker_emp", posBase[3]);
	teamEnts[2] = FindEntityByClassname(-1, "nd_team_consortium");
	teamEnts[3] = FindEntityByClassname(-1, "nd_team_empire");
	resCount = 0;
	new resIndex;
	while (resIndex < 30)
	{
		resEnts[resIndex] = 0;
		ClearCapturers(resIndex);
		resIndex++;
	}
	rotation = ReadMapCompassRotation();
	return 0;
}

public Event_EnterPregame(Handle:event, String:name[], bool:dontBroadcast)
{
	show_messages = false;
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	show_messages = true;
	return 0;
}

public Event_ResourceStartCapture(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new entindex = GetEventInt(event, "entindex");
	new client = GetClientOfUserId(userid);
	new resIndex = GetResIndex(entindex);
	if (IsValidClient(client, false))
	{
		AddCapturer(resIndex, client);
	}
	return 0;
}

public Event_ResourceEndCapture(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new entindex = GetEventInt(event, "entindex");
	new client = GetClientOfUserId(userid);
	new resIndex = GetResIndex(entindex);
	RemoveCapturer(resIndex, client);
	return 0;
}

public Event_ResourceCaptured(Handle:event, String:name[], bool:dontBroadcast)
{
	new var5;
	var5 = GetEventInt(event, "entindex");
	new var6;
	var6 = GetEventInt(event, "type");
	new var7;
	var7 = GetEventInt(event, "team");
	new var1;
	if (var7 != 3 && var7 != 2)
	{
		return 0;
	}
	new var8;
	var8 = GetResIndex(var5);
	new var9;
	decl capsCount;
	new var2;
	if (var6)
	{
		var2 = 1;
	}
	else
	{
		var2 = 2;
	}
	capsCount = GetCapturerNames(resCapturers[var8], var7, var9, var2);
	new var3;
	if (show_messages && capsCount > 0)
	{
		decl String:nameString[4160];
		ImplodeStrings(var9, capsCount, ",", nameString, 4160);
		new Float:pos[3] = 0.0;
		new String:direction[4];
		GetEntPropVector(var5, PropType:0, "m_vecOrigin", pos, 0);
		GetDirection(pos, var7, var6);
		new String:resKey[32] = "Primary Resource Captured";
		switch (var6)
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
		new client = 1;
		while (client <= MaxClients)
		{
			new var4;
			if (IsValidClient(client, true) && option_resmsg[client] && var7 == GetClientTeam(client))
			{
				decl String:areaKey[32];
				decl String:area[48];
				decl String:message[512];
				Format(areaKey, 32, "Map Area %s", direction);
				Format(area, 48, "%T", areaKey, client);
				Format(message, 512, "\x03%T", resKey, client, nameString, area);
				PrintToChat(client, message);
			}
			client++;
		}
	}
	ClearCapturers(var8);
	return 0;
}

public CookieMenuHandler_resmsg(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	if (action)
	{
		option_resmsg[client] = !option_resmsg[client];
		if (option_resmsg[client])
		{
			SetClientCookie(client, cookie_resmsg, "On");
			PrintToChat(client, "\x04Resource Messages Enabled!");
		}
		else
		{
			SetClientCookie(client, cookie_resmsg, "Off");
			PrintToChat(client, "\x04Resource Messages Disabled!");
		}
		ShowCookieMenu(client);
	}
	else
	{
		decl String:status[12];
		if (option_resmsg[client])
		{
			Format(status, 10, "%T", "On", client);
		}
		else
		{
			Format(status, 10, "%T", "Off", client);
		}
		Format(buffer, maxlen, "%T: %s", "Cookie Resource Messages", client, status);
	}
	return 0;
}

public OnClientCookiesCached(client)
{
	option_resmsg[client] = GetCookie_resmsg(client);
	return 0;
}

bool:GetCookie_resmsg(client)
{
	decl String:buffer[12];
	GetClientCookie(client, cookie_resmsg, buffer, 10);
	return StrEqual(buffer, "On", true);
}

GetResIndex(entIndex)
{
	new resIndex;
	while (resIndex < 30)
	{
		if (entIndex == resEnts[resIndex])
		{
			return resIndex;
		}
		resIndex++;
	}
	if (resCount < 30)
	{
		new resIndex = resCount;
		resCount += 1;
		resEnts[resIndex] = entIndex;
		ClearCapturers(resIndex);
		return resIndex;
	}
	return -1;
}

ClearCapturers(resIndex)
{
	new client = 1;
	while (client <= MaxClients)
	{
		resCapturers[resIndex][client] = false;
		client++;
	}
	return 0;
}

AddCapturer(resIndex, client)
{
	resCapturers[resIndex][client] = true;
	return 0;
}

RemoveCapturer(resIndex, client)
{
	resCapturers[resIndex][client] = false;
	return 0;
}

GetCapturerNames(bool:clients[], team, String:names[264][64], maxNames)
{
	new nameCount;
	new capCount;
	new client = 1;
	while (client <= MaxClients)
	{
		new var1;
		if (IsValidClient(client, false) && clients[client] && team == GetClientTeam(client) && !IsFakeClient(client))
		{
			decl String:name[64];
			GetClientName(client, name, 64);
			if (capCount < maxNames)
			{
				nameCount++;
			}
			capCount++;
		}
		client++;
	}
	new client = 1;
	while (client <= MaxClients)
	{
		new var2;
		if (IsValidClient(client, false) && clients[client] && team == GetClientTeam(client) && IsFakeClient(client))
		{
			decl String:name[64];
			GetClientName(client, name, 64);
			if (capCount < maxNames)
			{
				nameCount++;
			}
			capCount++;
		}
		client++;
	}
	new var3;
	if (nameCount > 0 && capCount > nameCount)
	{
		decl String:appdendedname[64];
		Format(appdendedname, 64, "%s +%d", names[nameCount + -1], capCount - nameCount);
	}
	return nameCount;
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

bool:IsCloseToBase(Float:pos[3], team)
{
	return IsCloseTo(pos, posBase[team], 2500.0);
}

bool:IsCloseTo(Float:pos[3], Float:ref[3], Float:dist)
{
	return GetVectorDistance(pos, ref, false) < dist;
}

String:GetDirection(Float:pos[3], team, type, _arg3)
{
	new String:direction[4] = "CE";
	if (type)
	{
		new Float:rel[3] = 0.0;
		SubtractVectors(pos, posCenter, rel);
		new otherteam = 5 - team;
		if (IsCloseToBase(pos, team))
		{
			return direction;
		}
		if (IsCloseToBase(pos, otherteam))
		{
			return direction;
		}
		new var1;
		if (type == 2 && GetVectorLength(pos, false) < 2000.0)
		{
			return direction;
		}
		new ns;
		new we;
		new bS = -180;
		new bW = -90;
		new bN;
		new bE = 90;
		new Float:R = 60.0;
		new Float:S = float(bS + 180 + rotation % 360 - 180);
		new Float:W = float(bW + 180 + rotation % 360 - 180);
		new Float:N = float(bN + 180 + rotation % 360 - 180);
		new Float:E = float(bE + 180 + rotation % 360 - 180);
		new Float:angle = RadToDeg(ArcTangent2(rel[0], rel[1]));
		if (IsInBounds(angle, N - R, N + R))
		{
			ns = 3;
		}
		if (IsInBounds(angle, S - R, S + R))
		{
			ns = 6;
		}
		if (!IsInBounds(angle, W + R, -W - R))
		{
			we = 1;
		}
		if (IsInBounds(angle, E - R, E + R))
		{
			we = 2;
		}
		new comb = we + ns;
		switch (comb)
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
			case 7:
			{
			}
			case 8:
			{
			}
			default:
			{
			}
		}
		return direction;
	}
	return direction;
}

bool:IsInBounds(Float:value, Float:lowerBound, Float:upperBound)
{
	new var1;
	return lowerBound < value && value < upperBound;
}

GetFirstEntityOrigin(String:class[], Float:pos[3])
{
	new entindex = FindEntityByClassname(-1, class);
	if (entindex != -1)
	{
		GetEntPropVector(entindex, PropType:0, "m_vecOrigin", pos, 0);
	}
	return 0;
}

ReadMapCompassRotation()
{
	new String:mapName[32];
	GetCurrentMap(mapName, 32);
	return ReadCompassRotation(mapName);
}

