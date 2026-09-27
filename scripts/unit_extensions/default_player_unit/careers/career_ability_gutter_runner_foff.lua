-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_gutter_runner_foff.lua

CareerAbilityGutterRunnerFoff = class(CareerAbilityGutterRunnerFoff, CareerAbilityDarkPactBase)

CareerAbilityGutterRunnerFoff._ability_available = function (self)
	-- function 1
	local _ability_available = self.super._ability_available(self)
	local flag = self._career_extension:get_state() == "vs_gutter_runner_smoke_bomb_invisible"

	return not _ability_available and not flag
end

CareerAbilityGutterRunnerFoff._start = function (self)
	-- function 2
	self.super._start(self)

	local _career_extension = self._career_extension
	local ability_id = self._ability_data.ability_id

	_career_extension:start_activated_ability_cooldown(ability_id)
	_career_extension:set_activated_ability_cooldown_paused(ability_id)
end
