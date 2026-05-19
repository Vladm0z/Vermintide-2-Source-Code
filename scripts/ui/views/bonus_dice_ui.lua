-- chunkname: @scripts/ui/views/bonus_dice_ui.lua

local var_0_0 = local_require("scripts/ui/views/bonus_dice_ui_definitions")
local var_0_1 = math.easeInCubic

BonusDiceUI = class(BonusDiceUI)

function BonusDiceUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.dice_keeper = arg_1_2.dice_keeper
	arg_1_0.active_dice_widgets = 0
	arg_1_0.dice_widgets = {}
	arg_1_0.die_types = {}
	arg_1_0.die_count = {}

	local var_1_0 = arg_1_2.dice_keeper:get_dice()
	local var_1_1 = 0

	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		var_1_1 = var_1_1 + 1
		arg_1_0.die_types[var_1_1] = iter_1_0
		arg_1_0.die_count[iter_1_0] = 0
	end

	arg_1_0.die_types_n = var_1_1

	arg_1_0:create_ui_elements()
end

function BonusDiceUI.create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	for iter_2_0 = 1, 10 do
		arg_2_0.dice_widgets[iter_2_0] = UIWidget.init(var_0_0.dice_widget_definition)
	end
end

function BonusDiceUI.add_die(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.active_dice_widgets + 1
	local var_3_1 = arg_3_0.dice_widgets[var_3_0] or UIWidget.init(var_0_0.dice_widget_definition)
	local var_3_2 = var_0_0.num_dice_columns
	local var_3_3 = var_0_0.dice_size
	local var_3_4 = var_0_0.gap
	local var_3_5 = 0
	local var_3_6 = 0
	local var_3_7 = (var_3_0 - 1) % var_3_2
	local var_3_8 = math.floor((var_3_0 - 1) / var_3_2)
	local var_3_9 = var_3_7 * var_3_3[1] + var_3_4 * var_3_7
	local var_3_10 = -(var_3_8 * var_3_3[2] + var_3_4 * var_3_8)

	var_3_1.style.offset[1] = var_3_9
	var_3_1.style.offset[2] = var_3_10
	var_3_1.content.texture_id = var_0_0.get_die_texture(arg_3_1)

	UIWidget.animate(var_3_1, UIAnimation.init(UIAnimation.function_by_time, var_3_1.style.color, 1, 0, 255, 1, var_0_1))

	arg_3_0.die_count[arg_3_1] = arg_3_0.die_count[arg_3_1] + 1
	arg_3_0.dice_widgets[var_3_0] = var_3_1
	arg_3_0.active_dice_widgets = var_3_0
end

function BonusDiceUI.destroy(arg_4_0)
	arg_4_0.dice_keeper = nil
end

function BonusDiceUI.update(arg_5_0, arg_5_1)
	do return end

	if DebugKeyHandler.key_pressed("f3", "asdasd", "dadsa") then
		arg_5_0.dice_keeper:add_die("normal", 1)
	end

	arg_5_0:update_dices()

	if arg_5_0.active_dice_widgets > 0 then
		arg_5_0:draw(arg_5_1)
	end
end

function BonusDiceUI.update_dices(arg_6_0)
	local var_6_0 = arg_6_0.dice_keeper
	local var_6_1 = arg_6_0.die_count
	local var_6_2 = arg_6_0.die_types
	local var_6_3 = arg_6_0.die_types_n

	for iter_6_0 = 1, var_6_3 do
		local var_6_4 = var_6_2[iter_6_0]
		local var_6_5 = var_6_1[var_6_4]
		local var_6_6 = var_6_0:num_new_dices(var_6_4) - var_6_5

		if var_6_6 > 0 then
			for iter_6_1 = 1, var_6_6 do
				arg_6_0:add_die(var_6_4)
			end
		end
	end
end

function BonusDiceUI.draw(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.ui_renderer
	local var_7_1 = arg_7_0.ui_scenegraph
	local var_7_2 = arg_7_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_7_0, var_7_1, var_7_2, arg_7_1)

	local var_7_3 = arg_7_0.dice_widgets
	local var_7_4 = arg_7_0.active_dice_widgets

	for iter_7_0 = 1, var_7_4 do
		UIRenderer.draw_widget(var_7_0, var_7_3[iter_7_0])
	end

	UIRenderer.end_pass(var_7_0)
end
