-- chunkname: @scripts/unit_extensions/generic/interactions.lua

InteractionResult = table.mirror_array_inplace({
	"ONGOING",
	"SUCCESS",
	"FAILURE",
	"USER_ENDED"
})
InteractionCustomChecks = InteractionCustomChecks or {}

function InteractionCustomChecks.dialogue_not_playing(arg_1_0, arg_1_1)
	return not Managers.state.entity:system("dialogue_system"):is_dialogue_playing()
end

InteractionDefinitions = InteractionDefinitions or {}
InteractionDefinitions.player_generic = {
	default_config = {
		hud_verb = "player_interaction",
		duration = 2,
		hold = true,
		swap_to_3p = true
	},
	server = {
		start = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
			InteractionDefinitions.player_generic.current_data = InteractionHelper.choose_player_interaction(arg_2_1, arg_2_2)

			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].server.start(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
		end,
		update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].server.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
		end,
		stop = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
			local var_4_0 = InteractionDefinitions[InteractionDefinitions.player_generic.current_data].server.stop(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)

			InteractionDefinitions.player_generic.current_data = nil

			return var_4_0
		end
	},
	client = {
		start = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
			InteractionDefinitions.player_generic.current_data = InteractionHelper.choose_player_interaction(arg_5_1, arg_5_2)

			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].client.start(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
		end,
		update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].client.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
		end,
		stop = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
			local var_7_0 = InteractionDefinitions[InteractionDefinitions.player_generic.current_data].client.stop(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)

			InteractionDefinitions.player_generic.current_data = nil

			return var_7_0
		end,
		get_progress = function(arg_8_0, arg_8_1, arg_8_2)
			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].client.get_progress(arg_8_0, arg_8_1, arg_8_2)
		end,
		hud_description = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
			local var_9_0
			local var_9_1 = InteractionHelper.choose_player_interaction(arg_9_4, arg_9_0)

			if var_9_1 then
				var_9_0 = InteractionDefinitions[var_9_1].client.hud_description(arg_9_0, arg_9_3, arg_9_3, arg_9_3, arg_9_4)
			else
				var_9_0 = InteractionDefinitions.player_generic.default_config.hud_verb
			end

			if arg_9_0 and Unit.alive(arg_9_0) then
				local var_9_2 = Managers.player
				local var_9_3 = Managers.state.network.profile_synchronizer
				local var_9_4 = ""
				local var_9_5 = var_9_2:owner(arg_9_0)

				if var_9_5 then
					local var_9_6 = var_9_5:network_id()
					local var_9_7 = var_9_5:local_player_id()
					local var_9_8 = var_9_3:profile_by_peer(var_9_6, var_9_7)

					var_9_4 = SPProfiles[var_9_8].ingame_display_name
				end

				return var_9_4, var_9_0
			end
		end,
		can_interact = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			local var_10_0 = InteractionHelper.choose_player_interaction(arg_10_0, arg_10_1)

			return var_10_0 ~= nil, nil, var_10_0
		end
	},
	get_config = function()
		if InteractionDefinitions.player_generic.current_data then
			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].config
		else
			return InteractionDefinitions.player_generic.default_config
		end
	end
}

local function var_0_0(arg_12_0, arg_12_1)
	local var_12_0 = ScriptUnit.extension(arg_12_0, "first_person_system")
	local var_12_1 = var_12_0:current_position() + Vector3(math.random(-1, 1), math.random(-1, 1), 0) * 0.2
	local var_12_2 = var_12_0:current_rotation()
	local var_12_3 = var_12_1 + Vector3.normalize(Quaternion.forward(var_12_2)) * 0.7
	local var_12_4 = "dropped"
	local var_12_5 = NetworkLookup.pickup_names[arg_12_1]
	local var_12_6 = NetworkLookup.pickup_spawn_types[var_12_4]

	Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", var_12_5, var_12_3, var_12_2, var_12_6)
end

