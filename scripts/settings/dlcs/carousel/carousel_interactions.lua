-- chunkname: @scripts/settings/dlcs/carousel/carousel_interactions.lua

local climb_point_ignored_weapon_states = table.set({
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
		start = function (world, interactor_unit, interactable_unit, data, config, t)
			-- function 1
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			status_extension:set_should_climb(true)
		end,
		update = function (world, interactor_unit, interactable_unit, data, config, dt, t)
			-- function 2
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			if status_extension:should_climb() then
				return InteractionResult.ONGOING
			end

			return InteractionResult.SUCCESS
		end,
		stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
			-- function 3
			return
		end,
		get_progress = function (data, config, t)
			-- function 4
			return 0
		end,
		can_interact = function (interactor_unit, interactable_unit, data, config)
			-- function 5
			if not Managers.state.side:versus_is_dark_pact(interactor_unit) then
				return false
			end

			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			if status_extension:breed_action() or status_extension:should_climb() then
				return false
			end

			local weapon_system = Managers.state.entity:system("weapon_system")
			local current_weapon_state = weapon_system:get_synced_weapon_state(interactor_unit)

			if climb_point_ignored_weapon_states[current_weapon_state] then
				return false
			end

			local breed = Unit.get_data(interactor_unit, "breed")
			local is_boss = breed.boss

			if is_boss then
				local boss_allowed = Unit.get_data(interactable_unit, "allow_boss_traversal")

				if not boss_allowed then
					return false
				end
			end

			return true
		end,
		hud_description = function (interactable_unit, data, config)
			-- function 6
			return Unit.get_data(interactable_unit, "interaction_data", "hud_description"), Unit.get_data(interactable_unit, "interaction_data", "hud_interaction_action")
		end,
		in_range = function (interactor_unit, interactable_unit, data, config, world, is_in_range)
			-- function 7
			if is_in_range then
				local wwise_world = Managers.world:wwise_world(world)

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
		start = function (world, interactor_unit, interactable_unit, data, config, t)
			-- function 8
			return
		end,
		update = function (world, interactor_unit, interactable_unit, data, config, dt, t)
			-- function 9
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")
			local breed_action = status_extension:breed_action()

			if breed_action and breed_action.name == "tunneling" then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
			-- function 10
			return
		end,
		can_interact = function (interactor_unit, interactable_unit)
			-- function 11
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			if not status_extension.breed_action then
				return
			end

			return not status_extension:breed_action()
		end
	},
	client = {
		start = function (world, interactor_unit, interactable_unit, data, config, t)
			-- function 12
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			status_extension:set_should_tunnel(true)
		end,
		update = function (world, interactor_unit, interactable_unit, data, config, dt, t)
			-- function 13
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			if status_extension:should_tunnel() then
				return InteractionResult.ONGOING
			end

			return InteractionResult.SUCCESS
		end,
		stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
			-- function 14
			return
		end,
		get_progress = function (data, config, t)
			-- function 15
			return 0
		end,
		can_interact = function (interactor_unit, interactable_unit, data, config)
			-- function 16
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			if not status_extension.breed_action or not status_extension.should_tunnel then
				return
			end

			return not status_extension:breed_action() and not not not status_extension:should_tunnel()
		end,
		hud_description = function (interactable_unit, data, config)
			-- function 17
			return Unit.get_data(interactable_unit, "interaction_data", "hud_description"), Unit.get_data(interactable_unit, "interaction_data", "hud_interaction_action")
		end,
		in_range = function (interactor_unit, interactable_unit, data, config, world, is_in_range)
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
		start = function (world, interactor_unit, interactable_unit, data, config, t)
			-- function 19
			return
		end,
		update = function (world, interactor_unit, interactable_unit, data, config, dt, t)
			-- function 20
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")
			local breed_action = status_extension:breed_action()

			if breed_action and breed_action.name == "spawning" then
				return InteractionResult.SUCCESS
			end

			return InteractionResult.ONGOING
		end,
		stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
			-- function 21
			return
		end,
		can_interact = function (interactor_unit, interactable_unit)
			-- function 22
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			if not status_extension.breed_action then
				return
			end

			return not status_extension:breed_action()
		end
	},
	client = {
		start = function (world, interactor_unit, interactable_unit, data, config, t)
			-- function 23
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			status_extension:set_should_spawn(true)
		end,
		update = function (world, interactor_unit, interactable_unit, data, config, dt, t)
			-- function 24
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			if status_extension:should_spawn() then
				return InteractionResult.ONGOING
			end

			return InteractionResult.SUCCESS
		end,
		stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
			-- function 25
			return
		end,
		get_progress = function (data, config, t)
			-- function 26
			return 0
		end,
		can_interact = function (interactor_unit, interactable_unit, data, config)
			-- function 27
			local status_extension = ScriptUnit.extension(interactor_unit, "status_system")

			if not status_extension.breed_action then
				return
			end

			return not status_extension:breed_action() and not not not status_extension:should_spawn()
		end,
		hud_description = function (interactable_unit, data, config)
			-- function 28
			return Unit.get_data(interactable_unit, "interaction_data", "hud_description"), Unit.get_data(interactable_unit, "interaction_data", "hud_interaction_action")
		end,
		in_range = function (interactor_unit, interactable_unit, data, config, world, is_in_range)
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
		start = function (world, interactor_unit, interactable_unit, data, config, t)
			-- function 30
			return
		end,
		update = function (world, interactor_unit, interactable_unit, data, config, dt, t)
			-- function 31
			return InteractionResult.SUCCESS
		end,
		stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
			-- function 32
			if result == InteractionResult.SUCCESS then
				local vote_data = {
					level_key = "carousel_hub",
					mechanism_key = "versus"
				}
				local interaction_player = Managers.player:owner(interactor_unit)

				Managers.state.voting:request_vote("change_game_mode", vote_data, interaction_player.peer_id)

				local interactable_system = ScriptUnit.extension(interactable_unit, "interactable_system")

				interactable_system.num_times_successfully_completed = interactable_system.num_times_successfully_completed + 1
			end
		end,
		can_interact = function (interactor_unit, interactable_unit)
			-- function 33
			local used = Unit.get_data(interactable_unit, "interaction_data", "used")
			local all_players_spawned = Managers.matchmaking:are_all_players_spawned()

			return not used and not not all_players_spawned
		end
	},
	client = {
		start = function (world, interactor_unit, interactable_unit, data, config, t)
			-- function 34
			return
		end,
		update = function (world, interactor_unit, interactable_unit, data, config, dt, t)
			-- function 35
			return InteractionResult.SUCCESS
		end,
		stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
			-- function 36
			data.start_time = nil

			Unit.animation_event(interactor_unit, "interaction_end")

			if result == InteractionResult.SUCCESS and Unit.get_data(interactable_unit, "interaction_data", "only_once") then
				Unit.set_data(interactable_unit, "interaction_data", "used", true)
			end

			Unit.set_data(interactable_unit, "interaction_data", "being_used", false)
		end,
		get_progress = function (data, config, t)
			-- function 37
			return 0
		end,
		can_interact = function (interactor_unit, interactable_unit, data, config)
			-- function 38
			local used = Unit.get_data(interactable_unit, "interaction_data", "used")
			local being_used = Unit.get_data(interactable_unit, "interaction_data", "being_used")
			local all_players_spawned = Managers.matchmaking:are_all_players_spawned()

			return not used and not being_used and not not all_players_spawned
		end,
		hud_description = function (interactable_unit, data, config)
			-- function 39
			return Unit.get_data(interactable_unit, "interaction_data", "hud_description"), Unit.get_data(interactable_unit, "interaction_data", "hud_interaction_action")
		end
	}
}
InteractionDefinitions.carousel_door_transition = not not InteractionDefinitions.carousel_door_transition
InteractionDefinitions.carousel_door_transition.config.swap_to_3p = false

