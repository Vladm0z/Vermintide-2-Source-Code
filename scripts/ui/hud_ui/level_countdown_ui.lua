-- chunkname: @scripts/ui/hud_ui/level_countdown_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/level_countdown_ui_definitions")
local var_0_1 = true

LevelCountdownUI = class(LevelCountdownUI)

LevelCountdownUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.network_event_delegate = arg_1_2.network_event_delegate
	arg_1_0.camera_manager = arg_1_2.camera_manager
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.is_in_inn = arg_1_2.is_in_inn
	arg_1_0.is_server = arg_1_2.is_server
	arg_1_0.world_manager = arg_1_2.world_manager
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.matchmaking_manager = Managers.matchmaking

	local var_1_0 = arg_1_0.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)

	arg_1_0:create_ui_elements()

	arg_1_0.colors = {
		normal = Colors.get_table("font_default"),
		selected = Colors.get_table("font_title")
	}
end

LevelCountdownUI.create_ui_elements = function (arg_2_0)
	var_0_1 = false
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0.countdown_widget = UIWidget.init(var_0_0.widgets.fullscreen_countdown)

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)
end

LevelCountdownUI.update = function (arg_3_0, arg_3_1)
	if var_0_1 then
		arg_3_0:create_ui_elements()

		arg_3_0.colors = {
			normal = Colors.get_table("font_default"),
			selected = Colors.get_table("font_title")
		}
	end

	if not arg_3_0.is_in_inn then
		return
	end

	if arg_3_0.ingame_ui.menu_suspended then
		return
	end

	local var_3_0 = false
	local var_3_1, var_3_2 = arg_3_0:_get_start_time()

	if var_3_1 and var_3_2 then
		if arg_3_0:update_enter_game_counter(var_3_1, var_3_2, arg_3_1) then
			var_3_0 = true

			arg_3_0:draw(arg_3_1)
		else
			arg_3_0.last_timer_value = var_3_2
		end
	end

	arg_3_0._countdown_active = var_3_0
end

LevelCountdownUI.is_enter_game = function (arg_4_0)
	return arg_4_0._countdown_active
end

LevelCountdownUI.draw = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.input_manager:get_service("ingame_menu")
	local var_5_1 = arg_5_0.ui_renderer

	UIRenderer.begin_pass(var_5_1, arg_5_0.ui_scenegraph, var_5_0, arg_5_1)
	UIRenderer.draw_widget(var_5_1, arg_5_0.countdown_widget)
	UIRenderer.end_pass(var_5_1)
end

LevelCountdownUI.update_enter_game_counter = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0.countdown_widget
	local var_6_1 = var_6_0.content
	local var_6_2 = var_6_0.style
	local var_6_3 = arg_6_0.colors
	local var_6_4 = math.round(arg_6_1)
	local var_6_5 = var_6_4 ~= arg_6_2
	local var_6_6

	if var_6_4 ~= arg_6_0.last_timer_value then
		if var_6_4 ~= 0 then
			var_6_6 = "Play_hud_matchmaking_countdown"
			var_6_1.timer_text = var_6_4
			arg_6_0.color_timer = 0
		else
			var_6_6 = "Play_hud_matchmaking_countdown_final"
			var_6_1.timer_text = ""
		end

		arg_6_0.last_timer_value = var_6_4

		Colors.lerp_color_tables(var_6_3.normal, var_6_3.selected, 0, var_6_2.timer_text.text_color)
	else
		local var_6_7 = arg_6_0.color_timer

		if var_6_7 then
			local var_6_8 = 0.5
			local var_6_9 = math.min(var_6_7 + arg_6_3, var_6_8)
			local var_6_10 = var_6_9 / var_6_8

			arg_6_0.color_timer = var_6_9

			Colors.lerp_color_tables(var_6_3.normal, var_6_3.selected, var_6_10, var_6_2.timer_text.text_color)
		end
	end

	if var_6_5 and var_6_6 then
		arg_6_0:play_sound(var_6_6)
	end

	if arg_6_1 <= 0 then
		arg_6_0.matchmaking_manager:countdown_completed()
	end

	return var_6_5
end

LevelCountdownUI.play_sound = function (arg_7_0, arg_7_1)
	WwiseWorld.trigger_event(arg_7_0.wwise_world, arg_7_1)
end

LevelCountdownUI._get_start_time = function (arg_8_0)
	local var_8_0 = arg_8_0:_get_active_waystone_extension()

	if var_8_0 then
		local var_8_1 = var_8_0:end_time()

		return var_8_0:end_time_left(), var_8_1
	end
end

LevelCountdownUI._get_active_waystone_extension = function (arg_9_0)
	if not Managers.state.entity then
		return
	end

	local var_9_0 = Managers.state.entity:get_entities("EndZoneExtension")

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if iter_9_1:activated() then
			return iter_9_1
		end
	end
end
