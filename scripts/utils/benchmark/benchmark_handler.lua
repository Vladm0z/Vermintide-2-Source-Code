-- chunkname: @scripts/utils/benchmark/benchmark_handler.lua

require("scripts/utils/benchmark/benchmark_settings")

BenchmarkHandler = class(BenchmarkHandler)

BenchmarkHandler.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._cycle_time = BenchmarkSettings.initial_cycle_time
	self._cycle_views = BenchmarkSettings.cycle_views
	self._cycle_view_time = BenchmarkSettings.cycle_view_time
	self._ingame_ui = arg_1_1
	self._bot_selection_timer = 0
	self._portal_index = 1
	self._current_path = 1
	self._current_node_index = 1
	self._time_since_last_teleport = 0
	self._next_teleport_time = BenchmarkSettings.main_path_teleport_time
	self._world = arg_1_2
	self._performance_data = {}

	Managers.input:create_input_service("benchmark", "BenchmarkControllerSettings")
	Managers.input:map_device_to_service("benchmark", "keyboard")
	Managers.input:map_device_to_service("benchmark", "mouse")
	Managers.input:map_device_to_service("benchmark", "gamepad")
	Managers.input:block_device_except_service("benchmark", "keyboard", 1)
	Managers.input:block_device_except_service("benchmark", "mouse", 1)
	Managers.input:block_device_except_service("benchmark", "gamepad", 1)

	script_data.game_seed = BenchmarkSettings.game_seed

	if not BenchmarkSettings.bot_power_level_override then
		BackendUtils.get_total_power_level = function (arg_2_0, arg_2_1)
			-- function 2
			return MAX_POWER_LEVEL
		end
	end

	if not BenchmarkSettings.bot_damage_multiplier then
		local add_damage = GenericHealthExtension.add_damage
		local bot_damage_multiplier = BenchmarkSettings.bot_damage_multiplier

		GenericHealthExtension.add_damage = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9)
			-- function 3
			arg_3_2 = arg_3_2 * bot_damage_multiplier

			add_damage(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9)
		end
	end

	PlayerBotUnitFirstPerson.animation_event = function (self, arg_4_1)
		-- function 4
		Unit.animation_event(self.first_person_unit, arg_4_1)
	end

	script_data.recycler_in_cutscene = true
	script_data.recycler_in_freeflight = true
	script_data.ai_bots_disabled = false

	if not BenchmarkSettings.is_story_based then
		script_data.ai_boss_spawning_disabled = true
		script_data.ai_specials_spawning_disabled = true
	end

	Development.set_parameter("disable_loading_icon", true)

	if not IS_WINDOWS then
		local str = "resource_packages/breeds/chaos_troll"
		local flag = true
		local flag_2 = false

		Managers.package:load(str, "global", nil, flag, flag_2)
	end
end

BenchmarkHandler.story_spawn_and_animate_troll = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = Managers.state.conflict.level_analysis.generic_ai_node_units[arg_5_1.ai_node_id]
	local local_position = Unit.local_position(var_5_0[1], 0)
	local local_rotation = Unit.local_rotation(var_5_0[1], 0)
	local str = "units/beings/enemies/chaos_troll/chr_chaos_troll"
	local spawn_unit = World.spawn_unit(self._world, str, local_position, local_rotation)
	local str_2 = "units/weapons/enemy/wpn_chaos_troll/wpn_chaos_troll_01"
	local spawn_unit_2 = World.spawn_unit(self._world, str_2, local_position, local_rotation)
	local node = Unit.node(spawn_unit, "j_leftweaponattach")
	local num = 0

	World.link_unit(self._world, spawn_unit_2, num, spawn_unit, node)
	Unit.animation_event(spawn_unit, "benchmark_attack")
end

BenchmarkHandler.story_destroy_close_units = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local radius_squared = arg_6_1.radius_squared

	radius_squared = radius_squared or 900

	Managers.state.conflict:destroy_close_units(nil, nil, radius_squared)
end

BenchmarkHandler.story_teleport_party = function (self, arg_7_1, arg_7_2)
	-- function 7
	local get_teleporter_portals = ConflictUtils.get_teleporter_portals()
	local portal_id = arg_7_1.portal_id
	local unbox = get_teleporter_portals[portal_id][1]:unbox()
	local unbox_2 = get_teleporter_portals[portal_id][2]:unbox()
	local local_player = Managers.player:local_player()

	if not local_player then
		local player_unit = local_player.player_unit

		if not Unit.alive(player_unit) then
			local extension = ScriptUnit.extension(player_unit, "locomotion_system")
			local world = Managers.world:world("level_world")

			LevelHelper:flow_event(world, "teleport_" .. portal_id)
			extension:teleport_to(unbox, unbox_2)
		end
	end

	local function fn(arg_8_0, arg_8_1)
		-- function 8
		arg_8_1.locomotion_extension:teleport_to(unbox)
	end

	self:run_func_on_bots(fn)
