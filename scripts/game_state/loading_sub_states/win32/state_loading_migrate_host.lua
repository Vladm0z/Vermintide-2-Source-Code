-- chunkname: @scripts/game_state/loading_sub_states/win32/state_loading_migrate_host.lua

local function fn(arg_1_0, ...)
	-- function 1
	if not script_data.network_debug_connections then
		printf("[StateLoadingMigrateHost] " .. arg_1_0, ...)
	end
end

StateLoadingMigrateHost = class(StateLoadingMigrateHost)
StateLoadingMigrateHost.NAME = "StateLoadingMigrateHost"

local num = 5

StateLoadingMigrateHost.on_enter = function (self, arg_2_1)
	-- function 2
	print("[Gamestate] Enter Substate StateLoadingMigrateHost")
	self:_init_params(arg_2_1)
	self:_init_network()
end

StateLoadingMigrateHost._init_params = function (self, arg_3_1)
	-- function 3
	self._loading_view = arg_3_1.loading_view
	self._lobby_client = arg_3_1.lobby_client
	self._lobby_joined = false
	self._server_created = false
end

StateLoadingMigrateHost._init_network = function (self)
	-- function 4
	LobbySetup.setup_network_options()

	if not self.parent:has_registered_rpcs() then
		self.parent:register_rpcs()
	end

	if not Managers.voice_chat then
		Managers.voice_chat:reset()
	end

	local host_migration_info = self.parent.parent.loading_context.host_migration_info
	local host_to_migrate_to = host_migration_info.host_to_migrate_to
	local flag = not host_to_migrate_to and host_to_migrate_to.peer_id

	if flag == Network.peer_id() then
		fn("creating host for people to migrate to")

		local level_transition_handler = Managers.level_transition_handler

		if not host_migration_info.level_data then
			local level_data = host_migration_info.level_data

			host_migration_info.level_data = nil

			level_transition_handler:set_next_level(level_data.level_key, level_data.environment_variation_id, level_data.level_seed, level_data.mechanism, level_data.game_mode_key, level_data.conflict_settings, level_data.locked_director_functions, level_data.difficulty, level_data.difficulty_tweak, level_data.extra_packages)
		elseif not host_migration_info.level_to_load then
			local level_to_load = host_migration_info.level_to_load

			level_transition_handler:set_next_level(level_to_load)

			host_migration_info.level_to_load = nil
		end

		if not IS_XB1 then
			print("#########################################")
			print("#### SETTING UP HOST MIGRATION LOBBY ####")
			print("#########################################")
			print(host_to_migrate_to.session_id, host_to_migrate_to.session_template_name)
			self.parent:setup_lobby_host(callback(self, "cb_server_created"), nil, host_to_migrate_to.session_id, host_to_migrate_to.session_template_name)
		else
			self.parent:setup_lobby_host(callback(self, "cb_server_created"))
			self.parent:start_matchmaking()
		end
	elseif not IS_XB1 then
		print("#################################")
		print("#### JOINING MIGRATION LOBBY ####")
		print("#################################")
		print(host_to_migrate_to.session_id, host_to_migrate_to.session_template_name)

		self.parent.parent.loading_context.join_lobby_data = {
			name = host_to_migrate_to.session_id,
			session_template_name = host_to_migrate_to.session_template_name
		}

		self.parent:setup_join_lobby(num)
	else
		fn("Migrating to host %s, trying to find its lobby...", host_to_migrate_to)

		local setup_lobby_finder = self.parent:setup_lobby_finder(callback(self, "cb_lobby_joined"), nil, host_to_migrate_to)
		local tbl = {
			free_slots = 1,
			distance_filter = "world",
			filters = {
				host = {
					comparison = "equal",
					value = flag
				}
			},
			near_filters = {}
		}
		local get_lobby_browser = setup_lobby_finder:get_lobby_browser()

		LobbyInternal.add_filter_requirements(tbl, get_lobby_browser)
	end
end

StateLoadingMigrateHost.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if self._server_created or not self._lobby_joined then
		return StateLoadingRunning
	elseif not IS_XB1 and not self.parent:lobby_verified() then
		return StateLoadingRunning
	end
end

StateLoadingMigrateHost.on_exit = function (self, arg_6_1)
	-- function 6
	local host_migration_info = self.parent.parent.loading_context.host_migration_info
	local flag = not host_migration_info and host_migration_info.game_mode_event_data

	if not flag then
		self.parent.parent.loading_context.host_migration_info = {
			game_mode_event_data = flag
		}
	else
		self.parent.parent.loading_context.host_migration_info = nil
	end
end

StateLoadingMigrateHost.cb_server_created = function (self)
	-- function 7
	fn("cb_server_created")

	if not IS_XB1 then
		self.parent:start_matchmaking()
	end

	local get_lobby = self.parent:get_lobby()
	local get_stored_lobby_data = get_lobby:get_stored_lobby_data()

	get_stored_lobby_data = get_stored_lobby_data or {}

	local lobby_data = self.parent.parent.loading_context.host_migration_info.lobby_data

	for k, v in pairs(lobby_data) do
		get_stored_lobby_data[k] = v
	end

	get_lobby:set_lobby_data(get_stored_lobby_data)

	self._server_created = true
end

StateLoadingMigrateHost.cb_lobby_joined = function (self)
	-- function 8
	fn("cb_lobby_joined")

	self._lobby_joined = true
end
