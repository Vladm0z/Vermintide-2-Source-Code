-- chunkname: @scripts/ui/views/deus_menu/deus_run_stats_ui.lua

local var_0_0 = local_require("scripts/ui/views/deus_menu/deus_run_stats_ui_definitions")
local animations_definitions = var_0_0.animations_definitions
local reminder_widgets = var_0_0.reminder_widgets
local generic_input_actions = var_0_0.generic_input_actions
local allow_boon_removal = var_0_0.allow_boon_removal

DeusRunStatsUi = class(DeusRunStatsUi)

DeusRunStatsUi.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._wwise_world = arg_1_1.wwise_world
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._ingame_ui_context = arg_1_1
	self._parent = arg_1_2
	self._gamepad_row_index = 1
	self._gamepad_column_index = 1
	self._active = false
	self._blessing_widgets = {}
	self._power_up_widgets = {}
	self._reminders = {}
	self._animations = {}
	self._ui_animations = {}
	self._force_update_power_ups = false

	self:_create_ui_elements()
	Managers.state.event:register(self, "present_rewards", "show_info_message")
end

DeusRunStatsUi.show_info_message = function (self, arg_2_1)
	-- function 2
	for i = 1, #arg_2_1 do
		local var_2_0 = arg_2_1[i]

		if table.size(self._animations) == 0 then
			self:_start_animation("reminder", var_2_0.type)
		else
			self._reminders[#self._reminders + 1] = var_2_0.type
		end
	end
end

DeusRunStatsUi._start_animation = function (self, arg_3_1, arg_3_2)
	-- function 3
	local tbl = {}
	local reminder_text = self._reminder_widgets_by_name.reminder_text

	reminder_text.content.info_type = arg_3_2

	local start_animation = self._ui_animator:start_animation(arg_3_1, reminder_text, var_0_0.scenegraph, tbl)

	self._animations[arg_3_1] = start_animation
end

DeusRunStatsUi._create_ui_elements = function (self)
	-- function 4
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(var_0_0.widgets) do
		if not v then
			local var_4_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_4_2
			tbl_2[k] = var_4_2
		end
	end

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(var_0_0.equipment_widgets) do
		if not v_2 then
			local var_4_5 = UIWidget.init(v_2)

			tbl_3[#tbl_3 + 1] = var_4_5
			tbl_4[k_2] = var_4_5
		end
	end

	local tbl_5 = {}
	local tbl_6 = {}

	for k_3, v_3 in pairs(reminder_widgets) do
		if not v_3 then
			local var_4_8 = UIWidget.init(v_3)

			tbl_5[#tbl_5 + 1] = var_4_8
			tbl_6[k_3] = var_4_8
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._reminder_widgets = tbl_5
	self._reminder_widgets_by_name = tbl_6
	self._equipment_widgets = tbl_3
	self._equipment_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animations_definitions)

	local input_service = self._parent:input_service()

	self._menu_input_description = MenuInputDescriptionUI:new(self._ingame_ui_context, self._ui_top_renderer, input_service, 6, nil, generic_input_actions.default, false)

	self._menu_input_description:set_input_description(nil)
end

DeusRunStatsUi.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_update_animations(arg_5_1, arg_5_2)
	self:_handle_gamepad_input(arg_5_1, arg_5_2)
	self:_handle_input(arg_5_1, arg_5_2)
	self:_draw(arg_5_1, arg_5_2)
	self:_draw_reminder(arg_5_1, arg_5_2)
end

DeusRunStatsUi._update_animations = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._ui_animator:update(arg_6_1)

	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _ui_animations = self._ui_animations

	for k_2, v_2 in pairs(_ui_animations) do
		UIAnimation.update(v_2, arg_6_1)

		if not UIAnimation.completed(v_2) then
			self._ui_animations[k_2] = nil
		end
	end

	if not self._ui_animations.move_scrollbar and not self._scrollbar_ui then
		self._scrollbar_ui:force_update_progress(2)
	end
end

DeusRunStatsUi.lock = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _locked = self._locked

	self._locked = arg_7_1
	self._widgets_by_name.fullscreen_fade.content.visible = arg_7_2

	local input = Managers.input

	if _locked or not arg_7_1 then
		ShowCursorStack.show("DeusRunStatsUi")
		input:block_device_except_service("deus_run_stats_view", "keyboard")
		input:block_device_except_service("deus_run_stats_view", "mouse")
		input:block_device_except_service("deus_run_stats_view", "gamepad")
	elseif not (not _locked and arg_7_1) then
		ShowCursorStack.hide("DeusRunStatsUi")
		input:device_unblock_all_services("keyboard")
		input:device_unblock_all_services("mouse")
		input:device_unblock_all_services("gamepad")

		self._gamepad_row_index = 1
		self._gamepad_column_index = 1
	end
end

DeusRunStatsUi.locked = function (self)
	-- function 8
	return self._locked
end

DeusRunStatsUi.set_active = function (self, arg_9_1)
	-- function 9
	if arg_9_1 ~= self._active then
		Managers.state.event:trigger("ingame_player_list_enabled", arg_9_1)
	end

	self._active = arg_9_1
end

DeusRunStatsUi.active = function (self)
	-- function 10
	return self._active
end

DeusRunStatsUi._handle_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self._active then
		return
	end

	local input_service = self._parent:input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	if (is_device_active or not input_service:get("hotkey_inventory", false)) and input_service:get("toggle_menu") or not input_service:get("back") then
		self:lock(false)
	end

	local _ui_scenegraph = self._ui_scenegraph
	local _power_up_widgets = self._power_up_widgets
	local power_up_description = self._widgets_by_name.power_up_description
	local var_11_5
	local var_11_6
	local flag = true

	for i = 1, #_power_up_widgets do
		local var_11_8 = self._power_up_widgets[i]
		local ceil = math.ceil(i / 2)
		local flag_2

		flag_2 = i % 2 ~= 0 or not 2 or 1

		if not ((UIUtils.is_button_hover(var_11_8) or not is_device_active) and self._gamepad_row_index ~= ceil or self._gamepad_column_index ~= flag_2) then
			local scenegraph_id = var_11_8.scenegraph_id
			local get_world_position = UISceneGraph.get_world_position(_ui_scenegraph, scenegraph_id)
			local offset = var_11_8.offset

			_ui_scenegraph.power_up_description_root.local_position[1] = get_world_position[1] + offset[1]
			_ui_scenegraph.power_up_description_root.local_position[2] = get_world_position[2] + offset[2]
			var_11_5 = var_11_8.content.power_up_name
			var_11_6 = var_11_8.content.power_up_rarity

			local locked = var_11_8.content.locked
			local locked_text_id = var_11_8.content.locked_text_id
			local content = power_up_description.content
			local style = power_up_description.style

			content.visible = true
			content.locked = locked
			content.locked_text_id = locked_text_id or content.locked_text_id

			if not locked then
				content.end_time = nil
				content.progress = nil
				content.input_made = false
				style.remove_frame.color[1] = 0

				break
			end

			if not allow_boon_removal then
				if input_service:get("mouse_middle_press") or not input_service:get("special_1_press") then
					content.input_made = true
					style.remove_frame.color[1] = 0

					self:_play_sound("Play_gui_boon_removal_start")

					break
				end

				if not content.input_made and input_service:get("mouse_middle_held") and not input_service:get("special_1_hold") then
					local end_time = content.end_time

					end_time = end_time or arg_11_2 + content.remove_interaction_duration

					local num = (end_time - arg_11_2) / content.remove_interaction_duration

					style.remove_frame.color[1] = 255 * (1 - num)

					if not (num <= 0) then
						content.end_time = nil
						content.progress = nil
						content.input_made = false

						local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
						local local_player_id = Managers.player:local_player():local_player_id()

						self._force_update_power_ups = get_deus_run_controller:remove_power_ups(var_11_5, local_player_id)

						self:_play_sound("Play_gui_boon_removal_end")

						break
					end

					content.end_time = end_time
					content.progress = num

					break
				end

				if not content.input_made then
					self:_play_sound("Stop_gui_boon_removal_start")
				end

				content.end_time = nil
				content.progress = nil
				content.input_made = false
				style.remove_frame.color[1] = 0
			end

			break
		end
	end

	if var_11_5 ~= self._current_power_up_name then
		self:_populate_power_up(var_11_5, var_11_6, power_up_description, flag)
	end

	self._current_power_up_name = var_11_5
end

local tbl = {}

DeusRunStatsUi._handle_gamepad_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _gamepad_active = self._gamepad_active
	local is_device_active = Managers.input:is_device_active("gamepad")

	self._gamepad_active = is_device_active

	if not (not is_device_active and self._active) then
		return
	end

	local input_service = self._parent:input_service()
	local count = #self._power_up_widgets
	local num = 2

	table.clear(tbl)

	tbl[1] = math.ceil(count / num)
	tbl[2] = math.floor(count / num)

	local _gamepad_row_index = self._gamepad_row_index
	local _gamepad_column_index = self._gamepad_column_index

	if not input_service:get("move_down_hold_continuous") then
		self._gamepad_row_index = math.min(self._gamepad_row_index + 1, tbl[self._gamepad_column_index])
	elseif not input_service:get("move_up_hold_continuous") then
		self._gamepad_row_index = math.max(self._gamepad_row_index - 1, 1)
	elseif not input_service:get("move_right") then
		local min = math.min(self._gamepad_column_index + 1, num)

		if tbl[min] >= self._gamepad_row_index then
			self._gamepad_column_index = min
		end
	elseif not input_service:get("move_left") then
		self._gamepad_column_index = math.max(self._gamepad_column_index - 1, 1)
	end

	if not (_gamepad_column_index ~= self._gamepad_column_index or _gamepad_row_index ~= self._gamepad_row_index or _gamepad_active == is_device_active) then
		local var_12_8 = self._ui_scenegraph.power_up_window.size[2]
		local num_2 = math.min(self._gamepad_row_index + 3, tbl[1]) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2])
		local max = math.max(num_2 - var_12_8, 0)

		self._ui_animations.move_scrollbar = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.power_up_anchor.local_position, 2, self._ui_scenegraph.power_up_anchor.local_position[2], max, 0.5, math.easeOutCubic)
	end
