-- chunkname: @scripts/ui/views/lobby_browser_console_ui.lua

require("foundation/scripts/util/local_require")
require("scripts/managers/telemetry/iso_country_names")
require("scripts/settings/level_settings")

local var_0_0 = local_require("scripts/ui/views/lobby_browser_console_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.base_widget_definition
local var_0_3 = var_0_0.adventure_details_widget_definition
local var_0_4 = var_0_0.weave_details_widget_definition
local var_0_5 = var_0_0.deus_details_widget_definition
local var_0_6 = var_0_0.versus_details_widget_definition
local var_0_7 = var_0_0.animation_definitions

LobbyBrowserConsoleUI = class(LobbyBrowserConsoleUI)

local var_0_8 = {
	deus = "area_selection_morris_name",
	adventure = "area_selection_campaign",
	weave = "menu_weave_area_no_wom_title",
	versus = "area_selection_carousel_name",
	any = "lobby_browser_mission"
}

LobbyBrowserConsoleUI.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._game_mode_data = arg_1_3
	arg_1_0._show_lobby_data_table = arg_1_4
	arg_1_0._distance_data_table = arg_1_5
	arg_1_0._parent = arg_1_1
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._details_type = "adventure"
	arg_1_0._ui_renderer = arg_1_2.ui_top_renderer
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._world_manager = arg_1_2.world_manager
	arg_1_0._world = arg_1_0._world_manager:world("level_world")
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)

	arg_1_0:_create_ui_elements()
	arg_1_0:_start_transition_animation("on_enter")
end

LobbyBrowserConsoleUI._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

LobbyBrowserConsoleUI._create_ui_elements = function (arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_3_0._widgets = {}
	arg_3_0._animations = {}
	arg_3_0._lobby_entry_widgets = {}
	arg_3_0._empty_lobby_entry_widgets = {}
	arg_3_0._details_widgets = {}
	arg_3_0._dynamic_details_widgets = {}
	arg_3_0._ui_animations = {}
	arg_3_0._selected_lobby_index = 1
	arg_3_0._mouse_selected_index = 1
	arg_3_0._visible_list_index = 1
	arg_3_0._hold_up_timer = 0
	arg_3_0._hold_down_timer = 0
	arg_3_0._hold_up_list_timer = 0
	arg_3_0._hold_down_list_timer = 0
	arg_3_0._wanted_pos = 0
	arg_3_0._base_pos_y = nil
	arg_3_0._list_base_pos_y = nil
	arg_3_0._dot_timer = 0
	arg_3_0._details_filled = false

	UIUtils.create_widgets(var_0_2, false, arg_3_0._widgets)

	local var_3_0 = {}

	UIUtils.create_widgets(var_0_3, false, var_3_0)

	arg_3_0._details_widgets.adventure = var_3_0
	arg_3_0._dynamic_details_widgets.adventure = {}

	local var_3_1 = {}

	UIUtils.create_widgets(var_0_5, false, var_3_1)

	arg_3_0._details_widgets.deus = var_3_1
	arg_3_0._dynamic_details_widgets.deus = {}

	local var_3_2 = {}

	UIUtils.create_widgets(var_0_4, false, var_3_2)

	arg_3_0._details_widgets.weave = var_3_2
	arg_3_0._dynamic_details_widgets.weave = {}

	local var_3_3 = {}

	UIUtils.create_widgets(var_0_6, false, var_3_3)

	arg_3_0._details_widgets.versus = var_3_3
	arg_3_0._dynamic_details_widgets.versus = {}

	arg_3_0:populate_lobby_list(arg_3_0._lobbies or {}, false)
	arg_3_0:_create_filters()
	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_7)
end

LobbyBrowserConsoleUI._create_filters = function (arg_4_0)
	arg_4_0._game_type_filter_widgets = {}
	arg_4_0._level_filter_widgets = {}
	arg_4_0._difficulty_filter_widgets = {}
	arg_4_0._lobby_filter_widgets = {}
	arg_4_0._distance_filter_widgets = {}
	arg_4_0._filter_functions = {
		{
			input_function = "_handle_game_type_filter_input",
			render_function = "_render_game_type_filter_list",
			input_function_mouse = "_handle_game_type_filter_input_mouse"
		},
		{
			input_function = "_handle_level_filter_input",
			render_function = "_render_level_filter_list",
			input_function_mouse = "_handle_level_filter_input_mouse"
		},
		{
			input_function = "_handle_difficulty_filter_input",
			render_function = "_render_difficulty_filter_list",
			input_function_mouse = "_handle_difficulty_filter_input_mouse"
		},
		{
			input_function = "_handle_lobby_filter_input",
			render_function = "_render_lobby_filter_list",
			input_function_mouse = "_handle_lobby_filter_input_mouse"
		},
		{
			input_function = "_handle_distance_filter_input",
			render_function = "_render_distance_filter_list",
			input_function_mouse = "_handle_distance_filter_input_mouse"
		}
	}

	arg_4_0:setup_filter_entries()
end

