-- chunkname: @scripts/utils/ai_debugger.lua

require("scripts/utils/script_gui")
require("scripts/utils/draw_ai_behavior")

local script_data = script_data
local ai_debugger_freeflight_only = script_data.ai_debugger_freeflight_only

ai_debugger_freeflight_only = ai_debugger_freeflight_only or Development.parameter("ai_debugger_freeflight_only")
script_data.ai_debugger_freeflight_only = ai_debugger_freeflight_only

local num = 26
local num_2 = 22
local num_3 = 16
local str = "arial"
local str_2 = "materials/fonts/" .. str

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	local num = 0

	for k, v in pairs(self) do
		num = num + 1
		arg_1_1[num] = tostring(k)
	end

	table.sort(arg_1_1)

	for k_2 = 1, num do
		arg_1_2[k_2] = self[arg_1_1[k_2]]
	end

	return num
end

AIDebugger = class(AIDebugger)

AIDebugger.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	self.free_flight_manager = arg_2_5
	self.is_server = arg_2_4
	self.world = arg_2_1
	self.nav_world = arg_2_2
	self.group_blackboard = arg_2_3
	self.world_gui = World.create_world_gui(arg_2_1, Matrix4x4.identity(), 1, 1, "immediate", "material", "materials/fonts/gw_fonts")
	self.screen_gui = World.create_screen_gui(self.world, "material", "materials/fonts/gw_fonts", "immediate")
	self.show_navmesh = false
	self.show_extensions = false
	self.cycle_info = 0
	self.show_slots = false
	self.follow_active = false
	self.show_behavior_tree = false
	self.hint_time_when_key_handle_visible = 0
end

AIDebugger.lazy_create_drawer = function (self)
	-- function 3
	if not self.drawer then
		return
	end

	self.drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AIDebugger"
	})
end

AIDebugger.destroy = function (arg_4_0)
	-- function 4
	return
end