end

DeusRunStatsUi._populate_power_up = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	if not arg_13_1 then
		arg_13_3.content.visible = false

		return
	end

	local var_13_0 = DeusPowerUps[arg_13_2][arg_13_1]
	local content = arg_13_3.content
	local local_player = Managers.player:local_player()
	local profile_index = local_player:profile_index()
	local career_index = local_player:career_index()
	local rarity = var_13_0.rarity

	content.title_text = DeusPowerUpUtils.get_power_up_name_text(var_13_0.name, var_13_0.talent_index, var_13_0.talent_tier, profile_index, career_index)
	content.rarity_text = Localize(RaritySettings[rarity].display_name)
	content.description_text = DeusPowerUpUtils.get_power_up_description(var_13_0, profile_index, career_index)
	content.icon = DeusPowerUpUtils.get_power_up_icon(var_13_0, profile_index, career_index)
	content.extend_left = true
	content.is_rectangular_icon = DeusPowerUpTemplates[var_13_0.name].rectangular_icon

	local style = arg_13_3.style
	local get_table = Colors.get_table(rarity)

	style.rarity_text_left.text_color = get_table
	arg_13_3.content.visible = true

	local var_13_8 = DeusPowerUpSetLookup[rarity]

	var_13_8 = not var_13_8 and DeusPowerUpSetLookup[rarity][var_13_0.name]

	local flag = false

	if not var_13_8 then
		local var_13_10 = var_13_8[1]
		local num = 0
		local pieces = var_13_10.pieces
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

		for i, v in ipairs(pieces) do
			local name = v.name
			local rarity_2 = v.rarity
			local get_own_peer_id = get_deus_run_controller:get_own_peer_id()

			if not get_deus_run_controller:has_power_up_by_name(get_own_peer_id, name, rarity_2) then
				num = num + 1
			end
		end

		flag = true

		local num_required_pieces = var_13_10.num_required_pieces

		num_required_pieces = num_required_pieces or #pieces
		content.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), num, num_required_pieces)

		if #pieces == num then
			style.set_progression.text_color = style.set_progression.progression_colors.complete
		end
	end

	content.is_part_of_set = flag
