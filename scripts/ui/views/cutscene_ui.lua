-- chunkname: @scripts/ui/views/cutscene_ui.lua

local var_0_0 = local_require("scripts/ui/views/cutscene_ui_definitions")
local cutscene_ui = UISettings.cutscene_ui
local easeCubic = math.easeCubic
local pdArray = pdArray

CutsceneUI = class(CutsceneUI)

CutsceneUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.cutscene_system = Managers.state.entity:system("cutscene_system")

	local input_manager = arg_1_2.input_manager

	self.input_manager = input_manager

	input_manager:create_input_service("cutscene", "CutsceneKeymaps", "CutsceneFilters")
	input_manager:map_device_to_service("cutscene", "keyboard")
	input_manager:map_device_to_service("cutscene", "mouse")
	input_manager:map_device_to_service("cutscene", "gamepad")

	self.ui_animations = {}
	self.fx_fade_widgets = {}
	self.fx_fade_widgets_pool = {}
	self.fx_text_popup_widgets = {}
	self.fx_text_popup_widgets_pool = {}
	self.letterbox_enabled = false

	self:_create_ui_elements()
end

CutsceneUI._create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)
	self.letterbox_widget = UIWidget.init(var_0_0.widgets.letterbox)
	self.checkboxes = {
		checkbox_1 = UIWidget.init(var_0_0.widgets.checkbox_1),
		checkbox_2 = UIWidget.init(var_0_0.widgets.checkbox_2),
		checkbox_3 = UIWidget.init(var_0_0.widgets.checkbox_3),
		checkbox_4 = UIWidget.init(var_0_0.widgets.checkbox_4)
	}
end

CutsceneUI.destroy = function (self)
	-- function 3
	self.ui_renderer = nil
	self.ingame_ui = nil
	self.cutscene_system = nil
	self.input_manager = nil
	self.ui_scenegraph = nil
	self.letterbox_widget = nil
	self.fx_fade_widgets = nil
	self.fx_fade_widgets_pool = nil
	self.fx_text_popup_widgets = nil
	self.fx_text_popup_widgets_pool = nil
end

CutsceneUI.update = function (self, arg_4_1)
	-- function 4
	self:check_for_fade()

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_4_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end

	local cutscene_system = self.cutscene_system
	local ui_event_queue = cutscene_system.ui_event_queue

	if not pdArray.empty(ui_event_queue) then
		self:handle_event_queue(ui_event_queue)
		pdArray.set_empty(ui_event_queue)
	end

	if not cutscene_system.active_camera and self.input_manager:get_service("cutscene"):get("skip_cutscene") and not LEVEL_EDITOR_TEST then
		cutscene_system:skip_pressed()
	end

	if not self:do_draw() then
		self:prepare_draw()
		self:draw(arg_4_1)
	end
end

CutsceneUI.do_draw = function (self)
	-- function 5
	local letterbox_enabled = self.letterbox_enabled

	letterbox_enabled = letterbox_enabled or #self.fx_fade_widgets > 0 or #self.fx_text_popup_widgets > 0

	return letterbox_enabled
end

CutsceneUI.prepare_draw = function (self)
	-- function 6
	local fx_fade_widgets = self.fx_fade_widgets
	local fx_fade_widgets_pool = self.fx_fade_widgets_pool

	for i = #fx_fade_widgets, 1, -1 do
		local var_6_2 = fx_fade_widgets[i]

		if not next(fx_fade_widgets[i].animations) then
			fx_fade_widgets_pool[#fx_fade_widgets_pool + 1] = table.remove(fx_fade_widgets, i)
		end
	end

	local fx_text_popup_widgets = self.fx_text_popup_widgets
	local fx_text_popup_widgets_pool = self.fx_text_popup_widgets_pool

	for j = #fx_text_popup_widgets, 1, -1 do
		local var_6_5 = fx_text_popup_widgets[j]

		if not next(fx_text_popup_widgets[j].animations) then
			fx_text_popup_widgets_pool[#fx_text_popup_widgets_pool + 1] = table.remove(fx_text_popup_widgets, j)
		end
	end
end

CutsceneUI.draw = function (self, arg_7_1)
	-- function 7
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("cutscene")
	local get_size_scaled = UISceneGraph.get_size_scaled(ui_scenegraph, "screen")

	ui_scenegraph.letterbox_top_bar.size[1] = get_size_scaled[1]
	ui_scenegraph.letterbox_bottom_bar.size[1] = get_size_scaled[1]

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_7_1)

	if not self.letterbox_enabled then
		UIRenderer.draw_widget(ui_renderer, self.letterbox_widget)

		if not cutscene_ui.skippable then
			UIRenderer.draw_all_widgets(ui_renderer, self.checkboxes)
		end
	end

	local fx_fade_widgets = self.fx_fade_widgets

	for i = 1, #fx_fade_widgets do
		local var_7_5 = fx_fade_widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_7_5)
	end

	local fx_text_popup_widgets = self.fx_text_popup_widgets

	for j = 1, #fx_text_popup_widgets do
		local var_7_7 = fx_text_popup_widgets[j]

		UIRenderer.draw_widget(ui_renderer, var_7_7)
	end

	UIRenderer.end_pass(ui_renderer)
