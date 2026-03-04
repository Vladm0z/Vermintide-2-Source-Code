-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_loot_rat_flee_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTLootRatFleeAction = class(BTLootRatFleeAction, BTNode)

BTLootRatFleeAction.init = function (arg_1_0, ...)
	BTLootRatFleeAction.super.init(arg_1_0, ...)
end

BTLootRatFleeAction.name = "BTLootRatFleeAction"

local var_0_0 = 2
local var_0_1 = 400
local var_0_2 = 14

BTLootRatFleeAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.is_fleeing = true
	arg_2_2.check_escaped_players_time = arg_2_3 + var_0_0

	if not arg_2_2.flee_node_data then
		local var_2_0 = Managers.state.conflict.main_path_info.merged_main_paths

		arg_2_2.flee_node_data = {
			direction = "fwd",
			nodes = {
				fwd = var_2_0.forward_list,
				bwd = var_2_0.reversed_list
			},
			break_nodes = {
				fwd = var_2_0.forward_break_list,
				bwd = var_2_0.reversed_break_list
			}
		}
	end

	if not arg_2_2.flee_astar_data then
		local var_2_1 = arg_2_2.navigation_extension

		arg_2_2.astar_id = "flee_astar"

		local var_2_2 = var_2_1:get_reusable_astar(arg_2_2.astar_id)
		local var_2_3 = var_2_1:traverse_logic()

		arg_2_2.flee_astar_data = {
			doing_astar = false,
			astar = var_2_2,
			traverse_logic = var_2_3
		}
	end

	arg_2_0:enter_state_moving_to_level_end(arg_2_1, arg_2_2)
end

BTLootRatFleeAction.run = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_2.spawn_to_running then
		arg_3_2.spawn_to_running = nil
		arg_3_2.start_anim_done = true
		arg_3_2.move_state = "moving"
		arg_3_2.start_anim_locked = nil

		arg_3_0:toggle_start_move_animation_lock(arg_3_1, false, arg_3_2)
	elseif not arg_3_2.movement_inited then
		arg_3_2.spawn_to_running = nil
		arg_3_2.start_anim_done = true
		arg_3_2.move_state = "moving"
		arg_3_2.start_anim_locked = nil
		arg_3_2.movement_inited = true

		Managers.state.network:anim_event(arg_3_1, "move_fwd")
		arg_3_0:toggle_start_move_animation_lock(arg_3_1, false, arg_3_2)
	end

	if arg_3_2.flee_state == "moving_to_level_end" then
		arg_3_0:update_state_moving_to_level_end(arg_3_1, arg_3_2, arg_3_3)
	end

	if arg_3_3 > arg_3_2.check_escaped_players_time then
		if arg_3_0:has_escaped_players(arg_3_1, arg_3_2) then
			arg_3_0:despawn(arg_3_1, arg_3_2, "escaped_players")
		end

		arg_3_2.check_escaped_players_time = arg_3_3 + var_0_0
	end

	return "running"
end

BTLootRatFleeAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_2.flee_astar_data

	if not GwNavAStar.processing_finished(var_4_0.astar) then
		GwNavAStar.cancel(var_4_0.astar)
	end

	arg_4_2.action = nil
	arg_4_2.check_escaped_players_time = nil

	if not arg_4_5 then
		arg_4_0:toggle_start_move_animation_lock(arg_4_1, false, arg_4_2)
	end

	arg_4_2.start_anim_locked = nil
	arg_4_2.anim_cb_rotation_start = nil
	arg_4_2.anim_cb_move = nil
	arg_4_2.start_anim_done = nil
	arg_4_2.movement_inited = nil
end

BTLootRatFleeAction.enter_state_moving_to_level_end = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:set_state(arg_5_2, "moving_to_level_end")

	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local var_5_1 = arg_5_2.flee_node_data
	local var_5_2 = var_5_1.nodes[var_5_1.direction]
	local var_5_3

	if var_5_1.target_node_index then
		var_5_3 = var_5_1.target_node_index
	else
		var_5_3 = MainPathUtils.closest_node_in_node_list(var_5_2, var_5_0)
	end

	arg_5_0:move_to_main_path_node(arg_5_2, var_5_3)
end

