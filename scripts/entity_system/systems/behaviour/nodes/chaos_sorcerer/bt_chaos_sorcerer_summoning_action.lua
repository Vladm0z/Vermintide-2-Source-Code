-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_summoning_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererSummoningAction = class(BTChaosSorcererSummoningAction, BTNode)

BTChaosSorcererSummoningAction.init = function (arg_1_0, ...)
	BTChaosSorcererSummoningAction.super.init(arg_1_0, ...)
end

BTChaosSorcererSummoningAction.name = "BTChaosSorcererSummoningAction"

BTChaosSorcererSummoningAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.attack_finished = false

	local var_2_1 = arg_2_2.vortex_data

	if var_2_0.vortex_template_name then
		var_2_1.vortex_template = VortexTemplates[var_2_0.vortex_template_name]
	end

	local var_2_2 = arg_2_2.target_unit

	arg_2_2.target_position = var_2_2 and Vector3Box(POSITION_LOOKUP[var_2_2]) or Vector3Box()
	arg_2_2.spell_count = arg_2_2.spell_count or 0

	if not var_2_0.is_spawner then
		arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
		arg_2_2.navigation_extension:set_enabled(false)

		local var_2_3 = var_2_0.attack_anim

		if var_2_3 then
			Managers.state.network:anim_event(arg_2_1, var_2_3)
		end

		local var_2_4 = var_2_0.init_func_name

		if var_2_4 then
			arg_2_0[var_2_4](arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		end

		arg_2_2.move_state = "attacking"
		arg_2_2.summon_target_unit = var_2_2
		arg_2_2.summoning = true
	end

	if arg_2_2.breed.summon_sound_event then
		arg_2_0:trigger_summon_sound(arg_2_1, arg_2_2, arg_2_3)
	end
end

BTChaosSorcererSummoningAction.trigger_summon_sound = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_2.breed
	local var_3_1 = Managers.state.network
	local var_3_2 = var_3_0.summon_sound_event
	local var_3_3 = var_3_0.no_summon_sound_for_target
	local var_3_4 = Managers.player
	local var_3_5 = arg_3_2.target_unit
	local var_3_6 = var_3_4:unit_owner(var_3_5)
	local var_3_7 = ScriptUnit.has_extension_input(arg_3_1, "dialogue_system")
	local var_3_8 = Managers.state.entity:system("audio_system")
	local var_3_9 = NetworkUnit.game_object_id(arg_3_1)
	local var_3_10 = NetworkLookup.sound_events[var_3_2]

	if var_3_3 then
		if not var_3_6.local_player then
			var_3_7:play_voice(var_3_2, true)
		end

		var_3_1.network_transmit:send_rpc_clients_except("rpc_server_audio_unit_dialogue_event", var_3_6.peer_id, var_3_10, var_3_9, 0)
	else
		var_3_7:play_voice(var_3_2, true)
		var_3_1.network_transmit:send_rpc_clients("rpc_server_audio_unit_dialogue_event", var_3_10, var_3_9, 0)
	end
end

BTChaosSorcererSummoningAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_2.action

	if not var_4_0.is_spawner then
		arg_4_2.navigation_extension:set_enabled(true)

		local var_4_1 = var_4_0.cleanup_func_name

		if var_4_1 then
			arg_4_0[var_4_1](arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		end
	end

	arg_4_2.action = nil
	arg_4_2.attack_finished = false
	arg_4_2.summoning = nil
	arg_4_2.summoning_unit = nil
	arg_4_2.summon_target_unit = nil
	arg_4_2.ready_to_summon = false
	arg_4_2.summoning_finished = nil

	QuickDrawerStay:reset()
end

BTChaosSorcererSummoningAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.action
	local var_5_1 = arg_5_2.summon_target_unit

	if Unit.alive(var_5_1) then
		local var_5_2 = ScriptUnit.has_extension(var_5_1, "status_system")

		if var_5_2 and not var_5_2:is_invisible() and not var_5_2:get_is_dodging() and not var_5_0.use_first_position then
			arg_5_2.target_position:store(POSITION_LOOKUP[var_5_1])
		end

		if arg_5_2.face_target_while_summoning then
			local var_5_3 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, var_5_1)

			arg_5_2.locomotion_extension:set_wanted_rotation(var_5_3)
		end
	end

	if not var_5_0.ignore_attack_finished then
		if arg_5_2.attack_finished then
			arg_5_2.ready_to_summon = false

			return "done"
		elseif arg_5_2.summoning_finished then
			local var_5_4 = arg_5_2.target_position:unbox()
			local var_5_5 = arg_5_0[var_5_0.spawn_func_name](arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, var_5_4, arg_5_2.current_spell)

			arg_5_2.spell_count = arg_5_2.spell_count + 1
			arg_5_2.summoning_finished = nil

			if not var_5_5 then
				return "done"
			end
		end
	end

	local var_5_6 = var_5_0.update_func_name

	if var_5_6 and arg_5_0[var_5_6](arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4) then
		arg_5_2.summoning_finished = nil

		return "done"
	end

	return "running"
end

BTChaosSorcererSummoningAction.spawn_exalted_spell = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_2.current_spell

	var_6_0.spawn_function(arg_6_0, arg_6_2, arg_6_3, arg_6_4, arg_6_5, var_6_0)
end

local var_0_0 = 0.25

BTChaosSorcererSummoningAction._start_vortex_summoning = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2.world
	local var_7_1 = arg_7_2.action
	local var_7_2 = arg_7_2.vortex_data
	local var_7_3 = var_7_2.vortex_template
	local var_7_4 = var_7_2.vortex_spawn_pos:unbox()
	local var_7_5 = var_7_3.max_height
	local var_7_6 = var_7_2.vortex_spawn_radius
	local var_7_7 = math.min(var_7_6 / var_7_3.full_inner_radius, 1)

	if Managers.player.is_server then
		local var_7_8 = var_7_1.inner_decal_unit_name

		if var_7_8 then
			local var_7_9 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_7_4)
			local var_7_10 = math.max(var_7_3.min_inner_radius, var_7_7 * var_7_3.full_inner_radius)

			Matrix4x4.set_scale(var_7_9, Vector3(var_7_10, var_7_10, var_7_10))

			var_7_2.inner_decal_unit = Managers.state.unit_spawner:spawn_network_unit(var_7_8, "network_synched_dummy_unit", nil, var_7_9)
		end

		local var_7_11 = var_7_1.outer_decal_unit_name

		if var_7_11 then
			local var_7_12 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_7_4)
			local var_7_13 = math.max(var_7_3.min_outer_radius, var_7_7 * var_7_3.full_outer_radius)

			Matrix4x4.set_scale(var_7_12, Vector3(var_7_13, var_7_13, var_7_13))

			var_7_2.outer_decal_unit = Managers.state.unit_spawner:spawn_network_unit(var_7_11, "network_synched_dummy_unit", nil, var_7_12)
		end
	end

	var_7_2.next_missile_cast_t = arg_7_3
	var_7_2.num_dummy_missiles = 0

	local var_7_14 = var_7_2.physics_world
	local var_7_15 = var_7_4 + Vector3.up() * var_0_0
	local var_7_16, var_7_17, var_7_18, var_7_19, var_7_20 = PhysicsWorld.immediate_raycast(var_7_14, var_7_15, Vector3.up(), var_7_5 - var_0_0, "closest", "collision_filter", "filter_ai_mover")

	var_7_2.max_height = var_7_16 and var_0_0 + var_7_18 or var_7_5

	local var_7_21 = POSITION_LOOKUP[arg_7_1]
	local var_7_22 = Vector3.distance(var_7_21, var_7_4) * var_7_1.extra_time_per_distance

	var_7_2.summoning_done_t = arg_7_3 + var_7_1.summoning_time + var_7_22
	var_7_2.extra_time = var_7_22

	if not arg_7_2.breed.boss then
		local var_7_23 = arg_7_2.target_unit

		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_7_1, var_7_23, "chaos_vortex")
	end
