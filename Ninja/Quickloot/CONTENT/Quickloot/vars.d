const string NINJA_QUICKLOOT_VERSION = "Quickloot v2.0.0-alpha"; 

// Used to calculate the "Top"-Offset for a Print
const int _Ninja_Quickloot_Print_Count = 0;
// Used to make Prints always start at the "Top"
const int _Ninja_Quickloot_Print_Timer = 0;
const int _Ninja_Quickloot_Print_Duration = 3000;
const int _Ninja_Quickloot_Print_Duration_Total = 3700;
const int _Ninja_Quickloot_Print_UseAnimation = 0;
const int _Ninja_Quickloot_Print_UsePatchFont = 0;
const int _Ninja_Quickloot_Print_UseColors    = 0;
const string Ninja_Quickloot_Print_Font = "FONT_OLD_10_WHITE.TGA"; // <-- PF_Font
const string _Ninja_Quickloot_Item_Money = "ITMI_GOLD";

const int _Ninja_Quickloot_Print_Count_Limit_Current = 0;

const int _Ninja_Quickloot_Print_Count_Max = 15;
const int _Ninja_Quickloot_Print_TextHeight    = 150;
const int _Ninja_Quickloot_Print_AnimSpeed = 700;
const int _Ninja_Quickloot_Set_AnimStart_X = 4096;
const int _Ninja_Quickloot_Set_AnimStart_Y = 4096;

const int _Ninja_Quickloot_Print_X = 150;
const int _Ninja_Quickloot_Print_Y = 4096; // PS_VMax / 2

const string _Ninja_Quickloot_Received_Prefix = "Erhalten: ";

const int PATCH_QUICKLOOT_ITEM_EXPENSIVE= 250;
const int PATCH_QUICKLOOT_RARITY_NONE   = 0;
const int PATCH_QUICKLOOT_RARITY_RARE   = 1;
const int PATCH_QUICKLOOT_RARITY_GOLD   = 2;
const int PATCH_QUICKLOOT_RARITY_QUEST  = 3;
const int PATCH_QUICKLOOT_RARITY_WEAPON = 4;
const int PATCH_QUICKLOOT_RARITY_FOOD   = 5;
const int PATCH_QUICKLOOT_RARITY_COMMON = 6;

const int PATCH_QUICKLOOT_COLOR_NONE   = (255<<16) | (255<<8) | (255<<0) | (255<<24); // #FFFFFF | COL_White
const int PATCH_QUICKLOOT_COLOR_RARE   = (255<<16) | (165<<8) |            (255<<24); // #FFA500 | Orange
const int PATCH_QUICKLOOT_COLOR_GOLD   = (255<<16) | (255<<8) |            (255<<24); // #FFFF00 | COL_Yellow
const int PATCH_QUICKLOOT_COLOR_QUEST  =             (154<<8) | (255<<0) | (255<<24); // #009AFF | Light Blue
const int PATCH_QUICKLOOT_COLOR_WEAPON = (211<<16) | (110<<8) | (112<<0) | (255<<24); // #d36e70 | Altrosa
const int PATCH_QUICKLOOT_COLOR_FOOD   =             (204<<8) |            (255<<24); // #00cc00 | Caparol
const int PATCH_QUICKLOOT_COLOR_COMMON = (204<<16) | (204<<8) | (204<<0) | (255<<24); // #cccccc |

const int PATCH_QUICKLOOT_INDEX_MONEY   = -1;

// Constants that might not exists in Mods.
// Engine constants. Can not be adjusted by mods.
const int PATCH_QUICKLOOT_PERC_ASSESSTHEFT  = 17; // PERC_ASSESSTHEFT
const int PATCH_QUICKLOOT_PERC_ASSESSUSEMOB = 32; // PERC_ASSESSUSEMOB
const int PATCH_QUICKLOOT_ITEM_KAT_NONE     =  1; // ITEM_KAT_NONE  ( 1 << 0)
const int PATCH_QUICKLOOT_ITEM_KAT_ARMOR    = 16; // ITEM_KAT_ARMOR ( 1 << 4)
const int PATCH_QUICKLOOT_INV_CAT_MAX       =  9; // INV_CAT_MAX

const int PATCH_QUICKLOOT_LOCALE    =  0; // (0 = EN, 1 = DE, 2 = PL, 3 = RU)

