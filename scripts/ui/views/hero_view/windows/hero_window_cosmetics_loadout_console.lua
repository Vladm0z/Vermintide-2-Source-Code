-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.generic_input_actions
local var_0_5 = false
local var_0_6 = "cosmetics_selection"

HeroWindowCosmeticsLoadoutConsole = class(HeroWindowCosmeticsLoadoutConsole)
HeroWindowCosmeticsLoadoutConsole.NAME = "HeroWindowCosmeticsLoadoutConsole"

function HeroWindowCosmeticsLoadoutConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsLoadoutConsole")

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

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index

	arg_1_0:_start_transition_animation("on_enter")
end

function HeroWindowCosmeticsLoadoutConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_2, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function HeroWindowCosmeticsLoadoutConsole.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
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

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_3)

	if arg_3_2 then
		local var_3_3 = arg_3_0.ui_scenegraph.window.local_position

		var_3_3[1] = var_3_3[1] + arg_3_2[1]
		var_3_3[2] = var_3_3[2] + arg_3_2[2]
		var_3_3[3] = var_3_3[3] + arg_3_2[3]
	end

	local var_3_4 = Managers.input:get_service("hero_view")
	local var_3_5 = UILayer.default + 300

	arg_3_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_3_0.ui_top_renderer, var_3_4, 6, var_3_5, var_0_4.default, true)

	arg_3_0._menu_input_description:set_input_description(nil)

	local var_3_6 = var_3_1.loadout_grid.content

	var_3_6.profile_index = arg_3_0.params.profile_index
	var_3_6.career_index = arg_3_0.params.career_index

	local var_3_7 = InventorySettings.slots_by_cosmetic_index

	for iter_3_2, iter_3_3 in pairs(var_3_7) do
		local var_3_8 = iter_3_3.cosmetic_index

		var_3_6["layout_" .. tostring(var_3_8) .. "_1"] = iter_3_3.layout_name or var_0_6
	end
end

