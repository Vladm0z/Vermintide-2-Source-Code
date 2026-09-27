-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_leave_hooks.lua

local BTLeaveHooks = BTLeaveHooks

BTLeaveHooks = BTLeaveHooks or {}
BTLeaveHooks = BTLeaveHooks

local BTLeaveHooks_2 = BTLeaveHooks
local alive = Unit.alive
local ScriptUnit = ScriptUnit

BTLeaveHooks_2.reset_fling_skaven = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	arg_1_1.fling_skaven = false
end

BTLeaveHooks_2.check_if_victim_was_grabbed = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not arg_2_1.victim_grabbed then
		arg_2_1.has_grabbed_victim = true

		local has_extension = ScriptUnit.has_extension(arg_2_1.victim_grabbed, "status_system")
		local flag = not has_extension and has_extension:is_grabbed_by_chaos_spawn()

		if not (arg_2_1.stagger or HEALTH_ALIVE[arg_2_0]) then
			if not flag then
				StatusUtils.set_grabbed_by_chaos_spawn_network(arg_2_1.victim_grabbed, false, arg_2_0)
			end

			arg_2_1.has_grabbed_victim = nil
			arg_2_1.victim_grabbed = nil
		end
	end
end

BTLeaveHooks_2.kill_unit = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	if not Unit.alive(arg_3_0) and not HEALTH_ALIVE[arg_3_0] then
		ScriptUnit.has_extension(arg_3_0, "health_system"):die("forced")
	end
end

BTLeaveHooks_2.unclamp_health = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	ScriptUnit.has_extension(arg_4_0, "health_system"):set_min_health_percentage(nil)
end

BTLeaveHooks_2.ring_summoning_ends = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	arg_5_1.ring_summonings_finished = arg_5_1.ring_summonings_finished + 1
	arg_5_1.ring_cooldown = arg_5_1.ring_total_cooldown
end

BTLeaveHooks_2.charge_ends = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_1.charge_cooldown = arg_6_1.charge_total_cooldown
end

BTLeaveHooks_2.teleport_ends = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	arg_7_1.teleport_cooldown = arg_7_1.teleport_total_cooldown
end

BTLeaveHooks_2.summoning_ends = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	arg_8_1.is_summoning = false
end

BTLeaveHooks_2.sorcerer_next_phase = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local phase = arg_9_1.phase

	if phase == "defensive_starts" then
		arg_9_1.phase = "defensive_combat"
	elseif phase == "defensive_combat" then
		arg_9_1.phase = "defensive_ends"
	else
		arg_9_1.phase = "defensive_completed"
	end
end

BTLeaveHooks_2.sorcerer_setup_done = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	arg_10_1.mode = "offensive"
	arg_10_1.setup_done = true
	arg_10_1.phase_timer = arg_10_2 + 20
end

BTLeaveHooks_2.sorcerer_evade = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	arg_11_1.escape_teleport = false
end

BTLeaveHooks_2.reset_stormfiend_charge = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	arg_12_1.weakspot_hits = nil
	arg_12_1.weakspot_rage = nil
end

BTLeaveHooks_2.stormfiend_boss_mount_leave = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	return
end

BTLeaveHooks_2.stormfiend_boss_rage_leave = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_14_0)

	arg_14_1.intro_rage = nil
	ScriptUnit.extension(arg_14_0, "health_system").is_invincible = false

	GameSession.set_game_object_field(game, go_id, "show_health_bar", true)
	Managers.state.event:trigger("boss_health_bar_register_unit", arg_14_0, "lord")

	local grey_seer_intro_jump_down_to = Managers.state.conflict.level_analysis.generic_ai_node_units.grey_seer_intro_jump_down_to

	if not grey_seer_intro_jump_down_to then
		local var_14_3 = grey_seer_intro_jump_down_to[1]
		local local_position = Unit.local_position(var_14_3, 0)
		local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_14_1.nav_world, local_position, 1, 1)

		arg_14_1.goal_destination = Vector3Box(pos_on_mesh)
		arg_14_1.jump_down_intro = true
	end
