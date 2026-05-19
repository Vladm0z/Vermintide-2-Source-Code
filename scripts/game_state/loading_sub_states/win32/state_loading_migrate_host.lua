-- chunkname: @scripts/game_state/loading_sub_states/win32/state_loading_migrate_host.lua

local function var_0_0(arg_1_0, ...)
	if script_data.network_debug_connections then
		printf("[StateLoadingMigrateHost] " .. arg_1_0, ...)
	end
end

StateLoadingMigrateHost = class(StateLoadingMigrateHost)
StateLoadingMigrateHost.NAME = "StateLoadingMigrateHost"

local var_0_1 = 5

function StateLoadingMigrateHost.on_enter(arg_2_0, arg_2_1)
	print("[Gamestate] Enter Substate StateLoadingMigrateHost")
	arg_2_0:_init_params(arg_2_1)
	arg_2_0:_init_network()
end

function StateLoadingMigrateHost._init_params(arg_3_0, arg_3_1)
	arg_3_0._loading_view = arg_3_1.loading_view
	arg_3_0._lobby_client = arg_3_1.lobby_client
	arg_3_0._lobby_joined = false
	arg_3_0._server_created = false
end

function StateLoadingMigrateHost._init_network(arg_4_0)
	LobbySetup.setup_network_options()

	if not arg_4_0.parent:has_registered_rpcs() then
		arg_4_0.parent:register_rpcs()
	end

	if Managers.voice_chat then
		Managers.voice_chat:reset()
	end

	local var_4_0 = arg_4_0.parent.parent.loading_context.host_migration_info
	local var_4_1 = var_4_0.host_to_migrate_to
	local var_4_2 = var_4_1 and var_4_1.peer_id

	if var_4_2 == Network.peer_id() then
		var_0_0("creating host for people to migrate to")

		local var_4_3 = Managers.level_transition_handler

		if var_4_0.level_data then
			local var_4_4 = var_4_0.level_data

			var_4_0.level_data = nil

			var_4_3:set_next_level(var_4_4.level_key, var_4_4.environment_variation_id, var_4_4.level_seed, var_4_4.mechanism, var_4_4.game_mode_key, var_4_4.conflict_settings, var_4_4.locked_director_functions, var_4_4.difficulty, var_4_4.difficulty_tweak, var_4_4.extra_packages)
		elseif var_4_0.level_to_load then
			local var_4_5 = var_4_0.level_to_load

			var_4_3:set_next_level(var_4_5)

			var_4_0.level_to_load = nil
		end

		if IS_XB1 then
			print("#########################################")
			print("#### SETTING UP HOST MIGRATION LOBBY ####")
			print("#########################################")
			print(var_4_1.session_id, var_4_1.session_template_name)
			arg_4_0.parent:setup_lobby_host(callback(arg_4_0, "cb_server_created"), nil, var_4_1.session_id, var_4_1.session_template_name)
		else
			arg_4_0.parent:setup_lobby_host(callback(arg_4_0, "cb_server_created"))
			arg_4_0.parent:start_matchmaking()
		end
	elseif IS_XB1 then
		print("#################################")
		print("#### JOINING MIGRATION LOBBY ####")
		print("#################################")
		print(var_4_1.session_id, var_4_1.session_template_name)

		arg_4_0.parent.parent.loading_context.join_lobby_data = {
			name = var_4_1.session_id,
			session_template_name = var_4_1.session_template_name
		}

		arg_4_0.parent:setup_join_lobby(var_0_1)
	else
		var_0_0("Migrating to host %s, trying to find its lobby...", var_4_1)

		local var_4_6 = arg_4_0.parent:setup_lobby_finder(callback(arg_4_0, "cb_lobby_joined"), nil, var_4_1)
		local var_4_7 = {
			free_slots = 1,
			distance_filter = "world",
			filters = {
				host = {
					comparison = "equal",
					value = var_4_2
				}
			},
			near_filters = {}
		}
		local var_4_8 = var_4_6:get_lobby_browser()

		LobbyInternal.add_filter_requirements(var_4_7, var_4_8)
	end
end

function StateLoadingMigrateHost.update(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._server_created or arg_5_0._lobby_joined then
		return StateLoadingRunning
	elseif IS_XB1 and arg_5_0.parent:lobby_verified() then
		return StateLoadingRunning
	end
end

function StateLoadingMigrateHost.on_exit(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.parent.parent.loading_context.host_migration_info
	local var_6_1 = var_6_0 and var_6_0.game_mode_event_data

	if var_6_1 then
		arg_6_0.parent.parent.loading_context.host_migration_info = {
			game_mode_event_data = var_6_1
		}
	else
		arg_6_0.parent.parent.loading_context.host_migration_info = nil
	end
end

function StateLoadingMigrateHost.cb_server_created(arg_7_0)
	var_0_0("cb_server_created")

	if IS_XB1 then
		arg_7_0.parent:start_matchmaking()
	end

	local var_7_0 = arg_7_0.parent:get_lobby()
	local var_7_1 = var_7_0:get_stored_lobby_data() or {}
	local var_7_2 = arg_7_0.parent.parent.loading_context.host_migration_info.lobby_data

	for iter_7_0, iter_7_1 in pairs(var_7_2) do
		var_7_1[iter_7_0] = iter_7_1
	end

	var_7_0:set_lobby_data(var_7_1)

	arg_7_0._server_created = true
end

function StateLoadingMigrateHost.cb_lobby_joined(arg_8_0)
	var_0_0("cb_lobby_joined")

	arg_8_0._lobby_joined = true
end
