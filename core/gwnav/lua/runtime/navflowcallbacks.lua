-- chunkname: @core/gwnav/lua/runtime/navflowcallbacks.lua

require("core/gwnav/lua/safe_require")

GwNavFlowCallbacks = safe_require_guard()

local var_0_0 = safe_require("core/gwnav/lua/runtime/navroute")
local var_0_1 = safe_require("core/gwnav/lua/runtime/navworld")
local var_0_2 = safe_require("core/gwnav/lua/runtime/navbot")
local var_0_3 = safe_require("core/gwnav/lua/runtime/navboxobstacle")
local var_0_4 = safe_require("core/gwnav/lua/runtime/navcylinderobstacle")
local var_0_5 = stingray.Unit
local var_0_6 = stingray.Vector3
local var_0_7 = stingray.Vector3Box
local var_0_8 = stingray.Matrix4x4
local var_0_9 = {}

GwNavFlowCallbacks.create_navworld = function (arg_1_0)
	var_0_1(var_0_5.world(arg_1_0.unit), var_0_5.level(arg_1_0.unit))
end

GwNavFlowCallbacks.destroy_navworld = function (arg_2_0)
	var_0_1.get_navworld(var_0_5.level(arg_2_0.unit)):shutdown()
end

GwNavFlowCallbacks.update_navworld = function (arg_3_0)
	var_0_1.get_navworld(var_0_5.level(arg_3_0.unit)):update(arg_3_0.delta_time)
end

GwNavFlowCallbacks.add_navmesh = function (arg_4_0)
	var_0_1.get_navworld(var_0_5.level(arg_4_0.unit)):add_navdata(arg_4_0.name)
end

GwNavFlowCallbacks.create_navbot = function (arg_5_0)
	local var_5_0 = var_0_1.get_navworld(var_0_5.level(arg_5_0.unit))

	if arg_5_0.bot_configuration ~= nil then
		var_5_0:init_bot_from_unit(arg_5_0.unit, arg_5_0.bot_configuration)
	else
		var_5_0:init_bot(arg_5_0.unit)
	end
end

GwNavFlowCallbacks.destroy_navbot = function (arg_6_0)
	local var_6_0 = var_0_2.get_navbot(arg_6_0.unit)

	if var_6_0 then
		var_6_0:shutdown()
	end
end

GwNavFlowCallbacks.navbot_velocity = function (arg_7_0)
	local var_7_0 = var_0_2.get_navbot(arg_7_0.unit)

	if var_7_0 then
		arg_7_0.input_velocity = var_7_0:velocity()
	else
		arg_7_0.input_velocity = var_0_6(0, 0, 0)
	end

	return arg_7_0
end

GwNavFlowCallbacks.navbot_output_velocity = function (arg_8_0)
	local var_8_0 = var_0_2.get_navbot(arg_8_0.unit)

	if var_8_0 then
		arg_8_0.output_velocity = var_8_0:output_velocity()
	else
		arg_8_0.output_velocity = var_0_6(0, 0, 0)
	end

	return arg_8_0
end

GwNavFlowCallbacks.navbot_local_output_velocity = function (arg_9_0)
	local var_9_0 = var_0_2.get_navbot(arg_9_0.unit)

	if var_9_0 then
		arg_9_0.local_output_velocity = var_0_8.transform_without_translation(var_0_8.inverse(var_0_5.local_pose(arg_9_0.unit, 1)), var_9_0:output_velocity())
	else
		arg_9_0.local_output_velocity = var_0_6(0, 0, 0)
	end

	return arg_9_0
end

GwNavFlowCallbacks.navbot_destination = function (arg_10_0)
	local var_10_0 = var_0_2.get_navbot(arg_10_0.unit)

	if var_10_0 then
		arg_10_0.destination = var_10_0.destination:unbox()
	else
		arg_10_0.destination = var_0_6(0, 0, 0)
	end

	return arg_10_0
end

GwNavFlowCallbacks.set_navbot_destination = function (arg_11_0)
	local var_11_0 = var_0_2.get_navbot(arg_11_0.unit)

	if var_11_0 then
		var_11_0:set_destination(arg_11_0.destination)
	end
end

GwNavFlowCallbacks.navbot_move_unit = function (arg_12_0)
	local var_12_0 = var_0_2.get_navbot(arg_12_0.unit)

	if var_12_0 then
		var_12_0:move_unit(arg_12_0.delta_time)
	end
end

GwNavFlowCallbacks.navbot_move_unit_with_mover = function (arg_13_0)
	local var_13_0 = var_0_2.get_navbot(arg_13_0.unit)

	if var_13_0 then
		var_13_0:move_unit_with_mover(arg_13_0.delta_time, arg_13_0.gravity)
	end
end

GwNavFlowCallbacks.set_navbot_route = function (arg_14_0)
	local var_14_0 = var_0_9[arg_14_0.id]

	if var_14_0 then
		local var_14_1 = var_0_2.get_navbot(arg_14_0.unit)

		if var_14_1 then
			var_14_1:set_route(var_14_0:positions())
		end
	end
end

GwNavFlowCallbacks.navbot_set_layer_cost_multiplier = function (arg_15_0)
	local var_15_0 = var_0_2.get_navbot(arg_15_0.unit)

	if var_15_0 then
		var_15_0:set_layer_cost_multiplier(arg_15_0.layer, arg_15_0.cost)
	end
end

GwNavFlowCallbacks.navbot_allow_layer = function (arg_16_0)
	local var_16_0 = var_0_2.get_navbot(arg_16_0.unit)

	if var_16_0 then
		var_16_0:allow_layer(arg_16_0.layer)
	end
end

GwNavFlowCallbacks.navbot_forbid_layer = function (arg_17_0)
	local var_17_0 = var_0_2.get_navbot(arg_17_0.unit)

	if var_17_0 then
		var_17_0:forbid_layer(arg_17_0.layer)
	end
end

GwNavFlowCallbacks.create_route = function (arg_18_0)
	arg_18_0.route_id = tostring(#var_0_9 + 1)
	var_0_9[arg_18_0.route_id] = var_0_0()

	return arg_18_0
end

GwNavFlowCallbacks.add_position_to_route = function (arg_19_0)
	local var_19_0 = var_0_9[arg_19_0.route_id]

	if var_19_0 then
		var_19_0:add_position(var_0_5.local_position(arg_19_0.unit, 1))
	end
end

GwNavFlowCallbacks.navboxobstacle_create = function (arg_20_0)
	var_0_1.get_navworld(var_0_5.level(arg_20_0.world_unit)):add_boxobstacle(arg_20_0.obstacle_unit)
end

GwNavFlowCallbacks.navboxobstacle_destroy = function (arg_21_0)
	local var_21_0 = var_0_3.get_navboxstacle(arg_21_0.obstacle_unit)

	if var_21_0 then
		var_21_0:shutdown()
	end
end

GwNavFlowCallbacks.cylinderobstacle_create = function (arg_22_0)
	var_0_1.get_navworld(var_0_5.level(arg_22_0.world_unit)):add_cylinderobstacle(arg_22_0.obstacle_unit)
end

GwNavFlowCallbacks.cylinderobstacle_destroy = function (arg_23_0)
	local var_23_0 = var_0_4.get_navcylinderostacle(arg_23_0.obstacle_unit)

	if var_23_0 then
		var_23_0:shutdown()
	end
end

return GwNavFlowCallbacks
