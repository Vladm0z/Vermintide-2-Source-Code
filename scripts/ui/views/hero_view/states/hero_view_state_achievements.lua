-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_achievements.lua

require("scripts/ui/reward_popup/reward_popup_ui")
require("scripts/helpers/search_utils")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_achievements_definitions")
local widgets = var_0_0.widgets
local overlay_widgets = var_0_0.overlay_widgets
local summary_widgets = var_0_0.summary_widgets
local search_widget_definitions = var_0_0.search_widget_definitions
local quest_widgets = var_0_0.quest_widgets
local achievement_widgets = var_0_0.achievement_widgets
local category_tab_widgets = var_0_0.category_tab_widgets
local quest_entry_definition = var_0_0.quest_entry_definition
local achievement_entry_definition = var_0_0.achievement_entry_definition
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local achievement_entry_size = var_0_0.achievement_entry_size
local achievement_window_size = var_0_0.achievement_window_size
local achievement_scrollbar_size = var_0_0.achievement_scrollbar_size
local checklist_entry_size = var_0_0.checklist_entry_size
local category_tab_info = var_0_0.category_tab_info
local achievement_spacing = var_0_0.achievement_spacing
local achievement_presentation_amount = var_0_0.achievement_presentation_amount
local generic_input_actions = var_0_0.generic_input_actions
local console_cursor_definition = var_0_0.console_cursor_definition
local quest_scrollbar_bottom_inset = var_0_0.quest_scrollbar_bottom_inset
local create_search_filters_widget = var_0_0.create_search_filters_widget
local var_0_23 = checklist_entry_size[2]
local var_0_24 = achievement_entry_size[2]
local var_0_25 = achievement_window_size[2]
local var_0_26 = achievement_presentation_amount
local var_0_27 = achievement_spacing

HeroViewStateAchievements = class(HeroViewStateAchievements)
HeroViewStateAchievements.NAME = "HeroViewStateAchievements"

HeroViewStateAchievements.on_enter = function (self, arg_1_1)
	-- function 1
	print("[HeroViewState] Enter Substate HeroViewStateAchievements")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.voting_manager = ingame_ui_context.voting_manager
	self.profile_synchronizer = ingame_ui_context.profile_synchronizer
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = false
	}
	self.wwise_world = arg_1_1.wwise_world
	self.ingame_ui = ingame_ui_context.ingame_ui
	self._quest_manager = Managers.state.quest
	self._achievement_manager = Managers.state.achievement
	self._claimable_challenge_widgets = {}
	self._quest_rewards_fail_reason = nil
	self._search_query = ""
	self._reward_presentation_queue = {}

	local tbl = {
		wwise_world = self.wwise_world,
		ui_renderer = self.ui_renderer,
		ui_top_renderer = self.ui_top_renderer,
		input_manager = self.input_manager
	}

	self._timer_title = Localize("achv_menu_summary_quest_refresh")
	self._active_quest_tab_timer_type = "daily"
	self.reward_popup = RewardPopupUI:new(tbl)

	self.reward_popup:set_input_manager(self.input_manager)

	self.world_previewer = arg_1_1.world_previewer
	self.platform = PLATFORM

	local player = Managers.player
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.local_player_id = ingame_ui_context.local_player_id
	self.player = local_player

	local profile_by_peer = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)
	local var_1_5 = SPProfiles[profile_by_peer]
	local display_name = var_1_5.display_name
	local character_name = var_1_5.character_name
	local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "career")
	local input_service = self:input_service()

	self.menu_input_description = MenuInputDescriptionUI:new(ingame_ui_context, self.ui_top_renderer, input_service, 5, 100, generic_input_actions.default)

	self.menu_input_description:set_input_description(nil)

	self.hero_name = display_name
	self.career_index = get
	self.profile_index = profile_by_peer
	self.is_server = self.parent.is_server
	self._current_gamepad_input_selection = {
		1,
		1
	}
	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1)
	self._achievement_manager:setup_achievement_data()
	self:_setup_achievement_progress_overview()
	self:_setup_quest_summary_progress()

	if not arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		self:_start_transition_animation("on_enter", "on_enter")
	end

	self:_update_buttons_new_status()

	local str = "summary"
	local var_1_11

	if not arg_1_1.start_state then
		if type(arg_1_1.start_state) == "table" then
			str = arg_1_1.start_state[1].layout_name

			if not arg_1_1.start_state[2] then
				var_1_11 = arg_1_1.start_state[2].tab_index
			end
		else
			str = arg_1_1.start_state
		end
	end

	local summary_button = self._widgets_by_name.summary_button

	self:_on_layout_button_pressed(summary_button, nil, str, var_1_11)
	self:play_sound("Play_gui_achivements_menu_open")
	Managers.input:enable_gamepad_cursor()
	self:_create_filter_input_service()
end

HeroViewStateAchievements._create_filter_input_service = function (arg_2_0)
	-- function 2
	local input = Managers.input

	input:create_input_service("achievement_filter", "IngameMenuKeymaps", "IngameMenuFilters", {
		hero_view = false
	})
	input:map_device_to_service("achievement_filter", "gamepad")
end

HeroViewStateAchievements.get_filter_input_service = function (arg_3_0)
	-- function 3
	return Managers.input:get_service("achievement_filter")
end

HeroViewStateAchievements._update_buttons_new_status = function (self)
	-- function 4
	local _get_layout = self:_get_layout("quest")

	self._widgets_by_name.quests_button.content.new = self:_has_any_unclaimed_completed_challenge_in_category(_get_layout)

	local _get_layout_2 = self:_get_layout("achievements")

	self._widgets_by_name.achievements_button.content.new = self:_has_any_unclaimed_completed_challenge_in_category(_get_layout_2)
end

HeroViewStateAchievements._update_summary_quest_timers = function (self, arg_5_1)
	-- function 5
	local str = "quest"
	local categories = self:_get_layout(str).categories
	local str_2 = "summary_quest_bar_timer_"
	local _summary_widgets_by_name = self._summary_widgets_by_name

	for i, v in ipairs(categories) do
		local name = v.name
		local entries = v.entries
		local quest_type = v.quest_type

		if not v.max_entry_amount then
			local num = 1
		end

		local flag

		flag = entries ~= nil

		local var_5_9

		if quest_type == "daily" then
			var_5_9 = self._quest_manager:time_until_new_daily_quest()
		elseif quest_type == "weekly" then
			var_5_9 = self._quest_manager:time_until_new_weekly_quest()
		elseif quest_type == "event" then
			var_5_9 = self._quest_manager:time_left_on_event_quest()
		end

		local var_5_10

		if not (not var_5_9 and not (var_5_9 > 0)) then
			var_5_10 = UIUtils.format_duration(var_5_9)
		else
			var_5_10 = Localize("achv_menu_summary_quests_unavailable")
			var_5_9 = 0
		end

		local content = _summary_widgets_by_name[str_2 .. tostring(i)].content

		content.text = var_5_10

		local previous_time_in_seconds = content.previous_time_in_seconds

		previous_time_in_seconds = previous_time_in_seconds or math.huge
		content.previous_time_in_seconds = var_5_9

		if not (previous_time_in_seconds < var_5_9) then
			local num_2 = 1
			local num_3 = 1

			if not (self._active_tab_index == num_2) then
				local var_5_15 = self._category_tab_widgets[num_2]

				self:_setup_layout("quest")
				self:_activate_tab(var_5_15, num_2, num_3, true)
			end

			self:_setup_quest_summary_progress()
		end

		if self._active_quest_tab_timer_type == quest_type then
			self._additional_quest_widgets_by_name.time_left_text.content.text = self._timer_title .. " " .. var_5_10
		end
	end
end

