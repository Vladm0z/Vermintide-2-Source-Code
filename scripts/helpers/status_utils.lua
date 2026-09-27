-- chunkname: @scripts/helpers/status_utils.lua

StatusUtils = {}

StatusUtils.set_wounded_network = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)
	ScriptUnit.extension(arg_1_0, "status_system"):set_wounded(arg_1_1, arg_1_2, arg_1_3)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_1_0)
		local var_1_4 = NetworkLookup.set_wounded_reasons[arg_1_2]

		network.network_transmit:send_rpc_clients("rpc_set_wounded", unit_game_object_id, arg_1_1, var_1_4)
	end
end

StatusUtils.set_knocked_down_network = function (arg_2_0, arg_2_1)
	-- function 2
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "can only knock down on server")
	ScriptUnit.extension(arg_2_0, "status_system"):set_knocked_down(arg_2_1)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_2_0)

		network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.knocked_down, arg_2_1, unit_game_object_id, 0)
	end
end

StatusUtils.set_revived_network = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "Only the server is allowed to decide who is revived and who isn't since it owns damage and interactions.")

	if not arg_3_0 then
		return
	end

	local has_extension = ScriptUnit.has_extension(arg_3_0, "status_system")

	if not has_extension then
		has_extension:set_revived(arg_3_1, arg_3_2)

		if not LEVEL_EDITOR_TEST then
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(arg_3_0)
			local unit_game_object_id_2

			if not arg_3_2 then
				unit_game_object_id_2 = network:unit_game_object_id(arg_3_2)

				if not unit_game_object_id_2 then
					-- Nothing
				end
			end

			unit_game_object_id_2 = NetworkConstants.invalid_game_object_id

			::label_3_0::

			network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.revived, arg_3_1, unit_game_object_id, unit_game_object_id_2)
		end
	end
end

StatusUtils.set_respawned_network = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)

	local extension = ScriptUnit.extension(arg_4_0, "status_system")

	if not arg_4_1 then
		extension:set_respawned(arg_4_1)

		if not LEVEL_EDITOR_TEST then
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(arg_4_0)
			local unit_game_object_id_2

			if not arg_4_2 then
				unit_game_object_id_2 = network:unit_game_object_id(arg_4_2)

				if not unit_game_object_id_2 then
					-- Nothing
				end
			end

			unit_game_object_id_2 = NetworkConstants.invalid_game_object_id

			::label_4_0::

			network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.respawned, arg_4_1, unit_game_object_id, unit_game_object_id_2)
		end
	elseif not LEVEL_EDITOR_TEST then
		local network_2 = Managers.state.network
		local unit_game_object_id_3 = network_2:unit_game_object_id(arg_4_0)

		unit_game_object_id_3 = unit_game_object_id_3 or 0

		local unit_game_object_id_4

		if not arg_4_2 then
			unit_game_object_id_4 = network_2:unit_game_object_id(arg_4_2)

			if not unit_game_object_id_4 then
				-- Nothing
			end
		end

		unit_game_object_id_4 = 0

		::label_4_1::

		local network_id = Managers.player:owner(arg_4_0):network_id()

		network_2.network_transmit:send_rpc("rpc_status_change_bool", network_id, NetworkLookup.statuses.assisted_respawning, arg_4_1, unit_game_object_id_3, unit_game_object_id_4)
	end
end

StatusUtils.set_pulled_up_network = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	ScriptUnit.extension(arg_5_0, "status_system"):set_pulled_up(arg_5_1, arg_5_2)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_5_0)
		local unit_game_object_id_2

		if not arg_5_2 then
			unit_game_object_id_2 = network:unit_game_object_id(arg_5_2)

			if not unit_game_object_id_2 then
				-- Nothing
			end
		end

		unit_game_object_id_2 = NetworkConstants.invalid_game_object_id

		::label_5_0::

		if not Managers.player.is_server then
			network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.pulled_up, arg_5_1, unit_game_object_id, unit_game_object_id_2)
		else
			network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.pulled_up, arg_5_1, unit_game_object_id, unit_game_object_id_2)
		end
	end
end

StatusUtils.set_grabbed_by_pack_master_network = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not Managers.state.network:game() then
		return
	end

	local has_extension = ScriptUnit.has_extension(arg_6_1, "status_system")

	if not has_extension then
		return
	end

	has_extension:set_pack_master(arg_6_0, arg_6_2, arg_6_3)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_6_1)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_6_3)

		unit_game_object_id_2 = unit_game_object_id_2 or NetworkConstants.invalid_game_object_id

		local var_6_4 = NetworkLookup.statuses[arg_6_0]

		if not Managers.player.is_server then
			network.network_transmit:send_rpc_clients("rpc_status_change_bool", var_6_4, arg_6_2, unit_game_object_id, unit_game_object_id_2)
		else
			network.network_transmit:send_rpc_server("rpc_status_change_bool", var_6_4, arg_6_2, unit_game_object_id, unit_game_object_id_2)
		end
	end
