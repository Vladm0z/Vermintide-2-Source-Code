-- chunkname: @scripts/managers/debug/debug.lua

local var_0_0 = "arial"
local var_0_1 = 26
local var_0_2 = "materials/fonts/" .. var_0_0

Debug = Debug or {}

Debug.setup = function (arg_1_0, arg_1_1)
	Debug.active = BUILD ~= "release"
	Debug.world = arg_1_0
	Debug.world_name = arg_1_1
	Debug.gui = World.create_screen_gui(arg_1_0, "material", "materials/fonts/gw_fonts", "immediate")
	Debug.debug_texts = {}
	Debug.sticky_texts = {}
	Debug.line_objects = {}

	Debug.create_line_object("default")

	Debug.world_texts = {}
	Debug.world_sticky_texts = {}
	Debug.world_sticky_index = 0
	Debug.num_world_sticky_texts = 0
end

Debug.font = var_0_0
Debug.font_mtrl = var_0_2
Debug.font_size = 26

Debug.create_line_object = function (arg_2_0)
	local var_2_0 = false

	Debug.line_objects[arg_2_0] = World.create_line_object(Debug.world, var_2_0)

	return Debug.line_objects[arg_2_0]
end

Debug.test_popup = function ()
	local var_3_0 = Localize("popup_debug_header")
	local var_3_1 = Localize("popup_debug_message") .. "\nhost_name"

	Debug.popup_id = Managers.popup:queue_popup(var_3_1, var_3_0, "cancel", Localize("popup_choice_cancel"))

	Managers.popup:activate_timer(Debug.popup_id, 120, "cancel")
end

Debug.update = function (arg_4_0, arg_4_1)
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	if Debug.popup_id and Managers.popup:query_result(Debug.popup_id) == "cancel" then
		Managers.popup:cancel_popup(Debug.popup_id)

		Debug.popup_id = nil
	end

	local var_4_0 = not script_data.hide_debug_text_background
	local var_4_1 = RESOLUTION_LOOKUP.res_w
	local var_4_2 = RESOLUTION_LOOKUP.res_h
	local var_4_3 = Debug.gui
	local var_4_4 = var_4_2 - 100
	local var_4_5 = Color(120, 220, 0)
	local var_4_6 = #Debug.debug_texts

	if var_4_6 > 100 then
		-- Nothing
	end

	local var_4_7 = Gui.FormatDirectives + Gui.MultiColor

	for iter_4_0 = 1, var_4_6 do
		local var_4_8 = Debug.debug_texts[iter_4_0]
		local var_4_9 = var_4_8.text
		local var_4_10 = var_4_8.color
		local var_4_11 = Vector3(130, var_4_4, 700)

		Gui.text(var_4_3, var_4_9, var_0_2, var_0_1, var_0_0, var_4_11, var_4_10 and var_4_10:unbox() or var_4_5, var_4_7)

		if var_4_0 then
			local var_4_12, var_4_13 = Gui.text_extents(var_4_3, var_4_9, var_0_2, var_0_1)

			Gui.rect(var_4_3, var_4_11 + Vector3(-5, -6, -100), Vector3(var_4_13.x - var_4_12.x + 20, var_0_1 + 2, 0), Color(75, 0, 0, 0))
		end

		var_4_4 = var_4_4 - (var_0_1 + 2)
		Debug.debug_texts[iter_4_0] = nil
	end

	local var_4_14 = Debug.sticky_texts
	local var_4_15 = #var_4_14

	if var_4_15 > 0 then
		local var_4_16 = 1

		while var_4_16 <= var_4_15 do
			local var_4_17, var_4_18 = unpack(var_4_14[var_4_16])

			Gui.text(var_4_3, var_4_17, var_0_2, var_0_1, var_0_0, Vector3(10, var_4_4, 700), var_4_5, var_4_7)

			var_4_4 = var_4_4 - (var_0_1 + 2)

			if var_4_18 < arg_4_0 then
				table.remove(var_4_14, var_4_16)

				var_4_15 = var_4_15 - 1
			else
				var_4_16 = var_4_16 + 1
			end
		end
	end

	Debug.update_world_texts()
	Debug.update_world_sticky_texts()

	local var_4_19 = Debug.world

	for iter_4_1, iter_4_2 in pairs(Debug.line_objects) do
		LineObject.dispatch(var_4_19, iter_4_2)
	end

	if script_data.debug_cycle_select_inventory_item then
		local var_4_20 = Managers.matchmaking
		local var_4_21 = var_4_20 and var_4_20._ingame_ui

		if var_4_21 and var_4_21.current_view == "inventory_view" and arg_4_0 > (Debug.next_select_at or 0) then
			local var_4_22 = (Debug.previous_selected_item or 1) + 1

			if var_4_22 > 7 then
				var_4_22 = 1
			end

			Debug.previous_selected_item = var_4_22
			Debug.select_item = var_4_22
			Debug.next_select_at = arg_4_0 + 1
		end
	end
