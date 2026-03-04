-- chunkname: @scripts/unit_extensions/ai_commander/ai_commander_extension.lua

require("scripts/settings/profiles/career_constants")

local var_0_0 = true
local var_0_1 = 7
local var_0_2 = 11
local var_0_3 = 4
local var_0_4 = {
	alternating = true,
	lead_dist_min = 2,
	lead_dist_max = 2,
	commander_avoid_radius = 1.2,
	dist = 4,
	formation_type = "circle",
	lead_dist_mult = math.huge,
	initial_angle_offset = math.pi * 0.5,
	angle_offset = math.pi * 0.05
}

AICommanderExtension = class(AICommanderExtension)

AICommanderExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0.ai_commander_system = arg_1_1.owning_system
	arg_1_0._controlled_units = {}
	arg_1_0._controlled_units_n = 0
	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._unit_storage = arg_1_1.unit_storage

	local var_1_0 = arg_1_3.player

	if var_1_0 then
		arg_1_0._is_local = var_1_0 and not var_1_0.remote
	end

	arg_1_0._player = var_1_0
	arg_1_0._last_reference_pos = Vector3Box()
	arg_1_0._last_reference_rot = QuaternionBox(Quaternion.identity())
	arg_1_0._last_point_match_rot = QuaternionBox(Quaternion.identity())

	if arg_1_0._is_server then
		arg_1_0._follow_indices = {}
		arg_1_0._follow_datas = {}
		arg_1_0._units_to_recalculate = {}
		arg_1_0._follow_units = {}
		arg_1_0._stored_fallback_positions = {}
		arg_1_0._fallback_position_data = {
			n = 0,
			cell_width = 2,
			grid_width = 0
		}
		arg_1_0._fallback_positions = {}
	end

	arg_1_0._combat_units = {}
	arg_1_0._stand_ground_queue = {}
	arg_1_0._stand_ground_active = false
	arg_1_0._detection_radius = var_0_1
	arg_1_0._detection_source_pos = Vector3Box()
	arg_1_0._command_buffs = {}
end

AICommanderExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._locomotion_ext = ScriptUnit.has_extension(arg_2_2, "locomotion_system")
	arg_2_0._buff_extension = ScriptUnit.has_extension(arg_2_2, "buff_system")
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	arg_2_0._buff_system = Managers.state.entity:system("buff_system")
end

AICommanderExtension.destroy = function (arg_3_0)
	return
end

AICommanderExtension._claim_follow_index = function (arg_4_0, arg_4_1)
	local var_4_0 = #arg_4_0._follow_indices + 1

	arg_4_0._follow_indices[var_4_0] = arg_4_1
	arg_4_0._follow_datas[arg_4_1] = {
		undergoing_avoidance = false,
		follow_index = var_4_0,
		last_follow_position = Vector3Box(),
		lerped_follow_position = Vector3Box(POSITION_LOOKUP[arg_4_1]),
		target_follow_position = Vector3Box(),
		true_follow_position = Vector3Box(),
		unit = arg_4_1
	}
end

AICommanderExtension._free_follow_index = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._follow_datas[arg_5_1].follow_index

	arg_5_0._follow_datas[arg_5_1] = nil

	local var_5_1 = arg_5_0._follow_indices

	table.swap_delete(var_5_1, var_5_0)

	local var_5_2 = var_5_1[var_5_0]

	if var_5_2 then
		arg_5_0._follow_datas[var_5_2].follow_index = var_5_0
	end
end

AICommanderExtension.register_follow_node_update = function (arg_6_0, arg_6_1)
	arg_6_0._follow_units[arg_6_1] = true
	arg_6_0._force_follow_update = true

	arg_6_0._follow_datas[arg_6_1].lerped_follow_position:store(POSITION_LOOKUP[arg_6_1])
end

AICommanderExtension.unregister_follow_node_update = function (arg_7_0, arg_7_1)
	arg_7_0._follow_units[arg_7_1] = nil
	arg_7_0._units_to_recalculate[arg_7_1] = nil
end

AICommanderExtension.follow_node_pending = function (arg_8_0, arg_8_1)
	return arg_8_1.waiting_for_follow_node
end

AICommanderExtension.follow_node_position = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._follow_datas[arg_9_1]

	return var_9_0 and var_9_0.lerped_follow_position
end

AICommanderExtension.update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	if arg_10_0._is_server then
		arg_10_0:_update_units(arg_10_3, arg_10_5)
		arg_10_0:_update_follow(arg_10_3, arg_10_5)
	end

	arg_10_0:_update_commands()

	arg_10_0._cached_hovered_friendly_unit = false
	arg_10_0._cached_hovered_fallback_unit = false
	arg_10_0._cached_hovered_commanded_unit = false
end

AICommanderExtension._on_controlled_unit_destroyed = function (arg_11_0, arg_11_1)
	arg_11_0:remove_controlled_unit(arg_11_1)
end

AICommanderExtension.set_controlled_unit_template = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	if arg_12_3 then
		arg_12_0._controlled_units[arg_12_1] = {
			start_t = arg_12_4 or Managers.time:time("game"),
			command_state = CommandStates.Following
		}
	end

	local var_12_0 = ControlledUnitTemplates[arg_12_2]

	if not arg_12_0._is_server then
		local var_12_1 = var_12_0.client_version

		if var_12_1 then
			var_12_0 = ControlledUnitTemplates[var_12_1]
		end
	end

	arg_12_0._controlled_units[arg_12_1].template = var_12_0
end

AICommanderExtension.controlled_unit_template = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._controlled_units[arg_13_1]

	return var_13_0 and var_13_0.template
end

