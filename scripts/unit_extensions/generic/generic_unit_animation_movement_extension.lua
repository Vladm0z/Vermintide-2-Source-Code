-- chunkname: @scripts/unit_extensions/generic/generic_unit_animation_movement_extension.lua

require("scripts/unit_extensions/generic/animation_movement_templates")

GenericUnitAnimationMovementExtension = class(GenericUnitAnimationMovementExtension)

GenericUnitAnimationMovementExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2

	local template = arg_1_3.template

	self.template = AnimationMovementTemplates[template]

	local flag

	flag = not arg_1_3.is_husk and "husk" and "owner"
	self.network_type = flag
	self.data = {}
	self.enabled = false
end

GenericUnitAnimationMovementExtension.extensions_ready = function (self)
	-- function 2
	self.template[self.network_type].init(self.unit, self.data)

	local get_data = Unit.get_data(self.unit, "breed")
end

GenericUnitAnimationMovementExtension.destroy = function (self)
	-- function 3
	self.template[self.network_type].leave(self.unit, self.data)

	self.template = nil
	self.data = nil
end

GenericUnitAnimationMovementExtension.reset = function (arg_4_0)
	-- function 4
	return
end

GenericUnitAnimationMovementExtension.set_enabled = function (self, arg_5_1)
	-- function 5
	self.enabled = arg_5_1

	if not arg_5_1 then
		self.leave = true
	end
end

GenericUnitAnimationMovementExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local data = self.data
	local template = self.template

	if not self.enabled then
		template[self.network_type].update(arg_6_1, arg_6_5, arg_6_3, data)
	elseif not self.leave then
		template[self.network_type].leave(arg_6_1, data)

		self.leave = false
	end
end