end

DeusRunStatsUi._draw_reminder = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not (self._active or table.size(self._animations) ~= 0) then
		return
	end

	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local input_service = self._parent:input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, input_service, arg_14_1, nil, _render_settings)

	local _reminder_widgets = self._reminder_widgets

	for i = 1, #_reminder_widgets do
		local var_14_5 = _reminder_widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_14_5)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

DeusRunStatsUi._draw = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self._active then
		return
	end

	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local input_service = self._parent:input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, input_service, arg_15_1, nil, _render_settings)

	local snap_pixel_positions = _render_settings.snap_pixel_positions
	local _blessing_widgets = self._blessing_widgets

	for i = 1, #_blessing_widgets do
		local var_15_6 = _blessing_widgets[i]

		if var_15_6.snap_pixel_positions ~= nil then
			_render_settings.snap_pixel_positions = var_15_6.snap_pixel_positions
		end

		UIRenderer.draw_widget(_ui_top_renderer, var_15_6)

		_render_settings.snap_pixel_positions = snap_pixel_positions
	end

	local _power_up_widgets = self._power_up_widgets

	for j = 1, #_power_up_widgets do
		local var_15_8 = _power_up_widgets[j]

		if var_15_8.snap_pixel_positions ~= nil then
			_render_settings.snap_pixel_positions = var_15_8.snap_pixel_positions
		end

		UIRenderer.draw_widget(_ui_top_renderer, var_15_8)

		_render_settings.snap_pixel_positions = snap_pixel_positions
	end

	local _widgets = self._widgets

	for k = 1, #_widgets do
		local var_15_10 = _widgets[k]

		if var_15_10.snap_pixel_positions ~= nil then
			_render_settings.snap_pixel_positions = var_15_10.snap_pixel_positions
		end

		UIRenderer.draw_widget(_ui_top_renderer, var_15_10)

		_render_settings.snap_pixel_positions = snap_pixel_positions
	end

	local _equipment_widgets = self._equipment_widgets

	for l = 1, #_equipment_widgets do
		local var_15_12 = _equipment_widgets[l]

		if var_15_12.snap_pixel_positions ~= nil then
			_render_settings.snap_pixel_positions = var_15_12.snap_pixel_positions
		end

		UIRenderer.draw_widget(_ui_top_renderer, var_15_12)

		_render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not Managers.input:is_device_active("gamepad") then
		self._menu_input_description:draw(self._ui_top_renderer, arg_15_1)
	end

	if not self._scrollbar_ui then
		self._scrollbar_ui:update(arg_15_1, arg_15_2, _ui_top_renderer, input_service, _render_settings)
	end