end

BenchmarkHandler.recycler_spawn_at = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local position = arg_9_1.position
	local var_9_1 = Vector3Box(position[1], position[2], position[3])
	local num = arg_9_2 + arg_9_1.duration

	Managers.state.conflict:set_recycler_extra_pos(var_9_1, num)
end

BenchmarkHandler.story_troll_sound = function (self, arg_10_1, arg_10_2)
	-- function 10
	WwiseUtils.trigger_position_event(self._world, "Play_military_benchmark_troll", Vector3(0, 0, 0))
end

BenchmarkHandler.story_end_benchmark = function (self, arg_11_1, arg_11_2)
	-- function 11
	self._ingame_ui.leave_game = true
	self._disabled = true

	if not BenchmarkSettings.attract_benchmark then
		self:write_data()

		Boot.quit_game = true
	end
end

BenchmarkHandler._setup_initial_values = function (self, arg_12_1)
	-- function 12
	self._paths = Managers.state.conflict.level_analysis:get_main_paths()

	Managers.input:block_device_except_service("benchmark", "keyboard", 1)
	Managers.input:block_device_except_service("benchmark", "mouse", 1)
	Managers.input:block_device_except_service("benchmark", "gamepad", 1)

	local player_unit = Managers.player:local_player().player_unit

	self._local_player_unit = player_unit

	ScriptUnit.extension(player_unit, "status_system"):set_invisible(true, nil, "benchmark_handler")

	self._overview_timer = arg_12_1 + BenchmarkSettings.initial_overview_time
	self._overview = false

	if not BenchmarkSettings.is_story_based then
		self:_disable_third_person()
	end

	self._initialized = true
end

BenchmarkHandler.run_func_on_bots = function (arg_13_0, arg_13_1, ...)
	-- function 13
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
	local player = Managers.player

	for i, v in ipairs(PLAYER_AND_BOT_UNITS) do
		if not player:owner(v):is_player_controlled() then
			local var_13_2 = BLACKBOARDS[v]
			local var_13_3 = arg_13_1(v, var_13_2, ...)

			if not var_13_3 then
				return var_13_3
			end
		end
	end
end

BenchmarkHandler.gather_performance_data = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	arg_14_0._performance_data[#arg_14_0._performance_data + 1] = {
		arg_14_1,
		arg_14_2
	}
end

BenchmarkHandler.write_data = function (self)
	-- function 15
	local date = os.date("*t")
	local format = string.format("%d%d%d_%d%d%d", date.year, date.month, date.day, date.hour, date.min, date.sec)
	local format_2 = string.format("benchmark_data_%s.txt", format)
	local open = io.open(format_2, "w")

	open:write(string.format("Perfomance Data, recorded: %s\n", os.date()))
	open:write(Application.sysinfo())
	open:write("\n---\n")
	open:write(string.format("Build type: %s\n", BUILD))
	open:write(string.format("Build identifier: %s\n", Application.build_identifier()))
	open:write("---\n")
	open:write("[t, dt]\n")

	for i, v in ipairs(self._performance_data) do
		local var_15_4 = v[1]
		local var_15_5 = v[2]

		open:write(string.format("%f, %f\n", var_15_5, var_15_4))
	end

	open:close()

	self._performance_data = {}
end

BenchmarkHandler.update = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not BenchmarkSettings.attract_benchmark then
		self:gather_performance_data(arg_16_1, arg_16_2)
	end

	if self:_handle_early_out(arg_16_2) or not self._disabled then
		return
	end

	if not BenchmarkSettings.is_story_based then
		return
	end

	local num = 0
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for i, v in ipairs(PLAYER_AND_BOT_UNITS) do
		local var_16_2 = BLACKBOARDS[v]

		if not var_16_2 then
			num = num + #var_16_2.proximite_enemies
		end
	end

	if not self._overview then
		self:_update_overview(arg_16_1, arg_16_2)
	else
		self:_update_selected_bot(arg_16_1, arg_16_2)
		self:_update_bot_view(arg_16_1, arg_16_2)
	end

	self:_update_main_path(arg_16_1, arg_16_2, num)
