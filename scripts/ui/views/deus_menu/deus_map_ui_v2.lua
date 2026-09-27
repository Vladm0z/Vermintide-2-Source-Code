-- chunkname: @scripts/ui/views/deus_menu/deus_map_ui_v2.lua

require("scripts/helpers/ui_atlas_helper")

DeusMapUI = class(DeusMapUI)

local num = 1
local var_0_1 = local_require("scripts/ui/views/deus_menu/deus_map_ui_definitions_v2")
local allow_boon_removal = var_0_1.allow_boon_removal

DeusMapUI.init = function (self, arg_1_1)
	-- function 1
	self._context = arg_1_1
	self._ui_renderer = arg_1_1.ui_renderer
	self._render_content = false
	self._render_full_screen_rect = false
	self._deus_run_controller = arg_1_1.deus_run_controller
	self._wwise_world = arg_1_1.wwise_world

	self:_create_ui_elements()
	Managers.state.event:register(self, "ingame_player_list_enabled", "event_ingame_player_list_enabled")
end

DeusMapUI.event_ingame_player_list_enabled = function (self, arg_2_1, arg_2_2)
	-- function 2
	local content = self._widgets_by_name.console_cursor.content

	if not arg_2_1 then
		content.visible = false

		if not arg_2_2 then
			Managers.input:disable_gamepad_cursor()
		end
	else
		content.visible = true

		Managers.input:enable_gamepad_cursor()
	end
end