end

BTChaosSorcererSummoningAction._clean_up_vortex_summoning = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_2.vortex_data
	local var_8_1 = Managers.state.unit_spawner
	local var_8_2 = var_8_0.inner_decal_unit

	if Unit.alive(var_8_2) then
		var_8_1:mark_for_deletion(var_8_2)
	end

	local var_8_3 = var_8_0.outer_decal_unit

	if Unit.alive(var_8_3) then
		var_8_1:mark_for_deletion(var_8_3)
	end

	var_8_0.inner_decal_unit = nil
	var_8_0.outer_decal_unit = nil
	var_8_0.num_dummy_missiles = 0

	if not arg_8_2.breed.boss then
		local var_8_4 = arg_8_2.target_unit

		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_8_1, var_8_4, "chaos_vortex")
	end
end

BTChaosSorcererSummoningAction._update_vortex_summoning = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_2.vortex_data
	local var_9_1 = var_9_0.vortex_spawn_pos:unbox()
	local var_9_2 = LocomotionUtils.look_at_position_flat(arg_9_1, var_9_1)

	arg_9_2.locomotion_extension:set_wanted_rotation(var_9_2)

	if arg_9_2.attack_finished then
		return
	end

	local var_9_3 = arg_9_2.action

	if var_9_0.num_dummy_missiles < var_9_3.num_missiles and arg_9_3 > var_9_0.next_missile_cast_t then
		local var_9_4 = var_9_1 - POSITION_LOOKUP[arg_9_1]
		local var_9_5 = Vector3.normalize(var_9_4)
		local var_9_6 = Unit.node(arg_9_1, "j_lefthand")
		local var_9_7 = Unit.world_position(arg_9_1, var_9_6)

		arg_9_0:_launch_vortex_dummy_missile(arg_9_1, var_9_3, var_9_0, var_9_7, var_9_1, var_9_5)

		var_9_0.next_missile_cast_t = var_9_0.next_missile_cast_t + var_9_3.missile_cast_interval
	end

	if arg_9_3 > var_9_0.summoning_done_t then
		arg_9_2.summoning_finished = true
	end
