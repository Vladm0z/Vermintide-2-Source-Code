-- chunkname: @scripts/settings/dlcs/celebrate/celebrate_buff_settings.lua

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local celebrate = DLCSettings.celebrate

local function fn()
	-- function 1
	return Managers.player.is_server
end

local function fn_2(arg_2_0)
	-- function 2
	local owner = Managers.player:owner(arg_2_0)

	return not owner and not owner.remote
end

local function fn_3(arg_3_0)
	-- function 3
	local owner = Managers.player:owner(arg_3_0)

	return not owner and owner.bot_player
end

celebrate.buff_templates = {
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.disable_career_ability
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.intoxication_stagger
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.bloody_mess
				}
			},
			{
				refresh_durations = true,
				name = "intoxication_effect_drunk_stagger",
				max_stacks = 1,
				duration = 30,
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.drunk_stagger
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.falling_down
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.hungover_stagger
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.hungover
				}
			}
		}
	}
}
celebrate.buff_function_templates = {
	update_intoxication_level = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		if not fn_2(arg_4_0) and not fn_3(arg_4_0) then
			return
		end

		local extension = ScriptUnit.extension(arg_4_0, "status_system")
		local extension_2 = ScriptUnit.extension(arg_4_0, "buff_system")
		local extension_3 = ScriptUnit.extension(arg_4_0, "career_system")
		local extension_4 = ScriptUnit.extension(arg_4_0, "inventory_system")
		local extension_input = ScriptUnit.extension_input(arg_4_0, "dialogue_system")
		local intoxication_level = extension:intoxication_level()

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

		local t = arg_4_2.t

		if not (extension_2:has_buff_perk("falling_down") or not (intoxication_level > 0) or not (intoxication_level > #arg_4_1.intoxication_stack_ids)) then
			if not extension_3 and not extension_3:current_ability_paused() then
				extension_3:start_activated_ability_cooldown()
			end

			local num = intoxication_level - #arg_4_1.intoxication_stack_ids

			for i = 1, num do
				local add_buff = extension_2:add_buff("intoxication_effect")

				arg_4_1.intoxication_stack_ids[#arg_4_1.intoxication_stack_ids + 1] = add_buff
			end

			if intoxication_level >= 3 then
				for j = 1, #arg_4_1.intoxication_vfx_stack_ids do
					local var_4_9 = arg_4_1.intoxication_vfx_stack_ids[j]

					extension_2:remove_buff(var_4_9)
				end

				table.clear(arg_4_1.intoxication_vfx_stack_ids)

				local add_buff_2 = extension_2:add_buff("intoxication_effect_max_stacks_vfx")

				arg_4_1.intoxication_vfx_max_stack_ids[#arg_4_1.intoxication_vfx_max_stack_ids + 1] = add_buff_2
			else
				for k = 1, #arg_4_1.intoxication_vfx_max_stack_ids do
					local var_4_11 = arg_4_1.intoxication_vfx_max_stack_ids[k]

					extension_2:remove_buff(var_4_11)
				end

				table.clear(arg_4_1.intoxication_vfx_max_stack_ids)

				local add_buff_3 = extension_2:add_buff("intoxication_effect_vfx")

				arg_4_1.intoxication_vfx_stack_ids[#arg_4_1.intoxication_vfx_stack_ids + 1] = add_buff_3
			end

			local count = #arg_4_1.hungover_stack_ids

			for l = 1, count do
				local var_4_14 = arg_4_1.hungover_stack_ids[l]

				extension_2:remove_buff(var_4_14)
			end

			table.clear(arg_4_1.hungover_stack_ids)

			if not arg_4_1.shake_id then
				Managers.state.camera:stop_camera_effect_shake_event(arg_4_1.shake_id)

				arg_4_1.shake_id = nil
			end

			Managers.state.camera:set_mood("hangover_01", arg_4_1, false)
			Managers.state.camera:set_mood("drunk_01", arg_4_1, true)
		elseif not (not (intoxication_level < 0) or #arg_4_1.hungover_stack_ids == math.abs(intoxication_level)) then
			if not (not extension_3 and extension_3:current_ability_paused()) then
				CharacterStateHelper.stop_weapon_actions(extension_4, "hungover")
				CharacterStateHelper.stop_career_abilities(extension_3, "hungover")
				extension_3:reset_cooldown()
				extension_3:set_activated_ability_cooldown_paused()
			end

			local count_2 = #arg_4_1.hungover_stack_ids

			if not (count_2 < math.abs(intoxication_level)) then
				local abs = math.abs(intoxication_level)

				for i4 = #arg_4_1.hungover_stack_ids + 1, abs do
					local add_buff_4 = extension_2:add_buff("hungover_effect")

					arg_4_1.hungover_stack_ids[i4] = add_buff_4
				end
			else
				local num_2 = count_2 - math.abs(intoxication_level)

				for i5 = 1, num_2 do
					local remove = table.remove(arg_4_1.hungover_stack_ids, 1)

					extension_2:remove_buff(remove)
				end
			end

			for i6 = 1, #arg_4_1.intoxication_stack_ids do
				local var_4_20 = arg_4_1.intoxication_stack_ids[i6]

				extension_2:remove_buff(var_4_20)
			end

			table.clear(arg_4_1.intoxication_stack_ids)

			for i7 = 1, #arg_4_1.intoxication_vfx_max_stack_ids do
				local var_4_21 = arg_4_1.intoxication_vfx_max_stack_ids[i7]

				extension_2:remove_buff(var_4_21)
			end

			table.clear(arg_4_1.intoxication_vfx_max_stack_ids)

			for i8 = 1, #arg_4_1.intoxication_vfx_stack_ids do
				local var_4_22 = arg_4_1.intoxication_vfx_stack_ids[i8]

				extension_2:remove_buff(var_4_22)
			end

			table.clear(arg_4_1.intoxication_vfx_stack_ids)

			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_dialogue_event("buff_wears_off", alloc_table)

			if not arg_4_1.shake_id then
				arg_4_1.shake_id = Managers.state.camera:camera_effect_shake_event("intoxication_after_effect", t)
			end

			Managers.state.camera:camera_effect_shake_event("hungover", t)
			Managers.state.camera:set_mood("drunk_01", arg_4_1, false)
			Managers.state.camera:set_mood("hangover_01", arg_4_1, true)

			local str = "Play_eye_blink_hangover"
			local has_extension = ScriptUnit.has_extension(arg_4_0, "first_person_system")

			has_extension:play_hud_sound_event(str)

			arg_4_1.next_blink_t = t + 3

			local str_2 = "Play_player_celebrate_hangover"

			has_extension:play_hud_sound_event(str_2)
		end

		if not (not arg_4_1.delayed_vce_time and not (t > arg_4_1.delayed_vce_time)) then
			local delayed_vce_event = arg_4_1.delayed_vce_event
			local alloc_table_2 = FrameTable.alloc_table()

			extension_input:trigger_dialogue_event(delayed_vce_event, alloc_table_2)

			arg_4_1.delayed_vce_time = nil
			arg_4_1.delayed_vce_event = nil
		end

		if not (not arg_4_1.delayed_drink_vce_time and not (t > arg_4_1.delayed_drink_vce_time)) then
			local delayed_drink_vce_event = arg_4_1.delayed_drink_vce_event
			local alloc_table_3 = FrameTable.alloc_table()

			extension_input:trigger_dialogue_event(delayed_drink_vce_event, alloc_table_3)

			arg_4_1.delayed_drink_vce_time = nil
			arg_4_1.delayed_drink_vce_event = nil
		end

		if not arg_4_1.shake_event_settings then
			local tbl = {}
			local intoxication_after_effect = CameraEffectSettings.shake.intoxication_after_effect

			tbl.event = intoxication_after_effect
			tbl.start_time = t

			local seed = intoxication_after_effect.seed

			seed = seed or Math.random(1, 100)
			tbl.seed = seed
			arg_4_1.shake_event_settings = tbl
			arg_4_1.shake_functions = {
				calculate_perlin_value_func = function (self, arg_5_1)
					-- function 5
					local num = 0
					local event = self.shake_event_settings.event
					local persistance = event.persistance
					local octaves = event.octaves

					for i = 0, octaves do
						local num_2 = 2^i
						local num_3 = persistance^i

						num = num + self.shake_functions.interpolated_noise_func(self, arg_5_1 * num_2) * num_3
					end

					local amplitude = event.amplitude

					amplitude = amplitude or 1

					local fade_progress = celebrate.fade_progress

					fade_progress = fade_progress or 1

					return num * amplitude * fade_progress
				end,
				interpolated_noise_func = function (self, arg_6_1)
					-- function 6
					local floor = math.floor(arg_6_1)
					local num = arg_6_1 - floor
					local smoothed_noise_func = self.shake_functions.smoothed_noise_func(self, floor)
					local smoothed_noise_func_2 = self.shake_functions.smoothed_noise_func(self, floor + 1)

					return math.lerp(smoothed_noise_func, smoothed_noise_func_2, num)
				end,
				smoothed_noise_func = function (self, arg_7_1, arg_7_2)
					-- function 7
					return self.shake_functions.noise_func(self, arg_7_1) / 2 + self.shake_functions.noise_func(self, arg_7_1 - 1) / 4 + self.shake_functions.noise_func(self, arg_7_1 + 1) / 4
				end,
				noise_func = function (self, arg_8_1)
					-- function 8
					local next_random, var_8_1 = Math.next_random(arg_8_1 + self.shake_event_settings.seed)
					local next_random_2, var_8_3 = Math.next_random(next_random)

					return var_8_3 * 2 - 1
				end
			}
		end

		if not (not arg_4_1.next_blink_t and not (t > arg_4_1.next_blink_t)) then
			local str_3 = "Play_eye_blink_hangover"

			ScriptUnit.has_extension(arg_4_0, "first_person_system"):play_hud_sound_event(str_3)

			arg_4_1.next_blink_t = nil
		end

		if not (not arg_4_1.next_noise_t and not (t > arg_4_1.next_noise_t)) then
			arg_4_1.next_noise_t = t + 2

			local calculate_perlin_value_func = arg_4_1.shake_functions.calculate_perlin_value_func(arg_4_1, t - arg_4_1.shake_event_settings.start_time, arg_4_1.shake_event_settings)
			local calculate_perlin_value_func_2 = arg_4_1.shake_functions.calculate_perlin_value_func(arg_4_1, t - arg_4_1.shake_event_settings.start_time + 10, arg_4_1.shake_event_settings)
			local abs_2 = math.abs(math.sin(t * math.pi * 0.5))
			local abs_3 = math.abs(math.sin(t * math.pi))
			local sqrt = math.sqrt(calculate_perlin_value_func * calculate_perlin_value_func + calculate_perlin_value_func_2 * calculate_perlin_value_func_2)

			assert(sqrt ~= 0, "trying to divide by zero in \"update_intoxication_level\" buff update function")

			local num_3 = calculate_perlin_value_func / sqrt
			local num_4 = calculate_perlin_value_func_2 / sqrt
			local num_5 = math.abs(math.lerp(num_3, num_4, abs_2)) * math.sign(intoxication_level) * 200 + math.sign(intoxication_level) * 200 * (math.abs(intoxication_level) - 1)
			local num_6 = math.abs(math.lerp(num_3, num_4, abs_3)) * math.sign(intoxication_level) * 200 + math.sign(intoxication_level) * 200 * (math.abs(intoxication_level) - 1)
			local wwise_world = Managers.world:wwise_world(arg_4_3)

			WwiseWorld.set_global_parameter(wwise_world, "player_intoxication_level", num_5)
			WwiseWorld.set_global_parameter(wwise_world, "player_intoxication_level_2", num_6)
		end
	end,
	remove_intoxication_base = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		-- function 9
		local wwise_world = Managers.world:wwise_world(arg_9_3)

		WwiseWorld.set_global_parameter(wwise_world, "player_intoxication_level", 0)
		WwiseWorld.set_global_parameter(wwise_world, "player_intoxication_level_2", 0)

		if not arg_9_1.shake_id then
			Managers.state.camera:stop_camera_effect_shake_event(arg_9_1.shake_id)

			arg_9_1.shake_id = nil
		end
	end,
	check_celebrate_buff = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		-- function 10
		if not fn_2(arg_10_0) and not fn_3(arg_10_0) then
			return
		end

		if not ScriptUnit.extension(arg_10_0, "buff_system"):has_buff_perk("hungover") then
			local extension = ScriptUnit.extension(arg_10_0, "status_system")

			if extension:intoxication_level() < 0 then
				extension:invert_intoxication_level()

				local time = Managers.time:time("game")

				Managers.state.camera:camera_effect_shake_event("intoxication", time)

				local network = Managers.state.network
				local unit_game_object_id = network:unit_game_object_id(arg_10_0)

				network.network_transmit:send_rpc_server("rpc_request_heal_wounds", unit_game_object_id)
			end

			local str = "Play_player_celebrate_drunk"

			ScriptUnit.has_extension(arg_10_0, "first_person_system"):play_hud_sound_event(str)
		end
	end,
	increase_intoxication_level = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		-- function 11
		if not fn_2(arg_11_0) and not fn_3(arg_11_0) then
			return
		end

		local extension = ScriptUnit.extension(arg_11_0, "status_system")
		local extension_2 = ScriptUnit.extension(arg_11_0, "buff_system")

		if not extension_2:has_buff_perk("falling_down") then
			return
		end

		local base_buff = arg_11_1.template.base_buff
		local get_non_stacking_buff = extension_2:get_non_stacking_buff(base_buff)
		local intoxication_level = extension:intoxication_level()

		if intoxication_level < 0 then
			extension:invert_intoxication_level()

			if not get_non_stacking_buff then
				get_non_stacking_buff.delayed_vce_time = arg_11_2.t + 1
				get_non_stacking_buff.delayed_vce_event = "buff_begins_from_sick"
			end
		else
			extension:add_intoxication_level(1)

			if not get_non_stacking_buff then
				get_non_stacking_buff.delayed_vce_time = arg_11_2.t + 1
				get_non_stacking_buff.delayed_vce_event = "buff_begins"
			end

			if intoxication_level >= 3 then
				extension_2:add_buff("falling_down_effect")
			end
		end

		local time = Managers.time:time("game")

		Managers.state.camera:camera_effect_shake_event("intoxication", time)

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_11_0)

		network.network_transmit:send_rpc_server("rpc_request_heal_wounds", unit_game_object_id)

		get_non_stacking_buff.delayed_drink_vce_time = arg_11_2.t + 1.6
		get_non_stacking_buff.delayed_drink_vce_event = "player_drank_vce"

		local str = "Play_player_celebrate_drunk"

		ScriptUnit.has_extension(arg_11_0, "first_person_system"):play_hud_sound_event(str)

		if not fn() then
			local str_2 = "celebrate_group"
			local var_11_10 = NetworkLookup.group_buff_templates[str_2]

			Managers.state.entity:system("buff_system"):rpc_add_group_buff(nil, var_11_10, 1)
		end
	end,
	end_intoxication_effect = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		-- function 12
		local extension = ScriptUnit.extension(arg_12_0, "status_system")

		if extension:intoxication_level() > 0 then
			extension:invert_intoxication_level()
		end
	end,
	remove_falling_down_effect = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		-- function 13
		local extension = ScriptUnit.extension(arg_13_0, "status_system")

		if extension:intoxication_level() > 0 then
			extension:invert_intoxication_level()
		end

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_13_0)

		network.network_transmit:send_rpc_server("rpc_request_knock_down", unit_game_object_id)
	end,
	add_buff = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		-- function 14
		local extension = ScriptUnit.extension(arg_14_0, "buff_system")
		local buff_to_add = arg_14_1.template.buff_to_add

		extension:add_buff(buff_to_add)
	end,
	hot_joined = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		-- function 15
		local extension = ScriptUnit.extension(arg_15_0, "status_system")

		if extension:intoxication_level() == 0 then
			ScriptUnit.extension(arg_15_0, "buff_system"):add_buff("intoxication_base")
			extension:add_intoxication_level(1)
			extension:invert_intoxication_level()
		end
	end
}
celebrate.group_buff_templates = {
	celebrate_group = {
		buff_per_instance = "celebrate_group",
		side_name = "heroes"
	}
}
celebrate.add_sub_buffs_to_core_buffs = {
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
