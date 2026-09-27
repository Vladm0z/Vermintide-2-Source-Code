-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_keep_decorations.lua

require("scripts/ui/helpers/scrollbar_logic")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_keep_decorations_definitions")
local widgets_definitions = var_0_0.widgets_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local generic_input_actions = var_0_0.generic_input_actions
local animation_definitions = var_0_0.animation_definitions
local entry_widget_definition = var_0_0.entry_widget_definition
local dummy_entry_widget_definition = var_0_0.dummy_entry_widget_definition
local input_actions = var_0_0.input_actions
local flag = false
local num = 4
local num_2 = 800
local num_3 = 1

HeroViewStateKeepDecorations = class(HeroViewStateKeepDecorations)
HeroViewStateKeepDecorations.NAME = "HeroViewStateKeepDecorations"

HeroViewStateKeepDecorations.on_enter = function (self, arg_1_1)
	-- function 1
	print("[HeroViewState] Enter Substate HeroViewStateKeepDecorations")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._voting_manager = ingame_ui_context.voting_manager
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._wwise_world = arg_1_1.wwise_world
	self._is_server = ingame_ui_context.is_server

	local input_service = self:input_service()

	self._menu_input_description = MenuInputDescriptionUI:new(ingame_ui_context, self._ui_top_renderer, input_service, 3, 100, generic_input_actions)

	self._menu_input_description:set_input_description(nil)

	self._animations = {}
	self._ui_animations = {}
	self._decoration_system = Managers.state.entity:system("keep_decoration_system")
	self._keep_decoration_backend_interface = Managers.backend:get_interface("keep_decorations")

	self:_create_ui_elements(arg_1_1)

	if not arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		self:_start_transition_animation("on_enter", "on_enter")
	end

	self:_play_sound("Play_hud_trophy_open")

	local state_params = arg_1_1.state_params
	local interactable_unit = state_params.interactable_unit

	self._interactable_unit = interactable_unit
	self._type = state_params.type

	if self._type == "painting" then
		self._default_table = DefaultPaintings
		self._main_table = Paintings
		self._ordered_table = PaintingOrder
		self._empty_decoration_name = "hor_none"
	elseif self._type == "trophy" then
		self._default_table = DefaultTrophies
		self._main_table = Trophies
		self._ordered_table = TrophyOrder
		self._empty_decoration_name = "hub_trophy_empty"
	end

	self._default_decorations = {}

	table.append(self._default_decorations, DefaultPaintings)
	table.append(self._default_decorations, DefaultTrophies)

	local get_data = Unit.get_data(interactable_unit, "interaction_data", "camera_interaction_name")
	local get_data_2 = Unit.get_data(interactable_unit, "interaction_data", "hide_character")

	self._hide_character = get_data_2

	local local_player = Managers.player:local_player()

	if not local_player then
		local map = UISettings.map
		local get_data_3 = Unit.get_data(interactable_unit, "interaction_data", "camera_transition_time_in")

		get_data_3 = get_data_3 or 0.5
		map.camera_time_enter = get_data_3

		local map_2 = UISettings.map
		local get_data_4 = Unit.get_data(interactable_unit, "interaction_data", "camera_transition_time_out")

		get_data_4 = get_data_4 or 0.5
		map_2.camera_time_exit = get_data_4

		local tbl = {
			camera_interaction_name = get_data
		}

		CharacterStateHelper.change_camera_state(local_player, "camera_state_interaction", tbl)

		local player_unit = local_player.player_unit

		if not Unit.alive(player_unit) then
			local extension = ScriptUnit.extension(player_unit, "first_person_system")

			extension:abort_toggle_visibility_timer()
			extension:abort_first_person_units_visibility_timer()

			if not get_data_2 then
				if not extension:first_person_mode_active() then
					extension:set_first_person_mode(true)
				end

				if not extension:first_person_units_visible() then
					extension:toggle_first_person_units_visibility("third_person_mode")
				end
			elseif not extension:first_person_mode_active() then
				extension:set_first_person_mode(false)
			end
		end
	end

	if not Unit.get_data(interactable_unit, "decoration_settings_key") then
		local extension_2 = ScriptUnit.extension(interactable_unit, "keep_decoration_system")
		local get_selected_decoration = extension_2:get_selected_decoration()

		self._keep_decoration_extension = extension_2

		local get_data_5 = Unit.get_data(interactable_unit, "interaction_data", "view_only")

		get_data_5 = get_data_5 or not self._is_server

		if not get_data_5 then
			self:_set_info_by_decoration_key(get_selected_decoration, false)
		else
			self._customizable_decoration = true

			self:_setup_decorations_list()

			local num = 1
			local _list_widgets = self._list_widgets

			for i = 1, #_list_widgets do
				if _list_widgets[i].content.key == get_selected_decoration then
					num = i

					break
				end
			end

			self:_on_list_index_selected(num)

			local _get_scrollbar_percentage_by_index = self:_get_scrollbar_percentage_by_index(num)

			self._scrollbar_logic:set_scroll_percentage(_get_scrollbar_percentage_by_index)
		end
	else
		self:_initialize_simple_decoration_preview()
	end

	if not self._customizable_decoration then
		self:_disable_list_widgets()
	end
