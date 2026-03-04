-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_loadout_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.generic_input_actions
local var_0_5 = false

HeroWindowLoadoutConsole = class(HeroWindowLoadoutConsole)
HeroWindowLoadoutConsole.NAME = "HeroWindowLoadoutConsole"

function HeroWindowLoadoutConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowLoadoutConsole")

	arg_1_0.params = arg_1_1
	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}
	arg_1_0._equipment_items = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_show_weapon_disclaimer(false)

	if Managers.mechanism:mechanism_setting("should_display_weapon_disclaimer") then
		arg_1_0:_show_weapon_disclaimer(true)
	end

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index

	arg_1_0:_start_transition_animation("on_enter")
end

function HeroWindowLoadoutConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_2, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function HeroWindowLoadoutConsole.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	local var_3_3 = Managers.mechanism:current_mechanism_name()
	local var_3_4 = InventorySettings.equipment_slots_by_mechanism[var_3_3] or InventorySettings.equipment_slots_by_mechanism.default
	local var_3_5 = var_0_0.create_loadout_grid_func(#var_3_4, arg_3_0.ui_scenegraph)
	local var_3_6 = UIWidget.init(var_3_5)

	arg_3_0._widgets[#arg_3_0._widgets + 1] = var_3_6
	arg_3_0._widgets_by_name.loadout_grid = var_3_6

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_3)

	if arg_3_2 then
		local var_3_7 = arg_3_0.ui_scenegraph.window.local_position

		var_3_7[1] = var_3_7[1] + arg_3_2[1]
		var_3_7[2] = var_3_7[2] + arg_3_2[2]
		var_3_7[3] = var_3_7[3] + arg_3_2[3]
	end

	local var_3_8 = Managers.input:get_service("hero_view")
	local var_3_9 = UILayer.default + 300
	local var_3_10 = 1500

	arg_3_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_3_0.ui_top_renderer, var_3_8, 7, var_3_9, var_0_4.default, true, var_3_10)

	arg_3_0._menu_input_description:set_input_description(nil)

	var_3_1.loadout_grid.content.profile_index = arg_3_0.params.profile_index
	var_3_1.loadout_grid.content.career_index = arg_3_0.params.career_index
end

