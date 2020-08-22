const string NINJA_QUICKLOOT_VERSION = "Quickloot v1.6"; 

/***
	Credits: F A W K E S

    Removes specific vobPtr from slf.vobList_array
***/
FUNC VOID _Ninja_Quickloot_NPC_RemoveFromVobList (var C_NPC slfInstance, var int vobPtr) {
    //006B7080  .text     Debug data           ?RemoveFromVobList@oCNpc@@QAEXPAVzCVob@@@Z
    const int oCNpc__RemoveFromVobList_G1 = 7041152;
    //0x0075D9B0 public: void __thiscall oCNpc::RemoveFromVobList(class zCVob *)
    const int oCNpc__RemoveFromVobList_G2 = 7723440;
    
    if (!vobPtr)    { return; };
    
    var int npcPtr; npcPtr = MEM_InstToPtr(slfInstance);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam (_@(vobPtr));
        CALL__thiscall(_@(npcPtr), MEMINT_SwitchG1G2 (oCNpc__RemoveFromVobList_G1, oCNpc__RemoveFromVobList_G2));

        call = CALL_End();
    };
};
FUNC VOID _Ninja_Quickloot_NPC_CollectFocusVob (var C_NPC slfInstance, var int force) {
    var int npcPtr; npcPtr = MEM_InstToPtr(slfInstance);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_IntParam (_@(force));
        CALL__thiscall(_@(npcPtr), 7551504 /* 00733A10: oCNpc::CollectFocusVob */);

        call = CALL_End();
    };
};
/// Removes player/self and dead/C_NpcIsDown Npc's from voblist
/// ____
/// Credits: F A W K E S
FUNC VOID _Ninja_Quickloot_NPC_VobList_RemoveInvalid (var C_NPC slfInstance)
{
    var oCNPC slf; slf = MEM_CpyInst(slfInstance);
    
    var int i; i = 0;
    while (slf.vobList_numInArray > 0);
        var int vobPtr; vobPtr = MEM_ReadIntArray (slf.vobList_array, i);
        
        if (Hlp_Is_oCNpc (vobPtr))
        {
            var C_NPC npc; npc = MEM_PtrToInst(vobPtr);
            if (C_NpcIsDown(npc) 
			|| NPC_IsDead (npc)
			|| Npc_IsPlayer(npc)
			|| (slfInstance == vobPtr)) {
                //remove down,dead,player,self from vobList_array
                _Ninja_Quickloot_NPC_RemoveFromVobList (slfInstance, vobPtr);

                //restart loop
                i = 0;
                continue;
            };
        } else {
			_Ninja_Quickloot_NPC_RemoveFromVobList (slfInstance, vobPtr);
			//restart loop
			i = 0;
			continue;
		};
        
        i += 1;
		if (i >= slf.vobList_numInArray) { break; };
	end;

	slf = MEM_NullToInst();
	npc = MEM_NullToInst();
};

/***
   Credits: F A W K E S

	_Ninja_Quickloot_NPC_CreateVobList (var int slfInstance, var int range)
    Pretty much same as NPC_PerceiveAll - however allows you to control range in which Vobs will be collected.
    When used all collected vobs will be available in slf.vobList_array.

	Kirides: Removes non-npc vobs, Dead and Player NPCs
***/
FUNC VOID _Ninja_Quickloot_NPC_CreateVobList (var C_NPC slf, var int range) {
    //006B7110  .text     Debug data           ?CreateVobList@oCNpc@@QAEXM@Z
    const int oCNpc__CreateVobList_G1 = 7041296;
    //0x0075DA40 public: void __thiscall oCNpc::CreateVobList(float)
    const int oCNpc__CreateVobList_G2 = 7723584;
    
    var int slfPtr; slfPtr = MEM_InstToPtr (slf);
    var int range_f; range_f = mkf(range);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_IntParam(_@(range_f));
        CALL__thiscall(_@(slfPtr), MEMINT_SwitchG1G2 (oCNpc__CreateVobList_G1, oCNpc__CreateVobList_G2));

        call = CALL_End();
    };
	_Ninja_Quickloot_NPC_VobList_RemoveInvalid(slf);
};