end

StatusUtils.set_grabbed_by_corruptor_network = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not Managers.state.network:game() then
		return
	end

	ScriptUnit.extension(arg_7_1, "status_system"):set_grabbed_by_corruptor(arg_7_0, arg_7_2, arg_7_3)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_7_1)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_7_3)

		unit_game_object_id_2 = unit_game_object_id_2 or NetworkConstants.invalid_game_object_id

		local var_7_3 = NetworkLookup.statuses[arg_7_0]

		if not Managers.player.is_server then
			network.network_transmit:send_rpc_clients("rpc_status_change_bool", var_7_3, arg_7_2, unit_game_object_id, unit_game_object_id_2)
		else
			network.network_transmit:send_rpc_server("rpc_status_change_bool", var_7_3, arg_7_2, unit_game_object_id, unit_game_object_id_2)
		end
	end
end

StatusUtils.set_pushed_network = function (arg_8_0, arg_8_1)
	-- function 8
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)

	local time = Managers.time:time("game")

	ScriptUnit.extension(arg_8_0, "status_system"):set_pushed(arg_8_1, time)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_8_0)

		network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.pushed, arg_8_1, unit_game_object_id, 0)
	end
end

StatusUtils.set_charged_network = function (arg_9_0, arg_9_1)
	-- function 9
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)

	local time = Managers.time:time("game")

	ScriptUnit.extension(arg_9_0, "status_system"):set_charged(arg_9_1, time)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_9_0)

		network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.charged, arg_9_1, unit_game_object_id, 0)
	end
end

StatusUtils.set_catapulted_network = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local player = Managers.player
	local unit_owner = player:unit_owner(arg_10_0)

	if not unit_owner.remote then
		ScriptUnit.extension(arg_10_0, "status_system"):set_catapulted(arg_10_1, arg_10_2)
	elseif player.is_server or not DEDICATED_SERVER then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_10_0)
		local network_id = unit_owner:network_id()

		if not unit_game_object_id then
			return
		end

		network.network_transmit:send_rpc("rpc_set_catapulted", network_id, unit_game_object_id, arg_10_1, arg_10_2 or Vector.zero())
	else
		local network_2 = Managers.state.network
		local unit_game_object_id_2 = network_2:unit_game_object_id(arg_10_0)

		if not unit_game_object_id_2 then
			return
		end

		network_2.network_transmit:send_rpc_server("rpc_set_catapulted", unit_game_object_id_2, arg_10_1, arg_10_2 or Vector.zero())
	end
end

StatusUtils.set_grabbed_by_tentacle_network = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)
	ScriptUnit.extension(arg_11_0, "status_system"):set_grabbed_by_tentacle(arg_11_1, arg_11_2)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_11_0)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_11_2)

		network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.grabbed_by_tentacle, arg_11_1, unit_game_object_id, unit_game_object_id_2)
	end
end

StatusUtils.set_grabbed_by_tentacle_status_network = function (arg_12_0, arg_12_1)
	-- function 12
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)
	ScriptUnit.extension(arg_12_0, "status_system"):set_grabbed_by_tentacle_status(arg_12_1)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_12_0)
		local var_12_4 = NetworkLookup.grabbed_by_tentacle[arg_12_1]

		network.network_transmit:send_rpc_clients("rpc_status_change_int", NetworkLookup.statuses.grabbed_by_tentacle, var_12_4, unit_game_object_id)
	end
end

StatusUtils.set_grabbed_by_chaos_spawn_network = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)
	ScriptUnit.extension(arg_13_0, "status_system"):set_grabbed_by_chaos_spawn(arg_13_1, arg_13_2)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_13_0)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_13_2)

		network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.grabbed_by_chaos_spawn, arg_13_1, unit_game_object_id, unit_game_object_id_2)
	end
end

StatusUtils.set_grabbed_by_chaos_spawn_status_network = function (arg_14_0, arg_14_1)
	-- function 14
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)
	ScriptUnit.extension(arg_14_0, "status_system"):set_grabbed_by_chaos_spawn_status(arg_14_1)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_14_0)
		local var_14_4 = NetworkLookup.grabbed_by_chaos_spawn[arg_14_1]

		network.network_transmit:send_rpc_clients("rpc_status_change_int", NetworkLookup.statuses.grabbed_by_chaos_spawn, var_14_4, unit_game_object_id)
	end
end

