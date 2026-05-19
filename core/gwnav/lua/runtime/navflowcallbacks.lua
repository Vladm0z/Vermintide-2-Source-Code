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

function GwNavFlowCallbacks.create_navworld(arg_1_0)
	var_0_1(var_0_5.world(arg_1_0.unit), var_0_5.level(arg_1_0.unit))
end

function GwNavFlowCallbacks.destroy_navworld(arg_2_0)
	var_0_1.get_navworld(var_0_5.level(arg_2_0.unit)):shutdown()
end

function GwNavFlowCallbacks.update_navworld(arg_3_0)
	var_0_1.get_navworld(var_0_5.level(arg_3_0.unit)):update(arg_3_0.delta_time)
end

function GwNavFlowCallbacks.add_navmesh(arg_4_0)
	var_0_1.get_navworld(var_0_5.level(arg_4_0.unit)):add_navdata(arg_4_0.name)
end

function GwNavFlowCallbacks.create_navbot(arg_5_0)
	local var_5_0 = var_0_1.get_navworld(var_0_5.level(arg_5_0.unit))

	if arg_5_0.bot_configuration ~= nil then
		var_5_0:init_bot_from_unit(arg_5_0.unit, arg_5_0.bot_configuration)
	else
		var_5_0:init_bot(arg_5_0.unit)
	end
end

function GwNavFlowCallbacks.destroy_navbot(arg_6_0)
	local var_6_0 = var_0_2.get_navbot(arg_6_0.unit)

	if var_6_0 then
		var_6_0:shutdown()
	end
end

function GwNavFlowCallbacks.navbot_velocity(arg_7_0)
	local var_7_0 = var_0_2.get_navbot(arg_7_0.unit)

	if var_7_0 then
		arg_7_0.input_velocity = var_7_0:velocity()
	else
		arg_7_0.input_velocity = var_0_6(0, 0, 0)
	end

	return arg_7_0
end

function GwNavFlowCallbacks.navbot_output_velocity(arg_8_0)
	local var_8_0 = var_0_2.get_navbot(arg_8_0.unit)

	if var_8_0 then
		arg_8_0.output_velocity = var_8_0:output_velocity()
	else
		arg_8_0.output_velocity = var_0_6(0, 0, 0)
	end

	return arg_8_0
end

function GwNavFlowCallbacks.navbot_local_output_velocity(arg_9_0)
	local var_9_0 = var_0_2.get_navbot(arg_9_0.unit)

	if var_9_0 then
		arg_9_0.local_output_velocity = var_0_8.transform_without_translation(var_0_8.inverse(var_0_5.local_pose(arg_9_0.unit, 1)), var_9_0:output_velocity())
	else
		arg_9_0.local_output_velocity = var_0_6(0, 0, 0)
	end

	return arg_9_0
end

function GwNavFlowCallbacks.navbot_destination(arg_10_0)
	local var_10_0 = var_0_2.get_navbot(arg_10_0.unit)

	if var_10_0 then
		arg_10_0.destination = var_10_0.destination:unbox()
	else
		arg_10_0.destination = var_0_6(0, 0, 0)
	end

	return arg_10_0
end

function GwNavFlowCallbacks.set_navbot_destination(arg_11_0)
	local var_11_0 = var_0_2.get_navbot(arg_11_0.unit)

	if var_11_0 then
		var_11_0:set_destination(arg_11_0.destination)
	end
end

function GwNavFlowCallbacks.navbot_move_unit(arg_12_0)
	local var_12_0 = var_0_2.get_navbot(arg_12_0.unit)

	if var_12_0 then
		var_12_0:move_unit(arg_12_0.delta_time)
	end
end

function GwNavFlowCallbacks.navbot_move_unit_with_mover(arg_13_0)
	local var_13_0 = var_0_2.get_navbot(arg_13_0.unit)

	if var_13_0 then
		var_13_0:move_unit_with_mover(arg_13_0.delta_time, arg_13_0.gravity)
	end
end

function GwNavFlowCallbacks.set_navbot_route(arg_14_0)
	local var_14_0 = var_0_9[arg_14_0.id]

	if var_14_0 then
		local var_14_1 = var_0_2.get_navbot(arg_14_0.unit)

		if var_14_1 then
			var_14_1:set_route(var_14_0:positions())
		end
	end
end

function GwNavFlowCallbacks.navbot_set_layer_cost_multiplier(arg_15_0)
	local var_15_0 = var_0_2.get_navbot(arg_15_0.unit)

	if var_15_0 then
		var_15_0:set_layer_cost_multiplier(arg_15_0.layer, arg_15_0.cost)
	end
end

function GwNavFlowCallbacks.navbot_allow_layer(arg_16_0)
	local var_16_0 = var_0_2.get_navbot(arg_16_0.unit)

	if var_16_0 then
		var_16_0:allow_layer(arg_16_0.layer)
	end
end

function GwNavFlowCallbacks.navbot_forbid_layer(arg_17_0)
	local var_17_0 = var_0_2.get_navbot(arg_17_0.unit)

	if var_17_0 then
		var_17_0:forbid_layer(arg_17_0.layer)
	end
end

function GwNavFlowCallbacks.create_route(arg_18_0)
	arg_18_0.route_id = tostring(#var_0_9 + 1)
	var_0_9[arg_18_0.route_id] = var_0_0()

	return arg_18_0
end

function GwNavFlowCallbacks.add_position_to_route(arg_19_0)
	local var_19_0 = var_0_9[arg_19_0.route_id]

	if var_19_0 then
		var_19_0:add_position(var_0_5.local_position(arg_19_0.unit, 1))
	end
end

function GwNavFlowCallbacks.navboxobstacle_create(arg_20_0)
	var_0_1.get_navworld(var_0_5.level(arg_20_0.world_unit)):add_boxobstacle(arg_20_0.obstacle_unit)
end

function GwNavFlowCallbacks.navboxobstacle_destroy(arg_21_0)
	local var_21_0 = var_0_3.get_navboxstacle(arg_21_0.obstacle_unit)

	if var_21_0 then
		var_21_0:shutdown()
	end
end

function GwNavFlowCallbacks.cylinderobstacle_create(arg_22_0)
	var_0_1.get_navworld(var_0_5.level(arg_22_0.world_unit)):add_cylinderobstacle(arg_22_0.obstacle_unit)
end

function GwNavFlowCallbacks.cylinderobstacle_destroy(arg_23_0)
	local var_23_0 = var_0_4.get_navcylinderostacle(arg_23_0.obstacle_unit)

	if var_23_0 then
		var_23_0:shutdown()
	end
end

return GwNavFlowCallbacks
