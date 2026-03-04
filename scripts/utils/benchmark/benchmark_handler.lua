-- chunkname: @scripts/utils/benchmark/benchmark_handler.lua

require("scripts/utils/benchmark/benchmark_settings")

BenchmarkHandler = class(BenchmarkHandler)

BenchmarkHandler.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._cycle_time = BenchmarkSettings.initial_cycle_time
	arg_1_0._cycle_views = BenchmarkSettings.cycle_views
	arg_1_0._cycle_view_time = BenchmarkSettings.cycle_view_time
	arg_1_0._ingame_ui = arg_1_1
	arg_1_0._bot_selection_timer = 0
	arg_1_0._portal_index = 1
	arg_1_0._current_path = 1
	arg_1_0._current_node_index = 1
	arg_1_0._time_since_last_teleport = 0
	arg_1_0._next_teleport_time = BenchmarkSettings.main_path_teleport_time
	arg_1_0._world = arg_1_2
	arg_1_0._performance_data = {}

	Managers.input:create_input_service("benchmark", "BenchmarkControllerSettings")
	Managers.input:map_device_to_service("benchmark", "keyboard")
	Managers.input:map_device_to_service("benchmark", "mouse")
	Managers.input:map_device_to_service("benchmark", "gamepad")
	Managers.input:block_device_except_service("benchmark", "keyboard", 1)
	Managers.input:block_device_except_service("benchmark", "mouse", 1)
	Managers.input:block_device_except_service("benchmark", "gamepad", 1)

	script_data.game_seed = BenchmarkSettings.game_seed

	if BenchmarkSettings.bot_power_level_override then
		BackendUtils.get_total_power_level = function (arg_2_0, arg_2_1)
			return MAX_POWER_LEVEL
		end
	end

	if BenchmarkSettings.bot_damage_multiplier then
		local var_1_0 = GenericHealthExtension.add_damage
		local var_1_1 = BenchmarkSettings.bot_damage_multiplier

		GenericHealthExtension.add_damage = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9)
			arg_3_2 = arg_3_2 * var_1_1

			var_1_0(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9)
		end
	end

	PlayerBotUnitFirstPerson.animation_event = function (arg_4_0, arg_4_1)
		Unit.animation_event(arg_4_0.first_person_unit, arg_4_1)
	end

	script_data.recycler_in_cutscene = true
	script_data.recycler_in_freeflight = true
	script_data.ai_bots_disabled = false

	if BenchmarkSettings.is_story_based then
		script_data.ai_boss_spawning_disabled = true
		script_data.ai_specials_spawning_disabled = true
	end

	Development.set_parameter("disable_loading_icon", true)

	if IS_WINDOWS then
		local var_1_2 = "resource_packages/breeds/chaos_troll"
		local var_1_3 = true
		local var_1_4 = false

		Managers.package:load(var_1_2, "global", nil, var_1_3, var_1_4)
	end
end

BenchmarkHandler.story_spawn_and_animate_troll = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Managers.state.conflict.level_analysis.generic_ai_node_units[arg_5_1.ai_node_id]
	local var_5_1 = Unit.local_position(var_5_0[1], 0)
	local var_5_2 = Unit.local_rotation(var_5_0[1], 0)
	local var_5_3 = "units/beings/enemies/chaos_troll/chr_chaos_troll"
	local var_5_4 = World.spawn_unit(arg_5_0._world, var_5_3, var_5_1, var_5_2)
	local var_5_5 = "units/weapons/enemy/wpn_chaos_troll/wpn_chaos_troll_01"
	local var_5_6 = World.spawn_unit(arg_5_0._world, var_5_5, var_5_1, var_5_2)
	local var_5_7 = Unit.node(var_5_4, "j_leftweaponattach")
	local var_5_8 = 0

	World.link_unit(arg_5_0._world, var_5_6, var_5_8, var_5_4, var_5_7)
	Unit.animation_event(var_5_4, "benchmark_attack")
end

BenchmarkHandler.story_destroy_close_units = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1.radius_squared or 900

	Managers.state.conflict:destroy_close_units(nil, nil, var_6_0)
end