end

Debug.cond_text = function (arg_5_0, ...)
	if arg_5_0 then
		Debug.text(...)
	end
end

Debug.text = function (...)
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local var_6_0 = FrameTable.alloc_table()

	var_6_0.text = string.format(...)

	table.insert(Debug.debug_texts, var_6_0)
end

Debug.colored_text = function (arg_7_0, ...)
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local var_7_0 = FrameTable.alloc_table()

	var_7_0.text = string.format(...)
	var_7_0.color = ColorBox(arg_7_0)

	table.insert(Debug.debug_texts, var_7_0)
end

local var_0_3 = 512
local var_0_4 = {
	red = {
		255,
		0,
		0
	},
	green = {
		0,
		200,
		0
	},
	blue = {
		0,
		0,
		200
	},
	white = {
		255,
		255,
		255
	},
	yellow = {
		200,
		200,
		0
	},
	teal = {
		0,
		200,
		200
	},
	purple = {
		200,
		0,
		160
	}
}

Debug.update_world_texts = function ()
	if not Managers.state.debug_text then
		return
	end

	local var_8_0 = Managers.state.debug_text._world_gui
	local var_8_1 = Debug.world_texts
	local var_8_2 = #var_8_1
	local var_8_3 = Application.main_world()

	if not ScriptWorld.has_viewport(var_8_3, "player_1") then
		return
	end

	local var_8_4 = ScriptWorld.viewport(Application.main_world(), "player_1")
	local var_8_5 = ScriptViewport.camera(var_8_4)
	local var_8_6 = Camera.local_pose(var_8_5)
	local var_8_7 = Matrix4x4.translation(var_8_6)

	for iter_8_0 = 1, var_8_2 do
		local var_8_8 = var_8_1[iter_8_0]
		local var_8_9 = var_8_8[1]
		local var_8_10 = Vector3(var_8_8[2], var_8_8[3], var_8_8[4])
		local var_8_11 = Quaternion.flat_no_roll(Quaternion.look(var_8_10 - var_8_7, Vector3.up()))
		local var_8_12 = 0.3
		local var_8_13, var_8_14, var_8_15 = Gui.text_extents(var_8_0, var_8_9, var_0_2, var_8_12)
		local var_8_16 = var_8_15[1]
		local var_8_17 = var_8_10 - Quaternion.right(var_8_11) * var_8_16 * 0.5
		local var_8_18 = Matrix4x4.from_quaternion_position(var_8_11, var_8_17)

		Gui.text_3d(var_8_0, var_8_9, var_0_2, var_8_12, var_0_0, var_8_18, Vector3.zero(), 1, Color(var_8_8[5], var_8_8[6], var_8_8[7]))

		var_8_1[iter_8_0] = nil
	end
end

Debug.update_world_sticky_texts = function ()
	if not Managers.state.debug_text then
		return
	end

	local var_9_0 = Managers.state.debug_text._world_gui
	local var_9_1 = Debug.world_sticky_texts
	local var_9_2 = Debug.num_world_sticky_texts
	local var_9_3 = Application.main_world()

	if not ScriptWorld.has_viewport(var_9_3, "player_1") then
		return
	end

	local var_9_4 = ScriptWorld.viewport(Application.main_world(), "player_1")
	local var_9_5 = ScriptViewport.camera(var_9_4)
	local var_9_6 = Camera.local_pose(var_9_5)
	local var_9_7 = Matrix4x4.translation(var_9_6)

	for iter_9_0 = 1, var_9_2 do
		local var_9_8 = var_9_1[iter_9_0]
		local var_9_9 = var_9_8[1]
		local var_9_10 = Vector3(var_9_8[2], var_9_8[3], var_9_8[4])
		local var_9_11 = Quaternion.flat_no_roll(Quaternion.look(var_9_10 - var_9_7, Vector3.up()))
		local var_9_12 = 0.3
		local var_9_13, var_9_14, var_9_15 = Gui.text_extents(var_9_0, var_9_9, var_0_2, var_9_12)
		local var_9_16 = var_9_15[1]
		local var_9_17 = var_9_10 - Quaternion.right(var_9_11) * var_9_16 * 0.5
		local var_9_18 = Matrix4x4.from_quaternion_position(var_9_11, var_9_17)

		Gui.text_3d(var_9_0, var_9_9, var_0_2, var_9_12, var_0_0, var_9_18, Vector3.zero(), 1, Color(var_9_8[5], var_9_8[6], var_9_8[7]))
	end
