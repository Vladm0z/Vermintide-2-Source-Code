-- chunkname: @scripts/unit_extensions/generic/interactions.lua

InteractionResult = table.mirror_array_inplace({
	"ONGOING",
	"SUCCESS",
	"FAILURE",
	"USER_ENDED"
})

local InteractionCustomChecks = InteractionCustomChecks

InteractionCustomChecks = InteractionCustomChecks or {}
InteractionCustomChecks = InteractionCustomChecks

InteractionCustomChecks.dialogue_not_playing = function (arg_1_0, arg_1_1)
	-- function 1
	return not Managers.state.entity:system("dialogue_system"):is_dialogue_playing()
end

local InteractionDefinitions = InteractionDefinitions

InteractionDefinitions = InteractionDefinitions or {}
InteractionDefinitions = InteractionDefinitions
InteractionDefinitions.player_generic = {
	default_config = {
		hud_verb = "player_interaction",
		duration = 2,
		hold = true,
		swap_to_3p = true
	},
	server = {
		start = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
			-- function 2
			InteractionDefinitions.player_generic.current_data = InteractionHelper.choose_player_interaction(arg_2_1, arg_2_2)

			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].server.start(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
		end,
		update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
			-- function 3
			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].server.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
		end,
		stop = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
			-- function 4
			local stop = InteractionDefinitions[InteractionDefinitions.player_generic.current_data].server.stop(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)

			InteractionDefinitions.player_generic.current_data = nil

			return stop
		end
	},
	client = {
		start = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
			-- function 5
			InteractionDefinitions.player_generic.current_data = InteractionHelper.choose_player_interaction(arg_5_1, arg_5_2)

			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].client.start(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
		end,
		update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
			-- function 6
			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].client.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
		end,
		stop = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
			-- function 7
			local stop = InteractionDefinitions[InteractionDefinitions.player_generic.current_data].client.stop(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)

			InteractionDefinitions.player_generic.current_data = nil

			return stop
		end,
		get_progress = function (arg_8_0, arg_8_1, arg_8_2)
			-- function 8
			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].client.get_progress(arg_8_0, arg_8_1, arg_8_2)
		end,
		hud_description = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
			-- function 9
			local var_9_0
			local choose_player_interaction = InteractionHelper.choose_player_interaction(arg_9_4, arg_9_0)

			if not choose_player_interaction then
				var_9_0 = InteractionDefinitions[choose_player_interaction].client.hud_description(arg_9_0, arg_9_3, arg_9_3, arg_9_3, arg_9_4)
			else
				var_9_0 = InteractionDefinitions.player_generic.default_config.hud_verb
			end

			if not arg_9_0 and not Unit.alive(arg_9_0) then
				local player = Managers.player
				local profile_synchronizer = Managers.state.network.profile_synchronizer
				local str = ""
				local owner = player:owner(arg_9_0)

				if not owner then
					local network_id = owner:network_id()
					local local_player_id = owner:local_player_id()
					local profile_by_peer = profile_synchronizer:profile_by_peer(network_id, local_player_id)

					str = SPProfiles[profile_by_peer].ingame_display_name
				end

				return str, var_9_0
			end
		end,
		can_interact = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			-- function 10
			local choose_player_interaction = InteractionHelper.choose_player_interaction(arg_10_0, arg_10_1)

			return choose_player_interaction ~= nil, nil, choose_player_interaction
		end
	},
	get_config = function ()
		-- function 11
		if not InteractionDefinitions.player_generic.current_data then
			return InteractionDefinitions[InteractionDefinitions.player_generic.current_data].config
		else
			return InteractionDefinitions.player_generic.default_config
		end
	end
}

local function fn(arg_12_0, arg_12_1)
	-- function 12
	local extension = ScriptUnit.extension(arg_12_0, "first_person_system")
	local num = extension:current_position() + Vector3(math.random(-1, 1), math.random(-1, 1), 0) * 0.2
	local current_rotation = extension:current_rotation()
	local num_2 = num + Vector3.normalize(Quaternion.forward(current_rotation)) * 0.7
	local str = "dropped"
	local var_12_5 = NetworkLookup.pickup_names[arg_12_1]
	local var_12_6 = NetworkLookup.pickup_spawn_types[str]

	Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", var_12_5, num_2, current_rotation, var_12_6)
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
		start = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			-- function 13
			local duration = arg_13_4.duration
			local apply_buffs_to_value = ScriptUnit.extension(arg_13_1, "buff_system"):apply_buffs_to_value(duration, "faster_revive")

			ScriptUnit.extension(arg_13_2, "status_system"):set_knocked_down_bleed_buff_paused(true)

			arg_13_3.done_time = arg_13_5 + apply_buffs_to_value
		end,
		update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
			-- function 14
			if not (ScriptUnit.extension(arg_14_1, "status_system"):is_knocked_down() or HEALTH_ALIVE[arg_14_1]) then
				return InteractionResult.FAILURE
			end

			if not (not ScriptUnit.extension(arg_14_2, "status_system"):is_knocked_down() and HEALTH_ALIVE[arg_14_2]) then
				return InteractionResult.FAILURE
			end

			if arg_14_6 > arg_14_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
			-- function 15
			if arg_15_6 == InteractionResult.SUCCESS then
				StatusUtils.set_revived_network(arg_15_2, true, arg_15_1)

				local player = Managers.player
				local unit_owner = player:unit_owner(arg_15_1)
				local unit_owner_2 = player:unit_owner(arg_15_2)

				if not (not unit_owner and unit_owner_2) then
					return
				end

				local var_15_3 = POSITION_LOOKUP[arg_15_2]

				Managers.telemetry_events:player_revived(unit_owner, unit_owner_2, var_15_3)
			elseif not HEALTH_ALIVE[arg_15_2] then
				ScriptUnit.extension(arg_15_2, "status_system"):set_knocked_down_bleed_buff_paused(false)
			end
		end,
		can_interact = function (arg_16_0, arg_16_1)
			-- function 16
			local extension = ScriptUnit.extension(arg_16_1, "status_system")
			local is_knocked_down = extension:is_knocked_down()
			local is_pounced_down = extension:is_pounced_down()
			local var_16_3 = HEALTH_ALIVE[arg_16_1]
			local is_grabbed_by_pack_master = extension:is_grabbed_by_pack_master()
			local get_is_ledge_hanging = extension:get_is_ledge_hanging()
			local is_hanging_from_hook = extension:is_hanging_from_hook()

			return not is_knocked_down and not var_16_3 and not not is_pounced_down and not not is_grabbed_by_pack_master and not not get_is_ledge_hanging or not is_hanging_from_hook
		end
	},
	client = {
		start = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
			-- function 17
			arg_17_3.start_time = arg_17_5

			local animation_find_variable = Unit.animation_find_variable(arg_17_2, "revive_time")
			local duration = arg_17_4.duration
			local alloc_table = FrameTable.alloc_table()
			local alive = Unit.alive(arg_17_1)

			if not alive then
				duration = ScriptUnit.extension(arg_17_1, "buff_system"):apply_buffs_to_value(duration, "faster_revive")

				local animation_find_variable_2 = Unit.animation_find_variable(arg_17_1, "interaction_duration")

				Unit.animation_set_variable(arg_17_1, animation_find_variable_2, duration)
				Unit.animation_event(arg_17_1, "interaction_revive")

				alloc_table.target = arg_17_2
			end

			local alive_2 = Unit.alive(arg_17_2)

			if not alive_2 then
				Unit.animation_set_variable(arg_17_2, animation_find_variable, duration)
				Unit.animation_event(arg_17_2, "revive_start")

				if not ScriptUnit.has_extension(arg_17_2, "first_person_system") then
					ScriptUnit.extension(arg_17_2, "first_person_system"):set_wanted_player_height("stand", arg_17_5, duration)
				end

				alloc_table.target_name = ScriptUnit.extension(arg_17_2, "dialogue_system").context.player_profile

				ScriptUnit.extension(arg_17_1, "status_system"):set_reviving(true, arg_17_2)
			end

			arg_17_3.duration = duration

			if not alive_2 and not alive then
				ScriptUnit.extension_input(arg_17_1, "dialogue_system"):trigger_dialogue_event("start_revive", alloc_table)
			end
		end,
		update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
			-- function 18
			return
		end,
		stop = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			-- function 19
			arg_19_3.start_time = nil

			local alive = Unit.alive(arg_19_2)
			local alive_2 = Unit.alive(arg_19_1)

			if not alive_2 then
				Unit.animation_event(arg_19_1, "interaction_end")
			end

			if arg_19_6 == InteractionResult.SUCCESS then
				if not alive then
					Unit.animation_event(arg_19_2, "revive_complete")
				end

				if not alive_2 and not alive then
					StatisticsUtil.register_revive(arg_19_1, arg_19_2, arg_19_3.statistics_db)

					local player = Managers.player
					local unit_owner = player:unit_owner(arg_19_1)
					local unit_owner_2 = player:unit_owner(arg_19_2)
					local var_19_5 = POSITION_LOOKUP[arg_19_2]

					if not unit_owner_2.is_server then
						Managers.telemetry_events:player_revived(unit_owner, unit_owner_2, var_19_5)
					end
				end
			elseif not alive then
				Unit.animation_event(arg_19_2, "revive_abort")

				if not ScriptUnit.has_extension(arg_19_2, "first_person_system") then
					ScriptUnit.extension(arg_19_2, "first_person_system"):set_wanted_player_height("knocked_down", arg_19_5)
				end
			end

			ScriptUnit.extension(arg_19_1, "status_system"):set_reviving(false, arg_19_2)
		end,
		get_progress = function (self, arg_20_1, arg_20_2)
			-- function 20
			local duration = self.duration

			if duration == 0 then
				return 0
			end

			local flag

			flag = self.start_time ~= nil or not 0 or math.min(1, (arg_20_2 - self.start_time) / duration)

			return flag
		end,
		can_interact = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			-- function 21
			local is_being_interacted_with = ScriptUnit.extension(arg_21_1, "interactable_system"):is_being_interacted_with()

			if not (not is_being_interacted_with and is_being_interacted_with == arg_21_0) then
				return false
			end

			local extension = ScriptUnit.extension(arg_21_1, "status_system")
			local is_grabbed_by_pack_master = extension:is_grabbed_by_pack_master()
			local get_is_ledge_hanging = extension:get_is_ledge_hanging()
			local is_hanging_from_hook = extension:is_hanging_from_hook()
			local is_knocked_down

			if not (extension:is_pounced_down() or is_grabbed_by_pack_master or get_is_ledge_hanging or is_hanging_from_hook) then
				is_knocked_down = extension:is_knocked_down()

				if not is_knocked_down then
					is_knocked_down = HEALTH_ALIVE[arg_21_1]
				end
			else
				is_knocked_down = false
			end

			if false then
				is_knocked_down = true
			end

			return is_knocked_down
		end,
		hud_description = function (arg_22_0, arg_22_1, arg_22_2)
			-- function 22
			if not arg_22_0 and not Unit.alive(arg_22_0) then
				local player = Managers.player
				local profile_synchronizer = Managers.state.network.profile_synchronizer
				local str = ""
				local owner = player:owner(arg_22_0)

				if not owner then
					local network_id = owner:network_id()
					local local_player_id = owner:local_player_id()
					local profile_by_peer = profile_synchronizer:profile_by_peer(network_id, local_player_id)

					str = SPProfiles[profile_by_peer].ingame_display_name
				end

				local time = Managers.time:time("game")
				local flag

				flag = not arg_22_2.duration and arg_22_1.start_time == nil and 0 and math.min(1, (time - arg_22_1.start_time) / arg_22_2.duration)

				local flag_2

				flag_2 = not (not flag and flag > 0) and "interaction_action_reviving" and "interaction_action_revive"

				return str, flag_2
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
		start = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
			-- function 23
			arg_23_3.done_time = arg_23_5 + arg_23_4.duration
		end,
		update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			-- function 24
			if not (ScriptUnit.extension(arg_24_1, "status_system"):get_is_ledge_hanging() or HEALTH_ALIVE[arg_24_1]) then
				return InteractionResult.FAILURE
			end

			if arg_24_6 > arg_24_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
			-- function 25
			if arg_25_6 == InteractionResult.SUCCESS then
				StatusUtils.set_pulled_up_network(arg_25_2, true, not Unit.alive(arg_25_1) and arg_25_1 and nil)
			end
		end,
		can_interact = function (arg_26_0, arg_26_1)
			-- function 26
			local extension = ScriptUnit.extension(arg_26_1, "status_system")
			local get_is_ledge_hanging = extension:get_is_ledge_hanging()
			local is_pulled_up = extension:is_pulled_up()
			local has_buff_perk = ScriptUnit.extension(arg_26_1, "buff_system"):has_buff_perk("ledge_self_rescue")

			return not get_is_ledge_hanging and not not is_pulled_up or not has_buff_perk
		end
	},
	client = {
		start = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
			-- function 27
			arg_27_3.start_time = arg_27_5

			local animation_find_variable = Unit.animation_find_variable(arg_27_1, "interaction_duration")

			Unit.animation_set_variable(arg_27_1, animation_find_variable, arg_27_4.duration)
			Unit.animation_event(arg_27_1, "interaction_revive")

			if not Unit.alive(arg_27_2) then
				local animation_find_variable_2 = Unit.animation_find_variable(arg_27_2, "revive_time")

				Unit.animation_set_variable(arg_27_2, animation_find_variable_2, arg_27_4.duration)
				Unit.animation_event(arg_27_2, "revive_start")

				if not ScriptUnit.has_extension(arg_27_2, "first_person_system") then
					ScriptUnit.extension(arg_27_2, "first_person_system"):set_wanted_player_height("stand", arg_27_5, arg_27_4.duration)
				end

				local extension_input = ScriptUnit.extension_input(arg_27_1, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				alloc_table.target = arg_27_2
				alloc_table.target_name = ScriptUnit.extension(arg_27_2, "dialogue_system").context.player_profile

				extension_input:trigger_dialogue_event("start_revive", alloc_table)
			end
		end,
		update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
			-- function 28
			return
		end,
		stop = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
			-- function 29
			arg_29_3.start_time = nil

			Unit.animation_event(arg_29_1, "interaction_end")

			if arg_29_6 == InteractionResult.SUCCESS then
				if not Unit.alive(arg_29_2) then
					StatisticsUtil.register_pull_up(arg_29_1, arg_29_2, arg_29_3.statistics_db)
					Unit.animation_event(arg_29_2, "revive_complete")
				end
			elseif not Unit.alive(arg_29_2) then
				Unit.animation_event(arg_29_2, "revive_abort")

				if not ScriptUnit.has_extension(arg_29_2, "first_person_system") then
					ScriptUnit.extension(arg_29_2, "first_person_system"):set_wanted_player_height("knocked_down", arg_29_5)
				end
			end
		end,
		get_progress = function (self, arg_30_1, arg_30_2)
			-- function 30
			if arg_30_1.duration == 0 then
				return 0
			end

			local flag

			flag = self.start_time ~= nil or not 0 or math.min(1, (arg_30_2 - self.start_time) / arg_30_1.duration)

			return flag
		end,
		can_interact = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			-- function 31
			local extension = ScriptUnit.extension(arg_31_1, "status_system")
			local has_buff_perk = ScriptUnit.extension(arg_31_1, "buff_system"):has_buff_perk("ledge_self_rescue")
			local get_is_ledge_hanging = extension:get_is_ledge_hanging()

			get_is_ledge_hanging = not get_is_ledge_hanging and not extension:is_pulled_up()

			return not get_is_ledge_hanging and not has_buff_perk
		end,
		hud_description = function (arg_32_0, arg_32_1, arg_32_2)
			-- function 32
			if not arg_32_0 and not Unit.alive(arg_32_0) then
				local player = Managers.player
				local profile_synchronizer = Managers.state.network.profile_synchronizer
				local str = ""
				local owner = player:owner(arg_32_0)

				if not owner then
					local network_id = owner:network_id()
					local local_player_id = owner:local_player_id()
					local profile_by_peer = profile_synchronizer:profile_by_peer(network_id, local_player_id)

					str = SPProfiles[profile_by_peer].ingame_display_name
				end

				return str, "interaction_action_pull_up"
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
		start = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
			-- function 33
			arg_33_3.done_time = arg_33_5 + arg_33_4.duration
		end,
		update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
			-- function 34
			if arg_34_6 > arg_34_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6)
			-- function 35
			if arg_35_6 == InteractionResult.SUCCESS then
				StatusUtils.set_grabbed_by_pack_master_network("pack_master_dropping", arg_35_2, true, nil)
				QuestSettings.check_pack_master_rescue_hoisted_ally(arg_35_1)
			end
		end,
		can_interact = function (arg_36_0, arg_36_1)
			-- function 36
			local is_hanging_from_hook = ScriptUnit.extension(arg_36_1, "status_system"):is_hanging_from_hook()
			local var_36_1 = HEALTH_ALIVE[arg_36_1]

			return not is_hanging_from_hook and var_36_1
		end
	},
	client = {
		start = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
			-- function 37
			arg_37_3.start_time = arg_37_5

			local animation_find_variable = Unit.animation_find_variable(arg_37_1, "interaction_duration")

			Unit.animation_set_variable(arg_37_1, animation_find_variable, arg_37_4.duration)
			Unit.animation_event(arg_37_1, "interaction_generic")

			local extension_input = ScriptUnit.extension_input(arg_37_1, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			alloc_table.target = arg_37_2
			alloc_table.target_name = ScriptUnit.extension(arg_37_2, "dialogue_system").context.player_profile

			extension_input:trigger_dialogue_event("start_revive", alloc_table)
		end,
		update = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6)
			-- function 38
			return
		end,
		stop = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
			-- function 39
			arg_39_3.start_time = nil

			Unit.animation_event(arg_39_1, "interaction_end")
		end,
		get_progress = function (self, arg_40_1, arg_40_2)
			-- function 40
			if arg_40_1.duration == 0 then
				return 0
			end

			local flag

			flag = self.start_time ~= nil or not 0 or math.min(1, (arg_40_2 - self.start_time) / arg_40_1.duration)

			return flag
		end,
		can_interact = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
			-- function 41
			local is_hanging_from_hook = ScriptUnit.extension(arg_41_1, "status_system"):is_hanging_from_hook()
			local var_41_1 = HEALTH_ALIVE[arg_41_1]

			return not is_hanging_from_hook and var_41_1
		end,
		hud_description = function (arg_42_0, arg_42_1, arg_42_2)
			-- function 42
			if not arg_42_0 and not Unit.alive(arg_42_0) then
				local player = Managers.player
				local profile_synchronizer = Managers.state.network.profile_synchronizer
				local str = ""
				local owner = player:owner(arg_42_0)

				if not owner then
					local network_id = owner:network_id()
					local local_player_id = owner:local_player_id()
					local profile_by_peer = profile_synchronizer:profile_by_peer(network_id, local_player_id)

					str = SPProfiles[profile_by_peer].ingame_display_name
				end

				return str, "interact_release_from_hook"
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
		start = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
			-- function 43
			arg_43_3.done_time = arg_43_5 + arg_43_4.duration
		end,
		update = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5, arg_44_6)
			-- function 44
			if arg_44_6 > arg_44_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
			-- function 45
			if arg_45_6 == InteractionResult.SUCCESS then
				StatusUtils.set_respawned_network(arg_45_2, true, arg_45_1)
			end
		end,
		can_interact = function (arg_46_0, arg_46_1)
			-- function 46
			return (ScriptUnit.extension(arg_46_1, "status_system"):is_ready_for_assisted_respawn())
		end
	},
	client = {
		start = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5)
			-- function 47
			arg_47_3.start_time = arg_47_5

			local duration = arg_47_4.duration
			local animation_find_variable = Unit.animation_find_variable(arg_47_2, "revive_time")

			Unit.animation_set_variable(arg_47_2, animation_find_variable, duration)
			Unit.animation_event(arg_47_2, "revive_start")

			local animation_find_variable_2 = Unit.animation_find_variable(arg_47_1, "interaction_duration")

			Unit.animation_set_variable(arg_47_1, animation_find_variable_2, arg_47_4.duration)
			Unit.animation_event(arg_47_1, "interaction_revive")
		end,
		update = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5, arg_48_6)
			-- function 48
			return
		end,
		stop = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6)
			-- function 49
			arg_49_3.start_time = nil

			Unit.animation_event(arg_49_1, "interaction_end")

			if arg_49_6 == InteractionResult.SUCCESS then
				Unit.animation_event(arg_49_2, "revive_complete")
				StatisticsUtil.register_assisted_respawn(arg_49_1, arg_49_2, arg_49_3.statistics_db)
			else
				Unit.animation_event(arg_49_2, "revive_abort")
			end
		end,
		get_progress = function (self, arg_50_1, arg_50_2)
			-- function 50
			if arg_50_1.duration == 0 then
				return 0
			end

			local flag

			flag = self.start_time ~= nil or not 0 or math.min(1, (arg_50_2 - self.start_time) / arg_50_1.duration)

			return flag
		end,
		can_interact = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
			-- function 51
			return (ScriptUnit.extension(arg_51_1, "status_system"):is_ready_for_assisted_respawn())
		end,
		hud_description = function (arg_52_0, arg_52_1, arg_52_2)
			-- function 52
			if not arg_52_0 and not Unit.alive(arg_52_0) then
				local player = Managers.player
				local profile_synchronizer = Managers.state.network.profile_synchronizer
				local str = ""
				local owner = player:owner(arg_52_0)

				if not owner then
					local network_id = owner:network_id()
					local local_player_id = owner:local_player_id()
					local profile_by_peer = profile_synchronizer:profile_by_peer(network_id, local_player_id)

					str = SPProfiles[profile_by_peer].ingame_display_name
				end

				return str, "interaction_action_assisted_respawn"
			end
		end
	}
}

