-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_weekly_event.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_weekly_event_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widget_definitions = var_0_0.widget_definitions
local animation_definitions = var_0_0.animation_definitions
local create_weekly_event_information_box = var_0_0.create_weekly_event_information_box
local selector_input_definitions = var_0_0.selector_input_definitions
local str = "refresh_press"
local str_2 = "confirm_press"

StartGameWindowDeusWeeklyEvent = class(StartGameWindowDeusWeeklyEvent)
StartGameWindowDeusWeeklyEvent.NAME = "StartGameWindowDeusWeeklyEvent"

StartGameWindowDeusWeeklyEvent.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameViewWindow] Enter Substate StartGameWindowDeusWeeklyEvent")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer

	local input_index = arg_1_1.input_index

	input_index = input_index or 1
	self._input_index = input_index
	self._input_manager = ingame_ui_context.input_manager
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_handle_new_selection(self._input_index)

	local get_difficulty_option = self._parent:get_difficulty_option(true)

	get_difficulty_option = get_difficulty_option or Managers.state.difficulty:get_difficulty()
	self._current_difficulty = get_difficulty_option

	self:_update_difficulty_option(self._current_difficulty)

	self._refresh_requested = true
	self._is_focused = false
	self._play_button_pressed = false
	self._show_additional_settings = false
	self._previous_can_play = nil
	self._num_requests = 0

	self._parent:change_generic_actions("deus_default")
	self:_start_transition_animation("on_enter")
end

local tbl = {}