BenchmarkHandler.story_teleport_party = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = ConflictUtils.get_teleporter_portals()
	local var_7_1 = arg_7_1.portal_id
	local var_7_2 = var_7_0[var_7_1][1]:unbox()
	local var_7_3 = var_7_0[var_7_1][2]:unbox()
	local var_7_4 = Managers.player:local_player()

	if var_7_4 then
		local var_7_5 = var_7_4.player_unit

		if Unit.alive(var_7_5) then
			local var_7_6 = ScriptUnit.extension(var_7_5, "locomotion_system")
			local var_7_7 = Managers.world:world("level_world")

			LevelHelper:flow_event(var_7_7, "teleport_" .. var_7_1)
			var_7_6:teleport_to(var_7_2, var_7_3)
		end
	end

	local function var_7_8(arg_8_0, arg_8_1)
		arg_8_1.locomotion_extension:teleport_to(var_7_2)
	end

	arg_7_0:run_func_on_bots(var_7_8)
end

BenchmarkHandler.recycler_spawn_at = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1.position
	local var_9_1 = Vector3Box(var_9_0[1], var_9_0[2], var_9_0[3])
	local var_9_2 = arg_9_2 + arg_9_1.duration

	Managers.state.conflict:set_recycler_extra_pos(var_9_1, var_9_2)
end

BenchmarkHandler.story_troll_sound = function (arg_10_0, arg_10_1, arg_10_2)
	WwiseUtils.trigger_position_event(arg_10_0._world, "Play_military_benchmark_troll", Vector3(0, 0, 0))
end

BenchmarkHandler.story_end_benchmark = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._ingame_ui.leave_game = true
	arg_11_0._disabled = true

	if BenchmarkSettings.attract_benchmark then
		arg_11_0:write_data()

		Boot.quit_game = true
	end
end

BenchmarkHandler._setup_initial_values = function (arg_12_0, arg_12_1)
	arg_12_0._paths = Managers.state.conflict.level_analysis:get_main_paths()

	Managers.input:block_device_except_service("benchmark", "keyboard", 1)
	Managers.input:block_device_except_service("benchmark", "mouse", 1)
	Managers.input:block_device_except_service("benchmark", "gamepad", 1)

	local var_12_0 = Managers.player:local_player().player_unit

	arg_12_0._local_player_unit = var_12_0

	ScriptUnit.extension(var_12_0, "status_system"):set_invisible(true, nil, "benchmark_handler")

	arg_12_0._overview_timer = arg_12_1 + BenchmarkSettings.initial_overview_time
	arg_12_0._overview = false

	if BenchmarkSettings.is_story_based then
		arg_12_0:_disable_third_person()
	end

	arg_12_0._initialized = true
end

BenchmarkHandler.run_func_on_bots = function (arg_13_0, arg_13_1, ...)
	local var_13_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
	local var_13_1 = Managers.player

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		if not var_13_1:owner(iter_13_1):is_player_controlled() then
			local var_13_2 = BLACKBOARDS[iter_13_1]
			local var_13_3 = arg_13_1(iter_13_1, var_13_2, ...)

			if var_13_3 then
				return var_13_3
			end
		end
	end
end

