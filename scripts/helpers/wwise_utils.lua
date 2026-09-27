-- chunkname: @scripts/helpers/wwise_utils.lua

local WwiseUtils = WwiseUtils

WwiseUtils = WwiseUtils or {}
WwiseUtils = WwiseUtils
WwiseUtils.EVENT_ID_NONE = 0

WwiseUtils.trigger_position_event = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local make_position_auto_source, var_1_1 = WwiseUtils.make_position_auto_source(arg_1_0, arg_1_2)

	return WwiseWorld.trigger_event(var_1_1, arg_1_1, make_position_auto_source), make_position_auto_source, var_1_1
end

WwiseUtils.trigger_unit_event = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	if not DEDICATED_SERVER then
		return nil, nil, nil
	end

	local make_unit_auto_source, var_2_1 = WwiseUtils.make_unit_auto_source(arg_2_0, arg_2_2, arg_2_3)

	return WwiseWorld.trigger_event(var_2_1, arg_2_1, make_unit_auto_source), make_unit_auto_source, var_2_1
end

WwiseUtils.make_position_auto_source = function (arg_3_0, arg_3_1)
	-- function 3
	local wwise_world = Managers.world:wwise_world(arg_3_0)
	local make_auto_source = WwiseWorld.make_auto_source(wwise_world, arg_3_1)
	local system = Managers.state.entity:system("sound_environment_system")

	if system ~= nil then
		system:set_source_environment(make_auto_source, arg_3_1)
	end

	return make_auto_source, wwise_world
end

WwiseUtils.make_unit_auto_source = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local wwise_world = Managers.world:wwise_world(arg_4_0)
	local var_4_1
	local var_4_2

	if not arg_4_2 then
		var_4_1 = WwiseWorld.make_auto_source(wwise_world, arg_4_1, arg_4_2)
		var_4_2 = Unit.world_position(arg_4_1, arg_4_2)
	else
		var_4_1 = WwiseWorld.make_auto_source(wwise_world, arg_4_1)
		var_4_2 = Unit.world_position(arg_4_1, 0)
	end

	local system = Managers.state.entity:system("sound_environment_system")

	if system ~= nil then
		system:set_source_environment(var_4_1, var_4_2)
	end

	return var_4_1, wwise_world
end

WwiseUtils.make_unit_manual_source = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0

	if not arg_5_2 then
		var_5_0 = WwiseWorld.make_manual_source(arg_5_0, arg_5_1, arg_5_2)
	else
		var_5_0 = WwiseWorld.make_manual_source(arg_5_0, arg_5_1)
	end

	local system = Managers.state.entity:system("sound_environment_system")

	if system ~= nil then
		local world_position = Unit.world_position(arg_5_1, arg_5_2 or 0)

		system:set_source_environment(var_5_0, world_position)
	end

	return var_5_0
end