func string Ninja_Quickloot_GetOptSec(var string section, var string optName, var string defaultVal) {
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

func string Ninja_Quickloot_GetOpt(var string optName, var string defaultVal) {
	const string INI_SECTION = "NINJA_QUICKLOOT";
	return Ninja_Quickloot_GetOptSec(INI_SECTION, optName, defaultVal);
};
func string Ninja_Quickloot_GetColorOpt(var string optName, var string defaultVal) {
	const string INI_SECTION = "NINJA_QUICKLOOT_COLOR";
	return Ninja_Quickloot_GetOptSec(INI_SECTION, optName, defaultVal);
};
func string Ninja_Quickloot_SetOpt(var string optName, var string optValue) {
	const string INI_SECTION = "NINJA_QUICKLOOT";
	var string concatText; concatText = "";
	MEM_SetGothOpt(INI_SECTION, optName, optValue);
	
	concatText = ConcatStrings(concatText, "    SET: ");
	concatText = ConcatStrings(concatText, optName);
	concatText = ConcatStrings(concatText, ": ");
	concatText = ConcatStrings(concatText, optValue);
	MEM_Info(concatText);

	return optValue;
};

func int _Ninja_Quickloot_IntInRangeDefault(var int v, var int min, var int max, var int def) {
	if ((v < min) || (v > max)) {
		return +def;
	};
	return +v;
};

func void Ninja_Quickloot_Init_Options() {
    if (!MEM_GothOptExists("KEYS", "keyPatchQuickloot")) {
		if (GOTHIC_BASE_VERSION == 2) { MEM_SetGothOpt("KEYS", "keyPatchQuickloot", "0d02" /* 525 -> RMB, MOUSE_BUTTONRIGHT */); }
        else                          { MEM_SetGothOpt("KEYS", "keyPatchQuickloot", "2f00" /* 47, KEY_V */                    ); };
	};

	_Ninja_Quickloot_Received_Prefix = Ninja_Quickloot_GetOpt("Prefix", "Erhalten:");
	if (!Hlp_StrCmp(_Ninja_Quickloot_Received_Prefix, "")) {
		_Ninja_Quickloot_Received_Prefix = ConcatStrings(_Ninja_Quickloot_Received_Prefix, " ");
	};

	_Ninja_Quickloot_Print_X = _Ninja_Quickloot_IntInRangeDefault(STR_ToInt(Ninja_Quickloot_GetOpt("PrintX", "150")), 0, PS_VMax, 150);
	Ninja_Quickloot_SetOpt("PrintX", IntToString(_Ninja_Quickloot_Print_X));

	_Ninja_Quickloot_Print_Y = _Ninja_Quickloot_IntInRangeDefault(STR_ToInt(Ninja_Quickloot_GetOpt("PrintY", "4096")), 0, PS_VMax, 4096);
	Ninja_Quickloot_SetOpt("PrintY", IntToString(_Ninja_Quickloot_Print_Y));

	var int animated; animated = STR_ToInt(Ninja_Quickloot_GetOpt("UseAnimations", "1"));
	if (animated) {
		_Ninja_Quickloot_Received_Prefix = "";
		_Ninja_Quickloot_Print_UseAnimation = 1;
	};

	_Ninja_Quickloot_Print_AnimSpeed = STR_ToInt(Ninja_Quickloot_GetOpt("AnimSpeed", "700"));
	if (_Ninja_Quickloot_Print_AnimSpeed <= 0 || _Ninja_Quickloot_Print_AnimSpeed >= 2000) {
		_Ninja_Quickloot_Print_AnimSpeed = 700;
	};

	_Ninja_Quickloot_Print_UsePatchFont = STR_ToInt(Ninja_Quickloot_GetOpt("UsePatchFont", "0"));
	if (_Ninja_Quickloot_Print_UsePatchFont != 0) {
		Ninja_Quickloot_Print_Font = Ninja_Quickloot_GetOpt("Font", "Ninja_QuickLoot_Font_DE.tga");
	} else {
        Ninja_Quickloot_GetOpt("Font", "Ninja_QuickLoot_Font_DE.tga");
    };

	if (_Ninja_Quickloot_Print_UseAnimation) {
		_Ninja_Quickloot_Print_Duration_Total = _Ninja_Quickloot_Print_Duration + _Ninja_Quickloot_Print_AnimSpeed;
	} else {
		_Ninja_Quickloot_Print_Duration_Total = _Ninja_Quickloot_Print_Duration;
	};

	if (animated) {
		const int _UpdatePlayerStatus_PrintFocusName_G1 = 6526632; /* 006396A8 */
		const int _UpdatePlayerStatus_PrintFocusName_G2 = 7093113; /* 006C3B79 */
		HookEngineF(
			MEMINT_SwitchG1G2(
				_UpdatePlayerStatus_PrintFocusName_G1,
				_UpdatePlayerStatus_PrintFocusName_G2), 
			8,
			_Ninja_Quickloot_Set_AnimStart);
	};

	_Ninja_Quickloot_Item_Money = Ninja_Quickloot_GetOpt("szItemMoney", "ITMI_GOLD");
	PATCH_QUICKLOOT_INDEX_MONEY = MEM_FindParserSymbol(_Ninja_Quickloot_Item_Money);
	_Ninja_Quickloot_Print_UseColors = STR_ToInt(Ninja_Quickloot_GetOpt("UseColors", "1"));

	PATCH_QUICKLOOT_COLOR_NONE   = Ninja_Quickloot_ParseColor(Ninja_Quickloot_GetColorOpt("ItemOther" , "#FFFFFF")); // White
	PATCH_QUICKLOOT_COLOR_RARE   = Ninja_Quickloot_ParseColor(Ninja_Quickloot_GetColorOpt("ItemRare"  , "#FFA500")); // Orange-ish
	PATCH_QUICKLOOT_COLOR_GOLD   = Ninja_Quickloot_ParseColor(Ninja_Quickloot_GetColorOpt("ItemGold"  , "#FFFF00")); // Yellow
	PATCH_QUICKLOOT_COLOR_COMMON = Ninja_Quickloot_ParseColor(Ninja_Quickloot_GetColorOpt("ItemCommon", "#C0C0C0")); // Silver 
	PATCH_QUICKLOOT_COLOR_WEAPON = Ninja_Quickloot_ParseColor(Ninja_Quickloot_GetColorOpt("ItemWeapon", "#E3A5AA")); // Helleres Rosé
	PATCH_QUICKLOOT_COLOR_QUEST  = Ninja_Quickloot_ParseColor(Ninja_Quickloot_GetColorOpt("ItemQuest" , "#009AFF")); // Light Blue
	PATCH_QUICKLOOT_COLOR_FOOD   = Ninja_Quickloot_ParseColor(Ninja_Quickloot_GetColorOpt("ItemFood"  , "#04F804")); // Caparol
};