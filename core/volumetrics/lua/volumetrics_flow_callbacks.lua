-- chunkname: @core/volumetrics/lua/volumetrics_flow_callbacks.lua

local VolumetricsFlowCallbacks = VolumetricsFlowCallbacks

VolumetricsFlowCallbacks = VolumetricsFlowCallbacks or {}
VolumetricsFlowCallbacks = VolumetricsFlowCallbacks

VolumetricsFlowCallbacks.register_fog_volume = function (self)
	-- function 1
	local unit = self.unit
	local get_data = stingray.Unit.get_data(unit, "FogProperties", "albedo", 0)
	local get_data_2 = stingray.Unit.get_data(unit, "FogProperties", "albedo", 1)
	local get_data_3 = stingray.Unit.get_data(unit, "FogProperties", "albedo", 2)
	local var_1_4 = Vector3(get_data, get_data_2, get_data_3)
	local get_data_4 = stingray.Unit.get_data(unit, "FogProperties", "extinction")
	local get_data_5 = stingray.Unit.get_data(unit, "FogProperties", "phase")
	local get_data_6 = stingray.Unit.get_data(unit, "FogProperties", "falloff", 0)
	local get_data_7 = stingray.Unit.get_data(unit, "FogProperties", "falloff", 1)
	local get_data_8 = stingray.Unit.get_data(unit, "FogProperties", "falloff", 2)
	local var_1_10 = Vector3(get_data_6, get_data_7, get_data_8)

	if not unit then
		stingray.Volumetrics.register_volume(unit, var_1_4, get_data_4, get_data_5, var_1_10)
	end
end

VolumetricsFlowCallbacks.unregister_fog_volume = function (self)
	-- function 2
	local unit = self.unit

	if not unit then
		stingray.Volumetrics.unregister_volume(unit)
	end
end

VolumetricsFlowCallbacks.register_fog_volume_manual = function (self)
	-- function 3
	local unit = self.unit

	if not unit then
		stingray.Volumetrics.register_volume(unit, self.albedo, self.extinction, self.phase, self.falloff)
	end
end

VolumetricsFlowCallbacks.update_fog_volume = function (self)
	-- function 4
	local unit = self.unit

	if not unit then
		stingray.Volumetrics.update_volume(unit, self.albedo, self.extinction, self.phase, self.falloff)
	end
end
