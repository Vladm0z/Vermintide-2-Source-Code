-- chunkname: @scripts/ui/views/options_view.lua

require("scripts/ui/views/ui_calibration_view")

OptionsView = class(OptionsView)

local var_0_0 = local_require("scripts/ui/views/options_view_definitions")
local var_0_1 = local_require("scripts/ui/views/options_view_settings")
local gamepad_frame_widget_definitions = var_0_0.gamepad_frame_widget_definitions
local background_widget_definitions = var_0_0.background_widget_definitions
local widget_definitions = var_0_0.widget_definitions
local title_button_definitions = var_0_1.title_button_definitions
local button_definitions = var_0_0.button_definitions
local child_input_services = var_0_0.child_input_services
local animation_definitions = var_0_0.animation_definitions
local SettingsMenuNavigation = SettingsMenuNavigation
local SettingsWidgetTypeTemplate = SettingsWidgetTypeTemplate

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local num = arg_1_1 - arg_1_0

	return (math.clamp(arg_1_2, arg_1_0, arg_1_1) - arg_1_0) / num
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	if arg_2_0 == nil then
		return arg_2_1
	else
		return arg_2_0
	end
end

local tbl = {}
local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {
	priority = 49,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag

flag = not IS_PS4 and "l2" and "left_trigger"
tbl_4.input_action = flag
tbl_3[1] = tbl_4
tbl_3[2] = {
	input_action = "l1_r1",
	priority = 49,
	description_text = "input_description_change_tab",
	ignore_keybinding = true
}
tbl_3[3] = {
	input_action = "back",
	priority = 50,
	description_text = "input_description_close"
}
tbl_2.default = tbl_3

local tbl_5 = {}
local tbl_6 = {
	priority = 46,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag_2

flag_2 = not IS_PS4 and "l2" and "left_trigger"
tbl_6.input_action = flag_2
tbl_5[1] = tbl_6
tbl_5[2] = {
	input_action = "l1_r1",
	priority = 47,
	description_text = "input_description_change_tab",
	ignore_keybinding = true
}
tbl_5[3] = {
	input_action = "special_1",
	priority = 49,
	description_text = "input_description_reset"
}
tbl_5[4] = {
	input_action = "back",
	priority = 50,
	description_text = "input_description_close"
}
tbl_2.reset = tbl_5

local tbl_7 = {}
local tbl_8 = {
	priority = 45,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag_3

flag_3 = not IS_PS4 and "l2" and "left_trigger"
tbl_8.input_action = flag_3
tbl_7[1] = tbl_8
tbl_7[2] = {
	input_action = "l1_r1",
	priority = 46,
	description_text = "input_description_change_tab",
	ignore_keybinding = true
}
tbl_7[3] = {
	input_action = "special_1",
	priority = 48,
	description_text = "input_description_reset"
}
tbl_7[4] = {
	input_action = "refresh",
	priority = 49,
	description_text = "input_description_apply"
}
tbl_7[5] = {
	input_action = "back",
	priority = 50,
	description_text = "input_description_close"
}
tbl_2.reset_and_apply = tbl_7

local tbl_9 = {}
local tbl_10 = {
	priority = 46,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag_4

flag_4 = not IS_PS4 and "l2" and "left_trigger"
tbl_10.input_action = flag_4
tbl_9[1] = tbl_10
tbl_9[2] = {
	input_action = "l1_r1",
	priority = 47,
	description_text = "input_description_change_tab",
	ignore_keybinding = true
}
tbl_9[3] = {
	input_action = "refresh",
	priority = 49,
	description_text = "input_description_apply"
}
tbl_9[4] = {
	input_action = "back",
	priority = 50,
	description_text = "input_description_close"
}
tbl_2.apply = tbl_9
tbl.main_menu = tbl_2

local tbl_11 = {}
local tbl_12 = {}
local tbl_13 = {
	priority = 47,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag_5

flag_5 = not IS_PS4 and "l2" and "left_trigger"
tbl_13.input_action = flag_5
tbl_12[1] = tbl_13
tbl_12[2] = {
	input_action = "l1_r1",
	priority = 48,
	description_text = "input_description_change_tab",
	ignore_keybinding = true
}
tbl_12[3] = {
	input_action = "back",
	priority = 50,
	description_text = "input_description_back"
}
tbl_11.default = tbl_12

local tbl_14 = {}
local tbl_15 = {
	priority = 47,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag_6

flag_6 = not IS_PS4 and "l2" and "left_trigger"
tbl_15.input_action = flag_6
tbl_14[1] = tbl_15
tbl_14[2] = {
	input_action = "l1_r1",
	priority = 48,
	description_text = "input_description_change_tab",
	ignore_keybinding = true
}
tbl_14[3] = {
	input_action = "special_1",
	priority = 50,
	description_text = "input_description_reset"
}
tbl_14[4] = {
	input_action = "back",
	priority = 51,
	description_text = "input_description_back"
}
tbl_11.reset = tbl_14

local tbl_16 = {}
local tbl_17 = {
	priority = 46,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag_7

flag_7 = not IS_PS4 and "l2" and "left_trigger"
tbl_17.input_action = flag_7
tbl_16[1] = tbl_17
tbl_16[2] = {
	input_action = "l1_r1",
	priority = 47,
	description_text = "input_description_change_tab",
	ignore_keybinding = true
}
tbl_16[3] = {
	input_action = "special_1",
	priority = 49,
	description_text = "input_description_reset"
}
tbl_16[4] = {
	input_action = "refresh",
	priority = 50,
	description_text = "input_description_apply"
}
tbl_16[5] = {
	input_action = "back",
	priority = 51,
	description_text = "input_description_back"
}
tbl_11.reset_and_apply = tbl_16

local tbl_18 = {}
local tbl_19 = {
	priority = 47,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag_8

flag_8 = not IS_PS4 and "l2" and "left_trigger"
tbl_19.input_action = flag_8
tbl_18[1] = tbl_19
tbl_18[2] = {
	input_action = "l1_r1",
	priority = 48,
	description_text = "input_description_change_tab",
	ignore_keybinding = true
}
tbl_18[3] = {
	input_action = "refresh",
	priority = 50,
	description_text = "input_description_apply"
}
tbl_18[4] = {
	input_action = "back",
	priority = 51,
	description_text = "input_description_back"
}
tbl_11.apply = tbl_18
tbl.sub_menu = tbl_11

local tbl_20 = {
	activate_chat_input = {
		"left",
		"right",
		"left_double",
		"right_double"
	}
}

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	for i, v in ipairs(arg_3_0) do
		local var_3_0 = tbl_20[v]

		if not var_3_0 then
			for i_2, v_2 in ipairs(var_3_0) do
				if v_2 == arg_3_1 then
					return false
				end
			end
		end
	end

	return true
end

local num = 1

OptionsView.init = function (self, arg_4_1)
	-- function 4
	self.ui_renderer = arg_4_1.ui_renderer
	self.ui_top_renderer = arg_4_1.ui_top_renderer
	self.ingame_ui = arg_4_1.ingame_ui
	self.voip = arg_4_1.voip
	self.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = false
	}
	self.is_in_tutorial = arg_4_1.is_in_tutorial
	self.in_title_screen = arg_4_1.in_title_screen
	self.platform = PLATFORM

	local input_manager = arg_4_1.input_manager

	input_manager:create_input_service("options_menu", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("options_menu", "keyboard")
	input_manager:map_device_to_service("options_menu", "mouse")
	input_manager:map_device_to_service("options_menu", "gamepad")

	self.input_manager = input_manager
	self.controller_cooldown = 0

	if not GLOBAL_MUSIC_WORLD then
		self.wwise_world = MUSIC_WWISE_WORLD
	else
		local world = arg_4_1.world_manager:world("music_world")

		self.wwise_world = Managers.world:wwise_world(world)
	end

	self.ui_animations = {}

	self:reset_changed_settings()

	local user_setting = Application.user_setting("overriden_settings")

	user_setting = user_setting or {}
	self.overriden_settings = user_setting

	self:create_ui_elements()

	local get_service = input_manager:get_service("options_menu")
	local var_4_4 = var_0_0.scenegraph_definition.root.position[3]

	self.menu_input_description = MenuInputDescriptionUI:new(arg_4_1, self.ui_top_renderer, get_service, 7, var_4_4, tbl.main_menu.reset)

	self:_setup_input_functions()
end

OptionsView._setup_input_functions = function (self)
	-- function 5
	self._input_functions = {
		checkbox = function (self, arg_6_1, arg_6_2)
			-- function 6
			if not self.content.hotspot.on_release then
				WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")
				self.content.callback(self.content)
			end
		end,
		option = function (self, arg_7_1, arg_7_2)
			-- function 7
			local content = self.content
			local num_options = content.num_options
			local current_selection = content.current_selection

			for i = 1, num_options do
				if not (not content["option_" .. i].on_release and current_selection == i) then
					WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")

					content.current_selection = i

					content.callback(self.content)

					return
				end
			end
		end,
		slider = function (self, arg_8_1, arg_8_2)
			-- function 8
			local content = self.content
			local style = self.style
			local left_hotspot = content.left_hotspot
			local right_hotspot = content.right_hotspot
			local callback_on_release = content.callback_on_release

			if not content.changed then
				content.changed = nil

				content.callback(content, style)
			end

			if not arg_8_1:get("left_hold") then
				content.altering_value = true
			else
				content.altering_value = nil
			end

			local input_cooldown = content.input_cooldown
			local input_cooldown_multiplier = content.input_cooldown_multiplier
			local flag = false

			if not input_cooldown then
				flag = true

				local max = math.max(input_cooldown - arg_8_2, 0)

				input_cooldown = not (max > 0) or not max or nil
				content.input_cooldown = input_cooldown
			end

			local internal_value = content.internal_value
			local num_decimals = content.num_decimals
			local min = content.min
			local num = 1 / ((content.max - min) * 10^num_decimals)
			local flag_2 = false

			if left_hotspot.is_clicked == 0 or not left_hotspot.on_release then
				internal_value = math.clamp(internal_value - num, 0, 1)
				flag_2 = true
			elseif right_hotspot.is_clicked == 0 or not right_hotspot.on_release then
				internal_value = math.clamp(internal_value + num, 0, 1)
				flag_2 = true
			end

			if not flag_2 then
				if not input_cooldown then
					content.internal_value = internal_value

					if not callback_on_release and left_hotspot.on_release or not right_hotspot.on_release then
						content.changed = true
					end

					if not flag then
						local max_2 = math.max(input_cooldown_multiplier - 0.1, 0.1)

						content.input_cooldown = 0.2 * math.ease_in_exp(max_2)
						content.input_cooldown_multiplier = max_2
					else
						local num_2 = 1

						content.input_cooldown = 0.2 * math.ease_in_exp(num_2)
						content.input_cooldown_multiplier = num_2
					end
				elseif not callback_on_release and left_hotspot.on_release and not right_hotspot.on_release then
					content.internal_value = internal_value
					content.changed = true
				end
			end
		end,
		drop_down = function (self, arg_9_1, arg_9_2)
			-- function 9
			local content = self.content
			local list_style = self.style.list_style
			local list_content = content.list_content
			local item_styles = list_style.item_styles
			local start_index = list_style.start_index
			local num_draws = list_style.num_draws
			local total_draws = list_style.total_draws
			local using_scrollbar = content.using_scrollbar
			local thumbnail_hotspot = content.thumbnail_hotspot

			if not content.active then
				local hotspot = content.hotspot

				if not hotspot.on_hover_enter then
					WwiseWorld.trigger_event(self.wwise_world, "Play_hud_hover")
				end

				local current_selection = content.current_selection

				if not hotspot.on_release and not current_selection then
					content.active = true
					list_style.active = true
					self.disable_all_input = true

					if not using_scrollbar then
						local num = total_draws - num_draws

						list_style.start_index = math.min(current_selection, num)
						thumbnail_hotspot.scroll_progress = (list_style.start_index - 1) / num
					end

					WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")
				end
			else
				local options_texts = content.options_texts

				for i = start_index, start_index - 1 + num_draws do
					local hotspot_2 = list_content[i].hotspot

					if not hotspot_2.disabled then
						if not hotspot_2.on_hover_enter then
							WwiseWorld.trigger_event(self.wwise_world, "Play_hud_hover")
						end

						if not hotspot_2.on_release then
							WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")

							content.current_selection = i

							content.callback(content)

							content.active = false
							list_style.active = false
							self.disable_all_input = false

							break
						end
					end
				end

				local was_dragging = content.was_dragging
				local dragging = content.dragging

				content.was_dragging = dragging

				if not Managers.input:is_device_active("gamepad") then
					if not using_scrollbar then
						local get = arg_9_1:get("scroll_axis")

						if not get then
							local y = get.y
							local flag = false

							if y > 0 then
								flag = true
								list_style.start_index = math.max(start_index - 1, 1)
							elseif y < 0 then
								flag = true
								list_style.start_index = math.min(start_index + 1, total_draws - num_draws + 1)
							end

							if not flag then
								local start_index_2 = list_style.start_index
								local num_2 = total_draws - num_draws

								thumbnail_hotspot.scroll_progress = (start_index_2 - 1) / num_2
							end
						end
					end

					if not (not arg_9_1:get("left_release") and dragging or was_dragging) then
						content.active = false
						list_style.active = false
						self.disable_all_input = false

						WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")
					end
				end
			end
		end,
		stepper = function (self, arg_10_1, arg_10_2)
			-- function 10
			local content = self.content
			local current_selection = content.current_selection

			current_selection = current_selection or 0

			local var_10_2 = current_selection
			local left_hotspot = content.left_hotspot
			local right_hotspot = content.right_hotspot

			if left_hotspot.on_release or not content.controller_on_release_left then
				content.controller_on_release_left = nil
				var_10_2 = var_10_2 - 1

				if var_10_2 == 0 then
					var_10_2 = content.num_options
				end
			end

			if right_hotspot.on_release or not content.controller_on_release_right then
				content.controller_on_release_right = nil
				var_10_2 = var_10_2 + 1

				if var_10_2 > content.num_options then
					var_10_2 = 1
				end
			end

			if var_10_2 ~= current_selection then
				WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")

				local style = self.style

				content.current_selection = var_10_2

				content.callback(content, style)
			end
		end,
		keybind = function (self, arg_11_1, arg_11_2)
			-- function 11
			if not Managers.input:is_device_active("gamepad") then
				return
			end

			local content = self.content
			local active = content.active

			if not active then
				if not content.hotspot_1.on_release then
					active = true
					content.active_1 = true
				elseif not content.hotspot_2.on_release then
					active = true
					content.active_2 = true
				elseif not content.hotspot_1.on_right_click then
					local keybind = content.actions_info[1].keybind
					local var_11_3 = keybind[4]

					var_11_3 = var_11_3 or "keyboard"

					local var_11_4 = keybind[5]

					var_11_4 = var_11_4 or UNASSIGNED_KEY

					content.callback(UNASSIGNED_KEY, "keyboard", content, 2)
					content.callback(var_11_4, var_11_3, content, 1)
				elseif not content.hotspot_2.on_right_click then
					content.callback(UNASSIGNED_KEY, "keyboard", content, 2)
				end

				if not active then
					content.active = true
					content.active_t = 0
					self.disable_all_input = true

					self.input_manager:block_device_except_service("options_menu", "keyboard", 1, "keybind")
					self.input_manager:block_device_except_service("options_menu", "mouse", 1, "keybind")
					self.input_manager:block_device_except_service("options_menu", "gamepad", 1, "keybind")
					WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")
				end
			else
				local flag = false
				local flag_2

				flag_2 = not content.active_1 and 1 and 2

				if not content.controller_input_pressed then
					flag = true
				end

				local any_released = Keyboard.any_released()

				if not (flag or any_released ~= 27) then
					flag = true
				end

				if not (flag or any_released == nil) then
					local button_name = Keyboard.button_name(any_released)

					if not (not button_name and button_name == "") then
						content.callback(button_name, "keyboard", content, flag_2)

						flag = true
					end
				end

				local any_released_2 = Mouse.any_released()

				if not (flag or any_released_2 == nil) then
					local button_name_2 = Mouse.button_name(any_released_2)

					if not fn_3(content.actions, button_name_2) then
						content.callback(button_name_2, "mouse", content, flag_2)

						flag = true
					end
				end

				if not flag then
					content.controller_input_pressed = nil
					content.active = false
					content.active_1 = false
					content.active_2 = false
					self.disable_all_input = false

					self.input_manager:device_unblock_all_services("keyboard", 1)
					self.input_manager:device_unblock_all_services("mouse", 1)
					self.input_manager:device_unblock_all_services("gamepad", 1)
					self.input_manager:block_device_except_service("options_menu", "keyboard", 1)
					self.input_manager:block_device_except_service("options_menu", "mouse", 1)
					self.input_manager:block_device_except_service("options_menu", "gamepad", 1)
				end
			end
		end,
		sorted_list = function (self, arg_12_1, arg_12_2)
			-- function 12
			local content = self.content
			local style = self.style
			local list_content = content.list_content
			local item_styles = style.list_style.item_styles
			local current_selection = content.current_selection
			local var_12_5 = list_content[current_selection]
			local wwise_world = self.wwise_world
			local count = #list_content
			local up_hotspot = content.up_hotspot
			local down_hotspot = content.down_hotspot

			if up_hotspot.on_hover_enter or not down_hotspot.on_hover_enter then
				WwiseWorld.trigger_event(wwise_world, "Play_hud_hover")
			end

			if not current_selection then
				if current_selection > 1 then
					if not up_hotspot.active then
						up_hotspot.active = true
					end
				elseif not up_hotspot.active then
					up_hotspot.active = false
				end

				if current_selection < count then
					if not down_hotspot.active then
						down_hotspot.active = true
					end
				elseif not down_hotspot.active then
					down_hotspot.active = false
				end
			elseif up_hotspot.active or not down_hotspot.active then
				up_hotspot.active = false
				down_hotspot.active = false
			end

			if up_hotspot.on_release or not down_hotspot.on_release then
				local current_selection_2 = content.current_selection
				local var_12_11

				if not up_hotspot.on_release then
					var_12_11 = current_selection_2 - 1
				else
					var_12_11 = current_selection_2 + 1
				end

				list_content[current_selection_2].index_text, list_content[var_12_11].index_text = list_content[var_12_11].index_text, list_content[current_selection_2].index_text
				list_content[current_selection_2], list_content[var_12_11] = list_content[var_12_11], list_content[current_selection_2]
				item_styles[current_selection_2], item_styles[var_12_11] = item_styles[var_12_11], item_styles[current_selection_2]
				content.current_selection = var_12_11

				WwiseWorld.trigger_event(wwise_world, "Play_hud_select")
				content.callback(content, style)
			else
				for i = 1, count do
					local var_12_12 = list_content[i]

					if var_12_12 ~= var_12_5 then
						local hotspot = var_12_12.hotspot

						if not hotspot.on_hover_enter then
							WwiseWorld.trigger_event(wwise_world, "Play_hud_hover")
						end

						if not hotspot.on_release then
							WwiseWorld.trigger_event(wwise_world, "Play_hud_select")

							content.current_selection = i
							hotspot.is_selected = true

							if not var_12_5 then
								var_12_5.hotspot.is_selected = false
							end

							break
						end
					end
				end
			end
		end,
		text_link = function (self, arg_13_1, arg_13_2)
			-- function 13
			local content = self.content

			if content.hotspot.on_release or not content.controller_input_pressed then
				content.controller_input_pressed = nil

				local url = self.content.url

				if not url then
					WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")
					Application.open_url_in_browser(url)
				end
			end
		end,
		image = function ()
			-- function 14
			return
		end,
		title = function ()
			-- function 15
			return
		end,
		gamepad_layout = function ()
			-- function 16
			return
		end
	}
end

OptionsView.input_service = function (self)
	-- function 17
	return self.input_manager:get_service("options_menu")
end

OptionsView.cleanup_popups = function (self)
	-- function 18
	if not self.save_data_error_popup_id then
		Managers.popup:cancel_popup(self.save_data_error_popup_id)

		self.save_data_error_popup_id = nil
	end

	if not self.apply_popup_id then
		Managers.popup:cancel_popup(self.apply_popup_id)

		self.apply_popup_id = nil

		self:handle_apply_popup_results("revert_changes")
	end

	if not self.apply_bot_spawn_priority_popup_id then
		Managers.popup:cancel_popup(self.apply_bot_spawn_priority_popup_id)

		self.apply_bot_spawn_priority_popup_id = nil
	end

	if not self.title_popup_id then
		Managers.popup:cancel_popup(self.title_popup_id)

		self.title_popup_id = nil
	end

	if not self.exit_popup_id then
		Managers.popup:cancel_popup(self.exit_popup_id)

		self.exit_popup_id = nil
	end

	if not self.reset_popup_id then
		Managers.popup:cancel_popup(self.reset_popup_id)

		self.reset_popup_id = nil
	end
end

OptionsView.destroy = function (self)
	-- function 19
	self:cleanup_popups()

	if not self._cursor_pushed then
		ShowCursorStack.hide("OptionsView")

		self._cursor_pushed = nil
	end

	self.menu_input_description:destroy()

	self.menu_input_description = nil

	GarbageLeakDetector.register_object(self, "OptionsView")
end

RELOAD_OPTIONS_VIEW = true

OptionsView.create_ui_elements = function (self)
	-- function 20
	self.background_widgets = {}

	local num = 0

	for k, v in pairs(background_widget_definitions) do
		num = num + 1
		self.background_widgets[num] = UIWidget.init(v)

		if k == "right_frame" then
			self.scroll_field_widget = self.background_widgets[num]
		end
	end

	self.background_widgets_n = num
	self.gamepad_tooltip_text_widget = UIWidget.init(gamepad_frame_widget_definitions.gamepad_tooltip_text)
	self.keybind_info_widget = UIWidget.init(widget_definitions.keybind_info)
	self.title_buttons = {}

	local num_2 = 0

	for i, v_2 in ipairs(title_button_definitions) do
		num_2 = num_2 + 1
		self.title_buttons[num_2] = UIWidget.init(v_2)
	end

	self.title_buttons_n = num_2

	if not self.is_in_tutorial then
		for i_2, v_3 in ipairs(self.title_buttons) do
			if not TutorialSettingsMenuNavigation[i_2] then
				v_3.content.button_text.disable_button = true
			end
		end
	end

	self.exit_button = UIWidget.init(button_definitions.exit_button)
	self.apply_button = UIWidget.init(button_definitions.apply_button)
	self.reset_to_default = UIWidget.init(button_definitions.reset_to_default)
	self.back_button = UIWidget.init(button_definitions.back_button)
	self.scrollbar = UIWidget.init(var_0_0.scrollbar_definition)
	self.scrollbar.content.disable_frame = true
	self.safe_rect_widget = UIWidget.init(var_0_0.create_safe_rect_widget())

	local tbl = {
		hide_reset = true,
		widgets_n = 0,
		scenegraph_id_start = "calibrate_ui_dummy",
		widgets = {}
	}
	local tbl_2 = {}

	if not IS_WINDOWS then
		if not rawget(_G, "Tobii") then
			local var_20_4
			local get_is_connected = Tobii.get_is_connected()

			self._tobii_is_connected = get_is_connected

			if not get_is_connected then
				var_20_4 = var_0_1.tobii_settings_definition
			else
				var_20_4 = {
					{
						text = "settings_view_header_eyetracker_not_found",
						url = "http://tobiigaming.com/",
						widget_type = "text_link"
					}
				}
			end

			local build_settings_list = self:build_settings_list(var_20_4, "tobii_eyetracking_settings_list")

			tbl_2.tobii_eyetracking_settings = build_settings_list

			build_settings_list.on_enter = function (arg_21_0)
				-- function 21
				local players = Managers.player:players()

				for k, v in pairs(players) do
					local player_unit = v.player_unit

					if not v.local_player and not ScriptUnit.has_extension(player_unit, "eyetracking_system") then
						ScriptUnit.extension(player_unit, "eyetracking_system"):set_eyetracking_options_opened(true)
					end
				end
			end

			build_settings_list.on_exit = function ()
				-- function 22
				local players = Managers.player:players()

				for k, v in pairs(players) do
					local player_unit = v.player_unit

					if not v.local_player and not ScriptUnit.has_extension(player_unit, "eyetracking_system") then
						ScriptUnit.extension(player_unit, "eyetracking_system"):set_eyetracking_options_opened(false)
					end
				end
			end
		end

		tbl_2.video_settings = self:build_settings_list(var_0_1.video_settings_definition, "video_settings_list")

		if Managers.voice_chat or not self.voip then
			tbl_2.audio_settings = self:build_settings_list(var_0_1.audio_settings_definition, "audio_settings_list")
		else
			tbl_2.audio_settings = self:build_settings_list(var_0_1.audio_settings_definition_without_voip, "audio_settings_list")
		end

		tbl_2.gameplay_settings = self:build_settings_list(var_0_1.gameplay_settings_definition, "gameplay_settings_list")
		tbl_2.display_settings = self:build_settings_list(var_0_1.display_settings_definition, "display_settings_list")
		tbl_2.keybind_settings = self:build_settings_list(var_0_1.keybind_settings_definition, "keybind_settings_list")
		tbl_2.gamepad_settings = self:build_settings_list(var_0_1.gamepad_settings_definition, "gamepad_settings_list")
		tbl_2.network_settings = self:build_settings_list(var_0_1.network_settings_definition, "network_settings_list")
		tbl_2.versus_settings = self:build_settings_list(var_0_1.versus_settings_definition, "versus_settings_list")
		tbl_2.video_settings.hide_reset = true
		tbl_2.video_settings.needs_apply_confirmation = true
	elseif not IS_XB1 then
		if Managers.voice_chat or not self.voip then
			tbl_2.audio_settings = self:build_settings_list(var_0_1.audio_settings_definition, "audio_settings_list")
		else
			tbl_2.audio_settings = self:build_settings_list(var_0_1.audio_settings_definition_without_voip, "audio_settings_list")
		end

		tbl_2.gameplay_settings = self:build_settings_list(var_0_1.gameplay_settings_definition, "gameplay_settings_list")
		tbl_2.display_settings = self:build_settings_list(var_0_1.display_settings_definition, "display_settings_list")
		tbl_2.gamepad_settings = self:build_settings_list(var_0_1.gamepad_settings_definition, "gamepad_settings_list")

		if not GameSettingsDevelopment.allow_keyboard_mouse then
			tbl_2.keybind_settings = self:build_settings_list(var_0_1.keybind_settings_definition, "keybind_settings_list")
		end

		tbl_2.accessibility_settings = self:build_settings_list(var_0_1.accessibility_settings_definition, "accessibility_settings_list")
	else
		if Managers.voice_chat or not self.voip then
			tbl_2.audio_settings = self:build_settings_list(var_0_1.audio_settings_definition, "audio_settings_list")
		else
			tbl_2.audio_settings = self:build_settings_list(var_0_1.audio_settings_definition_without_voip, "audio_settings_list")
		end

		tbl_2.gameplay_settings = self:build_settings_list(var_0_1.gameplay_settings_definition, "gameplay_settings_list")
		tbl_2.display_settings = self:build_settings_list(var_0_1.display_settings_definition, "display_settings_list")
		tbl_2.gamepad_settings = self:build_settings_list(var_0_1.gamepad_settings_definition, "gamepad_settings_list")
		tbl_2.motion_control_settings = self:build_settings_list(var_0_1.motion_control_settings_definition, "motion_control_settings_list")
		tbl_2.accessibility_settings = self:build_settings_list(var_0_1.accessibility_settings_definition, "accessibility_settings_list")
	end

	self.settings_lists = tbl_2
	self.selected_widget = nil
	self.selected_title = nil
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.ui_calibration_view = UICalibrationView:new()
	self._animations = {}
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, var_0_0.animation_definitions)
	RELOAD_OPTIONS_VIEW = false

	self:_setup_text_buttons_width()
end

OptionsView._setup_text_buttons_width = function (self)
	-- function 23
	local _setup_text_button_size = self:_setup_text_button_size(self.apply_button)

	self:_setup_text_button_size(self.reset_to_default)
	self:_set_text_button_horizontal_position(self.reset_to_default, -(_setup_text_button_size + 50))

	local num = 0

	for i, v in ipairs(self.title_buttons) do
		local _setup_text_button_size_2 = self:_setup_text_button_size(v)

		self:_set_text_button_horizontal_position(v, num)

		num = num + _setup_text_button_size_2 + 20
	end
end

OptionsView._setup_text_button_size = function (self, arg_24_1)
	-- function 24
	local scenegraph_id = arg_24_1.scenegraph_id
	local content = arg_24_1.content
	local text = arg_24_1.style.text
	local text_field = content.text_field

	text_field = text_field or content.text

	if not text.localize then
		text_field = Localize(text_field)
	end

	if not text.upper_case then
		text_field = TextToUpper(text_field)
	end

	local ui_scenegraph = self.ui_scenegraph
	local ui_renderer = self.ui_renderer
	local var_24_6, var_24_7 = UIFontByResolution(text)
	local text_size, var_24_9, var_24_10 = UIRenderer.text_size(ui_renderer, text_field, var_24_6[1], var_24_7)

	ui_scenegraph[scenegraph_id].size[1] = text_size

	return text_size
end

OptionsView._set_text_button_horizontal_position = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	arg_25_0.ui_scenegraph[arg_25_1.scenegraph_id].local_position[1] = arg_25_2
end

OptionsView.build_settings_list = function (self, arg_26_1, arg_26_2)
	-- function 26
	local scenegraph_definition = var_0_0.scenegraph_definition
	local str = arg_26_2 .. "start"
	local num = 0
	local tbl = {}
	local num_2 = 0
	local count = #arg_26_1
	local unlock = Managers.unlock

	for i = 1, count do
		local var_26_7 = arg_26_1[i]
		local tbl_2 = {
			0,
			-num,
			0
		}
		local var_26_9
		local num_3 = 0
		local widget_type = var_26_7.widget_type
		local flag = true

		if not (not var_26_7.required_dlc and unlock:is_dlc_unlocked(var_26_7.required_dlc)) then
			flag = false
		elseif not var_26_7.required_render_caps then
			for k, v in pairs(var_26_7.required_render_caps) do
				if Application.render_caps(k) ~= v then
					flag = false

					break
				end
			end
		end

		if not flag then
			if widget_type == "drop_down" then
				var_26_9 = self:build_drop_down_widget(var_26_7, str, tbl_2)
			elseif widget_type == "option" then
				var_26_9 = self:build_option_widget(var_26_7, str, tbl_2)
			elseif widget_type == "slider" then
				var_26_9 = self:build_slider_widget(var_26_7, str, tbl_2)
			elseif widget_type == "checkbox" then
				var_26_9 = self:build_checkbox_widget(var_26_7, str, tbl_2)
			elseif widget_type == "stepper" then
				var_26_9 = self:build_stepper_widget(var_26_7, str, tbl_2)
			elseif widget_type == "keybind" then
				var_26_9 = self:build_keybind_widget(var_26_7, str, tbl_2)
			elseif widget_type == "sorted_list" then
				var_26_9 = self:build_sorted_list_widget(var_26_7, str, tbl_2)
			elseif widget_type == "image" then
				var_26_9 = self:build_image(var_26_7, str, tbl_2)
			elseif widget_type == "gamepad_layout" then
				var_26_9 = self:build_gamepad_layout(var_26_7, str, tbl_2)
				self.gamepad_layout_widget = var_26_9

				local var_26_13 = fn_2(self.changed_user_settings.gamepad_layout, Application.user_setting("gamepad_layout"))
				local var_26_14 = fn_2(self.changed_user_settings.gamepad_left_handed, Application.user_setting("gamepad_left_handed"))
				local AlternatateGamepadKeymapsLayoutsLeftHanded

				if not var_26_14 then
					AlternatateGamepadKeymapsLayoutsLeftHanded = AlternatateGamepadKeymapsLayoutsLeftHanded

					if not AlternatateGamepadKeymapsLayoutsLeftHanded then
						-- Nothing
					end
				end

				AlternatateGamepadKeymapsLayoutsLeftHanded = AlternatateGamepadKeymapsLayouts

				::label_26_0::

				local var_26_16 = AlternatateGamepadKeymapsLayoutsLeftHanded[var_26_13]

				self:update_gamepad_layout_widget(var_26_16, var_26_14)
			elseif widget_type == "empty" then
				num_3 = var_26_7.size_y
			elseif widget_type == "title" then
				var_26_9 = self:build_title(var_26_7, str, tbl_2)
			elseif widget_type == "text_link" then
				var_26_9 = self:build_text_link(var_26_7, str, tbl_2)
			else
				error("[OptionsView] Unsupported widget type")
			end
		end

		if not var_26_9 then
			local callback = var_26_7.callback

			num_3 = var_26_9.style.size[2]

			rawset(var_26_9, "type", widget_type)
			rawset(var_26_9, "name", callback)
			rawset(var_26_9, "ui_animations", {})

			var_26_9.content.definition = var_26_7
		end

		num = num + num_3

		if not var_26_9 then
			if not var_26_7.name then
				var_26_9.name = var_26_7.name
			end

			num_2 = num_2 + 1
			tbl[num_2] = var_26_9
		end
	end

	local size = scenegraph_definition.list_mask.size
	local var_26_19 = size[1]

	scenegraph_definition[arg_26_2] = {
		vertical_alignment = "top",
		parent = "list_mask",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			-1
		},
		offset = {
			0,
			0,
			0
		},
		size = {
			var_26_19,
			num
		}
	}
	scenegraph_definition[str] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		parent = arg_26_2,
		position = {
			30,
			0,
			10
		},
		size = {
			1,
			1
		}
	}

	local flag_2 = false
	local num_4 = 0

	if num > size[2] then
		flag_2 = true
		num_4 = num - size[2]
	end

	return {
		visible_widgets_n = 0,
		scenegraph_id = arg_26_2,
		scenegraph_id_start = str,
		scrollbar = flag_2,
		max_offset_y = num_4,
		widgets = tbl,
		widgets_n = num_2
	}
end

OptionsView.make_callback = function (arg_27_0, arg_27_1)
	-- function 27
	return function (...)
		-- function 28
		arg_27_0[arg_27_1](arg_27_0, ...)

		local changed_user_settings = arg_27_0.changed_user_settings
		local original_user_settings = arg_27_0.original_user_settings

		for k, v in pairs(changed_user_settings) do
			if not original_user_settings[k] then
				original_user_settings[k] = Application.user_setting(k)
			end

			if v == original_user_settings[k] then
				changed_user_settings[k] = nil
			end
		end

		local changed_render_settings = arg_27_0.changed_render_settings
		local original_render_settings = arg_27_0.original_render_settings

		for k_2, v_2 in pairs(changed_render_settings) do
			if not original_render_settings[k_2] then
				original_render_settings[k_2] = Application.user_setting("render_settings", k_2)
			end

			if v_2 == original_render_settings[k_2] then
				changed_render_settings[k_2] = nil
			end
		end

		local changed_versus_settings = arg_27_0.changed_versus_settings
		local original_versus_settings = arg_27_0.original_versus_settings

		for k_3, v_3 in pairs(changed_versus_settings) do
			if not original_versus_settings[k_3] then
				original_versus_settings[k_3] = Application.user_setting("versus_settings", k_3)
			end

			if v_3 == original_versus_settings[k_3] then
				changed_versus_settings[k_3] = nil
			end
		end
	end
end

OptionsView.build_stepper_widget = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local callback = arg_29_1.callback
	local make_callback = self:make_callback(callback)
	local saved_value = arg_29_1.saved_value
	local var_29_3 = callback(self, saved_value)
	local condition = arg_29_1.condition
	local flag = not condition and callback(self, condition)
	local var_29_6, var_29_7, var_29_8, var_29_9 = self[arg_29_1.setup](self)
	local create_stepper_widget = var_0_0.create_stepper_widget(var_29_8, var_29_7, var_29_6, arg_29_1.tooltip_text, arg_29_1.disabled_tooltip_text, arg_29_2, arg_29_3, arg_29_1.indent_level)
	local content = create_stepper_widget.content

	content.callback = make_callback
	content.saved_value_cb = var_29_3
	content.condition_cb = flag
	content.on_hover_enter_callback = callback(self, "on_stepper_arrow_hover", create_stepper_widget)
	content.on_hover_exit_callback = callback(self, "on_stepper_arrow_dehover", create_stepper_widget)
	content.default_value = var_29_9

	return create_stepper_widget
end

OptionsView.build_option_widget = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	local callback = arg_30_1.callback
	local make_callback = self:make_callback(callback)
	local saved_value = arg_30_1.saved_value
	local var_30_3 = callback(self, saved_value)
	local condition = arg_30_1.condition
	local flag = not condition and callback(self, condition)
	local var_30_6, var_30_7, var_30_8, var_30_9 = self[arg_30_1.setup](self)
	local ui_renderer = self.ui_renderer
	local create_option_widget = var_0_0.create_option_widget(ui_renderer, var_30_8, var_30_7, var_30_6, arg_30_1.tooltip_text, arg_30_2, arg_30_3)
	local content = create_option_widget.content

	content.callback = make_callback
	content.saved_value_cb = var_30_3
	content.condition_cb = flag
	content.default_value = var_30_9

	return create_option_widget
end

OptionsView.build_drop_down_widget = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local callback = arg_31_1.callback
	local make_callback = self:make_callback(callback)
	local saved_value = arg_31_1.saved_value
	local var_31_3 = callback(self, saved_value)
	local condition = arg_31_1.condition
	local flag = not condition and callback(self, condition)
	local ignore_upper_case = arg_31_1.ignore_upper_case
	local var_31_7, var_31_8, var_31_9, var_31_10 = self[arg_31_1.setup](self)
	local create_drop_down_widget = var_0_0.create_drop_down_widget(var_31_9, var_31_8, var_31_7, arg_31_1.tooltip_text, arg_31_1.disabled_tooltip_text, arg_31_2, arg_31_3, arg_31_1.indent_level, ignore_upper_case)
	local content = create_drop_down_widget.content

	content.callback = make_callback
	content.saved_value_cb = var_31_3
	content.default_value = var_31_10
	content.condition_cb = flag

	return create_drop_down_widget
end

OptionsView.build_slider_widget = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	local callback = arg_32_1.callback
	local make_callback = self:make_callback(callback)
	local callback_on_release = arg_32_1.callback_on_release
	local saved_value = arg_32_1.saved_value
	local var_32_4 = callback(self, saved_value)
	local condition = arg_32_1.condition
	local flag = not condition and callback(self, condition)
	local setup = arg_32_1.setup
	local slider_image = arg_32_1.slider_image
	local slider_image_text = arg_32_1.slider_image_text
	local var_32_10, var_32_11, var_32_12, var_32_13, var_32_14, var_32_15 = self[setup](self)

	fassert(type(var_32_10) == "number", "Value type is wrong, need number, got %q", type(var_32_10))

	local create_slider_widget = var_0_0.create_slider_widget(var_32_14, arg_32_1.tooltip_text, arg_32_2, arg_32_3, slider_image, slider_image_text)
	local content = create_slider_widget.content

	content.min = var_32_11
	content.max = var_32_12
	content.internal_value = var_32_10
	content.num_decimals = var_32_13
	content.callback = make_callback
	content.callback_on_release = callback_on_release
	content.on_hover_enter_callback = callback(self, "on_stepper_arrow_hover", create_slider_widget)
	content.on_hover_exit_callback = callback(self, "on_stepper_arrow_dehover", create_slider_widget)
	content.saved_value_cb = var_32_4
	content.default_value = var_32_15
	content.condition_cb = flag

	return create_slider_widget
end

OptionsView.build_image = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	local create_simple_texture_widget = var_0_0.create_simple_texture_widget(arg_33_1.image, arg_33_1.image_size, arg_33_2, arg_33_3)
	local content = create_simple_texture_widget.content

	content.callback = function ()
		-- function 34
		return
	end

	content.saved_value_cb = function ()
		-- function 35
		return
	end

	content.disabled = true

	return create_simple_texture_widget
end

OptionsView.build_title = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	local create_title_widget = var_0_0.create_title_widget(arg_36_1.text, arg_36_1.font_size, arg_36_1.color, arg_36_1.horizontal_alignment, arg_36_2, arg_36_3)
	local content = create_title_widget.content

	content.callback = function ()
		-- function 37
		return
	end

	content.saved_value_cb = function ()
		-- function 38
		return
	end

	content.disabled = true

	return create_title_widget
end

OptionsView.build_text_link = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local create_text_link_widget = var_0_0.create_text_link_widget(arg_39_1.text, arg_39_1.url, arg_39_1.font_size, arg_39_1.color, arg_39_1.horizontal_alignment, arg_39_2, arg_39_3)
	local content = create_text_link_widget.content

	content.callback = function ()
		-- function 40
		return
	end

	content.saved_value_cb = function ()
		-- function 41
		return
	end

	return create_text_link_widget
end

OptionsView.clear_gamepad_layout_widget = function (self)
	-- function 42
	local default_gamepad_actions_by_key

	if not fn_2(self.changed_user_settings.gamepad_left_handed, Application.user_setting("gamepad_left_handed")) then
		default_gamepad_actions_by_key = AlternatateGamepadSettings.left_handed.default_gamepad_actions_by_key

		if not default_gamepad_actions_by_key then
			-- Nothing
		end
	end

	default_gamepad_actions_by_key = AlternatateGamepadSettings.default.default_gamepad_actions_by_key

	::label_42_0::

	local content = self.gamepad_layout_widget.content
	local background = content.background
	local background1 = content.background1
	local background2 = content.background2
	local saved_value_cb = content.saved_value_cb

	table.clear(content)

	content.background = background
	content.background1 = background1
	content.background2 = background2
	content.saved_value_cb = saved_value_cb

	if not IS_WINDOWS then
		content.use_texture2_layout = fn_2(self.changed_user_settings.gamepad_use_ps4_style_input_icons, Application.user_setting("gamepad_use_ps4_style_input_icons"))
	end

	for k, v in pairs(default_gamepad_actions_by_key) do
		content[k] = Localize(v)
	end
end

OptionsView.update_gamepad_layout_widget = function (self, arg_43_1, arg_43_2)
	-- function 43
	local content = self.gamepad_layout_widget.content
	local tbl = {}

	self:clear_gamepad_layout_widget()

	local ignore_gamepad_action_names

	if not arg_43_2 then
		ignore_gamepad_action_names = AlternatateGamepadSettings.left_handed.ignore_gamepad_action_names

		if not ignore_gamepad_action_names then
			-- Nothing
		end
	end

	ignore_gamepad_action_names = AlternatateGamepadSettings.default.ignore_gamepad_action_names

	do
		local replace_gamepad_action_names
	end

	::label_43_0::

	if not arg_43_2 then
		replace_gamepad_action_names = AlternatateGamepadSettings.left_handed.replace_gamepad_action_names

		if not replace_gamepad_action_names then
			-- Nothing
		end
	end

	replace_gamepad_action_names = AlternatateGamepadSettings.default.replace_gamepad_action_names

	::label_43_1::

	for k, v in pairs(arg_43_1) do
		for k_2, v_2 in pairs(v) do
			for k_3, v_3 in pairs(v_2) do
				repeat
					if var_0_1.ignore_keybind[k_3] or not ignore_gamepad_action_names or not ignore_gamepad_action_names[k_3] then
						break
					end

					if #v_3 < 3 then
						break
					end

					local var_43_4 = v_3[2]
					local var_43_5 = tbl[var_43_4]

					var_43_5 = var_43_5 or {}
					tbl[var_43_4] = var_43_5

					if not replace_gamepad_action_names and not replace_gamepad_action_names[k_3] then
						k_3 = replace_gamepad_action_names[k_3]
					end

					var_43_5[#var_43_5 + 1] = k_3
				until true
			end
		end
	end

	local tbl_2 = {}

	for k_4, v_4 in pairs(tbl) do
		for i8 = 1, #v_4 do
			local var_43_7 = v_4[i8]

			if not content[k_4] then
				content[k_4] = Localize(var_43_7)
			else
				table.clear(tbl_2)

				tbl_2[1] = Localize(var_43_7)
				tbl_2[2] = content[k_4]

				table.sort(tbl_2)

				content[k_4] = tbl_2[1] .. "/" .. tbl_2[2]
			end
		end
	end
end

OptionsView.build_gamepad_layout = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local create_gamepad_layout_widget = var_0_0.create_gamepad_layout_widget(arg_44_1.bg_image, arg_44_1.bg_image_size, arg_44_1.bg_image2, arg_44_1.bg_image_size2, arg_44_2, arg_44_3)
	local content = create_gamepad_layout_widget.content

	content.callback = function ()
		-- function 45
		return
	end

	content.saved_value_cb = function ()
		-- function 46
		return
	end

	content.disabled = true

	return create_gamepad_layout_widget
end

OptionsView.build_checkbox_widget = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	local callback = arg_47_1.callback
	local make_callback = self:make_callback(callback)
	local saved_value = arg_47_1.saved_value
	local var_47_3 = callback(self, saved_value)
	local condition = arg_47_1.condition
	local flag = not condition and callback(self, condition)
	local var_47_6, var_47_7, var_47_8 = self[arg_47_1.setup](self)

	fassert(type(var_47_6) == "boolean", "Flag type is wrong, need boolean, got %q", type(var_47_6))

	local create_checkbox_widget = var_0_0.create_checkbox_widget(var_47_7, arg_47_2, arg_47_3)
	local content = create_checkbox_widget.content

	content.flag = var_47_6
	content.callback = make_callback
	content.saved_value_cb = var_47_3
	content.default_value = var_47_8
	content.condition_cb = flag

	return create_checkbox_widget
end

OptionsView.build_keybind_widget = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local var_48_0 = callback(self, "cb_keybind_changed")
	local var_48_1 = callback(self, "cb_keybind_saved_value")
	local cb_keybind_setup, var_48_3, var_48_4, var_48_5 = self:cb_keybind_setup(arg_48_1.keymappings_key, arg_48_1.keymappings_table_key, arg_48_1.actions)
	local create_keybind_widget = var_0_0.create_keybind_widget(cb_keybind_setup, var_48_3, arg_48_1.keybind_description, arg_48_1.actions, var_48_4, arg_48_2, arg_48_3)
	local content = create_keybind_widget.content

	content.callback = var_48_0
	content.saved_value_cb = var_48_1
	content.default_value = var_48_5
	content.keymappings_key = arg_48_1.keymappings_key
	content.keymappings_table_key = arg_48_1.keymappings_table_key

	return create_keybind_widget
end

OptionsView.build_sorted_list_widget = function (self, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	local callback = arg_49_1.callback
	local var_49_1 = callback(self, callback)
	local saved_value = arg_49_1.saved_value
	local var_49_3 = callback(self, saved_value)
	local condition = arg_49_1.condition
	local flag = not condition and callback(self, condition)
	local var_49_6, var_49_7, var_49_8, var_49_9, var_49_10, var_49_11 = self[arg_49_1.setup](self)
	local create_sorted_list_widget = var_0_0.create_sorted_list_widget(var_49_6, arg_49_1.tooltip_text, var_49_7, var_49_8, var_49_9, var_49_10, arg_49_2, arg_49_3)
	local content = create_sorted_list_widget.content

	content.callback = var_49_1
	content.saved_value_cb = var_49_3
	content.default_value = var_49_11
	content.condition_cb = flag

	return create_sorted_list_widget
end

OptionsView.widget_from_name = function (self, arg_50_1)
	-- function 50
	local selected_settings_list = self.selected_settings_list

	fassert(selected_settings_list, "[OptionsView] Trying to set disable on widget without a selected settings list.")

	local widgets = selected_settings_list.widgets
	local widgets_n = selected_settings_list.widgets_n

	for i = 1, widgets_n do
		local var_50_3 = widgets[i]

		if not (not var_50_3.name and var_50_3.name ~= arg_50_1) then
			return var_50_3
		end
	end
end

OptionsView.force_set_widget_value = function (self, arg_51_1, arg_51_2)
	-- function 51
	local widget_from_name = self:widget_from_name(arg_51_1)

	fassert(widget_from_name, "No widget with name %q in current settings list", arg_51_1)

	local type = widget_from_name.type

	if not (type == "stepper" or type ~= "option") then
		local content = widget_from_name.content
		local options_values = content.options_values

		for i = 1, #options_values do
			if arg_51_2 == options_values[i] then
				content.current_selection = i
			end
		end

		content.callback(content)
	else
		fassert(false, "Force set widget value not supported for widget type %q yet", type)
	end
end

OptionsView.set_widget_disabled = function (self, arg_52_1, arg_52_2)
	-- function 52
	local widget_from_name = self:widget_from_name(arg_52_1)

	if not widget_from_name then
		widget_from_name.content.disabled = arg_52_2
	end
end

OptionsView.on_enter = function (self, arg_53_1)
	-- function 53
	ShowCursorStack.show("OptionsView")

	self._cursor_pushed = true

	self:_setup_text_buttons_width()
	self:set_original_settings()
	self:reset_changed_settings()
	self:select_settings_title(1)

	self.in_settings_sub_menu = false
	self.gamepad_active_generic_actions_name = nil
	self.gamepad_tooltip_available = nil
	self._exit_transition = not arg_53_1 and arg_53_1.exit_transition

	if not self.input_manager:is_device_active("gamepad") then
		self.selected_title = nil

		self:set_console_title_selection(1, true)
	end

	WwiseWorld.trigger_event(self.wwise_world, "Play_hud_button_open")

	self.active = true
	self.safe_rect_alpha_timer = 0

	self.input_manager:block_device_except_service("options_menu", "keyboard", 1)
	self.input_manager:block_device_except_service("options_menu", "mouse", 1)
	self.input_manager:block_device_except_service("options_menu", "gamepad", 1)

	if not self.in_title_screen then
		local world = self.ui_renderer.world
		local get_data = World.get_data(world, "shading_environment")

		if not get_data then
			ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_enabled", 1)
			ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_amount", 0.75)
			ShadingEnvironment.apply(get_data)
		end
	end

	UIWidgetUtils.reset_layout_button(self.back_button)
	self:_start_animation("on_enter")
end

OptionsView._start_animation = function (self, arg_54_1)
	-- function 54
	local render_settings = self.render_settings

	render_settings = render_settings or {
		alpha_multiplier = 0,
		snap_pixel_positions = false
	}
	self.render_settings = render_settings

	local tbl = {
		render_settings = self.render_settings
	}

	self._animations[arg_54_1] = self._ui_animator:start_animation(arg_54_1, nil, self.ui_scenegraph, tbl, 1, 0)
end

OptionsView.on_exit = function (self)
	-- function 55
	if not self.exiting then
		Crashify.print_exception("[OptionsView]", "triggering on_exit() without triggering exit()")
	end

	self:cleanup_popups()
	ShowCursorStack.hide("OptionsView")

	self._cursor_pushed = nil

	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)

	self.exiting = nil
	self.active = nil

	local world = self.ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_enabled", 0)
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_amount", 0)
		ShadingEnvironment.apply(get_data)
	end
end

OptionsView.exit_reset_params = function (self)
	-- function 56
	self:cleanup_popups()

	if not self.selected_title then
		self:deselect_title(self.selected_title)

		self.in_settings_sub_menu = false
	end

	self.gamepad_active_generic_actions_name = nil
	self.gamepad_tooltip_available = nil

	WwiseWorld.trigger_event(self.wwise_world, "Play_hud_button_close")

	self.exiting = true
end

OptionsView.exit = function (self, arg_57_1)
	-- function 57
	self:exit_reset_params()

	local str

	if not arg_57_1 then
		str = "exit_menu"
	else
		str = self._exit_transition
		str = str or "ingame_menu"
	end

	self.ingame_ui:transition_with_fade(str)
end

OptionsView.transitioning = function (self)
	-- function 58
	if not self.exiting then
		return true
	else
		return not self.active
	end
end

OptionsView.get_keymaps = function (arg_59_0, arg_59_1, arg_59_2)
	-- function 59
	local tbl = {}
	local keybind_settings_definition = var_0_1.keybind_settings_definition

	if not keybind_settings_definition then
		return
	end

	for i, v in ipairs(keybind_settings_definition) do
		local keymappings_key = v.keymappings_key
		local actions = v.actions

		if not actions then
			local keymappings_table_key = v.keymappings_table_key

			if not tbl[keymappings_key] then
				tbl[keymappings_key] = {}
			end

			local var_59_5 = tbl[keymappings_key]
			local var_59_6 = rawget(_G, keymappings_key)

			for k, v_2 in pairs(var_59_6) do
				if not (not arg_59_2 and arg_59_2 ~= k) then
					if not var_59_5[k] then
						var_59_5[k] = {}
					end

					local var_59_7 = var_59_5[k]

					for k_2, v_3 in pairs(v_2) do
						if not table.contains(actions, k_2) then
							var_59_7[k_2] = table.clone(v_3)
						end
					end
				end
			end
		end
	end

	if not arg_59_1 then
		local controls = PlayerData.controls

		controls = controls or {}

		for k_3, v_4 in pairs(tbl) do
			local var_59_9 = controls[k_3]

			if not var_59_9 then
				for k_4, v_5 in pairs(var_59_9) do
					if not (not arg_59_2 and arg_59_2 ~= k_4) then
						for k_5, v_6 in pairs(v_5) do
							local var_59_10 = v_4[k_4]

							if not var_59_10 and not var_59_10[k_5] then
								var_59_10[k_5] = table.clone(v_6)
							end
						end
					end
				end
			end
		end
	end

	return tbl
end

OptionsView._get_original_bot_spawn_priority = function (arg_60_0)
	-- function 60
	local bot_spawn_priority = PlayerData.bot_spawn_priority

	if #bot_spawn_priority > 0 then
		return bot_spawn_priority
	else
		return ProfilePriority
	end
end

OptionsView.reset_changed_settings = function (self)
	-- function 61
	self.changed_user_settings = {}
	self.changed_render_settings = {}
	self.changed_versus_settings = {}

	local flag = true

	self.session_keymaps = self:get_keymaps(flag, "win32")
	self.changed_keymaps = false
	self.session_bot_spawn_priority = table.create_copy(self.session_bot_spawn_priority, self:_get_original_bot_spawn_priority())
	self.changed_bot_spawn_priority = false
end

OptionsView.set_original_settings = function (self)
	-- function 62
	self.original_user_settings = {}
	self.original_render_settings = {}
	self.original_versus_settings = {}

	local flag = true

	self.original_keymaps = self:get_keymaps(flag, "win32")
	self.original_bot_spawn_priority = table.create_copy(self.original_bot_spawn_priority, self:_get_original_bot_spawn_priority())
end

OptionsView._get_setting = function (self, arg_63_1, arg_63_2)
	-- function 63
	if arg_63_1 == "user_settings" then
		return fn_2(self.changed_user_settings[arg_63_2], Application.user_setting(arg_63_2))
	elseif arg_63_1 == "render_settings" then
		return fn_2(self.changed_render_settings[arg_63_2], Application.user_setting("render_settings", arg_63_2))
	elseif arg_63_1 == "versus_settings" then
		return fn_2(self.changed_versus_settings[arg_63_2], Application.user_setting("versus_settings", arg_63_2))
	end

	fassert(false, "Unknown setting_type: %q", arg_63_1)
end

OptionsView._set_setting = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	-- function 64
	if arg_64_1 == "user_settings" then
		arg_64_0.changed_user_settings[arg_64_2] = arg_64_3
	elseif arg_64_1 == "render_settings" then
		arg_64_0.changed_render_settings[arg_64_2] = arg_64_3
	elseif arg_64_1 == "versus_settings" then
		arg_64_0.changed_versus_settings[arg_64_2] = arg_64_3
	else
		fassert(false, "Unknown setting_type: %q", arg_64_1)
	end
end

OptionsView._set_setting_override = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	-- function 65
	local options_values = arg_65_1.options_values
	local find = table.find(options_values, arg_65_4)

	fassert(find, "Could not find the forced value %q for setting: %s", arg_65_4, arg_65_3)

	if self.overriden_settings[arg_65_3] == nil then
		local current_selection = arg_65_1.current_selection

		self.overriden_settings[arg_65_3] = options_values[current_selection]

		if find ~= current_selection then
			arg_65_1.current_selection = find

			local flag = true

			arg_65_1.callback(arg_65_1, arg_65_2, nil, flag)
		end
	end

	local var_65_4 = self.overriden_settings[arg_65_3]
	local find_2 = table.find(options_values, var_65_4)

	fassert(find_2, "Could not find the wanted value %q for setting: %s", var_65_4, arg_65_3)

	if find ~= find_2 then
		arg_65_1.overriden_setting = arg_65_1.options_texts[find_2]
	end
end

OptionsView._restore_setting_override = function (self, arg_66_1, arg_66_2, arg_66_3)
	-- function 66
	local var_66_0 = self.overriden_settings[arg_66_3]

	if var_66_0 == nil then
		return
	end

	local find = table.find(arg_66_1.options_values, var_66_0)

	if not find then
		arg_66_1.current_selection = find

		local flag = true

		arg_66_1.callback(arg_66_1, arg_66_2, nil, flag)
	else
		printf("[OptionsView] Could not find the wanted value %q for setting %q. Ignored.", var_66_0, arg_66_3)
	end

	arg_66_1.overriden_setting = nil
	arg_66_1.overriden_reason = nil
	self.overriden_settings[arg_66_3] = nil
end

OptionsView._clear_setting_override = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	-- function 67
	arg_67_1.overriden_setting = nil
	arg_67_1.overriden_reason = nil
	arg_67_0.overriden_settings[arg_67_3] = nil
end

OptionsView._set_override_reason = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	-- function 68
	if not arg_68_1.overriden_reason then
		if not arg_68_3 then
			arg_68_1.overriden_reason = Localize(arg_68_1.text) .. "\n" .. Localize(arg_68_2)
		else
			arg_68_1.overriden_reason = Localize(arg_68_1.text) .. "\n" .. Localize("tooltip_overriden_by_setting") .. "\n" .. Localize(arg_68_2)
		end
	end
end

OptionsView.set_wwise_parameter = function (self, arg_69_1, arg_69_2)
	-- function 69
	WwiseWorld.set_global_parameter(self.wwise_world, arg_69_1, arg_69_2)
end

OptionsView.changes_been_made = function (self)
	-- function 70
	local changed_keymaps

	if not table.is_empty(self.changed_user_settings) and not table.is_empty(self.changed_render_settings) and not table.is_empty(self.changed_versus_settings) then
		changed_keymaps = self.changed_keymaps

		if not changed_keymaps then
			changed_keymaps = self.changed_bot_spawn_priority
		end

		if false then
			changed_keymaps = false
		end
	else
		changed_keymaps = true
	end

	return changed_keymaps
end

local tbl_21 = {}
local needs_reload_settings = var_0_1.needs_reload_settings
local needs_restart_settings = var_0_1.needs_restart_settings

OptionsView.apply_changes = function (self, arg_71_1, arg_71_2, arg_71_3, arg_71_4, arg_71_5)
	-- function 71
	local flag = false

	for k, v in pairs(arg_71_1) do
		Application.set_user_setting(k, v)

		if not table.contains(needs_reload_settings, k) then
			flag = true
		end
	end

	for k_2, v_2 in pairs(arg_71_2) do
		Application.set_user_setting("render_settings", k_2, v_2)

		if not table.contains(needs_restart_settings, k_2) then
			flag = true
		end
	end

	for k_3, v_3 in pairs(arg_71_3) do
		Application.set_user_setting("versus_settings", k_3, v_3)

		if not table.contains(needs_restart_settings, k_3) then
			flag = true
		end
	end

	Application.set_user_setting("overriden_settings", self.overriden_settings)

	local char_texture_quality = arg_71_1.char_texture_quality

	if not char_texture_quality then
		local var_71_2 = TextureQuality.characters[char_texture_quality]

		for i, v_4 in ipairs(var_71_2) do
			Application.set_user_setting("texture_settings", v_4.texture_setting, v_4.mip_level)
		end
	end

	local env_texture_quality = arg_71_1.env_texture_quality

	if not env_texture_quality then
		local var_71_4 = TextureQuality.environment[env_texture_quality]

		for i_2, v_5 in ipairs(var_71_4) do
			Application.set_user_setting("texture_settings", v_5.texture_setting, v_5.mip_level)
		end
	end

	if not self.in_title_screen then
		Framerate.set_playing()
	end

	local network = Managers.state.network

	if not network then
		network:set_small_network_packets(arg_71_1.small_network_packets)
	end

	local MatchmakingSettings = MatchmakingSettings
	local str

	if GameSettingsDevelopment.network_mode == "lan" then
		str = "close"
	else
		str = arg_71_1.max_quick_play_search_range

		if not str then
			str = Application.user_setting("max_quick_play_search_range")
			str = str or DefaultUserSettings.get("user_settings", "max_quick_play_search_range")
		end
	end

	MatchmakingSettings.max_distance_filter = str

	local max_stacking_frames = arg_71_1.max_stacking_frames

	if not max_stacking_frames then
		Application.set_max_frame_stacking(max_stacking_frames)
	end

	local hud_clamp_ui_scaling = arg_71_1.hud_clamp_ui_scaling

	if hud_clamp_ui_scaling ~= nil then
		UISettings.hud_clamp_ui_scaling = hud_clamp_ui_scaling
	end

	local use_custom_hud_scale = arg_71_1.use_custom_hud_scale

	if use_custom_hud_scale ~= nil then
		UISettings.use_custom_hud_scale = use_custom_hud_scale
	end

	local use_pc_menu_layout = arg_71_1.use_pc_menu_layout

	if use_pc_menu_layout ~= nil then
		UISettings.use_pc_menu_layout = use_pc_menu_layout
	end

	local use_gamepad_hud_layout = arg_71_1.use_gamepad_hud_layout

	if use_gamepad_hud_layout ~= nil then
		UISettings.use_gamepad_hud_layout = use_gamepad_hud_layout
	end

	local use_subtitles = arg_71_1.use_subtitles

	if use_subtitles ~= nil then
		UISettings.use_subtitles = use_subtitles
	end

	local subtitles_font_size = arg_71_1.subtitles_font_size

	if not subtitles_font_size then
		UISettings.subtitles_font_size = subtitles_font_size
	end

	local subtitles_background_opacity = arg_71_1.subtitles_background_opacity

	if not subtitles_background_opacity then
		UISettings.subtitles_background_alpha = 2.55 * subtitles_background_opacity
	end

	local master_bus_volume = arg_71_1.master_bus_volume

	if not master_bus_volume then
		self:set_wwise_parameter("master_bus_volume", master_bus_volume)
	end

	local music_bus_volume = arg_71_1.music_bus_volume

	if not music_bus_volume then
		Managers.music:set_music_volume(music_bus_volume)
	end

	local sfx_bus_volume = arg_71_1.sfx_bus_volume

	if not sfx_bus_volume then
		self:set_wwise_parameter("sfx_bus_volume", sfx_bus_volume)
	end

	local voice_bus_volume = arg_71_1.voice_bus_volume

	if not voice_bus_volume then
		self:set_wwise_parameter("voice_bus_volume", voice_bus_volume)
	end

	local voip_bus_volume = arg_71_1.voip_bus_volume

	if not voip_bus_volume then
		self.voip:set_volume(voip_bus_volume)
	end

	local voip_is_enabled = arg_71_1.voip_is_enabled

	if voip_is_enabled ~= nil then
		self.voip:set_enabled(voip_is_enabled)

		if not IS_XB1 and not Managers.voice_chat then
			Managers.voice_chat:set_enabled(voip_is_enabled)
		end
	end

	local voip_push_to_talk = arg_71_1.voip_push_to_talk

	if not voip_push_to_talk then
		self.voip:set_push_to_talk(voip_push_to_talk)
	end

	local dynamic_range_sound = arg_71_1.dynamic_range_sound

	if not dynamic_range_sound then
		local num = 1

		if dynamic_range_sound == "high" then
			num = 0
		end

		self:set_wwise_parameter("dynamic_range_sound", num)
	end

	local sound_channel_configuration = arg_71_1.sound_channel_configuration

	if not sound_channel_configuration then
		Wwise.set_bus_config("ingame_mastering_channel", sound_channel_configuration)
	end

	local sound_panning_rule = arg_71_1.sound_panning_rule

	if not sound_panning_rule then
		local flag_2

		flag_2 = sound_panning_rule ~= "headphones" or not "PANNING_RULE_HEADPHONES" or "PANNING_RULE_SPEAKERS"

		Managers.music:set_panning_rule(flag_2)
	end

	local sound_quality = arg_71_1.sound_quality

	if not sound_quality then
		SoundQualitySettings.set_sound_quality(self.wwise_world, sound_quality)
	end

	local fov = arg_71_2.fov

	if not fov then
		local num_2 = fov / CameraSettings.first_person._node.vertical_fov
		local camera = Managers.state.camera

		if not camera then
			camera:set_fov_multiplier(num_2)
		end
	end

	local get_service = self.input_manager:get_service("Player")
	local mouse_look_sensitivity = arg_71_1.mouse_look_sensitivity

	if not mouse_look_sensitivity then
		local str_2 = "win32"
		local multiplier = InputUtils.get_platform_filters(PlayerControllerFilters, str_2).look.multiplier

		get_service:get_active_filters(str_2).look.function_data.multiplier = multiplier * 0.85^-mouse_look_sensitivity
	end

	local mouse_look_invert_y = arg_71_1.mouse_look_invert_y

	if mouse_look_invert_y ~= nil then
		local str_3 = "win32"
		local function_data = get_service:get_active_filters(str_3).look.function_data
		local flag_3

		flag_3 = not mouse_look_invert_y and "scale_vector3" and "scale_vector3_invert_y"
		function_data.filter_type = flag_3
	end

	local gamepad_look_sensitivity = arg_71_1.gamepad_look_sensitivity

	if not gamepad_look_sensitivity then
		table.clear(tbl_21)

		local var_71_41 = tbl_21
		local num_3 = #tbl_21 + 1
		local flag_4

		flag_4 = not IS_WINDOWS and "xb1" and self.platform
		var_71_41[num_3] = flag_4

		local var_71_44 = tbl_21
		local num_4 = #tbl_21 + 1
		local IS_WINDOWS = IS_WINDOWS

		IS_WINDOWS = not IS_WINDOWS and "ps_pad"
		var_71_44[num_4] = IS_WINDOWS

		for i10 = 1, #tbl_21 do
			local var_71_47 = tbl_21[i10]
			local get_platform_filters = InputUtils.get_platform_filters(PlayerControllerFilters, var_71_47)
			local multiplier_x = get_platform_filters.look_controller.multiplier_x
			local multiplier_x_2 = get_platform_filters.look_controller_melee.multiplier_x
			local multiplier_x_3 = get_platform_filters.look_controller_ranged.multiplier_x
			local get_active_filters = get_service:get_active_filters(var_71_47)
			local function_data_2 = get_active_filters.look_controller.function_data

			function_data_2.multiplier_x = multiplier_x * 0.85^-gamepad_look_sensitivity

			local num_5

			if not get_platform_filters.look_controller.multiplier_min_x then
				num_5 = get_platform_filters.look_controller.multiplier_min_x * 0.85^-gamepad_look_sensitivity

				if not num_5 then
					-- Nothing
				end
			end

			num_5 = function_data_2.multiplier_x * 0.25

			::label_71_0::

			function_data_2.min_multiplier_x = num_5

			local function_data_3 = get_active_filters.look_controller_melee.function_data

			function_data_3.multiplier_x = multiplier_x_2 * 0.85^-gamepad_look_sensitivity

			local num_6

			if not get_platform_filters.look_controller_melee.multiplier_min_x then
				num_6 = get_platform_filters.look_controller_melee.multiplier_min_x * 0.85^-gamepad_look_sensitivity

				if not num_6 then
					-- Nothing
				end
			end

			num_6 = function_data_3.multiplier_x * 0.25

			::label_71_1::

			function_data_3.min_multiplier_x = num_6

			local function_data_4 = get_active_filters.look_controller_ranged.function_data

			function_data_4.multiplier_x = multiplier_x_3 * 0.85^-gamepad_look_sensitivity

			local num_7

			if not get_platform_filters.look_controller_ranged.multiplier_min_x then
				num_7 = get_platform_filters.look_controller_ranged.multiplier_min_x * 0.85^-gamepad_look_sensitivity

				if not num_7 then
					-- Nothing
				end
			end

			num_7 = function_data_4.multiplier_x * 0.25

			::label_71_2::

			function_data_4.min_multiplier_x = num_7
		end
	end

	local gamepad_look_sensitivity_y = arg_71_1.gamepad_look_sensitivity_y

	if not gamepad_look_sensitivity_y then
		table.clear(tbl_21)

		local var_71_60 = tbl_21
		local num_8 = #tbl_21 + 1
		local flag_5

		flag_5 = not IS_WINDOWS and "xb1" and self.platform
		var_71_60[num_8] = flag_5

		local var_71_63 = tbl_21
		local num_9 = #tbl_21 + 1
		local IS_WINDOWS_2 = IS_WINDOWS

		IS_WINDOWS_2 = not IS_WINDOWS_2 and "ps_pad"
		var_71_63[num_9] = IS_WINDOWS_2

		for i11 = 1, #tbl_21 do
			local var_71_66 = tbl_21[i11]
			local get_platform_filters_2 = InputUtils.get_platform_filters(PlayerControllerFilters, var_71_66)
			local multiplier_y = get_platform_filters_2.look_controller.multiplier_y
			local multiplier_y_2 = get_platform_filters_2.look_controller.multiplier_y
			local multiplier_y_3 = get_platform_filters_2.look_controller.multiplier_y
			local get_active_filters_2 = get_service:get_active_filters(var_71_66)

			get_active_filters_2.look_controller.function_data.multiplier_y = multiplier_y * 0.85^-gamepad_look_sensitivity_y
			get_active_filters_2.look_controller_melee.function_data.multiplier_y = multiplier_y_2 * 0.85^-gamepad_look_sensitivity_y
			get_active_filters_2.look_controller_ranged.function_data.multiplier_y = multiplier_y_3 * 0.85^-gamepad_look_sensitivity_y
		end
	end

	local gamepad_zoom_sensitivity = arg_71_1.gamepad_zoom_sensitivity

	if not gamepad_zoom_sensitivity then
		table.clear(tbl_21)

		local var_71_73 = tbl_21
		local num_10 = #tbl_21 + 1
		local flag_6

		flag_6 = not IS_WINDOWS and "xb1" and self.platform
		var_71_73[num_10] = flag_6

		local var_71_76 = tbl_21
		local num_11 = #tbl_21 + 1
		local IS_WINDOWS_3 = IS_WINDOWS

		IS_WINDOWS_3 = not IS_WINDOWS_3 and "ps_pad"
		var_71_76[num_11] = IS_WINDOWS_3

		for i12 = 1, #tbl_21 do
			local var_71_79 = tbl_21[i12]
			local get_platform_filters_3 = InputUtils.get_platform_filters(PlayerControllerFilters, var_71_79)
			local multiplier_x_4 = get_platform_filters_3.look_controller_zoom.multiplier_x
			local function_data_5 = get_service:get_active_filters(var_71_79).look_controller_zoom.function_data

			function_data_5.multiplier_x = multiplier_x_4 * 0.85^-gamepad_zoom_sensitivity

			local num_12

			if not get_platform_filters_3.look_controller_zoom.multiplier_min_x then
				num_12 = get_platform_filters_3.look_controller_zoom.multiplier_min_x * 0.85^-gamepad_zoom_sensitivity

				if not num_12 then
					-- Nothing
				end
			end

			num_12 = function_data_5.multiplier_x * 0.25

			::label_71_3::

			function_data_5.min_multiplier_x = num_12
		end
	end

	local gamepad_zoom_sensitivity_y = arg_71_1.gamepad_zoom_sensitivity_y

	if not gamepad_zoom_sensitivity_y then
		table.clear(tbl_21)

		local var_71_85 = tbl_21
		local num_13 = #tbl_21 + 1
		local flag_7

		flag_7 = not IS_WINDOWS and "xb1" and self.platform
		var_71_85[num_13] = flag_7

		local var_71_88 = tbl_21
		local num_14 = #tbl_21 + 1
		local IS_WINDOWS_4 = IS_WINDOWS

		IS_WINDOWS_4 = not IS_WINDOWS_4 and "ps_pad"
		var_71_88[num_14] = IS_WINDOWS_4

		for i13 = 1, #tbl_21 do
			local var_71_91 = tbl_21[i13]
			local multiplier_y_4 = InputUtils.get_platform_filters(PlayerControllerFilters, var_71_91).look_controller_zoom.multiplier_y

			get_service:get_active_filters(var_71_91).look_controller_zoom.function_data.multiplier_y = multiplier_y_4 * 0.85^-gamepad_zoom_sensitivity_y
		end
	end

	local gamepad_left_dead_zone = arg_71_1.gamepad_left_dead_zone

	if not gamepad_left_dead_zone then
		local active_controller = Managers.account:active_controller()
		local default_dead_zone = active_controller.default_dead_zone()
		local CIRCULAR = active_controller.CIRCULAR
		local axis_index = active_controller.axis_index("left")
		local dead_zone = default_dead_zone[axis_index].dead_zone
		local num_15 = dead_zone + gamepad_left_dead_zone * (0.9 - dead_zone)

		active_controller.set_dead_zone(axis_index, CIRCULAR, num_15)
	end

	local gamepad_right_dead_zone = arg_71_1.gamepad_right_dead_zone

	if not gamepad_right_dead_zone then
		local active_controller_2 = Managers.account:active_controller()
		local default_dead_zone_2 = active_controller_2.default_dead_zone()
		local CIRCULAR_2 = active_controller_2.CIRCULAR
		local axis_index_2 = active_controller_2.axis_index("right")
		local dead_zone_2 = default_dead_zone_2[axis_index_2].dead_zone
		local num_16 = dead_zone_2 + gamepad_right_dead_zone * (0.9 - dead_zone_2)

		active_controller_2.set_dead_zone(axis_index_2, CIRCULAR_2, num_16)
	end

	local gamepad_look_invert_y = arg_71_1.gamepad_look_invert_y

	if gamepad_look_invert_y ~= nil then
		table.clear(tbl_21)

		local var_71_108 = tbl_21
		local num_17 = #tbl_21 + 1
		local flag_8

		flag_8 = not IS_WINDOWS and "xb1" and self.platform
		var_71_108[num_17] = flag_8

		local var_71_111 = tbl_21
		local num_18 = #tbl_21 + 1
		local IS_WINDOWS_5 = IS_WINDOWS

		IS_WINDOWS_5 = not IS_WINDOWS_5 and "ps_pad"
		var_71_111[num_18] = IS_WINDOWS_5

		for i14 = 1, #tbl_21 do
			local var_71_114 = tbl_21[i14]
			local get_active_filters_3 = get_service:get_active_filters(var_71_114)
			local function_data_6 = get_active_filters_3.look_controller.function_data
			local flag_9

			flag_9 = not gamepad_look_invert_y and "scale_vector3_xy_accelerated_x_inverted" and "scale_vector3_xy_accelerated_x"
			function_data_6.filter_type = flag_9

			local function_data_7 = get_active_filters_3.look_controller_melee.function_data
			local flag_10

			flag_10 = not gamepad_look_invert_y and "scale_vector3_xy_accelerated_x_inverted" and "scale_vector3_xy_accelerated_x"
			function_data_7.filter_type = flag_10

			local function_data_8 = get_active_filters_3.look_controller_ranged.function_data
			local flag_11

			flag_11 = not gamepad_look_invert_y and "scale_vector3_xy_accelerated_x_inverted" and "scale_vector3_xy_accelerated_x"
			function_data_8.filter_type = flag_11

			local function_data_9 = get_active_filters_3.look_controller_zoom.function_data
			local flag_12

			flag_12 = not gamepad_look_invert_y and "scale_vector3_xy_accelerated_x_inverted" and "scale_vector3_xy_accelerated_x"
			function_data_9.filter_type = flag_12
		end
	end

	local gamepad_use_ps4_style_input_icons = arg_71_1.gamepad_use_ps4_style_input_icons

	if gamepad_use_ps4_style_input_icons ~= nil then
		UISettings.use_ps4_input_icons = gamepad_use_ps4_style_input_icons
	end

	local flag_13 = arg_71_1.gamepad_layout ~= nil
	local flag_14 = arg_71_1.gamepad_left_handed ~= nil

	if flag_13 or not flag_14 then
		local get = DefaultUserSettings.get("user_settings", "gamepad_layout")

		get = get or "default"

		local var_71_128 = fn_2(arg_71_1.gamepad_layout, Application.user_setting("gamepad_layout"))

		var_71_128 = var_71_128 or get

		if not var_71_128 then
			local var_71_129 = fn_2(arg_71_1.gamepad_left_handed, Application.user_setting("gamepad_left_handed"))
			local var_71_130

			if not var_71_129 then
				var_71_130 = AlternatateGamepadKeymapsLayoutsLeftHanded
			else
				var_71_130 = AlternatateGamepadKeymapsLayouts
			end

			local var_71_131 = var_71_130[var_71_128]

			self:apply_gamepad_changes(var_71_131, var_71_129)
		end
	end

	local use_motion_controls = arg_71_1.use_motion_controls

	if use_motion_controls ~= nil then
		MotionControlSettings.use_motion_controls = use_motion_controls
	end

	local motion_sensitivity_yaw = arg_71_1.motion_sensitivity_yaw

	if motion_sensitivity_yaw ~= nil then
		MotionControlSettings.motion_sensitivity_yaw = motion_sensitivity_yaw
	end

	local motion_sensitivity_pitch = arg_71_1.motion_sensitivity_pitch

	if motion_sensitivity_pitch ~= nil then
		MotionControlSettings.motion_sensitivity_pitch = motion_sensitivity_pitch
	end

	local motion_disable_right_stick_vertical = arg_71_1.motion_disable_right_stick_vertical

	if motion_disable_right_stick_vertical ~= nil then
		MotionControlSettings.motion_disable_right_stick_vertical = motion_disable_right_stick_vertical
	end

	local motion_enable_yaw_motion = arg_71_1.motion_enable_yaw_motion

	if motion_enable_yaw_motion ~= nil then
		MotionControlSettings.motion_enable_yaw_motion = motion_enable_yaw_motion
	end

	local motion_enable_pitch_motion = arg_71_1.motion_enable_pitch_motion

	if motion_enable_pitch_motion ~= nil then
		MotionControlSettings.motion_enable_pitch_motion = motion_enable_pitch_motion
	end

	local motion_invert_yaw = arg_71_1.motion_invert_yaw

	if motion_invert_yaw ~= nil then
		MotionControlSettings.motion_invert_yaw = motion_invert_yaw
	end

	local motion_invert_pitch = arg_71_1.motion_invert_pitch

	if motion_invert_pitch ~= nil then
		MotionControlSettings.motion_invert_pitch = motion_invert_pitch
	end

	local animation_lod_distance_multiplier = arg_71_1.animation_lod_distance_multiplier

	if not animation_lod_distance_multiplier then
		GameSettingsDevelopment.bone_lod_husks.lod_multiplier = animation_lod_distance_multiplier
	end

	if not arg_71_1.player_outlines then
		local players = Managers.player:players()

		for k_4, v_6 in pairs(players) do
			local player_unit = v_6.player_unit

			if v_6.local_player or not Unit.alive(player_unit) then
				local extension = ScriptUnit.extension(player_unit, "outline_system")

				if not extension.update_override_method_player_setting then
					extension.update_override_method_player_setting()
				end
			end
		end
	end

	if not (not arg_71_1.minion_outlines and self.in_title_screen) then
		local local_player = Managers.player:local_player()
		local flag_15 = not local_player and local_player.player_unit

		if not flag_15 then
			local extension_2 = ScriptUnit.extension(flag_15, "ai_commander_system")

			for k_5 in pairs(extension_2:get_controlled_units()) do
				local extension_3 = ScriptUnit.extension(k_5, "outline_system")

				if not extension_3.update_override_method_minion_setting then
					extension_3:update_override_method_minion_setting()
				end
			end
		end
	end

	local overcharge_opacity = arg_71_1.overcharge_opacity
	local player = Managers.player
	local network_2 = Managers.state.network

	network_2 = not network_2 and Managers.state.network:game()

	if not overcharge_opacity and not player and not network_2 then
		local player_unit_2 = player:local_player().player_unit

		ScriptUnit.extension(player_unit_2, "overcharge_system"):set_screen_particle_opacity_modifier(overcharge_opacity)
	end

	local chat_enabled = arg_71_1.chat_enabled
	local chat = Managers.chat

	if chat_enabled == nil or not chat then
		chat:set_chat_enabled(chat_enabled)
	end

	local chat_font_size = arg_71_1.chat_font_size
	local chat_2 = Managers.chat

	if not chat_font_size and not chat_2 then
		chat_2:set_font_size(chat_font_size)
	end

	local language_id = arg_71_1.language_id

	if not language_id then
		self:reload_language(language_id)
	end

	local hud_scale = arg_71_1.hud_scale

	if hud_scale ~= nil then
		UISettings.hud_scale = hud_scale

		local flag_16 = true

		UPDATE_RESOLUTION_LOOKUP(flag_16)
		self:_setup_text_buttons_width()
		self:setup_scrollbar(self.selected_settings_list, self.scroll_value)
	end

	if not rawget(_G, "Tobii") then
		local tobii_extended_view_sensitivity = arg_71_1.tobii_extended_view_sensitivity

		if tobii_extended_view_sensitivity ~= nil then
			Tobii.set_extended_view_responsiveness(tobii_extended_view_sensitivity / 100)
		end

		local tobii_extended_view_use_head_tracking = arg_71_1.tobii_extended_view_use_head_tracking

		if tobii_extended_view_use_head_tracking ~= nil then
			Tobii.set_extended_view_use_head_tracking(tobii_extended_view_use_head_tracking)
		end
	end

	local twitch_vote_time = arg_71_1.twitch_vote_time

	if not twitch_vote_time then
		TwitchSettings.default_vote_time = twitch_vote_time
	end

	local twitch_time_between_votes = arg_71_1.twitch_time_between_votes

	if not twitch_time_between_votes then
		TwitchSettings.default_downtime = twitch_time_between_votes
	end

	local twitch_difficulty = arg_71_1.twitch_difficulty

	if not twitch_difficulty then
		TwitchSettings.difficulty = twitch_difficulty
	end

	local twitch_disable_positive_votes = arg_71_1.twitch_disable_positive_votes

	if not twitch_disable_positive_votes then
		TwitchSettings.disable_giving_items = twitch_disable_positive_votes == TwitchSettings.positive_vote_options.disable_giving_items or twitch_disable_positive_votes == TwitchSettings.positive_vote_options.disable_positive_votes
		TwitchSettings.disable_positive_votes = twitch_disable_positive_votes == TwitchSettings.positive_vote_options.disable_positive_votes
	end

	local twitch_disable_mutators = arg_71_1.twitch_disable_mutators

	if twitch_disable_mutators ~= nil then
		TwitchSettings.disable_mutators = twitch_disable_mutators
	end

	local twitch_spawn_amount = arg_71_1.twitch_spawn_amount

	if not twitch_spawn_amount then
		TwitchSettings.spawn_amount_multiplier = twitch_spawn_amount
	end

	local twitch_mutator_duration = arg_71_1.twitch_mutator_duration

	if not twitch_mutator_duration then
		TwitchSettings.mutator_duration_multiplier = twitch_mutator_duration
	end

	if not arg_71_1.use_razer_chroma then
		Managers.razer_chroma:load_packages()
	else
		Managers.razer_chroma:unload_packages()
	end

	local blood_enabled = arg_71_1.blood_enabled

	if blood_enabled == nil or not Managers.state.blood then
		Managers.state.blood:update_blood_enabled(blood_enabled)
	end

	local num_blood_decals = arg_71_1.num_blood_decals

	if num_blood_decals == nil or not Managers.state.blood then
		Managers.state.blood:update_num_blood_decals(num_blood_decals)
	end

	local screen_blood_enabled = arg_71_1.screen_blood_enabled

	if screen_blood_enabled == nil or not Managers.state.blood then
		Managers.state.blood:update_screen_blood_enabled(screen_blood_enabled)
	end

	local dismemberment_enabled = arg_71_1.dismemberment_enabled

	if dismemberment_enabled == nil or not Managers.state.blood then
		Managers.state.blood:update_dismemberment_enabled(dismemberment_enabled)
	end

	local ragdoll_enabled = arg_71_1.ragdoll_enabled

	if ragdoll_enabled == nil or not Managers.state.blood then
		Managers.state.blood:update_ragdoll_enabled(ragdoll_enabled)
	end

	self:apply_bot_spawn_priority_changes(arg_71_4, arg_71_5)

	if not IS_WINDOWS then
		Managers.save:auto_save(SaveFileName, SaveData)
		Application.save_user_settings()
	else
		Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_save_done"))
	end

	if not flag then
		Application.apply_user_settings()
		GlobalShaderFlags.apply_settings()
		Renderer.bake_static_shadows()

		local current_level_settings = LevelHelper:current_level_settings()
		local flag_17 = not current_level_settings and current_level_settings.render_settings_overrides

		if not flag_17 then
			for k_6, v_7 in pairs(flag_17) do
				Application.set_render_setting(k_6, tostring(v_7))
			end
		end
	end

	ShowCursorStack.update_clip_cursor()
	WwiseWorld.trigger_event(self.wwise_world, "Play_hud_button_close")

	if not Managers.state.event then
		print("[OptionsView] Triggering `on_game_options_changed`")
		Managers.state.event:trigger("on_game_options_changed")
	end
end

OptionsView.apply_bot_spawn_priority_changes = function (self, arg_72_1, arg_72_2)
	-- function 72
	local bot_spawn_priority = PlayerData.bot_spawn_priority

	for i = 1, #arg_72_1 do
		bot_spawn_priority[i] = arg_72_1[i]
	end

	if not arg_72_2 then
		local var_72_1 = Localize("will_be_applied_on_next_map_popup_text")

		self.apply_bot_spawn_priority_popup_id = Managers.popup:queue_popup(var_72_1, Localize("popup_will_be_applied_on_next_map_popup"), "continue", Localize("popup_choice_continue"))
	end
end

OptionsView.apply_keymap_changes = function (self, arg_73_1, arg_73_2)
	-- function 73
	if not PlayerData.controls then
		PlayerData.controls = {}
	end

	local flag = not arg_73_2 and PlayerData.controls

	for k, v in pairs(arg_73_1) do
		for k_2, v_2 in pairs(v) do
			for k_3, v_3 in pairs(v_2) do
				if not arg_73_2 then
					if not flag[k] then
						flag[k] = {}
					end

					local var_73_1 = flag[k]

					if not var_73_1[k_2] then
						var_73_1[k_2] = {}
					end

					local var_73_2 = var_73_1[k_2]

					if not v_3.changed then
						var_73_2[k_3] = table.clone(v_3)
					else
						var_73_2[k_3] = nil
					end
				end

				self:_apply_keybinding_changes(k, k_2, k_3, v_3)
			end
		end
	end

	if not arg_73_2 then
		if not IS_WINDOWS then
			Managers.save:auto_save(SaveFileName, SaveData)
		else
			Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_save_done"))
		end

		Managers.razer_chroma:lit_keybindings(true)
	end

	if not Managers.state.event then
		Managers.state.event:trigger("input_changed")
	end
end

local tbl_22 = {}

OptionsView._apply_keybinding_changes = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
	-- function 74
	table.clear(tbl_22)

	local num = 0

	for i = 1, #arg_74_4, 3 do
		local var_74_1 = arg_74_4[i]
		local var_74_2 = arg_74_4[i + 1]
		local var_74_3 = arg_74_4[i + 2]
		local var_74_4
		local flag = var_74_1 == "gamepad"
		local Pad1 = Pad1

		if not (not IS_WINDOWS and arg_74_2 ~= "ps_pad") then
			flag = true
			Pad1 = InputAux.input_device_mapping.ps_pad[1] or Pad1
		end

		if not flag then
			if var_74_3 == "axis" then
				var_74_4 = Pad1.axis_index(var_74_2)
			else
				var_74_4 = Pad1.button_index(var_74_2)
			end
		elseif var_74_1 == "keyboard" then
			var_74_4 = Keyboard.button_index(var_74_2)
		elseif var_74_1 == "mouse" then
			if var_74_3 == "axis" then
				var_74_4 = Mouse.axis_index(var_74_2)
			else
				var_74_4 = Mouse.button_index(var_74_2)
			end
		else
			assert(var_74_1, "[OptionsView] - Trying to keybind unrecognized device for action %s in keybinds %s, %s", arg_74_3, arg_74_1, arg_74_2)
		end

		if not var_74_4 then
			tbl_22[num + 1] = var_74_4
			tbl_22[num + 2] = var_74_1
			num = num + 2
		end
	end

	local input = Managers.input

	if num > 0 then
		input:change_keybinding(arg_74_1, arg_74_2, arg_74_3, unpack(tbl_22))
	else
		input:clear_keybinding(arg_74_1, arg_74_2, arg_74_3)
	end
end

OptionsView.cb_save_done = function (self, arg_75_1)
	-- function 75
	Managers.transition:hide_loading_icon()

	self.disable_all_input = false
end

OptionsView.apply_gamepad_changes = function (self, arg_76_1, arg_76_2)
	-- function 76
	local flag = false

	self:apply_keymap_changes(arg_76_1, flag)
	self:update_gamepad_layout_widget(arg_76_1, arg_76_2)
end

OptionsView.has_popup = function (self)
	-- function 77
	local exit_popup_id = self.exit_popup_id

	if not exit_popup_id then
		exit_popup_id = self.title_popup_id

		if not exit_popup_id then
			exit_popup_id = self.apply_popup_id

			if not exit_popup_id then
				exit_popup_id = self.apply_bot_spawn_priority_popup_id
				exit_popup_id = exit_popup_id or self.reset_popup_id
			end
		end
	end

	return exit_popup_id
end

OPTIONS_VIEW_PRINT_ORIGINAL_VALUES = false

local var_0_47 = rawget(_G, "Tobii")

OptionsView.update = function (self, arg_78_1)
	-- function 78
	if not self.suspended then
		return
	end

	if not RESOLUTION_LOOKUP.modified then
		self:_setup_text_buttons_width()
	end

	local disable_all_input = self.disable_all_input
	local RELOAD_OPTIONS_VIEW = RELOAD_OPTIONS_VIEW

	if not var_0_47 then
		local get_is_connected = Tobii.get_is_connected()

		if self._tobii_is_connected ~= get_is_connected then
			self._tobii_is_connected = get_is_connected
			RELOAD_OPTIONS_VIEW = true
		end
	end

	if not RELOAD_OPTIONS_VIEW then
		local selected_title = self.selected_title

		self:create_ui_elements()
		self:_setup_input_functions()

		if not selected_title then
			self:select_settings_title(selected_title)
		end
	end

	local transitioning = self:transitioning()

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_78_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end

	if not self.active then
		return
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("options_menu")
	local is_device_active = input_manager:is_device_active("gamepad")
	local is_device_active_2 = input_manager:is_device_active("mouse")
	local selected_widget = self.selected_widget

	self:update_apply_button()

	if not (is_device_active_2 or self:has_popup() or transitioning or disable_all_input) then
		self:handle_controller_navigation_input(arg_78_1, get_service)
	end

	if not transitioning then
		self:update_mouse_scroll_input(disable_all_input)

		local flag = not is_device_active and not not self.draw_gamepad_tooltip or not disable_all_input

		self:handle_apply_button(get_service, flag)

		if not self.selected_settings_list then
			self:handle_reset_to_default_button(get_service, flag)
		end
	end

	self:draw_widgets(arg_78_1, disable_all_input)
	self:_handle_ps_pads(is_device_active)
	self:_update_animations(arg_78_1)

	if not self.save_data_error_popup_id then
		local query_result = Managers.popup:query_result(self.save_data_error_popup_id)

		if not query_result then
			if query_result == "delete" then
				Managers.save:delete_save(SaveFileName, callback(self, "cb_delete_save"))

				self.disable_all_input = true
			end

			Managers.popup:cancel_popup(self.save_data_error_popup_id)

			self.save_data_error_popup_id = nil
		end
	end

	if not self.title_popup_id then
		local query_result_2 = Managers.popup:query_result(self.title_popup_id)

		if not query_result_2 then
			Managers.popup:cancel_popup(self.title_popup_id)

			self.title_popup_id = nil

			self:handle_title_buttons_popup_results(query_result_2)
		end
	end

	if not self.apply_popup_id then
		local query_result_3 = Managers.popup:query_result(self.apply_popup_id)

		if not query_result_3 then
			Managers.popup:cancel_popup(self.apply_popup_id)

			self.apply_popup_id = nil

			self:handle_apply_popup_results(query_result_3)
		end
	end

	if not self.reset_popup_id then
		local query_result_4 = Managers.popup:query_result(self.reset_popup_id)

		if not query_result_4 then
			Managers.popup:cancel_popup(self.reset_popup_id)

			self.reset_popup_id = nil

			self:handle_apply_popup_results(query_result_4)
		end
	end

	if not self.apply_bot_spawn_priority_popup_id then
		local query_result_5 = Managers.popup:query_result(self.apply_bot_spawn_priority_popup_id)

		if not query_result_5 then
			Managers.popup:cancel_popup(self.apply_bot_spawn_priority_popup_id)

			self.apply_bot_spawn_priority_popup_id = nil

			self:handle_apply_popup_results(query_result_5)
		end
	end

	if not self.exit_popup_id then
		local query_result_6 = Managers.popup:query_result(self.exit_popup_id)

		if not query_result_6 then
			Managers.popup:cancel_popup(self.exit_popup_id)

			self.exit_popup_id = nil

			self:handle_exit_button_popup_results(query_result_6)
		end
	end

	if not OPTIONS_VIEW_PRINT_ORIGINAL_VALUES then
		print("------------------------")
		print("ORIGINAL USER SETTINGS")

		local original_user_settings = self.original_user_settings

		for k_2, v_2 in pairs(original_user_settings) do
			printf("  - %s  %s", k_2, tostring(v_2))
		end

		print("ORIGINAL RENDER SETTINGS")

		local original_render_settings = self.original_render_settings

		for k_3, v_3 in pairs(original_render_settings) do
			printf("  - %s  %s", k_3, tostring(v_3))
		end

		print("/-----------------------")

		OPTIONS_VIEW_PRINT_ORIGINAL_VALUES = false
	end

	if not transitioning then
		local button_hotspot = self.exit_button.content.button_hotspot

		if not button_hotspot.on_hover_enter then
			WwiseWorld.trigger_event(self.wwise_world, "Play_hud_hover")
		end

		local button_hotspot_2 = self.back_button.content.button_hotspot

		if not button_hotspot_2.on_hover_enter then
			WwiseWorld.trigger_event(self.wwise_world, "Play_hud_hover")
		end

		if not (disable_all_input or self:has_popup() or self.draw_gamepad_tooltip) then
			if (selected_widget or not get_service:get("toggle_menu", true)) and not button_hotspot.is_hover and button_hotspot.on_release and not button_hotspot_2.is_hover or not button_hotspot_2.on_release then
				WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")
				self:on_exit_pressed()
			end

			UIWidgetUtils.animate_layout_button(self.back_button, arg_78_1)
		end
	end
end

OptionsView._update_animations = function (self, arg_79_1)
	-- function 79
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_79_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_animations[k] = nil
		end
	end
end

OptionsView._handle_ps_pads = function (self, arg_80_1)
	-- function 80
	if not (not IS_WINDOWS and arg_80_1) then
		return
	end

	local gamepad_layout_widget = self.gamepad_layout_widget

	if not gamepad_layout_widget then
		return
	end

	local get_most_recent_device = Managers.input:get_most_recent_device()
	local var_80_2 = fn_2(self.changed_user_settings.gamepad_use_ps4_style_input_icons, Application.user_setting("gamepad_use_ps4_style_input_icons"))

	gamepad_layout_widget.content.use_texture2_layout = get_most_recent_device.type() == "sce_pad" or var_80_2
end

OptionsView.cb_delete_save = function (self, arg_81_1)
	-- function 81
	if not arg_81_1.error then
		Application.warning(string.format("[StateTitleScreenLoadSave] Error when overriding save data %q", arg_81_1.error))
	end

	self.disable_all_input = false
end

OptionsView.on_gamepad_activated = function (self)
	-- function 82
	local title_buttons = self.title_buttons
	local title_buttons_n = self.title_buttons_n

	for i = 1, title_buttons_n do
		title_buttons[i].content.disable_side_textures = true
	end
end

OptionsView.on_gamepad_deactivated = function (self)
	-- function 83
	local title_buttons = self.title_buttons
	local title_buttons_n = self.title_buttons_n

	for i = 1, title_buttons_n do
		title_buttons[i].content.disable_side_textures = false
	end
end

OptionsView.on_exit_pressed = function (self)
	-- function 84
	if not self:changes_been_made() then
		local var_84_0 = Localize("unapplied_changes_popup_text")

		self.exit_popup_id = Managers.popup:queue_popup(var_84_0, Localize("popup_discard_changes_topic"), "revert_changes", Localize("popup_choice_discard"), "cancel", Localize("popup_choice_cancel"))
	else
		self:exit()
	end
end

local needs_restart_settings_2 = var_0_1.needs_restart_settings

OptionsView.handle_apply_popup_results = function (self, arg_85_1)
	-- function 85
	if arg_85_1 == "keep_changes" then
		local flag = false

		for k, v in pairs(self.changed_user_settings) do
			if not table.contains(needs_restart_settings_2, k) then
				flag = true

				break
			end
		end

		for k_2, v_2 in pairs(self.changed_render_settings) do
			if not table.contains(needs_restart_settings_2, k_2) then
				flag = true

				break
			end
		end

		if not (not flag and self.in_title_screen) then
			local var_85_1 = Localize("changes_need_restart_popup_text")

			self.apply_popup_id = Managers.popup:queue_popup(var_85_1, Localize("popup_needs_restart_topic"), "continue", Localize("popup_choice_continue"), "restart", Localize("popup_choice_restart_now"))
		elseif not self.delayed_title_change then
			self:select_settings_title(self.delayed_title_change)

			self.delayed_title_change = nil
		end

		self:set_original_settings()
		self:reset_changed_settings()
	elseif arg_85_1 == "reset_values" then
		self:reset_current_settings_list_to_default()
		self:handle_apply_changes()
	elseif arg_85_1 == "revert_changes" then
		if not self.changed_keymaps then
			self:apply_keymap_changes(self.original_keymaps, true)
		else
			self:apply_changes(self.original_user_settings, self.original_render_settings, self.original_versus_settings, self.original_bot_spawn_priority, false)
		end

		if not self.delayed_title_change then
			self:select_settings_title(self.delayed_title_change)

			self.delayed_title_change = nil
		else
			self:set_original_settings()
			self:reset_changed_settings()
			self:set_widget_values(self.selected_settings_list)
		end
	elseif arg_85_1 == "restart" then
		self:restart()
	elseif arg_85_1 == "continue" then
		if not self.delayed_title_change then
			self:select_settings_title(self.delayed_title_change)

			self.delayed_title_change = nil
		end
	else
		print(arg_85_1)
	end
end

OptionsView.restart = function (self)
	-- function 86
	self:exit()
	self.ingame_ui:handle_transition("leave_game")
end

OptionsView.handle_title_buttons_popup_results = function (self, arg_87_1)
	-- function 87
	if arg_87_1 == "revert_changes" then
		if not self.changed_keymaps then
			self:apply_keymap_changes(self.original_keymaps, true)
		else
			self:apply_changes(self.original_user_settings, self.original_render_settings, self.original_versus_settings, self.original_bot_spawn_priority, false)
		end

		self:reset_changed_settings()

		if not self.delayed_title_change then
			self:select_settings_title(self.delayed_title_change)

			self.delayed_title_change = nil
		else
			self:set_original_settings()
			self:set_widget_values(self.selected_settings_list)
		end
	elseif arg_87_1 == "apply_changes" then
		self:handle_apply_changes()
	else
		print(arg_87_1)
	end
end

OptionsView.handle_exit_button_popup_results = function (self, arg_88_1)
	-- function 88
	if arg_88_1 == "revert_changes" then
		if not self.changed_keymaps then
			self:apply_keymap_changes(self.original_keymaps, true)
		else
			self:apply_changes(self.original_user_settings, self.original_render_settings, self.original_versus_settings, self.original_bot_spawn_priority, false)
		end

		self:set_original_settings()
		self:reset_changed_settings()
		self:exit()
	elseif arg_88_1 == "cancel" then
		-- Nothing
	else
		print(arg_88_1)
	end
end

OptionsView.update_apply_button = function (self)
	-- function 89
	local apply_button = self.apply_button

	if not self:changes_been_made() then
		apply_button.content.button_text.disabled = false
		apply_button.content.button_text.disable_button = false
		apply_button.style.text.text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
	else
		apply_button.content.button_text.disabled = true
		apply_button.content.button_text.disable_button = true
	end
end

OptionsView.handle_apply_changes = function (self)
	-- function 90
	if not self.changed_keymaps then
		self:apply_keymap_changes(self.session_keymaps, true)
	else
		self:apply_changes(self.changed_user_settings, self.changed_render_settings, self.changed_versus_settings, self.session_bot_spawn_priority, self.changed_bot_spawn_priority)
	end

	if not IS_WINDOWS and not self.selected_settings_list.needs_apply_confirmation then
		local var_90_0 = Localize("keep_changes_popup_text")

		self.apply_popup_id = Managers.popup:queue_popup(var_90_0, Localize("popup_keep_changes_topic"), "keep_changes", Localize("popup_choice_keep"), "revert_changes", Localize("popup_choice_revert"))

		Managers.popup:activate_timer(self.apply_popup_id, 15, "revert_changes", "center")
	else
		self:handle_apply_popup_results("keep_changes")

		if not self.delayed_title_change then
			self:select_settings_title(self.delayed_title_change)

			self.delayed_title_change = nil
		end
	end
end

OptionsView.handle_apply_button = function (self, arg_91_1, arg_91_2)
	-- function 91
	if not self.apply_button.content.button_text.disabled then
		return
	end

	local button_text = self.apply_button.content.button_text

	if not button_text.on_hover_enter then
		WwiseWorld.trigger_event(self.wwise_world, "Play_hud_hover")
	end

	if not button_text.is_hover and button_text.on_release and not arg_91_2 or not arg_91_1:get("refresh") then
		WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")

		if not self.apply_popup_id then
			local is_device_active = self.input_manager:is_device_active("gamepad")
			local changes_been_made = self:changes_been_made()
			local n_popups = Managers.popup._handler.n_popups

			table.dump(Managers.popup._handler.popups, "popups", 2)

			local tbl = {}

			self.input_manager:get_blocked_services(nil, nil, tbl)
			table.dump(tbl, "blocked_input_services", 2)
			Crashify.print_exception("OptionsView", "Apply button wasn't disabled, even though we had an apply popup...")
		else
			self:handle_apply_changes()
		end
	end
end

OptionsView.reset_to_default_drop_down = function (arg_92_0, arg_92_1)
	-- function 92
	local content = arg_92_1.content
	local default_value = content.default_value

	content.current_selection = default_value
	content.selected_option = content.options_texts[default_value]

	content.callback(content, default_value)
end

OptionsView.reset_to_default_slider = function (arg_93_0, arg_93_1)
	-- function 93
	local content = arg_93_1.content
	local style = arg_93_1.style
	local default_value = content.default_value

	content.value = default_value
	content.internal_value = fn(content.min, content.max, default_value)

	content.callback(content, style)
end

OptionsView.reset_to_default_checkbox = function (arg_94_0, arg_94_1)
	-- function 94
	local content = arg_94_1.content

	content.flag = content.default_value

	content.callback(content)
end

OptionsView.reset_to_default_stepper = function (arg_95_0, arg_95_1)
	-- function 95
	local content = arg_95_1.content
	local style = arg_95_1.style

	content.current_selection = content.default_value

	content.callback(content, style)
end

OptionsView.reset_to_default_option = function (arg_96_0, arg_96_1)
	-- function 96
	local content = arg_96_1.content

	content.current_selection = content.default_value

	content.callback(content)
end

OptionsView.reset_to_default_keybind = function (arg_97_0, arg_97_1)
	-- function 97
	local content = arg_97_1.content
	local default_value = content.default_value

	content.callback(UNASSIGNED_KEY, default_value.controller, content, 2)
	content.callback(default_value.key, default_value.controller, content, 1)
end

OptionsView.reset_to_default_sorted_list = function (arg_98_0, arg_98_1)
	-- function 98
	local content = arg_98_1.content
	local style = arg_98_1.style
	local default_value = content.default_value
	local current_selection = content.current_selection

	if not current_selection then
		content.list_content[current_selection].hotspot.is_selected = false
		content.current_selection = nil
		content.up_hotspot.active = false
		content.down_hotspot.active = false
	end

	content.callback(content, style, default_value)
end

OptionsView.reset_current_settings_list_to_default = function (self)
	-- function 99
	local selected_settings_list = self.selected_settings_list
	local widgets = selected_settings_list.widgets
	local widgets_n = selected_settings_list.widgets_n

	for i = 1, widgets_n do
		local var_99_3 = widgets[i]

		if not var_99_3.content.default_value then
			local type = var_99_3.type

			if type == "drop_down" then
				self:reset_to_default_drop_down(var_99_3)
			elseif type == "slider" then
				self:reset_to_default_slider(var_99_3)
			elseif type == "checkbox" then
				self:reset_to_default_checkbox(var_99_3)
			elseif type == "stepper" then
				self:reset_to_default_stepper(var_99_3)
			elseif type == "option" then
				self:reset_to_default_option(var_99_3)
			elseif type == "keybind" then
				self:reset_to_default_keybind(var_99_3)
			elseif type == "sorted_list" then
				self:reset_to_default_sorted_list(var_99_3)
			else
				error("Not supported widget type..")
			end
		end
	end

	if SettingsMenuNavigation[self.selected_title] == "keybind_settings" then
		self.keybind_info_text = Localize("options_menu_gamepad_reset_text")
	end
end

OptionsView.handle_reset_to_default_button = function (self, arg_100_1, arg_100_2)
	-- function 100
	local content = self.reset_to_default.content

	if content.button_text.disabled or not content.hidden then
		return
	end

	local button_text = self.reset_to_default.content.button_text

	if not button_text.on_hover_enter then
		WwiseWorld.trigger_event(self.wwise_world, "Play_hud_hover")
	end

	if button_text.on_release or not arg_100_2 or not arg_100_1:get("special_1") then
		WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")

		local var_100_2 = Localize("reset_settings_popup_text")

		self.reset_popup_id = Managers.popup:queue_popup(var_100_2, Localize("popup_discard_changes_topic"), "reset_values", Localize("button_ok"), "revert_changes", Localize("popup_choice_cancel"))
	end
end

OptionsView.draw_widgets = function (self, arg_101_1, arg_101_2)
	-- function 101
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer

	ui_top_renderer = ui_top_renderer or self.ui_renderer

	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("options_menu")
	local is_device_active = input_manager:is_device_active("gamepad")
	local draw_gamepad_tooltip = self.draw_gamepad_tooltip
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, get_service, arg_101_1, nil, self.render_settings)

	local background_widgets = self.background_widgets
	local background_widgets_n = self.background_widgets_n

	for i = 1, background_widgets_n do
		UIRenderer.draw_widget(ui_top_renderer, background_widgets[i])
	end

	if not (not self.selected_settings_list and draw_gamepad_tooltip) then
		self:update_settings_list(self.selected_settings_list, ui_top_renderer, ui_scenegraph, get_service, arg_101_1, arg_101_2)
	end

	self:handle_title_buttons(ui_top_renderer, arg_101_2)

	self.reset_to_default.content.button_text.disable_button = arg_101_2
	self.exit_button.content.button_hotspot.disable_button = arg_101_2
	self.back_button.content.button_hotspot.disable_button = arg_101_2

	if not is_device_active then
		local keybind_info_text = self.keybind_info_text

		if not keybind_info_text then
			local keybind_info_widget = self.keybind_info_widget

			keybind_info_widget.content.text = keybind_info_text

			UIRenderer.draw_widget(ui_top_renderer, keybind_info_widget)
		end

		if not self.reset_to_default.content.hidden then
			UIRenderer.draw_widget(ui_top_renderer, self.reset_to_default)
		end

		UIRenderer.draw_widget(ui_top_renderer, self.apply_button)
		UIRenderer.draw_widget(ui_top_renderer, self.exit_button)

		if not self.in_title_screen then
			UIRenderer.draw_widget(ui_top_renderer, self.back_button)
		end
	elseif not draw_gamepad_tooltip then
		UIRenderer.draw_widget(ui_top_renderer, self.gamepad_tooltip_text_widget)
	end

	if not self.safe_rect_widget then
		local alpha_multiplier = render_settings.alpha_multiplier

		render_settings.alpha_multiplier = math.ease_out_exp(self.safe_rect_alpha_timer / num)

		UIRenderer.draw_widget(ui_top_renderer, self.safe_rect_widget)

		render_settings.alpha_multiplier = alpha_multiplier
		self.safe_rect_alpha_timer = math.max(self.safe_rect_alpha_timer - arg_101_1, 0)
	end

	UIRenderer.end_pass(ui_top_renderer)

	if SettingsMenuNavigation[self.selected_title] == "calibrate_ui" then
		self.ui_calibration_view:update(self.ui_top_renderer, get_service, arg_101_1)
	end

	if not (not is_device_active and self:has_popup() or self.disable_all_input) then
		self.menu_input_description:draw(ui_top_renderer, arg_101_1)
	end
end

local tbl_23 = {
	0,
	0
}

OptionsView.update_settings_list = function (self, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6)
	-- function 102
	if not arg_102_1.scrollbar then
		local content = self.scrollbar.content

		content.button_up_hotspot.disable_button = arg_102_6
		content.button_down_hotspot.disable_button = arg_102_6
		content.scroll_bar_info.disable_button = arg_102_6

		UIRenderer.draw_widget(arg_102_2, self.scrollbar)
		self:update_scrollbar(arg_102_1, arg_102_3)
	end

	local scenegraph_id_start = arg_102_1.scenegraph_id_start
	local get_world_position = UISceneGraph.get_world_position(arg_102_3, scenegraph_id_start)
	local get_world_position_2 = UISceneGraph.get_world_position(arg_102_3, "list_mask")
	local get_size = UISceneGraph.get_size(arg_102_3, "list_mask")
	local selected_widget = self.selected_widget
	local is_device_active = Managers.input:is_device_active("gamepad")
	local widgets = arg_102_1.widgets
	local widgets_n = arg_102_1.widgets_n
	local num = 0
	local flag = false

	for i = 1, widgets_n do
		local var_102_11 = widgets[i]
		local style = var_102_11.style
		local name = var_102_11.name
		local size = style.size
		local offset = style.offset

		tbl_23[1] = get_world_position[1] + offset[1]
		tbl_23[2] = get_world_position[2] + offset[2]

		local point_is_inside_2d_box = math.point_is_inside_2d_box(tbl_23, get_world_position_2, get_size)

		tbl_23[2] = tbl_23[2] + size[2] / 2

		local point_is_inside_2d_box_2 = math.point_is_inside_2d_box(tbl_23, get_world_position_2, get_size)

		tbl_23[2] = tbl_23[2] + size[2] / 2

		local point_is_inside_2d_box_3 = math.point_is_inside_2d_box(tbl_23, get_world_position_2, get_size)
		local flag_2 = point_is_inside_2d_box or point_is_inside_2d_box_3

		var_102_11.content.visible = flag_2

		if not flag_2 then
			num = num + 1
		end

		local flag_3 = true

		if not is_device_active then
			flag_3 = false
		elseif not var_102_11.content.is_highlighted then
			flag_3 = false
		end

		if not var_102_11.content.disabled then
			flag_3 = true
		end

		if not point_is_inside_2d_box_2 then
			flag_3 = true
		end

		local content_2 = var_102_11.content
		local hotspot_content_ids = content_2.hotspot_content_ids

		if not hotspot_content_ids then
			for j = 1, #hotspot_content_ids do
				content_2[hotspot_content_ids[j]].disable_button = flag_3
			end
		end

		if not content_2.highlight_hotspot then
			content_2.highlight_hotspot.disable_button = arg_102_6
		end

		local ui_animations = var_102_11.ui_animations

		for k, v in pairs(ui_animations) do
			UIAnimation.update(v, arg_102_5)

			if not UIAnimation.completed(v) then
				ui_animations[k] = nil
			end
		end

		if not content_2.condition_cb then
			content_2.condition_cb(content_2, style)
		end

		UIRenderer.draw_widget(arg_102_2, var_102_11)

		if not var_102_11.content.is_highlighted then
			self:handle_mouse_widget_input(var_102_11, arg_102_4, arg_102_5)
		end

		if not content_2.highlight_hotspot then
			if not content_2.highlight_hotspot.on_hover_enter then
				if not flag then
					local allow_multi_hover = content_2.highlight_hotspot.allow_multi_hover

					table.clear(content_2.highlight_hotspot)

					content_2.highlight_hotspot.allow_multi_hover = allow_multi_hover
				else
					var_102_11.content.is_highlighted = true
					flag = true

					self:select_settings_list_widget(i)
				end
			elseif not content_2.highlight_hotspot.is_hover then
				flag = true
			end
		end
	end

	arg_102_1.visible_widgets_n = num
end

OptionsView.update_scrollbar = function (self, arg_103_1, arg_103_2)
	-- function 103
	local value = self.scrollbar.content.scroll_bar_info.value
	local num = arg_103_1.max_offset_y * value
	local var_103_2 = arg_103_2[arg_103_1.scenegraph_id]
	local offset = var_103_2.offset

	offset = offset or {
		0,
		0,
		0
	}
	var_103_2.offset = offset
	var_103_2.offset[2] = num
end

OptionsView.handle_title_buttons = function (self, arg_104_1, arg_104_2)
	-- function 104
	local title_buttons = self.title_buttons
	local title_buttons_n = self.title_buttons_n
	local find = table.find(SettingsMenuNavigation, "versus_settings")

	for i = 1, title_buttons_n do
		local var_104_3 = title_buttons[i]

		if not arg_104_2 then
			var_104_3.content.button_text.disable_button = true
		elseif not self.is_in_tutorial then
			var_104_3.content.button_text.disable_button = not TutorialSettingsMenuNavigation[i]
		elseif not self.is_in_versus then
			var_104_3.content.button_text.disable_button = i ~= find
		else
			var_104_3.content.button_text.disable_button = false
		end

		UIRenderer.draw_widget(arg_104_1, var_104_3)

		if self.selected_title ~= i then
			local flag = false
			local button_text = var_104_3.content.button_text

			if not button_text and not button_text.on_hover_enter then
				WwiseWorld.trigger_event(self.wwise_world, "Play_hud_hover")
			end

			if not button_text and not button_text.on_release then
				WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")

				button_text.is_selected = true
				flag = true
			end

			if not var_104_3.content.controller_button_hotspot and not var_104_3.content.controller_button_hotspot.on_release then
				var_104_3.content.controller_button_hotspot.is_selected = true
				flag = true
			end

			if not flag then
				if not self:changes_been_made() then
					local var_104_6 = Localize("unapplied_changes_popup_text")

					self.title_popup_id = Managers.popup:queue_popup(var_104_6, Localize("popup_discard_changes_topic"), "apply_changes", Localize("menu_settings_apply"), "revert_changes", Localize("popup_choice_discard"))
					self.delayed_title_change = i
				else
					self:select_settings_title(i)

					self.in_settings_sub_menu = true
				end
			end
		end
	end
end

OptionsView.set_in_versus = function (self, arg_105_1)
	-- function 105
	self.is_in_versus = arg_105_1

	if not arg_105_1 and not table.find(SettingsMenuNavigation, "versus_settings") then
		self:select_settings_title(8)

		self.in_settings_sub_menu = true
	end
end

OptionsView.set_widget_values = function (arg_106_0, arg_106_1)
	-- function 106
	local widgets = arg_106_1.widgets
	local widgets_n = arg_106_1.widgets_n

	for i = 1, widgets_n do
		local var_106_2 = widgets[i]

		var_106_2.content.saved_value_cb(var_106_2)
	end
end

OptionsView.select_settings_list_widget = function (self, arg_107_1)
	-- function 107
	local selected_settings_list = self.selected_settings_list

	if not selected_settings_list then
		return
	end

	local selected_index = selected_settings_list.selected_index
	local widgets = selected_settings_list.widgets

	if not selected_index then
		local var_107_3 = widgets[selected_index]

		self:deselect_settings_list_widget(var_107_3)
	else
		self.gamepad_active_generic_actions_name = nil

		self:change_gamepad_generic_input_action()
	end

	local var_107_4 = widgets[arg_107_1]

	var_107_4.content.is_highlighted = true
	selected_settings_list.selected_index = arg_107_1
	self.gamepad_tooltip_text_widget.content.text = var_107_4.content.tooltip_text
	self.gamepad_tooltip_available = var_107_4.content.tooltip_text ~= nil
	self.in_settings_sub_menu = true

	local type = var_107_4.type
	local input_description = SettingsWidgetTypeTemplate[type].input_description

	if not var_107_4.content.disabled then
		self.menu_input_description:set_input_description(nil)
	else
		self.menu_input_description:set_input_description(input_description)
	end
end

OptionsView.deselect_settings_list_widget = function (self, arg_108_1)
	-- function 108
	arg_108_1.content.is_highlighted = false

	if not arg_108_1.content.highlight_hotspot then
		local allow_multi_hover = arg_108_1.content.highlight_hotspot.allow_multi_hover

		table.clear(arg_108_1.content.highlight_hotspot)

		arg_108_1.content.highlight_hotspot.allow_multi_hover = allow_multi_hover
	end

	self.menu_input_description:set_input_description(nil)
end

OptionsView.settings_list_widget_enter = function (self, arg_109_1)
	-- function 109
	local selected_settings_list = self.selected_settings_list

	if not selected_settings_list then
		return
	end

	selected_settings_list.widgets[arg_109_1].content.is_active = true
end

OptionsView.select_settings_title = function (self, arg_110_1)
	-- function 110
	self.menu_input_description:set_input_description(nil)

	if not self.selected_title then
		self:deselect_title(self.selected_title)
	end

	local var_110_0 = self.title_buttons[arg_110_1]
	local scenegraph_id = var_110_0.scenegraph_id
	local local_position = self.ui_scenegraph[scenegraph_id].local_position

	var_110_0.content.button_text.is_selected = true
	self.selected_title = arg_110_1

	local var_110_3 = SettingsMenuNavigation[arg_110_1]

	fassert(self.settings_lists[var_110_3], "No settings list called %q", var_110_3)

	local var_110_4 = self.settings_lists[var_110_3]

	if not var_110_4.scrollbar then
		self:setup_scrollbar(var_110_4)
	end

	if not var_110_4.hide_reset then
		self.reset_to_default.content.hidden = true
	else
		self.reset_to_default.content.hidden = false
	end

	if var_110_3 == "calibrate_ui" then
		self.disable_all_input = true
	else
		self.disable_all_input = false
	end

	if not var_110_4.on_enter then
		var_110_4.on_enter(var_110_4)
	end

	self:set_widget_values(var_110_4)

	self.selected_settings_list = var_110_4

	local var_110_5

	if var_110_3 == "keybind_settings" then
		var_110_5 = Localize("keybind_deselect_info")

		if not var_110_5 then
			-- Nothing
		end
	end

	var_110_5 = nil

	::label_110_0::

	self.keybind_info_text = var_110_5
end

OptionsView.deselect_title = function (self, arg_111_1)
	-- function 111
	local var_111_0 = SettingsMenuNavigation[arg_111_1]
	local settings_lists = self.settings_lists

	settings_lists = not settings_lists and self.settings_lists[var_111_0]

	if not settings_lists and not settings_lists.on_exit then
		settings_lists.on_exit()
	end

	self.selected_title = nil

	local selected_settings_list = self.selected_settings_list
	local selected_index = selected_settings_list.selected_index
	local widgets = selected_settings_list.widgets

	if not selected_index then
		local var_111_5 = widgets[selected_index]

		self:deselect_settings_list_widget(var_111_5)
	end

	self.selected_settings_list.selected_index = nil
	self.selected_settings_list = nil
	self.title_buttons[arg_111_1].content.button_text.is_selected = false
end

OptionsView.handle_dropdown_lists = function (arg_112_0, arg_112_1, arg_112_2)
	-- function 112
	for i = 1, arg_112_2 do
		local content = arg_112_1[i].content
		local list_content = content.list_content

		for j = 1, #list_content do
			if not list_content[j].selected then
				content.callback(content.options, j)

				break
			end
		end
	end
end

OptionsView.setup_scrollbar = function (self, arg_113_1, arg_113_2)
	-- function 113
	local scrollbar = self.scrollbar
	local scenegraph_id = arg_113_1.scenegraph_id
	local var_113_2 = self.ui_scenegraph[scenegraph_id].size[2]
	local num = self.ui_scenegraph.list_mask.size[2] / var_113_2

	scrollbar.content.scroll_bar_info.bar_height_percentage = num

	self:set_scrollbar_value(arg_113_2 or 0)
end

OptionsView.update_mouse_scroll_input = function (self, arg_114_1)
	-- function 114
	local selected_settings_list = self.selected_settings_list

	if not (not selected_settings_list and selected_settings_list.scrollbar) then
		local value = self.scrollbar.content.scroll_bar_info.value

		if not arg_114_1 then
			self.scroll_field_widget.content.internal_scroll_value = value
		end

		local internal_scroll_value = self.scroll_field_widget.content.internal_scroll_value

		if not internal_scroll_value then
			return
		end

		local scroll_value = self.scroll_value

		if scroll_value ~= internal_scroll_value then
			self:set_scrollbar_value(internal_scroll_value)
		elseif scroll_value ~= value then
			self:set_scrollbar_value(value)
		end
	end
end

OptionsView.set_scrollbar_value = function (self, arg_115_1)
	-- function 115
	local scroll_value = self.scroll_value

	if not (not scroll_value and arg_115_1 == scroll_value) then
		self.scrollbar.content.scroll_bar_info.value = arg_115_1
		self.scroll_field_widget.content.internal_scroll_value = arg_115_1
		self.scroll_value = arg_115_1
	end
end

OptionsView.change_gamepad_generic_input_action = function (self, arg_116_1)
	-- function 116
	local in_settings_sub_menu = self.in_settings_sub_menu
	local str = "default"
	local flag

	flag = not in_settings_sub_menu and "sub_menu" and "main_menu"

	local hidden = self.reset_to_default.content.hidden

	hidden = hidden or self.reset_to_default.content.button_text.disabled

	local disabled = self.apply_button.content.button_text.disabled

	if not hidden then
		if not disabled then
			str = "reset_and_apply"
		else
			str = "reset"
		end
	elseif not disabled then
		str = "apply"
	end

	if not (not self.gamepad_active_generic_actions_name and self.gamepad_active_generic_actions_name == str) then
		self.gamepad_active_generic_actions_name = str

		local var_116_5 = tbl[flag][str]

		self.menu_input_description:change_generic_actions(var_116_5)
	end

	if not arg_116_1 then
		self.menu_input_description:set_input_description(nil)
	end
end

OptionsView._find_next_title_tab = function (self)
	-- function 117
	local num = 1 + self.selected_title % self.title_buttons_n
	local var_117_1

	for i = num, self.title_buttons_n do
		local var_117_2 = self.title_buttons[i]

		if not var_117_2 then
			break
		end

		if not var_117_2.content.button_text.disable_button then
			var_117_1 = i

			break
		end
	end

	return var_117_1
end

OptionsView._find_previous_title_tab = function (self)
	-- function 118
	local num = self.selected_title - 1

	if num < 1 then
		num = self.title_buttons_n
	end

	local var_118_1

	for i = num, 1, -1 do
		local var_118_2 = self.title_buttons[i]

		if not var_118_2 then
			break
		end

		if not var_118_2.content.button_text.disable_button then
			var_118_1 = i

			break
		end
	end

	return var_118_1
end

OptionsView.handle_controller_navigation_input = function (self, arg_119_1, arg_119_2)
	-- function 119
	self:change_gamepad_generic_input_action()

	if self.controller_cooldown > 0 then
		self.controller_cooldown = self.controller_cooldown - arg_119_1

		local speed_multiplier = self.speed_multiplier

		speed_multiplier = speed_multiplier or 1

		local menu_speed_multiplier_frame_decrease = GamepadSettings.menu_speed_multiplier_frame_decrease
		local menu_min_speed_multiplier = GamepadSettings.menu_min_speed_multiplier

		self.speed_multiplier = math.max(speed_multiplier - menu_speed_multiplier_frame_decrease, menu_min_speed_multiplier)

		return
	else
		local in_settings_sub_menu = self.in_settings_sub_menu

		if not in_settings_sub_menu then
			in_settings_sub_menu = true
			self.in_settings_sub_menu = in_settings_sub_menu

			self:set_console_setting_list_selection(1, true, false)
		end

		local gamepad_tooltip_available = self.gamepad_tooltip_available

		gamepad_tooltip_available = not gamepad_tooltip_available and arg_119_2:get("trigger_cycle_previous_hold")
		self.draw_gamepad_tooltip = gamepad_tooltip_available

		if not self.draw_gamepad_tooltip then
			return
		end

		local handle_settings_list_widget_input, var_119_6 = self:handle_settings_list_widget_input(arg_119_2, arg_119_1)

		if not handle_settings_list_widget_input then
			if var_119_6 ~= nil then
				self:set_selected_input_description_by_active(var_119_6)
			end

			return
		elseif not arg_119_2:get("back", true) then
			local selected_settings_list = self.selected_settings_list

			if not selected_settings_list.scrollbar then
				self:setup_scrollbar(selected_settings_list)
			end

			in_settings_sub_menu = false
			self.in_settings_sub_menu = in_settings_sub_menu

			self:clear_console_setting_list_selection()

			self.gamepad_active_generic_actions_name = nil

			self:change_gamepad_generic_input_action(true)
			WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")

			if not self:changes_been_made() then
				local var_119_8 = Localize("unapplied_changes_popup_text")

				self.title_popup_id = Managers.popup:queue_popup(var_119_8, Localize("popup_discard_changes_topic"), "apply_changes", Localize("menu_settings_apply"), "revert_changes", Localize("popup_choice_discard"))
			else
				self:on_exit_pressed()
			end
		end

		local var_119_9

		if not arg_119_2:get("cycle_previous") then
			var_119_9 = self:_find_previous_title_tab()
		elseif not arg_119_2:get("cycle_next") then
			var_119_9 = self:_find_next_title_tab()
		end

		if not var_119_9 then
			if not self:changes_been_made() then
				local var_119_10 = Localize("unapplied_changes_popup_text")

				self.title_popup_id = Managers.popup:queue_popup(var_119_10, Localize("popup_discard_changes_topic"), "apply_changes", Localize("menu_settings_apply"), "revert_changes", Localize("popup_choice_discard"))
				self.delayed_title_change = var_119_9
			else
				self:select_settings_title(var_119_9)
				self:set_console_setting_list_selection(1, true)

				self.in_settings_sub_menu = true
			end
		end

		if not in_settings_sub_menu then
			local speed_multiplier_2 = self.speed_multiplier

			speed_multiplier_2 = speed_multiplier_2 or 1

			local selected_settings_list_2 = self.selected_settings_list
			local widgets = selected_settings_list_2.widgets
			local selected_index = selected_settings_list_2.selected_index

			selected_index = selected_index or 0

			repeat
				local get = arg_119_2:get("move_up")
				local get_2 = arg_119_2:get("move_up_hold")

				if get or not get_2 then
					self.controller_cooldown = GamepadSettings.menu_cooldown * speed_multiplier_2

					self:set_console_setting_list_selection(selected_index - 1, false)

					return
				end

				local get_3 = arg_119_2:get("move_down")
				local get_4 = arg_119_2:get("move_down_hold")

				if get_3 or not get_4 then
					self.controller_cooldown = GamepadSettings.menu_cooldown * speed_multiplier_2

					self:set_console_setting_list_selection(selected_index + 1, true)

					return
				end
			until true
		else
			local speed_multiplier_3 = self.speed_multiplier

			speed_multiplier_3 = speed_multiplier_3 or 1

			local selected_title = self.selected_title

			selected_title = selected_title or 0

			repeat
				local get_5 = arg_119_2:get("move_up")
				local get_6 = arg_119_2:get("move_up_hold")

				if get_5 or not get_6 then
					self.controller_cooldown = GamepadSettings.menu_cooldown * speed_multiplier_3

					self:set_console_title_selection(selected_title - 1)

					return
				end

				local get_7 = arg_119_2:get("move_down")
				local get_8 = arg_119_2:get("move_down_hold")

				if get_7 or not get_8 then
					self.controller_cooldown = GamepadSettings.menu_cooldown * speed_multiplier_3

					self:set_console_title_selection(selected_title + 1)

					return
				end
			until true
		end
	end

	self.speed_multiplier = 1
end

OptionsView.handle_mouse_widget_input = function (self, arg_120_1, arg_120_2, arg_120_3)
	-- function 120
	local type = arg_120_1.type

	self._input_functions[type](arg_120_1, arg_120_2, arg_120_3)
end

OptionsView.handle_settings_list_widget_input = function (self, arg_121_1, arg_121_2)
	-- function 121
	local selected_settings_list = self.selected_settings_list
	local widgets = selected_settings_list.widgets
	local selected_index = selected_settings_list.selected_index

	selected_index = selected_index or 1

	local var_121_3 = widgets[selected_index]

	if selected_settings_list.widgets_n == 0 or not var_121_3.content.disabled then
		return false
	end

	local type = var_121_3.type

	return SettingsWidgetTypeTemplate[type].input_function(var_121_3, arg_121_1, arg_121_2)
end

OptionsView.set_console_title_selection = function (self, arg_122_1, arg_122_2)
	-- function 122
	local selected_title = self.selected_title

	if selected_title == arg_122_1 then
		return
	elseif not selected_title then
		arg_122_1 = 1
	end

	if not (arg_122_1 > #SettingsMenuNavigation or not (arg_122_1 <= 0)) then
		return
	end

	if not arg_122_2 then
		WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")
	end

	self:select_settings_title(arg_122_1)
end

OptionsView.set_console_setting_list_selection = function (self, arg_123_1, arg_123_2, arg_123_3)
	-- function 123
	local selected_settings_list = self.selected_settings_list
	local selected_index = selected_settings_list.selected_index
	local widgets = selected_settings_list.widgets
	local widgets_n = selected_settings_list.widgets_n
	local var_123_4 = arg_123_1
	local var_123_5 = widgets[var_123_4]
	local is_widget_selectable = self:is_widget_selectable(var_123_5)

	while not is_widget_selectable do
		if not arg_123_2 then
			var_123_4 = math.min(var_123_4 + 1, widgets_n + 1)
		else
			var_123_4 = math.max(var_123_4 - 1, 0)
		end

		if not (var_123_4 < 1 or not (widgets_n < var_123_4)) then
			return
		end

		local var_123_7 = widgets[var_123_4]

		is_widget_selectable = self:is_widget_selectable(var_123_7)
	end

	if not arg_123_3 then
		WwiseWorld.trigger_event(self.wwise_world, "Play_hud_select")
	end

	if not selected_settings_list.scrollbar then
		self:move_scrollbar_based_on_selection(var_123_4)
	end

	self:select_settings_list_widget(var_123_4)
end

OptionsView.is_widget_selectable = function (arg_124_0, arg_124_1)
	-- function 124
	return not arg_124_1 and arg_124_1.type == "image" and arg_124_1.type == "gamepad_layout" or arg_124_1.type ~= "title"
end

OptionsView.clear_console_setting_list_selection = function (self)
	-- function 125
	local selected_settings_list = self.selected_settings_list

	if not selected_settings_list then
		return
	end

	local selected_index = selected_settings_list.selected_index

	if not selected_index then
		local var_125_2 = selected_settings_list.widgets[selected_index]

		self:deselect_settings_list_widget(var_125_2)

		selected_settings_list.selected_index = nil
	end
end

OptionsView.move_scrollbar_based_on_selection = function (self, arg_126_1)
	-- function 126
	local selected_settings_list = self.selected_settings_list
	local selected_index = selected_settings_list.selected_index
	local flag

	flag = selected_index or not true or selected_index < arg_126_1

	local widgets = selected_settings_list.widgets
	local var_126_4

	if not flag then
		var_126_4 = widgets[arg_126_1 + 1]

		if not var_126_4 then
			-- Nothing
		end
	end

	var_126_4 = widgets[arg_126_1 - 1]

	::label_126_0::

	if not var_126_4 then
		local max_offset_y = selected_settings_list.max_offset_y
		local ui_scenegraph = self.ui_scenegraph
		local scenegraph_id_start = selected_settings_list.scenegraph_id_start
		local deprecated_copy = Vector3.deprecated_copy(UISceneGraph.get_world_position(ui_scenegraph, "list_mask"))
		local get_size = UISceneGraph.get_size(ui_scenegraph, "list_mask")
		local get_world_position = UISceneGraph.get_world_position(ui_scenegraph, scenegraph_id_start)

		if not selected_index then
			local var_126_11 = widgets[selected_index]
			local offset = var_126_11.style.offset
			local size = var_126_11.style.size

			tbl_23[1] = get_world_position[1] + offset[1]
			tbl_23[2] = get_world_position[2] + offset[2]

			local point_is_inside_2d_box = math.point_is_inside_2d_box(tbl_23, deprecated_copy, get_size)

			tbl_23[2] = tbl_23[2] + size[2]
			point_is_inside_2d_box = not point_is_inside_2d_box and math.point_is_inside_2d_box(tbl_23, deprecated_copy, get_size)

			if not point_is_inside_2d_box then
				local var_126_15
				local flag_2

				flag_2 = not (get_world_position[2] + offset[2] < deprecated_copy[2]) or not true or false

				if not ((flag or not flag_2 or not flag) and flag_2) then
					flag = not flag
					var_126_4 = var_126_11
				end
			end
		end

		local style = var_126_4.style
		local size_2 = style.size
		local offset_2 = style.offset

		tbl_23[1] = get_world_position[1] + offset_2[1]
		tbl_23[2] = get_world_position[2] + offset_2[2]

		local point_is_inside_2d_box_2 = math.point_is_inside_2d_box(tbl_23, deprecated_copy, get_size)

		tbl_23[2] = tbl_23[2] + size_2[2]
		point_is_inside_2d_box_2 = not point_is_inside_2d_box_2 and math.point_is_inside_2d_box(tbl_23, deprecated_copy, get_size)

		if not point_is_inside_2d_box_2 then
			local num = 0

			if not flag then
				local var_126_22 = deprecated_copy[2]
				local num_2 = get_world_position[2] + offset_2[2]

				num = math.abs(var_126_22 - num_2) / max_offset_y
			else
				local num_3 = deprecated_copy[2] + get_size[2]
				local var_126_25 = tbl_23[2]

				num = -(math.abs(num_3 - var_126_25) / max_offset_y)
			end

			local value = self.scrollbar.content.scroll_bar_info.value

			self:set_scrollbar_value(math.clamp(value + num, 0, 1))
		end
	else
		local scrollbar = self.scrollbar

		if not flag then
			self:set_scrollbar_value(1)
		else
			self:set_scrollbar_value(0)
		end
	end
end

OptionsView.set_selected_input_description_by_active = function (self, arg_127_1)
	-- function 127
	local selected_settings_list = self.selected_settings_list

	if not selected_settings_list then
		return
	end

	local selected_index = selected_settings_list.selected_index
	local var_127_2 = selected_settings_list.widgets[selected_index]
	local disabled = var_127_2.content.disabled
	local type = var_127_2.type
	local var_127_5 = SettingsWidgetTypeTemplate[type]
	local active_input_description

	if not arg_127_1 then
		active_input_description = var_127_5.active_input_description

		if not active_input_description then
			-- Nothing
		end
	end

	active_input_description = var_127_5.input_description

	::label_127_0::

	if not disabled then
		self.menu_input_description:set_input_description(nil)
	else
		self.menu_input_description:set_input_description(active_input_description)
	end
end

OptionsView.animate_element_by_time = function (arg_128_0, arg_128_1, arg_128_2, arg_128_3, arg_128_4, arg_128_5)
	-- function 128
	return (UIAnimation.init(UIAnimation.function_by_time, arg_128_1, arg_128_2, arg_128_3, arg_128_4, arg_128_5, math.ease_out_quad))
end

OptionsView.animate_element_by_catmullrom = function (arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4, arg_129_5, arg_129_6, arg_129_7, arg_129_8)
	-- function 129
	return (UIAnimation.init(UIAnimation.catmullrom, arg_129_1, arg_129_2, arg_129_3, arg_129_4, arg_129_5, arg_129_6, arg_129_7, arg_129_8))
end

OptionsView.on_stepper_arrow_pressed = function (self, arg_130_1, arg_130_2)
	-- function 130
	local ui_animations = arg_130_1.ui_animations
	local var_130_1 = arg_130_1.style[arg_130_2]
	local tbl = {
		28,
		34
	}
	local var_130_3 = var_130_1.color[1]
	local num = 255
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration

	if topic_hover_duration > 0 then
		local str = "stepper_widget_arrow_hover_" .. arg_130_2
		local str_2 = "stepper_widget_arrow_width_" .. arg_130_2
		local str_3 = "stepper_widget_arrow_height_" .. arg_130_2

		ui_animations[str] = self:animate_element_by_time(var_130_1.color, 1, var_130_3, num, topic_hover_duration)
		ui_animations[str_2] = self:animate_element_by_catmullrom(var_130_1.size, 1, tbl[1], 0.7, 1, 1, 0.7, topic_hover_duration)
		ui_animations[str_3] = self:animate_element_by_catmullrom(var_130_1.size, 2, tbl[2], 0.7, 1, 1, 0.7, topic_hover_duration)
	else
		var_130_1.color[1] = num
	end
end

OptionsView.on_stepper_arrow_hover = function (self, arg_131_1, arg_131_2)
	-- function 131
	local ui_animations = arg_131_1.ui_animations
	local var_131_1 = arg_131_1.style[arg_131_2]
	local var_131_2 = var_131_1.color[1]
	local num = 255
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration
	local num_2 = (1 - var_131_2 / num) * topic_hover_duration

	if num_2 > 0 then
		ui_animations["stepper_widget_arrow_hover_" .. arg_131_2] = self:animate_element_by_time(var_131_1.color, 1, var_131_2, num, num_2)
	else
		var_131_1.color[1] = num
	end
end

OptionsView.on_stepper_arrow_dehover = function (self, arg_132_1, arg_132_2)
	-- function 132
	local ui_animations = arg_132_1.ui_animations
	local var_132_1 = arg_132_1.style[arg_132_2]
	local var_132_2 = var_132_1.color[1]
	local num = 0
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration
	local num_2 = var_132_2 / 255 * topic_hover_duration

	if num_2 > 0 then
		ui_animations["stepper_widget_arrow_hover_" .. arg_132_2] = self:animate_element_by_time(var_132_1.color, 1, var_132_2, num, num_2)
	else
		var_132_1.color[1] = num
	end
end

OptionsView.checkbox_test_setup = function (arg_133_0)
	-- function 133
	return false, "test"
end

OptionsView.checkbox_test_saved_value = function (arg_134_0, arg_134_1)
	-- function 134
	arg_134_1.content.flag = false
end

OptionsView.checkbox_test = function (arg_135_0, arg_135_1)
	-- function 135
	local flag = arg_135_1.flag

	print("OptionsView:checkbox_test(flag)", arg_135_0, flag)
end

OptionsView.slider_test_setup = function (arg_136_0)
	-- function 136
	return 0.5, 5, 500, 0, "Music Volume"
end

OptionsView.slider_test_saved_value = function (arg_137_0, arg_137_1)
	-- function 137
	arg_137_1.content.value = 0.5
end

OptionsView.slider_test = function (arg_138_0, arg_138_1)
	-- function 138
	local value = arg_138_1.value

	print("OptionsView:slider_test(flag)", arg_138_0, value)
end

OptionsView.drop_down_test_setup = function (arg_139_0)
	-- function 139
	local tbl = {
		{
			text = "1920x1080",
			value = {
				1920,
				1080
			}
		},
		{
			text = "1680x1050",
			value = {
				1680,
				1050
			}
		},
		{
			text = "1680x1050",
			value = {
				1680,
				1050
			}
		}
	}

	return 1, tbl, "Resolution"
end

OptionsView.drop_down_test_saved_value = function (arg_140_0, arg_140_1)
	-- function 140
	local options_values = arg_140_1.content.options_values
	local options_texts = arg_140_1.content.options_texts

	arg_140_1.content.selected_option = options_texts[1]
end

OptionsView.drop_down_test = function (arg_141_0, arg_141_1, arg_141_2)
	-- function 141
	print("OptionsView:dropdown_test(flag)", arg_141_0, arg_141_1, arg_141_2)
end

OptionsView.cb_stepper_test_setup = function (arg_142_0)
	-- function 142
	local tbl = {
		{
			text = "value_1",
			value = 1
		},
		{
			text = "value_2_maddafakkaaa",
			value = 2
		},
		{
			text = "value_3_yobro",
			value = 3
		}
	}

	return 1, tbl, "stepper_test"
end

OptionsView.cb_stepper_test_saved_value = function (arg_143_0, arg_143_1)
	-- function 143
	arg_143_1.content.current_selection = 1
end

OptionsView.cb_stepper_test = function (arg_144_0, arg_144_1)
	-- function 144
	local var_144_0 = arg_144_1.options_values[arg_144_1.current_selection]

	print(var_144_0)
end

OptionsView.cb_vsync_setup = function (arg_145_0)
	-- function 145
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("vsync")

	user_setting = user_setting or false

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "vsync") and 2 and 1

	return flag, tbl, "settings_menu_vsync", flag_2
end

OptionsView.cb_vsync_saved_value = function (self, arg_146_1)
	-- function 146
	local var_146_0 = fn_2(self.changed_user_settings.vsync, Application.user_setting("vsync"))
	local content = arg_146_1.content
	local flag

	flag = not var_146_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_vsync = function (arg_147_0, arg_147_1)
	-- function 147
	local options_values = arg_147_1.options_values
	local current_selection = arg_147_1.current_selection

	arg_147_0.changed_user_settings.vsync = options_values[current_selection]
end

OptionsView.cb_vsync_condition = function (self, arg_148_1, arg_148_2)
	-- function 148
	if not self:_get_setting("render_settings", "dlss_g_enabled") then
		self:_set_setting_override(arg_148_1, arg_148_2, "vsync", false)
		self:_set_override_reason(arg_148_1, "menu_settings_dlss_frame_generation")

		arg_148_1.disabled = true
	else
		self:_restore_setting_override(arg_148_1, arg_148_2, "vsync")

		arg_148_1.disabled = false
	end
end

OptionsView.cb_hud_clamp_ui_scaling_setup = function (arg_149_0)
	-- function 149
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("hud_clamp_ui_scaling")

	user_setting = user_setting or false

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "hud_clamp_ui_scaling") and 2 and 1

	return flag, tbl, "settings_menu_hud_clamp_ui_scaling", flag_2
end

OptionsView.cb_hud_clamp_ui_scaling_saved_value = function (self, arg_150_1)
	-- function 150
	local var_150_0 = fn_2(self.changed_user_settings.hud_clamp_ui_scaling, Application.user_setting("hud_clamp_ui_scaling"))
	local content = arg_150_1.content
	local flag

	flag = not var_150_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_hud_clamp_ui_scaling = function (arg_151_0, arg_151_1)
	-- function 151
	local var_151_0 = arg_151_1.options_values[arg_151_1.current_selection]

	arg_151_0.changed_user_settings.hud_clamp_ui_scaling = var_151_0

	local flag = true

	UPDATE_RESOLUTION_LOOKUP(flag)
end

OptionsView.cb_vs_floating_damage = function (arg_152_0, arg_152_1)
	-- function 152
	local options_values = arg_152_1.options_values
	local current_selection = arg_152_1.current_selection

	arg_152_0.changed_user_settings.vs_floating_damage = options_values[current_selection]
end

OptionsView.cb_vs_floating_damage_setup = function (arg_153_0)
	-- function 153
	local tbl = {
		{
			value = "none",
			text = Localize("menu_settings_crosshair_none")
		},
		{
			value = "floating",
			text = Localize("menu_settings_floating_damage")
		},
		{
			value = "streak",
			text = Localize("menu_settings_streak_damage")
		},
		{
			value = "both",
			text = Localize("menu_settings_both")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "vs_floating_damage")
	local user_setting = Application.user_setting("vs_floating_damage")
	local var_153_3
	local var_153_4

	for i, v in ipairs(tbl) do
		if v.value == user_setting then
			var_153_4 = i
		end

		if v.value == get then
			var_153_3 = i
		end
	end

	fassert(var_153_3, "default option %i does not exist in cb_enabled_crosshairs_setup options table", get)

	return var_153_4 or var_153_3, tbl, "menu_settings_vs_floating_damage", var_153_3
end

OptionsView.cb_vs_floating_damage_saved_value = function (self, arg_154_1)
	-- function 154
	local var_154_0 = fn_2(self.changed_user_settings.vs_floating_damage, Application.user_setting("vs_floating_damage"))

	var_154_0 = var_154_0 or DefaultUserSettings.get("user_settings", "vs_floating_damage")

	local options_values = arg_154_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_154_0 == options_values[i] then
			num = i

			break
		end
	end

	arg_154_1.content.current_selection = num
end

OptionsView.cb_vs_hud_damage_feedback_in_world_setup = function (arg_155_0)
	-- function 155
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("hud_damage_feedback_in_world")

	user_setting = user_setting or false

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "hud_damage_feedback_in_world") and 2 and 1

	return flag, tbl, "settings_menu_hud_damage_feedback_in_world", flag_2
end

OptionsView.cb_vs_hud_damage_feedback_in_world_saved_value = function (self, arg_156_1)
	-- function 156
	local var_156_0 = fn_2(self.changed_user_settings.hud_damage_feedback_in_world, Application.user_setting("hud_damage_feedback_in_world"))
	local content = arg_156_1.content
	local flag

	flag = not var_156_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_vs_hud_damage_feedback_in_world = function (arg_157_0, arg_157_1)
	-- function 157
	local var_157_0 = arg_157_1.options_values[arg_157_1.current_selection]

	arg_157_0.changed_user_settings.hud_damage_feedback_in_world = var_157_0
end

OptionsView.cb_vs_hud_damage_feedback_on_yourself_setup = function (arg_158_0)
	-- function 158
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("hud_damage_feedback_on_yourself")

	user_setting = user_setting or false

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "hud_damage_feedback_on_yourself") and 2 and 1

	return flag, tbl, "settings_menu_hud_damage_feedback_on_yourself", flag_2
end

OptionsView.cb_vs_hud_damage_feedback_on_yourself_saved_value = function (self, arg_159_1)
	-- function 159
	local var_159_0 = fn_2(self.changed_user_settings.hud_damage_feedback_on_yourself, Application.user_setting("hud_damage_feedback_on_yourself"))
	local content = arg_159_1.content
	local flag

	flag = not var_159_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_vs_hud_damage_feedback_on_yourself = function (arg_160_0, arg_160_1)
	-- function 160
	local var_160_0 = arg_160_1.options_values[arg_160_1.current_selection]

	arg_160_0.changed_user_settings.hud_damage_feedback_on_yourself = var_160_0
end

OptionsView.cb_vs_hud_damage_feedback_on_teammates_setup = function (arg_161_0)
	-- function 161
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("hud_damage_feedback_on_teammates")

	user_setting = user_setting or false

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "hud_damage_feedback_on_teammates") and 2 and 1

	return flag, tbl, "settings_menu_hud_damage_feedback_on_teammates", flag_2
end

OptionsView.cb_vs_hud_damage_feedback_on_teammates_saved_value = function (self, arg_162_1)
	-- function 162
	local var_162_0 = fn_2(self.changed_user_settings.hud_damage_feedback_on_teammates, Application.user_setting("hud_damage_feedback_on_teammates"))
	local content = arg_162_1.content
	local flag

	flag = not var_162_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_vs_hud_damage_feedback_on_teammates = function (arg_163_0, arg_163_1)
	-- function 163
	local var_163_0 = arg_163_1.options_values[arg_163_1.current_selection]

	arg_163_0.changed_user_settings.hud_damage_feedback_on_teammates = var_163_0
end

OptionsView.cb_hud_custom_scale_setup = function (arg_164_0)
	-- function 164
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("use_custom_hud_scale")

	user_setting = user_setting or false

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "use_custom_hud_scale") and 2 and 1

	return flag, tbl, "settings_menu_hud_custom_scale", flag_2
end

OptionsView.cb_hud_custom_scale_saved_value = function (self, arg_165_1)
	-- function 165
	local var_165_0 = fn_2(self.changed_user_settings.use_custom_hud_scale, Application.user_setting("use_custom_hud_scale"))
	local content = arg_165_1.content
	local flag

	flag = not var_165_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_hud_custom_scale = function (self, arg_166_1)
	-- function 166
	local var_166_0 = arg_166_1.options_values[arg_166_1.current_selection]

	self.changed_user_settings.use_custom_hud_scale = var_166_0

	if var_166_0 == true then
		self:set_widget_disabled("hud_scale", false)
	else
		self:set_widget_disabled("hud_scale", true)
	end

	local flag = true

	UPDATE_RESOLUTION_LOOKUP(flag)
end

OptionsView.cb_enabled_pc_menu_layout_setup = function (arg_167_0)
	-- function 167
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("use_pc_menu_layout")

	user_setting = user_setting or false

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "use_pc_menu_layout") and 2 and 1

	return flag, tbl, "settings_menu_enabled_pc_menu_layout", flag_2
end

OptionsView.cb_enabled_pc_menu_layout_saved_value = function (self, arg_168_1)
	-- function 168
	local var_168_0 = fn_2(self.changed_user_settings.use_pc_menu_layout, Application.user_setting("use_pc_menu_layout"))
	local content = arg_168_1.content
	local flag

	flag = not var_168_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_enabled_pc_menu_layout = function (arg_169_0, arg_169_1)
	-- function 169
	local options_values = arg_169_1.options_values
	local current_selection = arg_169_1.current_selection

	arg_169_0.changed_user_settings.use_pc_menu_layout = options_values[current_selection]
end

OptionsView.cb_enabled_gamepad_hud_layout_setup = function (arg_170_0)
	-- function 170
	local tbl = {
		{
			value = "auto",
			text = Localize("map_host_option_1")
		},
		{
			value = "always",
			text = Localize("map_host_option_2")
		},
		{
			value = "never",
			text = Localize("map_host_option_3")
		}
	}
	local user_setting = Application.user_setting("use_gamepad_hud_layout")

	user_setting = user_setting or "auto"

	local num = 1
	local num_2 = 1
	local get = DefaultUserSettings.get("user_settings", "use_gamepad_hud_layout")

	for i, v in ipairs(tbl) do
		num = user_setting ~= v.value or not i or num
		num_2 = get ~= v.value or not i or num_2
	end

	return num, tbl, "settings_menu_enabled_gamepad_hud_layout", num_2
end

OptionsView.cb_enabled_gamepad_hud_layout_saved_value = function (self, arg_171_1)
	-- function 171
	local var_171_0 = fn_2(self.changed_user_settings.use_gamepad_hud_layout, Application.user_setting("use_gamepad_hud_layout"))
	local options_values = arg_171_1.content.options_values

	for i, v in ipairs(options_values) do
		if var_171_0 == v then
			arg_171_1.content.current_selection = i

			break
		end
	end
end

OptionsView.cb_enabled_gamepad_hud_layout = function (arg_172_0, arg_172_1)
	-- function 172
	local options_values = arg_172_1.options_values
	local current_selection = arg_172_1.current_selection

	arg_172_0.changed_user_settings.use_gamepad_hud_layout = options_values[current_selection]
end

OptionsView.cb_fullscreen_setup = function (arg_173_0)
	-- function 173
	local tbl = {
		{
			value = "fullscreen",
			text = Localize("menu_settings_fullscreen")
		},
		{
			value = "borderless_fullscreen",
			text = Localize("menu_settings_borderless_window")
		},
		{
			value = "windowed",
			text = Localize("menu_settings_windowed")
		}
	}
	local user_setting = Application.user_setting("fullscreen")
	local user_setting_2 = Application.user_setting("borderless_fullscreen")
	local flag

	flag = not not user_setting or not user_setting_2

	local flag_2

	flag_2 = not user_setting and 1 and not user_setting_2 or 2 and 3

	local get = DefaultUserSettings.get("user_settings", "fullscreen")
	local get_2 = DefaultUserSettings.get("user_settings", "borderless_fullscreen")
	local flag_3

	flag_3 = not get and 1 and not user_setting_2 or 2 and 3

	return flag_2, tbl, "menu_settings_windowed_mode", flag_3
end

OptionsView.cb_fullscreen_saved_value = function (self, arg_174_1)
	-- function 174
	local options_values = arg_174_1.content.options_values
	local options_texts = arg_174_1.content.options_texts
	local var_174_2 = fn_2(self.changed_user_settings.fullscreen, Application.user_setting("fullscreen"))
	local var_174_3 = fn_2(self.changed_user_settings.borderless_fullscreen, Application.user_setting("borderless_fullscreen"))
	local flag

	flag = not not var_174_2 or not var_174_3

	local flag_2

	flag_2 = not var_174_2 and 1 and not var_174_3 or 2 and 3
	arg_174_1.content.current_selection = flag_2
end

OptionsView.cb_fullscreen = function (self, arg_175_1)
	-- function 175
	local current_selection = arg_175_1.current_selection
	local var_175_1 = arg_175_1.options_values[current_selection]
	local changed_user_settings = self.changed_user_settings

	if var_175_1 == "fullscreen" then
		changed_user_settings.fullscreen = true
		changed_user_settings.borderless_fullscreen = false
	elseif var_175_1 == "borderless_fullscreen" then
		changed_user_settings.fullscreen = false
		changed_user_settings.borderless_fullscreen = true
	elseif var_175_1 == "windowed" then
		changed_user_settings.fullscreen = false
		changed_user_settings.borderless_fullscreen = false
	end

	if var_175_1 == "borderless_fullscreen" then
		self:set_widget_disabled("resolutions", true)
	else
		self:set_widget_disabled("resolutions", false)
	end

	if var_175_1 == "fullscreen" then
		self:set_widget_disabled("minimize_on_alt_tab", false)
	else
		self:set_widget_disabled("minimize_on_alt_tab", true)
	end
end

OptionsView.cb_adapter_setup = function (arg_176_0)
	-- function 176
	local num_adapters = DisplayAdapter.num_adapters()
	local tbl = {}

	for i = 0, num_adapters - 1 do
		tbl[#tbl + 1] = {
			text = tostring(i),
			value = i
		}
	end

	local num = Application.user_setting("adapter_index") + 1
	local num_2 = DefaultUserSettings.get("user_settings", "adapter_index") + 1

	return num, tbl, "menu_settings_adapter", num_2
end

OptionsView.cb_adapter_saved_value = function (self, arg_177_1)
	-- function 177
	local options_values = arg_177_1.content.options_values
	local num = fn_2(self.changed_user_settings.adapter_index, Application.user_setting("adapter_index")) + 1

	arg_177_1.content.current_selection = num
end

OptionsView.cb_adapter = function (arg_178_0, arg_178_1, arg_178_2)
	-- function 178
	local var_178_0 = arg_178_1.options_values[arg_178_1.current_selection]

	arg_178_0.changed_user_settings.adapter_index = var_178_0
end

OptionsView.cb_minimize_on_alt_tab_setup = function (arg_179_0)
	-- function 179
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local user_setting = Application.user_setting("fullscreen_minimize_on_alt_tab")
	local num = 1

	for i, v in ipairs(tbl) do
		if user_setting == v.value then
			num = i

			break
		end
	end

	return num, tbl, "menu_settings_minimize_on_alt_tab", true
end

OptionsView.cb_minimize_on_alt_tab_saved_value = function (self, arg_180_1)
	-- function 180
	local options_values = arg_180_1.content.options_values
	local var_180_1 = fn_2(self.changed_user_settings.fullscreen_minimize_on_alt_tab, Application.user_setting("fullscreen_minimize_on_alt_tab"))
	local num = 1

	for i, v in ipairs(options_values) do
		if var_180_1 == v then
			num = i

			break
		end
	end

	arg_180_1.content.current_selection = num
end

OptionsView.cb_minimize_on_alt_tab = function (arg_181_0, arg_181_1, arg_181_2)
	-- function 181
	local var_181_0 = arg_181_1.options_values[arg_181_1.current_selection]

	arg_181_0.changed_user_settings.fullscreen_minimize_on_alt_tab = var_181_0
end

OptionsView.cb_graphics_quality_setup = function (arg_182_0)
	-- function 182
	local tbl = {
		{
			value = "custom",
			text = Localize("menu_settings_custom")
		},
		{
			value = "lowest",
			text = Localize("menu_settings_lowest")
		},
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		},
		{
			value = "extreme",
			text = Localize("menu_settings_extreme")
		}
	}
	local user_setting = Application.user_setting("graphics_quality")
	local num = 1

	for i, v in ipairs(tbl) do
		if user_setting == v.value then
			num = i

			break
		end
	end

	return num, tbl, "menu_settings_graphics_quality", "high"
end

OptionsView.cb_graphics_quality_saved_value = function (self, arg_183_1)
	-- function 183
	local var_183_0 = fn_2(self.changed_user_settings.graphics_quality, Application.user_setting("graphics_quality"))
	local options_values = arg_183_1.content.options_values
	local num = 1

	for i, v in ipairs(options_values) do
		if var_183_0 == v then
			num = i

			break
		end
	end

	arg_183_1.content.current_selection = num
end

OptionsView.cb_graphics_quality = function (self, arg_184_1)
	-- function 184
	local var_184_0 = arg_184_1.options_values[arg_184_1.current_selection]

	self.changed_user_settings.graphics_quality = var_184_0

	if var_184_0 == "custom" then
		return
	end

	local var_184_1 = GraphicsQuality[var_184_0]
	local user_settings = var_184_1.user_settings

	for k, v in pairs(user_settings) do
		self.changed_user_settings[k] = v
	end

	local render_settings = var_184_1.render_settings

	for k_2, v_2 in pairs(render_settings) do
		self.changed_render_settings[k_2] = v_2
	end

	local widgets = self.selected_settings_list.widgets
	local widgets_n = self.selected_settings_list.widgets_n

	for i4 = 1, widgets_n do
		local var_184_6 = widgets[i4]

		if var_184_6.name ~= "graphics_quality_settings" then
			local content = var_184_6.content

			content.saved_value_cb(var_184_6)
			content.callback(content, var_184_6.style, true)
		end
	end
end

OptionsView.cb_resolutions_setup = function (arg_185_0)
	-- function 185
	local user_setting = Application.user_setting("screen_resolution")
	local user_setting_2 = Application.user_setting("fullscreen_output")
	local user_setting_3 = Application.user_setting("adapter_index")

	if DisplayAdapter.num_outputs(user_setting_3) < 1 then
		local num_adapters = DisplayAdapter.num_adapters()

		for i = 0, num_adapters - 1 do
			if DisplayAdapter.num_outputs(i) > 0 then
				user_setting_3 = i

				break
			end
		end
	end

	if DisplayAdapter.num_outputs(user_setting_3) < 1 then
		return 1, {
			{
				text = "1280x720 -- NO OUTPUTS",
				value = {
					1280,
					720
				}
			}
		}, "menu_settings_resolution"
	end

	local tbl = {}
	local num_modes = DisplayAdapter.num_modes(user_setting_3, user_setting_2)

	for j = 0, num_modes - 1 do
		repeat
			local mode, var_185_7 = DisplayAdapter.mode(user_setting_3, user_setting_2, j)

			if mode < GameSettingsDevelopment.lowest_resolution then
				break
			end

			local str = tostring(mode) .. "x" .. tostring(var_185_7)

			tbl[#tbl + 1] = {
				text = str,
				value = {
					mode,
					var_185_7
				}
			}
		until true
	end

	local function fn(self, arg_186_1)
		-- function 186
		return arg_186_1.value[1] < self.value[1]
	end

	table.sort(tbl, fn)

	local num = 1

	for k = 1, #tbl do
		local var_185_11 = tbl[k]

		if not (var_185_11.value[1] ~= user_setting[1] or var_185_11.value[2] ~= user_setting[2]) then
			num = k

			break
		end
	end

	return num, tbl, "menu_settings_resolution"
end

OptionsView.cb_resolutions_saved_value = function (self, arg_187_1)
	-- function 187
	local options_values = arg_187_1.content.options_values
	local options_texts = arg_187_1.content.options_texts
	local var_187_2 = fn_2(self.changed_user_settings.screen_resolution, Application.user_setting("screen_resolution"))
	local num = 1

	for i = 1, #options_values do
		local var_187_4 = options_values[i]

		if not (var_187_4[1] ~= var_187_2[1] or var_187_4[2] ~= var_187_2[2]) then
			num = i

			break
		end
	end

	arg_187_1.content.current_selection = num

	local var_187_5 = fn_2(self.changed_user_settings.fullscreen, Application.user_setting("fullscreen"))
	local var_187_6 = fn_2(self.changed_user_settings.borderless_fullscreen, Application.user_setting("borderless_fullscreen"))

	if var_187_5 or not var_187_6 then
		arg_187_1.content.disabled = true
	else
		arg_187_1.content.disabled = false
	end
end

OptionsView.cb_resolutions = function (arg_188_0, arg_188_1)
	-- function 188
	local current_selection = arg_188_1.current_selection
	local var_188_1 = arg_188_1.options_values[current_selection]

	if not var_188_1 then
		arg_188_0.changed_user_settings.screen_resolution = table.clone(var_188_1)
	end
end

local mirror_array_inplace = table.mirror_array_inplace({
	0,
	30,
	60,
	90,
	120,
	144,
	165
})
local tbl_24 = {
	{
		value = 0,
		text = Localize("menu_settings_off")
	},
	{
		text = "30",
		value = 30
	},
	{
		text = "60",
		value = 60
	},
	{
		text = "90",
		value = 90
	},
	{
		text = "120",
		value = 120
	},
	{
		text = "144",
		value = 144
	},
	{
		text = "165",
		value = 165
	}
}

OptionsView.cb_lock_framerate_setup = function (arg_189_0)
	-- function 189
	local var_189_0 = tbl_24
	local var_189_1 = mirror_array_inplace[Application.user_setting("max_fps")]

	var_189_1 = var_189_1 or 1

	local var_189_2 = mirror_array_inplace[DefaultUserSettings.get("user_settings", "max_fps")]

	var_189_2 = var_189_2 or 1

	return var_189_1, var_189_0, "menu_settings_lock_framerate", var_189_2
end

OptionsView.cb_lock_framerate_saved_value = function (self, arg_190_1)
	-- function 190
	local _get_setting = self:_get_setting("user_settings", "max_fps")
	local content = arg_190_1.content
	local var_190_2 = mirror_array_inplace[_get_setting]

	var_190_2 = var_190_2 or 1
	content.current_selection = var_190_2
end

OptionsView.cb_lock_framerate = function (arg_191_0, arg_191_1)
	-- function 191
	local var_191_0 = arg_191_1.options_values[arg_191_1.current_selection]

	arg_191_0.changed_user_settings.max_fps = var_191_0
end

OptionsView.cb_max_stacking_frames_setup = function (arg_192_0)
	-- function 192
	local tbl = {
		{
			value = -1,
			text = Localize("menu_settings_auto")
		},
		{
			text = "1",
			value = 1
		},
		{
			text = "2",
			value = 2
		},
		{
			text = "3",
			value = 3
		},
		{
			text = "4",
			value = 4
		}
	}
	local get = DefaultUserSettings.get("user_settings", "max_stacking_frames")
	local var_192_2
	local num = 1
	local user_setting = Application.user_setting("max_stacking_frames")

	user_setting = user_setting or -1

	for i = 1, #tbl do
		if user_setting == tbl[i].value then
			num = i
		end

		if get == tbl[i].value then
			var_192_2 = i
		end
	end

	return num, tbl, "menu_settings_max_stacking_frames", var_192_2
end

OptionsView.cb_max_stacking_frames_saved_value = function (self, arg_193_1)
	-- function 193
	local options_values = arg_193_1.content.options_values
	local var_193_1
	local var_193_2 = fn_2(self.changed_user_settings.max_stacking_frames, Application.user_setting("max_stacking_frames"))

	var_193_2 = var_193_2 or -1

	for i = 1, #options_values do
		if var_193_2 == options_values[i] then
			var_193_1 = i

			break
		end
	end

	arg_193_1.content.current_selection = var_193_1
end

OptionsView.cb_max_stacking_frames = function (arg_194_0, arg_194_1)
	-- function 194
	arg_194_0.changed_user_settings.max_stacking_frames = arg_194_1.options_values[arg_194_1.current_selection]
end

OptionsView.cb_anti_aliasing_setup = function (arg_195_0)
	-- function 195
	local tbl = {
		{
			value = "none",
			text = Localize("menu_settings_none")
		},
		{
			value = "FXAA",
			text = Localize("menu_settings_fxaa")
		},
		{
			value = "TAA",
			text = Localize("menu_settings_taa")
		}
	}
	local user_setting = Application.user_setting("render_settings", "fxaa_enabled")
	local user_setting_2 = Application.user_setting("render_settings", "taa_enabled")
	local flag

	flag = not user_setting and 2 and not user_setting_2 or 3 and 1

	local get = DefaultUserSettings.get("render_settings", "fxaa_enabled")
	local get_2 = DefaultUserSettings.get("render_settings", "taa_enabled")
	local flag_2

	flag_2 = not get and 2 and not get_2 or 3 and 1

	return flag, tbl, "menu_settings_anti_aliasing", flag_2
end

OptionsView.cb_anti_aliasing_saved_value = function (self, arg_196_1)
	-- function 196
	local var_196_0 = fn_2(self.changed_render_settings.fxaa_enabled, Application.user_setting("render_settings", "fxaa_enabled"))
	local var_196_1 = fn_2(self.changed_render_settings.taa_enabled, Application.user_setting("render_settings", "taa_enabled"))
	local flag

	flag = not var_196_0 and 2 and not var_196_1 or 3 and 1
	arg_196_1.content.current_selection = flag
end

OptionsView.cb_anti_aliasing = function (self, arg_197_1, arg_197_2, arg_197_3)
	-- function 197
	local current_selection = arg_197_1.current_selection
	local var_197_1 = arg_197_1.options_values[current_selection]

	if var_197_1 == "FXAA" then
		self.changed_render_settings.fxaa_enabled = true
		self.changed_render_settings.taa_enabled = false
	elseif var_197_1 == "TAA" then
		self.changed_render_settings.fxaa_enabled = false
		self.changed_render_settings.taa_enabled = true
	else
		self.changed_render_settings.fxaa_enabled = false
		self.changed_render_settings.taa_enabled = false
	end

	if not arg_197_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_anti_aliasing_condition = function (self, arg_198_1, arg_198_2)
	-- function 198
	if not self:_get_setting("render_settings", "fsr_enabled") then
		self:_set_setting_override(arg_198_1, arg_198_2, "anti_aliasing", "TAA")
		self:_set_override_reason(arg_198_1, "settings_view_header_fidelityfx_super_resolution")

		arg_198_1.disabled = true
	elseif self:_get_setting("render_settings", "upscaling_mode") == "dlss" then
		self:_set_setting_override(arg_198_1, arg_198_2, "anti_aliasing", "none")
		self:_set_override_reason(arg_198_1, "menu_settings_dlss_super_resolution")

		arg_198_1.disabled = true
	elseif self:_get_setting("render_settings", "upscaling_mode") == "fsr2" then
		self:_set_setting_override(arg_198_1, arg_198_2, "anti_aliasing", "none")
		self:_set_override_reason(arg_198_1, "menu_settings_fsr2_enabled")

		arg_198_1.disabled = true
	else
		self:_restore_setting_override(arg_198_1, arg_198_2, "anti_aliasing")

		arg_198_1.disabled = false
	end
end

OptionsView.cb_gamma_setup = function (arg_199_0)
	-- function 199
	local num = 1.5
	local num_2 = 5
	local user_setting = Application.user_setting("render_settings", "gamma")

	user_setting = user_setting or 2.2

	local var_199_3 = fn(num, num_2, user_setting)
	local clamp = math.clamp(DefaultUserSettings.get("render_settings", "gamma"), num, num_2)

	Application.set_render_setting("gamma", user_setting)

	return var_199_3, num, num_2, 1, "menu_settings_gamma", clamp
end

OptionsView.cb_gamma_saved_value = function (self, arg_200_1)
	-- function 200
	local content = arg_200_1.content
	local min = content.min
	local max = content.max
	local var_200_3 = fn_2(self.changed_render_settings.gamma, Application.user_setting("render_settings", "gamma"))

	var_200_3 = var_200_3 or 2.2

	local clamp = math.clamp(var_200_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp

	Application.set_render_setting("gamma", content.value)
end

OptionsView.cb_gamma = function (arg_201_0, arg_201_1)
	-- function 201
	arg_201_0.changed_render_settings.gamma = arg_201_1.value

	Application.set_render_setting("gamma", arg_201_1.value)
end

OptionsView.cb_fsr_enabled_setup = function (arg_202_0)
	-- function 202
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "fsr_enabled")
	local get = DefaultUserSettings.get("render_settings", "fsr_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	if not IS_WINDOWS then
		local set_render_setting = Application.set_render_setting
		local str = "fsr_enabled"
		local var_202_7

		if not user_setting then
			var_202_7 = tostring(user_setting)

			if not var_202_7 then
				-- Nothing
			end
		end

		var_202_7 = tostring(get)

		::label_202_0::

		set_render_setting(str, var_202_7)
	end

	return flag, tbl, "settings_view_header_fidelityfx_super_resolution", flag_2
end

OptionsView.cb_fsr_enabled_saved_value = function (self, arg_203_1)
	-- function 203
	local flag

	flag = not fn_2(self.changed_render_settings.fsr_enabled, Application.user_setting("render_settings", "fsr_enabled")) and 2 and 1
	arg_203_1.content.current_selection = flag
end

OptionsView.cb_fsr_enabled = function (arg_204_0, arg_204_1, arg_204_2, arg_204_3)
	-- function 204
	local var_204_0 = arg_204_1.options_values[arg_204_1.current_selection]

	arg_204_0.changed_render_settings.fsr_enabled = var_204_0

	if not IS_WINDOWS then
		Application.set_render_setting("fsr_enabled", tostring(var_204_0))
	end
end

OptionsView.cb_fsr_enabled_condition = function (self, arg_205_1, arg_205_2)
	-- function 205
	if not self:_get_setting("user_settings", "dlss_enabled") then
		self:_set_setting_override(arg_205_1, arg_205_2, "fsr_enabled", false)
		self:_set_override_reason(arg_205_1, "menu_settings_dlss_enabled")

		arg_205_1.disabled = true
	elseif not self:_get_setting("user_settings", "fsr2_enabled") then
		self:_set_setting_override(arg_205_1, arg_205_2, "fsr_enabled", false)
		self:_set_override_reason(arg_205_1, "menu_settings_fsr2_enabled")

		arg_205_1.disabled = true
	else
		self:_restore_setting_override(arg_205_1, arg_205_2, "fsr_enabled")

		arg_205_1.disabled = false
	end
end

OptionsView.cb_fsr_quality_setup = function (arg_206_0)
	-- function 206
	local tbl = {
		{
			value = 1,
			text = Localize("menu_settings_performance")
		},
		{
			value = 2,
			text = Localize("menu_settings_balanced")
		},
		{
			value = 3,
			text = Localize("menu_settings_quality")
		},
		{
			value = 4,
			text = Localize("menu_settings_ultra_quality")
		}
	}
	local user_setting = Application.user_setting("render_settings", "fsr_quality")
	local get, var_206_3 = DefaultUserSettings.get("render_settings", "fsr_quality"), user_setting

	return var_206_3, tbl, "menu_settings_fsr_quality", get
end

OptionsView.cb_fsr_quality_saved_value = function (self, arg_207_1)
	-- function 207
	local var_207_0 = fn_2(self.changed_render_settings.fsr_quality, Application.user_setting("render_settings", "fsr_quality"))

	arg_207_1.content.current_selection = var_207_0
end

OptionsView.cb_fsr_quality = function (arg_208_0, arg_208_1, arg_208_2, arg_208_3)
	-- function 208
	local var_208_0 = arg_208_1.options_values[arg_208_1.current_selection]

	arg_208_0.changed_render_settings.fsr_quality = var_208_0

	if not IS_WINDOWS then
		Application.set_render_setting("fsr_quality", var_208_0)
	end
end

OptionsView.cb_fsr_quality_condition = function (self, arg_209_1, arg_209_2)
	-- function 209
	if not self:_get_setting("render_settings", "fsr_enabled") then
		self:_set_setting_override(arg_209_1, arg_209_2, "fsr_quality", arg_209_1.current_selection)
		self:_set_override_reason(arg_209_1, "settings_view_header_fidelityfx_super_resolution")

		arg_209_1.disabled = true
	else
		self:_restore_setting_override(arg_209_1, arg_209_2, "fsr_quality")

		arg_209_1.disabled = false
	end
end

OptionsView.cb_fsr2_enabled_setup = function (arg_210_0)
	-- function 210
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("fsr2_enabled")
	local get = DefaultUserSettings.get("user_settings", "fsr2_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_fsr2_enabled", flag_2
end

OptionsView.cb_fsr2_enabled_saved_value = function (self, arg_211_1)
	-- function 211
	local flag

	flag = not self:_get_setting("user_settings", "fsr2_enabled") and 2 and 1
	arg_211_1.content.current_selection = flag
end

OptionsView.cb_fsr2_enabled = function (arg_212_0, arg_212_1, arg_212_2, arg_212_3)
	-- function 212
	local var_212_0 = arg_212_1.options_values[arg_212_1.current_selection]

	arg_212_0.changed_user_settings.fsr2_enabled = var_212_0

	if not var_212_0 then
		arg_212_0.changed_render_settings.upscaling_enabled = true
		arg_212_0.changed_render_settings.upscaling_mode = "fsr2"
		arg_212_0.changed_render_settings.upscaling_quality = "quality"
	else
		arg_212_0.changed_render_settings.upscaling_enabled = false
		arg_212_0.changed_render_settings.upscaling_mode = "none"
		arg_212_0.changed_render_settings.upscaling_quality = "none"
	end
end

OptionsView.cb_fsr2_enabled_condition = function (self, arg_213_1, arg_213_2)
	-- function 213
	if not Application.render_caps("d3d12") then
		self:_set_setting_override(arg_213_1, arg_213_2, "fsr2_enabled", false)
		self:_set_override_reason(arg_213_1, "backend_err_playfab_unsupported_version", true)

		arg_213_1.disabled = true
	elseif not self:_get_setting("render_settings", "fsr2_enabled") then
		self:_set_setting_override(arg_213_1, arg_213_2, "fsr2_enabled", false)
		self:_set_override_reason(arg_213_1, "settings_view_header_fidelityfx_super_resolution")

		arg_213_1.disabled = true
	elseif not self:_get_setting("user_settings", "dlss_enabled") then
		self:_set_setting_override(arg_213_1, arg_213_2, "fsr2_enabled", false)
		self:_set_override_reason(arg_213_1, "menu_settings_dlss_enabled")

		arg_213_1.disabled = true
	else
		self:_restore_setting_override(arg_213_1, arg_213_2, "fsr2_enabled")

		arg_213_1.disabled = false
	end
end

local mirror_array_inplace_2 = table.mirror_array_inplace({
	"quality",
	"balanced",
	"performance",
	"ultra_performance"
})

OptionsView.cb_fsr2_quality_setup = function (self)
	-- function 214
	local tbl = {
		{
			value = "quality",
			text = Localize("menu_settings_quality")
		},
		{
			value = "balanced",
			text = Localize("menu_settings_balanced")
		},
		{
			value = "performance",
			text = Localize("menu_settings_performance")
		},
		{
			value = "ultra_performance",
			text = Localize("menu_settings_ultra_performance")
		}
	}
	local quality = mirror_array_inplace_2.quality
	local var_214_2 = quality

	if self:_get_setting("render_settings", "upscaling_mode") == "fsr2" then
		local _get_setting = self:_get_setting("render_settings", "upscaling_quality")

		var_214_2 = mirror_array_inplace_2[_get_setting] or var_214_2
	else
		local fsr2_quality = self.overriden_settings.fsr2_quality

		var_214_2 = mirror_array_inplace_2[fsr2_quality] or var_214_2
	end

	return var_214_2, tbl, "menu_settings_fsr2_quality", quality
end

OptionsView.cb_fsr2_quality_saved_value = function (self, arg_215_1)
	-- function 215
	local var_215_0

	if self:_get_setting("render_settings", "upscaling_mode") == "fsr2" then
		var_215_0 = self:_get_setting("render_settings", "upscaling_quality")
	else
		var_215_0 = self.overriden_settings.fsr2_quality
	end

	local content = arg_215_1.content
	local var_215_2 = mirror_array_inplace_2[var_215_0]

	var_215_2 = var_215_2 or 1
	content.current_selection = var_215_2
end

OptionsView.cb_fsr2_quality = function (self, arg_216_1, arg_216_2, arg_216_3)
	-- function 216
	local var_216_0 = arg_216_1.options_values[arg_216_1.current_selection]

	if not self:_get_setting("user_settings", "fsr2_enabled") then
		self.changed_render_settings.upscaling_quality = var_216_0
	end
end

OptionsView.cb_fsr2_quality_condition = function (self, arg_217_1, arg_217_2)
	-- function 217
	if not self:_get_setting("user_settings", "fsr2_enabled") then
		local var_217_0 = arg_217_1.options_values[arg_217_1.current_selection]

		self:_set_setting_override(arg_217_1, arg_217_2, "fsr2_quality", var_217_0)
		self:_set_override_reason(arg_217_1, "menu_settings_fsr2_enabled")

		arg_217_1.disabled = true
	else
		self:_restore_setting_override(arg_217_1, arg_217_2, "fsr2_quality")

		arg_217_1.disabled = false
	end
end

OptionsView.cb_dlss_enabled_setup = function (arg_218_0)
	-- function 218
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("dlss_enabled")
	local get = DefaultUserSettings.get("user_settings", "dlss_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_dlss_enabled", flag_2
end

OptionsView.cb_dlss_enabled_saved_value = function (self, arg_219_1)
	-- function 219
	local flag

	flag = not self:_get_setting("user_settings", "dlss_enabled") and 2 and 1
	arg_219_1.content.current_selection = flag
end

OptionsView.cb_dlss_enabled = function (arg_220_0, arg_220_1, arg_220_2, arg_220_3)
	-- function 220
	local var_220_0 = arg_220_1.options_values[arg_220_1.current_selection]

	arg_220_0.changed_user_settings.dlss_enabled = var_220_0
end

OptionsView.cb_dlss_enabled_condition = function (self, arg_221_1, arg_221_2)
	-- function 221
	if not self:_get_setting("render_settings", "fsr_enabled") then
		self:_set_setting_override(arg_221_1, arg_221_2, "dlss_enabled", false)
		self:_set_override_reason(arg_221_1, "settings_view_header_fidelityfx_super_resolution")

		arg_221_1.disabled = true
	elseif not self:_get_setting("user_settings", "fsr2_enabled") then
		self:_set_setting_override(arg_221_1, arg_221_2, "dlss_enabled", false)
		self:_set_override_reason(arg_221_1, "menu_settings_fsr2_enabled")

		arg_221_1.disabled = true
	else
		self:_restore_setting_override(arg_221_1, arg_221_2, "dlss_enabled")

		arg_221_1.disabled = false
	end
end

OptionsView.cb_dlss_frame_generation_setup = function (arg_222_0)
	-- function 222
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "dlss_g_enabled")
	local get = DefaultUserSettings.get("render_settings", "dlss_g_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_dlss_frame_generation", flag_2
end

OptionsView.cb_dlss_frame_generation_saved_value = function (self, arg_223_1)
	-- function 223
	local flag

	flag = not self:_get_setting("render_settings", "dlss_g_enabled") and 2 and 1
	arg_223_1.content.current_selection = flag
end

OptionsView.cb_dlss_frame_generation = function (arg_224_0, arg_224_1, arg_224_2, arg_224_3)
	-- function 224
	local var_224_0 = arg_224_1.options_values[arg_224_1.current_selection]

	arg_224_0.changed_render_settings.dlss_g_enabled = var_224_0
end

OptionsView.cb_dlss_frame_generation_condition = function (self, arg_225_1, arg_225_2)
	-- function 225
	if not Application.render_caps("dlss_g_supported") then
		self:_set_setting_override(arg_225_1, arg_225_2, "dlss_frame_generation", false)
		self:_set_override_reason(arg_225_1, "backend_err_playfab_unsupported_version", true)

		arg_225_1.disabled = true
	elseif not self:_get_setting("user_settings", "dlss_enabled") then
		self:_set_setting_override(arg_225_1, arg_225_2, "dlss_frame_generation", false)
		self:_set_override_reason(arg_225_1, "menu_settings_dlss_enabled")

		arg_225_1.disabled = true
	else
		self:_restore_setting_override(arg_225_1, arg_225_2, "dlss_frame_generation")

		arg_225_1.disabled = false
	end
end

local mirror_array_inplace_3 = table.mirror_array_inplace({
	"none",
	"auto",
	"quality",
	"balanced",
	"performance",
	"ultra_performance",
	"dlaa"
})

OptionsView.cb_dlss_super_resolution_setup = function (self)
	-- function 226
	local tbl = {
		{
			value = "none",
			text = Localize("menu_settings_off")
		},
		{
			value = "auto",
			text = Localize("menu_settings_auto")
		},
		{
			value = "quality",
			text = Localize("menu_settings_quality")
		},
		{
			value = "balanced",
			text = Localize("menu_settings_balanced")
		},
		{
			value = "performance",
			text = Localize("menu_settings_performance")
		},
		{
			value = "ultra_performance",
			text = Localize("menu_settings_ultra_performance")
		},
		{
			value = "dlaa",
			text = Localize("menu_settings_dlaa")
		}
	}
	local none = mirror_array_inplace_3.none
	local var_226_2

	if not self:_get_setting("user_settings", "dlss_enabled") then
		var_226_2 = self:_get_setting("render_settings", "upscaling_quality")
	else
		var_226_2 = "none"
	end

	local var_226_3 = mirror_array_inplace_3[var_226_2]

	var_226_3 = var_226_3 or selected_option

	return var_226_3, tbl, "menu_settings_dlss_super_resolution", none
end

OptionsView.cb_dlss_super_resolution_saved_value = function (self, arg_227_1)
	-- function 227
	local var_227_0

	if not self:_get_setting("user_settings", "dlss_enabled") then
		var_227_0 = self:_get_setting("render_settings", "upscaling_quality")
	else
		var_227_0 = "none"
	end

	local content = arg_227_1.content
	local var_227_2 = mirror_array_inplace_3[var_227_0]

	var_227_2 = var_227_2 or 1
	content.current_selection = var_227_2
end

OptionsView.cb_dlss_super_resolution = function (arg_228_0, arg_228_1, arg_228_2, arg_228_3)
	-- function 228
	local var_228_0 = arg_228_1.options_values[arg_228_1.current_selection]

	if var_228_0 == "none" then
		arg_228_0.changed_render_settings.upscaling_enabled = false
		arg_228_0.changed_render_settings.upscaling_mode = "none"
		arg_228_0.changed_render_settings.upscaling_quality = "none"
	else
		arg_228_0.changed_render_settings.upscaling_enabled = true
		arg_228_0.changed_render_settings.upscaling_mode = "dlss"
		arg_228_0.changed_render_settings.upscaling_quality = var_228_0
	end
end

OptionsView.cb_dlss_super_resolution_condition = function (self, arg_229_1, arg_229_2)
	-- function 229
	if not self:_get_setting("user_settings", "dlss_enabled") then
		self:_set_setting_override(arg_229_1, arg_229_2, "dlss_super_resolution", "none")
		self:_set_override_reason(arg_229_1, "menu_settings_dlss_enabled")

		arg_229_1.disabled = true
	else
		self:_restore_setting_override(arg_229_1, arg_229_2, "dlss_super_resolution")

		arg_229_1.disabled = false
	end
end

local function fn_4(arg_230_0, arg_230_1)
	-- function 230
	local flag

	flag = not arg_230_0 and not arg_230_1 and 3 and 2 or 1

	return flag
end

OptionsView.cb_reflex_low_latency_setup = function (arg_231_0)
	-- function 231
	local tbl = {
		{
			value = 1,
			text = Localize("menu_settings_off")
		},
		{
			value = 2,
			text = Localize("menu_settings_reflex_enabled")
		},
		{
			value = 3,
			text = Localize("menu_settings_reflex_boost")
		}
	}
	local var_231_1 = fn_4(Application.user_setting("render_settings", "nv_low_latency_mode"), Application.user_setting("render_settings", "nv_low_latency_boost"))
	local var_231_2 = fn_4(DefaultUserSettings.get("render_settings", "nv_low_latency_mode"), DefaultUserSettings.get("render_settings", "nv_low_latency_boost"))

	return var_231_1, tbl, "menu_settings_reflex_low_latency", var_231_2
end

OptionsView.cb_reflex_low_latency_saved_value = function (self, arg_232_1)
	-- function 232
	local _get_setting = self:_get_setting("render_settings", "nv_low_latency_mode")
	local _get_setting_2 = self:_get_setting("render_settings", "nv_low_latency_boost")

	arg_232_1.content.current_selection = fn_4(_get_setting, _get_setting_2)
end

OptionsView.cb_reflex_low_latency = function (self, arg_233_1, arg_233_2, arg_233_3, arg_233_4)
	-- function 233
	local var_233_0 = arg_233_1.options_values[arg_233_1.current_selection]
	local flag = false
	local flag_2 = false

	if var_233_0 == 2 then
		flag = true
	elseif var_233_0 == 3 then
		flag, flag_2 = true, true
	end

	self.changed_render_settings.nv_low_latency_mode = flag
	self.changed_render_settings.nv_low_latency_boost = flag_2

	if not arg_233_4 then
		self:_clear_setting_override(arg_233_1, arg_233_2, "reflex_low_latency")
	end
end

OptionsView.cb_reflex_low_latency_condition = function (self, arg_234_1, arg_234_2)
	-- function 234
	if not self:_get_setting("render_settings", "dlss_g_enabled") then
		if not (arg_234_1.current_selection == 1 or self.overriden_settings.reflex_low_latency ~= 1) then
			self:_set_setting_override(arg_234_1, arg_234_2, "reflex_low_latency", 2)
			self:_set_override_reason(arg_234_1, "menu_settings_dlss_frame_generation")
		end

		arg_234_1.list_content[1].hotspot.disabled = true
	else
		self:_restore_setting_override(arg_234_1, arg_234_2, "reflex_low_latency")

		arg_234_1.list_content[1].hotspot.disabled = false
	end
end

OptionsView.cb_reflex_framerate_cap_setup = function (arg_235_0)
	-- function 235
	local var_235_0 = tbl_24
	local var_235_1 = mirror_array_inplace[Application.user_setting("render_settings", "nv_framerate_cap")]

	var_235_1 = var_235_1 or 1

	local var_235_2 = mirror_array_inplace[DefaultUserSettings.get("render_settings", "nv_framerate_cap")]

	return var_235_1, var_235_0, "menu_settings_reflex_framerate_cap", var_235_2
end

OptionsView.cb_reflex_framerate_cap_saved_value = function (self, arg_236_1)
	-- function 236
	local _get_setting = self:_get_setting("render_settings", "nv_framerate_cap")
	local content = arg_236_1.content
	local var_236_2 = mirror_array_inplace[_get_setting]

	var_236_2 = var_236_2 or 1
	content.current_selection = var_236_2
end

OptionsView.cb_reflex_framerate_cap = function (arg_237_0, arg_237_1, arg_237_2, arg_237_3)
	-- function 237
	local var_237_0 = arg_237_1.options_values[arg_237_1.current_selection]

	arg_237_0.changed_render_settings.nv_framerate_cap = var_237_0
end

OptionsView.cb_sun_shadows_setup = function (arg_238_0)
	-- function 238
	local tbl = {
		{
			value = "off",
			text = Localize("menu_settings_off")
		},
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		},
		{
			value = "extreme",
			text = Localize("menu_settings_extreme")
		}
	}
	local user_setting = Application.user_setting("render_settings", "sun_shadows")
	local user_setting_2 = Application.user_setting("sun_shadow_quality")
	local var_238_3

	if not user_setting then
		if user_setting_2 == "low" then
			var_238_3 = 2
		elseif user_setting_2 == "medium" then
			var_238_3 = 3
		elseif user_setting_2 == "high" then
			var_238_3 = 4
		elseif user_setting_2 == "extreme" then
			var_238_3 = 5
		end
	else
		var_238_3 = 1
	end

	return var_238_3, tbl, "menu_settings_sun_shadows"
end

OptionsView.cb_sun_shadows_saved_value = function (self, arg_239_1)
	-- function 239
	local var_239_0 = fn_2(self.changed_render_settings.sun_shadows, Application.user_setting("render_settings", "sun_shadows"))
	local var_239_1 = fn_2(self.changed_user_settings.sun_shadow_quality, Application.user_setting("sun_shadow_quality"))
	local var_239_2

	if not var_239_0 then
		if var_239_1 == "low" then
			var_239_2 = 2
		elseif var_239_1 == "medium" then
			var_239_2 = 3
		elseif var_239_1 == "high" then
			var_239_2 = 4
		elseif var_239_1 == "extreme" then
			var_239_2 = 5
		end
	else
		var_239_2 = 1
	end

	arg_239_1.content.current_selection = var_239_2
end

OptionsView.cb_sun_shadows = function (self, arg_240_1, arg_240_2, arg_240_3)
	-- function 240
	local options_values = arg_240_1.options_values
	local current_selection = arg_240_1.current_selection
	local var_240_2
	local var_240_3 = options_values[current_selection]
	local str

	if var_240_3 == "off" then
		self.changed_render_settings.sun_shadows = false
		str = "low"
	else
		self.changed_render_settings.sun_shadows = true
		str = var_240_3
	end

	self.changed_user_settings.sun_shadow_quality = str

	local var_240_5 = SunShadowQuality[str]

	for k, v in pairs(var_240_5) do
		self.changed_render_settings[k] = v
	end

	if not arg_240_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_lod_quality_setup = function (arg_241_0)
	-- function 241
	local tbl = {
		{
			value = 0.6,
			text = Localize("menu_settings_low")
		},
		{
			value = 0.8,
			text = Localize("menu_settings_medium")
		},
		{
			value = 1,
			text = Localize("menu_settings_high")
		}
	}
	local get = DefaultUserSettings.get("render_settings", "lod_object_multiplier")
	local var_241_2
	local user_setting = Application.user_setting("render_settings", "lod_object_multiplier")

	user_setting = user_setting or 1

	local num = 1

	for i = 1, #tbl do
		if user_setting == tbl[i].value then
			num = i
		end

		if get == tbl[i].value then
			var_241_2 = i
		end
	end

	return num, tbl, "menu_settings_lod_quality", var_241_2
end

OptionsView.cb_lod_quality_saved_value = function (self, arg_242_1)
	-- function 242
	local options_values = arg_242_1.content.options_values
	local num = 1
	local var_242_2 = fn_2(self.changed_render_settings.lod_object_multiplier, Application.user_setting("render_settings", "lod_object_multiplier"))

	var_242_2 = var_242_2 or 1

	for i = 1, #options_values do
		if var_242_2 == options_values[i] then
			num = i

			break
		end
	end

	arg_242_1.content.current_selection = num
end

OptionsView.cb_lod_quality = function (arg_243_0, arg_243_1)
	-- function 243
	local var_243_0 = arg_243_1.options_values[arg_243_1.current_selection]

	var_243_0 = var_243_0 or 1
	arg_243_0.changed_render_settings.lod_object_multiplier = var_243_0
end

OptionsView.cb_scatter_density_setup = function (arg_244_0)
	-- function 244
	local tbl = {
		{
			value = 0,
			text = Localize("menu_settings_off")
		},
		{
			text = "25%",
			value = 0.25
		},
		{
			text = "50%",
			value = 0.5
		},
		{
			text = "75%",
			value = 0.75
		},
		{
			text = "100%",
			value = 1
		}
	}
	local get = DefaultUserSettings.get("render_settings", "lod_scatter_density")
	local var_244_2
	local user_setting = Application.user_setting("render_settings", "lod_scatter_density")

	user_setting = user_setting or 1

	local num = 1

	for i = 1, #tbl do
		if user_setting == tbl[i].value then
			num = i
		end

		if get == tbl[i].value then
			var_244_2 = i
		end
	end

	return num, tbl, "menu_settings_scatter_density", var_244_2
end

OptionsView.cb_scatter_density_saved_value = function (self, arg_245_1)
	-- function 245
	local options_values = arg_245_1.content.options_values
	local num = 1
	local var_245_2 = fn_2(self.changed_render_settings.lod_scatter_density, Application.user_setting("render_settings", "lod_scatter_density"))

	var_245_2 = var_245_2 or 1

	for i = 1, #options_values do
		if var_245_2 == options_values[i] then
			num = i

			break
		end
	end

	arg_245_1.content.current_selection = num
end

OptionsView.cb_scatter_density = function (self, arg_246_1, arg_246_2, arg_246_3)
	-- function 246
	local var_246_0 = arg_246_1.options_values[arg_246_1.current_selection]

	var_246_0 = var_246_0 or 1
	self.changed_render_settings.lod_scatter_density = var_246_0

	if not arg_246_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_decoration_density_setup = function (arg_247_0)
	-- function 247
	local tbl = {
		{
			value = 0,
			text = Localize("menu_settings_off")
		},
		{
			text = "25%",
			value = 0.25
		},
		{
			text = "50%",
			value = 0.5
		},
		{
			text = "75%",
			value = 0.75
		},
		{
			text = "100%",
			value = 1
		}
	}
	local user_setting = Application.user_setting("render_settings", "lod_decoration_density")

	user_setting = user_setting or 1

	local num = 1

	for i = 1, #tbl do
		if user_setting == tbl[i].value then
			num = i

			break
		end
	end

	return num, tbl, "menu_settings_decoration_density"
end

OptionsView.cb_decoration_density_saved_value = function (self, arg_248_1)
	-- function 248
	local options_values = arg_248_1.content.options_values
	local num = 1
	local var_248_2 = fn_2(self.changed_render_settings.lod_decoration_density, Application.user_setting("render_settings", "lod_decoration_density"))

	var_248_2 = var_248_2 or 1

	for i = 1, #options_values do
		if var_248_2 == options_values[i] then
			num = i

			break
		end
	end

	arg_248_1.content.current_selection = num
end

OptionsView.cb_decoration_density = function (arg_249_0, arg_249_1)
	-- function 249
	local var_249_0 = arg_249_1.options_values[arg_249_1.current_selection]

	var_249_0 = var_249_0 or 1
	arg_249_0.changed_render_settings.lod_decoration_density = var_249_0
end

OptionsView.cb_maximum_shadow_casting_lights_setup = function (arg_250_0)
	-- function 250
	local num = 1
	local num_2 = 10
	local user_setting = Application.user_setting("render_settings", "max_shadow_casting_lights")

	return fn(num, num_2, user_setting), num, num_2, 0, "menu_settings_maximum_shadow_casting_lights"
end

OptionsView.cb_maximum_shadow_casting_lights_saved_value = function (self, arg_251_1)
	-- function 251
	local content = arg_251_1.content
	local min = content.min
	local max = content.max
	local var_251_3 = fn_2(self.changed_render_settings.max_shadow_casting_lights, Application.user_setting("render_settings", "max_shadow_casting_lights"))
	local clamp = math.clamp(var_251_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_maximum_shadow_casting_lights = function (self, arg_252_1, arg_252_2, arg_252_3)
	-- function 252
	self.changed_render_settings.max_shadow_casting_lights = arg_252_1.value

	print("max_shadow_casting_lights", arg_252_1.value)

	if not arg_252_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_local_light_shadow_quality_setup = function (arg_253_0)
	-- function 253
	local tbl = {
		{
			value = "off",
			text = Localize("menu_settings_off")
		},
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		},
		{
			value = "extreme",
			text = Localize("menu_settings_extreme")
		}
	}
	local user_setting = Application.user_setting("local_light_shadow_quality")
	local user_setting_2 = Application.user_setting("render_settings", "deferred_local_lights_cast_shadows")
	local user_setting_3 = Application.user_setting("render_settings", "forward_local_lights_cast_shadows")
	local var_253_4

	if not (not user_setting_2 and user_setting_3) then
		var_253_4 = 1
	elseif user_setting == "low" then
		var_253_4 = 2
	elseif user_setting == "medium" then
		var_253_4 = 3
	elseif user_setting == "high" then
		var_253_4 = 4
	elseif user_setting == "extreme" then
		var_253_4 = 5
	end

	return var_253_4, tbl, "menu_settings_local_light_shadow_quality"
end

OptionsView.cb_local_light_shadow_quality_saved_value = function (self, arg_254_1)
	-- function 254
	local var_254_0 = fn_2(self.changed_user_settings.local_light_shadow_quality, Application.user_setting("local_light_shadow_quality"))
	local var_254_1 = fn_2(self.changed_render_settings.deferred_local_lights_cast_shadows, Application.user_setting("render_settings", "deferred_local_lights_cast_shadows"))
	local var_254_2 = fn_2(self.changed_render_settings.forward_local_lights_cast_shadows, Application.user_setting("render_settings", "forward_local_lights_cast_shadows"))
	local var_254_3

	if not (not var_254_1 and var_254_2) then
		var_254_3 = 1
	elseif var_254_0 == "low" then
		var_254_3 = 2
	elseif var_254_0 == "medium" then
		var_254_3 = 3
	elseif var_254_0 == "high" then
		var_254_3 = 4
	elseif var_254_0 == "extreme" then
		var_254_3 = 5
	end

	arg_254_1.content.current_selection = var_254_3
end

OptionsView.cb_local_light_shadow_quality = function (self, arg_255_1, arg_255_2, arg_255_3)
	-- function 255
	local var_255_0 = arg_255_1.options_values[arg_255_1.current_selection]
	local var_255_1
	local str

	if var_255_0 == "off" then
		self.changed_render_settings.deferred_local_lights_cast_shadows = false
		self.changed_render_settings.forward_local_lights_cast_shadows = false
		str = "low"
	else
		self.changed_render_settings.deferred_local_lights_cast_shadows = true
		self.changed_render_settings.forward_local_lights_cast_shadows = true
		str = var_255_0
	end

	self.changed_user_settings.local_light_shadow_quality = str

	local var_255_3 = LocalLightShadowQuality[str]

	for k, v in pairs(var_255_3) do
		self.changed_render_settings[k] = v
	end

	if not arg_255_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_motion_blur_setup = function (arg_256_0)
	-- function 256
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "motion_blur_enabled")

	if user_setting == nil then
		user_setting = true
	end

	local get = DefaultUserSettings.get("render_settings", "motion_blur_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	if not IS_WINDOWS then
		Application.set_render_setting("motion_blur_enabled", tostring(user_setting))
	end

	return flag, tbl, "menu_settings_motion_blur", flag_2
end

OptionsView.cb_motion_blur_saved_value = function (self, arg_257_1)
	-- function 257
	local flag

	flag = not fn_2(self.changed_render_settings.motion_blur_enabled, Application.user_setting("render_settings", "motion_blur_enabled")) and 2 and 1
	arg_257_1.content.current_selection = flag
end

OptionsView.cb_motion_blur = function (self, arg_258_1, arg_258_2, arg_258_3)
	-- function 258
	local var_258_0 = arg_258_1.options_values[arg_258_1.current_selection]

	self.changed_render_settings.motion_blur_enabled = var_258_0

	if not (not IS_WINDOWS and arg_258_3) then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	elseif not IS_WINDOWS then
		Application.set_render_setting("motion_blur_enabled", tostring(var_258_0))
	end
end

OptionsView.cb_dof_setup = function (arg_259_0)
	-- function 259
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local flag

	flag = not Application.user_setting("render_settings", "dof_enabled") and 2 and 1

	return flag, tbl, "menu_settings_dof"
end

OptionsView.cb_dof_saved_value = function (self, arg_260_1)
	-- function 260
	local flag

	flag = not fn_2(self.changed_render_settings.dof_enabled, Application.user_setting("render_settings", "dof_enabled")) and 2 and 1
	arg_260_1.content.current_selection = flag
end

OptionsView.cb_dof = function (self, arg_261_1, arg_261_2, arg_261_3)
	-- function 261
	local var_261_0 = arg_261_1.options_values[arg_261_1.current_selection]

	self.changed_render_settings.dof_enabled = var_261_0

	if not arg_261_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_bloom_setup = function (arg_262_0)
	-- function 262
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "bloom_enabled")

	user_setting = user_setting or false

	local get = DefaultUserSettings.get("render_settings", "bloom_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_bloom", flag_2
end

OptionsView.cb_bloom_saved_value = function (self, arg_263_1)
	-- function 263
	local var_263_0 = fn_2(self.changed_render_settings.bloom_enabled, Application.user_setting("render_settings", "bloom_enabled"))

	var_263_0 = var_263_0 or false

	local content = arg_263_1.content
	local flag

	flag = not var_263_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_bloom = function (self, arg_264_1, arg_264_2, arg_264_3)
	-- function 264
	local options_values = arg_264_1.options_values
	local current_selection = arg_264_1.current_selection

	self.changed_render_settings.bloom_enabled = options_values[current_selection]

	if not arg_264_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_light_shafts_setup = function (arg_265_0)
	-- function 265
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "light_shafts_enabled")

	user_setting = user_setting or false

	local get = DefaultUserSettings.get("render_settings", "light_shafts_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_light_shafts", flag_2
end

OptionsView.cb_light_shafts_saved_value = function (self, arg_266_1)
	-- function 266
	local var_266_0 = fn_2(self.changed_render_settings.light_shafts_enabled, Application.user_setting("render_settings", "light_shafts_enabled"))

	var_266_0 = var_266_0 or false

	local content = arg_266_1.content
	local flag

	flag = not var_266_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_light_shafts = function (self, arg_267_1, arg_267_2, arg_267_3)
	-- function 267
	local options_values = arg_267_1.options_values
	local current_selection = arg_267_1.current_selection

	self.changed_render_settings.light_shafts_enabled = options_values[current_selection]

	if not arg_267_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_sun_flare_setup = function (arg_268_0)
	-- function 268
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "sun_flare_enabled")

	user_setting = user_setting or false

	local get = DefaultUserSettings.get("render_settings", "sun_flare_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_sun_flare", flag_2
end

OptionsView.cb_sun_flare_saved_value = function (self, arg_269_1)
	-- function 269
	local var_269_0 = fn_2(self.changed_render_settings.sun_flare_enabled, Application.user_setting("render_settings", "sun_flare_enabled"))

	var_269_0 = var_269_0 or false

	local content = arg_269_1.content
	local flag

	flag = not var_269_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_sun_flare = function (self, arg_270_1, arg_270_2, arg_270_3)
	-- function 270
	local options_values = arg_270_1.options_values
	local current_selection = arg_270_1.current_selection

	self.changed_render_settings.sun_flare_enabled = options_values[current_selection]

	if not arg_270_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_sharpen_setup = function (arg_271_0)
	-- function 271
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "sharpen_enabled")

	user_setting = user_setting or false

	local get = DefaultUserSettings.get("render_settings", "sharpen_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_sharpen", flag_2
end

OptionsView.cb_sharpen_saved_value = function (self, arg_272_1)
	-- function 272
	local var_272_0 = fn_2(self.changed_render_settings.sharpen_enabled, Application.user_setting("render_settings", "sharpen_enabled"))

	var_272_0 = var_272_0 or false

	local content = arg_272_1.content
	local flag

	flag = not var_272_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_sharpen = function (self, arg_273_1, arg_273_2, arg_273_3)
	-- function 273
	local var_273_0 = arg_273_1.options_values[arg_273_1.current_selection]

	self.changed_render_settings.sharpen_enabled = var_273_0

	if not arg_273_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_sharpen_condition = function (arg_274_0, arg_274_1, arg_274_2)
	-- function 274
	return
end

OptionsView.cb_lens_quality_setup = function (arg_275_0)
	-- function 275
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "lens_quality_enabled")

	user_setting = user_setting or false

	local get = DefaultUserSettings.get("render_settings", "lens_quality_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_lens_quality", flag_2
end

OptionsView.cb_lens_quality_saved_value = function (self, arg_276_1)
	-- function 276
	local var_276_0 = fn_2(self.changed_render_settings.lens_quality_enabled, Application.user_setting("render_settings", "lens_quality_enabled"))

	var_276_0 = var_276_0 or false

	local content = arg_276_1.content
	local flag

	flag = not var_276_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_lens_quality = function (self, arg_277_1, arg_277_2, arg_277_3)
	-- function 277
	local options_values = arg_277_1.options_values
	local current_selection = arg_277_1.current_selection

	self.changed_render_settings.lens_quality_enabled = options_values[current_selection]

	if not arg_277_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_skin_shading_setup = function (arg_278_0)
	-- function 278
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "skin_material_enabled")

	user_setting = user_setting or false

	local get = DefaultUserSettings.get("render_settings", "skin_material_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_skin_shading", flag_2
end

OptionsView.cb_skin_shading_saved_value = function (self, arg_279_1)
	-- function 279
	local var_279_0 = fn_2(self.changed_render_settings.skin_material_enabled, Application.user_setting("render_settings", "skin_material_enabled"))

	var_279_0 = var_279_0 or false

	local content = arg_279_1.content
	local flag

	flag = not var_279_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_skin_shading = function (self, arg_280_1, arg_280_2, arg_280_3)
	-- function 280
	local options_values = arg_280_1.options_values
	local current_selection = arg_280_1.current_selection

	self.changed_render_settings.skin_material_enabled = options_values[current_selection]

	if not arg_280_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_ssao_setup = function (arg_281_0)
	-- function 281
	local tbl = {
		{
			value = "off",
			text = Localize("menu_settings_off")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		},
		{
			value = "extreme",
			text = Localize("menu_settings_extreme")
		}
	}
	local user_setting = Application.user_setting("ao_quality")
	local get = DefaultUserSettings.get("user_settings", "ao_quality")
	local num = 1
	local var_281_4

	for i = 1, #tbl do
		if tbl[i].value == user_setting then
			num = i
		end

		if get == tbl[i].value then
			var_281_4 = i
		end
	end

	return num, tbl, "menu_settings_ssao", var_281_4
end

OptionsView.cb_ssao_saved_value = function (self, arg_282_1)
	-- function 282
	local var_282_0 = fn_2(self.changed_user_settings.ao_quality, Application.user_setting("ao_quality"))
	local options_values = arg_282_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_282_0 == options_values[i] then
			num = i
		end
	end

	arg_282_1.content.current_selection = num
end

OptionsView.cb_ssao = function (self, arg_283_1, arg_283_2, arg_283_3)
	-- function 283
	local var_283_0 = arg_283_1.options_values[arg_283_1.current_selection]

	self.changed_user_settings.ao_quality = var_283_0

	local var_283_1 = AmbientOcclusionQuality[var_283_0]

	for k, v in pairs(var_283_1) do
		self.changed_render_settings[k] = v
	end

	if not arg_283_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_char_texture_quality_setup = function (arg_284_0)
	-- function 284
	local tbl = {
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		}
	}
	local user_setting = Application.user_setting("char_texture_quality")
	local get = DefaultUserSettings.get("user_settings", "char_texture_quality")
	local num = 1
	local var_284_4

	for i = 1, #tbl do
		if user_setting == tbl[i].value then
			num = i
		end

		if get == tbl[i].value then
			var_284_4 = i
		end
	end

	return num, tbl, "menu_settings_char_texture_quality", var_284_4
end

OptionsView.cb_char_texture_quality_saved_value = function (self, arg_285_1)
	-- function 285
	local var_285_0 = fn_2(self.changed_user_settings.char_texture_quality, Application.user_setting("char_texture_quality"))
	local options_values = arg_285_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_285_0 == options_values[i] then
			num = i
		end
	end

	arg_285_1.content.current_selection = num

	print("OptionsView:cb_char_texture_quality_saved_value", num, var_285_0)
end

OptionsView.cb_char_texture_quality = function (self, arg_286_1, arg_286_2, arg_286_3)
	-- function 286
	local var_286_0 = arg_286_1.options_values[arg_286_1.current_selection]

	self.changed_user_settings.char_texture_quality = var_286_0

	if not arg_286_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_env_texture_quality_setup = function (arg_287_0)
	-- function 287
	local tbl = {
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		}
	}
	local user_setting = Application.user_setting("env_texture_quality")
	local get = DefaultUserSettings.get("user_settings", "env_texture_quality")
	local num = 1
	local var_287_4

	for i = 1, #tbl do
		if user_setting == tbl[i].value then
			num = i
		end

		if get == tbl[i].value then
			var_287_4 = i
		end
	end

	return num, tbl, "menu_settings_env_texture_quality", var_287_4
end

OptionsView.cb_env_texture_quality_saved_value = function (self, arg_288_1)
	-- function 288
	local var_288_0 = fn_2(self.changed_user_settings.env_texture_quality, Application.user_setting("env_texture_quality"))
	local options_values = arg_288_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_288_0 == options_values[i] then
			num = i
		end
	end

	arg_288_1.content.current_selection = num

	print("OptionsView:cb_env_texture_quality_saved_value", num, var_288_0)
end

OptionsView.cb_env_texture_quality = function (self, arg_289_1, arg_289_2, arg_289_3)
	-- function 289
	local var_289_0 = arg_289_1.options_values[arg_289_1.current_selection]

	self.changed_user_settings.env_texture_quality = var_289_0

	if not arg_289_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_subtitles_setup = function (arg_290_0)
	-- function 290
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("use_subtitles")

	user_setting = user_setting or false

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "use_subtitles") and 2 and 1

	return flag, tbl, "menu_settings_subtitles", flag_2
end

OptionsView.cb_subtitles_saved_value = function (self, arg_291_1)
	-- function 291
	local var_291_0 = fn_2(self.changed_user_settings.use_subtitles, Application.user_setting("use_subtitles"))

	var_291_0 = var_291_0 or false

	local content = arg_291_1.content
	local flag

	flag = not var_291_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_subtitles = function (arg_292_0, arg_292_1)
	-- function 292
	local options_values = arg_292_1.options_values
	local current_selection = arg_292_1.current_selection

	arg_292_0.changed_user_settings.use_subtitles = options_values[current_selection]
end

OptionsView.cb_language_setup = function (arg_293_0)
	-- function 293
	local tbl = {
		{
			value = "en",
			text = Localize("english")
		},
		{
			value = "fr",
			text = Localize("french")
		},
		{
			value = "pl",
			text = Localize("polish")
		},
		{
			value = "es",
			text = Localize("spanish")
		},
		{
			value = "tr",
			text = Localize("turkish")
		},
		{
			value = "de",
			text = Localize("german")
		},
		{
			value = "br-pt",
			text = Localize("brazilian")
		},
		{
			value = "ru",
			text = Localize("russian")
		}
	}
	local user_setting = Application.user_setting("language_id")

	if not user_setting then
		if not rawget(_G, "Steam") then
			user_setting = Steam.language()

			if not user_setting then
				-- Nothing
			end
		end

		user_setting = "en"
	end

	::label_293_0::

	local get = DefaultUserSettings.get("user_settings", "language_id")

	get = get or "en"

	local num = 1

	for i, v in ipairs(tbl) do
		if v.value == user_setting then
			num = i
		end

		if v.value == get then
			get = i
		end
	end

	return num, tbl, "menu_settings_language", get
end

OptionsView.cb_language_saved_value = function (self, arg_294_1)
	-- function 294
	local var_294_0 = fn_2(self.changed_user_settings.language_id, Application.user_setting("language_id"))

	var_294_0 = var_294_0 or "en"

	local options_values = arg_294_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_294_0 == options_values[i] then
			num = i
		end
	end

	arg_294_1.content.current_selection = num
end

OptionsView.cb_language = function (arg_295_0, arg_295_1)
	-- function 295
	local options_values = arg_295_1.options_values
	local current_selection = arg_295_1.current_selection

	arg_295_0.changed_user_settings.language_id = options_values[current_selection]
end

OptionsView.reload_language = function (arg_296_0, arg_296_1)
	-- function 296
	if not Managers.package:has_loaded("resource_packages/strings", "boot") then
		Managers.package:unload("resource_packages/strings", "boot")
	end

	if arg_296_1 == "en" then
		Application.set_resource_property_preference_order("en")
	else
		Application.set_resource_property_preference_order(arg_296_1, "en")
	end

	Managers.package:load("resource_packages/strings", "boot")

	Managers.localizer = LocalizationManager:new(arg_296_1)

	local function fn(arg_297_0)
		-- function 297
		local var_297_0 = LocalizerTweakData[arg_297_0]

		var_297_0 = var_297_0 or "<missing LocalizerTweakData \"" .. arg_297_0 .. "\">"

		return var_297_0
	end

	Managers.localizer:add_macro("TWEAK", fn)

	local function fn_2(arg_298_0)
		-- function 298
		local find, var_298_1 = string.find(arg_298_0, "__")

		assert(not find and var_298_1, "[key_parser] You need to specify a key using this format $KEY;<input_service>__<key>. Example: $KEY;options_menu__back (note the dubbel underline separating input service and key")

		local sub = string.sub(arg_298_0, 1, find - 1)
		local sub_2 = string.sub(arg_298_0, var_298_1 + 1)
		local get_service = Managers.input:get_service(sub)

		fassert(get_service, "[key_parser] No input service with the name %s", sub)

		local get_keymapping = get_service:get_keymapping(sub_2)

		fassert(get_keymapping, "[key_parser] There is no such key: %s in input service: %s", sub_2, sub)

		local get_most_recent_device = Managers.input:get_most_recent_device()
		local get_device_type = InputAux.get_device_type(get_most_recent_device)
		local var_298_8

		for i, v in ipairs(get_keymapping.input_mappings) do
			if v[1] == get_device_type then
				var_298_8 = v[2]

				break
			end
		end

		local var_298_9

		if not var_298_8 then
			var_298_9 = get_most_recent_device.button_name(var_298_8)
			var_298_9 = get_device_type ~= "keyboard" or not get_most_recent_device.button_locale_name(var_298_8) or var_298_9

			if get_device_type == "mouse" then
				var_298_9 = string.format("%s %s", "mouse", var_298_9)
			end
		else
			local var_298_10
			local str = "keyboard"

			for i_2, v_2 in ipairs(get_keymapping.input_mappings) do
				if v_2[1] == str then
					var_298_10 = v_2[2]

					break
				end
			end

			if not var_298_10 then
				var_298_9 = Keyboard.button_name(var_298_10)
				var_298_9 = Keyboard.button_locale_name(var_298_10) or var_298_9
			else
				var_298_9 = Localize(unassigned_keymap)
			end
		end

		return var_298_9
	end

	Managers.localizer:add_macro("KEY", fn_2)
end

OptionsView.cb_mouse_look_sensitivity_setup = function (arg_299_0)
	-- function 299
	local num = -10
	local num_2 = 10
	local user_setting = Application.user_setting("mouse_look_sensitivity")

	user_setting = user_setting or 0

	local get = DefaultUserSettings.get("user_settings", "mouse_look_sensitivity")
	local var_299_4 = fn(num, num_2, user_setting)
	local str = "win32"
	local multiplier = InputUtils.get_platform_filters(PlayerControllerFilters, str).look.multiplier

	arg_299_0.input_manager:get_service("Player"):get_active_filters(str).look.function_data.multiplier = multiplier * 0.85^-user_setting

	return var_299_4, num, num_2, 1, "menu_settings_mouse_look_sensitivity", get
end

OptionsView.cb_mouse_look_sensitivity_saved_value = function (self, arg_300_1)
	-- function 300
	local content = arg_300_1.content
	local min = content.min
	local max = content.max
	local var_300_3 = fn_2(self.changed_user_settings.mouse_look_sensitivity, Application.user_setting("mouse_look_sensitivity"))

	var_300_3 = var_300_3 or 0

	local clamp = math.clamp(var_300_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_mouse_look_sensitivity = function (arg_301_0, arg_301_1)
	-- function 301
	arg_301_0.changed_user_settings.mouse_look_sensitivity = arg_301_1.value
end

OptionsView.cb_hud_scale_setup = function (arg_302_0)
	-- function 302
	local num = 50
	local num_2 = 100
	local user_setting = Application.user_setting("hud_scale")

	user_setting = user_setting or 100

	local var_302_3 = fn(num, num_2, user_setting)
	local clamp = math.clamp(DefaultUserSettings.get("user_settings", "hud_scale"), num, num_2)

	return var_302_3, num, num_2, 0, "settings_menu_hud_scale", clamp
end

OptionsView.cb_hud_scale_saved_value = function (self, arg_303_1)
	-- function 303
	local content = arg_303_1.content
	local min = content.min
	local max = content.max
	local var_303_3 = fn_2(self.changed_user_settings.hud_scale, Application.user_setting("hud_scale"))

	var_303_3 = var_303_3 or 100

	local clamp = math.clamp(var_303_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp

	local user_setting = Application.user_setting("use_custom_hud_scale")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "use_custom_hud_scale")
	content.disabled = not user_setting
end

OptionsView.cb_hud_scale = function (self, arg_304_1)
	-- function 304
	local value = arg_304_1.value

	self.changed_user_settings.hud_scale = value
	UISettings.hud_scale = value

	local flag = true

	UPDATE_RESOLUTION_LOOKUP(flag)
	self:_setup_text_buttons_width()
end

OptionsView.cb_safe_rect_setup = function (arg_305_0)
	-- function 305
	local resolution, var_305_1 = Gui.resolution()
	local num = 0
	local num_2 = 20
	local user_setting = Application.user_setting("safe_rect")

	user_setting = user_setting or num

	local var_305_5 = fn(num, num_2, user_setting)
	local clamp = math.clamp(DefaultUserSettings.get("user_settings", "safe_rect"), num, num_2)

	return var_305_5, num, num_2, 0, "settings_menu_hud_safe_rect", clamp
end

OptionsView.cb_safe_rect_saved_value = function (self, arg_306_1)
	-- function 306
	local resolution, var_306_1 = Gui.resolution()
	local num = 0
	local num_2 = 20

	if not IS_PS4 then
		local num_3 = 5
	end

	local content = arg_306_1.content
	local min = content.min
	local max = content.max
	local var_306_8 = fn_2(self.changed_user_settings.safe_rect, Application.user_setting("safe_rect"))

	var_306_8 = var_306_8 or min

	local clamp = math.clamp(var_306_8, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_safe_rect = function (self, arg_307_1)
	-- function 307
	local num_2 = 0
	local num_3 = 20

	if not IS_PS4 then
		num_2 = 5
	end

	local value = arg_307_1.value
	local user_setting = Application.user_setting("safe_rect")

	user_setting = user_setting or num_2
	self.changed_user_settings.safe_rect = value

	Application.set_user_setting("safe_rect", value)

	if value ~= user_setting then
		self.safe_rect_alpha_timer = num
	end
end

OptionsView.cb_gamepad_look_sensitivity_setup = function (self)
	-- function 308
	local num = -10
	local num_2 = 10
	local user_setting = Application.user_setting("gamepad_look_sensitivity")

	user_setting = user_setting or 0

	local get = DefaultUserSettings.get("user_settings", "gamepad_look_sensitivity")
	local var_308_4 = fn(num, num_2, user_setting)
	local clamp = math.clamp(user_setting, num, num_2)

	table.clear(tbl_21)

	local var_308_6 = tbl_21
	local num_3 = #tbl_21 + 1
	local flag

	flag = not IS_WINDOWS and "xb1" and self.platform
	var_308_6[num_3] = flag

	local var_308_9 = tbl_21
	local num_4 = #tbl_21 + 1
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and "ps_pad"
	var_308_9[num_4] = IS_WINDOWS

	for i = 1, #tbl_21 do
		local var_308_12 = tbl_21[i]
		local get_platform_filters = InputUtils.get_platform_filters(PlayerControllerFilters, var_308_12)
		local multiplier_x = get_platform_filters.look_controller.multiplier_x
		local multiplier_x_2 = get_platform_filters.look_controller_melee.multiplier_x
		local multiplier_x_3 = get_platform_filters.look_controller_ranged.multiplier_x
		local get_active_filters = self.input_manager:get_service("Player"):get_active_filters(var_308_12)
		local function_data = get_active_filters.look_controller.function_data

		function_data.multiplier_x = multiplier_x * 0.85^-clamp

		local num_5

		if not get_platform_filters.look_controller.multiplier_min_x then
			num_5 = get_platform_filters.look_controller.multiplier_min_x * 0.85^-clamp

			if not num_5 then
				-- Nothing
			end
		end

		num_5 = function_data.multiplier_x * 0.25

		::label_308_0::

		function_data.min_multiplier_x = num_5

		local function_data_2 = get_active_filters.look_controller_melee.function_data

		function_data_2.multiplier_x = multiplier_x_2 * 0.85^-clamp

		local num_6

		if not get_platform_filters.look_controller_melee.multiplier_min_x then
			num_6 = get_platform_filters.look_controller_melee.multiplier_min_x * 0.85^-clamp

			if not num_6 then
				-- Nothing
			end
		end

		num_6 = function_data_2.multiplier_x * 0.25

		::label_308_1::

		function_data_2.min_multiplier_x = num_6

		local function_data_3 = get_active_filters.look_controller_ranged.function_data

		function_data_3.multiplier_x = multiplier_x_3 * 0.85^-clamp

		local num_7

		if not get_platform_filters.look_controller_ranged.multiplier_min_x then
			num_7 = get_platform_filters.look_controller_ranged.multiplier_min_x * 0.85^-clamp

			if not num_7 then
				-- Nothing
			end
		end

		num_7 = function_data_3.multiplier_x * 0.25

		::label_308_2::

		function_data_3.min_multiplier_x = num_7
	end

	return var_308_4, num, num_2, 1, "menu_settings_gamepad_look_sensitivity", get
end

OptionsView.cb_gamepad_look_sensitivity_saved_value = function (self, arg_309_1)
	-- function 309
	local content = arg_309_1.content
	local min = content.min
	local max = content.max
	local var_309_3 = fn_2(self.changed_user_settings.gamepad_look_sensitivity, Application.user_setting("gamepad_look_sensitivity"))

	var_309_3 = var_309_3 or 0

	local clamp = math.clamp(var_309_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_gamepad_look_sensitivity = function (arg_310_0, arg_310_1)
	-- function 310
	arg_310_0.changed_user_settings.gamepad_look_sensitivity = arg_310_1.value
end

OptionsView.cb_gamepad_look_sensitivity_y_setup = function (self)
	-- function 311
	local num = -10
	local num_2 = 10
	local user_setting = Application.user_setting("gamepad_look_sensitivity_y")

	user_setting = user_setting or 0

	local get = DefaultUserSettings.get("user_settings", "gamepad_look_sensitivity_y")
	local var_311_4 = fn(num, num_2, user_setting)
	local clamp = math.clamp(user_setting, num, num_2)

	table.clear(tbl_21)

	local var_311_6 = tbl_21
	local num_3 = #tbl_21 + 1
	local flag

	flag = not IS_WINDOWS and "xb1" and self.platform
	var_311_6[num_3] = flag

	local var_311_9 = tbl_21
	local num_4 = #tbl_21 + 1
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and "ps_pad"
	var_311_9[num_4] = IS_WINDOWS

	for i = 1, #tbl_21 do
		local var_311_12 = tbl_21[i]
		local get_platform_filters = InputUtils.get_platform_filters(PlayerControllerFilters, var_311_12)
		local multiplier_y = get_platform_filters.look_controller.multiplier_y
		local multiplier_y_2 = get_platform_filters.look_controller_melee.multiplier_y
		local multiplier_y_3 = get_platform_filters.look_controller_ranged.multiplier_y
		local get_active_filters = self.input_manager:get_service("Player"):get_active_filters(var_311_12)

		get_active_filters.look_controller.function_data.multiplier_y = multiplier_y * 0.85^-clamp
		get_active_filters.look_controller_melee.function_data.multiplier_y = multiplier_y_2 * 0.85^-clamp
		get_active_filters.look_controller_ranged.function_data.multiplier_y = multiplier_y_3 * 0.85^-clamp
	end

	return var_311_4, num, num_2, 1, "menu_settings_gamepad_look_sensitivity_y", get
end

OptionsView.cb_gamepad_look_sensitivity_y_saved_value = function (self, arg_312_1)
	-- function 312
	local content = arg_312_1.content
	local min = content.min
	local max = content.max
	local var_312_3 = fn_2(self.changed_user_settings.gamepad_look_sensitivity_y, Application.user_setting("gamepad_look_sensitivity_y"))

	var_312_3 = var_312_3 or 0

	local clamp = math.clamp(var_312_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_gamepad_look_sensitivity_y = function (arg_313_0, arg_313_1)
	-- function 313
	arg_313_0.changed_user_settings.gamepad_look_sensitivity_y = arg_313_1.value
end

OptionsView.cb_gamepad_zoom_sensitivity_setup = function (self)
	-- function 314
	local num = -10
	local num_2 = 10
	local user_setting = Application.user_setting("gamepad_zoom_sensitivity")

	user_setting = user_setting or 0

	local get = DefaultUserSettings.get("user_settings", "gamepad_zoom_sensitivity")
	local var_314_4 = fn(num, num_2, user_setting)
	local clamp = math.clamp(user_setting, num, num_2)

	table.clear(tbl_21)

	local var_314_6 = tbl_21
	local num_3 = #tbl_21 + 1
	local flag

	flag = not IS_WINDOWS and "xb1" and self.platform
	var_314_6[num_3] = flag

	local var_314_9 = tbl_21
	local num_4 = #tbl_21 + 1
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and "ps_pad"
	var_314_9[num_4] = IS_WINDOWS

	for i = 1, #tbl_21 do
		local var_314_12 = tbl_21[i]
		local get_platform_filters = InputUtils.get_platform_filters(PlayerControllerFilters, var_314_12)
		local multiplier_x = get_platform_filters.look_controller_zoom.multiplier_x
		local function_data = self.input_manager:get_service("Player"):get_active_filters(var_314_12).look_controller_zoom.function_data

		function_data.multiplier_x = multiplier_x * 0.85^-clamp

		local num_5

		if not get_platform_filters.look_controller_zoom.multiplier_min_x then
			num_5 = get_platform_filters.look_controller_zoom.multiplier_min_x * 0.85^-clamp

			if not num_5 then
				-- Nothing
			end
		end

		num_5 = function_data.multiplier_x * 0.25

		::label_314_0::

		function_data.min_multiplier_x = num_5
	end

	return var_314_4, num, num_2, 1, "menu_settings_gamepad_zoom_sensitivity", get
end

OptionsView.cb_gamepad_zoom_sensitivity_saved_value = function (self, arg_315_1)
	-- function 315
	local content = arg_315_1.content
	local min = content.min
	local max = content.max
	local var_315_3 = fn_2(self.changed_user_settings.gamepad_zoom_sensitivity, Application.user_setting("gamepad_zoom_sensitivity"))

	var_315_3 = var_315_3 or 0

	local clamp = math.clamp(var_315_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_gamepad_zoom_sensitivity = function (arg_316_0, arg_316_1)
	-- function 316
	arg_316_0.changed_user_settings.gamepad_zoom_sensitivity = arg_316_1.value
end

OptionsView.cb_gamepad_zoom_sensitivity_y_setup = function (self)
	-- function 317
	local num = -10
	local num_2 = 10
	local user_setting = Application.user_setting("gamepad_zoom_sensitivity_y")

	user_setting = user_setting or 0

	local get = DefaultUserSettings.get("user_settings", "gamepad_zoom_sensitivity_y")
	local var_317_4 = fn(num, num_2, user_setting)
	local clamp = math.clamp(user_setting, num, num_2)

	table.clear(tbl_21)

	local var_317_6 = tbl_21
	local num_3 = #tbl_21 + 1
	local flag

	flag = not IS_WINDOWS and "xb1" and self.platform
	var_317_6[num_3] = flag

	local var_317_9 = tbl_21
	local num_4 = #tbl_21 + 1
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and "ps_pad"
	var_317_9[num_4] = IS_WINDOWS

	for i = 1, #tbl_21 do
		local var_317_12 = tbl_21[i]
		local multiplier_y = InputUtils.get_platform_filters(PlayerControllerFilters, var_317_12).look_controller_zoom.multiplier_y

		self.input_manager:get_service("Player"):get_active_filters(var_317_12).look_controller_zoom.function_data.multiplier_y = multiplier_y * 0.85^-clamp
	end

	return var_317_4, num, num_2, 1, "menu_settings_gamepad_zoom_sensitivity_y", get
end

OptionsView.cb_gamepad_zoom_sensitivity_y_saved_value = function (self, arg_318_1)
	-- function 318
	local content = arg_318_1.content
	local min = content.min
	local max = content.max
	local var_318_3 = fn_2(self.changed_user_settings.gamepad_zoom_sensitivity_y, Application.user_setting("gamepad_zoom_sensitivity_y"))

	var_318_3 = var_318_3 or 0

	local clamp = math.clamp(var_318_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_gamepad_zoom_sensitivity_y = function (arg_319_0, arg_319_1)
	-- function 319
	arg_319_0.changed_user_settings.gamepad_zoom_sensitivity_y = arg_319_1.value
end

OptionsView.cb_max_upload_speed = function (arg_320_0, arg_320_1)
	-- function 320
	local options_values = arg_320_1.options_values
	local current_selection = arg_320_1.current_selection

	arg_320_0.changed_user_settings.max_upload_speed = options_values[current_selection]
end

OptionsView.cb_max_upload_speed_setup = function (arg_321_0)
	-- function 321
	local tbl = {
		{
			value = 256,
			text = Localize("menu_settings_256kbit")
		},
		{
			value = 512,
			text = Localize("menu_settings_512kbit")
		},
		{
			value = 1024,
			text = Localize("menu_settings_1mbit")
		},
		{
			value = 2048,
			text = Localize("menu_settings_2mbit_plus")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "max_upload_speed")
	local user_setting = Application.user_setting("max_upload_speed")
	local var_321_3
	local var_321_4

	for i, v in ipairs(tbl) do
		if v.value == user_setting then
			var_321_4 = i
		end

		if v.value == get then
			var_321_3 = i
		end
	end

	fassert(var_321_3, "default option %i does not exist in cb_max_upload_speed_setup options table", get)

	return var_321_4 or var_321_3, tbl, "menu_settings_max_upload", var_321_3
end

OptionsView.cb_max_upload_speed_saved_value = function (self, arg_322_1)
	-- function 322
	local var_322_0 = fn_2(self.changed_user_settings.max_upload_speed, Application.user_setting("max_upload_speed"))

	var_322_0 = var_322_0 or DefaultUserSettings.get("user_settings", "max_upload_speed")

	local options_values = arg_322_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_322_0 == options_values[i] then
			num = i

			break
		end
	end

	arg_322_1.content.current_selection = num
end

OptionsView.cb_small_network_packets = function (arg_323_0, arg_323_1)
	-- function 323
	local options_values = arg_323_1.options_values
	local current_selection = arg_323_1.current_selection

	arg_323_0.changed_user_settings.small_network_packets = options_values[current_selection]
end

OptionsView.cb_small_network_packets_setup = function (arg_324_0)
	-- function 324
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "small_network_packets")
	local flag

	flag = not Application.user_setting("small_network_packets") and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_small_network_packets", flag_2
end

OptionsView.cb_small_network_packets_saved_value = function (self, arg_325_1)
	-- function 325
	local var_325_0 = fn_2(self.changed_user_settings.small_network_packets, Application.user_setting("small_network_packets"))

	var_325_0 = var_325_0 or false

	local content = arg_325_1.content
	local flag

	flag = not var_325_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_max_quick_play_search_range = function (arg_326_0, arg_326_1)
	-- function 326
	local options_values = arg_326_1.options_values
	local current_selection = arg_326_1.current_selection

	arg_326_0.changed_user_settings.max_quick_play_search_range = options_values[current_selection]
end

OptionsView.cb_max_quick_play_search_range_setup = function (arg_327_0)
	-- function 327
	local tbl = {
		{
			value = "close",
			text = Localize("menu_settings_near")
		},
		{
			value = "far",
			text = Localize("menu_settings_far")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "max_quick_play_search_range")
	local user_setting = Application.user_setting("max_quick_play_search_range")
	local var_327_3
	local var_327_4

	for i, v in ipairs(tbl) do
		if v.value == user_setting then
			var_327_4 = i
		end

		if v.value == get then
			var_327_3 = i
		end
	end

	fassert(var_327_3, "default option %i does not exist in cb_max_quick_play_search_range_setup options table", get)

	return var_327_4 or var_327_3, tbl, "menu_settings_max_quick_play_search_range", var_327_3
end

OptionsView.cb_max_quick_play_search_range_saved_value = function (self, arg_328_1)
	-- function 328
	local var_328_0 = fn_2(self.changed_user_settings.max_quick_play_search_range, Application.user_setting("max_quick_play_search_range"))

	var_328_0 = var_328_0 or DefaultUserSettings.get("user_settings", "max_quick_play_search_range")

	local options_values = arg_328_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_328_0 == options_values[i] then
			num = i

			break
		end
	end

	arg_328_1.content.current_selection = num
end

OptionsView.cb_mouse_look_invert_y_setup = function (self)
	-- function 329
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "mouse_look_invert_y")
	local user_setting = Application.user_setting("mouse_look_invert_y")
	local get_service = self.input_manager:get_service("Player")
	local str = "win32"
	local function_data = get_service:get_active_filters(str).look.function_data
	local flag

	flag = not user_setting and "scale_vector3" and "scale_vector3_invert_y"
	function_data.filter_type = flag

	local flag_2

	flag_2 = not user_setting and 2 and 1

	local flag_3

	flag_3 = not get and 2 and 1

	return flag_2, tbl, "menu_settings_mouse_look_invert_y", flag_3
end

OptionsView.cb_mouse_look_invert_y_saved_value = function (self, arg_330_1)
	-- function 330
	local var_330_0 = fn_2(self.changed_user_settings.mouse_look_invert_y, Application.user_setting("mouse_look_invert_y"))

	var_330_0 = var_330_0 or false

	local content = arg_330_1.content
	local flag

	flag = not var_330_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_mouse_look_invert_y = function (arg_331_0, arg_331_1)
	-- function 331
	local options_values = arg_331_1.options_values
	local current_selection = arg_331_1.current_selection

	arg_331_0.changed_user_settings.mouse_look_invert_y = options_values[current_selection]
end

OptionsView.cb_gamepad_look_invert_y_setup = function (self)
	-- function 332
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "gamepad_look_invert_y")

	get = get or false

	local user_setting = Application.user_setting("gamepad_look_invert_y")
	local get_service = self.input_manager:get_service("Player")

	table.clear(tbl_21)

	local var_332_4 = tbl_21
	local num = #tbl_21 + 1
	local flag

	flag = not IS_WINDOWS and "xb1" and self.platform
	var_332_4[num] = flag

	local var_332_7 = tbl_21
	local num_2 = #tbl_21 + 1
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and "ps_pad"
	var_332_7[num_2] = IS_WINDOWS

	for i = 1, #tbl_21 do
		local var_332_10 = tbl_21[i]
		local get_active_filters = get_service:get_active_filters(var_332_10)
		local function_data = get_active_filters.look_controller.function_data
		local flag_2

		flag_2 = not user_setting and "scale_vector3_xy_accelerated_x_inverted" and "scale_vector3_xy_accelerated_x"
		function_data.filter_type = flag_2

		local function_data_2 = get_active_filters.look_controller_ranged.function_data
		local flag_3

		flag_3 = not user_setting and "scale_vector3_xy_accelerated_x_inverted" and "scale_vector3_xy_accelerated_x"
		function_data_2.filter_type = flag_3

		local function_data_3 = get_active_filters.look_controller_melee.function_data
		local flag_4

		flag_4 = not user_setting and "scale_vector3_xy_accelerated_x_inverted" and "scale_vector3_xy_accelerated_x"
		function_data_3.filter_type = flag_4

		local function_data_4 = get_active_filters.look_controller_zoom.function_data
		local flag_5

		flag_5 = not user_setting and "scale_vector3_xy_accelerated_x_inverted" and "scale_vector3_xy_accelerated_x"
		function_data_4.filter_type = flag_5
	end

	local flag_6

	flag_6 = not user_setting and 2 and 1

	local flag_7

	flag_7 = not get and 2 and 1

	return flag_6, tbl, "menu_settings_gamepad_look_invert_y", flag_7
end

OptionsView.cb_gamepad_look_invert_y_saved_value = function (self, arg_333_1)
	-- function 333
	local var_333_0 = fn_2(self.changed_user_settings.gamepad_look_invert_y, Application.user_setting("gamepad_look_invert_y"))

	var_333_0 = var_333_0 or false

	local content = arg_333_1.content
	local flag

	flag = not var_333_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_gamepad_look_invert_y = function (arg_334_0, arg_334_1)
	-- function 334
	local options_values = arg_334_1.options_values
	local current_selection = arg_334_1.current_selection

	arg_334_0.changed_user_settings.gamepad_look_invert_y = options_values[current_selection]
end

OptionsView.cb_gamepad_left_dead_zone_setup = function (arg_335_0)
	-- function 335
	local num = 0
	local num_2 = 1
	local active_controller = Managers.account:active_controller()
	local default_dead_zone = active_controller.default_dead_zone()
	local axis_index = active_controller.axis_index("left")
	local get = DefaultUserSettings.get("user_settings", "gamepad_left_dead_zone")

	get = get or 0

	local user_setting = Application.user_setting("gamepad_left_dead_zone")

	user_setting = user_setting or get

	local var_335_7 = fn(num, num_2, user_setting)
	local dead_zone = default_dead_zone[axis_index].dead_zone
	local num_3 = dead_zone + var_335_7 * (0.9 - dead_zone)

	if user_setting > 0 then
		local CIRCULAR = active_controller.CIRCULAR

		active_controller.set_dead_zone(axis_index, CIRCULAR, num_3)
	end

	return var_335_7, num, num_2, 1, "menu_settings_gamepad_left_dead_zone", get
end

OptionsView.cb_gamepad_left_dead_zone_saved_value = function (self, arg_336_1)
	-- function 336
	local content = arg_336_1.content
	local min = content.min
	local max = content.max
	local var_336_3 = fn_2(self.changed_user_settings.gamepad_left_dead_zone, Application.user_setting("gamepad_left_dead_zone"))

	var_336_3 = var_336_3 or 0

	local clamp = math.clamp(var_336_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_gamepad_left_dead_zone = function (arg_337_0, arg_337_1)
	-- function 337
	arg_337_0.changed_user_settings.gamepad_left_dead_zone = arg_337_1.value
end

OptionsView.cb_gamepad_right_dead_zone_setup = function (arg_338_0)
	-- function 338
	local num = 0
	local num_2 = 1
	local active_controller = Managers.account:active_controller()
	local default_dead_zone = active_controller.default_dead_zone()
	local axis_index = active_controller.axis_index("right")
	local get = DefaultUserSettings.get("user_settings", "gamepad_right_dead_zone")

	get = get or 0

	local user_setting = Application.user_setting("gamepad_right_dead_zone")

	user_setting = user_setting or get

	local var_338_7 = fn(num, num_2, user_setting)
	local dead_zone = default_dead_zone[axis_index].dead_zone
	local num_3 = dead_zone + var_338_7 * (0.9 - dead_zone)

	if user_setting > 0 then
		local CIRCULAR = active_controller.CIRCULAR

		active_controller.set_dead_zone(axis_index, CIRCULAR, num_3)
	end

	return var_338_7, num, num_2, 1, "menu_settings_gamepad_right_dead_zone", get
end

OptionsView.cb_gamepad_right_dead_zone_saved_value = function (self, arg_339_1)
	-- function 339
	local content = arg_339_1.content
	local min = content.min
	local max = content.max
	local var_339_3 = fn_2(self.changed_user_settings.gamepad_right_dead_zone, Application.user_setting("gamepad_right_dead_zone"))

	var_339_3 = var_339_3 or 0

	local clamp = math.clamp(var_339_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_gamepad_right_dead_zone = function (arg_340_0, arg_340_1)
	-- function 340
	arg_340_0.changed_user_settings.gamepad_right_dead_zone = arg_340_1.value
end

OptionsView.cb_gamepad_auto_aim_enabled_setup = function (arg_341_0)
	-- function 341
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "gamepad_auto_aim_enabled")

	get = get or true

	local flag

	flag = not Application.user_setting("gamepad_auto_aim_enabled") and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	return flag, tbl, "menu_settings_gamepad_auto_aim_enabled", flag_2
end

OptionsView.cb_gamepad_auto_aim_enabled_saved_value = function (self, arg_342_1)
	-- function 342
	local var_342_0 = fn_2(self.changed_user_settings.gamepad_auto_aim_enabled, Application.user_setting("gamepad_auto_aim_enabled"))
	local content = arg_342_1.content
	local flag

	flag = not var_342_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_gamepad_auto_aim_enabled = function (arg_343_0, arg_343_1)
	-- function 343
	local options_values = arg_343_1.options_values
	local current_selection = arg_343_1.current_selection

	arg_343_0.changed_user_settings.gamepad_auto_aim_enabled = options_values[current_selection]
end

OptionsView.cb_gamepad_acceleration_enabled_setup = function (arg_344_0)
	-- function 344
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "enable_gamepad_acceleration")

	get = get or true

	local flag

	flag = not Application.user_setting("enable_gamepad_acceleration") and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	return flag, tbl, "menu_settings_enable_gamepad_acceleration", flag_2
end

OptionsView.cb_gamepad_acceleration_enabled_saved_value = function (self, arg_345_1)
	-- function 345
	local var_345_0 = fn_2(self.changed_user_settings.enable_gamepad_acceleration, Application.user_setting("enable_gamepad_acceleration"))
	local content = arg_345_1.content
	local flag

	flag = not var_345_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_gamepad_acceleration_enabled = function (arg_346_0, arg_346_1)
	-- function 346
	local options_values = arg_346_1.options_values
	local current_selection = arg_346_1.current_selection

	arg_346_0.changed_user_settings.enable_gamepad_acceleration = options_values[current_selection]
end

OptionsView.cb_gamepad_rumble_enabled_setup = function (arg_347_0)
	-- function 347
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "gamepad_rumble_enabled")

	get = get or true

	local flag

	flag = not Application.user_setting("gamepad_rumble_enabled") and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	return flag, tbl, "menu_settings_gamepad_rumble_enabled", flag_2
end

OptionsView.cb_gamepad_rumble_enabled_saved_value = function (self, arg_348_1)
	-- function 348
	local var_348_0 = fn_2(self.changed_user_settings.gamepad_rumble_enabled, Application.user_setting("gamepad_rumble_enabled"))
	local content = arg_348_1.content
	local flag

	flag = not var_348_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_gamepad_rumble_enabled = function (arg_349_0, arg_349_1)
	-- function 349
	local options_values = arg_349_1.options_values
	local current_selection = arg_349_1.current_selection

	arg_349_0.changed_user_settings.gamepad_rumble_enabled = options_values[current_selection]
end

OptionsView.cb_motion_controls_enabled_setup = function (arg_350_0)
	-- function 350
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "use_motion_controls")

	get = get or false

	local user_setting = Application.user_setting("use_motion_controls")
	local flag

	flag = not user_setting and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	if user_setting == nil then
		user_setting = MotionControlSettings.motion_controls_enabled
	end

	MotionControlSettings.use_motion_controls = user_setting

	return flag, tbl, "menu_settings_motion_controls_enabled", flag_2
end

OptionsView.cb_motion_controls_enabled_saved_value = function (self, arg_351_1)
	-- function 351
	local var_351_0 = fn_2(self.changed_user_settings.use_motion_controls, Application.user_setting("use_motion_controls"))
	local content = arg_351_1.content
	local flag

	flag = not var_351_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_motion_controls_enabled = function (arg_352_0, arg_352_1)
	-- function 352
	local options_values = arg_352_1.options_values
	local current_selection = arg_352_1.current_selection

	arg_352_0.changed_user_settings.use_motion_controls = options_values[current_selection]
end

OptionsView.cb_motion_yaw_sensitivity_setup = function (arg_353_0)
	-- function 353
	local sensitivity_yaw_min = MotionControlSettings.sensitivity_yaw_min
	local sensitivity_yaw_max = MotionControlSettings.sensitivity_yaw_max
	local user_setting = Application.user_setting("motion_sensitivity_yaw")

	user_setting = user_setting or MotionControlSettings.default_sensitivity_yaw

	local get = DefaultUserSettings.get("user_settings", "motion_sensitivity_yaw")
	local var_353_4 = fn(sensitivity_yaw_min, sensitivity_yaw_max, user_setting)
	local clamp = math.clamp(user_setting, sensitivity_yaw_min, sensitivity_yaw_max)

	if clamp == nil then
		motion_controls_enabled = MotionControlSettings.default_sensitivity_yaw
	end

	MotionControlSettings.motion_sensitivity_yaw = clamp

	return var_353_4, sensitivity_yaw_min, sensitivity_yaw_max, 0, "menu_settings_sensitivity_yaw", get
end

OptionsView.cb_motion_yaw_sensitivity_saved_value = function (self, arg_354_1)
	-- function 354
	local content = arg_354_1.content
	local min = content.min
	local max = content.max
	local var_354_3 = fn_2(self.changed_user_settings.motion_sensitivity_yaw, Application.user_setting("motion_sensitivity_yaw"))

	var_354_3 = var_354_3 or MotionControlSettings.default_sensitivity_yaw

	local clamp = math.clamp(var_354_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_motion_yaw_sensitivity = function (arg_355_0, arg_355_1)
	-- function 355
	arg_355_0.changed_user_settings.motion_sensitivity_yaw = arg_355_1.value
end

OptionsView.cb_motion_pitch_sensitivity_setup = function (arg_356_0)
	-- function 356
	local sensitivity_pitch_min = MotionControlSettings.sensitivity_pitch_min
	local sensitivity_pitch_max = MotionControlSettings.sensitivity_pitch_max
	local user_setting = Application.user_setting("motion_sensitivity_pitch")

	user_setting = user_setting or MotionControlSettings.default_sensitivity_pitch

	local get = DefaultUserSettings.get("user_settings", "motion_sensitivity_pitch")
	local var_356_4 = fn(sensitivity_pitch_min, sensitivity_pitch_max, user_setting)
	local clamp = math.clamp(user_setting, sensitivity_pitch_min, sensitivity_pitch_max)

	if clamp == nil then
		MotionControlSettings.motion_sensitivity_pitch = MotionControlSettings.default_sensitivity_pitch
	end

	MotionControlSettings.motion_sensitivity_pitch = clamp

	return var_356_4, sensitivity_pitch_min, sensitivity_pitch_max, 0, "menu_settings_sensitivity_pitch", get
end

OptionsView.cb_motion_pitch_sensitivity_saved_value = function (self, arg_357_1)
	-- function 357
	local content = arg_357_1.content
	local min = content.min
	local max = content.max
	local var_357_3 = fn_2(self.changed_user_settings.motion_sensitivity_pitch, Application.user_setting("motion_sensitivity_pitch"))

	var_357_3 = var_357_3 or MotionControlSettings.default_sensitivity_pitch

	local clamp = math.clamp(var_357_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_motion_pitch_sensitivity = function (arg_358_0, arg_358_1)
	-- function 358
	arg_358_0.changed_user_settings.motion_sensitivity_pitch = arg_358_1.value
end

OptionsView.cb_disable_right_stick_look_setup = function (arg_359_0)
	-- function 359
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "motion_disable_right_stick_vertical")
	local user_setting = Application.user_setting("motion_disable_right_stick_vertical")
	local flag

	flag = not user_setting and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	if user_setting == nil then
		MotionControlSettings.motion_disable_right_stick_vertical = MotionControlSettings.motion_disable_right_stick_vertical
	end

	MotionControlSettings.motion_disable_right_stick_vertical = user_setting

	return flag, tbl, "menu_settings_disable_right_stick_vertical", flag_2
end

OptionsView.cb_disable_right_stick_look_saved_value = function (self, arg_360_1)
	-- function 360
	local var_360_0 = fn_2(self.changed_user_settings.motion_disable_right_stick_vertical, Application.user_setting("motion_disable_right_stick_vertical"))
	local content = arg_360_1.content
	local flag

	flag = not var_360_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_disable_right_stick_look = function (arg_361_0, arg_361_1)
	-- function 361
	local options_values = arg_361_1.options_values
	local current_selection = arg_361_1.current_selection

	arg_361_0.changed_user_settings.motion_disable_right_stick_vertical = options_values[current_selection]
end

OptionsView.cb_yaw_motion_enabled_setup = function (arg_362_0)
	-- function 362
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "motion_enable_yaw_motion")
	local user_setting = Application.user_setting("motion_enable_yaw_motion")
	local flag

	flag = not user_setting and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	if user_setting == nil then
		MotionControlSettings.motion_enable_yaw_motion = MotionControlSettings.motion_enable_yaw_motion
	end

	MotionControlSettings.motion_enable_yaw_motion = user_setting

	return flag, tbl, "menu_settings_motion_yaw_enabled", flag_2
end

OptionsView.cb_yaw_motion_enabled_saved_value = function (self, arg_363_1)
	-- function 363
	local var_363_0 = fn_2(self.changed_user_settings.motion_enable_yaw_motion, Application.user_setting("motion_enable_yaw_motion"))
	local content = arg_363_1.content
	local flag

	flag = not var_363_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_yaw_motion_enabled = function (arg_364_0, arg_364_1)
	-- function 364
	local options_values = arg_364_1.options_values
	local current_selection = arg_364_1.current_selection

	arg_364_0.changed_user_settings.motion_enable_yaw_motion = options_values[current_selection]
end

OptionsView.cb_pitch_motion_enabled_setup = function (arg_365_0)
	-- function 365
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "motion_enable_pitch_motion")
	local user_setting = Application.user_setting("motion_enable_pitch_motion")
	local flag

	flag = not user_setting and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	if user_setting == nil then
		MotionControlSettings.motion_enable_pitch_motion = MotionControlSettings.motion_enable_pitch_motion
	end

	MotionControlSettings.motion_enable_pitch_motion = user_setting

	return flag, tbl, "menu_settings_motion_pitch_enabled", flag_2
end

OptionsView.cb_pitch_motion_enabled_saved_value = function (self, arg_366_1)
	-- function 366
	local var_366_0 = fn_2(self.changed_user_settings.motion_enable_pitch_motion, Application.user_setting("motion_enable_pitch_motion"))
	local content = arg_366_1.content
	local flag

	flag = not var_366_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_pitch_motion_enabled = function (arg_367_0, arg_367_1)
	-- function 367
	local options_values = arg_367_1.options_values
	local current_selection = arg_367_1.current_selection

	arg_367_0.changed_user_settings.motion_enable_pitch_motion = options_values[current_selection]
end

OptionsView.cb_invert_yaw_enabled_setup = function (arg_368_0)
	-- function 368
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "motion_invert_yaw")
	local user_setting = Application.user_setting("motion_invert_yaw")
	local flag

	flag = not user_setting and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	if user_setting == nil then
		MotionControlSettings.motion_invert_yaw = MotionControlSettings.motion_invert_yaw
	end

	MotionControlSettings.motion_invert_yaw = user_setting

	return flag, tbl, "menu_settings_invert_yaw", flag_2
end

OptionsView.cb_invert_yaw_enabled_saved_value = function (self, arg_369_1)
	-- function 369
	local var_369_0 = fn_2(self.changed_user_settings.motion_invert_yaw, Application.user_setting("motion_invert_yaw"))
	local content = arg_369_1.content
	local flag

	flag = not var_369_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_invert_yaw_enabled = function (arg_370_0, arg_370_1)
	-- function 370
	local options_values = arg_370_1.options_values
	local current_selection = arg_370_1.current_selection

	arg_370_0.changed_user_settings.motion_invert_yaw = options_values[current_selection]
end

OptionsView.cb_invert_pitch_enabled_setup = function (arg_371_0)
	-- function 371
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "motion_invert_pitch")
	local user_setting = Application.user_setting("motion_invert_pitch")
	local flag

	flag = not user_setting and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	if user_setting == nil then
		MotionControlSettings.motion_invert_pitch = MotionControlSettings.motion_invert_pitch
	end

	MotionControlSettings.motion_invert_pitch = user_setting

	return flag, tbl, "menu_settings_invert_pitch", flag_2
end

OptionsView.cb_invert_pitch_enabled_saved_value = function (self, arg_372_1)
	-- function 372
	local var_372_0 = fn_2(self.changed_user_settings.motion_invert_pitch, Application.user_setting("motion_invert_pitch"))
	local content = arg_372_1.content
	local flag

	flag = not var_372_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_invert_pitch_enabled = function (arg_373_0, arg_373_1)
	-- function 373
	local options_values = arg_373_1.options_values
	local current_selection = arg_373_1.current_selection

	arg_373_0.changed_user_settings.motion_invert_pitch = options_values[current_selection]
end

OptionsView.cb_gamepad_use_ps4_style_input_icons_setup = function (arg_374_0)
	-- function 374
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_auto")
		},
		{
			value = true,
			text = Localize("menu_settings_ps4_input_icons")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "gamepad_use_ps4_style_input_icons")

	get = get or false

	local flag

	flag = not Application.user_setting("gamepad_use_ps4_style_input_icons") and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_gamepad_use_ps4_style_input_icons", flag_2
end

OptionsView.cb_gamepad_use_ps4_style_input_icons_saved_value = function (self, arg_375_1)
	-- function 375
	local var_375_0 = fn_2(self.changed_user_settings.gamepad_use_ps4_style_input_icons, Application.user_setting("gamepad_use_ps4_style_input_icons"))
	local content = arg_375_1.content
	local flag

	flag = not var_375_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_gamepad_use_ps4_style_input_icons = function (self, arg_376_1)
	-- function 376
	local options_values = arg_376_1.options_values
	local current_selection = arg_376_1.current_selection

	self.changed_user_settings.gamepad_use_ps4_style_input_icons = options_values[current_selection]

	local gamepad_layout_widget = self.gamepad_layout_widget
	local var_376_3 = fn_2(self.changed_user_settings.gamepad_use_ps4_style_input_icons, Application.user_setting("gamepad_use_ps4_style_input_icons"))

	gamepad_layout_widget.content.use_texture2_layout = var_376_3
end

OptionsView.cb_gamepad_layout_setup = function (arg_377_0)
	-- function 377
	local AlternatateGamepadKeymapsOptionsMenu = AlternatateGamepadKeymapsOptionsMenu
	local get = DefaultUserSettings.get("user_settings", "gamepad_layout")

	get = get or "default"

	local user_setting = Application.user_setting("gamepad_layout")
	local num = 1
	local var_377_4

	for i = 1, #AlternatateGamepadKeymapsOptionsMenu do
		local var_377_5 = AlternatateGamepadKeymapsOptionsMenu[i]

		if user_setting == var_377_5.value then
			num = i
		end

		if get == var_377_5.value then
			var_377_4 = i
		end

		if not var_377_5.localized then
			var_377_5.localized = true
			var_377_5.text = Localize(var_377_5.text)
		end
	end

	return num, AlternatateGamepadKeymapsOptionsMenu, "menu_settings_gamepad_layout", var_377_4
end

OptionsView.cb_gamepad_layout_saved_value = function (self, arg_378_1)
	-- function 378
	local var_378_0 = fn_2(self.changed_user_settings.gamepad_layout, Application.user_setting("gamepad_layout"))
	local options_values = arg_378_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_378_0 == options_values[i] then
			num = i
		end
	end

	arg_378_1.content.current_selection = num
end

OptionsView.cb_gamepad_layout = function (self, arg_379_1)
	-- function 379
	local var_379_0 = arg_379_1.options_values[arg_379_1.current_selection]

	self.changed_user_settings.gamepad_layout = var_379_0

	local var_379_1 = fn_2(self.changed_user_settings.gamepad_left_handed, Application.user_setting("gamepad_left_handed"))
	local var_379_2

	if not var_379_1 then
		var_379_2 = AlternatateGamepadKeymapsLayoutsLeftHanded
	else
		var_379_2 = AlternatateGamepadKeymapsLayouts
	end

	local var_379_3 = var_379_2[var_379_0]

	self:update_gamepad_layout_widget(var_379_3, var_379_1)
end

OptionsView.using_left_handed_gamepad_layout = function (self)
	-- function 380
	local user_setting = Application.user_setting("gamepad_left_handed")
	local gamepad_left_handed = self.changed_user_settings.gamepad_left_handed
	local var_380_2

	if gamepad_left_handed ~= nil then
		var_380_2 = gamepad_left_handed
	else
		var_380_2 = user_setting
	end

	return var_380_2
end

OptionsView.cb_gamepad_left_handed_enabled_setup = function (arg_381_0)
	-- function 381
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "gamepad_left_handed")

	get = get or false

	local flag

	flag = not Application.user_setting("gamepad_left_handed") and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	return flag, tbl, "menu_settings_gamepad_left_handed_enabled", flag_2
end

OptionsView.cb_gamepad_left_handed_enabled_saved_value = function (self, arg_382_1)
	-- function 382
	local var_382_0 = fn_2(self.changed_user_settings.gamepad_left_handed, Application.user_setting("gamepad_left_handed"))
	local content = arg_382_1.content
	local flag

	flag = not var_382_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_gamepad_left_handed_enabled = function (self, arg_383_1)
	-- function 383
	local options_values = arg_383_1.options_values
	local current_selection = arg_383_1.current_selection

	self.changed_user_settings.gamepad_left_handed = options_values[current_selection]

	local var_383_2 = fn_2(self.changed_user_settings.gamepad_layout, Application.user_setting("gamepad_layout"))

	self:force_set_widget_value("gamepad_layout", var_383_2)
end

OptionsView.cb_toggle_crouch_setup = function (arg_384_0)
	-- function 384
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "toggle_crouch")
	local flag

	flag = not Application.user_setting("toggle_crouch") and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	return flag, tbl, "menu_settings_toggle_crouch", flag_2
end

OptionsView.cb_toggle_crouch_saved_value = function (self, arg_385_1)
	-- function 385
	local var_385_0 = fn_2(self.changed_user_settings.toggle_crouch, Application.user_setting("toggle_crouch"))
	local content = arg_385_1.content
	local flag

	flag = not var_385_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_toggle_crouch = function (arg_386_0, arg_386_1)
	-- function 386
	local options_values = arg_386_1.options_values
	local current_selection = arg_386_1.current_selection

	arg_386_0.changed_user_settings.toggle_crouch = options_values[current_selection]
end

OptionsView.cb_toggle_stationary_dodge_setup = function (arg_387_0)
	-- function 387
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "toggle_stationary_dodge")
	local flag

	flag = not Application.user_setting("toggle_stationary_dodge") and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	return flag, tbl, "menu_settings_toggle_stationary_dodge", flag_2
end

OptionsView.cb_toggle_stationary_dodge_saved_value = function (self, arg_388_1)
	-- function 388
	local var_388_0 = fn_2(self.changed_user_settings.toggle_stationary_dodge, Application.user_setting("toggle_stationary_dodge"))
	local content = arg_388_1.content
	local flag

	flag = not var_388_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_toggle_stationary_dodge = function (arg_389_0, arg_389_1)
	-- function 389
	local options_values = arg_389_1.options_values
	local current_selection = arg_389_1.current_selection

	arg_389_0.changed_user_settings.toggle_stationary_dodge = options_values[current_selection]
end

OptionsView.cb_matchmaking_region_setup = function (arg_390_0)
	-- function 390
	local tbl = {}

	for k, v in pairs(MatchmakingRegions) do
		for k_2, v_2 in pairs(v) do
			tbl[k_2] = true
		end
	end

	local tbl_2 = {
		{
			value = "auto",
			text = Localize("menu_settings_auto")
		}
	}

	for k_3, v_3 in pairs(tbl) do
		tbl_2[#tbl_2 + 1] = {
			text = Localize(k_3),
			value = k_3
		}
	end

	local get = DefaultUserSettings.get("user_settings", "matchmaking_region")
	local user_setting = Application.user_setting("matchmaking_region")
	local num = 1
	local num_2 = 1

	for i, v_4 in ipairs(tbl_2) do
		if v_4.value == user_setting then
			num_2 = i

			break
		end
	end

	return num_2, tbl_2, "menu_settings_matchmaking_region", num
end

OptionsView.cb_matchmaking_region_saved_value = function (self, arg_391_1)
	-- function 391
	local var_391_0 = fn_2(self.changed_user_settings.matchmaking_region, Application.user_setting("matchmaking_region"))
	local num = 1

	for i, v in ipairs(arg_391_1.content.options_values) do
		if v == var_391_0 then
			num = i

			break
		end
	end

	arg_391_1.content.current_selection = num
end

OptionsView.cb_matchmaking_region = function (arg_392_0, arg_392_1)
	-- function 392
	local current_selection = arg_392_1.current_selection
	local var_392_1 = arg_392_1.options_values[current_selection]

	arg_392_0.changed_user_settings.matchmaking_region = var_392_1
end

OptionsView.cb_overcharge_opacity_setup = function (arg_393_0)
	-- function 393
	local num = 0
	local num_2 = 100
	local user_setting = Application.user_setting("overcharge_opacity")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "overcharge_opacity")

	local get = DefaultUserSettings.get("user_settings", "overcharge_opacity")

	return fn(num, num_2, user_setting), num, num_2, 0, "menu_settings_overcharge_opacity", get
end

OptionsView.cb_overcharge_opacity_saved_value = function (self, arg_394_1)
	-- function 394
	local content = arg_394_1.content
	local min = content.min
	local max = content.max
	local var_394_3 = fn_2
	local overcharge_opacity = self.changed_user_settings.overcharge_opacity
	local user_setting = Application.user_setting("overcharge_opacity")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "overcharge_opacity")

	local var_394_6 = var_394_3(overcharge_opacity, user_setting)
	local clamp = math.clamp(var_394_6, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_overcharge_opacity = function (arg_395_0, arg_395_1)
	-- function 395
	arg_395_0.changed_user_settings.overcharge_opacity = arg_395_1.value
end

OptionsView.cb_input_buffer_setup = function (arg_396_0)
	-- function 396
	local num = 0
	local num_2 = 1
	local user_setting = Application.user_setting("input_buffer")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "input_buffer")

	local get = DefaultUserSettings.get("user_settings", "input_buffer")

	return fn(num, num_2, user_setting), num, num_2, 1, "menu_settings_input_buffer", get
end

OptionsView.cb_input_buffer_saved_value = function (self, arg_397_1)
	-- function 397
	local content = arg_397_1.content
	local min = content.min
	local max = content.max
	local var_397_3 = fn_2
	local input_buffer = self.changed_user_settings.input_buffer
	local user_setting = Application.user_setting("input_buffer")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "input_buffer")

	local var_397_6 = var_397_3(input_buffer, user_setting)
	local clamp = math.clamp(var_397_6, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_input_buffer = function (arg_398_0, arg_398_1)
	-- function 398
	arg_398_0.changed_user_settings.input_buffer = arg_398_1.value
end

OptionsView.cb_priority_input_buffer_setup = function (arg_399_0)
	-- function 399
	local num = 0
	local num_2 = 2
	local user_setting = Application.user_setting("priority_input_buffer")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "priority_input_buffer")

	local get = DefaultUserSettings.get("user_settings", "priority_input_buffer")

	return fn(num, num_2, user_setting), num, num_2, 1, "menu_settings_priority_input_buffer", get
end

OptionsView.cb_priority_input_buffer_saved_value = function (self, arg_400_1)
	-- function 400
	local content = arg_400_1.content
	local min = content.min
	local max = content.max
	local var_400_3 = fn_2
	local priority_input_buffer = self.changed_user_settings.priority_input_buffer
	local user_setting = Application.user_setting("priority_input_buffer")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "priority_input_buffer")

	local var_400_6 = var_400_3(priority_input_buffer, user_setting)
	local clamp = math.clamp(var_400_6, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_priority_input_buffer = function (arg_401_0, arg_401_1)
	-- function 401
	arg_401_0.changed_user_settings.priority_input_buffer = arg_401_1.value
end

OptionsView.cb_weapon_scroll_type_setup = function (arg_402_0)
	-- function 402
	local tbl = {
		{
			value = "scroll_wrap",
			text = Localize("menu_settings_scroll_type_wrap")
		},
		{
			value = "scroll_clamp",
			text = Localize("menu_settings_scroll_type_clamp")
		},
		{
			value = "scroll_disabled",
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "weapon_scroll_type")
	local user_setting = Application.user_setting("weapon_scroll_type")

	user_setting = user_setting or "scroll_wrap"

	local flag

	flag = (user_setting ~= "scroll_clamp" or not 2 or user_setting ~= "scroll_disabled") and (not 3 or 1)

	local flag_2

	flag_2 = (get ~= "scroll_clamp" or not 2 or get ~= "scroll_disabled") and (not 3 or 1)

	return flag, tbl, "menu_settings_weapon_scroll_type", flag_2
end

OptionsView.cb_weapon_scroll_type_saved_value = function (self, arg_403_1)
	-- function 403
	local var_403_0 = fn_2(self.changed_user_settings.weapon_scroll_type, Application.user_setting("weapon_scroll_type"))

	var_403_0 = var_403_0 or "scroll_wrap"

	local content = arg_403_1.content
	local flag

	flag = (var_403_0 ~= "scroll_clamp" or not 2 or var_403_0 ~= "scroll_disabled") and (not 3 or 1)
	content.current_selection = flag
end

OptionsView.cb_weapon_scroll_type = function (arg_404_0, arg_404_1)
	-- function 404
	local options_values = arg_404_1.options_values
	local current_selection = arg_404_1.current_selection

	arg_404_0.changed_user_settings.weapon_scroll_type = options_values[current_selection]
end

OptionsView.cb_double_tap_dodge = function (arg_405_0, arg_405_1)
	-- function 405
	local options_values = arg_405_1.options_values
	local current_selection = arg_405_1.current_selection

	arg_405_0.changed_user_settings.double_tap_dodge = options_values[current_selection]
end

OptionsView.cb_double_tap_dodge_setup = function (arg_406_0)
	-- function 406
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "double_tap_dodge")
	local user_setting = Application.user_setting("double_tap_dodge")

	if user_setting == nil then
		user_setting = get
	end

	local flag

	flag = not user_setting and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	return flag, tbl, "menu_settings_double_tap_dodge", flag_2
end

OptionsView.cb_double_tap_dodge_saved_value = function (self, arg_407_1)
	-- function 407
	local var_407_0 = fn_2(self.changed_user_settings.double_tap_dodge, Application.user_setting("double_tap_dodge"))

	if var_407_0 == nil then
		var_407_0 = DefaultUserSettings.get("user_settings", "double_tap_dodge")
	end

	local content = arg_407_1.content
	local flag

	flag = not var_407_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_tutorials_enabled_setup = function (arg_408_0)
	-- function 408
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "tutorials_enabled")
	local user_setting = Application.user_setting("tutorials_enabled")

	if user_setting == nil then
		user_setting = true
	end

	local flag

	flag = not user_setting and 1 and 2

	local flag_2

	flag_2 = not get and 1 and 2

	return flag, tbl, "menu_settings_tutorials_enabled", flag_2
end

OptionsView.cb_tutorials_enabled_saved_value = function (self, arg_409_1)
	-- function 409
	local var_409_0 = fn_2(self.changed_user_settings.tutorials_enabled, Application.user_setting("tutorials_enabled"))

	if var_409_0 == nil then
		var_409_0 = true
	end

	local content = arg_409_1.content
	local flag

	flag = not var_409_0 and 1 and 2
	content.current_selection = flag
end

OptionsView.cb_tutorials_enabled = function (arg_410_0, arg_410_1)
	-- function 410
	local options_values = arg_410_1.options_values
	local current_selection = arg_410_1.current_selection

	arg_410_0.changed_user_settings.tutorials_enabled = options_values[current_selection]
end

OptionsView.cb_master_volume_setup = function (arg_411_0)
	-- function 411
	local num = 0
	local num_2 = 100
	local user_setting = Application.user_setting("master_bus_volume")

	user_setting = user_setting or 90

	return fn(num, num_2, user_setting), num, num_2, 0, "menu_settings_master_volume", DefaultUserSettings.get("user_settings", "master_bus_volume")
end

OptionsView.cb_master_volume_saved_value = function (self, arg_412_1)
	-- function 412
	local content = arg_412_1.content
	local min = content.min
	local max = content.max
	local var_412_3 = fn_2(self.changed_user_settings.master_bus_volume, Application.user_setting("master_bus_volume"))

	var_412_3 = var_412_3 or 90
	content.internal_value = fn(min, max, var_412_3)
	content.value = var_412_3
end

OptionsView.cb_master_volume = function (self, arg_413_1)
	-- function 413
	local value = arg_413_1.value

	self.changed_user_settings.master_bus_volume = value

	self:set_wwise_parameter("master_bus_volume", value)
	Managers.music:set_master_volume(value)
end

OptionsView.cb_music_bus_volume_setup = function (arg_414_0)
	-- function 414
	local num = 0
	local num_2 = 100
	local user_setting = Application.user_setting("music_bus_volume")

	user_setting = user_setting or 90

	return fn(num, num_2, user_setting), num, num_2, 0, "menu_settings_music_volume", DefaultUserSettings.get("user_settings", "music_bus_volume")
end

OptionsView.cb_music_bus_volume_saved_value = function (self, arg_415_1)
	-- function 415
	local content = arg_415_1.content
	local min = content.min
	local max = content.max
	local var_415_3 = fn_2(self.changed_user_settings.music_bus_volume, Application.user_setting("music_bus_volume"))

	var_415_3 = var_415_3 or 90
	content.internal_value = fn(min, max, var_415_3)
	content.value = var_415_3
end

OptionsView.cb_music_bus_volume = function (arg_416_0, arg_416_1)
	-- function 416
	local value = arg_416_1.value

	arg_416_0.changed_user_settings.music_bus_volume = value

	Managers.music:set_music_volume(value)
end

OptionsView.cb_sfx_bus_volume_setup = function (arg_417_0)
	-- function 417
	local num = 0
	local num_2 = 100
	local user_setting = Application.user_setting("sfx_bus_volume")

	user_setting = user_setting or 90

	return fn(num, num_2, user_setting), num, num_2, 0, "menu_settings_sfx_volume", DefaultUserSettings.get("user_settings", "sfx_bus_volume")
end

OptionsView.cb_sfx_bus_volume_saved_value = function (self, arg_418_1)
	-- function 418
	local content = arg_418_1.content
	local min = content.min
	local max = content.max
	local var_418_3 = fn_2(self.changed_user_settings.sfx_bus_volume, Application.user_setting("sfx_bus_volume"))

	var_418_3 = var_418_3 or 90
	content.internal_value = fn(min, max, var_418_3)
	content.value = var_418_3
end

OptionsView.cb_sfx_bus_volume = function (self, arg_419_1)
	-- function 419
	local value = arg_419_1.value

	self.changed_user_settings.sfx_bus_volume = value

	self:set_wwise_parameter("sfx_bus_volume", value)
end

OptionsView.cb_voice_bus_volume_setup = function (arg_420_0)
	-- function 420
	local num = 0
	local num_2 = 100
	local user_setting = Application.user_setting("voice_bus_volume")

	user_setting = user_setting or 90

	return fn(num, num_2, user_setting), num, num_2, 0, "menu_settings_voice_volume", DefaultUserSettings.get("user_settings", "voice_bus_volume")
end

OptionsView.cb_voice_bus_volume_saved_value = function (self, arg_421_1)
	-- function 421
	local content = arg_421_1.content
	local min = content.min
	local max = content.max
	local var_421_3 = fn_2(self.changed_user_settings.voice_bus_volume, Application.user_setting("voice_bus_volume"))

	var_421_3 = var_421_3 or 90
	content.internal_value = fn(min, max, var_421_3)
	content.value = var_421_3
end

OptionsView.cb_voice_bus_volume = function (self, arg_422_1)
	-- function 422
	local value = arg_422_1.value

	self.changed_user_settings.voice_bus_volume = value

	self:set_wwise_parameter("voice_bus_volume", value)
end

OptionsView.cb_voip_bus_volume_setup = function (arg_423_0)
	-- function 423
	local num = 0
	local num_2 = 100
	local user_setting = Application.user_setting("voip_bus_volume")

	user_setting = user_setting or 0

	return fn(num, num_2, user_setting), num, num_2, 0, "menu_settings_voip_volume", DefaultUserSettings.get("user_settings", "voip_bus_volume")
end

OptionsView.cb_voip_bus_volume_saved_value = function (self, arg_424_1)
	-- function 424
	local content = arg_424_1.content
	local min = content.min
	local max = content.max
	local var_424_3 = fn_2(self.changed_user_settings.voip_bus_volume, Application.user_setting("voip_bus_volume"))

	var_424_3 = var_424_3 or 90
	content.internal_value = fn(min, max, var_424_3)
	content.value = var_424_3
end

OptionsView.cb_voip_bus_volume = function (self, arg_425_1)
	-- function 425
	local value = arg_425_1.value

	self.changed_user_settings.voip_bus_volume = value

	self.voip:set_volume(value)
end

OptionsView.cb_voip_enabled_setup = function (self)
	-- function 426
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local user_setting = Application.user_setting("voip_is_enabled")
	local get = DefaultUserSettings.get("user_settings", "voip_is_enabled")

	if user_setting == nil then
		user_setting = get
	end

	if not self.voip then
		self.voip:set_enabled(user_setting)
	end

	local num = 1

	if not user_setting then
		num = 2
	end

	local num_2 = 1

	if not get then
		num_2 = 2
	end

	return num, tbl, "menu_settings_voip_enabled", num_2
end

OptionsView.cb_voip_enabled_saved_value = function (self, arg_427_1)
	-- function 427
	local options_values = arg_427_1.content.options_values
	local var_427_1 = fn_2(self.changed_user_settings.voip_is_enabled, Application.user_setting("voip_is_enabled"))

	if var_427_1 == nil then
		var_427_1 = true
	end

	local num = 1

	for k, v in pairs(options_values) do
		if v == var_427_1 then
			num = k

			break
		end
	end

	arg_427_1.content.current_selection = num
	arg_427_1.content.selected_option = num
end

OptionsView.cb_voip_enabled = function (self, arg_428_1)
	-- function 428
	local var_428_0 = arg_428_1.options_values[arg_428_1.current_selection]

	self.changed_user_settings.voip_is_enabled = var_428_0

	self.voip:set_enabled(var_428_0)
end

OptionsView.cb_voip_push_to_talk_setup = function (self)
	-- function 429
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local user_setting = Application.user_setting("voip_push_to_talk")
	local get = DefaultUserSettings.get("user_settings", "voip_push_to_talk")

	if user_setting == nil then
		user_setting = get
	end

	self.voip:set_push_to_talk(user_setting)

	local num = 1

	if not user_setting then
		num = 2
	end

	local num_2 = 1

	if not get then
		num_2 = 2
	end

	return num, tbl, "menu_settings_voip_push_to_talk", num_2
end

OptionsView.cb_voip_push_to_talk_saved_value = function (self, arg_430_1)
	-- function 430
	local options_values = arg_430_1.content.options_values
	local var_430_1 = fn_2(self.changed_user_settings.voip_push_to_talk, Application.user_setting("voip_push_to_talk"))

	if var_430_1 == nil then
		var_430_1 = true
	end

	local num = 1

	for k, v in pairs(options_values) do
		if v == var_430_1 then
			num = k

			break
		end
	end

	arg_430_1.content.current_selection = num
	arg_430_1.content.selected_option = num
end

OptionsView.cb_voip_push_to_talk = function (self, arg_431_1)
	-- function 431
	local var_431_0 = arg_431_1.options_values[arg_431_1.current_selection]

	self.changed_user_settings.voip_push_to_talk = var_431_0

	self.voip:set_push_to_talk(var_431_0)
end

OptionsView.cb_particles_resolution_setup = function (arg_432_0)
	-- function 432
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_high")
		},
		{
			value = true,
			text = Localize("menu_settings_low")
		}
	}
	local flag

	flag = not Application.user_setting("render_settings", "low_res_transparency") and 2 and 1

	return flag, tbl, "menu_settings_low_res_transparency"
end

OptionsView.cb_particles_resolution_saved_value = function (self, arg_433_1)
	-- function 433
	local flag

	flag = not fn_2(self.changed_render_settings.low_res_transparency, Application.user_setting("render_settings", "low_res_transparency")) and 2 and 1
	arg_433_1.content.current_selection = flag
end

OptionsView.cb_particles_resolution = function (self, arg_434_1, arg_434_2, arg_434_3)
	-- function 434
	local var_434_0 = arg_434_1.options_values[arg_434_1.current_selection]

	self.changed_render_settings.low_res_transparency = var_434_0

	if not arg_434_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_particles_quality_setup = function (arg_435_0)
	-- function 435
	local tbl = {
		{
			value = "lowest",
			text = Localize("menu_settings_lowest")
		},
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		},
		{
			value = "extreme",
			text = Localize("menu_settings_extreme")
		}
	}
	local user_setting = Application.user_setting("particles_quality")
	local get = DefaultUserSettings.get("user_settings", "particles_quality")
	local num = 1
	local var_435_4

	for i = 1, #tbl do
		if tbl[i].value == user_setting then
			num = i
		end

		if get == tbl[i].value then
			var_435_4 = i
		end
	end

	return num, tbl, "menu_settings_particles_quality", var_435_4
end

OptionsView.cb_particles_quality_saved_value = function (self, arg_436_1)
	-- function 436
	local var_436_0 = fn_2(self.changed_user_settings.particles_quality, Application.user_setting("particles_quality"))
	local options_values = arg_436_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_436_0 == options_values[i] then
			num = i
		end
	end

	arg_436_1.content.current_selection = num
end

OptionsView.cb_particles_quality = function (self, arg_437_1, arg_437_2, arg_437_3)
	-- function 437
	local var_437_0 = arg_437_1.options_values[arg_437_1.current_selection]

	self.changed_user_settings.particles_quality = var_437_0

	local var_437_1 = ParticlesQuality[var_437_0]

	for k, v in pairs(var_437_1) do
		self.changed_render_settings[k] = v
	end

	if not arg_437_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_ambient_light_quality_setup = function (arg_438_0)
	-- function 438
	local tbl = {
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		}
	}
	local user_setting = Application.user_setting("ambient_light_quality")
	local get = DefaultUserSettings.get("user_settings", "ambient_light_quality")
	local num = 1
	local var_438_4

	for i = 1, #tbl do
		if tbl[i].value == user_setting then
			num = i
		end

		if get == tbl[i].value then
			var_438_4 = i
		end
	end

	return num, tbl, "menu_settings_ambient_light_quality", var_438_4
end

OptionsView.cb_ambient_light_quality_saved_value = function (self, arg_439_1)
	-- function 439
	local var_439_0 = fn_2(self.changed_user_settings.ambient_light_quality, Application.user_setting("ambient_light_quality"))
	local options_values = arg_439_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_439_0 == options_values[i] then
			num = i
		end
	end

	arg_439_1.content.current_selection = num
end

OptionsView.cb_ambient_light_quality = function (self, arg_440_1, arg_440_2, arg_440_3)
	-- function 440
	local var_440_0 = arg_440_1.options_values[arg_440_1.current_selection]

	self.changed_user_settings.ambient_light_quality = var_440_0

	local var_440_1 = AmbientLightQuality[var_440_0]

	for k, v in pairs(var_440_1) do
		self.changed_render_settings[k] = v
	end

	if not arg_440_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_auto_exposure_speed_setup = function (arg_441_0)
	-- function 441
	local num = 0.1
	local num_2 = 2
	local user_setting = Application.user_setting("render_settings", "eye_adaptation_speed")

	user_setting = user_setting or 1

	local var_441_3 = fn(num, num_2, user_setting)
	local clamp = math.clamp(DefaultUserSettings.get("render_settings", "eye_adaptation_speed"), num, num_2)

	return var_441_3, num, num_2, 1, "menu_settings_auto_exposure_speed"
end

OptionsView.cb_auto_exposure_speed_saved_value = function (self, arg_442_1)
	-- function 442
	local content = arg_442_1.content
	local min = content.min
	local max = content.max
	local var_442_3 = fn_2(self.changed_render_settings.eye_adaptation_speed, Application.user_setting("render_settings", "eye_adaptation_speed"))
	local clamp = math.clamp(var_442_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_auto_exposure_speed = function (self, arg_443_1, arg_443_2, arg_443_3)
	-- function 443
	self.changed_render_settings.eye_adaptation_speed = arg_443_1.value

	if not arg_443_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_volumetric_fog_quality_setup = function (arg_444_0)
	-- function 444
	local tbl = {
		{
			value = "lowest",
			text = Localize("menu_settings_lowest")
		},
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		},
		{
			value = "extreme",
			text = Localize("menu_settings_extreme")
		}
	}
	local user_setting = Application.user_setting("volumetric_fog_quality")
	local get = DefaultUserSettings.get("user_settings", "volumetric_fog_quality")
	local num = 1
	local var_444_4

	for i = 1, #tbl do
		if tbl[i].value == user_setting then
			num = i
		end

		if get == tbl[i].value then
			var_444_4 = i
		end
	end

	return num, tbl, "menu_settings_volumetric_fog_quality", var_444_4
end

OptionsView.cb_volumetric_fog_quality_saved_value = function (self, arg_445_1)
	-- function 445
	local var_445_0 = fn_2(self.changed_user_settings.volumetric_fog_quality, Application.user_setting("volumetric_fog_quality"))
	local options_values = arg_445_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_445_0 == options_values[i] then
			num = i
		end
	end

	arg_445_1.content.current_selection = num
end

OptionsView.cb_volumetric_fog_quality = function (self, arg_446_1, arg_446_2, arg_446_3)
	-- function 446
	local var_446_0 = arg_446_1.options_values[arg_446_1.current_selection]

	self.changed_user_settings.volumetric_fog_quality = var_446_0

	local var_446_1 = VolumetricFogQuality[var_446_0]

	for k, v in pairs(var_446_1) do
		self.changed_render_settings[k] = v
	end

	if not arg_446_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_physic_debris_setup = function (arg_447_0)
	-- function 447
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("use_physic_debris")

	if user_setting == nil then
		user_setting = true
	end

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "use_physic_debris") and 2 and 1

	return flag, tbl, "menu_settings_physic_debris", flag_2
end

OptionsView.cb_physic_debris_saved_value = function (self, arg_448_1)
	-- function 448
	local var_448_0 = fn_2(self.changed_user_settings.use_physic_debris, Application.user_setting("use_physic_debris"))

	if var_448_0 == nil then
		var_448_0 = true
	end

	local content = arg_448_1.content
	local flag

	flag = not var_448_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_physic_debris = function (self, arg_449_1, arg_449_2, arg_449_3)
	-- function 449
	local options_values = arg_449_1.options_values
	local current_selection = arg_449_1.current_selection

	self.changed_user_settings.use_physic_debris = options_values[current_selection]

	if not arg_449_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_alien_fx_setup = function (arg_450_0)
	-- function 450
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("use_alien_fx")

	if user_setting == nil then
		user_setting = true
	end

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "use_alien_fx") and 2 and 1
	GameSettingsDevelopment.use_alien_fx = user_setting

	return flag, tbl, "menu_settings_alien_fx", flag_2
end

OptionsView.cb_alien_fx_saved_value = function (self, arg_451_1)
	-- function 451
	local var_451_0 = fn_2(self.changed_user_settings.use_alien_fx, Application.user_setting("use_alien_fx"))

	if var_451_0 == nil then
		var_451_0 = true
	end

	local content = arg_451_1.content
	local flag

	flag = not var_451_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_alien_fx = function (arg_452_0, arg_452_1)
	-- function 452
	local options_values = arg_452_1.options_values
	local current_selection = arg_452_1.current_selection

	arg_452_0.changed_user_settings.use_alien_fx = options_values[current_selection]
	GameSettingsDevelopment.use_alien_fx = options_values[current_selection]
end

OptionsView.cb_razer_chroma_setup = function (arg_453_0)
	-- function 453
	print("cb_razer_chroma_setup")

	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("use_razer_chroma")

	if user_setting == nil then
		user_setting = false
	end

	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not DefaultUserSettings.get("user_settings", "use_razer_chroma") and 2 and 1
	GameSettingsDevelopment.use_razer_chroma = user_setting

	return flag, tbl, "menu_settings_razer_chroma", flag_2
end

OptionsView.cb_razer_chroma_saved_value = function (self, arg_454_1)
	-- function 454
	local var_454_0 = fn_2(self.changed_user_settings.use_razer_chroma, Application.user_setting("use_razer_chroma"))

	if var_454_0 == nil then
		var_454_0 = false
	end

	local content = arg_454_1.content
	local flag

	flag = not var_454_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_razer_chroma = function (arg_455_0, arg_455_1)
	-- function 455
	local options_values = arg_455_1.options_values
	local current_selection = arg_455_1.current_selection

	arg_455_0.changed_user_settings.use_razer_chroma = options_values[current_selection]
	GameSettingsDevelopment.use_razer_chroma = options_values[current_selection]
end

OptionsView.cb_ssr_setup = function (arg_456_0)
	-- function 456
	local tbl = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local user_setting = Application.user_setting("render_settings", "ssr_enabled")

	user_setting = user_setting or false

	local get = DefaultUserSettings.get("render_settings", "ssr_enabled")
	local flag

	flag = not user_setting and 2 and 1

	local flag_2

	flag_2 = not get and 2 and 1

	return flag, tbl, "menu_settings_ssr", flag_2
end

OptionsView.cb_ssr_saved_value = function (self, arg_457_1)
	-- function 457
	local var_457_0 = fn_2(self.changed_render_settings.ssr_enabled, Application.user_setting("render_settings", "ssr_enabled"))

	var_457_0 = var_457_0 or false

	local content = arg_457_1.content
	local flag

	flag = not var_457_0 and 2 and 1
	content.current_selection = flag
end

OptionsView.cb_ssr = function (self, arg_458_1, arg_458_2, arg_458_3)
	-- function 458
	local options_values = arg_458_1.options_values
	local current_selection = arg_458_1.current_selection

	self.changed_render_settings.ssr_enabled = options_values[current_selection]

	if not arg_458_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_fov_setup = function (arg_459_0)
	-- function 459
	local num = 45
	local num_2 = 120

	if not IS_WINDOWS then
		num, num_2 = 65, 90
	end

	local vertical_fov = CameraSettings.first_person._node.vertical_fov
	local user_setting = Application.user_setting("render_settings", "fov")

	user_setting = user_setting or vertical_fov

	local var_459_4 = fn(num, num_2, user_setting)
	local num_3 = math.clamp(user_setting, num, num_2) / vertical_fov
	local camera = Managers.state.camera

	if not camera then
		camera:set_fov_multiplier(num_3)
	end

	local clamp = math.clamp(DefaultUserSettings.get("render_settings", "fov"), num, num_2)

	return var_459_4, num, num_2, 0, "menu_settings_fov", clamp
end

OptionsView.cb_fov_saved_value = function (self, arg_460_1)
	-- function 460
	local content = arg_460_1.content
	local min = content.min
	local max = content.max
	local vertical_fov = CameraSettings.first_person._node.vertical_fov
	local var_460_4 = fn_2(self.changed_render_settings.fov, Application.user_setting("render_settings", "fov"))

	var_460_4 = var_460_4 or vertical_fov

	local clamp = math.clamp(var_460_4, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_fov = function (arg_461_0, arg_461_1)
	-- function 461
	arg_461_0.changed_render_settings.fov = arg_461_1.value
end

OptionsView.cb_enabled_crosshairs = function (arg_462_0, arg_462_1)
	-- function 462
	local options_values = arg_462_1.options_values
	local current_selection = arg_462_1.current_selection

	arg_462_0.changed_user_settings.enabled_crosshairs = options_values[current_selection]
end

OptionsView.cb_enabled_crosshairs_setup = function (arg_463_0)
	-- function 463
	local tbl = {
		{
			value = "all",
			text = Localize("menu_settings_crosshair_all")
		},
		{
			value = "melee",
			text = Localize("menu_settings_crosshair_melee")
		},
		{
			value = "ranged",
			text = Localize("menu_settings_crosshair_ranged")
		},
		{
			value = "none",
			text = Localize("menu_settings_crosshair_none")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "enabled_crosshairs")
	local user_setting = Application.user_setting("enabled_crosshairs")
	local var_463_3
	local var_463_4

	for i, v in ipairs(tbl) do
		if v.value == user_setting then
			var_463_4 = i
		end

		if v.value == get then
			var_463_3 = i
		end
	end

	fassert(var_463_3, "default option %i does not exist in cb_enabled_crosshairs_setup options table", get)

	return var_463_4 or var_463_3, tbl, "menu_settings_enabled_crosshairs", var_463_3
end

OptionsView.cb_enabled_crosshairs_saved_value = function (self, arg_464_1)
	-- function 464
	local var_464_0 = fn_2(self.changed_user_settings.enabled_crosshairs, Application.user_setting("enabled_crosshairs"))

	var_464_0 = var_464_0 or DefaultUserSettings.get("user_settings", "enabled_crosshairs")

	local options_values = arg_464_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_464_0 == options_values[i] then
			num = i

			break
		end
	end

	arg_464_1.content.current_selection = num
end

OptionsView.cb_blood_enabled_setup = function (arg_465_0)
	-- function 465
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local user_setting = Application.user_setting("blood_enabled")
	local get = DefaultUserSettings.get("user_settings", "blood_enabled")

	if user_setting == nil then
		user_setting = get
	end

	local num = 1

	if not user_setting then
		num = 2
	end

	local num_2 = 1

	if not get then
		num_2 = 2
	end

	return num, tbl, "menu_settings_blood_enabled", num_2
end

OptionsView.cb_blood_enabled_saved_value = function (self, arg_466_1)
	-- function 466
	local options_values = arg_466_1.content.options_values
	local var_466_1 = fn_2(self.changed_user_settings.blood_enabled, Application.user_setting("blood_enabled"))

	if var_466_1 == nil then
		var_466_1 = true
	end

	local num = 1

	for k, v in pairs(options_values) do
		if v == var_466_1 then
			num = k

			break
		end
	end

	arg_466_1.content.current_selection = num
	arg_466_1.content.selected_option = num
end

OptionsView.cb_blood_enabled = function (arg_467_0, arg_467_1)
	-- function 467
	local var_467_0 = arg_467_1.options_values[arg_467_1.current_selection]

	arg_467_0.changed_user_settings.blood_enabled = var_467_0
end

OptionsView.cb_screen_blood_enabled_setup = function (arg_468_0)
	-- function 468
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local user_setting = Application.user_setting("screen_blood_enabled")
	local get = DefaultUserSettings.get("user_settings", "screen_blood_enabled")

	if user_setting == nil then
		user_setting = get
	end

	local num = 1

	if not user_setting then
		num = 2
	end

	local num_2 = 1

	if not get then
		num_2 = 2
	end

	return num, tbl, "menu_settings_screen_blood_enabled", num_2
end

OptionsView.cb_screen_blood_enabled_saved_value = function (self, arg_469_1)
	-- function 469
	local options_values = arg_469_1.content.options_values
	local var_469_1 = fn_2(self.changed_user_settings.screen_blood_enabled, Application.user_setting("screen_blood_enabled"))

	if var_469_1 == nil then
		var_469_1 = true
	end

	local num = 1

	for k, v in pairs(options_values) do
		if v == var_469_1 then
			num = k

			break
		end
	end

	arg_469_1.content.current_selection = num
	arg_469_1.content.selected_option = num
end

OptionsView.cb_screen_blood_enabled = function (arg_470_0, arg_470_1)
	-- function 470
	local var_470_0 = arg_470_1.options_values[arg_470_1.current_selection]

	arg_470_0.changed_user_settings.screen_blood_enabled = var_470_0
end

OptionsView.cb_dismemberment_enabled_setup = function (arg_471_0)
	-- function 471
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local user_setting = Application.user_setting("dismemberment_enabled")
	local get = DefaultUserSettings.get("user_settings", "dismemberment_enabled")

	if user_setting == nil then
		user_setting = get
	end

	local num = 1

	if not user_setting then
		num = 2
	end

	local num_2 = 1

	if not get then
		num_2 = 2
	end

	return num, tbl, "menu_settings_dismemberment_enabled", num_2
end

OptionsView.cb_dismemberment_enabled_saved_value = function (self, arg_472_1)
	-- function 472
	local options_values = arg_472_1.content.options_values
	local var_472_1 = fn_2(self.changed_user_settings.dismemberment_enabled, Application.user_setting("dismemberment_enabled"))

	if var_472_1 == nil then
		var_472_1 = true
	end

	local num = 1

	for k, v in pairs(options_values) do
		if v == var_472_1 then
			num = k

			break
		end
	end

	arg_472_1.content.current_selection = num
	arg_472_1.content.selected_option = num
end

OptionsView.cb_dismemberment_enabled = function (arg_473_0, arg_473_1)
	-- function 473
	local var_473_0 = arg_473_1.options_values[arg_473_1.current_selection]

	arg_473_0.changed_user_settings.dismemberment_enabled = var_473_0
end

OptionsView.cb_ragdoll_enabled_setup = function (arg_474_0)
	-- function 474
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local user_setting = Application.user_setting("ragdoll_enabled")
	local get = DefaultUserSettings.get("user_settings", "ragdoll_enabled")

	if user_setting == nil then
		user_setting = get
	end

	local num = 1

	if not user_setting then
		num = 2
	end

	local num_2 = 1

	if not get then
		num_2 = 2
	end

	return num, tbl, "menu_settings_ragdoll_enabled", num_2
end

OptionsView.cb_ragdoll_enabled_saved_value = function (self, arg_475_1)
	-- function 475
	local options_values = arg_475_1.content.options_values
	local var_475_1 = fn_2(self.changed_user_settings.ragdoll_enabled, Application.user_setting("ragdoll_enabled"))

	if var_475_1 == nil then
		var_475_1 = true
	end

	local num = 1

	for k, v in pairs(options_values) do
		if v == var_475_1 then
			num = k

			break
		end
	end

	arg_475_1.content.current_selection = num
	arg_475_1.content.selected_option = num
end

OptionsView.cb_ragdoll_enabled = function (arg_476_0, arg_476_1)
	-- function 476
	local var_476_0 = arg_476_1.options_values[arg_476_1.current_selection]

	arg_476_0.changed_user_settings.ragdoll_enabled = var_476_0
end

OptionsView.cb_chat_enabled_setup = function (arg_477_0)
	-- function 477
	local tbl = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local user_setting = Application.user_setting("chat_enabled")
	local get = DefaultUserSettings.get("user_settings", "chat_enabled")

	if user_setting == nil then
		user_setting = get
	end

	local num = 1

	if not user_setting then
		num = 2
	end

	local num_2 = 1

	if not get then
		num_2 = 2
	end

	local str = "menu_settings_chat_enabled"

	if not IS_WINDOWS then
		str = "menu_settings_chat_enabled_" .. PLATFORM
	end

	return num, tbl, str, num_2
end

OptionsView.cb_chat_enabled_saved_value = function (self, arg_478_1)
	-- function 478
	local options_values = arg_478_1.content.options_values
	local var_478_1 = fn_2(self.changed_user_settings.chat_enabled, Application.user_setting("chat_enabled"))

	if var_478_1 == nil then
		var_478_1 = true
	end

	local num = 1

	for k, v in pairs(options_values) do
		if v == var_478_1 then
			num = k

			break
		end
	end

	arg_478_1.content.current_selection = num
	arg_478_1.content.selected_option = num
end

OptionsView.cb_chat_enabled = function (arg_479_0, arg_479_1)
	-- function 479
	local var_479_0 = arg_479_1.options_values[arg_479_1.current_selection]

	arg_479_0.changed_user_settings.chat_enabled = var_479_0
end

OptionsView.cb_chat_font_size = function (arg_480_0, arg_480_1)
	-- function 480
	local options_values = arg_480_1.options_values
	local current_selection = arg_480_1.current_selection

	arg_480_0.changed_user_settings.chat_font_size = options_values[current_selection]
end

OptionsView.cb_chat_font_size_setup = function (arg_481_0)
	-- function 481
	local tbl = {
		{
			text = "16",
			value = 16
		},
		{
			text = "20",
			value = 20
		},
		{
			text = "24",
			value = 24
		},
		{
			text = "28",
			value = 28
		},
		{
			text = "32",
			value = 32
		}
	}
	local get = DefaultUserSettings.get("user_settings", "chat_font_size")
	local user_setting = Application.user_setting("chat_font_size")
	local var_481_3
	local var_481_4

	for i, v in ipairs(tbl) do
		if v.value == user_setting then
			var_481_4 = i
		end

		if v.value == get then
			var_481_3 = i
		end
	end

	fassert(var_481_3, "default option %i does not exist in cb_chat_font_size_setup options table", get)

	return var_481_4 or var_481_3, tbl, "menu_settings_chat_font_size", var_481_3
end

OptionsView.cb_chat_font_size_saved_value = function (self, arg_482_1)
	-- function 482
	local var_482_0 = fn_2(self.changed_user_settings.chat_font_size, Application.user_setting("chat_font_size"))

	var_482_0 = var_482_0 or DefaultUserSettings.get("user_settings", "chat_font_size")

	local options_values = arg_482_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_482_0 == options_values[i] then
			num = i

			break
		end
	end

	arg_482_1.content.current_selection = num
end

OptionsView.cb_clan_tag_setup = function (arg_483_0)
	-- function 483
	local tbl = {
		{
			value = "0",
			text = Localize("menu_settings_none")
		}
	}
	local user_setting = Application.user_setting("clan_tag")
	local clans_short = SteamHelper.clans_short()
	local num = 2
	local num_2 = 1
	local var_483_5 = num_2

	for k, v in pairs(clans_short) do
		if v ~= "" then
			tbl[num] = {
				text = v,
				value = k
			}

			if k == user_setting then
				var_483_5 = num
			end

			num = num + 1
		end
	end

	return var_483_5, tbl, "menu_settings_clan_tag", num_2
end

OptionsView.cb_clan_tag_saved_value = function (self, arg_484_1)
	-- function 484
	local options_values = arg_484_1.content.options_values
	local var_484_1 = fn_2(self.changed_user_settings.clan_tag, Application.user_setting("clan_tag"))

	if var_484_1 == nil then
		var_484_1 = "0"
	end

	local num = 1

	for k, v in pairs(options_values) do
		if v == var_484_1 then
			num = k

			break
		end
	end

	arg_484_1.content.current_selection = num
	arg_484_1.content.selected_option = num
end

OptionsView.cb_clan_tag = function (arg_485_0, arg_485_1)
	-- function 485
	local var_485_0 = arg_485_1.options_values[arg_485_1.current_selection]

	arg_485_0.changed_user_settings.clan_tag = var_485_0
end

OptionsView.cb_blood_decals_setup = function (arg_486_0)
	-- function 486
	local num = 0
	local num_2 = 500
	local user_setting = Application.user_setting("num_blood_decals")

	user_setting = user_setting or BloodSettings.blood_decals.num_decals

	local get = DefaultUserSettings.get("user_settings", "num_blood_decals")
	local var_486_4 = fn(num, num_2, user_setting)
	local clamp = math.clamp(user_setting, num, num_2)

	BloodSettings.blood_decals.num_decals = clamp

	return var_486_4, num, num_2, 0, "menu_settings_num_blood_decals", get
end

OptionsView.cb_blood_decals_saved_value = function (self, arg_487_1)
	-- function 487
	local content = arg_487_1.content
	local min = content.min
	local max = content.max
	local var_487_3 = fn_2(self.changed_user_settings.num_blood_decals, Application.user_setting("num_blood_decals"))

	var_487_3 = var_487_3 or BloodSettings.blood_decals.num_decals

	local clamp = math.clamp(var_487_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_blood_decals = function (self, arg_488_1, arg_488_2, arg_488_3)
	-- function 488
	self.changed_user_settings.num_blood_decals = arg_488_1.value

	if not arg_488_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_dynamic_range_sound_setup = function (arg_489_0)
	-- function 489
	local tbl = {
		{
			value = "high",
			text = Localize("menu_settings_high")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "low",
			text = Localize("menu_settings_low")
		}
	}
	local get = DefaultUserSettings.get("user_settings", "dynamic_range_sound")
	local user_setting = Application.user_setting("dynamic_range_sound")

	user_setting = user_setting or get

	local num = 1

	if user_setting == "high" then
		num = 1
	elseif user_setting == "medium" then
		num = 2
	elseif user_setting == "low" then
		num = 3
	end

	local num_2 = 1

	return num, tbl, "menu_settings_dynamic_range_sound", num_2
end

OptionsView.cb_dynamic_range_sound_saved_value = function (self, arg_490_1)
	-- function 490
	local var_490_0 = fn_2(self.changed_user_settings.dynamic_range_sound, Application.user_setting("dynamic_range_sound"))

	var_490_0 = var_490_0 or "low"

	local num = 1

	if var_490_0 == "high" then
		num = 1
	elseif var_490_0 == "medium" then
		num = 2
	elseif var_490_0 == "low" then
		num = 3
	end

	arg_490_1.content.current_selection = num
end

OptionsView.cb_dynamic_range_sound = function (self, arg_491_1)
	-- function 491
	local var_491_0 = arg_491_1.options_values[arg_491_1.current_selection]

	self.changed_user_settings.dynamic_range_sound = var_491_0

	local var_491_1

	if var_491_0 == "high" then
		var_491_1 = 0
	elseif var_491_0 == "medium" then
		var_491_1 = 0.5
	elseif var_491_0 == "low" then
		var_491_1 = 1
	end

	self:set_wwise_parameter("dynamic_range_sound", var_491_1)
end

OptionsView.cb_sound_panning_rule_setup = function (arg_492_0)
	-- function 492
	local tbl = {
		{
			value = "headphones",
			text = Localize("menu_settings_headphones")
		},
		{
			value = "speakers",
			text = Localize("menu_settings_speakers")
		}
	}
	local num = 1
	local var_492_2
	local get = DefaultUserSettings.get("user_settings", "sound_panning_rule")
	local user_setting = Application.user_setting("sound_panning_rule")

	user_setting = user_setting or get

	if user_setting == "headphones" then
		num = 1
	elseif user_setting == "speakers" then
		num = 2
	end

	if get == "headphones" then
		var_492_2 = 1
	elseif get == "speakers" then
		var_492_2 = 2
	end

	return num, tbl, "menu_settings_sound_panning_rule", var_492_2
end

OptionsView.cb_sound_panning_rule_saved_value = function (self, arg_493_1)
	-- function 493
	local num = 1
	local var_493_1 = fn_2(self.changed_user_settings.sound_panning_rule, Application.user_setting("sound_panning_rule"))

	var_493_1 = var_493_1 or "headphones"

	if var_493_1 == "headphones" then
		num = 1
	elseif var_493_1 == "speakers" then
		num = 2
	end

	arg_493_1.content.current_selection = num
end

OptionsView.cb_sound_panning_rule = function (arg_494_0, arg_494_1)
	-- function 494
	local var_494_0 = arg_494_1.options_values[arg_494_1.current_selection]

	arg_494_0.changed_user_settings.sound_panning_rule = var_494_0

	if var_494_0 == "headphones" then
		Managers.music:set_panning_rule("PANNING_RULE_HEADPHONES")
	elseif var_494_0 == "speakers" then
		Managers.music:set_panning_rule("PANNING_RULE_SPEAKERS")
	end
end

OptionsView.cb_sound_quality_setup = function (arg_495_0)
	-- function 495
	local tbl = {
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		}
	}
	local user_setting = Application.user_setting("sound_quality")
	local get = DefaultUserSettings.get("user_settings", "sound_quality")
	local var_495_3

	for i = 1, #tbl do
		local value = tbl[i].value

		if user_setting == value then
			var_495_3 = i
		end

		if get == value then
			get = i
		end
	end

	return var_495_3, tbl, "menu_settings_sound_quality", get
end

OptionsView.cb_sound_quality_saved_value = function (self, arg_496_1)
	-- function 496
	local var_496_0 = fn_2(self.changed_user_settings.sound_quality, Application.user_setting("sound_quality"))
	local options_values = arg_496_1.content.options_values
	local var_496_2

	for i = 1, #options_values do
		if var_496_0 == options_values[i] then
			var_496_2 = i
		end
	end

	arg_496_1.content.current_selection = var_496_2
end

OptionsView.cb_sound_quality = function (arg_497_0, arg_497_1)
	-- function 497
	local var_497_0 = arg_497_1.options_values[arg_497_1.current_selection]

	arg_497_0.changed_user_settings.sound_quality = var_497_0
end

OptionsView.cb_animation_lod_distance_setup = function (arg_498_0)
	-- function 498
	local num = 0
	local num_2 = 1
	local user_setting = Application.user_setting("animation_lod_distance_multiplier")

	user_setting = user_setting or GameSettingsDevelopment.bone_lod_husks.lod_multiplier

	return fn(num, num_2, user_setting), num, num_2, 1, "menu_settings_animation_lod_multiplier"
end

OptionsView.cb_animation_lod_distance_saved_value = function (self, arg_499_1)
	-- function 499
	local content = arg_499_1.content
	local min = content.min
	local max = content.max
	local var_499_3 = fn_2(self.changed_user_settings.animation_lod_distance_multiplier, Application.user_setting("animation_lod_distance_multiplier"))

	var_499_3 = var_499_3 or GameSettingsDevelopment.bone_lod_husks.lod_multiplier

	local clamp = math.clamp(var_499_3, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_animation_lod_distance = function (self, arg_500_1, arg_500_2, arg_500_3)
	-- function 500
	self.changed_user_settings.animation_lod_distance_multiplier = arg_500_1.value

	if not arg_500_3 then
		self:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_player_outlines_setup = function (arg_501_0)
	-- function 501
	local tbl = {
		{
			value = "off",
			text = Localize("menu_settings_off")
		},
		{
			value = "on",
			text = Localize("menu_settings_on")
		},
		{
			value = "always_on",
			text = Localize("menu_settings_always_on")
		}
	}
	local user_setting = Application.user_setting("player_outlines")
	local get = DefaultUserSettings.get("user_settings", "player_outlines")
	local var_501_3
	local var_501_4

	for i, v in ipairs(tbl) do
		if user_setting == v.value then
			var_501_3 = i
		end

		if get == v.value then
			var_501_4 = i
		end
	end

	return var_501_3, tbl, "menu_settings_player_outlines", var_501_4
end

OptionsView.cb_player_outlines_saved_value = function (self, arg_502_1)
	-- function 502
	local var_502_0 = fn_2(self.changed_user_settings.player_outlines, Application.user_setting("player_outlines"))
	local var_502_1
	local options_values = arg_502_1.content.options_values

	for i = 1, #options_values do
		if var_502_0 == options_values[i] then
			var_502_1 = i
		end
	end

	arg_502_1.content.current_selection = var_502_1
end

OptionsView.cb_player_outlines = function (arg_503_0, arg_503_1)
	-- function 503
	local current_selection = arg_503_1.current_selection
	local var_503_1 = arg_503_1.options_values[current_selection]

	arg_503_0.changed_user_settings.player_outlines = var_503_1
end

OptionsView.cb_minion_outlines = function (arg_504_0, arg_504_1)
	-- function 504
	local current_selection = arg_504_1.current_selection
	local var_504_1 = arg_504_1.options_values[current_selection]

	arg_504_0.changed_user_settings.minion_outlines = var_504_1
end

OptionsView.cb_minion_outlines_setup = function (arg_505_0)
	-- function 505
	local tbl = {
		{
			value = "off",
			text = Localize("menu_settings_off")
		},
		{
			value = "on",
			text = Localize("menu_settings_on")
		},
		{
			value = "always_on",
			text = Localize("menu_settings_always_on")
		}
	}
	local user_setting = Application.user_setting("minion_outlines")
	local get = DefaultUserSettings.get("user_settings", "minion_outlines")
	local var_505_3
	local var_505_4

	for i, v in ipairs(tbl) do
		if user_setting == v.value then
			var_505_3 = i
		end

		if get == v.value then
			var_505_4 = i
		end
	end

	return var_505_3, tbl, "menu_settings_minion_outlines", var_505_4
end

OptionsView.cb_minion_outlines_saved_value = function (self, arg_506_1)
	-- function 506
	local var_506_0 = fn_2(self.changed_user_settings.minion_outlines, Application.user_setting("minion_outlines"))
	local var_506_1
	local options_values = arg_506_1.content.options_values

	for i = 1, #options_values do
		if var_506_0 == options_values[i] then
			var_506_1 = i
		end
	end

	arg_506_1.content.current_selection = var_506_1
end

local function fn_5(arg_507_0, arg_507_1)
	-- function 507
	local str = "cb_" .. arg_507_0
	local str_2 = str .. "_setup"

	OptionsView[str_2] = function (arg_508_0)
		-- function 508
		local tbl = {
			{
				value = false,
				text = Localize("menu_settings_off")
			},
			{
				value = true,
				text = Localize("menu_settings_on")
			}
		}
		local user_setting = Application.user_setting(arg_507_0)

		if user_setting == nil then
			user_setting = true
		end

		local flag

		flag = not user_setting and 2 and 1

		local flag_2

		flag_2 = not DefaultUserSettings.get("user_settings", arg_507_0) and 2 and 1
		GameSettingsDevelopment[arg_507_0] = user_setting

		return flag, tbl, "menu_settings_" .. arg_507_0, flag_2
	end
	OptionsView[str] = function (arg_509_0, arg_509_1)
		-- function 509
		local options_values = arg_509_1.options_values
		local current_selection = arg_509_1.current_selection

		arg_509_0.changed_user_settings[arg_507_0] = options_values[current_selection]
		GameSettingsDevelopment[arg_507_0] = options_values[current_selection]

		if arg_507_1 ~= nil then
			arg_507_1(arg_509_0, arg_509_1.current_selection == 2)
		end
	end

	local str_3 = str .. "_saved_value"

	OptionsView[str_3] = function (self, arg_510_1)
		-- function 510
		local var_510_0 = fn_2(self.changed_user_settings[arg_507_0], Application.user_setting(arg_507_0))

		if var_510_0 == nil then
			var_510_0 = true
		end

		local content = arg_510_1.content
		local flag

		flag = not var_510_0 and 2 and 1
		content.current_selection = flag
	end
end

local function fn_6(arg_511_0, arg_511_1, arg_511_2, arg_511_3, arg_511_4)
	-- function 511
	local str = "cb_" .. arg_511_0
	local str_2 = str .. "_setup"

	OptionsView[str_2] = function (arg_512_0)
		-- function 512
		local user_setting = Application.user_setting(arg_511_0)

		user_setting = user_setting or DefaultUserSettings[arg_511_0]

		local get = DefaultUserSettings.get("user_settings", arg_511_0)

		return fn(arg_511_1, arg_511_2, user_setting), arg_511_1, arg_511_2, arg_511_3, "menu_settings_" .. arg_511_0, get
	end
	OptionsView[str] = function (arg_513_0, arg_513_1)
		-- function 513
		arg_513_0.changed_user_settings[arg_511_0] = arg_513_1.value

		if arg_511_4 ~= nil then
			arg_511_4(arg_513_0, arg_513_1.internal_value)
		end
	end

	local str_3 = str .. "_saved_value"

	OptionsView[str_3] = function (self, arg_514_1)
		-- function 514
		local content = arg_514_1.content
		local var_514_1 = fn_2(self.changed_user_settings[arg_511_0], Application.user_setting(arg_511_0))
		local clamp = math.clamp(var_514_1, arg_511_1, arg_511_2)

		content.internal_value = fn(arg_511_1, arg_511_2, clamp)
		content.value = clamp
	end
end

local tbl_25 = {
	responsiveness = function (arg_515_0, arg_515_1)
		-- function 515
		Tobii.set_extended_view_responsiveness(arg_515_1)
	end,
	use_head_tracking = function (arg_516_0, arg_516_1)
		-- function 516
		Tobii.set_extended_view_use_head_tracking(arg_516_1)
	end,
	use_clean_ui = function (self, arg_517_1)
		-- function 517
		if not self.in_title_screen then
			self.ingame_ui.ingame_hud:enable_clean_ui(arg_517_1)
		end
	end
}

fn_5("tobii_eyetracking")
fn_5("tobii_extended_view")
fn_5("tobii_extended_view_use_head_tracking", tbl_25.use_head_tracking)
fn_5("tobii_aim_at_gaze")
fn_5("tobii_fire_at_gaze")
fn_5("tobii_clean_ui", tbl_25.use_clean_ui)
fn_6("tobii_extended_view_sensitivity", 1, 100, 0, tbl_25.responsiveness)

local function fn_7(arg_518_0, arg_518_1)
	-- function 518
	local var_518_0
	local flag = false

	if not (arg_518_1 == nil or arg_518_1 ~= UNASSIGNED_KEY) then
		var_518_0 = Localize(UNASSIGNED_KEY)
		flag = true
	elseif arg_518_0 == "keyboard" then
		local button_index = Keyboard.button_index(arg_518_1)

		var_518_0 = Keyboard.button_locale_name(button_index)
	elseif arg_518_0 == "mouse" then
		var_518_0 = string.format("%s %s", "mouse", arg_518_1)
	elseif arg_518_0 == "gamepad" then
		local button_index_2 = Pad1.button_index(arg_518_1)

		var_518_0 = Pad1.button_locale_name(button_index_2) ~= "" or arg_518_1
	end

	return var_518_0 == "" or not var_518_0 or TextToUpper(arg_518_1), flag
end

OptionsView.cb_keybind_setup = function (self, arg_519_1, arg_519_2, arg_519_3)
	-- function 519
	local var_519_0 = self.session_keymaps[arg_519_1][arg_519_2]
	local tbl = {}

	for i, v in ipairs(arg_519_3) do
		local var_519_2 = var_519_0[v]

		tbl[i] = {
			action = v,
			keybind = table.clone(var_519_2)
		}
	end

	local var_519_3 = tbl[1]
	local var_519_4 = fn_7(var_519_3.keybind[1], var_519_3.keybind[2])
	local var_519_5 = fn_7(var_519_3.keybind[4], var_519_3.keybind[5])
	local var_519_6 = rawget(_G, arg_519_1)[arg_519_2][arg_519_3[1]]
	local tbl_2 = {
		controller = var_519_6[1],
		key = var_519_6[2]
	}

	return var_519_4, var_519_5, tbl, tbl_2
end

OptionsView.cb_keybind_saved_value = function (self, arg_520_1)
	-- function 520
	local actions = arg_520_1.content.actions

	if not actions then
		return
	end

	local keymappings_key = arg_520_1.content.keymappings_key
	local keymappings_table_key = arg_520_1.content.keymappings_table_key
	local var_520_3 = self.original_keymaps[keymappings_key][keymappings_table_key]
	local tbl = {}

	for i, v in ipairs(actions) do
		local var_520_5 = var_520_3[v]

		tbl[i] = {
			action = v,
			keybind = table.clone(var_520_5)
		}
	end

	local var_520_6 = tbl[1]

	arg_520_1.content.selected_key_1, arg_520_1.content.is_unassigned_1 = fn_7(var_520_6.keybind[1], var_520_6.keybind[2])
	arg_520_1.content.selected_key_2, arg_520_1.content.is_unassigned_2 = fn_7(var_520_6.keybind[4], var_520_6.keybind[5])
	arg_520_1.content.actions_info = tbl
end

OptionsView.cleanup_duplicates = function (self, arg_521_1, arg_521_2)
	-- function 521
	local selected_settings_list = self.selected_settings_list
	local widgets = selected_settings_list.widgets
	local widgets_n = selected_settings_list.widgets_n

	for i = 1, widgets_n do
		local var_521_3 = widgets[i]

		if var_521_3.type == "keybind" then
			local content = var_521_3.content
			local actions_info = content.actions_info
			local var_521_6 = actions_info[1].keybind[1]

			if not (actions_info[1].keybind[2] ~= arg_521_1 or var_521_6 ~= arg_521_2) then
				content.callback(UNASSIGNED_KEY, arg_521_2, content)
			end
		end
	end
end

OptionsView.cb_keybind_changed = function (self, arg_522_1, arg_522_2, arg_522_3, arg_522_4)
	-- function 522
	local actions_info = arg_522_3.actions_info

	if not actions_info then
		return
	end

	if not (arg_522_4 ~= 2 or actions_info[1].keybind[2] ~= UNASSIGNED_KEY) then
		arg_522_4 = 1
	end

	local keybind = actions_info[1].keybind

	if not (arg_522_1 == UNASSIGNED_KEY or (keybind[1] ~= arg_522_2 or keybind[2] ~= arg_522_1 or keybind[4] ~= arg_522_2) and keybind[5] ~= arg_522_1) then
		return
	end

	local session_keymaps = self.session_keymaps
	local keymappings_key = arg_522_3.keymappings_key
	local keymappings_table_key = arg_522_3.keymappings_table_key
	local input = Managers.input

	for i, v in ipairs(actions_info) do
		local keybind_2 = v.keybind
		local action = v.action

		if arg_522_4 == 2 then
			keybind_2[4] = arg_522_2
			keybind_2[5] = arg_522_1
			keybind_2[6] = keybind_2[3]
		else
			keybind_2[1] = arg_522_2
			keybind_2[2] = arg_522_1
		end

		keybind_2.changed = true

		local var_522_8 = session_keymaps[keymappings_key][keymappings_table_key][action]

		if arg_522_4 == 2 then
			var_522_8[4] = arg_522_2
			var_522_8[5] = arg_522_1
			var_522_8[6] = var_522_8[3]
		else
			var_522_8[1] = arg_522_2
			var_522_8[2] = arg_522_1
		end

		var_522_8.changed = true
	end

	self.changed_keymaps = true

	local var_522_9, var_522_10 = fn_7(arg_522_2, arg_522_1)
	local flag

	flag = not var_522_10 and "keybind_bind_cancel" and "keybind_bind_success"

	local str = "{#color(193,91,36)}" .. Utf8.upper(Localize(arg_522_3.text)) .. "{#reset()}"
	local upper = Utf8.upper(var_522_9)

	self.keybind_info_text = string.format(Localize(flag), str, upper)

	local var_522_14 = UIAnimation.init(UIAnimation.function_by_time, self.keybind_info_widget.style.text.text_color, 1, 0, 255, 0.4, math.easeOutCubic)

	self.ui_animations.keybind_info_attract = var_522_14

	if arg_522_4 == 1 then
		arg_522_3.selected_key_1, arg_522_3.is_unassigned_1 = var_522_9, var_522_10
	else
		arg_522_3.selected_key_2, arg_522_3.is_unassigned_2 = var_522_9, var_522_10
	end
end

OptionsView.cb_twitch_vote_time = function (arg_523_0, arg_523_1)
	-- function 523
	local var_523_0 = arg_523_1.options_values[arg_523_1.current_selection]

	arg_523_0.changed_user_settings.twitch_vote_time = var_523_0
end

OptionsView.cb_twitch_vote_time_setup = function (arg_524_0)
	-- function 524
	local tbl = {
		{
			text = "15",
			value = 15
		},
		{
			text = "30",
			value = 30
		},
		{
			text = "45",
			value = 45
		},
		{
			text = "60",
			value = 60
		},
		{
			text = "75",
			value = 75
		},
		{
			text = "90",
			value = 90
		}
	}
	local get = DefaultUserSettings.get("user_settings", "twitch_vote_time")
	local user_setting = Application.user_setting("twitch_vote_time")
	local var_524_3
	local var_524_4

	for i, v in ipairs(tbl) do
		if v.value == user_setting then
			var_524_4 = i
		end

		if v.value == get then
			var_524_3 = i
		end
	end

	fassert(var_524_3, "default option %i does not exist in cb_chat_font_size_setup options table", get)

	return var_524_4 or var_524_3, tbl, "menu_settings_twitch_vote_time", var_524_3
end

OptionsView.cb_twitch_vote_time_saved_value = function (self, arg_525_1)
	-- function 525
	local var_525_0 = fn_2(self.changed_user_settings.twitch_vote_time, Application.user_setting("twitch_vote_time"))

	var_525_0 = var_525_0 or DefaultUserSettings.get("user_settings", "twitch_vote_time")

	local options_values = arg_525_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_525_0 == options_values[i] then
			num = i

			break
		end
	end

	arg_525_1.content.current_selection = num
end

OptionsView.cb_twitch_time_between_votes = function (arg_526_0, arg_526_1)
	-- function 526
	local var_526_0 = arg_526_1.options_values[arg_526_1.current_selection]

	arg_526_0.changed_user_settings.twitch_time_between_votes = var_526_0
end

OptionsView.cb_twitch_time_between_votes_setup = function (arg_527_0)
	-- function 527
	local tbl = {
		{
			text = "5",
			value = 5
		},
		{
			text = "15",
			value = 15
		},
		{
			text = "30",
			value = 30
		},
		{
			text = "45",
			value = 45
		},
		{
			text = "60",
			value = 60
		},
		{
			text = "75",
			value = 75
		},
		{
			text = "90",
			value = 90
		}
	}
	local get = DefaultUserSettings.get("user_settings", "twitch_time_between_votes")
	local user_setting = Application.user_setting("twitch_time_between_votes")
	local var_527_3
	local var_527_4

	for i, v in ipairs(tbl) do
		if v.value == user_setting then
			var_527_4 = i
		end

		if v.value == get then
			var_527_3 = i
		end
	end

	fassert(var_527_3, "default option %i does not exist in cb_chat_font_size_setup options table", get)

	return var_527_4 or var_527_3, tbl, "menu_settings_twitch_time_between_votes", var_527_3
end

OptionsView.cb_twitch_time_between_votes_saved_value = function (self, arg_528_1)
	-- function 528
	local var_528_0 = fn_2(self.changed_user_settings.twitch_time_between_votes, Application.user_setting("twitch_time_between_votes"))

	var_528_0 = var_528_0 or DefaultUserSettings.get("user_settings", "twitch_time_between_votes")

	local options_values = arg_528_1.content.options_values
	local num = 1

	for i = 1, #options_values do
		if var_528_0 == options_values[i] then
			num = i

			break
		end
	end

	arg_528_1.content.current_selection = num
end

OptionsView.cb_twitch_difficulty_setup = function (arg_529_0)
	-- function 529
	local num = 0
	local num_2 = 100
	local user_setting = Application.user_setting("twitch_difficulty")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "twitch_difficulty")

	local get = DefaultUserSettings.get("user_settings", "twitch_difficulty")

	return fn(num, num_2, user_setting), num, num_2, 0, "menu_settings_twitch_difficulty", get
end

OptionsView.cb_twitch_difficulty_saved_value = function (self, arg_530_1)
	-- function 530
	local content = arg_530_1.content
	local min = content.min
	local max = content.max
	local var_530_3 = fn_2
	local twitch_difficulty = self.changed_user_settings.twitch_difficulty
	local user_setting = Application.user_setting("twitch_difficulty")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "twitch_difficulty")

	local var_530_6 = var_530_3(twitch_difficulty, user_setting)
	local clamp = math.clamp(var_530_6, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_twitch_difficulty = function (arg_531_0, arg_531_1)
	-- function 531
	local value = arg_531_1.value

	arg_531_0.changed_user_settings.twitch_difficulty = value
end

OptionsView.cb_twitch_spawn_amount_setup = function (arg_532_0)
	-- function 532
	local num = 100
	local num_2 = 300
	local get = DefaultUserSettings.get("user_settings", "twitch_spawn_amount")
	local user_setting = Application.user_setting("twitch_spawn_amount")

	user_setting = user_setting or get

	local num_3 = 100 * user_setting

	return fn(num, num_2, num_3), num, num_2, 0, "menu_settings_twitch_spawn_amount", 100 * get
end

OptionsView.cb_twitch_spawn_amount_saved_value = function (self, arg_533_1)
	-- function 533
	local content = arg_533_1.content
	local min = content.min
	local max = content.max
	local _get_setting = self:_get_setting("user_settings", "twitch_spawn_amount")

	_get_setting = _get_setting or content.default_value

	local num = 100 * _get_setting
	local clamp = math.clamp(num, min, max)

	content.internal_value = fn(min, max, clamp)
	content.value = clamp
end

OptionsView.cb_twitch_spawn_amount = function (arg_534_0, arg_534_1, arg_534_2, arg_534_3)
	-- function 534
	arg_534_0.changed_user_settings.twitch_spawn_amount = 0.01 * arg_534_1.value
end