InteractionDefinitions.revive = {
	config = {
		block_other_interactions = true,
		hud_verb = "revive",
		hold = true,
		swap_to_3p = true,
		activate_block = true,
		duration = 2
	},
	server = {
		start = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			local var_13_0 = arg_13_4.duration
			local var_13_1 = ScriptUnit.extension(arg_13_1, "buff_system"):apply_buffs_to_value(var_13_0, "faster_revive")

			ScriptUnit.extension(arg_13_2, "status_system"):set_knocked_down_bleed_buff_paused(true)

			arg_13_3.done_time = arg_13_5 + var_13_1
		end,
		update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
			if ScriptUnit.extension(arg_14_1, "status_system"):is_knocked_down() or not HEALTH_ALIVE[arg_14_1] then
				return InteractionResult.FAILURE
			end

			if not ScriptUnit.extension(arg_14_2, "status_system"):is_knocked_down() or not HEALTH_ALIVE[arg_14_2] then
				return InteractionResult.FAILURE
			end

			if arg_14_6 > arg_14_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
			if arg_15_6 == InteractionResult.SUCCESS then
				StatusUtils.set_revived_network(arg_15_2, true, arg_15_1)

				local var_15_0 = Managers.player
				local var_15_1 = var_15_0:unit_owner(arg_15_1)
				local var_15_2 = var_15_0:unit_owner(arg_15_2)

				if not var_15_1 or not var_15_2 then
					return
				end

				local var_15_3 = POSITION_LOOKUP[arg_15_2]

				Managers.telemetry_events:player_revived(var_15_1, var_15_2, var_15_3)
			elseif HEALTH_ALIVE[arg_15_2] then
				ScriptUnit.extension(arg_15_2, "status_system"):set_knocked_down_bleed_buff_paused(false)
			end
		end,
		can_interact = function(arg_16_0, arg_16_1)
			local var_16_0 = ScriptUnit.extension(arg_16_1, "status_system")
			local var_16_1 = var_16_0:is_knocked_down()
			local var_16_2 = var_16_0:is_pounced_down()
			local var_16_3 = HEALTH_ALIVE[arg_16_1]
			local var_16_4 = var_16_0:is_grabbed_by_pack_master()
			local var_16_5 = var_16_0:get_is_ledge_hanging()
			local var_16_6 = var_16_0:is_hanging_from_hook()

			return var_16_1 and var_16_3 and not var_16_2 and not var_16_4 and not var_16_5 and not var_16_6
		end
	},
	client = {
		start = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
			arg_17_3.start_time = arg_17_5

			local var_17_0 = Unit.animation_find_variable(arg_17_2, "revive_time")
			local var_17_1 = arg_17_4.duration
			local var_17_2 = FrameTable.alloc_table()
			local var_17_3 = Unit.alive(arg_17_1)

			if var_17_3 then
				var_17_1 = ScriptUnit.extension(arg_17_1, "buff_system"):apply_buffs_to_value(var_17_1, "faster_revive")

				local var_17_4 = Unit.animation_find_variable(arg_17_1, "interaction_duration")

				Unit.animation_set_variable(arg_17_1, var_17_4, var_17_1)
				Unit.animation_event(arg_17_1, "interaction_revive")

				var_17_2.target = arg_17_2
			end

			local var_17_5 = Unit.alive(arg_17_2)

			if var_17_5 then
				Unit.animation_set_variable(arg_17_2, var_17_0, var_17_1)
				Unit.animation_event(arg_17_2, "revive_start")

				if ScriptUnit.has_extension(arg_17_2, "first_person_system") then
					ScriptUnit.extension(arg_17_2, "first_person_system"):set_wanted_player_height("stand", arg_17_5, var_17_1)
				end

				var_17_2.target_name = ScriptUnit.extension(arg_17_2, "dialogue_system").context.player_profile

				ScriptUnit.extension(arg_17_1, "status_system"):set_reviving(true, arg_17_2)
			end

			arg_17_3.duration = var_17_1

			if var_17_5 and var_17_3 then
				ScriptUnit.extension_input(arg_17_1, "dialogue_system"):trigger_dialogue_event("start_revive", var_17_2)
			end
		end,
		update = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
			return
		end,
		stop = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			arg_19_3.start_time = nil

			local var_19_0 = Unit.alive(arg_19_2)
			local var_19_1 = Unit.alive(arg_19_1)

			if var_19_1 then
				Unit.animation_event(arg_19_1, "interaction_end")
			end

			if arg_19_6 == InteractionResult.SUCCESS then
				if var_19_0 then
					Unit.animation_event(arg_19_2, "revive_complete")
				end

				if var_19_1 and var_19_0 then
					StatisticsUtil.register_revive(arg_19_1, arg_19_2, arg_19_3.statistics_db)

					local var_19_2 = Managers.player
					local var_19_3 = var_19_2:unit_owner(arg_19_1)
					local var_19_4 = var_19_2:unit_owner(arg_19_2)
					local var_19_5 = POSITION_LOOKUP[arg_19_2]

					if not var_19_4.is_server then
						Managers.telemetry_events:player_revived(var_19_3, var_19_4, var_19_5)
					end
				end
			elseif var_19_0 then
				Unit.animation_event(arg_19_2, "revive_abort")

				if ScriptUnit.has_extension(arg_19_2, "first_person_system") then
					ScriptUnit.extension(arg_19_2, "first_person_system"):set_wanted_player_height("knocked_down", arg_19_5)
				end
			end

			ScriptUnit.extension(arg_19_1, "status_system"):set_reviving(false, arg_19_2)
		end,
		get_progress = function(arg_20_0, arg_20_1, arg_20_2)
			local var_20_0 = arg_20_0.duration

			if var_20_0 == 0 then
				return 0
			end

			return arg_20_0.start_time == nil and 0 or math.min(1, (arg_20_2 - arg_20_0.start_time) / var_20_0)
		end,
		can_interact = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			local var_21_0 = ScriptUnit.extension(arg_21_1, "interactable_system"):is_being_interacted_with()

			if var_21_0 and var_21_0 ~= arg_21_0 then
				return false
			end

			local var_21_1 = ScriptUnit.extension(arg_21_1, "status_system")
			local var_21_2 = var_21_1:is_grabbed_by_pack_master()
			local var_21_3 = var_21_1:get_is_ledge_hanging()
			local var_21_4 = var_21_1:is_hanging_from_hook()

			return not var_21_1:is_pounced_down() and not var_21_2 and not var_21_3 and not var_21_4 and var_21_1:is_knocked_down() and HEALTH_ALIVE[arg_21_1]
		end,
		hud_description = function(arg_22_0, arg_22_1, arg_22_2)
			if arg_22_0 and Unit.alive(arg_22_0) then
				local var_22_0 = Managers.player
				local var_22_1 = Managers.state.network.profile_synchronizer
				local var_22_2 = ""
				local var_22_3 = var_22_0:owner(arg_22_0)

				if var_22_3 then
					local var_22_4 = var_22_3:network_id()
					local var_22_5 = var_22_3:local_player_id()
					local var_22_6 = var_22_1:profile_by_peer(var_22_4, var_22_5)

					var_22_2 = SPProfiles[var_22_6].ingame_display_name
				end

				local var_22_7 = Managers.time:time("game")
				local var_22_8 = arg_22_2.duration and arg_22_1.start_time == nil and 0 or math.min(1, (var_22_7 - arg_22_1.start_time) / arg_22_2.duration)
				local var_22_9 = var_22_8 and var_22_8 > 0 and "interaction_action_reviving" or "interaction_action_revive"

				return var_22_2, var_22_9
			end
		end
	}
}
InteractionDefinitions.pull_up = {
	config = {
		block_other_interactions = true,
		hud_verb = "pull up",
		hold = true,
		swap_to_3p = true,
		activate_block = true,
		duration = 2,
		does_not_require_line_of_sight = true
	},
	server = {
		start = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
			arg_23_3.done_time = arg_23_5 + arg_23_4.duration
		end,
		update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			if ScriptUnit.extension(arg_24_1, "status_system"):get_is_ledge_hanging() or not HEALTH_ALIVE[arg_24_1] then
				return InteractionResult.FAILURE
			end

			if arg_24_6 > arg_24_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
			if arg_25_6 == InteractionResult.SUCCESS then
				StatusUtils.set_pulled_up_network(arg_25_2, true, Unit.alive(arg_25_1) and arg_25_1 or nil)
			end
		end,
		can_interact = function(arg_26_0, arg_26_1)
			local var_26_0 = ScriptUnit.extension(arg_26_1, "status_system")
			local var_26_1 = var_26_0:get_is_ledge_hanging()
			local var_26_2 = var_26_0:is_pulled_up()
			local var_26_3 = ScriptUnit.extension(arg_26_1, "buff_system"):has_buff_perk("ledge_self_rescue")

			return var_26_1 and not var_26_2 and not var_26_3
		end
	},
	client = {
		start = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
			arg_27_3.start_time = arg_27_5

			local var_27_0 = Unit.animation_find_variable(arg_27_1, "interaction_duration")

			Unit.animation_set_variable(arg_27_1, var_27_0, arg_27_4.duration)
			Unit.animation_event(arg_27_1, "interaction_revive")

			if Unit.alive(arg_27_2) then
				local var_27_1 = Unit.animation_find_variable(arg_27_2, "revive_time")

				Unit.animation_set_variable(arg_27_2, var_27_1, arg_27_4.duration)
				Unit.animation_event(arg_27_2, "revive_start")

				if ScriptUnit.has_extension(arg_27_2, "first_person_system") then
					ScriptUnit.extension(arg_27_2, "first_person_system"):set_wanted_player_height("stand", arg_27_5, arg_27_4.duration)
				end

				local var_27_2 = ScriptUnit.extension_input(arg_27_1, "dialogue_system")
				local var_27_3 = FrameTable.alloc_table()

				var_27_3.target = arg_27_2
				var_27_3.target_name = ScriptUnit.extension(arg_27_2, "dialogue_system").context.player_profile

				var_27_2:trigger_dialogue_event("start_revive", var_27_3)
			end
		end,
		update = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
			return
		end,
		stop = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
			arg_29_3.start_time = nil

			Unit.animation_event(arg_29_1, "interaction_end")

			if arg_29_6 == InteractionResult.SUCCESS then
				if Unit.alive(arg_29_2) then
					StatisticsUtil.register_pull_up(arg_29_1, arg_29_2, arg_29_3.statistics_db)
					Unit.animation_event(arg_29_2, "revive_complete")
				end
			elseif Unit.alive(arg_29_2) then
				Unit.animation_event(arg_29_2, "revive_abort")

				if ScriptUnit.has_extension(arg_29_2, "first_person_system") then
					ScriptUnit.extension(arg_29_2, "first_person_system"):set_wanted_player_height("knocked_down", arg_29_5)
				end
			end
		end,
		get_progress = function(arg_30_0, arg_30_1, arg_30_2)
			if arg_30_1.duration == 0 then
				return 0
			end

			return arg_30_0.start_time == nil and 0 or math.min(1, (arg_30_2 - arg_30_0.start_time) / arg_30_1.duration)
		end,
		can_interact = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			local var_31_0 = ScriptUnit.extension(arg_31_1, "status_system")
			local var_31_1 = ScriptUnit.extension(arg_31_1, "buff_system"):has_buff_perk("ledge_self_rescue")

			return var_31_0:get_is_ledge_hanging() and not var_31_0:is_pulled_up() and not var_31_1
		end,
		hud_description = function(arg_32_0, arg_32_1, arg_32_2)
			if arg_32_0 and Unit.alive(arg_32_0) then
				local var_32_0 = Managers.player
				local var_32_1 = Managers.state.network.profile_synchronizer
				local var_32_2 = ""
				local var_32_3 = var_32_0:owner(arg_32_0)

				if var_32_3 then
					local var_32_4 = var_32_3:network_id()
					local var_32_5 = var_32_3:local_player_id()
					local var_32_6 = var_32_1:profile_by_peer(var_32_4, var_32_5)

					var_32_2 = SPProfiles[var_32_6].ingame_display_name
				end

				return var_32_2, "interaction_action_pull_up"
			end
		end
	}
}
InteractionDefinitions.release_from_hook = {
	config = {
		block_other_interactions = true,
		hud_verb = "player_interaction",
		hold = true,
		swap_to_3p = true,
		activate_block = true,
		duration = 2
	},
	server = {
		start = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
			arg_33_3.done_time = arg_33_5 + arg_33_4.duration
		end,
		update = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
			if arg_34_6 > arg_34_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6)
			if arg_35_6 == InteractionResult.SUCCESS then
				StatusUtils.set_grabbed_by_pack_master_network("pack_master_dropping", arg_35_2, true, nil)
				QuestSettings.check_pack_master_rescue_hoisted_ally(arg_35_1)
			end
		end,
		can_interact = function(arg_36_0, arg_36_1)
			local var_36_0 = ScriptUnit.extension(arg_36_1, "status_system"):is_hanging_from_hook()
			local var_36_1 = HEALTH_ALIVE[arg_36_1]

			return var_36_0 and var_36_1
		end
	},
	client = {
		start = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
			arg_37_3.start_time = arg_37_5

			local var_37_0 = Unit.animation_find_variable(arg_37_1, "interaction_duration")

			Unit.animation_set_variable(arg_37_1, var_37_0, arg_37_4.duration)
			Unit.animation_event(arg_37_1, "interaction_generic")

			local var_37_1 = ScriptUnit.extension_input(arg_37_1, "dialogue_system")
			local var_37_2 = FrameTable.alloc_table()

			var_37_2.target = arg_37_2
			var_37_2.target_name = ScriptUnit.extension(arg_37_2, "dialogue_system").context.player_profile

			var_37_1:trigger_dialogue_event("start_revive", var_37_2)
		end,
		update = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6)
			return
		end,
		stop = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
			arg_39_3.start_time = nil

			Unit.animation_event(arg_39_1, "interaction_end")
		end,
		get_progress = function(arg_40_0, arg_40_1, arg_40_2)
			if arg_40_1.duration == 0 then
				return 0
			end

			return arg_40_0.start_time == nil and 0 or math.min(1, (arg_40_2 - arg_40_0.start_time) / arg_40_1.duration)
		end,
		can_interact = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
			local var_41_0 = ScriptUnit.extension(arg_41_1, "status_system"):is_hanging_from_hook()
			local var_41_1 = HEALTH_ALIVE[arg_41_1]

			return var_41_0 and var_41_1
		end,
		hud_description = function(arg_42_0, arg_42_1, arg_42_2)
			if arg_42_0 and Unit.alive(arg_42_0) then
				local var_42_0 = Managers.player
				local var_42_1 = Managers.state.network.profile_synchronizer
				local var_42_2 = ""
				local var_42_3 = var_42_0:owner(arg_42_0)

				if var_42_3 then
					local var_42_4 = var_42_3:network_id()
					local var_42_5 = var_42_3:local_player_id()
					local var_42_6 = var_42_1:profile_by_peer(var_42_4, var_42_5)

					var_42_2 = SPProfiles[var_42_6].ingame_display_name
				end

				return var_42_2, "interact_release_from_hook"
			end
		end
	}
}
InteractionDefinitions.assisted_respawn = {
	config = {
		block_other_interactions = true,
		hud_verb = "assist respawn",
		hold = true,
		swap_to_3p = true,
		activate_block = true,
		duration = 2
	},
	server = {
		start = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
			arg_43_3.done_time = arg_43_5 + arg_43_4.duration
		end,
		update = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5, arg_44_6)
			if arg_44_6 > arg_44_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
			if arg_45_6 == InteractionResult.SUCCESS then
				StatusUtils.set_respawned_network(arg_45_2, true, arg_45_1)
			end
		end,
		can_interact = function(arg_46_0, arg_46_1)
			return (ScriptUnit.extension(arg_46_1, "status_system"):is_ready_for_assisted_respawn())
		end
	},
	client = {
		start = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5)
			arg_47_3.start_time = arg_47_5

			local var_47_0 = arg_47_4.duration
			local var_47_1 = Unit.animation_find_variable(arg_47_2, "revive_time")

			Unit.animation_set_variable(arg_47_2, var_47_1, var_47_0)
			Unit.animation_event(arg_47_2, "revive_start")

			local var_47_2 = Unit.animation_find_variable(arg_47_1, "interaction_duration")

			Unit.animation_set_variable(arg_47_1, var_47_2, arg_47_4.duration)
			Unit.animation_event(arg_47_1, "interaction_revive")
		end,
		update = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5, arg_48_6)
			return
		end,
		stop = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6)
			arg_49_3.start_time = nil

			Unit.animation_event(arg_49_1, "interaction_end")

			if arg_49_6 == InteractionResult.SUCCESS then
				Unit.animation_event(arg_49_2, "revive_complete")
				StatisticsUtil.register_assisted_respawn(arg_49_1, arg_49_2, arg_49_3.statistics_db)
			else
				Unit.animation_event(arg_49_2, "revive_abort")
			end
		end,
		get_progress = function(arg_50_0, arg_50_1, arg_50_2)
			if arg_50_1.duration == 0 then
				return 0
			end

			return arg_50_0.start_time == nil and 0 or math.min(1, (arg_50_2 - arg_50_0.start_time) / arg_50_1.duration)
		end,
		can_interact = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
			return (ScriptUnit.extension(arg_51_1, "status_system"):is_ready_for_assisted_respawn())
		end,
		hud_description = function(arg_52_0, arg_52_1, arg_52_2)
			if arg_52_0 and Unit.alive(arg_52_0) then
				local var_52_0 = Managers.player
				local var_52_1 = Managers.state.network.profile_synchronizer
				local var_52_2 = ""
				local var_52_3 = var_52_0:owner(arg_52_0)

				if var_52_3 then
					local var_52_4 = var_52_3:network_id()
					local var_52_5 = var_52_3:local_player_id()
					local var_52_6 = var_52_1:profile_by_peer(var_52_4, var_52_5)

					var_52_2 = SPProfiles[var_52_6].ingame_display_name
				end

				return var_52_2, "interaction_action_assisted_respawn"
			end
		end
	}
}

local var_0_1 = 1

InteractionDefinitions.smartobject = {
	config = {
		show_weapons = true,
		hold = true,
		swap_to_3p = false
	},
	server = {
		start = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
			local var_53_0 = Unit.get_data(arg_53_2, "interaction_data", "interaction_length")

			fassert(var_53_0, "Interacting with %q that has no interaction length", arg_53_2)

			local var_53_1 = Unit.get_data(arg_53_2, "interaction_data", "stored_interaction_progress") or 0

			arg_53_3.done_time = arg_53_5 + var_53_0 - var_53_1
			arg_53_3.duration = var_53_0

			local var_53_2 = Unit.get_data(arg_53_2, "interaction_data", "apply_buff")

			if var_53_2 then
				arg_53_3.apply_buff = var_53_2
			end

			local var_53_3 = Unit.world_position(arg_53_1, 0) - Unit.world_position(arg_53_2, 0)

			arg_53_3.start_offset = Vector3Box(var_53_3)
		end,
		update = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6)
			if ScriptUnit.extension(arg_54_1, "status_system"):is_knocked_down() or not HEALTH_ALIVE[arg_54_1] then
				return InteractionResult.FAILURE
			end

			local var_54_0 = Unit.world_position(arg_54_1, 0) - Unit.world_position(arg_54_2, 0)
			local var_54_1 = arg_54_3.start_offset:unbox()

			if Vector3.distance_squared(var_54_1, var_54_0) > var_0_1 then
				return InteractionResult.FAILURE
			end

			if arg_54_6 > arg_54_3.done_time then
				if arg_54_3.apply_buff then
					Managers.state.entity:system("buff_system"):add_buff(arg_54_1, arg_54_3.apply_buff, arg_54_2, false)
				end

				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6)
			if arg_55_6 == InteractionResult.SUCCESS then
				local var_55_0 = ScriptUnit.extension(arg_55_2, "interactable_system")

				var_55_0.num_times_successfully_completed = var_55_0.num_times_successfully_completed + 1
			end
		end,
		can_interact = function(arg_56_0, arg_56_1)
			local var_56_0 = Unit.get_data(arg_56_1, "interaction_data", "custom_interaction_check_name")

			if var_56_0 and InteractionCustomChecks[var_56_0] and not InteractionCustomChecks[var_56_0](arg_56_0, arg_56_1) then
				return false
			end

			return not Unit.get_data(arg_56_1, "interaction_data", "used")
		end
	},
	client = {
		start = function(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5)
			arg_57_3.start_time = arg_57_5

			local var_57_0 = Unit.get_data(arg_57_2, "interaction_data", "interaction_length")

			arg_57_3.duration = var_57_0
			arg_57_3.stored_progress = Unit.get_data(arg_57_2, "interaction_data", "stored_interaction_progress") or 0

			local var_57_1 = Unit.get_data(arg_57_2, "interaction_data", "interactor_animation")
			local var_57_2 = Unit.get_data(arg_57_2, "interaction_data", "interactor_animation_time_variable")
			local var_57_3 = ScriptUnit.extension(arg_57_1, "inventory_system")
			local var_57_4 = ScriptUnit.extension(arg_57_1, "career_system")

			if var_57_1 then
				local var_57_5 = Unit.animation_find_variable(arg_57_1, var_57_2)

				Unit.animation_set_variable(arg_57_1, var_57_5, var_57_0)
				Unit.animation_event(arg_57_1, var_57_1)
			end

			local var_57_6 = Unit.get_data(arg_57_2, "interaction_data", "interactable_animation")
			local var_57_7 = Unit.get_data(arg_57_2, "interaction_data", "interactable_animation_time_variable")

			if var_57_6 then
				local var_57_8 = Unit.animation_find_variable(arg_57_2, var_57_7)

				Unit.animation_set_variable(arg_57_2, var_57_8, var_57_0)
				Unit.animation_event(arg_57_2, var_57_6)
			end

			CharacterStateHelper.stop_weapon_actions(var_57_3, "interacting")
			CharacterStateHelper.stop_career_abilities(var_57_4, "interacting")
			Unit.set_data(arg_57_2, "interaction_data", "being_used", true)
		end,
		update = function(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5, arg_58_6)
			return
		end,
		stop = function(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6)
			if Unit.get_data(arg_59_2, "interaction_data", "resumable") then
				local var_59_0 = arg_59_3.stored_progress or 0
				local var_59_1 = arg_59_6 == InteractionResult.SUCCESS and 0 or var_59_0 + math.max(0, arg_59_5 - arg_59_3.start_time)

				Unit.set_data(arg_59_2, "interaction_data", "stored_interaction_progress", var_59_1)
			end

			arg_59_3.start_time = nil

			if Unit.has_animation_event(arg_59_1, "interaction_end") then
				Unit.animation_event(arg_59_1, "interaction_end")
			end

			if arg_59_6 == InteractionResult.SUCCESS and Unit.get_data(arg_59_2, "interaction_data", "only_once") then
				Unit.set_data(arg_59_2, "interaction_data", "used", true)
			end

			Unit.set_data(arg_59_2, "interaction_data", "being_used", false)
		end,
		get_progress = function(arg_60_0, arg_60_1, arg_60_2)
			if arg_60_0.duration == 0 or arg_60_0.start_time == nil then
				return 0
			end

			local var_60_0 = arg_60_0.stored_progress or 0

			return math.clamp((arg_60_2 + var_60_0 - arg_60_0.start_time) / arg_60_0.duration, 0, 1)
		end,
		can_interact = function(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
			local var_61_0 = Unit.get_data(arg_61_1, "interaction_data", "custom_interaction_check_name")

			if var_61_0 and InteractionCustomChecks[var_61_0] and not InteractionCustomChecks[var_61_0](arg_61_0, arg_61_1) then
				return false
			end

			local var_61_1 = Unit.get_data(arg_61_1, "interaction_data", "used")
			local var_61_2 = Unit.get_data(arg_61_1, "interaction_data", "being_used")

			return not var_61_1 and not var_61_2
		end,
		hud_description = function(arg_62_0, arg_62_1, arg_62_2)
			return Unit.get_data(arg_62_0, "interaction_data", "hud_description"), Unit.get_data(arg_62_0, "interaction_data", "hud_interaction_action")
		end
	}
}
InteractionDefinitions.control_panel = InteractionDefinitions.control_panel or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.control_panel.config.swap_to_3p = true
InteractionDefinitions.control_panel.config.show_weapons = false