end

BTChaosSorcererSummoningAction._launch_vortex_dummy_missile = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	local var_10_0 = arg_10_2.missile_launch_angle
	local var_10_1 = arg_10_2.missile_speed
	local var_10_2 = arg_10_2.missile_life_time + arg_10_3.extra_time
	local var_10_3 = "sorcerer_vortex_dummy_missile"
	local var_10_4 = math.max(arg_10_3.max_height / 2, var_0_0 + 0.5)
	local var_10_5 = var_0_0 + (var_10_4 - var_0_0) * math.random()

	arg_10_5 = arg_10_5 + Vector3.up() * var_10_5

	local var_10_6 = {
		projectile_locomotion_system = {
			trajectory_template_name = "throw_trajectory",
			gravity_settings = "default",
			angle = var_10_0,
			initial_position = arg_10_4,
			height_offset = var_10_5,
			life_time = var_10_2,
			owner_unit = arg_10_1,
			position_target = arg_10_5,
			speed = var_10_1,
			target_vector = arg_10_6,
			true_flight_template_name = var_10_3
		},
		projectile_system = {
			impact_template_name = "direct_impact",
			explosion_template_name = "chaos_vortex_dummy_missile",
			owner_unit = arg_10_1
		}
	}
	local var_10_7 = Quaternion.look(arg_10_6)
	local var_10_8 = arg_10_2.missile_effect_unit_name
	local var_10_9, var_10_10 = Managers.state.unit_spawner:spawn_network_unit(var_10_8, "ai_true_flight_projectile_unit_without_raycast", var_10_6, arg_10_4, var_10_7)

	arg_10_3.num_dummy_missiles = arg_10_3.num_dummy_missiles + 1

	return var_10_9, var_10_10
end

BTChaosSorcererSummoningAction._spawn_boss_vortex = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_2.action
	local var_11_1 = var_11_0.vortex_template_name
	local var_11_2 = VortexTemplates[var_11_1]
	local var_11_3 = arg_11_2.boss_vortex_data
	local var_11_4 = 6
	local var_11_5 = POSITION_LOOKUP[arg_11_1]

	var_11_3.vortex_spawn_pos:store(var_11_5)

	var_11_3.vortex_spawn_radius = var_11_4

	local var_11_6 = math.min(var_11_4 / var_11_2.full_inner_radius, 1)
	local var_11_7 = var_11_0.inner_decal_unit_name

	if var_11_7 then
		local var_11_8 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_11_5)
		local var_11_9 = math.max(var_11_2.min_inner_radius, var_11_6 * var_11_2.full_inner_radius)

		Matrix4x4.set_scale(var_11_8, Vector3(var_11_9, var_11_9, var_11_9))

		var_11_3.inner_decal_unit = Managers.state.unit_spawner:spawn_network_unit(var_11_7, "network_synched_dummy_unit", nil, var_11_8)
	end

	local var_11_10 = var_11_0.outer_decal_unit_name

	if var_11_10 then
		local var_11_11 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_11_5)
		local var_11_12 = math.max(var_11_2.min_outer_radius, var_11_6 * var_11_2.full_outer_radius)

		Matrix4x4.set_scale(var_11_11, Vector3(var_11_12, var_11_12, var_11_12))

		var_11_3.outer_decal_unit = Managers.state.unit_spawner:spawn_network_unit(var_11_10, "network_synched_dummy_unit", nil, var_11_11)
	end

	arg_11_0:_spawn_vortex(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, var_11_3)
end

