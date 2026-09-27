-- chunkname: @scripts/managers/status_effect/status_effect_manager.lua

require("scripts/managers/status_effect/status_effect_templates")

StatusEffectManager = class(StatusEffectManager)

StatusEffectManager.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._statuses_by_unit = {}
	self._timed_status_datas = {}
	self._blacklisted_units = {}

	self._on_unit_destroyed_cb = function (arg_2_0)
		-- function 2
		self:_cleanup_unit(arg_2_0)
	end
end

StatusEffectManager.destroy = function (self)
	-- function 3
	for k in pairs(self._statuses_by_unit) do
		self:remove_all_statuses(k)
	end
end

StatusEffectManager.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_update_timed_statuses(arg_4_1, arg_4_2)
end

local tbl = {}

StatusEffectManager.set_status = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not arg_5_4 then
		if not self._blacklisted_units[arg_5_1] then
			return false
		end

		local get_data = Unit.get_data(arg_5_1, "breed")

		if not get_data then
			local status_effect_settings = get_data.status_effect_settings
			local ignored_statuses

			if not status_effect_settings then
				ignored_statuses = status_effect_settings.ignored_statuses

				if not ignored_statuses then
					-- Nothing
				end
			end

			ignored_statuses = tbl

			::label_5_0::

			local var_5_3 = CRITTER[get_data.name]

			if ignored_statuses[arg_5_2] or not var_5_3 then
				return false
			end
		end
	end

	local var_5_4 = StatusEffectTemplates[arg_5_2]
	local has_status = self:has_status(arg_5_1, arg_5_2)
	local _statuses_by_unit = self._statuses_by_unit
	local var_5_7 = _statuses_by_unit[arg_5_1]

	if not arg_5_4 then
		if not var_5_7 then
			Managers.state.unit_spawner:add_destroy_listener(arg_5_1, "StatusEffectManager", self._on_unit_destroyed_cb)
			Managers.state.event:register_referenced(arg_5_1, self, "on_unit_freeze", "_cleanup_unit")

			var_5_7 = {}
			_statuses_by_unit[arg_5_1] = var_5_7
		end

		local var_5_8 = var_5_7[arg_5_2]

		var_5_8 = var_5_8 or {
			reasons = {},
			frame_index = GLOBAL_FRAME_INDEX
		}
		var_5_7[arg_5_2] = var_5_8

		local var_5_9 = var_5_7[arg_5_2]

		var_5_9.reasons[arg_5_3] = true

		if has_status or not var_5_4.on_applied then
			var_5_9.apply_data = var_5_4.on_applied(arg_5_1, arg_5_3, var_5_4, self._world)
		end

		if not var_5_4.on_increment then
			var_5_4.on_increment(arg_5_1, arg_5_3, var_5_4, self._world, var_5_9.apply_data)
		end
	elseif not var_5_7 then
		local var_5_10 = var_5_7[arg_5_2]

		var_5_10 = var_5_10 or tbl

		local reasons = var_5_10.reasons

		reasons = reasons or tbl

		if not reasons[arg_5_3] then
			reasons[arg_5_3] = nil

			local apply_data = var_5_10.apply_data

			if not var_5_4.on_decrement then
				var_5_4.on_decrement(arg_5_1, arg_5_3, var_5_4, self._world, apply_data)
			end

			if not table.is_empty(reasons) then
				var_5_7[arg_5_2] = nil

				if not var_5_4.on_removed then
					var_5_4.on_removed(arg_5_1, arg_5_3, var_5_4, self._world, apply_data)
				end
			end
		end

		if not table.is_empty(var_5_7) then
			_statuses_by_unit[arg_5_1] = nil

			if not self._blacklisted_units[arg_5_1] then
				Managers.state.unit_spawner:remove_destroy_listener(arg_5_1, "StatusEffectManager")
				Managers.state.event:unregister_referenced("on_unit_freeze", arg_5_1, self)
			end
		end
	end

	return true
end

StatusEffectManager.add_timed_status = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local flag = arg_6_3 or StatusEffectTemplates[arg_6_2].default_timed_duration
	local time = Managers.time:time("game")
	local tbl = {
		_is_timed = true,
		status_name = arg_6_2,
		remove_t = time + flag
	}

	if not self:set_status(arg_6_1, arg_6_2, tbl, true) then
		self._timed_status_datas[tbl] = arg_6_1
	end

	return tbl
end

StatusEffectManager._remove_timed_status = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not Unit.alive(arg_7_1) then
		local status_name = arg_7_2.status_name

		self:set_status(arg_7_1, status_name, arg_7_2, false)
	end

	self._timed_status_datas[arg_7_2] = nil
end

StatusEffectManager.has_status = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = self._statuses_by_unit[arg_8_1]

	if not var_8_0 then
		local var_8_1 = var_8_0[arg_8_2]
		local flag = not var_8_1 and var_8_1.frame_index == GLOBAL_FRAME_INDEX

		return var_8_1, flag
	end

	return false, false
end

StatusEffectManager.remove_all_statuses = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not arg_9_2 then
		self._blacklisted_units[arg_9_1] = true
	end

	local var_9_0 = self._statuses_by_unit[arg_9_1]

	var_9_0 = var_9_0 or tbl

	for k, v in pairs(var_9_0) do
		for k_2 in pairs(v.reasons) do
			if type(k_2) ~= "table" or not k_2._is_timed then
				self:_remove_timed_status(arg_9_1, k_2)
			else
				self:set_status(arg_9_1, k, k_2, false)
			end
		end
	end
end

StatusEffectManager._update_timed_statuses = function (self, arg_10_1, arg_10_2)
	-- function 10
	for k, v in pairs(self._timed_status_datas) do
		if arg_10_2 > k.remove_t then
			self:_remove_timed_status(v, k)
		end
	end
end

StatusEffectManager._cleanup_unit = function (self, arg_11_1)
	-- function 11
	Managers.state.unit_spawner:remove_destroy_listener(arg_11_1, "StatusEffectManager")
	Managers.state.event:unregister_referenced("on_unit_freeze", arg_11_1, self)
	self:remove_all_statuses(arg_11_1)

	self._blacklisted_units[arg_11_1] = nil
end

StatusEffectManager.unit_is_burning = function (self, arg_12_1)
	-- function 12
	local has_status, var_12_1 = self:has_status(arg_12_1, StatusEffectNames.burning)
	local has_status_2, var_12_3 = self:has_status(arg_12_1, StatusEffectNames.burning_balefire)
	local has_status_3, var_12_5 = self:has_status(arg_12_1, StatusEffectNames.burning_elven_magic)
	local has_status_4, var_12_7 = self:has_status(arg_12_1, StatusEffectNames.burning_warpfire)
	local flag = has_status or has_status_2 or has_status_3 or has_status_4
	local flag_2 = not flag and not has_status and var_12_1 and not has_status_2 or var_12_3 and (not has_status_3 and var_12_5 and not has_status_4 or var_12_7)

	return flag, flag_2
end