LobbyBrowserConsoleUI.setup_filter_entries = function (arg_5_0)
	table.clear(arg_5_0._game_type_filter_widgets)
	table.clear(arg_5_0._level_filter_widgets)
	table.clear(arg_5_0._difficulty_filter_widgets)
	table.clear(arg_5_0._lobby_filter_widgets)
	table.clear(arg_5_0._distance_filter_widgets)

	local var_5_0 = arg_5_0._game_mode_data
	local var_5_1 = var_5_0.game_modes
	local var_5_2 = var_5_0[arg_5_0._parent:get_selected_game_mode_index() or var_5_1.adventure]
	local var_5_3 = var_5_2.game_mode_key
	local var_5_4 = UnlockableLevelsByGameMode[var_5_3] and table.clone(UnlockableLevelsByGameMode[var_5_3]) or {}
	local var_5_5 = var_5_2.levels
	local var_5_6 = var_5_2.difficulties
	local var_5_7 = var_0_0.element_settings
	local var_5_8 = -var_5_7.filter_height - var_5_7.spacing
	local var_5_9 = var_0_0.create_game_type_filter_entry_func
	local var_5_10 = var_5_9("any", var_0_8.any, var_5_8)

	arg_5_0._game_type_filter_widgets[#arg_5_0._game_type_filter_widgets + 1] = UIWidget.init(var_5_10)

	for iter_5_0, iter_5_1 in ipairs(var_5_1) do
		if iter_5_1 ~= "any" then
			var_5_8 = var_5_8 - var_5_7.filter_height - var_5_7.spacing

			local var_5_11 = var_5_9(iter_5_1, var_0_8[iter_5_1], var_5_8)

			arg_5_0._game_type_filter_widgets[#arg_5_0._game_type_filter_widgets + 1] = UIWidget.init(var_5_11)
		end
	end

	local var_5_12 = {}
	local var_5_13 = var_0_0.create_level_filter_entry_func

	for iter_5_2, iter_5_3 in pairs(var_5_5) do
		if iter_5_3 ~= "any" then
			local var_5_14 = table.find(var_5_4, iter_5_3)

			table.remove(var_5_4, var_5_14)

			local var_5_15 = var_5_13(iter_5_3, true)

			var_5_12[#var_5_12 + 1] = UIWidget.init(var_5_15)
		end
	end

	local function var_5_16(arg_6_0, arg_6_1)
		return string.gsub(string.lower(arg_6_0.content.level_name_id), "the ", "") < string.gsub(string.lower(arg_6_1.content.level_name_id), "the ", "")
	end

	table.sort(var_5_12, var_5_16)

	local var_5_17 = {}

	for iter_5_4, iter_5_5 in pairs(var_5_4) do
		if not LevelSettings[iter_5_5].ommit_from_lobby_browser then
			local var_5_18 = var_5_13(iter_5_5, false)

			var_5_17[#var_5_17 + 1] = UIWidget.init(var_5_18)
		end
	end

	table.sort(var_5_17, var_5_16)
	table.append(var_5_12, var_5_17)

	local var_5_19 = var_5_13("any", true)
	local var_5_20 = UIWidget.init(var_5_19)

	table.insert(var_5_12, 1, var_5_20)

	local var_5_21 = 0

	for iter_5_6, iter_5_7 in ipairs(var_5_12) do
		var_5_21 = var_5_21 - var_5_7.filter_height - var_5_7.spacing
		iter_5_7.offset[2] = var_5_21
	end

	arg_5_0._level_filter_widgets = var_5_12
	arg_5_0._level_filter_scroller = UIWidget.init(var_0_0.create_level_filter_scroller_func(#var_5_12))

	local var_5_22 = -var_5_7.filter_height - var_5_7.spacing
	local var_5_23 = var_0_0.create_difficulty_filter_entry_func
	local var_5_24 = var_5_23("any", var_5_22)

	arg_5_0._difficulty_filter_widgets[#arg_5_0._difficulty_filter_widgets + 1] = UIWidget.init(var_5_24)

	for iter_5_8, iter_5_9 in pairs(var_5_6) do
		if iter_5_9 ~= "any" then
			var_5_22 = var_5_22 - var_5_7.filter_height - var_5_7.spacing

			local var_5_25 = var_5_23(iter_5_9, var_5_22)

			arg_5_0._difficulty_filter_widgets[#arg_5_0._difficulty_filter_widgets + 1] = UIWidget.init(var_5_25)
		end
	end

	local var_5_26 = arg_5_0._show_lobby_data_table
	local var_5_27 = 0
	local var_5_28 = var_0_0.create_lobby_filter_entry_func

	for iter_5_10, iter_5_11 in ipairs(var_5_26) do
		var_5_27 = var_5_27 - var_5_7.filter_height - var_5_7.spacing

		local var_5_29 = var_5_28(iter_5_11, var_5_27)

		arg_5_0._lobby_filter_widgets[#arg_5_0._lobby_filter_widgets + 1] = UIWidget.init(var_5_29)
	end

	local var_5_30 = arg_5_0._distance_data_table
	local var_5_31 = 0
	local var_5_32 = var_0_0.create_distance_filter_entry_func

	for iter_5_12, iter_5_13 in ipairs(var_5_30) do
		var_5_31 = var_5_31 - var_5_7.filter_height - var_5_7.spacing

		local var_5_33 = var_5_32(iter_5_13, var_5_31)

		arg_5_0._distance_filter_widgets[#arg_5_0._distance_filter_widgets + 1] = UIWidget.init(var_5_33)
	end

	local var_5_34 = arg_5_0._widgets.filter_frame.content

	var_5_34.filter_hotspot_1.disable_button = #arg_5_0._game_type_filter_widgets < 2
	var_5_34.filter_hotspot_2.disable_button = #arg_5_0._level_filter_widgets < 2
	var_5_34.filter_hotspot_3.disable_button = #arg_5_0._difficulty_filter_widgets < 2
	var_5_34.filter_hotspot_4.disable_button = #arg_5_0._lobby_filter_widgets < 2
	var_5_34.filter_hotspot_5.disable_button = #arg_5_0._distance_filter_widgets < 2
end

LobbyBrowserConsoleUI.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0:_update_info_text(arg_7_1, arg_7_2, arg_7_3)
	arg_7_0:_handle_input(arg_7_1, arg_7_2, arg_7_3)
	arg_7_0:_handle_mouse_input(arg_7_1, arg_7_2, arg_7_3)
	arg_7_0:_handle_input_description(arg_7_1, arg_7_2)
	arg_7_0:_update_animations(arg_7_1, arg_7_2)
	arg_7_0:_update_lobby_data(arg_7_1, arg_7_2)
	arg_7_0:_draw(arg_7_1, arg_7_2)
end

LobbyBrowserConsoleUI._update_info_text = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._widgets.frame.content

	if arg_8_3 then
		var_8_0.info_text_id, arg_8_0._dot_timer = Localize("start_game_window_lobby_searching") .. string.rep(".", arg_8_0._dot_timer % 4), arg_8_0._dot_timer + arg_8_1 * 5
	else
		arg_8_0._dot_timer = 0
		var_8_0.info_text_id = Localize("start_game_window_lobbies_found") .. ": " .. arg_8_0._num_lobbies
	end
end

LobbyBrowserConsoleUI._update_animations = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_0._ui_animator:update(arg_9_1)

	local var_9_0 = arg_9_0._ui_animations

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		UIAnimation.update(iter_9_1, arg_9_1)

		if UIAnimation.completed(iter_9_1) then
			var_9_0[iter_9_0] = nil
		end
	end

	UIWidgetUtils.animate_default_button(arg_9_0._widgets.join_button, arg_9_1)
	UIWidgetUtils.animate_default_button(arg_9_0._widgets.refresh_button, arg_9_1)
end

local var_0_9 = {}
local var_0_10 = {}

LobbyBrowserConsoleUI._remove_invalid_lobbies = function (arg_10_0, arg_10_1)
	table.clear(var_0_9)
	table.clear(var_0_10)

	local var_10_0 = #arg_10_1
	local var_10_1 = NetworkLookup.mission_ids
	local var_10_2 = false

	for iter_10_0 = 1, var_10_0 do
		local var_10_3 = false
		local var_10_4 = arg_10_1[iter_10_0]

		if var_10_4 then
			local var_10_5 = var_10_4.selected_mission_id

			var_10_3 = var_10_5 and var_10_1[var_10_5] == nil or var_10_3

			local var_10_6 = var_10_4.mission_id

			var_10_3 = var_10_6 and var_10_1[var_10_6] == nil or var_10_3

			if not var_10_3 then
				var_0_9[#var_0_9 + 1] = var_10_4
				var_0_10[var_10_4.id] = var_10_4
			end
		end
	end

	return var_0_9, var_0_10
end

LobbyBrowserConsoleUI.populate_lobby_list = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._widgets.frame.content.timer = 0

	local var_11_0, var_11_1 = arg_11_0:_remove_invalid_lobbies(arg_11_1)
	local var_11_2 = var_0_0.element_settings
	local var_11_3 = 0
	local var_11_4 = arg_11_0._lobby_entry_widgets

	table.clear(var_11_4)

	local var_11_5 = var_0_0.create_lobby_entry_func

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		local var_11_6, var_11_7 = arg_11_0._parent:is_lobby_joinable(iter_11_1)

		var_11_3 = var_11_3 - var_11_2.height - var_11_2.spacing

		local var_11_8 = arg_11_0._parent:completed_level_difficulty_index(iter_11_1)
		local var_11_9 = var_11_5(var_11_3, iter_11_1, #var_11_4 + 1, var_11_6, var_11_8)
		local var_11_10 = UIWidget.init(var_11_9)

		var_11_4[#var_11_4 + 1] = var_11_10
	end

	arg_11_0._lobbies = var_11_0
	arg_11_0._num_lobbies = #var_11_4

	arg_11_0:_select_lobby(nil, arg_11_0._selected_lobby_index)

	local var_11_11 = arg_11_0._widgets.frame
	local var_11_12 = var_11_11.content
	local var_11_13 = var_11_11.style

	var_11_12.show_scroller = false
	arg_11_0._empty_lobby_entry_widgets = arg_11_0._empty_lobby_entry_widgets or {}

	local var_11_14 = arg_11_0._empty_lobby_entry_widgets

	table.clear(var_11_14)

	if arg_11_0._num_lobbies < var_11_2.num_visible_entries then
		local var_11_15 = var_11_2.num_visible_entries - arg_11_0._num_lobbies
		local var_11_16 = var_0_0.create_empty_lobby_entry_func

		for iter_11_2 = 1, var_11_15 do
			var_11_3 = var_11_3 - var_11_2.height - var_11_2.spacing

			local var_11_17 = var_11_16(var_11_3)
			local var_11_18 = UIWidget.init(var_11_17)

			var_11_14[#var_11_14 + 1] = var_11_18
		end
	elseif arg_11_0._num_lobbies > var_11_2.num_visible_entries then
		var_11_12.show_scroller = true
		var_11_13.scroller.texture_size[2] = math.min(-(var_11_2.window_height / (arg_11_0._num_lobbies / var_11_2.num_visible_entries)), -30)

		local var_11_19 = var_11_13.inner_scroller

		var_11_19.texture_size[2] = math.min(-(var_11_2.window_height / (arg_11_0._num_lobbies / var_11_2.num_visible_entries)), -30) + 4
		var_11_13.inner_scroller_hotspot.area_size[2] = -var_11_19.texture_size[2]
	end
end

LobbyBrowserConsoleUI._handle_input_description = function (arg_12_0, arg_12_1, arg_12_2)
	if arg_12_0._filter_active then
		arg_12_0._parent:set_input_description("set_filter")
	elseif arg_12_0._selected_lobby_index then
		local var_12_0 = arg_12_0._lobbies[arg_12_0._selected_lobby_index]

		if var_12_0 then
			local var_12_1, var_12_2 = arg_12_0._parent:is_lobby_joinable(var_12_0)

			if var_12_1 then
				arg_12_0._parent:set_input_description("join_filter")
			else
				arg_12_0._parent:set_input_description("filter")
			end
		else
			arg_12_0._parent:set_input_description("filter")
		end
	else
		arg_12_0._parent:set_input_description("filter")
	end
end

LobbyBrowserConsoleUI._handle_input = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if Managers.input:is_device_active("mouse") then
		return
	end

	local var_13_0 = arg_13_0._input_manager
	local var_13_1 = arg_13_0._parent:input_service()

	arg_13_0:_verify_selected_lobby_index()

	local var_13_2 = var_0_0.element_settings

	if arg_13_0._filter_active then
		if arg_13_0._current_active_filter then
			arg_13_0[arg_13_0._filter_functions[arg_13_0._current_active_filter].input_function](arg_13_0, var_13_1, var_13_2, arg_13_1, arg_13_2)
		else
			arg_13_0:_handle_filter_input(var_13_1, var_13_2, arg_13_1, arg_13_2)
		end
	else
		arg_13_0:_handle_browser_input(var_13_1, var_13_2, arg_13_1, arg_13_2)
	end
end

LobbyBrowserConsoleUI._handle_mouse_input = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local var_14_0 = arg_14_0._input_manager
	local var_14_1 = arg_14_0._parent:input_service()

	arg_14_0:_verify_selected_lobby_index()

	local var_14_2 = var_0_0.element_settings

	if arg_14_0._filter_active then
		if arg_14_0._current_active_filter then
			arg_14_0[arg_14_0._filter_functions[arg_14_0._current_active_filter].input_function_mouse](arg_14_0, var_14_1, var_14_2, arg_14_1, arg_14_2)
		else
			arg_14_0._widgets.frame.content.filter_active = false
			arg_14_0._filter_active = false
			arg_14_0._current_active_filter = false
			arg_14_0._current_filter_index = 1
			arg_14_0._filter_list_index = nil

			local var_14_3 = arg_14_0._widgets.filter_frame.content

			var_14_3.filter_selection = false
			var_14_3.filter_index = arg_14_0._current_filter_index
		end
	else
		arg_14_0:_handle_browser_input_mouse(var_14_1, var_14_2, arg_14_1, arg_14_2)
	end
end

LobbyBrowserConsoleUI._verify_selected_lobby_index = function (arg_15_0)
	local var_15_0 = arg_15_0._selected_lobby_index

	arg_15_0._selected_lobby_index = math.clamp(arg_15_0._selected_lobby_index, 1, math.max(arg_15_0._num_lobbies, 1))

	if var_15_0 ~= arg_15_0._selected_lobby_index then
		local var_15_1 = var_0_0.element_settings
		local var_15_2 = var_15_1.num_visible_entries
		local var_15_3 = var_15_1.height + var_15_1.spacing

		arg_15_0._base_pos_y = arg_15_0._base_pos_y or var_0_1.lobby_entry_anchor.position[2]
		arg_15_0._visible_list_index = math.max(math.min(var_15_2, arg_15_0._num_lobbies), 1)

		local var_15_4 = arg_15_0._base_pos_y

		if var_15_2 < arg_15_0._selected_lobby_index then
			var_15_4 = arg_15_0._base_pos_y + arg_15_0._selected_lobby_index * var_15_3
		end

		local var_15_5 = arg_15_0._base_pos_y
		local var_15_6 = arg_15_0._num_lobbies * var_15_3 - var_15_2 * var_15_3

		arg_15_0._wanted_pos = math.clamp(var_15_4, arg_15_0._base_pos_y, math.max(arg_15_0._num_lobbies * var_15_3 - var_15_2 * var_15_3, 0))
		arg_15_0._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, arg_15_0._ui_scenegraph.lobby_entry_anchor.position, 2, arg_15_0._ui_scenegraph.lobby_entry_anchor.position[2], arg_15_0._wanted_pos, 0.3, math.easeOutCubic)

		arg_15_0:_select_lobby(var_15_0, arg_15_0._selected_lobby_index, arg_15_0._mouse_selected_index)

		local var_15_7 = arg_15_0._widgets.frame.content
		local var_15_8 = arg_15_0._wanted_pos / (arg_15_0._num_lobbies * var_15_3 - var_15_2 * var_15_3)

		var_15_8 = arg_15_0:_is_nan_or_inf(var_15_8) and 0 or var_15_8
		arg_15_0._ui_animations.scrollbar = UIAnimation.init(UIAnimation.function_by_time, var_15_7, "scrollbar_progress", var_15_7.scrollbar_progress, var_15_8, 0.3, math.easeOutCubic)
	end
end

LobbyBrowserConsoleUI._handle_browser_input = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = 0
	local var_16_1 = 0
	local var_16_2 = arg_16_0._selected_lobby_index
	local var_16_3 = arg_16_2.num_visible_entries
	local var_16_4 = arg_16_2.height + arg_16_2.spacing

	arg_16_0._base_pos_y = arg_16_0._base_pos_y or var_0_1.lobby_entry_anchor.position[2]
	arg_16_0._wanted_pos = arg_16_0._wanted_pos or arg_16_0._base_pos_y

	if arg_16_1:get("right_stick_press") then
		arg_16_0._widgets.frame.content.filter_active = true
		arg_16_0._filter_active = true
		arg_16_0._current_active_filter = false
		arg_16_0._current_filter_index = 1
		arg_16_0._filter_list_index = nil

		local var_16_5 = arg_16_0._widgets.filter_frame.content

		var_16_5.filter_selection = true
		var_16_5.filter_index = arg_16_0._current_filter_index

		arg_16_0._parent:play_sound("Play_hud_hover")

		return
	end

	if arg_16_1:get("refresh") and arg_16_0._num_lobbies > 0 then
		local var_16_6 = arg_16_0._lobby_entry_widgets[arg_16_0._selected_lobby_index].content.lobby_data
		local var_16_7 = false

		if var_16_6 and arg_16_0._parent:is_lobby_joinable(var_16_6) then
			arg_16_0._parent:play_sound("hud_morris_start_menu_play")
			arg_16_0._parent:_join(var_16_6)
		end

		return
	elseif arg_16_1:get("special_1") then
		arg_16_0._parent:play_sound("hud_morris_start_menu_set")
		arg_16_0._parent:refresh()

		return
	elseif arg_16_1:get("left_stick_press") then
		arg_16_0._parent:play_sound("hud_morris_start_menu_set")
		arg_16_0._parent:reset_filters()

		return
	end

	if arg_16_1:get("move_up_hold") then
		var_16_1 = arg_16_0._hold_up_timer + arg_16_3
	elseif arg_16_1:get("move_down_hold") then
		var_16_0 = arg_16_0._hold_down_timer + arg_16_3
	end

	arg_16_0._hold_down_timer = var_16_0
	arg_16_0._hold_up_timer = var_16_1

	if arg_16_1:get("move_down") or arg_16_0._hold_down_timer > 0.5 then
		if arg_16_0._hold_down_timer > 0.5 then
			arg_16_0._hold_down_timer = 0.4
		end

		arg_16_0._selected_lobby_index = math.clamp(arg_16_0._selected_lobby_index + 1, 1, arg_16_0._num_lobbies)
		arg_16_0._visible_list_index = math.clamp(arg_16_0._visible_list_index + 1, 1, math.min(var_16_3, arg_16_0._num_lobbies))

		if arg_16_0._visible_list_index == var_16_3 then
			local var_16_8 = arg_16_0._wanted_pos

			arg_16_0._wanted_pos = math.clamp(arg_16_0._wanted_pos + var_16_4, arg_16_0._base_pos_y, arg_16_0._num_lobbies * var_16_4 - var_16_3 * var_16_4)
			arg_16_0._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, arg_16_0._ui_scenegraph.lobby_entry_anchor.position, 2, arg_16_0._ui_scenegraph.lobby_entry_anchor.position[2], arg_16_0._wanted_pos, 0.3, math.easeOutCubic)

			if arg_16_0._wanted_pos ~= var_16_8 then
				arg_16_0._visible_list_index = math.clamp(arg_16_0._visible_list_index - 1, 1, var_16_3)
			end
		end
	elseif arg_16_1:get("move_up") or arg_16_0._hold_up_timer > 0.5 then
		if arg_16_0._hold_up_timer > 0.5 then
			arg_16_0._hold_up_timer = 0.4
		end

		arg_16_0._selected_lobby_index = math.clamp(arg_16_0._selected_lobby_index - 1, 1, arg_16_0._num_lobbies)
		arg_16_0._visible_list_index = math.clamp(arg_16_0._visible_list_index - 1, 1, math.min(var_16_3, arg_16_0._num_lobbies))

		if arg_16_0._visible_list_index <= 1 and var_16_3 < arg_16_0._num_lobbies then
			local var_16_9 = arg_16_0._wanted_pos

			arg_16_0._wanted_pos = math.clamp(arg_16_0._wanted_pos - var_16_4, arg_16_0._base_pos_y, arg_16_0._num_lobbies * var_16_4 + var_16_4)
			arg_16_0._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, arg_16_0._ui_scenegraph.lobby_entry_anchor.position, 2, arg_16_0._ui_scenegraph.lobby_entry_anchor.position[2], arg_16_0._wanted_pos, 0.3, math.easeOutCubic)

			if arg_16_0._wanted_pos ~= var_16_9 then
				arg_16_0._visible_list_index = math.clamp(arg_16_0._visible_list_index + 1, 1, var_16_3)
			end
		end
	end

	if arg_16_0._selected_lobby_index ~= var_16_2 then
		arg_16_0:_select_lobby(var_16_2, arg_16_0._selected_lobby_index, arg_16_0._mouse_selected_index)

		local var_16_10 = arg_16_0._widgets.frame.content
		local var_16_11 = arg_16_0._wanted_pos / (arg_16_0._num_lobbies * var_16_4 - var_16_3 * var_16_4)

		var_16_11 = arg_16_0:_is_nan_or_inf(var_16_11) and 0 or var_16_11
		arg_16_0._ui_animations.scrollbar = UIAnimation.init(UIAnimation.function_by_time, var_16_10, "scrollbar_progress", var_16_10.scrollbar_progress, var_16_11, 0.3, math.easeOutCubic)
	end
end

LobbyBrowserConsoleUI._handle_filter_input_mouse = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	return
end

LobbyBrowserConsoleUI._handle_browser_input_mouse = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_0._mouse_selected_index
	local var_18_1 = arg_18_0._selected_lobby_index
	local var_18_2 = arg_18_2.num_visible_entries
	local var_18_3 = arg_18_2.height + arg_18_2.spacing

	arg_18_0._base_pos_y = arg_18_0._base_pos_y or var_0_1.lobby_entry_anchor.position[2]
	arg_18_0._wanted_pos = arg_18_0._wanted_pos or arg_18_0._base_pos_y

	local var_18_4 = arg_18_1:get("left_press")
	local var_18_5 = arg_18_0._widgets.filter_frame
	local var_18_6 = var_18_5.content

	for iter_18_0 = 1, #arg_18_0._filter_functions do
		local var_18_7 = var_18_6["filter_hotspot_" .. iter_18_0]

		if var_18_7.on_hover_enter then
			arg_18_0._parent:play_sound("Play_hud_hover")
		end

		if var_18_7.is_hover and var_18_4 then
			var_18_6.filter_active = true
			arg_18_0._filter_active = true
			arg_18_0._current_active_filter = iter_18_0
			arg_18_0._current_filter_index = iter_18_0
			arg_18_0._filter_list_index = nil
			arg_18_0._mouse_scroll_index = nil

			local var_18_8 = var_18_5.content

			var_18_8.filter_selection = true
			var_18_8.filter_index = arg_18_0._current_filter_index
			arg_18_0._widgets.frame.content.filter_active = true

			return
		end
	end

	if arg_18_1:get("left_press") then
		local var_18_9 = arg_18_0._lobby_entry_widgets

		for iter_18_1, iter_18_2 in ipairs(var_18_9) do
			if iter_18_2.content.lobby_hotspot.is_hover then
				arg_18_0:_select_lobby(var_18_0, iter_18_1, arg_18_0._selected_lobby_index)

				arg_18_0._mouse_selected_index = iter_18_1

				break
			end
		end
	elseif arg_18_0._widgets.join_button.content.button_hotspot.on_pressed then
		local var_18_10 = arg_18_0._lobby_entry_widgets[arg_18_0._mouse_selected_index]

		if var_18_10 then
			local var_18_11 = var_18_10.content.lobby_data
			local var_18_12 = false

			if var_18_11 and arg_18_0._parent:is_lobby_joinable(var_18_11) then
				arg_18_0._parent:_join(var_18_11)
			end
		end

		return
	elseif arg_18_0._widgets.refresh_button.content.button_hotspot.on_pressed then
		arg_18_0._parent:play_sound("hud_morris_start_menu_set")
		arg_18_0._parent:refresh()

		return
	end

	if var_18_2 < arg_18_0._num_lobbies then
		local var_18_13 = arg_18_0._widgets.frame

		if var_18_4 then
			if UIUtils.is_button_hover(var_18_13, "inner_scroller_hotspot") then
				arg_18_0:_calculate_input_offset(arg_18_2, arg_18_1)
			elseif UIUtils.is_button_hover(var_18_13, "scrollbar_hotspot") then
				arg_18_0:_update_scroller_position(var_18_3, var_18_2, arg_18_2, arg_18_1)

				return
			end
		elseif arg_18_1:get("left_hold") and arg_18_0._progress_diff then
			arg_18_0:_update_scroller_position(var_18_3, var_18_2, arg_18_2, arg_18_1)

			return
		else
			arg_18_0._progress_diff = nil
		end
	else
		arg_18_0._progress_diff = nil
	end

	local var_18_14 = arg_18_1:get("scroll_axis")[2]
	local var_18_15 = arg_18_0._widgets.frame

	if UIUtils.is_button_hover(var_18_15, "scroller_hotspot") then
		if var_18_14 < 0 then
			arg_18_0._selected_lobby_index = math.clamp(arg_18_0._selected_lobby_index + 1, 1, arg_18_0._num_lobbies)
			arg_18_0._visible_list_index = math.clamp(arg_18_0._visible_list_index + 1, 1, math.min(var_18_2, arg_18_0._num_lobbies))

			if var_18_2 < arg_18_0._num_lobbies then
				local var_18_16 = arg_18_0._wanted_pos

				arg_18_0._wanted_pos = math.clamp(arg_18_0._wanted_pos + var_18_3, arg_18_0._base_pos_y, arg_18_0._num_lobbies * var_18_3 - var_18_2 * var_18_3)

				if arg_18_0._wanted_pos ~= var_18_16 then
					arg_18_0._visible_list_index = math.clamp(arg_18_0._visible_list_index - 1, 1, var_18_2)
				end

				arg_18_0._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, arg_18_0._ui_scenegraph.lobby_entry_anchor.position, 2, arg_18_0._ui_scenegraph.lobby_entry_anchor.position[2], arg_18_0._wanted_pos, 0.3, math.easeOutCubic)
			end
		elseif var_18_14 > 0 then
			arg_18_0._selected_lobby_index = math.clamp(arg_18_0._selected_lobby_index - 1, 1, arg_18_0._num_lobbies)
			arg_18_0._visible_list_index = math.clamp(arg_18_0._visible_list_index - 1, 1, math.min(var_18_2, arg_18_0._num_lobbies))

			if var_18_2 < arg_18_0._num_lobbies then
				local var_18_17 = arg_18_0._wanted_pos

				arg_18_0._wanted_pos = math.clamp(arg_18_0._wanted_pos - var_18_3, arg_18_0._base_pos_y, arg_18_0._num_lobbies * var_18_3 + var_18_3)

				if arg_18_0._wanted_pos ~= var_18_17 then
					arg_18_0._visible_list_index = math.clamp(arg_18_0._visible_list_index + 1, 1, var_18_2)
				end

				arg_18_0._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, arg_18_0._ui_scenegraph.lobby_entry_anchor.position, 2, arg_18_0._ui_scenegraph.lobby_entry_anchor.position[2], arg_18_0._wanted_pos, 0.3, math.easeOutCubic)
			end
		end
	end

	if arg_18_0._selected_lobby_index ~= var_18_1 then
		local var_18_18 = arg_18_0._widgets.frame.content
		local var_18_19 = arg_18_0._wanted_pos / (arg_18_0._num_lobbies * var_18_3 - var_18_2 * var_18_3)

		var_18_19 = arg_18_0:_is_nan_or_inf(var_18_19) and 0 or var_18_19
		arg_18_0._ui_animations.scrollbar = UIAnimation.init(UIAnimation.function_by_time, var_18_18, "scrollbar_progress", var_18_18.scrollbar_progress, var_18_19, 0.3, math.easeOutCubic)
	end
end

LobbyBrowserConsoleUI._calculate_input_offset = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0._widgets.frame
	local var_19_1 = arg_19_0._ui_scenegraph.lobby_browser_frame.world_position[2] + var_19_0.style.inner_scroller.base_offset[2]
	local var_19_2 = var_19_1 - arg_19_1.window_height
	local var_19_3 = var_19_0.style.inner_scroller.texture_size[2]
	local var_19_4 = arg_19_2:get("cursor")
	local var_19_5 = UIInverseScaleVectorToResolution(var_19_4)[2]
	local var_19_6 = math.inv_lerp(var_19_1 + var_19_3 * 0.5, var_19_2 - var_19_3 * 0.5, var_19_5)

	arg_19_0._progress_diff = var_19_0.content.scrollbar_progress - var_19_6
end

LobbyBrowserConsoleUI._update_scroller_position = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = arg_20_0._widgets.frame
	local var_20_1 = arg_20_0._ui_scenegraph.lobby_browser_frame.world_position[2] + var_20_0.style.inner_scroller.base_offset[2]
	local var_20_2 = var_20_1 - arg_20_3.window_height
	local var_20_3 = var_20_0.style.inner_scroller.texture_size[2]
	local var_20_4 = arg_20_4:get("cursor")
	local var_20_5 = UIInverseScaleVectorToResolution(var_20_4)[2]
	local var_20_6 = math.inv_lerp(var_20_1 + var_20_3 * 0.5, var_20_2 - var_20_3 * 0.5, var_20_5)
	local var_20_7 = math.clamp(var_20_6 + (arg_20_0._progress_diff or 0), 0, 1)

	var_20_0.content.scrollbar_progress = var_20_7
	arg_20_0._ui_scenegraph.lobby_entry_anchor.position[2] = var_20_7 * (arg_20_0._num_lobbies * arg_20_1 - arg_20_2 * arg_20_1)
	arg_20_0._selected_lobby_index = math.clamp(math.round(var_20_7 * arg_20_0._num_lobbies), 1, arg_20_0._num_lobbies)
	arg_20_0._wanted_pos = math.clamp(arg_20_0._base_pos_y + arg_20_1 * arg_20_0._selected_lobby_index - 1, arg_20_0._base_pos_y, arg_20_0._num_lobbies * arg_20_1 - arg_20_2 * arg_20_1)
end

LobbyBrowserConsoleUI._is_nan_or_inf = function (arg_21_0, arg_21_1)
	return type(arg_21_1) ~= "number" or arg_21_1 ~= arg_21_1 or arg_21_1 == math.huge or arg_21_1 == -math.huge
end

LobbyBrowserConsoleUI._handle_filter_input = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = Managers.input:is_device_active("gamepad")

	if arg_22_1:get("right_stick_press") or arg_22_1:get("back_menu", true) then
		arg_22_0._widgets.frame.content.filter_active = false
		arg_22_0._filter_active = false
		arg_22_0._current_active_filter = false
		arg_22_0._current_filter_index = 1
		arg_22_0._filter_list_index = nil

		local var_22_1 = arg_22_0._widgets.filter_frame.content

		var_22_1.filter_selection = false
		var_22_1.filter_index = arg_22_0._current_filter_index

		return
	end

	local var_22_2 = arg_22_0._current_filter_index

	if arg_22_1:get("confirm") then
		arg_22_0._widgets.filter_frame.content.filter_selection = false
		arg_22_0._current_active_filter = arg_22_0._current_filter_index

		arg_22_0._parent:play_sound("Play_hud_hover")

		return
	elseif arg_22_1:get("move_left") then
		var_22_2 = arg_22_0:_update_filter_index(-1)
	elseif arg_22_1:get("move_right") then
		var_22_2 = arg_22_0:_update_filter_index(1)
	end

	if arg_22_0._current_filter_index ~= var_22_2 then
		arg_22_0._current_filter_index = var_22_2

		arg_22_0._parent:play_sound("Play_hud_hover")

		arg_22_0._filter_list_index = nil
		arg_22_0._widgets.filter_frame.content.filter_index = var_22_2
	end
end

LobbyBrowserConsoleUI._update_filter_index = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._widgets.filter_frame.content
	local var_23_1 = math.clamp(arg_23_0._current_filter_index + arg_23_1, 1, #arg_23_0._filter_functions)
	local var_23_2 = arg_23_1 > 0 and #arg_23_0._filter_functions or 1

	for iter_23_0 = var_23_1, var_23_2, arg_23_1 do
		if not var_23_0["filter_hotspot_" .. iter_23_0].disable_button then
			return iter_23_0
		end
	end

	return arg_23_0._current_filter_index
end

LobbyBrowserConsoleUI._handle_game_type_filter_input = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_0._filter_list_index

	arg_24_0._filter_list_index = arg_24_0._filter_list_index or 1

	local var_24_1 = 0
	local var_24_2 = 0
	local var_24_3 = #arg_24_0._game_type_filter_widgets
	local var_24_4 = arg_24_1:get("back_menu", true)

	if arg_24_1:get("confirm") or var_24_4 then
		local var_24_5 = arg_24_0._filter_list_index
		local var_24_6 = arg_24_0._game_type_filter_widgets[var_24_5].content

		var_24_6.selected = false
		arg_24_0._filter_list_index = nil
		arg_24_0._visible_list_index = 1
		arg_24_0._hold_up_list_timer = 0
		arg_24_0._hold_down_list_timer = 0

		if not var_24_4 then
			arg_24_0._parent:play_sound("hud_morris_start_menu_set")
			arg_24_0._parent:set_game_mode(var_24_6.game_type)
			arg_24_0._parent:refresh()
		end

		arg_24_0._current_active_filter = nil
		arg_24_0._widgets.filter_frame.content.filter_selection = true

		return
	end

	if arg_24_1:get("move_up_hold") then
		var_24_2 = arg_24_0._hold_up_list_timer + arg_24_3
	elseif arg_24_1:get("move_down_hold") then
		var_24_1 = arg_24_0._hold_down_list_timer + arg_24_3
	end

	arg_24_0._hold_down_list_timer = var_24_1
	arg_24_0._hold_up_list_timer = var_24_2

	if arg_24_1:get("move_down") or arg_24_0._hold_down_list_timer > 0.5 then
		if arg_24_0._hold_down_list_timer > 0.5 then
			arg_24_0._hold_down_list_timer = 0.4
		end

		arg_24_0._filter_list_index = math.clamp(arg_24_0._filter_list_index + 1, 1, var_24_3)
	elseif arg_24_1:get("move_up") or arg_24_0._hold_up_list_timer > 0.5 then
		if arg_24_0._hold_up_list_timer > 0.5 then
			arg_24_0._hold_up_list_timer = 0.4
		end

		arg_24_0._filter_list_index = math.clamp(arg_24_0._filter_list_index - 1, 1, var_24_3)
	end

	if arg_24_0._filter_list_index ~= var_24_0 then
		arg_24_0._game_type_filter_widgets[arg_24_0._filter_list_index].content.selected = true

		if var_24_0 then
			arg_24_0._game_type_filter_widgets[var_24_0].content.selected = false
		end

		arg_24_0._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_game_type_filter_input_mouse = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = arg_25_2.window_height + arg_25_2.filter_height
	local var_25_1 = math.ceil(var_25_0 / (arg_25_2.filter_height + arg_25_2.spacing))
	local var_25_2 = arg_25_2.filter_height + arg_25_2.spacing

	arg_25_0._list_base_pos_y = arg_25_0._list_base_pos_y or var_0_1.filter_game_type_entry_anchor.position[2]

	local var_25_3 = #arg_25_0._game_type_filter_widgets

	arg_25_0._mouse_scroll_index = arg_25_0._mouse_scroll_index or 1

	local var_25_4 = false
	local var_25_5 = arg_25_1:get("back_menu", true)

	if arg_25_1:get("left_press") then
		for iter_25_0, iter_25_1 in ipairs(arg_25_0._game_type_filter_widgets) do
			if iter_25_1.content.button_hotspot.is_hover then
				var_25_4 = true

				arg_25_0._parent:play_sound("hud_morris_start_menu_set")
				arg_25_0._parent:set_game_mode(iter_25_1.content.game_type)
				arg_25_0._parent:refresh()

				var_25_5 = true

				break
			end
		end

		var_25_5 = var_25_5 or not var_25_4
	end

	if var_25_5 then
		arg_25_0._filter_list_index = nil
		arg_25_0._wanted_list_pos = arg_25_0._list_base_pos_y
		arg_25_0._visible_list_index = 1
		arg_25_0._hold_up_list_timer = 0
		arg_25_0._hold_down_list_timer = 0
		arg_25_0._ui_scenegraph.filter_game_type_entry_anchor.position[2] = arg_25_0._list_base_pos_y
		arg_25_0._current_active_filter = nil
		arg_25_0._widgets.filter_frame.content.filter_selection = true

		return
	end
end

LobbyBrowserConsoleUI._handle_level_filter_input = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = 0
	local var_26_1 = 0
	local var_26_2 = arg_26_0._filter_list_index

	arg_26_0._filter_list_index = arg_26_0._filter_list_index or 1

	local var_26_3 = arg_26_2.window_height + arg_26_2.filter_height
	local var_26_4 = math.ceil(var_26_3 / (arg_26_2.filter_height + arg_26_2.spacing))
	local var_26_5 = arg_26_2.filter_height + arg_26_2.spacing

	arg_26_0._list_base_pos_y = arg_26_0._list_base_pos_y or var_0_1.filter_level_entry_anchor.position[2]
	arg_26_0._wanted_list_pos = arg_26_0._wanted_list_pos or arg_26_0._list_base_pos_y

	local var_26_6 = #arg_26_0._level_filter_widgets
	local var_26_7 = arg_26_1:get("confirm")
	local var_26_8 = arg_26_1:get("back_menu", true)

	if var_26_7 or var_26_8 then
		local var_26_9 = arg_26_0._filter_list_index

		if arg_26_0._level_filter_widgets[var_26_9].content.unlocked or var_26_8 then
			local var_26_10 = arg_26_0._level_filter_widgets[arg_26_0._filter_list_index].content

			var_26_10.selected = false
			arg_26_0._filter_list_index = nil
			arg_26_0._wanted_list_pos = arg_26_0._list_base_pos_y
			arg_26_0._visible_list_index = 1
			arg_26_0._hold_up_list_timer = 0
			arg_26_0._hold_down_list_timer = 0
			arg_26_0._ui_scenegraph.filter_level_entry_anchor.position[2] = arg_26_0._list_base_pos_y

			if not var_26_8 then
				arg_26_0._parent:play_sound("hud_morris_start_menu_set")
				arg_26_0._parent:set_level(var_26_10.level)
				arg_26_0._parent:refresh()
			end

			arg_26_0._current_active_filter = nil
			arg_26_0._widgets.filter_frame.content.filter_selection = true

			return
		end
	end

	for iter_26_0 = 1, #arg_26_0._level_filter_widgets do
		if UIUtils.is_button_hover_enter(arg_26_0._level_filter_widgets[iter_26_0]) then
			arg_26_0._parent:play_sound("Play_hud_hover")

			break
		end
	end

	if arg_26_1:get("move_up_hold") then
		var_26_1 = arg_26_0._hold_up_list_timer + arg_26_3
	elseif arg_26_1:get("move_down_hold") then
		var_26_0 = arg_26_0._hold_down_list_timer + arg_26_3
	end

	arg_26_0._hold_down_list_timer = var_26_0
	arg_26_0._hold_up_list_timer = var_26_1

	if arg_26_1:get("move_down") or arg_26_0._hold_down_list_timer > 0.5 then
		if arg_26_0._hold_down_list_timer > 0.5 then
			arg_26_0._hold_down_list_timer = 0.4
		end

		arg_26_0._filter_list_index = math.clamp(arg_26_0._filter_list_index + 1, 1, var_26_6)
		arg_26_0._visible_list_index = math.clamp(arg_26_0._visible_list_index + 1, 1, math.min(var_26_4, var_26_6))

		if arg_26_0._visible_list_index == var_26_4 then
			local var_26_11 = arg_26_0._wanted_list_pos

			if var_26_6 >= arg_26_0._filter_list_index then
				arg_26_0._wanted_list_pos = math.clamp(arg_26_0._wanted_list_pos + var_26_5, arg_26_0._list_base_pos_y, var_26_6 * var_26_5 - var_26_4 * var_26_5)
				arg_26_0._ui_animations.move_list = UIAnimation.init(UIAnimation.function_by_time, arg_26_0._ui_scenegraph.filter_level_entry_anchor.position, 2, arg_26_0._ui_scenegraph.filter_level_entry_anchor.position[2], arg_26_0._wanted_list_pos, 0.3, math.easeOutCubic)
			end

			if arg_26_0._wanted_list_pos ~= var_26_11 then
				arg_26_0._visible_list_index = math.clamp(arg_26_0._visible_list_index - 1, 1, var_26_4)
			end
		end
	elseif arg_26_1:get("move_up") or arg_26_0._hold_up_list_timer > 0.5 then
		if arg_26_0._hold_up_list_timer > 0.5 then
			arg_26_0._hold_up_list_timer = 0.4
		end

		arg_26_0._filter_list_index = math.clamp(arg_26_0._filter_list_index - 1, 1, var_26_6)
		arg_26_0._visible_list_index = math.clamp(arg_26_0._visible_list_index - 1, 1, math.min(var_26_4, var_26_6))

		if arg_26_0._visible_list_index <= 1 and var_26_4 < var_26_6 then
			local var_26_12 = arg_26_0._wanted_list_pos

			arg_26_0._wanted_list_pos = math.clamp(arg_26_0._wanted_list_pos - var_26_5, arg_26_0._list_base_pos_y, arg_26_0._num_lobbies * var_26_5 + var_26_5)
			arg_26_0._ui_animations.move_list = UIAnimation.init(UIAnimation.function_by_time, arg_26_0._ui_scenegraph.filter_level_entry_anchor.position, 2, arg_26_0._ui_scenegraph.filter_level_entry_anchor.position[2], arg_26_0._wanted_list_pos, 0.3, math.easeOutCubic)

			if arg_26_0._wanted_list_pos ~= var_26_12 then
				arg_26_0._visible_list_index = math.clamp(arg_26_0._visible_list_index + 1, 1, var_26_4)
			end
		end
	end

	if arg_26_0._filter_list_index ~= var_26_2 then
		arg_26_0._level_filter_widgets[arg_26_0._filter_list_index].content.selected = true

		if var_26_2 then
			arg_26_0._level_filter_widgets[var_26_2].content.selected = false
		end

		local var_26_13 = arg_26_0._level_filter_scroller.content
		local var_26_14 = (arg_26_0._wanted_list_pos - arg_26_0._list_base_pos_y) / (var_26_6 * var_26_5 - var_26_4 * var_26_5 + var_26_5)

		var_26_14 = arg_26_0:_is_nan_or_inf(var_26_14) and 0 or var_26_14
		arg_26_0._ui_animations.list_scrollbar = UIAnimation.init(UIAnimation.function_by_time, var_26_13, "scrollbar_progress", var_26_13.scrollbar_progress, var_26_14, 0.3, math.easeOutCubic)

		arg_26_0._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_level_filter_input_mouse = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = arg_27_2.window_height + arg_27_2.filter_height
	local var_27_1 = math.ceil(var_27_0 / (arg_27_2.filter_height + arg_27_2.spacing))
	local var_27_2 = arg_27_2.filter_height + arg_27_2.spacing

	arg_27_0._list_base_pos_y = arg_27_0._list_base_pos_y or var_0_1.filter_level_entry_anchor.position[2]

	local var_27_3 = #arg_27_0._level_filter_widgets

	arg_27_0._mouse_scroll_index = arg_27_0._mouse_scroll_index or 1

	local var_27_4 = arg_27_0._level_filter_scroller
	local var_27_5 = var_27_4.content
	local var_27_6 = var_27_4.style
	local var_27_7 = var_27_5.scroller_hotspot
	local var_27_8 = var_27_5.bar_hotspot
	local var_27_9 = false
	local var_27_10 = arg_27_1:get("back_menu", true)

	if arg_27_1:get("left_press") then
		for iter_27_0, iter_27_1 in ipairs(arg_27_0._level_filter_widgets) do
			if iter_27_1.content.button_hotspot.is_hover then
				var_27_9 = true

				if iter_27_1.content.unlocked then
					arg_27_0._parent:play_sound("hud_morris_start_menu_set")
					arg_27_0._parent:set_level(iter_27_1.content.level)
					arg_27_0._parent:refresh()

					var_27_10 = true

					break
				end
			end
		end

		var_27_9 = var_27_8.is_hover or var_27_9
		var_27_10 = var_27_10 or not var_27_9
	end

	if var_27_10 then
		arg_27_0._filter_list_index = nil
		arg_27_0._wanted_list_pos = arg_27_0._list_base_pos_y
		arg_27_0._visible_list_index = 1
		arg_27_0._hold_up_list_timer = 0
		arg_27_0._hold_down_list_timer = 0
		arg_27_0._ui_scenegraph.filter_level_entry_anchor.position[2] = arg_27_0._list_base_pos_y
		arg_27_0._current_active_filter = nil
		arg_27_0._widgets.filter_frame.content.filter_selection = true
		arg_27_0._level_filter_scroller.content.scrollbar_progress = 0

		return
	end

	if var_27_7.on_pressed then
		arg_27_0._old_mouse_y = arg_27_1:get("cursor")[2]
	elseif var_27_7.is_held then
		local var_27_11 = (var_27_3 - var_27_1 - 3) * arg_27_2.filter_height
		local var_27_12 = arg_27_1:get("cursor")[2]
		local var_27_13 = var_27_12 - arg_27_0._old_mouse_y
		local var_27_14 = var_27_11 > 0 and var_27_13 / var_27_11 or 0
		local var_27_15 = math.clamp(var_27_5.scrollbar_progress - var_27_14, 0, 1)

		var_27_5.scrollbar_progress = var_27_15

		local var_27_16 = arg_27_0._list_base_pos_y + (var_27_3 - var_27_1 + 1) * var_27_15 * var_27_2

		arg_27_0._ui_scenegraph.filter_level_entry_anchor.position[2] = var_27_16
		arg_27_0._mouse_scroll_index = math.floor((var_27_3 - var_27_1 + 1) * var_27_15)
		arg_27_0._old_mouse_y = var_27_12
	elseif var_27_1 < var_27_3 then
		local var_27_17 = arg_27_1:get("scroll_axis")[2]

		if math.abs(var_27_17) > 0 then
			arg_27_0._mouse_scroll_index = math.clamp(arg_27_0._mouse_scroll_index - math.sign(var_27_17), 1, var_27_3 - var_27_1 + 2)

			local var_27_18 = arg_27_0._mouse_scroll_index - 1
			local var_27_19 = arg_27_0._list_base_pos_y + var_27_18 * var_27_2

			arg_27_0._ui_animations.move_list = UIAnimation.init(UIAnimation.function_by_time, arg_27_0._ui_scenegraph.filter_level_entry_anchor.position, 2, arg_27_0._ui_scenegraph.filter_level_entry_anchor.position[2], var_27_19, 0.3, math.easeOutCubic)

			local var_27_20 = arg_27_0._level_filter_scroller.content
			local var_27_21 = var_27_18 / (var_27_3 - var_27_1 + 1)

			var_27_21 = arg_27_0:_is_nan_or_inf(var_27_21) and 0 or var_27_21
			arg_27_0._ui_animations.list_scrollbar = UIAnimation.init(UIAnimation.function_by_time, var_27_20, "scrollbar_progress", var_27_20.scrollbar_progress, var_27_21, 0.3, math.easeOutCubic)
		end
	end
end

LobbyBrowserConsoleUI._handle_difficulty_filter_input = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = arg_28_0._filter_list_index

	arg_28_0._filter_list_index = arg_28_0._filter_list_index or 1

	local var_28_1 = 0
	local var_28_2 = 0
	local var_28_3 = #arg_28_0._difficulty_filter_widgets
	local var_28_4 = arg_28_1:get("back_menu", true)

	if arg_28_1:get("confirm") or var_28_4 then
		local var_28_5 = arg_28_0._filter_list_index
		local var_28_6 = arg_28_0._difficulty_filter_widgets[var_28_5].content

		if var_28_6.unlocked or var_28_4 then
			var_28_6.selected = false
			arg_28_0._filter_list_index = nil
			arg_28_0._visible_list_index = 1
			arg_28_0._hold_up_list_timer = 0
			arg_28_0._hold_down_list_timer = 0

			if not var_28_4 then
				arg_28_0._parent:play_sound("hud_morris_start_menu_set")
				arg_28_0._parent:set_difficulty(var_28_6.difficulty)
				arg_28_0._parent:refresh()
			end

			arg_28_0._current_active_filter = nil
			arg_28_0._widgets.filter_frame.content.filter_selection = true

			return
		end
	end

	if arg_28_1:get("move_up_hold") then
		var_28_2 = arg_28_0._hold_up_list_timer + arg_28_3
	elseif arg_28_1:get("move_down_hold") then
		var_28_1 = arg_28_0._hold_down_list_timer + arg_28_3
	end

	arg_28_0._hold_down_list_timer = var_28_1
	arg_28_0._hold_up_list_timer = var_28_2

	if arg_28_1:get("move_down") or arg_28_0._hold_down_list_timer > 0.5 then
		if arg_28_0._hold_down_list_timer > 0.5 then
			arg_28_0._hold_down_list_timer = 0.4
		end

		arg_28_0._filter_list_index = math.clamp(arg_28_0._filter_list_index + 1, 1, var_28_3)
	elseif arg_28_1:get("move_up") or arg_28_0._hold_up_list_timer > 0.5 then
		if arg_28_0._hold_up_list_timer > 0.5 then
			arg_28_0._hold_up_list_timer = 0.4
		end

		arg_28_0._filter_list_index = math.clamp(arg_28_0._filter_list_index - 1, 1, var_28_3)
	end

	if arg_28_0._filter_list_index ~= var_28_0 then
		arg_28_0._difficulty_filter_widgets[arg_28_0._filter_list_index].content.selected = true

		if var_28_0 then
			arg_28_0._difficulty_filter_widgets[var_28_0].content.selected = false
		end

		arg_28_0._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_difficulty_filter_input_mouse = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	local var_29_0 = arg_29_2.window_height + arg_29_2.filter_height
	local var_29_1 = math.ceil(var_29_0 / (arg_29_2.filter_height + arg_29_2.spacing))
	local var_29_2 = arg_29_2.filter_height + arg_29_2.spacing

	arg_29_0._list_base_pos_y = arg_29_0._list_base_pos_y or var_0_1.filter_difficulty_entry_anchor.position[2]

	local var_29_3 = #arg_29_0._difficulty_filter_widgets

	arg_29_0._mouse_scroll_index = arg_29_0._mouse_scroll_index or 1

	local var_29_4 = false
	local var_29_5 = arg_29_1:get("back_menu", true)

	if arg_29_1:get("left_press") then
		for iter_29_0, iter_29_1 in ipairs(arg_29_0._difficulty_filter_widgets) do
			if iter_29_1.content.button_hotspot.is_hover then
				var_29_4 = true

				if iter_29_1.content.unlocked then
					arg_29_0._parent:play_sound("hud_morris_start_menu_set")
					arg_29_0._parent:set_difficulty(iter_29_1.content.difficulty)
					arg_29_0._parent:refresh()

					var_29_5 = true

					break
				end
			end
		end

		var_29_5 = var_29_5 or not var_29_4
	end

	if var_29_5 then
		arg_29_0._filter_list_index = nil
		arg_29_0._wanted_list_pos = arg_29_0._list_base_pos_y
		arg_29_0._visible_list_index = 1
		arg_29_0._hold_up_list_timer = 0
		arg_29_0._hold_down_list_timer = 0
		arg_29_0._ui_scenegraph.filter_difficulty_entry_anchor.position[2] = arg_29_0._list_base_pos_y
		arg_29_0._current_active_filter = nil
		arg_29_0._widgets.filter_frame.content.filter_selection = true

		return
	end
end

LobbyBrowserConsoleUI._handle_lobby_filter_input = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	local var_30_0 = arg_30_0._filter_list_index

	arg_30_0._filter_list_index = arg_30_0._filter_list_index or 1

	local var_30_1 = 0
	local var_30_2 = 0
	local var_30_3 = #arg_30_0._lobby_filter_widgets
	local var_30_4 = arg_30_1:get("back_menu", true)

	if arg_30_1:get("confirm") or var_30_4 then
		local var_30_5 = arg_30_0._filter_list_index
		local var_30_6 = arg_30_0._lobby_filter_widgets[var_30_5].content

		var_30_6.selected = false
		arg_30_0._filter_list_index = nil
		arg_30_0._visible_list_index = 1
		arg_30_0._hold_up_list_timer = 0
		arg_30_0._hold_down_list_timer = 0

		if not var_30_4 then
			arg_30_0._parent:play_sound("hud_morris_start_menu_set")
			arg_30_0._parent:set_lobby_filter(var_30_6.lobby_filter)
			arg_30_0._parent:refresh()
		end

		arg_30_0._current_active_filter = nil
		arg_30_0._widgets.filter_frame.content.filter_selection = true

		return
	end

	if arg_30_1:get("move_up_hold") then
		var_30_2 = arg_30_0._hold_up_list_timer + arg_30_3
	elseif arg_30_1:get("move_down_hold") then
		var_30_1 = arg_30_0._hold_down_list_timer + arg_30_3
	end

	arg_30_0._hold_down_list_timer = var_30_1
	arg_30_0._hold_up_list_timer = var_30_2

	if arg_30_1:get("move_down") or arg_30_0._hold_down_list_timer > 0.5 then
		if arg_30_0._hold_down_list_timer > 0.5 then
			arg_30_0._hold_down_list_timer = 0.4
		end

		arg_30_0._filter_list_index = math.clamp(arg_30_0._filter_list_index + 1, 1, var_30_3)
	elseif arg_30_1:get("move_up") or arg_30_0._hold_up_list_timer > 0.5 then
		if arg_30_0._hold_up_list_timer > 0.5 then
			arg_30_0._hold_up_list_timer = 0.4
		end

		arg_30_0._filter_list_index = math.clamp(arg_30_0._filter_list_index - 1, 1, var_30_3)
	end

	if arg_30_0._filter_list_index ~= var_30_0 then
		arg_30_0._lobby_filter_widgets[arg_30_0._filter_list_index].content.selected = true

		if var_30_0 then
			arg_30_0._lobby_filter_widgets[var_30_0].content.selected = false
		end

		arg_30_0._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_lobby_filter_input_mouse = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	local var_31_0 = arg_31_2.window_height + arg_31_2.filter_height
	local var_31_1 = math.ceil(var_31_0 / (arg_31_2.filter_height + arg_31_2.spacing))
	local var_31_2 = arg_31_2.filter_height + arg_31_2.spacing

	arg_31_0._list_base_pos_y = arg_31_0._list_base_pos_y or var_0_1.filter_lobby_entry_anchor.position[2]

	local var_31_3 = #arg_31_0._lobby_filter_widgets

	arg_31_0._mouse_scroll_index = arg_31_0._mouse_scroll_index or 1

	local var_31_4 = false
	local var_31_5 = arg_31_1:get("back_menu", true)

	if arg_31_1:get("left_press") then
		for iter_31_0, iter_31_1 in ipairs(arg_31_0._lobby_filter_widgets) do
			if iter_31_1.content.button_hotspot.is_hover then
				arg_31_0._parent:play_sound("hud_morris_start_menu_set")
				arg_31_0._parent:set_lobby_filter(iter_31_1.content.lobby_filter)
				arg_31_0._parent:refresh()

				var_31_5 = true
				var_31_4 = true

				break
			end
		end

		var_31_5 = var_31_5 or not var_31_4
	end

	if var_31_5 then
		arg_31_0._filter_list_index = nil
		arg_31_0._wanted_list_pos = arg_31_0._list_base_pos_y
		arg_31_0._visible_list_index = 1
		arg_31_0._hold_up_list_timer = 0
		arg_31_0._hold_down_list_timer = 0
		arg_31_0._ui_scenegraph.filter_lobby_entry_anchor.position[2] = arg_31_0._list_base_pos_y
		arg_31_0._current_active_filter = nil
		arg_31_0._widgets.filter_frame.content.filter_selection = true

		return
	end
end

LobbyBrowserConsoleUI._handle_distance_filter_input = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	local var_32_0 = arg_32_0._filter_list_index

	arg_32_0._filter_list_index = arg_32_0._filter_list_index or 1

	local var_32_1 = 0
	local var_32_2 = 0
	local var_32_3 = #arg_32_0._distance_filter_widgets
	local var_32_4 = arg_32_1:get("back_menu", true)

	if arg_32_1:get("confirm") or var_32_4 then
		local var_32_5 = arg_32_0._filter_list_index
		local var_32_6 = arg_32_0._distance_filter_widgets[var_32_5].content

		var_32_6.selected = false
		arg_32_0._filter_list_index = nil
		arg_32_0._visible_list_index = 1
		arg_32_0._hold_up_list_timer = 0
		arg_32_0._hold_down_list_timer = 0

		if not var_32_4 then
			arg_32_0._parent:play_sound("hud_morris_start_menu_set")
			arg_32_0._parent:set_distance_filter(var_32_6.distance)
			arg_32_0._parent:refresh()
		end

		arg_32_0._current_active_filter = nil
		arg_32_0._widgets.filter_frame.content.filter_selection = true

		return
	end

	if arg_32_1:get("move_up_hold") then
		var_32_2 = arg_32_0._hold_up_list_timer + arg_32_3
	elseif arg_32_1:get("move_down_hold") then
		var_32_1 = arg_32_0._hold_down_list_timer + arg_32_3
	end

	arg_32_0._hold_down_list_timer = var_32_1
	arg_32_0._hold_up_list_timer = var_32_2

	if arg_32_1:get("move_down") or arg_32_0._hold_down_list_timer > 0.5 then
		if arg_32_0._hold_down_list_timer > 0.5 then
			arg_32_0._hold_down_list_timer = 0.4
		end

		arg_32_0._filter_list_index = math.clamp(arg_32_0._filter_list_index + 1, 1, var_32_3)
	elseif arg_32_1:get("move_up") or arg_32_0._hold_up_list_timer > 0.5 then
		if arg_32_0._hold_up_list_timer > 0.5 then
			arg_32_0._hold_up_list_timer = 0.4
		end

		arg_32_0._filter_list_index = math.clamp(arg_32_0._filter_list_index - 1, 1, var_32_3)
	end

	if arg_32_0._filter_list_index ~= var_32_0 then
		arg_32_0._distance_filter_widgets[arg_32_0._filter_list_index].content.selected = true

		if var_32_0 then
			arg_32_0._distance_filter_widgets[var_32_0].content.selected = false
		end

		arg_32_0._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_distance_filter_input_mouse = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	local var_33_0 = arg_33_2.window_height + arg_33_2.filter_height
	local var_33_1 = math.ceil(var_33_0 / (arg_33_2.filter_height + arg_33_2.spacing))
	local var_33_2 = arg_33_2.filter_height + arg_33_2.spacing

	arg_33_0._list_base_pos_y = arg_33_0._list_base_pos_y or var_0_1.filter_distance_entry_anchor.position[2]

	local var_33_3 = #arg_33_0._distance_filter_widgets

	arg_33_0._mouse_scroll_index = arg_33_0._mouse_scroll_index or 1

	local var_33_4 = false
	local var_33_5 = arg_33_1:get("back_menu", true)

	if arg_33_1:get("left_press") then
		for iter_33_0, iter_33_1 in ipairs(arg_33_0._distance_filter_widgets) do
			if iter_33_1.content.button_hotspot.is_hover then
				arg_33_0._parent:play_sound("hud_morris_start_menu_set")
				arg_33_0._parent:set_distance_filter(iter_33_1.content.distance)
				arg_33_0._parent:refresh()

				var_33_5 = true
				var_33_4 = true

				break
			end
		end

		var_33_5 = var_33_5 or not var_33_4
	end

	if var_33_5 then
		arg_33_0._filter_list_index = nil
		arg_33_0._wanted_list_pos = arg_33_0._list_base_pos_y
		arg_33_0._visible_list_index = 1
		arg_33_0._hold_up_list_timer = 0
		arg_33_0._hold_down_list_timer = 0
		arg_33_0._ui_scenegraph.filter_distance_entry_anchor.position[2] = arg_33_0._list_base_pos_y
		arg_33_0._current_active_filter = nil
		arg_33_0._widgets.filter_frame.content.filter_selection = true

		return
	end
end

LobbyBrowserConsoleUI._select_lobby = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	arg_34_0._details_filled = false

	if arg_34_0._scrollbar_ui then
		arg_34_0._scrollbar_ui:destroy(arg_34_0._ui_scenegraph)

		arg_34_0._scrollbar_ui = nil
	end

	local var_34_0 = arg_34_0._lobby_entry_widgets

	if arg_34_1 then
		local var_34_1 = var_34_0[arg_34_1]

		if var_34_1 then
			var_34_1.content.selected = false
		end
	end

	if arg_34_3 then
		local var_34_2 = var_34_0[arg_34_3]

		if var_34_2 then
			var_34_2.content.selected = false
		end
	end

	if arg_34_2 then
		local var_34_3 = var_34_0[arg_34_2]

		if var_34_3 then
			var_34_3.content.selected = true
		end
	end

	local var_34_4 = arg_34_0._lobby_entry_widgets[arg_34_2]
	local var_34_5 = var_34_4 and var_34_4.content
	local var_34_6 = var_34_5 and var_34_5.lobby_data

	arg_34_0._selected_lobby_id = var_34_6 and var_34_6.id

	local var_34_7 = arg_34_0._parent:get_lobbies()
	local var_34_8, var_34_9 = arg_34_0:_remove_invalid_lobbies(var_34_7)

	if var_34_9[arg_34_0._selected_lobby_id] then
		local var_34_10 = true

		arg_34_0:_update_lobby_details(var_34_9, var_34_10)
	end
end

LobbyBrowserConsoleUI._update_lobby_data = function (arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_0._parent:dirty() then
		return
	end

	local var_35_0 = arg_35_0._parent:get_lobbies()
	local var_35_1, var_35_2 = arg_35_0:_remove_invalid_lobbies(var_35_0)

	arg_35_0:_update_lobby_details(var_35_2)
	arg_35_0:_update_lobby_list(var_35_2, arg_35_1, arg_35_2)
end

LobbyBrowserConsoleUI._update_lobby_details = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0._selected_lobby_id

	if not var_36_0 then
		arg_36_0._details_filled = false
	end

	local var_36_1 = arg_36_1[var_36_0]

	if var_36_1 then
		local var_36_2 = var_36_1.mechanism
		local var_36_3 = var_36_1.selected_mission_id

		if var_36_2 == "weave" and WeaveSettings.templates[var_36_3] then
			arg_36_0:_fill_weave_details(var_36_1)
		elseif var_36_2 == "deus" and DeusJourneySettings[var_36_3] then
			arg_36_0:_fill_deus_details(var_36_1)
		elseif var_36_2 == "versus" then
			arg_36_0:_fill_versus_details(var_36_1, arg_36_2)
		else
			arg_36_0:_fill_details(var_36_1)
		end
	else
		arg_36_0._details_filled = false
	end
end

LobbyBrowserConsoleUI._update_lobby_list = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	for iter_37_0, iter_37_1 in ipairs(arg_37_0._lobby_entry_widgets) do
		local var_37_0 = iter_37_1.content
		local var_37_1 = var_37_0.lobby_data
		local var_37_2 = var_37_0.selected
		local var_37_3 = iter_37_1.offset[2]

		arg_37_0:_update_lobby_entry(iter_37_0, var_37_3, var_37_2, var_37_1, arg_37_1, arg_37_2, arg_37_3)
	end
end

LobbyBrowserConsoleUI._update_lobby_entry = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7)
	local var_38_0 = arg_38_5[arg_38_4 and arg_38_4.id]

	if var_38_0 then
		local var_38_1 = var_0_0.create_lobby_entry_func
		local var_38_2, var_38_3 = arg_38_0._parent:is_lobby_joinable(var_38_0)
		local var_38_4 = arg_38_0._parent:completed_level_difficulty_index(var_38_0)
		local var_38_5 = var_38_1(arg_38_2, var_38_0, arg_38_1, var_38_2, var_38_4)
		local var_38_6 = UIWidget.init(var_38_5)

		var_38_6.content.selected = arg_38_3
		arg_38_0._lobby_entry_widgets[arg_38_1] = var_38_6
	else
		local var_38_7 = var_0_0.create_unavailable_lobby_entry_func(arg_38_2)
		local var_38_8 = UIWidget.init(var_38_7)

		var_38_8.content.selected = arg_38_3
		arg_38_0._lobby_entry_widgets[arg_38_1] = var_38_8
	end
end

LobbyBrowserConsoleUI._fill_versus_details = function (arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0._details_widgets.versus
	local var_39_1 = arg_39_0._dynamic_details_widgets.versus
	local var_39_2 = "level_image_any"
	local var_39_3 = "random_level"
	local var_39_4 = arg_39_1 and (arg_39_1.selected_mission_id or arg_39_1.mission_id)
	local var_39_5 = arg_39_1 and arg_39_1.matchmaking_type
	local var_39_6 = var_39_5 and NetworkLookup.matchmaking_types[tonumber(var_39_5)]

	if var_39_4 and var_39_4 ~= "any" then
		local var_39_7 = var_39_4
		local var_39_8 = LevelSettings[var_39_7]

		var_39_3 = var_39_8.display_name or "lb_unknown"
		var_39_2 = var_39_8.level_image or var_39_2
	end

	local var_39_9 = var_39_0.level_image

	var_39_9.content.texture_id = var_39_2

	local var_39_10 = var_39_0.level_name

	var_39_10.content.text = Localize(var_39_3)

	local var_39_11 = var_39_0.level_image_frame.content

	var_39_11.texture_id = "map_frame_00"

	local var_39_12 = var_39_0.custom_level_image

	var_39_12.content.texture_id = var_39_2

	local var_39_13 = var_39_0.custom_level_name

	var_39_13.content.text = Localize(var_39_3)

	local var_39_14 = var_39_0.custom_level_image_frame.content

	var_39_14.texture_id = "map_frame_00"

	local var_39_15 = arg_39_0._widgets.join_button.content.button_hotspot
	local var_39_16 = var_39_0.locked_reason.content

	if arg_39_1 then
		local var_39_17, var_39_18 = arg_39_0._parent:is_lobby_joinable(arg_39_1)

		var_39_16.text = var_39_18 or "tutorial_no_text"
		var_39_15.disable_button = not var_39_17
	else
		var_39_16.text = "tutorial_no_text"
		var_39_15.disable_button = true
	end

	local var_39_19 = var_39_0.details_information.content

	if arg_39_1 then
		local var_39_20 = {
			custom = "map_host_setting",
			["n/a"] = "lb_game_type_none",
			standard = "lb_game_type_quick_play"
		}
		local var_39_21 = arg_39_1.mission_id
		local var_39_22 = LevelSettings[var_39_21]

		var_39_19.game_type_id = var_39_6 and var_39_20[var_39_6] or "lb_game_type_none"
		var_39_19.status_id = var_39_22.hub_level and "lb_in_inn" or "lb_playing"
	else
		var_39_19.game_type_id = "lb_unknown"
		var_39_19.status_id = "lb_unknown"
	end

	local var_39_23 = var_39_0.players
	local var_39_24 = true
	local var_39_25 = LobbyAux.deserialize_lobby_reservation_data(arg_39_1, var_39_24)

	for iter_39_0 = 1, 2 do
		local var_39_26 = var_39_25[iter_39_0]

		for iter_39_1 = 1, 4 do
			local var_39_27 = var_39_26 and var_39_26[iter_39_1]
			local var_39_28 = var_39_27 and var_39_27.peer_id
			local var_39_29 = "---"

			if var_39_28 then
				var_39_29 = PlayerUtils.player_name(var_39_28, nil)
				var_39_29 = UIRenderer.crop_text(var_39_29, 18)
			end

			local var_39_30 = string.format("player_%d_%d", iter_39_0, iter_39_1)

			var_39_23.content[var_39_30] = var_39_29

			local var_39_31 = var_39_28 and LobbyInternal.is_friend(var_39_28) and "pale_green" or "font_default"
			local var_39_32 = Colors.color_definitions[var_39_31]

			Colors.copy_no_alpha_to(var_39_23.style[var_39_30].text_color, var_39_32)
		end
	end

	if arg_39_2 then
		local var_39_33 = arg_39_1.custom_game_settings
		local var_39_34 = var_39_33 and var_39_33 ~= "n/a" or false

		table.clear(var_39_1)

		arg_39_0._scrollbar_ui = nil

		if var_39_34 then
			local var_39_35 = GameModeCustomSettingsHandlerUtility.parse_packed_custom_settings(var_39_33, "versus")
			local var_39_36 = 0

			for iter_39_2 = 1, #var_39_35 do
				local var_39_37 = var_39_35[iter_39_2]
				local var_39_38 = var_0_0.create_custom_setting_func(var_39_37.name, var_39_37.value, var_39_37.template, var_39_36)

				var_39_1[#var_39_1 + 1] = UIWidget.init(var_39_38)
				var_39_36 = var_39_36 - 30
			end

			local var_39_39 = "custom_settings_window"
			local var_39_40 = "custom_settings_anchor"
			local var_39_41 = arg_39_0._ui_scenegraph[var_39_39].size[2]
			local var_39_42 = math.abs(var_39_36) - var_39_41
			local var_39_43
			local var_39_44 = true

			if var_39_42 > 0 then
				arg_39_0._scrollbar_ui = ScrollbarUI:new(arg_39_0._ui_scenegraph, var_39_39, var_39_40, var_39_42, var_39_44, var_39_43)
			end

			var_39_9.content.visible = false
			var_39_10.content.visible = false
			var_39_11.visible = false
			var_39_12.content.visible = true
			var_39_13.content.visible = true
			var_39_14.visible = true
			arg_39_0._ui_scenegraph.details_players.position[2] = 180
			var_39_0.custom_settings.content.visible = true
			var_39_0.custom_settings_label.content.visible = true
			var_39_0.custom_settings_icon.content.visible = true
		else
			arg_39_0._ui_scenegraph.details_players.position[2] = 0
			var_39_9.content.visible = true
			var_39_10.content.visible = true
			var_39_11.visible = true
			var_39_12.content.visible = false
			var_39_13.content.visible = false
			var_39_14.visible = false
			var_39_0.custom_settings.content.visible = false
			var_39_0.custom_settings_label.content.visible = false
			var_39_0.custom_settings_icon.content.visible = false
		end
	end

	arg_39_0._details_type = "versus"
	arg_39_0._details_filled = true
end

LobbyBrowserConsoleUI._fill_details = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0._details_widgets.adventure
	local var_40_1 = "level_image_any"
	local var_40_2
	local var_40_3 = arg_40_1 and (arg_40_1.selected_mission_id or arg_40_1.mission_id)
	local var_40_4 = arg_40_1 and arg_40_1.matchmaking_type
	local var_40_5 = var_40_4 and (IS_PS4 and var_40_4 or NetworkLookup.matchmaking_types[tonumber(var_40_4)])
	local var_40_6 = arg_40_1 and arg_40_1.mechanism

	if var_40_3 then
		if var_40_3 == "default_start_level" then
			var_40_3 = LevelSettingsDefaultStartLevel
		end

		local var_40_7 = var_40_3

		if var_40_6 == "weave" then
			local var_40_8 = WeaveSettings.templates[var_40_3]

			if var_40_8 then
				var_40_7 = var_40_8.objectives[1].level_id
			end
		end

		local var_40_9 = LevelSettings[var_40_7]

		var_40_2 = var_40_9.display_name
		var_40_1 = var_40_9.level_image or var_40_1
	end

	var_40_0.level_image.content.texture_id = var_40_1
	var_40_0.level_name.content.text = var_40_2 and Localize(var_40_2) or " "

	local var_40_10 = {}

	if arg_40_1 then
		local var_40_11 = #SPProfiles

		for iter_40_0 = 1, var_40_11 do
			if not ProfileSynchronizer.is_free_in_lobby(iter_40_0, arg_40_1) then
				var_40_10[iter_40_0] = true
			end
		end
	end

	local var_40_12 = var_40_0.hero_tabs.content

	for iter_40_1 = 1, #ProfilePriority do
		local var_40_13 = ProfilePriority[iter_40_1]
		local var_40_14 = "_" .. tostring(iter_40_1)
		local var_40_15 = var_40_12["hotspot" .. var_40_14]

		if var_40_10[var_40_13] then
			var_40_15.disable_button = true
		else
			var_40_15.disable_button = false
		end
	end

	local var_40_16 = var_40_0.level_image_frame.content
	local var_40_17 = "map_frame_00"

	if arg_40_1 then
		local var_40_18 = arg_40_0._parent:completed_level_difficulty_index(arg_40_1)

		if var_40_18 > 0 then
			local var_40_19 = DefaultDifficulties[var_40_18]

			var_40_17 = DifficultySettings[var_40_19].completed_frame_texture
		end
	end

	var_40_16.texture_id = var_40_17

	local var_40_20 = arg_40_0._widgets.join_button.content.button_hotspot
	local var_40_21 = var_40_0.locked_reason.content

	if arg_40_1 then
		local var_40_22, var_40_23 = arg_40_0._parent:is_lobby_joinable(arg_40_1)

		var_40_21.text = var_40_23 or "tutorial_no_text"
		var_40_20.disable_button = not var_40_22
	else
		var_40_21.text = "tutorial_no_text"
		var_40_20.disable_button = true
	end

	local var_40_24 = var_40_0.details_information.content

	if arg_40_1 then
		local var_40_25 = {
			tutorial = "lb_game_type_prologue",
			deed = "lb_game_type_deed",
			weave = "lb_game_type_weave",
			event = "lb_game_type_event",
			deus_weekly = "cw_weekly_expedition_name_long",
			custom = "lb_game_type_custom",
			standard = "lb_game_type_quick_play",
			weave_quick_play = "lb_game_type_weave_quick_play",
			["n/a"] = "lb_game_type_none",
			deus = "area_selection_morris_name"
		}
		local var_40_26 = arg_40_1.mission_id
		local var_40_27 = var_40_26

		if var_40_6 == "weave" then
			local var_40_28 = WeaveSettings.templates[var_40_26]

			if var_40_28 then
				var_40_27 = var_40_28.objectives[1].level_id
			end

			if arg_40_1.weave_quick_game == "true" then
				var_40_5 = "weave_quick_play"
			else
				var_40_5 = "weave"
			end
		elseif var_40_6 == "deus" then
			var_40_5 = var_40_5 == "event" and "deus_weekly" or "deus"
		end

		local var_40_29 = LevelSettings[var_40_27]

		var_40_24.game_type_id = var_40_5 and (var_40_25[var_40_5] or "lb_unknown") or "lb_game_type_none"
		var_40_24.status_id = var_40_29.hub_level and "lb_in_inn" or "lb_playing"
	else
		var_40_24.game_type_id = "lb_unknown"
		var_40_24.status_id = "lb_unknown"
	end

	var_40_0.twitch_logo.content.visible = to_boolean(arg_40_1 and arg_40_1.twitch_enabled)
	arg_40_0._details_type = "adventure"
	arg_40_0._details_filled = true
end

LobbyBrowserConsoleUI._fill_weave_details = function (arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0._details_widgets.weave
	local var_41_1 = arg_41_1.selected_mission_id
	local var_41_2 = WeaveSettings.templates[var_41_1]
	local var_41_3 = table.find(WeaveSettings.templates_ordered, var_41_2)
	local var_41_4 = var_41_2.wind
	local var_41_5 = WindSettings[var_41_4]
	local var_41_6 = Localize(var_41_5.display_name)
	local var_41_7 = Colors.get_color_table_with_alpha(var_41_4, 255)
	local var_41_8 = var_41_5.thumbnail_icon
	local var_41_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_41_8).size
	local var_41_10 = var_41_0.wind_icon
	local var_41_11 = var_41_10.content
	local var_41_12 = var_41_10.style.texture_id

	var_41_11.texture_id = var_41_8
	var_41_12.texture_size = {
		var_41_9[1] * 0.6,
		var_41_9[2] * 0.6
	}
	var_41_12.horizontal_alignment = "center"
	var_41_12.vertical_alignment = "center"
	var_41_0.wind_icon_glow.style.texture_id.color = var_41_7
	var_41_0.wind_icon_bg.style.texture_id.color = var_41_7

	local var_41_13 = var_41_0.wind_name

	var_41_13.content.text = var_41_6
	var_41_13.style.text.text_color = var_41_7

	local var_41_14 = var_41_5.mutator
	local var_41_15 = MutatorTemplates[var_41_14]
	local var_41_16 = var_41_0.wind_mutator_icon
	local var_41_17 = var_41_0.wind_mutator_title_text
	local var_41_18 = var_41_0.wind_mutator_description_text

	var_41_16.content.texture_id = var_41_15.icon
	var_41_17.content.text = var_41_15.display_name
	var_41_18.content.text = var_41_15.description

	local var_41_19 = var_41_2.objectives
	local var_41_20 = 10
	local var_41_21 = 0

	for iter_41_0 = 1, #var_41_19 do
		local var_41_22 = var_41_19[iter_41_0]
		local var_41_23 = var_41_22.display_name
		local var_41_24 = var_41_22.icon

		arg_41_0:_assign_objective(iter_41_0, var_41_23, var_41_24, var_41_20)
	end

	local var_41_25 = "level_image_any"
	local var_41_26 = var_41_2.display_name
	local var_41_27 = arg_41_1 and (arg_41_1.selected_mission_id or arg_41_1.mission_id)
	local var_41_28 = arg_41_1.mechanism

	if var_41_27 then
		local var_41_29 = var_41_27

		if var_41_28 == "weave" then
			local var_41_30 = WeaveSettings.templates[var_41_27]

			if var_41_30 then
				var_41_29 = var_41_30.objectives[1].level_id
			end
		end

		if var_41_29 == "default_start_level" then
			var_41_29 = LevelSettingsDefaultStartLevel
		end

		var_41_25 = LevelSettings[var_41_29].level_image or var_41_25
	end

	var_41_0.level_image.content.texture_id = var_41_25

	local var_41_31 = var_41_0.level_name

	if arg_41_1.weave_quick_game == "true" then
		var_41_31.content.text = Localize(var_41_26)
	else
		var_41_31.content.text = var_41_3 .. ". " .. Localize(var_41_26)
	end

	local var_41_32 = {}

	if arg_41_1 then
		local var_41_33 = #SPProfiles

		for iter_41_1 = 1, var_41_33 do
			if not ProfileSynchronizer.is_free_in_lobby(iter_41_1, arg_41_1) then
				var_41_32[iter_41_1] = true
			end
		end
	end

	local var_41_34 = var_41_0.hero_tabs.content

	for iter_41_2 = 1, #ProfilePriority do
		local var_41_35 = ProfilePriority[iter_41_2]
		local var_41_36 = "_" .. tostring(iter_41_2)
		local var_41_37 = var_41_34["hotspot" .. var_41_36]

		if var_41_32[var_41_35] then
			var_41_37.disable_button = true
		else
			var_41_37.disable_button = false
		end
	end

	local var_41_38 = var_41_0.level_image_frame

	var_41_38.content.texture_id = "map_frame_weaves"
	var_41_38.style.texture_id.color = var_41_7

	local var_41_39 = arg_41_0._widgets.join_button.content.button_hotspot
	local var_41_40 = var_41_0.locked_reason.content

	if arg_41_1 then
		local var_41_41, var_41_42 = arg_41_0._parent:is_lobby_joinable(arg_41_1)

		var_41_40.text = var_41_42 or "tutorial_no_text"
		var_41_39.disable_button = not var_41_41
	else
		var_41_40.text = "tutorial_no_text"
		var_41_39.disable_button = true
	end

	local var_41_43 = var_41_0.details_information.content

	if arg_41_1 then
		local var_41_44 = {
			event = "lb_game_type_event",
			deed = "lb_game_type_deed",
			tutorial = "lb_game_type_prologue",
			weave = "lb_game_type_weave",
			custom = "lb_game_type_custom",
			standard = "lb_game_type_quick_play",
			weave_quick_play = "lb_game_type_weave_quick_play",
			["n/a"] = "lb_game_type_none",
			deus = "area_selection_morris_name"
		}
		local var_41_45 = arg_41_1.mechanism
		local var_41_46 = arg_41_1.matchmaking_type
		local var_41_47 = IS_PS4 and var_41_46 or NetworkLookup.matchmaking_types[tonumber(var_41_46)]
		local var_41_48 = arg_41_1.mission_id
		local var_41_49 = var_41_48

		if var_41_45 == "weave" then
			local var_41_50 = WeaveSettings.templates[var_41_48]

			if var_41_50 then
				var_41_49 = var_41_50.objectives[1].level_id
			end

			if arg_41_1.weave_quick_game == "true" then
				var_41_47 = "weave_quick_play"
			end
		elseif var_41_45 == "deus" then
			var_41_47 = "deus"
		end

		local var_41_51 = LevelSettings[var_41_49]

		var_41_43.game_type_id = var_41_47 and (var_41_44[var_41_47] or "lb_unknown") or "lb_game_type_none"
		var_41_43.status_id = var_41_51.hub_level and "lb_in_inn" or "lb_playing"
	else
		var_41_43.game_type_id = "lb_unknown"
		var_41_43.status_id = "lb_unknown"
	end

	arg_41_0._details_type = "weave"
	arg_41_0._details_filled = true
end

LobbyBrowserConsoleUI._gather_unlocked_journeys = function (arg_42_0)
	local var_42_0 = {}
	local var_42_1 = Managers.player:statistics_db()
	local var_42_2 = Managers.player:local_player():stats_id()

	for iter_42_0, iter_42_1 in ipairs(LevelUnlockUtils.unlocked_journeys(var_42_1, var_42_2)) do
		var_42_0[iter_42_1] = true
	end

	return var_42_0
end

LobbyBrowserConsoleUI._fill_deus_details = function (arg_43_0, arg_43_1)
	local var_43_0, var_43_1 = arg_43_0:_gather_unlocked_journeys()
	local var_43_2 = arg_43_0._details_widgets.deus
	local var_43_3 = "level_image_any"
	local var_43_4
	local var_43_5 = arg_43_1 and (arg_43_1.selected_mission_id or arg_43_1.mission_id)
	local var_43_6 = arg_43_1 and arg_43_1.matchmaking_type
	local var_43_7 = var_43_6 and (IS_PS4 and var_43_6 or NetworkLookup.matchmaking_types[tonumber(var_43_6)])
	local var_43_8 = arg_43_1 and arg_43_1.mechanism
	local var_43_9 = var_43_5
	local var_43_10 = DeusJourneySettings[var_43_9]
	local var_43_11 = var_43_2.expedition_icon.content

	var_43_11.level_icon = var_43_10.level_image
	var_43_11.locked = not var_43_0[var_43_9]

	local var_43_12 = Managers.backend:get_interface("deus"):get_journey_cycle().journey_data[var_43_9].dominant_god

	var_43_11.theme_icon = DeusThemeSettings[var_43_12].icon
	var_43_2.level_name.content.text = Localize(var_43_10.display_name)

	local var_43_13 = {}

	if arg_43_1 then
		local var_43_14 = #SPProfiles

		for iter_43_0 = 1, var_43_14 do
			if not ProfileSynchronizer.is_free_in_lobby(iter_43_0, arg_43_1) then
				var_43_13[iter_43_0] = true
			end
		end
	end

	local var_43_15 = var_43_2.hero_tabs.content

	for iter_43_1 = 1, #ProfilePriority do
		local var_43_16 = ProfilePriority[iter_43_1]
		local var_43_17 = "_" .. tostring(iter_43_1)
		local var_43_18 = var_43_15["hotspot" .. var_43_17]

		if var_43_13[var_43_16] then
			var_43_18.disable_button = true
		else
			var_43_18.disable_button = false
		end
	end

	local var_43_19 = arg_43_0._widgets.join_button.content.button_hotspot
	local var_43_20 = var_43_2.locked_reason.content

	if arg_43_1 then
		local var_43_21, var_43_22 = arg_43_0._parent:is_lobby_joinable(arg_43_1)

		var_43_20.text = var_43_22 or "tutorial_no_text"
		var_43_19.disable_button = not var_43_21
	else
		var_43_20.text = "tutorial_no_text"
		var_43_19.disable_button = true
	end

	local var_43_23 = var_43_2.details_information.content

	if arg_43_1 then
		local var_43_24 = {
			event = "lb_game_type_event",
			deed = "lb_game_type_deed",
			tutorial = "lb_game_type_prologue",
			weave = "lb_game_type_weave",
			deus_weekly = "cw_weekly_expedition_name_long",
			custom = "lb_game_type_custom",
			standard = "lb_game_type_quick_play",
			weave_quick_play = "lb_game_type_weave_quick_play",
			["n/a"] = "lb_game_type_none",
			deus = "area_selection_morris_name"
		}
		local var_43_25 = arg_43_1.mission_id
		local var_43_26 = var_43_25

		if var_43_8 == "weave" then
			local var_43_27 = WeaveSettings.templates[var_43_25]

			if var_43_27 then
				var_43_26 = var_43_27.objectives[1].level_id
			end

			if arg_43_1.weave_quick_game == "true" then
				var_43_7 = "weave_quick_play"
			else
				var_43_7 = "weave"
			end
		elseif var_43_8 == "deus" then
			var_43_7 = var_43_7 == "event" and "deus_weekly" or "deus"
		end

		local var_43_28 = LevelSettings[var_43_26]

		var_43_23.game_type_id = var_43_7 and (var_43_24[var_43_7] or "lb_unknown") or "lb_game_type_none"
		var_43_23.status_id = var_43_28.hub_level and "lb_in_inn" or "lb_playing"
	else
		var_43_23.game_type_id = "lb_unknown"
		var_43_23.status_id = "lb_unknown"
	end

	var_43_2.twitch_logo.content.visible = to_boolean(arg_43_1 and arg_43_1.twitch_enabled)
	arg_43_0._details_type = "deus"
	arg_43_0._details_filled = true
end

LobbyBrowserConsoleUI._assign_objective = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	local var_44_0 = "objective_" .. arg_44_1
	local var_44_1 = arg_44_0._details_widgets.weave[var_44_0]
	local var_44_2 = var_44_1.content
	local var_44_3 = var_44_1.style

	var_44_2.icon = arg_44_3 or "trial_gem"
	var_44_2.text = arg_44_2 or "-"
end

LobbyBrowserConsoleUI.set_game_type_filter = function (arg_45_0, arg_45_1)
	arg_45_0._widgets.filter_frame.content.game_type_name = arg_45_1
end

LobbyBrowserConsoleUI.set_level_filter = function (arg_46_0, arg_46_1)
	arg_46_0._widgets.filter_frame.content.mission_name = arg_46_1
end

LobbyBrowserConsoleUI.set_difficulty_filter = function (arg_47_0, arg_47_1)
	arg_47_0._widgets.filter_frame.content.difficulty_name = arg_47_1
end

LobbyBrowserConsoleUI.set_show_lobbies_filter = function (arg_48_0, arg_48_1)
	arg_48_0._widgets.filter_frame.content.show_lobbies_name = arg_48_1
end

LobbyBrowserConsoleUI.set_distance_filter = function (arg_49_0, arg_49_1)
	arg_49_0._widgets.filter_frame.content.distance_name = arg_49_1
end

LobbyBrowserConsoleUI._draw = function (arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0._ui_renderer
	local var_50_1 = arg_50_0._ui_scenegraph
	local var_50_2 = arg_50_0._input_manager
	local var_50_3 = arg_50_0._render_settings
	local var_50_4 = arg_50_0._parent:input_service()
	local var_50_5

	UIRenderer.begin_pass(var_50_0, var_50_1, var_50_4, arg_50_1, nil, var_50_3)

	for iter_50_0, iter_50_1 in pairs(arg_50_0._widgets) do
		UIRenderer.draw_widget(var_50_0, iter_50_1)
	end

	if arg_50_0._filter_active then
		arg_50_0:_render_filter(var_50_0, var_50_1, var_50_4, arg_50_1, arg_50_2)
	end

	arg_50_0:_render_lobby_browser(var_50_0, var_50_1, var_50_4, arg_50_1)
	UIRenderer.end_pass(var_50_0)

	if arg_50_0._scrollbar_ui then
		arg_50_0._scrollbar_ui:update(arg_50_1, arg_50_2, var_50_0, var_50_4, var_50_3)
	end
end

LobbyBrowserConsoleUI._render_filter = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	if arg_51_0._current_active_filter then
		arg_51_0[arg_51_0._filter_functions[arg_51_0._current_active_filter].render_function](arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	end
end

LobbyBrowserConsoleUI._render_game_type_filter_list = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	for iter_52_0, iter_52_1 in ipairs(arg_52_0._game_type_filter_widgets) do
		UIRenderer.draw_widget(arg_52_1, iter_52_1)
	end
end

LobbyBrowserConsoleUI._render_level_filter_list = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	for iter_53_0, iter_53_1 in ipairs(arg_53_0._level_filter_widgets) do
		UIRenderer.draw_widget(arg_53_1, iter_53_1)
	end

	UIRenderer.draw_widget(arg_53_1, arg_53_0._level_filter_scroller)
end

LobbyBrowserConsoleUI._render_difficulty_filter_list = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	for iter_54_0, iter_54_1 in ipairs(arg_54_0._difficulty_filter_widgets) do
		UIRenderer.draw_widget(arg_54_1, iter_54_1)
	end
end

LobbyBrowserConsoleUI._render_lobby_filter_list = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5)
	for iter_55_0, iter_55_1 in ipairs(arg_55_0._lobby_filter_widgets) do
		UIRenderer.draw_widget(arg_55_1, iter_55_1)
	end
end

LobbyBrowserConsoleUI._render_distance_filter_list = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5)
	for iter_56_0, iter_56_1 in ipairs(arg_56_0._distance_filter_widgets) do
		UIRenderer.draw_widget(arg_56_1, iter_56_1)
	end
end

LobbyBrowserConsoleUI._render_lobby_browser = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5)
	local var_57_0 = var_0_0.element_settings

	for iter_57_0, iter_57_1 in ipairs(arg_57_0._lobby_entry_widgets) do
		if arg_57_0:_is_inside(iter_57_1, var_57_0, iter_57_0) then
			UIRenderer.draw_widget(arg_57_1, iter_57_1)
		end
	end

	if arg_57_0._details_filled then
		local var_57_1 = arg_57_0._details_widgets[arg_57_0._details_type]

		for iter_57_2, iter_57_3 in pairs(var_57_1) do
			UIRenderer.draw_widget(arg_57_1, iter_57_3)
		end

		local var_57_2 = arg_57_0._dynamic_details_widgets[arg_57_0._details_type]

		for iter_57_4, iter_57_5 in pairs(var_57_2) do
			UIRenderer.draw_widget(arg_57_1, iter_57_5)
		end
	end

	for iter_57_6, iter_57_7 in ipairs(arg_57_0._empty_lobby_entry_widgets) do
		UIRenderer.draw_widget(arg_57_1, iter_57_7)
	end
end

LobbyBrowserConsoleUI._is_inside = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0 = arg_58_2.height
	local var_58_1 = arg_58_2.window_height
	local var_58_2 = arg_58_0._ui_scenegraph.lobby_entry_anchor.position[2] + arg_58_1.offset[2]
	local var_58_3 = var_58_2 + var_58_0
	local var_58_4 = 0
	local var_58_5 = -var_58_1

	return var_58_2 < var_58_4 and var_58_5 < var_58_3
end

LobbyBrowserConsoleUI.destroy = function (arg_59_0)
	return
end
