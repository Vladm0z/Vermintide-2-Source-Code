-- chunkname: @scripts/unit_extensions/default_player_unit/energy/player_unit_energy_extension.lua

require("scripts/unit_extensions/default_player_unit/energy/energy_data")

PlayerUnitEnergyExtension = class(PlayerUnitEnergyExtension)

PlayerUnitEnergyExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.network_manager = Managers.state.network

	local energy_data = arg_1_3.energy_data
	local max_value = energy_data.max_value

	max_value = max_value or 40
	self._max_energy = max_value
	self._energy = self._max_energy
	self._recharge_delay_timer = 0

	local recharge_delay = energy_data.recharge_delay

	recharge_delay = recharge_delay or 0
	self._recharge_delay = recharge_delay

	local recharge_rate = energy_data.recharge_rate

	recharge_rate = recharge_rate or 0
	self._recharge_rate = recharge_rate
	self._depletion_cooldown_timer = 0

	local depletion_cooldown = energy_data.depletion_cooldown

	depletion_cooldown = depletion_cooldown or 0
	self._depletion_cooldown = depletion_cooldown
	self._previous_can_drain = self:is_drainable()
end

PlayerUnitEnergyExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return
end

PlayerUnitEnergyExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

PlayerUnitEnergyExtension._update_game_object = function (self)
	-- function 4
	local network_manager = self.network_manager
	local unit = self.unit
	local game = network_manager:game()
	local go_id = Managers.state.unit_storage:go_id(unit)

	if not game and not go_id then
		local get_fraction = self:get_fraction()
		local get_max = self:get_max()
		local is_on_depletion_cooldown = self:is_on_depletion_cooldown()

		fassert(not (get_max >= NetworkConstants.max_energy.min) or get_max <= NetworkConstants.max_energy.max, "Max energy outside value bounds allowed by network variable!")
		GameSession.set_game_object_field(game, go_id, "energy_percentage", get_fraction)
		GameSession.set_game_object_field(game, go_id, "energy_max_value", get_max)
		GameSession.set_game_object_field(game, go_id, "is_on_depletion_cooldown", is_on_depletion_cooldown)
	end
end

PlayerUnitEnergyExtension._update_events = function (self)
	-- function 5
	local _previous_can_drain = self._previous_can_drain
	local is_drainable = self:is_drainable()

	if _previous_can_drain ~= is_drainable then
		if not is_drainable then
			self:_broadcast_equipment_flow_event("on_energy_drainable")
		else
			self:_broadcast_equipment_flow_event("on_energy_not_drainable")
		end
	end

	self._previous_can_drain = is_drainable
end

PlayerUnitEnergyExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local var_6_0 = ALIVE[arg_6_1]

	var_6_0 = not var_6_0 and ScriptUnit.has_extension(arg_6_1, "buff_system")

	if not var_6_0 and not var_6_0:has_buff_type("twitch_no_overcharge_no_ammo_reloads") then
		self._energy = self._max_energy
		self._depletion_cooldown_timer = 0
	end

	if not self:_is_recharging() then
		self:_process_recharge(arg_6_3, arg_6_5)
	end

	if not self:is_depleted() then
		self:_start_depletion(arg_6_3, arg_6_5)
	end

	self:_update_game_object()
	self:_update_events()
end

PlayerUnitEnergyExtension.drain = function (self, arg_7_1)
	-- function 7
	assert(arg_7_1 >= 0, "Use add_energy()")

	local has_extension = ScriptUnit.has_extension(self.unit, "buff_system")

	if not has_extension then
		if not has_extension:has_buff_perk("infinite_ammo") then
			arg_7_1 = 0
		end

		arg_7_1 = arg_7_1 * has_extension:apply_buffs_to_value(1, "ammo_used_multiplier")
	end

	local _energy = self._energy
	local num = _energy - arg_7_1

	self._energy = math.clamp(num, 0, _energy)
	self._recharge_delay_timer = Managers.time:time("game") + self._recharge_delay
