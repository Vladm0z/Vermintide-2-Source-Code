-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_loot_rat_flee_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTLootRatFleeAction = class(BTLootRatFleeAction, BTNode)

BTLootRatFleeAction.init = function (arg_1_0, ...)
	-- function 1
	BTLootRatFleeAction.super.init(arg_1_0, ...)
end

BTLootRatFleeAction.name = "BTLootRatFleeAction"

local num = 2
local num_2 = 400
local num_3 = 14

BTLootRatFleeAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.is_fleeing = true
	arg_2_2.check_escaped_players_time = arg_2_3 + num

	if not arg_2_2.flee_node_data then
		local merged_main_paths = Managers.state.conflict.main_path_info.merged_main_paths

		arg_2_2.flee_node_data = {
			direction = "fwd",
			nodes = {
				fwd = merged_main_paths.forward_list,
				bwd = merged_main_paths.reversed_list
			},
			break_nodes = {
				fwd = merged_main_paths.forward_break_list,
				bwd = merged_main_paths.reversed_break_list
			}
		}
	end

	if not arg_2_2.flee_astar_data then
		local navigation_extension = arg_2_2.navigation_extension

		arg_2_2.astar_id = "flee_astar"

		local get_reusable_astar = navigation_extension:get_reusable_astar(arg_2_2.astar_id)
		local traverse_logic = navigation_extension:traverse_logic()

		arg_2_2.flee_astar_data = {
			doing_astar = false,
			astar = get_reusable_astar,
			traverse_logic = traverse_logic
		}
	end

	self:enter_state_moving_to_level_end(arg_2_1, arg_2_2)
end

BTLootRatFleeAction.run = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not arg_3_2.spawn_to_running then
		arg_3_2.spawn_to_running = nil
		arg_3_2.start_anim_done = true
		arg_3_2.move_state = "moving"
		arg_3_2.start_anim_locked = nil

		self:toggle_start_move_animation_lock(arg_3_1, false, arg_3_2)
	elseif not arg_3_2.movement_inited then
		arg_3_2.spawn_to_running = nil
		arg_3_2.start_anim_done = true
		arg_3_2.move_state = "moving"
		arg_3_2.start_anim_locked = nil
		arg_3_2.movement_inited = true

		Managers.state.network:anim_event(arg_3_1, "move_fwd")
		self:toggle_start_move_animation_lock(arg_3_1, false, arg_3_2)
	end

	if arg_3_2.flee_state == "moving_to_level_end" then
		self:update_state_moving_to_level_end(arg_3_1, arg_3_2, arg_3_3)
	end

	if arg_3_3 > arg_3_2.check_escaped_players_time then
		if not self:has_escaped_players(arg_3_1, arg_3_2) then
			self:despawn(arg_3_1, arg_3_2, "escaped_players")
		end

		arg_3_2.check_escaped_players_time = arg_3_3 + num
	end

	return "running"
end

BTLootRatFleeAction.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local flee_astar_data = arg_4_2.flee_astar_data

	if not GwNavAStar.processing_finished(flee_astar_data.astar) then
		GwNavAStar.cancel(flee_astar_data.astar)
	end

	arg_4_2.action = nil
	arg_4_2.check_escaped_players_time = nil

	if not arg_4_5 then
		self:toggle_start_move_animation_lock(arg_4_1, false, arg_4_2)
	end

	arg_4_2.start_anim_locked = nil
	arg_4_2.anim_cb_rotation_start = nil
	arg_4_2.anim_cb_move = nil
	arg_4_2.start_anim_done = nil
	arg_4_2.movement_inited = nil
end

BTLootRatFleeAction.enter_state_moving_to_level_end = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:set_state(arg_5_2, "moving_to_level_end")

	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local flee_node_data = arg_5_2.flee_node_data
	local var_5_2 = flee_node_data.nodes[flee_node_data.direction]
	local var_5_3

	if not flee_node_data.target_node_index then
		var_5_3 = flee_node_data.target_node_index
	else
		var_5_3 = MainPathUtils.closest_node_in_node_list(var_5_2, var_5_0)
	end

	self:move_to_main_path_node(arg_5_2, var_5_3)
end

