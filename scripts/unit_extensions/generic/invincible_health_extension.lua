-- chunkname: @scripts/unit_extensions/generic/invincible_health_extension.lua

InvincibleHealthExtension = class(InvincibleHealthExtension, GenericHealthExtension)

InvincibleHealthExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.unit = unit
	self.is_server = Managers.player.is_server
	self.system_data = extension_init_context.system_data
	self.statistics_db = extension_init_context.statistics_db
	self.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
	self.network_transmit = extension_init_context.network_transmit
	self.is_invincible = true
	self.health = NetworkConstants.health.max
	self.damage = 0
	self.state = "alive"
end

InvincibleHealthExtension.destroy = function (self)
	-- function 2
	return
end

InvincibleHealthExtension.reset = function (self)
	-- function 3
	return
end

InvincibleHealthExtension.hot_join_sync = function (self, sender)
	-- function 4
	return
end

InvincibleHealthExtension.is_alive = function (self)
	-- function 5
	return true
end

InvincibleHealthExtension.current_health_percent = function (self)
	-- function 6
	return 1
end

InvincibleHealthExtension.current_health = function (self)
	-- function 7
	return self.health
end

InvincibleHealthExtension.get_max_health = function (self)
	-- function 8
	return self.health
end

InvincibleHealthExtension.set_max_health = function (self, health, update_unmodfied)
	-- function 9
	return self.health
end

InvincibleHealthExtension.get_damage_taken = function (self)
	-- function 10
	return 0
end

InvincibleHealthExtension.set_current_damage = function (self, damage)
	-- function 11
	return
end

InvincibleHealthExtension.die = function (self, damage_type)
	-- function 12
	fassert(false, "Tried to kill InvincibleHealthExtension")
end

InvincibleHealthExtension.set_dead = function (self)
	-- function 13
	return
end

InvincibleHealthExtension.apply_client_predicted_damage = function (self, predicted_damage)
	-- function 14
	return
end
