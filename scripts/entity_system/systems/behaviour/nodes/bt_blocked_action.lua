-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_blocked_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBlockedAction = class(BTBlockedAction, BTNode)

BTBlockedAction.init = function (arg_1_0, ...)
	BTBlockedAction.super.init(arg_1_0, ...)
end

BTBlockedAction.name = "BTBlockedAction"

BTBlockedAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.navigation_extension:set_enabled(false)

	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = var_2_0.blocked_anims
	local var_2_2 = arg_2_2.blocked_anim or var_2_1[Math.random(1, #var_2_1)]

	Managers.state.network:anim_event(arg_2_1, var_2_2)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, true, true, false)

	local var_2_3 = arg_2_2.locomotion_extension

	var_2_3:set_rotation_speed(100)
	var_2_3:set_wanted_velocity(Vector3.zero())

	arg_2_2.spawn_to_running = nil

	if ScriptUnit.has_extension(arg_2_1, "ai_shield_system") then
		ScriptUnit.extension(arg_2_1, "ai_shield_system"):set_is_blocking(false)
	end

	arg_2_2.move_state = "stagger"

	local var_2_4 = Managers.state.entity:system("ai_slot_system")

	var_2_4:do_slot_search(arg_2_1, false)
	var_2_4:ai_unit_blocked_attack(arg_2_1)

	local var_2_5 = var_2_0.difficulty_duration

	if var_2_5 then
		local var_2_6 = var_2_5[Managers.state.difficulty:get_difficulty()]

		if var_2_6 then
			arg_2_2.leave_blocked_at_t = arg_2_3 + Math.random_range(var_2_6[1], var_2_6[2])
		end
	end
end

BTBlockedAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.blocked = nil
	arg_3_2.anim_cb_blocked_cooldown = nil
	arg_3_2.stagger_hit_wall = nil
	arg_3_2.leave_blocked_at_t = nil

	if arg_3_2.stagger and arg_3_2.stagger < 3 then
		arg_3_2.stagger = 3
	end

	if ScriptUnit.has_extension(arg_3_1, "ai_shield_system") then
		ScriptUnit.extension(arg_3_1, "ai_shield_system"):set_is_blocking(true)
	end

	if not arg_3_5 then
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false, false)

		local var_3_0 = arg_3_2.locomotion_extension

		var_3_0:set_rotation_speed(10)
		var_3_0:set_wanted_rotation(nil)
		var_3_0:set_movement_type("snap_to_navmesh")
		var_3_0:set_wanted_velocity(Vector3.zero())
	end

	arg_3_2.blocked_anim = nil

	arg_3_2.navigation_extension:set_enabled(true)
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, true)
end

BTBlockedAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.locomotion_extension

	if var_4_0.movement_type ~= "constrained_by_mover" and not arg_4_2.stagger_hit_wall then
		local var_4_1 = POSITION_LOOKUP[arg_4_1]
		local var_4_2 = var_4_0:current_velocity()
		local var_4_3 = arg_4_2.nav_world
		local var_4_4 = arg_4_2.world
		local var_4_5 = World.physics_world(var_4_4)
		local var_4_6 = arg_4_2.navigation_extension:traverse_logic()
		local var_4_7 = LocomotionUtils.navmesh_movement_check(var_4_1, var_4_2, var_4_3, var_4_5, var_4_6)

		if var_4_7 == "navmesh_hit_wall" then
			arg_4_2.stagger_hit_wall = true
		elseif var_4_7 == "navmesh_use_mover" then
			local var_4_8 = arg_4_2.breed.override_mover_move_distance
			local var_4_9 = true

			if not var_4_0:set_movement_type("constrained_by_mover", var_4_8, var_4_9) then
				var_4_0:set_movement_type("snap_to_navmesh")

				arg_4_2.stagger_hit_wall = true
			end
		end
	end

	if arg_4_2.anim_cb_blocked_cooldown and arg_4_2.leave_blocked_at_t and arg_4_3 > arg_4_2.leave_blocked_at_t then
		return "done"
	end

	return "running"
end
