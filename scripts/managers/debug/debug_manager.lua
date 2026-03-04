-- chunkname: @scripts/managers/debug/debug_manager.lua

require("scripts/managers/debug/debug_drawer")
require("scripts/managers/debug/debug_drawer_release")
require("scripts/managers/debug/debug")
require("scripts/managers/debug/profiler_scopes")

DebugManager = class(DebugManager)
QuickDrawer = QuickDrawer or true
QuickDrawerStay = QuickDrawerStay or true

local var_0_0 = {
	"rpc_debug_command",
	"rpc_propagate_debug_option",
	"rpc_debug_option_propagation_response"
}

GLOBAL_TIME_SCALE = GLOBAL_TIME_SCALE or 1

local var_0_1 = {
	1e-05,
	0.0001,
	0.001,
	0.01,
	0.1,
	1,
	5,
	10,
	20,
	30,
	50,
	75,
	100,
	125,
	150,
	175,
	200,
	250,
	300,
	500,
	750,
	1000,
	5000,
	10000
}
local var_0_2 = {
	10,
	20,
	30,
	40,
	50,
	75,
	100,
	150,
	200,
	250,
	300,
	500,
	750,
	1000,
	2000,
	3000,
	5000
}
local var_0_3 = 0

DebugManager.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0._world = arg_1_1
	arg_1_0._drawers = {}
	arg_1_0.free_flight_manager = arg_1_2
	arg_1_0.input_manager = arg_1_3
	arg_1_0.input_service = arg_1_0.input_manager:get_service("Debug")
	arg_1_0.is_server = arg_1_5
	arg_1_0._actor_draw = {}
	arg_1_0._paused = false
	arg_1_0._visualize_units = {}
	QuickDrawer = arg_1_0:drawer({
		name = "quick_debug",
		mode = "immediate"
	})
	QuickDrawerStay = arg_1_0:drawer({
		name = "quick_debug_stay",
		mode = "retained"
	})
	arg_1_0.time_paused = false
	arg_1_0.time_scale_index = table.find(var_0_1, 100)
	arg_1_0.time_scale_accumulating_value = 0
	arg_1_0.speed_scale_index = table.find(var_0_2, 100)
	arg_1_0.graph_drawer = GraphDrawer:new(arg_1_1, arg_1_3)
	arg_1_0.network_event_delegate = arg_1_4

	arg_1_4:register(arg_1_0, unpack(var_0_0))

	arg_1_0.time_scale_list = var_0_1
	arg_1_0._debug_updates = {}
end

