-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_leave_hooks.lua

BTLeaveHooks = BTLeaveHooks or {}

local var_0_0 = BTLeaveHooks
local var_0_1 = Unit.alive
local var_0_2 = ScriptUnit

function var_0_0.reset_fling_skaven(arg_1_0, arg_1_1, arg_1_2)
	arg_1_1.fling_skaven = false
end

function var_0_0.check_if_victim_was_grabbed(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1.victim_grabbed then
		arg_2_1.has_grabbed_victim = true

		local var_2_0 = var_0_2.has_extension(arg_2_1.victim_grabbed, "status_system")
		local var_2_1 = var_2_0 and var_2_0:is_grabbed_by_chaos_spawn()

		if arg_2_1.stagger or not HEALTH_ALIVE[arg_2_0] then
			if var_2_1 then
				StatusUtils.set_grabbed_by_chaos_spawn_network(arg_2_1.victim_grabbed, false, arg_2_0)
			end

			arg_2_1.has_grabbed_victim = nil
			arg_2_1.victim_grabbed = nil
		end
	end
end

function var_0_0.kill_unit(arg_3_0, arg_3_1, arg_3_2)
	if Unit.alive(arg_3_0) and HEALTH_ALIVE[arg_3_0] then
		var_0_2.has_extension(arg_3_0, "health_system"):die("forced")
	end
end

function var_0_0.unclamp_health(arg_4_0, arg_4_1, arg_4_2)
	var_0_2.has_extension(arg_4_0, "health_system"):set_min_health_percentage(nil)
end

function var_0_0.ring_summoning_ends(arg_5_0, arg_5_1, arg_5_2)
	arg_5_1.ring_summonings_finished = arg_5_1.ring_summonings_finished + 1
	arg_5_1.ring_cooldown = arg_5_1.ring_total_cooldown
end

function var_0_0.charge_ends(arg_6_0, arg_6_1, arg_6_2)
	arg_6_1.charge_cooldown = arg_6_1.charge_total_cooldown
end

function var_0_0.teleport_ends(arg_7_0, arg_7_1, arg_7_2)
	arg_7_1.teleport_cooldown = arg_7_1.teleport_total_cooldown
end

function var_0_0.summoning_ends(arg_8_0, arg_8_1, arg_8_2)
	arg_8_1.is_summoning = false
end

function var_0_0.sorcerer_next_phase(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1.phase

	if var_9_0 == "defensive_starts" then
		arg_9_1.phase = "defensive_combat"
	elseif var_9_0 == "defensive_combat" then
		arg_9_1.phase = "defensive_ends"
	else
		arg_9_1.phase = "defensive_completed"
	end
end

function var_0_0.sorcerer_setup_done(arg_10_0, arg_10_1, arg_10_2)
	arg_10_1.mode = "offensive"
	arg_10_1.setup_done = true
	arg_10_1.phase_timer = arg_10_2 + 20
end

function var_0_0.sorcerer_evade(arg_11_0, arg_11_1, arg_11_2)
	arg_11_1.escape_teleport = false
end

function var_0_0.reset_stormfiend_charge(arg_12_0, arg_12_1, arg_12_2)
	arg_12_1.weakspot_hits = nil
	arg_12_1.weakspot_rage = nil
end

function var_0_0.stormfiend_boss_mount_leave(arg_13_0, arg_13_1, arg_13_2)
	return
end

function var_0_0.stormfiend_boss_rage_leave(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = Managers.state.network:game()
	local var_14_1 = Managers.state.unit_storage:go_id(arg_14_0)

	arg_14_1.intro_rage = nil
	var_0_2.extension(arg_14_0, "health_system").is_invincible = false

	GameSession.set_game_object_field(var_14_0, var_14_1, "show_health_bar", true)
	Managers.state.event:trigger("boss_health_bar_register_unit", arg_14_0, "lord")

	local var_14_2 = Managers.state.conflict.level_analysis.generic_ai_node_units.grey_seer_intro_jump_down_to

	if var_14_2 then
		local var_14_3 = var_14_2[1]
		local var_14_4 = Unit.local_position(var_14_3, 0)
		local var_14_5 = LocomotionUtils.pos_on_mesh(arg_14_1.nav_world, var_14_4, 1, 1)

		arg_14_1.goal_destination = Vector3Box(var_14_5)
		arg_14_1.jump_down_intro = true
	end
end

function var_0_0.stormfiend_boss_jump_down_leave(arg_15_0, arg_15_1, arg_15_2)
	arg_15_1.jump_down_intro = nil
	arg_15_1.goal_destination = nil
end

local function var_0_3(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_2.mounted_data
	local var_16_1 = arg_16_2.goal_destination
	local var_16_2 = arg_16_2.blackboard

	var_16_0.knocked_off_mounted_timer, var_16_0.mount_unit = Managers.time:time("game"), arg_16_0

	local var_16_3 = BLACKBOARDS[arg_16_0]

	var_16_3.goal_destination = var_16_1
	var_16_3.anim_cb_move = true
	var_16_3.intro_rage = true
	var_16_2.intro_timer = nil
end

function var_0_0.on_grey_seer_intro_leave(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_1.exit_last_action then
		local var_17_0 = Managers.state.conflict
		local var_17_1 = var_17_0.level_analysis.generic_ai_node_units.grey_seer_intro_stormfiend_spawn

		if var_17_1 then
			local var_17_2 = var_17_1[1]
			local var_17_3 = Unit.local_position(var_17_2, 0)
			local var_17_4 = Breeds.skaven_stormfiend_boss
			local var_17_5 = "misc"

			arg_17_1.knocked_off_mount = true
			arg_17_1.waiting_for_pickup = true

			local var_17_6 = {
				spawned_func = var_0_3,
				mounted_data = arg_17_1.mounted_data,
				goal_destination = Vector3Box(POSITION_LOOKUP[arg_17_0]),
				blackboard = arg_17_1
			}

			var_17_0:spawn_queued_unit(var_17_4, Vector3Box(var_17_3), QuaternionBox(Unit.local_rotation(arg_17_0, 0)), var_17_5, nil, nil, var_17_6)

			local var_17_7 = var_0_2.extension_input(arg_17_0, "dialogue_system")
			local var_17_8 = FrameTable.alloc_table()

			var_17_7:trigger_networked_dialogue_event("egs_call_mount_intro", var_17_8)
		else
			print("Found no generic AI node (grey_seer_intro_stormfiend_spawn) for grey_seer_intro_leave")
		end

		var_17_0:add_angry_boss(1, arg_17_1)

		arg_17_1.is_angry = true
	end
end

function var_0_0.on_grey_seer_death_sequence_leave(arg_18_0, arg_18_1, arg_18_2)
	arg_18_1.current_phase = 6
	var_0_2.extension(arg_18_1.unit, "health_system").is_invincible = false

	arg_18_1.navigation_extension:set_enabled(false)
	arg_18_1.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

function var_0_0.leave_attack_grabbed(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = HEALTH_ALIVE[arg_19_1.victim_grabbed]

	if arg_19_1.stagger or not HEALTH_ALIVE[arg_19_0] or not var_19_0 then
		if var_19_0 then
			StatusUtils.set_grabbed_by_chaos_spawn_network(arg_19_1.victim_grabbed, false, arg_19_0)
		end

		arg_19_1.has_grabbed_victim = nil
		arg_19_1.victim_grabbed = nil
		arg_19_1.attack_grabbed_attacks = 0
		arg_19_1.chew_attacks_done = 0
	end

	arg_19_1.override_target_unit = nil
end

function var_0_0.on_lord_intro_leave(arg_20_0, arg_20_1, arg_20_2)
	if HEALTH_ALIVE[arg_20_0] and not arg_20_1.exit_last_action then
		var_0_2.extension(arg_20_0, "health_system").is_invincible = false

		local var_20_0 = Managers.state.network:game()
		local var_20_1 = Managers.state.unit_storage:go_id(arg_20_0)

		GameSession.set_game_object_field(var_20_0, var_20_1, "show_health_bar", true)
		Managers.state.event:trigger("boss_health_bar_register_unit", arg_20_0, "lord")
		Managers.state.conflict:add_angry_boss(1, arg_20_1)

		arg_20_1.is_angry = true
		arg_20_1.intro_timer = nil
	end

	arg_20_1.stagger = nil
	arg_20_1.stagger_immune_time = arg_20_2 + 2
end

function var_0_0.on_lord_warlord_intro_leave(arg_21_0, arg_21_1, arg_21_2)
	if HEALTH_ALIVE[arg_21_0] and not arg_21_1.exit_last_action then
		var_0_2.extension(arg_21_0, "health_system").is_invincible = false

		local var_21_0 = Managers.state.network:game()
		local var_21_1 = Managers.state.unit_storage:go_id(arg_21_0)

		GameSession.set_game_object_field(var_21_0, var_21_1, "show_health_bar", true)
		Managers.state.event:trigger("boss_health_bar_register_unit", arg_21_0, "lord")
		Managers.state.conflict:add_angry_boss(1, arg_21_1)

		arg_21_1.is_angry = true
		arg_21_1.jump_down_timer = arg_21_2 + 5

		Managers.state.network:anim_event(arg_21_0, "to_dual_wield")

		local var_21_2 = Managers.state.conflict.level_analysis.generic_ai_node_units.skaven_warlord_intro_jump_to

		if var_21_2 then
			local var_21_3 = var_21_2[1]
			local var_21_4 = Unit.local_position(var_21_3, 0)

			arg_21_1.jump_from_pos = Vector3Box(POSITION_LOOKUP[arg_21_0])
			arg_21_1.exit_pos = Vector3Box(var_21_4)
		end
	end
end

function var_0_0.reset_keep_target(arg_22_0, arg_22_1, arg_22_2)
	arg_22_1.keep_target = nil
end

function var_0_0.reset_chain_stagger(arg_23_0, arg_23_1, arg_23_2)
	arg_23_1.num_chain_stagger = nil
end

function var_0_0.remove_invincibility(arg_24_0, arg_24_1, arg_24_2)
	var_0_2.extension(arg_24_0, "health_system").is_invincible = false
end

function var_0_0.mutator_sorcerer_activate_teleport(arg_25_0, arg_25_1, arg_25_2)
	if arg_25_1.stagger then
		arg_25_1.quick_teleport = true
	end
end

function var_0_0.mutator_sorcerer_force_teleport(arg_26_0, arg_26_1, arg_26_2)
	arg_26_1.quick_teleport = true
end

function var_0_0.destroy_unit_leave_hook(arg_27_0, arg_27_1, arg_27_2)
	Managers.state.conflict:destroy_unit(arg_27_0, arg_27_1, "debug")
end

function var_0_0.remove_goal_destination(arg_28_0, arg_28_1, arg_28_2)
	arg_28_1.goal_destination = nil
end

function var_0_0.bulwark_stagger_leave(arg_29_0, arg_29_1, arg_29_2)
	Managers.state.network:anim_event(arg_29_0, "stagger_finished")

	if not arg_29_1.reset_after_stagger then
		return
	end

	local var_29_0 = arg_29_1.breed

	arg_29_1.max_stagger_reached = nil
	arg_29_1.reset_on_stagger_leave = nil
	arg_29_1.stagger = 0
	arg_29_1.cached_stagger = 0
	arg_29_1.stagger_level = nil
	arg_29_1.stagger_recover_time = var_29_0.stagger_recover_time
	arg_29_1.reset_after_stagger = nil

	var_0_2.extension(arg_29_0, "ai_shield_system"):set_is_blocking(true)
end

function var_0_0.bulwark_vortex_leave(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_1.breed

	arg_30_1.max_stagger_reached = nil
	arg_30_1.reset_on_stagger_leave = nil
	arg_30_1.stagger = 0
	arg_30_1.cached_stagger = 0
	arg_30_1.stagger_level = nil
	arg_30_1.stagger_recover_time = var_30_0.stagger_recover_time
	arg_30_1.reset_after_stagger = nil
	arg_30_1.stagger_activated = false
end

function var_0_0.beastmen_standard_bearer_leave_move_and_plant_standard(arg_31_0, arg_31_1, arg_31_2)
	arg_31_1.move_and_place_standard = nil
	arg_31_1.stagger = nil
	var_0_2.extension(arg_31_0, "health_system").is_invincible = false
end

DLCUtils.merge("bt_leave_hooks", var_0_0)
