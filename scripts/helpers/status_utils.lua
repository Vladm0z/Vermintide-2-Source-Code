-- chunkname: @scripts/helpers/status_utils.lua

StatusUtils = {}

StatusUtils.set_wounded_network = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)
	ScriptUnit.extension(arg_1_0, "status_system"):set_wounded(arg_1_1, arg_1_2, arg_1_3)

	if not LEVEL_EDITOR_TEST then
		local var_1_0 = Managers.state.network
		local var_1_1 = var_1_0:unit_game_object_id(arg_1_0)
		local var_1_2 = NetworkLookup.set_wounded_reasons[arg_1_2]

		var_1_0.network_transmit:send_rpc_clients("rpc_set_wounded", var_1_1, arg_1_1, var_1_2)
	end
end

StatusUtils.set_knocked_down_network = function (arg_2_0, arg_2_1)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST, "can only knock down on server")
	ScriptUnit.extension(arg_2_0, "status_system"):set_knocked_down(arg_2_1)

	if not LEVEL_EDITOR_TEST then
		local var_2_0 = Managers.state.network
		local var_2_1 = var_2_0:unit_game_object_id(arg_2_0)

		var_2_0.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.knocked_down, arg_2_1, var_2_1, 0)
	end
end

StatusUtils.set_revived_network = function (arg_3_0, arg_3_1, arg_3_2)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST, "Only the server is allowed to decide who is revived and who isn't since it owns damage and interactions.")

	if not arg_3_0 then
		return
	end

	local var_3_0 = ScriptUnit.has_extension(arg_3_0, "status_system")

	if var_3_0 then
		var_3_0:set_revived(arg_3_1, arg_3_2)

		if not LEVEL_EDITOR_TEST then
			local var_3_1 = Managers.state.network
			local var_3_2 = var_3_1:unit_game_object_id(arg_3_0)
			local var_3_3 = arg_3_2 and var_3_1:unit_game_object_id(arg_3_2) or NetworkConstants.invalid_game_object_id

			var_3_1.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.revived, arg_3_1, var_3_2, var_3_3)
		end
	end
end

StatusUtils.set_respawned_network = function (arg_4_0, arg_4_1, arg_4_2)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)

	local var_4_0 = ScriptUnit.extension(arg_4_0, "status_system")

	if not arg_4_1 then
		var_4_0:set_respawned(arg_4_1)

		if not LEVEL_EDITOR_TEST then
			local var_4_1 = Managers.state.network
			local var_4_2 = var_4_1:unit_game_object_id(arg_4_0)
			local var_4_3 = arg_4_2 and var_4_1:unit_game_object_id(arg_4_2) or NetworkConstants.invalid_game_object_id

			var_4_1.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.respawned, arg_4_1, var_4_2, var_4_3)
		end
	elseif not LEVEL_EDITOR_TEST then
		local var_4_4 = Managers.state.network
		local var_4_5 = var_4_4:unit_game_object_id(arg_4_0) or 0
		local var_4_6 = arg_4_2 and var_4_4:unit_game_object_id(arg_4_2) or 0
		local var_4_7 = Managers.player:owner(arg_4_0):network_id()

		var_4_4.network_transmit:send_rpc("rpc_status_change_bool", var_4_7, NetworkLookup.statuses.assisted_respawning, arg_4_1, var_4_5, var_4_6)
	end
end

StatusUtils.set_pulled_up_network = function (arg_5_0, arg_5_1, arg_5_2)
	ScriptUnit.extension(arg_5_0, "status_system"):set_pulled_up(arg_5_1, arg_5_2)

	if not LEVEL_EDITOR_TEST then
		local var_5_0 = Managers.state.network
		local var_5_1 = var_5_0:unit_game_object_id(arg_5_0)
		local var_5_2 = arg_5_2 and var_5_0:unit_game_object_id(arg_5_2) or NetworkConstants.invalid_game_object_id

		if Managers.player.is_server then
			var_5_0.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.pulled_up, arg_5_1, var_5_1, var_5_2)
		else
			var_5_0.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.pulled_up, arg_5_1, var_5_1, var_5_2)
		end
	end
