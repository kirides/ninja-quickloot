const string NINJA_QUICKLOOT_VERSION = "Quickloot v1.1"; 

/***
	Credits: F A W K E S

    Ninja_Quickloot_NPC_RemoveFromVobList (var int slfInstance, var int vobPtr)
    Removes specific vobPtr from slf.vobList_array
***/
FUNC VOID Ninja_Quickloot_NPC_RemoveFromVobList (var int slfInstance, var int vobPtr)
{
    //006B7080  .text     Debug data           ?RemoveFromVobList@oCNpc@@QAEXPAVzCVob@@@Z
    const int oCNpc__RemoveFromVobList_G1 = 7041152;
    //0x0075D9B0 public: void __thiscall oCNpc::RemoveFromVobList(class zCVob *)
    const int oCNpc__RemoveFromVobList_G2 = 7723440;
    
    if (!vobPtr)    { return; };
    
    var C_NPC slf;
    slf = Hlp_GetNPC (slfInstance);
    
    var zCVob Vob;
    Vob = _^ (vobPtr);
    
    CALL_PtrParam (MEM_InstToPtr (Vob));
    CALL__thiscall (MEM_InstToPtr (slf), MEMINT_SwitchG1G2 (oCNpc__RemoveFromVobList_G1, oCNpc__RemoveFromVobList_G2));
};

/***
	Credits: F A W K E S
***/
FUNC VOID Ninja_Quickloot_NPC_VobList_RemoveInvalid (var int slfInstance)
{
    var oCNPC slf;
    slf = Hlp_GetNPC (slfInstance);
    
    var int i; i = 0;


    while (slf.vobList_numInArray > 0);
        var int vobPtr; vobPtr = MEM_ReadIntArray (slf.vobList_array, i);
        
        if (Hlp_Is_oCNpc (vobPtr))
        {
            var C_NPC npc; npc = _^(vobPtr);
            if (C_NpcIsDown(npc) 
			|| NPC_IsDead (npc)
			|| Npc_IsPlayer(npc)
			|| (slfInstance == vobPtr)) {
                //remove npc,player,self from vobList_array
                Ninja_Quickloot_NPC_RemoveFromVobList (slfInstance, vobPtr);

                //restart loop
                i = 0;
                continue;
            };
        } else {
			Ninja_Quickloot_NPC_RemoveFromVobList (slfInstance, vobPtr);
			//restart loop
			i = 0;
			continue;
		};
        
        i += 1;
		if (i >= slf.vobList_numInArray) { break; };
	end;
};

/***
   Credits: F A W K E S

	Ninja_Quickloot_NPC_CreateVobList (var int slfInstance, var int range)
    Pretty much same as NPC_PerceiveAll - however allows you to control range in which Vobs will be collected.
    When used all collected vobs will be available in slf.vobList_array.

	Kirides: Removes non-npc vobs, Dead and Player NPCs
***/
FUNC VOID Ninja_Quickloot_NPC_CreateVobList (var int slfInstance, var int range)
{
    //006B7110  .text     Debug data           ?CreateVobList@oCNpc@@QAEXM@Z
    const int oCNpc__CreateVobList_G1 = 7041296;
    //0x0075DA40 public: void __thiscall oCNpc::CreateVobList(float)
    const int oCNpc__CreateVobList_G2 = 7723584;
    
    var C_NPC slf;
    slf = Hlp_GetNPC (slfInstance);
    
    CALL_IntParam (mkf (range));
    CALL__thiscall (MEM_InstToPtr (slf), MEMINT_SwitchG1G2 (oCNpc__CreateVobList_G1, oCNpc__CreateVobList_G2));

	Ninja_Quickloot_NPC_VobList_RemoveInvalid(slfInstance);
};

/***
	Credits: F A W K E S

    Checks if NPC can see vobPtr.
***/
FUNC INT Ninja_Quickloot_NPC_FreeLineOfSight (var int slfInstance, var int vobPtr)
{
    //0069DE50  .text     Debug data           ?FreeLineOfSight@oCNpc@@QAEHPAVzCVob@@@Z
    const int oCNpc__FreeLineOfSight_G1 = 6938192;
    //0x007418E0 public: int __thiscall oCNpc::FreeLineOfSight(class zCVob *)
    const int oCNpc__FreeLineOfSight_G2 = 7608544;
    
    if (!vobPtr)    { return 0; };
    
    var C_NPC slf;
    slf = Hlp_GetNPC (slfInstance);
    
    var zCVob Vob;
    Vob = _^ (vobPtr);

    CALL_PtrParam (MEM_InstToPtr (Vob));
    CALL__thiscall (MEM_InstToPtr (slf), MEMINT_SwitchG1G2 (oCNpc__FreeLineOfSight_G1, oCNpc__FreeLineOfSight_G2));
    
    return CALL_RetValAsInt();
};