BTChaosSorcererSummoningAction._spawn_vortex = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	arg_12_6 = arg_12_6 or arg_12_2.vortex_data

	local var_12_0 = arg_12_2.action
	local var_12_1 = arg_12_6.vortex_spawn_pos:unbox()
	local var_12_2 = arg_12_2.breed.vortex_template_name or var_12_0.vortex_template_name
	local var_12_3 = VortexTemplates[var_12_2].breed_name
	local var_12_4 = Breeds[var_12_3]
	local var_12_5 = arg_12_6.vortex_units
	local var_12_6 = arg_12_6.queued_vortex
	local var_12_7 = "vortex"
	local var_12_8 = var_12_0.link_decal_units_to_vortex
	local var_12_9 = arg_12_6.inner_decal_unit
	local var_12_10 = arg_12_6.outer_decal_unit
	local var_12_11 = {
		prepare_func = function (arg_13_0, arg_13_1)
			arg_13_1.ai_supplementary_system = {
				vortex_template_name = var_12_2 or "standard",
				inner_decal_unit = var_12_8 and var_12_9,
				outer_decal_unit = var_12_8 and var_12_10,
				owner_unit = arg_12_1
			}
		end,
		spawned_func = function (arg_14_0, arg_14_1, arg_14_2)
			local var_14_0 = arg_14_2.spawn_queue_index

			var_12_6[var_14_0] = nil
			var_12_5[#var_12_5 + 1] = arg_14_0
			BLACKBOARDS[arg_14_0].master_unit = arg_12_1

			Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_14_0, "enemy_attack", DialogueSettings.see_vortex_distance, "attack_tag", "chaos_vortex_spawned")
		end
	}
	local var_12_12 = Managers.state.conflict:spawn_queued_unit(var_12_4, Vector3Box(var_12_1), QuaternionBox(Quaternion.identity()), var_12_7, nil, nil, var_12_11)

	arg_12_6.queued_vortex[var_12_12] = {
		inner_decal_unit = var_12_8 and var_12_9,
		outer_decal_unit = var_12_8 and var_12_10
	}

	if var_12_8 then
		arg_12_6.inner_decal_unit = nil
		arg_12_6.outer_decal_unit = nil
	end

	arg_12_2.attack_finished = true

	return true
end

BTChaosSorcererSummoningAction.spawn_portal = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	arg_15_6 = arg_15_6 or arg_15_2.portal_data

	local var_15_0 = arg_15_6.portal_spawn_pos:unbox()
	local var_15_1 = arg_15_6.portal_spawn_rot:unbox()
	local var_15_2 = arg_15_6.portal_spawn_type
	local var_15_3 = Breeds.chaos_tentacle
	local var_15_4 = var_15_3.inside_wall_spawn_distance
	local var_15_5

	if var_15_4 then
		local var_15_6 = Quaternion.forward(var_15_1)

		var_15_5 = var_15_0 - var_15_6 * var_15_4

		QuickDrawerStay:line(var_15_5, var_15_5 + var_15_6 * 5, Colors.get("light_green"))
		QuickDrawerStay:sphere(var_15_5, 0.1, Colors.get("light_green"))
	end

	local var_15_7 = arg_15_2.action.tentacle_template_name or "portal"
	local var_15_8 = {
		prepare_func = function (arg_16_0, arg_16_1)
			arg_16_1.ai_supplementary_system = {
				tentacle_template_name = var_15_7
			}
		end,
		spawned_func = function (arg_17_0, arg_17_1, arg_17_2)
			arg_17_2.sorcerer_blackboard.portal_unit = arg_17_0
		end,
		sorcerer_blackboard = arg_15_2
	}
	local var_15_9 = "portal"

	if var_15_2 == "wall" then
		Managers.state.conflict:spawn_queued_unit(var_15_3, Vector3Box(var_15_5), QuaternionBox(var_15_1), var_15_9, nil, nil, var_15_8)
	elseif var_15_2 == "floor" then
		Managers.state.conflict:spawn_queued_unit(var_15_3, Vector3Box(var_15_5), QuaternionBox(var_15_1), var_15_9, nil, nil, var_15_8)
	end

	arg_15_2.portal_search_active = false
	arg_15_2.ready_to_summon = false

	return true
end

