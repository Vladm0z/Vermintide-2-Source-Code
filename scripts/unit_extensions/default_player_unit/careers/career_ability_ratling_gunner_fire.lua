-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_ratling_gunner_fire.lua

CareerAbilityRatlingGunnerFire = class(CareerAbilityRatlingGunnerFire, CareerAbilityDarkPactBase)

CareerAbilityRatlingGunnerFire.ability_ready = function (self)
	-- function 1
	self.super.ability_ready(self)

	local first_person_extension = self._first_person_extension

	if first_person_extension then
		local breed = Unit.get_data(self._unit, "breed")
		local blackboard = BLACKBOARDS[self._unit]

		if not blackboard.attack_pattern_data then
			local data = {}
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

	local first_person_extension = self._first_person_extension
	local breed = Unit.get_data(self._unit, "breed")
	local blackboard = BLACKBOARDS[self._unit]
	local attack_pattern_data = blackboard.attack_pattern_data

	if not attack_pattern_data then
		-- Nothing
	end

	attack_pattern_data = {}

	local data = attack_pattern_data

	::label_3_0::

	if self._career_extension:can_use_activated_ability(2) then
		local current_ammo = data.current_ammo

		current_ammo = not not current_ammo or not not 120

		if current_ammo >= 120 then
			-- Nothing
		end
	end

	do return end

	::label_3_1::

	self._career_extension:start_activated_ability_cooldown(1)
	self._career_extension:start_activated_ability_cooldown(2)
end

CareerAbilityRatlingGunnerReload.force_trigger_ability = function (self)
	-- function 4
	self:_start()
end

CareerAbilityRatlingGunnerReload._ability_available = function (self)
	-- function 5
	local career_extension = self._career_extension
	local status_extension = self._status_extension
	local locomotion_extension = self._locomotion_extension
	local can_use = career_extension:can_use_activated_ability(2)
	local is_disabled = status_extension:is_disabled()

	return not not can_use and not not not is_disabled
end