local num = 1

InteractionDefinitions.smartobject = {
	config = {
		show_weapons = true,
		hold = true,
		swap_to_3p = false
	},
	server = {
		start = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
			-- function 53
			local get_data = Unit.get_data(arg_53_2, "interaction_data", "interaction_length")

			fassert(get_data, "Interacting with %q that has no interaction length", arg_53_2)

			local get_data_2 = Unit.get_data(arg_53_2, "interaction_data", "stored_interaction_progress")

			get_data_2 = get_data_2 or 0
			arg_53_3.done_time = arg_53_5 + get_data - get_data_2
			arg_53_3.duration = get_data

			local get_data_3 = Unit.get_data(arg_53_2, "interaction_data", "apply_buff")

			if not get_data_3 then
				arg_53_3.apply_buff = get_data_3
			end

			local num = Unit.world_position(arg_53_1, 0) - Unit.world_position(arg_53_2, 0)

			arg_53_3.start_offset = Vector3Box(num)
		end,
		update = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6)
			-- function 54
			if not (ScriptUnit.extension(arg_54_1, "status_system"):is_knocked_down() or HEALTH_ALIVE[arg_54_1]) then
				return InteractionResult.FAILURE
			end

			local num_2 = Unit.world_position(arg_54_1, 0) - Unit.world_position(arg_54_2, 0)
			local unbox = arg_54_3.start_offset:unbox()

			if Vector3.distance_squared(unbox, num_2) > num then
				return InteractionResult.FAILURE
			end

			if arg_54_6 > arg_54_3.done_time then
				if not arg_54_3.apply_buff then
					Managers.state.entity:system("buff_system"):add_buff(arg_54_1, arg_54_3.apply_buff, arg_54_2, false)
				end

				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6)
			-- function 55
			if arg_55_6 == InteractionResult.SUCCESS then
				local extension = ScriptUnit.extension(arg_55_2, "interactable_system")

				extension.num_times_successfully_completed = extension.num_times_successfully_completed + 1
			end
		end,
		can_interact = function (arg_56_0, arg_56_1)
			-- function 56
			local get_data = Unit.get_data(arg_56_1, "interaction_data", "custom_interaction_check_name")

			if not (not get_data and not InteractionCustomChecks[get_data] and InteractionCustomChecks[get_data](arg_56_0, arg_56_1)) then
				return false
			end

			return not Unit.get_data(arg_56_1, "interaction_data", "used")
		end
	},
	client = {
		start = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5)
			-- function 57
			arg_57_3.start_time = arg_57_5

			local get_data = Unit.get_data(arg_57_2, "interaction_data", "interaction_length")

			arg_57_3.duration = get_data

			local get_data_2 = Unit.get_data(arg_57_2, "interaction_data", "stored_interaction_progress")

			get_data_2 = get_data_2 or 0
			arg_57_3.stored_progress = get_data_2

			local get_data_3 = Unit.get_data(arg_57_2, "interaction_data", "interactor_animation")
			local get_data_4 = Unit.get_data(arg_57_2, "interaction_data", "interactor_animation_time_variable")
			local extension = ScriptUnit.extension(arg_57_1, "inventory_system")
			local extension_2 = ScriptUnit.extension(arg_57_1, "career_system")

			if not get_data_3 then
				local animation_find_variable = Unit.animation_find_variable(arg_57_1, get_data_4)

				Unit.animation_set_variable(arg_57_1, animation_find_variable, get_data)
				Unit.animation_event(arg_57_1, get_data_3)
			end

			local get_data_5 = Unit.get_data(arg_57_2, "interaction_data", "interactable_animation")
			local get_data_6 = Unit.get_data(arg_57_2, "interaction_data", "interactable_animation_time_variable")

			if not get_data_5 then
				local animation_find_variable_2 = Unit.animation_find_variable(arg_57_2, get_data_6)

				Unit.animation_set_variable(arg_57_2, animation_find_variable_2, get_data)
				Unit.animation_event(arg_57_2, get_data_5)
			end

			CharacterStateHelper.stop_weapon_actions(extension, "interacting")
			CharacterStateHelper.stop_career_abilities(extension_2, "interacting")
			Unit.set_data(arg_57_2, "interaction_data", "being_used", true)
		end,
		update = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5, arg_58_6)
			-- function 58
			return
		end,
		stop = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6)
			-- function 59
			if not Unit.get_data(arg_59_2, "interaction_data", "resumable") then
				local stored_progress = arg_59_3.stored_progress

				stored_progress = stored_progress or 0

				local flag

				flag = arg_59_6 ~= InteractionResult.SUCCESS or not 0 or stored_progress + math.max(0, arg_59_5 - arg_59_3.start_time)

				Unit.set_data(arg_59_2, "interaction_data", "stored_interaction_progress", flag)
			end

			arg_59_3.start_time = nil

			if not Unit.has_animation_event(arg_59_1, "interaction_end") then
				Unit.animation_event(arg_59_1, "interaction_end")
			end

			if arg_59_6 ~= InteractionResult.SUCCESS or not Unit.get_data(arg_59_2, "interaction_data", "only_once") then
				Unit.set_data(arg_59_2, "interaction_data", "used", true)
			end

			Unit.set_data(arg_59_2, "interaction_data", "being_used", false)
		end,
		get_progress = function (self, arg_60_1, arg_60_2)
			-- function 60
			if not (self.duration == 0 or self.start_time ~= nil) then
				return 0
			end

			local stored_progress = self.stored_progress

			stored_progress = stored_progress or 0

			return math.clamp((arg_60_2 + stored_progress - self.start_time) / self.duration, 0, 1)
		end,
		can_interact = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
			-- function 61
			local get_data = Unit.get_data(arg_61_1, "interaction_data", "custom_interaction_check_name")

			if not (not get_data and not InteractionCustomChecks[get_data] and InteractionCustomChecks[get_data](arg_61_0, arg_61_1)) then
				return false
			end

			local get_data_2 = Unit.get_data(arg_61_1, "interaction_data", "used")
			local get_data_3 = Unit.get_data(arg_61_1, "interaction_data", "being_used")

			return not not get_data_2 or not get_data_3
		end,
		hud_description = function (arg_62_0, arg_62_1, arg_62_2)
			-- function 62
			return Unit.get_data(arg_62_0, "interaction_data", "hud_description"), Unit.get_data(arg_62_0, "interaction_data", "hud_interaction_action")
		end
	}
}