end

local function fn()
	-- function 17
	return Managers.player:local_player().player_unit
end

BenchmarkHandler._handle_early_out = function (self, arg_18_1)
	-- function 18
	if not self._initialized then
		return
	end

	if not Managers.state.entity then
		return true
	end

	local system = Managers.state.entity:system("cutscene_system")
	local var_18_1

	if not BenchmarkSettings.is_story_based then
		if not fn() then
			var_18_1 = true
		end
	elseif not system:has_intro_cutscene_finished_playing() then
		var_18_1 = true
	end

	if not var_18_1 then
		self:_setup_initial_values(arg_18_1)
	else
		return true
	end
end

BenchmarkHandler._disable_third_person = function (self, arg_19_1)
	-- function 19
	if not (not self._third_person_disabled and arg_19_1) then
		return
	end

	local player_unit = Managers.player:local_player().player_unit

	ScriptUnit.extension(player_unit, "first_person_system"):show_third_person_units(false)

	self._third_person_disabled = true
end

BenchmarkHandler._camera_follow_bot = function (self)
	-- function 20
	local system = Managers.state.entity:system("camera_system")
	local local_player = Managers.player:local_player()
	local _current_bot = self._current_bot
	local str = "j_spine"

	system:set_follow_unit(local_player, _current_bot, str)
end

BenchmarkHandler._set_overview_camera = function (self, arg_21_1)
	-- function 21
	Managers.state.entity:system("ai_bot_group_system"):first_person_debug(nil)

	script_data.attract_mode_spectate = true

	CharacterStateHelper.change_camera_state(Managers.player:local_player(), "attract")
	ScriptUnit.extension(self._local_player_unit, "first_person_system"):set_first_person_mode(false, true)
	self:_disable_third_person(true)

	self._bot_name = nil
	self._last_bot_view = nil
	self._overview_timer = arg_21_1 + BenchmarkSettings.overview_duration
	self._overview = true
end

BenchmarkHandler._disable_overview_camera = function (self)
	-- function 22
	CharacterStateHelper.change_camera_state(Managers.player:local_player(), "idle")
	self:_disable_third_person(true)

	script_data.attract_mode_spectate = false
end

BenchmarkHandler._update_overview = function (self, arg_23_1, arg_23_2)
	-- function 23
	if arg_23_2 > self._overview_timer then
		self:_disable_overview_camera()

		self._overview = false
		self._overview_timer = arg_23_2 + BenchmarkSettings.overview_downtime
		self._bot_selection_timer = 0

		self:_update_selected_bot(arg_23_1, arg_23_2)

		return
	end
end

