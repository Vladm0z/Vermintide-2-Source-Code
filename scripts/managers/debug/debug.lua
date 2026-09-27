-- chunkname: @scripts/managers/debug/debug.lua

local str = "arial"
local num = 26
local str_2 = "materials/fonts/" .. str
local Debug = Debug

Debug = Debug or {}
Debug = Debug

Debug.setup = function (arg_1_0, arg_1_1)
	-- function 1
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

Debug.font = str
Debug.font_mtrl = str_2
Debug.font_size = 26

Debug.create_line_object = function (arg_2_0)
	-- function 2
	local flag = false

	Debug.line_objects[arg_2_0] = World.create_line_object(Debug.world, flag)

	return Debug.line_objects[arg_2_0]
end

Debug.test_popup = function ()
	-- function 3
	local var_3_0 = Localize("popup_debug_header")
	local str = Localize("popup_debug_message") .. "\nhost_name"

	Debug.popup_id = Managers.popup:queue_popup(str, var_3_0, "cancel", Localize("popup_choice_cancel"))

	Managers.popup:activate_timer(Debug.popup_id, 120, "cancel")
end

Debug.update = function (arg_4_0, arg_4_1)
	-- function 4
	if not Debug.active and not script_data and not script_data.disable_debug_draw then
		return
	end

	if not (not Debug.popup_id and Managers.popup:query_result(Debug.popup_id) ~= "cancel") then
		Managers.popup:cancel_popup(Debug.popup_id)

		Debug.popup_id = nil
	end

	local flag = not script_data.hide_debug_text_background
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local gui = Debug.gui
	local num_2 = res_h - 100
	local var_4_5 = Color(120, 220, 0)
	local count = #Debug.debug_texts

	if count > 100 then
		-- Nothing
	end

	local num_3 = Gui.FormatDirectives + Gui.MultiColor

	for i = 1, count do
		local var_4_8 = Debug.debug_texts[i]
		local text = var_4_8.text
		local color = var_4_8.color
		local var_4_11 = Vector3(130, num_2, 700)
		local text_2 = Gui.text
		local var_4_13 = gui
		local var_4_14 = text
		local var_4_15 = str_2
		local var_4_16 = num
		local var_4_17 = str
		local var_4_18 = var_4_11
		local unbox

		if not color then
			unbox = color:unbox()

			if not unbox then
				-- Nothing
			end
		end

		unbox = var_4_5

		::label_4_0::

		text_2(var_4_13, var_4_14, var_4_15, var_4_16, var_4_17, var_4_18, unbox, num_3)

		if not flag then
			local text_extents, var_4_21 = Gui.text_extents(gui, text, str_2, num)

			Gui.rect(gui, var_4_11 + Vector3(-5, -6, -100), Vector3(var_4_21.x - text_extents.x + 20, num + 2, 0), Color(75, 0, 0, 0))
		end

		num_2 = num_2 - (num + 2)
		Debug.debug_texts[i] = nil
	end

	local sticky_texts = Debug.sticky_texts
	local count_2 = #sticky_texts

	if count_2 > 0 then
		local num_4 = 1

		while num_4 <= count_2 do
			local var_4_25, var_4_26 = unpack(sticky_texts[num_4])

			Gui.text(gui, var_4_25, str_2, num, str, Vector3(10, num_2, 700), var_4_5, num_3)

			num_2 = num_2 - (num + 2)

			if var_4_26 < arg_4_0 then
				table.remove(sticky_texts, num_4)

				count_2 = count_2 - 1
			else
				num_4 = num_4 + 1
			end
		end
	end

	Debug.update_world_texts()
	Debug.update_world_sticky_texts()

	local world = Debug.world

	for k, v in pairs(Debug.line_objects) do
		LineObject.dispatch(world, v)
	end

	if not script_data.debug_cycle_select_inventory_item then
		local matchmaking = Managers.matchmaking
		local flag_2 = not matchmaking and matchmaking._ingame_ui

		if not (not flag_2 and flag_2.current_view == "inventory_view") then
			local next_select_at = Debug.next_select_at

			next_select_at = next_select_at or 0

			if next_select_at < arg_4_0 then
				local previous_selected_item = Debug.previous_selected_item

				previous_selected_item = previous_selected_item or 1

				local num_5 = previous_selected_item + 1

				if num_5 > 7 then
					num_5 = 1
				end

				Debug.previous_selected_item = num_5
				Debug.select_item = num_5
				Debug.next_select_at = arg_4_0 + 1
			end
		end
	end
end

Debug.cond_text = function (arg_5_0, ...)
	-- function 5
	if not arg_5_0 then
		Debug.text(...)
	end
end

