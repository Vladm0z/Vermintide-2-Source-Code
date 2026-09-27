-- chunkname: @scripts/managers/transition/transition_manager.lua

require("scripts/ui/views/disconnect_indicator_view")
require("scripts/ui/views/loading_icon_view")
require("scripts/ui/views/twitch_icon_view")
require("scripts/ui/views/dev_backend_water_mark_view")

if not script_data.honduras_demo then
	require("scripts/ui/views/water_mark_view")
	require("scripts/ui/views/transition_video")
end

TransitionManager = class(TransitionManager)

TransitionManager.init = function (self)
	-- function 1
	self:_setup_names()
	self:_setup_world()

	self._loading_icon_view = LoadingIconView:new(self._world)
	self._disconnect_indicator_view = DisconnectIndicatorView:new(self._world)
	self._twitch_icon_view = TwitchIconView:new(self._world)

	if not script_data.honduras_demo then
		self._watermark = WaterMarkView:new(self._world)
		self._transition_video = TransitionVideo:new(self._world)
	end

	if not GameSettingsDevelopment.backend_settings.is_prod then
		self._dev_backend_watermark = DevBackendWatermarkView:new(self._world)
	end

	self._color = Vector3Box(0, 0, 0)
	self._fade_state = "out"
	self._fade = 0
end

TransitionManager._setup_names = function (self)
	-- function 2
	self._world_name = "top_ingame_view"
end

