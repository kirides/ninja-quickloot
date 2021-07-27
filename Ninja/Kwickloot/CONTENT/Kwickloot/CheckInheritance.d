func int Kwickloot_CheckInheritance(var int objPtr, var int classDef) {
	if (!objPtr) || (!classDef) { return 0; };

    const int zCClassDef_baseClassDef_offset = 60;  //0x003C

    // Iterate over base classes
    var int curClassDef; curClassDef = MEM_GetClassDef(objPtr);
    while((curClassDef) && (curClassDef != classDef));
        curClassDef = MEM_ReadInt(curClassDef+zCClassDef_baseClassDef_offset);
    end;

    return (curClassDef == classDef);
};

func int Kwickloot_Hlp_Is_oCMobLockable (var int objPtr) { return +Kwickloot_CheckInheritance(objPtr, Kwickloot_ClassDef_oCMobLockable);  };
func int Kwickloot_Hlp_Is_oCNpc         (var int objPtr) { return +Kwickloot_CheckInheritance(objPtr, Kwickloot_ClassDef_oCNpc);          };
func int Kwickloot_Hlp_Is_oCItem        (var int objPtr) { return +Kwickloot_CheckInheritance(objPtr, Kwickloot_ClassDef_oCItem);         };
func int Kwickloot_Hlp_Is_oCMobContainer(var int objPtr) { return +Kwickloot_CheckInheritance(objPtr, Kwickloot_ClassDef_oCMobContainer); };
func int Kwickloot_Hlp_Is_oCMobInter    (var int objPtr) { return +Kwickloot_CheckInheritance(objPtr, Kwickloot_ClassDef_oCMobInter);     };
