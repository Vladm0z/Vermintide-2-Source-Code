-- chunkname: @scripts/ui/views/crosshair_kill_confirm_settings.lua

CrosshairKillConfirmSettingsGroups = table.enum("off", "all", "elites_above", "bosses_specials", "elites_specials", "specials_only")

local enum = table.enum("infantry", "elite", "special", "boss")
local tbl = {
	[CrosshairKillConfirmSettingsGroups.off] = {},
	[CrosshairKillConfirmSettingsGroups.all] = {
		[enum.infantry] = true,
		[enum.elite] = true,
		[enum.boss] = true,
		[enum.special] = true
	},
	[CrosshairKillConfirmSettingsGroups.elites_above] = {
		[enum.elite] = true,
		[enum.boss] = true,
		[enum.special] = true
	},
	[CrosshairKillConfirmSettingsGroups.bosses_specials] = {
		[enum.boss] = true,
		[enum.special] = true
	},
	[CrosshairKillConfirmSettingsGroups.elites_specials] = {
		[enum.elite] = true,
		[enum.special] = true
	},
	[CrosshairKillConfirmSettingsGroups.specials_only] = {
		[enum.special] = true
	}
}
local enum_2 = table.enum("kill", "kill_dot", "kill_weakpoint", "assist")
local tbl_2 = {
	[enum_2.kill] = {
		255,
		243,
		21,
		21
	},
	[enum_2.kill_dot] = {
		255,
		228,
		139,
		255
	},
	[enum_2.kill_weakpoint] = {
		255,
		230,
		168,
		0
	},
	[enum_2.assist] = {
		255,
		0,
		162,
		255
	}
}
local mirror_array_inplace = table.mirror_array_inplace({
	enum.infantry,
	enum.elite,
	enum.boss,
	enum.special
})
local tbl_3 = {
	head = true,
	weakspot = true
}
local tbl_4 = {
	[enum.infantry] = "style_4",
	[enum.elite] = "style_3",
	[enum.special] = "style_2",
	[enum.boss] = "style_5"
}
local tbl_5 = {
	style_1 = "kill_confirm_01",
	style_2 = "kill_confirm_02",
	style_5 = "kill_confirm_05",
	style_3 = "kill_confirm_03",
	style_4 = "kill_confirm_04"
}

return {
	kill_confirm_enemy_types = enum,
	kill_confirm_group_settings = tbl,
	kill_confirm_types = enum_2,
	kill_confirm_type_colors = tbl_2,
	kill_confirm_enemy_prio = mirror_array_inplace,
	kill_confirm_weakspot_zones = tbl_3,
	kill_confirm_enemy_type_widget_map = tbl_4,
	kill_confirm_styles = tbl_5
}