function HeroWindowCosmeticsLoadoutConsole.on_exit(arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsLoadoutConsole")

	arg_4_0.ui_animator = nil

	arg_4_0._menu_input_description:destroy()

	arg_4_0._menu_input_description = nil
end

function HeroWindowCosmeticsLoadoutConsole._input_service(arg_5_0)
	local var_5_0 = arg_5_0.parent

	if var_5_0:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return var_5_0:window_input_service()
end

function HeroWindowCosmeticsLoadoutConsole.update(arg_6_0, arg_6_1, arg_6_2)
	if var_0_5 then
		var_0_5 = false

		arg_6_0:create_ui_elements()
	end

	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_update_loadout_sync()
	arg_6_0:_update_selected_cosmetic_slot_index()
	arg_6_0:_update_input_description()
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_handle_gamepad_input(arg_6_1, arg_6_2)
	arg_6_0:draw(arg_6_1)
end

function HeroWindowCosmeticsLoadoutConsole.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function HeroWindowCosmeticsLoadoutConsole._update_input_description(arg_8_0)
	local var_8_0 = arg_8_0.params
	local var_8_1 = arg_8_0.params.hero_statistics_active

	if var_8_1 ~= arg_8_0._hero_statistics_active then
		arg_8_0._hero_statistics_active = var_8_1

		if var_8_1 then
			arg_8_0._menu_input_description:change_generic_actions(var_0_4.details)
		else
			arg_8_0._menu_input_description:change_generic_actions(var_0_4.default)
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._update_animations(arg_9_0, arg_9_1)
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

function HeroWindowCosmeticsLoadoutConsole._is_button_pressed(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.on_release then
		var_10_0.on_release = false

		return true
	end
end

function HeroWindowCosmeticsLoadoutConsole._handle_gamepad_input(arg_11_0, arg_11_1, arg_11_2)
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
			var_11_0:set_selected_cosmetic_slot_index(var_11_5 - 1)
			arg_11_0:_play_sound("play_gui_cosmetics_selection_click")
		elseif var_11_5 < var_11_3 and var_11_1:get("move_down_hold_continuous") then
			var_11_0:set_selected_cosmetic_slot_index(var_11_5 + 1)
			arg_11_0:_play_sound("play_gui_cosmetics_selection_click")
		end
	end

	if var_11_1:get("confirm", true) then
		local var_11_8 = arg_11_0._widgets_by_name.loadout_grid.content["layout_" .. tostring(var_11_5) .. "_1"]

		var_11_0:set_layout_by_name(var_11_8 or var_0_6)
	end
end

function HeroWindowCosmeticsLoadoutConsole._handle_input(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.parent
	local var_12_1 = arg_12_0:_is_equipment_slot_hovered()

	if var_12_1 then
		var_12_0:set_selected_cosmetic_slot_index(var_12_1)
		arg_12_0:_play_sound("play_gui_cosmetics_selection_hover")
	end

	local var_12_2 = arg_12_0:_is_equipment_slot_pressed()

	if var_12_2 then
		local var_12_3 = arg_12_0._widgets_by_name.loadout_grid.content["layout_" .. tostring(var_12_2) .. "_1"]

		arg_12_0:_play_sound("play_gui_cosmetics_selection_click")
		var_12_0:set_layout_by_name(var_12_3 or var_0_6)
	end
end

function HeroWindowCosmeticsLoadoutConsole._update_selected_cosmetic_slot_index(arg_13_0)
	local var_13_0 = arg_13_0.parent:get_selected_cosmetic_slot_index()

	if var_13_0 ~= arg_13_0._selected_cosmetic_slot_index then
		arg_13_0:_set_equipment_slot_selected(var_13_0)

		arg_13_0._selected_cosmetic_slot_index = var_13_0
	end
end

function HeroWindowCosmeticsLoadoutConsole._update_loadout_sync(arg_14_0)
	local var_14_0 = arg_14_0.parent.loadout_sync_id

	if var_14_0 ~= arg_14_0._loadout_sync_id then
		arg_14_0:_populate_loadout()

		arg_14_0._loadout_sync_id = var_14_0
	end
end

function HeroWindowCosmeticsLoadoutConsole._exit(arg_15_0, arg_15_1)
	arg_15_0.exit = true
	arg_15_0.exit_level_id = arg_15_1
end

function HeroWindowCosmeticsLoadoutConsole.draw(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.ui_renderer
	local var_16_1 = arg_16_0.ui_top_renderer
	local var_16_2 = arg_16_0.ui_scenegraph
	local var_16_3 = arg_16_0:_input_service()
	local var_16_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_16_1, var_16_2, var_16_3, arg_16_1, nil, arg_16_0.render_settings)

	for iter_16_0, iter_16_1 in ipairs(arg_16_0._widgets) do
		UIRenderer.draw_widget(var_16_1, iter_16_1)
	end

	local var_16_5 = arg_16_0._active_node_widgets

	if var_16_5 then
		for iter_16_2, iter_16_3 in ipairs(var_16_5) do
			UIRenderer.draw_widget(var_16_1, iter_16_3)
		end
	end

	UIRenderer.end_pass(var_16_1)

	if var_16_4 and arg_16_0._menu_input_description and not arg_16_0.parent:input_blocked() then
		arg_16_0._menu_input_description:draw(var_16_1, arg_16_1)
	end
end

function HeroWindowCosmeticsLoadoutConsole._play_sound(arg_17_0, arg_17_1)
	arg_17_0.parent:play_sound(arg_17_1)
end

function HeroWindowCosmeticsLoadoutConsole._setup_slot_icons(arg_18_0)
	local var_18_0 = InventorySettings.slots_by_cosmetic_index

	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		local var_18_1 = iter_18_1.ui_slot_index

		if var_18_1 then
			local var_18_2 = arg_18_0._widgets_by_name.loadout_grid.content
			local var_18_3 = "_1_" .. tostring(var_18_1)
			local var_18_4 = "item_icon" .. var_18_3
			local var_18_5 = "hotspot" .. var_18_3
			local var_18_6 = "item_tooltip" .. var_18_3
			local var_18_7 = "slot_icon" .. var_18_3
			local var_18_8 = iter_18_1.type

			var_18_2[var_18_7] = slot_icon_by_type[var_18_8] or "tabs_icon_all_selected"
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._populate_loadout(arg_19_0)
	local var_19_0 = arg_19_0.hero_name
	local var_19_1 = InventorySettings.slots_by_cosmetic_index
	local var_19_2 = arg_19_0.career_index
	local var_19_3 = FindProfileIndex(var_19_0)
	local var_19_4 = SPProfiles[var_19_3].careers[var_19_2].name

	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		local var_19_5 = iter_19_1.name

		arg_19_0:_clear_item_slot(iter_19_1)

		local var_19_6 = BackendUtils.get_loadout_item(var_19_4, var_19_5)

		if var_19_6 then
			arg_19_0:_equip_item_presentation(var_19_6, iter_19_1)
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._equip_item_presentation(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_1.data.slot_type
	local var_20_1 = arg_20_2.slot_index
	local var_20_2 = arg_20_2.cosmetic_index
	local var_20_3 = arg_20_0._widgets_by_name

	if var_20_2 then
		arg_20_0._equipment_items[var_20_2] = arg_20_1

		local var_20_4 = var_20_3.loadout_grid
		local var_20_5 = var_20_4.content
		local var_20_6 = var_20_4.style
		local var_20_7 = "_" .. tostring(var_20_2) .. "_1"
		local var_20_8 = "item_icon" .. var_20_7
		local var_20_9 = "hotspot" .. var_20_7
		local var_20_10 = "item_tooltip" .. var_20_7
		local var_20_11, var_20_12, var_20_13 = UIUtils.get_ui_information_from_item(arg_20_1)

		var_20_5[var_20_10] = var_20_12
		var_20_5["item" .. var_20_7] = arg_20_1

		local var_20_14 = arg_20_1.backend_id
		local var_20_15 = arg_20_1.rarity
		local var_20_16 = Managers.backend:get_interface("items")

		if var_20_14 then
			var_20_15 = var_20_16:get_item_rarity(var_20_14)
		end

		if var_20_15 then
			var_20_5["rarity_texture" .. var_20_7] = UISettings.item_rarity_textures[var_20_15]
		end

		var_20_5[var_20_9][var_20_8] = var_20_11
	end
end

function HeroWindowCosmeticsLoadoutConsole._clear_item_slot(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1.type
	local var_21_1 = arg_21_1.slot_index
	local var_21_2 = arg_21_1.ui_slot_index
	local var_21_3 = arg_21_0._widgets_by_name

	if var_21_2 then
		arg_21_0._equipment_items[var_21_1] = nil

		local var_21_4 = var_21_3.loadout_grid
		local var_21_5 = var_21_4.content
		local var_21_6 = var_21_4.style
		local var_21_7 = "_" .. tostring(var_21_1) .. "_1"
		local var_21_8 = "item_icon" .. var_21_7
		local var_21_9 = "hotspot" .. var_21_7

		var_21_5["item_tooltip" .. var_21_7] = nil
		var_21_5["item" .. var_21_7] = nil
		var_21_5[var_21_9][var_21_8] = nil
	end
end

function HeroWindowCosmeticsLoadoutConsole._is_equipment_slot_right_clicked(arg_22_0)
	local var_22_0 = arg_22_0._widgets_by_name.loadout_grid.content
	local var_22_1 = var_22_0.rows
	local var_22_2 = var_22_0.columns

	for iter_22_0 = 1, var_22_1 do
		for iter_22_1 = 1, var_22_2 do
			local var_22_3 = "_" .. tostring(iter_22_0) .. "_" .. tostring(iter_22_1)

			if var_22_0["hotspot" .. var_22_3].on_right_click then
				return iter_22_0
			end
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._is_equipment_slot_pressed(arg_23_0)
	local var_23_0 = arg_23_0._widgets_by_name.loadout_grid.content
	local var_23_1 = var_23_0.rows
	local var_23_2 = var_23_0.columns

	for iter_23_0 = 1, var_23_1 do
		for iter_23_1 = 1, var_23_2 do
			local var_23_3 = "_" .. tostring(iter_23_0) .. "_" .. tostring(iter_23_1)

			if var_23_0["hotspot" .. var_23_3].on_pressed then
				return iter_23_0
			end
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._is_equipment_slot_hovered(arg_24_0)
	local var_24_0 = arg_24_0._widgets_by_name.loadout_grid.content
	local var_24_1 = var_24_0.rows
	local var_24_2 = var_24_0.columns

	for iter_24_0 = 1, var_24_1 do
		for iter_24_1 = 1, var_24_2 do
			local var_24_3 = "_" .. tostring(iter_24_0) .. "_" .. tostring(iter_24_1)

			if var_24_0["hotspot" .. var_24_3].on_hover_enter then
				return iter_24_0
			end
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._set_equipment_slot_selected(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._widgets_by_name.loadout_grid.content
	local var_25_1 = var_25_0.rows
	local var_25_2 = var_25_0.columns

	for iter_25_0 = 1, var_25_1 do
		for iter_25_1 = 1, var_25_2 do
			local var_25_3 = "_" .. tostring(iter_25_0) .. "_" .. tostring(iter_25_1)
			local var_25_4 = var_25_0["hotspot" .. var_25_3]

			var_25_4.is_selected = arg_25_1 and arg_25_1 == iter_25_0
			var_25_4.highlight = var_25_4.is_selected
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._enable_selection_highlight(arg_26_0)
	local var_26_0 = arg_26_0._widgets_by_name.loadout_grid.content
	local var_26_1 = var_26_0.rows
	local var_26_2 = var_26_0.columns

	for iter_26_0 = 1, var_26_1 do
		for iter_26_1 = 1, var_26_2 do
			local var_26_3 = "_" .. tostring(iter_26_0) .. "_" .. tostring(iter_26_1)
			local var_26_4 = var_26_0["hotspot" .. var_26_3]

			var_26_4.highlight = var_26_4.is_selected
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._disable_selection_highlight(arg_27_0)
	local var_27_0 = arg_27_0._widgets_by_name.loadout_grid.content
	local var_27_1 = var_27_0.rows
	local var_27_2 = var_27_0.columns

	for iter_27_0 = 1, var_27_1 do
		for iter_27_1 = 1, var_27_2 do
			local var_27_3 = "_" .. tostring(iter_27_0) .. "_" .. tostring(iter_27_1)

			var_27_0["hotspot" .. var_27_3].highlight = false
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._is_equipment_slot_hovered_by_type(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._widgets_by_name.loadout_grid.content
	local var_28_1 = var_28_0.rows
	local var_28_2 = var_28_0.columns
	local var_28_3 = InventorySettings.slots_by_ui_slot_index

	for iter_28_0 = 1, var_28_1 do
		for iter_28_1 = 1, var_28_2 do
			if var_28_3[iter_28_1].type == arg_28_1 then
				local var_28_4 = "_" .. tostring(iter_28_0) .. "_" .. tostring(iter_28_1)

				if var_28_0["hotspot" .. var_28_4].internal_is_hover then
					return iter_28_1
				end
			end
		end
	end
end

function HeroWindowCosmeticsLoadoutConsole._highlight_equipment_slot_by_type(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._widgets_by_name.loadout_grid
	local var_29_1 = var_29_0.content
	local var_29_2 = var_29_0.style
	local var_29_3 = var_29_1.rows
	local var_29_4 = var_29_1.columns
	local var_29_5 = InventorySettings.slots_by_ui_slot_index

	for iter_29_0 = 1, var_29_3 do
		for iter_29_1 = 1, var_29_4 do
			local var_29_6 = var_29_5[iter_29_1]
			local var_29_7 = "_" .. tostring(iter_29_0) .. "_" .. tostring(iter_29_1)
			local var_29_8 = "hotspot" .. var_29_7
			local var_29_9 = "slot_hover" .. var_29_7
			local var_29_10 = var_29_1[var_29_8]
			local var_29_11 = var_29_6.type == arg_29_1

			var_29_10.highlight = var_29_11

			local var_29_12 = var_29_10.internal_is_hover and 255 or 100

			var_29_2[var_29_9].color[1] = var_29_11 and var_29_12 or 255
		end
	end
end