local function var_0_2(arg_63_0)
	local var_63_0 = arg_63_0:get_slot_data("slot_potion")

	if not var_63_0 then
		return false
	end

	if arg_63_0:get_item_template(var_63_0).is_grimoire then
		return true
	end

	local var_63_1 = arg_63_0:get_additional_items("slot_potion")

	if var_63_1 then
		for iter_63_0 = 1, #var_63_1 do
			local var_63_2 = var_63_1[iter_63_0]

			if BackendUtils.get_item_template(var_63_2).is_grimoire then
				return true
			end
		end
	end

	return false
end

local function var_0_3(arg_64_0)
	return function(arg_65_0)
		return arg_64_0 ~= arg_65_0.name
	end
end

local function var_0_4(arg_66_0)
	local var_66_0 = BackendUtils.get_item_template(arg_66_0).pickup_data

	if var_66_0 then
		local var_66_1 = var_66_0.pickup_name

		if var_66_1 then
			return var_66_1
		end
	end
end

InteractionDefinitions.pickup_object = {
	config = {
		allow_movement = true,
		duration = 0,
		hold = true,
		swap_to_3p = false
	},
	server = {
		start = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
			arg_67_3.done_time = arg_67_5 + Unit.get_data(arg_67_2, "interaction_data", "interaction_length")
		end,
		update = function(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5, arg_68_6)
			if ScriptUnit.extension(arg_68_1, "status_system"):is_knocked_down() or not HEALTH_ALIVE[arg_68_1] then
				return InteractionResult.FAILURE
			end

			local var_68_0 = ScriptUnit.has_extension(arg_68_2, "health_system")

			if var_68_0 and var_68_0.exploded then
				return InteractionResult.FAILURE
			end

			if arg_68_6 >= arg_68_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5, arg_69_6)
			if arg_69_6 == InteractionResult.SUCCESS then
				if Unit.get_data(arg_69_2, "interaction_data", "only_once") and ScriptUnit.has_extension(arg_69_2, "limited_item_track_system") then
					ScriptUnit.extension(arg_69_2, "limited_item_track_system"):mark_for_transformation()
				end

				Managers.state.entity:system("pickup_system"):mark_for_consumption(arg_69_2, arg_69_1)

				local var_69_0 = ScriptUnit.extension(arg_69_1, "buff_system")
				local var_69_1 = ScriptUnit.extension(arg_69_2, "pickup_system"):get_pickup_settings()

				if var_69_1.consumable_item then
					var_69_0:trigger_procs("on_consumable_picked_up", arg_69_2, var_69_1)

					local var_69_2 = Managers.state.side.side_by_unit[arg_69_1].PLAYER_AND_BOT_UNITS
					local var_69_3 = #var_69_2

					if var_69_1.ranger_ammo then
						if not DEDICATED_SERVER then
							local var_69_4 = Managers.player:local_player().player_unit
							local var_69_5 = ScriptUnit.has_extension(var_69_4, "buff_system")

							if var_69_5 then
								var_69_5:trigger_procs("on_bardin_consumable_picked_up_any_player")
							end
						end

						for iter_69_0 = 1, var_69_3 do
							local var_69_6 = var_69_2[iter_69_0]

							if Unit.alive(var_69_6) then
								local var_69_7 = Managers.player:owner(var_69_6)

								if not LEVEL_EDITOR_TEST then
									local var_69_8 = var_69_7:network_id()
									local var_69_9 = var_69_7:local_player_id()
									local var_69_10 = NetworkLookup.proc_events.on_bardin_consumable_picked_up_any_player

									Managers.state.network.network_transmit:send_rpc_clients("rpc_proc_event", var_69_8, var_69_9, var_69_10)
								end
							end
						end
					end
				end
			end
		end,
		can_interact = function(arg_70_0, arg_70_1)
			return not Managers.state.entity:system("pickup_system"):marked_for_consumption(arg_70_1)
		end
	},
	client = {
		start = function(arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4, arg_71_5)
			local var_71_0 = Unit.get_data(arg_71_2, "interaction_data", "interaction_length")

			arg_71_3.duration = var_71_0

			fassert(var_71_0, "Interacting with %q that has no interaction length", arg_71_2)
		end,
		update = function(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6)
			return
		end,
		stop = function(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6)
			arg_73_3.start_time = nil

			Unit.animation_event(arg_73_1, "interaction_end")

			if arg_73_6 == InteractionResult.SUCCESS then
				local var_73_0 = arg_73_3.is_husk or false

				if Unit.get_data(arg_73_2, "interaction_data", "only_once") and not var_73_0 then
					Unit.set_data(arg_73_2, "interaction_data", "used", true)
				end

				local var_73_1 = Managers.player:owner(arg_73_1)
				local var_73_2 = var_73_1.local_player
				local var_73_3 = var_73_1:is_player_controlled()
				local var_73_4 = Managers.state.network
				local var_73_5 = ScriptUnit.extension(arg_73_1, "inventory_system")
				local var_73_6 = ScriptUnit.extension(arg_73_1, "career_system")
				local var_73_7 = ScriptUnit.extension(arg_73_2, "pickup_system")
				local var_73_8 = var_73_7:get_pickup_settings()
				local var_73_9 = var_73_1.peer_id
				local var_73_10

				if IS_WINDOWS then
					var_73_10 = var_73_3 and (rawget(_G, "Steam") and Steam.user_name(var_73_9) or tostring(var_73_9)) or var_73_1:name()
				elseif Managers.account:is_online() then
					local var_73_11 = Managers.state.network:lobby()

					var_73_10 = var_73_3 and var_73_11:user_name(var_73_9) or var_73_1:name()
				else
					var_73_10 = var_73_1:name()
				end

				local var_73_12 = true

				if var_73_8.type == "loot_die" then
					Managers.state.event:trigger("add_coop_feedback", var_73_1:stats_id(), var_73_2, "picked_up_loot_dice", var_73_1)

					local var_73_13 = string.format(Localize("system_chat_player_picked_up_loot_die"), var_73_10)

					Managers.chat:add_local_system_message(1, var_73_13, var_73_12)
				elseif var_73_8.type == "painting_scrap" then
					Managers.state.event:trigger("add_coop_feedback", var_73_1:stats_id(), var_73_2, "picked_up_painting_scrap", var_73_1)

					local var_73_14 = string.format(Localize("system_chat_player_picked_up_painting_chat"), var_73_10)

					Managers.chat:add_local_system_message(1, var_73_14, var_73_12)
				elseif var_73_8.type == "inventory_item" then
					local var_73_15 = var_73_8.slot_name
					local var_73_16 = var_73_8.item_name
					local var_73_17 = var_73_5:get_slot_data(var_73_15)
					local var_73_18 = ItemMasterList[var_73_16]

					if not var_73_17 or var_73_17.item_data.name ~= var_73_18.name then
						if var_73_16 == "wpn_side_objective_tome_01" then
							Managers.state.event:trigger("add_coop_feedback", var_73_1:stats_id(), var_73_2, "picked_up_tome", var_73_1)
							Managers.state.event:trigger("player_pickup_tome", var_73_1)

							local var_73_19 = string.format(Localize("system_chat_player_picked_up_tome"), var_73_10)

							Managers.chat:add_local_system_message(1, var_73_19, var_73_12)
						elseif var_73_16 == "wpn_grimoire_01" then
							Managers.state.event:trigger("add_coop_feedback", var_73_1:stats_id(), var_73_2, "picked_up_grimoire", var_73_1)
							Managers.state.event:trigger("player_pickup_grimoire", var_73_1)

							local var_73_20 = string.format(Localize("system_chat_player_picked_up_grimoire"), var_73_10)

							Managers.chat:add_local_system_message(1, var_73_20, var_73_12)
						end
					end

					if var_73_17 then
						local var_73_21 = var_73_17.item_data
						local var_73_22 = BackendUtils.get_item_template(var_73_21)

						if var_73_16 ~= "wpn_side_objective_tome_01" and var_73_22.name == "wpn_side_objective_tome_01" then
							local var_73_23 = not var_73_1.remote and not var_73_1.bot_player

							Managers.state.event:trigger("add_coop_feedback", var_73_1:stats_id(), var_73_23, "discarded_tome", var_73_1)

							local var_73_24 = string.format(Localize("system_chat_player_discarded_tome"), var_73_10)

							Managers.chat:add_local_system_message(1, var_73_24, var_73_12)
						elseif var_73_16 ~= "wpn_grimoire_01" and var_73_22.name == "wpn_grimoire_01" then
							local var_73_25 = not var_73_1.remote and not var_73_1.bot_player

							Managers.state.event:trigger("add_coop_feedback", var_73_1:stats_id(), var_73_25, "discarded_grimoire", var_73_1)

							local var_73_26 = string.format(Localize("system_chat_player_discarded_grimoire"), var_73_10)

							Managers.chat:add_local_system_message(1, var_73_26, var_73_12)
						end
					end
				end

				local var_73_27 = var_73_8.on_pick_up_func

				if var_73_27 then
					local var_73_28 = arg_73_3.is_server

					var_73_27(arg_73_0, arg_73_1, var_73_28, arg_73_2, var_73_0)
				end

				local var_73_29 = not var_73_1.remote
				local var_73_30 = var_73_8.local_pickup_sound

				if (var_73_30 and var_73_29 or not var_73_30) and not var_73_1.bot_player then
					local var_73_31 = var_73_8.pickup_sound_event_func
					local var_73_32 = var_73_31 and var_73_31(arg_73_1, arg_73_2, arg_73_3) or var_73_8.pickup_sound_event

					if var_73_32 then
						local var_73_33 = Managers.world:wwise_world(arg_73_0)

						WwiseWorld.trigger_event(var_73_33, var_73_32)
					end
				end

				if arg_73_3.is_server then
					local var_73_34 = Unit.get_data(arg_73_2, "interaction_data", "item_name")
					local var_73_35 = ScriptUnit.extension_input(arg_73_1, "dialogue_system")
					local var_73_36 = FrameTable.alloc_table()

					var_73_36.pickup_name = var_73_34

					var_73_35:trigger_dialogue_event("on_pickup", var_73_36)

					local var_73_37 = ScriptUnit.extension(arg_73_1, "dialogue_system").context.player_profile

					SurroundingAwareSystem.add_event(arg_73_1, "on_other_pickup", DialogueSettings.default_view_distance, "pickup_name", var_73_34, "target_name", var_73_37)
				end

				if var_73_29 then
					local var_73_38 = ScriptUnit.extension(arg_73_1, "buff_system")

					if var_73_8.consumable_item and not arg_73_3.is_server then
						var_73_38:trigger_procs("on_consumable_picked_up", arg_73_2, var_73_8)
					end

					local var_73_39 = arg_73_3.statistics_db
					local var_73_40 = var_73_7.pickup_name
					local var_73_41 = var_73_7.spawn_type
					local var_73_42 = POSITION_LOOKUP[arg_73_2]

					Managers.telemetry_events:player_pickup(var_73_1, var_73_40, var_73_41, var_73_42)

					local var_73_43 = var_73_8.lorebook_page_name

					if var_73_43 then
						local var_73_44 = LorebookPageLookup[var_73_43]

						StatisticsUtil.unlock_lorebook_page(var_73_44, var_73_39)
					end

					if var_73_8.hide_on_pickup then
						var_73_7:hide()
					end

					if var_73_8.mission_name then
						local var_73_45 = var_73_8.mission_name
						local var_73_46 = NetworkLookup.mission_names[var_73_45]
						local var_73_47 = var_73_4.network_transmit

						var_73_47:send_rpc_server("rpc_request_mission", var_73_46, false)
						var_73_47:send_rpc_server("rpc_request_mission_update", var_73_46, true)
					end

					local var_73_48 = true
					local var_73_49

					if var_73_8.type == "inventory_item" then
						local var_73_50 = var_73_8.slot_name
						local var_73_51 = var_73_8.item_name
						local var_73_52 = Unit.local_rotation(arg_73_2, 0)
						local var_73_53
						local var_73_54 = {}
						local var_73_55 = ScriptUnit.has_extension(arg_73_2, "limited_item_track_system")

						if var_73_55 then
							local var_73_56 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
							local var_73_57 = var_73_56.id
							local var_73_58 = var_73_56.spawner_unit

							var_73_53 = "weapon_unit_ammo_limited"
							var_73_54.limited_item_track_system = {
								spawner_unit = var_73_58,
								id = var_73_57
							}
						end

						local var_73_59 = var_73_5:get_slot_data(var_73_50)
						local var_73_60 = var_73_59 and var_73_59.item_data
						local var_73_61 = var_73_60 and var_73_60.dont_unwield_on_pickup
						local var_73_62 = var_73_5:get_wielded_slot_name()
						local var_73_63 = not var_73_61 and (var_73_8.wield_on_pickup or var_73_62 == var_73_50)
						local var_73_64 = var_73_5:can_store_additional_item(var_73_50)
						local var_73_65 = ItemMasterList[var_73_51]

						if var_73_63 then
							CharacterStateHelper.stop_weapon_actions(var_73_5, "picked_up_object")
							CharacterStateHelper.stop_career_abilities(var_73_6, "picked_up_object")
						end

						local var_73_66 = false

						if var_73_60 and not var_73_64 then
							local var_73_67, var_73_68, var_73_69 = var_73_5:has_droppable_item(var_73_50, var_0_3(var_73_51))

							if var_73_67 then
								var_73_49 = var_0_4(var_73_69)

								if var_73_68 then
									if var_73_63 then
										var_73_5:swap_equipment_from_storage(var_73_50, SwapFromStorageType.Same, var_73_69)
										var_73_5:destroy_slot(var_73_50)
										var_73_5:add_equipment(var_73_50, var_73_65, var_73_53, var_73_54)

										var_73_66 = true
									else
										var_73_5:remove_additional_item(var_73_50, var_73_69)
										var_73_5:store_additional_item(var_73_50, var_73_65)
									end
								else
									var_73_5:destroy_slot(var_73_50)
									var_73_5:add_equipment(var_73_50, var_73_65, var_73_53, var_73_54)

									var_73_66 = true
								end
							else
								var_73_48 = false
							end
						elseif var_73_60 then
							if var_73_63 then
								var_73_5:store_additional_item(var_73_50, var_73_60)
								var_73_5:destroy_slot(var_73_50)
								var_73_5:add_equipment(var_73_50, var_73_65, var_73_53, var_73_54)

								var_73_66 = true
							else
								var_73_5:store_additional_item(var_73_50, var_73_65)
							end
						else
							var_73_5:add_equipment(var_73_50, var_73_65, var_73_53, var_73_54)

							var_73_66 = true
						end

						if not LEVEL_EDITOR_TEST and var_73_66 then
							local var_73_70 = Managers.state.unit_storage:go_id(arg_73_1)
							local var_73_71 = NetworkLookup.equipment_slots[var_73_50]
							local var_73_72 = NetworkLookup.item_names[var_73_51]
							local var_73_73 = NetworkLookup.weapon_skins["n/a"]

							if var_73_55 then
								local var_73_74 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
								local var_73_75 = var_73_74.id
								local var_73_76 = var_73_74.spawner_unit
								local var_73_77 = var_73_76 and Managers.state.network:level_object_id(var_73_76) or NetworkConstants.invalid_game_object_id

								if arg_73_3.is_server then
									var_73_4.network_transmit:send_rpc_clients("rpc_add_equipment_limited_item", var_73_70, var_73_71, var_73_72, var_73_77, var_73_75)
								else
									var_73_4.network_transmit:send_rpc_server("rpc_add_equipment_limited_item", var_73_70, var_73_71, var_73_72, var_73_77, var_73_75)
								end
							elseif arg_73_3.is_server then
								var_73_4.network_transmit:send_rpc_clients("rpc_add_equipment", var_73_70, var_73_71, var_73_72, var_73_73)
							else
								var_73_4.network_transmit:send_rpc_server("rpc_add_equipment", var_73_70, var_73_71, var_73_72, var_73_73)
							end
						end

						if var_73_63 then
							local var_73_78 = var_73_8.action_on_wield

							if var_73_78 then
								BackendUtils.get_item_template(var_73_65).next_action = var_73_78
							end

							var_73_5:wield(var_73_50)
						end
					elseif var_73_8.type == "explosive_inventory_item" then
						local var_73_79 = var_73_8.slot_name
						local var_73_80 = var_73_8.item_name
						local var_73_81 = ScriptUnit.extension(arg_73_2, "health_system")
						local var_73_82 = ScriptUnit.extension(arg_73_2, "death_system")
						local var_73_83 = ScriptUnit.extension(arg_73_2, "tutorial_system")
						local var_73_84 = "explosive_weapon_unit_ammo"
						local var_73_85 = {
							health_system = {
								in_hand = true,
								owner_unit = arg_73_1,
								ignored_damage_types = {
									temporary_health_degen = true,
									kinetic = true,
									damage_over_time = true,
									buff = true,
									vomit_face = true,
									life_tap = true,
									health_degen = true,
									vomit_ground = true,
									wounded_dot = true,
									heal = true
								},
								health = var_73_81.health,
								damage = var_73_81.damage,
								item_name = var_73_80
							},
							death_system = {
								death_reaction_template = var_73_82.death_reaction_template
							},
							tutorial_system = {
								always_show = var_73_83.always_show,
								proxy_active = var_73_83.active
							}
						}

						if var_73_81.ignited then
							var_73_85.health_system.health_data = var_73_81:health_data()
						end

						local var_73_86 = ScriptUnit.has_extension(arg_73_2, "limited_item_track_system")

						if var_73_86 then
							local var_73_87 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
							local var_73_88 = var_73_87.id
							local var_73_89 = var_73_87.spawner_unit

							var_73_84 = "explosive_weapon_unit_ammo_limited"
							var_73_85.limited_item_track_system = {
								spawner_unit = var_73_89,
								id = var_73_88
							}
						end

						local var_73_90 = ItemMasterList[var_73_80]

						var_73_5:add_equipment(var_73_79, var_73_90, var_73_84, var_73_85)

						if not LEVEL_EDITOR_TEST then
							local var_73_91 = Managers.state.unit_storage:go_id(arg_73_1)
							local var_73_92 = NetworkLookup.equipment_slots[var_73_79]
							local var_73_93 = NetworkLookup.item_names[var_73_80]
							local var_73_94 = NetworkLookup.weapon_skins["n/a"]

							if arg_73_3.is_server then
								if var_73_86 then
									local var_73_95 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
									local var_73_96 = var_73_95.id
									local var_73_97 = var_73_95.spawner_unit
									local var_73_98 = var_73_97 and Managers.state.network:level_object_id(var_73_97) or NetworkConstants.invalid_game_object_id

									var_73_4.network_transmit:send_rpc_clients("rpc_add_equipment_limited_item", var_73_91, var_73_92, var_73_93, var_73_98, var_73_96)
								else
									var_73_4.network_transmit:send_rpc_clients("rpc_add_equipment", var_73_91, var_73_92, var_73_93, var_73_94)
								end
							elseif var_73_86 then
								local var_73_99 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
								local var_73_100 = var_73_99.id
								local var_73_101 = var_73_99.spawner_unit
								local var_73_102 = var_73_101 and Managers.state.network:level_object_id(var_73_101) or NetworkConstants.invalid_game_object_id

								var_73_4.network_transmit:send_rpc_server("rpc_add_equipment_limited_item", var_73_91, var_73_92, var_73_93, var_73_102, var_73_100)
							else
								var_73_4.network_transmit:send_rpc_server("rpc_add_equipment", var_73_91, var_73_92, var_73_93, var_73_94)
							end
						end

						if var_73_8.wield_on_pickup then
							CharacterStateHelper.stop_weapon_actions(var_73_5, "picked_up_object")
							CharacterStateHelper.stop_career_abilities(var_73_6, "picked_up_object")
							var_73_5:wield(var_73_79)
						end
					elseif var_73_8.type == "ammo" then
						if var_73_2 then
							ScriptUnit.extension(arg_73_1, "hud_system"):set_picked_up_ammo(true)
						end

						var_73_5:add_ammo_from_pickup(var_73_8)
					elseif var_73_8.type == "lorebook_page" then
						local var_73_103 = Managers.state.game_mode:level_key()
						local var_73_104 = table.clone(LorebookCollectablePages[var_73_103])

						table.shuffle(var_73_104)

						local var_73_105 = #var_73_104
						local var_73_106 = Managers.player:local_player():stats_id()

						for iter_73_0 = 1, var_73_105 do
							local var_73_107 = var_73_104[iter_73_0]
							local var_73_108 = LorebookCategoryLookup[var_73_107]

							if not var_73_39:get_persistent_array_stat(var_73_106, "lorebook_unlocks", var_73_108) then
								StatisticsUtil.unlock_lorebook_page(var_73_108, var_73_39)
								Managers.state.event:trigger("add_personal_feedback", var_73_1:stats_id() .. var_73_108, var_73_2, "picked_up_lorebook_page", var_73_107)

								break
							end
						end
					elseif var_73_8.type == "painting_scrap" then
						local var_73_109 = Managers.state.game_mode:level_key()
						local var_73_110 = Managers.player:local_player():stats_id()

						var_73_39:increment_stat(var_73_110, "collected_painting_scraps_unlimited")

						if table.contains(UnlockableLevels, var_73_109) then
							local var_73_111 = "collected_painting_scraps"
							local var_73_112 = var_73_39:get_persistent_stat(var_73_110, var_73_111, var_73_109)
							local var_73_113 = QuestSettings.scrap_count_level[#QuestSettings.scrap_count_level]
							local var_73_114 = var_73_39:get_persistent_stat(var_73_110, var_73_111 .. "_generic")
							local var_73_115 = QuestSettings.scrap_count_generic[#QuestSettings.scrap_count_generic]

							if var_73_112 < var_73_113 then
								var_73_39:increment_stat(var_73_110, var_73_111, var_73_109)
							end

							if var_73_114 < var_73_115 then
								var_73_39:increment_stat(var_73_110, var_73_111 .. "_generic")
							end
						end
					elseif var_73_8.type == "crater_pendant" then
						local var_73_116 = "scorpion"

						if Managers.unlock:is_dlc_unlocked(var_73_116) then
							local var_73_117 = Managers.player:local_player():stats_id()

							var_73_39:set_stat(var_73_117, "scorpion_crater_pendant", 1)
						end
					elseif var_73_8.type == "crater_painting" then
						local var_73_118 = "scorpion"

						if Managers.unlock:is_dlc_unlocked(var_73_118) then
							local var_73_119 = Managers.player:local_player():stats_id()

							var_73_39:set_stat(var_73_119, "scorpion_crater_dark_tongue_3", 1)
						end
					end

					Managers.state.entity:system("pickup_system"):finalize_consumption(arg_73_2, var_73_48, var_73_49)
				end
			end
		end,
		get_progress = function(arg_74_0, arg_74_1, arg_74_2)
			if arg_74_0.duration == 0 then
				return nil
			end

			return arg_74_0.start_time == nil and 0 or math.min(1, (arg_74_2 - arg_74_0.start_time) / arg_74_0.duration)
		end,
		can_interact = function(arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4)
			local var_75_0 = not Unit.get_data(arg_75_1, "interaction_data", "used")
			local var_75_1 = ScriptUnit.extension(arg_75_1, "pickup_system")
			local var_75_2 = var_75_1:get_pickup_settings()
			local var_75_3 = var_75_2.slot_name
			local var_75_4

			if var_75_0 and var_75_1.can_interact then
				var_75_0 = var_75_1:can_interact()
			end

			if var_75_0 and var_75_2.can_interact_func then
				var_75_0 = var_75_2.can_interact_func(arg_75_0, arg_75_1, arg_75_2)
			end

			var_75_0 = var_75_0 and not Managers.state.entity:system("pickup_system"):marked_for_consumption(arg_75_1)

			local var_75_5 = ScriptUnit.extension(arg_75_0, "inventory_system")
			local var_75_6, var_75_7, var_75_8 = CharacterStateHelper.get_item_data_and_weapon_extensions(var_75_5)

			if var_75_0 and var_75_6 then
				local var_75_9, var_75_10, var_75_11 = CharacterStateHelper.get_current_action_data(var_75_8, var_75_7)

				if var_75_9 and var_75_9.block_pickup then
					var_75_0 = false
				end
			end

			if var_75_0 and var_75_3 == "slot_level_event" and var_75_5:get_wielded_slot_name() == "slot_level_event" then
				var_75_0 = false
			end

			local var_75_12 = var_75_3 and var_75_5:get_slot_data(var_75_3)

			if var_75_0 and var_75_3 == "slot_potion" and var_0_2(var_75_5) then
				var_75_4 = "grimoire_equipped"
				var_75_0 = false
			end

			local var_75_13 = var_75_5:can_store_additional_item(var_75_3)
			local var_75_14 = var_75_12 and var_75_12.item_data

			if var_75_0 and var_75_14 and var_75_14.is_not_droppable and not (var_75_13 or var_75_5:has_droppable_item(var_75_3, var_0_3(var_75_2.item_name))) then
				var_75_4 = "not_droppable"
				var_75_0 = false
			end

			if var_75_0 and var_75_14 and not var_75_13 and not var_75_5:has_droppable_item(var_75_3, var_0_3(var_75_2.item_name)) then
				var_75_4 = "already_equipped"
				var_75_0 = false
			end

			if var_75_0 and ScriptUnit.has_extension(arg_75_1, "death_system") then
				local var_75_15 = ScriptUnit.extension(arg_75_1, "death_system").death_reaction_data

				if var_75_15 and var_75_15.exploded then
					var_75_0 = false
				end
			end

			if var_75_0 and var_75_2.type == "ammo" then
				if var_75_5:is_ammo_blocked() then
					var_75_4 = "ammo_blocked"
					var_75_0 = false
				elseif var_75_5:has_ammo_consuming_weapon_equipped("throwing_axe") and var_75_2.pickup_name == "all_ammo" then
					var_75_4 = "throwing_axe"
					var_75_0 = false
				elseif var_75_5:has_full_ammo() then
					var_75_4 = "ammo_full"
					var_75_0 = false
				end
			end

			return var_75_0, var_75_4
		end,
		hud_description = function(arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4)
			local var_76_0 = "no_ammo_for_this_weapon"
			local var_76_1 = false
			local var_76_2 = "interaction_action_pick_up"

			if not Managers.state.unit_spawner:is_marked_for_deletion(arg_76_0) then
				var_76_2 = Unit.get_data(arg_76_0, "interaction_action_description") or var_76_2

				if arg_76_3 then
					if arg_76_3 == "already_equipped" then
						local var_76_3 = ScriptUnit.extension(arg_76_0, "pickup_system"):get_pickup_settings()

						if not var_76_3.item_description then
							table.dump(var_76_3)
						end

						var_76_2 = "interaction_action_already_equipped"
					elseif arg_76_3 == "ammo_blocked" then
						var_76_2 = "interaction_action_ammo_blocked"
						var_76_1 = true
					elseif arg_76_3 == "throwing_axe" then
						var_76_2 = "interaction_action_ammo_blocked"
						var_76_1 = true
					elseif arg_76_3 == "ammo_full" then
						var_76_2 = "interaction_action_ammo_full"
					elseif arg_76_3 == "grimoire_equipped" then
						var_76_2 = "interaction_action_grimoire_equipped"
					elseif arg_76_3 == "not_droppable" then
						var_76_2 = "interaction_action_not_droppable"
					end
				end
			end

			if var_76_1 then
				return var_76_0, var_76_2
			end

			return Unit.get_data(arg_76_0, "interaction_data", "hud_description"), var_76_2
		end
	}
}
InteractionDefinitions.give_item = {
	config = {
		allow_movement = true,
		duration = 0,
		hold = false,
		block_other_interactions = true
	},
	server = {
		start = function(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4, arg_77_5)
			arg_77_3.done_time = arg_77_5 + arg_77_4.duration
		end,
		update = function(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5, arg_78_6)
			local var_78_0 = ScriptUnit.extension(arg_78_1, "status_system")

			if var_78_0:is_knocked_down() or not HEALTH_ALIVE[arg_78_1] then
				return InteractionResult.FAILURE
			end

			if var_78_0:is_disabled() then
				return InteractionResult.FAILURE
			end

			if ScriptUnit.extension(arg_78_1, "status_system"):is_knocked_down() or not HEALTH_ALIVE[arg_78_2] then
				return InteractionResult.FAILURE
			end

			if arg_78_6 > arg_78_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5, arg_79_6)
			return
		end,
		can_interact = function(arg_80_0, arg_80_1)
			local var_80_0 = ScriptUnit.extension(arg_80_1, "status_system")
			local var_80_1 = Managers.state.side:is_enemy(arg_80_0, arg_80_1)

			return not var_80_0:is_disabled() and not var_80_1
		end
	},
	client = {
		start = function(arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5)
			return
		end,
		update = function(arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4, arg_82_5, arg_82_6)
			return
		end,
		stop = function(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4, arg_83_5, arg_83_6)
			arg_83_3.start_time = nil

			Unit.animation_event(arg_83_1, "interaction_end")

			if arg_83_6 == InteractionResult.SUCCESS then
				local var_83_0 = Managers.player:owner(arg_83_1)

				if var_83_0 and not var_83_0.remote then
					local var_83_1 = ScriptUnit.extension(arg_83_1, "inventory_system")
					local var_83_2 = arg_83_3.interactor_data.item_slot_name
					local var_83_3 = var_83_1:get_slot_data(var_83_2)

					if var_83_3 and var_83_1:get_item_template(var_83_3).can_give_other then
						local var_83_4 = var_83_1:get_item_slot_extension(var_83_2, "ammo_system")
						local var_83_5 = true
						local var_83_6 = true

						var_83_4:use_ammo(1, var_83_5, var_83_6)

						if not LEVEL_EDITOR_TEST then
							local var_83_7 = Managers.state.unit_storage:go_id(arg_83_1)
							local var_83_8 = Managers.state.unit_storage:go_id(arg_83_2)
							local var_83_9 = NetworkLookup.equipment_slots[var_83_2]
							local var_83_10 = NetworkLookup.item_names[var_83_3.item_data.name]
							local var_83_11 = POSITION_LOOKUP[arg_83_2] + Vector3(0, 0, 1.5)

							Managers.state.network.network_transmit:send_rpc_server("rpc_give_equipment", var_83_7, var_83_8, var_83_9, var_83_10, var_83_11)
						end

						var_83_1:wield_previous_weapon()
					end
				end
			end
		end,
		get_progress = function(arg_84_0, arg_84_1, arg_84_2)
			if arg_84_1.duration == 0 then
				return 0
			end

			return arg_84_0.start_time == nil and 0 or math.min(1, (arg_84_2 - arg_84_0.start_time) / arg_84_1.duration)
		end,
		can_interact = function(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
			if not ScriptUnit.has_extension(arg_85_1, "health_system") then
				return false
			end

			if not ScriptUnit.has_extension(arg_85_1, "status_system") then
				return false
			end

			if Managers.state.side:is_enemy(arg_85_0, arg_85_1) then
				return false
			end

			local var_85_0 = Managers.player:unit_owner(arg_85_0)
			local var_85_1

			var_85_1 = var_85_0 and var_85_0.bot_player

			local var_85_2 = ScriptUnit.extension(arg_85_1, "status_system")
			local var_85_3 = HEALTH_ALIVE[arg_85_1] and not var_85_2:is_knocked_down()
			local var_85_4 = ScriptUnit.extension(arg_85_0, "inventory_system")
			local var_85_5 = var_85_4:get_wielded_slot_item_template()

			if not var_85_5 then
				return false
			end

			local var_85_6 = ScriptUnit.extension(arg_85_1, "inventory_system")
			local var_85_7 = Managers.input:is_device_active("gamepad") and var_85_4:get_selected_consumable_slot_name() or var_85_4:get_wielded_slot_name()
			local var_85_8 = var_85_6:get_slot_data(var_85_7)
			local var_85_9 = var_85_6:can_store_additional_item(var_85_7)

			return var_85_3 and var_85_5.can_give_other and (not var_85_8 or var_85_9)
		end,
		set_interactor_data = function(arg_86_0, arg_86_1, arg_86_2)
			arg_86_2.item_slot_name = ScriptUnit.extension(arg_86_0, "inventory_system"):get_wielded_slot_name()
		end,
		hud_description = function(arg_87_0, arg_87_1, arg_87_2)
			if arg_87_0 and Unit.alive(arg_87_0) then
				local var_87_0 = Managers.player
				local var_87_1 = Managers.state.network.profile_synchronizer
				local var_87_2 = ""
				local var_87_3 = var_87_0:owner(arg_87_0)

				if var_87_3 then
					local var_87_4 = var_87_3:network_id()
					local var_87_5 = var_87_3:local_player_id()
					local var_87_6 = var_87_1:profile_by_peer(var_87_4, var_87_5)

					var_87_2 = SPProfiles[var_87_6].ingame_display_name
				end

				return var_87_2, "interaction_action_give"
			end
		end
	}
}
InteractionDefinitions.heal = {
	config = {
		block_other_interactions = true,
		hold = true,
		swap_to_3p = true,
		duration = 2,
		attack_template = "heal_bandage"
	},
	server = {
		start = function(arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4, arg_88_5)
			arg_88_3.done_time = arg_88_5 + arg_88_4.duration
		end,
		update = function(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5, arg_89_6)
			local var_89_0 = ScriptUnit.extension(arg_89_1, "status_system")

			if var_89_0:is_knocked_down() or not HEALTH_ALIVE[arg_89_1] then
				return InteractionResult.FAILURE
			end

			if var_89_0:is_disabled() then
				return InteractionResult.FAILURE
			end

			local var_89_1 = ScriptUnit.extension(arg_89_2, "status_system")

			if var_89_1:is_knocked_down() or not HEALTH_ALIVE[arg_89_2] then
				return InteractionResult.FAILURE
			end

			if var_89_1:is_disabled() then
				return InteractionResult.FAILURE
			end

			if arg_89_6 > arg_89_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6)
			if arg_90_6 == InteractionResult.SUCCESS then
				local var_90_0 = DamageUtils.get_attack_template(arg_90_4.attack_template)
				local var_90_1 = ScriptUnit.extension(arg_90_2, "health_system")
				local var_90_2 = ScriptUnit.extension(arg_90_1, "buff_system")
				local var_90_3 = var_90_0.heal_type

				if var_90_0.heal_type == "bandage" then
					local var_90_4 = var_90_1:get_damage_taken() * var_90_0.heal_percent

					if var_90_2:has_buff_perk("no_permanent_health") and arg_90_1 == arg_90_2 then
						var_90_3 = "bandage_temp_health"
					end

					DamageUtils.heal_network(arg_90_2, arg_90_1, var_90_4, var_90_3)
				else
					DamageUtils.heal_network(arg_90_2, arg_90_1, var_90_0.heal_amount, var_90_3)
				end

				if arg_90_1 ~= arg_90_2 then
					local var_90_5 = ScriptUnit.extension(arg_90_1, "health_system"):get_damage_taken()
					local var_90_6 = var_90_2:apply_buffs_to_value(var_90_5, "heal_self_on_heal_other") - var_90_5

					DamageUtils.heal_network(arg_90_1, arg_90_1, var_90_6, "bandage_trinket")
				end

				local var_90_7 = Managers.player
				local var_90_8 = var_90_7:unit_owner(arg_90_1)
				local var_90_9 = var_90_7:unit_owner(arg_90_2)
				local var_90_10 = POSITION_LOOKUP[arg_90_2]
			end
		end,
		can_interact = function(arg_91_0, arg_91_1)
			local var_91_0 = ScriptUnit.extension(arg_91_1, "status_system")
			local var_91_1 = var_91_0:is_knocked_down()
			local var_91_2 = var_91_0:is_dead()
			local var_91_3 = ScriptUnit.extension(arg_91_1, "health_system"):current_permanent_health_percent() >= 1
			local var_91_4 = var_91_0:is_wounded()

			return not var_91_1 and not var_91_2 and (not var_91_3 or not not var_91_4)
		end
	},
	client = {
		start = function(arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5)
			arg_92_3.start_time = arg_92_5

			local var_92_0 = ScriptUnit.extension_input(arg_92_1, "dialogue_system")
			local var_92_1 = FrameTable.alloc_table()

			var_92_1.target = arg_92_2
			var_92_1.target_name = ScriptUnit.extension(arg_92_2, "dialogue_system").context.player_profile

			var_92_0:trigger_dialogue_event("heal_start", var_92_1)
		end,
		update = function(arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6)
			return
		end,
		stop = function(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4, arg_94_5, arg_94_6)
			arg_94_3.start_time = nil

			Unit.animation_event(arg_94_1, "interaction_end")

			local var_94_0 = Managers.player:unit_owner(arg_94_1)

			if not var_94_0 then
				return
			end

			if arg_94_6 == InteractionResult.SUCCESS then
				if not var_94_0.remote then
					local var_94_1 = ScriptUnit.extension(arg_94_1, "inventory_system")
					local var_94_2, var_94_3 = ScriptUnit.extension(arg_94_1, "buff_system"):apply_buffs_to_value(0, "not_consume_medpack")

					if not var_94_3 then
						local var_94_4 = arg_94_3.interactor_data.item_slot_name
						local var_94_5 = var_94_1:get_slot_data(var_94_4)

						if var_94_5 then
							local var_94_6 = var_94_1:get_item_template(var_94_5)

							if var_94_6.can_heal_self and arg_94_1 == arg_94_2 or var_94_6.can_heal_other and arg_94_1 ~= arg_94_2 then
								var_94_1:get_item_slot_extension(var_94_4, "ammo_system"):use_ammo(1)
							end
						end
					else
						var_94_1:wield_previous_weapon()
					end
				end

				local var_94_7 = ScriptUnit.extension_input(arg_94_2, "dialogue_system")
				local var_94_8 = FrameTable.alloc_table()

				var_94_8.healer = arg_94_1
				var_94_8.healer_name = ScriptUnit.extension(arg_94_1, "dialogue_system").context.player_profile

				var_94_7:trigger_dialogue_event("heal_completed", var_94_8)
				StatisticsUtil.register_heal(arg_94_1, arg_94_2, arg_94_3.statistics_db)
			end
		end,
		get_progress = function(arg_95_0, arg_95_1, arg_95_2)
			if arg_95_1.duration == 0 then
				return 0
			end

			return arg_95_0.start_time == nil and 0 or math.min(1, (arg_95_2 - arg_95_0.start_time) / arg_95_1.duration)
		end,
		can_interact = function(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
			if not ScriptUnit.has_extension(arg_96_1, "health_system") then
				return false
			end

			if not ScriptUnit.has_extension(arg_96_1, "status_system") then
				return false
			end

			local var_96_0 = Managers.player:unit_owner(arg_96_0)
			local var_96_1

			var_96_1 = var_96_0 and var_96_0.bot_player

			local var_96_2 = ScriptUnit.extension(arg_96_1, "health_system")
			local var_96_3 = ScriptUnit.extension(arg_96_1, "status_system")
			local var_96_4 = var_96_2:is_alive() and not var_96_3:is_knocked_down()
			local var_96_5 = var_96_2:current_permanent_health_percent() >= 1
			local var_96_6 = var_96_3:is_wounded()
			local var_96_7 = ScriptUnit.extension(arg_96_0, "inventory_system"):get_wielded_slot_item_template()

			if not var_96_7 then
				return false
			end

			return var_96_7.can_heal_other and var_96_4 and (not var_96_5 or var_96_6)
		end,
		set_interactor_data = function(arg_97_0, arg_97_1, arg_97_2)
			arg_97_2.item_slot_name = ScriptUnit.extension(arg_97_0, "inventory_system"):get_wielded_slot_name()
		end,
		hud_description = function(arg_98_0, arg_98_1, arg_98_2)
			if arg_98_0 and Unit.alive(arg_98_0) then
				local var_98_0 = Managers.player
				local var_98_1 = Managers.state.network.profile_synchronizer
				local var_98_2 = ""
				local var_98_3 = var_98_0:owner(arg_98_0)

				if var_98_3 then
					local var_98_4 = var_98_3:network_id()
					local var_98_5 = var_98_3:local_player_id()
					local var_98_6 = var_98_1:profile_by_peer(var_98_4, var_98_5)

					var_98_2 = SPProfiles[var_98_6].ingame_display_name
				end

				local var_98_7 = Managers.time:time("game")
				local var_98_8 = arg_98_2.duration and arg_98_1.start_time == nil and 0 or math.min(1, (var_98_7 - arg_98_1.start_time) / arg_98_2.duration)
				local var_98_9 = var_98_8 and var_98_8 > 0 and "interaction_action_healing" or "interaction_action_heal"

				return var_98_2, var_98_9
			end
		end,
		camera_node = function(arg_99_0, arg_99_1)
			if arg_99_0 == arg_99_1 then
				return "heal_self"
			else
				return "heal_other"
			end
		end
	}
}
InteractionDefinitions.linker_transportation_unit = InteractionDefinitions.linker_transportation_unit or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.linker_transportation_unit.config.swap_to_3p = false

function InteractionDefinitions.linker_transportation_unit.client.hud_description(arg_100_0, arg_100_1, arg_100_2, arg_100_3)
	local var_100_0 = "interaction_action_activate"

	if arg_100_3 then
		if arg_100_3 == "enemies_inside" then
			var_100_0 = "interaction_action_hostiles_close"
		elseif arg_100_3 == "players_missing" then
			var_100_0 = "interaction_action_missing_players"
		end
	end

	return Unit.get_data(arg_100_0, "interaction_data", "hud_description"), var_100_0
end

function InteractionDefinitions.linker_transportation_unit.client.stop(arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6)
	arg_101_3.start_time = nil

	if arg_101_6 == InteractionResult.SUCCESS then
		if Unit.get_data(arg_101_2, "interaction_data", "only_once") then
			Unit.set_data(arg_101_2, "interaction_data", "used", true)
		end

		ScriptUnit.extension(arg_101_2, "transportation_system"):interacted_with(arg_101_1)
	end

	Unit.set_data(arg_101_2, "interaction_data", "being_used", false)
end

local var_0_5 = {}

function InteractionDefinitions.linker_transportation_unit.client.can_interact(arg_102_0, arg_102_1, arg_102_2, arg_102_3)
	local var_102_0 = ScriptUnit.extension(arg_102_1, "transportation_system")
	local var_102_1 = var_102_0:can_interact(arg_102_0)

	if Unit.get_data(arg_102_1, "interaction_data", "used") or not var_102_1 then
		return false
	end

	local var_102_2 = var_102_0.units_inside_oobb

	if var_102_2 then
		if var_102_2.ai.count > 0 then
			local var_102_3 = Managers.state.side

			for iter_102_0 in pairs(var_102_2.ai.units) do
				if var_102_3:is_enemy(arg_102_0, iter_102_0) then
					return false, "enemies_inside"
				end
			end
		end

		local var_102_4 = Managers.state.side.side_by_unit[arg_102_0].PLAYER_UNITS
		local var_102_5 = var_102_2.human.count
		local var_102_6 = 0
		local var_102_7 = ScriptUnit.extension
		local var_102_8 = #var_102_4

		for iter_102_1 = 1, var_102_8 do
			local var_102_9 = var_102_4[iter_102_1]
			local var_102_10 = var_102_7(var_102_9, "status_system")
			local var_102_11 = HEALTH_ALIVE[var_102_9]
			local var_102_12 = var_102_10:is_ready_for_assisted_respawn()

			if var_102_11 and not var_102_12 then
				var_102_6 = var_102_6 + 1
			end
		end

		if var_102_5 < var_102_6 then
			return false, "players_missing"
		end
	end

	return true
end

InteractionDefinitions.door = InteractionDefinitions.door or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.door.config.swap_to_3p = false
InteractionDefinitions.door.config.block_other_interactions = true
InteractionDefinitions.door.config.allow_movement = true

function InteractionDefinitions.door.client.stop(arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4, arg_103_5, arg_103_6)
	arg_103_3.start_time = nil

	if arg_103_6 == InteractionResult.SUCCESS then
		ScriptUnit.extension(arg_103_2, "door_system"):interacted_with(arg_103_1)
	end

	Unit.set_data(arg_103_2, "interaction_data", "being_used", false)
end

function InteractionDefinitions.door.client.hud_description(arg_104_0, arg_104_1, arg_104_2)
	local var_104_0 = ScriptUnit.extension(arg_104_0, "door_system"):is_open() and "interaction_action_close" or "interaction_action_open"

	return Unit.get_data(arg_104_0, "interaction_data", "hud_description"), var_104_0
end

local var_0_6 = {}

InteractionDefinitions.chest = InteractionDefinitions.chest or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.chest.config.swap_to_3p = false
InteractionDefinitions.chest.config.block_other_interactions = true
InteractionDefinitions.chest.config.allow_movement = true

function InteractionDefinitions.chest.client.start(arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4, arg_105_5)
	arg_105_3.start_time = arg_105_5

	local var_105_0 = Unit.get_data(arg_105_2, "interaction_data", "interaction_length")

	arg_105_3.duration = var_105_0

	local var_105_1 = Unit.get_data(arg_105_2, "interaction_data", "interactor_animation")
	local var_105_2 = Unit.get_data(arg_105_2, "interaction_data", "interactor_animation_time_variable")
	local var_105_3 = ScriptUnit.extension(arg_105_1, "inventory_system")

	if var_105_1 then
		local var_105_4 = Unit.animation_find_variable(arg_105_1, var_105_2)

		Unit.animation_set_variable(arg_105_1, var_105_4, var_105_0)
		Unit.animation_event(arg_105_1, var_105_1)
	end

	local var_105_5 = Unit.get_data(arg_105_2, "interaction_data", "interactable_animation")
	local var_105_6 = Unit.get_data(arg_105_2, "interaction_data", "interactable_animation_time_variable")

	if var_105_5 then
		local var_105_7 = Unit.animation_find_variable(arg_105_2, var_105_6)

		Unit.animation_set_variable(arg_105_2, var_105_7, var_105_0)
		Unit.animation_event(arg_105_2, var_105_5)
	end

	Unit.set_data(arg_105_2, "interaction_data", "being_used", true)
end

function InteractionDefinitions.chest.server.stop(arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4, arg_106_5, arg_106_6)
	arg_106_3.start_time = nil

	local var_106_0 = arg_106_6 == InteractionResult.SUCCESS

	if not Unit.get_data(arg_106_2, "can_spawn_dice") or Managers.weave:get_active_weave() then
		return
	end

	table.clear(var_0_6)

	local var_106_1 = "loot_die"
	local var_106_2 = arg_106_3.dice_keeper
	local var_106_3 = AllPickups[var_106_1]

	var_0_6.dice_keeper = var_106_2

	if var_106_0 and var_106_3.can_spawn_func(var_0_6) then
		local var_106_4 = ScriptUnit.extension(arg_106_1, "buff_system")
		local var_106_5 = math.random()
		local var_106_6 = var_106_2:chest_loot_dice_chance()

		if var_106_5 < var_106_4:apply_buffs_to_value(var_106_6, "increase_luck") then
			local var_106_7 = {
				pickup_system = {
					has_physics = true,
					spawn_type = "rare",
					pickup_name = var_106_1
				}
			}
			local var_106_8 = var_106_3.unit_name
			local var_106_9 = var_106_3.unit_template_name or "pickup_unit"
			local var_106_10 = Unit.local_position(arg_106_2, 0) + Vector3(0, 0, 0.3)
			local var_106_11 = Unit.local_rotation(arg_106_2, 0)

			Managers.state.unit_spawner:spawn_network_unit(var_106_8, var_106_9, var_106_7, var_106_10, var_106_11)
			var_106_2:bonus_dice_spawned()
		end
	end

	Unit.set_data(arg_106_2, "interaction_data", "being_used", false)
end

InteractionDefinitions.inventory_access = InteractionDefinitions.inventory_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.inventory_access.config.swap_to_3p = false

function InteractionDefinitions.inventory_access.client.can_interact(arg_107_0, arg_107_1, arg_107_2, arg_107_3)
	return true
end

function InteractionDefinitions.inventory_access.client.stop(arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4, arg_108_5, arg_108_6)
	arg_108_3.start_time = nil

	if arg_108_6 == InteractionResult.SUCCESS and not arg_108_3.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "equipment",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

function InteractionDefinitions.inventory_access.client.hud_description(arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4)
	return Unit.get_data(arg_109_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.prestige_access = InteractionDefinitions.prestige_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.prestige_access.config.swap_to_3p = false

function InteractionDefinitions.prestige_access.client.can_interact(arg_110_0, arg_110_1, arg_110_2, arg_110_3)
	return true
end

function InteractionDefinitions.prestige_access.client.stop(arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4, arg_111_5, arg_111_6)
	arg_111_3.start_time = nil

	if arg_111_6 == InteractionResult.SUCCESS and not arg_111_3.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "prestige",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

function InteractionDefinitions.prestige_access.client.can_interact(arg_112_0, arg_112_1, arg_112_2, arg_112_3)
	return false
end

function InteractionDefinitions.prestige_access.client.hud_description(arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4)
	return Unit.get_data(arg_113_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.forge_access = InteractionDefinitions.forge_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.forge_access.config.swap_to_3p = false

function InteractionDefinitions.forge_access.client.stop(arg_114_0, arg_114_1, arg_114_2, arg_114_3, arg_114_4, arg_114_5, arg_114_6)
	arg_114_3.start_time = nil

	if arg_114_6 == InteractionResult.SUCCESS and not arg_114_3.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "forge",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

function InteractionDefinitions.forge_access.client.can_interact(arg_115_0, arg_115_1, arg_115_2, arg_115_3)
	return not script_data["eac-untrusted"]
end

function InteractionDefinitions.forge_access.client.hud_description(arg_116_0, arg_116_1, arg_116_2, arg_116_3, arg_116_4)
	return Unit.get_data(arg_116_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.talents_access = InteractionDefinitions.talents_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.talents_access.config.swap_to_3p = false

function InteractionDefinitions.talents_access.client.stop(arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4, arg_117_5, arg_117_6)
	arg_117_3.start_time = nil

	if arg_117_6 == InteractionResult.SUCCESS and not arg_117_3.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "talents",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

function InteractionDefinitions.talents_access.client.can_interact(arg_118_0, arg_118_1, arg_118_2, arg_118_3)
	return true
end

function InteractionDefinitions.talents_access.client.hud_description(arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4)
	return Unit.get_data(arg_119_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.loadout_access = InteractionDefinitions.loadout_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.loadout_access.config.swap_to_3p = false

function InteractionDefinitions.loadout_access.client.stop(arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4, arg_120_5, arg_120_6)
	arg_120_3.start_time = nil

	if arg_120_6 == InteractionResult.SUCCESS and not arg_120_3.is_husk then
		Managers.ui:handle_transition("character_selection_force", {
			use_fade = true,
			menu_state_name = "loadouts"
		})
	end
end

function InteractionDefinitions.loadout_access.client.can_interact(arg_121_0, arg_121_1, arg_121_2, arg_121_3)
	return true
end

function InteractionDefinitions.loadout_access.client.hud_description(arg_122_0, arg_122_1, arg_122_2, arg_122_3, arg_122_4)
	return Unit.get_data(arg_122_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.cosmetics_access = InteractionDefinitions.cosmetics_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.cosmetics_access.config.swap_to_3p = false

function InteractionDefinitions.cosmetics_access.client.stop(arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4, arg_123_5, arg_123_6)
	arg_123_3.start_time = nil

	if arg_123_6 == InteractionResult.SUCCESS and not arg_123_3.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "cosmetics",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

function InteractionDefinitions.cosmetics_access.client.can_interact(arg_124_0, arg_124_1, arg_124_2, arg_124_3)
	return true
end

function InteractionDefinitions.cosmetics_access.client.hud_description(arg_125_0, arg_125_1, arg_125_2, arg_125_3, arg_125_4)
	return Unit.get_data(arg_125_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.loot_access = InteractionDefinitions.loot_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.loot_access.config.swap_to_3p = false

function InteractionDefinitions.loot_access.client.stop(arg_126_0, arg_126_1, arg_126_2, arg_126_3, arg_126_4, arg_126_5, arg_126_6)
	arg_126_3.start_time = nil

	if arg_126_6 == InteractionResult.SUCCESS and not arg_126_3.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			use_fade = true,
			menu_state_name = "loot"
		})
	end
end

function InteractionDefinitions.loot_access.client.can_interact(arg_127_0, arg_127_1, arg_127_2, arg_127_3)
	return not script_data["eac-untrusted"]
end

function InteractionDefinitions.loot_access.client.hud_description(arg_128_0, arg_128_1, arg_128_2, arg_128_3, arg_128_4)
	return Unit.get_data(arg_128_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.characters_access = InteractionDefinitions.characters_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.characters_access.config.swap_to_3p = false

function InteractionDefinitions.characters_access.client.stop(arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4, arg_129_5, arg_129_6)
	arg_129_3.start_time = nil

	if arg_129_6 == InteractionResult.SUCCESS and not arg_129_3.is_husk then
		Managers.ui:handle_transition("character_selection_force", {
			use_fade = true,
			menu_state_name = "character"
		})
	end
end

function InteractionDefinitions.characters_access.client.can_interact(arg_130_0, arg_130_1, arg_130_2, arg_130_3)
	return true
end

function InteractionDefinitions.characters_access.client.hud_description(arg_131_0, arg_131_1, arg_131_2, arg_131_3, arg_131_4)
	return Unit.get_data(arg_131_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.altar_access = InteractionDefinitions.altar_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.altar_access.config.swap_to_3p = false

function InteractionDefinitions.altar_access.client.stop(arg_132_0, arg_132_1, arg_132_2, arg_132_3, arg_132_4, arg_132_5, arg_132_6)
	arg_132_3.start_time = nil

	if arg_132_6 == InteractionResult.SUCCESS and not arg_132_3.is_husk then
		Managers.ui:handle_transition("altar_view_force", {
			use_fade = true
		})
	end
end

function InteractionDefinitions.altar_access.client.can_interact(arg_133_0, arg_133_1, arg_133_2, arg_133_3)
	return false
end

InteractionDefinitions.quest_access = InteractionDefinitions.quest_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.quest_access.config.swap_to_3p = false

function InteractionDefinitions.quest_access.client.stop(arg_134_0, arg_134_1, arg_134_2, arg_134_3, arg_134_4, arg_134_5, arg_134_6)
	arg_134_3.start_time = nil

	if arg_134_6 == InteractionResult.SUCCESS and not arg_134_3.is_husk then
		Managers.ui:handle_transition("quest_view_force", {
			use_fade = true
		})
	end
end

function InteractionDefinitions.quest_access.client.can_interact(arg_135_0, arg_135_1, arg_135_2, arg_135_3)
	local var_135_0 = false
	local var_135_1 = GameSettingsDevelopment.backend_settings
	local var_135_2 = var_135_0 and var_135_1.quests_enabled
	local var_135_3 = not var_135_2 and "quest_access_locked"

	return var_135_2, var_135_3
end

function InteractionDefinitions.quest_access.client.hud_description(arg_136_0, arg_136_1, arg_136_2, arg_136_3, arg_136_4)
	if arg_136_3 and arg_136_3 == "quest_access_locked" then
		return Unit.get_data(arg_136_0, "interaction_data", "hud_description"), "dlc1_3_1_interact_open_quests_blocked"
	end

	return Unit.get_data(arg_136_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.journal_access = InteractionDefinitions.journal_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.journal_access.config.swap_to_3p = false

function InteractionDefinitions.journal_access.client.stop(arg_137_0, arg_137_1, arg_137_2, arg_137_3, arg_137_4, arg_137_5, arg_137_6)
	arg_137_3.start_time = nil

	if arg_137_6 == InteractionResult.SUCCESS and not arg_137_3.is_husk then
		Managers.ui:handle_transition("lorebook_view_force", {
			use_fade = true
		})
	end
end

function InteractionDefinitions.journal_access.client.can_interact(arg_138_0, arg_138_1, arg_138_2, arg_138_3)
	return true
end

InteractionDefinitions.map_access = InteractionDefinitions.map_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.map_access.config.swap_to_3p = false

function InteractionDefinitions.map_access.client.stop(arg_139_0, arg_139_1, arg_139_2, arg_139_3, arg_139_4, arg_139_5, arg_139_6)
	arg_139_3.start_time = nil

	local var_139_0
	local var_139_1 = Managers.matchmaking:is_in_versus_custom_game_lobby() and "versus_player_hosted_lobby" or nil

	if arg_139_6 == InteractionResult.SUCCESS and not arg_139_3.is_husk then
		Managers.ui:handle_transition("start_game_view_force", {
			menu_state_name = "play",
			use_fade = true,
			menu_sub_state_name = var_139_1
		})
	end
end

function InteractionDefinitions.map_access.client.hud_description(arg_140_0, arg_140_1, arg_140_2, arg_140_3, arg_140_4)
	return Unit.get_data(arg_140_0, "interaction_data", "hud_description"), "interaction_action_open"
end

function InteractionDefinitions.map_access.client.can_interact(arg_141_0, arg_141_1, arg_141_2, arg_141_3)
	local var_141_0
	local var_141_1 = Managers.matchmaking:is_in_versus_custom_game_lobby()

	return not Managers.matchmaking:is_game_matchmaking() or var_141_1
end

InteractionDefinitions.unlock_key_access = InteractionDefinitions.unlock_key_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.unlock_key_access.config.swap_to_3p = false

function InteractionDefinitions.unlock_key_access.client.stop(arg_142_0, arg_142_1, arg_142_2, arg_142_3, arg_142_4, arg_142_5, arg_142_6)
	arg_142_3.start_time = nil

	if arg_142_6 == InteractionResult.SUCCESS and not arg_142_3.is_husk then
		Managers.ui:handle_transition("unlock_key_force", {
			use_fade = true
		})
	end
end

function InteractionDefinitions.unlock_key_access.client.can_interact(arg_143_0, arg_143_1, arg_143_2, arg_143_3)
	return true
end

for iter_0_0, iter_0_1 in pairs(InteractionDefinitions) do
	if iter_0_1.client.camera_node == nil then
		function iter_0_1.client.camera_node()
			return iter_0_0
		end
	end

	if iter_0_1.client.hud_description == nil then
		function iter_0_1.client.hud_description()
			return "interact_" .. iter_0_0
		end
	end
end

InteractionDefinitions.pictureframe = InteractionDefinitions.pictureframe or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.pictureframe.config.swap_to_3p = false

function InteractionDefinitions.pictureframe.client.stop(arg_146_0, arg_146_1, arg_146_2, arg_146_3, arg_146_4, arg_146_5, arg_146_6)
	arg_146_3.start_time = nil

	if arg_146_6 == InteractionResult.SUCCESS and not arg_146_3.is_husk and rawget(_G, "HeroViewStateKeepDecorations") then
		ScriptUnit.extension(arg_146_2, "keep_decoration_system"):interacted_with()
		Managers.ui:handle_transition("hero_view_force", {
			type = "painting",
			menu_state_name = "keep_decorations",
			use_fade = true,
			interactable_unit = arg_146_2
		})
	end
end

function InteractionDefinitions.pictureframe.client.can_interact(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
	local var_147_0 = ScriptUnit.extension(arg_147_1, "keep_decoration_system"):can_interact()
	local var_147_1 = Unit.get_data(arg_147_1, "painting_data", "not_interactable")

	return var_147_0 and not var_147_1
end

function InteractionDefinitions.pictureframe.client.hud_description(arg_148_0, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
	local var_148_0 = (not arg_148_1.is_server or Unit.get_data(arg_148_0, "interaction_data", "view_only")) and "interaction_action_view" or Unit.get_data(arg_148_0, "interaction_data", "hud_interaction_action")

	return Unit.get_data(arg_148_0, "interaction_data", "hud_description"), var_148_0
end

InteractionDefinitions.trophy = InteractionDefinitions.trophy or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.trophy.config.swap_to_3p = false

function InteractionDefinitions.trophy.client.stop(arg_149_0, arg_149_1, arg_149_2, arg_149_3, arg_149_4, arg_149_5, arg_149_6)
	arg_149_3.start_time = nil

	if arg_149_6 == InteractionResult.SUCCESS and not arg_149_3.is_husk and rawget(_G, "HeroViewStateKeepDecorations") then
		ScriptUnit.extension(arg_149_2, "keep_decoration_system"):interacted_with()
		Managers.ui:handle_transition("hero_view_force", {
			type = "trophy",
			menu_state_name = "keep_decorations",
			use_fade = true,
			interactable_unit = arg_149_2
		})
	end
end

function InteractionDefinitions.trophy.client.can_interact(arg_150_0, arg_150_1, arg_150_2, arg_150_3)
	local var_150_0 = ScriptUnit.extension(arg_150_1, "keep_decoration_system"):can_interact()
	local var_150_1 = Unit.get_data(arg_150_1, "trophy_data", "not_interactable")

	return var_150_0 and not var_150_1
end

function InteractionDefinitions.trophy.client.hud_description(arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
	local var_151_0 = (not arg_151_1.is_server or Unit.get_data(arg_151_0, "interaction_data", "view_only")) and "interaction_action_view" or Unit.get_data(arg_151_0, "interaction_data", "hud_interaction_action")

	return Unit.get_data(arg_151_0, "interaction_data", "hud_description"), var_151_0
end

InteractionDefinitions.decoration = InteractionDefinitions.decoration or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.decoration.config.swap_to_3p = false

function InteractionDefinitions.decoration.client.stop(arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4, arg_152_5, arg_152_6)
	arg_152_3.start_time = nil

	if arg_152_6 == InteractionResult.SUCCESS and not arg_152_3.is_husk and rawget(_G, "HeroViewStateKeepDecorations") then
		Managers.ui:handle_transition("hero_view_force", {
			menu_state_name = "keep_decorations",
			use_fade = true,
			interactable_unit = arg_152_2
		})
	end
end

function InteractionDefinitions.decoration.client.can_interact(arg_153_0, arg_153_1, arg_153_2, arg_153_3)
	return Unit.get_data(arg_153_1, "interaction_data", "camera_interaction_name") ~= ""
end

function InteractionDefinitions.decoration.client.hud_description(arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4)
	return Unit.get_data(arg_154_0, "interaction_data", "hud_description"), Unit.get_data(arg_154_0, "interaction_data", "hud_interaction_action")
end

InteractionDefinitions.no_interaction_hud_only = InteractionDefinitions.no_interaction_hud_only or table.clone(InteractionDefinitions.smartobject)

function InteractionDefinitions.no_interaction_hud_only.client.hud_description(arg_155_0, arg_155_1, arg_155_2, arg_155_3)
	local var_155_0 = Unit.get_data(arg_155_0, "interaction_data", "hud_text_line_1")
	local var_155_1 = Unit.get_data(arg_155_0, "interaction_data", "hud_text_line_2")

	return var_155_0, var_155_1
end

function InteractionDefinitions.no_interaction_hud_only.client.can_interact(arg_156_0, arg_156_1, arg_156_2, arg_156_3)
	return false, ""
end

InteractionDefinitions.achievement_access = InteractionDefinitions.achievement_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.achievement_access.config.swap_to_3p = false

function InteractionDefinitions.achievement_access.client.stop(arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4, arg_157_5, arg_157_6)
	arg_157_3.start_time = nil

	if arg_157_6 == InteractionResult.SUCCESS and not arg_157_3.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			use_fade = true,
			menu_state_name = "achievements"
		})
	end
end

function InteractionDefinitions.achievement_access.client.can_interact(arg_158_0, arg_158_1, arg_158_2, arg_158_3)
	return not script_data.settings.use_beta_mode
end

function InteractionDefinitions.achievement_access.client.hud_description(arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)
	return Unit.get_data(arg_159_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.luckstone_access = InteractionDefinitions.luckstone_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.luckstone_access.config.swap_to_3p = false

function InteractionDefinitions.luckstone_access.server.stop(arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4, arg_160_5, arg_160_6)
	if arg_160_6 == InteractionResult.SUCCESS then
		local var_160_0 = Managers.player
		local var_160_1 = var_160_0:statistics_db()
		local var_160_2 = var_160_0:local_player(1):stats_id()
		local var_160_3 = var_160_1:get_persistent_stat(var_160_2, "holly_difficulty_selection_plaza")

		if var_160_3 == 0 then
			var_160_3 = 1
		end

		local var_160_4 = {
			private_game = true,
			mission_id = "plaza",
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "event",
			mechanism = "adventure",
			quick_game = false,
			difficulty = DefaultDifficulties[var_160_3],
			event_data = {}
		}
		local var_160_5 = Managers.player:owner(arg_160_1)

		Managers.state.voting:request_vote("game_settings_vote", var_160_4, var_160_5.peer_id)
	end
end

function InteractionDefinitions.luckstone_access.client.stop(arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4, arg_161_5, arg_161_6)
	if arg_161_6 == InteractionResult.SUCCESS then
		local var_161_0 = Managers.world:world("level_world")
		local var_161_1 = "emitter_rune_activate"
		local var_161_2 = Unit.node(arg_161_2, "c_interaction")

		WwiseUtils.trigger_unit_event(var_161_0, var_161_1, arg_161_2, var_161_2)
	end
end

local var_0_7 = Unit.get_data

function InteractionDefinitions.luckstone_access.client.can_interact(arg_162_0, arg_162_1, arg_162_2, arg_162_3)
	local var_162_0 = var_0_7(arg_162_1, "cemetery")
	local var_162_1 = var_0_7(arg_162_1, "forest")
	local var_162_2 = var_0_7(arg_162_1, "magnus")
	local var_162_3 = var_162_0 and var_162_1 and var_162_2

	return not Managers.matchmaking:is_game_matchmaking() and var_162_3
end

function InteractionDefinitions.luckstone_access.client.hud_description(arg_163_0, arg_163_1, arg_163_2, arg_163_3, arg_163_4)
	return var_0_7(arg_163_0, "interaction_data", "hud_description"), Unit.get_data(arg_163_0, "interaction_data", "hud_interaction_action")
end

InteractionDefinitions.difficulty_selection_access = InteractionDefinitions.difficulty_selection_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.difficulty_selection_access.config.swap_to_3p = false

function InteractionDefinitions.difficulty_selection_access.server.stop(arg_164_0, arg_164_1, arg_164_2, arg_164_3, arg_164_4, arg_164_5, arg_164_6)
	if arg_164_6 == InteractionResult.SUCCESS then
		local var_164_0 = var_0_7(arg_164_2, "current_difficulty")
		local var_164_1 = "scorpion"

		var_164_0 = var_164_0 > (Managers.unlock:is_dlc_unlocked(var_164_1) and 4 or 3) and 1 or var_164_0 + 1

		local var_164_2 = Managers.player
		local var_164_3 = var_164_2:statistics_db()
		local var_164_4 = var_164_2:local_player(1):stats_id()

		var_164_3:set_stat(var_164_4, "holly_difficulty_selection_plaza", var_164_0)
		Unit.flow_event(arg_164_2, "lua_update_difficulty_on_success")
	end
end

function InteractionDefinitions.difficulty_selection_access.client.can_interact(arg_165_0, arg_165_1, arg_165_2, arg_165_3)
	local var_165_0 = var_0_7(arg_165_1, "is_interactable")

	return not Managers.matchmaking:is_game_matchmaking() and var_165_0
end

function InteractionDefinitions.difficulty_selection_access.client.hud_description(arg_166_0, arg_166_1, arg_166_2, arg_166_3, arg_166_4)
	local var_166_0 = var_0_7(arg_166_0, "current_difficulty")

	return var_0_7(arg_166_0, "interaction_data", "hud_description"), DifficultySettings[DefaultDifficulties[var_166_0]].display_name
end

InteractionDefinitions.handbook_access = InteractionDefinitions.handbook_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.handbook_access.config.swap_to_3p = false

function InteractionDefinitions.handbook_access.client.stop(arg_167_0, arg_167_1, arg_167_2, arg_167_3, arg_167_4, arg_167_5, arg_167_6)
	arg_167_3.start_time = nil

	if arg_167_6 == InteractionResult.SUCCESS and not arg_167_3.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			use_fade = true,
			menu_state_name = "handbook"
		})
	end
end

function InteractionDefinitions.handbook_access.client.can_interact(arg_168_0, arg_168_1, arg_168_2, arg_168_3)
	return true
end

function InteractionDefinitions.handbook_access.client.hud_description(arg_169_0, arg_169_1, arg_169_2, arg_169_3, arg_169_4)
	return Unit.get_data(arg_169_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.inn_door_transition = InteractionDefinitions.inn_door_transition or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.inn_door_transition.config.swap_to_3p = false

function InteractionDefinitions.inn_door_transition.client.stop(arg_170_0, arg_170_1, arg_170_2, arg_170_3, arg_170_4, arg_170_5, arg_170_6)
	if arg_170_6 == InteractionResult.SUCCESS and not arg_170_3.is_husk then
		local var_170_0 = Managers.backend:get_level_variation_data()
		local var_170_1 = {
			switch_mechanism = true,
			mechanism = "adventure",
			level_key = var_170_0.hub_level or "inn_level"
		}

		Managers.state.voting:request_vote("game_settings_vote_switch_mechanism", var_170_1, Network.peer_id())
	end
end

function InteractionDefinitions.inn_door_transition.client.hud_description(arg_171_0, arg_171_1, arg_171_2, arg_171_3, arg_171_4)
	return Unit.get_data(arg_171_0, "interaction_data", "hud_description"), "interaction_action_enter"
end

function InteractionDefinitions.inn_door_transition.client.can_interact(arg_172_0, arg_172_1, arg_172_2, arg_172_3)
	local var_172_0 = Managers.matchmaking:is_game_matchmaking()
	local var_172_1 = Managers.state.voting:vote_in_progress()

	return not var_172_0 and not var_172_1
end

InteractionDefinitions.deus_door_transition = InteractionDefinitions.deus_door_transition or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.deus_door_transition.config.swap_to_3p = false

function InteractionDefinitions.deus_door_transition.client.stop(arg_173_0, arg_173_1, arg_173_2, arg_173_3, arg_173_4, arg_173_5, arg_173_6)
	if arg_173_6 == InteractionResult.SUCCESS and not arg_173_3.is_husk then
		local var_173_0 = Managers.backend:get_level_variation_data()
		local var_173_1 = {
			switch_mechanism = true,
			mechanism = "deus",
			level_key = "morris_hub"
		}

		Managers.state.voting:request_vote("game_settings_vote_switch_mechanism", var_173_1, Network.peer_id())
	end
end

function InteractionDefinitions.deus_door_transition.client.hud_description(arg_174_0, arg_174_1, arg_174_2, arg_174_3, arg_174_4)
	return Unit.get_data(arg_174_0, "interaction_data", "hud_description"), "interaction_action_enter"
end

function InteractionDefinitions.deus_door_transition.client.can_interact(arg_175_0, arg_175_1, arg_175_2, arg_175_3)
	if not DLCSettings.morris then
		return false
	end

	local var_175_0 = Managers.matchmaking:is_game_matchmaking()
	local var_175_1 = Managers.state.voting:vote_in_progress()

	return not var_175_0 and not var_175_1
end

InteractionDefinitions.active_event = InteractionDefinitions.active_event or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.active_event.config.swap_to_3p = false

function InteractionDefinitions.active_event.client.stop(arg_176_0, arg_176_1, arg_176_2, arg_176_3, arg_176_4, arg_176_5, arg_176_6)
	arg_176_3.start_time = nil

	if arg_176_6 == InteractionResult.SUCCESS and not arg_176_3.is_husk then
		local var_176_0 = Managers.backend:get_interface("live_events")
		local var_176_1 = var_176_0 and var_176_0:get_active_events()
		local var_176_2 = "default_event"

		if var_176_1 then
			for iter_176_0 = 1, #var_176_1 do
				local var_176_3 = var_176_1[iter_176_0]

				if CommonPopupSettings[var_176_3] then
					var_176_2 = var_176_3

					break
				end
			end
		end

		Managers.state.event:trigger("ui_show_popup", var_176_2, "active_event")
	end
end

function InteractionDefinitions.active_event.client.can_interact(arg_177_0, arg_177_1, arg_177_2, arg_177_3)
	local var_177_0 = Managers.backend:get_interface("live_events")
	local var_177_1 = var_177_0 and var_177_0:get_active_events()

	return var_177_1 and #var_177_1 ~= 0
end

function InteractionDefinitions.active_event.client.hud_description(arg_178_0, arg_178_1, arg_178_2, arg_178_3, arg_178_4)
	return Unit.get_data(arg_178_0, "interaction_data", "hud_description"), "interaction_action_open"
end

DLCUtils.require_list("interactions_filenames")
