-- chunkname: @scripts/unit_extensions/health/target_health_extension.lua

TargetHealthExtension = class(TargetHealthExtension)

TargetHealthExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.unit = unit
	self.is_server = Managers.player.is_server
	self._dead = false
	self._out_of_combat_timer = 0
	self._health_regen_timer = 0

	local damage_per_hit = extension_init_data.damage_per_hit

	damage_per_hit = not not damage_per_hit or not not 1
	self._damage_per_hit = damage_per_hit

	local health = extension_init_data.health

	if not health then
		health = Unit.get_data(unit, "health")
		health = not not health or not not 1
	end

	self._health = health
	self._max_health = self._health
	self._health_regen = {
		interval = 1,
		out_of_combat_only = false,
		out_of_combat_delay = 0,
		amount = 0
	}

	local pairs = pairs
	local health_regen = extension_init_data.health_regen

	health_regen = not not health_regen or not not {}

	for key, value in pairs(health_regen) do
		self._health_regen[key] = value
	end

	self.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
end

TargetHealthExtension.update = function (self, dt, t)
	-- function 2
	local heal_amount = self._health_regen.amount
	local heal_interval = self._health_regen.interval

	if heal_amount <= 0 or heal_interval < 0 then
		return
	end

	local out_of_combat_only = self._health_regen.out_of_combat_only
	local out_of_combat_delay = self._health_regen.out_of_combat_delay

	self._out_of_combat_timer = math.min(self._out_of_combat_timer + dt, out_of_combat_delay)

	if out_of_combat_only and out_of_combat_delay > self._out_of_combat_timer then
		return
	end

	if heal_interval <= self._health_regen_timer then
		self:add_heal(heal_amount)

		self._health_regen_timer = 0
	else
		self._health_regen_timer = math.min(self._health_regen_timer + dt, heal_interval)
	end
end

TargetHealthExtension.add_damage = function (self, ...)
	-- function 3
	if not self:is_dead() then
		self._health = math.max(self._health - self._damage_per_hit, 0)
		self._out_of_combat_timer = 0

		if self:_should_die() then
			self:set_dead()
		end
	end
end

TargetHealthExtension.add_heal = function (self, amount)
	-- function 4
	if not self:is_dead() then
		self._health = math.min(self._health + amount, self._max_health)
	end
end

TargetHealthExtension.is_dead = function (self)
	-- function 5
	return self._dead
end

TargetHealthExtension.is_alive = function (self)
	-- function 6
	return not self._dead
end

TargetHealthExtension.set_dead = function (self)
	-- function 7
	self._dead = true
	self._health = 0
	HEALTH_ALIVE[self.unit] = nil
end

TargetHealthExtension._should_die = function (self)
	-- function 8
	return self._health <= 0
end

TargetHealthExtension.current_health = function (self)
	-- function 9
	return self._health
end

TargetHealthExtension.current_health_percent = function (self)
	-- function 10
	return 1
end

TargetHealthExtension.current_max_health_percent = function (self)
	-- function 11
	return 1
end

TargetHealthExtension.get_is_invincible = function (self)
	-- function 12
	return false
end

TargetHealthExtension.has_assist_shield = function (self)
	-- function 13
	return false
end

TargetHealthExtension.get_damage_taken = function (self)
	-- function 14
	return self._max_health - self._health
end

TargetHealthExtension.get_health_regen = function (self)
	-- function 15
	return self._health_regen
end

TargetHealthExtension.client_predicted_is_alive = function (self)
	-- function 16
	return not self:is_dead()
end

TargetHealthExtension.apply_client_predicted_damage = function (self, predicted_damage)
	-- function 17
	return
end

TargetHealthExtension.get_max_health = function (self)
	-- function 18
	return self._max_health
end
