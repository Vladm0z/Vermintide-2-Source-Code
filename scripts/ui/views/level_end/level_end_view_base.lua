-- chunkname: @scripts/ui/views/level_end/level_end_view_base.lua

require("scripts/ui/reward_popup/reward_popup_ui")
DLCUtils.require_list("end_view_state")

local var_0_0 = local_require("scripts/ui/views/level_end/level_end_view_base_definitions")
local tbl = {}

for k, v in pairs(DLCSettings) do
	local portrait_materials = v.portrait_materials

	if not portrait_materials then
		for i, v_2 in ipairs(portrait_materials) do
			tbl[#tbl + 1] = v_2
		end
	end
end

local num = 3
local num_2 = 4

LevelEndViewBase = class(LevelEndViewBase)

LevelEndViewBase.init = function (self, arg_1_1)
	-- function 1
	self:setup_world(arg_1_1)
	self:setup_transition_data()

	local game_won = arg_1_1.game_won
	local rewards = arg_1_1.rewards

	self.context = arg_1_1
	self.game_won = game_won
	self.challenge_progression_status = arg_1_1.challenge_progression_status
	self.game_mode_key = arg_1_1.game_mode_key
	self.player_manager = arg_1_1.player_manager
	self.input_manager = arg_1_1.input_manager
	self.ingame_ui = arg_1_1.ingame_ui
	self.profile_synchronizer = arg_1_1.profile_synchronizer
	self.peer_id = arg_1_1.peer_id
	self.local_player_id = arg_1_1.local_player_id
	self.rewards = rewards
	self.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._lobby = arg_1_1.lobby
	self.is_server = arg_1_1.is_server
	self._state_speed_mult = 1
	self._state_machine_complete = false
	self._skip_pressed = false

	if not self.is_server then
		local statistics_db = Managers.player:statistics_db()
		local context = self.context
		local _players_session_score = self._players_session_score

		_players_session_score = _players_session_score or Managers.mechanism:get_players_session_score(statistics_db, self.profile_synchronizer)
		context.players_session_score = _players_session_score
		self._players_session_score = self.context.players_session_score
	end

	if not GameSettingsDevelopment.read_only_backend then
		self.level_up_rewards = self:_get_level_up_rewards()
		self.deed_rewards = self:_get_deed_rewards()
		self.deus_rewards = self:_get_deus_rewards()
		self.keep_decoration_rewards = self:_get_keep_decoration_rewards()
		self.event_rewards = self:_get_event_rewards()
		self.win_track_rewards = self:_get_win_track_rewards()
		self.versus_level_up_rewards = self:_get_versus_level_up_rewards()
	end

	self._reward_presentation_queue = {}
	self.reward_popup = RewardPopupUI:new(arg_1_1)

	local setup_pages = self:setup_pages(game_won, rewards)
	local tbl = {}

	for k, v in pairs(setup_pages) do
		tbl[v] = k
	end

	self._index_by_state_name = setup_pages
	self._state_name_by_index = tbl
	self._state_machine_params = {
		parent = self,
		context = arg_1_1,
		game_won = game_won,
		game_mode_key = self.game_mode_key
	}

	self:setup_camera()
	self:create_ui_elements()

	self._done_peers = {}
	self._wants_reload = {}
	self.waiting_to_start = true
	self._wants_to_exit_to_game = nil
	self._started_exit = nil

	if self._lobby == nil then
		self:left_lobby()
	end
end

LevelEndViewBase.state_machine_completed = function (self)
	-- function 2
	return self._state_machine_complete
end

LevelEndViewBase.setup_transition_data = function (self)
	-- function 3
	self._transition_animations = {}
	self._transition_render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._transition_scenegraph_ui = UISceneGraph.init_scenegraph(var_0_0.transition_scenegraph_definition)
	self._transition_widgets, self._transition_widgets_by_name = UIUtils.create_widgets(var_0_0.transition_widget_definition)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self._transition_ui_animator = UIAnimator:new(self._transition_scenegraph_ui, var_0_0.transition_animations)
end

LevelEndViewBase.trigger_transition = function (self, arg_4_1)
	-- function 4
	self:_cleanup_transitions()

	local tbl = {
		parent = self,
		render_settings = self._transition_render_settings,
		transition_data = arg_4_1
	}
	local _transition_widgets = self._transition_widgets
	local animation_name = arg_4_1.animation_name

	animation_name = animation_name or "default"
	self._transition_animations[#self._transition_animations + 1] = self._transition_ui_animator:start_animation(animation_name, _transition_widgets, var_0_0.transition_scenegraph_definition, tbl)
end

LevelEndViewBase.transition_camera = function (self, arg_5_1)
	-- function 5
	if not arg_5_1.camera_name then
		return
	end

	local var_5_0
	local level_name = arg_5_1.level_name

	level_name = level_name or "levels/end_screen/world"

	local unit_indices = LevelResource.unit_indices(level_name, "units/hub_elements/cutscene_camera/cutscene_camera")

	for k, v in pairs(unit_indices) do
		local unit_data = LevelResource.unit_data(level_name, v)
		local get = DynamicData.get(unit_data, "name")

		if not (not get and get ~= arg_5_1.camera_name) then
			local unit_position = LevelResource.unit_position(level_name, v)
			local unit_rotation = LevelResource.unit_rotation(level_name, v)
			local from_quaternion_position = Matrix4x4.from_quaternion_position(unit_rotation, unit_position)

			var_5_0 = Matrix4x4Box(from_quaternion_position)

			print("Found camera: " .. get)
		end
	end

	self._camera_pose = var_5_0

	self:position_camera()
end

LevelEndViewBase._cleanup_transitions = function (self)
	-- function 6
	for k, v in pairs(self._transition_animations) do
		self._transition_ui_animator:stop_animation(v)
	end

	table.clear(self._transition_animations)
end

LevelEndViewBase._update_transition_fade = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not table.is_empty(self._transition_animations) then
		return
	end

	self:_update_transition_animations(arg_7_1, arg_7_2)
	self:_draw_transition_widgets(arg_7_1, arg_7_2)
end

LevelEndViewBase._draw_transition_widgets = function (self, arg_8_1, arg_8_2)
	-- function 8
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local _transition_scenegraph_ui = self._transition_scenegraph_ui
	local input_manager = self.input_manager
	local _transition_render_settings = self._transition_render_settings
	local input_service = self:input_service()

	UIRenderer.begin_pass(ui_renderer, _transition_scenegraph_ui, input_service, arg_8_1, nil, _transition_render_settings)

	for i, v in ipairs(self._transition_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	UIRenderer.end_pass(ui_renderer)
end

LevelEndViewBase._update_transition_animations = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _transition_ui_animator = self._transition_ui_animator

	_transition_ui_animator:update(arg_9_1)

	for i = #self._transition_animations, 1, -1 do
		local var_9_1 = self._transition_animations[i]

		if not _transition_ui_animator:is_animation_completed(var_9_1) then
			self._transition_animations[i] = nil
		end
	end
end

LevelEndViewBase.enable_chat = function (arg_10_0)
	-- function 10
	return true
end

LevelEndViewBase.start = function (self)
	-- function 11
	self:_activate_viewport()

	self.waiting_to_start = nil
	self.state_auto_change = true

	self:_proceed_to_next_auto_state(1, #self._state_name_by_index)
end

LevelEndViewBase.on_enter = function (self)
	-- function 12
	self._state_speed_mult = 1
end

LevelEndViewBase.on_exit = function (arg_13_0)
	-- function 13
	if not GameSettingsDevelopment.read_only_backend then
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local package_name = LootChestData.chests_by_category[get_difficulty].package_name

		Managers.package:unload(package_name, "global")
	end
end

LevelEndViewBase._vote_to_leave_game = function (self)
	-- function 14
	Managers.state.voting:vote(1)

	self._voted = true
end

LevelEndViewBase.exit_to_game = function (self)
	-- function 15
	self._exit_timer = 2
	self._started_exit = true
end

LevelEndViewBase.done = function (self)
	-- function 16
	return self._wants_to_exit_to_game
end

LevelEndViewBase.setup_pages = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	return {}
end

LevelEndViewBase.create_ui_elements = function (arg_18_0)
	-- function 18
	return
end

LevelEndViewBase._activate_viewport = function (self)
	-- function 19
	local get_viewport_world, var_19_1 = self:get_viewport_world()

	ScriptWorld.activate_viewport(get_viewport_world, var_19_1)
end

LevelEndViewBase.get_world_link_unit = function (self)
	-- function 20
	local str = "levels/end_screen/world"
	local get_viewport_world = self:get_viewport_world()
	local level = ScriptWorld.level(get_viewport_world, str)

	if not level then
		local units = Level.units(level)

		for i, v in ipairs(units) do
			local get_data = Unit.get_data(v, "name")

			if not (not get_data and get_data ~= "loot_chest_spawn") then
				return v
			end
		end
	end
end

LevelEndViewBase.get_viewport_world = function (self)
	-- function 21
	return self._world, self._world_viewport
end

LevelEndViewBase.post_update = function (arg_22_0)
	-- function 22
	return
end

LevelEndViewBase.update = function (self, arg_23_1, arg_23_2)
	-- function 23
	if self.suspended or not self.waiting_for_post_update_enter then
		return
	end

	local _active_camera_shakes = self._active_camera_shakes

	if not _active_camera_shakes then
		for k, v in pairs(_active_camera_shakes) do
			self:_apply_shake_event(k, arg_23_2)
		end
	end

	local input_service = self:input_service()

	if not self._started_force_shutdown then
		self:update_force_shutdown(arg_23_1)
	end

	if not self._started_exit then
		self:_update_exit(arg_23_1)
	end

	if not self.reward_popup then
		self.reward_popup:update(arg_23_1)
	end

	self:_handle_queued_presentations()
	self:_update_transition_fade(arg_23_1, arg_23_2)

	if not self._machine then
		if not self._state_can_speed_up then
			local num_3 = 1
			local get_service = self.input_manager:get_service("end_of_level")
			local get = get_service:get("skip_pressed")

			get = get or get_service:get("confirm_press")
			self._skip_pressed = get

			if get_service:get("confirm_hold", true) or not get_service:get("skip", true) then
				num_3 = num
			end

			local _state_speed_mult = self._state_speed_mult
			local lerp = math.lerp(_state_speed_mult, num_3, num_2 * arg_23_1)
			local clamp = math.clamp(lerp, 1, num)

			arg_23_1 = arg_23_1 * clamp
			self._state_speed_mult = clamp
		end

		self._machine:update(arg_23_1, arg_23_2)

		if not self._new_state_name then
			self:_handle_state_exit()
		elseif not self.state_auto_change then
			self:_handle_state_auto_change()
		elseif not self._page_selector_widget then
			local _is_page_selector_pressed = self:_is_page_selector_pressed()

			if not _is_page_selector_pressed then
				local var_23_9 = self._state_name_by_index[_is_page_selector_pressed]

				self:_request_state_change(var_23_9)
			end
		end
	end
end

LevelEndViewBase.skip_pressed = function (self)
	-- function 24
	return self._skip_pressed
end

LevelEndViewBase.transitioning = function (self)
	-- function 25
	return self.exiting
end

LevelEndViewBase.left_lobby = function (self)
	-- function 26
	self._left_lobby = true
	self._lobby = nil

	if not self._done_peers[Network.peer_id()] then
		self:exit_to_game()
	end
end

LevelEndViewBase.destroy = function (self, arg_27_1)
	-- function 27
	self.ui_animator = nil

	self:_cleanup_transitions()

	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	if not self.reward_popup then
		self.reward_popup:destroy()

		self.reward_popup = nil
	end

	self:_pop_mouse_cursor()
	self:play_sound("play_gui_chestroom_stop")
	self:play_sound("unmute_all_world_sounds")
	self:destroy_world()

	if not arg_27_1 then
		Managers.mechanism:unload_end_screen_resources()
	end
end

LevelEndViewBase.play_sound = function (self, arg_28_1)
	-- function 28
	WwiseWorld.trigger_event(self.wwise_world, arg_28_1)
end

LevelEndViewBase._is_button_pressed = function (arg_29_0, arg_29_1)
	-- function 29
	local button_hotspot = arg_29_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = nil

		return true
	end
end

LevelEndViewBase._is_button_hover_enter = function (arg_30_0, arg_30_1)
	-- function 30
	return arg_30_1.content.button_hotspot.on_hover_enter
end

LevelEndViewBase._is_page_selector_pressed = function (self)
	-- function 31
	local content = self._page_selector_widget.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)
		local var_31_3 = content["hotspot" .. str]

		if not (not var_31_3.on_release and var_31_3.is_selected) then
			return i
		end
	end
end

LevelEndViewBase._set_page_selector_selection = function (self, arg_32_1)
	-- function 32
	local content = self._page_selector_widget.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)

		content["hotspot" .. str].is_selected = arg_32_1 == i
	end
end

LevelEndViewBase._update_exit = function (self, arg_33_1)
	-- function 33
	self._exit_timer = math.max(0, self._exit_timer - arg_33_1)

	if self._exit_timer == 0 then
		self._started_exit = false
		self._wants_to_exit_to_game = true
	end
end

LevelEndViewBase.do_retry = function (arg_34_0)
	-- function 34
	return false
end

LevelEndViewBase._get_level_up_rewards = function (self)
	-- function 35
	local end_of_level_rewards = self.context.rewards.end_of_level_rewards
	local tbl = {}

	for k, v in pairs(end_of_level_rewards) do
		if string.find(k, "level_up_reward") == 1 then
			local split_deprecated = string.split_deprecated(k, ";")
			local var_35_3 = tonumber(split_deprecated[2])
			local var_35_4 = tonumber(split_deprecated[3])

			if not tbl[var_35_3] then
				tbl[var_35_3] = {}
			end

			tbl[var_35_3][var_35_4] = v
		end
	end

	return tbl
end

LevelEndViewBase._get_versus_level_up_rewards = function (self)
	-- function 36
	local end_of_level_rewards = self.context.rewards.end_of_level_rewards
	local tbl = {}

	for k, v in pairs(end_of_level_rewards) do
		if string.find(k, "vs_level_up_reward") == 1 then
			local split_deprecated = string.split_deprecated(k, ";")
			local var_36_3 = tonumber(split_deprecated[2])
			local var_36_4 = tonumber(split_deprecated[3])

			if not tbl[var_36_3] then
				tbl[var_36_3] = {}
			end

			tbl[var_36_3][var_36_4] = v
		end
	end

	return tbl
end

LevelEndViewBase._get_win_track_rewards = function (self)
	-- function 37
	local end_of_level_rewards = self.context.rewards.end_of_level_rewards
	local tbl = {
		start_experience = self.context.rewards.win_track_start_experience,
		item_rewards = {}
	}

	for k, v in pairs(end_of_level_rewards) do
		if string.find(k, "win_track_reward") == 1 then
			local split_deprecated = string.split_deprecated(k, ";")
			local var_37_3 = tonumber(split_deprecated[2])

			tbl.item_rewards[var_37_3] = v
		end
	end

	return tbl
end

LevelEndViewBase._get_deed_rewards = function (self)
	-- function 38
	local end_of_level_rewards = self.context.rewards.end_of_level_rewards
	local tbl = {}

	for k, v in pairs(end_of_level_rewards) do
		if string.find(k, "deed_reward") == 1 then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

LevelEndViewBase._get_event_rewards = function (self)
	-- function 39
	local end_of_level_rewards = self.context.rewards.end_of_level_rewards
	local tbl = {}

	for k, v in pairs(end_of_level_rewards) do
		if not string.find(k, "event_reward") then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

LevelEndViewBase._get_deus_rewards = function (self)
	-- function 40
	local end_of_level_rewards = self.context.rewards.end_of_level_rewards
	local tbl = {}

	for k, v in pairs(end_of_level_rewards) do
		if string.find(k, "deus_reward") == 1 then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

LevelEndViewBase._get_keep_decoration_rewards = function (self)
	-- function 41
	local end_of_level_rewards = self.context.rewards.end_of_level_rewards
	local tbl = {}

	for k, v in pairs(end_of_level_rewards) do
		if string.find(k, "keep_decoration_painting") == 1 then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

LevelEndViewBase._present_reward = function (self, arg_42_1)
	-- function 42
	local reward_popup = self.reward_popup

	if not self:displaying_reward_presentation() then
		local _reward_presentation_queue = self._reward_presentation_queue

		_reward_presentation_queue[#_reward_presentation_queue + 1] = arg_42_1
	else
		reward_popup:display_presentation(arg_42_1)
	end
end

LevelEndViewBase._handle_queued_presentations = function (self)
	-- function 43
	if not (self:_is_reward_presentation_complete() or #self._reward_presentation_queue ~= 0 or self:displaying_reward_presentation()) then
		local _reward_presentation_queue = self._reward_presentation_queue

		if #_reward_presentation_queue > 0 then
			local remove = table.remove(_reward_presentation_queue, 1)

			self:_present_reward(remove)
		else
			self._reward_presentation_done = true
		end
	end
end

LevelEndViewBase.displaying_reward_presentation = function (self)
	-- function 44
	return self.reward_popup:is_presentation_active()
end

LevelEndViewBase._is_reward_presentation_complete = function (self)
	-- function 45
	return self.reward_popup:is_presentation_complete()
end

LevelEndViewBase.reward_presentation_done = function (self)
	-- function 46
	return self._reward_presentation_done
end

LevelEndViewBase.present_level_up = function (self, arg_47_1, arg_47_2)
	-- function 47
	local get_level_unlocks = ProgressionUnlocks.get_level_unlocks(arg_47_2, arg_47_1)
	local var_47_1 = self.level_up_rewards[arg_47_2]
	local flag = not get_level_unlocks and #get_level_unlocks > 0
	local flag_2 = not var_47_1 and #var_47_1 > 0
	local var_47_4

	if flag_2 or not flag then
		var_47_4 = {}
	end

	if not flag then
		for i, v in ipairs(get_level_unlocks) do
			local tbl = {}
			local title = v.title
			local description = v.description

			if not title and not description then
				tbl[#tbl + 1] = {
					widget_type = "description",
					value = {
						Localize(title),
						Localize(description)
					}
				}
			elseif not title then
				tbl[#tbl + 1] = {
					widget_type = "title",
					value = Localize(title)
				}
			elseif not description then
				tbl[#tbl + 1] = {
					widget_type = "title",
					value = Localize(description)
				}
			end

			tbl[#tbl + 1] = {
				value = v.value,
				widget_type = v.unlock_type
			}
			var_47_4[#var_47_4 + 1] = tbl
		end
	end

	if not flag_2 then
		local get_interface = Managers.backend:get_interface("items")

		for i_2, v_2 in ipairs(var_47_1) do
			local tbl_2 = {}
			local backend_id = v_2.backend_id
			local get_item_from_id = get_interface:get_item_from_id(backend_id)
			local item_type = get_interface:get_item_masterlist_data(backend_id).item_type
			local tbl_3 = {}
			local get_ui_information_from_item, var_47_15, var_47_16 = UIUtils.get_ui_information_from_item(get_item_from_id)

			if item_type == "loot_chest" then
				tbl_3[1] = Localize(var_47_15)
				tbl_3[2] = Localize("end_screen_chest_received")
			else
				tbl_3[1] = Localize(item_type)
				tbl_3[2] = Localize("reward_weapon")
			end

			if not tbl_3 then
				tbl_2[#tbl_2 + 1] = {
					widget_type = "description",
					value = tbl_3
				}
			end

			tbl_2[#tbl_2 + 1] = {
				widget_type = "item",
				value = v_2
			}
			var_47_4[#var_47_4 + 1] = tbl_2
		end
	end

	if not var_47_4 then
		self:_present_reward(var_47_4)
	end
end

LevelEndViewBase.present_win_track_reward = function (self, arg_48_1)
	-- function 48
	local get_interface = Managers.backend:get_interface("items")
	local var_48_1 = self.win_track_rewards.item_rewards[arg_48_1]
	local tbl = {}
	local tbl_2 = {}
	local backend_id = var_48_1.backend_id
	local get_item_from_id = get_interface:get_item_from_id(backend_id)
	local item_type = get_interface:get_item_masterlist_data(backend_id).item_type
	local tbl_3 = {}
	local get_ui_information_from_item, var_48_9, var_48_10 = UIUtils.get_ui_information_from_item(get_item_from_id)

	tbl_3[1] = Localize(item_type)
	tbl_3[2] = Localize(var_48_9)

	if not tbl_3 then
		tbl_2[#tbl_2 + 1] = {
			widget_type = "description",
			value = tbl_3
		}
	end

	tbl_2[#tbl_2 + 1] = {
		widget_type = "item",
		value = var_48_1
	}
	tbl[#tbl + 1] = tbl_2

	self:_present_reward(tbl)
end

LevelEndViewBase.present_additional_rewards = function (self)
	-- function 49
	local deed_rewards = self.deed_rewards
	local count = #deed_rewards
	local get_interface = Managers.backend:get_interface("items")

	if count > 0 then
		local tbl = {
			{
				{
					widget_type = "title",
					value = Localize("deed_completed_title")
				}
			}
		}

		for i, v in ipairs(deed_rewards) do
			local tbl_2 = {}
			local backend_id = v.backend_id
			local get_item_from_id = get_interface:get_item_from_id(backend_id)
			local item_type = get_interface:get_item_masterlist_data(backend_id).item_type
			local tbl_3 = {}
			local get_ui_information_from_item, var_49_10, var_49_11 = UIUtils.get_ui_information_from_item(get_item_from_id)

			if item_type == "loot_chest" then
				tbl_3[1] = Localize(var_49_10)
				tbl_3[2] = Localize("end_screen_chest_received")
			else
				tbl_3[1] = Localize(item_type)
				tbl_3[2] = Localize("reward_weapon")
			end

			if not tbl_3 then
				tbl_2[#tbl_2 + 1] = {
					widget_type = "description",
					value = tbl_3
				}
			end

			tbl_2[#tbl_2 + 1] = {
				widget_type = "item",
				value = v
			}
			tbl[#tbl + 1] = tbl_2
		end

		self:_present_reward(tbl)
	end

	local keep_decoration_rewards = self.keep_decoration_rewards

	if #keep_decoration_rewards > 0 then
		local tbl_4 = {}

		for i_2, v_2 in ipairs(keep_decoration_rewards) do
			local keep_decoration_name = v_2.keep_decoration_name
			local var_49_15 = Paintings[keep_decoration_name]
			local display_name = var_49_15.display_name
			local icon = var_49_15.icon
			local tbl_5 = {
				Localize(display_name),
				Localize("end_screen_you_received")
			}
			local tbl_6 = {
				{
					widget_type = "description",
					value = tbl_5
				},
				{
					widget_type = "icon",
					value = icon
				}
			}

			tbl_4[#tbl_4 + 1] = tbl_6
		end

		self:_present_reward(tbl_4)
	end

	local event_rewards = self.event_rewards

	if #event_rewards > 0 then
		local tbl_7 = {}

		for i_3, v_3 in ipairs(event_rewards) do
			local tbl_8 = {}
			local backend_id_2 = v_3.backend_id
			local get_item_from_id_2 = get_interface:get_item_from_id(backend_id_2)
			local tbl_9 = {}
			local get_ui_information_from_item_2, var_49_27, var_49_28 = UIUtils.get_ui_information_from_item(get_item_from_id_2)

			tbl_9[1] = Localize(var_49_27)
			tbl_9[2] = Localize("end_screen_you_received")

			if not tbl_9 then
				tbl_8[#tbl_8 + 1] = {
					widget_type = "description",
					value = tbl_9
				}
			end

			tbl_8[#tbl_8 + 1] = {
				widget_type = "item",
				value = v_3
			}
			tbl_7[#tbl_7 + 1] = tbl_8
		end

		self:_present_reward(tbl_7)
	end

	local deus_rewards = self.deus_rewards

	if #deus_rewards > 0 then
		local tbl_10 = {
			{
				{
					widget_type = "title",
					value = Localize("deus_expedition_completed_title")
				}
			}
		}

		for i_4, v_4 in ipairs(deus_rewards) do
			local tbl_11 = {}
			local backend_id_3 = v_4.backend_id
			local get_item_from_id_3 = get_interface:get_item_from_id(backend_id_3)
			local tbl_12 = {}
			local get_ui_information_from_item_3, var_49_36, var_49_37 = UIUtils.get_ui_information_from_item(get_item_from_id_3)

			tbl_12[1] = Localize(var_49_36)
			tbl_12[2] = Localize("end_screen_you_received")

			if not tbl_12 then
				tbl_11[#tbl_11 + 1] = {
					widget_type = "description",
					value = tbl_12
				}
			end

			tbl_11[#tbl_11 + 1] = {
				widget_type = "item",
				value = v_4
			}
			tbl_10[#tbl_10 + 1] = tbl_11
		end

		self:_present_reward(tbl_10)
	end
end

LevelEndViewBase.present_chest_rewards = function (self)
	-- function 50
	local end_of_level_rewards = self.context.rewards.end_of_level_rewards
	local get_interface = Managers.backend:get_interface("items")
	local chest = end_of_level_rewards.chest

	if not chest then
		local backend_id = chest.backend_id
		local get_item_from_id = get_interface:get_item_from_id(backend_id)
		local get_item_masterlist_data = get_interface:get_item_masterlist_data(backend_id)
		local get_ui_information_from_item, var_50_7, var_50_8 = UIUtils.get_ui_information_from_item(get_item_from_id)
		local name = get_item_masterlist_data.name
		local tbl = {
			{
				{
					widget_type = "description",
					value = {
						Localize(var_50_7),
						Localize("end_screen_chest_received")
					}
				},
				{
					widget_type = "loot_chest",
					value = name
				}
			}
		}

		self:_present_reward(tbl)
	end
end

LevelEndViewBase.wanted_menu_state = function (self)
	-- function 51
	return self._wanted_menu_state
end

LevelEndViewBase.clear_wanted_menu_state = function (self)
	-- function 52
	self._wanted_menu_state = nil
end

LevelEndViewBase._request_state_change = function (self, arg_53_1)
	-- function 53
	local _machine = self._machine

	if not _machine then
		return
	end

	local state = _machine:state()
	local NAME = state.NAME
	local var_53_3
	local flag

	flag = not (self._index_by_state_name[arg_53_1] > self._index_by_state_name[NAME]) or not "left" or "right"

	state:exit(flag)

	self._new_state_name = arg_53_1
end

LevelEndViewBase._handle_state_exit = function (self)
	-- function 54
	local _machine = self._machine

	if not _machine then
		return
	end

	if not _machine:state():exit_done() then
		self:_setup_state_machine(self._new_state_name)

		self._new_state_name = nil
		self._state_speed_mult = 1
	end
end

LevelEndViewBase._setup_state_machine = function (self, arg_55_1, arg_55_2)
	-- function 55
	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	local flag = arg_55_1 or "EndViewStateSummary"
	local var_55_1 = self._index_by_state_name[flag]
	local var_55_2 = rawget(_G, flag)
	local flag_2 = false
	local _state_machine_params = self._state_machine_params

	_state_machine_params.initial_state = arg_55_2
	self._state_can_speed_up = var_55_2.CAN_SPEED_UP

	local var_55_5

	if not arg_55_2 then
		local _current_state_name = self._current_state_name

		var_55_5 = not (var_55_1 > self._index_by_state_name[_current_state_name]) or not "left" or "right"
	end

	_state_machine_params.direction = var_55_5
	self._current_state_name = flag
	self._machine = StateMachine:new(self, var_55_2, _state_machine_params, flag_2)

	self:_show_object_set(flag)
end

LevelEndViewBase._handle_state_auto_change = function (self)
	-- function 56
	local _machine = self._machine

	if not _machine then
		return
	end

	local state = _machine:state()
	local NAME = state.NAME
	local _state_name_by_index = self._state_name_by_index
	local var_56_4 = self._index_by_state_name[NAME]
	local count = #_state_name_by_index

	if not self._next_auto_state_index then
		if not state:exit_done() then
			if count < self._next_auto_state_index then
				if not self._started_exit then
					self:exit_to_game()
				end
			else
				self:_proceed_to_next_auto_state(self._next_auto_state_index, count)
			end
		end
	else
		local var_56_6

		if not self:displaying_reward_presentation() then
			if not state:done() then
				var_56_6 = var_56_4 + 1
			end

			if not var_56_6 then
				state:exit()

				self._next_auto_state_index = var_56_6
			end
		end
	end
end

LevelEndViewBase._proceed_to_next_auto_state = function (self, arg_57_1, arg_57_2)
	-- function 57
	local var_57_0 = self._state_name_by_index[arg_57_1]

	self:_setup_state_machine(var_57_0, true)

	if arg_57_1 == arg_57_2 then
		self:_push_mouse_cursor()

		self._state_machine_complete = true
	end

	self._next_auto_state_index = nil
end

LevelEndViewBase.rpc_signal_end_of_level_done = function (self, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	if not self.is_server then
		local get_members = self._lobby:members():get_members()
		local peer_id = Network.peer_id()

		for i, v in ipairs(get_members) do
			if not (v == arg_58_2 or v == peer_id) then
				local var_58_2 = PEER_ID_TO_CHANNEL[v]

				if not var_58_2 then
					RPC.rpc_signal_end_of_level_done(var_58_2, arg_58_2, arg_58_3)
				end
			end
		end
	end

	self:peer_signaled_done(arg_58_2, arg_58_3)
end

LevelEndViewBase.signal_done = function (self, arg_59_1)
	-- function 59
	if not self._signaled_done then
		return
	end

	if not self._left_lobby then
		if not self.is_server then
			local members = self._lobby:members()

			if not members then
				local get_members = members:get_members()
				local peer_id = Network.peer_id()

				for i, v in ipairs(get_members) do
					if v ~= peer_id then
						local var_59_3 = PEER_ID_TO_CHANNEL[v]

						if not var_59_3 then
							RPC.rpc_signal_end_of_level_done(var_59_3, peer_id, arg_59_1)
						end
					end
				end
			end
		else
			local lobby_host = self._lobby:lobby_host()
			local peer_id_2 = Network.peer_id()
			local var_59_6 = PEER_ID_TO_CHANNEL[lobby_host]

			if not var_59_6 then
				RPC.rpc_signal_end_of_level_done(var_59_6, peer_id_2, arg_59_1)
			end
		end
	end

	self:peer_signaled_done(Network.peer_id(), arg_59_1)
end

LevelEndViewBase.peer_signaled_done = function (self, arg_60_1, arg_60_2)
	-- function 60
	if not self._started_force_shutdown then
		self:start_force_shutdown()
	end

	self._done_peers[arg_60_1] = true
	self._wants_reload[arg_60_1] = arg_60_2
end

LevelEndViewBase.rpc_notify_lobby_joined = function (self, arg_61_1)
	-- function 61
	if not self.is_server then
		local flag = false
		local get_members = self._lobby:members():get_members()
		local peer_id = Network.peer_id()
		local var_61_3 = CHANNEL_TO_PEER_ID[arg_61_1]

		for i, v in ipairs(get_members) do
			if not (v == var_61_3 or v == peer_id) then
				local var_61_4 = PEER_ID_TO_CHANNEL[v]

				RPC.rpc_signal_end_of_level_done(var_61_4, var_61_3, flag)
			end
		end

		self:peer_signaled_done(var_61_3, flag)
	end
end

LevelEndViewBase.start_force_shutdown = function (self)
	-- function 62
	self._started_force_shutdown = true
	self._force_shutdown_timer = 45
	self._force_shutdown_timer_start = self._force_shutdown_timer
end

LevelEndViewBase.get_force_shutdown_time = function (self)
	-- function 63
	return self._force_shutdown_timer, self._force_shutdown_timer_start
end

LevelEndViewBase.is_force_shutdown_active = function (self)
	-- function 64
	return self._started_force_shutdown
end

LevelEndViewBase.update_force_shutdown = function (self, arg_65_1)
	-- function 65
	self._force_shutdown_timer = math.max(0, self._force_shutdown_timer - arg_65_1)

	if not (self._force_shutdown_timer ~= 0 or self._signaled_done) then
		self:signal_done(false)

		self._signaled_done = true
	elseif not self._left_lobby then
		local flag = true

		if not self._lobby:members() then
			local get_members = self._lobby:members():get_members()

			for i, v in ipairs(get_members) do
				if not self._done_peers[v] then
					flag = false

					break
				end
			end
		end

		if not flag then
			self:exit_to_game()
		end
	end

	if not self._started_exit then
		self._started_force_shutdown = false
	end
end

local tbl_2 = {
	persistance = 1,
	fade_out = 0.5,
	amplitude = 0.9,
	seed = 0,
	duration = 0.5,
	fade_in = 0.1,
	octaves = 7
}

LevelEndViewBase.setup_camera = function (self)
	-- function 66
	local var_66_0
	local var_66_1
	local str = "levels/end_screen/world"
	local unit_indices = LevelResource.unit_indices(str, "units/hub_elements/cutscene_camera/cutscene_camera")

	for k, v in pairs(unit_indices) do
		local unit_data = LevelResource.unit_data(str, v)
		local get = DynamicData.get(unit_data, "name")

		if not (not get and get ~= "end_screen_camera") then
			local unit_position = LevelResource.unit_position(str, v)
			local unit_rotation = LevelResource.unit_rotation(str, v)
			local from_quaternion_position = Matrix4x4.from_quaternion_position(unit_rotation, unit_position)

			var_66_0 = Matrix4x4Box(from_quaternion_position)
			var_66_1 = v

			print("Found camera: " .. get)

			break
		end
	end

	self._camera_pose = var_66_0
	self._camera_index = var_66_1

	self:position_camera()
end

LevelEndViewBase.add_camera_shake = function (self, arg_67_1, arg_67_2, arg_67_3)
	-- function 67
	local tbl = {}
	local get_camera_rotation = self:get_camera_rotation()
	local flag = arg_67_1 or tbl_2
	local duration = flag.duration
	local fade_in = flag.fade_in
	local fade_out = flag.fade_out
	local num = (duration or 0) + (fade_in or 0) + (fade_out or 0)

	tbl.shake_settings = flag
	tbl.start_time = arg_67_2
	tbl.end_time = not num and arg_67_2 + num
	tbl.fade_in_time = not fade_in and arg_67_2 + fade_in
	tbl.fade_out_time = not fade_out and tbl.end_time - fade_out

	local seed = flag.seed

	seed = seed or Math.random(1, 100)
	tbl.seed = seed
	tbl.scale = arg_67_3 or 1
	tbl.camera_rotation_boxed = QuaternionBox(get_camera_rotation)
	self._active_camera_shakes = {
		[tbl] = true
	}
end

LevelEndViewBase._apply_shake_event = function (self, arg_68_1, arg_68_2)
	-- function 68
	local _active_camera_shakes = self._active_camera_shakes
	local start_time = arg_68_1.start_time
	local end_time = arg_68_1.end_time
	local fade_in_time = arg_68_1.fade_in_time
	local fade_out_time = arg_68_1.fade_out_time

	if not (not fade_in_time and not (arg_68_2 <= fade_in_time)) then
		arg_68_1.fade_progress = math.clamp((arg_68_2 - start_time) / (fade_in_time - start_time), 0, 1)
	elseif not (not fade_out_time and not (fade_out_time <= arg_68_2)) then
		arg_68_1.fade_progress = math.clamp((end_time - arg_68_2) / (end_time - fade_out_time), 0, 1)
	end

	local num = self:_calculate_perlin_value(arg_68_2 - arg_68_1.start_time, arg_68_1) * arg_68_1.scale
	local num_2 = self:_calculate_perlin_value(arg_68_2 - arg_68_1.start_time + 10, arg_68_1) * arg_68_1.scale
	local unbox = arg_68_1.camera_rotation_boxed:unbox()
	local num_3 = math.pi / 180
	local var_68_9 = Quaternion(Vector3.up(), num_2 * num_3)
	local var_68_10 = Quaternion(Vector3.right(), num * num_3)
	local multiply = Quaternion.multiply(var_68_9, var_68_10)
	local multiply_2 = Quaternion.multiply(unbox, multiply)

	self:set_camera_rotation(multiply_2)

	if not (not arg_68_1.end_time and not (arg_68_2 >= arg_68_1.end_time)) then
		_active_camera_shakes[arg_68_1] = nil
	end
end

LevelEndViewBase._calculate_perlin_value = function (self, arg_69_1, arg_69_2)
	-- function 69
	local num = 0
	local shake_settings = arg_69_2.shake_settings
	local persistance = shake_settings.persistance
	local octaves = shake_settings.octaves

	for i = 0, octaves do
		local num_2 = 2^i
		local num_3 = persistance^i

		num = num + self:_interpolated_noise(arg_69_1 * num_2, arg_69_2) * num_3
	end

	local amplitude = shake_settings.amplitude

	amplitude = amplitude or 1

	local fade_progress = arg_69_2.fade_progress

	fade_progress = fade_progress or 1

	return num * amplitude * fade_progress
end

LevelEndViewBase._interpolated_noise = function (self, arg_70_1, arg_70_2)
	-- function 70
	local floor = math.floor(arg_70_1)
	local num = arg_70_1 - floor
	local _smoothed_noise = self:_smoothed_noise(floor, arg_70_2)
	local _smoothed_noise_2 = self:_smoothed_noise(floor + 1, arg_70_2)

	return math.lerp(_smoothed_noise, _smoothed_noise_2, num)
end

LevelEndViewBase._smoothed_noise = function (self, arg_71_1, arg_71_2)
	-- function 71
	return self:_noise(arg_71_1, arg_71_2) / 2 + self:_noise(arg_71_1 - 1, arg_71_2) / 4 + self:_noise(arg_71_1 + 1, arg_71_2) / 4
end

LevelEndViewBase._noise = function (arg_72_0, arg_72_1, arg_72_2)
	-- function 72
	local next_random, var_72_1 = Math.next_random(arg_72_1 + arg_72_2.seed)
	local next_random_2, var_72_3 = Math.next_random(next_random)

	return var_72_3 * 2 - 1
end

LevelEndViewBase.set_camera_position = function (self, arg_73_1)
	-- function 73
	local get_viewport_world, var_73_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_73_1)

	return ScriptCamera.set_local_position(camera, arg_73_1)
end

LevelEndViewBase.set_camera_rotation = function (self, arg_74_1)
	-- function 74
	local get_viewport_world, var_74_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_74_1)

	return ScriptCamera.set_local_rotation(camera, arg_74_1)
end

LevelEndViewBase.get_camera_position = function (self)
	-- function 75
	local get_viewport_world, var_75_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_75_1)

	return ScriptCamera.position(camera)
end

LevelEndViewBase.get_camera_rotation = function (self)
	-- function 76
	local get_viewport_world, var_76_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_76_1)

	return ScriptCamera.rotation(camera)
end

LevelEndViewBase.position_camera = function (self, arg_77_1, arg_77_2)
	-- function 77
	local get_viewport_world, var_77_1 = self:get_viewport_world()
	local camera = ScriptViewport.camera(var_77_1)
	local flag = arg_77_1 or self._camera_pose:unbox()

	if not flag then
		local flag_2 = arg_77_2 or 65

		Camera.set_vertical_fov(camera, math.degrees_to_radians(flag_2))
		ScriptCamera.set_local_pose(camera, flag)
		ScriptCamera.force_update(get_viewport_world, camera)
	end
end

LevelEndViewBase.set_camera_zoom = function (self, arg_78_1)
	-- function 78
	local unbox = self._camera_pose:unbox()
	local translation = Matrix4x4.translation(unbox)
	local rotation = Matrix4x4.rotation(unbox)
	local num = 0.5 * arg_78_1
	local num_2 = translation + Quaternion.forward(rotation) * num

	self:set_camera_position(num_2)
end

LevelEndViewBase._setup_viewport_camera = function (self)
	-- function 79
	local get_viewport_world, var_79_1 = self:get_viewport_world()
	local unit_by_name = World.unit_by_name(get_viewport_world, "camera")
	local world_rotation = Unit.world_rotation(unit_by_name, 0)
	local num = Unit.world_position(unit_by_name, 0) - Quaternion.forward(world_rotation) * 3
	local camera = ScriptViewport.camera(var_79_1)

	ScriptCamera.set_local_rotation(camera, world_rotation)
	ScriptCamera.set_local_position(camera, num)
end

LevelEndViewBase._push_mouse_cursor = function (self)
	-- function 80
	if not self._cursor_visible then
		ShowCursorStack.show("LevelEndViewBase")

		self._cursor_visible = true
	end
end

LevelEndViewBase._pop_mouse_cursor = function (self)
	-- function 81
	if not self._cursor_visible then
		ShowCursorStack.hide("LevelEndViewBase")

		self._cursor_visible = nil
	end
end

LevelEndViewBase.set_input_manager = function (self, arg_82_1)
	-- function 82
	self.input_manager = arg_82_1

	if not self.reward_popup then
		self.reward_popup:set_input_manager(arg_82_1)
	end

	self._machine:state():set_input_manager(arg_82_1)
end

LevelEndViewBase.input_service = function (self)
	-- function 83
	local FAKE_INPUT_SERVICE

	if not (self:displaying_reward_presentation() or table.is_empty(self._transition_animations)) then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self.input_manager:get_service("end_of_level")

	::label_83_0::

	return FAKE_INPUT_SERVICE
end

LevelEndViewBase.menu_input_service = function (self)
	-- function 84
	local FAKE_INPUT_SERVICE

	if not self.input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_84_0::

	return FAKE_INPUT_SERVICE
end

LevelEndViewBase.set_input_blocked = function (self, arg_85_1)
	-- function 85
	self.input_blocked = arg_85_1
end

LevelEndViewBase.input_enabled = function (arg_86_0)
	-- function 86
	return true
end

LevelEndViewBase.setup_world = function (self, arg_87_1)
	-- function 87
	local create_world, var_87_1 = self:create_world(arg_87_1)
	local spawn_level = self:spawn_level(arg_87_1, create_world)
	local create_viewport = self:create_viewport(arg_87_1, create_world)
	local create_ui_renderer, var_87_5 = self:create_ui_renderer(arg_87_1, create_world, var_87_1)
	local wwise_world = Managers.world:wwise_world(create_world)

	self._world = create_world
	self._level = spawn_level
	self._top_world = var_87_1
	self._world_viewport = create_viewport
	self.ui_renderer = create_ui_renderer
	self.ui_top_renderer = var_87_5
	self.wwise_world = wwise_world
	arg_87_1.world = create_world
	arg_87_1.top_world = var_87_1
	arg_87_1.world_viewport = create_viewport
	arg_87_1.ui_renderer = create_ui_renderer
	arg_87_1.ui_top_renderer = var_87_5
	arg_87_1.wwise_world = wwise_world
end

LevelEndViewBase.destroy_world = function (self)
	-- function 88
	UIRenderer.destroy(self.ui_renderer, self._world)

	self.ui_renderer = nil

	UIRenderer.destroy(self.ui_top_renderer, self._top_world)

	self.ui_top_renderer = nil

	Managers.world:destroy_world(self._world)

	self._world = nil
	self._top_world = nil
end

LevelEndViewBase.get_world_flags = function (arg_89_0)
	-- function 89
	local tbl = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM,
		Application.ENABLE_VOLUMETRICS
	}

	if not Application.user_setting("disable_apex_cloth") then
		table.insert(tbl, Application.DISABLE_APEX_CLOTH)
	else
		table.insert(tbl, Application.APEX_LOD_RESOURCE_BUDGET)

		local insert = table.insert
		local var_89_2 = tbl
		local user_setting = Application.user_setting("apex_lod_resource_budget")

		user_setting = user_setting or ApexClothQuality.high.apex_lod_resource_budget

		insert(var_89_2, user_setting)
	end

	return tbl
end

LevelEndViewBase.create_world = function (self, arg_90_1)
	-- function 90
	local str = "end_screen"
	local str_2 = "environment/ui_end_screen"
	local num = 2
	local get_world_flags = self:get_world_flags()
	local create_world = Managers.world:create_world(str, str_2, nil, num, unpack(get_world_flags))
	local world = Managers.world:world("top_ingame_view")

	return create_world, world
end

LevelEndViewBase.create_viewport = function (arg_91_0, arg_91_1, arg_91_2)
	-- function 91
	local str = "end_screen_viewport"
	local str_2 = "default"
	local num = 2

	return (ScriptWorld.create_viewport(arg_91_2, str, str_2, num))
end

LevelEndViewBase.spawn_level = function (self, arg_92_1, arg_92_2)
	-- function 92
	local str = "levels/end_screen/world"
	local tbl = {}
	local var_92_2
	local var_92_3
	local var_92_4
	local var_92_5
	local flag = false
	local spawn_level = ScriptWorld.spawn_level(arg_92_2, str, tbl, var_92_2, var_92_3, var_92_4, var_92_5, flag)

	Level.spawn_background(spawn_level)
	Level.trigger_level_loaded(spawn_level)
	self:_register_object_sets(spawn_level, str)

	return spawn_level
end

LevelEndViewBase._register_object_sets = function (self, arg_93_1, arg_93_2)
	-- function 93
	local tbl = {}
	local object_set_names = LevelResource.object_set_names(arg_93_2)

	for i, v in ipairs(object_set_names) do
		tbl[v] = {
			set_enabled = true,
			units = LevelResource.unit_indices_in_object_set(arg_93_2, v)
		}
	end

	self._object_sets = tbl

	self:_show_object_set(nil, arg_93_1)
end

LevelEndViewBase._show_object_set = function (self, arg_94_1, arg_94_2)
	-- function 94
	local flag = arg_94_2 or self._level
	local _object_sets = self._object_sets
	local flag_2 = false

	for k, v in pairs(_object_sets) do
		local set_enabled = v.set_enabled

		if not (not set_enabled and k == arg_94_1) then
			local units = v.units

			for i, v_2 in ipairs(units) do
				local unit_by_index = Level.unit_by_index(flag, v_2)

				if not Unit.alive(unit_by_index) then
					Unit.set_unit_visibility(unit_by_index, false)
				end
			end

			v.set_enabled = false
		elseif not (k ~= arg_94_1 or set_enabled) then
			local units_2 = v.units

			for i_2, v_3 in ipairs(units_2) do
				local unit_by_index_2 = Level.unit_by_index(flag, v_3)

				Unit.set_unit_visibility(unit_by_index_2, true)

				if not Unit.has_data(unit_by_index_2, "LevelEditor", "is_gizmo_unit") then
					local get_data = Unit.get_data(unit_by_index_2, "LevelEditor", "is_gizmo_unit")
					local is_a = Unit.is_a(unit_by_index_2, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe")

					if not (not get_data and is_a) then
						Unit.flow_event(unit_by_index_2, "hide_helper_mesh")
						Unit.flow_event(unit_by_index_2, "unit_object_set_enabled")
					end
				end
			end

			v.set_enabled = true
		end

		flag_2 = k == arg_94_1 or flag_2
	end

	if not flag_2 then
		print("Showing object set:", arg_94_1)
	elseif not arg_94_1 then
		print(string.format("Trying to show object set %q - But it didn't exist", arg_94_1))
	end
end

LevelEndViewBase.create_ui_renderer = function (self, arg_95_1, arg_95_2, arg_95_3)
	-- function 95
	local tbl_2 = {
		"material",
		"materials/ui/ui_1080p_hud_atlas_textures",
		"material",
		"materials/ui/ui_1080p_hud_single_textures",
		"material",
		"materials/ui/ui_1080p_menu_atlas_textures",
		"material",
		"materials/ui/ui_1080p_menu_single_textures",
		"material",
		"materials/ui/ui_1080p_common",
		"material",
		"materials/ui/ui_1080p_versus_available_common",
		"material",
		"materials/ui/ui_1080p_versus_rewards_atlas",
		"material",
		"materials/fonts/gw_fonts"
	}
	local get_extra_materials = self.get_extra_materials

	if not get_extra_materials then
		for i, v in ipairs(get_extra_materials) do
			tbl_2[#tbl_2 + 1] = v
		end
	end

	for i_2, v_2 in ipairs(tbl) do
		tbl_2[#tbl_2 + 1] = "material"
		tbl_2[#tbl_2 + 1] = v_2
	end

	local var_95_2 = UIRenderer.create(arg_95_2, unpack(tbl_2))
	local var_95_3 = UIRenderer.create(arg_95_3, unpack(tbl_2))

	return var_95_2, var_95_3
end

LevelEndViewBase.show_team = function (arg_96_0)
	-- function 96
	return
end

LevelEndViewBase.hide_team = function (arg_97_0)
	-- function 97
	return
end
