-- chunkname: @scripts/unit_extensions/generic/chaos_troll_health_extension.lua

ChaosTrollHealthExtension = class(ChaosTrollHealthExtension, GenericHealthExtension)

local var_0_0 = AiUtils.set_material_property

function ChaosTrollHealthExtension.init(arg_1_0, arg_1_1, arg_1_2, ...)
	ChaosTrollHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, ...)

	local var_1_0 = Managers.time:time("game")

	arg_1_0._regen_time = var_1_0 + 1
	arg_1_0._regen_paused_time = var_1_0
	arg_1_0.pulse_time = 0
	arg_1_0.state = "unhurt"
	arg_1_0.skin_unit = nil

	local var_1_1 = ScriptUnit.has_extension(arg_1_0.unit, "ai_inventory_system")

	if var_1_1 then
		arg_1_0.skin_unit = var_1_1:get_skin_unit()
	end
end

function ChaosTrollHealthExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = BLACKBOARDS[arg_2_2]
	local var_2_1 = Breeds[var_2_0.breed.name]

	arg_2_0.action, arg_2_0.breed = BreedActions[var_2_0.breed.name].downed, var_2_1

	arg_2_0:_setup_initial_health_variables(arg_2_0.health)
end

function ChaosTrollHealthExtension.current_max_health_percent(arg_3_0)
	return arg_3_0.health / arg_3_0.current_max_health
end

local var_0_1 = 0.0001