local InteractionDefinitions_2 = InteractionDefinitions
local control_panel = InteractionDefinitions.control_panel

control_panel = control_panel or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_2.control_panel = control_panel
InteractionDefinitions.control_panel.config.swap_to_3p = true
InteractionDefinitions.control_panel.config.show_weapons = false

local function fn_2(self)
	-- function 63
	local get_slot_data = self:get_slot_data("slot_potion")

	if not get_slot_data then
		return false
	end

	if not self:get_item_template(get_slot_data).is_grimoire then
		return true
	end

	local get_additional_items = self:get_additional_items("slot_potion")

	if not get_additional_items then
		for i = 1, #get_additional_items do
			local var_63_2 = get_additional_items[i]

			if not BackendUtils.get_item_template(var_63_2).is_grimoire then
				return true
			end
		end
	end

	return false
end

local function fn_3(arg_64_0)
	-- function 64
	return function (self)
		-- function 65
		return arg_64_0 ~= self.name
	end
end

local function fn_4(arg_66_0)
	-- function 66
	local pickup_data = BackendUtils.get_item_template(arg_66_0).pickup_data

	if not pickup_data then
		local pickup_name = pickup_data.pickup_name

		if not pickup_name then
			return pickup_name
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
		start = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
			-- function 67
			arg_67_3.done_time = arg_67_5 + Unit.get_data(arg_67_2, "interaction_data", "interaction_length")
		end,
		update = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5, arg_68_6)
			-- function 68
			if not (ScriptUnit.extension(arg_68_1, "status_system"):is_knocked_down() or HEALTH_ALIVE[arg_68_1]) then
				return InteractionResult.FAILURE
			end

			local has_extension = ScriptUnit.has_extension(arg_68_2, "health_system")

			if not has_extension and not has_extension.exploded then
				return InteractionResult.FAILURE
			end

			if arg_68_6 >= arg_68_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5, arg_69_6)
			-- function 69
			if arg_69_6 == InteractionResult.SUCCESS then
				if not Unit.get_data(arg_69_2, "interaction_data", "only_once") and not ScriptUnit.has_extension(arg_69_2, "limited_item_track_system") then
					ScriptUnit.extension(arg_69_2, "limited_item_track_system"):mark_for_transformation()
				end

				Managers.state.entity:system("pickup_system"):mark_for_consumption(arg_69_2, arg_69_1)

				local extension = ScriptUnit.extension(arg_69_1, "buff_system")
				local get_pickup_settings = ScriptUnit.extension(arg_69_2, "pickup_system"):get_pickup_settings()

				if not get_pickup_settings.consumable_item then
					extension:trigger_procs("on_consumable_picked_up", arg_69_2, get_pickup_settings)

					local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_69_1].PLAYER_AND_BOT_UNITS
					local count = #PLAYER_AND_BOT_UNITS

					if not get_pickup_settings.ranger_ammo then
						if not DEDICATED_SERVER then
							local player_unit = Managers.player:local_player().player_unit
							local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")

							if not has_extension then
								has_extension:trigger_procs("on_bardin_consumable_picked_up_any_player")
							end
						end

						for i = 1, count do
							local var_69_6 = PLAYER_AND_BOT_UNITS[i]

							if not Unit.alive(var_69_6) then
								local owner = Managers.player:owner(var_69_6)

								if not LEVEL_EDITOR_TEST then
									local network_id = owner:network_id()
									local local_player_id = owner:local_player_id()
									local on_bardin_consumable_picked_up_any_player = NetworkLookup.proc_events.on_bardin_consumable_picked_up_any_player

									Managers.state.network.network_transmit:send_rpc_clients("rpc_proc_event", network_id, local_player_id, on_bardin_consumable_picked_up_any_player)
								end
							end
						end
					end
				end
			end
		end,
		can_interact = function (arg_70_0, arg_70_1)
			-- function 70
			return not Managers.state.entity:system("pickup_system"):marked_for_consumption(arg_70_1)
		end
	},
	client = {
		start = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4, arg_71_5)
			-- function 71
			local get_data = Unit.get_data(arg_71_2, "interaction_data", "interaction_length")

			arg_71_3.duration = get_data

			fassert(get_data, "Interacting with %q that has no interaction length", arg_71_2)
		end,
		update = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6)
			-- function 72
			return
		end,
		stop = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6)
			-- function 73
			arg_73_3.start_time = nil

			Unit.animation_event(arg_73_1, "interaction_end")

			if arg_73_6 == InteractionResult.SUCCESS then
				local is_husk = arg_73_3.is_husk

				is_husk = is_husk or false

				if not (not Unit.get_data(arg_73_2, "interaction_data", "only_once") and is_husk) then
					Unit.set_data(arg_73_2, "interaction_data", "used", true)
				end

				local owner = Managers.player:owner(arg_73_1)
				local local_player = owner.local_player
				local is_player_controlled = owner:is_player_controlled()
				local network = Managers.state.network
				local extension = ScriptUnit.extension(arg_73_1, "inventory_system")
				local extension_2 = ScriptUnit.extension(arg_73_1, "career_system")
				local extension_3 = ScriptUnit.extension(arg_73_2, "pickup_system")
				local get_pickup_settings = extension_3:get_pickup_settings()
				local peer_id = owner.peer_id
				local var_73_10

				if not IS_WINDOWS then
					var_73_10 = not is_player_controlled and not rawget(_G, "Steam") and Steam.user_name(peer_id) and tostring(peer_id) or owner:name()
				elseif not Managers.account:is_online() then
					local lobby = Managers.state.network:lobby()

					var_73_10 = not is_player_controlled and lobby:user_name(peer_id) and owner:name()
				else
					var_73_10 = owner:name()
				end

				local flag = true

				if get_pickup_settings.type == "loot_die" then
					Managers.state.event:trigger("add_coop_feedback", owner:stats_id(), local_player, "picked_up_loot_dice", owner)

					local format = string.format(Localize("system_chat_player_picked_up_loot_die"), var_73_10)

					Managers.chat:add_local_system_message(1, format, flag)
				elseif get_pickup_settings.type == "painting_scrap" then
					Managers.state.event:trigger("add_coop_feedback", owner:stats_id(), local_player, "picked_up_painting_scrap", owner)

					local format_2 = string.format(Localize("system_chat_player_picked_up_painting_chat"), var_73_10)

					Managers.chat:add_local_system_message(1, format_2, flag)
				elseif get_pickup_settings.type == "inventory_item" then
					local slot_name = get_pickup_settings.slot_name
					local item_name = get_pickup_settings.item_name
					local get_slot_data = extension:get_slot_data(slot_name)
					local var_73_18 = ItemMasterList[item_name]

					if not (not get_slot_data and get_slot_data.item_data.name == var_73_18.name) then
						if item_name == "wpn_side_objective_tome_01" then
							Managers.state.event:trigger("add_coop_feedback", owner:stats_id(), local_player, "picked_up_tome", owner)
							Managers.state.event:trigger("player_pickup_tome", owner)

							local format_3 = string.format(Localize("system_chat_player_picked_up_tome"), var_73_10)

							Managers.chat:add_local_system_message(1, format_3, flag)
						elseif item_name == "wpn_grimoire_01" then
							Managers.state.event:trigger("add_coop_feedback", owner:stats_id(), local_player, "picked_up_grimoire", owner)
							Managers.state.event:trigger("player_pickup_grimoire", owner)

							local format_4 = string.format(Localize("system_chat_player_picked_up_grimoire"), var_73_10)

							Managers.chat:add_local_system_message(1, format_4, flag)
						end
					end

					if not get_slot_data then
						local item_data = get_slot_data.item_data
						local get_item_template = BackendUtils.get_item_template(item_data)

						if not (item_name == "wpn_side_objective_tome_01" or get_item_template.name ~= "wpn_side_objective_tome_01") then
							local flag_2 = not not owner.remote or not owner.bot_player

							Managers.state.event:trigger("add_coop_feedback", owner:stats_id(), flag_2, "discarded_tome", owner)

							local format_5 = string.format(Localize("system_chat_player_discarded_tome"), var_73_10)

							Managers.chat:add_local_system_message(1, format_5, flag)
						elseif not (item_name == "wpn_grimoire_01" or get_item_template.name ~= "wpn_grimoire_01") then
							local flag_3 = not not owner.remote or not owner.bot_player

							Managers.state.event:trigger("add_coop_feedback", owner:stats_id(), flag_3, "discarded_grimoire", owner)

							local format_6 = string.format(Localize("system_chat_player_discarded_grimoire"), var_73_10)

							Managers.chat:add_local_system_message(1, format_6, flag)
						end
					end
				end

				local on_pick_up_func = get_pickup_settings.on_pick_up_func

				if not on_pick_up_func then
					local is_server = arg_73_3.is_server

					on_pick_up_func(arg_73_0, arg_73_1, is_server, arg_73_2, is_husk)
				end

				local flag_4 = not owner.remote
				local local_pickup_sound = get_pickup_settings.local_pickup_sound

				if not (not local_pickup_sound and flag_4 and not local_pickup_sound and not owner.bot_player) then
					local pickup_sound_event_func = get_pickup_settings.pickup_sound_event_func
					local var_73_32

					if not pickup_sound_event_func then
						var_73_32 = pickup_sound_event_func(arg_73_1, arg_73_2, arg_73_3)

						if not var_73_32 then
							-- Nothing
						end
					end

					var_73_32 = get_pickup_settings.pickup_sound_event

					::label_73_0::

					if not var_73_32 then
						local wwise_world = Managers.world:wwise_world(arg_73_0)

						WwiseWorld.trigger_event(wwise_world, var_73_32)
					end
				end

				if not arg_73_3.is_server then
					local get_data = Unit.get_data(arg_73_2, "interaction_data", "item_name")
					local extension_input = ScriptUnit.extension_input(arg_73_1, "dialogue_system")
					local alloc_table = FrameTable.alloc_table()

					alloc_table.pickup_name = get_data

					extension_input:trigger_dialogue_event("on_pickup", alloc_table)

					local player_profile = ScriptUnit.extension(arg_73_1, "dialogue_system").context.player_profile

					SurroundingAwareSystem.add_event(arg_73_1, "on_other_pickup", DialogueSettings.default_view_distance, "pickup_name", get_data, "target_name", player_profile)
				end

				if not flag_4 then
					local extension_4 = ScriptUnit.extension(arg_73_1, "buff_system")

					if not (not get_pickup_settings.consumable_item and arg_73_3.is_server) then
						extension_4:trigger_procs("on_consumable_picked_up", arg_73_2, get_pickup_settings)
					end

					local statistics_db = arg_73_3.statistics_db
					local pickup_name = extension_3.pickup_name
					local spawn_type = extension_3.spawn_type
					local var_73_42 = POSITION_LOOKUP[arg_73_2]

					Managers.telemetry_events:player_pickup(owner, pickup_name, spawn_type, var_73_42)

					local lorebook_page_name = get_pickup_settings.lorebook_page_name

					if not lorebook_page_name then
						local var_73_44 = LorebookPageLookup[lorebook_page_name]

						StatisticsUtil.unlock_lorebook_page(var_73_44, statistics_db)
					end

					if not get_pickup_settings.hide_on_pickup then
						extension_3:hide()
					end

					if not get_pickup_settings.mission_name then
						local mission_name = get_pickup_settings.mission_name
						local var_73_46 = NetworkLookup.mission_names[mission_name]
						local network_transmit = network.network_transmit

						network_transmit:send_rpc_server("rpc_request_mission", var_73_46, false)
						network_transmit:send_rpc_server("rpc_request_mission_update", var_73_46, true)
					end

					local flag_5 = true
					local var_73_49

					if get_pickup_settings.type == "inventory_item" then
						local slot_name_2 = get_pickup_settings.slot_name
						local item_name_2 = get_pickup_settings.item_name
						local local_rotation = Unit.local_rotation(arg_73_2, 0)
						local var_73_53
						local tbl = {}
						local has_extension = ScriptUnit.has_extension(arg_73_2, "limited_item_track_system")

						if not has_extension then
							local extension_5 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
							local id = extension_5.id
							local spawner_unit = extension_5.spawner_unit

							var_73_53 = "weapon_unit_ammo_limited"
							tbl.limited_item_track_system = {
								spawner_unit = spawner_unit,
								id = id
							}
						end

						local get_slot_data_2 = extension:get_slot_data(slot_name_2)
						local flag_6 = not get_slot_data_2 and get_slot_data_2.item_data
						local flag_7 = not flag_6 and flag_6.dont_unwield_on_pickup
						local get_wielded_slot_name = extension:get_wielded_slot_name()
						local wield_on_pickup

						if not flag_7 then
							wield_on_pickup = get_pickup_settings.wield_on_pickup

							if not wield_on_pickup then
								-- Nothing
							end

							if get_wielded_slot_name ~= slot_name_2 then
								-- Nothing
							end
						end

						wield_on_pickup = false

						goto label_73_2

						::label_73_1::

						wield_on_pickup = true

						::label_73_2::

						local can_store_additional_item = extension:can_store_additional_item(slot_name_2)
						local var_73_65 = ItemMasterList[item_name_2]

						if not wield_on_pickup then
							CharacterStateHelper.stop_weapon_actions(extension, "picked_up_object")
							CharacterStateHelper.stop_career_abilities(extension_2, "picked_up_object")
						end

						local flag_8 = false

						if not (not flag_6 and not can_store_additional_item) then
							local has_droppable_item, var_73_68, var_73_69 = extension:has_droppable_item(slot_name_2, fn_3(item_name_2))

							if not has_droppable_item then
								var_73_49 = fn_4(var_73_69)

								if not var_73_68 then
									if not wield_on_pickup then
										extension:swap_equipment_from_storage(slot_name_2, SwapFromStorageType.Same, var_73_69)
										extension:destroy_slot(slot_name_2)
										extension:add_equipment(slot_name_2, var_73_65, var_73_53, tbl)

										flag_8 = true
									else
										extension:remove_additional_item(slot_name_2, var_73_69)
										extension:store_additional_item(slot_name_2, var_73_65)
									end
								else
									extension:destroy_slot(slot_name_2)
									extension:add_equipment(slot_name_2, var_73_65, var_73_53, tbl)

									flag_8 = true
								end
							else
								flag_5 = false
							end
						elseif not flag_6 then
							if not wield_on_pickup then
								extension:store_additional_item(slot_name_2, flag_6)
								extension:destroy_slot(slot_name_2)
								extension:add_equipment(slot_name_2, var_73_65, var_73_53, tbl)

								flag_8 = true
							else
								extension:store_additional_item(slot_name_2, var_73_65)
							end
						else
							extension:add_equipment(slot_name_2, var_73_65, var_73_53, tbl)

							flag_8 = true
						end

						if LEVEL_EDITOR_TEST or not flag_8 then
							local go_id = Managers.state.unit_storage:go_id(arg_73_1)
							local var_73_71 = NetworkLookup.equipment_slots[slot_name_2]
							local var_73_72 = NetworkLookup.item_names[item_name_2]
							local var_73_73 = NetworkLookup.weapon_skins["n/a"]

							if not has_extension then
								local extension_6 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
								local id_2 = extension_6.id
								local spawner_unit_2 = extension_6.spawner_unit
								local level_object_id

								if not spawner_unit_2 then
									level_object_id = Managers.state.network:level_object_id(spawner_unit_2)

									if not level_object_id then
										-- Nothing
									end
								end

								level_object_id = NetworkConstants.invalid_game_object_id

								::label_73_3::

								if not arg_73_3.is_server then
									network.network_transmit:send_rpc_clients("rpc_add_equipment_limited_item", go_id, var_73_71, var_73_72, level_object_id, id_2)
								else
									network.network_transmit:send_rpc_server("rpc_add_equipment_limited_item", go_id, var_73_71, var_73_72, level_object_id, id_2)
								end
							elseif not arg_73_3.is_server then
								network.network_transmit:send_rpc_clients("rpc_add_equipment", go_id, var_73_71, var_73_72, var_73_73)
							else
								network.network_transmit:send_rpc_server("rpc_add_equipment", go_id, var_73_71, var_73_72, var_73_73)
							end
						end

						if not wield_on_pickup then
							local action_on_wield = get_pickup_settings.action_on_wield

							if not action_on_wield then
								BackendUtils.get_item_template(var_73_65).next_action = action_on_wield
							end

							extension:wield(slot_name_2)
						end
					elseif get_pickup_settings.type == "explosive_inventory_item" then
						local slot_name_3 = get_pickup_settings.slot_name
						local item_name_3 = get_pickup_settings.item_name
						local extension_7 = ScriptUnit.extension(arg_73_2, "health_system")
						local extension_8 = ScriptUnit.extension(arg_73_2, "death_system")
						local extension_9 = ScriptUnit.extension(arg_73_2, "tutorial_system")
						local str = "explosive_weapon_unit_ammo"
						local tbl_2 = {
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
								health = extension_7.health,
								damage = extension_7.damage,
								item_name = item_name_3
							},
							death_system = {
								death_reaction_template = extension_8.death_reaction_template
							},
							tutorial_system = {
								always_show = extension_9.always_show,
								proxy_active = extension_9.active
							}
						}

						if not extension_7.ignited then
							tbl_2.health_system.health_data = extension_7:health_data()
						end

						local has_extension_2 = ScriptUnit.has_extension(arg_73_2, "limited_item_track_system")

						if not has_extension_2 then
							local extension_10 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
							local id_3 = extension_10.id
							local spawner_unit_3 = extension_10.spawner_unit

							str = "explosive_weapon_unit_ammo_limited"
							tbl_2.limited_item_track_system = {
								spawner_unit = spawner_unit_3,
								id = id_3
							}
						end

						local var_73_90 = ItemMasterList[item_name_3]

						extension:add_equipment(slot_name_3, var_73_90, str, tbl_2)

						if not LEVEL_EDITOR_TEST then
							local go_id_2 = Managers.state.unit_storage:go_id(arg_73_1)
							local var_73_92 = NetworkLookup.equipment_slots[slot_name_3]
							local var_73_93 = NetworkLookup.item_names[item_name_3]
							local var_73_94 = NetworkLookup.weapon_skins["n/a"]

							if not arg_73_3.is_server then
								if not has_extension_2 then
									local extension_11 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
									local id_4 = extension_11.id
									local spawner_unit_4 = extension_11.spawner_unit
									local level_object_id_2

									if not spawner_unit_4 then
										level_object_id_2 = Managers.state.network:level_object_id(spawner_unit_4)

										if not level_object_id_2 then
											-- Nothing
										end
									end

									level_object_id_2 = NetworkConstants.invalid_game_object_id

									::label_73_4::

									network.network_transmit:send_rpc_clients("rpc_add_equipment_limited_item", go_id_2, var_73_92, var_73_93, level_object_id_2, id_4)
								else
									network.network_transmit:send_rpc_clients("rpc_add_equipment", go_id_2, var_73_92, var_73_93, var_73_94)
								end
							elseif not has_extension_2 then
								local extension_12 = ScriptUnit.extension(arg_73_2, "limited_item_track_system")
								local id_5 = extension_12.id
								local spawner_unit_5 = extension_12.spawner_unit
								local level_object_id_3

								if not spawner_unit_5 then
									level_object_id_3 = Managers.state.network:level_object_id(spawner_unit_5)

									if not level_object_id_3 then
										-- Nothing
									end
								end

								level_object_id_3 = NetworkConstants.invalid_game_object_id

								::label_73_5::

								network.network_transmit:send_rpc_server("rpc_add_equipment_limited_item", go_id_2, var_73_92, var_73_93, level_object_id_3, id_5)
							else
								network.network_transmit:send_rpc_server("rpc_add_equipment", go_id_2, var_73_92, var_73_93, var_73_94)
							end
						end

						if not get_pickup_settings.wield_on_pickup then
							CharacterStateHelper.stop_weapon_actions(extension, "picked_up_object")
							CharacterStateHelper.stop_career_abilities(extension_2, "picked_up_object")
							extension:wield(slot_name_3)
						end
					elseif get_pickup_settings.type == "ammo" then
						if not local_player then
							ScriptUnit.extension(arg_73_1, "hud_system"):set_picked_up_ammo(true)
						end

						extension:add_ammo_from_pickup(get_pickup_settings)
					elseif get_pickup_settings.type == "lorebook_page" then
						local level_key = Managers.state.game_mode:level_key()
						local clone = table.clone(LorebookCollectablePages[level_key])

						table.shuffle(clone)

						local count = #clone
						local stats_id = Managers.player:local_player():stats_id()

						for i = 1, count do
							local var_73_107 = clone[i]
							local var_73_108 = LorebookCategoryLookup[var_73_107]

							if not statistics_db:get_persistent_array_stat(stats_id, "lorebook_unlocks", var_73_108) then
								StatisticsUtil.unlock_lorebook_page(var_73_108, statistics_db)
								Managers.state.event:trigger("add_personal_feedback", owner:stats_id() .. var_73_108, local_player, "picked_up_lorebook_page", var_73_107)

								break
							end
						end
					elseif get_pickup_settings.type == "painting_scrap" then
						local level_key_2 = Managers.state.game_mode:level_key()
						local stats_id_2 = Managers.player:local_player():stats_id()

						statistics_db:increment_stat(stats_id_2, "collected_painting_scraps_unlimited")

						if not table.contains(UnlockableLevels, level_key_2) then
							local str_2 = "collected_painting_scraps"
							local get_persistent_stat = statistics_db:get_persistent_stat(stats_id_2, str_2, level_key_2)
							local var_73_113 = QuestSettings.scrap_count_level[#QuestSettings.scrap_count_level]
							local get_persistent_stat_2 = statistics_db:get_persistent_stat(stats_id_2, str_2 .. "_generic")
							local var_73_115 = QuestSettings.scrap_count_generic[#QuestSettings.scrap_count_generic]

							if get_persistent_stat < var_73_113 then
								statistics_db:increment_stat(stats_id_2, str_2, level_key_2)
							end

							if get_persistent_stat_2 < var_73_115 then
								statistics_db:increment_stat(stats_id_2, str_2 .. "_generic")
							end
						end
					elseif get_pickup_settings.type == "crater_pendant" then
						local str_3 = "scorpion"

						if not Managers.unlock:is_dlc_unlocked(str_3) then
							local stats_id_3 = Managers.player:local_player():stats_id()

							statistics_db:set_stat(stats_id_3, "scorpion_crater_pendant", 1)
						end
					elseif get_pickup_settings.type == "crater_painting" then
						local str_4 = "scorpion"

						if not Managers.unlock:is_dlc_unlocked(str_4) then
							local stats_id_4 = Managers.player:local_player():stats_id()

							statistics_db:set_stat(stats_id_4, "scorpion_crater_dark_tongue_3", 1)
						end
					end

					Managers.state.entity:system("pickup_system"):finalize_consumption(arg_73_2, flag_5, var_73_49)
				end
			end
		end,
		get_progress = function (self, arg_74_1, arg_74_2)
			-- function 74
			if self.duration == 0 then
				return nil
			end

			local flag

			flag = self.start_time ~= nil or not 0 or math.min(1, (arg_74_2 - self.start_time) / self.duration)

			return flag
		end,
		can_interact = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4)
			-- function 75
			local flag = not Unit.get_data(arg_75_1, "interaction_data", "used")
			local extension = ScriptUnit.extension(arg_75_1, "pickup_system")
			local get_pickup_settings = extension:get_pickup_settings()
			local slot_name = get_pickup_settings.slot_name
			local var_75_4

			if not flag and not extension.can_interact then
				flag = extension:can_interact()
			end

			if not flag and not get_pickup_settings.can_interact_func then
				flag = get_pickup_settings.can_interact_func(arg_75_0, arg_75_1, arg_75_2)
			end

			flag = not flag and not Managers.state.entity:system("pickup_system"):marked_for_consumption(arg_75_1)

			local extension_2 = ScriptUnit.extension(arg_75_0, "inventory_system")
			local get_item_data_and_weapon_extensions, var_75_7, var_75_8 = CharacterStateHelper.get_item_data_and_weapon_extensions(extension_2)

			if not flag and not get_item_data_and_weapon_extensions then
				local get_current_action_data, var_75_10, var_75_11 = CharacterStateHelper.get_current_action_data(var_75_8, var_75_7)

				if not get_current_action_data and not get_current_action_data.block_pickup then
					flag = false
				end
			end

			if not (not flag and slot_name ~= "slot_level_event" or extension_2:get_wielded_slot_name() ~= "slot_level_event") then
				flag = false
			end

			local flag_2 = not slot_name and extension_2:get_slot_data(slot_name)

			if not flag and slot_name ~= "slot_potion" or not fn_2(extension_2) then
				var_75_4 = "grimoire_equipped"
				flag = false
			end

			local can_store_additional_item = extension_2:can_store_additional_item(slot_name)
			local flag_3 = not flag_2 and flag_2.item_data

			if not (not flag and not flag_3 and not flag_3.is_not_droppable and (can_store_additional_item or extension_2:has_droppable_item(slot_name, fn_3(get_pickup_settings.item_name)))) then
				var_75_4 = "not_droppable"
				flag = false
			end

			if not (not flag and not flag_3 and can_store_additional_item or extension_2:has_droppable_item(slot_name, fn_3(get_pickup_settings.item_name))) then
				var_75_4 = "already_equipped"
				flag = false
			end

			if not flag and not ScriptUnit.has_extension(arg_75_1, "death_system") then
				local death_reaction_data = ScriptUnit.extension(arg_75_1, "death_system").death_reaction_data

				if not death_reaction_data and not death_reaction_data.exploded then
					flag = false
				end
			end

			if not (not flag and get_pickup_settings.type ~= "ammo") then
				if not extension_2:is_ammo_blocked() then
					var_75_4 = "ammo_blocked"
					flag = false
				elseif not (not extension_2:has_ammo_consuming_weapon_equipped("throwing_axe") and get_pickup_settings.pickup_name ~= "all_ammo") then
					var_75_4 = "throwing_axe"
					flag = false
				elseif not extension_2:has_full_ammo() then
					var_75_4 = "ammo_full"
					flag = false
				end
			end

			return flag, var_75_4
		end,
		hud_description = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4)
			-- function 76
			local str = "no_ammo_for_this_weapon"
			local flag = false
			local str_2 = "interaction_action_pick_up"

			if not Managers.state.unit_spawner:is_marked_for_deletion(arg_76_0) then
				str_2 = Unit.get_data(arg_76_0, "interaction_action_description") or str_2

				if not arg_76_3 then
					if arg_76_3 == "already_equipped" then
						local get_pickup_settings = ScriptUnit.extension(arg_76_0, "pickup_system"):get_pickup_settings()

						if not get_pickup_settings.item_description then
							table.dump(get_pickup_settings)
						end

						str_2 = "interaction_action_already_equipped"
					elseif arg_76_3 == "ammo_blocked" then
						str_2 = "interaction_action_ammo_blocked"
						flag = true
					elseif arg_76_3 == "throwing_axe" then
						str_2 = "interaction_action_ammo_blocked"
						flag = true
					elseif arg_76_3 == "ammo_full" then
						str_2 = "interaction_action_ammo_full"
					elseif arg_76_3 == "grimoire_equipped" then
						str_2 = "interaction_action_grimoire_equipped"
					elseif arg_76_3 == "not_droppable" then
						str_2 = "interaction_action_not_droppable"
					end
				end
			end

			if not flag then
				return str, str_2
			end

			return Unit.get_data(arg_76_0, "interaction_data", "hud_description"), str_2
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
		start = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4, arg_77_5)
			-- function 77
			arg_77_3.done_time = arg_77_5 + arg_77_4.duration
		end,
		update = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5, arg_78_6)
			-- function 78
			local extension = ScriptUnit.extension(arg_78_1, "status_system")

			if not (extension:is_knocked_down() or HEALTH_ALIVE[arg_78_1]) then
				return InteractionResult.FAILURE
			end

			if not extension:is_disabled() then
				return InteractionResult.FAILURE
			end

			if not (ScriptUnit.extension(arg_78_1, "status_system"):is_knocked_down() or HEALTH_ALIVE[arg_78_2]) then
				return InteractionResult.FAILURE
			end

			if arg_78_6 > arg_78_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5, arg_79_6)
			-- function 79
			return
		end,
		can_interact = function (arg_80_0, arg_80_1)
			-- function 80
			local extension = ScriptUnit.extension(arg_80_1, "status_system")
			local is_enemy = Managers.state.side:is_enemy(arg_80_0, arg_80_1)

			return not not extension:is_disabled() or not is_enemy
		end
	},
	client = {
		start = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5)
			-- function 81
			return
		end,
		update = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4, arg_82_5, arg_82_6)
			-- function 82
			return
		end,
		stop = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4, arg_83_5, arg_83_6)
			-- function 83
			arg_83_3.start_time = nil

			Unit.animation_event(arg_83_1, "interaction_end")

			if arg_83_6 == InteractionResult.SUCCESS then
				local owner = Managers.player:owner(arg_83_1)

				if not (not owner and owner.remote) then
					local extension = ScriptUnit.extension(arg_83_1, "inventory_system")
					local item_slot_name = arg_83_3.interactor_data.item_slot_name
					local get_slot_data = extension:get_slot_data(item_slot_name)

					if not get_slot_data and not extension:get_item_template(get_slot_data).can_give_other then
						local get_item_slot_extension = extension:get_item_slot_extension(item_slot_name, "ammo_system")
						local flag = true
						local flag_2 = true

						get_item_slot_extension:use_ammo(1, flag, flag_2)

						if not LEVEL_EDITOR_TEST then
							local go_id = Managers.state.unit_storage:go_id(arg_83_1)
							local go_id_2 = Managers.state.unit_storage:go_id(arg_83_2)
							local var_83_9 = NetworkLookup.equipment_slots[item_slot_name]
							local var_83_10 = NetworkLookup.item_names[get_slot_data.item_data.name]
							local num = POSITION_LOOKUP[arg_83_2] + Vector3(0, 0, 1.5)

							Managers.state.network.network_transmit:send_rpc_server("rpc_give_equipment", go_id, go_id_2, var_83_9, var_83_10, num)
						end

						extension:wield_previous_weapon()
					end
				end
			end
		end,
		get_progress = function (self, arg_84_1, arg_84_2)
			-- function 84
			if arg_84_1.duration == 0 then
				return 0
			end

			local flag

			flag = self.start_time ~= nil or not 0 or math.min(1, (arg_84_2 - self.start_time) / arg_84_1.duration)

			return flag
		end,
		can_interact = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
			-- function 85
			if not ScriptUnit.has_extension(arg_85_1, "health_system") then
				return false
			end

			if not ScriptUnit.has_extension(arg_85_1, "status_system") then
				return false
			end

			if not Managers.state.side:is_enemy(arg_85_0, arg_85_1) then
				return false
			end

			local unit_owner = Managers.player:unit_owner(arg_85_0)
			local flag

			flag = not unit_owner and unit_owner.bot_player

			local extension = ScriptUnit.extension(arg_85_1, "status_system")
			local var_85_3 = HEALTH_ALIVE[arg_85_1]

			var_85_3 = not var_85_3 and not extension:is_knocked_down()

			local extension_2 = ScriptUnit.extension(arg_85_0, "inventory_system")
			local get_wielded_slot_item_template = extension_2:get_wielded_slot_item_template()

			if not get_wielded_slot_item_template then
				return false
			end

			local extension_3 = ScriptUnit.extension(arg_85_1, "inventory_system")
			local get_selected_consumable_slot_name

			if not Managers.input:is_device_active("gamepad") then
				get_selected_consumable_slot_name = extension_2:get_selected_consumable_slot_name()

				if not get_selected_consumable_slot_name then
					-- Nothing
				end
			end

			get_selected_consumable_slot_name = extension_2:get_wielded_slot_name()

			::label_85_0::

			local get_slot_data = extension_3:get_slot_data(get_selected_consumable_slot_name)
			local can_store_additional_item = extension_3:can_store_additional_item(get_selected_consumable_slot_name)

			if not var_85_3 then
				-- Nothing
			end

			::label_85_1::

			local can_give_other = get_wielded_slot_item_template.can_give_other

			can_give_other = not can_give_other and not get_slot_data and can_store_additional_item

			::label_85_2::

			return can_give_other
		end,
		set_interactor_data = function (arg_86_0, arg_86_1, arg_86_2)
			-- function 86
			arg_86_2.item_slot_name = ScriptUnit.extension(arg_86_0, "inventory_system"):get_wielded_slot_name()
		end,
		hud_description = function (arg_87_0, arg_87_1, arg_87_2)
			-- function 87
			if not arg_87_0 and not Unit.alive(arg_87_0) then
				local player = Managers.player
				local profile_synchronizer = Managers.state.network.profile_synchronizer
				local str = ""
				local owner = player:owner(arg_87_0)

				if not owner then
					local network_id = owner:network_id()
					local local_player_id = owner:local_player_id()
					local profile_by_peer = profile_synchronizer:profile_by_peer(network_id, local_player_id)

					str = SPProfiles[profile_by_peer].ingame_display_name
				end

				return str, "interaction_action_give"
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
		start = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4, arg_88_5)
			-- function 88
			arg_88_3.done_time = arg_88_5 + arg_88_4.duration
		end,
		update = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5, arg_89_6)
			-- function 89
			local extension = ScriptUnit.extension(arg_89_1, "status_system")

			if not (extension:is_knocked_down() or HEALTH_ALIVE[arg_89_1]) then
				return InteractionResult.FAILURE
			end

			if not extension:is_disabled() then
				return InteractionResult.FAILURE
			end

			local extension_2 = ScriptUnit.extension(arg_89_2, "status_system")

			if not (extension_2:is_knocked_down() or HEALTH_ALIVE[arg_89_2]) then
				return InteractionResult.FAILURE
			end

			if not extension_2:is_disabled() then
				return InteractionResult.FAILURE
			end

			if arg_89_6 > arg_89_3.done_time then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6)
			-- function 90
			if arg_90_6 == InteractionResult.SUCCESS then
				local get_attack_template = DamageUtils.get_attack_template(arg_90_4.attack_template)
				local extension = ScriptUnit.extension(arg_90_2, "health_system")
				local extension_2 = ScriptUnit.extension(arg_90_1, "buff_system")
				local heal_type = get_attack_template.heal_type

				if get_attack_template.heal_type == "bandage" then
					local num = extension:get_damage_taken() * get_attack_template.heal_percent

					if not (not extension_2:has_buff_perk("no_permanent_health") and arg_90_1 ~= arg_90_2) then
						heal_type = "bandage_temp_health"
					end

					DamageUtils.heal_network(arg_90_2, arg_90_1, num, heal_type)
				else
					DamageUtils.heal_network(arg_90_2, arg_90_1, get_attack_template.heal_amount, heal_type)
				end

				if arg_90_1 ~= arg_90_2 then
					local get_damage_taken = ScriptUnit.extension(arg_90_1, "health_system"):get_damage_taken()
					local num_2 = extension_2:apply_buffs_to_value(get_damage_taken, "heal_self_on_heal_other") - get_damage_taken

					DamageUtils.heal_network(arg_90_1, arg_90_1, num_2, "bandage_trinket")
				end

				local player = Managers.player
				local unit_owner = player:unit_owner(arg_90_1)
				local unit_owner_2 = player:unit_owner(arg_90_2)
				local var_90_10 = POSITION_LOOKUP[arg_90_2]
			end
		end,
		can_interact = function (arg_91_0, arg_91_1)
			-- function 91
			local extension = ScriptUnit.extension(arg_91_1, "status_system")
			local is_knocked_down = extension:is_knocked_down()
			local is_dead = extension:is_dead()
			local flag = ScriptUnit.extension(arg_91_1, "health_system"):current_permanent_health_percent() >= 1
			local is_wounded = extension:is_wounded()

			return (not not is_knocked_down or not not is_dead or not flag) and not not is_wounded
		end
	},
	client = {
		start = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5)
			-- function 92
			arg_92_3.start_time = arg_92_5

			local extension_input = ScriptUnit.extension_input(arg_92_1, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			alloc_table.target = arg_92_2
			alloc_table.target_name = ScriptUnit.extension(arg_92_2, "dialogue_system").context.player_profile

			extension_input:trigger_dialogue_event("heal_start", alloc_table)
		end,
		update = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6)
			-- function 93
			return
		end,
		stop = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4, arg_94_5, arg_94_6)
			-- function 94
			arg_94_3.start_time = nil

			Unit.animation_event(arg_94_1, "interaction_end")

			local unit_owner = Managers.player:unit_owner(arg_94_1)

			if not unit_owner then
				return
			end

			if arg_94_6 == InteractionResult.SUCCESS then
				if not unit_owner.remote then
					local extension = ScriptUnit.extension(arg_94_1, "inventory_system")
					local apply_buffs_to_value, var_94_3 = ScriptUnit.extension(arg_94_1, "buff_system"):apply_buffs_to_value(0, "not_consume_medpack")

					if not var_94_3 then
						local item_slot_name = arg_94_3.interactor_data.item_slot_name
						local get_slot_data = extension:get_slot_data(item_slot_name)

						if not get_slot_data then
							local get_item_template = extension:get_item_template(get_slot_data)

							if not ((not get_item_template.can_heal_self and arg_94_1 == arg_94_2 or not get_item_template.can_heal_other) and arg_94_1 == arg_94_2) then
								extension:get_item_slot_extension(item_slot_name, "ammo_system"):use_ammo(1)
							end
						end
					else
						extension:wield_previous_weapon()
					end
				end

				local extension_input = ScriptUnit.extension_input(arg_94_2, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				alloc_table.healer = arg_94_1
				alloc_table.healer_name = ScriptUnit.extension(arg_94_1, "dialogue_system").context.player_profile

				extension_input:trigger_dialogue_event("heal_completed", alloc_table)
				StatisticsUtil.register_heal(arg_94_1, arg_94_2, arg_94_3.statistics_db)
			end
		end,
		get_progress = function (self, arg_95_1, arg_95_2)
			-- function 95
			if arg_95_1.duration == 0 then
				return 0
			end

			local flag

			flag = self.start_time ~= nil or not 0 or math.min(1, (arg_95_2 - self.start_time) / arg_95_1.duration)

			return flag
		end,
		can_interact = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3)
			-- function 96
			if not ScriptUnit.has_extension(arg_96_1, "health_system") then
				return false
			end

			if not ScriptUnit.has_extension(arg_96_1, "status_system") then
				return false
			end

			local unit_owner = Managers.player:unit_owner(arg_96_0)
			local flag

			flag = not unit_owner and unit_owner.bot_player

			local extension = ScriptUnit.extension(arg_96_1, "health_system")
			local extension_2 = ScriptUnit.extension(arg_96_1, "status_system")
			local is_alive = extension:is_alive()

			is_alive = not is_alive and not extension_2:is_knocked_down()

			local flag_2 = extension:current_permanent_health_percent() >= 1
			local is_wounded = extension_2:is_wounded()
			local get_wielded_slot_item_template = ScriptUnit.extension(arg_96_0, "inventory_system"):get_wielded_slot_item_template()

			if not get_wielded_slot_item_template then
				return false
			end

			return not get_wielded_slot_item_template.can_heal_other and not is_alive and not flag_2 and is_wounded
		end,
		set_interactor_data = function (arg_97_0, arg_97_1, arg_97_2)
			-- function 97
			arg_97_2.item_slot_name = ScriptUnit.extension(arg_97_0, "inventory_system"):get_wielded_slot_name()
		end,
		hud_description = function (arg_98_0, arg_98_1, arg_98_2)
			-- function 98
			if not arg_98_0 and not Unit.alive(arg_98_0) then
				local player = Managers.player
				local profile_synchronizer = Managers.state.network.profile_synchronizer
				local str = ""
				local owner = player:owner(arg_98_0)

				if not owner then
					local network_id = owner:network_id()
					local local_player_id = owner:local_player_id()
					local profile_by_peer = profile_synchronizer:profile_by_peer(network_id, local_player_id)

					str = SPProfiles[profile_by_peer].ingame_display_name
				end

				local time = Managers.time:time("game")
				local flag

				flag = not arg_98_2.duration and arg_98_1.start_time == nil and 0 and math.min(1, (time - arg_98_1.start_time) / arg_98_2.duration)

				local flag_2

				flag_2 = not (not flag and flag > 0) and "interaction_action_healing" and "interaction_action_heal"

				return str, flag_2
			end
		end,
		camera_node = function (arg_99_0, arg_99_1)
			-- function 99
			if arg_99_0 == arg_99_1 then
				return "heal_self"
			else
				return "heal_other"
			end
		end
	}
}

