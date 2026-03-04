-- chunkname: @scripts/managers/transition/transition_manager.lua

require("scripts/ui/views/disconnect_indicator_view")
require("scripts/ui/views/loading_icon_view")
require("scripts/ui/views/twitch_icon_view")
require("scripts/ui/views/dev_backend_water_mark_view")

if script_data.honduras_demo then
	require("scripts/ui/views/water_mark_view")
	require("scripts/ui/views/transition_video")
end

TransitionManager = class(TransitionManager)

TransitionManager.init = function (arg_1_0)
	arg_1_0:_setup_names()
	arg_1_0:_setup_world()

	arg_1_0._loading_icon_view = LoadingIconView:new(arg_1_0._world)
	arg_1_0._disconnect_indicator_view = DisconnectIndicatorView:new(arg_1_0._world)
	arg_1_0._twitch_icon_view = TwitchIconView:new(arg_1_0._world)

	if script_data.honduras_demo then
		arg_1_0._watermark = WaterMarkView:new(arg_1_0._world)
		arg_1_0._transition_video = TransitionVideo:new(arg_1_0._world)
	end

	if not GameSettingsDevelopment.backend_settings.is_prod then
		arg_1_0._dev_backend_watermark = DevBackendWatermarkView:new(arg_1_0._world)
	end

	arg_1_0._color = Vector3Box(0, 0, 0)
	arg_1_0._fade_state = "out"
	arg_1_0._fade = 0
end

TransitionManager._setup_names = function (arg_2_0)
	arg_2_0._world_name = "top_ingame_view"
end

