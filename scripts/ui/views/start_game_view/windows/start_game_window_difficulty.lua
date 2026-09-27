-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_difficulty.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_difficulty_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local create_difficulty_button = var_0_0.create_difficulty_button
local create_dlc_difficulty_divider = var_0_0.create_dlc_difficulty_divider
local animation_definitions = var_0_0.animation_definitions
local num = 1

StartGameWindowDifficulty = class(StartGameWindowDifficulty)
StartGameWindowDifficulty.NAME = "StartGameWindowDifficulty"

StartGameWindowDifficulty.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowDifficulty")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._has_exited = false

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
	self:_setup_difficulties()

	local get_difficulty_option = self.parent:get_difficulty_option()

	get_difficulty_option = get_difficulty_option or Managers.state.difficulty:get_difficulty()

	self:_update_selected_difficulty_option(get_difficulty_option)
	self.parent:set_input_description("select_difficulty")
end

StartGameWindowDifficulty.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_3
		tbl_2[k] = var_2_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

StartGameWindowDifficulty._setup_difficulties = function (self)
	-- function 3
	local tbl = {}
	local tbl_2 = {}
	local _get_difficulty_options = self:_get_difficulty_options()
	local _widgets = self._widgets
	local _widgets_by_name = self._widgets_by_name
	local num_2 = 1
	local str = "difficulty_option_"
	local num_3 = 16
	local str_2 = "difficulty_option"
	local size = scenegraph_definition[str_2].size
	local var_3_10 = create_difficulty_button(str_2, size)
	local num_4 = 0
	local tbl_3 = {}

	for i = num, #_get_difficulty_options do
		local var_3_13 = _get_difficulty_options[i]
		local var_3_14 = DifficultySettings[var_3_13]

		if not var_3_14.dlc_requirement then
			tbl_3[#tbl_3 + 1] = var_3_13
		else
			local display_name = var_3_14.display_name
			local display_image = var_3_14.display_image
			local var_3_17 = UIWidget.init(var_3_10)

			_widgets_by_name[str .. num_2] = var_3_17
			_widgets[#_widgets + 1] = var_3_17
			tbl[#tbl + 1] = var_3_17

			local offset = var_3_17.offset
			local content = var_3_17.content

			content.difficulty_key = var_3_13
			content.title_text = Localize(display_name)
			content.icon = display_image
			offset[2] = num_4
			num_4 = num_4 - (size[2] + num_3)
			num_2 = num_2 + 1
		end
	end

	self.ui_scenegraph.game_options_left_chain.size[2] = math.abs(num_4) - num_3
	self.ui_scenegraph.game_options_right_chain.size[2] = math.abs(num_4) - num_3

	if #tbl_3 > 0 then
		local str_3 = "dlc_difficulty_divider"
		local var_3_21 = UIWidget.init(create_dlc_difficulty_divider("divider_01_top", str_3))

		_widgets_by_name.dlc_difficulty_divider = var_3_21
		_widgets[#_widgets + 1] = var_3_21
		var_3_21.style.texture_id.offset[2] = num_4 + size[2] * 0.5 + num_3 * 1.5

		local num_5 = num_4 - size[2] + num_3 * 2
		local str_4 = "difficulty_option"
		local size_2 = scenegraph_definition[str_4].size

		for i_2, v in ipairs(tbl_3) do
			local var_3_25 = DifficultySettings[v]
			local display_name_2 = var_3_25.display_name
			local display_image_2 = var_3_25.display_image
			local dlc_requirement = var_3_25.dlc_requirement
			local flag = not Managers.unlock:is_dlc_unlocked(dlc_requirement)
			local button_textures = var_3_25.button_textures
			local var_3_31 = create_difficulty_button(str_4, size_2, button_textures.lit_texture, button_textures.unlit_texture, button_textures.background, flag)
			local var_3_32 = UIWidget.init(var_3_31)

			_widgets_by_name[str .. num_2] = var_3_32
			_widgets[#_widgets + 1] = var_3_32
			tbl[#tbl + 1] = var_3_32

			local offset_2 = var_3_32.offset
			local content_2 = var_3_32.content

			content_2.difficulty_key = v
			content_2.title_text = Localize(display_name_2)
			content_2.icon = display_image_2
			offset_2[2] = num_5
			num_5 = num_5 - (size_2[2] + num_3)
		end
	end

	self._difficulty_widgets = tbl
end

StartGameWindowDifficulty._get_difficulty_options = function (arg_4_0)
	-- function 4
	return Managers.state.difficulty:get_default_difficulties()
end

StartGameWindowDifficulty.on_exit = function (self, arg_5_1)
	-- function 5
	print("[StartGameWindow] Exit Substate StartGameWindowDifficulty")

	self.ui_animator = nil

	self.parent:set_input_description(nil)

	self._has_exited = true
end

StartGameWindowDifficulty.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_animations(arg_6_1)
	self:_handle_input(arg_6_1, arg_6_2)
	self:_update_difficulty_lock()
	self:draw(arg_6_1)
end

StartGameWindowDifficulty.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

StartGameWindowDifficulty._update_animations = function (self, arg_8_1)
	-- function 8
	local ui_animator = self.ui_animator

	ui_animator:update(arg_8_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _difficulty_widgets = self._difficulty_widgets

	for k_2 = 1, #_difficulty_widgets do
		local var_8_3 = _difficulty_widgets[k_2]

		self:_animate_difficulty_option_button(var_8_3, arg_8_1)
	end
end

StartGameWindowDifficulty._is_button_pressed = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.on_pressed then
		button_hotspot.on_pressed = false

		return true
	end
end

StartGameWindowDifficulty._is_button_released = function (arg_10_0, arg_10_1)
	-- function 10
	local button_hotspot = arg_10_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowDifficulty._is_button_hover_enter = function (arg_11_0, arg_11_1)
	-- function 11
	local button_hotspot = arg_11_1.content.button_hotspot
	local on_hover_enter = button_hotspot.on_hover_enter

	on_hover_enter = not on_hover_enter and not button_hotspot.is_selected

	return on_hover_enter
end

StartGameWindowDifficulty._handle_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _difficulty_widgets = self._difficulty_widgets

	for i = 1, #_difficulty_widgets do
		local var_12_1 = _difficulty_widgets[i]

		if not self:_is_button_hover_enter(var_12_1) then
			self:_play_sound("play_gui_lobby_button_01_difficulty_select_hover")
		end

		if not self:_is_button_pressed(var_12_1) then
			local difficulty_key = var_12_1.content.difficulty_key

			self:_update_selected_difficulty_option(difficulty_key)

			local difficulties_select_sounds = UISettings.difficulties_select_sounds
			local var_12_4 = difficulties_select_sounds[i]

			var_12_4 = var_12_4 or difficulties_select_sounds[#difficulties_select_sounds]

			self:_play_sound(var_12_4)
		end
	end

	local select_button = self._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(select_button, arg_12_1)

	local buy_button = self._widgets_by_name.buy_button

	UIWidgetUtils.animate_default_button(buy_button, arg_12_1)

	local parent = self.parent

	if not self:_is_button_hover_enter(select_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if not self:_is_button_hover_enter(buy_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if not self:_is_button_released(select_button) then
		if not self._selected_difficulty_key then
			parent:set_difficulty_option(self._selected_difficulty_key)
			self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_click")
		end

		local get_selected_game_mode_layout_name = parent:get_selected_game_mode_layout_name()

		parent:set_layout_by_name(get_selected_game_mode_layout_name)
	elseif not self:_is_button_released(buy_button) then
		local dlc_name = buy_button.content.dlc_name
		local store_page_url = AreaSettings[dlc_name].store_page_url

		self:_show_storepage(store_page_url)
	end
end

StartGameWindowDifficulty._set_selected_difficulty_option = function (self, arg_13_1)
	-- function 13
	local _difficulty_widgets = self._difficulty_widgets

	for i = 1, #_difficulty_widgets do
		local content = _difficulty_widgets[i].content
		local flag = content.difficulty_key == arg_13_1

		content.button_hotspot.is_selected = flag
	end
end

StartGameWindowDifficulty._set_info_window = function (self, arg_14_1)
	-- function 14
	local var_14_0 = DifficultySettings[arg_14_1]
	local description = var_14_0.description
	local display_name = var_14_0.display_name
	local display_image = var_14_0.display_image
	local xp_multiplier = var_14_0.xp_multiplier
	local max_chest_power_level = var_14_0.max_chest_power_level
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.difficulty_title.content.text = Localize(display_name)
	_widgets_by_name.difficulty_texture.content.texture_id = display_image
	_widgets_by_name.description_text.content.text = Localize(description)
	_widgets_by_name.difficulty_chest_info.content.text = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(max_chest_power_level)
end

StartGameWindowDifficulty._update_difficulty_lock = function (self)
	-- function 15
	local _widgets_by_name = self._widgets_by_name
	local select_button = _widgets_by_name.select_button
	local buy_button = _widgets_by_name.buy_button
	local extreme_difficulty_bg = _widgets_by_name.extreme_difficulty_bg
	local extremely_hard_text = _widgets_by_name.extremely_hard_text
	local dlc_lock_text = _widgets_by_name.dlc_lock_text
	local _selected_difficulty_key = self._selected_difficulty_key

	if not _selected_difficulty_key then
		local var_15_7 = DifficultySettings[_selected_difficulty_key]
		local is_difficulty_approved, var_15_9, var_15_10, var_15_11 = self.parent:is_difficulty_approved(_selected_difficulty_key)

		if not is_difficulty_approved then
			if not var_15_10 then
				buy_button.content.button_hotspot.disable_button = false
				buy_button.content.visible = true
				buy_button.content.dlc_name = var_15_10
				select_button.content.visible = false
				dlc_lock_text.content.visible = true
			else
				buy_button.content.button_hotspot.disable_button = true
				buy_button.content.visible = false
				buy_button.content.dlc_name = nil
				select_button.content.visible = true
				dlc_lock_text.content.visible = false
			end

			select_button.content.button_hotspot.disable_button = true

			if var_15_11 or not var_15_9 then
				_widgets_by_name.difficulty_is_locked_text.content.text = Localize("required_power_level_not_met_in_party")

				if not var_15_11 then
					local required_power_level = var_15_7.required_power_level
					local var_15_13 = Localize("required_power_level")

					_widgets_by_name.difficulty_lock_text.content.text = string.format("%s: %s", var_15_13, tostring(UIUtils.presentable_hero_power_level(required_power_level)))

					local content = _widgets_by_name.difficulty_second_lock_text.content
					local var_15_15

					if not var_15_9 then
						var_15_15 = Localize(var_15_9)

						if not var_15_15 then
							-- Nothing
						end
					end

					var_15_15 = ""

					::label_15_0::

					content.text = var_15_15
				else
					local content_2 = _widgets_by_name.difficulty_lock_text.content
					local var_15_17

					if not var_15_9 then
						var_15_17 = Localize(var_15_9)

						if not var_15_17 then
							-- Nothing
						end
					end

					var_15_17 = ""

					::label_15_1::

					content_2.text = var_15_17
				end
			end

			if not self._has_exited then
				self.parent:set_input_description(nil)
			end
		else
			select_button.content.button_hotspot.disable_button = false
			select_button.content.visible = true
			buy_button.content.button_hotspot.disable_button = true
			buy_button.content.visible = false
			buy_button.content.dlc_name = nil
			dlc_lock_text.content.visible = false
			_widgets_by_name.difficulty_lock_text.content.text = ""
			_widgets_by_name.difficulty_second_lock_text.content.text = ""
			_widgets_by_name.difficulty_is_locked_text.content.text = ""

			if not self._has_exited then
				self.parent:set_input_description("select_difficulty")
			end
		end

		local content_3 = extreme_difficulty_bg.content
		local show_warning = var_15_7.show_warning

		show_warning = show_warning or false
		content_3.visible = show_warning

		local content_4 = extremely_hard_text.content
		local show_warning_2 = var_15_7.show_warning

		show_warning_2 = show_warning_2 or false
		content_4.visible = show_warning_2
	else
		select_button.content.button_hotspot.disable_button = true
		buy_button.content.button_hotspot.disable_button = true
		buy_button.content.visible = false
		buy_button.content.dlc_name = nil
		extreme_difficulty_bg.content.visible = false
		extremely_hard_text.content.visible = false
		dlc_lock_text.content.visible = false

		if not self._has_exited then
			self.parent:set_input_description(nil)
		end
	end
end

StartGameWindowDifficulty._update_selected_difficulty_option = function (self, arg_16_1)
	-- function 16
	arg_16_1 = arg_16_1 or Managers.state.difficulty:get_difficulty()

	if arg_16_1 ~= self._selected_difficulty_key then
		self:_set_selected_difficulty_option(arg_16_1)

		self._selected_difficulty_key = arg_16_1

		self:_set_info_window(arg_16_1)
	end
end

StartGameWindowDifficulty.draw = function (self, arg_17_1)
	-- function 17
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_17_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_17_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_17_4)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowDifficulty._play_sound = function (self, arg_18_1)
	-- function 18
	self.parent:play_sound(arg_18_1)
end

StartGameWindowDifficulty._animate_difficulty_option_button = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local content = arg_19_1.content
	local style = arg_19_1.style
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

	goto label_19_1

	::label_19_0::

	is_clicked = true

	::label_19_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_19_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_19_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_19_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_19_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_19_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_19_2 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
	local num_3 = 255 * input_progress

	style.button_clicked_rect.color[1] = 100 * input_progress
	style.hover_glow.color[1] = 255 * max

	local num_4 = 255 * selection_progress

	style.select_glow.color[1] = num_4
	style.skull_select_glow.color[1] = num_4
	style.icon_bg_glow.color[1] = num_4

	local title_text_disabled = style.title_text_disabled
	local default_text_color = title_text_disabled.default_text_color
	local text_color = title_text_disabled.text_color

	text_color[2] = default_text_color[2] * 0.4
	text_color[3] = default_text_color[3] * 0.4
	text_color[4] = default_text_color[4] * 0.4

	local title_text = style.title_text
	local text_color_2 = title_text.text_color
	local default_text_color_2 = title_text.default_text_color
	local select_text_color = title_text.select_text_color

	Colors.lerp_color_tables(default_text_color_2, select_text_color, max, text_color_2)

	local color = style.icon.color

	color[2] = text_color_2[2]
	color[3] = text_color_2[3]
	color[4] = text_color_2[4]

	local background_icon = style.background_icon
	local color_2 = background_icon.color
	local default_color = background_icon.default_color

	color_2[2] = default_color[2] + max * (255 - default_color[2])
	color_2[3] = default_color[3] + max * (255 - default_color[3])
	color_2[4] = default_color[4] + max * (255 - default_color[4])
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

StartGameWindowDifficulty._show_storepage = function (arg_20_0, arg_20_1)
	-- function 20
	local PLATFORM = PLATFORM

	if not IS_WINDOWS and not rawget(_G, "Steam") then
		Steam.open_url(arg_20_1)
	end
end
