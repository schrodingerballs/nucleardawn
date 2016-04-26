public PlVers:__version =
{
	version = 5,
	filevers = "1.7.0",
	date = "02/08/2015",
	time = "05:45:24"
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
new Handle:cvar_type[6];
new Handle:cvar_time[6];
new Handle:cvar_arch_demos;
new Handle:cvar_arch_replays;
new Handle:cvar_enable;
new Handle:cvar_logtype;
new Handle:cvar_demopath;
new Handle:cvar_logging;
new Handle:g_warpath;
new Handle:g_logsdir;
new Handle:g_backuproundprefix;
new String:s_backuproundprefix[256];
new bool:b_usewarmod;
public Plugin:myinfo =
{
	name = "Server Clean Up",
	description = "Cleans up logs and demo files automatically",
	author = "Jamster",
	version = "1.2.2",
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

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

public void:OnPluginStart()
{
	LoadTranslations("servercleanup.phrases");
	decl String:desc[256];
	FormatEx(desc, 256, "%t", "srvcln_version");
	CreateConVar("sm_srvcln_version", "1.2.2", desc, 401728, false, 0.0, false, 0.0);
	FormatEx(desc, 256, "%t", "srvcln_enable");
	cvar_enable = CreateConVar("sm_srvcln_enable", "1", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_logging_mode");
	cvar_logging = CreateConVar("sm_srvcln_logging_mode", "0", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_logs");
	cvar_type[0] = CreateConVar("sm_srvcln_logs", "1", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_smlogs");
	cvar_type[1] = CreateConVar("sm_srvcln_smlogs", "1", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_demos");
	cvar_type[2] = CreateConVar("sm_srvcln_demos", "0", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_replays");
	cvar_type[5] = CreateConVar("sm_srvcln_replays", "0", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_replays_archives");
	cvar_arch_replays = CreateConVar("sm_srvcln_replays_archives", "0", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_roundbackups");
	cvar_type[4] = CreateConVar("sm_srvcln_roundbackups", "0", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_demos_path");
	cvar_demopath = CreateConVar("sm_srvcln_demos_path", "", desc, 262144, false, 0.0, false, 0.0);
	FormatEx(desc, 256, "%t", "srvcln_sprays");
	cvar_type[3] = CreateConVar("sm_srvcln_sprays", "0", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_demos_archives");
	cvar_arch_demos = CreateConVar("sm_srvcln_demos_archives", "0", desc, 262144, true, 0.0, true, 1.0);
	FormatEx(desc, 256, "%t", "srvcln_smlogs_type");
	cvar_logtype = CreateConVar("sm_srvcln_smlogs_type", "0", desc, 262144, true, 0.0, true, 2.0);
	FormatEx(desc, 256, "%t", "srvcln_logs_time");
	cvar_time[0] = CreateConVar("sm_srvcln_logs_time", "168", desc, 262144, true, -1.0, false, 0.0);
	FormatEx(desc, 256, "%t", "srvcln_sprays_time");
	cvar_time[3] = CreateConVar("sm_srvcln_sprays_time", "168", desc, 262144, true, -1.0, false, 0.0);
	FormatEx(desc, 256, "%t", "srvcln_smlogs_time");
	cvar_time[1] = CreateConVar("sm_srvcln_smlogs_time", "168", desc, 262144, true, -1.0, false, 0.0);
	FormatEx(desc, 256, "%t", "srvcln_demos_time");
	cvar_time[2] = CreateConVar("sm_srvcln_demos_time", "168", desc, 262144, true, -1.0, false, 0.0);
	FormatEx(desc, 256, "%t", "srvcln_replays_time");
	cvar_time[5] = CreateConVar("sm_srvcln_replays_time", "168", desc, 262144, true, -1.0, false, 0.0);
	FormatEx(desc, 256, "%t", "srvcln_roundbackups_time");
	cvar_time[4] = CreateConVar("sm_srvcln_roundbackups_time", "168", desc, 262144, true, -1.0, false, 0.0);
	FormatEx(desc, 256, "%t", "srvcln_now");
	RegAdminCmd("sm_srvcln_now", CommandCleanNow, 16384, desc, "", 0);
	g_logsdir = FindConVar("sv_logsdir");
	g_backuproundprefix = FindConVar("mp_backup_round_file");
	return void:0;
}

public void:OnAllPluginsLoaded()
{
	g_warpath = FindConVar("wm_save_dir");
	if (g_warpath)
	{
		b_usewarmod = true;
	}
	else
	{
		b_usewarmod = false;
	}
	return void:0;
}

public void:OnConfigsExecuted()
{
	if (GetConVarInt(cvar_enable))
	{
		new i;
		while (i < 6)
		{
			if (GetConVarInt(cvar_type[i]))
			{
				CleanServer(i);
			}
			i++;
		}
	}
	return void:0;
}

public Action:CommandCleanNow(client, args)
{
	ReplyToCommand(client, "%t", "Command Now Start");
	new i;
	while (i < 6)
	{
		if (GetConVarInt(cvar_type[i]))
		{
			CleanServer(i);
		}
		i++;
	}
	ReplyToCommand(client, "%t", "Command Now End");
	LogMessage("\"%L\" %t", client, "Command Now Log");
	return Action:3;
}

CleanServer(type)
{
	new Time32;
	new TimeType = GetConVarInt(cvar_time[type]);
	if (TimeType != -1)
	{
		if (TimeType < 12)
		{
			Time32 = GetTime({0,0}) / 3600 + -12;
			TimeType = 12;
		}
		else
		{
			Time32 = GetTime({0,0}) / 3600 - TimeType;
		}
	}
	else
	{
		decl String:day[12];
		FormatTime(day, 10, "%Y%j", -1);
		Time32 = StringToInt(day, 10);
	}
	new String:filename[256];
	new String:dir[256];
	new logging = GetConVarInt(cvar_logging);
	switch (type)
	{
		case 0:
		{
			GetConVarString(g_logsdir, dir, 256);
		}
		case 1:
		{
			BuildPath(PathType:0, dir, 256, "logs");
		}
		case 2:
		{
			GetConVarString(cvar_demopath, dir, 256);
		}
		case 3:
		{
			FormatEx(dir, 256, "downloads");
		}
		case 4:
		{
			FormatEx(dir, 256, "");
		}
		default:
		{
		}
	}
	new var1;
	if (b_usewarmod && type == 2)
	{
		GetConVarString(g_warpath, dir, 256);
	}
	new Handle:h_dir;
	new var2;
	if (type == 4 && g_backuproundprefix)
	{
		new String:cvar[256];
		GetConVarString(g_backuproundprefix, cvar, 256);
		TrimString(cvar);
		if (!cvar[0])
		{
			FormatEx(s_backuproundprefix, 256, "round");
		}
		else
		{
			FormatEx(s_backuproundprefix, 256, "%s_round", cvar);
		}
	}
	else
	{
		if (type == 4)
		{
			return 0;
		}
	}
	new strLength;
	new DelArchDemos = GetConVarInt(cvar_arch_demos);
	new DelArchReplays = GetConVarInt(cvar_arch_replays);
	new LogType = GetConVarInt(cvar_logtype);
	if (type == 5)
	{
		new i;
		while (i <= 2)
		{
			switch (i)
			{
				case 0:
				{
					FormatEx(dir, 256, "replay/server/blocks");
				}
				case 1:
				{
					FormatEx(dir, 256, "replay/server/sessions");
				}
				case 2:
				{
					FormatEx(dir, 256, "replay/server/tmp");
				}
				default:
				{
				}
			}
			if (DirExists(dir, false, "GAME"))
			{
				h_dir = OpenDirectory(dir, false, "GAME");
				while (ReadDirEntry(h_dir, filename, 256, 0))
				{
					new var3;
					if (!(StrEqual(filename, ".", true) || StrEqual(filename, "..", true)))
					{
						strLength = strlen(filename);
						new var4;
						if (strLength + -4 != StrContains(filename, ".dmx", false) && strLength + -6 != StrContains(filename, ".block", false))
						{
							CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
						}
						new var6;
						if (DelArchReplays && (strLength + -4 != StrContains(filename, ".zip", false) && strLength + -4 != StrContains(filename, ".bz2", false) && strLength + -4 != StrContains(filename, ".rar", false) && strLength + -3 != StrContains(filename, ".7z", false)))
						{
							CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
						}
					}
				}
				CloseHandle(h_dir);
				h_dir = MissingTAG:0;
			}
			i++;
		}
	}
	else
	{
		if (type == 3)
		{
			if (DirExists(dir, false, "GAME"))
			{
				h_dir = OpenDirectory(dir, false, "GAME");
				while (ReadDirEntry(h_dir, filename, 256, 0))
				{
					new var7;
					if (!(StrEqual(filename, ".", true) || StrEqual(filename, "..", true)))
					{
						strLength = strlen(filename);
						new var8;
						if (strLength + -4 != StrContains(filename, ".dat", false) && strLength + -5 != StrContains(filename, ".ztmp", false))
						{
							CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
						}
					}
				}
				CloseHandle(h_dir);
				h_dir = MissingTAG:0;
			}
			FormatEx(dir, 256, "download/user_custom");
			if (DirExists(dir, false, "GAME"))
			{
				h_dir = OpenDirectory(dir, false, "GAME");
				new String:subdir[256];
				new String:fullpath[256];
				new Handle:h_subdir;
				while (ReadDirEntry(h_dir, subdir, 256, 0))
				{
					new var9;
					if (!(StrEqual(subdir, ".", true) || StrEqual(subdir, "..", true)))
					{
						FormatEx(fullpath, 256, "%s/%s", dir, subdir);
						if (DirExists(fullpath, false, "GAME"))
						{
							h_subdir = OpenDirectory(fullpath, false, "GAME");
							new bool:emptyfolder = 1;
							while (ReadDirEntry(h_subdir, filename, 256, 0))
							{
								new var10;
								if (!(StrEqual(filename, ".", true) || StrEqual(filename, "..", true)))
								{
									emptyfolder = false;
									strLength = strlen(filename);
									new var11;
									if (strLength + -4 != StrContains(filename, ".dat", false) && strLength + -5 != StrContains(filename, ".ztmp", false))
									{
										CanDelete(Time32, TimeType, fullpath, filename, type, logging, 0, 0);
									}
								}
							}
							CloseHandle(h_subdir);
							h_subdir = MissingTAG:0;
							if (emptyfolder)
							{
								CanDelete(Time32, TimeType, dir, subdir, type, logging, 1, 1);
							}
						}
					}
				}
				CloseHandle(h_dir);
				h_dir = MissingTAG:0;
			}
		}
		if (DirExists(dir, false, "GAME"))
		{
			h_dir = OpenDirectory(dir, false, "GAME");
			while (ReadDirEntry(h_dir, filename, 256, 0))
			{
				new var12;
				if (!(StrEqual(filename, ".", true) || StrEqual(filename, "..", true)))
				{
					strLength = strlen(filename);
					if (type)
					{
						if (type == 1)
						{
							if (!LogType)
							{
								new var13;
								if (StrContains(filename, "l", false) && strLength + -4 == StrContains(filename, ".log", false))
								{
									CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
								}
							}
							else
							{
								if (LogType == 1)
								{
									new var14;
									if ((StrContains(filename, "l", false) && StrContains(filename, "errors_", false)) && strLength + -4 == StrContains(filename, ".log", false))
									{
										CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
									}
								}
								new var16;
								if (LogType == 2 && strLength + -4 == StrContains(filename, ".log", false))
								{
									CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
								}
							}
						}
						if (type == 2)
						{
							new var17;
							if ((StrContains(filename, "auto-", false) && b_usewarmod) && strLength + -4 == StrContains(filename, ".dem", false))
							{
								CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
							}
							new var19;
							if ((DelArchDemos && StrContains(filename, "auto-", false)) || b_usewarmod || (strLength + -4 != StrContains(filename, ".zip", false) && strLength + -4 != StrContains(filename, ".bz2", false) && strLength + -4 != StrContains(filename, ".rar", false) && strLength + -3 != StrContains(filename, ".7z", false)))
							{
								CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
							}
						}
						if (type == 4)
						{
							new var23;
							if (StrContains(filename, s_backuproundprefix, false) && strLength + -4 == StrContains(filename, ".txt", false) && IsCharNumeric(filename[strLength + -5]) && IsCharNumeric(filename[strLength + -6]))
							{
								CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
							}
						}
					}
					else
					{
						if (strLength + -4 == StrContains(filename, ".log", false))
						{
							CanDelete(Time32, TimeType, dir, filename, type, logging, 0, 0);
						}
					}
				}
			}
			CloseHandle(h_dir);
			h_dir = MissingTAG:0;
		}
	}
	return 1;
}

CanDelete(Time32, TimeType, String:dir[], String:filename[], type, logging, force, folder)
{
	new TimeStamp;
	decl String:file[256];
	FormatEx(file, 256, "%s/%s", dir, filename);
	if (type == 3)
	{
		TimeStamp = GetFileTime(file, FileTimeMode:0);
		if (TimeStamp == -1)
		{
			TimeStamp = GetFileTime(file, FileTimeMode:2);
		}
	}
	else
	{
		TimeStamp = GetFileTime(file, FileTimeMode:2);
	}
	if (TimeType != -1)
	{
		TimeStamp /= 3600;
	}
	else
	{
		decl String:day[12];
		FormatTime(day, 10, "%Y%j", TimeStamp);
		TimeStamp = StringToInt(day, 10);
	}
	if (TimeStamp == -1)
	{
		LogError("%t", "CL Error TS", file);
	}
	new var1;
	if (Time32 > TimeStamp || force)
	{
		new var2;
		if (folder)
		{
			var2 = !RemoveDir(file);
		}
		else
		{
			var2 = !DeleteFile(file, false, "DEFAULT_WRITE_PATH");
		}
		if (var2)
		{
			LogError("%t", "CL Error Del", file);
		}
		if (logging)
		{
			switch (folder)
			{
				case 0:
				{
					LogMessage("%t", "CL Deleted File", file);
				}
				case 1:
				{
					LogMessage("%t", "CL Deleted Folder", file);
				}
				default:
				{
				}
			}
		}
	}
	return 0;
}

