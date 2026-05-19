-- chunkname: @scripts/unit_extensions/default_player_unit/energy/player_husk_energy_extension.lua

require("scripts/unit_extensions/default_player_unit/energy/energy_data")

PlayerHuskEnergyExtension = class(PlayerHuskEnergyExtension)

function PlayerHuskEnergyExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.unit = arg_1_2

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

function PlayerHuskEnergyExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	return
end

function PlayerHuskEnergyExtension.reset(arg_3_0)
	return
end

function PlayerHuskEnergyExtension.destroy(arg_4_0)
	return
end

function PlayerHuskEnergyExtension._update_game_object(arg_5_0)
	local var_5_0 = arg_5_0.network_manager
	local var_5_1 = arg_5_0.unit
	local var_5_2 = var_5_0:game()
	local var_5_3 = Managers.state.unit_storage:go_id(var_5_1)

	if var_5_2 and var_5_3 then
		local var_5_4 = GameSession.game_object_field(var_5_2, var_5_3, "energy_max_value")

		arg_5_0._depletion_cooldown_active = GameSession.game_object_field(var_5_2, var_5_3, "is_on_depletion_cooldown")
		arg_5_0._energy = var_5_4 * GameSession.game_object_field(var_5_2, var_5_3, "energy_percentage")
		arg_5_0._max_energy = var_5_4
	end
end

function PlayerHuskEnergyExtension._update_events(arg_6_0)
	local var_6_0 = arg_6_0._previous_can_drain
	local var_6_1 = arg_6_0:is_drainable()

	if var_6_0 ~= var_6_1 then
		if var_6_1 then
			arg_6_0:_broadcast_equipment_flow_event("on_energy_drainable")
		else
			arg_6_0:_broadcast_equipment_flow_event("on_energy_not_drainable")
		end
	end

	arg_6_0._previous_can_drain = var_6_1
end

function PlayerHuskEnergyExtension.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_0:_update_game_object()
	arg_7_0:_update_events()
end

function PlayerHuskEnergyExtension.drain(arg_8_0)
	return
end

function PlayerHuskEnergyExtension.get_max(arg_9_0)
	return arg_9_0._max_energy
end

function PlayerHuskEnergyExtension.is_drainable(arg_10_0)
	local var_10_0 = arg_10_0:is_depleted()
	local var_10_1 = arg_10_0:_is_on_depletion_cooldown()

	if var_10_0 or var_10_1 then
		return false
	end

	return true
end

function PlayerHuskEnergyExtension.is_depleted(arg_11_0)
	return arg_11_0._energy <= 0
end

function PlayerHuskEnergyExtension.get_fraction(arg_12_0)
	return math.clamp(arg_12_0._energy / arg_12_0._max_energy, 0, 1)
end

function PlayerHuskEnergyExtension._is_recharging(arg_13_0)
	return arg_13_0._recharge_delay_timer <= Managers.time:time("game")
end

function PlayerHuskEnergyExtension._is_on_depletion_cooldown(arg_14_0)
	return arg_14_0._depletion_cooldown_active
end

function PlayerHuskEnergyExtension._broadcast_equipment_flow_event(arg_15_0, arg_15_1)
	local var_15_0 = ScriptUnit.has_extension(arg_15_0.unit, "inventory_system")
	local var_15_1 = var_15_0 and var_15_0:equipment()

	if var_15_1 then
		local var_15_2 = var_15_1.right_hand_wielded_unit_3p
		local var_15_3 = var_15_1.right_hand_ammo_unit_3p
		local var_15_4 = var_15_1.right_hand_wielded_unit
		local var_15_5 = var_15_1.right_hand_ammo_unit_1p

		if var_15_2 then
			Unit.flow_event(var_15_2, arg_15_1)
		end

		if var_15_3 then
			Unit.flow_event(var_15_3, arg_15_1)
		end

		if var_15_4 then
			Unit.flow_event(var_15_4, arg_15_1)
		end

		if var_15_5 then
			Unit.flow_event(var_15_5, arg_15_1)
		end

		local var_15_6 = var_15_1.left_hand_wielded_unit_3p
		local var_15_7 = var_15_1.left_hand_ammo_unit_3p
		local var_15_8 = var_15_1.left_hand_wielded_unit
		local var_15_9 = var_15_1.left_hand_ammo_unit_1p

		if var_15_6 then
			Unit.flow_event(var_15_6, arg_15_1)
		end

		if var_15_7 then
			Unit.flow_event(var_15_7, arg_15_1)
		end

		if var_15_8 then
			Unit.flow_event(var_15_8, arg_15_1)
		end

		if var_15_9 then
			Unit.flow_event(var_15_9, arg_15_1)
		end
	end
end
