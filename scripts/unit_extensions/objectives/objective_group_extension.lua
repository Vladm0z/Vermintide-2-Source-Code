-- chunkname: @scripts/unit_extensions/objectives/objective_group_extension.lua

ObjectiveGroupExtension = class(ObjectiveGroupExtension, BaseObjectiveExtension)
ObjectiveGroupExtension.NAME = "ObjectiveGroupExtension"

ObjectiveGroupExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	ObjectiveGroupExtension.super.init(self, extension_init_context, unit, extension_init_data)

	self._children = {}
end

ObjectiveGroupExtension._set_objective_data = function (self, objective_data)
	-- function 2
	self._time_for_completion = not not objective_data.time_for_completion
end

ObjectiveGroupExtension._activate = function (self)
	-- function 3
	return
end

ObjectiveGroupExtension.register_child = function (self, child_extension)
	-- function 4
	self._children[child_extension] = true
end

ObjectiveGroupExtension.get_percentage_done = function (self)
	-- function 5
	local percentage_done = 0
	local num_children = 0

	for child_extension in pairs(self._children) do
		percentage_done = percentage_done + child_extension:get_percentage_done()
		num_children = num_children + 1
	end

	if num_children == 0 then
		return 1
	end

	return percentage_done / num_children
end

ObjectiveGroupExtension.get_total_sections = function (self)
	-- function 6
	local total_sections = 0

	for child_extension in pairs(self._children) do
		total_sections = total_sections + child_extension:get_total_sections()
	end

	return total_sections
end

ObjectiveGroupExtension.description = function (self)
	-- function 7
	for child_extension in pairs(self._children) do
		local description = child_extension:description()

		if description then
			return description
		end
	end
end

ObjectiveGroupExtension.objective_icon = function (self)
	-- function 8
	for child_extension in pairs(self._children) do
		local objective_icon = child_extension:objective_icon()

		if objective_icon then
			return objective_icon
		end
	end
end

ObjectiveGroupExtension.objective_type = function (self)
	-- function 9
	for child_extension in pairs(self._children) do
		local objective_type = child_extension:objective_type()

		if objective_type then
			return objective_type
		end
	end
end

ObjectiveGroupExtension.is_done = function (self)
	-- function 10
	return self:get_percentage_done() >= 1
end

ObjectiveGroupExtension.is_active = function (self)
	-- function 11
	return self._activated
end

ObjectiveGroupExtension._client_update = function (self)
	-- function 12
	return
end

ObjectiveGroupExtension._server_update = function (self)
	-- function 13
	return
end

ObjectiveGroupExtension._deactivate = function (self)
	-- function 14
	return
end