// Used to calculate the "Top"-Offset for a Print
const int Ninja_Quickloot_Print_Count = 0;
// Used to make Prints always start at the "Top"
const int Ninja_Quickloot_Print_Timer = 0;
const int Ninja_Quickloot_Print_Duration = 3000;
var string Ninja_Quickloot_Print_Font;

const int Ninja_Quickloot_Print_Count_Max = 15;
const int Ninja_Quickloot_Print_Count_Limit_Current = 0;
const int Ninja_Quickloot_Print_Count_Limit = 30;

func void Ninja_Quickloot_PrintLoot(var string text) {
	if (Ninja_Quickloot_Print_Count_Limit_Current > Ninja_Quickloot_Print_Count_Limit) { return; };
	// If we, for some reason, have no font.
	if (STR_Len(Ninja_Quickloot_Print_Font) == 0) { return; };
	Print_GetScreenSize(); // Accomodate for possible resolution change.

	var int txtHeight;
	if (Ninja_Quickloot_Print_Count > Ninja_Quickloot_Print_Count_Max) { Ninja_Quickloot_Print_Count = 0; };
	if (!txtHeight) { txtHeight = Print_GetFontHeight(Ninja_Quickloot_Print_Font); };
	
	const int _COL_White = (255<<16) | (255<<8) | (255<<0) | (255<<24); //#FFFFFF

	Print_ExtPxl(40, (Print_Screen[1] / 2) + (txtHeight * Ninja_Quickloot_Print_Count), text, Ninja_Quickloot_Print_Font, _COL_White, Ninja_Quickloot_Print_Duration);
	Ninja_Quickloot_Print_Count += 1;
	Ninja_Quickloot_Print_Timer = 0;
	Ninja_Quickloot_Print_Count_Limit_Current +=1;
};

func void Ninja_Quickloot_CNpc_SetFocusVob(var C_Npc npc, var int vobPtr) {
	const int oCNpc__SetFocusVob_G1 = 6881136; // 0068FF70
	const int oCNpc__SetFocusVob_G2 = 7547744; // 00732B60

	CALL_PtrParam(vobPtr);
	CALL__thiscall(MEM_InstToPtr(npc), MEMINT_SwitchG1G2 (oCNpc__SetFocusVob_G1, oCNpc__SetFocusVob_G2));
};

func void Ninja_Quickloot_PerceiveAction(var int takerPtr, var int vobPtr, var int perc){
	/*
		Recognize Theft, based on F A W K E S' NPC_CreateVobList.
	*/
	var oCNpc oTaker; oTaker = Hlp_GetNpc(takerPtr);
	Ninja_Quickloot_NPC_CreateVobList(takerPtr, 500); // TODO: Replace this with the proper range for theft.
	var C_Npc perceiver;
	var oCNpc cPerceiver;
	var int i; i = 0;
	var int npcptr;

	if (perc == PERC_ASSESSTHEFT) {
		// Set global ITEM variable. This is for Npc_SendPassivePerc to not report errors.
		ITEM = _^(vobPtr);
	};
	if (perc == PERC_ASSESSUSEMOB) {
		// Set obstVob variable. NPC will react to action with this.
		oTaker.rbt_obstVob = vobPtr;
	};
	while(i < oTaker.vobList_numInArray);
		npcPtr = MEM_ReadIntArray(oTaker.vobList_array, i);
		if (!npcPtr) { 
			i += 1;
			continue;
		};

		cPerceiver = _^(npcPtr);

		if (Ninja_Quickloot_NPC_FreeLineOfSight(cPerceiver, vobPtr)) {
			perceiver = _^(npcPtr);
			if (Hlp_IsValidNpc(perceiver)) {
				Npc_SendPassivePerc(oTaker, perc, perceiver, oTaker);
				break;
			};
		};

		i += 1;
	end;
};

