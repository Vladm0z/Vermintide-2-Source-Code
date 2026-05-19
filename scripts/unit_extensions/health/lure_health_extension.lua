-- chunkname: @scripts/unit_extensions/health/lure_health_extension.lua

LureHealthExtension = class(LureHealthExtension)

function LureHealthExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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

function LureHealthExtension.destroy(arg_2_0)
	return
end

function LureHealthExtension.hot_join_sync(arg_3_0, arg_3_1)
	return
end

function LureHealthExtension.is_alive(arg_4_0)
	return not arg_4_0._is_dead
end

function LureHealthExtension.current_health_percent(arg_5_0)
	return arg_5_0._is_dead and 0 or 1
end

function LureHealthExtension.current_health(arg_6_0)
	return 1
end

function LureHealthExtension.get_damage_taken(arg_7_0)
	return 0
end

function LureHealthExtension.get_max_health(arg_8_0)
	return 1
end

function LureHealthExtension.add_damage(arg_9_0, ...)
	if arg_9_0._is_server and not arg_9_0._is_dead and Unit.alive(arg_9_0._attached_unit) then
		ScriptUnit.extension(arg_9_0._attached_unit, "health_system"):add_damage(...)
	end
end

function LureHealthExtension.update(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_0._is_server and not arg_10_0._is_dead and arg_10_3 > arg_10_0._lifetime then
		Managers.state.entity:system("death_system"):kill_unit(arg_10_0._unit, {})
	end
end

function LureHealthExtension.add_heal(arg_11_0, ...)
	return
end

function LureHealthExtension.set_dead(arg_12_0)
	arg_12_0._is_dead = true
	HEALTH_ALIVE[arg_12_0._unit] = nil
end

function LureHealthExtension.has_assist_shield(arg_13_0)
	return false
end

function LureHealthExtension.client_predicted_is_alive(arg_14_0)
	return arg_14_0:is_alive()
end

function LureHealthExtension.apply_client_predicted_damage(arg_15_0, arg_15_1)
	return
end
