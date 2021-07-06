
func void _Kwickloot_Set_AnimStart() {
	_Kwickloot_Set_AnimStart_Y = MEMINT_SwitchG1G2(ESI, EBX);
	_Kwickloot_Set_AnimStart_X = MEMINT_SwitchG1G2(EDI, EAX);
};

func void _Kwickloot_AnimMoveX(var int MyText, var int Position) {
	var zCViewText MyTextObject;
	if (Hlp_IsValidHandle(MyText)) {
		MyTextObject = Print_GetText(MyText);
		MyTextObject.posx = Position;
	};
};
func void _Kwickloot_AnimMoveY(var int MyText, var int Position) {
	var zCViewText MyTextObject;
	if (Hlp_IsValidHandle(MyText)) {
		MyTextObject = Print_GetText(MyText);
		MyTextObject.posy = Position;
	};
};

func void _Kwickloot_PrintLoot_Anim(var string text, var int startX, var int startY, var int stopX, var int stopY, var int color) {
	var int MyText;    MyText    = Print_Ext(startX, startY, text, Kwickloot_Print_Font, color, -1);
    var int MyAnim8_X; MyAnim8_X = Anim8_NewExt(startX, _Kwickloot_AnimMoveX, MyText, FALSE);
    var int MyAnim8_Y; MyAnim8_Y = Anim8_NewExt(startY, _Kwickloot_AnimMoveY, MyText, FALSE);

    Anim8(MyAnim8_X, stopX, _Kwickloot_Print_AnimSpeed, A8_SlowStart); // Move to target X location
	Anim8q(MyAnim8_X, stopX, _Kwickloot_Print_Duration, A8_Wait);      // Wait there for X seconds
	Anim8_RemoveIfEmpty(MyAnim8_X, TRUE);                                    // Cleanup automatically
	Anim8_RemoveDataIfEmpty(MyAnim8_X, TRUE);                                // also remove Data

    Anim8(MyAnim8_Y, stopY, _Kwickloot_Print_AnimSpeed, A8_SlowEnd);   // Also move on the Y axis
	Anim8_RemoveIfEmpty(MyAnim8_Y, TRUE);                                    // only clean Anim
};

func void _Kwickloot_PrintLootExt(var string text, var int anim, var int color) {
    const int _Kwickloot_Print_Count_Limit = 30;

	if (_Kwickloot_Print_Count_Limit_Current > _Kwickloot_Print_Count_Limit) { return; };
	// If we, for some reason, have no font.
	if (STR_Len(Kwickloot_Print_Font) == 0) { return; };

	if (_Kwickloot_Print_Count >= _Kwickloot_Print_Count_Max) { _Kwickloot_Print_Count = 0; };
	// restart from top if text would be out-of-bounds (Y-coords)
	if ((_Kwickloot_Print_Y + (_Kwickloot_Print_TextHeight * _Kwickloot_Print_Count) + _Kwickloot_Print_TextHeight) >= PS_VMax) {
		_Kwickloot_Print_Count = 0;
	};

	if (anim) {
		_Kwickloot_PrintLoot_Anim(text, _Kwickloot_Set_AnimStart_X, _Kwickloot_Set_AnimStart_Y, _Kwickloot_Print_X, _Kwickloot_Print_Y + (_Kwickloot_Print_TextHeight * _Kwickloot_Print_Count), color);
	} else {
		Print_Ext(_Kwickloot_Print_X, _Kwickloot_Print_Y + (_Kwickloot_Print_TextHeight * _Kwickloot_Print_Count), text, Kwickloot_Print_Font, color, _Kwickloot_Print_Duration);
	};

	_Kwickloot_Print_Count += 1;
	_Kwickloot_Print_Timer = 0;
	_Kwickloot_Print_Count_Limit_Current +=1;
};

func void _Kwickloot_PerceiveAction(var C_NPC taker, var int vobPtr, var int perc) {
	// Not supported in Gothic 1.
	if (GOTHIC_BASE_VERSION != 2) { return; };
	if (!vobPtr) { return; };

	var oCNpc oTaker; oTaker = Hlp_GetNpc(taker);
    var C_ITEM itmOld;
	if (Hlp_IsValidItem(item)) { itmOld = MEM_CpyInst(item); }
	else                       { itmOld = MEM_NullToInst();  };

	if (perc == Kwickloot_PERC_ASSESSTHEFT) {
		// Set global ITEM variable. This is for Npc_SendPassivePerc to not report errors.
		item = MEM_PtrToInst(vobPtr);
	};
	if (perc == Kwickloot_PERC_ASSESSUSEMOB) {
		// Set obstVob variable. NPC will react to action with this.
		if (!Hlp_Is_oCMobInter(vobPtr)) {
			return;
		};
		const int oldInteractMob = 0; oldInteractMob = oTaker.interactMob;
		if (final()) { oTaker.interactMob = oldInteractMob; };
		
		oTaker.interactMob = vobPtr;
	};
	// Sends perception to all surrounding NPCs
	// this creates a zSPY warning about invalid "victim" but that's fine!
	Npc_SendPassivePerc(taker, perc, NULL, taker);
	item = MEM_CpyInst(itmOld);
};