AICommanderExtension.add_controlled_unit = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if not ALIVE[arg_14_1] then
		return
	end

	arg_14_0:set_controlled_unit_template(arg_14_1, arg_14_2, true, arg_14_3)

	local var_14_0 = arg_14_0._unit

	arg_14_0._controlled_units_n = arg_14_0._controlled_units_n + 1

	arg_14_0.ai_commander_system:register_commander_unit(var_14_0, arg_14_1)

	if arg_14_0._is_server then
		arg_14_0:_claim_follow_index(arg_14_1)

		arg_14_0._command_buffs[arg_14_1] = {}

		local var_14_1 = BLACKBOARDS[arg_14_1]

		if not var_14_1.ability_spawned then
			var_14_1.detection_radius = var_0_1
		end

		var_14_1.detection_source_pos = Vector3Box()
		var_14_1.max_combat_range = var_0_1
		var_14_1.max_combat_range_sq = var_14_1.max_combat_range * var_14_1.max_combat_range
		var_14_1.max_combat_range_sticky = var_0_2
		var_14_1.max_combat_range_sticky_sq = var_14_1.max_combat_range_sticky * var_14_1.max_combat_range_sticky
		var_14_1.dist_to_commander = 0
		var_14_1.commander_unit = var_14_0
		var_14_1.commander_extension = arg_14_0
		var_14_1.command_state = CommandStates.Following

		Managers.state.event:register_referenced(arg_14_1, arg_14_0, "on_ai_unit_destroyed", "_on_controlled_unit_destroyed")
	end

	if arg_14_0._is_local then
		arg_14_0:_set_command_state(arg_14_1, CommandStates.Following)
		Managers.state.achievement:trigger_event("on_controlled_unit_added", arg_14_1, arg_14_0._unit, arg_14_0)
	end

	local var_14_2 = arg_14_0._buff_extension

	if var_14_2 then
		var_14_2:trigger_procs("on_controlled_unit_added", arg_14_1)
	end

	Managers.state.event:trigger_referenced(var_14_0, "on_controlled_unit_added", arg_14_1)

	if not arg_14_4 then
		local var_14_3 = arg_14_0._unit_storage:go_id(var_14_0)
		local var_14_4 = arg_14_0._unit_storage:go_id(arg_14_1)
		local var_14_5 = NetworkLookup.controlled_unit_templates[arg_14_2]

		if arg_14_0._is_server then
			local var_14_6 = Managers.player:owner(var_14_0)

			if var_14_6 and var_14_6.remote then
				arg_14_0._network_transmit:send_rpc("rpc_add_controlled_unit", var_14_6.peer_id, var_14_3, var_14_4, var_14_5)
			end
		else
			arg_14_0._network_transmit:send_rpc_server("rpc_add_controlled_unit", var_14_3, var_14_4, var_14_5)
		end
	end
end

AICommanderExtension.remove_controlled_unit = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._controlled_units

	if not var_15_0[arg_15_1] then
		return
	end

	arg_15_0._combat_units[arg_15_1] = nil
	var_15_0[arg_15_1] = nil
	arg_15_0._controlled_units_n = arg_15_0._controlled_units_n - 1

	if arg_15_0._is_local and Managers.player:local_player() then
		Managers.state.achievement:trigger_event("on_controlled_unit_removed", arg_15_1, arg_15_0._unit, arg_15_0)
	end

	local var_15_1 = arg_15_0._buff_extension

	if var_15_1 then
		var_15_1:trigger_procs("on_controlled_unit_removed", arg_15_1)

		if not HEALTH_ALIVE[arg_15_1] then
			var_15_1:trigger_procs("on_controlled_unit_death", arg_15_1)
		end
	end

	arg_15_0.ai_commander_system:clear_commander_unit(arg_15_1)

	if arg_15_0._is_server then
		arg_15_0:_free_follow_index(arg_15_1)
		arg_15_0:unregister_follow_node_update(arg_15_1)
		arg_15_0:_store_fallback_position(arg_15_1)

		local var_15_2 = BLACKBOARDS[arg_15_1]

		if var_15_2 then
			var_15_2.max_combat_range = nil
			var_15_2.max_combat_range_sq = nil
			var_15_2.max_combat_range_sticky = nil
			var_15_2.dist_to_commander = nil
			var_15_2.commander_unit = nil
			var_15_2.commander_extension = nil
			var_15_2.waiting_for_follow_node = nil
		end

		arg_15_0:_cleanup_command_buffs(arg_15_1, false)

		arg_15_0._command_buffs[arg_15_1] = nil

		Managers.state.event:unregister_referenced("on_ai_unit_destroyed", arg_15_1, arg_15_0)
	end

	if not arg_15_2 then
		local var_15_3 = arg_15_0._unit
		local var_15_4 = arg_15_0._unit_storage:go_id(var_15_3)
		local var_15_5 = arg_15_0._unit_storage:go_id(arg_15_1)

		if var_15_4 and var_15_5 then
			if arg_15_0._is_server then
				local var_15_6 = Managers.player:owner(var_15_3)

				if var_15_6 and var_15_6.remote then
					arg_15_0._network_transmit:send_rpc("rpc_remove_controlled_unit", var_15_6.peer_id, var_15_4, var_15_5)
				end
			else
				arg_15_0._network_transmit:send_rpc_server("rpc_remove_controlled_unit", var_15_4, var_15_5)
			end
		end
	end
end

AICommanderExtension.get_controlled_units = function (arg_16_0)
	return arg_16_0._controlled_units
end

AICommanderExtension.get_controlled_units_count = function (arg_17_0)
	return arg_17_0._controlled_units_n
end

local var_0_5 = 0.5
local var_0_6 = var_0_5 * var_0_5

