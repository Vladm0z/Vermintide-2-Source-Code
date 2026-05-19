-- chunkname: @core/volumetrics/lua/volumetrics_flow_callbacks.lua

VolumetricsFlowCallbacks = VolumetricsFlowCallbacks or {}

function VolumetricsFlowCallbacks.register_fog_volume(arg_1_0)
	local var_1_0 = arg_1_0.unit
	local var_1_1 = stingray.Unit.get_data(var_1_0, "FogProperties", "albedo", 0)
	local var_1_2 = stingray.Unit.get_data(var_1_0, "FogProperties", "albedo", 1)
	local var_1_3 = stingray.Unit.get_data(var_1_0, "FogProperties", "albedo", 2)
	local var_1_4 = Vector3(var_1_1, var_1_2, var_1_3)
	local var_1_5 = stingray.Unit.get_data(var_1_0, "FogProperties", "extinction")
	local var_1_6 = stingray.Unit.get_data(var_1_0, "FogProperties", "phase")
	local var_1_7 = stingray.Unit.get_data(var_1_0, "FogProperties", "falloff", 0)
	local var_1_8 = stingray.Unit.get_data(var_1_0, "FogProperties", "falloff", 1)
	local var_1_9 = stingray.Unit.get_data(var_1_0, "FogProperties", "falloff", 2)
	local var_1_10 = Vector3(var_1_7, var_1_8, var_1_9)

	if var_1_0 then
		stingray.Volumetrics.register_volume(var_1_0, var_1_4, var_1_5, var_1_6, var_1_10)
	end
end

function VolumetricsFlowCallbacks.unregister_fog_volume(arg_2_0)
	local var_2_0 = arg_2_0.unit

	if var_2_0 then
		stingray.Volumetrics.unregister_volume(var_2_0)
	end
end

function VolumetricsFlowCallbacks.register_fog_volume_manual(arg_3_0)
	local var_3_0 = arg_3_0.unit

	if var_3_0 then
		stingray.Volumetrics.register_volume(var_3_0, arg_3_0.albedo, arg_3_0.extinction, arg_3_0.phase, arg_3_0.falloff)
	end
end

function VolumetricsFlowCallbacks.update_fog_volume(arg_4_0)
	local var_4_0 = arg_4_0.unit

	if var_4_0 then
		stingray.Volumetrics.update_volume(var_4_0, arg_4_0.albedo, arg_4_0.extinction, arg_4_0.phase, arg_4_0.falloff)
	end
end
