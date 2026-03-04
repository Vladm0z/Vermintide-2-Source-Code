-- chunkname: @scripts/managers/game_mode/mutator_handler.lua

require("scripts/managers/game_mode/mutator_common_settings")
require("scripts/managers/game_mode/mutator_templates")

function mutator_dprint(arg_1_0, ...)
	if script_data.debug_mutators then
		local var_1_0 = string.format(arg_1_0, ...)

		printf("[Mutator] %s", var_1_0)
	end
end

function mutator_print(arg_2_0, ...)
	local var_2_0 = string.format(arg_2_0, ...)

	printf("[Mutator] %s", var_2_0)
end

MutatorHandler = class(MutatorHandler)

local var_0_0 = {
	"rpc_activate_mutator_client",
	"rpc_deactivate_mutator_client"
}

MutatorHandler.init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	arg_3_0._is_server = arg_3_2
	arg_3_0._network_handler = arg_3_3
	arg_3_0._has_local_client = arg_3_4
	arg_3_0._network_transmit = arg_3_7
	arg_3_0.network_event_delegate = arg_3_6

	arg_3_6:register(arg_3_0, unpack(var_0_0))

	arg_3_0._mutator_context = {
		world = arg_3_5,
		is_server = arg_3_2
	}
	arg_3_0._active_mutators = {}
	arg_3_0._mutators = {}

	if arg_3_2 and arg_3_1 then
		arg_3_0._initialized_mutator_map = {}

		arg_3_0:initialize_mutators(arg_3_1)
	else
		arg_3_0._initialized_mutator_map = arg_3_3:get_initialized_mutator_map()

		arg_3_3:get_network_state():register_callback("client_data_updated", arg_3_0, "on_client_mutator_list_updated", "initialized_mutator_map")
	end

	Managers.state.event:register(arg_3_0, "on_player_disabled", "player_disabled")
end

MutatorHandler.destroy = function (arg_4_0)
	Managers.state.event:unregister(arg_4_0)

	if not arg_4_0._is_server then
		arg_4_0._network_handler:get_network_state():unregister_callback(arg_4_0, "client_data_updated")
	end

	local var_4_0 = arg_4_0._active_mutators
	local var_4_1 = arg_4_0._mutator_context

	var_4_1.is_destroy = true

	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		arg_4_0:_deactivate_mutator(iter_4_0, var_4_0, var_4_1, true)
	end

	arg_4_0.network_event_delegate:unregister(arg_4_0)

	arg_4_0.network_event_delegate = nil
	arg_4_0._mutators = nil
	arg_4_0._active_mutators = nil
end

MutatorHandler.initialize_mutators = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._active_mutators
	local var_5_1 = arg_5_0._mutator_context

	for iter_5_0 = 1, #arg_5_1 do
		local var_5_2 = arg_5_1[iter_5_0]

		arg_5_0:_server_initialize_mutator(var_5_2, var_5_0, var_5_1)
	end

	if arg_5_0._is_server then
		arg_5_0._network_handler:get_network_state():set_initialized_mutator_map(table.shallow_copy(arg_5_0._initialized_mutator_map))
	end
end

MutatorHandler.activate_mutators = function (arg_6_0)
	if arg_6_0._is_server then
		local var_6_0 = arg_6_0._mutator_context
		local var_6_1 = arg_6_0._active_mutators
		local var_6_2 = arg_6_0._mutators

		for iter_6_0, iter_6_1 in pairs(var_6_2) do
			arg_6_0:_activate_mutator(iter_6_0, var_6_1, var_6_0, iter_6_1)
		end
	end
end

MutatorHandler.deactivate_mutators = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._active_mutators
	local var_7_1 = arg_7_0._mutator_context

	var_7_1.is_destroy = arg_7_1

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		arg_7_0:_deactivate_mutator(iter_7_0, var_7_0, var_7_1, true)
	end
end

MutatorHandler.activate_mutator = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_0._is_server then
		local var_8_0 = arg_8_0._mutator_context
		local var_8_1 = arg_8_0._active_mutators
		local var_8_2 = arg_8_0._mutators[arg_8_1]

		if arg_8_3 then
			var_8_2[arg_8_3] = true
		end

		arg_8_0:_activate_mutator(arg_8_1, var_8_1, var_8_0, var_8_2, arg_8_2)
	end
