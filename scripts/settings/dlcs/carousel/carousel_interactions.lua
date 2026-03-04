-- chunkname: @scripts/settings/dlcs/carousel/carousel_interactions.lua

local var_0_0 = table.set({
	"firing",
	"winding"
})

InteractionDefinitions.carousel_dark_pact_climb = {
	config = {
		timeout_duration = 5,
		hold = false,
		swap_to_3p = false,
		duration = 0,
		show_weapons = true
	},
	client = {
		start = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
			ScriptUnit.extension(arg_1_1, "status_system"):set_should_climb(true)
		end,
		update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
			if ScriptUnit.extension(arg_2_1, "status_system"):should_climb() then
				return InteractionResult.ONGOING
			end

			return InteractionResult.SUCCESS
		end,
		stop = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
			return
		end,
		get_progress = function(arg_4_0, arg_4_1, arg_4_2)
			return 0
		end,
		can_interact = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			if not Managers.state.side:versus_is_dark_pact(arg_5_0) then
				return false
			end

			local var_5_0 = ScriptUnit.extension(arg_5_0, "status_system")

			if var_5_0:breed_action() or var_5_0:should_climb() then
				return false
			end

			local var_5_1 = Managers.state.entity:system("weapon_system"):get_synced_weapon_state(arg_5_0)

			if var_0_0[var_5_1] then
				return false
			end

			if Unit.get_data(arg_5_0, "breed").boss and not Unit.get_data(arg_5_1, "allow_boss_traversal") then
				return false
			end

			return true
		end,
		hud_description = function(arg_6_0, arg_6_1, arg_6_2)
			return Unit.get_data(arg_6_0, "interaction_data", "hud_description"), Unit.get_data(arg_6_0, "interaction_data", "hud_interaction_action")
		end,
		in_range = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
			if arg_7_5 then
				local var_7_0 = Managers.world:wwise_world(arg_7_4)

				WwiseWorld.trigger_event(var_7_0, "versus_climb_node_indicator")
			end
		end
	}
}
InteractionDefinitions.carousel_dark_pact_tunnel = {
	config = {
		show_weapons = true,
		duration = 0,
		hold = false,
		swap_to_3p = false
	},
	server = {
		start = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
			return
		end,
		update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
			local var_9_0 = ScriptUnit.extension(arg_9_1, "status_system"):breed_action()

			if var_9_0 and var_9_0.name == "tunneling" then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
			return
		end,
		can_interact = function(arg_11_0, arg_11_1)
			local var_11_0 = ScriptUnit.extension(arg_11_0, "status_system")

			if not var_11_0.breed_action then
				return
			end

			return not var_11_0:breed_action()
		end
	},
	client = {
		start = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
			ScriptUnit.extension(arg_12_1, "status_system"):set_should_tunnel(true)
		end,
		update = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
			if ScriptUnit.extension(arg_13_1, "status_system"):should_tunnel() then
				return InteractionResult.ONGOING
			end

			return InteractionResult.SUCCESS
		end,
		stop = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
			return
		end,
		get_progress = function(arg_15_0, arg_15_1, arg_15_2)
			return 0
		end,
		can_interact = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
			local var_16_0 = ScriptUnit.extension(arg_16_0, "status_system")

			if not var_16_0.breed_action or not var_16_0.should_tunnel then
				return
			end

			return not var_16_0:breed_action() and not var_16_0:should_tunnel()
		end,
		hud_description = function(arg_17_0, arg_17_1, arg_17_2)
			return Unit.get_data(arg_17_0, "interaction_data", "hud_description"), Unit.get_data(arg_17_0, "interaction_data", "hud_interaction_action")
		end,
		in_range = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
			return
		end
	}
}
InteractionDefinitions.carousel_dark_pact_spawner = {
	config = {
		show_weapons = true,
		duration = 0,
		hold = false,
		swap_to_3p = false
	},
	server = {
		start = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
			return
		end,
		update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
			local var_20_0 = ScriptUnit.extension(arg_20_1, "status_system"):breed_action()

			if var_20_0 and var_20_0.name == "spawning" then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
			return
		end,
		can_interact = function(arg_22_0, arg_22_1)
			local var_22_0 = ScriptUnit.extension(arg_22_0, "status_system")

			if not var_22_0.breed_action then
				return
			end

			return not var_22_0:breed_action()
		end
	},
	client = {
		start = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
			ScriptUnit.extension(arg_23_1, "status_system"):set_should_spawn(true)
		end,
		update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			if ScriptUnit.extension(arg_24_1, "status_system"):should_spawn() then
				return InteractionResult.ONGOING
			end

			return InteractionResult.SUCCESS
		end,
		stop = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
			return
		end,
		get_progress = function(arg_26_0, arg_26_1, arg_26_2)
			return 0
		end,
		can_interact = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			local var_27_0 = ScriptUnit.extension(arg_27_0, "status_system")

			if not var_27_0.breed_action then
				return
			end

			return not var_27_0:breed_action() and not var_27_0:should_spawn()
		end,
		hud_description = function(arg_28_0, arg_28_1, arg_28_2)
			return Unit.get_data(arg_28_0, "interaction_data", "hud_description"), Unit.get_data(arg_28_0, "interaction_data", "hud_interaction_action")
		end,
		in_range = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
			return
		end
	}
}
InteractionDefinitions.carousel_start_versus = {
	config = {
		show_weapons = true,
		duration = 0,
		hold = true,
		swap_to_3p = false
	},
	server = {
		start = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
			return
		end,
		update = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6)
			return InteractionResult.SUCCESS
		end,
		stop = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
			if arg_32_6 == InteractionResult.SUCCESS then
				local var_32_0 = {
					level_key = "carousel_hub",
					mechanism_key = "versus"
				}
				local var_32_1 = Managers.player:owner(arg_32_1)

				Managers.state.voting:request_vote("change_game_mode", var_32_0, var_32_1.peer_id)

				local var_32_2 = ScriptUnit.extension(arg_32_2, "interactable_system")

				var_32_2.num_times_successfully_completed = var_32_2.num_times_successfully_completed + 1
			end
		end,
		can_interact = function(arg_33_0, arg_33_1)
			local var_33_0 = Unit.get_data(arg_33_1, "interaction_data", "used")
			local var_33_1 = Managers.matchmaking:are_all_players_spawned()

			return not var_33_0 and var_33_1
		end
	},
	client = {
		start = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
			return
		end,
		update = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6)
			return InteractionResult.SUCCESS
		end,
		stop = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
			arg_36_3.start_time = nil

			Unit.animation_event(arg_36_1, "interaction_end")

			if arg_36_6 == InteractionResult.SUCCESS and Unit.get_data(arg_36_2, "interaction_data", "only_once") then
				Unit.set_data(arg_36_2, "interaction_data", "used", true)
			end

			Unit.set_data(arg_36_2, "interaction_data", "being_used", false)
		end,
		get_progress = function(arg_37_0, arg_37_1, arg_37_2)
			return 0
		end,
		can_interact = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
			local var_38_0 = Unit.get_data(arg_38_1, "interaction_data", "used")
			local var_38_1 = Unit.get_data(arg_38_1, "interaction_data", "being_used")
			local var_38_2 = Managers.matchmaking:are_all_players_spawned()

			return not var_38_0 and not var_38_1 and var_38_2
		end,
		hud_description = function(arg_39_0, arg_39_1, arg_39_2)
			return Unit.get_data(arg_39_0, "interaction_data", "hud_description"), Unit.get_data(arg_39_0, "interaction_data", "hud_interaction_action")
		end
	}
}
InteractionDefinitions.carousel_door_transition = InteractionDefinitions.carousel_door_transition or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.carousel_door_transition.config.swap_to_3p = false