local InteractionDefinitions_3 = InteractionDefinitions
local linker_transportation_unit = InteractionDefinitions.linker_transportation_unit

linker_transportation_unit = linker_transportation_unit or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_3.linker_transportation_unit = linker_transportation_unit
InteractionDefinitions.linker_transportation_unit.config.swap_to_3p = false

InteractionDefinitions.linker_transportation_unit.client.hud_description = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3)
	-- function 100
	local str = "interaction_action_activate"

	if not arg_100_3 then
		if arg_100_3 == "enemies_inside" then
			str = "interaction_action_hostiles_close"
		elseif arg_100_3 == "players_missing" then
			str = "interaction_action_missing_players"
		end
	end

	return Unit.get_data(arg_100_0, "interaction_data", "hud_description"), str
end

InteractionDefinitions.linker_transportation_unit.client.stop = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6)
	-- function 101
	arg_101_3.start_time = nil

	if arg_101_6 == InteractionResult.SUCCESS then
		if not Unit.get_data(arg_101_2, "interaction_data", "only_once") then
			Unit.set_data(arg_101_2, "interaction_data", "used", true)
		end

		ScriptUnit.extension(arg_101_2, "transportation_system"):interacted_with(arg_101_1)
	end

	Unit.set_data(arg_101_2, "interaction_data", "being_used", false)