DebugManager.drawer = function (arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or {}

	local var_2_0 = arg_2_1.name
	local var_2_1
	local var_2_2 = BUILD == "release" and DebugDrawerRelease or DebugDrawer

	if var_2_0 == nil then
		local var_2_3 = World.create_line_object(arg_2_0._world)

		var_2_1 = var_2_2:new(var_2_3, arg_2_1.mode)
		arg_2_0._drawers[#arg_2_0._drawers + 1] = var_2_1
	elseif arg_2_0._drawers[var_2_0] == nil then
		local var_2_4 = World.create_line_object(arg_2_0._world)

		var_2_1 = var_2_2:new(var_2_4, arg_2_1.mode)
		arg_2_0._drawers[var_2_0] = var_2_1
	else
		var_2_1 = arg_2_0._drawers[var_2_0]
	end

	return var_2_1
end

DebugManager.reset_drawer = function (arg_3_0, arg_3_1)
	if arg_3_0._drawers[arg_3_1] then
		arg_3_0._drawers[arg_3_1]:reset()
	end
end

DebugManager.update = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_1 / (var_0_1[arg_4_0.time_scale_index] / 100)

	if IS_LINUX then
		return
	end

	arg_4_0:update_time_scale(var_4_0)
	arg_4_0:_update_sound_debug()

	if script_data.player_mechanics_goodness_debug then
		arg_4_0:_adjust_player_speed()
	end

	if Managers.input:is_device_active("gamepad") then
		arg_4_0:_adjust_gamepad_player_speed()
	end

	local var_4_1 = var_0_2[arg_4_0.speed_scale_index]

	if var_4_1 ~= 100 then
		if math.ceil(var_4_1) == var_4_1 then
			Debug.text("Player speed scaled by " .. tostring(var_4_1) .. "%%")
		else
			local var_4_2 = string.format("Speed scaled by %f", var_4_1):gsub("^(.-)0*$", "%1") .. "%%"

			Debug.text(var_4_2)
		end
	end

	if script_data.debug_wwise_timestamp then
		local var_4_3 = Wwise.get_timestamp()
		local var_4_4 = math.floor(var_4_3 / 3600000)
		local var_4_5 = var_4_3 - var_4_4 * 1000 * 60 * 60
		local var_4_6 = math.floor(var_4_5 / 60000)
		local var_4_7 = var_4_5 - var_4_6 * 1000 * 60
		local var_4_8 = math.floor(var_4_7 / 1000)
		local var_4_9 = var_4_7 - var_4_8 * 1000

		Debug.text("Wwise Timestamp: %.2d:%.2d:%.2d.%.3d", var_4_4, var_4_6, var_4_8, var_4_9)
	end

	if script_data.debug_particle_simulation then
		Debug.text("Particles simulated: " .. World.num_particles(arg_4_0._world))
	end

	if script_data.debug_enemy_package_loader then
		Managers.level_transition_handler.enemy_package_loader:debug_loaded_breeds()
	end

	if script_data.debug_pickup_package_loader then
		Managers.level_transition_handler.pickup_package_loader:debug_loaded_pickups()
	end

	if script_data.debug_general_synced_package_loader then
		Managers.level_transition_handler.general_synced_package_loader:debug_loaded_packages()
	end

	arg_4_0:_update_bot_behavior_debug()
	arg_4_0:_update_actor_draw(var_4_0)

	for iter_4_0, iter_4_1 in pairs(arg_4_0._drawers) do
		iter_4_1:update(arg_4_0._world)
	end

	arg_4_0.graph_drawer:update(arg_4_0.input_service, arg_4_2)

	if DebugKeyHandler.key_pressed("f7", "cycle patched weapons") then
		arg_4_0:cycle_patched_items(arg_4_2)
	end

	local var_4_10 = arg_4_0._cycle_patch_items_at

	if var_4_10 and var_4_10 < arg_4_2 then
		arg_4_0:_cycle_patched_items()

		arg_4_0._cycle_patch_items_at = nil
	end

	arg_4_0:_update_unit_spawning(var_4_0, arg_4_2)

	if script_data.debug_unit and arg_4_0.is_server and script_data.debug_behaviour_trees then
		local var_4_11 = script_data.debug_unit

		if Unit.alive(var_4_11) then
			local var_4_12 = ScriptUnit.extension(var_4_11, "ai_system"):blackboard().action

			if var_4_12 then
				Debug.text(var_4_12.name)
			end
		end
	end

	local var_4_13 = arg_4_0.free_flight_manager:active("global")

	if not var_4_13 and arg_4_0._in_free_flight and script_data.has_mouse then
		arg_4_0:_toggle_debug_mouse_cursor(false)
	end

	for iter_4_2, iter_4_3 in pairs(arg_4_0._debug_updates) do
		iter_4_3(var_4_0, arg_4_2)
	end

	arg_4_0:_clear_debug_draws()

	arg_4_0._in_free_flight = var_4_13

	if not var_4_13 then
		return
	end

	local var_4_14 = Managers.player:player_from_peer_id(Network.peer_id()).input_source

	if var_4_14 and var_4_14:has("debug_mouse_cursor") and var_4_14:get("debug_mouse_cursor") and script_data.has_mouse then
		local var_4_15 = not arg_4_0._debug_mouse_cursor

		arg_4_0:_toggle_debug_mouse_cursor(var_4_15)
	end

	arg_4_0:_update_paused_game(var_4_14, var_4_0)
end

DebugManager._clear_debug_draws = function (arg_5_0)
	if DebugKeyHandler.key_pressed("x", "clear quickdraw", "ai debugger", nil, "FreeFlight") then
		QuickDrawerStay:reset()
		Debug.reset_sticky_world_texts()
	end
end

DebugManager.register_update = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._debug_updates[arg_6_1] = arg_6_2
end

DebugManager.unregister_update = function (arg_7_0, arg_7_1)
	arg_7_0._debug_updates[arg_7_1] = nil
end

DebugManager.update_time_scale = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.time_scale_index

	if not not arg_8_0._disable_time_travel ~= not not script_data.disable_time_travel then
		arg_8_0._disable_time_travel = not not script_data.disable_time_travel
		var_8_0 = table.index_of(var_0_1, 100)

		arg_8_0:set_time_scale(var_8_0)
	end

	local var_8_1 = arg_8_0.time_paused
	local var_8_2 = Managers.input

	if not script_data.disable_time_travel and Keyboard.button(Keyboard.button_index("left shift")) > 0.5 then
		local var_8_3 = Mouse.axis_index("wheel")

		if Vector3.y(Mouse.axis(var_8_3)) > 0 then
			var_8_0 = math.min(var_8_0 + 1, #var_0_1)

			arg_8_0:set_time_scale(var_8_0)
		elseif Vector3.y(Mouse.axis(var_8_3)) < 0 and GLOBAL_TIME_SCALE > 0.0001 then
			var_8_0 = math.max(var_8_0 - 1, 1)

			arg_8_0:set_time_scale(var_8_0)
		elseif Mouse.button(Mouse.button_index("middle")) > 0.5 then
			var_8_0 = table.index_of(var_0_1, 100)

			arg_8_0:set_time_scale(var_8_0)
		end
	elseif var_8_2:is_device_active("gamepad") then
		if IS_LINUX then
			return
		end

		local var_8_4 = var_8_2:get_service("Debug")

		if var_8_4 and var_8_4:get("time_scale") then
			arg_8_0.time_scale_accumulating_value = arg_8_0.time_scale_accumulating_value + var_8_4:get("time_scale_axis") * arg_8_1 * 5

			if arg_8_0.time_scale_accumulating_value > 1 then
				var_8_0 = math.min(var_8_0 + 1, #var_0_1)

				arg_8_0:set_time_scale(var_8_0)

				arg_8_0.time_scale_accumulating_value = arg_8_0.time_scale_accumulating_value - 1
			elseif arg_8_0.time_scale_accumulating_value < -1 then
				var_8_0 = math.max(var_8_0 - 1, 1)

				arg_8_0:set_time_scale(var_8_0)

				arg_8_0.time_scale_accumulating_value = arg_8_0.time_scale_accumulating_value + 1
			end
		else
			arg_8_0.time_scale_accumulating_value = 0
		end
	end

	if DebugKeyHandler.key_pressed("page up", "speed up time", "time") then
		var_8_0 = math.min(var_8_0 + 1, #var_0_1)

		arg_8_0:set_time_scale(var_8_0)
	elseif DebugKeyHandler.key_pressed("page down", "slow down time", "time") then
		var_8_0 = math.max(var_8_0 - 1, 1)

		arg_8_0:set_time_scale(var_8_0)
	elseif DebugKeyHandler.key_pressed("home", "pause", "time") then
		var_8_1 = not var_8_1

		if var_8_1 then
			arg_8_0:set_time_paused()
		else
			arg_8_0:set_time_scale(var_8_0)
		end
	end

	if var_8_1 then
		Debug.text("Time paused. (press home to unpause)")
	else
		local var_8_5 = var_0_1[var_8_0]

		if var_8_5 ~= 100 then
			if math.ceil(var_8_5) == var_8_5 then
				Debug.text("Time scaled by " .. tostring(var_8_5) .. "%%")
			else
				local var_8_6 = string.format("Time scaled by %f", var_8_5):gsub("^(.-)0*$", "%1") .. "%%"

				Debug.text(var_8_6)
			end
		end
	end

	arg_8_0.time_paused = var_8_1
	arg_8_0.time_scale_index = var_8_0
end

DebugManager._adjust_player_speed = function (arg_9_0)
	if Keyboard.button(Keyboard.button_index("left alt")) > 0.5 then
		local var_9_0 = Mouse.axis_index("wheel")
		local var_9_1 = arg_9_0.speed_scale_index

		if Vector3.y(Mouse.axis(var_9_0)) > 0 then
			var_9_1 = math.min(var_9_1 + 1, #var_0_2)

			local var_9_2 = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for iter_9_0, iter_9_1 in pairs(var_9_2) do
				PlayerUnitMovementSettings.get_movement_settings_table(iter_9_1).player_speed_scale = var_0_2[var_9_1] * 0.01
			end
		elseif Vector3.y(Mouse.axis(var_9_0)) < 0 then
			var_9_1 = math.max(var_9_1 - 1, 1)

			local var_9_3 = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for iter_9_2, iter_9_3 in pairs(var_9_3) do
				PlayerUnitMovementSettings.get_movement_settings_table(iter_9_3).player_speed_scale = var_0_2[var_9_1] * 0.01
			end
		elseif Mouse.button(Mouse.button_index("middle")) > 0.5 then
			var_9_1 = table.index_of(var_0_2, 100)

			local var_9_4 = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for iter_9_4, iter_9_5 in pairs(var_9_4) do
				PlayerUnitMovementSettings.get_movement_settings_table(iter_9_5).player_speed_scale = var_0_2[var_9_1] * 0.01
			end
		end

		arg_9_0.speed_scale_index = var_9_1
	end
end

DebugManager._adjust_gamepad_player_speed = function (arg_10_0)
	local var_10_0 = Managers.account:active_controller()

	if not var_10_0 then
		return
	end

	local var_10_1 = var_10_0.type() == "sce_pad"
	local var_10_2

	if not IS_PS4 and not var_10_1 then
		local var_10_3 = var_10_0.button_index("right_thumb")

		var_10_2 = var_10_3 and var_10_0.button(var_10_3) > 0.5
	else
		var_10_2 = var_10_0.button(var_10_0.button_index("r3")) > 0.5
	end

	if var_10_2 then
		local var_10_4
		local var_10_5

		if not IS_PS4 and not var_10_1 then
			local var_10_6 = var_10_0.button_index("d_up")

			var_10_4 = var_10_6 and var_10_0.pressed(var_10_6)

			local var_10_7 = var_10_0.button_index("d_down")

			var_10_5 = var_10_7 and var_10_0.pressed(var_10_7)
		else
			var_10_4 = var_10_0.pressed(var_10_0.button_index("up"))
			var_10_5 = var_10_0.pressed(var_10_0.button_index("down"))
		end

		local var_10_8 = arg_10_0.speed_scale_index

		if var_10_4 then
			var_10_8 = math.min(var_10_8 + 1, #var_0_2)

			local var_10_9 = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for iter_10_0, iter_10_1 in pairs(var_10_9) do
				PlayerUnitMovementSettings.get_movement_settings_table(iter_10_1).player_speed_scale = var_0_2[var_10_8] * 0.01
			end
		elseif var_10_5 then
			var_10_8 = math.max(var_10_8 - 1, 1)

			local var_10_10 = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for iter_10_2, iter_10_3 in pairs(var_10_10) do
				PlayerUnitMovementSettings.get_movement_settings_table(iter_10_3).player_speed_scale = var_0_2[var_10_8] * 0.01
			end
		end

		arg_10_0.speed_scale_index = var_10_8
	end
end

DebugManager._update_actor_draw = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._world
	local var_11_1 = World.get_data(var_11_0, "physics_world")
	local var_11_2 = World.debug_camera_pose(var_11_0)

	for iter_11_0, iter_11_1 in pairs(arg_11_0._actor_draw) do
		PhysicsWorld.overlap(var_11_1, function (...)
			arg_11_0:_actor_draw_overlap_callback(iter_11_1, ...)
		end, "shape", "sphere", "size", iter_11_1.range, "pose", var_11_2, "types", "both", "collision_filter", iter_11_1.collision_filter)

		if iter_11_1.actors then
			local var_11_3 = arg_11_0._actor_drawer

			for iter_11_2, iter_11_3 in ipairs(iter_11_1.actors) do
				if ActorBox(iter_11_3):unbox() then
					var_11_3:actor(iter_11_3, iter_11_1.color:unbox(), var_11_2)
				end
			end
		end
	end
end

DebugManager._actor_draw_overlap_callback = function (arg_13_0, arg_13_1, arg_13_2)
	arg_13_1.actors = arg_13_2
end

DebugManager.enable_actor_draw = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0._world
	local var_14_1 = World.physics_world(var_14_0)

	PhysicsWorld.immediate_overlap(var_14_1, "shape", "sphere", "size", 0.1, "position", Vector3(0, 0, 0), "types", "both", "collision_filter", arg_14_1)

	arg_14_0._actor_drawer = arg_14_0:drawer({
		mode = "immediate",
		name = "_actor_drawer"
	})
	arg_14_0._actor_draw[arg_14_1] = {
		color = QuaternionBox(arg_14_2),
		range = arg_14_3,
		collision_filter = arg_14_1
	}
end

DebugManager.disable_actor_draw = function (arg_15_0, arg_15_1)
	arg_15_0._actor_draw[arg_15_1] = nil
end

DebugManager.color = function (arg_16_0, arg_16_1, arg_16_2)
	fassert(Unit.alive(arg_16_1), "Trying to get color from a destroyed unit")

	local var_16_0 = arg_16_2 or 255

	arg_16_0._unit_color_list = arg_16_0._unit_color_list or {}

	if not arg_16_0._unit_color_list[arg_16_1] then
		arg_16_0._unit_color_list[arg_16_1] = arg_16_0:_get_next_color_index()
	end

	local var_16_1 = arg_16_0._unit_color_list[arg_16_1]
	local var_16_2 = GameSettingsDevelopment.debug_unit_colors[var_16_1]

	return Color(var_16_0, var_16_2[1], var_16_2[2], var_16_2[3]), var_16_1
end

DebugManager._get_next_color_index = function (arg_17_0)
	for iter_17_0, iter_17_1 in pairs(arg_17_0._unit_color_list) do
		if not Unit.alive(iter_17_0) then
			arg_17_0._unit_color_list[iter_17_0] = nil
		end
	end

	for iter_17_2, iter_17_3 in pairs(GameSettingsDevelopment.debug_unit_colors) do
		if not arg_17_0:_color_index_in_use(iter_17_2) then
			return iter_17_2
		end
	end

	return 1
end

DebugManager._color_index_in_use = function (arg_18_0, arg_18_1)
	for iter_18_0, iter_18_1 in pairs(arg_18_0._unit_color_list) do
		if arg_18_1 == iter_18_1 then
			return true
		end
	end

	return false
end

DebugManager._toggle_debug_mouse_cursor = function (arg_19_0, arg_19_1)
	Window.set_show_cursor(arg_19_1)

	if arg_19_1 then
		arg_19_0._free_flight_update_global_free_flight = arg_19_0.free_flight_manager._update_global_free_flight

		arg_19_0.free_flight_manager._update_global_free_flight = function ()
			return
		end
	else
		arg_19_0.free_flight_manager._update_global_free_flight = arg_19_0._free_flight_update_global_free_flight
	end

	arg_19_0._debug_mouse_cursor = arg_19_1
end

DebugManager._update_paused_game = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_1:get("action_one")

	if not script_data.disable_debug_draw then
		arg_21_0:_update_visuals(arg_21_2)
	end
end

local var_0_4 = true

DebugManager._update_sound_debug = function (arg_22_0)
	local var_22_0 = script_data.sound_debug
	local var_22_1 = script_data.sound_cue_breakpoint

	if arg_22_0._sound_debug ~= var_22_0 or arg_22_0._sound_cue_breakpoint ~= var_22_1 or var_0_4 then
		arg_22_0._sound_debug = var_22_0
		arg_22_0._sound_cue_breakpoint = var_22_1

		local var_22_2

		var_22_2 = var_22_0 and var_22_1

		if var_22_0 then
			Debug.hook(WwiseWorld, "trigger_event", function (arg_23_0, arg_23_1, arg_23_2, ...)
				if arg_22_0._sound_debug then
					printf("[sound_debug] Played sound: %s", arg_23_2)
				end

				if arg_22_0._sound_cue_breakpoint then
					rawset(_G, "_sound_cue_breakpoint_set", rawget(_G, "_sound_cue_breakpoint_set") or {})

					_sound_cue_breakpoint_set[arg_23_2] = true

					if arg_22_0._sound_cue_breakpoint == arg_23_2 then
						Script.do_break()
					end
				end

				return arg_23_0(arg_23_1, arg_23_2, ...)
			end)
		else
			Debug.unhook(WwiseWorld, "trigger_event", true)
		end

		var_0_4 = false
	end
end

DebugManager._update_visuals = function (arg_24_0)
	local var_24_0 = Managers.state.debug:drawer({
		name = "mouse_ray_hit",
		mode = "immediate"
	})

	if arg_24_0._selected_unit then
		local var_24_1 = arg_24_0:color(arg_24_0._selected_unit)
		local var_24_2 = Unit.world_position(arg_24_0._selected_unit, 0)

		var_24_0:sphere(var_24_2, 0.2, var_24_1)

		local var_24_3 = arg_24_0._visualize_units[arg_24_0._selected_unit]

		if var_24_3 then
			local var_24_4 = var_24_3:unbox()

			var_24_0:sphere(var_24_4, 0.2, var_24_1)
		end
	end

	for iter_24_0, iter_24_1 in pairs(arg_24_0._visualize_units) do
		local var_24_5 = arg_24_0:color(iter_24_0, 100)
		local var_24_6 = Unit.world_position(iter_24_0, 0)

		var_24_0:sphere(var_24_6, 0.2, var_24_5)

		if iter_24_1 then
			local var_24_7 = iter_24_1:unbox()

			var_24_0:sphere(var_24_7, 0.2, var_24_5)
		end
	end
end

DebugManager.selected_unit = function (arg_25_0)
	return arg_25_0._selected_unit
end

DebugManager._create_screen_gui = function (arg_26_0)
	arg_26_0._screen_gui = World.create_screen_gui(arg_26_0._world, "material", "materials/fonts/gw_fonts", "immediate")
end

DebugManager.draw_screen_rect = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	if not arg_27_0._screen_gui then
		arg_27_0:_create_screen_gui()
	end

	Gui.rect(arg_27_0._screen_gui, Vector3(arg_27_1, arg_27_2, arg_27_3 or 1), Vector2(arg_27_4, arg_27_5), arg_27_6 or Color(255, 255, 255, 255))
end

DebugManager.draw_screen_text = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
	if not arg_28_0._screen_gui then
		arg_28_0:_create_screen_gui()
	end

	local var_28_0 = arg_28_7 or "hell_shark"
	local var_28_1 = UIFontByResolution({
		dynamic_font = true,
		font_type = var_28_0,
		font_size = arg_28_5
	})
	local var_28_2, var_28_3, var_28_4 = unpack(var_28_1)

	Gui.text(arg_28_0._screen_gui, arg_28_4, var_28_2, var_28_3, var_28_4, Vector3(arg_28_1, arg_28_2, arg_28_3), arg_28_6 or Color(255, 255, 255, 255))
end

DebugManager.screen_text_extents = function (arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_0._screen_gui then
		arg_29_0:_create_screen_gui()
	end

	local var_29_0, var_29_1 = Gui.text_extents(arg_29_0._screen_gui, arg_29_1, GameSettings.ingame_font.font, arg_29_2)
	local var_29_2 = var_29_1[1] - var_29_0[1]
	local var_29_3 = var_29_1[2] - var_29_0[2]

	return var_29_2, var_29_3
end

DebugManager.destroy = function (arg_30_0)
	if arg_30_0._screen_gui then
		World.destroy_gui(arg_30_0._world, arg_30_0._screen_gui)

		arg_30_0._screen_gui = nil
	end

	arg_30_0.network_event_delegate:unregister(arg_30_0)
end

DebugManager.set_time_scale = function (arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = var_0_1[arg_31_1] * 0.01

	Application.set_time_step_policy("external_multiplier", var_31_0)

	GLOBAL_TIME_SCALE = var_31_0

	if not arg_31_2 then
		local var_31_1 = NetworkLookup.debug_commands.set_time_scale

		if arg_31_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_debug_command", var_31_1, arg_31_1)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_debug_command", var_31_1, arg_31_1)
		end
	end

	arg_31_0.time_scale_index = arg_31_1
	arg_31_0.time_paused = false
end

DebugManager.set_time_paused = function (arg_32_0)
	local var_32_0 = 1e-08

	Application.set_time_step_policy("external_multiplier", var_32_0)

	GLOBAL_TIME_SCALE = var_32_0

	if arg_32_0.is_server then
		local var_32_1 = NetworkLookup.debug_commands.set_time_paused

		Managers.state.network.network_transmit:send_rpc_clients("rpc_debug_command", var_32_1, var_0_3)
	end

	arg_32_0.time_paused = true
end

DebugManager.hot_join_sync = function (arg_33_0, arg_33_1)
	local var_33_0 = NetworkLookup.debug_commands.set_time_scale

	Managers.state.network.network_transmit:send_rpc_clients("rpc_debug_command", var_33_0, arg_33_0.time_scale_index)
end

DebugManager.cycle_patched_items = function (arg_34_0, arg_34_1)
	do return end

	if not Managers.backend:is_local() then
		Debug.sticky_text("patching of ItemMasterList only works with local backend")

		return
	end

	if not arg_34_0._patched_items_list then
		arg_34_0._patched_items_list = arg_34_0:_load_patched_items_into_backend()

		local var_34_0 = Network.game_session()
		local var_34_1 = GameSession.other_peers(var_34_0)
		local var_34_2 = RPC.rpc_debug_command
		local var_34_3 = NetworkLookup.debug_commands.load_patched_items_into_backend

		for iter_34_0, iter_34_1 in ipairs(var_34_1) do
			local var_34_4 = PEER_ID_TO_CHANNEL[iter_34_1]

			var_34_2(var_34_4, var_34_3, var_0_3)
		end

		if #var_34_1 > 0 then
			arg_34_0._cycle_patch_items_at = arg_34_1 + 1

			return
		end
	end

	arg_34_0:_cycle_patched_items()
end

DebugManager._cycle_patched_items = function (arg_35_0)
	local var_35_0 = arg_35_0._patched_items_list
	local var_35_1 = arg_35_0._current_patch_item_index
	local var_35_2, var_35_3 = next(var_35_0, var_35_1)

	if var_35_3 == nil then
		var_35_2, var_35_3 = next(var_35_0)
	end

	local var_35_4 = Managers.backend:get_interface("items")
	local var_35_5 = Managers.backend:get_interface("common")
	local var_35_6 = var_35_4:get_key(var_35_3)
	local var_35_7 = ItemMasterList[var_35_6]
	local var_35_8 = Managers.player:local_player()
	local var_35_9 = var_35_8:profile_index()
	local var_35_10 = var_35_8:career_index()
	local var_35_11 = SPProfiles[var_35_9].careers[var_35_10].name

	if var_35_5:can_wield(var_35_11, var_35_7) then
		local var_35_12 = var_35_7.slot_type
		local var_35_13 = InventorySettings.slot_names_by_type[var_35_12][1]
		local var_35_14 = var_35_8.player_unit

		ScriptUnit.extension(var_35_14, "inventory_system"):create_equipment_in_slot(var_35_13, var_35_3)
		Debug.sticky_text("template:%s", var_35_7.template, "delay", 7)

		if var_35_7.right_hand_unit then
			Debug.sticky_text("right_hand_unit:%s", var_35_7.right_hand_unit, "delay", 7)
		end

		if var_35_7.left_hand_unit then
			Debug.sticky_text("left_hand_unit:%s", var_35_7.left_hand_unit, "delay", 7)
		end
	else
		Debug.sticky_text("%s can't use %s", var_35_11, var_35_6)
	end

	arg_35_0._current_patch_item_index = var_35_2
end

DebugManager.rpc_debug_command = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = NetworkLookup.debug_commands[arg_36_2]

	if var_36_0 == "load_patched_items_into_backend" then
		arg_36_0._patched_items_list = arg_36_0:_load_patched_items_into_backend()
	elseif var_36_0 == "set_time_scale" then
		local var_36_1 = arg_36_3

		arg_36_0:set_time_scale(var_36_1, true)

		if arg_36_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients_except("rpc_debug_command", CHANNEL_TO_PEER_ID[arg_36_1], arg_36_2, arg_36_3)
		end
	elseif var_36_0 == "set_time_paused" then
		arg_36_0:set_time_paused()
	end
end

DebugManager.rpc_propagate_debug_option = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	if not rawget(_G, "DebugScreen") then
		Managers.state.network.network_transmit:send_rpc("rpc_debug_option_propagation_response", CHANNEL_TO_PEER_ID[arg_37_1], "DebugScreen is missing")

		return
	end

	local var_37_0 = tonumber(arg_37_2)
	local var_37_1 = DebugScreen.handle_propagated_option(var_37_0, arg_37_3, arg_37_4, arg_37_5)

	if var_37_1 then
		Managers.state.network.network_transmit:send_rpc("rpc_debug_option_propagation_response", CHANNEL_TO_PEER_ID[arg_37_1], var_37_1)
	end
end

DebugManager.rpc_debug_option_propagation_response = function (arg_38_0, arg_38_1, arg_38_2)
	Debug.sticky_text("[DebugManager] Propagated debug option failed: %s", arg_38_2, "delay", 10)
end

DebugManager._load_patched_items_into_backend = function (arg_39_0)
	if not Managers.backend:is_local() then
		Debug.sticky_text("patching of ItemMasterList only works with local backend")

		return
	end

	local var_39_0 = {}
	local var_39_1 = dofile("scripts/settings/equipment/item_master_list_debug_patch")

	for iter_39_0, iter_39_1 in pairs(var_39_1) do
		repeat
			if rawget(ItemMasterList, iter_39_0) then
				Debug.sticky_text("name %s already exists in ItemMasterList", iter_39_0)

				break
			end

			iter_39_1.name = iter_39_0
			ItemMasterList[iter_39_0] = iter_39_1

			local var_39_2 = #NetworkLookup.item_names + 1

			NetworkLookup.item_names[var_39_2] = iter_39_0
			NetworkLookup.item_names[iter_39_0] = var_39_2

			local var_39_3 = #NetworkLookup.damage_sources + 1

			NetworkLookup.damage_sources[var_39_3] = iter_39_0
			NetworkLookup.damage_sources[iter_39_0] = var_39_3

			local var_39_4 = iter_39_1.right_hand_unit

			if var_39_4 then
				arg_39_0:_load_resource(var_39_4)
			end

			local var_39_5 = iter_39_1.left_hand_unit

			if var_39_5 then
				arg_39_0:_load_resource(var_39_5)
			end

			local var_39_6 = Managers.backend:get_interface("items"):award_item(iter_39_0)

			table.insert(var_39_0, var_39_6)
			printf("added %s: to ItemMasterList", iter_39_0)
			printf("awarded %s: to player", iter_39_0)
		until true
	end

	return var_39_0
end

DebugManager._load_resource = function (arg_40_0, arg_40_1)
	local var_40_0 = #NetworkLookup.husks + 1

	NetworkLookup.husks[var_40_0] = arg_40_1
	NetworkLookup.husks[arg_40_1] = var_40_0

	local var_40_1
	local var_40_2 = false
	local var_40_3 = true
	local var_40_4 = arg_40_1 .. "_3p"

	Managers.package:load(arg_40_1, "debug_patch", var_40_1, var_40_2, var_40_3)
	Managers.package:load(var_40_4, "debug_patch", var_40_1, var_40_2, var_40_3)
end

DebugManager.send_conflict_director_command = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	arg_41_2 = arg_41_2 or ""

	if not arg_41_3 then
		local var_41_0 = Managers.player:local_player().player_unit
		local var_41_1 = POSITION_LOOKUP[var_41_0]

		arg_41_3 = Managers.state.conflict:player_aim_raycast(arg_41_0._world, false, "filter_ray_horde_spawn") or var_41_1 or Vector3.zero()
	end

	local var_41_2 = ""
	local var_41_3 = arg_41_0.debug_breed_picker.picked_enhancements

	if var_41_3 and next(var_41_3) then
		var_41_2 = table.concat(table.keys_if(var_41_3, {}, function (arg_42_0, arg_42_1)
			return arg_42_1 == true
		end), ",")
	end

	Managers.state.network.network_transmit:send_rpc_server("rpc_debug_conflict_director_command", arg_41_1, arg_41_2, arg_41_3, var_41_2, arg_41_4 or {})
end

DebugManager._update_unit_spawning = function (arg_43_0, arg_43_1, arg_43_2)
	if DebugKeyHandler.key_pressed("o", "switch spawn breed", "ai") then
		arg_43_0.debug_breed_picker:activate()
	end

	if arg_43_0.debug_breed_picker.active and arg_43_0.is_server then
		if DebugKeyHandler.key_pressed("i", "switch spawn breed", "ai", "left shift") then
			Managers.state.conflict:cycle_debug_spawn_side()
		end

		Debug.text("Debug spawn side: %s", Managers.state.conflict.debug_spawn_side_id)
	end

	arg_43_0.debug_breed_picker:update(arg_43_2, arg_43_1)

	local var_43_0 = arg_43_0.debug_breed_picker:current_item_name()

	if DebugKeyHandler.key_pressed("p", "spawn " .. var_43_0, "ai", "left ctrl") then
		arg_43_0:send_conflict_director_command("debug_spawn_group", var_43_0)
	elseif DebugKeyHandler.key_pressed("p", "spawn " .. var_43_0, "ai", "right ctrl") then
		arg_43_0:send_conflict_director_command("debug_spawn_roaming_patrol")
	elseif DebugKeyHandler.key_pressed("p", "spawn " .. var_43_0, "ai", "left alt") then
		arg_43_0:send_conflict_director_command("debug_spawn_group_at_main_path")
	elseif DebugKeyHandler.key_pressed("p", "spawn " .. var_43_0, "ai") then
		local var_43_1 = arg_43_0.debug_breed_picker:current_item()

		if Breeds[var_43_0] then
			arg_43_0._last_debug_breed_name = var_43_0
			arg_43_0._last_current_item = arg_43_0.debug_breed_picker:current_item()
		elseif var_43_1[2] ~= "pick_enhancement" then
			var_43_1 = arg_43_0.debug_breed_picker:current_item()
		elseif arg_43_0._last_debug_breed_name then
			var_43_0 = arg_43_0._last_debug_breed_name
			var_43_1 = arg_43_0._last_current_item
		end

		arg_43_0:send_conflict_director_command("debug_spawn_breed", var_43_0, nil, var_43_1)
	elseif DebugKeyHandler.key_pressed("o", "spawn hidden " .. var_43_0, "ai", "left ctrl") then
		arg_43_0:send_conflict_director_command("debug_spawn_breed_at_hidden_spawner", var_43_0)
	end

	if DebugKeyHandler.key_pressed("u", "unspawn close AIs", "ai") then
		local var_43_2 = Managers.player:local_player().player_unit
		local var_43_3 = POSITION_LOOKUP[var_43_2]

		if not var_43_3 then
			print("can't destroy close units - player is dead")

			return
		end

		arg_43_0:send_conflict_director_command("destroy_close_units", nil, var_43_3)
	elseif DebugKeyHandler.key_pressed("l", "unspawn all AIs", "ai") then
		arg_43_0:send_conflict_director_command("destroy_all_units")
	end

	if DebugKeyHandler.key_pressed("m", "unspawn all AI specials", "ai") then
		arg_43_0:send_conflict_director_command("destroy_specials")
	end
end

DebugManager._update_bot_behavior_debug = function (arg_44_0)
	if not script_data.ai_bots_debug_behavior then
		script_data.ai_bots_debug_behavior_data = nil

		return
	end

	script_data.ai_bots_debug_behavior_data = script_data.ai_bots_debug_behavior_data or {
		time_in_heavy_attack = 0,
		time_in_light_attack = 0,
		time_spent_attacking = 0,
		ranged_attacks = 0,
		failed_ranged_attacks = 0,
		time_spent_defending = 0
	}

	local var_44_0 = 15
	local var_44_1 = 20
	local var_44_2 = 250
	local var_44_3 = Vector3(10, var_44_2, 10)
	local var_44_4 = Color(255, 130, 10)

	Debug.draw_rect(var_44_3, Vector3(340, var_44_2 + var_44_1 * 20, 0), Color(200, 0, 0, 0))

	local var_44_5 = var_44_3

	for iter_44_0, iter_44_1 in pairs(script_data.ai_bots_debug_behavior_data) do
		local var_44_6 = string.format("%s: %s", iter_44_0, iter_44_1)

		Debug.draw_text(var_44_6, var_44_5, var_44_0, var_44_4)

		var_44_5[2] = var_44_5[2] + var_44_1
	end
end

DebugManager.start_bot_behavior_scenario = function ()
	if Managers.state.game_mode:level_key() ~= "military" then
		Debug.sticky_text("ERROR: The bot behavior scenario is set up for 'military' level only.")

		return
	end

	if Managers.state.difficulty:get_difficulty() ~= "hardest" then
		Debug.sticky_text("WARNING: The bot behavior scneario is designed for Legend difficulty. The following run targets are recommended: '-set-difficulty hardest -current-difficulty-setting hardest'")

		return
	end

	script_data.ai_bots_disabled = false
	script_data.ai_pacing_disabled = true
	script_data.disable_ai_perception = true
	script_data.disable_debug_draw = false
	POSITION_LOOKUP[player_unit()] = Vector3(122.148, 87.8162, -12.8631)

	local var_45_0 = Quaternion.identity()

	Quaternion.set_xyzw(var_45_0, 0, 0, 1, -0.000214087)
	ScriptUnit.extension(player_unit(), "locomotion_system"):teleport_to(Vector3(122.148, 87.8162, -13.6631) + Quaternion.forward(var_45_0) * 2, var_45_0)

	local var_45_1 = Managers.input:get_service("FreeFlight")
	local var_45_2 = Managers.time:time("main") + 0.5
	local var_45_3 = 1
	local var_45_4 = QuaternionBox(var_45_0)
	local var_45_5 = update

	function update(...)
		local var_46_0 = var_45_5(...)

		var_45_0 = var_45_4:unbox()

		local var_46_1 = Managers.time:time("main")

		if var_45_3 == 1 then
			if var_46_1 > var_45_2 then
				Managers.state.conflict:destroy_all_units()

				local var_46_2 = Unit.local_position(player_unit(), 0)
				local var_46_3 = Quaternion.forward(var_45_0)
				local var_46_4 = Quaternion.right(var_45_0)

				for iter_46_0 = -4, 4 do
					local var_46_5 = var_46_2 + var_46_3 * 4 + var_46_4 * iter_46_0

					Managers.state.conflict:debug_spawn_breed("skaven_slave", false, var_46_5, {})
				end

				for iter_46_1 = -1.5, 1.5 do
					local var_46_6 = var_46_2 + var_46_3 * 5.5 + var_46_4 * iter_46_1

					Managers.state.conflict:debug_spawn_breed("skaven_slave", false, var_46_6, {})
				end

				for iter_46_2 = -1.5, 1.5 do
					local var_46_7 = var_46_2 + var_46_3 * 7 + var_46_4 * iter_46_2

					Managers.state.conflict:debug_spawn_breed("skaven_storm_vermin_with_shield", false, var_46_7, {})
				end

				for iter_46_3 = 0, 0 do
					local var_46_8 = var_46_2 + var_46_3 * 8.5 + var_46_4 * iter_46_3

					Managers.state.conflict:debug_spawn_breed("chaos_warrior", false, var_46_8, {})
				end

				local var_46_9 = var_45_1.get

				var_45_1.get = function (arg_47_0, arg_47_1, ...)
					if arg_47_1 == "global_free_flight_toggle" then
						var_45_1.get = var_46_9
						var_45_3 = 2

						return true
					end

					return var_46_9(arg_47_0, arg_47_1, ...)
				end
			end
		elseif var_45_3 == 2 then
			local var_46_10 = Managers.world:world(Managers.free_flight.data.global.viewport_world_name)
			local var_46_11 = ScriptWorld.global_free_flight_viewport(var_46_10)
			local var_46_12 = ScriptViewport.camera(var_46_11)

			ScriptCamera.set_local_position(var_46_12, Vector3(126.374, 80.3227, -8.77923))

			local var_46_13 = Quaternion.identity()

			Quaternion.set_xyzw(var_46_13, 0.281551, 0.111096, -0.349516, -0.886694)
			ScriptCamera.set_local_rotation(var_46_12, var_46_13)

			var_45_2 = var_46_1 + 2
			var_45_3 = 3
		elseif var_45_3 == 3 then
			if var_46_1 > var_45_2 then
				var_45_3 = 4
				script_data.disable_ai_perception = false
				var_45_2 = var_46_1 + 45
			end
		elseif var_45_3 == 4 then
			local var_46_14 = Quaternion.right(var_45_0)

			var_45_0 = Quaternion.multiply(Quaternion.axis_angle(var_46_14, math.pi * -0.4), var_45_0)

			if var_46_1 > var_45_2 then
				var_45_3 = 5
			end
		else
			local var_46_15 = var_45_1.get

			var_45_1.get = function (arg_48_0, arg_48_1, ...)
				if arg_48_1 == "global_free_flight_toggle" then
					var_45_1.get = var_46_15

					return true
				end

				return var_46_15(arg_48_0, arg_48_1, ...)
			end

			update = var_45_5
		end

		return var_46_0
	end
end