end

HeroViewStateKeepDecorations._disable_list_widgets = function (self)
	-- function 2
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.list_mask.content.visible = false
	_widgets_by_name.list_scrollbar.content.visible = false
	_widgets_by_name.confirm_button.content.visible = false
	_widgets_by_name.list_detail_top.content.visible = false
	_widgets_by_name.list_detail_bottom.content.visible = false
end

HeroViewStateKeepDecorations._initialize_simple_decoration_preview = function (self)
	-- function 3
	local _interactable_unit = self._interactable_unit
	local get_data = Unit.get_data(_interactable_unit, "interaction_data", "hud_text_line_1")
	local get_data_2 = Unit.get_data(_interactable_unit, "interaction_data", "hud_text_line_2")
	local get_data_3 = Unit.get_data(_interactable_unit, "interaction_data", "sound_event")

	if not (not get_data_3 and get_data_3 == "") then
		self._sound_event = get_data_3

		local var_3_4

		if not self._sound_event then
			var_3_4 = num_3

			if not var_3_4 then
				-- Nothing
			end
		end

		var_3_4 = nil

		::label_3_0::

		self._sound_event_delay = var_3_4
	end

	local var_3_5 = Localize(get_data)
	local var_3_6 = Localize(get_data_2)

	self:_set_info_texts(var_3_5, var_3_6)
end

HeroViewStateKeepDecorations.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewState] Exit Substate HeroViewStateKeepDecorations")

	self.ui_animator = nil

	if not self._customizable_decoration then
		local _interactable_unit = self._interactable_unit

		ScriptUnit.extension(_interactable_unit, "keep_decoration_system"):reset_selection()
	end

	if not self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false)
	end

	self:_play_sound("Stop_all_keep_decorations_desc_vo")
	self:_play_sound("Stop_trophy_music")

	local local_player = Managers.player:local_player()

	if not local_player then
		CharacterStateHelper.change_camera_state(local_player, "follow")

		local player_unit = local_player.player_unit

		if not Unit.alive(player_unit) then
			local extension = ScriptUnit.extension(player_unit, "first_person_system")

			extension:abort_toggle_visibility_timer()
			extension:abort_first_person_units_visibility_timer()

			local camera_time_exit = UISettings.map.camera_time_exit

			camera_time_exit = camera_time_exit or 0.5

			if not extension:first_person_mode_active() then
				extension:toggle_visibility(camera_time_exit)
			elseif not extension:first_person_units_visible() then
				extension:toggle_first_person_units_visibility("third_person_mode", camera_time_exit)
			end
		end
	end
end

HeroViewStateKeepDecorations._create_ui_elements = function (self, arg_5_1)
	-- function 5
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets_definitions) do
		if not v then
			local var_5_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_5_2
			tbl_2[k] = var_5_2
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local list_scrollbar = self._widgets_by_name.list_scrollbar

	self._scrollbar_logic = ScrollBarLogic:new(list_scrollbar)
end

HeroViewStateKeepDecorations._set_color_alpha_intensity = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_set_color_values(arg_6_1, arg_6_1[1] * arg_6_2)
end

HeroViewStateKeepDecorations._set_color_intensity = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:_set_color_values(arg_7_1, nil, arg_7_1[2] * arg_7_2, arg_7_1[3] * arg_7_2, arg_7_1[4] * arg_7_2)
end

HeroViewStateKeepDecorations._set_color_values = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	arg_8_1[1] = arg_8_2 or arg_8_1[1]
	arg_8_1[2] = arg_8_3 or arg_8_1[2]
	arg_8_1[3] = arg_8_4 or arg_8_1[3]
	arg_8_1[4] = arg_8_5 or arg_8_1[4]
end

HeroViewStateKeepDecorations.transitioning = function (self)
	-- function 9
	if not self.exiting then
		return true
	else
		return false
	end
end

HeroViewStateKeepDecorations._wanted_state = function (self)
	-- function 10
	return (self.parent:wanted_state())
end

HeroViewStateKeepDecorations.wanted_menu_state = function (self)
	-- function 11
	return self._wanted_menu_state
end

HeroViewStateKeepDecorations.clear_wanted_menu_state = function (self)
	-- function 12
	self._wanted_menu_state = nil
end

HeroViewStateKeepDecorations._update_transition_timer = function (self, arg_13_1)
	-- function 13
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_13_1, 0)
	end
end

HeroViewStateKeepDecorations.input_service = function (self)
	-- function 14
	return self.parent:input_service()
end

HeroViewStateKeepDecorations._is_list_hovered = function (self)
	-- function 15
	local is_hover = self._widgets_by_name.list_mask.content.hotspot.is_hover

	is_hover = is_hover or false

	return is_hover
