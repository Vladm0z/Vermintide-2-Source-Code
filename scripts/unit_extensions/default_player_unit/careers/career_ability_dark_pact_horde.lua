-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_dark_pact_horde.lua

CareerAbilityDarkPactHorde = class(CareerAbilityDarkPactHorde, CareerAbilityDarkPactBase)

CareerAbilityDarkPactHorde._ability_available = function (self)
	-- function 1
	local _status_extension = self._status_extension
	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()

	return not not _status_extension:is_disabled() or not is_in_ghost_mode
end