end

StatusUtils.set_grabbed_by_pack_master_network = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if not Managers.state.network:game() then
		return
	end

	local var_6_0 = ScriptUnit.has_extension(arg_6_1, "status_system")

	if not var_6_0 then
		return
	end

	var_6_0:set_pack_master(arg_6_0, arg_6_2, arg_6_3)

	if not LEVEL_EDITOR_TEST then
		local var_6_1 = Managers.state.network
		local var_6_2 = var_6_1:unit_game_object_id(arg_6_1)
		local var_6_3 = var_6_1:unit_game_object_id(arg_6_3) or NetworkConstants.invalid_game_object_id
		local var_6_4 = NetworkLookup.statuses[arg_6_0]

		if Managers.player.is_server then
			var_6_1.network_transmit:send_rpc_clients("rpc_status_change_bool", var_6_4, arg_6_2, var_6_2, var_6_3)
		else
			var_6_1.network_transmit:send_rpc_server("rpc_status_change_bool", var_6_4, arg_6_2, var_6_2, var_6_3)
		end
	end
end

StatusUtils.set_grabbed_by_corruptor_network = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not Managers.state.network:game() then
		return
	end

	ScriptUnit.extension(arg_7_1, "status_system"):set_grabbed_by_corruptor(arg_7_0, arg_7_2, arg_7_3)

	if not LEVEL_EDITOR_TEST then
		local var_7_0 = Managers.state.network
		local var_7_1 = var_7_0:unit_game_object_id(arg_7_1)
		local var_7_2 = var_7_0:unit_game_object_id(arg_7_3) or NetworkConstants.invalid_game_object_id
		local var_7_3 = NetworkLookup.statuses[arg_7_0]

		if Managers.player.is_server then
			var_7_0.network_transmit:send_rpc_clients("rpc_status_change_bool", var_7_3, arg_7_2, var_7_1, var_7_2)
		else
			var_7_0.network_transmit:send_rpc_server("rpc_status_change_bool", var_7_3, arg_7_2, var_7_1, var_7_2)
		end
	end
end

StatusUtils.set_pushed_network = function (arg_8_0, arg_8_1)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)

	local var_8_0 = Managers.time:time("game")

	ScriptUnit.extension(arg_8_0, "status_system"):set_pushed(arg_8_1, var_8_0)

	if not LEVEL_EDITOR_TEST then
		local var_8_1 = Managers.state.network
		local var_8_2 = var_8_1:unit_game_object_id(arg_8_0)

		var_8_1.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.pushed, arg_8_1, var_8_2, 0)
	end
end

StatusUtils.set_charged_network = function (arg_9_0, arg_9_1)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)

	local var_9_0 = Managers.time:time("game")

	ScriptUnit.extension(arg_9_0, "status_system"):set_charged(arg_9_1, var_9_0)

	if not LEVEL_EDITOR_TEST then
		local var_9_1 = Managers.state.network
		local var_9_2 = var_9_1:unit_game_object_id(arg_9_0)

		var_9_1.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.charged, arg_9_1, var_9_2, 0)
	end
end

StatusUtils.set_catapulted_network = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Managers.player
	local var_10_1 = var_10_0:unit_owner(arg_10_0)

	if not var_10_1.remote then
		ScriptUnit.extension(arg_10_0, "status_system"):set_catapulted(arg_10_1, arg_10_2)
	elseif var_10_0.is_server or DEDICATED_SERVER then
		local var_10_2 = Managers.state.network
		local var_10_3 = var_10_2:unit_game_object_id(arg_10_0)
		local var_10_4 = var_10_1:network_id()

		if not var_10_3 then
			return
		end

		var_10_2.network_transmit:send_rpc("rpc_set_catapulted", var_10_4, var_10_3, arg_10_1, arg_10_2 or Vector.zero())
	else
		local var_10_5 = Managers.state.network
		local var_10_6 = var_10_5:unit_game_object_id(arg_10_0)

		if not var_10_6 then
			return
		end

		var_10_5.network_transmit:send_rpc_server("rpc_set_catapulted", var_10_6, arg_10_1, arg_10_2 or Vector.zero())
	end
