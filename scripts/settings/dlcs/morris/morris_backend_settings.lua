-- chunkname: @scripts/settings/dlcs/morris/morris_backend_settings.lua

local var_0_0 = DLCSettings.morris

var_0_0.backend_interfaces = {
	deus = {
		ignore_on_dedicated_server = true,
		playfab_file = "scripts/managers/backend_playfab/backend_interface_deus_playfab",
		playfab_class = "BackendInterfaceDeusPlayFab"
	}
}
var_0_0.offline_backend_title_data = {
	"scripts/settings/offline_backend_playfab/title_internal_data/deus_player_setup",
	"scripts/settings/offline_backend_playfab/title_internal_data/deus_roll_over_settings",
	"scripts/settings/offline_backend_playfab/title_internal_data/earn_chests_on_defeat_data"
}