BenchmarkHandler.gather_performance_data = function (arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._performance_data[#arg_14_0._performance_data + 1] = {
		arg_14_1,
		arg_14_2
	}
end

BenchmarkHandler.write_data = function (arg_15_0)
	local var_15_0 = os.date("*t")
	local var_15_1 = string.format("%d%d%d_%d%d%d", var_15_0.year, var_15_0.month, var_15_0.day, var_15_0.hour, var_15_0.min, var_15_0.sec)
	local var_15_2 = string.format("benchmark_data_%s.txt", var_15_1)
	local var_15_3 = io.open(var_15_2, "w")

	var_15_3:write(string.format("Perfomance Data, recorded: %s\n", os.date()))
	var_15_3:write(Application.sysinfo())
	var_15_3:write("\n---\n")
	var_15_3:write(string.format("Build type: %s\n", BUILD))
	var_15_3:write(string.format("Build identifier: %s\n", Application.build_identifier()))
	var_15_3:write("---\n")
	var_15_3:write("[t, dt]\n")

	for iter_15_0, iter_15_1 in ipairs(arg_15_0._performance_data) do
		local var_15_4 = iter_15_1[1]
		local var_15_5 = iter_15_1[2]

		var_15_3:write(string.format("%f, %f\n", var_15_5, var_15_4))
	end

	var_15_3:close()

	arg_15_0._performance_data = {}
end

BenchmarkHandler.update = function (arg_16_0, arg_16_1, arg_16_2)
	if BenchmarkSettings.attract_benchmark then
		arg_16_0:gather_performance_data(arg_16_1, arg_16_2)
	end

	if arg_16_0:_handle_early_out(arg_16_2) or arg_16_0._disabled then
		return
	end

	if BenchmarkSettings.is_story_based then
		return
	end

	local var_16_0 = 0
	local var_16_1 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for iter_16_0, iter_16_1 in ipairs(var_16_1) do
		local var_16_2 = BLACKBOARDS[iter_16_1]

		if var_16_2 then
			var_16_0 = var_16_0 + #var_16_2.proximite_enemies
		end
	end

	if arg_16_0._overview then
		arg_16_0:_update_overview(arg_16_1, arg_16_2)
	else
		arg_16_0:_update_selected_bot(arg_16_1, arg_16_2)
		arg_16_0:_update_bot_view(arg_16_1, arg_16_2)
	end

	arg_16_0:_update_main_path(arg_16_1, arg_16_2, var_16_0)
end

local function var_0_0()
	return Managers.player:local_player().player_unit
end

BenchmarkHandler._handle_early_out = function (arg_18_0, arg_18_1)
	if arg_18_0._initialized then
		return
	end

	if not Managers.state.entity then
		return true
	end

	local var_18_0 = Managers.state.entity:system("cutscene_system")
	local var_18_1

	if BenchmarkSettings.is_story_based then
		if var_0_0() then
			var_18_1 = true
		end
	elseif var_18_0:has_intro_cutscene_finished_playing() then
		var_18_1 = true
	end

	if var_18_1 then
		arg_18_0:_setup_initial_values(arg_18_1)
	else
		return true
	end
end

BenchmarkHandler._disable_third_person = function (arg_19_0, arg_19_1)
	if arg_19_0._third_person_disabled and not arg_19_1 then
		return
	end

	local var_19_0 = Managers.player:local_player().player_unit

	ScriptUnit.extension(var_19_0, "first_person_system"):show_third_person_units(false)

	arg_19_0._third_person_disabled = true
end

BenchmarkHandler._camera_follow_bot = function (arg_20_0)
	local var_20_0 = Managers.state.entity:system("camera_system")
	local var_20_1 = Managers.player:local_player()
	local var_20_2 = arg_20_0._current_bot
	local var_20_3 = "j_spine"

	var_20_0:set_follow_unit(var_20_1, var_20_2, var_20_3)
end

BenchmarkHandler._set_overview_camera = function (arg_21_0, arg_21_1)
	Managers.state.entity:system("ai_bot_group_system"):first_person_debug(nil)

	script_data.attract_mode_spectate = true

	CharacterStateHelper.change_camera_state(Managers.player:local_player(), "attract")
	ScriptUnit.extension(arg_21_0._local_player_unit, "first_person_system"):set_first_person_mode(false, true)
	arg_21_0:_disable_third_person(true)

	arg_21_0._bot_name = nil
	arg_21_0._last_bot_view = nil
	arg_21_0._overview_timer = arg_21_1 + BenchmarkSettings.overview_duration
	arg_21_0._overview = true
end

BenchmarkHandler._disable_overview_camera = function (arg_22_0)
	CharacterStateHelper.change_camera_state(Managers.player:local_player(), "idle")
	arg_22_0:_disable_third_person(true)

	script_data.attract_mode_spectate = false
end

BenchmarkHandler._update_overview = function (arg_23_0, arg_23_1, arg_23_2)
	if arg_23_2 > arg_23_0._overview_timer then
		arg_23_0:_disable_overview_camera()

		arg_23_0._overview = false
		arg_23_0._overview_timer = arg_23_2 + BenchmarkSettings.overview_downtime
		arg_23_0._bot_selection_timer = 0

		arg_23_0:_update_selected_bot(arg_23_1, arg_23_2)

		return
	end
end

BenchmarkHandler._update_selected_bot = function (arg_24_0, arg_24_1, arg_24_2)
	arg_24_0._bot_selection_timer = arg_24_0._bot_selection_timer - arg_24_1

	if arg_24_0._bot_selection_timer > 0 then
		return
	end

	if arg_24_2 > arg_24_0._overview_timer then
		arg_24_0:_set_overview_camera(arg_24_2)

		return
	end

	arg_24_0._bot_selection_timer = BenchmarkSettings.bot_selection_timer

	local var_24_0
	local var_24_1 = arg_24_0._current_bot_view
	local var_24_2 = Managers.player:bots()

	for iter_24_0, iter_24_1 in pairs(var_24_2) do
		local var_24_3 = iter_24_1.player_unit

		if Unit.alive(var_24_3) then
			local var_24_4 = BLACKBOARDS[var_24_3]

			if var_24_4 and #var_24_4.proximite_enemies > 0 then
				if iter_24_0 == arg_24_0._current_bot_view then
					return
				else
					var_24_0 = iter_24_0
				end
			end
		end
	end

	arg_24_0._current_bot_view = var_24_0 or arg_24_0._current_bot_view or 3
end

BenchmarkHandler._update_bot_view = function (arg_25_0, arg_25_1, arg_25_2)
	if arg_25_0._overview then
		return
	end

	local var_25_0 = arg_25_0._current_bot_view

	if var_25_0 ~= arg_25_0._last_bot_view then
		local var_25_1 = Managers.state.entity:system("ai_bot_group_system")
		local var_25_2 = Managers.state.entity:system("fade_system")
		local var_25_3 = Managers.state.entity:system("locomotion_system")
		local var_25_4 = Managers.player:local_player(var_25_0 + 1)

		if arg_25_0._current_bot then
			ScriptUnit.has_extension(arg_25_0._current_bot, "input_system"):set_bot_in_attract_mode_focus(false)
			ScriptUnit.extension(arg_25_0._current_bot, "first_person_system"):set_first_person_mode(false)
		end

		arg_25_0._current_bot = var_25_4.player_unit

		ScriptUnit.has_extension(arg_25_0._current_bot, "input_system"):set_bot_in_attract_mode_focus(true)
		var_25_1:first_person_debug(var_25_0)
		var_25_2:local_player_created(var_25_4)
		var_25_3:set_override_player(var_25_4)
		ScriptUnit.extension(arg_25_0._current_bot, "first_person_system"):set_first_person_mode(true)

		arg_25_0._last_bot_view = var_25_0
	end
end

local var_0_1 = {}

BenchmarkHandler._update_main_path = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	arg_26_0._time_since_last_teleport = arg_26_0._time_since_last_teleport + arg_26_1

	if arg_26_0._time_since_last_teleport > BenchmarkSettings.destroy_close_enemies_timer then
		Managers.state.conflict:destroy_close_units(nil, nil, BenchmarkSettings.destroy_close_enemies_radius)

		arg_26_0._time_since_last_teleport = 0

		print("Teleportation took too long -> despawning enemies")
	end

	local var_26_0 = arg_26_0._local_player_unit
	local var_26_1 = math.huge
	local var_26_2
	local var_26_3 = POSITION_LOOKUP[var_26_0]
	local var_26_4 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for iter_26_0, iter_26_1 in ipairs(var_26_4) do
		if iter_26_1 ~= var_26_0 then
			local var_26_5 = POSITION_LOOKUP[iter_26_1]
			local var_26_6 = Vector3.distance_squared(var_26_5, var_26_3)

			var_0_1[iter_26_1] = var_26_6

			if var_26_6 < var_26_1 then
				var_26_1 = var_26_6
				var_26_2 = iter_26_1
			end
		end
	end

	local var_26_7 = false

	if var_26_1 < 8 then
		if arg_26_3 <= 0 then
			var_26_7 = true
		elseif BLACKBOARDS[var_26_2].proximite_enemies == 0 then
			local var_26_8 = 0
			local var_26_9

			for iter_26_2, iter_26_3 in ipairs(var_26_4) do
				local var_26_10 = BLACKBOARDS[iter_26_3]

				if var_26_10 then
					local var_26_11 = #var_26_10.proximite_enemies

					if var_26_8 < var_26_11 then
						var_26_9 = iter_26_3
						var_26_8 = var_26_11
					end
				end

				local var_26_12 = POSITION_LOOKUP[var_26_9]

				ScriptUnit.has_extension(var_26_0, "locomotion_system"):teleport_to(var_26_12)
				print("One bot is close to player, with no enemis around, but other bot is off fighting, teleport and help him")

				return
			end
		else
			local function var_26_13(arg_27_0, arg_27_1)
				if Unit.alive(arg_27_1.target_unit) then
					return arg_27_0
				end
			end

			local var_26_14 = arg_26_0:run_func_on_bots(var_26_13)

			if var_26_14 and var_0_1[var_26_14] > 2 then
				local var_26_15 = POSITION_LOOKUP[var_26_14]

				ScriptUnit.has_extension(var_26_0, "locomotion_system"):teleport_to(var_26_15)
				print("Bot in need of help, teleporting to him")
			end
		end
	end

	local var_26_16 = Managers.state.conflict
	local var_26_17 = var_26_16.main_path_player_info[var_26_0]

	if var_26_16.main_path_player_info[var_26_2].path_index ~= var_26_17.path_index then
		local function var_26_18(arg_28_0, arg_28_1)
			arg_28_1.locomotion_extension:teleport_to(var_26_3)
		end

		arg_26_0:run_func_on_bots(var_26_18)
	end

	arg_26_0._next_teleport_time = arg_26_0._next_teleport_time - arg_26_1

	if var_26_7 then
		local var_26_19 = arg_26_0._paths[arg_26_0._current_path].nodes
		local var_26_20 = var_26_19[arg_26_0._current_node_index]:unbox()

		if not Unit.alive(var_26_0) then
			return
		end

		local var_26_21 = ScriptUnit.has_extension(var_26_0, "locomotion_system")

		if not var_26_21 then
			return
		end

		var_26_21:teleport_to(var_26_20)

		arg_26_0._next_teleport_time = BenchmarkSettings.main_path_teleport_time
		arg_26_0._time_since_last_teleport = 0

		arg_26_0:_disable_third_person()
		print("Teleporting to", var_26_20, arg_26_0._current_path, arg_26_0._current_node_index)

		arg_26_0._current_node_index = arg_26_0._current_node_index + 1

		if arg_26_0._current_node_index > #var_26_19 then
			arg_26_0._current_node_index = 1
			arg_26_0._current_path = arg_26_0._current_path + 1

			if arg_26_0._current_path > #arg_26_0._paths then
				arg_26_0._ingame_ui.leave_game = true
				arg_26_0._disabled = true

				if BenchmarkSettings.attract_benchmark then
					arg_26_0:write_data()

					Boot.quit_game = true
				end
			end
		end
	end
end

BenchmarkHandler.destroy = function (arg_29_0)
	Managers.input:device_unblock_all_services("keyboard")
	Managers.input:device_unblock_all_services("mouse")
	Managers.input:device_unblock_all_services("gamepad")
	Development.set_parameter("disable_loading_icon", false)
end

BenchmarkHandler._get_teleporter_portals = function (arg_30_0)
	local var_30_0 = Managers.state.game_mode:level_key()
	local var_30_1 = LevelSettings[var_30_0].level_name
	local var_30_2 = {}
	local var_30_3 = LevelResource.unit_indices(var_30_1, "units/hub_elements/portal")

	for iter_30_0, iter_30_1 in ipairs(var_30_3) do
		local var_30_4 = LevelResource.unit_position(var_30_1, iter_30_1)
		local var_30_5 = LevelResource.unit_data(var_30_1, iter_30_1)
		local var_30_6 = DynamicData.get(var_30_5, "id")
		local var_30_7 = QuaternionBox(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))))

		var_30_2[var_30_6] = Vector3Box(var_30_4)
	end

	return var_30_2
