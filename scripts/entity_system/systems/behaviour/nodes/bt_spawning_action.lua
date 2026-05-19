-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_spawning_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSpawningAction = class(BTSpawningAction, BTNode)

function BTSpawningAction.init(arg_1_0, ...)
	BTSpawningAction.super.init(arg_1_0, ...)
end

BTSpawningAction.name = "BTSpawningAction"

local var_0_0 = Unit.alive

function BTSpawningAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	Unit.set_animation_root_mode(arg_2_1, "ignore")
	arg_2_0:_apply_anim_varations(arg_2_1)

	local var_2_0 = arg_2_2.breed

	arg_2_2.uses_spawn_animation = arg_2_2.spawn_type == "horde" or var_2_0.uses_spawn_animation or arg_2_2.spawn_animation_override

	if arg_2_2.uses_spawn_animation then
		local var_2_1 = 1 / ScriptUnit.extension(arg_2_1, "ai_system"):size_variation()

		LocomotionUtils.set_animation_translation_scale(arg_2_1, Vector3(var_2_1, var_2_1, var_2_1))

		local var_2_2 = arg_2_2.locomotion_extension

		var_2_2:use_lerp_rotation(false)
		var_2_2:set_movement_type("script_driven")
		LocomotionUtils.set_animation_driven_movement(arg_2_1, true)
	else
		arg_2_2.spawning_finished = true
	end

	local var_2_3 = Managers.state.network
	local var_2_4 = var_2_0.wield_inventory_on_spawn

	if (arg_2_2.spawn_type == "horde" or arg_2_2.spawn_type == "horde_hidden" or var_2_4) and ScriptUnit.has_extension(arg_2_1, "ai_inventory_system") then
		local var_2_5 = var_2_3:unit_game_object_id(arg_2_1)

		var_2_3.network_transmit:send_rpc_all("rpc_ai_inventory_wield", var_2_5, 1)
	end

	local var_2_6 = arg_2_2.spawn_animation or var_2_0.default_spawn_animation or "idle"

	if type(var_2_6) == "table" then
		var_2_6 = var_2_6[Math.random(1, #var_2_6)]
	end

	if var_2_6 == "to_combat" then
		AiUtils.enter_combat(arg_2_1, arg_2_2)
	elseif var_2_6 == "to_passive" then
		AiUtils.enter_passive(arg_2_1, arg_2_2)
	elseif var_2_6 then
		var_2_3:anim_event(arg_2_1, var_2_6)
	end

	arg_2_2.spawn_last_pos = Vector3Box(POSITION_LOOKUP[arg_2_1])
	arg_2_2.spawn_immovable_time = 0

	arg_2_0:_play_spawning_effect(arg_2_1)
end

function BTSpawningAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.spawn = nil
	arg_3_2.spawning_finished = nil
	arg_3_2.spawn_last_pos = nil
	arg_3_2.fallback_landing_t = nil
	arg_3_2.spawn_animation_override = nil
	arg_3_2.spawn_exit_time = nil

	arg_3_2.navigation_extension:init_position()

	if (arg_3_2.uses_spawn_animation or arg_3_2.spawn_type == "horde_hidden") and not arg_3_5 and not arg_3_2.about_to_be_destroyed then
		ScriptUnit.extension(arg_3_1, "ai_system"):force_enemy_detection(arg_3_3)

		if var_0_0(arg_3_2.target_unit) then
			Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, true)
		else
			arg_3_2.target_unit = nil
		end
	end

	if not arg_3_5 then
		local var_3_0 = arg_3_2.locomotion_extension

		var_3_0:set_movement_type("snap_to_navmesh")

		if arg_3_2.uses_spawn_animation then
			var_3_0:use_lerp_rotation(true)
			LocomotionUtils.set_animation_driven_movement(arg_3_1, false)

			arg_3_2.spawn_landing_state = nil
			arg_3_2.jump_climb_finished = nil
		end

		if arg_3_2.constrained_on_client then
			arg_3_2.constrained_on_client = nil

			LocomotionUtils.constrain_on_clients(arg_3_1, false)
		end

		LocomotionUtils.set_animation_translation_scale(arg_3_1, Vector3(1, 1, 1))

		if arg_3_2.optional_spawn_data and arg_3_2.optional_spawn_data.horde_ability_caller_peer_id then
			local var_3_1 = Managers.state.entity:system("versus_horde_ability_system")
			local var_3_2 = Managers.state.unit_storage:go_id(arg_3_1)

			var_3_1:server_register_horde_unit(var_3_2, arg_3_2.optional_spawn_data.horde_ability_caller_peer_id)
		end
	end
end

function BTSpawningAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.breed

	if var_4_0.interrupt_spawning_on_stagger and arg_4_2.stagger then
		arg_4_2.spawning_finished = true
	end

	if var_4_0.interrupt_spawning_on_health_percentage and ScriptUnit.extension(arg_4_1, "health_system"):current_health_percent() < var_4_0.interrupt_spawning_on_health_percentage then
		arg_4_2.spawning_finished = true
	end

	local var_4_1 = arg_4_2.locomotion_extension
	local var_4_2 = arg_4_2.spawning_finished
	local var_4_3 = not arg_4_2.spawn_exit_time and true or arg_4_3 > arg_4_2.spawn_exit_time
	local var_4_4 = arg_4_2.nav_world
	local var_4_5 = POSITION_LOOKUP[arg_4_1]

	if var_4_2 and var_4_3 then
		if arg_4_2.instant_spawn then
			return "done"
		elseif not arg_4_2.spawn_landing_state then
			local var_4_6, var_4_7 = GwNavQueries.triangle_from_position(var_4_4, var_4_5, 0.5, 0.5)

			if var_4_6 then
				local var_4_8 = Vector3(var_4_5.x, var_4_5.y, var_4_7)
				local var_4_9 = Managers.state.network
				local var_4_10 = var_4_9:unit_game_object_id(arg_4_1)

				var_4_9.network_transmit:send_rpc_clients("rpc_teleport_unit_to", var_4_10, var_4_8, Unit.local_rotation(arg_4_1, 0))
				var_4_1:teleport_to(var_4_8)

				return "done"
			else
				var_4_1:set_affected_by_gravity(true)
				var_4_1:set_movement_type("script_driven")

				arg_4_2.spawn_landing_state = "falling"

				local var_4_11, var_4_12 = GwNavQueries.triangle_from_position(var_4_4, var_4_5, 0, 20)
				local var_4_13 = var_4_12

				if var_4_11 then
					local var_4_14 = Vector3(var_4_5.x, var_4_5.y, var_4_13)

					LocomotionUtils.constrain_on_clients(arg_4_1, true, var_4_14, var_4_5)

					arg_4_2.constrained_on_client = true
					arg_4_2.landing_destination = Vector3Box(var_4_5.x, var_4_5.y, var_4_13)

					if not arg_4_2.spawn_animation then
						Managers.state.network:anim_event(arg_4_1, "idle")
					end
				else
					local var_4_15 = "forced"
					local var_4_16 = Vector3(0, 0, -1)

					AiUtils.kill_unit(arg_4_1, nil, nil, var_4_15, var_4_16)

					return
				end
			end
		end
	end

	if arg_4_2.spawn_landing_state == "falling" then
		local var_4_17 = var_4_1:current_velocity().z
		local var_4_18 = arg_4_2.landing_destination:unbox()

		if var_4_5.z + var_4_17 * arg_4_4 * 2 < var_4_18.z then
			local var_4_19 = Managers.state.network
			local var_4_20 = var_4_19:unit_game_object_id(arg_4_1)

			var_4_19.network_transmit:send_rpc_clients("rpc_teleport_unit_to", var_4_20, var_4_18, Unit.local_rotation(arg_4_1, 0))
			var_4_1:teleport_to(var_4_18)
			var_4_1:set_movement_type("snap_to_navmesh")

			if arg_4_2.spawn_animation then
				LocomotionUtils.set_animation_driven_movement(arg_4_1, true, false, false)
				Managers.state.network:anim_event(arg_4_1, "jump_down_land")

				arg_4_2.spawn_landing_state = "landing"
				arg_4_2.fallback_landing_t = arg_4_3 + 5
			else
				return "done"
			end
		end
	elseif arg_4_2.spawn_landing_state == "landing" and (arg_4_2.jump_climb_finished or arg_4_3 > arg_4_2.fallback_landing_t) then
		return "done"
	end

	return "running"
end

local var_0_1 = {
	int = "rpc_anim_set_variable_int",
	float = "rpc_anim_set_variable_float"
}

function BTSpawningAction._apply_anim_varations(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._tree_node.action_data

	if var_5_0 then
		local var_5_1 = var_5_0.incrementing_anim_variations

		if var_5_1 then
			local var_5_2 = Managers.state.unit_storage:go_id(arg_5_1)
			local var_5_3 = Managers.state.network.network_transmit

			for iter_5_0 = 1, #var_5_1 do
				local var_5_4 = var_5_1[iter_5_0]

				if Unit.animation_has_variable(arg_5_1, var_5_4.name) then
					local var_5_5 = var_5_4.min
					local var_5_6 = var_5_4.max
					local var_5_7 = var_5_4.value or math.random(var_5_5, var_5_6)

					var_5_4.value = math.wrap_index_between(var_5_7 + 1, var_5_5, var_5_6)

					local var_5_8 = Unit.animation_find_variable(arg_5_1, var_5_4.name)

					Unit.animation_set_variable(arg_5_1, var_5_8, var_5_7)

					local var_5_9 = var_0_1[var_5_4.value_type]
					local var_5_10 = NetworkLookup.anims[var_5_4.name]

					var_5_3:send_rpc_server(var_5_9, var_5_2, var_5_10, var_5_7)
				end
			end
		end
	end
end

function BTSpawningAction._play_spawning_effect(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._tree_node.action_data
	local var_6_1 = var_6_0 and var_6_0.spawning_effect

	if var_6_1 then
		local var_6_2 = NetworkLookup.effects[var_6_1]
		local var_6_3 = Managers.state.network
		local var_6_4 = 0
		local var_6_5 = Quaternion.identity()

		var_6_3:rpc_play_particle_effect(nil, var_6_2, NetworkConstants.invalid_game_object_id, var_6_4, Unit.local_position(arg_6_1, 0), var_6_5, false)
	end
end
