-- chunkname: @scripts/settings/dlcs/penny/penny_ai_breed_snippets.lua

AiBreedSnippets = AiBreedSnippets or {}

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_3 or 100
	local var_1_1, var_1_2 = ScriptUnit.extension(arg_1_0, "health_system"):recent_damages()

	if var_1_2 > 0 then
		local var_1_3 = var_1_1[DamageDataIndex.ATTACKER]
		local var_1_4 = arg_1_1.side
		local var_1_5 = var_1_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_1_6 = rawget(ItemMasterList, var_1_5)
		local var_1_7 = var_1_6 and var_1_6.slot_type == "melee"

		if Unit.alive(var_1_3) and var_1_4.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_1_3] then
			if var_1_0 < Vector3.distance_squared(POSITION_LOOKUP[arg_1_0], POSITION_LOOKUP[var_1_3]) and not var_1_7 then
				arg_1_1.recent_attacker_unit = var_1_3
				arg_1_1.recent_attacker_timer = arg_1_2 + 3
				arg_1_1.recent_attacker = true

				local var_1_8 = ScriptUnit.extension_input(arg_1_0, "dialogue_system")
				local var_1_9 = FrameTable.alloc_table()

				var_1_8:trigger_networked_dialogue_event("ebh_retaliation_missile", var_1_9)
			elseif var_1_7 then
				arg_1_1.recent_melee_attacker_unit = var_1_3
				arg_1_1.recent_melee_attacker_timer = arg_1_2 + 0.35
				arg_1_1.recent_melee_attacker = true
			end
		end
	elseif arg_1_1.recent_attacker then
		if arg_1_2 > arg_1_1.recent_attacker_timer then
			arg_1_1.recent_attacker_unit = nil
			arg_1_1.recent_attacker_timer = math.huge
			arg_1_1.recent_attacker = false
		end
	elseif arg_1_1.recent_melee_attacker and arg_1_2 > arg_1_1.recent_melee_attacker_timer then
		arg_1_1.recent_melee_attacker_unit = nil
		arg_1_1.recent_melee_attacker_timer = math.huge
		arg_1_1.recent_melee_attacker = false
	end
end

