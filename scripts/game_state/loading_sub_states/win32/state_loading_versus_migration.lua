-- chunkname: @scripts/game_state/loading_sub_states/win32/state_loading_versus_migration.lua

local function var_0_0(arg_1_0, ...)
	if script_data.network_debug_connections then
		printf("[StateLoadingVersusMigration] " .. arg_1_0, ...)
	end
end

StateLoadingVersusMigration = class(StateLoadingVersusMigration)
StateLoadingVersusMigration.NAME = "StateLoadingVersusMigration"

function StateLoadingVersusMigration.on_enter(arg_2_0, arg_2_1)
	print("[Gamestate] Enter Substate StateLoadingVersusMigration")

	arg_2_0._party_manager = Managers.party

	arg_2_0:_init_params(arg_2_1)
	arg_2_0:_init_network()
end

function StateLoadingVersusMigration._init_params(arg_3_0, arg_3_1)
	arg_3_0._loading_view = arg_3_1.loading_view
	arg_3_0._lobby_client = arg_3_1.lobby_client
	arg_3_0._lobby_joined = false
	arg_3_0._server_created = false
end

function StateLoadingVersusMigration._init_network(arg_4_0)
	LobbySetup.setup_network_options()

	if not arg_4_0.parent:has_registered_rpcs() then
		arg_4_0.parent:register_rpcs()
	end

	arg_4_0._migration_info = arg_4_0.parent.parent.loading_context.versus_migration_info
	arg_4_0._friend_party = arg_4_0._migration_info.friend_party

	local var_4_0 = arg_4_0:get_host_to_migrate_to()
	local var_4_1 = var_4_0.peer_id

	if not var_4_1 then
		Crashify.print_exception("[VersusMigration]", "Local player does not belong to any friend party")
	end

	if not var_4_1 or var_4_1 == Network.peer_id() then
		arg_4_0:set_up_lobby()
	else
		var_0_0("Versus migration to host %s, trying to find its lobby...", var_4_0)

		local var_4_2 = arg_4_0.parent:setup_lobby_finder(callback(arg_4_0, "cb_lobby_joined"), nil, var_4_0)
		local var_4_3 = {
			free_slots = 1,
			distance_filter = "world",
			filters = {
				host = {
					comparison = "equal",
					value = var_4_1
				}
			},
			near_filters = {}
		}
		local var_4_4 = var_4_2:get_lobby_browser()

		LobbyInternal.add_filter_requirements(var_4_3, var_4_4)
	end
end

function StateLoadingVersusMigration.update(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._server_created or arg_5_0._lobby_joined then
		return StateLoadingRunning
	end
end

function StateLoadingVersusMigration.on_exit(arg_6_0, arg_6_1)
	arg_6_0.parent.parent.loading_context.versus_migration_info = nil
end

function StateLoadingVersusMigration.cb_server_created(arg_7_0)
	var_0_0("cb_server_created")

	local var_7_0 = arg_7_0._migration_info.lobby_data
	local var_7_1 = arg_7_0.parent:get_lobby()
	local var_7_2 = var_7_1:get_stored_lobby_data() or {}

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		var_7_2[iter_7_0] = iter_7_1
	end

	var_7_1:set_lobby_data(var_7_2)

	arg_7_0._server_created = true
end

function StateLoadingVersusMigration.cb_lobby_joined(arg_8_0)
	var_0_0("cb_lobby_joined")

	arg_8_0._lobby_joined = true
end

function StateLoadingVersusMigration.set_up_lobby(arg_9_0)
	local var_9_0 = Managers.level_transition_handler
	local var_9_1 = arg_9_0._migration_info.level_data

	var_9_0:set_next_level(var_9_1.level_key, var_9_1.environment_variation_id, var_9_1.level_seed)
	arg_9_0.parent:setup_lobby_host(callback(arg_9_0, "cb_server_created"))
	arg_9_0.parent:start_matchmaking()
end

function StateLoadingVersusMigration.get_host_to_migrate_to(arg_10_0)
	local var_10_0 = arg_10_0._friend_party[1]
	local var_10_1 = tostring(var_10_0)

	return {
		peer_id = var_10_0,
		name = var_10_1
	}
end
