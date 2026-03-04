-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_options.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_options_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = false
local var_0_5 = 1

HeroWindowOptions = class(HeroWindowOptions)
HeroWindowOptions.NAME = "HeroWindowOptions"

function HeroWindowOptions.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowOptions")

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

	local var_1_6 = arg_1_0._widgets_by_name

	arg_1_0.button_widgets_by_news_template = {
		equipment = var_1_6.game_option_1,
		talent = var_1_6.game_option_2,
		cosmetics = var_1_6.game_option_4,
		loot_chest = var_1_6.game_option_5
	}
end

function HeroWindowOptions.create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_3)

	if arg_2_2 then
		local var_2_3 = arg_2_0.ui_scenegraph.window.local_position

		var_2_3[1] = var_2_3[1] + arg_2_2[1]
		var_2_3[2] = var_2_3[2] + arg_2_2[2]
		var_2_3[3] = var_2_3[3] + arg_2_2[3]
	end

	local var_2_4 = Managers.mechanism:current_mechanism_name()

	if script_data["eac-untrusted"] or not DamageUtils.is_in_inn or var_2_4 == "versus" then
		var_2_1.game_option_3.content.button_hotspot.disable_button = true
		var_2_1.game_option_5.content.button_hotspot.disable_button = true
	end
end

