-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_breed_snippets.lua

local var_0_0 = script_data

AiBreedSnippets = AiBreedSnippets or {}

local var_0_1 = Vector3.distance

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = Managers.state.side.side_by_unit[arg_1_0].ENEMY_PLAYER_AND_BOT_UNITS
	local var_1_1 = arg_1_1.breed
	local var_1_2 = var_1_1.perception_weights
	local var_1_3 = 0
	local var_1_4

	for iter_1_0 = 1, #var_1_0 do
		local var_1_5 = var_1_0[iter_1_0]
		local var_1_6 = POSITION_LOOKUP[var_1_5]
		local var_1_7 = POSITION_LOOKUP[arg_1_0]
		local var_1_8 = var_0_1(var_1_7, var_1_6)

		if var_1_8 < var_1_1.detection_radius then
			local var_1_9 = math.clamp(1 - var_1_8 / var_1_2.max_distance, 0, 1)
			local var_1_10 = var_1_9 * var_1_9 * var_1_2.distance_weight

			if var_1_3 < var_1_10 then
				var_1_3 = var_1_10
				var_1_4 = var_1_5
			end
		end
	end

	if var_1_4 then
		arg_1_1.aggro_list[var_1_4] = 50

		print("Boss gave ", var_1_4, "initial aggro")
	end
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_1.breed
	local var_2_1 = ScriptUnit.extension(arg_2_0, "ai_system")

	if arg_2_1.optional_spawn_data.spawn_behind_door then
		var_2_1:set_perception(var_2_0.perception, var_2_0.target_selection)

		local var_2_2 = arg_2_2.main_path_info.main_paths
		local var_2_3, var_2_4 = MainPathUtils.closest_pos_at_main_path(var_2_2, POSITION_LOOKUP[arg_2_0])

		arg_2_1.waiting = {
			next_player_unit_index = 1,
			awake_on_players_passing = true,
			view_cone_dot = 1,
			next_update_time = 0,
			travel_dist = var_2_4
		}
	else
		var_2_1:set_perception(var_2_0.perception, var_2_0.target_selection_angry)
		arg_2_2:add_angry_boss(1, arg_2_1)

		arg_2_1.is_angry = true

		var_0_2(arg_2_0, arg_2_1)
	end
end

AiBreedSnippets.on_rat_ogre_spawn = function (arg_3_0, arg_3_1)
	arg_3_1.cycle_rage_anim_index = 0
	arg_3_1.aggro_list = {}
	arg_3_1.fling_skaven_timer = 0
	arg_3_1.next_move_check = 0
	arg_3_1.is_valid_target_func = GenericStatusExtension.is_ogre_target

	local var_3_0 = Managers.state.conflict

	var_0_3(arg_3_0, arg_3_1, var_3_0)
	var_3_0:freeze_intensity_decay(10)
	var_3_0:add_unit_to_bosses(arg_3_0)
end

AiBreedSnippets.on_rat_ogre_death = function (arg_4_0, arg_4_1)
	local var_4_0 = Managers.state.conflict

	var_4_0:freeze_intensity_decay(1)
	var_4_0:remove_unit_from_bosses(arg_4_0)
	print("rat ogre died!")

	if arg_4_1.is_angry then
		var_4_0:add_angry_boss(-1)
	end

	AiBreedSnippets.reward_boss_kill_loot(arg_4_0, arg_4_1)
end

AiBreedSnippets.on_rat_ogre_despawn = function (arg_5_0, arg_5_1)
	local var_5_0 = Managers.state.conflict

	var_5_0:freeze_intensity_decay(1)
	var_5_0:remove_unit_from_bosses(arg_5_0)
	print("rat ogre was despawned!")

	if arg_5_1.is_angry then
		var_5_0:add_angry_boss(-1)
	end

	if not arg_5_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_5_0, arg_5_1)
	end
end

local function var_0_4(arg_6_0, arg_6_1)
	local var_6_0 = Managers.state.entity:system("audio_system")

	var_6_0:play_2d_audio_event("Stop_stormfiend_ambience")

	local var_6_1 = BreedActions.skaven_stormfiend.shoot.global_sound_parameter

	var_6_0:set_global_parameter_with_lerp(var_6_1, 0)

	local var_6_2 = Managers.state.network.network_transmit
	local var_6_3 = NetworkLookup.global_parameter_names[var_6_1]

	var_6_2:send_rpc_clients("rpc_client_audio_set_global_parameter_with_lerp", var_6_3, 0)

	arg_6_1.group_blackboard.firewall_environment_intensity = 0
end

AiBreedSnippets.on_stormfiend_spawn = function (arg_7_0, arg_7_1)
	arg_7_1.aggro_list = {}
	arg_7_1.fling_skaven_timer = 0
	arg_7_1.next_move_check = 0

	local var_7_0 = Managers.state.conflict

	var_0_3(arg_7_0, arg_7_1, var_7_0)
	var_7_0:freeze_intensity_decay(10)
	var_7_0:add_unit_to_bosses(arg_7_0)

	local var_7_1 = arg_7_1.breed.name

	if var_7_0:count_units_by_breed(var_7_1) == 0 then
		Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_stormfiend_ambience")
	end
end

AiBreedSnippets.on_stormfiend_death = function (arg_8_0, arg_8_1)
	local var_8_0 = Managers.state.conflict

	var_8_0:freeze_intensity_decay(1)
	var_8_0:remove_unit_from_bosses(arg_8_0)
	print("stormfiend died!")

	local var_8_1 = arg_8_1.breed.name

	if var_8_0:count_units_by_breed(var_8_1) == 0 then
		var_0_4(arg_8_0, arg_8_1)
	end

	if arg_8_1.is_angry then
		var_8_0:add_angry_boss(-1)
	end

	AiBreedSnippets.reward_boss_kill_loot(arg_8_0, arg_8_1)
end

AiBreedSnippets.on_stormfiend_despawn = function (arg_9_0, arg_9_1)
	local var_9_0 = Managers.state.conflict

	var_9_0:freeze_intensity_decay(1)
	var_9_0:remove_unit_from_bosses(arg_9_0)

	local var_9_1 = arg_9_1.breed.name

	if var_9_0:count_units_by_breed(var_9_1) == 0 then
		var_0_4(arg_9_0, arg_9_1)
	end

	if arg_9_1.is_angry then
		var_9_0:add_angry_boss(-1)
	end

	if not arg_9_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_9_0, arg_9_1)
	end
end

AiBreedSnippets.on_stormfiend_demo_death = function (arg_10_0, arg_10_1)
	local var_10_0 = Managers.state.conflict

	var_10_0:freeze_intensity_decay(1)
	var_10_0:remove_unit_from_bosses(arg_10_0)

	local var_10_1 = arg_10_1.breed.name

	if var_10_0:count_units_by_breed(var_10_1) == 0 then
		var_0_4(arg_10_0, arg_10_1)
	end

	if arg_10_1.is_angry then
		var_10_0:add_angry_boss(-1)
	end

	AiBreedSnippets.on_stormfiend_demo_shoot(arg_10_0, arg_10_1)
end

AiBreedSnippets.on_stormfiend_demo_despawn = function (arg_11_0, arg_11_1)
	local var_11_0 = Managers.state.conflict

	var_11_0:freeze_intensity_decay(1)
	var_11_0:remove_unit_from_bosses(arg_11_0)

	local var_11_1 = arg_11_1.breed.name

	if var_11_0:count_units_by_breed(var_11_1) == 0 then
		var_0_4(arg_11_0, arg_11_1)
	end

	if arg_11_1.is_angry then
		var_11_0:add_angry_boss(-1)
	end

	AiBreedSnippets.on_stormfiend_demo_shoot(arg_11_0, arg_11_1)
end

AiBreedSnippets.on_stormfiend_demo_shoot = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.world

	LevelHelper:flow_event(var_12_0, "demo_fire_event")

	local var_12_1 = arg_12_1.target_unit
	local var_12_2 = POSITION_LOOKUP[arg_12_0] - POSITION_LOOKUP[var_12_1]
	local var_12_3 = Quaternion.look(var_12_2, Vector3.up())
	local var_12_4 = ScriptUnit.extension(var_12_1, "first_person_system")

	var_12_4:disable_rig_movement()
	var_12_4:force_look_rotation(var_12_3, 1)
	Managers.time:set_global_time_scale_lerp(0.1, 0.5)

	local var_12_5 = 0.9

	Managers.state.entity:system("audio_system"):set_global_parameter_with_lerp("demo_slowmo", var_12_5)
end

AiBreedSnippets.on_loot_rat_update = function (arg_13_0, arg_13_1)
	local var_13_0 = Managers.time:time("game")
	local var_13_1 = arg_13_1.dodge_cooldown_time

	if not var_13_1 or var_13_1 < var_13_0 then
		local var_13_2 = arg_13_1.breed
		local var_13_3, var_13_4 = LocomotionUtils.in_crosshairs_dodge(arg_13_0, arg_13_1, var_13_0, var_13_2.dodge_crosshair_radius, var_13_2.dodge_crosshair_delay, var_13_2.dodge_crosshair_min_distance, var_13_2.dodge_crosshair_max_distance)

		if var_13_3 then
			arg_13_1.dodge_vector = Vector3Box(var_13_3)
			arg_13_1.threat_vector = Vector3Box(var_13_4)
			arg_13_1.dodge_cooldown_time = var_13_0 + arg_13_1.breed.dodge_cooldown
		end
	end
end

