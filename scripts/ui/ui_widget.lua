-- chunkname: @scripts/ui/ui_widget.lua

local function fn(arg_1_0)
	-- function 1
	if not arg_1_0 then
		return {}
	end

	return table.clone(arg_1_0)
end

local UIWidget = UIWidget

UIWidget = UIWidget or {}
UIWidget = UIWidget

UIWidget.init = function (self, arg_2_1)
	-- function 2
	local var_2_0 = fn(self.content)
	local var_2_1 = fn(self.style)
	local offset = self.offset

	offset = not offset and fn(self.offset)

	local passes = self.element.passes
	local count = #passes
	local new_array = Script.new_array(count)

	for i = 1, count do
		local var_2_6 = passes[i]
		local pass_type = var_2_6.pass_type

		new_array[i] = UIPasses[pass_type].init(var_2_6, var_2_0, var_2_1, arg_2_1)
	end

	return {
		scenegraph_id = self.scenegraph_id,
		offset = offset or {
			0,
			0,
			0
		},
		element = {
			passes = passes,
			pass_data = new_array
		},
		content = var_2_0,
		style = var_2_1,
		animations = {}
	}
end

UIWidget.destroy = function (arg_3_0, arg_3_1)
	-- function 3
	local element = arg_3_1.element
	local pass_data = element.pass_data
	local passes = element.passes

	for i = 1, #passes do
		local var_3_3 = passes[i]
		local pass_type = var_3_3.pass_type
		local var_3_5 = UIPasses[pass_type]

		fassert(var_3_5, "No such pass-type: %s", pass_type)

		if not var_3_5.destroy then
			var_3_5.destroy(arg_3_0, pass_data[i], var_3_3)
		end
	end
end

UIWidget.animate = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_0.animations[arg_4_1] = true
end

UIWidget.stop_animations = function (self)
	-- function 5
	table.clear(self.animations)
end

UIWidget.has_animation = function (self)
	-- function 6
	local flag

	flag = not next(self.animations) and true and false

	return flag
end