end

local tbl = {}

InteractionDefinitions.linker_transportation_unit.client.can_interact = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3)
	-- function 102
	local extension = ScriptUnit.extension(arg_102_1, "transportation_system")
	local can_interact = extension:can_interact(arg_102_0)

	if not (Unit.get_data(arg_102_1, "interaction_data", "used") or can_interact) then
		return false
	end

	local units_inside_oobb = extension.units_inside_oobb

	if not units_inside_oobb then
		if units_inside_oobb.ai.count > 0 then
			local side = Managers.state.side

			for k in pairs(units_inside_oobb.ai.units) do
				if not side:is_enemy(arg_102_0, k) then
					return false, "enemies_inside"
				end
			end
		end

		local PLAYER_UNITS = Managers.state.side.side_by_unit[arg_102_0].PLAYER_UNITS
		local count = units_inside_oobb.human.count
		local num = 0
		local extension_2 = ScriptUnit.extension
		local count_2 = #PLAYER_UNITS

		for j = 1, count_2 do
			local var_102_9 = PLAYER_UNITS[j]
			local var_102_10 = extension_2(var_102_9, "status_system")
			local var_102_11 = HEALTH_ALIVE[var_102_9]
			local is_ready_for_assisted_respawn = var_102_10:is_ready_for_assisted_respawn()

			if not (not var_102_11 and is_ready_for_assisted_respawn) then
				num = num + 1
			end
		end

		if count < num then
			return false, "players_missing"
		end
	end

	return true