/***
	Credits: F A W K E S

    Checks if NPC can see vobPtr.
***/
FUNC INT _Ninja_Quickloot_NPC_FreeLineOfSight (var int npcPtr, var int vobPtr) {
    //0069DE50  .text     Debug data           ?FreeLineOfSight@oCNpc@@QAEHPAVzCVob@@@Z
    const int oCNpc__FreeLineOfSight_G1 = 6938192;
    //0x007418E0 public: int __thiscall oCNpc::FreeLineOfSight(class zCVob *)
    const int oCNpc__FreeLineOfSight_G2 = 7608544;
    
    if (!vobPtr)    { return 0; };
    
    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PutRetValTo(_@(fos));
        CALL_PtrParam (_@(vobPtr));
        CALL__thiscall (_@(npcPtr), MEMINT_SwitchG1G2 (oCNpc__FreeLineOfSight_G1, oCNpc__FreeLineOfSight_G2));

        call = CALL_End();
    };

    var int fos;
    return fos;
};

// Used to calculate the "Top"-Offset for a Print
const int _Ninja_Quickloot_Print_Count = 0;
// Used to make Prints always start at the "Top"
const int _Ninja_Quickloot_Print_Timer = 0;
const int _Ninja_Quickloot_Print_Duration = 3000;
const string Ninja_Quickloot_Print_Font = "FONT_OLD_10_WHITE.TGA"; // <-- PF_Font

const int _Ninja_Quickloot_Print_Count_Limit_Current = 0;

func void _Ninja_Quickloot_PrintLoot(var string text) {
    const int _Ninja_Quickloot_Print_Count_Max = 15;
    const int _Ninja_Quickloot_Print_Count_Limit = 30;

	if (_Ninja_Quickloot_Print_Count_Limit_Current > _Ninja_Quickloot_Print_Count_Limit) { return; };
	// If we, for some reason, have no font.
	if (STR_Len(Ninja_Quickloot_Print_Font) == 0) { return; };

	if (_Ninja_Quickloot_Print_Count > _Ninja_Quickloot_Print_Count_Max) { _Ninja_Quickloot_Print_Count = 0; };
	
	Print_Ext(PF_TextHeight, PS_VMax / 2 + (PF_TextHeight * _Ninja_Quickloot_Print_Count), text, Ninja_Quickloot_Print_Font, COL_White, _Ninja_Quickloot_Print_Duration);
	_Ninja_Quickloot_Print_Count += 1;
	_Ninja_Quickloot_Print_Timer = 0;
	_Ninja_Quickloot_Print_Count_Limit_Current +=1;
};

