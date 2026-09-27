-- chunkname: @scripts/unit_extensions/generic/death_reactions.lua

DeathReactions = {}
DeathReactions.IS_NOT_DONE = "not_done"
DeathReactions.IS_DONE = "done"

local DeathReactions = DeathReactions
local BLACKBOARDS = BLACKBOARDS
local tbl = {
	heavy = "fx/screenspace_blood_drops_heavy",
	blunt = "fx/screenspace_blood_drops"
}

local function fn(self)
	-- function 1
	return self[DamageDataIndex.DAMAGE_TYPE] == "sync_health"
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	local num = POSITION_LOOKUP[arg_2_1] + Vector3(0, 0, 1)
	local player = Managers.player
	local camera = Managers.state.camera

	for k, v in pairs(player:human_players()) do
		if not (v.remote or not script_data.disable_remote_blood_splatter or not Unit.alive(arg_2_2) or v ~= player:owner(arg_2_2)) then
			local viewport_name = v.viewport_name
			local camera_position = camera:camera_position(viewport_name)

			if (not (Vector3.distance_squared(camera_position, num) < 9) or not script_data.disable_behind_blood_splatter) and not camera:is_in_view(viewport_name, num) then
				local var_2_5 = tbl[arg_2_4]

				var_2_5 = var_2_5 or "fx/screenspace_blood_drops"

				Managers.state.blood:play_screen_space_blood(var_2_5, Vector3.zero())
			end
		end
	end
end

local function fn_3(self, arg_3_1)
	-- function 3
	local difficulty_kill_achievements = self.difficulty_kill_achievements

	if not difficulty_kill_achievements then
		for i = 1, #difficulty_kill_achievements do
			local var_3_1 = difficulty_kill_achievements[i]
			local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
			local player = Managers.player
			local num = 1

			while player:local_player(num) ~= nil do
				if num > 4 then
					ferror("Sanity check, how did we get above 4 here?")

					break
				end

				local local_player = player:local_player(num)

				if not (local_player.bot_player or not (get_difficulty_rank > arg_3_1:get_persistent_stat(local_player:stats_id(), var_3_1))) then
					arg_3_1:set_stat(local_player:stats_id(), var_3_1, get_difficulty_rank)
				end

				num = num + 1
			end
		end
	end
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	if not (arg_4_0 ~= "military_finish" or arg_4_1 ~= "chaos_warrior") then
		local tbl = {
			"military_statue_kill_chaos_warriors",
			"military_statue_kill_chaos_warriors_cata"
		}

		for i = 1, #tbl do
			if not QuestSettings.allowed_difficulties[tbl[i]][Managers.state.difficulty:get_difficulty()] then
				local local_player = Managers.player:local_player()

				if not local_player then
					local stats_id = local_player:stats_id()

					arg_4_2:increment_stat(stats_id, "military_statue_kill_chaos_warriors_session")

					if arg_4_2:get_stat(stats_id, "military_statue_kill_chaos_warriors_session") >= 3 then
						arg_4_2:increment_stat(stats_id, tbl[i])
						Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", NetworkLookup.statistics[tbl[i]])
					end
				end
			end
		end
	end
end

local function fn_5(arg_5_0, arg_5_1)
	-- function 5
	local conflict = Managers.state.conflict

	if conflict:count_units_by_breed_during_event("chaos_exalted_sorcerer_drachenfels") > 0 then
		local player = Managers.player
		local last_damage_data = ScriptUnit.has_extension(arg_5_1, "health_system").last_damage_data
		local owner = player:owner(arg_5_1)
		local attacker_unique_id = last_damage_data.attacker_unique_id
		local player_from_unique_id = player:player_from_unique_id(attacker_unique_id)

		if not (not player_from_unique_id and player_from_unique_id == owner) then
			local var_5_6 = conflict:alive_bosses()[1]

			if var_5_6 ~= arg_5_1 then
				BLACKBOARDS[var_5_6].no_kill_achievement = false
			end
		end
	end
end

