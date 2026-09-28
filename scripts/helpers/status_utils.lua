-- chunkname: @scripts/helpers/status_utils.lua

StatusUtils = {}

StatusUtils.set_wounded_network = function (wounded_unit, wounded, reason, t)
	-- function 1
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local status_extension = ScriptUnit.extension(wounded_unit, "status_system")

	status_extension:set_wounded(wounded, reason, t)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(wounded_unit)
		local reason_id = NetworkLookup.set_wounded_reasons[reason]

		network_manager.network_transmit:send_rpc_clients("rpc_set_wounded", go_id, wounded, reason_id)
	end
end

StatusUtils.set_knocked_down_network = function (knocked_down_unit, knocked_down)
	-- function 2
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server, "can only knock down on server")

	local status_extension = ScriptUnit.extension(knocked_down_unit, "status_system")

	status_extension:set_knocked_down(knocked_down)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(knocked_down_unit)

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.knocked_down, knocked_down, go_id, 0)
	end
end

StatusUtils.set_revived_network = function (revived_unit, revived, reviver_unit)
	-- function 3
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server, "Only the server is allowed to decide who is revived and who isn't since it owns damage and interactions.")

	if not revived_unit then
		return
	end

	local status_extension = ScriptUnit.has_extension(revived_unit, "status_system")

	if status_extension then
		status_extension:set_revived(revived, reviver_unit)

		if not LEVEL_EDITOR_TEST then
			local network_manager = Managers.state.network
			local go_id = network_manager:unit_game_object_id(revived_unit)
			local unit_game_object_id

			if reviver_unit then
				unit_game_object_id = network_manager:unit_game_object_id(reviver_unit)

				if not unit_game_object_id then
					-- Nothing
				end
			end

			unit_game_object_id = NetworkConstants.invalid_game_object_id

			local reviver_go_id = unit_game_object_id

			::label_3_0::

			network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.revived, revived, go_id, reviver_go_id)
		end
	end
end

StatusUtils.set_respawned_network = function (respawned_unit, respawned, helper_unit)
	-- function 4
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local status_extension = ScriptUnit.extension(respawned_unit, "status_system")

	if not respawned then
		status_extension:set_respawned(respawned)

		if not LEVEL_EDITOR_TEST then
			local network_manager = Managers.state.network
			local go_id = network_manager:unit_game_object_id(respawned_unit)
			local unit_game_object_id

			if helper_unit then
				unit_game_object_id = network_manager:unit_game_object_id(helper_unit)

				if not unit_game_object_id then
					-- Nothing
				end
			end

			unit_game_object_id = NetworkConstants.invalid_game_object_id

			local helper_go_id = unit_game_object_id

			::label_4_0::

			network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.respawned, respawned, go_id, helper_go_id)
		end
	elseif not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local unit_game_object_id_2 = network_manager:unit_game_object_id(respawned_unit)

		if not unit_game_object_id_2 then
			-- Nothing
		end

		unit_game_object_id_2 = 0

		local go_id = unit_game_object_id_2

		do
			local unit_game_object_id_3
		end

		::label_4_1::

		if helper_unit then
			unit_game_object_id_3 = network_manager:unit_game_object_id(helper_unit)

			if not unit_game_object_id_3 then
				-- Nothing
			end
		end

		unit_game_object_id_3 = 0

		local helper_go_id = unit_game_object_id_3

		::label_4_2::

		local owner = Managers.player:owner(respawned_unit)
		local network_id = owner:network_id()

		network_manager.network_transmit:send_rpc("rpc_status_change_bool", network_id, NetworkLookup.statuses.assisted_respawning, respawned, go_id, helper_go_id)
	end
end

StatusUtils.set_pulled_up_network = function (pulled_up_unit, pulled_up, helper_unit)
	-- function 5
	local status_extension = ScriptUnit.extension(pulled_up_unit, "status_system")

	status_extension:set_pulled_up(pulled_up, helper_unit)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(pulled_up_unit)
		local unit_game_object_id

		if helper_unit then
			unit_game_object_id = network_manager:unit_game_object_id(helper_unit)

			if not unit_game_object_id then
				-- Nothing
			end
		end

		unit_game_object_id = NetworkConstants.invalid_game_object_id

		local helper_go_id = unit_game_object_id

		::label_5_0::

		if Managers.player.is_server then
			network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.pulled_up, pulled_up, go_id, helper_go_id)
		else
			network_manager.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.pulled_up, pulled_up, go_id, helper_go_id)
		end
	end
