public PlVers:__version =
{
	version = 5,
	filevers = "1.6.4-dev+4616",
	date = "02/21/2016",
	time = "11:11:19"
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
public SharedPlugin:__pl_gameme =
{
	name = "gameme",
	file = "gameme.smx",
	required = 1,
};
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
new String:nd_whitelisted_players[5][80] =
{
	"STEAM_0:1:1317565",
	"STEAM_1:1:31931728",
	"STEAM_1:0:7181974",
	"STEAM_1:1:7236729",
	"STEAM_1:1:46107040"
};
new Handle:ServerType;
new Handle:SkillThreshold;
new playerSkill[66];
new playerRank[66];
new playerKills[66];
new playerDeaths[66];
new Float:playerKDR[66];
new bool:playerAuthorized[66];
new bool:playerQueried[66];
new bool:playerKickChecked[66];
public Plugin:myinfo =
{
	name = "[ND] GameMe Extras",
	description = "Creates natives and forwards for retreiving player statisitics",
	author = "Stickz",
	version = "1.0.9",
	url = "xenogamers.com"
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

bool:IsPlayerBot(client)
{
	new var1;
	GetClientAuthId(client, AuthIdType:1, var1, 64, true);
	new var2;
	new idx;
	while (idx < 6)
	{
		if (StrContains(var2[idx], var1, false) > -1)
		{
			return true;
		}
		idx++;
	}
	return false;
}

AddUpdaterLibrary()
{
	return 0;
}

public OnPluginStart()
{
	ServerType = CreateConVar("sm_gameme_servertype", "0", "define the server type 0:regular, 1:rookie, 2:veteran", 0, false, 0.0, false, 0.0);
	SkillThreshold = CreateConVar("sm_gameme_skillthreshold", "30000", "define when to kick clients based on skill requirements", 0, false, 0.0, false, 0.0);
	AutoExecConfig(true, "nd_gameme_extras", "sourcemod");
	AddUpdaterLibrary();
	return 0;
}

public OnClientAuthorized(client)
{
	ResetVarriables(client, true);
	return 0;
}

public OnClientPutInServer(client)
{
	if (IsQueryable(client))
	{
		QueryClientData(client);
		CreateTimer(3.0, TIMER_CheckBackupKick, GetClientUserId(client), 2);
	}
	return 0;
}

public Action:TIMER_CheckBackupKick(Handle:timer, any:userid)
{
	new client = GetClientOfUserId(userid);
	if (client)
	{
		if (!playerKickChecked[client])
		{
			switch (GetConVarInt(ServerType))
			{
				case 1:
				{
					new var2;
					if (IsVeteran(client) && !IsWhiteListedPlayer(client))
					{
						KickClient(client, "This server is for rookies only.");
					}
				}
				case 2:
				{
					new var1;
					if (!IsVeteran(client) && !IsWhiteListedPlayer(client))
					{
						KickClient(client, "This server is for veterans only.");
					}
				}
				default:
				{
				}
			}
		}
		return Action:3;
	}
	return Action:3;
}

public OnClientDisconnect(client)
{
	ResetVarriables(client, false);
	return 0;
}

ResetVarriables(client, bool:authorized)
{
	playerSkill[client] = 0;
	playerRank[client] = 0;
	playerKills[client] = 0;
	playerDeaths[client] = 0;
	playerKDR[client] = 0;
	playerAuthorized[client] = authorized;
	playerQueried[client] = 0;
	playerKickChecked[client] = 0;
	return 0;
}

QueryClientData(client)
{
	QueryGameMEStats("playerinfo", client, gameMEStatsCallback:25, 1);
	return 0;
}

public QueryGameMEStatsCallback(command, payload, client, &Handle:datapack)
{
	new var1;
	if (client > 0 && command == 101)
	{
		new Handle:data = CloneHandle(datapack, Handle:0);
		ResetPack(data, false);
		new rank = ReadPackCell(data);
		new players = ReadPackCell(data);
		new skill = ReadPackCell(data);
		new kills = ReadPackCell(data);
		new deaths = ReadPackCell(data);
		CloseHandle(data);
		if (payload == 1)
		{
			playerSkill[client] = skill;
			playerRank[client] = rank;
			playerKills[client] = kills;
			playerDeaths[client] = deaths;
			playerKDR[client] = float(kills) / float(deaths);
			playerQueried[client] = 1;
			CheckPlayerKick(client, skill);
		}
	}
	return 0;
}

bool:IsQueryable(client)
{
	new var1;
	return client > 0 && !IsFakeClient(client);
}

CheckPlayerKick(client, skill)
{
	playerKickChecked[client] = 1;
	new var1;
	if (!IsWhiteListedPlayer(client) && !IsPlayerBot(client))
	{
		new SkillRequirement = GetConVarInt(SkillThreshold);
		switch (GetConVarInt(ServerType))
		{
			case 1:
			{
				if (skill > SkillRequirement)
				{
					KickClient(client, "This server is for rookies only.");
				}
			}
			case 2:
			{
				if (skill < SkillRequirement)
				{
					KickClient(client, "%d points on rank.xenogamers.com/players/nd required to access this server!", SkillRequirement);
				}
			}
			default:
			{
			}
		}
	}
	return 0;
}

bool:IsWhiteListedPlayer(client)
{
	if (playerAuthorized[client])
	{
		decl String:gAuth[32];
		GetClientAuthId(client, AuthIdType:1, gAuth, 32, true);
		new ig;
		while (ig <= 4)
		{
			if (StrEqual(nd_whitelisted_players[ig], gAuth, false))
			{
				return true;
			}
			ig++;
		}
	}
	return false;
}

bool:IsVeteran(client)
{
	decl String:gAuth[32];
	GetClientAuthId(client, AuthIdType:1, gAuth, 32, true);
	new ig;
	while (ig <= 243)
	{
		if (StrEqual(nd_top_players[ig], gAuth, false))
		{
			return true;
		}
		ig++;
	}
	new ix;
	while (ix <= 247)
	{
		if (StrEqual(nd_middle_players[ix], gAuth, false))
		{
			return true;
		}
		ix++;
	}
	new id;
	while (id <= 60)
	{
		if (StrEqual(nd_graduate_players[id], gAuth, false))
		{
			return true;
		}
		id++;
	}
	return false;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("GameME_GetServerType", Native_GameME_GetServerType);
	CreateNative("GameME_GetClientSkill", Native_GameME_GetClientSkill);
	CreateNative("GameME_GetClientRank", Native_GameME_GetClientRank);
	CreateNative("GameME_GetClientKills", Native_GameME_GetClientKills);
	CreateNative("GameME_GetClientDeaths", Native_GameME_GetClientDeaths);
	CreateNative("GameME_GetClientKDR", Native_GameME_GetClientKDR);
	CreateNative("GameME_RankedClient", Native_GameME_RankedClient);
	return APLRes:0;
}

public Native_GameME_RankedClient(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	return playerSkill[client] > GetConVarInt(SkillThreshold);
}

public Native_GameME_GetClientSkill(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	return playerSkill[client];
}

public Native_GameME_GetClientRank(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	return playerRank[client];
}

public Native_GameME_GetClientKills(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	return playerKills[client];
}

public Native_GameME_GetClientDeaths(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	return playerDeaths[client];
}

public Native_GameME_GetClientKDR(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	return playerKDR[client];
}

public Native_GameME_GetServerType(Handle:plugin, numParams)
{
	return GetConVarInt(ServerType);
}

