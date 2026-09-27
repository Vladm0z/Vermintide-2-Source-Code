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
			on_pick_up_func = function (arg_1_0, arg_1_1, arg_1_2)
				-- function 1
				ScriptUnit.extension(arg_1_1, "buff_system"):add_buff("intoxication_base")

				local player = Managers.player
				local local_player = player:local_player()
				local statistics_db = player:statistics_db()
				local stats_id = local_player:stats_id()

				statistics_db:increment_stat(stats_id, "crawl_total_ales_drunk")
			end,
			can_interact_func = function (arg_2_0, arg_2_1, arg_2_2)
				-- function 2
				local extension = ScriptUnit.extension(arg_2_0, "buff_system")
				local has_buff_type = extension:has_buff_type("beer_bottle_pickup_cooldown")
				local has_buff_perk = extension:has_buff_perk("falling_down")

				return not not has_buff_type or not has_buff_perk
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
			on_pick_up_func = function (arg_3_0, arg_3_1, arg_3_2)
				-- function 3
				local extension = ScriptUnit.extension(arg_3_1, "buff_system")

				extension:add_buff("intoxication_base")
				extension:add_buff("hinder_career_ability")
			end,
			can_interact_func = function (arg_4_0, arg_4_1, arg_4_2)
				-- function 4
				local extension = ScriptUnit.extension(arg_4_0, "buff_system")
				local has_buff_type = extension:has_buff_type("beer_bottle_pickup_cooldown")
				local has_buff_perk = extension:has_buff_perk("falling_down")

				return not not has_buff_type or not has_buff_perk
			end
		}
	}
}