BTLootRatFleeAction.update_state_moving_to_level_end = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local flee_astar_data = arg_6_2.flee_astar_data

	if not flee_astar_data.doing_astar then
		local astar = flee_astar_data.astar

		if not GwNavAStar.processing_finished(astar) then
			flee_astar_data.doing_astar = false

			local flee_node_data = arg_6_2.flee_node_data
			local target_node_index = flee_node_data.target_node_index
			local var_6_4

			if not (not GwNavAStar.path_found(astar) and not (GwNavAStar.node_count(astar) > 0)) then
				var_6_4 = target_node_index + 1
			else
				local flag

				flag = flee_node_data.direction ~= "fwd" or not "bwd" or "fwd"
				flee_node_data.direction = flag
				var_6_4 = #flee_node_data.nodes[flee_node_data.direction] - target_node_index + 2
			end

			self:move_to_main_path_node(arg_6_2, var_6_4)
		else
			return
		end
	end

	local var_6_6 = POSITION_LOOKUP[arg_6_1]
	local flee_node_data_2 = arg_6_2.flee_node_data
	local target_node_index_2 = flee_node_data_2.target_node_index
	local var_6_9 = flee_node_data_2.nodes[flee_node_data_2.direction]
	local var_6_10 = flee_node_data_2.break_nodes[flee_node_data_2.direction]
	local var_6_11 = var_6_9[target_node_index_2]

	if not script_data.ai_loot_rat_behavior then
		self:debug_draw_path_nodes(arg_6_2.nav_world, var_6_9, var_6_10, target_node_index_2, arg_6_3)
	end

	if Vector3.length_squared(var_6_6 - var_6_11:unbox()) < 0.25 then
		local num = target_node_index_2 + 1
		local var_6_13 = var_6_9[num]

		if not var_6_13 then
			if not var_6_10[var_6_11] then
				local unbox = var_6_13:unbox()

				if Vector3.length_squared(var_6_6 - unbox) < num_2 then
					self:do_astar_to_between_main_path_nodes(arg_6_2, target_node_index_2)

					return
				else
					local flag_2

					flag_2 = flee_node_data_2.direction ~= "fwd" or not "bwd" or "fwd"
					flee_node_data_2.direction = flag_2
					num = #flee_node_data_2.nodes[flee_node_data_2.direction] - target_node_index_2 + 2
				end
			end
		else
			local flag_3

			flag_3 = flee_node_data_2.direction ~= "fwd" or not "bwd" or "fwd"
			flee_node_data_2.direction = flag_3
			num = 2
		end

		self:move_to_main_path_node(arg_6_2, num)
	end
end

BTLootRatFleeAction.move_to_main_path_node = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local flee_node_data = arg_7_1.flee_node_data
	local var_7_1 = flee_node_data.nodes[flee_node_data.direction][arg_7_2]

	flee_node_data.target_node_index = arg_7_2

	arg_7_1.navigation_extension:move_to(var_7_1:unbox())
end

BTLootRatFleeAction.do_astar_to_between_main_path_nodes = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local flee_node_data = arg_8_1.flee_node_data
	local var_8_1 = flee_node_data.nodes[flee_node_data.direction]
	local unbox = var_8_1[arg_8_2]:unbox()
	local unbox_2 = var_8_1[arg_8_2 + 1]:unbox()
	local flee_astar_data = arg_8_1.flee_astar_data

	flee_astar_data.doing_astar = true

	GwNavAStar.start_with_propagation_box(flee_astar_data.astar, arg_8_1.nav_world, unbox, unbox_2, num_3, flee_astar_data.traverse_logic)
end

BTLootRatFleeAction.has_escaped_players = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local escaped_players_distance_sq = arg_9_2.action.escaped_players_distance_sq
	local var_9_1 = POSITION_LOOKUP[arg_9_1]
	local ENEMY_PLAYER_AND_BOT_UNITS = arg_9_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_9_3 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local var_9_4 = POSITION_LOOKUP[var_9_3]

		if escaped_players_distance_sq > Vector3.distance_squared(var_9_1, var_9_4) then
			return false
		end
	end

	return true
end

BTLootRatFleeAction.despawn = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	Managers.state.conflict:destroy_unit(arg_10_1, arg_10_2, arg_10_3)
end

BTLootRatFleeAction.set_state = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	arg_11_1.flee_state = arg_11_2
end

BTLootRatFleeAction.toggle_start_move_animation_lock = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local locomotion_extension = arg_12_3.locomotion_extension

	if not arg_12_2 then
		locomotion_extension:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_12_1, true, false, false)
	else
		locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_12_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_12_1, 1)
	end
end

BTLootRatFleeAction.debug_draw_path_nodes = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	for i = 1, #arg_13_2 do
		local var_13_0 = arg_13_2[i]
		local unbox = var_13_0:unbox()

		if i == arg_13_4 then
			if not arg_13_3[var_13_0] then
				QuickDrawer:sphere(unbox, 0.25 + math.sin(arg_13_5) * 0.15, Colors.get("dark_blue"))
			elseif not GwNavQueries.triangle_from_position(arg_13_1, unbox, 1, 1) then
				QuickDrawer:sphere(unbox, 0.25 + math.sin(arg_13_5) * 0.15, Colors.get("pink"))
			else
				QuickDrawer:sphere(unbox, 0.25 + math.sin(arg_13_5) * 0.15, Colors.get("dark_red"))
			end
		elseif not arg_13_3[var_13_0] then
			QuickDrawer:sphere(unbox, 0.25, Colors.get("orange"))
		else
			QuickDrawer:sphere(unbox, 0.25, Colors.get("dark_green"))
		end
	end
end