end

BenchmarkHandler._update_info = function (arg_31_0)
	Debug.text("Press 'TAB' to cycle through views")

	if arg_31_0._bot_name then
		Debug.text("Current View: %s [BOT] ", arg_31_0._bot_name)
	else
		Debug.text("Current View: Spectate")
	end
end

BenchmarkHandler._handle_views = function (arg_32_0, arg_32_1, arg_32_2)
	if not arg_32_0._cycle_views then
		return
	end

	arg_32_0._cycle_view_time = arg_32_0._cycle_view_time - arg_32_1

	if arg_32_0._cycle_view_time <= 0 then
		arg_32_0._trigger_cycle_view = true
		arg_32_0._cycle_view_time = BenchmarkSettings.cycle_view_time
	end
end

BenchmarkHandler._update_input = function (arg_33_0, arg_33_1, arg_33_2)
	arg_33_0:_update_info()
	Managers.input:block_device_except_service("benchmark", "keyboard", 1)
	Managers.input:block_device_except_service("benchmark", "mouse", 1)
	Managers.input:block_device_except_service("benchmark", "gamepad", 1)

	local var_33_0 = Managers.state.entity:system("ai_bot_group_system")

	if Managers.input:get_service("benchmark"):get("cycle_through_views") or arg_33_0._trigger_cycle_view then
		arg_33_0._trigger_cycle_view = false

		local var_33_1 = Managers.player:bots()
		local var_33_2 = #var_33_1

		arg_33_0._current_bot_view = 1 + (arg_33_0._current_bot_view or 0) % var_33_2

		if arg_33_0._current_bot_view > 0 then
			var_33_0:first_person_debug(arg_33_0._current_bot_view)
			CharacterStateHelper.change_camera_state(Managers.player:local_player(), "idle")
			Development.set_parameter("attract_mode_spectate", false)

			for iter_33_0, iter_33_1 in ipairs(var_33_1) do
				if ScriptUnit.extension(iter_33_1.player_unit, "first_person_system").first_person_debug then
					arg_33_0._bot_name = iter_33_1.character_name

					break
				end
			end
		else
			var_33_0:first_person_debug(nil)
			Development.set_parameter("attract_mode_spectate", true)
			CharacterStateHelper.change_camera_state(Managers.player:local_player(), "attract")
			ScriptUnit.extension(arg_33_0._local_player_unit, "first_person_system"):set_first_person_mode(false, true)

			arg_33_0._bot_name = nil
		end
	end