end

Debug.world_text = function (arg_10_0, arg_10_1, arg_10_2)
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local var_10_0 = Debug.world_texts
	local var_10_1 = var_0_4[arg_10_2] or var_0_4.white
	local var_10_2 = #var_10_0 + 1

	if var_10_0[var_10_2] then
		var_10_0[var_10_2][1] = arg_10_1
		var_10_0[var_10_2][2] = arg_10_0[1]
		var_10_0[var_10_2][3] = arg_10_0[2]
		var_10_0[var_10_2][4] = arg_10_0[3]
		var_10_0[var_10_2][5] = var_10_1[1]
		var_10_0[var_10_2][6] = var_10_1[2]
		var_10_0[var_10_2][7] = var_10_1[3]
	else
		var_10_0[var_10_2] = {
			arg_10_1,
			arg_10_0[1],
			arg_10_0[2],
			arg_10_0[3],
			var_10_1[1],
			var_10_1[2],
			var_10_1[3]
		}
	end
end

Debug.world_sticky_text = function (arg_11_0, arg_11_1, arg_11_2)
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local var_11_0 = Debug.world_sticky_texts
	local var_11_1 = Debug.world_sticky_index + 1

	if var_11_1 > var_0_3 then
		var_11_1 = 1
	end

	Debug.num_world_sticky_texts = math.clamp(Debug.num_world_sticky_texts + 1, 0, var_0_3)

	local var_11_2 = var_0_4[arg_11_2] or var_0_4.white

	if var_11_0[var_11_1] then
		var_11_0[var_11_1][1] = arg_11_1
		var_11_0[var_11_1][2] = arg_11_0[1]
		var_11_0[var_11_1][3] = arg_11_0[2]
		var_11_0[var_11_1][4] = arg_11_0[3]
		var_11_0[var_11_1][5] = var_11_2[1]
		var_11_0[var_11_1][6] = var_11_2[2]
		var_11_0[var_11_1][7] = var_11_2[3]
	else
		var_11_0[var_11_1] = {
			arg_11_1,
			arg_11_0[1],
			arg_11_0[2],
			arg_11_0[3],
			var_11_2[1],
			var_11_2[2],
			var_11_2[3]
		}
	end

	Debug.world_sticky_index = var_11_1
end

Debug.reset_sticky_world_texts = function ()
	Debug.num_world_sticky_texts = 0
	Debug.world_sticky_index = 0
end

