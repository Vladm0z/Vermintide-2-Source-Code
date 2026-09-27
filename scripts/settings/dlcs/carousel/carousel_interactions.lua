-- chunkname: @scripts/settings/dlcs/carousel/carousel_interactions.lua

local set = table.set({
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
		start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
			-- function 1
			ScriptUnit.extension(arg_1_1, "status_system"):set_should_climb(true)
		end,
		update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
			-- function 2
			if not ScriptUnit.extension(arg_2_1, "status_system"):should_climb() then
				return InteractionResult.ONGOING
			end

			return InteractionResult.SUCCESS
		end,
		stop = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
			-- function 3
			return
		end,
		get_progress = function (arg_4_0, arg_4_1, arg_4_2)
			-- function 4
			return 0
		end,
		can_interact = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			-- function 5
			if not Managers.state.side:versus_is_dark_pact(arg_5_0) then
				return false
			end

			local extension = ScriptUnit.extension(arg_5_0, "status_system")

			if extension:breed_action() or not extension:should_climb() then
				return false
			end

			local get_synced_weapon_state = Managers.state.entity:system("weapon_system"):get_synced_weapon_state(arg_5_0)

			if not set[get_synced_weapon_state] then
				return false
			end

			if not (not Unit.get_data(arg_5_0, "breed").boss and Unit.get_data(arg_5_1, "allow_boss_traversal")) then
				return false
			end

			return true
		end,
		hud_description = function (arg_6_0, arg_6_1, arg_6_2)
			-- function 6
			return Unit.get_data(arg_6_0, "interaction_data", "hud_description"), Unit.get_data(arg_6_0, "interaction_data", "hud_interaction_action")
		end,
		in_range = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
			-- function 7
			if not arg_7_5 then
				local wwise_world = Managers.world:wwise_world(arg_7_4)

				WwiseWorld.trigger_event(wwise_world, "versus_climb_node_indicator")
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
		start = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
			-- function 8
			return
		end,
		update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
			-- function 9
			local breed_action = ScriptUnit.extension(arg_9_1, "status_system"):breed_action()

			if not (not breed_action and breed_action.name ~= "tunneling") then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
			-- function 10
			return
		end,
		can_interact = function (arg_11_0, arg_11_1)
			-- function 11
			local extension = ScriptUnit.extension(arg_11_0, "status_system")

			if not extension.breed_action then
				return
			end

			return not extension:breed_action()
		end
	},
	client = {
		start = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
			-- function 12
			ScriptUnit.extension(arg_12_1, "status_system"):set_should_tunnel(true)
		end,
		update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
			-- function 13
			if not ScriptUnit.extension(arg_13_1, "status_system"):should_tunnel() then
				return InteractionResult.ONGOING
			end

			return InteractionResult.SUCCESS
		end,
		stop = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
			-- function 14
			return
		end,
		get_progress = function (arg_15_0, arg_15_1, arg_15_2)
			-- function 15
			return 0
		end,
		can_interact = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
			-- function 16
			local extension = ScriptUnit.extension(arg_16_0, "status_system")

			if not (not extension.breed_action and extension.should_tunnel) then
				return
			end

			return not not extension:breed_action() or not extension:should_tunnel()
		end,
		hud_description = function (arg_17_0, arg_17_1, arg_17_2)
			-- function 17
			return Unit.get_data(arg_17_0, "interaction_data", "hud_description"), Unit.get_data(arg_17_0, "interaction_data", "hud_interaction_action")
		end,
		in_range = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
			-- function 18
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
		start = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
			-- function 19
			return
		end,
		update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
			-- function 20
			local breed_action = ScriptUnit.extension(arg_20_1, "status_system"):breed_action()

			if not (not breed_action and breed_action.name ~= "spawning") then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
			-- function 21
			return
		end,
		can_interact = function (arg_22_0, arg_22_1)
			-- function 22
			local extension = ScriptUnit.extension(arg_22_0, "status_system")

			if not extension.breed_action then
				return
			end

			return not extension:breed_action()
		end
	},
	client = {
		start = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
			-- function 23
			ScriptUnit.extension(arg_23_1, "status_system"):set_should_spawn(true)
		end,
		update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			-- function 24
			if not ScriptUnit.extension(arg_24_1, "status_system"):should_spawn() then
				return InteractionResult.ONGOING
			end

			return InteractionResult.SUCCESS
		end,
		stop = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
			-- function 25
			return
		end,
		get_progress = function (arg_26_0, arg_26_1, arg_26_2)
			-- function 26
			return 0
		end,
		can_interact = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			-- function 27
			local extension = ScriptUnit.extension(arg_27_0, "status_system")

			if not extension.breed_action then
				return
			end

			return not not extension:breed_action() or not extension:should_spawn()
		end,
		hud_description = function (arg_28_0, arg_28_1, arg_28_2)
			-- function 28
			return Unit.get_data(arg_28_0, "interaction_data", "hud_description"), Unit.get_data(arg_28_0, "interaction_data", "hud_interaction_action")
		end,
		in_range = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
			-- function 29
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
		start = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
			-- function 30
			return
		end,
		update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6)
			-- function 31
			return InteractionResult.SUCCESS
		end,
		stop = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
			-- function 32
			if arg_32_6 == InteractionResult.SUCCESS then
				local tbl = {
					level_key = "carousel_hub",
					mechanism_key = "versus"
				}
				local owner = Managers.player:owner(arg_32_1)

				Managers.state.voting:request_vote("change_game_mode", tbl, owner.peer_id)

				local extension = ScriptUnit.extension(arg_32_2, "interactable_system")

				extension.num_times_successfully_completed = extension.num_times_successfully_completed + 1
			end
		end,
		can_interact = function (arg_33_0, arg_33_1)
			-- function 33
			local get_data = Unit.get_data(arg_33_1, "interaction_data", "used")
			local are_all_players_spawned = Managers.matchmaking:are_all_players_spawned()

			return not not get_data or are_all_players_spawned
		end
	},
	client = {
		start = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
			-- function 34
			return
		end,
		update = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6)
			-- function 35
			return InteractionResult.SUCCESS
		end,
		stop = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
			-- function 36
			arg_36_3.start_time = nil

			Unit.animation_event(arg_36_1, "interaction_end")

			if arg_36_6 ~= InteractionResult.SUCCESS or not Unit.get_data(arg_36_2, "interaction_data", "only_once") then
				Unit.set_data(arg_36_2, "interaction_data", "used", true)
			end

			Unit.set_data(arg_36_2, "interaction_data", "being_used", false)
		end,
		get_progress = function (arg_37_0, arg_37_1, arg_37_2)
			-- function 37
			return 0
		end,
		can_interact = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
			-- function 38
			local get_data = Unit.get_data(arg_38_1, "interaction_data", "used")
			local get_data_2 = Unit.get_data(arg_38_1, "interaction_data", "being_used")
			local are_all_players_spawned = Managers.matchmaking:are_all_players_spawned()

			return not not get_data or not not get_data_2 or are_all_players_spawned
		end,
		hud_description = function (arg_39_0, arg_39_1, arg_39_2)
			-- function 39
			return Unit.get_data(arg_39_0, "interaction_data", "hud_description"), Unit.get_data(arg_39_0, "interaction_data", "hud_interaction_action")
		end
	}
}

