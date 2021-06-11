const string KWICKLOOT_VERSION = "Kwickloot v2.0.0-alpha"; 

// Used to calculate the "Top"-Offset for a Print
const int _Kwickloot_Print_Count = 0;
// Used to make Prints always start at the "Top"
const int _Kwickloot_Print_Timer = 0;
const int _Kwickloot_Print_Duration = 3000;
const int _Kwickloot_Print_Duration_Total = 3700;
const int _Kwickloot_Print_UseAnimation = 0;
const int _Kwickloot_Print_UsePatchFont = 0;
const int _Kwickloot_Print_UseColors    = 0;
const string Kwickloot_Print_Font = "FONT_OLD_10_WHITE.TGA"; // <-- PF_Font
const string _Kwickloot_Item_Money = "ITMI_GOLD";

const int _Kwickloot_Print_Count_Limit_Current = 0;

const int _Kwickloot_Print_Count_Max = 15;
const int _Kwickloot_Print_TextHeight    = 150;
const int _Kwickloot_Print_AnimSpeed = 700;
const int _Kwickloot_Set_AnimStart_X = 4096;
const int _Kwickloot_Set_AnimStart_Y = 4096;

const int _Kwickloot_Print_X = 150;
const int _Kwickloot_Print_Y = 4096; // PS_VMax / 2

const string _Kwickloot_Received_Prefix = "Erhalten: ";
const string Kwickloot_KEYNAME = "keyKwickloot";
const int Kwickloot_ITEM_EXPENSIVE= 250;
const int Kwickloot_RARITY_NONE   = 0;
const int Kwickloot_RARITY_RARE   = 1;
const int Kwickloot_RARITY_GOLD   = 2;
const int Kwickloot_RARITY_QUEST  = 3;
const int Kwickloot_RARITY_WEAPON = 4;
const int Kwickloot_RARITY_FOOD   = 5;
const int Kwickloot_RARITY_COMMON = 6;

const int Kwickloot_COLOR_NONE   = (255<<16) | (255<<8) | (255<<0) | (255<<24); // #FFFFFF | COL_White
const int Kwickloot_COLOR_RARE   = (255<<16) | (165<<8) |            (255<<24); // #FFA500 | Orange
const int Kwickloot_COLOR_GOLD   = (255<<16) | (255<<8) |            (255<<24); // #FFFF00 | COL_Yellow
const int Kwickloot_COLOR_QUEST  =             (154<<8) | (255<<0) | (255<<24); // #009AFF | Light Blue
const int Kwickloot_COLOR_WEAPON = (211<<16) | (110<<8) | (112<<0) | (255<<24); // #d36e70 | Altrosa
const int Kwickloot_COLOR_FOOD   =             (204<<8) |            (255<<24); // #00cc00 | Caparol
const int Kwickloot_COLOR_COMMON = (204<<16) | (204<<8) | (204<<0) | (255<<24); // #cccccc |

const int Kwickloot_INDEX_MONEY   = -1;

// Constants that might not exists in Mods.
// Engine constants. Can not be adjusted by mods.
const int Kwickloot_PERC_ASSESSTHEFT  = 17; // PERC_ASSESSTHEFT
const int Kwickloot_PERC_ASSESSUSEMOB = 32; // PERC_ASSESSUSEMOB
const int Kwickloot_ITEM_KAT_NONE     =  1; // ITEM_KAT_NONE  ( 1 << 0)
const int Kwickloot_ITEM_KAT_ARMOR    = 16; // ITEM_KAT_ARMOR ( 1 << 4)
const int Kwickloot_INV_CAT_MAX       =  9; // INV_CAT_MAX

const int Kwickloot_LOCALE    =  0; // (0 = EN, 1 = DE, 2 = PL, 3 = RU)

func string Kwickloot_GetOptSec(var string section, var string optName, var string defaultVal) {
	var string concatText; concatText = "";
	var string optValue;

	if (!MEM_GothOptExists(section, optName)) {
		MEM_SetGothOpt(section, optName, defaultVal);
		return defaultVal;
	};
	optValue = MEM_GetGothOpt(section, optName);
	if (Hlp_StrCmp("", optValue)) {
		MEM_SetGothOpt(section, optName, defaultVal);
		optValue = defaultVal; 
	};
	
	concatText = ConcatStrings(concatText, "    ");
	concatText = ConcatStrings(concatText, optName);
	concatText = ConcatStrings(concatText, ": ");
	concatText = ConcatStrings(concatText, optValue);
	MEM_Info(concatText);

	return optValue;
};

func string Kwickloot_GetOpt(var string optName, var string defaultVal) {
	const string INI_SECTION = "KWICKLOOT";
	return Kwickloot_GetOptSec(INI_SECTION, optName, defaultVal);
};
func string Kwickloot_GetColorOpt(var string optName, var string defaultVal) {
	const string INI_SECTION = "KWICKLOOT_COLORS";
	return Kwickloot_GetOptSec(INI_SECTION, optName, defaultVal);
};
func string Kwickloot_SetOpt(var string optName, var string optValue) {
	const string INI_SECTION = "KWICKLOOT";
	var string concatText; concatText = "";
	MEM_SetGothOpt(INI_SECTION, optName, optValue);
	
	concatText = ConcatStrings(concatText, "    SET: ");
	concatText = ConcatStrings(concatText, optName);
	concatText = ConcatStrings(concatText, ": ");
	concatText = ConcatStrings(concatText, optValue);
	MEM_Info(concatText);

	return optValue;
};

