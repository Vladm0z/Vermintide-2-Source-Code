-- chunkname: @scripts/unit_extensions/objectives/objective_group_extension.lua

ObjectiveGroupExtension = class(ObjectiveGroupExtension, BaseObjectiveExtension)
ObjectiveGroupExtension.NAME = "ObjectiveGroupExtension"

ObjectiveGroupExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	ObjectiveGroupExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._children = {}
end

ObjectiveGroupExtension._set_objective_data = function (self, arg_2_1)
	-- function 2
	local time_for_completion = arg_2_1.time_for_completion

	time_for_completion = time_for_completion or 0
	self._time_for_completion = time_for_completion
end

ObjectiveGroupExtension._activate = function (arg_3_0)
	-- function 3
	return
end

ObjectiveGroupExtension.register_child = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_0._children[arg_4_1] = true
end

ObjectiveGroupExtension.get_percentage_done = function (self)
	-- function 5
	local num = 0
	local num_2 = 0

	for k in pairs(self._children) do
		num = num + k:get_percentage_done()
		num_2 = num_2 + 1
	end

	if num_2 == 0 then
		return 1
	end

	return num / num_2
end

ObjectiveGroupExtension.get_total_sections = function (self)
	-- function 6
	local num = 0

	for k in pairs(self._children) do
		num = num + k:get_total_sections()
	end

	return num
end

ObjectiveGroupExtension.description = function (self)
	-- function 7
	for k in pairs(self._children) do
		local description = k:description()

		if not description then
			return description
		end
	end
end

ObjectiveGroupExtension.objective_icon = function (self)
	-- function 8
	for k in pairs(self._children) do
		local objective_icon = k:objective_icon()

		if not objective_icon then
			return objective_icon
		end
	end
end

ObjectiveGroupExtension.objective_type = function (self)
	-- function 9
	for k in pairs(self._children) do
		local objective_type = k:objective_type()

		if not objective_type then
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

ObjectiveGroupExtension._client_update = function (arg_12_0)
	-- function 12
	return
end

ObjectiveGroupExtension._server_update = function (arg_13_0)
	-- function 13
	return
end

ObjectiveGroupExtension._deactivate = function (arg_14_0)
	-- function 14
	return
end
