-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_hero_power_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_hero_power_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.category_settings
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = false
local var_0_6 = 1

HeroWindowHeroPowerConsole = class(HeroWindowHeroPowerConsole)
HeroWindowHeroPowerConsole.NAME = "HeroWindowHeroPowerConsole"

HeroWindowHeroPowerConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowHeroPowerConsole")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
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
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._hero_power_loadout_selection = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_start_transition_animation("on_enter")
end

HeroWindowHeroPowerConsole._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_3, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

HeroWindowHeroPowerConsole.create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_4)

	if arg_3_2 then
		local var_3_3 = arg_3_0.ui_scenegraph.window.local_position

		var_3_3[1] = var_3_3[1] + arg_3_2[1]
		var_3_3[2] = var_3_3[2] + arg_3_2[2]
		var_3_3[3] = var_3_3[3] + arg_3_2[3]
	end
end

HeroWindowHeroPowerConsole.on_exit = function (arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate HeroWindowHeroPowerConsole")

	arg_4_0.ui_animator = nil
end

HeroWindowHeroPowerConsole.update = function (arg_5_0, arg_5_1, arg_5_2)
	if var_0_5 then
		var_0_5 = false

		arg_5_0:create_ui_elements()
	end

	arg_5_0:_update_loadout_sync()
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_update_hero_power_effect(arg_5_1)
	arg_5_0:draw(arg_5_1)
end

HeroWindowHeroPowerConsole.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	return
end

HeroWindowHeroPowerConsole._update_animations = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._ui_animations
	local var_7_1 = arg_7_0._animations
	local var_7_2 = arg_7_0.ui_animator

	for iter_7_0, iter_7_1 in pairs(arg_7_0._ui_animations) do
		UIAnimation.update(iter_7_1, arg_7_1)

		if UIAnimation.completed(iter_7_1) then
			arg_7_0._ui_animations[iter_7_0] = nil
		end
	end

	var_7_2:update(arg_7_1)

	for iter_7_2, iter_7_3 in pairs(var_7_1) do
		if var_7_2:is_animation_completed(iter_7_3) then
			var_7_2:stop_animation(iter_7_3)

			var_7_1[iter_7_2] = nil
		end
	end
end

HeroWindowHeroPowerConsole._is_button_pressed = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.content.button_hotspot

	if var_8_0.on_release then
		var_8_0.on_release = false

		return true
	end
end

HeroWindowHeroPowerConsole.set_focus = function (arg_9_0, arg_9_1)
	arg_9_0._focused = arg_9_1
end

HeroWindowHeroPowerConsole._update_loadout_sync = function (arg_10_0)
	local var_10_0 = arg_10_0.parent.loadout_sync_id

	if var_10_0 ~= arg_10_0._loadout_sync_id or arg_10_0:_has_hero_level_changed() then
		arg_10_0:_calculate_power_level()

		arg_10_0._loadout_sync_id = var_10_0
	end
end

HeroWindowHeroPowerConsole._has_hero_level_changed = function (arg_11_0)
	local var_11_0 = ExperienceSettings.get_experience(arg_11_0.hero_name)

	if ExperienceSettings.get_level(var_11_0) ~= arg_11_0._hero_level then
		return true
	end
end

HeroWindowHeroPowerConsole._calculate_power_level = function (arg_12_0)
	local var_12_0 = arg_12_0.hero_name
	local var_12_1 = arg_12_0.career_index
	local var_12_2 = FindProfileIndex(var_12_0)
	local var_12_3 = SPProfiles[var_12_2].careers[var_12_1].name
	local var_12_4 = BackendUtils.get_total_power_level(var_12_0, var_12_3)
	local var_12_5 = UIUtils.presentable_hero_power_level(var_12_4)
	local var_12_6 = arg_12_0._widgets_by_name.power_text.content
	local var_12_7 = Managers.backend:get_interface("items"):get_selected_career_loadout(var_12_3)

	if var_12_6.power and var_12_5 > var_12_6.power then
		arg_12_0._hero_power_effect_time = var_0_6

		local var_12_8 = arg_12_0._hero_power_loadout_selection[var_12_3]

		if not var_12_8 or var_12_7 == var_12_8 then
			arg_12_0:_play_sound("play_gui_equipment_power_level_increase")
		end
	end

	var_12_6.power = var_12_5
	var_12_6.text = tostring(var_12_5)
	arg_12_0._hero_power_loadout_selection[var_12_3] = var_12_7
end

local var_0_7 = Colors.get_color_table_with_alpha("white", 255)
local var_0_8 = Colors.get_color_table_with_alpha("font_title", 255)

HeroWindowHeroPowerConsole._update_hero_power_effect = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._hero_power_effect_time

	if var_13_0 then
		local var_13_1 = math.max(var_13_0 - arg_13_1, 0)
		local var_13_2 = 1 - var_13_1 / var_0_6
		local var_13_3 = math.easeOutCubic(var_13_2)
		local var_13_4 = math.ease_pulse(var_13_3)
		local var_13_5 = arg_13_0._widgets_by_name
		local var_13_6 = var_13_5.hero_power_tooltip.style.effect

		var_13_6.angle = math.degrees_to_radians(120 * var_13_3)
		var_13_6.color[1] = 255 * var_13_4

		local var_13_7 = var_13_5.power_text.style.text

		Colors.lerp_color_tables(var_0_7, var_0_8, var_13_4, var_13_7.text_color)

		if var_13_2 == 1 then
			arg_13_0._hero_power_effect_time = nil
		else
			arg_13_0._hero_power_effect_time = var_13_1
		end
	end
end

HeroWindowHeroPowerConsole._exit = function (arg_14_0)
	arg_14_0.exit = true
end

HeroWindowHeroPowerConsole.draw = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.ui_renderer
	local var_15_1 = arg_15_0.ui_top_renderer
	local var_15_2 = arg_15_0.ui_scenegraph
	local var_15_3 = arg_15_0.parent:window_input_service()

	UIRenderer.begin_pass(var_15_1, var_15_2, var_15_3, arg_15_1, nil, arg_15_0.render_settings)

	for iter_15_0, iter_15_1 in ipairs(arg_15_0._widgets) do
		UIRenderer.draw_widget(var_15_1, iter_15_1)
	end

	UIRenderer.end_pass(var_15_1)
end

HeroWindowHeroPowerConsole._play_sound = function (arg_16_0, arg_16_1)
	arg_16_0.parent:play_sound(arg_16_1)
end
