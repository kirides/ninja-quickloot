/// Menu-Init-function called by Ninja (as soon as the main menu opens)
func void Ninja_Quickloot_Menu(var int menuPtr) {
	// Initialize Ikarus
	const int once = 1;
	if (once) {
		MEM_InitAll();
		Ninja_Quickloot_Init_Options();
		once = 0;
	};
};

/// Init-function called by Ninja
func void Ninja_Quickloot_Init() {
	// Initialize Ikarus
	MEM_InitAll();
	Ninja_Quickloot_Init_Internal();
};