AICommanderExtension._update_follow = function (arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0:_commander_is_on_navmesh() then
		return
	end

	local var_18_0 = arg_18_0._unit
	local var_18_1 = POSITION_LOOKUP[var_18_0]
	local var_18_2

	if arg_18_0._first_person_extension then
		var_18_2 = arg_18_0._first_person_extension:current_rotation()
		var_18_2 = Quaternion.flat_no_roll(var_18_2)
	else
		local var_18_3 = arg_18_0._unit_storage:go_id(var_18_0)
		local var_18_4 = Managers.state.network:game()
		local var_18_5 = GameSession.game_object_field(var_18_4, var_18_3, "aim_direction")

		var_18_2 = Quaternion.flat_no_roll(Quaternion.look(var_18_5))
	end

	local var_18_6 = arg_18_0._force_follow_update
	local var_18_7 = false
	local var_18_8 = not table.is_empty(arg_18_0._units_to_recalculate)

	arg_18_0._force_follow_update = nil

	if not var_18_6 then
		local var_18_9 = arg_18_0._last_reference_pos:unbox()
		local var_18_10 = Vector3.distance_squared(var_18_1, var_18_9)

		if var_18_10 > var_0_6 then
			var_18_6 = var_18_10 > var_0_6
		end

		var_18_7 = not var_18_6 and var_18_10 > 0.001

		if var_18_7 then
			local var_18_11 = arg_18_0._locomotion_ext:current_velocity()

			var_18_7 = Vector3.length_squared(var_18_11) < NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON
		end
	end

	if var_18_6 or var_18_8 or var_18_7 then
		if var_18_6 or var_18_7 then
			arg_18_0._last_reference_rot:store(var_18_2)
			arg_18_0._last_reference_pos:store(var_18_1)

			for iter_18_0 in pairs(arg_18_0._follow_units) do
				arg_18_0._units_to_recalculate[iter_18_0] = true
			end
		end

		arg_18_0:_update_follow_nodes(arg_18_1, arg_18_2)

		local var_18_12 = arg_18_0._last_point_match_rot

		if Quaternion.angle(var_18_2, var_18_12:unbox()) > math.pi * 0.25 or var_18_7 then
			var_18_12:store(var_18_2)
			arg_18_0:_pair_best_follow_nodes()
		end
	end

	arg_18_0:_lerp_follow_positions(arg_18_1)
end

AICommanderExtension._update_follow_nodes = function (arg_19_0, arg_19_1, arg_19_2)
	if script_data.bots_dont_follow then
		return
	end

	local var_19_0 = arg_19_0._unit
	local var_19_1 = arg_19_0._nav_world
	local var_19_2 = POSITION_LOOKUP[var_19_0]
	local var_19_3 = arg_19_0._locomotion_ext:current_velocity()
	local var_19_4
	local var_19_5

	if Vector3.length_squared(var_19_3) < NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON then
		var_19_4 = 0
		var_19_5 = Quaternion.forward(Quaternion.flat_no_roll(arg_19_0._last_reference_rot:unbox()))
	else
		var_19_4 = Vector3.length(var_19_3)
		var_19_5 = var_19_3 / var_19_4
	end

	local var_19_6 = 30
	local var_19_7 = 30
	local var_19_8 = 5

	for iter_19_0 in pairs(arg_19_0._units_to_recalculate) do
		repeat
			arg_19_0._units_to_recalculate[iter_19_0] = nil

			local var_19_9 = arg_19_0._follow_datas[iter_19_0]

			var_19_9.undergoing_avoidance = false

			if not POSITION_LOOKUP[iter_19_0] then
				break
			end

			local var_19_10 = BLACKBOARDS[iter_19_0]
			local var_19_11 = var_19_10.breed.commander_formation
			local var_19_12 = var_19_9.follow_index > var_0_3
			local var_19_13

			if var_19_12 then
				local var_19_14 = arg_19_0._fallback_position_data.grid_width

				var_19_13 = Vector3(0, -3 - var_19_14 * 0.5, 0) + arg_19_0:_get_fallback_position(iter_19_0).pos:unbox()
				var_19_13 = Quaternion.rotate(Quaternion.look(Vector3.flat(var_19_5)), var_19_13)
			else
				local var_19_15 = var_19_11.angle_offset
				local var_19_16 = var_19_11.initial_angle_offset or var_19_15
				local var_19_17 = var_19_11.alternating
				local var_19_18 = var_19_9.follow_index
				local var_19_19 = var_19_18 - 1

				var_19_19 = var_19_17 and math.floor(var_19_19 * 0.5) or var_19_19

				local var_19_20 = var_19_16 + var_19_19 * var_19_15

				if var_19_17 and var_19_18 % 2 > 0 then
					var_19_20 = var_19_20 * -1
				end

				local var_19_21 = Quaternion.axis_angle(Vector3.up(), var_19_20)

				var_19_13 = Quaternion.rotate(var_19_21, Vector3.forward() * var_19_11.dist)
				var_19_13 = Quaternion.rotate(Quaternion.look(Vector3.flat(var_19_5)), var_19_13)
				var_19_13 = var_19_13 + (var_19_11.offset and Vector3(var_19_11.offset[1], var_19_11.offset[2], 0) or Vector3.zero())
			end

			local var_19_22 = var_19_5 * (var_19_4 == 0 and 0 or math.clamp(var_19_4 * var_19_11.lead_dist_mult, var_19_11.lead_dist_min, var_19_11.lead_dist_max))
			local var_19_23 = var_19_2 + var_19_13 + var_19_22
			local var_19_24 = arg_19_0:_navify_follow_pos(var_19_23, var_19_1, var_19_2, var_19_22, var_19_10)

			var_19_9.true_follow_position:store(var_19_24)

			local var_19_25 = var_19_24
			local var_19_26 = var_19_4 > 0 and var_19_11.commander_avoid_radius or 0
			local var_19_27 = arg_19_0:_avoid_unit(var_19_0, iter_19_0, var_19_25, var_19_26, var_19_10, var_19_1, var_19_6, var_19_7, arg_19_1, arg_19_2)

			for iter_19_1 in pairs(arg_19_0._follow_datas) do
				if iter_19_1 ~= iter_19_0 then
					local var_19_28 = BLACKBOARDS[iter_19_1]

					if var_19_28 and var_19_28.command_state == CommandStates.Following then
						local var_19_29 = var_19_4 > 0 and (arg_19_0:_unit_arrived_at_follow_node(iter_19_1) and 0.25 or 1) or 0

						var_19_27 = arg_19_0:_avoid_unit(iter_19_1, iter_19_0, var_19_27, var_19_29, var_19_10, var_19_1, var_19_6, var_19_7, arg_19_1, arg_19_2)
					end
				end
			end

			if var_19_27 ~= var_19_24 then
				var_19_27 = arg_19_0:_navify_follow_pos(var_19_27, var_19_1, var_19_2, var_19_22, var_19_10)
			end

			local var_19_30 = var_19_9.lerped_follow_position

			if Vector3.distance_squared(var_19_30:unbox(), var_19_27) > 0.09 then
				local var_19_31, var_19_32 = GwNavQueries.triangle_from_position(var_19_1, var_19_27, var_19_6, var_19_7)

				if var_19_31 then
					var_19_27.z = var_19_32
				else
					var_19_27 = GwNavQueries.inside_position_from_outside_position(var_19_1, var_19_27, var_19_6, var_19_7, var_19_8, 0.5)
				end

				if var_19_27 then
					var_19_9.target_follow_position:store(var_19_27)
				end
			end
		until true
	end
end

AICommanderExtension._lerp_follow_positions = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._nav_world

	for iter_20_0 in pairs(arg_20_0._follow_units) do
		local var_20_1 = BLACKBOARDS[iter_20_0]
		local var_20_2 = arg_20_0._follow_datas[iter_20_0]
		local var_20_3 = var_20_2.lerped_follow_position
		local var_20_4 = var_20_3:unbox()
		local var_20_5 = var_20_2.target_follow_position:unbox()

		if Vector3.distance_squared(var_20_4, var_20_5) > math.epsilon then
			local var_20_6 = var_20_1.navigation_extension:get_max_speed() * 2
			local var_20_7, var_20_8 = Vector3.direction_length(var_20_5 - var_20_4)
			local var_20_9 = var_20_4 + var_20_7 * math.max(var_20_6, var_20_8) * arg_20_1
			local var_20_10 = Geometry.closest_point_on_line(var_20_9, var_20_4, var_20_5)
			local var_20_11 = var_20_1.navigation_extension:traverse_logic()

			if var_20_11 then
				local var_20_12, var_20_13 = GwNavQueries.raycast(var_20_0, var_20_5, var_20_10, var_20_11)

				var_20_3:store(var_20_13)

				local var_20_14 = var_20_2.last_follow_position

				if Vector3.distance_squared(var_20_14:unbox(), var_20_13) > 0.09 then
					var_20_14:store(var_20_13)

					var_20_1.goal_destination = Vector3Box(var_20_13)
					var_20_1.new_move_to_goal = true
					arg_20_0._units_to_recalculate[iter_20_0] = true
				end
			end
		end

		var_20_1.waiting_for_follow_node = nil
	end
end

AICommanderExtension._unit_arrived_at_follow_node = function (arg_21_0, arg_21_1)
	local var_21_0 = POSITION_LOOKUP[arg_21_1]
	local var_21_1 = arg_21_0._follow_datas[arg_21_1]

	return Vector3.distance_squared(var_21_0, var_21_1.target_follow_position:unbox()) < 0.25
end

AICommanderExtension._avoid_unit = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10)
	local var_22_0 = POSITION_LOOKUP[arg_22_1]
	local var_22_1 = POSITION_LOOKUP[arg_22_2]

	if not var_22_0 then
		return arg_22_3
	end

	if math.abs(var_22_0.z - var_22_1.z) > 1 then
		return arg_22_3
	end

	local var_22_2 = arg_22_0._follow_datas[arg_22_1]

	if var_22_2 and var_22_2.undergoing_avoidance == arg_22_2 then
		return arg_22_3
	end

	local var_22_3 = Vector3.flat(arg_22_3 - var_22_0)
	local var_22_4 = Vector3.flat(var_22_1 - var_22_0)

	if Vector3.length_squared(var_22_3) < arg_22_4 * arg_22_4 then
		return arg_22_3
	end

	if Vector3.dot(var_22_3, var_22_4) < 0 then
		local var_22_5 = arg_22_5.flip_attempt_t
		local var_22_6 = var_22_5 and arg_22_10 - var_22_5 < 2
		local var_22_7 = var_22_6 and arg_22_5.flip_dir or Vector3.cross(var_22_4, var_22_3).z < 0 and -1 or 1
		local var_22_8 = math.max(Vector3.length(var_22_4), math.epsilon)
		local var_22_9 = var_22_8 < arg_22_4
		local var_22_10 = arg_22_0._follow_datas[arg_22_2]
		local var_22_11 = var_22_10.undergoing_avoidance

		if var_22_9 then
			var_22_10.undergoing_avoidance = arg_22_1
			arg_22_0._units_to_recalculate[arg_22_2] = true

			if var_22_11 then
				return Vector3.copy(var_22_1)
			end

			local var_22_12 = Vector3.cross(Vector3.normalize(var_22_4), -Vector3.up()) * var_22_7

			arg_22_3 = var_22_1 + Quaternion.rotate(Quaternion.axis_angle(Vector3(0, 0, var_22_7), -math.pi * arg_22_9), var_22_12) * 2
		else
			local var_22_13 = Vector3.normalize(Vector3.flat(arg_22_3 - var_22_1))
			local var_22_14 = var_22_1 + var_22_13 * Vector3.dot(-var_22_4, var_22_13)

			if Vector3.length_squared(Vector3.flat(var_22_0) - Vector3.flat(var_22_14)) < arg_22_4 * arg_22_4 - math.epsilon then
				var_22_10.undergoing_avoidance = arg_22_1
				arg_22_0._units_to_recalculate[arg_22_2] = true

				if var_22_11 then
					local var_22_15 = Vector3.flat(var_22_1)
					local var_22_16, var_22_17 = Intersect.ray_circle(var_22_15, var_22_13, Vector3.flat(var_22_0), arg_22_4)
					local var_22_18 = Vector3.distance_squared(var_22_16, var_22_15) < Vector3.distance_squared(var_22_17, var_22_15) and var_22_16 or var_22_17

					if not var_22_6 then
						arg_22_5.flip_attempt_t = arg_22_10
						arg_22_5.flip_dir = -var_22_7
					end

					var_22_18.z = arg_22_3.z

					return var_22_18
				end

				local var_22_19 = math.clamp01(arg_22_4 / var_22_8)
				local var_22_20 = var_22_0 + Quaternion.rotate(Quaternion.axis_angle(Vector3(0, 0, var_22_7), math.acos(var_22_19)), Vector3.normalize(var_22_4) * arg_22_4)
				local var_22_21, var_22_22 = GwNavQueries.triangle_from_position(arg_22_6, var_22_20, arg_22_7, arg_22_8)

				if var_22_21 then
					var_22_20.z = var_22_22
				elseif not var_22_6 then
					arg_22_5.flip_attempt_t = arg_22_10
					arg_22_5.flip_dir = -var_22_7
				else
					return var_22_14
				end

				local var_22_23 = Vector3.length(arg_22_3 - var_22_1)

				arg_22_3 = var_22_1 + Vector3.normalize(var_22_20 - var_22_1) * var_22_23
			end
		end
	end

	return arg_22_3