InteractionDefinitions.carousel_door_transition.client.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
	-- function 40
	if result == InteractionResult.SUCCESS and not data.is_husk then
		local variation_data = Managers.backend:get_level_variation_data()
		local vote_data = {
			switch_mechanism = true,
			mechanism = "versus",
			level_key = "carousel_hub"
		}

		Managers.state.voting:request_vote("game_settings_vote_switch_mechanism", vote_data, Network.peer_id())
	end
end

InteractionDefinitions.carousel_door_transition.client.hud_description = function (interactable_unit, data, config, fail_reason, interactor_unit)
	-- function 41
	return Unit.get_data(interactable_unit, "interaction_data", "hud_description"), "interaction_action_enter"
end

InteractionDefinitions.carousel_door_transition.client.can_interact = function (interactor_unit, interactable_unit, data, config)
	-- function 42
	if not DLCSettings.carousel then
		return false
	end

	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local is_vote_in_progress = Managers.state.voting:vote_in_progress()

	return not is_game_matchmaking and not not not is_vote_in_progress
end

InteractionDefinitions.versus_map_access = not not InteractionDefinitions.versus_map_access
InteractionDefinitions.versus_map_access.config.swap_to_3p = false

InteractionDefinitions.versus_map_access.client.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
	-- function 43
	data.start_time = nil

	if result == InteractionResult.SUCCESS and not data.is_husk then
		Managers.ui:handle_transition("start_game_view_force", {
			use_fade = true,
			menu_state_name = "play"
		})
	end
end

InteractionDefinitions.versus_map_access.client.hud_description = function (interactable_unit, data, config, fail_reason, interactor_unit)
	-- function 44
	return Unit.get_data(interactable_unit, "interaction_data", "hud_description"), "interaction_action_open"
end

InteractionDefinitions.versus_map_access.client.can_interact = function (interactor_unit, interactable_unit, data, config)
	-- function 45
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()

	return not is_game_matchmaking
end
