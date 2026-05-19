-- chunkname: @scripts/ui/views/chat_gui.lua

require("scripts/utils/keystroke_helper")

local var_0_0 = local_require("scripts/ui/views/chat_gui_definitions")

ChatGui = class(ChatGui)
ChatGui.MAX_CHARS = 500

function ChatGui.init(arg_1_0, arg_1_1)
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.ui_renderer = arg_1_1.ui_top_renderer
	arg_1_0.chat_manager = arg_1_1.chat_manager
	arg_1_0._render_settings = {
		alpha_multiplier = 1
	}
	arg_1_0._keystrokes = {}
	arg_1_0.chat_message = ""
	arg_1_0.chat_index = 1
	arg_1_0.chat_mode = "insert"
	arg_1_0.chat_messages = {}

	rawset(_G, "global_chat_gui", arg_1_0)

	arg_1_0.ui_animations = {}

	arg_1_0:create_ui_elements()

	arg_1_0.block_chat_activation_hack = 0
	arg_1_0.menu_active = false
	arg_1_0.chat_closed = true
	arg_1_0.chat_focused = false
	arg_1_0.chat_close_time = 0

	local var_1_0

	if LEVEL_EDITOR_TEST then
		var_1_0 = DefaultUserSettings.get("user_settings", "chat_font_size")
	else
		var_1_0 = Application.user_setting("chat_font_size")
	end

	arg_1_0:set_font_size(var_1_0)
	arg_1_0:_set_chat_window_alpha(0)
end

function ChatGui.set_profile_synchronizer(arg_2_0, arg_2_1)
	arg_2_0.profile_synchronizer = arg_2_1
end

function ChatGui.set_wwise_world(arg_3_0, arg_3_1)
	arg_3_0.wwise_world = arg_3_1
end

function ChatGui.set_input_manager(arg_4_0, arg_4_1)
	if arg_4_1 then
		local var_4_0 = {
			keybind = true,
			irc_chat = true,
			debug_screen = true,
			popup = true,
			twitch = true,
			free_flight = true
		}

		arg_4_1:create_input_service("chat_input", "ChatControllerSettings", "ChatControllerFilters", var_4_0)
		arg_4_1:map_device_to_service("chat_input", "keyboard")
		arg_4_1:map_device_to_service("chat_input", "mouse")
	end

	arg_4_0.input_manager = arg_4_1
end

local var_0_1 = true

function ChatGui.create_ui_elements(arg_5_0)
	UIRenderer.clear_scenegraph_queue(arg_5_0.ui_renderer)

	arg_5_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_5_0.chat_window_widget = UIWidget.init(var_0_0.chat_window_widget)
	arg_5_0.chat_output_widget = UIWidget.init(var_0_0.chat_output_widget)
	arg_5_0.chat_input_widget = UIWidget.init(var_0_0.chat_input_widget)
	arg_5_0.scrollbar_widget = UIWidget.init(var_0_0.chat_scrollbar_widget)
	arg_5_0.tab_widget = UIWidget.init(var_0_0.chat_tab_widget)
	arg_5_0._widgets = {}

	for iter_5_0, iter_5_1 in pairs(var_0_0.widgets) do
		arg_5_0._widgets[iter_5_0] = UIWidget.init(iter_5_1)
	end

	arg_5_0.ui_animations.caret_pulse = arg_5_0:animate_element_pulse(arg_5_0.chat_input_widget.style.text.caret_color, 1, 60, 255, 2)

	if var_0_1 then
		local var_5_0

		if LEVEL_EDITOR_TEST then
			var_5_0 = DefaultUserSettings.get("user_settings", "chat_font_size")
		else
			var_5_0 = Application.user_setting("chat_font_size")
		end

		arg_5_0:set_font_size(var_5_0)
		arg_5_0:set_menu_transition_fraction(0)
	end

	var_0_1 = false
end

function ChatGui.clear_messages(arg_6_0)
	arg_6_0.chat_output_widget = UIWidget.init(var_0_0.chat_output_widget)
end

function ChatGui.animate_element_pulse(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5))
end

function ChatGui.animate_element_by_time(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, math.ease_out_quad))
end

function ChatGui.destroy(arg_9_0)
	rawset(_G, "global_chat_gui", nil)

	if arg_9_0.chat_focused then
		arg_9_0:unblock_input()

		arg_9_0.chat_focused = false
	end
end

function ChatGui.ignoring_peer_id(arg_10_0, arg_10_1)
	return arg_10_0.chat_manager:ignoring_peer_id(arg_10_1)
end

function ChatGui.ignore_peer_id(arg_11_0, arg_11_1)
	arg_11_0.chat_manager:ignore_peer_id(arg_11_1)
end

function ChatGui.remove_ignore_peer_id(arg_12_0, arg_12_1)
	arg_12_0.chat_manager:remove_ignore_peer_id(arg_12_1)
end

