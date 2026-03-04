-- chunkname: @scripts/ui/hud_ui/pet_ui.lua

require("scripts/unit_extensions/ai_commander/ai_commander_extension")

local var_0_0 = local_require("scripts/ui/hud_ui/pet_ui_definitions")
local var_0_1 = var_0_0.SKULL_TEXTURES
local var_0_2 = var_0_0.SKULL_GLOW_TEXTURES
local var_0_3 = var_0_0.RETAINED_MODE_ENABLED

PetUI = class(PetUI)

PetUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._global_pet_counter = 0
	arg_1_0._last_amount_pets = 0
	arg_1_0._last_resolution = {}

	arg_1_0:_create_ui_elements()
end

PetUI.destroy = function (arg_2_0, arg_2_1, arg_2_2)
	for iter_2_0, iter_2_1 in pairs(arg_2_0._pet_widget_by_unit) do
		local var_2_0 = iter_2_1.content.marker_id

		if var_2_0 then
			Managers.state.event:trigger("remove_world_marker", var_2_0)
		end
	end

	if var_0_3 then
		arg_2_0:_destroy_all_widgets()
	end
end

PetUI._destroy_all_widgets = function (arg_3_0)
	for iter_3_0, iter_3_1 in pairs(arg_3_0._pet_widget_list) do
		UIWidget.destroy(arg_3_0._ui_renderer, iter_3_1)
	end

	UIWidget.destroy(arg_3_0._ui_renderer, arg_3_0._container_widget)
end

PetUI._create_ui_elements = function (arg_4_0)
	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)

	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_0.animation_definitions)
	arg_4_0._pet_widget_by_unit = {}
	arg_4_0._pet_widget_list = {}
	arg_4_0._pet_widget_animation_ids = {}
	arg_4_0._pet_attack_status = {}
	arg_4_0._container_widget = UIWidget.init(var_0_0.container_widget_definition)

	local var_4_0 = arg_4_0._ui_renderer.gui
	local var_4_1 = arg_4_0._ui_renderer.gui_retained

	arg_4_0._container_widget.content.materials = {
		Gui.material(var_4_0, "necromancer_command_coin_follow"),
		Gui.material(var_4_0, "necromancer_command_coin_attack"),
		Gui.material(var_4_0, "necromancer_command_coin_defend"),
		Gui.material(var_4_0, "necromancer_command_coin")
	}
	arg_4_0._container_widget.content.retained_materials = {
		Gui.material(var_4_1, "necromancer_command_coin_follow"),
		Gui.material(var_4_1, "necromancer_command_coin_attack"),
		Gui.material(var_4_1, "necromancer_command_coin_defend"),
		Gui.material(var_4_1, "necromancer_command_coin")
	}
	arg_4_0._dirty = true
end

PetUI.set_visible = function (arg_5_0, arg_5_1)
	arg_5_0._is_visible = arg_5_1

	arg_5_0:_set_elements_visible(arg_5_1)
end

PetUI._set_elements_visible = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._ui_renderer

	UIRenderer.set_element_visible(var_6_0, arg_6_0._container_widget.element, arg_6_1)

	for iter_6_0, iter_6_1 in ipairs(arg_6_0._pet_widget_list) do
		UIRenderer.set_element_visible(var_6_0, iter_6_1.element)
	end

	arg_6_0._retained_elements_visible = arg_6_1

	arg_6_0:_set_all_dirty()
end

PetUI._set_widget_dirty = function (arg_7_0, arg_7_1)
	arg_7_1.element.dirty = true
	arg_7_0._dirty = true
end

PetUI._set_all_dirty = function (arg_8_0)
	UIUtils.mark_dirty(arg_8_0._pet_widget_list)
	arg_8_0:_set_widget_dirty(arg_8_0._container_widget)
end