func void _Ninja_Quickloot_CNpc_SetFocusVob(var C_Npc npc, var int vobPtr) {
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

func void _Ninja_Quickloot_PerceiveAction(var C_NPC taker, var int vobPtr, var int perc){
	var oCNpc oTaker; oTaker = MEM_CpyInst(taker);
    var C_ITEM itmOld;
	if (Hlp_IsValidItem(item)) {
		itmOld = MEM_CpyInst(item);
	};
	if (perc == PERC_ASSESSTHEFT) {
		// Set global ITEM variable. This is for Npc_SendPassivePerc to not report errors.
		ITEM = MEM_PtrToInst(vobPtr);
	};
	if (perc == PERC_ASSESSUSEMOB) {
		// Set obstVob variable. NPC will react to action with this.
		oTaker.rbt_obstVob = vobPtr;
	};
	// Sends perception to all surrounding NPCs
	Npc_SendPassivePerc(oTaker, perc, oTaker, oTaker);
	oTaker = MEM_NullToInst();
	ITEM = MEM_CpyInst(itmOld);
	itmOld = MEM_NullToInst();
};

func void _Ninja_Quickloot_PrintItem(var string name, var int amount) {
	if (amount > 1) {
		_Ninja_Quickloot_PrintLoot(
			ConcatStrings(
				"Erhalten: ", 
				ConcatStrings(
					ConcatStrings(IntToString(amount) , "x "),
					name
				)
			)
		);
	} else {
		_Ninja_Quickloot_PrintLoot(
			ConcatStrings("Erhalten: ", name)
		);
	};
};

func void _Ninja_Quickloot_TakeOrStealItem(var C_NPC taker, var int itemPtr) {
    var C_Item targetItem; targetItem = MEM_PtrToInst(itemPtr);
    if (!Hlp_IsValidItem(targetItem)) { targetItem = MEM_NullToInst(); return; };

    var oCItem item_; item_ = MEM_CpyInst(targetItem);
    var int itemAmount; itemAmount = item_.amount;
    item_ = MEM_NullToInst();

    var string itemName; itemName = targetItem.description;
    if (Hlp_StrCmp(itemName, "")) {
        itemName = targetItem.name;
    };
    var int itmID; itmID = Hlp_GetInstanceID(targetItem);


    _Ninja_Quickloot_PerceiveAction(taker, itemPtr, PERC_ASSESSTHEFT);

    // Take the item without animation.
    CreateInvItems(taker, itmID, itemAmount);
    Wld_RemoveItem(targetItem);
	targetItem = MEM_NullToInst();

    // Remove the Item from focus.
    _Ninja_Quickloot_CNpc_SetFocusVob(taker, 0);
    _Ninja_Quickloot_PrintItem(itemName, itemAmount);		
};

func int _Ninja_Quickloot_NpcHasValidBodyState(var oCNPC npc) {
	return (((npc.bitfield[4] & BS_STAND) > 0)
		|| ((npc.bitfield[4] & BS_WALK) > 0)
		|| ((npc.bitfield[4] & BS_SNEAK) > 0)
		|| ((npc.bitfield[4] & BS_RUN) > 0)
		|| ((npc.bitfield[4] & BS_SPRINT) > 0)
		|| ((npc.bitfield[4] & BS_SWIM) > 0)
		|| ((npc.bitfield[4] & BS_DIVE) > 0)
		);
};

// https://forum.worldofplayers.de/forum/threads/1337194-Gothic-2-Script-that-transfers-NPCs-inventory-to-hero?p=22540061&viewfull=1#post22540061
func void _Ninja_Quickloot_LootNpc(var C_NPC _owner, var C_NPC _receiver){
    var int amount;
    var int itmID; 
    var string itemName;
    
    var int slotNr;
    repeat (i,INV_CAT_MAX); var int i;
		slotNr = 0;
		while (1); // Loop all items, until category is empty/item is invalid
			amount = NPC_GetInvItemBySlot(_owner, i, slotNr);
			if (amount == 0) { break; };
			if (!Hlp_IsValidItem(Item)) { break; };
            
            itmID = Hlp_GetInstanceID(Item);
            if (item.flags & ITEM_KAT_ARMOR) {
				slotNr += 1;
				continue;
			};
            if (item.flags & ITEM_ACTIVE_LEGO) {
				slotNr += 1;
				continue;
			};
			if (amount > 0) {
				itemName = item.description;
				if (Hlp_StrCmp(itemName, "")) {
					itemName = item.name;
				};
				_Ninja_Quickloot_PrintItem(itemName, amount);

				CreateInvItems (_receiver, itmID, amount);
				Npc_RemoveInvItems (_owner, itmID, amount);
			};
		end;
	end;
	// Damit die Funktion nicht mehrfach hintereinander ausgeführt wird.
	_Ninja_Quickloot_CNpc_SetFocusVob(_receiver, 0);
};

func int _Ninja_Quickloot__Npc_HasItem(var c_npc npc, var string instanceString) {
	if (Hlp_StrCmp(instanceString, "")) {
		return 0;
	};
	var int symIdx; symIdx = MEM_GetSymbolIndex(instanceString);
	if (symIdx != -1) {
		if (Npc_HasItems(npc, symIdx)) {
			return 1;
		};
	};
	return 0;
};

func void _Ninja_Quickloot_Unlock(var c_npc npc, var oCMobLockable lockable, var int playSound) {
	lockable.bitfield = lockable.bitfield & ~oCMobLockable_bitfield_locked;
	if (playSound) {
		Snd_Play3D(npc, "PICKLOCK_SUCCESS");
	};
};

func void _Ninja_Quickloot_Container_OnState(var string state, var int stateNo) {
	var int symId; symId = MEM_FindParserSymbol(ConcatStrings(state, ConcatStrings("_S", IntToString(stateNo))));
	if (symId != -1) {
		var C_NPC oldSlf; oldSlf = Hlp_GetNpc(self);
		self = Hlp_GetNpc(hero);
		MEM_CallByID(symId);
		self = Hlp_GetNpc(oldSlf);
		oldSlf = MEM_NullToInst();
	};
};

func void _Ninja_Quickloot_Container_ExecuteStates(var oCMobContainer container) {
	if (!Hlp_StrCmp(container._oCMobInter_onStateFuncName, "")) {
		// Hat OnStateFunc, sollten wir ausführen!
		_Ninja_Quickloot_Container_OnState(container._oCMobInter_onStateFuncName, 1);
	};
};

func void _Ninja_Quickloot_LootContainer(var C_NPC taker, var int containerPtr) {
	if (Hlp_Is_oCMobLockable(containerPtr)) {
		var oCMobLockable lockable; lockable = MEM_PtrToInst(containerPtr);
		const int _oCMobLockable_bitfield_autoOpen = ((1 <<  1) - 1) << 1;

		if (lockable.bitfield & oCMobLockable_bitfield_locked) {
			if (_Ninja_Quickloot__Npc_HasItem(taker, lockable.keyInstance)) {
				_Ninja_Quickloot_Unlock(taker, lockable, 1);
			} else if (lockable.bitfield & _oCMobLockable_bitfield_autoOpen) { 
				_Ninja_Quickloot_Unlock(taker, lockable, 0);
			} else {
				var int needsNoKey; needsNoKey = Hlp_StrCmp(lockable.keyInstance, "");
				if (!needsNoKey) {
					AI_OutputSVM_Overlay(taker, taker, "$KEYMISSING");
				};
				// locked + No key or requires lockpicking, clear focus & exit.
				_Ninja_Quickloot_CNpc_SetFocusVob(taker, 0);
				lockable = MEM_NullToInst();
				return;
			};
		};
	};
	lockable = MEM_NullToInst();
	var oCMobContainer container; container = MEM_PtrToInst(containerPtr);

	var int nodePtr; nodePtr = container.containList_next;
	var zCListSort node;

	while(nodePtr);
		node = MEM_PtrToInst(nodePtr);
		if (!node.data) {
			nodePtr = node.next;
			continue;
		};
		var oCItem oItem; oItem = MEM_PtrToInst(node.data);

		if (!Hlp_IsValidItem(oItem)) {
			nodePtr = node.next;
			continue;
		};

		CreateInvItems(taker, Hlp_GetInstanceId(oItem), oItem.amount);
		_Ninja_Quickloot_PrintItem(oItem.description, oItem.amount);

		nodePtr = node.next;
	end;
	oItem = MEM_NullToInst();
	// Remove the container contents, by NULL-ing the first item pointer of the list.
	container.containList_next = 0;

	// Notify surrounding NPCs that we stole from a chest.
	_Ninja_Quickloot_PerceiveAction(taker, containerPtr, PERC_ASSESSUSEMOB);
	_Ninja_Quickloot_Container_ExecuteStates(container);
	container = MEM_NullToInst();
	_Ninja_Quickloot_CNpc_SetFocusVob(taker, 0);
};

func void _Ninja_Quickloot_ClearRuneInv(var C_Npc targetNpc) {
	// B_ClearRuneInv(targetNpc);
	
	// Use the following code if planning on using it as a patch.
	// Code assumes if B_ClearRuneInv exists
	// it takes a C_NPC as single parameter.
	
	const int once = 1;
	const int fnId = -1;
	if (once) {
		fnId = +MEM_FindParserSymbol("B_ClearRuneInv");
		once = 0;
	};
	if (fnId != -1) {
		MEM_PushInstParam(targetNpc); // Push targetNpc for function parameter.
		MEM_CallByID(fnId);
	};
	
};

func void _Ninja_Quickloot_Loot() {
	var int delayCounter;
	var int delay;
	_Ninja_Quickloot_Print_Timer += MEM_Timer.frameTime;
	// Reset the Print-Counter if not printed for X milliseconds
	if (_Ninja_Quickloot_Print_Timer > _Ninja_Quickloot_Print_Duration) {
		_Ninja_Quickloot_Print_Count_Limit_Current = 0;
		_Ninja_Quickloot_Print_Count = 0;
		_Ninja_Quickloot_Print_Timer = 0;
	};
	// Throttle item-pickup
	if (delay > 0 && delay <= delayCounter) {
		delayCounter = 0;
		delay = 0;
	} else if (delay > 0) {
		delayCounter += MEM_Timer.frameTime;
		return;
	};
	// Check for RMB pressed
	if (!MEM_KeyPressed(MOUSE_BUTTONRIGHT)) { return; };

	if (Npc_HasReadiedWeapon(hero) || Npc_HasReadiedRangedWeapon(hero) || Npc_HasReadiedMeleeWeapon(hero)) {
		return;
	};
	if (Npc_IsInState(hero, ZS_Unconscious)) {
		return;
	};

	var oCNpc her; her = MEM_CpyInst(hero);
	if (!_Ninja_Quickloot_NpcHasValidBodyState(her)) { her = MEM_NullToInst(); return ; };

	if (Hlp_Is_oCNpc(her.focus_vob)) {
		var C_Npc targetNpc; targetNpc = MEM_PtrToInst(her.focus_vob);

		// Keine lebenden NPC ausrauben! Ausser wenn sie am Boden liegen.
		if (targetNpc.attribute[ATR_HITPOINTS] <= 0 || Npc_IsInState(targetNpc, ZS_Unconscious)) {
			// Transfer Target inventory into Ours
			_Ninja_Quickloot_ClearRuneInv(targetNpc);
			_Ninja_Quickloot_LootNpc(targetNpc, hero);
		};
		targetNpc = MEM_NullToInst();
	} else if (Hlp_Is_oCItem(her.focus_vob)) {
		_Ninja_Quickloot_TakeOrStealItem(hero, her.focus_vob);
		_Ninja_Quickloot_NPC_CollectFocusVob(hero, /* force: */ 1);
		delay = 80;
	} else if (Hlp_Is_oCMobContainer(her.focus_vob)) {
		_Ninja_Quickloot_LootContainer(hero, her.focus_vob);
	};
	her = MEM_NullToInst();
};

/// Init-function called by Ninja
func void Ninja_Quickloot_Init_Internal() {
	MEM_Info(ConcatStrings(ConcatStrings("Initialize ", NINJA_QUICKLOOT_VERSION), "."));
	LeGo_MergeFlags(LeGo_FrameFunctions);

	Ninja_Quickloot_Print_Font = "Ninja_QuickLoot_Font_DE.tga";

	FF_ApplyOnceGT(_Ninja_Quickloot_Loot);
    MEM_Info(ConcatStrings(NINJA_QUICKLOOT_VERSION, " was initialized successfully."));
};
