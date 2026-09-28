-- chunkname: @scripts/managers/debug/debug.lua

local font, font_size = "arial", 26
local font_mtrl = "materials/fonts/" .. font
local Debug = Debug

Debug = not not Debug or not not {}
Debug = Debug

Debug.setup = function (world, world_name)
	-- function 1
	Debug.active = BUILD ~= "release"
	Debug.world = world
	Debug.world_name = world_name
	Debug.gui = World.create_screen_gui(world, "material", "materials/fonts/gw_fonts", "immediate")
	Debug.debug_texts = {}
	Debug.sticky_texts = {}
	Debug.line_objects = {}

	Debug.create_line_object("default")

	Debug.world_texts = {}
	Debug.world_sticky_texts = {}
	Debug.world_sticky_index = 0
	Debug.num_world_sticky_texts = 0
end

Debug.font = font
Debug.font_mtrl = font_mtrl
Debug.font_size = 26

Debug.create_line_object = function (name)
	-- function 2
	local disable_depth_test = false

	Debug.line_objects[name] = World.create_line_object(Debug.world, disable_depth_test)

	return Debug.line_objects[name]
end

Debug.test_popup = function ()
	-- function 3
	local header = Localize("popup_debug_header")
	local message = Localize("popup_debug_message") .. "\nhost_name"

	Debug.popup_id = Managers.popup:queue_popup(message, header, "cancel", Localize("popup_choice_cancel"))

	Managers.popup:activate_timer(Debug.popup_id, 120, "cancel")
end

Debug.update = function (t, dt)
	-- function 4
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	if Debug.popup_id then
		local result = Managers.popup:query_result(Debug.popup_id)

		if result == "cancel" then
			Managers.popup:cancel_popup(Debug.popup_id)

			Debug.popup_id = nil
		end
	end

	local show_debug_text_background = not script_data.hide_debug_text_background
	local res_x, res_y = RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h
	local gui = Debug.gui
	local pos = res_y - 100
	local text_color = Color(120, 220, 0)
	local num_debug_texts = #Debug.debug_texts
	local max = 100

	if max < num_debug_texts then
		-- Nothing
	end

	local bitmaskflags = Gui.FormatDirectives + Gui.MultiColor

	for i = 1, num_debug_texts do
		local data = Debug.debug_texts[i]
		local text = data.text
		local instance_text_color = data.color
		local text_pos = Vector3(130, pos, 700)
		local text_2 = Gui.text
		local var_4_1 = gui
		local var_4_2 = text
		local var_4_3 = font_mtrl
		local var_4_4 = font_size
		local var_4_5 = font
		local var_4_6 = text_pos
		local unbox

		if instance_text_color then
			unbox = instance_text_color:unbox()

			if not unbox then
				-- Nothing
			end
		end

		unbox = text_color

		::label_4_0::

		text_2(var_4_1, var_4_2, var_4_3, var_4_4, var_4_5, var_4_6, unbox, bitmaskflags)

		if show_debug_text_background then
			local text_min, text_max = Gui.text_extents(gui, text, font_mtrl, font_size)

			Gui.rect(gui, text_pos + Vector3(-5, -6, -100), Vector3(text_max.x - text_min.x + 20, font_size + 2, 0), Color(75, 0, 0, 0))
		end

		pos = pos - (font_size + 2)
		Debug.debug_texts[i] = nil
	end

	local sticky_texts = Debug.sticky_texts
	local num_sticky = #sticky_texts

	if num_sticky > 0 then
		local i = 1

		while i <= num_sticky do
			local text, display_time = unpack(sticky_texts[i])

			Gui.text(gui, text, font_mtrl, font_size, font, Vector3(10, pos, 700), text_color, bitmaskflags)

			pos = pos - (font_size + 2)

			if display_time < t then
				table.remove(sticky_texts, i)

				num_sticky = num_sticky - 1
			else
				i = i + 1
			end
		end
	end

	Debug.update_world_texts()
	Debug.update_world_sticky_texts()

	local w = Debug.world

	for lo_name, lo in pairs(Debug.line_objects) do
		LineObject.dispatch(w, lo)
	end

	if script_data.debug_cycle_select_inventory_item then
		local matchmaking_manager = Managers.matchmaking
		local ingame_ui = not not matchmaking_manager and not not matchmaking_manager._ingame_ui
		local inventory_view = not not ingame_ui and ingame_ui.current_view == "inventory_view"

		if inventory_view then
			local next_select_at_2 = Debug.next_select_at

			if not next_select_at_2 then
				-- Nothing
			end

			next_select_at_2 = 0

			local next_select_at = next_select_at_2

			::label_4_1::

			if next_select_at < t then
				local previous_selected_item = Debug.previous_selected_item

				if not previous_selected_item then
					-- Nothing
				end

				previous_selected_item = 1

				local selected_item = previous_selected_item

				::label_4_2::

				local next_select_item = selected_item + 1

				if next_select_item > 7 then
					next_select_item = 1
				end

				Debug.previous_selected_item = next_select_item
				Debug.select_item = next_select_item
				Debug.next_select_at = t + 1
			end
		end
	end
