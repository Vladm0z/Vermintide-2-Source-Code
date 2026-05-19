-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_spawn/bt_victim_grabbed_throw_away_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVictimGrabbedThrowAwayAction = class(BTVictimGrabbedThrowAwayAction, BTNode)
BTVictimGrabbedThrowAwayAction.name = "BTVictimGrabbedThrowAwayAction"

function BTVictimGrabbedThrowAwayAction.init(arg_1_0, ...)
	BTVictimGrabbedThrowAwayAction.super.init(arg_1_0, ...)
end

function BTVictimGrabbedThrowAwayAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Managers.state.network
	local var_2_1 = "attack_grabbed_throw"

	arg_2_2.action = arg_2_0._tree_node.action_data

	var_2_0:anim_event(arg_2_1, var_2_1)

	if arg_2_2.move_state ~= "idle" then
		arg_2_2.move_state = "idle"
	end

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	if Unit.alive(arg_2_2.victim_grabbed) then
		StatusUtils.set_grabbed_by_chaos_spawn_status_network(arg_2_2.victim_grabbed, "thrown_away")
	end

	arg_2_2.anim_cb_finished = nil
	arg_2_2.chaos_spawn_is_throwing = true
	arg_2_2.grabbed_state = "throw_away"
	arg_2_2.throw_direction = Vector3Box()

	local var_2_2 = 3.5
	local var_2_3

	if Unit.alive(arg_2_2.target_unit) then
		local var_2_4 = arg_2_2.nav_world
		local var_2_5 = POSITION_LOOKUP[arg_2_1]
		local var_2_6 = var_2_5 + (POSITION_LOOKUP[arg_2_2.target_unit] - var_2_5) * var_2_2

		var_2_3 = GwNavQueries.raycango(var_2_4, var_2_5, var_2_6)
	end

	if not var_2_3 then
		local var_2_7 = arg_2_0:find_throw_direction(arg_2_1, arg_2_2, var_2_2)

		if var_2_7 then
			arg_2_2.throw_direction:store(var_2_7)

			arg_2_2.use_stored_throw_direction = true
		else
			arg_2_2.drop_grabbed_player = true
		end
	end
end

function BTVictimGrabbedThrowAwayAction.find_throw_direction(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = POSITION_LOOKUP[arg_3_1] + Vector3.up()
	local var_3_1 = Unit.local_rotation(arg_3_1, 0)
	local var_3_2 = arg_3_2.nav_world

	for iter_3_0 = 1, 4 do
		local var_3_3 = Quaternion.forward

		if iter_3_0 == 2 or iter_3_0 == 4 then
			var_3_3 = Quaternion.right
		end

		local var_3_4 = var_3_3(var_3_1)

		if iter_3_0 == 3 or iter_3_0 == 4 then
			var_3_4 = -var_3_4
		end

		local var_3_5 = var_3_0 + var_3_4 * arg_3_3

		if GwNavQueries.raycango(var_3_2, var_3_0, var_3_5) then
			return var_3_4
		end
	end

	return nil
end

function BTVictimGrabbedThrowAwayAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.anim_cb_throw = false

	if Unit.alive(arg_4_2.victim_grabbed) and (arg_4_4 == "aborted" or arg_4_2.drop_grabbed_player and arg_4_2.victim_grabbed) then
		StatusUtils.set_grabbed_by_chaos_spawn_network(arg_4_2.victim_grabbed, false, arg_4_1)
	end

	arg_4_2.attack_grabbed_attacks = 0
	arg_4_2.has_grabbed_victim = false
	arg_4_2.victim_grabbed = nil
	arg_4_2.chaos_spawn_is_throwing = false
	arg_4_2.grabbed_state = nil
	arg_4_2.wants_to_throw = false
	arg_4_2.throw_direction = nil
	arg_4_2.use_stored_throw_direction = nil
	arg_4_2.drop_grabbed_player = nil
	arg_4_2.chew_attacks_done = 0
end

function BTVictimGrabbedThrowAwayAction.catapult_player(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.victim_grabbed
	local var_5_1 = POSITION_LOOKUP[var_5_0]
	local var_5_2

	if arg_5_2.target_unit then
		var_5_2 = POSITION_LOOKUP[arg_5_2.target_unit]
	else
		var_5_2 = var_5_1 + Quaternion.forward(Unit.local_rotation(arg_5_1, 0)) * 10
	end

	local var_5_3 = arg_5_3 * (arg_5_2.use_stored_throw_direction and arg_5_2.throw_direction:unbox() or Vector3.normalize(var_5_2 - var_5_1))

	if arg_5_4 then
		Vector3.set_z(var_5_3, arg_5_4)
	end

	StatusUtils.set_grabbed_by_chaos_spawn_network(var_5_0, false, arg_5_1)
	StatusUtils.set_catapulted_network(var_5_0, true, var_5_3)

	arg_5_2.anim_cb_throw = nil
end

local var_0_0 = Unit.alive

function BTVictimGrabbedThrowAwayAction.run(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_2.attack_finished or not Unit.alive(arg_6_2.victim_grabbed) or arg_6_2.drop_grabbed_player then
		return "done"
	elseif arg_6_2.anim_cb_throw then
		arg_6_0:catapult_player(arg_6_1, arg_6_2, 25, 1)
	end

	local var_6_0 = arg_6_2.target_unit

	if Unit.alive(var_6_0) then
		local var_6_1 = arg_6_2.use_stored_throw_direction and arg_6_2.throw_direction:unbox()
		local var_6_2 = var_6_1 and Quaternion.look(var_6_1) or var_0_0(var_6_0) and LocomotionUtils.rotation_towards_unit_flat(arg_6_1, var_6_0)

		arg_6_2.locomotion_extension:set_wanted_rotation(var_6_2)
	end

	return "running"
end
