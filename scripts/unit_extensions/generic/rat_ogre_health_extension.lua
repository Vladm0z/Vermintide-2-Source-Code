-- chunkname: @scripts/unit_extensions/generic/rat_ogre_health_extension.lua

RatOgreHealthExtension = class(RatOgreHealthExtension, GenericHealthExtension)

RatOgreHealthExtension.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	RatOgreHealthExtension.super.init(self, arg_1_1, arg_1_2, ...)

	self._wounded_anim_variable = Unit.animation_find_variable(arg_1_2, "wounded")
end

RatOgreHealthExtension.update = function (self, arg_2_1, ...)
	-- function 2
	local unit = self.unit
	local flag

	flag = not (self.damage / self.health > 0.5) or not 1 or 0

	Unit.animation_set_variable(unit, self._wounded_anim_variable, flag)
end
