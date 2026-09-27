-- chunkname: @scripts/unit_extensions/health/lure_health_extension.lua

LureHealthExtension = class(LureHealthExtension)

LureHealthExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._is_server = Managers.player.is_server
	self._attached_unit = arg_1_3.attached_unit
	self._lifetime = Managers.time:time("game") + arg_1_3.duration
	self.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
	self._network_transmit = arg_1_1.network_transmit
	self._is_dead = false
end

LureHealthExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

LureHealthExtension.hot_join_sync = function (arg_3_0, arg_3_1)
	-- function 3
	return
end

LureHealthExtension.is_alive = function (self)
	-- function 4
	return not self._is_dead
end

LureHealthExtension.current_health_percent = function (self)
	-- function 5
	local flag

	flag = not self._is_dead and 0 and 1

	return flag
end

LureHealthExtension.current_health = function (arg_6_0)
	-- function 6
	return 1
end

LureHealthExtension.get_damage_taken = function (arg_7_0)
	-- function 7
	return 0
end

LureHealthExtension.get_max_health = function (arg_8_0)
	-- function 8
	return 1
end

LureHealthExtension.add_damage = function (self, ...)
	-- function 9
	if not self._is_server and self._is_dead or not Unit.alive(self._attached_unit) then
		ScriptUnit.extension(self._attached_unit, "health_system"):add_damage(...)
	end
end

LureHealthExtension.update = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not (not self._is_server and self._is_dead or not (arg_10_3 > self._lifetime)) then
		Managers.state.entity:system("death_system"):kill_unit(self._unit, {})
	end
end

LureHealthExtension.add_heal = function (arg_11_0, ...)
	-- function 11
	return
end

LureHealthExtension.set_dead = function (self)
	-- function 12
	self._is_dead = true
	HEALTH_ALIVE[self._unit] = nil
end

LureHealthExtension.has_assist_shield = function (arg_13_0)
	-- function 13
	return false
end

LureHealthExtension.client_predicted_is_alive = function (self)
	-- function 14
	return self:is_alive()
end

LureHealthExtension.apply_client_predicted_damage = function (arg_15_0, arg_15_1)
	-- function 15
	return
end
