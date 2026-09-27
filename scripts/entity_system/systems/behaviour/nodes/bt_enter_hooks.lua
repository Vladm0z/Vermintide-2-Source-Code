-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_enter_hooks.lua

local BTEnterHooks = BTEnterHooks

BTEnterHooks = BTEnterHooks or {}
BTEnterHooks = BTEnterHooks

local BTEnterHooks_2 = BTEnterHooks
local local_position = Unit.local_position
local alive = Unit.alive
local ScriptUnit = ScriptUnit

BTEnterHooks_2.crouch_on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	if not arg_1_1.is_upright then
		Managers.state.network:anim_event(arg_1_0, "to_crouch")

		arg_1_1.is_upright = false
	end
end

BTEnterHooks_2.upright_on_enter = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not arg_2_1.is_upright then
		Managers.state.network:anim_event(arg_2_0, "to_upright")

		arg_2_1.is_upright = true
	end
end

BTEnterHooks_2.drop_items = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local extension = ScriptUnit.extension(arg_3_0, "ai_inventory_system")
	local inventory_item_definitions = extension.inventory_item_definitions
	local str = "death"
	local network_transmit = Managers.state.network.network_transmit
	local go_id = Managers.state.unit_storage:go_id(arg_3_0)
	local var_3_5 = NetworkLookup.item_drop_reasons[str]

	for i = 1, #inventory_item_definitions do
		local drop_single_item, var_3_7 = extension:drop_single_item(i, str)

		if not drop_single_item then
			network_transmit:send_rpc_clients("rpc_ai_drop_single_item", go_id, i, var_3_5)
			print("DROPPING ITEMS", i, var_3_7)
		end
	end
end

BTEnterHooks_2.crouch_or_upright_on_enter = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	if arg_4_1.needs_to_crouch == nil then
		PerceptionUtils.troll_crouch_check(arg_4_0, arg_4_1, arg_4_2)
	end

	if not arg_4_1.needs_to_crouch then
		Managers.state.network:anim_event(arg_4_0, "to_crouch")
	else
		Managers.state.network:anim_event(arg_4_0, "to_upright")
	end
end

BTEnterHooks_2.rage_on_enter = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	arg_5_1.next_rage_time = arg_5_2 + 7
end

BTEnterHooks_2.attack_grabbed_smash = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	if not alive(arg_6_1.victim_grabbed) then
		StatusUtils.set_grabbed_by_chaos_spawn_status_network(arg_6_1.victim_grabbed, "beating_with")

		arg_6_1.override_target_unit = arg_6_1.victim_grabbed
	end

	arg_6_1.grabbed_state = "attack_smash"
	arg_6_1.attack_grabbed_attacks = arg_6_1.attack_grabbed_attacks + 1

	if arg_6_1.attack_grabbed_attacks >= arg_6_1.breed.max_grabbed_attacks then
		arg_6_1.wants_to_throw = true
		arg_6_1.attack_grabbed_attacks = 0
	end
end

BTEnterHooks_2.on_warlord_dual_wield = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	if arg_7_1.inventory_item_set ~= 2 then
		arg_7_1.switching_weapons = 2
	end
end

BTEnterHooks_2.on_warlord_halberd = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	if arg_8_1.inventory_item_set ~= 1 then
		arg_8_1.switching_weapons = 1
	end
end

BTEnterHooks_2.on_warlord_disable_blocking = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local has_extension = ScriptUnit.has_extension(arg_9_0, "ai_shield_system")

	if not has_extension then
		has_extension:set_is_blocking(false)
		has_extension:set_is_dodging(false)
	end
end

