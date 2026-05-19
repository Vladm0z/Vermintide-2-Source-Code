-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_background.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_background_definitions")
local var_0_1 = var_0_0.top_widgets
local var_0_2 = var_0_0.bottom_widgets
local var_0_3 = var_0_0.bottom_hdr_widgets
local var_0_4 = var_0_0.scenegraph_definition
local var_0_5 = var_0_0.animation_definitions
local var_0_6 = false

StartGameWindowWeaveBackground = class(StartGameWindowWeaveBackground)
StartGameWindowWeaveBackground.NAME = "StartGameWindowWeaveBackground"

function StartGameWindowWeaveBackground.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowWeaveBackground")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui = var_1_0.ingame_ui
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._network_lobby = var_1_0.network_lobby
	arg_1_0._is_server = var_1_0.is_server
	arg_1_0._is_in_inn = var_1_0.is_in_inn
	arg_1_0._ui_hdr_renderer = arg_1_0._parent:hdr_renderer()
	arg_1_0._my_player = var_1_0.player
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_play_sound("menu_wind_level_open")
end

function StartGameWindowWeaveBackground._create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_4)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_1[#var_2_1 + 1] = var_2_2
		var_2_0[iter_2_0] = var_2_2
	end

	local var_2_3 = {}

	for iter_2_2, iter_2_3 in pairs(var_0_2) do
		local var_2_4 = UIWidget.init(iter_2_3)

		var_2_3[#var_2_3 + 1] = var_2_4
		var_2_0[iter_2_2] = var_2_4
	end

	local var_2_5 = {}

	for iter_2_4, iter_2_5 in pairs(var_0_3) do
		local var_2_6 = UIWidget.init(iter_2_5)

		var_2_5[#var_2_5 + 1] = var_2_6
		var_2_0[iter_2_4] = var_2_6
	end

	arg_2_0._top_widgets = var_2_1
	arg_2_0._bottom_widgets = var_2_3
	arg_2_0._bottom_hdr_widgets = var_2_5
	arg_2_0._widgets_by_name = var_2_0

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_5)

	arg_2_0:_set_background_wheel_visibility(true)
end

function StartGameWindowWeaveBackground.on_exit(arg_3_0, arg_3_1)
	print("[StartGameWindow] Exit Substate StartGameWindowWeaveBackground")

	arg_3_0.ui_animator = nil

	arg_3_0:_play_sound("menu_wind_level_close")
end

function StartGameWindowWeaveBackground.update(arg_4_0, arg_4_1, arg_4_2)
	if var_0_6 then
		var_0_6 = false

		arg_4_0:_create_ui_elements()
	end

	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:draw(arg_4_1)
end

function StartGameWindowWeaveBackground.post_update(arg_5_0, arg_5_1, arg_5_2)
	return
end

function StartGameWindowWeaveBackground._update_animations(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._ui_animations
	local var_6_1 = arg_6_0._animations
	local var_6_2 = arg_6_0.ui_animator

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			var_6_0[iter_6_0] = nil
		end
	end

	var_6_2:update(arg_6_1)

	for iter_6_2, iter_6_3 in pairs(var_6_1) do
		if var_6_2:is_animation_completed(iter_6_3) then
			var_6_2:stop_animation(iter_6_3)

			var_6_1[iter_6_2] = nil
		end
	end

	if arg_6_0._draw_background_wheel then
		arg_6_0:_update_background_animations(arg_6_1)
		arg_6_0:_animate_wheel_position(arg_6_1)
	end
end

function StartGameWindowWeaveBackground._set_background_wheel_visibility(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._widgets_by_name
	local var_7_1 = var_7_0.background_wheel_1
	local var_7_2 = var_7_0.hdr_background_wheel_1

	var_7_1.content.visible = arg_7_1
	var_7_2.content.visible = arg_7_1

	for iter_7_0 = 1, 2 do
		local var_7_3 = var_7_0["wheel_ring_" .. iter_7_0 .. "_1"]
		local var_7_4 = var_7_0["wheel_ring_" .. iter_7_0 .. "_2"]
		local var_7_5 = var_7_0["wheel_ring_" .. iter_7_0 .. "_3"]
		local var_7_6 = var_7_0["hdr_wheel_ring_" .. iter_7_0 .. "_1"]
		local var_7_7 = var_7_0["hdr_wheel_ring_" .. iter_7_0 .. "_2"]
		local var_7_8 = var_7_0["hdr_wheel_ring_" .. iter_7_0 .. "_3"]

		var_7_3.content.visible = arg_7_1
		var_7_4.content.visible = arg_7_1
		var_7_5.content.visible = arg_7_1
		var_7_6.content.visible = arg_7_1
		var_7_7.content.visible = arg_7_1
		var_7_8.content.visible = arg_7_1
	end

	arg_7_0._draw_background_wheel = arg_7_1
end

function StartGameWindowWeaveBackground._update_background_animations(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._widgets_by_name

	for iter_8_0 = 1, 2 do
		local var_8_1 = var_8_0["wheel_ring_" .. iter_8_0 .. "_1"]
		local var_8_2 = var_8_0["wheel_ring_" .. iter_8_0 .. "_2"]
		local var_8_3 = var_8_0["wheel_ring_" .. iter_8_0 .. "_3"]
		local var_8_4 = var_8_0["hdr_wheel_ring_" .. iter_8_0 .. "_1"]
		local var_8_5 = var_8_0["hdr_wheel_ring_" .. iter_8_0 .. "_2"]
		local var_8_6 = var_8_0["hdr_wheel_ring_" .. iter_8_0 .. "_3"]
		local var_8_7 = 360
		local var_8_8 = math.degrees_to_radians(var_8_7)
		local var_8_9 = arg_8_1 * 0.01
		local var_8_10 = arg_8_1 * 0.008
		local var_8_11 = arg_8_1 * 0.006

		var_8_1.style.texture_id.angle = (var_8_1.style.texture_id.angle + var_8_8 * var_8_9) % var_8_8
		var_8_2.style.texture_id.angle = (var_8_2.style.texture_id.angle - var_8_8 * var_8_10) % -var_8_8
		var_8_3.style.texture_id.angle = (var_8_3.style.texture_id.angle + var_8_8 * var_8_11) % var_8_8
		var_8_4.style.texture_id.angle = var_8_1.style.texture_id.angle
		var_8_5.style.texture_id.angle = var_8_2.style.texture_id.angle
		var_8_6.style.texture_id.angle = var_8_3.style.texture_id.angle
	end

	local var_8_12 = Managers.matchmaking:is_game_matchmaking()
	local var_8_13 = var_8_12 and 4 or 2.5
	local var_8_14 = 0.5 + math.sin(Managers.time:time("ui") * var_8_13) * 0.5

	arg_8_0:_set_background_bloom_intensity(var_8_14, var_8_12)
end

function StartGameWindowWeaveBackground._set_background_bloom_intensity(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = 1.39
	local var_9_1 = arg_9_2 and 10 or 2
	local var_9_2 = var_9_0 + math.clamp(arg_9_1, 0, 1) * var_9_1
	local var_9_3 = arg_9_0._ui_hdr_renderer.gui
	local var_9_4 = arg_9_0._widgets_by_name
	local var_9_5 = var_9_4.hdr_background_wheel_1.content.texture_id
	local var_9_6 = Gui.material(var_9_3, var_9_5)

	Material.set_scalar(var_9_6, "noise_intensity", var_9_2)

	for iter_9_0 = 1, 2 do
		local var_9_7 = var_9_4["hdr_wheel_ring_" .. iter_9_0 .. "_1"]
		local var_9_8 = var_9_4["hdr_wheel_ring_" .. iter_9_0 .. "_2"]
		local var_9_9 = var_9_4["hdr_wheel_ring_" .. iter_9_0 .. "_3"]
		local var_9_10 = var_9_7.content.texture_id
		local var_9_11 = var_9_8.content.texture_id
		local var_9_12 = var_9_9.content.texture_id
		local var_9_13 = Gui.material(var_9_3, var_9_10)
		local var_9_14 = Gui.material(var_9_3, var_9_11)
		local var_9_15 = Gui.material(var_9_3, var_9_12)

		Material.set_scalar(var_9_13, "noise_intensity", var_9_2)
		Material.set_scalar(var_9_14, "noise_intensity", var_9_2)
		Material.set_scalar(var_9_15, "noise_intensity", var_9_2)
	end
end

function StartGameWindowWeaveBackground._play_sound(arg_10_0, arg_10_1)
	arg_10_0._parent:play_sound(arg_10_1)
end

function StartGameWindowWeaveBackground._exit(arg_11_0, arg_11_1)
	arg_11_0.exit = true
	arg_11_0.exit_level_id = arg_11_1
end

function StartGameWindowWeaveBackground.draw(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._ui_renderer
	local var_12_1 = arg_12_0._ui_top_renderer
	local var_12_2 = arg_12_0._ui_hdr_renderer
	local var_12_3 = arg_12_0._ui_scenegraph
	local var_12_4 = arg_12_0._render_settings
	local var_12_5 = arg_12_0._parent:window_input_service()

	UIRenderer.begin_pass(var_12_1, var_12_3, var_12_5, arg_12_1, nil, var_12_4)

	for iter_12_0, iter_12_1 in ipairs(arg_12_0._top_widgets) do
		UIRenderer.draw_widget(var_12_1, iter_12_1)
	end

	UIRenderer.end_pass(var_12_1)
	UIRenderer.begin_pass(var_12_0, var_12_3, var_12_5, arg_12_1, nil, var_12_4)

	for iter_12_2, iter_12_3 in ipairs(arg_12_0._bottom_widgets) do
		UIRenderer.draw_widget(var_12_0, iter_12_3)
	end

	UIRenderer.end_pass(var_12_0)
	UIRenderer.begin_pass(var_12_2, var_12_3, var_12_5, arg_12_1, nil, var_12_4)

	for iter_12_4, iter_12_5 in ipairs(arg_12_0._bottom_hdr_widgets) do
		UIRenderer.draw_widget(var_12_2, iter_12_5)
	end

	UIRenderer.end_pass(var_12_2)
end

function StartGameWindowWeaveBackground._play_sound(arg_13_0, arg_13_1)
	arg_13_0._parent:play_sound(arg_13_1)
end

function StartGameWindowWeaveBackground._animate_pulse(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5))
end

function StartGameWindowWeaveBackground._animate_element_by_time(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, math.ease_out_quad))
end

function StartGameWindowWeaveBackground._animate_element_by_catmullrom(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8))
end

function StartGameWindowWeaveBackground._animate_wheel_position(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._parent:get_selected_layout_name()
	local var_17_1 = 3
	local var_17_2 = arg_17_0._wheel_position_progress or 0
	local var_17_3 = 0

	if var_17_0 == "weave" then
		var_17_2 = math.min(var_17_2 + var_17_1 * arg_17_1, 1)
		var_17_3 = math.easeOutCubic(var_17_2)
	else
		var_17_2 = math.max(var_17_2 - var_17_1 * arg_17_1, 0)
		var_17_3 = math.easeInCubic(var_17_2)
	end

	local var_17_4 = var_17_3 * 300
	local var_17_5 = var_17_3 * -100
	local var_17_6 = "background_wheel"
	local var_17_7 = 1
	local var_17_8 = arg_17_0._ui_scenegraph[var_17_6]
	local var_17_9 = var_0_4[var_17_6]
	local var_17_10 = var_17_8.position
	local var_17_11 = var_17_9.position

	var_17_10[var_17_7] = var_17_11[var_17_7] + var_17_4
	var_17_10[2] = var_17_11[2] + var_17_5
	arg_17_0._wheel_position_progress = var_17_2
end