end

BTLeaveHooks_2.stormfiend_boss_jump_down_leave = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	arg_15_1.jump_down_intro = nil
	arg_15_1.goal_destination = nil
end

local function fn(arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local mounted_data = arg_16_2.mounted_data
	local goal_destination = arg_16_2.goal_destination
	local blackboard = arg_16_2.blackboard

	mounted_data.knocked_off_mounted_timer, mounted_data.mount_unit = Managers.time:time("game"), arg_16_0

	local var_16_3 = BLACKBOARDS[arg_16_0]

	var_16_3.goal_destination = goal_destination
	var_16_3.anim_cb_move = true
	var_16_3.intro_rage = true
	blackboard.intro_timer = nil
end

BTLeaveHooks_2.on_grey_seer_intro_leave = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	if not arg_17_1.exit_last_action then
		local conflict = Managers.state.conflict
		local grey_seer_intro_stormfiend_spawn = conflict.level_analysis.generic_ai_node_units.grey_seer_intro_stormfiend_spawn

		if not grey_seer_intro_stormfiend_spawn then
			local var_17_2 = grey_seer_intro_stormfiend_spawn[1]
			local local_position = Unit.local_position(var_17_2, 0)
			local skaven_stormfiend_boss = Breeds.skaven_stormfiend_boss
			local str = "misc"

			arg_17_1.knocked_off_mount = true
			arg_17_1.waiting_for_pickup = true

			local tbl = {
				spawned_func = fn,
				mounted_data = arg_17_1.mounted_data,
				goal_destination = Vector3Box(POSITION_LOOKUP[arg_17_0]),
				blackboard = arg_17_1
			}

			conflict:spawn_queued_unit(skaven_stormfiend_boss, Vector3Box(local_position), QuaternionBox(Unit.local_rotation(arg_17_0, 0)), str, nil, nil, tbl)

			local extension_input = ScriptUnit.extension_input(arg_17_0, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_networked_dialogue_event("egs_call_mount_intro", alloc_table)
		else
			print("Found no generic AI node (grey_seer_intro_stormfiend_spawn) for grey_seer_intro_leave")
		end

		conflict:add_angry_boss(1, arg_17_1)

		arg_17_1.is_angry = true
	end
end

BTLeaveHooks_2.on_grey_seer_death_sequence_leave = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	arg_18_1.current_phase = 6
	ScriptUnit.extension(arg_18_1.unit, "health_system").is_invincible = false

	arg_18_1.navigation_extension:set_enabled(false)
	arg_18_1.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

BTLeaveHooks_2.leave_attack_grabbed = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = HEALTH_ALIVE[arg_19_1.victim_grabbed]

	if not ((arg_19_1.stagger or not HEALTH_ALIVE[arg_19_0]) and var_19_0) then
		if not var_19_0 then
			StatusUtils.set_grabbed_by_chaos_spawn_network(arg_19_1.victim_grabbed, false, arg_19_0)
		end

		arg_19_1.has_grabbed_victim = nil
		arg_19_1.victim_grabbed = nil
		arg_19_1.attack_grabbed_attacks = 0
		arg_19_1.chew_attacks_done = 0
	end

	arg_19_1.override_target_unit = nil
end

BTLeaveHooks_2.on_lord_intro_leave = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	if not (not HEALTH_ALIVE[arg_20_0] and arg_20_1.exit_last_action) then
		ScriptUnit.extension(arg_20_0, "health_system").is_invincible = false

		local game = Managers.state.network:game()
		local go_id = Managers.state.unit_storage:go_id(arg_20_0)

		GameSession.set_game_object_field(game, go_id, "show_health_bar", true)
		Managers.state.event:trigger("boss_health_bar_register_unit", arg_20_0, "lord")
		Managers.state.conflict:add_angry_boss(1, arg_20_1)

		arg_20_1.is_angry = true
		arg_20_1.intro_timer = nil
	end

	arg_20_1.stagger = nil
	arg_20_1.stagger_immune_time = arg_20_2 + 2
end

BTLeaveHooks_2.on_lord_warlord_intro_leave = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	if not (not HEALTH_ALIVE[arg_21_0] and arg_21_1.exit_last_action) then
		ScriptUnit.extension(arg_21_0, "health_system").is_invincible = false

		local game = Managers.state.network:game()
		local go_id = Managers.state.unit_storage:go_id(arg_21_0)

		GameSession.set_game_object_field(game, go_id, "show_health_bar", true)
		Managers.state.event:trigger("boss_health_bar_register_unit", arg_21_0, "lord")
		Managers.state.conflict:add_angry_boss(1, arg_21_1)

		arg_21_1.is_angry = true
		arg_21_1.jump_down_timer = arg_21_2 + 5

		Managers.state.network:anim_event(arg_21_0, "to_dual_wield")

		local skaven_warlord_intro_jump_to = Managers.state.conflict.level_analysis.generic_ai_node_units.skaven_warlord_intro_jump_to

		if not skaven_warlord_intro_jump_to then
			local var_21_3 = skaven_warlord_intro_jump_to[1]
			local local_position = Unit.local_position(var_21_3, 0)

			arg_21_1.jump_from_pos = Vector3Box(POSITION_LOOKUP[arg_21_0])
			arg_21_1.exit_pos = Vector3Box(local_position)
		end
	end
end

BTLeaveHooks_2.reset_keep_target = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	arg_22_1.keep_target = nil
end

BTLeaveHooks_2.reset_chain_stagger = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	arg_23_1.num_chain_stagger = nil
end

BTLeaveHooks_2.remove_invincibility = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	ScriptUnit.extension(arg_24_0, "health_system").is_invincible = false
end

BTLeaveHooks_2.mutator_sorcerer_activate_teleport = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	if not arg_25_1.stagger then
		arg_25_1.quick_teleport = true
	end
end

BTLeaveHooks_2.mutator_sorcerer_force_teleport = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	arg_26_1.quick_teleport = true
end

BTLeaveHooks_2.destroy_unit_leave_hook = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	Managers.state.conflict:destroy_unit(arg_27_0, arg_27_1, "debug")
end

BTLeaveHooks_2.remove_goal_destination = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	arg_28_1.goal_destination = nil
end

BTLeaveHooks_2.bulwark_stagger_leave = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	Managers.state.network:anim_event(arg_29_0, "stagger_finished")

	if not arg_29_1.reset_after_stagger then
		return
	end

	local breed = arg_29_1.breed

	arg_29_1.max_stagger_reached = nil
	arg_29_1.reset_on_stagger_leave = nil
	arg_29_1.stagger = 0
	arg_29_1.cached_stagger = 0
	arg_29_1.stagger_level = nil
	arg_29_1.stagger_recover_time = breed.stagger_recover_time
	arg_29_1.reset_after_stagger = nil

	ScriptUnit.extension(arg_29_0, "ai_shield_system"):set_is_blocking(true)
end

BTLeaveHooks_2.bulwark_vortex_leave = function (arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	local breed = arg_30_1.breed

	arg_30_1.max_stagger_reached = nil
	arg_30_1.reset_on_stagger_leave = nil
	arg_30_1.stagger = 0
	arg_30_1.cached_stagger = 0
	arg_30_1.stagger_level = nil
	arg_30_1.stagger_recover_time = breed.stagger_recover_time
	arg_30_1.reset_after_stagger = nil
	arg_30_1.stagger_activated = false
end

BTLeaveHooks_2.beastmen_standard_bearer_leave_move_and_plant_standard = function (arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	arg_31_1.move_and_place_standard = nil
	arg_31_1.stagger = nil
	ScriptUnit.extension(arg_31_0, "health_system").is_invincible = false
end

DLCUtils.merge("bt_leave_hooks", BTLeaveHooks_2)