AiBreedSnippets.on_loot_rat_alerted = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = Managers.time:time("game")
	local var_14_1 = arg_14_1.dodge_cooldown_time

	if not var_14_1 or var_14_1 < var_14_0 then
		local var_14_2 = arg_14_1.breed
		local var_14_3
		local var_14_4

		if arg_14_0 == arg_14_2 and arg_14_1.dodge_damage_points > 0 then
			var_14_3, var_14_4 = LocomotionUtils.on_alerted_dodge(arg_14_0, arg_14_1, arg_14_2, arg_14_3)

			if var_14_3 then
				var_14_3 = Vector3Box(var_14_3)
				var_14_4 = Vector3Box(var_14_4)
			end
		end

		if not arg_14_1.confirmed_player_sighting then
			arg_14_1.target_unit = arg_14_3
			arg_14_1.is_alerted = true
			arg_14_1.is_fleeing = true
			arg_14_1.is_passive = false
		end

		ScriptUnit.extension(arg_14_0, "ai_system"):set_perception(var_14_2.perception, var_14_2.target_selection_alerted)

		arg_14_1.dodge_vector = var_14_3
		arg_14_1.threat_vector = var_14_4
		arg_14_1.dodge_cooldown_time = var_14_0 + arg_14_1.breed.dodge_cooldown
	end
end

AiBreedSnippets.on_loot_rat_stagger_action_done = function (arg_15_0)
	if Unit.alive(arg_15_0) then
		ScriptUnit.extension(arg_15_0, "health_system"):regen_dodge_damage_points()
	end
end

AiBreedSnippets.on_skaven_explosive_loot_rat_spawn = function (arg_16_0)
	if Unit.alive(arg_16_0) then
		local var_16_0 = ScriptUnit.has_extension(arg_16_0, "buff_system")
		local var_16_1 = "enemy_kill_timer"

		var_16_0:add_buff(var_16_1)
	end
end

AiBreedSnippets.on_chaos_troll_spawn = function (arg_17_0, arg_17_1)
	arg_17_1.aggro_list = {}
	arg_17_1.fling_skaven_timer = 0
	arg_17_1.can_get_downed = true
	arg_17_1.crouch_sticky_timer = 0
	arg_17_1.displaced_units = {}
	arg_17_1.next_move_check = 0
	arg_17_1.next_rage_time = 0

	local var_17_0 = arg_17_1.breed
	local var_17_1 = Managers.state.difficulty:get_difficulty_rank()

	arg_17_1.max_health_regen_per_sec = var_17_0.max_health_regen_per_sec[var_17_1] or var_17_0.max_health_regen_per_sec[2]
	arg_17_1.max_health_regen_time = var_17_0.max_health_regen_time[var_17_1] or var_17_0.max_health_regen_time[2]

	local var_17_2 = true

	if ScriptUnit.has_extension(arg_17_0, "ai_group_system") then
		var_17_2 = not ScriptUnit.extension(arg_17_0, "ai_group_system").in_patrol
	end

	if var_17_2 then
		local var_17_3 = Managers.state.conflict

		var_0_3(arg_17_0, arg_17_1, var_17_3)
		var_17_3:freeze_intensity_decay(10)
		var_17_3:add_unit_to_bosses(arg_17_0)
	end
end

AiBreedSnippets.on_chaos_troll_chief_spawn = function (arg_18_0, arg_18_1)
	arg_18_1.aggro_list = {}
	arg_18_1.fling_skaven_timer = 0
	arg_18_1.can_get_downed = true
	arg_18_1.crouch_sticky_timer = 0
	arg_18_1.displaced_units = {}
	arg_18_1.next_move_check = 0
	arg_18_1.next_rage_time = 0
	arg_18_1.running_downed_chunk_events = {}
	arg_18_1.running_upped_chunk_events = {}
	arg_18_1.stagger_immunity = nil

	local var_18_0 = arg_18_1.breed
	local var_18_1 = Managers.state.difficulty:get_difficulty_rank()

	arg_18_1.max_health_regen_per_sec = var_18_0.max_health_regen_per_sec[var_18_1] or var_18_0.max_health_regen_per_sec[2]
	arg_18_1.max_health_regen_time = var_18_0.max_health_regen_time[var_18_1] or var_18_0.max_health_regen_time[2]

	local var_18_2 = true

	if ScriptUnit.has_extension(arg_18_0, "ai_group_system") then
		var_18_2 = not ScriptUnit.extension(arg_18_0, "ai_group_system").in_patrol
	end

	if var_18_2 then
		local var_18_3 = Managers.state.conflict

		var_0_3(arg_18_0, arg_18_1, var_18_3)
		var_18_3:freeze_intensity_decay(10)
		var_18_3:add_unit_to_bosses(arg_18_0)
	end
end

