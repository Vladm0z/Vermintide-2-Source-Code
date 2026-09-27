-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_prestige.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_prestige_definitions")
local widgets = var_0_0.widgets
local warning_widgets = var_0_0.warning_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false

HeroWindowPrestige = class(HeroWindowPrestige)
HeroWindowPrestige.NAME = "HeroWindowPrestige"

HeroWindowPrestige.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowPrestige")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.profile_index = arg_1_1.profile_index

	local get_experience = ExperienceSettings.get_experience(self.hero_name)

	self.hero_level = ExperienceSettings.get_level(get_experience)

	self:_setup_prestige_reward()
end

HeroWindowPrestige.on_exit = function (self, arg_2_1)
	-- function 2
	print("[HeroViewWindow] Exit Substate HeroWindowPrestige")

	self.ui_animator = nil
end

HeroWindowPrestige.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}

	for k_2, v_2 in pairs(warning_widgets) do
		local var_3_4 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_3_4
		tbl_2[k_2] = var_3_4
	end

	self._warning_widgets = tbl_3

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end
end

HeroWindowPrestige._setup_prestige_reward = function (self)
	-- function 4
	local _widgets_by_name = self._widgets_by_name
	local hero_name = self.hero_name
	local get_max_prestige_levels = ProgressionUnlocks.get_max_prestige_levels()

	self._max_prestige_level = get_max_prestige_levels

	local get_prestige_level = ProgressionUnlocks.get_prestige_level(hero_name)

	self._prestige_level = get_prestige_level

	local min = math.min(get_prestige_level + 1, get_max_prestige_levels)

	if not (get_prestige_level == min) then
		local var_4_5
		local var_4_6
		local prestige_reward_by_level = ProgressionUnlocks.prestige_reward_by_level(min, hero_name)

		self._reward_item_key = prestige_reward_by_level

		local var_4_8 = ItemMasterList[prestige_reward_by_level]
		local item_type = var_4_8.item_type
		local display_name = var_4_8.display_name

		if item_type == "hat" then
			-- Nothing
		elseif item_type == "frame" then
			var_4_5 = var_4_8.name
		elseif item_type == "skin" then
			-- Nothing
		end

		self:_set_prestige_reward_portrait_frame(var_4_5)

		_widgets_by_name.reward_item_text.content.text = Localize(display_name)
	end

	local can_upgrade_prestige = ProgressionUnlocks.can_upgrade_prestige(hero_name)

	_widgets_by_name.prestige_button.content.button_hotspot.disable_button = not can_upgrade_prestige
	_widgets_by_name.unable_description_text.content.visible = not can_upgrade_prestige
end

HeroWindowPrestige.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_animations(arg_5_1)
	self:_handle_input(arg_5_1, arg_5_2)
	self:draw(arg_5_1)
end

HeroWindowPrestige.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

HeroWindowPrestige._update_animations = function (self, arg_7_1)
	-- function 7
	self.ui_animator:update(arg_7_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

HeroWindowPrestige._is_button_pressed = function (arg_8_0, arg_8_1)
	-- function 8
	local button_hotspot = arg_8_1.content.button_hotspot

	if not button_hotspot.on_pressed then
		button_hotspot.on_pressed = false

		return true
	end
end

HeroWindowPrestige._is_button_released = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowPrestige._is_stepper_button_pressed = function (arg_10_0, arg_10_1)
	-- function 10
	local content = arg_10_1.content
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

HeroWindowPrestige._handle_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	local parent = self.parent
	local _widgets_by_name = self._widgets_by_name
	local get_interface = Managers.backend:get_interface("hero_attributes")

	if not self:_is_button_pressed(_widgets_by_name.debug_level_up_button) then
		get_interface:set(self.hero_name, "experience", ExperienceSettings.max_experience)
		self:_setup_prestige_reward()

		return true
	end

	if not (not self:_is_button_pressed(_widgets_by_name.prestige_button) and self._show_warning_popup) then
		_widgets_by_name.prestige_button.content.visible = false
		self._show_warning_popup = true

		parent:block_input()
		parent:set_fullscreen_effect_enable_state(true)

		return true
	end

	if not self._show_warning_popup then
		local get = parent:input_service():get("toggle_menu", true)

		if self:_is_button_pressed(_widgets_by_name.warning_popup_decline_button) or not get then
			_widgets_by_name.prestige_button.content.visible = true
			self._show_warning_popup = false

			parent:unblock_input()
			parent:set_fullscreen_effect_enable_state(false)

			return true
		end

		if not self:_is_button_pressed(_widgets_by_name.warning_popup_accept_button) then
			_widgets_by_name.prestige_button.content.visible = true
			self._show_warning_popup = false

			self:_play_sound("Play_enemy_combat_globadier_suicide_explosion")
			get_interface:prestige(self.hero_name)

			self._wait_for_backend_attributes = true

			parent:unblock_input()
			parent:set_fullscreen_effect_enable_state(false)
			self:_setup_prestige_reward()

			return true
		end
	end
end

HeroWindowPrestige.draw = function (self, arg_12_1)
	-- function 12
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_12_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	if not self._reward_portrait_widget then
		UIRenderer.draw_widget(ui_renderer, self._reward_portrait_widget)
	end

	UIRenderer.end_pass(ui_renderer)

	if not self._show_warning_popup then
		local input_service = self.parent:input_service()

		UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, arg_12_1, nil, self.render_settings)

		for i_2, v_2 in ipairs(self._warning_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v_2)
		end

		UIRenderer.end_pass(ui_top_renderer)
	end
end

HeroWindowPrestige._play_sound = function (self, arg_13_1)
	-- function 13
	self.parent:play_sound(arg_13_1)
end

HeroWindowPrestige._set_prestige_reward_portrait_frame = function (self, arg_14_1)
	-- function 14
	local career_index = self.career_index
	local profile_index = self.profile_index
	local portrait_image = SPProfiles[profile_index].careers[career_index].portrait_image
	local var_14_3

	if not arg_14_1 then
		local create_portrait_frame = UIWidgets.create_portrait_frame("reward_portrait_root", arg_14_1, "", 1, nil, portrait_image)

		var_14_3 = UIWidget.init(create_portrait_frame, self.ui_renderer)
		var_14_3.content.frame_settings_name = arg_14_1
	end

	self._reward_portrait_widget = var_14_3
end