end

StatusUtils.set_grabbed_by_pack_master_network = function (status_name, grabbed_unit, is_grabbed, grabber_unit)
	-- function 6
	if not Managers.state.network:game() then
		return
	end

	local status_extension = ScriptUnit.has_extension(grabbed_unit, "status_system")

	if not status_extension then
		return
	end

	status_extension:set_pack_master(status_name, is_grabbed, grabber_unit)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local grabbed_go_id = network_manager:unit_game_object_id(grabbed_unit)
		local unit_game_object_id = network_manager:unit_game_object_id(grabber_unit)

		if not unit_game_object_id then
			-- Nothing
		end

		unit_game_object_id = NetworkConstants.invalid_game_object_id

		local grabber_go_id = unit_game_object_id

		::label_6_0::

		local status_id = NetworkLookup.statuses[status_name]

		if Managers.player.is_server then
			network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", status_id, is_grabbed, grabbed_go_id, grabber_go_id)
		else
			network_manager.network_transmit:send_rpc_server("rpc_status_change_bool", status_id, is_grabbed, grabbed_go_id, grabber_go_id)
		end
	end
end

StatusUtils.set_grabbed_by_corruptor_network = function (status_name, grabbed_unit, is_grabbed, grabber_unit)
	-- function 7
	if not Managers.state.network:game() then
		return
	end

	local status_extension = ScriptUnit.extension(grabbed_unit, "status_system")

	status_extension:set_grabbed_by_corruptor(status_name, is_grabbed, grabber_unit)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local grabbed_go_id = network_manager:unit_game_object_id(grabbed_unit)
		local unit_game_object_id = network_manager:unit_game_object_id(grabber_unit)

		if not unit_game_object_id then
			-- Nothing
		end

		unit_game_object_id = NetworkConstants.invalid_game_object_id

		local grabber_go_id = unit_game_object_id

		::label_7_0::

		local status_id = NetworkLookup.statuses[status_name]

		if Managers.player.is_server then
			network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", status_id, is_grabbed, grabbed_go_id, grabber_go_id)
		else
			network_manager.network_transmit:send_rpc_server("rpc_status_change_bool", status_id, is_grabbed, grabbed_go_id, grabber_go_id)
		end
	end
end

StatusUtils.set_pushed_network = function (pushed_unit, pushed)
	-- function 8
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local t = Managers.time:time("game")
	local status_extension = ScriptUnit.extension(pushed_unit, "status_system")

	status_extension:set_pushed(pushed, t)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(pushed_unit)

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.pushed, pushed, go_id, 0)
	end
end

StatusUtils.set_charged_network = function (charged_unit, charged)
	-- function 9
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local t = Managers.time:time("game")
	local status_extension = ScriptUnit.extension(charged_unit, "status_system")

	status_extension:set_charged(charged, t)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(charged_unit)

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.charged, charged, go_id, 0)
	end
end

StatusUtils.set_catapulted_network = function (unit, catapulted, velocity)
	-- function 10
	local player_manager = Managers.player
	local player = player_manager:unit_owner(unit)

	if not player.remote then
		local status_extension = ScriptUnit.extension(unit, "status_system")

		status_extension:set_catapulted(catapulted, velocity)
	elseif player_manager.is_server or DEDICATED_SERVER then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(unit)
		local peer_id = player:network_id()

		if not go_id then
			return
		end

		network_manager.network_transmit:send_rpc("rpc_set_catapulted", peer_id, go_id, catapulted, not not velocity or not not Vector.zero())
	else
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(unit)

		if not go_id then
			return
		end

		network_manager.network_transmit:send_rpc_server("rpc_set_catapulted", go_id, catapulted, not not velocity or not not Vector.zero())
	end
end

