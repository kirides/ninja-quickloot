const string NINJA_QUICKLOOT_VERSION = "Quickloot v1.9.5"; 

FUNC VOID _Ninja_Quickloot_NPC_CollectFocusVob (var C_NPC slfInstance, var int force) {
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

func void _Ninja_Quickloot_Set_AnimStart() {
	_Ninja_Quickloot_Set_AnimStart_Y = MEMINT_SwitchG1G2(ESI, EBX);
	_Ninja_Quickloot_Set_AnimStart_X = MEMINT_SwitchG1G2(EDI, EAX);
};

func void _Ninja_Quickloot_AnimMoveX(var int MyText, var int Position) {
	var zCViewText MyTextObject;
	if (Hlp_IsValidHandle(MyText)) {
		MyTextObject = Print_GetText(MyText);
		MyTextObject.posx = Position;
	};
};
func void _Ninja_Quickloot_AnimMoveY(var int MyText, var int Position) {
	var zCViewText MyTextObject;
	if (Hlp_IsValidHandle(MyText)) {
		MyTextObject = Print_GetText(MyText);
		MyTextObject.posy = Position;
	};
};

func void _Ninja_Quickloot_PrintLoot_Anim(var string text, var int startX, var int startY, var int stopX, var int stopY) {
	var int MyText;    MyText    = Print_Ext(startX, startY, text, Ninja_Quickloot_Print_Font, COL_White, -1);
    var int MyAnim8_X; MyAnim8_X = Anim8_NewExt(startX, _Ninja_Quickloot_AnimMoveX, MyText, FALSE);
    var int MyAnim8_Y; MyAnim8_Y = Anim8_NewExt(startY, _Ninja_Quickloot_AnimMoveY, MyText, FALSE);

    Anim8(MyAnim8_X, stopX, _Ninja_Quickloot_Print_AnimSpeed, A8_SlowStart); // Move to target X location
	Anim8q(MyAnim8_X, stopX, _Ninja_Quickloot_Print_Duration, A8_Wait);      // Wait there for X seconds
	Anim8_RemoveIfEmpty(MyAnim8_X, TRUE);                                    // Cleanup automatically
	Anim8_RemoveDataIfEmpty(MyAnim8_X, TRUE);                                // also remove Data

    Anim8(MyAnim8_Y, stopY, _Ninja_Quickloot_Print_AnimSpeed, A8_SlowEnd);   // Also move on the Y axis
	Anim8_RemoveIfEmpty(MyAnim8_Y, TRUE);                                    // only clean Anim
};

func void _Ninja_Quickloot_PrintLootExt(var string text, var int anim) {
    const int _Ninja_Quickloot_Print_Count_Limit = 30;

	if (_Ninja_Quickloot_Print_Count_Limit_Current > _Ninja_Quickloot_Print_Count_Limit) { return; };
	// If we, for some reason, have no font.
	if (STR_Len(Ninja_Quickloot_Print_Font) == 0) { return; };

	if (_Ninja_Quickloot_Print_Count >= _Ninja_Quickloot_Print_Count_Max) { _Ninja_Quickloot_Print_Count = 0; };

	if (anim) {
		_Ninja_Quickloot_PrintLoot_Anim(text, _Ninja_Quickloot_Set_AnimStart_X, _Ninja_Quickloot_Set_AnimStart_Y, _Ninja_Quickloot_Print_TextHeight, PS_VMax / 2 + (_Ninja_Quickloot_Print_TextHeight * _Ninja_Quickloot_Print_Count));
	} else {
		Print_Ext(_Ninja_Quickloot_Print_TextHeight, PS_VMax / 2 + (_Ninja_Quickloot_Print_TextHeight * _Ninja_Quickloot_Print_Count), text, Ninja_Quickloot_Print_Font, COL_White, _Ninja_Quickloot_Print_Duration);
	};

	_Ninja_Quickloot_Print_Count += 1;
	_Ninja_Quickloot_Print_Timer = 0;
	_Ninja_Quickloot_Print_Count_Limit_Current +=1;
};

func void _Ninja_Quickloot_PrintLoot(var string text) { 
	_Ninja_Quickloot_PrintLootExt(text, FALSE);
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

func void _Ninja_Quickloot_PerceiveAction(var C_NPC taker, var int vobPtr, var int perc) {
	// Not supported in Gothic 1.
	if (GOTHIC_BASE_VERSION != 2) { return; };
	if (!vobPtr) { return; };

	var oCNpc oTaker; oTaker = Hlp_GetNpc(taker);
    var C_ITEM itmOld;
	if (Hlp_IsValidItem(item)) { itmOld = MEM_CpyInst(item); }
	else                       { itmOld = MEM_NullToInst();  };

	if (perc == PERC_ASSESSTHEFT) {
		// Set global ITEM variable. This is for Npc_SendPassivePerc to not report errors.
		item = MEM_PtrToInst(vobPtr);
	};
	if (perc == PERC_ASSESSUSEMOB) {
		// Set obstVob variable. NPC will react to action with this.
		if (!Hlp_Is_oCMobInter(vobPtr)) {
			return;
		};
		oTaker.rbt_obstVob = vobPtr;
	};
	// Sends perception to all surrounding NPCs
	// this creates a zSPY warning about invalid "victim" but that's fine!
	Npc_SendPassivePerc(taker, perc, NULL, taker);
	item = MEM_CpyInst(itmOld);
};

func void _Ninja_Quickloot_PrintItem(var string name, var int amount) {
	if (amount > 1) {
		_Ninja_Quickloot_PrintLootExt(
			ConcatStrings(
				_Ninja_Quickloot_Received_Prefix, 
				ConcatStrings(
					ConcatStrings(IntToString(amount) , "x "),
					name
				)
			), _Ninja_Quickloot_Print_UseAnimation
		);
	} else {
		_Ninja_Quickloot_PrintLootExt(
			ConcatStrings(_Ninja_Quickloot_Received_Prefix, name),
			_Ninja_Quickloot_Print_UseAnimation
		);
	};
};

func void _Ninja_Quickloot_World_DisableVob(var int vobPtr) {
	const int oCWorld__DisableVob_G2 = 7865440; // 00780460
	if (MEMINT_SwitchG1G2(1, 0)) {
		// G1 is not supported for this.
		return;
	};
	var int worldPtr; worldPtr = _@(MEM_World);

	const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(vobPtr));
        CALL__thiscall(_@(worldPtr), oCWorld__DisableVob_G2);

        call = CALL_End();
    };
};