BenchmarkHandler._update_selected_bot = function (self, arg_24_1, arg_24_2)
	-- function 24
	self._bot_selection_timer = self._bot_selection_timer - arg_24_1

	if self._bot_selection_timer > 0 then
		return
	end

	if arg_24_2 > self._overview_timer then
		self:_set_overview_camera(arg_24_2)

		return
	end

	self._bot_selection_timer = BenchmarkSettings.bot_selection_timer

	local var_24_0
	local _current_bot_view = self._current_bot_view
	local bots = Managers.player:bots()

	for k, v in pairs(bots) do
		local player_unit = v.player_unit

		if not Unit.alive(player_unit) then
			local var_24_4 = BLACKBOARDS[player_unit]

			if not (not var_24_4 and not (#var_24_4.proximite_enemies > 0)) then
				if k == self._current_bot_view then
					return
				else
					var_24_0 = k
				end
			end
		end
	end

	if not var_24_0 then
		-- Nothing
	end

	::label_24_0::

	local _current_bot_view_2 = self._current_bot_view

	_current_bot_view_2 = _current_bot_view_2 or 3

	::label_24_1::

	self._current_bot_view = _current_bot_view_2
end

BenchmarkHandler._update_bot_view = function (self, arg_25_1, arg_25_2)
	-- function 25
	if not self._overview then
		return
	end

	local _current_bot_view = self._current_bot_view

	if _current_bot_view ~= self._last_bot_view then
		local system = Managers.state.entity:system("ai_bot_group_system")
		local system_2 = Managers.state.entity:system("fade_system")
		local system_3 = Managers.state.entity:system("locomotion_system")
		local local_player = Managers.player:local_player(_current_bot_view + 1)

		if not self._current_bot then
			ScriptUnit.has_extension(self._current_bot, "input_system"):set_bot_in_attract_mode_focus(false)
			ScriptUnit.extension(self._current_bot, "first_person_system"):set_first_person_mode(false)
		end

		self._current_bot = local_player.player_unit

		ScriptUnit.has_extension(self._current_bot, "input_system"):set_bot_in_attract_mode_focus(true)
		system:first_person_debug(_current_bot_view)
		system_2:local_player_created(local_player)
		system_3:set_override_player(local_player)
		ScriptUnit.extension(self._current_bot, "first_person_system"):set_first_person_mode(true)

		self._last_bot_view = _current_bot_view
	end
end

local tbl = {}

BenchmarkHandler._update_main_path = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	self._time_since_last_teleport = self._time_since_last_teleport + arg_26_1

	if self._time_since_last_teleport > BenchmarkSettings.destroy_close_enemies_timer then
		Managers.state.conflict:destroy_close_units(nil, nil, BenchmarkSettings.destroy_close_enemies_radius)

		self._time_since_last_teleport = 0

		print("Teleportation took too long -> despawning enemies")
	end

	local _local_player_unit = self._local_player_unit
	local huge = math.huge
	local var_26_2
	local var_26_3 = POSITION_LOOKUP[_local_player_unit]
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for i, v in ipairs(PLAYER_AND_BOT_UNITS) do
		if v ~= _local_player_unit then
			local var_26_5 = POSITION_LOOKUP[v]
			local distance_squared = Vector3.distance_squared(var_26_5, var_26_3)

			tbl[v] = distance_squared

			if distance_squared < huge then
				huge = distance_squared
				var_26_2 = v
			end
		end
	end

	local flag = false

	if huge < 8 then
		if arg_26_3 <= 0 then
			flag = true
		elseif BLACKBOARDS[var_26_2].proximite_enemies == 0 then
			local num = 0
			local var_26_9

			for i_2, v_2 in ipairs(PLAYER_AND_BOT_UNITS) do
				local var_26_10 = BLACKBOARDS[v_2]

				if not var_26_10 then
					local count = #var_26_10.proximite_enemies

					if num < count then
						var_26_9 = v_2
						num = count
					end
				end

				local var_26_12 = POSITION_LOOKUP[var_26_9]

				ScriptUnit.has_extension(_local_player_unit, "locomotion_system"):teleport_to(var_26_12)
				print("One bot is close to player, with no enemis around, but other bot is off fighting, teleport and help him")

				return
			end
		else
			local function fn(arg_27_0, arg_27_1)
				-- function 27
				if not Unit.alive(arg_27_1.target_unit) then
					return arg_27_0
				end
			end

			local run_func_on_bots = self:run_func_on_bots(fn)

			if not (not run_func_on_bots and not (tbl[run_func_on_bots] > 2)) then
				local var_26_15 = POSITION_LOOKUP[run_func_on_bots]

				ScriptUnit.has_extension(_local_player_unit, "locomotion_system"):teleport_to(var_26_15)
				print("Bot in need of help, teleporting to him")
			end
		end
	end

	local conflict = Managers.state.conflict
	local var_26_17 = conflict.main_path_player_info[_local_player_unit]

	if conflict.main_path_player_info[var_26_2].path_index ~= var_26_17.path_index then
		local function fn_2(arg_28_0, arg_28_1)
			-- function 28
			arg_28_1.locomotion_extension:teleport_to(var_26_3)
		end

		self:run_func_on_bots(fn_2)
	end

	self._next_teleport_time = self._next_teleport_time - arg_26_1

	if not flag then
		local nodes = self._paths[self._current_path].nodes
		local unbox = nodes[self._current_node_index]:unbox()

		if not Unit.alive(_local_player_unit) then
			return
		end

		local has_extension = ScriptUnit.has_extension(_local_player_unit, "locomotion_system")

		if not has_extension then
			return
		end

		has_extension:teleport_to(unbox)

		self._next_teleport_time = BenchmarkSettings.main_path_teleport_time
		self._time_since_last_teleport = 0

		self:_disable_third_person()
		print("Teleporting to", unbox, self._current_path, self._current_node_index)

		self._current_node_index = self._current_node_index + 1

		if self._current_node_index > #nodes then
			self._current_node_index = 1
			self._current_path = self._current_path + 1

			if self._current_path > #self._paths then
				self._ingame_ui.leave_game = true
				self._disabled = true

				if not BenchmarkSettings.attract_benchmark then
					self:write_data()

					Boot.quit_game = true
				end
			end
		end
	end
end

BenchmarkHandler.destroy = function (arg_29_0)
	-- function 29
	Managers.input:device_unblock_all_services("keyboard")
	Managers.input:device_unblock_all_services("mouse")
	Managers.input:device_unblock_all_services("gamepad")
	Development.set_parameter("disable_loading_icon", false)
end

BenchmarkHandler._get_teleporter_portals = function (arg_30_0)
	-- function 30
	local level_key = Managers.state.game_mode:level_key()
	local level_name = LevelSettings[level_key].level_name
	local tbl = {}
	local unit_indices = LevelResource.unit_indices(level_name, "units/hub_elements/portal")

	for i, v in ipairs(unit_indices) do
		local unit_position = LevelResource.unit_position(level_name, v)
		local unit_data = LevelResource.unit_data(level_name, v)
		local get = DynamicData.get(unit_data, "id")
		local var_30_7 = QuaternionBox(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))))

		tbl[get] = Vector3Box(unit_position)
	end

	return tbl
