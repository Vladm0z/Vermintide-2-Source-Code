-- chunkname: @scripts/managers/vce/vce_manager.lua

VCEManager = class(VCEManager)

VCEManager.init = function (self)
	-- function 1
	self._vce_by_unit = {}
	self._vce_free_list = {}
end

VCEManager.trigger_vce = function (self, arg_2_1, arg_2_2, ...)
	-- function 2
	if not Managers.state.entity:system("dialogue_system"):is_unit_playing_dialogue(arg_2_1) then
		return
	end

	local trigger_event = WwiseWorld.trigger_event(arg_2_2, ...)

	self:_register_vce(arg_2_1, arg_2_2, trigger_event)
end

VCEManager.trigger_vce_unit = function (self, arg_3_1, ...)
	-- function 3
	if not Managers.state.entity:system("dialogue_system"):is_unit_playing_dialogue(arg_3_1) then
		return
	end

	local trigger_unit_event, var_3_1, var_3_2 = WwiseUtils.trigger_unit_event(...)

	self:_register_vce(arg_3_1, var_3_2, trigger_unit_event)
end

VCEManager._register_vce = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local _rent_vce_data = self:_rent_vce_data()

	_rent_vce_data.vce_id = arg_4_3
	_rent_vce_data.wwise_world = arg_4_2

	local var_4_1 = self._vce_by_unit[arg_4_1]

	var_4_1 = var_4_1 or {}
	self._vce_by_unit[arg_4_1] = var_4_1
	var_4_1[#var_4_1 + 1] = _rent_vce_data
end

VCEManager.interrupt_vce = function (self, arg_5_1)
	-- function 5
	local var_5_0 = self._vce_by_unit[arg_5_1]

	if not var_5_0 then
		return
	end

	for i = 1, #var_5_0 do
		local var_5_1 = var_5_0[i]
		local vce_id = var_5_1.vce_id
		local wwise_world = var_5_1.wwise_world

		if not WwiseWorld.is_playing(wwise_world, vce_id) then
			WwiseWorld.stop_event(wwise_world, vce_id)
		end

		self:_return_vce_data(var_5_1)

		var_5_0[i] = nil
	end
end

VCEManager._rent_vce_data = function (self)
	-- function 6
	local _vce_free_list = self._vce_free_list
	local count = #_vce_free_list
	local var_6_2 = _vce_free_list[count]

	var_6_2 = var_6_2 or {}
	_vce_free_list[count] = nil

	return var_6_2
end

VCEManager._return_vce_data = function (self, arg_7_1)
	-- function 7
	local _vce_free_list = self._vce_free_list

	_vce_free_list[#_vce_free_list] = arg_7_1
end
