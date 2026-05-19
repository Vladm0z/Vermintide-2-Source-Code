-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_enter_hooks.lua

BTEnterHooks = BTEnterHooks or {}

local var_0_0 = BTEnterHooks
local var_0_1 = Unit.local_position
local var_0_2 = Unit.alive
local var_0_3 = ScriptUnit

function var_0_0.crouch_on_enter(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1.is_upright then
		Managers.state.network:anim_event(arg_1_0, "to_crouch")

		arg_1_1.is_upright = false
	end
end

function var_0_0.upright_on_enter(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_1.is_upright then
		Managers.state.network:anim_event(arg_2_0, "to_upright")

		arg_2_1.is_upright = true
	end
end

function var_0_0.drop_items(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = var_0_3.extension(arg_3_0, "ai_inventory_system")
	local var_3_1 = var_3_0.inventory_item_definitions
	local var_3_2 = "death"
	local var_3_3 = Managers.state.network.network_transmit
	local var_3_4 = Managers.state.unit_storage:go_id(arg_3_0)
	local var_3_5 = NetworkLookup.item_drop_reasons[var_3_2]

	for iter_3_0 = 1, #var_3_1 do
		local var_3_6, var_3_7 = var_3_0:drop_single_item(iter_3_0, var_3_2)

		if var_3_6 then
			var_3_3:send_rpc_clients("rpc_ai_drop_single_item", var_3_4, iter_3_0, var_3_5)
			print("DROPPING ITEMS", iter_3_0, var_3_7)
		end
	end
end

function var_0_0.crouch_or_upright_on_enter(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1.needs_to_crouch == nil then
		PerceptionUtils.troll_crouch_check(arg_4_0, arg_4_1, arg_4_2)
	end

	if arg_4_1.needs_to_crouch then
		Managers.state.network:anim_event(arg_4_0, "to_crouch")
	else
		Managers.state.network:anim_event(arg_4_0, "to_upright")
	end
end

function var_0_0.rage_on_enter(arg_5_0, arg_5_1, arg_5_2)
	arg_5_1.next_rage_time = arg_5_2 + 7
end

function var_0_0.attack_grabbed_smash(arg_6_0, arg_6_1, arg_6_2)
	if var_0_2(arg_6_1.victim_grabbed) then
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

function var_0_0.on_warlord_dual_wield(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1.inventory_item_set ~= 2 then
		arg_7_1.switching_weapons = 2
	end
end

function var_0_0.on_warlord_halberd(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1.inventory_item_set ~= 1 then
		arg_8_1.switching_weapons = 1
	end
end

function var_0_0.on_warlord_disable_blocking(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = var_0_3.has_extension(arg_9_0, "ai_shield_system")

	if var_9_0 then
		var_9_0:set_is_blocking(false)
		var_9_0:set_is_dodging(false)
	end
end

function var_0_0.on_grey_seer_intro_enter(arg_10_0, arg_10_1, arg_10_2)
	var_0_3.extension(arg_10_0, "health_system").is_invincible = true

	local var_10_0 = Managers.state.network.network_transmit
	local var_10_1 = Managers.state.unit_storage:go_id(arg_10_0)

	var_10_0:send_rpc_clients("rpc_set_hit_reaction_template", var_10_1, "HitEffectsSkavenGreySeerMounted")

	local var_10_2 = var_0_3.extension_input(arg_10_0, "dialogue_system")
	local var_10_3 = FrameTable.alloc_table()

	var_10_2:trigger_networked_dialogue_event("egs_intro", var_10_3)
end

function var_0_0.grey_seer_death_sequence_teleport(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1.current_death_sequence_index or 1
	local var_11_1 = arg_11_1.death_sequence_positions[var_11_0]

	if var_11_1 then
		arg_11_1.quick_teleport_exit_pos = Vector3Box(var_11_1:unbox())
		arg_11_1.quick_teleport = true
		arg_11_1.current_death_sequence_index = var_11_0 + 1
	end
end

function var_0_0.grey_seer_call_stormfiend_enter(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = var_0_3.extension_input(arg_12_0, "dialogue_system")
	local var_12_1 = arg_12_1.mounted_data
	local var_12_2 = BLACKBOARDS[var_12_1.mount_unit]
	local var_12_3 = arg_12_1.call_stormfiend_positions
	local var_12_4 = POSITION_LOOKUP[arg_12_0]
	local var_12_5 = math.huge
	local var_12_6

	for iter_12_0 = 1, #var_12_3 do
		local var_12_7 = var_12_3[iter_12_0]:unbox()
		local var_12_8 = Vector3.distance(var_12_4, var_12_7)

		if var_12_8 < var_12_5 then
			var_12_6 = var_12_7
			var_12_5 = var_12_8
		end
	end

	local var_12_9 = LocomotionUtils.pos_on_mesh(arg_12_1.nav_world, var_12_6, 1, 1)

	var_12_2.goal_destination = Vector3Box(var_12_9)
	var_12_2.start_anim_done = true

	local var_12_10 = FrameTable.alloc_table()

	var_12_0:trigger_networked_dialogue_event("egs_calls_mount_battle", var_12_10)

	arg_12_1.quick_teleport = true
	arg_12_1.quick_teleport_exit_pos = Vector3Box(var_12_9)
end

function var_0_0.stormfiend_boss_charge_enter(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0
	local var_13_1 = 0
	local var_13_2 = POSITION_LOOKUP[arg_13_0] + Vector3.up()
	local var_13_3 = arg_13_1.world
	local var_13_4 = World.get_data(var_13_3, "physics_world")
	local var_13_5 = arg_13_1.side
	local var_13_6 = var_13_5.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_13_7 = var_13_5.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_13_0, iter_13_1 in ipairs(var_13_6) do
		local var_13_8 = var_13_7[iter_13_0]
		local var_13_9 = Vector3.distance(var_13_2, iter_13_1)
		local var_13_10 = iter_13_1 + Vector3.up()

		if var_13_1 < var_13_9 and PerceptionUtils.is_position_in_line_of_sight(arg_13_0, var_13_2, var_13_10, var_13_4) then
			var_13_0 = var_13_8
		end
	end

	if HEALTH_ALIVE[var_13_0] then
		arg_13_1.target_unit = var_13_0
		arg_13_1.keep_target = true
	end
end

function var_0_0.to_combat(arg_14_0, arg_14_1, arg_14_2)
	AiUtils.enter_combat(arg_14_0, arg_14_1)
end

function var_0_0.on_chaos_exalted_champion_intro_enter(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = Managers.state.conflict.level_analysis.generic_ai_node_units.chaos_exalted_intro_move_to

	if var_15_0 then
		local var_15_1 = var_15_0[1]
		local var_15_2 = var_0_1(var_15_1, 0)

		arg_15_1.goal_destination = Vector3Box(var_15_2)
		var_0_3.extension(arg_15_0, "health_system").is_invincible = true
	else
		print("Found no generic AI node (chaos_exalted_intro_move_to) for lord intro, ", arg_15_0)

		arg_15_1.intro_timer = nil
	end
end

function var_0_0.on_chaos_exalted_sorcerer_intro_enter(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_intro

	if var_16_0 then
		local var_16_1 = var_16_0[1]
		local var_16_2 = var_0_1(var_16_1, 0)
		local var_16_3 = Unit.local_rotation(var_16_1, 0)

		arg_16_1.quick_teleport_exit_pos = Vector3Box(var_16_2)
		arg_16_1.quick_teleport = true

		Unit.set_local_rotation(arg_16_0, 0, var_16_3)

		var_0_3.extension(arg_16_0, "health_system").is_invincible = true
	else
		print("Found no generic AI node (sorcerer_boss_intro) for lord intro, ", arg_16_0)

		arg_16_1.intro_timer = nil
	end

	local var_16_4 = var_0_3.extension_input(arg_16_0, "dialogue_system")
	local var_16_5 = FrameTable.alloc_table()

	var_16_4:trigger_networked_dialogue_event("ebh_intro", var_16_5)
end

function var_0_0.on_skaven_warlord_intro_enter(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = Managers.state.conflict.level_analysis.generic_ai_node_units.skaven_warlord_intro_move_to

	if var_17_0 then
		local var_17_1 = var_17_0[1]
		local var_17_2 = var_0_1(var_17_1, 0)

		arg_17_1.goal_destination = Vector3Box(var_17_2)
		var_0_3.extension(arg_17_0, "health_system").is_invincible = true
	else
		print("Found no generic AI node (skaven_warlord_intro_move_to) for lord intro, ", arg_17_0)

		arg_17_1.intro_timer = nil
	end
end

function var_0_0.sorcerer_dummy_idle(arg_18_0, arg_18_1, arg_18_2)
	Managers.state.network:anim_event(arg_18_0, "to_plague_wave")

	var_0_3.extension(arg_18_0, "health_system").is_invincible = true
end

function var_0_0.corruptor_enter(arg_19_0, arg_19_1, arg_19_2)
	Managers.state.network:anim_event(arg_19_0, "to_corruptor")
end

function var_0_0.grey_seer_stagger_enter(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_1.damage_wave_extension

	if var_20_0 then
		var_20_0:abort()
	end
end

local function var_0_4(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0
	local var_21_1 = ConflictUtils.get_random_spawner_with_id("sorcerer_boss")

	if var_21_1 then
		var_21_0 = var_0_1(var_21_1, 0)

		local var_21_2 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_0_3.extension(var_21_1, "spawner_system"):spawn_rotation())))

		arg_21_2.spawn_forward = Vector3Box(var_21_2)

		local var_21_3 = {
			(ConflictUtils.get_random_spawner_with_id("sorcerer_boss_minion"))
		}

		print("found spawner for sorcerer_boss_minion:", var_21_3[1])

		var_21_3[2] = ConflictUtils.get_random_spawner_with_id("sorcerer_boss_minion", var_21_3[1])

		print("found spawner for sorcerer_boss_minion:", var_21_3[2])

		arg_21_2.spawners = var_21_3
		arg_21_1.defensive_spawner = var_21_1
	else
		local var_21_4 = {
			spawn_group = "default",
			use_fallback_spawners = true
		}

		var_21_0 = BTSpawnAllies.find_spawn_point(arg_21_0, arg_21_1, var_21_4, arg_21_2)
	end

	return var_21_0
end

function var_0_0.sorcerer_begin_defensive_mode(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = {
		stay_still = true,
		end_time = math.huge
	}
	local var_22_1 = var_0_4(arg_22_0, arg_22_1, var_22_0)

	arg_22_1.spawning_allies = var_22_0
	arg_22_1.quick_teleport_exit_pos = Vector3Box(var_22_1)
	arg_22_1.quick_teleport = true
	var_22_0.call_position = arg_22_1.quick_teleport_exit_pos
	arg_22_1.has_call_position = true
	arg_22_1.teleport_health_percent = arg_22_1.health_extension:current_health_percent() - 0.1
	arg_22_1.spell_count = 0
	arg_22_1.phase = "defensive_starts"

	local var_22_2 = var_0_3.extension_input(arg_22_0, "dialogue_system")
	local var_22_3 = FrameTable.alloc_table()

	var_22_2:trigger_networked_dialogue_event("ebh_summon", var_22_3)
end

function var_0_0.dont_face_target_while_summoning(arg_23_0, arg_23_1, arg_23_2)
	arg_23_1.face_target_while_summoning = false
end

function var_0_0.sorcerer_re_enter_defensive_mode(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = {
		stay_still = true,
		end_time = math.huge
	}
	local var_24_1 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_intro[1]
	local var_24_2 = var_0_1(var_24_1, 0)

	arg_24_1.spawning_allies = var_24_0
	arg_24_1.quick_teleport_exit_pos = Vector3Box(var_24_2)
	arg_24_1.quick_teleport = true
	var_24_0.call_position = arg_24_1.quick_teleport_exit_pos
	arg_24_1.has_call_position = true
	arg_24_1.teleport_health_percent = arg_24_1.health_extension:current_health_percent() - 0.1
	arg_24_1.spell_count = 0

	local var_24_3 = var_0_3.extension_input(arg_24_0, "dialogue_system")
	local var_24_4 = FrameTable.alloc_table()

	var_24_3:trigger_networked_dialogue_event("ebh_summon", var_24_4)
end

function var_0_0.target_furthest_player_in_sight(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
	local var_25_1 = arg_25_1.physics_world or World.get_data(arg_25_1.world, "physics_world")
	local var_25_2 = POSITION_LOOKUP[arg_25_0]
	local var_25_3
	local var_25_4 = 0

	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		local var_25_5 = PerceptionUtils.raycast_spine_to_spine(arg_25_0, iter_25_1, var_25_1)
		local var_25_6 = Vector3.distance_squared(var_25_2, POSITION_LOOKUP[iter_25_1])

		if var_25_5 and var_25_4 < var_25_6 then
			var_25_3 = iter_25_1
			var_25_4 = var_25_6
		end
	end

	arg_25_1.target_unit = var_25_3 or arg_25_1.target_unit
end

function var_0_0.sorcerer_spawn_horde(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = {
		stay_still = true,
		end_time = math.huge
	}

	var_0_4(arg_26_0, arg_26_1, var_26_0)

	arg_26_1.spawning_allies = var_26_0
end

function var_0_0.sorcerer_defensive_seeking_bomb(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = var_0_3.extension_input(arg_27_0, "dialogue_system")
	local var_27_1 = FrameTable.alloc_table()

	var_27_0:trigger_networked_dialogue_event("ebh_insect_spell", var_27_1)
end

function var_0_0.teleport_to_center(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_center[1]
	local var_28_1 = var_0_1(var_28_0, 0)

	if var_28_1 then
		arg_28_1.quick_teleport_exit_pos = Vector3Box(var_28_1)
		arg_28_1.quick_teleport = true
		arg_28_1.move_pos = nil

		return
	end
end

function var_0_0.quick_teleport(arg_29_0, arg_29_1, arg_29_2)
	arg_29_1.quick_teleport = true
end

function var_0_0.summoning_starts(arg_30_0, arg_30_1, arg_30_2)
	arg_30_1.is_summoning = true
end

function var_0_0.wave_summoning_starts(arg_31_0, arg_31_1, arg_31_2)
	arg_31_1.is_summoning = true
end

function var_0_0.block_stagger_start(arg_32_0, arg_32_1, arg_32_2)
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
		local var_32_1 = ConflictUtils.get_spawn_pos_on_circle(arg_32_1.nav_world, var_32_0, 15, 7, 15)

		if var_32_1 then
			arg_32_1.quick_teleport_exit_pos = Vector3Box(var_32_1)
			arg_32_1.quick_teleport = true
			arg_32_1.move_pos = nil

			return
		end
	end
end

function var_0_0.sorcerer_evade(arg_33_0, arg_33_1, arg_33_2)
	arg_33_1.quick_teleport = true

	local var_33_0 = Managers.state.difficulty:get_difficulty()
	local var_33_1 = "sorcerer_boss_hit_extra"
	local var_33_2 = "sorcerer_boss_minion"
	local var_33_3 = Managers.state.conflict
	local var_33_4 = true
	local var_33_5 = true
	local var_33_6
	local var_33_7 = arg_33_1.side.side_id

	var_33_3.horde_spawner:execute_event_horde(arg_33_2, var_33_2, var_33_7, var_33_1, var_33_6, var_33_5, nil, var_33_4)

	local var_33_8 = var_0_3.extension_input(arg_33_0, "dialogue_system")
	local var_33_9 = FrameTable.alloc_table()

	var_33_8:trigger_networked_dialogue_event("ebh_taunt", var_33_9)
end

function var_0_0.warlord_defensive_on_enter(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_1.spawn_allies_positions
	local var_34_1 = POSITION_LOOKUP[arg_34_0]
	local var_34_2 = 0
	local var_34_3

	if var_34_0 then
		for iter_34_0 = 1, #var_34_0 do
			local var_34_4 = var_34_0[iter_34_0]:unbox()
			local var_34_5 = Vector3.distance(var_34_1, var_34_4)

			if var_34_2 < var_34_5 then
				var_34_3 = var_34_4
				var_34_2 = var_34_5
			end
		end
	end

	var_34_3 = var_34_3 or var_34_1
	arg_34_1.override_spawn_allies_call_position = Vector3Box(var_34_3)
end

function var_0_0.keep_target(arg_35_0, arg_35_1, arg_35_2)
	arg_35_1.keep_target = true
end

function var_0_0.add_invincibility(arg_36_0, arg_36_1, arg_36_2)
	var_0_3.extension(arg_36_0, "health_system").is_invincible = true
end

function var_0_0.remove_invincibility(arg_37_0, arg_37_1, arg_37_2)
	var_0_3.extension(arg_37_0, "health_system").is_invincible = false
end

function var_0_0.activate_slot_system(arg_38_0, arg_38_1, arg_38_2)
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_38_0, true)
end

function var_0_0.troll_chief_on_downed(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = {
		stay_still = true,
		end_time = math.huge
	}
	local var_39_1 = Quaternion.forward(Quaternion.flat_no_roll(Unit.local_rotation(arg_39_0, 0)))

	var_39_0.spawn_forward = Vector3Box(var_39_1)
	arg_39_1.spawning_allies = var_39_0
	arg_39_1.spawned_allies_wave = 0

	local var_39_2, var_39_3, var_39_4, var_39_5, var_39_6 = arg_39_1.health_extension:respawn_thresholds()

	arg_39_1.downed_phase = var_39_6
end

DLCUtils.merge("bt_enter_hooks", var_0_0)
