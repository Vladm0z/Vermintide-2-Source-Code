-- chunkname: @core/gwnav/lua/runtime/navbot.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = safe_require("core/gwnav/lua/runtime/navdefaultsmartobjectfollower")
local var_0_3 = stingray.Math
local var_0_4 = stingray.Vector3
local var_0_5 = stingray.Vector3Box
local var_0_6 = stingray.Matrix4x4
local var_0_7 = stingray.Matrix4x4Box
local var_0_8 = stingray.Quaternion
local var_0_9 = stingray.QuaternionBox
local var_0_10 = stingray.Gui
local var_0_11 = stingray.World
local var_0_12 = stingray.Unit
local var_0_13 = stingray.Application
local var_0_14 = stingray.Color
local var_0_15 = stingray.LineObject
local var_0_16 = stingray.Level
local var_0_17 = stingray.Mover
local var_0_18 = stingray.GwNavWorld
local var_0_19 = stingray.GwNavBot
local var_0_20 = stingray.GwNavSmartObjectInterval
local var_0_21 = stingray.GwNavQueries
local var_0_22 = stingray.GwNavAStar
local var_0_23 = stingray.GwNavSmartObject
local var_0_24 = stingray.GwNavTagVolume
local var_0_25 = stingray.GwNavBoxObstacle
local var_0_26 = stingray.GwNavCylinderObstacle
local var_0_27 = stingray.GwNavGraph
local var_0_28 = stingray.GwNavTraversal
local var_0_29 = {}

function var_0_1.get_navbot(arg_1_0)
	return var_0_29[arg_1_0]
end

function var_0_1.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.navworld = arg_2_1
	arg_2_0.unit = arg_2_2
	arg_2_0.config = arg_2_3
	var_0_29[arg_2_0.unit] = arg_2_0

	local var_2_0 = var_0_12.local_position(arg_2_0.unit, 1)

	arg_2_0.route = {}
	arg_2_0.arrival_distance = 1
	arg_2_0.smartobjects = arg_2_1.smartobjects
	arg_2_0.next_smartobject_max_distance = 2
	arg_2_0.is_smartobject_driven = false
	arg_2_0.follower = var_0_2(arg_2_0)
	arg_2_0.gwnavbot = var_0_19.create(arg_2_1.gwnavworld, arg_2_0.config.height, arg_2_0.config.radius, arg_2_0.config.speed, var_2_0)
	arg_2_0.interval = var_0_20.create(arg_2_0.navworld.gwnavworld)

	arg_2_3:configure_bot(arg_2_0)

	arg_2_0.destination = var_0_5(var_2_0)
	arg_2_0.has_destination = false
	arg_2_0.target_route_vertex = 1
	arg_2_0.moving = false

	arg_2_1:add_bot(arg_2_0)
end

function var_0_1.set_use_avoidance(arg_3_0, arg_3_1)
	var_0_19.set_use_avoidance(arg_3_0.gwnavbot, arg_3_1)
end

function var_0_1.set_navtag_layer_cost_table(arg_4_0, arg_4_1)
	var_0_19.set_navtag_layer_cost_table(arg_4_0.gwnavbot, arg_4_1)
end

function var_0_1.set_use_channel(arg_5_0, arg_5_1)
	var_0_19.set_use_channel(arg_5_0.gwnavbot, arg_5_1)
end

function var_0_1.get_target_group(arg_6_0)
	return arg_6_0.config.target_group
end

function var_0_1.set_destination(arg_7_0, arg_7_1)
	if arg_7_1 == arg_7_0.destination:unbox() then
		arg_7_0:on_recompute_path_to_similar_destination_for_crowd_dispersion()
	else
		arg_7_0:on_compute_path_to_brand_new_destination_for_crowd_dispersion()
	end

	arg_7_0.destination:store(arg_7_1)
	var_0_19.compute_new_path(arg_7_0.gwnavbot, arg_7_1)

	arg_7_0.has_destination = true
end

function var_0_1.set_route(arg_8_0, arg_8_1)
	arg_8_0.route = arg_8_1
end

function var_0_1.velocity(arg_9_0)
	return var_0_19.velocity(arg_9_0.gwnavbot)
end

