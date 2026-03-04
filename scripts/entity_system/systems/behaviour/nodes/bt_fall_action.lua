-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_fall_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1.locomotion_extension:current_velocity()
	local var_1_1 = var_1_0.x
	local var_1_2 = var_1_0.y

	if var_1_1 * var_1_1 + var_1_2 * var_1_2 < 1e-07 then
		return "falling_fwd"
	end

	local var_1_3 = Unit.local_rotation(arg_1_0, 0)
	local var_1_4 = Quaternion.forward(var_1_3)

	if var_1_1 * var_1_4.x + var_1_2 * var_1_4.y >= 0 then
		return "falling_fwd"
	end

	return "falling_bwd"
end

BTFallAction = class(BTFallAction, BTNode)

BTFallAction.init = function (arg_2_0, ...)
	BTFallAction.super.init(arg_2_0, ...)
end

BTFallAction.name = "BTFallAction"

BTFallAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = var_0_0(arg_3_1, arg_3_2)

	Managers.state.network:anim_event(arg_3_1, var_3_0)
	LocomotionUtils.set_animation_driven_movement(arg_3_1, true, true, false)

	local var_3_1 = arg_3_2.breed.override_mover_move_distance
	local var_3_2 = arg_3_2.locomotion_extension

	var_3_2:set_affected_by_gravity(true)
	var_3_2:set_movement_type("constrained_by_mover", var_3_1)
	arg_3_2.navigation_extension:set_enabled(false)

	arg_3_2.fall_state = "waiting_to_stop_freefall"
	arg_3_2.fall_failsafe_timer = arg_3_3 + 0

	local var_3_3 = ScriptUnit.extension_input(arg_3_1, "dialogue_system")
	local var_3_4 = FrameTable.alloc_table()

	var_3_3:trigger_networked_dialogue_event("falling", var_3_4)

	local var_3_5 = ScriptUnit.has_extension(arg_3_1, "ai_shield_system")

	if var_3_5 then
		var_3_5:set_is_blocking(false)
	end
end

BTFallAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if not arg_4_5 then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)

		local var_4_0 = arg_4_2.locomotion_extension

		var_4_0:set_affected_by_gravity(false)
		var_4_0:set_movement_type("snap_to_navmesh")
	end

	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.jump_climb_finished = nil
	arg_4_2.fall_state = nil

	local var_4_1 = ScriptUnit.has_extension(arg_4_1, "ai_shield_system")

	if var_4_1 then
		var_4_1:set_is_blocking(true)
	end
end

BTFallAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_2.fall_state == "waiting_to_stop_freefall" then
		local var_5_0 = arg_5_2.locomotion_extension:is_falling()
		local var_5_1 = arg_5_3 >= arg_5_2.fall_failsafe_timer

		if not var_5_0 and var_5_1 then
			arg_5_2.fall_state = "waiting_to_collide_down"
		end
	elseif arg_5_2.fall_state == "waiting_to_collide_down" then
		local var_5_2 = Unit.mover(arg_5_1)

		if Mover.collides_down(var_5_2) then
			local var_5_3 = arg_5_2.nav_world
			local var_5_4 = POSITION_LOOKUP[arg_5_1]
			local var_5_5 = LocomotionUtils.pos_on_mesh(var_5_3, var_5_4, 1, 1)

			if var_5_5 == nil then
				local var_5_6 = 0.5
				local var_5_7 = 0.5
				local var_5_8 = 0.5

				var_5_5 = GwNavQueries.inside_position_from_outside_position(var_5_3, var_5_4, var_5_6, var_5_6, var_5_7, var_5_8)

				if var_5_5 == nil then
					local var_5_9 = "forced"
					local var_5_10 = Vector3(0, 0, -1)

					AiUtils.kill_unit(arg_5_1, nil, nil, var_5_9, var_5_10)

					return "failed"
				end
			end

			Unit.set_local_position(arg_5_1, 0, var_5_5)
			Managers.state.network:anim_event(arg_5_1, "jump_down_land")

			arg_5_2.fall_state = "waiting_to_land"

			local var_5_11 = ScriptUnit.extension_input(arg_5_1, "dialogue_system")
			local var_5_12 = FrameTable.alloc_table()

			var_5_11:trigger_networked_dialogue_event("landing", var_5_12)
		end
	elseif arg_5_2.fall_state == "waiting_to_land" and arg_5_2.jump_climb_finished then
		return "done"
	end

	return "running"
end
