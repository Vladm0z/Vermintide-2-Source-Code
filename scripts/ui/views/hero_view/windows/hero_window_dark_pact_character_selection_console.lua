-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_dark_pact_character_selection_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_dark_pact_character_selection_console_definitions")
local widget_definitions = var_0_0.widget_definitions
local generic_input_actions = var_0_0.generic_input_actions
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local num = 5
local num_2 = 5

HeroWindowDarkPactCharacterSelectionConsole = class(HeroWindowDarkPactCharacterSelectionConsole)
HeroWindowDarkPactCharacterSelectionConsole.NAME = "HeroWindowDarkPactCharacterSelectionConsole"

HeroWindowDarkPactCharacterSelectionConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowDarkPactCharacterSelectionConsole")

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._profile_synchronizer = ingame_ui_context.profile_synchronizer
	self._ingame_ui = ingame_ui_context.ingame_ui
	self._parent = arg_1_1.parent
	self._wwise_world = arg_1_1.wwise_world
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._hero_name = arg_1_1.hero_name

	local career_index = arg_1_1.career_index

	career_index = career_index or 0
	self._career_index = career_index

	local profile_index = arg_1_1.profile_index

	profile_index = profile_index or 0
	self._profile_index = profile_index
	self._profile_selectable = false
	self._animations = {}
	self._ui_animations = {}

	local local_player = Managers.player:local_player()

	self._peer_id = local_player:network_id()
	self._local_player_id = local_player:local_player_id()
	self._player_stats_id = local_player:stats_id()
	self._statistics_db = ingame_ui_context.statistics_db

	local num = UILayer.default + 300
	local window_input_service = self._parent:window_input_service()

	self._menu_input_description = MenuInputDescriptionUI:new(ingame_ui_context, self._ui_top_renderer, window_input_service, 4, num + 100, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)

	self._dark_pact_profiles = self:_get_dark_pact_selectable_profiles()

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_start_transition_animation("on_enter", "on_enter")
	self:_first_pactsworn_setup(self._profile_index, self._career_index)

	local carousel = DLCSettings.carousel

	carousel = not carousel and DLCSettings.carousel.hero_window_mood_settings

	local pactsworn = carousel.pactsworn

	pactsworn = pactsworn or "default"

	self._parent:set_background_mood(pactsworn)
end

