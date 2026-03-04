-- chunkname: @scripts/unit_extensions/default_player_unit/energy/player_unit_energy_extension.lua

require("scripts/unit_extensions/default_player_unit/energy/energy_data")

PlayerUnitEnergyExtension = class(PlayerUnitEnergyExtension)

PlayerUnitEnergyExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.network_manager = Managers.state.network

	local var_1_0 = arg_1_3.energy_data

	arg_1_0._max_energy = var_1_0.max_value or 40
	arg_1_0._energy = arg_1_0._max_energy
	arg_1_0._recharge_delay_timer = 0
	arg_1_0._recharge_delay = var_1_0.recharge_delay or 0
	arg_1_0._recharge_rate = var_1_0.recharge_rate or 0
	arg_1_0._depletion_cooldown_timer = 0
	arg_1_0._depletion_cooldown = var_1_0.depletion_cooldown or 0
	arg_1_0._previous_can_drain = arg_1_0:is_drainable()
end

PlayerUnitEnergyExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	return
end

PlayerUnitEnergyExtension.destroy = function (arg_3_0)
	return
end

PlayerUnitEnergyExtension._update_game_object = function (arg_4_0)
	local var_4_0 = arg_4_0.network_manager
	local var_4_1 = arg_4_0.unit
	local var_4_2 = var_4_0:game()
	local var_4_3 = Managers.state.unit_storage:go_id(var_4_1)

	if var_4_2 and var_4_3 then
		local var_4_4 = arg_4_0:get_fraction()
		local var_4_5 = arg_4_0:get_max()
		local var_4_6 = arg_4_0:_is_on_depletion_cooldown()

		fassert(var_4_5 >= NetworkConstants.max_energy.min and var_4_5 <= NetworkConstants.max_energy.max, "Max energy outside value bounds allowed by network variable!")
		GameSession.set_game_object_field(var_4_2, var_4_3, "energy_percentage", var_4_4)
		GameSession.set_game_object_field(var_4_2, var_4_3, "energy_max_value", var_4_5)
		GameSession.set_game_object_field(var_4_2, var_4_3, "is_on_depletion_cooldown", var_4_6)
	end
end

PlayerUnitEnergyExtension._update_events = function (arg_5_0)
	local var_5_0 = arg_5_0._previous_can_drain
	local var_5_1 = arg_5_0:is_drainable()

	if var_5_0 ~= var_5_1 then
		if var_5_1 then
			arg_5_0:_broadcast_equipment_flow_event("on_energy_drainable")
		else
			arg_5_0:_broadcast_equipment_flow_event("on_energy_not_drainable")
		end
	end

	arg_5_0._previous_can_drain = var_5_1
end

PlayerUnitEnergyExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = ALIVE[arg_6_1] and ScriptUnit.has_extension(arg_6_1, "buff_system")

	if var_6_0 and var_6_0:has_buff_type("twitch_no_overcharge_no_ammo_reloads") then
		arg_6_0._energy = arg_6_0._max_energy
		arg_6_0._depletion_cooldown_timer = 0
	end

	if arg_6_0:_is_recharging() then
		arg_6_0:_process_recharge(arg_6_3, arg_6_5)
	end

	if arg_6_0:is_depleted() then
		arg_6_0:_start_depletion(arg_6_3, arg_6_5)
	end

	arg_6_0:_update_game_object()
	arg_6_0:_update_events()
end

PlayerUnitEnergyExtension.drain = function (arg_7_0, arg_7_1)
	assert(arg_7_1 >= 0, "Use add_energy()")

	local var_7_0 = ScriptUnit.has_extension(arg_7_0.unit, "buff_system")

	if var_7_0 then
		if var_7_0:has_buff_perk("infinite_ammo") then
			arg_7_1 = 0
		end

		arg_7_1 = arg_7_1 * var_7_0:apply_buffs_to_value(1, "ammo_used_multiplier")
	end

	local var_7_1 = arg_7_0._energy
	local var_7_2 = var_7_1 - arg_7_1

	arg_7_0._energy = math.clamp(var_7_2, 0, var_7_1)
	arg_7_0._recharge_delay_timer = Managers.time:time("game") + arg_7_0._recharge_delay
end

PlayerUnitEnergyExtension.add_energy = function (arg_8_0, arg_8_1)
	assert(arg_8_1 >= 0, "Use drain()")

	local var_8_0 = arg_8_0._energy + arg_8_1
	local var_8_1 = arg_8_0._max_energy

	arg_8_0._energy = math.clamp(var_8_0, 0, var_8_1)
end

PlayerUnitEnergyExtension.get_max = function (arg_9_0)
	return arg_9_0._max_energy
end

PlayerUnitEnergyExtension.is_drainable = function (arg_10_0)
	local var_10_0 = arg_10_0:is_depleted()
	local var_10_1 = arg_10_0:_is_on_depletion_cooldown()

	if var_10_0 or var_10_1 then
		return false
	end

	return true
end

PlayerUnitEnergyExtension.is_depleted = function (arg_11_0)
	return arg_11_0._energy <= 0
end

PlayerUnitEnergyExtension.get_fraction = function (arg_12_0)
	return math.clamp(arg_12_0._energy / arg_12_0._max_energy, 0, 1)
end

PlayerUnitEnergyExtension._start_depletion = function (arg_13_0, arg_13_1, arg_13_2)
	arg_13_0._depletion_cooldown_timer = arg_13_0._depletion_cooldown + arg_13_2
end

PlayerUnitEnergyExtension._process_recharge = function (arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._energy = math.clamp(arg_14_0._energy + arg_14_0._recharge_rate * arg_14_1, 0, arg_14_0._max_energy)
end

PlayerUnitEnergyExtension._is_on_depletion_cooldown = function (arg_15_0)
	return arg_15_0._depletion_cooldown_timer > Managers.time:time("game")
end

PlayerUnitEnergyExtension._is_recharging = function (arg_16_0)
	return arg_16_0._recharge_delay_timer <= Managers.time:time("game")
end

PlayerUnitEnergyExtension._broadcast_equipment_flow_event = function (arg_17_0, arg_17_1)
	local var_17_0 = ScriptUnit.has_extension(arg_17_0.unit, "inventory_system")
	local var_17_1 = var_17_0 and var_17_0:equipment()

	if var_17_1 then
		local var_17_2 = var_17_1.right_hand_wielded_unit_3p
		local var_17_3 = var_17_1.right_hand_ammo_unit_3p
		local var_17_4 = var_17_1.right_hand_wielded_unit
		local var_17_5 = var_17_1.right_hand_ammo_unit_1p

		if var_17_2 then
			Unit.flow_event(var_17_2, arg_17_1)
		end

		if var_17_3 then
			Unit.flow_event(var_17_3, arg_17_1)
		end

		if var_17_4 then
			Unit.flow_event(var_17_4, arg_17_1)
		end

		if var_17_5 then
			Unit.flow_event(var_17_5, arg_17_1)
		end

		local var_17_6 = var_17_1.left_hand_wielded_unit_3p
		local var_17_7 = var_17_1.left_hand_ammo_unit_3p
		local var_17_8 = var_17_1.left_hand_wielded_unit
		local var_17_9 = var_17_1.left_hand_ammo_unit_1p

		if var_17_6 then
			Unit.flow_event(var_17_6, arg_17_1)
		end

		if var_17_7 then
			Unit.flow_event(var_17_7, arg_17_1)
		end

		if var_17_8 then
			Unit.flow_event(var_17_8, arg_17_1)
		end

		if var_17_9 then
			Unit.flow_event(var_17_9, arg_17_1)
		end
	end
end