Debug.sticky_text = function (...)
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local var_13_0 = {
		...
	}
	local var_13_1 = 3

	var_13_1 = var_13_0[#var_13_0 - 1] == "delay" and var_13_0[#var_13_0] or var_13_1

	table.insert(Debug.sticky_texts, {
		string.format(...),
		Managers.time:time("game") + var_13_1
	})
end

Debug.drawer = function (arg_14_0, arg_14_1)
	arg_14_0 = arg_14_0 or "default"

	local var_14_0 = Debug.line_objects[arg_14_0] or Debug.create_line_object(arg_14_0)

	return DebugDrawer:new(var_14_0, to_boolean(not arg_14_1))
end

Debug.draw_text = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = Debug.gui
	local var_15_1 = arg_15_2 or var_0_1
	local var_15_2 = Vector3(arg_15_1.x, RESOLUTION_LOOKUP.res_h - arg_15_1.y - var_15_1, arg_15_1.z)

	Gui.text(var_15_0, arg_15_0, var_0_2, arg_15_2 or var_0_1, var_0_0, var_15_2, arg_15_3 or Color(120, 220, 0), "shadow")
end

Debug.draw_rect = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = Debug.gui
	local var_16_1 = Vector3(arg_16_0.x, RESOLUTION_LOOKUP.res_h - arg_16_0.y, arg_16_0.z)
	local var_16_2 = Vector3(arg_16_1.x, -arg_16_1.y, arg_16_1.z)

	Gui.rect(var_16_0, var_16_1, var_16_2, arg_16_2)
end

Debug.teardown = function ()
	Debug.active = false

	local var_17_0 = Debug.world

	for iter_17_0, iter_17_1 in pairs(Debug.line_objects) do
		World.destroy_line_object(var_17_0, iter_17_1)
	end

	table.clear(Debug.line_objects)
end

Debug.animation_log_specific_profile = function (arg_18_0, arg_18_1)
	local var_18_0 = Managers.player:players()

	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		local var_18_1 = iter_18_1.owned_units

		for iter_18_2, iter_18_3 in pairs(var_18_1) do
			if ScriptUnit.has_extension(iter_18_3, "status_system") then
				local var_18_2 = ScriptUnit.extension(iter_18_3, "status_system").profile_id

				if SPProfiles[var_18_2].display_name == arg_18_0 then
					print("animation logging enabled for:" .. arg_18_0)
					Unit.set_animation_logging(iter_18_3, arg_18_1)
				end
			end
		end
	end
end

Debug.spawn_hero = function (arg_19_0)
	local var_19_0 = Managers.state.spawn.hero_spawner_handler
	local var_19_1 = Network.peer_id()
	local var_19_2 = Managers.player:player_from_peer_id(var_19_1)

	var_19_0:spawn_hero_request(var_19_2, arg_19_0)
end

Debug.load_level = function (arg_20_0, arg_20_1, arg_20_2)
	Managers.mechanism:debug_load_level(arg_20_0, arg_20_1)

	if arg_20_2 ~= nil then
		StateIngame._level_flow_events = {
			arg_20_2
		}
	else
		StateIngame._level_flow_events = nil
	end
end

Debug.level_loaded = function (arg_21_0)
	if not Managers.state then
		return false
	end

	local var_21_0 = Managers.level_transition_handler

	if var_21_0:get_current_level_key() ~= arg_21_0 then
		return false
	end

	if not var_21_0:all_packages_loaded() then
		return false
	end

	local var_21_1 = Network.peer_id()
	local var_21_2 = Managers.player:player_from_peer_id(var_21_1)
	local var_21_3 = var_21_2 and var_21_2.player_unit

	if not Unit.alive(var_21_3) then
		return false
	end

	return true
end

Debug.visualize_level_unit = function (arg_22_0)
	local var_22_0 = Managers.state.networked_flow_state._level

	if not var_22_0 then
		return
	end

	local var_22_1 = Level.unit_by_index(var_22_0, arg_22_0)

	if not var_22_1 then
		return
	end

	local var_22_2 = Unit.world_position(var_22_1, 0)

	QuickDrawer:sphere(var_22_2, 1, Colors.get("medium_aqua_marine"))

	for iter_22_0 = 1, 20 do
		QuickDrawer:sphere(var_22_2, iter_22_0 * 10, Colors.get("medium_aqua_marine"))
	end
end

Debug.aim_position = function ()
	local var_23_0 = Managers.player:local_player(1)
	local var_23_1 = var_23_0.player_unit
	local var_23_2 = Managers.state.camera:camera_position(var_23_0.viewport_name)
	local var_23_3 = Managers.state.camera:camera_rotation(var_23_0.viewport_name)
	local var_23_4 = Quaternion.forward(var_23_3)
	local var_23_5 = "filter_ray_projectile"
	local var_23_6 = Managers.state.spawn.world
	local var_23_7 = World.get_data(var_23_6, "physics_world")
	local var_23_8 = PhysicsWorld.immediate_raycast(var_23_7, var_23_2, var_23_4, 100, "all", "collision_filter", var_23_5)

	if var_23_8 then
		local var_23_9 = #var_23_8

		for iter_23_0 = 1, var_23_9 do
			local var_23_10 = var_23_8[iter_23_0]
			local var_23_11 = var_23_10[4]

			if not (Actor.unit(var_23_11) == var_23_1) then
				return var_23_10[1], var_23_10[2], var_23_10[3], var_23_10[4]
			end
		end
	end
end

Debug.test_spawn_unit = function (arg_24_0, arg_24_1)
	arg_24_0 = arg_24_0 or "wood_elf"
	arg_24_1 = arg_24_1 or 1

	local var_24_0 = FindProfileIndex(arg_24_0)
	local var_24_1 = SPProfiles[var_24_0].careers[arg_24_1]
	local var_24_2 = var_24_1.name
	local var_24_3 = BackendUtils.get_loadout_item(var_24_2, "slot_skin")
	local var_24_4 = var_24_3 and var_24_3.data
	local var_24_5 = var_24_4 and var_24_4.name or var_24_1.base_skin
	local var_24_6 = {}
	local var_24_7 = Cosmetics[var_24_5]
	local var_24_8 = var_24_7.third_person
	local var_24_9 = var_24_7.material_changes

	var_24_6[#var_24_6 + 1] = var_24_8

	if var_24_9 then
		local var_24_10 = var_24_9.package_name

		var_24_6[#var_24_6 + 1] = var_24_10
	end

	for iter_24_0, iter_24_1 in ipairs(var_24_6) do
		Managers.package:load(iter_24_1, "debug", nil, false)
	end

	local var_24_11 = Managers.state.spawn.world
	local var_24_12 = Debug.aim_position()
	local var_24_13 = var_24_7.third_person
	local var_24_14 = var_24_7.color_tint
	local var_24_15 = World.spawn_unit(var_24_11, var_24_13, var_24_12)
	local var_24_16 = var_24_7.material_changes

	if var_24_16 then
		local var_24_17 = var_24_16.third_person

		for iter_24_2, iter_24_3 in pairs(var_24_17) do
			Unit.set_material(var_24_15, iter_24_2, iter_24_3)
			Unit.set_material(var_24_15, iter_24_2, iter_24_3)
		end
	end

	Debug.test_unit = var_24_15
end

Debug.test_despawn_unit = function (arg_25_0, arg_25_1)
	local var_25_0 = Managers.state.spawn.world
	local var_25_1 = Debug.test_unit

	if not var_25_1 then
		return
	end

	World.destroy_unit(var_25_0, var_25_1)

	arg_25_0 = arg_25_0 or "wood_elf"
	arg_25_1 = arg_25_1 or 1

	local var_25_2 = FindProfileIndex(arg_25_0)
	local var_25_3 = SPProfiles[var_25_2].careers[arg_25_1]
	local var_25_4 = var_25_3.name
	local var_25_5 = BackendUtils.get_loadout_item(var_25_4, "slot_skin")
	local var_25_6 = var_25_5 and var_25_5.data
	local var_25_7 = var_25_6 and var_25_6.name or var_25_3.base_skin
	local var_25_8 = {}
	local var_25_9 = Cosmetics[var_25_7]
	local var_25_10 = var_25_9.third_person
	local var_25_11 = var_25_9.material_changes

	var_25_8[#var_25_8 + 1] = var_25_10

	if var_25_11 then
		local var_25_12 = var_25_11.package_name

		var_25_8[#var_25_8 + 1] = var_25_12
	end

	for iter_25_0, iter_25_1 in ipairs(var_25_8) do
		Managers.package:unload(iter_25_1, "debug", nil, false)
	end
end

Debug.create_jira_issue = function ()
	local var_26_0, var_26_1 = pcall(require, "core/plugins/reporter")

	if var_26_0 then
		Reporter.create_jira_issue("honduras")
	end
end

Debug._hook_data = Debug._hook_data or {}

Debug.hook = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = Debug._hook_data[arg_27_0]

	if not var_27_0 then
		var_27_0 = {}
		Debug._hook_data[arg_27_0] = var_27_0
	end

	local var_27_1 = var_27_0[arg_27_1]

	if not var_27_1 then
		var_27_1 = rawget(arg_27_0, arg_27_1)
		var_27_0[arg_27_1] = var_27_1

		assert(var_27_1)
	end

	rawset(arg_27_0, arg_27_1, function (...)
		return arg_27_2(var_27_1, ...)
	end)
end

Debug.unhook = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = Debug._hook_data[arg_29_0]

	if not var_29_0 then
		return assert(arg_29_2)
	end

	local var_29_1 = var_29_0[arg_29_1]

	if not var_29_1 then
		return assert(arg_29_2)
	end

	rawset(arg_29_0, arg_29_1, var_29_1)

	return true
end
