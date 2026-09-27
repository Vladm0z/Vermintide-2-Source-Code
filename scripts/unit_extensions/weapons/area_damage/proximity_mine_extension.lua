-- chunkname: @scripts/unit_extensions/weapons/area_damage/proximity_mine_extension.lua

ProximityMineExtension = class(ProximityMineExtension)

ProximityMineExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local arm_time = arg_1_3.arm_time

	arm_time = arm_time or 0
	self.arm_time = arm_time

	local detonation_time = arg_1_3.detonation_time

	detonation_time = detonation_time or 0
	self.detonation_time = detonation_time

	local range = arg_1_3.range

	range = range or 1
	self.range = range

	local catapult_strength = arg_1_3.catapult_strength

	catapult_strength = catapult_strength or 1
	self.catapult_strength = catapult_strength
	self.explosion_template = arg_1_3.explosion_template
	self.owner_unit = arg_1_3.owner_unit
	self.detonating_sound_event = arg_1_3.detonating_sound_event
	self.armed_sound_event = arg_1_3.armed_sound_event
	self.hero_side = Managers.state.side:get_side_from_name("heroes")
	self.audio_system = Managers.state.entity:system("audio_system")
	self._is_server = arg_1_1.is_server
	self._armed = false
	self._detonating = false
	self._unit = arg_1_2

	self:enable(true)
end

ProximityMineExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

ProximityMineExtension.enable = function (self, arg_3_1)
	-- function 3
	self._arm_timer = self.arm_time
end

ProximityMineExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not (not self._is_server and HEALTH_ALIVE[arg_4_1]) then
		return
	end

	local _arm_timer = self._arm_timer

	if not _arm_timer then
		local num = _arm_timer - arg_4_3

		if num <= 0 then
			if not self.armed_sound_event then
				self.audio_system:play_audio_unit_event(self.armed_sound_event, arg_4_1)
			end

			self._arm_timer = nil
			self._armed = true
		else
			self._arm_timer = num
		end
	end

	if not self._armed then
		local PLAYER_AND_BOT_UNITS = self.hero_side.PLAYER_AND_BOT_UNITS
		local local_position = Unit.local_position(arg_4_1, 0)

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_4_4 = PLAYER_AND_BOT_UNITS[i]

			if not ALIVE[var_4_4] then
				local var_4_5 = POSITION_LOOKUP[var_4_4]
				local distance_squared = Vector3.distance_squared(local_position, var_4_5)
				local range = self.range

				if distance_squared <= range * range then
					if not self.detonating_sound_event then
						self.audio_system:play_audio_unit_event(self.detonating_sound_event, arg_4_1)
					end

					self._armed = false
					self._detonating = true
					self._detonation_timer = self.detonation_time
				end
			end
		end
	end

	local _detonation_timer = self._detonation_timer

	if not _detonation_timer then
		local num_2 = _detonation_timer - arg_4_3

		if num_2 <= 0 then
			local system = Managers.state.entity:system("area_damage_system")
			local local_position_2 = Unit.local_position(arg_4_1, 0)
			local num_3 = 100

			system:create_explosion(arg_4_1, local_position_2, Quaternion.identity(), self.explosion_template, 1, "undefined", num_3, false, self.owner_unit)
			AiUtils.kill_unit(arg_4_1)

			self._detonating = false
			self._detonation_timer = nil
		else
			self._detonation_timer = num_2
		end
	end
end

ProximityMineExtension.hot_join_sync = function (arg_5_0, arg_5_1)
	-- function 5
	return
end