StatusUtils.set_grabbed_by_tentacle_network = function (grabbed_unit, is_grabbed, tentacle_unit)
	-- function 11
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local status_extension = ScriptUnit.extension(grabbed_unit, "status_system")

	status_extension:set_grabbed_by_tentacle(is_grabbed, tentacle_unit)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(grabbed_unit)
		local grabber_go_id = network_manager:unit_game_object_id(tentacle_unit)

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.grabbed_by_tentacle, is_grabbed, go_id, grabber_go_id)
	end
end

StatusUtils.set_grabbed_by_tentacle_status_network = function (grabbed_unit, substatus)
	-- function 12
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local status_extension = ScriptUnit.extension(grabbed_unit, "status_system")

	status_extension:set_grabbed_by_tentacle_status(substatus)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(grabbed_unit)
		local substatus_id = NetworkLookup.grabbed_by_tentacle[substatus]

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_int", NetworkLookup.statuses.grabbed_by_tentacle, substatus_id, go_id)
	end
end

StatusUtils.set_grabbed_by_chaos_spawn_network = function (grabbed_unit, is_grabbed, chaos_spawn_unit)
	-- function 13
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local status_extension = ScriptUnit.extension(grabbed_unit, "status_system")

	status_extension:set_grabbed_by_chaos_spawn(is_grabbed, chaos_spawn_unit)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(grabbed_unit)
		local grabber_go_id = network_manager:unit_game_object_id(chaos_spawn_unit)

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.grabbed_by_chaos_spawn, is_grabbed, go_id, grabber_go_id)
	end
end

StatusUtils.set_grabbed_by_chaos_spawn_status_network = function (grabbed_unit, substatus)
	-- function 14
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local status_extension = ScriptUnit.extension(grabbed_unit, "status_system")

	status_extension:set_grabbed_by_chaos_spawn_status(substatus)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(grabbed_unit)
		local substatus_id = NetworkLookup.grabbed_by_chaos_spawn[substatus]

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_int", NetworkLookup.statuses.grabbed_by_chaos_spawn, substatus_id, go_id)
	end
end

StatusUtils.set_in_vortex_network = function (affected_unit, in_vortex, vortex_unit)
	-- function 15
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	if not ALIVE[affected_unit] then
		return false
	end

	local status_extension = ScriptUnit.extension(affected_unit, "status_system")

	status_extension:set_in_vortex(in_vortex, vortex_unit)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(affected_unit)
		local unit_game_object_id = network_manager:unit_game_object_id(vortex_unit)

		if not unit_game_object_id then
			-- Nothing
		end

		unit_game_object_id = NetworkConstants.invalid_game_object_id

		local vortex_go_id = unit_game_object_id

		::label_15_0::

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.in_vortex, in_vortex, go_id, vortex_go_id)
	end

	return true
end

StatusUtils.set_near_vortex_network = function (affected_unit, near_vortex, vortex_unit)
	-- function 16
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local status_extension = ScriptUnit.extension(affected_unit, "status_system")

	status_extension:set_near_vortex(near_vortex, vortex_unit)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(affected_unit)
		local unit_game_object_id = network_manager:unit_game_object_id(vortex_unit)

		if not unit_game_object_id then
			-- Nothing
		end

		unit_game_object_id = NetworkConstants.invalid_game_object_id

		local vortex_go_id = unit_game_object_id

		::label_16_0::

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.near_vortex, near_vortex, go_id, vortex_go_id)
	end
end

StatusUtils.set_in_liquid_network = function (affected_unit, in_liquid, in_liquid_unit)
	-- function 17
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local status_extension = ScriptUnit.extension(affected_unit, "status_system")

	status_extension:set_in_liquid(in_liquid, in_liquid_unit)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(affected_unit)
		local unit_game_object_id = network_manager:unit_game_object_id(in_liquid_unit)

		if not unit_game_object_id then
			-- Nothing
		end

		unit_game_object_id = NetworkConstants.invalid_game_object_id

		local liquid_go_id = unit_game_object_id

		::label_17_0::

		network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.in_liquid, in_liquid, go_id, liquid_go_id)
	end
end