AIDebugger.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:lazy_create_drawer()

	if not Unit.alive(script_data.debug_unit) then
		local debug_unit = script_data.debug_unit
		local has_extension = ScriptUnit.has_extension(debug_unit, "ai_system")
		local flag = not has_extension and has_extension._breed

		if not flag then
			local var_5_3 = BLACKBOARDS[debug_unit]

			if not var_5_3 and not var_5_3.mode then
				Debug.text("debug_unit = %s, mode=%s, phase=%s", flag.name, tostring(var_5_3.mode), tostring(var_5_3.phase))
			else
				Debug.text("script_data.debug_unit = %s", flag.name)
			end
		else
			Debug.text("script_data.debug_unit = %s", tostring(debug_unit))
		end
	end

	local active = self.free_flight_manager:active("global")

	if not active then
		local get_service = self.free_flight_manager.input_manager:get_service("FreeFlight")

		self:update_selection(get_service, arg_5_2)
		self:update_mouse_input(get_service)
		self:draw_reticule()
		self:draw_hint(arg_5_1)

		if not self.follow_active and not Unit.alive(self.active_unit) then
			local global_free_flight_viewport = ScriptWorld.global_free_flight_viewport(self.world)
			local camera = ScriptViewport.camera(global_free_flight_viewport)
			local local_pose = Unit.local_pose(self.active_unit, 0)
			local translation = Matrix4x4.translation(local_pose)
			local num = translation - Matrix4x4.forward(local_pose) * 4 + Vector3.up() * 3

			Matrix4x4.set_translation(local_pose, num)

			local normalize = Vector3.normalize(translation + Vector3.up() - num)
			local look = Quaternion.look(normalize)

			Matrix4x4.set_rotation(local_pose, look)
			ScriptCamera.set_local_pose(camera, local_pose)
		end

		self:update_ingame_selection(true)
	else
		self:update_ingame_selection(false)

		self.hint_time_when_key_handle_visible = arg_5_1

		if not script_data.ai_debugger_freeflight_only then
			return
		end
	end

	if not DebugKeyHandler.key_pressed("k", "show ai navmesh", "ai debugger", nil, "FreeFlight") then
		self.show_navmesh = not self.show_navmesh
	end

	if not DebugKeyHandler.key_pressed("l", "show ai slots", "ai debugger", nil, "FreeFlight") then
		self.show_slots = not self.show_slots
	end

	if not DebugKeyHandler.key_pressed("j", "kill all but selected AI", "ai", "left shift") then
		local zero = Vector3.zero()

		zero = not Managers.player:local_player() and POSITION_LOOKUP[Managers.player:local_player().player_unit] and zero

		Managers.state.debug:send_conflict_director_command("destroy_close_units", nil, zero, {
			"512"
		})
	elseif not DebugKeyHandler.key_pressed("j", "damage selected AI", "ai", "left alt") then
		local active_unit = self.active_unit

		if HEALTH_ALIVE[active_unit] or not self:closest_unit_in_aim_dir(active) then
			active_unit = self.hot_unit
		end

		DamageUtils.debug_deal_damage(active_unit, 1000)
	elseif not DebugKeyHandler.key_pressed("j", "kill selected AI", "ai") then
		local active_unit_2 = self.active_unit

		if HEALTH_ALIVE[active_unit_2] or not self:closest_unit_in_aim_dir(active) then
			active_unit_2 = self.hot_unit
		end

		if not Unit.alive(active_unit_2) then
			local has_extension_2 = ScriptUnit.has_extension(active_unit_2, "health_system")

			if not has_extension_2 then
				if not has_extension_2:is_alive() then
					local has_extension_3 = ScriptUnit.has_extension(active_unit_2, "status_system")

					if not (not has_extension_3 and not has_extension_3:is_knocked_down()) then
						has_extension_2:knock_down(active_unit_2)
					elseif not self.is_server then
						has_extension_2:die("forced")
					else
						AiUtils.kill_unit(active_unit_2)
					end
				end
			else
				local var_5_18 = BLACKBOARDS[active_unit_2]

				Managers.state.conflict:destroy_unit(active_unit_2, var_5_18, "debug_destroy")
			end
		end
	end

	if not Unit.alive(self.hot_unit) then
		self:draw_hot_unit()
	end

	if not Unit.alive(self.active_unit) then
		self:draw_active_unit(arg_5_1)

		if not DebugKeyHandler.key_pressed("comma", "go to unit", "ai debugger", nil, "FreeFlight") then
			self.follow_active = not self.follow_active
		end

		if not DebugKeyHandler.key_pressed("m", "animation log", "ai debugger", "left shift") then
			local flag_2 = not not not Unit.get_data(self.active_unit, "ai_debugger", "logging_enabled")

			print("animation log enabled " .. tostring(flag_2))
			Unit.set_data(self.active_unit, "ai_debugger", "logging_enabled", flag_2)
			Unit.set_animation_logging(self.active_unit, flag_2)
		end

		if not DebugKeyHandler.key_pressed("m", "show blackboard", "ai debugger", "left ctrl") then
			self.cycle_info = (self.cycle_info + 1) % 3

			local cycle_info = self.cycle_info

			if cycle_info == 1 then
				self.show_blackboard = true
			elseif cycle_info == 2 then
				self.show_blackboard = false
				self.show_extensions = true
			elseif cycle_info == 0 then
				self.show_extensions = false
			end
		end

		local PLATFORM = PLATFORM
		local var_5_22

		if not IS_CONSOLE then
			var_5_22 = DebugKeyHandler.key_pressed("show_behaviour", "show behaviour graph", "ai debugger")
		else
			var_5_22 = DebugKeyHandler.key_pressed("b", "show behaviour graph", "ai debugger", "left ctrl")
		end

		if not var_5_22 then
			self.show_behavior_tree = not self.show_behavior_tree
			script_data.hide_boss_health_ui = self.show_behavior_tree
		end

		local active_unit_3 = self.active_unit

		if not Unit.alive(active_unit_3) then
			self:draw_blackboard(active_unit_3)
			self:draw_extensions(active_unit_3)
			self:draw_behavior_tree(active_unit_3, arg_5_1, arg_5_2)
		end
	end

	if not DebugKeyHandler.key_pressed("j", "edit_ai_utility", "ai", "left ctrl") then
		if self._edit_ai_utility == nil then
			self._edit_ai_utility = EditAiUtility:new(self.world)
		end

		if not self.show_edit_ai_utility then
			self._edit_ai_utility:activate()
		else
			self._edit_ai_utility:deactivate()
		end

		self.show_edit_ai_utility = not self.show_edit_ai_utility
	end

	if not self.show_edit_ai_utility then
		local alive = Unit.alive(self.active_unit)

		alive = not alive and BLACKBOARDS[self.active_unit]

		self._edit_ai_utility:update(self.active_unit, arg_5_1, arg_5_2, Managers.input:get_service("Debug"), alive)
	end

	if not CurrentConflictSettings.disabled then
		if not script_data.debug_ai_pacing then
			self:debug_pacing(arg_5_1, arg_5_2)
		end

		if not self.is_server and not script_data.debug_player_intensity then
			self:debug_player_intensity(arg_5_1, arg_5_2)
		end
	end

	if not DebugKeyHandler.key_pressed("c", "spawn bot player", "ai debugger", nil, "FreeFlight") then
		-- Nothing
	end

	if not self._fake_players then
		for i, v in ipairs(self._fake_players) do
			local unbox = Vector3Box.unbox(v)

			self.drawer:sphere(unbox, 0.5, Color(255, 255, 0, 0))
		end
	end
end