end

MutatorHandler.deactivate_mutator = function (arg_9_0, arg_9_1)
	if arg_9_0._is_server then
		local var_9_0 = arg_9_0._active_mutators
		local var_9_1 = arg_9_0._mutator_context

		arg_9_0:_deactivate_mutator(arg_9_1, var_9_0, var_9_1)
	end
end

MutatorHandler.hot_join_sync = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._network_transmit
	local var_10_1 = arg_10_0._active_mutators
	local var_10_2 = arg_10_0._mutator_context
	local var_10_3 = arg_10_0._is_server

	for iter_10_0, iter_10_1 in pairs(var_10_1) do
		local var_10_4 = NetworkLookup.mutator_templates[iter_10_0]
		local var_10_5 = not not iter_10_1.activated_by_twitch

		var_10_0:send_rpc("rpc_activate_mutator_client", arg_10_1, var_10_4, var_10_5)
	end

	for iter_10_2, iter_10_3 in pairs(var_10_1) do
		local var_10_6 = iter_10_3.template

		if var_10_3 then
			var_10_6.server.hot_join_sync_function(var_10_2, iter_10_3, arg_10_1)
		else
			var_10_6.client.hot_join_sync_function(var_10_2, iter_10_3, arg_10_1)
		end
	end
end

MutatorHandler.pre_update = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._active_mutators
	local var_11_1 = arg_11_0._mutator_context
	local var_11_2 = arg_11_0._is_server

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		local var_11_3 = iter_11_1.template

		if var_11_2 and var_11_3.server.pre_update then
			var_11_3.server.pre_update(var_11_1, iter_11_1, arg_11_1, arg_11_2)
		end

		if arg_11_0._has_local_client and var_11_3.client.pre_update then
			var_11_3.client.pre_update(var_11_1, iter_11_1, arg_11_1, arg_11_2)
		end
	end
end

local var_0_1 = true

MutatorHandler.update = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._active_mutators
	local var_12_1 = arg_12_0._mutator_context
	local var_12_2 = arg_12_0._is_server

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if var_0_1 then
			print("FIRST UPDATE @" .. arg_12_2)

			var_0_1 = false
		end

		local var_12_3 = iter_12_1.template

		if var_12_2 and var_12_3.server.update then
			var_12_3.server.update(var_12_1, iter_12_1, arg_12_1, arg_12_2)
		end

		if arg_12_0._has_local_client and var_12_3.client.update then
			var_12_3.client.update(var_12_1, iter_12_1, arg_12_1, arg_12_2)
		end

		if iter_12_1.deactivate_at_t and arg_12_2 > iter_12_1.deactivate_at_t then
			arg_12_0:_deactivate_mutator(iter_12_0, var_12_0, var_12_1)
		end
	end
end

MutatorHandler.has_activated_mutator = function (arg_13_0, arg_13_1)
	return arg_13_0._active_mutators[arg_13_1] ~= nil
end

MutatorHandler.has_mutator = function (arg_14_0, arg_14_1)
	return arg_14_0._mutators[arg_14_1] ~= nil
end

MutatorHandler.activated_mutators = function (arg_15_0)
	return arg_15_0._active_mutators
end

MutatorHandler.mutators = function (arg_16_0)
	return arg_16_0._mutators
end

MutatorHandler.initialized_mutator_map = function (arg_17_0)
	return arg_17_0._initialized_mutator_map
end

MutatorHandler.player_disabled = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_0._mutator_context
	local var_18_1 = arg_18_0._active_mutators
	local var_18_2 = arg_18_0._is_server

	for iter_18_0, iter_18_1 in pairs(var_18_1) do
		local var_18_3 = iter_18_1.template

		if var_18_2 then
			var_18_3.server.player_disabled_function(var_18_0, iter_18_1, arg_18_1, arg_18_2, arg_18_3)
		end
	end
end

