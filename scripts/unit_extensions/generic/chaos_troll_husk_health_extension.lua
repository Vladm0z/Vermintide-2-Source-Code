-- chunkname: @scripts/unit_extensions/generic/chaos_troll_husk_health_extension.lua

ChaosTrollHuskHealthExtension = class(ChaosTrollHuskHealthExtension, GenericHealthExtension)

local var_0_0 = AiUtils.set_material_property

ChaosTrollHuskHealthExtension.init = function (arg_1_0, arg_1_1, arg_1_2, ...)
	ChaosTrollHuskHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, ...)

	arg_1_0._regen_time = Managers.time:time("game") + 1
	arg_1_0.pulse_time = 0
	arg_1_0.state = "unhurt"

	local var_1_0 = true

	arg_1_0:_setup_initial_health_variables(arg_1_0.health, var_1_0)

	arg_1_0.network_event_delegate = arg_1_1.system_data.network_event_delegate

	arg_1_0.network_event_delegate:register(arg_1_0, "rpc_sync_current_max_health")

	arg_1_0.skin_unit = nil

	local var_1_1 = ScriptUnit.has_extension(arg_1_0.unit, "ai_inventory_system")

	if var_1_1 then
		arg_1_0.skin_unit = var_1_1:get_skin_unit()
	end
end

ChaosTrollHuskHealthExtension.set_max_health = function (arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2 then
		arg_2_1 = DamageUtils.networkify_health(arg_2_1)
		arg_2_0.current_max_health = arg_2_1
	else
		arg_2_1 = ChaosTrollHuskHealthExtension.super.set_max_health(arg_2_0, arg_2_1)

		arg_2_0:_setup_initial_health_variables(arg_2_1)
	end

	return arg_2_1
end

ChaosTrollHuskHealthExtension._setup_initial_health_variables = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._breed
	local var_3_1 = BreedActions[var_3_0.name].downed

	arg_3_0.regen_pulse_interval = var_3_0.regen_pulse_interval
	arg_3_0.downed_pulse_interval = var_3_0.downed_pulse_interval
	arg_3_0.regen_pulse_intensity = var_3_0.regen_pulse_intensity
	arg_3_0.downed_pulse_intensity = var_3_0.downed_pulse_intensity
	arg_3_0.action = var_3_1
	arg_3_0.respawn_hp_max = arg_3_1
	arg_3_0.go_down_health = arg_3_0:respawn_thresholds(arg_3_1, arg_3_1)
end

ChaosTrollHuskHealthExtension.current_max_health_percent = function (arg_4_0)
	return arg_4_0.health / arg_4_0.current_max_health
end

local var_0_1 = 0.0001

ChaosTrollHuskHealthExtension.respawn_thresholds = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.action
	local var_5_1 = arg_5_1 or arg_5_0.current_max_health
	local var_5_2 = arg_5_2 or arg_5_0.health
	local var_5_3
	local var_5_4
	local var_5_5

	if var_5_0.fixed_hp_chunks then
		local var_5_6 = var_5_1 / var_5_0.fixed_hp_chunks

		if var_5_6 % 1 ~= 0 then
			var_5_2 = math.round_to_closest_multiple(var_5_2, var_5_6 % 1)
		end

		local var_5_7 = math.ceil(math.round_to_closest_multiple(var_5_2 / var_5_6, var_0_1))

		var_5_3 = math.clamp(var_5_7 - 1, 0, var_5_0.fixed_hp_chunks) * var_5_6
		var_5_4 = var_5_3 + var_5_6 * var_5_0.respawn_hp_chunk_percent
		var_5_5 = var_5_0.fixed_hp_chunks - var_5_7 + 1
	else
		var_5_3 = var_5_2 * var_5_0.become_downed_hp_percent
		var_5_4 = var_5_2 * var_5_0.respawn_hp_min_percent
	end

	return var_5_3, var_5_4, var_5_3 / var_5_1, var_5_4 / var_5_1, var_5_5
end

ChaosTrollHuskHealthExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_0.state == "dead" then
		return
	end

	if arg_6_0.state == "down" then
		ChaosTrollHealthExtension.update_regen_effect(arg_6_0, arg_6_3, arg_6_1, arg_6_0.downed_pulse_interval, arg_6_0.downed_pulse_intensity)

		if arg_6_3 > arg_6_0.start_reset_time then
			arg_6_0.down_reset_timer = arg_6_0.down_reset_timer + arg_6_1

			local var_6_0 = 1 - (arg_6_0.action.reset_duration > 0 and arg_6_0.down_reset_timer / arg_6_0.action.reset_duration or 0)

			if arg_6_0.skin_unit ~= nil then
				var_0_0(arg_6_0.skin_unit, "damage_value", "mtr_skin", var_6_0, true)
			else
				var_0_0(arg_6_0.unit, "damage_value", "mtr_skin", var_6_0, true)
			end
		end
	elseif arg_6_0.state == "unhurt" or arg_6_0.state == "wounded" then
		ChaosTrollHealthExtension.update_regen_effect(arg_6_0, arg_6_3, arg_6_1, arg_6_0.regen_pulse_interval, arg_6_0.regen_pulse_intensity)

		if arg_6_3 > arg_6_0._regen_time then
			arg_6_0._regen_time = arg_6_3 + arg_6_0.regen_pulse_interval
			arg_6_0.pulse_time = 0
		end
	end
end

ChaosTrollHuskHealthExtension.apply_client_predicted_damage = function (arg_7_0, arg_7_1)
	return
end

ChaosTrollHuskHealthExtension.add_damage = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14, arg_8_15, arg_8_16, arg_8_17)
	local var_8_0 = arg_8_0.unit
	local var_8_1 = arg_8_0:_add_to_damage_history_buffer(var_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14, arg_8_15, arg_8_17)

	StatisticsUtil.register_damage(var_8_0, var_8_1, arg_8_0.statistics_db)
	arg_8_0:save_kill_feed_data(arg_8_1, var_8_1, arg_8_3, arg_8_4, arg_8_7, arg_8_9)
	fassert(arg_8_4, "No damage_type!")

	arg_8_0._recent_damage_type = arg_8_4
	arg_8_0._recent_hit_react_type = arg_8_10

	DamageUtils.handle_hit_indication(arg_8_1, var_8_0, arg_8_2, arg_8_3, arg_8_12)