AIDebugger.perlin_path = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local resolution, var_6_1 = Application.resolution()
	local num = 500
	local num_2 = 3
	local tbl = {
		Color(255, 30, 240, 70),
		Color(255, 130, 40, 170),
		Color(255, 130, 240, 70),
		Color(255, 0, 40, 170),
		Color(255, 230, 40, 230)
	}
	local screen_gui = self.screen_gui
	local num_3 = 60337
	local make_perlin_path = PerlinPath.make_perlin_path(15, 15, 1, num_3)
	local normalize_path = PerlinPath.normalize_path(make_perlin_path[1], 0.5 + 0.5 * math.sin(arg_6_1 * 0.1))
	local num_4 = arg_6_2 * resolution
	local num_5 = arg_6_3 * var_6_1
	local num_6 = resolution * (arg_6_2 + arg_6_4)
	local num_7 = var_6_1 * (arg_6_3 + arg_6_5)

	ScriptGUI.icrect(screen_gui, resolution, var_6_1, num_4, num_5, num_6, num_7, num - 1, Color(200, 20, 20, 20))

	for i = 1, #make_perlin_path do
		local var_6_13 = make_perlin_path[i]
		local var_6_14 = Vector3(arg_6_2 + var_6_13[0][1] * arg_6_4, arg_6_3 + (1 - var_6_13[0][2] * normalize_path) * arg_6_5, 0)
		local var_6_15

		for j = 1, #var_6_13 do
			local var_6_16 = var_6_13[j]
			local var_6_17 = Vector3(arg_6_2 + var_6_16[1] * arg_6_4, arg_6_3 + (1 - var_6_16[2] * normalize_path) * arg_6_5, 0)

			ScriptGUI.hud_iline(screen_gui, resolution, var_6_1, var_6_14, var_6_17, num, num_2, tbl[i % 5 + 1])

			var_6_14 = var_6_17
		end
	end
end

AIDebugger.update_selection = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:mouse_raycast(arg_7_1)

	if not Unit.alive(self.active_unit) then
		self.active_unit = nil
	end

	if not arg_7_1:get("action_one") then
		self.active_unit = self.hot_unit
		script_data.debug_unit = self.active_unit
	end

	if not DebugKeyHandler.key_pressed("period", "select next bot", "ai debugger", nil, "FreeFlight") then
		local get_entities = Managers.state.entity:get_entities("AISimpleExtension")

		self.active_unit = next(get_entities, self.active_unit)
	end
end

AIDebugger.update_ingame_selection = function (self, arg_8_1)
	-- function 8
	if not Unit.alive(self.active_unit) then
		self.active_unit = nil
	end

	if DebugKeyHandler.key_pressed("right_thumb_pressed", "select target", "ai") or not DebugKeyHandler.key_pressed("v", "select bot", "ai debugger") or not self:closest_unit_in_aim_dir(arg_8_1) then
		if not Unit.alive(self.active_unit) and not script_data.anim_debug_ai_debug_target then
			Unit.set_animation_logging(self.active_unit, false)
		end

		self.active_unit = self.hot_unit
		script_data.debug_unit = self.active_unit

		if not self.active_unit and not script_data.anim_debug_ai_debug_target then
			Unit.set_animation_logging(self.active_unit, true)
			print("[AIDebugger] NEW TARGET!", self.active_unit)
		end
	end
end

AIDebugger.closest_unit_in_aim_dir = function (self, arg_9_1)
	-- function 9
	if not arg_9_1 then
		return true
	end

	local player_unit = Managers.player:player_from_peer_id(Network.peer_id()).player_unit

	if not player_unit then
		return
	end

	local extension = ScriptUnit.extension(player_unit, "first_person_system")
	local get_first_person_unit = extension:get_first_person_unit()
	local current_position = extension:current_position()
	local current_rotation = extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)
	local num = 999
	local var_9_7
	local tbl = {}
	local entity = Managers.state.entity
	local unit_extension_data = Managers.state.entity:system("ai_system").unit_extension_data
	local get_entities = Managers.state.entity:get_entities("PlayerBotBase")

	table.merge(tbl, unit_extension_data)

	if not script_data.ignore_bots_for_debug_selection then
		table.merge(tbl, get_entities)
	end

	for k, v in pairs(tbl) do
		if not Unit.alive(k) then
			local var_9_12 = forward
			local var_9_13 = current_position
			local num_2 = POSITION_LOOKUP[k] + Vector3(0, 0, 1)
			local normalize = Vector3.normalize(var_9_13 - num_2)
			local dot = Vector3.dot(var_9_12, normalize)

			if not (not (dot <= num) or k == self.active_unit) then
				print("UNIT", k)

				num = dot
				var_9_7 = k
			end
		end
	end

	if not var_9_7 then
		self.hot_unit = var_9_7

		return true
	end
end