end

StatusUtils.set_grabbed_by_tentacle_network = function (arg_11_0, arg_11_1, arg_11_2)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)
	ScriptUnit.extension(arg_11_0, "status_system"):set_grabbed_by_tentacle(arg_11_1, arg_11_2)

	if not LEVEL_EDITOR_TEST then
		local var_11_0 = Managers.state.network
		local var_11_1 = var_11_0:unit_game_object_id(arg_11_0)
		local var_11_2 = var_11_0:unit_game_object_id(arg_11_2)

		var_11_0.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.grabbed_by_tentacle, arg_11_1, var_11_1, var_11_2)
	end
end

StatusUtils.set_grabbed_by_tentacle_status_network = function (arg_12_0, arg_12_1)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)
	ScriptUnit.extension(arg_12_0, "status_system"):set_grabbed_by_tentacle_status(arg_12_1)

	if not LEVEL_EDITOR_TEST then
		local var_12_0 = Managers.state.network
		local var_12_1 = var_12_0:unit_game_object_id(arg_12_0)
		local var_12_2 = NetworkLookup.grabbed_by_tentacle[arg_12_1]

		var_12_0.network_transmit:send_rpc_clients("rpc_status_change_int", NetworkLookup.statuses.grabbed_by_tentacle, var_12_2, var_12_1)
	end
end

StatusUtils.set_grabbed_by_chaos_spawn_network = function (arg_13_0, arg_13_1, arg_13_2)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)
	ScriptUnit.extension(arg_13_0, "status_system"):set_grabbed_by_chaos_spawn(arg_13_1, arg_13_2)

	if not LEVEL_EDITOR_TEST then
		local var_13_0 = Managers.state.network
		local var_13_1 = var_13_0:unit_game_object_id(arg_13_0)
		local var_13_2 = var_13_0:unit_game_object_id(arg_13_2)

		var_13_0.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.grabbed_by_chaos_spawn, arg_13_1, var_13_1, var_13_2)
	end
end

StatusUtils.set_grabbed_by_chaos_spawn_status_network = function (arg_14_0, arg_14_1)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)
	ScriptUnit.extension(arg_14_0, "status_system"):set_grabbed_by_chaos_spawn_status(arg_14_1)

	if not LEVEL_EDITOR_TEST then
		local var_14_0 = Managers.state.network
		local var_14_1 = var_14_0:unit_game_object_id(arg_14_0)
		local var_14_2 = NetworkLookup.grabbed_by_chaos_spawn[arg_14_1]

		var_14_0.network_transmit:send_rpc_clients("rpc_status_change_int", NetworkLookup.statuses.grabbed_by_chaos_spawn, var_14_2, var_14_1)
	end
end

StatusUtils.set_in_vortex_network = function (arg_15_0, arg_15_1, arg_15_2)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)

	if not ALIVE[arg_15_0] then
		return false
	end

	ScriptUnit.extension(arg_15_0, "status_system"):set_in_vortex(arg_15_1, arg_15_2)

	if not LEVEL_EDITOR_TEST then
		local var_15_0 = Managers.state.network
		local var_15_1 = var_15_0:unit_game_object_id(arg_15_0)
		local var_15_2 = var_15_0:unit_game_object_id(arg_15_2) or NetworkConstants.invalid_game_object_id

		var_15_0.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.in_vortex, arg_15_1, var_15_1, var_15_2)
	end

	return true
end

StatusUtils.set_near_vortex_network = function (arg_16_0, arg_16_1, arg_16_2)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)
	ScriptUnit.extension(arg_16_0, "status_system"):set_near_vortex(arg_16_1, arg_16_2)

	if not LEVEL_EDITOR_TEST then
		local var_16_0 = Managers.state.network
		local var_16_1 = var_16_0:unit_game_object_id(arg_16_0)
		local var_16_2 = var_16_0:unit_game_object_id(arg_16_2) or NetworkConstants.invalid_game_object_id

		var_16_0.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.near_vortex, arg_16_1, var_16_1, var_16_2)
	end
end

