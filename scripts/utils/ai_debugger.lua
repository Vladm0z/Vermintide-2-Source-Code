-- chunkname: @scripts/utils/ai_debugger.lua

require("scripts/utils/script_gui")
require("scripts/utils/draw_ai_behavior")

script_data.ai_debugger_freeflight_only = script_data.ai_debugger_freeflight_only or Development.parameter("ai_debugger_freeflight_only")

local var_0_0 = 26
local var_0_1 = 22
local var_0_2 = 16
local var_0_3 = "arial"
local var_0_4 = "materials/fonts/" .. var_0_3

local function var_0_5(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = 0

	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		var_1_0 = var_1_0 + 1
		arg_1_1[var_1_0] = tostring(iter_1_0)
	end

	table.sort(arg_1_1)

	for iter_1_2 = 1, var_1_0 do
		arg_1_2[iter_1_2] = arg_1_0[arg_1_1[iter_1_2]]
	end

	return var_1_0
end

AIDebugger = class(AIDebugger)

function AIDebugger.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_0.free_flight_manager = arg_2_5
	arg_2_0.is_server = arg_2_4
	arg_2_0.world = arg_2_1
	arg_2_0.nav_world = arg_2_2
	arg_2_0.group_blackboard = arg_2_3
	arg_2_0.world_gui = World.create_world_gui(arg_2_1, Matrix4x4.identity(), 1, 1, "immediate", "material", "materials/fonts/gw_fonts")
	arg_2_0.screen_gui = World.create_screen_gui(arg_2_0.world, "material", "materials/fonts/gw_fonts", "immediate")
	arg_2_0.show_navmesh = false
	arg_2_0.show_extensions = false
	arg_2_0.cycle_info = 0
	arg_2_0.show_slots = false
	arg_2_0.follow_active = false
	arg_2_0.show_behavior_tree = false
	arg_2_0.hint_time_when_key_handle_visible = 0
end

function AIDebugger.lazy_create_drawer(arg_3_0)
	if arg_3_0.drawer then
		return
	end

	arg_3_0.drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AIDebugger"
	})
end

function AIDebugger.destroy(arg_4_0)
	return
end