func int _Kwickloot_ColorForRarity(var int rarity) {
	if (!_Kwickloot_Print_UseColors) {
		return COL_White;
	};
	if      (rarity == Kwickloot_RARITY_RARE)   { return Kwickloot_COLOR_RARE; }
	else if (rarity == Kwickloot_RARITY_GOLD)   { return Kwickloot_COLOR_GOLD; }
	else if (rarity == Kwickloot_RARITY_QUEST)  { return Kwickloot_COLOR_QUEST; }
	else if (rarity == Kwickloot_RARITY_WEAPON) { return Kwickloot_COLOR_WEAPON; }
	else if (rarity == Kwickloot_RARITY_FOOD)   { return Kwickloot_COLOR_FOOD; }
	else if (rarity == Kwickloot_RARITY_COMMON) { return Kwickloot_COLOR_COMMON; }
	;
	return Kwickloot_COLOR_NONE;
};

func void _Kwickloot_PrintItem(var string name, var int amount, var int rarity) {
	var int color; color = _Kwickloot_ColorForRarity(rarity);
	var string text; text = name;

	if (amount > 1) {
		text = ConcatStrings(IntToString(amount) , "x ");
		text = ConcatStrings(text, name);
	};
	_Kwickloot_PrintLootExt(
		ConcatStrings(_Kwickloot_Received_Prefix, text),
		_Kwickloot_Print_UseAnimation, color
	);
};

func int _Kwickloot_RarityForItem(var C_ITEM itm) {
	const int _ITEM_KAT_NF      = 1 <<  1; // ITEM_KAT_NF
	const int _ITEM_KAT_FF      = 1 <<  2; // ITEM_KAT_FF
	const int _ITEM_KAT_MUN     = 1 <<  3; // ITEM_KAT_MUN
	const int _ITEM_KAT_FOOD    = 1 <<  5; // ITEM_KAT_FOOD
	const int _ITEM_KAT_POTIONS = 1 <<  7; // ITEM_KAT_POTIONS
	const int _ITEM_KAT_RUNE    = 1 <<  9; // ITEM_KAT_RUNE
	const int _ITEM_MISSION     = 1 << 12; // ITEM_MISSION
	
	if      (itm.flags & _ITEM_MISSION) { return Kwickloot_RARITY_QUEST;  }
	else if (itm.flags & _ITEM_KAT_NF)  { return Kwickloot_RARITY_WEAPON; }
	else if (itm.flags & _ITEM_KAT_FF)  { return Kwickloot_RARITY_WEAPON; }
	else if (itm.flags & _ITEM_KAT_MUN) { return Kwickloot_RARITY_COMMON; };

	if (itm.value >= Kwickloot_ITEM_EXPENSIVE) { return Kwickloot_RARITY_RARE; };

	if      (itm.flags & _ITEM_KAT_FOOD)    { return Kwickloot_RARITY_FOOD;   }
	else if (itm.flags & _ITEM_KAT_POTIONS) { return Kwickloot_RARITY_FOOD;   }
	else if (itm.flags & _ITEM_KAT_RUNE)    { return Kwickloot_RARITY_NONE;   };

	if (Hlp_GetInstanceId(itm) == Kwickloot_INDEX_MONEY) { return Kwickloot_RARITY_GOLD; };

	if (itm.value <= 10)    { return Kwickloot_RARITY_COMMON; };

	return Kwickloot_RARITY_NONE;
};

