-- chunkname: @scripts/settings/dlcs/gecko/gecko_common_settings.lua

local gecko = DLCSettings.gecko

gecko.network_lookups = {
	keep_decoration_paintings = "Paintings"
}
gecko.keep_decoration_file_names = {
	"scripts/settings/paintings_01"
}

local str = "resource_packages/keep_paintings/keep_paintings_inn_level_sounds_01"

gecko.extra_level_packages = {
	inn_level = {
		str
	},
	inn_level_celebrate = {
		str
	},
	inn_level_halloween = {
		str
	},
	inn_level_skulls = {
		str
	},
	inn_level_sonnstill = {
		str
	},
	keep_base = {
		str
	}
}