function AIDebugger.update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:lazy_create_drawer()

	if Unit.alive(script_data.debug_unit) then
		local var_5_0 = script_data.debug_unit
		local var_5_1 = ScriptUnit.has_extension(var_5_0, "ai_system")
		local var_5_2 = var_5_1 and var_5_1._breed

		if var_5_2 then
			local var_5_3 = BLACKBOARDS[var_5_0]

			if var_5_3 and var_5_3.mode then
				Debug.text("debug_unit = %s, mode=%s, phase=%s", var_5_2.name, tostring(var_5_3.mode), tostring(var_5_3.phase))
			else
				Debug.text("script_data.debug_unit = %s", var_5_2.name)
			end
		else
			Debug.text("script_data.debug_unit = %s", tostring(var_5_0))
		end
	end

	local var_5_4 = arg_5_0.free_flight_manager:active("global")

	if var_5_4 then
		local var_5_5 = arg_5_0.free_flight_manager.input_manager:get_service("FreeFlight")

		arg_5_0:update_selection(var_5_5, arg_5_2)
		arg_5_0:update_mouse_input(var_5_5)
		arg_5_0:draw_reticule()
		arg_5_0:draw_hint(arg_5_1)

		if arg_5_0.follow_active and Unit.alive(arg_5_0.active_unit) then
			local var_5_6 = ScriptWorld.global_free_flight_viewport(arg_5_0.world)
			local var_5_7 = ScriptViewport.camera(var_5_6)
			local var_5_8 = Unit.local_pose(arg_5_0.active_unit, 0)
			local var_5_9 = Matrix4x4.translation(var_5_8)
			local var_5_10 = var_5_9 - Matrix4x4.forward(var_5_8) * 4 + Vector3.up() * 3

			Matrix4x4.set_translation(var_5_8, var_5_10)

			local var_5_11 = Vector3.normalize(var_5_9 + Vector3.up() - var_5_10)
			local var_5_12 = Quaternion.look(var_5_11)

			Matrix4x4.set_rotation(var_5_8, var_5_12)
			ScriptCamera.set_local_pose(var_5_7, var_5_8)
		end

		arg_5_0:update_ingame_selection(true)
	else
		arg_5_0:update_ingame_selection(false)

		arg_5_0.hint_time_when_key_handle_visible = arg_5_1

		if script_data.ai_debugger_freeflight_only then
			return
		end
	end

	if DebugKeyHandler.key_pressed("k", "show ai navmesh", "ai debugger", nil, "FreeFlight") then
		arg_5_0.show_navmesh = not arg_5_0.show_navmesh
	end

	if DebugKeyHandler.key_pressed("l", "show ai slots", "ai debugger", nil, "FreeFlight") then
		arg_5_0.show_slots = not arg_5_0.show_slots
	end

	if DebugKeyHandler.key_pressed("j", "kill all but selected AI", "ai", "left shift") then
		local var_5_13 = Vector3.zero()

		var_5_13 = Managers.player:local_player() and POSITION_LOOKUP[Managers.player:local_player().player_unit] or var_5_13

		Managers.state.debug:send_conflict_director_command("destroy_close_units", nil, var_5_13, {
			"512"
		})
	elseif DebugKeyHandler.key_pressed("j", "damage selected AI", "ai", "left alt") then
		local var_5_14 = arg_5_0.active_unit

		if not HEALTH_ALIVE[var_5_14] and arg_5_0:closest_unit_in_aim_dir(var_5_4) then
			var_5_14 = arg_5_0.hot_unit
		end

		DamageUtils.debug_deal_damage(var_5_14, 1000)
	elseif DebugKeyHandler.key_pressed("j", "kill selected AI", "ai") then
		local var_5_15 = arg_5_0.active_unit

		if not HEALTH_ALIVE[var_5_15] and arg_5_0:closest_unit_in_aim_dir(var_5_4) then
			var_5_15 = arg_5_0.hot_unit
		end

		if Unit.alive(var_5_15) then
			local var_5_16 = ScriptUnit.has_extension(var_5_15, "health_system")

			if var_5_16 then
				if var_5_16:is_alive() then
					local var_5_17 = ScriptUnit.has_extension(var_5_15, "status_system")

					if var_5_17 and not var_5_17:is_knocked_down() then
						var_5_16:knock_down(var_5_15)
					elseif arg_5_0.is_server then
						var_5_16:die("forced")
					else
						AiUtils.kill_unit(var_5_15)
					end
				end
			else
				local var_5_18 = BLACKBOARDS[var_5_15]

				Managers.state.conflict:destroy_unit(var_5_15, var_5_18, "debug_destroy")
			end
		end
	end

	if Unit.alive(arg_5_0.hot_unit) then
		arg_5_0:draw_hot_unit()
	end

	if Unit.alive(arg_5_0.active_unit) then
		arg_5_0:draw_active_unit(arg_5_1)

		if DebugKeyHandler.key_pressed("comma", "go to unit", "ai debugger", nil, "FreeFlight") then
			arg_5_0.follow_active = not arg_5_0.follow_active
		end

		if DebugKeyHandler.key_pressed("m", "animation log", "ai debugger", "left shift") then
			local var_5_19 = not not not Unit.get_data(arg_5_0.active_unit, "ai_debugger", "logging_enabled")

			print("animation log enabled " .. tostring(var_5_19))
			Unit.set_data(arg_5_0.active_unit, "ai_debugger", "logging_enabled", var_5_19)
			Unit.set_animation_logging(arg_5_0.active_unit, var_5_19)
		end

		if DebugKeyHandler.key_pressed("m", "show blackboard", "ai debugger", "left ctrl") then
			arg_5_0.cycle_info = (arg_5_0.cycle_info + 1) % 3

			local var_5_20 = arg_5_0.cycle_info

			if var_5_20 == 1 then
				arg_5_0.show_blackboard = true
			elseif var_5_20 == 2 then
				arg_5_0.show_blackboard = false
				arg_5_0.show_extensions = true
			elseif var_5_20 == 0 then
				arg_5_0.show_extensions = false
			end
		end

		local var_5_21 = PLATFORM
		local var_5_22

		if IS_CONSOLE then
			var_5_22 = DebugKeyHandler.key_pressed("show_behaviour", "show behaviour graph", "ai debugger")
		else
			var_5_22 = DebugKeyHandler.key_pressed("b", "show behaviour graph", "ai debugger", "left ctrl")
		end

		if var_5_22 then
			arg_5_0.show_behavior_tree = not arg_5_0.show_behavior_tree
			script_data.hide_boss_health_ui = arg_5_0.show_behavior_tree
		end

		local var_5_23 = arg_5_0.active_unit

		if Unit.alive(var_5_23) then
			arg_5_0:draw_blackboard(var_5_23)
			arg_5_0:draw_extensions(var_5_23)
			arg_5_0:draw_behavior_tree(var_5_23, arg_5_1, arg_5_2)
		end
	end

	if DebugKeyHandler.key_pressed("j", "edit_ai_utility", "ai", "left ctrl") then
		if arg_5_0._edit_ai_utility == nil then
			arg_5_0._edit_ai_utility = EditAiUtility:new(arg_5_0.world)
		end

		if not arg_5_0.show_edit_ai_utility then
			arg_5_0._edit_ai_utility:activate()
		else
			arg_5_0._edit_ai_utility:deactivate()
		end

		arg_5_0.show_edit_ai_utility = not arg_5_0.show_edit_ai_utility
	end

	if arg_5_0.show_edit_ai_utility then
		local var_5_24 = Unit.alive(arg_5_0.active_unit) and BLACKBOARDS[arg_5_0.active_unit]

		arg_5_0._edit_ai_utility:update(arg_5_0.active_unit, arg_5_1, arg_5_2, Managers.input:get_service("Debug"), var_5_24)
	end

	if not CurrentConflictSettings.disabled then
		if script_data.debug_ai_pacing then
			arg_5_0:debug_pacing(arg_5_1, arg_5_2)
		end

		if arg_5_0.is_server and script_data.debug_player_intensity then
			arg_5_0:debug_player_intensity(arg_5_1, arg_5_2)
		end
	end

	if DebugKeyHandler.key_pressed("c", "spawn bot player", "ai debugger", nil, "FreeFlight") then
		-- block empty
	end

	if arg_5_0._fake_players then
		for iter_5_0, iter_5_1 in ipairs(arg_5_0._fake_players) do
			local var_5_25 = Vector3Box.unbox(iter_5_1)

			arg_5_0.drawer:sphere(var_5_25, 0.5, Color(255, 255, 0, 0))
		end
	end
end