function InteractionDefinitions.carousel_door_transition.client.stop(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6)
	if arg_40_6 == InteractionResult.SUCCESS and not arg_40_3.is_husk then
		local var_40_0 = Managers.backend:get_level_variation_data()
		local var_40_1 = {
			switch_mechanism = true,
			mechanism = "versus",
			level_key = "carousel_hub"
		}

		Managers.state.voting:request_vote("game_settings_vote_switch_mechanism", var_40_1, Network.peer_id())
	end
end

function InteractionDefinitions.carousel_door_transition.client.hud_description(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	return Unit.get_data(arg_41_0, "interaction_data", "hud_description"), "interaction_action_enter"
end

function InteractionDefinitions.carousel_door_transition.client.can_interact(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	if not DLCSettings.carousel then
		return false
	end

	local var_42_0 = Managers.matchmaking:is_game_matchmaking()
	local var_42_1 = Managers.state.voting:vote_in_progress()

	return not var_42_0 and not var_42_1
end

InteractionDefinitions.versus_map_access = InteractionDefinitions.versus_map_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.versus_map_access.config.swap_to_3p = false

function InteractionDefinitions.versus_map_access.client.stop(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
	arg_43_3.start_time = nil

	if arg_43_6 == InteractionResult.SUCCESS and not arg_43_3.is_husk then
		Managers.ui:handle_transition("start_game_view_force", {
			use_fade = true,
			menu_state_name = "play"
		})
	end
end

function InteractionDefinitions.versus_map_access.client.hud_description(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	return Unit.get_data(arg_44_0, "interaction_data", "hud_description"), "interaction_action_open"
end

function InteractionDefinitions.versus_map_access.client.can_interact(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	return not Managers.matchmaking:is_game_matchmaking()
end
