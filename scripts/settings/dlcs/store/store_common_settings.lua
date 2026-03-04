-- chunkname: @scripts/settings/dlcs/store/store_common_settings.lua

local var_0_0 = DLCSettings.store

var_0_0.interactions = {
	"store_access"
}
var_0_0.interactions_filenames = {
	"scripts/settings/store_interactions"
}
var_0_0.backend_interfaces = {
	peddler = {
		ignore_on_dedicated_server = true,
		playfab_file = "scripts/managers/backend_playfab/backend_interface_peddler_playfab",
		playfab_class = "BackendInterfacePeddlerPlayFab"
	}
}
var_0_0.backend_localizations = {
	peddler = {
		pl = "store_localization_pl",
		de = "store_localization_de",
		zh = "store_localization_zh",
		ru = "store_localization_ru",
		ja = "store_localization_ja",
		fr = "store_localization_fr",
		en = "store_localization_en",
		it = "store_localization_it",
		["br-pt"] = "store_localization_br-pt",
		es = "store_localization_es"
	}
}
