-- chunkname: @scripts/ui/views/start_menu_view/states/start_menu_state_overview.lua

require("scripts/settings/profiles/sp_profiles")

local var_0_0 = local_require("scripts/ui/views/start_menu_view/states/definitions/start_menu_state_overview_definitions")
local widgets = var_0_0.widgets
local generic_input_actions = var_0_0.generic_input_actions
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local console_cursor_definition = var_0_0.console_cursor_definition
local flag = false
local tbl = {
	function (self)
		-- function 1
		Managers.input:block_device_except_service("options_menu", "gamepad")
		self:_activate_view("options_view")
	end,
	function (arg_2_0)
		-- function 2
		Managers.state.difficulty:set_difficulty("normal", 0)
		Managers.state.game_mode:start_specific_level("prologue")
	end,
	function (self)
		-- function 3
		self:_activate_view("credits_view")
	end,
	function (self)
		-- function 4
		self:_activate_view("cinematics_view")
	end
}

StartMenuStateOverview = class(StartMenuStateOverview)
StartMenuStateOverview.NAME = "StartMenuStateOverview"

StartMenuStateOverview.on_enter = function (self, arg_5_1)
	-- function 5
	self.parent:clear_wanted_state()
	print("[HeroViewState] Enter Substate StartMenuStateOverview")

	self._hero_name = arg_5_1.hero_name

	local ingame_ui_context = arg_5_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.profile_synchronizer = ingame_ui_context.profile_synchronizer
	self.is_server = ingame_ui_context.is_server
	self.world_previewer = arg_5_1.world_previewer
	self.wwise_world = arg_5_1.wwise_world
	self.platform = PLATFORM

	local player = Managers.player
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.local_player_id = ingame_ui_context.local_player_id
	self.local_player = local_player
	self._animations = {}
	self._ui_animations = {}
	self._available_profiles = {}

	self:_init_menu_views()

	local parent = self.parent
	local input_service = self:input_service(true)
	local num = UILayer.default + 30

	self.menu_input_description = MenuInputDescriptionUI:new(ingame_ui_context, self.ui_top_renderer, input_service, 3, num, generic_input_actions.default)

	self.menu_input_description:set_input_description(nil)
	self:create_ui_elements(arg_5_1)
	self:_start_transition_animation("on_enter", "on_enter")

	self._hero_preview_skin = nil
	self.use_user_skins = true

	local profile_by_peer = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)
	local _hero_name = self._hero_name

	if not _hero_name then
		local get = Managers.backend:get_interface("hero_attributes"):get(_hero_name, "career")

		get = get or 1

		self:_populate_career_page(_hero_name, get)
	end

	Managers.input:enable_gamepad_cursor()
end

StartMenuStateOverview.create_ui_elements = function (self, arg_6_1)
	-- function 6
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_6_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_6_2
		tbl_2[k] = var_6_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	if not script_data.settings.use_beta_mode and not IS_XB1 then
		tbl_2.tutorial_button.content.button_hotspot.disable_button = true
	end

	self._console_cursor = UIWidget.init(console_cursor_definition)

	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
end

StartMenuStateOverview._get_skin_item_data = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local base_skin = SPProfiles[arg_7_1].careers[arg_7_2].base_skin

	return Cosmetics[base_skin]
end

StartMenuStateOverview._wanted_state = function (self)
	-- function 8
	return (self.parent:wanted_state())
end

StartMenuStateOverview.on_exit = function (self, arg_9_1)
	-- function 9
	Managers.input:disable_gamepad_cursor()

	if not self._active_view then
		self:exit_current_view()
	end

	if not self.menu_input_description then
		self.menu_input_description:destroy()

		self.menu_input_description = nil
	end

	self.ui_animator = nil

	print("[HeroViewState] Exit Substate StartMenuStateOverview")
end

StartMenuStateOverview._update_transition_timer = function (self, arg_10_1)
	-- function 10
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_10_1, 0)
	end
end

StartMenuStateOverview.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_11_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _active_view = self._active_view

	if not _active_view then
		self._views[_active_view]:update(arg_11_1, arg_11_2)
	elseif not self._prepare_exit then
		self:_handle_input(arg_11_1, arg_11_2)
		self:_handle_keyboard_input(arg_11_1, arg_11_2)
	end

	local _wanted_state = self:_wanted_state()

	if self._transition_timer or _wanted_state or not self._new_state then
		if not self.world_previewer:has_units_spawned() then
			self._prepare_exit = true
		elseif not self._prepare_exit then
			return _wanted_state or self._new_state
		end
	end

	self:draw(arg_11_1)