func void _Ninja_Quickloot_TakeOrStealItem(var C_NPC taker, var int itemPtr) {	
    var oCItem targetItem; targetItem = MEM_PtrToInst(itemPtr);
    if (!Hlp_IsValidItem(targetItem)) { return; };
    var int itemAmount; itemAmount = targetItem.amount;

    var string itemName; itemName = targetItem.description;
    if (Hlp_StrCmp(itemName, "")) {
        itemName = targetItem.name;
    };
    var int itmID; itmID = Hlp_GetInstanceID(targetItem);

    _Ninja_Quickloot_PerceiveAction(taker, itemPtr, PERC_ASSESSTHEFT);

    // Take the item without animation.
    CreateInvItems(taker, itmID, itemAmount);

	_Ninja_Quickloot_World_DisableVob(itemPtr);
    Wld_RemoveItem(targetItem);

    // Remove the Item from focus.
    _Ninja_Quickloot_CNpc_SetFocusVob(taker, 0);
    _Ninja_Quickloot_PrintItem(itemName, itemAmount);		
};

func int _Ninja_Quickloot_NpcHasValidBodyState(var oCNPC npc) {
	if (npc.interactMob) { return 0; };

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
	// Globales ITEM speichern und zurücksetzen am Ende
	var C_ITEM itmOld;
	if (Hlp_IsValidItem(item)) { itmOld = MEM_CpyInst(item); }
	else                       { itmOld = MEM_NullToInst();  };

	if (final())               { item = MEM_CpyInst(itmOld); };

    var int amount;
    var int itmID; 
    var string itemName;
    
    var int slotNr;
	if (GOTHIC_BASE_VERSION == 2) {
		// Gothic 2 lies to you about categories got NPC_GetInvItemBySlot.
		// It only looks in a global inventory without respecting the category
		slotNr = 0;
		while (1); // Loop all items, until category is empty/item is invalid
			amount = NPC_GetInvItemBySlot(_owner, ITEM_KAT_NONE, slotNr);
			if (amount == 0) { break; };
			if (!Hlp_IsValidItem(item)) { break; };
			
			itmID = Hlp_GetInstanceID(item);
			if (item.flags & ITEM_KAT_ARMOR) {
				slotNr += 1;
				continue;
			};
			// For now, also loot equipped stuff.
			// if (item.flags & ITEM_ACTIVE_LEGO) {
			// 	slotNr += 1;
			// 	continue;
			// };
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
	} else {
		repeat (i,INV_CAT_MAX); var int i;
			slotNr = 0;
			while (1); // Loop all items, until category is empty/item is invalid
				amount = NPC_GetInvItemBySlot(_owner, i, slotNr);
				if (amount == 0) { break; };
				if (!Hlp_IsValidItem(item)) { break; };
				
				itmID = Hlp_GetInstanceID(item);
				if (item.flags & ITEM_KAT_ARMOR) {
					slotNr += 1;
					continue;
				};
				// For now, also loot equipped stuff.
				// if (item.flags & ITEM_ACTIVE_LEGO) {
				// 	slotNr += 1;
				// 	continue;
				// };
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
	};
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


func int _Ninja_Quickloot_Container_ConditionFunc(var oCMobContainer container) {
	if (Hlp_StrCmp(container._oCMobInter_conditionFunc, "")) {
		return 1;
	};

	var int symId; symId = MEM_FindParserSymbol(container._oCMobInter_conditionFunc);
	if (symId != -1) {
		var C_NPC oldSlf; oldSlf = MEM_CpyInst(self);
		self = MEM_CpyInst(hero);
		MEM_CallByID(symId);
		self = MEM_CpyInst(oldSlf);
		return +MEM_PopIntResult();
	};

	return 1;
};

func void _Ninja_Quickloot_Container_OnState(var string state, var int stateNo) {
	var int symId; symId = MEM_FindParserSymbol(ConcatStrings(state, ConcatStrings("_S", IntToString(stateNo))));
	if (symId != -1) {
		var C_NPC oldSlf; oldSlf = MEM_CpyInst(self);
		self = MEM_CpyInst(hero);
		MEM_CallByID(symId);
		self = MEM_CpyInst(oldSlf);
		oldSlf = MEM_NullToInst();
	};
};

func void _Ninja_Quickloot_Container_ExecuteStates(var oCMobContainer container) {
	// TODO: implement calling OnTrigger for container
	if (!Hlp_StrCmp(container._oCMobInter_onStateFuncName, "")) {
		// Hat OnStateFunc, sollten wir ausführen!
		_Ninja_Quickloot_Container_OnState(container._oCMobInter_onStateFuncName, 0);
		_Ninja_Quickloot_Container_OnState(container._oCMobInter_onStateFuncName, 1);
		_Ninja_Quickloot_Container_OnState(container._oCMobInter_onStateFuncName, 2);
		_Ninja_Quickloot_Container_OnState(container._oCMobInter_onStateFuncName, 3);
	};
};

func int _Ninja_Quickloot_KnowsPicklocking() {
	// return Npc_GetTalentSkill (hero, NPC_TALENT_PICKLOCK);

	/*
		Use the code below for use in a PATCH
	*/
	const int talIdx = 0;
	if (talIdx == 0) {
		var int sym; sym = MEM_GetParserSymbol("NPC_TALENT_PICKLOCK");
		if (sym != 0) {
			var zCPar_Symbol s; s = _^(sym);
			talIdx = s.content;
		};
	};
	if (talIdx != 0) {
		return Npc_GetTalentSkill (hero, talIdx);
	};
	return 1;
};

func void _Ninja_Quickloot_MobRemoveItems_RemoveItem(var int pThis, var int itmAddress) {
	const int __oCMobContainerRemoveAddress_G1 = 6831792; //0x00683eb0
	const int __oCMobContainerRemoveAddress_G2 = 7495664; //0x00725FF0

	const int call = 0;
    if (CALL_Begin(call)) {
		CALL_IntParam (_@(itmAddress));
        CALL__thiscall(_@(pThis), MEMINT_SwitchG1G2 (__oCMobContainerRemoveAddress_G1, __oCMobContainerRemoveAddress_G2));

        call = CALL_End();
    };
};
func void _Ninja_Quickloot_Mob_RemoveAllItems(var int containerAddress) {
	var oCMobContainer container; container = _^(containerAddress);
	var int ptr; ptr = container.containList_next;
	var zCListSort list;

	while(ptr != 0);
		list = _^(ptr);
		var int itmPtr; itmPtr = list.data;
		
		if (itmPtr == 0) {
			ptr  = list.next;
		} else {
			_Ninja_Quickloot_MobRemoveItems_RemoveItem(containerAddress, itmPtr);
			ptr = container.containList_next;
		};
	end;
};

func void _Ninja_Quickloot_LootContainer(var C_NPC taker, var int containerPtr) {
	var oCMobContainer container; container = MEM_PtrToInst(containerPtr);
	if (!_Ninja_Quickloot_Container_ConditionFunc(container)) {
		_Ninja_Quickloot_CNpc_SetFocusVob(taker, 0);
		return;
	};

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
				} else if (!_Ninja_Quickloot_KnowsPicklocking()){
					AI_OutputSVM_Overlay(taker, taker, "$NOPICKLOCKTALENT");
				} else {
					AI_OutputSVM_Overlay(taker, taker, "$PICKLOCKMISSING");
				};
				// locked + No key or requires lockpicking, clear focus & exit.
				_Ninja_Quickloot_CNpc_SetFocusVob(taker, 0);
				lockable = MEM_NullToInst();
				return;
			};
		};
		lockable = MEM_NullToInst();
	};

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

	_Ninja_Quickloot_Mob_RemoveAllItems(containerPtr);

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
const int _Ninja_Quickloot_LootKey = 525; /* MOUSE_BUTTONRIGHT */

