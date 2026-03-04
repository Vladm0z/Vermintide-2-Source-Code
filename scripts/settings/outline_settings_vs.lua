-- chunkname: @scripts/settings/outline_settings_vs.lua

OutlineSettingsVS = OutlineSettingsVS or {}
OutlineSettingsVS.colors = {
	ally = {
		pulse_multiplier = 50,
		pulsate = false,
		color = {
			255,
			72,
			95,
			143
		}
	},
	hero_healthy = {
		pulse_multiplier = 50,
		pulsate = false,
		color = {
			255,
			33,
			106,
			34
		}
	},
	hero_hurt = {
		pulse_multiplier = 50,
		pulsate = false,
		color = {
			255,
			177,
			144,
			31
		}
	},
	hero_dying = {
		pulse_multiplier = 15,
		pulsate = false,
		color = {
			255,
			139,
			0,
			0
		}
	}
}
OutlineSettingsVS.templates = {
	horde_ability = {
		priority = 15,
		method = "ai_alive",
		outline_color = OutlineSettingsVS.colors.ally,
		flag = OutlineSettings.flags.non_wall_occluded
	}
}

for iter_0_0, iter_0_1 in pairs(OutlineSettingsVS.colors) do
	iter_0_1.name = iter_0_0
end