AiBreedSnippets.on_chaos_exalted_sorcerer_drachenfels_spawn = function (arg_2_0, arg_2_1)
	local var_2_0 = Managers.time:time("game")
	local var_2_1 = arg_2_1.breed

	arg_2_1.next_move_check = 0
	arg_2_1.max_vortex_units = var_2_1.max_vortex_units
	arg_2_1.done_casting_timer = 0
	arg_2_1.spawned_allies_wave = 0
	arg_2_1.recent_attacker_timer = 0
	arg_2_1.recent_melee_attacker_timer = 0
	arg_2_1.health_extension = ScriptUnit.extension(arg_2_0, "health_system")
	arg_2_1.num_portals_alive = 0
	arg_2_1.tentacle_portal_units = {}
	arg_2_1.ring_total_cooldown = 20
	arg_2_1.charge_total_cooldown = 20
	arg_2_1.teleport_total_cooldown = 10
	arg_2_1.ring_cooldown = 0
	arg_2_1.charge_cooldown = 0
	arg_2_1.ring_summonings_finished = 0
	arg_2_1.teleport_cooldown = 0
	arg_2_1.ready_to_summon = true
	arg_2_1.surrounding_players = 0
	arg_2_1.aggro_list = {}
	arg_2_1.ring_pulse_rate = 0
	arg_2_1.defensive_phase_duration = 0
	arg_2_1.defensive_phase_max_duration = 60

	local var_2_2 = var_2_1.available_spells
	local var_2_3 = {}
	local var_2_4 = {}
	local var_2_5 = World.get_data(arg_2_1.world, "physics_world")
	local var_2_6 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_center[1]

	arg_2_1.no_kill_achievement = true
	arg_2_1.ring_center_position = Vector3Box(Unit.local_position(var_2_6, 0))
	arg_2_1.spell_count = 0

	local var_2_7 = {
		name = "plague_wave",
		plague_wave_timer = var_2_0 + 10,
		physics_world = var_2_5,
		target_starting_pos = Vector3Box(),
		plague_wave_rot = QuaternionBox(),
		search_func = BTChaosExaltedSorcererSkulkAction.update_plague_wave
	}

	arg_2_1.plague_wave_data = var_2_7
	var_2_3[#var_2_3 + 1] = var_2_7
	var_2_4.plague_wave = var_2_7

	local var_2_8 = {
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

	arg_2_1.magic_missile_data = var_2_8
	var_2_3[#var_2_3 + 1] = var_2_8
	var_2_4.magic_missile = var_2_8

	local var_2_9 = {
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

	arg_2_1.sorcerer_strike_missile_data = var_2_9
	var_2_3[#var_2_3 + 1] = var_2_9
	var_2_4.sorcerer_strike_missile = var_2_9

	local var_2_10 = {
		range = 40,
		name = "magic_missile_ground",
		magic_missile = true,
		magic_missile_speed = 10,
		target_ground = true,
		projectile_unit_name = "units/weapons/projectile/strike_missile_drachenfels/strike_missile_drachenfels",
		true_flight_template_name = "sorcerer_magic_missile_ground",
		explosion_template_name = "chaos_drachenfels_strike_missile_impact",
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}

	arg_2_1.magic_missile_ground_data = var_2_10
	var_2_3[#var_2_3 + 1] = var_2_10
	var_2_4.magic_missile_ground = var_2_10

	local var_2_11 = {
		name = "missile_barrage",
		magic_missile = true,
		magic_missile_speed = 20,
		range = 40,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}

	arg_2_1.missile_barrage_data = var_2_11
	var_2_3[#var_2_3 + 1] = var_2_11
	var_2_4.missile_barrage = var_2_11

	local var_2_12 = {
		range = 40,
		name = "seeking_bomb_missile",
		magic_missile = true,
		magic_missile_speed = 2.5,
		true_flight_template_name = "sorcerer_slow_bomb_missile",
		projectile_unit_name = "units/weapons/projectile/insect_swarm_missile_drachenfels/insect_swarm_missile_drachenfels_01",
		explosion_template_name = "chaos_slow_bomb_missile_new",
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

	arg_2_1.seeking_bomb_missile_data = var_2_12
	var_2_3[#var_2_3 + 1] = var_2_12
	var_2_4.seeking_bomb_missile = var_2_12

	local var_2_13 = {
		name = "dummy",
		search_func = BTChaosExaltedSorcererSkulkAction.update_dummy
	}

	arg_2_1.dummy_data = var_2_13
	var_2_3[#var_2_3 + 1] = var_2_13
	var_2_4.dummy = var_2_13

	local var_2_14 = Managers.state.entity:system("spawner_system")._id_lookup
	local var_2_15 = Managers.state.conflict.level_analysis
	local var_2_16 = var_2_15.generic_ai_node_units.sorcerer_boss_drachenfels_center
	local var_2_17 = var_2_15.generic_ai_node_units.sorcerer_boss_drachenfels_wall

	if var_2_16 and var_2_17 and var_2_14.sorcerer_boss_drachenfels and var_2_14.sorcerer_boss_drachenfels_minion then
		local var_2_18 = var_2_16[1]

		arg_2_1.in_boss_arena = Vector3.distance(POSITION_LOOKUP[arg_2_0], Unit.local_position(var_2_18, 0)) < 20
	else
		arg_2_1.in_boss_arena = false
	end

	if arg_2_1.in_boss_arena then
		arg_2_1.spawners = {
			sorcerer_boss_center = var_2_16
		}
		arg_2_1.mode = "setup"
		arg_2_1.intro_timer = var_2_0 + 12.3

		local var_2_19 = var_2_16[1]
		local var_2_20 = Unit.local_position(var_2_19, 0) + Vector3(0, 0, 0.75)
		local var_2_21 = Unit.local_rotation(var_2_19, 0)

		arg_2_1.arena_pose_boxed = Matrix4x4Box(Matrix4x4.from_quaternion_position(var_2_21, var_2_20))
		arg_2_1.arena_half_extents = Vector3Box(12, 12, 1)

		arg_2_1.valid_teleport_pos_func = function (arg_3_0, arg_3_1)
			local var_3_0 = arg_3_1.arena_pose_boxed:unbox()
			local var_3_1 = arg_3_1.arena_half_extents:unbox()

			return (math.point_is_inside_oobb(arg_3_0, var_3_0, var_3_1))
		end
	else
		arg_2_1.phase = "offensive"

		arg_2_1.valid_teleport_pos_func = function (arg_4_0, arg_4_1)
			return true
		end

		print("Sorcerer boss not in arena")
	end

	local var_2_22 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for iter_2_0, iter_2_1 in pairs(var_2_22) do
		ScriptUnit.extension(iter_2_1, "health_system").is_invincible = true
	end

	arg_2_1.spells = var_2_3
	arg_2_1.spells_lookup = var_2_4

	local var_2_23 = arg_2_1.breed
	local var_2_24 = Managers.state.entity:system("audio_system")

	if var_2_23.teleport_sound_event then
		var_2_24:play_audio_unit_event(var_2_23.teleport_sound_event, arg_2_0)
	end

	Managers.state.conflict:add_unit_to_bosses(arg_2_0)

	arg_2_1.is_valid_target_func = GenericStatusExtension.is_lord_target
end

local var_0_1 = false

AiBreedSnippets.on_chaos_exalted_sorcerer_drachenfels_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	var_0_0(arg_5_0, arg_5_1, arg_5_2, 10)

	if not arg_5_1.in_boss_arena then
		return
	end

	if arg_5_1.intro_timer then
		return
	end

	local var_5_0 = Managers.state.side.side_by_unit[arg_5_0]
	local var_5_1 = var_5_0.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_5_2 = var_5_0.ENEMY_PLAYER_AND_BOT_UNITS
	local var_5_3 = 0
	local var_5_4 = POSITION_LOOKUP[arg_5_0]
	local var_5_5 = BreedActions.chaos_exalted_sorcerer_drachenfels.retaliation_aoe.radius

	for iter_5_0, iter_5_1 in ipairs(var_5_1) do
		local var_5_6 = var_5_2[iter_5_0]

		if var_5_5 > Vector3.distance(var_5_4, iter_5_1) and not ScriptUnit.extension(var_5_6, "status_system"):is_disabled() and not ScriptUnit.extension(var_5_6, "status_system"):is_invisible() then
			var_5_3 = var_5_3 + 1
		end
	end

	arg_5_1.surrounding_players = var_5_3
	arg_5_1.ring_cooldown = math.max(arg_5_1.ring_cooldown - arg_5_3, 0)
	arg_5_1.charge_cooldown = math.max(arg_5_1.charge_cooldown - arg_5_3, 0)
	arg_5_1.teleport_cooldown = math.max(arg_5_1.teleport_cooldown - arg_5_3, 0)
	arg_5_1.defensive_phase_duration = math.max(arg_5_1.defensive_phase_duration - arg_5_3, 0)

	if var_0_1 then
		local var_5_7 = arg_5_1.arena_pose_boxed:unbox()
		local var_5_8 = arg_5_1.arena_half_extents:unbox()

		QuickDrawer:box(var_5_7, var_5_8, Color(0, 255, 70))
	end

	if arg_5_1.missle_bot_threat_unit then
		local var_5_9 = POSITION_LOOKUP[arg_5_1.missle_bot_threat_unit]
		local var_5_10 = 2
		local var_5_11 = 1
		local var_5_12 = var_5_11 * 0.5
		local var_5_13 = Vector3(0, var_5_10, var_5_12)
		local var_5_14 = var_5_9 - Vector3.up() * var_5_12

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_5_14, "cylinder", var_5_13, nil, 1, "Exalted Sorcerer")

		arg_5_1.missle_bot_threat_unit = nil
	end

	if arg_5_1.third_phase_in_progress and arg_5_1.current_health ~= 1 then
		if arg_5_2 > arg_5_1.ring_pulse_rate and not arg_5_1.ring_damage_effect_time then
			local var_5_15 = Vector3Box.unbox(arg_5_1.ring_center_position)
			local var_5_16 = 3

			arg_5_1.sorcerer_allow_tricke_spawn = false

			Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects["fx/drachenfels_boss_indicator_donut_medium_part_1"], NetworkConstants.invalid_game_object_id, 0, var_5_15, false)
			Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects["fx/drachenfels_boss_indicator_donut_large_part_1"], NetworkConstants.invalid_game_object_id, 0, var_5_15, false)

			arg_5_1.ring_damage_effect_time = arg_5_2 + var_5_16 - 0.75
		elseif arg_5_1.ring_damage_effect_time and arg_5_2 >= arg_5_1.ring_damage_effect_time then
			local var_5_17 = Managers.state.entity:system("audio_system")
			local var_5_18 = Vector3Box.unbox(arg_5_1.ring_center_position)
			local var_5_19 = 8
			local var_5_20 = 15
			local var_5_21 = var_5_19 * var_5_19
			local var_5_22 = var_5_20 * var_5_20
			local var_5_23 = {
				harder = 100,
				hard = 75,
				normal = 50,
				hardest = 150,
				cataclysm = 400,
				cataclysm_3 = 400,
				cataclysm_2 = 400,
				easy = 50
			}

			Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects["fx/drachenfels_boss_indicator_donut_medium_part_2"], NetworkConstants.invalid_game_object_id, 0, var_5_18, false)
			Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects["fx/drachenfels_boss_indicator_donut_large_part_2"], NetworkConstants.invalid_game_object_id, 0, var_5_18, false)
			var_5_17:play_audio_position_event("Play_sorcerer_boss_special_ability_burn", var_5_18)

			local var_5_24 = {}
			local var_5_25 = var_5_2
			local var_5_26 = 7

			AiUtils.broadphase_query(var_5_18, var_5_20, var_5_24)

			for iter_5_2, iter_5_3 in ipairs(var_5_24) do
				local var_5_27 = POSITION_LOOKUP[iter_5_3]

				if var_5_21 < Vector3.distance_squared(var_5_27, var_5_18) and iter_5_3 ~= arg_5_0 then
					local var_5_28 = "frag_grenade"
					local var_5_29 = DamageProfileTemplates[var_5_28]
					local var_5_30 = var_5_23[Managers.state.difficulty:get_difficulty()]

					DamageUtils.add_damage_network_player(var_5_29, nil, var_5_30, iter_5_3, arg_5_0, "torso", POSITION_LOOKUP[iter_5_3], Vector3.up(), "undefined")
				end
			end

			for iter_5_4, iter_5_5 in ipairs(var_5_25) do
				local var_5_31 = POSITION_LOOKUP[iter_5_5]
				local var_5_32 = Vector3.distance_squared(var_5_31, var_5_18)
				local var_5_33 = "in" == "in" and var_5_18 - var_5_31 or var_5_31 - var_5_18
				local var_5_34 = Vector3.normalize(var_5_33)

				if var_5_32 < var_5_22 and var_5_21 < var_5_32 then
					local var_5_35 = "frag_grenade"
					local var_5_36 = DamageProfileTemplates[var_5_35]
					local var_5_37 = Managers.state.difficulty:get_difficulty()
					local var_5_38 = Managers.player:owner(iter_5_5)
					local var_5_39 = var_5_38 and not var_5_38:is_player_controlled() and 0 or var_5_23[var_5_37]

					DamageUtils.add_damage_network_player(var_5_36, nil, var_5_39, iter_5_5, arg_5_0, "torso", POSITION_LOOKUP[iter_5_5], Vector3.up(), "undefined")

					if var_5_26 then
						StatusUtils.set_catapulted_network(iter_5_5, true, (var_5_34 + Vector3.up()) * var_5_26)
					end

					arg_5_1.hit_by_eruptions = true
				end
			end

			arg_5_1.ring_damage_effect_time = nil
			arg_5_1.ring_pulse_rate = arg_5_2 + 8
			arg_5_1.sorcerer_allow_tricke_spawn = true
		end
	end
end

AiBreedSnippets.on_chaos_exalted_sorcerer_drachenfels_death = function (arg_6_0, arg_6_1)
	local var_6_0 = Managers.state.conflict

	var_6_0:remove_unit_from_bosses(arg_6_0)
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_sorcerer_boss_fly_stop", arg_6_0)

	local var_6_1 = Managers.player:statistics_db()

	if arg_6_1.no_kill_achievement then
		local var_6_2 = "penny_castle_no_kill"
		local var_6_3 = NetworkLookup.statistics[var_6_2]
		local var_6_4 = Managers.player:local_player():stats_id()

		var_6_1:increment_stat(var_6_4, var_6_2)
		Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", var_6_3)
	end

	if not arg_6_1.hit_by_eruptions then
		local var_6_5 = "penny_castle_eruptions"
		local var_6_6 = NetworkLookup.statistics[var_6_5]
		local var_6_7 = Managers.player:local_player():stats_id()

		var_6_1:increment_stat(var_6_7, var_6_5)
		Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", var_6_6)
	end

	local var_6_8 = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(var_6_8, 120, 20, true)

	if arg_6_1.is_angry then
		var_6_0:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(4, Vector3(14.959, 383.806, 31.202), true)
end

AiBreedSnippets.on_chaos_exalted_sorcerer_drachenfels_despawn = function (arg_7_0, arg_7_1)
	local var_7_0 = Managers.state.conflict

	var_7_0:remove_unit_from_bosses(arg_7_0)

	if arg_7_1.is_angry then
		var_7_0:add_angry_boss(-1)
	end
end
