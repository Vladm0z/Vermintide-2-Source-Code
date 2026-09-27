-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_spawning_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSpawningAction = class(BTSpawningAction, BTNode)

BTSpawningAction.init = function (arg_1_0, ...)
	-- function 1
	BTSpawningAction.super.init(arg_1_0, ...)
end

BTSpawningAction.name = "BTSpawningAction"

local alive = Unit.alive

BTSpawningAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	Unit.set_animation_root_mode(arg_2_1, "ignore")
	self:_apply_anim_varations(arg_2_1)

	local breed = arg_2_2.breed
	local uses_spawn_animation

	if arg_2_2.spawn_type ~= "horde" then
		uses_spawn_animation = breed.uses_spawn_animation

		if not uses_spawn_animation then
			uses_spawn_animation = arg_2_2.spawn_animation_override
		end

		if false then
			uses_spawn_animation = false
		end
	else
		uses_spawn_animation = true
	end

	arg_2_2.uses_spawn_animation = uses_spawn_animation

	if not arg_2_2.uses_spawn_animation then
		local num = 1 / ScriptUnit.extension(arg_2_1, "ai_system"):size_variation()

		LocomotionUtils.set_animation_translation_scale(arg_2_1, Vector3(num, num, num))

		local locomotion_extension = arg_2_2.locomotion_extension

		locomotion_extension:use_lerp_rotation(false)
		locomotion_extension:set_movement_type("script_driven")
		LocomotionUtils.set_animation_driven_movement(arg_2_1, true)
	else
		arg_2_2.spawning_finished = true
	end

	local network = Managers.state.network
	local wield_inventory_on_spawn = breed.wield_inventory_on_spawn

	if arg_2_2.spawn_type == "horde" or arg_2_2.spawn_type == "horde_hidden" or not wield_inventory_on_spawn or not ScriptUnit.has_extension(arg_2_1, "ai_inventory_system") then
		local unit_game_object_id = network:unit_game_object_id(arg_2_1)

		network.network_transmit:send_rpc_all("rpc_ai_inventory_wield", unit_game_object_id, 1)
	end

	local spawn_animation = arg_2_2.spawn_animation

	if not spawn_animation then
		spawn_animation = breed.default_spawn_animation
		spawn_animation = spawn_animation or "idle"
	end

	if type(spawn_animation) == "table" then
		spawn_animation = spawn_animation[Math.random(1, #spawn_animation)]
	end

	if spawn_animation == "to_combat" then
		AiUtils.enter_combat(arg_2_1, arg_2_2)
	elseif spawn_animation == "to_passive" then
		AiUtils.enter_passive(arg_2_1, arg_2_2)
	elseif not spawn_animation then
		network:anim_event(arg_2_1, spawn_animation)
	end

	arg_2_2.spawn_last_pos = Vector3Box(POSITION_LOOKUP[arg_2_1])
	arg_2_2.spawn_immovable_time = 0

	self:_play_spawning_effect(arg_2_1)
end

BTSpawningAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.spawn = nil
	arg_3_2.spawning_finished = nil
	arg_3_2.spawn_last_pos = nil
	arg_3_2.fallback_landing_t = nil
	arg_3_2.spawn_animation_override = nil
	arg_3_2.spawn_exit_time = nil

	arg_3_2.navigation_extension:init_position()

	if not ((arg_3_2.uses_spawn_animation or arg_3_2.spawn_type == "horde_hidden") and arg_3_5 or arg_3_2.about_to_be_destroyed) then
		ScriptUnit.extension(arg_3_1, "ai_system"):force_enemy_detection(arg_3_3)

		if not alive(arg_3_2.target_unit) then
			Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, true)
		else
			arg_3_2.target_unit = nil
		end
	end

	if not arg_3_5 then
		local locomotion_extension = arg_3_2.locomotion_extension

		locomotion_extension:set_movement_type("snap_to_navmesh")

		if not arg_3_2.uses_spawn_animation then
			locomotion_extension:use_lerp_rotation(true)
			LocomotionUtils.set_animation_driven_movement(arg_3_1, false)

			arg_3_2.spawn_landing_state = nil
			arg_3_2.jump_climb_finished = nil
		end

		if not arg_3_2.constrained_on_client then
			arg_3_2.constrained_on_client = nil

			LocomotionUtils.constrain_on_clients(arg_3_1, false)
		end

		LocomotionUtils.set_animation_translation_scale(arg_3_1, Vector3(1, 1, 1))

		if not arg_3_2.optional_spawn_data and not arg_3_2.optional_spawn_data.horde_ability_caller_peer_id then
			local system = Managers.state.entity:system("versus_horde_ability_system")
			local go_id = Managers.state.unit_storage:go_id(arg_3_1)

			system:server_register_horde_unit(go_id, arg_3_2.optional_spawn_data.horde_ability_caller_peer_id)
		end
	end
end

BTSpawningAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local breed = arg_4_2.breed

	if not breed.interrupt_spawning_on_stagger and not arg_4_2.stagger then
		arg_4_2.spawning_finished = true
	end

	if not (not breed.interrupt_spawning_on_health_percentage and not (ScriptUnit.extension(arg_4_1, "health_system"):current_health_percent() < breed.interrupt_spawning_on_health_percentage)) then
		arg_4_2.spawning_finished = true
	end

	local locomotion_extension = arg_4_2.locomotion_extension
	local spawning_finished = arg_4_2.spawning_finished
	local flag

	flag = arg_4_2.spawn_exit_time or not true or arg_4_3 > arg_4_2.spawn_exit_time

	local nav_world = arg_4_2.nav_world
	local var_4_5 = POSITION_LOOKUP[arg_4_1]

	if not spawning_finished and not flag then
		if not arg_4_2.instant_spawn then
			return "done"
		elseif not arg_4_2.spawn_landing_state then
			local triangle_from_position, var_4_7 = GwNavQueries.triangle_from_position(nav_world, var_4_5, 0.5, 0.5)

			if not triangle_from_position then
				local var_4_8 = Vector3(var_4_5.x, var_4_5.y, var_4_7)
				local network = Managers.state.network
				local unit_game_object_id = network:unit_game_object_id(arg_4_1)

				network.network_transmit:send_rpc_clients("rpc_teleport_unit_to", unit_game_object_id, var_4_8, Unit.local_rotation(arg_4_1, 0))
				locomotion_extension:teleport_to(var_4_8)

				return "done"
			else
				locomotion_extension:set_affected_by_gravity(true)
				locomotion_extension:set_movement_type("script_driven")

				arg_4_2.spawn_landing_state = "falling"

				local triangle_from_position_2, var_4_12 = GwNavQueries.triangle_from_position(nav_world, var_4_5, 0, 20)
				local var_4_13 = var_4_12

				if not triangle_from_position_2 then
					local var_4_14 = Vector3(var_4_5.x, var_4_5.y, var_4_13)

					LocomotionUtils.constrain_on_clients(arg_4_1, true, var_4_14, var_4_5)

					arg_4_2.constrained_on_client = true
					arg_4_2.landing_destination = Vector3Box(var_4_5.x, var_4_5.y, var_4_13)

					if not arg_4_2.spawn_animation then
						Managers.state.network:anim_event(arg_4_1, "idle")
					end
				else
					local str = "forced"
					local var_4_16 = Vector3(0, 0, -1)

					AiUtils.kill_unit(arg_4_1, nil, nil, str, var_4_16)

					return
				end
			end
		end
	end

	if arg_4_2.spawn_landing_state == "falling" then
		local z = locomotion_extension:current_velocity().z
		local unbox = arg_4_2.landing_destination:unbox()

		if var_4_5.z + z * arg_4_4 * 2 < unbox.z then
			local network_2 = Managers.state.network
			local unit_game_object_id_2 = network_2:unit_game_object_id(arg_4_1)

			network_2.network_transmit:send_rpc_clients("rpc_teleport_unit_to", unit_game_object_id_2, unbox, Unit.local_rotation(arg_4_1, 0))
			locomotion_extension:teleport_to(unbox)
			locomotion_extension:set_movement_type("snap_to_navmesh")

			if not arg_4_2.spawn_animation then
				LocomotionUtils.set_animation_driven_movement(arg_4_1, true, false, false)
				Managers.state.network:anim_event(arg_4_1, "jump_down_land")

				arg_4_2.spawn_landing_state = "landing"
				arg_4_2.fallback_landing_t = arg_4_3 + 5
			else
				return "done"
			end
		end
	elseif not (arg_4_2.spawn_landing_state ~= "landing" or arg_4_2.jump_climb_finished or not (arg_4_3 > arg_4_2.fallback_landing_t)) then
		return "done"
	end

	return "running"
end

local tbl = {
	int = "rpc_anim_set_variable_int",
	float = "rpc_anim_set_variable_float"
}

BTSpawningAction._apply_anim_varations = function (self, arg_5_1)
	-- function 5
	local action_data = self._tree_node.action_data

	if not action_data then
		local incrementing_anim_variations = action_data.incrementing_anim_variations

		if not incrementing_anim_variations then
			local go_id = Managers.state.unit_storage:go_id(arg_5_1)
			local network_transmit = Managers.state.network.network_transmit

			for i = 1, #incrementing_anim_variations do
				local var_5_4 = incrementing_anim_variations[i]

				if not Unit.animation_has_variable(arg_5_1, var_5_4.name) then
					local min = var_5_4.min
					local max = var_5_4.max
					local value = var_5_4.value

					value = value or math.random(min, max)
					var_5_4.value = math.wrap_index_between(value + 1, min, max)

					local animation_find_variable = Unit.animation_find_variable(arg_5_1, var_5_4.name)

					Unit.animation_set_variable(arg_5_1, animation_find_variable, value)

					local var_5_9 = tbl[var_5_4.value_type]
					local var_5_10 = NetworkLookup.anims[var_5_4.name]

					network_transmit:send_rpc_server(var_5_9, go_id, var_5_10, value)
				end
			end
		end
	end
end

BTSpawningAction._play_spawning_effect = function (self, arg_6_1)
	-- function 6
	local action_data = self._tree_node.action_data
	local flag = not action_data and action_data.spawning_effect

	if not flag then
		local var_6_2 = NetworkLookup.effects[flag]
		local network = Managers.state.network
		local num = 0
		local identity = Quaternion.identity()

		network:rpc_play_particle_effect(nil, var_6_2, NetworkConstants.invalid_game_object_id, num, Unit.local_position(arg_6_1, 0), identity, false)
	end
end
