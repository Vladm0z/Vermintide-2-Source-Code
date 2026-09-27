-- chunkname: @scripts/game_state/loading_sub_states/win32/state_loading_versus_migration.lua

local function fn(arg_1_0, ...)
	-- function 1
	if not script_data.network_debug_connections then
		printf("[StateLoadingVersusMigration] " .. arg_1_0, ...)
	end
end

StateLoadingVersusMigration = class(StateLoadingVersusMigration)
StateLoadingVersusMigration.NAME = "StateLoadingVersusMigration"

StateLoadingVersusMigration.on_enter = function (self, arg_2_1)
	-- function 2
	print("[Gamestate] Enter Substate StateLoadingVersusMigration")

	self._party_manager = Managers.party

	self:_init_params(arg_2_1)
	self:_init_network()
end

StateLoadingVersusMigration._init_params = function (self, arg_3_1)
	-- function 3
	self._loading_view = arg_3_1.loading_view
	self._lobby_client = arg_3_1.lobby_client
	self._lobby_joined = false
	self._server_created = false
end

StateLoadingVersusMigration._init_network = function (self)
	-- function 4
	LobbySetup.setup_network_options()

	if not self.parent:has_registered_rpcs() then
		self.parent:register_rpcs()
	end

	self._migration_info = self.parent.parent.loading_context.versus_migration_info
	self._friend_party = self._migration_info.friend_party

	local get_host_to_migrate_to = self:get_host_to_migrate_to()
	local peer_id = get_host_to_migrate_to.peer_id

	if not peer_id then
		Crashify.print_exception("[VersusMigration]", "Local player does not belong to any friend party")
	end

	if not (not peer_id and peer_id ~= Network.peer_id()) then
		self:set_up_lobby()
	else
		fn("Versus migration to host %s, trying to find its lobby...", get_host_to_migrate_to)

		local setup_lobby_finder = self.parent:setup_lobby_finder(callback(self, "cb_lobby_joined"), nil, get_host_to_migrate_to)
		local tbl = {
			free_slots = 1,
			distance_filter = "world",
			filters = {
				host = {
					comparison = "equal",
					value = peer_id
				}
			},
			near_filters = {}
		}
		local get_lobby_browser = setup_lobby_finder:get_lobby_browser()

		LobbyInternal.add_filter_requirements(tbl, get_lobby_browser)
	end
end

StateLoadingVersusMigration.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if self._server_created or not self._lobby_joined then
		return StateLoadingRunning
	end
end

StateLoadingVersusMigration.on_exit = function (arg_6_0, arg_6_1)
	-- function 6
	arg_6_0.parent.parent.loading_context.versus_migration_info = nil
end

StateLoadingVersusMigration.cb_server_created = function (self)
	-- function 7
	fn("cb_server_created")

	local lobby_data = self._migration_info.lobby_data
	local get_lobby = self.parent:get_lobby()
	local get_stored_lobby_data = get_lobby:get_stored_lobby_data()

	get_stored_lobby_data = get_stored_lobby_data or {}

	for k, v in pairs(lobby_data) do
		get_stored_lobby_data[k] = v
	end

	get_lobby:set_lobby_data(get_stored_lobby_data)

	self._server_created = true
end

StateLoadingVersusMigration.cb_lobby_joined = function (self)
	-- function 8
	fn("cb_lobby_joined")

	self._lobby_joined = true
end

StateLoadingVersusMigration.set_up_lobby = function (self)
	-- function 9
	local level_transition_handler = Managers.level_transition_handler
	local level_data = self._migration_info.level_data

	level_transition_handler:set_next_level(level_data.level_key, level_data.environment_variation_id, level_data.level_seed)
	self.parent:setup_lobby_host(callback(self, "cb_server_created"))
	self.parent:start_matchmaking()
end

StateLoadingVersusMigration.get_host_to_migrate_to = function (self)
	-- function 10
	local var_10_0 = self._friend_party[1]
	local var_10_1 = tostring(var_10_0)

	return {
		peer_id = var_10_0,
		name = var_10_1
	}
end