end

AICommanderExtension._pair_best_follow_nodes = function (arg_23_0)
	local var_23_0 = arg_23_0._follow_indices
	local var_23_1 = arg_23_0._follow_datas
	local var_23_2 = FrameTable.alloc_table()
	local var_23_3 = FrameTable.alloc_table()
	local var_23_4 = #var_23_0

	for iter_23_0 = 1, var_23_4 do
		local var_23_5 = var_23_0[iter_23_0]
		local var_23_6 = POSITION_LOOKUP[var_23_5]

		var_23_3[iter_23_0], var_23_2[iter_23_0] = var_23_1[var_23_5].true_follow_position:unbox(), var_23_6
	end

	local var_23_7 = FrameTable.alloc_table()

	math.distributed_point_matching(var_23_2, var_23_3, var_23_7, true)

	for iter_23_1 = 1, var_23_4 do
		local var_23_8 = var_23_7[iter_23_1]
		local var_23_9 = var_23_0[iter_23_1]

		if var_23_1[var_23_9].follow_index ~= var_23_8 then
			var_23_1[var_23_9].follow_index = var_23_8
			arg_23_0._units_to_recalculate[var_23_9] = true
		end
	end

	for iter_23_2, iter_23_3 in pairs(var_23_1) do
		var_23_0[iter_23_3.follow_index] = iter_23_2
	end