end

StartMenuStateOverview.post_update = function (self, arg_12_1, arg_12_2)
	-- function 12
	self.ui_animator:update(arg_12_1)
	self:_update_animations(arg_12_1)

	if not (self.parent:transitioning() or self._transition_timer) then
		if not self._prepare_exit then
			self._prepare_exit = false

			self.world_previewer:prepare_exit()
		elseif not self._spawn_hero then
			self._spawn_hero = nil

			local _selected_hero_name = self._selected_hero_name

			_selected_hero_name = _selected_hero_name or self._hero_name

			self:_spawn_hero_unit(_selected_hero_name)
		end
	end
end

StartMenuStateOverview.draw = function (self, arg_13_1)
	-- function 13
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local parent = self.parent
	local input_service = self:input_service(true)
	local render_settings = self.render_settings
	local snap_pixel_positions = render_settings.snap_pixel_positions

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, arg_13_1, nil, render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	if not self._player_portrait_widget then
		UIRenderer.draw_widget(ui_top_renderer, self._player_portrait_widget)
	end

	if not self._active_view then
		UIRenderer.draw_widget(ui_top_renderer, self._console_cursor)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

StartMenuStateOverview._update_animations = function (self, arg_14_1)
	-- function 14
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StartMenuStateOverview._spawn_hero_unit = function (self, arg_15_1)
	-- function 15
	local world_previewer = self.world_previewer
	local career_index = self.career_index
	local var_15_2 = callback(self, "cb_hero_unit_spawned", arg_15_1)

	world_previewer:request_spawn_hero_unit(arg_15_1, self.career_index, not self.use_user_skins, var_15_2)
end

StartMenuStateOverview.cb_hero_unit_spawned = function (self, arg_16_1)
	-- function 16
	local world_previewer = self.world_previewer
	local career_index = self.career_index
	local var_16_2 = FindProfileIndex(arg_16_1)
	local var_16_3 = SPProfiles[var_16_2].careers[career_index]
	local preview_idle_animation = var_16_3.preview_idle_animation
	local preview_wield_slot = var_16_3.preview_wield_slot
	local preview_items = var_16_3.preview_items

	if not preview_items then
		for i, v in ipairs(preview_items) do
			local item_name = v.item_name
			local slot_type = ItemMasterList[item_name].slot_type
			local var_16_9 = InventorySettings.slot_names_by_type[slot_type][1]
			local var_16_10 = InventorySettings.slots_by_name[var_16_9]

			world_previewer:equip_item(item_name, var_16_10)
		end

		if not preview_wield_slot then
			world_previewer:wield_weapon_slot(preview_wield_slot)
		end
	end

	if not self.use_user_skins then
		local name = var_16_3.name
		local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_hat")

		if not get_loadout_item then
			local name_2 = get_loadout_item.data.name
			local backend_id = get_loadout_item.backend_id
			local slot_hat = InventorySettings.slots_by_name.slot_hat

			world_previewer:equip_item(name_2, slot_hat, backend_id)
		end
	end

	if not preview_idle_animation then
		self.world_previewer:play_character_animation(preview_idle_animation)
	end
end

StartMenuStateOverview._populate_career_page = function (self, arg_17_1, arg_17_2)
	-- function 17
	local var_17_0 = FindProfileIndex(arg_17_1)
	local var_17_1 = SPProfiles[var_17_0]
	local character_name = var_17_1.character_name
	local var_17_3 = var_17_1.careers[arg_17_2]
	local name = var_17_3.name
	local portrait_image = var_17_3.portrait_image
	local display_name = var_17_3.display_name
	local icon = var_17_3.icon

	self._widgets_by_name.info_career_name.content.text = Localize(display_name)
	self._spawn_hero = true
	self.career_index = arg_17_2

	local var_17_8

	if Managers.mechanism:current_mechanism_name() == "versus" then
		local get_versus_experience = ExperienceSettings.get_versus_experience()

		var_17_8 = ExperienceSettings.get_versus_profile_level_from_experience(get_versus_experience)
	else
		local get = Managers.backend:get_interface("hero_attributes"):get(arg_17_1, "experience")

		get = get or 0
		var_17_8 = ExperienceSettings.get_level(get)
	end

	self:_set_hero_info(Localize(character_name), var_17_8)

	local _get_portrait_frame = self:_get_portrait_frame(var_17_0, arg_17_2)

	self:_create_player_portrait(portrait_image, var_17_8, _get_portrait_frame)
