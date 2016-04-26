public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "03/21/2016",
	time = "17:57:01"
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
public SharedPlugin:__pl_commander =
{
	name = "nd_commander",
	file = "nd_commander_restrictions.smx",
	required = 0,
};
public SharedPlugin:__pl_slot =
{
	name = "nd_slot",
	file = "nd_managed_slots.smx",
	required = 0,
};
new g_Integer[6];
new g_Handle[5];
new g_Float[5];
new g_Cvar[8];
new joinCheck[66];
new bool:g_Bool[9];
new clientType[66];
new bool:g_isStacker[66];
new lockTeam[66] =
{
	-1, ...
};
new LevelCacheArray[66] =
{
	-1, ...
};
new ProratedQuadraticCacheArray[66] =
{
	-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};
new ProratedLevelCache[2][66];
new Float:ProratedLinearCacheArray[2][66];
new Float:ProratedFinalLinearCache[2][66];
new connectionTime[66] =
{
	-1, ...
};
new scorePerMinute[66] =
{
	-1, ...
};
new previousTeam[66] =
{
	-1, ...
};
new bool:g_isSkilledRookie[66];
new bool:g_isWeakVeteran[66];
new String:nd_middle_players[248][80] =
{
	"STEAM_1:1:57388815",
	"STEAM_1:0:20117506",
	"STEAM_1:1:19250159",
	"STEAM_1:0:58887668",
	"STEAM_1:1:50783946",
	"STEAM_1:0:79421132",
	"STEAM_1:0:29184711",
	"STEAM_1:0:38931860",
	"STEAM_1:1:30973858",
	"STEAM_1:0:21901341",
	"STEAM_1:1:33826106",
	"STEAM_1:0:56730404",
	"STEAM_1:0:47004502",
	"STEAM_1:1:1568242",
	"STEAM_1:1:5592794",
	"STEAM_1:0:87168627",
	"STEAM_1:1:74776837",
	"STEAM_1:0:87276878",
	"STEAM_1:0:38232618",
	"STEAM_1:1:45399755",
	"STEAM_1:1:15682428",
	"STEAM_1:0:22214157",
	"STEAM_1:0:45364298",
	"STEAM_1:1:26936909",
	"STEAM_1:0:11307412",
	"STEAM_1:0:61068555",
	"STEAM_1:1:27361073",
	"STEAM_1:0:30914756",
	"STEAM_1:1:11520539",
	"STEAM_1:0:39106724",
	"STEAM_1:1:519227",
	"STEAM_1:1:44078660",
	"STEAM_1:0:32437639",
	"STEAM_1:1:32890854",
	"STEAM_1:0:54997929",
	"STEAM_1:0:41912516",
	"STEAM_1:0:90964343",
	"STEAM_1:1:4707474",
	"STEAM_1:0:48487004",
	"STEAM_1:1:30059278",
	"STEAM_1:0:39439766",
	"STEAM_1:0:28424253",
	"STEAM_1:1:20567834",
	"STEAM_1:0:13513477",
	"STEAM_1:1:22650625",
	"STEAM_1:0:26337108",
	"STEAM_1:1:25328463",
	"STEAM_1:0:22998152",
	"STEAM_1:1:18011023",
	"STEAM_1:0:33149971",
	"STEAM_1:0:23137096",
	"STEAM_1:1:2074803",
	"STEAM_1:0:12141167",
	"STEAM_1:0:63202690",
	"STEAM_1:0:18544586",
	"STEAM_1:0:29477997",
	"STEAM_1:0:125443322",
	"STEAM_1:1:38534646",
	"STEAM_1:0:13126119",
	"STEAM_1:1:53653141",
	"STEAM_1:1:5595121",
	"STEAM_1:1:47155619",
	"STEAM_1:1:33655531",
	"STEAM_1:1:53736854",
	"STEAM_1:1:58105032",
	"STEAM_1:0:4088417",
	"STEAM_1:0:4205698",
	"STEAM_1:1:34867513",
	"STEAM_1:0:13698215",
	"STEAM_1:1:41797450",
	"STEAM_1:0:41006053",
	"STEAM_1:0:47122039",
	"STEAM_1:1:37997313",
	"STEAM_1:1:51835161",
	"STEAM_1:1:64900059",
	"STEAM_1:1:80278254",
	"STEAM_1:0:57767157",
	"STEAM_1:1:93461708",
	"STEAM_1:0:16029323",
	"STEAM_1:1:35434411",
	"STEAM_1:0:37549340",
	"STEAM_1:0:21447770",
	"STEAM_1:1:3013925",
	"STEAM_1:1:90676769",
	"STEAM_1:0:29722694",
	"STEAM_1:1:63384805",
	"STEAM_1:1:42383645",
	"STEAM_1:1:19433387",
	"STEAM_1:0:24815498",
	"STEAM_1:1:57260191",
	"STEAM_1:0:62586369",
	"STEAM_1:1:46186118",
	"STEAM_1:1:8268862",
	"STEAM_1:0:24609174",
	"STEAM_1:1:5266799",
	"STEAM_1:0:92691062",
	"STEAM_1:1:105371219",
	"STEAM_1:1:59090320",
	"STEAM_1:1:11931836",
	"STEAM_1:1:23508262",
	"STEAM_1:1:52693638",
	"STEAM_1:1:68580808",
	"STEAM_1:0:79963164",
	"STEAM_1:1:38119131",
	"STEAM_1:0:102504155",
	"STEAM_1:0:19091180",
	"STEAM_1:0:30763341",
	"STEAM_1:1:56225171",
	"STEAM_1:0:39030272",
	"STEAM_1:1:36972018",
	"STEAM_1:0:58726590",
	"STEAM_1:1:21676156",
	"STEAM_1:0:46806399",
	"STEAM_1:0:36035225",
	"STEAM_1:0:32414774",
	"STEAM_1:0:90964343",
	"STEAM_1:0:77077814",
	"STEAM_1:1:13604076",
	"STEAM_1:1:45661518",
	"STEAM_1:0:57613965",
	"STEAM_1:0:33349943",
	"STEAM_1:1:50981895",
	"STEAM_1:0:26063838",
	"STEAM_1:1:81585249",
	"STEAM_1:0:43288677",
	"STEAM_1:1:52893098",
	"STEAM_1:1:7366484",
	"STEAM_1:0:27218070",
	"STEAM_1:1:90482923",
	"STEAM_1:0:32738008",
	"STEAM_1:0:41435672",
	"STEAM_1:0:46928890",
	"STEAM_1:0:34383498",
	"STEAM_1:1:42074138",
	"STEAM_1:0:79194515",
	"STEAM_1:0:59601782",
	"STEAM_1:1:37835419",
	"STEAM_1:0:58808674",
	"STEAM_1:0:46549168",
	"STEAM_1:0:28808936",
	"STEAM_1:1:21273449",
	"STEAM_1:0:33842051",
	"STEAM_1:1:50632188",
	"STEAM_1:1:56851044",
	"STEAM_1:1:38384598",
	"STEAM_1:0:3562999",
	"STEAM_1:1:35127541",
	"STEAM_1:1:45491043",
	"STEAM_1:1:65741965",
	"STEAM_1:0:23417966",
	"STEAM_1:0:10900851",
	"STEAM_1:0:34761691",
	"STEAM_1:0:23084957",
	"STEAM_1:1:50191247",
	"STEAM_1:1:9222784",
	"STEAM_1:0:25178481",
	"STEAM_1:1:22541877",
	"STEAM_1:0:92440720",
	"STEAM_1:1:48120159",
	"STEAM_1:0:10989232",
	"STEAM_1:0:45580671",
	"STEAM_1:0:78412614",
	"STEAM_1:0:41594495",
	"STEAM_1:0:24290316",
	"STEAM_1:0:14472240",
	"STEAM_1:0:41787672",
	"STEAM_1:0:26346714",
	"STEAM_1:1:66452937",
	"STEAM_1:0:46406739",
	"STEAM_1:0:27388716",
	"STEAM_1:1:22151251",
	"STEAM_1:1:34840098",
	"STEAM_1:0:34926391",
	"STEAM_1:1:33530826",
	"STEAM_1:0:19228678",
	"STEAM_1:1:44161807",
	"STEAM_1:0:58831899",
	"STEAM_1:0:59986876",
	"STEAM_1:0:33489405",
	"STEAM_0:1:43162163",
	"STEAM_1:1:53534455",
	"STEAM_1:0:34339195",
	"STEAM_1:1:42633024",
	"STEAM_1:0:36384803",
	"STEAM_1:1:34079127",
	"STEAM_1:0:31515843",
	"STEAM_1:1:3874474",
	"STEAM_1:1:47798564",
	"STEAM_1:0:68128784",
	"STEAM_1:0:5634756",
	"STEAM_1:0:33264453",
	"STEAM_1:0:90299620",
	"STEAM_1:1:33119204",
	"STEAM_1:1:41080445",
	"STEAM_1:0:121184280",
	"STEAM_1:0:91630716",
	"STEAM_1:1:62439343",
	"STEAM_1:1:4376989",
	"STEAM_1:1:22442811",
	"STEAM_1:1:25489242",
	"STEAM_1:0:59981355",
	"STEAM_1:1:24163528",
	"STEAM_1:0:20066682",
	"STEAM_1:1:85233322",
	"STEAM_1:1:66371433",
	"STEAM_1:0:8986060",
	"STEAM_1:0:33476820",
	"STEAM_1:1:21264384",
	"STEAM_1:0:77075161",
	"STEAM_1:1:42008030",
	"STEAM_1:0:70497987",
	"STEAM_1:0:66692417",
	"STEAM_1:0:68773715",
	"STEAM_1:0:41996093",
	"STEAM_1:0:3721878",
	"STEAM_1:0:97713931",
	"STEAM_1:1:47754962",
	"STEAM_1:1:32194219",
	"STEAM_1:1:51595614",
	"STEAM_1:0:56812565",
	"STEAM_1:0:73321677",
	"STEAM_1:0:97146125",
	"STEAM_1:1:32555990",
	"STEAM_1:0:40466432",
	"STEAM_1:1:57957877",
	"STEAM_1:1:14046674",
	"STEAM_1:0:62764580",
	"STEAM_1:1:38402651",
	"STEAM_1:1:105386610",
	"STEAM_1:1:11666080",
	"STEAM_1:1:23161367",
	"STEAM_1:0:44374852",
	"STEAM_1:0:30827459",
	"STEAM_1:0:32600881",
	"STEAM_1:1:52161510",
	"STEAM_1:1:44227780",
	"STEAM_1:0:47359669",
	"STEAM_1:1:40402617",
	"STEAM_1:1:63577721",
	"STEAM_1:1:21100067",
	"STEAM_1:0:5754248",
	"STEAM_1:0:4903956",
	"STEAM_1:0:19068715",
	"STEAM_1:1:65890204",
	"STEAM_1:0:25609364",
	"STEAM_1:0:17544064",
	"STEAM_1:1:55435257",
	"STEAM_1:1:38505233"
};
new String:nd_top_players[244][80] =
{
	"STEAM_1:1:58651714",
	"STEAM_1:0:18973999",
	"STEAM_1:0:27111230",
	"STEAM_1:0:16654629",
	"STEAM_1:1:32804464",
	"STEAM_1:0:29089945",
	"STEAM_1:1:5667714",
	"STEAM_1:0:7181974",
	"STEAM_1:0:53362273",
	"STEAM_1:0:32859977",
	"STEAM_1:1:53587435",
	"STEAM_1:0:31419708",
	"STEAM_1:0:41308496",
	"STEAM_1:1:58399296",
	"STEAM_1:0:41825895",
	"STEAM_1:0:37655392",
	"STEAM_1:1:46107040",
	"STEAM_1:0:58794469",
	"STEAM_1:1:58951623",
	"STEAM_1:1:17862880",
	"STEAM_1:1:53763028",
	"STEAM_1:1:32251652",
	"STEAM_1:0:26518082",
	"STEAM_1:0:15404626",
	"STEAM_1:1:75529662",
	"STEAM_1:0:44254478",
	"STEAM_1:1:103112440",
	"STEAM_1:1:75641829",
	"STEAM_1:0:8032658",
	"STEAM_1:0:49607903",
	"STEAM_1:0:14458656",
	"STEAM_1:0:28409110",
	"STEAM_1:0:48630697",
	"STEAM_1:0:29258395",
	"STEAM_1:1:29989811",
	"STEAM_1:0:38477168",
	"STEAM_1:0:56168530",
	"STEAM_1:0:17513123",
	"STEAM_1:1:8766017",
	"STEAM_1:0:48021119",
	"STEAM_1:0:33195116",
	"STEAM_1:1:48003051",
	"STEAM_1:0:31299340",
	"STEAM_1:1:26076957",
	"STEAM_1:0:5348322",
	"STEAM_1:0:46330290",
	"STEAM_1:0:38614392",
	"STEAM_1:0:5067405",
	"STEAM_1:0:24205710",
	"STEAM_1:1:31931728",
	"STEAM_1:0:33657626",
	"STEAM_1:0:96059913",
	"STEAM_1:1:37013740",
	"STEAM_1:0:45414181",
	"STEAM_1:1:26078907",
	"STEAM_1:0:26435296",
	"STEAM_1:1:57760295",
	"STEAM_1:1:58089270",
	"STEAM_1:0:7990893",
	"STEAM_1:0:16995602",
	"STEAM_1:1:22680603",
	"STEAM_1:0:31394456",
	"STEAM_1:1:62422458",
	"STEAM_1:1:61475560",
	"STEAM_1:0:23448816",
	"STEAM_1:1:35621030",
	"STEAM_1:1:50110886",
	"STEAM_1:1:46649333",
	"STEAM_1:1:2782557",
	"STEAM_1:1:38656422",
	"STEAM_1:0:57899894",
	"STEAM_1:1:1297571",
	"STEAM_1:0:29542825",
	"STEAM_1:0:40732936",
	"STEAM_1:1:84371957",
	"STEAM_1:1:46808993",
	"STEAM_1:1:54249754",
	"STEAM_1:0:35290831",
	"STEAM_1:1:6054662",
	"STEAM_1:0:50217091",
	"STEAM_1:1:34706684",
	"STEAM_1:0:46548281",
	"STEAM_1:0:28782812",
	"STEAM_1:1:42206024",
	"STEAM_1:1:110273100",
	"STEAM_1:0:47377096",
	"STEAM_1:0:51222937",
	"STEAM_1:1:53716816",
	"STEAM_1:1:57981221",
	"STEAM_1:0:29527491",
	"STEAM_1:0:50470936",
	"STEAM_1:0:7307733",
	"STEAM_1:1:101041252",
	"STEAM_1:1:6073853",
	"STEAM_1:0:12791734",
	"STEAM_1:1:78170359",
	"STEAM_1:0:7971298",
	"STEAM_1:1:7546620",
	"STEAM_1:1:5316362",
	"STEAM_1:0:68207745",
	"STEAM_1:0:43826628",
	"STEAM_1:0:60847495",
	"STEAM_1:1:105062480",
	"STEAM_1:0:36140424",
	"STEAM_1:0:24518306",
	"STEAM_1:1:49060134",
	"STEAM_1:1:23788410",
	"STEAM_1:1:240259",
	"STEAM_1:1:57119047",
	"STEAM_1:0:84212346",
	"STEAM_1:0:44556801",
	"STEAM_1:0:35763836",
	"STEAM_1:1:18515267",
	"STEAM_1:1:13456110",
	"STEAM_1:1:30268857",
	"STEAM_1:0:26840153",
	"STEAM_1:1:27851609",
	"STEAM_1:1:73655896",
	"STEAM_1:0:38782833",
	"STEAM_1:0:87301099",
	"STEAM_1:1:99401946",
	"STEAM_1:0:41576484",
	"STEAM_1:1:33755767",
	"STEAM_1:0:37683262",
	"STEAM_1:0:45731351",
	"STEAM_1:1:45633666",
	"STEAM_1:0:28414655",
	"STEAM_1:0:16568774",
	"STEAM_1:0:23364715",
	"STEAM_1:1:23131172",
	"STEAM_1:0:120922576",
	"STEAM_1:0:35611539",
	"STEAM_1:0:37461260",
	"STEAM_1:0:17150289",
	"STEAM_1:1:20900125",
	"STEAM_1:0:37936451",
	"STEAM_1:0:34857962",
	"STEAM_1:0:143015476",
	"STEAM_1:0:31603129",
	"STEAM_1:1:37487925",
	"STEAM_1:1:150788320",
	"STEAM_1:0:67664609",
	"STEAM_1:1:22709689",
	"STEAM_1:1:29011172",
	"STEAM_1:1:59681635",
	"STEAM_1:0:34752441",
	"STEAM_1:0:86891817",
	"STEAM_1:1:24162803",
	"STEAM_1:1:53354988",
	"STEAM_1:0:19765883",
	"STEAM_1:0:93763110",
	"STEAM_1:0:39374680",
	"STEAM_1:1:19843462",
	"STEAM_1:1:25759904",
	"STEAM_1:1:47216787",
	"STEAM_1:0:65611233",
	"STEAM_1:1:24502018",
	"STEAM_1:1:65841059",
	"STEAM_1:1:103663742",
	"STEAM_1:0:56752178",
	"STEAM_1:1:101923604",
	"STEAM_1:1:39155305",
	"STEAM_1:0:15129794",
	"STEAM_1:0:45594062",
	"STEAM_1:1:26929916",
	"STEAM_1:0:22534230",
	"STEAM_1:1:21071675",
	"STEAM_1:0:58776476",
	"STEAM_1:0:50757327",
	"STEAM_1:1:33954373",
	"STEAM_1:0:58387998",
	"STEAM_1:1:54163906",
	"STEAM_1:0:52516388",
	"STEAM_1:0:74998805",
	"STEAM_1:1:39659517",
	"STEAM_1:1:58061940",
	"STEAM_1:0:23170857",
	"STEAM_1:1:26976651",
	"STEAM_1:1:19356706",
	"STEAM_1:0:61987251",
	"STEAM_1:1:95054530",
	"STEAM_1:1:89478187",
	"STEAM_1:1:32383606",
	"STEAM_1:1:64608964",
	"STEAM_1:1:7236729",
	"STEAM_1:0:91262115",
	"STEAM_1:0:30992389",
	"STEAM_1:1:37448115",
	"STEAM_1:1:1853986",
	"STEAM_1:1:30849437",
	"STEAM_1:0:88241861",
	"STEAM_1:1:25383030",
	"STEAM_1:1:5317760",
	"STEAM_1:1:13175650",
	"STEAM_1:1:15987345",
	"STEAM_1:0:41435672",
	"STEAM_1:1:61903159",
	"STEAM_1:0:12359987",
	"STEAM_1:0:18343697",
	"STEAM_1:0:30027065",
	"STEAM_1:0:33257266",
	"STEAM_1:1:28208778",
	"STEAM_1:1:55500973",
	"STEAM_1:1:6071581",
	"STEAM_1:1:103893059",
	"STEAM_1:0:37656668",
	"STEAM_1:0:48422195",
	"STEAM_1:1:43313023",
	"STEAM_1:0:32241691",
	"STEAM_1:0:48181633",
	"STEAM_1:1:58287877",
	"STEAM_1:1:65770297",
	"STEAM_1:1:41447353",
	"STEAM_1:1:27021193",
	"STEAM_1:0:33035622",
	"STEAM_1:0:35010700",
	"STEAM_1:1:60012123",
	"STEAM_1:0:56288753",
	"STEAM_1:0:85637259",
	"STEAM_1:1:121669879",
	"STEAM_1:1:61258862",
	"STEAM_1:0:14826564",
	"STEAM_1:1:91276424",
	"STEAM_1:0:42334052",
	"STEAM_1:0:50311866",
	"STEAM_1:0:5586272",
	"STEAM_1:0:5128789",
	"STEAM_1:0:45668566",
	"STEAM_1:0:16635137",
	"STEAM_1:1:53012939",
	"STEAM_1:0:37971558",
	"STEAM_1:0:57813228",
	"STEAM_1:1:64698087",
	"STEAM_1:1:55057211",
	"STEAM_1:0:60347941",
	"STEAM_1:1:59161836",
	"STEAM_1:1:44235730",
	"STEAM_1:0:43227464",
	"STEAM_1:0:51185796",
	"STEAM_1:1:37347548",
	"STEAM_1:1:55006941",
	"STEAM_1:0:21137011",
	"STEAM_1:1:10785528",
	"STEAM_1:1:149894414"
};
new String:nd_graduate_players[61][0];
public Extension:__ext_cprefs =
{
	name = "Client Preferences",
	file = "clientprefs.ext",
	autoload = 1,
	required = 1,
};
new Handle:cookie_team_difference_hints;
new bool:option_team_diff_hints[66] =
{
	1, ...
};
public Plugin:myinfo =
{
	name = "Team Balancer",
	description = "Provides many team balance benefits to ND.",
	author = "Stickz",
	version = "3.0.5",
	url = "N/A"
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

Float:operator/(_:,Float:)(oper1, Float:oper2)
{
	return float(oper1) / oper2;
}

bool:operator>(Float:,_:)(Float:oper1, oper2)
{
	return oper1 > float(oper2);
}

bool:operator>(_:,Float:)(oper1, Float:oper2)
{
	return float(oper1) > oper2;
}

bool:operator>=(Float:,_:)(Float:oper1, oper2)
{
	return oper1 >= float(oper2);
}

bool:operator<(Float:,_:)(Float:oper1, oper2)
{
	return oper1 < float(oper2);
}

bool:operator<(_:,Float:)(oper1, Float:oper2)
{
	return float(oper1) < oper2;
}

bool:operator<=(_:,Float:)(oper1, Float:oper2)
{
	return float(oper1) <= oper2;
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

bool:NDC_IsCommander(client)
{
	if (!GetFeatureStatus(FeatureType:0, "GetCommanderTeam") == 0)
	{
		return client == GameRules_GetPropEnt("m_hCommanders", GetClientTeam(client) + -2);
	}
	return GetCommanderTeam(client) != -1;
}

bool:NDC_IsCommanderOnTeam(client, team)
{
	if (!GetFeatureStatus(FeatureType:0, "GetCommanderTeam") == 0)
	{
		new clientTeam = GetClientTeam(client);
		new var1;
		return team == clientTeam && client == GameRules_GetPropEnt("m_hCommanders", clientTeam + -2);
	}
	return team == GetCommanderTeam(client);
}

public __pl_commander_SetNTVOptional()
{
	MarkNativeAsOptional("GetCommanderTeam");
	return 0;
}

public __pl_slot_SetNTVOptional()
{
	MarkNativeAsOptional("ToggleDynamicSlots");
	MarkNativeAsOptional("GetDynamicSlotStatus");
	MarkNativeAsOptional("GetDynamicSlotCount");
	return 0;
}

bool:GameME_SkillAvailible(client)
{
	new var1;
	return GetFeatureStatus(FeatureType:0, "GameME_GetClientSkill") && GameME_GetClientSkill(client) > 0;
}

bool:GameME_Deaths_Availible(client)
{
	new var1;
	return GetFeatureStatus(FeatureType:0, "GameME_GetClientKills") && GameME_GetClientDeaths(client) > 0;
}

bool:GameME_Kills_Availible(client)
{
	new var1;
	return GetFeatureStatus(FeatureType:0, "GameME_GetClientKills") && GameME_GetClientKills(client) > 0;
}

bool:GameME_KDR_Availible(client)
{
	new var1;
	return GetFeatureStatus(FeatureType:0, "GameME_GetClientKDR") && GameME_GetClientKDR(client) > 0.0;
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

bool:IsValidAdmin(client, String:flags[])
{
	new ibFlags = ReadFlagString(flags, 0);
	new var1;
	return ibFlags != ibFlags & GetUserFlagBits(client) && GetUserFlagBits(client) & 16384;
}

PrintToAdmins(String:message[], String:flags[])
{
	new x = 1;
	while (x <= MaxClients)
	{
		new var1;
		if (IsValidClient(x, true) && IsValidAdmin(x, flags))
		{
			PrintToChat(x, message);
		}
		x++;
	}
	return 0;
}

RetrieveScore(client, PlayerManEnt)
{
	decl PlayerManager;
	new var1;
	if (PlayerManEnt != -1)
	{
		var1 = PlayerManEnt;
	}
	else
	{
		var1 = FindEntityByClassname(-1, "nd_player_manager");
	}
	PlayerManager = var1;
	return GetEntProp(PlayerManager, PropType:0, "m_iScore", 1, client);
}

OnTeamCount()
{
	new clientCount;
	new idx = 1;
	while (idx <= MaxClients)
	{
		new var1;
		if (IsValidClient(idx, true) && GetClientTeam(idx) > 1)
		{
			clientCount++;
		}
		idx++;
	}
	return clientCount;
}

getOverBalance()
{
	new clientCount[2];
	new team;
	new idx = 1;
	while (idx <= MaxClients)
	{
		if (IsValidClient(idx, true))
		{
			team = GetClientTeam(idx);
			if (team > 1)
			{
				clientCount[team + -2]++;
			}
		}
		idx++;
	}
	return clientCount[1] - clientCount[0];
}

getPositiveOverBalance()
{
	new overBalance = getOverBalance();
	if (0 > overBalance)
	{
		overBalance *= -1;
	}
	return overBalance;
}

getOtherTeam(team)
{
	new var1;
	if (team == 2)
	{
		var1 = 3;
	}
	else
	{
		var1 = 2;
	}
	return var1;
}

bool:isOnTeam(client)
{
	new var1;
	return IsClientInGame(client) && GetClientTeam(client) > 1;
}

getLeastStackedTeam(Float:teamdiff)
{
	new var1;
	if (teamdiff > 0.0)
	{
		var1 = 3;
	}
	else
	{
		var1 = 2;
	}
	return var1;
}

getRandomTeam()
{
	return GetRandomInt(2, 3);
}

SetVarDefaults()
{
	g_Bool[0] = 0;
	g_Bool[2] = 0;
	g_Bool[1] = 0;
	g_Bool[3] = 0;
	g_Bool[4] = 0;
	g_Bool[5] = 0;
	g_Bool[6] = 0;
	g_Bool[7] = 0;
	g_Bool[8] = 0;
	new client = 1;
	while (client <= MaxClients)
	{
		joinCheck[client] = 0;
		connectionTime[client] = -1;
		scorePerMinute[client] = -1;
		client++;
	}
	return 0;
}

InitializeVariables()
{
	g_Handle[0] = CreateArray(23, 0);
	g_Handle[1] = CreateArray(23, 0);
	g_Handle[2] = CreateArray(23, 0);
	g_Handle[3] = CreateArray(23, 0);
	g_Handle[4] = CreateArray(23, 66);
	return 0;
}

resetClientValues(client)
{
	resetScoreStats(client);
	clientType[client] = 0;
	g_isSkilledRookie[client] = 0;
	g_isWeakVeteran[client] = 0;
	LevelCacheArray[client] = -1;
	ProratedQuadraticCacheArray[client] = -1;
	new i;
	while (i < 2)
	{
		ProratedLinearCacheArray[i][client] = -1.0;
		ProratedFinalLinearCache[i][client] = -1.0;
		ProratedLevelCache[i][client] = -1;
		i++;
	}
	lockTeam[client] = -1;
	g_isStacker[client] = 0;
	previousTeam[client] = -1;
	return 0;
}

resetScoreStats(client)
{
	connectionTime[client] = -1;
	scorePerMinute[client] = -1;
	return 0;
}

clearTBArrays()
{
	ClearArray(g_Handle[2]);
	ClearArray(g_Handle[3]);
	ClearArray(g_Handle[1]);
	ClearArray(g_Handle[0]);
	return 0;
}

public OnPluginEnd()
{
	CloseHandle(g_Handle[0]);
	CloseHandle(g_Handle[1]);
	CloseHandle(g_Handle[2]);
	CloseHandle(g_Handle[3]);
	CloseHandle(g_Handle[4]);
	ServerCommand("sv_visiblemaxplayers 28");
	return 0;
}

bool:isRookie(client, Float:clientLevel)
{
	new var1;
	return clientType[client] <= 1 && clientLevel * 3 <= g_Float[2];
}

bool:RequestedSpectate(client)
{
	return lockTeam[client] == 1;
}

bool:lstHasMorePlayers(overBalance)
{
	switch (overBalance)
	{
		case -1:
		{
			return g_Integer[0] == 2;
		}
		case 1:
		{
			return g_Integer[0] == 3;
		}
		default:
		{
			return false;
		}
	}
}

bool:BotsAreDisabled()
{
	new var1;
	return GetFeatureStatus(FeatureType:0, "GetDynamicSlotStatus") && GetDynamicSlotStatus();
}

bool:IsVeteran(client)
{
	new Float:clientLevel = getLinearLevel(client);
	new var1;
	return clientType[client] >= 2 || clientLevel >= 8.4E-44 || clientLevel >= g_Float[2] * 2;
}

bool:EnableSkillPrediction()
{
	new var1;
	return OnTeamCount() > 15 && g_Float[2] > 45;
}

bool:RookieClassify()
{
	return g_Float[2] < 35;
}

bool:LargeCommanderDiff()
{
	new tolerance = GetConVarInt(g_Cvar[4]) / 100;
	return g_Float[0] > g_Float[2] * tolerance;
}

bool:UseKdrEnhancedBalance(client)
{
	if (GameME_KDR_Availible(client))
	{
		decl bool:useKills;
		new var1;
		useKills = GameME_Kills_Availible(client) && GameME_GetClientKills(client) > 3000;
		decl bool:useDeaths;
		new var2;
		useDeaths = GameME_Deaths_Availible(client) && GameME_GetClientDeaths(client) > 3000;
		new var3;
		return useKills || useDeaths;
	}
	return false;
}

PercentAVLtoTD(percent)
{
	new Factor = percent / 100;
	new Difference = Factor * g_Integer[1];
	return Difference;
}

getChoiceTolerance()
{
	new overBalance = getOverBalance();
	new teamCount = OnTeamCount();
	new allocate;
	new var1;
	if (overBalance && teamCount >= 8)
	{
		new evenTeams = GetConVarInt(g_Cvar[1]);
		allocate = evenTeams - GetConVarInt(g_Cvar[3]);
		new var2;
		if (LargeCommanderDiff())
		{
			var2 = allocate;
		}
		else
		{
			var2 = evenTeams;
		}
		return var2;
	}
	new var3;
	if (lstHasMorePlayers(overBalance) && teamCount >= 12)
	{
		new oneDiff = GetConVarInt(g_Cvar[2]);
		allocate = oneDiff - GetConVarInt(g_Cvar[3]);
		new var4;
		if (LargeCommanderDiff())
		{
			var4 = allocate;
		}
		else
		{
			var4 = oneDiff;
		}
		return var4;
	}
	return -1;
}

getQuadraticLevel(client)
{
	switch (clientType[client])
	{
		case 0, 1, 2:
		{
			new clientLevel = getClientLevel(client);
			new var1;
			if (clientLevel >= 60 && UseKdrEnhancedBalance(client))
			{
				var2 = getQuadraticKDR(client, clientLevel);
			}
			else
			{
				var2 = clientLevel;
			}
			return var2;
		}
		case 3:
		{
			return ProratedQuadraticCacheArray[client];
		}
		default:
		{
			return -1;
		}
	}
}

getQuadraticKDR(client, skill)
{
	new Float:newSkill = GetKpdFactor(client) * skill;
	return RoundFloat(newSkill);
}

getClientLevel(client)
{
	if (LevelCacheArray[client] < 2)
	{
		new clientLevel = GetEntProp(GetPlayerResourceEntity(), PropType:0, "m_iPlayerRank", 1, client);
		if (clientLevel > 1)
		{
			if (clientLevel < 80)
			{
				new var1 = ProratedLevelCache;
				if (var1[0][var1][client] > clientLevel)
				{
					new var2 = ProratedLevelCache;
					clientLevel = var2[0][var2][client];
				}
				new var3 = ProratedLevelCache;
				if (var3[0][var3][client] < clientLevel)
				{
					new i;
					while (i < 2)
					{
						ProratedLevelCache[i][client] = clientLevel;
						i++;
					}
					AddInKdrSkill(client);
				}
			}
			LevelCacheArray[client] = clientLevel;
			return LevelCacheArray[client];
		}
		return 1;
	}
	return LevelCacheArray[client];
}

getTeamCountByMinutes(team, mins)
{
	new count;
	new client = 1;
	while (client <= MaxClients)
	{
		new var1;
		if (IsValidClient(client, true) && team == previousTeam[client] && connectionTime[client] >= mins)
		{
			count++;
		}
		client++;
	}
	return count;
}

getSPMaverage(team)
{
	new score;
	new count;
	new client = 1;
	while (client <= MaxClients)
	{
		new var1;
		if (IsValidClient(client, true) && team == previousTeam[client])
		{
			if (scorePerMinute[client] != -1)
			{
				score = scorePerMinute[client][score];
				count++;
			}
		}
		client++;
	}
	new var2;
	if (count > 0)
	{
		var2 = score / count;
	}
	else
	{
		var2 = -1;
	}
	return var2;
}

Float:getAverageLevel(team)
{
	new var1;
	if (team == 2)
	{
		var1 = g_Float[4];
	}
	else
	{
		var1 = g_Float[3];
	}
	return var1;
}

Float:getLinearLevel(client)
{
	switch (clientType[client])
	{
		case 0:
		{
			new clientLevel = getClientLevel(client);
			new var10 = ProratedFinalLinearCache;
			if (-1.0 != var10[0][var10][client])
			{
				new var11 = ProratedFinalLinearCache;
				return var11[0][var11][client];
			}
			if (g_isSkilledRookie[client])
			{
				new Float:cachedAverage = g_Float[2] / 1.25;
				if (clientLevel < cachedAverage)
				{
					return cachedAverage;
				}
			}
			if (RookieClassify())
			{
				return RookieMinSkillValue(clientLevel);
			}
			if (EnableSkillPrediction())
			{
				return PredictedSkill(clientLevel);
			}
			return MinSkillValue(clientLevel);
		}
		case 1, 2:
		{
			new clientLevel = getClientLevel(client);
			new var6 = ProratedFinalLinearCache;
			if (-1.0 != var6[0][var6][client])
			{
				new var7 = ProratedFinalLinearCache;
				return var7[0][var7][client];
			}
			new var8 = ProratedLinearCacheArray;
			new var5;
			if (var8[0][var8][client] > clientLevel)
			{
				new var9 = ProratedLinearCacheArray;
				var5 = var9[0][var9][client];
			}
			else
			{
				var5 = float(clientLevel);
			}
			return var5;
		}
		case 3:
		{
			decl uI;
			new var1;
			if (OnTeamCount() > 11 || g_Integer[1] > 65)
			{
				var2 = 0;
			}
			else
			{
				var2 = 1;
			}
			uI = var2;
			decl Float:ClientSkill;
			new var3;
			if (-1.0 != ProratedFinalLinearCache[uI][client])
			{
				var3 = ProratedFinalLinearCache[uI][client];
			}
			else
			{
				var3 = ProratedLinearCacheArray[uI][client];
			}
			ClientSkill = var3;
			new var4;
			if (g_isWeakVeteran[client] && ClientSkill > g_Float[2])
			{
				ClientSkill = g_Float[2];
			}
			return ClientSkill;
		}
		default:
		{
			return float(-1);
		}
	}
}

Float:GetKpdFactor(client)
{
	new Float:ClientKdr = GameME_GetClientKDR(client);
	new var1;
	if (ClientKdr < 1.0)
	{
		var1 = ClientKdr / 10.0 + 0.75;
	}
	else
	{
		var1 = ClientKdr / 20.0 + 1.0;
	}
	return var1;
}

Float:RookieMinSkillValue(clientLevel)
{
	switch (clientLevel)
	{
		case 0, 1, 2, 3, 4:
		{
			return 5.0;
		}
		case 6, 7, 8, 9:
		{
			return 10.0;
		}
		default:
		{
			return float(clientLevel);
		}
	}
}

Float:MinSkillValue(clientLevel)
{
	switch (clientLevel)
	{
		case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10:
		{
			return 10.0;
		}
		case 11, 12, 13, 14, 15:
		{
			return 15.0;
		}
		case 16, 17, 18, 19, 20:
		{
			return 20.0;
		}
		default:
		{
			return float(clientLevel);
		}
	}
}

Float:PredictedSkill(clientLevel)
{
	new Float:min = g_Float[2] / 4.25;
	new Float:max = g_Float[2] / 3;
	new var1;
	if (clientLevel < min)
	{
		var1 = min;
	}
	else
	{
		if (clientLevel < max)
		{
			var1 = max;
		}
		var1 = float(clientLevel);
	}
	return var1;
}

loadHudDisplayFeature()
{
	cookie_team_difference_hints = RegClientCookie("TeamDiff Hints On/Off", "", CookieAccess:1);
	new info;
	SetCookieMenuItem(CookieMenuHandler_TeamDiffHints, info, "TeamDiff Hints");
	return 0;
}

StartTeamDiffHudDisplay()
{
	CreateTimer(3.0, TIMER_UpdateTeamDiffHint, any:0, 3);
	return 0;
}

public Action:TIMER_UpdateTeamDiffHint(Handle:Timer)
{
	displayTeamDiffUpdate();
	return Action:0;
}

public CookieMenuHandler_TeamDiffHints(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	switch (action)
	{
		case 0:
		{
			decl String:status[12];
			new var2;
			if (option_team_diff_hints[client])
			{
				var2[0] = 19800;
			}
			else
			{
				var2[0] = 19804;
			}
			Format(status, 10, "%T", var2, client);
			Format(buffer, maxlen, "%T: %s", "Cookie TeamDiff Hints", client, status);
		}
		case 1:
		{
			option_team_diff_hints[client] = !option_team_diff_hints[client];
			new var1;
			if (option_team_diff_hints[client])
			{
				var1[0] = 19840;
			}
			else
			{
				var1[0] = 19844;
			}
			SetClientCookie(client, cookie_team_difference_hints, var1);
			ShowCookieMenu(client);
		}
		default:
		{
		}
	}
	return 0;
}

public OnClientCookiesCached(client)
{
	option_team_diff_hints[client] = GetCookieTeamDiffHints(client);
	return 0;
}

bool:GetCookieTeamDiffHints(client)
{
	decl String:buffer[12];
	GetClientCookie(client, cookie_team_difference_hints, buffer, 10);
	return StrEqual(buffer, "On", true);
}

displayTeamDiffUpdate()
{
	updateTDCache();
	decl String:stackedTeam[16];
	switch (g_Integer[0])
	{
		case 2:
		{
			Format(stackedTeam, 16, "%t", "Empire");
		}
		case 3:
		{
			Format(stackedTeam, 16, "%t", "Consortium");
		}
		default:
		{
		}
	}
	decl String:hudText[24];
	new var1;
	if (g_Integer[1] < 0)
	{
		var1 = g_Integer[2];
	}
	else
	{
		var1 = g_Integer[1];
	}
	Format(hudText, 24, "%s +%d/%d", stackedTeam, 1456 + 8, var1);
	new idx;
	while (idx < 65)
	{
		new var2;
		if (option_team_diff_hints[idx] && IsValidClient(idx, true) && isOnTeam(idx))
		{
			new var3;
			if (IsPlayerAlive(idx))
			{
				var3[0] = hudText;
			}
			else
			{
				var3[0] = 19896;
			}
			PrintHintText(idx, "%s", var3);
		}
		idx++;
	}
	return 0;
}

loadClientPrefFeatures()
{
	loadHudDisplayFeature();
	LoadTranslations("common.phrases");
	return 0;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("GetAverageSkill", Native_GetAverageSkill);
	CreateNative("WB_BalanceTeams", Native_WarmupTeamBalance);
	CreateNative("RefreshTBCache", Native_RefreshTBCache);
	return APLRes:0;
}

public Native_GetAverageSkill(Handle:plugin, numParams)
{
	updateTDCache();
	return g_Float[2];
}

public Native_WarmupTeamBalance(Handle:plugin, numParms)
{
	BalanceTeams();
	return 0;
}

public Native_RefreshTBCache(Handle:plugin, numParms)
{
	g_Bool[7] = 1;
	return 0;
}

updateTDCache()
{
	if (g_Bool[7])
	{
		UpdateSkillVarriables();
		g_Integer[2] = RoundFloat(g_Float[1]);
		new var1;
		if (g_Integer[2] < 0)
		{
			var1 = g_Integer[2] * -1;
		}
		else
		{
			var1 = g_Integer[2];
		}
		g_Integer[2] = var1;
		g_Integer[1] = RoundFloat(g_Float[2]);
		g_Integer[0] = getLeastStackedTeam(g_Float[1]);
		new var2;
		if (g_Float[3] <= g_Float[4])
		{
			var2 = 3;
		}
		else
		{
			var2 = 2;
		}
		g_Integer[3] = var2;
		g_Bool[7] = 0;
	}
	return 0;
}

UpdateSkillVarriables()
{
	new Float:consortRankedCount = 0.0;
	new Float:empireRankedCount = 0.0;
	new consortTotalCount;
	new empireTotalCount;
	new consortRookieCount;
	new empireRookieCount;
	new Float:consortCommanderSkill = -1.0;
	new Float:empireCommanderSkill = -1.0;
	new Float:clientLevel = 0.0;
	new team;
	new client;
	while (client <= MaxClients)
	{
		if (IsValidClient(client, true))
		{
			team = GetClientTeam(client);
			switch (team)
			{
				case 2:
				{
					clientLevel = getLinearLevel(client);
					if (!NDC_IsCommanderOnTeam(client, team))
					{
						consortRankedCount += clientLevel;
					}
					else
					{
						consortCommanderSkill = clientLevel;
					}
					consortTotalCount++;
					if (isRookie(client, clientLevel))
					{
						consortRookieCount++;
					}
				}
				case 3:
				{
					clientLevel = getLinearLevel(client);
					if (!NDC_IsCommanderOnTeam(client, team))
					{
						empireRankedCount += clientLevel;
					}
					else
					{
						empireCommanderSkill = clientLevel;
					}
					empireTotalCount++;
					if (isRookie(client, clientLevel))
					{
						empireRookieCount++;
					}
				}
				default:
				{
				}
			}
		}
		client++;
	}
	new Float:CommanderDifference = -1.0;
	g_Float[1] = consortRankedCount - empireRankedCount;
	new Float:skillDifference = consortCommanderSkill - empireCommanderSkill;
	if (skillDifference < 0.0)
	{
		skillDifference *= -1;
	}
	new var1;
	if (skillDifference < GetConVarInt(g_Cvar[5]) || -1.0 == empireCommanderSkill || -1.0 == consortCommanderSkill)
	{
		new Float:AverageCommSkill = consortCommanderSkill + empireCommanderSkill;
		AverageCommSkill /= 2;
		consortRankedCount += AverageCommSkill;
		empireRankedCount += AverageCommSkill;
		empireTotalCount++;
		consortTotalCount++;
		g_Float[1] = consortRankedCount - empireRankedCount;
	}
	else
	{
		if (consortCommanderSkill > empireCommanderSkill)
		{
			if (skillDifference < GetConVarInt(g_Cvar[6]))
			{
				new Float:AverageCommSkill = consortCommanderSkill + empireCommanderSkill;
				AverageCommSkill /= 2;
				consortRankedCount += AverageCommSkill;
				empireRankedCount += AverageCommSkill;
				consortRankedCount += skillDifference / 2;
			}
			else
			{
				CommanderDifference = consortCommanderSkill - empireCommanderSkill;
				g_Float[1] = consortRankedCount + CommanderDifference - empireRankedCount;
			}
		}
		if (empireCommanderSkill > consortCommanderSkill)
		{
			if (skillDifference < GetConVarInt(g_Cvar[6]))
			{
				new Float:AverageCommSkill = consortCommanderSkill + empireCommanderSkill;
				AverageCommSkill /= 2;
				consortRankedCount += AverageCommSkill;
				empireRankedCount += AverageCommSkill;
				empireRankedCount += skillDifference / 2;
			}
			CommanderDifference = empireCommanderSkill - consortCommanderSkill;
			g_Float[1] = consortRankedCount - empireRankedCount + CommanderDifference;
		}
	}
	g_Integer[5] = empireRookieCount;
	g_Integer[4] = consortRookieCount;
	g_Float[3] = empireRankedCount / float(empireTotalCount);
	g_Float[4] = consortRankedCount / float(consortTotalCount);
	g_Float[2] = g_Float[3] + g_Float[4] / 2.0;
	g_Float[0] = CommanderDifference;
	return 0;
}

setSkillByArrays(client, String:gAuth[])
{
	new idx;
	while (idx <= 243)
	{
		if (StrContains(nd_top_players[idx], gAuth, false) > -1)
		{
			clientType[client] = 3;
			new position = 244 - idx;
			new wbPosition = 324 - idx;
			ProratedQuadraticCacheArray[client] = wbPosition;
			if (position > 1064514355 * 244)
			{
				new var1 = ProratedLinearCacheArray;
				var1[0][var1][client] = float(80) + 60.0;
				ProratedLinearCacheArray[1][client] = float(80) + 30.0;
			}
			else
			{
				if (position > 1063339950 * 244)
				{
					new var2 = ProratedLinearCacheArray;
					var2[0][var2][client] = float(80) + 40.0;
					ProratedLinearCacheArray[1][client] = float(80) + 25.0;
				}
				if (position > 1060823368 * 244)
				{
					new var3 = ProratedLinearCacheArray;
					var3[0][var3][client] = float(80) + 30.0;
					ProratedLinearCacheArray[1][client] = float(80) + 20.0;
				}
				if (position > 1058306785 * 244)
				{
					new var4 = ProratedLinearCacheArray;
					var4[0][var4][client] = float(80) + 25.0;
					ProratedLinearCacheArray[1][client] = float(80) + 15.0;
				}
				if (position > 1054615798 * 244)
				{
					new var5 = ProratedLinearCacheArray;
					var5[0][var5][client] = float(80) + 20.0;
					ProratedLinearCacheArray[1][client] = float(80) + 15.0;
				}
				if (position > 1049582633 * 244)
				{
					new var6 = ProratedLinearCacheArray;
					var6[0][var6][client] = float(80) + 15.0;
					ProratedLinearCacheArray[1][client] = float(80) + 5.0;
				}
				if (position > 1040522936 * 244)
				{
					new var7 = ProratedLinearCacheArray;
					var7[0][var7][client] = float(80) + 10.0;
					ProratedLinearCacheArray[1][client] = float(80) + 5.0;
				}
				new var8 = ProratedLinearCacheArray;
				var8[0][var8][client] = float(80) + 5.0;
				ProratedLinearCacheArray[1][client] = float(80);
			}
			return 0;
		}
		idx++;
	}
	new i;
	while (i <= 247)
	{
		if (StrContains(nd_middle_players[i], gAuth, false) > -1)
		{
			clientType[client] = 2;
			new position = 248 - i;
			if (position > 1060320051 * 248)
			{
				new var9 = ProratedLinearCacheArray;
				var9[0][var9][client] = float(80);
			}
			else
			{
				if (position > 1055286886 * 248)
				{
					new var10 = ProratedLinearCacheArray;
					var10[0][var10][client] = float(80) - 5.0;
				}
				if (position > 1041865114 * 248)
				{
					new var11 = ProratedLinearCacheArray;
					var11[0][var11][client] = float(80) - 10.0;
				}
				new var12 = ProratedLinearCacheArray;
				var12[0][var12][client] = float(80) - 15.0;
			}
			return 0;
		}
		i++;
	}
	new ix;
	while (ix <= 60)
	{
		if (StrContains(nd_graduate_players[ix], gAuth, false) > -1)
		{
			clientType[client] = 1;
			new var13 = ProratedLinearCacheArray;
			var13[0][var13][client] = float(80) - 35.0;
			return 0;
		}
		ix++;
	}
	return 0;
}

SetSkillByGameMe(client)
{
	if (GameME_SkillAvailible(client))
	{
		new skill = GameME_GetClientSkill(client);
		if (skill > 50000)
		{
			clientType[client] = 3;
			new var1 = ProratedLevelCache;
			var1[0][var1][client] = 80;
			ProratedLevelCache[1][client] = 80;
			if (skill > 600000)
			{
				new var2 = ProratedLevelCache;
				var2[0][var2][client] += 70;
				ProratedLevelCache[1][client] += 35;
			}
			else
			{
				if (skill > 525000)
				{
					new var3 = ProratedLevelCache;
					var3[0][var3][client] += 65;
					ProratedLevelCache[1][client] += 35;
				}
				if (skill > 450000)
				{
					new var4 = ProratedLevelCache;
					var4[0][var4][client] += 60;
					ProratedLevelCache[1][client] += 30;
				}
				if (skill > 350000)
				{
					new var5 = ProratedLevelCache;
					var5[0][var5][client] += 50;
					ProratedLevelCache[1][client] += 30;
				}
				if (skill > 300000)
				{
					new var6 = ProratedLevelCache;
					var6[0][var6][client] += 45;
					ProratedLevelCache[1][client] += 20;
				}
				if (skill > 250000)
				{
					new var7 = ProratedLevelCache;
					var7[0][var7][client] += 40;
					ProratedLevelCache[1][client] += 20;
				}
				if (skill > 200000)
				{
					new var8 = ProratedLevelCache;
					var8[0][var8][client] += 30;
					ProratedLevelCache[1][client] += 15;
				}
				if (skill > 150000)
				{
					new var9 = ProratedLevelCache;
					var9[0][var9][client] += 25;
					ProratedLevelCache[1][client] += 10;
				}
				if (skill > 125000)
				{
					new var10 = ProratedLevelCache;
					var10[0][var10][client] += 20;
					ProratedLevelCache[1][client] += 10;
				}
				if (skill > 100000)
				{
					new var11 = ProratedLevelCache;
					var11[0][var11][client] += 15;
					ProratedLevelCache[1][client] += 7;
				}
				if (skill > 87000)
				{
					new var12 = ProratedLevelCache;
					var12[0][var12][client] += 12;
					ProratedLevelCache[1][client] += 7;
				}
				if (skill > 75000)
				{
					new var13 = ProratedLevelCache;
					var13[0][var13][client] += 10;
					ProratedLevelCache[1][client] += 5;
				}
				if (skill > 60000)
				{
					new var14 = ProratedLevelCache;
					var14[0][var14][client] += 5;
					ProratedLevelCache[1][client] += 5;
				}
			}
		}
		else
		{
			if (skill > 30000)
			{
				clientType[client] = 2;
				new var15 = ProratedLevelCache;
				var15[0][var15][client] = 80;
				ProratedLevelCache[1][client] = 80;
				if (skill > 45000)
				{
					new var16 = ProratedLevelCache;
					var16[0][var16][client] += -5;
					ProratedLevelCache[1][client] += -5;
				}
				else
				{
					if (skill > 40000)
					{
						new var17 = ProratedLevelCache;
						var17[0][var17][client] += -10;
						ProratedLevelCache[1][client] += -10;
					}
					if (skill > 35000)
					{
						new var18 = ProratedLevelCache;
						var18[0][var18][client] += -15;
						ProratedLevelCache[1][client] += -15;
					}
					if (skill > 30000)
					{
						new var19 = ProratedLevelCache;
						var19[0][var19][client] += -20;
						ProratedLevelCache[1][client] += -20;
					}
				}
			}
			clientType[client] = 0;
			if (skill > 25000)
			{
				new var20 = ProratedLevelCache;
				var20[0][var20][client] = 50;
				ProratedLevelCache[1][client] = 50;
			}
			if (skill > 20000)
			{
				new var21 = ProratedLevelCache;
				var21[0][var21][client] = 45;
				ProratedLevelCache[1][client] = 45;
			}
			if (skill > 15000)
			{
				new var22 = ProratedLevelCache;
				var22[0][var22][client] = 40;
				ProratedLevelCache[1][client] = 40;
			}
			if (skill > 10000)
			{
				new var23 = ProratedLevelCache;
				var23[0][var23][client] = 30;
				ProratedLevelCache[1][client] = 30;
			}
		}
	}
	AddInKdrSkill(client);
	return 0;
}

AddInKdrSkill(client)
{
	if (UseKdrEnhancedBalance(client))
	{
		new Float:KpdFactor = GetKpdFactor(client);
		new i;
		while (i < 2)
		{
			ProratedFinalLinearCache[i][client] = KpdFactor * ProratedLevelCache[i][client];
			i++;
		}
	}
	return 0;
}

setTeamLocks(client, String:gAuth[])
{
	if (FindStringInArray(g_Handle[1], gAuth) != -1)
	{
		lockTeam[client] = 2;
	}
	else
	{
		if (FindStringInArray(g_Handle[0], gAuth) != -1)
		{
			lockTeam[client] = 3;
		}
	}
	return 0;
}

storeBalancedTeam(client)
{
	decl String:sSteamID[24];
	GetArrayString(g_Handle[4], client, sSteamID, 22);
	if (FindStringInArray(g_Handle[2], sSteamID) != -1)
	{
		PushArrayString(g_Handle[1], sSteamID);
	}
	else
	{
		if (FindStringInArray(g_Handle[3], sSteamID) != -1)
		{
			PushArrayString(g_Handle[0], sSteamID);
		}
	}
	return 0;
}

UpdateSPM()
{
	new playerManager = FindEntityByClassname(-1, "nd_player_manager");
	new clientScore;
	new Float:SPM = 0.0;
	new spmAverage[2];
	new bool:useAdjustment[2];
	new cTeamM2;
	useAdjustment[0] = getTeamCountByMinutes(2, 5) >= 6;
	useAdjustment[1] = getTeamCountByMinutes(3, 5) >= 6;
	spmAverage[0] = getSPMaverage(2);
	spmAverage[1] = getSPMaverage(3);
	new client = 1;
	while (client <= MaxClients)
	{
		new var1;
		if (IsValidClient(client, true) && isOnTeam(client) && !NDC_IsCommander(client))
		{
			connectionTime[client]++;
			if (connectionTime[client] >= 1)
			{
				clientScore = RetrieveScore(client, playerManager);
				SPM = float(clientScore) / float(connectionTime[client]) * float(100);
				scorePerMinute[client] = RoundFloat(SPM);
				new var2;
				if (clientType[client] <= 1 && !g_isSkilledRookie[client])
				{
					cTeamM2 = GetClientTeam(client) + -2;
					new var3;
					if (connectionTime[client] >= 15 && useAdjustment[cTeamM2])
					{
						new var4;
						if (getLinearLevel(client) < g_Integer[1] / 1067450368 && scorePerMinute[client] >= spmAverage[cTeamM2])
						{
							g_isSkilledRookie[client] = 1;
							g_Bool[8] = 1;
							PrintToAdmins("debug: adjusted skill level of a rookie", "a");
						}
					}
				}
				new var5;
				if (clientType[client] >= 2 && !g_isWeakVeteran[client])
				{
					cTeamM2 = GetClientTeam(client) + -2;
					new var7;
					if (connectionTime[client] >= 15 && (useAdjustment[cTeamM2] || scorePerMinute[client] < 1000))
					{
						new var8;
						if (getLinearLevel(client) > 1067450368 * g_Integer[1] && scorePerMinute[client] <= spmAverage[cTeamM2] / 1069547520)
						{
							g_isWeakVeteran[client] = 1;
							g_Bool[8] = 1;
							PrintToAdmins("debug: adjusted skill level of a veteran", "a");
						}
					}
					new var9;
					if (connectionTime[client] >= 6 && scorePerMinute[client] < 1000)
					{
						if (getLinearLevel(client) > 1067450368 * g_Integer[1])
						{
							g_isWeakVeteran[client] = 1;
							g_Bool[8] = 1;
							PrintToAdmins("debug: adjusted skill level of a veteran", "a");
						}
					}
				}
			}
		}
		client++;
	}
	return 0;
}

InitiateRoundEnd()
{
	g_Bool[3] = 1;
	clearTBArrays();
	CheckForPluginUpdate();
	return 0;
}

CheckForPluginUpdate()
{
	ServerCommand("sm_updater_check");
	return 0;
}

ShowLevelResets()
{
	new bool:FoundEquiv;
	decl String:Message[128];
	new client = 1;
	while (client <= MaxClients)
	{
		new var1;
		if (IsValidClient(client, true) && isOnTeam(client))
		{
			new clientLevel = getClientLevel(client);
			new var2;
			if (clientLevel > 1 && clientLevel != 80 && getLinearLevel(client) >= 80)
			{
				decl String:name[32];
				GetClientName(client, name, 32);
				decl String:spaceName[36];
				Format(spaceName, 33, "%s, ", name);
				StrCat(Message, 128, spaceName);
				if (!FoundEquiv)
				{
					FoundEquiv = true;
				}
			}
		}
		client++;
	}
	if (FoundEquiv)
	{
		PrintToChatAll("\x05[TB] Level 80 Resets: %s", Message);
	}
	return 0;
}

PrintDisconnectMessage(client)
{
	decl String:Name[32];
	GetClientName(client, Name, 32);
	new var1;
	if (IsValidClient(client, true) && g_Bool[6])
	{
		PrintToChatAll("\x05[TB] %t!", "Disconnected WB", Name);
	}
	else
	{
		decl String:Message[64];
		Format(Message, 64, "\x05[TB] %s disconnected during team locks!", Name);
		PrintToAdmins(Message, "b");
	}
	return 0;
}

PutIntoSpecator(client)
{
	ChangeClientTeam(client, 1);
	PrintToChat(client, "\x05[TB] %t!", "Retry Placement");
	g_Bool[7] = 1;
	return 0;
}

setClientTeam(client, team, String:Reason[])
{
	ChangeClientTeam(client, 1);
	ChangeClientTeam(client, team);
	g_Bool[7] = 1;
	decl String:teamPhrase[32];
	switch (team)
	{
		case 2:
		{
			Format(teamPhrase, 32, "Consortium");
		}
		case 3:
		{
			Format(teamPhrase, 32, "Empire");
		}
		default:
		{
		}
	}
	decl String:teamName[32];
	Format(teamName, 32, "%T", teamPhrase, client);
	decl String:tReason[32];
	if (StrEqual(Reason, "imbalanced teams", false))
	{
		Format(tReason, 32, "%T", "Imbalanced Teams", client);
	}
	else
	{
		Format(tReason, 32, "%T", "Imbalanced Teams", client);
	}
	PrintToChat(client, "\x05[TB] %t.", "Player Assigned", teamName, tReason);
	decl String:Name[32];
	GetClientName(client, Name, 32);
	new x = 1;
	while (x <= MaxClients)
	{
		new var1;
		if (IsValidClient(x, true) && GetUserFlagBits(x))
		{
			PrintToChat(x, "\x05[TB] placed %s on %s!", Name, teamName);
		}
		x++;
	}
	return 0;
}

public Action:TIMER_updateSPM(Handle:timer)
{
	UpdateSPM();
	if (g_Bool[8])
	{
		g_Bool[7] = 1;
		g_Bool[8] = 0;
	}
	return Action:0;
}

public Action:TIMER_CheckGameMeSkill(Handle:timer, any:Userid)
{
	new client = GetClientOfUserId(Userid);
	if (client)
	{
		SetSkillByGameMe(client);
		return Action:3;
	}
	return Action:3;
}

public Action:TIMER_DisplayWarmupJob(Handle:timer)
{
	updateTDCache();
	PrintToChatAll("\x05[TB] %t", "Skill Averages", RoundFloat(getAverageLevel(3)), RoundFloat(getAverageLevel(2)));
	return Action:3;
}

public Action:TIMER_DisplayLevelResets(Handle:timer)
{
	updateTDCache();
	ShowLevelResets();
	return Action:3;
}

RegisterCommands()
{
	RegAdminCmd("sm_dumpclients", CMD_DumpClients, 1, "Dumps the new levels for all clients in console", "", 0);
	RegConsoleCmd("sm_teamdiff", CMD_TeamDiff, "", 0);
	RegConsoleCmd("sm_stacked", CMD_TeamDiff, "", 0);
	RegConsoleCmd("sm_diff", CMD_TeamDiff, "", 0);
	RegConsoleCmd("sm_spec", CMD_GoSpec, "", 0);
	return 0;
}

AddEventHooks()
{
	AddCommandListener(PlayerJoinTeam, "jointeam");
	HookEvent("round_win", Event_RoundEnd, EventHookMode:0);
	HookEvent("timeleft_5s", Event_RoundEnd, EventHookMode:2);
	HookEvent("round_start", Event_RoundStart, EventHookMode:2);
	return 0;
}

AddConvars()
{
	g_Cvar[0] = CreateConVar("sm_balance", "1", "Team Balancer: 0 to disable, 1 to enable", 0, false, 0.0, false, 0.0);
	g_Cvar[1] = CreateConVar("sm_even_allowance", "125", "Percentage to trigger even teams assignment", 0, false, 0.0, false, 0.0);
	g_Cvar[2] = CreateConVar("sm_one_allowance", "200", "Percentage to trigger two extra players assignment", 0, false, 0.0, false, 0.0);
	g_Cvar[3] = CreateConVar("sm_commander_allocate", "25", "Percentage to allocate towards uneven commanders", 0, false, 0.0, false, 0.0);
	g_Cvar[4] = CreateConVar("sm_commander_stacked", "100", "Percentage of average level for stacked commander", 0, false, 0.0, false, 0.0);
	g_Cvar[5] = CreateConVar("sm_commander_offset", "40", "Disable commander offsets at this skill difference", 0, false, 0.0, false, 0.0);
	g_Cvar[6] = CreateConVar("sm_commander_offset_low", "80", "Sets when to apply a very low commander offset", 0, false, 0.0, false, 0.0);
	g_Cvar[7] = CreateConVar("sm_eighty_skill", "50000", "Sets the skill to consider a client level 80", 0, false, 0.0, false, 0.0);
	return 0;
}

public Action:CMD_DumpClients(client, args)
{
	dumpClientValues(client);
	return Action:3;
}

dumpClientValues(player)
{
	new Float:linearClientRank = 0.0;
	new quadraticClientRank;
	PrintToConsole(player, "eSPMav: %d, cSPMav: %d, AVL: %d", getSPMaverage(3), getSPMaverage(2), 1456 + 4);
	decl String:Name[32];
	PrintToConsole(player, "Team Consort");
	new client;
	while (client <= MaxClients)
	{
		new var1;
		if (IsValidClient(client, true) && GetClientTeam(client) == 2)
		{
			linearClientRank = getLinearLevel(client);
			quadraticClientRank = getQuadraticLevel(client);
			GetClientName(client, Name, 32);
			PrintToConsole(player, "Name: %s, Linear: %d, Quadratic: %d, SPM: %d, CT: %d", Name, RoundFloat(linearClientRank), quadraticClientRank, scorePerMinute[client], connectionTime[client]);
		}
		client++;
	}
	PrintToConsole(player, "Team Empire");
	new client;
	while (client <= MaxClients)
	{
		new var2;
		if (IsValidClient(client, true) && GetClientTeam(client) == 3)
		{
			linearClientRank = getLinearLevel(client);
			quadraticClientRank = getQuadraticLevel(client);
			GetClientName(client, Name, 32);
			PrintToConsole(player, "Name: %s, Linear: %d, Quadratic: %d, SPM: %d, CT: %d", Name, RoundFloat(linearClientRank), quadraticClientRank, scorePerMinute[client], connectionTime[client]);
		}
		client++;
	}
	return 0;
}

public Action:CMD_GoSpec(client, args)
{
	new team = GetClientTeam(client);
	new var1;
	if ((g_Bool[2] || lockTeam[client] >= 2) && team > 1)
	{
		PrintToChat(client, "\x05[TB] %t!", "Spectator Avoid");
		return Action:3;
	}
	new var3;
	if (!GetConVarBool(g_Cvar[0]) && !g_Bool[5])
	{
		PrintToChat(client, "\x05[TB] %t.", "TP Spectator");
		return Action:3;
	}
	switch (lockTeam[client])
	{
		case 1:
		{
			PrintToChat(client, "\x05[xG] %t!", "Spectator Unlocked");
			lockTeam[client] = -1;
		}
		default:
		{
			if (team != 1)
			{
				g_Bool[7] = 1;
				ChangeClientTeam(client, 1);
			}
			PrintToChat(client, "\x05[xG] %t", "Spectator Joined");
			lockTeam[client] = 1;
		}
	}
	return Action:3;
}

public Action:CMD_TeamDiff(client, args)
{
	if (!g_Bool[5])
	{
		PrintToChat(client, "\x05[TB] %t!", "Teamdiff Round Wait");
		return Action:3;
	}
	updateTDCache();
	decl String:stackedTeam[16];
	switch (g_Integer[0])
	{
		case 2:
		{
			Format(stackedTeam, 16, "%t", "Empire");
		}
		case 3:
		{
			Format(stackedTeam, 16, "%t", "Consortium");
		}
		default:
		{
		}
	}
	PrintToChat(client, "\x05[TB] %s +%d/%d %t! Your Skill: %d/%d!", stackedTeam, 1456 + 8, 1456 + 4, "Skill", RoundFloat(getLinearLevel(client)), 1456 + 4);
	return Action:3;
}

BalanceTeams()
{
	g_Bool[4] = 1;
	if (WB_SkipWarmupBalance())
	{
		PrintToChatAll("\x05[TB] Warmup balance skipped due even teams!");
		WB_StartRound();
		return 0;
	}
	new Handle:Array = CreateArray(4, MaxClients + 1);
	new count = 324;
	new client = 1;
	new team = getRandomTeam();
	new bool:doublePlace = 1;
	new bool:firstPlace = 1;
	new bool:checkPlacement = 1;
	SetArrayCell(Array, 0, any:-1, 0, false);
	while (client <= MaxClients)
	{
		new var1;
		if (IsValidClient(client, true) && WB_IsReadyForBalance(client))
		{
			var2 = getQuadraticLevel(client);
		}
		else
		{
			var2 = MissingTAG:-1;
		}
		SetArrayCell(Array, client, var2, 0, false);
		client++;
	}
	while (count > -1)
	{
		client = FindValueInArray(Array, count);
		if (client == -1)
		{
			count--;
		}
		else
		{
			WB_SetTeam(client, team);
			WB_StoreTeam(client, team);
			if (checkPlacement)
			{
				if (firstPlace)
				{
					firstPlace = false;
					team = getOtherTeam(team);
				}
				else
				{
					if (doublePlace)
					{
						doublePlace = false;
						checkPlacement = false;
					}
				}
			}
			else
			{
				team = getOtherTeam(team);
			}
			SetArrayCell(Array, client, any:-1, 0, false);
		}
	}
	CloseHandle(Array);
	WB_EnableTeamLocks();
	WB_StartRound();
	return 0;
}

WB_EnableTeamLocks()
{
	g_Bool[2] = 1;
	CreateTimer(90.0, TIMER_UnlockTeams, any:0, 2);
	return 0;
}

WB_SetTeam(client, team)
{
	ChangeClientTeam(client, 1);
	ChangeClientTeam(client, team);
	return 0;
}

WB_StartRound()
{
	g_Bool[6] = 1;
	g_Bool[0] = 1;
	ServerCommand("mp_minplayers 1");
	return 0;
}

WB_StoreTeam(client, team)
{
	previousTeam[client] = team;
	decl String:sSteamID[24];
	GetClientAuthId(client, AuthIdType:1, sSteamID, 22, true);
	new var1;
	if (team == 2)
	{
		var1 = g_Handle[2];
	}
	else
	{
		var1 = g_Handle[3];
	}
	PushArrayString(var1, sSteamID);
	return 0;
}

bool:WB_IsReadyForBalance(client)
{
	return GetClientTeam(client) != 0;
}

bool:WB_SkipWarmupBalance()
{
	return false;
}

public Action:TIMER_UnlockTeams(Handle:timer)
{
	PrintToAdmins("\x05[TB] Team balancer locks disabled!", "a");
	g_Bool[2] = 0;
	return Action:0;
}

AddUpdaterLibrary()
{
	return 0;
}

public Event_RoundStart(Handle:event, String:name[], bool:dontBroadcast)
{
	g_Bool[4] = 0;
	g_Bool[5] = 1;
	g_Bool[1] = 1;
	StartTeamDiffHudDisplay();
	if (g_Bool[0])
	{
		CreateTimer(0.5, TIMER_DisplayWarmupJob, any:0, 2);
		CreateTimer(2.0, TIMER_DisplayLevelResets, any:0, 2);
	}
	CreateTimer(60.0, TIMER_updateSPM, any:0, 3);
	return 0;
}

public OnPluginStart()
{
	AddConvars();
	RegisterCommands();
	AddEventHooks();
	InitializeVariables();
	LoadTranslations("nd_team_balancer.phrases");
	loadClientPrefFeatures();
	AddUpdaterLibrary();
	AutoExecConfig(true, "nd_team_balancer", "sourcemod");
	return 0;
}

public OnMapStart()
{
	SetVarDefaults();
	return 0;
}

public OnClientAuthorized(client)
{
	resetClientValues(client);
	if (!IsFakeClient(client))
	{
		decl String:gAuth[32];
		GetClientAuthId(client, AuthIdType:1, gAuth, 32, true);
		SetArrayString(g_Handle[4], client, gAuth);
		setTeamLocks(client, gAuth);
		setSkillByArrays(client, gAuth);
	}
	return 0;
}

public OnClientPutInServer(client)
{
	CreateTimer(5.0, TIMER_CheckGameMeSkill, GetClientUserId(client), 2);
	return 0;
}

public OnClientDisconnect(client)
{
	if (!IsFakeClient(client))
	{
		new var1;
		if (g_Bool[2] && lockTeam[client] <= 1)
		{
			storeBalancedTeam(client);
			if (isOnTeam(client))
			{
				PrintDisconnectMessage(client);
			}
		}
		g_Bool[7] = 1;
	}
	resetClientValues(client);
	return 0;
}

public Action:PlayerJoinTeam(client, String:command[], argc)
{
	new var1;
	if (BlockTeamAction(client))
	{
		var1 = MissingTAG:3;
	}
	else
	{
		var1 = MissingTAG:0;
	}
	return var1;
}

bool:BlockTeamAction(client)
{
	if (IsValidClient(client, true))
	{
		if (g_Bool[4])
		{
			PrintToChat(client, "\x05[TB] %t", "Balancer Running");
			return true;
		}
		if (g_Bool[1])
		{
			switch (GetClientTeam(client))
			{
				case 0, 1:
				{
					if (ForcedPlacement(client))
					{
						g_Bool[7] = 1;
						return true;
					}
				}
				case 2, 3:
				{
					new var1;
					if (g_Bool[2] && getPositiveOverBalance() < 2)
					{
						PrintToChat(client, "\x05[TB] %t", "Switch Disabled");
					}
					else
					{
						if (!GetConVarBool(g_Cvar[0]))
						{
							return false;
						}
						if (NDC_IsCommander(client))
						{
							PrintToChat(client, "\x05[xG] %t!", "Resign Switch");
						}
						PutIntoSpecator(client);
					}
					return true;
				}
				default:
				{
				}
			}
		}
	}
	g_Bool[7] = 1;
	return false;
}

bool:ForcedPlacement(client)
{
	if (RequestedSpectate(client))
	{
		PrintToChat(client, "\x05[xG] %t!", "Revoke Spectator");
		return true;
	}
	if (!GetConVarBool(g_Cvar[0]))
	{
		return false;
	}
	updateTDCache();
	new var1;
	if (BotsAreDisabled() && IsVeteran(client))
	{
		new tPercent = getChoiceTolerance();
		if (tPercent == -1)
		{
			return false;
		}
		if (PercentAVLtoTD(tPercent) < g_Integer[2])
		{
			setClientTeam(client, g_Integer[0], "imbalanced teams");
			return true;
		}
	}
	return false;
}

public Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	if (!g_Bool[3])
	{
		InitiateRoundEnd();
	}
	return 0;
}