end

Debug.cond_text = function (c, ...)
	-- function 5
	if c then
		Debug.text(...)
	end
end

Debug.text = function (...)
	-- function 6
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local text_table = FrameTable.alloc_table()

	text_table.text = string.format(...)

	table.insert(Debug.debug_texts, text_table)
end

Debug.colored_text = function (color, ...)
	-- function 7
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local text_table = FrameTable.alloc_table()

	text_table.text = string.format(...)
	text_table.color = ColorBox(color)

	table.insert(Debug.debug_texts, text_table)
end

local max_world_sticky = 512
local debug_colors = {
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

	local world_gui = Managers.state.debug_text._world_gui
	local wt = Debug.world_texts
	local num_texts = #wt
	local world = Application.main_world()

	if not ScriptWorld.has_viewport(world, "player_1") then
		return
	end

	local viewport = ScriptWorld.viewport(Application.main_world(), "player_1")
	local cam = ScriptViewport.camera(viewport)
	local cam_tm = Camera.local_pose(cam)
	local cam_pos = Matrix4x4.translation(cam_tm)

	for i = 1, num_texts do
		local item = wt[i]
		local text = item[1]
		local pos = Vector3(item[2], item[3], item[4])
		local rot = Quaternion.flat_no_roll(Quaternion.look(pos - cam_pos, Vector3.up()))
		local font_size = 0.3
		local _, _, extent_3 = Gui.text_extents(world_gui, text, font_mtrl, font_size)
		local width = extent_3[1]

		pos = pos - Quaternion.right(rot) * width * 0.5

		local tm = Matrix4x4.from_quaternion_position(rot, pos)

		Gui.text_3d(world_gui, text, font_mtrl, font_size, font, tm, Vector3.zero(), 1, Color(item[5], item[6], item[7]))

		wt[i] = nil
	end
end

Debug.update_world_sticky_texts = function ()
	-- function 9
	if not Managers.state.debug_text then
		return
	end

	local world_gui = Managers.state.debug_text._world_gui
	local wt = Debug.world_sticky_texts
	local num_texts = Debug.num_world_sticky_texts
	local world = Application.main_world()

	if not ScriptWorld.has_viewport(world, "player_1") then
		return
	end

	local viewport = ScriptWorld.viewport(Application.main_world(), "player_1")
	local cam = ScriptViewport.camera(viewport)
	local cam_tm = Camera.local_pose(cam)
	local cam_pos = Matrix4x4.translation(cam_tm)

	for i = 1, num_texts do
		local item = wt[i]
		local text = item[1]
		local pos = Vector3(item[2], item[3], item[4])
		local rot = Quaternion.flat_no_roll(Quaternion.look(pos - cam_pos, Vector3.up()))
		local font_size = 0.3
		local _, _, extent_3 = Gui.text_extents(world_gui, text, font_mtrl, font_size)
		local width = extent_3[1]

		pos = pos - Quaternion.right(rot) * width * 0.5

		local tm = Matrix4x4.from_quaternion_position(rot, pos)

		Gui.text_3d(world_gui, text, font_mtrl, font_size, font, tm, Vector3.zero(), 1, Color(item[5], item[6], item[7]))
	end
end

Debug.world_text = function (pos, text, color_name)
	-- function 10
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local wt = Debug.world_texts
	local var_10_0 = debug_colors[color_name]

	if not var_10_0 then
		-- Nothing
	end

	var_10_0 = debug_colors.white

	local color = var_10_0

	::label_10_0::

	local index = #wt + 1

	if wt[index] then
		wt[index][1] = text
		wt[index][2] = pos[1]
		wt[index][3] = pos[2]
		wt[index][4] = pos[3]
		wt[index][5] = color[1]
		wt[index][6] = color[2]
		wt[index][7] = color[3]
	else
		wt[index] = {
			text,
			pos[1],
			pos[2],
			pos[3],
			color[1],
			color[2],
			color[3]
		}
	end
end

Debug.world_sticky_text = function (pos, text, color_name)
	-- function 11
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local wt = Debug.world_sticky_texts
	local index = Debug.world_sticky_index

	index = index + 1

	if index > max_world_sticky then
		index = 1
	end

	Debug.num_world_sticky_texts = math.clamp(Debug.num_world_sticky_texts + 1, 0, max_world_sticky)

	local var_11_0 = debug_colors[color_name]

	if not var_11_0 then
		-- Nothing
	end

	var_11_0 = debug_colors.white

	local color = var_11_0

	::label_11_0::

	if wt[index] then
		wt[index][1] = text
		wt[index][2] = pos[1]
		wt[index][3] = pos[2]
		wt[index][4] = pos[3]
		wt[index][5] = color[1]
		wt[index][6] = color[2]
		wt[index][7] = color[3]
	else
		wt[index] = {
			text,
			pos[1],
			pos[2],
			pos[3],
			color[1],
			color[2],
			color[3]
		}
	end

	Debug.world_sticky_index = index
end

Debug.reset_sticky_world_texts = function ()
	-- function 12
	Debug.num_world_sticky_texts = 0
	Debug.world_sticky_index = 0
end

Debug.sticky_text = function (...)
	-- function 13
	if not Debug.active or script_data and script_data.disable_debug_draw then
		return
	end

	local t = {
		...
	}
	local delay = 3

	if t[#t - 1] == "delay" and not t[#t] then
		-- Nothing
	end

	table.insert(Debug.sticky_texts, {
		string.format(...),
		Managers.time:time("game") + delay
	})
end

Debug.drawer = function (name, disabled)
	-- function 14
	name = not not name or not not "default"

	local lo = Debug.line_objects[name]

	lo = not not lo or not not Debug.create_line_object(name)

	return DebugDrawer:new(lo, to_boolean(not disabled))
end

Debug.draw_text = function (text, text_pos, opt_font_size, opt_color)
	-- function 15
	local gui = Debug.gui
	local size = not not opt_font_size or not not font_size
	local pos = Vector3(text_pos.x, RESOLUTION_LOOKUP.res_h - text_pos.y - size, text_pos.z)

	Gui.text(gui, text, font_mtrl, not not opt_font_size or not not font_size, font, pos, not not opt_color or not not Color(120, 220, 0), "shadow")
end

Debug.draw_rect = function (pos, size, color)
	-- function 16
	local gui = Debug.gui
	local inverted_pos = Vector3(pos.x, RESOLUTION_LOOKUP.res_h - pos.y, pos.z)
	local inverted_size = Vector3(size.x, -size.y, size.z)

	Gui.rect(gui, inverted_pos, inverted_size, color)
end

Debug.teardown = function ()
	-- function 17
	Debug.active = false

	local w = Debug.world

	for lo_name, lo in pairs(Debug.line_objects) do
		World.destroy_line_object(w, lo)
	end

	table.clear(Debug.line_objects)
end

Debug.animation_log_specific_profile = function (profile, enable)
	-- function 18
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local units = player.owned_units

		for _, unit in pairs(units) do
			local has_status_extension = ScriptUnit.has_extension(unit, "status_system")

			if has_status_extension then
				local status_extension = ScriptUnit.extension(unit, "status_system")
				local profile_id = status_extension.profile_id
				local profile_data = SPProfiles[profile_id]
				local profile_display_name = profile_data.display_name

				if profile_display_name == profile then
					print("animation logging enabled for:" .. profile)
					Unit.set_animation_logging(unit, enable)
				end
			end
		end
	end
end

Debug.spawn_hero = function (hero_name)
	-- function 19
	local spawn_manager = Managers.state.spawn
	local hero_spawner_handler = spawn_manager.hero_spawner_handler
	local peer_id = Network.peer_id()
	local player = Managers.player:player_from_peer_id(peer_id)

	hero_spawner_handler:spawn_hero_request(player, hero_name)
end

Debug.load_level = function (level_name, environment_variation_id, debug_environment_level_flow_event)
	-- function 20
	Managers.mechanism:debug_load_level(level_name, environment_variation_id)

	if debug_environment_level_flow_event ~= nil then
		StateIngame._level_flow_events = {
			debug_environment_level_flow_event
		}
	else
		StateIngame._level_flow_events = nil
	end
end

Debug.level_loaded = function (level_name)
	-- function 21
	local state_managers = Managers.state

	if not state_managers then
		return false
	end

	local level_transition_handler = Managers.level_transition_handler
	local level_key = level_transition_handler:get_current_level_key()

	if level_key ~= level_name then
		return false
	end

	local packages_loaded = level_transition_handler:all_packages_loaded()

	if not packages_loaded then
		return false
	end

	local peer_id = Network.peer_id()
	local player = Managers.player:player_from_peer_id(peer_id)
	local player_unit = not not player and not not player.player_unit

	if not Unit.alive(player_unit) then
		return false
	end

	return true
end

Debug.visualize_level_unit = function (level_unit_id)
	-- function 22
	local level = Managers.state.networked_flow_state._level

	if not level then
		return
	end

	local unit = Level.unit_by_index(level, level_unit_id)

	if not unit then
		return
	end

	local position = Unit.world_position(unit, 0)

	QuickDrawer:sphere(position, 1, Colors.get("medium_aqua_marine"))

	for i = 1, 20 do
		QuickDrawer:sphere(position, i * 10, Colors.get("medium_aqua_marine"))
	end
end

Debug.aim_position = function ()
	-- function 23
	local player_manager = Managers.player
	local player = player_manager:local_player(1)
	local player_unit = player.player_unit
	local camera_position = Managers.state.camera:camera_position(player.viewport_name)
	local camera_rotation = Managers.state.camera:camera_rotation(player.viewport_name)
	local camera_direction = Quaternion.forward(camera_rotation)
	local filter = "filter_ray_projectile"
	local world = Managers.state.spawn.world
	local physics_world = World.get_data(world, "physics_world")
	local result = PhysicsWorld.immediate_raycast(physics_world, camera_position, camera_direction, 100, "all", "collision_filter", filter)

	if result then
		local num_hits = #result

		for i = 1, num_hits do
			local hit = result[i]
			local hit_actor = hit[4]
			local hit_unit = Actor.unit(hit_actor)
			local attack_hit_self = hit_unit == player_unit

			if not attack_hit_self then
				return hit[1], hit[2], hit[3], hit[4]
			end
		end
	end
end

Debug.test_spawn_unit = function (profile_name, career_index)
	-- function 24
	profile_name = not not profile_name or not not "wood_elf"
	career_index = not not career_index or not not 1

	local profile_index = FindProfileIndex(profile_name)
	local profile = SPProfiles[profile_index]
	local career = profile.careers[career_index]
	local career_name = career.name
	local skin_item = BackendUtils.get_loadout_item(career_name, "slot_skin")
	local item_data = not not skin_item and not not skin_item.data
	local name

	if item_data then
		name = item_data.name

		if not name then
			-- Nothing
		end
	end

	name = career.base_skin

	local skin_name = name

	::label_24_0::

	local package_names = {}
	local skin_data = Cosmetics[skin_name]
	local unit_name = skin_data.third_person
	local material_changes = skin_data.material_changes

	package_names[#package_names + 1] = unit_name

	if material_changes then
		local material_package = material_changes.package_name

		package_names[#package_names + 1] = material_package
	end

	for index, package_name in ipairs(package_names) do
		Managers.package:load(package_name, "debug", nil, false)
	end

	local world = Managers.state.spawn.world
	local position = Debug.aim_position()
	local unit_name = skin_data.third_person
	local tint_data = skin_data.color_tint
	local character_unit = World.spawn_unit(world, unit_name, position)
	local material_changes = skin_data.material_changes

	if material_changes then
		local third_person_changes = material_changes.third_person

		for slot_name, material_name in pairs(third_person_changes) do
			Unit.set_material(character_unit, slot_name, material_name)
			Unit.set_material(character_unit, slot_name, material_name)
		end
	end

	Debug.test_unit = character_unit
end

Debug.test_despawn_unit = function (profile_name, career_index)
	-- function 25
	local world = Managers.state.spawn.world
	local character_unit = Debug.test_unit

	if not character_unit then
		return
	end

	World.destroy_unit(world, character_unit)

	profile_name = not not profile_name or not not "wood_elf"
	career_index = not not career_index or not not 1

	local profile_index = FindProfileIndex(profile_name)
	local profile = SPProfiles[profile_index]
	local career = profile.careers[career_index]
	local career_name = career.name
	local skin_item = BackendUtils.get_loadout_item(career_name, "slot_skin")
	local item_data = not not skin_item and not not skin_item.data
	local name

	if item_data then
		name = item_data.name

		if not name then
			-- Nothing
		end
	end

	name = career.base_skin

	local skin_name = name

	::label_25_0::

	local package_names = {}
	local skin_data = Cosmetics[skin_name]
	local unit_name = skin_data.third_person
	local material_changes = skin_data.material_changes

	package_names[#package_names + 1] = unit_name

	if material_changes then
		local material_package = material_changes.package_name

		package_names[#package_names + 1] = material_package
	end

	for index, package_name in ipairs(package_names) do
		Managers.package:unload(package_name, "debug", nil, false)
	end
end

Debug.create_jira_issue = function ()
	-- function 26
	local valid, err = pcall(require, "core/plugins/reporter")

	if valid then
		Reporter.create_jira_issue("honduras")
	end
end

local Debug_2 = Debug
local _hook_data = Debug._hook_data

_hook_data = not not _hook_data or not not {}
Debug_2._hook_data = _hook_data

Debug.hook = function (obj, method, handler)
	-- function 27
	local data_for_obj = Debug._hook_data[obj]

	if not data_for_obj then
		data_for_obj = {}
		Debug._hook_data[obj] = data_for_obj
	end

	local orig = data_for_obj[method]

	if not orig then
		orig = rawget(obj, method)
		data_for_obj[method] = orig

		assert(orig)
	end

	rawset(obj, method, function (...)
		-- function 28
		return handler(orig, ...)
	end)
end

Debug.unhook = function (obj, method, silent)
	-- function 29
	local data_for_obj = Debug._hook_data[obj]

	if not data_for_obj then
		return assert(silent)
	end

	local orig = data_for_obj[method]

	if not orig then
		return assert(silent)
	end

	rawset(obj, method, orig)

	return true
end
