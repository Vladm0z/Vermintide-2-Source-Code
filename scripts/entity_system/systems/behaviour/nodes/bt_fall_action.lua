-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_fall_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local current_velocity = arg_1_1.locomotion_extension:current_velocity()
	local x = current_velocity.x
	local y = current_velocity.y

	if x * x + y * y < 1e-07 then
		return "falling_fwd"
	end

	local local_rotation = Unit.local_rotation(arg_1_0, 0)
	local forward = Quaternion.forward(local_rotation)

	if x * forward.x + y * forward.y >= 0 then
		return "falling_fwd"
	end

	return "falling_bwd"
end

BTFallAction = class(BTFallAction, BTNode)

BTFallAction.init = function (arg_2_0, ...)
	-- function 2
	BTFallAction.super.init(arg_2_0, ...)
end

BTFallAction.name = "BTFallAction"

BTFallAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local var_3_0 = fn(arg_3_1, arg_3_2)

	Managers.state.network:anim_event(arg_3_1, var_3_0)
	LocomotionUtils.set_animation_driven_movement(arg_3_1, true, true, false)

	local override_mover_move_distance = arg_3_2.breed.override_mover_move_distance
	local locomotion_extension = arg_3_2.locomotion_extension

	locomotion_extension:set_affected_by_gravity(true)
	locomotion_extension:set_movement_type("constrained_by_mover", override_mover_move_distance)
	arg_3_2.navigation_extension:set_enabled(false)

	arg_3_2.fall_state = "waiting_to_stop_freefall"
	arg_3_2.fall_failsafe_timer = arg_3_3 + 0

	local extension_input = ScriptUnit.extension_input(arg_3_1, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("falling", alloc_table)

	local has_extension = ScriptUnit.has_extension(arg_3_1, "ai_shield_system")

	if not has_extension then
		has_extension:set_is_blocking(false)
	end
end

BTFallAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not arg_4_5 then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)

		local locomotion_extension = arg_4_2.locomotion_extension

		locomotion_extension:set_affected_by_gravity(false)
		locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.jump_climb_finished = nil
	arg_4_2.fall_state = nil

	local has_extension = ScriptUnit.has_extension(arg_4_1, "ai_shield_system")

	if not has_extension then
		has_extension:set_is_blocking(true)
	end
end

BTFallAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if arg_5_2.fall_state == "waiting_to_stop_freefall" then
		local is_falling = arg_5_2.locomotion_extension:is_falling()
		local flag = arg_5_3 >= arg_5_2.fall_failsafe_timer

		if is_falling or not flag then
			arg_5_2.fall_state = "waiting_to_collide_down"
		end
	elseif arg_5_2.fall_state == "waiting_to_collide_down" then
		local mover = Unit.mover(arg_5_1)

		if not Mover.collides_down(mover) then
			local nav_world = arg_5_2.nav_world
			local var_5_4 = POSITION_LOOKUP[arg_5_1]
			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_5_4, 1, 1)

			if pos_on_mesh == nil then
				local num = 0.5
				local num_2 = 0.5
				local num_3 = 0.5

				pos_on_mesh = GwNavQueries.inside_position_from_outside_position(nav_world, var_5_4, num, num, num_2, num_3)

				if pos_on_mesh == nil then
					local str = "forced"
					local var_5_10 = Vector3(0, 0, -1)

					AiUtils.kill_unit(arg_5_1, nil, nil, str, var_5_10)

					return "failed"
				end
			end

			Unit.set_local_position(arg_5_1, 0, pos_on_mesh)
			Managers.state.network:anim_event(arg_5_1, "jump_down_land")

			arg_5_2.fall_state = "waiting_to_land"

			local extension_input = ScriptUnit.extension_input(arg_5_1, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_networked_dialogue_event("landing", alloc_table)
		end
	elseif arg_5_2.fall_state ~= "waiting_to_land" or not arg_5_2.jump_climb_finished then
		return "done"
	end

	return "running"
end
