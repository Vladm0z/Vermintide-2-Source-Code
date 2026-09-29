-- chunkname: @scripts/unit_extensions/weapons/area_damage/proximity_mine_extension.lua

ProximityMineExtension = class(ProximityMineExtension)

ProximityMineExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.arm_time = not not extension_init_data.arm_time
	self.detonation_time = not not extension_init_data.detonation_time
	self.range = not not extension_init_data.range
	self.catapult_strength = not not extension_init_data.catapult_strength
	self.explosion_template = extension_init_data.explosion_template
	self.owner_unit = extension_init_data.owner_unit
	self.detonating_sound_event = extension_init_data.detonating_sound_event
	self.armed_sound_event = extension_init_data.armed_sound_event
	self.hero_side = Managers.state.side:get_side_from_name("heroes")
	self.audio_system = Managers.state.entity:system("audio_system")
	self._is_server = extension_init_context.is_server
	self._armed = false
	self._detonating = false
	self._unit = unit

	self:enable(true)
end

ProximityMineExtension.destroy = function (self)
	-- function 2
	return
end

ProximityMineExtension.enable = function (self, enable)
	-- function 3
	self._arm_timer = self.arm_time
end

ProximityMineExtension.update = function (self, unit, input, dt, context, t)
	-- function 4
	if not self._is_server or not HEALTH_ALIVE[unit] then
		return
	end

	local arm_timer = self._arm_timer

	if arm_timer then
		arm_timer = arm_timer - dt

		if arm_timer <= 0 then
			if self.armed_sound_event then
				self.audio_system:play_audio_unit_event(self.armed_sound_event, unit)
			end

			self._arm_timer = nil
			self._armed = true
		else
			self._arm_timer = arm_timer
		end
	end

	if self._armed then
		local player_and_bot_units = self.hero_side.PLAYER_AND_BOT_UNITS
		local position = Unit.local_position(unit, 0)

		for i = 1, #player_and_bot_units do
			local player_unit = player_and_bot_units[i]

			if ALIVE[player_unit] then
				local unit_pos = POSITION_LOOKUP[player_unit]
				local distance_sq = Vector3.distance_squared(position, unit_pos)
				local range = self.range

				if distance_sq <= range * range then
					if self.detonating_sound_event then
						self.audio_system:play_audio_unit_event(self.detonating_sound_event, unit)
					end

					self._armed = false
					self._detonating = true
					self._detonation_timer = self.detonation_time
				end
			end
		end
	end

	local detonation_timer = self._detonation_timer

	if detonation_timer then
		detonation_timer = detonation_timer - dt

		if detonation_timer <= 0 then
			local area_damage_system = Managers.state.entity:system("area_damage_system")
			local position = Unit.local_position(unit, 0)
			local power_level = 100

			area_damage_system:create_explosion(unit, position, Quaternion.identity(), self.explosion_template, 1, "undefined", power_level, false, self.owner_unit)
			AiUtils.kill_unit(unit)

			self._detonating = false
			self._detonation_timer = nil
		else
			self._detonation_timer = detonation_timer
		end
	end
end

ProximityMineExtension.hot_join_sync = function (self, peer_id)
	-- function 5
	return
end