end

BenchmarkHandler._handle_teleport = function (arg_34_0, arg_34_1, arg_34_2)
	if arg_34_0._teleporting then
		return
	end

	arg_34_0._cycle_time = arg_34_0._cycle_time - arg_34_1

	if arg_34_0._cycle_time <= 0 then
		local var_34_0 = arg_34_0._portals[arg_34_0._portal_index]

		if var_34_0 then
			Managers.state.conflict:destroy_all_units(true)
			Managers.transition:fade_in(2, callback(arg_34_0, "cb_fade_in_done", var_34_0))

			arg_34_0._teleporting = true
		end

		arg_34_0._cycle_time = BenchmarkSettings.cycle_time
		arg_34_0._portal_index = 1 + arg_34_0._portal_index % #arg_34_0._portals
	end
end

BenchmarkHandler.cb_fade_in_done = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_1.boxed_pos:unbox()
	local var_35_1 = Managers.player:local_player().player_unit
	local var_35_2 = ScriptUnit.extension(var_35_1, "locomotion_system")
	local var_35_3 = Managers.world:world("level_world")

	LevelHelper:flow_event(var_35_3, "teleport_" .. arg_35_1.key)
	var_35_2:teleport_to(var_35_0)
	Managers.transition:fade_out(0.5, callback(arg_35_0, "cb_fade_out_done"))
end

BenchmarkHandler.cb_fade_out_done = function (arg_36_0)
	arg_36_0._teleporting = nil
end
