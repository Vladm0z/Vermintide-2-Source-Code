-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_pickup_settings.lua

DLCSettings.scorpion.pickups = {
	ammo = {
		ammo_throwing_axe_01_t2_magic_01 = {
			only_once = true,
			refill_amount = 1,
			type = "ammo",
			pickup_sound_event = "pickup_ammo",
			debug_pickup_category = "throwing_weapons",
			outline_distance = "small_pickup",
			spawn_weighting = 1e-06,
			unit_name = "units/weapons/player/wpn_dw_thrown_axe_01_t2/pup_dw_thrown_axe_01_t2_magic_01",
			unit_template_name = "limited_owned_pickup_projectile_unit",
			consumable_item = true,
			local_pickup_sound = true,
			hud_description = "interaction_ammunition_axe",
			can_interact_func = function(arg_1_0, arg_1_1, arg_1_2)
				local var_1_0 = ScriptUnit.has_extension(arg_1_0, "inventory_system")

				return var_1_0 and var_1_0:has_ammo_consuming_weapon_equipped("throwing_axe")
			end,
			outline_available_func = function(arg_2_0)
				local var_2_0 = ScriptUnit.has_extension(arg_2_0, "inventory_system")

				return var_2_0 and var_2_0:has_ammo_consuming_weapon_equipped("throwing_axe")
			end
		},
		link_ammo_throwing_axe_01_t2_magic_01 = {
			only_once = true,
			refill_amount = 1,
			type = "ammo",
			pickup_sound_event = "pickup_ammo",
			debug_pickup_category = "throwing_weapons",
			outline_distance = "small_pickup",
			spawn_weighting = 1e-06,
			unit_name = "units/weapons/player/wpn_dw_thrown_axe_01_t2/pup_dw_thrown_axe_01_t2_magic_01",
			unit_template_name = "limited_owned_pickup_unit",
			consumable_item = true,
			local_pickup_sound = true,
			hud_description = "interaction_ammunition_axe",
			can_interact_func = function(arg_3_0, arg_3_1, arg_3_2)
				local var_3_0 = ScriptUnit.has_extension(arg_3_0, "inventory_system")

				return var_3_0 and var_3_0:has_ammo_consuming_weapon_equipped("throwing_axe")
			end,
			outline_available_func = function(arg_4_0)
				local var_4_0 = ScriptUnit.has_extension(arg_4_0, "inventory_system")

				return var_4_0 and var_4_0:has_ammo_consuming_weapon_equipped("throwing_axe")
			end
		}
	}
}
