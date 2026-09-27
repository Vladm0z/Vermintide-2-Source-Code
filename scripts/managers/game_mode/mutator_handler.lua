-- chunkname: @scripts/managers/game_mode/mutator_handler.lua

require("scripts/managers/game_mode/mutator_common_settings")
require("scripts/managers/game_mode/mutator_templates")

function mutator_dprint(arg_1_0, ...)
	-- function 1
	if not script_data.debug_mutators then
		local format = string.format(arg_1_0, ...)

		printf("[Mutator] %s", format)
	end
end

function mutator_print(arg_2_0, ...)
	-- function 2
	local format = string.format(arg_2_0, ...)

	printf("[Mutator] %s", format)
end

MutatorHandler = class(MutatorHandler)

local tbl = {
	"rpc_activate_mutator_client",
	"rpc_deactivate_mutator_client"
}

MutatorHandler.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	self._is_server = arg_3_2
	self._network_handler = arg_3_3
	self._has_local_client = arg_3_4
	self._network_transmit = arg_3_7
	self.network_event_delegate = arg_3_6

	arg_3_6:register(self, unpack(tbl))

	self._mutator_context = {
		world = arg_3_5,
		is_server = arg_3_2
	}
	self._active_mutators = {}
	self._mutators = {}

	if not arg_3_2 and not arg_3_1 then
		self._initialized_mutator_map = {}

		self:initialize_mutators(arg_3_1)
	else
		self._initialized_mutator_map = arg_3_3:get_initialized_mutator_map()

		arg_3_3:get_network_state():register_callback("client_data_updated", self, "on_client_mutator_list_updated", "initialized_mutator_map")
	end

	Managers.state.event:register(self, "on_player_disabled", "player_disabled")
end

MutatorHandler.destroy = function (self)
	-- function 4
	Managers.state.event:unregister(self)

	if not self._is_server then
		self._network_handler:get_network_state():unregister_callback(self, "client_data_updated")
	end

	local _active_mutators = self._active_mutators
	local _mutator_context = self._mutator_context

	_mutator_context.is_destroy = true

	for k, v in pairs(_active_mutators) do
		self:_deactivate_mutator(k, _active_mutators, _mutator_context, true)
	end

	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
	self._mutators = nil
	self._active_mutators = nil
end

MutatorHandler.initialize_mutators = function (self, arg_5_1)
	-- function 5
	local _active_mutators = self._active_mutators
	local _mutator_context = self._mutator_context

	for i = 1, #arg_5_1 do
		local var_5_2 = arg_5_1[i]

		self:_server_initialize_mutator(var_5_2, _active_mutators, _mutator_context)
	end

	if not self._is_server then
		self._network_handler:get_network_state():set_initialized_mutator_map(table.shallow_copy(self._initialized_mutator_map))
	end
end

MutatorHandler.activate_mutators = function (self)
	-- function 6
	if not self._is_server then
		local _mutator_context = self._mutator_context
		local _active_mutators = self._active_mutators
		local _mutators = self._mutators

		for k, v in pairs(_mutators) do
			self:_activate_mutator(k, _active_mutators, _mutator_context, v)
		end
	end
end

MutatorHandler.deactivate_mutators = function (self, arg_7_1)
	-- function 7
	local _active_mutators = self._active_mutators
	local _mutator_context = self._mutator_context

	_mutator_context.is_destroy = arg_7_1

	for k, v in pairs(_active_mutators) do
		self:_deactivate_mutator(k, _active_mutators, _mutator_context, true)
	end
end

MutatorHandler.activate_mutator = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not self._is_server then
		local _mutator_context = self._mutator_context
		local _active_mutators = self._active_mutators
		local var_8_2 = self._mutators[arg_8_1]

		if not arg_8_3 then
			var_8_2[arg_8_3] = true
		end

		self:_activate_mutator(arg_8_1, _active_mutators, _mutator_context, var_8_2, arg_8_2)
	end
end

