-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_packmaster_hoist.lua

CareerAbilityPackmasterHoist = class(CareerAbilityPackmasterHoist, CareerAbilityDarkPactBase)

CareerAbilityPackmasterHoist._ability_available = function (self)
	-- function 1
	local ability_available = self.super._ability_available(self)
	local status_extension = self._status_extension
	local locomotion_extension = self._locomotion_extension

	if ability_available then
		-- Nothing
	end

	::label_1_0::

	local get_is_packmaster_dragging = status_extension:get_is_packmaster_dragging()

	get_is_packmaster_dragging = not not get_is_packmaster_dragging and not not locomotion_extension:is_on_ground()

	::label_1_1::

	return get_is_packmaster_dragging
end
