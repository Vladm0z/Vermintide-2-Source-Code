-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_loadout_selection_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_selection_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.loadout_button_widgets
local var_0_3 = var_0_0.gamepad_specific_widgets
local var_0_4 = var_0_0.context_menu_widgets
local var_0_5 = var_0_0.scenegraph_definition
local var_0_6 = var_0_0.animation_definitions
local var_0_7 = var_0_0.button_size
local var_0_8 = var_0_0.button_spacing
local var_0_9 = var_0_0.equipment_slots
local var_0_10 = var_0_0.cosmetic_slots
local var_0_11 = var_0_0.generic_input_actions

HeroWindowLoadoutSelectionConsole = class(HeroWindowLoadoutSelectionConsole)
HeroWindowLoadoutSelectionConsole.NAME = "HeroWindowLoadoutSelectionConsole"

HeroWindowLoadoutSelectionConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowLoadoutSelectionConsole")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0._player_manager = var_1_1
	arg_1_0._profile_synchronizer = var_1_0.profile_synchronizer
	arg_1_0._peer_id = var_1_0.peer_id
	arg_1_0._local_player_id = var_1_0.local_player_id
	arg_1_0._game_mode_key = Managers.state.game_mode:game_mode_key()
	arg_1_0._hero_name = arg_1_1.hero_name
	arg_1_0._career_index = arg_1_1.career_index
	arg_1_0._profile_index = arg_1_1.profile_index
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._gamepad_loadout_grid = {}
	arg_1_0._gamepad_grid_index = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_hide_context_menu()
	arg_1_0:_start_transition_animation("on_enter")

	local var_1_2 = Managers.input:get_service("hero_view")
	local var_1_3 = UILayer.default + 300
	local var_1_4 = var_0_11.default

	if arg_1_0._num_loadouts <= 1 then
		var_1_4 = var_0_11.default_no_delete
	end

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_1_0._ui_top_renderer, var_1_2, 7, var_1_3, var_1_4, true)

	arg_1_0._menu_input_description:set_input_description(nil)
end

HeroWindowLoadoutSelectionConsole._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_5, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