BTChaosSorcererSummoningAction.boss_sorcerer_spawn_tentacle_in_arena = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = Breeds.chaos_tentacle
	local var_18_1 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_wall
	local var_18_2 = var_18_1[math.random(1, #var_18_1)]
	local var_18_3 = Unit.local_position(var_18_2, 0)
	local var_18_4 = Unit.local_rotation(var_18_2, 0)
	local var_18_5 = Quaternion.forward(var_18_4)
	local var_18_6 = var_18_0.inside_wall_spawn_distance
	local var_18_7 = "portal"
	local var_18_8 = var_18_3 - var_18_5 * var_18_6
	local var_18_9 = {
		spawned_func = function (arg_19_0, arg_19_1, arg_19_2)
			arg_18_2.tentacle_portal_units[arg_19_0] = true
			BLACKBOARDS[arg_19_0].boss_master_unit = arg_18_1
			arg_18_2.num_portals_alive = arg_18_2.num_portals_alive + 1
			arg_18_2.portal_unit = arg_19_0
		end
	}

	Managers.state.conflict:spawn_queued_unit(var_18_0, Vector3Box(var_18_8), QuaternionBox(var_18_4), var_18_7, nil, nil, var_18_9)
end

BTChaosSorcererSummoningAction.init_boss_sorcerer_tentacle = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_2.summon_plague_wave_timer = arg_20_3 + 0.5
end

BTChaosSorcererSummoningAction.init_summon_plague_wave = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_2.summon_plague_wave_timer = arg_21_3 + 0.1

	if not arg_21_2.breed.boss then
		local var_21_0 = arg_21_2.target_unit

		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_21_1, var_21_0, "plague_wave")
	end
end

BTChaosSorcererSummoningAction.init_summon_vermintide = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	arg_22_2.summon_plague_wave_timer = arg_22_3 + 0.1
	arg_22_2.damage_wave_template_name = "vermintide"
end

BTChaosSorcererSummoningAction.update_summon_plague_wave = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	if arg_23_3 > arg_23_2.summon_plague_wave_timer then
		if not arg_23_2.summoning_unit then
			local var_23_0 = DamageWaveTemplates.templates[arg_23_2.damage_wave_template_name or "plague_wave"].fx_unit
			local var_23_1 = {
				area_damage_system = {
					damage_wave_template_name = arg_23_2.damage_wave_template_name or "plague_wave",
					source_unit = arg_23_1
				}
			}
			local var_23_2 = POSITION_LOOKUP[arg_23_1]
			local var_23_3 = Unit.local_rotation(arg_23_1, 0)
			local var_23_4 = Managers.state.unit_spawner:spawn_network_unit(var_23_0, "damage_wave_unit", var_23_1, var_23_2, var_23_3)

			arg_23_2.summoning_unit = var_23_4
			arg_23_2.damage_wave_extension = ScriptUnit.extension(var_23_4, "area_damage_system")
		elseif arg_23_2.summoning_unit then
			local var_23_5 = arg_23_2.summoning_unit
			local var_23_6 = Managers.state.unit_storage:go_id(var_23_5)
			local var_23_7 = arg_23_2.damage_wave_extension
			local var_23_8 = var_23_7.source_unit
			local var_23_9 = Unit.local_rotation(var_23_8, 0)

			Unit.set_local_rotation(var_23_5, 0, var_23_9)

			local var_23_10 = POSITION_LOOKUP[var_23_5]
			local var_23_11 = POSITION_LOOKUP[var_23_8] + Quaternion.forward(var_23_9) * 2
			local var_23_12 = math.min(arg_23_4 * 2, 1)
			local var_23_13 = Vector3.lerp(var_23_10, var_23_11, var_23_12)
			local var_23_14, var_23_15, var_23_16, var_23_17, var_23_18 = GwNavQueries.triangle_from_position(arg_23_2.nav_world, var_23_13, 1.5, 1.5)

			if var_23_14 then
				var_23_13 = Vector3(var_23_13.x, var_23_13.y, var_23_15)
			end

			Unit.set_local_position(var_23_5, 0, var_23_13)
			GameSession.set_game_object_field(var_23_7.game, var_23_6, "rotation", var_23_9)
			GameSession.set_game_object_field(var_23_7.game, var_23_6, "position", var_23_13)
		end
	end
end

BTChaosSorcererSummoningAction.spawn_plague_wave = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	local var_24_0 = arg_24_2.plague_wave_data
	local var_24_1 = var_24_0.target_starting_pos:unbox()
	local var_24_2 = POSITION_LOOKUP[arg_24_1]
	local var_24_3 = Quaternion.look(arg_24_5 - var_24_2)
	local var_24_4 = var_24_0.target_dist
	local var_24_5 = arg_24_2.nav_world
	local var_24_6 = LocomotionUtils.pos_on_mesh(var_24_5, var_24_2, 1, 1)
	local var_24_7 = LocomotionUtils.pos_on_mesh(var_24_5, arg_24_5, 1, 1)
	local var_24_8 = arg_24_2.damage_wave_extension

	if not var_24_7 then
		local var_24_9 = GwNavQueries.inside_position_from_outside_position(var_24_5, arg_24_5, 6, 6, 4, 0.5)

		if var_24_9 then
			var_24_7 = var_24_9
		else
			arg_24_2.ready_to_summon = false

			var_24_8:abort()

			return false
		end
	end

	if not var_24_6 then
		local var_24_10 = GwNavQueries.inside_position_from_outside_position(var_24_5, var_24_2, 6, 6, 4, 0.5)

		if var_24_10 then
			var_24_6 = var_24_10
		else
			arg_24_2.ready_to_summon = false

			var_24_8:abort()

			return false
		end
	end

	local var_24_11 = GwNavQueries.raycango(var_24_5, var_24_6, var_24_7)
	local var_24_12

	if var_24_11 then
		var_24_12 = var_24_7
	else
		local var_24_13 = false
		local var_24_14 = 5
		local var_24_15 = var_24_1 - arg_24_5
		local var_24_16 = Vector3.normalize(var_24_15)
		local var_24_17 = Vector3.distance(arg_24_5, var_24_1)
		local var_24_18 = 2.5

		for iter_24_0 = 1, var_24_14 do
			local var_24_19 = arg_24_5 + var_24_16 * (var_24_18 * iter_24_0)

			if GwNavQueries.raycango(var_24_5, var_24_6, var_24_19) then
				var_24_13 = true
				var_24_12 = var_24_19

				local var_24_20 = Quaternion.look(var_24_19 - var_24_2)

				break
			end
		end

		if not var_24_13 then
			arg_24_2.ready_to_summon = false

			var_24_8:abort()

			return false
		end
	end

	local var_24_21 = arg_24_2.action

	if Vector3.distance_squared(var_24_12, arg_24_5) > var_24_21.max_wave_to_target_dist^2 then
		arg_24_2.ready_to_summon = false

		var_24_8:abort()

		return false
	end

	var_24_8:launch_wave(arg_24_2.summon_target_unit, var_24_12)

	return true
end

BTChaosSorcererSummoningAction.spawn_plague_wave_from_spawner = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0 = POSITION_LOOKUP[arg_25_1]
	local var_25_1 = arg_25_2.nav_world
	local var_25_2 = arg_25_2.target_unit
	local var_25_3 = LocomotionUtils.pos_on_mesh(var_25_1, var_25_0)

	if not var_25_3 then
		return false
	end

	local var_25_4 = arg_25_5 - var_25_3
	local var_25_5 = Quaternion.look(var_25_4, Vector3.up())
	local var_25_6 = "units/beings/enemies/chaos_sorcerer_fx/chr_chaos_sorcerer_fx"
	local var_25_7 = {
		area_damage_system = {
			damage_wave_template_name = "plague_wave",
			source_unit = arg_25_1
		}
	}
	local var_25_8 = Managers.state.unit_spawner:spawn_network_unit(var_25_6, "damage_wave_unit", var_25_7, var_25_3, var_25_5)

	ScriptUnit.extension(var_25_8, "area_damage_system"):launch_wave(var_25_2)

	arg_25_2.attack_finished = true

	return true
end

BTChaosSorcererSummoningAction.spawn_plague_waves_in_patterns = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	local var_26_0 = arg_26_2.nav_world
	local var_26_1 = arg_26_2.action
	local var_26_2
	local var_26_3

	if var_26_1.spawner_set_id then
		var_26_2 = arg_26_2.spawners[var_26_1.spawner_set_id]
	else
		var_26_2 = {
			arg_26_1
		}
	end

	local var_26_4 = var_26_1.pattern_repetitions or 1
	local var_26_5 = var_26_1.range or 20

	for iter_26_0 = 1, var_26_4 do
		for iter_26_1 = 1, #var_26_2 do
			local var_26_6 = var_26_2[iter_26_1]
			local var_26_7 = Unit.local_position(var_26_6, 0)
			local var_26_8 = LocomotionUtils.pos_on_mesh(var_26_0, var_26_7)

			if not var_26_8 then
				return false
			end

			local var_26_9
			local var_26_10

			if var_26_1.spawn_rot_func then
				var_26_9 = var_26_1.spawn_rot_func(arg_26_1, arg_26_2, var_26_6, iter_26_0)
			else
				var_26_9 = Unit.local_rotation(var_26_6, 0)
			end

			local var_26_11 = Quaternion.forward(var_26_9)
			local var_26_12 = var_26_8 + var_26_11 * var_26_5

			if var_26_1.goal_pos_func then
				var_26_12 = var_26_1.goal_pos_func(arg_26_1, arg_26_2, var_26_6, iter_26_0, var_26_8, var_26_12, var_26_11)
			end

			if var_26_12 then
				local var_26_13 = "units/beings/enemies/chaos_sorcerer_fx/chr_chaos_sorcerer_fx"
				local var_26_14 = {
					area_damage_system = {
						damage_wave_template_name = var_26_1.damage_wave_template,
						source_unit = arg_26_1
					}
				}
				local var_26_15 = Managers.state.unit_spawner:spawn_network_unit(var_26_13, "damage_wave_unit", var_26_14, var_26_8, var_26_9)
				local var_26_16 = ScriptUnit.extension(var_26_15, "area_damage_system")

				if var_26_1.damage_wave_update_func then
					var_26_16:set_update_func(var_26_1.damage_wave_update_func, var_26_1.damage_wave_init_func, arg_26_3)
				end

				local var_26_17

				var_26_16:launch_wave(var_26_17, var_26_12)

				arg_26_2.attack_finished = true
			end
		end
	end

	return true
end

BTChaosSorcererSummoningAction.init_summon_plague_wave_sequence = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_2.summon_plague_wave_timer = arg_27_3 + 0.5
	arg_27_2.next_wave_time = 0
	arg_27_2.wave_counter = 0

	local var_27_0 = arg_27_2.action.sequence_init_func

	if var_27_0 then
		var_27_0(arg_27_1, arg_27_2)
	end
end

BTChaosSorcererSummoningAction.update_sequenced_plague_wave_spawning = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = arg_28_2.action
	local var_28_1

	if arg_28_3 > arg_28_2.next_wave_time then
		arg_28_2.next_wave_time = arg_28_3 + var_28_0.duration_between_waves

		local var_28_2 = arg_28_0[var_28_0.spawn_func_name](arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, var_28_1)

		arg_28_2.wave_counter = arg_28_2.wave_counter + 1

		if arg_28_2.wave_counter > var_28_0.num_waves then
			return true
		end
	end
end

BTChaosSorcererSummoningAction.clean_up_plague_wave = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_2.target_unit

	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_29_1, var_29_0, "plague_wave")
