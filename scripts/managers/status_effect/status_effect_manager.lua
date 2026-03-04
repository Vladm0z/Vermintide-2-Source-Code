-- chunkname: @scripts/managers/status_effect/status_effect_manager.lua

require("scripts/managers/status_effect/status_effect_templates")

StatusEffectManager = class(StatusEffectManager)

StatusEffectManager.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._statuses_by_unit = {}
	arg_1_0._timed_status_datas = {}
	arg_1_0._blacklisted_units = {}

	arg_1_0._on_unit_destroyed_cb = function (arg_2_0)
		arg_1_0:_cleanup_unit(arg_2_0)
	end
end

StatusEffectManager.destroy = function (arg_3_0)
	for iter_3_0 in pairs(arg_3_0._statuses_by_unit) do
		arg_3_0:remove_all_statuses(iter_3_0)
	end
end

StatusEffectManager.update = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_update_timed_statuses(arg_4_1, arg_4_2)
end

local var_0_0 = {}

StatusEffectManager.set_status = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_4 then
		if arg_5_0._blacklisted_units[arg_5_1] then
			return false
		end

		local var_5_0 = Unit.get_data(arg_5_1, "breed")

		if var_5_0 then
			local var_5_1 = var_5_0.status_effect_settings
			local var_5_2 = var_5_1 and var_5_1.ignored_statuses or var_0_0
			local var_5_3 = CRITTER[var_5_0.name]

			if var_5_2[arg_5_2] or var_5_3 then
				return false
			end
		end
	end

	local var_5_4 = StatusEffectTemplates[arg_5_2]
	local var_5_5 = arg_5_0:has_status(arg_5_1, arg_5_2)
	local var_5_6 = arg_5_0._statuses_by_unit
	local var_5_7 = var_5_6[arg_5_1]

	if arg_5_4 then
		if not var_5_7 then
			Managers.state.unit_spawner:add_destroy_listener(arg_5_1, "StatusEffectManager", arg_5_0._on_unit_destroyed_cb)
			Managers.state.event:register_referenced(arg_5_1, arg_5_0, "on_unit_freeze", "_cleanup_unit")

			var_5_7 = {}
			var_5_6[arg_5_1] = var_5_7
		end

		var_5_7[arg_5_2] = var_5_7[arg_5_2] or {
			reasons = {},
			frame_index = GLOBAL_FRAME_INDEX
		}

		local var_5_8 = var_5_7[arg_5_2]

		var_5_8.reasons[arg_5_3] = true

		if not var_5_5 and var_5_4.on_applied then
			var_5_8.apply_data = var_5_4.on_applied(arg_5_1, arg_5_3, var_5_4, arg_5_0._world)
		end

		if var_5_4.on_increment then
			var_5_4.on_increment(arg_5_1, arg_5_3, var_5_4, arg_5_0._world, var_5_8.apply_data)
		end
	elseif var_5_7 then
		local var_5_9 = var_5_7[arg_5_2] or var_0_0
		local var_5_10 = var_5_9.reasons or var_0_0

		if var_5_10[arg_5_3] then
			var_5_10[arg_5_3] = nil

			local var_5_11 = var_5_9.apply_data

			if var_5_4.on_decrement then
				var_5_4.on_decrement(arg_5_1, arg_5_3, var_5_4, arg_5_0._world, var_5_11)
			end

			if table.is_empty(var_5_10) then
				var_5_7[arg_5_2] = nil

				if var_5_4.on_removed then
					var_5_4.on_removed(arg_5_1, arg_5_3, var_5_4, arg_5_0._world, var_5_11)
				end
			end
		end

		if table.is_empty(var_5_7) then
			var_5_6[arg_5_1] = nil

			if not arg_5_0._blacklisted_units[arg_5_1] then
				Managers.state.unit_spawner:remove_destroy_listener(arg_5_1, "StatusEffectManager")
				Managers.state.event:unregister_referenced("on_unit_freeze", arg_5_1, arg_5_0)
			end
		end
	end

	return true
end

StatusEffectManager.add_timed_status = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_3 or StatusEffectTemplates[arg_6_2].default_timed_duration
	local var_6_1 = Managers.time:time("game")
	local var_6_2 = {
		_is_timed = true,
		status_name = arg_6_2,
		remove_t = var_6_1 + var_6_0
	}

	if arg_6_0:set_status(arg_6_1, arg_6_2, var_6_2, true) then
		arg_6_0._timed_status_datas[var_6_2] = arg_6_1
	end

	return var_6_2
end

StatusEffectManager._remove_timed_status = function (arg_7_0, arg_7_1, arg_7_2)
	if Unit.alive(arg_7_1) then
		local var_7_0 = arg_7_2.status_name

		arg_7_0:set_status(arg_7_1, var_7_0, arg_7_2, false)
	end

	arg_7_0._timed_status_datas[arg_7_2] = nil
end

StatusEffectManager.has_status = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._statuses_by_unit[arg_8_1]

	if var_8_0 then
		local var_8_1 = var_8_0[arg_8_2]
		local var_8_2 = var_8_1 and var_8_1.frame_index == GLOBAL_FRAME_INDEX

		return var_8_1, var_8_2
	end

	return false, false
end

StatusEffectManager.remove_all_statuses = function (arg_9_0, arg_9_1, arg_9_2)
	if arg_9_2 then
		arg_9_0._blacklisted_units[arg_9_1] = true
	end

	local var_9_0 = arg_9_0._statuses_by_unit[arg_9_1] or var_0_0

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		for iter_9_2 in pairs(iter_9_1.reasons) do
			if type(iter_9_2) == "table" and iter_9_2._is_timed then
				arg_9_0:_remove_timed_status(arg_9_1, iter_9_2)
			else
				arg_9_0:set_status(arg_9_1, iter_9_0, iter_9_2, false)
			end
		end
	end
end

StatusEffectManager._update_timed_statuses = function (arg_10_0, arg_10_1, arg_10_2)
	for iter_10_0, iter_10_1 in pairs(arg_10_0._timed_status_datas) do
		if arg_10_2 > iter_10_0.remove_t then
			arg_10_0:_remove_timed_status(iter_10_1, iter_10_0)
		end
	end
end

StatusEffectManager._cleanup_unit = function (arg_11_0, arg_11_1)
	Managers.state.unit_spawner:remove_destroy_listener(arg_11_1, "StatusEffectManager")
	Managers.state.event:unregister_referenced("on_unit_freeze", arg_11_1, arg_11_0)
	arg_11_0:remove_all_statuses(arg_11_1)

	arg_11_0._blacklisted_units[arg_11_1] = nil
end

StatusEffectManager.unit_is_burning = function (arg_12_0, arg_12_1)
	local var_12_0, var_12_1 = arg_12_0:has_status(arg_12_1, StatusEffectNames.burning)
	local var_12_2, var_12_3 = arg_12_0:has_status(arg_12_1, StatusEffectNames.burning_balefire)
	local var_12_4, var_12_5 = arg_12_0:has_status(arg_12_1, StatusEffectNames.burning_elven_magic)
	local var_12_6, var_12_7 = arg_12_0:has_status(arg_12_1, StatusEffectNames.burning_warpfire)
	local var_12_8 = var_12_0 or var_12_2 or var_12_4 or var_12_6
	local var_12_9 = var_12_8 and (not var_12_0 or var_12_1) and (not var_12_2 or var_12_3) and (not var_12_4 or var_12_5) and (not var_12_6 or var_12_7)

	return var_12_8, var_12_9
end