MutatorHandler.ai_killed = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_0._mutator_context
	local var_19_1 = arg_19_0._active_mutators
	local var_19_2 = arg_19_0._is_server
	local var_19_3 = arg_19_0._has_local_client

	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		local var_19_4 = iter_19_1.template

		if var_19_2 then
			var_19_4.server.ai_killed_function(var_19_0, iter_19_1, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		end

		if var_19_3 then
			var_19_4.client.ai_killed_function(var_19_0, iter_19_1, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		end
	end
end

MutatorHandler.level_object_killed = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._mutator_context
	local var_20_1 = arg_20_0._active_mutators
	local var_20_2 = arg_20_0._is_server
	local var_20_3 = arg_20_0._has_local_client

	for iter_20_0, iter_20_1 in pairs(var_20_1) do
		local var_20_4 = iter_20_1.template

		if var_20_2 then
			var_20_4.server.level_object_killed_function(var_20_0, iter_20_1, arg_20_1, arg_20_2)
		end

		if var_20_3 then
			var_20_4.client.level_object_killed_function(var_20_0, iter_20_1, arg_20_1, arg_20_2)
		end
	end
end

MutatorHandler.ai_hit_by_player = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0._mutator_context
	local var_21_1 = arg_21_0._active_mutators
	local var_21_2 = arg_21_0._is_server
	local var_21_3 = arg_21_0._has_local_client

	for iter_21_0, iter_21_1 in pairs(var_21_1) do
		local var_21_4 = iter_21_1.template

		if var_21_2 then
			var_21_4.server.ai_hit_by_player_function(var_21_0, iter_21_1, arg_21_1, arg_21_2, arg_21_3)
		end

		if var_21_3 then
			var_21_4.client.ai_hit_by_player_function(var_21_0, iter_21_1, arg_21_1, arg_21_2, arg_21_3)
		end
	end
end

MutatorHandler.player_hit = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0._mutator_context
	local var_22_1 = arg_22_0._active_mutators
	local var_22_2 = arg_22_0._is_server
	local var_22_3 = arg_22_0._has_local_client

	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		local var_22_4 = iter_22_1.template

		if var_22_2 then
			var_22_4.server.player_hit_function(var_22_0, iter_22_1, arg_22_1, arg_22_2, arg_22_3)
		end

		if var_22_3 then
			var_22_4.client.player_hit_function(var_22_0, iter_22_1, arg_22_1, arg_22_2, arg_22_3)
		end
	end
end

MutatorHandler.modify_player_base_damage = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = arg_23_0._mutator_context
	local var_23_1 = arg_23_0._active_mutators
	local var_23_2 = arg_23_0._is_server

	for iter_23_0, iter_23_1 in pairs(var_23_1) do
		local var_23_3 = iter_23_1.template

		if var_23_2 and var_23_3.modify_player_base_damage then
			arg_23_3 = var_23_3.modify_player_base_damage(var_23_0, iter_23_1, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
		end
	end

	return arg_23_3
end

MutatorHandler.player_respawned = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._mutator_context
	local var_24_1 = arg_24_0._active_mutators
	local var_24_2 = arg_24_0._is_server
	local var_24_3 = arg_24_0._has_local_client

	for iter_24_0, iter_24_1 in pairs(var_24_1) do
		local var_24_4 = iter_24_1.template

		if var_24_2 then
			var_24_4.server.player_respawned_function(var_24_0, iter_24_1, arg_24_1)
		end

		if var_24_3 then
			var_24_4.client.player_respawned_function(var_24_0, iter_24_1, arg_24_1)
		end
	end
end

MutatorHandler.damage_taken = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0 = arg_25_0._mutator_context
	local var_25_1 = arg_25_0._active_mutators
	local var_25_2 = arg_25_0._is_server
	local var_25_3 = arg_25_0._has_local_client

	for iter_25_0, iter_25_1 in pairs(var_25_1) do
		local var_25_4 = iter_25_1.template

		if var_25_2 then
			var_25_4.server.damage_taken_function(var_25_0, iter_25_1, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
		end

		if var_25_3 then
			var_25_4.client.damage_taken_function(var_25_0, iter_25_1, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
		end
	end
end

MutatorHandler.pre_ai_spawned = function (arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0._is_server then
		return
	end

	local var_26_0 = arg_26_0._mutator_context
	local var_26_1 = arg_26_0._active_mutators

	for iter_26_0, iter_26_1 in pairs(var_26_1) do
		local var_26_2 = iter_26_1.template

		if var_26_2.server.pre_ai_spawned_function then
			var_26_2.server.pre_ai_spawned_function(var_26_0, iter_26_1, arg_26_1, arg_26_2)
		end
	end
end

MutatorHandler.ai_spawned = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._mutator_context
	local var_27_1 = arg_27_0._active_mutators
	local var_27_2 = arg_27_0._is_server
	local var_27_3 = arg_27_0._has_local_client

	for iter_27_0, iter_27_1 in pairs(var_27_1) do
		local var_27_4 = iter_27_1.template

		if var_27_2 then
			var_27_4.server.ai_spawned_function(var_27_0, iter_27_1, arg_27_1)
		end

		if var_27_3 then
			var_27_4.client.ai_spawned_function(var_27_0, iter_27_1, arg_27_1)
		end
	end
end

MutatorHandler.post_ai_spawned = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	if not arg_28_0._is_server then
		return
	end

	local var_28_0 = arg_28_0._mutator_context
	local var_28_1 = arg_28_0._active_mutators

	for iter_28_0, iter_28_1 in pairs(var_28_1) do
		local var_28_2 = iter_28_1.template

		if var_28_2.server.post_ai_spawned_function then
			var_28_2.server.post_ai_spawned_function(var_28_0, iter_28_1, arg_28_1, arg_28_2, arg_28_3)
		end
	end
end

MutatorHandler.players_left_safe_zone = function (arg_29_0)
	local var_29_0 = arg_29_0._mutator_context
	local var_29_1 = arg_29_0._active_mutators
	local var_29_2 = arg_29_0._is_server

	for iter_29_0, iter_29_1 in pairs(var_29_1) do
		local var_29_3 = iter_29_1.template

		if var_29_2 then
			var_29_3.server.server_players_left_safe_zone(var_29_0, iter_29_1)
		end
	end
end

MutatorHandler.evaluate_lose_conditions = function (arg_30_0)
	fassert(arg_30_0._is_server, "evaluate_lose_conditions only runs on server")

	local var_30_0 = arg_30_0._mutator_context
	local var_30_1 = arg_30_0._active_mutators
	local var_30_2 = false
	local var_30_3

	for iter_30_0, iter_30_1 in pairs(var_30_1) do
		local var_30_4 = iter_30_1.template

		if var_30_4.lose_condition_function then
			local var_30_5, var_30_6 = var_30_4.lose_condition_function(var_30_0, iter_30_1)

			if var_30_5 then
				if var_30_6 and (var_30_3 == nil or var_30_3 < var_30_6) then
					var_30_3 = var_30_6
				end

				var_30_2 = var_30_5
			end
		end
	end

	return var_30_2, var_30_3
end

MutatorHandler.evaluate_end_zone_activation_conditions = function (arg_31_0)
	fassert(arg_31_0._is_server, "evaluate_end_zone_activation_conditions only runs on server")

	local var_31_0 = arg_31_0._mutator_context
	local var_31_1 = arg_31_0._active_mutators

	for iter_31_0, iter_31_1 in pairs(var_31_1) do
		local var_31_2 = iter_31_1.template

		if var_31_2.end_zone_activation_condition_function and not var_31_2.end_zone_activation_condition_function(var_31_0, iter_31_1) then
			return false
		end
	end

	return true
end

MutatorHandler.post_process_terror_event = function (arg_32_0, arg_32_1)
	fassert(arg_32_0._is_server, "post_process_terror_event only runs on server")

	local var_32_0 = arg_32_0._mutator_context
	local var_32_1 = arg_32_0._active_mutators

	for iter_32_0, iter_32_1 in pairs(var_32_1) do
		local var_32_2 = iter_32_1.template

		if var_32_2.post_process_terror_event then
			var_32_2.post_process_terror_event(var_32_0, iter_32_1, arg_32_1)
		end
	end
end

MutatorHandler.pickup_settings_updated_settings = function (arg_33_0, arg_33_1)
	if not arg_33_0._is_server then
		return
	end

	if not arg_33_1 then
		return nil
	end

	local var_33_0 = table.clone(arg_33_1)
	local var_33_1 = {}
	local var_33_2 = arg_33_0._mutators

	for iter_33_0, iter_33_1 in pairs(var_33_2) do
		local var_33_3 = iter_33_1.template.pickup_system_multipliers

		if var_33_3 then
			for iter_33_2, iter_33_3 in pairs(var_33_3) do
				if var_33_1[iter_33_2] then
					var_33_1[iter_33_2] = var_33_1[iter_33_2] * iter_33_3
				else
					var_33_1[iter_33_2] = iter_33_3
				end
			end
		end
	end

	local function var_33_4(arg_34_0, arg_34_1, arg_34_2)
		if var_33_1[arg_34_1] then
			return math.ceil(arg_34_2 * var_33_1[arg_34_1])
		elseif var_33_1[arg_34_0] then
			return math.ceil(arg_34_2 * var_33_1[arg_34_0])
		else
			return arg_34_2
		end
	end

	for iter_33_4, iter_33_5 in pairs(var_33_0) do
		if type(iter_33_5) == "table" then
			for iter_33_6, iter_33_7 in pairs(iter_33_5) do
				iter_33_5[iter_33_6] = var_33_4(iter_33_4, iter_33_6, iter_33_7)
			end
		else
			var_33_0[iter_33_4] = var_33_4(iter_33_4, nil, iter_33_5)
		end
	end

	return var_33_0
end

MutatorHandler.conflict_director_updated_settings = function (arg_35_0)
	if not arg_35_0._is_server then
		return
	end

	local var_35_0 = arg_35_0._mutator_context
	local var_35_1 = arg_35_0._mutators

	for iter_35_0, iter_35_1 in pairs(var_35_1) do
		local var_35_2 = iter_35_1.template

		if var_35_2.update_conflict_settings then
			var_35_2.update_conflict_settings(var_35_0, iter_35_1)
		end
	end
end

MutatorHandler.get_terror_event_tags = function (arg_36_0)
	local var_36_0 = arg_36_0._mutator_context
	local var_36_1 = arg_36_0._mutators
	local var_36_2

	for iter_36_0, iter_36_1 in pairs(var_36_1) do
		local var_36_3 = iter_36_1.template

		if var_36_3.get_terror_event_tags then
			var_36_2 = var_36_2 or {}

			var_36_3.get_terror_event_tags(var_36_0, iter_36_1, var_36_2)
		end
	end

	return var_36_2
end

MutatorHandler.tweak_zones = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	if not arg_37_0._is_server then
		return
	end

	local var_37_0 = arg_37_0._mutator_context
	local var_37_1 = arg_37_0._mutators

	for iter_37_0, iter_37_1 in pairs(var_37_1) do
		local var_37_2 = iter_37_1.template

		if var_37_2.tweak_zones then
			var_37_2.tweak_zones(var_37_0, iter_37_1, arg_37_1, arg_37_2, arg_37_3)
		end
	end

	return arg_37_2
end

MutatorHandler._server_initialize_mutator = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	fassert(arg_38_0._is_server, "Only server is allowed to run mutator initialization function.")

	if not MutatorTemplates[arg_38_1] then
		mutator_print("No such template (%s)", arg_38_1)

		return
	end

	local var_38_0 = arg_38_0._mutators

	fassert(var_38_0[arg_38_1] == nil, "Can't initialize an already initialized mutator (%s)", arg_38_1)
	fassert(arg_38_2[arg_38_1] == nil, "Can't initialize an activated mutator (%s)", arg_38_1)

	local var_38_1 = MutatorTemplates[arg_38_1]
	local var_38_2 = {
		template = var_38_1
	}

	mutator_print("Initializing mutator '%s'", arg_38_1)

	local var_38_3 = var_38_1.server

	if var_38_3.initialize_function then
		var_38_3.initialize_function(arg_38_3, var_38_2)
	end

	arg_38_0._mutators[arg_38_1] = var_38_2
	arg_38_0._initialized_mutator_map[arg_38_1] = true
end

MutatorHandler._activate_mutator = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
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

	if arg_39_5 then
		arg_39_4.deactivate_at_t = Managers.time:time("game") + arg_39_5
	end

	arg_39_2[arg_39_1] = arg_39_4

	if arg_39_0._is_server then
		local var_39_1 = var_39_0.server

		if var_39_1.start_function then
			var_39_1.start_function(arg_39_3, arg_39_4)
		end
	end

	if arg_39_0._has_local_client then
		local var_39_2 = var_39_0.client

		if var_39_2.start_function then
			var_39_2.start_function(arg_39_3, arg_39_4)
		end
	end

	if var_39_0.register_rpcs then
		var_39_0.register_rpcs(arg_39_3, arg_39_4, arg_39_0.network_event_delegate)
	end

	if arg_39_0._is_server then
		local var_39_3 = NetworkLookup.mutator_templates[arg_39_1]
		local var_39_4 = not not arg_39_4.activated_by_twitch

		arg_39_0._network_transmit:send_rpc_clients("rpc_activate_mutator_client", var_39_3, var_39_4)
	end
end

MutatorHandler._deactivate_mutator = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	fassert(arg_40_2[arg_40_1], "Trying to deactivate mutator (%s) but it isn't active", arg_40_1)
	mutator_print("Deactivating mutator '%s'", arg_40_1)

	local var_40_0 = MutatorTemplates[arg_40_1]
	local var_40_1 = arg_40_2[arg_40_1]

	if var_40_0.unregister_rpcs then
		var_40_0.unregister_rpcs(arg_40_3, var_40_1)
	end

	arg_40_2[arg_40_1] = nil
	arg_40_0._mutators[arg_40_1] = nil

	if arg_40_0._is_server then
		local var_40_2 = var_40_0.server

		if var_40_2.stop_function then
			var_40_2.stop_function(arg_40_3, var_40_1, arg_40_4)
		end

		arg_40_0._initialized_mutator_map[arg_40_1] = nil

		arg_40_0._network_handler:get_network_state():set_initialized_mutator_map(table.shallow_copy(arg_40_0._initialized_mutator_map))
	end

	if arg_40_0._has_local_client then
		local var_40_3 = var_40_0.client

		if var_40_3.stop_function then
			var_40_3.stop_function(arg_40_3, var_40_1, arg_40_4)
		end
	end

	if arg_40_0._is_server and not arg_40_4 then
		local var_40_4 = NetworkLookup.mutator_templates[arg_40_1]

		arg_40_0._network_transmit:send_rpc_clients("rpc_deactivate_mutator_client", var_40_4)
	end
end

MutatorHandler.tweak_pack_spawning_settings = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0

	local function var_41_1(arg_42_0)
		for iter_42_0, iter_42_1 in ipairs(arg_42_0) do
			local var_42_0 = MutatorTemplates[iter_42_1]

			if var_42_0.tweak_pack_spawning_settings then
				if not var_41_0 then
					var_41_0 = table.clone(arg_41_3)
				end

				var_42_0.tweak_pack_spawning_settings(arg_41_2, var_41_0)
			end
		end
	end

	var_41_1(arg_41_1)
	var_41_1(arg_41_0)

	return var_41_0 or arg_41_3
end

MutatorHandler.rpc_activate_mutator_client = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	fassert(not arg_43_0._is_server, "Only call rpc_activate_mutator_client on clients.")

	local var_43_0 = NetworkLookup.mutator_templates[arg_43_2]
	local var_43_1 = arg_43_0._active_mutators
	local var_43_2 = arg_43_0._mutator_context
	local var_43_3 = {
		template = MutatorTemplates[var_43_0],
		activated_by_twitch = arg_43_3
	}

	arg_43_0:_activate_mutator(var_43_0, var_43_1, var_43_2, var_43_3)
end

MutatorHandler.rpc_deactivate_mutator_client = function (arg_44_0, arg_44_1, arg_44_2)
	fassert(not arg_44_0._is_server, "Only call rpc_deactivate_mutator_client on clients.")

	local var_44_0 = NetworkLookup.mutator_templates[arg_44_2]
	local var_44_1 = arg_44_0._active_mutators
	local var_44_2 = arg_44_0._mutator_context

	arg_44_0:_deactivate_mutator(var_44_0, var_44_1, var_44_2)
end

MutatorHandler.on_client_mutator_list_updated = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7)
	arg_45_0._initialized_mutator_map = arg_45_7
end
