/*
 * Replace first occurrence of needle in haystack and replace it
 */
func string Kwickloot_STR_ReplaceOnce(var string haystack, var string needle, var string replace) {
    var zString zSh; zSh = _^(_@s(haystack));
    var zString zSn; zSn = _^(_@s(needle));
    if (!zSh.len) || (!zSn.len) {
        return haystack;
    };

    var int startPos; startPos = STR_IndexOf(haystack, needle);
    if (startPos == -1) {
        return haystack;
    };

    var string destStr; destStr = "";

    destStr = STR_Prefix(haystack, startPos);
    destStr = ConcatStrings(destStr, replace);
    destStr = ConcatStrings(destStr, STR_Substr(haystack, startPos+zSn.len, zSh.len-(startPos+zSn.len)));

    return destStr;
};


/*
 * Replace all occurrences of needle in haystack and replace them
 */
func string Kwickloot_STR_ReplaceAll(var string haystack, var string needle, var string replace) {
    var string before; before = "";
    while(!Hlp_StrCmp(haystack, before));
        before = haystack;
        haystack = Kwickloot_STR_ReplaceOnce(before, needle, replace);
    end;
    return haystack;
};

/*
 * Complement to STR_Prefix in Ikarus (from ScriptBin/strings.d)
 */
func string Kwickloot_STR_Postfix(var string str, var int off) {
    return STR_SubStr(str, off, STR_Len(str)-off);
};

/*
 * Convert hexadecimal to decimal (big endian) (from ScriptBin/strings.d)
 */
func int Kwickloot_hex2dec(var string hex) {
    var zString zStr; zStr = _^(_@s(hex));
    if (!zStr.len) {
        return 0;
    };

    // Remove 0x prefix and h postfix
    hex = STR_Lower(hex);
    if (Hlp_StrCmp(STR_Prefix(hex, 2), "0x")) {
        hex = STR_SubStr(hex, 2, zStr.len-2);
    } else if (Hlp_StrCmp(STR_Prefix(hex, 1), "#")) {
        hex = STR_SubStr(hex, 1, zStr.len-1);
    } else if (MEM_ReadByte(zStr.ptr+zStr.len-1) == /*h*/ 104) {
        hex = STR_Prefix(hex, zStr.len-1);
    };

    // Remove any spaces
    hex = Kwickloot_STR_ReplaceAll(hex, " ", "");

    // Check length
    if (zStr.len > 8) {
        MEM_Error("hex2dec: Hexadecimal number to big. Considering the last 4 bytes only.");
        hex = Kwickloot_STR_Postfix(hex, zStr.len-8);
    };

    // Iterate over all characters (from back to front)
    var int dec; dec = 0;
    repeat(i, zStr.len); var int i;
        dec += MEMINT_HexCharToInt(MEM_ReadByte(zStr.ptr+(zStr.len-1)-i)) << 4*i;
    end;

    return dec;
};

func int Kwickloot_ParseColor(var string color) {
    color = STR_Upper(color);

    if      (Hlp_StrCmp(color, "AQUA")    )  { return COL_Aqua;    }
    // else if (Hlp_StrCmp(color, "BLACK")) { } // Nah ...
    else if (Hlp_StrCmp(color, "BLUE")    )  { return COL_Blue;    }
    else if (Hlp_StrCmp(color, "FUCHSIA") )  { return COL_Fuchsia; }
    else if (Hlp_StrCmp(color, "GRAY")    )  { return COL_Gray;    }
    else if (Hlp_StrCmp(color, "GREEN")   )  { return COL_Green;   }
    else if (Hlp_StrCmp(color, "LIME")    )  { return COL_Lime;    }
    else if (Hlp_StrCmp(color, "MAROON")  )  { return COL_Maroon;  }
    else if (Hlp_StrCmp(color, "NAVY")    )  { return COL_Navy;    }
    else if (Hlp_StrCmp(color, "OLIVE")   )  { return COL_Olive;   }
    else if (Hlp_StrCmp(color, "PURPLE")  )  { return COL_Purple;  }
    else if (Hlp_StrCmp(color, "RED")     )  { return COL_Red;     }
    else if (Hlp_StrCmp(color, "SILVER")  )  { return COL_Silver;  }
    else if (Hlp_StrCmp(color, "TEAL")    )  { return COL_Teal;    }
    // else if (Hlp_StrCmp(color, "WHITE")) { } // Nah ...
    else if (Hlp_StrCmp(color, "YELLOW")  )  { return COL_Yellow;  };
    if (STR_Len(color) >= 6) {
        var int col;
        col = Kwickloot_hex2dec(color);
        if (col != 0) {
            col = col | (255<<24); // Set alpha = 255
            return col;
        };
    };

    return COL_Lime;
};