MutatorHandler.deactivate_mutator = function (self, arg_9_1)
	-- function 9
	if not self._is_server then
		local _active_mutators = self._active_mutators
		local _mutator_context = self._mutator_context

		self:_deactivate_mutator(arg_9_1, _active_mutators, _mutator_context)
	end
end

MutatorHandler.hot_join_sync = function (self, arg_10_1)
	-- function 10
	local _network_transmit = self._network_transmit
	local _active_mutators = self._active_mutators
	local _mutator_context = self._mutator_context
	local _is_server = self._is_server

	for k, v in pairs(_active_mutators) do
		local var_10_4 = NetworkLookup.mutator_templates[k]
		local flag = not not v.activated_by_twitch

		_network_transmit:send_rpc("rpc_activate_mutator_client", arg_10_1, var_10_4, flag)
	end

	for k_2, v_2 in pairs(_active_mutators) do
		local template = v_2.template

		if not _is_server then
			template.server.hot_join_sync_function(_mutator_context, v_2, arg_10_1)
		else
			template.client.hot_join_sync_function(_mutator_context, v_2, arg_10_1)
		end
	end
end

MutatorHandler.pre_update = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _active_mutators = self._active_mutators
	local _mutator_context = self._mutator_context
	local _is_server = self._is_server

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server and not template.server.pre_update then
			template.server.pre_update(_mutator_context, v, arg_11_1, arg_11_2)
		end

		if not self._has_local_client and not template.client.pre_update then
			template.client.pre_update(_mutator_context, v, arg_11_1, arg_11_2)
		end
	end
end

local flag = true

MutatorHandler.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _active_mutators = self._active_mutators
	local _mutator_context = self._mutator_context
	local _is_server = self._is_server

	for k, v in pairs(_active_mutators) do
		if not flag then
			print("FIRST UPDATE @" .. arg_12_2)

			flag = false
		end

		local template = v.template

		if not _is_server and not template.server.update then
			template.server.update(_mutator_context, v, arg_12_1, arg_12_2)
		end

		if not self._has_local_client and not template.client.update then
			template.client.update(_mutator_context, v, arg_12_1, arg_12_2)
		end

		if not (not v.deactivate_at_t and not (arg_12_2 > v.deactivate_at_t)) then
			self:_deactivate_mutator(k, _active_mutators, _mutator_context)
		end
	end
end

MutatorHandler.has_activated_mutator = function (self, arg_13_1)
	-- function 13
	return self._active_mutators[arg_13_1] ~= nil
end

MutatorHandler.has_mutator = function (self, arg_14_1)
	-- function 14
	return self._mutators[arg_14_1] ~= nil
end

MutatorHandler.activated_mutators = function (self)
	-- function 15
	return self._active_mutators
end

MutatorHandler.mutators = function (self)
	-- function 16
	return self._mutators
end

MutatorHandler.initialized_mutator_map = function (self)
	-- function 17
	return self._initialized_mutator_map
end

MutatorHandler.player_disabled = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server then
			template.server.player_disabled_function(_mutator_context, v, arg_18_1, arg_18_2, arg_18_3)
		end
	end
end