function ChaosTrollHealthExtension.respawn_thresholds(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.action
	local var_4_1 = arg_4_1 or arg_4_0.current_max_health
	local var_4_2 = arg_4_2 or arg_4_0.health
	local var_4_3
	local var_4_4
	local var_4_5

	if var_4_0.fixed_hp_chunks then
		local var_4_6 = var_4_1 / var_4_0.fixed_hp_chunks

		if var_4_6 % 1 ~= 0 then
			var_4_2 = math.round_to_closest_multiple(var_4_2, var_4_6 % 1)
		end

		local var_4_7 = math.ceil(math.round_to_closest_multiple(var_4_2 / var_4_6, var_0_1) - var_0_1)

		var_4_3 = math.clamp(var_4_7 - 1, 0, var_4_0.fixed_hp_chunks) * var_4_6
		var_4_4 = var_4_3 + var_4_6 * var_4_0.respawn_hp_chunk_percent
		var_4_5 = var_4_0.fixed_hp_chunks - var_4_7 + 1
	else
		var_4_3 = var_4_2 * var_4_0.become_downed_hp_percent
		var_4_4 = var_4_2 * var_4_0.respawn_hp_min_percent
	end

	return var_4_3, var_4_4, var_4_3 / var_4_1, var_4_4 / var_4_1, var_4_5
end

function ChaosTrollHealthExtension.chunk_size(arg_5_0)
	return arg_5_0.current_max_health / arg_5_0.action.fixed_hp_chunks
end

function ChaosTrollHealthExtension.set_max_health(arg_6_0, arg_6_1)
	arg_6_1 = ChaosTrollHealthExtension.super.set_max_health(arg_6_0, arg_6_1)

	arg_6_0:_setup_initial_health_variables(arg_6_1)

	local var_6_0 = arg_6_0._game_object_id or Managers.state.unit_storage:go_id(arg_6_0.unit)

	if var_6_0 then
		local var_6_1 = arg_6_0.current_max_health

		arg_6_0.network_transmit:send_rpc_clients("rpc_sync_current_max_health", var_6_0, var_6_1)
	end

	return arg_6_1
end

function ChaosTrollHealthExtension._setup_initial_health_variables(arg_7_0, arg_7_1)
	if not arg_7_0.action then
		return
	end

	local var_7_0, var_7_1 = arg_7_0:respawn_thresholds(arg_7_1)

	arg_7_0.go_down_health = var_7_0
	arg_7_0.respawn_hp_min = var_7_1
	arg_7_0.respawn_hp_max = arg_7_1
	arg_7_0.regen_pulse_interval = arg_7_0.breed.regen_pulse_interval
	arg_7_0.downed_pulse_interval = arg_7_0.breed.downed_pulse_interval
	arg_7_0.regen_pulse_intensity = arg_7_0.breed.regen_pulse_intensity
	arg_7_0.downed_pulse_intensity = arg_7_0.breed.downed_pulse_intensity
	arg_7_0.regen_taken_damage_pause_time = arg_7_0.breed.regen_taken_damage_pause_time
	arg_7_0.current_max_health = DamageUtils.networkify_health(arg_7_1)
	arg_7_0._initial_sync = false
end

function ChaosTrollHealthExtension.hot_join_sync(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._game_object_id or Managers.state.unit_storage:go_id(arg_8_0.unit)

	if var_8_0 then
		local var_8_1 = NetworkLookup.health_statuses[arg_8_0.state]
		local var_8_2 = false
		local var_8_3 = true

		arg_8_0.network_transmit:send_rpc("rpc_sync_damage_taken", arg_8_1, var_8_0, var_8_2, var_8_3, arg_8_0.current_max_health, var_8_1)
		arg_8_0.network_transmit:send_rpc("rpc_sync_damage_taken", arg_8_1, var_8_0, var_8_2, var_8_3, arg_8_0.health, var_8_1)
	end

	ChaosTrollHealthExtension.super.hot_join_sync(arg_8_0, arg_8_1)
end

function ChaosTrollHealthExtension.update_regen_effect(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_0.pulse_time = arg_9_0.pulse_time + arg_9_2

	local var_9_0 = (arg_9_0._regen_time - arg_9_1) / arg_9_3
	local var_9_1 = math.sin(var_9_0 * math.pi) * arg_9_4

	if arg_9_0.skin_unit ~= nil then
		var_0_0(arg_9_0.skin_unit, "regen_value", "mtr_skin", var_9_1, true)
	else
		var_0_0(arg_9_0.unit, "regen_value", "mtr_skin", var_9_1, true)
	end
end

local var_0_2 = 0

function ChaosTrollHealthExtension.update(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_0.state == "dead" then
		return
	end

	if not arg_10_0._initial_sync then
		arg_10_0._initial_sync = true

		arg_10_0:sync_health_to_clients(true)
	end

	if arg_10_0.state == "down" then
		arg_10_0:update_regen_effect(arg_10_3, arg_10_1, arg_10_0.downed_pulse_interval, arg_10_0.downed_pulse_intensity)

		if arg_10_3 > arg_10_0.start_reset_time then
			arg_10_0.down_reset_timer = arg_10_0.down_reset_timer + arg_10_1

			local var_10_0 = 1 - (arg_10_0.action.reset_duration > 0 and arg_10_0.down_reset_timer / arg_10_0.action.reset_duration or 0)

			if arg_10_0.skin_unit ~= nil then
				var_0_0(arg_10_0.skin_unit, "damage_value", "mtr_skin", var_10_0, true)
			else
				var_0_0(arg_10_0.unit, "damage_value", "mtr_skin", var_10_0, true)
			end
		end
	elseif arg_10_0.state == "unhurt" or arg_10_0.state == "wounded" then
		arg_10_0:update_regen_effect(arg_10_3, arg_10_1, arg_10_0.regen_pulse_interval, arg_10_0.regen_pulse_intensity)

		if arg_10_3 > arg_10_0._regen_time and arg_10_3 > arg_10_0._regen_paused_time then
			local var_10_1 = BLACKBOARDS[arg_10_0.unit]
			local var_10_2 = arg_10_3 - arg_10_0._regen_paused_time
			local var_10_3 = var_10_1.max_health_regen_time
			local var_10_4 = math.min(var_10_2 / var_10_3, 1)
			local var_10_5 = var_10_1.max_health_regen_per_sec * var_10_4
			local var_10_6 = DamageUtils.networkify_health(var_10_5)

			if var_10_6 > 0 and arg_10_0.damage > 0 then
				arg_10_0:add_heal(arg_10_0.unit, var_10_6 * arg_10_0.regen_pulse_interval, nil, "buff")
			end

			arg_10_0._regen_time = arg_10_3 + arg_10_0.regen_pulse_interval
			arg_10_0.pulse_time = 0
		end
	end
end

function ChaosTrollHealthExtension._should_die(arg_11_0)
	return arg_11_0.state == "wounded" and arg_11_0.damage >= arg_11_0.health
end

function ChaosTrollHealthExtension.apply_client_predicted_damage(arg_12_0, arg_12_1)
	return
end

function ChaosTrollHealthExtension.add_damage(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10, arg_13_11, arg_13_12, arg_13_13, arg_13_14, arg_13_15, arg_13_16, arg_13_17)
	ChaosTrollHealthExtension.super.add_damage(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10, arg_13_11, arg_13_12, arg_13_13, arg_13_14, arg_13_15, arg_13_16, arg_13_17)

	arg_13_0._first_damage_occured = true

	if arg_13_0.state == "dead" then
		return
	end

	local var_13_0 = Managers.time:time("game")

	if arg_13_0.state == "unhurt" then
		local var_13_1 = 1

		if arg_13_0.health - arg_13_0.damage < arg_13_0.go_down_health then
			local var_13_2 = BLACKBOARDS[arg_13_0.unit]

			arg_13_0.damage = 0
			arg_13_0.state = "down"
			var_13_2.downed_state = "downed"
			arg_13_0.start_reset_time = var_13_0 + (AiUtils.downed_duration(arg_13_0.action) + arg_13_0.action.standup_anim_duration - arg_13_0.action.reset_duration)
			arg_13_0.down_reset_timer = 0
		else
			local var_13_3 = arg_13_0.health - arg_13_0.go_down_health

			var_13_1 = var_13_3 ~= 0 and arg_13_0.damage / var_13_3 or 0
		end

		if arg_13_0.skin_unit ~= nil then
			var_0_0(arg_13_0.skin_unit, "damage_value", "mtr_skin", var_13_1, true)
		else
			var_0_0(arg_13_0.unit, "damage_value", "mtr_skin", var_13_1, true)
		end
	elseif arg_13_0.state == "down" then
		if arg_13_0.health - arg_13_0.damage < arg_13_0.respawn_hp_min then
			arg_13_0.damage = arg_13_0.health - arg_13_0.respawn_hp_min

			if not arg_13_0.action.fixed_hp_chunks then
				arg_13_0.wounded = true
			end
		end
	elseif arg_13_0.state == "wounded" then
		if arg_13_0.damage >= arg_13_0.health then
			arg_13_0.state = "dead"

			if arg_13_0.skin_unit ~= nil then
				var_0_0(arg_13_0.skin_unit, "regen_value", "mtr_skin", 0, true)
			else
				var_0_0(arg_13_0.unit, "regen_value", "mtr_skin", 0, true)
			end
		else
			local var_13_4 = arg_13_0.damage / (arg_13_0.health - arg_13_0.damage)

			if arg_13_0.skin_unit ~= nil then
				var_0_0(arg_13_0.skin_unit, "damage_value", "mtr_skin", var_13_4, true)
			else
				var_0_0(arg_13_0.unit, "damage_value", "mtr_skin", var_13_4, true)
			end
		end
	end

	arg_13_0._regen_paused_time = var_13_0 + arg_13_0.regen_taken_damage_pause_time

	arg_13_0:sync_health_to_clients(nil)
end

function ChaosTrollHealthExtension.set_downed_finished(arg_14_0)
	if arg_14_0.state == "down" then
		local var_14_0 = BLACKBOARDS[arg_14_0.unit]
		local var_14_1 = var_14_0.running_downed_chunk_events

		if var_14_1 then
			for iter_14_0, iter_14_1 in pairs(var_14_1) do
				if iter_14_1.before_down_end then
					iter_14_1.before_down_end(arg_14_0.unit, var_14_0)
				end
			end
		end

		local var_14_2 = arg_14_0.action
		local var_14_3 = arg_14_0:current_health()

		if var_14_2.reset_health_on_fail and var_14_3 - arg_14_0.respawn_hp_min > 0.25 then
			arg_14_0.damage = 0
		elseif var_14_2.respawn_hp_max_percent then
			arg_14_0.respawn_hp_max = arg_14_0.health * var_14_2.respawn_hp_max_percent

			if arg_14_0.health - arg_14_0.damage > arg_14_0.respawn_hp_max then
				arg_14_0.damage = arg_14_0.health - arg_14_0.respawn_hp_max
			end
		end

		if var_14_2.reduce_hp_permanently then
			local var_14_4 = arg_14_0.health - arg_14_0.damage
			local var_14_5, var_14_6, var_14_7, var_14_8, var_14_9 = arg_14_0:respawn_thresholds(nil, var_14_4)

			if var_14_9 and var_14_9 == var_14_2.fixed_hp_chunks then
				arg_14_0.wounded = true
			end

			arg_14_0.respawn_hp_min = var_14_6
			arg_14_0.go_down_health = var_14_5

			ChaosTrollHealthExtension.super.set_max_health(arg_14_0, var_14_4)
			arg_14_0:sync_health_to_clients(true)

			arg_14_0.damage = 0
		end

		if arg_14_0.wounded then
			arg_14_0.state = "wounded"
		else
			arg_14_0.wounded = false
			arg_14_0.state = "unhurt"
		end

		arg_14_0.down_reset_timer = nil

		if arg_14_0.skin_unit ~= nil then
			var_0_0(arg_14_0.skin_unit, "damage_value", "mtr_skin", 1, true)
		else
			var_0_0(arg_14_0.unit, "damage_value", "mtr_skin", 1, true)
		end

		arg_14_0:sync_health_to_clients(false)
	end
end

function ChaosTrollHealthExtension.die(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.unit

	if ScriptUnit.has_extension(var_15_0, "ai_system") then
		arg_15_1 = arg_15_1 or "undefined"

		arg_15_0:force_set_wounded()
		AiUtils.kill_unit(var_15_0, nil, nil, arg_15_1, nil)
	end
end

function ChaosTrollHealthExtension.sync_health_to_clients(arg_16_0, arg_16_1)
	arg_16_0._game_object_id = arg_16_0._game_object_id or Managers.state.unit_storage:go_id(arg_16_0.unit)

	local var_16_0 = NetworkLookup.health_statuses[arg_16_0.state]
	local var_16_1 = false
	local var_16_2

	if arg_16_1 then
		var_16_2 = arg_16_0.health
	else
		var_16_2 = math.max(0, arg_16_0.damage)
	end

	arg_16_0.network_transmit:send_rpc_clients("rpc_sync_damage_taken", arg_16_0._game_object_id, var_16_1, arg_16_1 or false, var_16_2, var_16_0)
end

function ChaosTrollHealthExtension.min_health_reached(arg_17_0)
	return arg_17_0.health - arg_17_0.damage <= arg_17_0.respawn_hp_min
end

function ChaosTrollHealthExtension.force_set_wounded(arg_18_0)
	arg_18_0.wounded = true
	arg_18_0.state = "wounded"
end

function ChaosTrollHealthExtension.add_heal(arg_19_0, ...)
	ChaosTrollHealthExtension.super.add_heal(arg_19_0, ...)
	arg_19_0:sync_health_to_clients(false)
end