end

CutsceneUI.handle_event_queue = function (self, arg_8_1)
	-- function 8
	local data, var_8_1 = pdArray.data(arg_8_1)
	local num = 1

	while num <= var_8_1 do
		local var_8_3 = data[num]
		local var_8_4 = self[var_8_3]

		fassert(var_8_4, "[CutsceneUI] Function not found for event %q", var_8_3)

		local var_8_5 = data[num + 1]

		if type(var_8_5) == "table" then
			var_8_4(self, unpack(var_8_5))
		else
			var_8_4(self, var_8_5)
		end

		num = num + 2
	end
end

CutsceneUI.set_letterbox_enabled = function (self, arg_9_1)
	-- function 9
	self.letterbox_enabled = arg_9_1
end

CutsceneUI.set_player_input_enabled = function (self, arg_10_1)
	-- function 10
	local input_manager = self.input_manager

	if not arg_10_1 then
		input_manager:release_input({
			"keyboard",
			"gamepad",
			"mouse"
		}, 1, "cutscene", "CutsceneUI")
	else
		self.ingame_ui:handle_transition("close_active")
		input_manager:capture_input({
			"keyboard",
			"gamepad",
			"mouse"
		}, 1, "cutscene", "CutsceneUI")
	end
end

CutsceneUI.input_service = function (self)
	-- function 11
	return self.input_manager:get_service("cutscene")
end

CutsceneUI.fx_fade = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local fx_fade = cutscene_ui.fx_fade

	arg_12_1 = arg_12_1 or fx_fade.fade_in_time
	arg_12_2 = arg_12_2 or fx_fade.hold_time
	arg_12_3 = arg_12_3 or fx_fade.fade_out_time
	arg_12_4 = arg_12_4 or fx_fade.color

	local remove = table.remove(self.fx_fade_widgets_pool)

	remove = remove or UIWidget.init(var_0_0.widgets.fx_fade)

	local content = remove.content
	local str = "fx_fade_alpha"
	local num = 0
	local num_2 = 1
	local num_3 = arg_12_1 + arg_12_2 + arg_12_3

	arg_12_1 = arg_12_1 / num_3
	arg_12_3 = arg_12_3 / num_3
	arg_12_2 = 1 - arg_12_3

	local function fn(arg_13_0)
		-- function 13
		if arg_13_0 < arg_12_1 then
			return easeCubic(arg_13_0 / arg_12_1)
		elseif arg_13_0 < arg_12_2 then
			return 1
		elseif arg_12_3 > 0 then
			return easeCubic((1 - arg_13_0) / arg_12_3)
		else
			return 0
		end
	end

	UIWidget.animate(remove, UIAnimation.init(UIAnimation.function_by_time, content, str, num, num_2, num_3, fn))

	self.fx_fade_widgets[#self.fx_fade_widgets + 1] = remove
end

CutsceneUI.fx_text_popup = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local fx_text_popup = cutscene_ui.fx_text_popup

	arg_14_1 = arg_14_1 or fx_text_popup.fade_in_time
	arg_14_2 = arg_14_2 or fx_text_popup.hold_time
	arg_14_3 = arg_14_3 or fx_text_popup.fade_out_time
	arg_14_4 = arg_14_4 or "no text set"

	local remove = table.remove(self.fx_text_popup_widgets_pool)

	remove = remove or UIWidget.init(var_0_0.widgets.fx_text_popup)

	local content = remove.content
	local str = "fx_text_popup_alpha"
	local num = 0
	local num_2 = 1
	local num_3 = arg_14_1 + arg_14_2 + arg_14_3

	arg_14_1 = arg_14_1 / num_3
	arg_14_3 = arg_14_3 / num_3
	arg_14_2 = 1 - arg_14_3

	local function fn(arg_15_0)
		-- function 15
		if arg_15_0 < arg_14_1 then
			return easeCubic(arg_15_0 / arg_14_1)
		elseif arg_15_0 < arg_14_2 then
			return 1
		elseif arg_14_3 > 0 then
			return easeCubic((1 - arg_15_0) / arg_14_3)
		else
			return 0
		end
	end

	UIWidget.animate(remove, UIAnimation.init(UIAnimation.function_by_time, content, str, num, num_2, num_3, fn))

	remove.content.text = arg_14_4
	self.fx_text_popup_widgets[#self.fx_text_popup_widgets + 1] = remove
end

CutsceneUI.check_for_fade = function (self)
	-- function 16
	local cutscene_system = self.cutscene_system

	if not cutscene_system then
		if not cutscene_system.fade_in_game_logo then
			local fade_in_game_logo_time = cutscene_system.fade_in_game_logo_time

			cutscene_system.fade_in_game_logo = nil
			cutscene_system.fade_in_game_logo_time = nil

			self:fade_in_logo(fade_in_game_logo_time)
		elseif not cutscene_system.fade_out_game_logo_time then
			local fade_out_game_logo_time = cutscene_system.fade_out_game_logo_time

			cutscene_system.fade_out_game_logo = nil
			cutscene_system.fade_out_game_logo_time = nil

			self:fade_out_logo(fade_out_game_logo_time)
		end
	end
end
