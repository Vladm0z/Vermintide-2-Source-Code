-- chunkname: @scripts/ui/views/area_indicator_ui.lua

local var_0_0 = local_require("scripts/ui/views/area_indicator_ui_definitions")

AreaIndicatorUI = class(AreaIndicatorUI)

function AreaIndicatorUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager

	local var_1_0 = arg_1_2.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)

	arg_1_0:create_ui_elements()
end

function AreaIndicatorUI.create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0.area_text_box = UIWidget.init(var_0_0.widget_definitions.area_text_box)

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)
end

function AreaIndicatorUI.destroy(arg_3_0)
	return
end

function AreaIndicatorUI.update(arg_4_0, arg_4_1)
	local var_4_0 = Managers.player:local_player()
	local var_4_1 = var_4_0 and var_4_0.player_unit

	if var_4_1 and Unit.alive(var_4_1) then
		local var_4_2 = ScriptUnit.extension(var_4_1, "hud_system")
		local var_4_3 = arg_4_0.saved_location
		local var_4_4 = var_4_2.current_location

		if not var_4_2.location_ui_blocked and var_4_4 ~= nil and var_4_4 ~= var_4_3 then
			arg_4_0.saved_location = var_4_4

			local var_4_5 = UISettings.area_indicator
			local var_4_6 = arg_4_0.area_text_box

			var_4_6.content.text = var_4_4
			arg_4_0.area_text_box_animation = UIAnimation.init(UIAnimation.function_by_time, var_4_6.style.text.text_color, 1, 0, 255, var_4_5.fade_time, math.easeInCubic, UIAnimation.wait, var_4_5.wait_time, UIAnimation.function_by_time, var_4_6.style.text.text_color, 1, 255, 0, var_4_5.fade_time, math.easeInCubic)
			arg_4_0.area_text_box_shadow_animation = UIAnimation.init(UIAnimation.function_by_time, var_4_6.style.text_shadow.text_color, 1, 0, 255, var_4_5.fade_time, math.easeInCubic, UIAnimation.wait, var_4_5.wait_time, UIAnimation.function_by_time, var_4_6.style.text_shadow.text_color, 1, 255, 0, var_4_5.fade_time, math.easeInCubic)

			WwiseWorld.trigger_event(arg_4_0.wwise_world, "hud_area_indicator")
		end
	end

	if arg_4_0.area_text_box_animation == nil then
		return
	end

	arg_4_0.area_text_box_animation = arg_4_0:update_animation(arg_4_0.area_text_box_animation, arg_4_1)
	arg_4_0.area_text_box_shadow_animation = arg_4_0:update_animation(arg_4_0.area_text_box_shadow_animation, arg_4_1)

	arg_4_0:draw(arg_4_1)
end

function AreaIndicatorUI.update_animation(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 then
		UIAnimation.update(arg_5_1, arg_5_2)

		if UIAnimation.completed(arg_5_1) then
			return nil
		end

		return arg_5_1
	end
end

function AreaIndicatorUI.draw(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.ui_renderer
	local var_6_1 = arg_6_0.ui_scenegraph
	local var_6_2 = arg_6_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_6_0, var_6_1, var_6_2, arg_6_1)
	UIRenderer.draw_widget(var_6_0, arg_6_0.area_text_box)
	UIRenderer.end_pass(var_6_0)
end
