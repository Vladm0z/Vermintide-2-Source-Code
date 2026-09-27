-- chunkname: @scripts/ui/views/level_end/level_end_view_v2.lua

require("scripts/ui/views/level_end/level_end_view_base")
require("scripts/ui/views/level_end/states/end_view_state_parading")
require("scripts/ui/views/level_end/states/end_view_state_summary")
require("scripts/ui/views/level_end/states/end_view_state_score")
require("scripts/ui/views/level_end/states/end_view_state_chest")
require("scripts/ui/reward_popup/reward_popup_ui")

local var_0_0 = local_require("scripts/ui/views/level_end/level_end_view_v2_definitions")
local widgets_definitions = var_0_0.widgets_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local animations = var_0_0.animations
local generic_input_actions = var_0_0.generic_input_actions
local weave_widget_definitions = var_0_0.weave_widget_definitions
local flag = false
local flag_2 = false
local testify = script_data.testify

testify = not testify and require("scripts/ui/views/level_end/level_end_view_testify")

local num = 0.07
local num_2 = 1.36
local num_3 = -1.5
local num_4 = 0.15
local num_5 = 0
local tbl = {
	{
		{
			num,
			num_3,
			num_5
		}
	},
	{
		{
			num + num_2 * 0.5,
			num_3 + num_4 * 0.5,
			num_5
		},
		{
			num + num_2 * -0.5,
			num_3 + num_4 * -0.5,
			num_5
		}
	},
	{
		{
			num + num_2 * 1,
			num_3 + num_4 * 1,
			num_5
		},
		{
			num + num_2 * 0,
			num_3 + num_4 * 0,
			num_5
		},
		{
			num + num_2 * -1,
			num_3 + num_4 * -1,
			num_5
		}
	},
	{
		{
			num + num_2 * 1,
			num_3 + num_4 * 1.5,
			num_5
		},
		{
			num + num_2 * 0.25,
			num_3 + num_4 * 0.25 + 0.5,
			num_5
		},
		{
			num + num_2 * -0.25,
			num_3 + num_4 * -0.25 + 0.5,
			num_5
		},
		{
			num + num_2 * -1,
			num_3 + num_4 * -1.5,
			num_5
		}
	}
}

LevelEndView = class(LevelEndView, LevelEndViewBase)

LevelEndView.init = function (self, arg_1_1)
	-- function 1
	self._weave_render_settings = {
		snap_pixel_positions = true
	}
	self._team_heroes = {}
	self._team_previewer = nil

	local tbl = {}

	if not arg_1_1.players_session_score then
		for k in pairs(arg_1_1.players_session_score) do
			tbl[k] = true
		end
	end

	self._peers_with_score = tbl

	LevelEndView.super.init(self, arg_1_1)
	Managers.transition:force_fade_in()
end

LevelEndView.start = function (self)
	-- function 2
	LevelEndView.super.start(self)
	self:play_sound("play_gui_chestroom_start")

	self._playing_music = nil

	local flag

	flag = not self.game_won and "Play_won_music" and "Play_lost_music"
	self._start_music_event = flag

	local flag_2

	flag_2 = not self.game_won and "Stop_won_music" and "Stop_lost_music"
	self._stop_music_event = flag_2
end

LevelEndView.setup_pages = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0

	if not GameSettingsDevelopment.read_only_backend then
		var_3_0 = self:_setup_pages_untrusted()
	elseif not arg_3_1 then
		var_3_0 = self:_setup_pages_victory(arg_3_2)
	else
		var_3_0 = self:_setup_pages_defeat(arg_3_2)
	end

	return var_3_0
end

LevelEndView._setup_pages_untrusted = function (arg_4_0)
	-- function 4
	return {
		EndViewStateScore = 1
	}
end

LevelEndView._setup_pages_victory = function (arg_5_0, arg_5_1)
	-- function 5
	local tbl = {}
	local chest = arg_5_1.end_of_level_rewards.chest

	tbl.EndViewStateParading = table.size(tbl) + 1
	tbl.EndViewStateSummary = table.size(tbl) + 1

	if not chest then
		tbl.EndViewStateChest = table.size(tbl) + 1
	end

	tbl.EndViewStateScore = table.size(tbl) + 1

	return tbl