end

local InteractionDefinitions_4 = InteractionDefinitions
local door = InteractionDefinitions.door

door = door or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_4.door = door
InteractionDefinitions.door.config.swap_to_3p = false
InteractionDefinitions.door.config.block_other_interactions = true
InteractionDefinitions.door.config.allow_movement = true

InteractionDefinitions.door.client.stop = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4, arg_103_5, arg_103_6)
	-- function 103
	arg_103_3.start_time = nil

	if arg_103_6 == InteractionResult.SUCCESS then
		ScriptUnit.extension(arg_103_2, "door_system"):interacted_with(arg_103_1)
	end

	Unit.set_data(arg_103_2, "interaction_data", "being_used", false)
end

InteractionDefinitions.door.client.hud_description = function (arg_104_0, arg_104_1, arg_104_2)
	-- function 104
	local flag

	flag = not ScriptUnit.extension(arg_104_0, "door_system"):is_open() and "interaction_action_close" and "interaction_action_open"

	return Unit.get_data(arg_104_0, "interaction_data", "hud_description"), flag
end

local tbl_2 = {}
local InteractionDefinitions_5 = InteractionDefinitions
local chest = InteractionDefinitions.chest

chest = chest or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_5.chest = chest
InteractionDefinitions.chest.config.swap_to_3p = false
InteractionDefinitions.chest.config.block_other_interactions = true
InteractionDefinitions.chest.config.allow_movement = true

InteractionDefinitions.chest.client.start = function (arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4, arg_105_5)
	-- function 105
	arg_105_3.start_time = arg_105_5

	local get_data = Unit.get_data(arg_105_2, "interaction_data", "interaction_length")

	arg_105_3.duration = get_data

	local get_data_2 = Unit.get_data(arg_105_2, "interaction_data", "interactor_animation")
	local get_data_3 = Unit.get_data(arg_105_2, "interaction_data", "interactor_animation_time_variable")
	local extension = ScriptUnit.extension(arg_105_1, "inventory_system")

	if not get_data_2 then
		local animation_find_variable = Unit.animation_find_variable(arg_105_1, get_data_3)

		Unit.animation_set_variable(arg_105_1, animation_find_variable, get_data)
		Unit.animation_event(arg_105_1, get_data_2)
	end

	local get_data_4 = Unit.get_data(arg_105_2, "interaction_data", "interactable_animation")
	local get_data_5 = Unit.get_data(arg_105_2, "interaction_data", "interactable_animation_time_variable")

	if not get_data_4 then
		local animation_find_variable_2 = Unit.animation_find_variable(arg_105_2, get_data_5)

		Unit.animation_set_variable(arg_105_2, animation_find_variable_2, get_data)
		Unit.animation_event(arg_105_2, get_data_4)
	end

	Unit.set_data(arg_105_2, "interaction_data", "being_used", true)
end

InteractionDefinitions.chest.server.stop = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4, arg_106_5, arg_106_6)
	-- function 106
	arg_106_3.start_time = nil

	local flag = arg_106_6 == InteractionResult.SUCCESS

	if not Unit.get_data(arg_106_2, "can_spawn_dice") and not Managers.weave:get_active_weave() then
		return
	end

	table.clear(tbl_2)

	local str = "loot_die"
	local dice_keeper = arg_106_3.dice_keeper
	local var_106_3 = AllPickups[str]

	tbl_2.dice_keeper = dice_keeper

	if not flag and not var_106_3.can_spawn_func(tbl_2) then
		local extension = ScriptUnit.extension(arg_106_1, "buff_system")
		local random = math.random()
		local chest_loot_dice_chance = dice_keeper:chest_loot_dice_chance()

		if random < extension:apply_buffs_to_value(chest_loot_dice_chance, "increase_luck") then
			local tbl = {
				pickup_system = {
					has_physics = true,
					spawn_type = "rare",
					pickup_name = str
				}
			}
			local unit_name = var_106_3.unit_name
			local unit_template_name = var_106_3.unit_template_name

			unit_template_name = unit_template_name or "pickup_unit"

			local num = Unit.local_position(arg_106_2, 0) + Vector3(0, 0, 0.3)
			local local_rotation = Unit.local_rotation(arg_106_2, 0)

			Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, num, local_rotation)
			dice_keeper:bonus_dice_spawned()
		end
	end

	Unit.set_data(arg_106_2, "interaction_data", "being_used", false)
end

local InteractionDefinitions_6 = InteractionDefinitions
local inventory_access = InteractionDefinitions.inventory_access

inventory_access = inventory_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_6.inventory_access = inventory_access
InteractionDefinitions.inventory_access.config.swap_to_3p = false

InteractionDefinitions.inventory_access.client.can_interact = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3)
	-- function 107
	return true
end

InteractionDefinitions.inventory_access.client.stop = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4, arg_108_5, arg_108_6)
	-- function 108
	arg_108_3.start_time = nil

	if not (arg_108_6 ~= InteractionResult.SUCCESS or arg_108_3.is_husk) then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "equipment",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

InteractionDefinitions.inventory_access.client.hud_description = function (arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4)
	-- function 109
	return Unit.get_data(arg_109_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_7 = InteractionDefinitions
local prestige_access = InteractionDefinitions.prestige_access

prestige_access = prestige_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_7.prestige_access = prestige_access
InteractionDefinitions.prestige_access.config.swap_to_3p = false

InteractionDefinitions.prestige_access.client.can_interact = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3)
	-- function 110
	return true
end

InteractionDefinitions.prestige_access.client.stop = function (arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4, arg_111_5, arg_111_6)
	-- function 111
	arg_111_3.start_time = nil

	if not (arg_111_6 ~= InteractionResult.SUCCESS or arg_111_3.is_husk) then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "prestige",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

InteractionDefinitions.prestige_access.client.can_interact = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3)
	-- function 112
	return false
end

InteractionDefinitions.prestige_access.client.hud_description = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4)
	-- function 113
	return Unit.get_data(arg_113_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_8 = InteractionDefinitions
local forge_access = InteractionDefinitions.forge_access

forge_access = forge_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_8.forge_access = forge_access
InteractionDefinitions.forge_access.config.swap_to_3p = false

InteractionDefinitions.forge_access.client.stop = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3, arg_114_4, arg_114_5, arg_114_6)
	-- function 114
	arg_114_3.start_time = nil

	if not (arg_114_6 ~= InteractionResult.SUCCESS or arg_114_3.is_husk) then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "forge",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

InteractionDefinitions.forge_access.client.can_interact = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3)
	-- function 115
	return not GameSettingsDevelopment.read_only_backend
end