end

StartMenuStateOverview._get_portrait_frame = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local name = SPProfiles[arg_18_1].careers[arg_18_2].name
	local str = "default"
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_frame")

	str = not get_loadout_item and get_loadout_item.data.temporary_template and str

	return str
end

StartMenuStateOverview._set_hero_info = function (self, arg_19_1, arg_19_2)
	-- function 19
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.info_hero_name.content.text = arg_19_1
	_widgets_by_name.info_hero_level.content.text = Localize("level") .. ": " .. arg_19_2
end

StartMenuStateOverview._create_player_portrait = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local var_20_0

	if not arg_20_2 then
		var_20_0 = tostring(arg_20_2)

		if not var_20_0 then
			-- Nothing
		end
	end

	var_20_0 = "-"

	::label_20_0::

	local num = 1
	local flag = false
	local create_portrait_frame = UIWidgets.create_portrait_frame("portrait_root", arg_20_3, var_20_0, num, flag, arg_20_1)

	self._player_portrait_widget = UIWidget.init(create_portrait_frame, self.ui_top_renderer)
end

StartMenuStateOverview._set_select_button_enabled = function (arg_21_0, arg_21_1)
	-- function 21
	arg_21_0._widgets_by_name.select_button.content.button_hotspot.disable_button = not arg_21_1
end

StartMenuStateOverview._clear_keyboard_selection = function (self, arg_22_1)
	-- function 22
	local _widgets_by_name = self._widgets_by_name

	for i, v in ipairs(arg_22_1) do
		for i_2, v_2 in ipairs(v) do
			_widgets_by_name[v_2].content.button_hotspot.is_selected = false
		end
	end

	self._keyboard_grid_selection = nil
end