HeroWindowLoadoutSelectionConsole._create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_5)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0

	local var_3_3 = {}

	for iter_3_2, iter_3_3 in pairs(var_0_2) do
		local var_3_4 = UIWidget.init(iter_3_3)

		var_3_3[#var_3_3 + 1] = var_3_4
		var_3_1[iter_3_2] = var_3_4
	end

	arg_3_0._loadout_button_widgets = var_3_3

	local var_3_5 = {}

	for iter_3_4, iter_3_5 in pairs(var_0_4) do
		local var_3_6 = UIWidget.init(iter_3_5)

		var_3_5[#var_3_5 + 1] = var_3_6
		var_3_1[iter_3_4] = var_3_6
	end

	var_3_1.delete_button_bar.content.visible = false
	var_3_1.delete_button_bar_edge.content.visible = false
	arg_3_0._context_menu_widgets = var_3_5

	local var_3_7 = {}

	for iter_3_6, iter_3_7 in pairs(var_0_3) do
		local var_3_8 = UIWidget.init(iter_3_7)

		var_3_7[#var_3_7 + 1] = var_3_8
		var_3_1[iter_3_6] = var_3_8
	end

	arg_3_0._gamepad_specific_widgets = var_3_7
	var_3_1.bot_checkbox.content.visible = InventorySettings.bot_loadout_allowed_game_modes[arg_3_0._game_mode_key] or false
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_6)

	if arg_3_2 then
		local var_3_9 = arg_3_0._ui_scenegraph.window.local_position

		var_3_9[1] = var_3_9[1] + arg_3_2[1]
		var_3_9[2] = var_3_9[2] + arg_3_2[2]
		var_3_9[3] = var_3_9[3] + arg_3_2[3]
	end

	arg_3_0:_populate_loadout_buttons()
end

HeroWindowLoadoutSelectionConsole._populate_loadout_buttons = function (arg_4_0)
	local var_4_0 = SPProfiles[arg_4_0._profile_index].careers[arg_4_0._career_index].name
	local var_4_1 = Managers.backend:get_interface("items")
	local var_4_2 = var_4_1:get_career_loadouts(var_4_0)
	local var_4_3 = var_4_1:get_selected_career_loadout(var_4_0)

	arg_4_0._num_loadouts = #var_4_2

	if var_4_3 > arg_4_0._num_loadouts then
		var_4_3 = 1
	end

	arg_4_0._max_loadouts = 0

	for iter_4_0, iter_4_1 in ipairs(InventorySettings.loadouts) do
		if iter_4_1.loadout_type == "custom" then
			arg_4_0._max_loadouts = arg_4_0._max_loadouts + 1
		end
	end

	arg_4_0._widgets_by_name.add_loadout_button.content.button_hotspot.disable_button = arg_4_0._num_loadouts >= arg_4_0._max_loadouts
	arg_4_0._selected_loadout_index = var_4_3

	if InventorySettings.bot_loadout_allowed_game_modes[arg_4_0._game_mode_key] then
		PlayerData.loadout_selection = PlayerData.loadout_selection or {}
		PlayerData.loadout_selection.bot_equipment = PlayerData.loadout_selection.bot_equipment or {}

		local var_4_4 = PlayerData.loadout_selection.bot_equipment[var_4_0]

		if not var_4_4 or var_4_4 > arg_4_0._num_loadouts then
			PlayerData.loadout_selection.bot_equipment[var_4_0] = var_4_3
		end
	end

	for iter_4_2, iter_4_3 in ipairs(arg_4_0._loadout_button_widgets) do
		local var_4_5 = iter_4_3.content

		var_4_5.visible = var_4_2[iter_4_2] ~= nil
		var_4_5.is_selected = iter_4_2 == arg_4_0._selected_loadout_index
		var_4_5.loadout = var_4_2[iter_4_2]
		var_4_5.loadout_index = iter_4_2
		var_4_5.career_name = var_4_0
	end

	local var_4_6 = arg_4_0._widgets_by_name.loadout_frame
	local var_4_7 = arg_4_0._loadout_button_widgets[var_4_3].offset

	var_4_6.offset[1] = var_4_7[1]
	var_4_6.offset[3] = -10
	arg_4_0._ui_scenegraph.button.offset[1] = -(var_0_7[1] + var_0_8) * (arg_4_0._num_loadouts - 1)
end

HeroWindowLoadoutSelectionConsole.on_exit = function (arg_5_0, arg_5_1)
	print("[HeroViewWindow] Exit Substate HeroWindowLoadoutSelectionConsole")

	arg_5_0._ui_animator = nil

	if not InventorySettings.save_local_loadout_selection[arg_5_0._game_mode_key] then
		return
	end

	local var_5_0 = Managers.player:local_player()
	local var_5_1 = var_5_0 and var_5_0:career_name()

	if var_5_1 and arg_5_0._selected_loadout_index then
		local var_5_2

		for iter_5_0, iter_5_1 in ipairs(InventorySettings.loadouts) do
			local var_5_3 = iter_5_1.loadout_index

			if iter_5_1.loadout_type == "custom" and var_5_3 == arg_5_0._selected_loadout_index then
				var_5_2 = iter_5_0

				break
			end
		end

		if not var_5_2 then
			return
		end

		local var_5_4 = Managers.mechanism:current_mechanism_name()

		PlayerData.loadout_selection = PlayerData.loadout_selection or {}
		PlayerData.loadout_selection[var_5_4] = PlayerData.loadout_selection[var_5_4] or {}
		PlayerData.loadout_selection[var_5_4][var_5_1] = var_5_2

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

HeroWindowLoadoutSelectionConsole.update = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_draw(arg_6_1)
end

HeroWindowLoadoutSelectionConsole.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

HeroWindowLoadoutSelectionConsole._update_animations = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._ui_animations
	local var_8_1 = arg_8_0._animations
	local var_8_2 = arg_8_0._ui_animator

	for iter_8_0, iter_8_1 in pairs(arg_8_0._ui_animations) do
		UIAnimation.update(iter_8_1, arg_8_1)

		if UIAnimation.completed(iter_8_1) then
			arg_8_0._ui_animations[iter_8_0] = nil
		end
	end

	var_8_2:update(arg_8_1)

	for iter_8_2, iter_8_3 in pairs(var_8_1) do
		if var_8_2:is_animation_completed(iter_8_3) then
			var_8_2:stop_animation(iter_8_3)

			var_8_1[iter_8_2] = nil
		end
	end

	for iter_8_4, iter_8_5 in ipairs(arg_8_0._loadout_button_widgets) do
		UIWidgetUtils.animate_default_button(iter_8_5, arg_8_1)
	end

	local var_8_3 = arg_8_0._widgets_by_name.add_loadout_button

	UIWidgetUtils.animate_default_button(var_8_3, arg_8_1)

	if InventorySettings.bot_loadout_allowed_game_modes[arg_8_0._game_mode_key] then
		local var_8_4 = arg_8_0._widgets_by_name.bot_checkbox

		UIWidgetUtils.animate_default_checkbox_button(var_8_4, arg_8_1)
	end

	if arg_8_0._context_menu_active then
		local var_8_5 = arg_8_0._widgets_by_name.delete_button

		UIWidgetUtils.animate_default_button(var_8_5, arg_8_1)
	end
end

HeroWindowLoadoutSelectionConsole._handle_gamepad_activity = function (arg_9_0)
	local var_9_0 = Managers.input:is_device_active("gamepad")

	if var_9_0 ~= arg_9_0._gamepad_active_last_frame then
		arg_9_0:_hide_context_menu()
	end

	arg_9_0._gamepad_active_last_frame = var_9_0
end

HeroWindowLoadoutSelectionConsole._handle_input = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:_handle_gamepad_activity(arg_10_1, arg_10_2)

	local var_10_0 = arg_10_0:_get_input_service()

	if Managers.input:is_device_active("mouse") then
		arg_10_0:_handle_mouse_input(var_10_0, arg_10_1, arg_10_2)
	else
		arg_10_0:_handle_gamepad_input(var_10_0, arg_10_1, arg_10_2)
	end
end

HeroWindowLoadoutSelectionConsole._get_input_service = function (arg_11_0)
	return (arg_11_0._context_menu_active or arg_11_0._on_add_loadout_button) and Managers.input:get_service("hero_view") or arg_11_0._parent:window_input_service()
end

HeroWindowLoadoutSelectionConsole._update_selection_frame = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.loadout_index
	local var_12_1 = arg_12_0._widgets_by_name.hover_loadout_frame

	if var_12_0 ~= arg_12_0._selected_loadout_index then
		local var_12_2 = arg_12_1.offset

		var_12_1.offset = table.clone(var_12_2)
		var_12_1.content.visible = true
		var_12_1.content.loadout_index = var_12_0
	else
		var_12_1.content.visible = false
	end
end

HeroWindowLoadoutSelectionConsole._update_button_hover = function (arg_13_0, arg_13_1, arg_13_2)
	arg_13_0:_update_selection_frame(arg_13_1)

	if arg_13_2 > (arg_13_1.content.hover_enter_time or math.huge) and not arg_13_0._context_menu_active then
		arg_13_0:_show_context_menu(arg_13_1)
	end
end

HeroWindowLoadoutSelectionConsole._reset_hover_frame = function (arg_14_0)
	local var_14_0 = arg_14_0._widgets_by_name.hover_loadout_frame

	if arg_14_0._context_menu_active then
		if var_14_0.content.loadout_index ~= arg_14_0._context_menu_loadout_index then
			var_14_0.content.visible = false
		end
	else
		var_14_0.content.visible = false
	end
end

HeroWindowLoadoutSelectionConsole._handle_mouse_input = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0

	arg_15_0:_reset_hover_frame()

	for iter_15_0, iter_15_1 in ipairs(arg_15_0._loadout_button_widgets) do
		if UIUtils.is_button_hover_enter(iter_15_1) then
			iter_15_1.content.hover_enter_time = arg_15_3 + 0

			arg_15_0:_play_sound("Play_hud_hover")
		elseif UIUtils.is_button_hover(iter_15_1) then
			arg_15_0:_update_button_hover(iter_15_1, arg_15_3)

			var_15_0 = iter_15_0
		end

		if UIUtils.is_button_pressed(iter_15_1) then
			local var_15_1 = iter_15_1.content

			arg_15_0:_change_loadout(iter_15_0)

			return
		end
	end

	local var_15_2 = arg_15_0._widgets_by_name.context_menu_hotspot

	if arg_15_0._context_menu_active and UIUtils.is_button_hover(var_15_2) or var_15_0 == arg_15_0._context_menu_loadout_index then
		arg_15_0:_handle_context_menu_input(arg_15_1, arg_15_2, arg_15_3)

		var_15_2.content.hover_timer = arg_15_3 + 0.1
	elseif arg_15_0._context_menu_active and (var_15_0 or arg_15_3 > (var_15_2.content.hover_timer or 0)) then
		arg_15_0:_hide_context_menu()
	end

	local var_15_3 = arg_15_0._widgets_by_name.add_loadout_button

	if UIUtils.is_button_hover_enter(var_15_3) then
		arg_15_0:_play_sound("Play_hud_hover")
	elseif UIUtils.is_button_pressed(var_15_3) then
		arg_15_0:_add_loadout()
	end
end

HeroWindowLoadoutSelectionConsole._handle_gamepad_input = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_0._inside_context_menu then
		arg_16_0:_handle_context_menu_gamepad_input(arg_16_1, arg_16_2, arg_16_3)
	elseif arg_16_0._on_add_loadout_button then
		arg_16_0:_handle_add_loadout_gamepad_input(arg_16_1, arg_16_2, arg_16_3)
	elseif arg_16_0._context_menu_active then
		if arg_16_1:get("move_left") or arg_16_1:get("trigger_cycle_previous") then
			local var_16_0 = arg_16_0._context_menu_loadout_index
			local var_16_1 = math.max(var_16_0 - 1, 1)

			if var_16_0 ~= var_16_1 then
				arg_16_0:_hide_context_menu()

				local var_16_2 = arg_16_0._loadout_button_widgets[var_16_1]

				arg_16_0:_show_context_menu(var_16_2)
				arg_16_0:_update_selection_frame(var_16_2)
			end
		elseif arg_16_1:get("move_right") or arg_16_1:get("trigger_cycle_next") then
			local var_16_3 = arg_16_0._context_menu_loadout_index
			local var_16_4 = math.min(var_16_3 + 1, arg_16_0._num_loadouts)

			if var_16_3 ~= var_16_4 then
				arg_16_0:_hide_context_menu()

				local var_16_5 = arg_16_0._loadout_button_widgets[var_16_4]

				arg_16_0:_show_context_menu(var_16_5)
				arg_16_0:_update_selection_frame(var_16_5)
			elseif arg_16_0._num_loadouts < arg_16_0._max_loadouts then
				arg_16_0:_on_enter_add_loadout_gamepad()
			end
		elseif arg_16_1:get("special_1") then
			arg_16_0:_enter_details_menu()
		elseif arg_16_1:get("back") or arg_16_1:get("right_stick_press") or arg_16_1:get("toggle_menu") then
			arg_16_0:_hide_context_menu()
		elseif arg_16_1:get("confirm") then
			arg_16_0:_change_loadout(arg_16_0._context_menu_loadout_index)
		elseif arg_16_1:get("left_stick_press") then
			if InventorySettings.bot_loadout_allowed_game_modes[arg_16_0._game_mode_key] then
				local var_16_6 = arg_16_0._widgets_by_name.bot_checkbox.content

				var_16_6.button_hotspot.is_selected = true
				var_16_6.button_hotspot.disable_button = true

				arg_16_0:_save_bot_equipment()
			end
		else
			arg_16_0:_handle_delete_input(arg_16_1, arg_16_2, arg_16_3)
		end
	elseif arg_16_1:get("right_stick_press") then
		local var_16_7 = arg_16_0._loadout_button_widgets[arg_16_0._selected_loadout_index]

		if not var_16_7 then
			return
		end

		arg_16_0:_show_context_menu(var_16_7)
		arg_16_0:_update_selection_frame(var_16_7)

		local var_16_8 = true

		arg_16_0:_update_gamepad_selections(var_16_8)

		arg_16_0._inside_context_menu = false

		arg_16_0._parent:block_input()
	elseif arg_16_1:get("trigger_cycle_next") then
		local var_16_9 = math.min(arg_16_0._selected_loadout_index + 1, arg_16_0._num_loadouts)

		arg_16_0:_change_loadout(var_16_9)
	elseif arg_16_1:get("trigger_cycle_previous") then
		local var_16_10 = math.max(arg_16_0._selected_loadout_index - 1, 1)

		arg_16_0:_change_loadout(var_16_10)
	end
end

HeroWindowLoadoutSelectionConsole._handle_add_loadout_gamepad_input = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if arg_17_1:get("confirm") then
		arg_17_0:_add_loadout()

		local var_17_0 = true

		arg_17_0:_update_gamepad_selections(var_17_0)

		arg_17_0._inside_context_menu = false

		arg_17_0:_hide_context_menu()
	elseif arg_17_1:get("back") or arg_17_1:get("right_stick_press") or arg_17_1:get("toggle_menu") then
		arg_17_0:_hide_context_menu()
	elseif arg_17_1:get("move_left") or arg_17_1:get("trigger_cycle_previous") then
		local var_17_1 = arg_17_0._loadout_button_widgets[arg_17_0._num_loadouts]

		arg_17_0:_show_context_menu(var_17_1)
		arg_17_0:_update_selection_frame(var_17_1)

		local var_17_2 = true

		arg_17_0:_update_gamepad_selections(var_17_2)

		arg_17_0._inside_context_menu = false

		if arg_17_0._num_loadouts > 1 then
			arg_17_0._menu_input_description:change_generic_actions(var_0_11.default)
		else
			arg_17_0._menu_input_description:change_generic_actions(var_0_11.default_no_delete)
		end

		arg_17_0._parent:block_input()
	end
end

HeroWindowLoadoutSelectionConsole._on_enter_add_loadout_gamepad = function (arg_18_0)
	arg_18_0:_hide_context_menu()

	arg_18_0._on_add_loadout_button = true

	local var_18_0 = arg_18_0._widgets_by_name.hover_loadout_frame

	var_18_0.content.visible = true
	var_18_0.offset[1] = arg_18_0._num_loadouts * (var_0_7[1] + var_0_8)

	if arg_18_0._num_loadouts >= arg_18_0._max_loadouts then
		arg_18_0._menu_input_description:change_generic_actions(var_0_11.add_loadout_no_add)
	else
		arg_18_0._menu_input_description:change_generic_actions(var_0_11.add_loadout)
	end

	arg_18_0._parent:block_input()
end

HeroWindowLoadoutSelectionConsole._enter_details_menu = function (arg_19_0)
	arg_19_0._inside_context_menu = true

	table.clear(arg_19_0._gamepad_grid_index)
	arg_19_0:_update_gamepad_selections()
	arg_19_0._menu_input_description:change_generic_actions(var_0_11.details)
end

HeroWindowLoadoutSelectionConsole._exit_details_menu = function (arg_20_0)
	arg_20_0._inside_context_menu = nil

	table.clear(arg_20_0._gamepad_grid_index)

	local var_20_0 = true

	arg_20_0:_update_gamepad_selections(var_20_0)

	if arg_20_0._num_loadouts > 1 then
		arg_20_0._menu_input_description:change_generic_actions(var_0_11.default)
	else
		arg_20_0._menu_input_description:change_generic_actions(var_0_11.default_no_delete)
	end
end

HeroWindowLoadoutSelectionConsole._handle_context_menu_gamepad_input = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = false
	local var_21_1 = arg_21_0._gamepad_grid_index[1]
	local var_21_2 = arg_21_0._gamepad_grid_index[2]
	local var_21_3 = var_21_1 or #arg_21_0._gamepad_loadout_grid
	local var_21_4 = var_21_2 or 1

	if arg_21_1:get("move_left") then
		var_21_4 = math.max(var_21_2 - 1, 1)
	elseif arg_21_1:get("move_right") then
		local var_21_5 = arg_21_0._gamepad_loadout_grid[var_21_1]

		var_21_4 = math.min(var_21_2 + 1, #var_21_5)
	elseif arg_21_1:get("move_up") then
		local var_21_6 = #arg_21_0._gamepad_loadout_grid

		var_21_3 = math.min(var_21_1 + 1, var_21_6)
	elseif arg_21_1:get("move_down") then
		local var_21_7 = #arg_21_0._gamepad_loadout_grid

		var_21_3 = math.max(var_21_1 - 1, 1)
	elseif arg_21_1:get("special_1") or arg_21_1:get("back") then
		arg_21_0:_exit_details_menu()

		return
	elseif arg_21_1:get("right_stick_press") then
		arg_21_0:_exit_details_menu()
		arg_21_0:_hide_context_menu()
	elseif arg_21_1:get("toggle_menu") then
		arg_21_0:_exit_details_menu()
		arg_21_0:_hide_context_menu()
	else
		arg_21_0:_handle_delete_input(arg_21_1, arg_21_2, arg_21_3)
	end

	if var_21_3 ~= var_21_1 then
		arg_21_0._gamepad_grid_index[1] = var_21_3

		local var_21_8 = arg_21_0._gamepad_loadout_grid[var_21_3]

		arg_21_0._gamepad_grid_index[2] = math.clamp(var_21_4, 1, #var_21_8)

		arg_21_0:_update_gamepad_selections()
	elseif var_21_4 ~= var_21_2 then
		arg_21_0._gamepad_grid_index[2] = var_21_4

		arg_21_0:_update_gamepad_selections()
	end
end

HeroWindowLoadoutSelectionConsole._handle_delete_input = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if arg_22_0._num_loadouts == 1 then
		return
	end

	local var_22_0 = arg_22_0._widgets_by_name.delete_button
	local var_22_1 = 1
	local var_22_2 = arg_22_0._delete_progress or 0

	if arg_22_1:get("refresh_hold") or UIUtils.is_button_held(var_22_0) and UIUtils.is_button_hover(var_22_0) then
		if not arg_22_0._delete_started then
			arg_22_0._delete_started = true

			arg_22_0:_play_sound("Play_gui_loadout_delete_start")
		end

		var_22_2 = math.min(var_22_2 + arg_22_2 / var_22_1, 1)
	else
		var_22_2 = math.max(var_22_2 - arg_22_2 * var_22_1, 0)

		if arg_22_0._delete_started then
			arg_22_0._delete_started = false

			arg_22_0:_play_sound("Stop_gui_loadout_delete_start")
		end
	end

	local var_22_3 = math.easeOutCubic(var_22_2)

	arg_22_0._ui_scenegraph.delete_button_bar.size[1] = 172 * var_22_3
	arg_22_0._widgets_by_name.delete_button_bar.content.texture_id.uvs[2][1] = var_22_3

	if var_22_2 >= 1 then
		arg_22_0:_delete_loadout()
	else
		arg_22_0._delete_progress = var_22_2
	end
end

HeroWindowLoadoutSelectionConsole._handle_bot_checkbox_input = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if InventorySettings.bot_loadout_allowed_game_modes[arg_23_0._game_mode_key] then
		local var_23_0 = arg_23_0._widgets_by_name.bot_checkbox

		if UIUtils.is_button_pressed(var_23_0) then
			local var_23_1 = var_23_0.content

			var_23_1.button_hotspot.is_selected = true
			var_23_1.button_hotspot.disable_button = true

			arg_23_0:_save_bot_equipment()
		end
	end
end

HeroWindowLoadoutSelectionConsole._save_bot_equipment = function (arg_24_0)
	local var_24_0 = arg_24_0._profile_index
	local var_24_1 = arg_24_0._career_index
	local var_24_2 = SPProfiles[var_24_0].careers[var_24_1].name

	PlayerData.loadout_selection.bot_equipment[var_24_2] = arg_24_0._context_menu_loadout_index

	Managers.backend:get_interface("items"):refresh_bot_loadouts()
end

HeroWindowLoadoutSelectionConsole._update_gamepad_selections = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1 and 0 or arg_25_0._gamepad_grid_index[1]
	local var_25_1 = arg_25_1 and 0 or arg_25_0._gamepad_grid_index[2]

	for iter_25_0, iter_25_1 in ipairs(arg_25_0._gamepad_loadout_grid) do
		for iter_25_2, iter_25_3 in ipairs(iter_25_1) do
			iter_25_3.is_selected = iter_25_2 == var_25_1 and iter_25_0 == var_25_0
		end
	end
end

HeroWindowLoadoutSelectionConsole._handle_context_menu_input = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = arg_26_0._widgets_by_name.delete_button
	local var_26_1 = arg_26_0._widgets_by_name.context_menu_hotspot

	if arg_26_1:get("toggle_menu", true) then
		arg_26_0:_hide_context_menu()

		return
	end

	local var_26_2 = arg_26_1:get("left_press")
	local var_26_3 = arg_26_1:get("right_press")
	local var_26_4 = arg_26_0._loadout_button_widgets[arg_26_0._context_menu_loadout_index]

	if not UIUtils.is_button_hover(var_26_1) and (var_26_2 or var_26_3) and not UIUtils.is_button_hover(var_26_4) then
		arg_26_0:_hide_context_menu()
	else
		arg_26_0:_handle_delete_input(arg_26_1, arg_26_2, arg_26_3)
		arg_26_0:_handle_bot_checkbox_input(arg_26_1, arg_26_2, arg_26_3)
	end
end

HeroWindowLoadoutSelectionConsole._delete_loadout = function (arg_27_0)
	local var_27_0 = SPProfiles[arg_27_0._profile_index].careers[arg_27_0._career_index].name
	local var_27_1 = arg_27_0._context_menu_loadout_index == arg_27_0._selected_loadout_index

	Managers.backend:get_interface("items"):delete_loadout(var_27_0, arg_27_0._context_menu_loadout_index)
	arg_27_0:_populate_loadout_buttons()
	arg_27_0._parent:update_full_loadout()

	if var_27_1 then
		arg_27_0._parent:set_loadout_dirty()
	end

	arg_27_0._delete_progress = 0

	arg_27_0:_exit_details_menu()
	arg_27_0:_hide_context_menu()
	arg_27_0:_play_sound("Play_gui_loadout_delete_finish")
end

HeroWindowLoadoutSelectionConsole._hide_context_menu = function (arg_28_0)
	arg_28_0._context_menu_active = false
	arg_28_0._inside_context_menu = false
	arg_28_0._on_add_loadout_button = false

	local var_28_0 = true

	arg_28_0:_update_gamepad_selections(var_28_0)
	arg_28_0:_reset_hover_frame()
	arg_28_0._parent:unblock_input()
end

HeroWindowLoadoutSelectionConsole._show_context_menu = function (arg_29_0, arg_29_1)
	arg_29_0._context_menu_active = true
	arg_29_0._on_add_loadout_button = false

	local var_29_0 = arg_29_1.offset

	arg_29_0._ui_scenegraph.context_menu.offset[1] = var_29_0[1]

	local var_29_1 = arg_29_1.content
	local var_29_2 = var_29_1.loadout_index
	local var_29_3 = var_29_1.loadout

	arg_29_0:_populate_context_menu_loadout(var_29_3, var_29_2)

	local var_29_4 = arg_29_0._widgets_by_name.context_menu_bg
	local var_29_5 = arg_29_0._widgets_by_name.context_menu_bg_white

	if var_29_2 == arg_29_0._selected_loadout_index then
		var_29_4.content.visible = true
		var_29_5.content.visible = false
	else
		var_29_4.content.visible = false
		var_29_5.content.visible = true
	end

	for iter_29_0, iter_29_1 in ipairs(arg_29_0._loadout_button_widgets) do
		iter_29_1.offset[3] = iter_29_0 == var_29_2 and -20 or -100
	end

	arg_29_0._delete_progress = 0
	arg_29_0._ui_scenegraph.delete_button_bar.size[1] = 0

	local var_29_6 = arg_29_0._widgets_by_name.delete_button

	var_29_6.content.visible = arg_29_0._num_loadouts > 1
	var_29_6.content.title_text = Localize("input_description_delete_loadout") .. " " .. var_29_2

	local var_29_7 = arg_29_0._widgets_by_name.delete_button_bar

	var_29_7.content.texture_id.uvs[2][1] = 0
	var_29_7.content.visible = arg_29_0._num_loadouts > 1
	arg_29_0._widgets_by_name.delete_button_bar_edge.content.visible = arg_29_0._num_loadouts > 1
	arg_29_0._context_menu_loadout_index = var_29_2

	arg_29_0._parent:block_input()

	if arg_29_0._num_loadouts > 1 then
		arg_29_0._menu_input_description:change_generic_actions(var_0_11.default)
	else
		arg_29_0._menu_input_description:change_generic_actions(var_0_11.default_no_delete)
	end
end

local var_0_12 = {}

HeroWindowLoadoutSelectionConsole._populate_context_menu_loadout = function (arg_30_0, arg_30_1, arg_30_2)
	arg_30_0._gamepad_loadout_grid = {}

	local var_30_0 = arg_30_0._profile_index
	local var_30_1 = arg_30_0._career_index
	local var_30_2 = SPProfiles[var_30_0]
	local var_30_3 = var_30_2.careers[var_30_1]
	local var_30_4 = var_30_2.display_name
	local var_30_5 = var_30_3.name
	local var_30_6 = {}

	for iter_30_0, iter_30_1 in ipairs(InventorySettings.loadouts) do
		if iter_30_1.loadout_type == "custom" then
			var_30_6[#var_30_6 + 1] = iter_30_1
		end
	end

	local var_30_7 = var_30_6[arg_30_2]
	local var_30_8 = arg_30_0._widgets_by_name.icon
	local var_30_9 = arg_30_0._widgets_by_name.header

	var_30_8.content.texture_id = var_30_7.loadout_icon or "icons_placeholder"
	var_30_9.content.text = Localize("custom_loadout_" .. var_30_7.loadout_index .. "_title")

	local var_30_10 = Managers.backend:get_interface("items")
	local var_30_11 = arg_30_0._widgets_by_name.cosmetics.content
	local var_30_12

	for iter_30_2, iter_30_3 in ipairs(var_0_10) do
		local var_30_13

		if CosmeticUtils.is_cosmetic_slot(iter_30_3) then
			local var_30_14 = arg_30_1[iter_30_3]
			local var_30_15 = var_30_10:get_backend_id_from_cosmetic_item(var_30_14)

			var_30_13 = var_30_10:get_item_from_id(var_30_15)
		elseif iter_30_3 == "slot_pose" then
			local var_30_16 = arg_30_1[iter_30_3]
			local var_30_17 = var_30_16 and var_30_10:get_backend_id_from_unlocked_weapon_poses(var_30_16)

			var_30_13 = var_30_17 and var_30_10:get_item_from_id(var_30_17)
		else
			var_30_13 = BackendUtils.get_loadout_item(var_30_5, iter_30_3)
		end

		if var_30_13 then
			var_30_11[iter_30_3].item = var_30_13
			var_30_11[iter_30_3].icon = var_30_13.data.inventory_icon or var_30_13.data.hud_icon
			var_30_11[iter_30_3].profile_index = arg_30_0._profile_index
			var_30_11[iter_30_3].career_index = arg_30_0._career_index
			var_30_11[iter_30_3].rarity = UISettings.item_rarity_textures[var_30_13.rarity]
			var_30_12 = var_30_12 or {}
			var_30_12[#var_30_12 + 1] = var_30_11[iter_30_3]
		else
			Application.warning(string.format("[HeroWindowLoadoutSelectionConsole] Missing %q for loadout_index: %q", iter_30_3, arg_30_2))
		end
	end

	arg_30_0._gamepad_loadout_grid[#arg_30_0._gamepad_loadout_grid + 1] = var_30_12

	local var_30_18 = Managers.backend:get_interface("talents")
	local var_30_19 = var_30_18:get_career_talents(var_30_5)[arg_30_2]
	local var_30_20 = var_30_18:get_career_talent_ids(var_30_5, arg_30_2)
	local var_30_21 = arg_30_0._widgets_by_name.talents.content
	local var_30_22
	local var_30_23 = 1

	for iter_30_4 = 1, MaxTalentPoints do
		local var_30_24 = var_30_21["talent_" .. iter_30_4]

		if var_30_19[iter_30_4] ~= 0 then
			local var_30_25 = var_30_20[var_30_23]
			local var_30_26 = TalentUtils.get_talent_by_id(var_30_4, var_30_25)
			local var_30_27 = var_30_26 and var_30_26.icon

			if not var_30_27 then
				var_30_26 = nil
			end

			var_30_24.icon = var_30_27
			var_30_24.talent = var_30_26
			var_30_23 = var_30_23 + 1

			if var_30_26 then
				var_30_22 = var_30_22 or {}
				var_30_22[#var_30_22 + 1] = var_30_24
			end
		else
			var_30_24.talent = nil
		end
	end

	arg_30_0._gamepad_loadout_grid[#arg_30_0._gamepad_loadout_grid + 1] = var_30_22

	local var_30_28 = arg_30_0._widgets_by_name.equipment.content
	local var_30_29

	for iter_30_5, iter_30_6 in ipairs(var_0_9) do
		local var_30_30

		if arg_30_1 then
			local var_30_31 = arg_30_1[iter_30_6]

			var_30_30 = var_30_10:get_item_from_id(var_30_31)
		else
			var_30_30 = BackendUtils.get_loadout_item(var_30_5, iter_30_6)
		end

		local var_30_32, var_30_33, var_30_34 = UIUtils.get_ui_information_from_item(var_30_30)

		var_30_28[iter_30_6].item = var_30_30
		var_30_28[iter_30_6].rarity = UISettings.item_rarity_textures[var_30_30.rarity]
		var_30_28[iter_30_6].icon = var_30_32
		var_30_28[iter_30_6].profile_index = arg_30_0._profile_index
		var_30_28[iter_30_6].career_index = arg_30_0._career_index
		var_30_29 = var_30_29 or {}
		var_30_29[#var_30_29 + 1] = var_30_28[iter_30_6]
	end

	arg_30_0._gamepad_loadout_grid[#arg_30_0._gamepad_loadout_grid + 1] = var_30_29

	local var_30_35 = PlayerData.loadout_selection and PlayerData.loadout_selection.bot_equipment
	local var_30_36
	local var_30_37 = var_30_35 and var_30_35[var_30_5]

	if var_30_37 then
		var_30_36 = var_30_37 == arg_30_2
	else
		var_30_36 = arg_30_2 == arg_30_0._selected_loadout_index
	end

	local var_30_38 = arg_30_0._widgets_by_name.bot_checkbox.content

	var_30_38.button_hotspot.is_selected = var_30_36
	var_30_38.button_hotspot.disable_button = var_30_36
end

HeroWindowLoadoutSelectionConsole._change_loadout = function (arg_31_0, arg_31_1)
	if arg_31_1 and arg_31_1 ~= arg_31_0._selected_loadout_index then
		local var_31_0 = SPProfiles[arg_31_0._profile_index].careers[arg_31_0._career_index].name
		local var_31_1 = Managers.backend:get_interface("items")

		var_31_1:set_loadout_index(var_31_0, arg_31_1)

		local var_31_2 = var_31_1:get_selected_career_loadout(var_31_0)

		if var_31_2 > arg_31_0._num_loadouts then
			var_31_2 = 1
		end

		arg_31_0._selected_loadout_index = var_31_2

		local var_31_3 = arg_31_0._widgets_by_name.loadout_frame
		local var_31_4 = arg_31_0._loadout_button_widgets[arg_31_1].offset

		var_31_3.offset = table.clone(var_31_4)

		arg_31_0._parent:update_full_loadout()
		arg_31_0:_play_sound("Play_gui_loadout_select")
		arg_31_0:_hide_context_menu()
		arg_31_0._parent:set_loadout_dirty()
	end
end

HeroWindowLoadoutSelectionConsole._add_loadout = function (arg_32_0)
	if #arg_32_0._loadout_button_widgets >= arg_32_0._num_loadouts + 1 then
		local var_32_0 = SPProfiles[arg_32_0._profile_index].careers[arg_32_0._career_index].name

		Managers.backend:get_interface("items"):add_loadout(var_32_0)
		arg_32_0:_play_sound("Play_gui_loadout_add")
		arg_32_0._parent:update_full_loadout()
		arg_32_0:_populate_loadout_buttons()
	end
end

HeroWindowLoadoutSelectionConsole.set_focus = function (arg_33_0, arg_33_1)
	arg_33_0._focused = arg_33_1
end

HeroWindowLoadoutSelectionConsole._exit = function (arg_34_0)
	arg_34_0.exit = true
end

HeroWindowLoadoutSelectionConsole._draw = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._ui_renderer
	local var_35_1 = arg_35_0._ui_top_renderer
	local var_35_2 = arg_35_0._ui_scenegraph
	local var_35_3 = arg_35_0:_get_input_service()
	local var_35_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_35_1, var_35_2, var_35_3, arg_35_1, nil, arg_35_0._render_settings)

	for iter_35_0, iter_35_1 in ipairs(arg_35_0._widgets) do
		UIRenderer.draw_widget(var_35_1, iter_35_1)
	end

	for iter_35_2, iter_35_3 in ipairs(arg_35_0._loadout_button_widgets) do
		UIRenderer.draw_widget(var_35_1, iter_35_3)
	end

	if arg_35_0._context_menu_active then
		for iter_35_4, iter_35_5 in ipairs(arg_35_0._context_menu_widgets) do
			UIRenderer.draw_widget(var_35_1, iter_35_5)
		end
	end

	if var_35_4 and (arg_35_0._context_menu_active or arg_35_0._on_add_loadout_button) then
		for iter_35_6, iter_35_7 in ipairs(arg_35_0._gamepad_specific_widgets) do
			UIRenderer.draw_widget(var_35_1, iter_35_7)
		end
	end

	UIRenderer.end_pass(var_35_1)

	if var_35_4 and (arg_35_0._context_menu_active or arg_35_0._on_add_loadout_button) then
		arg_35_0._menu_input_description:draw(var_35_1, arg_35_1)
	end
end

HeroWindowLoadoutSelectionConsole._play_sound = function (arg_36_0, arg_36_1)
	arg_36_0._parent:play_sound(arg_36_1)
end
