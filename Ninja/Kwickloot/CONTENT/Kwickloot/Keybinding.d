/*
 * Create menu item from script instance name
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func int Kwickloot_CreateMenuItem(var string scriptName) { // Adjust name
    const int zCMenuItem__Create_G1 = 5052784; //0x4D1970
    const int zCMenuItem__Create_G2 = 5105600; //0x4DE7C0

    var int strPtr; strPtr = _@s(scriptName);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(strPtr));
        CALL_PutRetValTo(_@(ret));
        CALL__cdecl(MEMINT_SwitchG1G2(zCMenuItem__Create_G1,
                                      zCMenuItem__Create_G2));
        call = CALL_End();
    };

    var int ret;
    return +ret;
};

/*
 * Copy essential properties from one to another menu entry
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func void Kwickloot_CopyMenuItemProperties(var int dstPtr, var int srcPtr) {
    if (!dstPtr) || (!srcPtr) {
        return;
    };

    var zCMenuItem src; src = _^(srcPtr);
    var zCMenuItem dst; dst = _^(dstPtr);

    dst.m_parPosX = src.m_parPosX;
    dst.m_parPosY = src.m_parPosY;
    dst.m_parDimX = src.m_parDimX;
    dst.m_parDimY = src.m_parDimY;
    dst.m_pFont = src.m_pFont;
    dst.m_pFontSel = src.m_pFontSel;
    dst.m_parBackPic = src.m_parBackPic;
};

/*
 * Get maximum menu item height
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func int Kwickloot_MenuItemGetHeight(var int itmPtr) { // Adjust name
    if (!itmPtr) {
        return 0;
    };

    var zCMenuItem itm; itm = _^(itmPtr);
    var int fontPtr; fontPtr = itm.m_pFont;

    const int zCFont__GetFontY_G1 = 7209472; //0x6E0200
    const int zCFont__GetFontY_G2 = 7902432; //0x7894E0

    var int fontHeight;
    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PutRetValTo(_@(fontHeight));
        CALL__thiscall(_@(fontPtr), MEMINT_SwitchG1G2(zCFont__GetFontY_G1,
                                                      zCFont__GetFontY_G2));
        call = CALL_End();
    };

    // Transform to virtual pixels
    MEM_InitGlobalInst();
    var zCView screen; screen = _^(MEM_Game._zCSession_viewport);
    fontHeight *= 8192 / screen.psizey;

    if (fontHeight > itm.m_parDimY) {
        return fontHeight;
    } else {
        return itm.m_parDimY;
    };
};

/*
 * Insert value into array at specific position
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func void Kwickloot_ArrayInsertAtPos(var int zCArray_ptr,
                                             var int pos,
                                             var int value) { // Adjust name
    const int zCArray__InsertAtPos_G1 = 6267728; //0x5FA350
    const int zCArray__InsertAtPos_G2 = 6458144; //0x628B20

    var int valuePtr; valuePtr = _@(value);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_IntParam(_@(pos));
        CALL_PtrParam(_@(valuePtr));
        CALL__thiscall(_@(zCArray_ptr), MEMINT_SwitchG1G2(zCArray__InsertAtPos_G1,
                                                          zCArray__InsertAtPos_G2));
        call = CALL_End();
    };
};


/*
 * Guess localization (0 = EN, 1 = DE, 2 = PL, 3 = RU)
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes#localization
 */
func int Kwickloot_GuessLocalization() { // Adjust the name!
	MEM_InitAll();
    var int pan; pan = MEM_GetSymbol("MOBNAME_PAN");
    if (pan) {
        var zCPar_Symbol panSymb; panSymb = _^(pan);
        var string panName; panName = MEM_ReadString(panSymb.content);
        if (Hlp_StrCmp(panName, "Pfanne")) { // DE (Windows 1252)
            return 1;
        } else if (Hlp_StrCmp(panName, "Patelnia")) { // PL (Windows 1250)
            return 2;
        } else if (Hlp_StrCmp(panName, "Сковорода")) { // RU (Windows 1251)
            return 3;
        };
    };
    return 0; // Otherwise EN
};