function AIDebugger.perlin_path(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0, var_6_1 = Application.resolution()
	local var_6_2 = 500
	local var_6_3 = 3
	local var_6_4 = {
		Color(255, 30, 240, 70),
		Color(255, 130, 40, 170),
		Color(255, 130, 240, 70),
		Color(255, 0, 40, 170),
		Color(255, 230, 40, 230)
	}
	local var_6_5 = arg_6_0.screen_gui
	local var_6_6 = 60337
	local var_6_7 = PerlinPath.make_perlin_path(15, 15, 1, var_6_6)
	local var_6_8 = PerlinPath.normalize_path(var_6_7[1], 0.5 + 0.5 * math.sin(arg_6_1 * 0.1))
	local var_6_9 = arg_6_2 * var_6_0
	local var_6_10 = arg_6_3 * var_6_1
	local var_6_11 = var_6_0 * (arg_6_2 + arg_6_4)
	local var_6_12 = var_6_1 * (arg_6_3 + arg_6_5)

	ScriptGUI.icrect(var_6_5, var_6_0, var_6_1, var_6_9, var_6_10, var_6_11, var_6_12, var_6_2 - 1, Color(200, 20, 20, 20))

	for iter_6_0 = 1, #var_6_7 do
		local var_6_13 = var_6_7[iter_6_0]
		local var_6_14 = Vector3(arg_6_2 + var_6_13[0][1] * arg_6_4, arg_6_3 + (1 - var_6_13[0][2] * var_6_8) * arg_6_5, 0)
		local var_6_15

		for iter_6_1 = 1, #var_6_13 do
			local var_6_16 = var_6_13[iter_6_1]
			local var_6_17 = Vector3(arg_6_2 + var_6_16[1] * arg_6_4, arg_6_3 + (1 - var_6_16[2] * var_6_8) * arg_6_5, 0)

			ScriptGUI.hud_iline(var_6_5, var_6_0, var_6_1, var_6_14, var_6_17, var_6_2, var_6_3, var_6_4[iter_6_0 % 5 + 1])

			var_6_14 = var_6_17
		end
	end
end

function AIDebugger.update_selection(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:mouse_raycast(arg_7_1)

	if not Unit.alive(arg_7_0.active_unit) then
		arg_7_0.active_unit = nil
	end

	if arg_7_1:get("action_one") then
		arg_7_0.active_unit = arg_7_0.hot_unit
		script_data.debug_unit = arg_7_0.active_unit
	end

	if DebugKeyHandler.key_pressed("period", "select next bot", "ai debugger", nil, "FreeFlight") then
		local var_7_0 = Managers.state.entity:get_entities("AISimpleExtension")

		arg_7_0.active_unit = next(var_7_0, arg_7_0.active_unit)
	end
end

function AIDebugger.update_ingame_selection(arg_8_0, arg_8_1)
	if not Unit.alive(arg_8_0.active_unit) then
		arg_8_0.active_unit = nil
	end

	if (DebugKeyHandler.key_pressed("right_thumb_pressed", "select target", "ai") or DebugKeyHandler.key_pressed("v", "select bot", "ai debugger")) and arg_8_0:closest_unit_in_aim_dir(arg_8_1) then
		if Unit.alive(arg_8_0.active_unit) and script_data.anim_debug_ai_debug_target then
			Unit.set_animation_logging(arg_8_0.active_unit, false)
		end

		arg_8_0.active_unit = arg_8_0.hot_unit
		script_data.debug_unit = arg_8_0.active_unit

		if arg_8_0.active_unit and script_data.anim_debug_ai_debug_target then
			Unit.set_animation_logging(arg_8_0.active_unit, true)
			print("[AIDebugger] NEW TARGET!", arg_8_0.active_unit)
		end
	end
end

function AIDebugger.closest_unit_in_aim_dir(arg_9_0, arg_9_1)
	if arg_9_1 then
		return true
	end

	local var_9_0 = Managers.player:player_from_peer_id(Network.peer_id()).player_unit

	if not var_9_0 then
		return
	end

	local var_9_1 = ScriptUnit.extension(var_9_0, "first_person_system")
	local var_9_2 = var_9_1:get_first_person_unit()
	local var_9_3 = var_9_1:current_position()
	local var_9_4 = var_9_1:current_rotation()
	local var_9_5 = Quaternion.forward(var_9_4)
	local var_9_6 = 999
	local var_9_7
	local var_9_8 = {}
	local var_9_9 = Managers.state.entity
	local var_9_10 = Managers.state.entity:system("ai_system").unit_extension_data
	local var_9_11 = Managers.state.entity:get_entities("PlayerBotBase")

	table.merge(var_9_8, var_9_10)

	if not script_data.ignore_bots_for_debug_selection then
		table.merge(var_9_8, var_9_11)
	end

	for iter_9_0, iter_9_1 in pairs(var_9_8) do
		if Unit.alive(iter_9_0) then
			local var_9_12 = var_9_5
			local var_9_13 = var_9_3
			local var_9_14 = POSITION_LOOKUP[iter_9_0] + Vector3(0, 0, 1)
			local var_9_15 = Vector3.normalize(var_9_13 - var_9_14)
			local var_9_16 = Vector3.dot(var_9_12, var_9_15)

			if var_9_16 <= var_9_6 and iter_9_0 ~= arg_9_0.active_unit then
				print("UNIT", iter_9_0)

				var_9_6 = var_9_16
				var_9_7 = iter_9_0
			end
		end
	end

	if var_9_7 then
		arg_9_0.hot_unit = var_9_7

		return true
	end
end

function AIDebugger.mouse_raycast(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.free_flight_manager.data.global
	local var_10_1 = Managers.world:world(var_10_0.viewport_world_name)
	local var_10_2 = World.get_data(var_10_1, "physics_world")
	local var_10_3 = ScriptWorld.global_free_flight_viewport(var_10_1)
	local var_10_4 = var_10_0.frustum_freeze_camera or ScriptViewport.camera(var_10_3)
	local var_10_5 = arg_10_1:get("cursor")
	local var_10_6 = Camera.screen_to_world(var_10_4, Vector3(var_10_5.x, var_10_5.y, 0), 0)
	local var_10_7 = Camera.screen_to_world(var_10_4, Vector3(var_10_5.x, var_10_5.y, 0), 1) - var_10_6
	local var_10_8 = Vector3.normalize(var_10_7)
	local var_10_9, var_10_10, var_10_11, var_10_12, var_10_13 = PhysicsWorld.immediate_raycast(var_10_2, var_10_6, var_10_8, 100, "closest", "collision_filter", "filter_character_trigger")

	arg_10_0.hot_unit = nil
	arg_10_0.hot_actor = nil

	if var_10_9 and var_10_13 then
		local var_10_14 = Actor.unit(var_10_13)
		local var_10_15 = Unit.get_data(var_10_14, "breed")
		local var_10_16 = Managers.player
		local var_10_17 = var_10_16:is_player_unit(var_10_14) and var_10_16:owner(var_10_14).bot_player

		if var_10_15 or var_10_17 then
			arg_10_0.hot_unit = var_10_14
			arg_10_0.hot_actor = var_10_13
		end
	end
end

local var_0_6 = {
	z = -1,
	x = 0,
	y = 0
}

function AIDebugger.update_mouse_input(arg_11_0, arg_11_1)
	if not Unit.alive(arg_11_0.hot_unit) then
		return
	end
end

function AIDebugger.draw_hot_unit(arg_12_0)
	local var_12_0 = Unit.local_position(arg_12_0.hot_unit, 0)

	arg_12_0.drawer:sphere(var_12_0 + Vector3.up() * 2, 0.15, Color(255, 255, 100, 0))
end

function AIDebugger.draw_active_unit(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.drawer
	local var_13_1 = arg_13_0.active_unit
	local var_13_2 = Unit.local_position(var_13_1, 0) + Vector3.up() * 2
	local var_13_3 = Quaternion.forward(Unit.local_rotation(var_13_1, 0))

	var_13_0:sphere(var_13_2, 0.1, Color(255, 255, 0))
	var_13_0:vector(var_13_2, var_13_3, Color(255, 255, 0))
	arg_13_0:draw_nearby_navmesh(var_13_1)
end

local var_0_7 = {}

for iter_0_0 = 1, 25 do
	var_0_7[iter_0_0] = math.random(1, 15)
end

function AIDebugger.draw_nearby_navmesh(arg_14_0, arg_14_1)
	if not arg_14_0.show_navmesh then
		return
	end

	local var_14_0 = arg_14_0.drawer
	local var_14_1 = POSITION_LOOKUP[arg_14_1]
	local var_14_2 = Vector3(0, 0, 0.2)

	arg_14_0._line_object = arg_14_0._line_object or World.create_line_object(arg_14_0.world, false)

	LineObject.reset(arg_14_0._line_object)

	local var_14_3 = arg_14_0.nav_world
	local var_14_4 = GwNavTraversal.get_seed_triangle(var_14_3, var_14_1)

	if var_14_4 == nil then
		return
	end

	local var_14_5 = {
		var_14_4
	}
	local var_14_6 = 1
	local var_14_7 = 0

	while var_14_7 < var_14_6 do
		var_14_7 = var_14_7 + 1

		local var_14_8 = var_14_5[var_14_7]
		local var_14_9, var_14_10, var_14_11 = GwNavTraversal.get_triangle_vertices(var_14_3, var_14_8)
		local var_14_12 = var_14_9 + var_14_10 + var_14_11
		local var_14_13 = math.ceil((var_14_12.x + var_14_12.y) % 24 + 1)
		local var_14_14 = var_0_7[var_14_13] * 10

		Gui.triangle(arg_14_0.world_gui, var_14_9 + var_14_2, var_14_10 + var_14_2, var_14_11 + var_14_2, 0, Color(150, 0, var_14_14, 255))
		LineObject.add_line(arg_14_0._line_object, Color(0, 0, 200), var_14_9 + var_14_2, var_14_10 + var_14_2)
		LineObject.add_line(arg_14_0._line_object, Color(0, 0, 200), var_14_9 + var_14_2, var_14_11 + var_14_2)
		LineObject.add_line(arg_14_0._line_object, Color(0, 0, 200), var_14_10 + var_14_2, var_14_11 + var_14_2)

		local var_14_15 = {
			GwNavTraversal.get_neighboring_triangles(var_14_8)
		}

		for iter_14_0 = 1, #var_14_15 do
			local var_14_16 = var_14_15[iter_14_0]
			local var_14_17 = false

			for iter_14_1 = 1, var_14_6 do
				local var_14_18 = var_14_5[iter_14_1]

				if GwNavTraversal.are_triangles_equal(var_14_16, var_14_18) then
					var_14_17 = true

					break
				end
			end

			if not var_14_17 then
				local var_14_19, var_14_20, var_14_21 = GwNavTraversal.get_triangle_vertices(var_14_3, var_14_8)

				if Vector3.distance((var_14_19 + var_14_20 + var_14_21) * 0.33, var_14_1) < 5 then
					var_14_6 = var_14_6 + 1
					var_14_5[var_14_6] = var_14_16
				end
			end
		end
	end

	LineObject.dispatch(arg_14_0.world, arg_14_0._line_object)
end

function AIDebugger.draw_blackboard(arg_15_0, arg_15_1)
	if not arg_15_0.show_blackboard then
		return
	end

	local var_15_0 = arg_15_0.screen_gui
	local var_15_1 = BLACKBOARDS[arg_15_1]
	local var_15_2 = {}
	local var_15_3 = {}
	local var_15_4 = {}
	local var_15_5 = {}
	local var_15_6 = var_0_5(var_15_1, var_15_2, var_15_3)
	local var_15_7, var_15_8 = Application.resolution()
	local var_15_9 = var_15_8 - 100
	local var_15_10 = Vector3(200, var_15_9, 150)
	local var_15_11 = Vector3(200, 0, 0)
	local var_15_12 = Vector3(30, 0, 0)
	local var_15_13 = 1
	local var_15_14 = string.format("Blackboard [ %s ]  @  %s", var_15_1.breed.name, tostring(POSITION_LOOKUP[arg_15_1]))

	Gui.text(var_15_0, var_15_14, var_0_4, var_0_0, var_0_3, var_15_10, Color(255, 255, 255, 255))

	var_15_10.y = var_15_10.y - var_0_0

	for iter_15_0 = 1, var_15_6 do
		local var_15_15 = var_15_2[iter_15_0]
		local var_15_16 = var_15_3[iter_15_0]

		var_15_10.y = var_15_10.y - var_0_2

		if var_15_10.y < 100 then
			var_15_10.y = var_15_9 - var_0_0 - var_0_2
			var_15_10.x = var_15_10.x + 500
			var_15_13 = var_15_13 + 1
		end

		Gui.text(var_15_0, var_15_15, var_0_4, var_0_2, var_0_3, var_15_10, Color(255, 255, 255, 255))

		if type(var_15_16) == "table" then
			local var_15_17 = var_0_5(var_15_16, var_15_4, var_15_5)

			if var_15_17 == 0 then
				Gui.text(var_15_0, "[empty table]", var_0_4, var_0_2, var_0_3, var_15_10 + var_15_11, Color(255, 100, 100, 100))
			elseif var_15_16.name ~= nil then
				var_15_10.y = var_15_10.y - var_0_2

				Gui.text(var_15_0, "name", var_0_4, var_0_2, var_0_3, var_15_10 + var_15_12, Color(255, 255, 255, 255))
				Gui.text(var_15_0, tostring(var_15_16.name), var_0_4, var_0_2, var_0_3, var_15_10 + var_15_11, Color(255, 255, 255, 0))

				var_15_10.y = var_15_10.y - var_0_2

				Gui.text(var_15_0, "[hidden fields]", var_0_4, var_0_2, var_0_3, var_15_10 + var_15_12, Color(255, 100, 100, 100))
				Gui.text(var_15_0, tostring(var_15_17 - 1), var_0_4, var_0_2, var_0_3, var_15_10 + var_15_11, Color(255, 100, 100, 0))
			elseif var_15_15:find("_extension") ~= nil then
				var_15_10.y = var_15_10.y - var_0_2

				Gui.text(var_15_0, "[hidden fields]", var_0_4, var_0_2, var_0_3, var_15_10 + var_15_12, Color(255, 100, 100, 100))
				Gui.text(var_15_0, tostring(var_15_17 - 1), var_0_4, var_0_2, var_0_3, var_15_10 + var_15_11, Color(255, 100, 100, 0))
			else
				for iter_15_1 = 1, var_15_17 do
					local var_15_18 = var_15_4[iter_15_1]
					local var_15_19 = var_15_5[iter_15_1]

					if type(var_15_19) ~= "table" then
						var_15_10.y = var_15_10.y - var_0_2

						Gui.text(var_15_0, var_15_18, var_0_4, var_0_2, var_0_3, var_15_10 + var_15_12, Color(255, 255, 255, 255))
						Gui.text(var_15_0, tostring(var_15_19), var_0_4, var_0_2, var_0_3, var_15_10 + var_15_11, Color(255, 255, 255, 0))
					else
						var_15_10.y = var_15_10.y - var_0_2

						Gui.text(var_15_0, var_15_18, var_0_4, var_0_2, var_0_3, var_15_10 + var_15_12, Color(255, 255, 255, 255))
						Gui.text(var_15_0, "[table]", var_0_4, var_0_2, var_0_3, var_15_10 + var_15_11, Color(255, 255, 255, 0))
					end
				end
			end

			table.clear_array(var_15_4, var_15_17)
			table.clear_array(var_15_5, var_15_17)
		else
			Gui.text(var_15_0, tostring(var_15_16), var_0_4, var_0_2, var_0_3, var_15_10 + var_15_11, Color(255, 255, 255, 0))
		end
	end

	var_15_10.y = var_15_10.y - var_0_2

	if var_15_13 == 1 then
		Gui.rect(var_15_0, Vector3(150, var_15_10.y, 100), Vector2(var_15_10.x + 400, var_15_9 - var_15_10.y + var_0_2 * 3), Color(240, 25, 50, 25))
	else
		Gui.rect(var_15_0, Vector3(150, 0, 100), Vector2(var_15_10.x + 400, var_15_9 + 50), Color(240, 25, 50, 25))
	end
end

function AIDebugger.draw_behavior_tree(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if not arg_16_0.show_behavior_tree then
		return
	end

	arg_16_0.tree_x = arg_16_0.tree_x or 0.45
	arg_16_0.tree_y = arg_16_0.tree_y or 0

	local var_16_0 = ScriptUnit.has_extension(arg_16_1, "ai_system")

	if var_16_0 then
		local var_16_1 = var_16_0:brain():bt()
		local var_16_2 = var_16_1:root()

		DrawAiBehaviour.tree_width(arg_16_0.screen_gui, var_16_2)

		local var_16_3
		local var_16_4 = ScriptUnit.has_extension(arg_16_1, "ai_group_system")

		if var_16_4 and var_16_4.template then
			local var_16_5 = AIGroupTemplates[var_16_4.template]

			var_16_3 = var_16_5.BT_debug and var_16_5.BT_debug(var_16_4.group)
		end

		local var_16_6 = BLACKBOARDS[arg_16_1]

		DrawAiBehaviour.draw_tree(var_16_1, arg_16_0.screen_gui, var_16_2, var_16_6, 1, arg_16_2, arg_16_3, arg_16_0.tree_x, arg_16_0.tree_y, nil, var_16_3)

		local var_16_7 = DebugKeyHandler.key_pressed("right_shoulder_held", "pan behaviour graph", "ai debugger")
		local var_16_8 = DebugKeyHandler.key_pressed("mouse_middle_held", "pan behaviour graph", "ai debugger")
		local var_16_9 = DebugKeyHandler.key_pressed("mouse_middle_held", "pan behaviour graph vertical", "ai debugger", "left ctrl")

		if var_16_8 or var_16_9 then
			local var_16_10 = arg_16_0.free_flight_manager.input_manager:get_service("Debug"):get("look")

			arg_16_0.tree_x = arg_16_0.tree_x - var_16_10.x * 0.001

			if var_16_9 then
				arg_16_0.tree_y = arg_16_0.tree_y - var_16_10.y * 0.001
			end
		elseif var_16_7 then
			local var_16_11 = arg_16_0.free_flight_manager.input_manager:get_service("Debug"):get("look_raw")

			arg_16_0.tree_x = arg_16_0.tree_x - var_16_11.x * 0.1
			arg_16_0.tree_y = arg_16_0.tree_y - var_16_11.y * 0.1
		end

		if DebugKeyHandler.key_pressed("mouse_middle_held", "pan reset behaviour graph", "ai debugger", "left shift") then
			arg_16_0.tree_x = 0.45
			arg_16_0.tree_y = 0
		end
	end
end

function AIDebugger.draw_reticule(arg_17_0)
	do return end

	local var_17_0 = "crosshair_texture_1"
	local var_17_1 = "hud_assets"

	if rawget(_G, var_17_1)[var_17_0] then
		local var_17_2, var_17_3 = Gui.resolution()
		local var_17_4 = arg_17_0.hot_unit and Color(255, 255, 0, 0) or Color(255, 255, 255, 255)
		local var_17_5, var_17_6, var_17_7, var_17_8 = HUDHelper.atlas_material(var_17_1, var_17_0)
		local var_17_9 = 1

		Gui.bitmap_uv(arg_17_0.screen_gui, var_17_5, Vector2(var_17_6[1], var_17_6[2]), Vector2(var_17_7[1], var_17_7[2]), Vector3((var_17_2 - var_17_9 * var_17_8.x) / 2, (var_17_3 - var_17_9 * var_17_8.y) / 2, 0), var_17_9 * var_17_8, var_17_4)
	end
end

function AIDebugger.debug_player_intensity(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = {
		Color(200, 160, 145, 0),
		Color(200, 90, 150, 170),
		Color(200, 10, 200, 100),
		Color(200, 190, 50, 190)
	}
	local var_18_1 = arg_18_0.screen_gui
	local var_18_2, var_18_3 = Application.resolution()
	local var_18_4 = Managers.player:human_players()
	local var_18_5 = 0.15
	local var_18_6 = 0.02
	local var_18_7 = 0.0025
	local var_18_8 = 1 - (var_18_5 + var_18_7)
	local var_18_9 = 0.15
	local var_18_10 = var_18_9
	local var_18_11 = Managers.state.conflict
	local var_18_12 = var_18_11.pacing
	local var_18_13, var_18_14 = var_18_12:get_pacing_intensity()

	for iter_18_0 = 1, #var_18_14 do
		local var_18_15 = var_18_14[iter_18_0] * 0.01
		local var_18_16 = var_18_8
		local var_18_17 = var_18_10 + var_18_6
		local var_18_18 = var_18_8 + var_18_5 * var_18_15
		local var_18_19 = var_18_10

		ScriptGUI.irect(var_18_1, var_18_2, var_18_3, var_18_16, var_18_17, var_18_8 + var_18_5, var_18_19, 1, Color(100, 10, 10, 10))
		ScriptGUI.irect(var_18_1, var_18_2, var_18_3, var_18_16, var_18_17, var_18_18, var_18_19, 2, var_18_0[iter_18_0])

		var_18_10 = var_18_10 + var_18_6 + var_18_7
	end

	ScriptGUI.itext(var_18_1, var_18_2, var_18_3, "[Player Intensity]", var_0_4, var_0_0, var_0_3, var_18_8, var_18_9, 3, Color(255, 237, 237, 152))

	local var_18_20 = var_18_10 + var_18_6 * 1

	ScriptGUI.itext(var_18_1, var_18_2, var_18_3, "[Total Intensity]", var_0_4, var_0_0, var_0_3, var_18_8, var_18_20 + var_18_6 * 0.75, 3, Color(255, 237, 237, 152))

	local var_18_21 = var_18_20 + var_18_6 * 1

	ScriptGUI.irect(var_18_1, var_18_2, var_18_3, var_18_8, var_18_21 + var_18_6, var_18_8 + var_18_5, var_18_21, 1, Color(100, 90, 10, 10))
	ScriptGUI.irect(var_18_1, var_18_2, var_18_3, var_18_8, var_18_21 + var_18_6, var_18_8 + var_18_5 * var_18_13 * 0.01, var_18_21, 2, Color(200, 130, 10, 10))

	local var_18_22 = ""

	if var_18_11:intensity_decay_frozen() then
		var_18_22 = string.format("decay delay frozen: %.1f", math.clamp(var_18_11.frozen_intensity_decay_until - arg_18_1, 0, 100))
	elseif var_18_12:ignore_pacing_intensity_decay_delay() then
		var_18_22 = "decay delay: ignored"
	else
		local var_18_23 = Managers.player:local_player(1)

		if ScriptUnit.has_extension(var_18_23.player_unit, "status_system") then
			-- block empty
		end
	end

	local var_18_24 = var_18_21 + var_18_6 * 1.5
	local var_18_25 = 22

	ScriptGUI.itext(var_18_1, var_18_2, var_18_3, var_18_22, var_0_4, var_18_25, var_0_3, var_18_8, var_18_24 + var_18_6 * 0.75, 3, Color(255, 200, 200, 32))
end

function AIDebugger.debug_pacing(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.screen_gui
	local var_19_1 = Managers.state.conflict
	local var_19_2, var_19_3 = Application.resolution()
	local var_19_4 = 0.02
	local var_19_5 = 0.3
	local var_19_6 = 0.2
	local var_19_7 = 0.0025
	local var_19_8 = 0.45
	local var_19_9 = 0.01
	local var_19_10 = var_19_9
	local var_19_11 = CurrentPacing.name or "default"
	local var_19_12 = ScriptGUI.itext_next_xy(var_19_0, var_19_2, var_19_3, "Pacing: ", var_0_4, var_0_0, var_0_3, var_19_8 + var_19_7, var_19_10 + var_19_4, 3, Color(255, 237, 237, 152))
	local var_19_13 = ScriptGUI.itext_next_xy(var_19_0, var_19_2, var_19_3, var_19_11, var_0_4, var_0_0, var_0_3, var_19_12, var_19_10 + var_19_4, 3, Color(255, 137, 237, 137))
	local var_19_14 = ScriptGUI.itext_next_xy(var_19_0, var_19_2, var_19_3, "Conflict setting: ", var_0_4, var_0_0, var_0_3, var_19_13, var_19_10 + var_19_4, 3, Color(255, 237, 237, 152))
	local var_19_15 = ScriptGUI.itext_next_xy(var_19_0, var_19_2, var_19_3, tostring(var_19_1.current_conflict_settings), var_0_4, var_0_0, var_0_3, var_19_14, var_19_10 + var_19_4, 3, Color(255, 137, 237, 137))
	local var_19_16 = var_19_10 + 0.03
	local var_19_17
	local var_19_18
	local var_19_19, var_19_20, var_19_21, var_19_22, var_19_23, var_19_24 = var_19_1.pacing:get_pacing_data()
	local var_19_25 = var_19_21 > 0 and "[Roamers]" or "[NO Roamers]"
	local var_19_26 = var_19_23 > 0 and "[Specials]" or "[NO Specials]"
	local var_19_27 = var_19_23 > 0 and "[Hordes]" or "[NO Hordes]"

	if var_19_24 then
		local var_19_28 = math.clamp(var_19_24 - arg_19_1, 0, 999999)

		var_19_17 = string.format("State: %s time left: %.1f", var_19_19, var_19_28)
		var_19_18 = string.format("%s%s%s", var_19_25, var_19_26, var_19_27)
	else
		var_19_17 = string.format("State: %s runtime: %.1f", var_19_19, arg_19_1 - var_19_20)
		var_19_18 = string.format("%s%s%s", var_19_25, var_19_26, var_19_27)
	end

	ScriptGUI.itext(var_19_0, var_19_2, var_19_3, var_19_17, var_0_4, var_0_1, var_0_3, var_19_8 + var_19_7, var_19_16 + var_19_4, 3, Color(255, 237, 237, 152))

	local var_19_29 = var_19_16 + 0.03

	ScriptGUI.itext(var_19_0, var_19_2, var_19_3, var_19_18, var_0_4, var_0_1, var_0_3, var_19_8 + var_19_7, var_19_29 + var_19_4, 3, Color(255, 137, 237, 152))

	local var_19_30 = var_19_29 + 0.03
	local var_19_31 = "Horde debugging is disabled on clients"

	if Managers.state.network.is_server then
		if script_data.ai_horde_spawning_disabled then
			var_19_31 = string.format("Horde spawning is disabled")
		else
			local var_19_32, var_19_33, var_19_34 = var_19_1:get_horde_data()

			if #var_19_33 > 0 then
				var_19_31 = string.format("Number of hordes active: %d  horde size:%d", #var_19_33, var_19_1:horde_size())
			elseif var_19_23 > 0 then
				if var_19_32 then
					var_19_31 = string.format("Next horde in: %.1fs horde size:%d", var_19_32 - arg_19_1, var_19_1:horde_size())
				else
					var_19_31 = "Next horde in: N/A"
				end
			else
				var_19_31 = string.format("No horde will spawn during this state")
			end

			if var_19_34 then
				local var_19_35 = string.format("Horde waves left: %d", var_19_34)

				ScriptGUI.itext(var_19_0, var_19_2, var_19_3, var_19_35, var_0_4, var_0_1, var_0_3, var_19_8 + var_19_7, var_19_30 + var_19_4, 3, Color(255, 237, 237, 152))

				var_19_30 = var_19_30 + 0.03
			end
		end
	end

	ScriptGUI.itext(var_19_0, var_19_2, var_19_3, var_19_31, var_0_4, var_0_1, var_0_3, var_19_8 + var_19_7, var_19_30 + var_19_4, 3, Color(255, 237, 237, 152))

	local var_19_36 = var_19_30 + 0.03

	if var_19_1.players_speeding_dist then
		local var_19_37 = CurrentPacing.relax_rushing_distance
		local var_19_38 = string.format("Players rushing dist: %d / %d", var_19_1.players_speeding_dist, var_19_37)

		ScriptGUI.itext(var_19_0, var_19_2, var_19_3, var_19_38, var_0_4, var_0_1, var_0_3, var_19_8 + var_19_7, var_19_36 + var_19_4, 3, Color(255, 237, 237, 152))

		var_19_36 = var_19_36 + 0.03
	end

	ScriptGUI.irect(var_19_0, var_19_2, var_19_3, var_19_8, var_19_9, var_19_8 + var_19_5, var_19_36, 2, Color(100, 10, 10, 10))
end

local var_0_8 = false

function AIDebugger.draw_hint(arg_20_0, arg_20_1)
	if script_data and script_data.disable_debug_draw then
		return
	end

	if var_0_8 then
		return
	end

	local var_20_0 = arg_20_0.screen_gui
	local var_20_1, var_20_2 = Application.resolution()

	if script_data.debug_key_handler_visible then
		arg_20_0.hint_time_when_key_handle_visible = arg_20_1

		return
	end

	local var_20_3 = arg_20_1 - arg_20_0.hint_time_when_key_handle_visible

	if var_20_3 > math.pi * 2 then
		var_0_8 = true

		return
	end

	local var_20_4 = math.min(1, math.sin(var_20_3 * 0.5) * 3) * 255
	local var_20_5 = "Hint: you can show ai debugger shortcuts by enabling 'debug_key_handler_visible' in the debug menu"
	local var_20_6, var_20_7 = Gui.text_extents(var_20_0, var_20_5, var_0_4, var_0_0)
	local var_20_8 = var_20_7.x - var_20_6.x
	local var_20_9 = var_20_1 / 2 - var_20_8 / 2

	Gui.text(var_20_0, var_20_5, var_0_4, var_0_0, var_0_3, Vector3(var_20_9, 20, 150), Color(var_20_4, 255, 255, 255))
	Gui.rect(var_20_0, Vector3(var_20_9 - 20, 0, 100), Vector2(var_20_8 + 40, 50), Color(var_20_4 * 0.75, 25, 50, 25))
end

function AIDebugger.create_fake_players(arg_21_0)
	local var_21_0 = Managers.player:player_from_peer_id(Network.peer_id()).player_unit
	local var_21_1 = POSITION_LOOKUP[var_21_0]
	local var_21_2 = Managers.state.entity:system("ai_system"):nav_world()

	arg_21_0._fake_players = {}
	arg_21_0._fake_players[1] = Vector3Box(var_21_1)

	for iter_21_0 = 2, 4 do
		arg_21_0._fake_players[iter_21_0] = Vector3Box(LocomotionUtils.new_random_goal(var_21_2, nil, var_21_1, 5, 20, 10))
	end

	return arg_21_0._fake_players
end

function AIDebugger.fake_players(arg_22_0)
	return arg_22_0._fake_players
end

function AIDebugger.draw_extensions(arg_23_0, arg_23_1)
	if not arg_23_0.show_extensions then
		return
	end

	local var_23_0 = arg_23_0.screen_gui
	local var_23_1 = BLACKBOARDS[arg_23_1]
	local var_23_2, var_23_3 = Application.resolution()
	local var_23_4 = var_23_3 - 120
	local var_23_5 = Vector3(200, var_23_4, 150)
	local var_23_6 = 1
	local var_23_7 = string.format("Extensions for %s", var_23_1.breed.name)

	Gui.text(var_23_0, var_23_7, var_0_4, var_0_0, var_0_3, var_23_5, Color(255, 255, 255, 255))

	var_23_5.y = var_23_5.y - var_0_0

	local var_23_8 = ScriptUnit.extensions(arg_23_1)

	for iter_23_0, iter_23_1 in pairs(var_23_8) do
		var_23_5.y = var_23_5.y - var_0_2

		if var_23_5.y < 100 then
			var_23_5.y = var_23_4 - var_0_0 - var_0_2
			var_23_5.x = var_23_5.x + 500
			var_23_6 = var_23_6 + 1
		end

		Gui.text(var_23_0, iter_23_0, var_0_4, var_0_2, var_0_3, var_23_5, Color(255, 255, 255, 255))
	end

	var_23_5.y = var_23_5.y - var_0_2

	if var_23_6 == 1 then
		Gui.rect(var_23_0, Vector3(150, var_23_5.y, 100), Vector2(var_23_5.x + 400, var_23_4 - var_23_5.y + var_0_2 * 3), Color(240, 25, 50, 25))
	else
		Gui.rect(var_23_0, Vector3(150, 0, 100), Vector2(var_23_5.x + 400, var_23_4 + 50), Color(240, 25, 50, 25))
	end
end
