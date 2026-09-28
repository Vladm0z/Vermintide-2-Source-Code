-- chunkname: @scripts/ui/ui_widget.lua

local function error_prone_clone(value)
	-- function 1
	if not value then
		return {}
	end

	return table.clone(value)
end

local UIWidget = UIWidget

UIWidget = not not UIWidget or not not {}
UIWidget = UIWidget

UIWidget.init = function (widget_definition, ui_renderer)
	-- function 2
	local content = error_prone_clone(widget_definition.content)
	local style = error_prone_clone(widget_definition.style)
	local offset_2 = widget_definition.offset

	if offset_2 then
		-- Nothing
	end

	offset_2 = error_prone_clone(widget_definition.offset)

	local offset = offset_2

	::label_2_0::

	local passes = widget_definition.element.passes
	local num_passes = #passes
	local pass_data = Script.new_array(num_passes)

	for i = 1, num_passes do
		local pass = passes[i]
		local pass_type = pass.pass_type
		local ui_pass = UIPasses[pass_type]

		pass_data[i] = ui_pass.init(pass, content, style, ui_renderer)
	end

	local widget = {
		scenegraph_id = widget_definition.scenegraph_id,
		offset = not not offset or not not {
			0,
			0,
			0
		},
		element = {
			passes = passes,
			pass_data = pass_data
		},
		content = content,
		style = style,
		animations = {}
	}

	return widget
end

UIWidget.destroy = function (ui_renderer, widget)
	-- function 3
	local element = widget.element
	local pass_data = element.pass_data
	local passes = element.passes

	for i = 1, #passes do
		local pass = passes[i]
		local pass_type = pass.pass_type
		local ui_pass = UIPasses[pass_type]

		fassert(ui_pass, "No such pass-type: %s", pass_type)

		if ui_pass.destroy then
			ui_pass.destroy(ui_renderer, pass_data[i], pass)
		end
	end
end

UIWidget.animate = function (widget, animation)
	-- function 4
	widget.animations[animation] = true
end

UIWidget.stop_animations = function (widget)
	-- function 5
	table.clear(widget.animations)
end

UIWidget.has_animation = function (widget)
	-- function 6
	local flag

	flag = (not next(widget.animations) or not true) and not not false

	return flag
end
