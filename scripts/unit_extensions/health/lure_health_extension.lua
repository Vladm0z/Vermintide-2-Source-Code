-- chunkname: @scripts/unit_extensions/health/lure_health_extension.lua

LureHealthExtension = class(LureHealthExtension)

LureHealthExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._is_server = Managers.player.is_server
	arg_1_0._attached_unit = arg_1_3.attached_unit
	arg_1_0._lifetime = Managers.time:time("game") + arg_1_3.duration
	arg_1_0.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._is_dead = false
end

LureHealthExtension.destroy = function (arg_2_0)
	return
end

LureHealthExtension.hot_join_sync = function (arg_3_0, arg_3_1)
	return
end

LureHealthExtension.is_alive = function (arg_4_0)
	return not arg_4_0._is_dead
end

LureHealthExtension.current_health_percent = function (arg_5_0)
	return arg_5_0._is_dead and 0 or 1
end

LureHealthExtension.current_health = function (arg_6_0)
	return 1
end

LureHealthExtension.get_damage_taken = function (arg_7_0)
	return 0
end

LureHealthExtension.get_max_health = function (arg_8_0)
	return 1
end

LureHealthExtension.add_damage = function (arg_9_0, ...)
	if arg_9_0._is_server and not arg_9_0._is_dead and Unit.alive(arg_9_0._attached_unit) then
		ScriptUnit.extension(arg_9_0._attached_unit, "health_system"):add_damage(...)
	end
end

LureHealthExtension.update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_0._is_server and not arg_10_0._is_dead and arg_10_3 > arg_10_0._lifetime then
		Managers.state.entity:system("death_system"):kill_unit(arg_10_0._unit, {})
	end
end

LureHealthExtension.add_heal = function (arg_11_0, ...)
	return
end

LureHealthExtension.set_dead = function (arg_12_0)
	arg_12_0._is_dead = true
	HEALTH_ALIVE[arg_12_0._unit] = nil
end

LureHealthExtension.has_assist_shield = function (arg_13_0)
	return false
end

LureHealthExtension.client_predicted_is_alive = function (arg_14_0)
	return arg_14_0:is_alive()
end

LureHealthExtension.apply_client_predicted_damage = function (arg_15_0, arg_15_1)
	return
end