HeroViewStateAchievements.create_ui_elements = function (self, arg_6_1)
	-- function 6
	local create_category_tab_widgets_func = var_0_0.create_category_tab_widgets_func()

	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._console_cursor_widget = UIWidget.init(console_cursor_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)
	self._overlay_widgets, self._overlay_widgets_by_name = UIUtils.create_widgets(overlay_widgets)
	self._summary_widgets, self._summary_widgets_by_name = UIUtils.create_widgets(summary_widgets)
	self._additional_quest_widgets, self._additional_quest_widgets_by_name = UIUtils.create_widgets(quest_widgets)
	self._additional_achievement_widgets, self._additional_achievement_widgets_by_name = UIUtils.create_widgets(achievement_widgets)
	self._search_widgets, self._search_widgets_by_name = UIUtils.create_widgets(search_widget_definitions)
	self._category_tab_widgets = UIUtils.create_widgets(create_category_tab_widgets_func)

	for k, v in pairs(self._category_tab_widgets) do
		self:_reset_tab(v)
	end

	local var_6_1 = UIWidget.init(create_search_filters_widget("search_filters", self.ui_renderer, UISettings.achievement_search_definitions))

	self._search_widgets[#self._search_widgets + 1] = var_6_1
	self._search_widgets_by_name.filters = var_6_1

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	local left_window = self._additional_quest_widgets_by_name.left_window

	self:_set_uvs_scale_progress(left_window.scenegraph_id, left_window.content.texture_id.uvs, 1)

	local left_window_2 = self._additional_achievement_widgets_by_name.left_window

	self:_set_uvs_scale_progress(left_window_2.scenegraph_id, left_window_2.content.texture_id.uvs, 1)

	self._category_scrollbar = ScrollBarLogic:new(self._widgets_by_name.category_scrollbar)
end

local function fn(self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local entries = arg_7_1.entries

	if not entries then
		local count = #entries

		arg_7_2 = arg_7_2 + count

		for i = 1, count do
			local get_data_by_id = self:get_data_by_id(entries[i])

			if not get_data_by_id.claimed then
				arg_7_3 = arg_7_3 + 1
			elseif not get_data_by_id.completed then
				arg_7_4 = true
			end
		end
	end

	local categories = arg_7_1.categories

	if not categories then
		for j = 1, #categories do
			arg_7_2, arg_7_3, arg_7_4 = fn(self, categories[j], arg_7_2, arg_7_3, arg_7_4)
		end
	end

	return arg_7_2, arg_7_3, arg_7_4
end

HeroViewStateAchievements._setup_achievement_progress_overview = function (self)
	-- function 8
	local _achievement_manager = self._achievement_manager
	local tbl = {}
	local outline = _achievement_manager:outline()

	for i, v in ipairs(outline.categories) do
		if not v.present_progression then
			local tbl_2 = {
				display_name = v.name
			}

			tbl_2.amount, tbl_2.amount_claimed, tbl_2.has_unclaimed = fn(_achievement_manager, v, 0, 0, false)
			tbl[i] = tbl_2
		end
	end

	self:_set_summary_achievement_categories_progress(tbl)
end

HeroViewStateAchievements._handle_layout_buttons_hovered = function (self)
	-- function 9
	local _widgets_by_name = self._widgets_by_name
	local _summary_widgets_by_name = self._summary_widgets_by_name
	local exit_button = _widgets_by_name.exit_button
	local quests_button = _widgets_by_name.quests_button
	local summary_button = _widgets_by_name.summary_button
	local achievements_button = _widgets_by_name.achievements_button
	local summary_right_window_button = _summary_widgets_by_name.summary_right_window_button
	local summary_left_window_button = _summary_widgets_by_name.summary_left_window_button
	local flag = false

	if UIUtils.is_button_hover_enter(quests_button) or not UIUtils.is_button_hover_enter(summary_left_window_button) then
		self:play_sound("Play_gui_achivements_menu_hover_epic")
	end

	if UIUtils.is_button_hover_enter(achievements_button) or not UIUtils.is_button_hover_enter(summary_right_window_button) then
		flag = true
	end

	if not UIUtils.is_button_hover_enter(summary_button) then
		flag = true
	end

	if not UIUtils.is_button_hover(quests_button) then
		summary_left_window_button.content.has_focus = true
	else
		summary_left_window_button.content.has_focus = false
	end

	if not UIUtils.is_button_hover(summary_left_window_button) then
		quests_button.content.has_focus = true
	else
		quests_button.content.has_focus = false
	end

	if not UIUtils.is_button_hover(achievements_button) then
		summary_right_window_button.content.has_focus = true
	else
		summary_right_window_button.content.has_focus = false
	end

	if not UIUtils.is_button_hover(summary_right_window_button) then
		achievements_button.content.has_focus = true
	else
		achievements_button.content.has_focus = false
	end

	if not flag then
		self:play_sound("play_gui_equipment_button_hover")
	end
end

HeroViewStateAchievements._on_layout_button_pressed = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local _widgets_by_name = self._widgets_by_name
	local quests_button = _widgets_by_name.quests_button
	local summary_button = _widgets_by_name.summary_button
	local achievements_button = _widgets_by_name.achievements_button

	if not arg_10_2 then
		arg_10_2.content.has_focus = false

		table.clear(arg_10_2.content.button_hotspot)
	end

	quests_button.content.button_hotspot.is_selected = false
	summary_button.content.button_hotspot.is_selected = false
	achievements_button.content.button_hotspot.is_selected = false
	arg_10_1.content.button_hotspot.is_selected = true
	arg_10_1.content.has_focus = false

	if arg_10_3 == "summary" then
		if not self._looping_summary_sounds then
			self:play_sound("Play_gui_achivements_menu_flag_loop")
			self:play_sound("Play_gui_achivements_menu_daily_quest_loop")

			self._looping_summary_sounds = true
		end

		self._draw_summary = true

		self:_deactivate_active_tab()
		self:_reset_tabs()

		self._achievement_widgets = nil
		self._widgets_by_name.achievement_scrollbar.content.visible = false
		self._widgets_by_name.category_scrollbar.content.visible = false
		self._search_widgets_by_name.input.content.visible = false
		self._search_widgets_by_name.filters.content.visible = false
	else
		if arg_10_3 == "achievements" then
			self._additional_type_widgets = self._additional_achievement_widgets
			self._additional_type_widgets_by_name = self._additional_achievement_widgets_by_name
		else
			self._additional_type_widgets = self._additional_quest_widgets
			self._additional_type_widgets_by_name = self._additional_quest_widgets_by_name
		end

		if not self._looping_summary_sounds then
			self:play_sound("Stop_gui_achivements_menu_flag_loop")
			self:play_sound("Stop_gui_achivements_menu_daily_quest_loop")

			self._looping_summary_sounds = false
		end

		self._draw_summary = false

		self:_setup_layout(arg_10_3)

		self._widgets_by_name.achievement_scrollbar.content.visible = true
		self._widgets_by_name.category_scrollbar.content.visible = true
		self._search_widgets_by_name.input.content.visible = true

		self:_update_categories_scroll_height(0)

		arg_10_4 = arg_10_4 or 1

		local var_10_4 = self._category_tab_widgets[arg_10_4]

		self:_activate_tab(var_10_4, arg_10_4, nil, true)
	end

	self._achievement_layout_type = arg_10_3
end

HeroViewStateAchievements._reset_tabs = function (self)
	-- function 11
	for i, v in ipairs(self._category_tab_widgets) do
		self:_reset_tab(v)
	end
end

HeroViewStateAchievements._setup_layout = function (self, arg_12_1)
	-- function 12
	local _category_tab_widgets = self._category_tab_widgets
	local count = #_category_tab_widgets
	local categories = self:_get_layout(arg_12_1).categories

	for i = 1, count do
		local var_12_3 = categories[i]
		local var_12_4 = _category_tab_widgets[i]

		self:_reset_tab(var_12_4)
		self:_setup_tab_widget(var_12_4, var_12_3)
	end

	self._achievement_layout_type = arg_12_1
end

HeroViewStateAchievements._setup_tab_widget = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not arg_13_2 then
		local name = arg_13_2.name
		local var_13_1 = Localize(name)

		arg_13_1.content.title_text = var_13_1
		arg_13_1.content.data = arg_13_2
		arg_13_1.content.new = self:_has_any_unclaimed_completed_challenge_in_category(arg_13_2)

		local categories = arg_13_2.categories
		local entries = arg_13_2.entries

		if not categories then
			self:_populate_tab(arg_13_1, categories)
		end

		local flag = false

		if not (entries or categories) then
			flag = true
		end

		arg_13_1.content.visible = true
		arg_13_1.content.button_hotspot.disable_button = flag
	end
end

HeroViewStateAchievements._get_layout = function (self, arg_14_1)
	-- function 14
	if arg_14_1 == "achievements" then
		return self._achievement_manager:outline()
	elseif arg_14_1 == "quest" then
		local get_quest_outline = self._quest_manager:get_quest_outline()

		if not arg_14_1 then
			for i, v in ipairs(get_quest_outline) do
				if v.type == arg_14_1 then
					return v
				end
			end
		end

		return get_quest_outline
	end
end

HeroViewStateAchievements._reset_tab = function (arg_15_0, arg_15_1)
	-- function 15
	local content = arg_15_1.content
	local style = arg_15_1.style
	local list_style = arg_15_1.style.list_style

	content.active = false
	content.list_content.active = false
	content.button_hotspot.is_selected = false
	content.visible = false
	content.new = false
	list_style.num_draws = 0

	local scenegraph_id = list_style.scenegraph_id

	arg_15_0.ui_scenegraph[scenegraph_id].size[2] = 0
	arg_15_1.alpha_multiplier = 0
	arg_15_1.alpha_fade_in_delay = nil
	arg_15_1.alpha_fade_multipler = 5
end

local function fn_2(self, arg_16_1)
	-- function 16
	local unlock = Managers.unlock
	local entries = arg_16_1.entries

	if not entries then
		for i = 1, #entries do
			local get_data_by_id = self:get_data_by_id(entries[i])

			if not (not get_data_by_id.completed and get_data_by_id.claimed) then
				local required_dlc = get_data_by_id.required_dlc
				local required_dlc_extra = get_data_by_id.required_dlc_extra
				local is_dlc_unlocked

				if not required_dlc then
					is_dlc_unlocked = unlock:is_dlc_unlocked(required_dlc)

					if not is_dlc_unlocked then
						-- Nothing
					end
				end

				is_dlc_unlocked = not required_dlc_extra and unlock:is_dlc_unlocked(required_dlc_extra)

				::label_16_0::

				if not is_dlc_unlocked then
					return true
				end
			end
		end
	end

	local categories = arg_16_1.categories

	if not categories then
		for j = 1, #categories do
			if not fn_2(self, categories[j]) then
				return true
			end
		end
	end

	return false
end

HeroViewStateAchievements._has_any_unclaimed_completed_challenge_in_category = function (self, arg_17_1)
	-- function 17
	local type = arg_17_1.type
	local var_17_1

	if type == "achievements" then
		var_17_1 = self._achievement_manager
	elseif type == "quest" then
		var_17_1 = self._quest_manager
	else
		ferror("Invalid category type: %q", type)
	end

	return fn_2(var_17_1, arg_17_1)
end

HeroViewStateAchievements._populate_tab = function (self, arg_18_1, arg_18_2)
	-- function 18
	local content = arg_18_1.content
	local list_style = arg_18_1.style.list_style
	local list_content = content.list_content
	local tab_list_entry_size = category_tab_info.tab_list_entry_size
	local count = #arg_18_2

	content.tabs_height = tab_list_entry_size[2] * count

	for i, v in ipairs(arg_18_2) do
		local name = v.name
		local var_18_6

		var_18_6.text, var_18_6 = Localize(name), list_content[i]
		var_18_6.new = self:_has_any_unclaimed_completed_challenge_in_category(v)
	end

	list_style.num_draws = count
end

HeroViewStateAchievements._create_entries = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local _quest_manager = self._quest_manager
	local _achievement_manager = self._achievement_manager

	self._claimable_challenge_widgets = {}
	self._has_claimable_filtered_challenges = nil

	local var_19_2
	local var_19_3
	local flag = false

	if arg_19_2 == "quest" then
		var_19_2 = quest_entry_definition
		flag = arg_19_3 ~= "daily" or _quest_manager:can_refresh_daily_quest()
		var_19_3 = _quest_manager
	else
		var_19_2 = achievement_entry_definition
		var_19_3 = _achievement_manager
	end

	local _search_query = self._search_query
	local query = self._search_widgets_by_name.filters.content.query

	print("[HeroViewStateAchievements] Using search query: ", _search_query)

	local extract_queries = SearchUtils.extract_queries(_search_query, UISettings.achievement_search_definitions, query)
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}

	for i = 1, #arg_19_1 do
		local var_19_11 = arg_19_1[i]
		local get_data_by_id = var_19_3:get_data_by_id(var_19_11)

		if not (extract_queries == nil or SearchUtils.simple_search(extract_queries, get_data_by_id.name) or SearchUtils.simple_search(extract_queries, get_data_by_id.desc)) then
			-- Nothing
		else
			local set_all_challenges_claimable

			if not get_data_by_id.completed then
				set_all_challenges_claimable = script_data.set_all_challenges_claimable

				if not set_all_challenges_claimable then
					-- Nothing
				end
			end

			set_all_challenges_claimable = not GameSettingsDevelopment.read_only_backend

			::label_19_0::

			if not (query.completed == nil or query.completed ~= not set_all_challenges_claimable) then
				-- Nothing
			else
				local claimed = get_data_by_id.claimed

				if not (query.claimed == nil or query.claimed ~= not claimed) then
					-- Nothing
				else
					local flag_2 = true
					local str = Localize("dlc_not_owned") .. ":"
					local var_19_17
					local required_dlc = get_data_by_id.required_dlc

					if not (not required_dlc and Managers.unlock:is_dlc_unlocked(required_dlc)) then
						local var_19_19 = StoreDlcSettingsByName[required_dlc]

						if not var_19_19 then
							str = str .. "\n" .. Localize(var_19_19.name)
							var_19_17 = var_19_19.dlc_name
						end

						flag_2 = false
					end

					local required_dlc_extra = get_data_by_id.required_dlc_extra

					if not (not required_dlc_extra and Managers.unlock:is_dlc_unlocked(required_dlc_extra)) then
						local var_19_21 = StoreDlcSettingsByName[required_dlc_extra]

						if not var_19_21 then
							str = str .. "\n" .. Localize(var_19_21.name)
							var_19_17 = var_19_21.dlc_name
						end

						flag_2 = false
					end

					if not (query.locked == nil or query.locked ~= flag_2) then
						-- Nothing
					else
						table.clear(tbl)

						local reward = get_data_by_id.reward

						if not reward then
							if type(reward) == "string" then
								local var_19_23 = reward
								local var_19_24 = ItemMasterList[var_19_23]

								tbl.reward_item = {
									data = var_19_24
								}
								tbl.reward_icon = var_19_24.inventory_icon
								tbl.reward_icon_background = UISettings.item_rarity_textures[var_19_24.rarity]
							elseif type(reward) == "table" then
								local reward_type = reward.reward_type

								if reward_type == "item" or reward_type == "loot_chest" or not CosmeticUtils.is_cosmetic_item(reward_type) then
									local item_name = reward.item_name
									local var_19_27 = ItemMasterList[item_name]
									local custom_data = reward.custom_data
									local tbl_4 = {
										data = var_19_27
									}

									if not custom_data then
										if not custom_data.power_level then
											tbl_4.power_level = tonumber(custom_data.power_level)
										end

										if not custom_data.rarity then
											tbl_4.rarity = custom_data.rarity
										end
									end

									tbl.reward_item = tbl_4
									tbl.reward_icon = var_19_27.inventory_icon

									local item_rarity_textures = UISettings.item_rarity_textures
									local rarity = tbl_4.rarity

									rarity = rarity or var_19_27.rarity
									tbl.reward_icon_background = item_rarity_textures[rarity]
								elseif reward_type == "keep_decoration_painting" then
									local decoration_name = reward.decoration_name
									local var_19_33 = Paintings[decoration_name]
									local rarity_2 = reward.rarity

									if not rarity_2 then
										rarity_2 = var_19_33.rarity
										rarity_2 = rarity_2 or "plentiful"
									end

									tbl.reward_item = {
										data = {
											item_type = "keep_decoration_painting",
											slot_type = "keep_decoration_painting",
											information_text = "information_text_painting",
											matching_item_key = "keep_decoration_painting",
											can_wield = CanWieldAllItemTemplates,
											rarity = rarity_2,
											display_name = var_19_33.display_name,
											description = var_19_33.description
										},
										painting = decoration_name
									}
									tbl.reward_icon = var_19_33.icon
									tbl.reward_icon_background = UISettings.item_rarity_textures[rarity_2]
								elseif reward_type == "weapon_skin" then
									local weapon_skin_name = reward.weapon_skin_name
									local var_19_36 = WeaponSkins.skins[weapon_skin_name]
									local rarity_3 = var_19_36.rarity

									rarity_3 = rarity_3 or "plentiful"

									local tbl_5 = {
										data = {
											item_type = "weapon_skin",
											slot_type = "weapon_skin",
											information_text = "information_weapon_skin",
											matching_item_key = var_19_36.item_type,
											can_wield = CanWieldAllItemTemplates,
											rarity = rarity_3
										},
										skin = weapon_skin_name
									}

									tbl.reward_icon, tbl.reward_item = var_19_36.inventory_icon, tbl_5
									tbl.is_illusion = true
									tbl.reward_icon_background = UISettings.item_rarity_textures[rarity_3]
								elseif reward_type == "currency" then
									local tbl_6 = {
										data = BackendUtils.get_fake_currency_item(reward.currency_code, reward.amount)
									}
									local icon = tbl_6.data.icon
									local var_19_41 = UISettings.item_rarity_textures[tbl_6.data.rarity]

									tbl.reward_item = tbl_6
									tbl.reward_icon = icon
									tbl.reward_icon_background = var_19_41
								end
							end

							if query.reward ~= nil then
								local data = tbl.reward_item.data
								local slot_type = data.slot_type

								slot_type = slot_type or data.item_type

								if query.reward ~= slot_type then
									goto label_19_1
								end
							end

							if not (query.rarity == nil or query.rarity == tbl.reward_icon_background:gsub("^icon_bg_", "")) then
								goto label_19_1
							end
						end

						local var_19_44 = UIWidget.init(var_19_2)
						local content = var_19_44.content
						local style = var_19_44.style

						table.merge(content, tbl)

						if not flag_2 then
							if not var_19_17 then
								content.dlc_name = var_19_17
							else
								str = str .. "\n" .. Localize("lb_unknown")
							end

							content.locked_text = str
						end

						local requirements = get_data_by_id.requirements
						local progress = get_data_by_id.progress

						content.locked = not flag_2
						content.can_close = not flag and not set_all_challenges_claimable
						content.completed = set_all_challenges_claimable
						content.claimed = claimed
						content.id = var_19_11
						content.achievement_id = var_19_11
						content.original_order_index = i
						content.title = get_data_by_id.name
						content.description = get_data_by_id.desc

						local icon_2 = get_data_by_id.icon

						icon_2 = icon_2 or "icons_placeholder"
						content.icon = icon_2

						local num = 10

						if not (not requirements and not (#requirements > 0)) then
							num = num + self:_set_requirements(var_19_44, requirements)
							content.expandable = true
						else
							content.expandable = false
						end

						self:_set_achievement_expand_height(var_19_44, num)

						if not (not progress and set_all_challenges_claimable or claimed) then
							self:_set_widget_bar_progress(var_19_44, progress[1], progress[2])

							content.draw_bar = true
						else
							content.draw_bar = false
						end

						style.reward_icon.saturated = claimed

						if not set_all_challenges_claimable then
							Colors.darker(style.icon.color, 1.94)
							Colors.darker(style.progress_bar.color, 1.43)
							Colors.darker(style.background.color, 1.43)
							Colors.darker(style.icon_background.color, 1.43)
							Colors.darker(style.reward_background.color, 1.43)
							Colors.darker(style.side_detail_left.color, 1.43)
							Colors.darker(style.side_detail_right.color, 1.43)
						end

						if not set_all_challenges_claimable and claimed or not flag_2 then
							tbl_2[#tbl_2 + 1] = var_19_44
							self._claimable_challenge_widgets[#self._claimable_challenge_widgets + 1] = var_19_44
						else
							tbl_3[#tbl_3 + 1] = var_19_44
						end

						if not (not tbl_2 and #tbl_2 == 0) then
							self._has_claimable_filtered_challenges = true
						else
							self._has_claimable_filtered_challenges = false
						end
					end
				end
			end
		end

		::label_19_1::
	end

	if #tbl_3 > 1 then
		table.sort(tbl_3, function (self, arg_20_1)
			-- function 20
			local content = self.content
			local content_2 = arg_20_1.content

			if content.claimed == content_2.claimed then
				return content.original_order_index < content_2.original_order_index
			else
				return not content.claimed
			end
		end)
	end

	table.append(tbl_2, tbl_3)

	self._achievement_widgets = tbl_2
	self.scroll_value = nil

	self:_update_achievements_scroll_height()
	self:_setup_achievement_entries_animations()

	if not self._achievement_widgets[1] then
		self:_hide_empty_entries_warning()
	else
		self:_show_empty_entries_warning()
	end
end

HeroViewStateAchievements._show_empty_entries_warning = function (self)
	-- function 21
	local _additional_type_widgets_by_name = self._additional_type_widgets_by_name
	local overlay = _additional_type_widgets_by_name.overlay
	local overlay_text = _additional_type_widgets_by_name.overlay_text
	local overlay_fade = _additional_type_widgets_by_name.overlay_fade

	overlay.content.visible = true
	overlay_fade.content.visible = true
	overlay_text.content.visible = true
end

HeroViewStateAchievements._hide_empty_entries_warning = function (self)
	-- function 22
	local _additional_type_widgets_by_name = self._additional_type_widgets_by_name
	local overlay = _additional_type_widgets_by_name.overlay
	local overlay_text = _additional_type_widgets_by_name.overlay_text
	local overlay_fade = _additional_type_widgets_by_name.overlay_fade

	overlay.content.visible = false
	overlay_fade.content.visible = false
	overlay_text.content.visible = false
end

HeroViewStateAchievements._set_widget_bar_progress = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local content = arg_23_1.content
	local progress_bar = arg_23_1.style.progress_bar
	local default_size = progress_bar.default_size

	progress_bar.texture_size[1] = default_size[1] * (arg_23_2 / arg_23_3)

	local content_2 = arg_23_1.content

	content_2 = not content_2 and arg_23_1.content.achievement_id

	local var_23_4 = AchievementTemplates.achievements[content_2]

	if not var_23_4 and not var_23_4.progress_text_format_func then
		content.progress_text = var_23_4.progress_text_format_func(arg_23_2, arg_23_3)
	else
		content.progress_text = string.format("%d/%d", arg_23_2, arg_23_3)
	end
end

HeroViewStateAchievements._set_requirements = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local content = arg_24_1.content
	local style = arg_24_1.style
	local var_24_2 = var_0_23
	local num = 0

	for i, v in ipairs(arg_24_2) do
		local num_2 = (i - 1) % 2 + 1
		local var_24_5 = content["checklist_" .. num_2]
		local var_24_6 = style["checklist_" .. num_2]
		local item_styles = var_24_6.item_styles
		local num_3 = var_24_6.num_draws + 1
		local var_24_9 = var_24_5[num_3]
		local var_24_10 = item_styles[num_3]

		var_24_6.num_draws = num_3

		if num < num_3 then
			num = num_3
		end

		local name = v.name
		local progress = v.progress
		local completed = v.completed
		local var_24_14 = name

		if not progress then
			local var_24_15 = progress[1]
			local var_24_16 = progress[2]
			local str = " (" .. tostring(var_24_15) .. "/" .. tostring(var_24_16) .. ")"

			var_24_14 = var_24_14 .. str
		end

		var_24_9.text = var_24_14

		local set = Colors.set
		local color = var_24_10.checkbox_marker.color
		local flag

		flag = not completed and 255 and 0

		set(color, flag, 0, 0, 0)
	end

	return var_24_2 + num * var_0_23
end

HeroViewStateAchievements._set_achievement_expand_height = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local content = arg_25_1.content
	local style = arg_25_1.style

	content.expand_height = arg_25_2
	style.expand_background.texture_size[2] = arg_25_2
	style.expand_background_edge.offset[2] = -arg_25_2
end

HeroViewStateAchievements._update_achievements_scroll_height = function (self, arg_26_1)
	-- function 26
	local _get_achievement_entries_height = self:_get_achievement_entries_height()

	self.total_scroll_height = math.max(_get_achievement_entries_height - var_0_25, 0)

	self:_setup_scrollbar(_get_achievement_entries_height, arg_26_1)
	self:_align_achievement_entries()
end

HeroViewStateAchievements._update_categories_scroll_height = function (self, arg_27_1)
	-- function 27
	local size = scenegraph_definition.category_window_mask.size
	local size_2 = scenegraph_definition.category_scrollbar.size
	local _category_scrollbar = self._category_scrollbar
	local var_27_3 = size[2]
	local _get_category_entries_height = self:_get_category_entries_height()
	local var_27_5 = size_2[2]
	local num = 220
	local num_2 = 1

	_category_scrollbar:set_scrollbar_values(var_27_3, _get_category_entries_height, var_27_5, num, num_2)

	if not arg_27_1 then
		_category_scrollbar:set_scroll_percentage(arg_27_1)
	else
		local _get_active_category_height, var_27_9 = self:_get_active_category_height()

		_category_scrollbar:scroll_to_fit(_get_active_category_height, var_27_9)
	end
end

HeroViewStateAchievements._get_achievement_entries_height = function (self, arg_28_1)
	-- function 28
	arg_28_1 = arg_28_1 or 1

	local num = 0
	local _achievement_widgets = self._achievement_widgets

	for i = arg_28_1, #_achievement_widgets do
		local content = _achievement_widgets[i].content
		local var_28_3 = var_0_24

		if i > 1 then
			var_28_3 = var_28_3 + var_0_27
		end

		if not content.expanded then
			var_28_3 = var_28_3 + content.expand_height
		end

		num = num + var_28_3
	end

	local num_2 = 0

	if self._achievement_layout_type == "quest" then
		num_2 = quest_scrollbar_bottom_inset
	end

	return num + num_2
end

HeroViewStateAchievements._get_category_entries_height = function (self)
	-- function 29
	local count = #self._category_tab_widgets
	local tab_size = category_tab_info.tab_size
	local tab_list_entry_spacing = category_tab_info.tab_list_entry_spacing

	return math.max(tab_size[2] * count + tab_list_entry_spacing * (count - 1), 0) + self:_get_active_tabs_height()
end

HeroViewStateAchievements._get_active_tabs_height = function (self)
	-- function 30
	local _active_tab = self._active_tab
	local num_draws

	if not _active_tab then
		num_draws = _active_tab.style.list_style.num_draws

		if not num_draws then
			-- Nothing
		end
	end

	num_draws = 0

	::label_30_0::

	local tab_list_entry_size = category_tab_info.tab_list_entry_size
	local tab_list_entry_spacing = category_tab_info.tab_list_entry_spacing

	return (math.max(tab_list_entry_size[2] * num_draws + tab_list_entry_spacing * (num_draws - 1), 0))
end

HeroViewStateAchievements._get_active_category_height = function (self)
	-- function 31
	local _active_tab_index = self._active_tab_index

	_active_tab_index = _active_tab_index or 1

	local num = _active_tab_index - 1
	local tab_size = category_tab_info.tab_size
	local tab_list_entry_spacing = category_tab_info.tab_list_entry_spacing
	local max = math.max(tab_size[2] * num + tab_list_entry_spacing * (num - 1), 0)
	local _get_active_tabs_height = self:_get_active_tabs_height()

	return max, tab_size[2] + tab_list_entry_spacing + _get_active_tabs_height
end

HeroViewStateAchievements._setup_scrollbar = function (self, arg_32_1, arg_32_2)
	-- function 32
	local achievement_scrollbar = self._widgets_by_name.achievement_scrollbar
	local scenegraph_id = achievement_scrollbar.scenegraph_id
	local var_32_2 = self.ui_scenegraph[scenegraph_id].size[2]
	local min = math.min(var_32_2 / arg_32_1, 1)

	achievement_scrollbar.content.scroll_bar_info.bar_height_percentage = min

	self:_set_scrollbar_value(arg_32_2 or 0)

	local num = 2
	local num_2 = math.max(var_0_24 / self.total_scroll_height, 0) * num

	self._widgets_by_name.achievement_window.content.scroll_amount = num_2
end

HeroViewStateAchievements._update_mouse_scroll_input = function (self)
	-- function 33
	local flag = true

	if not flag then
		local _widgets_by_name = self._widgets_by_name
		local achievement_scrollbar = _widgets_by_name.achievement_scrollbar
		local achievement_window = _widgets_by_name.achievement_window

		if not achievement_scrollbar.content.scroll_bar_info.on_pressed then
			achievement_window.content.scroll_add = nil
		end

		local scroll_value = achievement_window.content.scroll_value

		if not scroll_value then
			return
		end

		local value = achievement_scrollbar.content.scroll_bar_info.value
		local scroll_value_2 = self.scroll_value

		if scroll_value_2 ~= scroll_value then
			self:_set_scrollbar_value(scroll_value)
		elseif scroll_value_2 ~= value then
			self:_set_scrollbar_value(value)
		end
	end
end

HeroViewStateAchievements._set_scrollbar_value = function (self, arg_34_1)
	-- function 34
	local scroll_value = self.scroll_value

	if not arg_34_1 then
		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.achievement_scrollbar.content.scroll_bar_info.value = arg_34_1
		_widgets_by_name.achievement_window.content.scroll_value = arg_34_1

		self:_update_achievement_read_index(arg_34_1)

		self.scroll_value = arg_34_1
	end
end

HeroViewStateAchievements._update_achievement_read_index = function (self, arg_35_1)
	-- function 35
	local _achievement_widgets = self._achievement_widgets
	local count = #_achievement_widgets
	local num = count - var_0_26
	local num_2 = self.total_scroll_height * arg_35_1
	local num_3 = 1
	local num_4 = 0

	for i = 1, count do
		local content = _achievement_widgets[i].content
		local var_35_7 = var_0_24

		if i > 1 then
			var_35_7 = var_35_7 + var_0_27
		end

		if not content.expanded then
			var_35_7 = var_35_7 + content.expand_height
		end

		num_4 = num_4 + var_35_7

		if num_2 < num_4 then
			num_3 = math.max(i - 1, 1)

			break
		end
	end

	self._achievement_draw_index = num_3
	self.ui_scenegraph.achievement_root.position[2] = math.floor(num_2)
end

HeroViewStateAchievements._update_category_scroll_position = function (self)
	-- function 36
	local get_scrolled_length = self._category_scrollbar:get_scrolled_length()

	if get_scrolled_length ~= self._category_scrolled_length then
		self.ui_scenegraph.category_root.local_position[2] = math.round(get_scrolled_length)
		self._category_scrolled_length = get_scrolled_length
	end
end

HeroViewStateAchievements._on_achievement_pressed = function (self, arg_37_1)
	-- function 37
	if not self._claim_all then
		return
	end

	local content = arg_37_1.content
	local style = arg_37_1.style
	local offset = arg_37_1.offset
	local can_close = content.can_close
	local close_button_hotspot = content.close_button_hotspot
	local progress_button_hotspot = content.progress_button_hotspot

	if not can_close and not close_button_hotspot.is_hover then
		local id = content.id

		self._quest_refresh_poll_id = self._quest_manager:refresh_daily_quest(id)

		self:block_input()
		self:play_sound("Play_gui_achivements_menu_destroy_item")
	elseif not progress_button_hotspot.is_hover then
		progress_button_hotspot.is_hover = false

		if not content.locked then
			content.dlc_on_claim = true

			self:play_sound("Play_gui_locked_content")
		else
			self:_claim_reward(arg_37_1)
		end
	elseif not content.expandable then
		if not content.expanded then
			self:play_sound("Play_gui_achivements_menu_item_expand")
		else
			self:play_sound("Play_gui_achivements_menu_item_close")
		end

		content.expanded = not content.expanded

		local expand_height = content.expand_height
		local num = expand_height / self.total_scroll_height
		local max = math.max(self:_get_achievement_entries_height() - var_0_25, 0)
		local num_2 = self.total_scroll_height * self.scroll_value
		local min = math.min(num_2 / max, 1)
		local num_3 = var_0_24 + (math.abs(offset[2]) - num_2)

		if not content.expanded then
			num_3 = num_3 + expand_height
		end

		local num_4 = num_3 - var_0_25

		if num_4 > 0 then
			local num_5 = num_4 / max

			min = math.min(min + num_5, 1)
		end

		self:_update_achievements_scroll_height(min)
	end
end

HeroViewStateAchievements._claim_reward = function (self, arg_38_1)
	-- function 38
	local id = arg_38_1.content.id
	local var_38_1
	local var_38_2
	local _achievement_layout_type = self._achievement_layout_type

	if _achievement_layout_type == "achievements" then
		var_38_1 = self:_claim_achievement_reward(id)
	else
		var_38_1, var_38_2 = self:_claim_quest_reward(id)
	end

	if not var_38_1 then
		self:play_sound("Play_gui_achivements_menu_claim_reward")

		arg_38_1.content.claiming = true
		self._reward_claim_widget = arg_38_1

		self:block_input()

		self._reward_poll_id = var_38_1
		self._reward_poll_type = _achievement_layout_type
	elseif not var_38_2 then
		printf("[HeroViewStateAchievements] %s", var_38_2)
	end
end

HeroViewStateAchievements._claim_multiple_rewards = function (self, arg_39_1)
	-- function 39
	local var_39_0
	local var_39_1
	local tbl = {}

	for i = 1, #arg_39_1 do
		local var_39_3 = arg_39_1[i]

		tbl[i] = var_39_3.content.id
		var_39_3.content.claiming = true
	end

	local _achievement_layout_type = self._achievement_layout_type

	if _achievement_layout_type == "achievements" then
		var_39_0 = self:_claim_multiple_achievement_rewards(tbl)
	else
		var_39_0, var_39_1 = self:_claim_multiple_quest_rewards(tbl)
	end

	self._reward_poll_claim_all_id = var_39_0
	self._reward_poll_type = _achievement_layout_type
	self._quest_rewards_fail_reason = var_39_1
end

HeroViewStateAchievements._claim_quest_reward = function (self, arg_40_1)
	-- function 40
	local _quest_manager = self._quest_manager
	local can_claim_quest_rewards, var_40_2 = _quest_manager:can_claim_quest_rewards(arg_40_1)

	if not can_claim_quest_rewards then
		print("[HeroViewStateAchievements]:_claim_quest_reward()", can_claim_quest_rewards, var_40_2, arg_40_1)

		return nil, nil
	end

	local claim_reward, var_40_4 = _quest_manager:claim_reward(arg_40_1)

	return claim_reward, var_40_4
end

HeroViewStateAchievements._claim_multiple_quest_rewards = function (self, arg_41_1)
	-- function 41
	local _quest_manager = self._quest_manager
	local can_claim_multiple_quest_rewards, var_41_2, var_41_3 = _quest_manager:can_claim_multiple_quest_rewards(arg_41_1)

	if not can_claim_multiple_quest_rewards then
		print("[HeroViewStateAchievements]:_claim_quest_reward()", can_claim_multiple_quest_rewards, var_41_3, arg_41_1)

		return nil, nil
	end

	local claim_multiple_quest_rewards, var_41_5 = _quest_manager:claim_multiple_quest_rewards(arg_41_1)

	return claim_multiple_quest_rewards, var_41_5
end

HeroViewStateAchievements._claim_achievement_reward = function (self, arg_42_1)
	-- function 42
	local _achievement_manager = self._achievement_manager
	local can_claim_achievement_rewards, var_42_2 = _achievement_manager:can_claim_achievement_rewards(arg_42_1)

	if not can_claim_achievement_rewards then
		print("[HeroViewStateAchievements]:_claim_achievement_reward()", can_claim_achievement_rewards, var_42_2, arg_42_1)

		return nil
	end

	return (_achievement_manager:claim_reward(arg_42_1))
end

HeroViewStateAchievements._claim_multiple_achievement_rewards = function (self, arg_43_1)
	-- function 43
	local _achievement_manager = self._achievement_manager
	local can_claim_all_achievement_rewards, var_43_2, var_43_3 = _achievement_manager:can_claim_all_achievement_rewards(arg_43_1)

	if not (can_claim_all_achievement_rewards or var_43_2) then
		printf("[HeroViewStateAchievements]: Failed to claim achievement: %s", var_43_3)

		return nil
	end

	if not var_43_2 then
		for i = 1, #var_43_2 do
			printf("[HeroViewStateAchievements]: %s, %s", var_43_3, var_43_2[i])
		end
	end

	if not can_claim_all_achievement_rewards then
		return (_achievement_manager:claim_multiple_rewards(can_claim_all_achievement_rewards))
	end
end

HeroViewStateAchievements._is_polling = function (self)
	-- function 44
	local _reward_poll_id = self._reward_poll_id

	if not _reward_poll_id then
		_reward_poll_id = self._quest_refresh_poll_id
		_reward_poll_id = _reward_poll_id or self._reward_poll_claim_all_id
	end

	return _reward_poll_id
end

HeroViewStateAchievements._poll_quest_refresh = function (self, arg_45_1)
	-- function 45
	if not self._quest_refresh_poll_id then
		return
	end

	if not self._quest_manager:polling_quest_refresh() then
		self._quest_refresh_poll_id = nil

		self:unblock_input()

		local quests_button = self._widgets_by_name.quests_button
		local quest_window_button = self._widgets_by_name.quest_window_button

		self:_on_layout_button_pressed(quests_button, quest_window_button, "quest")
	end
end

HeroViewStateAchievements._poll_rewards = function (self, arg_46_1)
	-- function 46
	local _reward_poll_id = self._reward_poll_id

	if not _reward_poll_id then
		return
	end

	local var_46_1
	local _reward_poll_type = self._reward_poll_type

	if _reward_poll_type == "quest" then
		var_46_1 = self._quest_manager:polling_quest_reward()
	elseif _reward_poll_type == "achievements" then
		var_46_1 = self._achievement_manager:polling_reward()
	else
		ferror("Unknown reward_poll_type (%s)", _reward_poll_type)
	end

	if not var_46_1 then
		self:_on_reward_claimed(_reward_poll_id, _reward_poll_type)

		self._reward_poll_id = nil
		self._reward_poll_type = nil
	end
end

HeroViewStateAchievements._poll_all_rewards = function (self, arg_47_1)
	-- function 47
	local _reward_poll_claim_all_id = self._reward_poll_claim_all_id

	if not _reward_poll_claim_all_id then
		return
	end

	local var_47_1
	local _reward_poll_type = self._reward_poll_type

	if not self._reward_poll_type then
		return
	end

	if _reward_poll_type == "quest" then
		var_47_1 = self._quest_manager:polling_quest_reward()
	elseif _reward_poll_type == "achievements" then
		var_47_1 = self._achievement_manager:polling_reward()
	else
		ferror("Unknown reward_poll_type (%s)", _reward_poll_type)
	end

	if not var_47_1 then
		self:_on_all_rewards_claimed(_reward_poll_claim_all_id, _reward_poll_type)

		self._reward_poll_claim_all_id = nil
		self._reward_poll_type = nil
	end
end

HeroViewStateAchievements._on_reward_claimed = function (self, arg_48_1, arg_48_2)
	-- function 48
	local _reward_claim_widget = self._reward_claim_widget
	local content = _reward_claim_widget.content
	local style = _reward_claim_widget.style

	content.claimed = true
	content.claiming = false
	style.reward_icon.saturated = true
	self._reward_claim_widget = nil

	self:_setup_reward_presentation(arg_48_1, arg_48_2)

	if arg_48_2 == "quest" then
		self:_setup_layout("quest")

		local _active_tab = self._active_tab
		local _active_tab_index = self._active_tab_index

		self:_activate_tab(_active_tab, _active_tab_index, 1, true)
	end

	self:_update_new_status_for_current_tab()
	self:_update_buttons_new_status()

	local index_of = table.index_of(self._claimable_challenge_widgets, _reward_claim_widget)

	table.swap_delete(self._claimable_challenge_widgets, index_of)
	self:_handle_claim_all_challenges()
end

HeroViewStateAchievements._on_all_rewards_claimed = function (self, arg_49_1, arg_49_2)
	-- function 49
	local _claimable_challenge_widgets = self._claimable_challenge_widgets

	for i = 1, #_claimable_challenge_widgets do
		local var_49_1 = _claimable_challenge_widgets[i]
		local content = var_49_1.content
		local style = var_49_1.style

		content.claimed = true
		content.claiming = false
		style.reward_icon.saturated = true
	end

	self._claimable_challenge_widgets = nil
	self._has_claimable_filtered_challenges = nil

	self:_setup_reward_presentation(arg_49_1, arg_49_2)

	if arg_49_2 == "quest" then
		self:_setup_layout("quest")

		local _active_tab = self._active_tab
		local _active_tab_index = self._active_tab_index

		self:_activate_tab(_active_tab, _active_tab_index, 1, true)
	end

	self:_handle_claim_all_challenges()
	self:_update_new_status_for_current_tab()
	self:_update_buttons_new_status()
end

HeroViewStateAchievements._update_new_status_for_current_tab = function (self)
	-- function 50
	if self._achievement_layout_type == "achievements" then
		local tbl = {}

		local function fn(self)
			-- function 51
			if not self.entries then
				for i, v in ipairs(self.entries) do
					tbl[#tbl + 1] = v
				end
			end

			if not self.categories then
				for i_2, v_2 in ipairs(self.categories) do
					fn(v_2)
				end
			end
		end

		local _active_tab = self._active_tab
		local data = _active_tab.content.data

		fn(data)
		self._achievement_manager:setup_achievement_data_from_list(tbl, false)
		self:_setup_tab_widget(_active_tab, data)
	elseif self._achievement_layout_type == "quest" then
		local categories = self:_get_layout(self._achievement_layout_type).categories
		local _category_tab_widgets = self._category_tab_widgets
		local count = #_category_tab_widgets

		for i = 1, count do
			local var_50_7 = categories[i]
			local var_50_8 = _category_tab_widgets[i]

			self:_setup_tab_widget(var_50_8, var_50_7)
		end
	end
end

HeroViewStateAchievements._setup_reward_presentation = function (self, arg_52_1, arg_52_2)
	-- function 52
	local backend = Managers.backend
	local get_interface = backend:get_interface("items")
	local var_52_2

	if arg_52_2 == "quest" then
		var_52_2 = backend:get_interface("quests"):get_quest_rewards(arg_52_1).loot
	elseif arg_52_2 == "achievements" then
		var_52_2 = backend:get_interface("loot"):get_loot(arg_52_1)
	else
		ferror("Unknown reward_polling_type (%s)", arg_52_2)
	end

	local count

	if not var_52_2 then
		count = #var_52_2

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_52_0::

	if count > 0 then
		local tbl = {}

		for i, v in ipairs(var_52_2) do
			local type = v.type

			if type == "item" or type == "loot_chest" or not CosmeticUtils.is_cosmetic_item(type) then
				local backend_id = v.backend_id
				local amount = v.amount
				local tbl_2 = {}
				local get_item_from_id = get_interface:get_item_from_id(backend_id)
				local item_type = get_interface:get_item_masterlist_data(backend_id).item_type
				local tbl_3 = {}
				local get_ui_information_from_item, var_52_13, var_52_14 = UIUtils.get_ui_information_from_item(get_item_from_id)

				tbl_3[1] = Localize(var_52_13)
				tbl_3[2] = Localize("achv_menu_reward_claimed_title")
				tbl_2[#tbl_2 + 1] = {
					widget_type = "description",
					value = tbl_3
				}
				tbl_2[#tbl_2 + 1] = {
					widget_type = "item",
					value = get_item_from_id
				}
				tbl[#tbl + 1] = tbl_2
			elseif type == "keep_decoration_painting" then
				local keep_decoration_name = v.keep_decoration_name
				local var_52_16 = Paintings[keep_decoration_name]
				local display_name = var_52_16.display_name
				local description = var_52_16.description
				local icon = var_52_16.icon
				local tbl_4 = {}
				local tbl_5 = {}

				tbl_4[1] = Localize(display_name)
				tbl_4[2] = Localize("achv_menu_reward_claimed_title")
				tbl_5[#tbl_5 + 1] = {
					widget_type = "description",
					value = tbl_4
				}
				tbl_5[#tbl_5 + 1] = {
					widget_type = "icon",
					value = icon
				}
				tbl[#tbl + 1] = tbl_5
			elseif type == "weapon_skin" then
				local weapon_skin_name = v.weapon_skin_name
				local var_52_23 = WeaponSkins.skins[weapon_skin_name]
				local rarity = var_52_23.rarity

				rarity = rarity or "plentiful"

				local display_name_2 = var_52_23.display_name
				local description_2 = var_52_23.description
				local inventory_icon = var_52_23.inventory_icon
				local tbl_6 = {}
				local tbl_7 = {}

				tbl_6[1] = Localize(display_name_2)
				tbl_6[2] = Localize("achv_menu_reward_claimed_title")
				tbl_7[#tbl_7 + 1] = {
					widget_type = "description",
					value = tbl_6
				}
				tbl_7[#tbl_7 + 1] = {
					widget_type = "weapon_skin",
					value = {
						icon = inventory_icon,
						rarity = rarity
					}
				}
				tbl[#tbl + 1] = tbl_7
			elseif type == "currency" then
				local get_fake_currency_item, var_52_31, var_52_32 = BackendUtils.get_fake_currency_item(v.currency_code, v.amount)
				local tbl_8 = {
					data = get_fake_currency_item
				}
				local tbl_9 = {}
				local get_ui_information_from_item_2, var_52_36, var_52_37 = UIUtils.get_ui_information_from_item(tbl_8)

				tbl_9[1] = Localize(var_52_36)
				tbl_9[2] = string.format(Localize(var_52_32), v.amount)

				local tbl_10 = {}

				tbl_10[#tbl_10 + 1] = {
					widget_type = "description",
					value = tbl_9
				}
				tbl_10[#tbl_10 + 1] = {
					widget_type = "icon",
					value = tbl_8.data.icon
				}
				tbl[#tbl + 1] = tbl_10
			end
		end

		self:_present_reward(tbl)
	else
		self:unblock_input()
	end
end

HeroViewStateAchievements._align_achievement_entries = function (self)
	-- function 53
	local num = 0
	local _achievement_widgets = self._achievement_widgets

	for i, v in ipairs(_achievement_widgets) do
		v.offset[2] = -num

		local content = v.content
		local num_2 = var_0_24 + var_0_27

		if not content.expanded then
			num_2 = num_2 + content.expand_height
		end

		num = num + num_2
	end
end

HeroViewStateAchievements._setup_achievement_entries_animations = function (self)
	-- function 54
	local _achievement_draw_index = self._achievement_draw_index

	if not _achievement_draw_index then
		return
	end

	local _achievement_widgets = self._achievement_widgets
	local min = math.min(_achievement_draw_index + var_0_26 + 1, #_achievement_widgets)
	local num = 0.05
	local num_2 = 0
	local num_3 = 4

	for i, v in ipairs(_achievement_widgets) do
		if not (not (_achievement_draw_index <= i) or i <= min) then
			v.alpha_multiplier = 0
			v.alpha_fade_in_delay = num_2
			v.alpha_fade_multipler = num_3
			num_2 = num_2 + num
		else
			v.alpha_multiplier = 1
		end
	end
end

HeroViewStateAchievements.transitioning = function (self)
	-- function 55
	if not self.exiting then
		return true
	else
		return false
	end
end

HeroViewStateAchievements._wanted_state = function (self)
	-- function 56
	return (self.parent:wanted_state())
end

HeroViewStateAchievements.wanted_menu_state = function (self)
	-- function 57
	return self._wanted_menu_state
end

HeroViewStateAchievements.clear_wanted_menu_state = function (self)
	-- function 58
	self._wanted_menu_state = nil
end

HeroViewStateAchievements.on_exit = function (self, arg_59_1)
	-- function 59
	print("[HeroViewState] Exit Substate HeroViewStateAchievements")

	self.ui_animator = nil

	if not self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false)
	end

	if not self.reward_popup then
		self.reward_popup:destroy()

		self.reward_popup = nil
	end

	if not self._looping_summary_sounds then
		self:play_sound("Stop_gui_achivements_menu_flag_loop")
		self:play_sound("Stop_gui_achivements_menu_daily_quest_loop")

		self._looping_summary_sounds = false
	end

	Managers.input:disable_gamepad_cursor()
end

HeroViewStateAchievements._update_transition_timer = function (self, arg_60_1)
	-- function 60
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_60_1, 0)
	end
end

HeroViewStateAchievements.input_service = function (self)
	-- function 61
	return self.parent:input_service()
end

HeroViewStateAchievements.update = function (self, arg_62_1, arg_62_2)
	-- function 62
	local FAKE_INPUT_SERVICE

	if not self._input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_62_0::

	if not self.reward_popup then
		self.reward_popup:update(arg_62_1)
		self:_handle_queued_presentations()
	end

	self:_update_summary_quest_timers(arg_62_1)
	self:draw(FAKE_INPUT_SERVICE, arg_62_1)
	self:_update_transition_timer(arg_62_1)
	self:_handle_claim_all_challenges()
	self:_handle_gamepad_activity()

	local transitioning = self.parent:transitioning()
	local _wanted_state = self:_wanted_state()

	if not self._transition_timer then
		if not transitioning then
			if not (not self:_has_active_level_vote() and self:_displaying_reward_presentation() or self:_is_polling()) then
				local flag = true

				self:close_menu(flag)
			else
				self:_handle_input(arg_62_1, arg_62_2)
				self:_handle_input_desc()
				self:_poll_quest_refresh(arg_62_1)
				self:_poll_rewards(arg_62_1)
				self:_poll_all_rewards(arg_62_1)
				self._quest_manager:update_quests()
			end
		end

		if _wanted_state or not self._new_state then
			self.parent:clear_wanted_state()

			return _wanted_state or self._new_state
		end
	end

	if not self._claim_all then
		self:_claim_multiple_rewards(self._claimable_challenge_widgets)

		self._claim_all = false
	end
end

HeroViewStateAchievements._has_active_level_vote = function (self)
	-- function 63
	local voting_manager = self.voting_manager
	local vote_in_progress = voting_manager:vote_in_progress()

	vote_in_progress = not vote_in_progress and voting_manager:is_mission_vote()

	return not vote_in_progress and not voting_manager:has_voted(Network.peer_id())
end

HeroViewStateAchievements.post_update = function (self, arg_64_1, arg_64_2)
	-- function 64
	self.ui_animator:update(arg_64_1)
	self:_update_animations(arg_64_1)
end

HeroViewStateAchievements._update_animations = function (self, arg_65_1)
	-- function 65
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_65_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name
	local _summary_widgets_by_name = self._summary_widgets_by_name
	local exit_button = _widgets_by_name.exit_button
	local quests_button = _widgets_by_name.quests_button
	local summary_button = _widgets_by_name.summary_button
	local achievements_button = _widgets_by_name.achievements_button
	local summary_right_window_button = _summary_widgets_by_name.summary_right_window_button
	local summary_left_window_button = _summary_widgets_by_name.summary_left_window_button

	UIWidgetUtils.animate_default_button(exit_button, arg_65_1)
	UIWidgetUtils.animate_option_button(quests_button, arg_65_1)
	UIWidgetUtils.animate_default_button(summary_button, arg_65_1)
	UIWidgetUtils.animate_option_button(achievements_button, arg_65_1)
	self:_animate_window_button(summary_left_window_button, arg_65_1)
	self:_animate_window_button(summary_right_window_button, arg_65_1)

	local summary_quest_book = self._summary_widgets_by_name.summary_quest_book

	if not summary_quest_book.content.disabled then
		local num = 0.5 + math.sin(Managers.time:time("ui") * 2) * 0.5
		local easeOutCubic = math.easeOutCubic(num)

		summary_quest_book.offset[2] = easeOutCubic * 6
	else
		summary_quest_book.offset[2] = 0
	end
end

HeroViewStateAchievements._set_button_force_hover = function (arg_66_0, arg_66_1, arg_66_2)
	-- function 66
	local content = arg_66_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot
	button_hotspot.force_hover = arg_66_2
end

HeroViewStateAchievements._handle_gamepad_filter_input = function (self, arg_67_1, arg_67_2)
	-- function 67
	if not self._gamepad_filter_active then
		return false
	end

	local get_filter_input_service = self:get_filter_input_service()
	local var_67_1 = self._current_gamepad_input_selection[2]
	local var_67_2 = self._current_gamepad_input_selection[1]
	local content = self._search_widgets_by_name.filters.content

	if get_filter_input_service:get("back") or not get_filter_input_service:get("refresh") then
		self:_enable_gamepad_filters(false)
	elseif not get_filter_input_service:get("confirm") then
		local var_67_4 = UISettings.achievement_search_definitions[var_67_1]
		local key = var_67_4.key
		local var_67_6 = var_67_4[var_67_2][1]

		if content.query[key] == var_67_6 then
			content.query[key] = nil
		else
			content.query[key] = var_67_6
		end

		local content_2 = self._search_widgets_by_name.input.content

		self:_do_search(content_2.search_query)
	else
		local achievement_search_definitions = UISettings.achievement_search_definitions
		local count = #achievement_search_definitions
		local count_2 = #achievement_search_definitions[var_67_1]

		if not get_filter_input_service:get("move_down") then
			var_67_1 = math.min(var_67_1 + 1, count)
		elseif not get_filter_input_service:get("move_up") then
			var_67_1 = math.max(var_67_1 - 1, 1)
		elseif not get_filter_input_service:get("move_right") then
			var_67_2 = math.min(var_67_2 + 1, count_2)
		elseif not get_filter_input_service:get("move_left") then
			var_67_2 = math.max(var_67_2 - 1, 1)
		end

		if not (var_67_1 ~= self._current_gamepad_input_selection[2] or var_67_2 == self._current_gamepad_input_selection[1]) then
			local count_3 = #achievement_search_definitions[var_67_1]
			local min = math.min(var_67_2, count_3)

			content.gamepad_button_index = {
				min,
				var_67_1
			}
			self._current_gamepad_input_selection[2] = var_67_1
			self._current_gamepad_input_selection[1] = min
		end
	end

	return true
end

HeroViewStateAchievements._enable_gamepad_filters = function (self, arg_68_1)
	-- function 68
	self._gamepad_filter_active = arg_68_1
	self._gamepad_filer_selection_index = 1
	self._search_widgets_by_name.filters.content.visible = arg_68_1

	if not arg_68_1 then
		self:block_input()
	else
		self:unblock_input()
	end
end

HeroViewStateAchievements._handle_input = function (self, arg_69_1, arg_69_2)
	-- function 69
	if not self:_handle_gamepad_filter_input(arg_69_1, arg_69_2) then
		return
	end

	local FAKE_INPUT_SERVICE

	if not self._input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_69_0::

	if not self:_handle_search_input(arg_69_1, arg_69_2, FAKE_INPUT_SERVICE) then
		return
	end

	local is_device_active = Managers.input:is_device_active("gamepad")
	local get = FAKE_INPUT_SERVICE:get("toggle_menu")
	local flag = not is_device_active and FAKE_INPUT_SERVICE:get("back")
	local _widgets_by_name = self._widgets_by_name
	local _summary_widgets_by_name = self._summary_widgets_by_name
	local _additional_achievement_widgets_by_name = self._additional_achievement_widgets_by_name
	local _additional_quest_widgets_by_name = self._additional_quest_widgets_by_name
	local exit_button = _widgets_by_name.exit_button
	local quests_button = _widgets_by_name.quests_button
	local summary_button = _widgets_by_name.summary_button
	local achievements_button = _widgets_by_name.achievements_button
	local summary_right_window_button = _summary_widgets_by_name.summary_right_window_button
	local summary_left_window_button = _summary_widgets_by_name.summary_left_window_button
	local claim_all_achievements

	if self._achievement_layout_type == "achievements" then
		claim_all_achievements = _additional_achievement_widgets_by_name.claim_all_achievements

		if not claim_all_achievements then
			-- Nothing
		end
	end

	claim_all_achievements = _additional_quest_widgets_by_name.claim_all_quests

	::label_69_1::

	self:_handle_layout_buttons_hovered()

	local _achievement_layout_type = self._achievement_layout_type

	if not (not (not is_device_active and FAKE_INPUT_SERVICE:get("refresh")) and _achievement_layout_type == "summary") then
		self:_enable_gamepad_filters(true)

		return
	end

	if not UIUtils.is_button_hover_enter(exit_button) then
		self:play_sound("play_gui_equipment_button_hover")
	end

	if not UIUtils.is_button_pressed(summary_button) then
		self:_on_layout_button_pressed(summary_button, nil, "summary")
		self:play_sound("Play_gui_achivements_menu_summary_tab")
	end

	if UIUtils.is_button_pressed(quests_button) or not UIUtils.is_button_pressed(summary_left_window_button) then
		local var_69_16
		local _get_layout = self:_get_layout("quest")
		local _summary_widgets_by_name_2 = self._summary_widgets_by_name

		for i = 1, #_get_layout.categories do
			local var_69_19 = _summary_widgets_by_name_2["summary_quest_bar_background_" .. i]

			if not UIUtils.is_button_pressed(var_69_19) then
				var_69_16 = i

				break
			end
		end

		self:_on_layout_button_pressed(quests_button, summary_left_window_button, "quest", var_69_16)
		self:play_sound("Play_gui_achivements_menu_quest_tab")
	end

	if UIUtils.is_button_pressed(achievements_button) or not UIUtils.is_button_pressed(summary_right_window_button) then
		local var_69_20
		local outline = self._achievement_manager:outline()
		local _summary_widgets_by_name_3 = self._summary_widgets_by_name

		for j = 1, #outline.categories do
			local var_69_23 = _summary_widgets_by_name_3["summary_achievement_bar_" .. j]

			if not UIUtils.is_button_pressed(var_69_23) then
				var_69_20 = j

				break
			end
		end

		self:_on_layout_button_pressed(achievements_button, summary_right_window_button, "achievements", var_69_20)
		self:play_sound("Play_gui_achivements_menu_achivements_tab")
	end

	local is_button_hover = UIUtils.is_button_hover(claim_all_achievements, "hover_hotspot")

	if not UIUtils.is_button_pressed(claim_all_achievements) and not is_button_hover then
		self._claim_all = true
	end

	UIWidgetUtils.animate_default_button(claim_all_achievements, arg_69_1)
	self:_animate_claim_button(claim_all_achievements, is_button_hover, arg_69_1, arg_69_2)
	self._category_scrollbar:update(arg_69_1, arg_69_2, false)
	self:_update_category_scroll_position()

	for i_2, v in ipairs(self._category_tab_widgets) do
		if not v.content.visible then
			UIWidgetUtils.animate_default_button(v, arg_69_1)

			if not UIUtils.is_button_hover_enter(v) then
				self:play_sound("Play_gui_achivements_menu_hover_category")
			end

			if not UIUtils.is_button_pressed(v) then
				self:_tab_pressed(v, i_2)
			end
		end
	end

	local _active_tab = self._active_tab

	if not _active_tab then
		local list_content = _active_tab.content.list_content
		local num_draws = _active_tab.style.list_style.num_draws
		local _active_list_index = self._active_list_index

		for i4 = 1, num_draws do
			local var_69_29 = list_content[i4]
			local button_hotspot = var_69_29.button_hotspot

			button_hotspot = button_hotspot or var_69_29.hotspot

			if not button_hotspot.on_hover_enter then
				self:play_sound("Play_gui_achivements_menu_hover_category")
			end

			if not button_hotspot.on_release then
				button_hotspot.on_release = false

				self:_on_tab_list_pressed(i4)
			end

			button_hotspot.is_selected = _active_list_index == i4
		end
	end

	local achievement_window = _widgets_by_name.achievement_window
	local is_button_hover_2 = UIUtils.is_button_hover(achievement_window)
	local _achievement_widgets = self._achievement_widgets
	local _achievement_draw_index = self._achievement_draw_index

	if not _achievement_widgets and not _achievement_draw_index then
		self:_update_mouse_scroll_input()

		if not is_button_hover_2 then
			local var_69_35 = _achievement_draw_index
			local min = math.min(_achievement_draw_index + var_0_26 + 1, #_achievement_widgets)

			for i5 = var_69_35, min do
				local var_69_37 = _achievement_widgets[i5]

				if not UIUtils.is_button_hover_enter(var_69_37) then
					self:play_sound("Play_gui_achivements_menu_hover_item")
				end

				if not UIUtils.is_button_hover(var_69_37) then
					var_69_37.content.reward_button_hotspot.draw = true

					local dlc_lock_hotspot = var_69_37.content.dlc_lock_hotspot

					if not dlc_lock_hotspot then
						dlc_lock_hotspot.draw = true
					end
				end

				if not UIUtils.is_button_pressed(var_69_37) then
					self:_on_achievement_pressed(var_69_37)
				end

				local dlc_lock_hotspot_2 = var_69_37.content.dlc_lock_hotspot

				if not dlc_lock_hotspot_2 and not dlc_lock_hotspot_2.on_release and not var_69_37.content.dlc_name then
					dlc_lock_hotspot_2.on_release = false

					Managers.unlock:open_dlc_page(var_69_37.content.dlc_name)
				end
			end
		end
	end

	if get or UIUtils.is_button_pressed(exit_button) or not flag then
		self:play_sound("Play_hud_hover")
		self:close_menu()

		return
	end
end

HeroViewStateAchievements._on_tab_list_pressed = function (self, arg_70_1, arg_70_2)
	-- function 70
	local _active_tab_index = self._active_tab_index
	local _achievement_layout_type = self._achievement_layout_type
	local var_70_2 = self:_get_layout(_achievement_layout_type).categories[_active_tab_index].categories[arg_70_1]
	local type = var_70_2.type
	local entries = var_70_2.entries

	self:_create_entries(entries, type, var_70_2.quest_type)

	self._active_list_index = arg_70_1

	if not arg_70_2 then
		self:play_sound("Play_gui_achivements_menu_select_category")
	end
end

HeroViewStateAchievements._tab_pressed = function (self, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
	-- function 71
	if not (not self._active_tab and self._active_tab == arg_71_1) then
		self:_deactivate_active_tab()
	end

	self:_activate_tab(arg_71_1, arg_71_2, arg_71_3, arg_71_4)
end

HeroViewStateAchievements._activate_tab = function (self, arg_72_1, arg_72_2, arg_72_3, arg_72_4)
	-- function 72
	self._active_tab = arg_72_1
	self._active_tab_index = arg_72_2

	self:_update_new_status_for_current_tab()

	local content = arg_72_1.content
	local list_style = arg_72_1.style.list_style
	local num_draws = list_style.num_draws
	local scenegraph_id = list_style.scenegraph_id
	local var_72_4 = self.ui_scenegraph[scenegraph_id]
	local tab_size = category_tab_info.tab_size
	local tab_active_size = category_tab_info.tab_active_size
	local tab_list_entry_size = category_tab_info.tab_list_entry_size
	local tab_list_entry_spacing = category_tab_info.tab_list_entry_spacing
	local max = math.max(tab_list_entry_size[2] * num_draws + tab_list_entry_spacing * (num_draws - 1), 0)

	var_72_4.size[1] = tab_active_size[1]
	var_72_4.size[2] = max
	content.button_hotspot.is_selected = true

	local data = content.data
	local flag = not data and data.entries
	local flag_2 = not data and data.categories

	if not data then
		local quest_type = data.quest_type

		if quest_type == "daily" then
			self._timer_title = Localize("achv_menu_summary_quest_refresh")
			self._active_quest_tab_timer_type = "daily"
		elseif quest_type == "weekly" then
			self._timer_title = Localize("achv_menu_summary_quest_refresh")
			self._active_quest_tab_timer_type = "weekly"
		elseif quest_type == "event" then
			self._timer_title = Localize("join_popup_timer_title") .. ":"
			self._active_quest_tab_timer_type = "event"
		end
	end

	if not flag then
		local type = data.type

		self._active_list_index = nil

		self:_create_entries(flag, type, data.quest_type)

		content.active = false
		content.list_content.active = false
	else
		self:_show_empty_entries_warning()

		self._achievement_widgets = nil
	end

	if not flag_2 then
		content.active = true
		content.list_content.active = true

		if not arg_72_4 then
			self:play_sound("Play_gui_achivements_menu_expand_category")
		end

		if not flag then
			self._active_list_index = nil
		else
			local flag_3 = arg_72_3 or 1

			self:_on_tab_list_pressed(flag_3, true)
		end
	elseif not arg_72_4 then
		self:play_sound("Play_gui_achivements_menu_select_category")
	end

	self:_update_categories_scroll_height()
end

HeroViewStateAchievements._deactivate_active_tab = function (self)
	-- function 73
	local _active_tab = self._active_tab

	if not _active_tab then
		return
	end

	self._active_tab = nil
	self._active_tab_index = nil

	local content = _active_tab.content
	local scenegraph_id = _active_tab.style.list_style.scenegraph_id
	local var_73_3 = self.ui_scenegraph[scenegraph_id]
	local tab_size = category_tab_info.tab_size

	var_73_3.size[1] = tab_size[1]
	var_73_3.size[2] = 0
	content.active = false
	content.list_content.active = false
	content.button_hotspot.is_selected = false

	self:_update_categories_scroll_height()
end

HeroViewStateAchievements.close_menu = function (self, arg_74_1)
	-- function 74
	if not arg_74_1 then
		self:play_sound("Play_gui_achivements_menu_close")
	end

	arg_74_1 = true

	self.parent:close_menu(nil, arg_74_1)
end

HeroViewStateAchievements.draw = function (self, arg_75_1, arg_75_2)
	-- function 75
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local render_settings = self.render_settings
	local is_device_active = input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_75_1, arg_75_2, nil, render_settings)

	local snap_pixel_positions = render_settings.snap_pixel_positions
	local alpha_multiplier = render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	UIRenderer.draw_all_widgets(ui_renderer, self._search_widgets)

	for i, v in ipairs(self._widgets) do
		if v.snap_pixel_positions ~= nil then
			render_settings.snap_pixel_positions = v.snap_pixel_positions
		end

		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(ui_renderer, v)

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	if not self:_is_polling() then
		for i_2, v_2 in ipairs(self._overlay_widgets) do
			if v_2.snap_pixel_positions ~= nil then
				render_settings.snap_pixel_positions = v_2.snap_pixel_positions
			end

			local alpha_multiplier_3 = v_2.alpha_multiplier

			alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
			render_settings.alpha_multiplier = alpha_multiplier_3

			UIRenderer.draw_widget(ui_renderer, v_2)

			render_settings.snap_pixel_positions = snap_pixel_positions
		end
	end

	if not self._draw_summary then
		for i_3, v_3 in ipairs(self._summary_widgets) do
			if v_3.snap_pixel_positions ~= nil then
				render_settings.snap_pixel_positions = v_3.snap_pixel_positions
			end

			local alpha_multiplier_4 = v_3.alpha_multiplier

			alpha_multiplier_4 = alpha_multiplier_4 or alpha_multiplier
			render_settings.alpha_multiplier = alpha_multiplier_4

			UIRenderer.draw_widget(ui_renderer, v_3)

			render_settings.snap_pixel_positions = snap_pixel_positions
		end
	elseif not self._additional_type_widgets then
		for i_4, v_4 in ipairs(self._additional_type_widgets) do
			if v_4.snap_pixel_positions ~= nil then
				render_settings.snap_pixel_positions = v_4.snap_pixel_positions
			end

			local alpha_multiplier_5 = v_4.alpha_multiplier

			alpha_multiplier_5 = alpha_multiplier_5 or alpha_multiplier
			render_settings.alpha_multiplier = alpha_multiplier_5

			UIRenderer.draw_widget(ui_renderer, v_4)

			render_settings.snap_pixel_positions = snap_pixel_positions
		end
	end

	local _achievement_widgets = self._achievement_widgets
	local _achievement_draw_index = self._achievement_draw_index

	if not _achievement_widgets and not _achievement_draw_index then
		local var_75_14 = _achievement_draw_index
		local min = math.min(_achievement_draw_index + var_0_26 + 1, #_achievement_widgets)

		for i8 = var_75_14, min do
			local var_75_16 = _achievement_widgets[i8]

			if var_75_16.snap_pixel_positions ~= nil then
				render_settings.snap_pixel_positions = var_75_16.snap_pixel_positions
			end

			local alpha_multiplier_6 = var_75_16.alpha_multiplier
			local alpha_fade_in_delay = var_75_16.alpha_fade_in_delay

			if not alpha_fade_in_delay then
				local max = math.max(alpha_fade_in_delay - arg_75_2, 0)

				if max > 0 then
					var_75_16.alpha_fade_in_delay = max
				else
					var_75_16.alpha_fade_in_delay = nil
				end

				render_settings.alpha_multiplier = 0
			elseif not alpha_multiplier_6 then
				local alpha_fade_multipler = var_75_16.alpha_fade_multipler

				alpha_fade_multipler = alpha_fade_multipler or 1

				local min_2 = math.min(alpha_multiplier_6 + arg_75_2 * alpha_fade_multipler, 1)

				render_settings.alpha_multiplier = math.easeInCubic(min_2)
				var_75_16.alpha_multiplier = min_2
				var_75_16.offset[1] = -40 * (1 - min_2)
			end

			UIRenderer.draw_widget(ui_renderer, var_75_16)

			render_settings.snap_pixel_positions = snap_pixel_positions
		end
	end

	for i_5, v_5 in ipairs(self._category_tab_widgets) do
		if v_5.snap_pixel_positions ~= nil then
			render_settings.snap_pixel_positions = v_5.snap_pixel_positions
		end

		local alpha_multiplier_7 = v_5.alpha_multiplier
		local alpha_fade_in_delay_2 = v_5.alpha_fade_in_delay

		if not alpha_fade_in_delay_2 then
			local max_2 = math.max(alpha_fade_in_delay_2 - arg_75_2, 0)

			if max_2 > 0 then
				v_5.alpha_fade_in_delay = max_2
			else
				v_5.alpha_fade_in_delay = nil
			end

			render_settings.alpha_multiplier = 0
		elseif not alpha_multiplier_7 then
			local alpha_fade_multipler_2 = v_5.alpha_fade_multipler

			alpha_fade_multipler_2 = alpha_fade_multipler_2 or 1

			local min_3 = math.min(alpha_multiplier_7 + arg_75_2 * alpha_fade_multipler_2, 1)

			render_settings.alpha_multiplier = math.easeInCubic(min_3)
			v_5.alpha_multiplier = min_3
		end

		UIRenderer.draw_widget(ui_renderer, v_5)

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(ui_renderer)

	render_settings.alpha_multiplier = alpha_multiplier

	if not is_device_active then
		self.menu_input_description:draw(ui_top_renderer, arg_75_2)
		UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, arg_75_1, arg_75_2)
		UIRenderer.draw_widget(ui_top_renderer, self._console_cursor_widget)
		UIRenderer.end_pass(ui_top_renderer)
	end
end

HeroViewStateAchievements.play_sound = function (self, arg_76_1)
	-- function 76
	self.parent:play_sound(arg_76_1)
end

HeroViewStateAchievements._start_transition_animation = function (self, arg_77_1, arg_77_2)
	-- function 77
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_77_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_77_1] = start_animation
end

HeroViewStateAchievements.set_fullscreen_effect_enable_state = function (self, arg_78_1)
	-- function 78
	local world = self.ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_78_3 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_78_1 and 1 and 0

		set_scalar(var_78_3, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_78_7 = get_data
		local str_2 = "fullscreen_blur_amount"
		local flag_2

		flag_2 = not arg_78_1 and 0.75 and 0

		set_scalar_2(var_78_7, str_2, flag_2)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_78_1
end

HeroViewStateAchievements.block_input = function (self)
	-- function 79
	self._input_blocked = true
end

HeroViewStateAchievements.unblock_input = function (self)
	-- function 80
	self._input_blocked = false
end

HeroViewStateAchievements.input_blocked = function (self)
	-- function 81
	return self._input_blocked
end

HeroViewStateAchievements._set_summary_achievement_categories_progress = function (self, arg_82_1)
	-- function 82
	local _summary_widgets_by_name = self._summary_widgets_by_name
	local str = "summary_achievement_bar_"

	for i, v in ipairs(arg_82_1) do
		local display_name = v.display_name
		local amount = v.amount
		local amount_claimed = v.amount_claimed
		local num = amount_claimed / amount
		local str_2 = tostring(amount_claimed) .. "/" .. tostring(amount)
		local var_82_7 = Localize(display_name)
		local var_82_8 = _summary_widgets_by_name[str .. tostring(i)]
		local content = var_82_8.content
		local style = var_82_8.style

		content.title_text = var_82_7
		content.value_text = str_2
		content.has_star = v.has_unclaimed

		local experience_bar = style.experience_bar
		local size = experience_bar.size
		local default_size = experience_bar.default_size

		size[1] = math.floor(default_size[1] * num)
	end
end

HeroViewStateAchievements._present_reward = function (self, arg_83_1)
	-- function 83
	local reward_popup = self.reward_popup

	if not self:_displaying_reward_presentation() then
		local _reward_presentation_queue = self._reward_presentation_queue

		_reward_presentation_queue[#_reward_presentation_queue + 1] = arg_83_1
	else
		reward_popup:display_presentation(arg_83_1)

		self._reward_presentation_active = true

		self:block_input()
	end
end

HeroViewStateAchievements._handle_queued_presentations = function (self)
	-- function 84
	if not (self:_is_reward_presentation_complete() or #self._reward_presentation_queue ~= 0 or self:_displaying_reward_presentation()) then
		local _reward_presentation_queue = self._reward_presentation_queue

		if #_reward_presentation_queue > 0 then
			local remove = table.remove(_reward_presentation_queue, 1)

			self:_present_reward(remove)
		elseif not self._reward_presentation_active then
			self._reward_presentation_active = false

			self:unblock_input()
		end
	end
end

HeroViewStateAchievements._displaying_reward_presentation = function (self)
	-- function 85
	return self.reward_popup:is_presentation_active()
end

HeroViewStateAchievements._is_reward_presentation_complete = function (self)
	-- function 86
	return self.reward_popup:is_presentation_complete()
end

HeroViewStateAchievements._reward_presentation_done = function (self)
	-- function 87
	return not self._reward_presentation_active
end

HeroViewStateAchievements._setup_quest_summary_progress = function (self)
	-- function 88
	local str = "quest"
	local categories = self:_get_layout(str).categories
	local _quest_manager = self._quest_manager
	local can_refresh_daily_quest = _quest_manager:can_refresh_daily_quest()
	local unlock = Managers.unlock
	local _summary_widgets_by_name = self._summary_widgets_by_name
	local str_2 = "summary_quest_bar_"
	local str_3 = "summary_quest_bar_title_"
	local str_4 = "summary_quest_bar_timer_"
	local num = 255
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_title", 255)
	local tbl = {
		255,
		80,
		80,
		80
	}
	local flag = false

	for i, v in ipairs(categories) do
		local name = v.name
		local entries = v.entries
		local quest_type = v.quest_type
		local max_entry_amount = v.max_entry_amount

		max_entry_amount = max_entry_amount or 1

		if not v.max_dlc_entries then
			for k, v_2 in pairs(v.max_dlc_entries) do
				if not unlock:is_dlc_unlocked(k) then
					max_entry_amount = max_entry_amount + v_2
				end
			end
		end

		local flag_2 = entries ~= nil
		local flag_3 = true

		if quest_type == "event" then
			max_entry_amount = not flag_2 and #entries and 0
			flag_3 = flag_2
		end

		local text_color = _summary_widgets_by_name[str_4 .. tostring(i)].style.text.text_color

		Colors.copy_to(text_color, not flag_3 and get_color_table_with_alpha and tbl)

		local var_88_20 = _summary_widgets_by_name[str_3 .. tostring(i)]

		var_88_20.content.text = Localize(name)

		local text_color_2 = var_88_20.style.text.text_color

		Colors.copy_to(text_color_2, not flag_2 and get_color_table_with_alpha and tbl)

		local var_88_22 = _summary_widgets_by_name[str_2 .. tostring(i)]
		local style = var_88_22.style
		local content = var_88_22.content
		local color = style.refresh_icon.color
		local flag_4

		flag_4 = quest_type ~= "event" or not "achievement_symbol_book_event_skull" or "achievement_symbol_book"
		content.slot = flag_4
		color[1] = not ((quest_type ~= "daily" or not can_refresh_daily_quest) and flag_2) and num and 0

		local num_2 = 0
		local num_3 = 0
		local num_4 = 0

		for i4 = 1, max_entry_amount do
			local flag_5 = not flag_2 and entries[i4]
			local flag_6 = not flag_5 and _quest_manager:get_data_by_id(flag_5)
			local flag_7 = not flag_6
			local flag_8

			flag_8 = not flag_6 and flag_6.claimed

			local flag_9 = not flag_6 and flag_6.completed
			local flag_10 = not flag_6 and flag_6.required_dlc

			if not flag_10 then
				flag_7 = not unlock:is_dlc_unlocked(flag_10)
			end

			if not flag_7 then
				num_2 = num_2 + 1
			elseif not flag_9 then
				num_4 = num_4 + 1
				flag = true
			else
				num_3 = num_3 + 1
				flag = true
			end
		end

		content.cooldown_lock = quest_type == "daily"
		content.locked_text = "x" .. num_2
		content.available_text = "x" .. num_3
		content.completed_text = "x" .. num_4
		content.has_locked = num_2 > 0
		content.has_available = num_3 > 0
		content.has_completed = num_4 > 0
	end

	_summary_widgets_by_name.summary_quest_book.content.disabled = not flag
end

HeroViewStateAchievements._animate_window_button = function (self, arg_89_1, arg_89_2)
	-- function 89
	local content = arg_89_1.content
	local style = arg_89_1.style
	local button_hotspot = content.button_hotspot
	local has_focus = content.has_focus
	local is_hover = button_hotspot.is_hover

	is_hover = is_hover or has_focus

	local is_selected = button_hotspot.is_selected
	local is_clicked

	if not is_selected then
		is_clicked = button_hotspot.is_clicked

		if not is_clicked then
			-- Nothing
		end

		if button_hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_89_1

	::label_89_0::

	is_clicked = true

	::label_89_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_89_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_89_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_89_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_89_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_89_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_89_2 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
	local num_3 = 255 * max

	style.hover_frame.color[1] = num_3

	local scenegraph_id = arg_89_1.scenegraph_id
	local uvs = content.background.uvs

	self:_set_uvs_scale_progress(scenegraph_id, uvs, max)

	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

HeroViewStateAchievements._set_uvs_scale_progress = function (self, arg_90_1, arg_90_2, arg_90_3)
	-- function 90
	local size = self.ui_scenegraph[arg_90_1].size
	local num = 10
	local num_2 = num / size[1] * arg_90_3
	local num_3 = num / size[2] * arg_90_3

	arg_90_2[1][1] = num_3
	arg_90_2[1][2] = num_2
	arg_90_2[2][1] = 1 - num_3
	arg_90_2[2][2] = 1 - num_2
end

HeroViewStateAchievements._handle_input_desc = function (self)
	-- function 91
	local query = self._search_widgets_by_name.filters.content.query
	local var_91_1

	if self._achievement_layout_type == "summary" or not self._gamepad_filter_active then
		-- Nothing
	else
		var_91_1 = table.is_empty(query) or not "filter_available" or "filter_unavailable"
	end

	if var_91_1 ~= self._current_input_desc then
		self.menu_input_description:set_input_description(generic_input_actions[var_91_1])

		self._current_input_desc = var_91_1
	end
end

HeroViewStateAchievements._handle_search_input = function (self, arg_92_1, arg_92_2, arg_92_3)
	-- function 92
	local content = self._search_widgets_by_name.input.content
	local content_2 = self._search_widgets_by_name.filters.content

	if not content.clear_hotspot.on_pressed then
		content.search_query, content.caret_index, content.text_index = "", 1, 1

		self:_do_search(content.search_query)

		return true
	end

	if not content_2.query_dirty then
		self:_do_search(content.search_query)

		content_2.query_dirty = false
	end

	local on_pressed = content.search_filters_hotspot.on_pressed

	if not content_2.visible and arg_92_3:get("toggle_menu", true) and not arg_92_3:get("back", true) then
		on_pressed = true
	end

	if not on_pressed then
		local flag = not content_2.visible

		content_2.visible = flag
		content.filters_active = flag

		return false
	end

	if not (not arg_92_3:get("special_1") and self._achievement_layout_type == "summary" or table.is_empty(content_2.query)) then
		table.clear(content_2.query)
		self:_do_search(content.search_query)
	end

	if not self._keyboard_id then
		content.input_active = false

		if not content.hotspot.on_pressed then
			content.input_active = true

			if not IS_WINDOWS then
				self:_set_input_blocked(true)

				self._keyboard_id = true
			elseif not IS_XB1 then
				local var_92_4 = Localize("lb_search")

				XboxInterface.show_virtual_keyboard(self._search_query, var_92_4)

				self._keyboard_id = true
			elseif not IS_PS4 then
				local user_id = Managers.account:user_id()
				local var_92_6 = Localize("lb_search")
				local virtual_keyboard_anchor_point = var_0_0.virtual_keyboard_anchor_point

				self._keyboard_id = Managers.system_dialog:open_virtual_keyboard(user_id, var_92_6, self._search_query, virtual_keyboard_anchor_point)
			end

			return true
		end

		return content_2.visible
	end

	Managers.chat:block_chat_input_for_one_frame()

	if not IS_WINDOWS then
		local keystrokes = Keyboard.keystrokes()

		content.search_query, content.caret_index = KeystrokeHelper.parse_strokes(content.search_query, content.caret_index, "insert", keystrokes)

		if not arg_92_3:get("execute_chat_input", true) then
			self:_do_search(content.search_query)
			self:_set_input_blocked(false)

			content.input_active = false
			self._keyboard_id = nil
		elseif arg_92_3:get("toggle_menu", true) or self._achievement_layout_type == "summary" or not arg_92_3:get("back", true) then
			self:_set_input_blocked(false)

			content.input_active = false
			self._keyboard_id = nil
		end
	elseif not IS_XB1 then
		if not XboxInterface.interface_active() then
			local get_keyboard_result = XboxInterface.get_keyboard_result()

			content.caret_index = #get_keyboard_result

			self:_do_search(get_keyboard_result)

			self._keyboard_id = nil
		end
	elseif not IS_PS4 then
		local poll_virtual_keyboard, var_92_11, var_92_12 = Managers.system_dialog:poll_virtual_keyboard(self._keyboard_id)

		if not poll_virtual_keyboard then
			if not var_92_11 then
				content.caret_index = #var_92_12

				self:_do_search(var_92_12)
			end

			self._keyboard_id = nil
		end
	end

	if not content.hotspot.on_pressed then
		return true
	end

	return content_2.visible
end

HeroViewStateAchievements._do_search = function (self, arg_93_1)
	-- function 93
	self._search_query = arg_93_1
	self._search_widgets_by_name.input.content.search_query = arg_93_1

	local _achievement_layout_type = self._achievement_layout_type
	local _get_layout = self:_get_layout(_achievement_layout_type)
	local tbl = {}

	for k, v in pairs(_get_layout.categories) do
		if not v.entries then
			table.append(tbl, v.entries)
		end

		if not v.categories then
			for k_2, v_2 in pairs(v.categories) do
				table.append(tbl, v_2.entries)
			end
		end
	end

	self:_create_entries(tbl, _achievement_layout_type, nil)
	self:play_sound("Play_hud_select")
end

HeroViewStateAchievements._set_input_blocked = function (self, arg_94_1)
	-- function 94
	local input = Managers.input

	if not arg_94_1 then
		input:block_device_except_service("hero_view", "keyboard", 1, "search")
		input:block_device_except_service("hero_view", "mouse", 1, "search")
		input:block_device_except_service("hero_view", "gamepad", 1, "search")
	else
		input:device_unblock_all_services("keyboard")
		input:device_unblock_all_services("mouse")
		input:device_unblock_all_services("gamepad")
		input:block_device_except_service("hero_view", "keyboard", 1)
		input:block_device_except_service("hero_view", "mouse", 1)
		input:block_device_except_service("hero_view", "gamepad", 1)
	end

	self.parent:set_input_blocked(arg_94_1)
end

HeroViewStateAchievements._handle_claim_all_challenges = function (self)
	-- function 95
	local _achievement_layout_type = self._achievement_layout_type
	local _active_tab_index = self._active_tab_index
	local _active_list_index = self._active_list_index
	local _get_layout = self:_get_layout(_achievement_layout_type)
	local _additional_achievement_widgets_by_name = self._additional_achievement_widgets_by_name
	local _additional_quest_widgets_by_name = self._additional_quest_widgets_by_name
	local claim_all_achievements

	if _achievement_layout_type == "achievements" then
		claim_all_achievements = _additional_achievement_widgets_by_name.claim_all_achievements

		if not claim_all_achievements then
			-- Nothing
		end
	end

	claim_all_achievements = _additional_quest_widgets_by_name.claim_all_quests

	::label_95_0::

	if not self._active_tab then
		return
	end

	local categories = _get_layout.categories

	if not categories then
		return
	end

	local var_95_8 = categories[_active_tab_index]

	if not var_95_8 then
		return
	end

	local categories_2 = var_95_8.categories
	local flag = not categories_2 and categories_2[_active_list_index]
	local flag_2 = false

	if not flag and not _active_list_index then
		flag_2 = self:_has_any_unclaimed_completed_challenge_in_category(flag)
	else
		flag_2 = self:_has_any_unclaimed_completed_challenge_in_category(var_95_8)
	end

	local flag_3

	flag_3 = not self._claimable_challenge_widgets and #self._claimable_challenge_widgets > 0 and true and false

	if not (not flag_3 and flag_2 and not self._has_claimable_filtered_challenges and GameSettingsDevelopment.read_only_backend or self:_is_polling()) then
		claim_all_achievements.content.visible = true
	else
		claim_all_achievements.content.visible = false
	end
end

HeroViewStateAchievements._animate_claim_button = function (self, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
	-- function 96
	if not arg_96_1.content.visible then
		return
	end

	local offset = arg_96_1.offset
	local style = arg_96_1.style
	local num = 2
	local flag

	flag = not (offset[2] < 0) or arg_96_2 or not true or false

	if not (offset[2] < 10) or not arg_96_2 then
		self._button_hide_cooldown = nil

		local num_2 = 200 * arg_96_3

		if offset[2] >= 10 then
			-- Nothing
		else
			offset[2] = offset[2] + num_2
		end
	end

	if not arg_96_2 then
		if not self._button_hide_cooldown then
			self._button_hide_cooldown = arg_96_4
		end

		local num_3 = 200 * arg_96_3

		if offset[2] < -20 then
			self._button_hide_cooldown = nil
		elseif arg_96_4 >= self._button_hide_cooldown + num then
			offset[2] = offset[2] - num_3
		end
	end

	if not flag then
		style.button_glow.color[1] = 195 + 60 * math.sin(7.5 * Managers.time:time("ui"))
	end
end

HeroViewStateAchievements._handle_gamepad_activity = function (self)
	-- function 97
	local is_device_active = Managers.input:is_device_active("gamepad")

	if self._gamepad_active_last_frame ~= is_device_active then
		self:_enable_gamepad_filters(false)

		local filters = self._search_widgets_by_name.filters
		local content = filters.content
		local flag

		flag = not is_device_active and "gamepad_search_filters" and "search_filters"
		filters.scenegraph_id = flag
	end

	self._gamepad_active_last_frame = is_device_active
end
