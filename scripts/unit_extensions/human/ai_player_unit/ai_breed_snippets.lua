-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_breed_snippets.lua

local script_data = script_data
local AiBreedSnippets = AiBreedSnippets

AiBreedSnippets = AiBreedSnippets or {}
AiBreedSnippets = AiBreedSnippets

local distance = Vector3.distance

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_1_0].ENEMY_PLAYER_AND_BOT_UNITS
	local breed = arg_1_1.breed
	local perception_weights = breed.perception_weights
	local num = 0
	local var_1_4

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_1_5 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local var_1_6 = POSITION_LOOKUP[var_1_5]
		local var_1_7 = POSITION_LOOKUP[arg_1_0]
		local var_1_8 = distance(var_1_7, var_1_6)

		if var_1_8 < breed.detection_radius then
			local clamp = math.clamp(1 - var_1_8 / perception_weights.max_distance, 0, 1)
			local num_2 = clamp * clamp * perception_weights.distance_weight

			if num < num_2 then
				num = num_2
				var_1_4 = var_1_5
			end
		end
	end

	if not var_1_4 then
		arg_1_1.aggro_list[var_1_4] = 50

		print("Boss gave ", var_1_4, "initial aggro")
	end
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local breed = arg_2_1.breed
	local extension = ScriptUnit.extension(arg_2_0, "ai_system")

	if not arg_2_1.optional_spawn_data.spawn_behind_door then
		extension:set_perception(breed.perception, breed.target_selection)

		local main_paths = arg_2_2.main_path_info.main_paths
		local closest_pos_at_main_path, var_2_4 = MainPathUtils.closest_pos_at_main_path(main_paths, POSITION_LOOKUP[arg_2_0])

		arg_2_1.waiting = {
			next_player_unit_index = 1,
			awake_on_players_passing = true,
			view_cone_dot = 1,
			next_update_time = 0,
			travel_dist = var_2_4
		}
	else
		extension:set_perception(breed.perception, breed.target_selection_angry)
		arg_2_2:add_angry_boss(1, arg_2_1)

		arg_2_1.is_angry = true

		fn(arg_2_0, arg_2_1)
	end
end

AiBreedSnippets.on_rat_ogre_spawn = function (arg_3_0, arg_3_1)
	-- function 3
	arg_3_1.cycle_rage_anim_index = 0
	arg_3_1.aggro_list = {}
	arg_3_1.fling_skaven_timer = 0
	arg_3_1.next_move_check = 0
	arg_3_1.is_valid_target_func = GenericStatusExtension.is_ogre_target

	local conflict = Managers.state.conflict

	fn_2(arg_3_0, arg_3_1, conflict)
	conflict:freeze_intensity_decay(10)
	conflict:add_unit_to_bosses(arg_3_0)
end

AiBreedSnippets.on_rat_ogre_death = function (arg_4_0, arg_4_1)
	-- function 4
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_4_0)
	print("rat ogre died!")

	if not arg_4_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.reward_boss_kill_loot(arg_4_0, arg_4_1)
end

AiBreedSnippets.on_rat_ogre_despawn = function (arg_5_0, arg_5_1)
	-- function 5
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_5_0)
	print("rat ogre was despawned!")

	if not arg_5_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	if not arg_5_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_5_0, arg_5_1)
	end
end

local function fn_3(arg_6_0, arg_6_1)
	-- function 6
	local system = Managers.state.entity:system("audio_system")

	system:play_2d_audio_event("Stop_stormfiend_ambience")

	local global_sound_parameter = BreedActions.skaven_stormfiend.shoot.global_sound_parameter

	system:set_global_parameter_with_lerp(global_sound_parameter, 0)

	local network_transmit = Managers.state.network.network_transmit
	local var_6_3 = NetworkLookup.global_parameter_names[global_sound_parameter]

	network_transmit:send_rpc_clients("rpc_client_audio_set_global_parameter_with_lerp", var_6_3, 0)

	arg_6_1.group_blackboard.firewall_environment_intensity = 0
end

AiBreedSnippets.on_stormfiend_spawn = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_1.aggro_list = {}
	arg_7_1.fling_skaven_timer = 0
	arg_7_1.next_move_check = 0

	local conflict = Managers.state.conflict

	fn_2(arg_7_0, arg_7_1, conflict)
	conflict:freeze_intensity_decay(10)
	conflict:add_unit_to_bosses(arg_7_0)

	local name = arg_7_1.breed.name

	if conflict:count_units_by_breed(name) == 0 then
		Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_stormfiend_ambience")
	end
end

AiBreedSnippets.on_stormfiend_death = function (arg_8_0, arg_8_1)
	-- function 8
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_8_0)
	print("stormfiend died!")

	local name = arg_8_1.breed.name

	if conflict:count_units_by_breed(name) == 0 then
		fn_3(arg_8_0, arg_8_1)
	end

	if not arg_8_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.reward_boss_kill_loot(arg_8_0, arg_8_1)
end

AiBreedSnippets.on_stormfiend_despawn = function (arg_9_0, arg_9_1)
	-- function 9
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_9_0)

	local name = arg_9_1.breed.name

	if conflict:count_units_by_breed(name) == 0 then
		fn_3(arg_9_0, arg_9_1)
	end

	if not arg_9_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	if not arg_9_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_9_0, arg_9_1)
	end
end

AiBreedSnippets.on_stormfiend_demo_death = function (arg_10_0, arg_10_1)
	-- function 10
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_10_0)

	local name = arg_10_1.breed.name

	if conflict:count_units_by_breed(name) == 0 then
		fn_3(arg_10_0, arg_10_1)
	end

	if not arg_10_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.on_stormfiend_demo_shoot(arg_10_0, arg_10_1)
end

AiBreedSnippets.on_stormfiend_demo_despawn = function (arg_11_0, arg_11_1)
	-- function 11
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_11_0)

	local name = arg_11_1.breed.name

	if conflict:count_units_by_breed(name) == 0 then
		fn_3(arg_11_0, arg_11_1)
	end

	if not arg_11_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.on_stormfiend_demo_shoot(arg_11_0, arg_11_1)
end

AiBreedSnippets.on_stormfiend_demo_shoot = function (arg_12_0, arg_12_1)
	-- function 12
	local world = arg_12_1.world

	LevelHelper:flow_event(world, "demo_fire_event")

	local target_unit = arg_12_1.target_unit
	local num = POSITION_LOOKUP[arg_12_0] - POSITION_LOOKUP[target_unit]
	local look = Quaternion.look(num, Vector3.up())
	local extension = ScriptUnit.extension(target_unit, "first_person_system")

	extension:disable_rig_movement()
	extension:force_look_rotation(look, 1)
	Managers.time:set_global_time_scale_lerp(0.1, 0.5)

	local num_2 = 0.9

	Managers.state.entity:system("audio_system"):set_global_parameter_with_lerp("demo_slowmo", num_2)
end

AiBreedSnippets.on_loot_rat_update = function (arg_13_0, arg_13_1)
	-- function 13
	local time = Managers.time:time("game")
	local dodge_cooldown_time = arg_13_1.dodge_cooldown_time

	if not (not dodge_cooldown_time and not (dodge_cooldown_time < time)) then
		local breed = arg_13_1.breed
		local in_crosshairs_dodge, var_13_4 = LocomotionUtils.in_crosshairs_dodge(arg_13_0, arg_13_1, time, breed.dodge_crosshair_radius, breed.dodge_crosshair_delay, breed.dodge_crosshair_min_distance, breed.dodge_crosshair_max_distance)

		if not in_crosshairs_dodge then
			arg_13_1.dodge_vector = Vector3Box(in_crosshairs_dodge)
			arg_13_1.threat_vector = Vector3Box(var_13_4)
			arg_13_1.dodge_cooldown_time = time + arg_13_1.breed.dodge_cooldown
		end
	end
end

AiBreedSnippets.on_loot_rat_alerted = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local time = Managers.time:time("game")
	local dodge_cooldown_time = arg_14_1.dodge_cooldown_time

	if not (not dodge_cooldown_time and not (dodge_cooldown_time < time)) then
		local breed = arg_14_1.breed
		local var_14_3
		local var_14_4

		if not (arg_14_0 ~= arg_14_2 or not (arg_14_1.dodge_damage_points > 0)) then
			var_14_3, var_14_4 = LocomotionUtils.on_alerted_dodge(arg_14_0, arg_14_1, arg_14_2, arg_14_3)

			if not var_14_3 then
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

		ScriptUnit.extension(arg_14_0, "ai_system"):set_perception(breed.perception, breed.target_selection_alerted)

		arg_14_1.dodge_vector = var_14_3
		arg_14_1.threat_vector = var_14_4
		arg_14_1.dodge_cooldown_time = time + arg_14_1.breed.dodge_cooldown
	end