end

ChaosTrollHuskHealthExtension.add_heal = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_0.unit

	arg_9_0:_add_to_damage_history_buffer(var_9_0, arg_9_1, -arg_9_2, nil, "heal", nil, nil, arg_9_3, nil, nil, nil, nil, nil, nil, nil, nil, nil)
end

ChaosTrollHuskHealthExtension.sync_damage_taken = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_2 then
		if not arg_10_0._has_got_initial_setup then
			arg_10_0:set_max_health(arg_10_1, true)

			arg_10_0._has_got_initial_setup = true
		else
			ChaosTrollHealthExtension.super.set_max_health(arg_10_0, arg_10_1)
		end

		return
	end

	arg_10_0.damage = arg_10_1
	arg_10_0._first_damage_occured = true

	if arg_10_0.state ~= arg_10_3 then
		if arg_10_3 == "down" then
			var_0_0(arg_10_0.unit, "damage_value", "mtr_skin", 1, true)

			arg_10_0.start_reset_time = Managers.time:time("game") + (AiUtils.downed_duration(arg_10_0.action) + arg_10_0.action.standup_anim_duration - arg_10_0.action.reset_duration)
			arg_10_0.down_reset_timer = 0
		elseif arg_10_3 == "wounded" or arg_10_3 == "unhurt" then
			var_0_0(arg_10_0.unit, "damage_value", "mtr_skin", 0, true)
		elseif arg_10_3 == "dead" then
			var_0_0(arg_10_0.unit, "regen_value", "mtr_skin", 0, true)
		end

		arg_10_0.state = arg_10_3
	elseif arg_10_3 == "unhurt" then
		local var_10_0 = arg_10_0.damage / math.max(arg_10_0.health - arg_10_0.go_down_health, 0.01)

		var_0_0(arg_10_0.unit, "damage_value", "mtr_skin", var_10_0, true)
	elseif arg_10_3 == "wounded" then
		local var_10_1 = arg_10_0.damage / (arg_10_0.health - arg_10_0.damage)

		var_0_0(arg_10_0.unit, "damage_value", "mtr_skin", var_10_1, true)
	end
end

ChaosTrollHuskHealthExtension.rpc_sync_current_max_health = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if (arg_11_0.game_object_id or Managers.state.unit_storage:go_id(arg_11_0.unit)) ~= arg_11_2 then
		return
	end

	arg_11_0.current_max_health = DamageUtils.networkify_health(arg_11_3)
end

ChaosTrollHuskHealthExtension.destroy = function (arg_12_0)
	ChaosTrollHuskHealthExtension.super:destroy()
	arg_12_0.network_event_delegate:unregister(arg_12_0)
end