end

PlayerUnitEnergyExtension.add_energy = function (self, arg_8_1)
	-- function 8
	assert(arg_8_1 >= 0, "Use drain()")

	local num = self._energy + arg_8_1
	local _max_energy = self._max_energy

	self._energy = math.clamp(num, 0, _max_energy)
end

PlayerUnitEnergyExtension.get_max = function (self)
	-- function 9
	return self._max_energy
end

PlayerUnitEnergyExtension.is_drainable = function (self)
	-- function 10
	local is_depleted = self:is_depleted()
	local is_on_depletion_cooldown = self:is_on_depletion_cooldown()

	if is_depleted or not is_on_depletion_cooldown then
		return false
	end

	return true
end

PlayerUnitEnergyExtension.is_depleted = function (self)
	-- function 11
	return self._energy <= 0
end

PlayerUnitEnergyExtension.get_fraction = function (self)
	-- function 12
	return math.clamp(self._energy / self._max_energy, 0, 1)
end

PlayerUnitEnergyExtension._start_depletion = function (self, arg_13_1, arg_13_2)
	-- function 13
	self._depletion_cooldown_timer = self._depletion_cooldown + arg_13_2
end

PlayerUnitEnergyExtension._process_recharge = function (self, arg_14_1, arg_14_2)
	-- function 14
	self._energy = math.clamp(self._energy + self._recharge_rate * arg_14_1, 0, self._max_energy)
end

PlayerUnitEnergyExtension.is_on_depletion_cooldown = function (self)
	-- function 15
	return self._depletion_cooldown_timer > Managers.time:time("game")
end

PlayerUnitEnergyExtension._is_recharging = function (self)
	-- function 16
	return self._recharge_delay_timer <= Managers.time:time("game")
end

PlayerUnitEnergyExtension._broadcast_equipment_flow_event = function (self, arg_17_1)
	-- function 17
	local has_extension = ScriptUnit.has_extension(self.unit, "inventory_system")
	local flag = not has_extension and has_extension:equipment()

	if not flag then
		local right_hand_wielded_unit_3p = flag.right_hand_wielded_unit_3p
		local right_hand_ammo_unit_3p = flag.right_hand_ammo_unit_3p
		local right_hand_wielded_unit = flag.right_hand_wielded_unit
		local right_hand_ammo_unit_1p = flag.right_hand_ammo_unit_1p

		if not right_hand_wielded_unit_3p then
			Unit.flow_event(right_hand_wielded_unit_3p, arg_17_1)
		end

		if not right_hand_ammo_unit_3p then
			Unit.flow_event(right_hand_ammo_unit_3p, arg_17_1)
		end

		if not right_hand_wielded_unit then
			Unit.flow_event(right_hand_wielded_unit, arg_17_1)
		end

		if not right_hand_ammo_unit_1p then
			Unit.flow_event(right_hand_ammo_unit_1p, arg_17_1)
		end

		local left_hand_wielded_unit_3p = flag.left_hand_wielded_unit_3p
		local left_hand_ammo_unit_3p = flag.left_hand_ammo_unit_3p
		local left_hand_wielded_unit = flag.left_hand_wielded_unit
		local left_hand_ammo_unit_1p = flag.left_hand_ammo_unit_1p

		if not left_hand_wielded_unit_3p then
			Unit.flow_event(left_hand_wielded_unit_3p, arg_17_1)
		end

		if not left_hand_ammo_unit_3p then
			Unit.flow_event(left_hand_ammo_unit_3p, arg_17_1)
		end

		if not left_hand_wielded_unit then
			Unit.flow_event(left_hand_wielded_unit, arg_17_1)
		end

		if not left_hand_ammo_unit_1p then
			Unit.flow_event(left_hand_ammo_unit_1p, arg_17_1)
		end
	end
end
