-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_difficulty_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_difficulty_console_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local create_difficulty_button = var_0_0.create_difficulty_button
local animation_definitions = var_0_0.animation_definitions
local num = 1
local str = "confirm_press"

StartGameWindowDifficultyConsole = class(StartGameWindowDifficultyConsole)
StartGameWindowDifficultyConsole.NAME = "StartGameWindowDifficultyConsole"

StartGameWindowDifficultyConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowDifficultyConsole")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
	self:_setup_difficulties()

	local var_1_2 = self
	local _verify_difficulty = self._verify_difficulty
	local get_difficulty_option = self.parent:get_difficulty_option()

	get_difficulty_option = get_difficulty_option or Managers.state.difficulty:get_difficulty()

	local var_1_5 = _verify_difficulty(var_1_2, get_difficulty_option)

	self:_update_selected_difficulty_option(var_1_5)

	if not var_1_5 then
		self._difficulty_navigation_id = self:_get_difficulty_navigation_id_from_difficulty_key(var_1_5)
	else
		self._difficulty_navigation_id = 1
	end

	self:_start_transition_animation("on_enter")
end

StartGameWindowDifficultyConsole._verify_difficulty = function (arg_2_0, arg_2_1)
	-- function 2
	local get_default_difficulties = Managers.state.difficulty:get_default_difficulties()

	for k, v in pairs(get_default_difficulties) do
		if v == arg_2_1 then
			return arg_2_1
		end
	end

	Application.warning(string.format("Difficulty %q is not valid - Defaulting to %q", arg_2_1, get_default_difficulties[1]))

	return get_default_difficulties[1]
end

StartGameWindowDifficultyConsole._start_transition_animation = function (self, arg_3_1)
	-- function 3
	local tbl = {
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_3_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_3_1] = start_animation
end

StartGameWindowDifficultyConsole.create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_4_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_2
		tbl_2[k] = var_4_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end
end