func void Ninja_Quickloot_TakeOrStealItem(var int takerPtr, var int itemPtr) {
		var C_Item targetItem; targetItem = _^(itemPtr);
		if (!Hlp_IsValidItem(targetItem)) { return; };
		var oCItem item_; item_ =  _^(itemPtr);
		if (!Hlp_IsValidItem(item_)) { return; };
		
		var string itemName; itemName = targetItem.description;
		if (Hlp_StrCmp(itemName, "")) {
			itemName = targetItem.name;
		};

		if (Hlp_StrCmp(itemName, "")) {
			return;
		};

		var int itmID; itmID = Hlp_GetInstanceID(targetItem);

		Ninja_Quickloot_PerceiveAction(takerPtr, itemPtr, PERC_ASSESSTHEFT);

		// Take the item without animation.
		var C_Npc taker; taker = Hlp_GetNpc(takerPtr);
		var int itemAmount; itemAmount = item_.amount;
		CreateInvItems(taker, itmID, itemAmount);
		Wld_RemoveItem(targetItem);

		// Remove the Item from focus.
		Ninja_Quickloot_CNpc_SetFocusVob(taker, 0);

		if (itemAmount > 1) {
			Ninja_Quickloot_PrintLoot(
				ConcatStrings(
					"Erhalten: ", 
					ConcatStrings(
						ConcatStrings(IntToString(itemAmount) , "x "),
						itemName
					)
				)
			);
		} else {
			Ninja_Quickloot_PrintLoot(
				ConcatStrings("Erhalten: ", itemName)
			);
		};
		
};