end

HeroViewStateKeepDecorations.update = function (self, arg_16_1, arg_16_2)
	-- function 16
	self:_handle_gamepad_activity()

	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	local FAKE_INPUT_SERVICE

	if not self._input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_16_0::

	if self._type == "painting" then
		self:_update_client_paintings(arg_16_1)
	end

	self:_update_sound_trigger_delay(arg_16_1)
	self:_update_scroll_position()
	self:draw(FAKE_INPUT_SERVICE, arg_16_1)
	self:_update_transition_timer(arg_16_1)

	local transitioning = self.parent:transitioning()
	local _wanted_state = self:_wanted_state()

	if not self._transition_timer then
		if not transitioning then
			if not self:_has_active_level_vote() then
				local flag_2 = true

				self:close_menu(flag_2)
			else
				self:_handle_input(arg_16_1, arg_16_2)
			end
		end

		if _wanted_state or not self._new_state then
			self.parent:clear_wanted_state()

			return _wanted_state or self._new_state
		end
	end
end

HeroViewStateKeepDecorations._update_client_paintings = function (self, arg_17_1)
	-- function 17
	if not (not Unit.alive(self._interactable_unit) and not self._keep_decoration_extension and self._keep_decoration_extension.get_selected_decoration) then
		return
	end

	if not self._is_server then
		if self._keep_decoration_extension:get_selected_decoration() == "hidden" then
			self:close_menu()
		end
	else
		local get_selected_decoration = self._keep_decoration_extension:get_selected_decoration()

		if get_selected_decoration ~= self._selected_decoration then
			self:_set_info_by_decoration_key(get_selected_decoration, false)
		end
	end
end

HeroViewStateKeepDecorations._has_active_level_vote = function (self)
	-- function 18
	local _voting_manager = self._voting_manager
	local vote_in_progress = _voting_manager:vote_in_progress()

	vote_in_progress = not vote_in_progress and _voting_manager:is_mission_vote()

	return not vote_in_progress and not _voting_manager:has_voted(Network.peer_id())
end

HeroViewStateKeepDecorations.post_update = function (self, arg_19_1, arg_19_2)
	-- function 19
	self.ui_animator:update(arg_19_1)
	self:_update_animations(arg_19_1)
end

HeroViewStateKeepDecorations._update_animations = function (self, arg_20_1)
	-- function 20
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_20_1)

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
	local close_button = _widgets_by_name.close_button
	local confirm_button = _widgets_by_name.confirm_button

	UIWidgetUtils.animate_default_button(close_button, arg_20_1)
	UIWidgetUtils.animate_default_button(confirm_button, arg_20_1)
end

HeroViewStateKeepDecorations._is_button_hover_enter = function (arg_21_0, arg_21_1)
	-- function 21
	local content = arg_21_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	return button_hotspot.on_hover_enter
end

HeroViewStateKeepDecorations._is_button_hover_exit = function (arg_22_0, arg_22_1)
	-- function 22
	local content = arg_22_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	return button_hotspot.on_hover_exit
end

HeroViewStateKeepDecorations._is_button_hover = function (arg_23_0, arg_23_1)
	-- function 23
	local content = arg_23_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	return button_hotspot.is_hover
end

HeroViewStateKeepDecorations._handle_input = function (self, arg_24_1, arg_24_2)
	-- function 24
	local FAKE_INPUT_SERVICE

	if not self._input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_24_0::

	local is_device_active = Managers.input:is_device_active("mouse")
	local get = FAKE_INPUT_SERVICE:get("toggle_menu")
	local flag = not not is_device_active or FAKE_INPUT_SERVICE:get("back")
	local _widgets_by_name = self._widgets_by_name

	self._scrollbar_logic:update(arg_24_1, arg_24_2)

	local close_button = _widgets_by_name.close_button
	local confirm_button = _widgets_by_name.confirm_button

	if self:_is_button_hover_enter(close_button) or not self:_is_button_hover_enter(confirm_button) then
		self:_play_sound("Play_hud_hover")
	end

	if not self._customizable_decoration then
		local _interactable_unit = self._interactable_unit

		if self:_is_button_pressed(confirm_button) or not FAKE_INPUT_SERVICE:get("confirm") then
			local extension = ScriptUnit.extension(_interactable_unit, "keep_decoration_system")

			if not self._selected_equipped_decoration then
				extension:unequip_decoration()

				self._selected_equipped_decoration = false

				self:_update_confirm_button()
				self:_update_equipped_widget()
				self._menu_input_description:set_input_description(input_actions.default)
				self:_play_sound("Play_hud_select")
			else
				self:_verify_decoration_selection()
				extension:confirm_selection()
				self:_play_sound("hud_add_painting")

				self._selected_equipped_decoration = true

				self:_update_confirm_button()
				self:_update_equipped_widget()
				self._menu_input_description:set_input_description(input_actions.remove)
			end
		end

		local flag_2 = false

		if not is_device_active then
			flag_2 = true

			self:_handle_gamepad_list_selection(FAKE_INPUT_SERVICE)
		else
			flag_2 = self:_is_list_hovered()

			local _list_widgets = self._list_widgets

			if not _list_widgets and not flag_2 then
				for i, v in ipairs(_list_widgets) do
					if not self:_is_button_hover_enter(v) then
						self:_play_sound("play_gui_equipment_button_hover")
					end
				end
			end

			local _list_index_pressed = self:_list_index_pressed()

			if not (not _list_index_pressed and _list_index_pressed == self._selected_list_index) then
				self:_on_list_index_selected(_list_index_pressed)
				self:_play_sound("Play_hud_select")
			end
		end

		self:_animate_list_entries(arg_24_1, flag_2)
	end

	if get or self:_is_button_pressed(close_button) or not flag then
		self:_play_sound("Play_hud_select")
		self:close_menu()

		return
	end