AiBreedSnippets.on_chaos_troll_chief_update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if not Managers.state.network.is_server then
		return
	end

	local var_19_0 = arg_19_1.running_downed_chunk_events
	local var_19_1 = arg_19_1.running_upped_chunk_events
	local var_19_2 = ScriptUnit.extension(arg_19_0, "health_system")

	if var_19_2.state == "down" then
		for iter_19_0, iter_19_1 in pairs(var_19_1) do
			if iter_19_1.finish then
				iter_19_1.finish(arg_19_0, arg_19_1, iter_19_0)
			end

			var_19_1[iter_19_0] = nil
		end

		local var_19_3, var_19_4, var_19_5, var_19_6, var_19_7 = var_19_2:respawn_thresholds()

		if not var_19_0[var_19_7] then
			for iter_19_2, iter_19_3 in pairs(BreedActions[arg_19_1.breed.name].downed.downed_chunk_events) do
				repeat
					if (iter_19_2 == var_19_7 or type(iter_19_2) == "table" and table.contains(iter_19_2, var_19_7)) and (not iter_19_3.condition_func or iter_19_3.condition_func(arg_19_0, arg_19_1, var_19_7, arg_19_2, arg_19_3)) then
						iter_19_3.start(arg_19_0, arg_19_1, var_19_7, arg_19_2, arg_19_3)

						var_19_0[var_19_7] = iter_19_3
					end

					break
				until true
			end
		elseif var_19_0[var_19_7].update then
			var_19_0[var_19_7].update(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		end
	else
		for iter_19_4, iter_19_5 in pairs(var_19_0) do
			if iter_19_5.finish then
				iter_19_5.finish(arg_19_0, arg_19_1, iter_19_4)
			end

			var_19_0[iter_19_4] = nil
		end

		local var_19_8, var_19_9, var_19_10, var_19_11, var_19_12 = var_19_2:respawn_thresholds()

		if not var_19_1[var_19_12] then
			for iter_19_6, iter_19_7 in pairs(BreedActions[arg_19_1.breed.name].downed.upped_chunk_events) do
				repeat
					if (iter_19_6 == var_19_12 or type(iter_19_6) == "table" and table.contains(iter_19_6, var_19_12)) and (not iter_19_7.condition_func or iter_19_7.condition_func(arg_19_0, arg_19_1, var_19_12, arg_19_2, arg_19_3)) then
						iter_19_7.start(arg_19_0, arg_19_1, var_19_12, arg_19_2, arg_19_3)

						var_19_1[var_19_12] = iter_19_7
					end

					break
				until true
			end
		elseif var_19_1[var_19_12].update then
			var_19_1[var_19_12].update(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		end
	end
end

AiBreedSnippets.on_chaos_troll_chief_death = function (arg_20_0, arg_20_1)
	AiBreedSnippets.on_chaos_troll_death(arg_20_0, arg_20_1)

	local var_20_0 = arg_20_1.running_downed_chunk_events

	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		if iter_20_1.finish then
			iter_20_1.finish(arg_20_0, arg_20_1)
		end

		var_20_0[iter_20_0] = nil
	end

	local var_20_1 = arg_20_1.running_upped_chunk_events

	for iter_20_2, iter_20_3 in pairs(var_20_1) do
		if iter_20_3.finish then
			iter_20_3.finish(arg_20_0, arg_20_1)
		end

		var_20_1[iter_20_2] = nil
	end
end

AiBreedSnippets.on_chaos_troll_chief_despawn = function (arg_21_0, arg_21_1)
	AiBreedSnippets.on_chaos_troll_despawn(arg_21_0, arg_21_1)

	local var_21_0 = arg_21_1.running_downed_chunk_events

	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		if iter_21_1.finish then
			iter_21_1.finish(arg_21_0, arg_21_1)
		end

		var_21_0[iter_21_0] = nil
	end

	local var_21_1 = arg_21_1.running_upped_chunk_events

	for iter_21_2, iter_21_3 in pairs(var_21_1) do
		if iter_21_3.finish then
			iter_21_3.finish(arg_21_0, arg_21_1)
		end

		var_21_1[iter_21_2] = nil
	end
end

AiBreedSnippets.on_chaos_troll_death = function (arg_22_0, arg_22_1)
	local var_22_0 = Managers.state.conflict

	var_22_0:freeze_intensity_decay(1)
	var_22_0:remove_unit_from_bosses(arg_22_0)
	print("chaos troll died!")

	if arg_22_1.is_angry then
		var_22_0:add_angry_boss(-1)
	end

	AiBreedSnippets.reward_boss_kill_loot(arg_22_0, arg_22_1)
end

AiBreedSnippets.on_chaos_troll_despawn = function (arg_23_0, arg_23_1)
	local var_23_0 = Managers.state.conflict

	var_23_0:freeze_intensity_decay(1)
	var_23_0:remove_unit_from_bosses(arg_23_0)
	print("chaos troll was despawned!")

	if arg_23_1.is_angry then
		var_23_0:add_angry_boss(-1)
	end

	if not arg_23_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_23_0, arg_23_1)
	end
end

AiBreedSnippets.on_chaos_dummy_troll_spawn = function (arg_24_0, arg_24_1)
	arg_24_1.aggro_list = {}
	arg_24_1.can_get_downed = true
	arg_24_1.crouch_sticky_timer = 0
	arg_24_1.displaced_units = {}

	local var_24_0 = arg_24_1.breed
	local var_24_1 = Managers.state.difficulty:get_difficulty_rank()

	arg_24_1.max_health_regen_per_sec = var_24_0.max_health_regen_per_sec[var_24_1] or var_24_0.max_health_regen_per_sec[2]
	arg_24_1.max_health_regen_time = var_24_0.max_health_regen_time[var_24_1] or var_24_0.max_health_regen_time[2]
	arg_24_1.idle_sound_timer = Managers.time:time("game") + 2
	arg_24_1.play_alert = true
end

AiBreedSnippets.on_chaos_dummy_troll_update = function (arg_25_0, arg_25_1)
	local var_25_0 = Managers.time:time("game")
	local var_25_1 = arg_25_1.idle_sound_timer
	local var_25_2 = Managers.state.entity:system("audio_system")

	if arg_25_1.play_alert then
		var_25_2:play_audio_unit_event("Play_enemy_troll_vce_alert", arg_25_0)

		arg_25_1.play_alert = nil

		AiUtils.enter_combat(arg_25_0, arg_25_1)
	end

	if var_25_1 and var_25_1 < var_25_0 then
		var_25_2:play_audio_unit_event("Play_enemy_troll_vce_idle", arg_25_0)

		arg_25_1.idle_sound_timer = nil
	end
end

AiBreedSnippets.on_chaos_dummy_troll_death = function (arg_26_0, arg_26_1)
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_enemy_troll_vce_hurt", arg_26_0)
end

AiBreedSnippets.on_chaos_dummy_sorcerer_spawn = function (arg_27_0, arg_27_1, arg_27_2)
	ScriptUnit.extension(arg_27_0, "health_system").is_invincible = true
end

AiBreedSnippets.on_storm_vermin_champion_spawn = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_1.breed

	arg_28_1.aggro_list = {}
	arg_28_1.next_move_check = 0
	arg_28_1.spawned_allies_wave = 0
	arg_28_1.surrounding_players = 0
	arg_28_1.current_phase = 1
	arg_28_1.spawn_type = nil
	arg_28_1.surrounding_players_last = -math.huge
	arg_28_1.run_speed = var_28_0.run_speed
	arg_28_1.inventory_item_set = 1
	arg_28_1.switching_weapons = 2
	arg_28_1.dual_wield_timer = Managers.time:time("game") + 30
	arg_28_1.dual_wield_mode = true
	arg_28_1.num_times_hit_skaven = 0

	if var_28_0.displace_players_data then
		arg_28_1.displaced_units = {}
	end

	if Managers.state.difficulty:get_difficulty_rank() >= 2 then
		arg_28_1.trickle_timer = Managers.time:time("game") + 8
	else
		print("no trickle, difficulty:", Managers.state.difficulty:get_difficulty_rank())
	end

	local var_28_1 = Managers.state.conflict

	var_28_1:freeze_intensity_decay(10)
	var_28_1:add_unit_to_bosses(arg_28_0)

	local var_28_2 = Unit.actor(arg_28_0, "c_trophy_rack_ward")

	Actor.set_collision_enabled(var_28_2, false)
	Actor.set_scene_query_enabled(var_28_2, false)

	arg_28_1.intro_timer = Managers.time:time("game") + 10
	arg_28_1.is_valid_target_func = GenericStatusExtension.is_lord_target

	local var_28_3 = Managers.state.conflict.level_analysis.generic_ai_node_units.warlord_go_to

	if var_28_3 then
		local var_28_4 = {}

		for iter_28_0 = 1, #var_28_3 do
			local var_28_5 = var_28_3[iter_28_0]
			local var_28_6 = Unit.local_position(var_28_5, 0)

			var_28_4[#var_28_4 + 1] = Vector3Box(var_28_6)
		end

		arg_28_1.spawn_allies_positions = var_28_4
	end
end

AiBreedSnippets.on_storm_vermin_champion_husk_spawn = function (arg_29_0)
	local var_29_0 = Unit.actor(arg_29_0, "c_trophy_rack_ward")

	Actor.set_collision_enabled(var_29_0, false)
	Actor.set_scene_query_enabled(var_29_0, false)
end

AiBreedSnippets.on_storm_vermin_hot_join_sync = function (arg_30_0, arg_30_1)
	if BLACKBOARDS[arg_30_1].ward_active then
		local var_30_0 = Managers.state.network:unit_game_object_id(arg_30_0)
		local var_30_1 = PEER_ID_TO_CHANNEL[arg_30_0]

		RPC.rpc_set_ward_state(var_30_1, var_30_0, true)
	end
end

AiBreedSnippets.on_storm_vermin_champion_update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = Managers.state.side.side_by_unit[arg_31_0]
	local var_31_1 = var_31_0.ENEMY_PLAYER_AND_BOT_UNITS
	local var_31_2 = var_31_0.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_31_3 = Unit.local_position(arg_31_0, 0)
	local var_31_4 = BreedActions.skaven_storm_vermin_champion.special_attack_spin.radius
	local var_31_5 = 0

	for iter_31_0, iter_31_1 in ipairs(var_31_2) do
		local var_31_6 = var_31_1[iter_31_0]

		if var_31_4 > Vector3.distance(var_31_3, iter_31_1) and not ScriptUnit.extension(var_31_6, "status_system"):is_disabled() and not ScriptUnit.extension(var_31_6, "status_system"):is_invisible() then
			var_31_5 = var_31_5 + 1
		end
	end

	arg_31_1.surrounding_players = var_31_5

	if arg_31_1.surrounding_players > 0 then
		arg_31_1.surrounding_players_last = arg_31_2
	end

	if arg_31_1.trickle_timer and arg_31_2 > arg_31_1.trickle_timer and not arg_31_1.defensive_mode_duration then
		local var_31_7 = Managers.state.conflict

		if var_31_7:count_units_by_breed("skaven_slave") < 4 then
			local var_31_8 = true
			local var_31_9 = true
			local var_31_10 = "stronghold_boss_trickle"
			local var_31_11
			local var_31_12
			local var_31_13 = var_31_0.side_id

			var_31_7.horde_spawner:execute_event_horde(arg_31_2, var_31_12, var_31_13, var_31_10, var_31_11, var_31_9, nil, var_31_8)

			arg_31_1.trickle_timer = arg_31_2 + 15
		else
			arg_31_1.trickle_timer = arg_31_2 + 10
		end
	end

	local var_31_14 = arg_31_1.breed

	if arg_31_1.dual_wield_mode then
		if arg_31_2 > arg_31_1.dual_wield_timer and not arg_31_1.active_node or arg_31_1.defensive_mode_duration then
			arg_31_1.dual_wield_timer = arg_31_2 + 20
			arg_31_1.dual_wield_mode = false
		end
	else
		local var_31_15 = ScriptUnit.extension(arg_31_1.unit, "health_system"):current_health_percent()

		if arg_31_1.current_phase == 2 and var_31_15 < 0.15 then
			arg_31_1.current_phase = 3

			local var_31_16 = var_31_14.angry_run_speed

			arg_31_1.run_speed = var_31_16

			if not arg_31_1.run_speed_overridden then
				arg_31_1.navigation_extension:set_max_speed(var_31_16)
			end
		elseif arg_31_1.current_phase == 1 and var_31_15 < 0.8 then
			arg_31_1.current_phase = 2
		end

		if arg_31_1.defensive_mode_duration then
			if not arg_31_1.defensive_mode_duration_at_t then
				arg_31_1.defensive_mode_duration_at_t = arg_31_2 + arg_31_1.defensive_mode_duration
			end

			if arg_31_2 >= arg_31_1.defensive_mode_duration_at_t then
				arg_31_1.defensive_mode_duration = nil
				arg_31_1.defensive_mode_duration_at_t = nil
			else
				arg_31_1.defensive_mode_duration = arg_31_2 - arg_31_1.defensive_mode_duration_at_t
				arg_31_1.dual_wield_mode = false
			end
		elseif arg_31_2 > arg_31_1.dual_wield_timer and not arg_31_1.active_node then
			arg_31_1.dual_wield_mode = true
			arg_31_1.dual_wield_timer = arg_31_2 + 20
		end
	end

	if arg_31_1.displaced_units then
		AiUtils.push_intersecting_players(arg_31_0, arg_31_0, arg_31_1.displaced_units, var_31_14.displace_players_data, arg_31_2, arg_31_3)
	end
end

AiBreedSnippets.on_storm_vermin_champion_death = function (arg_32_0, arg_32_1)
	local var_32_0 = Managers.state.conflict

	var_32_0:freeze_intensity_decay(1)
	var_32_0:remove_unit_from_bosses(arg_32_0)

	local var_32_1 = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(var_32_1, 160, 20, true)

	if arg_32_1.is_angry then
		var_32_0:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(2, Vector3(166.5, -46, 38), true, arg_32_0)
end

AiBreedSnippets.on_storm_vermin_champion_despawn = function (arg_33_0, arg_33_1)
	local var_33_0 = Managers.state.conflict

	var_33_0:freeze_intensity_decay(1)
	var_33_0:remove_unit_from_bosses(arg_33_0)

	if arg_33_1.is_angry then
		var_33_0:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_chaos_warrior_spawn = function (arg_34_0, arg_34_1)
	arg_34_1.displaced_units = {}
	arg_34_1.aggro_list = {}
end

AiBreedSnippets.on_chaos_warrior_update = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_1.breed.displace_players_data

	if not var_35_0 or not HEALTH_ALIVE[arg_35_0] then
		return
	end

	AiUtils.push_intersecting_players(arg_35_0, arg_35_0, arg_35_1.displaced_units, var_35_0, arg_35_2)
end

AiBreedSnippets.on_chaos_tentacle_despawn = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_1.tentacle_data

	if var_36_0 and var_36_0.portal_unit then
		local var_36_1 = var_36_0.portal_unit

		Managers.state.entity:system("audio_system"):play_audio_unit_event("Stop_enemy_sorcerer_portal_loop", var_36_1, "a_surface_center")
		Managers.state.unit_spawner:mark_for_deletion(var_36_1)
	end

	local var_36_2 = arg_36_1.boss_master_unit

	if var_36_2 and Unit.alive(var_36_2) then
		local var_36_3 = BLACKBOARDS[var_36_2]

		var_36_3.num_portals_alive = var_36_3.num_portals_alive - 1
		var_36_3.tentacle_portal_units[arg_36_0] = nil
	end
end

AiBreedSnippets.on_chaos_spawn_spawn = function (arg_37_0, arg_37_1)
	arg_37_1.aggro_list = {}
	arg_37_1.fling_skaven_timer = 0
	arg_37_1.next_move_check = 0
	arg_37_1.cycle_rage_anim_index = 0
	arg_37_1.attack_grabbed_attacks = 0
	arg_37_1.chew_attacks_done = 0
	arg_37_1.grabbed_time = 0
	arg_37_1.chaos_spawn_is_throwing = false
	arg_37_1.is_valid_target_func = GenericStatusExtension.is_chaos_spawn_target

	local var_37_0 = Managers.state.conflict

	var_0_3(arg_37_0, arg_37_1, var_37_0)
	var_37_0:freeze_intensity_decay(10)
	var_37_0:add_unit_to_bosses(arg_37_0)
end

AiBreedSnippets.on_chaos_spawn_death = function (arg_38_0, arg_38_1)
	local var_38_0 = Managers.state.conflict

	var_38_0:freeze_intensity_decay(1)
	var_38_0:remove_unit_from_bosses(arg_38_0)
	print("chaos spawn died!")

	if arg_38_1.is_angry then
		var_38_0:add_angry_boss(-1)
	end

	AiBreedSnippets.reward_boss_kill_loot(arg_38_0, arg_38_1)
end

AiBreedSnippets.on_chaos_spawn_despawn = function (arg_39_0, arg_39_1)
	local var_39_0 = Managers.state.conflict

	var_39_0:freeze_intensity_decay(1)
	var_39_0:remove_unit_from_bosses(arg_39_0)

	if arg_39_1.is_angry then
		var_39_0:add_angry_boss(-1)
	end

	if not arg_39_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_39_0, arg_39_1)
	end
end

AiBreedSnippets.on_chaos_vortex_sorcerer_spawn = function (arg_40_0, arg_40_1)
	arg_40_1.max_vortex_units = arg_40_1.breed.max_vortex_units
	arg_40_1.spell_count = 0

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_40_0, "heard_enemy", DialogueSettings.hear_chaos_vortex_sorcerer, "enemy_tag", "chaos_vortex_sorcerer")
end