BTEnterHooks_2.on_grey_seer_intro_enter = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	ScriptUnit.extension(arg_10_0, "health_system").is_invincible = true

	local network_transmit = Managers.state.network.network_transmit
	local go_id = Managers.state.unit_storage:go_id(arg_10_0)

	network_transmit:send_rpc_clients("rpc_set_hit_reaction_template", go_id, "HitEffectsSkavenGreySeerMounted")

	local extension_input = ScriptUnit.extension_input(arg_10_0, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("egs_intro", alloc_table)
end

BTEnterHooks_2.grey_seer_death_sequence_teleport = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local current_death_sequence_index = arg_11_1.current_death_sequence_index

	current_death_sequence_index = current_death_sequence_index or 1

	local var_11_1 = arg_11_1.death_sequence_positions[current_death_sequence_index]

	if not var_11_1 then
		arg_11_1.quick_teleport_exit_pos = Vector3Box(var_11_1:unbox())
		arg_11_1.quick_teleport = true
		arg_11_1.current_death_sequence_index = current_death_sequence_index + 1
	end
end

BTEnterHooks_2.grey_seer_call_stormfiend_enter = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local extension_input = ScriptUnit.extension_input(arg_12_0, "dialogue_system")
	local mounted_data = arg_12_1.mounted_data
	local var_12_2 = BLACKBOARDS[mounted_data.mount_unit]
	local call_stormfiend_positions = arg_12_1.call_stormfiend_positions
	local var_12_4 = POSITION_LOOKUP[arg_12_0]
	local huge = math.huge
	local var_12_6

	for i = 1, #call_stormfiend_positions do
		local unbox = call_stormfiend_positions[i]:unbox()
		local distance = Vector3.distance(var_12_4, unbox)

		if distance < huge then
			var_12_6 = unbox
			huge = distance
		end
	end

	local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_12_1.nav_world, var_12_6, 1, 1)

	var_12_2.goal_destination = Vector3Box(pos_on_mesh)
	var_12_2.start_anim_done = true

	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("egs_calls_mount_battle", alloc_table)

	arg_12_1.quick_teleport = true
	arg_12_1.quick_teleport_exit_pos = Vector3Box(pos_on_mesh)
end

BTEnterHooks_2.stormfiend_boss_charge_enter = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local var_13_0
	local num = 0
	local num_2 = POSITION_LOOKUP[arg_13_0] + Vector3.up()
	local world = arg_13_1.world
	local get_data = World.get_data(world, "physics_world")
	local side = arg_13_1.side
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_POSITIONS) do
		local var_13_8 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local distance = Vector3.distance(num_2, v)
		local num_3 = v + Vector3.up()

		if not (num < distance) or not PerceptionUtils.is_position_in_line_of_sight(arg_13_0, num_2, num_3, get_data) then
			var_13_0 = var_13_8
		end
	end

	if not HEALTH_ALIVE[var_13_0] then
		arg_13_1.target_unit = var_13_0
		arg_13_1.keep_target = true
	end
end

BTEnterHooks_2.to_combat = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	AiUtils.enter_combat(arg_14_0, arg_14_1)
end

BTEnterHooks_2.on_chaos_exalted_champion_intro_enter = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local chaos_exalted_intro_move_to = Managers.state.conflict.level_analysis.generic_ai_node_units.chaos_exalted_intro_move_to

	if not chaos_exalted_intro_move_to then
		local var_15_1 = chaos_exalted_intro_move_to[1]
		local var_15_2 = local_position(var_15_1, 0)

		arg_15_1.goal_destination = Vector3Box(var_15_2)
		ScriptUnit.extension(arg_15_0, "health_system").is_invincible = true
	else
		print("Found no generic AI node (chaos_exalted_intro_move_to) for lord intro, ", arg_15_0)

		arg_15_1.intro_timer = nil
	end
end

BTEnterHooks_2.on_chaos_exalted_sorcerer_intro_enter = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local sorcerer_boss_intro = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_intro

	if not sorcerer_boss_intro then
		local var_16_1 = sorcerer_boss_intro[1]
		local var_16_2 = local_position(var_16_1, 0)
		local local_rotation = Unit.local_rotation(var_16_1, 0)

		arg_16_1.quick_teleport_exit_pos = Vector3Box(var_16_2)
		arg_16_1.quick_teleport = true

		Unit.set_local_rotation(arg_16_0, 0, local_rotation)

		ScriptUnit.extension(arg_16_0, "health_system").is_invincible = true
	else
		print("Found no generic AI node (sorcerer_boss_intro) for lord intro, ", arg_16_0)

		arg_16_1.intro_timer = nil
	end

	local extension_input = ScriptUnit.extension_input(arg_16_0, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("ebh_intro", alloc_table)
end

BTEnterHooks_2.on_skaven_warlord_intro_enter = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local skaven_warlord_intro_move_to = Managers.state.conflict.level_analysis.generic_ai_node_units.skaven_warlord_intro_move_to

	if not skaven_warlord_intro_move_to then
		local var_17_1 = skaven_warlord_intro_move_to[1]
		local var_17_2 = local_position(var_17_1, 0)

		arg_17_1.goal_destination = Vector3Box(var_17_2)
		ScriptUnit.extension(arg_17_0, "health_system").is_invincible = true
	else
		print("Found no generic AI node (skaven_warlord_intro_move_to) for lord intro, ", arg_17_0)

		arg_17_1.intro_timer = nil
	end
end

BTEnterHooks_2.sorcerer_dummy_idle = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	Managers.state.network:anim_event(arg_18_0, "to_plague_wave")

	ScriptUnit.extension(arg_18_0, "health_system").is_invincible = true
end

BTEnterHooks_2.corruptor_enter = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	Managers.state.network:anim_event(arg_19_0, "to_corruptor")
end

BTEnterHooks_2.grey_seer_stagger_enter = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local damage_wave_extension = arg_20_1.damage_wave_extension

	if not damage_wave_extension then
		damage_wave_extension:abort()
	end
end

local function fn(arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	local var_21_0
	local get_random_spawner_with_id = ConflictUtils.get_random_spawner_with_id("sorcerer_boss")

	if not get_random_spawner_with_id then
		var_21_0 = local_position(get_random_spawner_with_id, 0)

		local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(ScriptUnit.extension(get_random_spawner_with_id, "spawner_system"):spawn_rotation())))

		arg_21_2.spawn_forward = Vector3Box(normalize)

		local tbl = {
			(ConflictUtils.get_random_spawner_with_id("sorcerer_boss_minion"))
		}

		print("found spawner for sorcerer_boss_minion:", tbl[1])

		tbl[2] = ConflictUtils.get_random_spawner_with_id("sorcerer_boss_minion", tbl[1])

		print("found spawner for sorcerer_boss_minion:", tbl[2])

		arg_21_2.spawners = tbl
		arg_21_1.defensive_spawner = get_random_spawner_with_id
	else
		local tbl_2 = {
			spawn_group = "default",
			use_fallback_spawners = true
		}

		var_21_0 = BTSpawnAllies.find_spawn_point(arg_21_0, arg_21_1, tbl_2, arg_21_2)
	end

	return var_21_0
