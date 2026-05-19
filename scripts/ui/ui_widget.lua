-- chunkname: @scripts/ui/ui_widget.lua

local function var_0_0(arg_1_0)
	if not arg_1_0 then
		return {}
	end

	return table.clone(arg_1_0)
end

UIWidget = UIWidget or {}

function UIWidget.init(arg_2_0, arg_2_1)
	local var_2_0 = var_0_0(arg_2_0.content)
	local var_2_1 = var_0_0(arg_2_0.style)
	local var_2_2 = arg_2_0.offset and var_0_0(arg_2_0.offset)
	local var_2_3 = arg_2_0.element.passes
	local var_2_4 = #var_2_3
	local var_2_5 = Script.new_array(var_2_4)

	for iter_2_0 = 1, var_2_4 do
		local var_2_6 = var_2_3[iter_2_0]
		local var_2_7 = var_2_6.pass_type

		var_2_5[iter_2_0] = UIPasses[var_2_7].init(var_2_6, var_2_0, var_2_1, arg_2_1)
	end

	return {
		scenegraph_id = arg_2_0.scenegraph_id,
		offset = var_2_2 or {
			0,
			0,
			0
		},
		element = {
			passes = var_2_3,
			pass_data = var_2_5
		},
		content = var_2_0,
		style = var_2_1,
		animations = {}
	}
end

function UIWidget.destroy(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.element
	local var_3_1 = var_3_0.pass_data
	local var_3_2 = var_3_0.passes

	for iter_3_0 = 1, #var_3_2 do
		local var_3_3 = var_3_2[iter_3_0]
		local var_3_4 = var_3_3.pass_type
		local var_3_5 = UIPasses[var_3_4]

		fassert(var_3_5, "No such pass-type: %s", var_3_4)

		if var_3_5.destroy then
			var_3_5.destroy(arg_3_0, var_3_1[iter_3_0], var_3_3)
		end
	end
end

function UIWidget.animate(arg_4_0, arg_4_1)
	arg_4_0.animations[arg_4_1] = true
end

function UIWidget.stop_animations(arg_5_0)
	table.clear(arg_5_0.animations)
end

function UIWidget.has_animation(arg_6_0)
	return next(arg_6_0.animations) and true or false
end
