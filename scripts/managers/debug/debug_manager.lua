-- chunkname: @scripts/managers/debug/debug_manager.lua

require("scripts/managers/debug/debug_drawer")
require("scripts/managers/debug/debug_drawer_release")
require("scripts/managers/debug/debug")
require("scripts/managers/debug/profiler_scopes")

DebugManager = class(DebugManager)

local QuickDrawer = QuickDrawer

QuickDrawer = QuickDrawer or true
QuickDrawer = QuickDrawer

local QuickDrawerStay = QuickDrawerStay

QuickDrawerStay = QuickDrawerStay or true
QuickDrawerStay = QuickDrawerStay

local tbl = {
	"rpc_debug_command",
	"rpc_propagate_debug_option",
	"rpc_debug_option_propagation_response"
}
local GLOBAL_TIME_SCALE = GLOBAL_TIME_SCALE

GLOBAL_TIME_SCALE = GLOBAL_TIME_SCALE or 1
GLOBAL_TIME_SCALE = GLOBAL_TIME_SCALE

local tbl_2 = {
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
local tbl_3 = {
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
local num = 0

DebugManager.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	self._world = arg_1_1
	self._drawers = {}
	self.free_flight_manager = arg_1_2
	self.input_manager = arg_1_3
	self.input_service = self.input_manager:get_service("Debug")
	self.is_server = arg_1_5
	self._actor_draw = {}
	self._paused = false
	self._visualize_units = {}
	QuickDrawer = self:drawer({
		name = "quick_debug",
		mode = "immediate"
	})
	QuickDrawerStay = self:drawer({
		name = "quick_debug_stay",
		mode = "retained"
	})
	self.time_paused = false
	self.time_scale_index = table.find(tbl_2, 100)
	self.time_scale_accumulating_value = 0
	self.speed_scale_index = table.find(tbl_3, 100)
	self.graph_drawer = GraphDrawer:new(arg_1_1, arg_1_3)
	self.network_event_delegate = arg_1_4

	arg_1_4:register(self, unpack(tbl))

	self.time_scale_list = tbl_2
	self._debug_updates = {}
end

DebugManager.drawer = function (self, arg_2_1)
	-- function 2
	arg_2_1 = arg_2_1 or {}

	local name = arg_2_1.name
	local var_2_1
	local DebugDrawerRelease

	if BUILD == "release" then
		DebugDrawerRelease = DebugDrawerRelease

		if not DebugDrawerRelease then
			-- Nothing
		end
	end

	DebugDrawerRelease = DebugDrawer

	::label_2_0::

	if name == nil then
		local create_line_object = World.create_line_object(self._world)

		var_2_1 = DebugDrawerRelease:new(create_line_object, arg_2_1.mode)
		self._drawers[#self._drawers + 1] = var_2_1
	elseif self._drawers[name] == nil then
		local create_line_object_2 = World.create_line_object(self._world)

		var_2_1 = DebugDrawerRelease:new(create_line_object_2, arg_2_1.mode)
		self._drawers[name] = var_2_1
	else
		var_2_1 = self._drawers[name]
	end

	return var_2_1
end

DebugManager.reset_drawer = function (self, arg_3_1)
	-- function 3
	if not self._drawers[arg_3_1] then
		self._drawers[arg_3_1]:reset()
	end
end

DebugManager.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	local num = arg_4_1 / (tbl_2[self.time_scale_index] / 100)

	if not IS_LINUX then
		return
	end

	self:update_time_scale(num)
	self:_update_sound_debug()

	if not script_data.player_mechanics_goodness_debug then
		self:_adjust_player_speed()
	end

	if not Managers.input:is_device_active("gamepad") then
		self:_adjust_gamepad_player_speed()
	end

	local var_4_1 = tbl_3[self.speed_scale_index]

	if var_4_1 ~= 100 then
		if math.ceil(var_4_1) == var_4_1 then
			Debug.text("Player speed scaled by " .. tostring(var_4_1) .. "%%")
		else
			local str = string.format("Speed scaled by %f", var_4_1):gsub("^(.-)0*$", "%1") .. "%%"

			Debug.text(str)
		end
	end

	if not script_data.debug_wwise_timestamp then
		local get_timestamp = Wwise.get_timestamp()
		local floor = math.floor(get_timestamp / 3600000)
		local num_2 = get_timestamp - floor * 1000 * 60 * 60
		local floor_2 = math.floor(num_2 / 60000)
		local num_3 = num_2 - floor_2 * 1000 * 60
		local floor_3 = math.floor(num_3 / 1000)
		local num_4 = num_3 - floor_3 * 1000

		Debug.text("Wwise Timestamp: %.2d:%.2d:%.2d.%.3d", floor, floor_2, floor_3, num_4)
	end

	if not script_data.debug_particle_simulation then
		Debug.text("Particles simulated: " .. World.num_particles(self._world))
	end

	if not script_data.debug_enemy_package_loader then
		Managers.level_transition_handler.enemy_package_loader:debug_loaded_breeds()
	end

	if not script_data.debug_pickup_package_loader then
		Managers.level_transition_handler.pickup_package_loader:debug_loaded_pickups()
	end

	if not script_data.debug_general_synced_package_loader then
		Managers.level_transition_handler.general_synced_package_loader:debug_loaded_packages()
	end

	self:_update_bot_behavior_debug()
	self:_update_actor_draw(num)

	for k, v in pairs(self._drawers) do
		v:update(self._world)
	end

	self.graph_drawer:update(self.input_service, arg_4_2)

	if not DebugKeyHandler.key_pressed("f7", "cycle patched weapons") then
		self:cycle_patched_items(arg_4_2)
	end

	local _cycle_patch_items_at = self._cycle_patch_items_at

	if not (not _cycle_patch_items_at and not (_cycle_patch_items_at < arg_4_2)) then
		self:_cycle_patched_items()

		self._cycle_patch_items_at = nil
	end

	self:_update_unit_spawning(num, arg_4_2)

	if not script_data.debug_unit and not self.is_server and not script_data.debug_behaviour_trees then
		local debug_unit = script_data.debug_unit

		if not Unit.alive(debug_unit) then
			local action = ScriptUnit.extension(debug_unit, "ai_system"):blackboard().action

			if not action then
				Debug.text(action.name)
			end
		end
	end

	local active = self.free_flight_manager:active("global")

	if (active or not self._in_free_flight) and not script_data.has_mouse then
		self:_toggle_debug_mouse_cursor(false)
	end

	for k_2, v_2 in pairs(self._debug_updates) do
		v_2(num, arg_4_2)
	end

	self:_clear_debug_draws()

	self._in_free_flight = active

	if not active then
		return
	end

	local input_source = Managers.player:player_from_peer_id(Network.peer_id()).input_source

	if not input_source then
		-- Nothing
	end

	::label_4_0::

	local has = input_source:has("debug_mouse_cursor")

	has = not has and input_source:get("debug_mouse_cursor")

	::label_4_1::

	if not has and not script_data.has_mouse then
		local flag = not self._debug_mouse_cursor

		self:_toggle_debug_mouse_cursor(flag)
	end

	self:_update_paused_game(input_source, num)
end

DebugManager._clear_debug_draws = function (arg_5_0)
	-- function 5
	if not DebugKeyHandler.key_pressed("x", "clear quickdraw", "ai debugger", nil, "FreeFlight") then
		QuickDrawerStay:reset()
		Debug.reset_sticky_world_texts()
	end
end

DebugManager.register_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_0._debug_updates[arg_6_1] = arg_6_2
end

DebugManager.unregister_update = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_0._debug_updates[arg_7_1] = nil
end

DebugManager.update_time_scale = function (self, arg_8_1)
	-- function 8
	local time_scale_index = self.time_scale_index

	if not not self._disable_time_travel ~= not not script_data.disable_time_travel then
		self._disable_time_travel = not not script_data.disable_time_travel
		time_scale_index = table.index_of(tbl_2, 100)

		self:set_time_scale(time_scale_index)
	end

	local time_paused = self.time_paused
	local input = Managers.input

	if not (script_data.disable_time_travel or not (Keyboard.button(Keyboard.button_index("left shift")) > 0.5)) then
		local axis_index = Mouse.axis_index("wheel")

		if Vector3.y(Mouse.axis(axis_index)) > 0 then
			time_scale_index = math.min(time_scale_index + 1, #tbl_2)

			self:set_time_scale(time_scale_index)
		elseif not (not (Vector3.y(Mouse.axis(axis_index)) < 0) or not (GLOBAL_TIME_SCALE > 0.0001)) then
			time_scale_index = math.max(time_scale_index - 1, 1)

			self:set_time_scale(time_scale_index)
		elseif Mouse.button(Mouse.button_index("middle")) > 0.5 then
			time_scale_index = table.index_of(tbl_2, 100)

			self:set_time_scale(time_scale_index)
		end
	elseif not input:is_device_active("gamepad") then
		if not IS_LINUX then
			return
		end

		local get_service = input:get_service("Debug")

		if not get_service and not get_service:get("time_scale") then
			self.time_scale_accumulating_value = self.time_scale_accumulating_value + get_service:get("time_scale_axis") * arg_8_1 * 5

			if self.time_scale_accumulating_value > 1 then
				time_scale_index = math.min(time_scale_index + 1, #tbl_2)

				self:set_time_scale(time_scale_index)

				self.time_scale_accumulating_value = self.time_scale_accumulating_value - 1
			elseif self.time_scale_accumulating_value < -1 then
				time_scale_index = math.max(time_scale_index - 1, 1)

				self:set_time_scale(time_scale_index)

				self.time_scale_accumulating_value = self.time_scale_accumulating_value + 1
			end
		else
			self.time_scale_accumulating_value = 0
		end
	end

	if not DebugKeyHandler.key_pressed("page up", "speed up time", "time") then
		time_scale_index = math.min(time_scale_index + 1, #tbl_2)

		self:set_time_scale(time_scale_index)
	elseif not DebugKeyHandler.key_pressed("page down", "slow down time", "time") then
		time_scale_index = math.max(time_scale_index - 1, 1)

		self:set_time_scale(time_scale_index)
	elseif not DebugKeyHandler.key_pressed("home", "pause", "time") then
		time_paused = not time_paused

		if not time_paused then
			self:set_time_paused()
		else
			self:set_time_scale(time_scale_index)
		end
	end

	if not time_paused then
		Debug.text("Time paused. (press home to unpause)")
	else
		local var_8_5 = tbl_2[time_scale_index]

		if var_8_5 ~= 100 then
			if math.ceil(var_8_5) == var_8_5 then
				Debug.text("Time scaled by " .. tostring(var_8_5) .. "%%")
			else
				local str = string.format("Time scaled by %f", var_8_5):gsub("^(.-)0*$", "%1") .. "%%"

				Debug.text(str)
			end
		end
	end

	self.time_paused = time_paused
	self.time_scale_index = time_scale_index
end

DebugManager._adjust_player_speed = function (self)
	-- function 9
	if Keyboard.button(Keyboard.button_index("left alt")) > 0.5 then
		local axis_index = Mouse.axis_index("wheel")
		local speed_scale_index = self.speed_scale_index

		if Vector3.y(Mouse.axis(axis_index)) > 0 then
			speed_scale_index = math.min(speed_scale_index + 1, #tbl_3)

			local get_active_units_in_movement_settings = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for k, v in pairs(get_active_units_in_movement_settings) do
				PlayerUnitMovementSettings.get_movement_settings_table(v).player_speed_scale = tbl_3[speed_scale_index] * 0.01
			end
		elseif Vector3.y(Mouse.axis(axis_index)) < 0 then
			speed_scale_index = math.max(speed_scale_index - 1, 1)

			local get_active_units_in_movement_settings_2 = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for k_2, v_2 in pairs(get_active_units_in_movement_settings_2) do
				PlayerUnitMovementSettings.get_movement_settings_table(v_2).player_speed_scale = tbl_3[speed_scale_index] * 0.01
			end
		elseif Mouse.button(Mouse.button_index("middle")) > 0.5 then
			speed_scale_index = table.index_of(tbl_3, 100)

			local get_active_units_in_movement_settings_3 = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for k_3, v_3 in pairs(get_active_units_in_movement_settings_3) do
				PlayerUnitMovementSettings.get_movement_settings_table(v_3).player_speed_scale = tbl_3[speed_scale_index] * 0.01
			end
		end

		self.speed_scale_index = speed_scale_index
	end
end

DebugManager._adjust_gamepad_player_speed = function (self)
	-- function 10
	local active_controller = Managers.account:active_controller()

	if not active_controller then
		return
	end

	local flag = active_controller.type() == "sce_pad"
	local var_10_2

	if not (IS_PS4 or flag) then
		local button_index = active_controller.button_index("right_thumb")

		var_10_2 = not button_index and active_controller.button(button_index) > 0.5
	else
		var_10_2 = active_controller.button(active_controller.button_index("r3")) > 0.5
	end

	if not var_10_2 then
		local var_10_4
		local var_10_5

		if not (IS_PS4 or flag) then
			local button_index_2 = active_controller.button_index("d_up")

			var_10_4 = not button_index_2 and active_controller.pressed(button_index_2)

			local button_index_3 = active_controller.button_index("d_down")

			var_10_5 = not button_index_3 and active_controller.pressed(button_index_3)
		else
			var_10_4 = active_controller.pressed(active_controller.button_index("up"))
			var_10_5 = active_controller.pressed(active_controller.button_index("down"))
		end

		local speed_scale_index = self.speed_scale_index

		if not var_10_4 then
			speed_scale_index = math.min(speed_scale_index + 1, #tbl_3)

			local get_active_units_in_movement_settings = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for k, v in pairs(get_active_units_in_movement_settings) do
				PlayerUnitMovementSettings.get_movement_settings_table(v).player_speed_scale = tbl_3[speed_scale_index] * 0.01
			end
		elseif not var_10_5 then
			speed_scale_index = math.max(speed_scale_index - 1, 1)

			local get_active_units_in_movement_settings_2 = PlayerUnitMovementSettings.get_active_units_in_movement_settings()

			for k_2, v_2 in pairs(get_active_units_in_movement_settings_2) do
				PlayerUnitMovementSettings.get_movement_settings_table(v_2).player_speed_scale = tbl_3[speed_scale_index] * 0.01
			end
		end

		self.speed_scale_index = speed_scale_index
	end
end

DebugManager._update_actor_draw = function (self, arg_11_1)
	-- function 11
	local _world = self._world
	local get_data = World.get_data(_world, "physics_world")
	local debug_camera_pose = World.debug_camera_pose(_world)

	for k, v in pairs(self._actor_draw) do
		PhysicsWorld.overlap(get_data, function (...)
			-- function 12
			self:_actor_draw_overlap_callback(v, ...)
		end, "shape", "sphere", "size", v.range, "pose", debug_camera_pose, "types", "both", "collision_filter", v.collision_filter)

		if not v.actors then
			local _actor_drawer = self._actor_drawer

			for i, v_2 in ipairs(v.actors) do
				if not ActorBox(v_2):unbox() then
					_actor_drawer:actor(v_2, v.color:unbox(), debug_camera_pose)
				end
			end
		end
	end
end

DebugManager._actor_draw_overlap_callback = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	arg_13_1.actors = arg_13_2
end

DebugManager.enable_actor_draw = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local _world = self._world
	local physics_world = World.physics_world(_world)

	PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "size", 0.1, "position", Vector3(0, 0, 0), "types", "both", "collision_filter", arg_14_1)

	self._actor_drawer = self:drawer({
		mode = "immediate",
		name = "_actor_drawer"
	})
	self._actor_draw[arg_14_1] = {
		color = QuaternionBox(arg_14_2),
		range = arg_14_3,
		collision_filter = arg_14_1
	}
end

DebugManager.disable_actor_draw = function (arg_15_0, arg_15_1)
	-- function 15
	arg_15_0._actor_draw[arg_15_1] = nil
end

DebugManager.color = function (self, arg_16_1, arg_16_2)
	-- function 16
	fassert(Unit.alive(arg_16_1), "Trying to get color from a destroyed unit")

	local flag = arg_16_2 or 255
	local _unit_color_list = self._unit_color_list

	_unit_color_list = _unit_color_list or {}
	self._unit_color_list = _unit_color_list

	if not self._unit_color_list[arg_16_1] then
		self._unit_color_list[arg_16_1] = self:_get_next_color_index()
	end

	local var_16_2 = self._unit_color_list[arg_16_1]
	local var_16_3 = GameSettingsDevelopment.debug_unit_colors[var_16_2]

	return Color(flag, var_16_3[1], var_16_3[2], var_16_3[3]), var_16_2
end

DebugManager._get_next_color_index = function (self)
	-- function 17
	for k, v in pairs(self._unit_color_list) do
		if not Unit.alive(k) then
			self._unit_color_list[k] = nil
		end
	end

	for k_2, v_2 in pairs(GameSettingsDevelopment.debug_unit_colors) do
		if not self:_color_index_in_use(k_2) then
			return k_2
		end
	end

	return 1
end

DebugManager._color_index_in_use = function (self, arg_18_1)
	-- function 18
	for k, v in pairs(self._unit_color_list) do
		if arg_18_1 == v then
			return true
		end
	end

	return false
end

DebugManager._toggle_debug_mouse_cursor = function (self, arg_19_1)
	-- function 19
	Window.set_show_cursor(arg_19_1)

	if not arg_19_1 then
		self._free_flight_update_global_free_flight = self.free_flight_manager._update_global_free_flight

		self.free_flight_manager._update_global_free_flight = function ()
			-- function 20
			return
		end
	else
		self.free_flight_manager._update_global_free_flight = self._free_flight_update_global_free_flight
	end

	self._debug_mouse_cursor = arg_19_1
end

DebugManager._update_paused_game = function (self, arg_21_1, arg_21_2)
	-- function 21
	local get = arg_21_1:get("action_one")

	if not script_data.disable_debug_draw then
		self:_update_visuals(arg_21_2)
	end
end

local flag = true

DebugManager._update_sound_debug = function (self)
	-- function 22
	local sound_debug = script_data.sound_debug
	local sound_cue_breakpoint = script_data.sound_cue_breakpoint

	if self._sound_debug ~= sound_debug or self._sound_cue_breakpoint ~= sound_cue_breakpoint or not flag then
		self._sound_debug = sound_debug
		self._sound_cue_breakpoint = sound_cue_breakpoint

		local flag_2

		flag_2 = not sound_debug and sound_cue_breakpoint

		if not sound_debug then
			Debug.hook(WwiseWorld, "trigger_event", function (arg_23_0, arg_23_1, arg_23_2, ...)
				-- function 23
				if not self._sound_debug then
					printf("[sound_debug] Played sound: %s", arg_23_2)
				end

				if not self._sound_cue_breakpoint then
					local rawset = rawset
					local _G = _G
					local str = "_sound_cue_breakpoint_set"
					local var_23_3 = rawget(_G, "_sound_cue_breakpoint_set")

					var_23_3 = var_23_3 or {}

					rawset(_G, str, var_23_3)

					_sound_cue_breakpoint_set[arg_23_2] = true

					if self._sound_cue_breakpoint == arg_23_2 then
						Script.do_break()
					end
				end

				return arg_23_0(arg_23_1, arg_23_2, ...)
			end)
		else
			Debug.unhook(WwiseWorld, "trigger_event", true)
		end

		flag = false
	end
end

DebugManager._update_visuals = function (self)
	-- function 24
	local drawer = Managers.state.debug:drawer({
		name = "mouse_ray_hit",
		mode = "immediate"
	})

	if not self._selected_unit then
		local color = self:color(self._selected_unit)
		local world_position = Unit.world_position(self._selected_unit, 0)

		drawer:sphere(world_position, 0.2, color)

		local var_24_3 = self._visualize_units[self._selected_unit]

		if not var_24_3 then
			local unbox = var_24_3:unbox()

			drawer:sphere(unbox, 0.2, color)
		end
	end

	for k, v in pairs(self._visualize_units) do
		local color_2 = self:color(k, 100)
		local world_position_2 = Unit.world_position(k, 0)

		drawer:sphere(world_position_2, 0.2, color_2)

		if not v then
			local unbox_2 = v:unbox()

			drawer:sphere(unbox_2, 0.2, color_2)
		end
	end
end

DebugManager.selected_unit = function (self)
	-- function 25
	return self._selected_unit
end

DebugManager._create_screen_gui = function (self)
	-- function 26
	self._screen_gui = World.create_screen_gui(self._world, "material", "materials/fonts/gw_fonts", "immediate")
end

DebugManager.draw_screen_rect = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	-- function 27
	if not self._screen_gui then
		self:_create_screen_gui()
	end

	Gui.rect(self._screen_gui, Vector3(arg_27_1, arg_27_2, arg_27_3 or 1), Vector2(arg_27_4, arg_27_5), arg_27_6 or Color(255, 255, 255, 255))
end

DebugManager.draw_screen_text = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
	-- function 28
	if not self._screen_gui then
		self:_create_screen_gui()
	end

	local flag = arg_28_7 or "hell_shark"
	local var_28_1 = UIFontByResolution({
		dynamic_font = true,
		font_type = flag,
		font_size = arg_28_5
	})
	local var_28_2, var_28_3, var_28_4 = unpack(var_28_1)

	Gui.text(self._screen_gui, arg_28_4, var_28_2, var_28_3, var_28_4, Vector3(arg_28_1, arg_28_2, arg_28_3), arg_28_6 or Color(255, 255, 255, 255))
end

DebugManager.screen_text_extents = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not self._screen_gui then
		self:_create_screen_gui()
	end

	local text_extents, var_29_1 = Gui.text_extents(self._screen_gui, arg_29_1, GameSettings.ingame_font.font, arg_29_2)
	local num = var_29_1[1] - text_extents[1]
	local num_2 = var_29_1[2] - text_extents[2]

	return num, num_2
end

DebugManager.destroy = function (self)
	-- function 30
	if not self._screen_gui then
		World.destroy_gui(self._world, self._screen_gui)

		self._screen_gui = nil
	end

	self.network_event_delegate:unregister(self)
end

DebugManager.set_time_scale = function (self, arg_31_1, arg_31_2)
	-- function 31
	local num = tbl_2[arg_31_1] * 0.01

	Application.set_time_step_policy("external_multiplier", num)

	GLOBAL_TIME_SCALE = num

	if arg_31_2 or not Managers.state.network:game() then
		local set_time_scale = NetworkLookup.debug_commands.set_time_scale

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_debug_command", set_time_scale, arg_31_1)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_debug_command", set_time_scale, arg_31_1)
		end
	end

	self.time_scale_index = arg_31_1
	self.time_paused = false
end

DebugManager.set_time_paused = function (self)
	-- function 32
	local num_2 = 1e-08

	Application.set_time_step_policy("external_multiplier", num_2)

	GLOBAL_TIME_SCALE = num_2

	if not self.is_server then
		local set_time_paused = NetworkLookup.debug_commands.set_time_paused

		Managers.state.network.network_transmit:send_rpc_clients("rpc_debug_command", set_time_paused, num)
	end

	self.time_paused = true
end

DebugManager.hot_join_sync = function (self, arg_33_1)
	-- function 33
	local set_time_scale = NetworkLookup.debug_commands.set_time_scale

	Managers.state.network.network_transmit:send_rpc_clients("rpc_debug_command", set_time_scale, self.time_scale_index)
end

DebugManager.cycle_patched_items = function (self, arg_34_1)
	-- function 34
	do return end

	if not Managers.backend:is_local() then
		Debug.sticky_text("patching of ItemMasterList only works with local backend")

		return
	end

	if not self._patched_items_list then
		self._patched_items_list = self:_load_patched_items_into_backend()

		local game_session = Network.game_session()
		local other_peers = GameSession.other_peers(game_session)
		local rpc_debug_command = RPC.rpc_debug_command
		local load_patched_items_into_backend = NetworkLookup.debug_commands.load_patched_items_into_backend

		for i, v in ipairs(other_peers) do
			local var_34_4 = PEER_ID_TO_CHANNEL[v]

			rpc_debug_command(var_34_4, load_patched_items_into_backend, num)
		end

		if #other_peers > 0 then
			self._cycle_patch_items_at = arg_34_1 + 1

			return
		end
	end

	self:_cycle_patched_items()
end

DebugManager._cycle_patched_items = function (self)
	-- function 35
	local _patched_items_list = self._patched_items_list
	local _current_patch_item_index = self._current_patch_item_index
	local var_35_2, var_35_3 = next(_patched_items_list, _current_patch_item_index)

	if var_35_3 == nil then
		var_35_2, var_35_3 = next(_patched_items_list)
	end

	local get_interface = Managers.backend:get_interface("items")
	local get_interface_2 = Managers.backend:get_interface("common")
	local get_key = get_interface:get_key(var_35_3)
	local var_35_7 = ItemMasterList[get_key]
	local local_player = Managers.player:local_player()
	local profile_index = local_player:profile_index()
	local career_index = local_player:career_index()
	local name = SPProfiles[profile_index].careers[career_index].name

	if not get_interface_2:can_wield(name, var_35_7) then
		local slot_type = var_35_7.slot_type
		local var_35_13 = InventorySettings.slot_names_by_type[slot_type][1]
		local player_unit = local_player.player_unit

		ScriptUnit.extension(player_unit, "inventory_system"):create_equipment_in_slot(var_35_13, var_35_3)
		Debug.sticky_text("template:%s", var_35_7.template, "delay", 7)

		if not var_35_7.right_hand_unit then
			Debug.sticky_text("right_hand_unit:%s", var_35_7.right_hand_unit, "delay", 7)
		end

		if not var_35_7.left_hand_unit then
			Debug.sticky_text("left_hand_unit:%s", var_35_7.left_hand_unit, "delay", 7)
		end
	else
		Debug.sticky_text("%s can't use %s", name, get_key)
	end

	self._current_patch_item_index = var_35_2
end

DebugManager.rpc_debug_command = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	local var_36_0 = NetworkLookup.debug_commands[arg_36_2]

	if var_36_0 == "load_patched_items_into_backend" then
		self._patched_items_list = self:_load_patched_items_into_backend()
	elseif var_36_0 == "set_time_scale" then
		local var_36_1 = arg_36_3

		self:set_time_scale(var_36_1, true)

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients_except("rpc_debug_command", CHANNEL_TO_PEER_ID[arg_36_1], arg_36_2, arg_36_3)
		end
	elseif var_36_0 == "set_time_paused" then
		self:set_time_paused()
	end
end

DebugManager.rpc_propagate_debug_option = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	-- function 37
	if not rawget(_G, "DebugScreen") then
		Managers.state.network.network_transmit:send_rpc("rpc_debug_option_propagation_response", CHANNEL_TO_PEER_ID[arg_37_1], "DebugScreen is missing")

		return
	end

	local var_37_0 = tonumber(arg_37_2)
	local handle_propagated_option = DebugScreen.handle_propagated_option(var_37_0, arg_37_3, arg_37_4, arg_37_5)

	if not handle_propagated_option then
		Managers.state.network.network_transmit:send_rpc("rpc_debug_option_propagation_response", CHANNEL_TO_PEER_ID[arg_37_1], handle_propagated_option)
	end
end

DebugManager.rpc_debug_option_propagation_response = function (arg_38_0, arg_38_1, arg_38_2)
	-- function 38
	Debug.sticky_text("[DebugManager] Propagated debug option failed: %s", arg_38_2, "delay", 10)
end

DebugManager._load_patched_items_into_backend = function (self)
	-- function 39
	if not Managers.backend:is_local() then
		Debug.sticky_text("patching of ItemMasterList only works with local backend")

		return
	end

	local tbl = {}
	local var_39_1 = dofile("scripts/settings/equipment/item_master_list_debug_patch")

	for k, v in pairs(var_39_1) do
		repeat
			if not rawget(ItemMasterList, k) then
				Debug.sticky_text("name %s already exists in ItemMasterList", k)

				break
			end

			v.name = k
			ItemMasterList[k] = v

			local num = #NetworkLookup.item_names + 1

			NetworkLookup.item_names[num] = k
			NetworkLookup.item_names[k] = num

			local num_2 = #NetworkLookup.damage_sources + 1

			NetworkLookup.damage_sources[num_2] = k
			NetworkLookup.damage_sources[k] = num_2

			local right_hand_unit = v.right_hand_unit

			if not right_hand_unit then
				self:_load_resource(right_hand_unit)
			end

			local left_hand_unit = v.left_hand_unit

			if not left_hand_unit then
				self:_load_resource(left_hand_unit)
			end

			local award_item = Managers.backend:get_interface("items"):award_item(k)

			table.insert(tbl, award_item)
			printf("added %s: to ItemMasterList", k)
			printf("awarded %s: to player", k)
		until true
	end

	return tbl
end

DebugManager._load_resource = function (arg_40_0, arg_40_1)
	-- function 40
	local num = #NetworkLookup.husks + 1

	NetworkLookup.husks[num] = arg_40_1
	NetworkLookup.husks[arg_40_1] = num

	local var_40_1
	local flag = false
	local flag_2 = true
	local str = arg_40_1 .. "_3p"

	Managers.package:load(arg_40_1, "debug_patch", var_40_1, flag, flag_2)
	Managers.package:load(str, "debug_patch", var_40_1, flag, flag_2)
end

DebugManager.send_conflict_director_command = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	arg_41_2 = arg_41_2 or ""

	if not arg_41_3 then
		local player_unit = Managers.player:local_player().player_unit
		local var_41_1 = POSITION_LOOKUP[player_unit]

		arg_41_3 = Managers.state.conflict:player_aim_raycast(self._world, false, "filter_ray_horde_spawn") or var_41_1 or Vector3.zero()
	end

	local str = ""
	local picked_enhancements = self.debug_breed_picker.picked_enhancements

	if not picked_enhancements and not next(picked_enhancements) then
		str = table.concat(table.keys_if(picked_enhancements, {}, function (arg_42_0, arg_42_1)
			-- function 42
			return arg_42_1 == true
		end), ",")
	end

	Managers.state.network.network_transmit:send_rpc_server("rpc_debug_conflict_director_command", arg_41_1, arg_41_2, arg_41_3, str, arg_41_4 or {})
end

DebugManager._update_unit_spawning = function (self, arg_43_1, arg_43_2)
	-- function 43
	if not DebugKeyHandler.key_pressed("o", "switch spawn breed", "ai") then
		self.debug_breed_picker:activate()
	end

	if not self.debug_breed_picker.active and not self.is_server then
		if not DebugKeyHandler.key_pressed("i", "switch spawn breed", "ai", "left shift") then
			Managers.state.conflict:cycle_debug_spawn_side()
		end

		Debug.text("Debug spawn side: %s", Managers.state.conflict.debug_spawn_side_id)
	end

	self.debug_breed_picker:update(arg_43_2, arg_43_1)

	local current_item_name = self.debug_breed_picker:current_item_name()

	if not DebugKeyHandler.key_pressed("p", "spawn " .. current_item_name, "ai", "left ctrl") then
		self:send_conflict_director_command("debug_spawn_group", current_item_name)
	elseif not DebugKeyHandler.key_pressed("p", "spawn " .. current_item_name, "ai", "right ctrl") then
		self:send_conflict_director_command("debug_spawn_roaming_patrol")
	elseif not DebugKeyHandler.key_pressed("p", "spawn " .. current_item_name, "ai", "left alt") then
		self:send_conflict_director_command("debug_spawn_group_at_main_path")
	elseif not DebugKeyHandler.key_pressed("p", "spawn " .. current_item_name, "ai") then
		local current_item = self.debug_breed_picker:current_item()

		if not Breeds[current_item_name] then
			self._last_debug_breed_name = current_item_name
			self._last_current_item = self.debug_breed_picker:current_item()
		elseif current_item[2] ~= "pick_enhancement" then
			current_item = self.debug_breed_picker:current_item()
		elseif not self._last_debug_breed_name then
			current_item_name = self._last_debug_breed_name
			current_item = self._last_current_item
		end

		self:send_conflict_director_command("debug_spawn_breed", current_item_name, nil, current_item)
	elseif not DebugKeyHandler.key_pressed("o", "spawn hidden " .. current_item_name, "ai", "left ctrl") then
		self:send_conflict_director_command("debug_spawn_breed_at_hidden_spawner", current_item_name)
	end

	if not DebugKeyHandler.key_pressed("u", "unspawn close AIs", "ai") then
		local player_unit = Managers.player:local_player().player_unit
		local var_43_3 = POSITION_LOOKUP[player_unit]

		if not var_43_3 then
			print("can't destroy close units - player is dead")

			return
		end

		self:send_conflict_director_command("destroy_close_units", nil, var_43_3)
	elseif not DebugKeyHandler.key_pressed("l", "unspawn all AIs", "ai") then
		self:send_conflict_director_command("destroy_all_units")
	end

	if not DebugKeyHandler.key_pressed("m", "unspawn all AI specials", "ai") then
		self:send_conflict_director_command("destroy_specials")
	end
end

DebugManager._update_bot_behavior_debug = function (arg_44_0)
	-- function 44
	if not script_data.ai_bots_debug_behavior then
		script_data.ai_bots_debug_behavior_data = nil

		return
	end

	local script_data = script_data
	local ai_bots_debug_behavior_data = script_data.ai_bots_debug_behavior_data

	ai_bots_debug_behavior_data = ai_bots_debug_behavior_data or {
		time_in_heavy_attack = 0,
		time_in_light_attack = 0,
		time_spent_attacking = 0,
		ranged_attacks = 0,
		failed_ranged_attacks = 0,
		time_spent_defending = 0
	}
	script_data.ai_bots_debug_behavior_data = ai_bots_debug_behavior_data

	local num = 15
	local num_2 = 20
	local num_3 = 250
	local var_44_5 = Vector3(10, num_3, 10)
	local var_44_6 = Color(255, 130, 10)

	Debug.draw_rect(var_44_5, Vector3(340, num_3 + num_2 * 20, 0), Color(200, 0, 0, 0))

	local var_44_7 = var_44_5

	for k, v in pairs(script_data.ai_bots_debug_behavior_data) do
		local format = string.format("%s: %s", k, v)

		Debug.draw_text(format, var_44_7, num, var_44_6)

		var_44_7[2] = var_44_7[2] + num_2
	end
end

DebugManager.start_bot_behavior_scenario = function ()
	-- function 45
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

	local identity = Quaternion.identity()

	Quaternion.set_xyzw(identity, 0, 0, 1, -0.000214087)
	ScriptUnit.extension(player_unit(), "locomotion_system"):teleport_to(Vector3(122.148, 87.8162, -13.6631) + Quaternion.forward(identity) * 2, identity)

	local get_service = Managers.input:get_service("FreeFlight")
	local num = Managers.time:time("main") + 0.5
	local num_2 = 1
	local var_45_4 = QuaternionBox(identity)
	local update = update

	function update(...)
		-- function 46
		local var_46_0 = update(...)

		identity = var_45_4:unbox()

		local time = Managers.time:time("main")

		if num_2 == 1 then
			if time > num then
				Managers.state.conflict:destroy_all_units()

				local local_position = Unit.local_position(player_unit(), 0)
				local forward = Quaternion.forward(identity)
				local right = Quaternion.right(identity)

				for i = -4, 4 do
					local num_3 = local_position + forward * 4 + right * i

					Managers.state.conflict:debug_spawn_breed("skaven_slave", false, num_3, {})
				end

				for j = -1.5, 1.5 do
					local num_4 = local_position + forward * 5.5 + right * j

					Managers.state.conflict:debug_spawn_breed("skaven_slave", false, num_4, {})
				end

				for k = -1.5, 1.5 do
					local num_5 = local_position + forward * 7 + right * k

					Managers.state.conflict:debug_spawn_breed("skaven_storm_vermin_with_shield", false, num_5, {})
				end

				for l = 0, 0 do
					local num_6 = local_position + forward * 8.5 + right * l

					Managers.state.conflict:debug_spawn_breed("chaos_warrior", false, num_6, {})
				end

				local get = get_service.get

				get_service.get = function (arg_47_0, arg_47_1, ...)
					-- function 47
					if arg_47_1 == "global_free_flight_toggle" then
						get_service.get = get
						num_2 = 2

						return true
					end

					return get(arg_47_0, arg_47_1, ...)
				end
			end
		elseif num_2 == 2 then
			local world = Managers.world:world(Managers.free_flight.data.global.viewport_world_name)
			local global_free_flight_viewport = ScriptWorld.global_free_flight_viewport(world)
			local camera = ScriptViewport.camera(global_free_flight_viewport)

			ScriptCamera.set_local_position(camera, Vector3(126.374, 80.3227, -8.77923))

			local identity_2 = Quaternion.identity()

			Quaternion.set_xyzw(identity_2, 0.281551, 0.111096, -0.349516, -0.886694)
			ScriptCamera.set_local_rotation(camera, identity_2)

			num = time + 2
			num_2 = 3
		elseif num_2 == 3 then
			if time > num then
				num_2 = 4
				script_data.disable_ai_perception = false
				num = time + 45
			end
		elseif num_2 == 4 then
			local right_2 = Quaternion.right(identity)

			identity = Quaternion.multiply(Quaternion.axis_angle(right_2, math.pi * -0.4), identity)

			if time > num then
				num_2 = 5
			end
		else
			local get_2 = get_service.get

			get_service.get = function (arg_48_0, arg_48_1, ...)
				-- function 48
				if arg_48_1 == "global_free_flight_toggle" then
					get_service.get = get_2

					return true
				end

				return get_2(arg_48_0, arg_48_1, ...)
			end

			update = update
		end

		return var_46_0
	end
end