end

AICommanderExtension._navify_follow_pos = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	local var_24_0 = arg_24_5.navigation_extension:traverse_logic()

	if var_24_0 then
		local var_24_1, var_24_2 = GwNavQueries.raycast(arg_24_2, arg_24_3, arg_24_3 + arg_24_4, var_24_0)

		if not var_24_1 then
			var_24_2 = var_24_2 + Vector3.normalize(arg_24_3 - var_24_2) * 1.5
		end

		local var_24_3, var_24_4 = GwNavQueries.raycast(arg_24_2, var_24_2, arg_24_1, var_24_0)

		if not var_24_3 then
			arg_24_1 = var_24_4
		end
	end

	return arg_24_1
end

AICommanderExtension._update_units = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = POSITION_LOOKUP[arg_25_0._unit]
	local var_25_1 = arg_25_0._controlled_units
	local var_25_2 = table.is_empty(arg_25_0._combat_units) and var_0_1 or var_0_2
	local var_25_3 = var_25_2 * 0.5
	local var_25_4 = arg_25_0._locomotion_ext:average_velocity()

	if Vector3.length_squared(var_25_4) > var_25_3 * var_25_3 then
		var_25_4 = Vector3.normalize(var_25_4) * var_25_3
	end

	local var_25_5 = var_25_0 + var_25_4

	for iter_25_0 in pairs(var_25_1) do
		local var_25_6 = BLACKBOARDS[iter_25_0]
		local var_25_7 = POSITION_LOOKUP[iter_25_0]

		if not var_25_7 then
			arg_25_0:remove_controlled_unit(iter_25_0)

			return
		end

		if ScriptUnit.extension(iter_25_0, "health_system"):is_dead() then
			arg_25_0:remove_controlled_unit(iter_25_0)

			return
		end

		local var_25_8 = arg_25_0._controlled_units[iter_25_0]
		local var_25_9 = var_25_8.template

		if var_25_9.duration and arg_25_2 > var_25_8.start_t + var_25_9.duration then
			arg_25_0:remove_controlled_unit(iter_25_0)

			if var_25_9.disband_type == ControlledUnitDisbandType.kill then
				AiUtils.kill_unit(iter_25_0)
			end

			return
		end

		if not var_25_6.ability_spawned then
			var_25_6.detection_radius = var_25_2
		end

		var_25_6.dist_to_commander = Vector3.distance(var_25_0, var_25_7)

		if var_25_6.command_state == CommandStates.StandingGround then
			var_25_6.detection_source_pos:store(var_25_6.stand_ground_position:unbox())
		else
			var_25_6.detection_source_pos:store(var_25_5)
		end

		AiBreedSnippets.update_enemy_sighting_within_commander_sticky(var_25_6)
	end
end