HeroWindowDarkPactCharacterSelectionConsole._first_pactsworn_setup = function (self, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = SPProfiles[arg_2_1]
	local num = 1
	local num_2 = 1

	if var_2_0.affiliation ~= "dark_pact" then
		local random = Math.random(1, self._num_max_rows)
		local var_2_4 = self._num_hero_columns[random]

		var_2_4 = var_2_4 or 1

		local random_2 = Math.random(1, var_2_4)

		self._selected_row = random
		self._selected_column = random_2
		arg_2_1, arg_2_2 = self:_get_selected_dark_pact_profile_and_career_indx(random, random_2)
	end

	self._selected_dark_pact_profile_index = arg_2_1
	self._selected_dark_pact_career_index = arg_2_2

	self:_set_selected_portrait(arg_2_1, arg_2_2)

	if not (not (self._selected_dark_pact_profile_index > 0) or not (self._selected_dark_pact_career_index > 0)) then
		self:_select_hero(self._selected_dark_pact_profile_index, self._selected_dark_pact_career_index)
	end
end

HeroWindowDarkPactCharacterSelectionConsole._set_selected_portrait = function (self, arg_3_1, arg_3_2)
	-- function 3
	for i = 1, self._num_max_rows do
		for j = 1, self._num_hero_columns[i] do
			local content = self._selection_widget_lookup[i][j].content
			local flag = arg_3_1 ~= content.profile_index or arg_3_2 == content.career_index

			content.selected = flag

			if not flag then
				self._selected_row = i
				self._selected_column = j
			end
		end
	end
end

HeroWindowDarkPactCharacterSelectionConsole._get_selected_dark_pact_profile_and_career_indx = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._selection_widget_lookup then
		return self._dark_pact_profiles[1], 1
	end

	if arg_4_2 > self._num_hero_columns[arg_4_1] then
		arg_4_2 = self._num_hero_columns[arg_4_1]
	end

	local content = self._selection_widget_lookup[arg_4_1][arg_4_2].content
	local profile_index = content.profile_index
	local career_index = content.career_index

	return profile_index, career_index
end

HeroWindowDarkPactCharacterSelectionConsole._select_hero = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if not arg_5_3 then
		self:_play_sound("play_gui_hero_select_career_click")
	end

	local var_5_0 = SPProfiles[arg_5_1]
	local var_5_1 = var_5_0.careers[arg_5_2]
	local display_name = var_5_0.display_name
	local character_name = var_5_0.character_name
	local display_name_2 = var_5_1.display_name

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", display_name_2 == "bw_necromancer")

	local var_5_5 = Localize(character_name)
	local var_5_6 = Localize(display_name_2)

	self._selected_dark_pact_career_index = arg_5_2
	self._selected_dark_pact_profile_index = arg_5_1
	self._selected_hero_name = display_name

	Managers.state.event:trigger("respawn_hero", {
		hero_name = display_name,
		career_index = arg_5_2
	})
	self:_setup_dark_pact_loadut_data(arg_5_1, arg_5_2)
	self._parent:change_profile(arg_5_1, arg_5_2)
end

local num_3 = 2

HeroWindowDarkPactCharacterSelectionConsole._setup_dark_pact_loadut_data = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = SPProfiles[arg_6_1].careers[arg_6_2]
	local pactsworn_name = self._widgets_by_name.pactsworn_name
	local display_name = var_6_0.display_name
	local name = var_6_0.name

	pactsworn_name.content.text = Localize(display_name)

	local str = "slot_skin"
	local get_loadout_item = BackendUtils.get_loadout_item(name, str)
	local carousel = DLCSettings.carousel
	local var_6_7 = carousel.hero_window_pactsworn_stats_by_name[name]

	var_6_7 = var_6_7 or carousel.hero_window_pactsworn_stats_by_name.default

	for i = 1, num_3 do
		local content = self._widgets_by_name["pactsworn_stat_" .. i].content
		local var_6_9 = var_6_7[i]
		local round = math.round(self._statistics_db:get_persistent_stat(self._player_stats_id, unpack(var_6_9)))
		local var_6_11 = Localize(carousel.stats_string_lookup[var_6_9[1]])

		content.text = "{#color(160,146,101,255)}" .. var_6_11 .. "{#reset()} : " .. round
		self._widgets_by_name["pactsworn_stat_shadow_" .. i].content.text = var_6_11 .. " : " .. round
		self._widgets_by_name["pactsworn_stat_" .. i .. "_icon"].content.texture_id = carousel.stats_icons_lookup[var_6_9[1]]
	end

	self._widgets_by_name.pactsworn_description.content.text = Localize(var_6_0.description)

	local content_2 = self._widgets_by_name.equipment_skin.content

	if not get_loadout_item then
		content_2[str].item = get_loadout_item
		content_2[str].icon = get_loadout_item.data.inventory_icon
		content_2[str].profile_index = self._selected_dark_pact_profile_index
		content_2[str].career_index = self._selected_dark_pact_career_index
		content_2[str].rarity = UISettings.item_rarity_textures[get_loadout_item.rarity]
	end

	content_2.is_dark_pact = true
end

HeroWindowDarkPactCharacterSelectionConsole._update_selectable = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

HeroWindowDarkPactCharacterSelectionConsole._start_transition_animation = function (self, arg_8_1, arg_8_2)
	-- function 8
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_8_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_8_1] = start_animation
end

HeroWindowDarkPactCharacterSelectionConsole._create_ui_elements = function (self, arg_9_1, arg_9_2)
	-- function 9
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widget_definitions) do
		local var_9_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_9_2
		tbl_2[k] = var_9_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	self:_setup_dark_pact_selection_widgets()
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_9_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_9_2[1]
		local_position[2] = local_position[2] + arg_9_2[2]
		local_position[3] = local_position[3] + arg_9_2[3]
	end
end