AIDebugger.mouse_raycast = function (self, arg_10_1)
	-- function 10
	local global = self.free_flight_manager.data.global
	local world = Managers.world:world(global.viewport_world_name)
	local get_data = World.get_data(world, "physics_world")
	local global_free_flight_viewport = ScriptWorld.global_free_flight_viewport(world)
	local frustum_freeze_camera = global.frustum_freeze_camera

	frustum_freeze_camera = frustum_freeze_camera or ScriptViewport.camera(global_free_flight_viewport)

	local get = arg_10_1:get("cursor")
	local screen_to_world = Camera.screen_to_world(frustum_freeze_camera, Vector3(get.x, get.y, 0), 0)
	local num = Camera.screen_to_world(frustum_freeze_camera, Vector3(get.x, get.y, 0), 1) - screen_to_world
	local normalize = Vector3.normalize(num)
	local immediate_raycast, var_10_10, var_10_11, var_10_12, var_10_13 = PhysicsWorld.immediate_raycast(get_data, screen_to_world, normalize, 100, "closest", "collision_filter", "filter_character_trigger")

	self.hot_unit = nil
	self.hot_actor = nil

	if not immediate_raycast and not var_10_13 then
		local unit = Actor.unit(var_10_13)
		local get_data_2 = Unit.get_data(unit, "breed")
		local player = Managers.player
		local is_player_unit = player:is_player_unit(unit)

		is_player_unit = not is_player_unit and player:owner(unit).bot_player

		if get_data_2 or not is_player_unit then
			self.hot_unit = unit
			self.hot_actor = var_10_13
		end
	end
end

local tbl = {
	z = -1,
	x = 0,
	y = 0
}

AIDebugger.update_mouse_input = function (self, arg_11_1)
	-- function 11
	if not Unit.alive(self.hot_unit) then
		return
	end
end

AIDebugger.draw_hot_unit = function (self)
	-- function 12
	local local_position = Unit.local_position(self.hot_unit, 0)

	self.drawer:sphere(local_position + Vector3.up() * 2, 0.15, Color(255, 255, 100, 0))
end

AIDebugger.draw_active_unit = function (self, arg_13_1)
	-- function 13
	local drawer = self.drawer
	local active_unit = self.active_unit
	local num = Unit.local_position(active_unit, 0) + Vector3.up() * 2
	local forward = Quaternion.forward(Unit.local_rotation(active_unit, 0))

	drawer:sphere(num, 0.1, Color(255, 255, 0))
	drawer:vector(num, forward, Color(255, 255, 0))
	self:draw_nearby_navmesh(active_unit)
end

local tbl_2 = {}

for i = 1, 25 do
	tbl_2[i] = math.random(1, 15)
end

AIDebugger.draw_nearby_navmesh = function (self, arg_14_1)
	-- function 14
	if not self.show_navmesh then
		return
	end

	local drawer = self.drawer
	local var_14_1 = POSITION_LOOKUP[arg_14_1]
	local var_14_2 = Vector3(0, 0, 0.2)
	local _line_object = self._line_object

	_line_object = _line_object or World.create_line_object(self.world, false)
	self._line_object = _line_object

	LineObject.reset(self._line_object)

	local nav_world = self.nav_world
	local get_seed_triangle = GwNavTraversal.get_seed_triangle(nav_world, var_14_1)

	if get_seed_triangle == nil then
		return
	end

	local tbl = {
		get_seed_triangle
	}
	local num = 1
	local num_2 = 0

	while num_2 < num do
		num_2 = num_2 + 1

		local var_14_9 = tbl[num_2]
		local get_triangle_vertices, var_14_11, var_14_12 = GwNavTraversal.get_triangle_vertices(nav_world, var_14_9)
		local num_3 = get_triangle_vertices + var_14_11 + var_14_12
		local ceil = math.ceil((num_3.x + num_3.y) % 24 + 1)
		local num_4 = tbl_2[ceil] * 10

		Gui.triangle(self.world_gui, get_triangle_vertices + var_14_2, var_14_11 + var_14_2, var_14_12 + var_14_2, 0, Color(150, 0, num_4, 255))
		LineObject.add_line(self._line_object, Color(0, 0, 200), get_triangle_vertices + var_14_2, var_14_11 + var_14_2)
		LineObject.add_line(self._line_object, Color(0, 0, 200), get_triangle_vertices + var_14_2, var_14_12 + var_14_2)
		LineObject.add_line(self._line_object, Color(0, 0, 200), var_14_11 + var_14_2, var_14_12 + var_14_2)

		local tbl_3 = {
			GwNavTraversal.get_neighboring_triangles(var_14_9)
		}

		for i = 1, #tbl_3 do
			local var_14_17 = tbl_3[i]
			local flag = false

			for j = 1, num do
				local var_14_19 = tbl[j]

				if not GwNavTraversal.are_triangles_equal(var_14_17, var_14_19) then
					flag = true

					break
				end
			end

			if not flag then
				local get_triangle_vertices_2, var_14_21, var_14_22 = GwNavTraversal.get_triangle_vertices(nav_world, var_14_9)

				if Vector3.distance((get_triangle_vertices_2 + var_14_21 + var_14_22) * 0.33, var_14_1) < 5 then
					num = num + 1
					tbl[num] = var_14_17
				end
			end
		end
	end

	LineObject.dispatch(self.world, self._line_object)