StartGameWindowDeusWeeklyEvent._refresh_event_data = function (self)
	-- function 2
	local get_interface = Managers.backend:get_interface("live_events")
	local get_weekly_chaos_wastes_game_mode_data, var_2_2 = get_interface:get_weekly_chaos_wastes_game_mode_data()
	local get_weekly_chaos_wastes_rewards_data = get_interface:get_weekly_chaos_wastes_rewards_data()

	get_weekly_chaos_wastes_rewards_data = get_weekly_chaos_wastes_rewards_data or tbl
	self._refresh_time = os.time(os.date("!*t", var_2_2.end_timestamp / 1000))
	self._weekly_journey_name = not get_weekly_chaos_wastes_game_mode_data and get_weekly_chaos_wastes_game_mode_data.journey_name

	local var_2_4 = create_weekly_event_information_box(get_weekly_chaos_wastes_game_mode_data)
	local var_2_5 = UIWidget.init(var_2_4)

	self._widgets[#self._widgets + 1] = var_2_5
	self._widgets_by_name.weekly_info_box = var_2_5

	local num = 10
	local num_2 = 0

	self._info_box_widgets = {}

	local _setup_curses = self:_setup_curses(get_weekly_chaos_wastes_game_mode_data, num, num_2)
	local _setup_boons = self:_setup_boons(get_weekly_chaos_wastes_game_mode_data, num, _setup_curses)
	local _setup_rewards = self:_setup_rewards(get_weekly_chaos_wastes_rewards_data, num, _setup_boons)
	local abs = math.abs(scenegraph_definition.info_box.size[2] - math.abs(_setup_rewards))

	if abs > 0 then
		local _ui_scenegraph = self._ui_scenegraph
		local str = "info_box_anchor"
		local str_2 = "scrollbar_window"
		local flag = true
		local var_2_16
		local var_2_17

		self._scrollbar_ui = ScrollbarUI:new(_ui_scenegraph, str, str_2, abs, flag, var_2_16, var_2_17)
	end
end

StartGameWindowDeusWeeklyEvent._setup_curses = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local str = "curse"
	local create_header = var_0_0.create_header("cw_weekly_expedition_modifier_negative", arg_3_3, str)
	local var_3_2 = UIWidget.init(create_header)

	self._info_box_widgets[#self._info_box_widgets + 1] = var_3_2
	self._widgets_by_name.curse_header = var_3_2
	arg_3_3 = arg_3_3 - 40 - arg_3_2

	local mutators = arg_3_1.mutators

	mutators = mutators or tbl

	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	for i, v in ipairs(mutators) do
		local var_3_5 = MutatorTemplates[v]
		local display_name = var_3_5.display_name
		local icon = var_3_5.icon
		local var_3_8 = Localize(var_3_5.description)
		local create_entry_widget = var_0_0.create_entry_widget(icon, display_name, var_3_8, arg_3_3, arg_3_2)
		local var_3_10 = UIWidget.init(create_entry_widget)

		self._info_box_widgets[#self._info_box_widgets + 1] = var_3_10
		self._widgets_by_name["curse_" .. i] = var_3_10

		local desc = var_3_10.style.desc
		local var_3_12, var_3_13 = UIFontByResolution(desc)
		local var_3_14 = var_3_12[1]
		local var_3_15 = var_3_13
		local gui = self._ui_top_renderer.gui
		local var_3_17, var_3_18, var_3_19 = UIGetFontHeight(gui, desc.font_type, var_3_15)
		local num = (var_3_19 - var_3_18) * inv_scale
		local word_wrap, var_3_22 = UIRenderer.word_wrap(self._ui_top_renderer, var_3_8, var_3_14, var_3_15, desc.area_size[1])

		arg_3_3 = arg_3_3 - num * #word_wrap

		local title = var_3_10.style.title
		local var_3_24, var_3_25 = UIFontByResolution(title)
		local var_3_26 = var_3_24[1]
		local var_3_27 = var_3_25
		local var_3_28, var_3_29, var_3_30 = UIGetFontHeight(gui, title.font_type, var_3_27)
		local num_2 = (var_3_30 - var_3_29) * inv_scale
		local word_wrap_2, var_3_33 = UIRenderer.word_wrap(self._ui_top_renderer, Localize(display_name), var_3_26, var_3_27, title.area_size[1])

		arg_3_3 = arg_3_3 - num_2 * #word_wrap_2 - arg_3_2
	end

	return arg_3_3 - arg_3_2
end

StartGameWindowDeusWeeklyEvent._setup_boons = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local str = "boon"
	local create_header = var_0_0.create_header("cw_weekly_expedition_modifier_positive", arg_4_3, str)
	local var_4_2 = UIWidget.init(create_header)

	self._info_box_widgets[#self._info_box_widgets + 1] = var_4_2
	self._widgets_by_name.boon_header = var_4_2
	arg_4_3 = arg_4_3 - 40 - arg_4_2

	local local_player = Managers.player:local_player()
	local profile_index = local_player:profile_index()
	local career_index = local_player:career_index()
	local boons = arg_4_1.boons

	boons = boons or tbl

	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	for i, v in ipairs(boons) do
		local var_4_8 = DeusPowerUpsLookup[v]
		local display_name = var_4_8.display_name
		local get_power_up_icon = DeusPowerUpUtils.get_power_up_icon(var_4_8, profile_index, career_index)
		local get_power_up_description = DeusPowerUpUtils.get_power_up_description(var_4_8, profile_index, career_index)
		local create_entry_widget = var_0_0.create_entry_widget(get_power_up_icon, display_name, get_power_up_description, arg_4_3)
		local var_4_13 = UIWidget.init(create_entry_widget)

		self._info_box_widgets[#self._info_box_widgets + 1] = var_4_13
		self._widgets_by_name["boon_" .. i] = var_4_13

		local desc = var_4_13.style.desc
		local var_4_15, var_4_16 = UIFontByResolution(desc)
		local var_4_17 = var_4_15[1]
		local var_4_18 = var_4_16
		local gui = self._ui_top_renderer.gui
		local var_4_20, var_4_21, var_4_22 = UIGetFontHeight(gui, desc.font_type, var_4_18)
		local num = (var_4_22 - var_4_21) * inv_scale
		local word_wrap, var_4_25 = UIRenderer.word_wrap(self._ui_top_renderer, get_power_up_description, var_4_17, var_4_18, desc.area_size[1])

		arg_4_3 = arg_4_3 - num * #word_wrap

		local title = var_4_13.style.title
		local var_4_27, var_4_28 = UIFontByResolution(title)
		local var_4_29 = var_4_27[1]
		local var_4_30 = var_4_28
		local var_4_31, var_4_32, var_4_33 = UIGetFontHeight(gui, title.font_type, var_4_30)
		local num_2 = (var_4_33 - var_4_32) * inv_scale
		local word_wrap_2, var_4_36 = UIRenderer.word_wrap(self._ui_top_renderer, Localize(display_name), var_4_29, var_4_30, title.area_size[1])

		arg_4_3 = arg_4_3 - num_2 * #word_wrap_2 - arg_4_2
	end

	return arg_4_3 - arg_4_2
end

StartGameWindowDeusWeeklyEvent._setup_rewards = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local var_5_0
	local create_header = var_0_0.create_header("cw_weekly_expedition_rewards_name", arg_5_3, var_5_0)
	local var_5_2 = UIWidget.init(create_header)

	var_5_2.style.header.text_color = Colors.get_color_table_with_alpha("white", 255)
	self._info_box_widgets[#self._info_box_widgets + 1] = var_5_2
	self._widgets_by_name.rewards_header = var_5_2
	arg_5_3 = arg_5_3 - 40 - arg_5_2

	local var_5_3 = arg_5_1
	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	for i, v in ipairs(DefaultDifficulties) do
		local flag = not var_5_3 and var_5_3[v]

		if not flag then
			local _evaluate_rewards = self:_evaluate_rewards(flag, v)
			local create_reward_widget = var_0_0.create_reward_widget(_evaluate_rewards, arg_5_3)
			local var_5_8 = UIWidget.init(create_reward_widget)

			self._info_box_widgets[#self._info_box_widgets + 1] = var_5_8
			self._widgets_by_name["reward_" .. i] = var_5_8

			local desc = var_5_8.style.desc
			local var_5_10, var_5_11 = UIFontByResolution(desc)
			local var_5_12 = var_5_10[1]
			local var_5_13 = var_5_11
			local gui = self._ui_top_renderer.gui
			local var_5_15, var_5_16, var_5_17 = UIGetFontHeight(gui, desc.font_type, var_5_13)
			local num = (var_5_17 - var_5_16) * inv_scale
			local word_wrap = UIRenderer.word_wrap
			local _ui_top_renderer = self._ui_top_renderer
			local Localize = Localize
			local desc_2 = _evaluate_rewards.desc

			desc_2 = desc_2 or " "

			local var_5_23, var_5_24 = word_wrap(_ui_top_renderer, Localize(desc_2), var_5_12, var_5_13, desc.area_size[1])

			arg_5_3 = arg_5_3 - num * #var_5_23 - arg_5_2 - 20
		end
	end

	return arg_5_3 - arg_5_2
end

StartGameWindowDeusWeeklyEvent._evaluate_rewards = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local rewards = arg_6_1.rewards
	local claimed = arg_6_1.claimed
	local tbl = {}
	local Localize = Localize
	local display_name

	if not DifficultySettings[arg_6_2] then
		display_name = DifficultySettings[arg_6_2].display_name

		if not display_name then
			-- Nothing
		end
	end

	display_name = "lb_unknown"

	::label_6_0::

	tbl.difficulty_name = Localize(display_name)
	tbl.num_rewards = #rewards
	tbl.collected = claimed

	local var_6_5 = rewards[1]
	local flag = not var_6_5 and var_6_5.reward_type

	if flag == "experience" then
		local var_6_7 = tonumber(var_6_5.amount)

		var_6_7 = var_6_7 or 0
		tbl.icon = "experience"

		local var_6_8 = Localize("cw_weekly_expedition_xp_reward")

		tbl.desc = string.format(var_6_8, var_6_7)
	elseif not (flag == "item" or flag ~= "loot_chest") then
		local item_name = var_6_5.item_name

		item_name = item_name or var_6_5.weapon_skin_name

		local flag_2 = not item_name and ItemMasterList[item_name]
		local Localize_2 = Localize
		local display_name_2

		if not flag_2 then
			display_name_2 = flag_2.display_name

			if not display_name_2 then
				-- Nothing
			end
		end

		display_name_2 = "lb_unkown"

		::label_6_1::

		tbl.desc = Localize_2(display_name_2)

		local inventory_icon

		if not flag_2 then
			inventory_icon = flag_2.inventory_icon

			if not inventory_icon then
				-- Nothing
			end
		end

		inventory_icon = "icons_placeholder"

		::label_6_2::

		tbl.icon = inventory_icon
	elseif flag == "weapon_skin" then
		local item_name_2 = var_6_5.item_name

		item_name_2 = item_name_2 or var_6_5.weapon_skin_name

		local get_unlocked_weapon_skins = Managers.backend:get_interface("crafting"):get_unlocked_weapon_skins()

		tbl.collected = claimed or get_unlocked_weapon_skins[item_name_2] ~= nil

		local var_6_16 = WeaponSkins.skins[item_name_2]

		var_6_16 = var_6_16 or ItemMasterList[item_name_2]

		local Localize_3 = Localize
		local display_name_3

		if not var_6_16 then
			display_name_3 = var_6_16.display_name

			if not display_name_3 then
				-- Nothing
			end
		end

		display_name_3 = "lb_unkown"

		::label_6_3::

		tbl.desc = Localize_3(display_name_3)

		local inventory_icon_2

		if not var_6_16 then
			inventory_icon_2 = var_6_16.inventory_icon

			if not inventory_icon_2 then
				-- Nothing
			end
		end

		inventory_icon_2 = "icons_placeholder"

		::label_6_4::

		tbl.icon = inventory_icon_2
	else
		tbl.icon = "icons_placeholder"
		tbl.desc = Localize("lb_unkown")
	end

	return tbl
end

StartGameWindowDeusWeeklyEvent._setup_debug_texts = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local str = "info_box_anchor"
	local tbl = {
		font_size = 20,
		upper_case = false,
		localize = false,
		use_shadow = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			2
		}
	}
	local var_7_2, var_7_3 = UIFontByResolution(tbl)
	local var_7_4 = var_7_2[1]
	local var_7_5 = var_7_3
	local gui = self._ui_top_renderer.gui
	local var_7_7, var_7_8, var_7_9 = UIGetFontHeight(gui, tbl.font_type, var_7_5)
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local num = (var_7_9 - var_7_8) * inv_scale
	local str_2 = "This is just a temporary text This is just a temporary text This is just a temporary text"

	for i = 1, 50 do
		local str_3 = str_2 .. " " .. i
		local create_simple_text = UIWidgets.create_simple_text(str_3, str, var_7_5, nil, tbl)
		local var_7_15 = UIWidget.init(create_simple_text)

		var_7_15.offset[2] = arg_7_3
		self._widgets[#self._widgets + 1] = var_7_15
		self._widgets_by_name["temp_text_" .. i] = var_7_15

		local word_wrap, var_7_17 = UIRenderer.word_wrap(self._ui_top_renderer, str_3, var_7_4, var_7_5, scenegraph_definition.info_box.size[1])

		arg_7_3 = arg_7_3 - num * #word_wrap - arg_7_2
	end

	return arg_7_3
end

StartGameWindowDeusWeeklyEvent._start_transition_animation = function (self, arg_8_1)
	-- function 8
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_8_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_8_1] = start_animation
end

StartGameWindowDeusWeeklyEvent._create_ui_elements = function (self, arg_9_1, arg_9_2)
	-- function 9
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_9_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_9_2[1]
		local_position[2] = local_position[2] + arg_9_2[2]
		local_position[3] = local_position[3] + arg_9_2[3]
	end

	self._widgets_by_name.difficulty_info.content.visible = false
end

StartGameWindowDeusWeeklyEvent.on_exit = function (self, arg_10_1)
	-- function 10
	print("[StartGameViewWindow] Exit Substate StartGameWindowDeusWeeklyEvent")

	self._ui_animator = nil

	if not self._play_button_pressed then
		arg_10_1.input_index = nil
	else
		arg_10_1.input_index = self._input_index
	end

	self._parent:set_difficulty_option(self._current_difficulty)
end

StartGameWindowDeusWeeklyEvent.set_focus = function (self, arg_11_1)
	-- function 11
	self._is_focused = arg_11_1
end

StartGameWindowDeusWeeklyEvent.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not self._refresh_requested then
		self:_refresh_event_data()

		self._refresh_requested = false
	end

	self:_update_can_play()
	self:_update_animations(arg_12_1)
	self:_update_time_left()
	self:_handle_gamepad_activity()
	self:_handle_input(arg_12_1, arg_12_2)
	self:_draw(arg_12_1, arg_12_2)
end

StartGameWindowDeusWeeklyEvent.post_update = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	return
end

StartGameWindowDeusWeeklyEvent._handle_gamepad_activity = function (self)
	-- function 14
	local flag = self.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true
			self._input_index = 1

			local var_14_1 = selector_input_definitions[self._input_index]

			if not var_14_1 and not var_14_1.enter_requirements(self) then
				var_14_1.on_enter(self)
			end
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		selector_input_definitions[self._input_index].on_exit(self)
	end
end

StartGameWindowDeusWeeklyEvent._update_can_play = function (self)
	-- function 15
	local _can_play = self:_can_play()

	self._widgets_by_name.play_button.content.button_hotspot.disable_button = not _can_play

	local str = "deus_default"

	if not _can_play then
		str = "deus_default_play"
	elseif not self._dlc_locked then
		str = "deus_default_buy"
	end

	if str ~= self._prev_input_desc then
		self._parent:set_input_description(str)

		self._prev_input_desc = str
	end
end

StartGameWindowDeusWeeklyEvent._handle_input = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _parent = self._parent
	local window_input_service = _parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("mouse")

	if not is_device_active then
		local _input_index = self._input_index
		local var_16_4

		if not window_input_service:get("move_down") then
			_input_index = _input_index + 1
			var_16_4 = 1
		elseif not window_input_service:get("move_up") then
			_input_index = _input_index - 1
			var_16_4 = -1
		else
			selector_input_definitions[_input_index].update(self, window_input_service, arg_16_1, arg_16_2)
		end

		if _input_index ~= self._input_index then
			self:_gamepad_selector_input_func(_input_index, var_16_4)
		end

		if not window_input_service:get(str_2, true) and not self._dlc_locked then
			Managers.unlock:open_dlc_page(self._dlc_name)
		end

		if not self:_can_play() and not window_input_service:get(str) then
			self._parent:set_difficulty_option(self._current_difficulty)

			self._play_button_pressed = true

			self._parent:play(arg_16_2, "deus_weekly")
		end
	else
		local _widgets_by_name = self._widgets_by_name

		for i = 1, #selector_input_definitions do
			local widget_name = selector_input_definitions[i].widget_name
			local var_16_7 = _widgets_by_name[widget_name]
			local is_selected = var_16_7.content.is_selected

			if widget_name == "difficulty_stepper" then
				if is_selected or not UIUtils.is_button_hover_enter(var_16_7, "left_arrow_hotspot") then
					self:_handle_new_selection(i)
					self:_play_sound("Play_hud_hover")
				end

				if is_selected or not UIUtils.is_button_hover_enter(var_16_7, "right_arrow_hotspot") then
					self:_handle_new_selection(i)
					self:_play_sound("Play_hud_hover")
				end

				if UIUtils.is_button_hover(var_16_7, "info_hotspot") or UIUtils.is_button_hover(self._widgets_by_name.difficulty_info, "widget_hotspot") or is_device_active or not is_selected then
					local tbl = {
						difficulty_info = self._widgets_by_name.difficulty_info,
						upsell_button = self._widgets_by_name.upsell_button
					}

					if not self._diff_info_anim_played then
						self._diff_anim_id = self._ui_animator:start_animation("difficulty_info_enter", tbl, scenegraph_definition)
						self._diff_info_anim_played = true
					end

					self:_handle_difficulty_info(true)
				else
					if not self._diff_anim_id then
						self._ui_animator:stop_animation(self._diff_anim_id)
					end

					self._diff_info_anim_played = false
					self._widgets_by_name.upsell_button.content.visible = false
					self._widgets_by_name.difficulty_info.content.visible = false

					self:_handle_difficulty_info(false)
				end

				if UIUtils.is_button_pressed(var_16_7, "left_arrow_hotspot") or not window_input_service:get("move_left") then
					self:_option_selected(widget_name, "left_arrow", arg_16_2)
				elseif UIUtils.is_button_pressed(var_16_7, "right_arrow_hotspot") or not window_input_service:get("move_right") then
					self:_option_selected(widget_name, "right_arrow", arg_16_2)
				end
			elseif widget_name ~= "play_button" or not self:_can_play() then
				if is_selected or not UIUtils.is_button_hover_enter(_widgets_by_name.play_button) then
					self:_handle_new_selection(i)
					self:_play_sound("Play_hud_hover")
				end

				if not UIUtils.is_button_pressed(_widgets_by_name.play_button) then
					self:_option_selected(widget_name, "play_button", arg_16_2)
				end
			end
		end

		local upsell_button = self._widgets_by_name.upsell_button

		if not UIUtils.is_button_pressed(upsell_button) then
			Managers.unlock:open_dlc_page(self._dlc_name)
		end
	end

	local flag = true

	if not DLCSettings.quick_play_preferences and not window_input_service:get("right_stick_press", flag) then
		_parent:set_layout_by_name("adventure_level_preferences")
	end
end

StartGameWindowDeusWeeklyEvent._play_sound = function (self, arg_17_1)
	-- function 17
	return self._parent:play_sound(arg_17_1)
end

StartGameWindowDeusWeeklyEvent._can_play = function (self)
	-- function 18
	if not (self._current_difficulty == nil or not self._dlc_locked) then
		return false
	end

	local _weekly_journey_name = self._weekly_journey_name

	_weekly_journey_name = not _weekly_journey_name and not LevelUnlockUtils.is_journey_disabled(self._weekly_journey_name)

	return _weekly_journey_name
end

StartGameWindowDeusWeeklyEvent._set_info_window = function (self, arg_19_1)
	-- function 19
	local var_19_0 = DifficultySettings[arg_19_1]
	local description = var_19_0.description
	local max_chest_power_level = var_19_0.max_chest_power_level
	local difficulty_info = self._widgets_by_name.difficulty_info

	difficulty_info.content.difficulty_description = Localize(description)
	difficulty_info.content.highest_obtainable_level = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(max_chest_power_level)
end

StartGameWindowDeusWeeklyEvent._update_difficulty_option = function (self, arg_20_1)
	-- function 20
	if not arg_20_1 then
		local var_20_0 = DifficultySettings[arg_20_1]
		local difficulty_stepper = self._widgets_by_name.difficulty_stepper

		difficulty_stepper.content.selected_difficulty_text = Localize(var_20_0.display_name)

		local display_image = var_20_0.display_image

		difficulty_stepper.content.difficulty_icon = display_image

		self:_set_info_window(arg_20_1)

		self._current_difficulty = arg_20_1
	end
end

StartGameWindowDeusWeeklyEvent._option_selected = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	if arg_21_1 == "difficulty_stepper" then
		local _current_difficulty = self._current_difficulty
		local difficulties = GameModeSettings.deus.difficulties
		local find = table.find(difficulties, _current_difficulty)
		local num = 0

		if arg_21_2 == "left_arrow" then
			if find - 1 >= 1 then
				num = find - 1

				self._parent:play_sound("hud_morris_start_menu_set")
			end
		elseif not (arg_21_2 ~= "right_arrow" or not (find + 1 <= #difficulties)) then
			num = find + 1

			self._parent:play_sound("hud_morris_start_menu_set")
		end

		self:_update_difficulty_option(difficulties[num])
	elseif arg_21_1 == "play_button" then
		self._parent:set_difficulty_option(self._current_difficulty)

		self._play_button_pressed = true

		self._parent:play(arg_21_3, "deus_weekly")
	else
		ferror("Unknown selector_input_definition: %s", arg_21_1)
	end
end

StartGameWindowDeusWeeklyEvent._verify_selection_index = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _input_index = self._input_index
	local count = #selector_input_definitions

	arg_22_1 = math.clamp(arg_22_1, 1, count)

	if not arg_22_2 then
		return arg_22_1
	end

	local var_22_2 = selector_input_definitions[arg_22_1]

	while not (not var_22_2 and not (arg_22_1 < count) or var_22_2.enter_requirements()) do
		arg_22_1 = arg_22_1 + arg_22_2
		var_22_2 = selector_input_definitions[arg_22_1]
	end

	if not var_22_2 and not var_22_2.enter_requirements() then
		_input_index = arg_22_1
	end

	return _input_index
end

StartGameWindowDeusWeeklyEvent._gamepad_selector_input_func = function (self, arg_23_1, arg_23_2)
	-- function 23
	local is_device_active = Managers.input:is_device_active("mouse")

	arg_23_1 = self:_verify_selection_index(arg_23_1, arg_23_2)

	if not (self._input_index == arg_23_1 or is_device_active) then
		self._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if not self._input_index then
			selector_input_definitions[self._input_index].on_exit(self)
		end

		selector_input_definitions[arg_23_1].on_enter(self)
	end

	self._input_index = arg_23_1
end

StartGameWindowDeusWeeklyEvent._handle_new_selection = function (self, arg_24_1, arg_24_2)
	-- function 24
	local count = #selector_input_definitions

	arg_24_1 = math.clamp(arg_24_1, 1, count)

	local _widgets_by_name = self._widgets_by_name

	for i = 1, #selector_input_definitions do
		local var_24_2 = _widgets_by_name[selector_input_definitions[i].widget_name]
		local flag = i == arg_24_1

		var_24_2.content.is_selected = flag
	end

	self._input_index = arg_24_1
end

StartGameWindowDeusWeeklyEvent._update_animations = function (self, arg_25_1)
	-- function 25
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_25_1)

	if not Managers.input:is_device_active("gamepad") then
		self:_update_button_animations(arg_25_1)
	end

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StartGameWindowDeusWeeklyEvent._fetch_event_data = function (self)
	-- function 26
	if not self._fetch_in_progress then
		return
	end

	self._fetch_in_progress = true

	local get_interface = Managers.backend:get_interface("live_events")
	local num = 2

	local function fn()
		-- function 27
		num = num - 1

		if num == 0 then
			self._refresh_requested = true
			self._fetch_in_progress = false
		end
	end

	get_interface:request_live_events(fn)
	get_interface:request_weekly_event_rewards(fn)
end

StartGameWindowDeusWeeklyEvent._update_time_left = function (self)
	-- function 28
	local time = os.time(os.date("!*t"))
	local num = self._refresh_time - time
	local content = self._widgets_by_name.timer.content

	if num > 120 then
		local num_2 = num / 86400
		local num_3 = num / 3600 % 24
		local num_4 = num / 60 % 60
		local var_28_6 = Localize("deus_start_game_mod_timer")

		content.text = string.format(var_28_6, num_2, num_3, num_4)
	else
		local var_28_7 = Localize("deus_start_game_mod_timer_seconds")

		if num < 0 then
			num = 0

			self:_fetch_event_data()
		end

		content.text = string.format(var_28_7, num)
	end
end

StartGameWindowDeusWeeklyEvent._update_button_animations = function (self, arg_29_1)
	-- function 29
	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.upsell_button, arg_29_1)
end

StartGameWindowDeusWeeklyEvent._draw = function (self, arg_30_1, arg_30_2)
	-- function 30
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local var_30_4

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_30_1, var_30_4, _render_settings)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)

	if not table.is_empty(self._info_box_widgets) then
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._info_box_widgets)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not self._scrollbar_ui then
		self._scrollbar_ui:update(arg_30_1, arg_30_2, _ui_top_renderer, window_input_service, _render_settings)
	end
end

StartGameWindowDeusWeeklyEvent._update_difficulty_lock = function (self)
	-- function 31
	local _current_difficulty = self._current_difficulty
	local difficulty_info = self._widgets_by_name.difficulty_info
	local upsell_button = self._widgets_by_name.upsell_button

	if not _current_difficulty then
		local is_difficulty_approved, var_31_4, var_31_5, var_31_6 = self._parent:is_difficulty_approved(_current_difficulty)

		if not is_difficulty_approved then
			if not var_31_4 then
				difficulty_info.content.should_show_diff_lock_text = true

				local content = difficulty_info.content
				local var_31_8

				if not var_31_4 then
					var_31_8 = Localize(var_31_4)

					if not var_31_8 then
						-- Nothing
					end
				end

				var_31_8 = ""

				::label_31_0::

				content.difficulty_lock_text = var_31_8
			else
				difficulty_info.content.should_show_diff_lock_text = false
			end

			if not var_31_5 then
				difficulty_info.content.should_show_dlc_lock = true
				self._dlc_locked = var_31_5
				self._dlc_name = var_31_5
				upsell_button.content.visible = true
			else
				difficulty_info.content.should_show_dlc_lock = false
				upsell_button.content.visible = false
				self._dlc_locked = nil
				self._dlc_name = nil
			end
		else
			difficulty_info.content.should_show_dlc_lock = false
			difficulty_info.content.should_show_diff_lock_text = false
			difficulty_info.content.should_resize = false
			upsell_button.content.visible = false
			self._dlc_locked = nil
			self._dlc_name = nil
		end

		self._difficulty_approved = is_difficulty_approved
	else
		difficulty_info.content.should_show_dlc_lock = false
		upsell_button.content.visible = false
	end

	local _calculate_difficulty_info_widget_size = self:_calculate_difficulty_info_widget_size(difficulty_info)
	local num = (math.floor(_calculate_difficulty_info_widget_size) - scenegraph_definition.difficulty_info.size[2]) / 2

	self:_resize_difficulty_info({
		math.floor(scenegraph_definition.difficulty_info.size[1]),
		math.floor(_calculate_difficulty_info_widget_size)
	}, {
		0,
		-num,
		1
	})

	upsell_button.offset[2] = -math.floor(_calculate_difficulty_info_widget_size) / 2 + 24
end

StartGameWindowDeusWeeklyEvent._handle_difficulty_info = function (self, arg_32_1)
	-- function 32
	if not arg_32_1 then
		self:_update_difficulty_lock()
	end
end

StartGameWindowDeusWeeklyEvent._calculate_difficulty_info_widget_size = function (self, arg_33_1)
	-- function 33
	local num = 20
	local difficulty_description = arg_33_1.style.difficulty_description
	local difficulty_description_2 = arg_33_1.content.difficulty_description
	local get_text_height = UIUtils.get_text_height(self._ui_renderer, difficulty_description.size, difficulty_description, difficulty_description_2)

	arg_33_1.content.difficulty_description_text_size = get_text_height

	local highest_obtainable_level = arg_33_1.style.highest_obtainable_level
	local highest_obtainable_level_2 = arg_33_1.content.highest_obtainable_level
	local num_2 = UIUtils.get_text_height(self._ui_renderer, highest_obtainable_level.size, highest_obtainable_level, highest_obtainable_level_2) + num
	local difficulty_lock_text = arg_33_1.style.difficulty_lock_text
	local difficulty_lock_text_2 = arg_33_1.content.difficulty_lock_text
	local num_3 = 0

	if not arg_33_1.content.should_show_diff_lock_text then
		num_3 = UIUtils.get_text_height(self._ui_renderer, difficulty_lock_text.size, difficulty_lock_text, difficulty_lock_text_2) + num
		arg_33_1.content.difficulty_lock_text_height = num_3
	end

	local dlc_lock_text = arg_33_1.style.dlc_lock_text
	local dlc_lock_text_2 = arg_33_1.content.dlc_lock_text
	local num_4 = 0

	if not arg_33_1.content.should_show_dlc_lock then
		num_4 = UIUtils.get_text_height(self._ui_renderer, dlc_lock_text.size, dlc_lock_text, dlc_lock_text_2) + num
	end

	return num_2 + get_text_height + num_3 + num_4 + 50
end

StartGameWindowDeusWeeklyEvent._resize_difficulty_info = function (self, arg_34_1, arg_34_2)
	-- function 34
	local difficulty_info = self._widgets_by_name.difficulty_info

	difficulty_info.content.should_resize = true
	difficulty_info.content.resize_size = arg_34_1
	difficulty_info.content.resize_offset = arg_34_2
	difficulty_info.style.widget_hotspot.size = arg_34_1
	difficulty_info.style.widget_hotspot.offset = arg_34_2
end

StartGameWindowDeusWeeklyEvent._handle_difficulty_stepper_gamepad = function (self, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	local tbl = {}

	if not arg_35_2:get("move_left") and not arg_35_1.content.is_selected then
		self:_option_selected(self._input_index, "left_arrow", arg_35_3)

		arg_35_1.content.left_arrow_pressed = true
		tbl.left_key = arg_35_1.style.left_arrow_gamepad_highlight

		if not self._arrow_anim_id then
			self._ui_animator:stop_animation(self._arrow_anim_id)

			arg_35_1.style.right_arrow_gamepad_highlight.color[1] = 0
		end

		self._arrow_anim_id = self._ui_animator:start_animation("left_arrow_flick", arg_35_1, scenegraph_definition, tbl)
	elseif not arg_35_2:get("move_right") and not arg_35_1.content.is_selected then
		self:_option_selected(self._input_index, "right_arrow", arg_35_3)

		arg_35_1.content.right_arrow_pressed = true
		tbl.right_key = arg_35_1.style.right_arrow_gamepad_highlight

		if not self._arrow_anim_id then
			self._ui_animator:stop_animation(self._arrow_anim_id)

			arg_35_1.style.left_arrow_gamepad_highlight.color[1] = 0
		end

		self._arrow_anim_id = self._ui_animator:start_animation("right_arrow_flick", arg_35_1, scenegraph_definition, tbl)
	end
end