end

BenchmarkHandler._update_info = function (self)
	-- function 31
	Debug.text("Press 'TAB' to cycle through views")

	if not self._bot_name then
		Debug.text("Current View: %s [BOT] ", self._bot_name)
	else
		Debug.text("Current View: Spectate")
	end
end

BenchmarkHandler._handle_views = function (self, arg_32_1, arg_32_2)
	-- function 32
	if not self._cycle_views then
		return
	end

	self._cycle_view_time = self._cycle_view_time - arg_32_1

	if self._cycle_view_time <= 0 then
		self._trigger_cycle_view = true
		self._cycle_view_time = BenchmarkSettings.cycle_view_time
	end
end

BenchmarkHandler._update_input = function (self, arg_33_1, arg_33_2)
	-- function 33
	self:_update_info()
	Managers.input:block_device_except_service("benchmark", "keyboard", 1)
	Managers.input:block_device_except_service("benchmark", "mouse", 1)
	Managers.input:block_device_except_service("benchmark", "gamepad", 1)

	local system = Managers.state.entity:system("ai_bot_group_system")

	if Managers.input:get_service("benchmark"):get("cycle_through_views") or not self._trigger_cycle_view then
		self._trigger_cycle_view = false

		local bots = Managers.player:bots()
		local count = #bots
		local _current_bot_view = self._current_bot_view

		_current_bot_view = _current_bot_view or 0
		self._current_bot_view = 1 + _current_bot_view % count

		if self._current_bot_view > 0 then
			system:first_person_debug(self._current_bot_view)
			CharacterStateHelper.change_camera_state(Managers.player:local_player(), "idle")
			Development.set_parameter("attract_mode_spectate", false)

			for i, v in ipairs(bots) do
				if not ScriptUnit.extension(v.player_unit, "first_person_system").first_person_debug then
					self._bot_name = v.character_name

					break
				end
			end
		else
			system:first_person_debug(nil)
			Development.set_parameter("attract_mode_spectate", true)
			CharacterStateHelper.change_camera_state(Managers.player:local_player(), "attract")
			ScriptUnit.extension(self._local_player_unit, "first_person_system"):set_first_person_mode(false, true)

			self._bot_name = nil
		end
	end
end

BenchmarkHandler._handle_teleport = function (self, arg_34_1, arg_34_2)
	-- function 34
	if not self._teleporting then
		return
	end

	self._cycle_time = self._cycle_time - arg_34_1

	if self._cycle_time <= 0 then
		local var_34_0 = self._portals[self._portal_index]

		if not var_34_0 then
			Managers.state.conflict:destroy_all_units(true)
			Managers.transition:fade_in(2, callback(self, "cb_fade_in_done", var_34_0))

			self._teleporting = true
		end

		self._cycle_time = BenchmarkSettings.cycle_time
		self._portal_index = 1 + self._portal_index % #self._portals
	end
end

BenchmarkHandler.cb_fade_in_done = function (arg_35_0, arg_35_1)
	-- function 35
	local unbox = arg_35_1.boxed_pos:unbox()
	local player_unit = Managers.player:local_player().player_unit
	local extension = ScriptUnit.extension(player_unit, "locomotion_system")
	local world = Managers.world:world("level_world")

	LevelHelper:flow_event(world, "teleport_" .. arg_35_1.key)
	extension:teleport_to(unbox)
	Managers.transition:fade_out(0.5, callback(arg_35_0, "cb_fade_out_done"))
end

BenchmarkHandler.cb_fade_out_done = function (self)
	-- function 36
	self._teleporting = nil
end