function var_0_1.output_velocity(arg_10_0)
	if not arg_10_0:has_arrived() then
		return var_0_19.output_velocity(arg_10_0.gwnavbot)
	else
		return var_0_4(0, 0, 0)
	end
end

function var_0_1.set_layer_cost_multiplier(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = var_0_19.navtag_layer_cost_table(arg_11_0.gwnavbot)

	if var_11_0 ~= nil then
		GwNavTagLayerCostTable.set_layer_cost_multiplier(var_11_0, arg_11_1, arg_11_2)
	end
end

function var_0_1.allow_layer(arg_12_0, arg_12_1)
	local var_12_0 = var_0_19.navtag_layer_cost_table(arg_12_0.gwnavbot)

	if var_12_0 ~= nil then
		GwNavTagLayerCostTable.allow_layer(var_12_0, arg_12_1)
	end
end

function var_0_1.forbid_layer(arg_13_0, arg_13_1)
	local var_13_0 = var_0_19.navtag_layer_cost_table(arg_13_0.gwnavbot)

	if var_13_0 ~= nil then
		GwNavTagLayerCostTable.forbid_layer(var_13_0, arg_13_1)
	end
end

function var_0_1.repath(arg_14_0)
	arg_14_0:set_destination(arg_14_0.route[arg_14_0.target_route_vertex + 1]:unbox())
end

function var_0_1.force_repath(arg_15_0)
	if arg_15_0.has_destination == true and arg_15_0.is_smartobject_driven == false then
		arg_15_0:repath()
	end
end

function var_0_1.set_avoidance_computer_config(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	var_0_19.set_avoidance_computer_configuration(arg_16_0.gwnavbot, arg_16_1, arg_16_2, arg_16_3)
end

function var_0_1.set_avoidance_collider_collector_config(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	var_0_19.set_avoidance_collider_collector_configuration(arg_17_0.gwnavbot, arg_17_1, arg_17_2, arg_17_3)
end

function var_0_1.set_avoidance_behavior(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
	var_0_19.set_avoidance_behavior(arg_18_0.gwnavbot, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
end

function var_0_1.set_channel_config(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	var_0_19.set_channel_computer_configuration(arg_19_0.gwnavbot, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
end

function var_0_1.set_spline_trajectory_config(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	var_0_19.set_spline_trajectory_configuration(arg_20_0.gwnavbot, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
end

function var_0_1.set_propagation_box(arg_21_0, arg_21_1)
	var_0_19.set_propagation_box(arg_21_0.gwnavbot, arg_21_1)
end

function var_0_1.set_outside_navmesh_distance(arg_22_0, arg_22_1, arg_22_2)
	var_0_19.set_outside_navmesh_distance(arg_22_0.gwnavbot, arg_22_1, arg_22_2)
end

function var_0_1.visual_debug_draw_line(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	return
end

function var_0_1.get_remaining_distance_from_progress_to_end_of_path(arg_24_0)
	return var_0_19.get_remaining_distance_from_progress_to_end_of_path(arg_24_0.gwnavbot)
end

function var_0_1.shutdown(arg_25_0)
	arg_25_0.navworld:remove_bot(arg_25_0)
	var_0_20.destroy(arg_25_0.interval)
	var_0_19.destroy(arg_25_0.gwnavbot)

	arg_25_0.gwnavworld = nil
	arg_25_0.gwnavbot = nil
	arg_25_0.interval = nil
	arg_25_0.route = {}
	var_0_29[arg_25_0.unit] = nil
end

function var_0_1.update_crowd_dispersion(arg_26_0)
	local var_26_0 = var_0_19.update_logic_for_crowd_dispersion(arg_26_0.gwnavbot)

	if var_26_0 == 1 then
		if not var_0_19.is_computing_path(arg_26_0.gwnavbot) then
			arg_26_0:next_route_index()
			arg_26_0:set_destination(arg_26_0.route[arg_26_0.target_route_vertex]:unbox())
		end
	elseif var_26_0 == 2 and var_0_19.is_computing_path(arg_26_0.gwnavbot) then
		print("self:cancel()")
	end
end

function var_0_1.on_recompute_path_to_similar_destination_for_crowd_dispersion(arg_27_0)
	var_0_19.on_recompute_path_to_similar_destination_for_crowd_dispersion(arg_27_0.gwnavbot)
end

function var_0_1.on_compute_path_to_brand_new_destination_for_crowd_dispersion(arg_28_0)
	var_0_19.on_compute_path_to_brand_new_destination_for_crowd_dispersion(arg_28_0.gwnavbot)
end

function var_0_1.next_route_index(arg_29_0)
	arg_29_0.target_route_vertex = math.max((arg_29_0.target_route_vertex + 1) % (table.getn(arg_29_0.route) + 1), 1)
end

function var_0_1.update_route(arg_30_0)
	local var_30_0 = table.getn(arg_30_0.route)

	if var_30_0 == 0 then
		return
	end

	if not var_0_19.is_computing_new_path(arg_30_0.gwnavbot) and var_0_19.is_path_recomputation_needed(arg_30_0.gwnavbot) then
		arg_30_0:set_destination(arg_30_0.route[arg_30_0.target_route_vertex]:unbox())
	end

	if arg_30_0.has_destination == false then
		arg_30_0:next_route_index()
		arg_30_0:set_destination(arg_30_0.route[arg_30_0.target_route_vertex]:unbox())
	end

	if arg_30_0:has_arrived() then
		if var_30_0 == 1 then
			arg_30_0.has_destination = false
			arg_30_0.route = {}
		else
			arg_30_0:next_route_index()
			arg_30_0:set_destination(arg_30_0.route[arg_30_0.target_route_vertex]:unbox())
		end
	end
end

function var_0_1.has_arrived(arg_31_0)
	return var_0_4.distance(arg_31_0:get_position(), arg_31_0.destination:unbox()) < arg_31_0.arrival_distance
end

function var_0_1.visual_debug_next_smartobject(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	arg_32_0:visual_debug_draw_line("next_smart_object", "stingray", arg_32_1, arg_32_3, var_0_14(0, 255, 0, 0), true)

	if arg_32_2 == true then
		arg_32_0:visual_debug_draw_line("next_smart_object", "stingray", arg_32_1, arg_32_1 + var_0_4(0, 0, 3), var_0_14(255, 100, 20, 0), true)
	else
		arg_32_0:visual_debug_draw_line("next_smart_object", "stingray", arg_32_1, arg_32_1 + var_0_4(0, 0, 3), var_0_14(0, 255, 0, 0), true)
	end

	if arg_32_4 == true then
		arg_32_0:visual_debug_draw_line("next_smart_object", "stingray", arg_32_3, arg_32_3 + var_0_4(0, 0, 3), var_0_14(255, 100, 20, 0), true)
	else
		arg_32_0:visual_debug_draw_line("next_smart_object", "stingray", arg_32_3, arg_32_3 + var_0_4(0, 0, 3), var_0_14(0, 255, 0, 0), true)
	end
end

function var_0_1.update_next_smartobject(arg_33_0)
	if var_0_19.current_or_next_smartobject_interval(arg_33_0.gwnavbot, arg_33_0.interval, arg_33_0.next_smartobject_max_distance) == false then
		return
	end

	local var_33_0, var_33_1 = var_0_20.entrance_position(arg_33_0.interval)
	local var_33_2, var_33_3 = var_0_20.exit_position(arg_33_0.interval)

	arg_33_0:visual_debug_next_smartobject(var_33_0, var_33_1, var_33_2, var_33_3)
	arg_33_0.follower:handle_next_smartobject(arg_33_0:get_position(), arg_33_0.interval, var_33_0, var_33_1, var_33_2, var_33_3)
end

function var_0_1.verbose_smartobject_management(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
	if arg_34_3 == true then
		local var_34_0 = arg_34_0.follower:get_smartobject_type(arg_34_2)

		print("Inside smartobject", var_34_0)

		if arg_34_4 == true then
			print("End of path is inside this smartobject")
		end
	elseif arg_34_6 > var_0_4.distance(arg_34_5, arg_34_1) then
		local var_34_1 = arg_34_0.follower:get_smartobject_type(arg_34_2)

		print("Approaching smartobject", var_34_1)

		if arg_34_4 == true then
			print("End of path is inside this smartobject")
		end
	end
end

function var_0_1.update(arg_35_0, arg_35_1)
	arg_35_0:update_next_smartobject()
	arg_35_0:update_crowd_dispersion()
	arg_35_0:update_route()

	if arg_35_0.is_smartobject_driven == true then
		arg_35_0.follower:update_follow(arg_35_1)
	end

	if arg_35_0.custom_update then
		arg_35_0:custom_update(arg_35_1)
	end

	if not var_0_19.is_computing_new_path(arg_35_0.gwnavbot) and var_0_19.is_path_recomputation_needed(arg_35_0.gwnavbot) then
		arg_35_0:set_destination(arg_35_0.destination:unbox())
	end

	var_0_19.update_position(arg_35_0.gwnavbot, arg_35_0:get_position(), arg_35_1)
end

function var_0_1.get_position(arg_36_0)
	return var_0_12.local_position(arg_36_0.unit, 1)
end

function var_0_1.debug_draw(arg_37_0, arg_37_1)
	if arg_37_1 == nil then
		return
	end

	local var_37_0 = var_0_12.local_pose(arg_37_0.unit, 1)
	local var_37_1 = var_0_6.translation(var_37_0)

	var_0_15.add_line(arg_37_1, var_0_14(255, 0, 0, 255), var_37_1, var_37_1 + var_0_6.x(var_37_0))
	var_0_15.add_line(arg_37_1, var_0_14(255, 0, 255, 0), var_37_1, var_37_1 + var_0_6.y(var_37_0))
	var_0_15.add_line(arg_37_1, var_0_14(255, 255, 0, 0), var_37_1, var_37_1 + var_0_6.z(var_37_0))
end

function var_0_1.compute_height_on_navmesh(arg_38_0, arg_38_1)
	local var_38_0, var_38_1, var_38_2, var_38_3 = var_0_21.triangle_from_position(arg_38_0.navworld.gwnavworld, arg_38_1)

	if var_38_0 ~= nil then
		arg_38_1[3] = var_38_0
	end

	return arg_38_1
end

function var_0_1.update_pose(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = var_0_12.local_pose(arg_39_0.unit, 1)

	if var_0_4.length(arg_39_1) ~= 0 then
		var_0_6.set_forward(var_39_0, arg_39_1)
		var_0_6.set_right(var_39_0, var_0_4.cross(arg_39_1, var_0_6.up(var_39_0)))
	end

	var_0_6.set_translation(var_39_0, arg_39_2)
	var_0_12.set_local_pose(arg_39_0.unit, 1, var_39_0)
end

function var_0_1.move_unit(arg_40_0, arg_40_1)
	if arg_40_0.is_smartobject_driven == false then
		local var_40_0 = var_0_19.output_velocity(arg_40_0.gwnavbot)

		arg_40_0:update_pose(var_0_4.normalize(var_40_0), var_0_19.compute_move_on_navmesh(arg_40_0.gwnavbot, arg_40_1, var_40_0))
	else
		arg_40_0.follower:move_unit(arg_40_1)
	end

	var_0_19.update_position(arg_40_0.gwnavbot, arg_40_0:get_position(), arg_40_1)
end

function var_0_1.animation_wanted_delta(arg_41_0)
	if var_0_12.has_animation_state_machine(arg_41_0.unit) and var_0_12.animation_root_mode(arg_41_0.unit) == "ignore" then
		return var_0_4.length(var_0_6.translation(var_0_12.animation_wanted_root_pose(arg_41_0.unit)) - var_0_12.local_position(arg_41_0.unit, 1))
	end

	return nil
end

function var_0_1.move_unit_with_mover(arg_42_0, arg_42_1, arg_42_2)
	if arg_42_0.is_smartobject_driven == false then
		local var_42_0 = var_0_12.mover(arg_42_0.unit)

		if var_42_0 == nil then
			return
		end

		local var_42_1 = var_0_19.output_velocity(arg_42_0.gwnavbot)
		local var_42_2 = var_42_1 * arg_42_1

		var_42_2.z = var_42_2.z - arg_42_1 * arg_42_2

		var_0_17.move(var_42_0, var_42_2, arg_42_1)
		arg_42_0:update_pose(var_0_4.normalize(var_42_1), var_0_17.position(var_42_0))
	else
		arg_42_0.follower:move_unit_with_mover(arg_42_1, mover)
	end

	var_0_19.update_position(arg_42_0.gwnavbot, arg_42_0:get_position(), arg_42_1)
end

return var_0_1