HeroWindowDarkPactCharacterSelectionConsole._setup_dark_pact_selection_widgets = function (self)
	-- function 10
	local tbl = {}

	self._pactsworn_widgets = tbl

	local tbl_2 = {}

	self._selection_widget_lookup = tbl_2
	self._num_hero_columns = {}

	local num = 5
	local num_2 = 1
	local num_3 = 1

	for i, v in ipairs(self._dark_pact_profiles) do
		local var_10_5 = SPProfiles[v]
		local display_name = var_10_5.display_name
		local var_10_7 = var_10_5.careers[1]
		local create_dark_pact_selection_widget = UIWidgets.create_dark_pact_selection_widget("selection_anchor")
		local var_10_9 = UIWidget.init(create_dark_pact_selection_widget)

		tbl[#tbl + 1] = var_10_9
		self._widgets_by_name["selection_widget_" .. i] = var_10_9

		local content = var_10_9.content

		content.portrait = var_10_7.picking_image_square
		content.career_settings = var_10_7
		content.profile_index = v
		content.career_index = 1

		if var_10_5.enemy_role == "boss" then
			content.portrait_frame = "pactsworn_frame_gold"
		end

		if not tbl_2[num_3] then
			tbl_2[num_3] = {}
		end

		tbl_2[num_3][num_2] = var_10_9

		local flag = num_3 % 2 == 0
		local num_4 = 140 * num_2 - 1 + 10 * num_2 - 1
		local num_5 = 140 * num_3 - 1 + 10 * num_3 - 1
		local offset = var_10_9.offset
		local num_6

		if not flag then
			num_6 = num_4 + 70

			if not num_6 then
				-- Nothing
			end
		end

		num_6 = num_4

		::label_10_0::

		offset[1] = num_6

		local offset_2 = var_10_9.offset
		local num_7

		if not flag then
			num_7 = -num_5 + 35

			if not num_7 then
				-- Nothing
			end
		end

		num_7 = -num_5

		::label_10_1::

		offset_2[2] = num_7
		var_10_9.offset[3] = -i * 10
		self._num_hero_columns[num_3] = num_2

		if num_2 == 5 then
			num_3 = num_3 + 1
			num_2 = 0
		end

		num_2 = num_2 + 1
	end

	self._num_max_columns = num
	self._num_max_rows = num_3
end

HeroWindowDarkPactCharacterSelectionConsole._get_dark_pact_selectable_profiles = function (arg_11_0)
	-- function 11
	local tbl = {}

	for i, v in ipairs(SPProfiles) do
		if not (v.affiliation ~= "dark_pact" or v.role == nil) then
			tbl[#tbl + 1] = i
		end
	end

	return tbl
end

HeroWindowDarkPactCharacterSelectionConsole.on_exit = function (self, arg_12_1)
	-- function 12
	print("[HeroViewWindow] Exit Substate HeroWindowDarkPactCharacterSelectionConsole")

	self._ui_animator = nil

	local currently_selected_profile, var_12_1, var_12_2 = self._parent:currently_selected_profile()

	if not (self._selected_profile_index ~= currently_selected_profile or self._selected_career_index == var_12_1) then
		Managers.state.event:trigger("respawn_hero", {
			hero_name = var_12_2,
			career_index = var_12_1
		})

		local name = SPProfiles[currently_selected_profile].careers[var_12_1].name

		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", name == "bw_necromancer")
	end
end

HeroWindowDarkPactCharacterSelectionConsole.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not DO_RELOAD then
		DO_RELOAD = false

		self:_create_ui_elements()
	end

	self:_update_animations(arg_13_1)
	self:_update_portraits(arg_13_1)
	self:_update_input(arg_13_1)
	self:_draw(arg_13_1)
end

HeroWindowDarkPactCharacterSelectionConsole.post_update = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	return
end

HeroWindowDarkPactCharacterSelectionConsole._update_animations = function (self, arg_15_1)
	-- function 15
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_15_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_15_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

HeroWindowDarkPactCharacterSelectionConsole._update_input = function (self, arg_16_1)
	-- function 16
	local window_input_service = self._parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not is_device_active then
		self:_handle_gamepad_selection(window_input_service)
	else
		self:_handle_mouse_selection()
	end

	local slot_skin = self._widgets_by_name.equipment_skin.content.slot_skin
	local _higlight_inventory_selection = self._higlight_inventory_selection

	_higlight_inventory_selection = not _higlight_inventory_selection and is_device_active
	slot_skin.highlight = _higlight_inventory_selection
end

HeroWindowDarkPactCharacterSelectionConsole._handle_mouse_selection = function (self)
	-- function 17
	local _hero_widgets = self._hero_widgets
	local _num_max_rows = self._num_max_rows
	local _num_max_columns = self._num_max_columns
	local _selected_dark_pact_profile_index = self._selected_dark_pact_profile_index
	local _selected_dark_pact_career_index = self._selected_dark_pact_career_index
	local num = 1

	for i = 1, _num_max_rows do
		for j = 1, _num_max_columns do
			local var_17_6 = self._selection_widget_lookup[i][j]

			if not var_17_6 then
				break
			end

			local content = var_17_6.content
			local hotspot = content.hotspot
			local profile_index = content.profile_index
			local career_index = content.career_index

			if not (not hotspot.on_pressed and profile_index ~= _selected_dark_pact_profile_index or career_index == _selected_dark_pact_career_index) then
				self:_select_hero(profile_index, career_index)
				self:_set_selected_portrait(profile_index, career_index)
			end
		end
	end

	local equipment_skin = self._widgets_by_name.equipment_skin

	if not UIUtils.is_button_pressed(equipment_skin, "slot_skin") then
		self:_play_sound("play_gui_equipment_selection_click")
		self._parent:set_selected_cosmetic_slot_index(2)
		self._parent:set_layout_by_name("cosmetics_selection_dark_pact")
	end
end

HeroWindowDarkPactCharacterSelectionConsole._handle_gamepad_selection = function (self, arg_18_1)
	-- function 18
	local _selected_row = self._selected_row
	local _selected_column = self._selected_column
	local _num_max_rows = self._num_max_rows
	local var_18_3 = self._num_hero_columns[_selected_row]

	if not (not _selected_row and not _selected_column and self._higlight_inventory_selection) then
		local flag = false

		if not (_selected_column > 1) or not arg_18_1:get("move_left_hold_continuous") then
			_selected_column = _selected_column - 1
			flag = true
		elseif not (_selected_column < var_18_3) or not arg_18_1:get("move_right_hold_continuous") then
			_selected_column = _selected_column + 1
			flag = true
		end

		if not (_selected_row > 1) or not arg_18_1:get("move_up_hold_continuous") then
			_selected_row = _selected_row - 1
			var_18_3 = self._num_hero_columns[_selected_row]
			flag = true
		elseif not (_selected_row < _num_max_rows) or not arg_18_1:get("move_down_hold_continuous") then
			_selected_row = _selected_row + 1
			var_18_3 = self._num_hero_columns[_selected_row]
			flag = true
		end

		if var_18_3 < _selected_column then
			_selected_column = var_18_3
			flag = true
		end

		if not flag then
			local _get_selected_dark_pact_profile_and_career_indx, var_18_6 = self:_get_selected_dark_pact_profile_and_career_indx(_selected_row, _selected_column)

			self:_set_selected_portrait(_get_selected_dark_pact_profile_and_career_indx, var_18_6)
		end
	end

	if not self._higlight_inventory_selection and not arg_18_1:get("confirm") then
		self._higlight_inventory_selection = nil

		self._parent:pause_input(false)
		self:_play_sound("play_gui_equipment_selection_click")
		self._parent:set_selected_cosmetic_slot_index(2)
		self._parent:set_layout_by_name("cosmetics_selection_dark_pact")

		return
	elseif not self._higlight_inventory_selection and not arg_18_1:get("back") then
		self._higlight_inventory_selection = nil

		self._menu_input_description:change_generic_actions(generic_input_actions.default)
		self._parent:pause_input(false)
	end

	local _get_selected_dark_pact_profile_and_career_indx_2, var_18_8 = self:_get_selected_dark_pact_profile_and_career_indx(self._selected_row, self._selected_column)

	if not _get_selected_dark_pact_profile_and_career_indx_2 and not var_18_8 and self._higlight_inventory_selection or not arg_18_1:get("confirm") then
		self._higlight_inventory_selection = true

		self:_select_hero(_get_selected_dark_pact_profile_and_career_indx_2, var_18_8)
		self._parent:pause_input(true)
		self._menu_input_description:change_generic_actions(generic_input_actions.select_inventory)
	end
end

HeroWindowDarkPactCharacterSelectionConsole.set_focus = function (self, arg_19_1)
	-- function 19
	self._focused = arg_19_1
end

HeroWindowDarkPactCharacterSelectionConsole._exit = function (self, arg_20_1)
	-- function 20
	self.exit = true
	self.exit_level_id = arg_20_1
end

HeroWindowDarkPactCharacterSelectionConsole._draw = function (self, arg_21_1)
	-- function 21
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_21_1, nil, self._render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	if not self._pactsworn_widgets then
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._pactsworn_widgets)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not is_device_active then
		self._menu_input_description:draw(_ui_top_renderer, arg_21_1)
	end
end

HeroWindowDarkPactCharacterSelectionConsole._play_sound = function (self, arg_22_1)
	-- function 22
	self._parent:play_sound(arg_22_1)
end

HeroWindowDarkPactCharacterSelectionConsole._update_portraits = function (self, arg_23_1)
	-- function 23
	local _pactsworn_widgets = self._pactsworn_widgets
	local _selected_dark_pact_profile_index = self._selected_dark_pact_profile_index
	local _selected_dark_pact_career_index = self._selected_dark_pact_career_index
	local is_device_active = Managers.input:is_device_active("gamepad")

	for i = 1, #_pactsworn_widgets do
		local var_23_4 = _pactsworn_widgets[i]
		local content = var_23_4.content
		local hotspot = content.hotspot
		local hover_progress = hotspot.hover_progress

		hover_progress = hover_progress or 0

		local selection_progress = hotspot.selection_progress

		selection_progress = selection_progress or 0

		local var_23_9
		local var_23_10

		if not is_device_active then
			var_23_9 = content.profile_index ~= _selected_dark_pact_profile_index or content.career_index ~= _selected_dark_pact_career_index or self._higlight_inventory_selection
			var_23_10 = content.selected
		else
			var_23_9 = content.profile_index ~= _selected_dark_pact_profile_index or content.career_index == _selected_dark_pact_career_index
			var_23_10 = hotspot.is_hover or content.selected
		end

		if not var_23_10 then
			hover_progress = math.min(hover_progress + arg_23_1 * num_2, 1)
		else
			hover_progress = math.max(hover_progress - arg_23_1 * num_2, 0)
		end

		if not var_23_9 then
			selection_progress = math.min(selection_progress + arg_23_1 * num_2, 1)
		else
			selection_progress = math.max(selection_progress - arg_23_1 * num_2, 0)
		end

		local style = var_23_4.style
		local portrait_frame = style.portrait_frame
		local portrait = style.portrait
		local portrait_frame_selected = style.portrait_frame_selected
		local texture_size = portrait_frame.texture_size
		local default_size = portrait_frame.default_size
		local offset = portrait_frame.offset
		local default_offset = portrait_frame.default_offset
		local texture_size_2 = portrait.texture_size
		local default_size_2 = portrait.default_size
		local offset_2 = portrait.offset
		local default_offset_2 = portrait.default_offset
		local texture_size_3 = portrait_frame_selected.texture_size
		local default_size_3 = portrait_frame_selected.default_size
		local offset_3 = portrait_frame_selected.offset
		local default_offset_3 = portrait_frame_selected.default_offset
		local num = 0.125
		local num_3 = 0.2
		local easeOutCubic = math.easeOutCubic(selection_progress)

		texture_size[1] = default_size[1] + default_size[1] * num * easeOutCubic
		texture_size[2] = default_size[2] + default_size[2] * num * easeOutCubic
		offset[1] = default_offset[1] - default_size[1] * num * easeOutCubic * 0.5
		texture_size_2[1] = default_size_2[1] + default_size_2[1] * num_3 * easeOutCubic
		texture_size_2[2] = default_size_2[2] + default_size_2[2] * num_3 * easeOutCubic
		offset_2[1] = default_offset_2[1] - default_size_2[1] * num_3 * easeOutCubic * 0.5
		texture_size_3[1] = default_size_3[1] + default_size_3[1] * num * easeOutCubic
		texture_size_3[2] = default_size_3[2] + default_size_3[2] * num * easeOutCubic
		offset_3[1] = default_offset_3[1] - default_size_3[1] * num * easeOutCubic * 0.5
		portrait_frame_selected.color[1] = 255 * hover_progress
		hotspot.hover_progress = hover_progress
		hotspot.selection_progress = selection_progress
	end
end
