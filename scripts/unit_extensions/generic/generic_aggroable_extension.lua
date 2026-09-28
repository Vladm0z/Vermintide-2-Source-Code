-- chunkname: @scripts/unit_extensions/generic/generic_aggroable_extension.lua

GenericAggroableExtension = class(GenericAggroableExtension)

GenericAggroableExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	local num

	if Unit.has_data(unit, "aggro_modifier_passive") then
		num = Unit.get_data(unit, "aggro_modifier_passive") * -1

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_1_0::

	self.aggro_modifier_passive = num

	local num_2

	if Unit.has_data(unit, "aggro_modifier_active") then
		num_2 = Unit.get_data(unit, "aggro_modifier_active") * -1

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

GenericAggroableExtension.destroy = function (self)
	-- function 4
	return
end