func int Ninja_Quickloot_NpcHasValidBodyState(var oCNPC npc) {
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
func void Ninja_Quickloot_LootNpc(var C_NPC _owner, var C_NPC _receiver){
    var int amount;
    var int itmID; 
    var int i; i = 0;
    var string itemname;

	const int _ITEM_KAT_ARMOR = (1 << 4);
	const int _ITEM_KAT_ARMOR_EQUIPPED = _ITEM_KAT_ARMOR | ITEM_ACTIVE_LEGO;

    var int slotNr;
    while (i < INV_CAT_MAX);
		slotNr = 0;
		while (TRUE); // Loop all items, until category is empty/item is invalid
			amount = NPC_GetInvItemBySlot(_owner, i, slotNr);
			if (!Hlp_IsValidItem(Item)) { break; };

			if (item.flags & _ITEM_KAT_ARMOR_EQUIPPED)
			{
				slotNr += 1;
				continue;
			};
			if (item.flags & ITEM_ACTIVE_LEGO)
			{
				slotNr += 1;
				continue;
			};

			if (amount > 0)
			{
				itemName = item.description;
				if (Hlp_StrCmp(itemName, "")) {
					itemName = item.name;
				};
				if (amount > 1) {
					Ninja_Quickloot_PrintLoot(
						ConcatStrings("Erhalten: ", ConcatStrings(
							ConcatStrings(IntToString(amount), "x "),
							itemName)));
				} else {
					Ninja_Quickloot_PrintLoot(ConcatStrings("Erhalten: ", itemName));
				};

				itmID = Hlp_GetInstanceID(Item);
				CreateInvItems (_receiver, itmID, amount);
				Npc_RemoveInvItems (_owner, itmID, amount);
			};
		end;
        i += 1;
	end;
};

func void Ninja_Quickloot_LootContainer(var int takerPtr, var int containerPtr) {
		var oCMobContainer container; container = _^(containerPtr);

		var int nodePtr; nodePtr = container.containList_next;
		var zCListSort node;
		var C_NPC taker; taker = Hlp_GetNpc(takerPtr);

		while(nodePtr);
			node = _^(nodePtr);
			if (!node.data) {
				nodePtr = node.next;
				continue;
			};
			var C_Item cItem; var oCItem oItem;
			cItem = _^(node.data); oItem = _^(node.data);

			if (!Hlp_IsValidItem(cItem)) {
				nodePtr = node.next;
				continue;
			};
			CreateInvItems(taker, Hlp_GetInstanceId(cItem), oItem.amount);
			Ninja_Quickloot_PrintLoot(
				ConcatStrings("Erhalten: ", ConcatStrings(
					ConcatStrings(IntToString(oItem.amount), "x "),
					cItem.description)));

			nodePtr = node.next;
		end;

		// Remove the container contents, by NULL-ing the first item pointer of the list.
		container.containList_next = 0;

		// Notify surrounding NPCs that we stole from a chest.
		Ninja_Quickloot_PerceiveAction(takerPtr, containerPtr, PERC_ASSESSUSEMOB);
};

func void Ninja_Quickloot_Loot() {
	// Not during loading
    if (!Hlp_IsValidNpc(hero)) { return; };
    // Only in-game
    if (!MEM_Game.timestep) { return; };

	Ninja_Quickloot_Print_Timer += MEM_Timer.frameTime;
	// Reset the Print-Counter if not printed for X milliseconds
	if (Ninja_Quickloot_Print_Timer > Ninja_Quickloot_Print_Duration) {
		Ninja_Quickloot_Print_Count_Limit_Current = 0;
		Ninja_Quickloot_Print_Count = 0;
		Ninja_Quickloot_Print_Timer = 0;
	};

	if (Npc_HasReadiedWeapon(hero) || Npc_HasReadiedRangedWeapon(hero) || Npc_HasReadiedMeleeWeapon(hero)) {
		return;
	};
	// Check for RMB pressed
	if (!MEM_KeyPressed(MOUSE_BUTTONRIGHT)) { return; };
	var oCNpc her; her = Hlp_GetNpc(hero);
	if (!Ninja_Quickloot_NpcHasValidBodyState(her)) { return ; };

	if (Hlp_Is_oCNpc(her.focus_vob)) {
		var C_Npc targetNpc; targetNpc = _^(her.focus_vob);
		var C_Npc cHero; cHero = Hlp_GetNpc(hero);

		// Keine lebenden NPC ausrauben! Ausser wenn sie am Boden liegen.
		
		if (targetNpc.attribute[ATR_HITPOINTS] <= 0 || Npc_IsInState(targetNpc, ZS_Unconscious)) {
			// Transfer Target inventory into Ours
			B_ClearRuneInv(targetNpc);
			Ninja_Quickloot_LootNpc(targetNpc, cHero);
		 };
	};
	
	if (Hlp_Is_oCItem(her.focus_vob)) {
		Ninja_Quickloot_TakeOrStealItem(hero, her.focus_vob);
	};

	if (Hlp_Is_oCMobContainer(her.focus_vob)) {
		if (Hlp_Is_oCMobLockable(her.focus_vob)) {
			var oCMobLockable lockable; lockable = _^(her.focus_vob);
			const int _oCMobLockable_bitfield_locked = ((1 <<  1) - 1) << 0;
			if (lockable.bitfield & _oCMobLockable_bitfield_locked) { return; };
		};
		Ninja_Quickloot_LootContainer(hero, her.focus_vob);
	};
};

/// Init-function called by Ninja
func void Ninja_Quickloot_Init_Internal() {
	MEM_Info(ConcatStrings(ConcatStrings("Initialize ", NINJA_QUICKLOOT_VERSION), "."));
	LeGo_MergeFlags(LeGo_FrameFunctions);
	
	
	Ninja_Quickloot_Print_Font = "Ninja_QuickLoot_Font_DE.tga";
	// var zCPar_Symbol symb;
	// if (MEM_FindParserSymbol("TEXT_FONT_DEFAULT") != -1) {
	// 	symb = _^(MEM_GetSymbol("TEXT_FONT_DEFAULT"));
	// 	Ninja_Quickloot_Print_Font = MEM_ReadString(symb.content);
	// } else {
	// 	if (MEM_FindParserSymbol("TEXT_FONT_10") != -1) {
	// 		symb = _^(MEM_GetSymbol("TEXT_FONT_10"));
	// 		Ninja_Quickloot_Print_Font = MEM_ReadString(symb.content);
	// 	} else {
	// 		if (MEM_FindParserSymbol("FONT_ScreenSmall") != -1) {
	// 			symb = _^(MEM_GetSymbol("FONT_ScreenSmall"));
	// 			Ninja_Quickloot_Print_Font = MEM_ReadString(symb.content);
	// 		};
	// 	};
	// };
	FF_ApplyOnce(Ninja_Quickloot_Loot);
    MEM_Info(ConcatStrings(NINJA_QUICKLOOT_VERSION, " was initialized successfully."));
};