function HeroWindowOptions.on_exit(arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate HeroWindowOptions")

	arg_3_0.ui_animator = nil
end

function HeroWindowOptions.update(arg_4_0, arg_4_1, arg_4_2)
	if var_0_4 then
		var_0_4 = false

		arg_4_0:create_ui_elements()
	end

	arg_4_0:_sync_news(arg_4_1, arg_4_2)
	arg_4_0:_update_selected_option()
	arg_4_0:_update_loadout_sync()
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_update_hero_power_effect(arg_4_1)
	arg_4_0:draw(arg_4_1)
end

function HeroWindowOptions.post_update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
end

function HeroWindowOptions._update_animations(arg_6_0, arg_6_1)
	arg_6_0:_update_game_options_hover_effect(arg_6_1)

	local var_6_0 = arg_6_0._ui_animations
	local var_6_1 = arg_6_0._animations
	local var_6_2 = arg_6_0.ui_animator

	for iter_6_0, iter_6_1 in pairs(arg_6_0._ui_animations) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			arg_6_0._ui_animations[iter_6_0] = nil
		end
	end

	var_6_2:update(arg_6_1)

	for iter_6_2, iter_6_3 in pairs(var_6_1) do
		if var_6_2:is_animation_completed(iter_6_3) then
			var_6_2:stop_animation(iter_6_3)

			var_6_1[iter_6_2] = nil
		end
	end
end

function HeroWindowOptions._is_button_pressed(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		if not var_7_0.is_selected then
			return true
		end
	end
end

function HeroWindowOptions._is_stepper_button_pressed(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.content
	local var_8_1 = var_8_0.button_hotspot_left
	local var_8_2 = var_8_0.button_hotspot_right

	if var_8_1.on_release then
		var_8_1.on_release = false

		return true, -1
	elseif var_8_2.on_release then
		var_8_2.on_release = false

		return true, 1
	end
end

function HeroWindowOptions._is_button_hover_enter(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	return var_9_0.on_hover_enter and not var_9_0.is_selected
end

function HeroWindowOptions._is_button_hover_exit(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	return var_10_0.on_hover_exit and not var_10_0.is_selected
end

function HeroWindowOptions._is_button_selected(arg_11_0, arg_11_1)
	return arg_11_1.content.button_hotspot.is_selected
end

function HeroWindowOptions._handle_input(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._widgets_by_name
	local var_12_1 = Managers.input:is_device_active("gamepad")
	local var_12_2 = arg_12_0.parent:window_input_service()

	if arg_12_0:_is_button_pressed(var_12_0.game_option_1) then
		arg_12_0.parent:set_layout(1)
	elseif arg_12_0:_is_button_pressed(var_12_0.game_option_2) then
		arg_12_0.parent:set_layout(2)
	elseif arg_12_0:_is_button_pressed(var_12_0.game_option_3) then
		arg_12_0.parent:set_layout(3)
	elseif arg_12_0:_is_button_pressed(var_12_0.game_option_4) then
		arg_12_0.parent:set_layout(4)
	elseif arg_12_0:_is_button_pressed(var_12_0.game_option_5) then
		arg_12_0:_play_sound("play_gui_lobby_button_00_custom")
		arg_12_0.parent:requested_screen_change_by_name("loot")
	elseif var_12_1 then
		local var_12_3 = arg_12_0.parent:get_selected_game_mode_index()

		if var_12_2:get("move_up_raw") and var_12_3 > 1 then
			arg_12_0.parent:set_layout(var_12_3 - 1)
		elseif var_12_2:get("move_down_raw") and var_12_3 < 4 then
			arg_12_0.parent:set_layout(var_12_3 + 1)
		end
	end
end

function HeroWindowOptions._update_game_options_hover_effect(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._widgets_by_name
	local var_13_1 = "game_option_"

	for iter_13_0 = 1, 4 do
		local var_13_2 = var_13_0[var_13_1 .. iter_13_0]

		UIWidgetUtils.animate_option_button(var_13_2, arg_13_1)

		if arg_13_0:_is_button_hover_enter(var_13_2) then
			arg_13_0:_play_sound("play_gui_equipment_button_hover")
		end
	end

	UIWidgetUtils.animate_default_button(var_13_0.game_option_5, arg_13_1)

	if arg_13_0:_is_button_hover_enter(var_13_0.game_option_5) or arg_13_0:_is_button_hover_enter(var_13_0.hero_power_tooltip) then
		arg_13_0:_play_sound("play_gui_equipment_button_hover")
	end
end

function HeroWindowOptions._set_selected_option(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._widgets_by_name
	local var_14_1 = "game_option_"

	for iter_14_0 = 1, 4 do
		var_14_0[var_14_1 .. iter_14_0].content.button_hotspot.is_selected = arg_14_1 == iter_14_0
	end
end

function HeroWindowOptions._update_selected_option(arg_15_0)
	local var_15_0 = arg_15_0.parent:get_selected_game_mode_index()

	if var_15_0 ~= arg_15_0._selected_index then
		arg_15_0:_set_selected_option(var_15_0)

		arg_15_0._selected_index = var_15_0
	end
end

function HeroWindowOptions._update_loadout_sync(arg_16_0)
	local var_16_0 = arg_16_0.parent.loadout_sync_id

	if var_16_0 ~= arg_16_0._loadout_sync_id or arg_16_0:_has_hero_level_changed() then
		arg_16_0:_calculate_power_level()
		arg_16_0:_update_experience_presentation()
		arg_16_0:_update_hero_portrait_frame()

		arg_16_0._loadout_sync_id = var_16_0
	end
end

function HeroWindowOptions._has_hero_level_changed(arg_17_0)
	local var_17_0 = ExperienceSettings.get_experience(arg_17_0.hero_name)

	if ExperienceSettings.get_level(var_17_0) ~= arg_17_0._hero_level then
		return true
	end
end

function HeroWindowOptions._update_experience_presentation(arg_18_0)
	local var_18_0 = arg_18_0._widgets_by_name
	local var_18_1 = ExperienceSettings.get_experience(arg_18_0.hero_name)
	local var_18_2, var_18_3 = ExperienceSettings.get_level(var_18_1)
	local var_18_4 = ExperienceSettings.get_experience_pool(arg_18_0.hero_name)
	local var_18_5, var_18_6 = ExperienceSettings.get_extra_level(var_18_4)
	local var_18_7 = var_0_2.experience_bar.size
	local var_18_8 = arg_18_0.ui_scenegraph.experience_bar.size

	var_18_8[1] = math.ceil(var_18_7[1])

	if var_18_3 > 0 then
		var_18_8[1] = math.ceil(var_18_8[1] * var_18_3)
	elseif var_18_6 > 0 then
		var_18_8[1] = math.ceil(var_18_8[1] * var_18_6)
	end

	local var_18_9 = Localize("level") .. " " .. tostring(var_18_2)

	if var_18_5 and var_18_5 > 0 then
		var_18_9 = var_18_9 .. " (+" .. tostring(var_18_5) .. ")"
	end

	var_18_0.level_text.content.text = var_18_9
	arg_18_0._hero_level = var_18_2
end

function HeroWindowOptions._calculate_power_level(arg_19_0)
	local var_19_0 = arg_19_0.hero_name
	local var_19_1 = arg_19_0.career_index
	local var_19_2 = FindProfileIndex(var_19_0)
	local var_19_3 = SPProfiles[var_19_2].careers[var_19_1].name
	local var_19_4 = BackendUtils.get_total_power_level(var_19_0, var_19_3)
	local var_19_5 = UIUtils.presentable_hero_power_level(var_19_4)
	local var_19_6 = arg_19_0._widgets_by_name.power_text.content

	if var_19_6.power and var_19_5 > var_19_6.power then
		arg_19_0._hero_power_effect_time = var_0_5

		arg_19_0:_play_sound("play_gui_equipment_power_level_increase")
	end

	var_19_6.power = var_19_5
	var_19_6.text = tostring(var_19_5)
end

local var_0_6 = Colors.get_color_table_with_alpha("white", 255)
local var_0_7 = Colors.get_color_table_with_alpha("font_title", 255)

function HeroWindowOptions._update_hero_power_effect(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._hero_power_effect_time

	if var_20_0 then
		local var_20_1 = math.max(var_20_0 - arg_20_1, 0)
		local var_20_2 = 1 - var_20_1 / var_0_5
		local var_20_3 = math.easeOutCubic(var_20_2)
		local var_20_4 = math.ease_pulse(var_20_3)
		local var_20_5 = arg_20_0._widgets_by_name
		local var_20_6 = var_20_5.hero_power_tooltip.style.effect

		var_20_6.angle = math.degrees_to_radians(120 * var_20_3)
		var_20_6.color[1] = 255 * var_20_4

		local var_20_7 = var_20_5.power_text.style.text

		Colors.lerp_color_tables(var_0_6, var_0_7, var_20_4, var_20_7.text_color)

		if var_20_2 == 1 then
			arg_20_0._hero_power_effect_time = nil
		else
			arg_20_0._hero_power_effect_time = var_20_1
		end
	end
end

function HeroWindowOptions._update_hero_portrait_frame(arg_21_0)
	local var_21_0 = arg_21_0.career_index
	local var_21_1 = arg_21_0.profile_index
	local var_21_2 = SPProfiles[var_21_1]
	local var_21_3 = var_21_2.careers[var_21_0]
	local var_21_4 = var_21_3.portrait_image
	local var_21_5 = var_21_3.display_name
	local var_21_6 = var_21_2.character_name
	local var_21_7 = arg_21_0._widgets_by_name

	var_21_7.hero_name.content.text = var_21_6
	var_21_7.career_name.content.text = var_21_5

	local var_21_8 = arg_21_0._hero_level and tostring(arg_21_0._hero_level) or "-"
	local var_21_9 = arg_21_0:_get_portrait_frame()

	arg_21_0._portrait_widget = arg_21_0:_create_portrait_frame_widget(var_21_9, var_21_4, var_21_8)
end

function HeroWindowOptions.draw(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.ui_renderer
	local var_22_1 = arg_22_0.ui_scenegraph
	local var_22_2 = arg_22_0.parent:window_input_service()

	UIRenderer.begin_pass(var_22_0, var_22_1, var_22_2, arg_22_1, nil, arg_22_0.render_settings)

	for iter_22_0, iter_22_1 in ipairs(arg_22_0._widgets) do
		UIRenderer.draw_widget(var_22_0, iter_22_1)
	end

	if arg_22_0._portrait_widget then
		UIRenderer.draw_widget(var_22_0, arg_22_0._portrait_widget)
	end

	local var_22_3 = arg_22_0._active_node_widgets

	if var_22_3 then
		for iter_22_2, iter_22_3 in ipairs(var_22_3) do
			UIRenderer.draw_widget(var_22_0, iter_22_3)
		end
	end

	UIRenderer.end_pass(var_22_0)
end

function HeroWindowOptions._play_sound(arg_23_0, arg_23_1)
	arg_23_0.parent:play_sound(arg_23_1)
end

function HeroWindowOptions._create_portrait_frame_widget(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = UIWidgets.create_portrait_frame("portrait_root", arg_24_1, arg_24_3, 1, nil, arg_24_2)
	local var_24_1 = UIWidget.init(var_24_0, arg_24_0.ui_renderer)

	var_24_1.content.frame_settings_name = arg_24_1

	return var_24_1
end

function HeroWindowOptions._get_portrait_frame(arg_25_0)
	local var_25_0 = arg_25_0.profile_index
	local var_25_1 = arg_25_0.career_index
	local var_25_2 = arg_25_0.hero_name
	local var_25_3 = SPProfiles[var_25_0].careers[var_25_1].name
	local var_25_4 = "default"
	local var_25_5 = BackendUtils.get_loadout_item(var_25_3, "slot_frame")

	var_25_4 = var_25_5 and var_25_5.data.temporary_template or var_25_4

	return var_25_4
end

function HeroWindowOptions._create_style_animation_enter(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	local var_26_0 = arg_26_0._ui_animations
	local var_26_1 = "game_option_" .. arg_26_3
	local var_26_2 = arg_26_1.style[arg_26_3]
	local var_26_3 = var_26_2.color[1]
	local var_26_4 = arg_26_2
	local var_26_5 = 0.2
	local var_26_6 = (1 - var_26_3 / var_26_4) * var_26_5

	if var_26_6 > 0 and not arg_26_5 then
		var_26_0[var_26_1 .. "_hover_" .. arg_26_4] = arg_26_0:_animate_element_by_time(var_26_2.color, 1, var_26_3, var_26_4, var_26_6)
	else
		var_26_2.color[1] = var_26_4
	end
end

function HeroWindowOptions._create_style_animation_exit(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
	local var_27_0 = arg_27_0._ui_animations
	local var_27_1 = "game_option_" .. arg_27_3
	local var_27_2 = arg_27_1.style[arg_27_3]
	local var_27_3 = var_27_2.color[1]
	local var_27_4 = arg_27_2
	local var_27_5 = 0.2
	local var_27_6 = var_27_3 / 255 * var_27_5

	if var_27_6 > 0 and not arg_27_5 then
		var_27_0[var_27_1 .. "_hover_" .. arg_27_4] = arg_27_0:_animate_element_by_time(var_27_2.color, 1, var_27_3, var_27_4, var_27_6)
	else
		var_27_2.color[1] = var_27_4
	end
end

function HeroWindowOptions._animate_element_by_time(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, math.ease_out_quad))
end

function HeroWindowOptions._animate_element_by_catmullrom(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8))
end

function HeroWindowOptions._sync_news(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._sync_delay

	if var_30_0 then
		local var_30_1 = math.max(0, var_30_0 - arg_30_1)

		if var_30_1 == 0 then
			arg_30_0._sync_delay = nil
		else
			arg_30_0._sync_delay = var_30_1
		end

		return
	end

	local var_30_2 = Managers.player:local_player(1)

	if var_30_2 and var_30_2.player_unit then
		local var_30_3 = NewsFeedTemplates
		local var_30_4 = arg_30_0.conditions_params
		local var_30_5 = arg_30_0.button_widgets_by_news_template

		for iter_30_0, iter_30_1 in pairs(var_30_5) do
			local var_30_6 = var_30_3[FindNewsTemplateIndex(iter_30_0)].condition_func

			iter_30_1.content.new = var_30_6(var_30_4)
		end
	end

	arg_30_0._sync_delay = 4
end