AICommanderExtension.pet_ui_data = function (arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._controlled_units[arg_26_1]

	if not var_26_0 then
		return nil, nil, nil
	end

	local var_26_1 = var_26_0.template
	local var_26_2 = var_26_1.pet_ui_type

	if var_26_2 == "health" then
		local var_26_3 = ScriptUnit.has_extension(arg_26_1, "health_system")

		if var_26_3 then
			local var_26_4 = var_26_3:current_health()
			local var_26_5 = var_26_3:get_max_health()

			return var_26_1, var_26_4, var_26_5
		end
	elseif var_26_2 == "duration" then
		local var_26_6 = var_26_0.template.duration

		if var_26_6 then
			local var_26_7 = Managers.time:time("game")
			local var_26_8 = var_26_0.start_t

			return var_26_1, var_26_7 - var_26_8, var_26_6
		end
	end

	return nil, nil, nil
end

AICommanderExtension.controlled_units_in_combat = function (arg_27_0)
	return arg_27_0._combat_units
end

AICommanderExtension.set_in_combat = function (arg_28_0, arg_28_1, arg_28_2)
	arg_28_0._combat_units[arg_28_1] = arg_28_2 or nil
end

AICommanderExtension._calculate_hovered_friendly_unit = function (arg_29_0)
	local var_29_0 = 1
	local var_29_1 = arg_29_0._first_person_extension
	local var_29_2 = var_29_1:current_position()
	local var_29_3 = Quaternion.forward(var_29_1:current_rotation())
	local var_29_4 = arg_29_0:get_controlled_units()
	local var_29_5
	local var_29_6
	local var_29_7
	local var_29_8 = math.huge

	for iter_29_0 in pairs(var_29_4) do
		repeat
			if not ALIVE[iter_29_0] then
				break
			end

			local var_29_9 = Unit.has_node(iter_29_0, "j_spine") and Unit.world_position(iter_29_0, Unit.node(iter_29_0, "j_spine")) or POSITION_LOOKUP[iter_29_0]

			if var_29_9 then
				local var_29_10, var_29_11 = Vector3.direction_length(var_29_9 - var_29_2)
				local var_29_12 = math.atan(var_29_0 / var_29_11)
				local var_29_13 = Vector3.dot(var_29_3, var_29_10)
				local var_29_14 = math.acos(var_29_13)

				if var_29_14 < var_29_8 then
					var_29_6 = iter_29_0
					var_29_8 = var_29_14

					if var_29_14 <= var_29_12 then
						var_29_5 = iter_29_0

						if arg_29_0:command_state(iter_29_0) ~= CommandStates.Following then
							var_29_7 = iter_29_0
						end
					end
				end
			end
		until true
	end

	arg_29_0._cached_hovered_fallback_unit = var_29_6
	arg_29_0._cached_hovered_friendly_unit = var_29_5
	arg_29_0._cached_hovered_commanded_unit = var_29_7
end

AICommanderExtension._set_command_state = function (arg_30_0, arg_30_1, arg_30_2)
	fassert(arg_30_0._is_local, "[AICommanderExtension] Local only function")

	local var_30_0 = arg_30_0._controlled_units[arg_30_1]

	if var_30_0 then
		var_30_0.command_state = arg_30_2
	end
end

AICommanderExtension.command_state = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._controlled_units[arg_31_1]

	return var_31_0 and var_31_0.command_state
end

AICommanderExtension.cancel_current_command = function (arg_32_0, arg_32_1, arg_32_2)
	if arg_32_2 and arg_32_0:command_state(arg_32_1) == CommandStates.Attacking then
		return
	end

	if arg_32_0._is_local then
		arg_32_0:_set_command_state(arg_32_1, CommandStates.Following)
	end

	if not arg_32_0._is_server then
		local var_32_0 = arg_32_0._unit_storage:go_id(arg_32_1)

		arg_32_0._network_transmit:send_rpc_server("rpc_cancel_current_command", var_32_0)

		return
	end

	arg_32_0:_cleanup_command_buffs(arg_32_1, true)

	local var_32_1 = BLACKBOARDS[arg_32_1]

	var_32_1.command_state = CommandStates.Following
	var_32_1.override_target_selection_name = nil
	var_32_1.override_detection_radius = nil
	var_32_1.fallback_rotation = nil
	var_32_1.commander_target = nil
	var_32_1.new_command_attack = nil
	var_32_1.charge_target = nil
	var_32_1.target_unit = nil
end

AICommanderExtension.command_attack = function (arg_33_0, arg_33_1, arg_33_2)
	if arg_33_0._is_server then
		arg_33_0:cancel_current_command(arg_33_1)

		local var_33_0 = BLACKBOARDS[arg_33_1]

		var_33_0.target_unit = arg_33_2
		var_33_0.commander_target = arg_33_2
		var_33_0.override_target_selection_name = "attack_commander_target_with_fallback"
		var_33_0.command_state = CommandStates.Attacking
		var_33_0.new_command_attack = true

		arg_33_0:_add_command_buffs(arg_33_1, CommandStates.Attacking)
	else
		local var_33_1 = arg_33_0._unit_storage:go_id(arg_33_1)
		local var_33_2 = arg_33_0._unit_storage:go_id(arg_33_2)

		arg_33_0._network_transmit:send_rpc_server("rpc_command_attack", var_33_1, var_33_2)
	end

	if arg_33_0._is_local then
		Managers.state.achievement:trigger_event("command_attack_unit", arg_33_1, arg_33_2)
		arg_33_0:_set_command_state(arg_33_1, CommandStates.Attacking)

		arg_33_0._controlled_units[arg_33_1].commander_target = arg_33_2

		local var_33_3 = ScriptUnit.extension_input(arg_33_0._unit, "dialogue_system")
		local var_33_4 = FrameTable.alloc_table()

		var_33_3:trigger_dialogue_event("minion_command_attack", var_33_4)
	end
end

AICommanderExtension.command_stand_ground = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	if arg_34_0._is_server then
		arg_34_0:cancel_current_command(arg_34_1)

		local var_34_0 = BLACKBOARDS[arg_34_1]

		var_34_0.target_unit = nil
		var_34_0.command_state = CommandStates.StandingGround
		var_34_0.override_detection_radius = 3
		var_34_0.stand_ground_position = Vector3Box(arg_34_2)
		var_34_0.goal_destination = Vector3Box(arg_34_2)
		var_34_0.new_move_to_goal = true
		var_34_0.fallback_rotation = QuaternionBox(arg_34_3)

		arg_34_0:_add_command_buffs(arg_34_1, CommandStates.StandingGround)
	else
		local var_34_1 = arg_34_0._unit_storage:go_id(arg_34_1)

		arg_34_0._network_transmit:send_rpc_server("rpc_command_stand_ground", var_34_1, arg_34_2, arg_34_3)
	end

	if arg_34_0._is_local then
		arg_34_0:_set_command_state(arg_34_1, CommandStates.StandingGround)

		arg_34_0._stand_ground_active = true

		local var_34_2 = ScriptUnit.extension_input(arg_34_0._unit, "dialogue_system")
		local var_34_3 = FrameTable.alloc_table()

		var_34_2:trigger_dialogue_event("minion_command_defend", var_34_3)
	end
end

AICommanderExtension.hovered_friendly_unit = function (arg_35_0)
	if not arg_35_0._cached_hovered_fallback_unit then
		arg_35_0:_calculate_hovered_friendly_unit()
	end

	return arg_35_0._cached_hovered_friendly_unit, arg_35_0._cached_hovered_fallback_unit
end

AICommanderExtension.hovered_commanded_unit = function (arg_36_0)
	if not arg_36_0._cached_hovered_commanded_unit then
		arg_36_0:_calculate_hovered_friendly_unit()
	end

	return arg_36_0._cached_hovered_commanded_unit
end

AICommanderExtension._update_command_stand_ground = function (arg_37_0)
	if arg_37_0._stand_ground_active then
		local var_37_0 = false

		for iter_37_0 in pairs(arg_37_0._controlled_units) do
			local var_37_1 = POSITION_LOOKUP[iter_37_0]
			local var_37_2 = POSITION_LOOKUP[arg_37_0._unit]
			local var_37_3 = Vector3.distance_squared(var_37_1, var_37_2)
			local var_37_4 = CareerConstants.bw_necromancer.max_range

			if var_37_3 > var_37_4 * var_37_4 then
				var_37_0 = true

				break
			end
		end

		if var_37_0 then
			for iter_37_1 in pairs(arg_37_0._controlled_units) do
				if arg_37_0:command_state(iter_37_1) == CommandStates.StandingGround then
					arg_37_0:cancel_current_command(iter_37_1)
				end
			end

			arg_37_0._stand_ground_active = false
		end
	end

	local var_37_5 = arg_37_0._stand_ground_queue

	for iter_37_2 = 1, #var_37_5 do
		local var_37_6 = var_37_5[iter_37_2]

		arg_37_0:_command_stand_ground_group(var_37_6.units, var_37_6.target_position:unbox(), var_37_6.fallback_rotation:unbox())

		var_37_5[iter_37_2] = nil
	end
end

AICommanderExtension._update_commands = function (arg_38_0)
	if arg_38_0._is_local then
		local var_38_0 = false

		for iter_38_0, iter_38_1 in pairs(arg_38_0._controlled_units) do
			if arg_38_0:command_state(iter_38_0) == CommandStates.Attacking and not HEALTH_ALIVE[iter_38_1.commander_target] then
				arg_38_0:cancel_current_command(iter_38_0)
			else
				var_38_0 = var_38_0 or iter_38_1.command_state == CommandStates.StandingGround
			end
		end
	end

	arg_38_0:_update_command_stand_ground()
end

AICommanderExtension.command_stand_ground_group = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = arg_39_0._stand_ground_queue

	var_39_0[#var_39_0 + 1] = {
		units = arg_39_1,
		target_position = Vector3Box(arg_39_2),
		fallback_rotation = QuaternionBox(arg_39_3)
	}
end

AICommanderExtension._command_stand_ground_group = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	table.array_remove_if(arg_40_1, function (arg_41_0)
		return not arg_40_0._controlled_units[arg_41_0]
	end)

	local var_40_0 = #arg_40_1

	if var_40_0 <= 0 then
		return
	end

	local var_40_1 = ActionCareerBwNecromancerCommandStandTargetingUtility.generate_positions(arg_40_2, arg_40_3, var_40_0)
	local var_40_2 = math.min(var_40_0, #var_40_1)
	local var_40_3 = FrameTable.alloc_table()
	local var_40_4 = FrameTable.alloc_table()

	for iter_40_0 = 1, var_40_2 do
		var_40_3[iter_40_0] = POSITION_LOOKUP[arg_40_1[iter_40_0]]
		var_40_4[iter_40_0] = var_40_1[iter_40_0]:unbox()
	end

	local var_40_5 = FrameTable.alloc_table()
	local var_40_6 = math.distributed_point_matching(var_40_3, var_40_4, var_40_5)

	if not var_40_6 then
		return
	end

	for iter_40_1 = 1, var_40_6 do
		local var_40_7 = arg_40_1[iter_40_1]
		local var_40_8 = var_40_4[var_40_5[iter_40_1]]

		arg_40_0:command_stand_ground(var_40_7, var_40_8, arg_40_3)
	end
end

AICommanderExtension._commander_is_on_navmesh = function (arg_42_0)
	local var_42_0 = POSITION_LOOKUP[arg_42_0._unit]

	if not var_42_0 then
		arg_42_0._is_on_navmesh = false

		return
	end

	local var_42_1 = 0.5
	local var_42_2 = 2

	return (GwNavQueries.triangle_from_position(arg_42_0._nav_world, var_42_0, var_42_1, var_42_2))
end

AICommanderExtension._cleanup_command_buffs = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0._buff_system
	local var_43_1 = arg_43_0._command_buffs[arg_43_1]

	for iter_43_0 = #var_43_1, 1, -1 do
		local var_43_2 = var_43_1[iter_43_0]
		local var_43_3 = var_43_2.remove_on_command

		if not arg_43_2 or var_43_3 then
			local var_43_4 = var_43_2.id

			var_43_0:remove_buff_synced(arg_43_1, var_43_4)
			table.swap_delete(var_43_1, iter_43_0)
		end
	end
end

AICommanderExtension._add_command_buffs = function (arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0._controlled_units[arg_44_1].template.buff_on_command
	local var_44_1 = var_44_0 and var_44_0[arg_44_2]

	if not var_44_1 then
		return
	end

	local var_44_2 = arg_44_0._command_buffs[arg_44_1]
	local var_44_3 = arg_44_0._buff_system

	for iter_44_0 = 1, #var_44_1 do
		local var_44_4 = var_44_1[iter_44_0]
		local var_44_5 = var_44_3:add_buff_synced(arg_44_1, var_44_4.name, BuffSyncType.Local)

		var_44_2[#var_44_2 + 1] = {
			id = var_44_5,
			remove_on_command = var_44_4.remove_on_command
		}
	end
end

AICommanderExtension._get_fallback_position = function (arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0._fallback_positions
	local var_45_1 = arg_45_0._stored_fallback_positions
	local var_45_2 = arg_45_0._fallback_position_data

	if var_45_0[arg_45_1] then
		return var_45_0[arg_45_1]
	end

	local var_45_3 = #var_45_1

	if var_45_3 == 0 then
		local var_45_4 = var_45_2.cell_width
		local var_45_5 = var_45_2.grid_width + 1

		var_45_2.grid_width = var_45_5

		for iter_45_0, iter_45_1 in pairs(var_45_0) do
			local var_45_6 = iter_45_1.pos
			local var_45_7 = var_45_6:unbox()
			local var_45_8 = var_45_4 * 0.5

			var_45_7[1] = var_45_7[1] - var_45_8
			var_45_7[2] = var_45_7[2] - var_45_8

			var_45_6:store(var_45_7)
		end

		local var_45_9 = var_45_2.cell_width

		for iter_45_2 = 1, var_45_5 do
			local var_45_10 = (iter_45_2 - 1 - (var_45_5 - 1) * 0.5) * var_45_4 + math.random() * var_45_9 - var_45_9 * 0.5
			local var_45_11 = (var_45_5 - 1) * 0.5 * var_45_4 + math.random() * var_45_9 - var_45_9 * 0.5

			var_45_1[iter_45_2] = {
				pos = Vector3Box(Vector3(var_45_10, var_45_11, 0)),
				grid_pow_of = var_45_5
			}
			var_45_3 = var_45_3 + 1

			if iter_45_2 ~= var_45_5 then
				local var_45_12 = (var_45_5 - 1) * 0.5 * var_45_4 + math.random() * var_45_9 - var_45_9 * 0.5
				local var_45_13 = (iter_45_2 - 1 - (var_45_5 - 1) * 0.5) * var_45_4 + math.random() * var_45_9 - var_45_9 * 0.5

				var_45_1[var_45_5 + iter_45_2] = {
					pos = Vector3Box(Vector3(var_45_12, var_45_13, 0)),
					grid_pow_of = var_45_5
				}
				var_45_3 = var_45_3 + 1
			end
		end
	end

	local var_45_14 = Math.random(1, var_45_3)
	local var_45_15 = var_45_1[var_45_14]

	table.swap_delete(var_45_1, var_45_14)

	var_45_0[arg_45_1] = var_45_15
	var_45_2.n = var_45_2.n + 1

	return var_45_15
end

AICommanderExtension._store_fallback_position = function (arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0._fallback_positions

	if var_46_0[arg_46_1] then
		local var_46_1 = arg_46_0._stored_fallback_positions
		local var_46_2 = arg_46_0._fallback_position_data
		local var_46_3 = var_46_0[arg_46_1]

		var_46_0[arg_46_1] = nil
		var_46_2.n = var_46_2.n - 1
		var_46_1[#var_46_1 + 1] = var_46_3

		local var_46_4 = var_46_2.n
		local var_46_5 = var_46_4 > 0 and math.ceil(math.sqrt(var_46_4)) or 0
		local var_46_6 = var_46_2.grid_width

		var_46_2.grid_width = var_46_5

		if var_46_5 ~= var_46_6 then
			local var_46_7 = var_46_2.cell_width

			for iter_46_0, iter_46_1 in pairs(var_46_0) do
				if var_46_5 < iter_46_1.grid_pow_of then
					var_46_0[iter_46_0] = nil
					var_46_2.n = var_46_2.n - 1
				else
					local var_46_8 = iter_46_1.pos
					local var_46_9 = var_46_8:unbox()
					local var_46_10 = var_46_7 * 0.5

					var_46_9[1] = var_46_9[1] + var_46_10
					var_46_9[2] = var_46_9[2] + var_46_10

					var_46_8:store(var_46_9)
				end
			end

			local var_46_11 = var_46_2.n
			local var_46_12 = var_46_11 > 0 and math.ceil(math.sqrt(var_46_11)) or 0

			for iter_46_2 = #var_46_1, 1, -1 do
				local var_46_13 = var_46_1[iter_46_2]

				if var_46_12 < var_46_13.grid_pow_of then
					table.swap_delete(var_46_1, iter_46_2)
				else
					local var_46_14 = var_46_13.pos
					local var_46_15 = var_46_14:unbox()
					local var_46_16 = var_46_7 * 0.5

					var_46_15[1] = var_46_15[1] + var_46_16
					var_46_15[2] = var_46_15[2] + var_46_16

					var_46_14:store(var_46_15)
				end
			end
		end
	end
end
