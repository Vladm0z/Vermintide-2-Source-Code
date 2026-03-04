-- chunkname: @scripts/unit_extensions/generic/invincible_health_extension.lua

InvincibleHealthExtension = class(InvincibleHealthExtension, GenericHealthExtension)

InvincibleHealthExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.system_data = arg_1_1.system_data
	arg_1_0.statistics_db = arg_1_1.statistics_db
	arg_1_0.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
	arg_1_0.network_transmit = arg_1_1.network_transmit
	arg_1_0.is_invincible = true
	arg_1_0.health = NetworkConstants.health.max
	arg_1_0.damage = 0
	arg_1_0.state = "alive"
end

InvincibleHealthExtension.destroy = function (arg_2_0)
	return
end

InvincibleHealthExtension.reset = function (arg_3_0)
	return
end

InvincibleHealthExtension.hot_join_sync = function (arg_4_0, arg_4_1)
	return
end

InvincibleHealthExtension.is_alive = function (arg_5_0)
	return true
end

InvincibleHealthExtension.current_health_percent = function (arg_6_0)
	return 1
end

InvincibleHealthExtension.current_health = function (arg_7_0)
	return arg_7_0.health
end

InvincibleHealthExtension.get_max_health = function (arg_8_0)
	return arg_8_0.health
end

InvincibleHealthExtension.set_max_health = function (arg_9_0, arg_9_1, arg_9_2)
	return arg_9_0.health
end

InvincibleHealthExtension.get_damage_taken = function (arg_10_0)
	return 0
end

InvincibleHealthExtension.set_current_damage = function (arg_11_0, arg_11_1)
	return
end

InvincibleHealthExtension.die = function (arg_12_0, arg_12_1)
	fassert(false, "Tried to kill InvincibleHealthExtension")
end

InvincibleHealthExtension.set_dead = function (arg_13_0)
	return
end

InvincibleHealthExtension.apply_client_predicted_damage = function (arg_14_0, arg_14_1)
	return
end
