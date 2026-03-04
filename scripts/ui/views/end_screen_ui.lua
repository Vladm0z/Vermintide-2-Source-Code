-- chunkname: @scripts/ui/views/end_screen_ui.lua

local var_0_0 = local_require("scripts/ui/views/end_screen_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.animations
local var_0_3 = var_0_0.screens

for iter_0_0, iter_0_1 in pairs(var_0_3) do
	require(iter_0_1.file_name)
end

local var_0_4 = false

EndScreenUI = class(EndScreenUI)

function EndScreenUI.init(arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_top_renderer
	arg_1_0.world_manager = arg_1_1.world_manager
	arg_1_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._ingame_ui_context = arg_1_1

	local var_1_0 = arg_1_1.input_manager

	arg_1_0.input_manager = var_1_0

	var_1_0:create_input_service("end_screen_ui", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_0:map_device_to_service("end_screen_ui", "keyboard")
	var_1_0:map_device_to_service("end_screen_ui", "mouse")
	var_1_0:map_device_to_service("end_screen_ui", "gamepad")

	local var_1_1 = arg_1_0.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_1)

	arg_1_0:create_ui_elements()
end

function EndScreenUI.destroy(arg_2_0)
	arg_2_0.ui_animator = nil

	GarbageLeakDetector.register_object(arg_2_0, "EndScreenUI")
end

function EndScreenUI.create_ui_elements(arg_3_0)
	var_0_4 = false
	arg_3_0.draw_flags = {
		draw_text = false,
		banner_alpha_multiplier = 0,
		draw_background = false
	}
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_3_0.background_rect_widget = UIWidget.init(var_0_0.widgets.background_rect)

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_2)
end

function EndScreenUI.input_service(arg_4_0)
	return arg_4_0.input_manager:get_service("end_screen_ui")
end

function EndScreenUI.on_enter(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = var_0_3[arg_5_1]

	fassert(var_5_0, "Unknown screen name: %s", arg_5_1)

	local var_5_1 = arg_5_0.input_manager

	if not Managers.chat:chat_is_focused() then
		var_5_1:block_device_except_service("end_screen_ui", "mouse")
		var_5_1:block_device_except_service("end_screen_ui", "keyboard")
		var_5_1:block_device_except_service("end_screen_ui", "gamepad", 1)
	end

	arg_5_0:play_sound("mute_all_world_sounds")
	Wwise.set_state("override", "false")

	if arg_5_2 and arg_5_2.display_screen_delay then
		arg_5_0._delayed_screen_data = {
			display_t = Managers.time:time("ui") + arg_5_2.display_screen_delay,
			screen_definition = var_5_0,
			screen_context = arg_5_2,
			screen_params = arg_5_3
		}
	else
		arg_5_0:_create_screen(var_5_0, arg_5_2, arg_5_3)
	end
end

function EndScreenUI._create_screen(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.is_active = true

	arg_6_0:_fade_in_background()

	local var_6_0 = arg_6_0:input_service()
	local var_6_1 = arg_6_1.class_name

	arg_6_0._screen = rawget(_G, var_6_1):new(arg_6_0._ingame_ui_context, var_6_0, arg_6_2, arg_6_3)

	arg_6_0._screen:on_fade_in()
end

function EndScreenUI.on_exit(arg_7_0)
	local var_7_0 = arg_7_0.draw_flags

	arg_7_0.is_active = false

	if not Managers.chat:chat_is_focused() then
		local var_7_1 = arg_7_0.input_manager

		var_7_1:device_unblock_all_services("mouse", 1)
		var_7_1:device_unblock_all_services("keyboard", 1)
		var_7_1:device_unblock_all_services("gamepad", 1)
	end

	Managers.music:unduck_sounds()
end

function EndScreenUI.on_complete(arg_8_0)
	arg_8_0.is_complete = true
end

function EndScreenUI.fade_in_complete(arg_9_0)
	return arg_9_0._fade_in_completed
end

function EndScreenUI._fade_in_background(arg_10_0)
	arg_10_0.background_in_anim_id = arg_10_0.ui_animator:start_animation("fade_in_background", {
		arg_10_0.background_rect_widget
	}, var_0_1, arg_10_0.draw_flags)
end

function EndScreenUI.update(arg_11_0, arg_11_1, arg_11_2)
	if var_0_4 then
		arg_11_0:create_ui_elements()
	end

	local var_11_0 = arg_11_0._delayed_screen_data

	if var_11_0 then
		if arg_11_2 > var_11_0.display_t then
			arg_11_0._delayed_screen_data = nil

			arg_11_0:_create_screen(var_11_0.screen_definition, var_11_0.screen_context, var_11_0.screen_params)
		end

		return
	end

	if not arg_11_0.is_active then
		return
	end

	local var_11_1 = arg_11_0._screen

	var_11_1:update(arg_11_1, arg_11_2)

	local var_11_2 = arg_11_0.ui_animator

	var_11_2:update(arg_11_1)

	if arg_11_0.background_in_anim_id then
		if var_11_2:is_animation_completed(arg_11_0.background_in_anim_id) then
			arg_11_0.background_in_anim_id = nil
			arg_11_0._fade_in_completed = true

			var_11_1:start()
		end
	elseif var_11_1:started() and var_11_1:completed() and not Managers.backend:is_pending_request() then
		Managers.transition:fade_in(GameSettings.transition_fade_in_speed, callback(arg_11_0, "on_complete"))
	end

	arg_11_0:draw(arg_11_1)
end

function EndScreenUI.draw(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0.ui_scenegraph
	local var_12_2 = arg_12_0.input_manager:get_service("end_screen_ui")
	local var_12_3 = arg_12_0.draw_flags
	local var_12_4 = arg_12_0.render_settings

	UIRenderer.begin_pass(var_12_0, var_12_1, var_12_2, arg_12_1, nil, var_12_4)

	if var_12_3.draw_background then
		UIRenderer.draw_widget(var_12_0, arg_12_0.background_rect_widget)
	end

	UIRenderer.end_pass(var_12_0)
	arg_12_0._screen:draw(arg_12_1)
end

function EndScreenUI.play_sound(arg_13_0, arg_13_1)
	WwiseWorld.trigger_event(arg_13_0.wwise_world, arg_13_1)
end