StatusUtils.set_in_liquid_network = function (arg_17_0, arg_17_1, arg_17_2)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)
	ScriptUnit.extension(arg_17_0, "status_system"):set_in_liquid(arg_17_1, arg_17_2)

	if not LEVEL_EDITOR_TEST then
		local var_17_0 = Managers.state.network
		local var_17_1 = var_17_0:unit_game_object_id(arg_17_0)
		local var_17_2 = var_17_0:unit_game_object_id(arg_17_2) or NetworkConstants.invalid_game_object_id

		var_17_0.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.in_liquid, arg_17_1, var_17_1, var_17_2)
	end
end

StatusUtils.set_overpowered_network = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	fassert(Managers.player.is_server or LEVEL_EDITOR_TEST)
	ScriptUnit.extension(arg_18_0, "status_system"):set_overpowered(arg_18_1, arg_18_2, arg_18_3)

	if not LEVEL_EDITOR_TEST then
		local var_18_0 = Managers.state.network
		local var_18_1 = var_18_0:unit_game_object_id(arg_18_0)

		if var_18_1 and var_18_1 ~= NetworkConstants.invalid_game_object_id then
			local var_18_2 = var_18_0:unit_game_object_id(arg_18_3) or NetworkConstants.invalid_game_object_id
			local var_18_3 = arg_18_1 and NetworkLookup.overpowered_templates[arg_18_2] or 0

			var_18_0.network_transmit:send_rpc_clients("rpc_status_change_int_and_unit", NetworkLookup.statuses.overpowered, var_18_3, var_18_1, var_18_2)
		end
	end
end

StatusUtils.set_overcharge_exploding = function (arg_19_0, arg_19_1)
	ScriptUnit.extension(arg_19_0, "status_system"):set_overcharge_exploding(arg_19_1)

	if not LEVEL_EDITOR_TEST then
		local var_19_0 = Managers.state.network
		local var_19_1 = var_19_0:unit_game_object_id(arg_19_0)

		if Managers.player.is_server then
			var_19_0.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.overcharge_exploding, arg_19_1, var_19_1, 0)
		else
			var_19_0.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.overcharge_exploding, arg_19_1, var_19_1, 0)
		end
	end
end

StatusUtils.use_soft_collision = function (arg_20_0)
	local var_20_0 = ScriptUnit.extension(arg_20_0, "status_system")

	return not (var_20_0:is_using_transport() or var_20_0:get_inside_transport_unit() or var_20_0:is_disabled() or var_20_0:is_knocked_down() or var_20_0:is_pounced_down())
end

StatusUtils.replenish_stamina_local_players = function (arg_21_0, arg_21_1)
	local var_21_0 = Managers.player:players_at_peer(Network.peer_id())

	if var_21_0 then
		for iter_21_0, iter_21_1 in pairs(var_21_0) do
			local var_21_1 = iter_21_1.player_unit

			if Unit.alive(var_21_1) and var_21_1 ~= arg_21_0 then
				local var_21_2 = ScriptUnit.extension(var_21_1, "status_system")

				var_21_2:add_fatigue_points(arg_21_1)
				var_21_2:set_has_bonus_fatigue_active()
			end
		end
	end
end

StatusUtils.set_pounced_down_network = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if not Managers.state.network:game() then
		return
	end

	if not LEVEL_EDITOR_TEST then
		local var_22_0 = Managers.state.network
		local var_22_1 = var_22_0:unit_game_object_id(arg_22_1)
		local var_22_2 = var_22_0:unit_game_object_id(arg_22_3) or NetworkConstants.invalid_game_object_id
		local var_22_3 = NetworkLookup.statuses[arg_22_0]

		if DEDICATED_SERVER then
			var_22_0.network_transmit:send_rpc_clients("rpc_status_change_bool", var_22_3, arg_22_2, var_22_1, var_22_2)
		elseif Managers.player.is_server then
			ScriptUnit.extension(arg_22_1, "status_system"):set_pounced_down(arg_22_2, arg_22_3)
		else
			var_22_0.network_transmit:send_rpc_server("rpc_status_change_bool", var_22_3, arg_22_2, var_22_1, var_22_2)
		end
	end
end