end

AIDebugger.draw_blackboard = function (self, arg_15_1)
	-- function 15
	if not self.show_blackboard then
		return
	end

	local screen_gui = self.screen_gui
	local var_15_1 = BLACKBOARDS[arg_15_1]
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local var_15_6 = fn(var_15_1, tbl, tbl_2)
	local resolution, var_15_8 = Application.resolution()
	local num_2 = var_15_8 - 100
	local var_15_10 = Vector3(200, num_2, 150)
	local var_15_11 = Vector3(200, 0, 0)
	local var_15_12 = Vector3(30, 0, 0)
	local num_4 = 1
	local format = string.format("Blackboard [ %s ]  @  %s", var_15_1.breed.name, tostring(POSITION_LOOKUP[arg_15_1]))

	Gui.text(screen_gui, format, str_2, num, str, var_15_10, Color(255, 255, 255, 255))

	var_15_10.y = var_15_10.y - num

	for i = 1, var_15_6 do
		local var_15_15 = tbl[i]
		local var_15_16 = tbl_2[i]

		var_15_10.y = var_15_10.y - num_3

		if var_15_10.y < 100 then
			var_15_10.y = num_2 - num - num_3
			var_15_10.x = var_15_10.x + 500
			num_4 = num_4 + 1
		end

		Gui.text(screen_gui, var_15_15, str_2, num_3, str, var_15_10, Color(255, 255, 255, 255))

		if type(var_15_16) == "table" then
			local var_15_17 = fn(var_15_16, tbl_3, tbl_4)

			if var_15_17 == 0 then
				Gui.text(screen_gui, "[empty table]", str_2, num_3, str, var_15_10 + var_15_11, Color(255, 100, 100, 100))
			elseif var_15_16.name ~= nil then
				var_15_10.y = var_15_10.y - num_3

				Gui.text(screen_gui, "name", str_2, num_3, str, var_15_10 + var_15_12, Color(255, 255, 255, 255))
				Gui.text(screen_gui, tostring(var_15_16.name), str_2, num_3, str, var_15_10 + var_15_11, Color(255, 255, 255, 0))

				var_15_10.y = var_15_10.y - num_3

				Gui.text(screen_gui, "[hidden fields]", str_2, num_3, str, var_15_10 + var_15_12, Color(255, 100, 100, 100))
				Gui.text(screen_gui, tostring(var_15_17 - 1), str_2, num_3, str, var_15_10 + var_15_11, Color(255, 100, 100, 0))
			elseif var_15_15:find("_extension") ~= nil then
				var_15_10.y = var_15_10.y - num_3

				Gui.text(screen_gui, "[hidden fields]", str_2, num_3, str, var_15_10 + var_15_12, Color(255, 100, 100, 100))
				Gui.text(screen_gui, tostring(var_15_17 - 1), str_2, num_3, str, var_15_10 + var_15_11, Color(255, 100, 100, 0))
			else
				for j = 1, var_15_17 do
					local var_15_18 = tbl_3[j]
					local var_15_19 = tbl_4[j]

					if type(var_15_19) ~= "table" then
						var_15_10.y = var_15_10.y - num_3

						Gui.text(screen_gui, var_15_18, str_2, num_3, str, var_15_10 + var_15_12, Color(255, 255, 255, 255))
						Gui.text(screen_gui, tostring(var_15_19), str_2, num_3, str, var_15_10 + var_15_11, Color(255, 255, 255, 0))
					else
						var_15_10.y = var_15_10.y - num_3

						Gui.text(screen_gui, var_15_18, str_2, num_3, str, var_15_10 + var_15_12, Color(255, 255, 255, 255))
						Gui.text(screen_gui, "[table]", str_2, num_3, str, var_15_10 + var_15_11, Color(255, 255, 255, 0))
					end
				end
			end

			table.clear_array(tbl_3, var_15_17)
			table.clear_array(tbl_4, var_15_17)
		else
			Gui.text(screen_gui, tostring(var_15_16), str_2, num_3, str, var_15_10 + var_15_11, Color(255, 255, 255, 0))
		end
	end

	var_15_10.y = var_15_10.y - num_3

	if num_4 == 1 then
		Gui.rect(screen_gui, Vector3(150, var_15_10.y, 100), Vector2(var_15_10.x + 400, num_2 - var_15_10.y + num_3 * 3), Color(240, 25, 50, 25))
	else
		Gui.rect(screen_gui, Vector3(150, 0, 100), Vector2(var_15_10.x + 400, num_2 + 50), Color(240, 25, 50, 25))
	end
end

