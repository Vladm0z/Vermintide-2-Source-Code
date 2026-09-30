-- chunkname: @scripts/unit_extensions/generic/generic_aggroable_extension.lua

GenericAggroableExtension = class(GenericAggroableExtension)

GenericAggroableExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.aggro_modifier_passive = Unit.has_data(unit, "aggro_modifier_passive") and Unit.get_data(unit, "aggro_modifier_passive") * -1 or not Unit.has_data(unit, "aggro_modifier_passive") and 0
	self.aggro_modifier_active = Unit.has_data(unit, "aggro_modifier_active") and Unit.get_data(unit, "aggro_modifier_active") * -1 or not Unit.has_data(unit, "aggro_modifier_active") and 0

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
