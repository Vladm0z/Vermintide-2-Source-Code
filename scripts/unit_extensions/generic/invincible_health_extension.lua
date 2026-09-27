-- chunkname: @scripts/unit_extensions/generic/invincible_health_extension.lua

InvincibleHealthExtension = class(InvincibleHealthExtension, GenericHealthExtension)

InvincibleHealthExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.is_server = Managers.player.is_server
	self.system_data = arg_1_1.system_data
	self.statistics_db = arg_1_1.statistics_db
	self.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
	self.network_transmit = arg_1_1.network_transmit
	self.is_invincible = true
	self.health = NetworkConstants.health.max
	self.damage = 0
	self.state = "alive"
end

InvincibleHealthExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

InvincibleHealthExtension.reset = function (arg_3_0)
	-- function 3
	return
end

InvincibleHealthExtension.hot_join_sync = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

InvincibleHealthExtension.is_alive = function (arg_5_0)
	-- function 5
	return true
end

InvincibleHealthExtension.current_health_percent = function (arg_6_0)
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

InvincibleHealthExtension.set_max_health = function (self, arg_9_1, arg_9_2)
	-- function 9
	return self.health
end

InvincibleHealthExtension.get_damage_taken = function (arg_10_0)
	-- function 10
	return 0
end

InvincibleHealthExtension.set_current_damage = function (arg_11_0, arg_11_1)
	-- function 11
	return
end

InvincibleHealthExtension.die = function (arg_12_0, arg_12_1)
	-- function 12
	fassert(false, "Tried to kill InvincibleHealthExtension")
end

InvincibleHealthExtension.set_dead = function (arg_13_0)
	-- function 13
	return
end

InvincibleHealthExtension.apply_client_predicted_damage = function (arg_14_0, arg_14_1)
	-- function 14
	return
end
