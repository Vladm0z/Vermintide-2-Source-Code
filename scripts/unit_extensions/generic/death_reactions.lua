-- chunkname: @scripts/unit_extensions/generic/death_reactions.lua

DeathReactions = {}
DeathReactions.IS_NOT_DONE = "not_done"
DeathReactions.IS_DONE = "done"

local var_0_0 = DeathReactions
local var_0_1 = BLACKBOARDS
local var_0_2 = {
	heavy = "fx/screenspace_blood_drops_heavy",
	blunt = "fx/screenspace_blood_drops"
}

local function var_0_3(arg_1_0)
	return arg_1_0[DamageDataIndex.DAMAGE_TYPE] == "sync_health"
end

local function var_0_4(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	local var_2_0 = POSITION_LOOKUP[arg_2_1] + Vector3(0, 0, 1)
	local var_2_1 = Managers.player
	local var_2_2 = Managers.state.camera

	for iter_2_0, iter_2_1 in pairs(var_2_1:human_players()) do
		if not iter_2_1.remote and (not script_data.disable_remote_blood_splatter or Unit.alive(arg_2_2) and iter_2_1 == var_2_1:owner(arg_2_2)) then
			local var_2_3 = iter_2_1.viewport_name
			local var_2_4 = var_2_2:camera_position(var_2_3)

			if Vector3.distance_squared(var_2_4, var_2_0) < 9 and (not script_data.disable_behind_blood_splatter or var_2_2:is_in_view(var_2_3, var_2_0)) then
				local var_2_5 = var_0_2[arg_2_4] or "fx/screenspace_blood_drops"

				Managers.state.blood:play_screen_space_blood(var_2_5, Vector3.zero())
			end
		end
	end
end

local function var_0_5(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.difficulty_kill_achievements

	if var_3_0 then
		for iter_3_0 = 1, #var_3_0 do
			local var_3_1 = var_3_0[iter_3_0]
			local var_3_2 = Managers.state.difficulty:get_difficulty_rank()
			local var_3_3 = Managers.player
			local var_3_4 = 1

			while var_3_3:local_player(var_3_4) ~= nil do
				if var_3_4 > 4 then
					ferror("Sanity check, how did we get above 4 here?")

					break
				end

				local var_3_5 = var_3_3:local_player(var_3_4)

				if not var_3_5.bot_player and var_3_2 > arg_3_1:get_persistent_stat(var_3_5:stats_id(), var_3_1) then
					arg_3_1:set_stat(var_3_5:stats_id(), var_3_1, var_3_2)
				end

				var_3_4 = var_3_4 + 1
			end
		end
	end
end

local function var_0_6(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0 == "military_finish" and arg_4_1 == "chaos_warrior" then
		local var_4_0 = {
			"military_statue_kill_chaos_warriors",
			"military_statue_kill_chaos_warriors_cata"
		}

		for iter_4_0 = 1, #var_4_0 do
			if QuestSettings.allowed_difficulties[var_4_0[iter_4_0]][Managers.state.difficulty:get_difficulty()] then
				local var_4_1 = Managers.player:local_player()

				if var_4_1 then
					local var_4_2 = var_4_1:stats_id()

					arg_4_2:increment_stat(var_4_2, "military_statue_kill_chaos_warriors_session")

					if arg_4_2:get_stat(var_4_2, "military_statue_kill_chaos_warriors_session") >= 3 then
						arg_4_2:increment_stat(var_4_2, var_4_0[iter_4_0])
						Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", NetworkLookup.statistics[var_4_0[iter_4_0]])
					end
				end
			end
		end
	end
end

local function var_0_7(arg_5_0, arg_5_1)
	local var_5_0 = Managers.state.conflict

	if var_5_0:count_units_by_breed_during_event("chaos_exalted_sorcerer_drachenfels") > 0 then
		local var_5_1 = Managers.player
		local var_5_2 = ScriptUnit.has_extension(arg_5_1, "health_system").last_damage_data
		local var_5_3 = var_5_1:owner(arg_5_1)
		local var_5_4 = var_5_2.attacker_unique_id
		local var_5_5 = var_5_1:player_from_unique_id(var_5_4)

		if var_5_5 and var_5_5 ~= var_5_3 then
			local var_5_6 = var_5_0:alive_bosses()[1]

			if var_5_6 ~= arg_5_1 then
				var_0_1[var_5_6].no_kill_achievement = false
			end
		end
	end
end

local function var_0_8(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_1.statistics_db
	local var_6_1 = var_0_1[arg_6_0].breed
	local var_6_2 = arg_6_3[DamageDataIndex.DAMAGE_TYPE]

	StatisticsUtil.register_kill(arg_6_0, arg_6_3, var_6_0, true)
	var_0_5(var_6_1, var_6_0)
	var_0_6(var_6_2, var_6_1.name, var_6_0)
	var_0_7(arg_6_3, arg_6_0)
	QuestSettings.handle_bastard_block_on_death(var_6_1, arg_6_0, arg_6_3, var_6_0)

	local var_6_3 = arg_6_3[DamageDataIndex.ATTACKER]
	local var_6_4 = AiUtils.get_actual_attacker_unit(var_6_3)
	local var_6_5 = Managers.player:owner(var_6_4)

	if var_6_5 then
		local var_6_6 = arg_6_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_6_7 = arg_6_3[DamageDataIndex.HIT_ZONE]
		local var_6_8 = var_6_1.name

		var_0_0._add_ai_killed_by_player_telemetry(arg_6_0, var_6_8, var_6_4, var_6_5, var_6_2, var_6_6, var_6_7)
	end
end

local function var_0_9(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_3[DamageDataIndex.SOURCE_ATTACKER_UNIT] or arg_7_3[DamageDataIndex.ATTACKER]
	local var_7_1 = arg_7_3[DamageDataIndex.HIT_ZONE]
	local var_7_2 = arg_7_3[DamageDataIndex.DAMAGE_TYPE]
	local var_7_3 = arg_7_0 ~= var_7_0
	local var_7_4 = var_0_1[arg_7_0]
	local var_7_5 = ScriptUnit.extension(arg_7_0, "ai_system")
	local var_7_6 = var_7_4.breed

	if not var_7_6.disable_alert_friends_on_death and var_7_3 then
		AiUtils.alert_nearby_friends_of_enemy(arg_7_0, var_7_4.group_blackboard.broadphase, var_7_0)
	end

	if arg_7_4 and var_7_6.custom_death_enter_function then
		local var_7_7 = arg_7_3[DamageDataIndex.DAMAGE_SOURCE_NAME]

		var_7_6.custom_death_enter_function(arg_7_0, var_7_0, var_7_2, var_7_1, arg_7_2, var_7_7)
	end

	var_7_5:die(var_7_0, arg_7_3)

	local var_7_8 = ScriptUnit.has_extension(arg_7_0, "locomotion_system")

	if var_7_8 then
		local var_7_9 = var_7_8.death_velocity_boxed and var_7_8.death_velocity_boxed:unbox() or Vector3.zero()

		var_7_8:set_affected_by_gravity(false)
		var_7_8:set_movement_type("script_driven")
		var_7_8:set_wanted_velocity(var_7_9)
		Managers.state.entity:system("ai_navigation_system"):add_navbot_to_release(arg_7_0)
		var_7_8:set_collision_disabled("death_reaction", true)
		var_7_8:set_movement_type("disabled")
	end

	if not var_7_6.keep_weapon_on_death and ScriptUnit.has_extension(arg_7_0, "ai_inventory_system") then
		Managers.state.entity:system("ai_inventory_system"):drop_item(arg_7_0)
	end

	local var_7_10 = AiUtils.get_actual_attacker_unit(var_7_0)

	if not var_7_6.no_blood then
		var_0_4(arg_7_1.world, arg_7_0, var_7_10, arg_7_3, var_7_2)
	end

	if var_7_6.death_sound_event then
		local var_7_11, var_7_12 = WwiseUtils.make_unit_auto_source(arg_7_1.world, arg_7_0, Unit.node(arg_7_0, "c_head"))
		local var_7_13 = ScriptUnit.extension(arg_7_0, "dialogue_system")
		local var_7_14 = var_7_13.wwise_voice_switch_group

		if var_7_14 then
			local var_7_15 = var_7_13.wwise_voice_switch_value

			WwiseWorld.set_switch(var_7_12, var_7_14, var_7_15, var_7_11)
		end

		local var_7_16 = WwiseWorld.trigger_event(var_7_12, var_7_6.death_sound_event, var_7_11)
		local var_7_17 = ScriptUnit.has_extension(arg_7_0, "hit_reaction_system")

		if var_7_17 then
			var_7_17:set_death_sound_event_id(var_7_16)
		end
	end

	local var_7_18 = ScriptUnit.extension(arg_7_0, "death_system")
	local var_7_19 = {
		breed = var_7_6,
		finish_time = arg_7_2 + (var_7_6.time_to_unspawn_after_death or 3),
		wall_nail_data = var_7_18.wall_nail_data
	}
	local var_7_20 = var_7_6.force_despawn

	if Managers.state.game_mode:has_activated_mutator("metal") and var_7_2 == "metal_mutator" then
		var_7_20 = true
	end

	if var_7_20 then
		Managers.state.unit_spawner:mark_for_deletion(arg_7_0)
	elseif not var_7_6.ignore_death_watch_timer then
		var_7_19.push_to_death_watch_timer = 0
	end

	Managers.state.game_mode:ai_killed(arg_7_0, var_7_10, var_7_19, arg_7_3)

	return var_7_19, var_0_0.IS_NOT_DONE
end

local function var_0_10(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0, var_8_1 = var_0_9(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_2 = var_0_1[arg_8_0]

	var_8_0.blackboard = var_8_2

	local var_8_3 = var_8_2.tentacle_data
	local var_8_4 = var_8_2.boss_master_unit

	if var_8_4 and Unit.alive(var_8_4) then
		local var_8_5 = var_0_1[var_8_4]

		var_8_5.num_portals_alive = var_8_5.num_portals_alive - 1
		var_8_5.tentacle_portal_units[arg_8_0] = nil
	end

	local var_8_6 = var_8_0.breed
	local var_8_7 = Unit.node(arg_8_0, var_8_6.sound_head_node)

	WwiseUtils.trigger_unit_event(arg_8_1.world, "Play_enemy_sorcerer_tentacle_death_vce", arg_8_0, var_8_7)
	WwiseUtils.trigger_unit_event(arg_8_1.world, "Stop_tentacle_movement", arg_8_0, var_8_7)

	local var_8_8 = var_8_2.current_target

	if Unit.alive(var_8_8) then
		var_8_2.tentacle_spline_extension:set_target("attack", var_8_8, var_8_3.current_length)

		local var_8_9 = POSITION_LOOKUP[var_8_8]

		var_8_3.last_target_pos:store(var_8_9)

		if var_8_3.sub_state == "portal_hanging" then
			StatusUtils.set_grabbed_by_tentacle_status_network(var_8_8, "portal_release")

			var_8_3.wait_for_release = arg_8_2 + var_8_6.portal_release_time
			var_8_3.sub_state = "portal_release"
		else
			var_8_3.wait_for_release = arg_8_2

			StatusUtils.set_grabbed_by_tentacle_network(var_8_8, false, arg_8_0)
		end

		local var_8_10 = "attack"
		local var_8_11 = Managers.state.network
		local var_8_12 = var_8_11:unit_game_object_id(arg_8_0)
		local var_8_13 = var_8_11:unit_game_object_id(var_8_2.current_target)
		local var_8_14 = NetworkLookup.tentacle_template[var_8_10]
		local var_8_15 = math.clamp(var_8_3.current_length, 0, 31)

		var_8_11.network_transmit:send_rpc_clients("rpc_change_tentacle_state", var_8_12, var_8_13, var_8_14, var_8_15, arg_8_2)
	end

	return var_8_0, var_8_1
end

local function var_0_11(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_4.blackboard
	local var_9_1 = var_9_0.current_target

	if Unit.alive(var_9_1) then
		local var_9_2 = var_9_0.tentacle_data

		if var_9_2.unit then
			local var_9_3 = var_9_2.current_length - 7 * arg_9_1

			var_9_2.current_length = math.max(var_9_3, 0)

			var_9_0.tentacle_spline_extension:set_target("attack", var_9_1, var_9_3)

			if var_9_3 > 0 or arg_9_3 < var_9_2.wait_for_release then
				return var_0_0.IS_NOT_DONE
			else
				local var_9_4 = var_9_2.portal_unit

				AiUtils.kill_unit(var_9_4)
			end
		end

		if var_9_2.sub_state == "portal_release" then
			StatusUtils.set_grabbed_by_tentacle_network(var_9_1, false, arg_9_0)
		end
	end

	Managers.state.unit_spawner:mark_for_deletion(arg_9_0)

	return var_0_0.IS_DONE
end

local function var_0_12(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	for iter_10_0, iter_10_1 in pairs(arg_10_3.wall_nail_data) do
		local var_10_0 = Unit.actor(arg_10_0, iter_10_0)

		if var_10_0 and Actor.is_physical(var_10_0) then
			local var_10_1 = Unit.world(arg_10_0)
			local var_10_2 = Actor.position(var_10_0)

			fassert(Vector3.is_valid(var_10_2), "Position from actor is not valid.")

			iter_10_1.position = Vector3Box(var_10_2)

			local var_10_3 = iter_10_1.attack_direction:unbox()
			local var_10_4 = 0.3
			local var_10_5 = iter_10_1.hit_speed * var_10_4

			fassert(var_10_5 > 0, "Ray distance is not greater than 0")

			local var_10_6 = "filter_weapon_nailing"
			local var_10_7, var_10_8, var_10_9, var_10_10, var_10_11 = PhysicsWorld.immediate_raycast(World.get_data(var_10_1, "physics_world"), var_10_2, var_10_3, arg_10_3.nailed and math.min(var_10_5, 0.4) or var_10_5, "closest", "collision_filter", var_10_6)

			if var_10_7 then
				Unit.disable_animation_state_machine(arg_10_0)
				Actor.set_kinematic(var_10_0, true)
				Actor.set_collision_enabled(var_10_0, false)

				local var_10_12 = Unit.get_data(arg_10_0, "breed").ragdoll_actor_thickness[iter_10_0]
				local var_10_13 = Actor.node(var_10_0)

				Unit.scene_graph_link(arg_10_0, var_10_13, nil)

				iter_10_1.node = var_10_13

				fassert(Vector3.is_valid(var_10_8), "Position from raycast is valid")

				iter_10_1.target_position = Vector3Box(var_10_8 - var_10_3 * var_10_12)
				iter_10_1.start_t = arg_10_2
				iter_10_1.end_t = arg_10_2 + math.max(var_10_9 / var_10_5 * var_10_4, 0.01)
				arg_10_3.finish_time = math.max(arg_10_3.finish_time, arg_10_2 + 30)
				arg_10_3.nailed = true
			else
				arg_10_3.wall_nail_data[iter_10_0] = nil
			end
		elseif var_10_0 and arg_10_3.nailed then
			local var_10_14 = iter_10_1.node
			local var_10_15 = math.min(math.auto_lerp(iter_10_1.start_t, iter_10_1.end_t, 0, 1, arg_10_2), 1)

			Unit.set_local_position(arg_10_0, var_10_14, Vector3.lerp(iter_10_1.position:unbox(), iter_10_1.target_position:unbox(), var_10_15))
		end
	end
end

local function var_0_13(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	if arg_11_4.remove then
		Managers.state.conflict:register_unit_destroyed(arg_11_0, var_0_1[arg_11_0], "death_done")

		return var_0_0.IS_DONE
	end

	if arg_11_4.finish_time then
		if arg_11_3 < arg_11_4.finish_time then
			if next(arg_11_4.wall_nail_data) then
				var_0_12(arg_11_0, arg_11_1, arg_11_3, arg_11_4)
			end
		else
			arg_11_4.finish_time = nil
		end
	end

	if arg_11_4.push_to_death_watch_timer and arg_11_3 > arg_11_4.push_to_death_watch_timer then
		Managers.state.unit_spawner:push_unit_to_death_watch_list(arg_11_0, arg_11_3, arg_11_4)

		arg_11_4.push_to_death_watch_timer = nil
	end

	return var_0_0.IS_NOT_DONE
end

local function var_0_14(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_1.statistics_db

	if not var_0_3(arg_12_3) then
		StatisticsUtil.register_kill(arg_12_0, arg_12_3, var_12_0)
	end

	local var_12_1 = Unit.get_data(arg_12_0, "breed")

	var_0_5(var_12_1, var_12_0)

	local var_12_2 = arg_12_3[DamageDataIndex.ATTACKER]
	local var_12_3 = AiUtils.get_actual_attacker_unit(var_12_2)
	local var_12_4 = Managers.player:owner(var_12_3)

	if var_12_4 then
		local var_12_5 = var_12_1.name
		local var_12_6 = arg_12_3[DamageDataIndex.DAMAGE_TYPE]
		local var_12_7 = arg_12_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_12_8 = arg_12_3[DamageDataIndex.HIT_ZONE]

		var_0_0._add_ai_killed_by_player_telemetry(arg_12_0, var_12_5, var_12_3, var_12_4, var_12_6, var_12_7, var_12_8)
	end
end

local function var_0_15(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_3[DamageDataIndex.ATTACKER]
	local var_13_1 = arg_13_3[DamageDataIndex.DAMAGE_TYPE]
	local var_13_2 = ScriptUnit.has_extension(arg_13_0, "locomotion_system")

	if var_13_2 then
		var_13_2:set_mover_disable_reason("husk_death_reaction", true)
		var_13_2:set_collision_disabled("husk_death_reaction", true)
	end

	local var_13_3 = AiUtils.get_actual_attacker_unit(var_13_0)
	local var_13_4 = Unit.get_data(arg_13_0, "breed")

	if not var_13_4.no_blood then
		var_0_4(arg_13_1.world, arg_13_0, var_13_3, arg_13_3, var_13_1)
	end

	if ScriptUnit.has_extension(arg_13_0, "ai_inventory_system") then
		Managers.state.entity:system("ai_inventory_system"):drop_item(arg_13_0)
	end

	if var_13_4.death_sound_event and not var_0_3(arg_13_3) then
		local var_13_5, var_13_6 = WwiseUtils.make_unit_auto_source(arg_13_1.world, arg_13_0, Unit.node(arg_13_0, "c_head"))
		local var_13_7 = ScriptUnit.extension(arg_13_0, "dialogue_system")
		local var_13_8 = var_13_7.wwise_voice_switch_group

		if var_13_8 then
			local var_13_9 = var_13_7.wwise_voice_switch_value

			WwiseWorld.set_switch(var_13_6, var_13_8, var_13_9, var_13_5)
		end

		local var_13_10 = WwiseWorld.trigger_event(var_13_6, var_13_4.death_sound_event, var_13_5)
		local var_13_11 = ScriptUnit.has_extension(arg_13_0, "hit_reaction_system")

		if var_13_11 then
			var_13_11:set_death_sound_event_id(var_13_10)
		end
	end

	local var_13_12 = ScriptUnit.extension(arg_13_0, "death_system")
	local var_13_13 = {
		breed = var_13_4,
		finish_time = arg_13_2 + 3,
		wall_nail_data = var_13_12.wall_nail_data
	}

	Managers.state.game_mode:ai_killed(arg_13_0, var_13_3, var_13_13, arg_13_3)

	return var_13_13, var_0_0.IS_NOT_DONE
end

local function var_0_16(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0, var_14_1 = var_0_15(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)

	if not var_0_3(arg_14_3) then
		local var_14_2 = var_14_0.breed
		local var_14_3 = Unit.node(arg_14_0, var_14_2.sound_head_node)

		WwiseUtils.trigger_unit_event(arg_14_1.world, "Play_enemy_sorcerer_tentacle_death_vce", arg_14_0, var_14_3)
		WwiseUtils.trigger_unit_event(arg_14_1.world, "Stop_tentacle_movement", arg_14_0, var_14_3)
	end

	return var_14_0, var_14_1
end

local function var_0_17(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if next(arg_15_4.wall_nail_data) then
		var_0_12(arg_15_0, arg_15_1, arg_15_3, arg_15_4)

		return var_0_0.IS_NOT_DONE
	elseif arg_15_3 < arg_15_4.finish_time and not arg_15_4.player_collided and not arg_15_4.nailed then
		return var_0_0.IS_NOT_DONE
	end

	local var_15_0 = ScriptUnit.has_extension(arg_15_0, "locomotion_system")

	if var_15_0 then
		var_15_0:destroy()
	end

	return var_0_0.IS_DONE
end

local function var_0_18(arg_16_0, arg_16_1)
	Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_16_1, arg_16_0)
end

local function var_0_19(arg_17_0, arg_17_1)
	Managers.state.entity:system("audio_system"):player_unit_sound_local(arg_17_1, arg_17_0)
end

local function var_0_20(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if not Unit.alive(arg_18_0) or not Unit.alive(arg_18_1) then
		return
	end

	if Unit.has_animation_state_machine(arg_18_0) then
		if Unit.has_data(arg_18_0, "enemy_dialogue_face_anim") then
			Unit.animation_event(arg_18_0, "talk_end")
		end

		if Unit.has_data(arg_18_0, "enemy_dialogue_body_anim") then
			Unit.animation_event(arg_18_0, "talk_body_end")
		end
	end

	local var_18_0 = ScriptUnit.has_extension(arg_18_1, "dialogue_system")
	local var_18_1 = Managers.player:owner(arg_18_1)

	if var_18_0 and var_18_1 ~= nil then
		local var_18_2 = "UNKNOWN"
		local var_18_3 = Unit.get_data(arg_18_0, "breed")

		if var_18_3 then
			var_18_2 = var_18_3.name
		elseif ScriptUnit.has_extension(arg_18_0, "dialogue_system") then
			var_18_2 = ScriptUnit.extension(arg_18_0, "dialogue_system").context.player_profile
		end

		if var_18_2 == "skaven_rat_ogre" then
			local var_18_4 = var_18_0.user_memory

			var_18_4.times_killed_rat_ogre = (var_18_4.times_killed_rat_ogre or 0) + 1
		end

		local var_18_5 = ScriptUnit.extension(arg_18_1, "inventory_system")
		local var_18_6 = var_18_5:get_wielded_slot_name()

		if var_18_6 == "slot_melee" or var_18_6 == "slot_ranged" then
			local var_18_7 = FrameTable.alloc_table()

			var_18_7.killed_type = var_18_2
			var_18_7.enemy_tag = var_18_2
			var_18_7.hit_zone = arg_18_2
			var_18_7.weapon_slot = var_18_6

			local var_18_8 = var_18_5:get_slot_data(var_18_6)

			if var_18_8 then
				var_18_7.weapon_type = var_18_8.item_data.item_type
			end

			local var_18_9 = var_18_0.context.player_profile
			local var_18_10 = var_0_1[arg_18_0]
			local var_18_11 = var_18_10 and var_18_10.optional_spawn_data

			if var_18_11 and not var_18_11.prevent_killed_enemy_dialogue then
				SurroundingAwareSystem.add_event(arg_18_1, "killed_enemy", DialogueSettings.default_view_distance, "killer_name", var_18_9, "hit_zone", arg_18_2, "enemy_tag", var_18_2, "weapon_slot", var_18_6)
			end

			local var_18_12 = "enemy_kill"

			ScriptUnit.extension_input(arg_18_1, "dialogue_system"):trigger_dialogue_event(var_18_12, var_18_7)
		end
	end
end

local function var_0_21(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_1[DamageDataIndex.SOURCE_ATTACKER_UNIT] or arg_19_1[DamageDataIndex.ATTACKER]
	local var_19_1 = ALIVE[var_19_0] and Unit.get_data(var_19_0, "breed")
	local var_19_2 = ALIVE[arg_19_0] and Unit.get_data(arg_19_0, "breed")
	local var_19_3 = Managers.player:unit_owner(var_19_0)
	local var_19_4 = var_19_1 and var_19_1.is_player
	local var_19_5 = var_19_2 and var_19_2.is_player

	if not var_19_4 or not var_19_5 then
		return
	end

	local var_19_6 = Managers.state.side
	local var_19_7 = Managers.player:owner(var_19_0)
	local var_19_8 = var_19_7 and var_19_7.bot_player

	if var_19_6:is_enemy(arg_19_0, var_19_0) and not var_19_7.remote and not var_19_8 then
		local var_19_9 = Managers.world:wwise_world(arg_19_2)

		if var_19_6:versus_is_hero(var_19_0) then
			WwiseWorld.trigger_event(var_19_9, "versus_hud_hero_player_special_kill")
		elseif var_19_6:versus_is_dark_pact(var_19_0) then
			WwiseWorld.trigger_event(var_19_9, "generic_pactsworn_death")
		end
	end
end

local function var_0_22(arg_20_0, arg_20_1)
	if not Managers.state.network.is_server then
		return
	end

	local var_20_0 = Managers.state.entity:system("dialogue_system")
	local var_20_1 = Managers.state.side
	local var_20_2 = var_20_1:versus_is_dark_pact(arg_20_0)
	local var_20_3 = var_20_1.side_by_unit[arg_20_0].PLAYER_UNITS

	if var_20_2 then
		local var_20_4 = false

		for iter_20_0 = 1, #var_20_3 do
			if HEALTH_ALIVE[var_20_3[iter_20_0]] then
				var_20_4 = true

				break
			end
		end

		if not var_20_4 then
			var_20_0:queue_mission_giver_event("vs_mg_pactsworn_wipe")
		end
	end
end

local function var_0_23(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1[DamageDataIndex.SOURCE_ATTACKER_UNIT] or arg_21_1[DamageDataIndex.ATTACKER]

	if not Unit.alive(var_21_0) or not Unit.alive(arg_21_0) then
		return
	end

	local var_21_1 = Unit.get_data(var_21_0, "breed")
	local var_21_2 = Unit.get_data(arg_21_0, "breed")

	Managers.state.event:trigger("on_killed", arg_21_1, var_21_2, var_21_1, var_21_0, arg_21_0)

	if not var_21_1 or not var_21_1.is_player or not var_21_2 then
		return
	end

	local var_21_3 = Managers.state.side

	if not var_21_3:is_enemy(var_21_0, arg_21_0) then
		return
	end

	Managers.state.event:trigger("on_player_killed_enemy", arg_21_1, var_21_2, arg_21_0)

	local var_21_4 = ScriptUnit.has_extension(var_21_0, "buff_system")

	if var_21_4 then
		var_21_4:trigger_procs("on_kill", arg_21_1, var_21_2, arg_21_0)
	end

	if (var_21_2.special or var_21_2.elite) and var_21_4 then
		var_21_4:trigger_procs("on_kill_elite_special", arg_21_1, var_21_2, arg_21_0)
	end

	local var_21_5 = var_21_3.side_by_unit[arg_21_0]

	if var_21_2.elite then
		local var_21_6 = var_21_5.ENEMY_PLAYER_AND_BOT_UNITS

		for iter_21_0 = 1, #var_21_6 do
			local var_21_7 = var_21_6[iter_21_0]
			local var_21_8 = ScriptUnit.has_extension(var_21_7, "buff_system")

			if var_21_8 then
				var_21_8:trigger_procs("on_elite_killed", arg_21_1, var_21_2, arg_21_0)
			end
		end
	end

	if var_21_2.boss then
		local var_21_9 = var_21_5.ENEMY_PLAYER_AND_BOT_UNITS

		for iter_21_1 = 1, #var_21_9 do
			local var_21_10 = var_21_9[iter_21_1]
			local var_21_11 = ScriptUnit.has_extension(var_21_10, "buff_system")

			if var_21_11 then
				var_21_11:trigger_procs("on_boss_killed", arg_21_1, var_21_2)
			end
		end
	end

	if var_21_2.special then
		local var_21_12 = var_21_5.ENEMY_PLAYER_AND_BOT_UNITS

		for iter_21_2 = 1, #var_21_12 do
			local var_21_13 = var_21_12[iter_21_2]
			local var_21_14 = ScriptUnit.has_extension(var_21_13, "buff_system")

			if var_21_14 then
				var_21_14:trigger_procs("on_special_killed", arg_21_1, var_21_2, arg_21_0)
			end
		end
	end

	if ScriptUnit.has_extension(arg_21_0, "ping_system") then
		local var_21_15 = var_21_5.ENEMY_PLAYER_AND_BOT_UNITS

		for iter_21_3 = 1, #var_21_15 do
			local var_21_16 = var_21_15[iter_21_3]
			local var_21_17 = ScriptUnit.has_extension(var_21_16, "buff_system")

			if var_21_17 then
				var_21_17:trigger_procs("on_pingable_target_killed", arg_21_1, var_21_2)
			end
		end
	end
end

local function var_0_24(arg_22_0, arg_22_1)
	if Managers.player.is_server then
		local var_22_0 = Managers.state.game_mode:level_key()
		local var_22_1 = LevelSettings[var_22_0].display_name
		local var_22_2 = LevelSettings.farmlands.display_name
		local var_22_3 = "dlc_scorpion_field"

		if var_22_1 ~= var_22_2 and var_22_1 ~= var_22_3 then
			return
		end

		local var_22_4 = POSITION_LOOKUP[arg_22_1]
		local var_22_5 = Vector3(18.843, -117.7, 5.5)

		if Vector3.distance(var_22_5, var_22_4) < 35 then
			local var_22_6 = "scorpion_kill_minotaur_farmlands_oak"

			Managers.player:statistics_db():increment_stat_and_sync_to_clients(var_22_6)
		end
	end
end

local function var_0_25(arg_23_0)
	local var_23_0 = var_0_1[arg_23_0]

	if var_23_0 then
		if (var_23_0.breed and var_23_0.breed.name) ~= "beastmen_ungor_archer" then
			return
		end

		local var_23_1 = "scorpion_kill_archers_kill_minotaur"
		local var_23_2 = NetworkLookup.statistics[var_23_1]

		Managers.player:statistics_db():increment_stat_and_sync_to_clients("scorpion_kill_archers_kill_minotaur")
	end
end

local function var_0_26()
	local var_24_0 = Managers.player:statistics_db()

	var_24_0:increment_local_stat("warpfire_killed_gors")

	if var_24_0:get_local_stat("warpfire_killed_gors") >= QuestSettings.num_gors_killed_by_warpfire then
		var_24_0:set_local_stat("warpfire_killed_gors", 0)
		var_24_0:increment_stat_and_sync_to_clients("scorpion_slay_gors_warpfire_damage")
	end
end

local var_0_27 = {}

var_0_0.templates = {
	ai_default = {
		unit = {
			pre_start = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				var_0_8(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			end,
			start = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				local var_26_0, var_26_1 = var_0_9(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)

				var_0_20(arg_26_0, arg_26_3[DamageDataIndex.ATTACKER], arg_26_3[DamageDataIndex.HIT_ZONE], arg_26_3[DamageDataIndex.DAMAGE_TYPE])
				var_0_23(arg_26_0, arg_26_3)
				Managers.state.entity:system("play_go_tutorial_system"):register_killing_blow(arg_26_3[DamageDataIndex.DAMAGE_TYPE], arg_26_3[DamageDataIndex.ATTACKER])

				if arg_26_0 ~= arg_26_3[DamageDataIndex.ATTACKER] and ScriptUnit.has_extension(arg_26_0, "ai_system") then
					ScriptUnit.extension(arg_26_0, "ai_system"):attacked(arg_26_3[DamageDataIndex.ATTACKER], arg_26_2, arg_26_3)
				end

				local var_26_2 = arg_26_3[DamageDataIndex.ATTACKER]

				Managers.state.game_mode:ai_hit_by_player(arg_26_0, var_26_2, arg_26_3)

				return var_26_0, var_26_1
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				return (var_0_13(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4))
			end
		},
		husk = {
			pre_start = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				var_0_14(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
			end,
			start = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				local var_29_0, var_29_1 = var_0_15(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)

				if not var_0_3(arg_29_3) then
					var_0_23(arg_29_0, arg_29_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_29_0, arg_29_2, var_29_0)

				local var_29_2 = arg_29_3[DamageDataIndex.ATTACKER]

				Managers.state.game_mode:ai_hit_by_player(arg_29_0, var_29_2, arg_29_3)

				return var_29_0, var_29_1
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				return (var_0_17(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4))
			end
		}
	},
	chaos_tentacle = {
		unit = {
			pre_start = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				var_0_8(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			end,
			start = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				local var_32_0, var_32_1 = var_0_10(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)

				var_0_20(arg_32_0, arg_32_3[DamageDataIndex.ATTACKER], arg_32_3[DamageDataIndex.HIT_ZONE], arg_32_3[DamageDataIndex.DAMAGE_TYPE])
				var_0_23(arg_32_0, arg_32_3)

				return var_32_0, var_32_1
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				return (var_0_11(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4))
			end
		},
		husk = {
			pre_start = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				var_0_14(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
			end,
			start = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				local var_35_0, var_35_1 = var_0_16(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)

				if not var_0_3(arg_35_3) then
					var_0_23(arg_35_0, arg_35_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_35_0, arg_35_2, var_35_0)

				return var_35_0, var_35_1
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				return var_0_0.IS_DONE
			end
		}
	},
	chaos_tentacle_portal = {
		unit = {
			pre_start = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end,
			start = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				Unit.flow_event(arg_38_0, "kill_portal")

				local var_38_0 = Unit.node(arg_38_0, "a_surface_center")

				WwiseUtils.trigger_unit_event(arg_38_1.world, "Play_enemy_sorcerer_portal_explode", arg_38_0, var_38_0)

				return {
					despawn_after_time = arg_38_2 + 4.2
				}, var_0_0.IS_NOT_DONE
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				if arg_39_3 > arg_39_4.despawn_after_time then
					Managers.state.unit_spawner:mark_for_deletion(arg_39_0)

					return var_0_0.IS_DONE
				end

				return var_0_0.IS_NOT_DONE
			end
		},
		husk = {
			pre_start = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end,
			start = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				if not var_0_3(arg_41_3) then
					Unit.flow_event(arg_41_0, "kill_portal")

					local var_41_0 = Unit.node(arg_41_0, "a_surface_center")

					WwiseUtils.trigger_unit_event(arg_41_1.world, "Play_enemy_sorcerer_portal_explode", arg_41_0, var_41_0)
				end

				return nil, var_0_0.IS_DONE
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				return var_0_0.IS_DONE
			end
		}
	},
	storm_vermin_champion = {
		unit = {
			pre_start = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				var_0_8(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
			end,
			start = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				local var_44_0, var_44_1 = var_0_9(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)

				var_0_20(arg_44_0, arg_44_3[DamageDataIndex.ATTACKER], arg_44_3[DamageDataIndex.HIT_ZONE], arg_44_3[DamageDataIndex.DAMAGE_TYPE])
				var_0_23(arg_44_0, arg_44_3)

				if arg_44_0 ~= arg_44_3[DamageDataIndex.ATTACKER] and ScriptUnit.has_extension(arg_44_0, "ai_system") then
					ScriptUnit.extension(arg_44_0, "ai_system"):attacked(arg_44_3[DamageDataIndex.ATTACKER], arg_44_2, arg_44_3)
				end

				local var_44_2 = var_0_1[arg_44_0]

				if var_44_2.ward_active then
					AiUtils.stormvermin_champion_set_ward_state(arg_44_0, false, true)

					var_44_2.ward_active = false
				end

				return var_44_0, var_44_1
			end,
			update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				return (var_0_13(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4))
			end
		},
		husk = {
			pre_start = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				var_0_14(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
			end,
			start = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				local var_47_0, var_47_1 = var_0_15(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)

				if not var_0_3(arg_47_3) then
					var_0_23(arg_47_0, arg_47_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_47_0, arg_47_2, var_47_0)

				return var_47_0, var_47_1
			end,
			update = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
				return (var_0_17(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4))
			end
		}
	},
	gutter_runner = {
		unit = {
			pre_start = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				var_0_8(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
			end,
			start = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
				local var_50_0, var_50_1 = var_0_9(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)

				var_50_0.despawn_after_time = arg_50_2 + 2

				var_0_20(arg_50_0, arg_50_3[DamageDataIndex.ATTACKER], arg_50_3[DamageDataIndex.HIT_ZONE], arg_50_3[DamageDataIndex.DAMAGE_TYPE])
				var_0_23(arg_50_0, arg_50_3)

				return var_50_0, var_50_1
			end,
			update = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
				if arg_51_4.despawn_after_time and arg_51_3 > arg_51_4.despawn_after_time then
					Managers.state.unit_spawner:mark_for_deletion(arg_51_0)

					return var_0_0.IS_DONE
				end

				return var_0_0.IS_NOT_DONE
			end
		},
		husk = {
			pre_start = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
				var_0_14(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
			end,
			start = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
				local var_53_0, var_53_1 = var_0_15(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)

				if not var_0_3(arg_53_3) then
					var_0_23(arg_53_0, arg_53_3)
				end

				local var_53_2 = ScriptUnit.has_extension(arg_53_0, "locomotion_system")

				if var_53_2 then
					var_53_2:destroy()
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_53_0, arg_53_2, var_53_0)

				return nil, var_0_0.IS_DONE
			end,
			update = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
				return var_0_0.IS_DONE
			end
		}
	},
	poison_globadier = {
		unit = {
			pre_start = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
				var_0_8(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
			end,
			start = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
				local var_56_0 = var_0_1[arg_56_0]

				if Unit.get_data(arg_56_0, "breed").name == "skaven_poison_wind_globadier" then
					printf("[HON-43348] Globadier (%s) inside death reaction. Playing sound.", Unit.get_data(arg_56_0, "globadier_43348"))
				end

				var_0_19(arg_56_0, "Stop_enemy_foley_globadier_boiling_loop")

				if arg_56_0 ~= arg_56_3[DamageDataIndex.ATTACKER] and ScriptUnit.has_extension(arg_56_0, "ai_system") then
					ScriptUnit.extension(arg_56_0, "ai_system"):attacked(arg_56_3[DamageDataIndex.ATTACKER], arg_56_2, arg_56_3)
				end

				if var_56_0.suicide_run ~= nil and var_56_0.suicide_run.explosion_started then
					local var_56_1 = var_56_0.suicide_run.action

					AiUtils.poison_explode_unit(arg_56_0, var_56_1, var_56_0)
					var_0_9(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)

					local var_56_2 = "Play_enemy_combat_globadier_suicide_explosion"

					var_0_18(arg_56_0, var_56_2)
					var_0_20(arg_56_0, arg_56_3[DamageDataIndex.ATTACKER], arg_56_3[DamageDataIndex.HIT_ZONE], arg_56_3[DamageDataIndex.DAMAGE_TYPE])
					var_0_23(arg_56_0, arg_56_3)

					return nil, var_0_0.IS_DONE
				else
					local var_56_3, var_56_4 = var_0_9(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)

					var_56_3.blackboard = var_56_0

					var_0_20(arg_56_0, arg_56_3[DamageDataIndex.ATTACKER], arg_56_3[DamageDataIndex.HIT_ZONE], arg_56_3[DamageDataIndex.DAMAGE_TYPE])
					var_0_23(arg_56_0, arg_56_3)

					return var_56_3, var_56_4
				end
			end,
			update = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
				local var_57_0 = arg_57_4.blackboard
				local var_57_1

				if var_57_0.suicide_run ~= nil and var_57_0.suicide_run.explosion_started then
					var_57_1 = var_0_0.IS_DONE
				else
					var_57_1 = var_0_13(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
				end

				return var_57_1
			end
		},
		husk = {
			pre_start = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
				var_0_14(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
			end,
			start = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
				local var_59_0, var_59_1 = var_0_15(arg_59_0, arg_59_1, arg_59_2, arg_59_3)

				var_0_19(arg_59_0, "Stop_enemy_foley_globadier_boiling_loop")

				if not var_0_3(arg_59_3) then
					var_0_20(arg_59_0, arg_59_3[DamageDataIndex.ATTACKER], arg_59_3[DamageDataIndex.HIT_ZONE], arg_59_3[DamageDataIndex.DAMAGE_TYPE])
					var_0_23(arg_59_0, arg_59_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_59_0, arg_59_2, var_59_0)

				return var_59_0, var_59_1
			end,
			update = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
				return (var_0_17(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4))
			end
		}
	},
	chaos_zombie = {
		unit = {
			pre_start = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
				var_0_8(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
			end,
			start = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
				local var_62_0 = var_0_1[arg_62_0]

				if arg_62_0 ~= arg_62_3[DamageDataIndex.ATTACKER] and ScriptUnit.has_extension(arg_62_0, "ai_system") then
					ScriptUnit.extension(arg_62_0, "ai_system"):attacked(arg_62_3[DamageDataIndex.ATTACKER], arg_62_2, arg_62_3)
				end

				var_0_9(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)

				local var_62_1 = ScriptUnit.extension(arg_62_0, "ai_inventory_system")

				if arg_62_3[DamageDataIndex.HIT_ZONE] == var_62_1.inventory_weak_spot or var_62_0.explosion_finished then
					local var_62_2 = BreedActions.chaos_zombie.explosion_attack

					AiUtils.chaos_zombie_explosion(arg_62_0, var_62_2, var_62_0, true)

					return nil, var_0_0.IS_DONE
				else
					Managers.state.network:anim_event(arg_62_0, "death_backward")

					local var_62_3 = POSITION_LOOKUP[arg_62_0]
					local var_62_4 = Vector3(0, 4, 1)
					local var_62_5 = 1

					Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_62_3, "cylinder", var_62_4, nil, var_62_5, "Chaos Zombie")

					return nil, var_0_0.IS_NOT_DONE
				end
			end,
			update = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
				local var_63_0 = var_0_1[arg_63_0]
				local var_63_1

				if var_63_0.anim_cb_death_finished then
					local var_63_2 = BreedActions.chaos_zombie.explosion_attack

					AiUtils.chaos_zombie_explosion(arg_63_0, var_63_2, var_63_0, true)

					var_63_1 = var_0_0.IS_DONE
				elseif var_63_0.explosion_finished then
					var_63_1 = var_0_0.IS_DONE
				end

				return var_63_1
			end
		},
		husk = {
			pre_start = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
				var_0_14(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
			end,
			start = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
				local var_65_0, var_65_1 = var_0_15(arg_65_0, arg_65_1, arg_65_2, arg_65_3)

				Managers.state.unit_spawner:freeze_unit_extensions(arg_65_0, arg_65_2, var_65_0)

				return var_65_0, var_65_1
			end,
			update = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4)
				return (var_0_17(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4))
			end
		}
	},
	warpfire_thrower = {
		unit = {
			pre_start = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
				var_0_8(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
			end,
			start = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4)
				local var_68_0 = var_0_1[arg_68_0]

				if arg_68_0 ~= arg_68_3[DamageDataIndex.ATTACKER] and ScriptUnit.has_extension(arg_68_0, "ai_system") then
					ScriptUnit.extension(arg_68_0, "ai_system"):attacked(arg_68_3[DamageDataIndex.ATTACKER], arg_68_2, arg_68_3)
				end

				local var_68_1, var_68_2 = var_0_9(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4)

				var_0_20(arg_68_0, arg_68_3[DamageDataIndex.ATTACKER], arg_68_3[DamageDataIndex.HIT_ZONE], arg_68_3[DamageDataIndex.DAMAGE_TYPE])
				var_0_23(arg_68_0, arg_68_3)
				WwiseUtils.trigger_unit_event(Managers.world:world("level_world"), "Stop_enemy_vo_warpfire", arg_68_0, Unit.node(arg_68_0, "a_voice"))

				if arg_68_3[DamageDataIndex.HIT_ZONE] == "aux" then
					AiUtils.warpfire_explode_unit(arg_68_0, var_68_0)

					var_68_0.explode_on_death = true

					return var_68_1, var_0_0.IS_NOT_DONE
				else
					var_68_1.blackboard = var_68_0

					return var_68_1, var_68_2
				end
			end,
			update = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
				local var_69_0 = var_0_1[arg_69_0]
				local var_69_1

				if var_69_0.explode_on_death then
					local var_69_2 = Unit.actor(arg_69_0, "j_backpack")

					if var_69_2 then
						var_69_1 = var_0_0.IS_DONE

						Actor.set_collision_enabled(var_69_2, false)
						Actor.set_scene_query_enabled(var_69_2, false)
					else
						var_69_1 = var_0_0.IS_NOT_DONE
					end

					var_0_13(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
				else
					var_69_1 = var_0_13(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
				end

				return var_69_1
			end
		},
		husk = {
			pre_start = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
				var_0_14(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
			end,
			start = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
				local var_71_0, var_71_1 = var_0_15(arg_71_0, arg_71_1, arg_71_2, arg_71_3)

				if arg_71_3[DamageDataIndex.HIT_ZONE] == "aux" then
					Unit.flow_event(arg_71_0, "lua_hide_backpack")

					ScriptUnit.extension(arg_71_0, "death_system").actor_to_disable_on_death = "j_backpack"
				end

				if not var_0_3(arg_71_3) then
					var_0_20(arg_71_0, arg_71_3[DamageDataIndex.ATTACKER], arg_71_3[DamageDataIndex.HIT_ZONE], arg_71_3[DamageDataIndex.DAMAGE_TYPE])
					var_0_23(arg_71_0, arg_71_3)
				end

				WwiseUtils.trigger_unit_event(Managers.world:world("level_world"), "Stop_enemy_vo_warpfire", arg_71_0, Unit.node(arg_71_0, "a_voice"))
				Managers.state.unit_spawner:freeze_unit_extensions(arg_71_0, arg_71_2, var_71_0)

				return var_71_0, var_71_1
			end,
			update = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4)
				var_0_17(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4)

				local var_72_0 = ScriptUnit.extension(arg_72_0, "death_system")
				local var_72_1

				if var_72_0.actor_to_disable_on_death then
					local var_72_2 = Unit.actor(arg_72_0, var_72_0.actor_to_disable_on_death)

					if var_72_2 then
						var_72_1 = var_0_0.IS_DONE

						Actor.set_collision_enabled(var_72_2, false)
						Actor.set_scene_query_enabled(var_72_2, false)
					else
						var_72_1 = var_0_0.IS_NOT_DONE
					end
				else
					var_72_1 = var_0_0.IS_DONE
				end

				return var_72_1
			end
		}
	},
	loot_rat = {
		unit = {
			pre_start = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
				var_0_8(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
			end,
			start = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
				local var_74_0, var_74_1 = var_0_9(arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)

				var_0_20(arg_74_0, arg_74_3[DamageDataIndex.ATTACKER], arg_74_3[DamageDataIndex.HIT_ZONE], arg_74_3[DamageDataIndex.DAMAGE_TYPE])
				var_0_23(arg_74_0, arg_74_3)

				local var_74_2 = math.random(2, 4)

				for iter_74_0 = 1, var_74_2 do
					local var_74_3 = math.random()
					local var_74_4 = Managers.state.game_mode
					local var_74_5 = var_74_4:game_mode_key()
					local var_74_6 = LootRatPickups[var_74_5] or LootRatPickups.default
					local var_74_7 = 0

					for iter_74_1, iter_74_2 in pairs(var_74_6) do
						table.clear(var_0_27)

						if iter_74_1 == "boss_loot" then
							iter_74_1 = var_74_4:get_boss_loot_pickup()
						end

						local var_74_8 = arg_74_1.dice_keeper
						local var_74_9 = AllPickups[iter_74_1]
						local var_74_10 = var_74_9 and var_74_9.can_spawn_func
						local var_74_11 = var_74_9 ~= nil

						var_0_27.dice_keeper = var_74_8

						if var_74_10 and not var_74_10(var_0_27) then
							var_74_11 = false
						end

						var_74_7 = var_74_7 + iter_74_2

						if var_74_3 <= var_74_7 and var_74_11 then
							local var_74_12 = Unit.get_data(arg_74_0, "breed")
							local var_74_13 = var_74_12 and var_74_12.name
							local var_74_14 = {
								pickup_system = {
									has_physics = true,
									spawn_type = "loot",
									pickup_name = iter_74_1,
									dropped_by_breed = var_74_13
								}
							}
							local var_74_15 = var_74_9.unit_name
							local var_74_16 = var_74_9.unit_template_name or "pickup_unit"
							local var_74_17 = POSITION_LOOKUP[arg_74_0] + Vector3(math.random() - 0.5, math.random() - 0.5, 1)
							local var_74_18 = Quaternion(Vector3.right(), math.random() * 2 * math.pi)

							Managers.state.unit_spawner:spawn_network_unit(var_74_15, var_74_16, var_74_14, var_74_17, var_74_18)

							if iter_74_1 == "loot_die" then
								var_74_8:bonus_dice_spawned()
							end

							break
						end
					end
				end

				if arg_74_0 ~= arg_74_3[DamageDataIndex.ATTACKER] and ScriptUnit.has_extension(arg_74_0, "ai_system") then
					ScriptUnit.extension(arg_74_0, "ai_system"):attacked(arg_74_3[DamageDataIndex.ATTACKER], arg_74_2, arg_74_3)
				end

				return var_74_0, var_74_1
			end,
			update = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4)
				return (var_0_13(arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4))
			end
		},
		husk = {
			pre_start = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
				var_0_14(arg_76_0, arg_76_1, arg_76_2, arg_76_3)
			end,
			start = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
				local var_77_0, var_77_1 = var_0_15(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)

				if not var_0_3(arg_77_3) then
					var_0_20(arg_77_0, arg_77_3[DamageDataIndex.ATTACKER], arg_77_3[DamageDataIndex.HIT_ZONE], arg_77_3[DamageDataIndex.DAMAGE_TYPE])
					var_0_23(arg_77_0, arg_77_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_77_0, arg_77_2, var_77_0)

				return var_77_0, var_77_1
			end,
			update = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
				return (var_0_17(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4))
			end
		}
	},
	explosive_loot_rat = {
		unit = {
			pre_start = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
				var_0_8(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
			end,
			start = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
				local var_80_0, var_80_1 = var_0_9(arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4)

				var_0_20(arg_80_0, arg_80_3[DamageDataIndex.ATTACKER], arg_80_3[DamageDataIndex.HIT_ZONE], arg_80_3[DamageDataIndex.DAMAGE_TYPE])
				var_0_23(arg_80_0, arg_80_3)
				AiUtils.loot_rat_explosion(arg_80_0, arg_80_0, var_0_1[arg_80_0], nil, ExplosionUtils.get_template("loot_rat_explosion"))

				if arg_80_0 ~= arg_80_3[DamageDataIndex.ATTACKER] and ScriptUnit.has_extension(arg_80_0, "ai_system") then
					ScriptUnit.extension(arg_80_0, "ai_system"):attacked(arg_80_3[DamageDataIndex.ATTACKER], arg_80_2, arg_80_3)
				end

				if 0.2 >= math.random() then
					local var_80_2 = "all_ammo_small"
					local var_80_3 = AllPickups[var_80_2]
					local var_80_4 = {
						pickup_system = {
							has_physics = false,
							spawn_type = "loot",
							pickup_name = var_80_2
						}
					}
					local var_80_5 = var_80_3.unit_name
					local var_80_6 = var_80_3.unit_template_name or "pickup_unit"
					local var_80_7 = POSITION_LOOKUP[arg_80_0]
					local var_80_8 = Quaternion.identity()

					Managers.state.unit_spawner:spawn_network_unit(var_80_5, var_80_6, var_80_4, var_80_7, var_80_8)
				end

				return var_80_0, var_80_1
			end,
			update = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4)
				if arg_81_3 > var_0_1[arg_81_0].delete_at_t and not arg_81_4.marked_for_deletion then
					Managers.state.unit_spawner:mark_for_deletion(arg_81_0)

					arg_81_4.marked_for_deletion = true
				end

				return (var_0_13(arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4))
			end
		},
		husk = {
			pre_start = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
				var_0_14(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
			end,
			start = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
				local var_83_0, var_83_1 = var_0_15(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)

				if not var_0_3(arg_83_3) then
					var_0_20(arg_83_0, arg_83_3[DamageDataIndex.ATTACKER], arg_83_3[DamageDataIndex.HIT_ZONE], arg_83_3[DamageDataIndex.DAMAGE_TYPE])
					var_0_23(arg_83_0, arg_83_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_83_0, arg_83_2, var_83_0)

				return var_83_0, var_83_1
			end,
			update = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4)
				return (var_0_17(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4))
			end
		}
	},
	critter_nurgling = {
		unit = {
			pre_start = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
				var_0_8(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
			end,
			start = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
				Managers.state.event:trigger("nurgling_killed")

				return var_0_0.templates.ai_default.unit.start(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
			end,
			update = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
				return var_0_13(arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
			end
		},
		husk = {
			pre_start = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3)
				var_0_14(arg_88_0, arg_88_1, arg_88_2, arg_88_3)
			end,
			start = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
				return var_0_0.templates.ai_default.husk.start(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
			end,
			update = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4)
				return var_0_17(arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4)
			end
		}
	},
	player = {
		unit = {
			pre_start = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3)
				local var_91_0 = Managers.player:owner(arg_91_0)
				local var_91_1 = arg_91_3[DamageDataIndex.DAMAGE_TYPE]
				local var_91_2 = arg_91_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
				local var_91_3 = POSITION_LOOKUP[arg_91_0]

				Managers.telemetry_events:player_died(var_91_0, var_91_1, var_91_2, var_91_3)
			end,
			start = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4)
				var_0_22(arg_92_0, arg_92_3)
				var_0_23(arg_92_0, arg_92_3, true)
				StatisticsUtil.register_kill(arg_92_0, arg_92_3, arg_92_1.statistics_db, true)
				Unit.flow_event(arg_92_0, "lua_on_death")

				return nil, var_0_0.IS_DONE
			end
		},
		husk = {
			pre_start = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3)
				local var_93_0 = Managers.player:owner(arg_93_0)
				local var_93_1 = arg_93_3[DamageDataIndex.DAMAGE_TYPE]
				local var_93_2 = arg_93_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
				local var_93_3 = POSITION_LOOKUP[arg_93_0]

				Managers.telemetry_events:player_died(var_93_0, var_93_1, var_93_2, var_93_3)
			end,
			start = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
				if not var_0_3(arg_94_3) then
					if Managers.mechanism:current_mechanism_name() == "versus" then
						var_0_21(arg_94_0, arg_94_3, arg_94_1.world)
					end

					var_0_23(arg_94_0, arg_94_3, true)
					StatisticsUtil.register_kill(arg_94_0, arg_94_3, arg_94_1.statistics_db)
					Unit.flow_event(arg_94_0, "lua_on_death")

					if ScriptUnit.has_extension(arg_94_0, "dialogue_system") then
						SurroundingAwareSystem.add_event(arg_94_0, "player_death", DialogueSettings.death_discover_distance, "target", arg_94_0, "target_name", ScriptUnit.extension(arg_94_0, "dialogue_system").context.player_profile)
					end
				end

				return nil, var_0_0.IS_DONE
			end
		}
	},
	level_object = {
		unit = {
			pre_start = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3)
				return
			end,
			start = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
				Managers.state.game_mode:level_object_killed(arg_96_0, arg_96_3)
				Unit.set_flow_variable(arg_96_0, "current_health", 0)
				Unit.flow_event(arg_96_0, "lua_on_death")
			end,
			update = function (arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4)
				return
			end
		},
		husk = {
			pre_start = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3)
				return
			end,
			start = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4)
				Managers.state.game_mode:level_object_killed(arg_99_0, arg_99_3)
				Unit.flow_event(arg_99_0, "lua_on_death")
			end,
			update = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4)
				return
			end
		}
	},
	level_object_hit_context = {
		unit = {
			pre_start = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3)
				return
			end,
			start = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4)
				Managers.state.game_mode:level_object_killed(arg_102_0, arg_102_3)
				Unit.set_flow_variable(arg_102_0, "current_health", 0)
				Unit.flow_event(arg_102_0, "lua_on_death")

				local var_102_0 = Managers.player:local_player()
				local var_102_1 = var_102_0 and var_102_0.player_unit

				if var_102_1 and var_102_1 == arg_102_3[DamageDataIndex.SOURCE_ATTACKER_UNIT] then
					Unit.flow_event(arg_102_0, "lua_local_player_killing_blow")
				end
			end,
			update = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4)
				return
			end
		},
		husk = {
			pre_start = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3)
				return
			end,
			start = function (arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4)
				Managers.state.game_mode:level_object_killed(arg_105_0, arg_105_3)
				Unit.flow_event(arg_105_0, "lua_on_death")

				local var_105_0 = Managers.player:local_player()
				local var_105_1 = var_105_0 and var_105_0.player_unit

				if var_105_1 and var_105_1 == arg_105_3[DamageDataIndex.SOURCE_ATTACKER_UNIT] then
					Unit.flow_event(arg_105_0, "lua_local_player_killing_blow")
				end
			end,
			update = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
				return
			end
		}
	},
	standard = {
		unit = {
			pre_start = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3)
				return
			end,
			start = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4)
				local var_108_0 = {
					despawn_after_time = arg_108_2 + 8
				}

				ScriptUnit.has_extension(arg_108_0, "ai_supplementary_system"):on_death(arg_108_3[DamageDataIndex.ATTACKER])
				Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_108_0)

				return var_108_0, var_0_0.IS_NOT_DONE
			end,
			update = function (arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4)
				if arg_109_4.despawn_after_time and arg_109_3 > arg_109_4.despawn_after_time then
					Managers.state.unit_spawner:mark_for_deletion(arg_109_0)

					return var_0_0.IS_DONE
				end

				return var_0_0.IS_NOT_DONE
			end
		},
		husk = {
			pre_start = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3)
				return
			end,
			start = function (arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
				ScriptUnit.has_extension(arg_111_0, "ai_supplementary_system"):on_death(arg_111_3[DamageDataIndex.ATTACKER])

				return nil, var_0_0.IS_DONE
			end,
			update = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4)
				return
			end
		}
	},
	despawn = {
		unit = {
			pre_start = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3)
				return
			end,
			start = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3, arg_114_4, arg_114_5)
				local var_114_0 = {
					despawn_after_time = arg_114_5.despawn_after_time or 0,
					play_effect = arg_114_5.play_effect
				}

				Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_114_0)

				return var_114_0, var_0_0.IS_NOT_DONE
			end,
			update = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4)
				if arg_115_3 > arg_115_4.despawn_after_time then
					local var_115_0 = var_0_1[arg_115_0]

					Managers.state.conflict:destroy_unit(arg_115_0, var_115_0, "death_reaction_despawn")

					if arg_115_4.play_effect then
						local var_115_1 = POSITION_LOOKUP[arg_115_0]
						local var_115_2 = NetworkLookup.effects[arg_115_4.play_effect]
						local var_115_3 = 0
						local var_115_4 = Quaternion.identity()

						Managers.state.network:rpc_play_particle_effect(nil, var_115_2, NetworkConstants.invalid_game_object_id, var_115_3, var_115_1, var_115_4, false)
					end

					return var_0_0.IS_DONE
				end

				return var_0_0.IS_NOT_DONE
			end
		},
		husk = {
			pre_start = function (arg_116_0, arg_116_1, arg_116_2, arg_116_3)
				return
			end,
			start = function (arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4)
				return nil, var_0_0.IS_DONE
			end,
			update = function (arg_118_0, arg_118_1, arg_118_2, arg_118_3, arg_118_4)
				return
			end
		}
	},
	killable_projectile = {
		unit = {
			pre_start = function (arg_119_0, arg_119_1, arg_119_2, arg_119_3)
				return
			end,
			start = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4)
				ScriptUnit.extension(arg_120_0, "projectile_system"):force_impact(arg_120_0, Unit.local_position(arg_120_0, 0))

				local var_120_0 = Managers.state.network
				local var_120_1 = var_120_0:unit_game_object_id(arg_120_0)
				local var_120_2 = Unit.local_position(arg_120_0, 0)

				var_120_0.network_transmit:send_rpc_clients("rpc_generic_impact_projectile_force_impact", var_120_1, var_120_2)
				Unit.flow_event(arg_120_0, "lua_projectile_end")

				return nil, var_0_0.IS_DONE
			end,
			update = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3, arg_121_4)
				return
			end
		},
		husk = {
			pre_start = function (arg_122_0, arg_122_1, arg_122_2, arg_122_3)
				return
			end,
			start = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4)
				Unit.flow_event(arg_123_0, "lua_on_death")
			end,
			update = function (arg_124_0, arg_124_1, arg_124_2, arg_124_3, arg_124_4)
				return
			end
		}
	},
	explosive_barrel = {
		unit = {
			pre_start = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3)
				return
			end,
			start = function (arg_126_0, arg_126_1, arg_126_2, arg_126_3, arg_126_4)
				local var_126_0 = Managers.state.network:network_time()
				local var_126_1 = arg_126_3[DamageDataIndex.ATTACKER]
				local var_126_2 = {
					explode_time = var_126_0,
					killer_unit = var_126_1
				}
				local var_126_3 = ScriptUnit.has_extension(arg_126_0, "health_system").last_damage_data.attacker_unique_id
				local var_126_4 = Managers.player:player_from_unique_id(var_126_3)
				local var_126_5 = var_126_4 and var_126_4:stats_id()

				Managers.state.achievement:trigger_event("explosive_barrel_destroyed", var_126_5, arg_126_0, arg_126_3)

				ScriptUnit.extension(arg_126_0, "death_system").death_has_started = true

				return var_126_2, var_0_0.IS_NOT_DONE
			end,
			update = function (arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4)
				local var_127_0 = Managers.state.network:network_time()

				if not arg_127_4.exploded then
					Unit.flow_event(arg_127_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_127_0, false)

					local var_127_1 = ScriptUnit.extension(arg_127_0, "health_system")

					if var_127_1.in_hand then
						if not var_127_1.thrown then
							local var_127_2 = POSITION_LOOKUP[arg_127_0]
							local var_127_3 = Unit.local_rotation(arg_127_0, 0)
							local var_127_4 = "explosive_barrel"
							local var_127_5 = var_127_1.item_name
							local var_127_6 = var_127_1.owner_unit

							Managers.state.entity:system("area_damage_system"):create_explosion(var_127_6, var_127_2, var_127_3, var_127_4, 1, var_127_5, nil, false)

							local var_127_7 = ScriptUnit.extension(var_127_6, "inventory_system")
							local var_127_8 = var_127_7:equipment().wielded_slot

							var_127_7:destroy_slot(var_127_8)
							var_127_7:wield_previous_weapon()
						end
					else
						local var_127_9 = POSITION_LOOKUP[arg_127_0]
						local var_127_10 = Unit.local_rotation(arg_127_0, 0)
						local var_127_11 = "explosive_barrel"
						local var_127_12 = var_127_1.item_name
						local var_127_13 = var_127_1.last_damage_data
						local var_127_14 = Managers.state.network:game_object_or_level_unit(var_127_13.attacker_unit_id, false) or arg_127_0

						Managers.state.entity:system("area_damage_system"):create_explosion(var_127_14, var_127_9, var_127_10, var_127_11, 1, var_127_12, nil, false)

						if var_127_14 then
							local var_127_15 = ScriptUnit.has_extension(var_127_14, "buff_system")

							if var_127_15 then
								var_127_15:trigger_procs("on_barrel_exploded", var_127_9, var_127_10, var_127_12, arg_127_0)
							end
						end
					end

					arg_127_4.exploded = true
				elseif var_127_0 >= arg_127_4.explode_time + 0.5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_127_0)

					return var_0_0.IS_DONE
				end
			end
		},
		husk = {
			pre_start = function (arg_128_0, arg_128_1, arg_128_2, arg_128_3)
				return
			end,
			start = function (arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4)
				local var_129_0 = Managers.state.network:network_time()
				local var_129_1 = {
					explode_time = var_129_0,
					killer_unit = arg_129_3[DamageDataIndex.ATTACKER]
				}
				local var_129_2 = ScriptUnit.has_extension(arg_129_0, "health_system").last_damage_data.attacker_unique_id
				local var_129_3 = Managers.player:player_from_unique_id(var_129_2)
				local var_129_4 = var_129_3 and var_129_3:stats_id()

				Managers.state.achievement:trigger_event("explosive_barrel_destroyed", var_129_4, arg_129_0, arg_129_3)

				ScriptUnit.extension(arg_129_0, "death_system").death_has_started = true

				return var_129_1, var_0_0.IS_NOT_DONE
			end,
			update = function (arg_130_0, arg_130_1, arg_130_2, arg_130_3, arg_130_4)
				local var_130_0 = Managers.state.network:network_time()

				if not arg_130_4.exploded then
					Unit.flow_event(arg_130_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_130_0, false)

					local var_130_1 = ScriptUnit.extension(arg_130_0, "health_system")

					if var_130_1.in_hand and not var_130_1.thrown then
						local var_130_2 = POSITION_LOOKUP[arg_130_0]
						local var_130_3 = Unit.local_rotation(arg_130_0, 0)
						local var_130_4 = "explosive_barrel"
						local var_130_5 = var_130_1.item_name
						local var_130_6 = var_130_1.owner_unit

						Managers.state.entity:system("area_damage_system"):create_explosion(var_130_6, var_130_2, var_130_3, var_130_4, 1, var_130_5, nil, false)

						local var_130_7 = ScriptUnit.extension(var_130_6, "inventory_system")
						local var_130_8 = var_130_7:equipment().wielded_slot

						var_130_7:destroy_slot(var_130_8)
						var_130_7:wield_previous_weapon()
					end

					arg_130_4.exploded = true
				elseif var_130_0 >= arg_130_4.explode_time + 0.5 then
					return var_0_0.IS_DONE
				end
			end
		}
	},
	nurgle_liquid_blob = {
		unit = {
			pre_start = function (arg_131_0, arg_131_1, arg_131_2, arg_131_3)
				return
			end,
			start = function (arg_132_0, arg_132_1, arg_132_2, arg_132_3, arg_132_4, arg_132_5)
				local var_132_0 = Managers.state.network:network_time()
				local var_132_1 = arg_132_5.extension_init_data.die_callback

				if var_132_1 then
					var_132_1()
				end

				local var_132_2 = arg_132_5.extension_init_data.shrink_and_despawn_time
				local var_132_3 = ScriptUnit.has_extension(arg_132_0, "buff_system")

				if var_132_3 then
					local var_132_4 = var_132_3:get_buff_type("bubonic_blob_buff")

					var_132_3:remove_buff(var_132_4.id)
				end

				local var_132_5 = {
					start_time = var_132_0,
					shrink_and_despawn_time = var_132_2
				}

				Unit.set_flow_variable(arg_132_0, "current_health", 0)
				Unit.flow_event(arg_132_0, "lua_on_death")

				local var_132_6 = Managers.player:local_player()
				local var_132_7 = var_132_6 and var_132_6.player_unit

				if var_132_7 and var_132_7 == arg_132_3[DamageDataIndex.ATTACKER] then
					Unit.flow_event(arg_132_0, "lua_local_player_killing_blow")
				end

				arg_132_5.death_has_started = true

				return var_132_5, var_0_0.IS_NOT_DONE
			end,
			update = function (arg_133_0, arg_133_1, arg_133_2, arg_133_3, arg_133_4)
				local var_133_0 = Managers.state.network:network_time()
				local var_133_1 = Unit.get_data(arg_133_0, "death_reaction_delay") or 0
				local var_133_2 = arg_133_4.start_time
				local var_133_3 = var_0_0.IS_NOT_DONE

				if var_133_0 >= var_133_2 + var_133_1 then
					if not arg_133_4.destroyed then
						local var_133_4 = Unit.num_actors(arg_133_0)

						for iter_133_0 = 0, var_133_4 - 1 do
							Unit.destroy_actor(arg_133_0, iter_133_0)
						end

						Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_133_0)

						local var_133_5 = Unit.local_position(arg_133_0, 0)
						local var_133_6 = Managers.state.entity:system("ai_system"):nav_world()
						local var_133_7 = LocomotionUtils.get_close_pos_below_on_mesh(var_133_6, var_133_5, 4, 1, 30)

						if not var_133_7 then
							local var_133_8 = "nurgle_liquid"
							local var_133_9 = LiquidAreaDamageTemplates.templates[var_133_8].hit_player_function
							local var_133_10 = Managers.state.side:sides()

							for iter_133_1 = 1, #var_133_10 do
								local var_133_11 = var_133_10[iter_133_1].PLAYER_AND_BOT_UNITS
								local var_133_12 = #var_133_11

								for iter_133_2 = 1, var_133_12 do
									local var_133_13 = var_133_11[iter_133_2]

									var_133_9(var_133_13, var_133_11)
								end
							end

							var_133_3 = var_0_0.IS_DONE
						else
							local var_133_14 = Unit.local_rotation(arg_133_0, 0)
							local var_133_15 = Quaternion.forward(var_133_14)
							local var_133_16 = Vector3.flat(var_133_15)
							local var_133_17 = {
								area_damage_system = {
									liquid_template = "nurgle_liquid",
									flow_dir = var_133_16,
									source_unit = arg_133_0
								}
							}
							local var_133_18 = "units/hub_elements/empty"
							local var_133_19 = Managers.state.unit_spawner:spawn_network_unit(var_133_18, "liquid_aoe_unit", var_133_17, var_133_7)

							ScriptUnit.extension(var_133_19, "area_damage_system"):ready()
						end

						arg_133_4.destroyed = true
					elseif arg_133_4.destroyed and var_133_0 >= var_133_2 + 0.5 then
						if arg_133_4.shrink_and_despawn_time then
							local var_133_20 = ScriptUnit.has_extension(arg_133_0, "props_system")
							local var_133_21 = arg_133_4.shrinking_state

							if not var_133_21 then
								arg_133_4.shrinking_state = "waiting"
							elseif var_133_21 == "waiting" then
								if var_133_0 >= var_133_2 + arg_133_4.shrink_and_despawn_time then
									var_133_20:setup(1, 0, 0.5)

									arg_133_4.shrinking_state = "shrinking"
								end
							elseif var_133_21 == "shrinking" and var_133_20:scaling_complete() then
								Managers.state.unit_spawner:mark_for_deletion(arg_133_0)

								var_133_3 = var_0_0.IS_DONE
							end
						else
							var_133_3 = var_0_0.IS_DONE
						end
					end

					return var_133_3
				end
			end
		},
		husk = {
			pre_start = function (arg_134_0, arg_134_1, arg_134_2, arg_134_3)
				return
			end,
			start = function (arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5)
				local var_135_0 = Managers.state.network:network_time()
				local var_135_1 = arg_135_5.extension_init_data.shrink_and_despawn_time
				local var_135_2 = {
					start_time = var_135_0,
					shrink_and_despawn_time = var_135_1
				}

				ScriptUnit.extension(arg_135_0, "death_system").death_has_started = true

				local var_135_3 = ScriptUnit.has_extension(arg_135_0, "buff_system")

				if var_135_3 then
					local var_135_4 = var_135_3:get_buff_type("bubonic_blob_buff")

					var_135_3:remove_buff(var_135_4.id)
				end

				local var_135_5 = Managers.player:local_player()
				local var_135_6 = var_135_5 and var_135_5.player_unit

				if var_135_6 and var_135_6 == arg_135_3[DamageDataIndex.ATTACKER] then
					Unit.flow_event(arg_135_0, "lua_local_player_killing_blow")
				end

				return var_135_2, var_0_0.IS_NOT_DONE
			end,
			update = function (arg_136_0, arg_136_1, arg_136_2, arg_136_3, arg_136_4)
				local var_136_0 = Managers.state.network:network_time()
				local var_136_1 = arg_136_4.start_time
				local var_136_2 = var_0_0.IS_NOT_DONE

				if not arg_136_4.destroyed then
					local var_136_3 = Unit.num_actors(arg_136_0)

					for iter_136_0 = 0, var_136_3 - 1 do
						Unit.destroy_actor(arg_136_0, iter_136_0)
					end

					Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_136_0)

					arg_136_4.destroyed = true
				elseif arg_136_4.destroyed and var_136_0 >= var_136_1 + 0.5 then
					if arg_136_4.shrink_and_despawn_time then
						local var_136_4 = ScriptUnit.has_extension(arg_136_0, "props_system")
						local var_136_5 = arg_136_4.shrinking_state

						if not var_136_5 then
							arg_136_4.shrinking_state = "waiting"
						elseif var_136_5 == "waiting" then
							if var_136_0 >= var_136_1 + arg_136_4.shrink_and_despawn_time then
								var_136_4:setup(1, 0, 0.5)

								arg_136_4.shrinking_state = "shrinking"
							end
						elseif var_136_5 == "shrinking" and var_136_4:scaling_complete() then
							var_136_2 = var_0_0.IS_DONE
						end
					else
						var_136_2 = var_0_0.IS_DONE
					end
				end

				return var_136_2
			end
		}
	},
	lamp_oil = {
		unit = {
			pre_start = function (arg_137_0, arg_137_1, arg_137_2, arg_137_3)
				return
			end,
			start = function (arg_138_0, arg_138_1, arg_138_2, arg_138_3, arg_138_4)
				local var_138_0 = Managers.state.network:network_time()
				local var_138_1 = {
					killer_unit = arg_138_3[DamageDataIndex.ATTACKER],
					start_time = var_138_0
				}

				ScriptUnit.extension(arg_138_0, "death_system").death_has_started = true

				return var_138_1, var_0_0.IS_NOT_DONE
			end,
			update = function (arg_139_0, arg_139_1, arg_139_2, arg_139_3, arg_139_4)
				local var_139_0 = Managers.state.network:network_time()
				local var_139_1 = arg_139_4.start_time
				local var_139_2 = var_0_0.IS_NOT_DONE

				if not arg_139_4.exploded then
					Unit.flow_event(arg_139_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_139_0, false)

					local var_139_3 = POSITION_LOOKUP[arg_139_0]
					local var_139_4 = Managers.state.entity:system("ai_system"):nav_world()
					local var_139_5 = LocomotionUtils.get_close_pos_below_on_mesh(var_139_4, var_139_3, 4)
					local var_139_6 = ScriptUnit.extension(arg_139_0, "health_system")
					local var_139_7 = var_139_6.last_damage_data
					local var_139_8 = Managers.state.network:game_object_or_level_unit(var_139_7.attacker_unit_id, false) or arg_139_0

					if not var_139_5 then
						Managers.state.unit_spawner:mark_for_deletion(arg_139_0)

						var_139_2 = var_0_0.IS_DONE
					else
						local var_139_9 = Unit.local_rotation(arg_139_0, 0)
						local var_139_10 = Quaternion.forward(var_139_9)
						local var_139_11 = Vector3.flat(var_139_10)
						local var_139_12 = {
							area_damage_system = {
								liquid_template = "lamp_oil_fire",
								flow_dir = var_139_11,
								source_unit = var_139_8
							}
						}
						local var_139_13 = "units/hub_elements/empty"
						local var_139_14 = Managers.state.unit_spawner:spawn_network_unit(var_139_13, "liquid_aoe_unit", var_139_12, var_139_5)

						ScriptUnit.extension(var_139_14, "area_damage_system"):ready()
					end

					if var_139_6.in_hand and not var_139_6.thrown then
						local var_139_15 = var_139_6.owner_unit
						local var_139_16 = ScriptUnit.extension(var_139_15, "inventory_system")
						local var_139_17 = var_139_16:equipment().wielded_slot

						var_139_16:destroy_slot(var_139_17)
						var_139_16:wield_previous_weapon()
					end

					arg_139_4.exploded = true
				elseif arg_139_4.exploded and var_139_0 >= var_139_1 + 0.5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_139_0)

					var_139_2 = var_0_0.IS_DONE
				end

				return var_139_2
			end
		},
		husk = {
			pre_start = function (arg_140_0, arg_140_1, arg_140_2, arg_140_3)
				return
			end,
			start = function (arg_141_0, arg_141_1, arg_141_2, arg_141_3, arg_141_4)
				local var_141_0 = Managers.state.network:network_time()
				local var_141_1 = {
					killer_unit = arg_141_3[DamageDataIndex.ATTACKER],
					start_time = var_141_0
				}

				ScriptUnit.extension(arg_141_0, "death_system").death_has_started = true

				return var_141_1, var_0_0.IS_NOT_DONE
			end,
			update = function (arg_142_0, arg_142_1, arg_142_2, arg_142_3, arg_142_4)
				local var_142_0 = Managers.state.network:network_time()
				local var_142_1 = arg_142_4.start_time
				local var_142_2 = var_0_0.IS_NOT_DONE

				if not arg_142_4.exploded then
					Unit.flow_event(arg_142_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_142_0, false)

					local var_142_3 = ScriptUnit.extension(arg_142_0, "health_system")

					if var_142_3.in_hand and not var_142_3.thrown then
						local var_142_4 = POSITION_LOOKUP[arg_142_0]
						local var_142_5 = Managers.state.entity:system("ai_system"):nav_world()
						local var_142_6 = LocomotionUtils.get_close_pos_below_on_mesh(var_142_5, var_142_4, 4)

						if not var_142_6 then
							var_142_2 = var_0_0.IS_DONE
						else
							local var_142_7 = Unit.local_rotation(arg_142_0, 0)
							local var_142_8 = Quaternion.forward(var_142_7)
							local var_142_9 = Vector3.flat(var_142_8)
							local var_142_10 = NetworkLookup.liquid_area_damage_templates.lamp_oil_fire
							local var_142_11 = Managers.state.network
							local var_142_12 = var_142_3.last_damage_data.attacker_unit_id or NetworkConstants.invalid_game_object_id

							var_142_11.network_transmit:send_rpc_server("rpc_create_liquid_damage_area", var_142_12, var_142_6, var_142_9, var_142_10)
						end

						local var_142_13 = var_142_3.owner_unit
						local var_142_14 = ScriptUnit.extension(var_142_13, "inventory_system")
						local var_142_15 = var_142_14:equipment().wielded_slot

						var_142_14:destroy_slot(var_142_15)
						var_142_14:wield_previous_weapon()
					end

					arg_142_4.exploded = true
				elseif arg_142_4.exploded and var_142_0 >= var_142_1 + 0.5 then
					var_142_2 = var_0_0.IS_DONE
				end

				return var_142_2
			end
		}
	},
	lure_unit = {
		unit = {
			pre_start = function (arg_143_0, arg_143_1, arg_143_2, arg_143_3)
				return
			end,
			start = function (arg_144_0, arg_144_1, arg_144_2, arg_144_3, arg_144_4)
				Managers.state.unit_spawner:mark_for_deletion(arg_144_0)

				return nil, var_0_0.IS_DONE
			end
		},
		husk = {
			pre_start = function (arg_145_0, arg_145_1, arg_145_2, arg_145_3)
				return
			end,
			start = function (arg_146_0, arg_146_1, arg_146_2, arg_146_3, arg_146_4)
				return nil, var_0_0.IS_DONE
			end
		}
	}
}
var_0_0.templates.minotaur = {
	unit = {
		pre_start = function (arg_147_0, arg_147_1, arg_147_2, arg_147_3)
			var_0_8(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
		end,
		start = function (arg_148_0, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
			local var_148_0 = arg_148_3[DamageDataIndex.ATTACKER]
			local var_148_1 = Managers.player:unit_owner(var_148_0)

			if var_148_1 then
				var_0_24(var_148_1, arg_148_0)
			end

			var_0_25(var_148_0)

			return var_0_0.templates.ai_default.unit.start(arg_148_0, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
		end,
		update = function (arg_149_0, arg_149_1, arg_149_2, arg_149_3, arg_149_4)
			return (var_0_13(arg_149_0, arg_149_1, arg_149_2, arg_149_3, arg_149_4))
		end
	},
	husk = {
		pre_start = function (arg_150_0, arg_150_1, arg_150_2, arg_150_3)
			var_0_14(arg_150_0, arg_150_1, arg_150_2, arg_150_3)
		end,
		start = function (arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
			return var_0_0.templates.ai_default.husk.start(arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
		end,
		update = function (arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4)
			return (var_0_17(arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4))
		end
	}
}
var_0_0.templates.gor = {
	unit = {
		pre_start = function (arg_153_0, arg_153_1, arg_153_2, arg_153_3)
			var_0_8(arg_153_0, arg_153_1, arg_153_2, arg_153_3)
		end,
		start = function (arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4)
			local var_154_0 = arg_154_3[DamageDataIndex.DAMAGE_TYPE]

			if var_154_0 == "warpfire" or var_154_0 == "warpfire_ground" then
				var_0_26()
			end

			return var_0_0.templates.ai_default.unit.start(arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4)
		end,
		update = function (arg_155_0, arg_155_1, arg_155_2, arg_155_3, arg_155_4)
			return (var_0_13(arg_155_0, arg_155_1, arg_155_2, arg_155_3, arg_155_4))
		end
	},
	husk = {
		pre_start = function (arg_156_0, arg_156_1, arg_156_2, arg_156_3)
			var_0_14(arg_156_0, arg_156_1, arg_156_2, arg_156_3)
		end,
		start = function (arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4)
			return var_0_0.templates.ai_default.husk.start(arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4)
		end,
		update = function (arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4)
			return (var_0_17(arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4))
		end
	}
}
var_0_0.templates.shadow_skull = table.clone(var_0_0.templates.ai_default)

var_0_0.templates.shadow_skull.unit.start = function (arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)
	local var_159_0, var_159_1 = var_0_0.templates.ai_default.unit.start(arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)

	ScriptUnit.extension(arg_159_0, "projectile_system"):destroy()
	ScriptUnit.extension(arg_159_0, "projectile_locomotion_system"):destroy()

	return var_159_0, var_159_1
end

var_0_0.templates.shadow_skull.husk.start = function (arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4)
	local var_160_0, var_160_1 = var_0_0.templates.ai_default.husk.start(arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4)

	ScriptUnit.extension(arg_160_0, "projectile_system"):destroy()
	ScriptUnit.extension(arg_160_0, "projectile_locomotion_system"):destroy()

	if var_0_3(arg_160_3) then
		Unit.flow_event(arg_160_0, "lua_on_death")
	end

	return var_160_0, var_160_1
end

var_0_0.templates.tower_homing_skull = table.clone(var_0_0.templates.ai_default)

var_0_0.templates.tower_homing_skull.unit.start = function (arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4)
	local var_161_0, var_161_1 = var_0_0.templates.ai_default.unit.start(arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4)

	var_161_0.despawn_after_time = arg_161_2 + 2.5

	ScriptUnit.extension(arg_161_0, "projectile_system"):destroy()
	ScriptUnit.extension(arg_161_0, "projectile_locomotion_system"):destroy()

	return var_161_0, var_161_1
end

var_0_0.templates.tower_homing_skull.unit.update = function (arg_162_0, arg_162_1, arg_162_2, arg_162_3, arg_162_4)
	if arg_162_3 > arg_162_4.despawn_after_time and not arg_162_4.marked_for_deletion then
		Managers.state.unit_spawner:mark_for_deletion(arg_162_0)

		arg_162_4.marked_for_deletion = true

		return var_0_0.IS_DONE
	end

	return var_0_0.IS_NOT_DONE
end

var_0_0.templates.tower_homing_skull.husk.start = function (arg_163_0, arg_163_1, arg_163_2, arg_163_3, arg_163_4)
	local var_163_0, var_163_1 = var_0_0.templates.ai_default.husk.start(arg_163_0, arg_163_1, arg_163_2, arg_163_3, arg_163_4)

	ScriptUnit.extension(arg_163_0, "projectile_system"):destroy()
	ScriptUnit.extension(arg_163_0, "projectile_locomotion_system"):destroy()

	if var_0_3(arg_163_3) then
		Unit.flow_event(arg_163_0, "lua_on_death")
	end

	return var_163_0, var_163_1
end

var_0_0.templates.destructible_ward = {
	unit = {
		pre_start = function (arg_164_0, arg_164_1, arg_164_2, arg_164_3)
			return
		end,
		start = function (arg_165_0, arg_165_1, arg_165_2, arg_165_3, arg_165_4)
			Managers.state.game_mode:level_object_killed(arg_165_0, arg_165_3)
			Unit.set_flow_variable(arg_165_0, "current_health", 0)
			Unit.flow_event(arg_165_0, "lua_on_death")
			Managers.state.entity:remove_extensions_from_unit(arg_165_0, {
				"WardExtension"
			})
		end,
		update = function (arg_166_0, arg_166_1, arg_166_2, arg_166_3, arg_166_4)
			return
		end
	},
	husk = {
		pre_start = function (arg_167_0, arg_167_1, arg_167_2, arg_167_3)
			return
		end,
		start = function (arg_168_0, arg_168_1, arg_168_2, arg_168_3, arg_168_4)
			Managers.state.game_mode:level_object_killed(arg_168_0, arg_168_3)
			Unit.flow_event(arg_168_0, "lua_on_death")
			Managers.state.entity:remove_extensions_from_unit(arg_168_0, {
				"WardExtension"
			})
		end,
		update = function (arg_169_0, arg_169_1, arg_169_2, arg_169_3, arg_169_4)
			return
		end
	}
}, DLCUtils.map_list("death_reactions", function (arg_170_0)
	return table.merge(var_0_0.templates, require(arg_170_0))
end)

var_0_0.get_reaction = function (arg_171_0, arg_171_1)
	local var_171_0 = var_0_0.templates
	local var_171_1 = arg_171_1 and "husk" or "unit"
	local var_171_2 = var_171_0[arg_171_0][var_171_1]

	fassert(var_171_2, "Death reaction for template %q and husk key %q does not exist", arg_171_0, var_171_1)

	return var_171_2
end

var_0_0._add_ai_killed_by_player_telemetry = function (arg_172_0, arg_172_1, arg_172_2, arg_172_3, arg_172_4, arg_172_5, arg_172_6)
	local var_172_0 = Managers.state.network.is_server
	local var_172_1 = POSITION_LOOKUP[arg_172_2]
	local var_172_2 = POSITION_LOOKUP[arg_172_0]

	Managers.telemetry_events:player_killed_ai(arg_172_3, var_172_1, var_172_2, arg_172_1, arg_172_5, arg_172_4, arg_172_6)
end