end

BTEnterHooks_2.sorcerer_begin_defensive_mode = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	local tbl = {
		stay_still = true,
		end_time = math.huge
	}
	local var_22_1 = fn(arg_22_0, arg_22_1, tbl)

	arg_22_1.spawning_allies = tbl
	arg_22_1.quick_teleport_exit_pos = Vector3Box(var_22_1)
	arg_22_1.quick_teleport = true
	tbl.call_position = arg_22_1.quick_teleport_exit_pos
	arg_22_1.has_call_position = true
	arg_22_1.teleport_health_percent = arg_22_1.health_extension:current_health_percent() - 0.1
	arg_22_1.spell_count = 0
	arg_22_1.phase = "defensive_starts"

	local extension_input = ScriptUnit.extension_input(arg_22_0, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("ebh_summon", alloc_table)
end

BTEnterHooks_2.dont_face_target_while_summoning = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	arg_23_1.face_target_while_summoning = false
end

BTEnterHooks_2.sorcerer_re_enter_defensive_mode = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local tbl = {
		stay_still = true,
		end_time = math.huge
	}
	local var_24_1 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_intro[1]
	local var_24_2 = local_position(var_24_1, 0)

	arg_24_1.spawning_allies = tbl
	arg_24_1.quick_teleport_exit_pos = Vector3Box(var_24_2)
	arg_24_1.quick_teleport = true
	tbl.call_position = arg_24_1.quick_teleport_exit_pos
	arg_24_1.has_call_position = true
	arg_24_1.teleport_health_percent = arg_24_1.health_extension:current_health_percent() - 0.1
	arg_24_1.spell_count = 0

	local extension_input = ScriptUnit.extension_input(arg_24_0, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("ebh_summon", alloc_table)
end

BTEnterHooks_2.target_furthest_player_in_sight = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
	local physics_world = arg_25_1.physics_world

	physics_world = physics_world or World.get_data(arg_25_1.world, "physics_world")

	local var_25_2 = POSITION_LOOKUP[arg_25_0]
	local var_25_3
	local num = 0

	for k, v in pairs(PLAYER_AND_BOT_UNITS) do
		local raycast_spine_to_spine = PerceptionUtils.raycast_spine_to_spine(arg_25_0, v, physics_world)
		local distance_squared = Vector3.distance_squared(var_25_2, POSITION_LOOKUP[v])

		if not (not raycast_spine_to_spine and not (num < distance_squared)) then
			var_25_3 = v
			num = distance_squared
		end
	end

	arg_25_1.target_unit = var_25_3 or arg_25_1.target_unit
end

BTEnterHooks_2.sorcerer_spawn_horde = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local tbl = {
		stay_still = true,
		end_time = math.huge
	}

	fn(arg_26_0, arg_26_1, tbl)

	arg_26_1.spawning_allies = tbl
end

BTEnterHooks_2.sorcerer_defensive_seeking_bomb = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	local extension_input = ScriptUnit.extension_input(arg_27_0, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("ebh_insect_spell", alloc_table)
end

BTEnterHooks_2.teleport_to_center = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local var_28_0 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_center[1]
	local var_28_1 = local_position(var_28_0, 0)

	if not var_28_1 then
		arg_28_1.quick_teleport_exit_pos = Vector3Box(var_28_1)
		arg_28_1.quick_teleport = true
		arg_28_1.move_pos = nil

		return
	end
end

BTEnterHooks_2.quick_teleport = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	arg_29_1.quick_teleport = true
end

BTEnterHooks_2.summoning_starts = function (arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	arg_30_1.is_summoning = true
end

BTEnterHooks_2.wave_summoning_starts = function (arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	arg_31_1.is_summoning = true
end

BTEnterHooks_2.block_stagger_start = function (arg_32_0, arg_32_1, arg_32_2)
	-- function 32
	if arg_32_1.mode == "defensive" then
		if arg_32_1.health_extension:current_health_percent() < arg_32_1.teleport_health_percent then
			arg_32_1.teleport_health_percent = arg_32_1.health_extension:current_health_percent() - 0.05
			arg_32_1.escape_teleport = true
		end

		return
	end

	if not arg_32_1.stagger_time_end then
		arg_32_1.stagger_time_end = arg_32_2 + arg_32_1.breed.max_chain_stagger_time
	elseif arg_32_2 > arg_32_1.stagger_time_end then
		arg_32_1.stagger_time_end = nil

		local var_32_0 = POSITION_LOOKUP[arg_32_0]
		local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(arg_32_1.nav_world, var_32_0, 15, 7, 15)

		if not get_spawn_pos_on_circle then
			arg_32_1.quick_teleport_exit_pos = Vector3Box(get_spawn_pos_on_circle)
			arg_32_1.quick_teleport = true
			arg_32_1.move_pos = nil

			return
		end
	end
end

BTEnterHooks_2.sorcerer_evade = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	arg_33_1.quick_teleport = true

	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local str = "sorcerer_boss_hit_extra"
	local str_2 = "sorcerer_boss_minion"
	local conflict = Managers.state.conflict
	local flag = true
	local flag_2 = true
	local var_33_6
	local side_id = arg_33_1.side.side_id

	conflict.horde_spawner:execute_event_horde(arg_33_2, str_2, side_id, str, var_33_6, flag_2, nil, flag)

	local extension_input = ScriptUnit.extension_input(arg_33_0, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("ebh_taunt", alloc_table)
end

BTEnterHooks_2.warlord_defensive_on_enter = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	local spawn_allies_positions = arg_34_1.spawn_allies_positions
	local var_34_1 = POSITION_LOOKUP[arg_34_0]
	local num = 0
	local var_34_3

	if not spawn_allies_positions then
		for i = 1, #spawn_allies_positions do
			local unbox = spawn_allies_positions[i]:unbox()
			local distance = Vector3.distance(var_34_1, unbox)

			if num < distance then
				var_34_3 = unbox
				num = distance
			end
		end
	end

	var_34_3 = var_34_3 or var_34_1
	arg_34_1.override_spawn_allies_call_position = Vector3Box(var_34_3)
end

BTEnterHooks_2.keep_target = function (arg_35_0, arg_35_1, arg_35_2)
	-- function 35
	arg_35_1.keep_target = true
end

BTEnterHooks_2.add_invincibility = function (arg_36_0, arg_36_1, arg_36_2)
	-- function 36
	ScriptUnit.extension(arg_36_0, "health_system").is_invincible = true
end

BTEnterHooks_2.remove_invincibility = function (arg_37_0, arg_37_1, arg_37_2)
	-- function 37
	ScriptUnit.extension(arg_37_0, "health_system").is_invincible = false
end

BTEnterHooks_2.activate_slot_system = function (arg_38_0, arg_38_1, arg_38_2)
	-- function 38
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_38_0, true)
end

BTEnterHooks_2.troll_chief_on_downed = function (arg_39_0, arg_39_1, arg_39_2)
	-- function 39
	local tbl = {
		stay_still = true,
		end_time = math.huge
	}
	local forward = Quaternion.forward(Quaternion.flat_no_roll(Unit.local_rotation(arg_39_0, 0)))

	tbl.spawn_forward = Vector3Box(forward)
	arg_39_1.spawning_allies = tbl
	arg_39_1.spawned_allies_wave = 0

	local respawn_thresholds, var_39_3, var_39_4, var_39_5, var_39_6 = arg_39_1.health_extension:respawn_thresholds()

	arg_39_1.downed_phase = var_39_6
end

DLCUtils.merge("bt_enter_hooks", BTEnterHooks_2)