end

AiBreedSnippets.on_loot_rat_stagger_action_done = function (arg_15_0)
	-- function 15
	if not Unit.alive(arg_15_0) then
		ScriptUnit.extension(arg_15_0, "health_system"):regen_dodge_damage_points()
	end
end

AiBreedSnippets.on_skaven_explosive_loot_rat_spawn = function (arg_16_0)
	-- function 16
	if not Unit.alive(arg_16_0) then
		local has_extension = ScriptUnit.has_extension(arg_16_0, "buff_system")
		local str = "enemy_kill_timer"

		has_extension:add_buff(str)
	end
end

AiBreedSnippets.on_chaos_troll_spawn = function (arg_17_0, arg_17_1)
	-- function 17
	arg_17_1.aggro_list = {}
	arg_17_1.fling_skaven_timer = 0
	arg_17_1.can_get_downed = true
	arg_17_1.crouch_sticky_timer = 0
	arg_17_1.displaced_units = {}
	arg_17_1.next_move_check = 0
	arg_17_1.next_rage_time = 0

	local breed = arg_17_1.breed
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_17_2 = breed.max_health_regen_per_sec[get_difficulty_rank]

	var_17_2 = var_17_2 or breed.max_health_regen_per_sec[2]
	arg_17_1.max_health_regen_per_sec = var_17_2

	local var_17_3 = breed.max_health_regen_time[get_difficulty_rank]

	var_17_3 = var_17_3 or breed.max_health_regen_time[2]
	arg_17_1.max_health_regen_time = var_17_3

	local flag = true

	if not ScriptUnit.has_extension(arg_17_0, "ai_group_system") then
		flag = not ScriptUnit.extension(arg_17_0, "ai_group_system").in_patrol
	end

	if not flag then
		local conflict = Managers.state.conflict

		fn_2(arg_17_0, arg_17_1, conflict)
		conflict:freeze_intensity_decay(10)
		conflict:add_unit_to_bosses(arg_17_0)
	end
end

AiBreedSnippets.on_chaos_troll_chief_spawn = function (arg_18_0, arg_18_1)
	-- function 18
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

	local breed = arg_18_1.breed
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_18_2 = breed.max_health_regen_per_sec[get_difficulty_rank]

	var_18_2 = var_18_2 or breed.max_health_regen_per_sec[2]
	arg_18_1.max_health_regen_per_sec = var_18_2

	local var_18_3 = breed.max_health_regen_time[get_difficulty_rank]

	var_18_3 = var_18_3 or breed.max_health_regen_time[2]
	arg_18_1.max_health_regen_time = var_18_3

	local flag = true

	if not ScriptUnit.has_extension(arg_18_0, "ai_group_system") then
		flag = not ScriptUnit.extension(arg_18_0, "ai_group_system").in_patrol
	end

	if not flag then
		local conflict = Managers.state.conflict

		fn_2(arg_18_0, arg_18_1, conflict)
		conflict:freeze_intensity_decay(10)
		conflict:add_unit_to_bosses(arg_18_0)
	end
end

AiBreedSnippets.on_chaos_troll_chief_update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if not Managers.state.network.is_server then
		return
	end

	local running_downed_chunk_events = arg_19_1.running_downed_chunk_events
	local running_upped_chunk_events = arg_19_1.running_upped_chunk_events
	local extension = ScriptUnit.extension(arg_19_0, "health_system")

	if not (extension.state == "down") then
		for k, v in pairs(running_upped_chunk_events) do
			if not v.finish then
				v.finish(arg_19_0, arg_19_1, k)
			end

			running_upped_chunk_events[k] = nil
		end

		local respawn_thresholds, var_19_4, var_19_5, var_19_6, var_19_7 = extension:respawn_thresholds()

		if not running_downed_chunk_events[var_19_7] then
			for k_2, v_2 in pairs(BreedActions[arg_19_1.breed.name].downed.downed_chunk_events) do
				repeat
					if (k_2 == var_19_7 or type(k_2) ~= "table" or not table.contains(k_2, var_19_7)) and not v_2.condition_func and not v_2.condition_func(arg_19_0, arg_19_1, var_19_7, arg_19_2, arg_19_3) then
						v_2.start(arg_19_0, arg_19_1, var_19_7, arg_19_2, arg_19_3)

						running_downed_chunk_events[var_19_7] = v_2
					end

					break
				until true
			end
		elseif not running_downed_chunk_events[var_19_7].update then
			running_downed_chunk_events[var_19_7].update(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		end
	else
		for k_3, v_3 in pairs(running_downed_chunk_events) do
			if not v_3.finish then
				v_3.finish(arg_19_0, arg_19_1, k_3)
			end

			running_downed_chunk_events[k_3] = nil
		end

		local respawn_thresholds_2, var_19_9, var_19_10, var_19_11, var_19_12 = extension:respawn_thresholds()

		if not running_upped_chunk_events[var_19_12] then
			for k_4, v_4 in pairs(BreedActions[arg_19_1.breed.name].downed.upped_chunk_events) do
				repeat
					if (k_4 == var_19_12 or type(k_4) ~= "table" or not table.contains(k_4, var_19_12)) and not v_4.condition_func and not v_4.condition_func(arg_19_0, arg_19_1, var_19_12, arg_19_2, arg_19_3) then
						v_4.start(arg_19_0, arg_19_1, var_19_12, arg_19_2, arg_19_3)

						running_upped_chunk_events[var_19_12] = v_4
					end

					break
				until true
			end
		elseif not running_upped_chunk_events[var_19_12].update then
			running_upped_chunk_events[var_19_12].update(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		end
	end
end

AiBreedSnippets.on_chaos_troll_chief_death = function (arg_20_0, arg_20_1)
	-- function 20
	AiBreedSnippets.on_chaos_troll_death(arg_20_0, arg_20_1)

	local running_downed_chunk_events = arg_20_1.running_downed_chunk_events

	for k, v in pairs(running_downed_chunk_events) do
		if not v.finish then
			v.finish(arg_20_0, arg_20_1)
		end

		running_downed_chunk_events[k] = nil
	end

	local running_upped_chunk_events = arg_20_1.running_upped_chunk_events

	for k_2, v_2 in pairs(running_upped_chunk_events) do
		if not v_2.finish then
			v_2.finish(arg_20_0, arg_20_1)
		end

		running_upped_chunk_events[k_2] = nil
	end
end

AiBreedSnippets.on_chaos_troll_chief_despawn = function (arg_21_0, arg_21_1)
	-- function 21
	AiBreedSnippets.on_chaos_troll_despawn(arg_21_0, arg_21_1)

	local running_downed_chunk_events = arg_21_1.running_downed_chunk_events

	for k, v in pairs(running_downed_chunk_events) do
		if not v.finish then
			v.finish(arg_21_0, arg_21_1)
		end

		running_downed_chunk_events[k] = nil
	end

	local running_upped_chunk_events = arg_21_1.running_upped_chunk_events

	for k_2, v_2 in pairs(running_upped_chunk_events) do
		if not v_2.finish then
			v_2.finish(arg_21_0, arg_21_1)
		end

		running_upped_chunk_events[k_2] = nil
	end
end

AiBreedSnippets.on_chaos_troll_death = function (arg_22_0, arg_22_1)
	-- function 22
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_22_0)
	print("chaos troll died!")

	if not arg_22_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.reward_boss_kill_loot(arg_22_0, arg_22_1)
end

AiBreedSnippets.on_chaos_troll_despawn = function (arg_23_0, arg_23_1)
	-- function 23
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_23_0)
	print("chaos troll was despawned!")

	if not arg_23_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	if not arg_23_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_23_0, arg_23_1)
	end
end

AiBreedSnippets.on_chaos_dummy_troll_spawn = function (arg_24_0, arg_24_1)
	-- function 24
	arg_24_1.aggro_list = {}
	arg_24_1.can_get_downed = true
	arg_24_1.crouch_sticky_timer = 0
	arg_24_1.displaced_units = {}

	local breed = arg_24_1.breed
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_24_2 = breed.max_health_regen_per_sec[get_difficulty_rank]

	var_24_2 = var_24_2 or breed.max_health_regen_per_sec[2]
	arg_24_1.max_health_regen_per_sec = var_24_2

	local var_24_3 = breed.max_health_regen_time[get_difficulty_rank]

	var_24_3 = var_24_3 or breed.max_health_regen_time[2]
	arg_24_1.max_health_regen_time = var_24_3
	arg_24_1.idle_sound_timer = Managers.time:time("game") + 2
	arg_24_1.play_alert = true
end