function ChatGui.set_font_size(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.ui_scenegraph
	local var_13_1 = var_0_0.scenegraph_definition
	local var_13_2 = 0
	local var_13_3 = arg_13_1 + 20

	var_13_0.chat_input_text.size[2] = var_13_3
	var_13_0.chat_input_box.size[2] = var_13_3
	arg_13_0.chat_output_widget.style.text.font_size = arg_13_1
	arg_13_0.chat_input_widget.style.text.font_size = arg_13_1
	arg_13_0.chat_input_widget.style.channel_text.font_size = arg_13_1

	local var_13_4, var_13_5 = UIFontByResolution(arg_13_0.chat_input_widget.style.text)
	local var_13_6 = arg_13_0.chat_input_widget.style.text.font_type
	local var_13_7, var_13_8, var_13_9 = UIGetFontHeight(arg_13_0.ui_renderer.gui, var_13_6, var_13_5)
	local var_13_10 = var_13_3 / 2 + math.abs(var_13_8 / 2) - var_13_7 / 2

	arg_13_0.chat_input_widget.style.text.offset[2] = var_13_10
	arg_13_0.chat_input_widget.style.text.caret_size[2] = var_13_7
	var_13_0[arg_13_0.chat_output_widget.style.text.scenegraph_id].size[2] = var_0_0.CHAT_HEIGHT - arg_13_1 - var_13_2
	var_13_0[arg_13_0.chat_output_widget.style.text.scenegraph_id].position[2] = var_13_2 * 0.5
end

local var_0_2 = {
	registry_key = "chat_gui",
	drag_scenegraph_id = "root_dragger",
	root_scenegraph_id = "root",
	label = "Chat",
	use_plain_rects = true
}

function ChatGui.update(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	if var_0_1 then
		arg_14_0:create_ui_elements()
	end

	HudCustomizer.run(arg_14_0.ui_renderer, arg_14_0.ui_scenegraph, var_0_2)
	arg_14_0:update_transition(arg_14_1)

	local var_14_0 = arg_14_0:_update_chat_messages()
	local var_14_1 = arg_14_0.ui_scenegraph
	local var_14_2 = arg_14_0.ui_animations

	if not arg_14_0.menu_active and arg_14_2 then
		if arg_14_0.chat_focused then
			arg_14_0.chat_focused = true
			arg_14_0.chat_closed = false

			arg_14_0:clear_current_transition()
			arg_14_0:set_menu_transition_fraction(1)
			arg_14_0:_set_chat_window_alpha(1)

			arg_14_0.tab_widget.style.button_notification.color[1] = UISettings.chat.tab_notification_alpha_2
		else
			arg_14_0.chat_closed = true
			arg_14_0.chat_focused = false
			arg_14_0.chat_close_time = 0

			arg_14_0:clear_current_transition()
			arg_14_0:set_menu_transition_fraction(0)
			arg_14_0:_set_chat_window_alpha(1)

			arg_14_0.tab_widget.style.button_notification.color[1] = UISettings.chat.tab_notification_alpha_1
		end
	elseif arg_14_0.menu_active and not arg_14_2 then
		if arg_14_0.chat_focused then
			arg_14_0.chat_focused = true
			arg_14_0.chat_closed = false

			arg_14_0:clear_current_transition()
			arg_14_0:_set_chat_window_alpha(1)
			arg_14_0:set_menu_transition_fraction(1)

			var_14_2.notification_pulse = nil
		else
			arg_14_0.chat_closed = true
			arg_14_0.chat_focused = false
			arg_14_0.chat_close_time = 0

			arg_14_0:clear_current_transition()
			arg_14_0:_set_chat_window_alpha(0)

			var_14_2.notification_pulse = nil
		end
	end

	arg_14_0.menu_active = arg_14_2

	local var_14_3 = arg_14_0.input_manager:get_service("chat_input")
	local var_14_4, var_14_5, var_14_6 = arg_14_0:_update_input(var_14_3, arg_14_3, arg_14_1, arg_14_4, arg_14_5)

	if var_14_0 and not arg_14_2 then
		var_14_5 = false

		if not var_14_4 and not arg_14_0.keep_chat_visible then
			var_14_6 = UISettings.chat.chat_close_delay
		end
	end

	if var_14_6 and var_14_6 > 0 then
		var_14_6 = var_14_6 - arg_14_1

		if var_14_6 < 0 then
			var_14_6 = 0
		end
	end

	if arg_14_2 then
		if arg_14_0.chat_closed and not var_14_5 then
			arg_14_0:menu_open()
		elseif not arg_14_0.chat_closed and var_14_5 then
			arg_14_0:menu_close()
		end

		if var_14_5 and var_14_0 then
			if arg_14_0.wwise_world then
				WwiseWorld.trigger_event(arg_14_0.wwise_world, "hud_chat_message")
			end

			if not var_14_2.notification_pulse then
				local var_14_7 = UISettings.chat
				local var_14_8 = var_14_7.tab_notification_alpha_1
				local var_14_9 = var_14_7.tab_notification_alpha_2

				var_14_2.notification_pulse = arg_14_0:animate_element_pulse(arg_14_0.tab_widget.style.button_notification.color, 1, var_14_8, var_14_9, 5)
			end
		end
	elseif var_14_0 or not arg_14_0.chat_focused and var_14_4 or arg_14_0.chat_closed and not var_14_5 then
		arg_14_0:clear_current_transition()
		arg_14_0:set_menu_transition_fraction(1)
		arg_14_0:_set_chat_window_alpha(1)
	end

	if arg_14_0.chat_focused ~= var_14_4 then
		if var_14_4 then
			arg_14_0:block_input()
		else
			arg_14_0:unblock_input()
		end
	end

	arg_14_0.chat_focused = var_14_4
	arg_14_0.chat_closed = var_14_5
	arg_14_0.chat_close_time = var_14_6

	local var_14_10 = arg_14_3 or var_14_3

	if arg_14_0.chat_focused then
		var_14_10 = var_14_3
	end

	arg_14_0:_update_hud_scale()
	arg_14_0:_draw_widgets(arg_14_1, var_14_10, arg_14_5)
end

function ChatGui._update_chat_messages(arg_15_0)
	if Managers.chat:gui_should_clear() then
		arg_15_0:clear_messages()
	end

	local var_15_0 = FrameTable.alloc_table()

	arg_15_0.chat_manager:get_chat_messages(var_15_0)

	local var_15_1 = 30
	local var_15_2 = #var_15_0
	local var_15_3 = false

	if var_15_2 > 0 then
		local var_15_4 = arg_15_0.chat_output_widget.content.message_tables
		local var_15_5 = #var_15_4

		if var_15_1 < var_15_2 + var_15_5 then
			local var_15_6 = var_15_2 + var_15_5 - var_15_1

			for iter_15_0 = 1, var_15_6 do
				table.remove(var_15_4, 1)
			end
		end

		local var_15_7 = #var_15_4

		for iter_15_1 = 1, var_15_2 do
			local var_15_8 = var_15_0[iter_15_1]
			local var_15_9 = {}

			if var_15_8.type ~= Irc.PARTY_MSG and var_15_8.type ~= Irc.ALL_MSG and var_15_8.type ~= Irc.TEAM_MSG then
				local var_15_10 = var_15_8.message

				if var_15_8.is_system_message then
					var_15_9.is_system = true
					var_15_9.sender = var_15_8.message_sender .. ": "
				else
					if var_15_8.type == Irc.CHANNEL_MSG and var_15_8.data then
						var_15_9.sender = "[" .. var_15_8.data.parameter .. "] " .. var_15_8.message_sender .. ": "
						var_15_9.trimmed_sender = "[" .. var_15_8.data.parameter .. "] " .. string.sub(var_15_8.message_sender, 1, -11) .. ": "
					elseif var_15_8.type == Irc.PRIVATE_MSG then
						var_15_9.sender = var_15_8.message_sender .. ": "
						var_15_9.trimmed_sender = string.sub(var_15_8.message_sender, 1, -11) .. ": "
					else
						var_15_9.sender = var_15_8.message_sender .. ": "
					end

					var_15_9.is_system = false
				end

				var_15_9.is_dev = var_15_8.is_dev
				var_15_9.is_enemy = var_15_8.is_enemy
				var_15_9.is_bot = var_15_8.is_bot
				var_15_9.message = var_15_10
				var_15_9.type = var_15_8.type

				if var_15_8.link then
					var_15_9.link = var_15_8.link
				end

				var_15_3 = var_15_8.pop_chat
			else
				local var_15_11 = var_15_8.message_sender
				local var_15_12 = Managers.player:player(var_15_11, var_15_8.local_player_id)
				local var_15_13
				local var_15_14

				if var_15_12 then
					local var_15_15 = arg_15_0.profile_synchronizer:profile_by_peer(var_15_12.peer_id, var_15_12:local_player_id())

					var_15_13 = SPProfiles[var_15_15] and SPProfiles[var_15_15].ingame_short_display_name or nil
					var_15_14 = var_15_12:name()
				else
					var_15_14 = rawget(_G, "Steam") and Steam.user_name(var_15_11) or tostring(var_15_11)
				end

				local var_15_16 = var_15_8.message

				var_15_9.is_dev = var_15_8.is_dev
				var_15_9.is_enemy = var_15_8.is_enemy
				var_15_9.is_bot = var_15_8.is_bot
				var_15_9.is_system = false
				var_15_9.sender = var_15_13 and string.format("%s (%s): ", var_15_14, Localize(var_15_13)) or string.format("%s: ", var_15_14)
				var_15_9.message = var_15_16
				var_15_9.type = var_15_8.type

				local var_15_17 = arg_15_0.chat_manager.message_targets

				for iter_15_2, iter_15_3 in ipairs(var_15_17) do
					if iter_15_3.message_target_type == var_15_8.type then
						if iter_15_3.message_target_key then
							var_15_9.channel_string = string.format("[%s] ", Localize(iter_15_3.message_target_key))
						end

						break
					end
				end

				var_15_3 = true
			end

			var_15_4[var_15_7 + iter_15_1] = var_15_9
		end
	end

	return var_15_3
end

function ChatGui.show_chat(arg_16_0)
	arg_16_0:clear_current_transition()
	arg_16_0:set_menu_transition_fraction(1)
	arg_16_0:_set_chat_window_alpha(1)

	arg_16_0.chat_closed = false
	arg_16_0.chat_focused = false
	arg_16_0.chat_close_time = nil
	arg_16_0.keep_chat_visible = true
	arg_16_0.scrollbar_widget.content.internal_scroll_value = 0
end

function ChatGui.hide_chat(arg_17_0)
	arg_17_0:clear_current_transition()
	arg_17_0:set_menu_transition_fraction(0)
	arg_17_0:_set_chat_window_alpha(0)

	arg_17_0.chat_closed = true
	arg_17_0.chat_focused = false
	arg_17_0.chat_close_time = nil
	arg_17_0.keep_chat_visible = false
end

function ChatGui.menu_open(arg_18_0)
	arg_18_0:clear_current_transition()

	local var_18_0 = UISettings.chat

	arg_18_0.ui_animations.notification_pulse = nil
	arg_18_0.tab_widget.style.button_notification.color[1] = var_18_0.tab_notification_alpha_1
	arg_18_0.opening = true
	arg_18_0.transition_timer = 0
end

function ChatGui.menu_close(arg_19_0)
	arg_19_0:clear_current_transition()

	arg_19_0.closing = true
	arg_19_0.transition_timer = 0
end

function ChatGui.set_menu_transition_fraction(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.ui_scenegraph
	local var_20_1 = var_0_0.scenegraph_definition
	local var_20_2 = arg_20_0.chat_window_widget.scenegraph_id
	local var_20_3 = var_20_1[var_20_2]

	var_20_0[var_20_2].size[1] = var_20_3.size[1] * arg_20_1
end

function ChatGui.update_transition(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.transition_timer

	if not var_21_0 then
		return
	end

	local var_21_1 = 0.2
	local var_21_2 = math.min(var_21_0 + arg_21_1, var_21_1)
	local var_21_3 = var_21_2 / var_21_1

	if arg_21_0.opening then
		arg_21_0:set_menu_transition_fraction(var_21_3)
	elseif arg_21_0.closing then
		arg_21_0:set_menu_transition_fraction(1 - var_21_3)
	end

	if var_21_3 == 1 then
		arg_21_0.transition_timer = nil

		if arg_21_0.opening then
			arg_21_0.opening = nil
		elseif arg_21_0.closing then
			arg_21_0.closing = nil
		end
	else
		arg_21_0.transition_timer = var_21_2
	end
end

function ChatGui.clear_current_transition(arg_22_0)
	arg_22_0.opening = nil
	arg_22_0.closing = nil
	arg_22_0.transition_timer = nil
end

function ChatGui.block_input(arg_23_0)
	arg_23_0.input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "chat_input", "ChatGui")
	arg_23_0:_show_cursor()
	Window.set_ime_enabled(true)
end

function ChatGui.unblock_input(arg_24_0)
	Window.set_ime_enabled(false)

	if arg_24_0.input_manager then
		arg_24_0.input_manager:release_input({
			"keyboard",
			"gamepad",
			"mouse"
		}, 1, "chat_input", "ChatGui")
	end

	arg_24_0:_hide_cursor()
end

function ChatGui._show_cursor(arg_25_0)
	if not arg_25_0._cursor_visible then
		arg_25_0._cursor_visible = true

		ShowCursorStack.show("ChatGui")
	end
end

function ChatGui._hide_cursor(arg_26_0)
	if arg_26_0._cursor_visible then
		arg_26_0._cursor_visible = false

		ShowCursorStack.hide("ChatGui")
	end
end

function ChatGui.block_chat_input_for_one_frame(arg_27_0)
	arg_27_0._block_keystrokes = true
end

function ChatGui._update_input(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	local var_28_0 = arg_28_0.chat_focused
	local var_28_1 = arg_28_0.chat_closed
	local var_28_2 = arg_28_0.chat_close_time
	local var_28_3 = arg_28_0.tab_widget.content.button_hotspot
	local var_28_4 = arg_28_0.scrollbar_widget

	if arg_28_1:get("unallowed_activate_chat_input") then
		arg_28_0.block_chat_activation_hack = 0
	else
		arg_28_0.block_chat_activation_hack = arg_28_0.block_chat_activation_hack + arg_28_3
	end

	local var_28_5 = arg_28_0.block_chat_activation_hack < 0.2 or not arg_28_5 or arg_28_0._block_keystrokes

	arg_28_0._block_keystrokes = false

	local var_28_6 = var_28_1

	if var_28_1 then
		local var_28_7 = arg_28_1:get("execute_alt_chat_input")

		if var_28_3.on_release or (arg_28_1:get("activate_chat_input") or arg_28_1:get("execute_chat_input") or var_28_7) and not var_28_5 and GameSettingsDevelopment.allow_chat_input then
			if arg_28_5 then
				var_28_6 = false
				var_28_2 = nil
				var_28_0 = true
			else
				var_28_6 = false
				var_28_2 = UISettings.chat.chat_close_delay
				var_28_0 = false
				arg_28_0._refocus_chat_window = true
			end

			arg_28_0.chat_message = ""
			arg_28_0.chat_index = 1
			arg_28_0.chat_mode = "insert"

			local var_28_8 = 1
			local var_28_9
			local var_28_10 = Managers.mechanism:game_mechanism()

			if var_28_10.get_chat_channel then
				local var_28_11 = Network.peer_id()

				var_28_8, var_28_9 = var_28_10:get_chat_channel(var_28_11, var_28_7)
			end

			arg_28_0.channel_id = var_28_8 or 1
			arg_28_0.alt_chat_input = var_28_7

			if var_28_9 then
				Managers.chat:set_message_target_type(var_28_9)
			end

			local var_28_12 = Managers.chat:current_message_target()
			local var_28_13

			if var_28_12.message_target_key then
				var_28_13 = string.format("[%s] ", Localize(var_28_12.message_target_key))
			else
				var_28_13 = string.format("[%s] ", var_28_12.message_target)
			end

			local var_28_14, var_28_15 = UIFontByResolution(arg_28_0.chat_input_widget.style.channel_text)
			local var_28_16, var_28_17, var_28_18 = UIRenderer.text_size(arg_28_0.ui_renderer, var_28_13, var_28_14[1], var_28_15)

			arg_28_0.chat_input_widget.content.channel_field = var_28_13

			local var_28_19 = IRC_CHANNEL_COLORS[var_28_12.message_target_type]
			local var_28_20 = arg_28_0.chat_input_widget.style.channel_text.text_color

			arg_28_0:_apply_color_values(var_28_20, var_28_19)

			arg_28_0.ui_scenegraph.chat_input_text.size[1] = var_0_0.CHAT_INPUT_TEXT_WIDTH - var_28_16
			arg_28_0.chat_input_widget.style.text.offset[1] = arg_28_0.chat_input_widget.style.channel_text.offset[1] + var_28_16
			arg_28_0.chat_input_widget.content.caret_index = 1
			arg_28_0.chat_input_widget.content.text_index = 1
		end

		var_28_4.content.internal_scroll_value = 0
	else
		local var_28_21 = false

		if arg_28_0.menu_active and arg_28_1:get("left_release") then
			local var_28_22 = UIInverseScaleVectorToResolution(arg_28_1:get("cursor"))
			local var_28_23 = UISceneGraph.get_world_position(arg_28_0.ui_scenegraph, "chat_window_background")
			local var_28_24 = UISceneGraph.get_size(arg_28_0.ui_scenegraph, "chat_window_background")

			if not math.point_is_inside_2d_box(var_28_22, var_28_23, var_28_24) then
				var_28_21 = true
			end
		end

		local var_28_25 = var_28_2 and var_28_2 == 0 or not arg_28_5

		if var_28_3.on_release or arg_28_1:get("deactivate_chat_input") and not var_28_5 or var_28_21 or var_28_25 then
			if var_28_0 and (var_28_3.on_release or arg_28_1:get("deactivate_chat_input") and not var_28_5 or var_28_21) then
				table.clear(var_28_3)
			end

			var_28_6 = true
			var_28_2 = 0
			var_28_0 = false
			arg_28_0.recent_message_index = nil
			arg_28_0.old_chat_message = nil
		end

		var_28_3.on_release = false

		if var_28_0 and arg_28_5 then
			if GameSettingsDevelopment.allow_chat_input and arg_28_1:get("execute_chat_input") then
				var_28_6 = false
				var_28_0 = false

				if not arg_28_0.keep_chat_visible then
					var_28_2 = UISettings.chat.chat_close_delay
				end

				if arg_28_0.chat_message ~= "" then
					local var_28_26 = arg_28_0.channel_id

					if arg_28_0.chat_manager:has_channel(var_28_26) then
						local var_28_27 = false
						local var_28_28 = false

						arg_28_0.chat_manager:send_chat_message(var_28_26, 1, arg_28_0.chat_message, var_28_27, nil, var_28_28, arg_28_0.recent_message_index)
					end

					arg_28_0.chat_message = ""
					arg_28_0.chat_mode = "insert"
					arg_28_0.chat_index = 1
					arg_28_0.chat_input_widget.content.caret_index = 1
					arg_28_0.chat_input_widget.content.text_index = 1
					arg_28_0.scrollbar_widget.content.internal_scroll_value = 0
				else
					var_28_6 = true
					var_28_2 = 0
					var_28_0 = false
				end

				arg_28_0.old_chat_message = nil
				arg_28_0.recent_message_index = nil
			elseif arg_28_1:get("chat_next_old_message") and GameSettingsDevelopment.allow_chat_input then
				local var_28_29 = Managers.chat:get_recently_sent_messages()
				local var_28_30 = #var_28_29

				if var_28_30 > 0 then
					if not arg_28_0.recent_message_index then
						if string.len(arg_28_0.chat_message) > 0 and not arg_28_0.recent_message_index then
							arg_28_0.old_chat_message = arg_28_0.chat_message
						end

						arg_28_0.recent_message_index = var_28_30
					else
						arg_28_0.recent_message_index = math.max(arg_28_0.recent_message_index - 1, 1)
					end

					arg_28_0.chat_message = var_28_29[arg_28_0.recent_message_index]
					arg_28_0.chat_index = #KeystrokeHelper._build_utf8_table(arg_28_0.chat_message) + 1
					arg_28_0.chat_input_widget.content.jump_to_end = true
				end
			elseif arg_28_1:get("chat_previous_old_message") and GameSettingsDevelopment.allow_chat_input then
				local var_28_31 = Managers.chat:get_recently_sent_messages()
				local var_28_32 = #var_28_31

				if arg_28_0.recent_message_index then
					if var_28_32 > 0 and var_28_32 > arg_28_0.recent_message_index then
						arg_28_0.recent_message_index = math.clamp(arg_28_0.recent_message_index + 1, 1, var_28_32)
						arg_28_0.chat_message = var_28_31[arg_28_0.recent_message_index]
						arg_28_0.chat_index = #KeystrokeHelper._build_utf8_table(arg_28_0.chat_message) + 1
					elseif arg_28_0.recent_message_index == var_28_32 and arg_28_0.old_chat_message then
						arg_28_0.chat_message = arg_28_0.old_chat_message
						arg_28_0.chat_index = #KeystrokeHelper._build_utf8_table(arg_28_0.chat_message) + 1
						arg_28_0.recent_message_index = nil
						arg_28_0.old_chat_message = nil
					end

					arg_28_0.chat_input_widget.content.jump_to_end = true
				end
			elseif GameSettingsDevelopment.use_global_chat and arg_28_1:get("chat_switch_view") and GameSettingsDevelopment.allow_chat_input then
				arg_28_0:clear_messages()
				Managers.chat:switch_view()

				local var_28_33, var_28_34 = Managers.chat:current_view_and_color()

				arg_28_0.chat_input_widget.content.header_field = var_28_33

				arg_28_0:_apply_color_values(arg_28_0.chat_input_widget.style.header_text.text_color, var_28_34)
			elseif GameSettingsDevelopment.use_global_chat and arg_28_1:get("chat_switch_channel") and GameSettingsDevelopment.allow_chat_input then
				if Managers.chat:next_message_target() then
					arg_28_0:clear_messages()
				end

				local var_28_35 = Managers.chat:current_message_target()
				local var_28_36 = "[" .. tostring(var_28_35.message_target) .. "]  "
				local var_28_37, var_28_38 = UIFontByResolution(arg_28_0.chat_input_widget.style.channel_text)
				local var_28_39, var_28_40, var_28_41 = UIRenderer.text_size(arg_28_0.ui_renderer, var_28_36, var_28_37[1], var_28_38)

				arg_28_0.chat_input_widget.content.channel_field = var_28_36

				local var_28_42 = IRC_CHANNEL_COLORS[var_28_35.message_target_type]

				arg_28_0:_apply_color_values(arg_28_0.chat_input_widget.style.channel_text.text_color, var_28_42)

				arg_28_0.ui_scenegraph.chat_input_text.size[1] = var_0_0.CHAT_INPUT_TEXT_WIDTH - var_28_39
				arg_28_0.chat_input_widget.style.text.offset[1] = arg_28_0.chat_input_widget.style.channel_text.offset[1] + var_28_39
				arg_28_0.chat_input_widget.content.caret_index = UTF8Utils.string_length(arg_28_0.chat_message) + 1
				arg_28_0.chat_index = arg_28_0.chat_input_widget.content.caret_index

				local var_28_43, var_28_44 = Managers.chat:current_view_and_color()

				arg_28_0.chat_input_widget.content.header_field = var_28_43

				arg_28_0:_apply_color_values(arg_28_0.chat_input_widget.style.header_text.text_color, var_28_44)
			elseif arg_28_1:get("chat_backspace_word") and GameSettingsDevelopment.allow_chat_input then
				local var_28_45 = KeystrokeHelper._build_utf8_table(arg_28_0.chat_message)
				local var_28_46 = arg_28_0.chat_index - 1
				local var_28_47 = false
				local var_28_48 = 0

				for iter_28_0 = var_28_46, 1, -1 do
					local var_28_49 = var_28_45[iter_28_0]

					if var_28_45[iter_28_0] == " " and var_28_47 then
						var_28_46 = iter_28_0 + 1

						break
					else
						table.remove(var_28_45, iter_28_0)

						var_28_46 = iter_28_0

						if var_28_45[iter_28_0] ~= " " then
							var_28_47 = true
						end
					end
				end

				arg_28_0.chat_index = math.clamp(var_28_46, 1, #var_28_45 + 1)
				arg_28_0.chat_message = ""

				local var_28_50 = 0

				for iter_28_1, iter_28_2 in ipairs(var_28_45) do
					arg_28_0.chat_message = arg_28_0.chat_message .. iter_28_2
					var_28_50 = var_28_50 + 1
				end
			elseif GameSettingsDevelopment.allow_chat_input then
				local var_28_51 = arg_28_0._keystrokes

				table.clear(var_28_51)

				local var_28_52 = Keyboard.keystrokes(var_28_51)
				local var_28_53 = Keyboard.button_index("left ctrl")

				if not Keyboard.pressed(var_28_53) then
					local var_28_54

					var_28_54 = Keyboard.button(var_28_53) > 0
				end

				local var_28_55, var_28_56, var_28_57 = KeystrokeHelper.parse_strokes(arg_28_0.chat_message, arg_28_0.chat_index, arg_28_0.chat_mode, var_28_52, ChatGui.MAX_CHARS)

				if var_28_56 ~= arg_28_0.chat_index then
					if var_28_56 == 1 then
						arg_28_0.chat_input_widget.content.text_index = var_28_56
					elseif var_28_56 > UTF8Utils.string_length(var_28_55) then
						arg_28_0.chat_input_widget.content.jump_to_end = true
					end
				end

				arg_28_0.chat_message = var_28_55
				arg_28_0.chat_index = var_28_56
				arg_28_0.chat_mode = var_28_57
			end
		else
			local var_28_58 = arg_28_1:get("execute_alt_chat_input")

			if arg_28_1:get("activate_chat_input") or (arg_28_1:get("execute_chat_input") or var_28_58) and GameSettingsDevelopment.allow_chat_input then
				if arg_28_5 then
					var_28_6 = false
					var_28_2 = nil
					var_28_0 = true
				else
					var_28_6 = false
					var_28_2 = UISettings.chat.chat_close_delay
					var_28_0 = false
					arg_28_0._refocus_chat_window = true
				end

				arg_28_0.chat_message = ""
				arg_28_0.chat_index = 1
				arg_28_0.chat_mode = "insert"
				arg_28_0.recent_message_index = nil
				arg_28_0.old_chat_message = nil

				local var_28_59 = 1
				local var_28_60
				local var_28_61 = Managers.mechanism:game_mechanism()

				if var_28_61.get_chat_channel then
					local var_28_62 = Network.peer_id()

					var_28_59, var_28_60 = var_28_61:get_chat_channel(var_28_62, var_28_58)
				end

				arg_28_0.channel_id = var_28_59 or 1
				arg_28_0.alt_chat_input = var_28_58

				if var_28_60 then
					Managers.chat:set_message_target_type(var_28_60)
				end

				local var_28_63 = Managers.chat:current_message_target()

				if var_28_63 then
					local var_28_64 = "[" .. tostring(var_28_63.message_target) .. "]  "
					local var_28_65, var_28_66 = UIFontByResolution(arg_28_0.chat_input_widget.style.channel_text)
					local var_28_67, var_28_68, var_28_69 = UIRenderer.text_size(arg_28_0.ui_renderer, var_28_64, var_28_65[1], var_28_66)

					arg_28_0.chat_input_widget.content.channel_field = var_28_64

					local var_28_70 = IRC_CHANNEL_COLORS[var_28_63.message_target_type]

					arg_28_0:_apply_color_values(arg_28_0.chat_input_widget.style.channel_text.text_color, var_28_70)

					arg_28_0.ui_scenegraph.chat_input_text.size[1] = var_0_0.CHAT_INPUT_TEXT_WIDTH - var_28_67
					arg_28_0.chat_input_widget.style.text.offset[1] = arg_28_0.chat_input_widget.style.channel_text.offset[1] + var_28_67
				end

				arg_28_0.chat_input_widget.content.caret_index = 1
				arg_28_0.chat_input_widget.content.text_index = 1
			end
		end

		local var_28_71 = arg_28_0.chat_input_widget.content
		local var_28_72 = var_28_71.enlarge_hotspot
		local var_28_73 = var_28_71.info_hotspot
		local var_28_74 = var_28_71.filter_hotspot
		local var_28_75 = var_28_71.target_hotspot

		if GameSettingsDevelopment.use_global_chat then
			if var_28_72.on_release then
				Managers.ui:handle_transition("chat_view_force", {
					use_fade = true
				})

				var_28_6 = true
				var_28_2 = 0
				var_28_0 = false
			elseif var_28_73.on_release and false then
				var_28_6 = true
				var_28_2 = 0
				var_28_0 = false
			elseif var_28_74.on_release then
				arg_28_0:clear_messages()
				Managers.chat:switch_view()

				local var_28_76, var_28_77 = Managers.chat:current_view_and_color()

				arg_28_0.chat_input_widget.content.header_field = var_28_76

				arg_28_0:_apply_color_values(arg_28_0.chat_input_widget.style.header_text.text_color, var_28_77)
			elseif var_28_75.on_release then
				if Managers.chat:next_message_target() then
					arg_28_0:clear_messages()
				end

				local var_28_78 = Managers.chat:current_message_target()
				local var_28_79 = "[" .. tostring(var_28_78.message_target) .. "]  "
				local var_28_80, var_28_81 = UIFontByResolution(arg_28_0.chat_input_widget.style.channel_text)
				local var_28_82, var_28_83, var_28_84 = UIRenderer.text_size(arg_28_0.ui_renderer, var_28_79, var_28_80[1], var_28_81)

				arg_28_0.chat_input_widget.content.channel_field = var_28_79

				local var_28_85 = IRC_CHANNEL_COLORS[var_28_78.message_target_type]

				arg_28_0:_apply_color_values(arg_28_0.chat_input_widget.style.channel_text.text_color, var_28_85)

				arg_28_0.ui_scenegraph.chat_input_text.size[1] = var_0_0.CHAT_INPUT_TEXT_WIDTH - var_28_82
				arg_28_0.chat_input_widget.style.text.offset[1] = arg_28_0.chat_input_widget.style.channel_text.offset[1] + var_28_82
				arg_28_0.chat_input_widget.content.caret_index = UTF8Utils.string_length(arg_28_0.chat_message) + 1
				arg_28_0.chat_index = arg_28_0.chat_input_widget.content.caret_index

				local var_28_86, var_28_87 = Managers.chat:current_view_and_color()

				arg_28_0.chat_input_widget.content.header_field = var_28_86

				arg_28_0:_apply_color_values(arg_28_0.chat_input_widget.style.header_text.text_color, var_28_87)
			end
		end

		local var_28_88 = 0.025
		local var_28_89 = var_28_4.content
		local var_28_90

		if var_28_0 then
			if arg_28_1:get("chat_scroll_up") then
				var_28_90 = var_28_88
			elseif arg_28_1:get("chat_scroll_down") then
				var_28_90 = -var_28_88
			end

			local var_28_91 = "chat_scroll"

			if arg_28_1:has(var_28_91) then
				local var_28_92 = arg_28_1:get(var_28_91).y

				if var_28_92 ~= 0 then
					var_28_90 = var_28_88 * var_28_92
				end
			end
		end

		if var_28_90 then
			local var_28_93 = arg_28_0.ui_scenegraph
			local var_28_94 = var_28_93[var_28_4.scenegraph_id].position[2] + var_28_93.chat_window_root.position[2]
			local var_28_95 = var_28_4.style.scrollbar.scenegraph_id
			local var_28_96 = var_28_94 - var_28_89.scroll_bar_height / 2
			local var_28_97 = UISceneGraph.get_size(var_28_93, var_28_95)
			local var_28_98 = math.clamp(var_28_96, 0, var_28_97[2])
			local var_28_99 = math.min(var_28_98 / var_28_97[2], 1)

			var_28_89.internal_scroll_value = math.clamp(var_28_89.internal_scroll_value + var_28_90, 0, var_28_99)
		end
	end

	return var_28_0, var_28_6, var_28_2
end

function ChatGui._draw_widgets(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_0.input_manager:is_device_active("gamepad")
	local var_29_1 = arg_29_0.chat_close_time
	local var_29_2 = arg_29_0.menu_active

	if not var_29_2 and var_29_1 and var_29_1 == 0 then
		return
	end

	local var_29_3 = arg_29_0._render_settings
	local var_29_4 = arg_29_0.ui_scenegraph
	local var_29_5 = arg_29_0.ui_renderer
	local var_29_6 = arg_29_0.ui_animations
	local var_29_7 = arg_29_0.chat_window_widget
	local var_29_8 = arg_29_0.chat_input_widget
	local var_29_9 = arg_29_0.chat_output_widget
	local var_29_10 = arg_29_0.scrollbar_widget
	local var_29_11 = arg_29_0.tab_widget

	var_29_8.content.text_field = arg_29_0.chat_message
	var_29_8.content.caret_index = arg_29_0.chat_index
	var_29_9.content.text_start_offset = 1 - var_29_10.content.scroll_value

	local var_29_12 = var_29_3.alpha_multiplier

	UIRenderer.begin_pass(var_29_5, var_29_4, arg_29_2, arg_29_1, nil, var_29_3)

	if not var_29_0 and var_29_2 and arg_29_3 then
		UIRenderer.draw_widget(var_29_5, var_29_11)
	end

	arg_29_0:_apply_hud_scale()

	if arg_29_0.chat_focused then
		UIAnimation.update(var_29_6.caret_pulse, arg_29_1)
	end

	if var_29_2 then
		if var_29_6.window_position then
			UIAnimation.update(var_29_6.window_position, arg_29_1)
		end

		if var_29_6.notification_pulse then
			UIAnimation.update(var_29_6.notification_pulse, arg_29_1)
		end
	else
		local var_29_13 = UISettings.chat.chat_close_fade_length

		if var_29_1 and var_29_1 < var_29_13 then
			local var_29_14 = var_29_1 / var_29_13

			arg_29_0:_set_chat_window_alpha(var_29_14)
		elseif arg_29_0._refocus_chat_window then
			arg_29_0:_set_chat_window_alpha(1)

			arg_29_0._refocus_chat_window = nil
		end
	end

	UIRenderer.draw_widget(var_29_5, var_29_7)

	if not arg_29_0.chat_closed and not arg_29_0.opening and not arg_29_0.closing then
		if arg_29_0.chat_focused and arg_29_3 then
			UIRenderer.draw_widget(var_29_5, var_29_8)
		end

		var_29_3.alpha_multiplier = arg_29_0._output_text_alpha_multiplier or var_29_12

		UIRenderer.draw_widget(var_29_5, var_29_9)

		var_29_3.alpha_multiplier = var_29_12

		UIRenderer.draw_widget(var_29_5, var_29_10)

		if var_29_9.content.link_pressed then
			local var_29_15 = var_29_9.content.link_pressed

			Managers.invite:set_invited_lobby_data(var_29_15.lobby_id)

			var_29_9.content.link_pressed = nil

			print("Link Pressed! -> joining game!")
		end

		if arg_29_3 then
			for iter_29_0, iter_29_1 in pairs(arg_29_0._widgets) do
				UIRenderer.draw_widget(var_29_5, iter_29_1)
			end
		end
	end

	arg_29_0:_abort_hud_scale()
	UIRenderer.end_pass(var_29_5)

	var_29_3.alpha_multiplier = var_29_12
end

function ChatGui._update_hud_scale(arg_30_0)
	if not arg_30_0._resolution_modified then
		arg_30_0._resolution_modified = RESOLUTION_LOOKUP.modified
	end

	if not arg_30_0._scale_modified then
		local var_30_0 = UISettings.hud_scale * 0.01

		arg_30_0._scale_modified = arg_30_0._hud_scale_multiplier ~= var_30_0
		arg_30_0._hud_scale_multiplier = var_30_0
	end
end

function ChatGui._apply_hud_scale(arg_31_0)
	arg_31_0:_update_hud_scale()

	local var_31_0 = arg_31_0._scale_modified
	local var_31_1 = arg_31_0._resolution_modified
	local var_31_2 = var_31_0 or var_31_1
	local var_31_3 = arg_31_0._hud_scale_multiplier

	UPDATE_RESOLUTION_LOOKUP(var_31_2, var_31_3)
end

function ChatGui._abort_hud_scale(arg_32_0)
	local var_32_0 = arg_32_0._scale_modified
	local var_32_1 = arg_32_0._resolution_modified
	local var_32_2 = var_32_0 or var_32_1

	UPDATE_RESOLUTION_LOOKUP(var_32_2)
end

function ChatGui._set_chat_window_alpha(arg_33_0, arg_33_1)
	local var_33_0 = UISettings.chat
	local var_33_1 = arg_33_0.chat_window_widget
	local var_33_2 = arg_33_0.chat_input_widget
	local var_33_3 = arg_33_0.chat_output_widget
	local var_33_4 = arg_33_0.scrollbar_widget

	var_33_1.style.background.color[1] = var_33_0.window_background_alpha * arg_33_1

	local var_33_5 = var_33_2.style

	var_33_5.background.color[1] = var_33_0.input_background_alpha * arg_33_1
	var_33_5.text.text_color[1] = var_33_0.input_text_alpha * arg_33_1
	var_33_5.text.caret_color[1] = var_33_0.input_caret_alpha * arg_33_1
	var_33_3.style.background.color[1] = var_33_0.output_background_alpha * arg_33_1

	local var_33_6 = var_33_4.style

	var_33_6.background.color[1] = var_33_0.scrollbar_background_alpha * arg_33_1

	local var_33_7 = var_33_0.scrollbar_background_stroke_alpha * arg_33_1

	var_33_6.background_stroke_top.color[1] = var_33_7
	var_33_6.background_stroke_bottom.color[1] = var_33_7
	var_33_6.background_stroke_left.color[1] = var_33_7
	var_33_6.background_stroke_right.color[1] = var_33_7
	var_33_6.scrollbar.color[1] = var_33_0.scrollbar_alpha * arg_33_1

	local var_33_8 = var_33_0.scrollbar_stroke_alpha * arg_33_1

	var_33_6.scrollbar_stroke_top.color[1] = var_33_8
	var_33_6.scrollbar_stroke_bottom.color[1] = var_33_8
	arg_33_0._output_text_alpha_multiplier = arg_33_1
end

function ChatGui._apply_color_values(arg_34_0, arg_34_1, arg_34_2)
	arg_34_1[2] = arg_34_2[2]
	arg_34_1[3] = arg_34_2[3]
	arg_34_1[4] = arg_34_2[4]
end
