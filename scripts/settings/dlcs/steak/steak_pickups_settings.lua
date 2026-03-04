-- chunkname: @scripts/settings/dlcs/steak/steak_pickups_settings.lua

DLCSettings.steak.pickups = {
	crater_painting = {
		crater_painting = {
			only_once = true,
			individual_pickup = true,
			hide_on_pickup = true,
			type = "crater_painting",
			pickup_sound_event = "hud_pickup_painting_piece",
			debug_pickup_category = "special",
			spawn_weighting = 1,
			unit_name = "units/weapons/player/pup_crater_painting/pup_crater_painting",
			local_pickup_sound = true,
			hud_description = "interaction_crater_painting",
			can_spawn_func = function (arg_1_0, arg_1_1)
				return true
			end
		}
	},
	crater_pendant = {
		crater_pendant = {
			only_once = true,
			individual_pickup = true,
			hide_on_pickup = true,
			type = "crater_pendant",
			pickup_sound_event = "hud_pickup_painting_piece",
			debug_pickup_category = "special",
			spawn_weighting = 1,
			unit_name = "units/weapons/player/pup_cameo_pendant/pup_crater_cameo_pendant",
			local_pickup_sound = true,
			hud_description = "crater_pendant",
			can_spawn_func = function (arg_2_0, arg_2_1)
				return true
			end
		}
	}
}
