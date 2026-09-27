-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_escort_rat_ogre_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterEscortRatOgreAction = class(BTPackMasterEscortRatOgreAction, BTNode)
BTPackMasterEscortRatOgreAction.name = "BTPackMasterEscortRatOgreAction"

BTPackMasterEscortRatOgreAction.init = function (arg_1_0, ...)
	-- function 1
	BTPackMasterEscortRatOgreAction.super.init(arg_1_0, ...)
end

BTPackMasterEscortRatOgreAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)
	Managers.state.network:anim_event(arg_2_1, "combat_walk")
	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.walk_speed)
	arg_2_2.locomotion_extension:set_rotation_speed(5)

	local attack_cooldown = arg_2_2.attack_cooldown

	attack_cooldown = attack_cooldown or 0
	arg_2_2.attack_cooldown = attack_cooldown
end

BTPackMasterEscortRatOgreAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	Managers.state.network:anim_event(arg_3_1, "move_fwd")
end

BTPackMasterEscortRatOgreAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local my_escort_slot = arg_4_2.my_escort_slot

	if not my_escort_slot then
		return "running"
	end

	if not arg_4_2.escorting_wait_for_rat_ogre then
		if not BLACKBOARDS[my_escort_slot.ogre].wait_for_ogre then
			return "running"
		else
			arg_4_2.escorting_wait_for_rat_ogre = false

			Managers.state.network:anim_event(arg_4_1, "combat_walk")
		end
	end

	local ogre = my_escort_slot.ogre
	local var_4_2 = POSITION_LOOKUP[ogre]
	local local_rotation = Unit.local_rotation(ogre, 0)
	local forward = Quaternion.forward(local_rotation)
	local normalize = Vector3.normalize(Vector3.cross(forward, Vector3.up()))
	local num = var_4_2 + forward * 4 + normalize * my_escort_slot.side_offset
	local raycast, var_4_8 = GwNavQueries.raycast(arg_4_2.nav_world, var_4_2, num)

	if not raycast then
		arg_4_2.navigation_extension:move_to(num)
	elseif not var_4_8 then
		arg_4_2.navigation_extension:move_to(var_4_8)
	end

	local var_4_9 = BLACKBOARDS[my_escort_slot.ogre]

	if not (var_4_9.is_angry or arg_4_2.previous_attacker or HEALTH_ALIVE[ogre]) then
		local breed = arg_4_2.breed

		ScriptUnit.extension(arg_4_1, "ai_system"):set_perception(breed.perception, breed.target_selection)

		arg_4_2.escorting_rat_ogre = false
		arg_4_2.far_off_despawn_immunity = false

		if not arg_4_2.previous_attacker then
			var_4_9.is_angry = true
			var_4_9.previous_attacker = arg_4_2.previous_attacker
		end
	elseif not var_4_9.wait_for_ogre then
		arg_4_2.escorting_wait_for_rat_ogre = true

		Managers.state.network:anim_event(arg_4_1, "idle")
		arg_4_2.navigation_extension:stop()
	end

	return "running"
end
