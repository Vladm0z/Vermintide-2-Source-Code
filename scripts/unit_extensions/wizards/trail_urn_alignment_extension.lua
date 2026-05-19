-- chunkname: @scripts/unit_extensions/wizards/trail_urn_alignment_extension.lua

TrailUrnAlignmentExtension = class(TrailUrnAlignmentExtension)

local var_0_0 = {
	MOVE_TO_NODE = 2,
	WAITING_FOR_INTERACTION = 1,
	IS_ALIGNED = 3
}
local var_0_1 = 0.3

function TrailUrnAlignmentExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._interactable_type = Unit.get_data(arg_1_2, "interaction_data", "interaction_type")
	arg_1_0._elapsed_time = 0
	arg_1_0._start_time = 0
	arg_1_0._start_position = nil
	arg_1_0._start_offset = nil
	arg_1_0._interaction_position = Vector3Box(Vector3.zero())
	arg_1_0._position = Vector3Box(Unit.world_position(arg_1_0._unit, 0))
	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._interaction_distance = Unit.get_data(arg_1_2, "animation_distance")
	arg_1_0._align_state = var_0_0.WAITING_FOR_INTERACTION
end

function TrailUrnAlignmentExtension.update_interaction_position(arg_2_0, arg_2_1)
	local var_2_0 = POSITION_LOOKUP[arg_2_1]
	local var_2_1 = arg_2_0._position:unbox()
	local var_2_2 = Vector3.normalize(var_2_0 - var_2_1) * arg_2_0._interaction_distance + var_2_1
	local var_2_3, var_2_4 = GwNavQueries.triangle_from_position(arg_2_0._nav_world, var_2_2, 1, 1)

	if var_2_3 then
		var_2_2.z = var_2_4

		return var_2_2
	else
		local var_2_5 = 10
		local var_2_6 = 1

		for iter_2_0 = 1, var_2_5 do
			local var_2_7 = 2 * math.pi / var_2_5 * iter_2_0
			local var_2_8 = Vector3(math.sin(var_2_7) * arg_2_0._interaction_distance * var_2_6, -math.cos(var_2_7) * arg_2_0._interaction_distance * var_2_6, 0)

			var_2_6 = var_2_6 * -1

			local var_2_9 = var_2_1 + var_2_8
			local var_2_10, var_2_11 = GwNavQueries.triangle_from_position(arg_2_0._nav_world, var_2_9, 1, 1)

			if var_2_10 then
				var_2_9.z = var_2_11

				return var_2_9
			end
		end
	end
end

function TrailUrnAlignmentExtension.can_interact(arg_3_0)
	if arg_3_0._align_state ~= var_0_0.WAITING_FOR_INTERACTION then
		return false
	end

	return true
end

function TrailUrnAlignmentExtension.on_client_start_interaction(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._elapsed_time = 0
	arg_4_0._start_time = arg_4_2
	arg_4_0._start_position = Vector3Box(POSITION_LOOKUP[arg_4_1])

	local var_4_0 = arg_4_0:update_interaction_position(arg_4_1)

	arg_4_0._interaction_position:store(var_4_0)

	arg_4_0._align_state = var_0_0.MOVE_TO_NODE
end

local var_0_2 = 1

function TrailUrnAlignmentExtension.is_unit_pushed_out_off_range(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local var_5_1 = arg_5_0._start_offset:unbox()
	local var_5_2 = var_5_0 - arg_5_0._position:unbox()

	if Vector3.distance_squared(var_5_1, var_5_2) > var_0_2 then
		arg_5_0._align_state = var_0_0.WAITING_FOR_INTERACTION

		return true
	end

	return false
end

function TrailUrnAlignmentExtension.on_client_move_to_node(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_0._align_state ~= var_0_0.MOVE_TO_NODE then
		return false
	end

	local var_6_0 = arg_6_0._position:unbox()
	local var_6_1 = POSITION_LOOKUP[arg_6_1]
	local var_6_2 = arg_6_0:lerp_to_node(arg_6_1, var_0_1, arg_6_4)

	if not arg_6_3 then
		local var_6_3 = ScriptUnit.extension(arg_6_1, "locomotion_system")

		var_6_3:enable_wanted_position_movement()
		var_6_3:set_wanted_pos(var_6_2)

		local var_6_4 = var_6_0 - var_6_1
		local var_6_5 = Quaternion.look(Vector3.flat(var_6_4), Vector3.up())

		Unit.set_local_rotation(arg_6_1, 0, var_6_5)
	end

	if arg_6_0._interaction_distance * arg_6_0._interaction_distance >= Vector3.distance_squared(var_6_1, arg_6_0._position:unbox()) or arg_6_0._elapsed_time > var_0_1 then
		arg_6_0._start_offset = Vector3Box(POSITION_LOOKUP[arg_6_1] - arg_6_0._position:unbox())
		arg_6_0._align_state = var_0_0.IS_ALIGNED
	end
end

function TrailUrnAlignmentExtension.lerp_to_node(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0._elapsed_time = arg_7_3 - arg_7_0._start_time

	local var_7_0 = arg_7_0._elapsed_time / arg_7_2
	local var_7_1 = math.ease_out_quad(var_7_0)
	local var_7_2 = math.clamp(var_7_1, 0, 1)

	return (Vector3.lerp(arg_7_0._start_position:unbox(), arg_7_0._interaction_position:unbox(), var_7_2))
end

function TrailUrnAlignmentExtension.on_client_stop(arg_8_0, arg_8_1)
	if arg_8_1 == InteractionResult.SUCCESS then
		local var_8_0 = "lua_interaction_stopped_" .. arg_8_0._interactable_type .. "_" .. arg_8_1

		Unit.flow_event(arg_8_0._unit, var_8_0)

		arg_8_0._align_state = var_0_0.DONE
	else
		arg_8_0._align_state = var_0_0.WAITING_FOR_INTERACTION
	end
end

function TrailUrnAlignmentExtension.is_state_move_to_node(arg_9_0)
	if arg_9_0._align_state == var_0_0.MOVE_TO_NODE then
		return true
	end

	return false
end

function TrailUrnAlignmentExtension.set_state_waiting_for_interaction(arg_10_0)
	arg_10_0._align_state = var_0_0.WAITING_FOR_INTERACTION
end

function TrailUrnAlignmentExtension.is_state_aligned(arg_11_0)
	if arg_11_0._align_state == var_0_0.IS_ALIGNED then
		return true
	end

	return false
end
