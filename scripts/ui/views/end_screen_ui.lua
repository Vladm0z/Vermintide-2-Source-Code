-- chunkname: @scripts/ui/views/end_screen_ui.lua

local var_0_0 = local_require("scripts/ui/views/end_screen_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local animations = var_0_0.animations
local screens = var_0_0.screens

for k, v in pairs(screens) do
	require(v.file_name)
end

local flag = false

EndScreenUI = class(EndScreenUI)

EndScreenUI.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_top_renderer
	self.world_manager = arg_1_1.world_manager
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._ingame_ui_context = arg_1_1

	local input_manager = arg_1_1.input_manager

	self.input_manager = input_manager

	input_manager:create_input_service("end_screen_ui", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("end_screen_ui", "keyboard")
	input_manager:map_device_to_service("end_screen_ui", "mouse")
	input_manager:map_device_to_service("end_screen_ui", "gamepad")

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	self:create_ui_elements()
end

EndScreenUI.destroy = function (self)
	-- function 2
	self.ui_animator = nil

	GarbageLeakDetector.register_object(self, "EndScreenUI")
end

EndScreenUI.create_ui_elements = function (self)
	-- function 3
	flag = false
	self.draw_flags = {
		draw_text = false,
		banner_alpha_multiplier = 0,
		draw_background = false
	}
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.background_rect_widget = UIWidget.init(var_0_0.widgets.background_rect)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animations)
end

EndScreenUI.input_service = function (self)
	-- function 4
	return self.input_manager:get_service("end_screen_ui")
end

EndScreenUI.on_enter = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local var_5_0 = screens[arg_5_1]

	fassert(var_5_0, "Unknown screen name: %s", arg_5_1)

	local input_manager = self.input_manager

	if not Managers.chat:chat_is_focused() then
		input_manager:block_device_except_service("end_screen_ui", "mouse")
		input_manager:block_device_except_service("end_screen_ui", "keyboard")
		input_manager:block_device_except_service("end_screen_ui", "gamepad", 1)
	end

	self:play_sound("mute_all_world_sounds")
	Wwise.set_state("override", "false")

	if not arg_5_2 and not arg_5_2.display_screen_delay then
		self._delayed_screen_data = {
			display_t = Managers.time:time("ui") + arg_5_2.display_screen_delay,
			screen_definition = var_5_0,
			screen_context = arg_5_2,
			screen_params = arg_5_3
		}
	else
		self:_create_screen(var_5_0, arg_5_2, arg_5_3)
	end
end

EndScreenUI._create_screen = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	self.is_active = true

	self:_fade_in_background()

	local input_service = self:input_service()
	local class_name = arg_6_1.class_name

	self._screen = rawget(_G, class_name):new(self._ingame_ui_context, input_service, arg_6_2, arg_6_3)

	self._screen:on_fade_in()
end

EndScreenUI.on_exit = function (self)
	-- function 7
	local draw_flags = self.draw_flags

	self.is_active = false

	if not Managers.chat:chat_is_focused() then
		local input_manager = self.input_manager

		input_manager:device_unblock_all_services("mouse", 1)
		input_manager:device_unblock_all_services("keyboard", 1)
		input_manager:device_unblock_all_services("gamepad", 1)
	end

	Managers.music:unduck_sounds()
end

EndScreenUI.on_complete = function (self)
	-- function 8
	self.is_complete = true
end

EndScreenUI.fade_in_complete = function (self)
	-- function 9
	return self._fade_in_completed
end

EndScreenUI._fade_in_background = function (self)
	-- function 10
	self.background_in_anim_id = self.ui_animator:start_animation("fade_in_background", {
		self.background_rect_widget
	}, scenegraph_definition, self.draw_flags)
end

EndScreenUI.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not flag then
		self:create_ui_elements()
	end

	local _delayed_screen_data = self._delayed_screen_data

	if not _delayed_screen_data then
		if arg_11_2 > _delayed_screen_data.display_t then
			self._delayed_screen_data = nil

			self:_create_screen(_delayed_screen_data.screen_definition, _delayed_screen_data.screen_context, _delayed_screen_data.screen_params)
		end

		return
	end

	if not self.is_active then
		return
	end

	local _screen = self._screen

	_screen:update(arg_11_1, arg_11_2)

	local ui_animator = self.ui_animator

	ui_animator:update(arg_11_1)

	if not self.background_in_anim_id then
		if not ui_animator:is_animation_completed(self.background_in_anim_id) then
			self.background_in_anim_id = nil
			self._fade_in_completed = true

			_screen:start()
		end
	elseif not (not _screen:started() and not _screen:completed() and Managers.backend:is_pending_request()) then
		Managers.transition:fade_in(GameSettings.transition_fade_in_speed, callback(self, "on_complete"))
	end

	self:draw(arg_11_1)
end

EndScreenUI.draw = function (self, arg_12_1)
	-- function 12
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("end_screen_ui")
	local draw_flags = self.draw_flags
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_12_1, nil, render_settings)

	if not draw_flags.draw_background then
		UIRenderer.draw_widget(ui_renderer, self.background_rect_widget)
	end

	UIRenderer.end_pass(ui_renderer)
	self._screen:draw(arg_12_1)
end

EndScreenUI.play_sound = function (self, arg_13_1)
	-- function 13
	WwiseWorld.trigger_event(self.wwise_world, arg_13_1)
end
