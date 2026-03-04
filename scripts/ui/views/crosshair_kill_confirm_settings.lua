-- chunkname: @scripts/ui/views/crosshair_kill_confirm_settings.lua

CrosshairKillConfirmSettingsGroups = table.enum("off", "all", "elites_above", "bosses_specials", "elites_specials", "specials_only")

local var_0_0 = table.enum("infantry", "elite", "special", "boss")
local var_0_1 = {
	[CrosshairKillConfirmSettingsGroups.off] = {},
	[CrosshairKillConfirmSettingsGroups.all] = {
		[var_0_0.infantry] = true,
		[var_0_0.elite] = true,
		[var_0_0.boss] = true,
		[var_0_0.special] = true
	},
	[CrosshairKillConfirmSettingsGroups.elites_above] = {
		[var_0_0.elite] = true,
		[var_0_0.boss] = true,
		[var_0_0.special] = true
	},
	[CrosshairKillConfirmSettingsGroups.bosses_specials] = {
		[var_0_0.boss] = true,
		[var_0_0.special] = true
	},
	[CrosshairKillConfirmSettingsGroups.elites_specials] = {
		[var_0_0.elite] = true,
		[var_0_0.special] = true
	},
	[CrosshairKillConfirmSettingsGroups.specials_only] = {
		[var_0_0.special] = true
	}
}
local var_0_2 = table.enum("kill", "kill_dot", "kill_weakpoint", "assist")
local var_0_3 = {
	[var_0_2.kill] = {
		255,
		243,
		21,
		21
	},
	[var_0_2.kill_dot] = {
		255,
		228,
		139,
		255
	},
	[var_0_2.kill_weakpoint] = {
		255,
		230,
		168,
		0
	},
	[var_0_2.assist] = {
		255,
		0,
		162,
		255
	}
}
local var_0_4 = table.mirror_array_inplace({
	var_0_0.infantry,
	var_0_0.elite,
	var_0_0.boss,
	var_0_0.special
})
local var_0_5 = {
	head = true,
	weakspot = true
}
local var_0_6 = {
	[var_0_0.infantry] = "style_4",
	[var_0_0.elite] = "style_3",
	[var_0_0.special] = "style_2",
	[var_0_0.boss] = "style_5"
}
local var_0_7 = {
	style_1 = "kill_confirm_01",
	style_2 = "kill_confirm_02",
	style_5 = "kill_confirm_05",
	style_3 = "kill_confirm_03",
	style_4 = "kill_confirm_04"
}

return {
	kill_confirm_enemy_types = var_0_0,
	kill_confirm_group_settings = var_0_1,
	kill_confirm_types = var_0_2,
	kill_confirm_type_colors = var_0_3,
	kill_confirm_enemy_prio = var_0_4,
	kill_confirm_weakspot_zones = var_0_5,
	kill_confirm_enemy_type_widget_map = var_0_6,
	kill_confirm_styles = var_0_7
}
