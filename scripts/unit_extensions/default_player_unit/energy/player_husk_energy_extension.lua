-- chunkname: @scripts/unit_extensions/default_player_unit/energy/player_husk_energy_extension.lua

require("scripts/unit_extensions/default_player_unit/energy/energy_data")

PlayerHuskEnergyExtension = class(PlayerHuskEnergyExtension)

PlayerHuskEnergyExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.network_manager = Managers.state.network
	self.unit = arg_1_2

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

PlayerHuskEnergyExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return
end

PlayerHuskEnergyExtension.reset = function (arg_3_0)
	-- function 3
	return
end

PlayerHuskEnergyExtension.destroy = function (arg_4_0)
	-- function 4
	return
end

PlayerHuskEnergyExtension._update_game_object = function (self)
	-- function 5
	local network_manager = self.network_manager
	local unit = self.unit
	local game = network_manager:game()
	local go_id = Managers.state.unit_storage:go_id(unit)

	if not game and not go_id then
		local game_object_field = GameSession.game_object_field(game, go_id, "energy_max_value")

		self._depletion_cooldown_active = GameSession.game_object_field(game, go_id, "is_on_depletion_cooldown")
		self._energy = game_object_field * GameSession.game_object_field(game, go_id, "energy_percentage")
		self._max_energy = game_object_field
	end
end

PlayerHuskEnergyExtension._update_events = function (self)
	-- function 6
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

PlayerHuskEnergyExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	self:_update_game_object()
	self:_update_events()
end

PlayerHuskEnergyExtension.drain = function (arg_8_0)
	-- function 8
	return
end

PlayerHuskEnergyExtension.get_max = function (self)
	-- function 9
	return self._max_energy
end

PlayerHuskEnergyExtension.is_drainable = function (self)
	-- function 10
	local is_depleted = self:is_depleted()
	local _is_on_depletion_cooldown = self:_is_on_depletion_cooldown()

	if is_depleted or not _is_on_depletion_cooldown then
		return false
	end

	return true
end

PlayerHuskEnergyExtension.is_depleted = function (self)
	-- function 11
	return self._energy <= 0
end

PlayerHuskEnergyExtension.get_fraction = function (self)
	-- function 12
	return math.clamp(self._energy / self._max_energy, 0, 1)
end

PlayerHuskEnergyExtension._is_recharging = function (self)
	-- function 13
	return self._recharge_delay_timer <= Managers.time:time("game")
end

PlayerHuskEnergyExtension._is_on_depletion_cooldown = function (self)
	-- function 14
	return self._depletion_cooldown_active
end

PlayerHuskEnergyExtension._broadcast_equipment_flow_event = function (self, arg_15_1)
	-- function 15
	local has_extension = ScriptUnit.has_extension(self.unit, "inventory_system")
	local flag = not has_extension and has_extension:equipment()

	if not flag then
		local right_hand_wielded_unit_3p = flag.right_hand_wielded_unit_3p
		local right_hand_ammo_unit_3p = flag.right_hand_ammo_unit_3p
		local right_hand_wielded_unit = flag.right_hand_wielded_unit
		local right_hand_ammo_unit_1p = flag.right_hand_ammo_unit_1p

		if not right_hand_wielded_unit_3p then
			Unit.flow_event(right_hand_wielded_unit_3p, arg_15_1)
		end

		if not right_hand_ammo_unit_3p then
			Unit.flow_event(right_hand_ammo_unit_3p, arg_15_1)
		end

		if not right_hand_wielded_unit then
			Unit.flow_event(right_hand_wielded_unit, arg_15_1)
		end

		if not right_hand_ammo_unit_1p then
			Unit.flow_event(right_hand_ammo_unit_1p, arg_15_1)
		end

		local left_hand_wielded_unit_3p = flag.left_hand_wielded_unit_3p
		local left_hand_ammo_unit_3p = flag.left_hand_ammo_unit_3p
		local left_hand_wielded_unit = flag.left_hand_wielded_unit
		local left_hand_ammo_unit_1p = flag.left_hand_ammo_unit_1p

		if not left_hand_wielded_unit_3p then
			Unit.flow_event(left_hand_wielded_unit_3p, arg_15_1)
		end

		if not left_hand_ammo_unit_3p then
			Unit.flow_event(left_hand_ammo_unit_3p, arg_15_1)
		end

		if not left_hand_wielded_unit then
			Unit.flow_event(left_hand_wielded_unit, arg_15_1)
		end

		if not left_hand_ammo_unit_1p then
			Unit.flow_event(left_hand_ammo_unit_1p, arg_15_1)
		end
	end
end
