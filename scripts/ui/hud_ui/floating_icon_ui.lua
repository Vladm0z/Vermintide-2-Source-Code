-- chunkname: @scripts/ui/hud_ui/floating_icon_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/floating_icon_ui_definitions")
local var_0_1 = var_0_0.animation_definitions
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.scenegraph_definition

FloatingIconUI = class(FloatingIconUI)

FloatingIconUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.world_manager = arg_1_2.world_manager
	arg_1_0.camera_manager = arg_1_2.camera_manager
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.peer_id = arg_1_2.peer_id

	local var_1_0 = arg_1_0.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0._animations = {}
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:create_ui_elements()
	Managers.state.event:register(arg_1_0, "start_progression_zone", "show_progression_bar")
	Managers.state.event:register(arg_1_0, "stop_progression_zone", "hide_progression_bar")
end

local var_0_4 = true

FloatingIconUI.create_ui_elements = function (arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_2) do
		if iter_2_1 then
			local var_2_2 = UIWidget.init(iter_2_1)

			var_2_0[#var_2_0 + 1] = var_2_2
			var_2_1[iter_2_0] = var_2_2
		end
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	var_0_4 = false
end

FloatingIconUI.destroy = function (arg_3_0)
	arg_3_0.ui_animator = nil

	if Managers.state.event then
		Managers.state.event:unregister("start_progression_zone", arg_3_0)
		Managers.state.event:unregister("stop_progression_zone", arg_3_0)
	end
end

FloatingIconUI.show_progression_bar = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._progress_unit and arg_4_0._progress_unit == arg_4_1 then
		return
	end

	arg_4_0._progress_unit = arg_4_1
	arg_4_0._progress_extension = arg_4_2
end

FloatingIconUI.hide_progression_bar = function (arg_5_0, arg_5_1)
	if arg_5_0._progress_unit == arg_5_1 then
		arg_5_0._progress_unit = nil
		arg_5_0._progress_extension = nil
	end
end

FloatingIconUI.update = function (arg_6_0, arg_6_1)
	if var_0_4 then
		arg_6_0:create_ui_elements()
	end

	if arg_6_0._progress_unit then
		arg_6_0:_draw_progressbar(arg_6_1)
	end
end

FloatingIconUI._draw_progressbar = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.ui_renderer
	local var_7_1 = arg_7_0.ui_scenegraph
	local var_7_2 = arg_7_0.input_manager:get_service("ingame_menu")
	local var_7_3 = arg_7_0.render_settings

	UIRenderer.begin_pass(var_7_0, var_7_1, var_7_2, arg_7_1, nil, var_7_3)

	local var_7_4 = arg_7_0._progress_extension:progress_bar_personal() and arg_7_0._progress_extension:player_been_in_zone()
	local var_7_5 = arg_7_0._progress_extension:progress_bar_global() or var_7_4

	if var_7_4 or var_7_5 then
		local var_7_6 = arg_7_0._progress_extension:progress()

		if arg_7_0._progress_extension:should_progress_count_down() then
			var_7_6 = 1 - arg_7_0._progress_extension:progress()
		end

		arg_7_0:_draw(arg_7_0._progress_unit, var_7_6, arg_7_1)
	end

	UIRenderer.end_pass(var_7_0)
end

FloatingIconUI._get_camera = function (arg_8_0)
	local var_8_0 = "player_1"

	if arg_8_0.camera_manager:has_viewport(var_8_0) then
		local var_8_1 = "level_world"
		local var_8_2 = arg_8_0.world_manager

		if var_8_2:has_world(var_8_1) then
			local var_8_3 = var_8_2:world(var_8_1)
			local var_8_4 = ScriptWorld.viewport(var_8_3, var_8_0)

			return ScriptViewport.camera(var_8_4)
		end
	end
end

FloatingIconUI._get_player_rotation_and_position = function (arg_9_0)
	local var_9_0 = arg_9_0:get_player_first_person_extension()
	local var_9_1 = var_9_0:current_position()
	local var_9_2 = var_9_0:current_rotation()

	return var_9_1, var_9_2
end

FloatingIconUI._set_widget_position = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_1.offset

	var_10_0[1] = arg_10_2
	var_10_0[2] = arg_10_3
end

FloatingIconUI._set_bar_progress = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_1.style.foreground
	local var_11_1 = var_11_0.default_size

	var_11_0.texture_size[1] = math.floor(var_11_1[1] * arg_11_2)
end

FloatingIconUI._draw = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0._widgets_by_name.progress_bar

	arg_12_0:_set_bar_progress(var_12_1, arg_12_2, arg_12_3)

	local var_12_2 = 100
	local var_12_3 = 100

	arg_12_0:_set_widget_position(var_12_1, var_12_2, var_12_3)
	UIRenderer.draw_widget(var_12_0, var_12_1)
end

FloatingIconUI.convert_world_to_screen_position = function (arg_13_0, arg_13_1, arg_13_2)
	if arg_13_1 then
		local var_13_0 = Camera.world_to_screen(arg_13_1, arg_13_2)

		return var_13_0.x, var_13_0.y
	end
end

FloatingIconUI.get_floating_icon_position = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = UISceneGraph.get_size_scaled(arg_14_0.ui_scenegraph, "screen")
	local var_14_1 = RESOLUTION_LOOKUP.scale
	local var_14_2 = var_14_0[1] * var_14_1
	local var_14_3 = var_14_0[2] * var_14_1
	local var_14_4 = var_14_2 * 0.5
	local var_14_5 = var_14_3 * 0.5
	local var_14_6 = RESOLUTION_LOOKUP.res_w
	local var_14_7 = RESOLUTION_LOOKUP.res_h
	local var_14_8 = var_14_6 / 2
	local var_14_9 = var_14_7 / 2
	local var_14_10 = arg_14_1 - var_14_8
	local var_14_11 = var_14_9 - arg_14_2
	local var_14_12 = false
	local var_14_13 = false

	if math.abs(var_14_10) > var_14_4 * 0.9 then
		var_14_12 = true
	end

	if math.abs(var_14_11) > var_14_5 * 0.9 then
		var_14_13 = true
	end

	local var_14_14 = arg_14_1
	local var_14_15 = arg_14_2
	local var_14_16 = arg_14_3 < 0 and true or false
	local var_14_17 = (var_14_12 or var_14_13) and true or false
	local var_14_18 = var_14_6 - var_14_2
	local var_14_19 = var_14_7 - var_14_3
	local var_14_20 = var_14_14 - var_14_18 / 2
	local var_14_21 = var_14_15 - var_14_19 / 2
	local var_14_22 = RESOLUTION_LOOKUP.inv_scale
	local var_14_23 = var_14_20 * var_14_22
	local var_14_24 = var_14_21 * var_14_22

	return var_14_23, var_14_24, var_14_17, var_14_16
end

FloatingIconUI.get_icon_size = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = arg_15_4
	local var_15_1 = arg_15_5.start_scale_distance
	local var_15_2 = arg_15_5.end_scale_distance
	local var_15_3 = Vector3.distance(arg_15_1, arg_15_2)
	local var_15_4 = 1

	if var_15_1 < var_15_3 then
		var_15_4 = arg_15_0:icon_scale_by_distance(var_15_3 - var_15_1, var_15_2)
		var_15_0 = math.lerp(arg_15_3, var_15_4 * arg_15_4, 0.2)
	end

	return var_15_0, var_15_4
end

FloatingIconUI.icon_scale_by_distance = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = math.min(arg_16_2, arg_16_1)
	local var_16_1 = math.max(0, var_16_0)
	local var_16_2 = UISettings.tutorial.mission_tooltip.minimum_icon_scale

	return (math.max(var_16_2, 1 - var_16_1 / arg_16_2))
end

FloatingIconUI.get_player_first_person_extension = function (arg_17_0)
	if arg_17_0._first_person_extension then
		return arg_17_0._first_person_extension
	else
		local var_17_0 = arg_17_0.peer_id
		local var_17_1 = arg_17_0.player_manager:player_from_peer_id(var_17_0).player_unit

		if var_17_1 and ScriptUnit.has_extension(var_17_1, "first_person_system") then
			local var_17_2 = ScriptUnit.extension(var_17_1, "first_person_system")

			arg_17_0._first_person_extension = var_17_2

			return var_17_2
		end
	end
end