local InteractionDefinitions = InteractionDefinitions
local carousel_door_transition = InteractionDefinitions.carousel_door_transition

carousel_door_transition = carousel_door_transition or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.carousel_door_transition = carousel_door_transition
InteractionDefinitions.carousel_door_transition.config.swap_to_3p = false

InteractionDefinitions.carousel_door_transition.client.stop = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6)
	-- function 40
	if not (arg_40_6 ~= InteractionResult.SUCCESS or arg_40_3.is_husk) then
		local get_level_variation_data = Managers.backend:get_level_variation_data()
		local tbl = {
			switch_mechanism = true,
			mechanism = "versus",
			level_key = "carousel_hub"
		}

		Managers.state.voting:request_vote("game_settings_vote_switch_mechanism", tbl, Network.peer_id())
	end
end

InteractionDefinitions.carousel_door_transition.client.hud_description = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	return Unit.get_data(arg_41_0, "interaction_data", "hud_description"), "interaction_action_enter"
end

InteractionDefinitions.carousel_door_transition.client.can_interact = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	if not DLCSettings.carousel then
		return false
	end

	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local vote_in_progress = Managers.state.voting:vote_in_progress()

	return not not is_game_matchmaking or not vote_in_progress
end

local InteractionDefinitions_2 = InteractionDefinitions
local versus_map_access = InteractionDefinitions.versus_map_access

versus_map_access = versus_map_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_2.versus_map_access = versus_map_access
InteractionDefinitions.versus_map_access.config.swap_to_3p = false

InteractionDefinitions.versus_map_access.client.stop = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
	-- function 43
	arg_43_3.start_time = nil

	if not (arg_43_6 ~= InteractionResult.SUCCESS or arg_43_3.is_husk) then
		Managers.ui:handle_transition("start_game_view_force", {
			use_fade = true,
			menu_state_name = "play"
		})
	end
end

InteractionDefinitions.versus_map_access.client.hud_description = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	-- function 44
	return Unit.get_data(arg_44_0, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.versus_map_access.client.can_interact = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	return not Managers.matchmaking:is_game_matchmaking()
end
