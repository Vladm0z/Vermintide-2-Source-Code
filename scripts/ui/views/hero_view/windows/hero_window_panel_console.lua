-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_panel_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_panel_console_definitions")
local widgets = var_0_0.widgets
local title_button_definitions = var_0_0.title_button_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local create_bot_warning = var_0_0.create_bot_warning
local create_bot_cusomization_button = var_0_0.create_bot_cusomization_button
local tbl = {
	"equipment",
	"talents",
	"forge",
	"cosmetics",
	"pactsworn_equipment",
	"system"
}
local tbl_2 = {}

for i, v in ipairs(tbl) do
	tbl_2[v] = i
end

local str = "cycle_next"
local str_2 = "cycle_previous"
local str_3 = "show_gamercard"
local flag = false

HeroWindowPanelConsole = class(HeroWindowPanelConsole)
HeroWindowPanelConsole.NAME = "HeroWindowPanelConsole"

HeroWindowPanelConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowPanelConsole")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id

	local is_in_inn = ingame_ui_context.is_in_inn

	is_in_inn = is_in_inn or false
	self.is_in_inn = is_in_inn
	self.force_ingame_menu = arg_1_1.force_ingame_menu
	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.profile_index = arg_1_1.profile_index

	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_1_5 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_1_5].careers[career_index].name

	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self.conditions_params = {
		hero_name = self.hero_name,
		career_name = name,
		rarities_to_ignore = table.enum_safe("magic")
	}

	local _title_button_widgets = self._title_button_widgets

	self.button_widgets_by_news_template = {
		equipment = _title_button_widgets[1],
		talent = _title_button_widgets[2],
		cosmetics = _title_button_widgets[4]
	}

	if not (not self.is_in_inn and self.force_ingame_menu) then
		self:_setup_text_buttons_width()
		self:_setup_input_buttons()
	else
		local system_button = self._widgets_by_name.system_button

		system_button.content.button_hotspot.is_selected = true

		if not (IS_WINDOWS or self.is_in_inn) then
			system_button.content.visible = false
		end
	end

	self:_validate_product_owner()
end

HeroWindowPanelConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings,
		ui_scenegraph = self.ui_scenegraph
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self.ui_animator:start_animation(arg_2_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowPanelConsole.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl_2 = {}
	local tbl_3 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl_2[#tbl_2 + 1] = var_3_2
		tbl_3[k] = var_3_2
	end

	local var_3_3 = UIWidget.init(create_bot_cusomization_button(self.ui_renderer))

	tbl_2[#tbl_2 + 1] = var_3_3
	tbl_3.bot_customization_button = var_3_3
	self._widgets = tbl_2
	self._widgets_by_name = tbl_3

	local tbl_4 = {}

	for k_2, v_2 in pairs(title_button_definitions) do
		local var_3_5 = UIWidget.init(v_2)

		tbl_4[#tbl_4 + 1] = var_3_5
	end

	assert(tbl_4[3].content.text_field == "hero_window_crafting")

	tbl_4[3].content.button_hotspot.disable_button = GameSettingsDevelopment.read_only_backend

	for i4 = 1, #tbl_4 do
		tbl_4[i4].content.button_hotspot.disable_button = not self.parent:can_add(tbl[i4])
	end

	self._title_button_widgets = tbl_4

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	self._widgets_by_name.bot_customization_button.content.visible = not not self.force_ingame_menu or self.is_in_inn
end

HeroWindowPanelConsole.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate HeroWindowPanelConsole")

	self.ui_animator = nil
end

HeroWindowPanelConsole.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_handle_gamepad_activity()
	self:_handle_back_button_visibility()
	self:_handle_bot_warning()

	if not (not self.is_in_inn and self.force_ingame_menu) then
		self:_sync_news(arg_5_1, arg_5_2)
		self:_update_selected_option()
	end

	self:_update_animations(arg_5_1)
	self:draw(arg_5_1)
end

HeroWindowPanelConsole.post_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_handle_input(arg_6_1, arg_6_2)
end

HeroWindowPanelConsole._handle_bot_warning = function (self)
	-- function 7
	if not self.parent:is_bot_career() then
		local get_career_data, var_7_1 = self.parent:get_career_data()

		if not (get_career_data ~= self._current_profile_index or var_7_1 == self._current_career_index) then
			self:_set_bot_information(get_career_data, var_7_1)

			self._current_profile_index = get_career_data
			self._current_career_index = var_7_1

			self:_start_transition_animation("bot_info_enter")
		end
	elseif self._current_profile_index or not self._current_career_index then
		self:_start_transition_animation("bot_info_exit")

		local bot_customization_button = self._widgets_by_name.bot_customization_button

		bot_customization_button.content.managing_career_name = ""
		bot_customization_button.content.playing_career_name = ""
		self._current_profile_index = nil
		self._current_career_index = nil
	end
end

HeroWindowPanelConsole._set_bot_information = function (self, arg_8_1, arg_8_2)
	-- function 8
	local local_player = Managers.player:local_player()
	local profile_index = local_player:profile_index()
	local career_index = local_player:career_index()
	local display_name = SPProfiles[profile_index].careers[career_index].display_name
	local display_name_2 = SPProfiles[arg_8_1].careers[arg_8_2].display_name
	local bot_customization_button = self._widgets_by_name.bot_customization_button

	bot_customization_button.content.managing_career_name = Localize(display_name_2)
	bot_customization_button.content.playing_career_name = Localize(display_name)
end

HeroWindowPanelConsole._update_animations = function (self, arg_9_1)
	-- function 9
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_9_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	ui_animator:update(arg_9_1)

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	local _title_button_widgets = self._title_button_widgets

	for i, v_3 in ipairs(_title_button_widgets) do
		self:_animate_title_entry(v_3, arg_9_1)
	end

	self:_animate_title_entry(self._widgets_by_name.system_button, arg_9_1)
	self:_animate_title_entry(self._widgets_by_name.bot_customization_button, arg_9_1)
	self:_animate_back_button(self._widgets_by_name.back_button, arg_9_1)
	self:_animate_back_button(self._widgets_by_name.close_button, arg_9_1)

	if not self._present_purchase_add then
		self:_animate_purchase_add(arg_9_1)
	end
end

HeroWindowPanelConsole._is_button_pressed = function (arg_10_0, arg_10_1)
	-- function 10
	local content = arg_10_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.button_text

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowPanelConsole._is_stepper_button_pressed = function (arg_11_0, arg_11_1)
	-- function 11
	local content = arg_11_1.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if not button_hotspot_left.on_release then
		button_hotspot_left.on_release = false

		return true, -1
	elseif not button_hotspot_right.on_release then
		button_hotspot_right.on_release = false

		return true, 1
	end
end

HeroWindowPanelConsole._is_button_hover_enter = function (arg_12_0, arg_12_1)
	-- function 12
	return arg_12_1.content.button_hotspot.on_hover_enter
end

HeroWindowPanelConsole._is_button_hover_exit = function (arg_13_0, arg_13_1)
	-- function 13
	return arg_13_1.content.button_hotspot.on_hover_exit
end

HeroWindowPanelConsole._is_button_selected = function (arg_14_0, arg_14_1)
	-- function 14
	return arg_14_1.content.button_hotspot.is_selected
end

HeroWindowPanelConsole._handle_input = function (self, arg_15_1, arg_15_2)
	-- function 15
	local parent = self.parent
	local _widgets_by_name = self._widgets_by_name
	local _title_button_widgets = self._title_button_widgets
	local window_input_service = self.parent:window_input_service()
	local flag = false
	local close_button = _widgets_by_name.close_button
	local back_button = _widgets_by_name.back_button

	if self:_is_button_hover_enter(back_button) or not self:_is_button_hover_enter(close_button) then
		self:_play_sound("Play_hud_hover")
	end

	if flag or not self:_is_button_pressed(close_button) then
		parent:close_menu()

		flag = true
	end

	if self.force_ingame_menu or parent:close_on_exit() or flag or not self:_is_button_pressed(back_button) then
		local get_previous_selected_game_mode_index = parent:get_previous_selected_game_mode_index()

		if not get_previous_selected_game_mode_index then
			self:_reset_back_button()
			self.parent:set_layout(get_previous_selected_game_mode_index)

			flag = true
		end
	end

	if not (not self.is_in_inn and self.force_ingame_menu) then
		local _title_button_widgets_2 = self._title_button_widgets

		for i, v in ipairs(_title_button_widgets_2) do
			if not self:_is_button_hover_enter(v) then
				self:_play_sound("Play_hud_hover")
			end

			if not self:_is_button_pressed(v) then
				self:_on_panel_button_selected(i)

				flag = true
			end
		end

		local system_button = _widgets_by_name.system_button

		if not self:_is_button_hover_enter(system_button) then
			self:_play_sound("Play_hud_hover")
		end

		if flag or not self:_is_button_pressed(system_button) then
			local system = tbl_2.system

			self:_on_panel_button_selected(system)

			flag = true
		end

		if not (flag or self.parent.parent:input_blocked()) then
			local _selected_index = self._selected_index

			_selected_index = _selected_index or 1

			local count = #tbl
			local var_15_13

			if not window_input_service:get(str_2) then
				for k = #tbl, 1, -1 do
					if k == _selected_index then
						var_15_13 = not (_selected_index > 1) or not (_selected_index - 1) or count

						if not self.parent:can_add(tbl[var_15_13]) then
							break
						else
							_selected_index = var_15_13
						end
					end
				end

				self:_on_panel_button_selected(var_15_13)
			elseif not window_input_service:get(str) then
				for l = 1, #tbl do
					if l == _selected_index then
						var_15_13 = 1 + _selected_index % count

						if not self.parent:can_add(tbl[var_15_13]) then
							break
						else
							_selected_index = var_15_13
						end
					end
				end

				self:_on_panel_button_selected(var_15_13)
			end
		end

		if (flag or not self._present_purchase_add) and not window_input_service:get(str_3) and not IS_XB1 then
			local flag_2 = true

			self:_open_marketplace_xb1()
		end

		local bot_customization_button = _widgets_by_name.bot_customization_button

		if not UIUtils.is_button_hover_enter(bot_customization_button) then
			self:_play_sound("Play_hud_hover")
		end

		if UIUtils.is_button_pressed(bot_customization_button) or not window_input_service:get("show_gamercard") then
			self.parent:set_layout_by_name("character_selection")
		end
	end
end

HeroWindowPanelConsole._on_panel_button_selected = function (self, arg_16_1)
	-- function 16
	local get_layout_name = self.parent:get_layout_name()
	local var_16_1 = tbl[arg_16_1]

	if var_16_1 ~= get_layout_name then
		local var_16_2 = tbl[self._selected_index]

		self.parent:window_layout_on_exit(var_16_2)
		self.parent:set_layout_by_name(var_16_1)
	end
end

HeroWindowPanelConsole._set_selected_option = function (self, arg_17_1)
	-- function 17
	self._widgets_by_name.system_button.content.button_hotspot.is_selected = tbl[arg_17_1] == "system"

	local _title_button_widgets = self._title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		v.content.button_hotspot.is_selected = i == arg_17_1
	end
end

HeroWindowPanelConsole._update_selected_option = function (self)
	-- function 18
	local get_layout_name = self.parent:get_layout_name()
	local find = table.find(tbl, get_layout_name)

	if not (not find and find == self._selected_index) then
		self:_set_selected_option(find)

		self._selected_index = find
	end

	local bot_customization_button = self._widgets_by_name.bot_customization_button

	bot_customization_button.content.button_hotspot.is_selected = get_layout_name == "character_selection"

	local button_hotspot = bot_customization_button.content.button_hotspot
	local flag

	flag = not bot_customization_button.content.button_hotspot.is_selected and 1 and bot_customization_button.content.button_hotspot.hover_progress
	button_hotspot.hover_progress = flag
end

HeroWindowPanelConsole.draw = function (self, arg_19_1)
	-- function 19
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_19_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	if not (not self.is_in_inn and self.force_ingame_menu) then
		for i_2, v_2 in ipairs(self._title_button_widgets) do
			UIRenderer.draw_widget(ui_renderer, v_2)
		end
	end

	if not self._bot_warning_widget then
		UIRenderer.draw_widget(ui_renderer, self._bot_warning_widget)
	end

	UIRenderer.end_pass(ui_renderer)
end

HeroWindowPanelConsole._play_sound = function (self, arg_20_1)
	-- function 20
	self.parent:play_sound(arg_20_1)
end

HeroWindowPanelConsole._sync_news = function (self, arg_21_1, arg_21_2)
	-- function 21
	local _sync_delay = self._sync_delay

	if not _sync_delay then
		local max = math.max(0, _sync_delay - arg_21_1)

		if max == 0 then
			self._sync_delay = nil
		else
			self._sync_delay = max
		end

		return
	end

	local player_unit = Managers.player:local_player(1).player_unit
	local NewsFeedTemplates = NewsFeedTemplates
	local conditions_params = self.conditions_params
	local button_widgets_by_news_template = self.button_widgets_by_news_template

	if not player_unit then
		for k, v in pairs(button_widgets_by_news_template) do
			local condition_func = NewsFeedTemplates[FindNewsTemplateIndex(k)].condition_func

			v.content.new = condition_func(conditions_params)
		end
	end

	self._sync_delay = 4
end

HeroWindowPanelConsole._setup_input_buttons = function (self)
	-- function 22
	if not self.parent:input_blocked() then
		return
	end

	local window_input_service = self.parent:window_input_service()
	local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, str_2, true)
	local get_gamepad_input_texture_data_2 = UISettings.get_gamepad_input_texture_data(window_input_service, str, true)
	local _widgets_by_name = self._widgets_by_name
	local panel_input_area_1 = _widgets_by_name.panel_input_area_1
	local panel_input_area_2 = _widgets_by_name.panel_input_area_2
	local texture_id = panel_input_area_1.style.texture_id

	texture_id.horizontal_alignment = "center"
	texture_id.vertical_alignment = "center"
	texture_id.texture_size = {
		get_gamepad_input_texture_data.size[1],
		get_gamepad_input_texture_data.size[2]
	}
	panel_input_area_1.content.texture_id = get_gamepad_input_texture_data.texture

	local texture_id_2 = panel_input_area_2.style.texture_id

	texture_id_2.horizontal_alignment = "center"
	texture_id_2.vertical_alignment = "center"
	texture_id_2.texture_size = {
		get_gamepad_input_texture_data_2.size[1],
		get_gamepad_input_texture_data_2.size[2]
	}
	panel_input_area_2.content.texture_id = get_gamepad_input_texture_data_2.texture
end

HeroWindowPanelConsole._handle_back_button_visibility = function (self)
	-- function 23
	if not self.gamepad_active_last_frame then
		local close_on_exit = self.parent:close_on_exit()
		local back_button = self._widgets_by_name.back_button
		local flag = not close_on_exit

		back_button.content.visible = flag
	end
end

HeroWindowPanelConsole._reset_back_button = function (self)
	-- function 24
	local button_hotspot = self._widgets_by_name.back_button.content.button_hotspot

	table.clear(button_hotspot)
end

HeroWindowPanelConsole._handle_gamepad_activity = function (self)
	-- function 25
	local is_device_active = Managers.input:is_device_active("gamepad")
	local get_most_recent_device = Managers.input:get_most_recent_device()
	local flag = self.gamepad_active_last_frame == nil or not is_device_active or get_most_recent_device ~= self._most_recent_device

	if not is_device_active then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			local _widgets_by_name = self._widgets_by_name
			local flag_2 = not self.is_in_inn and not not self.force_ingame_menu or false

			_widgets_by_name.panel_input_area_1.content.visible = flag_2
			_widgets_by_name.panel_input_area_2.content.visible = flag_2
			_widgets_by_name.back_button.content.visible = false
			_widgets_by_name.close_button.content.visible = false

			self:_setup_input_buttons()
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		local _widgets_by_name_2 = self._widgets_by_name

		_widgets_by_name_2.panel_input_area_1.content.visible = false
		_widgets_by_name_2.panel_input_area_2.content.visible = false
		_widgets_by_name_2.close_button.content.visible = true
	end

	self._most_recent_device = get_most_recent_device
end

HeroWindowPanelConsole._setup_text_buttons_width = function (self)
	-- function 26
	local var_26_0 = self.ui_scenegraph.panel_entry_area.size[1]
	local num = 0
	local _title_button_widgets = self._title_button_widgets
	local count = #_title_button_widgets
	local floor = math.floor(var_26_0 / count)

	for i, v in ipairs(_title_button_widgets) do
		self:_set_text_button_size(v, floor)

		local num_2 = floor * (i - 1)

		self:_set_text_button_horizontal_position(v, num_2)
	end
end

HeroWindowPanelConsole._set_text_button_size = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	arg_27_0.ui_scenegraph[arg_27_1.scenegraph_id].size[1] = arg_27_2

	local style = arg_27_1.style

	style.selected_texture.texture_size[1] = arg_27_2

	local num = 5
	local num_2 = arg_27_2 - num * 2

	style.text.size[1] = num_2
	style.text_shadow.size[1] = num_2
	style.text_hover.size[1] = num_2
	style.text_disabled.size[1] = num_2
	style.text.offset[1] = style.text.default_offset[1] + num
	style.text_shadow.offset[1] = style.text_shadow.default_offset[1] + num
	style.text_hover.offset[1] = style.text_hover.default_offset[1] + num
	style.text_disabled.offset[1] = style.text_disabled.default_offset[1] + num
end

local get_color_table_with_alpha = Colors.get_color_table_with_alpha("white", 255)

HeroWindowPanelConsole._animate_purchase_add = function (self, arg_28_1)
	-- function 28
	local style = self._widgets_by_name.preorder_text.style
	local num = 0.5 + math.sin(Managers.time:time("ui") * 3) * 0.5
	local num_2 = math.easeOutCubic(num) * 10
	local text_color = style.text.text_color
	local text_color_2 = style.text_shadow.text_color
	local num_3 = math.easeOutCubic(num) * 0.5

	text_color[2] = get_color_table_with_alpha[2] * 0.5 + get_color_table_with_alpha[2] * num_3
	text_color[3] = get_color_table_with_alpha[3] * 0.5 + get_color_table_with_alpha[3] * num_3
	text_color[4] = get_color_table_with_alpha[4] * 0.5 + get_color_table_with_alpha[4] * num_3
end

HeroWindowPanelConsole._set_text_button_horizontal_position = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	arg_29_0.ui_scenegraph[arg_29_1.scenegraph_id].local_position[1] = arg_29_2
end

HeroWindowPanelConsole._validate_product_owner = function (self)
	-- function 30
	local var_30_0

	if not IS_XB1 and not script_data.settings.use_beta_mode then
		var_30_0 = not Managers.unlock:is_dlc_unlocked("vt2")
	else
		var_30_0 = false
	end

	self._present_purchase_add = var_30_0

	self:_set_purchase_add_visibility(var_30_0)
end

HeroWindowPanelConsole._open_marketplace_xb1 = function (arg_31_0)
	-- function 31
	local user_id = Managers.account:user_id()
	local str = "dc4149cc-19c1-4a90-885f-6883868b053a"

	XboxLive.show_product_details(user_id, str)
end

HeroWindowPanelConsole._set_purchase_add_visibility = function (self, arg_32_1)
	-- function 32
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.preorder_text.content.visible = arg_32_1
	_widgets_by_name.preorder_input.content.visible = arg_32_1
	_widgets_by_name.preorder_text_bg.content.visible = arg_32_1
	_widgets_by_name.preorder_divider.content.visible = arg_32_1
	_widgets_by_name.preorder_divider_top.content.visible = arg_32_1
	_widgets_by_name.preorder_divider_effect.content.visible = arg_32_1
	_widgets_by_name.preorder_divider_top_effect.content.visible = arg_32_1
end

HeroWindowPanelConsole._animate_title_entry = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local content = arg_33_1.content
	local style = arg_33_1.style
	local button_hotspot = content.button_hotspot
	local is_hover = button_hotspot.is_hover
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

	goto label_33_1

	::label_33_0::

	is_clicked = true

	::label_33_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_33_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_33_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_33_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_33_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_33_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_33_2 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
	local num_3 = 255 * max

	style.selected_texture.color[1] = num_3

	if not style.text then
		local num_4 = 4 * max

		style.text.offset[2] = 5 - num_4
		style.text_shadow.offset[2] = 3 - num_4
		style.text_hover.offset[2] = 5 - num_4
		style.text_disabled.offset[2] = 5 - num_4
	end

	if not style.new_marker then
		local num_5 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

		style.new_marker.color[1] = 100 + 155 * num_5
	end

	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

HeroWindowPanelConsole._animate_back_button = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	local content = arg_34_1.content
	local style = arg_34_1.style
	local button_hotspot = content.button_hotspot
	local is_hover = button_hotspot.is_hover
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

	goto label_34_1

	::label_34_0::

	is_clicked = true

	::label_34_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_34_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_34_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_34_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_34_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_34_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_34_2 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
	local num_3 = 255 * max

	style.texture_id.color[1] = 255 - num_3
	style.texture_hover_id.color[1] = num_3
	style.selected_texture.color[1] = num_3
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end
