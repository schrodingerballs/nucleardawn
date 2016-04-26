public PlVers:__version =
{
	version = 5,
	filevers = "1.6.3",
	date = "05/19/2015",
	time = "18:16:04"
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
public Extension:__ext_curl =
{
	name = "curl",
	file = "curl.ext",
	autoload = 1,
	required = 0,
};
public Extension:__ext_smsock =
{
	name = "Socket",
	file = "socket.ext",
	autoload = 1,
	required = 0,
};
public Extension:__ext_SteamTools =
{
	name = "SteamTools",
	file = "steamtools.ext",
	autoload = 1,
	required = 0,
};
public Extension:__ext_SteamWorks =
{
	name = "SteamWorks",
	file = "SteamWorks.ext",
	autoload = 1,
	required = 0,
};
public Plugin:myinfo =
{
	name = "Updater",
	description = "Automatically updates SourceMod plugins and files",
	author = "GoD-Tony",
	version = "1.2.2",
	url = "http://forums.alliedmods.net/showthread.php?t=169095"
};
new bool:g_bGetDownload;
new bool:g_bGetSource;
new Handle:g_hPluginPacks;
new Handle:g_hDownloadQueue;
new Handle:g_hRemoveQueue;
new bool:g_bDownloading;
new Handle:_hUpdateTimer;
new Float:_fLastUpdate;
new String:_sDataPath[256];
new PluginPack_Plugin;
new PluginPack_Files;
new PluginPack_Status;
new PluginPack_URL;
new Handle:SMC_Sections;
new Handle:SMC_DataTrie;
new Handle:SMC_DataPack;
new SMC_LineNum;
new DLPack_Header;
new DLPack_Redirects;
new DLPack_File;
new DLPack_Request;
new bool:g_bSteamLoaded;
new QueuePack_URL;
new Handle:fwd_OnPluginChecking;
new Handle:fwd_OnPluginDownloading;
new Handle:fwd_OnPluginUpdating;
new Handle:fwd_OnPluginUpdated;
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

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

CharToLower(chr)
{
	if (IsCharUpper(chr))
	{
		return chr | 32;
	}
	return chr;
}

FindCharInString(String:str[], c, bool:reverse)
{
	new i;
	new len = strlen(str);
	if (!reverse)
	{
		i = 0;
		while (i < len)
		{
			if (c == str[i])
			{
				return i;
			}
			i++;
		}
	}
	else
	{
		i = len + -1;
		while (0 <= i)
		{
			if (c == str[i])
			{
				return i;
			}
			i--;
		}
	}
	return -1;
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

bool:WriteFileCell(Handle:hndl, data, size)
{
	new array[1];
	array[0] = data;
	return WriteFile(hndl, array, 1, size);
}

public __ext_SteamWorks_SetNTVOptional()
{
	MarkNativeAsOptional("SteamWorks_IsVACEnabled");
	MarkNativeAsOptional("SteamWorks_GetPublicIP");
	MarkNativeAsOptional("SteamWorks_GetPublicIPCell");
	MarkNativeAsOptional("SteamWorks_IsLoaded");
	MarkNativeAsOptional("SteamWorks_SetGameDescription");
	MarkNativeAsOptional("SteamWorks_IsConnected");
	MarkNativeAsOptional("SteamWorks_SetRule");
	MarkNativeAsOptional("SteamWorks_ClearRules");
	MarkNativeAsOptional("SteamWorks_ForceHeartbeat");
	MarkNativeAsOptional("SteamWorks_GetUserGroupStatus");
	MarkNativeAsOptional("SteamWorks_GetUserGroupStatusAuthID");
	MarkNativeAsOptional("SteamWorks_HasLicenseForApp");
	MarkNativeAsOptional("SteamWorks_GetClientSteamID");
	MarkNativeAsOptional("SteamWorks_RequestStatsAuthID");
	MarkNativeAsOptional("SteamWorks_RequestStats");
	MarkNativeAsOptional("SteamWorks_GetStatCell");
	MarkNativeAsOptional("SteamWorks_GetStatAuthIDCell");
	MarkNativeAsOptional("SteamWorks_GetStatFloat");
	MarkNativeAsOptional("SteamWorks_GetStatAuthIDFloat");
	MarkNativeAsOptional("SteamWorks_CreateHTTPRequest");
	MarkNativeAsOptional("SteamWorks_SetHTTPRequestContextValue");
	MarkNativeAsOptional("SteamWorks_SetHTTPRequestNetworkActivityTimeout");
	MarkNativeAsOptional("SteamWorks_SetHTTPRequestHeaderValue");
	MarkNativeAsOptional("SteamWorks_SetHTTPRequestGetOrPostParameter");
	MarkNativeAsOptional("SteamWorks_SetHTTPCallbacks");
	MarkNativeAsOptional("SteamWorks_SendHTTPRequest");
	MarkNativeAsOptional("SteamWorks_SendHTTPRequestAndStreamResponse");
	MarkNativeAsOptional("SteamWorks_DeferHTTPRequest");
	MarkNativeAsOptional("SteamWorks_PrioritizeHTTPRequest");
	MarkNativeAsOptional("SteamWorks_GetHTTPResponseHeaderSize");
	MarkNativeAsOptional("SteamWorks_GetHTTPResponseHeaderValue");
	MarkNativeAsOptional("SteamWorks_GetHTTPResponseBodySize");
	MarkNativeAsOptional("SteamWorks_GetHTTPResponseBodyData");
	MarkNativeAsOptional("SteamWorks_GetHTTPStreamingResponseBodyData");
	MarkNativeAsOptional("SteamWorks_GetHTTPDownloadProgressPct");
	MarkNativeAsOptional("SteamWorks_SetHTTPRequestRawPostBody");
	MarkNativeAsOptional("SteamWorks_GetHTTPResponseBodyCallback");
	MarkNativeAsOptional("SteamWorks_WriteHTTPResponseBodyToFile");
	return 0;
}

GetMaxPlugins()
{
	return GetArraySize(g_hPluginPacks);
}

bool:IsValidPlugin(Handle:plugin)
{
	new Handle:hIterator = GetPluginIterator();
	new bool:bIsValid;
	while (MorePlugins(hIterator))
	{
		if (ReadPlugin(hIterator) == plugin)
		{
			bIsValid = true;
			CloseHandle(hIterator);
			return bIsValid;
		}
	}
	CloseHandle(hIterator);
	return bIsValid;
}

PluginToIndex(Handle:plugin)
{
	new Handle:hPluginPack;
	new maxPlugins = GetMaxPlugins();
	new i;
	while (i < maxPlugins)
	{
		hPluginPack = GetArrayCell(g_hPluginPacks, i, 0, false);
		SetPackPosition(hPluginPack, PluginPack_Plugin);
		if (ReadPackCell(hPluginPack) == plugin)
		{
			return i;
		}
		i++;
	}
	return -1;
}

Handle:IndexToPlugin(index)
{
	new Handle:hPluginPack = GetArrayCell(g_hPluginPacks, index, 0, false);
	SetPackPosition(hPluginPack, PluginPack_Plugin);
	return ReadPackCell(hPluginPack);
}

Updater_AddPlugin(Handle:plugin, String:url[])
{
	new index = PluginToIndex(plugin);
	if (index != -1)
	{
		new maxPlugins = GetArraySize(g_hRemoveQueue);
		new i;
		while (i < maxPlugins)
		{
			if (GetArrayCell(g_hRemoveQueue, i, 0, false) == plugin)
			{
				RemoveFromArray(g_hRemoveQueue, i);
				Updater_SetURL(index, url);
			}
			i++;
		}
		Updater_SetURL(index, url);
	}
	else
	{
		new Handle:hPluginPack = CreateDataPack();
		new Handle:hFiles = CreateArray(256, 0);
		PluginPack_Plugin = GetPackPosition(hPluginPack);
		WritePackCell(hPluginPack, plugin);
		PluginPack_Files = GetPackPosition(hPluginPack);
		WritePackCell(hPluginPack, hFiles);
		PluginPack_Status = GetPackPosition(hPluginPack);
		WritePackCell(hPluginPack, any:0);
		PluginPack_URL = GetPackPosition(hPluginPack);
		WritePackString(hPluginPack, url);
		PushArrayCell(g_hPluginPacks, hPluginPack);
	}
	return 0;
}

Updater_QueueRemovePlugin(Handle:plugin)
{
	new maxPlugins = GetArraySize(g_hRemoveQueue);
	new i;
	while (i < maxPlugins)
	{
		if (GetArrayCell(g_hRemoveQueue, i, 0, false) == plugin)
		{
			return 0;
		}
		i++;
	}
	PushArrayCell(g_hRemoveQueue, plugin);
	Updater_FreeMemory();
	return 0;
}

Updater_RemovePlugin(index)
{
	CloseHandle(Updater_GetFiles(index));
	CloseHandle(GetArrayCell(g_hPluginPacks, index, 0, false));
	RemoveFromArray(g_hPluginPacks, index);
	return 0;
}

Handle:Updater_GetFiles(index)
{
	new Handle:hPluginPack = GetArrayCell(g_hPluginPacks, index, 0, false);
	SetPackPosition(hPluginPack, PluginPack_Files);
	return ReadPackCell(hPluginPack);
}

UpdateStatus:Updater_GetStatus(index)
{
	new Handle:hPluginPack = GetArrayCell(g_hPluginPacks, index, 0, false);
	SetPackPosition(hPluginPack, PluginPack_Status);
	return ReadPackCell(hPluginPack);
}

Updater_SetStatus(index, UpdateStatus:status)
{
	new Handle:hPluginPack = GetArrayCell(g_hPluginPacks, index, 0, false);
	SetPackPosition(hPluginPack, PluginPack_Status);
	WritePackCell(hPluginPack, status);
	return 0;
}

Updater_GetURL(index, String:buffer[], size)
{
	new Handle:hPluginPack = GetArrayCell(g_hPluginPacks, index, 0, false);
	SetPackPosition(hPluginPack, PluginPack_URL);
	ReadPackString(hPluginPack, buffer, size);
	return 0;
}

Updater_SetURL(index, String:url[])
{
	new Handle:hPluginPack = GetArrayCell(g_hPluginPacks, index, 0, false);
	SetPackPosition(hPluginPack, PluginPack_URL);
	WritePackString(hPluginPack, url);
	return 0;
}

StripPathFilename(String:path[])
{
	strcopy(path, FindCharInString(path, 47, true) + 1, path);
	return 0;
}

GetPathBasename(String:path[], String:buffer[], maxlength)
{
	new check = -1;
	new var1;
	if ((check = FindCharInString(path, 47, true)) == -1 && (check = FindCharInString(path, 92, true)) == -1)
	{
		strcopy(buffer, maxlength, path[check + 1]);
	}
	else
	{
		strcopy(buffer, maxlength, path);
	}
	return 0;
}

PrefixURL(String:buffer[], maxlength, String:url[])
{
	new var1;
	if (strncmp(url, "http://", 7, true) && strncmp(url, "https://", 8, true))
	{
		Format(buffer, maxlength, "http://%s", url);
	}
	else
	{
		strcopy(buffer, maxlength, url);
	}
	return 0;
}

ParseURL(String:url[], String:host[], maxHost, String:location[], maxLoc, String:filename[], maxName)
{
	new var2;
	var2 = StrContains(url, "://", true);
	new var1;
	if (var2 != -1)
	{
		var1 = var2 + 3;
	}
	else
	{
		var1 = 0;
	}
	var2 = var1;
	new var3;
	new total = ExplodeString(url[var2], "/", var3, 16, 64, false);
	Format(host, maxHost, "%s", var3 + var3);
	location[0] = MissingTAG:0;
	new i = 1;
	while (total + -1 > i)
	{
		Format(location, maxLoc, "%s/%s", location, var3[i]);
		i++;
	}
	Format(filename, maxName, "%s", var3[total + -1]);
	return 0;
}

ParseSMCPathForLocal(String:path[], String:buffer[], maxlength)
{
	new var1;
	new total = ExplodeString(path, "/", var1, 16, 64, false);
	if (StrEqual(var1 + var1, "Path_SM", true))
	{
		BuildPath(PathType:0, buffer, maxlength, "");
	}
	else
	{
		buffer[0] = MissingTAG:0;
	}
	new i = 1;
	while (total + -1 > i)
	{
		Format(buffer, maxlength, "%s%s/", buffer, var1[i]);
		if (!DirExists(buffer))
		{
			CreateDirectory(buffer, 511);
		}
		i++;
	}
	Format(buffer, maxlength, "%s%s", buffer, var1[total + -1]);
	return 0;
}

ParseSMCPathForDownload(String:path[], String:buffer[], maxlength)
{
	new var1;
	new total = ExplodeString(path, "/", var1, 16, 64, false);
	buffer[0] = MissingTAG:0;
	new i = 1;
	while (i < total)
	{
		Format(buffer, maxlength, "%s/%s", buffer, var1[i]);
		i++;
	}
	return 0;
}

bool:ParseUpdateFile(index, String:path[])
{
	SMC_Sections = CreateArray(64, 0);
	SMC_DataTrie = CreateTrie();
	SMC_DataPack = CreateDataPack();
	SMC_LineNum = 0;
	new Handle:smc = SMC_CreateParser();
	SMC_SetRawLine(smc, Updater_RawLine);
	SMC_SetReaders(smc, Updater_NewSection, Updater_KeyValue, Updater_EndSection);
	decl String:sBuffer[256];
	decl Handle:hPack;
	new bool:bUpdate;
	new SMCError:err = SMC_ParseFile(smc, path, 0, 0);
	if (err)
	{
		Updater_Log("SMC parsing error on line %d", SMC_LineNum);
		Updater_GetURL(index, sBuffer, 256);
		Updater_Log("  [0]  URL: %s", sBuffer);
		if (SMC_GetErrorString(err, sBuffer, 256))
		{
			Updater_Log("  [1]  ERROR: %s", sBuffer);
		}
	}
	else
	{
		new Handle:hPlugin = IndexToPlugin(index);
		new Handle:hFiles = Updater_GetFiles(index);
		ClearArray(hFiles);
		decl String:sCurrentVersion[16];
		if (!GetPluginInfo(hPlugin, PluginInfo:3, sCurrentVersion, 16))
		{
			strcopy(sCurrentVersion, 16, "Null");
		}
		new String:smcLatestVersion[16];
		if (GetTrieValue(SMC_DataTrie, "version->latest", hPack))
		{
			ResetPack(hPack, false);
			ReadPackString(hPack, smcLatestVersion, 16);
		}
		if (!StrEqual(sCurrentVersion, smcLatestVersion, true))
		{
			decl String:sFilename[64];
			decl String:sName[64];
			GetPluginFilename(hPlugin, sFilename, 64);
			if (GetPluginInfo(hPlugin, PluginInfo:0, sName, 64))
			{
				Updater_Log("Update available for \"%s\" (%s). Current: %s - Latest: %s", sName, sFilename, sCurrentVersion, smcLatestVersion);
			}
			else
			{
				Updater_Log("Update available for \"%s\". Current: %s - Latest: %s", sFilename, sCurrentVersion, smcLatestVersion);
			}
			if (GetTrieValue(SMC_DataTrie, "information->notes", hPack))
			{
				ResetPack(hPack, false);
				new iCount;
				while (IsPackReadable(hPack, 1))
				{
					ReadPackString(hPack, sBuffer, 256);
					iCount++;
					Updater_Log("  [%i]  %s", iCount, sBuffer);
				}
			}
			new var1;
			if (g_bGetDownload && Fwd_OnPluginDownloading(hPlugin))
			{
				new String:smcPrevVersion[16];
				if (GetTrieValue(SMC_DataTrie, "version->previous", hPack))
				{
					ResetPack(hPack, false);
					ReadPackString(hPack, smcPrevVersion, 16);
				}
				new var2;
				if (StrEqual(sCurrentVersion, smcPrevVersion, true) && GetTrieValue(SMC_DataTrie, "patch->plugin", hPack))
				{
					ParseSMCFilePack(index, hPack, hFiles);
					new var3;
					if (g_bGetSource && GetTrieValue(SMC_DataTrie, "patch->source", hPack))
					{
						ParseSMCFilePack(index, hPack, hFiles);
					}
				}
				else
				{
					if (GetTrieValue(SMC_DataTrie, "files->plugin", hPack))
					{
						ParseSMCFilePack(index, hPack, hFiles);
						new var4;
						if (g_bGetSource && GetTrieValue(SMC_DataTrie, "files->source", hPack))
						{
							ParseSMCFilePack(index, hPack, hFiles);
						}
					}
				}
				Updater_SetStatus(index, UpdateStatus:2);
			}
			else
			{
				Updater_SetStatus(index, UpdateStatus:3);
			}
			bUpdate = true;
		}
	}
	ResetPack(SMC_DataPack, false);
	while (IsPackReadable(SMC_DataPack, 1))
	{
		ReadPackString(SMC_DataPack, sBuffer, 256);
		if (GetTrieValue(SMC_DataTrie, sBuffer, hPack))
		{
			CloseHandle(hPack);
		}
	}
	CloseHandle(SMC_Sections);
	CloseHandle(SMC_DataTrie);
	CloseHandle(SMC_DataPack);
	CloseHandle(smc);
	return bUpdate;
}

ParseSMCFilePack(index, Handle:hPack, Handle:hFiles)
{
	decl String:urlprefix[256];
	decl String:url[256];
	decl String:dest[256];
	decl String:sBuffer[256];
	Updater_GetURL(index, urlprefix, 256);
	StripPathFilename(urlprefix);
	ResetPack(hPack, false);
	while (IsPackReadable(hPack, 1))
	{
		ReadPackString(hPack, sBuffer, 256);
		ParseSMCPathForDownload(sBuffer, url, 256);
		Format(url, 256, "%s%s", urlprefix, url);
		ParseSMCPathForLocal(sBuffer, dest, 256);
		decl String:sLocalBase[64];
		decl String:sPluginBase[64];
		decl String:sFilename[64];
		GetPathBasename(dest, sLocalBase, 64);
		GetPathBasename(sFilename, sPluginBase, 64);
		if (StrEqual(sLocalBase, sPluginBase, true))
		{
			StripPathFilename(dest);
			Format(dest, 256, "%s/%s", dest, sFilename);
		}
		PushArrayString(hFiles, dest);
		Format(dest, 256, "%s.%s", dest, "temp");
		AddToDownloadQueue(index, url, dest);
	}
	return 0;
}

public SMCResult:Updater_RawLine(Handle:smc, String:line[], lineno)
{
	SMC_LineNum = lineno;
	return SMCResult:0;
}

public SMCResult:Updater_NewSection(Handle:smc, String:name[], bool:opt_quotes)
{
	PushArrayString(SMC_Sections, name);
	return SMCResult:0;
}

public SMCResult:Updater_KeyValue(Handle:smc, String:key[], String:value[], bool:key_quotes, bool:value_quotes)
{
	decl String:sCurSection[256];
	decl String:sKey[256];
	decl Handle:hPack;
	GetArrayString(SMC_Sections, GetArraySize(SMC_Sections) + -1, sCurSection, 256);
	FormatEx(sKey, 256, "%s->%s", sCurSection, key);
	StringToLower(sKey);
	if (!GetTrieValue(SMC_DataTrie, sKey, hPack))
	{
		hPack = CreateDataPack();
		SetTrieValue(SMC_DataTrie, sKey, hPack, true);
		WritePackString(SMC_DataPack, sKey);
	}
	WritePackString(hPack, value);
	return SMCResult:0;
}

public SMCResult:Updater_EndSection(Handle:smc)
{
	if (GetArraySize(SMC_Sections))
	{
		RemoveFromArray(SMC_Sections, GetArraySize(SMC_Sections) + -1);
	}
	return SMCResult:0;
}

StringToLower(String:input[])
{
	new length = strlen(input);
	new i;
	while (i < length)
	{
		input[i] = CharToLower(input[i]);
		i++;
	}
	return 0;
}

Download_cURL(String:url[], String:dest[])
{
	PrefixURL(_NULLVAR_, 256, url);
	new var1;
	var1 = curl_OpenFile(dest, "wb");
	if (var1)
	{
		new var2 = 0;
		new Handle:headers = curl_slist();
		curl_slist_append(headers, "Pragma: no-cache");
		curl_slist_append(headers, "Cache-Control: no-cache");
		new Handle:hDLPack = CreateDataPack();
		WritePackCell(hDLPack, var1);
		WritePackCell(hDLPack, headers);
		new Handle:curl = curl_easy_init();
		curl_easy_setopt_int_array(curl, var2, 5);
		curl_easy_setopt_handle(curl, CURLoption:10001, var1);
		curl_easy_setopt_string(curl, CURLoption:10002, url);
		curl_easy_setopt_handle(curl, CURLoption:10023, headers);
		curl_easy_perform_thread(curl, OnCurlComplete, hDLPack);
		return 0;
	}
	decl String:sError[256];
	FormatEx(sError, 256, "Error writing to file: %s", dest);
	DownloadEnded(false, sError);
	return 0;
}

public OnCurlComplete(Handle:curl, CURLcode:code, any:hDLPack)
{
	ResetPack(hDLPack, false);
	CloseHandle(ReadPackCell(hDLPack));
	CloseHandle(ReadPackCell(hDLPack));
	CloseHandle(hDLPack);
	CloseHandle(curl);
	if (code)
	{
		decl String:sError[256];
		curl_easy_strerror(code, sError, 256);
		Format(sError, 256, "cURL error: %s", sError);
		DownloadEnded(false, sError);
	}
	else
	{
		DownloadEnded(true, "");
	}
	return 0;
}

Download_Socket(String:url[], String:dest[])
{
	decl String:sURL[256];
	PrefixURL(sURL, 256, url);
	if (strncmp(sURL, "https://", 8, true))
	{
		new Handle:hFile = OpenFile(dest, "wb");
		if (hFile)
		{
			decl String:hostname[64];
			decl String:location[128];
			decl String:filename[64];
			decl String:sRequest[384];
			ParseURL(sURL, hostname, 64, location, 128, filename, 64);
			FormatEx(sRequest, 384, "GET %s/%s HTTP/1.0\r\nHost: %s\r\nConnection: close\r\nPragma: no-cache\r\nCache-Control: no-cache\r\n\r\n", location, filename, hostname);
			new Handle:hDLPack = CreateDataPack();
			DLPack_Header = GetPackPosition(hDLPack);
			WritePackCell(hDLPack, any:0);
			DLPack_Redirects = GetPackPosition(hDLPack);
			WritePackCell(hDLPack, any:0);
			DLPack_File = GetPackPosition(hDLPack);
			WritePackCell(hDLPack, hFile);
			DLPack_Request = GetPackPosition(hDLPack);
			WritePackString(hDLPack, sRequest);
			new Handle:socket = SocketCreate(SocketType:1, OnSocketError);
			SocketSetArg(socket, hDLPack);
			SocketSetOption(socket, SocketOption:1, 4096);
			SocketConnect(socket, OnSocketConnected, OnSocketReceive, OnSocketDisconnected, hostname, 80);
			return 0;
		}
		decl String:sError[256];
		FormatEx(sError, 256, "Error writing to file: %s", dest);
		DownloadEnded(false, sError);
		return 0;
	}
	decl String:sError[256];
	FormatEx(sError, 256, "Socket does not support HTTPs (URL: %s).", sURL);
	DownloadEnded(false, sError);
	return 0;
}

public OnSocketConnected(Handle:socket, any:hDLPack)
{
	decl String:sRequest[384];
	SetPackPosition(hDLPack, DLPack_Request);
	ReadPackString(hDLPack, sRequest, 384);
	SocketSend(socket, sRequest, -1);
	return 0;
}

public OnSocketReceive(Handle:socket, String:data[], size, any:hDLPack)
{
	new idx;
	SetPackPosition(hDLPack, DLPack_Header);
	new bool:bParsedHeader = ReadPackCell(hDLPack);
	new iRedirects = ReadPackCell(hDLPack);
	if (!bParsedHeader)
	{
		if ((idx = StrContains(data, "\r\n\r\n", true)) == -1)
		{
			idx = 0;
		}
		else
		{
			idx += 4;
		}
		if (!(strncmp(data, "HTTP/", 5, true)))
		{
			new idx2 = StrContains(data, "\nLocation: ", false);
			new var2;
			if (idx2 > -1 && (idx2 < idx || !idx))
			{
				iRedirects++;
				if (iRedirects > 5)
				{
					CloseSocketHandles(socket, hDLPack);
					DownloadEnded(false, "Socket error: too many redirects.");
					return 0;
				}
				SetPackPosition(hDLPack, DLPack_Redirects);
				WritePackCell(hDLPack, iRedirects);
				idx2 += 11;
				decl String:sURL[256];
				strcopy(sURL, FindCharInString(data[idx2], 13, false) + 1, data[idx2]);
				PrefixURL(sURL, 256, sURL);
				if (strncmp(sURL, "https://", 8, true))
				{
					decl String:hostname[64];
					decl String:location[128];
					decl String:filename[64];
					decl String:sRequest[384];
					ParseURL(sURL, hostname, 64, location, 128, filename, 64);
					FormatEx(sRequest, 384, "GET %s/%s HTTP/1.0\r\nHost: %s\r\nConnection: close\r\nPragma: no-cache\r\nCache-Control: no-cache\r\n\r\n", location, filename, hostname);
					SetPackPosition(hDLPack, DLPack_Request);
					WritePackString(hDLPack, sRequest);
					new Handle:newSocket = SocketCreate(SocketType:1, OnSocketError);
					SocketSetArg(newSocket, hDLPack);
					SocketSetOption(newSocket, SocketOption:1, 4096);
					SocketConnect(newSocket, OnSocketConnected, OnSocketReceive, OnSocketDisconnected, hostname, 80);
					CloseHandle(socket);
					return 0;
				}
				CloseSocketHandles(socket, hDLPack);
				decl String:sError[256];
				FormatEx(sError, 256, "Socket does not support HTTPs (URL: %s).", sURL);
				DownloadEnded(false, sError);
				return 0;
			}
			decl String:sStatusCode[64];
			strcopy(sStatusCode, FindCharInString(data, 13, false) + -8, data[2]);
			if (strncmp(sStatusCode, "200", 3, true))
			{
				CloseSocketHandles(socket, hDLPack);
				decl String:sError[256];
				FormatEx(sError, 256, "Socket error: %s", sStatusCode);
				DownloadEnded(false, sError);
				return 0;
			}
		}
		SetPackPosition(hDLPack, DLPack_Header);
		WritePackCell(hDLPack, any:1);
	}
	SetPackPosition(hDLPack, DLPack_File);
	new Handle:hFile = ReadPackCell(hDLPack);
	while (idx < size)
	{
		idx++;
		WriteFileCell(hFile, data[idx], 1);
	}
	return 0;
}

public OnSocketDisconnected(Handle:socket, any:hDLPack)
{
	CloseSocketHandles(socket, hDLPack);
	DownloadEnded(true, "");
	return 0;
}

public OnSocketError(Handle:socket, errorType, errorNum, any:hDLPack)
{
	CloseSocketHandles(socket, hDLPack);
	decl String:sError[256];
	FormatEx(sError, 256, "Socket error: %d (Error code %d)", errorType, errorNum);
	DownloadEnded(false, sError);
	return 0;
}

CloseSocketHandles(Handle:socket, Handle:hDLPack)
{
	SetPackPosition(hDLPack, DLPack_File);
	CloseHandle(ReadPackCell(hDLPack));
	CloseHandle(hDLPack);
	CloseHandle(socket);
	return 0;
}

Download_SteamTools(String:url[], String:dest[])
{
	decl String:sURL[256];
	PrefixURL(sURL, 256, url);
	new Handle:hDLPack = CreateDataPack();
	WritePackString(hDLPack, dest);
	new HTTPRequestHandle:hRequest = Steam_CreateHTTPRequest(HTTPMethod:1, sURL);
	Steam_SetHTTPRequestHeaderValue(hRequest, "Pragma", "no-cache");
	Steam_SetHTTPRequestHeaderValue(hRequest, "Cache-Control", "no-cache");
	Steam_SendHTTPRequest(hRequest, OnSteamHTTPComplete, hDLPack);
	return 0;
}

public OnSteamHTTPComplete(HTTPRequestHandle:HTTPRequest, bool:requestSuccessful, HTTPStatusCode:statusCode, any:hDLPack)
{
	decl String:sDest[256];
	ResetPack(hDLPack, false);
	ReadPackString(hDLPack, sDest, 256);
	CloseHandle(hDLPack);
	new var1;
	if (requestSuccessful && statusCode == HTTPStatusCode:200)
	{
		Steam_WriteHTTPResponseBody(HTTPRequest, sDest);
		DownloadEnded(true, "");
	}
	else
	{
		decl String:sError[256];
		new var2;
		if (requestSuccessful)
		{
			var2[0] = 4276;
		}
		else
		{
			var2[0] = 4284;
		}
		FormatEx(sError, 256, "SteamTools error (status code %i). Request successful: %s", statusCode, var2);
		DownloadEnded(false, sError);
	}
	Steam_ReleaseHTTPRequest(HTTPRequest);
	return 0;
}

public Steam_FullyLoaded()
{
	g_bSteamLoaded = true;
	return 0;
}

public Steam_Shutdown()
{
	g_bSteamLoaded = false;
	return 0;
}

Download_SteamWorks(String:url[], String:dest[])
{
	decl String:sURL[256];
	PrefixURL(sURL, 256, url);
	new Handle:hDLPack = CreateDataPack();
	WritePackString(hDLPack, dest);
	new Handle:hRequest = SteamWorks_CreateHTTPRequest(EHTTPMethod:1, sURL);
	SteamWorks_SetHTTPRequestHeaderValue(hRequest, "Pragma", "no-cache");
	SteamWorks_SetHTTPRequestHeaderValue(hRequest, "Cache-Control", "no-cache");
	SteamWorks_SetHTTPCallbacks(hRequest, SteamWorksHTTPRequestCompleted:31, SteamWorksHTTPHeadersReceived:-1, SteamWorksHTTPDataReceived:-1, Handle:0);
	SteamWorks_SetHTTPRequestContextValue(hRequest, hDLPack, any:0);
	SteamWorks_SendHTTPRequest(hRequest);
	return 0;
}

public OnSteamWorksHTTPComplete(Handle:hRequest, bool:bFailure, bool:bRequestSuccessful, EHTTPStatusCode:eStatusCode, any:hDLPack)
{
	decl String:sDest[256];
	ResetPack(hDLPack, false);
	ReadPackString(hDLPack, sDest, 256);
	CloseHandle(hDLPack);
	new var1;
	if (bRequestSuccessful && eStatusCode == EHTTPStatusCode:200)
	{
		SteamWorks_WriteHTTPResponseBodyToFile(hRequest, sDest);
		DownloadEnded(true, "");
	}
	else
	{
		decl String:sError[256];
		new var2;
		if (bRequestSuccessful)
		{
			var2[0] = 4404;
		}
		else
		{
			var2[0] = 4412;
		}
		FormatEx(sError, 256, "SteamWorks error (status code %i). Request successful: %s", eStatusCode, var2);
		DownloadEnded(false, sError);
	}
	CloseHandle(hRequest);
	return 0;
}

FinalizeDownload(index)
{
	decl String:newpath[256];
	decl String:oldpath[256];
	new Handle:hFiles = Updater_GetFiles(index);
	new maxFiles = GetArraySize(hFiles);
	new i;
	while (i < maxFiles)
	{
		GetArrayString(hFiles, i, newpath, 256);
		Format(oldpath, 256, "%s.%s", newpath, "temp");
		if (FileExists(newpath, false))
		{
			DeleteFile(newpath);
		}
		RenameFile(newpath, oldpath);
		i++;
	}
	ClearArray(hFiles);
	return 0;
}

AbortDownload(index)
{
	decl String:path[256];
	new Handle:hFiles = Updater_GetFiles(index);
	new maxFiles = GetArraySize(hFiles);
	new i;
	while (i < maxFiles)
	{
		GetArrayString(hFiles, 0, path, 256);
		Format(path, 256, "%s.%s", path, "temp");
		if (FileExists(path, false))
		{
			DeleteFile(path);
		}
		i++;
	}
	ClearArray(hFiles);
	return 0;
}

ProcessDownloadQueue(bool:force)
{
	new var2;
	if (!force && (g_bDownloading || !GetArraySize(g_hDownloadQueue)))
	{
		return 0;
	}
	new Handle:hQueuePack = GetArrayCell(g_hDownloadQueue, 0, 0, false);
	SetPackPosition(hQueuePack, QueuePack_URL);
	decl String:url[256];
	decl String:dest[256];
	ReadPackString(hQueuePack, url, 256);
	ReadPackString(hQueuePack, dest, 256);
	new var3;
	if (!GetFeatureStatus(FeatureType:0, "curl_easy_init") == 0 && !GetFeatureStatus(FeatureType:0, "SocketCreate") == 0 && !GetFeatureStatus(FeatureType:0, "Steam_CreateHTTPRequest") == 0 && !GetFeatureStatus(FeatureType:0, "SteamWorks_WriteHTTPResponseBodyToFile") == 0)
	{
		SetFailState("This plugin requires one of the cURL, Socket, SteamTools, or SteamWorks extensions to function.");
	}
	g_bDownloading = true;
	if (GetFeatureStatus(FeatureType:0, "SteamWorks_WriteHTTPResponseBodyToFile"))
	{
		if (GetFeatureStatus(FeatureType:0, "Steam_CreateHTTPRequest"))
		{
			if (GetFeatureStatus(FeatureType:0, "curl_easy_init"))
			{
				if (!(GetFeatureStatus(FeatureType:0, "SocketCreate")))
				{
					Download_Socket(url, dest);
				}
			}
			Download_cURL(url, dest);
		}
		if (g_bSteamLoaded)
		{
			Download_SteamTools(url, dest);
		}
		else
		{
			CreateTimer(10.0, Timer_RetryQueue, any:0, 0);
		}
	}
	else
	{
		if (SteamWorks_IsLoaded())
		{
			Download_SteamWorks(url, dest);
		}
		else
		{
			CreateTimer(10.0, Timer_RetryQueue, any:0, 0);
		}
	}
	return 0;
}

public Action:Timer_RetryQueue(Handle:timer)
{
	ProcessDownloadQueue(true);
	return Action:4;
}

AddToDownloadQueue(index, String:url[], String:dest[])
{
	new Handle:hQueuePack = CreateDataPack();
	WritePackCell(hQueuePack, index);
	QueuePack_URL = GetPackPosition(hQueuePack);
	WritePackString(hQueuePack, url);
	WritePackString(hQueuePack, dest);
	PushArrayCell(g_hDownloadQueue, hQueuePack);
	ProcessDownloadQueue(false);
	return 0;
}

DownloadEnded(bool:successful, String:error[])
{
	new Handle:hQueuePack = GetArrayCell(g_hDownloadQueue, 0, 0, false);
	ResetPack(hQueuePack, false);
	decl String:url[256];
	decl String:dest[256];
	new index = ReadPackCell(hQueuePack);
	ReadPackString(hQueuePack, url, 256);
	ReadPackString(hQueuePack, dest, 256);
	CloseHandle(hQueuePack);
	RemoveFromArray(g_hDownloadQueue, 0);
	switch (Updater_GetStatus(index))
	{
		case 1:
		{
			new var2;
			if (!successful || !ParseUpdateFile(index, dest))
			{
				Updater_SetStatus(index, UpdateStatus:0);
			}
		}
		case 2:
		{
			if (successful)
			{
				decl String:lastfile[256];
				new Handle:hFiles = Updater_GetFiles(index);
				GetArrayString(hFiles, GetArraySize(hFiles) + -1, lastfile, 256);
				Format(lastfile, 256, "%s.%s", lastfile, "temp");
				if (StrEqual(dest, lastfile, true))
				{
					new Handle:hPlugin = IndexToPlugin(index);
					Fwd_OnPluginUpdating(hPlugin);
					FinalizeDownload(index);
					decl String:sName[64];
					if (!GetPluginInfo(hPlugin, PluginInfo:0, sName, 64))
					{
						strcopy(sName, 64, "Null");
					}
					Updater_Log("Successfully updated and installed \"%s\".", sName);
					Updater_SetStatus(index, UpdateStatus:3);
					Fwd_OnPluginUpdated(hPlugin);
				}
			}
			else
			{
				AbortDownload(index);
				Updater_SetStatus(index, UpdateStatus:4);
				decl String:filename[64];
				GetPluginFilename(IndexToPlugin(index), filename, 64);
				Updater_Log("Error downloading update for plugin: %s", filename);
				Updater_Log("  [0]  URL: %s", url);
				Updater_Log("  [1]  Destination: %s", dest);
				if (error[0])
				{
					Updater_Log("  [2]  %s", error);
				}
			}
		}
		case 4:
		{
			new var1;
			if (successful && FileExists(dest, false))
			{
				DeleteFile(dest);
			}
		}
		default:
		{
		}
	}
	g_bDownloading = false;
	ProcessDownloadQueue(false);
	return 0;
}

API_Init()
{
	CreateNative("Updater_AddPlugin", Native_AddPlugin);
	CreateNative("Updater_RemovePlugin", Native_RemovePlugin);
	CreateNative("Updater_ForceUpdate", Native_ForceUpdate);
	fwd_OnPluginChecking = CreateForward(ExecType:2);
	fwd_OnPluginDownloading = CreateForward(ExecType:2);
	fwd_OnPluginUpdating = CreateForward(ExecType:0);
	fwd_OnPluginUpdated = CreateForward(ExecType:0);
	return 0;
}

public Native_AddPlugin(Handle:plugin, numParams)
{
	decl String:url[256];
	GetNativeString(1, url, 256, 0);
	Updater_AddPlugin(plugin, url);
	return 0;
}

public Native_RemovePlugin(Handle:plugin, numParams)
{
	new index = PluginToIndex(plugin);
	if (index != -1)
	{
		Updater_QueueRemovePlugin(plugin);
	}
	return 0;
}

public Native_ForceUpdate(Handle:plugin, numParams)
{
	new index = PluginToIndex(plugin);
	if (index == -1)
	{
		ThrowNativeError(6, "Plugin not found in updater.");
	}
	else
	{
		if (!(Updater_GetStatus(index)))
		{
			Updater_Check(index);
			return 1;
		}
	}
	return 0;
}

Action:Fwd_OnPluginChecking(Handle:plugin)
{
	new Action:result;
	new Function:func = GetFunctionByName(plugin, "Updater_OnPluginChecking");
	new var1;
	if (func != -1 && AddToForward(fwd_OnPluginChecking, plugin, func))
	{
		Call_StartForward(fwd_OnPluginChecking);
		Call_Finish(result);
		RemoveAllFromForward(fwd_OnPluginChecking, plugin);
	}
	return result;
}

Action:Fwd_OnPluginDownloading(Handle:plugin)
{
	new Action:result;
	new Function:func = GetFunctionByName(plugin, "Updater_OnPluginDownloading");
	new var1;
	if (func != -1 && AddToForward(fwd_OnPluginDownloading, plugin, func))
	{
		Call_StartForward(fwd_OnPluginDownloading);
		Call_Finish(result);
		RemoveAllFromForward(fwd_OnPluginDownloading, plugin);
	}
	return result;
}

Fwd_OnPluginUpdating(Handle:plugin)
{
	new Function:func = GetFunctionByName(plugin, "Updater_OnPluginUpdating");
	new var1;
	if (func != -1 && AddToForward(fwd_OnPluginUpdating, plugin, func))
	{
		Call_StartForward(fwd_OnPluginUpdating);
		Call_Finish(0);
		RemoveAllFromForward(fwd_OnPluginUpdating, plugin);
	}
	return 0;
}

Fwd_OnPluginUpdated(Handle:plugin)
{
	new Function:func = GetFunctionByName(plugin, "Updater_OnPluginUpdated");
	new var1;
	if (func != -1 && AddToForward(fwd_OnPluginUpdated, plugin, func))
	{
		Call_StartForward(fwd_OnPluginUpdated);
		Call_Finish(0);
		RemoveAllFromForward(fwd_OnPluginUpdated, plugin);
	}
	return 0;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	MarkNativeAsOptional("curl_OpenFile");
	MarkNativeAsOptional("curl_slist");
	MarkNativeAsOptional("curl_slist_append");
	MarkNativeAsOptional("curl_easy_init");
	MarkNativeAsOptional("curl_easy_setopt_int_array");
	MarkNativeAsOptional("curl_easy_setopt_handle");
	MarkNativeAsOptional("curl_easy_setopt_string");
	MarkNativeAsOptional("curl_easy_perform_thread");
	MarkNativeAsOptional("curl_easy_strerror");
	MarkNativeAsOptional("SocketCreate");
	MarkNativeAsOptional("SocketSetArg");
	MarkNativeAsOptional("SocketSetOption");
	MarkNativeAsOptional("SocketConnect");
	MarkNativeAsOptional("SocketSend");
	MarkNativeAsOptional("Steam_CreateHTTPRequest");
	MarkNativeAsOptional("Steam_SetHTTPRequestHeaderValue");
	MarkNativeAsOptional("Steam_SendHTTPRequest");
	MarkNativeAsOptional("Steam_WriteHTTPResponseBody");
	MarkNativeAsOptional("Steam_ReleaseHTTPRequest");
	API_Init();
	RegPluginLibrary("updater");
	return APLRes:0;
}

public OnPluginStart()
{
	new var1;
	if (!GetFeatureStatus(FeatureType:0, "curl_easy_init") == 0 && !GetFeatureStatus(FeatureType:0, "SocketCreate") == 0 && !GetFeatureStatus(FeatureType:0, "Steam_CreateHTTPRequest") == 0 && !GetFeatureStatus(FeatureType:0, "SteamWorks_WriteHTTPResponseBodyToFile") == 0)
	{
		SetFailState("This plugin requires one of the cURL, Socket, SteamTools, or SteamWorks extensions to function.");
	}
	LoadTranslations("common.phrases");
	new Handle:hCvar = CreateConVar("sm_updater_version", "1.2.2", "Updater", 393472, false, 0.0, false, 0.0);
	OnVersionChanged(hCvar, "", "");
	HookConVarChange(hCvar, OnVersionChanged);
	hCvar = CreateConVar("sm_updater", "2", "Determines update functionality. (1 = Notify, 2 = Download, 3 = Include source code)", 262144, true, 1.0, true, 3.0);
	OnSettingsChanged(hCvar, "", "");
	HookConVarChange(hCvar, OnSettingsChanged);
	RegAdminCmd("sm_updater_check", Command_Check, 4096, "Forces Updater to check for updates.", "", 0);
	RegAdminCmd("sm_updater_status", Command_Status, 4096, "View the status of Updater.", "", 0);
	g_hPluginPacks = CreateArray(1, 0);
	g_hDownloadQueue = CreateArray(1, 0);
	g_hRemoveQueue = CreateArray(1, 0);
	BuildPath(PathType:0, _sDataPath, 256, "data/updater.txt");
	Updater_AddPlugin(GetMyHandle(), "http://godtony.mooo.com/updater/updater.txt");
	_hUpdateTimer = CreateTimer(86400.0, Timer_CheckUpdates, any:0, 1);
	return 0;
}

public OnAllPluginsLoaded()
{
	TriggerTimer(_hUpdateTimer, true);
	return 0;
}

public Action:Timer_CheckUpdates(Handle:timer)
{
	Updater_FreeMemory();
	new maxPlugins = GetMaxPlugins();
	new i;
	while (i < maxPlugins)
	{
		if (Updater_GetStatus(i))
		{
		}
		else
		{
			Updater_Check(i);
		}
		i++;
	}
	_fLastUpdate = GetTickedTime();
	return Action:0;
}

public Action:Command_Check(client, args)
{
	new Float:fNextUpdate = _fLastUpdate + 3600.0;
	if (fNextUpdate > GetTickedTime())
	{
		ReplyToCommand(client, "[Updater] Updates can only be checked once per hour. %.1f minutes remaining.", fNextUpdate - GetTickedTime() / 60.0);
	}
	else
	{
		ReplyToCommand(client, "[Updater] Checking for updates.");
		TriggerTimer(_hUpdateTimer, true);
	}
	return Action:3;
}

public Action:Command_Status(client, args)
{
	decl String:sFilename[64];
	new Handle:hPlugin;
	new maxPlugins = GetMaxPlugins();
	ReplyToCommand(client, "[Updater] -- Status Begin --");
	ReplyToCommand(client, "Plugins being monitored for updates:");
	new i;
	while (i < maxPlugins)
	{
		hPlugin = IndexToPlugin(i);
		if (IsValidPlugin(hPlugin))
		{
			GetPluginFilename(hPlugin, sFilename, 64);
			ReplyToCommand(client, "  [%i]  %s", i, sFilename);
		}
		i++;
	}
	ReplyToCommand(client, "Last update check was %.1f minutes ago.", GetTickedTime() - _fLastUpdate / 60.0);
	ReplyToCommand(client, "[Updater] --- Status End ---");
	return Action:3;
}

public OnVersionChanged(Handle:convar, String:oldValue[], String:newValue[])
{
	if (!StrEqual(newValue, "1.2.2", true))
	{
		SetConVarString(convar, "1.2.2", false, false);
	}
	return 0;
}

public OnSettingsChanged(Handle:convar, String:oldValue[], String:newValue[])
{
	switch (GetConVarInt(convar))
	{
		case 1:
		{
			g_bGetDownload = false;
			g_bGetSource = false;
		}
		case 2:
		{
			g_bGetDownload = true;
			g_bGetSource = false;
		}
		case 3:
		{
			g_bGetDownload = true;
			g_bGetSource = true;
		}
		default:
		{
		}
	}
	return 0;
}

public Updater_OnPluginUpdated()
{
	Updater_Log("Reloading Updater plugin... updates will resume automatically.");
	decl String:filename[64];
	GetPluginFilename(Handle:0, filename, 64);
	ServerCommand("sm plugins reload %s", filename);
	return 0;
}

Updater_Check(index)
{
	if (!(Fwd_OnPluginChecking(IndexToPlugin(index))))
	{
		decl String:url[256];
		Updater_GetURL(index, url, 256);
		Updater_SetStatus(index, UpdateStatus:1);
		AddToDownloadQueue(index, url, _sDataPath);
	}
	return 0;
}

Updater_FreeMemory()
{
	new var1;
	if (g_bDownloading || GetArraySize(g_hDownloadQueue))
	{
		return 0;
	}
	new index;
	new maxPlugins = GetArraySize(g_hRemoveQueue);
	new i;
	while (i < maxPlugins)
	{
		index = PluginToIndex(GetArrayCell(g_hRemoveQueue, i, 0, false));
		if (index != -1)
		{
			Updater_RemovePlugin(index);
		}
		i++;
	}
	ClearArray(g_hRemoveQueue);
	new i;
	while (GetMaxPlugins() > i)
	{
		if (!IsValidPlugin(IndexToPlugin(i)))
		{
			Updater_RemovePlugin(i);
			i--;
		}
		i++;
	}
	return 0;
}

Updater_Log(String:format[])
{
	decl String:buffer[256];
	decl String:path[256];
	VFormat(buffer, 256, format, 2);
	BuildPath(PathType:0, path, 256, "logs/Updater.log");
	LogToFileEx(path, "%s", buffer);
	return 0;
}

