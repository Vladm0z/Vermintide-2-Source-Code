-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_spawn/bt_victim_grabbed_throw_away_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVictimGrabbedThrowAwayAction = class(BTVictimGrabbedThrowAwayAction, BTNode)
BTVictimGrabbedThrowAwayAction.name = "BTVictimGrabbedThrowAwayAction"

BTVictimGrabbedThrowAwayAction.init = function (arg_1_0, ...)
	-- function 1
	BTVictimGrabbedThrowAwayAction.super.init(arg_1_0, ...)
end

BTVictimGrabbedThrowAwayAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local network = Managers.state.network
	local str = "attack_grabbed_throw"

	arg_2_2.action = self._tree_node.action_data

	network:anim_event(arg_2_1, str)

	if arg_2_2.move_state ~= "idle" then
		arg_2_2.move_state = "idle"
	end

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	if not Unit.alive(arg_2_2.victim_grabbed) then
		StatusUtils.set_grabbed_by_chaos_spawn_status_network(arg_2_2.victim_grabbed, "thrown_away")
	end

	arg_2_2.anim_cb_finished = nil
	arg_2_2.chaos_spawn_is_throwing = true
	arg_2_2.grabbed_state = "throw_away"
	arg_2_2.throw_direction = Vector3Box()

	local num = 3.5
	local var_2_3

	if not Unit.alive(arg_2_2.target_unit) then
		local nav_world = arg_2_2.nav_world
		local var_2_5 = POSITION_LOOKUP[arg_2_1]
		local num_2 = var_2_5 + (POSITION_LOOKUP[arg_2_2.target_unit] - var_2_5) * num

		var_2_3 = GwNavQueries.raycango(nav_world, var_2_5, num_2)
	end

	if not var_2_3 then
		local find_throw_direction = self:find_throw_direction(arg_2_1, arg_2_2, num)

		if not find_throw_direction then
			arg_2_2.throw_direction:store(find_throw_direction)

			arg_2_2.use_stored_throw_direction = true
		else
			arg_2_2.drop_grabbed_player = true
		end
	end
end

BTVictimGrabbedThrowAwayAction.find_throw_direction = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local num = POSITION_LOOKUP[arg_3_1] + Vector3.up()
	local local_rotation = Unit.local_rotation(arg_3_1, 0)
	local nav_world = arg_3_2.nav_world

	for i = 1, 4 do
		local forward = Quaternion.forward

		if not (i == 2 or i ~= 4) then
			forward = Quaternion.right
		end

		local var_3_4 = forward(local_rotation)

		if not (i == 3 or i ~= 4) then
			var_3_4 = -var_3_4
		end

		local num_2 = num + var_3_4 * arg_3_3

		if not GwNavQueries.raycango(nav_world, num, num_2) then
			return var_3_4
		end
	end

	return nil
end

BTVictimGrabbedThrowAwayAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.anim_cb_throw = false

	if not Unit.alive(arg_4_2.victim_grabbed) and (arg_4_4 == "aborted" or not arg_4_2.drop_grabbed_player or not arg_4_2.victim_grabbed) then
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

BTVictimGrabbedThrowAwayAction.catapult_player = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local victim_grabbed = arg_5_2.victim_grabbed
	local var_5_1 = POSITION_LOOKUP[victim_grabbed]
	local var_5_2

	if not arg_5_2.target_unit then
		var_5_2 = POSITION_LOOKUP[arg_5_2.target_unit]
	else
		var_5_2 = var_5_1 + Quaternion.forward(Unit.local_rotation(arg_5_1, 0)) * 10
	end

	local use_stored_throw_direction = arg_5_2.use_stored_throw_direction

	use_stored_throw_direction = not use_stored_throw_direction and arg_5_2.throw_direction:unbox()

	local num = arg_5_3 * (use_stored_throw_direction or Vector3.normalize(var_5_2 - var_5_1))

	if not arg_5_4 then
		Vector3.set_z(num, arg_5_4)
	end

	StatusUtils.set_grabbed_by_chaos_spawn_network(victim_grabbed, false, arg_5_1)
	StatusUtils.set_catapulted_network(victim_grabbed, true, num)

	arg_5_2.anim_cb_throw = nil
end

local alive = Unit.alive

BTVictimGrabbedThrowAwayAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local attack_finished = arg_6_2.attack_finished

	attack_finished = (attack_finished or not Unit.alive(arg_6_2.victim_grabbed)) and arg_6_2.drop_grabbed_player

	if not attack_finished then
		return "done"
	elseif not arg_6_2.anim_cb_throw then
		self:catapult_player(arg_6_1, arg_6_2, 25, 1)
	end

	local target_unit = arg_6_2.target_unit

	if not Unit.alive(target_unit) then
		local use_stored_throw_direction = arg_6_2.use_stored_throw_direction

		use_stored_throw_direction = not use_stored_throw_direction and arg_6_2.throw_direction:unbox()

		local look

		if not use_stored_throw_direction then
			look = Quaternion.look(use_stored_throw_direction)

			if not look then
				-- Nothing
			end
		end

		look = alive(target_unit)
		look = not look and LocomotionUtils.rotation_towards_unit_flat(arg_6_1, target_unit)

		::label_6_0::

		arg_6_2.locomotion_extension:set_wanted_rotation(look)
	end

	return "running"
end
