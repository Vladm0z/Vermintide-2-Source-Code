-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_ratling_gunner_fire.lua

CareerAbilityRatlingGunnerFire = class(CareerAbilityRatlingGunnerFire, CareerAbilityDarkPactBase)

CareerAbilityRatlingGunnerFire.ability_ready = function (self)
	-- function 1
	self.super.ability_ready(self)

	if not self._first_person_extension then
		local get_data = Unit.get_data(self._unit, "breed")

		if not BLACKBOARDS[self._unit].attack_pattern_data then
			local tbl = {}
		end
	end
end

CareerAbilityRatlingGunnerReload = class(CareerAbilityRatlingGunnerReload, CareerAbilityDarkPactBase)

CareerAbilityRatlingGunnerReload.ability_ready = function (self)
	-- function 2
	self.super.ability_ready(self)
end

CareerAbilityRatlingGunnerReload._start = function (self)
	-- function 3
	self.super.ability_ready(self)

	local _first_person_extension = self._first_person_extension
	local get_data = Unit.get_data(self._unit, "breed")
	local attack_pattern_data = BLACKBOARDS[self._unit].attack_pattern_data

	attack_pattern_data = attack_pattern_data or {}

	if not self._career_extension:can_use_activated_ability(2) then
		local current_ammo = attack_pattern_data.current_ammo

		current_ammo = current_ammo or 120

		if current_ammo >= 120 then
			-- Nothing
		end
	end

	do return end

	::label_3_0::

	self._career_extension:start_activated_ability_cooldown(1)
	self._career_extension:start_activated_ability_cooldown(2)
end

CareerAbilityRatlingGunnerReload.force_trigger_ability = function (self)
	-- function 4
	self:_start()
end

CareerAbilityRatlingGunnerReload._ability_available = function (self)
	-- function 5
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability(2)
	local is_disabled = _status_extension:is_disabled()

	return not can_use_activated_ability and not is_disabled
end
