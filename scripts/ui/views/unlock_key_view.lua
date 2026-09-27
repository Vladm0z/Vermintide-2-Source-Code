-- chunkname: @scripts/ui/views/unlock_key_view.lua

local var_0_0 = local_require("scripts/ui/views/unlock_key_view_definitions")

UnlockKeyView = class(UnlockKeyView)

UnlockKeyView.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_renderer
	self.input_manager = arg_1_1.input_manager
	self.ingame_ui = arg_1_1.ingame_ui
	self.world = arg_1_1.world
	self.statistics_db = arg_1_1.statistics_db
	self.wwise_world = arg_1_1.dialogue_system.wwise_world

	local input_manager = self.input_manager

	input_manager:create_input_service("unlock_key_menu", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("unlock_key_menu", "keyboard")
	input_manager:map_device_to_service("unlock_key_menu", "mouse")
	input_manager:map_device_to_service("unlock_key_menu", "gamepad")
	rawset(_G, "global_unlock_key_view", self)

	self.ui_animations = {}

	self:create_ui_elements()

	self.controller_cooldown = 0
end

UnlockKeyView.input_service = function (self)
	-- function 2
	return self.input_manager:get_service("unlock_key_menu")
end

UnlockKeyView.destroy = function (arg_3_0)
	-- function 3
	rawset(_G, "global_unlock_key_view", nil)
	GarbageLeakDetector.register_object(arg_3_0, "UnlockKeyView")
end

local widget_definitions = var_0_0.widget_definitions
local create_simple_texture_widget = var_0_0.create_simple_texture_widget
local num = 0

UnlockKeyView.create_ui_elements = function (self)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.background_widgets = {
		create_simple_texture_widget("unlock_key_bg", "key_entry_background"),
		create_simple_texture_widget("title_bar", "unlock_key_title_background")
	}
	self.confirm_gamepad_button_widget = UIWidget.init(widget_definitions.confirm_gamepad_button_widget)
	self.back_gamepad_button_widget = UIWidget.init(widget_definitions.back_gamepad_button_widget)
	self.processing_icon_widget = UIWidget.init(widget_definitions.processing_icon)
	self.text_input_widget = UIWidget.init(widget_definitions.text_input)
	self.accept_button_widget = UIWidget.init(widget_definitions.accept_button)
	self.cancel_button_widget = UIWidget.init(widget_definitions.cancel_button)
	self.title_widget = UIWidget.init(widget_definitions.title)
	self.confirm_gamepad_button_widget.content.text_field = "Select"
	self.back_gamepad_button_widget.content.text_field = "Exit"
end

UnlockKeyView.on_enter = function (self)
	-- function 5
	self.input_manager:block_device_except_service("unlock_key_menu", "keyboard", 1)
	self.input_manager:block_device_except_service("unlock_key_menu", "mouse", 1)
	self.input_manager:block_device_except_service("unlock_key_menu", "gamepad", 1)

	self.fade_in_done = false

	Managers.transition:fade_in(10, function ()
		-- function 6
		self.fade_in_done = true
	end)

	self.ui_animations.entry_animation = UIAnimation.init(UIAnimation.function_by_time, self.ui_scenegraph.root.local_position, 2, 1080, 1080, 0.01, math.easeInCubic, UIAnimation.wait, 0.1, UIAnimation.function_by_time, self.ui_scenegraph.root.local_position, 2, 1080, 0, 0.01, math.easeInCubic)
	self.key_text = ""
	self.key_text_index = 1
	self.text_mode = "insert"
	self.text_input_widget.content.caret_index = 1
	self.text_input_widget.content.text_index = 1
	self.transition_on_completed_animation = nil
end

UnlockKeyView.on_exit = function (arg_7_0)
	-- function 7
	return
end

UnlockKeyView.suspend = function (self)
	-- function 8
	self.suspended = true

	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
end

UnlockKeyView.unsuspend = function (self)
	-- function 9
	self.input_manager:block_device_except_service("unlock_key_menu", "keyboard", 1)
	self.input_manager:block_device_except_service("unlock_key_menu", "mouse", 1)
	self.input_manager:block_device_except_service("unlock_key_menu", "gamepad", 1)

	self.suspended = nil
end

UnlockKeyView.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self.suspended then
		return
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("unlock_key_menu")
	local entry_animation = self.ui_animations.entry_animation

	entry_animation = entry_animation or self.ui_animations.exit_animation

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_10_1)

		if k == "exit_animation" or not UIAnimation.completed(v) then
			self.ui_animations[k] = nil

			if k == "entry_animation" then
				Managers.transition:fade_out(10)
			end
		end
	end

	if not self.ui_animations.exit_animation and not UIAnimation.completed(self.ui_animations.exit_animation) then
		Managers.transition:fade_out(10, nil)

		self.ui_animations.exit_animation = nil

		local transition_on_completed_animation = self.transition_on_completed_animation

		if not transition_on_completed_animation then
			self.ingame_ui:handle_transition(transition_on_completed_animation)

			self.transition_on_completed_animation = nil
		end
	end

	if not self.fade_in_done then
		self:draw_widgets(arg_10_1, arg_10_2)
	end

	if not entry_animation then
		self:handle_input(get_service)
		self:handle_controller_input(get_service, arg_10_1)
	end

	if entry_animation or get_service:get("toggle_menu") or not self.cancel_button_widget.content.button_hotspot.on_release then
		self:exit()
	end
