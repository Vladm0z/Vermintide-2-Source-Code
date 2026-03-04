-- chunkname: @scripts/entity_system/systems/play_go_tutorial/play_go_pause_templates.lua

DefaultAnimationFunctions = {
	on_enter = function(arg_1_0, arg_1_1, arg_1_2)
		arg_1_0.activated = true
		arg_1_0.unit = arg_1_1

		local var_1_0 = Managers.player:local_player().player_unit
		local var_1_1 = ScriptUnit.extension(var_1_0, "input_system")

		arg_1_0.old_player_input_enabled = var_1_1.enabled
		arg_1_0.old_allowed_input = var_1_1:allowed_input_table()
		arg_1_0.old_disallowed_input = var_1_1:disallowed_input_table()

		local var_1_2 = {}

		for iter_1_0, iter_1_1 in pairs(arg_1_0.allowed_input) do
			var_1_2[iter_1_1] = true
		end

		var_1_1:set_enabled(false)
		var_1_1:set_allowed_inputs(var_1_2)
		var_1_1:set_disallowed_inputs()
		Managers.state.event:trigger("close_ingame_menu")
		Managers.input:device_block_service("gamepad", 1, "ingame_menu")
		Managers.input:device_block_service("keyboard", 1, "ingame_menu")
		Managers.input:device_block_service("mouse", 1, "ingame_menu")

		local var_1_3 = ScriptUnit.extension(var_1_0, "first_person_system")
		local var_1_4 = Unit.world_position(var_1_0, Unit.node(var_1_0, "j_neck"))
		local var_1_5 = (arg_1_2 or Unit.world_position(arg_1_1, Unit.node(arg_1_1, "j_neck"))) - var_1_4
		local var_1_6 = Quaternion.look(var_1_5, Vector3.up())

		var_1_3:force_look_rotation(var_1_6, 10)

		local var_1_7 = LevelHelper:current_level(arg_1_0.world)

		Level.trigger_event(var_1_7, "lua_" .. arg_1_0.name .. "_activated")

		if arg_1_0.mission_name then
			local var_1_8 = arg_1_0.mission_name

			if Missions[var_1_8].is_tutorial_input then
				Managers.state.event:trigger("event_add_tutorial_input", var_1_8)
			else
				Managers.state.entity:system("mission_system"):flow_callback_start_mission(var_1_8)
			end
		end
	end,
	update_input = function(arg_2_0, arg_2_1)
		if not arg_2_0.activated then
			return false
		end

		if arg_2_0.timer then
			if arg_2_1 > arg_2_0.timer then
				arg_2_0.stop_timer = arg_2_0.timer
				arg_2_0.timer = nil

				Managers.time:set_global_time_scale(0.01)

				local var_2_0 = arg_2_0.play_sound_event or "Play_tutorial_indicator"

				Managers.music:trigger_event(var_2_0)

				local var_2_1 = LevelHelper:current_level(arg_2_0.world)

				Level.trigger_event(var_2_1, "lua_" .. arg_2_0.name .. "_triggered")
			end
		else
			local var_2_2 = arg_2_0.stop_delay or 0.15

			if arg_2_0.stop_timer and arg_2_1 > arg_2_0.stop_timer + var_2_2 then
				Managers.time:set_global_time_scale(0)

				arg_2_0.stop_timer = nil
			end

			local var_2_3 = Managers.input:is_device_active("gamepad")
			local var_2_4 = Managers.input:get_service("Player")
			local var_2_5 = Managers.input:get_service("Tutorial")

			if arg_2_0.input_requirement == "sequence" then
				local var_2_6 = arg_2_0.input_mappings[1]
				local var_2_7 = true

				for iter_2_0, iter_2_1 in ipairs(var_2_6) do
					local var_2_8
					local var_2_9 = not var_2_3 and var_2_4:get_keymapping(iter_2_1)

					if not var_2_3 and (not var_2_9 or var_2_9[2] == UNASSIGNED_KEY) then
						var_2_8 = var_2_5:get(iter_2_1)
					else
						var_2_8 = var_2_4:get(iter_2_1)
					end

					if type(var_2_8) == "number" and var_2_8 == 0 then
						var_2_7 = false

						break
					elseif type(var_2_8) == "boolean" and not var_2_8 then
						var_2_7 = false

						break
					elseif var_2_8 == nil then
						var_2_7 = false

						break
					end
				end

				if var_2_7 then
					table.remove(arg_2_0.input_mappings, 1)

					if table.is_empty(arg_2_0.input_mappings) then
						return true
					end
				end
			else
				for iter_2_2, iter_2_3 in ipairs(arg_2_0.input_mappings) do
					local var_2_10 = true

					for iter_2_4, iter_2_5 in ipairs(iter_2_3) do
						local var_2_11
						local var_2_12 = not var_2_3 and var_2_4:get_keymapping(iter_2_5)

						if not var_2_3 and (not var_2_12 or var_2_12[2] == UNASSIGNED_KEY) then
							var_2_11 = var_2_5:get(iter_2_5)
						else
							var_2_11 = var_2_4:get(iter_2_5)
						end

						if type(var_2_11) == "number" and var_2_11 == 0 then
							var_2_10 = false

							break
						elseif type(var_2_11) == "boolean" and not var_2_11 then
							var_2_10 = false

							break
						elseif var_2_11 == nil then
							var_2_10 = false

							break
						end
					end

					if var_2_10 then
						return true
					end
				end
			end
		end

		return false
	end,
	update_variable = function(arg_3_0, arg_3_1)
		if not arg_3_0.activated then
			return false
		end

		if arg_3_0.timer then
			if arg_3_1 > arg_3_0.timer then
				arg_3_0.stop_timer = arg_3_0.timer
				arg_3_0.timer = nil

				Managers.time:set_global_time_scale(0.01)
			end
		else
			local var_3_0 = arg_3_0.stop_delay or 0.15

			if arg_3_0.stop_timer and arg_3_1 > arg_3_0.stop_timer + var_3_0 then
				Managers.time:set_global_time_scale(0)

				arg_3_0.stop_timer = nil
			end

			if arg_3_0[arg_3_0.variable] then
				return true
			end
		end

		return false
	end,
	on_exit = function(arg_4_0)
		Managers.time:set_global_time_scale(1)

		local var_4_0 = arg_4_0.stop_sound_event or "Stop_tutorial_indicator"

		Managers.music:trigger_event(var_4_0)

		local var_4_1 = Managers.player:local_player().player_unit
		local var_4_2 = ScriptUnit.extension(var_4_1, "input_system")

		var_4_2:set_enabled(arg_4_0.old_player_input_enabled)
		var_4_2:set_allowed_inputs(arg_4_0.old_allowed_input)
		var_4_2:set_disallowed_inputs(arg_4_0.old_disallowed_input)
		Managers.input:device_unblock_service("gamepad", 1, "ingame_menu")
		Managers.input:device_unblock_service("keyboard", 1, "ingame_menu")
		Managers.input:device_unblock_service("mouse", 1, "ingame_menu")

		local var_4_3 = ScriptUnit.extension(var_4_1, "first_person_system")
		local var_4_4 = Unit.local_rotation(var_4_1, 0)

		var_4_3.forced_look_rotation = nil

		if arg_4_0.mission_name then
			local var_4_5 = arg_4_0.mission_name

			if Missions[var_4_5].is_tutorial_input then
				Managers.state.event:trigger("event_remove_tutorial_input", var_4_5)
			else
				Managers.state.entity:system("mission_system"):end_mission(var_4_5)
			end
		end

		local var_4_6 = LevelHelper:current_level(arg_4_0.world)

		Level.trigger_event(var_4_6, "lua_" .. arg_4_0.name .. "_done")
	end,
	default_prerequisites = function(arg_5_0)
		local var_5_0 = Managers.player:local_player().player_unit
		local var_5_1 = ScriptUnit.extension(var_5_0, "status_system")

		if var_5_1:dodge_locked() or var_5_1:get_is_dodging() then
			return false
		end

		local var_5_2 = ScriptUnit.extension(var_5_0, "character_state_machine_system")

		if var_5_2:current_state() ~= "standing" and var_5_2:current_state() ~= "walking" then
			return false
		end

		if var_5_1:is_blocking() then
			return false
		end

		return true
	end
}
PauseEvents = {
	pause_events = {
		{
			animation_delay = 0.75,
			stop_delay = 0.1,
			input_requirement = "sequence",
			mission_name = "prologue_use_special_ability",
			name = "special_ability",
			input_mappings = {
				{
					"action_career"
				},
				{
					"action_career_release"
				}
			},
			allowed_input = {
				"action_career",
				"action_career_release"
			},
			on_enter = DefaultAnimationFunctions.on_enter,
			update = DefaultAnimationFunctions.update_input,
			on_exit = DefaultAnimationFunctions.on_exit,
			check_prerequisites = function()
				return true
			end
		}
	},
	animation_hook_templates = {
		{
			stop_delay = 0.1,
			mission_name = "prologue_pushing",
			animation_delay = 0.75,
			breed = "skaven_storm_vermin",
			name = "push_storm_vermin",
			animations = {
				"attack_pounce",
				"attack_special"
			},
			input_mappings = {
				{
					"action_two_hold",
					"action_one"
				}
			},
			allowed_input = {
				"action_two_hold",
				"action_one"
			},
			on_enter = DefaultAnimationFunctions.on_enter,
			update = DefaultAnimationFunctions.update_input,
			on_exit = DefaultAnimationFunctions.on_exit,
			check_prerequisites = function()
				return true
			end
		},
		{
			stop_delay = 0.07,
			mission_name = "prologue_dodge",
			animation_delay = 0.4,
			breed = "chaos_raider_tutorial",
			name = "dodge_chaos_raider",
			animations = {
				"attack_cleave_02"
			},
			input_mappings = {
				{
					"move_left",
					"dodge_hold"
				},
				{
					"move_right",
					"dodge_hold"
				},
				{
					"move_controller_left",
					"dodge_hold"
				},
				{
					"move_controller_right",
					"dodge_hold"
				}
			},
			allowed_input = {
				"move",
				"move_left",
				"move_right",
				"move_controller",
				"dodge",
				"dodge_hold",
				"jump"
			},
			on_enter = DefaultAnimationFunctions.on_enter,
			update = DefaultAnimationFunctions.update_input,
			on_exit = DefaultAnimationFunctions.on_exit,
			check_prerequisites = function()
				return true
			end
		},
		{
			stop_delay = 0.05,
			mission_name = "prologue_blocking",
			animation_delay = 0.4,
			breed = "chaos_marauder_tutorial",
			name = "block_chaos_marauder",
			animations = {
				"attack_pounce"
			},
			input_mappings = {
				{
					"action_two",
					"action_two_hold"
				}
			},
			allowed_input = {
				"action_two_hold",
				"action_two"
			},
			on_enter = DefaultAnimationFunctions.on_enter,
			update = DefaultAnimationFunctions.update_input,
			on_exit = DefaultAnimationFunctions.on_exit,
			check_prerequisites = function()
				return true
			end
		}
	}
}

for iter_0_0, iter_0_1 in ipairs(PauseEvents.animation_hook_templates) do
	fassert(not PauseEvents.animation_hook_templates[iter_0_1.name], "[PauseEvents] There is already an animation hook called %s", iter_0_1.name)

	PauseEvents.animation_hook_templates[iter_0_1.name] = iter_0_1
end

for iter_0_2, iter_0_3 in ipairs(PauseEvents.pause_events) do
	fassert(not PauseEvents.animation_hook_templates[iter_0_3.name], "[PauseEvents] There is already a pause event called %s", iter_0_3.name)

	PauseEvents.pause_events[iter_0_3.name] = iter_0_3
end