func void Kwickloot_LocalizeKeyBinding(var int menuKey, var int menuInp) {
    var zCMenuItem itmKey; itmKey = _^(menuKey);
    var zCMenuItem itmInp; itmInp = _^(menuInp);
    
    if (Kwickloot_LOCALE == 0 /* EN */) {
        itmKey.m_parText[1] = "Press DEL to remove and ENTER to define a key.";
        itmInp.m_parText[1] = "Press the desired key.";
    } else if (Kwickloot_LOCALE == 2 /* PL */) {
        itmKey.m_parText[1] = "DEL - usuwa, ENTER - przypisuje klawisz.";
        itmInp.m_parText[1] = "Naciњnij ї№dany klawisz.";
    } else if (Kwickloot_LOCALE == 3 /* RU */) {
        itmKey.m_parText[1] = "Кнопка удалить Удалить и вернуться к определению";
        itmInp.m_parText[1] = "Нажмите нужную клавишу.";
    };
};

/*
 * Menu initialization function called by Ninja every time a menu is opened
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func void Ninja_Kwickloot_Menu(var int menuPtr) { // Adjust name
    // Initialize Ikarus
    MEM_InitAll();
	const int once = 1;
	if (once) {
        Kwickloot_LOCALE = Kwickloot_GuessLocalization();
		Kwickloot_Init_Options();
		once = 0;
	};

    // Get menu and menu item list, corresponds to C_MENU_DEF.items[]
    var zCMenu menu; menu = _^(menuPtr);
    var int items; items = _@(menu.m_listItems_array);

    // Modify each menu by its name
    if (Hlp_StrCmp(menu.name, "MENU_OPT_CONTROLS")) {
        // New menu instances (description and key binding)
        var string itm1Str; itm1Str = "MENUITEM_KEY_KWICKLOOT";
        var string itm2Str; itm2Str = "MENUITEM_INP_KWICKLOOT";

        // Get new items
        var int itm1; itm1 = MEM_GetMenuItemByString(itm1Str);
        var int itm2; itm2 = MEM_GetMenuItemByString(itm2Str);

        // If the new ones do not exist yet, create them the first time
        if (!itm1) {
            var zCMenuItem itm;
            itm1 = Kwickloot_CreateMenuItem(itm1Str);
            itm2 = Kwickloot_CreateMenuItem(itm2Str);
            Kwickloot_LocalizeKeyBinding(itm1, itm2);

            // Copy properties of first key binding entry (left column)
            var int itmF_left; itmF_left = MEM_ArrayRead(items, 1);
            Kwickloot_CopyMenuItemProperties(itm1, itmF_left);
            itm = _^(itmF_left);
            var int ypos_l; ypos_l = itm.m_parPosY;

            // Retrieve right column entry and copy its properties too
            var string rightname; rightname = itm.m_parOnSelAction_S;
            rightname = STR_SubStr(rightname, 4, STR_Len(rightname)-4);
            var int itmF_right; itmF_right = MEM_GetMenuItemByString(rightname);
            if (itmF_right) {
                Kwickloot_CopyMenuItemProperties(itm2, itmF_right);
            } else { // If not found, copy from left column
                Kwickloot_CopyMenuItemProperties(itm2, itmF_left);
                itm = _^(itm2);
                itm.m_parPosX += 2700; // Default x position
            };
            itm = _^(itmF_right);
            var int ypos_r; ypos_r = itm.m_parPosY;

            // Find "BACK" menu item by its action (to add the new ones above)
            const int index = 0;
            repeat(index, MEM_ArraySize(items));
                itm = _^(MEM_ArrayRead(items, index));
                if (itm.m_parOnSelAction == /*SEL_ACTION_BACK*/ 1)
                && (itm.m_parItemFlags & /*IT_SELECTABLE*/ 4) {
                    break;
                };
            end;
            var int y; y = itm.m_parPosY; // Obtain vertical position

            // Adjust height of new entries (just above the "BACK" option)
            itm = _^(itm1);
            itm.m_parPosY = y;
            itm = _^(itm2);
            itm.m_parPosY = y + (ypos_r - ypos_l); // Maintain possible difference

            // Get maximum height of new entries
            var int ystep; ystep = Kwickloot_MenuItemGetHeight(itm1);
            var int ystep_r; ystep_r = Kwickloot_MenuItemGetHeight(itm2);
            if (ystep_r > ystep) {
                ystep = ystep_r;
            };

            // Shift vertical positions of all following menu items below
            repeat(i, MEM_ArraySize(items) - index); var int i;
                itm = _^(MEM_ArrayRead(items, i + index));
                itm.m_parPosY += ystep;
            end;
        };

        // Add new entries at the correct position
        Kwickloot_ArrayInsertAtPos(items, index, itm1);
        Kwickloot_ArrayInsertAtPos(items, index+1, itm2);
    };
};