AIDebugger.draw_behavior_tree = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	if not self.show_behavior_tree then
		return
	end

	local tree_x = self.tree_x

	tree_x = tree_x or 0.45
	self.tree_x = tree_x

	local tree_y = self.tree_y

	tree_y = tree_y or 0
	self.tree_y = tree_y

	local has_extension = ScriptUnit.has_extension(arg_16_1, "ai_system")

	if not has_extension then
		local bt = has_extension:brain():bt()
		local root = bt:root()

		DrawAiBehaviour.tree_width(self.screen_gui, root)

		local var_16_5
		local has_extension_2 = ScriptUnit.has_extension(arg_16_1, "ai_group_system")

		if not has_extension_2 and not has_extension_2.template then
			local var_16_7 = AIGroupTemplates[has_extension_2.template]

			var_16_5 = not var_16_7.BT_debug and var_16_7.BT_debug(has_extension_2.group)
		end

		local var_16_8 = BLACKBOARDS[arg_16_1]

		DrawAiBehaviour.draw_tree(bt, self.screen_gui, root, var_16_8, 1, arg_16_2, arg_16_3, self.tree_x, self.tree_y, nil, var_16_5)

		local key_pressed = DebugKeyHandler.key_pressed("right_shoulder_held", "pan behaviour graph", "ai debugger")
		local key_pressed_2 = DebugKeyHandler.key_pressed("mouse_middle_held", "pan behaviour graph", "ai debugger")
		local key_pressed_3 = DebugKeyHandler.key_pressed("mouse_middle_held", "pan behaviour graph vertical", "ai debugger", "left ctrl")

		if key_pressed_2 or not key_pressed_3 then
			local get = self.free_flight_manager.input_manager:get_service("Debug"):get("look")

			self.tree_x = self.tree_x - get.x * 0.001

			if not key_pressed_3 then
				self.tree_y = self.tree_y - get.y * 0.001
			end
		elseif not key_pressed then
			local get_2 = self.free_flight_manager.input_manager:get_service("Debug"):get("look_raw")

			self.tree_x = self.tree_x - get_2.x * 0.1
			self.tree_y = self.tree_y - get_2.y * 0.1
		end

		if not DebugKeyHandler.key_pressed("mouse_middle_held", "pan reset behaviour graph", "ai debugger", "left shift") then
			self.tree_x = 0.45
			self.tree_y = 0
		end
	end
end

AIDebugger.draw_reticule = function (self)
	-- function 17
	do return end

	local str = "crosshair_texture_1"
	local str_2 = "hud_assets"

	if not rawget(_G, str_2)[str] then
		local resolution, var_17_3 = Gui.resolution()
		local var_17_4

		if not self.hot_unit then
			var_17_4 = Color(255, 255, 0, 0)

			if not var_17_4 then
				-- Nothing
			end
		end

		var_17_4 = Color(255, 255, 255, 255)

		::label_17_0::

		local atlas_material, var_17_6, var_17_7, var_17_8 = HUDHelper.atlas_material(str_2, str)
		local num = 1

		Gui.bitmap_uv(self.screen_gui, atlas_material, Vector2(var_17_6[1], var_17_6[2]), Vector2(var_17_7[1], var_17_7[2]), Vector3((resolution - num * var_17_8.x) / 2, (var_17_3 - num * var_17_8.y) / 2, 0), num * var_17_8, var_17_4)
	end
end

AIDebugger.debug_player_intensity = function (self, arg_18_1, arg_18_2)
	-- function 18
	local tbl = {
		Color(200, 160, 145, 0),
		Color(200, 90, 150, 170),
		Color(200, 10, 200, 100),
		Color(200, 190, 50, 190)
	}
	local screen_gui = self.screen_gui
	local resolution, var_18_3 = Application.resolution()
	local human_players = Managers.player:human_players()
	local num_2 = 0.15
	local num_3 = 0.02
	local num_4 = 0.0025
	local num_5 = 1 - (num_2 + num_4)
	local num_6 = 0.15
	local var_18_10 = num_6
	local conflict = Managers.state.conflict
	local pacing = conflict.pacing
	local get_pacing_intensity, var_18_14 = pacing:get_pacing_intensity()

	for i = 1, #var_18_14 do
		local num_7 = var_18_14[i] * 0.01
		local var_18_16 = num_5
		local num_8 = var_18_10 + num_3
		local num_9 = num_5 + num_2 * num_7
		local var_18_19 = var_18_10

		ScriptGUI.irect(screen_gui, resolution, var_18_3, var_18_16, num_8, num_5 + num_2, var_18_19, 1, Color(100, 10, 10, 10))
		ScriptGUI.irect(screen_gui, resolution, var_18_3, var_18_16, num_8, num_9, var_18_19, 2, tbl[i])

		var_18_10 = var_18_10 + num_3 + num_4
	end

	ScriptGUI.itext(screen_gui, resolution, var_18_3, "[Player Intensity]", str_2, num, str, num_5, num_6, 3, Color(255, 237, 237, 152))

	local num_10 = var_18_10 + num_3 * 1

	ScriptGUI.itext(screen_gui, resolution, var_18_3, "[Total Intensity]", str_2, num, str, num_5, num_10 + num_3 * 0.75, 3, Color(255, 237, 237, 152))

	local num_11 = num_10 + num_3 * 1

	ScriptGUI.irect(screen_gui, resolution, var_18_3, num_5, num_11 + num_3, num_5 + num_2, num_11, 1, Color(100, 90, 10, 10))
	ScriptGUI.irect(screen_gui, resolution, var_18_3, num_5, num_11 + num_3, num_5 + num_2 * get_pacing_intensity * 0.01, num_11, 2, Color(200, 130, 10, 10))

	local str_3 = ""

	if not conflict:intensity_decay_frozen() then
		str_3 = string.format("decay delay frozen: %.1f", math.clamp(conflict.frozen_intensity_decay_until - arg_18_1, 0, 100))
	elseif not pacing:ignore_pacing_intensity_decay_delay() then
		str_3 = "decay delay: ignored"
	else
		local local_player = Managers.player:local_player(1)

		if not ScriptUnit.has_extension(local_player.player_unit, "status_system") then
			-- Nothing
		end
	end

	local num_12 = num_11 + num_3 * 1.5
	local num_13 = 22

	ScriptGUI.itext(screen_gui, resolution, var_18_3, str_3, str_2, num_13, str, num_5, num_12 + num_3 * 0.75, 3, Color(255, 200, 200, 32))