StartGameWindowDifficultyConsole._setup_difficulties = function (self)
	-- function 5
	local tbl = {}
	local tbl_2 = {}
	local _get_difficulty_options = self:_get_difficulty_options()
	local _widgets = self._widgets
	local _widgets_by_name = self._widgets_by_name
	local num_2 = 1
	local str = "difficulty_option_"
	local num_3 = 10
	local str_2 = "difficulty_option"
	local size = scenegraph_definition[str_2].size
	local var_5_10 = create_difficulty_button(str_2, size)

	for i = num, #_get_difficulty_options do
		local var_5_11 = _get_difficulty_options[i]
		local var_5_12 = DifficultySettings[var_5_11]
		local display_name = var_5_12.display_name
		local display_image = var_5_12.display_image
		local completed_frame_texture = var_5_12.completed_frame_texture
		local var_5_16 = UIWidget.init(var_5_10)

		_widgets_by_name[str .. num_2] = var_5_16
		_widgets[#_widgets + 1] = var_5_16
		tbl[#tbl + 1] = var_5_16

		local offset = var_5_16.offset
		local content = var_5_16.content

		content.difficulty_key = var_5_11
		content.title_text = Localize(display_name)
		content.icon = display_image
		content.difficulty_key = var_5_11
		content.text_title = Localize(display_name)
		content.icon_texture = display_image
		content.icon_frame_texture = completed_frame_texture
		offset[2] = -(size[2] + num_3) * (num_2 - 1)

		local _rewards_by_difficulty = self:_rewards_by_difficulty(var_5_11)
		local count = #_rewards_by_difficulty

		for j = 1, count do
			local var_5_21 = _rewards_by_difficulty[j]
			local create_difficulty_reward_widget = var_0_0.create_difficulty_reward_widget(var_5_11, var_5_21, j, count)
			local var_5_23 = UIWidget.init(create_difficulty_reward_widget)

			_widgets_by_name[string.format("reward_%s_%s", var_5_11, j)] = var_5_23
			_widgets[#_widgets + 1] = var_5_23
			tbl_2[#tbl_2 + 1] = var_5_23
		end

		num_2 = num_2 + 1
	end

	self._difficulty_widgets = tbl
	self._difficulty_reward_widgets = tbl_2
end

StartGameWindowDifficultyConsole._rewards_by_difficulty = function (arg_6_0, arg_6_1)
	-- function 6
	return LootChestData.chests_by_category[arg_6_1].backend_keys
end

StartGameWindowDifficultyConsole._get_difficulty_options = function (arg_7_0)
	-- function 7
	return Managers.state.difficulty:get_default_difficulties()
end

StartGameWindowDifficultyConsole.on_exit = function (self, arg_8_1)
	-- function 8
	print("[StartGameWindow] Exit Substate StartGameWindowDifficultyConsole")

	self.ui_animator = nil

	self.parent:set_input_description(nil)
end

StartGameWindowDifficultyConsole.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	self:_update_animations(arg_9_1)
	self:_handle_input(arg_9_1, arg_9_2)
	self:_update_difficulty_locks()
	self:draw(arg_9_1)
end

StartGameWindowDifficultyConsole.post_update = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

StartGameWindowDifficultyConsole._update_animations = function (self, arg_11_1)
	-- function 11
	local ui_animator = self.ui_animator

	self.ui_animator:update(arg_11_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StartGameWindowDifficultyConsole._is_button_pressed = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot

	if not button_hotspot.on_pressed then
		button_hotspot.on_pressed = false

		return true
	end
end

StartGameWindowDifficultyConsole._is_button_hover_enter = function (arg_13_0, arg_13_1)
	-- function 13
	local button_hotspot = arg_13_1.content.button_hotspot
	local on_hover_enter = button_hotspot.on_hover_enter

	on_hover_enter = not on_hover_enter and not button_hotspot.is_selected

	return on_hover_enter
end

StartGameWindowDifficultyConsole._handle_input = function (self, arg_14_1, arg_14_2)
	-- function 14
	local window_input_service = self.parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("mouse")

	if not is_device_active then
		if not window_input_service:get("move_down_hold_continuous") then
			self:_update_difficulty_selection(1)
		elseif not window_input_service:get("move_up_hold_continuous") then
			self:_update_difficulty_selection(-1)
		end
	end

	local _difficulty_widgets = self._difficulty_widgets

	for i = 1, #_difficulty_widgets do
		local var_14_3 = _difficulty_widgets[i]

		if var_14_3.content.is_selected or not self:_is_button_hover_enter(var_14_3) then
			self:_update_difficulty_selection(nil, i)
		end

		if not self:_is_button_pressed(var_14_3) and not self._difficulty_approved then
			self:_on_difficulty_selection_confirmed()

			return
		end
	end

	local buy_button = self._widgets_by_name.buy_button

	UIWidgetUtils.animate_default_button(buy_button, arg_14_1)

	if not self:_is_button_hover_enter(buy_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if not self:_is_button_released(buy_button) then
		local dlc_name = buy_button.content.dlc_name
		local store_page_url = AreaSettings[dlc_name].store_page_url

		self:_show_storepage(store_page_url, dlc_name)
	end

	if not (not not is_device_active or window_input_service:get(str, true)) then
		if not self._difficulty_approved then
			self:_on_difficulty_selection_confirmed()
		elseif not self._dlc_locked then
			local _dlc_locked = self._dlc_locked
			local store_page_url_2 = AreaSettings[_dlc_locked].store_page_url

			self:_show_storepage(store_page_url_2, _dlc_locked)
		end
	end
end

StartGameWindowDifficultyConsole._on_difficulty_selection_confirmed = function (self)
	-- function 15
	local parent = self.parent

	parent:set_difficulty_option(self._selected_difficulty_key)

	local difficulties_select_sounds = UISettings.difficulties_select_sounds
	local var_15_2 = difficulties_select_sounds[self._difficulty_navigation_id]

	var_15_2 = var_15_2 or difficulties_select_sounds[#difficulties_select_sounds]

	self:_play_sound(var_15_2)

	local get_selected_game_mode_layout_name = parent:get_selected_game_mode_layout_name()

	parent:set_layout_by_name(get_selected_game_mode_layout_name)
end

StartGameWindowDifficultyConsole._update_difficulty_selection = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _get_difficulty_options = self:_get_difficulty_options()

	if not arg_16_2 then
		arg_16_2 = self._difficulty_navigation_id + arg_16_1

		local count = #_get_difficulty_options

		arg_16_2 = math.clamp(arg_16_2, 1, count)
	end

	if arg_16_2 ~= self._difficulty_navigation_id then
		local var_16_2 = _get_difficulty_options[arg_16_2]

		self:_update_selected_difficulty_option(var_16_2)
		self:_play_sound("play_gui_lobby_button_02_mission_act_click")

		self._difficulty_navigation_id = arg_16_2
	end
end

StartGameWindowDifficultyConsole._get_difficulty_navigation_id_from_difficulty_key = function (self, arg_17_1)
	-- function 17
	local _get_difficulty_options = self:_get_difficulty_options()

	for i = 1, #_get_difficulty_options do
		if arg_17_1 == _get_difficulty_options[i] then
			return i
		end
	end

	ferror("Difficulty Key not found %s", arg_17_1)
end

StartGameWindowDifficultyConsole._set_selected_difficulty_option = function (self, arg_18_1)
	-- function 18
	local _difficulty_widgets = self._difficulty_widgets

	for i = 1, #_difficulty_widgets do
		local content = _difficulty_widgets[i].content

		content.is_selected = content.difficulty_key == arg_18_1
	end

	local _difficulty_reward_widgets = self._difficulty_reward_widgets

	for j = 1, #_difficulty_reward_widgets do
		local content_2 = _difficulty_reward_widgets[j].content

		content_2.visible = content_2.difficulty_key == arg_18_1
	end
end

StartGameWindowDifficultyConsole._set_info_window = function (self, arg_19_1)
	-- function 19
	local var_19_0 = DifficultySettings[arg_19_1]
	local description = var_19_0.description
	local display_name = var_19_0.display_name
	local display_image = var_19_0.display_image
	local xp_multiplier = var_19_0.xp_multiplier

	xp_multiplier = xp_multiplier or 1

	local max_chest_power_level = var_19_0.max_chest_power_level
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.difficulty_title.content.text = Localize(display_name)
	_widgets_by_name.difficulty_texture.content.texture_id = display_image
	_widgets_by_name.description_text.content.text = Localize(description)
	_widgets_by_name.difficulty_chest_info.content.text = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(max_chest_power_level)

	local num = xp_multiplier % 1
	local num_2 = xp_multiplier - num

	_widgets_by_name.xp_multiplier.content.text = string.format("%s: %s.%sx", Localize("difficulty_xp_multiplier"), num_2, string.pad_right(string.sub(tostring(num), 3, 4), 2, "0"))
end

StartGameWindowDifficultyConsole._update_difficulty_locks = function (self)
	-- function 20
	local _widgets_by_name = self._widgets_by_name
	local str = "difficulty_option_"
	local get_default_difficulties = Managers.state.difficulty:get_default_difficulties()

	for i = 1, #get_default_difficulties do
		local var_20_3 = get_default_difficulties[i]
		local var_20_4 = DifficultySettings[var_20_3]
		local is_difficulty_approved = self.parent:is_difficulty_approved(var_20_3)
		local var_20_6 = _widgets_by_name[str .. i]

		var_20_6.content.locked = not is_difficulty_approved

		local offset = var_20_6.style.icon_texture.offset
		local icon_unlocked_z_offset

		if not is_difficulty_approved then
			icon_unlocked_z_offset = var_20_6.content.icon_unlocked_z_offset

			if not icon_unlocked_z_offset then
				-- Nothing
			end
		end

		icon_unlocked_z_offset = var_20_6.content.icon_locked_z_offset

		::label_20_0::

		offset[3] = icon_unlocked_z_offset
	end

	local buy_button = _widgets_by_name.buy_button
	local difficulty_second_lock_text = _widgets_by_name.difficulty_second_lock_text
	local difficulty_lock_text = _widgets_by_name.difficulty_lock_text
	local difficulty_is_locked_text = _widgets_by_name.difficulty_is_locked_text
	local dlc_lock_text = _widgets_by_name.dlc_lock_text
	local _selected_difficulty_key = self._selected_difficulty_key

	if not _selected_difficulty_key then
		local var_20_15 = DifficultySettings[_selected_difficulty_key]
		local is_difficulty_approved_2, var_20_17, var_20_18, var_20_19 = self.parent:is_difficulty_approved(_selected_difficulty_key)

		if not is_difficulty_approved_2 then
			if not var_20_18 then
				buy_button.content.button_hotspot.disable_button = false
				buy_button.content.visible = true
				buy_button.content.dlc_name = var_20_18
				difficulty_second_lock_text.offset[2] = 38
				difficulty_lock_text.offset[2] = 38
				difficulty_is_locked_text.offset[2] = 38
				dlc_lock_text.content.visible = true
				self._dlc_locked = var_20_18
			else
				buy_button.content.button_hotspot.disable_button = true
				buy_button.content.visible = false
				buy_button.content.dlc_name = nil
				difficulty_second_lock_text.offset[2] = 0
				difficulty_lock_text.offset[2] = 0
				difficulty_is_locked_text.offset[2] = 0
				dlc_lock_text.content.visible = false
				self._dlc_locked = nil
			end

			if var_20_19 or not var_20_17 then
				_widgets_by_name.difficulty_is_locked_text.content.text = Localize("required_power_level_not_met_in_party")

				if not var_20_19 then
					local required_power_level = var_20_15.required_power_level
					local var_20_21 = Localize("required_power_level")

					_widgets_by_name.difficulty_lock_text.content.text = string.format("%s: %s", var_20_21, tostring(UIUtils.presentable_hero_power_level(required_power_level)))

					local content = _widgets_by_name.difficulty_second_lock_text.content
					local var_20_23

					if not var_20_17 then
						var_20_23 = Localize(var_20_17)

						if not var_20_23 then
							-- Nothing
						end
					end

					var_20_23 = ""

					::label_20_1::

					content.text = var_20_23
				else
					local content_2 = _widgets_by_name.difficulty_lock_text.content
					local var_20_25

					if not var_20_17 then
						var_20_25 = Localize(var_20_17)

						if not var_20_25 then
							-- Nothing
						end
					end

					var_20_25 = ""

					::label_20_2::

					content_2.text = var_20_25
				end
			end

			if not var_20_18 then
				self.parent:set_input_description("select_difficulty_buy")
			else
				self.parent:set_input_description("select_difficulty")
			end
		else
			buy_button.content.button_hotspot.disable_button = true
			buy_button.content.visible = false
			buy_button.content.dlc_name = nil
			dlc_lock_text.content.visible = false
			_widgets_by_name.difficulty_lock_text.content.text = ""
			_widgets_by_name.difficulty_second_lock_text.content.text = ""
			_widgets_by_name.difficulty_is_locked_text.content.text = ""
			self._dlc_locked = nil

			self.parent:set_input_description("select_difficulty_confirm")
		end

		self._difficulty_approved = is_difficulty_approved_2
	else
		buy_button.content.button_hotspot.disable_button = true
		buy_button.content.visible = false
		buy_button.content.dlc_name = nil
		dlc_lock_text.content.visible = false

		if not self._has_exited then
			self.parent:set_input_description(nil)
		end
	end
end

StartGameWindowDifficultyConsole._update_selected_difficulty_option = function (self, arg_21_1)
	-- function 21
	arg_21_1 = arg_21_1 or Managers.state.difficulty:get_difficulty()

	if arg_21_1 ~= self._selected_difficulty_key then
		self:_set_selected_difficulty_option(arg_21_1)

		self._selected_difficulty_key = arg_21_1

		self:_set_info_window(arg_21_1)
	end
end

StartGameWindowDifficultyConsole.draw = function (self, arg_22_1)
	-- function 22
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_22_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_22_4 = _widgets[i]

		UIRenderer.draw_widget(ui_top_renderer, var_22_4)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

StartGameWindowDifficultyConsole._play_sound = function (self, arg_23_1)
	-- function 23
	self.parent:play_sound(arg_23_1)
end

StartGameWindowDifficultyConsole._is_button_released = function (arg_24_0, arg_24_1)
	-- function 24
	local button_hotspot = arg_24_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowDifficultyConsole._show_storepage = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local PLATFORM = PLATFORM

	if not IS_WINDOWS and not rawget(_G, "Steam") then
		Steam.open_url(arg_25_1)
	elseif not IS_XB1 then
		local user_id = Managers.account:user_id()

		if not arg_25_2 then
			local dlc_id = Managers.unlock:dlc_id(arg_25_2)

			if not dlc_id then
				XboxLive.show_product_details(user_id, dlc_id)
			else
				Application.error(string.format("[StartGameWindowAreaSelection:_show_storepage] No product_id for dlc: %s", arg_25_2))
			end
		else
			Application.error("[StartGameWindowAreaSelection:_show_storepage] No dlc name")
		end
	elseif not IS_PS4 then
		local user_id_2 = Managers.account:user_id()

		if not arg_25_2 then
			local ps4_dlc_product_label = Managers.unlock:ps4_dlc_product_label(arg_25_2)

			if not ps4_dlc_product_label then
				Managers.system_dialog:open_commerce_dialog(NpCommerceDialog.MODE_PRODUCT, user_id_2, {
					ps4_dlc_product_label
				})
			else
				Application.error(string.format("[StartGameWindowAreaSelection:_show_storepage] No product_id for dlc: %s", arg_25_2))
			end
		else
			Application.error("[StartGameWindowAreaSelection:_show_storepage] No dlc name")
		end
	end
end