end

HeroViewStateKeepDecorations._verify_decoration_selection = function (self)
	-- function 25
	local extension = ScriptUnit.extension(self._interactable_unit, "keep_decoration_system")
	local get_selected_decoration = extension:get_selected_decoration()

	if not table.find(self._default_decorations, get_selected_decoration) then
		return
	end

	local _selected_list_index = self._selected_list_index
	local _list_widgets = self._list_widgets

	if not (not _selected_list_index and not (_selected_list_index > #_list_widgets)) then
		return
	end

	local content = _list_widgets[_selected_list_index].content
	local key = content.key

	if not content.locked then
		return
	else
		extension:decoration_selected(key)
	end
end

HeroViewStateKeepDecorations.close_menu = function (self, arg_26_1)
	-- function 26
	arg_26_1 = true

	self.parent:close_menu(nil, arg_26_1)
end

HeroViewStateKeepDecorations.draw = function (self, arg_27_1, arg_27_2)
	-- function 27
	self:_update_visible_list_entries()

	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_manager = self._input_manager
	local _render_settings = self._render_settings
	local is_device_active = _input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, arg_27_1, arg_27_2, nil, _render_settings)

	local snap_pixel_positions = _render_settings.snap_pixel_positions
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	local _list_widgets = self._list_widgets

	if not _list_widgets then
		for i, v in ipairs(_list_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v)
		end
	end

	local _dummy_list_widgets = self._dummy_list_widgets

	if not _dummy_list_widgets then
		for i_2, v_2 in ipairs(_dummy_list_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v_2)
		end
	end

	for i_3, v_3 in ipairs(self._widgets) do
		if v_3.snap_pixel_positions ~= nil then
			_render_settings.snap_pixel_positions = v_3.snap_pixel_positions
		end

		local alpha_multiplier_2 = v_3.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(_ui_renderer, v_3)

		_render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(_ui_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier

	if not is_device_active then
		self._menu_input_description:draw(_ui_top_renderer, arg_27_2)
	end
end

HeroViewStateKeepDecorations._is_button_pressed = function (arg_28_0, arg_28_1)
	-- function 28
	local content = arg_28_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroViewStateKeepDecorations._play_sound = function (self, arg_29_1)
	-- function 29
	self.parent:play_sound(arg_29_1)
end

HeroViewStateKeepDecorations._start_transition_animation = function (self, arg_30_1, arg_30_2)
	-- function 30
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_30_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_30_1] = start_animation
end

HeroViewStateKeepDecorations.set_fullscreen_effect_enable_state = function (self, arg_31_1)
	-- function 31
	local world = self._ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_31_3 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_31_1 and 1 and 0

		set_scalar(var_31_3, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_31_7 = get_data
		local str_2 = "fullscreen_blur_amount"
		local flag_2

		flag_2 = not arg_31_1 and 0.75 and 0

		set_scalar_2(var_31_7, str_2, flag_2)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_31_1
end

HeroViewStateKeepDecorations.block_input = function (self)
	-- function 32
	self._input_blocked = true
end

HeroViewStateKeepDecorations.unblock_input = function (self)
	-- function 33
	self._input_blocked = false
end

HeroViewStateKeepDecorations.input_blocked = function (self)
	-- function 34
	return self._input_blocked
end

HeroViewStateKeepDecorations._set_info_by_decoration_key = function (self, arg_35_1, arg_35_2)
	-- function 35
	local var_35_0 = self._main_table[arg_35_1]
	local display_name = var_35_0.display_name
	local description = var_35_0.description
	local artist = var_35_0.artist
	local var_35_4

	if not arg_35_2 then
		var_35_4 = Localize("interaction_unavailable")

		if not var_35_4 then
			-- Nothing
		end
	end

	var_35_4 = Localize(description)

	do
		local var_35_5
	end

	::label_35_0::

	if not (not artist and arg_35_2) then
		var_35_5 = Localize(artist)

		if not var_35_5 then
			-- Nothing
		end
	end

	var_35_5 = ""

	::label_35_1::

	self._selected_decoration = arg_35_1

	self:_set_info_texts(Localize(display_name), var_35_4, var_35_5)
	self:_play_sound("Stop_all_keep_decorations_desc_vo")

	if not arg_35_2 then
		local var_35_6

		if not var_35_0.sound_event then
			var_35_6 = num_3

			if not var_35_6 then
				-- Nothing
			end
		end

		var_35_6 = nil

		::label_35_2::

		self._sound_event_delay = var_35_6
	end
end

HeroViewStateKeepDecorations._update_sound_trigger_delay = function (self, arg_36_1)
	-- function 36
	local _sound_event_delay = self._sound_event_delay

	if not _sound_event_delay then
		return
	end

	local max = math.max(_sound_event_delay - arg_36_1, 0)

	if max == 0 then
		self._sound_event_delay = nil

		local _selected_list_index = self._selected_list_index

		if not self._selected_decoration and not _selected_list_index then
			local key = self._list_widgets[_selected_list_index].content.key
			local sound_event = self._main_table[key].sound_event

			if not sound_event then
				self:_play_sound(sound_event)
			end
		elseif not self._sound_event then
			self:_play_sound(self._sound_event)
		end
	else
		self._sound_event_delay = max
	end
end

HeroViewStateKeepDecorations._update_confirm_button = function (self)
	-- function 37
	local flag = self._selected_equipped_decoration == true
	local confirm_button = self._widgets_by_name.confirm_button

	if not flag then
		confirm_button.content.title_text = Localize("input_description_remove")
	else
		confirm_button.content.title_text = Localize("menu_settings_apply")
	end
end

HeroViewStateKeepDecorations._on_list_index_selected = function (self, arg_38_1, arg_38_2)
	-- function 38
	local _interactable_unit = self._interactable_unit
	local extension = ScriptUnit.extension(_interactable_unit, "keep_decoration_system")
	local get_selected_decoration = extension:get_selected_decoration()
	local _list_widgets = self._list_widgets

	if not (not arg_38_1 and not (arg_38_1 > #_list_widgets)) then
		return
	end

	local content = _list_widgets[arg_38_1].content
	local key = content.key

	if not ItemHelper.is_new_keep_decoration_id(key) then
		ItemHelper.unmark_keep_decoration_as_new(key)

		content.new = false
	end

	local locked = content.locked

	self:_set_info_by_decoration_key(key, locked)

	if not locked then
		extension:decoration_selected(self._empty_decoration_name)
	else
		extension:decoration_selected(key)
	end

	self._selected_equipped_decoration = get_selected_decoration == key

	self:_update_confirm_button()

	local flag

	flag = not self._selected_equipped_decoration and "remove" and "default"

	self._menu_input_description:set_input_description(not flag and input_actions[flag])

	if not _list_widgets then
		for i, v in ipairs(_list_widgets) do
			local content_2 = v.content
			local hotspot = content_2.hotspot

			hotspot = hotspot or content_2.button_hotspot

			if not hotspot then
				local flag_2 = i == arg_38_1

				hotspot.is_selected = flag_2

				if not flag_2 then
					hotspot.on_hover_enter = true
				end
			end
		end
	end

	self._previous_selected_list_index = self._selected_list_index
	self._selected_list_index = arg_38_1

	if not arg_38_2 then
		local scroll_bar_info = self._widgets_by_name.list_scrollbar.content.scroll_bar_info
		local function_by_time = UIAnimation.function_by_time
		local var_38_13 = scroll_bar_info
		local str = "scroll_value"
		local scroll_value = scroll_bar_info.scroll_value
		local var_38_16 = arg_38_2
		local num = 0.3
		local easeOutCubic = math.easeOutCubic

		self._ui_animations.scrollbar = UIAnimation.init(function_by_time, var_38_13, str, scroll_value, var_38_16, num, easeOutCubic)
	else
		self._ui_animations.scrollbar = nil
	end
end

HeroViewStateKeepDecorations._update_scrollbar_progress_animation = function (self, arg_39_1, arg_39_2)
	-- function 39
	local _chest_zoom_in_duration = self._chest_zoom_in_duration

	if not _chest_zoom_in_duration then
		return
	end

	local num = _chest_zoom_in_duration + arg_39_1
	local min = math.min(num / CHEST_PRESENTATION_ZOOM_IN_TIME, 1)
	local easeOutCubic = math.easeOutCubic(min)

	self:set_camera_zoom(easeOutCubic)
	self:set_grid_animation_progress(easeOutCubic)
	self:set_chest_title_alpha_progress(1 - easeOutCubic)

	if min == 1 then
		self._chest_zoom_in_duration = nil
		self._chest_open_wait_duration = 0
	else
		self._chest_zoom_in_duration = num
	end
end

HeroViewStateKeepDecorations._set_info_texts = function (self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local _set_selected_title = self:_set_selected_title(arg_40_1)
	local _set_selected_description = self:_set_selected_description(arg_40_2)
	local _set_selected_artist

	if not arg_40_3 then
		_set_selected_artist = self:_set_selected_artist(arg_40_3)

		if not _set_selected_artist then
			-- Nothing
		end
	end

	_set_selected_artist = 0

	::label_40_0::

	local _ui_scenegraph = self._ui_scenegraph

	_ui_scenegraph.title_text.size[2] = _set_selected_title
	_ui_scenegraph.artist_text.size[2] = _set_selected_artist

	local info_window = _ui_scenegraph.info_window
	local position = info_window.position
	local num = info_window.size[2] - _set_selected_title - _set_selected_artist - 110

	_ui_scenegraph.description_text.size[2] = num
end

HeroViewStateKeepDecorations._set_selected_title = function (self, arg_41_1)
	-- function 41
	local title_text = self._widgets_by_name.title_text

	title_text.content.text = arg_41_1

	local scenegraph_id = title_text.scenegraph_id
	local text = title_text.style.text
	local size = scenegraph_definition[scenegraph_id].size

	return (UIUtils.get_text_height(self._ui_renderer, size, text, arg_41_1))
end

HeroViewStateKeepDecorations._set_selected_description = function (self, arg_42_1)
	-- function 42
	local description_text = self._widgets_by_name.description_text

	description_text.content.text = arg_42_1

	local scenegraph_id = description_text.scenegraph_id
	local text = description_text.style.text
	local size = scenegraph_definition[scenegraph_id].size

	return (UIUtils.get_text_height(self._ui_renderer, size, text, arg_42_1))
end

HeroViewStateKeepDecorations._set_selected_artist = function (self, arg_43_1)
	-- function 43
	local artist_text = self._widgets_by_name.artist_text

	artist_text.content.text = arg_43_1

	local scenegraph_id = artist_text.scenegraph_id
	local text = artist_text.style.text
	local size = scenegraph_definition[scenegraph_id].size

	return (UIUtils.get_text_height(self._ui_renderer, size, text, arg_43_1))
end

HeroViewStateKeepDecorations._update_equipped_widget = function (self)
	-- function 44
	local _interactable_unit = self._interactable_unit
	local get_selected_decoration = ScriptUnit.extension(_interactable_unit, "keep_decoration_system"):get_selected_decoration()
	local _decoration_system = self._decoration_system

	for k, v in pairs(self._list_widgets) do
		local key = v.content.key

		v.content.in_use = _decoration_system:is_decoration_in_use(key)
		v.content.equipped = get_selected_decoration == key
	end
end

HeroViewStateKeepDecorations._align_list_widgets = function (self)
	-- function 45
	local num_2 = 0
	local _list_widgets = self._list_widgets
	local _dummy_list_widgets = self._dummy_list_widgets
	local num_3 = #_list_widgets + #_dummy_list_widgets

	for i = 1, num_3 do
		local var_45_4

		if i <= #_list_widgets then
			var_45_4 = _list_widgets[i]
		else
			var_45_4 = _dummy_list_widgets[i - #_list_widgets]
		end

		local offset = var_45_4.offset
		local size = var_45_4.content.size

		var_45_4.default_offset = table.clone(offset)

		local var_45_7 = size[2]

		offset[2] = -num_2
		num_2 = num_2 + var_45_7

		if i ~= num_3 then
			num_2 = num_2 + num
		end
	end

	self._total_list_height = num_2
end

HeroViewStateKeepDecorations._handle_gamepad_list_selection = function (self, arg_46_1)
	-- function 46
	local _selected_list_index = self._selected_list_index

	if not _selected_list_index then
		return
	end

	local count = #self._list_widgets
	local var_46_2
	local var_46_3

	if not arg_46_1:get("move_up_hold_continuous") then
		var_46_2 = math.max(_selected_list_index - 1, 1)
		var_46_3 = math.max(var_46_2 - 3, 1)
	elseif not arg_46_1:get("move_down_hold_continuous") then
		var_46_2 = math.min(_selected_list_index + 1, count)
		var_46_3 = math.min(var_46_2 + 3, count)
	end

	if not (not var_46_2 and var_46_2 == _selected_list_index) then
		local _get_scrollbar_percentage_by_index = self:_get_scrollbar_percentage_by_index(var_46_3)

		self:_on_list_index_selected(var_46_2, _get_scrollbar_percentage_by_index)
		self:_play_sound("Play_hud_hover")
	end
end

HeroViewStateKeepDecorations._find_closest_neighbour = function (self, arg_47_1, arg_47_2)
	-- function 47
	local _list_widgets = self._list_widgets
	local var_47_1 = _list_widgets[arg_47_2]
	local size = var_47_1.content.size
	local offset = var_47_1.offset
	local num = size[1] * 0.5 + offset[1]
	local huge = math.huge
	local var_47_6

	for k, v in pairs(arg_47_1) do
		local var_47_7 = _list_widgets[v]
		local offset_2 = var_47_7.offset
		local num_2 = var_47_7.content.size[1] * 0.5 + offset_2[1]
		local abs = math.abs(num_2 - num)

		if abs < huge then
			huge = abs
			var_47_6 = v
		end
	end

	if not var_47_6 then
		return var_47_6
	end
end

HeroViewStateKeepDecorations._initialize_scrollbar = function (self)
	-- function 48
	local size = scenegraph_definition.list_window.size
	local size_2 = scenegraph_definition.list_scrollbar.size
	local var_48_2 = size[2]
	local _total_list_height = self._total_list_height
	local var_48_4 = size_2[2]
	local num_2 = 220 + num * 1.5
	local num_3 = 1
	local _scrollbar_logic = self._scrollbar_logic

	_scrollbar_logic:set_scrollbar_values(var_48_2, _total_list_height, var_48_4, num_2, num_3)
	_scrollbar_logic:set_scroll_percentage(0)
end

HeroViewStateKeepDecorations._update_scroll_position = function (self)
	-- function 49
	local get_scrolled_length = self._scrollbar_logic:get_scrolled_length()

	if get_scrolled_length ~= self._scrolled_length then
		self._ui_scenegraph.list_scroll_root.local_position[2] = math.round(get_scrolled_length)
		self._scrolled_length = get_scrolled_length
	end
end

HeroViewStateKeepDecorations._update_visible_list_entries = function (self)
	-- function 50
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		return
	end

	local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
	local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
	local get_scroll_length = _scrollbar_logic:get_scroll_length()
	local size = scenegraph_definition.list_window.size
	local num_2 = num * 2
	local num_3 = size[2] + num_2
	local _list_widgets = self._list_widgets
	local count = #_list_widgets

	for i, v in ipairs(_list_widgets) do
		local offset = v.offset
		local content = v.content
		local size_2 = content.size
		local num_4 = math.abs(offset[2]) + size_2[2]
		local flag = false

		if num_4 < get_scrolled_length - num_2 then
			flag = true
		elseif num_3 < math.abs(offset[2]) - get_scrolled_length then
			flag = true
		end

		content.visible = not flag
	end
end

HeroViewStateKeepDecorations._get_scrollbar_percentage_by_index = function (self, arg_51_1)
	-- function 51
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
		local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
		local get_scroll_length = _scrollbar_logic:get_scroll_length()
		local var_51_4 = scenegraph_definition.list_window.size[2]
		local var_51_5 = get_scrolled_length
		local num = var_51_5 + var_51_4
		local _list_widgets = self._list_widgets

		if not _list_widgets then
			local var_51_8 = _list_widgets[arg_51_1]
			local content = var_51_8.content
			local offset = var_51_8.offset
			local var_51_11 = content.size[2]
			local abs = math.abs(offset[2])
			local num_2 = abs + var_51_11
			local num_3 = 0

			if num < num_2 then
				local num_4 = num_2 - num

				num_3 = math.clamp(num_4 / get_scroll_length, 0, 1)
			elseif abs < var_51_5 then
				local num_5 = var_51_5 - abs

				num_3 = -math.clamp(num_5 / get_scroll_length, 0, 1)
			end

			if not num_3 then
				return (math.clamp(get_scroll_percentage + num_3, 0, 1))
			end
		end
	end

	return 0
end

HeroViewStateKeepDecorations._list_index_pressed = function (self)
	-- function 52
	local _list_widgets = self._list_widgets

	if not _list_widgets then
		for i, v in ipairs(_list_widgets) do
			local content = v.content
			local hotspot = content.hotspot

			hotspot = hotspot or content.button_hotspot

			if not hotspot and not hotspot.on_release then
				hotspot.on_release = false

				return i
			end
		end
	end
end

HeroViewStateKeepDecorations._setup_decorations_list = function (self)
	-- function 53
	local _keep_decoration_backend_interface = self._keep_decoration_backend_interface
	local get_unlocked_keep_decorations

	if not _keep_decoration_backend_interface then
		get_unlocked_keep_decorations = _keep_decoration_backend_interface:get_unlocked_keep_decorations()

		if not get_unlocked_keep_decorations then
			-- Nothing
		end
	end

	get_unlocked_keep_decorations = {}

	::label_53_0::

	local tbl = {}
	local num_2 = 0

	for i, v in ipairs(self._ordered_table) do
		if not table.contains(self._default_table, v) then
			local var_53_4 = self._main_table[v]

			if not var_53_4 then
				local contains = table.contains(get_unlocked_keep_decorations, v)
				local var_53_6 = Localize(var_53_4.display_name)
				local is_new_keep_decoration_id = ItemHelper.is_new_keep_decoration_id(v)

				if not contains then
					local var_53_8 = UIWidget.init(entry_widget_definition)

					num_2 = num_2 + 1
					tbl[num_2] = var_53_8

					local content = var_53_8.content
					local style = var_53_8.style
					local var_53_11 = var_53_6
					local title = style.title
					local num_3 = title.size[1] - 10

					content.title = UIRenderer.crop_text_width(self._ui_renderer, var_53_11, num_3, title)
					content.key = v
					content.locked = false
					content.new = is_new_keep_decoration_id
					content.in_use = self._decoration_system:is_decoration_in_use(v)
				end
			end
		end
	end

	table.sort(tbl, function (self, arg_54_1)
		-- function 54
		local content = self.content
		local content_2 = arg_54_1.content

		if content.new ~= content_2.new then
			return content.new
		end

		return Localize(content.title) < Localize(content_2.title)
	end)

	self._list_widgets = tbl
	self._dummy_list_widgets = {}

	self:_align_list_widgets()

	local _total_list_height = self._total_list_height
	local var_53_15 = scenegraph_definition.list_scrollbar.size[2]
	local tbl_2 = {}

	if _total_list_height < var_53_15 then
		local num_4 = 0
		local var_53_18 = num

		while var_53_15 > _total_list_height + var_53_18 do
			num_4 = num_4 + 1

			local var_53_19 = UIWidget.init(dummy_entry_widget_definition)

			table.insert(tbl_2, var_53_19)

			var_53_18 = var_53_18 + var_53_19.content.size[2] + num
		end
	end

	self._dummy_list_widgets = tbl_2

	self:_align_list_widgets()
	self:_initialize_scrollbar()
	self:_update_equipped_widget()
end

HeroViewStateKeepDecorations._animate_list_entries = function (self, arg_55_1, arg_55_2)
	-- function 55
	local _list_widgets = self._list_widgets

	if not _list_widgets then
		return
	end

	for i, v in ipairs(_list_widgets) do
		self:_animate_list_widget(v, arg_55_1, arg_55_2)
	end
end

HeroViewStateKeepDecorations._animate_list_widget = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	local offset = arg_56_1.offset
	local content = arg_56_1.content
	local style = arg_56_1.style
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	local on_hover_enter = button_hotspot.on_hover_enter
	local is_hover = button_hotspot.is_hover

	if not (arg_56_3 == nil or arg_56_3) then
		is_hover = false
		on_hover_enter = false
	end

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

	goto label_56_1

	::label_56_0::

	is_clicked = true

	::label_56_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local pulse_progress = button_hotspot.pulse_progress

	pulse_progress = pulse_progress or 1

	local offset_progress = button_hotspot.offset_progress

	offset_progress = offset_progress or 1

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local flag

	flag = is_hover or not is_selected or 14 or 3

	local num = 3
	local num_2 = 20
	local num_3 = 5

	if not is_clicked then
		input_progress = math.min(input_progress + arg_56_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_56_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not on_hover_enter then
		pulse_progress = 0
	end

	local min = math.min(pulse_progress + arg_56_2 * num, 1)
	local easeOutCubic_2 = math.easeOutCubic(min)
	local easeInCubic_2 = math.easeInCubic(min)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_56_2 * flag, 1)
	else
		hover_progress = math.max(hover_progress - arg_56_2 * flag, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(hover_progress)
	local easeInCubic_3 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_56_2 * flag, 1)
		offset_progress = math.min(offset_progress + arg_56_2 * num_3, 1)
	else
		selection_progress = math.max(selection_progress - arg_56_2 * flag, 0)
		offset_progress = math.max(offset_progress - arg_56_2 * num_3, 0)
	end

	local easeOutCubic_4 = math.easeOutCubic(selection_progress)
	local easeInCubic_4 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_4, easeOutCubic_3)
	local max_3 = math.max(easeInCubic_3, easeInCubic_4)
	local num_4 = 255 * max

	style.hover_frame.color[1] = num_4

	local title = style.title
	local text_color = title.text_color
	local default_text_color = title.default_text_color
	local hover_text_color = title.hover_text_color

	Colors.lerp_color_tables(default_text_color, hover_text_color, max, text_color)

	local num_5 = 255 - 255 * min

	style.pulse_frame.color[1] = num_5
	offset[1] = 10 * math.ease_in_exp(offset_progress)
	button_hotspot.offset_progress = offset_progress
	button_hotspot.pulse_progress = min
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

HeroViewStateKeepDecorations._handle_gamepad_activity = function (self)
	-- function 57
	local is_device_active = Managers.input:is_device_active("mouse")
	local flag = self._gamepad_active_last_frame == nil

	if not is_device_active then
		if not self._gamepad_active_last_frame and not flag then
			self._gamepad_active_last_frame = true

			if not self._customizable_decoration then
				local _selected_list_index = self._selected_list_index

				if not _selected_list_index then
					local _get_scrollbar_percentage_by_index = self:_get_scrollbar_percentage_by_index(_selected_list_index)

					self._scrollbar_logic:set_scroll_percentage(_get_scrollbar_percentage_by_index)
				end
			end
		end
	elseif self._gamepad_active_last_frame or not flag then
		self._gamepad_active_last_frame = false
	end
end
