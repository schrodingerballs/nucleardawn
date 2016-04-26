public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "05/06/2015",
	time = "21:09:10"
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
new Handle:g_version;
new Handle:g_enabled;
new Handle:g_simple;
new Handle:g_normal;
new String:map[256];
new bool:downloadfiles = 1;
new String:mediatype[256];
new downloadtype;
public Plugin:myinfo =
{
	name = "SM File/Folder Downloader and Precacher",
	description = "Downloads and Precaches Files",
	author = "SWAT_88",
	version = "1.4",
	url = "http://www.sourcemod.net"
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

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

StrCat(String:buffer[], maxlength, String:source[])
{
	new len = strlen(buffer);
	if (len >= maxlength)
	{
		return 0;
	}
	return Format(buffer[len], maxlength - len, "%s", source);
}

AddFileToDownloadsTable(String:filename[])
{
	static table = -1;
	if (table == -1)
	{
		table = FindStringTable("downloadables");
	}
	new bool:save = LockStringTables(false);
	AddToStringTable(table, filename, "", -1);
	LockStringTables(save);
	return 0;
}

public OnPluginStart()
{
	g_simple = CreateConVar("sm_downloader_simple", "1", "", 0, false, 0.0, false, 0.0);
	g_normal = CreateConVar("sm_downloader_normal", "1", "", 0, false, 0.0, false, 0.0);
	g_enabled = CreateConVar("sm_downloader_enabled", "1", "", 0, false, 0.0, false, 0.0);
	g_version = CreateConVar("sm_downloader_version", "1.4", "SM File Downloader and Precacher Version", 256, false, 0.0, false, 0.0);
	SetConVarString(g_version, "1.4", false, false);
	return 0;
}

public OnPluginEnd()
{
	CloseHandle(g_version);
	CloseHandle(g_enabled);
	CloseHandle(g_simple);
	CloseHandle(g_normal);
	return 0;
}

public OnMapStart()
{
	if (GetConVarInt(g_enabled) == 1)
	{
		if (GetConVarInt(g_normal) == 1)
		{
			ReadDownloads();
		}
		if (GetConVarInt(g_simple) == 1)
		{
			ReadDownloadsSimple();
		}
	}
	return 0;
}

public ReadFileFolder(String:path[])
{
	new Handle:dirh;
	new String:buffer[256];
	new String:tmp_path[256];
	new FileType:type;
	new len = strlen(path);
	if (path[len + -1] == '
')
	{
		len--;
		path[len] = MissingTAG:0;
	}
	TrimString(path);
	if (DirExists(path))
	{
		dirh = OpenDirectory(path);
		while (ReadDirEntry(dirh, buffer, 256, type))
		{
			len = strlen(buffer);
			if (buffer[len + -1] == '
')
			{
				len--;
				buffer[len] = MissingTAG:0;
			}
			TrimString(buffer);
			new var1;
			if (!StrEqual(buffer, "", false) && !StrEqual(buffer, ".", false) && !StrEqual(buffer, "..", false))
			{
				strcopy(tmp_path, 255, path);
				StrCat(tmp_path, 255, "/");
				StrCat(tmp_path, 255, buffer);
				if (type == FileType:2)
				{
					if (downloadtype == 1)
					{
						ReadItem(tmp_path);
					}
					else
					{
						ReadItemSimple(tmp_path);
					}
				}
				ReadFileFolder(tmp_path);
			}
		}
	}
	else
	{
		if (downloadtype == 1)
		{
			ReadItem(path);
		}
		ReadItemSimple(path);
	}
	if (dirh)
	{
		CloseHandle(dirh);
	}
	return 0;
}

public ReadDownloads()
{
	new String:file[256];
	BuildPath(PathType:0, file, 255, "configs/downloads.ini");
	new Handle:fileh = OpenFile(file, "r");
	new String:buffer[256];
	downloadtype = 1;
	new len;
	GetCurrentMap(map, 255);
	if (!fileh)
	{
		return 0;
	}
	while (ReadFileLine(fileh, buffer, 256))
	{
		len = strlen(buffer);
		if (buffer[len + -1] == '
')
		{
			len--;
			buffer[len] = MissingTAG:0;
		}
		TrimString(buffer);
		if (!StrEqual(buffer, "", false))
		{
			ReadFileFolder(buffer);
		}
		if (IsEndOfFile(fileh))
		{
			if (fileh)
			{
				CloseHandle(fileh);
			}
			return 0;
		}
	}
	if (fileh)
	{
		CloseHandle(fileh);
	}
	return 0;
}

public ReadItem(String:buffer[])
{
	new len = strlen(buffer);
	if (buffer[len + -1] == '
')
	{
		len--;
		buffer[len] = MissingTAG:0;
	}
	TrimString(buffer);
	if (0 <= StrContains(buffer, "//Files (Download Only No Precache)", true))
	{
		strcopy(mediatype, 255, "File");
		downloadfiles = true;
	}
	else
	{
		if (0 <= StrContains(buffer, "//Decal Files (Download and Precache)", true))
		{
			strcopy(mediatype, 255, "Decal");
			downloadfiles = true;
		}
		if (0 <= StrContains(buffer, "//Sound Files (Download and Precache)", true))
		{
			strcopy(mediatype, 255, "Sound");
			downloadfiles = true;
		}
		if (0 <= StrContains(buffer, "//Model Files (Download and Precache)", true))
		{
			strcopy(mediatype, 255, "Model");
			downloadfiles = true;
		}
		new var1;
		if (len >= 2 && buffer[0] == '/' && buffer[0] == '/')
		{
			if (0 <= StrContains(buffer, "//", true))
			{
				ReplaceString(buffer, 255, "//", "", true);
			}
			if (StrEqual(buffer, map, true))
			{
				downloadfiles = true;
			}
			else
			{
				if (StrEqual(buffer, "Any", false))
				{
					downloadfiles = true;
				}
				downloadfiles = false;
			}
		}
		new var2;
		if (!StrEqual(buffer, "", false) && FileExists(buffer, false))
		{
			if (downloadfiles)
			{
				if (0 <= StrContains(mediatype, "Decal", true))
				{
					PrecacheDecal(buffer, true);
				}
				else
				{
					if (0 <= StrContains(mediatype, "Sound", true))
					{
						PrecacheSound(buffer, true);
					}
					if (0 <= StrContains(mediatype, "Model", true))
					{
						PrecacheModel(buffer, true);
					}
				}
				AddFileToDownloadsTable(buffer);
			}
		}
	}
	return 0;
}

public ReadDownloadsSimple()
{
	new String:file[256];
	BuildPath(PathType:0, file, 255, "configs/downloads_simple.ini");
	new Handle:fileh = OpenFile(file, "r");
	new String:buffer[256];
	downloadtype = 2;
	new len;
	if (!fileh)
	{
		return 0;
	}
	while (ReadFileLine(fileh, buffer, 256))
	{
		len = strlen(buffer);
		if (buffer[len + -1] == '
')
		{
			len--;
			buffer[len] = MissingTAG:0;
		}
		TrimString(buffer);
		if (!StrEqual(buffer, "", false))
		{
			ReadFileFolder(buffer);
		}
		if (IsEndOfFile(fileh))
		{
			if (fileh)
			{
				CloseHandle(fileh);
			}
			return 0;
		}
	}
	if (fileh)
	{
		CloseHandle(fileh);
	}
	return 0;
}

public ReadItemSimple(String:buffer[])
{
	new len = strlen(buffer);
	if (buffer[len + -1] == '
')
	{
		len--;
		buffer[len] = MissingTAG:0;
	}
	TrimString(buffer);
	new var1;
	if (len >= 2 && buffer[0] == '/' && buffer[0] == '/')
	{
	}
	else
	{
		new var2;
		if (!StrEqual(buffer, "", false) && FileExists(buffer, false))
		{
			AddFileToDownloadsTable(buffer);
		}
	}
	return 0;
}