InteractionDefinitions.forge_access.client.hud_description = function (arg_116_0, arg_116_1, arg_116_2, arg_116_3, arg_116_4)
	-- function 116
	return Unit.get_data(arg_116_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_9 = InteractionDefinitions
local talents_access = InteractionDefinitions.talents_access

talents_access = talents_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_9.talents_access = talents_access
InteractionDefinitions.talents_access.config.swap_to_3p = false

InteractionDefinitions.talents_access.client.stop = function (arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4, arg_117_5, arg_117_6)
	-- function 117
	arg_117_3.start_time = nil

	if not (arg_117_6 ~= InteractionResult.SUCCESS or arg_117_3.is_husk) then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "talents",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

InteractionDefinitions.talents_access.client.can_interact = function (arg_118_0, arg_118_1, arg_118_2, arg_118_3)
	-- function 118
	return true
end

InteractionDefinitions.talents_access.client.hud_description = function (arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4)
	-- function 119
	return Unit.get_data(arg_119_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_10 = InteractionDefinitions
local loadout_access = InteractionDefinitions.loadout_access

loadout_access = loadout_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_10.loadout_access = loadout_access
InteractionDefinitions.loadout_access.config.swap_to_3p = false

InteractionDefinitions.loadout_access.client.stop = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4, arg_120_5, arg_120_6)
	-- function 120
	arg_120_3.start_time = nil

	if not (arg_120_6 ~= InteractionResult.SUCCESS or arg_120_3.is_husk) then
		Managers.ui:handle_transition("character_selection_force", {
			use_fade = true,
			menu_state_name = "loadouts"
		})
	end
end

InteractionDefinitions.loadout_access.client.can_interact = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3)
	-- function 121
	return true
end

InteractionDefinitions.loadout_access.client.hud_description = function (arg_122_0, arg_122_1, arg_122_2, arg_122_3, arg_122_4)
	-- function 122
	return Unit.get_data(arg_122_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_11 = InteractionDefinitions
local cosmetics_access = InteractionDefinitions.cosmetics_access

cosmetics_access = cosmetics_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_11.cosmetics_access = cosmetics_access
InteractionDefinitions.cosmetics_access.config.swap_to_3p = false

InteractionDefinitions.cosmetics_access.client.stop = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4, arg_123_5, arg_123_6)
	-- function 123
	arg_123_3.start_time = nil

	if not (arg_123_6 ~= InteractionResult.SUCCESS or arg_123_3.is_husk) then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "cosmetics",
			menu_state_name = "overview",
			use_fade = true
		})
	end
end

InteractionDefinitions.cosmetics_access.client.can_interact = function (arg_124_0, arg_124_1, arg_124_2, arg_124_3)
	-- function 124
	return true
end