PetUI._create_pet_widget = function (arg_9_0, arg_9_1)
	local var_9_0 = #arg_9_0._pet_widget_list + 1
	local var_9_1 = UIWidget.init(var_0_0.pet_widget_definition)
	local var_9_2 = var_9_1.content
	local var_9_3 = math.random(var_9_0, #var_0_1)

	var_0_1[var_9_3], var_0_1[var_9_0] = var_0_1[var_9_0], var_0_1[var_9_3]
	var_0_2[var_9_3], var_0_2[var_9_0] = var_0_2[var_9_0], var_0_2[var_9_3]
	var_9_1.content.icon = var_0_1[var_9_0] or var_0_1[1]
	var_9_1.content.icon_glow = var_0_2[var_9_0] or var_0_2[1]
	arg_9_0._pet_widget_by_unit[arg_9_1] = var_9_1
	var_9_2.unit = arg_9_1
	arg_9_0._global_pet_counter = arg_9_0._global_pet_counter + 1
	var_9_2.order_index = arg_9_0._global_pet_counter
	arg_9_0._pet_widget_list[var_9_0] = var_9_1

	local var_9_4 = arg_9_0._ui_animator:start_animation("spawn_skeleton", var_9_1, var_0_0.scenegraph_definition)

	arg_9_0._pet_widget_animation_ids[var_9_1] = var_9_4

	return var_9_1
end

local function var_0_4(arg_10_0, arg_10_1)
	local var_10_0 = Managers.input:get_service(arg_10_0)
	local var_10_1 = var_10_0 and var_10_0:get_keymapping(arg_10_1)
	local var_10_2 = var_10_1 and var_10_1[1]
	local var_10_3 = var_10_1 and var_10_1[2]
	local var_10_4

	if var_10_3 ~= UNASSIGNED_KEY then
		if var_10_2 == "keyboard" then
			var_10_4 = Keyboard.button_name(var_10_3)
		elseif var_10_2 == "mouse" then
			var_10_4 = Mouse.button_name(var_10_3)
		elseif var_10_2 == "gamepad" then
			var_10_4 = Pad1.button_name(var_10_3)
		end
	end

	return var_10_4 or "???"
end

PetUI._pet_ui_available = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._ui_available
	local var_11_1 = arg_11_1 and arg_11_1:career_name()

	if not CareerSettings[var_11_1].show_pet_ui then
		if var_0_3 and var_11_0 then
			arg_11_0:destroy()
		end

		table.clear(arg_11_0._pet_widget_by_unit)
		table.clear(arg_11_0._pet_widget_list)

		arg_11_0._ui_available = false
	else
		if var_0_3 and not var_11_0 then
			arg_11_0:_set_all_dirty()
		end

		arg_11_0._ui_available = true
	end

	return arg_11_0._ui_available
end

local var_0_5 = {}

PetUI._update_animations = function (arg_12_0, arg_12_1)
	table.clear(var_0_5)

	local var_12_0 = arg_12_0._ui_animator

	var_12_0:update(arg_12_1)

	local var_12_1 = arg_12_0._change_command_state_anim

	if var_12_1 then
		if not var_12_0:is_animation_completed(var_12_1) then
			arg_12_0:_set_widget_dirty(arg_12_0._container_widget)
		else
			arg_12_0._change_command_state_anim = nil
		end
	end

	for iter_12_0, iter_12_1 in pairs(arg_12_0._pet_widget_animation_ids) do
		if not var_12_0:is_animation_completed(iter_12_1) then
			arg_12_0:_set_widget_dirty(iter_12_0)
		else
			var_0_5[#var_0_5 + 1] = iter_12_0
		end
	end

	for iter_12_2 = 1, #var_0_5 do
		local var_12_2 = var_0_5[iter_12_2]

		arg_12_0._pet_widget_animation_ids[var_12_2] = nil
	end
end

local function var_0_6(arg_13_0, arg_13_1)
	return arg_13_0.content.order_index < arg_13_1.content.order_index
end

PetUI._update_pet_container = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_3.player_unit
	local var_14_1 = ScriptUnit.has_extension(var_14_0, "ai_commander_system")
	local var_14_2 = var_14_1:get_controlled_units()
	local var_14_3 = next(var_14_2)
	local var_14_4 = var_14_3 and var_14_1:command_state(var_14_3) or CommandStates.Following
	local var_14_5 = arg_14_0._container_widget

	if var_14_4 ~= arg_14_0._last_command_state and arg_14_0._ui_animator:is_animation_completed(arg_14_0._change_command_state_anim) then
		arg_14_0._change_command_state_anim = arg_14_0._ui_animator:start_animation("change_command_state", var_14_5, var_0_0.scenegraph_definition, var_14_4)
		arg_14_0._last_command_state = var_14_4
	end

	if not var_14_5.content.initialized then
		var_14_5.content.initialized = true
		var_14_5.content.help_text = string.format("{#color(255,168,0)}[%s]{#reset()} to attack", Utf8.upper(var_0_4("Player", "action_one"))) .. string.format("\n{#color(255,168,0)}[%s]{#reset()} to hold a position", Utf8.upper(var_0_4("Player", "action_two_hold"))) .. string.format("\n{#color(255,168,0)}[%s]{#reset()} to dark pact", Utf8.upper(var_0_4("Player", "weapon_reload")))
	end

	local var_14_6 = ScriptUnit.has_extension(var_14_0, "buff_system")
	local var_14_7 = var_14_5.content.show_glow

	var_14_5.content.show_glow = not not var_14_6:get_buff_type("sienna_necromancer_6_3_available_charge")

	if var_14_7 ~= var_14_5.content.show_glow then
		arg_14_0:_set_widget_dirty(var_14_5)
	end

	local var_14_8 = arg_14_0._pet_widget_by_unit
	local var_14_9 = arg_14_0._pet_widget_list
	local var_14_10 = arg_14_0._pet_attack_status
	local var_14_11 = ScriptUnit.has_extension(var_14_0, "inventory_system")
	local var_14_12 = var_14_11 and var_14_11:get_wielded_slot_item_template()
	local var_14_13 = not not var_14_12 and not not var_14_12.is_command_utility_weapon
	local var_14_14 = false

	for iter_14_0 in pairs(var_14_2) do
		if var_14_1:pet_ui_data(iter_14_0) and HEALTH_ALIVE[iter_14_0] then
			if not var_14_8[iter_14_0] then
				local var_14_15 = arg_14_0:_create_pet_widget(iter_14_0)

				var_14_14 = true

				arg_14_0:add_pet_nameplate(iter_14_0, var_14_15)
			end

			local var_14_16 = ScriptUnit.has_extension(iter_14_0, "buff_system")
			local var_14_17 = var_14_16 and var_14_16:has_buff_type("skeleton_command_attack_boost")
			local var_14_18 = var_14_8[iter_14_0]

			if var_14_17 and not var_14_10[iter_14_0] then
				local var_14_19 = arg_14_0._ui_animator:start_animation("fade_in_skull_glow", var_14_18, var_0_0.scenegraph_definition)

				arg_14_0._pet_widget_animation_ids[var_14_18] = var_14_19
			elseif not var_14_17 and var_14_10[iter_14_0] then
				local var_14_20 = arg_14_0._ui_animator:start_animation("fade_out_skull_glow", var_14_18, var_0_0.scenegraph_definition)

				arg_14_0._pet_widget_animation_ids[var_14_18] = var_14_20
			end

			var_14_10[iter_14_0] = var_14_17
		end
	end

	if Application.user_setting("numeric_ui") then
		local var_14_21 = var_14_1:get_controlled_units_count()

		if (arg_14_0._last_amount_pets or 0) ~= var_14_21 then
			var_14_5.content.pet_amount_text = var_14_21
			var_14_5.content.pet_amount_text_shadow = var_14_21
			arg_14_0._last_amount_pets = var_14_21

			arg_14_0:_set_widget_dirty(var_14_5)
		end
	end

	local var_14_22, var_14_23 = var_14_1:hovered_friendly_unit()
	local var_14_24 = var_14_22 or var_14_23

	for iter_14_1 = #var_14_9, 1, -1 do
		local var_14_25 = var_14_9[iter_14_1]
		local var_14_26 = var_14_25.content.unit

		if not (var_14_1 and arg_14_0:_update_pet_widget(var_14_25, var_14_1, var_14_13, var_14_24)) then
			var_14_8[var_14_26] = nil

			local var_14_27 = var_14_25.content.marker_id

			if var_14_27 then
				Managers.state.event:trigger("remove_world_marker", var_14_27)

				var_14_25.content.marker_id = false
				var_14_25.content.marker_widget = nil
			end

			if var_0_3 then
				UIWidget.destroy(arg_14_0._ui_renderer, var_14_25)
			end

			table.remove(var_14_9, iter_14_1)

			var_14_14 = true
		end
	end

	if var_14_14 then
		table.sort(arg_14_0._pet_widget_list, var_0_6)

		local var_14_28 = #arg_14_0._pet_widget_list

		for iter_14_2, iter_14_3 in pairs(arg_14_0._pet_widget_list) do
			var_0_0.reposition_widget(iter_14_3, iter_14_2, var_14_28)
			arg_14_0:_set_widget_dirty(iter_14_3)
		end
	end
end

PetUI.add_pet_nameplate = function (arg_15_0, arg_15_1, arg_15_2)
	if arg_15_0._show_nameplates then
		Managers.state.event:trigger("add_world_marker_unit", "pet_nameplate", arg_15_1, function (arg_16_0, arg_16_1)
			if arg_15_2.content.marker_id ~= false then
				arg_15_2.content.marker_id = arg_16_0
				arg_15_2.content.marker_widget = arg_16_1
				arg_16_1.content.text = "Skeleton"
			end
		end)
	end
end

PetUI.update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if not arg_17_0._is_visible then
		return
	end

	if not arg_17_0:_pet_ui_available(arg_17_3) then
		return
	end

	arg_17_0:_update_animations(arg_17_1, arg_17_2, arg_17_3)
	arg_17_0:_update_pet_container(arg_17_1, arg_17_2, arg_17_3)
	arg_17_0:_handle_resolution_modified()
	arg_17_0:_handle_gamepad_activity()
	arg_17_0:_draw(arg_17_1, arg_17_2)
end

PetUI._handle_gamepad_activity = function (arg_18_0)
	local var_18_0 = Managers.input:is_device_active("gamepad")
	local var_18_1 = arg_18_0._gamepad_active_last_frame == nil

	if var_18_0 then
		if not arg_18_0._gamepad_active_last_frame or var_18_1 then
			arg_18_0._gamepad_active_last_frame = true
			arg_18_0._ui_scenegraph.container.local_position[1] = 435
			arg_18_0._ui_scenegraph.container.local_position[2] = 10

			arg_18_0:_set_all_dirty()
		end
	elseif arg_18_0._gamepad_active_last_frame or var_18_1 then
		arg_18_0._gamepad_active_last_frame = false
		arg_18_0._ui_scenegraph.container.local_position[1] = 460
		arg_18_0._ui_scenegraph.container.local_position[2] = 0

		arg_18_0:_set_all_dirty()
	end
end

PetUI._handle_resolution_modified = function (arg_19_0)
	local var_19_0 = RESOLUTION_LOOKUP.res_w
	local var_19_1 = RESOLUTION_LOOKUP.res_h

	if arg_19_0._last_resolution.res_w ~= var_19_0 or arg_19_0._last_resolution.res_h ~= var_19_1 then
		arg_19_0:_set_all_dirty()

		arg_19_0._last_resolution.res_w = var_19_0
		arg_19_0._last_resolution.res_h = var_19_1
	end
end

PetUI.resolution_modified = function (arg_20_0)
	arg_20_0:_set_all_dirty()
end

PetUI._draw = function (arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0._dirty and var_0_3 then
		return
	end

	local var_21_0 = arg_21_0._ui_renderer

	UIRenderer.begin_pass(var_21_0, arg_21_0._ui_scenegraph, FAKE_INPUT_SERVICE, arg_21_1, nil, arg_21_0._render_settings)
	UIRenderer.draw_widget(var_21_0, arg_21_0._container_widget)
	UIRenderer.draw_all_widgets(var_21_0, arg_21_0._pet_widget_list)
	UIRenderer.end_pass(var_21_0)

	arg_21_0._dirty = false
end

PetUI._update_pet_widget = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = arg_22_1.content
	local var_22_1 = var_22_0.unit
	local var_22_2, var_22_3, var_22_4 = arg_22_2:pet_ui_data(var_22_1)

	if not var_22_2 then
		return false
	end

	local var_22_5 = var_22_0.marker_widget

	if var_22_5 then
		var_22_5.content.visible = arg_22_3

		if var_22_2.pet_ui_type == "health" then
			var_22_5.content.progress = var_22_3 / var_22_4
		end
	end

	local var_22_6 = var_22_0.is_highlighted

	var_22_0.is_highlighted = arg_22_3 and var_22_1 == arg_22_4

	if var_22_6 ~= var_22_0.is_highlighted then
		arg_22_0:_set_widget_dirty(arg_22_1)
	end

	return true
end
