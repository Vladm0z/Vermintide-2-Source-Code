-- chunkname: @scripts/ui/views/unlock_key_view.lua

local var_0_0 = local_require("scripts/ui/views/unlock_key_view_definitions")

UnlockKeyView = class(UnlockKeyView)

function UnlockKeyView.init(arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.world = arg_1_1.world
	arg_1_0.statistics_db = arg_1_1.statistics_db
	arg_1_0.wwise_world = arg_1_1.dialogue_system.wwise_world

	local var_1_0 = arg_1_0.input_manager

	var_1_0:create_input_service("unlock_key_menu", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_0:map_device_to_service("unlock_key_menu", "keyboard")
	var_1_0:map_device_to_service("unlock_key_menu", "mouse")
	var_1_0:map_device_to_service("unlock_key_menu", "gamepad")
	rawset(_G, "global_unlock_key_view", arg_1_0)

	arg_1_0.ui_animations = {}

	arg_1_0:create_ui_elements()

	arg_1_0.controller_cooldown = 0
end

function UnlockKeyView.input_service(arg_2_0)
	return arg_2_0.input_manager:get_service("unlock_key_menu")
end

function UnlockKeyView.destroy(arg_3_0)
	rawset(_G, "global_unlock_key_view", nil)
	GarbageLeakDetector.register_object(arg_3_0, "UnlockKeyView")
end

local var_0_1 = var_0_0.widget_definitions
local var_0_2 = var_0_0.create_simple_texture_widget
local var_0_3 = 0

function UnlockKeyView.create_ui_elements(arg_4_0)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_4_0.background_widgets = {
		var_0_2("unlock_key_bg", "key_entry_background"),
		var_0_2("title_bar", "unlock_key_title_background")
	}
	arg_4_0.confirm_gamepad_button_widget = UIWidget.init(var_0_1.confirm_gamepad_button_widget)
	arg_4_0.back_gamepad_button_widget = UIWidget.init(var_0_1.back_gamepad_button_widget)
	arg_4_0.processing_icon_widget = UIWidget.init(var_0_1.processing_icon)
	arg_4_0.text_input_widget = UIWidget.init(var_0_1.text_input)
	arg_4_0.accept_button_widget = UIWidget.init(var_0_1.accept_button)
	arg_4_0.cancel_button_widget = UIWidget.init(var_0_1.cancel_button)
	arg_4_0.title_widget = UIWidget.init(var_0_1.title)
	arg_4_0.confirm_gamepad_button_widget.content.text_field = "Select"
	arg_4_0.back_gamepad_button_widget.content.text_field = "Exit"
end

function UnlockKeyView.on_enter(arg_5_0)
	arg_5_0.input_manager:block_device_except_service("unlock_key_menu", "keyboard", 1)
	arg_5_0.input_manager:block_device_except_service("unlock_key_menu", "mouse", 1)
	arg_5_0.input_manager:block_device_except_service("unlock_key_menu", "gamepad", 1)

	arg_5_0.fade_in_done = false

	Managers.transition:fade_in(10, function()
		arg_5_0.fade_in_done = true
	end)

	arg_5_0.ui_animations.entry_animation = UIAnimation.init(UIAnimation.function_by_time, arg_5_0.ui_scenegraph.root.local_position, 2, 1080, 1080, 0.01, math.easeInCubic, UIAnimation.wait, 0.1, UIAnimation.function_by_time, arg_5_0.ui_scenegraph.root.local_position, 2, 1080, 0, 0.01, math.easeInCubic)
	arg_5_0.key_text = ""
	arg_5_0.key_text_index = 1
	arg_5_0.text_mode = "insert"
	arg_5_0.text_input_widget.content.caret_index = 1
	arg_5_0.text_input_widget.content.text_index = 1
	arg_5_0.transition_on_completed_animation = nil
end

function UnlockKeyView.on_exit(arg_7_0)
	return
end

function UnlockKeyView.suspend(arg_8_0)
	arg_8_0.suspended = true

	arg_8_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_8_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_8_0.input_manager:device_unblock_all_services("gamepad", 1)
end

function UnlockKeyView.unsuspend(arg_9_0)
	arg_9_0.input_manager:block_device_except_service("unlock_key_menu", "keyboard", 1)
	arg_9_0.input_manager:block_device_except_service("unlock_key_menu", "mouse", 1)
	arg_9_0.input_manager:block_device_except_service("unlock_key_menu", "gamepad", 1)

	arg_9_0.suspended = nil
end

function UnlockKeyView.update(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0.suspended then
		return
	end

	local var_10_0 = arg_10_0.ui_renderer
	local var_10_1 = arg_10_0.ui_scenegraph
	local var_10_2 = arg_10_0.input_manager:get_service("unlock_key_menu")
	local var_10_3 = arg_10_0.ui_animations.entry_animation or arg_10_0.ui_animations.exit_animation

	for iter_10_0, iter_10_1 in pairs(arg_10_0.ui_animations) do
		UIAnimation.update(iter_10_1, arg_10_1)

		if iter_10_0 ~= "exit_animation" and UIAnimation.completed(iter_10_1) then
			arg_10_0.ui_animations[iter_10_0] = nil

			if iter_10_0 == "entry_animation" then
				Managers.transition:fade_out(10)
			end
		end
	end

	if arg_10_0.ui_animations.exit_animation and UIAnimation.completed(arg_10_0.ui_animations.exit_animation) then
		Managers.transition:fade_out(10, nil)

		arg_10_0.ui_animations.exit_animation = nil

		local var_10_4 = arg_10_0.transition_on_completed_animation

		if var_10_4 then
			arg_10_0.ingame_ui:handle_transition(var_10_4)

			arg_10_0.transition_on_completed_animation = nil
		end
	end

	if arg_10_0.fade_in_done then
		arg_10_0:draw_widgets(arg_10_1, arg_10_2)
	end

	if not var_10_3 then
		arg_10_0:handle_input(var_10_2)
		arg_10_0:handle_controller_input(var_10_2, arg_10_1)
	end

	if not var_10_3 and (var_10_2:get("toggle_menu") or arg_10_0.cancel_button_widget.content.button_hotspot.on_release) then
		arg_10_0:exit()
	end
end

function UnlockKeyView.exit(arg_11_0)
	arg_11_0:on_menu_close()
	Managers.transition:fade_in(10)

	arg_11_0.ui_animations.exit_animation = UIAnimation.init(UIAnimation.wait, 0.2)
	arg_11_0.transition_on_completed_animation = "exit_menu"
end

function UnlockKeyView.draw_widgets(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0.ui_scenegraph
	local var_12_2 = arg_12_0.input_manager:get_service("unlock_key_menu")
	local var_12_3 = Managers.input:get_device("gamepad").active()

	UIRenderer.begin_pass(var_12_0, var_12_1, var_12_2, arg_12_1)

	for iter_12_0, iter_12_1 in ipairs(arg_12_0.background_widgets) do
		UIRenderer.draw_widget(var_12_0, iter_12_1)
	end

	if var_12_3 then
		UIRenderer.draw_widget(var_12_0, arg_12_0.confirm_gamepad_button_widget)
		UIRenderer.draw_widget(var_12_0, arg_12_0.back_gamepad_button_widget)
	end

	local var_12_4 = arg_12_0.text_input_widget

	var_12_4.content.text_field = arg_12_0.key_text
	var_12_4.content.caret_index = arg_12_0.key_text_index

	local var_12_5 = (1 + math.sin(arg_12_2 * 3 % math.pi)) / 2

	var_12_4.style.text.caret_color[1] = var_12_5 * 255

	UIRenderer.draw_widget(var_12_0, var_12_4)
	UIRenderer.draw_widget(var_12_0, arg_12_0.processing_icon_widget)
	UIRenderer.draw_widget(var_12_0, arg_12_0.accept_button_widget)
	UIRenderer.draw_widget(var_12_0, arg_12_0.cancel_button_widget)
	UIRenderer.draw_widget(var_12_0, arg_12_0.title_widget)
	UIRenderer.end_pass(var_12_0)
end

function UnlockKeyView.handle_input(arg_13_0, arg_13_1)
	local var_13_0 = Keyboard.keystrokes()

	arg_13_0.key_text, arg_13_0.key_text_index, arg_13_0.text_mode = KeystrokeHelper.parse_strokes(arg_13_0.key_text, arg_13_0.key_text_index, arg_13_0.text_mode, var_13_0)
	arg_13_0.key_text = TextToUpper(arg_13_0.key_text)

	if arg_13_0.accept_button_widget.content.button_hotspot.on_release then
		local var_13_1 = arg_13_0.available_unlock_keys
		local var_13_2 = #var_13_1

		for iter_13_0 = 1, var_13_2 do
			local var_13_3 = var_13_1[iter_13_0]

			if arg_13_0.key_text == var_13_3 then
				print("HAIL TO THE KING BABY")
			else
				print("INVALID KEY YOU INVALID")
			end
		end
	end
end

function UnlockKeyView.handle_controller_input(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_0.controller_cooldown > 0 then
		arg_14_0.controller_cooldown = arg_14_0.controller_cooldown - arg_14_2
	else
		repeat
			if arg_14_0.confirm_gamepad_button_widget.content.gamepad_button.is_clicked == 0 or arg_14_0.confirm_gamepad_button_widget.content.button_hotspot.is_clicked == 0 then
				break
			end

			if arg_14_0.back_gamepad_button_widget.content.gamepad_button.is_clicked == 0 or arg_14_0.back_gamepad_button_widget.content.button_hotspot.is_clicked == 0 then
				arg_14_0.controller_cooldown = GamepadSettings.menu_cooldown
			end

			break
		until true
	end
end

function UnlockKeyView.on_reset(arg_15_0)
	return
end

function UnlockKeyView.on_apply(arg_16_0)
	return
end

function UnlockKeyView.on_menu_close(arg_17_0)
	return
end

if rawget(_G, "my_global_ass_pointer") then
	my_global_ass_pointer:create_ui_elements()
end
