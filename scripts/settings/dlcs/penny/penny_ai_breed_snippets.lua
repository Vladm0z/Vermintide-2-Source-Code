-- chunkname: @scripts/settings/dlcs/penny/penny_ai_breed_snippets.lua

local AiBreedSnippets = AiBreedSnippets

AiBreedSnippets = AiBreedSnippets or {}
AiBreedSnippets = AiBreedSnippets

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local flag = arg_1_3 or 100
	local recent_damages, var_1_2 = ScriptUnit.extension(arg_1_0, "health_system"):recent_damages()

	if var_1_2 > 0 then
		local var_1_3 = recent_damages[DamageDataIndex.ATTACKER]
		local side = arg_1_1.side
		local var_1_5 = recent_damages[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_1_6 = rawget(ItemMasterList, var_1_5)
		local flag_2 = not var_1_6 and var_1_6.slot_type == "melee"

		if not Unit.alive(var_1_3) and not side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_1_3] then
			if not (not (flag < Vector3.distance_squared(POSITION_LOOKUP[arg_1_0], POSITION_LOOKUP[var_1_3])) or flag_2) then
				arg_1_1.recent_attacker_unit = var_1_3
				arg_1_1.recent_attacker_timer = arg_1_2 + 3
				arg_1_1.recent_attacker = true

				local extension_input = ScriptUnit.extension_input(arg_1_0, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				extension_input:trigger_networked_dialogue_event("ebh_retaliation_missile", alloc_table)
			elseif not flag_2 then
				arg_1_1.recent_melee_attacker_unit = var_1_3
				arg_1_1.recent_melee_attacker_timer = arg_1_2 + 0.35
				arg_1_1.recent_melee_attacker = true
			end
		end
	elseif not arg_1_1.recent_attacker then
		if arg_1_2 > arg_1_1.recent_attacker_timer then
			arg_1_1.recent_attacker_unit = nil
			arg_1_1.recent_attacker_timer = math.huge
			arg_1_1.recent_attacker = false
		end
	elseif not (not arg_1_1.recent_melee_attacker and not (arg_1_2 > arg_1_1.recent_melee_attacker_timer)) then
		arg_1_1.recent_melee_attacker_unit = nil
		arg_1_1.recent_melee_attacker_timer = math.huge
		arg_1_1.recent_melee_attacker = false
	end
end

AiBreedSnippets.on_chaos_exalted_sorcerer_drachenfels_spawn = function (arg_2_0, arg_2_1)
	-- function 2
	local time = Managers.time:time("game")
	local breed = arg_2_1.breed

	arg_2_1.next_move_check = 0
	arg_2_1.max_vortex_units = breed.max_vortex_units
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

	local available_spells = breed.available_spells
	local tbl = {}
	local tbl_2 = {}
	local get_data = World.get_data(arg_2_1.world, "physics_world")
	local sorcerer_boss_drachenfels_center = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_center
	local var_2_7

	if not sorcerer_boss_drachenfels_center then
		var_2_7 = sorcerer_boss_drachenfels_center[1]

		if not var_2_7 then
			-- Nothing
		end
	end

	var_2_7 = arg_2_0

	::label_2_0::

	arg_2_1.no_kill_achievement = true
	arg_2_1.ring_center_position = Vector3Box(Unit.local_position(var_2_7, 0))
	arg_2_1.spell_count = 0

	local tbl_3 = {
		name = "plague_wave",
		plague_wave_timer = time + 10,
		physics_world = get_data,
		target_starting_pos = Vector3Box(),
		plague_wave_rot = QuaternionBox(),
		search_func = BTChaosExaltedSorcererSkulkAction.update_plague_wave
	}

	arg_2_1.plague_wave_data = tbl_3
	tbl[#tbl + 1] = tbl_3
	tbl_2.plague_wave = tbl_3

	local tbl_4 = {
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

	arg_2_1.magic_missile_data = tbl_4
	tbl[#tbl + 1] = tbl_4
	tbl_2.magic_missile = tbl_4

	local tbl_5 = {
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

	arg_2_1.sorcerer_strike_missile_data = tbl_5
	tbl[#tbl + 1] = tbl_5
	tbl_2.sorcerer_strike_missile = tbl_5

	local tbl_6 = {
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

	arg_2_1.magic_missile_ground_data = tbl_6
	tbl[#tbl + 1] = tbl_6
	tbl_2.magic_missile_ground = tbl_6

	local tbl_7 = {
		name = "missile_barrage",
		magic_missile = true,
		magic_missile_speed = 20,
		range = 40,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}

	arg_2_1.missile_barrage_data = tbl_7
	tbl[#tbl + 1] = tbl_7
	tbl_2.missile_barrage = tbl_7

	local tbl_8 = {
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

	arg_2_1.seeking_bomb_missile_data = tbl_8
	tbl[#tbl + 1] = tbl_8
	tbl_2.seeking_bomb_missile = tbl_8

	local tbl_9 = {
		name = "dummy",
		search_func = BTChaosExaltedSorcererSkulkAction.update_dummy
	}

	arg_2_1.dummy_data = tbl_9
	tbl[#tbl + 1] = tbl_9
	tbl_2.dummy = tbl_9

	local _id_lookup = Managers.state.entity:system("spawner_system")._id_lookup
	local level_analysis = Managers.state.conflict.level_analysis
	local sorcerer_boss_drachenfels_center_2 = level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_center
	local sorcerer_boss_drachenfels_wall = level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_wall

	if not sorcerer_boss_drachenfels_center_2 and not sorcerer_boss_drachenfels_wall then
		-- Nothing
	end

	::label_2_2::

	local sorcerer_boss_drachenfels = _id_lookup.sorcerer_boss_drachenfels

	sorcerer_boss_drachenfels = not sorcerer_boss_drachenfels and _id_lookup.sorcerer_boss_drachenfels_minion

	::label_2_3::

	if not sorcerer_boss_drachenfels then
		local var_2_20 = sorcerer_boss_drachenfels_center_2[1]

		arg_2_1.in_boss_arena = Vector3.distance(POSITION_LOOKUP[arg_2_0], Unit.local_position(var_2_20, 0)) < 20
	else
		arg_2_1.in_boss_arena = false
	end

	if not arg_2_1.in_boss_arena then
		arg_2_1.spawners = {
			sorcerer_boss_center = sorcerer_boss_drachenfels_center_2
		}
		arg_2_1.mode = "setup"
		arg_2_1.intro_timer = time + 12.3

		local var_2_21 = sorcerer_boss_drachenfels_center_2[1]
		local num = Unit.local_position(var_2_21, 0) + Vector3(0, 0, 0.75)
		local local_rotation = Unit.local_rotation(var_2_21, 0)

		arg_2_1.arena_pose_boxed = Matrix4x4Box(Matrix4x4.from_quaternion_position(local_rotation, num))
		arg_2_1.arena_half_extents = Vector3Box(12, 12, 1)

		arg_2_1.valid_teleport_pos_func = function (arg_3_0, arg_3_1)
			-- function 3
			local unbox = arg_3_1.arena_pose_boxed:unbox()
			local unbox_2 = arg_3_1.arena_half_extents:unbox()

			return (math.point_is_inside_oobb(arg_3_0, unbox, unbox_2))
		end
	else
		arg_2_1.phase = "offensive"

		arg_2_1.valid_teleport_pos_func = function (arg_4_0, arg_4_1)
			-- function 4
			return true
		end

		print("Sorcerer boss not in arena")
	end

	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for k, v in pairs(PLAYER_AND_BOT_UNITS) do
		ScriptUnit.extension(v, "health_system").is_invincible = true
	end

	arg_2_1.spells = tbl
	arg_2_1.spells_lookup = tbl_2

	local breed_2 = arg_2_1.breed
	local system = Managers.state.entity:system("audio_system")

	if not breed_2.teleport_sound_event then
		system:play_audio_unit_event(breed_2.teleport_sound_event, arg_2_0)
	end

	Managers.state.conflict:add_unit_to_bosses(arg_2_0)

	arg_2_1.is_valid_target_func = GenericStatusExtension.is_lord_target
end

local flag = false

AiBreedSnippets.on_chaos_exalted_sorcerer_drachenfels_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	fn(arg_5_0, arg_5_1, arg_5_2, 10)

	if not arg_5_1.in_boss_arena then
		return
	end

	if not arg_5_1.intro_timer then
		return
	end

	local var_5_0 = Managers.state.side.side_by_unit[arg_5_0]
	local ENEMY_PLAYER_AND_BOT_POSITIONS = var_5_0.ENEMY_PLAYER_AND_BOT_POSITIONS
	local ENEMY_PLAYER_AND_BOT_UNITS = var_5_0.ENEMY_PLAYER_AND_BOT_UNITS
	local num = 0
	local var_5_4 = POSITION_LOOKUP[arg_5_0]
	local radius = BreedActions.chaos_exalted_sorcerer_drachenfels.retaliation_aoe.radius

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_POSITIONS) do
		local var_5_6 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not (not (radius > Vector3.distance(var_5_4, v)) or ScriptUnit.extension(var_5_6, "status_system"):is_disabled() or ScriptUnit.extension(var_5_6, "status_system"):is_invisible()) then
			num = num + 1
		end
	end

	arg_5_1.surrounding_players = num
	arg_5_1.ring_cooldown = math.max(arg_5_1.ring_cooldown - arg_5_3, 0)
	arg_5_1.charge_cooldown = math.max(arg_5_1.charge_cooldown - arg_5_3, 0)
	arg_5_1.teleport_cooldown = math.max(arg_5_1.teleport_cooldown - arg_5_3, 0)
	arg_5_1.defensive_phase_duration = math.max(arg_5_1.defensive_phase_duration - arg_5_3, 0)

	if not flag then
		local unbox = arg_5_1.arena_pose_boxed:unbox()
		local unbox_2 = arg_5_1.arena_half_extents:unbox()

		QuickDrawer:box(unbox, unbox_2, Color(0, 255, 70))
	end

	if not arg_5_1.missle_bot_threat_unit then
		local var_5_9 = POSITION_LOOKUP[arg_5_1.missle_bot_threat_unit]
		local num_2 = 2
		local num_3 = 1
		local num_4 = num_3 * 0.5
		local var_5_13 = Vector3(0, num_2, num_4)
		local num_5 = var_5_9 - Vector3.up() * num_4

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(num_5, "cylinder", var_5_13, nil, 1, "Exalted Sorcerer")

		arg_5_1.missle_bot_threat_unit = nil
	end

	if not (not arg_5_1.third_phase_in_progress and arg_5_1.current_health == 1) then
		if not (not (arg_5_2 > arg_5_1.ring_pulse_rate) or arg_5_1.ring_damage_effect_time) then
			local unbox_3 = Vector3Box.unbox(arg_5_1.ring_center_position)
			local num_6 = 3

			arg_5_1.sorcerer_allow_tricke_spawn = false

			Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects["fx/drachenfels_boss_indicator_donut_medium_part_1"], NetworkConstants.invalid_game_object_id, 0, unbox_3, false)
			Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects["fx/drachenfels_boss_indicator_donut_large_part_1"], NetworkConstants.invalid_game_object_id, 0, unbox_3, false)

			arg_5_1.ring_damage_effect_time = arg_5_2 + num_6 - 0.75
		elseif not (not arg_5_1.ring_damage_effect_time and not (arg_5_2 >= arg_5_1.ring_damage_effect_time)) then
			local system = Managers.state.entity:system("audio_system")
			local unbox_4 = Vector3Box.unbox(arg_5_1.ring_center_position)
			local num_7 = 8
			local num_8 = 15
			local num_9 = num_7 * num_7
			local num_10 = num_8 * num_8
			local tbl = {
				harder = 100,
				hard = 75,
				normal = 50,
				hardest = 150,
				cataclysm = 400,
				cataclysm_3 = 400,
				cataclysm_2 = 400,
				easy = 50
			}

			Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects["fx/drachenfels_boss_indicator_donut_medium_part_2"], NetworkConstants.invalid_game_object_id, 0, unbox_4, false)
			Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects["fx/drachenfels_boss_indicator_donut_large_part_2"], NetworkConstants.invalid_game_object_id, 0, unbox_4, false)
			system:play_audio_position_event("Play_sorcerer_boss_special_ability_burn", unbox_4)

			local tbl_2 = {}
			local var_5_25 = ENEMY_PLAYER_AND_BOT_UNITS
			local num_11 = 7

			AiUtils.broadphase_query(unbox_4, num_8, tbl_2)

			for i_2, v_2 in ipairs(tbl_2) do
				local var_5_27 = POSITION_LOOKUP[v_2]

				if not (not (num_9 < Vector3.distance_squared(var_5_27, unbox_4)) or v_2 == arg_5_0) then
					local str = "frag_grenade"
					local var_5_29 = DamageProfileTemplates[str]
					local var_5_30 = tbl[Managers.state.difficulty:get_difficulty()]

					DamageUtils.add_damage_network_player(var_5_29, nil, var_5_30, v_2, arg_5_0, "torso", POSITION_LOOKUP[v_2], Vector3.up(), "undefined")
				end
			end

			for i_3, v_3 in ipairs(var_5_25) do
				local var_5_31 = POSITION_LOOKUP[v_3]
				local distance_squared = Vector3.distance_squared(var_5_31, unbox_4)
				local num_12

				if "in" == "in" then
					num_12 = unbox_4 - var_5_31

					if not num_12 then
						-- Nothing
					end
				end

				num_12 = var_5_31 - unbox_4

				::label_5_0::

				local normalize = Vector3.normalize(num_12)

				if not (not (distance_squared < num_10) or not (num_9 < distance_squared)) then
					local str_2 = "frag_grenade"
					local var_5_36 = DamageProfileTemplates[str_2]
					local get_difficulty = Managers.state.difficulty:get_difficulty()
					local owner = Managers.player:owner(v_3)
					local flag_2

					flag_2 = not (not owner and not owner:is_player_controlled()) and 0 and tbl[get_difficulty]

					DamageUtils.add_damage_network_player(var_5_36, nil, flag_2, v_3, arg_5_0, "torso", POSITION_LOOKUP[v_3], Vector3.up(), "undefined")

					if not num_11 then
						StatusUtils.set_catapulted_network(v_3, true, (normalize + Vector3.up()) * num_11)
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
	-- function 6
	local conflict = Managers.state.conflict

	conflict:remove_unit_from_bosses(arg_6_0)
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_sorcerer_boss_fly_stop", arg_6_0)

	local statistics_db = Managers.player:statistics_db()

	if not arg_6_1.no_kill_achievement then
		local str = "penny_castle_no_kill"
		local var_6_3 = NetworkLookup.statistics[str]
		local stats_id = Managers.player:local_player():stats_id()

		statistics_db:increment_stat(stats_id, str)
		Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", var_6_3)
	end

	if not arg_6_1.hit_by_eruptions then
		local str_2 = "penny_castle_eruptions"
		local var_6_6 = NetworkLookup.statistics[str_2]
		local stats_id_2 = Managers.player:local_player():stats_id()

		statistics_db:increment_stat(stats_id_2, str_2)
		Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", var_6_6)
	end

	local time = Managers.time:time("game")

	Managers.state.conflict.specials_pacing:delay_spawning(time, 120, 20, true)

	if not arg_6_1.is_angry then
		conflict:add_angry_boss(-1)
	end

	AiBreedSnippets.drop_loot(4, Vector3(14.959, 383.806, 31.202), true)
end

AiBreedSnippets.on_chaos_exalted_sorcerer_drachenfels_despawn = function (arg_7_0, arg_7_1)
	-- function 7
	local conflict = Managers.state.conflict

	conflict:remove_unit_from_bosses(arg_7_0)

	if not arg_7_1.is_angry then
		conflict:add_angry_boss(-1)
	end
end