DeusMapUI._create_ui_elements = function (self)
	-- function 3
	local scenegraph_definition = var_0_1.scenegraph_definition
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self._ui_animator = UIAnimator:new(init_scenegraph, var_0_1.animations_definitions)

	local create_widgets, var_3_3 = UIUtils.create_widgets(var_0_1.widget_definitions)
	local tbl = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	local tbl_2 = {
		alpha_multiplier = 1
	}
	local shallow_copy = table.shallow_copy(self._deus_run_controller:get_peers(), true)
	local index_of = table.index_of(shallow_copy, Network.peer_id())

	if index_of > 0 then
		table.remove(shallow_copy, index_of)
	end

	table.insert(shallow_copy, 1, Network.peer_id())

	local tbl_3 = {}
	local tbl_4 = {}

	for i = 1, 4 do
		local str = "player_portrait_frame_" .. i
		local var_3_11
		local var_3_12
		local str_2 = "player_insignia_" .. i
		local var_3_14
		local var_3_15

		if not shallow_copy[i] then
			local get_player_profile, var_3_17 = self._deus_run_controller:get_player_profile(shallow_copy[i], num)
			local get_player_level = self._deus_run_controller:get_player_level(shallow_copy[i], get_player_profile)

			get_player_level = get_player_level or "-"

			local get_player_frame = self._deus_run_controller:get_player_frame(shallow_copy[i], get_player_profile, var_3_17)

			var_3_11 = UIWidgets.deus_create_player_portraits_frame("player_" .. i .. "_portrait", get_player_frame, get_player_level, false)

			local get_versus_player_level = self._deus_run_controller:get_versus_player_level(shallow_copy[i])

			var_3_14 = UIWidgets.create_small_insignia("player_" .. i .. "_insignia", get_versus_player_level)

			local get_server_peer_id = self._deus_run_controller:get_server_peer_id()

			if shallow_copy[i] == get_server_peer_id then
				local create_simple_texture = UIWidgets.create_simple_texture("host_icon", "player_" .. i .. "_portrait", nil, nil, nil, {
					-60,
					-8,
					50
				}, {
					40,
					40
				})
				local var_3_23 = UIWidget.init(create_simple_texture)

				var_3_3.host_icon = var_3_23
				create_widgets[#create_widgets + 1] = var_3_23
			end
		else
			var_3_11 = UIWidgets.deus_create_player_portraits_frame("player_" .. i .. "_portrait", "default", " ", false)
			var_3_14 = UIWidgets.create_small_insignia("player_" .. i .. "_insignia", 0)
		end

		local var_3_24 = UIWidget.init(var_3_11)

		tbl_3[#tbl_3 + 1] = var_3_24
		var_3_3[str] = var_3_24
		create_widgets[#create_widgets + 1] = var_3_24

		local var_3_25 = UIWidget.init(var_3_14)

		tbl_4[#tbl_4 + 1] = var_3_25
		var_3_3[str_2] = var_3_24
	end

	self._portrait_frame_widgets = tbl_3
	self._insignia_widgets = tbl_4
	self._ui_scenegraph = init_scenegraph
	self._widgets_by_name = var_3_3
	self._widgets = create_widgets
	self._anim_data = tbl_2
	self._render_settings = tbl
	self._portrait_mode = true

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._total_num_power_ups = nil

	self:_update_power_ups()
end

DeusMapUI.on_enter = function (self, arg_4_1)
	-- function 4
	self._input_service = arg_4_1
end

DeusMapUI.on_exit = function (arg_5_0)
	-- function 5
	return
end

DeusMapUI._play_sound = function (self, arg_6_1)
	-- function 6
	WwiseWorld.trigger_event(self._wwise_world, arg_6_1)
end

DeusMapUI.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not RESOLUTION_LOOKUP.modified then
		self:_on_resolution_changed()
	end

	self:_update_animations(arg_7_1, arg_7_2)
	self:_update_power_ups()
	self:_handle_mode_input(arg_7_1, arg_7_2)
	self:_handle_owned_power_up_input(arg_7_1, arg_7_2)
	self:_update_input_helper_text(arg_7_1, arg_7_2)
	self:_draw(arg_7_1, arg_7_2)
end

DeusMapUI._update_input_helper_text = function (self)
	-- function 8
	local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5
	local _widgets_by_name = self._widgets_by_name
	local portrait_input_helper_text = _widgets_by_name.portrait_input_helper_text
	local text = portrait_input_helper_text.style.text
	local boon_input_helper_text = _widgets_by_name.boon_input_helper_text
	local text_2 = boon_input_helper_text.style.text

	text.text_color[1] = 100 + 155 * num
	text_2.text_color[1] = 100 + 155 * num
	portrait_input_helper_text.content.visible = not self._portrait_mode
	boon_input_helper_text.content.visible = self._portrait_mode
end

DeusMapUI._handle_owned_power_up_input = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _ui_scenegraph = self._ui_scenegraph
	local _input_service = self._input_service
	local _power_up_widgets = self._power_up_widgets
	local power_up_description = self._widgets_by_name.power_up_description
	local var_9_4
	local var_9_5

	if not (self._portrait_mode or allow_boon_removal) then
		power_up_description.content.visible = false
		self._current_power_up_name = nil

		return
	end

	local content = power_up_description.content
	local style = power_up_description.style
	local flag = false

	for i = 1, #_power_up_widgets do
		local var_9_9 = _power_up_widgets[i]

		if not UIUtils.is_button_hover(var_9_9) then
			local scenegraph_id = var_9_9.scenegraph_id
			local get_world_position = UISceneGraph.get_world_position(_ui_scenegraph, scenegraph_id)
			local offset = var_9_9.offset

			_ui_scenegraph.power_up_description_root.local_position[1] = get_world_position[1] + offset[1]
			_ui_scenegraph.power_up_description_root.local_position[2] = get_world_position[2] + offset[2]
			var_9_4 = var_9_9.content.power_up_name
			var_9_5 = var_9_9.content.power_up_rarity

			local locked = var_9_9.content.locked
			local locked_text_id = var_9_9.content.locked_text_id

			content.visible = true
			content.locked = locked
			content.locked_text_id = locked_text_id or content.locked_text_id
			flag = true

			if not locked then
				content.end_time = nil
				content.progress = nil
				content.input_made = false
				style.remove_frame.color[1] = 0

				break
			end

			if _input_service:get("mouse_middle_press") or not _input_service:get("special_1_press") then
				content.input_made = true
				style.remove_frame.color[1] = 0

				self:_play_sound("Play_gui_boon_removal_start")

				break
			end

			if not content.input_made and _input_service:get("mouse_middle_held") and not _input_service:get("special_1_hold") then
				local end_time = content.end_time

				end_time = end_time or arg_9_2 + content.remove_interaction_duration

				local num = (end_time - arg_9_2) / content.remove_interaction_duration

				style.remove_frame.color[1] = 255 * (1 - num)

				if not (num <= 0) then
					content.end_time = nil
					content.progress = nil
					content.input_made = false

					local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
					local local_player_id = Managers.player:local_player():local_player_id()

					self._force_update_power_ups = get_deus_run_controller:remove_power_ups(var_9_4, local_player_id)

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

			break
		end
	end

	if not flag then
		content.end_time = nil
		content.progress = nil
		content.input_made = false
		style.remove_frame.color[1] = 0
	end

	if var_9_4 ~= self._current_power_up_name then
		self:_populate_power_up(var_9_4, var_9_5, power_up_description)
	end

	self._current_power_up_name = var_9_4
end

DeusMapUI._populate_power_up = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not arg_10_1 then
		arg_10_3.content.visible = false

		return
	end

	local var_10_0 = DeusPowerUps[arg_10_2][arg_10_1]
	local content = arg_10_3.content
	local local_player = Managers.player:local_player()
	local profile_index = local_player:profile_index()
	local career_index = local_player:career_index()
	local rarity = var_10_0.rarity

	content.title_text = DeusPowerUpUtils.get_power_up_name_text(var_10_0.name, var_10_0.talent_index, var_10_0.talent_tier, profile_index, career_index)
	content.rarity_text = Localize(RaritySettings[rarity].display_name)
	content.description_text = DeusPowerUpUtils.get_power_up_description(var_10_0, profile_index, career_index)
	content.icon = DeusPowerUpUtils.get_power_up_icon(var_10_0, profile_index, career_index)
	content.extend_left = false
	content.is_rectangular_icon = DeusPowerUpTemplates[var_10_0.name].rectangular_icon

	local style = arg_10_3.style
	local get_table = Colors.get_table(rarity)

	style.rarity_text.text_color = get_table
	arg_10_3.content.visible = true

	local var_10_8 = DeusPowerUpSetLookup[rarity]

	var_10_8 = not var_10_8 and DeusPowerUpSetLookup[rarity][var_10_0.name]

	local flag = false

	if not var_10_8 then
		local var_10_10 = var_10_8[1]
		local num = 0
		local pieces = var_10_10.pieces
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

		local num_required_pieces = var_10_10.num_required_pieces

		num_required_pieces = num_required_pieces or #pieces
		content.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), num, num_required_pieces)

		if #pieces == num then
			style.set_progression.text_color = style.set_progression.progression_colors.complete
		end
	end

	content.is_part_of_set = flag
end

local tbl = {}

DeusMapUI._update_power_ups = function (self)
	-- function 11
	local _deus_run_controller = self._deus_run_controller
	local get_own_peer_id = _deus_run_controller:get_own_peer_id()
	local get_player_profile, var_11_3 = _deus_run_controller:get_player_profile(get_own_peer_id, num)
	local get_party_power_ups = _deus_run_controller:get_party_power_ups()
	local var_11_5 = tbl
	local num_2 = 0
	local _power_up_widgets = self._power_up_widgets

	_power_up_widgets = _power_up_widgets or {}

	if not (get_player_profile == 0 or var_11_3 == 0) then
		local get_player_power_ups = _deus_run_controller:get_player_power_ups(get_own_peer_id, num)
		local num_3 = #get_player_power_ups + #get_party_power_ups

		if num_3 ~= self._total_num_power_ups then
			table.clear(_power_up_widgets)

			if num_3 > 0 then
				local var_11_10 = Managers.mechanism:game_mechanism():get_deus_run_controller():get_own_initial_talents()[SPProfiles[get_player_profile].careers[var_11_3].name]
				local tbl_2 = {}

				for i = 1, #var_11_10 do
					local var_11_12 = var_11_10[i]

					if var_11_12 ~= 0 then
						local get_talent_power_up_from_tier_and_column, var_11_14 = DeusPowerUpUtils.get_talent_power_up_from_tier_and_column(i, var_11_12)

						tbl_2[get_talent_power_up_from_tier_and_column.name] = true
					end
				end

				local RaritySettings = RaritySettings

				table.sort(get_player_power_ups, function (self, arg_12_1)
					-- function 12
					local order = RaritySettings[self.rarity].order
					local order_2 = RaritySettings[arg_12_1.rarity].order

					if order == order_2 then
						return self.name < arg_12_1.name
					else
						return order_2 < order
					end
				end)

				local DeusPowerUpTemplates = DeusPowerUpTemplates
				local num_4 = #get_player_power_ups + #get_party_power_ups

				for j = 1, num_4 do
					local var_11_18
					local flag = false

					if j <= #get_player_power_ups then
						var_11_18 = get_player_power_ups[j]
					else
						var_11_18 = get_party_power_ups[j - #get_player_power_ups]
						flag = true
					end

					local var_11_20 = DeusPowerUps[var_11_18.rarity][var_11_18.name]
					local get_power_up_name_text, var_11_22 = DeusPowerUpUtils.get_power_up_name_text(var_11_20.name, var_11_20.talent_index, var_11_20.talent_tier, get_player_profile, var_11_3)
					local get_power_up_icon = DeusPowerUpUtils.get_power_up_icon(var_11_20, get_player_profile, var_11_3)
					local get_table = Colors.get_table(var_11_20.rarity)
					local rectangular_icon = DeusPowerUpTemplates[var_11_20.name].rectangular_icon
					local rectangular_power_up_widget_data

					if not rectangular_icon then
						rectangular_power_up_widget_data = var_0_1.rectangular_power_up_widget_data

						if not rectangular_power_up_widget_data then
							-- Nothing
						end
					end

					rectangular_power_up_widget_data = var_0_1.round_power_up_widget_data

					::label_11_0::

					local flag_2 = true
					local flag_3 = true
					local tbl_3 = {
						color = {
							255,
							138,
							172,
							235
						},
						offset = var_0_1.rectangular_power_up_widget_data.icon_offset,
						texture_size = var_0_1.rectangular_power_up_widget_data.icon_size
					}
					local str = "own_power_up_anchor"
					local create_icon_info_box = UIWidgets.create_icon_info_box(str, get_power_up_icon, rectangular_power_up_widget_data.icon_size, rectangular_power_up_widget_data.icon_offset, rectangular_power_up_widget_data.background_icon, rectangular_power_up_widget_data.background_icon_size, rectangular_power_up_widget_data.background_icon_offset, var_11_22, get_power_up_name_text, get_table, rectangular_power_up_widget_data.width, rectangular_icon, flag_2, flag_3, tbl_3)
					local var_11_32 = UIWidget.init(create_icon_info_box)

					var_11_32.content.power_up_name = var_11_20.name
					var_11_32.content.power_up_rarity = var_11_20.rarity
					var_11_32.content.locked = flag or tbl_2[var_11_20.name]

					local content = var_11_32.content
					local flag_4

					flag_4 = not flag and "party_locked" and not tbl_2[var_11_20.name] or "talent_locked" and "search_filter_locked"
					content.locked_text_id = flag_4

					local num_5 = (j - 1) % 2

					var_11_32.offset[1] = num_5 * (var_0_1.power_up_widget_size[1] + var_0_1.power_up_widget_spacing[1])
					var_11_32.offset[2] = -math.floor((j - 1) / 2) * (var_0_1.power_up_widget_size[2] + var_0_1.power_up_widget_spacing[2])
					_power_up_widgets[#_power_up_widgets + 1] = var_11_32
					self._widgets_by_name[str] = var_11_32
				end
			end

			self._total_num_power_ups = num_3
			self._power_up_widgets = _power_up_widgets
			self._power_ups = get_player_power_ups
			self._party_power_ups = get_party_power_ups

			local num_6 = math.ceil(self._total_num_power_ups / 2) * (var_0_1.power_up_widget_size[2] + var_0_1.power_up_widget_spacing[2]) - self._ui_scenegraph.own_power_up_window.size[2]

			if num_6 > 0 then
				local _ui_scenegraph = self._ui_scenegraph
				local str_2 = "own_power_up_anchor"
				local str_3 = "own_power_up_window"
				local var_11_40 = num_6
				local flag_5 = false
				local var_11_42
				local var_11_43
				local flag_6 = true

				self._scrollbar_ui = ScrollbarUI:new(_ui_scenegraph, str_2, str_3, var_11_40, flag_5, var_11_42, var_11_43, flag_6)
			else
				self._scrollbar_ui = nil
			end
		end
	end
end

DeusMapUI._handle_mode_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self._input_service:get("cycle_next_raw") then
		if not self._ui_animator:is_animation_completed(self._anim_id) then
			self._ui_animator:stop_animation(self._anim_id)
		end

		local _ui_animator = self._ui_animator
		local var_13_1 = _ui_animator
		local start_animation = _ui_animator.start_animation
		local flag

		flag = not self._portrait_mode and "switch_to_boons" and "switch_to_portraits"
		self._anim_id = start_animation(var_13_1, flag, self._widgets_by_name, var_0_1.scenegraph_definition)
		self._portrait_mode = not self._portrait_mode
	end
end

DeusMapUI._update_animations = function (self, arg_14_1, arg_14_2)
	-- function 14
	self._ui_animator:update(arg_14_1)

	local _anim_data = self._anim_data

	if not _anim_data.alpha_multiplier_animation_duration then
		return
	end

	if not _anim_data.alpha_multiplier_animation_start_time then
		_anim_data.alpha_multiplier_animation_start_time = arg_14_2
		_anim_data.alpha_multiplier_animation_end_time = arg_14_2 + _anim_data.alpha_multiplier_animation_duration
	end

	local var_14_1
	local num = _anim_data.alpha_multiplier_animation_end_time - _anim_data.alpha_multiplier_animation_start_time
	local flag

	flag = not (num <= 0.001) or not 1 or math.clamp((arg_14_2 - _anim_data.alpha_multiplier_animation_start_time) / num, 0, 1)
	_anim_data.alpha_multiplier = math.lerp(_anim_data.source_alpha_multiplier, _anim_data.target_alpha_multiplier, flag)

	if flag == 1 then
		_anim_data.alpha_multiplier_animation_duration = nil
		_anim_data.alpha_multiplier_animation_start_time = nil
		_anim_data.alpha_multiplier_animation_end_time = nil
		_anim_data.source_alpha_multiplier = nil
		_anim_data.target_alpha_multiplier = nil
	end
end

DeusMapUI._draw = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _input_service = self._input_service
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local _anim_data = self._anim_data
	local var_15_5

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, _input_service, arg_15_1, var_15_5, _render_settings)

	local alpha_multiplier = _anim_data.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 0
	_render_settings.alpha_multiplier = alpha_multiplier

	if not self._render_full_screen_rect then
		UIRenderer.draw_rect(_ui_renderer, Vector2(0, 0), UISceneGraph.get_size_scaled(_ui_scenegraph, "screen"), Colors.color_definitions.black)
	end

	if not self._render_content then
		UIRenderer.draw_all_widgets(_ui_renderer, self._widgets)
	end

	_render_settings.alpha_multiplier = 1

	self:_draw_boons(arg_15_1, arg_15_2)
	UIRenderer.end_pass(_ui_renderer)

	if not (not self._scrollbar_ui and self._portrait_mode) then
		self._scrollbar_ui:update(arg_15_1, arg_15_2, _ui_renderer, _input_service, _render_settings)
	end
end

DeusMapUI._draw_boons = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _ui_scenegraph = self._ui_scenegraph
	local _ui_renderer = self._ui_renderer
	local str = "own_power_up_anchor"
	local str_2 = "own_power_up_window"
	local get_world_position = UISceneGraph.get_world_position(_ui_scenegraph, str)
	local get_world_position_2 = UISceneGraph.get_world_position(_ui_scenegraph, str_2)
	local var_16_6 = _ui_scenegraph[str_2].size[2]
	local _power_up_widgets = self._power_up_widgets

	for i = 1, #_power_up_widgets do
		local var_16_8 = _power_up_widgets[i]
		local hotspot = var_16_8.content.hotspot
		local offset = var_16_8.offset
		local num = get_world_position[2] + offset[2]
		local var_16_12 = var_0_1.power_up_widget_size[2]

		if num > get_world_position_2[2] + var_16_6 then
			table.clear(hotspot)
		elseif num + var_16_12 < get_world_position_2[2] then
			table.clear(hotspot)

			break
		else
			UIRenderer.draw_widget(_ui_renderer, var_16_8)
		end
	end
end

DeusMapUI.enable_hover_text = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, arg_17_11, arg_17_12, arg_17_13)
	-- function 17
	local var_17_0 = UIInverseScaleVectorToResolution(arg_17_1)
	local position = self._ui_scenegraph.node_info_pivot.position

	position[1] = var_17_0[1]
	position[2] = var_17_0[2]

	local node_info = self._widgets_by_name.node_info

	node_info.content.visible = true

	local node_info_2 = node_info.content.node_info

	if not arg_17_3 then
		node_info_2.none_modifier_info.title = Localize(arg_17_3 .. "_title")
		node_info_2.none_modifier_info.description = Localize(arg_17_3 .. "_desc")
	else
		node_info_2.none_modifier_info.title = Localize("undiscovered_level_title")
		node_info_2.none_modifier_info.description = Localize("undiscovered_level_desc")
	end

	if not (not arg_17_4 and arg_17_4 ~= "wastes") then
		node_info_2.curse_text = ""
	else
		node_info_2.curse_text = Localize("deus_map_node_info_god_" .. arg_17_4)
		node_info_2.curse_icon = "deus_icons_map_" .. arg_17_4
		node_info.style.node_info.curse_section.curse_icon.color = Colors.get_color_table_with_alpha(arg_17_4, 255)
		node_info.style.node_info.curse_section.curse_text.text_color = Colors.get_color_table_with_alpha(arg_17_4, 255)
	end

	if not arg_17_5 then
		local minor_modifier_1_section = node_info_2.minor_modifier_1_section
		local var_17_5

		if not arg_17_5[1] then
			var_17_5 = Localize("mutator_" .. arg_17_5[1] .. "_name")

			if not var_17_5 then
				-- Nothing
			end
		end

		var_17_5 = ""

		::label_17_0::

		minor_modifier_1_section.text = var_17_5

		local minor_modifier_2_section = node_info_2.minor_modifier_2_section
		local var_17_7

		if not arg_17_5[2] then
			var_17_7 = Localize("mutator_" .. arg_17_5[2] .. "_name")

			if not var_17_7 then
				-- Nothing
			end
		end

		var_17_7 = ""

		::label_17_1::

		minor_modifier_2_section.text = var_17_7

		local minor_modifier_3_section = node_info_2.minor_modifier_3_section
		local var_17_9

		if not arg_17_5[3] then
			var_17_9 = Localize("mutator_" .. arg_17_5[3] .. "_name")

			if not var_17_9 then
				-- Nothing
			end
		end

		var_17_9 = ""

		::label_17_2::

		minor_modifier_3_section.text = var_17_9
	else
		node_info_2.minor_modifier_1_section.text = ""
		node_info_2.minor_modifier_2_section.text = ""
		node_info_2.minor_modifier_3_section.text = ""
	end

	if not arg_17_7 then
		local var_17_10 = DeusPowerUpTemplates[arg_17_7]
		local get_power_up_name_text = DeusPowerUpUtils.get_power_up_name_text(arg_17_7, var_17_10.talent_index, var_17_10.talent_tier, arg_17_12, arg_17_13)
		local var_17_12 = Localize("terror_event_power_up_prefix_suffix")
		local format = string.format(var_17_12, get_power_up_name_text)

		node_info.content.node_info.terror_event_power_up_text = format
		node_info.content.node_info.terror_event_power_up_icon = var_17_10.icon
	elseif not arg_17_8 then
		if arg_17_8 > 1 then
			local var_17_14 = Localize("end_of_level_reward_hover_text_random_power_up_multiple")
			local var_17_15 = RaritySettings[arg_17_9]
			local var_17_16 = Localize(var_17_15.display_name)

			node_info_2.terror_event_power_up_text = string.format(var_17_14, arg_17_8, var_17_16)
		else
			local var_17_17 = Localize("end_of_level_reward_hover_text_random_power_up_singular")
			local var_17_18 = RaritySettings[arg_17_9]
			local var_17_19 = Localize(var_17_18.display_name)

			node_info_2.terror_event_power_up_text = string.format(var_17_17, var_17_19)
		end
	else
		node_info_2.terror_event_power_up_text = ""
	end

	node_info_2.shrine_text = ""

	local var_17_20 = ConflictDirectors[arg_17_6]
	local flag = not var_17_20 and var_17_20.description

	if not flag then
		local var_17_22 = Localize(flag)

		var_17_22 = var_17_22 or ""
		node_info_2.breed_text = var_17_22
	else
		node_info_2.breed_text = ""
	end

	local none_modifier_info = node_info_2.none_modifier_info
	local flag_2

	flag_2 = not arg_17_11 and "deus_map_node_info_click_to_vote" and ""
	none_modifier_info.click_to_vote = flag_2

	local flag_3

	flag_3 = not arg_17_10 and "menu_frame_12_gold" and "menu_frame_12"
	node_info_2.frame_settings_name = flag_3
end

DeusMapUI._update_portrait_frame = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local deus_create_player_portraits_frame = UIWidgets.deus_create_player_portraits_frame("player_" .. arg_18_3 .. "_portrait", arg_18_1, arg_18_2, false)
	local var_18_1 = UIWidget.init(deus_create_player_portraits_frame)

	arg_18_0._portrait_frame_widgets[arg_18_3] = var_18_1
	arg_18_0._widgets_by_name["player_portrait_frame_" .. arg_18_3] = var_18_1
end

DeusMapUI._update_insignia = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local create_small_insignia = UIWidgets.create_small_insignia("player_" .. arg_19_2 .. "_insignia", arg_19_1)
	local var_19_1 = UIWidget.init(create_small_insignia)

	arg_19_0._insignia_widgets[arg_19_2] = var_19_1
	arg_19_0._widgets_by_name["player_insignia_" .. arg_19_2] = var_19_1
end

DeusMapUI.update_player_data = function (self, arg_20_1)
	-- function 20
	self._player_data = arg_20_1

	local _widgets_by_name = self._widgets_by_name

	for i = 1, 4 do
		local var_20_1 = arg_20_1[i]
		local var_20_2 = _widgets_by_name["player_" .. i .. "_portrait"]
		local var_20_3 = _widgets_by_name["player_" .. i .. "_texts"]
		local var_20_4 = _widgets_by_name["player_portrait_frame_" .. i]
		local var_20_5 = _widgets_by_name["player_insignia_" .. i]
		local flag = not not var_20_1

		var_20_2.content.visible = flag
		var_20_3.content.visible = flag
		var_20_4.content.visible = flag

		if not flag then
			local frame = var_20_1.frame

			frame = frame or "default"

			local level = var_20_1.level

			level = level or "-"

			if not (var_20_4.content.frame_settings_name ~= frame or var_20_4.content.level == level) then
				self:_update_portrait_frame(frame, level, i)

				var_20_4.content.level = level
			end

			local versus_level = var_20_1.versus_level

			if var_20_5.content.level ~= versus_level then
				self:_update_insignia(versus_level, i)
			end

			local content = var_20_3.content
			local name = var_20_1.name

			name = name or ""
			content.name_text = name
			var_20_2.content.show_token_icon = not var_20_1.vote

			if var_20_1.profile_index ~= 0 then
				local var_20_12 = SPProfiles[var_20_1.profile_index]
				local var_20_13 = var_20_12.careers[var_20_1.career_index]

				var_20_2.content.character_portrait = var_20_13.portrait_image
				var_20_2.content.token_icon = var_20_12.hero_selection_image
			else
				var_20_2.content.character_portrait = "unit_frame_portrait_default"
				var_20_2.content.token_icon = nil
			end

			var_20_2.content.hp_bar.bar_value = var_20_1.health_percentage
			var_20_2.content.ammo_percentage = var_20_1.ammo_percentage
			var_20_3.content.coins_text = string.format("%d", var_20_1.soft_currency)

			local healthkit_consumable = var_20_1.healthkit_consumable

			var_20_2.content.healthkit_slot = not healthkit_consumable and ItemMasterList[healthkit_consumable].hud_icon
			var_20_2.style.healthkit_slot_bg.color = UIUtils.get_color_for_consumable_item(healthkit_consumable)

			local potion_consumable = var_20_1.potion_consumable

			var_20_2.content.potion_slot = not potion_consumable and ItemMasterList[potion_consumable].hud_icon
			var_20_2.style.potion_slot_bg.color = UIUtils.get_color_for_consumable_item(potion_consumable)

			local grenade_consumable = var_20_1.grenade_consumable

			var_20_2.content.grenade_slot = not grenade_consumable and ItemMasterList[grenade_consumable].hud_icon
			var_20_2.style.grenade_slot_bg.color = UIUtils.get_color_for_consumable_item(grenade_consumable)
		end
	end
end

DeusMapUI.set_journey_name = function (arg_21_0, arg_21_1)
	-- function 21
	arg_21_0._widgets_by_name.top_info.content.journey_name_label = arg_21_1 .. "_name"
end

DeusMapUI.set_general_info = function (self, arg_22_1, arg_22_2)
	-- function 22
	local general_info = self._widgets_by_name.general_info

	general_info.content.title = arg_22_1
	general_info.content.description = arg_22_2
end

DeusMapUI._on_resolution_changed = function (self)
	-- function 23
	local _player_data = self._player_data

	if not _player_data then
		self:update_player_data(_player_data)
	end
end

DeusMapUI.update_timer = function (self, arg_24_1, arg_24_2)
	-- function 24
	local general_info = self._widgets_by_name.general_info

	if not arg_24_2 then
		general_info.content.time = arg_24_2
	else
		local format = string.format("%.2d:%.2d", arg_24_1 / 60 % 60, arg_24_1 % 60)

		general_info.content.time = format
	end
end

DeusMapUI.hide_timer = function (arg_25_0)
	-- function 25
	arg_25_0._widgets_by_name.general_info.content.time = ""
end

DeusMapUI.disable_hover_text = function (arg_26_0)
	-- function 26
	arg_26_0._widgets_by_name.node_info.content.visible = false
end

DeusMapUI.set_alpha_multiplier = function (arg_27_0, arg_27_1)
	-- function 27
	arg_27_0._anim_data.alpha_multiplier = arg_27_1
end

DeusMapUI.show_full_screen_rect = function (self)
	-- function 28
	return self:set_full_screen_rect_visibility(true)
end

DeusMapUI.hide_full_screen_rect = function (self)
	-- function 29
	return self:set_full_screen_rect_visibility(false)
end

DeusMapUI.set_full_screen_rect_visibility = function (self, arg_30_1)
	-- function 30
	self._render_full_screen_rect = arg_30_1
end

DeusMapUI.show_content = function (self)
	-- function 31
	self:_set_content_visibility(true)
end

DeusMapUI.hide_content = function (self)
	-- function 32
	self:_set_content_visibility(false)
end

DeusMapUI._set_content_visibility = function (self, arg_33_1)
	-- function 33
	self._render_content = arg_33_1

	local _ui_renderer = self._ui_renderer

	for k, v in pairs(self._widgets_by_name) do
		UIRenderer.set_element_visible(_ui_renderer, v.element, arg_33_1)
	end
end

DeusMapUI.fade_out = function (self, arg_34_1)
	-- function 34
	local _anim_data = self._anim_data

	_anim_data.source_alpha_multiplier = _anim_data.alpha_multiplier
	_anim_data.target_alpha_multiplier = 0
	_anim_data.alpha_multiplier_animation_duration = arg_34_1
	_anim_data.alpha_multiplier_animation_start_time = nil
	_anim_data.alpha_multiplier_animation_end_time = nil
end

DeusMapUI.fade_in = function (self, arg_35_1)
	-- function 35
	local _anim_data = self._anim_data

	_anim_data.source_alpha_multiplier = _anim_data.alpha_multiplier
	_anim_data.target_alpha_multiplier = 1
	_anim_data.alpha_multiplier_animation_duration = arg_35_1
	_anim_data.alpha_multiplier_animation_start_time = nil
	_anim_data.alpha_multiplier_animation_end_time = nil
end

DeusMapUI.destroy = function (arg_36_0)
	-- function 36
	Managers.state.event:unregister("ingame_player_list_enabled", arg_36_0)
end
