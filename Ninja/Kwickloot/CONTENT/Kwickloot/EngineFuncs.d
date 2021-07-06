
FUNC VOID _Kwickloot_NPC_CollectFocusVob (var C_NPC slfInstance, var int force) {
    var int npcPtr; npcPtr = MEM_InstToPtr(slfInstance);
	const int oCNpc__CollectFocusVob_G1 = 6884720; // 0x690D70
	const int oCNpc__CollectFocusVob_G2 = 7551504; // 0x733A10
    const int call = 0;
    if (CALL_Begin(call)) {
		if (GOTHIC_BASE_VERSION == 2) {
        	CALL_IntParam (_@(force));
		};
        CALL__thiscall(_@(npcPtr), MEMINT_SwitchG1G2 (oCNpc__CollectFocusVob_G1, oCNpc__CollectFocusVob_G2));

        call = CALL_End();
    };
};

func void _Kwickloot_oCNpc_DoTakeVob(var int npcPtr, var int vobPtr) {
	const int oCNpc__DoTakeVob_G1 = 6950160; // 006a0d10
	const int oCNpc__DoTakeVob_G2 = 7621056; // 007449c0
	const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(vobPtr));
        CALL__thiscall(_@(npcPtr), MEMINT_SwitchG1G2(oCNpc__DoTakeVob_G1, oCNpc__DoTakeVob_G2));

        call = CALL_End();
    };
};

func void _Kwickloot_CNpc_SetFocusVob(var C_Npc npc, var int vobPtr) {
	const int oCNpc__SetFocusVob_G1 = 6881136; // 0068FF70
	const int oCNpc__SetFocusVob_G2 = 7547744; // 00732B60
    var int npcPtr; npcPtr = MEM_InstToPtr(npc);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(vobPtr));
        CALL__thiscall(_@(npcPtr), MEMINT_SwitchG1G2 (oCNpc__SetFocusVob_G1, oCNpc__SetFocusVob_G2));

        call = CALL_End();
    };
};

func void _Kwickloot_World_DisableVob(var int vobPtr) {
	const int oCWorld__DisableVob_G1 = 7172688; // 006d7250
	const int oCWorld__DisableVob_G2 = 7865440; // 00780460
	var int worldPtr; worldPtr = _@(MEM_World);

	const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(vobPtr));
        CALL__thiscall(_@(worldPtr), MEMINT_SwitchG1G2(oCWorld__DisableVob_G1, oCWorld__DisableVob_G2));

        call = CALL_End();
    };
};

func void _Kwickloot_MobRemoveItems_RemoveItem(var int pThis, var int itmAddress) {
	const int __oCMobContainerRemoveAddress_G1 = 6831792; //0x00683eb0
	const int __oCMobContainerRemoveAddress_G2 = 7495664; //0x00725FF0

	const int call = 0;
    if (CALL_Begin(call)) {
		CALL_IntParam (_@(itmAddress));
        CALL__thiscall(_@(pThis), MEMINT_SwitchG1G2 (__oCMobContainerRemoveAddress_G1, __oCMobContainerRemoveAddress_G2));

        call = CALL_End();
    };
};
func void _Kwickloot_Mob_RemoveAllItems(var int containerAddress) {
	var oCMobContainer container; container = _^(containerAddress);
	var int ptr; ptr = container.containList_next;
	var zCListSort list;

	while(ptr != 0);
		list = _^(ptr);
		var int itmPtr; itmPtr = list.data;
		
		if (itmPtr == 0) {
			ptr  = list.next;
		} else {
			_Kwickloot_MobRemoveItems_RemoveItem(containerAddress, itmPtr);
			ptr = container.containList_next;
		};
	end;
};

func int _Kwickloot__Npc_GetWeaponMode(var C_NPC slf) {
	var int npcPtr; npcPtr = MEM_InstToPtr(slf);
	const int oCNpc___GetWeaponMode_G1 = 6903840; // 0x690D70
	const int oCNpc___GetWeaponMode_G2 = 7572544; // 0x738C40
    const int call = 0;
	var int retVal; retVal = 0;
    if (CALL_Begin(call)) {
		CALL_PutRetValTo(_@(retVal));
        CALL__thiscall(_@(npcPtr), MEMINT_SwitchG1G2 (oCNpc___GetWeaponMode_G1, oCNpc___GetWeaponMode_G2));
        call = CALL_End();
    };
	return retVal;
};

