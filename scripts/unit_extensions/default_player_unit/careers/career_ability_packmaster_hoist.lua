-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_packmaster_hoist.lua

CareerAbilityPackmasterHoist = class(CareerAbilityPackmasterHoist, CareerAbilityDarkPactBase)

CareerAbilityPackmasterHoist._ability_available = function (self)
	-- function 1
	local _ability_available = self.super._ability_available(self)
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension

	if not _ability_available then
		-- Nothing
	end

	::label_1_0::

	local get_is_packmaster_dragging = _status_extension:get_is_packmaster_dragging()

	get_is_packmaster_dragging = not get_is_packmaster_dragging and _locomotion_extension:is_on_ground()

	::label_1_1::

	return get_is_packmaster_dragging
end