function remove_vortex_units(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_1.vortex_data
	local var_41_1 = Managers.state.conflict

	if arg_41_1.breed.no_despawn_when_master_dies then
		return
	end

	local var_41_2 = var_41_0 and var_41_0.vortex_units

	if var_41_2 then
		for iter_41_0, iter_41_1 in ipairs(var_41_2) do
			if Unit.alive(iter_41_1) then
				local var_41_3 = BLACKBOARDS[iter_41_1]

				var_41_1:destroy_unit(iter_41_1, var_41_3, "vortex")
			end
		end

		table.clear(var_41_2)
	end

	local var_41_4 = var_41_0 and var_41_0.queued_vortex

	if var_41_4 then
		local var_41_5 = Managers.state.unit_spawner

		for iter_41_2, iter_41_3 in pairs(var_41_4) do
			var_41_1:remove_queued_unit(iter_41_2)

			local var_41_6 = iter_41_3.inner_decal_unit

			if Unit.alive(var_41_6) then
				var_41_5:mark_for_deletion(var_41_6)
			end

			local var_41_7 = iter_41_3.outer_decal_unit

			if Unit.alive(var_41_7) then
				var_41_5:mark_for_deletion(var_41_7)
			end

			var_41_4[iter_41_2] = nil
		end
	end
end

AiBreedSnippets.on_chaos_vortex_sorcerer_death = function (arg_42_0, arg_42_1)
	remove_vortex_units(arg_42_0, arg_42_1)
end

AiBreedSnippets.on_chaos_vortex_sorcerer_despawn = function (arg_43_0, arg_43_1)
	remove_vortex_units(arg_43_0, arg_43_1)
end

AiBreedSnippets.on_chaos_sorcerer_spawn = function (arg_44_0, arg_44_1)
	arg_44_1.spell_count = 0
end

AiBreedSnippets.on_chaos_exalted_sorcerer_spawn = function (arg_45_0, arg_45_1)
	local var_45_0 = Managers.time:time("game")
	local var_45_1 = arg_45_1.breed

	arg_45_1.max_vortex_units = var_45_1.max_vortex_units
	arg_45_1.done_casting_timer = 0
	arg_45_1.spawned_allies_wave = 0
	arg_45_1.recent_attacker_timer = 0
	arg_45_1.recent_melee_attacker_timer = 0
	arg_45_1.health_extension = ScriptUnit.extension(arg_45_0, "health_system")
	arg_45_1.num_portals_alive = 0
	arg_45_1.tentacle_portal_units = {}

	local var_45_2 = {}
	local var_45_3 = {}
	local var_45_4 = World.get_data(arg_45_1.world, "physics_world")

	arg_45_1.spell_count = 0

	local var_45_5 = {
		spawn_timer = 3,
		name = "vortex",
		physics_world = var_45_4,
		vortex_units = {},
		queued_vortex = {},
		vortex_spawn_pos = Vector3Box(),
		search_func = BTChaosSorcererSkulkApproachAction._update_vortex_search,
		spawn_func = BTChaosSorcererSummoningAction._spawn_vortex
	}

	arg_45_1.vortex_data = var_45_5
	var_45_2[#var_45_2 + 1] = var_45_5
	var_45_3.vortex = var_45_5

	local var_45_6 = {
		name = "boss_vortex",
		spawn_timer = 3,
		physics_world = var_45_4,
		vortex_units = {},
		queued_vortex = {},
		vortex_spawn_pos = Vector3Box(),
		spawn_func = BTChaosSorcererSummoningAction._spawn_boss_vortex
	}

	arg_45_1.boss_vortex_data = var_45_6
	var_45_2[#var_45_2 + 1] = var_45_6
	var_45_3.boss_vortex = var_45_6

	local var_45_7 = {
		name = "plague_wave",
		plague_wave_timer = var_45_0 + 10,
		physics_world = var_45_4,
		target_starting_pos = Vector3Box(),
		plague_wave_rot = QuaternionBox(),
		search_func = BTChaosExaltedSorcererSkulkAction.update_plague_wave
	}

	arg_45_1.plague_wave_data = var_45_7
	var_45_2[#var_45_2 + 1] = var_45_7
	var_45_3.plague_wave = var_45_7

	local var_45_8 = {
		name = "tentacle",
		search_counter = 0,
		chance_to_look_for_wall_spawn = 0.5,
		portal_spawn_type = "n/a",
		portal_search_timer = var_45_0 + 3,
		cover_units = {},
		portal_spawn_pos = Vector3Box(),
		portal_spawn_rot = QuaternionBox(),
		physics_world = var_45_4,
		search_func = BTChaosSorcererSkulkApproachAction.update_portal_search,
		spawn_func = BTChaosSorcererSummoningAction.spawn_portal
	}

	arg_45_1.portal_data = var_45_8
	var_45_2[#var_45_2 + 1] = var_45_8
	var_45_3.tentacle = var_45_8

	local var_45_9 = {
		range = 40,
		magic_missile = true,
		magic_missile_speed = 20,
		true_flight_template_name = "sorcerer_magic_missile",
		projectile_unit_name = "units/weapons/projectile/magic_missile/magic_missile",
		name = "magic_missile",
		launch_angle = 0.7,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}

	arg_45_1.magic_missile_data = var_45_9
	var_45_2[#var_45_2 + 1] = var_45_9
	var_45_3.magic_missile = var_45_9

	local var_45_10 = {
		range = 40,
		magic_missile = true,
		magic_missile_speed = 15,
		true_flight_template_name = "sorcerer_strike_missile",
		projectile_unit_name = "units/weapons/projectile/strike_missile/strike_missile",
		name = "sorcerer_strike_missile",
		explosion_template_name = "chaos_strike_missile_impact",
		launch_angle = 1.25,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}

	arg_45_1.sorcerer_strike_missile_data = var_45_10
	var_45_2[#var_45_2 + 1] = var_45_10
	var_45_3.sorcerer_strike_missile = var_45_10

	local var_45_11 = {
		range = 40,
		name = "magic_missile_ground",
		magic_missile = true,
		magic_missile_speed = 20,
		true_flight_template_name = "sorcerer_magic_missile_ground",
		projectile_unit_name = "units/weapons/projectile/magic_missile/magic_missile",
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}

	arg_45_1.magic_missile_ground_data = var_45_11
	var_45_2[#var_45_2 + 1] = var_45_11
	var_45_3.magic_missile_ground = var_45_11

	local var_45_12 = {
		name = "missile_barrage",
		magic_missile = true,
		magic_missile_speed = 20,
		range = 40,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}

	arg_45_1.missile_barrage_data = var_45_12
	var_45_2[#var_45_2 + 1] = var_45_12
	var_45_3.missile_barrage = var_45_12

	local var_45_13 = {
		range = 40,
		name = "seeking_bomb_missile",
		magic_missile = true,
		magic_missile_speed = 2.5,
		true_flight_template_name = "sorcerer_slow_bomb_missile",
		projectile_unit_name = "units/weapons/projectile/insect_swarm_missile/insect_swarm_missile_01",
		explosion_template_name = "chaos_slow_bomb_missile",
		life_time = 15,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box(),
		projectile_size = {
			3,
			3,
			3
		}
	}

	arg_45_1.seeking_bomb_missile_data = var_45_13
	var_45_2[#var_45_2 + 1] = var_45_13
	var_45_3.seeking_bomb_missile = var_45_13

	local var_45_14 = {
		name = "dummy",
		search_func = BTChaosExaltedSorcererSkulkAction.update_dummy
	}

	arg_45_1.dummy_data = var_45_14
	var_45_2[#var_45_2 + 1] = var_45_14
	var_45_3.dummy = var_45_14

	local var_45_15 = Managers.state.entity:system("spawner_system")._id_lookup
	local var_45_16 = Managers.state.conflict.level_analysis
	local var_45_17 = var_45_16.generic_ai_node_units.sorcerer_boss_center
	local var_45_18 = var_45_16.generic_ai_node_units.sorcerer_boss_wall

	if var_45_17 and var_45_18 and var_45_15.sorcerer_boss and var_45_15.sorcerer_boss_minion then
		local var_45_19 = var_45_17[1]

		arg_45_1.in_boss_arena = Vector3.distance(POSITION_LOOKUP[arg_45_0], Unit.local_position(var_45_19, 0)) < 20
	else
		arg_45_1.in_boss_arena = false
	end

	if arg_45_1.in_boss_arena then
		arg_45_1.spawners = {
			sorcerer_boss_center = var_45_17
		}
		arg_45_1.mode = "setup"
		arg_45_1.phase_timer = var_45_0 + 999
		arg_45_1.intro_timer = var_45_0 + 21

		local var_45_20 = var_45_17[1]
		local var_45_21 = Unit.local_position(var_45_20, 0) + Vector3(0, 0, 0.75)
		local var_45_22 = Unit.local_rotation(var_45_20, 0)

		arg_45_1.arena_pose_boxed = Matrix4x4Box(Matrix4x4.from_quaternion_position(var_45_22, var_45_21))
		arg_45_1.arena_half_extents = Vector3Box(12, 12, 1)

		arg_45_1.valid_teleport_pos_func = function (arg_46_0, arg_46_1)
			local var_46_0 = arg_46_1.arena_pose_boxed:unbox()
			local var_46_1 = arg_46_1.arena_half_extents:unbox()

			return (math.point_is_inside_oobb(arg_46_0, var_46_0, var_46_1))
		end
	else
		arg_45_1.phase = "offensive"

		arg_45_1.valid_teleport_pos_func = function (arg_47_0, arg_47_1)
			return true
		end

		print("Sorcerer boss not in arena")
	end

	arg_45_1.spells = var_45_2
	arg_45_1.spells_lookup = var_45_3

	local var_45_23 = NetworkLookup.effects["fx/chr_chaos_sorcerer_teleport"]
	local var_45_24 = 0
	local var_45_25 = Quaternion.identity()

	Managers.state.network:rpc_play_particle_effect(nil, var_45_23, NetworkConstants.invalid_game_object_id, var_45_24, POSITION_LOOKUP[arg_45_0], var_45_25, false)

	local var_45_26 = Managers.state.entity:system("audio_system")

	if var_45_1.teleport_sound_event then
		var_45_26:play_audio_unit_event(var_45_1.teleport_sound_event, arg_45_0)
	end

	Managers.state.conflict:add_unit_to_bosses(arg_45_0)

	arg_45_1.is_valid_target_func = GenericStatusExtension.is_lord_target
end

function check_for_recent_attackers(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = arg_48_3 or 100
	local var_48_1, var_48_2 = ScriptUnit.extension(arg_48_0, "health_system"):recent_damages()

	if var_48_2 > 0 then
		local var_48_3 = var_48_1[DamageDataIndex.ATTACKER]
		local var_48_4 = arg_48_1.side
		local var_48_5 = var_48_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_48_6 = rawget(ItemMasterList, var_48_5)
		local var_48_7 = var_48_6 and var_48_6.slot_type == "melee"

		if Unit.alive(var_48_3) and var_48_4.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_48_3] then
			if var_48_0 < Vector3.distance_squared(Unit.local_position(arg_48_0, 0), Unit.local_position(var_48_3, 0)) and not var_48_7 then
				arg_48_1.target_unit = var_48_3
				arg_48_1.recent_attacker_unit = var_48_3
				arg_48_1.recent_attacker_timer = arg_48_2 + 3
				arg_48_1.recent_attacker = true

				local var_48_8 = ScriptUnit.extension_input(arg_48_0, "dialogue_system")
				local var_48_9 = FrameTable.alloc_table()

				var_48_8:trigger_networked_dialogue_event("ebh_retaliation_missile", var_48_9)
			elseif var_48_7 then
				arg_48_1.target_unit = var_48_3
				arg_48_1.recent_melee_attacker_unit = var_48_3
				arg_48_1.recent_melee_attacker_timer = arg_48_2 + 0.35
				arg_48_1.recent_melee_attacker = true
			end
		end
	elseif arg_48_1.recent_attacker then
		if arg_48_2 > arg_48_1.recent_attacker_timer then
			arg_48_1.recent_attacker_unit = nil
			arg_48_1.recent_attacker_timer = math.huge
			arg_48_1.recent_attacker = false
		end
	elseif arg_48_1.recent_melee_attacker and arg_48_2 > arg_48_1.recent_melee_attacker_timer then
		arg_48_1.recent_melee_attacker_unit = nil
		arg_48_1.recent_melee_attacker_timer = math.huge
		arg_48_1.recent_melee_attacker = false
	end
end

local var_0_5 = false

AiBreedSnippets.on_chaos_exalted_sorcerer_update = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	check_for_recent_attackers(arg_49_0, arg_49_1, arg_49_2)

	if not arg_49_1.in_boss_arena then
		return
	end

	if arg_49_1.intro_timer then
		return
	end

	if var_0_5 then
		local var_49_0 = arg_49_1.arena_pose_boxed:unbox()
		local var_49_1 = arg_49_1.arena_half_extents:unbox()

		QuickDrawer:box(var_49_0, var_49_1, Color(0, 255, 70))
	end

	local var_49_2 = arg_49_1.phase
	local var_49_3 = arg_49_1.mode

	arg_49_1.can_spawn_portals = arg_49_1.num_portals_alive < 1

	if var_49_3 == "defensive" then
		if var_49_2 == "defensive_completed" then
			arg_49_1.mode = "offensive"
			arg_49_1.phase_timer = arg_49_2 + 20
		elseif arg_49_2 > arg_49_1.phase_timer then
			arg_49_1.phase = "defensive_ends"
		end
	elseif var_49_3 == "offensive" then
		if arg_49_2 > arg_49_1.phase_timer then
			arg_49_1.mode = "defensive"
			arg_49_1.phase = "defensive_starts"
			arg_49_1.phase_timer = arg_49_2 + 20
		end
	elseif arg_49_2 > arg_49_1.phase_timer then
		arg_49_1.mode = "defensive"
		arg_49_1.phase = "defensive_starts"
		arg_49_1.phase_timer = arg_49_2 + 20
	end

	if arg_49_1.missle_bot_threat_unit then
		local var_49_4 = Unit.local_position(arg_49_1.missle_bot_threat_unit, 0)
		local var_49_5 = 2
		local var_49_6 = 1
		local var_49_7 = var_49_6 * 0.5
		local var_49_8 = Vector3(0, var_49_5, var_49_7)
		local var_49_9 = var_49_4 - Vector3.up() * var_49_7

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_49_9, "cylinder", var_49_8, nil, 1, "Exalted Sorcerer")

		arg_49_1.missle_bot_threat_unit = nil
	end
end

AiBreedSnippets.reward_boss_kill_loot = function (arg_50_0, arg_50_1)
	local var_50_0 = Managers.state.game_mode:get_boss_loot_pickup()

	if not var_50_0 then
		return
	end

	if arg_50_1.deny_kill_loot then
		return
	end

	local var_50_1 = arg_50_1.nav_world
	local var_50_2 = Unit.local_position(arg_50_0, 0)
	local var_50_3 = 1
	local var_50_4 = 1

	if Managers.mechanism:current_mechanism_name() == "versus" then
		var_50_1 = Managers.state.entity:system("ai_system"):nav_world()
	end

	local var_50_5
	local var_50_6, var_50_7 = GwNavQueries.triangle_from_position(var_50_1, var_50_2, var_50_4, var_50_3)

	if var_50_6 then
		var_50_5 = Vector3.copy(var_50_2)
		var_50_5.z = var_50_7
	else
		local var_50_8 = 2
		local var_50_9 = 0.05

		var_50_5 = GwNavQueries.inside_position_from_outside_position(var_50_1, var_50_2, var_50_4, var_50_3, var_50_8, var_50_9)
	end

	var_50_5 = var_50_5 or var_50_2

	local var_50_10 = Unit.get_data(arg_50_0, "breed")
	local var_50_11 = var_50_10 and var_50_10.name
	local var_50_12 = {
		pickup_system = {
			has_physics = true,
			spawn_type = "loot",
			pickup_name = var_50_0,
			dropped_by_breed = var_50_11
		}
	}
	local var_50_13 = AllPickups[var_50_0]
	local var_50_14 = var_50_13.unit_name
	local var_50_15 = var_50_13.unit_template_name or "pickup_unit"
	local var_50_16 = Quaternion.identity()
	local var_50_17 = Vector3(0, 0, 0.6)

	Managers.state.unit_spawner:spawn_network_unit(var_50_14, var_50_15, var_50_12, var_50_5 + var_50_17, var_50_16)

	arg_50_1.rewarded_boss_loot = true
end

AiBreedSnippets.drop_loot = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = Managers.state.game_mode:get_boss_loot_pickup()

	if not var_51_0 then
		return
	end

	local var_51_1 = arg_51_3 and Unit.get_data(arg_51_3, "breed")
	local var_51_2 = var_51_1 and var_51_1.name

	for iter_51_0 = 1, arg_51_0 do
		local var_51_3 = {
			pickup_system = {
				spawn_type = "loot",
				pickup_name = var_51_0,
				has_physics = arg_51_2,
				dropped_by_breed = var_51_2
			}
		}
		local var_51_4 = AllPickups[var_51_0]
		local var_51_5 = var_51_4.unit_name
		local var_51_6 = var_51_4.unit_template_name or "pickup_unit"
		local var_51_7 = iter_51_0 / arg_51_0 * 2 * math.pi
		local var_51_8 = arg_51_1 + Vector3(math.cos(var_51_7), math.sin(var_51_7), 0)
		local var_51_9 = Quaternion.identity()

		Managers.state.unit_spawner:spawn_network_unit(var_51_5, var_51_6, var_51_3, var_51_8, var_51_9)
	end
end

AiBreedSnippets.on_chaos_exalted_sorcerer_death = function (arg_52_0, arg_52_1)
	local var_52_0 = Managers.state.conflict

	var_52_0:remove_unit_from_bosses(arg_52_0)

	local var_52_1 = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(var_52_1, 120, 20, true)

	if arg_52_1.is_angry then
		var_52_0:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(2, Vector3(362.5, 51.6, -9.1), true, arg_52_0)
end

AiBreedSnippets.on_chaos_exalted_sorcerer_despawn = function (arg_53_0, arg_53_1)
	local var_53_0 = Managers.state.conflict

	var_53_0:remove_unit_from_bosses(arg_53_0)

	if arg_53_1.is_angry then
		var_53_0:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_chaos_exalted_champion_spawn = function (arg_54_0, arg_54_1)
	local var_54_0 = Managers.time:time("game")
	local var_54_1 = arg_54_1.breed

	arg_54_1.aggro_list = {}
	arg_54_1.next_move_check = 0
	arg_54_1.spawned_allies_wave = 0
	arg_54_1.surrounding_players = 0
	arg_54_1.current_phase = 1
	arg_54_1.spawn_type = nil
	arg_54_1.surrounding_players_last = -math.huge
	arg_54_1.run_speed = var_54_1.run_speed
	arg_54_1.cheer_state = 1
	arg_54_1.intro_timer = var_54_0 + 10

	if var_54_1.displace_players_data then
		arg_54_1.displaced_units = {}
	end

	local var_54_2 = Managers.state.conflict

	var_54_2:freeze_intensity_decay(10)
	var_54_2:add_unit_to_bosses(arg_54_0)

	arg_54_1.cheer_timer = var_54_0 + math.random(15, 30)
	arg_54_1.walla_sync_timer = var_54_0 + 2
	arg_54_1.ray_can_go_update_time = var_54_0 + 0.5

	local var_54_3 = Managers.state.conflict.level_analysis.generic_ai_node_units.chaos_exalted_defensive_move_to

	if var_54_3 then
		local var_54_4 = var_54_3[1]
		local var_54_5 = Unit.local_position(var_54_4, 0)

		arg_54_1.override_spawn_allies_call_position = Vector3Box(var_54_5)
	end

	arg_54_1.is_valid_target_func = GenericStatusExtension.is_lord_target
	arg_54_1.num_times_hit_chaos_warrior = 0
end

AiBreedSnippets.on_chaos_exalted_champion_norsca_spawn = function (arg_55_0, arg_55_1)
	local var_55_0 = Managers.time:time("game")
	local var_55_1 = arg_55_1.breed

	arg_55_1.aggro_list = {}
	arg_55_1.next_move_check = 0
	arg_55_1.current_phase = 1
	arg_55_1.spawn_type = nil
	arg_55_1.run_speed = var_55_1.run_speed

	if var_55_1.displace_players_data then
		arg_55_1.displaced_units = {}
	end

	local var_55_2 = Managers.state.conflict

	var_55_2:freeze_intensity_decay(10)
	var_55_2:add_unit_to_bosses(arg_55_0)
	var_55_2:add_angry_boss(1, arg_55_1)

	arg_55_1.is_angry = true
	arg_55_1.ray_can_go_update_time = var_55_0 + 0.5
	arg_55_1.is_valid_target_func = GenericStatusExtension.is_lord_target

	local var_55_3 = Managers.level_transition_handler.enemy_package_loader
	local var_55_4 = BreedActions.chaos_exalted_champion.transform.wanted_breed_transform

	if not var_55_3:is_breed_processed(var_55_4) then
		var_55_3:request_breed(var_55_4, true)
	end
end

AiBreedSnippets.on_chaos_exalted_champion_update = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = Unit.local_position(arg_56_0, 0)
	local var_56_1 = arg_56_1.breed
	local var_56_2 = BreedActions.chaos_exalted_champion.special_attack_aoe.radius
	local var_56_3 = 0
	local var_56_4 = 0
	local var_56_5 = Managers.state.side.side_by_unit[arg_56_0]
	local var_56_6 = var_56_5.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_56_7 = var_56_5.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_56_0, iter_56_1 in ipairs(var_56_6) do
		local var_56_8 = var_56_7[iter_56_0]

		if var_56_2 > Vector3.distance(var_56_0, iter_56_1) and not ScriptUnit.extension(var_56_8, "status_system"):is_disabled() and not ScriptUnit.extension(var_56_8, "status_system"):is_invisible() then
			var_56_3 = var_56_3 + 1
		end

		if ScriptUnit.extension(var_56_8, "status_system"):is_knocked_down() then
			var_56_4 = var_56_4 - 1
		else
			var_56_4 = var_56_4 + ScriptUnit.extension(var_56_8, "health_system"):current_health_percent()
		end
	end

	arg_56_1.surrounding_players = var_56_3

	if arg_56_1.surrounding_players > 0 then
		arg_56_1.surrounding_players_last = arg_56_2
	end

	local var_56_9 = var_56_4 / 4
	local var_56_10 = ScriptUnit.extension(arg_56_0, "health_system"):current_health_percent()

	if arg_56_1.current_phase == 1 and var_56_10 < 0.75 then
		local var_56_11 = var_56_1.angry_run_speed

		arg_56_1.run_speed = var_56_11

		if not arg_56_1.run_speed_overridden then
			arg_56_1.navigation_extension:set_max_speed(var_56_11)
		end
	end

	if arg_56_1.override_spawn_allies_call_position then
		if arg_56_1.current_phase == 1 and var_56_10 < 0.7 then
			arg_56_1.current_phase = 2
			arg_56_1.trickle_timer = arg_56_2 + 10
		elseif arg_56_1.current_phase == 2 and var_56_10 < 0.4 then
			arg_56_1.current_phase = 3
		end
	end

	local var_56_12 = Managers.state.conflict

	if arg_56_1.defensive_mode_duration then
		local var_56_13 = arg_56_1.defensive_mode_duration - arg_56_3

		if var_56_13 <= 0 then
			arg_56_1.defensive_mode_duration = nil
		else
			arg_56_1.defensive_mode_duration = var_56_13
		end
	end

	if var_56_10 > 0.05 and arg_56_1.trickle_timer and arg_56_2 > arg_56_1.trickle_timer and not arg_56_1.defensive_mode_duration then
		local var_56_14 = var_56_10 * 15
		local var_56_15 = math.max(var_56_14, 5)

		if var_56_12:count_units_by_breed("chaos_marauder") < 3 then
			local var_56_16 = true
			local var_56_17 = true
			local var_56_18 = "warcamp_boss_event_trickle"
			local var_56_19
			local var_56_20 = "warcamp_boss_minions"
			local var_56_21 = var_56_5.side_id

			var_56_12.horde_spawner:execute_event_horde(arg_56_2, var_56_20, var_56_21, var_56_18, var_56_19, var_56_17, nil, var_56_16)

			arg_56_1.trickle_timer = arg_56_2 + var_56_15
		else
			arg_56_1.trickle_timer = arg_56_2 + var_56_15
		end
	end

	if arg_56_1.displaced_units then
		AiUtils.push_intersecting_players(arg_56_0, arg_56_0, arg_56_1.displaced_units, var_56_1.displace_players_data, arg_56_2, arg_56_3)
	end

	AiBreedSnippets.update_exalted_champion_cheer_state(arg_56_0, arg_56_1, arg_56_2, arg_56_3, var_56_9)

	if arg_56_2 > arg_56_1.ray_can_go_update_time and Unit.alive(arg_56_1.target_unit) then
		local var_56_22 = arg_56_1.nav_world
		local var_56_23 = Unit.local_position(arg_56_1.target_unit, 0)

		arg_56_1.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(var_56_22, Unit.local_position(arg_56_0, 0), var_56_23, nil, 1, 1)
		arg_56_1.ray_can_go_update_time = arg_56_2 + 0.5
	end
end

AiBreedSnippets.update_exalted_champion_cheer_state = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	local var_57_0 = Managers.state.network.network_transmit
	local var_57_1 = Managers.state.entity:system("audio_system")
	local var_57_2 = ScriptUnit.extension(arg_57_1.unit, "health_system"):current_health_percent()
	local var_57_3 = Managers.world:wwise_world(arg_57_1.world)
	local var_57_4 = (var_57_2 - arg_57_4) * 5
	local var_57_5 = math.min(var_57_4 + 1, 5)
	local var_57_6 = math.max(var_57_5, 0)
	local var_57_7 = math.min(var_57_6, 4)
	local var_57_8 = math.ceil(var_57_7)

	if arg_57_2 > arg_57_1.cheer_timer then
		WwiseWorld.set_global_parameter(var_57_3, "champion_crowd_voices", 0)
		var_57_1:set_global_parameter_with_lerp("champion_crowd_voices", var_57_8)

		arg_57_1.cheer_timer = arg_57_2 + math.random(10, 25)

		local var_57_9 = NetworkLookup.global_parameter_names.champion_crowd_voices

		var_57_0:send_rpc_clients("rpc_client_audio_set_global_parameter", var_57_9, var_57_8)
	end

	var_57_1:set_global_parameter("champion_crowd_voices_walla", var_57_6)

	if arg_57_2 > arg_57_1.walla_sync_timer then
		local var_57_10 = NetworkLookup.global_parameter_names.champion_crowd_voices_walla

		var_57_0:send_rpc_clients("rpc_client_audio_set_global_parameter", var_57_10, var_57_6)

		arg_57_1.walla_sync_timer = arg_57_2 + 2
	end
end

AiBreedSnippets.on_chaos_exalted_champion_norsca_update = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0 = arg_58_1.breed
	local var_58_1 = ScriptUnit.extension(arg_58_1.unit, "health_system"):current_health_percent()

	if arg_58_1.current_phase == 1 and var_58_1 < 0.7 then
		arg_58_1.current_phase = 2
	end

	if arg_58_1.displaced_units then
		AiUtils.push_intersecting_players(arg_58_0, arg_58_0, arg_58_1.displaced_units, var_58_0.displace_players_data, arg_58_2, arg_58_3)
	end

	if arg_58_2 > arg_58_1.ray_can_go_update_time and arg_58_1.target_unit then
		local var_58_2 = arg_58_1.nav_world
		local var_58_3 = Unit.local_position(arg_58_1.target_unit, 0)

		arg_58_1.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(var_58_2, Unit.local_position(arg_58_0, 0), var_58_3, nil, 1, 1)
		arg_58_1.ray_can_go_update_time = arg_58_2 + 0.5
	end
end

AiBreedSnippets.on_chaos_exalted_champion_death = function (arg_59_0, arg_59_1)
	local var_59_0 = Managers.state.conflict

	var_59_0:remove_unit_from_bosses(arg_59_0)

	local var_59_1 = Managers.world:wwise_world(arg_59_1.world)

	WwiseWorld.set_global_parameter(var_59_1, "champion_crowd_voices", 0)
	WwiseWorld.set_global_parameter(var_59_1, "champion_crowd_voices", 1)

	arg_59_1.override_spawn_allies_call_position = nil

	local var_59_2 = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(var_59_2, 120, 20, true)

	if arg_59_1.is_angry then
		var_59_0:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(2, Vector3(231, -75, 45), true, arg_59_0)
end

AiBreedSnippets.on_chaos_exalted_champion_norsca_death = function (arg_60_0, arg_60_1)
	local var_60_0 = Managers.state.conflict

	var_60_0:freeze_intensity_decay(1)
	var_60_0:remove_unit_from_bosses(arg_60_0)

	local var_60_1 = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(var_60_1, 40, 20, true)

	if arg_60_1.is_angry then
		var_60_0:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_chaos_exalted_champion_despawn = function (arg_61_0, arg_61_1)
	local var_61_0 = Managers.state.conflict

	var_61_0:remove_unit_from_bosses(arg_61_0)

	if arg_61_1.is_angry then
		var_61_0:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_stormfiend_boss_spawn = function (arg_62_0, arg_62_1)
	AiBreedSnippets.on_stormfiend_spawn(arg_62_0, arg_62_1)

	arg_62_1.hp_at_mounted = ScriptUnit.extension(arg_62_1.unit, "health_system"):current_health_percent()
	ScriptUnit.extension(arg_62_0, "health_system").is_invincible = true
	arg_62_1.current_phase = 1
end

AiBreedSnippets.on_stormfiend_boss_update = function (arg_63_0, arg_63_1)
	local var_63_0 = ScriptUnit.extension(arg_63_1.unit, "health_system"):current_health_percent()
	local var_63_1 = arg_63_1.hp_at_mounted
	local var_63_2 = Unit.local_position(arg_63_0, 0)
	local var_63_3 = Managers.state.side.side_by_unit[arg_63_0]
	local var_63_4 = var_63_3.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_63_5 = var_63_3.ENEMY_PLAYER_AND_BOT_UNITS
	local var_63_6 = 0
	local var_63_7 = 4

	for iter_63_0, iter_63_1 in ipairs(var_63_4) do
		local var_63_8 = var_63_5[iter_63_0]

		if var_63_7 > Vector3.distance(var_63_2, iter_63_1) and not ScriptUnit.extension(var_63_8, "status_system"):is_disabled() then
			var_63_6 = var_63_6 + 1
		end
	end

	arg_63_1.surrounding_players = var_63_6

	if var_63_1 - var_63_0 >= 0.25 then
		AiBreedSnippets.on_stormfiend_boss_dismount(arg_63_0, arg_63_1)
	end
end

AiBreedSnippets.on_stormfiend_boss_dismount = function (arg_64_0, arg_64_1)
	local var_64_0 = arg_64_1.linked_unit

	if HEALTH_ALIVE[var_64_0] then
		local var_64_1 = BLACKBOARDS[var_64_0]
		local var_64_2 = var_64_1.mounted_data
		local var_64_3 = Managers.state.network
		local var_64_4 = var_64_1.locomotion_extension

		LocomotionUtils.set_animation_driven_movement(var_64_0, true, true, false)
		var_64_4:use_lerp_rotation(false)
		var_64_4:set_movement_type("snap_to_navmesh")
		var_64_3:anim_event_with_variable_float(var_64_0, "stagger_weakspot_fall_off", "stagger_scale", 1.2)

		local var_64_5 = Managers.time:time("game")

		var_64_2.knocked_off_mounted_timer = var_64_5 + 30
		var_64_1.stagger_immune_time = var_64_5 + 5
		arg_64_1.linked_unit = nil

		local var_64_6 = Managers.state.network:game()
		local var_64_7 = Managers.state.unit_storage:go_id(arg_64_0)
		local var_64_8 = Managers.state.unit_storage:go_id(var_64_0)

		if var_64_6 and var_64_7 and var_64_8 then
			GameSession.set_game_object_field(var_64_6, var_64_7, "animation_synced_unit_id", 0)
		end
	end
end

AiBreedSnippets.on_grey_seer_spawn = function (arg_65_0, arg_65_1)
	local var_65_0 = Managers.time:time("game")
	local var_65_1 = World.get_data(arg_65_1.world, "physics_world")

	arg_65_1.aggro_list = {}

	if Managers.state.difficulty:get_difficulty_rank() >= 2 then
		arg_65_1.trickle_timer = Managers.time:time("game") + 20
	else
		print("no trickle, difficulty:", Managers.state.difficulty:get_difficulty_rank())
	end

	arg_65_1.magic_missile_data = {
		range = 40,
		name = "magic_missile",
		magic_missile = true,
		magic_missile_speed = 20,
		true_flight_template_name = "sorcerer_magic_missile",
		projectile_unit_name = "units/weapons/projectile/warp_lightning_bolt/warp_lightning_bolt",
		read_from_missile_data = true,
		explosion_template_name = "grey_seer_warp_lightning_impact",
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}
	arg_65_1.plague_wave_data = {
		name = "plague_wave",
		plague_wave_timer = var_65_0 + 10,
		physics_world = var_65_1,
		target_starting_pos = Vector3Box(),
		plague_wave_rot = QuaternionBox(),
		search_func = BTChaosExaltedSorcererSkulkAction.update_plague_wave
	}
	arg_65_1.spell_count = 0
	arg_65_1.phase = "magic_missile"
	arg_65_1.current_spell = arg_65_1.magic_missile_data
	arg_65_1.face_target_while_summoning = true
	arg_65_1.mounted_data = {}
	arg_65_1.hit_reaction_extension = ScriptUnit.extension(arg_65_0, "hit_reaction_system")

	arg_65_1.hit_reaction_extension:set_hit_effect_template_id("HitEffectsSkavenGreySeerMounted")

	arg_65_1.current_phase = 1
	arg_65_1.intro_timer = var_65_0 + 15
	arg_65_1.current_hit_reaction_type = "mounted"
	arg_65_1.damage_wave_template_name = "vermintide"

	Managers.state.conflict:add_unit_to_bosses(arg_65_0)

	arg_65_1.is_valid_target_func = GenericStatusExtension.is_lord_target

	local var_65_2 = Managers.state.conflict.level_analysis
	local var_65_3 = var_65_2.generic_ai_node_units.grey_seer_death_sequence

	if var_65_3 then
		local var_65_4 = {}

		for iter_65_0 = 1, #var_65_3 do
			local var_65_5 = var_65_3[iter_65_0]
			local var_65_6 = Unit.local_position(var_65_5, 0)

			var_65_4[#var_65_4 + 1] = Vector3Box(var_65_6)
		end

		arg_65_1.death_sequence_positions = var_65_4
	else
		print("Grey seer: Found no death sequence positions")
	end

	local var_65_7 = var_65_2.generic_ai_node_units.grey_seer_teleport_position

	if var_65_7 then
		local var_65_8 = {}

		for iter_65_1 = 1, #var_65_7 do
			local var_65_9 = var_65_7[iter_65_1]
			local var_65_10 = Unit.local_position(var_65_9, 0)

			var_65_8[#var_65_8 + 1] = Vector3Box(var_65_10)
		end

		arg_65_1.defensive_teleport_positions = var_65_8
	else
		print("Grey seer: Found no defensive teleport positions")
	end

	local var_65_11 = var_65_2.generic_ai_node_units.grey_seer_call_stormfiend_position

	if var_65_11 then
		local var_65_12 = {}

		for iter_65_2 = 1, #var_65_11 do
			local var_65_13 = var_65_11[iter_65_2]
			local var_65_14 = Unit.local_position(var_65_13, 0)

			var_65_12[#var_65_12 + 1] = Vector3Box(var_65_14)
		end

		arg_65_1.call_stormfiend_positions = var_65_12
	else
		print("Grey seer: Found no call stormfiend positions")
	end
end

AiBreedSnippets.on_grey_seer_update = function (arg_66_0, arg_66_1, arg_66_2)
	local var_66_0 = arg_66_1.mounted_data
	local var_66_1 = ScriptUnit.extension(arg_66_1.unit, "health_system"):current_health_percent()
	local var_66_2 = Unit.local_position(arg_66_0, 0)
	local var_66_3 = arg_66_1.current_phase
	local var_66_4 = var_66_0.mount_unit
	local var_66_5 = ScriptUnit.extension_input(arg_66_0, "dialogue_system")

	if arg_66_1.intro_timer or var_66_3 == 6 then
		return
	end

	if arg_66_1.current_phase ~= 5 and arg_66_1.death_sequence then
		arg_66_1.current_phase = 5

		local var_66_6 = FrameTable.alloc_table()

		var_66_5:trigger_networked_dialogue_event("egs_death_scene", var_66_6)

		arg_66_1.face_player_when_teleporting = true
		arg_66_1.death_sequence = nil

		local var_66_7 = true
		local var_66_8 = true
		local var_66_9 = "skittergate_grey_seer_trickle"
		local var_66_10
		local var_66_11
		local var_66_12 = Managers.state.conflict
		local var_66_13 = arg_66_1.side.side_id

		var_66_12.horde_spawner:execute_event_horde(arg_66_2, var_66_11, var_66_13, var_66_9, var_66_10, var_66_8, nil, var_66_7)
	elseif var_66_3 == 2 and var_66_1 < 0.5 then
		arg_66_1.current_phase = 3
	elseif var_66_3 == 1 and var_66_1 < 0.75 then
		arg_66_1.current_phase = 2
	end

	if not HEALTH_ALIVE[var_66_4] and arg_66_1.current_phase ~= 5 and arg_66_1.current_phase ~= 6 then
		if arg_66_1.current_phase ~= 4 then
			local var_66_14 = FrameTable.alloc_table()

			var_66_5:trigger_networked_dialogue_event("egs_stormfiend_dead", var_66_14)
		end

		arg_66_1.current_phase = 4
		arg_66_1.knocked_off_mount = true
		arg_66_1.call_stormfiend = nil
		arg_66_1.about_to_mount = nil
		arg_66_1.should_mount_unit = nil
	end

	if arg_66_1.unlink_unit then
		arg_66_1.unlink_unit = nil

		local var_66_15 = var_66_4 and BLACKBOARDS[var_66_4]

		if var_66_15 then
			var_66_15.linked_unit = nil
		end

		arg_66_1.quick_teleport_timer = arg_66_2 + 10
		arg_66_1.quick_teleport = nil
		arg_66_1.hp_at_knocked_off = var_66_1

		local var_66_16 = Managers.state.network:game()
		local var_66_17 = Managers.state.unit_storage:go_id(var_66_4)

		if var_66_16 and var_66_17 then
			GameSession.set_game_object_field(var_66_16, var_66_17, "animation_synced_unit_id", 0)
		end
	end

	local var_66_18 = 0.25

	if var_66_0.knocked_off_mounted_timer and arg_66_1.hp_at_knocked_off and var_66_18 <= arg_66_1.hp_at_knocked_off - var_66_1 then
		var_66_0.knocked_off_mounted_timer = arg_66_2
	end

	if arg_66_1.knocked_off_mount and HEALTH_ALIVE[var_66_4] then
		local var_66_19 = BLACKBOARDS[var_66_4]
		local var_66_20 = var_66_0.knocked_off_mounted_timer and arg_66_2 >= var_66_0.knocked_off_mounted_timer

		if not arg_66_1.call_stormfiend and not var_66_19.intro_rage and var_66_20 and not var_66_19.goal_position and not var_66_19.anim_cb_move then
			arg_66_1.call_stormfiend = true
		elseif var_66_20 then
			arg_66_1.about_to_mount = true

			local var_66_21 = Unit.local_position(var_66_4, 0)

			if Vector3.distance(var_66_2, var_66_21) < 2 then
				arg_66_1.knocked_off_mount = nil
				arg_66_1.should_mount_unit = true
				arg_66_1.ready_to_summon = nil
				arg_66_1.about_to_mount = nil
				arg_66_1.call_stormfiend = nil
				var_66_19.should_mount_unit = true
				var_66_19.hp_at_mounted = ScriptUnit.extension(var_66_4, "health_system"):current_health_percent()
			end
		end
	end

	if arg_66_1.trickle_timer and arg_66_2 > arg_66_1.trickle_timer and not arg_66_1.defensive_mode_duration and var_66_3 < 4 then
		local var_66_22 = Managers.state.conflict
		local var_66_23 = var_66_1 * 12

		if arg_66_1.knocked_off_mount or not HEALTH_ALIVE[var_66_4] then
			var_66_23 = var_66_23 * 0.5
		end

		if var_66_22:count_units_by_breed("skaven_slave") < 4 then
			local var_66_24 = true
			local var_66_25 = true
			local var_66_26 = "skittergate_grey_seer_trickle"
			local var_66_27
			local var_66_28
			local var_66_29 = arg_66_1.side.side_id

			var_66_22.horde_spawner:execute_event_horde(arg_66_2, var_66_28, var_66_29, var_66_26, var_66_27, var_66_25, nil, var_66_24)

			arg_66_1.trickle_timer = arg_66_2 + var_66_23
		else
			arg_66_1.trickle_timer = arg_66_2 + var_66_23
		end
	end

	if arg_66_1.missile_bot_threat_unit then
		local var_66_30 = Unit.local_position(arg_66_1.missile_bot_threat_unit, 0)
		local var_66_31 = 2
		local var_66_32 = 1
		local var_66_33 = var_66_32 * 0.5
		local var_66_34 = Vector3(0, var_66_31, var_66_33)
		local var_66_35 = var_66_30 - Vector3.up() * var_66_33

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_66_35, "cylinder", var_66_34, nil, 1, "Gray Seer")

		arg_66_1.missile_bot_threat_unit = nil
	end
end

AiBreedSnippets.on_grey_seer_death = function (arg_67_0, arg_67_1)
	local var_67_0 = Managers.state.conflict

	var_67_0:remove_unit_from_bosses(arg_67_0)

	local var_67_1 = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(var_67_1, 120, 20, true)

	if arg_67_1.is_angry then
		var_67_0:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(3, Vector3(-308, -364, -126), true, arg_67_0)
end

AiBreedSnippets.on_grey_seer_despawn = function (arg_68_0, arg_68_1, arg_68_2)
	local var_68_0 = Managers.state.conflict

	var_68_0:remove_unit_from_bosses(arg_68_0)

	if arg_68_1.is_angry then
		var_68_0:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_gutter_runner_spawn = function (arg_69_0, arg_69_1)
	arg_69_1.initial_pounce_timer = Managers.time:time("game") + math.random(2, 3)

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_69_0, "heard_enemy", DialogueSettings.enemies_distant_distance, "enemy_tag", "skaven_gutter_runner")
end

AiBreedSnippets.update_enemy_sighting_within_commander_sticky = function (arg_70_0)
	local var_70_0 = false

	repeat
		if not HEALTH_ALIVE[arg_70_0.target_unit] then
			break
		end

		if arg_70_0.override_target_selection_name or arg_70_0.ability_spawned then
			var_70_0 = true

			break
		end

		if HEALTH_ALIVE[arg_70_0.commander_target] then
			var_70_0 = true

			break
		end

		arg_70_0.commander_target = nil

		if arg_70_0.stick_to_enemy_t then
			if Managers.time:time("game") < arg_70_0.stick_to_enemy_t then
				var_70_0 = true

				break
			else
				arg_70_0.stick_to_enemy_t = nil
			end
		end

		if arg_70_0.attack_token or arg_70_0.keep_target then
			var_70_0 = true

			break
		end

		local var_70_1 = arg_70_0.detection_source_pos:unbox()
		local var_70_2 = Vector3.distance_squared(var_70_1, Unit.local_position(arg_70_0.target_unit, 0))
		local var_70_3 = 1
		local var_70_4 = arg_70_0.detection_radius + var_70_3

		if var_70_2 < var_70_4 * var_70_4 then
			var_70_0 = true
		end
	until true

	arg_70_0.target_unit = var_70_0 and arg_70_0.target_unit or nil
	arg_70_0.confirmed_enemy_sighting_within_commander = var_70_0

	arg_70_0.commander_extension:set_in_combat(arg_70_0.unit, var_70_0)

	local var_70_5 = arg_70_0.breed.commanded_unit_aggro_sound

	if var_70_5 then
		local var_70_6 = Managers.time:time("game")

		arg_70_0.last_in_combat_t = arg_70_0.last_in_combat_t or var_70_6

		local var_70_7 = 2

		if arg_70_0.target_unit and arg_70_0.command_state ~= CommandStates.Attacking and var_70_6 > arg_70_0.last_in_combat_t + var_70_7 then
			Managers.state.entity:system("dialogue_system"):trigger_general_unit_event(arg_70_0.unit, var_70_5)
		end

		arg_70_0.last_in_combat_t = arg_70_0.target_unit and var_70_6 or arg_70_0.last_in_combat_t
	end
end

DLCUtils.require_list("ai_breed_snippets_file_names")