func int _Kwickloot_IntInRangeDefault(var int v, var int min, var int max, var int def) {
	if ((v < min) || (v > max)) {
		return +def;
	};
	return +v;
};

func void Kwickloot_Init_Options() {
    if (!MEM_GothOptExists("KEYS", Kwickloot_KEYNAME)) {
		if (GOTHIC_BASE_VERSION == 2) { MEM_SetGothOpt("KEYS", Kwickloot_KEYNAME, "0d02" /* 525 -> RMB, MOUSE_BUTTONRIGHT */); }
        else                          { MEM_SetGothOpt("KEYS", Kwickloot_KEYNAME, "2f00" /* 47, KEY_V */                    ); };
	};

	_Kwickloot_Received_Prefix = Kwickloot_GetOpt("Prefix", "Erhalten:");
	if (!Hlp_StrCmp(_Kwickloot_Received_Prefix, "")) {
		_Kwickloot_Received_Prefix = ConcatStrings(_Kwickloot_Received_Prefix, " ");
	};

	_Kwickloot_Print_X = _Kwickloot_IntInRangeDefault(STR_ToInt(Kwickloot_GetOpt("PrintX", "150")), 0, PS_VMax, 150);
	Kwickloot_SetOpt("PrintX", IntToString(_Kwickloot_Print_X));

	_Kwickloot_Print_Y = _Kwickloot_IntInRangeDefault(STR_ToInt(Kwickloot_GetOpt("PrintY", "4096")), 0, PS_VMax, 4096);
	Kwickloot_SetOpt("PrintY", IntToString(_Kwickloot_Print_Y));

	var int animated; animated = STR_ToInt(Kwickloot_GetOpt("UseAnimations", "1"));
	if (animated) {
		_Kwickloot_Received_Prefix = "";
		_Kwickloot_Print_UseAnimation = 1;
	};

	_Kwickloot_Print_AnimSpeed = STR_ToInt(Kwickloot_GetOpt("AnimSpeed", "700"));
	if (_Kwickloot_Print_AnimSpeed <= 0 || _Kwickloot_Print_AnimSpeed >= 2000) {
		_Kwickloot_Print_AnimSpeed = 700;
	};

	_Kwickloot_Print_UsePatchFont = STR_ToInt(Kwickloot_GetOpt("UsePatchFont", "0"));
	if (_Kwickloot_Print_UsePatchFont != 0) {
		Kwickloot_Print_Font = Kwickloot_GetOpt("Font", "Kwickloot_Font_DE.tga");
	} else {
        Kwickloot_GetOpt("Font", "Kwickloot_Font_DE.tga");
    };

	if (_Kwickloot_Print_UseAnimation) {
		_Kwickloot_Print_Duration_Total = _Kwickloot_Print_Duration + _Kwickloot_Print_AnimSpeed;
	} else {
		_Kwickloot_Print_Duration_Total = _Kwickloot_Print_Duration;
	};

	if (animated) {
		const int _UpdatePlayerStatus_PrintFocusName_G1 = 6526632; /* 006396A8 */
		const int _UpdatePlayerStatus_PrintFocusName_G2 = 7093113; /* 006C3B79 */
		HookEngineF(
			MEMINT_SwitchG1G2(
				_UpdatePlayerStatus_PrintFocusName_G1,
				_UpdatePlayerStatus_PrintFocusName_G2), 
			8,
			_Kwickloot_Set_AnimStart);
	};

	_Kwickloot_Item_Money = Kwickloot_GetOpt("szItemMoney", "ITMI_GOLD");
	Kwickloot_INDEX_MONEY = MEM_FindParserSymbol(_Kwickloot_Item_Money);
	_Kwickloot_Print_UseColors = STR_ToInt(Kwickloot_GetOpt("UseColors", "0"));

	Kwickloot_COLOR_NONE   = Kwickloot_ParseColor(Kwickloot_GetColorOpt("ItemOther" , "#FFFFFF")); // White
	Kwickloot_COLOR_RARE   = Kwickloot_ParseColor(Kwickloot_GetColorOpt("ItemRare"  , "#FFA500")); // Orange-ish
	Kwickloot_COLOR_GOLD   = Kwickloot_ParseColor(Kwickloot_GetColorOpt("ItemGold"  , "#FFFF00")); // Yellow
	Kwickloot_COLOR_COMMON = Kwickloot_ParseColor(Kwickloot_GetColorOpt("ItemCommon", "#C0C0C0")); // Silver 
	Kwickloot_COLOR_WEAPON = Kwickloot_ParseColor(Kwickloot_GetColorOpt("ItemWeapon", "#009AFF")); // Light Blue
	Kwickloot_COLOR_QUEST  = Kwickloot_ParseColor(Kwickloot_GetColorOpt("ItemQuest" , "#E3A5AA")); // Helleres Rosé
	Kwickloot_COLOR_FOOD   = Kwickloot_ParseColor(Kwickloot_GetColorOpt("ItemFood"  , "#04F804")); // Caparol
};