end

DeusRunStatsUi._play_sound = function (self, arg_16_1)
	-- function 16
	WwiseWorld.trigger_event(self._wwise_world, arg_16_1)
end

DeusRunStatsUi.destroy = function (self)
	-- function 17
	self:lock(false)
end

DeusRunStatsUi.update_dynamic_values = function (self, arg_18_1)
	-- function 18
	self:_update_blessings(arg_18_1.blessings)
	self:_update_power_ups(arg_18_1.party_power_ups, arg_18_1.power_ups, arg_18_1.profile_index, arg_18_1.career_index)

	self._force_update_power_ups = false
end

DeusRunStatsUi.force_update_power_ups = function (self)
	-- function 19
	return self._force_update_power_ups
end

DeusRunStatsUi._update_blessings = function (self, arg_20_1)
	-- function 20
	local flag = #arg_20_1 > 0
	local content = self._widgets_by_name.no_blessings_text.content
	local flag_2

	flag_2 = not flag and "" and Localize("no_active_blessings_text")
	content.text = flag_2

	local str = "blessing_"

	for k, v in pairs(self._widgets_by_name) do
		if not string.starts_with(k, str) then
			self._widgets_by_name[k] = nil
		end
	end

	local tbl = {}

	if not flag then
		local blessing_widget_data = var_0_0.blessing_widget_data
		local min = math.min(#arg_20_1, blessing_widget_data.max_blessing_amount)

		for k_2 = 1, min do
			local var_20_7 = arg_20_1[k_2]
			local var_20_8 = DeusBlessingSettings[var_20_7]
			local var_20_9 = Localize(var_20_8.display_name)
			local var_20_10 = Localize(var_20_8.description)
			local icon = var_20_8.icon
			local str_2 = "blessing_" .. k_2
			local create_framed_info_box = UIWidgets.create_framed_info_box(str_2, blessing_widget_data.title_frame_name, blessing_widget_data.info_frame_name, nil, nil, icon, blessing_widget_data.icon_size, blessing_widget_data.icon_frame_name, var_20_9, var_20_10, blessing_widget_data.bottom_panel_size)
			local var_20_14 = UIWidget.init(create_framed_info_box)

			tbl[k_2] = var_20_14
			self._widgets_by_name[str .. k_2] = var_20_14
		end
	end

	self._blessing_widgets = tbl
end

DeusRunStatsUi._update_power_ups = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local flag = #arg_21_2 > 0 or #arg_21_1 > 0
	local tbl = {}

	if not flag then
		local var_21_2 = Managers.mechanism:game_mechanism():get_deus_run_controller():get_own_initial_talents()[SPProfiles[arg_21_3].careers[arg_21_4].name]
		local tbl_2 = {}

		for i = 1, #var_21_2 do
			local var_21_4 = var_21_2[i]

			if var_21_4 ~= 0 then
				local get_talent_power_up_from_tier_and_column, var_21_6 = DeusPowerUpUtils.get_talent_power_up_from_tier_and_column(i, var_21_4)

				tbl_2[get_talent_power_up_from_tier_and_column.name] = true
			end
		end

		local RaritySettings = RaritySettings

		table.sort(arg_21_2, function (self, arg_22_1)
			-- function 22
			local order = RaritySettings[self.rarity].order
			local order_2 = RaritySettings[arg_22_1.rarity].order

			if order == order_2 then
				return self.name < arg_22_1.name
			else
				return order_2 < order
			end
		end)

		local DeusPowerUpTemplates = DeusPowerUpTemplates
		local num = #arg_21_2 + #arg_21_1

		for j = 1, num do
			local var_21_10
			local flag_2 = false

			if j <= #arg_21_2 then
				var_21_10 = arg_21_2[j]
			else
				var_21_10 = arg_21_1[j - #arg_21_2]
				flag_2 = true
			end

			local var_21_12 = DeusPowerUps[var_21_10.rarity][var_21_10.name]
			local get_power_up_name_text, var_21_14 = DeusPowerUpUtils.get_power_up_name_text(var_21_12.name, var_21_12.talent_index, var_21_12.talent_tier, arg_21_3, arg_21_4)
			local get_power_up_icon = DeusPowerUpUtils.get_power_up_icon(var_21_12, arg_21_3, arg_21_4)
			local get_table = Colors.get_table(var_21_12.rarity)
			local rectangular_icon = DeusPowerUpTemplates[var_21_12.name].rectangular_icon
			local rectangular_power_up_widget_data

			if not rectangular_icon then
				rectangular_power_up_widget_data = var_0_0.rectangular_power_up_widget_data

				if not rectangular_power_up_widget_data then
					-- Nothing
				end
			end

			rectangular_power_up_widget_data = var_0_0.round_power_up_widget_data

			::label_21_0::

			local flag_3 = true
			local flag_4 = true
			local tbl_3 = {
				color = {
					255,
					138,
					172,
					235
				},
				offset = var_0_0.rectangular_power_up_widget_data.icon_offset,
				texture_size = var_0_0.rectangular_power_up_widget_data.icon_size
			}
			local str = "power_up_anchor"
			local create_icon_info_box = UIWidgets.create_icon_info_box(str, get_power_up_icon, rectangular_power_up_widget_data.icon_size, rectangular_power_up_widget_data.icon_offset, rectangular_power_up_widget_data.background_icon, rectangular_power_up_widget_data.background_icon_size, rectangular_power_up_widget_data.background_icon_offset, var_21_14, get_power_up_name_text, get_table, rectangular_power_up_widget_data.width, rectangular_icon, flag_3, flag_4, tbl_3)
			local var_21_24 = UIWidget.init(create_icon_info_box)

			var_21_24.content.power_up_name = var_21_12.name
			var_21_24.content.power_up_rarity = var_21_12.rarity
			var_21_24.content.locked = flag_2 or tbl_2[var_21_12.name]

			local content = var_21_24.content
			local flag_5

			flag_5 = not flag_2 and "party_locked" and not tbl_2[var_21_12.name] or "talent_locked" and "search_filter_locked"
			content.locked_text_id = flag_5

			local num_2 = (j - 1) % 2

			var_21_24.offset[1] = num_2 * (var_0_0.power_up_widget_size[1] + var_0_0.power_up_widget_spacing[1])
			var_21_24.offset[2] = -math.floor((j - 1) / 2) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2])
			tbl[#tbl + 1] = var_21_24
			self._widgets_by_name[str] = var_21_24
		end

		local num_3 = 2

		if num < (self._gamepad_row_index - 1) * num_3 + self._gamepad_column_index then
			self._gamepad_row_index = math.ceil(num / num_3)
			self._gamepad_column_index = num_3 - num % num_3
		end

		if not Managers.input:is_device_active("gamepad") then
			local var_21_29 = self._ui_scenegraph.power_up_window.size[2]
			local num_4 = self._gamepad_row_index * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2])
			local max = math.max(num_4 - var_21_29, 0)

			self._ui_animations.move_scrollbar = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.power_up_anchor.local_position, 2, self._ui_scenegraph.power_up_anchor.local_position[2], max, 0.5, math.easeOutCubic)
		end

		local num_5 = math.ceil(num / 2) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2]) - self._ui_scenegraph.power_up_window.size[2]

		if num_5 > 0 then
			local _ui_scenegraph = self._ui_scenegraph
			local str_2 = "power_up_anchor"
			local str_3 = "power_up_window"
			local var_21_36 = num_5
			local flag_6 = false
			local var_21_38
			local var_21_39
			local flag_7 = false

			self._scrollbar_ui = ScrollbarUI:new(_ui_scenegraph, str_2, str_3, var_21_36, flag_6, var_21_38, var_21_39, flag_7)

			self._scrollbar_ui:disable_gamepad_input(true)
		else
			self._scrollbar_ui = nil
		end
	end

	self._power_up_widgets = tbl
	self._power_ups = arg_21_2
	self._party_power_ups = arg_21_1