MutatorHandler.ai_killed = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server
	local _has_local_client = self._has_local_client

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server then
			template.server.ai_killed_function(_mutator_context, v, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		end

		if not _has_local_client then
			template.client.ai_killed_function(_mutator_context, v, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		end
	end
end

MutatorHandler.level_object_killed = function (self, arg_20_1, arg_20_2)
	-- function 20
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server
	local _has_local_client = self._has_local_client

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server then
			template.server.level_object_killed_function(_mutator_context, v, arg_20_1, arg_20_2)
		end

		if not _has_local_client then
			template.client.level_object_killed_function(_mutator_context, v, arg_20_1, arg_20_2)
		end
	end
end

MutatorHandler.ai_hit_by_player = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server
	local _has_local_client = self._has_local_client

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server then
			template.server.ai_hit_by_player_function(_mutator_context, v, arg_21_1, arg_21_2, arg_21_3)
		end

		if not _has_local_client then
			template.client.ai_hit_by_player_function(_mutator_context, v, arg_21_1, arg_21_2, arg_21_3)
		end
	end
end

MutatorHandler.player_hit = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server
	local _has_local_client = self._has_local_client

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server then
			template.server.player_hit_function(_mutator_context, v, arg_22_1, arg_22_2, arg_22_3)
		end

		if not _has_local_client then
			template.client.player_hit_function(_mutator_context, v, arg_22_1, arg_22_2, arg_22_3)
		end
	end
end

MutatorHandler.modify_player_base_damage = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server and not template.modify_player_base_damage then
			arg_23_3 = template.modify_player_base_damage(_mutator_context, v, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
		end
	end

	return arg_23_3
end

MutatorHandler.player_respawned = function (self, arg_24_1)
	-- function 24
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server
	local _has_local_client = self._has_local_client

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server then
			template.server.player_respawned_function(_mutator_context, v, arg_24_1)
		end

		if not _has_local_client then
			template.client.player_respawned_function(_mutator_context, v, arg_24_1)
		end
	end
end

MutatorHandler.damage_taken = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	-- function 25
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server
	local _has_local_client = self._has_local_client

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server then
			template.server.damage_taken_function(_mutator_context, v, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
		end

		if not _has_local_client then
			template.client.damage_taken_function(_mutator_context, v, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
		end
	end
end

MutatorHandler.pre_ai_spawned = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not self._is_server then
		return
	end

	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not template.server.pre_ai_spawned_function then
			template.server.pre_ai_spawned_function(_mutator_context, v, arg_26_1, arg_26_2)
		end
	end
end

MutatorHandler.ai_spawned = function (self, arg_27_1)
	-- function 27
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server
	local _has_local_client = self._has_local_client

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server then
			template.server.ai_spawned_function(_mutator_context, v, arg_27_1)
		end

		if not _has_local_client then
			template.client.ai_spawned_function(_mutator_context, v, arg_27_1)
		end
	end
end

MutatorHandler.post_ai_spawned = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	if not self._is_server then
		return
	end

	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not template.server.post_ai_spawned_function then
			template.server.post_ai_spawned_function(_mutator_context, v, arg_28_1, arg_28_2, arg_28_3)
		end
	end
end

MutatorHandler.players_left_safe_zone = function (self)
	-- function 29
	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local _is_server = self._is_server

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not _is_server then
			template.server.server_players_left_safe_zone(_mutator_context, v)
		end
	end
end

MutatorHandler.evaluate_lose_conditions = function (self)
	-- function 30
	fassert(self._is_server, "evaluate_lose_conditions only runs on server")

	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators
	local flag = false
	local var_30_3

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not template.lose_condition_function then
			local lose_condition_function, var_30_6 = template.lose_condition_function(_mutator_context, v)

			if not lose_condition_function then
				if not (not var_30_6 and var_30_3 == nil or not (var_30_3 < var_30_6)) then
					var_30_3 = var_30_6
				end

				flag = lose_condition_function
			end
		end
	end

	return flag, var_30_3
end

MutatorHandler.evaluate_end_zone_activation_conditions = function (self)
	-- function 31
	fassert(self._is_server, "evaluate_end_zone_activation_conditions only runs on server")

	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not (not template.end_zone_activation_condition_function and template.end_zone_activation_condition_function(_mutator_context, v)) then
			return false
		end
	end

	return true
end

MutatorHandler.post_process_terror_event = function (self, arg_32_1)
	-- function 32
	fassert(self._is_server, "post_process_terror_event only runs on server")

	local _mutator_context = self._mutator_context
	local _active_mutators = self._active_mutators

	for k, v in pairs(_active_mutators) do
		local template = v.template

		if not template.post_process_terror_event then
			template.post_process_terror_event(_mutator_context, v, arg_32_1)
		end
	end
end

MutatorHandler.pickup_settings_updated_settings = function (self, arg_33_1)
	-- function 33
	if not self._is_server then
		return
	end

	if not arg_33_1 then
		return nil
	end

	local clone = table.clone(arg_33_1)
	local tbl = {}
	local _mutators = self._mutators

	for k, v in pairs(_mutators) do
		local pickup_system_multipliers = v.template.pickup_system_multipliers

		if not pickup_system_multipliers then
			for k_2, v_2 in pairs(pickup_system_multipliers) do
				if not tbl[k_2] then
					tbl[k_2] = tbl[k_2] * v_2
				else
					tbl[k_2] = v_2
				end
			end
		end
	end

	local function fn(arg_34_0, arg_34_1, arg_34_2)
		-- function 34
		if not tbl[arg_34_1] then
			return math.ceil(arg_34_2 * tbl[arg_34_1])
		elseif not tbl[arg_34_0] then
			return math.ceil(arg_34_2 * tbl[arg_34_0])
		else
			return arg_34_2
		end
	end

	for k_3, v_3 in pairs(clone) do
		if type(v_3) == "table" then
			for k_4, v_4 in pairs(v_3) do
				v_3[k_4] = fn(k_3, k_4, v_4)
			end
		else
			clone[k_3] = fn(k_3, nil, v_3)
		end
	end

	return clone
end

MutatorHandler.conflict_director_updated_settings = function (self)
	-- function 35
	if not self._is_server then
		return
	end

	local _mutator_context = self._mutator_context
	local _mutators = self._mutators

	for k, v in pairs(_mutators) do
		local template = v.template

		if not template.update_conflict_settings then
			template.update_conflict_settings(_mutator_context, v)
		end
	end
end

MutatorHandler.get_terror_event_tags = function (self)
	-- function 36
	local _mutator_context = self._mutator_context
	local _mutators = self._mutators
	local var_36_2

	for k, v in pairs(_mutators) do
		local template = v.template

		if not template.get_terror_event_tags then
			var_36_2 = var_36_2 or {}

			template.get_terror_event_tags(_mutator_context, v, var_36_2)
		end
	end

	return var_36_2
end

MutatorHandler.tweak_zones = function (self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	if not self._is_server then
		return
	end

	local _mutator_context = self._mutator_context
	local _mutators = self._mutators

	for k, v in pairs(_mutators) do
		local template = v.template

		if not template.tweak_zones then
			template.tweak_zones(_mutator_context, v, arg_37_1, arg_37_2, arg_37_3)
		end
	end

	return arg_37_2
end

MutatorHandler._server_initialize_mutator = function (self, arg_38_1, arg_38_2, arg_38_3)
	-- function 38
	fassert(self._is_server, "Only server is allowed to run mutator initialization function.")

	if not MutatorTemplates[arg_38_1] then
		mutator_print("No such template (%s)", arg_38_1)

		return
	end

	local _mutators = self._mutators

	fassert(_mutators[arg_38_1] == nil, "Can't initialize an already initialized mutator (%s)", arg_38_1)
	fassert(arg_38_2[arg_38_1] == nil, "Can't initialize an activated mutator (%s)", arg_38_1)

	local var_38_1 = MutatorTemplates[arg_38_1]
	local tbl = {
		template = var_38_1
	}

	mutator_print("Initializing mutator '%s'", arg_38_1)

	local server = var_38_1.server

	if not server.initialize_function then
		server.initialize_function(arg_38_3, tbl)
	end

	self._mutators[arg_38_1] = tbl
	self._initialized_mutator_map[arg_38_1] = true
end

MutatorHandler._activate_mutator = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	-- function 39
	fassert(arg_39_2[arg_39_1] == nil, "Can't have multiple of same mutator running at the same time (%s)", arg_39_1)

	if not MutatorTemplates[arg_39_1] then
		mutator_print("No such template (%s)", arg_39_1)

		return
	end

	mutator_print("Activating mutator '%s'", arg_39_1)

	local var_39_0 = MutatorTemplates[arg_39_1]

	arg_39_4 = arg_39_4 or {
		template = var_39_0
	}

	if not arg_39_5 then
		arg_39_4.deactivate_at_t = Managers.time:time("game") + arg_39_5
	end

	arg_39_2[arg_39_1] = arg_39_4

	if not self._is_server then
		local server = var_39_0.server

		if not server.start_function then
			server.start_function(arg_39_3, arg_39_4)
		end
	end

	if not self._has_local_client then
		local client = var_39_0.client

		if not client.start_function then
			client.start_function(arg_39_3, arg_39_4)
		end
	end

	if not var_39_0.register_rpcs then
		var_39_0.register_rpcs(arg_39_3, arg_39_4, self.network_event_delegate)
	end

	if not self._is_server then
		local var_39_3 = NetworkLookup.mutator_templates[arg_39_1]
		local flag = not not arg_39_4.activated_by_twitch

		self._network_transmit:send_rpc_clients("rpc_activate_mutator_client", var_39_3, flag)
	end
end

MutatorHandler._deactivate_mutator = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	fassert(arg_40_2[arg_40_1], "Trying to deactivate mutator (%s) but it isn't active", arg_40_1)
	mutator_print("Deactivating mutator '%s'", arg_40_1)

	local var_40_0 = MutatorTemplates[arg_40_1]
	local var_40_1 = arg_40_2[arg_40_1]

	if not var_40_0.unregister_rpcs then
		var_40_0.unregister_rpcs(arg_40_3, var_40_1)
	end

	arg_40_2[arg_40_1] = nil
	self._mutators[arg_40_1] = nil

	if not self._is_server then
		local server = var_40_0.server

		if not server.stop_function then
			server.stop_function(arg_40_3, var_40_1, arg_40_4)
		end

		self._initialized_mutator_map[arg_40_1] = nil

		self._network_handler:get_network_state():set_initialized_mutator_map(table.shallow_copy(self._initialized_mutator_map))
	end

	if not self._has_local_client then
		local client = var_40_0.client

		if not client.stop_function then
			client.stop_function(arg_40_3, var_40_1, arg_40_4)
		end
	end

	if not (not self._is_server and arg_40_4) then
		local var_40_4 = NetworkLookup.mutator_templates[arg_40_1]

		self._network_transmit:send_rpc_clients("rpc_deactivate_mutator_client", var_40_4)
	end
end

MutatorHandler.tweak_pack_spawning_settings = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	local var_41_0

	local function fn(arg_42_0)
		-- function 42
		for i, v in ipairs(arg_42_0) do
			local var_42_0 = MutatorTemplates[v]

			if not var_42_0.tweak_pack_spawning_settings then
				if not var_41_0 then
					var_41_0 = table.clone(arg_41_3)
				end

				var_42_0.tweak_pack_spawning_settings(arg_41_2, var_41_0)
			end
		end
	end

	fn(arg_41_1)
	fn(arg_41_0)

	return var_41_0 or arg_41_3
end

MutatorHandler.rpc_activate_mutator_client = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	fassert(not self._is_server, "Only call rpc_activate_mutator_client on clients.")

	local var_43_0 = NetworkLookup.mutator_templates[arg_43_2]
	local _active_mutators = self._active_mutators
	local _mutator_context = self._mutator_context
	local tbl = {
		template = MutatorTemplates[var_43_0],
		activated_by_twitch = arg_43_3
	}

	self:_activate_mutator(var_43_0, _active_mutators, _mutator_context, tbl)
end

MutatorHandler.rpc_deactivate_mutator_client = function (self, arg_44_1, arg_44_2)
	-- function 44
	fassert(not self._is_server, "Only call rpc_deactivate_mutator_client on clients.")

	local var_44_0 = NetworkLookup.mutator_templates[arg_44_2]
	local _active_mutators = self._active_mutators
	local _mutator_context = self._mutator_context

	self:_deactivate_mutator(var_44_0, _active_mutators, _mutator_context)
end

MutatorHandler.on_client_mutator_list_updated = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7)
	-- function 45
	self._initialized_mutator_map = arg_45_7
end