func void _Kwickloot_TakeOrStealItem(var C_NPC taker, var int itemPtr) {	
    var oCItem targetItem; targetItem = MEM_PtrToInst(itemPtr);
    if (!Hlp_IsValidItem(targetItem)) { return; };
    var int itemAmount; itemAmount = targetItem.amount;

    var int itmID; itmID = Hlp_GetInstanceID(targetItem);
	var C_ITEM itm; itm = MEM_PtrToInst(itemPtr);
	var int itemRarity; itemRarity = _Kwickloot_RarityForItem(itm);

	var string itemName; itemName = targetItem.description;
    if (Hlp_StrCmp(itemName, "")) {
        itemName = targetItem.name;
    };

	// oCNpc::DoTakeVob, without putting Torch in hand
	if (Hlp_StrCmp(targetItem._zCObject_objectName, "ITLSTORCHBURNING")) {
		if (GOTHIC_BASE_VERSION == 1) {
			// DoTakeVob does the same in G2!
			_Kwickloot_World_DisableVob(itemPtr);
		};
		const int ADR_DoTakeVob_CheckForTorch_G1 = 6950370; // 006a0de2
		const int ADR_DoTakeVob_CheckForTorch_G2 = 7621294; // 00744aae
		const int addr = 0; addr = MEMINT_SwitchG1G2(ADR_DoTakeVob_CheckForTorch_G1, ADR_DoTakeVob_CheckForTorch_G2);
		MemoryProtectionOverride(addr, 1);
		MEM_WriteByte(addr, 116); // 0x74 // replace with JE
		_Kwickloot_oCNpc_DoTakeVob(_@(taker), itemPtr);
		MEM_WriteByte(addr, 117); // 0x75 // restore JNZ
	} else {
		_Kwickloot_oCNpc_DoTakeVob(_@(taker), itemPtr);
	};

    _Kwickloot_PrintItem(itemName, itemAmount, itemRarity);
};

