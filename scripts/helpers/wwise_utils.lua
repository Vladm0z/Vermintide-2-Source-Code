-- chunkname: @scripts/helpers/wwise_utils.lua

WwiseUtils = WwiseUtils or {}
WwiseUtils.EVENT_ID_NONE = 0

function WwiseUtils.trigger_position_event(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0, var_1_1 = WwiseUtils.make_position_auto_source(arg_1_0, arg_1_2)

	return WwiseWorld.trigger_event(var_1_1, arg_1_1, var_1_0), var_1_0, var_1_1
end

function WwiseUtils.trigger_unit_event(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if DEDICATED_SERVER then
		return nil, nil, nil
	end

	local var_2_0, var_2_1 = WwiseUtils.make_unit_auto_source(arg_2_0, arg_2_2, arg_2_3)

	return WwiseWorld.trigger_event(var_2_1, arg_2_1, var_2_0), var_2_0, var_2_1
end

function WwiseUtils.make_position_auto_source(arg_3_0, arg_3_1)
	local var_3_0 = Managers.world:wwise_world(arg_3_0)
	local var_3_1 = WwiseWorld.make_auto_source(var_3_0, arg_3_1)
	local var_3_2 = Managers.state.entity:system("sound_environment_system")

	if var_3_2 ~= nil then
		var_3_2:set_source_environment(var_3_1, arg_3_1)
	end

	return var_3_1, var_3_0
end

function WwiseUtils.make_unit_auto_source(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = Managers.world:wwise_world(arg_4_0)
	local var_4_1
	local var_4_2

	if arg_4_2 then
		var_4_1 = WwiseWorld.make_auto_source(var_4_0, arg_4_1, arg_4_2)
		var_4_2 = Unit.world_position(arg_4_1, arg_4_2)
	else
		var_4_1 = WwiseWorld.make_auto_source(var_4_0, arg_4_1)
		var_4_2 = Unit.world_position(arg_4_1, 0)
	end

	local var_4_3 = Managers.state.entity:system("sound_environment_system")

	if var_4_3 ~= nil then
		var_4_3:set_source_environment(var_4_1, var_4_2)
	end

	return var_4_1, var_4_0
end

function WwiseUtils.make_unit_manual_source(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0

	if arg_5_2 then
		var_5_0 = WwiseWorld.make_manual_source(arg_5_0, arg_5_1, arg_5_2)
	else
		var_5_0 = WwiseWorld.make_manual_source(arg_5_0, arg_5_1)
	end

	local var_5_1 = Managers.state.entity:system("sound_environment_system")

	if var_5_1 ~= nil then
		local var_5_2 = Unit.world_position(arg_5_1, arg_5_2 or 0)

		var_5_1:set_source_environment(var_5_0, var_5_2)
	end

	return var_5_0
end
