-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_area_selection.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_definitions")
local widgets = var_0_0.widgets
local area_widgets = var_0_0.area_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local str = "StartGameWindowAreaSelection"

StartGameWindowAreaSelection = class(StartGameWindowAreaSelection)
StartGameWindowAreaSelection.NAME = "StartGameWindowAreaSelection"

StartGameWindowAreaSelection.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowAreaSelection")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.world_manager = ingame_ui_context.world_manager
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

	arg_1_1.return_layout_name = self.parent:get_selected_game_mode_layout_name()
	self._widgets_by_name.select_button.content.button_hotspot.disable_button = true

	self:_setup_area_widgets()
	self:_update_area_option()
	self.parent:set_input_description("select_mission")
end

StartGameWindowAreaSelection.create_ui_elements = function (self, arg_2_1, arg_2_2)
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

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(area_widgets) do
		local var_2_6 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_2_6
		tbl_4[k_2] = var_2_6
	end

	self._area_widgets = tbl_3
	self._area_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

StartGameWindowAreaSelection._setup_area_widgets = function (self)
	-- function 3
	local tbl = {}

	for k, v in pairs(AreaSettings) do
		if not v.exclude_from_area_selection then
			tbl[#tbl + 1] = v
		end
	end

	local function fn(self, arg_4_1)
		-- function 4
		return self.sort_order < arg_4_1.sort_order
	end

	table.sort(tbl, fn)

	local count = #tbl
	local var_3_3 = scenegraph_definition.area_root.size[1]
	local num = 25
	local num_2 = -((var_3_3 * count + num * (count - 1)) / 2) + var_3_3 / 2
	local tbl_2 = {}
	local statistics_db = self.statistics_db
	local _stats_id = self._stats_id

	for k_2 = 1, count do
		local var_3_9 = tbl[k_2]
		local var_3_10 = self._area_widgets[k_2]

		tbl_2[k_2] = var_3_10

		local content

		content.icon, content = var_3_9.level_image, var_3_10.content

		local flag = true
		local dlc_name = var_3_9.dlc_name

		if not dlc_name then
			flag = Managers.unlock:is_dlc_unlocked(dlc_name)
		end

		content.area_name, content.locked = var_3_9.name, not flag

		local huge = math.huge
		local acts = var_3_9.acts
		local count_2 = #acts

		for l = 1, count_2 do
			local var_3_17 = acts[l]
			local highest_completed_difficulty_index_by_act = LevelUnlockUtils.highest_completed_difficulty_index_by_act(statistics_db, _stats_id, var_3_17)

			if highest_completed_difficulty_index_by_act < huge then
				huge = highest_completed_difficulty_index_by_act
			end
		end

		content.frame = UIWidgetUtils.get_level_frame_by_difficulty_index(huge)
		var_3_10.offset[1] = num_2
		num_2 = num_2 + var_3_3 + num
	end

	self._active_area_widgets = tbl_2
end

StartGameWindowAreaSelection._select_area_by_name = function (self, arg_5_1)
	-- function 5
	local _active_area_widgets = self._active_area_widgets

	if not _active_area_widgets then
		for i = 1, #_active_area_widgets do
			local var_5_1 = _active_area_widgets[i]
			local flag = var_5_1.content.area_name == arg_5_1

			var_5_1.content.button_hotspot.is_selected = flag
		end
	end

	self._selected_area_name = arg_5_1

	self:_set_area_presentation_info(arg_5_1)

	self._widgets_by_name.select_button.content.button_hotspot.disable_button = arg_5_1 == nil
end

StartGameWindowAreaSelection._set_area_presentation_info = function (self, arg_6_1)
	-- function 6
	local str = ""
	local str_2 = ""
	local flag = true
	local var_6_3 = AreaSettings[arg_6_1]

	if not var_6_3 then
		local dlc_name = var_6_3.dlc_name

		if not dlc_name then
			flag = Managers.unlock:is_dlc_unlocked(dlc_name)
		end

		str = Localize(var_6_3.display_name)
		str_2 = Localize(var_6_3.description_text)
	end

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.area_title.content.text = str
	_widgets_by_name.description_text.content.text = str_2

	if not flag then
		_widgets_by_name.not_owned_text.content.visible = true
		_widgets_by_name.select_button.content.visible = true
		_widgets_by_name.requirements_not_met_text.content.visible = false
		_widgets_by_name.select_button.content.title_text = Localize("area_selection_visit_store")
	else
		local flag_2 = true

		if not var_6_3.unlock_requirement_function then
			local stats_id = Managers.player:local_player():stats_id()
			local statistics_db = Managers.player:statistics_db()

			flag_2 = var_6_3.unlock_requirement_function(statistics_db, stats_id)
		end

		if not flag_2 then
			_widgets_by_name.select_button.content.visible = true
			_widgets_by_name.requirements_not_met_text.content.visible = false
			_widgets_by_name.select_button.content.title_text = Localize("menu_select")
		else
			_widgets_by_name.select_button.content.visible = false
			_widgets_by_name.requirements_not_met_text.content.visible = true
			_widgets_by_name.requirements_not_met_text.content.text = var_6_3.unlock_requirement_description
		end

		_widgets_by_name.not_owned_text.content.visible = false
	end

	local video_settings = var_6_3.video_settings

	if not video_settings then
		local material_name = video_settings.material_name
		local resource = video_settings.resource

		self:_setup_video_player(material_name, resource)
	end

	local menu_sound_event = var_6_3.menu_sound_event

	self:_play_sound(menu_sound_event)
end

StartGameWindowAreaSelection.on_exit = function (self, arg_7_1)
	-- function 7
	print("[StartGameWindow] Exit Substate StartGameWindowAreaSelection")

	self.ui_animator = nil

	self.parent:set_input_description(nil)

	self._has_exited = true

	self:_destroy_video_player()

	arg_7_1.return_layout_name = nil

	self:_play_sound("Stop_hud_menu_area_music")
end

StartGameWindowAreaSelection.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:_update_animations(arg_8_1)
	self:_handle_input(arg_8_1, arg_8_2)
	self:draw(arg_8_1)
end

StartGameWindowAreaSelection.post_update = function (self, arg_9_1, arg_9_2)
	-- function 9
	self:draw_video(arg_9_1)
end

StartGameWindowAreaSelection._update_animations = function (self, arg_10_1)
	-- function 10
	local ui_animator = self.ui_animator

	ui_animator:update(arg_10_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _active_area_widgets = self._active_area_widgets

	if not _active_area_widgets then
		for k_2 = 1, #_active_area_widgets do
			local var_10_3 = _active_area_widgets[k_2]

			self:_animate_area_widget(var_10_3, arg_10_1)
		end
	end
end

StartGameWindowAreaSelection._is_button_pressed = function (arg_11_0, arg_11_1)
	-- function 11
	local button_hotspot = arg_11_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowAreaSelection._is_button_hovered = function (arg_12_0, arg_12_1)
	-- function 12
	if not arg_12_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

StartGameWindowAreaSelection._update_area_option = function (self)
	-- function 13
	local get_selected_area_name = self.parent:get_selected_area_name()

	if get_selected_area_name ~= self._selected_area_name then
		self:_select_area_by_name(get_selected_area_name)
	end
end

StartGameWindowAreaSelection._handle_input = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _active_area_widgets = self._active_area_widgets

	if not _active_area_widgets then
		for i = 1, #_active_area_widgets do
			local var_14_1 = _active_area_widgets[i]

			if not self:_is_button_hovered(var_14_1) then
				self:_play_sound("play_gui_lobby_button_02_mission_act_hover")
			end

			if not self:_is_button_pressed(var_14_1) then
				local area_name = var_14_1.content.area_name

				if self._selected_area_name ~= area_name then
					self:_select_area_by_name(area_name)
				end

				return
			end
		end
	end

	local select_button = self._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(select_button, arg_14_1)

	if not self:_is_button_hovered(select_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if not self:_is_button_pressed(select_button) then
		self:_on_select_button_pressed()
	end
end

StartGameWindowAreaSelection._on_select_button_pressed = function (self)
	-- function 15
	local _selected_area_name = self._selected_area_name
	local var_15_1 = AreaSettings[_selected_area_name]
	local flag = true
	local dlc_name = var_15_1.dlc_name

	if not dlc_name then
		flag = Managers.unlock:is_dlc_unlocked(dlc_name)
	end

	if not flag then
		local parent = self.parent
		local get_selected_layout_name = parent:get_selected_layout_name()
		local var_15_6

		if get_selected_layout_name == "area_selection_custom" then
			var_15_6 = "mission_selection_custom"
		elseif get_selected_layout_name == "area_selection_twitch" then
			var_15_6 = "mission_selection_twitch"
		end

		parent:set_selected_area_name(_selected_area_name)
		parent:set_layout_by_name(var_15_6)
	else
		local store_page_url = var_15_1.store_page_url

		if not store_page_url then
			print("store_page_url", _selected_area_name, store_page_url)
			self:_show_storepage(store_page_url)
		end
	end

	self:_play_sound("Play_hud_menu_area_start")
end

StartGameWindowAreaSelection.draw = function (self, arg_16_1)
	-- function 16
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_16_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_16_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_16_4)
	end

	local _active_area_widgets = self._active_area_widgets

	if not _active_area_widgets then
		for j = 1, #_active_area_widgets do
			local var_16_6 = _active_area_widgets[j]

			UIRenderer.draw_widget(ui_renderer, var_16_6)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowAreaSelection.draw_video = function (self, arg_17_1)
	-- function 17
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_17_1, nil, self.render_settings)

	if not self._draw_video_next_frame then
		if not (not self._video_widget and self._has_exited) then
			if not self._video_created then
				UIRenderer.draw_widget(ui_renderer, self._video_widget)
			else
				self._video_created = nil
			end
		end
	elseif not self._draw_video_next_frame then
		self._draw_video_next_frame = nil
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowAreaSelection._play_sound = function (self, arg_18_1)
	-- function 18
	self.parent:play_sound(arg_18_1)
end

StartGameWindowAreaSelection._setup_video_player = function (self, arg_19_1, arg_19_2)
	-- function 19
	self:_destroy_video_player()

	local ui_renderer = self.ui_renderer

	if not ui_renderer.video_players[str] then
		local flag = true

		UIRenderer.create_video_player(ui_renderer, str, ui_renderer.world, arg_19_2, flag)
	end

	local str_2 = "video"
	local create_video = UIWidgets.create_video(str_2, arg_19_1, str)

	self._video_widget = UIWidget.init(create_video)
	self._video_created = true
	self._draw_video_next_frame = true
end

StartGameWindowAreaSelection._destroy_video_player = function (self)
	-- function 20
	local ui_renderer = self.ui_renderer
	local _video_widget = self._video_widget

	if not _video_widget then
		UIWidget.destroy(ui_renderer, _video_widget)

		self._video_widget = nil
	end

	if not ui_renderer and not ui_renderer.video_players[str] then
		local world = ui_renderer.world

		UIRenderer.destroy_video_player(ui_renderer, str, world)
	end

	self._video_created = nil
end

StartGameWindowAreaSelection._animate_area_widget = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	local content = arg_21_1.content
	local style = arg_21_1.style
	local button_hotspot = content.button_hotspot
	local is_selected = button_hotspot.is_selected
	local num = 20
	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

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

	goto label_21_1

	::label_21_0::

	is_clicked = true

	::label_21_1::

	if not is_clicked then
		input_progress = math.min(input_progress + arg_21_2 * num, 1)
	else
		input_progress = math.max(input_progress - arg_21_2 * num, 0)
	end

	local num_2 = 8
	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	if not button_hotspot.is_hover then
		hover_progress = math.min(hover_progress + arg_21_2 * num_2, 1)
	else
		hover_progress = math.max(hover_progress - arg_21_2 * num_2, 0)
	end

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_21_2 * num_2, 1)
	else
		selection_progress = math.max(selection_progress - arg_21_2 * num_2, 0)
	end

	local num_3 = 255 * math.max(hover_progress, selection_progress)

	style.icon_glow.color[1] = num_3
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

StartGameWindowAreaSelection._show_storepage = function (arg_22_0, arg_22_1)
	-- function 22
	local PLATFORM = PLATFORM

	if not IS_WINDOWS and not rawget(_G, "Steam") then
		Steam.open_url(arg_22_1)
	end
end
