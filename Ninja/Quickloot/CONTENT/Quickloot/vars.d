const string NINJA_QUICKLOOT_VERSION = "Quickloot v2.0.0-alpha"; 

// Used to calculate the "Top"-Offset for a Print
const int _Ninja_Quickloot_Print_Count = 0;
// Used to make Prints always start at the "Top"
const int _Ninja_Quickloot_Print_Timer = 0;
const int _Ninja_Quickloot_Print_Duration = 3000;
const int _Ninja_Quickloot_Print_Duration_Total = 3700;
const int _Ninja_Quickloot_Print_UseAnimation = 0;
const int _Ninja_Quickloot_Print_UsePatchFont = 0;
const string Ninja_Quickloot_Print_Font = "FONT_OLD_10_WHITE.TGA"; // <-- PF_Font

const int _Ninja_Quickloot_Print_Count_Limit_Current = 0;

const int _Ninja_Quickloot_Print_Count_Max = 15;
const int _Ninja_Quickloot_Print_TextHeight    = 150;
const int _Ninja_Quickloot_Print_AnimSpeed = 700;
const int _Ninja_Quickloot_Set_AnimStart_X = 4096;
const int _Ninja_Quickloot_Set_AnimStart_Y = 4096;
const string _Ninja_Quickloot_Received_Prefix = "Erhalten: ";

// Constants that might not exists in Mods.
// Engine constants. Can not be adjusted by mods.
const int PATCH_QUICKLOOT_PERC_ASSESSTHEFT  = 17; // PERC_ASSESSTHEFT
const int PATCH_QUICKLOOT_PERC_ASSESSUSEMOB = 32; // PERC_ASSESSUSEMOB
const int PATCH_QUICKLOOT_ITEM_KAT_NONE     =  1; // ITEM_KAT_NONE  ( 1 << 0)
const int PATCH_QUICKLOOT_ITEM_KAT_ARMOR    = 16; // ITEM_KAT_ARMOR ( 1 << 4)
const int PATCH_QUICKLOOT_INV_CAT_MAX       =  9; // INV_CAT_MAX

const int PATCH_QUICKLOOT_LOCALE    =  0; // (0 = EN, 1 = DE, 2 = PL, 3 = RU)

func string Ninja_Quickloot_GetOpt(var string optName, var string defaultVal) {
	const string INI_SECTION = "NINJA_QUICKLOOT";
	var string concatText; concatText = "";
	var string optValue;

	if (!MEM_GothOptExists(INI_SECTION, optName)) {
		MEM_SetGothOpt(INI_SECTION, optName, defaultVal);
		return defaultVal;
	};
	optValue = MEM_GetGothOpt(INI_SECTION, optName);
	if (Hlp_StrCmp("", optValue)) {
		MEM_SetGothOpt(INI_SECTION, optName, defaultVal);
		optValue = defaultVal; 
	};
	
	concatText = ConcatStrings(concatText, "    ");
	concatText = ConcatStrings(concatText, optName);
	concatText = ConcatStrings(concatText, ": ");
	concatText = ConcatStrings(concatText, optValue);
	MEM_Info(concatText);

	return optValue;
};

func void Ninja_Quickloot_Init_Options() {
	_Ninja_Quickloot_Print_UsePatchFont = STR_ToInt(Ninja_Quickloot_GetOpt("UsePatchFont", "0"));
	if (_Ninja_Quickloot_Print_UsePatchFont != 0) {
		Ninja_Quickloot_Print_Font = Ninja_Quickloot_GetOpt("Font", "Ninja_QuickLoot_Font_DE.tga");
	} else {
        Ninja_Quickloot_GetOpt("Font", "Ninja_QuickLoot_Font_DE.tga");
    };
    if (!MEM_GothOptExists("KEYS", "keyPatchQuickloot")) {
		if (GOTHIC_BASE_VERSION == 2) { MEM_SetGothOpt("KEYS", "keyPatchQuickloot", "0d02" /* 525 -> RMB, MOUSE_BUTTONRIGHT */); }
        else                          { MEM_SetGothOpt("KEYS", "keyPatchQuickloot", "2f00" /* 47, KEY_V */                    ); };
	};

	_Ninja_Quickloot_Received_Prefix = Ninja_Quickloot_GetOpt("Prefix", "Erhalten:");
	if (!Hlp_StrCmp(_Ninja_Quickloot_Received_Prefix, "")) {
		_Ninja_Quickloot_Received_Prefix = ConcatStrings(_Ninja_Quickloot_Received_Prefix, " ");
	};

	var int animated; animated = STR_ToInt(Ninja_Quickloot_GetOpt("UseAnimations", "1"));
	if (animated) {
		_Ninja_Quickloot_Received_Prefix = "";
		_Ninja_Quickloot_Print_UseAnimation = 1;
	};

	_Ninja_Quickloot_Print_AnimSpeed = STR_ToInt(Ninja_Quickloot_GetOpt("AnimSpeed", "700"));
	if (_Ninja_Quickloot_Print_AnimSpeed <= 0 || _Ninja_Quickloot_Print_AnimSpeed >= 2000) {
		_Ninja_Quickloot_Print_AnimSpeed = 700;
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
		// Workaround for wrong "invalid pointer" check
	};
};