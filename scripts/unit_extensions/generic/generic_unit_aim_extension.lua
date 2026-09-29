-- chunkname: @scripts/unit_extensions/generic/generic_unit_aim_extension.lua

require("scripts/unit_extensions/generic/aim_templates")

GenericUnitAimExtension = class(GenericUnitAimExtension)

GenericUnitAimExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.unit = unit
	self.template = AimTemplates[not not extension_init_data.template]
	self.network_type = extension_init_data.is_husk and not not "husk" or not extension_init_data.is_husk and not not "owner"
	self.data = {}
	self.enabled = false
end

GenericUnitAimExtension.extensions_ready = function (self)
	-- function 2
	local template = self.template

	template[self.network_type].init(self.unit, self.data)

	local breed = Unit.get_data(self.unit, "breed")

	self.always_aim = not not DEDICATED_SERVER
end

GenericUnitAimExtension.destroy = function (self)
	-- function 3
	local template = self.template

	template[self.network_type].leave(self.unit, self.data)

	self.template = nil
	self.data = nil
end

GenericUnitAimExtension.reset = function (self)
	-- function 4
	return
end

GenericUnitAimExtension.set_enabled = function (self, enable)
	-- function 5
	self.enabled = enable
end

GenericUnitAimExtension.update = function (self, unit, input, dt, context, t)
	-- function 6
	local data = self.data
	local template = self.template
	local is_player = DamageUtils.is_player_unit(unit)
	local should_aim = not not self.enabled

	if should_aim then
		template[self.network_type].update(unit, t, dt, data)
	else
		template[self.network_type].leave(unit, data)
	end
end