TransitionManager.set_multiplayer_values = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local _multiplayer_tracking = self._multiplayer_tracking

	_multiplayer_tracking = _multiplayer_tracking or {}
	self._multiplayer_tracking = _multiplayer_tracking

	local _multiplayer_tracking_2 = self._multiplayer_tracking
	local var_3_2 = self._multiplayer_tracking[arg_3_1]

	var_3_2 = var_3_2 or {}
	_multiplayer_tracking_2[arg_3_1] = var_3_2
	self._multiplayer_tracking[arg_3_1][#self._multiplayer_tracking[arg_3_1] + 1] = arg_3_2

	local _multiplayer_tracking_3 = self._multiplayer_tracking
	local string = self._multiplayer_tracking.string

	string = string or {}
	_multiplayer_tracking_3.string = string
	self._multiplayer_tracking.string[#self._multiplayer_tracking.string + 1] = arg_3_3
end

TransitionManager.dump_multiplayer_data = function (self)
	-- function 4
	Application.warning(" ")
	Application.warning("##################################")
	Application.warning(" ")
	Application.warning("############## START #############")

	local dump = table.dump
	local start = self._multiplayer_tracking.start

	start = start or {}

	dump(start, "MultiplayerRoundStart", 2, Application.warning)
	Application.warning(" ")
	Application.warning("############### END ##############")

	local dump_2 = table.dump
	local var_4_3 = self._multiplayer_tracking["end"]

	var_4_3 = var_4_3 or {}

	dump_2(var_4_3, "MultiplayerRoundEnd", 2, Application.warning)
	Application.warning(" ")
	Application.warning("############# STRINGS ############")

	local dump_3 = table.dump
	local string = self._multiplayer_tracking.string

	string = string or {}

	dump_3(string, "Strings", 2, Application.warning)
	Application.warning(" ")
	Application.warning("##################################")
	Application.warning(" ")
end

TransitionManager._setup_world = function (self)
	-- function 5
	local create_world = Managers.world:create_world(self._world_name, GameSettingsDevelopment.default_environment, nil, 991, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.activate(create_world)

	self._loading_icon_viewport = ScriptWorld.create_viewport(create_world, "top_ingame_view_viewport", "overlay", 1)
	self._world = create_world
	self._gui = World.create_screen_gui(self._world, "material", "materials/fonts/gw_fonts", "immediate")
end

TransitionManager.destroy = function (self)
	-- function 6
	self._loading_icon_view:destroy()

	self._loading_icon_view = nil

	if not self._disconnect_indicator_view then
		self._disconnect_indicator_view:destroy()

		self._disconnect_indicator_view = nil
	end

	if not self._twitch_icon_view then
		self._twitch_icon_view:destroy()
	end

	self._twitch_icon_view = nil

	if not self._watermark then
		self._watermark:destroy()
	end

	if not self._dev_backend_watermark then
		self._dev_backend_watermark:destroy()
	end

	if not self._transition_video then
		self._transition_video:destroy()
	end

	self._transition_video = nil

	Managers.world:destroy_world(self._world_name)
end

TransitionManager.show_waiting_for_peers_message = function (self, arg_7_1)
	-- function 7
	self._waiting_for_peers_message = arg_7_1
	self._waiting_for_peers_timer = Managers.time:time("main")
end

TransitionManager.show_loading_icon = function (self, arg_8_1)
	-- function 8
	self._loading_icon_view:show_loading_icon()

	if not arg_8_1 then
		self:show_icon_background()
	else
		self:hide_icon_background()
	end
end

TransitionManager.show_video = function (self, arg_9_1)
	-- function 9
	if not self._transition_video then
		self._transition_video:activate(arg_9_1)
	end
end

TransitionManager.is_video_done = function (self)
	-- function 10
	if not self._transition_video then
		return self._transition_video:completed()
	end
end

TransitionManager.is_video_active = function (self)
	-- function 11
	if not self._transition_video then
		return self._transition_video:is_active()
	end
end

TransitionManager.hide_loading_icon = function (self)
	-- function 12
	self._loading_icon_view:hide_loading_icon()
end

TransitionManager.show_icon_background = function (self)
	-- function 13
	self._loading_icon_view:show_icon_background()
end

TransitionManager.hide_icon_background = function (self)
	-- function 14
	self._loading_icon_view:hide_icon_background()
end

TransitionManager.loading_icon_active = function (self)
	-- function 15
	local _loading_icon_view = self._loading_icon_view

	_loading_icon_view = not _loading_icon_view and self._loading_icon_view:active()

	return _loading_icon_view
end

TransitionManager.fade_in = function (self, arg_16_1, arg_16_2)
	-- function 16
	self._fade_state = "fade_in"
	self._fade_speed = arg_16_1
	self._callback = arg_16_2

	if not script_data.debug_transition_manager then
		print("[TransitionManager:fade_in]", Script.callstack())
	end
end

TransitionManager.fade_out = function (self, arg_17_1, arg_17_2)
	-- function 17
	self._fade_state = "fade_out"
	self._fade_speed = -arg_17_1
	self._callback = arg_17_2

	if not script_data.debug_transition_manager then
		print("[TransitionManager:fade_out]", Script.callstack())
	end
end

TransitionManager.force_fade_in = function (self)
	-- function 18
	self._fade_state = "in"
	self._fade_speed = 0
	self._fade = 1

	if not self._callback then
		self._callback()

		self._callback = nil
	end
end

TransitionManager.force_fade_out = function (self)
	-- function 19
	self._fade_state = "out"
	self._fade_speed = 0
	self._fade = 0

	if not self._callback then
		self._callback()

		self._callback = nil
	end
end

TransitionManager.fade_state = function (self)
	-- function 20
	return self._fade_state
end

TransitionManager.in_fade_active = function (self)
	-- function 21
	return self._fade ~= 0
end

TransitionManager.fade_value = function (self)
	-- function 22
	return self._fade
end

TransitionManager.fade_in_completed = function (self)
	-- function 23
	return self._fade_state ~= "in" or self._fade == 1
end

TransitionManager.fade_out_completed = function (self)
	-- function 24
	return self._fade_state ~= "out" or self._fade == 0
end

TransitionManager._render = function (self, arg_25_1)
	-- function 25
	if not DEDICATED_SERVER then
		return
	end

	local resolution, var_25_1 = Application.resolution()
	local unbox = self._color:unbox()

	Gui.rect(self._gui, Vector3(0, 0, UILayer.transition), Vector2(resolution, var_25_1), Color(self._fade * 255, unbox.x, unbox.y, unbox.z))
end

local tbl = {
	font_type = "hell_shark",
	font_size = 56
}

TransitionManager._render_waiting_message = function (self, arg_26_1)
	-- function 26
	if not self._waiting_for_peers_message then
		return
	end

	if IS_WINDOWS or not IS_LINUX then
		self:show_waiting_for_peers_message(false)

		return
	end

	if not (self._fade_state == "fade_out" or self._fade_state ~= "out") then
		self:show_waiting_for_peers_message(false)

		return
	end

	local resolution, var_26_1 = Gui.resolution()
	local num = 192 + 63 * math.sin(self._waiting_for_peers_timer * 4)
	local var_26_3 = Localize("matchmaking_status_waiting_for_other_players")
	local var_26_4, var_26_5 = UIFontByResolution(tbl)
	local var_26_6 = var_26_4[1]
	local var_26_7 = var_26_4[2]
	local var_26_8 = var_26_4[3]
	local var_26_9 = Color(255, num, num, num)
	local text_extents, var_26_11 = Gui.text_extents(self._gui, var_26_3, var_26_6, var_26_5)
	local num_2 = var_26_11.x - text_extents.x
	local var_26_13 = Vector3(resolution * 0.5 - num_2 * 0.5, var_26_1 * 0.1, UILayer.transition + 1)

	Gui.text(self._gui, var_26_3, var_26_6, var_26_5, var_26_8, var_26_13, var_26_9)

	self._waiting_for_peers_timer = self._waiting_for_peers_timer + arg_26_1
end

TransitionManager.force_render = function (self, arg_27_1)
	-- function 27
	if not (not self:loading_icon_active() and Development.parameter("disable_loading_icon")) then
		self._loading_icon_view:update(arg_27_1)
	end

	if not script_data.honduras_demo then
		if not Development.parameter("disable_water_mark") then
			self._watermark:update(arg_27_1)
		end

		self._transition_video:update(arg_27_1)
	end

	if not (not self._dev_backend_watermark and Development.parameter("disable_water_mark")) then
		self._dev_backend_watermark:update(arg_27_1)
	end

	self:_render()
end

TransitionManager.update = function (self, arg_28_1)
	-- function 28
	if Managers.eac ~= nil then
		Managers.eac:draw_panel(self._gui, arg_28_1)
	end

	if not self._disconnect_indicator_view then
		self._disconnect_indicator_view:update(arg_28_1)
	end

	if not (not self:loading_icon_active() and Development.parameter("disable_loading_icon")) then
		self._loading_icon_view:update(arg_28_1)
	end

	if not self._twitch_icon_view then
		self._twitch_icon_view:update(arg_28_1)
	end

	self:_render_waiting_message(arg_28_1)

	if not script_data.honduras_demo then
		if not Development.parameter("disable_water_mark") then
			self._watermark:update(arg_28_1)
		end

		self._transition_video:update(arg_28_1)
	end

	if not (not self._dev_backend_watermark and Development.parameter("disable_water_mark")) then
		self._dev_backend_watermark:update(arg_28_1)
	end

	if self._fade_state == "out" then
		return
	end

	if self._fade_state == "in" then
		self:_render(arg_28_1)

		return
	end

	self._fade = math.clamp(self._fade + self._fade_speed * math.min(arg_28_1, 0.03333333333333333), 0, 1)

	if not (self._fade_state ~= "fade_in" or not (self._fade >= 1)) then
		self._fade = 1
		self._fade_state = "in"

		if not self._callback then
			local _callback = self._callback

			self._callback = nil

			_callback()
		end
	elseif not (self._fade_state ~= "fade_out" or not (self._fade <= 0)) then
		self._fade = 0
		self._fade_state = "out"

		if not self._callback then
			local _callback_2 = self._callback

			self._callback = nil

			_callback_2()
		end

		return
	end

	if self._fade_state ~= "out" then
		self:_render(arg_28_1)
	end
end
