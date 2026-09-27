-- chunkname: @scripts/managers/controller_features/controller_features_implementation.lua

ControllerFeaturesImplementation = class(ControllerFeaturesImplementation)

ControllerFeaturesImplementation.init = function (self, arg_1_1)
	-- function 1
	self:_reset()

	self._is_in_inn = arg_1_1

	if not Managers.state.event then
		Managers.state.event:register(self, "gm_event_end_conditions_met", "event_end_conditions_met")
	end
end

ControllerFeaturesImplementation._reset = function (self)
	-- function 2
	self._effects = {}
	self._current_effect_id = 1
	self._game_mode_ended = false
	self._state_data = {}
end

ControllerFeaturesImplementation.event_end_conditions_met = function (self)
	-- function 3
	self._game_mode_ended = true
end

local tbl = {}

ControllerFeaturesImplementation.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	for k, v in pairs(self._effects) do
		table.clear(tbl)

		for k_2, v_2 in pairs(v) do
			if self._game_mode_ended or not v_2.effect.update(v_2.state_data, arg_4_1, arg_4_2) then
				v_2.effect.destroy(v_2.state_data)

				tbl[#tbl + 1] = k_2
			end
		end

		for i, v_3 in ipairs(tbl) do
			v[v_3] = nil
		end
	end
end

ControllerFeaturesImplementation.add_effect = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if not (self._game_mode_ended or not Application.user_setting("gamepad_rumble_enabled") or (arg_5_1 ~= "camera_shake" or not self._is_in_inn or script_data.honduras_demo) and Managers.input:is_device_active("gamepad")) then
		return
	end

	local flag = arg_5_3 or Managers.account:user_id()

	if not flag then
		return
	end

	local active_controller = Managers.account:active_controller(flag)

	if not active_controller then
		return
	end

	local tbl = {}

	if not ControllerFeaturesSettings[arg_5_1] then
		local var_5_3 = ControllerFeaturesSettings[arg_5_1]

		tbl.controller = active_controller

		var_5_3.init(tbl, arg_5_2)

		tbl.effect_id = self._current_effect_id

		local _effects = self._effects
		local var_5_5 = self._effects[flag]

		var_5_5 = var_5_5 or {}
		_effects[flag] = var_5_5
		self._effects[flag][self._current_effect_id] = {
			state_data = tbl,
			effect = var_5_3
		}
		self._current_effect_id = self._current_effect_id + 1

		return self._current_effect_id - 1
	end
end

ControllerFeaturesImplementation.stop_effect = function (self, arg_6_1)
	-- function 6
	local user_id = Managers.account:user_id()

	if not user_id then
		return
	end

	local var_6_1 = self._effects[user_id][arg_6_1]

	if not var_6_1 then
		var_6_1.effect.destroy(var_6_1.state_data)

		self._effects[user_id][arg_6_1] = nil
	end
end

ControllerFeaturesImplementation.destroy = function (self)
	-- function 7
	for k, v in pairs(self._effects) do
		for k_2, v_2 in pairs(v) do
			v_2.effect.destroy(v_2.state_data)
		end
	end

	self:_reset()
end