func int _Kwickloot_NpcHasValidBodyState(var oCNPC npc) {
	const int _BS_UNCONSCIOUS = 22;
	if (npc.interactMob) { return 0; };
	// const int bs = 0; bs = npc.bitfield[4] & oCNpc_bitfield4_bodyState;
	// if (npc.bitfield[4] & _BS_UNCONSCIOUS) { return 0; };

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
func void _Kwickloot_LootNpc(var C_NPC _owner, var C_NPC _receiver){
	// Globales ITEM speichern und zurücksetzen am Ende
	var C_ITEM itmOld;
	if (Hlp_IsValidItem(item)) { itmOld = MEM_CpyInst(item); }
	else                       { itmOld = MEM_NullToInst();  };

	if (final())               { item = MEM_CpyInst(itmOld); };
	var int itemRarity;
    var int amount;
    var int itmID; 
    var string itemName;
    
    var int slotNr;
	if (GOTHIC_BASE_VERSION == 2) {
		// Gothic 2 lies to you about categories got NPC_GetInvItemBySlot.
		// It only looks in a global inventory without respecting the category
		slotNr = 0;
		while (1); // Loop all items, until category is empty/item is invalid
			amount = NPC_GetInvItemBySlot(_owner, Kwickloot_ITEM_KAT_NONE, slotNr);
			if (amount == 0) { break; };
			if (!Hlp_IsValidItem(item)) { break; };
			
			itmID = Hlp_GetInstanceID(item);
			if (item.flags & Kwickloot_ITEM_KAT_ARMOR) {
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
				itemRarity = _Kwickloot_RarityForItem(item);

				_Kwickloot_PrintItem(itemName, amount, itemRarity);

				CreateInvItems (_receiver, itmID, amount);
				Npc_RemoveInvItems (_owner, itmID, amount);
			};
		end;
	} else {
		repeat (i,Kwickloot_INV_CAT_MAX); var int i;
			slotNr = 0;
			while (1); // Loop all items, until category is empty/item is invalid
				amount = NPC_GetInvItemBySlot(_owner, i, slotNr);
				if (amount == 0) { break; };
				if (!Hlp_IsValidItem(item)) { break; };
				
				itmID = Hlp_GetInstanceID(item);
				if (item.flags & Kwickloot_ITEM_KAT_ARMOR) {
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
					itemRarity = _Kwickloot_RarityForItem(item);
					_Kwickloot_PrintItem(itemName, amount, itemRarity);

					CreateInvItems (_receiver, itmID, amount);
					Npc_RemoveInvItems (_owner, itmID, amount);
				};
			end;
		end;
	};
	// Damit die Funktion nicht mehrfach hintereinander ausgeführt wird.
	_Kwickloot_CNpc_SetFocusVob(_receiver, 0);
};

func int _Kwickloot__Npc_HasItem(var c_npc npc, var string instanceString) {
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

func void _Kwickloot_Unlock(var c_npc npc, var oCMobLockable lockable, var int playSound) {
	lockable.bitfield = lockable.bitfield & ~oCMobLockable_bitfield_locked;
	if (playSound) {
		Snd_Play3D(npc, "PICKLOCK_SUCCESS");
	};
};


func int _Kwickloot_Container_ConditionFunc(var oCMobContainer container) {
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

func void _Kwickloot_Container_OnState(var string state, var int stateNo) {
	var string stateName; stateName = state;
	stateName = ConcatStrings(stateName, "_S");
	stateName = ConcatStrings(stateName, IntToString(stateNo));
	
	var int symId; symId = MEM_FindParserSymbol(stateName);
	if (symId != -1) {
		var C_NPC oldSlf; oldSlf = MEM_CpyInst(self);
		self = MEM_CpyInst(hero);
		MEM_CallByID(symId);
		self = MEM_CpyInst(oldSlf);
		oldSlf = MEM_NullToInst();
	};
};

func void _Kwickloot_Container_ExecuteStates(var oCMobContainer container) {
	// TODO: implement calling OnTrigger for container
	if (!Hlp_StrCmp(container._oCMobInter_onStateFuncName, "")) {
		// Hat OnStateFunc, sollten wir ausführen!
		_Kwickloot_Container_OnState(container._oCMobInter_onStateFuncName, 0);
		_Kwickloot_Container_OnState(container._oCMobInter_onStateFuncName, 1);
		_Kwickloot_Container_OnState(container._oCMobInter_onStateFuncName, 2);
		_Kwickloot_Container_OnState(container._oCMobInter_onStateFuncName, 3);
	};
};

func int _Kwickloot_KnowsPicklocking() {
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

func void _Kwickloot_LootContainer(var C_NPC taker, var int containerPtr) {
	var oCMobContainer container; container = MEM_PtrToInst(containerPtr);
	if (!_Kwickloot_Container_ConditionFunc(container)) {
		_Kwickloot_CNpc_SetFocusVob(taker, 0);
		return;
	};

	if (Hlp_Is_oCMobLockable(containerPtr)) {
		var oCMobLockable lockable; lockable = MEM_PtrToInst(containerPtr);
		const int _oCMobLockable_bitfield_autoOpen = ((1 <<  1) - 1) << 1;

		if (lockable.bitfield & oCMobLockable_bitfield_locked) {
			if (_Kwickloot__Npc_HasItem(taker, lockable.keyInstance)) {
				_Kwickloot_Unlock(taker, lockable, 1);
			} else if (lockable.bitfield & _oCMobLockable_bitfield_autoOpen) { 
				_Kwickloot_Unlock(taker, lockable, 0);
			} else {
				var int needsNoKey; needsNoKey = Hlp_StrCmp(lockable.keyInstance, "");
				if (!needsNoKey) {
					AI_OutputSVM_Overlay(taker, taker, "$KEYMISSING");
				} else if (!_Kwickloot_KnowsPicklocking()){
					AI_OutputSVM_Overlay(taker, taker, "$NOPICKLOCKTALENT");
				} else {
					AI_OutputSVM_Overlay(taker, taker, "$PICKLOCKMISSING");
				};
				// locked + No key or requires lockpicking, clear focus & exit.
				_Kwickloot_CNpc_SetFocusVob(taker, 0);
				lockable = MEM_NullToInst();
				return;
			};
		};
		lockable = MEM_NullToInst();
	};

	var int nodePtr; nodePtr = container.containList_next;
	var zCListSort node;
	var int itemRarity;

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
		var C_ITEM itm; itm = MEM_PtrToInst(node.data);

		itemRarity = _Kwickloot_RarityForItem(itm);
		CreateInvItems(taker, Hlp_GetInstanceId(oItem), oItem.amount);
		_Kwickloot_PrintItem(oItem.description, oItem.amount, itemRarity);

		nodePtr = node.next;
	end;
	oItem = MEM_NullToInst();

	_Kwickloot_Mob_RemoveAllItems(containerPtr);

	// Notify surrounding NPCs that we stole from a chest.
	_Kwickloot_PerceiveAction(taker, containerPtr, Kwickloot_PERC_ASSESSUSEMOB);
	_Kwickloot_Container_ExecuteStates(container);
	container = MEM_NullToInst();
	_Kwickloot_CNpc_SetFocusVob(taker, 0);
};

func void _Kwickloot_ClearRuneInv(var C_Npc targetNpc) {
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

func void _Kwickloot_ToggleRMBCancel(var int on) {
	const int CGameManager__HandleEvent_CaseRMB_G2 = 4370169;

	if (GOTHIC_BASE_VERSION != 2) { return; };

	const int once = 1;
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
func int _Kwickloot_IsInState(var C_NPC npc, var int stateFn) {
	MEM_PushInstParam(npc);
	MEM_PushIntParam(stateFn);
	MEM_Call(Npc_IsInState);
	return MEM_PopIntResult();
};

func void _Kwickloot_Loot() {
	var int delayCounter;
	var int delay;
	
	// Reset override of RMB functionality as soon as possible.
	var int resetRMBoverride;
	const int RMB_OVERRIDE_TIMESPAN = 250;
	if (resetRMBoverride > 0) {
		resetRMBoverride -= MEM_Timer.frameTime;
		if (resetRMBoverride <= 0) {
			_Kwickloot_ToggleRMBCancel(TRUE);
			resetRMBoverride = 0;
		};
	};

	_Kwickloot_Print_Timer += MEM_Timer.frameTime;
	// Reset the Print-Counter if not printed for X milliseconds
	if (_Kwickloot_Print_Timer > _Kwickloot_Print_Duration_Total) {
		_Kwickloot_Print_Count_Limit_Current = 0;
		_Kwickloot_Print_Count = 0;
		_Kwickloot_Print_Timer = 0;
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
	
	var int keyState;    keyState    = MEM_KeyState(MEM_GetKey(Kwickloot_KEYNAME));
	var int keyStateSec; keyStateSec = MEM_KeyState(MEM_GetSecondaryKey(Kwickloot_KEYNAME));
	if (!(keyState    == KEY_PRESSED || keyState    == KEY_HOLD))
	&& (!(keyStateSec == KEY_PRESSED || keyStateSec == KEY_HOLD)) { return; };

	// Check if any weapon is "readied" (also fist/magic)
	if (_Kwickloot__Npc_GetWeaponMode(hero) != 0) {
		return;
	};

	const int SYM_ZS_Unconscious = 0;
	if (SYM_ZS_Unconscious == 0) {
		SYM_ZS_Unconscious = MEM_FindParserSymbol("ZS_Unconscious");
	};
	if (SYM_ZS_Unconscious != -1) {
		if (_Kwickloot_IsInState(hero, SYM_ZS_Unconscious)) {
			return;
		};
	};

	var oCNpc her; her = MEM_CpyInst(hero);
	if (!_Kwickloot_NpcHasValidBodyState(her)) { her = MEM_NullToInst(); return ; };

	if (Hlp_Is_oCNpc(her.focus_vob)) {
		var C_Npc targetNpc; targetNpc = MEM_PtrToInst(her.focus_vob);

		// Keine lebenden NPC ausrauben! Ausser wenn sie am Boden liegen.
		if (targetNpc.attribute[ATR_HITPOINTS] <= 0) {
			// Transfer Target inventory into Ours
			_Kwickloot_ClearRuneInv(targetNpc);
			_Kwickloot_LootNpc(targetNpc, hero);
		} else if (SYM_ZS_Unconscious != -1) {
			if (_Kwickloot_IsInState(targetNpc, SYM_ZS_Unconscious)) {
				_Kwickloot_ClearRuneInv(targetNpc);
				_Kwickloot_LootNpc(targetNpc, hero);
			};
		};
		targetNpc = MEM_NullToInst();
	} else if (Hlp_Is_oCItem(her.focus_vob)) {
		_Kwickloot_TakeOrStealItem(hero, her.focus_vob);
		_Kwickloot_NPC_CollectFocusVob(hero, /* force: */ 1);
		_Kwickloot_ToggleRMBCancel(FALSE);
		resetRMBoverride = RMB_OVERRIDE_TIMESPAN;
		delay = 80;
	} else if (Hlp_Is_oCMobContainer(her.focus_vob)) {
		_Kwickloot_LootContainer(hero, her.focus_vob);
		_Kwickloot_ToggleRMBCancel(FALSE);
		resetRMBoverride = RMB_OVERRIDE_TIMESPAN;
	};
	her = MEM_NullToInst();
};

/// Init-function called by Ninja
func void Kwickloot_Init_Internal() {
	MEM_Info(ConcatStrings(ConcatStrings("Initialize ", KWICKLOOT_VERSION), "."));
	LeGo_MergeFlags(LeGo_FrameFunctions | LeGo_PrintS);

	FF_ApplyOnceGT(_Kwickloot_Loot);
    MEM_Info(ConcatStrings(KWICKLOOT_VERSION, " was initialized successfully."));
};
