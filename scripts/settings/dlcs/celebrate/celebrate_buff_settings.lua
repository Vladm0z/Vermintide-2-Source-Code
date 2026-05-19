-- chunkname: @scripts/settings/dlcs/celebrate/celebrate_buff_settings.lua

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_1 = DLCSettings.celebrate

local function var_0_2()
	return Managers.player.is_server
end

local function var_0_3(arg_2_0)
	local var_2_0 = Managers.player:owner(arg_2_0)

	return var_2_0 and not var_2_0.remote
end

local function var_0_4(arg_3_0)
	local var_3_0 = Managers.player:owner(arg_3_0)

	return var_3_0 and var_3_0.bot_player
end

var_0_1.buff_templates = {
	celebrate_group = {
		buffs = {
			{
				max_stacks = 1,
				name = "celebrate_group",
				apply_buff_func = "hot_joined"
			}
		}
	},
	beer_bottle_pickup_cooldown = {
		buffs = {
			{
				max_stacks = 1,
				name = "beer_bottle_pickup_cooldown",
				duration = 2.5
			}
		}
	},
	hinder_career_ability = {
		buffs = {
			{
				duration = 2.1,
				name = "hinder_career_ability",
				perks = {
					var_0_0.disable_career_ability
				}
			}
		}
	},
	intoxication_base = {
		buffs = {
			{
				max_stacks = 1,
				name = "intoxication_base",
				update_func = "update_intoxication_level",
				remove_buff_func = "remove_intoxication_base"
			}
		}
	},
	intoxication_stagger = {
		buffs = {
			{
				duration = 2.5,
				name = "intoxication_stagger",
				max_stacks = 1,
				refresh_durations = true,
				perks = {
					var_0_0.intoxication_stagger
				}
			}
		}
	},
	increase_intoxication_level = {
		activation_effect = "fx/screenspace_drink_01",
		buffs = {
			{
				effect_buff = "intoxication_effect",
				name = "increase_intoxication_level",
				apply_buff_func = "increase_intoxication_level",
				base_buff = "intoxication_base"
			},
			{
				buff_to_add = "intoxication_stagger",
				name = "add_intoxication_stagger",
				apply_buff_func = "add_buff"
			},
			{
				buff_to_add = "beer_bottle_pickup_cooldown",
				name = "add_intoxication_pickup_cooldown",
				apply_buff_func = "add_buff"
			}
		}
	},
	intoxication_effect_vfx = {
		buffs = {
			{
				refresh_durations = true,
				name = "intoxication_effect_vfx",
				continuous_effect = "fx/screenspace_drunken_lens_01",
				max_stacks = 1,
				duration = 30
			}
		}
	},
	intoxication_effect_max_stacks_vfx = {
		buffs = {
			{
				refresh_durations = true,
				name = "intoxication_effect_max_stacks_vfx",
				continuous_effect = "fx/screenspace_drunken_lens_05",
				max_stacks = 1,
				duration = 30
			}
		}
	},
	intoxication_effect = {
		buffs = {
			{
				remove_buff_func = "end_intoxication_effect",
				name = "intoxication_effect",
				duration = 30,
				continuous_effect = "fx/screenspace_drunken_lens_01",
				max_stacks = 3,
				icon = "buff_icon_mutator_icon_drunk",
				priority_buff = true,
				refresh_durations = true
			},
			{
				refresh_durations = true,
				name = "intoxication_effect_bloody_mess",
				max_stacks = 1,
				duration = 30,
				perks = {
					var_0_0.bloody_mess
				}
			},
			{
				refresh_durations = true,
				name = "intoxication_effect_drunk_stagger",
				max_stacks = 1,
				duration = 30,
				perks = {
					var_0_0.drunk_stagger
				}
			},
			{
				name = "intoxication_power_level",
				multiplier = 0.1,
				stat_buff = "power_level",
				refresh_durations = true,
				max_stacks = 3,
				duration = 30
			},
			{
				name = "intoxication_critical_hit_chance",
				multiplier = 0.15,
				stat_buff = "critical_strike_chance",
				refresh_durations = true,
				max_stacks = 3,
				duration = 30
			},
			{
				name = "intoxication_cooldown_regen_increase",
				multiplier = 1.5,
				stat_buff = "cooldown_regen",
				refresh_durations = true,
				max_stacks = 3,
				duration = 30
			},
			{
				max_stacks = 3,
				name = "drunk_attack_speed_slowdown",
				stat_buff = "attack_speed",
				multiplier = 0.02
			}
		}
	},
	falling_down_effect = {
		deactivation_effect = "fx/screenspace_hungover_01",
		activation_effect = "fx/screenspace_hungover_01",
		buffs = {
			{
				name = "falling_down_attack_speed_slowdown",
				stat_buff = "attack_speed",
				continuous_effect = "fx/screenspace_drink_looping",
				max_stacks = 1,
				remove_buff_func = "remove_falling_down_effect",
				multiplier = -0.5,
				duration = 5,
				perks = {
					var_0_0.falling_down
				}
			},
			{
				apply_buff_func = "apply_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "falling_down_decrease_speed",
				duration = 5,
				remove_buff_func = "remove_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 1,
				max_stacks = 1,
				update_func = "update_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				apply_buff_func = "apply_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "falling_down_decrease_crouch_speed",
				duration = 5,
				remove_buff_func = "remove_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 1,
				max_stacks = 1,
				update_func = "update_charging_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				apply_buff_func = "apply_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "falling_down_decrease_walk_speed",
				duration = 5,
				remove_buff_func = "remove_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 1,
				max_stacks = 1,
				update_func = "update_charging_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	hungover_effect = {
		activation_effect = "fx/screenspace_hungover_01",
		buffs = {
			{
				continuous_effect = "fx/screenspace_hungover_lens_01",
				name = "hungover_effect",
				debuff = true,
				max_stacks = 3,
				icon = "debuff_icon_mutator_icon_drunk",
				priority_buff = true
			},
			{
				max_stacks = 3,
				name = "hungover_effect_stagger",
				perks = {
					var_0_0.hungover_stagger
				}
			},
			{
				max_stacks = 3,
				name = "hungover_attack_speed_slowdown",
				stat_buff = "attack_speed",
				multiplier = -0.05
			},
			{
				max_stacks = 3,
				name = "hungover_regen_increase",
				stat_buff = "fatigue_regen",
				multiplier = -0.2
			},
			{
				max_stacks = 1,
				name = "hungover_effect_perk",
				perks = {
					var_0_0.hungover
				}
			}
		}
	}
}
var_0_1.buff_function_templates = {
	update_intoxication_level = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		if not var_0_3(arg_4_0) or var_0_4(arg_4_0) then
			return
		end

		local var_4_0 = ScriptUnit.extension(arg_4_0, "status_system")
		local var_4_1 = ScriptUnit.extension(arg_4_0, "buff_system")
		local var_4_2 = ScriptUnit.extension(arg_4_0, "career_system")
		local var_4_3 = ScriptUnit.extension(arg_4_0, "inventory_system")
		local var_4_4 = ScriptUnit.extension_input(arg_4_0, "dialogue_system")
		local var_4_5 = var_4_0:intoxication_level()

		if not arg_4_1.intoxication_stack_ids then
			arg_4_1.intoxication_stack_ids = {}
		end

		if not arg_4_1.intoxication_vfx_stack_ids then
			arg_4_1.intoxication_vfx_stack_ids = {}
		end

		if not arg_4_1.intoxication_vfx_max_stack_ids then
			arg_4_1.intoxication_vfx_max_stack_ids = {}
		end

		if not arg_4_1.hungover_stack_ids then
			arg_4_1.hungover_stack_ids = {}
		end

		local var_4_6 = arg_4_2.t

		if not var_4_1:has_buff_perk("falling_down") and var_4_5 > 0 and var_4_5 > #arg_4_1.intoxication_stack_ids then
			if var_4_2 and var_4_2:current_ability_paused() then
				var_4_2:start_activated_ability_cooldown()
			end

			local var_4_7 = var_4_5 - #arg_4_1.intoxication_stack_ids

			for iter_4_0 = 1, var_4_7 do
				local var_4_8 = var_4_1:add_buff("intoxication_effect")

				arg_4_1.intoxication_stack_ids[#arg_4_1.intoxication_stack_ids + 1] = var_4_8
			end

			if var_4_5 >= 3 then
				for iter_4_1 = 1, #arg_4_1.intoxication_vfx_stack_ids do
					local var_4_9 = arg_4_1.intoxication_vfx_stack_ids[iter_4_1]

					var_4_1:remove_buff(var_4_9)
				end

				table.clear(arg_4_1.intoxication_vfx_stack_ids)

				local var_4_10 = var_4_1:add_buff("intoxication_effect_max_stacks_vfx")

				arg_4_1.intoxication_vfx_max_stack_ids[#arg_4_1.intoxication_vfx_max_stack_ids + 1] = var_4_10
			else
				for iter_4_2 = 1, #arg_4_1.intoxication_vfx_max_stack_ids do
					local var_4_11 = arg_4_1.intoxication_vfx_max_stack_ids[iter_4_2]

					var_4_1:remove_buff(var_4_11)
				end

				table.clear(arg_4_1.intoxication_vfx_max_stack_ids)

				local var_4_12 = var_4_1:add_buff("intoxication_effect_vfx")

				arg_4_1.intoxication_vfx_stack_ids[#arg_4_1.intoxication_vfx_stack_ids + 1] = var_4_12
			end

			local var_4_13 = #arg_4_1.hungover_stack_ids

			for iter_4_3 = 1, var_4_13 do
				local var_4_14 = arg_4_1.hungover_stack_ids[iter_4_3]

				var_4_1:remove_buff(var_4_14)
			end

			table.clear(arg_4_1.hungover_stack_ids)

			if arg_4_1.shake_id then
				Managers.state.camera:stop_camera_effect_shake_event(arg_4_1.shake_id)

				arg_4_1.shake_id = nil
			end

			Managers.state.camera:set_mood("hangover_01", arg_4_1, false)
			Managers.state.camera:set_mood("drunk_01", arg_4_1, true)
		elseif var_4_5 < 0 and #arg_4_1.hungover_stack_ids ~= math.abs(var_4_5) then
			if var_4_2 and not var_4_2:current_ability_paused() then
				CharacterStateHelper.stop_weapon_actions(var_4_3, "hungover")
				CharacterStateHelper.stop_career_abilities(var_4_2, "hungover")
				var_4_2:reset_cooldown()
				var_4_2:set_activated_ability_cooldown_paused()
			end

			local var_4_15 = #arg_4_1.hungover_stack_ids

			if var_4_15 < math.abs(var_4_5) then
				local var_4_16 = math.abs(var_4_5)

				for iter_4_4 = #arg_4_1.hungover_stack_ids + 1, var_4_16 do
					local var_4_17 = var_4_1:add_buff("hungover_effect")

					arg_4_1.hungover_stack_ids[iter_4_4] = var_4_17
				end
			else
				local var_4_18 = var_4_15 - math.abs(var_4_5)

				for iter_4_5 = 1, var_4_18 do
					local var_4_19 = table.remove(arg_4_1.hungover_stack_ids, 1)

					var_4_1:remove_buff(var_4_19)
				end
			end

			for iter_4_6 = 1, #arg_4_1.intoxication_stack_ids do
				local var_4_20 = arg_4_1.intoxication_stack_ids[iter_4_6]

				var_4_1:remove_buff(var_4_20)
			end

			table.clear(arg_4_1.intoxication_stack_ids)

			for iter_4_7 = 1, #arg_4_1.intoxication_vfx_max_stack_ids do
				local var_4_21 = arg_4_1.intoxication_vfx_max_stack_ids[iter_4_7]

				var_4_1:remove_buff(var_4_21)
			end

			table.clear(arg_4_1.intoxication_vfx_max_stack_ids)

			for iter_4_8 = 1, #arg_4_1.intoxication_vfx_stack_ids do
				local var_4_22 = arg_4_1.intoxication_vfx_stack_ids[iter_4_8]

				var_4_1:remove_buff(var_4_22)
			end

			table.clear(arg_4_1.intoxication_vfx_stack_ids)

			local var_4_23 = FrameTable.alloc_table()

			var_4_4:trigger_dialogue_event("buff_wears_off", var_4_23)

			if not arg_4_1.shake_id then
				arg_4_1.shake_id = Managers.state.camera:camera_effect_shake_event("intoxication_after_effect", var_4_6)
			end

			Managers.state.camera:camera_effect_shake_event("hungover", var_4_6)
			Managers.state.camera:set_mood("drunk_01", arg_4_1, false)
			Managers.state.camera:set_mood("hangover_01", arg_4_1, true)

			local var_4_24 = "Play_eye_blink_hangover"
			local var_4_25 = ScriptUnit.has_extension(arg_4_0, "first_person_system")

			var_4_25:play_hud_sound_event(var_4_24)

			arg_4_1.next_blink_t = var_4_6 + 3

			local var_4_26 = "Play_player_celebrate_hangover"

			var_4_25:play_hud_sound_event(var_4_26)
		end

		if arg_4_1.delayed_vce_time and var_4_6 > arg_4_1.delayed_vce_time then
			local var_4_27 = arg_4_1.delayed_vce_event
			local var_4_28 = FrameTable.alloc_table()

			var_4_4:trigger_dialogue_event(var_4_27, var_4_28)

			arg_4_1.delayed_vce_time = nil
			arg_4_1.delayed_vce_event = nil
		end

		if arg_4_1.delayed_drink_vce_time and var_4_6 > arg_4_1.delayed_drink_vce_time then
			local var_4_29 = arg_4_1.delayed_drink_vce_event
			local var_4_30 = FrameTable.alloc_table()

			var_4_4:trigger_dialogue_event(var_4_29, var_4_30)

			arg_4_1.delayed_drink_vce_time = nil
			arg_4_1.delayed_drink_vce_event = nil
		end

		if not arg_4_1.shake_event_settings then
			local var_4_31 = {}
			local var_4_32 = CameraEffectSettings.shake.intoxication_after_effect

			var_4_31.event = var_4_32
			var_4_31.start_time = var_4_6
			var_4_31.seed = var_4_32.seed or Math.random(1, 100)
			arg_4_1.shake_event_settings = var_4_31
			arg_4_1.shake_functions = {
				calculate_perlin_value_func = function(arg_5_0, arg_5_1)
					local var_5_0 = 0
					local var_5_1 = arg_5_0.shake_event_settings.event
					local var_5_2 = var_5_1.persistance
					local var_5_3 = var_5_1.octaves

					for iter_5_0 = 0, var_5_3 do
						local var_5_4 = 2^iter_5_0
						local var_5_5 = var_5_2^iter_5_0

						var_5_0 = var_5_0 + arg_5_0.shake_functions.interpolated_noise_func(arg_5_0, arg_5_1 * var_5_4) * var_5_5
					end

					local var_5_6 = var_5_1.amplitude or 1
					local var_5_7 = var_0_1.fade_progress or 1

					return var_5_0 * var_5_6 * var_5_7
				end,
				interpolated_noise_func = function(arg_6_0, arg_6_1)
					local var_6_0 = math.floor(arg_6_1)
					local var_6_1 = arg_6_1 - var_6_0
					local var_6_2 = arg_6_0.shake_functions.smoothed_noise_func(arg_6_0, var_6_0)
					local var_6_3 = arg_6_0.shake_functions.smoothed_noise_func(arg_6_0, var_6_0 + 1)

					return math.lerp(var_6_2, var_6_3, var_6_1)
				end,
				smoothed_noise_func = function(arg_7_0, arg_7_1, arg_7_2)
					return arg_7_0.shake_functions.noise_func(arg_7_0, arg_7_1) / 2 + arg_7_0.shake_functions.noise_func(arg_7_0, arg_7_1 - 1) / 4 + arg_7_0.shake_functions.noise_func(arg_7_0, arg_7_1 + 1) / 4
				end,
				noise_func = function(arg_8_0, arg_8_1)
					local var_8_0, var_8_1 = Math.next_random(arg_8_1 + arg_8_0.shake_event_settings.seed)
					local var_8_2, var_8_3 = Math.next_random(var_8_0)

					return var_8_3 * 2 - 1
				end
			}
		end

		if arg_4_1.next_blink_t and var_4_6 > arg_4_1.next_blink_t then
			local var_4_33 = "Play_eye_blink_hangover"

			ScriptUnit.has_extension(arg_4_0, "first_person_system"):play_hud_sound_event(var_4_33)

			arg_4_1.next_blink_t = nil
		end

		if not arg_4_1.next_noise_t or var_4_6 > arg_4_1.next_noise_t then
			arg_4_1.next_noise_t = var_4_6 + 2

			local var_4_34 = arg_4_1.shake_functions.calculate_perlin_value_func(arg_4_1, var_4_6 - arg_4_1.shake_event_settings.start_time, arg_4_1.shake_event_settings)
			local var_4_35 = arg_4_1.shake_functions.calculate_perlin_value_func(arg_4_1, var_4_6 - arg_4_1.shake_event_settings.start_time + 10, arg_4_1.shake_event_settings)
			local var_4_36 = math.abs(math.sin(var_4_6 * math.pi * 0.5))
			local var_4_37 = math.abs(math.sin(var_4_6 * math.pi))
			local var_4_38 = math.sqrt(var_4_34 * var_4_34 + var_4_35 * var_4_35)

			assert(var_4_38 ~= 0, "trying to divide by zero in \"update_intoxication_level\" buff update function")

			local var_4_39 = var_4_34 / var_4_38
			local var_4_40 = var_4_35 / var_4_38
			local var_4_41 = math.abs(math.lerp(var_4_39, var_4_40, var_4_36)) * math.sign(var_4_5) * 200 + math.sign(var_4_5) * 200 * (math.abs(var_4_5) - 1)
			local var_4_42 = math.abs(math.lerp(var_4_39, var_4_40, var_4_37)) * math.sign(var_4_5) * 200 + math.sign(var_4_5) * 200 * (math.abs(var_4_5) - 1)
			local var_4_43 = Managers.world:wwise_world(arg_4_3)

			WwiseWorld.set_global_parameter(var_4_43, "player_intoxication_level", var_4_41)
			WwiseWorld.set_global_parameter(var_4_43, "player_intoxication_level_2", var_4_42)
		end
	end,
	remove_intoxication_base = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		local var_9_0 = Managers.world:wwise_world(arg_9_3)

		WwiseWorld.set_global_parameter(var_9_0, "player_intoxication_level", 0)
		WwiseWorld.set_global_parameter(var_9_0, "player_intoxication_level_2", 0)

		if arg_9_1.shake_id then
			Managers.state.camera:stop_camera_effect_shake_event(arg_9_1.shake_id)

			arg_9_1.shake_id = nil
		end
	end,
	check_celebrate_buff = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		if not var_0_3(arg_10_0) or var_0_4(arg_10_0) then
			return
		end

		if ScriptUnit.extension(arg_10_0, "buff_system"):has_buff_perk("hungover") then
			local var_10_0 = ScriptUnit.extension(arg_10_0, "status_system")

			if var_10_0:intoxication_level() < 0 then
				var_10_0:invert_intoxication_level()

				local var_10_1 = Managers.time:time("game")

				Managers.state.camera:camera_effect_shake_event("intoxication", var_10_1)

				local var_10_2 = Managers.state.network
				local var_10_3 = var_10_2:unit_game_object_id(arg_10_0)

				var_10_2.network_transmit:send_rpc_server("rpc_request_heal_wounds", var_10_3)
			end

			local var_10_4 = "Play_player_celebrate_drunk"

			ScriptUnit.has_extension(arg_10_0, "first_person_system"):play_hud_sound_event(var_10_4)
		end
	end,
	increase_intoxication_level = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		if not var_0_3(arg_11_0) or var_0_4(arg_11_0) then
			return
		end

		local var_11_0 = ScriptUnit.extension(arg_11_0, "status_system")
		local var_11_1 = ScriptUnit.extension(arg_11_0, "buff_system")

		if var_11_1:has_buff_perk("falling_down") then
			return
		end

		local var_11_2 = arg_11_1.template.base_buff
		local var_11_3 = var_11_1:get_non_stacking_buff(var_11_2)
		local var_11_4 = var_11_0:intoxication_level()

		if var_11_4 < 0 then
			var_11_0:invert_intoxication_level()

			if var_11_3 then
				var_11_3.delayed_vce_time = arg_11_2.t + 1
				var_11_3.delayed_vce_event = "buff_begins_from_sick"
			end
		else
			var_11_0:add_intoxication_level(1)

			if var_11_3 then
				var_11_3.delayed_vce_time = arg_11_2.t + 1
				var_11_3.delayed_vce_event = "buff_begins"
			end

			if var_11_4 >= 3 then
				var_11_1:add_buff("falling_down_effect")
			end
		end

		local var_11_5 = Managers.time:time("game")

		Managers.state.camera:camera_effect_shake_event("intoxication", var_11_5)

		local var_11_6 = Managers.state.network
		local var_11_7 = var_11_6:unit_game_object_id(arg_11_0)

		var_11_6.network_transmit:send_rpc_server("rpc_request_heal_wounds", var_11_7)

		var_11_3.delayed_drink_vce_time = arg_11_2.t + 1.6
		var_11_3.delayed_drink_vce_event = "player_drank_vce"

		local var_11_8 = "Play_player_celebrate_drunk"

		ScriptUnit.has_extension(arg_11_0, "first_person_system"):play_hud_sound_event(var_11_8)

		if var_0_2() then
			local var_11_9 = "celebrate_group"
			local var_11_10 = NetworkLookup.group_buff_templates[var_11_9]

			Managers.state.entity:system("buff_system"):rpc_add_group_buff(nil, var_11_10, 1)
		end
	end,
	end_intoxication_effect = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = ScriptUnit.extension(arg_12_0, "status_system")

		if var_12_0:intoxication_level() > 0 then
			var_12_0:invert_intoxication_level()
		end
	end,
	remove_falling_down_effect = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		local var_13_0 = ScriptUnit.extension(arg_13_0, "status_system")

		if var_13_0:intoxication_level() > 0 then
			var_13_0:invert_intoxication_level()
		end

		local var_13_1 = Managers.state.network
		local var_13_2 = var_13_1:unit_game_object_id(arg_13_0)

		var_13_1.network_transmit:send_rpc_server("rpc_request_knock_down", var_13_2)
	end,
	add_buff = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		local var_14_0 = ScriptUnit.extension(arg_14_0, "buff_system")
		local var_14_1 = arg_14_1.template.buff_to_add

		var_14_0:add_buff(var_14_1)
	end,
	hot_joined = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		local var_15_0 = ScriptUnit.extension(arg_15_0, "status_system")

		if var_15_0:intoxication_level() == 0 then
			ScriptUnit.extension(arg_15_0, "buff_system"):add_buff("intoxication_base")
			var_15_0:add_intoxication_level(1)
			var_15_0:invert_intoxication_level()
		end
	end
}
var_0_1.group_buff_templates = {
	celebrate_group = {
		buff_per_instance = "celebrate_group",
		side_name = "heroes"
	}
}
var_0_1.add_sub_buffs_to_core_buffs = {
	{
		buff_name = "damage_boost_potion",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "speed_boost_potion",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "cooldown_reduction_potion",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "invulnerability_potion",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "damage_boost_potion_increased",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "speed_boost_potion_increased",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "cooldown_reduction_potion_increased",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "invulnerability_potion_increased",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "damage_boost_potion_reduced",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "speed_boost_potion_reduced",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "cooldown_reduction_potion_reduced",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	},
	{
		buff_name = "invulnerability_potion_reduced",
		sub_buff_to_add = {
			apply_buff_func = "check_celebrate_buff",
			name = "check celebrate"
		}
	}
}