func int _Ninja_Quickloot__Npc_GetWeaponMode(var C_NPC slf) {
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

func void _Ninja_Quickloot_ToggleRMBCancel(var int on) {
	const int CGameManager__HandleEvent_CaseRMB_G2 = 4370169;

	const int once = 1;
	if (MEMINT_SwitchG1G2(0, 1)) {
		if (once) {
			MemoryProtectionOverride(CGameManager__HandleEvent_CaseRMB_G2, 4);
			once = 0;
		};

		if (on){
			MEM_WriteInt(CGameManager__HandleEvent_CaseRMB_G2, 525);
		} else {
			MEM_WriteInt(CGameManager__HandleEvent_CaseRMB_G2, 999999);
		};
	};
};

func void _Ninja_Quickloot_Loot() {
	var int delayCounter;
	var int delay;
	_Ninja_Quickloot_Print_Timer += MEM_Timer.frameTime;
	// Reset the Print-Counter if not printed for X milliseconds
	if (_Ninja_Quickloot_Print_Timer > _Ninja_Quickloot_Print_Duration_Total) {
		_Ninja_Quickloot_Print_Count_Limit_Current = 0;
		_Ninja_Quickloot_Print_Count = 0;
		_Ninja_Quickloot_Print_Timer = 0;
		_Ninja_Quickloot_ToggleRMBCancel(TRUE);
	};
	// Throttle item-pickup
	if (delay > 0 && delay <= delayCounter) {
		delayCounter = 0;
		delay = 0;
	} else if (delay > 0) {
		delayCounter += MEM_Timer.frameTime;
		return;
	};
	// Check for RMB pressed / held
	var int keyState; keyState = MEM_KeyState(_Ninja_Quickloot_LootKey);
	if (!(keyState == KEY_PRESSED || keyState == KEY_HOLD)) { return; };

	// Check if any weapon is "readied" (also fist/magic)
	if (_Ninja_Quickloot__Npc_GetWeaponMode(hero) != 0) {
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
		_Ninja_Quickloot_ToggleRMBCancel(FALSE);
		delay = 80;
	} else if (Hlp_Is_oCMobContainer(her.focus_vob)) {
		_Ninja_Quickloot_LootContainer(hero, her.focus_vob);
		_Ninja_Quickloot_ToggleRMBCancel(FALSE);
	};
	her = MEM_NullToInst();
};

func int Ninja_Quickloot_ReadOptKey() {
	const int optionKey = -1;
	if (!MEM_GothOptExists("NINJA_QUICKLOOT", "Key")) {
		if (GOTHIC_BASE_VERSION == 2) {
			MEM_SetGothOpt("NINJA_QUICKLOOT", "Key", "RMB");
		} else {
			MEM_SetGothOpt("NINJA_QUICKLOOT", "Key", "V");
		};
	};
	const int _real_KEY_Y = KEY_Y;
	const int _real_KEY_Z = KEY_Z;

	if (HLP_StrCmp(MEM_GetGothOpt("GAME", "keyboardLayout"), "00000407")) {
		// Handle German keyboard layout.
		_real_KEY_Y = KEY_Z;
		_real_KEY_Z = KEY_Y;
	};

	if (GOTHIC_BASE_VERSION != 2) {
		optionKey = KEY_V;
	};

	var string keyOpt; keyOpt = MEM_GetGothOpt("NINJA_QUICKLOOT", "Key");
	keyOpt = STR_Upper(keyOpt);
	if      (Hlp_StrCmp(keyOpt, "")) { /* Default */ }
	else if (Hlp_StrCmp(keyOpt, "A")) { optionKey = KEY_A ; }
	else if (Hlp_StrCmp(keyOpt, "B")) { optionKey = KEY_B ; }
	else if (Hlp_StrCmp(keyOpt, "C")) { optionKey = KEY_C ; }
	else if (Hlp_StrCmp(keyOpt, "D")) { optionKey = KEY_D ; }
	else if (Hlp_StrCmp(keyOpt, "E")) { optionKey = KEY_E ; }
	else if (Hlp_StrCmp(keyOpt, "F")) { optionKey = KEY_F ; }
	else if (Hlp_StrCmp(keyOpt, "G")) { optionKey = KEY_G ; }
	else if (Hlp_StrCmp(keyOpt, "H")) { optionKey = KEY_H ; }
	else if (Hlp_StrCmp(keyOpt, "I")) { optionKey = KEY_I ; }
	else if (Hlp_StrCmp(keyOpt, "J")) { optionKey = KEY_J ; }
	else if (Hlp_StrCmp(keyOpt, "K")) { optionKey = KEY_K ; }
	else if (Hlp_StrCmp(keyOpt, "L")) { optionKey = KEY_L ; }
	else if (Hlp_StrCmp(keyOpt, "M")) { optionKey = KEY_M ; }
	else if (Hlp_StrCmp(keyOpt, "N")) { optionKey = KEY_N ; }
	else if (Hlp_StrCmp(keyOpt, "O")) { optionKey = KEY_O ; }
	else if (Hlp_StrCmp(keyOpt, "P")) { optionKey = KEY_P ; }
	else if (Hlp_StrCmp(keyOpt, "Q")) { optionKey = KEY_Q ; }
	else if (Hlp_StrCmp(keyOpt, "R")) { optionKey = KEY_R ; }
	else if (Hlp_StrCmp(keyOpt, "S")) { optionKey = KEY_S ; }
	else if (Hlp_StrCmp(keyOpt, "T")) { optionKey = KEY_T ; }
	else if (Hlp_StrCmp(keyOpt, "U")) { optionKey = KEY_U ; }
	else if (Hlp_StrCmp(keyOpt, "V")) { optionKey = KEY_V ; }
	else if (Hlp_StrCmp(keyOpt, "W")) { optionKey = KEY_W ; }
	else if (Hlp_StrCmp(keyOpt, "X")) { optionKey = KEY_X ; }
	else if (Hlp_StrCmp(keyOpt, "Y")) { optionKey = _real_KEY_Y ; }
	else if (Hlp_StrCmp(keyOpt, "Z")) { optionKey = _real_KEY_Z ; }
	else if (Hlp_StrCmp(keyOpt, "RMB")) { optionKey = MEMINT_SwitchG1G2(2052, MOUSE_BUTTONRIGHT); }
	else if (Hlp_StrCmp(keyOpt, "MMB")) { optionKey = MOUSE_BUTTONMID ; }
	else if (Hlp_StrCmp(keyOpt, "MB1")) { optionKey = MOUSE_XBUTTON1 ; }
	else if (Hlp_StrCmp(keyOpt, "MB2")) { optionKey = MOUSE_XBUTTON2 ; }
	else if (Hlp_StrCmp(keyOpt, "MB3")) { optionKey = MOUSE_XBUTTON3 ; }
	else if (Hlp_StrCmp(keyOpt, "MB4")) { optionKey = MOUSE_XBUTTON4 ; }
	else if (Hlp_StrCmp(keyOpt, "MB5")) { optionKey = MOUSE_XBUTTON5 ; };

	return +optionKey;
};

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
	};
	_Ninja_Quickloot_LootKey = Ninja_Quickloot_ReadOptKey();

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

/// Init-function called by Ninja
func void Ninja_Quickloot_Init_Internal() {
	MEM_Info(ConcatStrings(ConcatStrings("Initialize ", NINJA_QUICKLOOT_VERSION), "."));
	LeGo_MergeFlags(LeGo_FrameFunctions | LeGo_PrintS);

	FF_ApplyOnceGT(_Ninja_Quickloot_Loot);
    MEM_Info(ConcatStrings(NINJA_QUICKLOOT_VERSION, " was initialized successfully."));
};