Debug.text = function (...)
	-- function 6
	if not Debug.active and not script_data and not script_data.disable_debug_draw then
		return
	end

	local alloc_table = FrameTable.alloc_table()

	alloc_table.text = string.format(...)

	table.insert(Debug.debug_texts, alloc_table)
end

Debug.colored_text = function (arg_7_0, ...)
	-- function 7
	if not Debug.active and not script_data and not script_data.disable_debug_draw then
		return
	end

	local alloc_table = FrameTable.alloc_table()

	alloc_table.text = string.format(...)
	alloc_table.color = ColorBox(arg_7_0)

	table.insert(Debug.debug_texts, alloc_table)
end

local num_2 = 512
local tbl = {
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
	-- function 8
	if not Managers.state.debug_text then
		return
	end

	local _world_gui = Managers.state.debug_text._world_gui
	local world_texts = Debug.world_texts
	local count = #world_texts
	local main_world = Application.main_world()

	if not ScriptWorld.has_viewport(main_world, "player_1") then
		return
	end

	local viewport = ScriptWorld.viewport(Application.main_world(), "player_1")
	local camera = ScriptViewport.camera(viewport)
	local local_pose = Camera.local_pose(camera)
	local translation = Matrix4x4.translation(local_pose)

	for i = 1, count do
		local var_8_8 = world_texts[i]
		local var_8_9 = var_8_8[1]
		local var_8_10 = Vector3(var_8_8[2], var_8_8[3], var_8_8[4])
		local flat_no_roll = Quaternion.flat_no_roll(Quaternion.look(var_8_10 - translation, Vector3.up()))
		local num = 0.3
		local text_extents, var_8_14, var_8_15 = Gui.text_extents(_world_gui, var_8_9, str_2, num)
		local var_8_16 = var_8_15[1]
		local num_2 = var_8_10 - Quaternion.right(flat_no_roll) * var_8_16 * 0.5
		local from_quaternion_position = Matrix4x4.from_quaternion_position(flat_no_roll, num_2)

		Gui.text_3d(_world_gui, var_8_9, str_2, num, str, from_quaternion_position, Vector3.zero(), 1, Color(var_8_8[5], var_8_8[6], var_8_8[7]))

		world_texts[i] = nil
	end
end

Debug.update_world_sticky_texts = function ()
	-- function 9
	if not Managers.state.debug_text then
		return
	end

	local _world_gui = Managers.state.debug_text._world_gui
	local world_sticky_texts = Debug.world_sticky_texts
	local num_world_sticky_texts = Debug.num_world_sticky_texts
	local main_world = Application.main_world()

	if not ScriptWorld.has_viewport(main_world, "player_1") then
		return
	end

	local viewport = ScriptWorld.viewport(Application.main_world(), "player_1")
	local camera = ScriptViewport.camera(viewport)
	local local_pose = Camera.local_pose(camera)
	local translation = Matrix4x4.translation(local_pose)

	for i = 1, num_world_sticky_texts do
		local var_9_8 = world_sticky_texts[i]
		local var_9_9 = var_9_8[1]
		local var_9_10 = Vector3(var_9_8[2], var_9_8[3], var_9_8[4])
		local flat_no_roll = Quaternion.flat_no_roll(Quaternion.look(var_9_10 - translation, Vector3.up()))
		local num = 0.3
		local text_extents, var_9_14, var_9_15 = Gui.text_extents(_world_gui, var_9_9, str_2, num)
		local var_9_16 = var_9_15[1]
		local num_2 = var_9_10 - Quaternion.right(flat_no_roll) * var_9_16 * 0.5
		local from_quaternion_position = Matrix4x4.from_quaternion_position(flat_no_roll, num_2)

		Gui.text_3d(_world_gui, var_9_9, str_2, num, str, from_quaternion_position, Vector3.zero(), 1, Color(var_9_8[5], var_9_8[6], var_9_8[7]))
	end
end

Debug.world_text = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not Debug.active and not script_data and not script_data.disable_debug_draw then
		return
	end

	local world_texts = Debug.world_texts
	local var_10_1 = tbl[arg_10_2]

	var_10_1 = var_10_1 or tbl.white

	local num = #world_texts + 1

	if not world_texts[num] then
		world_texts[num][1] = arg_10_1
		world_texts[num][2] = self[1]
		world_texts[num][3] = self[2]
		world_texts[num][4] = self[3]
		world_texts[num][5] = var_10_1[1]
		world_texts[num][6] = var_10_1[2]
		world_texts[num][7] = var_10_1[3]
	else
		world_texts[num] = {
			arg_10_1,
			self[1],
			self[2],
			self[3],
			var_10_1[1],
			var_10_1[2],
			var_10_1[3]
		}
	end
end

Debug.world_sticky_text = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not Debug.active and not script_data and not script_data.disable_debug_draw then
		return
	end

	local world_sticky_texts = Debug.world_sticky_texts
	local num = Debug.world_sticky_index + 1

	if num > num_2 then
		num = 1
	end

	Debug.num_world_sticky_texts = math.clamp(Debug.num_world_sticky_texts + 1, 0, num_2)

	local var_11_2 = tbl[arg_11_2]

	var_11_2 = var_11_2 or tbl.white

	if not world_sticky_texts[num] then
		world_sticky_texts[num][1] = arg_11_1
		world_sticky_texts[num][2] = self[1]
		world_sticky_texts[num][3] = self[2]
		world_sticky_texts[num][4] = self[3]
		world_sticky_texts[num][5] = var_11_2[1]
		world_sticky_texts[num][6] = var_11_2[2]
		world_sticky_texts[num][7] = var_11_2[3]
	else
		world_sticky_texts[num] = {
			arg_11_1,
			self[1],
			self[2],
			self[3],
			var_11_2[1],
			var_11_2[2],
			var_11_2[3]
		}
	end

	Debug.world_sticky_index = num
end

Debug.reset_sticky_world_texts = function ()
	-- function 12
	Debug.num_world_sticky_texts = 0
	Debug.world_sticky_index = 0
end

Debug.sticky_text = function (...)
	-- function 13
	if not Debug.active and not script_data and not script_data.disable_debug_draw then
		return
	end

	local tbl = {
		...
	}
	local num = 3

	num = tbl[#tbl - 1] ~= "delay" or not tbl[#tbl] or num

	table.insert(Debug.sticky_texts, {
		string.format(...),
		Managers.time:time("game") + num
	})
end

Debug.drawer = function (arg_14_0, arg_14_1)
	-- function 14
	arg_14_0 = arg_14_0 or "default"

	local var_14_0 = Debug.line_objects[arg_14_0]

	var_14_0 = var_14_0 or Debug.create_line_object(arg_14_0)

	return DebugDrawer:new(var_14_0, to_boolean(not arg_14_1))
end

Debug.draw_text = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local gui = Debug.gui
	local flag = arg_15_2 or num
	local var_15_2 = Vector3(arg_15_1.x, RESOLUTION_LOOKUP.res_h - arg_15_1.y - flag, arg_15_1.z)

	Gui.text(gui, arg_15_0, str_2, arg_15_2 or num, str, var_15_2, arg_15_3 or Color(120, 220, 0), "shadow")
end

Debug.draw_rect = function (self, arg_16_1, arg_16_2)
	-- function 16
	local gui = Debug.gui
	local var_16_1 = Vector3(self.x, RESOLUTION_LOOKUP.res_h - self.y, self.z)
	local var_16_2 = Vector3(arg_16_1.x, -arg_16_1.y, arg_16_1.z)

	Gui.rect(gui, var_16_1, var_16_2, arg_16_2)
end

Debug.teardown = function ()
	-- function 17
	Debug.active = false

	local world = Debug.world

	for k, v in pairs(Debug.line_objects) do
		World.destroy_line_object(world, v)
	end

	table.clear(Debug.line_objects)
end

Debug.animation_log_specific_profile = function (arg_18_0, arg_18_1)
	-- function 18
	local players = Managers.player:players()

	for k, v in pairs(players) do
		local owned_units = v.owned_units

		for k_2, v_2 in pairs(owned_units) do
			if not ScriptUnit.has_extension(v_2, "status_system") then
				local profile_id = ScriptUnit.extension(v_2, "status_system").profile_id

				if SPProfiles[profile_id].display_name == arg_18_0 then
					print("animation logging enabled for:" .. arg_18_0)
					Unit.set_animation_logging(v_2, arg_18_1)
				end
			end
		end
	end
end

Debug.spawn_hero = function (arg_19_0)
	-- function 19
	local hero_spawner_handler = Managers.state.spawn.hero_spawner_handler
	local peer_id = Network.peer_id()
	local player_from_peer_id = Managers.player:player_from_peer_id(peer_id)

	hero_spawner_handler:spawn_hero_request(player_from_peer_id, arg_19_0)
end

Debug.load_level = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
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
	-- function 21
	if not Managers.state then
		return false
	end

	local level_transition_handler = Managers.level_transition_handler

	if level_transition_handler:get_current_level_key() ~= arg_21_0 then
		return false
	end

	if not level_transition_handler:all_packages_loaded() then
		return false
	end

	local peer_id = Network.peer_id()
	local player_from_peer_id = Managers.player:player_from_peer_id(peer_id)
	local flag = not player_from_peer_id and player_from_peer_id.player_unit

	if not Unit.alive(flag) then
		return false
	end

	return true
end

Debug.visualize_level_unit = function (arg_22_0)
	-- function 22
	local _level = Managers.state.networked_flow_state._level

	if not _level then
		return
	end

	local unit_by_index = Level.unit_by_index(_level, arg_22_0)

	if not unit_by_index then
		return
	end

	local world_position = Unit.world_position(unit_by_index, 0)

	QuickDrawer:sphere(world_position, 1, Colors.get("medium_aqua_marine"))

	for i = 1, 20 do
		QuickDrawer:sphere(world_position, i * 10, Colors.get("medium_aqua_marine"))
	end
end

Debug.aim_position = function ()
	-- function 23
	local local_player = Managers.player:local_player(1)
	local player_unit = local_player.player_unit
	local camera_position = Managers.state.camera:camera_position(local_player.viewport_name)
	local camera_rotation = Managers.state.camera:camera_rotation(local_player.viewport_name)
	local forward = Quaternion.forward(camera_rotation)
	local str = "filter_ray_projectile"
	local world = Managers.state.spawn.world
	local get_data = World.get_data(world, "physics_world")
	local immediate_raycast = PhysicsWorld.immediate_raycast(get_data, camera_position, forward, 100, "all", "collision_filter", str)

	if not immediate_raycast then
		local count = #immediate_raycast

		for i = 1, count do
			local var_23_10 = immediate_raycast[i]
			local var_23_11 = var_23_10[4]

			if not (Actor.unit(var_23_11) == player_unit) then
				return var_23_10[1], var_23_10[2], var_23_10[3], var_23_10[4]
			end
		end
	end
end

Debug.test_spawn_unit = function (arg_24_0, arg_24_1)
	-- function 24
	arg_24_0 = arg_24_0 or "wood_elf"
	arg_24_1 = arg_24_1 or 1

	local var_24_0 = FindProfileIndex(arg_24_0)
	local var_24_1 = SPProfiles[var_24_0].careers[arg_24_1]
	local name = var_24_1.name
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_skin")
	local flag = not get_loadout_item and get_loadout_item.data
	local name_2

	if not flag then
		name_2 = flag.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = var_24_1.base_skin

	::label_24_0::

	local tbl = {}
	local var_24_7 = Cosmetics[name_2]
	local third_person = var_24_7.third_person
	local material_changes = var_24_7.material_changes

	tbl[#tbl + 1] = third_person

	if not material_changes then
		local package_name = material_changes.package_name

		tbl[#tbl + 1] = package_name
	end

	for i, v in ipairs(tbl) do
		Managers.package:load(v, "debug", nil, false)
	end

	local world = Managers.state.spawn.world
	local aim_position = Debug.aim_position()
	local third_person_2 = var_24_7.third_person
	local color_tint = var_24_7.color_tint
	local spawn_unit = World.spawn_unit(world, third_person_2, aim_position)
	local material_changes_2 = var_24_7.material_changes

	if not material_changes_2 then
		local third_person_3 = material_changes_2.third_person

		for k, v_2 in pairs(third_person_3) do
			Unit.set_material(spawn_unit, k, v_2)
			Unit.set_material(spawn_unit, k, v_2)
		end
	end

	Debug.test_unit = spawn_unit
end

Debug.test_despawn_unit = function (arg_25_0, arg_25_1)
	-- function 25
	local world = Managers.state.spawn.world
	local test_unit = Debug.test_unit

	if not test_unit then
		return
	end

	World.destroy_unit(world, test_unit)

	arg_25_0 = arg_25_0 or "wood_elf"
	arg_25_1 = arg_25_1 or 1

	local var_25_2 = FindProfileIndex(arg_25_0)
	local var_25_3 = SPProfiles[var_25_2].careers[arg_25_1]
	local name = var_25_3.name
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_skin")
	local flag = not get_loadout_item and get_loadout_item.data
	local name_2

	if not flag then
		name_2 = flag.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = var_25_3.base_skin

	::label_25_0::

	local tbl = {}
	local var_25_9 = Cosmetics[name_2]
	local third_person = var_25_9.third_person
	local material_changes = var_25_9.material_changes

	tbl[#tbl + 1] = third_person

	if not material_changes then
		local package_name = material_changes.package_name

		tbl[#tbl + 1] = package_name
	end

	for i, v in ipairs(tbl) do
		Managers.package:unload(v, "debug", nil, false)
	end
end

Debug.create_jira_issue = function ()
	-- function 26
	local var_26_0, var_26_1 = pcall(require, "core/plugins/reporter")

	if not var_26_0 then
		Reporter.create_jira_issue("honduras")
	end
end

local Debug_2 = Debug
local _hook_data = Debug._hook_data

_hook_data = _hook_data or {}
Debug_2._hook_data = _hook_data

Debug.hook = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
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
		-- function 28
		return arg_27_2(var_27_1, ...)
	end)
end

Debug.unhook = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
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
