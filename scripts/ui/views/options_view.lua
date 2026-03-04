-- chunkname: @scripts/ui/views/options_view.lua

require("scripts/ui/views/ui_calibration_view")

OptionsView = class(OptionsView)

local var_0_0 = local_require("scripts/ui/views/options_view_definitions")
local var_0_1 = local_require("scripts/ui/views/options_view_settings")
local var_0_2 = var_0_0.gamepad_frame_widget_definitions
local var_0_3 = var_0_0.background_widget_definitions
local var_0_4 = var_0_0.widget_definitions
local var_0_5 = var_0_1.title_button_definitions
local var_0_6 = var_0_0.button_definitions
local var_0_7 = var_0_0.child_input_services
local var_0_8 = var_0_0.animation_definitions
local var_0_9 = SettingsMenuNavigation
local var_0_10 = SettingsWidgetTypeTemplate

local function var_0_11(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1 - arg_1_0

	return (math.clamp(arg_1_2, arg_1_0, arg_1_1) - arg_1_0) / var_1_0
end

local function var_0_12(arg_2_0, arg_2_1)
	if arg_2_0 == nil then
		return arg_2_1
	else
		return arg_2_0
	end
end

local var_0_13 = {
	main_menu = {
		default = {
			{
				priority = 49,
				description_text = "input_description_information",
				ignore_keybinding = true,
				input_action = IS_PS4 and "l2" or "left_trigger"
			},
			{
				input_action = "l1_r1",
				priority = 49,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			},
			{
				input_action = "back",
				priority = 50,
				description_text = "input_description_close"
			}
		},
		reset = {
			{
				priority = 46,
				description_text = "input_description_information",
				ignore_keybinding = true,
				input_action = IS_PS4 and "l2" or "left_trigger"
			},
			{
				input_action = "l1_r1",
				priority = 47,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			},
			{
				input_action = "special_1",
				priority = 49,
				description_text = "input_description_reset"
			},
			{
				input_action = "back",
				priority = 50,
				description_text = "input_description_close"
			}
		},
		reset_and_apply = {
			{
				priority = 45,
				description_text = "input_description_information",
				ignore_keybinding = true,
				input_action = IS_PS4 and "l2" or "left_trigger"
			},
			{
				input_action = "l1_r1",
				priority = 46,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			},
			{
				input_action = "special_1",
				priority = 48,
				description_text = "input_description_reset"
			},
			{
				input_action = "refresh",
				priority = 49,
				description_text = "input_description_apply"
			},
			{
				input_action = "back",
				priority = 50,
				description_text = "input_description_close"
			}
		},
		apply = {
			{
				priority = 46,
				description_text = "input_description_information",
				ignore_keybinding = true,
				input_action = IS_PS4 and "l2" or "left_trigger"
			},
			{
				input_action = "l1_r1",
				priority = 47,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			},
			{
				input_action = "refresh",
				priority = 49,
				description_text = "input_description_apply"
			},
			{
				input_action = "back",
				priority = 50,
				description_text = "input_description_close"
			}
		}
	},
	sub_menu = {
		default = {
			{
				priority = 47,
				description_text = "input_description_information",
				ignore_keybinding = true,
				input_action = IS_PS4 and "l2" or "left_trigger"
			},
			{
				input_action = "l1_r1",
				priority = 48,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			},
			{
				input_action = "back",
				priority = 50,
				description_text = "input_description_back"
			}
		},
		reset = {
			{
				priority = 47,
				description_text = "input_description_information",
				ignore_keybinding = true,
				input_action = IS_PS4 and "l2" or "left_trigger"
			},
			{
				input_action = "l1_r1",
				priority = 48,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			},
			{
				input_action = "special_1",
				priority = 50,
				description_text = "input_description_reset"
			},
			{
				input_action = "back",
				priority = 51,
				description_text = "input_description_back"
			}
		},
		reset_and_apply = {
			{
				priority = 46,
				description_text = "input_description_information",
				ignore_keybinding = true,
				input_action = IS_PS4 and "l2" or "left_trigger"
			},
			{
				input_action = "l1_r1",
				priority = 47,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			},
			{
				input_action = "special_1",
				priority = 49,
				description_text = "input_description_reset"
			},
			{
				input_action = "refresh",
				priority = 50,
				description_text = "input_description_apply"
			},
			{
				input_action = "back",
				priority = 51,
				description_text = "input_description_back"
			}
		},
		apply = {
			{
				priority = 47,
				description_text = "input_description_information",
				ignore_keybinding = true,
				input_action = IS_PS4 and "l2" or "left_trigger"
			},
			{
				input_action = "l1_r1",
				priority = 48,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			},
			{
				input_action = "refresh",
				priority = 50,
				description_text = "input_description_apply"
			},
			{
				input_action = "back",
				priority = 51,
				description_text = "input_description_back"
			}
		}
	}
}
local var_0_14 = {
	activate_chat_input = {
		"left",
		"right",
		"left_double",
		"right_double"
	}
}

local function var_0_15(arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in ipairs(arg_3_0) do
		local var_3_0 = var_0_14[iter_3_1]

		if var_3_0 then
			for iter_3_2, iter_3_3 in ipairs(var_3_0) do
				if iter_3_3 == arg_3_1 then
					return false
				end
			end
		end
	end

	return true
end

local var_0_16 = 1

OptionsView.init = function (arg_4_0, arg_4_1)
	arg_4_0.ui_renderer = arg_4_1.ui_renderer
	arg_4_0.ui_top_renderer = arg_4_1.ui_top_renderer
	arg_4_0.ingame_ui = arg_4_1.ingame_ui
	arg_4_0.voip = arg_4_1.voip
	arg_4_0.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = false
	}
	arg_4_0.is_in_tutorial = arg_4_1.is_in_tutorial
	arg_4_0.in_title_screen = arg_4_1.in_title_screen
	arg_4_0.platform = PLATFORM

	local var_4_0 = arg_4_1.input_manager

	var_4_0:create_input_service("options_menu", "IngameMenuKeymaps", "IngameMenuFilters")
	var_4_0:map_device_to_service("options_menu", "keyboard")
	var_4_0:map_device_to_service("options_menu", "mouse")
	var_4_0:map_device_to_service("options_menu", "gamepad")

	arg_4_0.input_manager = var_4_0
	arg_4_0.controller_cooldown = 0

	if GLOBAL_MUSIC_WORLD then
		arg_4_0.wwise_world = MUSIC_WWISE_WORLD
	else
		local var_4_1 = arg_4_1.world_manager:world("music_world")

		arg_4_0.wwise_world = Managers.world:wwise_world(var_4_1)
	end

	arg_4_0.ui_animations = {}

	arg_4_0:reset_changed_settings()

	arg_4_0.overriden_settings = Application.user_setting("overriden_settings") or {}

	arg_4_0:create_ui_elements()

	local var_4_2 = var_4_0:get_service("options_menu")
	local var_4_3 = var_0_0.scenegraph_definition.root.position[3]

	arg_4_0.menu_input_description = MenuInputDescriptionUI:new(arg_4_1, arg_4_0.ui_top_renderer, var_4_2, 7, var_4_3, var_0_13.main_menu.reset)

	arg_4_0:_setup_input_functions()
end

OptionsView._setup_input_functions = function (arg_5_0)
	arg_5_0._input_functions = {
		checkbox = function (arg_6_0, arg_6_1, arg_6_2)
			if arg_6_0.content.hotspot.on_release then
				WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_select")
				arg_6_0.content.callback(arg_6_0.content)
			end
		end,
		option = function (arg_7_0, arg_7_1, arg_7_2)
			local var_7_0 = arg_7_0.content
			local var_7_1 = var_7_0.num_options
			local var_7_2 = var_7_0.current_selection

			for iter_7_0 = 1, var_7_1 do
				if var_7_0["option_" .. iter_7_0].on_release and var_7_2 ~= iter_7_0 then
					WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_select")

					var_7_0.current_selection = iter_7_0

					var_7_0.callback(arg_7_0.content)

					return
				end
			end
		end,
		slider = function (arg_8_0, arg_8_1, arg_8_2)
			local var_8_0 = arg_8_0.content
			local var_8_1 = arg_8_0.style
			local var_8_2 = var_8_0.left_hotspot
			local var_8_3 = var_8_0.right_hotspot
			local var_8_4 = var_8_0.callback_on_release

			if var_8_0.changed then
				var_8_0.changed = nil

				var_8_0.callback(var_8_0, var_8_1)
			end

			if arg_8_1:get("left_hold") then
				var_8_0.altering_value = true
			else
				var_8_0.altering_value = nil
			end

			local var_8_5 = var_8_0.input_cooldown
			local var_8_6 = var_8_0.input_cooldown_multiplier
			local var_8_7 = false

			if var_8_5 then
				var_8_7 = true

				local var_8_8 = math.max(var_8_5 - arg_8_2, 0)

				var_8_5 = var_8_8 > 0 and var_8_8 or nil
				var_8_0.input_cooldown = var_8_5
			end

			local var_8_9 = var_8_0.internal_value
			local var_8_10 = var_8_0.num_decimals
			local var_8_11 = var_8_0.min
			local var_8_12 = 1 / ((var_8_0.max - var_8_11) * 10^var_8_10)
			local var_8_13 = false

			if var_8_2.is_clicked == 0 or var_8_2.on_release then
				var_8_9 = math.clamp(var_8_9 - var_8_12, 0, 1)
				var_8_13 = true
			elseif var_8_3.is_clicked == 0 or var_8_3.on_release then
				var_8_9 = math.clamp(var_8_9 + var_8_12, 0, 1)
				var_8_13 = true
			end

			if var_8_13 then
				if not var_8_5 then
					var_8_0.internal_value = var_8_9

					if not var_8_4 or var_8_2.on_release or var_8_3.on_release then
						var_8_0.changed = true
					end

					if var_8_7 then
						local var_8_14 = math.max(var_8_6 - 0.1, 0.1)

						var_8_0.input_cooldown = 0.2 * math.ease_in_exp(var_8_14)
						var_8_0.input_cooldown_multiplier = var_8_14
					else
						local var_8_15 = 1

						var_8_0.input_cooldown = 0.2 * math.ease_in_exp(var_8_15)
						var_8_0.input_cooldown_multiplier = var_8_15
					end
				elseif var_8_4 and (var_8_2.on_release or var_8_3.on_release) then
					var_8_0.internal_value = var_8_9
					var_8_0.changed = true
				end
			end
		end,
		drop_down = function (arg_9_0, arg_9_1, arg_9_2)
			local var_9_0 = arg_9_0.content
			local var_9_1 = arg_9_0.style.list_style
			local var_9_2 = var_9_0.list_content
			local var_9_3 = var_9_1.item_styles
			local var_9_4 = var_9_1.start_index
			local var_9_5 = var_9_1.num_draws
			local var_9_6 = var_9_1.total_draws
			local var_9_7 = var_9_0.using_scrollbar
			local var_9_8 = var_9_0.thumbnail_hotspot

			if not var_9_0.active then
				local var_9_9 = var_9_0.hotspot

				if var_9_9.on_hover_enter then
					WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_hover")
				end

				local var_9_10 = var_9_0.current_selection

				if var_9_9.on_release and var_9_10 then
					var_9_0.active = true
					var_9_1.active = true
					arg_5_0.disable_all_input = true

					if var_9_7 then
						local var_9_11 = var_9_6 - var_9_5

						var_9_1.start_index = math.min(var_9_10, var_9_11)
						var_9_8.scroll_progress = (var_9_1.start_index - 1) / var_9_11
					end

					WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_select")
				end
			else
				local var_9_12 = var_9_0.options_texts

				for iter_9_0 = var_9_4, var_9_4 - 1 + var_9_5 do
					local var_9_13 = var_9_2[iter_9_0].hotspot

					if not var_9_13.disabled then
						if var_9_13.on_hover_enter then
							WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_hover")
						end

						if var_9_13.on_release then
							WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_select")

							var_9_0.current_selection = iter_9_0

							var_9_0.callback(var_9_0)

							var_9_0.active = false
							var_9_1.active = false
							arg_5_0.disable_all_input = false

							break
						end
					end
				end

				local var_9_14 = var_9_0.was_dragging
				local var_9_15 = var_9_0.dragging

				var_9_0.was_dragging = var_9_15

				if not Managers.input:is_device_active("gamepad") then
					if var_9_7 then
						local var_9_16 = arg_9_1:get("scroll_axis")

						if var_9_16 then
							local var_9_17 = var_9_16.y
							local var_9_18 = false

							if var_9_17 > 0 then
								var_9_18 = true
								var_9_1.start_index = math.max(var_9_4 - 1, 1)
							elseif var_9_17 < 0 then
								var_9_18 = true
								var_9_1.start_index = math.min(var_9_4 + 1, var_9_6 - var_9_5 + 1)
							end

							if var_9_18 then
								local var_9_19 = var_9_1.start_index
								local var_9_20 = var_9_6 - var_9_5

								var_9_8.scroll_progress = (var_9_19 - 1) / var_9_20
							end
						end
					end

					if arg_9_1:get("left_release") and not var_9_15 and not var_9_14 then
						var_9_0.active = false
						var_9_1.active = false
						arg_5_0.disable_all_input = false

						WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_select")
					end
				end
			end
		end,
		stepper = function (arg_10_0, arg_10_1, arg_10_2)
			local var_10_0 = arg_10_0.content
			local var_10_1 = var_10_0.current_selection or 0
			local var_10_2 = var_10_1
			local var_10_3 = var_10_0.left_hotspot
			local var_10_4 = var_10_0.right_hotspot

			if var_10_3.on_release or var_10_0.controller_on_release_left then
				var_10_0.controller_on_release_left = nil
				var_10_2 = var_10_2 - 1

				if var_10_2 == 0 then
					var_10_2 = var_10_0.num_options
				end
			end

			if var_10_4.on_release or var_10_0.controller_on_release_right then
				var_10_0.controller_on_release_right = nil
				var_10_2 = var_10_2 + 1

				if var_10_2 > var_10_0.num_options then
					var_10_2 = 1
				end
			end

			if var_10_2 ~= var_10_1 then
				WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_select")

				local var_10_5 = arg_10_0.style

				var_10_0.current_selection = var_10_2

				var_10_0.callback(var_10_0, var_10_5)
			end
		end,
		keybind = function (arg_11_0, arg_11_1, arg_11_2)
			if Managers.input:is_device_active("gamepad") then
				return
			end

			local var_11_0 = arg_11_0.content
			local var_11_1 = var_11_0.active

			if not var_11_1 then
				if var_11_0.hotspot_1.on_release then
					var_11_1 = true
					var_11_0.active_1 = true
				elseif var_11_0.hotspot_2.on_release then
					var_11_1 = true
					var_11_0.active_2 = true
				elseif var_11_0.hotspot_1.on_right_click then
					local var_11_2 = var_11_0.actions_info[1].keybind
					local var_11_3 = var_11_2[4] or "keyboard"
					local var_11_4 = var_11_2[5] or UNASSIGNED_KEY

					var_11_0.callback(UNASSIGNED_KEY, "keyboard", var_11_0, 2)
					var_11_0.callback(var_11_4, var_11_3, var_11_0, 1)
				elseif var_11_0.hotspot_2.on_right_click then
					var_11_0.callback(UNASSIGNED_KEY, "keyboard", var_11_0, 2)
				end

				if var_11_1 then
					var_11_0.active = true
					var_11_0.active_t = 0
					arg_5_0.disable_all_input = true

					arg_5_0.input_manager:block_device_except_service("options_menu", "keyboard", 1, "keybind")
					arg_5_0.input_manager:block_device_except_service("options_menu", "mouse", 1, "keybind")
					arg_5_0.input_manager:block_device_except_service("options_menu", "gamepad", 1, "keybind")
					WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_select")
				end
			else
				local var_11_5 = false
				local var_11_6 = var_11_0.active_1 and 1 or 2

				if var_11_0.controller_input_pressed then
					var_11_5 = true
				end

				local var_11_7 = Keyboard.any_released()

				if not var_11_5 and var_11_7 == 27 then
					var_11_5 = true
				end

				if not var_11_5 and var_11_7 ~= nil then
					local var_11_8 = Keyboard.button_name(var_11_7)

					if var_11_8 and var_11_8 ~= "" then
						var_11_0.callback(var_11_8, "keyboard", var_11_0, var_11_6)

						var_11_5 = true
					end
				end

				local var_11_9 = Mouse.any_released()

				if not var_11_5 and var_11_9 ~= nil then
					local var_11_10 = Mouse.button_name(var_11_9)

					if var_0_15(var_11_0.actions, var_11_10) then
						var_11_0.callback(var_11_10, "mouse", var_11_0, var_11_6)

						var_11_5 = true
					end
				end

				if var_11_5 then
					var_11_0.controller_input_pressed = nil
					var_11_0.active = false
					var_11_0.active_1 = false
					var_11_0.active_2 = false
					arg_5_0.disable_all_input = false

					arg_5_0.input_manager:device_unblock_all_services("keyboard", 1)
					arg_5_0.input_manager:device_unblock_all_services("mouse", 1)
					arg_5_0.input_manager:device_unblock_all_services("gamepad", 1)
					arg_5_0.input_manager:block_device_except_service("options_menu", "keyboard", 1)
					arg_5_0.input_manager:block_device_except_service("options_menu", "mouse", 1)
					arg_5_0.input_manager:block_device_except_service("options_menu", "gamepad", 1)
				end
			end
		end,
		sorted_list = function (arg_12_0, arg_12_1, arg_12_2)
			local var_12_0 = arg_12_0.content
			local var_12_1 = arg_12_0.style
			local var_12_2 = var_12_0.list_content
			local var_12_3 = var_12_1.list_style.item_styles
			local var_12_4 = var_12_0.current_selection
			local var_12_5 = var_12_2[var_12_4]
			local var_12_6 = arg_5_0.wwise_world
			local var_12_7 = #var_12_2
			local var_12_8 = var_12_0.up_hotspot
			local var_12_9 = var_12_0.down_hotspot

			if var_12_8.on_hover_enter or var_12_9.on_hover_enter then
				WwiseWorld.trigger_event(var_12_6, "Play_hud_hover")
			end

			if var_12_4 then
				if var_12_4 > 1 then
					if not var_12_8.active then
						var_12_8.active = true
					end
				elseif var_12_8.active then
					var_12_8.active = false
				end

				if var_12_4 < var_12_7 then
					if not var_12_9.active then
						var_12_9.active = true
					end
				elseif var_12_9.active then
					var_12_9.active = false
				end
			elseif var_12_8.active or var_12_9.active then
				var_12_8.active = false
				var_12_9.active = false
			end

			if var_12_8.on_release or var_12_9.on_release then
				local var_12_10 = var_12_0.current_selection
				local var_12_11

				if var_12_8.on_release then
					var_12_11 = var_12_10 - 1
				else
					var_12_11 = var_12_10 + 1
				end

				var_12_2[var_12_10].index_text, var_12_2[var_12_11].index_text = var_12_2[var_12_11].index_text, var_12_2[var_12_10].index_text
				var_12_2[var_12_10], var_12_2[var_12_11] = var_12_2[var_12_11], var_12_2[var_12_10]
				var_12_3[var_12_10], var_12_3[var_12_11] = var_12_3[var_12_11], var_12_3[var_12_10]
				var_12_0.current_selection = var_12_11

				WwiseWorld.trigger_event(var_12_6, "Play_hud_select")
				var_12_0.callback(var_12_0, var_12_1)
			else
				for iter_12_0 = 1, var_12_7 do
					local var_12_12 = var_12_2[iter_12_0]

					if var_12_12 ~= var_12_5 then
						local var_12_13 = var_12_12.hotspot

						if var_12_13.on_hover_enter then
							WwiseWorld.trigger_event(var_12_6, "Play_hud_hover")
						end

						if var_12_13.on_release then
							WwiseWorld.trigger_event(var_12_6, "Play_hud_select")

							var_12_0.current_selection = iter_12_0
							var_12_13.is_selected = true

							if var_12_5 then
								var_12_5.hotspot.is_selected = false
							end

							break
						end
					end
				end
			end
		end,
		text_link = function (arg_13_0, arg_13_1, arg_13_2)
			local var_13_0 = arg_13_0.content

			if var_13_0.hotspot.on_release or var_13_0.controller_input_pressed then
				var_13_0.controller_input_pressed = nil

				local var_13_1 = arg_13_0.content.url

				if var_13_1 then
					WwiseWorld.trigger_event(arg_5_0.wwise_world, "Play_hud_select")
					Application.open_url_in_browser(var_13_1)
				end
			end
		end,
		image = function ()
			return
		end,
		title = function ()
			return
		end,
		gamepad_layout = function ()
			return
		end
	}
end

OptionsView.input_service = function (arg_17_0)
	return arg_17_0.input_manager:get_service("options_menu")
end

OptionsView.cleanup_popups = function (arg_18_0)
	if arg_18_0.save_data_error_popup_id then
		Managers.popup:cancel_popup(arg_18_0.save_data_error_popup_id)

		arg_18_0.save_data_error_popup_id = nil
	end

	if arg_18_0.apply_popup_id then
		Managers.popup:cancel_popup(arg_18_0.apply_popup_id)

		arg_18_0.apply_popup_id = nil

		arg_18_0:handle_apply_popup_results("revert_changes")
	end

	if arg_18_0.apply_bot_spawn_priority_popup_id then
		Managers.popup:cancel_popup(arg_18_0.apply_bot_spawn_priority_popup_id)

		arg_18_0.apply_bot_spawn_priority_popup_id = nil
	end

	if arg_18_0.title_popup_id then
		Managers.popup:cancel_popup(arg_18_0.title_popup_id)

		arg_18_0.title_popup_id = nil
	end

	if arg_18_0.exit_popup_id then
		Managers.popup:cancel_popup(arg_18_0.exit_popup_id)

		arg_18_0.exit_popup_id = nil
	end

	if arg_18_0.reset_popup_id then
		Managers.popup:cancel_popup(arg_18_0.reset_popup_id)

		arg_18_0.reset_popup_id = nil
	end
end

OptionsView.destroy = function (arg_19_0)
	arg_19_0:cleanup_popups()

	if arg_19_0._cursor_pushed then
		ShowCursorStack.hide("OptionsView")

		arg_19_0._cursor_pushed = nil
	end

	arg_19_0.menu_input_description:destroy()

	arg_19_0.menu_input_description = nil

	GarbageLeakDetector.register_object(arg_19_0, "OptionsView")
end

RELOAD_OPTIONS_VIEW = true

OptionsView.create_ui_elements = function (arg_20_0)
	arg_20_0.background_widgets = {}

	local var_20_0 = 0

	for iter_20_0, iter_20_1 in pairs(var_0_3) do
		var_20_0 = var_20_0 + 1
		arg_20_0.background_widgets[var_20_0] = UIWidget.init(iter_20_1)

		if iter_20_0 == "right_frame" then
			arg_20_0.scroll_field_widget = arg_20_0.background_widgets[var_20_0]
		end
	end

	arg_20_0.background_widgets_n = var_20_0
	arg_20_0.gamepad_tooltip_text_widget = UIWidget.init(var_0_2.gamepad_tooltip_text)
	arg_20_0.keybind_info_widget = UIWidget.init(var_0_4.keybind_info)
	arg_20_0.title_buttons = {}

	local var_20_1 = 0

	for iter_20_2, iter_20_3 in ipairs(var_0_5) do
		var_20_1 = var_20_1 + 1
		arg_20_0.title_buttons[var_20_1] = UIWidget.init(iter_20_3)
	end

	arg_20_0.title_buttons_n = var_20_1

	if arg_20_0.is_in_tutorial then
		for iter_20_4, iter_20_5 in ipairs(arg_20_0.title_buttons) do
			if not TutorialSettingsMenuNavigation[iter_20_4] then
				iter_20_5.content.button_text.disable_button = true
			end
		end
	end

	arg_20_0.exit_button = UIWidget.init(var_0_6.exit_button)
	arg_20_0.apply_button = UIWidget.init(var_0_6.apply_button)
	arg_20_0.reset_to_default = UIWidget.init(var_0_6.reset_to_default)
	arg_20_0.back_button = UIWidget.init(var_0_6.back_button)
	arg_20_0.scrollbar = UIWidget.init(var_0_0.scrollbar_definition)
	arg_20_0.scrollbar.content.disable_frame = true
	arg_20_0.safe_rect_widget = UIWidget.init(var_0_0.create_safe_rect_widget())

	local var_20_2 = {
		hide_reset = true,
		widgets_n = 0,
		scenegraph_id_start = "calibrate_ui_dummy",
		widgets = {}
	}
	local var_20_3 = {}

	if IS_WINDOWS then
		if rawget(_G, "Tobii") then
			local var_20_4
			local var_20_5 = Tobii.get_is_connected()

			arg_20_0._tobii_is_connected = var_20_5

			if var_20_5 then
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

			local var_20_6 = arg_20_0:build_settings_list(var_20_4, "tobii_eyetracking_settings_list")

			var_20_3.tobii_eyetracking_settings = var_20_6

			var_20_6.on_enter = function (arg_21_0)
				local var_21_0 = Managers.player:players()

				for iter_21_0, iter_21_1 in pairs(var_21_0) do
					local var_21_1 = iter_21_1.player_unit

					if iter_21_1.local_player and ScriptUnit.has_extension(var_21_1, "eyetracking_system") then
						ScriptUnit.extension(var_21_1, "eyetracking_system"):set_eyetracking_options_opened(true)
					end
				end
			end

			var_20_6.on_exit = function ()
				local var_22_0 = Managers.player:players()

				for iter_22_0, iter_22_1 in pairs(var_22_0) do
					local var_22_1 = iter_22_1.player_unit

					if iter_22_1.local_player and ScriptUnit.has_extension(var_22_1, "eyetracking_system") then
						ScriptUnit.extension(var_22_1, "eyetracking_system"):set_eyetracking_options_opened(false)
					end
				end
			end
		end

		var_20_3.video_settings = arg_20_0:build_settings_list(var_0_1.video_settings_definition, "video_settings_list")

		if Managers.voice_chat or arg_20_0.voip then
			var_20_3.audio_settings = arg_20_0:build_settings_list(var_0_1.audio_settings_definition, "audio_settings_list")
		else
			var_20_3.audio_settings = arg_20_0:build_settings_list(var_0_1.audio_settings_definition_without_voip, "audio_settings_list")
		end

		var_20_3.gameplay_settings = arg_20_0:build_settings_list(var_0_1.gameplay_settings_definition, "gameplay_settings_list")
		var_20_3.display_settings = arg_20_0:build_settings_list(var_0_1.display_settings_definition, "display_settings_list")
		var_20_3.keybind_settings = arg_20_0:build_settings_list(var_0_1.keybind_settings_definition, "keybind_settings_list")
		var_20_3.gamepad_settings = arg_20_0:build_settings_list(var_0_1.gamepad_settings_definition, "gamepad_settings_list")
		var_20_3.network_settings = arg_20_0:build_settings_list(var_0_1.network_settings_definition, "network_settings_list")
		var_20_3.versus_settings = arg_20_0:build_settings_list(var_0_1.versus_settings_definition, "versus_settings_list")
		var_20_3.video_settings.hide_reset = true
		var_20_3.video_settings.needs_apply_confirmation = true
	elseif IS_XB1 then
		if Managers.voice_chat or arg_20_0.voip then
			var_20_3.audio_settings = arg_20_0:build_settings_list(var_0_1.audio_settings_definition, "audio_settings_list")
		else
			var_20_3.audio_settings = arg_20_0:build_settings_list(var_0_1.audio_settings_definition_without_voip, "audio_settings_list")
		end

		var_20_3.gameplay_settings = arg_20_0:build_settings_list(var_0_1.gameplay_settings_definition, "gameplay_settings_list")
		var_20_3.display_settings = arg_20_0:build_settings_list(var_0_1.display_settings_definition, "display_settings_list")
		var_20_3.gamepad_settings = arg_20_0:build_settings_list(var_0_1.gamepad_settings_definition, "gamepad_settings_list")

		if GameSettingsDevelopment.allow_keyboard_mouse then
			var_20_3.keybind_settings = arg_20_0:build_settings_list(var_0_1.keybind_settings_definition, "keybind_settings_list")
		end

		var_20_3.accessibility_settings = arg_20_0:build_settings_list(var_0_1.accessibility_settings_definition, "accessibility_settings_list")
	else
		if Managers.voice_chat or arg_20_0.voip then
			var_20_3.audio_settings = arg_20_0:build_settings_list(var_0_1.audio_settings_definition, "audio_settings_list")
		else
			var_20_3.audio_settings = arg_20_0:build_settings_list(var_0_1.audio_settings_definition_without_voip, "audio_settings_list")
		end

		var_20_3.gameplay_settings = arg_20_0:build_settings_list(var_0_1.gameplay_settings_definition, "gameplay_settings_list")
		var_20_3.display_settings = arg_20_0:build_settings_list(var_0_1.display_settings_definition, "display_settings_list")
		var_20_3.gamepad_settings = arg_20_0:build_settings_list(var_0_1.gamepad_settings_definition, "gamepad_settings_list")
		var_20_3.motion_control_settings = arg_20_0:build_settings_list(var_0_1.motion_control_settings_definition, "motion_control_settings_list")
		var_20_3.accessibility_settings = arg_20_0:build_settings_list(var_0_1.accessibility_settings_definition, "accessibility_settings_list")
	end

	arg_20_0.settings_lists = var_20_3
	arg_20_0.selected_widget = nil
	arg_20_0.selected_title = nil
	arg_20_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_20_0.ui_calibration_view = UICalibrationView:new()
	arg_20_0._animations = {}
	arg_20_0._ui_animator = UIAnimator:new(arg_20_0._ui_scenegraph, var_0_0.animation_definitions)
	RELOAD_OPTIONS_VIEW = false

	arg_20_0:_setup_text_buttons_width()
end

OptionsView._setup_text_buttons_width = function (arg_23_0)
	local var_23_0 = arg_23_0:_setup_text_button_size(arg_23_0.apply_button)

	arg_23_0:_setup_text_button_size(arg_23_0.reset_to_default)
	arg_23_0:_set_text_button_horizontal_position(arg_23_0.reset_to_default, -(var_23_0 + 50))

	local var_23_1 = 0

	for iter_23_0, iter_23_1 in ipairs(arg_23_0.title_buttons) do
		local var_23_2 = arg_23_0:_setup_text_button_size(iter_23_1)

		arg_23_0:_set_text_button_horizontal_position(iter_23_1, var_23_1)

		var_23_1 = var_23_1 + var_23_2 + 20
	end
end

OptionsView._setup_text_button_size = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_1.scenegraph_id
	local var_24_1 = arg_24_1.content
	local var_24_2 = arg_24_1.style.text
	local var_24_3 = var_24_1.text_field or var_24_1.text

	if var_24_2.localize then
		var_24_3 = Localize(var_24_3)
	end

	if var_24_2.upper_case then
		var_24_3 = TextToUpper(var_24_3)
	end

	local var_24_4 = arg_24_0.ui_scenegraph
	local var_24_5 = arg_24_0.ui_renderer
	local var_24_6, var_24_7 = UIFontByResolution(var_24_2)
	local var_24_8, var_24_9, var_24_10 = UIRenderer.text_size(var_24_5, var_24_3, var_24_6[1], var_24_7)

	var_24_4[var_24_0].size[1] = var_24_8

	return var_24_8
end

OptionsView._set_text_button_horizontal_position = function (arg_25_0, arg_25_1, arg_25_2)
	arg_25_0.ui_scenegraph[arg_25_1.scenegraph_id].local_position[1] = arg_25_2
end

OptionsView.build_settings_list = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = var_0_0.scenegraph_definition
	local var_26_1 = arg_26_2 .. "start"
	local var_26_2 = 0
	local var_26_3 = {}
	local var_26_4 = 0
	local var_26_5 = #arg_26_1
	local var_26_6 = Managers.unlock

	for iter_26_0 = 1, var_26_5 do
		local var_26_7 = arg_26_1[iter_26_0]
		local var_26_8 = {
			0,
			-var_26_2,
			0
		}
		local var_26_9
		local var_26_10 = 0
		local var_26_11 = var_26_7.widget_type
		local var_26_12 = true

		if var_26_7.required_dlc and not var_26_6:is_dlc_unlocked(var_26_7.required_dlc) then
			var_26_12 = false
		elseif var_26_7.required_render_caps then
			for iter_26_1, iter_26_2 in pairs(var_26_7.required_render_caps) do
				if Application.render_caps(iter_26_1) ~= iter_26_2 then
					var_26_12 = false

					break
				end
			end
		end

		if var_26_12 then
			if var_26_11 == "drop_down" then
				var_26_9 = arg_26_0:build_drop_down_widget(var_26_7, var_26_1, var_26_8)
			elseif var_26_11 == "option" then
				var_26_9 = arg_26_0:build_option_widget(var_26_7, var_26_1, var_26_8)
			elseif var_26_11 == "slider" then
				var_26_9 = arg_26_0:build_slider_widget(var_26_7, var_26_1, var_26_8)
			elseif var_26_11 == "checkbox" then
				var_26_9 = arg_26_0:build_checkbox_widget(var_26_7, var_26_1, var_26_8)
			elseif var_26_11 == "stepper" then
				var_26_9 = arg_26_0:build_stepper_widget(var_26_7, var_26_1, var_26_8)
			elseif var_26_11 == "keybind" then
				var_26_9 = arg_26_0:build_keybind_widget(var_26_7, var_26_1, var_26_8)
			elseif var_26_11 == "sorted_list" then
				var_26_9 = arg_26_0:build_sorted_list_widget(var_26_7, var_26_1, var_26_8)
			elseif var_26_11 == "image" then
				var_26_9 = arg_26_0:build_image(var_26_7, var_26_1, var_26_8)
			elseif var_26_11 == "gamepad_layout" then
				var_26_9 = arg_26_0:build_gamepad_layout(var_26_7, var_26_1, var_26_8)
				arg_26_0.gamepad_layout_widget = var_26_9

				local var_26_13 = var_0_12(arg_26_0.changed_user_settings.gamepad_layout, Application.user_setting("gamepad_layout"))
				local var_26_14 = var_0_12(arg_26_0.changed_user_settings.gamepad_left_handed, Application.user_setting("gamepad_left_handed"))
				local var_26_15 = (var_26_14 and AlternatateGamepadKeymapsLayoutsLeftHanded or AlternatateGamepadKeymapsLayouts)[var_26_13]

				arg_26_0:update_gamepad_layout_widget(var_26_15, var_26_14)
			elseif var_26_11 == "empty" then
				var_26_10 = var_26_7.size_y
			elseif var_26_11 == "title" then
				var_26_9 = arg_26_0:build_title(var_26_7, var_26_1, var_26_8)
			elseif var_26_11 == "text_link" then
				var_26_9 = arg_26_0:build_text_link(var_26_7, var_26_1, var_26_8)
			else
				error("[OptionsView] Unsupported widget type")
			end
		end

		if var_26_9 then
			local var_26_16 = var_26_7.callback

			var_26_10 = var_26_9.style.size[2]

			rawset(var_26_9, "type", var_26_11)
			rawset(var_26_9, "name", var_26_16)
			rawset(var_26_9, "ui_animations", {})

			var_26_9.content.definition = var_26_7
		end

		var_26_2 = var_26_2 + var_26_10

		if var_26_9 then
			if var_26_7.name then
				var_26_9.name = var_26_7.name
			end

			var_26_4 = var_26_4 + 1
			var_26_3[var_26_4] = var_26_9
		end
	end

	local var_26_17 = var_26_0.list_mask.size
	local var_26_18 = var_26_17[1]

	var_26_0[arg_26_2] = {
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
			var_26_18,
			var_26_2
		}
	}
	var_26_0[var_26_1] = {
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

	local var_26_19 = false
	local var_26_20 = 0

	if var_26_2 > var_26_17[2] then
		var_26_19 = true
		var_26_20 = var_26_2 - var_26_17[2]
	end

	return {
		visible_widgets_n = 0,
		scenegraph_id = arg_26_2,
		scenegraph_id_start = var_26_1,
		scrollbar = var_26_19,
		max_offset_y = var_26_20,
		widgets = var_26_3,
		widgets_n = var_26_4
	}
end

OptionsView.make_callback = function (arg_27_0, arg_27_1)
	return function (...)
		arg_27_0[arg_27_1](arg_27_0, ...)

		local var_28_0 = arg_27_0.changed_user_settings
		local var_28_1 = arg_27_0.original_user_settings

		for iter_28_0, iter_28_1 in pairs(var_28_0) do
			if not var_28_1[iter_28_0] then
				var_28_1[iter_28_0] = Application.user_setting(iter_28_0)
			end

			if iter_28_1 == var_28_1[iter_28_0] then
				var_28_0[iter_28_0] = nil
			end
		end

		local var_28_2 = arg_27_0.changed_render_settings
		local var_28_3 = arg_27_0.original_render_settings

		for iter_28_2, iter_28_3 in pairs(var_28_2) do
			if not var_28_3[iter_28_2] then
				var_28_3[iter_28_2] = Application.user_setting("render_settings", iter_28_2)
			end

			if iter_28_3 == var_28_3[iter_28_2] then
				var_28_2[iter_28_2] = nil
			end
		end

		local var_28_4 = arg_27_0.changed_versus_settings
		local var_28_5 = arg_27_0.original_versus_settings

		for iter_28_4, iter_28_5 in pairs(var_28_4) do
			if not var_28_5[iter_28_4] then
				var_28_5[iter_28_4] = Application.user_setting("versus_settings", iter_28_4)
			end

			if iter_28_5 == var_28_5[iter_28_4] then
				var_28_4[iter_28_4] = nil
			end
		end
	end
end

OptionsView.build_stepper_widget = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_1.callback
	local var_29_1 = arg_29_0:make_callback(var_29_0)
	local var_29_2 = arg_29_1.saved_value
	local var_29_3 = callback(arg_29_0, var_29_2)
	local var_29_4 = arg_29_1.condition
	local var_29_5 = var_29_4 and callback(arg_29_0, var_29_4)
	local var_29_6, var_29_7, var_29_8, var_29_9 = arg_29_0[arg_29_1.setup](arg_29_0)
	local var_29_10 = var_0_0.create_stepper_widget(var_29_8, var_29_7, var_29_6, arg_29_1.tooltip_text, arg_29_1.disabled_tooltip_text, arg_29_2, arg_29_3, arg_29_1.indent_level)
	local var_29_11 = var_29_10.content

	var_29_11.callback = var_29_1
	var_29_11.saved_value_cb = var_29_3
	var_29_11.condition_cb = var_29_5
	var_29_11.on_hover_enter_callback = callback(arg_29_0, "on_stepper_arrow_hover", var_29_10)
	var_29_11.on_hover_exit_callback = callback(arg_29_0, "on_stepper_arrow_dehover", var_29_10)
	var_29_11.default_value = var_29_9

	return var_29_10
end

OptionsView.build_option_widget = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = arg_30_1.callback
	local var_30_1 = arg_30_0:make_callback(var_30_0)
	local var_30_2 = arg_30_1.saved_value
	local var_30_3 = callback(arg_30_0, var_30_2)
	local var_30_4 = arg_30_1.condition
	local var_30_5 = var_30_4 and callback(arg_30_0, var_30_4)
	local var_30_6, var_30_7, var_30_8, var_30_9 = arg_30_0[arg_30_1.setup](arg_30_0)
	local var_30_10 = arg_30_0.ui_renderer
	local var_30_11 = var_0_0.create_option_widget(var_30_10, var_30_8, var_30_7, var_30_6, arg_30_1.tooltip_text, arg_30_2, arg_30_3)
	local var_30_12 = var_30_11.content

	var_30_12.callback = var_30_1
	var_30_12.saved_value_cb = var_30_3
	var_30_12.condition_cb = var_30_5
	var_30_12.default_value = var_30_9

	return var_30_11
end

OptionsView.build_drop_down_widget = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_1.callback
	local var_31_1 = arg_31_0:make_callback(var_31_0)
	local var_31_2 = arg_31_1.saved_value
	local var_31_3 = callback(arg_31_0, var_31_2)
	local var_31_4 = arg_31_1.condition
	local var_31_5 = var_31_4 and callback(arg_31_0, var_31_4)
	local var_31_6 = arg_31_1.ignore_upper_case
	local var_31_7, var_31_8, var_31_9, var_31_10 = arg_31_0[arg_31_1.setup](arg_31_0)
	local var_31_11 = var_0_0.create_drop_down_widget(var_31_9, var_31_8, var_31_7, arg_31_1.tooltip_text, arg_31_1.disabled_tooltip_text, arg_31_2, arg_31_3, arg_31_1.indent_level, var_31_6)
	local var_31_12 = var_31_11.content

	var_31_12.callback = var_31_1
	var_31_12.saved_value_cb = var_31_3
	var_31_12.default_value = var_31_10
	var_31_12.condition_cb = var_31_5

	return var_31_11
end

OptionsView.build_slider_widget = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = arg_32_1.callback
	local var_32_1 = arg_32_0:make_callback(var_32_0)
	local var_32_2 = arg_32_1.callback_on_release
	local var_32_3 = arg_32_1.saved_value
	local var_32_4 = callback(arg_32_0, var_32_3)
	local var_32_5 = arg_32_1.condition
	local var_32_6 = var_32_5 and callback(arg_32_0, var_32_5)
	local var_32_7 = arg_32_1.setup
	local var_32_8 = arg_32_1.slider_image
	local var_32_9 = arg_32_1.slider_image_text
	local var_32_10, var_32_11, var_32_12, var_32_13, var_32_14, var_32_15 = arg_32_0[var_32_7](arg_32_0)

	fassert(type(var_32_10) == "number", "Value type is wrong, need number, got %q", type(var_32_10))

	local var_32_16 = var_0_0.create_slider_widget(var_32_14, arg_32_1.tooltip_text, arg_32_2, arg_32_3, var_32_8, var_32_9)
	local var_32_17 = var_32_16.content

	var_32_17.min = var_32_11
	var_32_17.max = var_32_12
	var_32_17.internal_value = var_32_10
	var_32_17.num_decimals = var_32_13
	var_32_17.callback = var_32_1
	var_32_17.callback_on_release = var_32_2
	var_32_17.on_hover_enter_callback = callback(arg_32_0, "on_stepper_arrow_hover", var_32_16)
	var_32_17.on_hover_exit_callback = callback(arg_32_0, "on_stepper_arrow_dehover", var_32_16)
	var_32_17.saved_value_cb = var_32_4
	var_32_17.default_value = var_32_15
	var_32_17.condition_cb = var_32_6

	return var_32_16
end

OptionsView.build_image = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = var_0_0.create_simple_texture_widget(arg_33_1.image, arg_33_1.image_size, arg_33_2, arg_33_3)
	local var_33_1 = var_33_0.content

	var_33_1.callback = function ()
		return
	end

	var_33_1.saved_value_cb = function ()
		return
	end

	var_33_1.disabled = true

	return var_33_0
end

OptionsView.build_title = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = var_0_0.create_title_widget(arg_36_1.text, arg_36_1.font_size, arg_36_1.color, arg_36_1.horizontal_alignment, arg_36_2, arg_36_3)
	local var_36_1 = var_36_0.content

	var_36_1.callback = function ()
		return
	end

	var_36_1.saved_value_cb = function ()
		return
	end

	var_36_1.disabled = true

	return var_36_0
end

OptionsView.build_text_link = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = var_0_0.create_text_link_widget(arg_39_1.text, arg_39_1.url, arg_39_1.font_size, arg_39_1.color, arg_39_1.horizontal_alignment, arg_39_2, arg_39_3)
	local var_39_1 = var_39_0.content

	var_39_1.callback = function ()
		return
	end

	var_39_1.saved_value_cb = function ()
		return
	end

	return var_39_0
end

OptionsView.clear_gamepad_layout_widget = function (arg_42_0)
	local var_42_0 = var_0_12(arg_42_0.changed_user_settings.gamepad_left_handed, Application.user_setting("gamepad_left_handed")) and AlternatateGamepadSettings.left_handed.default_gamepad_actions_by_key or AlternatateGamepadSettings.default.default_gamepad_actions_by_key
	local var_42_1 = arg_42_0.gamepad_layout_widget.content
	local var_42_2 = var_42_1.background
	local var_42_3 = var_42_1.background1
	local var_42_4 = var_42_1.background2
	local var_42_5 = var_42_1.saved_value_cb

	table.clear(var_42_1)

	var_42_1.background = var_42_2
	var_42_1.background1 = var_42_3
	var_42_1.background2 = var_42_4
	var_42_1.saved_value_cb = var_42_5

	if IS_WINDOWS then
		var_42_1.use_texture2_layout = var_0_12(arg_42_0.changed_user_settings.gamepad_use_ps4_style_input_icons, Application.user_setting("gamepad_use_ps4_style_input_icons"))
	end

	for iter_42_0, iter_42_1 in pairs(var_42_0) do
		var_42_1[iter_42_0] = Localize(iter_42_1)
	end
end

OptionsView.update_gamepad_layout_widget = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0.gamepad_layout_widget.content
	local var_43_1 = {}

	arg_43_0:clear_gamepad_layout_widget()

	local var_43_2 = arg_43_2 and AlternatateGamepadSettings.left_handed.ignore_gamepad_action_names or AlternatateGamepadSettings.default.ignore_gamepad_action_names
	local var_43_3 = arg_43_2 and AlternatateGamepadSettings.left_handed.replace_gamepad_action_names or AlternatateGamepadSettings.default.replace_gamepad_action_names

	for iter_43_0, iter_43_1 in pairs(arg_43_1) do
		for iter_43_2, iter_43_3 in pairs(iter_43_1) do
			for iter_43_4, iter_43_5 in pairs(iter_43_3) do
				repeat
					if var_0_1.ignore_keybind[iter_43_4] or var_43_2 and var_43_2[iter_43_4] then
						break
					end

					if #iter_43_5 < 3 then
						break
					end

					local var_43_4 = iter_43_5[2]
					local var_43_5 = var_43_1[var_43_4] or {}

					var_43_1[var_43_4] = var_43_5

					if var_43_3 and var_43_3[iter_43_4] then
						iter_43_4 = var_43_3[iter_43_4]
					end

					var_43_5[#var_43_5 + 1] = iter_43_4
				until true
			end
		end
	end

	local var_43_6 = {}

	for iter_43_6, iter_43_7 in pairs(var_43_1) do
		for iter_43_8 = 1, #iter_43_7 do
			local var_43_7 = iter_43_7[iter_43_8]

			if not var_43_0[iter_43_6] then
				var_43_0[iter_43_6] = Localize(var_43_7)
			else
				table.clear(var_43_6)

				var_43_6[1] = Localize(var_43_7)
				var_43_6[2] = var_43_0[iter_43_6]

				table.sort(var_43_6)

				var_43_0[iter_43_6] = var_43_6[1] .. "/" .. var_43_6[2]
			end
		end
	end
end

OptionsView.build_gamepad_layout = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = var_0_0.create_gamepad_layout_widget(arg_44_1.bg_image, arg_44_1.bg_image_size, arg_44_1.bg_image2, arg_44_1.bg_image_size2, arg_44_2, arg_44_3)
	local var_44_1 = var_44_0.content

	var_44_1.callback = function ()
		return
	end

	var_44_1.saved_value_cb = function ()
		return
	end

	var_44_1.disabled = true

	return var_44_0
end

OptionsView.build_checkbox_widget = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = arg_47_1.callback
	local var_47_1 = arg_47_0:make_callback(var_47_0)
	local var_47_2 = arg_47_1.saved_value
	local var_47_3 = callback(arg_47_0, var_47_2)
	local var_47_4 = arg_47_1.condition
	local var_47_5 = var_47_4 and callback(arg_47_0, var_47_4)
	local var_47_6, var_47_7, var_47_8 = arg_47_0[arg_47_1.setup](arg_47_0)

	fassert(type(var_47_6) == "boolean", "Flag type is wrong, need boolean, got %q", type(var_47_6))

	local var_47_9 = var_0_0.create_checkbox_widget(var_47_7, arg_47_2, arg_47_3)
	local var_47_10 = var_47_9.content

	var_47_10.flag = var_47_6
	var_47_10.callback = var_47_1
	var_47_10.saved_value_cb = var_47_3
	var_47_10.default_value = var_47_8
	var_47_10.condition_cb = var_47_5

	return var_47_9
end

OptionsView.build_keybind_widget = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = callback(arg_48_0, "cb_keybind_changed")
	local var_48_1 = callback(arg_48_0, "cb_keybind_saved_value")
	local var_48_2, var_48_3, var_48_4, var_48_5 = arg_48_0:cb_keybind_setup(arg_48_1.keymappings_key, arg_48_1.keymappings_table_key, arg_48_1.actions)
	local var_48_6 = var_0_0.create_keybind_widget(var_48_2, var_48_3, arg_48_1.keybind_description, arg_48_1.actions, var_48_4, arg_48_2, arg_48_3)
	local var_48_7 = var_48_6.content

	var_48_7.callback = var_48_0
	var_48_7.saved_value_cb = var_48_1
	var_48_7.default_value = var_48_5
	var_48_7.keymappings_key = arg_48_1.keymappings_key
	var_48_7.keymappings_table_key = arg_48_1.keymappings_table_key

	return var_48_6
end

OptionsView.build_sorted_list_widget = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = arg_49_1.callback
	local var_49_1 = callback(arg_49_0, var_49_0)
	local var_49_2 = arg_49_1.saved_value
	local var_49_3 = callback(arg_49_0, var_49_2)
	local var_49_4 = arg_49_1.condition
	local var_49_5 = var_49_4 and callback(arg_49_0, var_49_4)
	local var_49_6, var_49_7, var_49_8, var_49_9, var_49_10, var_49_11 = arg_49_0[arg_49_1.setup](arg_49_0)
	local var_49_12 = var_0_0.create_sorted_list_widget(var_49_6, arg_49_1.tooltip_text, var_49_7, var_49_8, var_49_9, var_49_10, arg_49_2, arg_49_3)
	local var_49_13 = var_49_12.content

	var_49_13.callback = var_49_1
	var_49_13.saved_value_cb = var_49_3
	var_49_13.default_value = var_49_11
	var_49_13.condition_cb = var_49_5

	return var_49_12
end

OptionsView.widget_from_name = function (arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0.selected_settings_list

	fassert(var_50_0, "[OptionsView] Trying to set disable on widget without a selected settings list.")

	local var_50_1 = var_50_0.widgets
	local var_50_2 = var_50_0.widgets_n

	for iter_50_0 = 1, var_50_2 do
		local var_50_3 = var_50_1[iter_50_0]

		if var_50_3.name and var_50_3.name == arg_50_1 then
			return var_50_3
		end
	end
end

OptionsView.force_set_widget_value = function (arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_0:widget_from_name(arg_51_1)

	fassert(var_51_0, "No widget with name %q in current settings list", arg_51_1)

	local var_51_1 = var_51_0.type

	if var_51_1 == "stepper" or var_51_1 == "option" then
		local var_51_2 = var_51_0.content
		local var_51_3 = var_51_2.options_values

		for iter_51_0 = 1, #var_51_3 do
			if arg_51_2 == var_51_3[iter_51_0] then
				var_51_2.current_selection = iter_51_0
			end
		end

		var_51_2.callback(var_51_2)
	else
		fassert(false, "Force set widget value not supported for widget type %q yet", var_51_1)
	end
end

OptionsView.set_widget_disabled = function (arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_0:widget_from_name(arg_52_1)

	if var_52_0 then
		var_52_0.content.disabled = arg_52_2
	end
end

OptionsView.on_enter = function (arg_53_0, arg_53_1)
	ShowCursorStack.show("OptionsView")

	arg_53_0._cursor_pushed = true

	arg_53_0:_setup_text_buttons_width()
	arg_53_0:set_original_settings()
	arg_53_0:reset_changed_settings()
	arg_53_0:select_settings_title(1)

	arg_53_0.in_settings_sub_menu = false
	arg_53_0.gamepad_active_generic_actions_name = nil
	arg_53_0.gamepad_tooltip_available = nil
	arg_53_0._exit_transition = arg_53_1 and arg_53_1.exit_transition

	if arg_53_0.input_manager:is_device_active("gamepad") then
		arg_53_0.selected_title = nil

		arg_53_0:set_console_title_selection(1, true)
	end

	WwiseWorld.trigger_event(arg_53_0.wwise_world, "Play_hud_button_open")

	arg_53_0.active = true
	arg_53_0.safe_rect_alpha_timer = 0

	arg_53_0.input_manager:block_device_except_service("options_menu", "keyboard", 1)
	arg_53_0.input_manager:block_device_except_service("options_menu", "mouse", 1)
	arg_53_0.input_manager:block_device_except_service("options_menu", "gamepad", 1)

	if not arg_53_0.in_title_screen then
		local var_53_0 = arg_53_0.ui_renderer.world
		local var_53_1 = World.get_data(var_53_0, "shading_environment")

		if var_53_1 then
			ShadingEnvironment.set_scalar(var_53_1, "fullscreen_blur_enabled", 1)
			ShadingEnvironment.set_scalar(var_53_1, "fullscreen_blur_amount", 0.75)
			ShadingEnvironment.apply(var_53_1)
		end
	end

	UIWidgetUtils.reset_layout_button(arg_53_0.back_button)
	arg_53_0:_start_animation("on_enter")
end

OptionsView._start_animation = function (arg_54_0, arg_54_1)
	arg_54_0.render_settings = arg_54_0.render_settings or {
		alpha_multiplier = 0,
		snap_pixel_positions = false
	}

	local var_54_0 = {
		render_settings = arg_54_0.render_settings
	}

	arg_54_0._animations[arg_54_1] = arg_54_0._ui_animator:start_animation(arg_54_1, nil, arg_54_0.ui_scenegraph, var_54_0, 1, 0)
end

OptionsView.on_exit = function (arg_55_0)
	if not arg_55_0.exiting then
		Crashify.print_exception("[OptionsView]", "triggering on_exit() without triggering exit()")
	end

	arg_55_0:cleanup_popups()
	ShowCursorStack.hide("OptionsView")

	arg_55_0._cursor_pushed = nil

	arg_55_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_55_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_55_0.input_manager:device_unblock_all_services("gamepad", 1)

	arg_55_0.exiting = nil
	arg_55_0.active = nil

	local var_55_0 = arg_55_0.ui_renderer.world
	local var_55_1 = World.get_data(var_55_0, "shading_environment")

	if var_55_1 then
		ShadingEnvironment.set_scalar(var_55_1, "fullscreen_blur_enabled", 0)
		ShadingEnvironment.set_scalar(var_55_1, "fullscreen_blur_amount", 0)
		ShadingEnvironment.apply(var_55_1)
	end
end

OptionsView.exit_reset_params = function (arg_56_0)
	arg_56_0:cleanup_popups()

	if arg_56_0.selected_title then
		arg_56_0:deselect_title(arg_56_0.selected_title)

		arg_56_0.in_settings_sub_menu = false
	end

	arg_56_0.gamepad_active_generic_actions_name = nil
	arg_56_0.gamepad_tooltip_available = nil

	WwiseWorld.trigger_event(arg_56_0.wwise_world, "Play_hud_button_close")

	arg_56_0.exiting = true
end

OptionsView.exit = function (arg_57_0, arg_57_1)
	arg_57_0:exit_reset_params()

	local var_57_0 = arg_57_1 and "exit_menu" or arg_57_0._exit_transition or "ingame_menu"

	arg_57_0.ingame_ui:transition_with_fade(var_57_0)
end

OptionsView.transitioning = function (arg_58_0)
	if arg_58_0.exiting then
		return true
	else
		return not arg_58_0.active
	end
end

OptionsView.get_keymaps = function (arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = {}
	local var_59_1 = var_0_1.keybind_settings_definition

	if not var_59_1 then
		return
	end

	for iter_59_0, iter_59_1 in ipairs(var_59_1) do
		local var_59_2 = iter_59_1.keymappings_key
		local var_59_3 = iter_59_1.actions

		if var_59_3 then
			local var_59_4 = iter_59_1.keymappings_table_key

			if not var_59_0[var_59_2] then
				var_59_0[var_59_2] = {}
			end

			local var_59_5 = var_59_0[var_59_2]
			local var_59_6 = rawget(_G, var_59_2)

			for iter_59_2, iter_59_3 in pairs(var_59_6) do
				if not arg_59_2 or arg_59_2 == iter_59_2 then
					if not var_59_5[iter_59_2] then
						var_59_5[iter_59_2] = {}
					end

					local var_59_7 = var_59_5[iter_59_2]

					for iter_59_4, iter_59_5 in pairs(iter_59_3) do
						if table.contains(var_59_3, iter_59_4) then
							var_59_7[iter_59_4] = table.clone(iter_59_5)
						end
					end
				end
			end
		end
	end

	if arg_59_1 then
		local var_59_8 = PlayerData.controls or {}

		for iter_59_6, iter_59_7 in pairs(var_59_0) do
			local var_59_9 = var_59_8[iter_59_6]

			if var_59_9 then
				for iter_59_8, iter_59_9 in pairs(var_59_9) do
					if not arg_59_2 or arg_59_2 == iter_59_8 then
						for iter_59_10, iter_59_11 in pairs(iter_59_9) do
							local var_59_10 = iter_59_7[iter_59_8]

							if var_59_10 and var_59_10[iter_59_10] then
								var_59_10[iter_59_10] = table.clone(iter_59_11)
							end
						end
					end
				end
			end
		end
	end

	return var_59_0
end

OptionsView._get_original_bot_spawn_priority = function (arg_60_0)
	local var_60_0 = PlayerData.bot_spawn_priority

	if #var_60_0 > 0 then
		return var_60_0
	else
		return ProfilePriority
	end
end

OptionsView.reset_changed_settings = function (arg_61_0)
	arg_61_0.changed_user_settings = {}
	arg_61_0.changed_render_settings = {}
	arg_61_0.changed_versus_settings = {}

	local var_61_0 = true

	arg_61_0.session_keymaps = arg_61_0:get_keymaps(var_61_0, "win32")
	arg_61_0.changed_keymaps = false
	arg_61_0.session_bot_spawn_priority = table.create_copy(arg_61_0.session_bot_spawn_priority, arg_61_0:_get_original_bot_spawn_priority())
	arg_61_0.changed_bot_spawn_priority = false
end

OptionsView.set_original_settings = function (arg_62_0)
	arg_62_0.original_user_settings = {}
	arg_62_0.original_render_settings = {}
	arg_62_0.original_versus_settings = {}

	local var_62_0 = true

	arg_62_0.original_keymaps = arg_62_0:get_keymaps(var_62_0, "win32")
	arg_62_0.original_bot_spawn_priority = table.create_copy(arg_62_0.original_bot_spawn_priority, arg_62_0:_get_original_bot_spawn_priority())
end

OptionsView._get_setting = function (arg_63_0, arg_63_1, arg_63_2)
	if arg_63_1 == "user_settings" then
		return var_0_12(arg_63_0.changed_user_settings[arg_63_2], Application.user_setting(arg_63_2))
	elseif arg_63_1 == "render_settings" then
		return var_0_12(arg_63_0.changed_render_settings[arg_63_2], Application.user_setting("render_settings", arg_63_2))
	elseif arg_63_1 == "versus_settings" then
		return var_0_12(arg_63_0.changed_versus_settings[arg_63_2], Application.user_setting("versus_settings", arg_63_2))
	end

	fassert(false, "Unknown setting_type: %q", arg_63_1)
end

OptionsView._set_setting = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
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

OptionsView._set_setting_override = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	local var_65_0 = arg_65_1.options_values
	local var_65_1 = table.find(var_65_0, arg_65_4)

	fassert(var_65_1, "Could not find the forced value %q for setting: %s", arg_65_4, arg_65_3)

	if arg_65_0.overriden_settings[arg_65_3] == nil then
		local var_65_2 = arg_65_1.current_selection

		arg_65_0.overriden_settings[arg_65_3] = var_65_0[var_65_2]

		if var_65_1 ~= var_65_2 then
			arg_65_1.current_selection = var_65_1

			local var_65_3 = true

			arg_65_1.callback(arg_65_1, arg_65_2, nil, var_65_3)
		end
	end

	local var_65_4 = arg_65_0.overriden_settings[arg_65_3]
	local var_65_5 = table.find(var_65_0, var_65_4)

	fassert(var_65_5, "Could not find the wanted value %q for setting: %s", var_65_4, arg_65_3)

	if var_65_1 ~= var_65_5 then
		arg_65_1.overriden_setting = arg_65_1.options_texts[var_65_5]
	end
end

OptionsView._restore_setting_override = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	local var_66_0 = arg_66_0.overriden_settings[arg_66_3]

	if var_66_0 == nil then
		return
	end

	local var_66_1 = table.find(arg_66_1.options_values, var_66_0)

	if var_66_1 then
		arg_66_1.current_selection = var_66_1

		local var_66_2 = true

		arg_66_1.callback(arg_66_1, arg_66_2, nil, var_66_2)
	else
		printf("[OptionsView] Could not find the wanted value %q for setting %q. Ignored.", var_66_0, arg_66_3)
	end

	arg_66_1.overriden_setting = nil
	arg_66_1.overriden_reason = nil
	arg_66_0.overriden_settings[arg_66_3] = nil
end

OptionsView._clear_setting_override = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	arg_67_1.overriden_setting = nil
	arg_67_1.overriden_reason = nil
	arg_67_0.overriden_settings[arg_67_3] = nil
end

OptionsView._set_override_reason = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	if not arg_68_1.overriden_reason then
		if arg_68_3 then
			arg_68_1.overriden_reason = Localize(arg_68_1.text) .. "\n" .. Localize(arg_68_2)
		else
			arg_68_1.overriden_reason = Localize(arg_68_1.text) .. "\n" .. Localize("tooltip_overriden_by_setting") .. "\n" .. Localize(arg_68_2)
		end
	end
end

OptionsView.set_wwise_parameter = function (arg_69_0, arg_69_1, arg_69_2)
	WwiseWorld.set_global_parameter(arg_69_0.wwise_world, arg_69_1, arg_69_2)
end

OptionsView.changes_been_made = function (arg_70_0)
	return not table.is_empty(arg_70_0.changed_user_settings) or not table.is_empty(arg_70_0.changed_render_settings) or not table.is_empty(arg_70_0.changed_versus_settings) or arg_70_0.changed_keymaps or arg_70_0.changed_bot_spawn_priority
end

local var_0_17 = {}
local var_0_18 = var_0_1.needs_reload_settings
local var_0_19 = var_0_1.needs_restart_settings

OptionsView.apply_changes = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4, arg_71_5)
	local var_71_0 = false

	for iter_71_0, iter_71_1 in pairs(arg_71_1) do
		Application.set_user_setting(iter_71_0, iter_71_1)

		if table.contains(var_0_18, iter_71_0) then
			var_71_0 = true
		end
	end

	for iter_71_2, iter_71_3 in pairs(arg_71_2) do
		Application.set_user_setting("render_settings", iter_71_2, iter_71_3)

		if not table.contains(var_0_19, iter_71_2) then
			var_71_0 = true
		end
	end

	for iter_71_4, iter_71_5 in pairs(arg_71_3) do
		Application.set_user_setting("versus_settings", iter_71_4, iter_71_5)

		if not table.contains(var_0_19, iter_71_4) then
			var_71_0 = true
		end
	end

	Application.set_user_setting("overriden_settings", arg_71_0.overriden_settings)

	local var_71_1 = arg_71_1.char_texture_quality

	if var_71_1 then
		local var_71_2 = TextureQuality.characters[var_71_1]

		for iter_71_6, iter_71_7 in ipairs(var_71_2) do
			Application.set_user_setting("texture_settings", iter_71_7.texture_setting, iter_71_7.mip_level)
		end
	end

	local var_71_3 = arg_71_1.env_texture_quality

	if var_71_3 then
		local var_71_4 = TextureQuality.environment[var_71_3]

		for iter_71_8, iter_71_9 in ipairs(var_71_4) do
			Application.set_user_setting("texture_settings", iter_71_9.texture_setting, iter_71_9.mip_level)
		end
	end

	if not arg_71_0.in_title_screen then
		Framerate.set_playing()
	end

	local var_71_5 = Managers.state.network

	if var_71_5 then
		var_71_5:set_small_network_packets(arg_71_1.small_network_packets)
	end

	MatchmakingSettings.max_distance_filter = GameSettingsDevelopment.network_mode == "lan" and "close" or arg_71_1.max_quick_play_search_range or Application.user_setting("max_quick_play_search_range") or DefaultUserSettings.get("user_settings", "max_quick_play_search_range")

	local var_71_6 = arg_71_1.max_stacking_frames

	if var_71_6 then
		Application.set_max_frame_stacking(var_71_6)
	end

	local var_71_7 = arg_71_1.hud_clamp_ui_scaling

	if var_71_7 ~= nil then
		UISettings.hud_clamp_ui_scaling = var_71_7
	end

	local var_71_8 = arg_71_1.use_custom_hud_scale

	if var_71_8 ~= nil then
		UISettings.use_custom_hud_scale = var_71_8
	end

	local var_71_9 = arg_71_1.use_pc_menu_layout

	if var_71_9 ~= nil then
		UISettings.use_pc_menu_layout = var_71_9
	end

	local var_71_10 = arg_71_1.use_gamepad_hud_layout

	if var_71_10 ~= nil then
		UISettings.use_gamepad_hud_layout = var_71_10
	end

	local var_71_11 = arg_71_1.use_subtitles

	if var_71_11 ~= nil then
		UISettings.use_subtitles = var_71_11
	end

	local var_71_12 = arg_71_1.subtitles_font_size

	if var_71_12 then
		UISettings.subtitles_font_size = var_71_12
	end

	local var_71_13 = arg_71_1.subtitles_background_opacity

	if var_71_13 then
		UISettings.subtitles_background_alpha = 2.55 * var_71_13
	end

	local var_71_14 = arg_71_1.master_bus_volume

	if var_71_14 then
		arg_71_0:set_wwise_parameter("master_bus_volume", var_71_14)
	end

	local var_71_15 = arg_71_1.music_bus_volume

	if var_71_15 then
		Managers.music:set_music_volume(var_71_15)
	end

	local var_71_16 = arg_71_1.sfx_bus_volume

	if var_71_16 then
		arg_71_0:set_wwise_parameter("sfx_bus_volume", var_71_16)
	end

	local var_71_17 = arg_71_1.voice_bus_volume

	if var_71_17 then
		arg_71_0:set_wwise_parameter("voice_bus_volume", var_71_17)
	end

	local var_71_18 = arg_71_1.voip_bus_volume

	if var_71_18 then
		arg_71_0.voip:set_volume(var_71_18)
	end

	local var_71_19 = arg_71_1.voip_is_enabled

	if var_71_19 ~= nil then
		arg_71_0.voip:set_enabled(var_71_19)

		if IS_XB1 and Managers.voice_chat then
			Managers.voice_chat:set_enabled(var_71_19)
		end
	end

	local var_71_20 = arg_71_1.voip_push_to_talk

	if var_71_20 then
		arg_71_0.voip:set_push_to_talk(var_71_20)
	end

	local var_71_21 = arg_71_1.dynamic_range_sound

	if var_71_21 then
		local var_71_22 = 1

		if var_71_21 == "high" then
			var_71_22 = 0
		end

		arg_71_0:set_wwise_parameter("dynamic_range_sound", var_71_22)
	end

	local var_71_23 = arg_71_1.sound_channel_configuration

	if var_71_23 then
		Wwise.set_bus_config("ingame_mastering_channel", var_71_23)
	end

	local var_71_24 = arg_71_1.sound_panning_rule

	if var_71_24 then
		local var_71_25 = var_71_24 == "headphones" and "PANNING_RULE_HEADPHONES" or "PANNING_RULE_SPEAKERS"

		Managers.music:set_panning_rule(var_71_25)
	end

	local var_71_26 = arg_71_1.sound_quality

	if var_71_26 then
		SoundQualitySettings.set_sound_quality(arg_71_0.wwise_world, var_71_26)
	end

	local var_71_27 = arg_71_2.fov

	if var_71_27 then
		local var_71_28 = var_71_27 / CameraSettings.first_person._node.vertical_fov
		local var_71_29 = Managers.state.camera

		if var_71_29 then
			var_71_29:set_fov_multiplier(var_71_28)
		end
	end

	local var_71_30 = arg_71_0.input_manager:get_service("Player")
	local var_71_31 = arg_71_1.mouse_look_sensitivity

	if var_71_31 then
		local var_71_32 = "win32"
		local var_71_33 = InputUtils.get_platform_filters(PlayerControllerFilters, var_71_32).look.multiplier

		var_71_30:get_active_filters(var_71_32).look.function_data.multiplier = var_71_33 * 0.85^-var_71_31
	end

	local var_71_34 = arg_71_1.mouse_look_invert_y

	if var_71_34 ~= nil then
		local var_71_35 = "win32"

		var_71_30:get_active_filters(var_71_35).look.function_data.filter_type = var_71_34 and "scale_vector3" or "scale_vector3_invert_y"
	end

	local var_71_36 = arg_71_1.gamepad_look_sensitivity

	if var_71_36 then
		table.clear(var_0_17)

		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_71_0.platform
		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

		for iter_71_10 = 1, #var_0_17 do
			local var_71_37 = var_0_17[iter_71_10]
			local var_71_38 = InputUtils.get_platform_filters(PlayerControllerFilters, var_71_37)
			local var_71_39 = var_71_38.look_controller.multiplier_x
			local var_71_40 = var_71_38.look_controller_melee.multiplier_x
			local var_71_41 = var_71_38.look_controller_ranged.multiplier_x
			local var_71_42 = var_71_30:get_active_filters(var_71_37)
			local var_71_43 = var_71_42.look_controller.function_data

			var_71_43.multiplier_x = var_71_39 * 0.85^-var_71_36
			var_71_43.min_multiplier_x = var_71_38.look_controller.multiplier_min_x and var_71_38.look_controller.multiplier_min_x * 0.85^-var_71_36 or var_71_43.multiplier_x * 0.25

			local var_71_44 = var_71_42.look_controller_melee.function_data

			var_71_44.multiplier_x = var_71_40 * 0.85^-var_71_36
			var_71_44.min_multiplier_x = var_71_38.look_controller_melee.multiplier_min_x and var_71_38.look_controller_melee.multiplier_min_x * 0.85^-var_71_36 or var_71_44.multiplier_x * 0.25

			local var_71_45 = var_71_42.look_controller_ranged.function_data

			var_71_45.multiplier_x = var_71_41 * 0.85^-var_71_36
			var_71_45.min_multiplier_x = var_71_38.look_controller_ranged.multiplier_min_x and var_71_38.look_controller_ranged.multiplier_min_x * 0.85^-var_71_36 or var_71_45.multiplier_x * 0.25
		end
	end

	local var_71_46 = arg_71_1.gamepad_look_sensitivity_y

	if var_71_46 then
		table.clear(var_0_17)

		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_71_0.platform
		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

		for iter_71_11 = 1, #var_0_17 do
			local var_71_47 = var_0_17[iter_71_11]
			local var_71_48 = InputUtils.get_platform_filters(PlayerControllerFilters, var_71_47)
			local var_71_49 = var_71_48.look_controller.multiplier_y
			local var_71_50 = var_71_48.look_controller.multiplier_y
			local var_71_51 = var_71_48.look_controller.multiplier_y
			local var_71_52 = var_71_30:get_active_filters(var_71_47)

			var_71_52.look_controller.function_data.multiplier_y = var_71_49 * 0.85^-var_71_46
			var_71_52.look_controller_melee.function_data.multiplier_y = var_71_50 * 0.85^-var_71_46
			var_71_52.look_controller_ranged.function_data.multiplier_y = var_71_51 * 0.85^-var_71_46
		end
	end

	local var_71_53 = arg_71_1.gamepad_zoom_sensitivity

	if var_71_53 then
		table.clear(var_0_17)

		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_71_0.platform
		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

		for iter_71_12 = 1, #var_0_17 do
			local var_71_54 = var_0_17[iter_71_12]
			local var_71_55 = InputUtils.get_platform_filters(PlayerControllerFilters, var_71_54)
			local var_71_56 = var_71_55.look_controller_zoom.multiplier_x
			local var_71_57 = var_71_30:get_active_filters(var_71_54).look_controller_zoom.function_data

			var_71_57.multiplier_x = var_71_56 * 0.85^-var_71_53
			var_71_57.min_multiplier_x = var_71_55.look_controller_zoom.multiplier_min_x and var_71_55.look_controller_zoom.multiplier_min_x * 0.85^-var_71_53 or var_71_57.multiplier_x * 0.25
		end
	end

	local var_71_58 = arg_71_1.gamepad_zoom_sensitivity_y

	if var_71_58 then
		table.clear(var_0_17)

		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_71_0.platform
		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

		for iter_71_13 = 1, #var_0_17 do
			local var_71_59 = var_0_17[iter_71_13]
			local var_71_60 = InputUtils.get_platform_filters(PlayerControllerFilters, var_71_59).look_controller_zoom.multiplier_y

			var_71_30:get_active_filters(var_71_59).look_controller_zoom.function_data.multiplier_y = var_71_60 * 0.85^-var_71_58
		end
	end

	local var_71_61 = arg_71_1.gamepad_left_dead_zone

	if var_71_61 then
		local var_71_62 = Managers.account:active_controller()
		local var_71_63 = var_71_62.default_dead_zone()
		local var_71_64 = var_71_62.CIRCULAR
		local var_71_65 = var_71_62.axis_index("left")
		local var_71_66 = var_71_63[var_71_65].dead_zone
		local var_71_67 = var_71_66 + var_71_61 * (0.9 - var_71_66)

		var_71_62.set_dead_zone(var_71_65, var_71_64, var_71_67)
	end

	local var_71_68 = arg_71_1.gamepad_right_dead_zone

	if var_71_68 then
		local var_71_69 = Managers.account:active_controller()
		local var_71_70 = var_71_69.default_dead_zone()
		local var_71_71 = var_71_69.CIRCULAR
		local var_71_72 = var_71_69.axis_index("right")
		local var_71_73 = var_71_70[var_71_72].dead_zone
		local var_71_74 = var_71_73 + var_71_68 * (0.9 - var_71_73)

		var_71_69.set_dead_zone(var_71_72, var_71_71, var_71_74)
	end

	local var_71_75 = arg_71_1.gamepad_look_invert_y

	if var_71_75 ~= nil then
		table.clear(var_0_17)

		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_71_0.platform
		var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

		for iter_71_14 = 1, #var_0_17 do
			local var_71_76 = var_0_17[iter_71_14]
			local var_71_77 = var_71_30:get_active_filters(var_71_76)

			var_71_77.look_controller.function_data.filter_type = var_71_75 and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
			var_71_77.look_controller_melee.function_data.filter_type = var_71_75 and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
			var_71_77.look_controller_ranged.function_data.filter_type = var_71_75 and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
			var_71_77.look_controller_zoom.function_data.filter_type = var_71_75 and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
		end
	end

	local var_71_78 = arg_71_1.gamepad_use_ps4_style_input_icons

	if var_71_78 ~= nil then
		UISettings.use_ps4_input_icons = var_71_78
	end

	local var_71_79 = arg_71_1.gamepad_layout ~= nil
	local var_71_80 = arg_71_1.gamepad_left_handed ~= nil

	if var_71_79 or var_71_80 then
		local var_71_81 = DefaultUserSettings.get("user_settings", "gamepad_layout") or "default"
		local var_71_82 = var_0_12(arg_71_1.gamepad_layout, Application.user_setting("gamepad_layout")) or var_71_81

		if var_71_82 then
			local var_71_83 = var_0_12(arg_71_1.gamepad_left_handed, Application.user_setting("gamepad_left_handed"))
			local var_71_84

			if var_71_83 then
				var_71_84 = AlternatateGamepadKeymapsLayoutsLeftHanded
			else
				var_71_84 = AlternatateGamepadKeymapsLayouts
			end

			local var_71_85 = var_71_84[var_71_82]

			arg_71_0:apply_gamepad_changes(var_71_85, var_71_83)
		end
	end

	local var_71_86 = arg_71_1.use_motion_controls

	if var_71_86 ~= nil then
		MotionControlSettings.use_motion_controls = var_71_86
	end

	local var_71_87 = arg_71_1.motion_sensitivity_yaw

	if var_71_87 ~= nil then
		MotionControlSettings.motion_sensitivity_yaw = var_71_87
	end

	local var_71_88 = arg_71_1.motion_sensitivity_pitch

	if var_71_88 ~= nil then
		MotionControlSettings.motion_sensitivity_pitch = var_71_88
	end

	local var_71_89 = arg_71_1.motion_disable_right_stick_vertical

	if var_71_89 ~= nil then
		MotionControlSettings.motion_disable_right_stick_vertical = var_71_89
	end

	local var_71_90 = arg_71_1.motion_enable_yaw_motion

	if var_71_90 ~= nil then
		MotionControlSettings.motion_enable_yaw_motion = var_71_90
	end

	local var_71_91 = arg_71_1.motion_enable_pitch_motion

	if var_71_91 ~= nil then
		MotionControlSettings.motion_enable_pitch_motion = var_71_91
	end

	local var_71_92 = arg_71_1.motion_invert_yaw

	if var_71_92 ~= nil then
		MotionControlSettings.motion_invert_yaw = var_71_92
	end

	local var_71_93 = arg_71_1.motion_invert_pitch

	if var_71_93 ~= nil then
		MotionControlSettings.motion_invert_pitch = var_71_93
	end

	local var_71_94 = arg_71_1.animation_lod_distance_multiplier

	if var_71_94 then
		GameSettingsDevelopment.bone_lod_husks.lod_multiplier = var_71_94
	end

	if arg_71_1.player_outlines then
		local var_71_95 = Managers.player:players()

		for iter_71_15, iter_71_16 in pairs(var_71_95) do
			local var_71_96 = iter_71_16.player_unit

			if not iter_71_16.local_player and Unit.alive(var_71_96) then
				local var_71_97 = ScriptUnit.extension(var_71_96, "outline_system")

				if var_71_97.update_override_method_player_setting then
					var_71_97.update_override_method_player_setting()
				end
			end
		end
	end

	if arg_71_1.minion_outlines and not arg_71_0.in_title_screen then
		local var_71_98 = Managers.player:local_player()
		local var_71_99 = var_71_98 and var_71_98.player_unit

		if var_71_99 then
			local var_71_100 = ScriptUnit.extension(var_71_99, "ai_commander_system")

			for iter_71_17 in pairs(var_71_100:get_controlled_units()) do
				local var_71_101 = ScriptUnit.extension(iter_71_17, "outline_system")

				if var_71_101.update_override_method_minion_setting then
					var_71_101:update_override_method_minion_setting()
				end
			end
		end
	end

	local var_71_102 = arg_71_1.overcharge_opacity
	local var_71_103 = Managers.player
	local var_71_104 = Managers.state.network and Managers.state.network:game()

	if var_71_102 and var_71_103 and var_71_104 then
		local var_71_105 = var_71_103:local_player().player_unit

		ScriptUnit.extension(var_71_105, "overcharge_system"):set_screen_particle_opacity_modifier(var_71_102)
	end

	local var_71_106 = arg_71_1.chat_enabled
	local var_71_107 = Managers.chat

	if var_71_106 ~= nil and var_71_107 then
		var_71_107:set_chat_enabled(var_71_106)
	end

	local var_71_108 = arg_71_1.chat_font_size
	local var_71_109 = Managers.chat

	if var_71_108 and var_71_109 then
		var_71_109:set_font_size(var_71_108)
	end

	local var_71_110 = arg_71_1.language_id

	if var_71_110 then
		arg_71_0:reload_language(var_71_110)
	end

	local var_71_111 = arg_71_1.hud_scale

	if var_71_111 ~= nil then
		UISettings.hud_scale = var_71_111

		local var_71_112 = true

		UPDATE_RESOLUTION_LOOKUP(var_71_112)
		arg_71_0:_setup_text_buttons_width()
		arg_71_0:setup_scrollbar(arg_71_0.selected_settings_list, arg_71_0.scroll_value)
	end

	if rawget(_G, "Tobii") then
		local var_71_113 = arg_71_1.tobii_extended_view_sensitivity

		if var_71_113 ~= nil then
			Tobii.set_extended_view_responsiveness(var_71_113 / 100)
		end

		local var_71_114 = arg_71_1.tobii_extended_view_use_head_tracking

		if var_71_114 ~= nil then
			Tobii.set_extended_view_use_head_tracking(var_71_114)
		end
	end

	local var_71_115 = arg_71_1.twitch_vote_time

	if var_71_115 then
		TwitchSettings.default_vote_time = var_71_115
	end

	local var_71_116 = arg_71_1.twitch_time_between_votes

	if var_71_116 then
		TwitchSettings.default_downtime = var_71_116
	end

	local var_71_117 = arg_71_1.twitch_difficulty

	if var_71_117 then
		TwitchSettings.difficulty = var_71_117
	end

	local var_71_118 = arg_71_1.twitch_disable_positive_votes

	if var_71_118 then
		TwitchSettings.disable_giving_items = var_71_118 == TwitchSettings.positive_vote_options.disable_giving_items or var_71_118 == TwitchSettings.positive_vote_options.disable_positive_votes
		TwitchSettings.disable_positive_votes = var_71_118 == TwitchSettings.positive_vote_options.disable_positive_votes
	end

	local var_71_119 = arg_71_1.twitch_disable_mutators

	if var_71_119 ~= nil then
		TwitchSettings.disable_mutators = var_71_119
	end

	local var_71_120 = arg_71_1.twitch_spawn_amount

	if var_71_120 then
		TwitchSettings.spawn_amount_multiplier = var_71_120
	end

	local var_71_121 = arg_71_1.twitch_mutator_duration

	if var_71_121 then
		TwitchSettings.mutator_duration_multiplier = var_71_121
	end

	if arg_71_1.use_razer_chroma then
		Managers.razer_chroma:load_packages()
	else
		Managers.razer_chroma:unload_packages()
	end

	local var_71_122 = arg_71_1.blood_enabled

	if var_71_122 ~= nil and Managers.state.blood then
		Managers.state.blood:update_blood_enabled(var_71_122)
	end

	local var_71_123 = arg_71_1.num_blood_decals

	if var_71_123 ~= nil and Managers.state.blood then
		Managers.state.blood:update_num_blood_decals(var_71_123)
	end

	local var_71_124 = arg_71_1.screen_blood_enabled

	if var_71_124 ~= nil and Managers.state.blood then
		Managers.state.blood:update_screen_blood_enabled(var_71_124)
	end

	local var_71_125 = arg_71_1.dismemberment_enabled

	if var_71_125 ~= nil and Managers.state.blood then
		Managers.state.blood:update_dismemberment_enabled(var_71_125)
	end

	local var_71_126 = arg_71_1.ragdoll_enabled

	if var_71_126 ~= nil and Managers.state.blood then
		Managers.state.blood:update_ragdoll_enabled(var_71_126)
	end

	arg_71_0:apply_bot_spawn_priority_changes(arg_71_4, arg_71_5)

	if IS_WINDOWS then
		Managers.save:auto_save(SaveFileName, SaveData)
		Application.save_user_settings()
	else
		Managers.save:auto_save(SaveFileName, SaveData, callback(arg_71_0, "cb_save_done"))
	end

	if var_71_0 then
		Application.apply_user_settings()
		GlobalShaderFlags.apply_settings()
		Renderer.bake_static_shadows()

		local var_71_127 = LevelHelper:current_level_settings()
		local var_71_128 = var_71_127 and var_71_127.render_settings_overrides

		if var_71_128 then
			for iter_71_18, iter_71_19 in pairs(var_71_128) do
				Application.set_render_setting(iter_71_18, tostring(iter_71_19))
			end
		end
	end

	ShowCursorStack.update_clip_cursor()
	WwiseWorld.trigger_event(arg_71_0.wwise_world, "Play_hud_button_close")

	if Managers.state.event then
		print("[OptionsView] Triggering `on_game_options_changed`")
		Managers.state.event:trigger("on_game_options_changed")
	end
end

OptionsView.apply_bot_spawn_priority_changes = function (arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = PlayerData.bot_spawn_priority

	for iter_72_0 = 1, #arg_72_1 do
		var_72_0[iter_72_0] = arg_72_1[iter_72_0]
	end

	if arg_72_2 then
		local var_72_1 = Localize("will_be_applied_on_next_map_popup_text")

		arg_72_0.apply_bot_spawn_priority_popup_id = Managers.popup:queue_popup(var_72_1, Localize("popup_will_be_applied_on_next_map_popup"), "continue", Localize("popup_choice_continue"))
	end
end

OptionsView.apply_keymap_changes = function (arg_73_0, arg_73_1, arg_73_2)
	if not PlayerData.controls then
		PlayerData.controls = {}
	end

	local var_73_0 = arg_73_2 and PlayerData.controls

	for iter_73_0, iter_73_1 in pairs(arg_73_1) do
		for iter_73_2, iter_73_3 in pairs(iter_73_1) do
			for iter_73_4, iter_73_5 in pairs(iter_73_3) do
				if arg_73_2 then
					if not var_73_0[iter_73_0] then
						var_73_0[iter_73_0] = {}
					end

					local var_73_1 = var_73_0[iter_73_0]

					if not var_73_1[iter_73_2] then
						var_73_1[iter_73_2] = {}
					end

					local var_73_2 = var_73_1[iter_73_2]

					if iter_73_5.changed then
						var_73_2[iter_73_4] = table.clone(iter_73_5)
					else
						var_73_2[iter_73_4] = nil
					end
				end

				arg_73_0:_apply_keybinding_changes(iter_73_0, iter_73_2, iter_73_4, iter_73_5)
			end
		end
	end

	if arg_73_2 then
		if IS_WINDOWS then
			Managers.save:auto_save(SaveFileName, SaveData)
		else
			Managers.save:auto_save(SaveFileName, SaveData, callback(arg_73_0, "cb_save_done"))
		end

		Managers.razer_chroma:lit_keybindings(true)
	end

	if Managers.state.event then
		Managers.state.event:trigger("input_changed")
	end
end

local var_0_20 = {}

OptionsView._apply_keybinding_changes = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
	table.clear(var_0_20)

	local var_74_0 = 0

	for iter_74_0 = 1, #arg_74_4, 3 do
		local var_74_1 = arg_74_4[iter_74_0]
		local var_74_2 = arg_74_4[iter_74_0 + 1]
		local var_74_3 = arg_74_4[iter_74_0 + 2]
		local var_74_4
		local var_74_5 = var_74_1 == "gamepad"
		local var_74_6 = Pad1

		if IS_WINDOWS and arg_74_2 == "ps_pad" then
			var_74_5 = true
			var_74_6 = InputAux.input_device_mapping.ps_pad[1] or Pad1
		end

		if var_74_5 then
			if var_74_3 == "axis" then
				var_74_4 = var_74_6.axis_index(var_74_2)
			else
				var_74_4 = var_74_6.button_index(var_74_2)
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

		if var_74_4 then
			var_0_20[var_74_0 + 1] = var_74_4
			var_0_20[var_74_0 + 2] = var_74_1
			var_74_0 = var_74_0 + 2
		end
	end

	local var_74_7 = Managers.input

	if var_74_0 > 0 then
		var_74_7:change_keybinding(arg_74_1, arg_74_2, arg_74_3, unpack(var_0_20))
	else
		var_74_7:clear_keybinding(arg_74_1, arg_74_2, arg_74_3)
	end
end

OptionsView.cb_save_done = function (arg_75_0, arg_75_1)
	Managers.transition:hide_loading_icon()

	arg_75_0.disable_all_input = false
end

OptionsView.apply_gamepad_changes = function (arg_76_0, arg_76_1, arg_76_2)
	local var_76_0 = false

	arg_76_0:apply_keymap_changes(arg_76_1, var_76_0)
	arg_76_0:update_gamepad_layout_widget(arg_76_1, arg_76_2)
end

OptionsView.has_popup = function (arg_77_0)
	return arg_77_0.exit_popup_id or arg_77_0.title_popup_id or arg_77_0.apply_popup_id or arg_77_0.apply_bot_spawn_priority_popup_id or arg_77_0.reset_popup_id
end

OPTIONS_VIEW_PRINT_ORIGINAL_VALUES = false

local var_0_21 = rawget(_G, "Tobii")

OptionsView.update = function (arg_78_0, arg_78_1)
	if arg_78_0.suspended then
		return
	end

	if RESOLUTION_LOOKUP.modified then
		arg_78_0:_setup_text_buttons_width()
	end

	local var_78_0 = arg_78_0.disable_all_input
	local var_78_1 = RELOAD_OPTIONS_VIEW

	if var_0_21 then
		local var_78_2 = Tobii.get_is_connected()

		if arg_78_0._tobii_is_connected ~= var_78_2 then
			arg_78_0._tobii_is_connected = var_78_2
			var_78_1 = true
		end
	end

	if var_78_1 then
		local var_78_3 = arg_78_0.selected_title

		arg_78_0:create_ui_elements()
		arg_78_0:_setup_input_functions()

		if var_78_3 then
			arg_78_0:select_settings_title(var_78_3)
		end
	end

	local var_78_4 = arg_78_0:transitioning()

	for iter_78_0, iter_78_1 in pairs(arg_78_0.ui_animations) do
		UIAnimation.update(iter_78_1, arg_78_1)

		if UIAnimation.completed(iter_78_1) then
			arg_78_0.ui_animations[iter_78_0] = nil
		end
	end

	if not arg_78_0.active then
		return
	end

	local var_78_5 = arg_78_0.ui_renderer
	local var_78_6 = arg_78_0.ui_scenegraph
	local var_78_7 = arg_78_0.input_manager
	local var_78_8 = var_78_7:get_service("options_menu")
	local var_78_9 = var_78_7:is_device_active("gamepad")
	local var_78_10 = var_78_7:is_device_active("mouse")
	local var_78_11 = arg_78_0.selected_widget

	arg_78_0:update_apply_button()

	if not var_78_10 and not arg_78_0:has_popup() and not var_78_4 and not var_78_0 then
		arg_78_0:handle_controller_navigation_input(arg_78_1, var_78_8)
	end

	if not var_78_4 then
		arg_78_0:update_mouse_scroll_input(var_78_0)

		local var_78_12 = var_78_9 and not arg_78_0.draw_gamepad_tooltip and not var_78_0

		arg_78_0:handle_apply_button(var_78_8, var_78_12)

		if arg_78_0.selected_settings_list then
			arg_78_0:handle_reset_to_default_button(var_78_8, var_78_12)
		end
	end

	arg_78_0:draw_widgets(arg_78_1, var_78_0)
	arg_78_0:_handle_ps_pads(var_78_9)
	arg_78_0:_update_animations(arg_78_1)

	if arg_78_0.save_data_error_popup_id then
		local var_78_13 = Managers.popup:query_result(arg_78_0.save_data_error_popup_id)

		if var_78_13 then
			if var_78_13 == "delete" then
				Managers.save:delete_save(SaveFileName, callback(arg_78_0, "cb_delete_save"))

				arg_78_0.disable_all_input = true
			end

			Managers.popup:cancel_popup(arg_78_0.save_data_error_popup_id)

			arg_78_0.save_data_error_popup_id = nil
		end
	end

	if arg_78_0.title_popup_id then
		local var_78_14 = Managers.popup:query_result(arg_78_0.title_popup_id)

		if var_78_14 then
			Managers.popup:cancel_popup(arg_78_0.title_popup_id)

			arg_78_0.title_popup_id = nil

			arg_78_0:handle_title_buttons_popup_results(var_78_14)
		end
	end

	if arg_78_0.apply_popup_id then
		local var_78_15 = Managers.popup:query_result(arg_78_0.apply_popup_id)

		if var_78_15 then
			Managers.popup:cancel_popup(arg_78_0.apply_popup_id)

			arg_78_0.apply_popup_id = nil

			arg_78_0:handle_apply_popup_results(var_78_15)
		end
	end

	if arg_78_0.reset_popup_id then
		local var_78_16 = Managers.popup:query_result(arg_78_0.reset_popup_id)

		if var_78_16 then
			Managers.popup:cancel_popup(arg_78_0.reset_popup_id)

			arg_78_0.reset_popup_id = nil

			arg_78_0:handle_apply_popup_results(var_78_16)
		end
	end

	if arg_78_0.apply_bot_spawn_priority_popup_id then
		local var_78_17 = Managers.popup:query_result(arg_78_0.apply_bot_spawn_priority_popup_id)

		if var_78_17 then
			Managers.popup:cancel_popup(arg_78_0.apply_bot_spawn_priority_popup_id)

			arg_78_0.apply_bot_spawn_priority_popup_id = nil

			arg_78_0:handle_apply_popup_results(var_78_17)
		end
	end

	if arg_78_0.exit_popup_id then
		local var_78_18 = Managers.popup:query_result(arg_78_0.exit_popup_id)

		if var_78_18 then
			Managers.popup:cancel_popup(arg_78_0.exit_popup_id)

			arg_78_0.exit_popup_id = nil

			arg_78_0:handle_exit_button_popup_results(var_78_18)
		end
	end

	if OPTIONS_VIEW_PRINT_ORIGINAL_VALUES then
		print("------------------------")
		print("ORIGINAL USER SETTINGS")

		local var_78_19 = arg_78_0.original_user_settings

		for iter_78_2, iter_78_3 in pairs(var_78_19) do
			printf("  - %s  %s", iter_78_2, tostring(iter_78_3))
		end

		print("ORIGINAL RENDER SETTINGS")

		local var_78_20 = arg_78_0.original_render_settings

		for iter_78_4, iter_78_5 in pairs(var_78_20) do
			printf("  - %s  %s", iter_78_4, tostring(iter_78_5))
		end

		print("/-----------------------")

		OPTIONS_VIEW_PRINT_ORIGINAL_VALUES = false
	end

	if not var_78_4 then
		local var_78_21 = arg_78_0.exit_button.content.button_hotspot

		if var_78_21.on_hover_enter then
			WwiseWorld.trigger_event(arg_78_0.wwise_world, "Play_hud_hover")
		end

		local var_78_22 = arg_78_0.back_button.content.button_hotspot

		if var_78_22.on_hover_enter then
			WwiseWorld.trigger_event(arg_78_0.wwise_world, "Play_hud_hover")
		end

		if not var_78_0 and not arg_78_0:has_popup() and not arg_78_0.draw_gamepad_tooltip then
			if not var_78_11 and var_78_8:get("toggle_menu", true) or var_78_21.is_hover and var_78_21.on_release or var_78_22.is_hover and var_78_22.on_release then
				WwiseWorld.trigger_event(arg_78_0.wwise_world, "Play_hud_select")
				arg_78_0:on_exit_pressed()
			end

			UIWidgetUtils.animate_layout_button(arg_78_0.back_button, arg_78_1)
		end
	end
end

OptionsView._update_animations = function (arg_79_0, arg_79_1)
	local var_79_0 = arg_79_0._ui_animator

	var_79_0:update(arg_79_1)

	local var_79_1 = arg_79_0._animations

	for iter_79_0, iter_79_1 in pairs(var_79_1) do
		if var_79_0:is_animation_completed(iter_79_1) then
			var_79_1[iter_79_0] = nil
		end
	end
end

OptionsView._handle_ps_pads = function (arg_80_0, arg_80_1)
	if not IS_WINDOWS or not arg_80_1 then
		return
	end

	local var_80_0 = arg_80_0.gamepad_layout_widget

	if not var_80_0 then
		return
	end

	local var_80_1 = Managers.input:get_most_recent_device()
	local var_80_2 = var_0_12(arg_80_0.changed_user_settings.gamepad_use_ps4_style_input_icons, Application.user_setting("gamepad_use_ps4_style_input_icons"))

	var_80_0.content.use_texture2_layout = var_80_1.type() == "sce_pad" or var_80_2
end

OptionsView.cb_delete_save = function (arg_81_0, arg_81_1)
	if arg_81_1.error then
		Application.warning(string.format("[StateTitleScreenLoadSave] Error when overriding save data %q", arg_81_1.error))
	end

	arg_81_0.disable_all_input = false
end

OptionsView.on_gamepad_activated = function (arg_82_0)
	local var_82_0 = arg_82_0.title_buttons
	local var_82_1 = arg_82_0.title_buttons_n

	for iter_82_0 = 1, var_82_1 do
		var_82_0[iter_82_0].content.disable_side_textures = true
	end
end

OptionsView.on_gamepad_deactivated = function (arg_83_0)
	local var_83_0 = arg_83_0.title_buttons
	local var_83_1 = arg_83_0.title_buttons_n

	for iter_83_0 = 1, var_83_1 do
		var_83_0[iter_83_0].content.disable_side_textures = false
	end
end

OptionsView.on_exit_pressed = function (arg_84_0)
	if arg_84_0:changes_been_made() then
		local var_84_0 = Localize("unapplied_changes_popup_text")

		arg_84_0.exit_popup_id = Managers.popup:queue_popup(var_84_0, Localize("popup_discard_changes_topic"), "revert_changes", Localize("popup_choice_discard"), "cancel", Localize("popup_choice_cancel"))
	else
		arg_84_0:exit()
	end
end

local var_0_22 = var_0_1.needs_restart_settings

OptionsView.handle_apply_popup_results = function (arg_85_0, arg_85_1)
	if arg_85_1 == "keep_changes" then
		local var_85_0 = false

		for iter_85_0, iter_85_1 in pairs(arg_85_0.changed_user_settings) do
			if table.contains(var_0_22, iter_85_0) then
				var_85_0 = true

				break
			end
		end

		for iter_85_2, iter_85_3 in pairs(arg_85_0.changed_render_settings) do
			if table.contains(var_0_22, iter_85_2) then
				var_85_0 = true

				break
			end
		end

		if var_85_0 and not arg_85_0.in_title_screen then
			local var_85_1 = Localize("changes_need_restart_popup_text")

			arg_85_0.apply_popup_id = Managers.popup:queue_popup(var_85_1, Localize("popup_needs_restart_topic"), "continue", Localize("popup_choice_continue"), "restart", Localize("popup_choice_restart_now"))
		elseif arg_85_0.delayed_title_change then
			arg_85_0:select_settings_title(arg_85_0.delayed_title_change)

			arg_85_0.delayed_title_change = nil
		end

		arg_85_0:set_original_settings()
		arg_85_0:reset_changed_settings()
	elseif arg_85_1 == "reset_values" then
		arg_85_0:reset_current_settings_list_to_default()
		arg_85_0:handle_apply_changes()
	elseif arg_85_1 == "revert_changes" then
		if arg_85_0.changed_keymaps then
			arg_85_0:apply_keymap_changes(arg_85_0.original_keymaps, true)
		else
			arg_85_0:apply_changes(arg_85_0.original_user_settings, arg_85_0.original_render_settings, arg_85_0.original_versus_settings, arg_85_0.original_bot_spawn_priority, false)
		end

		if arg_85_0.delayed_title_change then
			arg_85_0:select_settings_title(arg_85_0.delayed_title_change)

			arg_85_0.delayed_title_change = nil
		else
			arg_85_0:set_original_settings()
			arg_85_0:reset_changed_settings()
			arg_85_0:set_widget_values(arg_85_0.selected_settings_list)
		end
	elseif arg_85_1 == "restart" then
		arg_85_0:restart()
	elseif arg_85_1 == "continue" then
		if arg_85_0.delayed_title_change then
			arg_85_0:select_settings_title(arg_85_0.delayed_title_change)

			arg_85_0.delayed_title_change = nil
		end
	else
		print(arg_85_1)
	end
end

OptionsView.restart = function (arg_86_0)
	arg_86_0:exit()
	arg_86_0.ingame_ui:handle_transition("leave_game")
end

OptionsView.handle_title_buttons_popup_results = function (arg_87_0, arg_87_1)
	if arg_87_1 == "revert_changes" then
		if arg_87_0.changed_keymaps then
			arg_87_0:apply_keymap_changes(arg_87_0.original_keymaps, true)
		else
			arg_87_0:apply_changes(arg_87_0.original_user_settings, arg_87_0.original_render_settings, arg_87_0.original_versus_settings, arg_87_0.original_bot_spawn_priority, false)
		end

		arg_87_0:reset_changed_settings()

		if arg_87_0.delayed_title_change then
			arg_87_0:select_settings_title(arg_87_0.delayed_title_change)

			arg_87_0.delayed_title_change = nil
		else
			arg_87_0:set_original_settings()
			arg_87_0:set_widget_values(arg_87_0.selected_settings_list)
		end
	elseif arg_87_1 == "apply_changes" then
		arg_87_0:handle_apply_changes()
	else
		print(arg_87_1)
	end
end

OptionsView.handle_exit_button_popup_results = function (arg_88_0, arg_88_1)
	if arg_88_1 == "revert_changes" then
		if arg_88_0.changed_keymaps then
			arg_88_0:apply_keymap_changes(arg_88_0.original_keymaps, true)
		else
			arg_88_0:apply_changes(arg_88_0.original_user_settings, arg_88_0.original_render_settings, arg_88_0.original_versus_settings, arg_88_0.original_bot_spawn_priority, false)
		end

		arg_88_0:set_original_settings()
		arg_88_0:reset_changed_settings()
		arg_88_0:exit()
	elseif arg_88_1 == "cancel" then
		-- Nothing
	else
		print(arg_88_1)
	end
end

OptionsView.update_apply_button = function (arg_89_0)
	local var_89_0 = arg_89_0.apply_button

	if arg_89_0:changes_been_made() then
		var_89_0.content.button_text.disabled = false
		var_89_0.content.button_text.disable_button = false
		var_89_0.style.text.text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
	else
		var_89_0.content.button_text.disabled = true
		var_89_0.content.button_text.disable_button = true
	end
end

OptionsView.handle_apply_changes = function (arg_90_0)
	if arg_90_0.changed_keymaps then
		arg_90_0:apply_keymap_changes(arg_90_0.session_keymaps, true)
	else
		arg_90_0:apply_changes(arg_90_0.changed_user_settings, arg_90_0.changed_render_settings, arg_90_0.changed_versus_settings, arg_90_0.session_bot_spawn_priority, arg_90_0.changed_bot_spawn_priority)
	end

	if IS_WINDOWS and arg_90_0.selected_settings_list.needs_apply_confirmation then
		local var_90_0 = Localize("keep_changes_popup_text")

		arg_90_0.apply_popup_id = Managers.popup:queue_popup(var_90_0, Localize("popup_keep_changes_topic"), "keep_changes", Localize("popup_choice_keep"), "revert_changes", Localize("popup_choice_revert"))

		Managers.popup:activate_timer(arg_90_0.apply_popup_id, 15, "revert_changes", "center")
	else
		arg_90_0:handle_apply_popup_results("keep_changes")

		if arg_90_0.delayed_title_change then
			arg_90_0:select_settings_title(arg_90_0.delayed_title_change)

			arg_90_0.delayed_title_change = nil
		end
	end
end

OptionsView.handle_apply_button = function (arg_91_0, arg_91_1, arg_91_2)
	if arg_91_0.apply_button.content.button_text.disabled then
		return
	end

	local var_91_0 = arg_91_0.apply_button.content.button_text

	if var_91_0.on_hover_enter then
		WwiseWorld.trigger_event(arg_91_0.wwise_world, "Play_hud_hover")
	end

	if var_91_0.is_hover and var_91_0.on_release or arg_91_2 and arg_91_1:get("refresh") then
		WwiseWorld.trigger_event(arg_91_0.wwise_world, "Play_hud_select")

		if arg_91_0.apply_popup_id then
			local var_91_1 = arg_91_0.input_manager:is_device_active("gamepad")
			local var_91_2 = arg_91_0:changes_been_made()
			local var_91_3 = Managers.popup._handler.n_popups

			table.dump(Managers.popup._handler.popups, "popups", 2)

			local var_91_4 = {}

			arg_91_0.input_manager:get_blocked_services(nil, nil, var_91_4)
			table.dump(var_91_4, "blocked_input_services", 2)
			Crashify.print_exception("OptionsView", "Apply button wasn't disabled, even though we had an apply popup...")
		else
			arg_91_0:handle_apply_changes()
		end
	end
end

OptionsView.reset_to_default_drop_down = function (arg_92_0, arg_92_1)
	local var_92_0 = arg_92_1.content
	local var_92_1 = var_92_0.default_value

	var_92_0.current_selection = var_92_1
	var_92_0.selected_option = var_92_0.options_texts[var_92_1]

	var_92_0.callback(var_92_0, var_92_1)
end

OptionsView.reset_to_default_slider = function (arg_93_0, arg_93_1)
	local var_93_0 = arg_93_1.content
	local var_93_1 = arg_93_1.style
	local var_93_2 = var_93_0.default_value

	var_93_0.value = var_93_2
	var_93_0.internal_value = var_0_11(var_93_0.min, var_93_0.max, var_93_2)

	var_93_0.callback(var_93_0, var_93_1)
end

OptionsView.reset_to_default_checkbox = function (arg_94_0, arg_94_1)
	local var_94_0 = arg_94_1.content

	var_94_0.flag = var_94_0.default_value

	var_94_0.callback(var_94_0)
end

OptionsView.reset_to_default_stepper = function (arg_95_0, arg_95_1)
	local var_95_0 = arg_95_1.content
	local var_95_1 = arg_95_1.style

	var_95_0.current_selection = var_95_0.default_value

	var_95_0.callback(var_95_0, var_95_1)
end

OptionsView.reset_to_default_option = function (arg_96_0, arg_96_1)
	local var_96_0 = arg_96_1.content

	var_96_0.current_selection = var_96_0.default_value

	var_96_0.callback(var_96_0)
end

OptionsView.reset_to_default_keybind = function (arg_97_0, arg_97_1)
	local var_97_0 = arg_97_1.content
	local var_97_1 = var_97_0.default_value

	var_97_0.callback(UNASSIGNED_KEY, var_97_1.controller, var_97_0, 2)
	var_97_0.callback(var_97_1.key, var_97_1.controller, var_97_0, 1)
end

OptionsView.reset_to_default_sorted_list = function (arg_98_0, arg_98_1)
	local var_98_0 = arg_98_1.content
	local var_98_1 = arg_98_1.style
	local var_98_2 = var_98_0.default_value
	local var_98_3 = var_98_0.current_selection

	if var_98_3 then
		var_98_0.list_content[var_98_3].hotspot.is_selected = false
		var_98_0.current_selection = nil
		var_98_0.up_hotspot.active = false
		var_98_0.down_hotspot.active = false
	end

	var_98_0.callback(var_98_0, var_98_1, var_98_2)
end

OptionsView.reset_current_settings_list_to_default = function (arg_99_0)
	local var_99_0 = arg_99_0.selected_settings_list
	local var_99_1 = var_99_0.widgets
	local var_99_2 = var_99_0.widgets_n

	for iter_99_0 = 1, var_99_2 do
		local var_99_3 = var_99_1[iter_99_0]

		if var_99_3.content.default_value then
			local var_99_4 = var_99_3.type

			if var_99_4 == "drop_down" then
				arg_99_0:reset_to_default_drop_down(var_99_3)
			elseif var_99_4 == "slider" then
				arg_99_0:reset_to_default_slider(var_99_3)
			elseif var_99_4 == "checkbox" then
				arg_99_0:reset_to_default_checkbox(var_99_3)
			elseif var_99_4 == "stepper" then
				arg_99_0:reset_to_default_stepper(var_99_3)
			elseif var_99_4 == "option" then
				arg_99_0:reset_to_default_option(var_99_3)
			elseif var_99_4 == "keybind" then
				arg_99_0:reset_to_default_keybind(var_99_3)
			elseif var_99_4 == "sorted_list" then
				arg_99_0:reset_to_default_sorted_list(var_99_3)
			else
				error("Not supported widget type..")
			end
		end
	end

	if var_0_9[arg_99_0.selected_title] == "keybind_settings" then
		arg_99_0.keybind_info_text = Localize("options_menu_gamepad_reset_text")
	end
end

OptionsView.handle_reset_to_default_button = function (arg_100_0, arg_100_1, arg_100_2)
	local var_100_0 = arg_100_0.reset_to_default.content

	if var_100_0.button_text.disabled or var_100_0.hidden then
		return
	end

	local var_100_1 = arg_100_0.reset_to_default.content.button_text

	if var_100_1.on_hover_enter then
		WwiseWorld.trigger_event(arg_100_0.wwise_world, "Play_hud_hover")
	end

	if var_100_1.on_release or arg_100_2 and arg_100_1:get("special_1") then
		WwiseWorld.trigger_event(arg_100_0.wwise_world, "Play_hud_select")

		local var_100_2 = Localize("reset_settings_popup_text")

		arg_100_0.reset_popup_id = Managers.popup:queue_popup(var_100_2, Localize("popup_discard_changes_topic"), "reset_values", Localize("button_ok"), "revert_changes", Localize("popup_choice_cancel"))
	end
end

OptionsView.draw_widgets = function (arg_101_0, arg_101_1, arg_101_2)
	local var_101_0 = arg_101_0.ui_renderer
	local var_101_1 = arg_101_0.ui_top_renderer or arg_101_0.ui_renderer
	local var_101_2 = arg_101_0.ui_scenegraph
	local var_101_3 = arg_101_0.input_manager
	local var_101_4 = var_101_3:get_service("options_menu")
	local var_101_5 = var_101_3:is_device_active("gamepad")
	local var_101_6 = arg_101_0.draw_gamepad_tooltip
	local var_101_7 = arg_101_0.render_settings

	UIRenderer.begin_pass(var_101_1, var_101_2, var_101_4, arg_101_1, nil, arg_101_0.render_settings)

	local var_101_8 = arg_101_0.background_widgets
	local var_101_9 = arg_101_0.background_widgets_n

	for iter_101_0 = 1, var_101_9 do
		UIRenderer.draw_widget(var_101_1, var_101_8[iter_101_0])
	end

	if arg_101_0.selected_settings_list and not var_101_6 then
		arg_101_0:update_settings_list(arg_101_0.selected_settings_list, var_101_1, var_101_2, var_101_4, arg_101_1, arg_101_2)
	end

	arg_101_0:handle_title_buttons(var_101_1, arg_101_2)

	arg_101_0.reset_to_default.content.button_text.disable_button = arg_101_2
	arg_101_0.exit_button.content.button_hotspot.disable_button = arg_101_2
	arg_101_0.back_button.content.button_hotspot.disable_button = arg_101_2

	if not var_101_5 then
		local var_101_10 = arg_101_0.keybind_info_text

		if var_101_10 then
			local var_101_11 = arg_101_0.keybind_info_widget

			var_101_11.content.text = var_101_10

			UIRenderer.draw_widget(var_101_1, var_101_11)
		end

		if not arg_101_0.reset_to_default.content.hidden then
			UIRenderer.draw_widget(var_101_1, arg_101_0.reset_to_default)
		end

		UIRenderer.draw_widget(var_101_1, arg_101_0.apply_button)
		UIRenderer.draw_widget(var_101_1, arg_101_0.exit_button)

		if arg_101_0.in_title_screen then
			UIRenderer.draw_widget(var_101_1, arg_101_0.back_button)
		end
	elseif var_101_6 then
		UIRenderer.draw_widget(var_101_1, arg_101_0.gamepad_tooltip_text_widget)
	end

	if arg_101_0.safe_rect_widget then
		local var_101_12 = var_101_7.alpha_multiplier

		var_101_7.alpha_multiplier = math.ease_out_exp(arg_101_0.safe_rect_alpha_timer / var_0_16)

		UIRenderer.draw_widget(var_101_1, arg_101_0.safe_rect_widget)

		var_101_7.alpha_multiplier = var_101_12
		arg_101_0.safe_rect_alpha_timer = math.max(arg_101_0.safe_rect_alpha_timer - arg_101_1, 0)
	end

	UIRenderer.end_pass(var_101_1)

	if var_0_9[arg_101_0.selected_title] == "calibrate_ui" then
		arg_101_0.ui_calibration_view:update(arg_101_0.ui_top_renderer, var_101_4, arg_101_1)
	end

	if var_101_5 and not arg_101_0:has_popup() and not arg_101_0.disable_all_input then
		arg_101_0.menu_input_description:draw(var_101_1, arg_101_1)
	end
end

local var_0_23 = {
	0,
	0
}

OptionsView.update_settings_list = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6)
	if arg_102_1.scrollbar then
		local var_102_0 = arg_102_0.scrollbar.content

		var_102_0.button_up_hotspot.disable_button = arg_102_6
		var_102_0.button_down_hotspot.disable_button = arg_102_6
		var_102_0.scroll_bar_info.disable_button = arg_102_6

		UIRenderer.draw_widget(arg_102_2, arg_102_0.scrollbar)
		arg_102_0:update_scrollbar(arg_102_1, arg_102_3)
	end

	local var_102_1 = arg_102_1.scenegraph_id_start
	local var_102_2 = UISceneGraph.get_world_position(arg_102_3, var_102_1)
	local var_102_3 = UISceneGraph.get_world_position(arg_102_3, "list_mask")
	local var_102_4 = UISceneGraph.get_size(arg_102_3, "list_mask")
	local var_102_5 = arg_102_0.selected_widget
	local var_102_6 = Managers.input:is_device_active("gamepad")
	local var_102_7 = arg_102_1.widgets
	local var_102_8 = arg_102_1.widgets_n
	local var_102_9 = 0
	local var_102_10 = false

	for iter_102_0 = 1, var_102_8 do
		local var_102_11 = var_102_7[iter_102_0]
		local var_102_12 = var_102_11.style
		local var_102_13 = var_102_11.name
		local var_102_14 = var_102_12.size
		local var_102_15 = var_102_12.offset

		var_0_23[1] = var_102_2[1] + var_102_15[1]
		var_0_23[2] = var_102_2[2] + var_102_15[2]

		local var_102_16 = math.point_is_inside_2d_box(var_0_23, var_102_3, var_102_4)

		var_0_23[2] = var_0_23[2] + var_102_14[2] / 2

		local var_102_17 = math.point_is_inside_2d_box(var_0_23, var_102_3, var_102_4)

		var_0_23[2] = var_0_23[2] + var_102_14[2] / 2

		local var_102_18 = math.point_is_inside_2d_box(var_0_23, var_102_3, var_102_4)
		local var_102_19 = var_102_16 or var_102_18

		var_102_11.content.visible = var_102_19

		if var_102_19 then
			var_102_9 = var_102_9 + 1
		end

		local var_102_20 = true

		if var_102_6 then
			var_102_20 = false
		elseif var_102_11.content.is_highlighted then
			var_102_20 = false
		end

		if var_102_11.content.disabled then
			var_102_20 = true
		end

		if not var_102_17 then
			var_102_20 = true
		end

		local var_102_21 = var_102_11.content
		local var_102_22 = var_102_21.hotspot_content_ids

		if var_102_22 then
			for iter_102_1 = 1, #var_102_22 do
				var_102_21[var_102_22[iter_102_1]].disable_button = var_102_20
			end
		end

		if var_102_21.highlight_hotspot then
			var_102_21.highlight_hotspot.disable_button = arg_102_6
		end

		local var_102_23 = var_102_11.ui_animations

		for iter_102_2, iter_102_3 in pairs(var_102_23) do
			UIAnimation.update(iter_102_3, arg_102_5)

			if UIAnimation.completed(iter_102_3) then
				var_102_23[iter_102_2] = nil
			end
		end

		if var_102_21.condition_cb then
			var_102_21.condition_cb(var_102_21, var_102_12)
		end

		UIRenderer.draw_widget(arg_102_2, var_102_11)

		if var_102_11.content.is_highlighted then
			arg_102_0:handle_mouse_widget_input(var_102_11, arg_102_4, arg_102_5)
		end

		if var_102_21.highlight_hotspot then
			if var_102_21.highlight_hotspot.on_hover_enter then
				if var_102_10 then
					local var_102_24 = var_102_21.highlight_hotspot.allow_multi_hover

					table.clear(var_102_21.highlight_hotspot)

					var_102_21.highlight_hotspot.allow_multi_hover = var_102_24
				else
					var_102_11.content.is_highlighted = true
					var_102_10 = true

					arg_102_0:select_settings_list_widget(iter_102_0)
				end
			elseif var_102_21.highlight_hotspot.is_hover then
				var_102_10 = true
			end
		end
	end

	arg_102_1.visible_widgets_n = var_102_9
end

OptionsView.update_scrollbar = function (arg_103_0, arg_103_1, arg_103_2)
	local var_103_0 = arg_103_0.scrollbar.content.scroll_bar_info.value
	local var_103_1 = arg_103_1.max_offset_y * var_103_0
	local var_103_2 = arg_103_2[arg_103_1.scenegraph_id]

	var_103_2.offset = var_103_2.offset or {
		0,
		0,
		0
	}
	var_103_2.offset[2] = var_103_1
end

OptionsView.handle_title_buttons = function (arg_104_0, arg_104_1, arg_104_2)
	local var_104_0 = arg_104_0.title_buttons
	local var_104_1 = arg_104_0.title_buttons_n
	local var_104_2 = table.find(var_0_9, "versus_settings")

	for iter_104_0 = 1, var_104_1 do
		local var_104_3 = var_104_0[iter_104_0]

		if arg_104_2 then
			var_104_3.content.button_text.disable_button = true
		elseif arg_104_0.is_in_tutorial then
			var_104_3.content.button_text.disable_button = not TutorialSettingsMenuNavigation[iter_104_0]
		elseif arg_104_0.is_in_versus then
			var_104_3.content.button_text.disable_button = iter_104_0 ~= var_104_2
		else
			var_104_3.content.button_text.disable_button = false
		end

		UIRenderer.draw_widget(arg_104_1, var_104_3)

		if arg_104_0.selected_title ~= iter_104_0 then
			local var_104_4 = false
			local var_104_5 = var_104_3.content.button_text

			if var_104_5 and var_104_5.on_hover_enter then
				WwiseWorld.trigger_event(arg_104_0.wwise_world, "Play_hud_hover")
			end

			if var_104_5 and var_104_5.on_release then
				WwiseWorld.trigger_event(arg_104_0.wwise_world, "Play_hud_select")

				var_104_5.is_selected = true
				var_104_4 = true
			end

			if var_104_3.content.controller_button_hotspot and var_104_3.content.controller_button_hotspot.on_release then
				var_104_3.content.controller_button_hotspot.is_selected = true
				var_104_4 = true
			end

			if var_104_4 then
				if arg_104_0:changes_been_made() then
					local var_104_6 = Localize("unapplied_changes_popup_text")

					arg_104_0.title_popup_id = Managers.popup:queue_popup(var_104_6, Localize("popup_discard_changes_topic"), "apply_changes", Localize("menu_settings_apply"), "revert_changes", Localize("popup_choice_discard"))
					arg_104_0.delayed_title_change = iter_104_0
				else
					arg_104_0:select_settings_title(iter_104_0)

					arg_104_0.in_settings_sub_menu = true
				end
			end
		end
	end
end

OptionsView.set_in_versus = function (arg_105_0, arg_105_1)
	arg_105_0.is_in_versus = arg_105_1

	if arg_105_1 and table.find(var_0_9, "versus_settings") then
		arg_105_0:select_settings_title(8)

		arg_105_0.in_settings_sub_menu = true
	end
end

OptionsView.set_widget_values = function (arg_106_0, arg_106_1)
	local var_106_0 = arg_106_1.widgets
	local var_106_1 = arg_106_1.widgets_n

	for iter_106_0 = 1, var_106_1 do
		local var_106_2 = var_106_0[iter_106_0]

		var_106_2.content.saved_value_cb(var_106_2)
	end
end

OptionsView.select_settings_list_widget = function (arg_107_0, arg_107_1)
	local var_107_0 = arg_107_0.selected_settings_list

	if not var_107_0 then
		return
	end

	local var_107_1 = var_107_0.selected_index
	local var_107_2 = var_107_0.widgets

	if var_107_1 then
		local var_107_3 = var_107_2[var_107_1]

		arg_107_0:deselect_settings_list_widget(var_107_3)
	else
		arg_107_0.gamepad_active_generic_actions_name = nil

		arg_107_0:change_gamepad_generic_input_action()
	end

	local var_107_4 = var_107_2[arg_107_1]

	var_107_4.content.is_highlighted = true
	var_107_0.selected_index = arg_107_1
	arg_107_0.gamepad_tooltip_text_widget.content.text = var_107_4.content.tooltip_text
	arg_107_0.gamepad_tooltip_available = var_107_4.content.tooltip_text ~= nil
	arg_107_0.in_settings_sub_menu = true

	local var_107_5 = var_107_4.type
	local var_107_6 = var_0_10[var_107_5].input_description

	if var_107_4.content.disabled then
		arg_107_0.menu_input_description:set_input_description(nil)
	else
		arg_107_0.menu_input_description:set_input_description(var_107_6)
	end
end

OptionsView.deselect_settings_list_widget = function (arg_108_0, arg_108_1)
	arg_108_1.content.is_highlighted = false

	if arg_108_1.content.highlight_hotspot then
		local var_108_0 = arg_108_1.content.highlight_hotspot.allow_multi_hover

		table.clear(arg_108_1.content.highlight_hotspot)

		arg_108_1.content.highlight_hotspot.allow_multi_hover = var_108_0
	end

	arg_108_0.menu_input_description:set_input_description(nil)
end

OptionsView.settings_list_widget_enter = function (arg_109_0, arg_109_1)
	local var_109_0 = arg_109_0.selected_settings_list

	if not var_109_0 then
		return
	end

	var_109_0.widgets[arg_109_1].content.is_active = true
end

OptionsView.select_settings_title = function (arg_110_0, arg_110_1)
	arg_110_0.menu_input_description:set_input_description(nil)

	if arg_110_0.selected_title then
		arg_110_0:deselect_title(arg_110_0.selected_title)
	end

	local var_110_0 = arg_110_0.title_buttons[arg_110_1]
	local var_110_1 = var_110_0.scenegraph_id
	local var_110_2 = arg_110_0.ui_scenegraph[var_110_1].local_position

	var_110_0.content.button_text.is_selected = true
	arg_110_0.selected_title = arg_110_1

	local var_110_3 = var_0_9[arg_110_1]

	fassert(arg_110_0.settings_lists[var_110_3], "No settings list called %q", var_110_3)

	local var_110_4 = arg_110_0.settings_lists[var_110_3]

	if var_110_4.scrollbar then
		arg_110_0:setup_scrollbar(var_110_4)
	end

	if var_110_4.hide_reset then
		arg_110_0.reset_to_default.content.hidden = true
	else
		arg_110_0.reset_to_default.content.hidden = false
	end

	if var_110_3 == "calibrate_ui" then
		arg_110_0.disable_all_input = true
	else
		arg_110_0.disable_all_input = false
	end

	if var_110_4.on_enter then
		var_110_4.on_enter(var_110_4)
	end

	arg_110_0:set_widget_values(var_110_4)

	arg_110_0.selected_settings_list = var_110_4
	arg_110_0.keybind_info_text = var_110_3 == "keybind_settings" and Localize("keybind_deselect_info") or nil
end

OptionsView.deselect_title = function (arg_111_0, arg_111_1)
	local var_111_0 = var_0_9[arg_111_1]
	local var_111_1 = arg_111_0.settings_lists and arg_111_0.settings_lists[var_111_0]

	if var_111_1 and var_111_1.on_exit then
		var_111_1.on_exit()
	end

	arg_111_0.selected_title = nil

	local var_111_2 = arg_111_0.selected_settings_list
	local var_111_3 = var_111_2.selected_index
	local var_111_4 = var_111_2.widgets

	if var_111_3 then
		local var_111_5 = var_111_4[var_111_3]

		arg_111_0:deselect_settings_list_widget(var_111_5)
	end

	arg_111_0.selected_settings_list.selected_index = nil
	arg_111_0.selected_settings_list = nil
	arg_111_0.title_buttons[arg_111_1].content.button_text.is_selected = false
end

OptionsView.handle_dropdown_lists = function (arg_112_0, arg_112_1, arg_112_2)
	for iter_112_0 = 1, arg_112_2 do
		local var_112_0 = arg_112_1[iter_112_0].content
		local var_112_1 = content.list_content

		for iter_112_1 = 1, #var_112_1 do
			if var_112_1[iter_112_1].selected then
				var_112_0.callback(var_112_0.options, iter_112_1)

				break
			end
		end
	end
end

OptionsView.setup_scrollbar = function (arg_113_0, arg_113_1, arg_113_2)
	local var_113_0 = arg_113_0.scrollbar
	local var_113_1 = arg_113_1.scenegraph_id
	local var_113_2 = arg_113_0.ui_scenegraph[var_113_1].size[2]
	local var_113_3 = arg_113_0.ui_scenegraph.list_mask.size[2] / var_113_2

	var_113_0.content.scroll_bar_info.bar_height_percentage = var_113_3

	arg_113_0:set_scrollbar_value(arg_113_2 or 0)
end

OptionsView.update_mouse_scroll_input = function (arg_114_0, arg_114_1)
	local var_114_0 = arg_114_0.selected_settings_list

	if var_114_0 and var_114_0.scrollbar then
		local var_114_1 = arg_114_0.scrollbar.content.scroll_bar_info.value

		if arg_114_1 then
			arg_114_0.scroll_field_widget.content.internal_scroll_value = var_114_1
		end

		local var_114_2 = arg_114_0.scroll_field_widget.content.internal_scroll_value

		if not var_114_2 then
			return
		end

		local var_114_3 = arg_114_0.scroll_value

		if var_114_3 ~= var_114_2 then
			arg_114_0:set_scrollbar_value(var_114_2)
		elseif var_114_3 ~= var_114_1 then
			arg_114_0:set_scrollbar_value(var_114_1)
		end
	end
end

OptionsView.set_scrollbar_value = function (arg_115_0, arg_115_1)
	local var_115_0 = arg_115_0.scroll_value

	if not var_115_0 or arg_115_1 ~= var_115_0 then
		arg_115_0.scrollbar.content.scroll_bar_info.value = arg_115_1
		arg_115_0.scroll_field_widget.content.internal_scroll_value = arg_115_1
		arg_115_0.scroll_value = arg_115_1
	end
end

OptionsView.change_gamepad_generic_input_action = function (arg_116_0, arg_116_1)
	local var_116_0 = arg_116_0.in_settings_sub_menu
	local var_116_1 = "default"
	local var_116_2 = var_116_0 and "sub_menu" or "main_menu"
	local var_116_3 = arg_116_0.reset_to_default.content.hidden or arg_116_0.reset_to_default.content.button_text.disabled
	local var_116_4 = arg_116_0.apply_button.content.button_text.disabled

	if not var_116_3 then
		if not var_116_4 then
			var_116_1 = "reset_and_apply"
		else
			var_116_1 = "reset"
		end
	elseif not var_116_4 then
		var_116_1 = "apply"
	end

	if not arg_116_0.gamepad_active_generic_actions_name or arg_116_0.gamepad_active_generic_actions_name ~= var_116_1 then
		arg_116_0.gamepad_active_generic_actions_name = var_116_1

		local var_116_5 = var_0_13[var_116_2][var_116_1]

		arg_116_0.menu_input_description:change_generic_actions(var_116_5)
	end

	if arg_116_1 then
		arg_116_0.menu_input_description:set_input_description(nil)
	end
end

OptionsView._find_next_title_tab = function (arg_117_0)
	local var_117_0 = 1 + arg_117_0.selected_title % arg_117_0.title_buttons_n
	local var_117_1

	for iter_117_0 = var_117_0, arg_117_0.title_buttons_n do
		local var_117_2 = arg_117_0.title_buttons[iter_117_0]

		if not var_117_2 then
			break
		end

		if not var_117_2.content.button_text.disable_button then
			var_117_1 = iter_117_0

			break
		end
	end

	return var_117_1
end

OptionsView._find_previous_title_tab = function (arg_118_0)
	local var_118_0 = arg_118_0.selected_title - 1

	if var_118_0 < 1 then
		var_118_0 = arg_118_0.title_buttons_n
	end

	local var_118_1

	for iter_118_0 = var_118_0, 1, -1 do
		local var_118_2 = arg_118_0.title_buttons[iter_118_0]

		if not var_118_2 then
			break
		end

		if not var_118_2.content.button_text.disable_button then
			var_118_1 = iter_118_0

			break
		end
	end

	return var_118_1
end

OptionsView.handle_controller_navigation_input = function (arg_119_0, arg_119_1, arg_119_2)
	arg_119_0:change_gamepad_generic_input_action()

	if arg_119_0.controller_cooldown > 0 then
		arg_119_0.controller_cooldown = arg_119_0.controller_cooldown - arg_119_1

		local var_119_0 = arg_119_0.speed_multiplier or 1
		local var_119_1 = GamepadSettings.menu_speed_multiplier_frame_decrease
		local var_119_2 = GamepadSettings.menu_min_speed_multiplier

		arg_119_0.speed_multiplier = math.max(var_119_0 - var_119_1, var_119_2)

		return
	else
		local var_119_3 = arg_119_0.in_settings_sub_menu

		if not var_119_3 then
			var_119_3 = true
			arg_119_0.in_settings_sub_menu = var_119_3

			arg_119_0:set_console_setting_list_selection(1, true, false)
		end

		arg_119_0.draw_gamepad_tooltip = arg_119_0.gamepad_tooltip_available and arg_119_2:get("trigger_cycle_previous_hold")

		if arg_119_0.draw_gamepad_tooltip then
			return
		end

		local var_119_4, var_119_5 = arg_119_0:handle_settings_list_widget_input(arg_119_2, arg_119_1)

		if var_119_4 then
			if var_119_5 ~= nil then
				arg_119_0:set_selected_input_description_by_active(var_119_5)
			end

			return
		elseif arg_119_2:get("back", true) then
			local var_119_6 = arg_119_0.selected_settings_list

			if var_119_6.scrollbar then
				arg_119_0:setup_scrollbar(var_119_6)
			end

			var_119_3 = false
			arg_119_0.in_settings_sub_menu = var_119_3

			arg_119_0:clear_console_setting_list_selection()

			arg_119_0.gamepad_active_generic_actions_name = nil

			arg_119_0:change_gamepad_generic_input_action(true)
			WwiseWorld.trigger_event(arg_119_0.wwise_world, "Play_hud_select")

			if arg_119_0:changes_been_made() then
				local var_119_7 = Localize("unapplied_changes_popup_text")

				arg_119_0.title_popup_id = Managers.popup:queue_popup(var_119_7, Localize("popup_discard_changes_topic"), "apply_changes", Localize("menu_settings_apply"), "revert_changes", Localize("popup_choice_discard"))
			else
				arg_119_0:on_exit_pressed()
			end
		end

		local var_119_8

		if arg_119_2:get("cycle_previous") then
			var_119_8 = arg_119_0:_find_previous_title_tab()
		elseif arg_119_2:get("cycle_next") then
			var_119_8 = arg_119_0:_find_next_title_tab()
		end

		if var_119_8 then
			if arg_119_0:changes_been_made() then
				local var_119_9 = Localize("unapplied_changes_popup_text")

				arg_119_0.title_popup_id = Managers.popup:queue_popup(var_119_9, Localize("popup_discard_changes_topic"), "apply_changes", Localize("menu_settings_apply"), "revert_changes", Localize("popup_choice_discard"))
				arg_119_0.delayed_title_change = var_119_8
			else
				arg_119_0:select_settings_title(var_119_8)
				arg_119_0:set_console_setting_list_selection(1, true)

				arg_119_0.in_settings_sub_menu = true
			end
		end

		if var_119_3 then
			local var_119_10 = arg_119_0.speed_multiplier or 1
			local var_119_11 = arg_119_0.selected_settings_list
			local var_119_12 = var_119_11.widgets
			local var_119_13 = var_119_11.selected_index or 0

			repeat
				local var_119_14 = arg_119_2:get("move_up")
				local var_119_15 = arg_119_2:get("move_up_hold")

				if var_119_14 or var_119_15 then
					arg_119_0.controller_cooldown = GamepadSettings.menu_cooldown * var_119_10

					arg_119_0:set_console_setting_list_selection(var_119_13 - 1, false)

					return
				end

				local var_119_16 = arg_119_2:get("move_down")
				local var_119_17 = arg_119_2:get("move_down_hold")

				if var_119_16 or var_119_17 then
					arg_119_0.controller_cooldown = GamepadSettings.menu_cooldown * var_119_10

					arg_119_0:set_console_setting_list_selection(var_119_13 + 1, true)

					return
				end
			until true
		else
			local var_119_18 = arg_119_0.speed_multiplier or 1
			local var_119_19 = arg_119_0.selected_title or 0

			repeat
				local var_119_20 = arg_119_2:get("move_up")
				local var_119_21 = arg_119_2:get("move_up_hold")

				if var_119_20 or var_119_21 then
					arg_119_0.controller_cooldown = GamepadSettings.menu_cooldown * var_119_18

					arg_119_0:set_console_title_selection(var_119_19 - 1)

					return
				end

				local var_119_22 = arg_119_2:get("move_down")
				local var_119_23 = arg_119_2:get("move_down_hold")

				if var_119_22 or var_119_23 then
					arg_119_0.controller_cooldown = GamepadSettings.menu_cooldown * var_119_18

					arg_119_0:set_console_title_selection(var_119_19 + 1)

					return
				end
			until true
		end
	end

	arg_119_0.speed_multiplier = 1
end

OptionsView.handle_mouse_widget_input = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3)
	local var_120_0 = arg_120_1.type

	arg_120_0._input_functions[var_120_0](arg_120_1, arg_120_2, arg_120_3)
end

OptionsView.handle_settings_list_widget_input = function (arg_121_0, arg_121_1, arg_121_2)
	local var_121_0 = arg_121_0.selected_settings_list
	local var_121_1 = var_121_0.widgets[var_121_0.selected_index or 1]

	if var_121_0.widgets_n == 0 or var_121_1.content.disabled then
		return false
	end

	local var_121_2 = var_121_1.type

	return var_0_10[var_121_2].input_function(var_121_1, arg_121_1, arg_121_2)
end

OptionsView.set_console_title_selection = function (arg_122_0, arg_122_1, arg_122_2)
	local var_122_0 = arg_122_0.selected_title

	if var_122_0 == arg_122_1 then
		return
	elseif not var_122_0 then
		arg_122_1 = 1
	end

	if arg_122_1 > #var_0_9 or arg_122_1 <= 0 then
		return
	end

	if not arg_122_2 then
		WwiseWorld.trigger_event(arg_122_0.wwise_world, "Play_hud_select")
	end

	arg_122_0:select_settings_title(arg_122_1)
end

OptionsView.set_console_setting_list_selection = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3)
	local var_123_0 = arg_123_0.selected_settings_list
	local var_123_1 = var_123_0.selected_index
	local var_123_2 = var_123_0.widgets
	local var_123_3 = var_123_0.widgets_n
	local var_123_4 = arg_123_1
	local var_123_5 = var_123_2[var_123_4]
	local var_123_6 = arg_123_0:is_widget_selectable(var_123_5)

	while not var_123_6 do
		if arg_123_2 then
			var_123_4 = math.min(var_123_4 + 1, var_123_3 + 1)
		else
			var_123_4 = math.max(var_123_4 - 1, 0)
		end

		if var_123_4 < 1 or var_123_3 < var_123_4 then
			return
		end

		local var_123_7 = var_123_2[var_123_4]

		var_123_6 = arg_123_0:is_widget_selectable(var_123_7)
	end

	if not arg_123_3 then
		WwiseWorld.trigger_event(arg_123_0.wwise_world, "Play_hud_select")
	end

	if var_123_0.scrollbar then
		arg_123_0:move_scrollbar_based_on_selection(var_123_4)
	end

	arg_123_0:select_settings_list_widget(var_123_4)
end

OptionsView.is_widget_selectable = function (arg_124_0, arg_124_1)
	return arg_124_1 and arg_124_1.type ~= "image" and arg_124_1.type ~= "gamepad_layout" and arg_124_1.type ~= "title"
end

OptionsView.clear_console_setting_list_selection = function (arg_125_0)
	local var_125_0 = arg_125_0.selected_settings_list

	if not var_125_0 then
		return
	end

	local var_125_1 = var_125_0.selected_index

	if var_125_1 then
		local var_125_2 = var_125_0.widgets[var_125_1]

		arg_125_0:deselect_settings_list_widget(var_125_2)

		var_125_0.selected_index = nil
	end
end

OptionsView.move_scrollbar_based_on_selection = function (arg_126_0, arg_126_1)
	local var_126_0 = arg_126_0.selected_settings_list
	local var_126_1 = var_126_0.selected_index
	local var_126_2 = not var_126_1 and true or var_126_1 < arg_126_1
	local var_126_3 = var_126_0.widgets
	local var_126_4 = var_126_2 and var_126_3[arg_126_1 + 1] or var_126_3[arg_126_1 - 1]

	if var_126_4 then
		local var_126_5 = var_126_0.max_offset_y
		local var_126_6 = arg_126_0.ui_scenegraph
		local var_126_7 = var_126_0.scenegraph_id_start
		local var_126_8 = Vector3.deprecated_copy(UISceneGraph.get_world_position(var_126_6, "list_mask"))
		local var_126_9 = UISceneGraph.get_size(var_126_6, "list_mask")
		local var_126_10 = UISceneGraph.get_world_position(var_126_6, var_126_7)

		if var_126_1 then
			local var_126_11 = var_126_3[var_126_1]
			local var_126_12 = var_126_11.style.offset
			local var_126_13 = var_126_11.style.size

			var_0_23[1] = var_126_10[1] + var_126_12[1]
			var_0_23[2] = var_126_10[2] + var_126_12[2]

			local var_126_14 = math.point_is_inside_2d_box(var_0_23, var_126_8, var_126_9)

			var_0_23[2] = var_0_23[2] + var_126_13[2]
			var_126_14 = var_126_14 and math.point_is_inside_2d_box(var_0_23, var_126_8, var_126_9)

			if not var_126_14 then
				local var_126_15
				local var_126_16 = var_126_10[2] + var_126_12[2] < var_126_8[2] and true or false

				if not var_126_2 and var_126_16 or var_126_2 and not var_126_16 then
					var_126_2 = not var_126_2
					var_126_4 = var_126_11
				end
			end
		end

		local var_126_17 = var_126_4.style
		local var_126_18 = var_126_17.size
		local var_126_19 = var_126_17.offset

		var_0_23[1] = var_126_10[1] + var_126_19[1]
		var_0_23[2] = var_126_10[2] + var_126_19[2]

		local var_126_20 = math.point_is_inside_2d_box(var_0_23, var_126_8, var_126_9)

		var_0_23[2] = var_0_23[2] + var_126_18[2]
		var_126_20 = var_126_20 and math.point_is_inside_2d_box(var_0_23, var_126_8, var_126_9)

		if not var_126_20 then
			local var_126_21 = 0

			if var_126_2 then
				local var_126_22 = var_126_8[2]
				local var_126_23 = var_126_10[2] + var_126_19[2]

				var_126_21 = math.abs(var_126_22 - var_126_23) / var_126_5
			else
				local var_126_24 = var_126_8[2] + var_126_9[2]
				local var_126_25 = var_0_23[2]

				var_126_21 = -(math.abs(var_126_24 - var_126_25) / var_126_5)
			end

			local var_126_26 = arg_126_0.scrollbar.content.scroll_bar_info.value

			arg_126_0:set_scrollbar_value(math.clamp(var_126_26 + var_126_21, 0, 1))
		end
	else
		local var_126_27 = arg_126_0.scrollbar

		if var_126_2 then
			arg_126_0:set_scrollbar_value(1)
		else
			arg_126_0:set_scrollbar_value(0)
		end
	end
end

OptionsView.set_selected_input_description_by_active = function (arg_127_0, arg_127_1)
	local var_127_0 = arg_127_0.selected_settings_list

	if not var_127_0 then
		return
	end

	local var_127_1 = var_127_0.selected_index
	local var_127_2 = var_127_0.widgets[var_127_1]
	local var_127_3 = var_127_2.content.disabled
	local var_127_4 = var_127_2.type
	local var_127_5 = var_0_10[var_127_4]
	local var_127_6 = arg_127_1 and var_127_5.active_input_description or var_127_5.input_description

	if var_127_3 then
		arg_127_0.menu_input_description:set_input_description(nil)
	else
		arg_127_0.menu_input_description:set_input_description(var_127_6)
	end
end

OptionsView.animate_element_by_time = function (arg_128_0, arg_128_1, arg_128_2, arg_128_3, arg_128_4, arg_128_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_128_1, arg_128_2, arg_128_3, arg_128_4, arg_128_5, math.ease_out_quad))
end

OptionsView.animate_element_by_catmullrom = function (arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4, arg_129_5, arg_129_6, arg_129_7, arg_129_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_129_1, arg_129_2, arg_129_3, arg_129_4, arg_129_5, arg_129_6, arg_129_7, arg_129_8))
end

OptionsView.on_stepper_arrow_pressed = function (arg_130_0, arg_130_1, arg_130_2)
	local var_130_0 = arg_130_1.ui_animations
	local var_130_1 = arg_130_1.style[arg_130_2]
	local var_130_2 = {
		28,
		34
	}
	local var_130_3 = var_130_1.color[1]
	local var_130_4 = 255
	local var_130_5 = UISettings.scoreboard.topic_hover_duration

	if var_130_5 > 0 then
		local var_130_6 = "stepper_widget_arrow_hover_" .. arg_130_2
		local var_130_7 = "stepper_widget_arrow_width_" .. arg_130_2
		local var_130_8 = "stepper_widget_arrow_height_" .. arg_130_2

		var_130_0[var_130_6] = arg_130_0:animate_element_by_time(var_130_1.color, 1, var_130_3, var_130_4, var_130_5)
		var_130_0[var_130_7] = arg_130_0:animate_element_by_catmullrom(var_130_1.size, 1, var_130_2[1], 0.7, 1, 1, 0.7, var_130_5)
		var_130_0[var_130_8] = arg_130_0:animate_element_by_catmullrom(var_130_1.size, 2, var_130_2[2], 0.7, 1, 1, 0.7, var_130_5)
	else
		var_130_1.color[1] = var_130_4
	end
end

OptionsView.on_stepper_arrow_hover = function (arg_131_0, arg_131_1, arg_131_2)
	local var_131_0 = arg_131_1.ui_animations
	local var_131_1 = arg_131_1.style[arg_131_2]
	local var_131_2 = var_131_1.color[1]
	local var_131_3 = 255
	local var_131_4 = UISettings.scoreboard.topic_hover_duration
	local var_131_5 = (1 - var_131_2 / var_131_3) * var_131_4

	if var_131_5 > 0 then
		var_131_0["stepper_widget_arrow_hover_" .. arg_131_2] = arg_131_0:animate_element_by_time(var_131_1.color, 1, var_131_2, var_131_3, var_131_5)
	else
		var_131_1.color[1] = var_131_3
	end
end

OptionsView.on_stepper_arrow_dehover = function (arg_132_0, arg_132_1, arg_132_2)
	local var_132_0 = arg_132_1.ui_animations
	local var_132_1 = arg_132_1.style[arg_132_2]
	local var_132_2 = var_132_1.color[1]
	local var_132_3 = 0
	local var_132_4 = UISettings.scoreboard.topic_hover_duration
	local var_132_5 = var_132_2 / 255 * var_132_4

	if var_132_5 > 0 then
		var_132_0["stepper_widget_arrow_hover_" .. arg_132_2] = arg_132_0:animate_element_by_time(var_132_1.color, 1, var_132_2, var_132_3, var_132_5)
	else
		var_132_1.color[1] = var_132_3
	end
end

OptionsView.checkbox_test_setup = function (arg_133_0)
	return false, "test"
end

OptionsView.checkbox_test_saved_value = function (arg_134_0, arg_134_1)
	arg_134_1.content.flag = false
end

OptionsView.checkbox_test = function (arg_135_0, arg_135_1)
	local var_135_0 = arg_135_1.flag

	print("OptionsView:checkbox_test(flag)", arg_135_0, var_135_0)
end

OptionsView.slider_test_setup = function (arg_136_0)
	return 0.5, 5, 500, 0, "Music Volume"
end

OptionsView.slider_test_saved_value = function (arg_137_0, arg_137_1)
	arg_137_1.content.value = 0.5
end

OptionsView.slider_test = function (arg_138_0, arg_138_1)
	local var_138_0 = arg_138_1.value

	print("OptionsView:slider_test(flag)", arg_138_0, var_138_0)
end

OptionsView.drop_down_test_setup = function (arg_139_0)
	local var_139_0 = {
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

	return 1, var_139_0, "Resolution"
end

OptionsView.drop_down_test_saved_value = function (arg_140_0, arg_140_1)
	local var_140_0 = arg_140_1.content.options_values
	local var_140_1 = arg_140_1.content.options_texts

	arg_140_1.content.selected_option = var_140_1[1]
end

OptionsView.drop_down_test = function (arg_141_0, arg_141_1, arg_141_2)
	print("OptionsView:dropdown_test(flag)", arg_141_0, arg_141_1, arg_141_2)
end

OptionsView.cb_stepper_test_setup = function (arg_142_0)
	local var_142_0 = {
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

	return 1, var_142_0, "stepper_test"
end

OptionsView.cb_stepper_test_saved_value = function (arg_143_0, arg_143_1)
	arg_143_1.content.current_selection = 1
end

OptionsView.cb_stepper_test = function (arg_144_0, arg_144_1)
	local var_144_0 = arg_144_1.options_values[arg_144_1.current_selection]

	print(var_144_0)
end

OptionsView.cb_vsync_setup = function (arg_145_0)
	local var_145_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_145_1 = (Application.user_setting("vsync") or false) and 2 or 1
	local var_145_2 = DefaultUserSettings.get("user_settings", "vsync") and 2 or 1

	return var_145_1, var_145_0, "settings_menu_vsync", var_145_2
end

OptionsView.cb_vsync_saved_value = function (arg_146_0, arg_146_1)
	local var_146_0 = var_0_12(arg_146_0.changed_user_settings.vsync, Application.user_setting("vsync"))

	arg_146_1.content.current_selection = var_146_0 and 2 or 1
end

OptionsView.cb_vsync = function (arg_147_0, arg_147_1)
	local var_147_0 = arg_147_1.options_values
	local var_147_1 = arg_147_1.current_selection

	arg_147_0.changed_user_settings.vsync = var_147_0[var_147_1]
end

OptionsView.cb_vsync_condition = function (arg_148_0, arg_148_1, arg_148_2)
	if arg_148_0:_get_setting("render_settings", "dlss_g_enabled") then
		arg_148_0:_set_setting_override(arg_148_1, arg_148_2, "vsync", false)
		arg_148_0:_set_override_reason(arg_148_1, "menu_settings_dlss_frame_generation")

		arg_148_1.disabled = true
	else
		arg_148_0:_restore_setting_override(arg_148_1, arg_148_2, "vsync")

		arg_148_1.disabled = false
	end
end

OptionsView.cb_hud_clamp_ui_scaling_setup = function (arg_149_0)
	local var_149_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_149_1 = (Application.user_setting("hud_clamp_ui_scaling") or false) and 2 or 1
	local var_149_2 = DefaultUserSettings.get("user_settings", "hud_clamp_ui_scaling") and 2 or 1

	return var_149_1, var_149_0, "settings_menu_hud_clamp_ui_scaling", var_149_2
end

OptionsView.cb_hud_clamp_ui_scaling_saved_value = function (arg_150_0, arg_150_1)
	local var_150_0 = var_0_12(arg_150_0.changed_user_settings.hud_clamp_ui_scaling, Application.user_setting("hud_clamp_ui_scaling"))

	arg_150_1.content.current_selection = var_150_0 and 2 or 1
end

OptionsView.cb_hud_clamp_ui_scaling = function (arg_151_0, arg_151_1)
	local var_151_0 = arg_151_1.options_values[arg_151_1.current_selection]

	arg_151_0.changed_user_settings.hud_clamp_ui_scaling = var_151_0

	local var_151_1 = true

	UPDATE_RESOLUTION_LOOKUP(var_151_1)
end

OptionsView.cb_vs_floating_damage = function (arg_152_0, arg_152_1)
	local var_152_0 = arg_152_1.options_values
	local var_152_1 = arg_152_1.current_selection

	arg_152_0.changed_user_settings.vs_floating_damage = var_152_0[var_152_1]
end

OptionsView.cb_vs_floating_damage_setup = function (arg_153_0)
	local var_153_0 = {
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
	local var_153_1 = DefaultUserSettings.get("user_settings", "vs_floating_damage")
	local var_153_2 = Application.user_setting("vs_floating_damage")
	local var_153_3
	local var_153_4

	for iter_153_0, iter_153_1 in ipairs(var_153_0) do
		if iter_153_1.value == var_153_2 then
			var_153_4 = iter_153_0
		end

		if iter_153_1.value == var_153_1 then
			var_153_3 = iter_153_0
		end
	end

	fassert(var_153_3, "default option %i does not exist in cb_enabled_crosshairs_setup options table", var_153_1)

	return var_153_4 or var_153_3, var_153_0, "menu_settings_vs_floating_damage", var_153_3
end

OptionsView.cb_vs_floating_damage_saved_value = function (arg_154_0, arg_154_1)
	local var_154_0 = var_0_12(arg_154_0.changed_user_settings.vs_floating_damage, Application.user_setting("vs_floating_damage")) or DefaultUserSettings.get("user_settings", "vs_floating_damage")
	local var_154_1 = arg_154_1.content.options_values
	local var_154_2 = 1

	for iter_154_0 = 1, #var_154_1 do
		if var_154_0 == var_154_1[iter_154_0] then
			var_154_2 = iter_154_0

			break
		end
	end

	arg_154_1.content.current_selection = var_154_2
end

OptionsView.cb_vs_hud_damage_feedback_in_world_setup = function (arg_155_0)
	local var_155_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_155_1 = (Application.user_setting("hud_damage_feedback_in_world") or false) and 2 or 1
	local var_155_2 = DefaultUserSettings.get("user_settings", "hud_damage_feedback_in_world") and 2 or 1

	return var_155_1, var_155_0, "settings_menu_hud_damage_feedback_in_world", var_155_2
end

OptionsView.cb_vs_hud_damage_feedback_in_world_saved_value = function (arg_156_0, arg_156_1)
	local var_156_0 = var_0_12(arg_156_0.changed_user_settings.hud_damage_feedback_in_world, Application.user_setting("hud_damage_feedback_in_world"))

	arg_156_1.content.current_selection = var_156_0 and 2 or 1
end

OptionsView.cb_vs_hud_damage_feedback_in_world = function (arg_157_0, arg_157_1)
	local var_157_0 = arg_157_1.options_values[arg_157_1.current_selection]

	arg_157_0.changed_user_settings.hud_damage_feedback_in_world = var_157_0
end

OptionsView.cb_vs_hud_damage_feedback_on_yourself_setup = function (arg_158_0)
	local var_158_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_158_1 = (Application.user_setting("hud_damage_feedback_on_yourself") or false) and 2 or 1
	local var_158_2 = DefaultUserSettings.get("user_settings", "hud_damage_feedback_on_yourself") and 2 or 1

	return var_158_1, var_158_0, "settings_menu_hud_damage_feedback_on_yourself", var_158_2
end

OptionsView.cb_vs_hud_damage_feedback_on_yourself_saved_value = function (arg_159_0, arg_159_1)
	local var_159_0 = var_0_12(arg_159_0.changed_user_settings.hud_damage_feedback_on_yourself, Application.user_setting("hud_damage_feedback_on_yourself"))

	arg_159_1.content.current_selection = var_159_0 and 2 or 1
end

OptionsView.cb_vs_hud_damage_feedback_on_yourself = function (arg_160_0, arg_160_1)
	local var_160_0 = arg_160_1.options_values[arg_160_1.current_selection]

	arg_160_0.changed_user_settings.hud_damage_feedback_on_yourself = var_160_0
end

OptionsView.cb_vs_hud_damage_feedback_on_teammates_setup = function (arg_161_0)
	local var_161_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_161_1 = (Application.user_setting("hud_damage_feedback_on_teammates") or false) and 2 or 1
	local var_161_2 = DefaultUserSettings.get("user_settings", "hud_damage_feedback_on_teammates") and 2 or 1

	return var_161_1, var_161_0, "settings_menu_hud_damage_feedback_on_teammates", var_161_2
end

OptionsView.cb_vs_hud_damage_feedback_on_teammates_saved_value = function (arg_162_0, arg_162_1)
	local var_162_0 = var_0_12(arg_162_0.changed_user_settings.hud_damage_feedback_on_teammates, Application.user_setting("hud_damage_feedback_on_teammates"))

	arg_162_1.content.current_selection = var_162_0 and 2 or 1
end

OptionsView.cb_vs_hud_damage_feedback_on_teammates = function (arg_163_0, arg_163_1)
	local var_163_0 = arg_163_1.options_values[arg_163_1.current_selection]

	arg_163_0.changed_user_settings.hud_damage_feedback_on_teammates = var_163_0
end

OptionsView.cb_hud_custom_scale_setup = function (arg_164_0)
	local var_164_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_164_1 = (Application.user_setting("use_custom_hud_scale") or false) and 2 or 1
	local var_164_2 = DefaultUserSettings.get("user_settings", "use_custom_hud_scale") and 2 or 1

	return var_164_1, var_164_0, "settings_menu_hud_custom_scale", var_164_2
end

OptionsView.cb_hud_custom_scale_saved_value = function (arg_165_0, arg_165_1)
	local var_165_0 = var_0_12(arg_165_0.changed_user_settings.use_custom_hud_scale, Application.user_setting("use_custom_hud_scale"))

	arg_165_1.content.current_selection = var_165_0 and 2 or 1
end

OptionsView.cb_hud_custom_scale = function (arg_166_0, arg_166_1)
	local var_166_0 = arg_166_1.options_values[arg_166_1.current_selection]

	arg_166_0.changed_user_settings.use_custom_hud_scale = var_166_0

	if var_166_0 == true then
		arg_166_0:set_widget_disabled("hud_scale", false)
	else
		arg_166_0:set_widget_disabled("hud_scale", true)
	end

	local var_166_1 = true

	UPDATE_RESOLUTION_LOOKUP(var_166_1)
end

OptionsView.cb_enabled_pc_menu_layout_setup = function (arg_167_0)
	local var_167_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_167_1 = (Application.user_setting("use_pc_menu_layout") or false) and 2 or 1
	local var_167_2 = DefaultUserSettings.get("user_settings", "use_pc_menu_layout") and 2 or 1

	return var_167_1, var_167_0, "settings_menu_enabled_pc_menu_layout", var_167_2
end

OptionsView.cb_enabled_pc_menu_layout_saved_value = function (arg_168_0, arg_168_1)
	local var_168_0 = var_0_12(arg_168_0.changed_user_settings.use_pc_menu_layout, Application.user_setting("use_pc_menu_layout"))

	arg_168_1.content.current_selection = var_168_0 and 2 or 1
end

OptionsView.cb_enabled_pc_menu_layout = function (arg_169_0, arg_169_1)
	local var_169_0 = arg_169_1.options_values
	local var_169_1 = arg_169_1.current_selection

	arg_169_0.changed_user_settings.use_pc_menu_layout = var_169_0[var_169_1]
end

OptionsView.cb_enabled_gamepad_hud_layout_setup = function (arg_170_0)
	local var_170_0 = {
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
	local var_170_1 = Application.user_setting("use_gamepad_hud_layout") or "auto"
	local var_170_2 = 1
	local var_170_3 = 1
	local var_170_4 = DefaultUserSettings.get("user_settings", "use_gamepad_hud_layout")

	for iter_170_0, iter_170_1 in ipairs(var_170_0) do
		var_170_2 = var_170_1 == iter_170_1.value and iter_170_0 or var_170_2
		var_170_3 = var_170_4 == iter_170_1.value and iter_170_0 or var_170_3
	end

	return var_170_2, var_170_0, "settings_menu_enabled_gamepad_hud_layout", var_170_3
end

OptionsView.cb_enabled_gamepad_hud_layout_saved_value = function (arg_171_0, arg_171_1)
	local var_171_0 = var_0_12(arg_171_0.changed_user_settings.use_gamepad_hud_layout, Application.user_setting("use_gamepad_hud_layout"))
	local var_171_1 = arg_171_1.content.options_values

	for iter_171_0, iter_171_1 in ipairs(var_171_1) do
		if var_171_0 == iter_171_1 then
			arg_171_1.content.current_selection = iter_171_0

			break
		end
	end
end

OptionsView.cb_enabled_gamepad_hud_layout = function (arg_172_0, arg_172_1)
	local var_172_0 = arg_172_1.options_values
	local var_172_1 = arg_172_1.current_selection

	arg_172_0.changed_user_settings.use_gamepad_hud_layout = var_172_0[var_172_1]
end

OptionsView.cb_fullscreen_setup = function (arg_173_0)
	local var_173_0 = {
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
	local var_173_1 = Application.user_setting("fullscreen")
	local var_173_2 = Application.user_setting("borderless_fullscreen")
	local var_173_3

	var_173_3 = not var_173_1 and not var_173_2

	local var_173_4 = var_173_1 and 1 or var_173_2 and 2 or 3
	local var_173_5 = DefaultUserSettings.get("user_settings", "fullscreen")
	local var_173_6 = DefaultUserSettings.get("user_settings", "borderless_fullscreen")
	local var_173_7 = var_173_5 and 1 or var_173_2 and 2 or 3

	return var_173_4, var_173_0, "menu_settings_windowed_mode", var_173_7
end

OptionsView.cb_fullscreen_saved_value = function (arg_174_0, arg_174_1)
	local var_174_0 = arg_174_1.content.options_values
	local var_174_1 = arg_174_1.content.options_texts
	local var_174_2 = var_0_12(arg_174_0.changed_user_settings.fullscreen, Application.user_setting("fullscreen"))
	local var_174_3 = var_0_12(arg_174_0.changed_user_settings.borderless_fullscreen, Application.user_setting("borderless_fullscreen"))
	local var_174_4

	var_174_4 = not var_174_2 and not var_174_3

	local var_174_5 = var_174_2 and 1 or var_174_3 and 2 or 3

	arg_174_1.content.current_selection = var_174_5
end

OptionsView.cb_fullscreen = function (arg_175_0, arg_175_1)
	local var_175_0 = arg_175_1.current_selection
	local var_175_1 = arg_175_1.options_values[var_175_0]
	local var_175_2 = arg_175_0.changed_user_settings

	if var_175_1 == "fullscreen" then
		var_175_2.fullscreen = true
		var_175_2.borderless_fullscreen = false
	elseif var_175_1 == "borderless_fullscreen" then
		var_175_2.fullscreen = false
		var_175_2.borderless_fullscreen = true
	elseif var_175_1 == "windowed" then
		var_175_2.fullscreen = false
		var_175_2.borderless_fullscreen = false
	end

	if var_175_1 == "borderless_fullscreen" then
		arg_175_0:set_widget_disabled("resolutions", true)
	else
		arg_175_0:set_widget_disabled("resolutions", false)
	end

	if var_175_1 == "fullscreen" then
		arg_175_0:set_widget_disabled("minimize_on_alt_tab", false)
	else
		arg_175_0:set_widget_disabled("minimize_on_alt_tab", true)
	end
end

OptionsView.cb_adapter_setup = function (arg_176_0)
	local var_176_0 = DisplayAdapter.num_adapters()
	local var_176_1 = {}

	for iter_176_0 = 0, var_176_0 - 1 do
		var_176_1[#var_176_1 + 1] = {
			text = tostring(iter_176_0),
			value = iter_176_0
		}
	end

	local var_176_2 = Application.user_setting("adapter_index") + 1
	local var_176_3 = DefaultUserSettings.get("user_settings", "adapter_index") + 1

	return var_176_2, var_176_1, "menu_settings_adapter", var_176_3
end

OptionsView.cb_adapter_saved_value = function (arg_177_0, arg_177_1)
	local var_177_0 = arg_177_1.content.options_values
	local var_177_1 = var_0_12(arg_177_0.changed_user_settings.adapter_index, Application.user_setting("adapter_index")) + 1

	arg_177_1.content.current_selection = var_177_1
end

OptionsView.cb_adapter = function (arg_178_0, arg_178_1, arg_178_2)
	local var_178_0 = arg_178_1.options_values[arg_178_1.current_selection]

	arg_178_0.changed_user_settings.adapter_index = var_178_0
end

OptionsView.cb_minimize_on_alt_tab_setup = function (arg_179_0)
	local var_179_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_179_1 = Application.user_setting("fullscreen_minimize_on_alt_tab")
	local var_179_2 = 1

	for iter_179_0, iter_179_1 in ipairs(var_179_0) do
		if var_179_1 == iter_179_1.value then
			var_179_2 = iter_179_0

			break
		end
	end

	return var_179_2, var_179_0, "menu_settings_minimize_on_alt_tab", true
end

OptionsView.cb_minimize_on_alt_tab_saved_value = function (arg_180_0, arg_180_1)
	local var_180_0 = arg_180_1.content.options_values
	local var_180_1 = var_0_12(arg_180_0.changed_user_settings.fullscreen_minimize_on_alt_tab, Application.user_setting("fullscreen_minimize_on_alt_tab"))
	local var_180_2 = 1

	for iter_180_0, iter_180_1 in ipairs(var_180_0) do
		if var_180_1 == iter_180_1 then
			var_180_2 = iter_180_0

			break
		end
	end

	arg_180_1.content.current_selection = var_180_2
end

OptionsView.cb_minimize_on_alt_tab = function (arg_181_0, arg_181_1, arg_181_2)
	local var_181_0 = arg_181_1.options_values[arg_181_1.current_selection]

	arg_181_0.changed_user_settings.fullscreen_minimize_on_alt_tab = var_181_0
end

OptionsView.cb_graphics_quality_setup = function (arg_182_0)
	local var_182_0 = {
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
	local var_182_1 = Application.user_setting("graphics_quality")
	local var_182_2 = 1

	for iter_182_0, iter_182_1 in ipairs(var_182_0) do
		if var_182_1 == iter_182_1.value then
			var_182_2 = iter_182_0

			break
		end
	end

	return var_182_2, var_182_0, "menu_settings_graphics_quality", "high"
end

OptionsView.cb_graphics_quality_saved_value = function (arg_183_0, arg_183_1)
	local var_183_0 = var_0_12(arg_183_0.changed_user_settings.graphics_quality, Application.user_setting("graphics_quality"))
	local var_183_1 = arg_183_1.content.options_values
	local var_183_2 = 1

	for iter_183_0, iter_183_1 in ipairs(var_183_1) do
		if var_183_0 == iter_183_1 then
			var_183_2 = iter_183_0

			break
		end
	end

	arg_183_1.content.current_selection = var_183_2
end

OptionsView.cb_graphics_quality = function (arg_184_0, arg_184_1)
	local var_184_0 = arg_184_1.options_values[arg_184_1.current_selection]

	arg_184_0.changed_user_settings.graphics_quality = var_184_0

	if var_184_0 == "custom" then
		return
	end

	local var_184_1 = GraphicsQuality[var_184_0]
	local var_184_2 = var_184_1.user_settings

	for iter_184_0, iter_184_1 in pairs(var_184_2) do
		arg_184_0.changed_user_settings[iter_184_0] = iter_184_1
	end

	local var_184_3 = var_184_1.render_settings

	for iter_184_2, iter_184_3 in pairs(var_184_3) do
		arg_184_0.changed_render_settings[iter_184_2] = iter_184_3
	end

	local var_184_4 = arg_184_0.selected_settings_list.widgets
	local var_184_5 = arg_184_0.selected_settings_list.widgets_n

	for iter_184_4 = 1, var_184_5 do
		local var_184_6 = var_184_4[iter_184_4]

		if var_184_6.name ~= "graphics_quality_settings" then
			local var_184_7 = var_184_6.content

			var_184_7.saved_value_cb(var_184_6)
			var_184_7.callback(var_184_7, var_184_6.style, true)
		end
	end
end

OptionsView.cb_resolutions_setup = function (arg_185_0)
	local var_185_0 = Application.user_setting("screen_resolution")
	local var_185_1 = Application.user_setting("fullscreen_output")
	local var_185_2 = Application.user_setting("adapter_index")

	if DisplayAdapter.num_outputs(var_185_2) < 1 then
		local var_185_3 = DisplayAdapter.num_adapters()

		for iter_185_0 = 0, var_185_3 - 1 do
			if DisplayAdapter.num_outputs(iter_185_0) > 0 then
				var_185_2 = iter_185_0

				break
			end
		end
	end

	if DisplayAdapter.num_outputs(var_185_2) < 1 then
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

	local var_185_4 = {}
	local var_185_5 = DisplayAdapter.num_modes(var_185_2, var_185_1)

	for iter_185_1 = 0, var_185_5 - 1 do
		repeat
			local var_185_6, var_185_7 = DisplayAdapter.mode(var_185_2, var_185_1, iter_185_1)

			if var_185_6 < GameSettingsDevelopment.lowest_resolution then
				break
			end

			local var_185_8 = tostring(var_185_6) .. "x" .. tostring(var_185_7)

			var_185_4[#var_185_4 + 1] = {
				text = var_185_8,
				value = {
					var_185_6,
					var_185_7
				}
			}
		until true
	end

	local function var_185_9(arg_186_0, arg_186_1)
		return arg_186_1.value[1] < arg_186_0.value[1]
	end

	table.sort(var_185_4, var_185_9)

	local var_185_10 = 1

	for iter_185_2 = 1, #var_185_4 do
		local var_185_11 = var_185_4[iter_185_2]

		if var_185_11.value[1] == var_185_0[1] and var_185_11.value[2] == var_185_0[2] then
			var_185_10 = iter_185_2

			break
		end
	end

	return var_185_10, var_185_4, "menu_settings_resolution"
end

OptionsView.cb_resolutions_saved_value = function (arg_187_0, arg_187_1)
	local var_187_0 = arg_187_1.content.options_values
	local var_187_1 = arg_187_1.content.options_texts
	local var_187_2 = var_0_12(arg_187_0.changed_user_settings.screen_resolution, Application.user_setting("screen_resolution"))
	local var_187_3 = 1

	for iter_187_0 = 1, #var_187_0 do
		local var_187_4 = var_187_0[iter_187_0]

		if var_187_4[1] == var_187_2[1] and var_187_4[2] == var_187_2[2] then
			var_187_3 = iter_187_0

			break
		end
	end

	arg_187_1.content.current_selection = var_187_3

	local var_187_5 = var_0_12(arg_187_0.changed_user_settings.fullscreen, Application.user_setting("fullscreen"))
	local var_187_6 = var_0_12(arg_187_0.changed_user_settings.borderless_fullscreen, Application.user_setting("borderless_fullscreen"))

	if not var_187_5 and var_187_6 then
		arg_187_1.content.disabled = true
	else
		arg_187_1.content.disabled = false
	end
end

OptionsView.cb_resolutions = function (arg_188_0, arg_188_1)
	local var_188_0 = arg_188_1.current_selection
	local var_188_1 = arg_188_1.options_values[var_188_0]

	if var_188_1 then
		arg_188_0.changed_user_settings.screen_resolution = table.clone(var_188_1)
	end
end

local var_0_24 = table.mirror_array_inplace({
	0,
	30,
	60,
	90,
	120,
	144,
	165
})
local var_0_25 = {
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
	local var_189_0 = var_0_25
	local var_189_1 = var_0_24[Application.user_setting("max_fps")] or 1
	local var_189_2 = var_0_24[DefaultUserSettings.get("user_settings", "max_fps")] or 1

	return var_189_1, var_189_0, "menu_settings_lock_framerate", var_189_2
end

OptionsView.cb_lock_framerate_saved_value = function (arg_190_0, arg_190_1)
	local var_190_0 = arg_190_0:_get_setting("user_settings", "max_fps")

	arg_190_1.content.current_selection = var_0_24[var_190_0] or 1
end

OptionsView.cb_lock_framerate = function (arg_191_0, arg_191_1)
	local var_191_0 = arg_191_1.options_values[arg_191_1.current_selection]

	arg_191_0.changed_user_settings.max_fps = var_191_0
end

OptionsView.cb_max_stacking_frames_setup = function (arg_192_0)
	local var_192_0 = {
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
	local var_192_1 = DefaultUserSettings.get("user_settings", "max_stacking_frames")
	local var_192_2
	local var_192_3 = 1
	local var_192_4 = Application.user_setting("max_stacking_frames") or -1

	for iter_192_0 = 1, #var_192_0 do
		if var_192_4 == var_192_0[iter_192_0].value then
			var_192_3 = iter_192_0
		end

		if var_192_1 == var_192_0[iter_192_0].value then
			var_192_2 = iter_192_0
		end
	end

	return var_192_3, var_192_0, "menu_settings_max_stacking_frames", var_192_2
end

OptionsView.cb_max_stacking_frames_saved_value = function (arg_193_0, arg_193_1)
	local var_193_0 = arg_193_1.content.options_values
	local var_193_1
	local var_193_2 = var_0_12(arg_193_0.changed_user_settings.max_stacking_frames, Application.user_setting("max_stacking_frames")) or -1

	for iter_193_0 = 1, #var_193_0 do
		if var_193_2 == var_193_0[iter_193_0] then
			var_193_1 = iter_193_0

			break
		end
	end

	arg_193_1.content.current_selection = var_193_1
end

OptionsView.cb_max_stacking_frames = function (arg_194_0, arg_194_1)
	arg_194_0.changed_user_settings.max_stacking_frames = arg_194_1.options_values[arg_194_1.current_selection]
end

OptionsView.cb_anti_aliasing_setup = function (arg_195_0)
	local var_195_0 = {
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
	local var_195_1 = Application.user_setting("render_settings", "fxaa_enabled")
	local var_195_2 = Application.user_setting("render_settings", "taa_enabled")
	local var_195_3 = var_195_1 and 2 or var_195_2 and 3 or 1
	local var_195_4 = DefaultUserSettings.get("render_settings", "fxaa_enabled")
	local var_195_5 = DefaultUserSettings.get("render_settings", "taa_enabled")
	local var_195_6 = var_195_4 and 2 or var_195_5 and 3 or 1

	return var_195_3, var_195_0, "menu_settings_anti_aliasing", var_195_6
end

OptionsView.cb_anti_aliasing_saved_value = function (arg_196_0, arg_196_1)
	local var_196_0 = var_0_12(arg_196_0.changed_render_settings.fxaa_enabled, Application.user_setting("render_settings", "fxaa_enabled"))
	local var_196_1 = var_0_12(arg_196_0.changed_render_settings.taa_enabled, Application.user_setting("render_settings", "taa_enabled"))
	local var_196_2 = var_196_0 and 2 or var_196_1 and 3 or 1

	arg_196_1.content.current_selection = var_196_2
end

OptionsView.cb_anti_aliasing = function (arg_197_0, arg_197_1, arg_197_2, arg_197_3)
	local var_197_0 = arg_197_1.current_selection
	local var_197_1 = arg_197_1.options_values[var_197_0]

	if var_197_1 == "FXAA" then
		arg_197_0.changed_render_settings.fxaa_enabled = true
		arg_197_0.changed_render_settings.taa_enabled = false
	elseif var_197_1 == "TAA" then
		arg_197_0.changed_render_settings.fxaa_enabled = false
		arg_197_0.changed_render_settings.taa_enabled = true
	else
		arg_197_0.changed_render_settings.fxaa_enabled = false
		arg_197_0.changed_render_settings.taa_enabled = false
	end

	if not arg_197_3 then
		arg_197_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_anti_aliasing_condition = function (arg_198_0, arg_198_1, arg_198_2)
	if arg_198_0:_get_setting("render_settings", "fsr_enabled") then
		arg_198_0:_set_setting_override(arg_198_1, arg_198_2, "anti_aliasing", "TAA")
		arg_198_0:_set_override_reason(arg_198_1, "settings_view_header_fidelityfx_super_resolution")

		arg_198_1.disabled = true
	elseif arg_198_0:_get_setting("render_settings", "upscaling_mode") == "dlss" then
		arg_198_0:_set_setting_override(arg_198_1, arg_198_2, "anti_aliasing", "none")
		arg_198_0:_set_override_reason(arg_198_1, "menu_settings_dlss_super_resolution")

		arg_198_1.disabled = true
	elseif arg_198_0:_get_setting("render_settings", "upscaling_mode") == "fsr2" then
		arg_198_0:_set_setting_override(arg_198_1, arg_198_2, "anti_aliasing", "none")
		arg_198_0:_set_override_reason(arg_198_1, "menu_settings_fsr2_enabled")

		arg_198_1.disabled = true
	else
		arg_198_0:_restore_setting_override(arg_198_1, arg_198_2, "anti_aliasing")

		arg_198_1.disabled = false
	end
end

OptionsView.cb_gamma_setup = function (arg_199_0)
	local var_199_0 = 1.5
	local var_199_1 = 5
	local var_199_2 = Application.user_setting("render_settings", "gamma") or 2.2
	local var_199_3 = var_0_11(var_199_0, var_199_1, var_199_2)
	local var_199_4 = math.clamp(DefaultUserSettings.get("render_settings", "gamma"), var_199_0, var_199_1)

	Application.set_render_setting("gamma", var_199_2)

	return var_199_3, var_199_0, var_199_1, 1, "menu_settings_gamma", var_199_4
end

OptionsView.cb_gamma_saved_value = function (arg_200_0, arg_200_1)
	local var_200_0 = arg_200_1.content
	local var_200_1 = var_200_0.min
	local var_200_2 = var_200_0.max
	local var_200_3 = var_0_12(arg_200_0.changed_render_settings.gamma, Application.user_setting("render_settings", "gamma")) or 2.2
	local var_200_4 = math.clamp(var_200_3, var_200_1, var_200_2)

	var_200_0.internal_value = var_0_11(var_200_1, var_200_2, var_200_4)
	var_200_0.value = var_200_4

	Application.set_render_setting("gamma", var_200_0.value)
end

OptionsView.cb_gamma = function (arg_201_0, arg_201_1)
	arg_201_0.changed_render_settings.gamma = arg_201_1.value

	Application.set_render_setting("gamma", arg_201_1.value)
end

OptionsView.cb_fsr_enabled_setup = function (arg_202_0)
	local var_202_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_202_1 = Application.user_setting("render_settings", "fsr_enabled")
	local var_202_2 = DefaultUserSettings.get("render_settings", "fsr_enabled")
	local var_202_3 = var_202_1 and 2 or 1
	local var_202_4 = var_202_2 and 2 or 1

	if not IS_WINDOWS then
		Application.set_render_setting("fsr_enabled", var_202_1 and tostring(var_202_1) or tostring(var_202_2))
	end

	return var_202_3, var_202_0, "settings_view_header_fidelityfx_super_resolution", var_202_4
end

OptionsView.cb_fsr_enabled_saved_value = function (arg_203_0, arg_203_1)
	local var_203_0 = var_0_12(arg_203_0.changed_render_settings.fsr_enabled, Application.user_setting("render_settings", "fsr_enabled")) and 2 or 1

	arg_203_1.content.current_selection = var_203_0
end

OptionsView.cb_fsr_enabled = function (arg_204_0, arg_204_1, arg_204_2, arg_204_3)
	local var_204_0 = arg_204_1.options_values[arg_204_1.current_selection]

	arg_204_0.changed_render_settings.fsr_enabled = var_204_0

	if not IS_WINDOWS then
		Application.set_render_setting("fsr_enabled", tostring(var_204_0))
	end
end

OptionsView.cb_fsr_enabled_condition = function (arg_205_0, arg_205_1, arg_205_2)
	if arg_205_0:_get_setting("user_settings", "dlss_enabled") then
		arg_205_0:_set_setting_override(arg_205_1, arg_205_2, "fsr_enabled", false)
		arg_205_0:_set_override_reason(arg_205_1, "menu_settings_dlss_enabled")

		arg_205_1.disabled = true
	elseif arg_205_0:_get_setting("user_settings", "fsr2_enabled") then
		arg_205_0:_set_setting_override(arg_205_1, arg_205_2, "fsr_enabled", false)
		arg_205_0:_set_override_reason(arg_205_1, "menu_settings_fsr2_enabled")

		arg_205_1.disabled = true
	else
		arg_205_0:_restore_setting_override(arg_205_1, arg_205_2, "fsr_enabled")

		arg_205_1.disabled = false
	end
end

OptionsView.cb_fsr_quality_setup = function (arg_206_0)
	local var_206_0 = {
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
	local var_206_1 = Application.user_setting("render_settings", "fsr_quality")
	local var_206_2, var_206_3 = DefaultUserSettings.get("render_settings", "fsr_quality"), var_206_1

	return var_206_3, var_206_0, "menu_settings_fsr_quality", var_206_2
end

OptionsView.cb_fsr_quality_saved_value = function (arg_207_0, arg_207_1)
	local var_207_0 = var_0_12(arg_207_0.changed_render_settings.fsr_quality, Application.user_setting("render_settings", "fsr_quality"))

	arg_207_1.content.current_selection = var_207_0
end

OptionsView.cb_fsr_quality = function (arg_208_0, arg_208_1, arg_208_2, arg_208_3)
	local var_208_0 = arg_208_1.options_values[arg_208_1.current_selection]

	arg_208_0.changed_render_settings.fsr_quality = var_208_0

	if not IS_WINDOWS then
		Application.set_render_setting("fsr_quality", var_208_0)
	end
end

OptionsView.cb_fsr_quality_condition = function (arg_209_0, arg_209_1, arg_209_2)
	if not arg_209_0:_get_setting("render_settings", "fsr_enabled") then
		arg_209_0:_set_setting_override(arg_209_1, arg_209_2, "fsr_quality", arg_209_1.current_selection)
		arg_209_0:_set_override_reason(arg_209_1, "settings_view_header_fidelityfx_super_resolution")

		arg_209_1.disabled = true
	else
		arg_209_0:_restore_setting_override(arg_209_1, arg_209_2, "fsr_quality")

		arg_209_1.disabled = false
	end
end

OptionsView.cb_fsr2_enabled_setup = function (arg_210_0)
	local var_210_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_210_1 = Application.user_setting("fsr2_enabled")
	local var_210_2 = DefaultUserSettings.get("user_settings", "fsr2_enabled")
	local var_210_3 = var_210_1 and 2 or 1
	local var_210_4 = var_210_2 and 2 or 1

	return var_210_3, var_210_0, "menu_settings_fsr2_enabled", var_210_4
end

OptionsView.cb_fsr2_enabled_saved_value = function (arg_211_0, arg_211_1)
	local var_211_0 = arg_211_0:_get_setting("user_settings", "fsr2_enabled") and 2 or 1

	arg_211_1.content.current_selection = var_211_0
end

OptionsView.cb_fsr2_enabled = function (arg_212_0, arg_212_1, arg_212_2, arg_212_3)
	local var_212_0 = arg_212_1.options_values[arg_212_1.current_selection]

	arg_212_0.changed_user_settings.fsr2_enabled = var_212_0

	if var_212_0 then
		arg_212_0.changed_render_settings.upscaling_enabled = true
		arg_212_0.changed_render_settings.upscaling_mode = "fsr2"
		arg_212_0.changed_render_settings.upscaling_quality = "quality"
	else
		arg_212_0.changed_render_settings.upscaling_enabled = false
		arg_212_0.changed_render_settings.upscaling_mode = "none"
		arg_212_0.changed_render_settings.upscaling_quality = "none"
	end
end

OptionsView.cb_fsr2_enabled_condition = function (arg_213_0, arg_213_1, arg_213_2)
	if not Application.render_caps("d3d12") then
		arg_213_0:_set_setting_override(arg_213_1, arg_213_2, "fsr2_enabled", false)
		arg_213_0:_set_override_reason(arg_213_1, "backend_err_playfab_unsupported_version", true)

		arg_213_1.disabled = true
	elseif arg_213_0:_get_setting("render_settings", "fsr2_enabled") then
		arg_213_0:_set_setting_override(arg_213_1, arg_213_2, "fsr2_enabled", false)
		arg_213_0:_set_override_reason(arg_213_1, "settings_view_header_fidelityfx_super_resolution")

		arg_213_1.disabled = true
	elseif arg_213_0:_get_setting("user_settings", "dlss_enabled") then
		arg_213_0:_set_setting_override(arg_213_1, arg_213_2, "fsr2_enabled", false)
		arg_213_0:_set_override_reason(arg_213_1, "menu_settings_dlss_enabled")

		arg_213_1.disabled = true
	else
		arg_213_0:_restore_setting_override(arg_213_1, arg_213_2, "fsr2_enabled")

		arg_213_1.disabled = false
	end
end

local var_0_26 = table.mirror_array_inplace({
	"quality",
	"balanced",
	"performance",
	"ultra_performance"
})

OptionsView.cb_fsr2_quality_setup = function (arg_214_0)
	local var_214_0 = {
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
	local var_214_1 = var_0_26.quality
	local var_214_2 = var_214_1

	if arg_214_0:_get_setting("render_settings", "upscaling_mode") == "fsr2" then
		local var_214_3 = arg_214_0:_get_setting("render_settings", "upscaling_quality")

		var_214_2 = var_0_26[var_214_3] or var_214_2
	else
		local var_214_4 = arg_214_0.overriden_settings.fsr2_quality

		var_214_2 = var_0_26[var_214_4] or var_214_2
	end

	return var_214_2, var_214_0, "menu_settings_fsr2_quality", var_214_1
end

OptionsView.cb_fsr2_quality_saved_value = function (arg_215_0, arg_215_1)
	local var_215_0

	if arg_215_0:_get_setting("render_settings", "upscaling_mode") == "fsr2" then
		var_215_0 = arg_215_0:_get_setting("render_settings", "upscaling_quality")
	else
		var_215_0 = arg_215_0.overriden_settings.fsr2_quality
	end

	arg_215_1.content.current_selection = var_0_26[var_215_0] or 1
end

OptionsView.cb_fsr2_quality = function (arg_216_0, arg_216_1, arg_216_2, arg_216_3)
	local var_216_0 = arg_216_1.options_values[arg_216_1.current_selection]

	if arg_216_0:_get_setting("user_settings", "fsr2_enabled") then
		arg_216_0.changed_render_settings.upscaling_quality = var_216_0
	end
end

OptionsView.cb_fsr2_quality_condition = function (arg_217_0, arg_217_1, arg_217_2)
	if not arg_217_0:_get_setting("user_settings", "fsr2_enabled") then
		local var_217_0 = arg_217_1.options_values[arg_217_1.current_selection]

		arg_217_0:_set_setting_override(arg_217_1, arg_217_2, "fsr2_quality", var_217_0)
		arg_217_0:_set_override_reason(arg_217_1, "menu_settings_fsr2_enabled")

		arg_217_1.disabled = true
	else
		arg_217_0:_restore_setting_override(arg_217_1, arg_217_2, "fsr2_quality")

		arg_217_1.disabled = false
	end
end

OptionsView.cb_dlss_enabled_setup = function (arg_218_0)
	local var_218_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_218_1 = Application.user_setting("dlss_enabled")
	local var_218_2 = DefaultUserSettings.get("user_settings", "dlss_enabled")
	local var_218_3 = var_218_1 and 2 or 1
	local var_218_4 = var_218_2 and 2 or 1

	return var_218_3, var_218_0, "menu_settings_dlss_enabled", var_218_4
end

OptionsView.cb_dlss_enabled_saved_value = function (arg_219_0, arg_219_1)
	local var_219_0 = arg_219_0:_get_setting("user_settings", "dlss_enabled") and 2 or 1

	arg_219_1.content.current_selection = var_219_0
end

OptionsView.cb_dlss_enabled = function (arg_220_0, arg_220_1, arg_220_2, arg_220_3)
	local var_220_0 = arg_220_1.options_values[arg_220_1.current_selection]

	arg_220_0.changed_user_settings.dlss_enabled = var_220_0
end

OptionsView.cb_dlss_enabled_condition = function (arg_221_0, arg_221_1, arg_221_2)
	if arg_221_0:_get_setting("render_settings", "fsr_enabled") then
		arg_221_0:_set_setting_override(arg_221_1, arg_221_2, "dlss_enabled", false)
		arg_221_0:_set_override_reason(arg_221_1, "settings_view_header_fidelityfx_super_resolution")

		arg_221_1.disabled = true
	elseif arg_221_0:_get_setting("user_settings", "fsr2_enabled") then
		arg_221_0:_set_setting_override(arg_221_1, arg_221_2, "dlss_enabled", false)
		arg_221_0:_set_override_reason(arg_221_1, "menu_settings_fsr2_enabled")

		arg_221_1.disabled = true
	else
		arg_221_0:_restore_setting_override(arg_221_1, arg_221_2, "dlss_enabled")

		arg_221_1.disabled = false
	end
end

OptionsView.cb_dlss_frame_generation_setup = function (arg_222_0)
	local var_222_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_222_1 = Application.user_setting("render_settings", "dlss_g_enabled")
	local var_222_2 = DefaultUserSettings.get("render_settings", "dlss_g_enabled")
	local var_222_3 = var_222_1 and 2 or 1
	local var_222_4 = var_222_2 and 2 or 1

	return var_222_3, var_222_0, "menu_settings_dlss_frame_generation", var_222_4
end

OptionsView.cb_dlss_frame_generation_saved_value = function (arg_223_0, arg_223_1)
	local var_223_0 = arg_223_0:_get_setting("render_settings", "dlss_g_enabled") and 2 or 1

	arg_223_1.content.current_selection = var_223_0
end

OptionsView.cb_dlss_frame_generation = function (arg_224_0, arg_224_1, arg_224_2, arg_224_3)
	local var_224_0 = arg_224_1.options_values[arg_224_1.current_selection]

	arg_224_0.changed_render_settings.dlss_g_enabled = var_224_0
end

OptionsView.cb_dlss_frame_generation_condition = function (arg_225_0, arg_225_1, arg_225_2)
	if not Application.render_caps("dlss_g_supported") then
		arg_225_0:_set_setting_override(arg_225_1, arg_225_2, "dlss_frame_generation", false)
		arg_225_0:_set_override_reason(arg_225_1, "backend_err_playfab_unsupported_version", true)

		arg_225_1.disabled = true
	elseif not arg_225_0:_get_setting("user_settings", "dlss_enabled") then
		arg_225_0:_set_setting_override(arg_225_1, arg_225_2, "dlss_frame_generation", false)
		arg_225_0:_set_override_reason(arg_225_1, "menu_settings_dlss_enabled")

		arg_225_1.disabled = true
	else
		arg_225_0:_restore_setting_override(arg_225_1, arg_225_2, "dlss_frame_generation")

		arg_225_1.disabled = false
	end
end

local var_0_27 = table.mirror_array_inplace({
	"none",
	"auto",
	"quality",
	"balanced",
	"performance",
	"ultra_performance",
	"dlaa"
})

OptionsView.cb_dlss_super_resolution_setup = function (arg_226_0)
	local var_226_0 = {
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
	local var_226_1 = var_0_27.none
	local var_226_2

	if arg_226_0:_get_setting("user_settings", "dlss_enabled") then
		var_226_2 = arg_226_0:_get_setting("render_settings", "upscaling_quality")
	else
		var_226_2 = "none"
	end

	return var_0_27[var_226_2] or selected_option, var_226_0, "menu_settings_dlss_super_resolution", var_226_1
end

OptionsView.cb_dlss_super_resolution_saved_value = function (arg_227_0, arg_227_1)
	local var_227_0

	if arg_227_0:_get_setting("user_settings", "dlss_enabled") then
		var_227_0 = arg_227_0:_get_setting("render_settings", "upscaling_quality")
	else
		var_227_0 = "none"
	end

	arg_227_1.content.current_selection = var_0_27[var_227_0] or 1
end

OptionsView.cb_dlss_super_resolution = function (arg_228_0, arg_228_1, arg_228_2, arg_228_3)
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

OptionsView.cb_dlss_super_resolution_condition = function (arg_229_0, arg_229_1, arg_229_2)
	if not arg_229_0:_get_setting("user_settings", "dlss_enabled") then
		arg_229_0:_set_setting_override(arg_229_1, arg_229_2, "dlss_super_resolution", "none")
		arg_229_0:_set_override_reason(arg_229_1, "menu_settings_dlss_enabled")

		arg_229_1.disabled = true
	else
		arg_229_0:_restore_setting_override(arg_229_1, arg_229_2, "dlss_super_resolution")

		arg_229_1.disabled = false
	end
end

local function var_0_28(arg_230_0, arg_230_1)
	return arg_230_0 and (arg_230_1 and 3 or 2) or 1
end

OptionsView.cb_reflex_low_latency_setup = function (arg_231_0)
	local var_231_0 = {
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
	local var_231_1 = var_0_28(Application.user_setting("render_settings", "nv_low_latency_mode"), Application.user_setting("render_settings", "nv_low_latency_boost"))
	local var_231_2 = var_0_28(DefaultUserSettings.get("render_settings", "nv_low_latency_mode"), DefaultUserSettings.get("render_settings", "nv_low_latency_boost"))

	return var_231_1, var_231_0, "menu_settings_reflex_low_latency", var_231_2
end

OptionsView.cb_reflex_low_latency_saved_value = function (arg_232_0, arg_232_1)
	local var_232_0 = arg_232_0:_get_setting("render_settings", "nv_low_latency_mode")
	local var_232_1 = arg_232_0:_get_setting("render_settings", "nv_low_latency_boost")

	arg_232_1.content.current_selection = var_0_28(var_232_0, var_232_1)
end

OptionsView.cb_reflex_low_latency = function (arg_233_0, arg_233_1, arg_233_2, arg_233_3, arg_233_4)
	local var_233_0 = arg_233_1.options_values[arg_233_1.current_selection]
	local var_233_1 = false
	local var_233_2 = false

	if var_233_0 == 2 then
		var_233_1 = true
	elseif var_233_0 == 3 then
		var_233_1, var_233_2 = true, true
	end

	arg_233_0.changed_render_settings.nv_low_latency_mode = var_233_1
	arg_233_0.changed_render_settings.nv_low_latency_boost = var_233_2

	if not arg_233_4 then
		arg_233_0:_clear_setting_override(arg_233_1, arg_233_2, "reflex_low_latency")
	end
end

OptionsView.cb_reflex_low_latency_condition = function (arg_234_0, arg_234_1, arg_234_2)
	if arg_234_0:_get_setting("render_settings", "dlss_g_enabled") then
		if arg_234_1.current_selection == 1 or arg_234_0.overriden_settings.reflex_low_latency == 1 then
			arg_234_0:_set_setting_override(arg_234_1, arg_234_2, "reflex_low_latency", 2)
			arg_234_0:_set_override_reason(arg_234_1, "menu_settings_dlss_frame_generation")
		end

		arg_234_1.list_content[1].hotspot.disabled = true
	else
		arg_234_0:_restore_setting_override(arg_234_1, arg_234_2, "reflex_low_latency")

		arg_234_1.list_content[1].hotspot.disabled = false
	end
end

OptionsView.cb_reflex_framerate_cap_setup = function (arg_235_0)
	local var_235_0 = var_0_25
	local var_235_1 = var_0_24[Application.user_setting("render_settings", "nv_framerate_cap")] or 1
	local var_235_2 = var_0_24[DefaultUserSettings.get("render_settings", "nv_framerate_cap")]

	return var_235_1, var_235_0, "menu_settings_reflex_framerate_cap", var_235_2
end

OptionsView.cb_reflex_framerate_cap_saved_value = function (arg_236_0, arg_236_1)
	local var_236_0 = arg_236_0:_get_setting("render_settings", "nv_framerate_cap")

	arg_236_1.content.current_selection = var_0_24[var_236_0] or 1
end

OptionsView.cb_reflex_framerate_cap = function (arg_237_0, arg_237_1, arg_237_2, arg_237_3)
	local var_237_0 = arg_237_1.options_values[arg_237_1.current_selection]

	arg_237_0.changed_render_settings.nv_framerate_cap = var_237_0
end

OptionsView.cb_sun_shadows_setup = function (arg_238_0)
	local var_238_0 = {
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
	local var_238_1 = Application.user_setting("render_settings", "sun_shadows")
	local var_238_2 = Application.user_setting("sun_shadow_quality")
	local var_238_3

	if var_238_1 then
		if var_238_2 == "low" then
			var_238_3 = 2
		elseif var_238_2 == "medium" then
			var_238_3 = 3
		elseif var_238_2 == "high" then
			var_238_3 = 4
		elseif var_238_2 == "extreme" then
			var_238_3 = 5
		end
	else
		var_238_3 = 1
	end

	return var_238_3, var_238_0, "menu_settings_sun_shadows"
end

OptionsView.cb_sun_shadows_saved_value = function (arg_239_0, arg_239_1)
	local var_239_0 = var_0_12(arg_239_0.changed_render_settings.sun_shadows, Application.user_setting("render_settings", "sun_shadows"))
	local var_239_1 = var_0_12(arg_239_0.changed_user_settings.sun_shadow_quality, Application.user_setting("sun_shadow_quality"))
	local var_239_2

	if var_239_0 then
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

OptionsView.cb_sun_shadows = function (arg_240_0, arg_240_1, arg_240_2, arg_240_3)
	local var_240_0 = arg_240_1.options_values
	local var_240_1 = arg_240_1.current_selection
	local var_240_2
	local var_240_3 = var_240_0[var_240_1]
	local var_240_4

	if var_240_3 == "off" then
		arg_240_0.changed_render_settings.sun_shadows = false
		var_240_4 = "low"
	else
		arg_240_0.changed_render_settings.sun_shadows = true
		var_240_4 = var_240_3
	end

	arg_240_0.changed_user_settings.sun_shadow_quality = var_240_4

	local var_240_5 = SunShadowQuality[var_240_4]

	for iter_240_0, iter_240_1 in pairs(var_240_5) do
		arg_240_0.changed_render_settings[iter_240_0] = iter_240_1
	end

	if not arg_240_3 then
		arg_240_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_lod_quality_setup = function (arg_241_0)
	local var_241_0 = {
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
	local var_241_1 = DefaultUserSettings.get("render_settings", "lod_object_multiplier")
	local var_241_2
	local var_241_3 = Application.user_setting("render_settings", "lod_object_multiplier") or 1
	local var_241_4 = 1

	for iter_241_0 = 1, #var_241_0 do
		if var_241_3 == var_241_0[iter_241_0].value then
			var_241_4 = iter_241_0
		end

		if var_241_1 == var_241_0[iter_241_0].value then
			var_241_2 = iter_241_0
		end
	end

	return var_241_4, var_241_0, "menu_settings_lod_quality", var_241_2
end

OptionsView.cb_lod_quality_saved_value = function (arg_242_0, arg_242_1)
	local var_242_0 = arg_242_1.content.options_values
	local var_242_1 = 1
	local var_242_2 = var_0_12(arg_242_0.changed_render_settings.lod_object_multiplier, Application.user_setting("render_settings", "lod_object_multiplier")) or 1

	for iter_242_0 = 1, #var_242_0 do
		if var_242_2 == var_242_0[iter_242_0] then
			var_242_1 = iter_242_0

			break
		end
	end

	arg_242_1.content.current_selection = var_242_1
end

OptionsView.cb_lod_quality = function (arg_243_0, arg_243_1)
	local var_243_0 = arg_243_1.options_values[arg_243_1.current_selection] or 1

	arg_243_0.changed_render_settings.lod_object_multiplier = var_243_0
end

OptionsView.cb_scatter_density_setup = function (arg_244_0)
	local var_244_0 = {
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
	local var_244_1 = DefaultUserSettings.get("render_settings", "lod_scatter_density")
	local var_244_2
	local var_244_3 = Application.user_setting("render_settings", "lod_scatter_density") or 1
	local var_244_4 = 1

	for iter_244_0 = 1, #var_244_0 do
		if var_244_3 == var_244_0[iter_244_0].value then
			var_244_4 = iter_244_0
		end

		if var_244_1 == var_244_0[iter_244_0].value then
			var_244_2 = iter_244_0
		end
	end

	return var_244_4, var_244_0, "menu_settings_scatter_density", var_244_2
end

OptionsView.cb_scatter_density_saved_value = function (arg_245_0, arg_245_1)
	local var_245_0 = arg_245_1.content.options_values
	local var_245_1 = 1
	local var_245_2 = var_0_12(arg_245_0.changed_render_settings.lod_scatter_density, Application.user_setting("render_settings", "lod_scatter_density")) or 1

	for iter_245_0 = 1, #var_245_0 do
		if var_245_2 == var_245_0[iter_245_0] then
			var_245_1 = iter_245_0

			break
		end
	end

	arg_245_1.content.current_selection = var_245_1
end

OptionsView.cb_scatter_density = function (arg_246_0, arg_246_1, arg_246_2, arg_246_3)
	local var_246_0 = arg_246_1.options_values[arg_246_1.current_selection] or 1

	arg_246_0.changed_render_settings.lod_scatter_density = var_246_0

	if not arg_246_3 then
		arg_246_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_decoration_density_setup = function (arg_247_0)
	local var_247_0 = {
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
	local var_247_1 = Application.user_setting("render_settings", "lod_decoration_density") or 1
	local var_247_2 = 1

	for iter_247_0 = 1, #var_247_0 do
		if var_247_1 == var_247_0[iter_247_0].value then
			var_247_2 = iter_247_0

			break
		end
	end

	return var_247_2, var_247_0, "menu_settings_decoration_density"
end

OptionsView.cb_decoration_density_saved_value = function (arg_248_0, arg_248_1)
	local var_248_0 = arg_248_1.content.options_values
	local var_248_1 = 1
	local var_248_2 = var_0_12(arg_248_0.changed_render_settings.lod_decoration_density, Application.user_setting("render_settings", "lod_decoration_density")) or 1

	for iter_248_0 = 1, #var_248_0 do
		if var_248_2 == var_248_0[iter_248_0] then
			var_248_1 = iter_248_0

			break
		end
	end

	arg_248_1.content.current_selection = var_248_1
end

OptionsView.cb_decoration_density = function (arg_249_0, arg_249_1)
	local var_249_0 = arg_249_1.options_values[arg_249_1.current_selection] or 1

	arg_249_0.changed_render_settings.lod_decoration_density = var_249_0
end

OptionsView.cb_maximum_shadow_casting_lights_setup = function (arg_250_0)
	local var_250_0 = 1
	local var_250_1 = 10
	local var_250_2 = Application.user_setting("render_settings", "max_shadow_casting_lights")

	return var_0_11(var_250_0, var_250_1, var_250_2), var_250_0, var_250_1, 0, "menu_settings_maximum_shadow_casting_lights"
end

OptionsView.cb_maximum_shadow_casting_lights_saved_value = function (arg_251_0, arg_251_1)
	local var_251_0 = arg_251_1.content
	local var_251_1 = var_251_0.min
	local var_251_2 = var_251_0.max
	local var_251_3 = var_0_12(arg_251_0.changed_render_settings.max_shadow_casting_lights, Application.user_setting("render_settings", "max_shadow_casting_lights"))
	local var_251_4 = math.clamp(var_251_3, var_251_1, var_251_2)

	var_251_0.internal_value = var_0_11(var_251_1, var_251_2, var_251_4)
	var_251_0.value = var_251_4
end

OptionsView.cb_maximum_shadow_casting_lights = function (arg_252_0, arg_252_1, arg_252_2, arg_252_3)
	arg_252_0.changed_render_settings.max_shadow_casting_lights = arg_252_1.value

	print("max_shadow_casting_lights", arg_252_1.value)

	if not arg_252_3 then
		arg_252_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_local_light_shadow_quality_setup = function (arg_253_0)
	local var_253_0 = {
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
	local var_253_1 = Application.user_setting("local_light_shadow_quality")
	local var_253_2 = Application.user_setting("render_settings", "deferred_local_lights_cast_shadows")
	local var_253_3 = Application.user_setting("render_settings", "forward_local_lights_cast_shadows")
	local var_253_4

	if not var_253_2 or not var_253_3 then
		var_253_4 = 1
	elseif var_253_1 == "low" then
		var_253_4 = 2
	elseif var_253_1 == "medium" then
		var_253_4 = 3
	elseif var_253_1 == "high" then
		var_253_4 = 4
	elseif var_253_1 == "extreme" then
		var_253_4 = 5
	end

	return var_253_4, var_253_0, "menu_settings_local_light_shadow_quality"
end

OptionsView.cb_local_light_shadow_quality_saved_value = function (arg_254_0, arg_254_1)
	local var_254_0 = var_0_12(arg_254_0.changed_user_settings.local_light_shadow_quality, Application.user_setting("local_light_shadow_quality"))
	local var_254_1 = var_0_12(arg_254_0.changed_render_settings.deferred_local_lights_cast_shadows, Application.user_setting("render_settings", "deferred_local_lights_cast_shadows"))
	local var_254_2 = var_0_12(arg_254_0.changed_render_settings.forward_local_lights_cast_shadows, Application.user_setting("render_settings", "forward_local_lights_cast_shadows"))
	local var_254_3

	if not var_254_1 or not var_254_2 then
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

OptionsView.cb_local_light_shadow_quality = function (arg_255_0, arg_255_1, arg_255_2, arg_255_3)
	local var_255_0 = arg_255_1.options_values[arg_255_1.current_selection]
	local var_255_1
	local var_255_2

	if var_255_0 == "off" then
		arg_255_0.changed_render_settings.deferred_local_lights_cast_shadows = false
		arg_255_0.changed_render_settings.forward_local_lights_cast_shadows = false
		var_255_2 = "low"
	else
		arg_255_0.changed_render_settings.deferred_local_lights_cast_shadows = true
		arg_255_0.changed_render_settings.forward_local_lights_cast_shadows = true
		var_255_2 = var_255_0
	end

	arg_255_0.changed_user_settings.local_light_shadow_quality = var_255_2

	local var_255_3 = LocalLightShadowQuality[var_255_2]

	for iter_255_0, iter_255_1 in pairs(var_255_3) do
		arg_255_0.changed_render_settings[iter_255_0] = iter_255_1
	end

	if not arg_255_3 then
		arg_255_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_motion_blur_setup = function (arg_256_0)
	local var_256_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_256_1 = Application.user_setting("render_settings", "motion_blur_enabled")

	if var_256_1 == nil then
		var_256_1 = true
	end

	local var_256_2 = DefaultUserSettings.get("render_settings", "motion_blur_enabled")
	local var_256_3 = var_256_1 and 2 or 1
	local var_256_4 = var_256_2 and 2 or 1

	if not IS_WINDOWS then
		Application.set_render_setting("motion_blur_enabled", tostring(var_256_1))
	end

	return var_256_3, var_256_0, "menu_settings_motion_blur", var_256_4
end

OptionsView.cb_motion_blur_saved_value = function (arg_257_0, arg_257_1)
	local var_257_0 = var_0_12(arg_257_0.changed_render_settings.motion_blur_enabled, Application.user_setting("render_settings", "motion_blur_enabled")) and 2 or 1

	arg_257_1.content.current_selection = var_257_0
end

OptionsView.cb_motion_blur = function (arg_258_0, arg_258_1, arg_258_2, arg_258_3)
	local var_258_0 = arg_258_1.options_values[arg_258_1.current_selection]

	arg_258_0.changed_render_settings.motion_blur_enabled = var_258_0

	if IS_WINDOWS and not arg_258_3 then
		arg_258_0:force_set_widget_value("graphics_quality_settings", "custom")
	elseif not IS_WINDOWS then
		Application.set_render_setting("motion_blur_enabled", tostring(var_258_0))
	end
end

OptionsView.cb_dof_setup = function (arg_259_0)
	local var_259_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}

	return Application.user_setting("render_settings", "dof_enabled") and 2 or 1, var_259_0, "menu_settings_dof"
end

OptionsView.cb_dof_saved_value = function (arg_260_0, arg_260_1)
	local var_260_0 = var_0_12(arg_260_0.changed_render_settings.dof_enabled, Application.user_setting("render_settings", "dof_enabled")) and 2 or 1

	arg_260_1.content.current_selection = var_260_0
end

OptionsView.cb_dof = function (arg_261_0, arg_261_1, arg_261_2, arg_261_3)
	local var_261_0 = arg_261_1.options_values[arg_261_1.current_selection]

	arg_261_0.changed_render_settings.dof_enabled = var_261_0

	if not arg_261_3 then
		arg_261_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_bloom_setup = function (arg_262_0)
	local var_262_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_262_1 = Application.user_setting("render_settings", "bloom_enabled") or false
	local var_262_2 = DefaultUserSettings.get("render_settings", "bloom_enabled")
	local var_262_3 = var_262_1 and 2 or 1
	local var_262_4 = var_262_2 and 2 or 1

	return var_262_3, var_262_0, "menu_settings_bloom", var_262_4
end

OptionsView.cb_bloom_saved_value = function (arg_263_0, arg_263_1)
	local var_263_0 = var_0_12(arg_263_0.changed_render_settings.bloom_enabled, Application.user_setting("render_settings", "bloom_enabled")) or false

	arg_263_1.content.current_selection = var_263_0 and 2 or 1
end

OptionsView.cb_bloom = function (arg_264_0, arg_264_1, arg_264_2, arg_264_3)
	local var_264_0 = arg_264_1.options_values
	local var_264_1 = arg_264_1.current_selection

	arg_264_0.changed_render_settings.bloom_enabled = var_264_0[var_264_1]

	if not arg_264_3 then
		arg_264_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_light_shafts_setup = function (arg_265_0)
	local var_265_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_265_1 = Application.user_setting("render_settings", "light_shafts_enabled") or false
	local var_265_2 = DefaultUserSettings.get("render_settings", "light_shafts_enabled")
	local var_265_3 = var_265_1 and 2 or 1
	local var_265_4 = var_265_2 and 2 or 1

	return var_265_3, var_265_0, "menu_settings_light_shafts", var_265_4
end

OptionsView.cb_light_shafts_saved_value = function (arg_266_0, arg_266_1)
	local var_266_0 = var_0_12(arg_266_0.changed_render_settings.light_shafts_enabled, Application.user_setting("render_settings", "light_shafts_enabled")) or false

	arg_266_1.content.current_selection = var_266_0 and 2 or 1
end

OptionsView.cb_light_shafts = function (arg_267_0, arg_267_1, arg_267_2, arg_267_3)
	local var_267_0 = arg_267_1.options_values
	local var_267_1 = arg_267_1.current_selection

	arg_267_0.changed_render_settings.light_shafts_enabled = var_267_0[var_267_1]

	if not arg_267_3 then
		arg_267_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_sun_flare_setup = function (arg_268_0)
	local var_268_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_268_1 = Application.user_setting("render_settings", "sun_flare_enabled") or false
	local var_268_2 = DefaultUserSettings.get("render_settings", "sun_flare_enabled")
	local var_268_3 = var_268_1 and 2 or 1
	local var_268_4 = var_268_2 and 2 or 1

	return var_268_3, var_268_0, "menu_settings_sun_flare", var_268_4
end

OptionsView.cb_sun_flare_saved_value = function (arg_269_0, arg_269_1)
	local var_269_0 = var_0_12(arg_269_0.changed_render_settings.sun_flare_enabled, Application.user_setting("render_settings", "sun_flare_enabled")) or false

	arg_269_1.content.current_selection = var_269_0 and 2 or 1
end

OptionsView.cb_sun_flare = function (arg_270_0, arg_270_1, arg_270_2, arg_270_3)
	local var_270_0 = arg_270_1.options_values
	local var_270_1 = arg_270_1.current_selection

	arg_270_0.changed_render_settings.sun_flare_enabled = var_270_0[var_270_1]

	if not arg_270_3 then
		arg_270_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_sharpen_setup = function (arg_271_0)
	local var_271_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_271_1 = Application.user_setting("render_settings", "sharpen_enabled") or false
	local var_271_2 = DefaultUserSettings.get("render_settings", "sharpen_enabled")
	local var_271_3 = var_271_1 and 2 or 1
	local var_271_4 = var_271_2 and 2 or 1

	return var_271_3, var_271_0, "menu_settings_sharpen", var_271_4
end

OptionsView.cb_sharpen_saved_value = function (arg_272_0, arg_272_1)
	local var_272_0 = var_0_12(arg_272_0.changed_render_settings.sharpen_enabled, Application.user_setting("render_settings", "sharpen_enabled")) or false

	arg_272_1.content.current_selection = var_272_0 and 2 or 1
end

OptionsView.cb_sharpen = function (arg_273_0, arg_273_1, arg_273_2, arg_273_3)
	local var_273_0 = arg_273_1.options_values[arg_273_1.current_selection]

	arg_273_0.changed_render_settings.sharpen_enabled = var_273_0

	if not arg_273_3 then
		arg_273_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_sharpen_condition = function (arg_274_0, arg_274_1, arg_274_2)
	return
end

OptionsView.cb_lens_quality_setup = function (arg_275_0)
	local var_275_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_275_1 = Application.user_setting("render_settings", "lens_quality_enabled") or false
	local var_275_2 = DefaultUserSettings.get("render_settings", "lens_quality_enabled")
	local var_275_3 = var_275_1 and 2 or 1
	local var_275_4 = var_275_2 and 2 or 1

	return var_275_3, var_275_0, "menu_settings_lens_quality", var_275_4
end

OptionsView.cb_lens_quality_saved_value = function (arg_276_0, arg_276_1)
	local var_276_0 = var_0_12(arg_276_0.changed_render_settings.lens_quality_enabled, Application.user_setting("render_settings", "lens_quality_enabled")) or false

	arg_276_1.content.current_selection = var_276_0 and 2 or 1
end

OptionsView.cb_lens_quality = function (arg_277_0, arg_277_1, arg_277_2, arg_277_3)
	local var_277_0 = arg_277_1.options_values
	local var_277_1 = arg_277_1.current_selection

	arg_277_0.changed_render_settings.lens_quality_enabled = var_277_0[var_277_1]

	if not arg_277_3 then
		arg_277_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_skin_shading_setup = function (arg_278_0)
	local var_278_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_278_1 = Application.user_setting("render_settings", "skin_material_enabled") or false
	local var_278_2 = DefaultUserSettings.get("render_settings", "skin_material_enabled")
	local var_278_3 = var_278_1 and 2 or 1
	local var_278_4 = var_278_2 and 2 or 1

	return var_278_3, var_278_0, "menu_settings_skin_shading", var_278_4
end

OptionsView.cb_skin_shading_saved_value = function (arg_279_0, arg_279_1)
	local var_279_0 = var_0_12(arg_279_0.changed_render_settings.skin_material_enabled, Application.user_setting("render_settings", "skin_material_enabled")) or false

	arg_279_1.content.current_selection = var_279_0 and 2 or 1
end

OptionsView.cb_skin_shading = function (arg_280_0, arg_280_1, arg_280_2, arg_280_3)
	local var_280_0 = arg_280_1.options_values
	local var_280_1 = arg_280_1.current_selection

	arg_280_0.changed_render_settings.skin_material_enabled = var_280_0[var_280_1]

	if not arg_280_3 then
		arg_280_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_ssao_setup = function (arg_281_0)
	local var_281_0 = {
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
	local var_281_1 = Application.user_setting("ao_quality")
	local var_281_2 = DefaultUserSettings.get("user_settings", "ao_quality")
	local var_281_3 = 1
	local var_281_4

	for iter_281_0 = 1, #var_281_0 do
		if var_281_0[iter_281_0].value == var_281_1 then
			var_281_3 = iter_281_0
		end

		if var_281_2 == var_281_0[iter_281_0].value then
			var_281_4 = iter_281_0
		end
	end

	return var_281_3, var_281_0, "menu_settings_ssao", var_281_4
end

OptionsView.cb_ssao_saved_value = function (arg_282_0, arg_282_1)
	local var_282_0 = var_0_12(arg_282_0.changed_user_settings.ao_quality, Application.user_setting("ao_quality"))
	local var_282_1 = arg_282_1.content.options_values
	local var_282_2 = 1

	for iter_282_0 = 1, #var_282_1 do
		if var_282_0 == var_282_1[iter_282_0] then
			var_282_2 = iter_282_0
		end
	end

	arg_282_1.content.current_selection = var_282_2
end

OptionsView.cb_ssao = function (arg_283_0, arg_283_1, arg_283_2, arg_283_3)
	local var_283_0 = arg_283_1.options_values[arg_283_1.current_selection]

	arg_283_0.changed_user_settings.ao_quality = var_283_0

	local var_283_1 = AmbientOcclusionQuality[var_283_0]

	for iter_283_0, iter_283_1 in pairs(var_283_1) do
		arg_283_0.changed_render_settings[iter_283_0] = iter_283_1
	end

	if not arg_283_3 then
		arg_283_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_char_texture_quality_setup = function (arg_284_0)
	local var_284_0 = {
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
	local var_284_1 = Application.user_setting("char_texture_quality")
	local var_284_2 = DefaultUserSettings.get("user_settings", "char_texture_quality")
	local var_284_3 = 1
	local var_284_4

	for iter_284_0 = 1, #var_284_0 do
		if var_284_1 == var_284_0[iter_284_0].value then
			var_284_3 = iter_284_0
		end

		if var_284_2 == var_284_0[iter_284_0].value then
			var_284_4 = iter_284_0
		end
	end

	return var_284_3, var_284_0, "menu_settings_char_texture_quality", var_284_4
end

OptionsView.cb_char_texture_quality_saved_value = function (arg_285_0, arg_285_1)
	local var_285_0 = var_0_12(arg_285_0.changed_user_settings.char_texture_quality, Application.user_setting("char_texture_quality"))
	local var_285_1 = arg_285_1.content.options_values
	local var_285_2 = 1

	for iter_285_0 = 1, #var_285_1 do
		if var_285_0 == var_285_1[iter_285_0] then
			var_285_2 = iter_285_0
		end
	end

	arg_285_1.content.current_selection = var_285_2

	print("OptionsView:cb_char_texture_quality_saved_value", var_285_2, var_285_0)
end

OptionsView.cb_char_texture_quality = function (arg_286_0, arg_286_1, arg_286_2, arg_286_3)
	local var_286_0 = arg_286_1.options_values[arg_286_1.current_selection]

	arg_286_0.changed_user_settings.char_texture_quality = var_286_0

	if not arg_286_3 then
		arg_286_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_env_texture_quality_setup = function (arg_287_0)
	local var_287_0 = {
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
	local var_287_1 = Application.user_setting("env_texture_quality")
	local var_287_2 = DefaultUserSettings.get("user_settings", "env_texture_quality")
	local var_287_3 = 1
	local var_287_4

	for iter_287_0 = 1, #var_287_0 do
		if var_287_1 == var_287_0[iter_287_0].value then
			var_287_3 = iter_287_0
		end

		if var_287_2 == var_287_0[iter_287_0].value then
			var_287_4 = iter_287_0
		end
	end

	return var_287_3, var_287_0, "menu_settings_env_texture_quality", var_287_4
end

OptionsView.cb_env_texture_quality_saved_value = function (arg_288_0, arg_288_1)
	local var_288_0 = var_0_12(arg_288_0.changed_user_settings.env_texture_quality, Application.user_setting("env_texture_quality"))
	local var_288_1 = arg_288_1.content.options_values
	local var_288_2 = 1

	for iter_288_0 = 1, #var_288_1 do
		if var_288_0 == var_288_1[iter_288_0] then
			var_288_2 = iter_288_0
		end
	end

	arg_288_1.content.current_selection = var_288_2

	print("OptionsView:cb_env_texture_quality_saved_value", var_288_2, var_288_0)
end

OptionsView.cb_env_texture_quality = function (arg_289_0, arg_289_1, arg_289_2, arg_289_3)
	local var_289_0 = arg_289_1.options_values[arg_289_1.current_selection]

	arg_289_0.changed_user_settings.env_texture_quality = var_289_0

	if not arg_289_3 then
		arg_289_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_subtitles_setup = function (arg_290_0)
	local var_290_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_290_1 = (Application.user_setting("use_subtitles") or false) and 2 or 1
	local var_290_2 = DefaultUserSettings.get("user_settings", "use_subtitles") and 2 or 1

	return var_290_1, var_290_0, "menu_settings_subtitles", var_290_2
end

OptionsView.cb_subtitles_saved_value = function (arg_291_0, arg_291_1)
	local var_291_0 = var_0_12(arg_291_0.changed_user_settings.use_subtitles, Application.user_setting("use_subtitles")) or false

	arg_291_1.content.current_selection = var_291_0 and 2 or 1
end

OptionsView.cb_subtitles = function (arg_292_0, arg_292_1)
	local var_292_0 = arg_292_1.options_values
	local var_292_1 = arg_292_1.current_selection

	arg_292_0.changed_user_settings.use_subtitles = var_292_0[var_292_1]
end

OptionsView.cb_language_setup = function (arg_293_0)
	local var_293_0 = {
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
	local var_293_1 = Application.user_setting("language_id") or rawget(_G, "Steam") and Steam.language() or "en"
	local var_293_2 = DefaultUserSettings.get("user_settings", "language_id") or "en"
	local var_293_3 = 1

	for iter_293_0, iter_293_1 in ipairs(var_293_0) do
		if iter_293_1.value == var_293_1 then
			var_293_3 = iter_293_0
		end

		if iter_293_1.value == var_293_2 then
			var_293_2 = iter_293_0
		end
	end

	return var_293_3, var_293_0, "menu_settings_language", var_293_2
end

OptionsView.cb_language_saved_value = function (arg_294_0, arg_294_1)
	local var_294_0 = var_0_12(arg_294_0.changed_user_settings.language_id, Application.user_setting("language_id")) or "en"
	local var_294_1 = arg_294_1.content.options_values
	local var_294_2 = 1

	for iter_294_0 = 1, #var_294_1 do
		if var_294_0 == var_294_1[iter_294_0] then
			var_294_2 = iter_294_0
		end
	end

	arg_294_1.content.current_selection = var_294_2
end

OptionsView.cb_language = function (arg_295_0, arg_295_1)
	local var_295_0 = arg_295_1.options_values
	local var_295_1 = arg_295_1.current_selection

	arg_295_0.changed_user_settings.language_id = var_295_0[var_295_1]
end

OptionsView.reload_language = function (arg_296_0, arg_296_1)
	if Managers.package:has_loaded("resource_packages/strings", "boot") then
		Managers.package:unload("resource_packages/strings", "boot")
	end

	if arg_296_1 == "en" then
		Application.set_resource_property_preference_order("en")
	else
		Application.set_resource_property_preference_order(arg_296_1, "en")
	end

	Managers.package:load("resource_packages/strings", "boot")

	Managers.localizer = LocalizationManager:new(arg_296_1)

	local function var_296_0(arg_297_0)
		return LocalizerTweakData[arg_297_0] or "<missing LocalizerTweakData \"" .. arg_297_0 .. "\">"
	end

	Managers.localizer:add_macro("TWEAK", var_296_0)

	local function var_296_1(arg_298_0)
		local var_298_0, var_298_1 = string.find(arg_298_0, "__")

		assert(var_298_0 and var_298_1, "[key_parser] You need to specify a key using this format $KEY;<input_service>__<key>. Example: $KEY;options_menu__back (note the dubbel underline separating input service and key")

		local var_298_2 = string.sub(arg_298_0, 1, var_298_0 - 1)
		local var_298_3 = string.sub(arg_298_0, var_298_1 + 1)
		local var_298_4 = Managers.input:get_service(var_298_2)

		fassert(var_298_4, "[key_parser] No input service with the name %s", var_298_2)

		local var_298_5 = var_298_4:get_keymapping(var_298_3)

		fassert(var_298_5, "[key_parser] There is no such key: %s in input service: %s", var_298_3, var_298_2)

		local var_298_6 = Managers.input:get_most_recent_device()
		local var_298_7 = InputAux.get_device_type(var_298_6)
		local var_298_8

		for iter_298_0, iter_298_1 in ipairs(var_298_5.input_mappings) do
			if iter_298_1[1] == var_298_7 then
				var_298_8 = iter_298_1[2]

				break
			end
		end

		local var_298_9

		if var_298_8 then
			var_298_9 = var_298_6.button_name(var_298_8)
			var_298_9 = var_298_7 == "keyboard" and var_298_6.button_locale_name(var_298_8) or var_298_9

			if var_298_7 == "mouse" then
				var_298_9 = string.format("%s %s", "mouse", var_298_9)
			end
		else
			local var_298_10
			local var_298_11 = "keyboard"

			for iter_298_2, iter_298_3 in ipairs(var_298_5.input_mappings) do
				if iter_298_3[1] == var_298_11 then
					var_298_10 = iter_298_3[2]

					break
				end
			end

			if var_298_10 then
				var_298_9 = Keyboard.button_name(var_298_10)
				var_298_9 = Keyboard.button_locale_name(var_298_10) or var_298_9
			else
				var_298_9 = Localize(unassigned_keymap)
			end
		end

		return var_298_9
	end

	Managers.localizer:add_macro("KEY", var_296_1)
end

OptionsView.cb_mouse_look_sensitivity_setup = function (arg_299_0)
	local var_299_0 = -10
	local var_299_1 = 10
	local var_299_2 = Application.user_setting("mouse_look_sensitivity") or 0
	local var_299_3 = DefaultUserSettings.get("user_settings", "mouse_look_sensitivity")
	local var_299_4 = var_0_11(var_299_0, var_299_1, var_299_2)
	local var_299_5 = "win32"
	local var_299_6 = InputUtils.get_platform_filters(PlayerControllerFilters, var_299_5).look.multiplier

	arg_299_0.input_manager:get_service("Player"):get_active_filters(var_299_5).look.function_data.multiplier = var_299_6 * 0.85^-var_299_2

	return var_299_4, var_299_0, var_299_1, 1, "menu_settings_mouse_look_sensitivity", var_299_3
end

OptionsView.cb_mouse_look_sensitivity_saved_value = function (arg_300_0, arg_300_1)
	local var_300_0 = arg_300_1.content
	local var_300_1 = var_300_0.min
	local var_300_2 = var_300_0.max
	local var_300_3 = var_0_12(arg_300_0.changed_user_settings.mouse_look_sensitivity, Application.user_setting("mouse_look_sensitivity")) or 0
	local var_300_4 = math.clamp(var_300_3, var_300_1, var_300_2)

	var_300_0.internal_value = var_0_11(var_300_1, var_300_2, var_300_4)
	var_300_0.value = var_300_4
end

OptionsView.cb_mouse_look_sensitivity = function (arg_301_0, arg_301_1)
	arg_301_0.changed_user_settings.mouse_look_sensitivity = arg_301_1.value
end

OptionsView.cb_hud_scale_setup = function (arg_302_0)
	local var_302_0 = 50
	local var_302_1 = 100
	local var_302_2 = Application.user_setting("hud_scale") or 100
	local var_302_3 = var_0_11(var_302_0, var_302_1, var_302_2)
	local var_302_4 = math.clamp(DefaultUserSettings.get("user_settings", "hud_scale"), var_302_0, var_302_1)

	return var_302_3, var_302_0, var_302_1, 0, "settings_menu_hud_scale", var_302_4
end

OptionsView.cb_hud_scale_saved_value = function (arg_303_0, arg_303_1)
	local var_303_0 = arg_303_1.content
	local var_303_1 = var_303_0.min
	local var_303_2 = var_303_0.max
	local var_303_3 = var_0_12(arg_303_0.changed_user_settings.hud_scale, Application.user_setting("hud_scale")) or 100
	local var_303_4 = math.clamp(var_303_3, var_303_1, var_303_2)

	var_303_0.internal_value = var_0_11(var_303_1, var_303_2, var_303_4)
	var_303_0.value = var_303_4
	var_303_0.disabled = not (Application.user_setting("use_custom_hud_scale") or DefaultUserSettings.get("user_settings", "use_custom_hud_scale"))
end

OptionsView.cb_hud_scale = function (arg_304_0, arg_304_1)
	local var_304_0 = arg_304_1.value

	arg_304_0.changed_user_settings.hud_scale = var_304_0
	UISettings.hud_scale = var_304_0

	local var_304_1 = true

	UPDATE_RESOLUTION_LOOKUP(var_304_1)
	arg_304_0:_setup_text_buttons_width()
end

OptionsView.cb_safe_rect_setup = function (arg_305_0)
	local var_305_0, var_305_1 = Gui.resolution()
	local var_305_2 = 0
	local var_305_3 = 20
	local var_305_4 = Application.user_setting("safe_rect") or var_305_2
	local var_305_5 = var_0_11(var_305_2, var_305_3, var_305_4)
	local var_305_6 = math.clamp(DefaultUserSettings.get("user_settings", "safe_rect"), var_305_2, var_305_3)

	return var_305_5, var_305_2, var_305_3, 0, "settings_menu_hud_safe_rect", var_305_6
end

OptionsView.cb_safe_rect_saved_value = function (arg_306_0, arg_306_1)
	local var_306_0, var_306_1 = Gui.resolution()
	local var_306_2 = 0
	local var_306_3 = 20

	if IS_PS4 then
		local var_306_4 = 5
	end

	local var_306_5 = arg_306_1.content
	local var_306_6 = var_306_5.min
	local var_306_7 = var_306_5.max
	local var_306_8 = var_0_12(arg_306_0.changed_user_settings.safe_rect, Application.user_setting("safe_rect")) or var_306_6
	local var_306_9 = math.clamp(var_306_8, var_306_6, var_306_7)

	var_306_5.internal_value = var_0_11(var_306_6, var_306_7, var_306_9)
	var_306_5.value = var_306_9
end

OptionsView.cb_safe_rect = function (arg_307_0, arg_307_1)
	local var_307_0 = 0
	local var_307_1 = 20

	if IS_PS4 then
		var_307_0 = 5
	end

	local var_307_2 = arg_307_1.value
	local var_307_3 = Application.user_setting("safe_rect") or var_307_0

	arg_307_0.changed_user_settings.safe_rect = var_307_2

	Application.set_user_setting("safe_rect", var_307_2)

	if var_307_2 ~= var_307_3 then
		arg_307_0.safe_rect_alpha_timer = var_0_16
	end
end

OptionsView.cb_gamepad_look_sensitivity_setup = function (arg_308_0)
	local var_308_0 = -10
	local var_308_1 = 10
	local var_308_2 = Application.user_setting("gamepad_look_sensitivity") or 0
	local var_308_3 = DefaultUserSettings.get("user_settings", "gamepad_look_sensitivity")
	local var_308_4 = var_0_11(var_308_0, var_308_1, var_308_2)
	local var_308_5 = math.clamp(var_308_2, var_308_0, var_308_1)

	table.clear(var_0_17)

	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_308_0.platform
	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

	for iter_308_0 = 1, #var_0_17 do
		local var_308_6 = var_0_17[iter_308_0]
		local var_308_7 = InputUtils.get_platform_filters(PlayerControllerFilters, var_308_6)
		local var_308_8 = var_308_7.look_controller.multiplier_x
		local var_308_9 = var_308_7.look_controller_melee.multiplier_x
		local var_308_10 = var_308_7.look_controller_ranged.multiplier_x
		local var_308_11 = arg_308_0.input_manager:get_service("Player"):get_active_filters(var_308_6)
		local var_308_12 = var_308_11.look_controller.function_data

		var_308_12.multiplier_x = var_308_8 * 0.85^-var_308_5
		var_308_12.min_multiplier_x = var_308_7.look_controller.multiplier_min_x and var_308_7.look_controller.multiplier_min_x * 0.85^-var_308_5 or var_308_12.multiplier_x * 0.25

		local var_308_13 = var_308_11.look_controller_melee.function_data

		var_308_13.multiplier_x = var_308_9 * 0.85^-var_308_5
		var_308_13.min_multiplier_x = var_308_7.look_controller_melee.multiplier_min_x and var_308_7.look_controller_melee.multiplier_min_x * 0.85^-var_308_5 or var_308_13.multiplier_x * 0.25

		local var_308_14 = var_308_11.look_controller_ranged.function_data

		var_308_14.multiplier_x = var_308_10 * 0.85^-var_308_5
		var_308_14.min_multiplier_x = var_308_7.look_controller_ranged.multiplier_min_x and var_308_7.look_controller_ranged.multiplier_min_x * 0.85^-var_308_5 or var_308_14.multiplier_x * 0.25
	end

	return var_308_4, var_308_0, var_308_1, 1, "menu_settings_gamepad_look_sensitivity", var_308_3
end

OptionsView.cb_gamepad_look_sensitivity_saved_value = function (arg_309_0, arg_309_1)
	local var_309_0 = arg_309_1.content
	local var_309_1 = var_309_0.min
	local var_309_2 = var_309_0.max
	local var_309_3 = var_0_12(arg_309_0.changed_user_settings.gamepad_look_sensitivity, Application.user_setting("gamepad_look_sensitivity")) or 0
	local var_309_4 = math.clamp(var_309_3, var_309_1, var_309_2)

	var_309_0.internal_value = var_0_11(var_309_1, var_309_2, var_309_4)
	var_309_0.value = var_309_4
end

OptionsView.cb_gamepad_look_sensitivity = function (arg_310_0, arg_310_1)
	arg_310_0.changed_user_settings.gamepad_look_sensitivity = arg_310_1.value
end

OptionsView.cb_gamepad_look_sensitivity_y_setup = function (arg_311_0)
	local var_311_0 = -10
	local var_311_1 = 10
	local var_311_2 = Application.user_setting("gamepad_look_sensitivity_y") or 0
	local var_311_3 = DefaultUserSettings.get("user_settings", "gamepad_look_sensitivity_y")
	local var_311_4 = var_0_11(var_311_0, var_311_1, var_311_2)
	local var_311_5 = math.clamp(var_311_2, var_311_0, var_311_1)

	table.clear(var_0_17)

	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_311_0.platform
	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

	for iter_311_0 = 1, #var_0_17 do
		local var_311_6 = var_0_17[iter_311_0]
		local var_311_7 = InputUtils.get_platform_filters(PlayerControllerFilters, var_311_6)
		local var_311_8 = var_311_7.look_controller.multiplier_y
		local var_311_9 = var_311_7.look_controller_melee.multiplier_y
		local var_311_10 = var_311_7.look_controller_ranged.multiplier_y
		local var_311_11 = arg_311_0.input_manager:get_service("Player"):get_active_filters(var_311_6)

		var_311_11.look_controller.function_data.multiplier_y = var_311_8 * 0.85^-var_311_5
		var_311_11.look_controller_melee.function_data.multiplier_y = var_311_9 * 0.85^-var_311_5
		var_311_11.look_controller_ranged.function_data.multiplier_y = var_311_10 * 0.85^-var_311_5
	end

	return var_311_4, var_311_0, var_311_1, 1, "menu_settings_gamepad_look_sensitivity_y", var_311_3
end

OptionsView.cb_gamepad_look_sensitivity_y_saved_value = function (arg_312_0, arg_312_1)
	local var_312_0 = arg_312_1.content
	local var_312_1 = var_312_0.min
	local var_312_2 = var_312_0.max
	local var_312_3 = var_0_12(arg_312_0.changed_user_settings.gamepad_look_sensitivity_y, Application.user_setting("gamepad_look_sensitivity_y")) or 0
	local var_312_4 = math.clamp(var_312_3, var_312_1, var_312_2)

	var_312_0.internal_value = var_0_11(var_312_1, var_312_2, var_312_4)
	var_312_0.value = var_312_4
end

OptionsView.cb_gamepad_look_sensitivity_y = function (arg_313_0, arg_313_1)
	arg_313_0.changed_user_settings.gamepad_look_sensitivity_y = arg_313_1.value
end

OptionsView.cb_gamepad_zoom_sensitivity_setup = function (arg_314_0)
	local var_314_0 = -10
	local var_314_1 = 10
	local var_314_2 = Application.user_setting("gamepad_zoom_sensitivity") or 0
	local var_314_3 = DefaultUserSettings.get("user_settings", "gamepad_zoom_sensitivity")
	local var_314_4 = var_0_11(var_314_0, var_314_1, var_314_2)
	local var_314_5 = math.clamp(var_314_2, var_314_0, var_314_1)

	table.clear(var_0_17)

	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_314_0.platform
	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

	for iter_314_0 = 1, #var_0_17 do
		local var_314_6 = var_0_17[iter_314_0]
		local var_314_7 = InputUtils.get_platform_filters(PlayerControllerFilters, var_314_6)
		local var_314_8 = var_314_7.look_controller_zoom.multiplier_x
		local var_314_9 = arg_314_0.input_manager:get_service("Player"):get_active_filters(var_314_6).look_controller_zoom.function_data

		var_314_9.multiplier_x = var_314_8 * 0.85^-var_314_5
		var_314_9.min_multiplier_x = var_314_7.look_controller_zoom.multiplier_min_x and var_314_7.look_controller_zoom.multiplier_min_x * 0.85^-var_314_5 or var_314_9.multiplier_x * 0.25
	end

	return var_314_4, var_314_0, var_314_1, 1, "menu_settings_gamepad_zoom_sensitivity", var_314_3
end

OptionsView.cb_gamepad_zoom_sensitivity_saved_value = function (arg_315_0, arg_315_1)
	local var_315_0 = arg_315_1.content
	local var_315_1 = var_315_0.min
	local var_315_2 = var_315_0.max
	local var_315_3 = var_0_12(arg_315_0.changed_user_settings.gamepad_zoom_sensitivity, Application.user_setting("gamepad_zoom_sensitivity")) or 0
	local var_315_4 = math.clamp(var_315_3, var_315_1, var_315_2)

	var_315_0.internal_value = var_0_11(var_315_1, var_315_2, var_315_4)
	var_315_0.value = var_315_4
end

OptionsView.cb_gamepad_zoom_sensitivity = function (arg_316_0, arg_316_1)
	arg_316_0.changed_user_settings.gamepad_zoom_sensitivity = arg_316_1.value
end

OptionsView.cb_gamepad_zoom_sensitivity_y_setup = function (arg_317_0)
	local var_317_0 = -10
	local var_317_1 = 10
	local var_317_2 = Application.user_setting("gamepad_zoom_sensitivity_y") or 0
	local var_317_3 = DefaultUserSettings.get("user_settings", "gamepad_zoom_sensitivity_y")
	local var_317_4 = var_0_11(var_317_0, var_317_1, var_317_2)
	local var_317_5 = math.clamp(var_317_2, var_317_0, var_317_1)

	table.clear(var_0_17)

	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_317_0.platform
	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

	for iter_317_0 = 1, #var_0_17 do
		local var_317_6 = var_0_17[iter_317_0]
		local var_317_7 = InputUtils.get_platform_filters(PlayerControllerFilters, var_317_6).look_controller_zoom.multiplier_y

		arg_317_0.input_manager:get_service("Player"):get_active_filters(var_317_6).look_controller_zoom.function_data.multiplier_y = var_317_7 * 0.85^-var_317_5
	end

	return var_317_4, var_317_0, var_317_1, 1, "menu_settings_gamepad_zoom_sensitivity_y", var_317_3
end

OptionsView.cb_gamepad_zoom_sensitivity_y_saved_value = function (arg_318_0, arg_318_1)
	local var_318_0 = arg_318_1.content
	local var_318_1 = var_318_0.min
	local var_318_2 = var_318_0.max
	local var_318_3 = var_0_12(arg_318_0.changed_user_settings.gamepad_zoom_sensitivity_y, Application.user_setting("gamepad_zoom_sensitivity_y")) or 0
	local var_318_4 = math.clamp(var_318_3, var_318_1, var_318_2)

	var_318_0.internal_value = var_0_11(var_318_1, var_318_2, var_318_4)
	var_318_0.value = var_318_4
end

OptionsView.cb_gamepad_zoom_sensitivity_y = function (arg_319_0, arg_319_1)
	arg_319_0.changed_user_settings.gamepad_zoom_sensitivity_y = arg_319_1.value
end

OptionsView.cb_max_upload_speed = function (arg_320_0, arg_320_1)
	local var_320_0 = arg_320_1.options_values
	local var_320_1 = arg_320_1.current_selection

	arg_320_0.changed_user_settings.max_upload_speed = var_320_0[var_320_1]
end

OptionsView.cb_max_upload_speed_setup = function (arg_321_0)
	local var_321_0 = {
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
	local var_321_1 = DefaultUserSettings.get("user_settings", "max_upload_speed")
	local var_321_2 = Application.user_setting("max_upload_speed")
	local var_321_3
	local var_321_4

	for iter_321_0, iter_321_1 in ipairs(var_321_0) do
		if iter_321_1.value == var_321_2 then
			var_321_4 = iter_321_0
		end

		if iter_321_1.value == var_321_1 then
			var_321_3 = iter_321_0
		end
	end

	fassert(var_321_3, "default option %i does not exist in cb_max_upload_speed_setup options table", var_321_1)

	return var_321_4 or var_321_3, var_321_0, "menu_settings_max_upload", var_321_3
end

OptionsView.cb_max_upload_speed_saved_value = function (arg_322_0, arg_322_1)
	local var_322_0 = var_0_12(arg_322_0.changed_user_settings.max_upload_speed, Application.user_setting("max_upload_speed")) or DefaultUserSettings.get("user_settings", "max_upload_speed")
	local var_322_1 = arg_322_1.content.options_values
	local var_322_2 = 1

	for iter_322_0 = 1, #var_322_1 do
		if var_322_0 == var_322_1[iter_322_0] then
			var_322_2 = iter_322_0

			break
		end
	end

	arg_322_1.content.current_selection = var_322_2
end

OptionsView.cb_small_network_packets = function (arg_323_0, arg_323_1)
	local var_323_0 = arg_323_1.options_values
	local var_323_1 = arg_323_1.current_selection

	arg_323_0.changed_user_settings.small_network_packets = var_323_0[var_323_1]
end

OptionsView.cb_small_network_packets_setup = function (arg_324_0)
	local var_324_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_324_1 = DefaultUserSettings.get("user_settings", "small_network_packets")
	local var_324_2 = Application.user_setting("small_network_packets") and 2 or 1
	local var_324_3 = var_324_1 and 2 or 1

	return var_324_2, var_324_0, "menu_settings_small_network_packets", var_324_3
end

OptionsView.cb_small_network_packets_saved_value = function (arg_325_0, arg_325_1)
	local var_325_0 = var_0_12(arg_325_0.changed_user_settings.small_network_packets, Application.user_setting("small_network_packets")) or false

	arg_325_1.content.current_selection = var_325_0 and 2 or 1
end

OptionsView.cb_max_quick_play_search_range = function (arg_326_0, arg_326_1)
	local var_326_0 = arg_326_1.options_values
	local var_326_1 = arg_326_1.current_selection

	arg_326_0.changed_user_settings.max_quick_play_search_range = var_326_0[var_326_1]
end

OptionsView.cb_max_quick_play_search_range_setup = function (arg_327_0)
	local var_327_0 = {
		{
			value = "close",
			text = Localize("menu_settings_near")
		},
		{
			value = "far",
			text = Localize("menu_settings_far")
		}
	}
	local var_327_1 = DefaultUserSettings.get("user_settings", "max_quick_play_search_range")
	local var_327_2 = Application.user_setting("max_quick_play_search_range")
	local var_327_3
	local var_327_4

	for iter_327_0, iter_327_1 in ipairs(var_327_0) do
		if iter_327_1.value == var_327_2 then
			var_327_4 = iter_327_0
		end

		if iter_327_1.value == var_327_1 then
			var_327_3 = iter_327_0
		end
	end

	fassert(var_327_3, "default option %i does not exist in cb_max_quick_play_search_range_setup options table", var_327_1)

	return var_327_4 or var_327_3, var_327_0, "menu_settings_max_quick_play_search_range", var_327_3
end

OptionsView.cb_max_quick_play_search_range_saved_value = function (arg_328_0, arg_328_1)
	local var_328_0 = var_0_12(arg_328_0.changed_user_settings.max_quick_play_search_range, Application.user_setting("max_quick_play_search_range")) or DefaultUserSettings.get("user_settings", "max_quick_play_search_range")
	local var_328_1 = arg_328_1.content.options_values
	local var_328_2 = 1

	for iter_328_0 = 1, #var_328_1 do
		if var_328_0 == var_328_1[iter_328_0] then
			var_328_2 = iter_328_0

			break
		end
	end

	arg_328_1.content.current_selection = var_328_2
end

OptionsView.cb_mouse_look_invert_y_setup = function (arg_329_0)
	local var_329_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_329_1 = DefaultUserSettings.get("user_settings", "mouse_look_invert_y")
	local var_329_2 = Application.user_setting("mouse_look_invert_y")
	local var_329_3 = arg_329_0.input_manager:get_service("Player")
	local var_329_4 = "win32"

	var_329_3:get_active_filters(var_329_4).look.function_data.filter_type = var_329_2 and "scale_vector3" or "scale_vector3_invert_y"

	local var_329_5 = var_329_2 and 2 or 1
	local var_329_6 = var_329_1 and 2 or 1

	return var_329_5, var_329_0, "menu_settings_mouse_look_invert_y", var_329_6
end

OptionsView.cb_mouse_look_invert_y_saved_value = function (arg_330_0, arg_330_1)
	local var_330_0 = var_0_12(arg_330_0.changed_user_settings.mouse_look_invert_y, Application.user_setting("mouse_look_invert_y")) or false

	arg_330_1.content.current_selection = var_330_0 and 2 or 1
end

OptionsView.cb_mouse_look_invert_y = function (arg_331_0, arg_331_1)
	local var_331_0 = arg_331_1.options_values
	local var_331_1 = arg_331_1.current_selection

	arg_331_0.changed_user_settings.mouse_look_invert_y = var_331_0[var_331_1]
end

OptionsView.cb_gamepad_look_invert_y_setup = function (arg_332_0)
	local var_332_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_332_1 = DefaultUserSettings.get("user_settings", "gamepad_look_invert_y") or false
	local var_332_2 = Application.user_setting("gamepad_look_invert_y")
	local var_332_3 = arg_332_0.input_manager:get_service("Player")

	table.clear(var_0_17)

	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "xb1" or arg_332_0.platform
	var_0_17[#var_0_17 + 1] = IS_WINDOWS and "ps_pad"

	for iter_332_0 = 1, #var_0_17 do
		local var_332_4 = var_0_17[iter_332_0]
		local var_332_5 = var_332_3:get_active_filters(var_332_4)

		var_332_5.look_controller.function_data.filter_type = var_332_2 and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
		var_332_5.look_controller_ranged.function_data.filter_type = var_332_2 and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
		var_332_5.look_controller_melee.function_data.filter_type = var_332_2 and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
		var_332_5.look_controller_zoom.function_data.filter_type = var_332_2 and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
	end

	local var_332_6 = var_332_2 and 2 or 1
	local var_332_7 = var_332_1 and 2 or 1

	return var_332_6, var_332_0, "menu_settings_gamepad_look_invert_y", var_332_7
end

OptionsView.cb_gamepad_look_invert_y_saved_value = function (arg_333_0, arg_333_1)
	local var_333_0 = var_0_12(arg_333_0.changed_user_settings.gamepad_look_invert_y, Application.user_setting("gamepad_look_invert_y")) or false

	arg_333_1.content.current_selection = var_333_0 and 2 or 1
end

OptionsView.cb_gamepad_look_invert_y = function (arg_334_0, arg_334_1)
	local var_334_0 = arg_334_1.options_values
	local var_334_1 = arg_334_1.current_selection

	arg_334_0.changed_user_settings.gamepad_look_invert_y = var_334_0[var_334_1]
end

OptionsView.cb_gamepad_left_dead_zone_setup = function (arg_335_0)
	local var_335_0 = 0
	local var_335_1 = 1
	local var_335_2 = Managers.account:active_controller()
	local var_335_3 = var_335_2.default_dead_zone()
	local var_335_4 = var_335_2.axis_index("left")
	local var_335_5 = DefaultUserSettings.get("user_settings", "gamepad_left_dead_zone") or 0
	local var_335_6 = Application.user_setting("gamepad_left_dead_zone") or var_335_5
	local var_335_7 = var_0_11(var_335_0, var_335_1, var_335_6)
	local var_335_8 = var_335_3[var_335_4].dead_zone
	local var_335_9 = var_335_8 + var_335_7 * (0.9 - var_335_8)

	if var_335_6 > 0 then
		local var_335_10 = var_335_2.CIRCULAR

		var_335_2.set_dead_zone(var_335_4, var_335_10, var_335_9)
	end

	return var_335_7, var_335_0, var_335_1, 1, "menu_settings_gamepad_left_dead_zone", var_335_5
end

OptionsView.cb_gamepad_left_dead_zone_saved_value = function (arg_336_0, arg_336_1)
	local var_336_0 = arg_336_1.content
	local var_336_1 = var_336_0.min
	local var_336_2 = var_336_0.max
	local var_336_3 = var_0_12(arg_336_0.changed_user_settings.gamepad_left_dead_zone, Application.user_setting("gamepad_left_dead_zone")) or 0
	local var_336_4 = math.clamp(var_336_3, var_336_1, var_336_2)

	var_336_0.internal_value = var_0_11(var_336_1, var_336_2, var_336_4)
	var_336_0.value = var_336_4
end

OptionsView.cb_gamepad_left_dead_zone = function (arg_337_0, arg_337_1)
	arg_337_0.changed_user_settings.gamepad_left_dead_zone = arg_337_1.value
end

OptionsView.cb_gamepad_right_dead_zone_setup = function (arg_338_0)
	local var_338_0 = 0
	local var_338_1 = 1
	local var_338_2 = Managers.account:active_controller()
	local var_338_3 = var_338_2.default_dead_zone()
	local var_338_4 = var_338_2.axis_index("right")
	local var_338_5 = DefaultUserSettings.get("user_settings", "gamepad_right_dead_zone") or 0
	local var_338_6 = Application.user_setting("gamepad_right_dead_zone") or var_338_5
	local var_338_7 = var_0_11(var_338_0, var_338_1, var_338_6)
	local var_338_8 = var_338_3[var_338_4].dead_zone
	local var_338_9 = var_338_8 + var_338_7 * (0.9 - var_338_8)

	if var_338_6 > 0 then
		local var_338_10 = var_338_2.CIRCULAR

		var_338_2.set_dead_zone(var_338_4, var_338_10, var_338_9)
	end

	return var_338_7, var_338_0, var_338_1, 1, "menu_settings_gamepad_right_dead_zone", var_338_5
end

OptionsView.cb_gamepad_right_dead_zone_saved_value = function (arg_339_0, arg_339_1)
	local var_339_0 = arg_339_1.content
	local var_339_1 = var_339_0.min
	local var_339_2 = var_339_0.max
	local var_339_3 = var_0_12(arg_339_0.changed_user_settings.gamepad_right_dead_zone, Application.user_setting("gamepad_right_dead_zone")) or 0
	local var_339_4 = math.clamp(var_339_3, var_339_1, var_339_2)

	var_339_0.internal_value = var_0_11(var_339_1, var_339_2, var_339_4)
	var_339_0.value = var_339_4
end

OptionsView.cb_gamepad_right_dead_zone = function (arg_340_0, arg_340_1)
	arg_340_0.changed_user_settings.gamepad_right_dead_zone = arg_340_1.value
end

OptionsView.cb_gamepad_auto_aim_enabled_setup = function (arg_341_0)
	local var_341_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_341_1 = DefaultUserSettings.get("user_settings", "gamepad_auto_aim_enabled") or true
	local var_341_2 = Application.user_setting("gamepad_auto_aim_enabled") and 1 or 2
	local var_341_3 = var_341_1 and 1 or 2

	return var_341_2, var_341_0, "menu_settings_gamepad_auto_aim_enabled", var_341_3
end

OptionsView.cb_gamepad_auto_aim_enabled_saved_value = function (arg_342_0, arg_342_1)
	local var_342_0 = var_0_12(arg_342_0.changed_user_settings.gamepad_auto_aim_enabled, Application.user_setting("gamepad_auto_aim_enabled"))

	arg_342_1.content.current_selection = var_342_0 and 1 or 2
end

OptionsView.cb_gamepad_auto_aim_enabled = function (arg_343_0, arg_343_1)
	local var_343_0 = arg_343_1.options_values
	local var_343_1 = arg_343_1.current_selection

	arg_343_0.changed_user_settings.gamepad_auto_aim_enabled = var_343_0[var_343_1]
end

OptionsView.cb_gamepad_acceleration_enabled_setup = function (arg_344_0)
	local var_344_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_344_1 = DefaultUserSettings.get("user_settings", "enable_gamepad_acceleration") or true
	local var_344_2 = Application.user_setting("enable_gamepad_acceleration") and 1 or 2
	local var_344_3 = var_344_1 and 1 or 2

	return var_344_2, var_344_0, "menu_settings_enable_gamepad_acceleration", var_344_3
end

OptionsView.cb_gamepad_acceleration_enabled_saved_value = function (arg_345_0, arg_345_1)
	local var_345_0 = var_0_12(arg_345_0.changed_user_settings.enable_gamepad_acceleration, Application.user_setting("enable_gamepad_acceleration"))

	arg_345_1.content.current_selection = var_345_0 and 1 or 2
end

OptionsView.cb_gamepad_acceleration_enabled = function (arg_346_0, arg_346_1)
	local var_346_0 = arg_346_1.options_values
	local var_346_1 = arg_346_1.current_selection

	arg_346_0.changed_user_settings.enable_gamepad_acceleration = var_346_0[var_346_1]
end

OptionsView.cb_gamepad_rumble_enabled_setup = function (arg_347_0)
	local var_347_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_347_1 = DefaultUserSettings.get("user_settings", "gamepad_rumble_enabled") or true
	local var_347_2 = Application.user_setting("gamepad_rumble_enabled") and 1 or 2
	local var_347_3 = var_347_1 and 1 or 2

	return var_347_2, var_347_0, "menu_settings_gamepad_rumble_enabled", var_347_3
end

OptionsView.cb_gamepad_rumble_enabled_saved_value = function (arg_348_0, arg_348_1)
	local var_348_0 = var_0_12(arg_348_0.changed_user_settings.gamepad_rumble_enabled, Application.user_setting("gamepad_rumble_enabled"))

	arg_348_1.content.current_selection = var_348_0 and 1 or 2
end

OptionsView.cb_gamepad_rumble_enabled = function (arg_349_0, arg_349_1)
	local var_349_0 = arg_349_1.options_values
	local var_349_1 = arg_349_1.current_selection

	arg_349_0.changed_user_settings.gamepad_rumble_enabled = var_349_0[var_349_1]
end

OptionsView.cb_motion_controls_enabled_setup = function (arg_350_0)
	local var_350_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_350_1 = DefaultUserSettings.get("user_settings", "use_motion_controls") or false
	local var_350_2 = Application.user_setting("use_motion_controls")
	local var_350_3 = var_350_2 and 1 or 2
	local var_350_4 = var_350_1 and 1 or 2

	if var_350_2 == nil then
		var_350_2 = MotionControlSettings.motion_controls_enabled
	end

	MotionControlSettings.use_motion_controls = var_350_2

	return var_350_3, var_350_0, "menu_settings_motion_controls_enabled", var_350_4
end

OptionsView.cb_motion_controls_enabled_saved_value = function (arg_351_0, arg_351_1)
	local var_351_0 = var_0_12(arg_351_0.changed_user_settings.use_motion_controls, Application.user_setting("use_motion_controls"))

	arg_351_1.content.current_selection = var_351_0 and 1 or 2
end

OptionsView.cb_motion_controls_enabled = function (arg_352_0, arg_352_1)
	local var_352_0 = arg_352_1.options_values
	local var_352_1 = arg_352_1.current_selection

	arg_352_0.changed_user_settings.use_motion_controls = var_352_0[var_352_1]
end

OptionsView.cb_motion_yaw_sensitivity_setup = function (arg_353_0)
	local var_353_0 = MotionControlSettings.sensitivity_yaw_min
	local var_353_1 = MotionControlSettings.sensitivity_yaw_max
	local var_353_2 = Application.user_setting("motion_sensitivity_yaw") or MotionControlSettings.default_sensitivity_yaw
	local var_353_3 = DefaultUserSettings.get("user_settings", "motion_sensitivity_yaw")
	local var_353_4 = var_0_11(var_353_0, var_353_1, var_353_2)
	local var_353_5 = math.clamp(var_353_2, var_353_0, var_353_1)

	if var_353_5 == nil then
		motion_controls_enabled = MotionControlSettings.default_sensitivity_yaw
	end

	MotionControlSettings.motion_sensitivity_yaw = var_353_5

	return var_353_4, var_353_0, var_353_1, 0, "menu_settings_sensitivity_yaw", var_353_3
end

OptionsView.cb_motion_yaw_sensitivity_saved_value = function (arg_354_0, arg_354_1)
	local var_354_0 = arg_354_1.content
	local var_354_1 = var_354_0.min
	local var_354_2 = var_354_0.max
	local var_354_3 = var_0_12(arg_354_0.changed_user_settings.motion_sensitivity_yaw, Application.user_setting("motion_sensitivity_yaw")) or MotionControlSettings.default_sensitivity_yaw
	local var_354_4 = math.clamp(var_354_3, var_354_1, var_354_2)

	var_354_0.internal_value = var_0_11(var_354_1, var_354_2, var_354_4)
	var_354_0.value = var_354_4
end

OptionsView.cb_motion_yaw_sensitivity = function (arg_355_0, arg_355_1)
	arg_355_0.changed_user_settings.motion_sensitivity_yaw = arg_355_1.value
end

OptionsView.cb_motion_pitch_sensitivity_setup = function (arg_356_0)
	local var_356_0 = MotionControlSettings.sensitivity_pitch_min
	local var_356_1 = MotionControlSettings.sensitivity_pitch_max
	local var_356_2 = Application.user_setting("motion_sensitivity_pitch") or MotionControlSettings.default_sensitivity_pitch
	local var_356_3 = DefaultUserSettings.get("user_settings", "motion_sensitivity_pitch")
	local var_356_4 = var_0_11(var_356_0, var_356_1, var_356_2)
	local var_356_5 = math.clamp(var_356_2, var_356_0, var_356_1)

	if var_356_5 == nil then
		MotionControlSettings.motion_sensitivity_pitch = MotionControlSettings.default_sensitivity_pitch
	end

	MotionControlSettings.motion_sensitivity_pitch = var_356_5

	return var_356_4, var_356_0, var_356_1, 0, "menu_settings_sensitivity_pitch", var_356_3
end

OptionsView.cb_motion_pitch_sensitivity_saved_value = function (arg_357_0, arg_357_1)
	local var_357_0 = arg_357_1.content
	local var_357_1 = var_357_0.min
	local var_357_2 = var_357_0.max
	local var_357_3 = var_0_12(arg_357_0.changed_user_settings.motion_sensitivity_pitch, Application.user_setting("motion_sensitivity_pitch")) or MotionControlSettings.default_sensitivity_pitch
	local var_357_4 = math.clamp(var_357_3, var_357_1, var_357_2)

	var_357_0.internal_value = var_0_11(var_357_1, var_357_2, var_357_4)
	var_357_0.value = var_357_4
end

OptionsView.cb_motion_pitch_sensitivity = function (arg_358_0, arg_358_1)
	arg_358_0.changed_user_settings.motion_sensitivity_pitch = arg_358_1.value
end

OptionsView.cb_disable_right_stick_look_setup = function (arg_359_0)
	local var_359_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_359_1 = DefaultUserSettings.get("user_settings", "motion_disable_right_stick_vertical")
	local var_359_2 = Application.user_setting("motion_disable_right_stick_vertical")
	local var_359_3 = var_359_2 and 1 or 2
	local var_359_4 = var_359_1 and 1 or 2

	if var_359_2 == nil then
		MotionControlSettings.motion_disable_right_stick_vertical = MotionControlSettings.motion_disable_right_stick_vertical
	end

	MotionControlSettings.motion_disable_right_stick_vertical = var_359_2

	return var_359_3, var_359_0, "menu_settings_disable_right_stick_vertical", var_359_4
end

OptionsView.cb_disable_right_stick_look_saved_value = function (arg_360_0, arg_360_1)
	local var_360_0 = var_0_12(arg_360_0.changed_user_settings.motion_disable_right_stick_vertical, Application.user_setting("motion_disable_right_stick_vertical"))

	arg_360_1.content.current_selection = var_360_0 and 1 or 2
end

OptionsView.cb_disable_right_stick_look = function (arg_361_0, arg_361_1)
	local var_361_0 = arg_361_1.options_values
	local var_361_1 = arg_361_1.current_selection

	arg_361_0.changed_user_settings.motion_disable_right_stick_vertical = var_361_0[var_361_1]
end

OptionsView.cb_yaw_motion_enabled_setup = function (arg_362_0)
	local var_362_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_362_1 = DefaultUserSettings.get("user_settings", "motion_enable_yaw_motion")
	local var_362_2 = Application.user_setting("motion_enable_yaw_motion")
	local var_362_3 = var_362_2 and 1 or 2
	local var_362_4 = var_362_1 and 1 or 2

	if var_362_2 == nil then
		MotionControlSettings.motion_enable_yaw_motion = MotionControlSettings.motion_enable_yaw_motion
	end

	MotionControlSettings.motion_enable_yaw_motion = var_362_2

	return var_362_3, var_362_0, "menu_settings_motion_yaw_enabled", var_362_4
end

OptionsView.cb_yaw_motion_enabled_saved_value = function (arg_363_0, arg_363_1)
	local var_363_0 = var_0_12(arg_363_0.changed_user_settings.motion_enable_yaw_motion, Application.user_setting("motion_enable_yaw_motion"))

	arg_363_1.content.current_selection = var_363_0 and 1 or 2
end

OptionsView.cb_yaw_motion_enabled = function (arg_364_0, arg_364_1)
	local var_364_0 = arg_364_1.options_values
	local var_364_1 = arg_364_1.current_selection

	arg_364_0.changed_user_settings.motion_enable_yaw_motion = var_364_0[var_364_1]
end

OptionsView.cb_pitch_motion_enabled_setup = function (arg_365_0)
	local var_365_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_365_1 = DefaultUserSettings.get("user_settings", "motion_enable_pitch_motion")
	local var_365_2 = Application.user_setting("motion_enable_pitch_motion")
	local var_365_3 = var_365_2 and 1 or 2
	local var_365_4 = var_365_1 and 1 or 2

	if var_365_2 == nil then
		MotionControlSettings.motion_enable_pitch_motion = MotionControlSettings.motion_enable_pitch_motion
	end

	MotionControlSettings.motion_enable_pitch_motion = var_365_2

	return var_365_3, var_365_0, "menu_settings_motion_pitch_enabled", var_365_4
end

OptionsView.cb_pitch_motion_enabled_saved_value = function (arg_366_0, arg_366_1)
	local var_366_0 = var_0_12(arg_366_0.changed_user_settings.motion_enable_pitch_motion, Application.user_setting("motion_enable_pitch_motion"))

	arg_366_1.content.current_selection = var_366_0 and 1 or 2
end

OptionsView.cb_pitch_motion_enabled = function (arg_367_0, arg_367_1)
	local var_367_0 = arg_367_1.options_values
	local var_367_1 = arg_367_1.current_selection

	arg_367_0.changed_user_settings.motion_enable_pitch_motion = var_367_0[var_367_1]
end

OptionsView.cb_invert_yaw_enabled_setup = function (arg_368_0)
	local var_368_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_368_1 = DefaultUserSettings.get("user_settings", "motion_invert_yaw")
	local var_368_2 = Application.user_setting("motion_invert_yaw")
	local var_368_3 = var_368_2 and 1 or 2
	local var_368_4 = var_368_1 and 1 or 2

	if var_368_2 == nil then
		MotionControlSettings.motion_invert_yaw = MotionControlSettings.motion_invert_yaw
	end

	MotionControlSettings.motion_invert_yaw = var_368_2

	return var_368_3, var_368_0, "menu_settings_invert_yaw", var_368_4
end

OptionsView.cb_invert_yaw_enabled_saved_value = function (arg_369_0, arg_369_1)
	local var_369_0 = var_0_12(arg_369_0.changed_user_settings.motion_invert_yaw, Application.user_setting("motion_invert_yaw"))

	arg_369_1.content.current_selection = var_369_0 and 1 or 2
end

OptionsView.cb_invert_yaw_enabled = function (arg_370_0, arg_370_1)
	local var_370_0 = arg_370_1.options_values
	local var_370_1 = arg_370_1.current_selection

	arg_370_0.changed_user_settings.motion_invert_yaw = var_370_0[var_370_1]
end

OptionsView.cb_invert_pitch_enabled_setup = function (arg_371_0)
	local var_371_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_371_1 = DefaultUserSettings.get("user_settings", "motion_invert_pitch")
	local var_371_2 = Application.user_setting("motion_invert_pitch")
	local var_371_3 = var_371_2 and 1 or 2
	local var_371_4 = var_371_1 and 1 or 2

	if var_371_2 == nil then
		MotionControlSettings.motion_invert_pitch = MotionControlSettings.motion_invert_pitch
	end

	MotionControlSettings.motion_invert_pitch = var_371_2

	return var_371_3, var_371_0, "menu_settings_invert_pitch", var_371_4
end

OptionsView.cb_invert_pitch_enabled_saved_value = function (arg_372_0, arg_372_1)
	local var_372_0 = var_0_12(arg_372_0.changed_user_settings.motion_invert_pitch, Application.user_setting("motion_invert_pitch"))

	arg_372_1.content.current_selection = var_372_0 and 1 or 2
end

OptionsView.cb_invert_pitch_enabled = function (arg_373_0, arg_373_1)
	local var_373_0 = arg_373_1.options_values
	local var_373_1 = arg_373_1.current_selection

	arg_373_0.changed_user_settings.motion_invert_pitch = var_373_0[var_373_1]
end

OptionsView.cb_gamepad_use_ps4_style_input_icons_setup = function (arg_374_0)
	local var_374_0 = {
		{
			value = false,
			text = Localize("menu_settings_auto")
		},
		{
			value = true,
			text = Localize("menu_settings_ps4_input_icons")
		}
	}
	local var_374_1 = DefaultUserSettings.get("user_settings", "gamepad_use_ps4_style_input_icons") or false
	local var_374_2 = Application.user_setting("gamepad_use_ps4_style_input_icons") and 2 or 1
	local var_374_3 = var_374_1 and 2 or 1

	return var_374_2, var_374_0, "menu_settings_gamepad_use_ps4_style_input_icons", var_374_3
end

OptionsView.cb_gamepad_use_ps4_style_input_icons_saved_value = function (arg_375_0, arg_375_1)
	local var_375_0 = var_0_12(arg_375_0.changed_user_settings.gamepad_use_ps4_style_input_icons, Application.user_setting("gamepad_use_ps4_style_input_icons"))

	arg_375_1.content.current_selection = var_375_0 and 2 or 1
end

OptionsView.cb_gamepad_use_ps4_style_input_icons = function (arg_376_0, arg_376_1)
	local var_376_0 = arg_376_1.options_values
	local var_376_1 = arg_376_1.current_selection

	arg_376_0.changed_user_settings.gamepad_use_ps4_style_input_icons = var_376_0[var_376_1]

	local var_376_2 = arg_376_0.gamepad_layout_widget
	local var_376_3 = var_0_12(arg_376_0.changed_user_settings.gamepad_use_ps4_style_input_icons, Application.user_setting("gamepad_use_ps4_style_input_icons"))

	var_376_2.content.use_texture2_layout = var_376_3
end

OptionsView.cb_gamepad_layout_setup = function (arg_377_0)
	local var_377_0 = AlternatateGamepadKeymapsOptionsMenu
	local var_377_1 = DefaultUserSettings.get("user_settings", "gamepad_layout") or "default"
	local var_377_2 = Application.user_setting("gamepad_layout")
	local var_377_3 = 1
	local var_377_4

	for iter_377_0 = 1, #var_377_0 do
		local var_377_5 = var_377_0[iter_377_0]

		if var_377_2 == var_377_5.value then
			var_377_3 = iter_377_0
		end

		if var_377_1 == var_377_5.value then
			var_377_4 = iter_377_0
		end

		if not var_377_5.localized then
			var_377_5.localized = true
			var_377_5.text = Localize(var_377_5.text)
		end
	end

	return var_377_3, var_377_0, "menu_settings_gamepad_layout", var_377_4
end

OptionsView.cb_gamepad_layout_saved_value = function (arg_378_0, arg_378_1)
	local var_378_0 = var_0_12(arg_378_0.changed_user_settings.gamepad_layout, Application.user_setting("gamepad_layout"))
	local var_378_1 = arg_378_1.content.options_values
	local var_378_2 = 1

	for iter_378_0 = 1, #var_378_1 do
		if var_378_0 == var_378_1[iter_378_0] then
			var_378_2 = iter_378_0
		end
	end

	arg_378_1.content.current_selection = var_378_2
end

OptionsView.cb_gamepad_layout = function (arg_379_0, arg_379_1)
	local var_379_0 = arg_379_1.options_values[arg_379_1.current_selection]

	arg_379_0.changed_user_settings.gamepad_layout = var_379_0

	local var_379_1 = var_0_12(arg_379_0.changed_user_settings.gamepad_left_handed, Application.user_setting("gamepad_left_handed"))
	local var_379_2

	if var_379_1 then
		var_379_2 = AlternatateGamepadKeymapsLayoutsLeftHanded
	else
		var_379_2 = AlternatateGamepadKeymapsLayouts
	end

	local var_379_3 = var_379_2[var_379_0]

	arg_379_0:update_gamepad_layout_widget(var_379_3, var_379_1)
end

OptionsView.using_left_handed_gamepad_layout = function (arg_380_0)
	local var_380_0 = Application.user_setting("gamepad_left_handed")
	local var_380_1 = arg_380_0.changed_user_settings.gamepad_left_handed
	local var_380_2

	if var_380_1 ~= nil then
		var_380_2 = var_380_1
	else
		var_380_2 = var_380_0
	end

	return var_380_2
end

OptionsView.cb_gamepad_left_handed_enabled_setup = function (arg_381_0)
	local var_381_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_381_1 = DefaultUserSettings.get("user_settings", "gamepad_left_handed") or false
	local var_381_2 = Application.user_setting("gamepad_left_handed") and 1 or 2
	local var_381_3 = var_381_1 and 1 or 2

	return var_381_2, var_381_0, "menu_settings_gamepad_left_handed_enabled", var_381_3
end

OptionsView.cb_gamepad_left_handed_enabled_saved_value = function (arg_382_0, arg_382_1)
	local var_382_0 = var_0_12(arg_382_0.changed_user_settings.gamepad_left_handed, Application.user_setting("gamepad_left_handed"))

	arg_382_1.content.current_selection = var_382_0 and 1 or 2
end

OptionsView.cb_gamepad_left_handed_enabled = function (arg_383_0, arg_383_1)
	local var_383_0 = arg_383_1.options_values
	local var_383_1 = arg_383_1.current_selection

	arg_383_0.changed_user_settings.gamepad_left_handed = var_383_0[var_383_1]

	local var_383_2 = var_0_12(arg_383_0.changed_user_settings.gamepad_layout, Application.user_setting("gamepad_layout"))

	arg_383_0:force_set_widget_value("gamepad_layout", var_383_2)
end

OptionsView.cb_toggle_crouch_setup = function (arg_384_0)
	local var_384_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_384_1 = DefaultUserSettings.get("user_settings", "toggle_crouch")
	local var_384_2 = Application.user_setting("toggle_crouch") and 1 or 2
	local var_384_3 = var_384_1 and 1 or 2

	return var_384_2, var_384_0, "menu_settings_toggle_crouch", var_384_3
end

OptionsView.cb_toggle_crouch_saved_value = function (arg_385_0, arg_385_1)
	local var_385_0 = var_0_12(arg_385_0.changed_user_settings.toggle_crouch, Application.user_setting("toggle_crouch"))

	arg_385_1.content.current_selection = var_385_0 and 1 or 2
end

OptionsView.cb_toggle_crouch = function (arg_386_0, arg_386_1)
	local var_386_0 = arg_386_1.options_values
	local var_386_1 = arg_386_1.current_selection

	arg_386_0.changed_user_settings.toggle_crouch = var_386_0[var_386_1]
end

OptionsView.cb_toggle_stationary_dodge_setup = function (arg_387_0)
	local var_387_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_387_1 = DefaultUserSettings.get("user_settings", "toggle_stationary_dodge")
	local var_387_2 = Application.user_setting("toggle_stationary_dodge") and 1 or 2
	local var_387_3 = var_387_1 and 1 or 2

	return var_387_2, var_387_0, "menu_settings_toggle_stationary_dodge", var_387_3
end

OptionsView.cb_toggle_stationary_dodge_saved_value = function (arg_388_0, arg_388_1)
	local var_388_0 = var_0_12(arg_388_0.changed_user_settings.toggle_stationary_dodge, Application.user_setting("toggle_stationary_dodge"))

	arg_388_1.content.current_selection = var_388_0 and 1 or 2
end

OptionsView.cb_toggle_stationary_dodge = function (arg_389_0, arg_389_1)
	local var_389_0 = arg_389_1.options_values
	local var_389_1 = arg_389_1.current_selection

	arg_389_0.changed_user_settings.toggle_stationary_dodge = var_389_0[var_389_1]
end

OptionsView.cb_matchmaking_region_setup = function (arg_390_0)
	local var_390_0 = {}

	for iter_390_0, iter_390_1 in pairs(MatchmakingRegions) do
		for iter_390_2, iter_390_3 in pairs(iter_390_1) do
			var_390_0[iter_390_2] = true
		end
	end

	local var_390_1 = {
		{
			value = "auto",
			text = Localize("menu_settings_auto")
		}
	}

	for iter_390_4, iter_390_5 in pairs(var_390_0) do
		var_390_1[#var_390_1 + 1] = {
			text = Localize(iter_390_4),
			value = iter_390_4
		}
	end

	local var_390_2 = DefaultUserSettings.get("user_settings", "matchmaking_region")
	local var_390_3 = Application.user_setting("matchmaking_region")
	local var_390_4 = 1
	local var_390_5 = 1

	for iter_390_6, iter_390_7 in ipairs(var_390_1) do
		if iter_390_7.value == var_390_3 then
			var_390_5 = iter_390_6

			break
		end
	end

	return var_390_5, var_390_1, "menu_settings_matchmaking_region", var_390_4
end

OptionsView.cb_matchmaking_region_saved_value = function (arg_391_0, arg_391_1)
	local var_391_0 = var_0_12(arg_391_0.changed_user_settings.matchmaking_region, Application.user_setting("matchmaking_region"))
	local var_391_1 = 1

	for iter_391_0, iter_391_1 in ipairs(arg_391_1.content.options_values) do
		if iter_391_1 == var_391_0 then
			var_391_1 = iter_391_0

			break
		end
	end

	arg_391_1.content.current_selection = var_391_1
end

OptionsView.cb_matchmaking_region = function (arg_392_0, arg_392_1)
	local var_392_0 = arg_392_1.current_selection
	local var_392_1 = arg_392_1.options_values[var_392_0]

	arg_392_0.changed_user_settings.matchmaking_region = var_392_1
end

OptionsView.cb_overcharge_opacity_setup = function (arg_393_0)
	local var_393_0 = 0
	local var_393_1 = 100
	local var_393_2 = Application.user_setting("overcharge_opacity") or DefaultUserSettings.get("user_settings", "overcharge_opacity")
	local var_393_3 = DefaultUserSettings.get("user_settings", "overcharge_opacity")

	return var_0_11(var_393_0, var_393_1, var_393_2), var_393_0, var_393_1, 0, "menu_settings_overcharge_opacity", var_393_3
end

OptionsView.cb_overcharge_opacity_saved_value = function (arg_394_0, arg_394_1)
	local var_394_0 = arg_394_1.content
	local var_394_1 = var_394_0.min
	local var_394_2 = var_394_0.max
	local var_394_3 = var_0_12(arg_394_0.changed_user_settings.overcharge_opacity, Application.user_setting("overcharge_opacity") or DefaultUserSettings.get("user_settings", "overcharge_opacity"))
	local var_394_4 = math.clamp(var_394_3, var_394_1, var_394_2)

	var_394_0.internal_value = var_0_11(var_394_1, var_394_2, var_394_4)
	var_394_0.value = var_394_4
end

OptionsView.cb_overcharge_opacity = function (arg_395_0, arg_395_1)
	arg_395_0.changed_user_settings.overcharge_opacity = arg_395_1.value
end

OptionsView.cb_input_buffer_setup = function (arg_396_0)
	local var_396_0 = 0
	local var_396_1 = 1
	local var_396_2 = Application.user_setting("input_buffer") or DefaultUserSettings.get("user_settings", "input_buffer")
	local var_396_3 = DefaultUserSettings.get("user_settings", "input_buffer")

	return var_0_11(var_396_0, var_396_1, var_396_2), var_396_0, var_396_1, 1, "menu_settings_input_buffer", var_396_3
end

OptionsView.cb_input_buffer_saved_value = function (arg_397_0, arg_397_1)
	local var_397_0 = arg_397_1.content
	local var_397_1 = var_397_0.min
	local var_397_2 = var_397_0.max
	local var_397_3 = var_0_12(arg_397_0.changed_user_settings.input_buffer, Application.user_setting("input_buffer") or DefaultUserSettings.get("user_settings", "input_buffer"))
	local var_397_4 = math.clamp(var_397_3, var_397_1, var_397_2)

	var_397_0.internal_value = var_0_11(var_397_1, var_397_2, var_397_4)
	var_397_0.value = var_397_4
end

OptionsView.cb_input_buffer = function (arg_398_0, arg_398_1)
	arg_398_0.changed_user_settings.input_buffer = arg_398_1.value
end

OptionsView.cb_priority_input_buffer_setup = function (arg_399_0)
	local var_399_0 = 0
	local var_399_1 = 2
	local var_399_2 = Application.user_setting("priority_input_buffer") or DefaultUserSettings.get("user_settings", "priority_input_buffer")
	local var_399_3 = DefaultUserSettings.get("user_settings", "priority_input_buffer")

	return var_0_11(var_399_0, var_399_1, var_399_2), var_399_0, var_399_1, 1, "menu_settings_priority_input_buffer", var_399_3
end

OptionsView.cb_priority_input_buffer_saved_value = function (arg_400_0, arg_400_1)
	local var_400_0 = arg_400_1.content
	local var_400_1 = var_400_0.min
	local var_400_2 = var_400_0.max
	local var_400_3 = var_0_12(arg_400_0.changed_user_settings.priority_input_buffer, Application.user_setting("priority_input_buffer") or DefaultUserSettings.get("user_settings", "priority_input_buffer"))
	local var_400_4 = math.clamp(var_400_3, var_400_1, var_400_2)

	var_400_0.internal_value = var_0_11(var_400_1, var_400_2, var_400_4)
	var_400_0.value = var_400_4
end

OptionsView.cb_priority_input_buffer = function (arg_401_0, arg_401_1)
	arg_401_0.changed_user_settings.priority_input_buffer = arg_401_1.value
end

OptionsView.cb_weapon_scroll_type_setup = function (arg_402_0)
	local var_402_0 = {
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
	local var_402_1 = DefaultUserSettings.get("user_settings", "weapon_scroll_type")
	local var_402_2 = Application.user_setting("weapon_scroll_type") or "scroll_wrap"
	local var_402_3 = var_402_2 == "scroll_clamp" and 2 or var_402_2 == "scroll_disabled" and 3 or 1
	local var_402_4 = var_402_1 == "scroll_clamp" and 2 or var_402_1 == "scroll_disabled" and 3 or 1

	return var_402_3, var_402_0, "menu_settings_weapon_scroll_type", var_402_4
end

OptionsView.cb_weapon_scroll_type_saved_value = function (arg_403_0, arg_403_1)
	local var_403_0 = var_0_12(arg_403_0.changed_user_settings.weapon_scroll_type, Application.user_setting("weapon_scroll_type")) or "scroll_wrap"

	arg_403_1.content.current_selection = var_403_0 == "scroll_clamp" and 2 or var_403_0 == "scroll_disabled" and 3 or 1
end

OptionsView.cb_weapon_scroll_type = function (arg_404_0, arg_404_1)
	local var_404_0 = arg_404_1.options_values
	local var_404_1 = arg_404_1.current_selection

	arg_404_0.changed_user_settings.weapon_scroll_type = var_404_0[var_404_1]
end

OptionsView.cb_double_tap_dodge = function (arg_405_0, arg_405_1)
	local var_405_0 = arg_405_1.options_values
	local var_405_1 = arg_405_1.current_selection

	arg_405_0.changed_user_settings.double_tap_dodge = var_405_0[var_405_1]
end

OptionsView.cb_double_tap_dodge_setup = function (arg_406_0)
	local var_406_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_406_1 = DefaultUserSettings.get("user_settings", "double_tap_dodge")
	local var_406_2 = Application.user_setting("double_tap_dodge")

	if var_406_2 == nil then
		var_406_2 = var_406_1
	end

	local var_406_3 = var_406_2 and 1 or 2
	local var_406_4 = var_406_1 and 1 or 2

	return var_406_3, var_406_0, "menu_settings_double_tap_dodge", var_406_4
end

OptionsView.cb_double_tap_dodge_saved_value = function (arg_407_0, arg_407_1)
	local var_407_0 = var_0_12(arg_407_0.changed_user_settings.double_tap_dodge, Application.user_setting("double_tap_dodge"))

	if var_407_0 == nil then
		var_407_0 = DefaultUserSettings.get("user_settings", "double_tap_dodge")
	end

	arg_407_1.content.current_selection = var_407_0 and 1 or 2
end

OptionsView.cb_tutorials_enabled_setup = function (arg_408_0)
	local var_408_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_408_1 = DefaultUserSettings.get("user_settings", "tutorials_enabled")
	local var_408_2 = Application.user_setting("tutorials_enabled")

	if var_408_2 == nil then
		var_408_2 = true
	end

	local var_408_3 = var_408_2 and 1 or 2
	local var_408_4 = var_408_1 and 1 or 2

	return var_408_3, var_408_0, "menu_settings_tutorials_enabled", var_408_4
end

OptionsView.cb_tutorials_enabled_saved_value = function (arg_409_0, arg_409_1)
	local var_409_0 = var_0_12(arg_409_0.changed_user_settings.tutorials_enabled, Application.user_setting("tutorials_enabled"))

	if var_409_0 == nil then
		var_409_0 = true
	end

	arg_409_1.content.current_selection = var_409_0 and 1 or 2
end

OptionsView.cb_tutorials_enabled = function (arg_410_0, arg_410_1)
	local var_410_0 = arg_410_1.options_values
	local var_410_1 = arg_410_1.current_selection

	arg_410_0.changed_user_settings.tutorials_enabled = var_410_0[var_410_1]
end

OptionsView.cb_master_volume_setup = function (arg_411_0)
	local var_411_0 = 0
	local var_411_1 = 100
	local var_411_2 = Application.user_setting("master_bus_volume") or 90

	return var_0_11(var_411_0, var_411_1, var_411_2), var_411_0, var_411_1, 0, "menu_settings_master_volume", DefaultUserSettings.get("user_settings", "master_bus_volume")
end

OptionsView.cb_master_volume_saved_value = function (arg_412_0, arg_412_1)
	local var_412_0 = arg_412_1.content
	local var_412_1 = var_412_0.min
	local var_412_2 = var_412_0.max
	local var_412_3 = var_0_12(arg_412_0.changed_user_settings.master_bus_volume, Application.user_setting("master_bus_volume")) or 90

	var_412_0.internal_value = var_0_11(var_412_1, var_412_2, var_412_3)
	var_412_0.value = var_412_3
end

OptionsView.cb_master_volume = function (arg_413_0, arg_413_1)
	local var_413_0 = arg_413_1.value

	arg_413_0.changed_user_settings.master_bus_volume = var_413_0

	arg_413_0:set_wwise_parameter("master_bus_volume", var_413_0)
	Managers.music:set_master_volume(var_413_0)
end

OptionsView.cb_music_bus_volume_setup = function (arg_414_0)
	local var_414_0 = 0
	local var_414_1 = 100
	local var_414_2 = Application.user_setting("music_bus_volume") or 90

	return var_0_11(var_414_0, var_414_1, var_414_2), var_414_0, var_414_1, 0, "menu_settings_music_volume", DefaultUserSettings.get("user_settings", "music_bus_volume")
end

OptionsView.cb_music_bus_volume_saved_value = function (arg_415_0, arg_415_1)
	local var_415_0 = arg_415_1.content
	local var_415_1 = var_415_0.min
	local var_415_2 = var_415_0.max
	local var_415_3 = var_0_12(arg_415_0.changed_user_settings.music_bus_volume, Application.user_setting("music_bus_volume")) or 90

	var_415_0.internal_value = var_0_11(var_415_1, var_415_2, var_415_3)
	var_415_0.value = var_415_3
end

OptionsView.cb_music_bus_volume = function (arg_416_0, arg_416_1)
	local var_416_0 = arg_416_1.value

	arg_416_0.changed_user_settings.music_bus_volume = var_416_0

	Managers.music:set_music_volume(var_416_0)
end

OptionsView.cb_sfx_bus_volume_setup = function (arg_417_0)
	local var_417_0 = 0
	local var_417_1 = 100
	local var_417_2 = Application.user_setting("sfx_bus_volume") or 90

	return var_0_11(var_417_0, var_417_1, var_417_2), var_417_0, var_417_1, 0, "menu_settings_sfx_volume", DefaultUserSettings.get("user_settings", "sfx_bus_volume")
end

OptionsView.cb_sfx_bus_volume_saved_value = function (arg_418_0, arg_418_1)
	local var_418_0 = arg_418_1.content
	local var_418_1 = var_418_0.min
	local var_418_2 = var_418_0.max
	local var_418_3 = var_0_12(arg_418_0.changed_user_settings.sfx_bus_volume, Application.user_setting("sfx_bus_volume")) or 90

	var_418_0.internal_value = var_0_11(var_418_1, var_418_2, var_418_3)
	var_418_0.value = var_418_3
end

OptionsView.cb_sfx_bus_volume = function (arg_419_0, arg_419_1)
	local var_419_0 = arg_419_1.value

	arg_419_0.changed_user_settings.sfx_bus_volume = var_419_0

	arg_419_0:set_wwise_parameter("sfx_bus_volume", var_419_0)
end

OptionsView.cb_voice_bus_volume_setup = function (arg_420_0)
	local var_420_0 = 0
	local var_420_1 = 100
	local var_420_2 = Application.user_setting("voice_bus_volume") or 90

	return var_0_11(var_420_0, var_420_1, var_420_2), var_420_0, var_420_1, 0, "menu_settings_voice_volume", DefaultUserSettings.get("user_settings", "voice_bus_volume")
end

OptionsView.cb_voice_bus_volume_saved_value = function (arg_421_0, arg_421_1)
	local var_421_0 = arg_421_1.content
	local var_421_1 = var_421_0.min
	local var_421_2 = var_421_0.max
	local var_421_3 = var_0_12(arg_421_0.changed_user_settings.voice_bus_volume, Application.user_setting("voice_bus_volume")) or 90

	var_421_0.internal_value = var_0_11(var_421_1, var_421_2, var_421_3)
	var_421_0.value = var_421_3
end

OptionsView.cb_voice_bus_volume = function (arg_422_0, arg_422_1)
	local var_422_0 = arg_422_1.value

	arg_422_0.changed_user_settings.voice_bus_volume = var_422_0

	arg_422_0:set_wwise_parameter("voice_bus_volume", var_422_0)
end

OptionsView.cb_voip_bus_volume_setup = function (arg_423_0)
	local var_423_0 = 0
	local var_423_1 = 100
	local var_423_2 = Application.user_setting("voip_bus_volume") or 0

	return var_0_11(var_423_0, var_423_1, var_423_2), var_423_0, var_423_1, 0, "menu_settings_voip_volume", DefaultUserSettings.get("user_settings", "voip_bus_volume")
end

OptionsView.cb_voip_bus_volume_saved_value = function (arg_424_0, arg_424_1)
	local var_424_0 = arg_424_1.content
	local var_424_1 = var_424_0.min
	local var_424_2 = var_424_0.max
	local var_424_3 = var_0_12(arg_424_0.changed_user_settings.voip_bus_volume, Application.user_setting("voip_bus_volume")) or 90

	var_424_0.internal_value = var_0_11(var_424_1, var_424_2, var_424_3)
	var_424_0.value = var_424_3
end

OptionsView.cb_voip_bus_volume = function (arg_425_0, arg_425_1)
	local var_425_0 = arg_425_1.value

	arg_425_0.changed_user_settings.voip_bus_volume = var_425_0

	arg_425_0.voip:set_volume(var_425_0)
end

OptionsView.cb_voip_enabled_setup = function (arg_426_0)
	local var_426_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_426_1 = Application.user_setting("voip_is_enabled")
	local var_426_2 = DefaultUserSettings.get("user_settings", "voip_is_enabled")

	if var_426_1 == nil then
		var_426_1 = var_426_2
	end

	if arg_426_0.voip then
		arg_426_0.voip:set_enabled(var_426_1)
	end

	local var_426_3 = 1

	if not var_426_1 then
		var_426_3 = 2
	end

	local var_426_4 = 1

	if not var_426_2 then
		var_426_4 = 2
	end

	return var_426_3, var_426_0, "menu_settings_voip_enabled", var_426_4
end

OptionsView.cb_voip_enabled_saved_value = function (arg_427_0, arg_427_1)
	local var_427_0 = arg_427_1.content.options_values
	local var_427_1 = var_0_12(arg_427_0.changed_user_settings.voip_is_enabled, Application.user_setting("voip_is_enabled"))

	if var_427_1 == nil then
		var_427_1 = true
	end

	local var_427_2 = 1

	for iter_427_0, iter_427_1 in pairs(var_427_0) do
		if iter_427_1 == var_427_1 then
			var_427_2 = iter_427_0

			break
		end
	end

	arg_427_1.content.current_selection = var_427_2
	arg_427_1.content.selected_option = var_427_2
end

OptionsView.cb_voip_enabled = function (arg_428_0, arg_428_1)
	local var_428_0 = arg_428_1.options_values[arg_428_1.current_selection]

	arg_428_0.changed_user_settings.voip_is_enabled = var_428_0

	arg_428_0.voip:set_enabled(var_428_0)
end

OptionsView.cb_voip_push_to_talk_setup = function (arg_429_0)
	local var_429_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_429_1 = Application.user_setting("voip_push_to_talk")
	local var_429_2 = DefaultUserSettings.get("user_settings", "voip_push_to_talk")

	if var_429_1 == nil then
		var_429_1 = var_429_2
	end

	arg_429_0.voip:set_push_to_talk(var_429_1)

	local var_429_3 = 1

	if not var_429_1 then
		var_429_3 = 2
	end

	local var_429_4 = 1

	if not var_429_2 then
		var_429_4 = 2
	end

	return var_429_3, var_429_0, "menu_settings_voip_push_to_talk", var_429_4
end

OptionsView.cb_voip_push_to_talk_saved_value = function (arg_430_0, arg_430_1)
	local var_430_0 = arg_430_1.content.options_values
	local var_430_1 = var_0_12(arg_430_0.changed_user_settings.voip_push_to_talk, Application.user_setting("voip_push_to_talk"))

	if var_430_1 == nil then
		var_430_1 = true
	end

	local var_430_2 = 1

	for iter_430_0, iter_430_1 in pairs(var_430_0) do
		if iter_430_1 == var_430_1 then
			var_430_2 = iter_430_0

			break
		end
	end

	arg_430_1.content.current_selection = var_430_2
	arg_430_1.content.selected_option = var_430_2
end

OptionsView.cb_voip_push_to_talk = function (arg_431_0, arg_431_1)
	local var_431_0 = arg_431_1.options_values[arg_431_1.current_selection]

	arg_431_0.changed_user_settings.voip_push_to_talk = var_431_0

	arg_431_0.voip:set_push_to_talk(var_431_0)
end

OptionsView.cb_particles_resolution_setup = function (arg_432_0)
	local var_432_0 = {
		{
			value = false,
			text = Localize("menu_settings_high")
		},
		{
			value = true,
			text = Localize("menu_settings_low")
		}
	}

	return Application.user_setting("render_settings", "low_res_transparency") and 2 or 1, var_432_0, "menu_settings_low_res_transparency"
end

OptionsView.cb_particles_resolution_saved_value = function (arg_433_0, arg_433_1)
	local var_433_0 = var_0_12(arg_433_0.changed_render_settings.low_res_transparency, Application.user_setting("render_settings", "low_res_transparency")) and 2 or 1

	arg_433_1.content.current_selection = var_433_0
end

OptionsView.cb_particles_resolution = function (arg_434_0, arg_434_1, arg_434_2, arg_434_3)
	local var_434_0 = arg_434_1.options_values[arg_434_1.current_selection]

	arg_434_0.changed_render_settings.low_res_transparency = var_434_0

	if not arg_434_3 then
		arg_434_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_particles_quality_setup = function (arg_435_0)
	local var_435_0 = {
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
	local var_435_1 = Application.user_setting("particles_quality")
	local var_435_2 = DefaultUserSettings.get("user_settings", "particles_quality")
	local var_435_3 = 1
	local var_435_4

	for iter_435_0 = 1, #var_435_0 do
		if var_435_0[iter_435_0].value == var_435_1 then
			var_435_3 = iter_435_0
		end

		if var_435_2 == var_435_0[iter_435_0].value then
			var_435_4 = iter_435_0
		end
	end

	return var_435_3, var_435_0, "menu_settings_particles_quality", var_435_4
end

OptionsView.cb_particles_quality_saved_value = function (arg_436_0, arg_436_1)
	local var_436_0 = var_0_12(arg_436_0.changed_user_settings.particles_quality, Application.user_setting("particles_quality"))
	local var_436_1 = arg_436_1.content.options_values
	local var_436_2 = 1

	for iter_436_0 = 1, #var_436_1 do
		if var_436_0 == var_436_1[iter_436_0] then
			var_436_2 = iter_436_0
		end
	end

	arg_436_1.content.current_selection = var_436_2
end

OptionsView.cb_particles_quality = function (arg_437_0, arg_437_1, arg_437_2, arg_437_3)
	local var_437_0 = arg_437_1.options_values[arg_437_1.current_selection]

	arg_437_0.changed_user_settings.particles_quality = var_437_0

	local var_437_1 = ParticlesQuality[var_437_0]

	for iter_437_0, iter_437_1 in pairs(var_437_1) do
		arg_437_0.changed_render_settings[iter_437_0] = iter_437_1
	end

	if not arg_437_3 then
		arg_437_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_ambient_light_quality_setup = function (arg_438_0)
	local var_438_0 = {
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		}
	}
	local var_438_1 = Application.user_setting("ambient_light_quality")
	local var_438_2 = DefaultUserSettings.get("user_settings", "ambient_light_quality")
	local var_438_3 = 1
	local var_438_4

	for iter_438_0 = 1, #var_438_0 do
		if var_438_0[iter_438_0].value == var_438_1 then
			var_438_3 = iter_438_0
		end

		if var_438_2 == var_438_0[iter_438_0].value then
			var_438_4 = iter_438_0
		end
	end

	return var_438_3, var_438_0, "menu_settings_ambient_light_quality", var_438_4
end

OptionsView.cb_ambient_light_quality_saved_value = function (arg_439_0, arg_439_1)
	local var_439_0 = var_0_12(arg_439_0.changed_user_settings.ambient_light_quality, Application.user_setting("ambient_light_quality"))
	local var_439_1 = arg_439_1.content.options_values
	local var_439_2 = 1

	for iter_439_0 = 1, #var_439_1 do
		if var_439_0 == var_439_1[iter_439_0] then
			var_439_2 = iter_439_0
		end
	end

	arg_439_1.content.current_selection = var_439_2
end

OptionsView.cb_ambient_light_quality = function (arg_440_0, arg_440_1, arg_440_2, arg_440_3)
	local var_440_0 = arg_440_1.options_values[arg_440_1.current_selection]

	arg_440_0.changed_user_settings.ambient_light_quality = var_440_0

	local var_440_1 = AmbientLightQuality[var_440_0]

	for iter_440_0, iter_440_1 in pairs(var_440_1) do
		arg_440_0.changed_render_settings[iter_440_0] = iter_440_1
	end

	if not arg_440_3 then
		arg_440_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_auto_exposure_speed_setup = function (arg_441_0)
	local var_441_0 = 0.1
	local var_441_1 = 2
	local var_441_2 = Application.user_setting("render_settings", "eye_adaptation_speed") or 1
	local var_441_3 = var_0_11(var_441_0, var_441_1, var_441_2)
	local var_441_4 = math.clamp(DefaultUserSettings.get("render_settings", "eye_adaptation_speed"), var_441_0, var_441_1)

	return var_441_3, var_441_0, var_441_1, 1, "menu_settings_auto_exposure_speed"
end

OptionsView.cb_auto_exposure_speed_saved_value = function (arg_442_0, arg_442_1)
	local var_442_0 = arg_442_1.content
	local var_442_1 = var_442_0.min
	local var_442_2 = var_442_0.max
	local var_442_3 = var_0_12(arg_442_0.changed_render_settings.eye_adaptation_speed, Application.user_setting("render_settings", "eye_adaptation_speed"))
	local var_442_4 = math.clamp(var_442_3, var_442_1, var_442_2)

	var_442_0.internal_value = var_0_11(var_442_1, var_442_2, var_442_4)
	var_442_0.value = var_442_4
end

OptionsView.cb_auto_exposure_speed = function (arg_443_0, arg_443_1, arg_443_2, arg_443_3)
	arg_443_0.changed_render_settings.eye_adaptation_speed = arg_443_1.value

	if not arg_443_3 then
		arg_443_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_volumetric_fog_quality_setup = function (arg_444_0)
	local var_444_0 = {
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
	local var_444_1 = Application.user_setting("volumetric_fog_quality")
	local var_444_2 = DefaultUserSettings.get("user_settings", "volumetric_fog_quality")
	local var_444_3 = 1
	local var_444_4

	for iter_444_0 = 1, #var_444_0 do
		if var_444_0[iter_444_0].value == var_444_1 then
			var_444_3 = iter_444_0
		end

		if var_444_2 == var_444_0[iter_444_0].value then
			var_444_4 = iter_444_0
		end
	end

	return var_444_3, var_444_0, "menu_settings_volumetric_fog_quality", var_444_4
end

OptionsView.cb_volumetric_fog_quality_saved_value = function (arg_445_0, arg_445_1)
	local var_445_0 = var_0_12(arg_445_0.changed_user_settings.volumetric_fog_quality, Application.user_setting("volumetric_fog_quality"))
	local var_445_1 = arg_445_1.content.options_values
	local var_445_2 = 1

	for iter_445_0 = 1, #var_445_1 do
		if var_445_0 == var_445_1[iter_445_0] then
			var_445_2 = iter_445_0
		end
	end

	arg_445_1.content.current_selection = var_445_2
end

OptionsView.cb_volumetric_fog_quality = function (arg_446_0, arg_446_1, arg_446_2, arg_446_3)
	local var_446_0 = arg_446_1.options_values[arg_446_1.current_selection]

	arg_446_0.changed_user_settings.volumetric_fog_quality = var_446_0

	local var_446_1 = VolumetricFogQuality[var_446_0]

	for iter_446_0, iter_446_1 in pairs(var_446_1) do
		arg_446_0.changed_render_settings[iter_446_0] = iter_446_1
	end

	if not arg_446_3 then
		arg_446_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_physic_debris_setup = function (arg_447_0)
	local var_447_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_447_1 = Application.user_setting("use_physic_debris")

	if var_447_1 == nil then
		var_447_1 = true
	end

	local var_447_2 = var_447_1 and 2 or 1
	local var_447_3 = DefaultUserSettings.get("user_settings", "use_physic_debris") and 2 or 1

	return var_447_2, var_447_0, "menu_settings_physic_debris", var_447_3
end

OptionsView.cb_physic_debris_saved_value = function (arg_448_0, arg_448_1)
	local var_448_0 = var_0_12(arg_448_0.changed_user_settings.use_physic_debris, Application.user_setting("use_physic_debris"))

	if var_448_0 == nil then
		var_448_0 = true
	end

	arg_448_1.content.current_selection = var_448_0 and 2 or 1
end

OptionsView.cb_physic_debris = function (arg_449_0, arg_449_1, arg_449_2, arg_449_3)
	local var_449_0 = arg_449_1.options_values
	local var_449_1 = arg_449_1.current_selection

	arg_449_0.changed_user_settings.use_physic_debris = var_449_0[var_449_1]

	if not arg_449_3 then
		arg_449_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_alien_fx_setup = function (arg_450_0)
	local var_450_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_450_1 = Application.user_setting("use_alien_fx")

	if var_450_1 == nil then
		var_450_1 = true
	end

	local var_450_2 = var_450_1 and 2 or 1
	local var_450_3 = DefaultUserSettings.get("user_settings", "use_alien_fx") and 2 or 1

	GameSettingsDevelopment.use_alien_fx = var_450_1

	return var_450_2, var_450_0, "menu_settings_alien_fx", var_450_3
end

OptionsView.cb_alien_fx_saved_value = function (arg_451_0, arg_451_1)
	local var_451_0 = var_0_12(arg_451_0.changed_user_settings.use_alien_fx, Application.user_setting("use_alien_fx"))

	if var_451_0 == nil then
		var_451_0 = true
	end

	arg_451_1.content.current_selection = var_451_0 and 2 or 1
end

OptionsView.cb_alien_fx = function (arg_452_0, arg_452_1)
	local var_452_0 = arg_452_1.options_values
	local var_452_1 = arg_452_1.current_selection

	arg_452_0.changed_user_settings.use_alien_fx = var_452_0[var_452_1]
	GameSettingsDevelopment.use_alien_fx = var_452_0[var_452_1]
end

OptionsView.cb_razer_chroma_setup = function (arg_453_0)
	print("cb_razer_chroma_setup")

	local var_453_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_453_1 = Application.user_setting("use_razer_chroma")

	if var_453_1 == nil then
		var_453_1 = false
	end

	local var_453_2 = var_453_1 and 2 or 1
	local var_453_3 = DefaultUserSettings.get("user_settings", "use_razer_chroma") and 2 or 1

	GameSettingsDevelopment.use_razer_chroma = var_453_1

	return var_453_2, var_453_0, "menu_settings_razer_chroma", var_453_3
end

OptionsView.cb_razer_chroma_saved_value = function (arg_454_0, arg_454_1)
	local var_454_0 = var_0_12(arg_454_0.changed_user_settings.use_razer_chroma, Application.user_setting("use_razer_chroma"))

	if var_454_0 == nil then
		var_454_0 = false
	end

	arg_454_1.content.current_selection = var_454_0 and 2 or 1
end

OptionsView.cb_razer_chroma = function (arg_455_0, arg_455_1)
	local var_455_0 = arg_455_1.options_values
	local var_455_1 = arg_455_1.current_selection

	arg_455_0.changed_user_settings.use_razer_chroma = var_455_0[var_455_1]
	GameSettingsDevelopment.use_razer_chroma = var_455_0[var_455_1]
end

OptionsView.cb_ssr_setup = function (arg_456_0)
	local var_456_0 = {
		{
			value = false,
			text = Localize("menu_settings_off")
		},
		{
			value = true,
			text = Localize("menu_settings_on")
		}
	}
	local var_456_1 = Application.user_setting("render_settings", "ssr_enabled") or false
	local var_456_2 = DefaultUserSettings.get("render_settings", "ssr_enabled")
	local var_456_3 = var_456_1 and 2 or 1
	local var_456_4 = var_456_2 and 2 or 1

	return var_456_3, var_456_0, "menu_settings_ssr", var_456_4
end

OptionsView.cb_ssr_saved_value = function (arg_457_0, arg_457_1)
	local var_457_0 = var_0_12(arg_457_0.changed_render_settings.ssr_enabled, Application.user_setting("render_settings", "ssr_enabled")) or false

	arg_457_1.content.current_selection = var_457_0 and 2 or 1
end

OptionsView.cb_ssr = function (arg_458_0, arg_458_1, arg_458_2, arg_458_3)
	local var_458_0 = arg_458_1.options_values
	local var_458_1 = arg_458_1.current_selection

	arg_458_0.changed_render_settings.ssr_enabled = var_458_0[var_458_1]

	if not arg_458_3 then
		arg_458_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_fov_setup = function (arg_459_0)
	local var_459_0 = 45
	local var_459_1 = 120

	if not IS_WINDOWS then
		var_459_0, var_459_1 = 65, 90
	end

	local var_459_2 = CameraSettings.first_person._node.vertical_fov
	local var_459_3 = Application.user_setting("render_settings", "fov") or var_459_2
	local var_459_4 = var_0_11(var_459_0, var_459_1, var_459_3)
	local var_459_5 = math.clamp(var_459_3, var_459_0, var_459_1) / var_459_2
	local var_459_6 = Managers.state.camera

	if var_459_6 then
		var_459_6:set_fov_multiplier(var_459_5)
	end

	local var_459_7 = math.clamp(DefaultUserSettings.get("render_settings", "fov"), var_459_0, var_459_1)

	return var_459_4, var_459_0, var_459_1, 0, "menu_settings_fov", var_459_7
end

OptionsView.cb_fov_saved_value = function (arg_460_0, arg_460_1)
	local var_460_0 = arg_460_1.content
	local var_460_1 = var_460_0.min
	local var_460_2 = var_460_0.max
	local var_460_3 = CameraSettings.first_person._node.vertical_fov
	local var_460_4 = var_0_12(arg_460_0.changed_render_settings.fov, Application.user_setting("render_settings", "fov")) or var_460_3
	local var_460_5 = math.clamp(var_460_4, var_460_1, var_460_2)

	var_460_0.internal_value = var_0_11(var_460_1, var_460_2, var_460_5)
	var_460_0.value = var_460_5
end

OptionsView.cb_fov = function (arg_461_0, arg_461_1)
	arg_461_0.changed_render_settings.fov = arg_461_1.value
end

OptionsView.cb_enabled_crosshairs = function (arg_462_0, arg_462_1)
	local var_462_0 = arg_462_1.options_values
	local var_462_1 = arg_462_1.current_selection

	arg_462_0.changed_user_settings.enabled_crosshairs = var_462_0[var_462_1]
end

OptionsView.cb_enabled_crosshairs_setup = function (arg_463_0)
	local var_463_0 = {
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
	local var_463_1 = DefaultUserSettings.get("user_settings", "enabled_crosshairs")
	local var_463_2 = Application.user_setting("enabled_crosshairs")
	local var_463_3
	local var_463_4

	for iter_463_0, iter_463_1 in ipairs(var_463_0) do
		if iter_463_1.value == var_463_2 then
			var_463_4 = iter_463_0
		end

		if iter_463_1.value == var_463_1 then
			var_463_3 = iter_463_0
		end
	end

	fassert(var_463_3, "default option %i does not exist in cb_enabled_crosshairs_setup options table", var_463_1)

	return var_463_4 or var_463_3, var_463_0, "menu_settings_enabled_crosshairs", var_463_3
end

OptionsView.cb_enabled_crosshairs_saved_value = function (arg_464_0, arg_464_1)
	local var_464_0 = var_0_12(arg_464_0.changed_user_settings.enabled_crosshairs, Application.user_setting("enabled_crosshairs")) or DefaultUserSettings.get("user_settings", "enabled_crosshairs")
	local var_464_1 = arg_464_1.content.options_values
	local var_464_2 = 1

	for iter_464_0 = 1, #var_464_1 do
		if var_464_0 == var_464_1[iter_464_0] then
			var_464_2 = iter_464_0

			break
		end
	end

	arg_464_1.content.current_selection = var_464_2
end

OptionsView.cb_blood_enabled_setup = function (arg_465_0)
	local var_465_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_465_1 = Application.user_setting("blood_enabled")
	local var_465_2 = DefaultUserSettings.get("user_settings", "blood_enabled")

	if var_465_1 == nil then
		var_465_1 = var_465_2
	end

	local var_465_3 = 1

	if not var_465_1 then
		var_465_3 = 2
	end

	local var_465_4 = 1

	if not var_465_2 then
		var_465_4 = 2
	end

	return var_465_3, var_465_0, "menu_settings_blood_enabled", var_465_4
end

OptionsView.cb_blood_enabled_saved_value = function (arg_466_0, arg_466_1)
	local var_466_0 = arg_466_1.content.options_values
	local var_466_1 = var_0_12(arg_466_0.changed_user_settings.blood_enabled, Application.user_setting("blood_enabled"))

	if var_466_1 == nil then
		var_466_1 = true
	end

	local var_466_2 = 1

	for iter_466_0, iter_466_1 in pairs(var_466_0) do
		if iter_466_1 == var_466_1 then
			var_466_2 = iter_466_0

			break
		end
	end

	arg_466_1.content.current_selection = var_466_2
	arg_466_1.content.selected_option = var_466_2
end

OptionsView.cb_blood_enabled = function (arg_467_0, arg_467_1)
	local var_467_0 = arg_467_1.options_values[arg_467_1.current_selection]

	arg_467_0.changed_user_settings.blood_enabled = var_467_0
end

OptionsView.cb_screen_blood_enabled_setup = function (arg_468_0)
	local var_468_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_468_1 = Application.user_setting("screen_blood_enabled")
	local var_468_2 = DefaultUserSettings.get("user_settings", "screen_blood_enabled")

	if var_468_1 == nil then
		var_468_1 = var_468_2
	end

	local var_468_3 = 1

	if not var_468_1 then
		var_468_3 = 2
	end

	local var_468_4 = 1

	if not var_468_2 then
		var_468_4 = 2
	end

	return var_468_3, var_468_0, "menu_settings_screen_blood_enabled", var_468_4
end

OptionsView.cb_screen_blood_enabled_saved_value = function (arg_469_0, arg_469_1)
	local var_469_0 = arg_469_1.content.options_values
	local var_469_1 = var_0_12(arg_469_0.changed_user_settings.screen_blood_enabled, Application.user_setting("screen_blood_enabled"))

	if var_469_1 == nil then
		var_469_1 = true
	end

	local var_469_2 = 1

	for iter_469_0, iter_469_1 in pairs(var_469_0) do
		if iter_469_1 == var_469_1 then
			var_469_2 = iter_469_0

			break
		end
	end

	arg_469_1.content.current_selection = var_469_2
	arg_469_1.content.selected_option = var_469_2
end

OptionsView.cb_screen_blood_enabled = function (arg_470_0, arg_470_1)
	local var_470_0 = arg_470_1.options_values[arg_470_1.current_selection]

	arg_470_0.changed_user_settings.screen_blood_enabled = var_470_0
end

OptionsView.cb_dismemberment_enabled_setup = function (arg_471_0)
	local var_471_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_471_1 = Application.user_setting("dismemberment_enabled")
	local var_471_2 = DefaultUserSettings.get("user_settings", "dismemberment_enabled")

	if var_471_1 == nil then
		var_471_1 = var_471_2
	end

	local var_471_3 = 1

	if not var_471_1 then
		var_471_3 = 2
	end

	local var_471_4 = 1

	if not var_471_2 then
		var_471_4 = 2
	end

	return var_471_3, var_471_0, "menu_settings_dismemberment_enabled", var_471_4
end

OptionsView.cb_dismemberment_enabled_saved_value = function (arg_472_0, arg_472_1)
	local var_472_0 = arg_472_1.content.options_values
	local var_472_1 = var_0_12(arg_472_0.changed_user_settings.dismemberment_enabled, Application.user_setting("dismemberment_enabled"))

	if var_472_1 == nil then
		var_472_1 = true
	end

	local var_472_2 = 1

	for iter_472_0, iter_472_1 in pairs(var_472_0) do
		if iter_472_1 == var_472_1 then
			var_472_2 = iter_472_0

			break
		end
	end

	arg_472_1.content.current_selection = var_472_2
	arg_472_1.content.selected_option = var_472_2
end

OptionsView.cb_dismemberment_enabled = function (arg_473_0, arg_473_1)
	local var_473_0 = arg_473_1.options_values[arg_473_1.current_selection]

	arg_473_0.changed_user_settings.dismemberment_enabled = var_473_0
end

OptionsView.cb_ragdoll_enabled_setup = function (arg_474_0)
	local var_474_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_474_1 = Application.user_setting("ragdoll_enabled")
	local var_474_2 = DefaultUserSettings.get("user_settings", "ragdoll_enabled")

	if var_474_1 == nil then
		var_474_1 = var_474_2
	end

	local var_474_3 = 1

	if not var_474_1 then
		var_474_3 = 2
	end

	local var_474_4 = 1

	if not var_474_2 then
		var_474_4 = 2
	end

	return var_474_3, var_474_0, "menu_settings_ragdoll_enabled", var_474_4
end

OptionsView.cb_ragdoll_enabled_saved_value = function (arg_475_0, arg_475_1)
	local var_475_0 = arg_475_1.content.options_values
	local var_475_1 = var_0_12(arg_475_0.changed_user_settings.ragdoll_enabled, Application.user_setting("ragdoll_enabled"))

	if var_475_1 == nil then
		var_475_1 = true
	end

	local var_475_2 = 1

	for iter_475_0, iter_475_1 in pairs(var_475_0) do
		if iter_475_1 == var_475_1 then
			var_475_2 = iter_475_0

			break
		end
	end

	arg_475_1.content.current_selection = var_475_2
	arg_475_1.content.selected_option = var_475_2
end

OptionsView.cb_ragdoll_enabled = function (arg_476_0, arg_476_1)
	local var_476_0 = arg_476_1.options_values[arg_476_1.current_selection]

	arg_476_0.changed_user_settings.ragdoll_enabled = var_476_0
end

OptionsView.cb_chat_enabled_setup = function (arg_477_0)
	local var_477_0 = {
		{
			value = true,
			text = Localize("menu_settings_on")
		},
		{
			value = false,
			text = Localize("menu_settings_off")
		}
	}
	local var_477_1 = Application.user_setting("chat_enabled")
	local var_477_2 = DefaultUserSettings.get("user_settings", "chat_enabled")

	if var_477_1 == nil then
		var_477_1 = var_477_2
	end

	local var_477_3 = 1

	if not var_477_1 then
		var_477_3 = 2
	end

	local var_477_4 = 1

	if not var_477_2 then
		var_477_4 = 2
	end

	local var_477_5 = "menu_settings_chat_enabled"

	if not IS_WINDOWS then
		var_477_5 = "menu_settings_chat_enabled_" .. PLATFORM
	end

	return var_477_3, var_477_0, var_477_5, var_477_4
end

OptionsView.cb_chat_enabled_saved_value = function (arg_478_0, arg_478_1)
	local var_478_0 = arg_478_1.content.options_values
	local var_478_1 = var_0_12(arg_478_0.changed_user_settings.chat_enabled, Application.user_setting("chat_enabled"))

	if var_478_1 == nil then
		var_478_1 = true
	end

	local var_478_2 = 1

	for iter_478_0, iter_478_1 in pairs(var_478_0) do
		if iter_478_1 == var_478_1 then
			var_478_2 = iter_478_0

			break
		end
	end

	arg_478_1.content.current_selection = var_478_2
	arg_478_1.content.selected_option = var_478_2
end

OptionsView.cb_chat_enabled = function (arg_479_0, arg_479_1)
	local var_479_0 = arg_479_1.options_values[arg_479_1.current_selection]

	arg_479_0.changed_user_settings.chat_enabled = var_479_0
end

OptionsView.cb_chat_font_size = function (arg_480_0, arg_480_1)
	local var_480_0 = arg_480_1.options_values
	local var_480_1 = arg_480_1.current_selection

	arg_480_0.changed_user_settings.chat_font_size = var_480_0[var_480_1]
end

OptionsView.cb_chat_font_size_setup = function (arg_481_0)
	local var_481_0 = {
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
	local var_481_1 = DefaultUserSettings.get("user_settings", "chat_font_size")
	local var_481_2 = Application.user_setting("chat_font_size")
	local var_481_3
	local var_481_4

	for iter_481_0, iter_481_1 in ipairs(var_481_0) do
		if iter_481_1.value == var_481_2 then
			var_481_4 = iter_481_0
		end

		if iter_481_1.value == var_481_1 then
			var_481_3 = iter_481_0
		end
	end

	fassert(var_481_3, "default option %i does not exist in cb_chat_font_size_setup options table", var_481_1)

	return var_481_4 or var_481_3, var_481_0, "menu_settings_chat_font_size", var_481_3
end

OptionsView.cb_chat_font_size_saved_value = function (arg_482_0, arg_482_1)
	local var_482_0 = var_0_12(arg_482_0.changed_user_settings.chat_font_size, Application.user_setting("chat_font_size")) or DefaultUserSettings.get("user_settings", "chat_font_size")
	local var_482_1 = arg_482_1.content.options_values
	local var_482_2 = 1

	for iter_482_0 = 1, #var_482_1 do
		if var_482_0 == var_482_1[iter_482_0] then
			var_482_2 = iter_482_0

			break
		end
	end

	arg_482_1.content.current_selection = var_482_2
end

OptionsView.cb_clan_tag_setup = function (arg_483_0)
	local var_483_0 = {
		{
			value = "0",
			text = Localize("menu_settings_none")
		}
	}
	local var_483_1 = Application.user_setting("clan_tag")
	local var_483_2 = SteamHelper.clans_short()
	local var_483_3 = 2
	local var_483_4 = 1
	local var_483_5 = var_483_4

	for iter_483_0, iter_483_1 in pairs(var_483_2) do
		if iter_483_1 ~= "" then
			var_483_0[var_483_3] = {
				text = iter_483_1,
				value = iter_483_0
			}

			if iter_483_0 == var_483_1 then
				var_483_5 = var_483_3
			end

			var_483_3 = var_483_3 + 1
		end
	end

	return var_483_5, var_483_0, "menu_settings_clan_tag", var_483_4
end

OptionsView.cb_clan_tag_saved_value = function (arg_484_0, arg_484_1)
	local var_484_0 = arg_484_1.content.options_values
	local var_484_1 = var_0_12(arg_484_0.changed_user_settings.clan_tag, Application.user_setting("clan_tag"))

	if var_484_1 == nil then
		var_484_1 = "0"
	end

	local var_484_2 = 1

	for iter_484_0, iter_484_1 in pairs(var_484_0) do
		if iter_484_1 == var_484_1 then
			var_484_2 = iter_484_0

			break
		end
	end

	arg_484_1.content.current_selection = var_484_2
	arg_484_1.content.selected_option = var_484_2
end

OptionsView.cb_clan_tag = function (arg_485_0, arg_485_1)
	local var_485_0 = arg_485_1.options_values[arg_485_1.current_selection]

	arg_485_0.changed_user_settings.clan_tag = var_485_0
end

OptionsView.cb_blood_decals_setup = function (arg_486_0)
	local var_486_0 = 0
	local var_486_1 = 500
	local var_486_2 = Application.user_setting("num_blood_decals") or BloodSettings.blood_decals.num_decals
	local var_486_3 = DefaultUserSettings.get("user_settings", "num_blood_decals")
	local var_486_4 = var_0_11(var_486_0, var_486_1, var_486_2)
	local var_486_5 = math.clamp(var_486_2, var_486_0, var_486_1)

	BloodSettings.blood_decals.num_decals = var_486_5

	return var_486_4, var_486_0, var_486_1, 0, "menu_settings_num_blood_decals", var_486_3
end

OptionsView.cb_blood_decals_saved_value = function (arg_487_0, arg_487_1)
	local var_487_0 = arg_487_1.content
	local var_487_1 = var_487_0.min
	local var_487_2 = var_487_0.max
	local var_487_3 = var_0_12(arg_487_0.changed_user_settings.num_blood_decals, Application.user_setting("num_blood_decals")) or BloodSettings.blood_decals.num_decals
	local var_487_4 = math.clamp(var_487_3, var_487_1, var_487_2)

	var_487_0.internal_value = var_0_11(var_487_1, var_487_2, var_487_4)
	var_487_0.value = var_487_4
end

OptionsView.cb_blood_decals = function (arg_488_0, arg_488_1, arg_488_2, arg_488_3)
	arg_488_0.changed_user_settings.num_blood_decals = arg_488_1.value

	if not arg_488_3 then
		arg_488_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_dynamic_range_sound_setup = function (arg_489_0)
	local var_489_0 = {
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
	local var_489_1 = DefaultUserSettings.get("user_settings", "dynamic_range_sound")
	local var_489_2 = Application.user_setting("dynamic_range_sound") or var_489_1
	local var_489_3 = 1

	if var_489_2 == "high" then
		var_489_3 = 1
	elseif var_489_2 == "medium" then
		var_489_3 = 2
	elseif var_489_2 == "low" then
		var_489_3 = 3
	end

	local var_489_4 = 1

	return var_489_3, var_489_0, "menu_settings_dynamic_range_sound", var_489_4
end

OptionsView.cb_dynamic_range_sound_saved_value = function (arg_490_0, arg_490_1)
	local var_490_0 = var_0_12(arg_490_0.changed_user_settings.dynamic_range_sound, Application.user_setting("dynamic_range_sound")) or "low"
	local var_490_1 = 1

	if var_490_0 == "high" then
		var_490_1 = 1
	elseif var_490_0 == "medium" then
		var_490_1 = 2
	elseif var_490_0 == "low" then
		var_490_1 = 3
	end

	arg_490_1.content.current_selection = var_490_1
end

OptionsView.cb_dynamic_range_sound = function (arg_491_0, arg_491_1)
	local var_491_0 = arg_491_1.options_values[arg_491_1.current_selection]

	arg_491_0.changed_user_settings.dynamic_range_sound = var_491_0

	local var_491_1

	if var_491_0 == "high" then
		var_491_1 = 0
	elseif var_491_0 == "medium" then
		var_491_1 = 0.5
	elseif var_491_0 == "low" then
		var_491_1 = 1
	end

	arg_491_0:set_wwise_parameter("dynamic_range_sound", var_491_1)
end

OptionsView.cb_sound_panning_rule_setup = function (arg_492_0)
	local var_492_0 = {
		{
			value = "headphones",
			text = Localize("menu_settings_headphones")
		},
		{
			value = "speakers",
			text = Localize("menu_settings_speakers")
		}
	}
	local var_492_1 = 1
	local var_492_2
	local var_492_3 = DefaultUserSettings.get("user_settings", "sound_panning_rule")
	local var_492_4 = Application.user_setting("sound_panning_rule") or var_492_3

	if var_492_4 == "headphones" then
		var_492_1 = 1
	elseif var_492_4 == "speakers" then
		var_492_1 = 2
	end

	if var_492_3 == "headphones" then
		var_492_2 = 1
	elseif var_492_3 == "speakers" then
		var_492_2 = 2
	end

	return var_492_1, var_492_0, "menu_settings_sound_panning_rule", var_492_2
end

OptionsView.cb_sound_panning_rule_saved_value = function (arg_493_0, arg_493_1)
	local var_493_0 = 1
	local var_493_1 = var_0_12(arg_493_0.changed_user_settings.sound_panning_rule, Application.user_setting("sound_panning_rule")) or "headphones"

	if var_493_1 == "headphones" then
		var_493_0 = 1
	elseif var_493_1 == "speakers" then
		var_493_0 = 2
	end

	arg_493_1.content.current_selection = var_493_0
end

OptionsView.cb_sound_panning_rule = function (arg_494_0, arg_494_1)
	local var_494_0 = arg_494_1.options_values[arg_494_1.current_selection]

	arg_494_0.changed_user_settings.sound_panning_rule = var_494_0

	if var_494_0 == "headphones" then
		Managers.music:set_panning_rule("PANNING_RULE_HEADPHONES")
	elseif var_494_0 == "speakers" then
		Managers.music:set_panning_rule("PANNING_RULE_SPEAKERS")
	end
end

OptionsView.cb_sound_quality_setup = function (arg_495_0)
	local var_495_0 = {
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
	local var_495_1 = Application.user_setting("sound_quality")
	local var_495_2 = DefaultUserSettings.get("user_settings", "sound_quality")
	local var_495_3

	for iter_495_0 = 1, #var_495_0 do
		local var_495_4 = var_495_0[iter_495_0].value

		if var_495_1 == var_495_4 then
			var_495_3 = iter_495_0
		end

		if var_495_2 == var_495_4 then
			var_495_2 = iter_495_0
		end
	end

	return var_495_3, var_495_0, "menu_settings_sound_quality", var_495_2
end

OptionsView.cb_sound_quality_saved_value = function (arg_496_0, arg_496_1)
	local var_496_0 = var_0_12(arg_496_0.changed_user_settings.sound_quality, Application.user_setting("sound_quality"))
	local var_496_1 = arg_496_1.content.options_values
	local var_496_2

	for iter_496_0 = 1, #var_496_1 do
		if var_496_0 == var_496_1[iter_496_0] then
			var_496_2 = iter_496_0
		end
	end

	arg_496_1.content.current_selection = var_496_2
end

OptionsView.cb_sound_quality = function (arg_497_0, arg_497_1)
	local var_497_0 = arg_497_1.options_values[arg_497_1.current_selection]

	arg_497_0.changed_user_settings.sound_quality = var_497_0
end

OptionsView.cb_animation_lod_distance_setup = function (arg_498_0)
	local var_498_0 = 0
	local var_498_1 = 1
	local var_498_2 = Application.user_setting("animation_lod_distance_multiplier") or GameSettingsDevelopment.bone_lod_husks.lod_multiplier

	return var_0_11(var_498_0, var_498_1, var_498_2), var_498_0, var_498_1, 1, "menu_settings_animation_lod_multiplier"
end

OptionsView.cb_animation_lod_distance_saved_value = function (arg_499_0, arg_499_1)
	local var_499_0 = arg_499_1.content
	local var_499_1 = var_499_0.min
	local var_499_2 = var_499_0.max
	local var_499_3 = var_0_12(arg_499_0.changed_user_settings.animation_lod_distance_multiplier, Application.user_setting("animation_lod_distance_multiplier")) or GameSettingsDevelopment.bone_lod_husks.lod_multiplier
	local var_499_4 = math.clamp(var_499_3, var_499_1, var_499_2)

	var_499_0.internal_value = var_0_11(var_499_1, var_499_2, var_499_4)
	var_499_0.value = var_499_4
end

OptionsView.cb_animation_lod_distance = function (arg_500_0, arg_500_1, arg_500_2, arg_500_3)
	arg_500_0.changed_user_settings.animation_lod_distance_multiplier = arg_500_1.value

	if not arg_500_3 then
		arg_500_0:force_set_widget_value("graphics_quality_settings", "custom")
	end
end

OptionsView.cb_player_outlines_setup = function (arg_501_0)
	local var_501_0 = {
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
	local var_501_1 = Application.user_setting("player_outlines")
	local var_501_2 = DefaultUserSettings.get("user_settings", "player_outlines")
	local var_501_3
	local var_501_4

	for iter_501_0, iter_501_1 in ipairs(var_501_0) do
		if var_501_1 == iter_501_1.value then
			var_501_3 = iter_501_0
		end

		if var_501_2 == iter_501_1.value then
			var_501_4 = iter_501_0
		end
	end

	return var_501_3, var_501_0, "menu_settings_player_outlines", var_501_4
end

OptionsView.cb_player_outlines_saved_value = function (arg_502_0, arg_502_1)
	local var_502_0 = var_0_12(arg_502_0.changed_user_settings.player_outlines, Application.user_setting("player_outlines"))
	local var_502_1
	local var_502_2 = arg_502_1.content.options_values

	for iter_502_0 = 1, #var_502_2 do
		if var_502_0 == var_502_2[iter_502_0] then
			var_502_1 = iter_502_0
		end
	end

	arg_502_1.content.current_selection = var_502_1
end

OptionsView.cb_player_outlines = function (arg_503_0, arg_503_1)
	local var_503_0 = arg_503_1.current_selection
	local var_503_1 = arg_503_1.options_values[var_503_0]

	arg_503_0.changed_user_settings.player_outlines = var_503_1
end

OptionsView.cb_minion_outlines = function (arg_504_0, arg_504_1)
	local var_504_0 = arg_504_1.current_selection
	local var_504_1 = arg_504_1.options_values[var_504_0]

	arg_504_0.changed_user_settings.minion_outlines = var_504_1
end

OptionsView.cb_minion_outlines_setup = function (arg_505_0)
	local var_505_0 = {
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
	local var_505_1 = Application.user_setting("minion_outlines")
	local var_505_2 = DefaultUserSettings.get("user_settings", "minion_outlines")
	local var_505_3
	local var_505_4

	for iter_505_0, iter_505_1 in ipairs(var_505_0) do
		if var_505_1 == iter_505_1.value then
			var_505_3 = iter_505_0
		end

		if var_505_2 == iter_505_1.value then
			var_505_4 = iter_505_0
		end
	end

	return var_505_3, var_505_0, "menu_settings_minion_outlines", var_505_4
end

OptionsView.cb_minion_outlines_saved_value = function (arg_506_0, arg_506_1)
	local var_506_0 = var_0_12(arg_506_0.changed_user_settings.minion_outlines, Application.user_setting("minion_outlines"))
	local var_506_1
	local var_506_2 = arg_506_1.content.options_values

	for iter_506_0 = 1, #var_506_2 do
		if var_506_0 == var_506_2[iter_506_0] then
			var_506_1 = iter_506_0
		end
	end

	arg_506_1.content.current_selection = var_506_1
end

local function var_0_29(arg_507_0, arg_507_1)
	local var_507_0 = "cb_" .. arg_507_0
	local var_507_1 = var_507_0 .. "_setup"

	OptionsView[var_507_1] = function (arg_508_0)
		local var_508_0 = {
			{
				value = false,
				text = Localize("menu_settings_off")
			},
			{
				value = true,
				text = Localize("menu_settings_on")
			}
		}
		local var_508_1 = Application.user_setting(arg_507_0)

		if var_508_1 == nil then
			var_508_1 = true
		end

		local var_508_2 = var_508_1 and 2 or 1
		local var_508_3 = DefaultUserSettings.get("user_settings", arg_507_0) and 2 or 1

		GameSettingsDevelopment[arg_507_0] = var_508_1

		return var_508_2, var_508_0, "menu_settings_" .. arg_507_0, var_508_3
	end
	OptionsView[var_507_0] = function (arg_509_0, arg_509_1)
		local var_509_0 = arg_509_1.options_values
		local var_509_1 = arg_509_1.current_selection

		arg_509_0.changed_user_settings[arg_507_0] = var_509_0[var_509_1]
		GameSettingsDevelopment[arg_507_0] = var_509_0[var_509_1]

		if arg_507_1 ~= nil then
			arg_507_1(arg_509_0, arg_509_1.current_selection == 2)
		end
	end

	local var_507_2 = var_507_0 .. "_saved_value"

	OptionsView[var_507_2] = function (arg_510_0, arg_510_1)
		local var_510_0 = var_0_12(arg_510_0.changed_user_settings[arg_507_0], Application.user_setting(arg_507_0))

		if var_510_0 == nil then
			var_510_0 = true
		end

		arg_510_1.content.current_selection = var_510_0 and 2 or 1
	end
end

local function var_0_30(arg_511_0, arg_511_1, arg_511_2, arg_511_3, arg_511_4)
	local var_511_0 = "cb_" .. arg_511_0
	local var_511_1 = var_511_0 .. "_setup"

	OptionsView[var_511_1] = function (arg_512_0)
		local var_512_0 = Application.user_setting(arg_511_0) or DefaultUserSettings[arg_511_0]
		local var_512_1 = DefaultUserSettings.get("user_settings", arg_511_0)

		return var_0_11(arg_511_1, arg_511_2, var_512_0), arg_511_1, arg_511_2, arg_511_3, "menu_settings_" .. arg_511_0, var_512_1
	end
	OptionsView[var_511_0] = function (arg_513_0, arg_513_1)
		arg_513_0.changed_user_settings[arg_511_0] = arg_513_1.value

		if arg_511_4 ~= nil then
			arg_511_4(arg_513_0, arg_513_1.internal_value)
		end
	end

	local var_511_2 = var_511_0 .. "_saved_value"

	OptionsView[var_511_2] = function (arg_514_0, arg_514_1)
		local var_514_0 = arg_514_1.content
		local var_514_1 = var_0_12(arg_514_0.changed_user_settings[arg_511_0], Application.user_setting(arg_511_0))
		local var_514_2 = math.clamp(var_514_1, arg_511_1, arg_511_2)

		var_514_0.internal_value = var_0_11(arg_511_1, arg_511_2, var_514_2)
		var_514_0.value = var_514_2
	end
end

local var_0_31 = {
	responsiveness = function (arg_515_0, arg_515_1)
		Tobii.set_extended_view_responsiveness(arg_515_1)
	end,
	use_head_tracking = function (arg_516_0, arg_516_1)
		Tobii.set_extended_view_use_head_tracking(arg_516_1)
	end,
	use_clean_ui = function (arg_517_0, arg_517_1)
		if not arg_517_0.in_title_screen then
			arg_517_0.ingame_ui.ingame_hud:enable_clean_ui(arg_517_1)
		end
	end
}

var_0_29("tobii_eyetracking")
var_0_29("tobii_extended_view")
var_0_29("tobii_extended_view_use_head_tracking", var_0_31.use_head_tracking)
var_0_29("tobii_aim_at_gaze")
var_0_29("tobii_fire_at_gaze")
var_0_29("tobii_clean_ui", var_0_31.use_clean_ui)
var_0_30("tobii_extended_view_sensitivity", 1, 100, 0, var_0_31.responsiveness)

local function var_0_32(arg_518_0, arg_518_1)
	local var_518_0
	local var_518_1 = false

	if arg_518_1 == nil or arg_518_1 == UNASSIGNED_KEY then
		var_518_0 = Localize(UNASSIGNED_KEY)
		var_518_1 = true
	elseif arg_518_0 == "keyboard" then
		local var_518_2 = Keyboard.button_index(arg_518_1)

		var_518_0 = Keyboard.button_locale_name(var_518_2)
	elseif arg_518_0 == "mouse" then
		var_518_0 = string.format("%s %s", "mouse", arg_518_1)
	elseif arg_518_0 == "gamepad" then
		local var_518_3 = Pad1.button_index(arg_518_1)

		var_518_0 = Pad1.button_locale_name(var_518_3) ~= "" or arg_518_1
	end

	return var_518_0 ~= "" and var_518_0 or TextToUpper(arg_518_1), var_518_1
end

OptionsView.cb_keybind_setup = function (arg_519_0, arg_519_1, arg_519_2, arg_519_3)
	local var_519_0 = arg_519_0.session_keymaps[arg_519_1][arg_519_2]
	local var_519_1 = {}

	for iter_519_0, iter_519_1 in ipairs(arg_519_3) do
		local var_519_2 = var_519_0[iter_519_1]

		var_519_1[iter_519_0] = {
			action = iter_519_1,
			keybind = table.clone(var_519_2)
		}
	end

	local var_519_3 = var_519_1[1]
	local var_519_4 = var_0_32(var_519_3.keybind[1], var_519_3.keybind[2])
	local var_519_5 = var_0_32(var_519_3.keybind[4], var_519_3.keybind[5])
	local var_519_6 = rawget(_G, arg_519_1)[arg_519_2][arg_519_3[1]]
	local var_519_7 = {
		controller = var_519_6[1],
		key = var_519_6[2]
	}

	return var_519_4, var_519_5, var_519_1, var_519_7
end

OptionsView.cb_keybind_saved_value = function (arg_520_0, arg_520_1)
	local var_520_0 = arg_520_1.content.actions

	if not var_520_0 then
		return
	end

	local var_520_1 = arg_520_1.content.keymappings_key
	local var_520_2 = arg_520_1.content.keymappings_table_key
	local var_520_3 = arg_520_0.original_keymaps[var_520_1][var_520_2]
	local var_520_4 = {}

	for iter_520_0, iter_520_1 in ipairs(var_520_0) do
		local var_520_5 = var_520_3[iter_520_1]

		var_520_4[iter_520_0] = {
			action = iter_520_1,
			keybind = table.clone(var_520_5)
		}
	end

	local var_520_6 = var_520_4[1]

	arg_520_1.content.selected_key_1, arg_520_1.content.is_unassigned_1 = var_0_32(var_520_6.keybind[1], var_520_6.keybind[2])
	arg_520_1.content.selected_key_2, arg_520_1.content.is_unassigned_2 = var_0_32(var_520_6.keybind[4], var_520_6.keybind[5])
	arg_520_1.content.actions_info = var_520_4
end

OptionsView.cleanup_duplicates = function (arg_521_0, arg_521_1, arg_521_2)
	local var_521_0 = arg_521_0.selected_settings_list
	local var_521_1 = var_521_0.widgets
	local var_521_2 = var_521_0.widgets_n

	for iter_521_0 = 1, var_521_2 do
		local var_521_3 = var_521_1[iter_521_0]

		if var_521_3.type == "keybind" then
			local var_521_4 = var_521_3.content
			local var_521_5 = var_521_4.actions_info
			local var_521_6 = var_521_5[1].keybind[1]

			if var_521_5[1].keybind[2] == arg_521_1 and var_521_6 == arg_521_2 then
				var_521_4.callback(UNASSIGNED_KEY, arg_521_2, var_521_4)
			end
		end
	end
end

OptionsView.cb_keybind_changed = function (arg_522_0, arg_522_1, arg_522_2, arg_522_3, arg_522_4)
	local var_522_0 = arg_522_3.actions_info

	if not var_522_0 then
		return
	end

	if arg_522_4 == 2 and var_522_0[1].keybind[2] == UNASSIGNED_KEY then
		arg_522_4 = 1
	end

	local var_522_1 = var_522_0[1].keybind

	if arg_522_1 ~= UNASSIGNED_KEY and (var_522_1[1] == arg_522_2 and var_522_1[2] == arg_522_1 or var_522_1[4] == arg_522_2 and var_522_1[5] == arg_522_1) then
		return
	end

	local var_522_2 = arg_522_0.session_keymaps
	local var_522_3 = arg_522_3.keymappings_key
	local var_522_4 = arg_522_3.keymappings_table_key
	local var_522_5 = Managers.input

	for iter_522_0, iter_522_1 in ipairs(var_522_0) do
		local var_522_6 = iter_522_1.keybind
		local var_522_7 = iter_522_1.action

		if arg_522_4 == 2 then
			var_522_6[4] = arg_522_2
			var_522_6[5] = arg_522_1
			var_522_6[6] = var_522_6[3]
		else
			var_522_6[1] = arg_522_2
			var_522_6[2] = arg_522_1
		end

		var_522_6.changed = true

		local var_522_8 = var_522_2[var_522_3][var_522_4][var_522_7]

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

	arg_522_0.changed_keymaps = true

	local var_522_9, var_522_10 = var_0_32(arg_522_2, arg_522_1)
	local var_522_11 = var_522_10 and "keybind_bind_cancel" or "keybind_bind_success"
	local var_522_12 = "{#color(193,91,36)}" .. Utf8.upper(Localize(arg_522_3.text)) .. "{#reset()}"
	local var_522_13 = Utf8.upper(var_522_9)

	arg_522_0.keybind_info_text = string.format(Localize(var_522_11), var_522_12, var_522_13)

	local var_522_14 = UIAnimation.init(UIAnimation.function_by_time, arg_522_0.keybind_info_widget.style.text.text_color, 1, 0, 255, 0.4, math.easeOutCubic)

	arg_522_0.ui_animations.keybind_info_attract = var_522_14

	if arg_522_4 == 1 then
		arg_522_3.selected_key_1, arg_522_3.is_unassigned_1 = var_522_9, var_522_10
	else
		arg_522_3.selected_key_2, arg_522_3.is_unassigned_2 = var_522_9, var_522_10
	end
end

OptionsView.cb_twitch_vote_time = function (arg_523_0, arg_523_1)
	local var_523_0 = arg_523_1.options_values[arg_523_1.current_selection]

	arg_523_0.changed_user_settings.twitch_vote_time = var_523_0
end

OptionsView.cb_twitch_vote_time_setup = function (arg_524_0)
	local var_524_0 = {
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
	local var_524_1 = DefaultUserSettings.get("user_settings", "twitch_vote_time")
	local var_524_2 = Application.user_setting("twitch_vote_time")
	local var_524_3
	local var_524_4

	for iter_524_0, iter_524_1 in ipairs(var_524_0) do
		if iter_524_1.value == var_524_2 then
			var_524_4 = iter_524_0
		end

		if iter_524_1.value == var_524_1 then
			var_524_3 = iter_524_0
		end
	end

	fassert(var_524_3, "default option %i does not exist in cb_chat_font_size_setup options table", var_524_1)

	return var_524_4 or var_524_3, var_524_0, "menu_settings_twitch_vote_time", var_524_3
end

OptionsView.cb_twitch_vote_time_saved_value = function (arg_525_0, arg_525_1)
	local var_525_0 = var_0_12(arg_525_0.changed_user_settings.twitch_vote_time, Application.user_setting("twitch_vote_time")) or DefaultUserSettings.get("user_settings", "twitch_vote_time")
	local var_525_1 = arg_525_1.content.options_values
	local var_525_2 = 1

	for iter_525_0 = 1, #var_525_1 do
		if var_525_0 == var_525_1[iter_525_0] then
			var_525_2 = iter_525_0

			break
		end
	end

	arg_525_1.content.current_selection = var_525_2
end

OptionsView.cb_twitch_time_between_votes = function (arg_526_0, arg_526_1)
	local var_526_0 = arg_526_1.options_values[arg_526_1.current_selection]

	arg_526_0.changed_user_settings.twitch_time_between_votes = var_526_0
end

OptionsView.cb_twitch_time_between_votes_setup = function (arg_527_0)
	local var_527_0 = {
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
	local var_527_1 = DefaultUserSettings.get("user_settings", "twitch_time_between_votes")
	local var_527_2 = Application.user_setting("twitch_time_between_votes")
	local var_527_3
	local var_527_4

	for iter_527_0, iter_527_1 in ipairs(var_527_0) do
		if iter_527_1.value == var_527_2 then
			var_527_4 = iter_527_0
		end

		if iter_527_1.value == var_527_1 then
			var_527_3 = iter_527_0
		end
	end

	fassert(var_527_3, "default option %i does not exist in cb_chat_font_size_setup options table", var_527_1)

	return var_527_4 or var_527_3, var_527_0, "menu_settings_twitch_time_between_votes", var_527_3
end

OptionsView.cb_twitch_time_between_votes_saved_value = function (arg_528_0, arg_528_1)
	local var_528_0 = var_0_12(arg_528_0.changed_user_settings.twitch_time_between_votes, Application.user_setting("twitch_time_between_votes")) or DefaultUserSettings.get("user_settings", "twitch_time_between_votes")
	local var_528_1 = arg_528_1.content.options_values
	local var_528_2 = 1

	for iter_528_0 = 1, #var_528_1 do
		if var_528_0 == var_528_1[iter_528_0] then
			var_528_2 = iter_528_0

			break
		end
	end

	arg_528_1.content.current_selection = var_528_2
end

OptionsView.cb_twitch_difficulty_setup = function (arg_529_0)
	local var_529_0 = 0
	local var_529_1 = 100
	local var_529_2 = Application.user_setting("twitch_difficulty") or DefaultUserSettings.get("user_settings", "twitch_difficulty")
	local var_529_3 = DefaultUserSettings.get("user_settings", "twitch_difficulty")

	return var_0_11(var_529_0, var_529_1, var_529_2), var_529_0, var_529_1, 0, "menu_settings_twitch_difficulty", var_529_3
end

OptionsView.cb_twitch_difficulty_saved_value = function (arg_530_0, arg_530_1)
	local var_530_0 = arg_530_1.content
	local var_530_1 = var_530_0.min
	local var_530_2 = var_530_0.max
	local var_530_3 = var_0_12(arg_530_0.changed_user_settings.twitch_difficulty, Application.user_setting("twitch_difficulty") or DefaultUserSettings.get("user_settings", "twitch_difficulty"))
	local var_530_4 = math.clamp(var_530_3, var_530_1, var_530_2)

	var_530_0.internal_value = var_0_11(var_530_1, var_530_2, var_530_4)
	var_530_0.value = var_530_4
end

OptionsView.cb_twitch_difficulty = function (arg_531_0, arg_531_1)
	local var_531_0 = arg_531_1.value

	arg_531_0.changed_user_settings.twitch_difficulty = var_531_0
end

OptionsView.cb_twitch_spawn_amount_setup = function (arg_532_0)
	local var_532_0 = 100
	local var_532_1 = 300
	local var_532_2 = DefaultUserSettings.get("user_settings", "twitch_spawn_amount")
	local var_532_3 = 100 * (Application.user_setting("twitch_spawn_amount") or var_532_2)

	return var_0_11(var_532_0, var_532_1, var_532_3), var_532_0, var_532_1, 0, "menu_settings_twitch_spawn_amount", 100 * var_532_2
end

OptionsView.cb_twitch_spawn_amount_saved_value = function (arg_533_0, arg_533_1)
	local var_533_0 = arg_533_1.content
	local var_533_1 = var_533_0.min
	local var_533_2 = var_533_0.max
	local var_533_3 = 100 * (arg_533_0:_get_setting("user_settings", "twitch_spawn_amount") or var_533_0.default_value)
	local var_533_4 = math.clamp(var_533_3, var_533_1, var_533_2)

	var_533_0.internal_value = var_0_11(var_533_1, var_533_2, var_533_4)
	var_533_0.value = var_533_4
end

OptionsView.cb_twitch_spawn_amount = function (arg_534_0, arg_534_1, arg_534_2, arg_534_3)
	arg_534_0.changed_user_settings.twitch_spawn_amount = 0.01 * arg_534_1.value
end
