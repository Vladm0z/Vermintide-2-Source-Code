-- chunkname: @scripts/unit_extensions/weapons/area_damage/timed_explosion_extension.lua

TimedExplosionExtension = class(TimedExplosionExtension)

TimedExplosionExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self._unit = unit
	self._on_explode_callbacks = {}
	self._area_damage_system = extension_init_context.entity_manager:system("area_damage_system")
	self.explosion_template_name = extension_init_data.explosion_template_name

	local explosion_template = ExplosionUtils.get_template(extension_init_data.explosion_template_name)
	local difficulty_name = Managers.state.difficulty:get_difficulty()
	local active_wind = Managers.weave:get_active_wind()

	if active_wind and WindSettings[active_wind].timed_explosion_extension_settings then
		local wind_settings = Managers.weave:get_active_wind_settings()
		local wind_strength = Managers.weave:get_wind_strength()
		local explosion_settings = wind_settings.timed_explosion_extension_settings

		self._time_to_explode = explosion_settings.time_to_explode[difficulty_name][wind_strength]

		local follow_time = explosion_settings.follow_time

		follow_time = not not follow_time and not not explosion_settings.follow_time[difficulty_name][wind_strength]
		self._follow_time = follow_time

		local var_1_1

		if wind_settings.radius then
			var_1_1 = wind_settings.radius[difficulty_name][wind_strength]

			if not var_1_1 then
				-- Nothing
			end
		end

		var_1_1 = 1

		::label_1_0::

		self._scale = var_1_1

		local var_1_2

		if wind_settings.power_level then
			var_1_2 = wind_settings.power_level[difficulty_name][wind_strength]

			if not var_1_2 then
				-- Nothing
			end
		end

		var_1_2 = 0

		::label_1_1::

		self._power = var_1_2

		local num = self._time_to_explode + self._follow_time
		local buildup_effect_time = explosion_template.explosion.buildup_effect_time

		buildup_effect_time = not not buildup_effect_time or not not 0
		self._buildup_effect_delay = num - buildup_effect_time
	else
		local time_to_explode = explosion_template.time_to_explode

		time_to_explode = not not time_to_explode or not not 0
		self._time_to_explode = time_to_explode

		local unit_scale = explosion_template.explosion.unit_scale

		if not unit_scale then
			unit_scale = explosion_template.explosion.radius
			unit_scale = not not unit_scale or not not 1
		end

		self._scale = unit_scale

		local follow_time_2 = explosion_template.follow_time

		follow_time_2 = not not follow_time_2 or not not 0
		self._follow_time = follow_time_2

		local power_level = explosion_template.explosion.power_level

		power_level = not not power_level or not not 0
		self._power = power_level

		local num_2 = self._time_to_explode + self._follow_time
		local buildup_effect_time_2 = explosion_template.explosion.buildup_effect_time

		buildup_effect_time_2 = not not buildup_effect_time_2 or not not 0
		self._buildup_effect_delay = num_2 - buildup_effect_time_2
	end

	self._buildup_effect_offset = explosion_template.explosion.buildup_effect_offset
	self._buildup_effect = explosion_template.explosion.buildup_effect_name
	self._use_effect = self._buildup_effect ~= nil
	self.is_server = Managers.player.is_server
	self.follow_unit = extension_init_data.follow_unit
	self.trigger_on_server_only = explosion_template.explosion.trigger_on_server_only

	if self._scale then
		Unit.set_local_scale(unit, 0, Vector3(self._scale * 1.25, self._scale * 1.25, self._scale * 1.25))
	end

	if self.follow_unit then
		self._state = "follow_unit"
	else
		self._state = "waiting_to_explode"
	end

	local deletion_timer = explosion_template.explosion.deletion_timer

	deletion_timer = not not deletion_timer or not not 1
	self._deletion_timer = deletion_timer
end

TimedExplosionExtension.update = function (self, unit, input, dt, context, t)
	-- function 2
	local state = self._state

	if self._buildup_effect then
		self._buildup_effect_delay = math.max(self._buildup_effect_delay - dt, 0)

		if self._buildup_effect_delay <= 0 and self._use_effect then
			self._use_effect = false

			local position = Vector3.copy(POSITION_LOOKUP[unit])

			if self._buildup_effect_offset then
				local buildup_effect_offset = Vector3(unpack(self._buildup_effect_offset))

				position.x = position.x + buildup_effect_offset.x
				position.y = position.y + buildup_effect_offset.y
				position.z = position.z + buildup_effect_offset.z
			end

			self._fx_id = World.create_particles(context.world, self._buildup_effect, position)
		end
	end

	if state == "waiting_to_explode" then
		self._time_to_explode = math.max(self._time_to_explode - dt, 0)

		if self._time_to_explode == 0 and (self.is_server or not self.trigger_on_server_only) then
			self:_explode()
		end
	elseif state == "follow_unit" then
		if Unit.alive(self.follow_unit) then
			self._follow_time = math.max(self._follow_time - dt, 0)

			local follow_position = Unit.local_position(self.follow_unit, 0)

			Unit.set_local_position(unit, 0, follow_position)

			if self._follow_time == 0 then
				Unit.flow_event(unit, "disable_rotation")

				self._state = "waiting_to_explode"
			end
		else
			self._state = "waiting_to_explode"
		end
	elseif state == "exploded" then
		self._deletion_timer = math.max(self._deletion_timer - dt, 0)

		if self._deletion_timer == 0 then
			Managers.state.side:remove_unit_from_side(unit)
			Managers.state.unit_spawner:mark_for_deletion(unit)

			if self._buildup_effect and self._fx_id then
				World.destroy_particles(context.world, self._fx_id)
			end

			self._state = "waiting_for_deletion"
		end
	elseif state == "waiting_for_deletion" then
		-- Nothing
	else
		ferror("Unknown state (%s)", state)
	end
end

TimedExplosionExtension._explode = function (self)
	-- function 3
	local explosion_template = ExplosionUtils.get_template(self.explosion_template_name)
	local attacker_unit = self._unit
	local position = Unit.world_position(attacker_unit, 0)
	local rotation = Unit.world_rotation(attacker_unit, 0)
	local explosion_template_name = self.explosion_template_name
	local scale = 1
	local damage_source_2 = explosion_template.damage_source

	if not damage_source_2 then
		-- Nothing
	end

	damage_source_2 = "undefined"

	local damage_source = damage_source_2

	::label_3_0::

	local attacker_power_level = self._power

	self._state = "exploded"

	self._area_damage_system:create_explosion(attacker_unit, position, rotation, explosion_template_name, scale, damage_source, attacker_power_level, false)
	self:_invoke_on_explode_callbacks()
end

TimedExplosionExtension._invoke_on_explode_callbacks = function (self)
	-- function 4
	local position = POSITION_LOOKUP[self._unit]

	for _, callback in ipairs(self._on_explode_callbacks) do
		callback(self.explosion_template_name, position)
	end

	self._on_explode_callbacks = nil
end

TimedExplosionExtension.add_on_explode_callback = function (self, callback)
	-- function 5
	if callback ~= nil then
		table.insert(self._on_explode_callbacks, callback)
	end
end