StartMenuStateOverview._handle_keyboard_input = function (self)
	-- function 23
	local is_device_active = Managers.input:is_device_active("gamepad")
	local is_device_active_2 = Managers.input:is_device_active("mouse")
	local tbl_2 = {
		{
			"play_button",
			"options_button",
			"tutorial_button",
			"cinematics_button",
			"credits_button",
			"quit_button"
		},
		{
			"hero_button"
		}
	}

	if is_device_active_2 or not is_device_active then
		self:_clear_keyboard_selection(tbl_2)

		return
	end

	local tbl_3 = {
		play_button = function ()
			-- function 24
			self.parent:close_menu()
		end,
		options_button = function ()
			-- function 25
			tbl[1](self)
		end,
		tutorial_button = function ()
			-- function 26
			tbl[2](self)
		end,
		cinematics_button = function ()
			-- function 27
			tbl[4](self)
		end,
		credits_button = function ()
			-- function 28
			tbl[3](self)
		end,
		quit_button = function ()
			-- function 29
			Boot.quit_game = true
		end,
		hero_button = function ()
			-- function 30
			self.parent:requested_screen_change_by_name("character")
		end
	}
	local _keyboard_grid_selection = self._keyboard_grid_selection

	_keyboard_grid_selection = _keyboard_grid_selection or {}

	local var_23_5 = _keyboard_grid_selection[1]

	var_23_5 = var_23_5 or 1

	local var_23_6 = _keyboard_grid_selection[2]

	var_23_6 = var_23_6 or 1

	local input_service = self:input_service(true)

	if not input_service:get("move_down_hold_continuous") then
		var_23_6 = var_23_6 + 1
	elseif not input_service:get("move_up_hold_continuous") then
		var_23_6 = var_23_6 - 1
	elseif not input_service:get("move_right_hold_continuous") then
		var_23_5 = var_23_5 + 1
	elseif not input_service:get("move_left_hold_continuous") then
		var_23_5 = var_23_5 - 1
	elseif not input_service:get("confirm_press") then
		local var_23_8 = tbl_3[tbl_2[var_23_5][var_23_6]]

		if not var_23_8 then
			var_23_8()
			self:_play_sound("play_gui_start_menu_button_click")
		end
	end

	local clamp = math.clamp(var_23_5, 1, #tbl_2)
	local clamp_2 = math.clamp(var_23_6, 1, #tbl_2[clamp])
	local _widgets_by_name = self._widgets_by_name

	if not (clamp ~= _keyboard_grid_selection[1] or clamp_2 == _keyboard_grid_selection[2]) then
		for i, v in ipairs(tbl_2) do
			for i_2, v_2 in ipairs(v) do
				_widgets_by_name[v_2].content.button_hotspot.is_selected = i ~= clamp or i_2 == clamp_2
			end
		end

		_keyboard_grid_selection[1] = clamp
		_keyboard_grid_selection[2] = clamp_2
		self._keyboard_grid_selection = _keyboard_grid_selection

		self:_play_sound("play_gui_start_menu_button_hover")
	end
end

StartMenuStateOverview._handle_input = function (self, arg_31_1, arg_31_2)
	-- function 31
	local input_service = self:input_service(true)
	local _widgets_by_name = self._widgets_by_name
	local play_button = _widgets_by_name.play_button
	local hero_button = _widgets_by_name.hero_button
	local quit_button = _widgets_by_name.quit_button
	local credits_button = _widgets_by_name.credits_button
	local options_button = _widgets_by_name.options_button
	local tutorial_button = _widgets_by_name.tutorial_button
	local cinematics_button = _widgets_by_name.cinematics_button

	UIWidgetUtils.animate_default_button(play_button, arg_31_1)
	UIWidgetUtils.animate_default_button(hero_button, arg_31_1)
	UIWidgetUtils.animate_default_button(quit_button, arg_31_1)
	UIWidgetUtils.animate_default_button(credits_button, arg_31_1)
	UIWidgetUtils.animate_default_button(cinematics_button, arg_31_1)
	UIWidgetUtils.animate_default_button(options_button, arg_31_1)
	UIWidgetUtils.animate_default_button(tutorial_button, arg_31_1)

	if self:_is_button_hover_enter(play_button) or self:_is_button_hover_enter(hero_button) or self:_is_button_hover_enter(quit_button) or self:_is_button_hover_enter(credits_button) or self:_is_button_hover_enter(options_button) or not self:_is_button_hover_enter(tutorial_button) then
		self:_play_sound("play_gui_start_menu_button_hover")
	elseif not self:_is_button_hover_enter(cinematics_button) then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	if not self:_is_button_pressed(hero_button) then
		self:_play_sound("play_gui_start_menu_button_click")
		self.parent:requested_screen_change_by_name("character")
	elseif not self:_is_button_pressed(play_button) then
		self:_play_sound("play_gui_start_menu_button_click")
		self.parent:close_menu()
	elseif not self:_is_button_pressed(options_button) then
		self:_play_sound("play_gui_start_menu_button_click")
		tbl[1](self)
		self:_play_sound("play_gui_start_menu_button_click")
	elseif not self:_is_button_pressed(tutorial_button) then
		tbl[2](self)
		self:_play_sound("play_gui_start_menu_button_click")
	elseif not self:_is_button_pressed(cinematics_button) then
		tbl[4](self)
		self:_play_sound("play_gui_start_menu_button_click")
	elseif not self:_is_button_pressed(credits_button) then
		tbl[3](self)
	elseif not self:_is_button_pressed(quit_button) then
		self:_play_sound("play_gui_start_menu_button_click")

		Boot.quit_game = true
	end

	if not Development.parameter("tobii_button") then
		self:_handle_tobii_button(arg_31_1)
	end
end

StartMenuStateOverview._handle_tobii_button = function (self, arg_32_1)
	-- function 32
	local tobii_button = self._widgets_by_name.tobii_button

	UIWidgetUtils.animate_default_button(tobii_button, arg_32_1)

	if not self:_is_button_pressed(tobii_button) then
		self:_play_sound("play_gui_start_menu_button_click")

		local str = "https://vermintide2beta.com/?utm_medium=referral&utm_campaign=vermintide2beta&utm_source=ingame#challenge"

		Application.open_url_in_browser(str)
	end
end

StartMenuStateOverview.game_popup_active = function (self)
	-- function 33
	return self._show_play_popup
end

StartMenuStateOverview._is_button_pressed = function (arg_34_0, arg_34_1)
	-- function 34
	local button_hotspot = arg_34_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartMenuStateOverview._is_button_hover_enter = function (arg_35_0, arg_35_1)
	-- function 35
	return arg_35_1.content.button_hotspot.on_hover_enter
end

StartMenuStateOverview._is_button_hover_exit = function (arg_36_0, arg_36_1)
	-- function 36
	return arg_36_1.content.button_hotspot.on_hover_exit
end

StartMenuStateOverview._play_sound = function (self, arg_37_1)
	-- function 37
	self.parent:play_sound(arg_37_1)
end

StartMenuStateOverview.get_camera_position = function (self)
	-- function 38
	local get_background_world, var_38_1 = self.parent:get_background_world()
	local camera = ScriptViewport.camera(var_38_1)

	return ScriptCamera.position(camera)
end

StartMenuStateOverview.get_camera_rotation = function (self)
	-- function 39
	local get_background_world, var_39_1 = self.parent:get_background_world()
	local camera = ScriptViewport.camera(var_39_1)

	return ScriptCamera.rotation(camera)
end

StartMenuStateOverview.trigger_unit_flow_event = function (arg_40_0, arg_40_1, arg_40_2)
	-- function 40
	if not arg_40_1 and not Unit.alive(arg_40_1) then
		Unit.flow_event(arg_40_1, arg_40_2)
	end
end

StartMenuStateOverview._start_transition_animation = function (self, arg_41_1, arg_41_2)
	-- function 41
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_41_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_41_1] = start_animation
end

StartMenuStateOverview._on_option_button_hover = function (self, arg_42_1, arg_42_2)
	-- function 42
	local _ui_animations = self._ui_animations
	local str = "option_button_" .. arg_42_2
	local var_42_2 = arg_42_1.style[arg_42_2]
	local var_42_3 = var_42_2.color[2]
	local num = 255
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration
	local num_2 = (1 - var_42_3 / num) * topic_hover_duration

	for i = 2, 4 do
		if num_2 > 0 then
			_ui_animations[str .. "_hover_" .. i] = self:_animate_element_by_time(var_42_2.color, i, var_42_3, num, num_2)
		else
			var_42_2.color[i] = num
		end
	end
end

StartMenuStateOverview._on_option_button_dehover = function (self, arg_43_1, arg_43_2)
	-- function 43
	local _ui_animations = self._ui_animations
	local str = "option_button_" .. arg_43_2
	local var_43_2 = arg_43_1.style[arg_43_2]
	local var_43_3 = var_43_2.color[1]
	local num = 100
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration
	local num_2 = var_43_3 / 255 * topic_hover_duration

	for i = 2, 4 do
		if num_2 > 0 then
			_ui_animations[str .. "_hover_" .. i] = self:_animate_element_by_time(var_43_2.color, i, var_43_3, num, num_2)
		else
			var_43_2.color[1] = num
		end
	end
end

StartMenuStateOverview.play_sound = function (arg_44_0, arg_44_1)
	-- function 44
	return
end

StartMenuStateOverview._animate_element_by_time = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5)
	-- function 45
	return (UIAnimation.init(UIAnimation.function_by_time, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, math.ease_out_quad))