StatusUtils.set_in_vortex_network = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)

	if not ALIVE[arg_15_0] then
		return false
	end

	ScriptUnit.extension(arg_15_0, "status_system"):set_in_vortex(arg_15_1, arg_15_2)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_15_0)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_15_2)

		unit_game_object_id_2 = unit_game_object_id_2 or NetworkConstants.invalid_game_object_id

		network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.in_vortex, arg_15_1, unit_game_object_id, unit_game_object_id_2)
	end

	return true
end

StatusUtils.set_near_vortex_network = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)
	ScriptUnit.extension(arg_16_0, "status_system"):set_near_vortex(arg_16_1, arg_16_2)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_16_0)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_16_2)

		unit_game_object_id_2 = unit_game_object_id_2 or NetworkConstants.invalid_game_object_id

		network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.near_vortex, arg_16_1, unit_game_object_id, unit_game_object_id_2)
	end
end

StatusUtils.set_in_liquid_network = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)
	ScriptUnit.extension(arg_17_0, "status_system"):set_in_liquid(arg_17_1, arg_17_2)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_17_0)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_17_2)

		unit_game_object_id_2 = unit_game_object_id_2 or NetworkConstants.invalid_game_object_id

		network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.in_liquid, arg_17_1, unit_game_object_id, unit_game_object_id_2)
	end
end

StatusUtils.set_overpowered_network = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server)
	ScriptUnit.extension(arg_18_0, "status_system"):set_overpowered(arg_18_1, arg_18_2, arg_18_3)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_18_0)

		if not (not unit_game_object_id and unit_game_object_id == NetworkConstants.invalid_game_object_id) then
			local unit_game_object_id_2 = network:unit_game_object_id(arg_18_3)

			unit_game_object_id_2 = unit_game_object_id_2 or NetworkConstants.invalid_game_object_id

			local var_18_5

			if not arg_18_1 then
				var_18_5 = NetworkLookup.overpowered_templates[arg_18_2]

				if not var_18_5 then
					-- Nothing
				end
			end

			var_18_5 = 0

			::label_18_0::

			network.network_transmit:send_rpc_clients("rpc_status_change_int_and_unit", NetworkLookup.statuses.overpowered, var_18_5, unit_game_object_id, unit_game_object_id_2)
		end
	end
end

StatusUtils.set_overcharge_exploding = function (arg_19_0, arg_19_1)
	-- function 19
	ScriptUnit.extension(arg_19_0, "status_system"):set_overcharge_exploding(arg_19_1)

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_19_0)

		if not Managers.player.is_server then
			network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.overcharge_exploding, arg_19_1, unit_game_object_id, 0)
		else
			network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.overcharge_exploding, arg_19_1, unit_game_object_id, 0)
		end
	end
end

StatusUtils.use_soft_collision = function (arg_20_0)
	-- function 20
	local extension = ScriptUnit.extension(arg_20_0, "status_system")
	local is_using_transport = extension:is_using_transport()

	if not is_using_transport then
		is_using_transport = extension:get_inside_transport_unit()

		if not is_using_transport then
			is_using_transport = extension:is_disabled()

			if not is_using_transport then
				is_using_transport = extension:is_knocked_down()
				is_using_transport = is_using_transport or extension:is_pounced_down()
			end
		end
	end

	return not is_using_transport
end

StatusUtils.replenish_stamina_local_players = function (arg_21_0, arg_21_1)
	-- function 21
	local players_at_peer = Managers.player:players_at_peer(Network.peer_id())

	if not players_at_peer then
		for k, v in pairs(players_at_peer) do
			local player_unit = v.player_unit

			if not (not Unit.alive(player_unit) and player_unit == arg_21_0) then
				local extension = ScriptUnit.extension(player_unit, "status_system")

				extension:add_fatigue_points(arg_21_1)
				extension:set_has_bonus_fatigue_active()
			end
		end
	end
end

StatusUtils.set_pounced_down_network = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	if not Managers.state.network:game() then
		return
	end

	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_22_1)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_22_3)

		unit_game_object_id_2 = unit_game_object_id_2 or NetworkConstants.invalid_game_object_id

		local var_22_3 = NetworkLookup.statuses[arg_22_0]

		if not DEDICATED_SERVER then
			network.network_transmit:send_rpc_clients("rpc_status_change_bool", var_22_3, arg_22_2, unit_game_object_id, unit_game_object_id_2)
		elseif not Managers.player.is_server then
			ScriptUnit.extension(arg_22_1, "status_system"):set_pounced_down(arg_22_2, arg_22_3)
		else
			network.network_transmit:send_rpc_server("rpc_status_change_bool", var_22_3, arg_22_2, unit_game_object_id, unit_game_object_id_2)
		end
	end
end
