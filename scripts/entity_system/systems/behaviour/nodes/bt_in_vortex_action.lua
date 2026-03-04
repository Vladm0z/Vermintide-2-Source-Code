-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_in_vortex_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInVortexAction = class(BTInVortexAction, BTNode)

function BTInVortexAction.init(arg_1_0, ...)
	BTInVortexAction.super.init(arg_1_0, ...)
end

BTInVortexAction.name = "BTInVortexAction"

function BTInVortexAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.navigation_extension:set_enabled(false)

	local var_2_0 = arg_2_2.locomotion_extension

	var_2_0:set_movement_type("script_driven")
	var_2_0:set_wanted_rotation(nil)

	arg_2_2.in_vortex_state = "in_vortex_init"
	arg_2_2.stagger_prohibited = true
	arg_2_2.move_state = "idle"
	ScriptUnit.extension(arg_2_1, "hit_reaction_system").force_ragdoll_on_death = true

	local var_2_1 = ScriptUnit.has_extension(arg_2_1, "ai_shield_system")

	if var_2_1 then
		var_2_1:set_is_blocking(false)
	end
end

function BTInVortexAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_5 then
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false, false)
	end

	if HEALTH_ALIVE[arg_3_1] and not arg_3_5 then
		arg_3_2.locomotion_extension:set_movement_type("snap_to_navmesh")

		local var_3_0 = arg_3_2.navigation_extension

		var_3_0:set_enabled(true)
		var_3_0:reset_destination(POSITION_LOOKUP[arg_3_1] or Unit.local_position(arg_3_1, 0))

		local var_3_1 = ScriptUnit.has_extension(arg_3_1, "ai_shield_system")

		if var_3_1 then
			var_3_1:set_is_blocking(true)
		end
	end

	arg_3_2.in_vortex = false
	arg_3_2.stagger_prohibited = nil
	ScriptUnit.extension(arg_3_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

function BTInVortexAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.in_vortex_state

	if var_4_0 == "in_vortex_init" then
		if arg_4_2.umbral_leap then
			Managers.state.network:anim_event(arg_4_1, "umbral_leap")

			arg_4_2.in_vortex_state = "in_umbral_leap"

			local var_4_1 = arg_4_2.locomotion_extension

			var_4_1:set_wanted_velocity(Vector3.zero())
			var_4_1:set_movement_type("script_driven")
			var_4_1:set_affected_by_gravity(false)

			arg_4_2.umbral_leap = false
			arg_4_2.umbral_leap_jump_start = arg_4_3
		else
			Managers.state.network:anim_event(arg_4_1, "vortex_loop")

			arg_4_2.in_vortex_state = "in_vortex"
		end
	elseif var_4_0 == "in_umbral_leap" then
		if arg_4_2.umbral_leap_destination then
			ConflictUtils.teleport_ai_unit(arg_4_1, arg_4_2.umbral_leap_destination:unbox())

			arg_4_2.umbral_leap_destination = nil
			arg_4_2.in_vortex_state = "umbral_leap_landing"
		else
			local var_4_2 = arg_4_3 - arg_4_2.umbral_leap_jump_start
			local var_4_3 = 0

			if var_4_2 > 0.4 then
				var_4_3 = 9.8
			end

			arg_4_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, var_4_3))
		end
	elseif var_4_0 == "ejected_from_vortex" then
		local var_4_4 = arg_4_2.ejected_from_vortex:unbox() - Vector3(0, 0, 9.82) * arg_4_4

		arg_4_2.locomotion_extension:set_wanted_velocity(var_4_4)
		arg_4_2.ejected_from_vortex:store(var_4_4)

		local var_4_5 = Unit.mover(arg_4_1)

		if Mover.collides_down(var_4_5) then
			local var_4_6 = var_4_4 - Vector3.normalize(var_4_4) * arg_4_4

			arg_4_2.ejected_from_vortex:store(var_4_6)

			local var_4_7 = arg_4_2.nav_world
			local var_4_8 = POSITION_LOOKUP[arg_4_1]
			local var_4_9 = LocomotionUtils.pos_on_mesh(var_4_7, var_4_8, 1, 1)

			if var_4_9 == nil then
				local var_4_10 = 0.5
				local var_4_11 = 0.5
				local var_4_12 = 0.5

				var_4_9 = GwNavQueries.inside_position_from_outside_position(var_4_7, var_4_8, var_4_10, var_4_10, var_4_11, var_4_12)

				if var_4_9 == nil then
					local var_4_13 = "forced"
					local var_4_14 = Vector3(0, 0, -1)

					AiUtils.kill_unit(arg_4_1, nil, nil, var_4_13, var_4_14)

					return "failed"
				end
			end

			Unit.set_local_position(arg_4_1, 0, var_4_9)

			if not arg_4_2.breed.die_on_vortex_land then
				local var_4_15 = arg_4_2.sot_landing and "sot_landing" or "vortex_landing"

				Managers.state.network:anim_event(arg_4_1, var_4_15)
			end

			arg_4_2.in_vortex_state = "waiting_to_land"

			local var_4_16 = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
			local var_4_17 = FrameTable.alloc_table()

			var_4_16:trigger_networked_dialogue_event("landing", var_4_17)

			if arg_4_2.thornsister_vortex then
				arg_4_2.thornsister_vortex = nil
				arg_4_2.thornsister_vortex_ext = nil
			else
				LocomotionUtils.set_animation_driven_movement(arg_4_1, true, true, false)
			end
		end
	elseif var_4_0 == "umbral_leap_landing" then
		Managers.state.network:anim_event(arg_4_1, "idle")

		local var_4_18 = arg_4_2.locomotion_extension

		var_4_18:set_wanted_velocity(Vector3.zero())
		var_4_18:set_affected_by_gravity(true)
		var_4_18:set_movement_type("constrained_by_mover")

		arg_4_2.umbral_leap_velocity = nil
		arg_4_2.landing_finished = nil
		arg_4_2.in_vortex_state = "landed"
		arg_4_2.stagger = false

		return "done"
	elseif var_4_0 == "waiting_to_land" then
		if not arg_4_2.breed.die_on_vortex_land and arg_4_2.landing_finished then
			arg_4_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

			arg_4_2.landing_finished = nil
			arg_4_2.in_vortex_state = "landed"

			return "done"
		elseif arg_4_2.breed.die_on_vortex_land then
			local var_4_19 = "forced"
			local var_4_20 = Vector3(0, 0, -1)

			AiUtils.kill_unit(arg_4_1, nil, nil, var_4_19, var_4_20)
		end
	end

	return "running"
end
