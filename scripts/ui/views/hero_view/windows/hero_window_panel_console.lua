-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_panel_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_panel_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.title_button_definitions
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.create_bot_warning
local var_0_6 = var_0_0.create_bot_cusomization_button
local var_0_7 = {
	"equipment",
	"talents",
	"forge",
	"cosmetics",
	"pactsworn_equipment",
	"system"
}
local var_0_8 = {}

for iter_0_0, iter_0_1 in ipairs(var_0_7) do
	var_0_8[iter_0_1] = iter_0_0
end

local var_0_9 = "cycle_next"
local var_0_10 = "cycle_previous"
local var_0_11 = "show_gamercard"
local var_0_12 = false

HeroWindowPanelConsole = class(HeroWindowPanelConsole)
HeroWindowPanelConsole.NAME = "HeroWindowPanelConsole"

function HeroWindowPanelConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowPanelConsole")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.is_in_inn = var_1_0.is_in_inn or false
	arg_1_0.force_ingame_menu = arg_1_1.force_ingame_menu
	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.profile_index = arg_1_1.profile_index

	local var_1_2 = arg_1_0.hero_name
	local var_1_3 = arg_1_0.career_index
	local var_1_4 = FindProfileIndex(var_1_2)
	local var_1_5 = SPProfiles[var_1_4].careers[var_1_3].name

	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.conditions_params = {
		hero_name = arg_1_0.hero_name,
		career_name = var_1_5,
		rarities_to_ignore = table.enum_safe("magic")
	}

	local var_1_6 = arg_1_0._title_button_widgets

	arg_1_0.button_widgets_by_news_template = {
		equipment = var_1_6[1],
		talent = var_1_6[2],
		cosmetics = var_1_6[4]
	}

	if arg_1_0.is_in_inn and not arg_1_0.force_ingame_menu then
		arg_1_0:_setup_text_buttons_width()
		arg_1_0:_setup_input_buttons()
	else
		local var_1_7 = arg_1_0._widgets_by_name.system_button

		var_1_7.content.button_hotspot.is_selected = true

		if IS_WINDOWS or not arg_1_0.is_in_inn then
			var_1_7.content.visible = false
		end
	end

	arg_1_0:_validate_product_owner()
end

function HeroWindowPanelConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0.render_settings,
		ui_scenegraph = arg_2_0.ui_scenegraph
	}
	local var_2_1 = arg_2_0._widgets_by_name
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_3, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function HeroWindowPanelConsole.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	local var_3_3 = UIWidget.init(var_0_6(arg_3_0.ui_renderer))

	var_3_0[#var_3_0 + 1] = var_3_3
	var_3_1.bot_customization_button = var_3_3
	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	local var_3_4 = {}

	for iter_3_2, iter_3_3 in pairs(var_0_2) do
		local var_3_5 = UIWidget.init(iter_3_3)

		var_3_4[#var_3_4 + 1] = var_3_5
	end

	assert(var_3_4[3].content.text_field == "hero_window_crafting")

	var_3_4[3].content.button_hotspot.disable_button = script_data["eac-untrusted"]

	for iter_3_4 = 1, #var_3_4 do
		var_3_4[iter_3_4].content.button_hotspot.disable_button = not arg_3_0.parent:can_add(var_0_7[iter_3_4])
	end

	arg_3_0._title_button_widgets = var_3_4

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_4)

	if arg_3_2 then
		local var_3_6 = arg_3_0.ui_scenegraph.window.local_position

		var_3_6[1] = var_3_6[1] + arg_3_2[1]
		var_3_6[2] = var_3_6[2] + arg_3_2[2]
		var_3_6[3] = var_3_6[3] + arg_3_2[3]
	end

	arg_3_0._widgets_by_name.bot_customization_button.content.visible = not arg_3_0.force_ingame_menu and arg_3_0.is_in_inn
end

function HeroWindowPanelConsole.on_exit(arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate HeroWindowPanelConsole")

	arg_4_0.ui_animator = nil
end

function HeroWindowPanelConsole.update(arg_5_0, arg_5_1, arg_5_2)
	if var_0_12 then
		var_0_12 = false

		arg_5_0:create_ui_elements()
	end

	arg_5_0:_handle_gamepad_activity()
	arg_5_0:_handle_back_button_visibility()
	arg_5_0:_handle_bot_warning()

	if arg_5_0.is_in_inn and not arg_5_0.force_ingame_menu then
		arg_5_0:_sync_news(arg_5_1, arg_5_2)
		arg_5_0:_update_selected_option()
	end

	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:draw(arg_5_1)
end

function HeroWindowPanelConsole.post_update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
end

function HeroWindowPanelConsole._handle_bot_warning(arg_7_0)
	if arg_7_0.parent:is_bot_career() then
		local var_7_0, var_7_1 = arg_7_0.parent:get_career_data()

		if var_7_0 ~= arg_7_0._current_profile_index or var_7_1 ~= arg_7_0._current_career_index then
			arg_7_0:_set_bot_information(var_7_0, var_7_1)

			arg_7_0._current_profile_index = var_7_0
			arg_7_0._current_career_index = var_7_1

			arg_7_0:_start_transition_animation("bot_info_enter")
		end
	elseif arg_7_0._current_profile_index or arg_7_0._current_career_index then
		arg_7_0:_start_transition_animation("bot_info_exit")

		local var_7_2 = arg_7_0._widgets_by_name.bot_customization_button

		var_7_2.content.managing_career_name = ""
		var_7_2.content.playing_career_name = ""
		arg_7_0._current_profile_index = nil
		arg_7_0._current_career_index = nil
	end
end

function HeroWindowPanelConsole._set_bot_information(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = Managers.player:local_player()
	local var_8_1 = var_8_0:profile_index()
	local var_8_2 = var_8_0:career_index()
	local var_8_3 = SPProfiles[var_8_1].careers[var_8_2].display_name
	local var_8_4 = SPProfiles[arg_8_1].careers[arg_8_2].display_name
	local var_8_5 = arg_8_0._widgets_by_name.bot_customization_button

	var_8_5.content.managing_career_name = Localize(var_8_4)
	var_8_5.content.playing_career_name = Localize(var_8_3)
end

function HeroWindowPanelConsole._update_animations(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._ui_animations
	local var_9_1 = arg_9_0._animations
	local var_9_2 = arg_9_0.ui_animator

	for iter_9_0, iter_9_1 in pairs(arg_9_0._ui_animations) do
		UIAnimation.update(iter_9_1, arg_9_1)

		if UIAnimation.completed(iter_9_1) then
			arg_9_0._ui_animations[iter_9_0] = nil
		end
	end

	var_9_2:update(arg_9_1)

	for iter_9_2, iter_9_3 in pairs(var_9_1) do
		if var_9_2:is_animation_completed(iter_9_3) then
			var_9_2:stop_animation(iter_9_3)

			var_9_1[iter_9_2] = nil
		end
	end

	local var_9_3 = arg_9_0._title_button_widgets

	for iter_9_4, iter_9_5 in ipairs(var_9_3) do
		arg_9_0:_animate_title_entry(iter_9_5, arg_9_1)
	end

	arg_9_0:_animate_title_entry(arg_9_0._widgets_by_name.system_button, arg_9_1)
	arg_9_0:_animate_title_entry(arg_9_0._widgets_by_name.bot_customization_button, arg_9_1)
	arg_9_0:_animate_back_button(arg_9_0._widgets_by_name.back_button, arg_9_1)
	arg_9_0:_animate_back_button(arg_9_0._widgets_by_name.close_button, arg_9_1)

	if arg_9_0._present_purchase_add then
		arg_9_0:_animate_purchase_add(arg_9_1)
	end
end

function HeroWindowPanelConsole._is_button_pressed(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content
	local var_10_1 = var_10_0.button_hotspot or var_10_0.button_text

	if var_10_1.on_release then
		var_10_1.on_release = false

		return true
	end
end

function HeroWindowPanelConsole._is_stepper_button_pressed(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content
	local var_11_1 = var_11_0.button_hotspot_left
	local var_11_2 = var_11_0.button_hotspot_right

	if var_11_1.on_release then
		var_11_1.on_release = false

		return true, -1
	elseif var_11_2.on_release then
		var_11_2.on_release = false

		return true, 1
	end
end

function HeroWindowPanelConsole._is_button_hover_enter(arg_12_0, arg_12_1)
	return arg_12_1.content.button_hotspot.on_hover_enter
end

function HeroWindowPanelConsole._is_button_hover_exit(arg_13_0, arg_13_1)
	return arg_13_1.content.button_hotspot.on_hover_exit
end

function HeroWindowPanelConsole._is_button_selected(arg_14_0, arg_14_1)
	return arg_14_1.content.button_hotspot.is_selected
end

function HeroWindowPanelConsole._handle_input(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.parent
	local var_15_1 = arg_15_0._widgets_by_name
	local var_15_2 = arg_15_0._title_button_widgets
	local var_15_3 = arg_15_0.parent:window_input_service()
	local var_15_4 = false
	local var_15_5 = var_15_1.close_button
	local var_15_6 = var_15_1.back_button

	if arg_15_0:_is_button_hover_enter(var_15_6) or arg_15_0:_is_button_hover_enter(var_15_5) then
		arg_15_0:_play_sound("Play_hud_hover")
	end

	if not var_15_4 and arg_15_0:_is_button_pressed(var_15_5) then
		var_15_0:close_menu()

		var_15_4 = true
	end

	if not arg_15_0.force_ingame_menu and not var_15_0:close_on_exit() and not var_15_4 and arg_15_0:_is_button_pressed(var_15_6) then
		local var_15_7 = var_15_0:get_previous_selected_game_mode_index()

		if var_15_7 then
			arg_15_0:_reset_back_button()
			arg_15_0.parent:set_layout(var_15_7)

			var_15_4 = true
		end
	end

	if arg_15_0.is_in_inn and not arg_15_0.force_ingame_menu then
		local var_15_8 = arg_15_0._title_button_widgets

		for iter_15_0, iter_15_1 in ipairs(var_15_8) do
			if arg_15_0:_is_button_hover_enter(iter_15_1) then
				arg_15_0:_play_sound("Play_hud_hover")
			end

			if arg_15_0:_is_button_pressed(iter_15_1) then
				arg_15_0:_on_panel_button_selected(iter_15_0)

				var_15_4 = true
			end
		end

		local var_15_9 = var_15_1.system_button

		if arg_15_0:_is_button_hover_enter(var_15_9) then
			arg_15_0:_play_sound("Play_hud_hover")
		end

		if not var_15_4 and arg_15_0:_is_button_pressed(var_15_9) then
			local var_15_10 = var_0_8.system

			arg_15_0:_on_panel_button_selected(var_15_10)

			var_15_4 = true
		end

		if not var_15_4 and not arg_15_0.parent.parent:input_blocked() then
			local var_15_11 = arg_15_0._selected_index or 1
			local var_15_12 = #var_0_7
			local var_15_13

			if var_15_3:get(var_0_10) then
				for iter_15_2 = #var_0_7, 1, -1 do
					if iter_15_2 == var_15_11 then
						var_15_13 = var_15_11 > 1 and var_15_11 - 1 or var_15_12

						if arg_15_0.parent:can_add(var_0_7[var_15_13]) then
							break
						else
							var_15_11 = var_15_13
						end
					end
				end

				arg_15_0:_on_panel_button_selected(var_15_13)
			elseif var_15_3:get(var_0_9) then
				for iter_15_3 = 1, #var_0_7 do
					if iter_15_3 == var_15_11 then
						var_15_13 = 1 + var_15_11 % var_15_12

						if arg_15_0.parent:can_add(var_0_7[var_15_13]) then
							break
						else
							var_15_11 = var_15_13
						end
					end
				end

				arg_15_0:_on_panel_button_selected(var_15_13)
			end
		end

		if not var_15_4 and arg_15_0._present_purchase_add and var_15_3:get(var_0_11) and IS_XB1 then
			local var_15_14 = true

			arg_15_0:_open_marketplace_xb1()
		end

		local var_15_15 = var_15_1.bot_customization_button

		if UIUtils.is_button_hover_enter(var_15_15) then
			arg_15_0:_play_sound("Play_hud_hover")
		end

		if UIUtils.is_button_pressed(var_15_15) or var_15_3:get("show_gamercard") then
			arg_15_0.parent:set_layout_by_name("character_selection")
		end
	end
end

function HeroWindowPanelConsole._on_panel_button_selected(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.parent:get_layout_name()
	local var_16_1 = var_0_7[arg_16_1]

	if var_16_1 ~= var_16_0 then
		local var_16_2 = var_0_7[arg_16_0._selected_index]

		arg_16_0.parent:window_layout_on_exit(var_16_2)
		arg_16_0.parent:set_layout_by_name(var_16_1)
	end
end

function HeroWindowPanelConsole._set_selected_option(arg_17_0, arg_17_1)
	arg_17_0._widgets_by_name.system_button.content.button_hotspot.is_selected = var_0_7[arg_17_1] == "system"

	local var_17_0 = arg_17_0._title_button_widgets

	for iter_17_0, iter_17_1 in ipairs(var_17_0) do
		iter_17_1.content.button_hotspot.is_selected = iter_17_0 == arg_17_1
	end
end

function HeroWindowPanelConsole._update_selected_option(arg_18_0)
	local var_18_0 = arg_18_0.parent:get_layout_name()
	local var_18_1 = table.find(var_0_7, var_18_0)

	if var_18_1 and var_18_1 ~= arg_18_0._selected_index then
		arg_18_0:_set_selected_option(var_18_1)

		arg_18_0._selected_index = var_18_1
	end

	local var_18_2 = arg_18_0._widgets_by_name.bot_customization_button

	var_18_2.content.button_hotspot.is_selected = var_18_0 == "character_selection"
	var_18_2.content.button_hotspot.hover_progress = var_18_2.content.button_hotspot.is_selected and 1 or var_18_2.content.button_hotspot.hover_progress
end

function HeroWindowPanelConsole.draw(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.ui_renderer
	local var_19_1 = arg_19_0.ui_scenegraph
	local var_19_2 = arg_19_0.parent:window_input_service()

	UIRenderer.begin_pass(var_19_0, var_19_1, var_19_2, arg_19_1, nil, arg_19_0.render_settings)

	for iter_19_0, iter_19_1 in ipairs(arg_19_0._widgets) do
		UIRenderer.draw_widget(var_19_0, iter_19_1)
	end

	if arg_19_0.is_in_inn and not arg_19_0.force_ingame_menu then
		for iter_19_2, iter_19_3 in ipairs(arg_19_0._title_button_widgets) do
			UIRenderer.draw_widget(var_19_0, iter_19_3)
		end
	end

	if arg_19_0._bot_warning_widget then
		UIRenderer.draw_widget(var_19_0, arg_19_0._bot_warning_widget)
	end

	UIRenderer.end_pass(var_19_0)
end

function HeroWindowPanelConsole._play_sound(arg_20_0, arg_20_1)
	arg_20_0.parent:play_sound(arg_20_1)
end

function HeroWindowPanelConsole._sync_news(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._sync_delay

	if var_21_0 then
		local var_21_1 = math.max(0, var_21_0 - arg_21_1)

		if var_21_1 == 0 then
			arg_21_0._sync_delay = nil
		else
			arg_21_0._sync_delay = var_21_1
		end

		return
	end

	local var_21_2 = Managers.player:local_player(1).player_unit
	local var_21_3 = NewsFeedTemplates
	local var_21_4 = arg_21_0.conditions_params
	local var_21_5 = arg_21_0.button_widgets_by_news_template

	if var_21_2 then
		for iter_21_0, iter_21_1 in pairs(var_21_5) do
			local var_21_6 = var_21_3[FindNewsTemplateIndex(iter_21_0)].condition_func

			iter_21_1.content.new = var_21_6(var_21_4)
		end
	end

	arg_21_0._sync_delay = 4
end

function HeroWindowPanelConsole._setup_input_buttons(arg_22_0)
	if arg_22_0.parent:input_blocked() then
		return
	end

	local var_22_0 = arg_22_0.parent:window_input_service()
	local var_22_1 = UISettings.get_gamepad_input_texture_data(var_22_0, var_0_10, true)
	local var_22_2 = UISettings.get_gamepad_input_texture_data(var_22_0, var_0_9, true)
	local var_22_3 = arg_22_0._widgets_by_name
	local var_22_4 = var_22_3.panel_input_area_1
	local var_22_5 = var_22_3.panel_input_area_2
	local var_22_6 = var_22_4.style.texture_id

	var_22_6.horizontal_alignment = "center"
	var_22_6.vertical_alignment = "center"
	var_22_6.texture_size = {
		var_22_1.size[1],
		var_22_1.size[2]
	}
	var_22_4.content.texture_id = var_22_1.texture

	local var_22_7 = var_22_5.style.texture_id

	var_22_7.horizontal_alignment = "center"
	var_22_7.vertical_alignment = "center"
	var_22_7.texture_size = {
		var_22_2.size[1],
		var_22_2.size[2]
	}
	var_22_5.content.texture_id = var_22_2.texture
end

function HeroWindowPanelConsole._handle_back_button_visibility(arg_23_0)
	if not arg_23_0.gamepad_active_last_frame then
		local var_23_0 = arg_23_0.parent:close_on_exit()
		local var_23_1 = arg_23_0._widgets_by_name.back_button
		local var_23_2 = not var_23_0

		var_23_1.content.visible = var_23_2
	end
end

function HeroWindowPanelConsole._reset_back_button(arg_24_0)
	local var_24_0 = arg_24_0._widgets_by_name.back_button.content.button_hotspot

	table.clear(var_24_0)
end

function HeroWindowPanelConsole._handle_gamepad_activity(arg_25_0)
	local var_25_0 = Managers.input:is_device_active("gamepad")
	local var_25_1 = Managers.input:get_most_recent_device()
	local var_25_2 = arg_25_0.gamepad_active_last_frame == nil or var_25_0 and var_25_1 ~= arg_25_0._most_recent_device

	if var_25_0 then
		if not arg_25_0.gamepad_active_last_frame or var_25_2 then
			arg_25_0.gamepad_active_last_frame = true

			local var_25_3 = arg_25_0._widgets_by_name
			local var_25_4 = arg_25_0.is_in_inn and not arg_25_0.force_ingame_menu or false

			var_25_3.panel_input_area_1.content.visible = var_25_4
			var_25_3.panel_input_area_2.content.visible = var_25_4
			var_25_3.back_button.content.visible = false
			var_25_3.close_button.content.visible = false

			arg_25_0:_setup_input_buttons()
		end
	elseif arg_25_0.gamepad_active_last_frame or var_25_2 then
		arg_25_0.gamepad_active_last_frame = false

		local var_25_5 = arg_25_0._widgets_by_name

		var_25_5.panel_input_area_1.content.visible = false
		var_25_5.panel_input_area_2.content.visible = false
		var_25_5.close_button.content.visible = true
	end

	arg_25_0._most_recent_device = var_25_1
end

function HeroWindowPanelConsole._setup_text_buttons_width(arg_26_0)
	local var_26_0 = arg_26_0.ui_scenegraph.panel_entry_area.size[1]
	local var_26_1 = 0
	local var_26_2 = arg_26_0._title_button_widgets
	local var_26_3 = #var_26_2
	local var_26_4 = math.floor(var_26_0 / var_26_3)

	for iter_26_0, iter_26_1 in ipairs(var_26_2) do
		arg_26_0:_set_text_button_size(iter_26_1, var_26_4)

		local var_26_5 = var_26_4 * (iter_26_0 - 1)

		arg_26_0:_set_text_button_horizontal_position(iter_26_1, var_26_5)
	end
end

function HeroWindowPanelConsole._set_text_button_size(arg_27_0, arg_27_1, arg_27_2)
	arg_27_0.ui_scenegraph[arg_27_1.scenegraph_id].size[1] = arg_27_2

	local var_27_0 = arg_27_1.style

	var_27_0.selected_texture.texture_size[1] = arg_27_2

	local var_27_1 = 5
	local var_27_2 = arg_27_2 - var_27_1 * 2

	var_27_0.text.size[1] = var_27_2
	var_27_0.text_shadow.size[1] = var_27_2
	var_27_0.text_hover.size[1] = var_27_2
	var_27_0.text_disabled.size[1] = var_27_2
	var_27_0.text.offset[1] = var_27_0.text.default_offset[1] + var_27_1
	var_27_0.text_shadow.offset[1] = var_27_0.text_shadow.default_offset[1] + var_27_1
	var_27_0.text_hover.offset[1] = var_27_0.text_hover.default_offset[1] + var_27_1
	var_27_0.text_disabled.offset[1] = var_27_0.text_disabled.default_offset[1] + var_27_1
end

local var_0_13 = Colors.get_color_table_with_alpha("white", 255)

function HeroWindowPanelConsole._animate_purchase_add(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._widgets_by_name.preorder_text.style
	local var_28_1 = 0.5 + math.sin(Managers.time:time("ui") * 3) * 0.5
	local var_28_2 = math.easeOutCubic(var_28_1) * 10
	local var_28_3 = var_28_0.text.text_color
	local var_28_4 = var_28_0.text_shadow.text_color
	local var_28_5 = math.easeOutCubic(var_28_1) * 0.5

	var_28_3[2] = var_0_13[2] * 0.5 + var_0_13[2] * var_28_5
	var_28_3[3] = var_0_13[3] * 0.5 + var_0_13[3] * var_28_5
	var_28_3[4] = var_0_13[4] * 0.5 + var_0_13[4] * var_28_5
end

function HeroWindowPanelConsole._set_text_button_horizontal_position(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0.ui_scenegraph[arg_29_1.scenegraph_id].local_position[1] = arg_29_2
end

function HeroWindowPanelConsole._validate_product_owner(arg_30_0)
	local var_30_0

	if IS_XB1 and script_data.settings.use_beta_mode then
		var_30_0 = not Managers.unlock:is_dlc_unlocked("vt2")
	else
		var_30_0 = false
	end

	arg_30_0._present_purchase_add = var_30_0

	arg_30_0:_set_purchase_add_visibility(var_30_0)
end

function HeroWindowPanelConsole._open_marketplace_xb1(arg_31_0)
	local var_31_0 = Managers.account:user_id()
	local var_31_1 = "dc4149cc-19c1-4a90-885f-6883868b053a"

	XboxLive.show_product_details(var_31_0, var_31_1)
end

function HeroWindowPanelConsole._set_purchase_add_visibility(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._widgets_by_name

	var_32_0.preorder_text.content.visible = arg_32_1
	var_32_0.preorder_input.content.visible = arg_32_1
	var_32_0.preorder_text_bg.content.visible = arg_32_1
	var_32_0.preorder_divider.content.visible = arg_32_1
	var_32_0.preorder_divider_top.content.visible = arg_32_1
	var_32_0.preorder_divider_effect.content.visible = arg_32_1
	var_32_0.preorder_divider_top_effect.content.visible = arg_32_1
end

function HeroWindowPanelConsole._animate_title_entry(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_1.content
	local var_33_1 = arg_33_1.style
	local var_33_2 = var_33_0.button_hotspot
	local var_33_3 = var_33_2.is_hover
	local var_33_4 = var_33_2.is_selected
	local var_33_5 = not var_33_4 and var_33_2.is_clicked and var_33_2.is_clicked == 0
	local var_33_6 = var_33_2.input_progress or 0
	local var_33_7 = var_33_2.hover_progress or 0
	local var_33_8 = var_33_2.selection_progress or 0
	local var_33_9 = 8
	local var_33_10 = 20

	if var_33_5 then
		var_33_6 = math.min(var_33_6 + arg_33_2 * var_33_10, 1)
	else
		var_33_6 = math.max(var_33_6 - arg_33_2 * var_33_10, 0)
	end

	local var_33_11 = math.easeOutCubic(var_33_6)
	local var_33_12 = math.easeInCubic(var_33_6)

	if var_33_3 then
		var_33_7 = math.min(var_33_7 + arg_33_2 * var_33_9, 1)
	else
		var_33_7 = math.max(var_33_7 - arg_33_2 * var_33_9, 0)
	end

	local var_33_13 = math.easeOutCubic(var_33_7)
	local var_33_14 = math.easeInCubic(var_33_7)

	if var_33_4 then
		var_33_8 = math.min(var_33_8 + arg_33_2 * var_33_9, 1)
	else
		var_33_8 = math.max(var_33_8 - arg_33_2 * var_33_9, 0)
	end

	local var_33_15 = math.easeOutCubic(var_33_8)
	local var_33_16 = math.easeInCubic(var_33_8)
	local var_33_17 = math.max(var_33_7, var_33_8)
	local var_33_18 = math.max(var_33_15, var_33_13)
	local var_33_19 = math.max(var_33_14, var_33_16)
	local var_33_20 = 255 * var_33_17

	var_33_1.selected_texture.color[1] = var_33_20

	if var_33_1.text then
		local var_33_21 = 4 * var_33_17

		var_33_1.text.offset[2] = 5 - var_33_21
		var_33_1.text_shadow.offset[2] = 3 - var_33_21
		var_33_1.text_hover.offset[2] = 5 - var_33_21
		var_33_1.text_disabled.offset[2] = 5 - var_33_21
	end

	if var_33_1.new_marker then
		local var_33_22 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

		var_33_1.new_marker.color[1] = 100 + 155 * var_33_22
	end

	var_33_2.hover_progress = var_33_7
	var_33_2.input_progress = var_33_6
	var_33_2.selection_progress = var_33_8
end

function HeroWindowPanelConsole._animate_back_button(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_1.content
	local var_34_1 = arg_34_1.style
	local var_34_2 = var_34_0.button_hotspot
	local var_34_3 = var_34_2.is_hover
	local var_34_4 = var_34_2.is_selected
	local var_34_5 = not var_34_4 and var_34_2.is_clicked and var_34_2.is_clicked == 0
	local var_34_6 = var_34_2.input_progress or 0
	local var_34_7 = var_34_2.hover_progress or 0
	local var_34_8 = var_34_2.selection_progress or 0
	local var_34_9 = 8
	local var_34_10 = 20

	if var_34_5 then
		var_34_6 = math.min(var_34_6 + arg_34_2 * var_34_10, 1)
	else
		var_34_6 = math.max(var_34_6 - arg_34_2 * var_34_10, 0)
	end

	local var_34_11 = math.easeOutCubic(var_34_6)
	local var_34_12 = math.easeInCubic(var_34_6)

	if var_34_3 then
		var_34_7 = math.min(var_34_7 + arg_34_2 * var_34_9, 1)
	else
		var_34_7 = math.max(var_34_7 - arg_34_2 * var_34_9, 0)
	end

	local var_34_13 = math.easeOutCubic(var_34_7)
	local var_34_14 = math.easeInCubic(var_34_7)

	if var_34_4 then
		var_34_8 = math.min(var_34_8 + arg_34_2 * var_34_9, 1)
	else
		var_34_8 = math.max(var_34_8 - arg_34_2 * var_34_9, 0)
	end

	local var_34_15 = math.easeOutCubic(var_34_8)
	local var_34_16 = math.easeInCubic(var_34_8)
	local var_34_17 = math.max(var_34_7, var_34_8)
	local var_34_18 = math.max(var_34_15, var_34_13)
	local var_34_19 = math.max(var_34_14, var_34_16)
	local var_34_20 = 255 * var_34_17

	var_34_1.texture_id.color[1] = 255 - var_34_20
	var_34_1.texture_hover_id.color[1] = var_34_20
	var_34_1.selected_texture.color[1] = var_34_20
	var_34_2.hover_progress = var_34_7
	var_34_2.input_progress = var_34_6
	var_34_2.selection_progress = var_34_8
end