BTLootRatFleeAction.update_state_moving_to_level_end = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_2.flee_astar_data

	if var_6_0.doing_astar then
		local var_6_1 = var_6_0.astar

		if GwNavAStar.processing_finished(var_6_1) then
			var_6_0.doing_astar = false

			local var_6_2 = arg_6_2.flee_node_data
			local var_6_3 = var_6_2.target_node_index
			local var_6_4

			if GwNavAStar.path_found(var_6_1) and GwNavAStar.node_count(var_6_1) > 0 then
				var_6_4 = var_6_3 + 1
			else
				var_6_2.direction = var_6_2.direction == "fwd" and "bwd" or "fwd"
				var_6_4 = #var_6_2.nodes[var_6_2.direction] - var_6_3 + 2
			end

			arg_6_0:move_to_main_path_node(arg_6_2, var_6_4)
		else
			return
		end
	end

	local var_6_5 = POSITION_LOOKUP[arg_6_1]
	local var_6_6 = arg_6_2.flee_node_data
	local var_6_7 = var_6_6.target_node_index
	local var_6_8 = var_6_6.nodes[var_6_6.direction]
	local var_6_9 = var_6_6.break_nodes[var_6_6.direction]
	local var_6_10 = var_6_8[var_6_7]

	if script_data.ai_loot_rat_behavior then
		arg_6_0:debug_draw_path_nodes(arg_6_2.nav_world, var_6_8, var_6_9, var_6_7, arg_6_3)
	end

	if Vector3.length_squared(var_6_5 - var_6_10:unbox()) < 0.25 then
		local var_6_11 = var_6_7 + 1
		local var_6_12 = var_6_8[var_6_11]

		if var_6_12 then
			if var_6_9[var_6_10] then
				local var_6_13 = var_6_12:unbox()

				if Vector3.length_squared(var_6_5 - var_6_13) < var_0_1 then
					arg_6_0:do_astar_to_between_main_path_nodes(arg_6_2, var_6_7)

					return
				else
					var_6_6.direction = var_6_6.direction == "fwd" and "bwd" or "fwd"
					var_6_11 = #var_6_6.nodes[var_6_6.direction] - var_6_7 + 2
				end
			end
		else
			var_6_6.direction = var_6_6.direction == "fwd" and "bwd" or "fwd"
			var_6_11 = 2
		end

		arg_6_0:move_to_main_path_node(arg_6_2, var_6_11)
	end
end

BTLootRatFleeAction.move_to_main_path_node = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1.flee_node_data
	local var_7_1 = var_7_0.nodes[var_7_0.direction][arg_7_2]

	var_7_0.target_node_index = arg_7_2

	arg_7_1.navigation_extension:move_to(var_7_1:unbox())
end

BTLootRatFleeAction.do_astar_to_between_main_path_nodes = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1.flee_node_data
	local var_8_1 = var_8_0.nodes[var_8_0.direction]
	local var_8_2 = var_8_1[arg_8_2]:unbox()
	local var_8_3 = var_8_1[arg_8_2 + 1]:unbox()
	local var_8_4 = arg_8_1.flee_astar_data

	var_8_4.doing_astar = true

	GwNavAStar.start_with_propagation_box(var_8_4.astar, arg_8_1.nav_world, var_8_2, var_8_3, var_0_2, var_8_4.traverse_logic)
end

BTLootRatFleeAction.has_escaped_players = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.action.escaped_players_distance_sq
	local var_9_1 = POSITION_LOOKUP[arg_9_1]
	local var_9_2 = arg_9_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_9_0 = 1, #var_9_2 do
		local var_9_3 = var_9_2[iter_9_0]
		local var_9_4 = POSITION_LOOKUP[var_9_3]

		if var_9_0 > Vector3.distance_squared(var_9_1, var_9_4) then
			return false
		end
	end

	return true
end

BTLootRatFleeAction.despawn = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	Managers.state.conflict:destroy_unit(arg_10_1, arg_10_2, arg_10_3)
end

BTLootRatFleeAction.set_state = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_1.flee_state = arg_11_2
end

BTLootRatFleeAction.toggle_start_move_animation_lock = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_3.locomotion_extension

	if arg_12_2 then
		var_12_0:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_12_1, true, false, false)
	else
		var_12_0:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_12_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_12_1, 1)
	end
end

BTLootRatFleeAction.debug_draw_path_nodes = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	for iter_13_0 = 1, #arg_13_2 do
		local var_13_0 = arg_13_2[iter_13_0]
		local var_13_1 = var_13_0:unbox()

		if iter_13_0 == arg_13_4 then
			if arg_13_3[var_13_0] then
				QuickDrawer:sphere(var_13_1, 0.25 + math.sin(arg_13_5) * 0.15, Colors.get("dark_blue"))
			elseif GwNavQueries.triangle_from_position(arg_13_1, var_13_1, 1, 1) then
				QuickDrawer:sphere(var_13_1, 0.25 + math.sin(arg_13_5) * 0.15, Colors.get("pink"))
			else
				QuickDrawer:sphere(var_13_1, 0.25 + math.sin(arg_13_5) * 0.15, Colors.get("dark_red"))
			end
		elseif arg_13_3[var_13_0] then
			QuickDrawer:sphere(var_13_1, 0.25, Colors.get("orange"))
		else
			QuickDrawer:sphere(var_13_1, 0.25, Colors.get("dark_green"))
		end
	end
end
