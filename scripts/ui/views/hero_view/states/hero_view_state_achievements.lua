-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_achievements.lua

require("scripts/ui/reward_popup/reward_popup_ui")
require("scripts/helpers/search_utils")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_achievements_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.overlay_widgets
local var_0_3 = var_0_0.summary_widgets
local var_0_4 = var_0_0.search_widget_definitions
local var_0_5 = var_0_0.quest_widgets
local var_0_6 = var_0_0.achievement_widgets
local var_0_7 = var_0_0.category_tab_widgets
local var_0_8 = var_0_0.quest_entry_definition
local var_0_9 = var_0_0.achievement_entry_definition
local var_0_10 = var_0_0.scenegraph_definition
local var_0_11 = var_0_0.animation_definitions
local var_0_12 = var_0_0.achievement_entry_size
local var_0_13 = var_0_0.achievement_window_size
local var_0_14 = var_0_0.achievement_scrollbar_size
local var_0_15 = var_0_0.checklist_entry_size
local var_0_16 = var_0_0.category_tab_info
local var_0_17 = var_0_0.achievement_spacing
local var_0_18 = var_0_0.achievement_presentation_amount
local var_0_19 = var_0_0.generic_input_actions
local var_0_20 = var_0_0.console_cursor_definition
local var_0_21 = var_0_0.quest_scrollbar_bottom_inset
local var_0_22 = var_0_0.create_search_filters_widget
local var_0_23 = var_0_15[2]
local var_0_24 = var_0_12[2]
local var_0_25 = var_0_13[2]
local var_0_26 = var_0_18
local var_0_27 = var_0_17

HeroViewStateAchievements = class(HeroViewStateAchievements)
HeroViewStateAchievements.NAME = "HeroViewStateAchievements"

HeroViewStateAchievements.on_enter = function (arg_1_0, arg_1_1)
	print("[HeroViewState] Enter Substate HeroViewStateAchievements")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ingame_ui_context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.voting_manager = var_1_0.voting_manager
	arg_1_0.profile_synchronizer = var_1_0.profile_synchronizer
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = false
	}
	arg_1_0.wwise_world = arg_1_1.wwise_world
	arg_1_0.ingame_ui = var_1_0.ingame_ui
	arg_1_0._quest_manager = Managers.state.quest
	arg_1_0._achievement_manager = Managers.state.achievement
	arg_1_0._claimable_challenge_widgets = {}
	arg_1_0._quest_rewards_fail_reason = nil
	arg_1_0._search_query = ""
	arg_1_0._reward_presentation_queue = {}

	local var_1_1 = {
		wwise_world = arg_1_0.wwise_world,
		ui_renderer = arg_1_0.ui_renderer,
		ui_top_renderer = arg_1_0.ui_top_renderer,
		input_manager = arg_1_0.input_manager
	}

	arg_1_0._timer_title = Localize("achv_menu_summary_quest_refresh")
	arg_1_0._active_quest_tab_timer_type = "daily"
	arg_1_0.reward_popup = RewardPopupUI:new(var_1_1)

	arg_1_0.reward_popup:set_input_manager(arg_1_0.input_manager)

	arg_1_0.world_previewer = arg_1_1.world_previewer
	arg_1_0.platform = PLATFORM

	local var_1_2 = Managers.player
	local var_1_3 = var_1_2:local_player()

	arg_1_0._stats_id = var_1_3:stats_id()
	arg_1_0.player_manager = var_1_2
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.local_player_id = var_1_0.local_player_id
	arg_1_0.player = var_1_3

	local var_1_4 = arg_1_0.profile_synchronizer:profile_by_peer(arg_1_0.peer_id, arg_1_0.local_player_id)
	local var_1_5 = SPProfiles[var_1_4]
	local var_1_6 = var_1_5.display_name
	local var_1_7 = var_1_5.character_name
	local var_1_8 = Managers.backend:get_interface("hero_attributes"):get(var_1_6, "career")
	local var_1_9 = arg_1_0:input_service()

	arg_1_0.menu_input_description = MenuInputDescriptionUI:new(var_1_0, arg_1_0.ui_top_renderer, var_1_9, 5, 100, var_0_19.default)

	arg_1_0.menu_input_description:set_input_description(nil)

	arg_1_0.hero_name = var_1_6
	arg_1_0.career_index = var_1_8
	arg_1_0.profile_index = var_1_4
	arg_1_0.is_server = arg_1_0.parent.is_server
	arg_1_0._current_gamepad_input_selection = {
		1,
		1
	}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1)
	arg_1_0._achievement_manager:setup_achievement_data()
	arg_1_0:_setup_achievement_progress_overview()
	arg_1_0:_setup_quest_summary_progress()

	if arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		arg_1_0:_start_transition_animation("on_enter", "on_enter")
	end

	arg_1_0:_update_buttons_new_status()

	local var_1_10 = "summary"
	local var_1_11

	if arg_1_1.start_state then
		if type(arg_1_1.start_state) == "table" then
			var_1_10 = arg_1_1.start_state[1].layout_name

			if arg_1_1.start_state[2] then
				var_1_11 = arg_1_1.start_state[2].tab_index
			end
		else
			var_1_10 = arg_1_1.start_state
		end
	end

	local var_1_12 = arg_1_0._widgets_by_name.summary_button

	arg_1_0:_on_layout_button_pressed(var_1_12, nil, var_1_10, var_1_11)
	arg_1_0:play_sound("Play_gui_achivements_menu_open")
	Managers.input:enable_gamepad_cursor()
	arg_1_0:_create_filter_input_service()
end

HeroViewStateAchievements._create_filter_input_service = function (arg_2_0)
	local var_2_0 = Managers.input

	var_2_0:create_input_service("achievement_filter", "IngameMenuKeymaps", "IngameMenuFilters", {
		hero_view = false
	})
	var_2_0:map_device_to_service("achievement_filter", "gamepad")
end

HeroViewStateAchievements.get_filter_input_service = function (arg_3_0)
	return Managers.input:get_service("achievement_filter")
end

HeroViewStateAchievements._update_buttons_new_status = function (arg_4_0)
	local var_4_0 = arg_4_0:_get_layout("quest")

	arg_4_0._widgets_by_name.quests_button.content.new = arg_4_0:_has_any_unclaimed_completed_challenge_in_category(var_4_0)

	local var_4_1 = arg_4_0:_get_layout("achievements")

	arg_4_0._widgets_by_name.achievements_button.content.new = arg_4_0:_has_any_unclaimed_completed_challenge_in_category(var_4_1)
end

HeroViewStateAchievements._update_summary_quest_timers = function (arg_5_0, arg_5_1)
	local var_5_0 = "quest"
	local var_5_1 = arg_5_0:_get_layout(var_5_0).categories
	local var_5_2 = "summary_quest_bar_timer_"
	local var_5_3 = arg_5_0._summary_widgets_by_name

	for iter_5_0, iter_5_1 in ipairs(var_5_1) do
		local var_5_4 = iter_5_1.name
		local var_5_5 = iter_5_1.entries
		local var_5_6 = iter_5_1.quest_type

		if not iter_5_1.max_entry_amount then
			local var_5_7 = 1
		end

		local var_5_8

		var_5_8 = var_5_5 ~= nil

		local var_5_9

		if var_5_6 == "daily" then
			var_5_9 = arg_5_0._quest_manager:time_until_new_daily_quest()
		elseif var_5_6 == "weekly" then
			var_5_9 = arg_5_0._quest_manager:time_until_new_weekly_quest()
		elseif var_5_6 == "event" then
			var_5_9 = arg_5_0._quest_manager:time_left_on_event_quest()
		end

		local var_5_10

		if var_5_9 and var_5_9 > 0 then
			var_5_10 = UIUtils.format_duration(var_5_9)
		else
			var_5_10 = Localize("achv_menu_summary_quests_unavailable")
			var_5_9 = 0
		end

		local var_5_11 = var_5_3[var_5_2 .. tostring(iter_5_0)].content

		var_5_11.text = var_5_10

		local var_5_12 = var_5_11.previous_time_in_seconds or math.huge

		var_5_11.previous_time_in_seconds = var_5_9

		if var_5_12 < var_5_9 then
			local var_5_13 = 1
			local var_5_14 = 1

			if arg_5_0._active_tab_index == var_5_13 then
				local var_5_15 = arg_5_0._category_tab_widgets[var_5_13]

				arg_5_0:_setup_layout("quest")
				arg_5_0:_activate_tab(var_5_15, var_5_13, var_5_14, true)
			end

			arg_5_0:_setup_quest_summary_progress()
		end

		if arg_5_0._active_quest_tab_timer_type == var_5_6 then
			arg_5_0._additional_quest_widgets_by_name.time_left_text.content.text = arg_5_0._timer_title .. " " .. var_5_10
		end
	end
end

