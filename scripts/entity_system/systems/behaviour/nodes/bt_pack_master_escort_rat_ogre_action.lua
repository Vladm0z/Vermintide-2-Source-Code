-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_escort_rat_ogre_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterEscortRatOgreAction = class(BTPackMasterEscortRatOgreAction, BTNode)
BTPackMasterEscortRatOgreAction.name = "BTPackMasterEscortRatOgreAction"

function BTPackMasterEscortRatOgreAction.init(arg_1_0, ...)
	BTPackMasterEscortRatOgreAction.super.init(arg_1_0, ...)
end

function BTPackMasterEscortRatOgreAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)
	Managers.state.network:anim_event(arg_2_1, "combat_walk")
	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.walk_speed)
	arg_2_2.locomotion_extension:set_rotation_speed(5)

	arg_2_2.attack_cooldown = arg_2_2.attack_cooldown or 0
end

function BTPackMasterEscortRatOgreAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	Managers.state.network:anim_event(arg_3_1, "move_fwd")
end

function BTPackMasterEscortRatOgreAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.my_escort_slot

	if not var_4_0 then
		return "running"
	end

	if arg_4_2.escorting_wait_for_rat_ogre then
		if BLACKBOARDS[var_4_0.ogre].wait_for_ogre then
			return "running"
		else
			arg_4_2.escorting_wait_for_rat_ogre = false

			Managers.state.network:anim_event(arg_4_1, "combat_walk")
		end
	end

	local var_4_1 = var_4_0.ogre
	local var_4_2 = POSITION_LOOKUP[var_4_1]
	local var_4_3 = Unit.local_rotation(var_4_1, 0)
	local var_4_4 = Quaternion.forward(var_4_3)
	local var_4_5 = Vector3.normalize(Vector3.cross(var_4_4, Vector3.up()))
	local var_4_6 = var_4_2 + var_4_4 * 4 + var_4_5 * var_4_0.side_offset
	local var_4_7, var_4_8 = GwNavQueries.raycast(arg_4_2.nav_world, var_4_2, var_4_6)

	if var_4_7 then
		arg_4_2.navigation_extension:move_to(var_4_6)
	elseif var_4_8 then
		arg_4_2.navigation_extension:move_to(var_4_8)
	end

	local var_4_9 = BLACKBOARDS[var_4_0.ogre]

	if var_4_9.is_angry or arg_4_2.previous_attacker or not HEALTH_ALIVE[var_4_1] then
		local var_4_10 = arg_4_2.breed

		ScriptUnit.extension(arg_4_1, "ai_system"):set_perception(var_4_10.perception, var_4_10.target_selection)

		arg_4_2.escorting_rat_ogre = false
		arg_4_2.far_off_despawn_immunity = false

		if arg_4_2.previous_attacker then
			var_4_9.is_angry = true
			var_4_9.previous_attacker = arg_4_2.previous_attacker
		end
	elseif var_4_9.wait_for_ogre then
		arg_4_2.escorting_wait_for_rat_ogre = true

		Managers.state.network:anim_event(arg_4_1, "idle")
		arg_4_2.navigation_extension:stop()
	end

	return "running"
end