end

LevelEndView.show_team = function (self)
	-- function 6
	if not self._team_previewer then
		self:_destroy_team_previewer()
	end

	self:_setup_team_heroes(self.context.players_session_score)

	if not self.game_won then
		self:_setup_team_previewer()
	end
end

LevelEndView.hide_team = function (self)
	-- function 7
	if not self._team_previewer then
		self:_destroy_team_previewer()
	end
end

LevelEndView.loading_complete = function (self)
	-- function 8
	local _team_previewer = self._team_previewer

	_team_previewer = not _team_previewer and self._team_previewer:loading_done()

	return _team_previewer
end

LevelEndView._setup_pages_defeat = function (arg_9_0)
	-- function 9
	local tbl = {}

	tbl.EndViewStateSummary = table.size(tbl) + 1
	tbl.EndViewStateScore = table.size(tbl) + 1

	return tbl
end

LevelEndView.create_ui_elements = function (self)
	-- function 10
	self.ui_animations = {}
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._static_widgets = {}
	self._dynamic_widgets = {
		timer_text = UIWidget.init(widgets_definitions.timer_text),
		timer_bg = UIWidget.init(widgets_definitions.timer_bg)
	}

	if not flag_2 then
		self._page_selector_widget = UIWidget.init(UIWidgets.create_page_dot_selector("page_selector", #self._state_name_by_index))
	end

	local create_default_button = UIWidgets.create_default_button
	local str = "retry_button"
	local size = scenegraph_definition.retry_button.size
	local var_10_3
	local var_10_4
	local Localize = Localize
	local flag

	flag = not self.game_won and "button_replay" and "button_retry"

	local var_10_7 = create_default_button(str, size, var_10_3, var_10_4, Localize(flag), 32, nil, nil, nil, true)

	self._retry_button_widget = UIWidget.init(var_10_7)
	self._ready_button_widget = UIWidget.init(widgets_definitions.ready_button)
	self._retry_checkboxes_widget = UIWidget.init(widgets_definitions.retry_checkboxes)
	self._reload_checkboxes_widget = UIWidget.init(widgets_definitions.reload_checkboxes)
	self._weave_widgets = {}

	for k, v in pairs(weave_widget_definitions) do
		self._weave_widgets[k] = UIWidget.init(v)
	end

	self._dead_space_filler_mask = UIWidget.init(widgets_definitions.dead_space_filler_mask)
	self._dead_space_filler_unmask = UIWidget.init(widgets_definitions.dead_space_filler_unmask)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animations)

	local get_service = self.input_manager:get_service("end_of_level")

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_renderer, get_service, 5, 10, generic_input_actions.default)

	self._menu_input_description:set_input_description(nil)

	self.active = true
	self._ready_button_widget.scenegraph_id = "ready_button_alone"
end