InteractionDefinitions.cosmetics_access.client.hud_description = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3, arg_125_4)
	-- function 125
	return Unit.get_data(arg_125_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_12 = InteractionDefinitions
local loot_access = InteractionDefinitions.loot_access

loot_access = loot_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_12.loot_access = loot_access
InteractionDefinitions.loot_access.config.swap_to_3p = false

InteractionDefinitions.loot_access.client.stop = function (arg_126_0, arg_126_1, arg_126_2, arg_126_3, arg_126_4, arg_126_5, arg_126_6)
	-- function 126
	arg_126_3.start_time = nil

	if not (arg_126_6 ~= InteractionResult.SUCCESS or arg_126_3.is_husk) then
		Managers.ui:handle_transition("hero_view_force", {
			use_fade = true,
			menu_state_name = "loot"
		})
	end
end

InteractionDefinitions.loot_access.client.can_interact = function (arg_127_0, arg_127_1, arg_127_2, arg_127_3)
	-- function 127
	return not GameSettingsDevelopment.read_only_backend
end

InteractionDefinitions.loot_access.client.hud_description = function (arg_128_0, arg_128_1, arg_128_2, arg_128_3, arg_128_4)
	-- function 128
	return Unit.get_data(arg_128_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_13 = InteractionDefinitions
local characters_access = InteractionDefinitions.characters_access

characters_access = characters_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_13.characters_access = characters_access
InteractionDefinitions.characters_access.config.swap_to_3p = false

InteractionDefinitions.characters_access.client.stop = function (arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4, arg_129_5, arg_129_6)
	-- function 129
	arg_129_3.start_time = nil

	if not (arg_129_6 ~= InteractionResult.SUCCESS or arg_129_3.is_husk) then
		Managers.ui:handle_transition("character_selection_force", {
			use_fade = true,
			menu_state_name = "character"
		})
	end
end

InteractionDefinitions.characters_access.client.can_interact = function (arg_130_0, arg_130_1, arg_130_2, arg_130_3)
	-- function 130
	return true
end

InteractionDefinitions.characters_access.client.hud_description = function (arg_131_0, arg_131_1, arg_131_2, arg_131_3, arg_131_4)
	-- function 131
	return Unit.get_data(arg_131_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_14 = InteractionDefinitions
local altar_access = InteractionDefinitions.altar_access

altar_access = altar_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_14.altar_access = altar_access
InteractionDefinitions.altar_access.config.swap_to_3p = false

InteractionDefinitions.altar_access.client.stop = function (arg_132_0, arg_132_1, arg_132_2, arg_132_3, arg_132_4, arg_132_5, arg_132_6)
	-- function 132
	arg_132_3.start_time = nil

	if not (arg_132_6 ~= InteractionResult.SUCCESS or arg_132_3.is_husk) then
		Managers.ui:handle_transition("altar_view_force", {
			use_fade = true
		})
	end
end

InteractionDefinitions.altar_access.client.can_interact = function (arg_133_0, arg_133_1, arg_133_2, arg_133_3)
	-- function 133
	return false
end

local InteractionDefinitions_15 = InteractionDefinitions
local quest_access = InteractionDefinitions.quest_access

quest_access = quest_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_15.quest_access = quest_access
InteractionDefinitions.quest_access.config.swap_to_3p = false

InteractionDefinitions.quest_access.client.stop = function (arg_134_0, arg_134_1, arg_134_2, arg_134_3, arg_134_4, arg_134_5, arg_134_6)
	-- function 134
	arg_134_3.start_time = nil

	if not (arg_134_6 ~= InteractionResult.SUCCESS or arg_134_3.is_husk) then
		Managers.ui:handle_transition("quest_view_force", {
			use_fade = true
		})
	end
end

InteractionDefinitions.quest_access.client.can_interact = function (arg_135_0, arg_135_1, arg_135_2, arg_135_3)
	-- function 135
	local flag = false
	local backend_settings = GameSettingsDevelopment.backend_settings
	local flag_2 = not flag and backend_settings.quests_enabled
	local flag_3 = not not flag_2 or "quest_access_locked"

	return flag_2, flag_3
end

InteractionDefinitions.quest_access.client.hud_description = function (arg_136_0, arg_136_1, arg_136_2, arg_136_3, arg_136_4)
	-- function 136
	if not (not arg_136_3 and arg_136_3 ~= "quest_access_locked") then
		return Unit.get_data(arg_136_0, "interaction_data", "hud_description"), "dlc1_3_1_interact_open_quests_blocked"
	end

	return Unit.get_data(arg_136_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_16 = InteractionDefinitions
local journal_access = InteractionDefinitions.journal_access

journal_access = journal_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_16.journal_access = journal_access
InteractionDefinitions.journal_access.config.swap_to_3p = false

InteractionDefinitions.journal_access.client.stop = function (arg_137_0, arg_137_1, arg_137_2, arg_137_3, arg_137_4, arg_137_5, arg_137_6)
	-- function 137
	arg_137_3.start_time = nil

	if not (arg_137_6 ~= InteractionResult.SUCCESS or arg_137_3.is_husk) then
		Managers.ui:handle_transition("lorebook_view_force", {
			use_fade = true
		})
	end
end

InteractionDefinitions.journal_access.client.can_interact = function (arg_138_0, arg_138_1, arg_138_2, arg_138_3)
	-- function 138
	return true
end

local InteractionDefinitions_17 = InteractionDefinitions
local map_access = InteractionDefinitions.map_access

map_access = map_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_17.map_access = map_access
InteractionDefinitions.map_access.config.swap_to_3p = false

InteractionDefinitions.map_access.client.stop = function (arg_139_0, arg_139_1, arg_139_2, arg_139_3, arg_139_4, arg_139_5, arg_139_6)
	-- function 139
	arg_139_3.start_time = nil

	local var_139_0
	local flag

	flag = not Managers.matchmaking:is_in_versus_custom_game_lobby() and "versus_player_hosted_lobby" and nil

	if not (arg_139_6 ~= InteractionResult.SUCCESS or arg_139_3.is_husk) then
		Managers.ui:handle_transition("start_game_view_force", {
			menu_state_name = "play",
			use_fade = true,
			menu_sub_state_name = flag
		})
	end
end

InteractionDefinitions.map_access.client.hud_description = function (arg_140_0, arg_140_1, arg_140_2, arg_140_3, arg_140_4)
	-- function 140
	return Unit.get_data(arg_140_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.map_access.client.can_interact = function (arg_141_0, arg_141_1, arg_141_2, arg_141_3)
	-- function 141
	local var_141_0
	local is_in_versus_custom_game_lobby = Managers.matchmaking:is_in_versus_custom_game_lobby()

	return not Managers.matchmaking:is_game_matchmaking() and is_in_versus_custom_game_lobby
end

local InteractionDefinitions_18 = InteractionDefinitions
local unlock_key_access = InteractionDefinitions.unlock_key_access

unlock_key_access = unlock_key_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_18.unlock_key_access = unlock_key_access
InteractionDefinitions.unlock_key_access.config.swap_to_3p = false

InteractionDefinitions.unlock_key_access.client.stop = function (arg_142_0, arg_142_1, arg_142_2, arg_142_3, arg_142_4, arg_142_5, arg_142_6)
	-- function 142
	arg_142_3.start_time = nil

	if not (arg_142_6 ~= InteractionResult.SUCCESS or arg_142_3.is_husk) then
		Managers.ui:handle_transition("unlock_key_force", {
			use_fade = true
		})
	end
end

InteractionDefinitions.unlock_key_access.client.can_interact = function (arg_143_0, arg_143_1, arg_143_2, arg_143_3)
	-- function 143
	return true
end

for k, v in pairs(InteractionDefinitions) do
	if v.client.camera_node == nil then
		v.client.camera_node = function ()
			-- function 144
			return k
		end
	end

	if v.client.hud_description == nil then
		v.client.hud_description = function ()
			-- function 145
			return "interact_" .. k
		end
	end
end

local InteractionDefinitions_19 = InteractionDefinitions
local pictureframe = InteractionDefinitions.pictureframe

pictureframe = pictureframe or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_19.pictureframe = pictureframe
InteractionDefinitions.pictureframe.config.swap_to_3p = false

InteractionDefinitions.pictureframe.client.stop = function (arg_146_0, arg_146_1, arg_146_2, arg_146_3, arg_146_4, arg_146_5, arg_146_6)
	-- function 146
	arg_146_3.start_time = nil

	if arg_146_6 ~= InteractionResult.SUCCESS or arg_146_3.is_husk or not rawget(_G, "HeroViewStateKeepDecorations") then
		ScriptUnit.extension(arg_146_2, "keep_decoration_system"):interacted_with()
		Managers.ui:handle_transition("hero_view_force", {
			type = "painting",
			menu_state_name = "keep_decorations",
			use_fade = true,
			interactable_unit = arg_146_2
		})
	end
end

InteractionDefinitions.pictureframe.client.can_interact = function (arg_147_0, arg_147_1, arg_147_2, arg_147_3)
	-- function 147
	local can_interact = ScriptUnit.extension(arg_147_1, "keep_decoration_system"):can_interact()
	local get_data = Unit.get_data(arg_147_1, "painting_data", "not_interactable")

	return not can_interact and not get_data
end

InteractionDefinitions.pictureframe.client.hud_description = function (arg_148_0, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
	-- function 148
	local flag

	flag = not (not arg_148_1.is_server and Unit.get_data(arg_148_0, "interaction_data", "view_only")) and "interaction_action_view" and Unit.get_data(arg_148_0, "interaction_data", "hud_interaction_action")

	return Unit.get_data(arg_148_0, "interaction_data", "hud_description"), flag
end

local InteractionDefinitions_20 = InteractionDefinitions
local trophy = InteractionDefinitions.trophy

trophy = trophy or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_20.trophy = trophy
InteractionDefinitions.trophy.config.swap_to_3p = false

InteractionDefinitions.trophy.client.stop = function (arg_149_0, arg_149_1, arg_149_2, arg_149_3, arg_149_4, arg_149_5, arg_149_6)
	-- function 149
	arg_149_3.start_time = nil

	if arg_149_6 ~= InteractionResult.SUCCESS or arg_149_3.is_husk or not rawget(_G, "HeroViewStateKeepDecorations") then
		ScriptUnit.extension(arg_149_2, "keep_decoration_system"):interacted_with()
		Managers.ui:handle_transition("hero_view_force", {
			type = "trophy",
			menu_state_name = "keep_decorations",
			use_fade = true,
			interactable_unit = arg_149_2
		})
	end
end

InteractionDefinitions.trophy.client.can_interact = function (arg_150_0, arg_150_1, arg_150_2, arg_150_3)
	-- function 150
	local can_interact = ScriptUnit.extension(arg_150_1, "keep_decoration_system"):can_interact()
	local get_data = Unit.get_data(arg_150_1, "trophy_data", "not_interactable")

	return not can_interact and not get_data
end

InteractionDefinitions.trophy.client.hud_description = function (arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
	-- function 151
	local flag

	flag = not (not arg_151_1.is_server and Unit.get_data(arg_151_0, "interaction_data", "view_only")) and "interaction_action_view" and Unit.get_data(arg_151_0, "interaction_data", "hud_interaction_action")

	return Unit.get_data(arg_151_0, "interaction_data", "hud_description"), flag
end

local InteractionDefinitions_21 = InteractionDefinitions
local decoration = InteractionDefinitions.decoration

decoration = decoration or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_21.decoration = decoration
InteractionDefinitions.decoration.config.swap_to_3p = false

InteractionDefinitions.decoration.client.stop = function (arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4, arg_152_5, arg_152_6)
	-- function 152
	arg_152_3.start_time = nil

	if arg_152_6 ~= InteractionResult.SUCCESS or arg_152_3.is_husk or not rawget(_G, "HeroViewStateKeepDecorations") then
		Managers.ui:handle_transition("hero_view_force", {
			menu_state_name = "keep_decorations",
			use_fade = true,
			interactable_unit = arg_152_2
		})
	end
end

InteractionDefinitions.decoration.client.can_interact = function (arg_153_0, arg_153_1, arg_153_2, arg_153_3)
	-- function 153
	return Unit.get_data(arg_153_1, "interaction_data", "camera_interaction_name") ~= ""
end

InteractionDefinitions.decoration.client.hud_description = function (arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4)
	-- function 154
	return Unit.get_data(arg_154_0, "interaction_data", "hud_description"), Unit.get_data(arg_154_0, "interaction_data", "hud_interaction_action")
end

local InteractionDefinitions_22 = InteractionDefinitions
local no_interaction_hud_only = InteractionDefinitions.no_interaction_hud_only

no_interaction_hud_only = no_interaction_hud_only or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_22.no_interaction_hud_only = no_interaction_hud_only

InteractionDefinitions.no_interaction_hud_only.client.hud_description = function (arg_155_0, arg_155_1, arg_155_2, arg_155_3)
	-- function 155
	local get_data = Unit.get_data(arg_155_0, "interaction_data", "hud_text_line_1")
	local get_data_2 = Unit.get_data(arg_155_0, "interaction_data", "hud_text_line_2")

	return get_data, get_data_2
end

InteractionDefinitions.no_interaction_hud_only.client.can_interact = function (arg_156_0, arg_156_1, arg_156_2, arg_156_3)
	-- function 156
	return false, ""
end

local InteractionDefinitions_23 = InteractionDefinitions
local achievement_access = InteractionDefinitions.achievement_access

achievement_access = achievement_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_23.achievement_access = achievement_access
InteractionDefinitions.achievement_access.config.swap_to_3p = false

InteractionDefinitions.achievement_access.client.stop = function (arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4, arg_157_5, arg_157_6)
	-- function 157
	arg_157_3.start_time = nil

	if not (arg_157_6 ~= InteractionResult.SUCCESS or arg_157_3.is_husk) then
		Managers.ui:handle_transition("hero_view_force", {
			use_fade = true,
			menu_state_name = "achievements"
		})
	end
end

InteractionDefinitions.achievement_access.client.can_interact = function (arg_158_0, arg_158_1, arg_158_2, arg_158_3)
	-- function 158
	return not script_data.settings.use_beta_mode
end

InteractionDefinitions.achievement_access.client.hud_description = function (arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)
	-- function 159
	return Unit.get_data(arg_159_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_24 = InteractionDefinitions
local luckstone_access = InteractionDefinitions.luckstone_access

luckstone_access = luckstone_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_24.luckstone_access = luckstone_access
InteractionDefinitions.luckstone_access.config.swap_to_3p = false

InteractionDefinitions.luckstone_access.server.stop = function (arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4, arg_160_5, arg_160_6)
	-- function 160
	if arg_160_6 == InteractionResult.SUCCESS then
		local player = Managers.player
		local statistics_db = player:statistics_db()
		local stats_id = player:local_player(1):stats_id()
		local get_persistent_stat = statistics_db:get_persistent_stat(stats_id, "holly_difficulty_selection_plaza")

		if get_persistent_stat == 0 then
			get_persistent_stat = 1
		end

		local tbl = {
			private_game = true,
			mission_id = "plaza",
			strict_matchmaking = false,
			always_host = true,
			matchmaking_type = "event",
			mechanism = "adventure",
			quick_game = false,
			difficulty = DefaultDifficulties[get_persistent_stat],
			event_data = {}
		}
		local owner = Managers.player:owner(arg_160_1)

		Managers.state.voting:request_vote("game_settings_vote", tbl, owner.peer_id)
	end
end

InteractionDefinitions.luckstone_access.client.stop = function (arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4, arg_161_5, arg_161_6)
	-- function 161
	if arg_161_6 == InteractionResult.SUCCESS then
		local world = Managers.world:world("level_world")
		local str = "emitter_rune_activate"
		local node = Unit.node(arg_161_2, "c_interaction")

		WwiseUtils.trigger_unit_event(world, str, arg_161_2, node)
	end
end

local get_data = Unit.get_data

InteractionDefinitions.luckstone_access.client.can_interact = function (arg_162_0, arg_162_1, arg_162_2, arg_162_3)
	-- function 162
	local var_162_0 = get_data(arg_162_1, "cemetery")
	local var_162_1 = get_data(arg_162_1, "forest")
	local var_162_2 = get_data(arg_162_1, "magnus")
	local flag = not var_162_0 and not var_162_1 and var_162_2

	return not not Managers.matchmaking:is_game_matchmaking() or flag
end

InteractionDefinitions.luckstone_access.client.hud_description = function (arg_163_0, arg_163_1, arg_163_2, arg_163_3, arg_163_4)
	-- function 163
	return get_data(arg_163_0, "interaction_data", "hud_description"), Unit.get_data(arg_163_0, "interaction_data", "hud_interaction_action")
end

local InteractionDefinitions_25 = InteractionDefinitions
local str = "difficulty_selection_access"
local difficulty_selection_access = InteractionDefinitions.difficulty_selection_access

difficulty_selection_access = difficulty_selection_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_25[str] = difficulty_selection_access
InteractionDefinitions.difficulty_selection_access.config.swap_to_3p = false

InteractionDefinitions.difficulty_selection_access.server.stop = function (arg_164_0, arg_164_1, arg_164_2, arg_164_3, arg_164_4, arg_164_5, arg_164_6)
	-- function 164
	if arg_164_6 == InteractionResult.SUCCESS then
		local var_164_0 = get_data(arg_164_2, "current_difficulty")
		local str = "scorpion"
		local flag

		flag = not Managers.unlock:is_dlc_unlocked(str) and 4 and 3
		var_164_0 = not (flag < var_164_0) or not 1 or var_164_0 + 1

		local player = Managers.player
		local statistics_db = player:statistics_db()
		local stats_id = player:local_player(1):stats_id()

		statistics_db:set_stat(stats_id, "holly_difficulty_selection_plaza", var_164_0)
		Unit.flow_event(arg_164_2, "lua_update_difficulty_on_success")
	end
end

InteractionDefinitions.difficulty_selection_access.client.can_interact = function (arg_165_0, arg_165_1, arg_165_2, arg_165_3)
	-- function 165
	local var_165_0 = get_data(arg_165_1, "is_interactable")

	return not not Managers.matchmaking:is_game_matchmaking() or var_165_0
end

InteractionDefinitions.difficulty_selection_access.client.hud_description = function (arg_166_0, arg_166_1, arg_166_2, arg_166_3, arg_166_4)
	-- function 166
	local var_166_0 = get_data(arg_166_0, "current_difficulty")

	return get_data(arg_166_0, "interaction_data", "hud_description"), DifficultySettings[DefaultDifficulties[var_166_0]].display_name
end

local InteractionDefinitions_26 = InteractionDefinitions
local str_2 = "handbook_access"
local handbook_access = InteractionDefinitions.handbook_access

handbook_access = handbook_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_26[str_2] = handbook_access
InteractionDefinitions.handbook_access.config.swap_to_3p = false

InteractionDefinitions.handbook_access.client.stop = function (arg_167_0, arg_167_1, arg_167_2, arg_167_3, arg_167_4, arg_167_5, arg_167_6)
	-- function 167
	arg_167_3.start_time = nil

	if not (arg_167_6 ~= InteractionResult.SUCCESS or arg_167_3.is_husk) then
		Managers.ui:handle_transition("hero_view_force", {
			use_fade = true,
			menu_state_name = "handbook"
		})
	end
end

InteractionDefinitions.handbook_access.client.can_interact = function (arg_168_0, arg_168_1, arg_168_2, arg_168_3)
	-- function 168
	return true
end

InteractionDefinitions.handbook_access.client.hud_description = function (arg_169_0, arg_169_1, arg_169_2, arg_169_3, arg_169_4)
	-- function 169
	return Unit.get_data(arg_169_0, "interaction_data", "hud_description"), "interaction_action_open"
end

local InteractionDefinitions_27 = InteractionDefinitions
local str_3 = "inn_door_transition"
local inn_door_transition = InteractionDefinitions.inn_door_transition

inn_door_transition = inn_door_transition or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_27[str_3] = inn_door_transition
InteractionDefinitions.inn_door_transition.config.swap_to_3p = false

InteractionDefinitions.inn_door_transition.client.stop = function (arg_170_0, arg_170_1, arg_170_2, arg_170_3, arg_170_4, arg_170_5, arg_170_6)
	-- function 170
	if not (arg_170_6 ~= InteractionResult.SUCCESS or arg_170_3.is_husk) then
		local get_level_variation_data = Managers.backend:get_level_variation_data()
		local tbl = {
			switch_mechanism = true,
			mechanism = "adventure"
		}
		local hub_level = get_level_variation_data.hub_level

		hub_level = hub_level or "inn_level"
		tbl.level_key = hub_level

		Managers.state.voting:request_vote("game_settings_vote_switch_mechanism", tbl, Network.peer_id())
	end
end

InteractionDefinitions.inn_door_transition.client.hud_description = function (arg_171_0, arg_171_1, arg_171_2, arg_171_3, arg_171_4)
	-- function 171
	return Unit.get_data(arg_171_0, "interaction_data", "hud_description"), "interaction_action_enter"
end

InteractionDefinitions.inn_door_transition.client.can_interact = function (arg_172_0, arg_172_1, arg_172_2, arg_172_3)
	-- function 172
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local vote_in_progress = Managers.state.voting:vote_in_progress()

	return not not is_game_matchmaking or not vote_in_progress
end

local InteractionDefinitions_28 = InteractionDefinitions
local str_4 = "deus_door_transition"
local deus_door_transition = InteractionDefinitions.deus_door_transition

deus_door_transition = deus_door_transition or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_28[str_4] = deus_door_transition
InteractionDefinitions.deus_door_transition.config.swap_to_3p = false

InteractionDefinitions.deus_door_transition.client.stop = function (arg_173_0, arg_173_1, arg_173_2, arg_173_3, arg_173_4, arg_173_5, arg_173_6)
	-- function 173
	if not (arg_173_6 ~= InteractionResult.SUCCESS or arg_173_3.is_husk) then
		local get_level_variation_data = Managers.backend:get_level_variation_data()
		local tbl = {
			switch_mechanism = true,
			mechanism = "deus",
			level_key = "morris_hub"
		}

		Managers.state.voting:request_vote("game_settings_vote_switch_mechanism", tbl, Network.peer_id())
	end
end

InteractionDefinitions.deus_door_transition.client.hud_description = function (arg_174_0, arg_174_1, arg_174_2, arg_174_3, arg_174_4)
	-- function 174
	return Unit.get_data(arg_174_0, "interaction_data", "hud_description"), "interaction_action_enter"
end

InteractionDefinitions.deus_door_transition.client.can_interact = function (arg_175_0, arg_175_1, arg_175_2, arg_175_3)
	-- function 175
	if not DLCSettings.morris then
		return false
	end

	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local vote_in_progress = Managers.state.voting:vote_in_progress()

	return not not is_game_matchmaking or not vote_in_progress
end

local InteractionDefinitions_29 = InteractionDefinitions
local str_5 = "active_event"
local active_event = InteractionDefinitions.active_event

active_event = active_event or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_29[str_5] = active_event
InteractionDefinitions.active_event.config.swap_to_3p = false

InteractionDefinitions.active_event.client.stop = function (arg_176_0, arg_176_1, arg_176_2, arg_176_3, arg_176_4, arg_176_5, arg_176_6)
	-- function 176
	arg_176_3.start_time = nil

	if not (arg_176_6 ~= InteractionResult.SUCCESS or arg_176_3.is_husk) then
		local get_interface = Managers.backend:get_interface("live_events")
		local flag = not get_interface and get_interface:get_active_events()
		local str = "default_event"

		if not flag then
			for i = 1, #flag do
				local var_176_3 = flag[i]

				if not CommonPopupSettings[var_176_3] then
					str = var_176_3

					break
				end
			end
		end

		Managers.state.event:trigger("ui_show_popup", str, "active_event")
	end
end

InteractionDefinitions.active_event.client.can_interact = function (arg_177_0, arg_177_1, arg_177_2, arg_177_3)
	-- function 177
	local get_interface = Managers.backend:get_interface("live_events")
	local flag = not get_interface and get_interface:get_active_events()

	return not flag and #flag ~= 0
end

InteractionDefinitions.active_event.client.hud_description = function (arg_178_0, arg_178_1, arg_178_2, arg_178_3, arg_178_4)
	-- function 178
	return Unit.get_data(arg_178_0, "interaction_data", "hud_description"), "interaction_action_open"
end

DLCUtils.require_list("interactions_filenames")
