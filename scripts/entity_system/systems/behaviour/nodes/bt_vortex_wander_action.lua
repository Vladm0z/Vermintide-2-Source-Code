-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_vortex_wander_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVortexWanderAction = class(BTVortexWanderAction, BTNode)

local var_0_0 = POSITION_LOOKUP

function BTVortexWanderAction.init(arg_1_0, ...)
	BTVortexWanderAction.super.init(arg_1_0, ...)
end

BTVortexWanderAction.name = "BTVortexWanderAction"

function BTVortexWanderAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
end

function BTVortexWanderAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

function BTVortexWanderAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.vortex_data

	arg_4_0:_wander_around(arg_4_1, arg_4_3, arg_4_4, arg_4_2, var_4_0)

	return "running"
end

function BTVortexWanderAction._wander_around(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_4.action
	local var_5_1 = arg_5_5.wander_state
	local var_5_2 = arg_5_5.vortex_template
	local var_5_3 = arg_5_5.num_players_inside
	local var_5_4 = arg_5_4.navigation_extension
	local var_5_5 = var_5_4:is_following_path()

	arg_5_4.move_state = var_5_5 and "moving" or "idle"

	if var_5_2.stop_and_process_player and var_5_3 > 0 and var_5_1 ~= "standing_still" and var_5_1 ~= "forced_standing_still" then
		arg_5_5.wander_state = "standing_still"

		var_5_4:stop()
	elseif var_5_3 == 0 and arg_5_5.wander_state == "standing_still" then
		arg_5_5.wander_state = "recalc_path"
	end

	if var_5_1 == "wandering" then
		if var_5_4:has_reached_destination(0.5) or arg_5_2 > arg_5_5.wander_time then
			arg_5_5.wander_state = "recalc_path"
		end
	elseif var_5_1 == "calculating_path" then
		local var_5_6 = var_5_4:is_computing_path()
		local var_5_7 = not arg_5_4.no_path_found

		if not var_5_6 and (var_5_5 or not var_5_7) then
			if var_5_7 then
				arg_5_5.wander_state = "wandering"
				arg_5_5.wander_time = arg_5_2 + 1
			else
				arg_5_5.wander_state = "no_path_found"
				arg_5_5.idle_time = arg_5_2 + 2 + math.random()
			end
		end
	elseif var_5_1 == "recalc_path" then
		local var_5_8 = arg_5_4.nav_world
		local var_5_9 = arg_5_4.target_unit
		local var_5_10 = var_0_0[arg_5_1]
		local var_5_11 = var_5_2.random_wander or not var_5_9
		local var_5_12 = arg_5_4.directed_wander_position_boxed and arg_5_4.directed_wander_position_boxed:unbox()

		if var_5_12 then
			var_5_4:move_to(var_5_12)

			arg_5_5.wander_state = "calculating_path"
		elseif var_5_11 then
			local var_5_13 = ConflictUtils.get_spawn_pos_on_circle(var_5_8, var_5_10, 5, 10, 7)

			if var_5_13 then
				var_5_4:move_to(var_5_13)

				arg_5_5.wander_state = "calculating_path"
			else
				arg_5_5.idle_time = arg_5_2 + math.random() * 0.5
				arg_5_5.wander_state = "no_path_found"
			end
		elseif Unit.alive(var_5_9) then
			local var_5_14 = var_0_0[var_5_9]
			local var_5_15 = LocomotionUtils.pos_on_mesh(var_5_8, var_5_14, 1, 2)

			if var_5_15 then
				if Vector3.length_squared(var_5_15 - var_5_10) > 0.25 then
					var_5_4:move_to(var_5_15)

					arg_5_5.wander_state = "calculating_path"
				end
			else
				arg_5_5.idle_time = arg_5_2 + math.random() * 0.5
				arg_5_5.wander_state = "no_path_found"
			end
		else
			arg_5_5.idle_time = arg_5_2 + 2 + math.random()
			arg_5_5.wander_state = "no_path_found"
		end
	elseif var_5_1 == "no_path_found" then
		if arg_5_2 > arg_5_5.idle_time then
			arg_5_5.wander_state = "recalc_path"
		end
	elseif var_5_1 ~= "standing_still" and var_5_1 == "forced_standing_still" then
		-- block empty
	end
end
