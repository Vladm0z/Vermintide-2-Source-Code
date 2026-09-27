-- chunkname: @scripts/unit_extensions/generic/generic_aggroable_extension.lua

GenericAggroableExtension = class(GenericAggroableExtension)

GenericAggroableExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local num

	if not Unit.has_data(arg_1_2, "aggro_modifier_passive") then
		num = Unit.get_data(arg_1_2, "aggro_modifier_passive") * -1

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_1_0::

	self.aggro_modifier_passive = num

	local num_2

	if not Unit.has_data(arg_1_2, "aggro_modifier_active") then
		num_2 = Unit.get_data(arg_1_2, "aggro_modifier_active") * -1

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = 0

	::label_1_1::

	self.aggro_modifier_active = num_2

	self:use_passive_aggro()
end

GenericAggroableExtension.use_passive_aggro = function (self)
	-- function 2
	self.aggro_modifier = self.aggro_modifier_passive
end

GenericAggroableExtension.use_active_aggro = function (self)
	-- function 3
	self.aggro_modifier = self.aggro_modifier_active
end

GenericAggroableExtension.destroy = function (arg_4_0)
	-- function 4
	return
end
