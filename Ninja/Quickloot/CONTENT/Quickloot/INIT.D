
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
	// restart from top if text would be out-of-bounds (Y-coords)
	if ((_Ninja_Quickloot_Print_Y + (_Ninja_Quickloot_Print_TextHeight * _Ninja_Quickloot_Print_Count) + _Ninja_Quickloot_Print_TextHeight) >= PS_VMax) {
		_Ninja_Quickloot_Print_Count = 0;
	};

	if (anim) {
		_Ninja_Quickloot_PrintLoot_Anim(text, _Ninja_Quickloot_Set_AnimStart_X, _Ninja_Quickloot_Set_AnimStart_Y, _Ninja_Quickloot_Print_X, _Ninja_Quickloot_Print_Y + (_Ninja_Quickloot_Print_TextHeight * _Ninja_Quickloot_Print_Count));
	} else {
		Print_Ext(_Ninja_Quickloot_Print_X, _Ninja_Quickloot_Print_Y + (_Ninja_Quickloot_Print_TextHeight * _Ninja_Quickloot_Print_Count), text, Ninja_Quickloot_Print_Font, COL_White, _Ninja_Quickloot_Print_Duration);
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

	const int _PERC_ASSESSTHEFT  = -1;
	const int _PERC_ASSESSUSEMOB = -1;
	if (perc == PATCH_QUICKLOOT_PERC_ASSESSTHEFT) {
		// Set global ITEM variable. This is for Npc_SendPassivePerc to not report errors.
		item = MEM_PtrToInst(vobPtr);
	};
	if (perc == PATCH_QUICKLOOT_PERC_ASSESSUSEMOB) {
		// Set obstVob variable. NPC will react to action with this.
		if (!Hlp_Is_oCMobInter(vobPtr)) {
			return;
		};
		oTaker.rbt_obstVob = vobPtr;
	};
	// Sends perception to all surrounding NPCs
	// this creates a zSPY warning about invalid "victim" but that's fine!
	Npc_SendPassivePerc(taker, perc, taker, NULL);
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

    _Ninja_Quickloot_PerceiveAction(taker, itemPtr, PATCH_QUICKLOOT_PERC_ASSESSTHEFT);

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
			amount = NPC_GetInvItemBySlot(_owner, PATCH_QUICKLOOT_ITEM_KAT_NONE, slotNr);
			if (amount == 0) { break; };
			if (!Hlp_IsValidItem(item)) { break; };
			
			itmID = Hlp_GetInstanceID(item);
			if (item.flags & PATCH_QUICKLOOT_ITEM_KAT_ARMOR) {
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
	} else {
		repeat (i,PATCH_QUICKLOOT_INV_CAT_MAX); var int i;
			slotNr = 0;
			while (1); // Loop all items, until category is empty/item is invalid
				amount = NPC_GetInvItemBySlot(_owner, i, slotNr);
				if (amount == 0) { break; };
				if (!Hlp_IsValidItem(item)) { break; };
				
				itmID = Hlp_GetInstanceID(item);
				if (item.flags & PATCH_QUICKLOOT_ITEM_KAT_ARMOR) {
					slotNr += 1;
					continue;
				};
				// For now, also loot equipped stuff.
				// How do Xardas' golem hearts work in G1?
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
	_Ninja_Quickloot_PerceiveAction(taker, containerPtr, PATCH_QUICKLOOT_PERC_ASSESSUSEMOB);
	_Ninja_Quickloot_Container_ExecuteStates(container);
	container = MEM_NullToInst();
	_Ninja_Quickloot_CNpc_SetFocusVob(taker, 0);
};

func void _Ninja_Quickloot_ClearRuneInv(var C_Npc targetNpc) {
	// B_ClearRuneInv(targetNpc);
	
	// Use the following code if planning on using it as a patch.
	// Code assumes if B_ClearRuneInv exists
	// it takes a C_NPC as single parameter.
	
	const int fnId = 0;
	if (fnId == 0) {
		fnId = MEM_FindParserSymbol("B_ClearRuneInv");
	};
	if (fnId != -1) {
		MEM_PushInstParam(targetNpc); // Push targetNpc for function parameter.
		MEM_CallByID(fnId);
	};
	
};

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
func int _Ninja_Quickloot_IsInState(var C_NPC npc, var int stateFn) {
	MEM_PushInstParam(npc);
	MEM_PushIntParam(stateFn);
	MEM_Call(Npc_IsInState);
	return MEM_PopIntResult();
};

func void _Ninja_Quickloot_Loot() {
	var int delayCounter;
	var int delay;
	
	// Reset override of RMB functionality as soon as possible.
	var int resetRMBoverride;
	const int RMB_OVERRIDE_TIMESPAN = 250;
	if (resetRMBoverride > 0) {
		resetRMBoverride -= MEM_Timer.frameTime;
		if (resetRMBoverride <= 0) {
			_Ninja_Quickloot_ToggleRMBCancel(TRUE);
			resetRMBoverride = 0;
		};
	};

	_Ninja_Quickloot_Print_Timer += MEM_Timer.frameTime;
	// Reset the Print-Counter if not printed for X milliseconds
	if (_Ninja_Quickloot_Print_Timer > _Ninja_Quickloot_Print_Duration_Total) {
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
	// Check for RMB pressed / held
	
	var int keyState;    keyState    = MEM_KeyState(MEM_GetKey("keyPatchQuickloot"));
	var int keyStateSec; keyStateSec = MEM_KeyState(MEM_GetSecondaryKey("keyPatchQuickloot"));
	if (!(keyState    == KEY_PRESSED || keyState    == KEY_HOLD))
	&& (!(keyStateSec == KEY_PRESSED || keyStateSec == KEY_HOLD)) { return; };

	// Check if any weapon is "readied" (also fist/magic)
	if (_Ninja_Quickloot__Npc_GetWeaponMode(hero) != 0) {
		return;
	};

	const int SYM_ZS_Unconscious = 0;
	if (SYM_ZS_Unconscious == 0) {
		SYM_ZS_Unconscious = MEM_FindParserSymbol("ZS_Unconscious");
	};
	if (SYM_ZS_Unconscious != -1) {
		if (_Ninja_Quickloot_IsInState(hero, SYM_ZS_Unconscious)) {
			return;
		};
	};

	var oCNpc her; her = MEM_CpyInst(hero);
	if (!_Ninja_Quickloot_NpcHasValidBodyState(her)) { her = MEM_NullToInst(); return ; };

	if (Hlp_Is_oCNpc(her.focus_vob)) {
		var C_Npc targetNpc; targetNpc = MEM_PtrToInst(her.focus_vob);

		// Keine lebenden NPC ausrauben! Ausser wenn sie am Boden liegen.
		if (targetNpc.attribute[ATR_HITPOINTS] <= 0) {
			// Transfer Target inventory into Ours
			_Ninja_Quickloot_ClearRuneInv(targetNpc);
			_Ninja_Quickloot_LootNpc(targetNpc, hero);
		} else if (SYM_ZS_Unconscious != -1) {
			if (_Ninja_Quickloot_IsInState(targetNpc, SYM_ZS_Unconscious)) {
				_Ninja_Quickloot_ClearRuneInv(targetNpc);
				_Ninja_Quickloot_LootNpc(targetNpc, hero);
			};
		};
		targetNpc = MEM_NullToInst();
	} else if (Hlp_Is_oCItem(her.focus_vob)) {
		_Ninja_Quickloot_TakeOrStealItem(hero, her.focus_vob);
		_Ninja_Quickloot_NPC_CollectFocusVob(hero, /* force: */ 1);
		_Ninja_Quickloot_ToggleRMBCancel(FALSE);
		resetRMBoverride = RMB_OVERRIDE_TIMESPAN;
		delay = 80;
	} else if (Hlp_Is_oCMobContainer(her.focus_vob)) {
		_Ninja_Quickloot_LootContainer(hero, her.focus_vob);
		_Ninja_Quickloot_ToggleRMBCancel(FALSE);
		resetRMBoverride = RMB_OVERRIDE_TIMESPAN;
	};
	her = MEM_NullToInst();
};

/// Init-function called by Ninja
func void Ninja_Quickloot_Init_Internal() {
	MEM_Info(ConcatStrings(ConcatStrings("Initialize ", NINJA_QUICKLOOT_VERSION), "."));
	LeGo_MergeFlags(LeGo_FrameFunctions | LeGo_PrintS);

	FF_ApplyOnceGT(_Ninja_Quickloot_Loot);
    MEM_Info(ConcatStrings(NINJA_QUICKLOOT_VERSION, " was initialized successfully."));
};