end

local var_0_1 = false

BTChaosSorcererSummoningAction.init_boss_rings = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_2.summoning_finished = true
end

BTChaosSorcererSummoningAction.spawn_boss_rings = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_2.action
	local var_31_1 = ScriptUnit.extension(arg_31_1, "dialogue_system")
	local var_31_2 = Managers.world:wwise_world(arg_31_2.world)

	arg_31_2.audio_source_id = WwiseWorld.make_manual_source(var_31_2, arg_31_1, var_31_1.voice_node)

	local var_31_3 = var_31_0.start_ability_sound_event

	if var_31_3 then
		Managers.state.entity:system("audio_system"):_play_event_with_source(var_31_2, var_31_3, arg_31_2.audio_source_id)

		arg_31_2.summoning_start_event_playing = true
	end

	return true
end

BTChaosSorcererSummoningAction.update_boss_rings = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	local var_32_0 = arg_32_2.world
	local var_32_1 = arg_32_2.action
	local var_32_2 = var_32_1.ring_sequence
	local var_32_3 = true
	local var_32_4 = {
		Color(255, 0, 0),
		Color(255, 0, 0)
	}
	local var_32_5 = 0.5

	for iter_32_0, iter_32_1 in ipairs(var_32_2) do
		if not iter_32_1.done then
			iter_32_1.delay_time = iter_32_1.delay_time or iter_32_1.delay + arg_32_3 or arg_32_3

			if arg_32_3 >= iter_32_1.delay_time and not iter_32_1.damage_effect_time then
				if var_0_1 and iter_32_1.delay > 0 then
					QuickDrawerStay:reset()
				end

				local var_32_6 = iter_32_1.premination
				local var_32_7 = var_32_1.ring_info
				local var_32_8 = Vector3Box.unbox(arg_32_2.ring_center_position)
				local var_32_9 = iter_32_1.position
				local var_32_10 = var_32_7[var_32_9].max_radius
				local var_32_11 = var_32_7[var_32_9].min_radius
				local var_32_12 = var_32_6 == "short" and 1 or var_32_6 == "medium" and 2 or var_32_6 == "long" and 3 or 0.75
				local var_32_13 = var_32_6 == "short" and var_32_7[var_32_9].premonition_effect_name_short or var_32_6 == "medium" and var_32_7[var_32_9].premonition_effect_name_medium or var_32_6 == "long" and var_32_7[var_32_9].premonition_effect_name_long

				if var_32_13 then
					Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects[var_32_13], NetworkConstants.invalid_game_object_id, 0, var_32_8, false)
				end

				local var_32_14 = Vector3(var_32_10, 0, 0)
				local var_32_15 = Vector3(var_32_11, 0, 0)

				if var_0_1 then
					for iter_32_2 = 1, 360 do
						var_32_14 = Quaternion.rotate(Quaternion.from_euler_angles_xyz(0, 0, 1), var_32_14)
						var_32_15 = Quaternion.rotate(Quaternion.from_euler_angles_xyz(0, 0, 1), var_32_15)

						QuickDrawerStay:line(var_32_8 + var_32_14 + Vector3.up() * 0.6, var_32_8 + var_32_15 + Vector3.up() * 0.1, var_32_4[iter_32_0 % 2 + 1])
					end
				end

				fassert(var_32_6, "No or invalid premonition type")

				iter_32_1.damage_effect_time = arg_32_3 + var_32_12
				iter_32_1.bot_avoid_time = iter_32_1.damage_effect_time - var_32_5
			elseif iter_32_1.bot_avoid_time and arg_32_3 >= iter_32_1.bot_avoid_time then
				iter_32_1.bot_avoid_time = nil

				local var_32_16 = iter_32_1.position
				local var_32_17 = var_32_1.ring_info
				local var_32_18 = arg_32_2.ring_center_position:unbox()
				local var_32_19 = var_32_17[var_32_16].min_radius
				local var_32_20 = var_32_17[var_32_16].max_radius
				local var_32_21 = Vector3(var_32_19, var_32_20, 1)

				Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_32_18, "cylinder", var_32_21, Quaternion.identity(), var_32_5, "Chaos Sorcerer")
			elseif iter_32_1.damage_effect_time and arg_32_3 >= iter_32_1.damage_effect_time and not iter_32_1.premonition_time then
				local var_32_22 = var_32_1.ring_info
				local var_32_23 = iter_32_1.position
				local var_32_24 = Vector3Box.unbox(arg_32_2.ring_center_position)
				local var_32_25 = var_32_22[var_32_23].damage_effect_name

				if var_32_25 then
					Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects[var_32_25], NetworkConstants.invalid_game_object_id, 0, var_32_24, false)
				end

				iter_32_1.premonition_time = arg_32_3
			elseif iter_32_1.premonition_time and arg_32_3 >= iter_32_1.premonition_time then
				local var_32_26 = iter_32_1.position
				local var_32_27 = var_32_1.ring_info
				local var_32_28 = Vector3Box.unbox(arg_32_2.ring_center_position)
				local var_32_29 = var_32_27[var_32_26].min_radius
				local var_32_30 = var_32_27[var_32_26].max_radius
				local var_32_31 = Managers.state.entity:system("audio_system")

				var_32_31:play_audio_position_event(var_32_1.damage_sound_event, var_32_28)

				if arg_32_2.summoning_start_event_playing then
					arg_32_2.summoning_start_event_playing = nil

					local var_32_32 = Managers.world:wwise_world(arg_32_2.world)

					var_32_31:_play_event_with_source(var_32_32, var_32_1.end_ability_sound_event, arg_32_2.audio_source_id)
					WwiseWorld.destroy_manual_source(var_32_32, arg_32_2.audio_source_id)
				end

				local var_32_33 = {}
				local var_32_34 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
				local var_32_35 = iter_32_1.catapult_strength

				AiUtils.broadphase_query(var_32_28, var_32_30, var_32_33)

				local var_32_36 = var_32_29 * var_32_29
				local var_32_37 = var_32_30 * var_32_30

				for iter_32_3, iter_32_4 in ipairs(var_32_33) do
					local var_32_38 = POSITION_LOOKUP[iter_32_4]

					if var_32_36 < Vector3.distance_squared(var_32_38, var_32_28) and iter_32_4 ~= arg_32_1 then
						local var_32_39 = var_32_1.damage_profile_name
						local var_32_40 = DamageProfileTemplates[var_32_39]
						local var_32_41 = Managers.state.difficulty:get_difficulty()
						local var_32_42 = var_32_1.power_level[var_32_41]
						local var_32_43
						local var_32_44
						local var_32_45
						local var_32_46
						local var_32_47
						local var_32_48
						local var_32_49
						local var_32_50 = arg_32_1

						DamageUtils.add_damage_network_player(var_32_40, nil, var_32_42, iter_32_4, arg_32_1, "torso", POSITION_LOOKUP[iter_32_4], Vector3.up(), "undefined", var_32_43, var_32_44, var_32_45, var_32_46, var_32_47, var_32_48, var_32_49, var_32_50)
					end
				end

				for iter_32_5, iter_32_6 in ipairs(var_32_34) do
					local var_32_51 = POSITION_LOOKUP[iter_32_6]
					local var_32_52 = Vector3.distance_squared(var_32_51, var_32_28)
					local var_32_53 = iter_32_1.catapult_direction == "in" and var_32_28 - var_32_51 or var_32_51 - var_32_28
					local var_32_54 = Vector3.normalize(var_32_53)

					if var_32_52 < var_32_37 and var_32_36 < var_32_52 then
						local var_32_55 = var_32_1.damage_profile_name
						local var_32_56 = DamageProfileTemplates[var_32_55]
						local var_32_57 = Managers.state.difficulty:get_difficulty()
						local var_32_58 = Managers.player:owner(iter_32_6)
						local var_32_59 = var_32_58 and not var_32_58:is_player_controlled() and 0 or var_32_1.power_level[var_32_57]

						DamageUtils.add_damage_network_player(var_32_56, nil, var_32_59, iter_32_6, arg_32_1, "torso", POSITION_LOOKUP[iter_32_6], Vector3.up(), "undefined")

						if var_32_35 then
							StatusUtils.set_catapulted_network(iter_32_6, true, (var_32_54 + Vector3.up()) * var_32_35)
						end

						arg_32_2.hit_by_eruptions = true
					end
				end

				iter_32_1.done = true
			else
				var_32_3 = false

				break
			end

			if not iter_32_1.done then
				var_32_3 = false
			end
		end
	end

	if var_32_3 then
		return true
	end
end

BTChaosSorcererSummoningAction.clean_up_boss_rings = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	for iter_33_0, iter_33_1 in ipairs(arg_33_2.action.ring_sequence) do
		iter_33_1.delay_time = nil
		iter_33_1.premonition_time = nil
		iter_33_1.damage_effect_time = nil
		iter_33_1.done = nil
	end

	if arg_33_2.summoning_start_event_playing then
		arg_33_2.summoning_start_event_playing = nil

		local var_33_0 = Managers.state.entity:system("audio_system")
		local var_33_1 = Managers.world:wwise_world(arg_33_2.world)

		var_33_0:_play_event_with_source(var_33_1, arg_33_2.action.end_ability_sound_event, arg_33_2.audio_source_id)
		WwiseWorld.destroy_manual_source(var_33_1, arg_33_2.audio_source_id)
	end
end
