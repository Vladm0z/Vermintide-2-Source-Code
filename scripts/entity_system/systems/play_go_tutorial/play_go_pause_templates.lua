-- chunkname: @scripts/entity_system/systems/play_go_tutorial/play_go_pause_templates.lua

DefaultAnimationFunctions = {
	on_enter = function (self, arg_1_1, arg_1_2)
		-- function 1
		self.activated = true
		self.unit = arg_1_1

		local player_unit = Managers.player:local_player().player_unit
		local extension = ScriptUnit.extension(player_unit, "input_system")

		self.old_player_input_enabled = extension.enabled
		self.old_allowed_input = extension:allowed_input_table()
		self.old_disallowed_input = extension:disallowed_input_table()

		local tbl = {}

		for k, v in pairs(self.allowed_input) do
			tbl[v] = true
		end

		extension:set_enabled(false)
		extension:set_allowed_inputs(tbl)
		extension:set_disallowed_inputs()
		Managers.state.event:trigger("close_ingame_menu")
		Managers.input:device_block_service("gamepad", 1, "ingame_menu")
		Managers.input:device_block_service("keyboard", 1, "ingame_menu")
		Managers.input:device_block_service("mouse", 1, "ingame_menu")

		local extension_2 = ScriptUnit.extension(player_unit, "first_person_system")
		local world_position = Unit.world_position(player_unit, Unit.node(player_unit, "j_neck"))
		local num = (arg_1_2 or Unit.world_position(arg_1_1, Unit.node(arg_1_1, "j_neck"))) - world_position
		local look = Quaternion.look(num, Vector3.up())

		extension_2:force_look_rotation(look, 10)

		local current_level = LevelHelper:current_level(self.world)

		Level.trigger_event(current_level, "lua_" .. self.name .. "_activated")

		if not self.mission_name then
			local mission_name = self.mission_name

			if not Missions[mission_name].is_tutorial_input then
				Managers.state.event:trigger("event_add_tutorial_input", mission_name)
			else
				Managers.state.entity:system("mission_system"):flow_callback_start_mission(mission_name)
			end
		end
	end,
	update_input = function (self, arg_2_1)
		-- function 2
		if not self.activated then
			return false
		end

		if not self.timer then
			if arg_2_1 > self.timer then
				self.stop_timer = self.timer
				self.timer = nil

				Managers.time:set_global_time_scale(0.01)

				local play_sound_event = self.play_sound_event

				play_sound_event = play_sound_event or "Play_tutorial_indicator"

				Managers.music:trigger_event(play_sound_event)

				local current_level = LevelHelper:current_level(self.world)

				Level.trigger_event(current_level, "lua_" .. self.name .. "_triggered")
			end
		else
			local stop_delay = self.stop_delay

			stop_delay = stop_delay or 0.15

			if not (not self.stop_timer and not (arg_2_1 > self.stop_timer + stop_delay)) then
				Managers.time:set_global_time_scale(0)

				self.stop_timer = nil
			end

			local is_device_active = Managers.input:is_device_active("gamepad")
			local get_service = Managers.input:get_service("Player")
			local get_service_2 = Managers.input:get_service("Tutorial")

			if not (self.input_requirement == "sequence") then
				local var_2_6 = self.input_mappings[1]
				local flag = true

				for i, v in ipairs(var_2_6) do
					local var_2_8
					local flag_2 = not not is_device_active or get_service:get_keymapping(v)

					if not (is_device_active or not flag_2 or flag_2[2] ~= UNASSIGNED_KEY) then
						var_2_8 = get_service_2:get(v)
					else
						var_2_8 = get_service:get(v)
					end

					if not (type(var_2_8) ~= "number" or var_2_8 ~= 0) then
						flag = false

						break
					elseif not (type(var_2_8) ~= "boolean" or var_2_8) then
						flag = false

						break
					elseif var_2_8 == nil then
						flag = false

						break
					end
				end

				if not flag then
					table.remove(self.input_mappings, 1)

					if not table.is_empty(self.input_mappings) then
						return true
					end
				end
			else
				for i_2, v_2 in ipairs(self.input_mappings) do
					local flag_3 = true

					for i_3, v_3 in ipairs(v_2) do
						local var_2_11
						local flag_4 = not not is_device_active or get_service:get_keymapping(v_3)

						if not (is_device_active or not flag_4 or flag_4[2] ~= UNASSIGNED_KEY) then
							var_2_11 = get_service_2:get(v_3)
						else
							var_2_11 = get_service:get(v_3)
						end

						if not (type(var_2_11) ~= "number" or var_2_11 ~= 0) then
							flag_3 = false

							break
						elseif not (type(var_2_11) ~= "boolean" or var_2_11) then
							flag_3 = false

							break
						elseif var_2_11 == nil then
							flag_3 = false

							break
						end
					end

					if not flag_3 then
						return true
					end
				end
			end
		end

		return false
	end,
	update_variable = function (self, arg_3_1)
		-- function 3
		if not self.activated then
			return false
		end

		if not self.timer then
			if arg_3_1 > self.timer then
				self.stop_timer = self.timer
				self.timer = nil

				Managers.time:set_global_time_scale(0.01)
			end
		else
			local stop_delay = self.stop_delay

			stop_delay = stop_delay or 0.15

			if not (not self.stop_timer and not (arg_3_1 > self.stop_timer + stop_delay)) then
				Managers.time:set_global_time_scale(0)

				self.stop_timer = nil
			end

			if not self[self.variable] then
				return true
			end
		end

		return false
	end,
	on_exit = function (self)
		-- function 4
		Managers.time:set_global_time_scale(1)

		local stop_sound_event = self.stop_sound_event

		stop_sound_event = stop_sound_event or "Stop_tutorial_indicator"

		Managers.music:trigger_event(stop_sound_event)

		local player_unit = Managers.player:local_player().player_unit
		local extension = ScriptUnit.extension(player_unit, "input_system")

		extension:set_enabled(self.old_player_input_enabled)
		extension:set_allowed_inputs(self.old_allowed_input)
		extension:set_disallowed_inputs(self.old_disallowed_input)
		Managers.input:device_unblock_service("gamepad", 1, "ingame_menu")
		Managers.input:device_unblock_service("keyboard", 1, "ingame_menu")
		Managers.input:device_unblock_service("mouse", 1, "ingame_menu")

		local extension_2 = ScriptUnit.extension(player_unit, "first_person_system")
		local local_rotation = Unit.local_rotation(player_unit, 0)

		extension_2.forced_look_rotation = nil

		if not self.mission_name then
			local mission_name = self.mission_name

			if not Missions[mission_name].is_tutorial_input then
				Managers.state.event:trigger("event_remove_tutorial_input", mission_name)
			else
				Managers.state.entity:system("mission_system"):end_mission(mission_name)
			end
		end

		local current_level = LevelHelper:current_level(self.world)

		Level.trigger_event(current_level, "lua_" .. self.name .. "_done")
	end,
	default_prerequisites = function (arg_5_0)
		-- function 5
		local player_unit = Managers.player:local_player().player_unit
		local extension = ScriptUnit.extension(player_unit, "status_system")

		if extension:dodge_locked() or not extension:get_is_dodging() then
			return false
		end

		local extension_2 = ScriptUnit.extension(player_unit, "character_state_machine_system")

		if not (extension_2:current_state() == "standing" or extension_2:current_state() == "walking") then
			return false
		end

		if not extension:is_blocking() then
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
			check_prerequisites = function ()
				-- function 6
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
			check_prerequisites = function ()
				-- function 7
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
			check_prerequisites = function ()
				-- function 8
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
			check_prerequisites = function ()
				-- function 9
				return true
			end
		}
	}
}

for i, v in ipairs(PauseEvents.animation_hook_templates) do
	fassert(not PauseEvents.animation_hook_templates[v.name], "[PauseEvents] There is already an animation hook called %s", v.name)

	PauseEvents.animation_hook_templates[v.name] = v
end

for i_2, v_2 in ipairs(PauseEvents.pause_events) do
	fassert(not PauseEvents.animation_hook_templates[v_2.name], "[PauseEvents] There is already a pause event called %s", v_2.name)

	PauseEvents.pause_events[v_2.name] = v_2
end