AiBreedSnippets.on_chaos_dummy_troll_update = function (arg_25_0, arg_25_1)
	-- function 25
	local time = Managers.time:time("game")
	local idle_sound_timer = arg_25_1.idle_sound_timer
	local system = Managers.state.entity:system("audio_system")

	if not arg_25_1.play_alert then
		system:play_audio_unit_event("Play_enemy_troll_vce_alert", arg_25_0)

		arg_25_1.play_alert = nil

		AiUtils.enter_combat(arg_25_0, arg_25_1)
	end

	if not (not idle_sound_timer and not (idle_sound_timer < time)) then
		system:play_audio_unit_event("Play_enemy_troll_vce_idle", arg_25_0)

		arg_25_1.idle_sound_timer = nil
	end
end

AiBreedSnippets.on_chaos_dummy_troll_death = function (arg_26_0, arg_26_1)
	-- function 26
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_enemy_troll_vce_hurt", arg_26_0)
end

AiBreedSnippets.on_chaos_dummy_sorcerer_spawn = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	ScriptUnit.extension(arg_27_0, "health_system").is_invincible = true
end

AiBreedSnippets.on_storm_vermin_champion_spawn = function (arg_28_0, arg_28_1)
	-- function 28
	local breed = arg_28_1.breed

	arg_28_1.aggro_list = {}
	arg_28_1.next_move_check = 0
	arg_28_1.spawned_allies_wave = 0
	arg_28_1.surrounding_players = 0
	arg_28_1.current_phase = 1
	arg_28_1.spawn_type = nil
	arg_28_1.surrounding_players_last = -math.huge
	arg_28_1.run_speed = breed.run_speed
	arg_28_1.inventory_item_set = 1
	arg_28_1.switching_weapons = 2
	arg_28_1.dual_wield_timer = Managers.time:time("game") + 30
	arg_28_1.dual_wield_mode = true
	arg_28_1.num_times_hit_skaven = 0

	if not breed.displace_players_data then
		arg_28_1.displaced_units = {}
	end

	if Managers.state.difficulty:get_difficulty_rank() >= 2 then
		arg_28_1.trickle_timer = Managers.time:time("game") + 8
	else
		print("no trickle, difficulty:", Managers.state.difficulty:get_difficulty_rank())
	end

	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(10)
	conflict:add_unit_to_bosses(arg_28_0)

	local actor = Unit.actor(arg_28_0, "c_trophy_rack_ward")

	Actor.set_collision_enabled(actor, false)
	Actor.set_scene_query_enabled(actor, false)

	arg_28_1.intro_timer = Managers.time:time("game") + 10
	arg_28_1.is_valid_target_func = GenericStatusExtension.is_lord_target

	local warlord_go_to = Managers.state.conflict.level_analysis.generic_ai_node_units.warlord_go_to

	if not warlord_go_to then
		local tbl = {}

		for i = 1, #warlord_go_to do
			local var_28_5 = warlord_go_to[i]
			local local_position = Unit.local_position(var_28_5, 0)

			tbl[#tbl + 1] = Vector3Box(local_position)
		end

		arg_28_1.spawn_allies_positions = tbl
	end
end

AiBreedSnippets.on_storm_vermin_champion_husk_spawn = function (arg_29_0)
	-- function 29
	local actor = Unit.actor(arg_29_0, "c_trophy_rack_ward")

	Actor.set_collision_enabled(actor, false)
	Actor.set_scene_query_enabled(actor, false)
end

AiBreedSnippets.on_storm_vermin_hot_join_sync = function (arg_30_0, arg_30_1)
	-- function 30
	if not BLACKBOARDS[arg_30_1].ward_active then
		local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_30_0)
		local var_30_1 = PEER_ID_TO_CHANNEL[arg_30_0]

		RPC.rpc_set_ward_state(var_30_1, unit_game_object_id, true)
	end
end

AiBreedSnippets.on_storm_vermin_champion_update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local var_31_0 = Managers.state.side.side_by_unit[arg_31_0]
	local ENEMY_PLAYER_AND_BOT_UNITS = var_31_0.ENEMY_PLAYER_AND_BOT_UNITS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = var_31_0.ENEMY_PLAYER_AND_BOT_POSITIONS
	local local_position = Unit.local_position(arg_31_0, 0)
	local radius = BreedActions.skaven_storm_vermin_champion.special_attack_spin.radius
	local num = 0

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_POSITIONS) do
		local var_31_6 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not (not (radius > Vector3.distance(local_position, v)) or ScriptUnit.extension(var_31_6, "status_system"):is_disabled() or ScriptUnit.extension(var_31_6, "status_system"):is_invisible()) then
			num = num + 1
		end
	end

	arg_31_1.surrounding_players = num

	if arg_31_1.surrounding_players > 0 then
		arg_31_1.surrounding_players_last = arg_31_2
	end

	if not (not arg_31_1.trickle_timer and not (arg_31_2 > arg_31_1.trickle_timer) or arg_31_1.defensive_mode_duration) then
		local conflict = Managers.state.conflict

		if conflict:count_units_by_breed("skaven_slave") < 4 then
			local flag = true
			local flag_2 = true
			local str = "stronghold_boss_trickle"
			local var_31_11
			local var_31_12
			local side_id = var_31_0.side_id

			conflict.horde_spawner:execute_event_horde(arg_31_2, var_31_12, side_id, str, var_31_11, flag_2, nil, flag)

			arg_31_1.trickle_timer = arg_31_2 + 15
		else
			arg_31_1.trickle_timer = arg_31_2 + 10
		end
	end

	local breed = arg_31_1.breed

	if not arg_31_1.dual_wield_mode then
		if (not (arg_31_2 > arg_31_1.dual_wield_timer) or not arg_31_1.active_node) and not arg_31_1.defensive_mode_duration then
			arg_31_1.dual_wield_timer = arg_31_2 + 20
			arg_31_1.dual_wield_mode = false
		end
	else
		local current_health_percent = ScriptUnit.extension(arg_31_1.unit, "health_system"):current_health_percent()

		if not (arg_31_1.current_phase ~= 2 or not (current_health_percent < 0.15)) then
			arg_31_1.current_phase = 3

			local angry_run_speed = breed.angry_run_speed

			arg_31_1.run_speed = angry_run_speed

			if not arg_31_1.run_speed_overridden then
				arg_31_1.navigation_extension:set_max_speed(angry_run_speed)
			end
		elseif not (arg_31_1.current_phase ~= 1 or not (current_health_percent < 0.8)) then
			arg_31_1.current_phase = 2
		end

		if not arg_31_1.defensive_mode_duration then
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
		elseif not (not (arg_31_2 > arg_31_1.dual_wield_timer) or arg_31_1.active_node) then
			arg_31_1.dual_wield_mode = true
			arg_31_1.dual_wield_timer = arg_31_2 + 20
		end
	end

	if not arg_31_1.displaced_units then
		AiUtils.push_intersecting_players(arg_31_0, arg_31_0, arg_31_1.displaced_units, breed.displace_players_data, arg_31_2, arg_31_3)
	end
end

AiBreedSnippets.on_storm_vermin_champion_death = function (arg_32_0, arg_32_1)
	-- function 32
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_32_0)

	local time = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(time, 160, 20, true)

	if not arg_32_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(2, Vector3(166.5, -46, 38), true, arg_32_0)
end

AiBreedSnippets.on_storm_vermin_champion_despawn = function (arg_33_0, arg_33_1)
	-- function 33
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_33_0)

	if not arg_33_1.is_angry then
		conflict:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_chaos_warrior_spawn = function (arg_34_0, arg_34_1)
	-- function 34
	arg_34_1.displaced_units = {}
	arg_34_1.aggro_list = {}
end

AiBreedSnippets.on_chaos_warrior_update = function (arg_35_0, arg_35_1, arg_35_2)
	-- function 35
	local displace_players_data = arg_35_1.breed.displace_players_data

	if not (not displace_players_data and HEALTH_ALIVE[arg_35_0]) then
		return
	end

	AiUtils.push_intersecting_players(arg_35_0, arg_35_0, arg_35_1.displaced_units, displace_players_data, arg_35_2)
end

AiBreedSnippets.on_chaos_tentacle_despawn = function (arg_36_0, arg_36_1)
	-- function 36
	local tentacle_data = arg_36_1.tentacle_data

	if not tentacle_data and not tentacle_data.portal_unit then
		local portal_unit = tentacle_data.portal_unit

		Managers.state.entity:system("audio_system"):play_audio_unit_event("Stop_enemy_sorcerer_portal_loop", portal_unit, "a_surface_center")
		Managers.state.unit_spawner:mark_for_deletion(portal_unit)
	end

	local boss_master_unit = arg_36_1.boss_master_unit

	if not boss_master_unit and not Unit.alive(boss_master_unit) then
		local var_36_3 = BLACKBOARDS[boss_master_unit]

		var_36_3.num_portals_alive = var_36_3.num_portals_alive - 1
		var_36_3.tentacle_portal_units[arg_36_0] = nil
	end