end

UnlockKeyView.exit = function (self)
	-- function 11
	self:on_menu_close()
	Managers.transition:fade_in(10)

	self.ui_animations.exit_animation = UIAnimation.init(UIAnimation.wait, 0.2)
	self.transition_on_completed_animation = "exit_menu"
end

UnlockKeyView.draw_widgets = function (self, arg_12_1, arg_12_2)
	-- function 12
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("unlock_key_menu")
	local active = Managers.input:get_device("gamepad").active()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_12_1)

	for i, v in ipairs(self.background_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	if not active then
		UIRenderer.draw_widget(ui_renderer, self.confirm_gamepad_button_widget)
		UIRenderer.draw_widget(ui_renderer, self.back_gamepad_button_widget)
	end

	local text_input_widget = self.text_input_widget

	text_input_widget.content.text_field = self.key_text
	text_input_widget.content.caret_index = self.key_text_index

	local num = (1 + math.sin(arg_12_2 * 3 % math.pi)) / 2

	text_input_widget.style.text.caret_color[1] = num * 255

	UIRenderer.draw_widget(ui_renderer, text_input_widget)
	UIRenderer.draw_widget(ui_renderer, self.processing_icon_widget)
	UIRenderer.draw_widget(ui_renderer, self.accept_button_widget)
	UIRenderer.draw_widget(ui_renderer, self.cancel_button_widget)
	UIRenderer.draw_widget(ui_renderer, self.title_widget)
	UIRenderer.end_pass(ui_renderer)
end

UnlockKeyView.handle_input = function (self, arg_13_1)
	-- function 13
	local keystrokes = Keyboard.keystrokes()

	self.key_text, self.key_text_index, self.text_mode = KeystrokeHelper.parse_strokes(self.key_text, self.key_text_index, self.text_mode, keystrokes)
	self.key_text = TextToUpper(self.key_text)

	if not self.accept_button_widget.content.button_hotspot.on_release then
		local available_unlock_keys = self.available_unlock_keys
		local count = #available_unlock_keys

		for i = 1, count do
			local var_13_3 = available_unlock_keys[i]

			if self.key_text == var_13_3 then
				print("HAIL TO THE KING BABY")
			else
				print("INVALID KEY YOU INVALID")
			end
		end
	end
end

UnlockKeyView.handle_controller_input = function (self, arg_14_1, arg_14_2)
	-- function 14
	if self.controller_cooldown > 0 then
		self.controller_cooldown = self.controller_cooldown - arg_14_2
	else
		repeat
			if not (self.confirm_gamepad_button_widget.content.gamepad_button.is_clicked == 0 or self.confirm_gamepad_button_widget.content.button_hotspot.is_clicked ~= 0) then
				break
			end

			if not (self.back_gamepad_button_widget.content.gamepad_button.is_clicked == 0 or self.back_gamepad_button_widget.content.button_hotspot.is_clicked ~= 0) then
				self.controller_cooldown = GamepadSettings.menu_cooldown
			end

			break
		until true
	end
end

UnlockKeyView.on_reset = function (arg_15_0)
	-- function 15
	return
end

UnlockKeyView.on_apply = function (arg_16_0)
	-- function 16
	return
end

UnlockKeyView.on_menu_close = function (arg_17_0)
	-- function 17
	return
end

if not rawget(_G, "my_global_ass_pointer") then
	my_global_ass_pointer:create_ui_elements()
end
