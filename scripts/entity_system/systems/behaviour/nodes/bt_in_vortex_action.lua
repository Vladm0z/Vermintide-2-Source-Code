-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_in_vortex_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInVortexAction = class(BTInVortexAction, BTNode)

BTInVortexAction.init = function (arg_1_0, ...)
	-- function 1
	BTInVortexAction.super.init(arg_1_0, ...)
end

BTInVortexAction.name = "BTInVortexAction"

BTInVortexAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.navigation_extension:set_enabled(false)

	local locomotion_extension = arg_2_2.locomotion_extension

	locomotion_extension:set_movement_type("script_driven")
	locomotion_extension:set_wanted_rotation(nil)

	arg_2_2.in_vortex_state = "in_vortex_init"
	arg_2_2.stagger_prohibited = true
	arg_2_2.move_state = "idle"
	ScriptUnit.extension(arg_2_1, "hit_reaction_system").force_ragdoll_on_death = true

	local has_extension = ScriptUnit.has_extension(arg_2_1, "ai_shield_system")

	if not has_extension then
		has_extension:set_is_blocking(false)
	end
end

BTInVortexAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not arg_3_5 then
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false, false)
	end

	if not (not HEALTH_ALIVE[arg_3_1] and arg_3_5) then
		arg_3_2.locomotion_extension:set_movement_type("snap_to_navmesh")

		local navigation_extension = arg_3_2.navigation_extension

		navigation_extension:set_enabled(true)

		local var_3_1 = navigation_extension
		local reset_destination = navigation_extension.reset_destination
		local var_3_3 = POSITION_LOOKUP[arg_3_1]

		var_3_3 = var_3_3 or Unit.local_position(arg_3_1, 0)

		reset_destination(var_3_1, var_3_3)

		local has_extension = ScriptUnit.has_extension(arg_3_1, "ai_shield_system")

		if not has_extension then
			has_extension:set_is_blocking(true)
		end
	end

	arg_3_2.in_vortex = false
	arg_3_2.stagger_prohibited = nil
	ScriptUnit.extension(arg_3_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

BTInVortexAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local in_vortex_state = arg_4_2.in_vortex_state

	if in_vortex_state == "in_vortex_init" then
		if not arg_4_2.umbral_leap then
			Managers.state.network:anim_event(arg_4_1, "umbral_leap")

			arg_4_2.in_vortex_state = "in_umbral_leap"

			local locomotion_extension = arg_4_2.locomotion_extension

			locomotion_extension:set_wanted_velocity(Vector3.zero())
			locomotion_extension:set_movement_type("script_driven")
			locomotion_extension:set_affected_by_gravity(false)

			arg_4_2.umbral_leap = false
			arg_4_2.umbral_leap_jump_start = arg_4_3
		else
			Managers.state.network:anim_event(arg_4_1, "vortex_loop")

			arg_4_2.in_vortex_state = "in_vortex"
		end
	elseif in_vortex_state == "in_umbral_leap" then
		if not arg_4_2.umbral_leap_destination then
			ConflictUtils.teleport_ai_unit(arg_4_1, arg_4_2.umbral_leap_destination:unbox())

			arg_4_2.umbral_leap_destination = nil
			arg_4_2.in_vortex_state = "umbral_leap_landing"
		else
			local num = arg_4_3 - arg_4_2.umbral_leap_jump_start
			local num_2 = 0

			if num > 0.4 then
				num_2 = 9.8
			end

			arg_4_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, num_2))
		end
	elseif in_vortex_state == "ejected_from_vortex" then
		local num_3 = arg_4_2.ejected_from_vortex:unbox() - Vector3(0, 0, 9.82) * arg_4_4

		arg_4_2.locomotion_extension:set_wanted_velocity(num_3)
		arg_4_2.ejected_from_vortex:store(num_3)

		local mover = Unit.mover(arg_4_1)

		if not Mover.collides_down(mover) then
			local num_4 = num_3 - Vector3.normalize(num_3) * arg_4_4

			arg_4_2.ejected_from_vortex:store(num_4)

			local nav_world = arg_4_2.nav_world
			local var_4_8 = POSITION_LOOKUP[arg_4_1]
			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_4_8, 1, 1)

			if pos_on_mesh == nil then
				local num_5 = 0.5
				local num_6 = 0.5
				local num_7 = 0.5

				pos_on_mesh = GwNavQueries.inside_position_from_outside_position(nav_world, var_4_8, num_5, num_5, num_6, num_7)

				if pos_on_mesh == nil then
					local str = "forced"
					local var_4_14 = Vector3(0, 0, -1)

					AiUtils.kill_unit(arg_4_1, nil, nil, str, var_4_14)

					return "failed"
				end
			end

			Unit.set_local_position(arg_4_1, 0, pos_on_mesh)

			if not arg_4_2.breed.die_on_vortex_land then
				local flag

				flag = not arg_4_2.sot_landing and "sot_landing" and "vortex_landing"

				Managers.state.network:anim_event(arg_4_1, flag)
			end

			arg_4_2.in_vortex_state = "waiting_to_land"

			local extension_input = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_networked_dialogue_event("landing", alloc_table)

			if not arg_4_2.thornsister_vortex then
				arg_4_2.thornsister_vortex = nil
				arg_4_2.thornsister_vortex_ext = nil
			else
				LocomotionUtils.set_animation_driven_movement(arg_4_1, true, true, false)
			end
		end
	elseif in_vortex_state == "umbral_leap_landing" then
		Managers.state.network:anim_event(arg_4_1, "idle")

		local locomotion_extension_2 = arg_4_2.locomotion_extension

		locomotion_extension_2:set_wanted_velocity(Vector3.zero())
		locomotion_extension_2:set_affected_by_gravity(true)
		locomotion_extension_2:set_movement_type("constrained_by_mover")

		arg_4_2.umbral_leap_velocity = nil
		arg_4_2.landing_finished = nil
		arg_4_2.in_vortex_state = "landed"
		arg_4_2.stagger = false

		return "done"
	elseif in_vortex_state == "waiting_to_land" then
		if arg_4_2.breed.die_on_vortex_land or not arg_4_2.landing_finished then
			arg_4_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

			arg_4_2.landing_finished = nil
			arg_4_2.in_vortex_state = "landed"

			return "done"
		elseif not arg_4_2.breed.die_on_vortex_land then
			local str_2 = "forced"
			local var_4_20 = Vector3(0, 0, -1)

			AiUtils.kill_unit(arg_4_1, nil, nil, str_2, var_4_20)
		end
	end

	return "running"
end
