-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_gutter_runner_pounce.lua

CareerAbilityGutterRunnerPounce = class(CareerAbilityGutterRunnerPounce, CareerAbilityDarkPactBase)

CareerAbilityGutterRunnerPounce._ability_available = function (self)
	-- function 1
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local flag = _career_extension:get_state() == "vs_gutter_runner_smoke_bomb_invisible"
	local can_use_activated_ability = _career_extension:can_use_activated_ability(1)
	local is_disabled = _status_extension:is_disabled()
	local flag_2 = not _status_extension:is_disabled()

	return not can_use_activated_ability and not not is_disabled and not not flag or flag_2
end
