-- chunkname: @scripts/unit_extensions/weapons/area_damage/timed_explosion_extension.lua

TimedExplosionExtension = class(TimedExplosionExtension)

TimedExplosionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._on_explode_callbacks = {}
	self._area_damage_system = arg_1_1.entity_manager:system("area_damage_system")
	self.explosion_template_name = arg_1_3.explosion_template_name

	local get_template = ExplosionUtils.get_template(arg_1_3.explosion_template_name)
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local get_active_wind = Managers.weave:get_active_wind()

	if not get_active_wind and not WindSettings[get_active_wind].timed_explosion_extension_settings then
		local get_active_wind_settings = Managers.weave:get_active_wind_settings()
		local get_wind_strength = Managers.weave:get_wind_strength()
		local timed_explosion_extension_settings = get_active_wind_settings.timed_explosion_extension_settings

		self._time_to_explode = timed_explosion_extension_settings.time_to_explode[get_difficulty][get_wind_strength]

		local follow_time = timed_explosion_extension_settings.follow_time

		follow_time = not follow_time and timed_explosion_extension_settings.follow_time[get_difficulty][get_wind_strength]
		self._follow_time = follow_time

		local var_1_7

		if not get_active_wind_settings.radius then
			var_1_7 = get_active_wind_settings.radius[get_difficulty][get_wind_strength]

			if not var_1_7 then
				-- Nothing
			end
		end

		var_1_7 = 1

		::label_1_0::

		self._scale = var_1_7

		local var_1_8

		if not get_active_wind_settings.power_level then
			var_1_8 = get_active_wind_settings.power_level[get_difficulty][get_wind_strength]

			if not var_1_8 then
				-- Nothing
			end
		end

		var_1_8 = 0

		::label_1_1::

		self._power = var_1_8

		local num = self._time_to_explode + self._follow_time
		local buildup_effect_time = get_template.explosion.buildup_effect_time

		buildup_effect_time = buildup_effect_time or 0
		self._buildup_effect_delay = num - buildup_effect_time
	else
		local time_to_explode = get_template.time_to_explode

		time_to_explode = time_to_explode or 0
		self._time_to_explode = time_to_explode

		local unit_scale = get_template.explosion.unit_scale

		if not unit_scale then
			unit_scale = get_template.explosion.radius
			unit_scale = unit_scale or 1
		end

		self._scale = unit_scale

		local follow_time_2 = get_template.follow_time

		follow_time_2 = follow_time_2 or 0
		self._follow_time = follow_time_2

		local power_level = get_template.explosion.power_level

		power_level = power_level or 0
		self._power = power_level

		local num_2 = self._time_to_explode + self._follow_time
		local buildup_effect_time_2 = get_template.explosion.buildup_effect_time

		buildup_effect_time_2 = buildup_effect_time_2 or 0
		self._buildup_effect_delay = num_2 - buildup_effect_time_2
	end

	self._buildup_effect_offset = get_template.explosion.buildup_effect_offset
	self._buildup_effect = get_template.explosion.buildup_effect_name
	self._use_effect = self._buildup_effect ~= nil
	self.is_server = Managers.player.is_server
	self.follow_unit = arg_1_3.follow_unit
	self.trigger_on_server_only = get_template.explosion.trigger_on_server_only

	if not self._scale then
		Unit.set_local_scale(arg_1_2, 0, Vector3(self._scale * 1.25, self._scale * 1.25, self._scale * 1.25))
	end

	if not self.follow_unit then
		self._state = "follow_unit"
	else
		self._state = "waiting_to_explode"
	end

	local deletion_timer = get_template.explosion.deletion_timer

	deletion_timer = deletion_timer or 1
	self._deletion_timer = deletion_timer
end

TimedExplosionExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local _state = self._state

	if not self._buildup_effect then
		self._buildup_effect_delay = math.max(self._buildup_effect_delay - arg_2_3, 0)

		if not (self._buildup_effect_delay <= 0) or not self._use_effect then
			self._use_effect = false

			local copy = Vector3.copy(POSITION_LOOKUP[arg_2_1])

			if not self._buildup_effect_offset then
				local var_2_2 = Vector3(unpack(self._buildup_effect_offset))

				copy.x = copy.x + var_2_2.x
				copy.y = copy.y + var_2_2.y
				copy.z = copy.z + var_2_2.z
			end

			self._fx_id = World.create_particles(arg_2_4.world, self._buildup_effect, copy)
		end
	end

	if _state == "waiting_to_explode" then
		self._time_to_explode = math.max(self._time_to_explode - arg_2_3, 0)

		if not (self._time_to_explode ~= 0 or self.is_server or self.trigger_on_server_only) then
			self:_explode()
		end
	elseif _state == "follow_unit" then
		if not Unit.alive(self.follow_unit) then
			self._follow_time = math.max(self._follow_time - arg_2_3, 0)

			local local_position = Unit.local_position(self.follow_unit, 0)

			Unit.set_local_position(arg_2_1, 0, local_position)

			if self._follow_time == 0 then
				Unit.flow_event(arg_2_1, "disable_rotation")

				self._state = "waiting_to_explode"
			end
		else
			self._state = "waiting_to_explode"
		end
	elseif _state == "exploded" then
		self._deletion_timer = math.max(self._deletion_timer - arg_2_3, 0)

		if self._deletion_timer == 0 then
			Managers.state.side:remove_unit_from_side(arg_2_1)
			Managers.state.unit_spawner:mark_for_deletion(arg_2_1)

			if not self._buildup_effect and not self._fx_id then
				World.destroy_particles(arg_2_4.world, self._fx_id)
			end

			self._state = "waiting_for_deletion"
		end
	elseif _state == "waiting_for_deletion" then
		-- Nothing
	else
		ferror("Unknown state (%s)", _state)
	end
end

TimedExplosionExtension._explode = function (self)
	-- function 3
	local get_template = ExplosionUtils.get_template(self.explosion_template_name)
	local _unit = self._unit
	local world_position = Unit.world_position(_unit, 0)
	local world_rotation = Unit.world_rotation(_unit, 0)
	local explosion_template_name = self.explosion_template_name
	local num = 1
	local damage_source = get_template.damage_source

	damage_source = damage_source or "undefined"

	local _power = self._power

	self._state = "exploded"

	self._area_damage_system:create_explosion(_unit, world_position, world_rotation, explosion_template_name, num, damage_source, _power, false)
	self:_invoke_on_explode_callbacks()
end

TimedExplosionExtension._invoke_on_explode_callbacks = function (self)
	-- function 4
	local var_4_0 = POSITION_LOOKUP[self._unit]

	for i, v in ipairs(self._on_explode_callbacks) do
		v(self.explosion_template_name, var_4_0)
	end

	self._on_explode_callbacks = nil
end

TimedExplosionExtension.add_on_explode_callback = function (self, arg_5_1)
	-- function 5
	if arg_5_1 ~= nil then
		table.insert(self._on_explode_callbacks, arg_5_1)
	end
end