end

AIDebugger.debug_pacing = function (self, arg_19_1, arg_19_2)
	-- function 19
	local screen_gui = self.screen_gui
	local conflict = Managers.state.conflict
	local resolution, var_19_3 = Application.resolution()
	local num_3 = 0.02
	local num_4 = 0.3
	local num_5 = 0.2
	local num_6 = 0.0025
	local num_7 = 0.45
	local num_8 = 0.01
	local var_19_10 = num_8
	local name = CurrentPacing.name

	name = name or "default"

	local itext_next_xy = ScriptGUI.itext_next_xy(screen_gui, resolution, var_19_3, "Pacing: ", str_2, num, str, num_7 + num_6, var_19_10 + num_3, 3, Color(255, 237, 237, 152))
	local itext_next_xy_2 = ScriptGUI.itext_next_xy(screen_gui, resolution, var_19_3, name, str_2, num, str, itext_next_xy, var_19_10 + num_3, 3, Color(255, 137, 237, 137))
	local itext_next_xy_3 = ScriptGUI.itext_next_xy(screen_gui, resolution, var_19_3, "Conflict setting: ", str_2, num, str, itext_next_xy_2, var_19_10 + num_3, 3, Color(255, 237, 237, 152))
	local itext_next_xy_4 = ScriptGUI.itext_next_xy(screen_gui, resolution, var_19_3, tostring(conflict.current_conflict_settings), str_2, num, str, itext_next_xy_3, var_19_10 + num_3, 3, Color(255, 137, 237, 137))
	local num_9 = var_19_10 + 0.03
	local var_19_17
	local var_19_18
	local get_pacing_data, var_19_20, var_19_21, var_19_22, var_19_23, var_19_24 = conflict.pacing:get_pacing_data()
	local flag

	flag = not (var_19_21 > 0) or not "[Roamers]" or "[NO Roamers]"

	local flag_2

	flag_2 = not (var_19_23 > 0) or not "[Specials]" or "[NO Specials]"

	local flag_3

	flag_3 = not (var_19_23 > 0) or not "[Hordes]" or "[NO Hordes]"

	if not var_19_24 then
		local clamp = math.clamp(var_19_24 - arg_19_1, 0, 999999)

		var_19_17 = string.format("State: %s time left: %.1f", get_pacing_data, clamp)
		var_19_18 = string.format("%s%s%s", flag, flag_2, flag_3)
	else
		var_19_17 = string.format("State: %s runtime: %.1f", get_pacing_data, arg_19_1 - var_19_20)
		var_19_18 = string.format("%s%s%s", flag, flag_2, flag_3)
	end

	ScriptGUI.itext(screen_gui, resolution, var_19_3, var_19_17, str_2, num_2, str, num_7 + num_6, num_9 + num_3, 3, Color(255, 237, 237, 152))

	local num_10 = num_9 + 0.03

	ScriptGUI.itext(screen_gui, resolution, var_19_3, var_19_18, str_2, num_2, str, num_7 + num_6, num_10 + num_3, 3, Color(255, 137, 237, 152))

	local num_11 = num_10 + 0.03
	local str_3 = "Horde debugging is disabled on clients"

	if not Managers.state.network.is_server then
		if not script_data.ai_horde_spawning_disabled then
			str_3 = string.format("Horde spawning is disabled")
		else
			local get_horde_data, var_19_33, var_19_34 = conflict:get_horde_data()

			if #var_19_33 > 0 then
				str_3 = string.format("Number of hordes active: %d  horde size:%d", #var_19_33, conflict:horde_size())
			elseif var_19_23 > 0 then
				if not get_horde_data then
					str_3 = string.format("Next horde in: %.1fs horde size:%d", get_horde_data - arg_19_1, conflict:horde_size())
				else
					str_3 = "Next horde in: N/A"
				end
			else
				str_3 = string.format("No horde will spawn during this state")
			end

			if not var_19_34 then
				local format = string.format("Horde waves left: %d", var_19_34)

				ScriptGUI.itext(screen_gui, resolution, var_19_3, format, str_2, num_2, str, num_7 + num_6, num_11 + num_3, 3, Color(255, 237, 237, 152))

				num_11 = num_11 + 0.03
			end
		end
	end

	ScriptGUI.itext(screen_gui, resolution, var_19_3, str_3, str_2, num_2, str, num_7 + num_6, num_11 + num_3, 3, Color(255, 237, 237, 152))

	local num_12 = num_11 + 0.03

	if not conflict.players_speeding_dist then
		local relax_rushing_distance = CurrentPacing.relax_rushing_distance
		local format_2 = string.format("Players rushing dist: %d / %d", conflict.players_speeding_dist, relax_rushing_distance)

		ScriptGUI.itext(screen_gui, resolution, var_19_3, format_2, str_2, num_2, str, num_7 + num_6, num_12 + num_3, 3, Color(255, 237, 237, 152))

		num_12 = num_12 + 0.03
	end

	ScriptGUI.irect(screen_gui, resolution, var_19_3, num_7, num_8, num_7 + num_4, num_12, 2, Color(100, 10, 10, 10))
end

local flag = false

AIDebugger.draw_hint = function (self, arg_20_1)
	-- function 20
	if not script_data and not script_data.disable_debug_draw then
		return
	end

	if not flag then
		return
	end

	local screen_gui = self.screen_gui
	local resolution, var_20_2 = Application.resolution()

	if not script_data.debug_key_handler_visible then
		self.hint_time_when_key_handle_visible = arg_20_1

		return
	end

	local num_2 = arg_20_1 - self.hint_time_when_key_handle_visible

	if num_2 > math.pi * 2 then
		flag = true

		return
	end

	local num_3 = math.min(1, math.sin(num_2 * 0.5) * 3) * 255
	local str_3 = "Hint: you can show ai debugger shortcuts by enabling 'debug_key_handler_visible' in the debug menu"
	local text_extents, var_20_7 = Gui.text_extents(screen_gui, str_3, str_2, num)
	local num_4 = var_20_7.x - text_extents.x
	local num_5 = resolution / 2 - num_4 / 2

	Gui.text(screen_gui, str_3, str_2, num, str, Vector3(num_5, 20, 150), Color(num_3, 255, 255, 255))
	Gui.rect(screen_gui, Vector3(num_5 - 20, 0, 100), Vector2(num_4 + 40, 50), Color(num_3 * 0.75, 25, 50, 25))
end

AIDebugger.create_fake_players = function (self)
	-- function 21
	local player_unit = Managers.player:player_from_peer_id(Network.peer_id()).player_unit
	local var_21_1 = POSITION_LOOKUP[player_unit]
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	self._fake_players = {}
	self._fake_players[1] = Vector3Box(var_21_1)

	for i = 2, 4 do
		self._fake_players[i] = Vector3Box(LocomotionUtils.new_random_goal(nav_world, nil, var_21_1, 5, 20, 10))
	end

	return self._fake_players
end

AIDebugger.fake_players = function (self)
	-- function 22
	return self._fake_players
end

AIDebugger.draw_extensions = function (self, arg_23_1)
	-- function 23
	if not self.show_extensions then
		return
	end

	local screen_gui = self.screen_gui
	local var_23_1 = BLACKBOARDS[arg_23_1]
	local resolution, var_23_3 = Application.resolution()
	local num_2 = var_23_3 - 120
	local var_23_5 = Vector3(200, num_2, 150)
	local num_4 = 1
	local format = string.format("Extensions for %s", var_23_1.breed.name)

	Gui.text(screen_gui, format, str_2, num, str, var_23_5, Color(255, 255, 255, 255))

	var_23_5.y = var_23_5.y - num

	local extensions = ScriptUnit.extensions(arg_23_1)

	for k, v in pairs(extensions) do
		var_23_5.y = var_23_5.y - num_3

		if var_23_5.y < 100 then
			var_23_5.y = num_2 - num - num_3
			var_23_5.x = var_23_5.x + 500
			num_4 = num_4 + 1
		end

		Gui.text(screen_gui, k, str_2, num_3, str, var_23_5, Color(255, 255, 255, 255))
	end

	var_23_5.y = var_23_5.y - num_3

	if num_4 == 1 then
		Gui.rect(screen_gui, Vector3(150, var_23_5.y, 100), Vector2(var_23_5.x + 400, num_2 - var_23_5.y + num_3 * 3), Color(240, 25, 50, 25))
	else
		Gui.rect(screen_gui, Vector3(150, 0, 100), Vector2(var_23_5.x + 400, num_2 + 50), Color(240, 25, 50, 25))
	end
end
