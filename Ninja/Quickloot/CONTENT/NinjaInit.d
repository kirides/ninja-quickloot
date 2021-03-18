
/// Init-function called by Ninja
func void Ninja_Quickloot_Init() {
	// Initialize Ikarus
	MEM_InitAll();
	Ninja_Quickloot_Init_Internal();
};
