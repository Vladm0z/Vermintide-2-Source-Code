-- chunkname: @scripts/ui/views/character_inspect_ui.lua

local var_0_0 = local_require("scripts/ui/views/character_inspect_ui_definitions")
local var_0_1 = var_0_0.create_loot_widget

CharacterInspectUI = class(CharacterInspectUI)

CharacterInspectUI.init = function (arg_1_0, arg_1_1)
	arg_1_0.ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.input_manager = arg_1_1.input_manager

	local var_1_0 = arg_1_1.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements()
end

local var_0_2 = true

CharacterInspectUI.create_ui_elements = function (arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_2_0 = {}
	local var_2_1 = {}
	local var_2_2 = var_0_0.widget_definitions

	for iter_2_0, iter_2_1 in pairs(var_2_2) do
		local var_2_3 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_3
		var_2_1[iter_2_0] = var_2_3
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	var_0_2 = false
end

CharacterInspectUI.destroy = function (arg_3_0)
	GarbageLeakDetector.register_object(arg_3_0, "character_inspect_ui")
end

CharacterInspectUI.update = function (arg_4_0, arg_4_1)
	if var_0_2 then
		arg_4_0:create_ui_elements()
	end

	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:draw(arg_4_1)
end

CharacterInspectUI._update_animations = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._animations

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		UIAnimation.update(iter_5_1, arg_5_1)

		if UIAnimation.completed(iter_5_1) then
			var_5_0[iter_5_0] = nil
		end
	end
end

CharacterInspectUI.draw = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.ui_top_renderer
	local var_6_1 = arg_6_0.ui_scenegraph
	local var_6_2 = arg_6_0.input_manager:get_service("ingame_menu")
	local var_6_3 = arg_6_0._widgets_by_name

	UIRenderer.begin_pass(var_6_0, var_6_1, var_6_2, arg_6_1)

	for iter_6_0, iter_6_1 in pairs(var_6_3) do
		UIRenderer.draw_widget(var_6_0, iter_6_1)
	end

	UIRenderer.end_pass(var_6_0)
end

CharacterInspectUI.set_position = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.ui_scenegraph.background.local_position

	var_7_0[1] = arg_7_1
	var_7_0[2] = arg_7_2
end
