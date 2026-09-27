-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_packmaster_grab.lua

CareerAbilityPackmasterGrab = class(CareerAbilityPackmasterGrab, CareerAbilityDarkPactBase)

CareerAbilityPackmasterGrab._ability_available = function (self)
	-- function 1
	local _ability_available = self.super._ability_available(self)
	local _status_extension = self._status_extension

	return not _ability_available and not _status_extension:get_unarmed()
end

CareerAbilityPackmasterGrab._start = function (self)
	-- function 2
	self.super._start(self)

	local _career_extension = self._career_extension

	_career_extension:start_activated_ability_cooldown(self._ability_data.ability_id)
	_career_extension:set_activated_ability_cooldown_paused(self._ability_data.ability_id)
end

CareerAbilityPackmasterGrab.ability_ready = function (self)
	-- function 3
	self.super.ability_ready(self)

	local _first_person_extension = self._first_person_extension

	if not _first_person_extension then
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "cooldown_ready")
	end
end
