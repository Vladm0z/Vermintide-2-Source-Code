-- chunkname: @scripts/unit_extensions/weaves/weave_kill_enemies_extension.lua

WeaveKillEnemiesExtension = class(WeaveKillEnemiesExtension, BaseObjectiveExtension)
WeaveKillEnemiesExtension.NAME = "WeaveKillEnemiesExtension"

local var_0_0 = {
	hardest = 0.7,
	hard = 0.9,
	harder = 0.8,
	cataclysm_2 = 0.5,
	cataclysm = 0.6,
	cataclysm_3 = 0.4,
	normal = 1
}

WeaveKillEnemiesExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	WeaveKillEnemiesExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._on_start_func = arg_1_3.on_start_func
	arg_1_0._on_progress_func = arg_1_3.on_progress_func
	arg_1_0._on_complete_func = arg_1_3.on_complete_func
	arg_1_0._num_killed = 0
	arg_1_0._kills_required = arg_1_3.amount or 0
	arg_1_0._base_score_per_kill = arg_1_3.base_score_per_kill or WeaveSettings.base_score_per_kill
	arg_1_0._breed_score_multipliers = arg_1_3.breed_score_multipliers or {}

	local var_1_0 = arg_1_3.score_multiplier or 1
	local var_1_1 = Managers.state.difficulty:get_difficulty()

	if type(var_1_0) == "table" then
		var_1_0 = var_1_0[var_1_1] or var_0_0[var_1_1] or 1
	end

	arg_1_0._weave_manager = Managers.weave
	arg_1_0._score_multiplier = var_1_0
	arg_1_0._breeds_allowed = arg_1_3.breeds_allowed
	arg_1_0._races_allowed = arg_1_3.races_allowed
	arg_1_0._hit_zones_allowed = arg_1_3.hit_zones_allowed
	arg_1_0._attacks_allowed = arg_1_3.attacks_allowed
	arg_1_0._damage_types_allowed = arg_1_3.damage_types_allowed

	if not arg_1_1.is_server then
		return
	end

	if arg_1_0._kills_required > 0 then
		arg_1_0._method = "num_kills"
	else
		arg_1_0._method = "score"

		if type(arg_1_0._breed_score_multipliers) == "number" then
			arg_1_0._breed_score_multipliers = {
				default = arg_1_0._breed_score_multipliers
			}
		else
			local var_1_2 = WeaveSettings.enemies_score_multipliers
			local var_1_3 = arg_1_0._breed_score_multipliers

			for iter_1_0, iter_1_1 in pairs(var_1_2) do
				if not var_1_3[iter_1_0] then
					var_1_3[iter_1_0] = iter_1_1
				end
			end
		end
	end

	if arg_1_0._breeds_allowed and #arg_1_0._breeds_allowed == 0 then
		arg_1_0._breeds_allowed = nil
	end

	if arg_1_0._races_allowed and #arg_1_0._races_allowed == 0 then
		arg_1_0._races_allowed = nil
	end

	if arg_1_0._hit_zones_allowed and #arg_1_0._hit_zones_allowed == 0 then
		arg_1_0._hit_zones_allowed = nil
	end

	if arg_1_0._attacks_allowed and #arg_1_0._attacks_allowed == 0 then
		arg_1_0._attacks_allowed = nil
	end

	if arg_1_0._damage_types_allowed and #arg_1_0._damage_types_allowed == 0 then
		arg_1_0._damage_types_allowed = nil
	end
end

WeaveKillEnemiesExtension.initial_sync_data = function (arg_2_0, arg_2_1)
	arg_2_1.value = arg_2_0:get_percentage_done()
end

WeaveKillEnemiesExtension._set_objective_data = function (arg_3_0, arg_3_1)
	return
end

WeaveKillEnemiesExtension._activate = function (arg_4_0)
	local var_4_0 = ScriptUnit.has_extension(arg_4_0._unit, "tutorial_system")

	if var_4_0 then
		var_4_0:set_active(true)
	end
end

WeaveKillEnemiesExtension._deactivate = function (arg_5_0)
	return
end

WeaveKillEnemiesExtension._server_update = function (arg_6_0, arg_6_1, arg_6_2)
	return
end

WeaveKillEnemiesExtension._client_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

WeaveKillEnemiesExtension.is_done = function (arg_8_0)
	if arg_8_0._method == "score" then
		return false
	end

	return arg_8_0._num_killed >= arg_8_0._kills_required
end

WeaveKillEnemiesExtension.get_percentage_done = function (arg_9_0)
	if arg_9_0._method == "score" then
		return 0
	end

	if arg_9_0._kills_required == 0 then
		return 1
	end

	return math.clamp(arg_9_0._num_killed / arg_9_0._kills_required, 0, 1)
end

WeaveKillEnemiesExtension.on_ai_killed = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_0._hit_zones_allowed

	if var_10_0 and arg_10_4 then
		local var_10_1 = arg_10_4[DamageDataIndex.HIT_ZONE]

		if not table.contains(var_10_0, var_10_1) then
			return
		end
	end

	local var_10_2 = arg_10_0._damage_types_allowed

	if var_10_2 and arg_10_4 then
		local var_10_3 = arg_10_4[DamageDataIndex.DAMAGE_TYPE]

		if not table.contains(var_10_2, var_10_3) then
			return
		end
	end

	local var_10_4 = arg_10_0._attacks_allowed

	if var_10_4 and arg_10_4 then
		local var_10_5 = arg_10_4[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_10_6 = rawget(ItemMasterList, var_10_5)

		if var_10_6 then
			local var_10_7 = var_10_6.slot_type

			if not table.contains(var_10_4, var_10_7) then
				return
			end
		else
			return
		end
	end

	local var_10_8 = arg_10_0._breeds_allowed
	local var_10_9 = false
	local var_10_10 = arg_10_3.breed.name

	if var_10_8 and table.contains(var_10_8, var_10_10) then
		var_10_9 = true
	end

	local var_10_11 = arg_10_0._races_allowed

	if not var_10_9 and var_10_11 then
		local var_10_12 = arg_10_3.breed.race

		if table.contains(var_10_11, var_10_12) then
			var_10_9 = true
		end
	end

	if (var_10_8 or var_10_11) and not var_10_9 then
		return
	end

	arg_10_0._num_killed = arg_10_0._num_killed + 1

	if arg_10_0._num_killed == 1 and arg_10_0._on_start_func then
		arg_10_0._on_start_func(arg_10_0._unit)

		arg_10_0._on_start_func = nil
	end

	if arg_10_0._on_progress_func then
		arg_10_0._on_progress_func(arg_10_0._unit, arg_10_0._num_killed, arg_10_0._kills_required)
	end

	if arg_10_0._method == "score" then
		local var_10_13 = WeaveSettings.roaming_multiplier[PLATFORM]
		local var_10_14 = Unit.get_data(arg_10_1, "spawn_type") or "unknown"
		local var_10_15 = arg_10_0._breed_score_multipliers
		local var_10_16 = var_10_15[var_10_10] or var_10_15.default
		local var_10_17 = var_10_14 == "roam" and arg_10_0._score_multiplier * var_10_13 or arg_10_0._score_multiplier
		local var_10_18 = var_10_17 * var_10_16

		if not arg_10_3.despawned then
			Managers.weave:increase_bar_score(var_10_18)
			print("Spawn type: " .. var_10_14, "Score: " .. var_10_18, "Score Multiplier: ", var_10_17)
		end

		Unit.set_data(arg_10_1, "spawn_type", nil)
	end

	if arg_10_0._is_server then
		arg_10_0:server_set_value(arg_10_0:get_percentage_done())
	end
end