TransitionManager.set_multiplayer_values = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0._multiplayer_tracking = arg_3_0._multiplayer_tracking or {}
	arg_3_0._multiplayer_tracking[arg_3_1] = arg_3_0._multiplayer_tracking[arg_3_1] or {}
	arg_3_0._multiplayer_tracking[arg_3_1][#arg_3_0._multiplayer_tracking[arg_3_1] + 1] = arg_3_2
	arg_3_0._multiplayer_tracking.string = arg_3_0._multiplayer_tracking.string or {}
	arg_3_0._multiplayer_tracking.string[#arg_3_0._multiplayer_tracking.string + 1] = arg_3_3
end

TransitionManager.dump_multiplayer_data = function (arg_4_0)
	Application.warning(" ")
	Application.warning("##################################")
	Application.warning(" ")
	Application.warning("############## START #############")
	table.dump(arg_4_0._multiplayer_tracking.start or {}, "MultiplayerRoundStart", 2, Application.warning)
	Application.warning(" ")
	Application.warning("############### END ##############")
	table.dump(arg_4_0._multiplayer_tracking["end"] or {}, "MultiplayerRoundEnd", 2, Application.warning)
	Application.warning(" ")
	Application.warning("############# STRINGS ############")
	table.dump(arg_4_0._multiplayer_tracking.string or {}, "Strings", 2, Application.warning)
	Application.warning(" ")
	Application.warning("##################################")
	Application.warning(" ")
end

TransitionManager._setup_world = function (arg_5_0)
	local var_5_0 = Managers.world:create_world(arg_5_0._world_name, GameSettingsDevelopment.default_environment, nil, 991, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.activate(var_5_0)

	arg_5_0._loading_icon_viewport = ScriptWorld.create_viewport(var_5_0, "top_ingame_view_viewport", "overlay", 1)
	arg_5_0._world = var_5_0
	arg_5_0._gui = World.create_screen_gui(arg_5_0._world, "material", "materials/fonts/gw_fonts", "immediate")
end

TransitionManager.destroy = function (arg_6_0)
	arg_6_0._loading_icon_view:destroy()

	arg_6_0._loading_icon_view = nil

	if arg_6_0._disconnect_indicator_view then
		arg_6_0._disconnect_indicator_view:destroy()

		arg_6_0._disconnect_indicator_view = nil
	end

	if arg_6_0._twitch_icon_view then
		arg_6_0._twitch_icon_view:destroy()
	end

	arg_6_0._twitch_icon_view = nil

	if arg_6_0._watermark then
		arg_6_0._watermark:destroy()
	end

	if arg_6_0._dev_backend_watermark then
		arg_6_0._dev_backend_watermark:destroy()
	end

	if arg_6_0._transition_video then
		arg_6_0._transition_video:destroy()
	end

	arg_6_0._transition_video = nil

	Managers.world:destroy_world(arg_6_0._world_name)
end

TransitionManager.show_waiting_for_peers_message = function (arg_7_0, arg_7_1)
	arg_7_0._waiting_for_peers_message = arg_7_1
	arg_7_0._waiting_for_peers_timer = Managers.time:time("main")
end

TransitionManager.show_loading_icon = function (arg_8_0, arg_8_1)
	arg_8_0._loading_icon_view:show_loading_icon()

	if arg_8_1 then
		arg_8_0:show_icon_background()
	else
		arg_8_0:hide_icon_background()
	end
end

TransitionManager.show_video = function (arg_9_0, arg_9_1)
	if arg_9_0._transition_video then
		arg_9_0._transition_video:activate(arg_9_1)
	end
end

TransitionManager.is_video_done = function (arg_10_0)
	if arg_10_0._transition_video then
		return arg_10_0._transition_video:completed()
	end
end

TransitionManager.is_video_active = function (arg_11_0)
	if arg_11_0._transition_video then
		return arg_11_0._transition_video:is_active()
	end
end

TransitionManager.hide_loading_icon = function (arg_12_0)
	arg_12_0._loading_icon_view:hide_loading_icon()
end

TransitionManager.show_icon_background = function (arg_13_0)
	arg_13_0._loading_icon_view:show_icon_background()
end

TransitionManager.hide_icon_background = function (arg_14_0)
	arg_14_0._loading_icon_view:hide_icon_background()
end

TransitionManager.loading_icon_active = function (arg_15_0)
	return arg_15_0._loading_icon_view and arg_15_0._loading_icon_view:active()
end

TransitionManager.fade_in = function (arg_16_0, arg_16_1, arg_16_2)
	arg_16_0._fade_state = "fade_in"
	arg_16_0._fade_speed = arg_16_1
	arg_16_0._callback = arg_16_2

	if script_data.debug_transition_manager then
		print("[TransitionManager:fade_in]", Script.callstack())
	end
end

TransitionManager.fade_out = function (arg_17_0, arg_17_1, arg_17_2)
	arg_17_0._fade_state = "fade_out"
	arg_17_0._fade_speed = -arg_17_1
	arg_17_0._callback = arg_17_2

	if script_data.debug_transition_manager then
		print("[TransitionManager:fade_out]", Script.callstack())
	end
end

TransitionManager.force_fade_in = function (arg_18_0)
	arg_18_0._fade_state = "in"
	arg_18_0._fade_speed = 0
	arg_18_0._fade = 1

	if arg_18_0._callback then
		arg_18_0._callback()

		arg_18_0._callback = nil
	end
end

TransitionManager.force_fade_out = function (arg_19_0)
	arg_19_0._fade_state = "out"
	arg_19_0._fade_speed = 0
	arg_19_0._fade = 0

	if arg_19_0._callback then
		arg_19_0._callback()

		arg_19_0._callback = nil
	end
end

TransitionManager.fade_state = function (arg_20_0)
	return arg_20_0._fade_state
end

TransitionManager.in_fade_active = function (arg_21_0)
	return arg_21_0._fade ~= 0
end

TransitionManager.fade_value = function (arg_22_0)
	return arg_22_0._fade
end

TransitionManager.fade_in_completed = function (arg_23_0)
	return arg_23_0._fade_state == "in" and arg_23_0._fade == 1
end

TransitionManager.fade_out_completed = function (arg_24_0)
	return arg_24_0._fade_state == "out" and arg_24_0._fade == 0
end

TransitionManager._render = function (arg_25_0, arg_25_1)
	if DEDICATED_SERVER then
		return
	end

	local var_25_0, var_25_1 = Application.resolution()
	local var_25_2 = arg_25_0._color:unbox()

	Gui.rect(arg_25_0._gui, Vector3(0, 0, UILayer.transition), Vector2(var_25_0, var_25_1), Color(arg_25_0._fade * 255, var_25_2.x, var_25_2.y, var_25_2.z))
end

local var_0_0 = {
	font_type = "hell_shark",
	font_size = 56
}

TransitionManager._render_waiting_message = function (arg_26_0, arg_26_1)
	if not arg_26_0._waiting_for_peers_message then
		return
	end

	if IS_WINDOWS or IS_LINUX then
		arg_26_0:show_waiting_for_peers_message(false)

		return
	end

	if arg_26_0._fade_state == "fade_out" or arg_26_0._fade_state == "out" then
		arg_26_0:show_waiting_for_peers_message(false)

		return
	end

	local var_26_0, var_26_1 = Gui.resolution()
	local var_26_2 = 192 + 63 * math.sin(arg_26_0._waiting_for_peers_timer * 4)
	local var_26_3 = Localize("matchmaking_status_waiting_for_other_players")
	local var_26_4, var_26_5 = UIFontByResolution(var_0_0)
	local var_26_6 = var_26_4[1]
	local var_26_7 = var_26_4[2]
	local var_26_8 = var_26_4[3]
	local var_26_9 = Color(255, var_26_2, var_26_2, var_26_2)
	local var_26_10, var_26_11 = Gui.text_extents(arg_26_0._gui, var_26_3, var_26_6, var_26_5)
	local var_26_12 = var_26_11.x - var_26_10.x
	local var_26_13 = Vector3(var_26_0 * 0.5 - var_26_12 * 0.5, var_26_1 * 0.1, UILayer.transition + 1)

	Gui.text(arg_26_0._gui, var_26_3, var_26_6, var_26_5, var_26_8, var_26_13, var_26_9)

	arg_26_0._waiting_for_peers_timer = arg_26_0._waiting_for_peers_timer + arg_26_1
end

TransitionManager.force_render = function (arg_27_0, arg_27_1)
	if arg_27_0:loading_icon_active() and not Development.parameter("disable_loading_icon") then
		arg_27_0._loading_icon_view:update(arg_27_1)
	end

	if script_data.honduras_demo then
		if not Development.parameter("disable_water_mark") then
			arg_27_0._watermark:update(arg_27_1)
		end

		arg_27_0._transition_video:update(arg_27_1)
	end

	if arg_27_0._dev_backend_watermark and not Development.parameter("disable_water_mark") then
		arg_27_0._dev_backend_watermark:update(arg_27_1)
	end

	arg_27_0:_render()
end

TransitionManager.update = function (arg_28_0, arg_28_1)
	if Managers.eac ~= nil then
		Managers.eac:draw_panel(arg_28_0._gui, arg_28_1)
	end

	if arg_28_0._disconnect_indicator_view then
		arg_28_0._disconnect_indicator_view:update(arg_28_1)
	end

	if arg_28_0:loading_icon_active() and not Development.parameter("disable_loading_icon") then
		arg_28_0._loading_icon_view:update(arg_28_1)
	end

	if arg_28_0._twitch_icon_view then
		arg_28_0._twitch_icon_view:update(arg_28_1)
	end

	arg_28_0:_render_waiting_message(arg_28_1)

	if script_data.honduras_demo then
		if not Development.parameter("disable_water_mark") then
			arg_28_0._watermark:update(arg_28_1)
		end

		arg_28_0._transition_video:update(arg_28_1)
	end

	if arg_28_0._dev_backend_watermark and not Development.parameter("disable_water_mark") then
		arg_28_0._dev_backend_watermark:update(arg_28_1)
	end

	if arg_28_0._fade_state == "out" then
		return
	end

	if arg_28_0._fade_state == "in" then
		arg_28_0:_render(arg_28_1)

		return
	end

	arg_28_0._fade = math.clamp(arg_28_0._fade + arg_28_0._fade_speed * math.min(arg_28_1, 0.03333333333333333), 0, 1)

	if arg_28_0._fade_state == "fade_in" and arg_28_0._fade >= 1 then
		arg_28_0._fade = 1
		arg_28_0._fade_state = "in"

		if arg_28_0._callback then
			local var_28_0 = arg_28_0._callback

			arg_28_0._callback = nil

			var_28_0()
		end
	elseif arg_28_0._fade_state == "fade_out" and arg_28_0._fade <= 0 then
		arg_28_0._fade = 0
		arg_28_0._fade_state = "out"

		if arg_28_0._callback then
			local var_28_1 = arg_28_0._callback

			arg_28_0._callback = nil

			var_28_1()
		end

		return
	end

	if arg_28_0._fade_state ~= "out" then
		arg_28_0:_render(arg_28_1)
	end
end
