-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_packmaster_equip.lua

CareerAbilityPackmasterEquip = class(CareerAbilityPackmasterEquip, CareerAbilityDarkPactBase)

CareerAbilityPackmasterEquip.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)

	self._ability_default_startup_delay_time = self._ability_data.startup_delay_time

	self:freeze()
end

CareerAbilityPackmasterEquip.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self._freezed then
		return
	end

	if not self._equip_ready then
		if not self._equip_startup_delay_time then
			if not self:_ability_available() then
				self._equip_startup_delay_time = arg_2_5 + self._ability_default_startup_delay_time
			end
		elseif not (self._equip_ready or not (arg_2_5 >= self._equip_startup_delay_time)) then
			self._equip_ready = true
		end
	end

	local _equip_startup_delay_time = self._equip_startup_delay_time

	if not _equip_startup_delay_time then
		local _ability_default_startup_delay_time = self._ability_default_startup_delay_time

		self._startup_delay_fraction = math.clamp((_equip_startup_delay_time - arg_2_5) / _ability_default_startup_delay_time, 0, 1)
	end
end

CareerAbilityPackmasterEquip.was_triggered = function (self)
	-- function 3
	if not self:_ability_available() and not self._equip_ready then
		self:_start()

		return true
	end

	return false
end

CareerAbilityPackmasterEquip.startup_delay_fraction = function (self)
	-- function 4
	return self._startup_delay_fraction
end

CareerAbilityPackmasterEquip.startup_delay_time = function (self)
	-- function 5
	return self._equip_startup_delay_time
end

CareerAbilityPackmasterEquip._start = function (self)
	-- function 6
	self.super._start(self)
	self:freeze()

	self._equip_ready = nil
	self._startup_delay_fraction = nil
	self._equip_startup_delay_time = nil
end

CareerAbilityPackmasterEquip.unfreeze = function (self)
	-- function 7
	self._freezed = false
end

CareerAbilityPackmasterEquip.freeze = function (self)
	-- function 8
	self._freezed = true
end
