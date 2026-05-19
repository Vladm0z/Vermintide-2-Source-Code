-- chunkname: @scripts/settings/dlcs/cog/action_charged_sweep.lua

ActionChargedSweep = class(ActionChargedSweep, ActionSweep)

function ActionChargedSweep.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionChargedSweep.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	local var_1_0 = ScriptUnit.extension(arg_1_4, "overcharge_system")

	arg_1_0.overcharge_level_map = {
		var_1_0.overcharge_threshold,
		var_1_0.overcharge_limit,
		var_1_0.overcharge_critical_limit
	}
	arg_1_0.overcharge_map_size = #arg_1_0.overcharge_level_map
	arg_1_0.overcharge_extension = var_1_0
end

function ActionChargedSweep.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}
	arg_2_0._overcharge_type = nil
	arg_2_0._consume_overcharge = false

	local var_2_0
	local var_2_1 = arg_2_0.overcharge_extension

	if arg_2_1.discharge_attack then
		local var_2_2 = var_2_1:get_overcharge_value()
		local var_2_3 = arg_2_0:get_overcharge_level(var_2_2)

		var_2_0 = arg_2_0:get_discharge_effect(arg_2_1, var_2_3)

		if var_2_0 then
			arg_2_4 = arg_2_4 * (var_2_0.overcharge_power_mult or 1)
			arg_2_0._overcharge_type = var_2_0.consume_overcharge_type
			arg_2_0._consume_overcharge = true
		end
	else
		arg_2_0._overcharge_type = arg_2_1.overcharge_type
	end

	arg_2_0._discharge_effect = var_2_0
	arg_2_0._overcharge_on_swing = arg_2_1.overcharge_on_swing

	if arg_2_1.overcharge_on_swing then
		arg_2_0:_apply_overcharge(arg_2_0._overcharge_type, arg_2_0._consume_overcharge)
	end

	ActionChargedSweep.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end

function ActionChargedSweep.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	ActionChargedSweep.super.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
end

function ActionChargedSweep.finish(arg_4_0, arg_4_1)
	ActionChargedSweep.super.finish(arg_4_0, arg_4_1)
end

function ActionChargedSweep.get_overcharge_level(arg_5_0, arg_5_1)
	local var_5_0 = 1
	local var_5_1 = arg_5_0.overcharge_level_map

	for iter_5_0 = arg_5_0.overcharge_map_size, 1, -1 do
		if arg_5_1 >= var_5_1[iter_5_0] then
			return iter_5_0 + 1
		end
	end

	return var_5_0
end

function ActionChargedSweep.get_discharge_effect(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = math.min(arg_6_2, arg_6_0.overcharge_map_size)
	local var_6_1 = arg_6_1.discharge_effects

	for iter_6_0 = var_6_0, 1, -1 do
		local var_6_2 = var_6_1[arg_6_2]

		if var_6_2 then
			return var_6_2
		end
	end

	return nil
end

function ActionChargedSweep.apply_overcharge(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1 then
		local var_7_0 = arg_7_0.overcharge_extension
		local var_7_1 = PlayerUnitStatusSettings.overcharge_values[arg_7_1]

		if arg_7_2 then
			var_7_0:remove_charge(var_7_1)
		else
			var_7_0:add_charge(var_7_1)
		end
	end
end

function ActionChargedSweep._send_attack_hit(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, ...)
	local var_8_0 = false
	local var_8_1

	if arg_8_1 > arg_8_0._time_to_hit and arg_8_0._number_of_hit_enemies == 1 then
		var_8_1 = arg_8_0._network_manager:game_object_or_level_unit(arg_8_4)

		local var_8_2 = ScriptUnit.has_extension(var_8_1, "health_system")

		var_8_0 = var_8_2 and var_8_2:client_predicted_is_alive()
	end

	ActionChargedSweep.super._send_attack_hit(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, ...)

	if var_8_0 then
		if not arg_8_0._overcharge_on_swing then
			arg_8_0:apply_overcharge(arg_8_0._overcharge_type, arg_8_0._consume_overcharge)
		end

		arg_8_0:_apply_discharge_effect(arg_8_0._discharge_effect, arg_8_2, var_8_1, arg_8_6)
	end
end

function ActionChargedSweep._apply_discharge_effect(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if arg_9_1 then
		local var_9_0 = arg_9_1.explosion_template_name

		if var_9_0 then
			local var_9_1 = Unit.has_node(arg_9_3, "c_spine") and Unit.node(arg_9_3, "c_spine")
			local var_9_2 = var_9_1 and Unit.world_position(arg_9_3, var_9_1) or arg_9_4
			local var_9_3 = arg_9_0.world
			local var_9_4 = arg_9_0.owner_unit
			local var_9_5 = arg_9_0._stored_rotation:unbox()
			local var_9_6 = 1
			local var_9_7 = arg_9_0.item_name
			local var_9_8 = arg_9_0._power_level
			local var_9_9 = arg_9_0.is_server
			local var_9_10 = false
			local var_9_11 = false
			local var_9_12 = arg_9_0.weapon_unit
			local var_9_13 = Managers.state.network
			local var_9_14 = var_9_13.network_transmit
			local var_9_15 = ExplosionUtils.get_template(var_9_0)
			local var_9_16 = var_9_13:unit_game_object_id(var_9_4)
			local var_9_17 = NetworkLookup.explosion_templates[var_9_0]

			if var_9_9 then
				var_9_14:send_rpc_clients("rpc_create_explosion", var_9_16, false, var_9_2, var_9_5, var_9_17, var_9_6, arg_9_2, var_9_8, var_9_11, var_9_16)
			else
				var_9_14:send_rpc_server("rpc_create_explosion", var_9_16, false, var_9_2, var_9_5, var_9_17, var_9_6, arg_9_2, var_9_8, var_9_11, var_9_16)
			end

			DamageUtils.create_explosion(var_9_3, var_9_4, var_9_2, var_9_5, var_9_15, var_9_6, var_9_7, var_9_9, var_9_10, var_9_12, var_9_8, var_9_11)
		end
	end
end

function ActionChargedSweep._get_damage_profile_name(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._discharge_effect

	if var_10_0 and var_10_0.damage_profile_name then
		return var_10_0.damage_profile_name
	end

	return ActionChargedSweep.super._get_damage_profile_name(arg_10_0, arg_10_1, arg_10_2)
end
