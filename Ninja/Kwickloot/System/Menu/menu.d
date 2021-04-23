const string Kwickloot_KEYNAME = "keyKwickloot";

INSTANCE MENUITEM_KEY_KWICKLOOT(C_MENU_ITEM_DEF)
{
	text[0]			=	"(Patch) Kwickloot";
	text[1]			=   "Taste ENTF zum Löschen und RETURN zum definieren"; // Kommentar
	posx			=	ctrl_sp1_1;		posy	=	ctrl_y_start + ctrl_y_step * 16 + CTRL_GROUP4;

	onSelAction[0]	=	SEL_ACTION_EXECCOMMANDS;
	onSelAction_S[0]= 	"RUN MENUITEM_INP_KWICKLOOT";
	fontName 	= 	MENU_FONT_SMALL;
	flags = flags;
};

INSTANCE MENUITEM_INP_KWICKLOOT(C_MENU_ITEM_DEF)
{
	type		= 	MENU_ITEM_INPUT;
	text[1] 	=   "Gewünschte Taste betätigen.";

	posx		=	ctrl_sp1_2;		posy	=	ctrl_y_start + ctrl_y_step * 16 + CTRL_GROUP4;
	dimx		=	ctrl_dimx;
	dimy		=	300;
	fontName 	= 	MENU_FONT_SMALL;
	backPic		=	MENU_KBDINPUT_BACK_PIC;

	onChgSetOption 			= Kwickloot_KEYNAME;
	onChgSetOptionSection 	= "KEYS";
	flags		=	flags & ~IT_SELECTABLE;
};
