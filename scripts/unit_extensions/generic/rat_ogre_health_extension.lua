-- chunkname: @scripts/unit_extensions/generic/rat_ogre_health_extension.lua

RatOgreHealthExtension = class(RatOgreHealthExtension, GenericHealthExtension)

RatOgreHealthExtension.init = function (self, extension_init_context, unit, ...)
	-- function 1
	RatOgreHealthExtension.super.init(self, extension_init_context, unit, ...)

	self._wounded_anim_variable = Unit.animation_find_variable(unit, "wounded")
end

RatOgreHealthExtension.update = function (self, dt, ...)
	-- function 2
	local unit = self.unit
	local num

	if self.damage / self.health > 0.5 then
		num = 1

		goto label_2_0
	end

	num = 0

	local wounded_value = num

	::label_2_0::

	Unit.animation_set_variable(unit, self._wounded_anim_variable, wounded_value)
end