local function fn_6(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local statistics_db = arg_6_1.statistics_db
	local breed = BLACKBOARDS[arg_6_0].breed
	local var_6_2 = arg_6_3[DamageDataIndex.DAMAGE_TYPE]

	StatisticsUtil.register_kill(arg_6_0, arg_6_3, statistics_db, true)
	fn_3(breed, statistics_db)
	fn_4(var_6_2, breed.name, statistics_db)
	fn_5(arg_6_3, arg_6_0)
	QuestSettings.handle_bastard_block_on_death(breed, arg_6_0, arg_6_3, statistics_db)

	local var_6_3 = arg_6_3[DamageDataIndex.ATTACKER]
	local get_actual_attacker_unit = AiUtils.get_actual_attacker_unit(var_6_3)
	local owner = Managers.player:owner(get_actual_attacker_unit)

	if not owner then
		local var_6_6 = arg_6_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_6_7 = arg_6_3[DamageDataIndex.HIT_ZONE]
		local name = breed.name

		DeathReactions._add_ai_killed_by_player_telemetry(arg_6_0, name, get_actual_attacker_unit, owner, var_6_2, var_6_6, var_6_7)
	end
end

local function fn_7(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local var_7_0 = arg_7_3[DamageDataIndex.SOURCE_ATTACKER_UNIT]

	var_7_0 = var_7_0 or arg_7_3[DamageDataIndex.ATTACKER]

	local var_7_1 = arg_7_3[DamageDataIndex.HIT_ZONE]
	local var_7_2 = arg_7_3[DamageDataIndex.DAMAGE_TYPE]
	local flag = arg_7_0 ~= var_7_0
	local var_7_4 = BLACKBOARDS[arg_7_0]
	local extension = ScriptUnit.extension(arg_7_0, "ai_system")
	local breed = var_7_4.breed

	if breed.disable_alert_friends_on_death or not flag then
		AiUtils.alert_nearby_friends_of_enemy(arg_7_0, var_7_4.group_blackboard.broadphase, var_7_0)
	end

	if not arg_7_4 and not breed.custom_death_enter_function then
		local var_7_7 = arg_7_3[DamageDataIndex.DAMAGE_SOURCE_NAME]

		breed.custom_death_enter_function(arg_7_0, var_7_0, var_7_2, var_7_1, arg_7_2, var_7_7)
	end

	extension:die(var_7_0, arg_7_3)

	local has_extension = ScriptUnit.has_extension(arg_7_0, "locomotion_system")

	if not has_extension then
		local unbox

		if not has_extension.death_velocity_boxed then
			unbox = has_extension.death_velocity_boxed:unbox()

			if not unbox then
				-- Nothing
			end
		end

		unbox = Vector3.zero()

		::label_7_0::

		has_extension:set_affected_by_gravity(false)
		has_extension:set_movement_type("script_driven")
		has_extension:set_wanted_velocity(unbox)
		Managers.state.entity:system("ai_navigation_system"):add_navbot_to_release(arg_7_0)
		has_extension:set_collision_disabled("death_reaction", true)
		has_extension:set_movement_type("disabled")
	end

	if breed.keep_weapon_on_death or not ScriptUnit.has_extension(arg_7_0, "ai_inventory_system") then
		Managers.state.entity:system("ai_inventory_system"):drop_item(arg_7_0)
	end

	local get_actual_attacker_unit = AiUtils.get_actual_attacker_unit(var_7_0)

	if not breed.no_blood then
		fn_2(arg_7_1.world, arg_7_0, get_actual_attacker_unit, arg_7_3, var_7_2)
	end

	if not breed.death_sound_event then
		local make_unit_auto_source, var_7_12 = WwiseUtils.make_unit_auto_source(arg_7_1.world, arg_7_0, Unit.node(arg_7_0, "c_head"))
		local extension_2 = ScriptUnit.extension(arg_7_0, "dialogue_system")
		local wwise_voice_switch_group = extension_2.wwise_voice_switch_group

		if not wwise_voice_switch_group then
			local wwise_voice_switch_value = extension_2.wwise_voice_switch_value

			WwiseWorld.set_switch(var_7_12, wwise_voice_switch_group, wwise_voice_switch_value, make_unit_auto_source)
		end

		local trigger_event = WwiseWorld.trigger_event(var_7_12, breed.death_sound_event, make_unit_auto_source)
		local has_extension_2 = ScriptUnit.has_extension(arg_7_0, "hit_reaction_system")

		if not has_extension_2 then
			has_extension_2:set_death_sound_event_id(trigger_event)
		end
	end

	local extension_3 = ScriptUnit.extension(arg_7_0, "death_system")
	local tbl = {
		breed = breed
	}
	local time_to_unspawn_after_death = breed.time_to_unspawn_after_death

	time_to_unspawn_after_death = time_to_unspawn_after_death or 3
	tbl.finish_time = arg_7_2 + time_to_unspawn_after_death
	tbl.wall_nail_data = extension_3.wall_nail_data

	local force_despawn = breed.force_despawn

	if not (not Managers.state.game_mode:has_activated_mutator("metal") and var_7_2 ~= "metal_mutator") then
		force_despawn = true
	end

	if not force_despawn then
		Managers.state.unit_spawner:mark_for_deletion(arg_7_0)
	elseif not breed.ignore_death_watch_timer then
		tbl.push_to_death_watch_timer = 0
	end

	Managers.state.game_mode:ai_killed(arg_7_0, get_actual_attacker_unit, tbl, arg_7_3)

	return tbl, DeathReactions.IS_NOT_DONE
end

local function fn_8(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local var_8_0, var_8_1 = fn_7(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_2 = BLACKBOARDS[arg_8_0]

	var_8_0.blackboard = var_8_2

	local tentacle_data = var_8_2.tentacle_data
	local boss_master_unit = var_8_2.boss_master_unit

	if not boss_master_unit and not Unit.alive(boss_master_unit) then
		local var_8_5 = BLACKBOARDS[boss_master_unit]

		var_8_5.num_portals_alive = var_8_5.num_portals_alive - 1
		var_8_5.tentacle_portal_units[arg_8_0] = nil
	end

	local breed = var_8_0.breed
	local node = Unit.node(arg_8_0, breed.sound_head_node)

	WwiseUtils.trigger_unit_event(arg_8_1.world, "Play_enemy_sorcerer_tentacle_death_vce", arg_8_0, node)
	WwiseUtils.trigger_unit_event(arg_8_1.world, "Stop_tentacle_movement", arg_8_0, node)

	local current_target = var_8_2.current_target

	if not Unit.alive(current_target) then
		var_8_2.tentacle_spline_extension:set_target("attack", current_target, tentacle_data.current_length)

		local var_8_9 = POSITION_LOOKUP[current_target]

		tentacle_data.last_target_pos:store(var_8_9)

		if tentacle_data.sub_state == "portal_hanging" then
			StatusUtils.set_grabbed_by_tentacle_status_network(current_target, "portal_release")

			tentacle_data.wait_for_release = arg_8_2 + breed.portal_release_time
			tentacle_data.sub_state = "portal_release"
		else
			tentacle_data.wait_for_release = arg_8_2

			StatusUtils.set_grabbed_by_tentacle_network(current_target, false, arg_8_0)
		end

		local str = "attack"
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_8_0)
		local unit_game_object_id_2 = network:unit_game_object_id(var_8_2.current_target)
		local var_8_14 = NetworkLookup.tentacle_template[str]
		local clamp = math.clamp(tentacle_data.current_length, 0, 31)

		network.network_transmit:send_rpc_clients("rpc_change_tentacle_state", unit_game_object_id, unit_game_object_id_2, var_8_14, clamp, arg_8_2)
	end

	return var_8_0, var_8_1
end

local function fn_9(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local blackboard = arg_9_4.blackboard
	local current_target = blackboard.current_target

	if not Unit.alive(current_target) then
		local tentacle_data = blackboard.tentacle_data

		if not tentacle_data.unit then
			local num = tentacle_data.current_length - 7 * arg_9_1

			tentacle_data.current_length = math.max(num, 0)

			blackboard.tentacle_spline_extension:set_target("attack", current_target, num)

			if not (num > 0 or not (arg_9_3 < tentacle_data.wait_for_release)) then
				return DeathReactions.IS_NOT_DONE
			else
				local portal_unit = tentacle_data.portal_unit

				AiUtils.kill_unit(portal_unit)
			end
		end

		if tentacle_data.sub_state == "portal_release" then
			StatusUtils.set_grabbed_by_tentacle_network(current_target, false, arg_9_0)
		end
	end

	Managers.state.unit_spawner:mark_for_deletion(arg_9_0)

	return DeathReactions.IS_DONE
end

local function fn_10(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	for k, v in pairs(arg_10_3.wall_nail_data) do
		local actor = Unit.actor(arg_10_0, k)

		if not actor and not Actor.is_physical(actor) then
			local world = Unit.world(arg_10_0)
			local position = Actor.position(actor)

			fassert(Vector3.is_valid(position), "Position from actor is not valid.")

			v.position = Vector3Box(position)

			local unbox = v.attack_direction:unbox()
			local num = 0.3
			local num_2 = v.hit_speed * num

			fassert(num_2 > 0, "Ray distance is not greater than 0")

			local str = "filter_weapon_nailing"
			local immediate_raycast = PhysicsWorld.immediate_raycast
			local get_data = World.get_data(world, "physics_world")
			local var_10_9 = position
			local var_10_10 = unbox
			local min

			if not arg_10_3.nailed then
				min = math.min(num_2, 0.4)

				if not min then
					-- Nothing
				end
			end

			min = num_2

			::label_10_0::

			local var_10_12, var_10_13, var_10_14, var_10_15, var_10_16 = immediate_raycast(get_data, var_10_9, var_10_10, min, "closest", "collision_filter", str)

			if not var_10_12 then
				Unit.disable_animation_state_machine(arg_10_0)
				Actor.set_kinematic(actor, true)
				Actor.set_collision_enabled(actor, false)

				local var_10_17 = Unit.get_data(arg_10_0, "breed").ragdoll_actor_thickness[k]
				local node = Actor.node(actor)

				Unit.scene_graph_link(arg_10_0, node, nil)

				v.node = node

				fassert(Vector3.is_valid(var_10_13), "Position from raycast is valid")

				v.target_position = Vector3Box(var_10_13 - unbox * var_10_17)
				v.start_t = arg_10_2
				v.end_t = arg_10_2 + math.max(var_10_14 / num_2 * num, 0.01)
				arg_10_3.finish_time = math.max(arg_10_3.finish_time, arg_10_2 + 30)
				arg_10_3.nailed = true
			else
				arg_10_3.wall_nail_data[k] = nil
			end
		elseif not actor and not arg_10_3.nailed then
			local node_2 = v.node
			local min_2 = math.min(math.auto_lerp(v.start_t, v.end_t, 0, 1, arg_10_2), 1)

			Unit.set_local_position(arg_10_0, node_2, Vector3.lerp(v.position:unbox(), v.target_position:unbox(), min_2))
		end
	end
end

local function fn_11(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	if not arg_11_4.remove then
		Managers.state.conflict:register_unit_destroyed(arg_11_0, BLACKBOARDS[arg_11_0], "death_done")

		return DeathReactions.IS_DONE
	end

	if not arg_11_4.finish_time then
		if arg_11_3 < arg_11_4.finish_time then
			if not next(arg_11_4.wall_nail_data) then
				fn_10(arg_11_0, arg_11_1, arg_11_3, arg_11_4)
			end
		else
			arg_11_4.finish_time = nil
		end
	end

	if not (not arg_11_4.push_to_death_watch_timer and not (arg_11_3 > arg_11_4.push_to_death_watch_timer)) then
		Managers.state.unit_spawner:push_unit_to_death_watch_list(arg_11_0, arg_11_3, arg_11_4)

		arg_11_4.push_to_death_watch_timer = nil
	end

	return DeathReactions.IS_NOT_DONE
end

local function fn_12(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local statistics_db = arg_12_1.statistics_db

	if not fn(arg_12_3) then
		StatisticsUtil.register_kill(arg_12_0, arg_12_3, statistics_db)
	end

	local get_data = Unit.get_data(arg_12_0, "breed")

	fn_3(get_data, statistics_db)

	local var_12_2 = arg_12_3[DamageDataIndex.ATTACKER]
	local get_actual_attacker_unit = AiUtils.get_actual_attacker_unit(var_12_2)
	local owner = Managers.player:owner(get_actual_attacker_unit)

	if not owner then
		local name = get_data.name
		local var_12_6 = arg_12_3[DamageDataIndex.DAMAGE_TYPE]
		local var_12_7 = arg_12_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_12_8 = arg_12_3[DamageDataIndex.HIT_ZONE]

		DeathReactions._add_ai_killed_by_player_telemetry(arg_12_0, name, get_actual_attacker_unit, owner, var_12_6, var_12_7, var_12_8)
	end
end

local function fn_13(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local var_13_0 = arg_13_3[DamageDataIndex.ATTACKER]
	local var_13_1 = arg_13_3[DamageDataIndex.DAMAGE_TYPE]
	local has_extension = ScriptUnit.has_extension(arg_13_0, "locomotion_system")

	if not has_extension then
		has_extension:set_mover_disable_reason("husk_death_reaction", true)
		has_extension:set_collision_disabled("husk_death_reaction", true)
	end

	local get_actual_attacker_unit = AiUtils.get_actual_attacker_unit(var_13_0)
	local get_data = Unit.get_data(arg_13_0, "breed")

	if not get_data.no_blood then
		fn_2(arg_13_1.world, arg_13_0, get_actual_attacker_unit, arg_13_3, var_13_1)
	end

	if not ScriptUnit.has_extension(arg_13_0, "ai_inventory_system") then
		Managers.state.entity:system("ai_inventory_system"):drop_item(arg_13_0)
	end

	if not (not get_data.death_sound_event and fn(arg_13_3)) then
		local make_unit_auto_source, var_13_6 = WwiseUtils.make_unit_auto_source(arg_13_1.world, arg_13_0, Unit.node(arg_13_0, "c_head"))
		local extension = ScriptUnit.extension(arg_13_0, "dialogue_system")
		local wwise_voice_switch_group = extension.wwise_voice_switch_group

		if not wwise_voice_switch_group then
			local wwise_voice_switch_value = extension.wwise_voice_switch_value

			WwiseWorld.set_switch(var_13_6, wwise_voice_switch_group, wwise_voice_switch_value, make_unit_auto_source)
		end

		local trigger_event = WwiseWorld.trigger_event(var_13_6, get_data.death_sound_event, make_unit_auto_source)
		local has_extension_2 = ScriptUnit.has_extension(arg_13_0, "hit_reaction_system")

		if not has_extension_2 then
			has_extension_2:set_death_sound_event_id(trigger_event)
		end
	end

	local extension_2 = ScriptUnit.extension(arg_13_0, "death_system")
	local tbl = {
		breed = get_data,
		finish_time = arg_13_2 + 3,
		wall_nail_data = extension_2.wall_nail_data
	}

	Managers.state.game_mode:ai_killed(arg_13_0, get_actual_attacker_unit, tbl, arg_13_3)

	return tbl, DeathReactions.IS_NOT_DONE
end

local function fn_14(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local var_14_0, var_14_1 = fn_13(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)

	if not fn(arg_14_3) then
		local breed = var_14_0.breed
		local node = Unit.node(arg_14_0, breed.sound_head_node)

		WwiseUtils.trigger_unit_event(arg_14_1.world, "Play_enemy_sorcerer_tentacle_death_vce", arg_14_0, node)
		WwiseUtils.trigger_unit_event(arg_14_1.world, "Stop_tentacle_movement", arg_14_0, node)
	end

	return var_14_0, var_14_1
end

local function fn_15(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	if not next(arg_15_4.wall_nail_data) then
		fn_10(arg_15_0, arg_15_1, arg_15_3, arg_15_4)

		return DeathReactions.IS_NOT_DONE
	elseif not (not (arg_15_3 < arg_15_4.finish_time) or arg_15_4.player_collided or arg_15_4.nailed) then
		return DeathReactions.IS_NOT_DONE
	end

	local has_extension = ScriptUnit.has_extension(arg_15_0, "locomotion_system")

	if not has_extension then
		has_extension:destroy()
	end

	return DeathReactions.IS_DONE
end

local function fn_16(arg_16_0, arg_16_1)
	-- function 16
	Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_16_1, arg_16_0)
end

local function fn_17(arg_17_0, arg_17_1)
	-- function 17
	Managers.state.entity:system("audio_system"):player_unit_sound_local(arg_17_1, arg_17_0)
end

local function fn_18(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	if not (not Unit.alive(arg_18_0) and Unit.alive(arg_18_1)) then
		return
	end

	if not Unit.has_animation_state_machine(arg_18_0) then
		if not Unit.has_data(arg_18_0, "enemy_dialogue_face_anim") then
			Unit.animation_event(arg_18_0, "talk_end")
		end

		if not Unit.has_data(arg_18_0, "enemy_dialogue_body_anim") then
			Unit.animation_event(arg_18_0, "talk_body_end")
		end
	end

	local has_extension = ScriptUnit.has_extension(arg_18_1, "dialogue_system")
	local owner = Managers.player:owner(arg_18_1)

	if not (not has_extension and owner == nil) then
		local str = "UNKNOWN"
		local get_data = Unit.get_data(arg_18_0, "breed")

		if not get_data then
			str = get_data.name
		elseif not ScriptUnit.has_extension(arg_18_0, "dialogue_system") then
			str = ScriptUnit.extension(arg_18_0, "dialogue_system").context.player_profile
		end

		if str == "skaven_rat_ogre" then
			local user_memory = has_extension.user_memory
			local times_killed_rat_ogre = user_memory.times_killed_rat_ogre

			times_killed_rat_ogre = times_killed_rat_ogre or 0
			user_memory.times_killed_rat_ogre = times_killed_rat_ogre + 1
		end

		local extension = ScriptUnit.extension(arg_18_1, "inventory_system")
		local get_wielded_slot_name = extension:get_wielded_slot_name()

		if not (get_wielded_slot_name == "slot_melee" or get_wielded_slot_name ~= "slot_ranged") then
			local alloc_table = FrameTable.alloc_table()

			alloc_table.killed_type = str
			alloc_table.enemy_tag = str
			alloc_table.hit_zone = arg_18_2
			alloc_table.weapon_slot = get_wielded_slot_name

			local get_slot_data = extension:get_slot_data(get_wielded_slot_name)

			if not get_slot_data then
				alloc_table.weapon_type = get_slot_data.item_data.item_type
			end

			local player_profile = has_extension.context.player_profile
			local var_18_11 = BLACKBOARDS[arg_18_0]
			local flag = not var_18_11 and var_18_11.optional_spawn_data

			if not (not flag and flag.prevent_killed_enemy_dialogue) then
				SurroundingAwareSystem.add_event(arg_18_1, "killed_enemy", DialogueSettings.default_view_distance, "killer_name", player_profile, "hit_zone", arg_18_2, "enemy_tag", str, "weapon_slot", get_wielded_slot_name)
			end

			local str_2 = "enemy_kill"

			ScriptUnit.extension_input(arg_18_1, "dialogue_system"):trigger_dialogue_event(str_2, alloc_table)
		end
	end
end

local function fn_19(arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = arg_19_1[DamageDataIndex.SOURCE_ATTACKER_UNIT]

	var_19_0 = var_19_0 or arg_19_1[DamageDataIndex.ATTACKER]

	local var_19_1 = ALIVE[var_19_0]

	var_19_1 = not var_19_1 and Unit.get_data(var_19_0, "breed")

	local var_19_2 = ALIVE[arg_19_0]

	var_19_2 = not var_19_2 and Unit.get_data(arg_19_0, "breed")

	local unit_owner = Managers.player:unit_owner(var_19_0)
	local flag = not var_19_1 and var_19_1.is_player
	local flag_2 = not var_19_2 and var_19_2.is_player

	if not (not flag and flag_2) then
		return
	end

	local side = Managers.state.side
	local owner = Managers.player:owner(var_19_0)
	local flag_3 = not owner and owner.bot_player

	if not (not side:is_enemy(arg_19_0, var_19_0) and owner.remote or flag_3) then
		local wwise_world = Managers.world:wwise_world(arg_19_2)

		if not side:versus_is_hero(var_19_0) then
			WwiseWorld.trigger_event(wwise_world, "versus_hud_hero_player_special_kill")
		elseif not side:versus_is_dark_pact(var_19_0) then
			WwiseWorld.trigger_event(wwise_world, "generic_pactsworn_death")
		end
	end
end

local function fn_20(arg_20_0, arg_20_1)
	-- function 20
	if not Managers.state.network.is_server then
		return
	end

	local system = Managers.state.entity:system("dialogue_system")
	local side = Managers.state.side
	local versus_is_dark_pact = side:versus_is_dark_pact(arg_20_0)
	local PLAYER_UNITS = side.side_by_unit[arg_20_0].PLAYER_UNITS

	if not versus_is_dark_pact then
		local flag = false

		for i = 1, #PLAYER_UNITS do
			if not HEALTH_ALIVE[PLAYER_UNITS[i]] then
				flag = true

				break
			end
		end

		if not flag then
			system:queue_mission_giver_event("vs_mg_pactsworn_wipe")
		end
	end
end

local function fn_21(arg_21_0, arg_21_1)
	-- function 21
	local var_21_0 = arg_21_1[DamageDataIndex.SOURCE_ATTACKER_UNIT]

	var_21_0 = var_21_0 or arg_21_1[DamageDataIndex.ATTACKER]

	if not (not Unit.alive(var_21_0) and Unit.alive(arg_21_0)) then
		return
	end

	local get_data = Unit.get_data(var_21_0, "breed")
	local get_data_2 = Unit.get_data(arg_21_0, "breed")

	Managers.state.event:trigger("on_killed", arg_21_1, get_data_2, get_data, var_21_0, arg_21_0)

	if not (not get_data and not get_data.is_player and get_data_2) then
		return
	end

	local side = Managers.state.side

	if not side:is_enemy(var_21_0, arg_21_0) then
		return
	end

	Managers.state.event:trigger("on_player_killed_enemy", arg_21_1, get_data_2, arg_21_0)

	local has_extension = ScriptUnit.has_extension(var_21_0, "buff_system")

	if not has_extension then
		has_extension:trigger_procs("on_kill", arg_21_1, get_data_2, arg_21_0)
	end

	if get_data_2.special or not get_data_2.elite or not has_extension then
		has_extension:trigger_procs("on_kill_elite_special", arg_21_1, get_data_2, arg_21_0)
	end

	local var_21_5 = side.side_by_unit[arg_21_0]

	if not get_data_2.elite then
		local ENEMY_PLAYER_AND_BOT_UNITS = var_21_5.ENEMY_PLAYER_AND_BOT_UNITS

		for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
			local var_21_7 = ENEMY_PLAYER_AND_BOT_UNITS[i]
			local has_extension_2 = ScriptUnit.has_extension(var_21_7, "buff_system")

			if not has_extension_2 then
				has_extension_2:trigger_procs("on_elite_killed", arg_21_1, get_data_2, arg_21_0)
			end
		end
	end

	if not get_data_2.boss then
		local ENEMY_PLAYER_AND_BOT_UNITS_2 = var_21_5.ENEMY_PLAYER_AND_BOT_UNITS

		for j = 1, #ENEMY_PLAYER_AND_BOT_UNITS_2 do
			local var_21_10 = ENEMY_PLAYER_AND_BOT_UNITS_2[j]
			local has_extension_3 = ScriptUnit.has_extension(var_21_10, "buff_system")

			if not has_extension_3 then
				has_extension_3:trigger_procs("on_boss_killed", arg_21_1, get_data_2)
			end
		end
	end

	if not get_data_2.special then
		local ENEMY_PLAYER_AND_BOT_UNITS_3 = var_21_5.ENEMY_PLAYER_AND_BOT_UNITS

		for k = 1, #ENEMY_PLAYER_AND_BOT_UNITS_3 do
			local var_21_13 = ENEMY_PLAYER_AND_BOT_UNITS_3[k]
			local has_extension_4 = ScriptUnit.has_extension(var_21_13, "buff_system")

			if not has_extension_4 then
				has_extension_4:trigger_procs("on_special_killed", arg_21_1, get_data_2, arg_21_0)
			end
		end
	end

	if not ScriptUnit.has_extension(arg_21_0, "ping_system") then
		local ENEMY_PLAYER_AND_BOT_UNITS_4 = var_21_5.ENEMY_PLAYER_AND_BOT_UNITS

		for l = 1, #ENEMY_PLAYER_AND_BOT_UNITS_4 do
			local var_21_16 = ENEMY_PLAYER_AND_BOT_UNITS_4[l]
			local has_extension_5 = ScriptUnit.has_extension(var_21_16, "buff_system")

			if not has_extension_5 then
				has_extension_5:trigger_procs("on_pingable_target_killed", arg_21_1, get_data_2)
			end
		end
	end
end

local function fn_22(arg_22_0, arg_22_1)
	-- function 22
	if not Managers.player.is_server then
		local level_key = Managers.state.game_mode:level_key()
		local display_name = LevelSettings[level_key].display_name
		local display_name_2 = LevelSettings.farmlands.display_name
		local str = "dlc_scorpion_field"

		if not (display_name == display_name_2 or display_name == str) then
			return
		end

		local var_22_4 = POSITION_LOOKUP[arg_22_1]
		local var_22_5 = Vector3(18.843, -117.7, 5.5)

		if Vector3.distance(var_22_5, var_22_4) < 35 then
			local str_2 = "scorpion_kill_minotaur_farmlands_oak"

			Managers.player:statistics_db():increment_stat_and_sync_to_clients(str_2)
		end
	end
end

local function fn_23(arg_23_0)
	-- function 23
	local var_23_0 = BLACKBOARDS[arg_23_0]

	if not var_23_0 then
		local breed = var_23_0.breed

		breed = not breed and var_23_0.breed.name

		if breed ~= "beastmen_ungor_archer" then
			return
		end

		local str = "scorpion_kill_archers_kill_minotaur"
		local var_23_3 = NetworkLookup.statistics[str]

		Managers.player:statistics_db():increment_stat_and_sync_to_clients("scorpion_kill_archers_kill_minotaur")
	end
end

local function fn_24()
	-- function 24
	local statistics_db = Managers.player:statistics_db()

	statistics_db:increment_local_stat("warpfire_killed_gors")

	if statistics_db:get_local_stat("warpfire_killed_gors") >= QuestSettings.num_gors_killed_by_warpfire then
		statistics_db:set_local_stat("warpfire_killed_gors", 0)
		statistics_db:increment_stat_and_sync_to_clients("scorpion_slay_gors_warpfire_damage")
	end
end

local tbl_2 = {}

DeathReactions.templates = {
	ai_default = {
		unit = {
			pre_start = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				fn_6(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			end,
			start = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				-- function 26
				local var_26_0, var_26_1 = fn_7(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)

				fn_18(arg_26_0, arg_26_3[DamageDataIndex.ATTACKER], arg_26_3[DamageDataIndex.HIT_ZONE], arg_26_3[DamageDataIndex.DAMAGE_TYPE])
				fn_21(arg_26_0, arg_26_3)
				Managers.state.entity:system("play_go_tutorial_system"):register_killing_blow(arg_26_3[DamageDataIndex.DAMAGE_TYPE], arg_26_3[DamageDataIndex.ATTACKER])

				if arg_26_0 == arg_26_3[DamageDataIndex.ATTACKER] or not ScriptUnit.has_extension(arg_26_0, "ai_system") then
					ScriptUnit.extension(arg_26_0, "ai_system"):attacked(arg_26_3[DamageDataIndex.ATTACKER], arg_26_2, arg_26_3)
				end

				local var_26_2 = arg_26_3[DamageDataIndex.ATTACKER]

				Managers.state.game_mode:ai_hit_by_player(arg_26_0, var_26_2, arg_26_3)

				return var_26_0, var_26_1
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				return (fn_11(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4))
			end
		},
		husk = {
			pre_start = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				fn_12(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
			end,
			start = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				-- function 29
				local var_29_0, var_29_1 = fn_13(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)

				if not fn(arg_29_3) then
					fn_21(arg_29_0, arg_29_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_29_0, arg_29_2, var_29_0)

				local var_29_2 = arg_29_3[DamageDataIndex.ATTACKER]

				Managers.state.game_mode:ai_hit_by_player(arg_29_0, var_29_2, arg_29_3)

				return var_29_0, var_29_1
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				return (fn_15(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4))
			end
		}
	},
	chaos_tentacle = {
		unit = {
			pre_start = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				fn_6(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			end,
			start = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				-- function 32
				local var_32_0, var_32_1 = fn_8(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)

				fn_18(arg_32_0, arg_32_3[DamageDataIndex.ATTACKER], arg_32_3[DamageDataIndex.HIT_ZONE], arg_32_3[DamageDataIndex.DAMAGE_TYPE])
				fn_21(arg_32_0, arg_32_3)

				return var_32_0, var_32_1
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				-- function 33
				return (fn_9(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4))
			end
		},
		husk = {
			pre_start = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				fn_12(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
			end,
			start = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				-- function 35
				local var_35_0, var_35_1 = fn_14(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)

				if not fn(arg_35_3) then
					fn_21(arg_35_0, arg_35_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_35_0, arg_35_2, var_35_0)

				return var_35_0, var_35_1
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				-- function 36
				return DeathReactions.IS_DONE
			end
		}
	},
	chaos_tentacle_portal = {
		unit = {
			pre_start = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				return
			end,
			start = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				-- function 38
				Unit.flow_event(arg_38_0, "kill_portal")

				local node = Unit.node(arg_38_0, "a_surface_center")

				WwiseUtils.trigger_unit_event(arg_38_1.world, "Play_enemy_sorcerer_portal_explode", arg_38_0, node)

				return {
					despawn_after_time = arg_38_2 + 4.2
				}, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				-- function 39
				if arg_39_3 > arg_39_4.despawn_after_time then
					Managers.state.unit_spawner:mark_for_deletion(arg_39_0)

					return DeathReactions.IS_DONE
				end

				return DeathReactions.IS_NOT_DONE
			end
		},
		husk = {
			pre_start = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				return
			end,
			start = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				-- function 41
				if not fn(arg_41_3) then
					Unit.flow_event(arg_41_0, "kill_portal")

					local node = Unit.node(arg_41_0, "a_surface_center")

					WwiseUtils.trigger_unit_event(arg_41_1.world, "Play_enemy_sorcerer_portal_explode", arg_41_0, node)
				end

				return nil, DeathReactions.IS_DONE
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				-- function 42
				return DeathReactions.IS_DONE
			end
		}
	},
	storm_vermin_champion = {
		unit = {
			pre_start = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
				fn_6(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
			end,
			start = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				-- function 44
				local var_44_0, var_44_1 = fn_7(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)

				fn_18(arg_44_0, arg_44_3[DamageDataIndex.ATTACKER], arg_44_3[DamageDataIndex.HIT_ZONE], arg_44_3[DamageDataIndex.DAMAGE_TYPE])
				fn_21(arg_44_0, arg_44_3)

				if arg_44_0 == arg_44_3[DamageDataIndex.ATTACKER] or not ScriptUnit.has_extension(arg_44_0, "ai_system") then
					ScriptUnit.extension(arg_44_0, "ai_system"):attacked(arg_44_3[DamageDataIndex.ATTACKER], arg_44_2, arg_44_3)
				end

				local var_44_2 = BLACKBOARDS[arg_44_0]

				if not var_44_2.ward_active then
					AiUtils.stormvermin_champion_set_ward_state(arg_44_0, false, true)

					var_44_2.ward_active = false
				end

				return var_44_0, var_44_1
			end,
			update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				-- function 45
				return (fn_11(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4))
			end
		},
		husk = {
			pre_start = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				-- function 46
				fn_12(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
			end,
			start = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				-- function 47
				local var_47_0, var_47_1 = fn_13(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)

				if not fn(arg_47_3) then
					fn_21(arg_47_0, arg_47_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_47_0, arg_47_2, var_47_0)

				return var_47_0, var_47_1
			end,
			update = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
				-- function 48
				return (fn_15(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4))
			end
		}
	},
	gutter_runner = {
		unit = {
			pre_start = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				-- function 49
				fn_6(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
			end,
			start = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
				-- function 50
				local var_50_0, var_50_1 = fn_7(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)

				var_50_0.despawn_after_time = arg_50_2 + 2

				fn_18(arg_50_0, arg_50_3[DamageDataIndex.ATTACKER], arg_50_3[DamageDataIndex.HIT_ZONE], arg_50_3[DamageDataIndex.DAMAGE_TYPE])
				fn_21(arg_50_0, arg_50_3)

				return var_50_0, var_50_1
			end,
			update = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
				-- function 51
				if not (not arg_51_4.despawn_after_time and not (arg_51_3 > arg_51_4.despawn_after_time)) then
					Managers.state.unit_spawner:mark_for_deletion(arg_51_0)

					return DeathReactions.IS_DONE
				end

				return DeathReactions.IS_NOT_DONE
			end
		},
		husk = {
			pre_start = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
				-- function 52
				fn_12(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
			end,
			start = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
				-- function 53
				local var_53_0, var_53_1 = fn_13(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)

				if not fn(arg_53_3) then
					fn_21(arg_53_0, arg_53_3)
				end

				local has_extension = ScriptUnit.has_extension(arg_53_0, "locomotion_system")

				if not has_extension then
					has_extension:destroy()
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_53_0, arg_53_2, var_53_0)

				return nil, DeathReactions.IS_DONE
			end,
			update = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
				-- function 54
				return DeathReactions.IS_DONE
			end
		}
	},
	poison_globadier = {
		unit = {
			pre_start = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
				-- function 55
				fn_6(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
			end,
			start = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
				-- function 56
				local var_56_0 = BLACKBOARDS[arg_56_0]

				if Unit.get_data(arg_56_0, "breed").name == "skaven_poison_wind_globadier" then
					printf("[HON-43348] Globadier (%s) inside death reaction. Playing sound.", Unit.get_data(arg_56_0, "globadier_43348"))
				end

				fn_17(arg_56_0, "Stop_enemy_foley_globadier_boiling_loop")

				if arg_56_0 == arg_56_3[DamageDataIndex.ATTACKER] or not ScriptUnit.has_extension(arg_56_0, "ai_system") then
					ScriptUnit.extension(arg_56_0, "ai_system"):attacked(arg_56_3[DamageDataIndex.ATTACKER], arg_56_2, arg_56_3)
				end

				if var_56_0.suicide_run == nil or not var_56_0.suicide_run.explosion_started then
					local action = var_56_0.suicide_run.action

					AiUtils.poison_explode_unit(arg_56_0, action, var_56_0)
					fn_7(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)

					local str = "Play_enemy_combat_globadier_suicide_explosion"

					fn_16(arg_56_0, str)
					fn_18(arg_56_0, arg_56_3[DamageDataIndex.ATTACKER], arg_56_3[DamageDataIndex.HIT_ZONE], arg_56_3[DamageDataIndex.DAMAGE_TYPE])
					fn_21(arg_56_0, arg_56_3)

					return nil, DeathReactions.IS_DONE
				else
					local var_56_3, var_56_4 = fn_7(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)

					var_56_3.blackboard = var_56_0

					fn_18(arg_56_0, arg_56_3[DamageDataIndex.ATTACKER], arg_56_3[DamageDataIndex.HIT_ZONE], arg_56_3[DamageDataIndex.DAMAGE_TYPE])
					fn_21(arg_56_0, arg_56_3)

					return var_56_3, var_56_4
				end
			end,
			update = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
				-- function 57
				local blackboard = arg_57_4.blackboard
				local var_57_1

				if blackboard.suicide_run == nil or not blackboard.suicide_run.explosion_started then
					var_57_1 = DeathReactions.IS_DONE
				else
					var_57_1 = fn_11(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
				end

				return var_57_1
			end
		},
		husk = {
			pre_start = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
				-- function 58
				fn_12(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
			end,
			start = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
				-- function 59
				local var_59_0, var_59_1 = fn_13(arg_59_0, arg_59_1, arg_59_2, arg_59_3)

				fn_17(arg_59_0, "Stop_enemy_foley_globadier_boiling_loop")

				if not fn(arg_59_3) then
					fn_18(arg_59_0, arg_59_3[DamageDataIndex.ATTACKER], arg_59_3[DamageDataIndex.HIT_ZONE], arg_59_3[DamageDataIndex.DAMAGE_TYPE])
					fn_21(arg_59_0, arg_59_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_59_0, arg_59_2, var_59_0)

				return var_59_0, var_59_1
			end,
			update = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
				-- function 60
				return (fn_15(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4))
			end
		}
	},
	chaos_zombie = {
		unit = {
			pre_start = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
				-- function 61
				fn_6(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
			end,
			start = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
				-- function 62
				local var_62_0 = BLACKBOARDS[arg_62_0]

				if arg_62_0 == arg_62_3[DamageDataIndex.ATTACKER] or not ScriptUnit.has_extension(arg_62_0, "ai_system") then
					ScriptUnit.extension(arg_62_0, "ai_system"):attacked(arg_62_3[DamageDataIndex.ATTACKER], arg_62_2, arg_62_3)
				end

				fn_7(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)

				local extension = ScriptUnit.extension(arg_62_0, "ai_inventory_system")

				if arg_62_3[DamageDataIndex.HIT_ZONE] == extension.inventory_weak_spot or not var_62_0.explosion_finished then
					local explosion_attack = BreedActions.chaos_zombie.explosion_attack

					AiUtils.chaos_zombie_explosion(arg_62_0, explosion_attack, var_62_0, true)

					return nil, DeathReactions.IS_DONE
				else
					Managers.state.network:anim_event(arg_62_0, "death_backward")

					local var_62_3 = POSITION_LOOKUP[arg_62_0]
					local var_62_4 = Vector3(0, 4, 1)
					local num = 1

					Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_62_3, "cylinder", var_62_4, nil, num, "Chaos Zombie")

					return nil, DeathReactions.IS_NOT_DONE
				end
			end,
			update = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
				-- function 63
				local var_63_0 = BLACKBOARDS[arg_63_0]
				local var_63_1

				if not var_63_0.anim_cb_death_finished then
					local explosion_attack = BreedActions.chaos_zombie.explosion_attack

					AiUtils.chaos_zombie_explosion(arg_63_0, explosion_attack, var_63_0, true)

					var_63_1 = DeathReactions.IS_DONE
				elseif not var_63_0.explosion_finished then
					var_63_1 = DeathReactions.IS_DONE
				end

				return var_63_1
			end
		},
		husk = {
			pre_start = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
				-- function 64
				fn_12(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
			end,
			start = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
				-- function 65
				local var_65_0, var_65_1 = fn_13(arg_65_0, arg_65_1, arg_65_2, arg_65_3)

				Managers.state.unit_spawner:freeze_unit_extensions(arg_65_0, arg_65_2, var_65_0)

				return var_65_0, var_65_1
			end,
			update = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4)
				-- function 66
				return (fn_15(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4))
			end
		}
	},
	warpfire_thrower = {
		unit = {
			pre_start = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
				-- function 67
				fn_6(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
			end,
			start = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4)
				-- function 68
				local var_68_0 = BLACKBOARDS[arg_68_0]

				if arg_68_0 == arg_68_3[DamageDataIndex.ATTACKER] or not ScriptUnit.has_extension(arg_68_0, "ai_system") then
					ScriptUnit.extension(arg_68_0, "ai_system"):attacked(arg_68_3[DamageDataIndex.ATTACKER], arg_68_2, arg_68_3)
				end

				local var_68_1, var_68_2 = fn_7(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4)

				fn_18(arg_68_0, arg_68_3[DamageDataIndex.ATTACKER], arg_68_3[DamageDataIndex.HIT_ZONE], arg_68_3[DamageDataIndex.DAMAGE_TYPE])
				fn_21(arg_68_0, arg_68_3)
				WwiseUtils.trigger_unit_event(Managers.world:world("level_world"), "Stop_enemy_vo_warpfire", arg_68_0, Unit.node(arg_68_0, "a_voice"))

				if arg_68_3[DamageDataIndex.HIT_ZONE] == "aux" then
					AiUtils.warpfire_explode_unit(arg_68_0, var_68_0)

					var_68_0.explode_on_death = true

					return var_68_1, DeathReactions.IS_NOT_DONE
				else
					var_68_1.blackboard = var_68_0

					return var_68_1, var_68_2
				end
			end,
			update = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
				-- function 69
				local var_69_0 = BLACKBOARDS[arg_69_0]
				local var_69_1

				if not var_69_0.explode_on_death then
					local actor = Unit.actor(arg_69_0, "j_backpack")

					if not actor then
						var_69_1 = DeathReactions.IS_DONE

						Actor.set_collision_enabled(actor, false)
						Actor.set_scene_query_enabled(actor, false)
					else
						var_69_1 = DeathReactions.IS_NOT_DONE
					end

					fn_11(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
				else
					var_69_1 = fn_11(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
				end

				return var_69_1
			end
		},
		husk = {
			pre_start = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
				-- function 70
				fn_12(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
			end,
			start = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
				-- function 71
				local var_71_0, var_71_1 = fn_13(arg_71_0, arg_71_1, arg_71_2, arg_71_3)

				if arg_71_3[DamageDataIndex.HIT_ZONE] == "aux" then
					Unit.flow_event(arg_71_0, "lua_hide_backpack")

					ScriptUnit.extension(arg_71_0, "death_system").actor_to_disable_on_death = "j_backpack"
				end

				if not fn(arg_71_3) then
					fn_18(arg_71_0, arg_71_3[DamageDataIndex.ATTACKER], arg_71_3[DamageDataIndex.HIT_ZONE], arg_71_3[DamageDataIndex.DAMAGE_TYPE])
					fn_21(arg_71_0, arg_71_3)
				end

				WwiseUtils.trigger_unit_event(Managers.world:world("level_world"), "Stop_enemy_vo_warpfire", arg_71_0, Unit.node(arg_71_0, "a_voice"))
				Managers.state.unit_spawner:freeze_unit_extensions(arg_71_0, arg_71_2, var_71_0)

				return var_71_0, var_71_1
			end,
			update = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4)
				-- function 72
				fn_15(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4)

				local extension = ScriptUnit.extension(arg_72_0, "death_system")
				local var_72_1

				if not extension.actor_to_disable_on_death then
					local actor = Unit.actor(arg_72_0, extension.actor_to_disable_on_death)

					if not actor then
						var_72_1 = DeathReactions.IS_DONE

						Actor.set_collision_enabled(actor, false)
						Actor.set_scene_query_enabled(actor, false)
					else
						var_72_1 = DeathReactions.IS_NOT_DONE
					end
				else
					var_72_1 = DeathReactions.IS_DONE
				end

				return var_72_1
			end
		}
	},
	loot_rat = {
		unit = {
			pre_start = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
				-- function 73
				fn_6(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
			end,
			start = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
				-- function 74
				local var_74_0, var_74_1 = fn_7(arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)

				fn_18(arg_74_0, arg_74_3[DamageDataIndex.ATTACKER], arg_74_3[DamageDataIndex.HIT_ZONE], arg_74_3[DamageDataIndex.DAMAGE_TYPE])
				fn_21(arg_74_0, arg_74_3)

				local random = math.random(2, 4)

				for i = 1, random do
					local random_2 = math.random()
					local game_mode = Managers.state.game_mode
					local game_mode_key = game_mode:game_mode_key()
					local var_74_6 = LootRatPickups[game_mode_key]

					var_74_6 = var_74_6 or LootRatPickups.default

					local num = 0

					for k, v in pairs(var_74_6) do
						table.clear(tbl_2)

						if k == "boss_loot" then
							k = game_mode:get_boss_loot_pickup()
						end

						local dice_keeper = arg_74_1.dice_keeper
						local var_74_9 = AllPickups[k]
						local flag = not var_74_9 and var_74_9.can_spawn_func
						local flag_2 = var_74_9 ~= nil

						tbl_2.dice_keeper = dice_keeper

						if not (not flag and flag(tbl_2)) then
							flag_2 = false
						end

						num = num + v

						if not (random_2 <= num) or not flag_2 then
							local get_data = Unit.get_data(arg_74_0, "breed")
							local flag_3 = not get_data and get_data.name
							local tbl = {
								pickup_system = {
									has_physics = true,
									spawn_type = "loot",
									pickup_name = k,
									dropped_by_breed = flag_3
								}
							}
							local unit_name = var_74_9.unit_name
							local unit_template_name = var_74_9.unit_template_name

							unit_template_name = unit_template_name or "pickup_unit"

							local num_2 = POSITION_LOOKUP[arg_74_0] + Vector3(math.random() - 0.5, math.random() - 0.5, 1)
							local var_74_18 = Quaternion(Vector3.right(), math.random() * 2 * math.pi)

							Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, num_2, var_74_18)

							if k == "loot_die" then
								dice_keeper:bonus_dice_spawned()
							end

							break
						end
					end
				end

				if arg_74_0 == arg_74_3[DamageDataIndex.ATTACKER] or not ScriptUnit.has_extension(arg_74_0, "ai_system") then
					ScriptUnit.extension(arg_74_0, "ai_system"):attacked(arg_74_3[DamageDataIndex.ATTACKER], arg_74_2, arg_74_3)
				end

				return var_74_0, var_74_1
			end,
			update = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4)
				-- function 75
				return (fn_11(arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4))
			end
		},
		husk = {
			pre_start = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
				-- function 76
				fn_12(arg_76_0, arg_76_1, arg_76_2, arg_76_3)
			end,
			start = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
				-- function 77
				local var_77_0, var_77_1 = fn_13(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)

				if not fn(arg_77_3) then
					fn_18(arg_77_0, arg_77_3[DamageDataIndex.ATTACKER], arg_77_3[DamageDataIndex.HIT_ZONE], arg_77_3[DamageDataIndex.DAMAGE_TYPE])
					fn_21(arg_77_0, arg_77_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_77_0, arg_77_2, var_77_0)

				return var_77_0, var_77_1
			end,
			update = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
				-- function 78
				return (fn_15(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4))
			end
		}
	},
	explosive_loot_rat = {
		unit = {
			pre_start = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
				-- function 79
				fn_6(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
			end,
			start = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
				-- function 80
				local var_80_0, var_80_1 = fn_7(arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4)

				fn_18(arg_80_0, arg_80_3[DamageDataIndex.ATTACKER], arg_80_3[DamageDataIndex.HIT_ZONE], arg_80_3[DamageDataIndex.DAMAGE_TYPE])
				fn_21(arg_80_0, arg_80_3)
				AiUtils.loot_rat_explosion(arg_80_0, arg_80_0, BLACKBOARDS[arg_80_0], nil, ExplosionUtils.get_template("loot_rat_explosion"))

				if arg_80_0 == arg_80_3[DamageDataIndex.ATTACKER] or not ScriptUnit.has_extension(arg_80_0, "ai_system") then
					ScriptUnit.extension(arg_80_0, "ai_system"):attacked(arg_80_3[DamageDataIndex.ATTACKER], arg_80_2, arg_80_3)
				end

				if 0.2 >= math.random() then
					local str = "all_ammo_small"
					local var_80_3 = AllPickups[str]
					local tbl = {
						pickup_system = {
							has_physics = false,
							spawn_type = "loot",
							pickup_name = str
						}
					}
					local unit_name = var_80_3.unit_name
					local unit_template_name = var_80_3.unit_template_name

					unit_template_name = unit_template_name or "pickup_unit"

					local var_80_7 = POSITION_LOOKUP[arg_80_0]
					local identity = Quaternion.identity()

					Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, var_80_7, identity)
				end

				return var_80_0, var_80_1
			end,
			update = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4)
				-- function 81
				if not (not (arg_81_3 > BLACKBOARDS[arg_81_0].delete_at_t) or arg_81_4.marked_for_deletion) then
					Managers.state.unit_spawner:mark_for_deletion(arg_81_0)

					arg_81_4.marked_for_deletion = true
				end

				return (fn_11(arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4))
			end
		},
		husk = {
			pre_start = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
				-- function 82
				fn_12(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
			end,
			start = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
				-- function 83
				local var_83_0, var_83_1 = fn_13(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)

				if not fn(arg_83_3) then
					fn_18(arg_83_0, arg_83_3[DamageDataIndex.ATTACKER], arg_83_3[DamageDataIndex.HIT_ZONE], arg_83_3[DamageDataIndex.DAMAGE_TYPE])
					fn_21(arg_83_0, arg_83_3)
				end

				Managers.state.unit_spawner:freeze_unit_extensions(arg_83_0, arg_83_2, var_83_0)

				return var_83_0, var_83_1
			end,
			update = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4)
				-- function 84
				return (fn_15(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4))
			end
		}
	},
	critter_nurgling = {
		unit = {
			pre_start = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
				-- function 85
				fn_6(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
			end,
			start = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
				-- function 86
				Managers.state.event:trigger("nurgling_killed")

				return DeathReactions.templates.ai_default.unit.start(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
			end,
			update = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
				-- function 87
				return fn_11(arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
			end
		},
		husk = {
			pre_start = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3)
				-- function 88
				fn_12(arg_88_0, arg_88_1, arg_88_2, arg_88_3)
			end,
			start = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
				-- function 89
				return DeathReactions.templates.ai_default.husk.start(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
			end,
			update = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4)
				-- function 90
				return fn_15(arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4)
			end
		}
	},
	player = {
		unit = {
			pre_start = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3)
				-- function 91
				local owner = Managers.player:owner(arg_91_0)
				local var_91_1 = arg_91_3[DamageDataIndex.DAMAGE_TYPE]
				local var_91_2 = arg_91_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
				local var_91_3 = POSITION_LOOKUP[arg_91_0]

				Managers.telemetry_events:player_died(owner, var_91_1, var_91_2, var_91_3)
			end,
			start = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4)
				-- function 92
				fn_20(arg_92_0, arg_92_3)
				fn_21(arg_92_0, arg_92_3, true)
				StatisticsUtil.register_kill(arg_92_0, arg_92_3, arg_92_1.statistics_db, true)
				Unit.flow_event(arg_92_0, "lua_on_death")

				return nil, DeathReactions.IS_DONE
			end
		},
		husk = {
			pre_start = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3)
				-- function 93
				local owner = Managers.player:owner(arg_93_0)
				local var_93_1 = arg_93_3[DamageDataIndex.DAMAGE_TYPE]
				local var_93_2 = arg_93_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
				local var_93_3 = POSITION_LOOKUP[arg_93_0]

				Managers.telemetry_events:player_died(owner, var_93_1, var_93_2, var_93_3)
			end,
			start = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
				-- function 94
				if not fn(arg_94_3) then
					if not (Managers.mechanism:current_mechanism_name() == "versus") then
						fn_19(arg_94_0, arg_94_3, arg_94_1.world)
					end

					fn_21(arg_94_0, arg_94_3, true)
					StatisticsUtil.register_kill(arg_94_0, arg_94_3, arg_94_1.statistics_db)
					Unit.flow_event(arg_94_0, "lua_on_death")

					if not ScriptUnit.has_extension(arg_94_0, "dialogue_system") then
						SurroundingAwareSystem.add_event(arg_94_0, "player_death", DialogueSettings.death_discover_distance, "target", arg_94_0, "target_name", ScriptUnit.extension(arg_94_0, "dialogue_system").context.player_profile)
					end
				end

				return nil, DeathReactions.IS_DONE
			end
		}
	},
	level_object = {
		unit = {
			pre_start = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3)
				-- function 95
				return
			end,
			start = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
				-- function 96
				Managers.state.game_mode:level_object_killed(arg_96_0, arg_96_3)
				Unit.set_flow_variable(arg_96_0, "current_health", 0)
				Unit.flow_event(arg_96_0, "lua_on_death")
			end,
			update = function (arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4)
				-- function 97
				return
			end
		},
		husk = {
			pre_start = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3)
				-- function 98
				return
			end,
			start = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4)
				-- function 99
				Managers.state.game_mode:level_object_killed(arg_99_0, arg_99_3)
				Unit.flow_event(arg_99_0, "lua_on_death")
			end,
			update = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4)
				-- function 100
				return
			end
		}
	},
	level_object_hit_context = {
		unit = {
			pre_start = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3)
				-- function 101
				return
			end,
			start = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4)
				-- function 102
				Managers.state.game_mode:level_object_killed(arg_102_0, arg_102_3)
				Unit.set_flow_variable(arg_102_0, "current_health", 0)
				Unit.flow_event(arg_102_0, "lua_on_death")

				local local_player = Managers.player:local_player()
				local flag = not local_player and local_player.player_unit

				if not (not flag and flag ~= arg_102_3[DamageDataIndex.SOURCE_ATTACKER_UNIT]) then
					Unit.flow_event(arg_102_0, "lua_local_player_killing_blow")
				end
			end,
			update = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4)
				-- function 103
				return
			end
		},
		husk = {
			pre_start = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3)
				-- function 104
				return
			end,
			start = function (arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4)
				-- function 105
				Managers.state.game_mode:level_object_killed(arg_105_0, arg_105_3)
				Unit.flow_event(arg_105_0, "lua_on_death")

				local local_player = Managers.player:local_player()
				local flag = not local_player and local_player.player_unit

				if not (not flag and flag ~= arg_105_3[DamageDataIndex.SOURCE_ATTACKER_UNIT]) then
					Unit.flow_event(arg_105_0, "lua_local_player_killing_blow")
				end
			end,
			update = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
				-- function 106
				return
			end
		}
	},
	standard = {
		unit = {
			pre_start = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3)
				-- function 107
				return
			end,
			start = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4)
				-- function 108
				local tbl = {
					despawn_after_time = arg_108_2 + 8
				}

				ScriptUnit.has_extension(arg_108_0, "ai_supplementary_system"):on_death(arg_108_3[DamageDataIndex.ATTACKER])
				Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_108_0)

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4)
				-- function 109
				if not (not arg_109_4.despawn_after_time and not (arg_109_3 > arg_109_4.despawn_after_time)) then
					Managers.state.unit_spawner:mark_for_deletion(arg_109_0)

					return DeathReactions.IS_DONE
				end

				return DeathReactions.IS_NOT_DONE
			end
		},
		husk = {
			pre_start = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3)
				-- function 110
				return
			end,
			start = function (arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
				-- function 111
				ScriptUnit.has_extension(arg_111_0, "ai_supplementary_system"):on_death(arg_111_3[DamageDataIndex.ATTACKER])

				return nil, DeathReactions.IS_DONE
			end,
			update = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4)
				-- function 112
				return
			end
		}
	},
	despawn = {
		unit = {
			pre_start = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3)
				-- function 113
				return
			end,
			start = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3, arg_114_4, arg_114_5)
				-- function 114
				local tbl = {}
				local despawn_after_time = arg_114_5.despawn_after_time

				despawn_after_time = despawn_after_time or 0
				tbl.despawn_after_time = despawn_after_time
				tbl.play_effect = arg_114_5.play_effect

				Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_114_0)

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4)
				-- function 115
				if arg_115_3 > arg_115_4.despawn_after_time then
					local var_115_0 = BLACKBOARDS[arg_115_0]

					Managers.state.conflict:destroy_unit(arg_115_0, var_115_0, "death_reaction_despawn")

					if not arg_115_4.play_effect then
						local var_115_1 = POSITION_LOOKUP[arg_115_0]
						local var_115_2 = NetworkLookup.effects[arg_115_4.play_effect]
						local num = 0
						local identity = Quaternion.identity()

						Managers.state.network:rpc_play_particle_effect(nil, var_115_2, NetworkConstants.invalid_game_object_id, num, var_115_1, identity, false)
					end

					return DeathReactions.IS_DONE
				end

				return DeathReactions.IS_NOT_DONE
			end
		},
		husk = {
			pre_start = function (arg_116_0, arg_116_1, arg_116_2, arg_116_3)
				-- function 116
				return
			end,
			start = function (arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4)
				-- function 117
				return nil, DeathReactions.IS_DONE
			end,
			update = function (arg_118_0, arg_118_1, arg_118_2, arg_118_3, arg_118_4)
				-- function 118
				return
			end
		}
	},
	killable_projectile = {
		unit = {
			pre_start = function (arg_119_0, arg_119_1, arg_119_2, arg_119_3)
				-- function 119
				return
			end,
			start = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4)
				-- function 120
				ScriptUnit.extension(arg_120_0, "projectile_system"):force_impact(arg_120_0, Unit.local_position(arg_120_0, 0))

				local network = Managers.state.network
				local unit_game_object_id = network:unit_game_object_id(arg_120_0)
				local local_position = Unit.local_position(arg_120_0, 0)

				network.network_transmit:send_rpc_clients("rpc_generic_impact_projectile_force_impact", unit_game_object_id, local_position)
				Unit.flow_event(arg_120_0, "lua_projectile_end")

				return nil, DeathReactions.IS_DONE
			end,
			update = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3, arg_121_4)
				-- function 121
				return
			end
		},
		husk = {
			pre_start = function (arg_122_0, arg_122_1, arg_122_2, arg_122_3)
				-- function 122
				return
			end,
			start = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4)
				-- function 123
				Unit.flow_event(arg_123_0, "lua_on_death")
			end,
			update = function (arg_124_0, arg_124_1, arg_124_2, arg_124_3, arg_124_4)
				-- function 124
				return
			end
		}
	},
	explosive_barrel = {
		unit = {
			pre_start = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3)
				-- function 125
				return
			end,
			start = function (arg_126_0, arg_126_1, arg_126_2, arg_126_3, arg_126_4)
				-- function 126
				local network_time = Managers.state.network:network_time()
				local var_126_1 = arg_126_3[DamageDataIndex.ATTACKER]
				local tbl = {
					explode_time = network_time,
					killer_unit = var_126_1
				}
				local attacker_unique_id = ScriptUnit.has_extension(arg_126_0, "health_system").last_damage_data.attacker_unique_id
				local player_from_unique_id = Managers.player:player_from_unique_id(attacker_unique_id)
				local flag = not player_from_unique_id and player_from_unique_id:stats_id()

				Managers.state.achievement:trigger_event("explosive_barrel_destroyed", flag, arg_126_0, arg_126_3)

				ScriptUnit.extension(arg_126_0, "death_system").death_has_started = true

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4)
				-- function 127
				local network_time = Managers.state.network:network_time()

				if not arg_127_4.exploded then
					Unit.flow_event(arg_127_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_127_0, false)

					local extension = ScriptUnit.extension(arg_127_0, "health_system")

					if not extension.in_hand then
						if not extension.thrown then
							local var_127_2 = POSITION_LOOKUP[arg_127_0]
							local local_rotation = Unit.local_rotation(arg_127_0, 0)
							local str = "explosive_barrel"
							local item_name = extension.item_name
							local owner_unit = extension.owner_unit

							Managers.state.entity:system("area_damage_system"):create_explosion(owner_unit, var_127_2, local_rotation, str, 1, item_name, nil, false)

							local extension_2 = ScriptUnit.extension(owner_unit, "inventory_system")
							local wielded_slot = extension_2:equipment().wielded_slot

							extension_2:destroy_slot(wielded_slot)
							extension_2:wield_previous_weapon()
						end
					else
						local var_127_9 = POSITION_LOOKUP[arg_127_0]
						local local_rotation_2 = Unit.local_rotation(arg_127_0, 0)
						local str_2 = "explosive_barrel"
						local item_name_2 = extension.item_name
						local last_damage_data = extension.last_damage_data
						local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(last_damage_data.attacker_unit_id, false)

						game_object_or_level_unit = game_object_or_level_unit or arg_127_0

						Managers.state.entity:system("area_damage_system"):create_explosion(game_object_or_level_unit, var_127_9, local_rotation_2, str_2, 1, item_name_2, nil, false)

						if not game_object_or_level_unit then
							local has_extension = ScriptUnit.has_extension(game_object_or_level_unit, "buff_system")

							if not has_extension then
								has_extension:trigger_procs("on_barrel_exploded", var_127_9, local_rotation_2, item_name_2, arg_127_0)
							end
						end
					end

					arg_127_4.exploded = true
				elseif network_time >= arg_127_4.explode_time + 0.5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_127_0)

					return DeathReactions.IS_DONE
				end
			end
		},
		husk = {
			pre_start = function (arg_128_0, arg_128_1, arg_128_2, arg_128_3)
				-- function 128
				return
			end,
			start = function (arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4)
				-- function 129
				local network_time = Managers.state.network:network_time()
				local tbl = {
					explode_time = network_time,
					killer_unit = arg_129_3[DamageDataIndex.ATTACKER]
				}
				local attacker_unique_id = ScriptUnit.has_extension(arg_129_0, "health_system").last_damage_data.attacker_unique_id
				local player_from_unique_id = Managers.player:player_from_unique_id(attacker_unique_id)
				local flag = not player_from_unique_id and player_from_unique_id:stats_id()

				Managers.state.achievement:trigger_event("explosive_barrel_destroyed", flag, arg_129_0, arg_129_3)

				ScriptUnit.extension(arg_129_0, "death_system").death_has_started = true

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_130_0, arg_130_1, arg_130_2, arg_130_3, arg_130_4)
				-- function 130
				local network_time = Managers.state.network:network_time()

				if not arg_130_4.exploded then
					Unit.flow_event(arg_130_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_130_0, false)

					local extension = ScriptUnit.extension(arg_130_0, "health_system")

					if not (not extension.in_hand and extension.thrown) then
						local var_130_2 = POSITION_LOOKUP[arg_130_0]
						local local_rotation = Unit.local_rotation(arg_130_0, 0)
						local str = "explosive_barrel"
						local item_name = extension.item_name
						local owner_unit = extension.owner_unit

						Managers.state.entity:system("area_damage_system"):create_explosion(owner_unit, var_130_2, local_rotation, str, 1, item_name, nil, false)

						local extension_2 = ScriptUnit.extension(owner_unit, "inventory_system")
						local wielded_slot = extension_2:equipment().wielded_slot

						extension_2:destroy_slot(wielded_slot)
						extension_2:wield_previous_weapon()
					end

					arg_130_4.exploded = true
				elseif network_time >= arg_130_4.explode_time + 0.5 then
					return DeathReactions.IS_DONE
				end
			end
		}
	},
	nurgle_liquid_blob = {
		unit = {
			pre_start = function (arg_131_0, arg_131_1, arg_131_2, arg_131_3)
				-- function 131
				return
			end,
			start = function (arg_132_0, arg_132_1, arg_132_2, arg_132_3, arg_132_4, arg_132_5)
				-- function 132
				local network_time = Managers.state.network:network_time()
				local die_callback = arg_132_5.extension_init_data.die_callback

				if not die_callback then
					die_callback()
				end

				local shrink_and_despawn_time = arg_132_5.extension_init_data.shrink_and_despawn_time
				local has_extension = ScriptUnit.has_extension(arg_132_0, "buff_system")

				if not has_extension then
					local get_buff_type = has_extension:get_buff_type("bubonic_blob_buff")

					has_extension:remove_buff(get_buff_type.id)
				end

				local tbl = {
					start_time = network_time,
					shrink_and_despawn_time = shrink_and_despawn_time
				}

				Unit.set_flow_variable(arg_132_0, "current_health", 0)
				Unit.flow_event(arg_132_0, "lua_on_death")

				local local_player = Managers.player:local_player()
				local flag = not local_player and local_player.player_unit

				if not (not flag and flag ~= arg_132_3[DamageDataIndex.ATTACKER]) then
					Unit.flow_event(arg_132_0, "lua_local_player_killing_blow")
				end

				arg_132_5.death_has_started = true

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_133_0, arg_133_1, arg_133_2, arg_133_3, arg_133_4)
				-- function 133
				local network_time = Managers.state.network:network_time()
				local get_data = Unit.get_data(arg_133_0, "death_reaction_delay")

				get_data = get_data or 0

				local start_time = arg_133_4.start_time
				local IS_NOT_DONE = DeathReactions.IS_NOT_DONE

				if network_time >= start_time + get_data then
					if not arg_133_4.destroyed then
						local num_actors = Unit.num_actors(arg_133_0)

						for i = 0, num_actors - 1 do
							Unit.destroy_actor(arg_133_0, i)
						end

						Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_133_0)

						local local_position = Unit.local_position(arg_133_0, 0)
						local nav_world = Managers.state.entity:system("ai_system"):nav_world()
						local get_close_pos_below_on_mesh = LocomotionUtils.get_close_pos_below_on_mesh(nav_world, local_position, 4, 1, 30)

						if not get_close_pos_below_on_mesh then
							local str = "nurgle_liquid"
							local hit_player_function = LiquidAreaDamageTemplates.templates[str].hit_player_function
							local sides = Managers.state.side:sides()

							for j = 1, #sides do
								local PLAYER_AND_BOT_UNITS = sides[j].PLAYER_AND_BOT_UNITS
								local count = #PLAYER_AND_BOT_UNITS

								for k = 1, count do
									local var_133_13 = PLAYER_AND_BOT_UNITS[k]

									hit_player_function(var_133_13, PLAYER_AND_BOT_UNITS)
								end
							end

							IS_NOT_DONE = DeathReactions.IS_DONE
						else
							local local_rotation = Unit.local_rotation(arg_133_0, 0)
							local forward = Quaternion.forward(local_rotation)
							local flat = Vector3.flat(forward)
							local tbl = {
								area_damage_system = {
									liquid_template = "nurgle_liquid",
									flow_dir = flat,
									source_unit = arg_133_0
								}
							}
							local str_2 = "units/hub_elements/empty"
							local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str_2, "liquid_aoe_unit", tbl, get_close_pos_below_on_mesh)

							ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
						end

						arg_133_4.destroyed = true
					elseif not (not arg_133_4.destroyed and not (network_time >= start_time + 0.5)) then
						if not arg_133_4.shrink_and_despawn_time then
							local has_extension = ScriptUnit.has_extension(arg_133_0, "props_system")
							local shrinking_state = arg_133_4.shrinking_state

							if not shrinking_state then
								arg_133_4.shrinking_state = "waiting"
							elseif shrinking_state == "waiting" then
								if network_time >= start_time + arg_133_4.shrink_and_despawn_time then
									has_extension:setup(1, 0, 0.5)

									arg_133_4.shrinking_state = "shrinking"
								end
							elseif shrinking_state ~= "shrinking" or not has_extension:scaling_complete() then
								Managers.state.unit_spawner:mark_for_deletion(arg_133_0)

								IS_NOT_DONE = DeathReactions.IS_DONE
							end
						else
							IS_NOT_DONE = DeathReactions.IS_DONE
						end
					end

					return IS_NOT_DONE
				end
			end
		},
		husk = {
			pre_start = function (arg_134_0, arg_134_1, arg_134_2, arg_134_3)
				-- function 134
				return
			end,
			start = function (arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5)
				-- function 135
				local network_time = Managers.state.network:network_time()
				local shrink_and_despawn_time = arg_135_5.extension_init_data.shrink_and_despawn_time
				local tbl = {
					start_time = network_time,
					shrink_and_despawn_time = shrink_and_despawn_time
				}

				ScriptUnit.extension(arg_135_0, "death_system").death_has_started = true

				local has_extension = ScriptUnit.has_extension(arg_135_0, "buff_system")

				if not has_extension then
					local get_buff_type = has_extension:get_buff_type("bubonic_blob_buff")

					has_extension:remove_buff(get_buff_type.id)
				end

				local local_player = Managers.player:local_player()
				local flag = not local_player and local_player.player_unit

				if not (not flag and flag ~= arg_135_3[DamageDataIndex.ATTACKER]) then
					Unit.flow_event(arg_135_0, "lua_local_player_killing_blow")
				end

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_136_0, arg_136_1, arg_136_2, arg_136_3, arg_136_4)
				-- function 136
				local network_time = Managers.state.network:network_time()
				local start_time = arg_136_4.start_time
				local IS_NOT_DONE = DeathReactions.IS_NOT_DONE

				if not arg_136_4.destroyed then
					local num_actors = Unit.num_actors(arg_136_0)

					for i = 0, num_actors - 1 do
						Unit.destroy_actor(arg_136_0, i)
					end

					Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(arg_136_0)

					arg_136_4.destroyed = true
				elseif not (not arg_136_4.destroyed and not (network_time >= start_time + 0.5)) then
					if not arg_136_4.shrink_and_despawn_time then
						local has_extension = ScriptUnit.has_extension(arg_136_0, "props_system")
						local shrinking_state = arg_136_4.shrinking_state

						if not shrinking_state then
							arg_136_4.shrinking_state = "waiting"
						elseif shrinking_state == "waiting" then
							if network_time >= start_time + arg_136_4.shrink_and_despawn_time then
								has_extension:setup(1, 0, 0.5)

								arg_136_4.shrinking_state = "shrinking"
							end
						elseif shrinking_state ~= "shrinking" or not has_extension:scaling_complete() then
							IS_NOT_DONE = DeathReactions.IS_DONE
						end
					else
						IS_NOT_DONE = DeathReactions.IS_DONE
					end
				end

				return IS_NOT_DONE
			end
		}
	},
	lamp_oil = {
		unit = {
			pre_start = function (arg_137_0, arg_137_1, arg_137_2, arg_137_3)
				-- function 137
				return
			end,
			start = function (arg_138_0, arg_138_1, arg_138_2, arg_138_3, arg_138_4)
				-- function 138
				local network_time = Managers.state.network:network_time()
				local tbl = {
					killer_unit = arg_138_3[DamageDataIndex.ATTACKER],
					start_time = network_time
				}

				ScriptUnit.extension(arg_138_0, "death_system").death_has_started = true

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_139_0, arg_139_1, arg_139_2, arg_139_3, arg_139_4)
				-- function 139
				local network_time = Managers.state.network:network_time()
				local start_time = arg_139_4.start_time
				local IS_NOT_DONE = DeathReactions.IS_NOT_DONE

				if not arg_139_4.exploded then
					Unit.flow_event(arg_139_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_139_0, false)

					local var_139_3 = POSITION_LOOKUP[arg_139_0]
					local nav_world = Managers.state.entity:system("ai_system"):nav_world()
					local get_close_pos_below_on_mesh = LocomotionUtils.get_close_pos_below_on_mesh(nav_world, var_139_3, 4)
					local extension = ScriptUnit.extension(arg_139_0, "health_system")
					local last_damage_data = extension.last_damage_data
					local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(last_damage_data.attacker_unit_id, false)

					game_object_or_level_unit = game_object_or_level_unit or arg_139_0

					if not get_close_pos_below_on_mesh then
						Managers.state.unit_spawner:mark_for_deletion(arg_139_0)

						IS_NOT_DONE = DeathReactions.IS_DONE
					else
						local local_rotation = Unit.local_rotation(arg_139_0, 0)
						local forward = Quaternion.forward(local_rotation)
						local flat = Vector3.flat(forward)
						local tbl = {
							area_damage_system = {
								liquid_template = "lamp_oil_fire",
								flow_dir = flat,
								source_unit = game_object_or_level_unit
							}
						}
						local str = "units/hub_elements/empty"
						local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, get_close_pos_below_on_mesh)

						ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
					end

					if not (not extension.in_hand and extension.thrown) then
						local owner_unit = extension.owner_unit
						local extension_2 = ScriptUnit.extension(owner_unit, "inventory_system")
						local wielded_slot = extension_2:equipment().wielded_slot

						extension_2:destroy_slot(wielded_slot)
						extension_2:wield_previous_weapon()
					end

					arg_139_4.exploded = true
				elseif not (not arg_139_4.exploded and not (network_time >= start_time + 0.5)) then
					Managers.state.unit_spawner:mark_for_deletion(arg_139_0)

					IS_NOT_DONE = DeathReactions.IS_DONE
				end

				return IS_NOT_DONE
			end
		},
		husk = {
			pre_start = function (arg_140_0, arg_140_1, arg_140_2, arg_140_3)
				-- function 140
				return
			end,
			start = function (arg_141_0, arg_141_1, arg_141_2, arg_141_3, arg_141_4)
				-- function 141
				local network_time = Managers.state.network:network_time()
				local tbl = {
					killer_unit = arg_141_3[DamageDataIndex.ATTACKER],
					start_time = network_time
				}

				ScriptUnit.extension(arg_141_0, "death_system").death_has_started = true

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_142_0, arg_142_1, arg_142_2, arg_142_3, arg_142_4)
				-- function 142
				local network_time = Managers.state.network:network_time()
				local start_time = arg_142_4.start_time
				local IS_NOT_DONE = DeathReactions.IS_NOT_DONE

				if not arg_142_4.exploded then
					Unit.flow_event(arg_142_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_142_0, false)

					local extension = ScriptUnit.extension(arg_142_0, "health_system")

					if not (not extension.in_hand and extension.thrown) then
						local var_142_4 = POSITION_LOOKUP[arg_142_0]
						local nav_world = Managers.state.entity:system("ai_system"):nav_world()
						local get_close_pos_below_on_mesh = LocomotionUtils.get_close_pos_below_on_mesh(nav_world, var_142_4, 4)

						if not get_close_pos_below_on_mesh then
							IS_NOT_DONE = DeathReactions.IS_DONE
						else
							local local_rotation = Unit.local_rotation(arg_142_0, 0)
							local forward = Quaternion.forward(local_rotation)
							local flat = Vector3.flat(forward)
							local lamp_oil_fire = NetworkLookup.liquid_area_damage_templates.lamp_oil_fire
							local network = Managers.state.network
							local attacker_unit_id = extension.last_damage_data.attacker_unit_id

							attacker_unit_id = attacker_unit_id or NetworkConstants.invalid_game_object_id

							network.network_transmit:send_rpc_server("rpc_create_liquid_damage_area", attacker_unit_id, get_close_pos_below_on_mesh, flat, lamp_oil_fire)
						end

						local owner_unit = extension.owner_unit
						local extension_2 = ScriptUnit.extension(owner_unit, "inventory_system")
						local wielded_slot = extension_2:equipment().wielded_slot

						extension_2:destroy_slot(wielded_slot)
						extension_2:wield_previous_weapon()
					end

					arg_142_4.exploded = true
				elseif not (not arg_142_4.exploded and not (network_time >= start_time + 0.5)) then
					IS_NOT_DONE = DeathReactions.IS_DONE
				end

				return IS_NOT_DONE
			end
		}
	},
	lure_unit = {
		unit = {
			pre_start = function (arg_143_0, arg_143_1, arg_143_2, arg_143_3)
				-- function 143
				return
			end,
			start = function (arg_144_0, arg_144_1, arg_144_2, arg_144_3, arg_144_4)
				-- function 144
				Managers.state.unit_spawner:mark_for_deletion(arg_144_0)

				return nil, DeathReactions.IS_DONE
			end
		},
		husk = {
			pre_start = function (arg_145_0, arg_145_1, arg_145_2, arg_145_3)
				-- function 145
				return
			end,
			start = function (arg_146_0, arg_146_1, arg_146_2, arg_146_3, arg_146_4)
				-- function 146
				return nil, DeathReactions.IS_DONE
			end
		}
	}
}
DeathReactions.templates.minotaur = {
	unit = {
		pre_start = function (arg_147_0, arg_147_1, arg_147_2, arg_147_3)
			-- function 147
			fn_6(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
		end,
		start = function (arg_148_0, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
			-- function 148
			local var_148_0 = arg_148_3[DamageDataIndex.ATTACKER]
			local unit_owner = Managers.player:unit_owner(var_148_0)

			if not unit_owner then
				fn_22(unit_owner, arg_148_0)
			end

			fn_23(var_148_0)

			return DeathReactions.templates.ai_default.unit.start(arg_148_0, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
		end,
		update = function (arg_149_0, arg_149_1, arg_149_2, arg_149_3, arg_149_4)
			-- function 149
			return (fn_11(arg_149_0, arg_149_1, arg_149_2, arg_149_3, arg_149_4))
		end
	},
	husk = {
		pre_start = function (arg_150_0, arg_150_1, arg_150_2, arg_150_3)
			-- function 150
			fn_12(arg_150_0, arg_150_1, arg_150_2, arg_150_3)
		end,
		start = function (arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
			-- function 151
			return DeathReactions.templates.ai_default.husk.start(arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
		end,
		update = function (arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4)
			-- function 152
			return (fn_15(arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4))
		end
	}
}
DeathReactions.templates.gor = {
	unit = {
		pre_start = function (arg_153_0, arg_153_1, arg_153_2, arg_153_3)
			-- function 153
			fn_6(arg_153_0, arg_153_1, arg_153_2, arg_153_3)
		end,
		start = function (arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4)
			-- function 154
			local var_154_0 = arg_154_3[DamageDataIndex.DAMAGE_TYPE]

			if not (var_154_0 == "warpfire" or var_154_0 ~= "warpfire_ground") then
				fn_24()
			end

			return DeathReactions.templates.ai_default.unit.start(arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4)
		end,
		update = function (arg_155_0, arg_155_1, arg_155_2, arg_155_3, arg_155_4)
			-- function 155
			return (fn_11(arg_155_0, arg_155_1, arg_155_2, arg_155_3, arg_155_4))
		end
	},
	husk = {
		pre_start = function (arg_156_0, arg_156_1, arg_156_2, arg_156_3)
			-- function 156
			fn_12(arg_156_0, arg_156_1, arg_156_2, arg_156_3)
		end,
		start = function (arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4)
			-- function 157
			return DeathReactions.templates.ai_default.husk.start(arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4)
		end,
		update = function (arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4)
			-- function 158
			return (fn_15(arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4))
		end
	}
}
DeathReactions.templates.shadow_skull = table.clone(DeathReactions.templates.ai_default)

DeathReactions.templates.shadow_skull.unit.start = function (arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)
	-- function 159
	local start, var_159_1 = DeathReactions.templates.ai_default.unit.start(arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)

	ScriptUnit.extension(arg_159_0, "projectile_system"):destroy()
	ScriptUnit.extension(arg_159_0, "projectile_locomotion_system"):destroy()

	return start, var_159_1
end

DeathReactions.templates.shadow_skull.husk.start = function (arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4)
	-- function 160
	local start, var_160_1 = DeathReactions.templates.ai_default.husk.start(arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4)

	ScriptUnit.extension(arg_160_0, "projectile_system"):destroy()
	ScriptUnit.extension(arg_160_0, "projectile_locomotion_system"):destroy()

	if not fn(arg_160_3) then
		Unit.flow_event(arg_160_0, "lua_on_death")
	end

	return start, var_160_1
end

DeathReactions.templates.tower_homing_skull = table.clone(DeathReactions.templates.ai_default)

DeathReactions.templates.tower_homing_skull.unit.start = function (arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4)
	-- function 161
	local start, var_161_1 = DeathReactions.templates.ai_default.unit.start(arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4)

	start.despawn_after_time = arg_161_2 + 2.5

	ScriptUnit.extension(arg_161_0, "projectile_system"):destroy()
	ScriptUnit.extension(arg_161_0, "projectile_locomotion_system"):destroy()

	return start, var_161_1
end

DeathReactions.templates.tower_homing_skull.unit.update = function (arg_162_0, arg_162_1, arg_162_2, arg_162_3, arg_162_4)
	-- function 162
	if not (not (arg_162_3 > arg_162_4.despawn_after_time) or arg_162_4.marked_for_deletion) then
		Managers.state.unit_spawner:mark_for_deletion(arg_162_0)

		arg_162_4.marked_for_deletion = true

		return DeathReactions.IS_DONE
	end

	return DeathReactions.IS_NOT_DONE
end

DeathReactions.templates.tower_homing_skull.husk.start = function (arg_163_0, arg_163_1, arg_163_2, arg_163_3, arg_163_4)
	-- function 163
	local start, var_163_1 = DeathReactions.templates.ai_default.husk.start(arg_163_0, arg_163_1, arg_163_2, arg_163_3, arg_163_4)

	ScriptUnit.extension(arg_163_0, "projectile_system"):destroy()
	ScriptUnit.extension(arg_163_0, "projectile_locomotion_system"):destroy()

	if not fn(arg_163_3) then
		Unit.flow_event(arg_163_0, "lua_on_death")
	end

	return start, var_163_1
end

DeathReactions.templates.destructible_ward = {
	unit = {
		pre_start = function (arg_164_0, arg_164_1, arg_164_2, arg_164_3)
			-- function 164
			return
		end,
		start = function (arg_165_0, arg_165_1, arg_165_2, arg_165_3, arg_165_4)
			-- function 165
			Managers.state.game_mode:level_object_killed(arg_165_0, arg_165_3)
			Unit.set_flow_variable(arg_165_0, "current_health", 0)
			Unit.flow_event(arg_165_0, "lua_on_death")
			Managers.state.entity:remove_extensions_from_unit(arg_165_0, {
				"WardExtension"
			})
		end,
		update = function (arg_166_0, arg_166_1, arg_166_2, arg_166_3, arg_166_4)
			-- function 166
			return
		end
	},
	husk = {
		pre_start = function (arg_167_0, arg_167_1, arg_167_2, arg_167_3)
			-- function 167
			return
		end,
		start = function (arg_168_0, arg_168_1, arg_168_2, arg_168_3, arg_168_4)
			-- function 168
			Managers.state.game_mode:level_object_killed(arg_168_0, arg_168_3)
			Unit.flow_event(arg_168_0, "lua_on_death")
			Managers.state.entity:remove_extensions_from_unit(arg_168_0, {
				"WardExtension"
			})
		end,
		update = function (arg_169_0, arg_169_1, arg_169_2, arg_169_3, arg_169_4)
			-- function 169
			return
		end
	}
}, DLCUtils.map_list("death_reactions", function (arg_170_0)
	-- function 170
	return table.merge(DeathReactions.templates, require(arg_170_0))
end)

DeathReactions.get_reaction = function (arg_171_0, arg_171_1)
	-- function 171
	local templates = DeathReactions.templates
	local flag

	flag = not arg_171_1 and "husk" and "unit"

	local var_171_2 = templates[arg_171_0][flag]

	fassert(var_171_2, "Death reaction for template %q and husk key %q does not exist", arg_171_0, flag)

	return var_171_2
end

DeathReactions._add_ai_killed_by_player_telemetry = function (arg_172_0, arg_172_1, arg_172_2, arg_172_3, arg_172_4, arg_172_5, arg_172_6)
	-- function 172
	local is_server = Managers.state.network.is_server
	local var_172_1 = POSITION_LOOKUP[arg_172_2]
	local var_172_2 = POSITION_LOOKUP[arg_172_0]

	Managers.telemetry_events:player_killed_ai(arg_172_3, var_172_1, var_172_2, arg_172_1, arg_172_5, arg_172_4, arg_172_6)
end
