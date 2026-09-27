-- chunkname: @scripts/ui/views/versus_menu/versus_party_char_selection_view.lua

require("scripts/ui/views/versus_menu/ui_widgets_vs")
require("scripts/ui/views/team_previewer")

local var_0_0 = local_require("scripts/ui/views/versus_menu/versus_party_char_selection_view_definitions")
local carousel = DLCSettings.carousel
local widget_definitions = var_0_0.widget_definitions
local create_progress_marker = var_0_0.create_progress_marker
local generic_input_actions = var_0_0.generic_input_actions
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local other_definitions = var_0_0.other_definitions
local top_detail_widgets_definitions = var_0_0.top_detail_widgets_definitions
local create_player_name_box_widgets = var_0_0.create_player_name_box_widgets
local tbl = {}
local tbl_2 = {
	done = "versus_hero_selection_view_done",
	waiting = "versus_hero_selection_view_waiting",
	picking = "versus_hero_selection_view_picking"
}
local ClientStateLookup = VersusPartySelectionLogicUtility.ClientStateLookup

VersusPartyCharSelectionView = class(VersusPartyCharSelectionView, BaseView)

VersusPartyCharSelectionView.init = function (self, arg_1_1)
	-- function 1
	local player = arg_1_1.player

	self._player = player
	self._peer_id = player:network_id()
	self._local_player_id = player:local_player_id()
	self._unique_id = self._peer_id .. ":" .. self._local_player_id
	self._game_mode = Managers.state.game_mode:game_mode()
	self._ingame_ui = arg_1_1.ingame_ui
	self._profile_synchronizer = arg_1_1.profile_synchronizer

	local network_server = arg_1_1.network_server

	network_server = network_server or arg_1_1.network_client
	self._profile_requester = network_server:profile_requester()
	self._ingame_ui_context = arg_1_1
	self._is_server = arg_1_1.is_server
	self._cam_anim_indx = 1
	self._camera_animations = {}
	self._team_heroes = {}
	self._team_previewer = nil
	self._voip = arg_1_1.voip

	self.super.init(self, arg_1_1, var_0_0)
end