end

StartMenuStateOverview._animate_element_by_catmullrom = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8)
	-- function 46
	return (UIAnimation.init(UIAnimation.catmullrom, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8))
end

StartMenuStateOverview._init_menu_views = function (self)
	-- function 47
	local ingame_ui_context = self.ingame_ui_context

	self._views = {
		credits_view = CreditsView:new(ingame_ui_context),
		options_view = OptionsView:new(ingame_ui_context),
		cinematics_view = CinematicsView:new(ingame_ui_context)
	}

	for k, v in pairs(self._views) do
		v.exit = function ()
			-- function 48
			self:exit_current_view()
		end
	end
end

StartMenuStateOverview._activate_view = function (self, arg_49_1)
	-- function 49
	self._active_view = arg_49_1

	local _views = self._views

	assert(_views[arg_49_1])

	if not arg_49_1 and not _views[arg_49_1] and not _views[arg_49_1].on_enter then
		Managers.input:disable_gamepad_cursor()
		_views[arg_49_1]:on_enter()
	end
end

StartMenuStateOverview.exit_current_view = function (self)
	-- function 50
	local _active_view = self._active_view
	local _views = self._views

	assert(_active_view)

	if not _views[_active_view] and not _views[_active_view].on_exit then
		_views[_active_view]:on_exit()
	end

	self._active_view = nil

	local name = self:input_service(true).name
	local input = Managers.input

	input:block_device_except_service(name, "keyboard")
	input:block_device_except_service(name, "mouse")
	input:block_device_except_service(name, "gamepad")
	Managers.input:enable_gamepad_cursor()
end

StartMenuStateOverview.input_service = function (self, arg_51_1)
	-- function 51
	if not arg_51_1 then
		local _active_view = self._active_view
		local var_51_1 = self._views[_active_view]

		if not var_51_1 then
			return var_51_1:input_service()
		end
	end

	return self.parent:input_service(true)
end