end

AiBreedSnippets.on_chaos_spawn_spawn = function (arg_37_0, arg_37_1)
	-- function 37
	arg_37_1.aggro_list = {}
	arg_37_1.fling_skaven_timer = 0
	arg_37_1.next_move_check = 0
	arg_37_1.cycle_rage_anim_index = 0
	arg_37_1.attack_grabbed_attacks = 0
	arg_37_1.chew_attacks_done = 0
	arg_37_1.grabbed_time = 0
	arg_37_1.chaos_spawn_is_throwing = false
	arg_37_1.is_valid_target_func = GenericStatusExtension.is_chaos_spawn_target

	local conflict = Managers.state.conflict

	fn_2(arg_37_0, arg_37_1, conflict)
	conflict:freeze_intensity_decay(10)
	conflict:add_unit_to_bosses(arg_37_0)
end

AiBreedSnippets.on_chaos_spawn_death = function (arg_38_0, arg_38_1)
	-- function 38
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_38_0)
	print("chaos spawn died!")

	if not arg_38_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.reward_boss_kill_loot(arg_38_0, arg_38_1)
end

AiBreedSnippets.on_chaos_spawn_despawn = function (arg_39_0, arg_39_1)
	-- function 39
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_39_0)

	if not arg_39_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	if not arg_39_1.rewarded_boss_loot then
		AiBreedSnippets.reward_boss_kill_loot(arg_39_0, arg_39_1)
	end
end

AiBreedSnippets.on_chaos_vortex_sorcerer_spawn = function (arg_40_0, arg_40_1)
	-- function 40
	arg_40_1.max_vortex_units = arg_40_1.breed.max_vortex_units
	arg_40_1.spell_count = 0

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_40_0, "heard_enemy", DialogueSettings.hear_chaos_vortex_sorcerer, "enemy_tag", "chaos_vortex_sorcerer")
end

function remove_vortex_units(arg_41_0, arg_41_1)
	-- function 41
	local vortex_data = arg_41_1.vortex_data
	local conflict = Managers.state.conflict

	if not arg_41_1.breed.no_despawn_when_master_dies then
		return
	end

	local flag = not vortex_data and vortex_data.vortex_units

	if not flag then
		for i, v in ipairs(flag) do
			if not Unit.alive(v) then
				local var_41_3 = BLACKBOARDS[v]

				conflict:destroy_unit(v, var_41_3, "vortex")
			end
		end

		table.clear(flag)
	end

	local flag_2 = not vortex_data and vortex_data.queued_vortex

	if not flag_2 then
		local unit_spawner = Managers.state.unit_spawner

		for k, v_2 in pairs(flag_2) do
			conflict:remove_queued_unit(k)

			local inner_decal_unit = v_2.inner_decal_unit

			if not Unit.alive(inner_decal_unit) then
				unit_spawner:mark_for_deletion(inner_decal_unit)
			end

			local outer_decal_unit = v_2.outer_decal_unit

			if not Unit.alive(outer_decal_unit) then
				unit_spawner:mark_for_deletion(outer_decal_unit)
			end

			flag_2[k] = nil
		end
	end
end

AiBreedSnippets.on_chaos_vortex_sorcerer_death = function (arg_42_0, arg_42_1)
	-- function 42
	remove_vortex_units(arg_42_0, arg_42_1)
end

AiBreedSnippets.on_chaos_vortex_sorcerer_despawn = function (arg_43_0, arg_43_1)
	-- function 43
	remove_vortex_units(arg_43_0, arg_43_1)
end

AiBreedSnippets.on_chaos_sorcerer_spawn = function (arg_44_0, arg_44_1)
	-- function 44
	arg_44_1.spell_count = 0
end