end

DeusRunStatsUi.set_loadout = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	self._equipment_widgets_by_name.weapon_melee.content.item = arg_23_1
	self._equipment_widgets_by_name.weapon_ranged.content.item = arg_23_2

	local healing_slot = self._equipment_widgets_by_name.healing_slot
	local potion_slot = self._equipment_widgets_by_name.potion_slot
	local grenade_slot = self._equipment_widgets_by_name.grenade_slot
	local flag = not arg_23_3 and ItemMasterList[arg_23_3]
	local content = healing_slot.content
	local hud_icon

	if not flag then
		hud_icon = flag.hud_icon

		if not hud_icon then
			-- Nothing
		end
	end

	hud_icon = "consumables_empty_medpack"

	::label_23_0::

	content.icon = hud_icon

	local content_2 = healing_slot.content
	local var_23_7

	if not flag then
		var_23_7 = Localize(arg_23_3)

		if not var_23_7 then
			-- Nothing
		end
	end

	var_23_7 = Localize("deus_weapon_inspect_title_unavailable")

	::label_23_1::

	content_2.title_text = var_23_7

	local content_3 = healing_slot.content
	local var_23_9

	if not flag then
		var_23_9 = Localize(flag.description)

		if not var_23_9 then
			-- Nothing
		end
	end

	var_23_9 = Localize("deus_weapon_inspect_info_unavailable")

	::label_23_2::

	content_3.info_text = var_23_9
	healing_slot.content.visible = flag ~= nil

	local flag_2 = not arg_23_4 and ItemMasterList[arg_23_4]
	local str = "consumables_empty_potion"
	local var_23_12 = Localize("deus_weapon_inspect_title_unavailable")
	local var_23_13 = Localize("deus_weapon_inspect_info_unavailable")

	if not flag_2 then
		str = flag_2.hud_icon or str
		var_23_12 = Localize(arg_23_4)
		var_23_13 = UIUtils.format_localized_description(flag_2.description, flag_2.description_values)
	end

	potion_slot.content.icon = str
	potion_slot.content.title_text = var_23_12
	potion_slot.content.info_text = var_23_13
	potion_slot.content.visible = flag_2 ~= nil

	local flag_3 = not arg_23_5 and ItemMasterList[arg_23_5]
	local content_4 = grenade_slot.content
	local hud_icon_2

	if not flag_3 then
		hud_icon_2 = flag_3.hud_icon

		if not hud_icon_2 then
			-- Nothing
		end
	end

	hud_icon_2 = "consumables_empty_grenade"

	::label_23_3::

	content_4.icon = hud_icon_2

	local content_5 = grenade_slot.content
	local var_23_18

	if not flag_3 then
		var_23_18 = Localize(arg_23_5)

		if not var_23_18 then
			-- Nothing
		end
	end

	var_23_18 = Localize("deus_weapon_inspect_title_unavailable")

	::label_23_4::

	content_5.title_text = var_23_18

	local content_6 = grenade_slot.content
	local var_23_20

	if not flag_3 then
		var_23_20 = Localize(flag_3.description)

		if not var_23_20 then
			-- Nothing
		end
	end

	var_23_20 = Localize("deus_weapon_inspect_info_unavailable")

	::label_23_5::

	content_6.info_text = var_23_20
	grenade_slot.content.visible = flag_3 ~= nil
end

DeusRunStatsUi._create_player_portrait = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local create_portrait_frame = UIWidgets.create_portrait_frame("player_portrait", arg_24_1, arg_24_3, 1, nil, arg_24_2)
	local var_24_1 = UIWidget.init(create_portrait_frame, self._ui_top_renderer)

	table.insert(self._widgets, var_24_1)

	self._widgets_by_name.player_portrait = var_24_1
end

DeusRunStatsUi._set_widget_text = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	arg_25_0._widgets_by_name[arg_25_1].content.text = arg_25_2
end
