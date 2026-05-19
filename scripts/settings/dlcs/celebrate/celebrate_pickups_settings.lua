-- chunkname: @scripts/settings/dlcs/celebrate/celebrate_pickups_settings.lua

DLCSettings.celebrate.pickups = {
	potions = {
		beer_bottle = {
			only_once = true,
			item_description = "interaction_beer",
			spawn_weighting = 1e-06,
			debug_pickup_category = "consumables",
			pickup_sound_event = "pickup_potion",
			consumable_item = true,
			item_name = "wpn_beer_bottle",
			unit_name = "units/weapons/player/pup_ale/pup_ale",
			type = "inventory_item",
			slot_name = "slot_level_event",
			wield_on_pickup = true,
			local_pickup_sound = true,
			hud_description = "interaction_beer",
			action_on_wield = {
				action = "action_one",
				sub_action = "default"
			},
			on_pick_up_func = function(arg_1_0, arg_1_1, arg_1_2)
				ScriptUnit.extension(arg_1_1, "buff_system"):add_buff("intoxication_base")

				local var_1_0 = Managers.player
				local var_1_1 = var_1_0:local_player()
				local var_1_2 = var_1_0:statistics_db()
				local var_1_3 = var_1_1:stats_id()

				var_1_2:increment_stat(var_1_3, "crawl_total_ales_drunk")
			end,
			can_interact_func = function(arg_2_0, arg_2_1, arg_2_2)
				local var_2_0 = ScriptUnit.extension(arg_2_0, "buff_system")
				local var_2_1 = var_2_0:has_buff_type("beer_bottle_pickup_cooldown")
				local var_2_2 = var_2_0:has_buff_perk("falling_down")

				return not var_2_1 and not var_2_2
			end
		},
		beer_bottle_unique = {
			only_once = true,
			item_description = "interaction_beer",
			spawn_weighting = 1e-06,
			debug_pickup_category = "consumables",
			pickup_sound_event = "pickup_potion",
			consumable_item = true,
			item_name = "wpn_beer_bottle",
			unit_name = "units/weapons/player/pup_ale/pup_ale",
			type = "inventory_item",
			slot_name = "slot_level_event",
			wield_on_pickup = true,
			local_pickup_sound = true,
			hud_description = "interaction_beer",
			action_on_wield = {
				action = "action_one",
				sub_action = "default"
			},
			on_pick_up_func = function(arg_3_0, arg_3_1, arg_3_2)
				local var_3_0 = ScriptUnit.extension(arg_3_1, "buff_system")

				var_3_0:add_buff("intoxication_base")
				var_3_0:add_buff("hinder_career_ability")
			end,
			can_interact_func = function(arg_4_0, arg_4_1, arg_4_2)
				local var_4_0 = ScriptUnit.extension(arg_4_0, "buff_system")
				local var_4_1 = var_4_0:has_buff_type("beer_bottle_pickup_cooldown")
				local var_4_2 = var_4_0:has_buff_perk("falling_down")

				return not var_4_1 and not var_4_2
			end
		}
	}
}