AiBreedSnippets.on_chaos_exalted_sorcerer_spawn = function (arg_45_0, arg_45_1)
	-- function 45
	local time = Managers.time:time("game")
	local breed = arg_45_1.breed

	arg_45_1.max_vortex_units = breed.max_vortex_units
	arg_45_1.done_casting_timer = 0
	arg_45_1.spawned_allies_wave = 0
	arg_45_1.recent_attacker_timer = 0
	arg_45_1.recent_melee_attacker_timer = 0
	arg_45_1.health_extension = ScriptUnit.extension(arg_45_0, "health_system")
	arg_45_1.num_portals_alive = 0
	arg_45_1.tentacle_portal_units = {}

	local tbl = {}
	local tbl_2 = {}
	local get_data = World.get_data(arg_45_1.world, "physics_world")

	arg_45_1.spell_count = 0

	local tbl_3 = {
		spawn_timer = 3,
		name = "vortex",
		physics_world = get_data,
		vortex_units = {},
		queued_vortex = {},
		vortex_spawn_pos = Vector3Box(),
		search_func = BTChaosSorcererSkulkApproachAction._update_vortex_search,
		spawn_func = BTChaosSorcererSummoningAction._spawn_vortex
	}

	arg_45_1.vortex_data = tbl_3
	tbl[#tbl + 1] = tbl_3
	tbl_2.vortex = tbl_3

	local tbl_4 = {
		name = "boss_vortex",
		spawn_timer = 3,
		physics_world = get_data,
		vortex_units = {},
		queued_vortex = {},
		vortex_spawn_pos = Vector3Box(),
		spawn_func = BTChaosSorcererSummoningAction._spawn_boss_vortex
	}

	arg_45_1.boss_vortex_data = tbl_4
	tbl[#tbl + 1] = tbl_4
	tbl_2.boss_vortex = tbl_4

	local tbl_5 = {
		name = "plague_wave",
		plague_wave_timer = time + 10,
		physics_world = get_data,
		target_starting_pos = Vector3Box(),
		plague_wave_rot = QuaternionBox(),
		search_func = BTChaosExaltedSorcererSkulkAction.update_plague_wave
	}

	arg_45_1.plague_wave_data = tbl_5
	tbl[#tbl + 1] = tbl_5
	tbl_2.plague_wave = tbl_5

	local tbl_6 = {
		name = "tentacle",
		search_counter = 0,
		chance_to_look_for_wall_spawn = 0.5,
		portal_spawn_type = "n/a",
		portal_search_timer = time + 3,
		cover_units = {},
		portal_spawn_pos = Vector3Box(),
		portal_spawn_rot = QuaternionBox(),
		physics_world = get_data,
		search_func = BTChaosSorcererSkulkApproachAction.update_portal_search,
		spawn_func = BTChaosSorcererSummoningAction.spawn_portal
	}

	arg_45_1.portal_data = tbl_6
	tbl[#tbl + 1] = tbl_6
	tbl_2.tentacle = tbl_6

	local tbl_7 = {
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

	arg_45_1.magic_missile_data = tbl_7
	tbl[#tbl + 1] = tbl_7
	tbl_2.magic_missile = tbl_7

	local tbl_8 = {
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

	arg_45_1.sorcerer_strike_missile_data = tbl_8
	tbl[#tbl + 1] = tbl_8
	tbl_2.sorcerer_strike_missile = tbl_8

	local tbl_9 = {
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

	arg_45_1.magic_missile_ground_data = tbl_9
	tbl[#tbl + 1] = tbl_9
	tbl_2.magic_missile_ground = tbl_9

	local tbl_10 = {
		name = "missile_barrage",
		magic_missile = true,
		magic_missile_speed = 20,
		range = 40,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}

	arg_45_1.missile_barrage_data = tbl_10
	tbl[#tbl + 1] = tbl_10
	tbl_2.missile_barrage = tbl_10

	local tbl_11 = {
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

	arg_45_1.seeking_bomb_missile_data = tbl_11
	tbl[#tbl + 1] = tbl_11
	tbl_2.seeking_bomb_missile = tbl_11

	local tbl_12 = {
		name = "dummy",
		search_func = BTChaosExaltedSorcererSkulkAction.update_dummy
	}

	arg_45_1.dummy_data = tbl_12
	tbl[#tbl + 1] = tbl_12
	tbl_2.dummy = tbl_12

	local _id_lookup = Managers.state.entity:system("spawner_system")._id_lookup
	local level_analysis = Managers.state.conflict.level_analysis
	local sorcerer_boss_center = level_analysis.generic_ai_node_units.sorcerer_boss_center
	local sorcerer_boss_wall = level_analysis.generic_ai_node_units.sorcerer_boss_wall

	if not sorcerer_boss_center and not sorcerer_boss_wall then
		-- Nothing
	end

	::label_45_1::

	local sorcerer_boss = _id_lookup.sorcerer_boss

	sorcerer_boss = not sorcerer_boss and _id_lookup.sorcerer_boss_minion

	::label_45_2::

	if not sorcerer_boss then
		local var_45_20 = sorcerer_boss_center[1]

		arg_45_1.in_boss_arena = Vector3.distance(POSITION_LOOKUP[arg_45_0], Unit.local_position(var_45_20, 0)) < 20
	else
		arg_45_1.in_boss_arena = false
	end

	if not arg_45_1.in_boss_arena then
		arg_45_1.spawners = {
			sorcerer_boss_center = sorcerer_boss_center
		}
		arg_45_1.mode = "setup"
		arg_45_1.phase_timer = time + 999
		arg_45_1.intro_timer = time + 21

		local var_45_21 = sorcerer_boss_center[1]
		local num = Unit.local_position(var_45_21, 0) + Vector3(0, 0, 0.75)
		local local_rotation = Unit.local_rotation(var_45_21, 0)

		arg_45_1.arena_pose_boxed = Matrix4x4Box(Matrix4x4.from_quaternion_position(local_rotation, num))
		arg_45_1.arena_half_extents = Vector3Box(12, 12, 1)

		arg_45_1.valid_teleport_pos_func = function (arg_46_0, arg_46_1)
			-- function 46
			local unbox = arg_46_1.arena_pose_boxed:unbox()
			local unbox_2 = arg_46_1.arena_half_extents:unbox()

			return (math.point_is_inside_oobb(arg_46_0, unbox, unbox_2))
		end
	else
		arg_45_1.phase = "offensive"

		arg_45_1.valid_teleport_pos_func = function (arg_47_0, arg_47_1)
			-- function 47
			return true
		end

		print("Sorcerer boss not in arena")
	end

	arg_45_1.spells = tbl
	arg_45_1.spells_lookup = tbl_2

	local var_45_24 = NetworkLookup.effects["fx/chr_chaos_sorcerer_teleport"]
	local num_2 = 0
	local identity = Quaternion.identity()

	Managers.state.network:rpc_play_particle_effect(nil, var_45_24, NetworkConstants.invalid_game_object_id, num_2, POSITION_LOOKUP[arg_45_0], identity, false)

	local system = Managers.state.entity:system("audio_system")

	if not breed.teleport_sound_event then
		system:play_audio_unit_event(breed.teleport_sound_event, arg_45_0)
	end

	Managers.state.conflict:add_unit_to_bosses(arg_45_0)

	arg_45_1.is_valid_target_func = GenericStatusExtension.is_lord_target
end

function check_for_recent_attackers(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local flag = arg_48_3 or 100
	local recent_damages, var_48_2 = ScriptUnit.extension(arg_48_0, "health_system"):recent_damages()

	if var_48_2 > 0 then
		local var_48_3 = recent_damages[DamageDataIndex.ATTACKER]
		local side = arg_48_1.side
		local var_48_5 = recent_damages[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_48_6 = rawget(ItemMasterList, var_48_5)
		local flag_2 = not var_48_6 and var_48_6.slot_type == "melee"

		if not Unit.alive(var_48_3) and not side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_48_3] then
			if not (not (flag < Vector3.distance_squared(Unit.local_position(arg_48_0, 0), Unit.local_position(var_48_3, 0))) or flag_2) then
				arg_48_1.target_unit = var_48_3
				arg_48_1.recent_attacker_unit = var_48_3
				arg_48_1.recent_attacker_timer = arg_48_2 + 3
				arg_48_1.recent_attacker = true

				local extension_input = ScriptUnit.extension_input(arg_48_0, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				extension_input:trigger_networked_dialogue_event("ebh_retaliation_missile", alloc_table)
			elseif not flag_2 then
				arg_48_1.target_unit = var_48_3
				arg_48_1.recent_melee_attacker_unit = var_48_3
				arg_48_1.recent_melee_attacker_timer = arg_48_2 + 0.35
				arg_48_1.recent_melee_attacker = true
			end
		end
	elseif not arg_48_1.recent_attacker then
		if arg_48_2 > arg_48_1.recent_attacker_timer then
			arg_48_1.recent_attacker_unit = nil
			arg_48_1.recent_attacker_timer = math.huge
			arg_48_1.recent_attacker = false
		end
	elseif not (not arg_48_1.recent_melee_attacker and not (arg_48_2 > arg_48_1.recent_melee_attacker_timer)) then
		arg_48_1.recent_melee_attacker_unit = nil
		arg_48_1.recent_melee_attacker_timer = math.huge
		arg_48_1.recent_melee_attacker = false
	end
end

local flag = false

AiBreedSnippets.on_chaos_exalted_sorcerer_update = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	check_for_recent_attackers(arg_49_0, arg_49_1, arg_49_2)

	if not arg_49_1.in_boss_arena then
		return
	end

	if not arg_49_1.intro_timer then
		return
	end

	if not flag then
		local unbox = arg_49_1.arena_pose_boxed:unbox()
		local unbox_2 = arg_49_1.arena_half_extents:unbox()

		QuickDrawer:box(unbox, unbox_2, Color(0, 255, 70))
	end

	local phase = arg_49_1.phase
	local mode = arg_49_1.mode

	arg_49_1.can_spawn_portals = arg_49_1.num_portals_alive < 1

	if mode == "defensive" then
		if phase == "defensive_completed" then
			arg_49_1.mode = "offensive"
			arg_49_1.phase_timer = arg_49_2 + 20
		elseif arg_49_2 > arg_49_1.phase_timer then
			arg_49_1.phase = "defensive_ends"
		end
	elseif mode == "offensive" then
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

	if not arg_49_1.missle_bot_threat_unit then
		local local_position = Unit.local_position(arg_49_1.missle_bot_threat_unit, 0)
		local num = 2
		local num_2 = 1
		local num_3 = num_2 * 0.5
		local var_49_8 = Vector3(0, num, num_3)
		local num_4 = local_position - Vector3.up() * num_3

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(num_4, "cylinder", var_49_8, nil, 1, "Exalted Sorcerer")

		arg_49_1.missle_bot_threat_unit = nil
	end
end

AiBreedSnippets.reward_boss_kill_loot = function (arg_50_0, arg_50_1)
	-- function 50
	local get_boss_loot_pickup = Managers.state.game_mode:get_boss_loot_pickup()

	if not get_boss_loot_pickup then
		return
	end

	if not arg_50_1.deny_kill_loot then
		return
	end

	local nav_world = arg_50_1.nav_world
	local local_position = Unit.local_position(arg_50_0, 0)
	local num = 1
	local num_2 = 1

	if Managers.mechanism:current_mechanism_name() == "versus" then
		nav_world = Managers.state.entity:system("ai_system"):nav_world()
	end

	local var_50_5
	local triangle_from_position, var_50_7 = GwNavQueries.triangle_from_position(nav_world, local_position, num_2, num)

	if not triangle_from_position then
		var_50_5 = Vector3.copy(local_position)
		var_50_5.z = var_50_7
	else
		local num_3 = 2
		local num_4 = 0.05

		var_50_5 = GwNavQueries.inside_position_from_outside_position(nav_world, local_position, num_2, num, num_3, num_4)
	end

	var_50_5 = var_50_5 or local_position

	local get_data = Unit.get_data(arg_50_0, "breed")
	local flag = not get_data and get_data.name
	local tbl = {
		pickup_system = {
			has_physics = true,
			spawn_type = "loot",
			pickup_name = get_boss_loot_pickup,
			dropped_by_breed = flag
		}
	}
	local var_50_13 = AllPickups[get_boss_loot_pickup]
	local unit_name = var_50_13.unit_name
	local unit_template_name = var_50_13.unit_template_name

	unit_template_name = unit_template_name or "pickup_unit"

	local identity = Quaternion.identity()
	local var_50_17 = Vector3(0, 0, 0.6)

	Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, var_50_5 + var_50_17, identity)

	arg_50_1.rewarded_boss_loot = true
end

AiBreedSnippets.drop_loot = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	local get_boss_loot_pickup = Managers.state.game_mode:get_boss_loot_pickup()

	if not get_boss_loot_pickup then
		return
	end

	local flag = not arg_51_3 and Unit.get_data(arg_51_3, "breed")
	local flag_2 = not flag and flag.name

	for i = 1, arg_51_0 do
		local tbl = {
			pickup_system = {
				spawn_type = "loot",
				pickup_name = get_boss_loot_pickup,
				has_physics = arg_51_2,
				dropped_by_breed = flag_2
			}
		}
		local var_51_4 = AllPickups[get_boss_loot_pickup]
		local unit_name = var_51_4.unit_name
		local unit_template_name = var_51_4.unit_template_name

		unit_template_name = unit_template_name or "pickup_unit"

		local num = i / arg_51_0 * 2 * math.pi
		local num_2 = arg_51_1 + Vector3(math.cos(num), math.sin(num), 0)
		local identity = Quaternion.identity()

		Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, num_2, identity)
	end
end

AiBreedSnippets.on_chaos_exalted_sorcerer_death = function (arg_52_0, arg_52_1)
	-- function 52
	local conflict = Managers.state.conflict

	conflict:remove_unit_from_bosses(arg_52_0)

	local time = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(time, 120, 20, true)

	if not arg_52_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(2, Vector3(362.5, 51.6, -9.1), true, arg_52_0)
end

AiBreedSnippets.on_chaos_exalted_sorcerer_despawn = function (arg_53_0, arg_53_1)
	-- function 53
	local conflict = Managers.state.conflict

	conflict:remove_unit_from_bosses(arg_53_0)

	if not arg_53_1.is_angry then
		conflict:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_chaos_exalted_champion_spawn = function (arg_54_0, arg_54_1)
	-- function 54
	local time = Managers.time:time("game")
	local breed = arg_54_1.breed

	arg_54_1.aggro_list = {}
	arg_54_1.next_move_check = 0
	arg_54_1.spawned_allies_wave = 0
	arg_54_1.surrounding_players = 0
	arg_54_1.current_phase = 1
	arg_54_1.spawn_type = nil
	arg_54_1.surrounding_players_last = -math.huge
	arg_54_1.run_speed = breed.run_speed
	arg_54_1.cheer_state = 1
	arg_54_1.intro_timer = time + 10

	if not breed.displace_players_data then
		arg_54_1.displaced_units = {}
	end

	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(10)
	conflict:add_unit_to_bosses(arg_54_0)

	arg_54_1.cheer_timer = time + math.random(15, 30)
	arg_54_1.walla_sync_timer = time + 2
	arg_54_1.ray_can_go_update_time = time + 0.5

	local chaos_exalted_defensive_move_to = Managers.state.conflict.level_analysis.generic_ai_node_units.chaos_exalted_defensive_move_to

	if not chaos_exalted_defensive_move_to then
		local var_54_4 = chaos_exalted_defensive_move_to[1]
		local local_position = Unit.local_position(var_54_4, 0)

		arg_54_1.override_spawn_allies_call_position = Vector3Box(local_position)
	end

	arg_54_1.is_valid_target_func = GenericStatusExtension.is_lord_target
	arg_54_1.num_times_hit_chaos_warrior = 0
end

AiBreedSnippets.on_chaos_exalted_champion_norsca_spawn = function (arg_55_0, arg_55_1)
	-- function 55
	local time = Managers.time:time("game")
	local breed = arg_55_1.breed

	arg_55_1.aggro_list = {}
	arg_55_1.next_move_check = 0
	arg_55_1.current_phase = 1
	arg_55_1.spawn_type = nil
	arg_55_1.run_speed = breed.run_speed

	if not breed.displace_players_data then
		arg_55_1.displaced_units = {}
	end

	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(10)
	conflict:add_unit_to_bosses(arg_55_0)
	conflict:add_angry_boss(1, arg_55_1)

	arg_55_1.is_angry = true
	arg_55_1.ray_can_go_update_time = time + 0.5
	arg_55_1.is_valid_target_func = GenericStatusExtension.is_lord_target

	local enemy_package_loader = Managers.level_transition_handler.enemy_package_loader
	local wanted_breed_transform = BreedActions.chaos_exalted_champion.transform.wanted_breed_transform

	if not enemy_package_loader:is_breed_processed(wanted_breed_transform) then
		enemy_package_loader:request_breed(wanted_breed_transform, true)
	end
end

AiBreedSnippets.on_chaos_exalted_champion_update = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	local local_position = Unit.local_position(arg_56_0, 0)
	local breed = arg_56_1.breed
	local radius = BreedActions.chaos_exalted_champion.special_attack_aoe.radius
	local num = 0
	local num_2 = 0
	local var_56_5 = Managers.state.side.side_by_unit[arg_56_0]
	local ENEMY_PLAYER_AND_BOT_POSITIONS = var_56_5.ENEMY_PLAYER_AND_BOT_POSITIONS
	local ENEMY_PLAYER_AND_BOT_UNITS = var_56_5.ENEMY_PLAYER_AND_BOT_UNITS

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_POSITIONS) do
		local var_56_8 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not (not (radius > Vector3.distance(local_position, v)) or ScriptUnit.extension(var_56_8, "status_system"):is_disabled() or ScriptUnit.extension(var_56_8, "status_system"):is_invisible()) then
			num = num + 1
		end

		if not ScriptUnit.extension(var_56_8, "status_system"):is_knocked_down() then
			num_2 = num_2 - 1
		else
			num_2 = num_2 + ScriptUnit.extension(var_56_8, "health_system"):current_health_percent()
		end
	end

	arg_56_1.surrounding_players = num

	if arg_56_1.surrounding_players > 0 then
		arg_56_1.surrounding_players_last = arg_56_2
	end

	local num_3 = num_2 / 4
	local current_health_percent = ScriptUnit.extension(arg_56_0, "health_system"):current_health_percent()

	if not (arg_56_1.current_phase ~= 1 or not (current_health_percent < 0.75)) then
		local angry_run_speed = breed.angry_run_speed

		arg_56_1.run_speed = angry_run_speed

		if not arg_56_1.run_speed_overridden then
			arg_56_1.navigation_extension:set_max_speed(angry_run_speed)
		end
	end

	if not arg_56_1.override_spawn_allies_call_position then
		if not (arg_56_1.current_phase ~= 1 or not (current_health_percent < 0.7)) then
			arg_56_1.current_phase = 2
			arg_56_1.trickle_timer = arg_56_2 + 10
		elseif not (arg_56_1.current_phase ~= 2 or not (current_health_percent < 0.4)) then
			arg_56_1.current_phase = 3
		end
	end

	local conflict = Managers.state.conflict

	if not arg_56_1.defensive_mode_duration then
		local num_4 = arg_56_1.defensive_mode_duration - arg_56_3

		if num_4 <= 0 then
			arg_56_1.defensive_mode_duration = nil
		else
			arg_56_1.defensive_mode_duration = num_4
		end
	end

	if not (not (current_health_percent > 0.05) or not arg_56_1.trickle_timer and not (arg_56_2 > arg_56_1.trickle_timer) or arg_56_1.defensive_mode_duration) then
		local num_5 = current_health_percent * 15
		local max = math.max(num_5, 5)

		if conflict:count_units_by_breed("chaos_marauder") < 3 then
			local flag = true
			local flag_2 = true
			local str = "warcamp_boss_event_trickle"
			local var_56_19
			local str_2 = "warcamp_boss_minions"
			local side_id = var_56_5.side_id

			conflict.horde_spawner:execute_event_horde(arg_56_2, str_2, side_id, str, var_56_19, flag_2, nil, flag)

			arg_56_1.trickle_timer = arg_56_2 + max
		else
			arg_56_1.trickle_timer = arg_56_2 + max
		end
	end

	if not arg_56_1.displaced_units then
		AiUtils.push_intersecting_players(arg_56_0, arg_56_0, arg_56_1.displaced_units, breed.displace_players_data, arg_56_2, arg_56_3)
	end

	AiBreedSnippets.update_exalted_champion_cheer_state(arg_56_0, arg_56_1, arg_56_2, arg_56_3, num_3)

	if not (arg_56_2 > arg_56_1.ray_can_go_update_time) or not Unit.alive(arg_56_1.target_unit) then
		local nav_world = arg_56_1.nav_world
		local local_position_2 = Unit.local_position(arg_56_1.target_unit, 0)

		arg_56_1.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(nav_world, Unit.local_position(arg_56_0, 0), local_position_2, nil, 1, 1)
		arg_56_1.ray_can_go_update_time = arg_56_2 + 0.5
	end
end

AiBreedSnippets.update_exalted_champion_cheer_state = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	-- function 57
	local network_transmit = Managers.state.network.network_transmit
	local system = Managers.state.entity:system("audio_system")
	local current_health_percent = ScriptUnit.extension(arg_57_1.unit, "health_system"):current_health_percent()
	local wwise_world = Managers.world:wwise_world(arg_57_1.world)
	local num = (current_health_percent - arg_57_4) * 5
	local min = math.min(num + 1, 5)
	local max = math.max(min, 0)
	local min_2 = math.min(max, 4)
	local ceil = math.ceil(min_2)

	if arg_57_2 > arg_57_1.cheer_timer then
		WwiseWorld.set_global_parameter(wwise_world, "champion_crowd_voices", 0)
		system:set_global_parameter_with_lerp("champion_crowd_voices", ceil)

		arg_57_1.cheer_timer = arg_57_2 + math.random(10, 25)

		local champion_crowd_voices = NetworkLookup.global_parameter_names.champion_crowd_voices

		network_transmit:send_rpc_clients("rpc_client_audio_set_global_parameter", champion_crowd_voices, ceil)
	end

	system:set_global_parameter("champion_crowd_voices_walla", max)

	if arg_57_2 > arg_57_1.walla_sync_timer then
		local champion_crowd_voices_walla = NetworkLookup.global_parameter_names.champion_crowd_voices_walla

		network_transmit:send_rpc_clients("rpc_client_audio_set_global_parameter", champion_crowd_voices_walla, max)

		arg_57_1.walla_sync_timer = arg_57_2 + 2
	end
end

AiBreedSnippets.on_chaos_exalted_champion_norsca_update = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	local breed = arg_58_1.breed
	local current_health_percent = ScriptUnit.extension(arg_58_1.unit, "health_system"):current_health_percent()

	if not (arg_58_1.current_phase ~= 1 or not (current_health_percent < 0.7)) then
		arg_58_1.current_phase = 2
	end

	if not arg_58_1.displaced_units then
		AiUtils.push_intersecting_players(arg_58_0, arg_58_0, arg_58_1.displaced_units, breed.displace_players_data, arg_58_2, arg_58_3)
	end

	if not (arg_58_2 > arg_58_1.ray_can_go_update_time) or not arg_58_1.target_unit then
		local nav_world = arg_58_1.nav_world
		local local_position = Unit.local_position(arg_58_1.target_unit, 0)

		arg_58_1.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(nav_world, Unit.local_position(arg_58_0, 0), local_position, nil, 1, 1)
		arg_58_1.ray_can_go_update_time = arg_58_2 + 0.5
	end
end

AiBreedSnippets.on_chaos_exalted_champion_death = function (arg_59_0, arg_59_1)
	-- function 59
	local conflict = Managers.state.conflict

	conflict:remove_unit_from_bosses(arg_59_0)

	local wwise_world = Managers.world:wwise_world(arg_59_1.world)

	WwiseWorld.set_global_parameter(wwise_world, "champion_crowd_voices", 0)
	WwiseWorld.set_global_parameter(wwise_world, "champion_crowd_voices", 1)

	arg_59_1.override_spawn_allies_call_position = nil

	local time = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(time, 120, 20, true)

	if not arg_59_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(2, Vector3(231, -75, 45), true, arg_59_0)
end

AiBreedSnippets.on_chaos_exalted_champion_norsca_death = function (arg_60_0, arg_60_1)
	-- function 60
	local conflict = Managers.state.conflict

	conflict:freeze_intensity_decay(1)
	conflict:remove_unit_from_bosses(arg_60_0)

	local time = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(time, 40, 20, true)

	if not arg_60_1.is_angry then
		conflict:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_chaos_exalted_champion_despawn = function (arg_61_0, arg_61_1)
	-- function 61
	local conflict = Managers.state.conflict

	conflict:remove_unit_from_bosses(arg_61_0)

	if not arg_61_1.is_angry then
		conflict:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_stormfiend_boss_spawn = function (arg_62_0, arg_62_1)
	-- function 62
	AiBreedSnippets.on_stormfiend_spawn(arg_62_0, arg_62_1)

	arg_62_1.hp_at_mounted = ScriptUnit.extension(arg_62_1.unit, "health_system"):current_health_percent()
	ScriptUnit.extension(arg_62_0, "health_system").is_invincible = true
	arg_62_1.current_phase = 1
end

AiBreedSnippets.on_stormfiend_boss_update = function (arg_63_0, arg_63_1)
	-- function 63
	local current_health_percent = ScriptUnit.extension(arg_63_1.unit, "health_system"):current_health_percent()
	local hp_at_mounted = arg_63_1.hp_at_mounted
	local local_position = Unit.local_position(arg_63_0, 0)
	local var_63_3 = Managers.state.side.side_by_unit[arg_63_0]
	local ENEMY_PLAYER_AND_BOT_POSITIONS = var_63_3.ENEMY_PLAYER_AND_BOT_POSITIONS
	local ENEMY_PLAYER_AND_BOT_UNITS = var_63_3.ENEMY_PLAYER_AND_BOT_UNITS
	local num = 0
	local num_2 = 4

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_POSITIONS) do
		local var_63_8 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not (not (num_2 > Vector3.distance(local_position, v)) or ScriptUnit.extension(var_63_8, "status_system"):is_disabled()) then
			num = num + 1
		end
	end

	arg_63_1.surrounding_players = num

	if hp_at_mounted - current_health_percent >= 0.25 then
		AiBreedSnippets.on_stormfiend_boss_dismount(arg_63_0, arg_63_1)
	end
end

AiBreedSnippets.on_stormfiend_boss_dismount = function (arg_64_0, arg_64_1)
	-- function 64
	local linked_unit = arg_64_1.linked_unit

	if not HEALTH_ALIVE[linked_unit] then
		local var_64_1 = BLACKBOARDS[linked_unit]
		local mounted_data = var_64_1.mounted_data
		local network = Managers.state.network
		local locomotion_extension = var_64_1.locomotion_extension

		LocomotionUtils.set_animation_driven_movement(linked_unit, true, true, false)
		locomotion_extension:use_lerp_rotation(false)
		locomotion_extension:set_movement_type("snap_to_navmesh")
		network:anim_event_with_variable_float(linked_unit, "stagger_weakspot_fall_off", "stagger_scale", 1.2)

		local time = Managers.time:time("game")

		mounted_data.knocked_off_mounted_timer = time + 30
		var_64_1.stagger_immune_time = time + 5
		arg_64_1.linked_unit = nil

		local game = Managers.state.network:game()
		local go_id = Managers.state.unit_storage:go_id(arg_64_0)
		local go_id_2 = Managers.state.unit_storage:go_id(linked_unit)

		if not game and not go_id and not go_id_2 then
			GameSession.set_game_object_field(game, go_id, "animation_synced_unit_id", 0)
		end
	end
end

AiBreedSnippets.on_grey_seer_spawn = function (arg_65_0, arg_65_1)
	-- function 65
	local time = Managers.time:time("game")
	local get_data = World.get_data(arg_65_1.world, "physics_world")

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
		plague_wave_timer = time + 10,
		physics_world = get_data,
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
	arg_65_1.intro_timer = time + 15
	arg_65_1.current_hit_reaction_type = "mounted"
	arg_65_1.damage_wave_template_name = "vermintide"

	Managers.state.conflict:add_unit_to_bosses(arg_65_0)

	arg_65_1.is_valid_target_func = GenericStatusExtension.is_lord_target

	local level_analysis = Managers.state.conflict.level_analysis
	local grey_seer_death_sequence = level_analysis.generic_ai_node_units.grey_seer_death_sequence

	if not grey_seer_death_sequence then
		local tbl = {}

		for i = 1, #grey_seer_death_sequence do
			local var_65_5 = grey_seer_death_sequence[i]
			local local_position = Unit.local_position(var_65_5, 0)

			tbl[#tbl + 1] = Vector3Box(local_position)
		end

		arg_65_1.death_sequence_positions = tbl
	else
		print("Grey seer: Found no death sequence positions")
	end

	local grey_seer_teleport_position = level_analysis.generic_ai_node_units.grey_seer_teleport_position

	if not grey_seer_teleport_position then
		local tbl_2 = {}

		for j = 1, #grey_seer_teleport_position do
			local var_65_9 = grey_seer_teleport_position[j]
			local local_position_2 = Unit.local_position(var_65_9, 0)

			tbl_2[#tbl_2 + 1] = Vector3Box(local_position_2)
		end

		arg_65_1.defensive_teleport_positions = tbl_2
	else
		print("Grey seer: Found no defensive teleport positions")
	end

	local grey_seer_call_stormfiend_position = level_analysis.generic_ai_node_units.grey_seer_call_stormfiend_position

	if not grey_seer_call_stormfiend_position then
		local tbl_3 = {}

		for k = 1, #grey_seer_call_stormfiend_position do
			local var_65_13 = grey_seer_call_stormfiend_position[k]
			local local_position_3 = Unit.local_position(var_65_13, 0)

			tbl_3[#tbl_3 + 1] = Vector3Box(local_position_3)
		end

		arg_65_1.call_stormfiend_positions = tbl_3
	else
		print("Grey seer: Found no call stormfiend positions")
	end
end

AiBreedSnippets.on_grey_seer_update = function (arg_66_0, arg_66_1, arg_66_2)
	-- function 66
	local mounted_data = arg_66_1.mounted_data
	local current_health_percent = ScriptUnit.extension(arg_66_1.unit, "health_system"):current_health_percent()
	local local_position = Unit.local_position(arg_66_0, 0)
	local current_phase = arg_66_1.current_phase
	local mount_unit = mounted_data.mount_unit
	local extension_input = ScriptUnit.extension_input(arg_66_0, "dialogue_system")

	if not (arg_66_1.intro_timer or current_phase ~= 6) then
		return
	end

	if arg_66_1.current_phase == 5 or not arg_66_1.death_sequence then
		arg_66_1.current_phase = 5

		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("egs_death_scene", alloc_table)

		arg_66_1.face_player_when_teleporting = true
		arg_66_1.death_sequence = nil

		local flag = true
		local flag_2 = true
		local str = "skittergate_grey_seer_trickle"
		local var_66_10
		local var_66_11
		local conflict = Managers.state.conflict
		local side_id = arg_66_1.side.side_id

		conflict.horde_spawner:execute_event_horde(arg_66_2, var_66_11, side_id, str, var_66_10, flag_2, nil, flag)
	elseif not (current_phase ~= 2 or not (current_health_percent < 0.5)) then
		arg_66_1.current_phase = 3
	elseif not (current_phase ~= 1 or not (current_health_percent < 0.75)) then
		arg_66_1.current_phase = 2
	end

	if not (HEALTH_ALIVE[mount_unit] or arg_66_1.current_phase == 5 or arg_66_1.current_phase == 6) then
		if arg_66_1.current_phase ~= 4 then
			local alloc_table_2 = FrameTable.alloc_table()

			extension_input:trigger_networked_dialogue_event("egs_stormfiend_dead", alloc_table_2)
		end

		arg_66_1.current_phase = 4
		arg_66_1.knocked_off_mount = true
		arg_66_1.call_stormfiend = nil
		arg_66_1.about_to_mount = nil
		arg_66_1.should_mount_unit = nil
	end

	if not arg_66_1.unlink_unit then
		arg_66_1.unlink_unit = nil

		local flag_3 = not mount_unit and BLACKBOARDS[mount_unit]

		if not flag_3 then
			flag_3.linked_unit = nil
		end

		arg_66_1.quick_teleport_timer = arg_66_2 + 10
		arg_66_1.quick_teleport = nil
		arg_66_1.hp_at_knocked_off = current_health_percent

		local game = Managers.state.network:game()
		local go_id = Managers.state.unit_storage:go_id(mount_unit)

		if not game and not go_id then
			GameSession.set_game_object_field(game, go_id, "animation_synced_unit_id", 0)
		end
	end

	local num = 0.25

	if not (not mounted_data.knocked_off_mounted_timer and not arg_66_1.hp_at_knocked_off and not (num <= arg_66_1.hp_at_knocked_off - current_health_percent)) then
		mounted_data.knocked_off_mounted_timer = arg_66_2
	end

	if not arg_66_1.knocked_off_mount and not HEALTH_ALIVE[mount_unit] then
		local var_66_19 = BLACKBOARDS[mount_unit]
		local knocked_off_mounted_timer = mounted_data.knocked_off_mounted_timer

		knocked_off_mounted_timer = not knocked_off_mounted_timer and arg_66_2 >= mounted_data.knocked_off_mounted_timer

		if not (not not arg_66_1.call_stormfiend or not not var_66_19.intro_rage or not knocked_off_mounted_timer or not not var_66_19.goal_position or not var_66_19.anim_cb_move) then
			arg_66_1.call_stormfiend = true
		elseif not knocked_off_mounted_timer then
			arg_66_1.about_to_mount = true

			local local_position_2 = Unit.local_position(mount_unit, 0)

			if Vector3.distance(local_position, local_position_2) < 2 then
				arg_66_1.knocked_off_mount = nil
				arg_66_1.should_mount_unit = true
				arg_66_1.ready_to_summon = nil
				arg_66_1.about_to_mount = nil
				arg_66_1.call_stormfiend = nil
				var_66_19.should_mount_unit = true
				var_66_19.hp_at_mounted = ScriptUnit.extension(mount_unit, "health_system"):current_health_percent()
			end
		end
	end

	if not (not arg_66_1.trickle_timer and not (arg_66_2 > arg_66_1.trickle_timer) or arg_66_1.defensive_mode_duration or not (current_phase < 4)) then
		local conflict_2 = Managers.state.conflict
		local num_2 = current_health_percent * 12

		if not (arg_66_1.knocked_off_mount or HEALTH_ALIVE[mount_unit]) then
			num_2 = num_2 * 0.5
		end

		if conflict_2:count_units_by_breed("skaven_slave") < 4 then
			local flag_4 = true
			local flag_5 = true
			local str_2 = "skittergate_grey_seer_trickle"
			local var_66_27
			local var_66_28
			local side_id_2 = arg_66_1.side.side_id

			conflict_2.horde_spawner:execute_event_horde(arg_66_2, var_66_28, side_id_2, str_2, var_66_27, flag_5, nil, flag_4)

			arg_66_1.trickle_timer = arg_66_2 + num_2
		else
			arg_66_1.trickle_timer = arg_66_2 + num_2
		end
	end

	if not arg_66_1.missile_bot_threat_unit then
		local local_position_3 = Unit.local_position(arg_66_1.missile_bot_threat_unit, 0)
		local num_3 = 2
		local num_4 = 1
		local num_5 = num_4 * 0.5
		local var_66_34 = Vector3(0, num_3, num_5)
		local num_6 = local_position_3 - Vector3.up() * num_5

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(num_6, "cylinder", var_66_34, nil, 1, "Gray Seer")

		arg_66_1.missile_bot_threat_unit = nil
	end
end

AiBreedSnippets.on_grey_seer_death = function (arg_67_0, arg_67_1)
	-- function 67
	local conflict = Managers.state.conflict

	conflict:remove_unit_from_bosses(arg_67_0)

	local time = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(time, 120, 20, true)

	if not arg_67_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(3, Vector3(-308, -364, -126), true, arg_67_0)
end

AiBreedSnippets.on_grey_seer_despawn = function (arg_68_0, arg_68_1, arg_68_2)
	-- function 68
	local conflict = Managers.state.conflict

	conflict:remove_unit_from_bosses(arg_68_0)

	if not arg_68_1.is_angry then
		conflict:add_angry_boss(-1)
	end
end

AiBreedSnippets.on_gutter_runner_spawn = function (arg_69_0, arg_69_1)
	-- function 69
	arg_69_1.initial_pounce_timer = Managers.time:time("game") + math.random(2, 3)

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_69_0, "heard_enemy", DialogueSettings.enemies_distant_distance, "enemy_tag", "skaven_gutter_runner")
end

AiBreedSnippets.update_enemy_sighting_within_commander_sticky = function (self)
	-- function 70
	local flag = false

	repeat
		if not HEALTH_ALIVE[self.target_unit] then
			break
		end

		if self.override_target_selection_name or not self.ability_spawned then
			flag = true

			break
		end

		if not HEALTH_ALIVE[self.commander_target] then
			flag = true

			break
		end

		self.commander_target = nil

		if not self.stick_to_enemy_t then
			if Managers.time:time("game") < self.stick_to_enemy_t then
				flag = true

				break
			else
				self.stick_to_enemy_t = nil
			end
		end

		if self.attack_token or not self.keep_target then
			flag = true

			break
		end

		local unbox = self.detection_source_pos:unbox()
		local distance_squared = Vector3.distance_squared(unbox, Unit.local_position(self.target_unit, 0))
		local num = 1
		local num_2 = self.detection_radius + num

		if distance_squared < num_2 * num_2 then
			flag = true
		end
	until true

	local target_unit

	if not flag then
		target_unit = self.target_unit

		if not target_unit then
			-- Nothing
		end
	end

	target_unit = nil

	::label_70_0::

	self.target_unit = target_unit
	self.confirmed_enemy_sighting_within_commander = flag

	self.commander_extension:set_in_combat(self.unit, flag)

	local commanded_unit_aggro_sound = self.breed.commanded_unit_aggro_sound

	if not commanded_unit_aggro_sound then
		local time = Managers.time:time("game")
		local last_in_combat_t = self.last_in_combat_t

		last_in_combat_t = last_in_combat_t or time
		self.last_in_combat_t = last_in_combat_t

		local num_3 = 2

		if not (not self.target_unit and self.command_state == CommandStates.Attacking or not (time > self.last_in_combat_t + num_3)) then
			Managers.state.entity:system("dialogue_system"):trigger_general_unit_event(self.unit, commanded_unit_aggro_sound)
		end

		self.last_in_combat_t = not self.target_unit and time and self.last_in_combat_t
	end
end

DLCUtils.require_list("ai_breed_snippets_file_names")