VersusPartyCharSelectionView.on_enter = function (self, arg_2_1)
	-- function 2
	print("[VersusPartyCharSelectionView] Enter character selection view")
	self.super.on_enter(self)

	self._party_selection_logic = Managers.state.game_mode:game_mode():party_selection_logic()

	self._party_selection_logic:set_ingame_ui(self._ingame_ui)

	self._party = Managers.party:get_party_from_player_id(self._peer_id, self._local_player_id)
	self._side = Managers.state.side.side_by_party[self._party]
	self._status = Managers.party:get_player_status(self._peer_id, self._local_player_id)

	self:_setup_roster_widgets_definitions()
	self:_setup_background_world()
	self:_activate_viewport()

	self.render_settings = {
		snap_pixel_positions = true
	}
	self._animations = {}

	local num = UILayer.default + 100

	self._menu_input_description = MenuInputDescriptionUI:new(self._ingame_ui_context, self._ui_top_renderer, self:input_service(), 4, num, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
	self:create_ui_elements(arg_2_1)

	self._params = arg_2_1
	self._prev_timer_value = 0

	self:play_sound("vs_mute_all")
	self:play_sound("menu_versus_character_amb_loop_start")

	if not (not IS_WINDOWS and Window.has_focus()) then
		Window.flash_window(nil, "start", 3)
	end
end

VersusPartyCharSelectionView._setup_roster_widgets_definitions = function (self)
	-- function 3
	local create_hero_roster_widget_defitions, var_3_1 = var_0_0.create_hero_roster_widget_defitions()

	self._hero_group_widgets_defs = create_hero_roster_widget_defitions
	self._hero_roster_detail_widgets_defs = var_3_1
end

VersusPartyCharSelectionView._is_hovering_item = function (self, arg_4_1, arg_4_2)
	-- function 4
	return self._hovered_profile_index ~= arg_4_1 or self._hovered_career_index == arg_4_2
end

VersusPartyCharSelectionView._set_item_hovered = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	arg_5_3 = arg_5_3 or 0
	arg_5_4 = arg_5_4 or 0
	self._hovered_profile_index = arg_5_3
	self._hovered_career_index = arg_5_4

	self._party_selection_logic:sync_hovered_item(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
end

VersusPartyCharSelectionView.on_exit = function (self)
	-- function 6
	print("[VersusPartyCharSelectionView] Exit character selection view")

	if not self._team_previewer then
		self:_destroy_team_previewer()
	end

	if not self._team_world_viewport then
		ScriptWorld.destroy_viewport(self._background_world, self._team_world_viewport_name)

		self._team_world_viewport = nil
		self._team_world_viewport_name = nil
	end

	if not self._background_world then
		self:_destroy_world()
	end

	self.super.on_exit(self)

	if not Managers.state.game_mode:setting("display_parading_view") then
		self:play_sound("vs_unmute_reset_all")
	end

	local event = Managers.state.event

	if not event then
		event:unregister("party_selection_logic_state_set", self)
	end
end

VersusPartyCharSelectionView.post_update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self.ui_animator:update(arg_7_1)
	self:_update_animations(arg_7_1, arg_7_2)
	self:_update_camera(arg_7_2)
	self:_update_player_party(arg_7_1, arg_7_2)
	self:_handle_input(arg_7_1, arg_7_2)

	if not self._team_previewer then
		self:_update_team_previewer(arg_7_1, arg_7_2)
	end
end

VersusPartyCharSelectionView.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._is_spectator then
		self:draw(arg_8_1)
	end

	self.super.update(self, arg_8_1, arg_8_2)
end

VersusPartyCharSelectionView._update_hero_picking_progress = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local picker_list = arg_9_2.picker_list
	local party_id = arg_9_1.party_id

	for k, v in pairs(self._hero_group_widgets_lookup) do
		for k_2, v_2 in pairs(v) do
			v_2.content.taken = nil
			v_2.content.taken_id = nil
		end
	end

	for i4 = 1, arg_9_3 do
		local var_9_2 = self._picking_progress_data[i4]
		local var_9_3 = picker_list[i4]
		local slot_id = var_9_3.slot_id
		local flag = ClientStateLookup[var_9_3.state] == ClientStateLookup.player_picking_character
		local flag_2 = ClientStateLookup[var_9_3.state] >= ClientStateLookup.player_has_picked_character
		local picker_index_is_bot = VersusPartySelectionLogicUtility.picker_index_is_bot(arg_9_2, slot_id)
		local var_9_8
		local var_9_9

		if not picker_index_is_bot then
			if flag_2 or not flag then
				var_9_8, var_9_9 = self._profile_synchronizer:get_bot_profile(party_id, slot_id)
			end
		else
			local peer_id = var_9_3.status.peer_id

			if not peer_id then
				var_9_8, var_9_9 = self._profile_synchronizer:get_persistent_profile_index_reservation(peer_id)
			end
		end

		local var_9_11 = self._hero_group_widgets_lookup[var_9_8]

		if not var_9_11 then
			for k_3, v_3 in pairs(var_9_11) do
				if not flag then
					v_3.content.taken = nil
				elseif not flag_2 then
					v_3.content.taken = true
					v_3.content.has_picked = true
				end

				if k_3 == var_9_9 then
					v_3.taken_id = slot_id
				end
			end
		end

		local flag_3

		flag_3, var_9_9 = var_9_8 or 0, var_9_9 or 0

		if not (var_9_2.profile_index ~= flag_3 or var_9_2.career_index == var_9_9) then
			var_9_2.profile_index = flag_3
			var_9_2.career_index = var_9_9
		end
	end
end

VersusPartyCharSelectionView._update_timer_progress_bar = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not arg_10_1.slider_timer then
		local str = "progress_bar"
		local _ui_scenegraph = self._ui_scenegraph
		local size = scenegraph_definition[str].size
		local slider_timer = arg_10_1.slider_timer
		local time_finished = arg_10_1.time_finished
		local total_slider_time = arg_10_1.total_slider_time
		local num = math.clamp((time_finished - slider_timer) / total_slider_time, 0, 1) * size[1]

		for i = 1, arg_10_3 do
			local var_10_7 = self._picking_progress_data[i]
			local bar_distance = var_10_7.bar_distance
			local flag = var_10_7.step_size > bar_distance - num
			local flag_2 = bar_distance < num
			local point_widget = var_10_7.point_widget

			if not point_widget then
				point_widget.content.highlight = flag
				point_widget.content.done = flag_2
			end

			_ui_scenegraph[str].size[1] = num
		end
	end
end

VersusPartyCharSelectionView._update_background_music = function (self, arg_11_1)
	-- function 11
	if not (self._background_music_triggered or arg_11_1 == "setup") then
		self._background_music_triggered = true

		self:play_sound("menu_versus_character_selection_start")
	end
end

VersusPartyCharSelectionView._update_party_state_startup = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if arg_12_1 ~= "startup" then
		return
	end

	local timer = self._party_selection_logic:timer()

	if not self._start_timer_value then
		self._start_timer_value = timer
	end

	if timer <= self._start_timer_value - GameSettings.transition_fade_out_speed then
		local ceil = math.ceil(timer)

		self._widgets_by_name.countdown_timer.content.text = tostring(ceil)

		if ceil ~= self._prev_timer_value then
			if ceil > 0 then
				local var_12_2 = carousel.versus_character_selection_clock_tick[ceil]

				self:play_sound(var_12_2)
			end

			self._prev_timer_value = ceil
		end
	end
end

VersusPartyCharSelectionView._update_party_state_player_picking_character = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local get_party_data = self._party_selection_logic:get_party_data(self._party_id)

	if not get_party_data then
		return
	end

	local _data_by_pick_index = self._data_by_pick_index

	for i = 1, #_data_by_pick_index do
		local var_13_2 = _data_by_pick_index[i]
		local picker_index_is_bot = VersusPartySelectionLogicUtility.picker_index_is_bot(get_party_data, i)

		if var_13_2.is_bot ~= picker_index_is_bot then
			var_13_2.is_bot = picker_index_is_bot

			self:_update_player_name_box_widget(get_party_data, i)
		end
	end

	if arg_13_1 ~= "player_picking_character" then
		return
	end

	local index_wrapper = math.index_wrapper
	local _next_character_update_idx = self._next_character_update_idx

	_next_character_update_idx = _next_character_update_idx or 0
	self._next_character_update_idx = index_wrapper(_next_character_update_idx + 1, arg_13_3)

	local _next_character_update_idx_2 = self._next_character_update_idx
	local var_13_7 = arg_13_2[_next_character_update_idx_2]
	local local_player_is_picking = self:local_player_is_picking()

	self._widgets_by_name.local_player_picking_frame.content.visible = local_player_is_picking

	local status = var_13_7.status
	local selected_profile_index = status.selected_profile_index
	local selected_career_index = status.selected_career_index
	local var_13_12 = self._data_by_pick_index[_next_character_update_idx_2]

	if not selected_profile_index and not selected_career_index then
		local slot_id = var_13_7.slot_id

		if not (not (arg_13_4.slots_data[slot_id].slot_skin ~= "n/a") and selected_profile_index ~= var_13_12.profile_index or selected_career_index == var_13_12.career_index) then
			self:_spawn_selected_hero(_next_character_update_idx_2)

			var_13_12.profile_index = selected_profile_index
			var_13_12.career_index = selected_career_index

			if _next_character_update_idx_2 == arg_13_3 then
				self:_set_selected_hero_and_career_text(selected_profile_index, selected_career_index)
				self:_update_selcted_career_passive_and_career_skill(selected_profile_index, selected_career_index)
			end
		end
	end

	local _hero_group_widgets_lookup = self._hero_group_widgets_lookup

	if not _hero_group_widgets_lookup then
		for j = 1, #_hero_group_widgets_lookup do
			local var_13_15 = _hero_group_widgets_lookup[j]

			if not var_13_15 then
				for k = 1, #var_13_15 do
					var_13_15[k].content.other_picking = not local_player_is_picking
				end
			end
		end
	end
end

VersusPartyCharSelectionView._setup_local_picker_data = function (self, arg_14_1, arg_14_2)
	-- function 14
	local get_party_from_player_id, var_14_1 = Managers.party:get_party_from_player_id(arg_14_1, arg_14_2)

	if var_14_1 == 0 then
		return
	end

	self._slot_id = Managers.party:get_player_status(arg_14_1, arg_14_2).slot_id
	self._party = get_party_from_player_id
	self._party_id = var_14_1
	self._is_spectator = get_party_from_player_id.name == "spectators"

	local get_party_data = self._party_selection_logic:get_party_data(self._party_id)

	if not get_party_data then
		return
	end

	self._data_by_pick_index = {}

	for i = 1, get_party_from_player_id.num_slots do
		self._data_by_pick_index[i] = {}
	end

	self._party_data = get_party_data

	local picker_list = get_party_data.picker_list

	for j = 1, #picker_list do
		local var_14_4 = picker_list[j]

		if var_14_4.slot_id == self._slot_id then
			self._local_player_data = var_14_4
			self._picker_list_id = j

			break
		end
	end

	if not self._is_spectator then
		self:_setup_character_selection_widgets()
		self:_update_all_player_name_box_widgets()
	end
end

VersusPartyCharSelectionView._update_player_party = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self._party_id then
		local _peer_id = self._peer_id
		local _local_player_id = self._local_player_id

		self:_setup_local_picker_data(_peer_id, _local_player_id)
	end

	local get_party_data = self._party_selection_logic:get_party_data(self._party_id)

	if not get_party_data then
		return
	end

	if not (#self._team_heroes ~= 0 or self._team_previewer) then
		self:_setup_team_heroes()
		self:_setup_team_previewer()
		self:_update_all_player_name_box_widgets()
		self:_set_your_turn_text_position()
		self:_set_top_detail_widgets_visible(false)
		Managers.state.event:register(self, "party_selection_logic_state_set", "on_party_selection_logic_state_set")
		self:on_party_selection_logic_state_set(get_party_data.state, self._party_id, get_party_data.current_picker_index)
	end

	local _party = self._party
	local state = get_party_data.state
	local num_slots = _party.num_slots
	local picker_list = get_party_data.picker_list
	local current_picker_index = get_party_data.current_picker_index
	local local_player_is_picking = self:local_player_is_picking()

	self:_update_background_music(state)
	self:_update_party_state_startup(state, picker_list, _party)
	self:_update_party_state_player_picking_character(state, picker_list, current_picker_index, _party)
	self:_update_hero_picking_progress(_party, get_party_data, num_slots)
	self:_update_timer_progress_bar(get_party_data, local_player_is_picking, num_slots)
end

VersusPartyCharSelectionView._update_roster_widgets_animations = function (self, arg_16_1, arg_16_2)
	-- function 16
	local get_party_data = self._party_selection_logic:get_party_data(self._party_id)

	if not get_party_data then
		return
	end

	local state = get_party_data.state
	local var_16_2 = get_party_data.picker_list[self._picker_list_id]
	local flag = false
	local _hero_group_widgets_lookup = self._hero_group_widgets_lookup

	if not _hero_group_widgets_lookup then
		for i = 1, #_hero_group_widgets_lookup do
			local var_16_5 = _hero_group_widgets_lookup[i]

			if not var_16_5 then
				for j = 1, #var_16_5 do
					local var_16_6 = var_16_5[j]
					local content = var_16_6.content
					local style = var_16_6.style
					local offset = var_16_6.offset
					local button_hotspot = content.button_hotspot
					local taken = content.taken
					local locked = content.locked
					local other_picking = content.other_picking
					local gamepad_selected = content.gamepad_selected
					local flag_2 = (button_hotspot.is_hover or not gamepad_selected or not not other_picking) and not locked
					local profile_index = content.profile_index
					local career_index = content.career_index
					local _is_item_selected = self:_is_item_selected(profile_index, career_index)
					local hover_progress = button_hotspot.hover_progress

					hover_progress = hover_progress or 0

					local selection_progress = button_hotspot.selection_progress

					selection_progress = selection_progress or 0

					local inactive_progress = button_hotspot.inactive_progress

					inactive_progress = inactive_progress or 0

					local taken_progress = button_hotspot.taken_progress

					taken_progress = taken_progress or 0
					content.party_state = state

					if state == "startup" then
						style.local_player_selected_texture.color[1] = 0
						style.other_player_selected_texture.color[1] = 0
						flag = true
					elseif not (state == "startup" or state == "parading") then
						flag = var_16_2.state == "player_has_picked_character" or not locked or not _is_item_selected

						local num = 15
						local num_2 = 5

						if not flag_2 then
							hover_progress = math.min(hover_progress + arg_16_1 * num, 1)
						else
							hover_progress = math.max(hover_progress - arg_16_1 * num, 0)
						end

						if not flag then
							inactive_progress = math.min(inactive_progress + arg_16_1 * num, 1)
						else
							inactive_progress = math.max(inactive_progress - arg_16_1 * num, 0)
						end

						if not _is_item_selected then
							selection_progress = math.min(selection_progress + arg_16_1 * num_2, 1)
						else
							selection_progress = 0
						end

						if not taken then
							taken_progress = math.min(taken_progress + arg_16_1 * num, 1)
						else
							taken_progress = math.max(taken_progress - arg_16_1 * num, 0)
						end

						local easeCubic = math.easeCubic(selection_progress)
						local flag_3

						flag_3 = not (hover_progress > 0) or not 10 or 0
						offset[3] = flag_3

						local num_3 = 55 + 200 * (1 - taken_progress)

						style.portrait.color = {
							255,
							num_3,
							num_3,
							num_3
						}

						local color = style.local_player_selected_texture.color
						local num_4

						if not other_picking then
							num_4 = 255 * easeCubic

							if not num_4 then
								-- Nothing
							end
						end

						num_4 = 0

						::label_16_0::

						color[1] = num_4

						local color_2 = style.other_player_selected_texture.color
						local num_5

						if not other_picking then
							num_5 = 255 * easeCubic

							if not num_5 then
								-- Nothing
							end
						end

						num_5 = 0

						::label_16_1::

						color_2[1] = num_5

						for k, v in pairs(style) do
							local default_size = v.default_size

							if not default_size then
								local size = v.size

								if not size then
									size = v.texture_size
									size = size or v.area_size
								end

								local num_6 = 0

								if not (k == "local_player_selected_texture" or k ~= "other_player_selected_texture") then
									num_6 = -0.5 + 0.5 * easeCubic
								end

								local num_7 = 0.2 + num_6
								local ceil = math.ceil(default_size[1] * num_7)
								local ceil_2 = math.ceil(default_size[2] * num_7)
								local num_8 = ceil * hover_progress
								local num_9 = ceil_2 * hover_progress

								size[1] = default_size[1] + num_8
								size[2] = default_size[2] + num_9

								local default_offset = v.default_offset

								if not default_offset then
									local offset_2 = v.offset

									offset_2[1] = default_offset[1] - num_8 * 0.5
									offset_2[2] = default_offset[2] - num_9 * 0.5
								end
							end
						end
					end

					style.portrait.saturated = flag
					button_hotspot.taken_progress = taken_progress
					button_hotspot.hover_progress = hover_progress
					button_hotspot.inactive_progress = inactive_progress
					button_hotspot.selection_progress = selection_progress
				end
			end
		end
	end
end

VersusPartyCharSelectionView._get_player_name_by_status = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local var_17_0

	if not arg_17_1 then
		if not arg_17_1.is_player then
			local peer_id = arg_17_1.peer_id
			local local_player_id = arg_17_1.local_player_id
			local player = Managers.player:player(peer_id, local_player_id)

			if not player then
				var_17_0 = player:name() .. " "
			end
		elseif not arg_17_1.is_bot then
			var_17_0 = "Bot " .. arg_17_1.slot_id
		end
	end

	var_17_0 = var_17_0 or "Bot " .. arg_17_2

	return var_17_0
end

VersusPartyCharSelectionView._handle_input = function (self, arg_18_1, arg_18_2)
	-- function 18
	if not self._party_selection_logic:get_party_data(self._party_id) then
		return
	end

	if not Managers.input:is_device_active("gamepad") then
		self:_handle_gamepad_selection()
	else
		self:_handle_mouse_selection()
		self:_handle_hover_sync()
	end
end

VersusPartyCharSelectionView._handle_hover_sync = function (self)
	-- function 19
	local _hero_group_widgets_lookup = self._hero_group_widgets_lookup

	if not _hero_group_widgets_lookup then
		for i = 1, #_hero_group_widgets_lookup do
			local var_19_1 = _hero_group_widgets_lookup[i]

			if not var_19_1 then
				for j = 1, #var_19_1 do
					local var_19_2 = var_19_1[j]
					local _is_item_hovered_by_other = self:_is_item_hovered_by_other(i, j)

					var_19_2.content.hovered_by_other = _is_item_hovered_by_other
				end
			end
		end
	end
end

VersusPartyCharSelectionView.draw = function (self, arg_20_1)
	-- function 20
	if not self._party_id then
		return
	end

	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local input_service = self:input_service()
	local render_settings = self.render_settings
	local state = self._party_selection_logic:get_party_data(self._party_id).state
	local alpha_multiplier = render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, input_service, arg_20_1, nil, render_settings)
	self:_draw_widgets(self._other_widgets, render_settings, _ui_top_renderer, alpha_multiplier)

	if state ~= "closing" then
		self:_draw_widgets(self._hero_group_widgets, render_settings, _ui_top_renderer, alpha_multiplier)
		self:_draw_widgets(self._hero_group_detail_widgets, render_settings, _ui_top_renderer, alpha_multiplier)
	end

	self:_draw_widgets(self._top_detail_widgets, render_settings, _ui_top_renderer, alpha_multiplier)
	self:_draw_widgets(self._player_name_box_widgets, render_settings, _ui_top_renderer, alpha_multiplier)
	UIRenderer.end_pass(_ui_top_renderer)

	render_settings.alpha_multiplier = alpha_multiplier

	local is_device_active = Managers.input:is_device_active("gamepad")

	if not self._menu_input_description and not is_device_active then
		self._menu_input_description:draw(_ui_top_renderer, arg_20_1)
	end
end

VersusPartyCharSelectionView._draw_widgets = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	if not arg_21_1 then
		return
	end

	for i, v in ipairs(arg_21_1) do
		local alpha_multiplier = v.alpha_multiplier

		alpha_multiplier = alpha_multiplier or arg_21_4
		arg_21_2.alpha_multiplier = alpha_multiplier

		UIRenderer.draw_widget(arg_21_3, v)
	end
end

VersusPartyCharSelectionView._update_animations = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	self:_update_roster_widgets_animations(arg_22_1, arg_22_2)
end

VersusPartyCharSelectionView._start_transition_animation = function (self, arg_23_1, arg_23_2)
	-- function 23
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_23_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_23_1] = start_animation
end

VersusPartyCharSelectionView.create_ui_elements = function (self, arg_24_1)
	-- function 24
	if not self._team_previewer then
		self:_destroy_team_previewer()
	end

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local _widgets_by_name = self._widgets_by_name

	self._other_widgets = {}
	self._player_name_box_widgets = {}
	self._top_detail_widgets = {}

	UIUtils.create_widgets(widget_definitions, self._other_widgets, _widgets_by_name)
	UIUtils.create_widgets(other_definitions, self._other_widgets, _widgets_by_name)
	UIUtils.create_widgets(top_detail_widgets_definitions, self._top_detail_widgets, _widgets_by_name)

	local var_24_1 = create_player_name_box_widgets()

	UIUtils.create_widgets(var_24_1, self._player_name_box_widgets, _widgets_by_name)
	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	self:_setup_picking_progress_bar(4)

	_widgets_by_name.local_player_picking_frame.content.visible = false

	self._menu_input_description:set_input_description(generic_input_actions.default)
end

VersusPartyCharSelectionView._setup_character_selection_widgets = function (self, arg_25_1)
	-- function 25
	local tbl = {}

	self._hero_group_widgets = tbl

	local tbl_2 = {}

	self._hero_group_detail_widgets = tbl_2

	local tbl_3 = {}

	self._hero_group_widgets_lookup = tbl_3

	self:_setup_hero_party_selection_widgets(tbl, tbl_2, tbl_3)
end

VersusPartyCharSelectionView._update_all_player_name_box_widgets = function (self)
	-- function 26
	local get_party_data = self._party_selection_logic:get_party_data(self._party_id)

	if not get_party_data then
		return
	end

	local picker_list = get_party_data.picker_list

	for i = 1, #picker_list do
		self:_update_player_name_box_widget(get_party_data, i)
	end
end

VersusPartyCharSelectionView._update_player_name_box_widget = function (self, arg_27_1, arg_27_2)
	-- function 27
	local var_27_0 = arg_27_1.picker_list[arg_27_2]
	local status = var_27_0.status

	if not status then
		local player = status.player
		local content = self._player_name_box_widgets[arg_27_2].content
		local _set_player_name

		if not player then
			_set_player_name = self:_set_player_name(player)

			if not _set_player_name then
				-- Nothing
			end
		end

		_set_player_name = "BOT"

		::label_27_0::

		local var_27_5

		if var_27_0.state == "player_picking_character" then
			if arg_27_2 == arg_27_1.current_picker_index then
				var_27_5 = Localize(tbl_2.picking)
			end
		elseif var_27_0.state == "player_has_picked_character" then
			var_27_5 = Localize(tbl_2.done)
		else
			var_27_5 = Localize(tbl_2.waiting)
		end

		local str = "{#color(%d,%d,%d,%d)}%s {#reset()} %s"
		local flag = self._picker_list_id == arg_27_2
		local get_color_table_with_alpha

		if not flag then
			get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_picking", 255)

			if not get_color_table_with_alpha then
				-- Nothing
			end
		end

		get_color_table_with_alpha = Colors.get_color_table_with_alpha("other_player_picking", 255)

		::label_27_1::

		content.player_name = string.format(str, get_color_table_with_alpha[2], get_color_table_with_alpha[3], get_color_table_with_alpha[4], get_color_table_with_alpha[1], _set_player_name, var_27_5)
		content.is_player = player ~= nil
		content.peer_id = status.peer_id
		content.is_local_player = flag
	end
end

VersusPartyCharSelectionView._setup_hero_party_selection_widgets = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local get_interface = Managers.backend:get_interface("hero_attributes")
	local tbl = {}
	local tbl_2 = {}

	for i, v in ipairs(ProfilePriority) do
		tbl[v] = SPProfiles[v]
		tbl_2[#tbl_2 + 1] = v
	end

	self._profile_indices = tbl_2

	local count = #tbl_2
	local num = 0

	for k, v_2 in pairs(tbl_2) do
		local var_28_5 = tbl[v_2]
		local display_name = var_28_5.display_name
		local get = get_interface:get(display_name, "experience")

		get = get or 0

		local get_level = ExperienceSettings.get_level(get)
		local careers = var_28_5.careers
		local num_2 = 0

		arg_28_3[v_2] = {}

		local var_28_11 = self._hero_roster_detail_widgets_defs[k]
		local var_28_12 = UIWidget.init(var_28_11)

		var_28_12.content.hero_name = Localize(var_28_5.ingame_short_display_name)
		var_28_12.content.profile_index = v_2
		arg_28_2[#arg_28_2 + 1] = var_28_12

		for i4 = 1, #careers do
			local var_28_13 = careers[i4]
			local var_28_14 = self._hero_group_widgets_defs[k][i4]
			local var_28_15 = UIWidget.init(var_28_14)

			arg_28_1[#arg_28_1 + 1] = var_28_15
			arg_28_3[v_2][i4] = var_28_15

			local content = var_28_15.content

			content.group_index = k
			content.career_index = i4

			if not var_28_13 and not var_28_13:override_available_for_mechanism() then
				content.career_settings = var_28_13
				content.profile_index = v_2
				content.portrait = var_28_13.picking_image
				content.locked = not var_28_13:is_unlocked_function(display_name, get_level)
				content.taken = false
			else
				content.career_settings = var_28_13
				content.profile_index = v_2
				content.portrait = var_28_13.picking_image
				content.locked = true
			end

			var_28_15.style.local_player_select_frame.color = Colors.get_color_table_with_alpha("local_player_picking", 255)
			num_2 = num_2 + 1
		end

		num = math.max(num, num_2)
	end

	assert(not (count <= 5) or num <= 4, "Too many rows or columns in VersusPartyCharSelectionView")

	self._num_max_hero_rows = count
	self._num_max_hero_columns = num
end

VersusPartyCharSelectionView._is_item_selected = function (self, arg_29_1, arg_29_2)
	-- function 29
	local get_party_data = self._party_selection_logic:get_party_data(self._party_id)

	if not get_party_data then
		return false
	end

	local current_picker_index = get_party_data.current_picker_index

	for i = 1, current_picker_index do
		local var_29_2 = self._data_by_pick_index[i]

		if not (var_29_2.profile_index ~= arg_29_1 or var_29_2.career_index ~= arg_29_2) then
			return true
		end
	end

	return false
end

VersusPartyCharSelectionView.local_player_is_picking = function (self)
	-- function 30
	return self:_is_slot_picking(self._picker_list_id)
end

VersusPartyCharSelectionView._is_slot_picking = function (self, arg_31_1)
	-- function 31
	local get_party_data = self._party_selection_logic:get_party_data(self._party_id)

	if not get_party_data then
		return
	end

	local current_picker_index = get_party_data.current_picker_index

	if current_picker_index <= 0 then
		return false
	end

	return current_picker_index == arg_31_1
end

VersusPartyCharSelectionView._local_player_has_picked = function (self)
	-- function 32
	return self:_has_slot_picked(self:_get_local_player_picker_index())
end

VersusPartyCharSelectionView._has_slot_picked = function (self, arg_33_1)
	-- function 33
	local get_party_data = self._party_selection_logic:get_party_data(self._party_id)

	if not get_party_data then
		return false
	end

	local current_picker_index = get_party_data.current_picker_index

	if current_picker_index <= 0 then
		return false
	end

	return arg_33_1 < current_picker_index
end

VersusPartyCharSelectionView._get_local_player_picker_index = function (self)
	-- function 34
	return self._picker_list_id
end

VersusPartyCharSelectionView._handle_gamepad_selection = function (self)
	-- function 35
	local local_player_is_picking = self:local_player_is_picking()
	local _gamepad_selected_index = self._gamepad_selected_index

	_gamepad_selected_index = _gamepad_selected_index or 1

	local input_service = self:input_service()

	if not input_service:get("move_right") then
		self:play_sound("Play_hud_hover")

		if _gamepad_selected_index < #self._hero_group_widgets then
			_gamepad_selected_index = _gamepad_selected_index + 1
		end
	elseif not input_service:get("move_left") then
		self:play_sound("Play_hud_hover")

		if _gamepad_selected_index > 1 then
			_gamepad_selected_index = _gamepad_selected_index - 1
		end
	elseif not input_service:get("cycle_next") then
		self:play_sound("Play_hud_hover")

		if _gamepad_selected_index < #self._hero_group_widgets - 3 then
			_gamepad_selected_index = bit.bor(_gamepad_selected_index - 1, 3) + 1 + 1
		end
	elseif not (not input_service:get("cycle_previous") and not (_gamepad_selected_index > 4)) then
		_gamepad_selected_index = math.max(0, bit.bor(_gamepad_selected_index - 1, 3) + 1 - 4) + -3
	end

	if _gamepad_selected_index ~= self._gamepad_selected_index then
		local var_35_3 = self._hero_group_widgets[_gamepad_selected_index]
		local _hero_group_widgets = self._hero_group_widgets
		local _gamepad_selected_index_2 = self._gamepad_selected_index

		_gamepad_selected_index_2 = _gamepad_selected_index_2 or 1

		local var_35_6 = _hero_group_widgets[_gamepad_selected_index_2]

		var_35_3.content.gamepad_selected = true

		if not self._gamepad_selected_index then
			var_35_6.content.gamepad_selected = false
		end
	end

	if not input_service:get("confirm") and not local_player_is_picking then
		local content = self._hero_group_widgets[_gamepad_selected_index].content

		if not (content.taken or content.other_picking or content.locked) then
			local profile_index = content.profile_index
			local career_index = content.career_index

			self._party_selection_logic:select_character(profile_index, career_index)
			self:play_sound("play_gui_hero_select_career_click")
		end
	end

	self._gamepad_selected_index = _gamepad_selected_index
end

VersusPartyCharSelectionView._reset_selection = function (self)
	-- function 36
	if not self._gamepad_selected_index then
		return
	end

	self._hero_group_widgets[self._gamepad_selected_index].content.gamepad_selected = false
end

VersusPartyCharSelectionView._handle_mouse_selection = function (self)
	-- function 37
	self:_reset_selection()

	local local_player_is_picking = self:local_player_is_picking()
	local _hero_group_widgets = self._hero_group_widgets
	local _num_max_hero_rows = self._num_max_hero_rows
	local _num_max_hero_columns = self._num_max_hero_columns
	local var_37_4
	local var_37_5
	local _get_local_player_picker_index = self:_get_local_player_picker_index()

	if not _get_local_player_picker_index then
		var_37_4 = self._data_by_pick_index[_get_local_player_picker_index].profile_index
		var_37_5 = self._data_by_pick_index[_get_local_player_picker_index].career_index
	end

	local flag = false
	local var_37_8
	local var_37_9
	local num = 1

	for i = 1, _num_max_hero_rows do
		for j = 1, _num_max_hero_columns do
			local var_37_11 = _hero_group_widgets[num]

			if not var_37_11 then
				local content = var_37_11.content
				local profile_index = content.profile_index
				local career_index = content.career_index
				local button_hotspot = content.button_hotspot

				if not self:_local_player_has_picked() then
					if not button_hotspot.on_hover_enter then
						var_37_8 = self._profile_indices[i]
						var_37_9 = j
						flag = true
					elseif not ((flag or not self:_is_hovering_item(self._profile_indices[i], j)) and button_hotspot.is_hover) then
						flag = true
					end
				end

				if not ((profile_index ~= var_37_4 or career_index ~= var_37_5) and content.taken or content.other_picking or content.locked) then
					if not button_hotspot.on_hover_enter then
						self:play_sound("Play_hud_hover")
					end

					if not button_hotspot.on_pressed and not local_player_is_picking then
						local var_37_16 = self._profile_indices[i]
						local var_37_17 = j

						self._party_selection_logic:select_character(var_37_16, var_37_17)
						self:play_sound("play_gui_hero_select_career_click")

						return
					end
				end
			end

			num = num + 1
		end
	end

	if not flag then
		self:_set_item_hovered(self._peer_id, self._local_player_id, var_37_8, var_37_9)
	end

	self:_update_mute_buttons()
end

VersusPartyCharSelectionView._setup_picking_progress_bar = function (self, arg_38_1)
	-- function 38
	local _other_widgets = self._other_widgets
	local str = "progress_point"
	local var_38_2 = create_progress_marker(str)
	local num = 5
	local str_2 = "progress_bar_rect"
	local var_38_5 = scenegraph_definition[str_2].size[1]
	local var_38_6 = arg_38_1
	local ceil = math.ceil(var_38_5 / var_38_6)
	local num_2 = -2
	local tbl = {}

	for i = 1, var_38_6 do
		num_2 = num_2 + ceil + num / 2

		local var_38_10

		if i < var_38_6 then
			var_38_10 = UIWidget.init(var_38_2)
			_other_widgets[#_other_widgets + 1] = var_38_10
			var_38_10.offset[1] = math.ceil(num_2)
		end

		tbl[i] = {
			point_widget = var_38_10,
			bar_distance = num_2,
			step_size = ceil,
			bar_distance_fraction = num_2 / var_38_5
		}
	end

	self._picking_progress_data = tbl

	local _ui_scenegraph = self._ui_scenegraph
	local size = _ui_scenegraph.progress_bar.size
	local size_2 = _ui_scenegraph.progress_bar_passive.size

	size[1] = 0
	size_2[1] = 0
end

VersusPartyCharSelectionView._start_step_transtion_animation = function (self, arg_39_1)
	-- function 39
	local var_39_0 = tbl
	local tbl_2 = {
		self = self
	}
	local start_animation = self.ui_animator:start_animation(arg_39_1, var_39_0, scenegraph_definition, tbl_2)

	self._animations[arg_39_1] = start_animation
end

VersusPartyCharSelectionView._start_widget_animation = function (self, arg_40_1, arg_40_2)
	-- function 40
	local var_40_0 = tbl
	local start_animation = self.ui_animator:start_animation(arg_40_1, arg_40_2, scenegraph_definition, var_40_0)

	self._animations[arg_40_1] = start_animation
end

VersusPartyCharSelectionView._set_top_detail_widgets_visible = function (self, arg_41_1)
	-- function 41
	local flag

	flag = not arg_41_1 and 1 and 0

	for i, v in ipairs(self._top_detail_widgets) do
		v.alpha_multiplier = flag
	end
end

VersusPartyCharSelectionView._is_item_hovered_by_other = function (self, arg_42_1, arg_42_2)
	-- function 42
	local _party = self._party
	local get_party_data = self._party_selection_logic:get_party_data(self._party_id)
	local num_slots = _party.num_slots
	local picker_list = get_party_data.picker_list

	for i = 1, num_slots do
		local status = picker_list[i].status
		local hovered_profile_index = status.hovered_profile_index

		hovered_profile_index = hovered_profile_index or 0

		local hovered_career_index = status.hovered_career_index

		hovered_career_index = hovered_career_index or 0

		if not (hovered_profile_index ~= arg_42_1 or hovered_career_index ~= arg_42_2) then
			if status.slot_id == self._slot_id or not self:_has_slot_picked(i) then
				return false, nil
			else
				return true, i
			end
		end
	end

	return false, nil
end

VersusPartyCharSelectionView._set_player_name = function (arg_43_0, arg_43_1)
	-- function 43
	local name = arg_43_1:name()

	if Utf8.length(name) > 18 then
		name = string.sub(name, 1, 18) .. "..."
	end

	return name
end

VersusPartyCharSelectionView._set_your_turn_text_position = function (self)
	-- function 44
	self._widgets_by_name.your_turn_indicator_text.scenegraph_id = "player_name_box_" .. self._picker_list_id
end

VersusPartyCharSelectionView._set_selected_hero_and_career_text = function (self, arg_45_1, arg_45_2)
	-- function 45
	local hero_career_name_text = self._widgets_by_name.hero_career_name_text
	local str = "%s - %s"
	local var_45_2 = SPProfiles[arg_45_1]
	local var_45_3 = Localize(var_45_2.ingame_short_display_name)
	local var_45_4 = var_45_2.careers[arg_45_2]
	local var_45_5 = Localize(var_45_4.display_name)

	hero_career_name_text.content.text = Utf8.upper(string.format(str, var_45_3, var_45_5))
end

VersusPartyCharSelectionView._set_current_picker_text = function (self, arg_46_1)
	-- function 46
	local player_picking_text = self._widgets_by_name.player_picking_text

	if not (arg_46_1 == self._picker_list_id) then
		local get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_picking", 255)

		player_picking_text.content.text = string.format(Localize("versus_hero_selection_view_local_player_picking"), get_color_table_with_alpha[2], get_color_table_with_alpha[3], get_color_table_with_alpha[4], get_color_table_with_alpha[1])
	else
		local player = self._party_selection_logic:get_party_data(self._party_id).picker_list[arg_46_1].status.player
		local name

		if not player then
			name = player:name()

			if not name then
				-- Nothing
			end
		end

		name = "BOT"

		::label_46_0::

		local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("other_player_picking", 255)

		player_picking_text.content.text = string.format(Localize("versus_hero_selection_view_other_player_picking"), get_color_table_with_alpha_2[2], get_color_table_with_alpha_2[3], get_color_table_with_alpha_2[4], get_color_table_with_alpha_2[1], name)
	end
end

VersusPartyCharSelectionView._update_selcted_career_passive_and_career_skill = function (self, arg_47_1, arg_47_2)
	-- function 47
	local passive_skill = self._widgets_by_name.passive_skill
	local career_skill = self._widgets_by_name.career_skill
	local hero_career_name_text = self._widgets_by_name.hero_career_name_text
	local content = passive_skill.content
	local content_2 = career_skill.content
	local var_47_5 = SPProfiles[arg_47_1].careers[arg_47_2]
	local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(var_47_5)
	local get_ability_data_by_career = CareerUtils.get_ability_data_by_career(var_47_5, 1)
	local icon = get_ability_data_by_career.icon
	local var_47_9 = Localize(get_ability_data_by_career.display_name)
	local var_47_10 = Localize("ability")
	local icon_2 = get_passive_ability_by_career.icon
	local var_47_12 = Localize(get_passive_ability_by_career.display_name)
	local var_47_13 = Localize("hero_view_passive_ability")

	content_2.skill_icon = icon
	content_2.skill_type = var_47_10
	content_2.skill_name = var_47_9
	content.skill_icon = icon_2
	content.skill_type = var_47_13
	content.skill_name = var_47_12

	local text = hero_career_name_text.style.text
	local text_2 = hero_career_name_text.content.text
	local get_text_width = UIUtils.get_text_width(self._ui_renderer, text, text_2)
	local skill_type = career_skill.style.skill_type
	local get_text_width_2 = UIUtils.get_text_width(self._ui_renderer, skill_type, var_47_10)
	local skill_name = career_skill.style.skill_name
	local get_text_width_3 = UIUtils.get_text_width(self._ui_renderer, skill_name, var_47_9)
	local num

	if 85 + get_text_width_2 > 150 then
		num = 85 + get_text_width_2

		if not num then
			-- Nothing
		end
	end

	num = 200

	do
		local num_2
	end

	::label_47_0::

	if 85 + get_text_width_3 > 150 then
		num_2 = 85 + get_text_width_3

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = 200

	::label_47_1::

	local var_47_23

	if num_2 < num then
		var_47_23 = num
	else
		var_47_23 = num_2
	end

	local num_3 = get_text_width + 25
	local num_4 = get_text_width + 25 + var_47_23 + 25

	passive_skill.offset[1] = num_4
	career_skill.offset[1] = num_3
end

VersusPartyCharSelectionView._setup_world = function (self)
	-- function 48
	if not self._background_world then
		self:_destroy_world()
	end

	local str = "versus_char_selection"
	local str_2 = "environment/ui_end_screen"
	local num = 2
	local tbl = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM,
		Application.ENABLE_VOLUMETRICS
	}
	local create_world = Managers.world:create_world(str, str_2, nil, num, unpack(tbl))

	World.set_data(create_world, "avoid_blend", true)

	local world = Managers.world:world("top_ingame_view")

	return create_world, world
end

VersusPartyCharSelectionView._create_viewport = function (self, arg_49_1)
	-- function 49
	local str = "versus_char_selection_ui"
	local str_2 = "default"
	local num = 960
	local create_viewport = ScriptWorld.create_viewport(arg_49_1, str, str_2, num)

	self._team_world_viewport_name = str

	return create_viewport
end

VersusPartyCharSelectionView._spawn_level = function (arg_50_0, arg_50_1)
	-- function 50
	local str = "levels/carousel_podium/world"
	local tbl = {}
	local var_50_2
	local var_50_3
	local var_50_4
	local var_50_5
	local flag = false
	local spawn_level = ScriptWorld.spawn_level(arg_50_1, str, tbl, var_50_2, var_50_3, var_50_4, var_50_5, flag)

	Level.spawn_background(spawn_level)
	Level.trigger_level_loaded(spawn_level)

	return spawn_level
end

local str = "levels/carousel_podium/world"

VersusPartyCharSelectionView._setup_background_world = function (self)
	-- function 51
	local _setup_world, var_51_1 = self:_setup_world()
	local _spawn_level = self:_spawn_level(_setup_world)
	local _create_viewport = self:_create_viewport(_setup_world)

	self._background_world = _setup_world
	self._top_world = var_51_1
	self._team_world_viewport = _create_viewport
	self._level = _spawn_level

	self:_setup_camera_nodes_data(_spawn_level)
	self:_setup_initial_camera(_setup_world, _create_viewport)
	Level.trigger_event(_spawn_level, "disable_character_select_lights")
end

VersusPartyCharSelectionView._get_heroes_spawn_locations = function (self, arg_52_1)
	-- function 52
	local flag

	flag = arg_52_1 ~= self._party_id or not "character_slot_0" or "character_slot_enemy_0"

	local str_2 = "units/hub_elements/versus_podium_character_spawn"
	local unit_indices = LevelResource.unit_indices(str, str_2)
	local tbl = {}

	for i = 1, 4 do
		for k, v in pairs(unit_indices) do
			local unit_data = LevelResource.unit_data(str, v)
			local get = DynamicData.get(unit_data, "name")

			if not (not get and get ~= flag .. i) then
				local unit_position = LevelResource.unit_position(str, v)
				local to_elements, var_52_8, var_52_9 = Vector3.to_elements(unit_position)
				local tbl_2 = {
					to_elements,
					var_52_8,
					var_52_9
				}

				tbl[#tbl + 1] = tbl_2
			end
		end
	end

	fassert(#tbl ~= 0, "[VersusPartyCharSelectionView:_get_heroes_spawn_locations], No hero locations have been found. Check if unit: %s is present in level: %s and has the script data varaible \"name\" set to the correct name.", str_2, str)

	return tbl
end

VersusPartyCharSelectionView._activate_viewport = function (self)
	-- function 53
	ScriptWorld.activate_viewport(self._background_world, self._team_world_viewport)
end

VersusPartyCharSelectionView.set_camera_position = function (self, arg_54_1)
	-- function 54
	local camera = ScriptViewport.camera(self._team_world_viewport)

	return ScriptCamera.set_local_position(camera, arg_54_1)
end

VersusPartyCharSelectionView.set_camera_rotation = function (self, arg_55_1)
	-- function 55
	local camera = ScriptViewport.camera(self._team_world_viewport)

	ScriptCamera.set_local_rotation(camera, arg_55_1)

	local _get_viewport_world = self:_get_viewport_world()

	ScriptCamera.force_update(_get_viewport_world, camera)
end

VersusPartyCharSelectionView._setup_initial_camera = function (self, arg_56_1, arg_56_2)
	-- function 56
	local initial_camera = self._cameras.initial_camera
	local camera = ScriptViewport.camera(arg_56_2)

	self._camera = camera

	local vertical_fov = Camera.vertical_fov(initial_camera.camera)

	Camera.set_vertical_fov(camera, vertical_fov)
	ScriptCamera.set_local_pose(camera, initial_camera.camera_pose:unbox())
	ScriptCamera.force_update(arg_56_1, camera)
end

VersusPartyCharSelectionView._setup_camera_nodes_data = function (self, arg_57_1)
	-- function 57
	local tbl = {}
	local flow_variable = Level.flow_variable(arg_57_1, "initial_camera")
	local flow_variable_2 = Level.flow_variable(arg_57_1, "parading_position_01")
	local flow_variable_3 = Level.flow_variable(arg_57_1, "parading_position_02")
	local var_57_4 = Matrix4x4Box(Unit.local_pose(flow_variable, 0))
	local var_57_5 = Matrix4x4Box(Unit.local_pose(flow_variable_2, 0))
	local var_57_6 = Matrix4x4Box(Unit.local_pose(flow_variable_3, 0))
	local camera = Unit.camera(flow_variable, "camera")
	local camera_2 = Unit.camera(flow_variable_2, "camera")
	local camera_3 = Unit.camera(flow_variable_3, "camera")

	self._inital_camera_position = Vector3Box(Unit.local_position(flow_variable, 0))
	tbl.initial_camera = {
		camera_unit = flow_variable,
		camera_pose = var_57_4,
		camera = camera
	}
	tbl.parading_camera_01 = {
		camera_unit = flow_variable_2,
		camera_pose = var_57_5,
		camera = camera_2
	}
	tbl.parading_camera_02 = {
		camera_unit = flow_variable_3,
		camera_pose = var_57_6,
		camera = camera_3
	}
	self._cameras = tbl
end

VersusPartyCharSelectionView._destroy_world = function (self)
	-- function 58
	Managers.world:destroy_world(self._background_world)

	self._background_world = nil
	self._top_world = nil
end

VersusPartyCharSelectionView._setup_team_previewer = function (self, arg_59_1)
	-- function 59
	if not self._team_previewer then
		return
	end

	arg_59_1 = arg_59_1 or false
	self._team_previewer = TeamPreviewer:new(self._ingame_ui_context, self._background_world, self._team_world_viewport)

	local _team_heroes = self._team_heroes
	local _get_heroes_spawn_locations = self:_get_heroes_spawn_locations(self._party_id)

	self._team_previewer:setup_team(_team_heroes, _get_heroes_spawn_locations, arg_59_1)

	self._hero_locations = _get_heroes_spawn_locations
end

VersusPartyCharSelectionView._setup_team_heroes = function (self)
	-- function 60
	local picker_list = self._party_selection_logic:get_party_data(self._party_id).picker_list
	local _team_heroes = self._team_heroes

	table.clear(_team_heroes)

	for i, v in ipairs(picker_list) do
		local _get_hero_previewer_data = self:_get_hero_previewer_data(v, self._party)

		_team_heroes[#_team_heroes + 1] = _get_hero_previewer_data or true
	end
end

VersusPartyCharSelectionView._get_hero_previewer_data = function (arg_61_0, arg_61_1, arg_61_2)
	-- function 61
	local status = arg_61_1.status
	local selected_profile_index = status.selected_profile_index
	local selected_career_index = status.selected_career_index
	local var_61_3 = SPProfiles[selected_profile_index]

	if not (not var_61_3 and var_61_3.affiliation ~= "dark_pact") then
		return nil
	end

	local slot_id = arg_61_1.slot_id
	local var_61_5 = arg_61_2.slots_data[slot_id]

	if not var_61_3 then
		local var_61_6 = var_61_3.careers[selected_career_index]
		local versus_preview_animation = var_61_6.versus_preview_animation

		versus_preview_animation = versus_preview_animation or var_61_6.preview_animation

		local preview_wield_slot = var_61_6.preview_wield_slot
		local profile_name = var_61_6.profile_name
		local slot_hat = var_61_5.slot_hat
		local tbl = {
			var_61_6.preview_items[1],
			{
				item_name = slot_hat == "n/a" or not slot_hat or var_61_6.preview_items[2].item_name
			}
		}
		local slot_skin

		if var_61_5.slot_skin ~= "n/a" then
			slot_skin = var_61_5.slot_skin

			if not slot_skin then
				-- Nothing
			end
		end

		slot_skin = var_61_6.base_skin

		::label_61_0::

		return {
			profile_index = selected_profile_index,
			career_index = selected_career_index,
			skin_name = slot_skin,
			hero_name = profile_name,
			weapon_slot = preview_wield_slot,
			preview_items = tbl,
			preview_animation = versus_preview_animation
		}
	end

	return nil
end

VersusPartyCharSelectionView._update_team_previewer = function (self, arg_62_1, arg_62_2)
	-- function 62
	local _team_previewer = self._team_previewer

	if not _team_previewer then
		_team_previewer:update(arg_62_1, arg_62_2)
		_team_previewer:post_update(arg_62_1, arg_62_2)
	end
end

VersusPartyCharSelectionView._destroy_team_previewer = function (self)
	-- function 63
	if not self._team_previewer then
		self._team_previewer:on_exit()

		self._team_previewer = nil
	end
end

VersusPartyCharSelectionView._spawn_selected_hero = function (self, arg_64_1)
	-- function 64
	local var_64_0 = self._party_selection_logic:get_party_data(self._party_id).picker_list[arg_64_1]
	local _get_hero_previewer_data = self:_get_hero_previewer_data(var_64_0, self._party)

	if not _get_hero_previewer_data then
		local get_hero_previewer = self._team_previewer:get_hero_previewer(arg_64_1)

		self._team_previewer:_spawn_hero(get_hero_previewer, _get_hero_previewer_data)

		self._team_heroes[arg_64_1] = _get_hero_previewer_data
	end
end

VersusPartyCharSelectionView._play_selected_hero_sound = function (self, arg_65_1, arg_65_2)
	-- function 65
	if not arg_65_2 and not arg_65_1 then
		local display_name = SPProfiles[arg_65_2].careers[arg_65_1].display_name
		local str = "menu_versus_character_selection_" .. display_name

		self:play_sound(str)
	end
end

VersusPartyCharSelectionView._level_flow_event = function (self, arg_66_1)
	-- function 66
	local _level = self._level

	Level.trigger_event(_level, arg_66_1)
end

local function fn(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6)
	-- function 67
	local var_67_0
	local num = arg_67_5 - arg_67_4
	local num_2

	if num <= 0.001 then
		num_2 = 1
	else
		local clamp = math.clamp((arg_67_6 - arg_67_4) / num, 0, 1)

		num_2 = (3 - 2 * clamp) * clamp^2
	end

	local lerp = Matrix4x4.lerp(arg_67_2, arg_67_3, num_2)

	ScriptCamera.set_local_pose(arg_67_0, lerp)
	Camera.set_vertical_fov(arg_67_0, arg_67_1)
end

VersusPartyCharSelectionView._update_camera = function (self, arg_68_1)
	-- function 68
	if not self._camera_anim_id then
		return
	end

	local _camera = self._camera
	local var_68_1 = self._camera_animations[self._camera_anim_id]

	if not (not var_68_1.animation_end_time and not (arg_68_1 > var_68_1.animation_end_time)) then
		self._camera_animations[self._camera_anim_id] = nil
		self._camera_anim_id = nil

		return
	end

	if not var_68_1.animation_start_time then
		var_68_1.animation_start_time = arg_68_1
		var_68_1.animation_end_time = arg_68_1 + 2
	end

	fn(_camera, var_68_1.fov, var_68_1.source_pose:unbox(), var_68_1.target_pose:unbox(), var_68_1.animation_start_time, var_68_1.animation_end_time, arg_68_1)
	ScriptCamera.force_update(self._background_world, _camera)
end

VersusPartyCharSelectionView._set_on_selection_complete_camera_animation = function (self)
	-- function 69
	local tbl = {
		fov = Camera.vertical_fov(self._cameras.initial_camera.camera),
		source_pose = self._cameras.initial_camera.camera_pose,
		target_pose = self._cameras.parading_camera_01.camera_pose
	}
	local _cam_anim_indx = self._cam_anim_indx

	self._camera_anim_id = _cam_anim_indx
	self._camera_animations[_cam_anim_indx] = tbl
	self._cam_anim_indx = self._cam_anim_indx + 1
end

VersusPartyCharSelectionView._muted_peer_id = function (self, arg_70_1)
	-- function 70
	if not IS_XB1 then
		if not Managers.voice_chat then
			return Managers.voice_chat:is_peer_muted(arg_70_1)
		else
			return false
		end
	else
		return self._voip:peer_muted(arg_70_1)
	end
end

VersusPartyCharSelectionView._ignore_voice_message_from_peer_id = function (self, arg_71_1)
	-- function 71
	if not IS_XB1 then
		if not Managers.voice_chat then
			Managers.voice_chat:mute_peer(arg_71_1)
		end
	else
		self._voip:mute_member(arg_71_1)
	end
end

VersusPartyCharSelectionView._remove_ignore_voice_message_from_peer_id = function (self, arg_72_1)
	-- function 72
	if not IS_XB1 then
		if not Managers.voice_chat then
			Managers.voice_chat:unmute_peer(arg_72_1)
		end
	else
		self._voip:unmute_member(arg_72_1)
	end
end

VersusPartyCharSelectionView._update_mute_buttons = function (self)
	-- function 73
	for i = 1, #self._player_name_box_widgets do
		local var_73_0 = self._player_name_box_widgets[i]
		local content = var_73_0.content
		local peer_id = content.peer_id

		if not peer_id and not UIUtils.is_button_pressed(var_73_0) then
			if not self:_muted_peer_id(peer_id) then
				self:_remove_ignore_voice_message_from_peer_id(peer_id)

				content.muted = false
			else
				self:_ignore_voice_message_from_peer_id(peer_id)

				content.muted = true
			end
		end
	end
end

VersusPartyCharSelectionView.on_party_selection_logic_state_set = function (self, arg_74_1, arg_74_2, arg_74_3)
	-- function 74
	if self._party_id ~= arg_74_2 then
		return
	end

	if arg_74_1 == "startup" then
		-- Nothing
	elseif arg_74_1 == "player_picking_character" then
		if not self._initial_selection_transition_done then
			self._initial_selection_transition_done = true

			self:_start_step_transtion_animation("transition_to_selection")
		end

		self:_start_widget_animation("name_box_fade_to_black", self._player_name_box_widgets[arg_74_3])
		self:_level_flow_event("chr_" .. arg_74_3 .. "_selected")
		self:_set_current_picker_text(arg_74_3)
		self:_update_all_player_name_box_widgets()

		if not self:local_player_is_picking() then
			self:play_sound("menu_versus_character_selection_your_turn_indicator")
			self:play_sound("menu_versus_character_selection_meter_start")
		end
	elseif arg_74_1 == "player_has_picked_character" then
		self:play_sound("menu_versus_character_selection_locked")

		if not self:local_player_is_picking() then
			self:play_sound("menu_versus_character_selection_meter_stop")
		end

		self:_play_selected_hero_sound(self._data_by_pick_index[arg_74_3].career_index, self._data_by_pick_index[arg_74_3].profile_index)
		self:_start_widget_animation("name_box_fade_to_gray", self._player_name_box_widgets[arg_74_3])
		self:_level_flow_event("chr_" .. arg_74_3 .. "_unselected")
	elseif arg_74_1 == "parading" then
		self:_level_flow_event("vs_team_heroes_selected")
		self:play_sound("menu_versus_character_selection_start_game_buildup")

		self._prev_timer_value = 0

		self:_set_on_selection_complete_camera_animation()
		self:_start_step_transtion_animation("transition_to_team_parading")
		self:play_sound("Play_menu_versus_parading_start_transition")
	end
end
