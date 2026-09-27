-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_blocked_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBlockedAction = class(BTBlockedAction, BTNode)

BTBlockedAction.init = function (arg_1_0, ...)
	-- function 1
	BTBlockedAction.super.init(arg_1_0, ...)
end

BTBlockedAction.name = "BTBlockedAction"

BTBlockedAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.navigation_extension:set_enabled(false)

	local action_data = self._tree_node.action_data
	local blocked_anims = action_data.blocked_anims
	local blocked_anim = arg_2_2.blocked_anim

	blocked_anim = blocked_anim or blocked_anims[Math.random(1, #blocked_anims)]

	Managers.state.network:anim_event(arg_2_1, blocked_anim)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, true, true, false)

	local locomotion_extension = arg_2_2.locomotion_extension

	locomotion_extension:set_rotation_speed(100)
	locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.spawn_to_running = nil

	if not ScriptUnit.has_extension(arg_2_1, "ai_shield_system") then
		ScriptUnit.extension(arg_2_1, "ai_shield_system"):set_is_blocking(false)
	end

	arg_2_2.move_state = "stagger"

	local system = Managers.state.entity:system("ai_slot_system")

	system:do_slot_search(arg_2_1, false)
	system:ai_unit_blocked_attack(arg_2_1)

	local difficulty_duration = action_data.difficulty_duration

	if not difficulty_duration then
		local var_2_6 = difficulty_duration[Managers.state.difficulty:get_difficulty()]

		if not var_2_6 then
			arg_2_2.leave_blocked_at_t = arg_2_3 + Math.random_range(var_2_6[1], var_2_6[2])
		end
	end
end

BTBlockedAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.blocked = nil
	arg_3_2.anim_cb_blocked_cooldown = nil
	arg_3_2.stagger_hit_wall = nil
	arg_3_2.leave_blocked_at_t = nil

	if not (not arg_3_2.stagger and not (arg_3_2.stagger < 3)) then
		arg_3_2.stagger = 3
	end

	if not ScriptUnit.has_extension(arg_3_1, "ai_shield_system") then
		ScriptUnit.extension(arg_3_1, "ai_shield_system"):set_is_blocking(true)
	end

	if not arg_3_5 then
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false, false)

		local locomotion_extension = arg_3_2.locomotion_extension

		locomotion_extension:set_rotation_speed(10)
		locomotion_extension:set_wanted_rotation(nil)
		locomotion_extension:set_movement_type("snap_to_navmesh")
		locomotion_extension:set_wanted_velocity(Vector3.zero())
	end

	arg_3_2.blocked_anim = nil

	arg_3_2.navigation_extension:set_enabled(true)
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, true)
end

BTBlockedAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local locomotion_extension = arg_4_2.locomotion_extension

	if not (locomotion_extension.movement_type == "constrained_by_mover" or arg_4_2.stagger_hit_wall) then
		local var_4_1 = POSITION_LOOKUP[arg_4_1]
		local current_velocity = locomotion_extension:current_velocity()
		local nav_world = arg_4_2.nav_world
		local world = arg_4_2.world
		local physics_world = World.physics_world(world)
		local traverse_logic = arg_4_2.navigation_extension:traverse_logic()
		local navmesh_movement_check = LocomotionUtils.navmesh_movement_check(var_4_1, current_velocity, nav_world, physics_world, traverse_logic)

		if navmesh_movement_check == "navmesh_hit_wall" then
			arg_4_2.stagger_hit_wall = true
		elseif navmesh_movement_check == "navmesh_use_mover" then
			local override_mover_move_distance = arg_4_2.breed.override_mover_move_distance
			local flag = true

			if not locomotion_extension:set_movement_type("constrained_by_mover", override_mover_move_distance, flag) then
				locomotion_extension:set_movement_type("snap_to_navmesh")

				arg_4_2.stagger_hit_wall = true
			end
		end
	end

	if not (not arg_4_2.anim_cb_blocked_cooldown and not arg_4_2.leave_blocked_at_t and not (arg_4_3 > arg_4_2.leave_blocked_at_t)) then
		return "done"
	end

	return "running"
end