HeroViewStateAchievements.create_ui_elements = function (arg_6_0, arg_6_1)
	local var_6_0 = var_0_0.create_category_tab_widgets_func()

	arg_6_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_10)
	arg_6_0._console_cursor_widget = UIWidget.init(var_0_20)
	arg_6_0._widgets, arg_6_0._widgets_by_name = UIUtils.create_widgets(var_0_1)
	arg_6_0._overlay_widgets, arg_6_0._overlay_widgets_by_name = UIUtils.create_widgets(var_0_2)
	arg_6_0._summary_widgets, arg_6_0._summary_widgets_by_name = UIUtils.create_widgets(var_0_3)
	arg_6_0._additional_quest_widgets, arg_6_0._additional_quest_widgets_by_name = UIUtils.create_widgets(var_0_5)
	arg_6_0._additional_achievement_widgets, arg_6_0._additional_achievement_widgets_by_name = UIUtils.create_widgets(var_0_6)
	arg_6_0._search_widgets, arg_6_0._search_widgets_by_name = UIUtils.create_widgets(var_0_4)
	arg_6_0._category_tab_widgets = UIUtils.create_widgets(var_6_0)

	for iter_6_0, iter_6_1 in pairs(arg_6_0._category_tab_widgets) do
		arg_6_0:_reset_tab(iter_6_1)
	end

	local var_6_1 = UIWidget.init(var_0_22("search_filters", arg_6_0.ui_renderer, UISettings.achievement_search_definitions))

	arg_6_0._search_widgets[#arg_6_0._search_widgets + 1] = var_6_1
	arg_6_0._search_widgets_by_name.filters = var_6_1

	UIRenderer.clear_scenegraph_queue(arg_6_0.ui_renderer)

	arg_6_0.ui_animator = UIAnimator:new(arg_6_0.ui_scenegraph, var_0_11)

	local var_6_2 = arg_6_0._additional_quest_widgets_by_name.left_window

	arg_6_0:_set_uvs_scale_progress(var_6_2.scenegraph_id, var_6_2.content.texture_id.uvs, 1)

	local var_6_3 = arg_6_0._additional_achievement_widgets_by_name.left_window

	arg_6_0:_set_uvs_scale_progress(var_6_3.scenegraph_id, var_6_3.content.texture_id.uvs, 1)

	arg_6_0._category_scrollbar = ScrollBarLogic:new(arg_6_0._widgets_by_name.category_scrollbar)
end

local function var_0_28(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_1.entries

	if var_7_0 then
		local var_7_1 = #var_7_0

		arg_7_2 = arg_7_2 + var_7_1

		for iter_7_0 = 1, var_7_1 do
			local var_7_2 = arg_7_0:get_data_by_id(var_7_0[iter_7_0])

			if var_7_2.claimed then
				arg_7_3 = arg_7_3 + 1
			elseif var_7_2.completed then
				arg_7_4 = true
			end
		end
	end

	local var_7_3 = arg_7_1.categories

	if var_7_3 then
		for iter_7_1 = 1, #var_7_3 do
			arg_7_2, arg_7_3, arg_7_4 = var_0_28(arg_7_0, var_7_3[iter_7_1], arg_7_2, arg_7_3, arg_7_4)
		end
	end

	return arg_7_2, arg_7_3, arg_7_4
end

HeroViewStateAchievements._setup_achievement_progress_overview = function (arg_8_0)
	local var_8_0 = arg_8_0._achievement_manager
	local var_8_1 = {}
	local var_8_2 = var_8_0:outline()

	for iter_8_0, iter_8_1 in ipairs(var_8_2.categories) do
		if iter_8_1.present_progression then
			local var_8_3 = {
				display_name = iter_8_1.name
			}

			var_8_3.amount, var_8_3.amount_claimed, var_8_3.has_unclaimed = var_0_28(var_8_0, iter_8_1, 0, 0, false)
			var_8_1[iter_8_0] = var_8_3
		end
	end

	arg_8_0:_set_summary_achievement_categories_progress(var_8_1)
end

HeroViewStateAchievements._handle_layout_buttons_hovered = function (arg_9_0)
	local var_9_0 = arg_9_0._widgets_by_name
	local var_9_1 = arg_9_0._summary_widgets_by_name
	local var_9_2 = var_9_0.exit_button
	local var_9_3 = var_9_0.quests_button
	local var_9_4 = var_9_0.summary_button
	local var_9_5 = var_9_0.achievements_button
	local var_9_6 = var_9_1.summary_right_window_button
	local var_9_7 = var_9_1.summary_left_window_button
	local var_9_8 = false

	if UIUtils.is_button_hover_enter(var_9_3) or UIUtils.is_button_hover_enter(var_9_7) then
		arg_9_0:play_sound("Play_gui_achivements_menu_hover_epic")
	end

	if UIUtils.is_button_hover_enter(var_9_5) or UIUtils.is_button_hover_enter(var_9_6) then
		var_9_8 = true
	end

	if UIUtils.is_button_hover_enter(var_9_4) then
		var_9_8 = true
	end

	if UIUtils.is_button_hover(var_9_3) then
		var_9_7.content.has_focus = true
	else
		var_9_7.content.has_focus = false
	end

	if UIUtils.is_button_hover(var_9_7) then
		var_9_3.content.has_focus = true
	else
		var_9_3.content.has_focus = false
	end

	if UIUtils.is_button_hover(var_9_5) then
		var_9_6.content.has_focus = true
	else
		var_9_6.content.has_focus = false
	end

	if UIUtils.is_button_hover(var_9_6) then
		var_9_5.content.has_focus = true
	else
		var_9_5.content.has_focus = false
	end

	if var_9_8 then
		arg_9_0:play_sound("play_gui_equipment_button_hover")
	end
end

HeroViewStateAchievements._on_layout_button_pressed = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_0._widgets_by_name
	local var_10_1 = var_10_0.quests_button
	local var_10_2 = var_10_0.summary_button
	local var_10_3 = var_10_0.achievements_button

	if arg_10_2 then
		arg_10_2.content.has_focus = false

		table.clear(arg_10_2.content.button_hotspot)
	end

	var_10_1.content.button_hotspot.is_selected = false
	var_10_2.content.button_hotspot.is_selected = false
	var_10_3.content.button_hotspot.is_selected = false
	arg_10_1.content.button_hotspot.is_selected = true
	arg_10_1.content.has_focus = false

	if arg_10_3 == "summary" then
		if not arg_10_0._looping_summary_sounds then
			arg_10_0:play_sound("Play_gui_achivements_menu_flag_loop")
			arg_10_0:play_sound("Play_gui_achivements_menu_daily_quest_loop")

			arg_10_0._looping_summary_sounds = true
		end

		arg_10_0._draw_summary = true

		arg_10_0:_deactivate_active_tab()
		arg_10_0:_reset_tabs()

		arg_10_0._achievement_widgets = nil
		arg_10_0._widgets_by_name.achievement_scrollbar.content.visible = false
		arg_10_0._widgets_by_name.category_scrollbar.content.visible = false
		arg_10_0._search_widgets_by_name.input.content.visible = false
		arg_10_0._search_widgets_by_name.filters.content.visible = false
	else
		if arg_10_3 == "achievements" then
			arg_10_0._additional_type_widgets = arg_10_0._additional_achievement_widgets
			arg_10_0._additional_type_widgets_by_name = arg_10_0._additional_achievement_widgets_by_name
		else
			arg_10_0._additional_type_widgets = arg_10_0._additional_quest_widgets
			arg_10_0._additional_type_widgets_by_name = arg_10_0._additional_quest_widgets_by_name
		end

		if arg_10_0._looping_summary_sounds then
			arg_10_0:play_sound("Stop_gui_achivements_menu_flag_loop")
			arg_10_0:play_sound("Stop_gui_achivements_menu_daily_quest_loop")

			arg_10_0._looping_summary_sounds = false
		end

		arg_10_0._draw_summary = false

		arg_10_0:_setup_layout(arg_10_3)

		arg_10_0._widgets_by_name.achievement_scrollbar.content.visible = true
		arg_10_0._widgets_by_name.category_scrollbar.content.visible = true
		arg_10_0._search_widgets_by_name.input.content.visible = true

		arg_10_0:_update_categories_scroll_height(0)

		arg_10_4 = arg_10_4 or 1

		local var_10_4 = arg_10_0._category_tab_widgets[arg_10_4]

		arg_10_0:_activate_tab(var_10_4, arg_10_4, nil, true)
	end

	arg_10_0._achievement_layout_type = arg_10_3
end

HeroViewStateAchievements._reset_tabs = function (arg_11_0)
	for iter_11_0, iter_11_1 in ipairs(arg_11_0._category_tab_widgets) do
		arg_11_0:_reset_tab(iter_11_1)
	end
end

HeroViewStateAchievements._setup_layout = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._category_tab_widgets
	local var_12_1 = #var_12_0
	local var_12_2 = arg_12_0:_get_layout(arg_12_1).categories

	for iter_12_0 = 1, var_12_1 do
		local var_12_3 = var_12_2[iter_12_0]
		local var_12_4 = var_12_0[iter_12_0]

		arg_12_0:_reset_tab(var_12_4)
		arg_12_0:_setup_tab_widget(var_12_4, var_12_3)
	end

	arg_12_0._achievement_layout_type = arg_12_1
end

HeroViewStateAchievements._setup_tab_widget = function (arg_13_0, arg_13_1, arg_13_2)
	if arg_13_2 then
		local var_13_0 = arg_13_2.name
		local var_13_1 = Localize(var_13_0)

		arg_13_1.content.title_text = var_13_1
		arg_13_1.content.data = arg_13_2
		arg_13_1.content.new = arg_13_0:_has_any_unclaimed_completed_challenge_in_category(arg_13_2)

		local var_13_2 = arg_13_2.categories
		local var_13_3 = arg_13_2.entries

		if var_13_2 then
			arg_13_0:_populate_tab(arg_13_1, var_13_2)
		end

		local var_13_4 = false

		if not var_13_3 and not var_13_2 then
			var_13_4 = true
		end

		arg_13_1.content.visible = true
		arg_13_1.content.button_hotspot.disable_button = var_13_4
	end
end

HeroViewStateAchievements._get_layout = function (arg_14_0, arg_14_1)
	if arg_14_1 == "achievements" then
		return arg_14_0._achievement_manager:outline()
	elseif arg_14_1 == "quest" then
		local var_14_0 = arg_14_0._quest_manager:get_quest_outline()

		if arg_14_1 then
			for iter_14_0, iter_14_1 in ipairs(var_14_0) do
				if iter_14_1.type == arg_14_1 then
					return iter_14_1
				end
			end
		end

		return var_14_0
	end
end

HeroViewStateAchievements._reset_tab = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.content
	local var_15_1 = arg_15_1.style
	local var_15_2 = arg_15_1.style.list_style

	var_15_0.active = false
	var_15_0.list_content.active = false
	var_15_0.button_hotspot.is_selected = false
	var_15_0.visible = false
	var_15_0.new = false
	var_15_2.num_draws = 0

	local var_15_3 = var_15_2.scenegraph_id

	arg_15_0.ui_scenegraph[var_15_3].size[2] = 0
	arg_15_1.alpha_multiplier = 0
	arg_15_1.alpha_fade_in_delay = nil
	arg_15_1.alpha_fade_multipler = 5
end

local function var_0_29(arg_16_0, arg_16_1)
	local var_16_0 = Managers.unlock
	local var_16_1 = arg_16_1.entries

	if var_16_1 then
		for iter_16_0 = 1, #var_16_1 do
			local var_16_2 = arg_16_0:get_data_by_id(var_16_1[iter_16_0])

			if var_16_2.completed and not var_16_2.claimed then
				local var_16_3 = var_16_2.required_dlc
				local var_16_4 = var_16_2.required_dlc_extra

				if (not var_16_3 or var_16_0:is_dlc_unlocked(var_16_3)) and (not var_16_4 or var_16_0:is_dlc_unlocked(var_16_4)) then
					return true
				end
			end
		end
	end

	local var_16_5 = arg_16_1.categories

	if var_16_5 then
		for iter_16_1 = 1, #var_16_5 do
			if var_0_29(arg_16_0, var_16_5[iter_16_1]) then
				return true
			end
		end
	end

	return false
end

HeroViewStateAchievements._has_any_unclaimed_completed_challenge_in_category = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.type
	local var_17_1

	if var_17_0 == "achievements" then
		var_17_1 = arg_17_0._achievement_manager
	elseif var_17_0 == "quest" then
		var_17_1 = arg_17_0._quest_manager
	else
		ferror("Invalid category type: %q", var_17_0)
	end

	return var_0_29(var_17_1, arg_17_1)
end

HeroViewStateAchievements._populate_tab = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_1.content
	local var_18_1 = arg_18_1.style.list_style
	local var_18_2 = var_18_0.list_content
	local var_18_3 = var_0_16.tab_list_entry_size
	local var_18_4 = #arg_18_2

	var_18_0.tabs_height = var_18_3[2] * var_18_4

	for iter_18_0, iter_18_1 in ipairs(arg_18_2) do
		local var_18_5 = iter_18_1.name
		local var_18_6

		var_18_6.text, var_18_6 = Localize(var_18_5), var_18_2[iter_18_0]
		var_18_6.new = arg_18_0:_has_any_unclaimed_completed_challenge_in_category(iter_18_1)
	end

	var_18_1.num_draws = var_18_4
end

HeroViewStateAchievements._create_entries = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_0._quest_manager
	local var_19_1 = arg_19_0._achievement_manager

	arg_19_0._claimable_challenge_widgets = {}
	arg_19_0._has_claimable_filtered_challenges = nil

	local var_19_2
	local var_19_3
	local var_19_4 = false

	if arg_19_2 == "quest" then
		var_19_2 = var_0_8
		var_19_4 = arg_19_3 == "daily" and var_19_0:can_refresh_daily_quest()
		var_19_3 = var_19_0
	else
		var_19_2 = var_0_9
		var_19_3 = var_19_1
	end

	local var_19_5 = arg_19_0._search_query
	local var_19_6 = arg_19_0._search_widgets_by_name.filters.content.query

	print("[HeroViewStateAchievements] Using search query: ", var_19_5)

	local var_19_7 = SearchUtils.extract_queries(var_19_5, UISettings.achievement_search_definitions, var_19_6)
	local var_19_8 = {}
	local var_19_9 = {}
	local var_19_10 = {}

	for iter_19_0 = 1, #arg_19_1 do
		local var_19_11 = arg_19_1[iter_19_0]
		local var_19_12 = var_19_3:get_data_by_id(var_19_11)

		if var_19_7 ~= nil and not SearchUtils.simple_search(var_19_7, var_19_12.name) and not SearchUtils.simple_search(var_19_7, var_19_12.desc) then
			-- Nothing
		else
			local var_19_13 = (var_19_12.completed or script_data.set_all_challenges_claimable) and not script_data["eac-untrusted"]

			if var_19_6.completed ~= nil and var_19_6.completed == not var_19_13 then
				-- Nothing
			else
				local var_19_14 = var_19_12.claimed

				if var_19_6.claimed ~= nil and var_19_6.claimed == not var_19_14 then
					-- Nothing
				else
					local var_19_15 = true
					local var_19_16 = Localize("dlc_not_owned") .. ":"
					local var_19_17
					local var_19_18 = var_19_12.required_dlc

					if var_19_18 and not Managers.unlock:is_dlc_unlocked(var_19_18) then
						local var_19_19 = StoreDlcSettingsByName[var_19_18]

						if var_19_19 then
							var_19_16 = var_19_16 .. "\n" .. Localize(var_19_19.name)
							var_19_17 = var_19_19.dlc_name
						end

						var_19_15 = false
					end

					local var_19_20 = var_19_12.required_dlc_extra

					if var_19_20 and not Managers.unlock:is_dlc_unlocked(var_19_20) then
						local var_19_21 = StoreDlcSettingsByName[var_19_20]

						if var_19_21 then
							var_19_16 = var_19_16 .. "\n" .. Localize(var_19_21.name)
							var_19_17 = var_19_21.dlc_name
						end

						var_19_15 = false
					end

					if var_19_6.locked ~= nil and var_19_6.locked == var_19_15 then
						-- Nothing
					else
						table.clear(var_19_8)

						local var_19_22 = var_19_12.reward

						if var_19_22 then
							if type(var_19_22) == "string" then
								local var_19_23 = var_19_22
								local var_19_24 = ItemMasterList[var_19_23]

								var_19_8.reward_item = {
									data = var_19_24
								}
								var_19_8.reward_icon = var_19_24.inventory_icon
								var_19_8.reward_icon_background = UISettings.item_rarity_textures[var_19_24.rarity]
							elseif type(var_19_22) == "table" then
								local var_19_25 = var_19_22.reward_type

								if var_19_25 == "item" or var_19_25 == "loot_chest" or CosmeticUtils.is_cosmetic_item(var_19_25) then
									local var_19_26 = var_19_22.item_name
									local var_19_27 = ItemMasterList[var_19_26]
									local var_19_28 = var_19_22.custom_data
									local var_19_29 = {
										data = var_19_27
									}

									if var_19_28 then
										if var_19_28.power_level then
											var_19_29.power_level = tonumber(var_19_28.power_level)
										end

										if var_19_28.rarity then
											var_19_29.rarity = var_19_28.rarity
										end
									end

									var_19_8.reward_item = var_19_29
									var_19_8.reward_icon = var_19_27.inventory_icon
									var_19_8.reward_icon_background = UISettings.item_rarity_textures[var_19_29.rarity or var_19_27.rarity]
								elseif var_19_25 == "keep_decoration_painting" then
									local var_19_30 = var_19_22.decoration_name
									local var_19_31 = Paintings[var_19_30]
									local var_19_32 = var_19_22.rarity or var_19_31.rarity or "plentiful"

									var_19_8.reward_item = {
										data = {
											item_type = "keep_decoration_painting",
											slot_type = "keep_decoration_painting",
											information_text = "information_text_painting",
											matching_item_key = "keep_decoration_painting",
											can_wield = CanWieldAllItemTemplates,
											rarity = var_19_32,
											display_name = var_19_31.display_name,
											description = var_19_31.description
										},
										painting = var_19_30
									}
									var_19_8.reward_icon = var_19_31.icon
									var_19_8.reward_icon_background = UISettings.item_rarity_textures[var_19_32]
								elseif var_19_25 == "weapon_skin" then
									local var_19_33 = var_19_22.weapon_skin_name
									local var_19_34 = WeaponSkins.skins[var_19_33]
									local var_19_35 = var_19_34.rarity or "plentiful"
									local var_19_36 = {
										data = {
											item_type = "weapon_skin",
											slot_type = "weapon_skin",
											information_text = "information_weapon_skin",
											matching_item_key = var_19_34.item_type,
											can_wield = CanWieldAllItemTemplates,
											rarity = var_19_35
										},
										skin = var_19_33
									}

									var_19_8.reward_icon, var_19_8.reward_item = var_19_34.inventory_icon, var_19_36
									var_19_8.is_illusion = true
									var_19_8.reward_icon_background = UISettings.item_rarity_textures[var_19_35]
								elseif var_19_25 == "currency" then
									local var_19_37 = {
										data = BackendUtils.get_fake_currency_item(var_19_22.currency_code, var_19_22.amount)
									}
									local var_19_38 = var_19_37.data.icon
									local var_19_39 = UISettings.item_rarity_textures[var_19_37.data.rarity]

									var_19_8.reward_item = var_19_37
									var_19_8.reward_icon = var_19_38
									var_19_8.reward_icon_background = var_19_39
								end
							end

							if var_19_6.reward ~= nil then
								local var_19_40 = var_19_8.reward_item.data
								local var_19_41 = var_19_40.slot_type or var_19_40.item_type

								if var_19_6.reward ~= var_19_41 then
									goto label_19_0
								end
							end

							if var_19_6.rarity ~= nil and var_19_6.rarity ~= var_19_8.reward_icon_background:gsub("^icon_bg_", "") then
								goto label_19_0
							end
						end

						local var_19_42 = UIWidget.init(var_19_2)
						local var_19_43 = var_19_42.content
						local var_19_44 = var_19_42.style

						table.merge(var_19_43, var_19_8)

						if not var_19_15 then
							if var_19_17 then
								var_19_43.dlc_name = var_19_17
							else
								var_19_16 = var_19_16 .. "\n" .. Localize("lb_unknown")
							end

							var_19_43.locked_text = var_19_16
						end

						local var_19_45 = var_19_12.requirements
						local var_19_46 = var_19_12.progress

						var_19_43.locked = not var_19_15
						var_19_43.can_close = var_19_4 and not var_19_13
						var_19_43.completed = var_19_13
						var_19_43.claimed = var_19_14
						var_19_43.id = var_19_11
						var_19_43.achievement_id = var_19_11
						var_19_43.original_order_index = iter_19_0
						var_19_43.title = var_19_12.name
						var_19_43.description = var_19_12.desc
						var_19_43.icon = var_19_12.icon or "icons_placeholder"

						local var_19_47 = 10

						if var_19_45 and #var_19_45 > 0 then
							var_19_47 = var_19_47 + arg_19_0:_set_requirements(var_19_42, var_19_45)
							var_19_43.expandable = true
						else
							var_19_43.expandable = false
						end

						arg_19_0:_set_achievement_expand_height(var_19_42, var_19_47)

						if var_19_46 and not var_19_13 and not var_19_14 then
							arg_19_0:_set_widget_bar_progress(var_19_42, var_19_46[1], var_19_46[2])

							var_19_43.draw_bar = true
						else
							var_19_43.draw_bar = false
						end

						var_19_44.reward_icon.saturated = var_19_14

						if not var_19_13 then
							Colors.darker(var_19_44.icon.color, 1.94)
							Colors.darker(var_19_44.progress_bar.color, 1.43)
							Colors.darker(var_19_44.background.color, 1.43)
							Colors.darker(var_19_44.icon_background.color, 1.43)
							Colors.darker(var_19_44.reward_background.color, 1.43)
							Colors.darker(var_19_44.side_detail_left.color, 1.43)
							Colors.darker(var_19_44.side_detail_right.color, 1.43)
						end

						if var_19_13 and not var_19_14 and var_19_15 then
							var_19_9[#var_19_9 + 1] = var_19_42
							arg_19_0._claimable_challenge_widgets[#arg_19_0._claimable_challenge_widgets + 1] = var_19_42
						else
							var_19_10[#var_19_10 + 1] = var_19_42
						end

						if var_19_9 and #var_19_9 ~= 0 then
							arg_19_0._has_claimable_filtered_challenges = true
						else
							arg_19_0._has_claimable_filtered_challenges = false
						end
					end
				end
			end
		end

		::label_19_0::
	end

	if #var_19_10 > 1 then
		table.sort(var_19_10, function (arg_20_0, arg_20_1)
			local var_20_0 = arg_20_0.content
			local var_20_1 = arg_20_1.content

			if var_20_0.claimed == var_20_1.claimed then
				return var_20_0.original_order_index < var_20_1.original_order_index
			else
				return not var_20_0.claimed
			end
		end)
	end

	table.append(var_19_9, var_19_10)

	arg_19_0._achievement_widgets = var_19_9
	arg_19_0.scroll_value = nil

	arg_19_0:_update_achievements_scroll_height()
	arg_19_0:_setup_achievement_entries_animations()

	if arg_19_0._achievement_widgets[1] then
		arg_19_0:_hide_empty_entries_warning()
	else
		arg_19_0:_show_empty_entries_warning()
	end
end

HeroViewStateAchievements._show_empty_entries_warning = function (arg_21_0)
	local var_21_0 = arg_21_0._additional_type_widgets_by_name
	local var_21_1 = var_21_0.overlay
	local var_21_2 = var_21_0.overlay_text
	local var_21_3 = var_21_0.overlay_fade

	var_21_1.content.visible = true
	var_21_3.content.visible = true
	var_21_2.content.visible = true
end

HeroViewStateAchievements._hide_empty_entries_warning = function (arg_22_0)
	local var_22_0 = arg_22_0._additional_type_widgets_by_name
	local var_22_1 = var_22_0.overlay
	local var_22_2 = var_22_0.overlay_text
	local var_22_3 = var_22_0.overlay_fade

	var_22_1.content.visible = false
	var_22_3.content.visible = false
	var_22_2.content.visible = false
end

HeroViewStateAchievements._set_widget_bar_progress = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_1.content
	local var_23_1 = arg_23_1.style.progress_bar
	local var_23_2 = var_23_1.default_size

	var_23_1.texture_size[1] = var_23_2[1] * (arg_23_2 / arg_23_3)

	local var_23_3 = arg_23_1.content and arg_23_1.content.achievement_id
	local var_23_4 = AchievementTemplates.achievements[var_23_3]

	if var_23_4 and var_23_4.progress_text_format_func then
		var_23_0.progress_text = var_23_4.progress_text_format_func(arg_23_2, arg_23_3)
	else
		var_23_0.progress_text = string.format("%d/%d", arg_23_2, arg_23_3)
	end
end

HeroViewStateAchievements._set_requirements = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_1.content
	local var_24_1 = arg_24_1.style
	local var_24_2 = var_0_23
	local var_24_3 = 0

	for iter_24_0, iter_24_1 in ipairs(arg_24_2) do
		local var_24_4 = (iter_24_0 - 1) % 2 + 1
		local var_24_5 = var_24_0["checklist_" .. var_24_4]
		local var_24_6 = var_24_1["checklist_" .. var_24_4]
		local var_24_7 = var_24_6.item_styles
		local var_24_8 = var_24_6.num_draws + 1
		local var_24_9 = var_24_5[var_24_8]
		local var_24_10 = var_24_7[var_24_8]

		var_24_6.num_draws = var_24_8

		if var_24_3 < var_24_8 then
			var_24_3 = var_24_8
		end

		local var_24_11 = iter_24_1.name
		local var_24_12 = iter_24_1.progress
		local var_24_13 = iter_24_1.completed
		local var_24_14 = var_24_11

		if var_24_12 then
			local var_24_15 = var_24_12[1]
			local var_24_16 = var_24_12[2]
			local var_24_17 = " (" .. tostring(var_24_15) .. "/" .. tostring(var_24_16) .. ")"

			var_24_14 = var_24_14 .. var_24_17
		end

		var_24_9.text = var_24_14

		Colors.set(var_24_10.checkbox_marker.color, var_24_13 and 255 or 0, 0, 0, 0)
	end

	return var_24_2 + var_24_3 * var_0_23
end

HeroViewStateAchievements._set_achievement_expand_height = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_1.content
	local var_25_1 = arg_25_1.style

	var_25_0.expand_height = arg_25_2
	var_25_1.expand_background.texture_size[2] = arg_25_2
	var_25_1.expand_background_edge.offset[2] = -arg_25_2
end

HeroViewStateAchievements._update_achievements_scroll_height = function (arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0:_get_achievement_entries_height()

	arg_26_0.total_scroll_height = math.max(var_26_0 - var_0_25, 0)

	arg_26_0:_setup_scrollbar(var_26_0, arg_26_1)
	arg_26_0:_align_achievement_entries()
end

HeroViewStateAchievements._update_categories_scroll_height = function (arg_27_0, arg_27_1)
	local var_27_0 = var_0_10.category_window_mask.size
	local var_27_1 = var_0_10.category_scrollbar.size
	local var_27_2 = arg_27_0._category_scrollbar
	local var_27_3 = var_27_0[2]
	local var_27_4 = arg_27_0:_get_category_entries_height()
	local var_27_5 = var_27_1[2]
	local var_27_6 = 220
	local var_27_7 = 1

	var_27_2:set_scrollbar_values(var_27_3, var_27_4, var_27_5, var_27_6, var_27_7)

	if arg_27_1 then
		var_27_2:set_scroll_percentage(arg_27_1)
	else
		local var_27_8, var_27_9 = arg_27_0:_get_active_category_height()

		var_27_2:scroll_to_fit(var_27_8, var_27_9)
	end
end

HeroViewStateAchievements._get_achievement_entries_height = function (arg_28_0, arg_28_1)
	arg_28_1 = arg_28_1 or 1

	local var_28_0 = 0
	local var_28_1 = arg_28_0._achievement_widgets

	for iter_28_0 = arg_28_1, #var_28_1 do
		local var_28_2 = var_28_1[iter_28_0].content
		local var_28_3 = var_0_24

		if iter_28_0 > 1 then
			var_28_3 = var_28_3 + var_0_27
		end

		if var_28_2.expanded then
			var_28_3 = var_28_3 + var_28_2.expand_height
		end

		var_28_0 = var_28_0 + var_28_3
	end

	local var_28_4 = 0

	if arg_28_0._achievement_layout_type == "quest" then
		var_28_4 = var_0_21
	end

	return var_28_0 + var_28_4
end

HeroViewStateAchievements._get_category_entries_height = function (arg_29_0)
	local var_29_0 = #arg_29_0._category_tab_widgets
	local var_29_1 = var_0_16.tab_size
	local var_29_2 = var_0_16.tab_list_entry_spacing

	return math.max(var_29_1[2] * var_29_0 + var_29_2 * (var_29_0 - 1), 0) + arg_29_0:_get_active_tabs_height()
end

HeroViewStateAchievements._get_active_tabs_height = function (arg_30_0)
	local var_30_0 = arg_30_0._active_tab
	local var_30_1 = var_30_0 and var_30_0.style.list_style.num_draws or 0
	local var_30_2 = var_0_16.tab_list_entry_size
	local var_30_3 = var_0_16.tab_list_entry_spacing

	return (math.max(var_30_2[2] * var_30_1 + var_30_3 * (var_30_1 - 1), 0))
end

HeroViewStateAchievements._get_active_category_height = function (arg_31_0)
	local var_31_0 = (arg_31_0._active_tab_index or 1) - 1
	local var_31_1 = var_0_16.tab_size
	local var_31_2 = var_0_16.tab_list_entry_spacing
	local var_31_3 = math.max(var_31_1[2] * var_31_0 + var_31_2 * (var_31_0 - 1), 0)
	local var_31_4 = arg_31_0:_get_active_tabs_height()

	return var_31_3, var_31_1[2] + var_31_2 + var_31_4
end

HeroViewStateAchievements._setup_scrollbar = function (arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0._widgets_by_name.achievement_scrollbar
	local var_32_1 = var_32_0.scenegraph_id
	local var_32_2 = arg_32_0.ui_scenegraph[var_32_1].size[2]
	local var_32_3 = math.min(var_32_2 / arg_32_1, 1)

	var_32_0.content.scroll_bar_info.bar_height_percentage = var_32_3

	arg_32_0:_set_scrollbar_value(arg_32_2 or 0)

	local var_32_4 = 2
	local var_32_5 = math.max(var_0_24 / arg_32_0.total_scroll_height, 0) * var_32_4

	arg_32_0._widgets_by_name.achievement_window.content.scroll_amount = var_32_5
end

HeroViewStateAchievements._update_mouse_scroll_input = function (arg_33_0)
	local var_33_0 = true

	if var_33_0 then
		local var_33_1 = arg_33_0._widgets_by_name
		local var_33_2 = var_33_1.achievement_scrollbar
		local var_33_3 = var_33_1.achievement_window

		if var_33_2.content.scroll_bar_info.on_pressed then
			var_33_3.content.scroll_add = nil
		end

		local var_33_4 = var_33_3.content.scroll_value

		if not var_33_4 then
			return
		end

		local var_33_5 = var_33_2.content.scroll_bar_info.value
		local var_33_6 = arg_33_0.scroll_value

		if var_33_6 ~= var_33_4 then
			arg_33_0:_set_scrollbar_value(var_33_4)
		elseif var_33_6 ~= var_33_5 then
			arg_33_0:_set_scrollbar_value(var_33_5)
		end
	end
end

HeroViewStateAchievements._set_scrollbar_value = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.scroll_value

	if arg_34_1 then
		local var_34_1 = arg_34_0._widgets_by_name

		var_34_1.achievement_scrollbar.content.scroll_bar_info.value = arg_34_1
		var_34_1.achievement_window.content.scroll_value = arg_34_1

		arg_34_0:_update_achievement_read_index(arg_34_1)

		arg_34_0.scroll_value = arg_34_1
	end
end

HeroViewStateAchievements._update_achievement_read_index = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._achievement_widgets
	local var_35_1 = #var_35_0
	local var_35_2 = var_35_1 - var_0_26
	local var_35_3 = arg_35_0.total_scroll_height * arg_35_1
	local var_35_4 = 1
	local var_35_5 = 0

	for iter_35_0 = 1, var_35_1 do
		local var_35_6 = var_35_0[iter_35_0].content
		local var_35_7 = var_0_24

		if iter_35_0 > 1 then
			var_35_7 = var_35_7 + var_0_27
		end

		if var_35_6.expanded then
			var_35_7 = var_35_7 + var_35_6.expand_height
		end

		var_35_5 = var_35_5 + var_35_7

		if var_35_3 < var_35_5 then
			var_35_4 = math.max(iter_35_0 - 1, 1)

			break
		end
	end

	arg_35_0._achievement_draw_index = var_35_4
	arg_35_0.ui_scenegraph.achievement_root.position[2] = math.floor(var_35_3)
end

HeroViewStateAchievements._update_category_scroll_position = function (arg_36_0)
	local var_36_0 = arg_36_0._category_scrollbar:get_scrolled_length()

	if var_36_0 ~= arg_36_0._category_scrolled_length then
		arg_36_0.ui_scenegraph.category_root.local_position[2] = math.round(var_36_0)
		arg_36_0._category_scrolled_length = var_36_0
	end
end

HeroViewStateAchievements._on_achievement_pressed = function (arg_37_0, arg_37_1)
	if arg_37_0._claim_all then
		return
	end

	local var_37_0 = arg_37_1.content
	local var_37_1 = arg_37_1.style
	local var_37_2 = arg_37_1.offset
	local var_37_3 = var_37_0.can_close
	local var_37_4 = var_37_0.close_button_hotspot
	local var_37_5 = var_37_0.progress_button_hotspot

	if var_37_3 and var_37_4.is_hover then
		local var_37_6 = var_37_0.id

		arg_37_0._quest_refresh_poll_id = arg_37_0._quest_manager:refresh_daily_quest(var_37_6)

		arg_37_0:block_input()
		arg_37_0:play_sound("Play_gui_achivements_menu_destroy_item")
	elseif var_37_5.is_hover then
		var_37_5.is_hover = false

		if var_37_0.locked then
			var_37_0.dlc_on_claim = true

			arg_37_0:play_sound("Play_gui_locked_content")
		else
			arg_37_0:_claim_reward(arg_37_1)
		end
	elseif var_37_0.expandable then
		if not var_37_0.expanded then
			arg_37_0:play_sound("Play_gui_achivements_menu_item_expand")
		else
			arg_37_0:play_sound("Play_gui_achivements_menu_item_close")
		end

		var_37_0.expanded = not var_37_0.expanded

		local var_37_7 = var_37_0.expand_height
		local var_37_8 = var_37_7 / arg_37_0.total_scroll_height
		local var_37_9 = math.max(arg_37_0:_get_achievement_entries_height() - var_0_25, 0)
		local var_37_10 = arg_37_0.total_scroll_height * arg_37_0.scroll_value
		local var_37_11 = math.min(var_37_10 / var_37_9, 1)
		local var_37_12 = var_0_24 + (math.abs(var_37_2[2]) - var_37_10)

		if var_37_0.expanded then
			var_37_12 = var_37_12 + var_37_7
		end

		local var_37_13 = var_37_12 - var_0_25

		if var_37_13 > 0 then
			local var_37_14 = var_37_13 / var_37_9

			var_37_11 = math.min(var_37_11 + var_37_14, 1)
		end

		arg_37_0:_update_achievements_scroll_height(var_37_11)
	end
end

HeroViewStateAchievements._claim_reward = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_1.content.id
	local var_38_1
	local var_38_2
	local var_38_3 = arg_38_0._achievement_layout_type

	if var_38_3 == "achievements" then
		var_38_1 = arg_38_0:_claim_achievement_reward(var_38_0)
	else
		var_38_1, var_38_2 = arg_38_0:_claim_quest_reward(var_38_0)
	end

	if var_38_1 then
		arg_38_0:play_sound("Play_gui_achivements_menu_claim_reward")

		arg_38_1.content.claiming = true
		arg_38_0._reward_claim_widget = arg_38_1

		arg_38_0:block_input()

		arg_38_0._reward_poll_id = var_38_1
		arg_38_0._reward_poll_type = var_38_3
	elseif var_38_2 then
		printf("[HeroViewStateAchievements] %s", var_38_2)
	end
end

HeroViewStateAchievements._claim_multiple_rewards = function (arg_39_0, arg_39_1)
	local var_39_0
	local var_39_1
	local var_39_2 = {}

	for iter_39_0 = 1, #arg_39_1 do
		local var_39_3 = arg_39_1[iter_39_0]

		var_39_2[iter_39_0] = var_39_3.content.id
		var_39_3.content.claiming = true
	end

	local var_39_4 = arg_39_0._achievement_layout_type

	if var_39_4 == "achievements" then
		var_39_0 = arg_39_0:_claim_multiple_achievement_rewards(var_39_2)
	else
		var_39_0, var_39_1 = arg_39_0:_claim_multiple_quest_rewards(var_39_2)
	end

	arg_39_0._reward_poll_claim_all_id = var_39_0
	arg_39_0._reward_poll_type = var_39_4
	arg_39_0._quest_rewards_fail_reason = var_39_1
end

HeroViewStateAchievements._claim_quest_reward = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0._quest_manager
	local var_40_1, var_40_2 = var_40_0:can_claim_quest_rewards(arg_40_1)

	if not var_40_1 then
		print("[HeroViewStateAchievements]:_claim_quest_reward()", var_40_1, var_40_2, arg_40_1)

		return nil, nil
	end

	local var_40_3, var_40_4 = var_40_0:claim_reward(arg_40_1)

	return var_40_3, var_40_4
end

HeroViewStateAchievements._claim_multiple_quest_rewards = function (arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0._quest_manager
	local var_41_1, var_41_2, var_41_3 = var_41_0:can_claim_multiple_quest_rewards(arg_41_1)

	if not var_41_1 then
		print("[HeroViewStateAchievements]:_claim_quest_reward()", var_41_1, var_41_3, arg_41_1)

		return nil, nil
	end

	local var_41_4, var_41_5 = var_41_0:claim_multiple_quest_rewards(arg_41_1)

	return var_41_4, var_41_5
end

HeroViewStateAchievements._claim_achievement_reward = function (arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._achievement_manager
	local var_42_1, var_42_2 = var_42_0:can_claim_achievement_rewards(arg_42_1)

	if not var_42_1 then
		print("[HeroViewStateAchievements]:_claim_achievement_reward()", var_42_1, var_42_2, arg_42_1)

		return nil
	end

	return (var_42_0:claim_reward(arg_42_1))
end

HeroViewStateAchievements._claim_multiple_achievement_rewards = function (arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._achievement_manager
	local var_43_1, var_43_2, var_43_3 = var_43_0:can_claim_all_achievement_rewards(arg_43_1)

	if not var_43_1 and not var_43_2 then
		printf("[HeroViewStateAchievements]: Failed to claim achievement: %s", var_43_3)

		return nil
	end

	if var_43_2 then
		for iter_43_0 = 1, #var_43_2 do
			printf("[HeroViewStateAchievements]: %s, %s", var_43_3, var_43_2[iter_43_0])
		end
	end

	if var_43_1 then
		return (var_43_0:claim_multiple_rewards(var_43_1))
	end
end

HeroViewStateAchievements._is_polling = function (arg_44_0)
	return arg_44_0._reward_poll_id or arg_44_0._quest_refresh_poll_id or arg_44_0._reward_poll_claim_all_id
end

HeroViewStateAchievements._poll_quest_refresh = function (arg_45_0, arg_45_1)
	if not arg_45_0._quest_refresh_poll_id then
		return
	end

	if not arg_45_0._quest_manager:polling_quest_refresh() then
		arg_45_0._quest_refresh_poll_id = nil

		arg_45_0:unblock_input()

		local var_45_0 = arg_45_0._widgets_by_name.quests_button
		local var_45_1 = arg_45_0._widgets_by_name.quest_window_button

		arg_45_0:_on_layout_button_pressed(var_45_0, var_45_1, "quest")
	end
end

HeroViewStateAchievements._poll_rewards = function (arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0._reward_poll_id

	if not var_46_0 then
		return
	end

	local var_46_1
	local var_46_2 = arg_46_0._reward_poll_type

	if var_46_2 == "quest" then
		var_46_1 = arg_46_0._quest_manager:polling_quest_reward()
	elseif var_46_2 == "achievements" then
		var_46_1 = arg_46_0._achievement_manager:polling_reward()
	else
		ferror("Unknown reward_poll_type (%s)", var_46_2)
	end

	if not var_46_1 then
		arg_46_0:_on_reward_claimed(var_46_0, var_46_2)

		arg_46_0._reward_poll_id = nil
		arg_46_0._reward_poll_type = nil
	end
end

HeroViewStateAchievements._poll_all_rewards = function (arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0._reward_poll_claim_all_id

	if not var_47_0 then
		return
	end

	local var_47_1
	local var_47_2 = arg_47_0._reward_poll_type

	if not arg_47_0._reward_poll_type then
		return
	end

	if var_47_2 == "quest" then
		var_47_1 = arg_47_0._quest_manager:polling_quest_reward()
	elseif var_47_2 == "achievements" then
		var_47_1 = arg_47_0._achievement_manager:polling_reward()
	else
		ferror("Unknown reward_poll_type (%s)", var_47_2)
	end

	if not var_47_1 then
		arg_47_0:_on_all_rewards_claimed(var_47_0, var_47_2)

		arg_47_0._reward_poll_claim_all_id = nil
		arg_47_0._reward_poll_type = nil
	end
end

HeroViewStateAchievements._on_reward_claimed = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_0._reward_claim_widget
	local var_48_1 = var_48_0.content
	local var_48_2 = var_48_0.style

	var_48_1.claimed = true
	var_48_1.claiming = false
	var_48_2.reward_icon.saturated = true
	arg_48_0._reward_claim_widget = nil

	arg_48_0:_setup_reward_presentation(arg_48_1, arg_48_2)

	if arg_48_2 == "quest" then
		arg_48_0:_setup_layout("quest")

		local var_48_3 = arg_48_0._active_tab
		local var_48_4 = arg_48_0._active_tab_index

		arg_48_0:_activate_tab(var_48_3, var_48_4, 1, true)
	end

	arg_48_0:_update_new_status_for_current_tab()
	arg_48_0:_update_buttons_new_status()

	local var_48_5 = table.index_of(arg_48_0._claimable_challenge_widgets, var_48_0)

	table.swap_delete(arg_48_0._claimable_challenge_widgets, var_48_5)
	arg_48_0:_handle_claim_all_challenges()
end

HeroViewStateAchievements._on_all_rewards_claimed = function (arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0._claimable_challenge_widgets

	for iter_49_0 = 1, #var_49_0 do
		local var_49_1 = var_49_0[iter_49_0]
		local var_49_2 = var_49_1.content
		local var_49_3 = var_49_1.style

		var_49_2.claimed = true
		var_49_2.claiming = false
		var_49_3.reward_icon.saturated = true
	end

	arg_49_0._claimable_challenge_widgets = nil
	arg_49_0._has_claimable_filtered_challenges = nil

	arg_49_0:_setup_reward_presentation(arg_49_1, arg_49_2)

	if arg_49_2 == "quest" then
		arg_49_0:_setup_layout("quest")

		local var_49_4 = arg_49_0._active_tab
		local var_49_5 = arg_49_0._active_tab_index

		arg_49_0:_activate_tab(var_49_4, var_49_5, 1, true)
	end

	arg_49_0:_handle_claim_all_challenges()
	arg_49_0:_update_new_status_for_current_tab()
	arg_49_0:_update_buttons_new_status()
end

HeroViewStateAchievements._update_new_status_for_current_tab = function (arg_50_0)
	if arg_50_0._achievement_layout_type == "achievements" then
		local var_50_0 = {}

		local function var_50_1(arg_51_0)
			if arg_51_0.entries then
				for iter_51_0, iter_51_1 in ipairs(arg_51_0.entries) do
					var_50_0[#var_50_0 + 1] = iter_51_1
				end
			end

			if arg_51_0.categories then
				for iter_51_2, iter_51_3 in ipairs(arg_51_0.categories) do
					var_50_1(iter_51_3)
				end
			end
		end

		local var_50_2 = arg_50_0._active_tab
		local var_50_3 = var_50_2.content.data

		var_50_1(var_50_3)
		arg_50_0._achievement_manager:setup_achievement_data_from_list(var_50_0, false)
		arg_50_0:_setup_tab_widget(var_50_2, var_50_3)
	elseif arg_50_0._achievement_layout_type == "quest" then
		local var_50_4 = arg_50_0:_get_layout(arg_50_0._achievement_layout_type).categories
		local var_50_5 = arg_50_0._category_tab_widgets
		local var_50_6 = #var_50_5

		for iter_50_0 = 1, var_50_6 do
			local var_50_7 = var_50_4[iter_50_0]
			local var_50_8 = var_50_5[iter_50_0]

			arg_50_0:_setup_tab_widget(var_50_8, var_50_7)
		end
	end
end

HeroViewStateAchievements._setup_reward_presentation = function (arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = Managers.backend
	local var_52_1 = var_52_0:get_interface("items")
	local var_52_2

	if arg_52_2 == "quest" then
		var_52_2 = var_52_0:get_interface("quests"):get_quest_rewards(arg_52_1).loot
	elseif arg_52_2 == "achievements" then
		var_52_2 = var_52_0:get_interface("loot"):get_loot(arg_52_1)
	else
		ferror("Unknown reward_polling_type (%s)", arg_52_2)
	end

	if (var_52_2 and #var_52_2 or 0) > 0 then
		local var_52_3 = {}

		for iter_52_0, iter_52_1 in ipairs(var_52_2) do
			local var_52_4 = iter_52_1.type

			if var_52_4 == "item" or var_52_4 == "loot_chest" or CosmeticUtils.is_cosmetic_item(var_52_4) then
				local var_52_5 = iter_52_1.backend_id
				local var_52_6 = iter_52_1.amount
				local var_52_7 = {}
				local var_52_8 = var_52_1:get_item_from_id(var_52_5)
				local var_52_9 = var_52_1:get_item_masterlist_data(var_52_5).item_type
				local var_52_10 = {}
				local var_52_11, var_52_12, var_52_13 = UIUtils.get_ui_information_from_item(var_52_8)

				var_52_10[1] = Localize(var_52_12)
				var_52_10[2] = Localize("achv_menu_reward_claimed_title")
				var_52_7[#var_52_7 + 1] = {
					widget_type = "description",
					value = var_52_10
				}
				var_52_7[#var_52_7 + 1] = {
					widget_type = "item",
					value = var_52_8
				}
				var_52_3[#var_52_3 + 1] = var_52_7
			elseif var_52_4 == "keep_decoration_painting" then
				local var_52_14 = iter_52_1.keep_decoration_name
				local var_52_15 = Paintings[var_52_14]
				local var_52_16 = var_52_15.display_name
				local var_52_17 = var_52_15.description
				local var_52_18 = var_52_15.icon
				local var_52_19 = {}
				local var_52_20 = {}

				var_52_19[1] = Localize(var_52_16)
				var_52_19[2] = Localize("achv_menu_reward_claimed_title")
				var_52_20[#var_52_20 + 1] = {
					widget_type = "description",
					value = var_52_19
				}
				var_52_20[#var_52_20 + 1] = {
					widget_type = "icon",
					value = var_52_18
				}
				var_52_3[#var_52_3 + 1] = var_52_20
			elseif var_52_4 == "weapon_skin" then
				local var_52_21 = iter_52_1.weapon_skin_name
				local var_52_22 = WeaponSkins.skins[var_52_21]
				local var_52_23 = var_52_22.rarity or "plentiful"
				local var_52_24 = var_52_22.display_name
				local var_52_25 = var_52_22.description
				local var_52_26 = var_52_22.inventory_icon
				local var_52_27 = {}
				local var_52_28 = {}

				var_52_27[1] = Localize(var_52_24)
				var_52_27[2] = Localize("achv_menu_reward_claimed_title")
				var_52_28[#var_52_28 + 1] = {
					widget_type = "description",
					value = var_52_27
				}
				var_52_28[#var_52_28 + 1] = {
					widget_type = "weapon_skin",
					value = {
						icon = var_52_26,
						rarity = var_52_23
					}
				}
				var_52_3[#var_52_3 + 1] = var_52_28
			elseif var_52_4 == "currency" then
				local var_52_29, var_52_30, var_52_31 = BackendUtils.get_fake_currency_item(iter_52_1.currency_code, iter_52_1.amount)
				local var_52_32 = {
					data = var_52_29
				}
				local var_52_33 = {}
				local var_52_34, var_52_35, var_52_36 = UIUtils.get_ui_information_from_item(var_52_32)

				var_52_33[1] = Localize(var_52_35)
				var_52_33[2] = string.format(Localize(var_52_31), iter_52_1.amount)

				local var_52_37 = {}

				var_52_37[#var_52_37 + 1] = {
					widget_type = "description",
					value = var_52_33
				}
				var_52_37[#var_52_37 + 1] = {
					widget_type = "icon",
					value = var_52_32.data.icon
				}
				var_52_3[#var_52_3 + 1] = var_52_37
			end
		end

		arg_52_0:_present_reward(var_52_3)
	else
		arg_52_0:unblock_input()
	end
end

HeroViewStateAchievements._align_achievement_entries = function (arg_53_0)
	local var_53_0 = 0
	local var_53_1 = arg_53_0._achievement_widgets

	for iter_53_0, iter_53_1 in ipairs(var_53_1) do
		iter_53_1.offset[2] = -var_53_0

		local var_53_2 = iter_53_1.content
		local var_53_3 = var_0_24 + var_0_27

		if var_53_2.expanded then
			var_53_3 = var_53_3 + var_53_2.expand_height
		end

		var_53_0 = var_53_0 + var_53_3
	end
end

HeroViewStateAchievements._setup_achievement_entries_animations = function (arg_54_0)
	local var_54_0 = arg_54_0._achievement_draw_index

	if not var_54_0 then
		return
	end

	local var_54_1 = arg_54_0._achievement_widgets
	local var_54_2 = math.min(var_54_0 + var_0_26 + 1, #var_54_1)
	local var_54_3 = 0.05
	local var_54_4 = 0
	local var_54_5 = 4

	for iter_54_0, iter_54_1 in ipairs(var_54_1) do
		if var_54_0 <= iter_54_0 and iter_54_0 <= var_54_2 then
			iter_54_1.alpha_multiplier = 0
			iter_54_1.alpha_fade_in_delay = var_54_4
			iter_54_1.alpha_fade_multipler = var_54_5
			var_54_4 = var_54_4 + var_54_3
		else
			iter_54_1.alpha_multiplier = 1
		end
	end
end

HeroViewStateAchievements.transitioning = function (arg_55_0)
	if arg_55_0.exiting then
		return true
	else
		return false
	end
end

HeroViewStateAchievements._wanted_state = function (arg_56_0)
	return (arg_56_0.parent:wanted_state())
end

HeroViewStateAchievements.wanted_menu_state = function (arg_57_0)
	return arg_57_0._wanted_menu_state
end

HeroViewStateAchievements.clear_wanted_menu_state = function (arg_58_0)
	arg_58_0._wanted_menu_state = nil
end

HeroViewStateAchievements.on_exit = function (arg_59_0, arg_59_1)
	print("[HeroViewState] Exit Substate HeroViewStateAchievements")

	arg_59_0.ui_animator = nil

	if arg_59_0._fullscreen_effect_enabled then
		arg_59_0:set_fullscreen_effect_enable_state(false)
	end

	if arg_59_0.reward_popup then
		arg_59_0.reward_popup:destroy()

		arg_59_0.reward_popup = nil
	end

	if arg_59_0._looping_summary_sounds then
		arg_59_0:play_sound("Stop_gui_achivements_menu_flag_loop")
		arg_59_0:play_sound("Stop_gui_achivements_menu_daily_quest_loop")

		arg_59_0._looping_summary_sounds = false
	end

	Managers.input:disable_gamepad_cursor()
end

HeroViewStateAchievements._update_transition_timer = function (arg_60_0, arg_60_1)
	if not arg_60_0._transition_timer then
		return
	end

	if arg_60_0._transition_timer == 0 then
		arg_60_0._transition_timer = nil
	else
		arg_60_0._transition_timer = math.max(arg_60_0._transition_timer - arg_60_1, 0)
	end
end

HeroViewStateAchievements.input_service = function (arg_61_0)
	return arg_61_0.parent:input_service()
end

HeroViewStateAchievements.update = function (arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = arg_62_0._input_blocked and FAKE_INPUT_SERVICE or arg_62_0:input_service()

	if arg_62_0.reward_popup then
		arg_62_0.reward_popup:update(arg_62_1)
		arg_62_0:_handle_queued_presentations()
	end

	arg_62_0:_update_summary_quest_timers(arg_62_1)
	arg_62_0:draw(var_62_0, arg_62_1)
	arg_62_0:_update_transition_timer(arg_62_1)
	arg_62_0:_handle_claim_all_challenges()
	arg_62_0:_handle_gamepad_activity()

	local var_62_1 = arg_62_0.parent:transitioning()
	local var_62_2 = arg_62_0:_wanted_state()

	if not arg_62_0._transition_timer then
		if not var_62_1 then
			if arg_62_0:_has_active_level_vote() and not arg_62_0:_displaying_reward_presentation() and not arg_62_0:_is_polling() then
				local var_62_3 = true

				arg_62_0:close_menu(var_62_3)
			else
				arg_62_0:_handle_input(arg_62_1, arg_62_2)
				arg_62_0:_handle_input_desc()
				arg_62_0:_poll_quest_refresh(arg_62_1)
				arg_62_0:_poll_rewards(arg_62_1)
				arg_62_0:_poll_all_rewards(arg_62_1)
				arg_62_0._quest_manager:update_quests()
			end
		end

		if var_62_2 or arg_62_0._new_state then
			arg_62_0.parent:clear_wanted_state()

			return var_62_2 or arg_62_0._new_state
		end
	end

	if arg_62_0._claim_all then
		arg_62_0:_claim_multiple_rewards(arg_62_0._claimable_challenge_widgets)

		arg_62_0._claim_all = false
	end
end

HeroViewStateAchievements._has_active_level_vote = function (arg_63_0)
	local var_63_0 = arg_63_0.voting_manager

	return var_63_0:vote_in_progress() and var_63_0:is_mission_vote() and not var_63_0:has_voted(Network.peer_id())
end

HeroViewStateAchievements.post_update = function (arg_64_0, arg_64_1, arg_64_2)
	arg_64_0.ui_animator:update(arg_64_1)
	arg_64_0:_update_animations(arg_64_1)
end

HeroViewStateAchievements._update_animations = function (arg_65_0, arg_65_1)
	for iter_65_0, iter_65_1 in pairs(arg_65_0._ui_animations) do
		UIAnimation.update(iter_65_1, arg_65_1)

		if UIAnimation.completed(iter_65_1) then
			arg_65_0._ui_animations[iter_65_0] = nil
		end
	end

	local var_65_0 = arg_65_0._animations
	local var_65_1 = arg_65_0.ui_animator

	for iter_65_2, iter_65_3 in pairs(var_65_0) do
		if var_65_1:is_animation_completed(iter_65_3) then
			var_65_1:stop_animation(iter_65_3)

			var_65_0[iter_65_2] = nil
		end
	end

	local var_65_2 = arg_65_0._widgets_by_name
	local var_65_3 = arg_65_0._summary_widgets_by_name
	local var_65_4 = var_65_2.exit_button
	local var_65_5 = var_65_2.quests_button
	local var_65_6 = var_65_2.summary_button
	local var_65_7 = var_65_2.achievements_button
	local var_65_8 = var_65_3.summary_right_window_button
	local var_65_9 = var_65_3.summary_left_window_button

	UIWidgetUtils.animate_default_button(var_65_4, arg_65_1)
	UIWidgetUtils.animate_option_button(var_65_5, arg_65_1)
	UIWidgetUtils.animate_default_button(var_65_6, arg_65_1)
	UIWidgetUtils.animate_option_button(var_65_7, arg_65_1)
	arg_65_0:_animate_window_button(var_65_9, arg_65_1)
	arg_65_0:_animate_window_button(var_65_8, arg_65_1)

	local var_65_10 = arg_65_0._summary_widgets_by_name.summary_quest_book

	if not var_65_10.content.disabled then
		local var_65_11 = 0.5 + math.sin(Managers.time:time("ui") * 2) * 0.5
		local var_65_12 = math.easeOutCubic(var_65_11)

		var_65_10.offset[2] = var_65_12 * 6
	else
		var_65_10.offset[2] = 0
	end
end

HeroViewStateAchievements._set_button_force_hover = function (arg_66_0, arg_66_1, arg_66_2)
	local var_66_0 = arg_66_1.content

	;(var_66_0.button_hotspot or var_66_0.hotspot).force_hover = arg_66_2
end

HeroViewStateAchievements._handle_gamepad_filter_input = function (arg_67_0, arg_67_1, arg_67_2)
	if not arg_67_0._gamepad_filter_active then
		return false
	end

	local var_67_0 = arg_67_0:get_filter_input_service()
	local var_67_1 = arg_67_0._current_gamepad_input_selection[2]
	local var_67_2 = arg_67_0._current_gamepad_input_selection[1]
	local var_67_3 = arg_67_0._search_widgets_by_name.filters.content

	if var_67_0:get("back") or var_67_0:get("refresh") then
		arg_67_0:_enable_gamepad_filters(false)
	elseif var_67_0:get("confirm") then
		local var_67_4 = UISettings.achievement_search_definitions[var_67_1]
		local var_67_5 = var_67_4.key
		local var_67_6 = var_67_4[var_67_2][1]

		if var_67_3.query[var_67_5] == var_67_6 then
			var_67_3.query[var_67_5] = nil
		else
			var_67_3.query[var_67_5] = var_67_6
		end

		local var_67_7 = arg_67_0._search_widgets_by_name.input.content

		arg_67_0:_do_search(var_67_7.search_query)
	else
		local var_67_8 = UISettings.achievement_search_definitions
		local var_67_9 = #var_67_8
		local var_67_10 = #var_67_8[var_67_1]

		if var_67_0:get("move_down") then
			var_67_1 = math.min(var_67_1 + 1, var_67_9)
		elseif var_67_0:get("move_up") then
			var_67_1 = math.max(var_67_1 - 1, 1)
		elseif var_67_0:get("move_right") then
			var_67_2 = math.min(var_67_2 + 1, var_67_10)
		elseif var_67_0:get("move_left") then
			var_67_2 = math.max(var_67_2 - 1, 1)
		end

		if var_67_1 ~= arg_67_0._current_gamepad_input_selection[2] or var_67_2 ~= arg_67_0._current_gamepad_input_selection[1] then
			local var_67_11 = #var_67_8[var_67_1]
			local var_67_12 = math.min(var_67_2, var_67_11)

			var_67_3.gamepad_button_index = {
				var_67_12,
				var_67_1
			}
			arg_67_0._current_gamepad_input_selection[2] = var_67_1
			arg_67_0._current_gamepad_input_selection[1] = var_67_12
		end
	end

	return true
end

HeroViewStateAchievements._enable_gamepad_filters = function (arg_68_0, arg_68_1)
	arg_68_0._gamepad_filter_active = arg_68_1
	arg_68_0._gamepad_filer_selection_index = 1
	arg_68_0._search_widgets_by_name.filters.content.visible = arg_68_1

	if arg_68_1 then
		arg_68_0:block_input()
	else
		arg_68_0:unblock_input()
	end
end

HeroViewStateAchievements._handle_input = function (arg_69_0, arg_69_1, arg_69_2)
	if arg_69_0:_handle_gamepad_filter_input(arg_69_1, arg_69_2) then
		return
	end

	local var_69_0 = arg_69_0._input_blocked and FAKE_INPUT_SERVICE or arg_69_0:input_service()

	if arg_69_0:_handle_search_input(arg_69_1, arg_69_2, var_69_0) then
		return
	end

	local var_69_1 = Managers.input:is_device_active("gamepad")
	local var_69_2 = var_69_0:get("toggle_menu")
	local var_69_3 = var_69_1 and var_69_0:get("back")
	local var_69_4 = arg_69_0._widgets_by_name
	local var_69_5 = arg_69_0._summary_widgets_by_name
	local var_69_6 = arg_69_0._additional_achievement_widgets_by_name
	local var_69_7 = arg_69_0._additional_quest_widgets_by_name
	local var_69_8 = var_69_4.exit_button
	local var_69_9 = var_69_4.quests_button
	local var_69_10 = var_69_4.summary_button
	local var_69_11 = var_69_4.achievements_button
	local var_69_12 = var_69_5.summary_right_window_button
	local var_69_13 = var_69_5.summary_left_window_button
	local var_69_14 = arg_69_0._achievement_layout_type == "achievements" and var_69_6.claim_all_achievements or var_69_7.claim_all_quests

	arg_69_0:_handle_layout_buttons_hovered()

	local var_69_15 = arg_69_0._achievement_layout_type

	if var_69_1 and var_69_0:get("refresh") and var_69_15 ~= "summary" then
		arg_69_0:_enable_gamepad_filters(true)

		return
	end

	if UIUtils.is_button_hover_enter(var_69_8) then
		arg_69_0:play_sound("play_gui_equipment_button_hover")
	end

	if UIUtils.is_button_pressed(var_69_10) then
		arg_69_0:_on_layout_button_pressed(var_69_10, nil, "summary")
		arg_69_0:play_sound("Play_gui_achivements_menu_summary_tab")
	end

	if UIUtils.is_button_pressed(var_69_9) or UIUtils.is_button_pressed(var_69_13) then
		local var_69_16
		local var_69_17 = arg_69_0:_get_layout("quest")
		local var_69_18 = arg_69_0._summary_widgets_by_name

		for iter_69_0 = 1, #var_69_17.categories do
			local var_69_19 = var_69_18["summary_quest_bar_background_" .. iter_69_0]

			if UIUtils.is_button_pressed(var_69_19) then
				var_69_16 = iter_69_0

				break
			end
		end

		arg_69_0:_on_layout_button_pressed(var_69_9, var_69_13, "quest", var_69_16)
		arg_69_0:play_sound("Play_gui_achivements_menu_quest_tab")
	end

	if UIUtils.is_button_pressed(var_69_11) or UIUtils.is_button_pressed(var_69_12) then
		local var_69_20
		local var_69_21 = arg_69_0._achievement_manager:outline()
		local var_69_22 = arg_69_0._summary_widgets_by_name

		for iter_69_1 = 1, #var_69_21.categories do
			local var_69_23 = var_69_22["summary_achievement_bar_" .. iter_69_1]

			if UIUtils.is_button_pressed(var_69_23) then
				var_69_20 = iter_69_1

				break
			end
		end

		arg_69_0:_on_layout_button_pressed(var_69_11, var_69_12, "achievements", var_69_20)
		arg_69_0:play_sound("Play_gui_achivements_menu_achivements_tab")
	end

	local var_69_24 = UIUtils.is_button_hover(var_69_14, "hover_hotspot")

	if UIUtils.is_button_pressed(var_69_14) and var_69_24 then
		arg_69_0._claim_all = true
	end

	UIWidgetUtils.animate_default_button(var_69_14, arg_69_1)
	arg_69_0:_animate_claim_button(var_69_14, var_69_24, arg_69_1, arg_69_2)
	arg_69_0._category_scrollbar:update(arg_69_1, arg_69_2, false)
	arg_69_0:_update_category_scroll_position()

	for iter_69_2, iter_69_3 in ipairs(arg_69_0._category_tab_widgets) do
		if iter_69_3.content.visible then
			UIWidgetUtils.animate_default_button(iter_69_3, arg_69_1)

			if UIUtils.is_button_hover_enter(iter_69_3) then
				arg_69_0:play_sound("Play_gui_achivements_menu_hover_category")
			end

			if UIUtils.is_button_pressed(iter_69_3) then
				arg_69_0:_tab_pressed(iter_69_3, iter_69_2)
			end
		end
	end

	local var_69_25 = arg_69_0._active_tab

	if var_69_25 then
		local var_69_26 = var_69_25.content.list_content
		local var_69_27 = var_69_25.style.list_style.num_draws
		local var_69_28 = arg_69_0._active_list_index

		for iter_69_4 = 1, var_69_27 do
			local var_69_29 = var_69_26[iter_69_4]
			local var_69_30 = var_69_29.button_hotspot or var_69_29.hotspot

			if var_69_30.on_hover_enter then
				arg_69_0:play_sound("Play_gui_achivements_menu_hover_category")
			end

			if var_69_30.on_release then
				var_69_30.on_release = false

				arg_69_0:_on_tab_list_pressed(iter_69_4)
			end

			var_69_30.is_selected = var_69_28 == iter_69_4
		end
	end

	local var_69_31 = var_69_4.achievement_window
	local var_69_32 = UIUtils.is_button_hover(var_69_31)
	local var_69_33 = arg_69_0._achievement_widgets
	local var_69_34 = arg_69_0._achievement_draw_index

	if var_69_33 and var_69_34 then
		arg_69_0:_update_mouse_scroll_input()

		if var_69_32 then
			local var_69_35 = var_69_34
			local var_69_36 = math.min(var_69_34 + var_0_26 + 1, #var_69_33)

			for iter_69_5 = var_69_35, var_69_36 do
				local var_69_37 = var_69_33[iter_69_5]

				if UIUtils.is_button_hover_enter(var_69_37) then
					arg_69_0:play_sound("Play_gui_achivements_menu_hover_item")
				end

				if UIUtils.is_button_hover(var_69_37) then
					var_69_37.content.reward_button_hotspot.draw = true

					local var_69_38 = var_69_37.content.dlc_lock_hotspot

					if var_69_38 then
						var_69_38.draw = true
					end
				end

				if UIUtils.is_button_pressed(var_69_37) then
					arg_69_0:_on_achievement_pressed(var_69_37)
				end

				local var_69_39 = var_69_37.content.dlc_lock_hotspot

				if var_69_39 and var_69_39.on_release and var_69_37.content.dlc_name then
					var_69_39.on_release = false

					Managers.unlock:open_dlc_page(var_69_37.content.dlc_name)
				end
			end
		end
	end

	if var_69_2 or UIUtils.is_button_pressed(var_69_8) or var_69_3 then
		arg_69_0:play_sound("Play_hud_hover")
		arg_69_0:close_menu()

		return
	end
end

HeroViewStateAchievements._on_tab_list_pressed = function (arg_70_0, arg_70_1, arg_70_2)
	local var_70_0 = arg_70_0._active_tab_index
	local var_70_1 = arg_70_0._achievement_layout_type
	local var_70_2 = arg_70_0:_get_layout(var_70_1).categories[var_70_0].categories[arg_70_1]
	local var_70_3 = var_70_2.type
	local var_70_4 = var_70_2.entries

	arg_70_0:_create_entries(var_70_4, var_70_3, var_70_2.quest_type)

	arg_70_0._active_list_index = arg_70_1

	if not arg_70_2 then
		arg_70_0:play_sound("Play_gui_achivements_menu_select_category")
	end
end

HeroViewStateAchievements._tab_pressed = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
	if arg_71_0._active_tab and arg_71_0._active_tab ~= arg_71_1 then
		arg_71_0:_deactivate_active_tab()
	end

	arg_71_0:_activate_tab(arg_71_1, arg_71_2, arg_71_3, arg_71_4)
end

HeroViewStateAchievements._activate_tab = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4)
	arg_72_0._active_tab = arg_72_1
	arg_72_0._active_tab_index = arg_72_2

	arg_72_0:_update_new_status_for_current_tab()

	local var_72_0 = arg_72_1.content
	local var_72_1 = arg_72_1.style.list_style
	local var_72_2 = var_72_1.num_draws
	local var_72_3 = var_72_1.scenegraph_id
	local var_72_4 = arg_72_0.ui_scenegraph[var_72_3]
	local var_72_5 = var_0_16.tab_size
	local var_72_6 = var_0_16.tab_active_size
	local var_72_7 = var_0_16.tab_list_entry_size
	local var_72_8 = var_0_16.tab_list_entry_spacing
	local var_72_9 = math.max(var_72_7[2] * var_72_2 + var_72_8 * (var_72_2 - 1), 0)

	var_72_4.size[1] = var_72_6[1]
	var_72_4.size[2] = var_72_9
	var_72_0.button_hotspot.is_selected = true

	local var_72_10 = var_72_0.data
	local var_72_11 = var_72_10 and var_72_10.entries
	local var_72_12 = var_72_10 and var_72_10.categories

	if var_72_10 then
		local var_72_13 = var_72_10.quest_type

		if var_72_13 == "daily" then
			arg_72_0._timer_title = Localize("achv_menu_summary_quest_refresh")
			arg_72_0._active_quest_tab_timer_type = "daily"
		elseif var_72_13 == "weekly" then
			arg_72_0._timer_title = Localize("achv_menu_summary_quest_refresh")
			arg_72_0._active_quest_tab_timer_type = "weekly"
		elseif var_72_13 == "event" then
			arg_72_0._timer_title = Localize("join_popup_timer_title") .. ":"
			arg_72_0._active_quest_tab_timer_type = "event"
		end
	end

	if var_72_11 then
		local var_72_14 = var_72_10.type

		arg_72_0._active_list_index = nil

		arg_72_0:_create_entries(var_72_11, var_72_14, var_72_10.quest_type)

		var_72_0.active = false
		var_72_0.list_content.active = false
	else
		arg_72_0:_show_empty_entries_warning()

		arg_72_0._achievement_widgets = nil
	end

	if var_72_12 then
		var_72_0.active = true
		var_72_0.list_content.active = true

		if not arg_72_4 then
			arg_72_0:play_sound("Play_gui_achivements_menu_expand_category")
		end

		if var_72_11 then
			arg_72_0._active_list_index = nil
		else
			local var_72_15 = arg_72_3 or 1

			arg_72_0:_on_tab_list_pressed(var_72_15, true)
		end
	elseif not arg_72_4 then
		arg_72_0:play_sound("Play_gui_achivements_menu_select_category")
	end

	arg_72_0:_update_categories_scroll_height()
end

HeroViewStateAchievements._deactivate_active_tab = function (arg_73_0)
	local var_73_0 = arg_73_0._active_tab

	if not var_73_0 then
		return
	end

	arg_73_0._active_tab = nil
	arg_73_0._active_tab_index = nil

	local var_73_1 = var_73_0.content
	local var_73_2 = var_73_0.style.list_style.scenegraph_id
	local var_73_3 = arg_73_0.ui_scenegraph[var_73_2]
	local var_73_4 = var_0_16.tab_size

	var_73_3.size[1] = var_73_4[1]
	var_73_3.size[2] = 0
	var_73_1.active = false
	var_73_1.list_content.active = false
	var_73_1.button_hotspot.is_selected = false

	arg_73_0:_update_categories_scroll_height()
end

HeroViewStateAchievements.close_menu = function (arg_74_0, arg_74_1)
	if not arg_74_1 then
		arg_74_0:play_sound("Play_gui_achivements_menu_close")
	end

	arg_74_1 = true

	arg_74_0.parent:close_menu(nil, arg_74_1)
end

HeroViewStateAchievements.draw = function (arg_75_0, arg_75_1, arg_75_2)
	local var_75_0 = arg_75_0.ui_renderer
	local var_75_1 = arg_75_0.ui_top_renderer
	local var_75_2 = arg_75_0.ui_scenegraph
	local var_75_3 = arg_75_0.input_manager
	local var_75_4 = arg_75_0.render_settings
	local var_75_5 = var_75_3:is_device_active("gamepad")

	UIRenderer.begin_pass(var_75_0, var_75_2, arg_75_1, arg_75_2, nil, var_75_4)

	local var_75_6 = var_75_4.snap_pixel_positions
	local var_75_7 = var_75_4.alpha_multiplier or 1

	UIRenderer.draw_all_widgets(var_75_0, arg_75_0._search_widgets)

	for iter_75_0, iter_75_1 in ipairs(arg_75_0._widgets) do
		if iter_75_1.snap_pixel_positions ~= nil then
			var_75_4.snap_pixel_positions = iter_75_1.snap_pixel_positions
		end

		var_75_4.alpha_multiplier = iter_75_1.alpha_multiplier or var_75_7

		UIRenderer.draw_widget(var_75_0, iter_75_1)

		var_75_4.snap_pixel_positions = var_75_6
	end

	if arg_75_0:_is_polling() then
		for iter_75_2, iter_75_3 in ipairs(arg_75_0._overlay_widgets) do
			if iter_75_3.snap_pixel_positions ~= nil then
				var_75_4.snap_pixel_positions = iter_75_3.snap_pixel_positions
			end

			var_75_4.alpha_multiplier = iter_75_3.alpha_multiplier or var_75_7

			UIRenderer.draw_widget(var_75_0, iter_75_3)

			var_75_4.snap_pixel_positions = var_75_6
		end
	end

	if arg_75_0._draw_summary then
		for iter_75_4, iter_75_5 in ipairs(arg_75_0._summary_widgets) do
			if iter_75_5.snap_pixel_positions ~= nil then
				var_75_4.snap_pixel_positions = iter_75_5.snap_pixel_positions
			end

			var_75_4.alpha_multiplier = iter_75_5.alpha_multiplier or var_75_7

			UIRenderer.draw_widget(var_75_0, iter_75_5)

			var_75_4.snap_pixel_positions = var_75_6
		end
	elseif arg_75_0._additional_type_widgets then
		for iter_75_6, iter_75_7 in ipairs(arg_75_0._additional_type_widgets) do
			if iter_75_7.snap_pixel_positions ~= nil then
				var_75_4.snap_pixel_positions = iter_75_7.snap_pixel_positions
			end

			var_75_4.alpha_multiplier = iter_75_7.alpha_multiplier or var_75_7

			UIRenderer.draw_widget(var_75_0, iter_75_7)

			var_75_4.snap_pixel_positions = var_75_6
		end
	end

	local var_75_8 = arg_75_0._achievement_widgets
	local var_75_9 = arg_75_0._achievement_draw_index

	if var_75_8 and var_75_9 then
		local var_75_10 = var_75_9
		local var_75_11 = math.min(var_75_9 + var_0_26 + 1, #var_75_8)

		for iter_75_8 = var_75_10, var_75_11 do
			local var_75_12 = var_75_8[iter_75_8]

			if var_75_12.snap_pixel_positions ~= nil then
				var_75_4.snap_pixel_positions = var_75_12.snap_pixel_positions
			end

			local var_75_13 = var_75_12.alpha_multiplier
			local var_75_14 = var_75_12.alpha_fade_in_delay

			if var_75_14 then
				local var_75_15 = math.max(var_75_14 - arg_75_2, 0)

				if var_75_15 > 0 then
					var_75_12.alpha_fade_in_delay = var_75_15
				else
					var_75_12.alpha_fade_in_delay = nil
				end

				var_75_4.alpha_multiplier = 0
			elseif var_75_13 then
				local var_75_16 = var_75_12.alpha_fade_multipler or 1
				local var_75_17 = math.min(var_75_13 + arg_75_2 * var_75_16, 1)

				var_75_4.alpha_multiplier = math.easeInCubic(var_75_17)
				var_75_12.alpha_multiplier = var_75_17
				var_75_12.offset[1] = -40 * (1 - var_75_17)
			end

			UIRenderer.draw_widget(var_75_0, var_75_12)

			var_75_4.snap_pixel_positions = var_75_6
		end
	end

	for iter_75_9, iter_75_10 in ipairs(arg_75_0._category_tab_widgets) do
		if iter_75_10.snap_pixel_positions ~= nil then
			var_75_4.snap_pixel_positions = iter_75_10.snap_pixel_positions
		end

		local var_75_18 = iter_75_10.alpha_multiplier
		local var_75_19 = iter_75_10.alpha_fade_in_delay

		if var_75_19 then
			local var_75_20 = math.max(var_75_19 - arg_75_2, 0)

			if var_75_20 > 0 then
				iter_75_10.alpha_fade_in_delay = var_75_20
			else
				iter_75_10.alpha_fade_in_delay = nil
			end

			var_75_4.alpha_multiplier = 0
		elseif var_75_18 then
			local var_75_21 = iter_75_10.alpha_fade_multipler or 1
			local var_75_22 = math.min(var_75_18 + arg_75_2 * var_75_21, 1)

			var_75_4.alpha_multiplier = math.easeInCubic(var_75_22)
			iter_75_10.alpha_multiplier = var_75_22
		end

		UIRenderer.draw_widget(var_75_0, iter_75_10)

		var_75_4.snap_pixel_positions = var_75_6
	end

	UIRenderer.end_pass(var_75_0)

	var_75_4.alpha_multiplier = var_75_7

	if var_75_5 then
		arg_75_0.menu_input_description:draw(var_75_1, arg_75_2)
		UIRenderer.begin_pass(var_75_1, var_75_2, arg_75_1, arg_75_2)
		UIRenderer.draw_widget(var_75_1, arg_75_0._console_cursor_widget)
		UIRenderer.end_pass(var_75_1)
	end
end

HeroViewStateAchievements.play_sound = function (arg_76_0, arg_76_1)
	arg_76_0.parent:play_sound(arg_76_1)
end

HeroViewStateAchievements._start_transition_animation = function (arg_77_0, arg_77_1, arg_77_2)
	local var_77_0 = {
		wwise_world = arg_77_0.wwise_world,
		render_settings = arg_77_0.render_settings
	}
	local var_77_1 = {}
	local var_77_2 = arg_77_0.ui_animator:start_animation(arg_77_2, var_77_1, var_0_10, var_77_0)

	arg_77_0._animations[arg_77_1] = var_77_2
end

HeroViewStateAchievements.set_fullscreen_effect_enable_state = function (arg_78_0, arg_78_1)
	local var_78_0 = arg_78_0.ui_renderer.world
	local var_78_1 = World.get_data(var_78_0, "shading_environment")

	if var_78_1 then
		ShadingEnvironment.set_scalar(var_78_1, "fullscreen_blur_enabled", arg_78_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_78_1, "fullscreen_blur_amount", arg_78_1 and 0.75 or 0)
		ShadingEnvironment.apply(var_78_1)
	end

	arg_78_0._fullscreen_effect_enabled = arg_78_1
end

HeroViewStateAchievements.block_input = function (arg_79_0)
	arg_79_0._input_blocked = true
end

HeroViewStateAchievements.unblock_input = function (arg_80_0)
	arg_80_0._input_blocked = false
end

HeroViewStateAchievements.input_blocked = function (arg_81_0)
	return arg_81_0._input_blocked
end

HeroViewStateAchievements._set_summary_achievement_categories_progress = function (arg_82_0, arg_82_1)
	local var_82_0 = arg_82_0._summary_widgets_by_name
	local var_82_1 = "summary_achievement_bar_"

	for iter_82_0, iter_82_1 in ipairs(arg_82_1) do
		local var_82_2 = iter_82_1.display_name
		local var_82_3 = iter_82_1.amount
		local var_82_4 = iter_82_1.amount_claimed
		local var_82_5 = var_82_4 / var_82_3
		local var_82_6 = tostring(var_82_4) .. "/" .. tostring(var_82_3)
		local var_82_7 = Localize(var_82_2)
		local var_82_8 = var_82_0[var_82_1 .. tostring(iter_82_0)]
		local var_82_9 = var_82_8.content
		local var_82_10 = var_82_8.style

		var_82_9.title_text = var_82_7
		var_82_9.value_text = var_82_6
		var_82_9.has_star = iter_82_1.has_unclaimed

		local var_82_11 = var_82_10.experience_bar
		local var_82_12 = var_82_11.size
		local var_82_13 = var_82_11.default_size

		var_82_12[1] = math.floor(var_82_13[1] * var_82_5)
	end
end

HeroViewStateAchievements._present_reward = function (arg_83_0, arg_83_1)
	local var_83_0 = arg_83_0.reward_popup

	if arg_83_0:_displaying_reward_presentation() then
		local var_83_1 = arg_83_0._reward_presentation_queue

		var_83_1[#var_83_1 + 1] = arg_83_1
	else
		var_83_0:display_presentation(arg_83_1)

		arg_83_0._reward_presentation_active = true

		arg_83_0:block_input()
	end
end

HeroViewStateAchievements._handle_queued_presentations = function (arg_84_0)
	if arg_84_0:_is_reward_presentation_complete() or #arg_84_0._reward_presentation_queue == 0 and not arg_84_0:_displaying_reward_presentation() then
		local var_84_0 = arg_84_0._reward_presentation_queue

		if #var_84_0 > 0 then
			local var_84_1 = table.remove(var_84_0, 1)

			arg_84_0:_present_reward(var_84_1)
		elseif arg_84_0._reward_presentation_active then
			arg_84_0._reward_presentation_active = false

			arg_84_0:unblock_input()
		end
	end
end

HeroViewStateAchievements._displaying_reward_presentation = function (arg_85_0)
	return arg_85_0.reward_popup:is_presentation_active()
end

HeroViewStateAchievements._is_reward_presentation_complete = function (arg_86_0)
	return arg_86_0.reward_popup:is_presentation_complete()
end

HeroViewStateAchievements._reward_presentation_done = function (arg_87_0)
	return not arg_87_0._reward_presentation_active
end

HeroViewStateAchievements._setup_quest_summary_progress = function (arg_88_0)
	local var_88_0 = "quest"
	local var_88_1 = arg_88_0:_get_layout(var_88_0).categories
	local var_88_2 = arg_88_0._quest_manager
	local var_88_3 = var_88_2:can_refresh_daily_quest()
	local var_88_4 = Managers.unlock
	local var_88_5 = arg_88_0._summary_widgets_by_name
	local var_88_6 = "summary_quest_bar_"
	local var_88_7 = "summary_quest_bar_title_"
	local var_88_8 = "summary_quest_bar_timer_"
	local var_88_9 = 255
	local var_88_10 = Colors.get_color_table_with_alpha("font_title", 255)
	local var_88_11 = {
		255,
		80,
		80,
		80
	}
	local var_88_12 = false

	for iter_88_0, iter_88_1 in ipairs(var_88_1) do
		local var_88_13 = iter_88_1.name
		local var_88_14 = iter_88_1.entries
		local var_88_15 = iter_88_1.quest_type
		local var_88_16 = iter_88_1.max_entry_amount or 1

		if iter_88_1.max_dlc_entries then
			for iter_88_2, iter_88_3 in pairs(iter_88_1.max_dlc_entries) do
				if var_88_4:is_dlc_unlocked(iter_88_2) then
					var_88_16 = var_88_16 + iter_88_3
				end
			end
		end

		local var_88_17 = var_88_14 ~= nil
		local var_88_18 = true

		if var_88_15 == "event" then
			var_88_16 = var_88_17 and #var_88_14 or 0
			var_88_18 = var_88_17
		end

		local var_88_19 = var_88_5[var_88_8 .. tostring(iter_88_0)].style.text.text_color

		Colors.copy_to(var_88_19, var_88_18 and var_88_10 or var_88_11)

		local var_88_20 = var_88_5[var_88_7 .. tostring(iter_88_0)]

		var_88_20.content.text = Localize(var_88_13)

		local var_88_21 = var_88_20.style.text.text_color

		Colors.copy_to(var_88_21, var_88_17 and var_88_10 or var_88_11)

		local var_88_22 = var_88_5[var_88_6 .. tostring(iter_88_0)]
		local var_88_23 = var_88_22.style
		local var_88_24 = var_88_22.content
		local var_88_25 = var_88_23.refresh_icon.color

		var_88_24.slot = var_88_15 == "event" and "achievement_symbol_book_event_skull" or "achievement_symbol_book"
		var_88_25[1] = var_88_15 == "daily" and var_88_3 and var_88_17 and var_88_9 or 0

		local var_88_26 = 0
		local var_88_27 = 0
		local var_88_28 = 0

		for iter_88_4 = 1, var_88_16 do
			local var_88_29 = var_88_17 and var_88_14[iter_88_4]
			local var_88_30 = var_88_29 and var_88_2:get_data_by_id(var_88_29)
			local var_88_31 = not var_88_30
			local var_88_32

			var_88_32 = var_88_30 and var_88_30.claimed

			local var_88_33 = var_88_30 and var_88_30.completed
			local var_88_34 = var_88_30 and var_88_30.required_dlc

			if var_88_34 then
				var_88_31 = not var_88_4:is_dlc_unlocked(var_88_34)
			end

			if var_88_31 then
				var_88_26 = var_88_26 + 1
			elseif var_88_33 then
				var_88_28 = var_88_28 + 1
				var_88_12 = true
			else
				var_88_27 = var_88_27 + 1
				var_88_12 = true
			end
		end

		var_88_24.cooldown_lock = var_88_15 == "daily"
		var_88_24.locked_text = "x" .. var_88_26
		var_88_24.available_text = "x" .. var_88_27
		var_88_24.completed_text = "x" .. var_88_28
		var_88_24.has_locked = var_88_26 > 0
		var_88_24.has_available = var_88_27 > 0
		var_88_24.has_completed = var_88_28 > 0
	end

	var_88_5.summary_quest_book.content.disabled = not var_88_12
end

HeroViewStateAchievements._animate_window_button = function (arg_89_0, arg_89_1, arg_89_2)
	local var_89_0 = arg_89_1.content
	local var_89_1 = arg_89_1.style
	local var_89_2 = var_89_0.button_hotspot
	local var_89_3 = var_89_0.has_focus
	local var_89_4 = var_89_2.is_hover or var_89_3
	local var_89_5 = var_89_2.is_selected
	local var_89_6 = not var_89_5 and var_89_2.is_clicked and var_89_2.is_clicked == 0
	local var_89_7 = var_89_2.input_progress or 0
	local var_89_8 = var_89_2.hover_progress or 0
	local var_89_9 = var_89_2.selection_progress or 0
	local var_89_10 = 8
	local var_89_11 = 20

	if var_89_6 then
		var_89_7 = math.min(var_89_7 + arg_89_2 * var_89_11, 1)
	else
		var_89_7 = math.max(var_89_7 - arg_89_2 * var_89_11, 0)
	end

	local var_89_12 = math.easeOutCubic(var_89_7)
	local var_89_13 = math.easeInCubic(var_89_7)

	if var_89_4 then
		var_89_8 = math.min(var_89_8 + arg_89_2 * var_89_10, 1)
	else
		var_89_8 = math.max(var_89_8 - arg_89_2 * var_89_10, 0)
	end

	local var_89_14 = math.easeOutCubic(var_89_8)
	local var_89_15 = math.easeInCubic(var_89_8)

	if var_89_5 then
		var_89_9 = math.min(var_89_9 + arg_89_2 * var_89_10, 1)
	else
		var_89_9 = math.max(var_89_9 - arg_89_2 * var_89_10, 0)
	end

	local var_89_16 = math.easeOutCubic(var_89_9)
	local var_89_17 = math.easeInCubic(var_89_9)
	local var_89_18 = math.max(var_89_8, var_89_9)
	local var_89_19 = math.max(var_89_16, var_89_14)
	local var_89_20 = math.max(var_89_15, var_89_17)
	local var_89_21 = 255 * var_89_18

	var_89_1.hover_frame.color[1] = var_89_21

	local var_89_22 = arg_89_1.scenegraph_id
	local var_89_23 = var_89_0.background.uvs

	arg_89_0:_set_uvs_scale_progress(var_89_22, var_89_23, var_89_18)

	var_89_2.hover_progress = var_89_8
	var_89_2.input_progress = var_89_7
	var_89_2.selection_progress = var_89_9
end

HeroViewStateAchievements._set_uvs_scale_progress = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	local var_90_0 = arg_90_0.ui_scenegraph[arg_90_1].size
	local var_90_1 = 10
	local var_90_2 = var_90_1 / var_90_0[1] * arg_90_3
	local var_90_3 = var_90_1 / var_90_0[2] * arg_90_3

	arg_90_2[1][1] = var_90_3
	arg_90_2[1][2] = var_90_2
	arg_90_2[2][1] = 1 - var_90_3
	arg_90_2[2][2] = 1 - var_90_2
end

HeroViewStateAchievements._handle_input_desc = function (arg_91_0)
	local var_91_0 = arg_91_0._search_widgets_by_name.filters.content.query
	local var_91_1

	if arg_91_0._achievement_layout_type == "summary" or arg_91_0._gamepad_filter_active then
		-- Nothing
	else
		var_91_1 = not table.is_empty(var_91_0) and "filter_available" or "filter_unavailable"
	end

	if var_91_1 ~= arg_91_0._current_input_desc then
		arg_91_0.menu_input_description:set_input_description(var_0_19[var_91_1])

		arg_91_0._current_input_desc = var_91_1
	end
end

HeroViewStateAchievements._handle_search_input = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3)
	local var_92_0 = arg_92_0._search_widgets_by_name.input.content
	local var_92_1 = arg_92_0._search_widgets_by_name.filters.content

	if var_92_0.clear_hotspot.on_pressed then
		var_92_0.search_query, var_92_0.caret_index, var_92_0.text_index = "", 1, 1

		arg_92_0:_do_search(var_92_0.search_query)

		return true
	end

	if var_92_1.query_dirty then
		arg_92_0:_do_search(var_92_0.search_query)

		var_92_1.query_dirty = false
	end

	local var_92_2 = var_92_0.search_filters_hotspot.on_pressed

	if var_92_1.visible and (arg_92_3:get("toggle_menu", true) or arg_92_3:get("back", true)) then
		var_92_2 = true
	end

	if var_92_2 then
		local var_92_3 = not var_92_1.visible

		var_92_1.visible = var_92_3
		var_92_0.filters_active = var_92_3

		return false
	end

	if arg_92_3:get("special_1") and arg_92_0._achievement_layout_type ~= "summary" and not table.is_empty(var_92_1.query) then
		table.clear(var_92_1.query)
		arg_92_0:_do_search(var_92_0.search_query)
	end

	if not arg_92_0._keyboard_id then
		var_92_0.input_active = false

		if var_92_0.hotspot.on_pressed then
			var_92_0.input_active = true

			if IS_WINDOWS then
				arg_92_0:_set_input_blocked(true)

				arg_92_0._keyboard_id = true
			elseif IS_XB1 then
				local var_92_4 = Localize("lb_search")

				XboxInterface.show_virtual_keyboard(arg_92_0._search_query, var_92_4)

				arg_92_0._keyboard_id = true
			elseif IS_PS4 then
				local var_92_5 = Managers.account:user_id()
				local var_92_6 = Localize("lb_search")
				local var_92_7 = var_0_0.virtual_keyboard_anchor_point

				arg_92_0._keyboard_id = Managers.system_dialog:open_virtual_keyboard(var_92_5, var_92_6, arg_92_0._search_query, var_92_7)
			end

			return true
		end

		return var_92_1.visible
	end

	Managers.chat:block_chat_input_for_one_frame()

	if IS_WINDOWS then
		local var_92_8 = Keyboard.keystrokes()

		var_92_0.search_query, var_92_0.caret_index = KeystrokeHelper.parse_strokes(var_92_0.search_query, var_92_0.caret_index, "insert", var_92_8)

		if arg_92_3:get("execute_chat_input", true) then
			arg_92_0:_do_search(var_92_0.search_query)
			arg_92_0:_set_input_blocked(false)

			var_92_0.input_active = false
			arg_92_0._keyboard_id = nil
		elseif arg_92_3:get("toggle_menu", true) or arg_92_0._achievement_layout_type == "summary" or arg_92_3:get("back", true) then
			arg_92_0:_set_input_blocked(false)

			var_92_0.input_active = false
			arg_92_0._keyboard_id = nil
		end
	elseif IS_XB1 then
		if not XboxInterface.interface_active() then
			local var_92_9 = XboxInterface.get_keyboard_result()

			var_92_0.caret_index = #var_92_9

			arg_92_0:_do_search(var_92_9)

			arg_92_0._keyboard_id = nil
		end
	elseif IS_PS4 then
		local var_92_10, var_92_11, var_92_12 = Managers.system_dialog:poll_virtual_keyboard(arg_92_0._keyboard_id)

		if var_92_10 then
			if var_92_11 then
				var_92_0.caret_index = #var_92_12

				arg_92_0:_do_search(var_92_12)
			end

			arg_92_0._keyboard_id = nil
		end
	end

	if var_92_0.hotspot.on_pressed then
		return true
	end

	return var_92_1.visible
end

HeroViewStateAchievements._do_search = function (arg_93_0, arg_93_1)
	arg_93_0._search_query = arg_93_1
	arg_93_0._search_widgets_by_name.input.content.search_query = arg_93_1

	local var_93_0 = arg_93_0._achievement_layout_type
	local var_93_1 = arg_93_0:_get_layout(var_93_0)
	local var_93_2 = {}

	for iter_93_0, iter_93_1 in pairs(var_93_1.categories) do
		if iter_93_1.entries then
			table.append(var_93_2, iter_93_1.entries)
		end

		if iter_93_1.categories then
			for iter_93_2, iter_93_3 in pairs(iter_93_1.categories) do
				table.append(var_93_2, iter_93_3.entries)
			end
		end
	end

	arg_93_0:_create_entries(var_93_2, var_93_0, nil)
	arg_93_0:play_sound("Play_hud_select")
end

HeroViewStateAchievements._set_input_blocked = function (arg_94_0, arg_94_1)
	local var_94_0 = Managers.input

	if arg_94_1 then
		var_94_0:block_device_except_service("hero_view", "keyboard", 1, "search")
		var_94_0:block_device_except_service("hero_view", "mouse", 1, "search")
		var_94_0:block_device_except_service("hero_view", "gamepad", 1, "search")
	else
		var_94_0:device_unblock_all_services("keyboard")
		var_94_0:device_unblock_all_services("mouse")
		var_94_0:device_unblock_all_services("gamepad")
		var_94_0:block_device_except_service("hero_view", "keyboard", 1)
		var_94_0:block_device_except_service("hero_view", "mouse", 1)
		var_94_0:block_device_except_service("hero_view", "gamepad", 1)
	end

	arg_94_0.parent:set_input_blocked(arg_94_1)
end

HeroViewStateAchievements._handle_claim_all_challenges = function (arg_95_0)
	local var_95_0 = arg_95_0._achievement_layout_type
	local var_95_1 = arg_95_0._active_tab_index
	local var_95_2 = arg_95_0._active_list_index
	local var_95_3 = arg_95_0:_get_layout(var_95_0)
	local var_95_4 = arg_95_0._additional_achievement_widgets_by_name
	local var_95_5 = arg_95_0._additional_quest_widgets_by_name
	local var_95_6 = var_95_0 == "achievements" and var_95_4.claim_all_achievements or var_95_5.claim_all_quests

	if not arg_95_0._active_tab then
		return
	end

	local var_95_7 = var_95_3.categories

	if not var_95_7 then
		return
	end

	local var_95_8 = var_95_7[var_95_1]

	if not var_95_8 then
		return
	end

	local var_95_9 = var_95_8.categories
	local var_95_10 = var_95_9 and var_95_9[var_95_2]
	local var_95_11 = false

	if var_95_10 and var_95_2 then
		var_95_11 = arg_95_0:_has_any_unclaimed_completed_challenge_in_category(var_95_10)
	else
		var_95_11 = arg_95_0:_has_any_unclaimed_completed_challenge_in_category(var_95_8)
	end

	if (arg_95_0._claimable_challenge_widgets and #arg_95_0._claimable_challenge_widgets > 0 and true or false) and (var_95_11 or arg_95_0._has_claimable_filtered_challenges) and not script_data["eac-untrusted"] and not arg_95_0:_is_polling() then
		var_95_6.content.visible = true
	else
		var_95_6.content.visible = false
	end
end

HeroViewStateAchievements._animate_claim_button = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
	if not arg_96_1.content.visible then
		return
	end

	local var_96_0 = arg_96_1.offset
	local var_96_1 = arg_96_1.style
	local var_96_2 = 2
	local var_96_3 = var_96_0[2] < 0 and not arg_96_2 and true or false

	if var_96_0[2] < 10 and arg_96_2 then
		arg_96_0._button_hide_cooldown = nil

		local var_96_4 = 200 * arg_96_3

		if var_96_0[2] >= 10 then
			-- Nothing
		else
			var_96_0[2] = var_96_0[2] + var_96_4
		end
	end

	if not arg_96_2 then
		if not arg_96_0._button_hide_cooldown then
			arg_96_0._button_hide_cooldown = arg_96_4
		end

		local var_96_5 = 200 * arg_96_3

		if var_96_0[2] < -20 then
			arg_96_0._button_hide_cooldown = nil
		elseif arg_96_4 >= arg_96_0._button_hide_cooldown + var_96_2 then
			var_96_0[2] = var_96_0[2] - var_96_5
		end
	end

	if var_96_3 then
		var_96_1.button_glow.color[1] = 195 + 60 * math.sin(7.5 * Managers.time:time("ui"))
	end
end

HeroViewStateAchievements._handle_gamepad_activity = function (arg_97_0)
	local var_97_0 = Managers.input:is_device_active("gamepad")

	if arg_97_0._gamepad_active_last_frame ~= var_97_0 then
		arg_97_0:_enable_gamepad_filters(false)

		local var_97_1 = arg_97_0._search_widgets_by_name.filters
		local var_97_2 = var_97_1.content

		var_97_1.scenegraph_id = var_97_0 and "gamepad_search_filters" or "search_filters"
	end

	arg_97_0._gamepad_active_last_frame = var_97_0
end
