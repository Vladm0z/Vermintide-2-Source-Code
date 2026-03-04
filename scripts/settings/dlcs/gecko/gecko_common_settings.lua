-- chunkname: @scripts/settings/dlcs/gecko/gecko_common_settings.lua

local var_0_0 = DLCSettings.gecko

var_0_0.network_lookups = {
	keep_decoration_paintings = "Paintings"
}
var_0_0.keep_decoration_file_names = {
	"scripts/settings/paintings_01"
}

local var_0_1 = "resource_packages/keep_paintings/keep_paintings_inn_level_sounds_01"

var_0_0.extra_level_packages = {
	inn_level = {
		var_0_1
	},
	inn_level_celebrate = {
		var_0_1
	},
	inn_level_halloween = {
		var_0_1
	},
	inn_level_skulls = {
		var_0_1
	},
	inn_level_sonnstill = {
		var_0_1
	},
	keep_base = {
		var_0_1
	}
}