function HeroWindowLoadoutConsole.on_exit(arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate HeroWindowLoadoutConsole")

	arg_4_0.ui_animator = nil

	arg_4_0._menu_input_description:destroy()

	arg_4_0._menu_input_description = nil
end

function HeroWindowLoadoutConsole._input_service(arg_5_0)
	local var_5_0 = arg_5_0.parent

	if var_5_0:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return var_5_0:window_input_service()
end

function HeroWindowLoadoutConsole.update(arg_6_0, arg_6_1, arg_6_2)
	if var_0_5 then
		var_0_5 = false

		arg_6_0:create_ui_elements()
	end

	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_update_loadout_sync()
	arg_6_0:_update_selected_loadout_slot_index()
	arg_6_0:_update_input_description()
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_handle_gamepad_input(arg_6_1, arg_6_2)
	arg_6_0:draw(arg_6_1)
end

function HeroWindowLoadoutConsole.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function HeroWindowLoadoutConsole._update_input_description(arg_8_0)
	local var_8_0 = arg_8_0.params
	local var_8_1 = arg_8_0.params.hero_statistics_active
	local var_8_2 = "default"

	if var_8_1 then
		var_8_2 = "details"
	elseif not arg_8_0:_is_selected_item_customizable() then
		var_8_2 = "default_no_customization"
	end

	if arg_8_0._current_input_desc ~= var_8_2 then
		arg_8_0._menu_input_description:change_generic_actions(var_0_4[var_8_2])

		arg_8_0._current_input_desc = var_8_2
	end
end

function HeroWindowLoadoutConsole._update_animations(arg_9_0, arg_9_1)
	arg_9_0.ui_animator:update(arg_9_1)

	local var_9_0 = arg_9_0._animations
	local var_9_1 = arg_9_0.ui_animator

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if var_9_1:is_animation_completed(iter_9_1) then
			var_9_1:stop_animation(iter_9_1)

			var_9_0[iter_9_0] = nil
		end
	end

	local var_9_2 = arg_9_0._widgets_by_name
end

function HeroWindowLoadoutConsole._is_button_pressed(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.on_release then
		var_10_0.on_release = false

		return true
	end
end

function HeroWindowLoadoutConsole._handle_gamepad_input(arg_11_0, arg_11_1, arg_11_2)
	if Managers.input:is_device_active("mouse") then
		return
	end

	local var_11_0 = arg_11_0.parent
	local var_11_1 = arg_11_0:_input_service()
	local var_11_2 = arg_11_0._widgets_by_name.loadout_grid.content
	local var_11_3 = var_11_2.rows
	local var_11_4 = var_11_2.columns
	local var_11_5
	local var_11_6

	for iter_11_0 = 1, var_11_3 do
		for iter_11_1 = 1, var_11_4 do
			local var_11_7 = "_" .. tostring(iter_11_0) .. "_" .. tostring(iter_11_1)

			if var_11_2["hotspot" .. var_11_7].is_selected then
				var_11_5 = iter_11_0
				var_11_6 = iter_11_1

				break
			end
		end
	end

	if var_11_5 and var_11_6 then
		if var_11_5 > 1 and var_11_1:get("move_up_hold_continuous") then
			var_11_0:set_selected_loadout_slot_index(var_11_5 - 1)
			arg_11_0:_play_sound("play_gui_equipment_inventory_hover")
		elseif var_11_5 < var_11_3 and var_11_1:get("move_down_hold_continuous") then
			var_11_0:set_selected_loadout_slot_index(var_11_5 + 1)
			arg_11_0:_play_sound("play_gui_equipment_inventory_hover")
		end
	end

	if var_11_1:get("confirm", true) then
		arg_11_0:_play_sound("play_gui_equipment_selection_click")
		var_11_0:set_layout_by_name("equipment_selection")
	elseif var_11_1:get("refresh_press", true) and arg_11_0:_is_selected_item_customizable() then
		arg_11_0:_play_sound("play_gui_equipment_selection_click")

		local var_11_8 = arg_11_0:_get_selected_item()

		if var_11_8 then
			arg_11_0:_customize_item(var_11_8)
		end
	end
end

function HeroWindowLoadoutConsole._handle_input(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.parent
	local var_12_1 = arg_12_0:_is_equipment_slot_hovered()

	if var_12_1 then
		var_12_0:set_selected_loadout_slot_index(var_12_1)
		arg_12_0:_play_sound("play_gui_equipment_selection_hover")
	end

	if arg_12_0:_is_equipment_slot_pressed() then
		arg_12_0:_play_sound("play_gui_equipment_selection_click")
		var_12_0:set_layout_by_name("equipment_selection")
	end

	local var_12_2 = arg_12_0:_is_customize_item_pressed()

	if var_12_2 then
		arg_12_0:_play_sound("play_gui_equipment_selection_click")
		arg_12_0:_customize_item(var_12_2)
	end
end

function HeroWindowLoadoutConsole._customize_item(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1.data.slot_type

	arg_13_0.params.item_to_customize = arg_13_1

	arg_13_0.parent:set_layout_by_name("item_customization")
end

function HeroWindowLoadoutConsole._update_selected_loadout_slot_index(arg_14_0)
	local var_14_0 = arg_14_0.parent:get_selected_loadout_slot_index()

	if var_14_0 ~= arg_14_0._selected_loadout_slot_index then
		arg_14_0:_set_equipment_slot_selected(var_14_0)

		arg_14_0._selected_loadout_slot_index = var_14_0
	end
end

function HeroWindowLoadoutConsole._update_loadout_sync(arg_15_0)
	local var_15_0 = arg_15_0.parent.loadout_sync_id

	if var_15_0 ~= arg_15_0._loadout_sync_id then
		arg_15_0:_populate_loadout()

		arg_15_0._loadout_sync_id = var_15_0
	end
end

function HeroWindowLoadoutConsole._exit(arg_16_0, arg_16_1)
	arg_16_0.exit = true
	arg_16_0.exit_level_id = arg_16_1
end

function HeroWindowLoadoutConsole.draw(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.ui_renderer
	local var_17_1 = arg_17_0.ui_top_renderer
	local var_17_2 = arg_17_0.ui_scenegraph
	local var_17_3 = arg_17_0:_input_service()
	local var_17_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_17_1, var_17_2, var_17_3, arg_17_1, nil, arg_17_0.render_settings)

	for iter_17_0, iter_17_1 in ipairs(arg_17_0._widgets) do
		UIRenderer.draw_widget(var_17_1, iter_17_1)
	end

	local var_17_5 = arg_17_0._active_node_widgets

	if var_17_5 then
		for iter_17_2, iter_17_3 in ipairs(var_17_5) do
			UIRenderer.draw_widget(var_17_1, iter_17_3)
		end
	end

	UIRenderer.end_pass(var_17_1)

	if var_17_4 and arg_17_0._menu_input_description and not arg_17_0.parent:input_blocked() then
		arg_17_0._menu_input_description:draw(var_17_1, arg_17_1)
	end
end

function HeroWindowLoadoutConsole._play_sound(arg_18_0, arg_18_1)
	arg_18_0.parent:play_sound(arg_18_1)
end

function HeroWindowLoadoutConsole._setup_slot_icons(arg_19_0)
	local var_19_0 = InventorySettings.slots_by_slot_index

	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		local var_19_1 = iter_19_1.ui_slot_index

		if var_19_1 then
			local var_19_2 = arg_19_0._widgets_by_name.loadout_grid.content
			local var_19_3 = "_1_" .. tostring(var_19_1)
			local var_19_4 = "item_icon" .. var_19_3
			local var_19_5 = "hotspot" .. var_19_3
			local var_19_6 = "item_tooltip" .. var_19_3
			local var_19_7 = "slot_icon" .. var_19_3
			local var_19_8 = iter_19_1.type

			var_19_2[var_19_7] = slot_icon_by_type[var_19_8] or "tabs_icon_all_selected"
		end
	end
end

function HeroWindowLoadoutConsole._populate_loadout(arg_20_0)
	local var_20_0 = arg_20_0.hero_name
	local var_20_1 = InventorySettings.slots_by_slot_index
	local var_20_2 = arg_20_0.career_index
	local var_20_3 = FindProfileIndex(var_20_0)
	local var_20_4 = SPProfiles[var_20_3].careers[var_20_2].name

	for iter_20_0, iter_20_1 in pairs(var_20_1) do
		local var_20_5 = iter_20_1.name

		arg_20_0:_clear_item_slot(iter_20_1)

		local var_20_6 = BackendUtils.get_loadout_item(var_20_4, var_20_5)

		if var_20_6 then
			arg_20_0:_equip_item_presentation(var_20_6, iter_20_1)
		end
	end
end

function HeroWindowLoadoutConsole._equip_item_presentation(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_1.data.slot_type
	local var_21_1 = arg_21_2.slot_index
	local var_21_2 = arg_21_2.ui_slot_index
	local var_21_3 = arg_21_0._widgets_by_name

	if var_21_2 then
		arg_21_0._equipment_items[var_21_1] = arg_21_1

		local var_21_4 = var_21_3.loadout_grid
		local var_21_5 = var_21_4.content
		local var_21_6 = var_21_4.style
		local var_21_7 = "_" .. tostring(var_21_1) .. "_1"
		local var_21_8 = "item_icon" .. var_21_7
		local var_21_9 = "hotspot" .. var_21_7
		local var_21_10 = "item_tooltip" .. var_21_7
		local var_21_11, var_21_12, var_21_13 = UIUtils.get_ui_information_from_item(arg_21_1)

		var_21_5[var_21_10] = var_21_12
		var_21_5["item" .. var_21_7] = arg_21_1

		local var_21_14 = arg_21_1.backend_id
		local var_21_15 = arg_21_1.rarity
		local var_21_16 = Managers.backend:get_interface("items")

		if var_21_15 then
			var_21_5["rarity_texture" .. var_21_7] = UISettings.item_rarity_textures[var_21_15]
		end

		local var_21_17 = var_21_5[var_21_9]

		if var_21_17 then
			var_21_17[var_21_8] = var_21_11
		end
	end
end

function HeroWindowLoadoutConsole._clear_item_slot(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_1.type
	local var_22_1 = arg_22_1.slot_index
	local var_22_2 = arg_22_1.ui_slot_index
	local var_22_3 = arg_22_0._widgets_by_name

	if var_22_2 then
		arg_22_0._equipment_items[var_22_1] = nil

		local var_22_4 = var_22_3.loadout_grid
		local var_22_5 = var_22_4.content
		local var_22_6 = var_22_4.style
		local var_22_7 = "_" .. tostring(var_22_1) .. "_1"
		local var_22_8 = "item_icon" .. var_22_7
		local var_22_9 = "hotspot" .. var_22_7

		var_22_5["item_tooltip" .. var_22_7] = nil
		var_22_5["item" .. var_22_7] = nil

		local var_22_10 = var_22_5[var_22_9]

		if var_22_10 then
			var_22_10[var_22_8] = nil
		end
	end
end

function HeroWindowLoadoutConsole._is_equipment_slot_right_clicked(arg_23_0)
	local var_23_0 = arg_23_0._widgets_by_name.loadout_grid.content
	local var_23_1 = var_23_0.rows
	local var_23_2 = var_23_0.columns

	for iter_23_0 = 1, var_23_1 do
		for iter_23_1 = 1, var_23_2 do
			local var_23_3 = "_" .. tostring(iter_23_0) .. "_" .. tostring(iter_23_1)

			if var_23_0["hotspot" .. var_23_3].on_right_click then
				return iter_23_0
			end
		end
	end
end

function HeroWindowLoadoutConsole._is_customize_item_pressed(arg_24_0)
	local var_24_0 = arg_24_0._widgets_by_name.loadout_grid.content
	local var_24_1 = var_24_0.rows
	local var_24_2 = var_24_0.columns

	for iter_24_0 = 1, var_24_1 do
		for iter_24_1 = 1, var_24_2 do
			local var_24_3 = "_" .. tostring(iter_24_0) .. "_" .. tostring(iter_24_1)

			if var_24_0["customize_hotspot" .. var_24_3].on_pressed then
				return var_24_0["item" .. var_24_3]
			end
		end
	end
end

function HeroWindowLoadoutConsole._is_selected_item_customizable(arg_25_0)
	local var_25_0 = arg_25_0._widgets_by_name.loadout_grid.content
	local var_25_1 = var_25_0.rows
	local var_25_2 = var_25_0.columns

	for iter_25_0 = 1, var_25_1 do
		for iter_25_1 = 1, var_25_2 do
			local var_25_3 = "_" .. tostring(iter_25_0) .. "_" .. tostring(iter_25_1)

			if var_25_0["hotspot" .. var_25_3].is_selected then
				return not var_25_0["item" .. var_25_3 .. "_disabled"]
			end
		end
	end
end

function HeroWindowLoadoutConsole._get_selected_item(arg_26_0)
	local var_26_0 = arg_26_0._widgets_by_name.loadout_grid.content
	local var_26_1 = var_26_0.rows
	local var_26_2 = var_26_0.columns

	for iter_26_0 = 1, var_26_1 do
		for iter_26_1 = 1, var_26_2 do
			local var_26_3 = "_" .. tostring(iter_26_0) .. "_" .. tostring(iter_26_1)

			if var_26_0["hotspot" .. var_26_3].is_selected then
				return var_26_0["item" .. var_26_3]
			end
		end
	end
end

function HeroWindowLoadoutConsole._is_equipment_slot_pressed(arg_27_0)
	local var_27_0 = arg_27_0._widgets_by_name.loadout_grid.content
	local var_27_1 = var_27_0.rows
	local var_27_2 = var_27_0.columns

	for iter_27_0 = 1, var_27_1 do
		for iter_27_1 = 1, var_27_2 do
			local var_27_3 = "_" .. tostring(iter_27_0) .. "_" .. tostring(iter_27_1)

			if var_27_0["hotspot" .. var_27_3].on_pressed then
				return iter_27_0
			end
		end
	end
end

function HeroWindowLoadoutConsole._is_equipment_slot_hovered(arg_28_0)
	local var_28_0 = arg_28_0._widgets_by_name.loadout_grid.content
	local var_28_1 = var_28_0.rows
	local var_28_2 = var_28_0.columns

	for iter_28_0 = 1, var_28_1 do
		for iter_28_1 = 1, var_28_2 do
			local var_28_3 = "_" .. tostring(iter_28_0) .. "_" .. tostring(iter_28_1)

			if var_28_0["hotspot" .. var_28_3].on_hover_enter then
				return iter_28_0
			end
		end
	end
end

function HeroWindowLoadoutConsole._set_equipment_slot_selected(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._widgets_by_name.loadout_grid.content
	local var_29_1 = var_29_0.rows
	local var_29_2 = var_29_0.columns

	for iter_29_0 = 1, var_29_1 do
		for iter_29_1 = 1, var_29_2 do
			local var_29_3 = "_" .. tostring(iter_29_0) .. "_" .. tostring(iter_29_1)
			local var_29_4 = var_29_0["hotspot" .. var_29_3]

			var_29_4.is_selected = arg_29_1 and arg_29_1 == iter_29_0
			var_29_4.highlight = var_29_4.is_selected
		end
	end
end

function HeroWindowLoadoutConsole._enable_selection_highlight(arg_30_0)
	local var_30_0 = arg_30_0._widgets_by_name.loadout_grid.content
	local var_30_1 = var_30_0.rows
	local var_30_2 = var_30_0.columns

	for iter_30_0 = 1, var_30_1 do
		for iter_30_1 = 1, var_30_2 do
			local var_30_3 = "_" .. tostring(iter_30_0) .. "_" .. tostring(iter_30_1)
			local var_30_4 = var_30_0["hotspot" .. var_30_3]

			var_30_4.highlight = var_30_4.is_selected
		end
	end
end

function HeroWindowLoadoutConsole._disable_selection_highlight(arg_31_0)
	local var_31_0 = arg_31_0._widgets_by_name.loadout_grid.content
	local var_31_1 = var_31_0.rows
	local var_31_2 = var_31_0.columns

	for iter_31_0 = 1, var_31_1 do
		for iter_31_1 = 1, var_31_2 do
			local var_31_3 = "_" .. tostring(iter_31_0) .. "_" .. tostring(iter_31_1)

			var_31_0["hotspot" .. var_31_3].highlight = false
		end
	end
end

function HeroWindowLoadoutConsole._is_equipment_slot_hovered_by_type(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._widgets_by_name.loadout_grid.content
	local var_32_1 = var_32_0.rows
	local var_32_2 = var_32_0.columns
	local var_32_3 = InventorySettings.slots_by_ui_slot_index

	for iter_32_0 = 1, var_32_1 do
		for iter_32_1 = 1, var_32_2 do
			if var_32_3[iter_32_1].type == arg_32_1 then
				local var_32_4 = "_" .. tostring(iter_32_0) .. "_" .. tostring(iter_32_1)

				if var_32_0["hotspot" .. var_32_4].internal_is_hover then
					return iter_32_1
				end
			end
		end
	end
end

function HeroWindowLoadoutConsole._highlight_equipment_slot_by_type(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0._widgets_by_name.loadout_grid
	local var_33_1 = var_33_0.content
	local var_33_2 = var_33_0.style
	local var_33_3 = var_33_1.rows
	local var_33_4 = var_33_1.columns
	local var_33_5 = InventorySettings.slots_by_ui_slot_index

	for iter_33_0 = 1, var_33_3 do
		for iter_33_1 = 1, var_33_4 do
			local var_33_6 = var_33_5[iter_33_1]
			local var_33_7 = "_" .. tostring(iter_33_0) .. "_" .. tostring(iter_33_1)
			local var_33_8 = "hotspot" .. var_33_7
			local var_33_9 = "slot_hover" .. var_33_7
			local var_33_10 = var_33_1[var_33_8]
			local var_33_11 = var_33_6.type == arg_33_1

			var_33_10.highlight = var_33_11

			local var_33_12 = var_33_10.internal_is_hover and 255 or 100

			var_33_2[var_33_9].color[1] = var_33_11 and var_33_12 or 255
		end
	end
end

function HeroWindowLoadoutConsole._show_weapon_disclaimer(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._widgets_by_name.disclaimer_text.content

	arg_34_0._widgets_by_name.disclaimer_text_background.content.visible = arg_34_1
	var_34_0.visible = arg_34_1
end