LevelEndView._setup_team_heroes = function (self, arg_11_1)
	-- function 11
	local tbl = {}

	for k in pairs(arg_11_1) do
		table.insert(tbl, k)
	end

	table.sort(tbl)

	local size = table.size(arg_11_1)
	local _team_heroes = self._team_heroes
	local _peers_with_score = self._peers_with_score

	table.clear(_team_heroes)
	table.clear(_peers_with_score)

	for j = 1, size do
		local var_11_4 = tbl[j]

		if not var_11_4 then
			local var_11_5 = arg_11_1[var_11_4]

			_team_heroes[#_team_heroes + 1] = self:_get_hero_from_score(var_11_5)
			_peers_with_score[var_11_4] = true
		end
	end
end

LevelEndView._get_hero_from_score = function (self, arg_12_1)
	-- function 12
	local profile_index = arg_12_1.profile_index
	local career_index = arg_12_1.career_index
	local var_12_2 = SPProfiles[profile_index].careers[career_index]
	local var_12_3
	local var_12_4
	local var_12_5
	local weapon_pose = arg_12_1.weapon_pose

	weapon_pose = not weapon_pose and arg_12_1.weapon_pose.item_name

	if not weapon_pose then
		local var_12_7 = ItemMasterList[weapon_pose]

		if not var_12_7 then
			local skin_name = arg_12_1.weapon_pose.skin_name
			local parent = var_12_7.parent
			local var_12_10 = rawget(ItemMasterList, parent)

			if not var_12_10 then
				var_12_4 = {
					item_name = parent,
					skin_name = skin_name
				}
				var_12_5 = var_12_10.slot_type
				var_12_3 = var_12_7.data.anim_event
			end
		end
	end

	local var_12_11 = self
	local _verify_weapon_data = self._verify_weapon_data
	local var_12_13 = arg_12_1

	if not var_12_5 then
		-- Nothing
	end

	do
		local preview_wield_slot
	end

	::label_12_0::

	if not arg_12_1.weapon then
		preview_wield_slot = var_12_2.preview_wield_slot

		if not preview_wield_slot then
			-- Nothing
		end
	end

	preview_wield_slot = nil

	::label_12_1::

	local var_12_15, var_12_16, var_12_17 = _verify_weapon_data(var_12_11, var_12_13, preview_wield_slot, var_12_4 or arg_12_1.weapon, var_12_3)

	return {
		profile_index = profile_index,
		career_index = career_index,
		hero_name = var_12_2.profile_name,
		skin_name = arg_12_1.hero_skin,
		weapon_slot = var_12_15,
		weapon_pose_anim_event = var_12_17,
		preview_items = {
			arg_12_1.hat,
			var_12_16
		}
	}
end

local tbl_2 = {}

LevelEndView._verify_weapon_data = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local profile_index = arg_13_1.profile_index
	local career_index = arg_13_1.career_index
	local var_13_2 = SPProfiles[profile_index].careers[career_index]
	local name = var_13_2.name
	local preview_wield_slot = var_13_2.preview_wield_slot
	local tbl = {
		item_name = var_13_2.preview_items[1].item_name
	}
	local var_13_6

	if not (not arg_13_3 and not arg_13_3 and arg_13_3.item_name) then
		print(string.format("[LevelEndView] No preview weapon was set - using DEFAULT for %s with peer_id: %s", arg_13_1.name, arg_13_1.peer_id))

		return preview_wield_slot, tbl, var_13_6
	end

	local get_interface = Managers.backend:get_interface("common")
	local var_13_8 = rawget(ItemMasterList, arg_13_3.item_name)

	if not get_interface:can_wield(name, var_13_8) then
		print(string.format("[LevelEndView] %q is not wieldable by %s  - using DEFAULT for %s with peer_id: %s", arg_13_3.item_name, name, arg_13_1.name, arg_13_1.peer_id))

		return preview_wield_slot, tbl, var_13_6
	end

	if var_13_8.slot_type ~= arg_13_2 then
		return preview_wield_slot, tbl, var_13_6
	end

	local var_13_9 = arg_13_2

	tbl.item_name = arg_13_3.item_name

	local flag = false
	local skin_name = arg_13_3.skin_name

	if not skin_name then
		local skin_combination_table = var_13_8.skin_combination_table
		local var_13_13 = WeaponSkins.skin_combinations[skin_combination_table]

		var_13_13 = var_13_13 or tbl_2

		for k, v in pairs(var_13_13) do
			for i, v_2 in ipairs(v) do
				if v_2 == skin_name then
					flag = true

					break
				end
			end

			if not flag then
				break
			end
		end

		tbl.skin_name = not flag and skin_name
	end

	local gsub = string.gsub(var_13_8.name, "^vs_", "")

	if var_13_8.rarity == "magic" then
		gsub = string.gsub(gsub, "_magic_0%d$", "")
	end

	local str = "resource_packages/pose_packages/" .. gsub

	if not Application.can_get("package", str) then
		var_13_6 = arg_13_4
	else
		var_13_6 = nil
	end

	return var_13_9, tbl, var_13_6
end

LevelEndView._destroy_team_previewer = function (self)
	-- function 14
	if not self._team_previewer then
		self._team_previewer:on_exit()

		self._team_previewer = nil
	end
end

LevelEndView._update_team_previewer = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _team_previewer = self._team_previewer

	if not _team_previewer then
		_team_previewer:update(arg_15_1, arg_15_2)
		_team_previewer:post_update(arg_15_1, arg_15_2)
	end
end

LevelEndView._setup_team_previewer = function (self)
	-- function 16
	if not self._team_previewer then
		self:_destroy_team_previewer()
	end

	local get_viewport_world, var_16_1 = self:get_viewport_world()

	self._team_previewer = TeamPreviewer:new(self.context, get_viewport_world, var_16_1)

	local _team_heroes = self._team_heroes
	local count = #_team_heroes
	local _gather_hero_locations = self:_gather_hero_locations()

	self._team_previewer:setup_team(_team_heroes, _gather_hero_locations)
end

LevelEndView._handle_global_shader_flags = function (self)
	-- function 17
	local flag = false

	for k, v in pairs(self._team_heroes) do
		local profile_index = v.profile_index
		local career_index = v.career_index

		if SPProfiles[profile_index].careers[career_index].name == "bw_necromancer" then
			flag = true

			break
		end
	end

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", flag)
end

LevelEndView.draw_weave_widgets = function (self, arg_18_1, arg_18_2)
	-- function 18
	local flag = self.context.game_mode_key == "weave"
	local is_quickplay = self.context.is_quickplay

	if not (not flag and is_quickplay) then
		return
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local _weave_render_settings = self._weave_render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_18_2, arg_18_1, nil, _weave_render_settings)
	UIRenderer.draw_widget(ui_renderer, self._dead_space_filler_mask)
	UIRenderer.draw_widget(ui_renderer, self._dead_space_filler_unmask)

	for k, v in pairs(self._weave_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	UIRenderer.end_pass(ui_renderer)
end

LevelEndView.draw = function (self, arg_19_1, arg_19_2)
	-- function 19
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local is_device_active = self.input_manager:is_device_active("gamepad")
	local waiting_to_start = self.waiting_to_start
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_19_2, arg_19_1, nil, render_settings)

	if not flag then
		UISceneGraph.debug_render_scenegraph(ui_renderer, ui_scenegraph)
	end

	for i, v in ipairs(self._static_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	if not self._page_selector_widget then
		UIRenderer.draw_widget(ui_renderer, self._page_selector_widget)
	end

	if not self._started_force_shutdown then
		for k, v_2 in pairs(self._dynamic_widgets) do
			UIRenderer.draw_widget(ui_renderer, v_2)
		end
	end

	if not self:state_machine_completed() then
		UIRenderer.draw_widget(ui_renderer, self._ready_button_widget)
	end

	UIRenderer.end_pass(ui_renderer)

	if not self:state_machine_completed() and not is_device_active and not not self._ready_button_widget.content.button_hotspot.disable_button then
		self._menu_input_description:draw(ui_top_renderer, arg_19_1)
	end
end

LevelEndView.update = function (self, arg_20_1, arg_20_2)
	-- function 20
	LevelEndView.super.update(self, arg_20_1, arg_20_2)
	self:_update_team_previewer(arg_20_1, arg_20_2)
	self:_update_fade(arg_20_1, arg_20_2)
	self:_update_story(arg_20_1, arg_20_2)

	local input_service = self:input_service()

	self:draw_weave_widgets(arg_20_1, input_service)

	if self.suspended or not self.waiting_for_post_update_enter then
		return
	end

	self:_update_input(arg_20_1, arg_20_2)
	self:_update_animations(arg_20_1, arg_20_2)
	self:draw(arg_20_1, input_service)

	if not self._playing_music then
		self._playing_music = true

		self:play_sound(self._start_music_event)
	end

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

LevelEndView._update_fade = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not self._fade_out_triggered then
		return
	end

	if not (not self._team_previewer and self._team_previewer:loading_done()) then
		Managers.transition:force_fade_in()
	else
		Managers.transition:fade_out(2)

		self._fade_out_triggered = true

		self:_handle_global_shader_flags()
	end
end

LevelEndView._update_input = function (self, arg_22_1, arg_22_2)
	-- function 22
	local flag = false

	if self:_is_button_hover_enter(self._retry_button_widget) or not self:_is_button_hover_enter(self._ready_button_widget) then
		self:play_sound("play_gui_start_menu_button_hover")
	end

	if not (not self:_is_button_pressed(self._ready_button_widget) and flag) then
		self:play_sound("play_gui_mission_summary_button_return_to_keep_click")

		if not self._left_lobby then
			self:exit_to_game()
		else
			self:signal_done(false)
		end

		flag = true
	end

	if flag or not self._cursor_visible then
		self:_update_gamepad_input(arg_22_1, arg_22_2)
	end
end

LevelEndView._update_gamepad_input = function (self, arg_23_1, arg_23_2)
	-- function 23
	local input_service = self:input_service()

	if not not self._ready_button_widget.content.button_hotspot.disable_button and input_service:get("refresh") and not Managers.invite:has_invitation() then
		self:play_sound("play_gui_mission_summary_button_return_to_keep_click")

		if not self._left_lobby then
			self:exit_to_game()
		else
			self:signal_done(false)
		end
	end
end

LevelEndView.input_enabled = function (self)
	-- function 24
	return not self._ready_button_widget.content.button_hotspot.disable_button
end

LevelEndView.set_input_description = function (self, arg_25_1)
	-- function 25
	local var_25_0 = var_0_0.generic_input_actions[arg_25_1]

	self._menu_input_description:set_input_description(var_25_0)
end

LevelEndView._update_animations = function (self, arg_26_1, arg_26_2)
	-- function 26
	self.ui_animator:update(arg_26_1)

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_26_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end

	UIWidgetUtils.animate_default_button(self._retry_button_widget, arg_26_1)
	UIWidgetUtils.animate_default_button(self._ready_button_widget, arg_26_1)
end

LevelEndView.destroy = function (self, arg_27_1)
	-- function 27
	self:_destroy_team_previewer()
	LevelEndView.super.destroy(self, arg_27_1)
	Managers.state.event:unregister("set_flow_object_set_enabled", self)

	self._ui_scenegraph = nil
end

LevelEndView.active_input_service = function (self)
	-- function 28
	local FAKE_INPUT_SERVICE

	if not self.input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_28_0::

	return FAKE_INPUT_SERVICE
end

LevelEndView._start_animation = function (self, arg_29_1)
	-- function 29
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local _dynamic_widgets = self._dynamic_widgets

	return self.ui_animator:start_animation(arg_29_1, _dynamic_widgets, scenegraph_definition, tbl)
end

LevelEndView._retry_level = function (self)
	-- function 30
	self:signal_done(true)

	if not self.is_server then
		self._retry_button_widget.content.button_hotspot.disabled = true
	end
end

LevelEndView.signal_done = function (self, arg_31_1)
	-- function 31
	LevelEndView.super.signal_done(self, arg_31_1)

	if not self._signaled_done then
		return
	end

	self._ready_button_widget.content.button_hotspot.disable_button = true
	self._retry_button_widget.content.button_hotspot.disable_button = true
end

LevelEndView.peer_signaled_done = function (self, arg_32_1, arg_32_2)
	-- function 32
	LevelEndView.super.peer_signaled_done(self, arg_32_1, arg_32_2)

	local var_32_0

	if not arg_32_2 then
		var_32_0 = self._retry_checkboxes_widget.content
	else
		var_32_0 = self._reload_checkboxes_widget.content
	end

	var_32_0.votes = var_32_0.votes + 1
end

LevelEndView._set_end_timer = function (arg_33_0, arg_33_1)
	-- function 33
	arg_33_0._dynamic_widgets.timer_text.content.text = Localize("timer_prefix_time_left") .. ": " .. UIUtils.format_time(math.ceil(arg_33_1))
end

LevelEndView.update_force_shutdown = function (self, arg_34_1)
	-- function 34
	self._force_shutdown_timer = math.max(0, self._force_shutdown_timer - arg_34_1)

	self:_set_end_timer(self._force_shutdown_timer)

	if not (self._force_shutdown_timer ~= 0 or self._signaled_done) then
		self:signal_done(false)

		self._signaled_done = true
		self._signal_done_fallback_timer = 15
		self._ready_button_widget.content.button_hotspot.disable_button = true
		self._retry_button_widget.content.button_hotspot.disable_button = true
	elseif not self._left_lobby then
		if not self._signal_done_fallback_timer then
			self._signal_done_fallback_timer = math.max(0, self._signal_done_fallback_timer - arg_34_1)
		end

		local flag = true

		if not self._lobby:members() then
			local get_members = self._lobby:members():get_members()
			local _peers_with_score = self._peers_with_score

			for i = 1, #get_members do
				local var_34_3 = get_members[i]

				if (self._done_peers[var_34_3] or not _peers_with_score) and not _peers_with_score[var_34_3 .. ":1"] then
					flag = false

					break
				end
			end
		end

		if not ((flag or not self._signal_done_fallback_timer) and not (self._signal_done_fallback_timer <= 0)) then
			self:exit_to_game()
		end
	end

	if not self._started_exit then
		self._started_force_shutdown = false
	end
end

local str = "levels/end_screen_victory/parading_screen"

LevelEndView.setup_camera = function (self)
	-- function 35
	local flag

	flag = not self.game_won and "pose_camera" and "end_screen_camera"

	local var_35_1
	local var_35_2
	local flag_2

	flag_2 = not self.game_won and "units/hub_elements/cutscene_camera/cutscene_camera_env_controls" and "units/hub_elements/cutscene_camera/cutscene_camera"

	local unit_indices = LevelResource.unit_indices(str, flag_2)

	for k, v in pairs(unit_indices) do
		local unit_data = LevelResource.unit_data(str, v)
		local get = DynamicData.get(unit_data, "name")

		if not (not get and get ~= flag) then
			local unit_position = LevelResource.unit_position(str, v)
			local unit_rotation = LevelResource.unit_rotation(str, v)
			local unit_rotation_2 = LevelResource.unit_rotation(str, v)
			local forward = Quaternion.forward(unit_rotation_2)
			local from_quaternion_position = Matrix4x4.from_quaternion_position(unit_rotation_2, unit_position)

			var_35_1 = Matrix4x4Box(from_quaternion_position)
			var_35_2 = v

			print("Found camera: " .. get)

			break
		end
	end

	self._camera_pose = var_35_1
	self._camera_index = var_35_2

	self:position_camera()
end

LevelEndView.get_camera_pose = function (self)
	-- function 36
	return self._camera_pose:unbox()
end

LevelEndView.start_story_camera = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	-- function 37
	self._storyteller = World.storyteller(self._world)

	self:stop_playing_story(self._story_id)

	local play_level_story = Storyteller.play_level_story(self._storyteller, self._level, arg_37_1)

	self._story_id = play_level_story

	Storyteller.set_speed(self._storyteller, play_level_story, arg_37_3 or 1)

	local set_loop_mode = Storyteller.set_loop_mode
	local _storyteller = self._storyteller
	local var_37_3 = play_level_story
	local LOOP

	if not arg_37_2 then
		LOOP = Storyteller.LOOP

		if not LOOP then
			-- Nothing
		end
	end

	LOOP = Storyteller.NONE

	::label_37_0::

	set_loop_mode(_storyteller, var_37_3, LOOP)

	self._story_timer = 0
	self._manual_control = arg_37_4
	self._story_length = Storyteller.length(self._storyteller, play_level_story)

	return play_level_story
end

LevelEndView.stop_playing_story = function (self, arg_38_1)
	-- function 38
	if not (not arg_38_1 and not self._storyteller and Storyteller.is_playing(self._storyteller, arg_38_1)) then
		return
	end

	Storyteller.stop(self._storyteller, arg_38_1)

	self._story_id = nil
end

LevelEndView.is_playing_story = function (self, arg_39_1)
	-- function 39
	if not (not self._storyteller and arg_39_1) then
		return false
	end

	return (Storyteller.is_playing(self._storyteller, arg_39_1))
end

LevelEndView._update_story = function (self, arg_40_1, arg_40_2)
	-- function 40
	if not (not self._storyteller and self._story_id) then
		return
	end

	Storyteller.set_speed(self._storyteller, self._story_id, self._state_speed_mult)

	if not self._manual_control then
		Storyteller.set_time(self._storyteller, self._story_id, self._story_timer)
	end

	local unit_by_index = Level.unit_by_index(self._level, self._camera_index)
	local world_pose = Unit.world_pose(unit_by_index, 0)

	self._camera_pose = Matrix4x4Box(world_pose)

	self:position_camera()

	if Storyteller.time(self._storyteller, self._story_id) >= self._story_length then
		self:stop_playing_story(self._story_id)

		self._storyteller = nil
	end
end

LevelEndView.set_story_time = function (self, arg_41_1)
	-- function 41
	self._story_timer = arg_41_1
end

LevelEndView._gather_hero_locations = function (arg_42_0)
	-- function 42
	local tbl = {}
	local unit_indices = LevelResource.unit_indices(str, "units/hub_elements/versus_podium_character_spawn")

	for k, v in pairs(unit_indices) do
		local unit_data = LevelResource.unit_data(str, v)
		local get = DynamicData.get(unit_data, "name")

		if not get and not string.find(get, "spawn_point") then
			local unit_position = LevelResource.unit_position(str, v)

			tbl[tonumber(string.gsub(get, "spawn_point_", ""), 10)] = {
				unit_position[1],
				unit_position[2],
				unit_position[3]
			}
		end
	end

	for k_2 = 1, 4 do
		local var_42_5 = tbl[k_2]

		var_42_5 = var_42_5 or {
			0,
			0,
			0
		}
		tbl[k_2] = var_42_5
	end

	return tbl
end

LevelEndView.create_world = function (self, arg_43_1)
	-- function 43
	local str = "end_screen"
	local str_2 = "environment/ui_end_screen"
	local num = 2
	local get_world_flags = self:get_world_flags()
	local create_world = Managers.world:create_world(str, str_2, nil, num, unpack(get_world_flags))
	local world = Managers.world:world("top_ingame_view")

	return create_world, world
end

LevelEndView.spawn_level = function (self, arg_44_1, arg_44_2)
	-- function 44
	local tbl = {}
	local var_44_1
	local var_44_2
	local var_44_3
	local var_44_4
	local flag = false
	local spawn_level = ScriptWorld.spawn_level(arg_44_2, str, tbl, var_44_1, var_44_2, var_44_3, var_44_4, flag)

	Level.spawn_background(spawn_level)
	Level.trigger_level_loaded(spawn_level)
	self:_register_object_sets(spawn_level, str)

	local flag_2

	flag_2 = not arg_44_1.game_won and "flow_victory" and "flow_defeat"

	self:_show_object_set(flag_2, spawn_level)

	return spawn_level
end

LevelEndView.get_world_link_unit = function (self)
	-- function 45
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

LevelEndView._push_mouse_cursor = function (self)
	-- function 46
	if not self._cursor_visible then
		ShowCursorStack.show("LevelEndViewBase")

		self._cursor_visible = true

		self:_start_animation("ready_button_entry_alone")
	end
end

LevelEndViewBase._pop_mouse_cursor = function (self)
	-- function 47
	if not self._cursor_visible then
		ShowCursorStack.hide("LevelEndViewBase")

		self._cursor_visible = nil
	end
end

LevelEndView.input_enabled = function (self)
	-- function 48
	return not self._ready_button_widget.content.button_hotspot.disable_button
end