StatusUtils.set_overpowered_network = function (affected_unit, overpowered, overpowered_template_name, attacking_unit)
	-- function 18
	local fassert = fassert
	local is_server = Managers.player.is_server

	is_server = not not is_server or not not LEVEL_EDITOR_TEST

	fassert(is_server)

	local status_extension = ScriptUnit.extension(affected_unit, "status_system")

	status_extension:set_overpowered(overpowered, overpowered_template_name, attacking_unit)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(affected_unit)

		if go_id and go_id ~= NetworkConstants.invalid_game_object_id then
			local unit_game_object_id = network_manager:unit_game_object_id(attacking_unit)

			if not unit_game_object_id then
				-- Nothing
			end

			unit_game_object_id = NetworkConstants.invalid_game_object_id

			local other_go_id = unit_game_object_id

			do
				local var_18_3
			end

			::label_18_0::

			if overpowered then
				var_18_3 = NetworkLookup.overpowered_templates[overpowered_template_name]

				if not var_18_3 then
					-- Nothing
				end
			end

			var_18_3 = 0

			local status_int = var_18_3

			::label_18_1::

			network_manager.network_transmit:send_rpc_clients("rpc_status_change_int_and_unit", NetworkLookup.statuses.overpowered, status_int, go_id, other_go_id)
		end
	end
end

StatusUtils.set_overcharge_exploding = function (unit, exploding)
	-- function 19
	local status_extension = ScriptUnit.extension(unit, "status_system")

	status_extension:set_overcharge_exploding(exploding)

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local go_id = network_manager:unit_game_object_id(unit)

		if Managers.player.is_server then
			network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.overcharge_exploding, exploding, go_id, 0)
		else
			network_manager.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.overcharge_exploding, exploding, go_id, 0)
		end
	end
end

StatusUtils.use_soft_collision = function (unit)
	-- function 20
	local status_extension = ScriptUnit.extension(unit, "status_system")
	local is_using_transport = status_extension:is_using_transport()

	if not is_using_transport then
		-- Nothing
	end

	is_using_transport = status_extension:get_inside_transport_unit()

	if not is_using_transport then
		-- Nothing
	end

	is_using_transport = status_extension:is_disabled()

	if not is_using_transport then
		-- Nothing
	end

	is_using_transport = status_extension:is_knocked_down()

	if not is_using_transport then
		-- Nothing
	end

	is_using_transport = status_extension:is_pounced_down()

	local is_disabled = is_using_transport

	::label_20_0::

	return not is_disabled
end

StatusUtils.replenish_stamina_local_players = function (except_unit, fatigue_type)
	-- function 21
	local local_players = Managers.player:players_at_peer(Network.peer_id())

	if local_players then
		for _, player in pairs(local_players) do
			local player_unit = player.player_unit

			if Unit.alive(player_unit) and player_unit ~= except_unit then
				local status_ext = ScriptUnit.extension(player_unit, "status_system")

				status_ext:add_fatigue_points(fatigue_type)
				status_ext:set_has_bonus_fatigue_active()
			end
		end
	end
end

StatusUtils.set_pounced_down_network = function (status_name, pounced_unit, is_pounced, pouncer_unit)
	-- function 22
	if not Managers.state.network:game() then
		return
	end

	if not LEVEL_EDITOR_TEST then
		local network_manager = Managers.state.network
		local pounced_go_id = network_manager:unit_game_object_id(pounced_unit)
		local unit_game_object_id = network_manager:unit_game_object_id(pouncer_unit)

		if not unit_game_object_id then
			-- Nothing
		end

		unit_game_object_id = NetworkConstants.invalid_game_object_id

		local pouncer_go_id = unit_game_object_id

		::label_22_0::

		local status_id = NetworkLookup.statuses[status_name]

		if DEDICATED_SERVER then
			network_manager.network_transmit:send_rpc_clients("rpc_status_change_bool", status_id, is_pounced, pounced_go_id, pouncer_go_id)
		elseif Managers.player.is_server then
			local target_status_extension = ScriptUnit.extension(pounced_unit, "status_system")

			target_status_extension:set_pounced_down(is_pounced, pouncer_unit)
		else
			network_manager.network_transmit:send_rpc_server("rpc_status_change_bool", status_id, is_pounced, pounced_go_id, pouncer_go_id)
		end
	end
end
