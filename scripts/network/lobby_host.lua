-- chunkname: @scripts/network/lobby_host.lua

require("scripts/network/lobby_aux")

local var_0_0 = true

local function var_0_1(arg_1_0, ...)
	if var_0_0 then
		printf(arg_1_0, ...)
	end
end

LobbyHost = class(LobbyHost)

function LobbyHost.init(arg_2_0, arg_2_1, arg_2_2)
	print("[LobbyHost] Creating")

	local var_2_0 = arg_2_1.config_file_name
	local var_2_1 = arg_2_1.project_hash

	arg_2_0.network_hash = LobbyAux.create_network_hash(var_2_0, var_2_1)

	if IS_WINDOWS or IS_LINUX then
		fassert(arg_2_1.max_members, "Must provide max members to LobbyHost")
	end

	arg_2_0.max_members = (IS_WINDOWS or IS_LINUX) and arg_2_1.max_members
	arg_2_0.lobby = arg_2_2 or LobbyInternal.create_lobby(arg_2_1)
	arg_2_0.peer_id = Network.peer_id()
	arg_2_0._network_initialized = false
	arg_2_0.platform = PLATFORM
	arg_2_0.is_host = true
end

function LobbyHost.kick_all_except(arg_3_0, arg_3_1)
	if arg_3_0.lobby ~= nil and arg_3_0.lobby.kick then
		arg_3_1 = arg_3_1 or {}

		local var_3_0 = arg_3_0.peer_id

		for iter_3_0, iter_3_1 in ipairs(arg_3_0.lobby:members()) do
			if iter_3_1 ~= var_3_0 and not arg_3_1[iter_3_1] then
				arg_3_0.lobby:kick(iter_3_1)
			end
		end
	end
end

function LobbyHost.destroy(arg_4_0)
	print("[LobbyHost] Destroying")
	arg_4_0:kick_all_except()

	arg_4_0.lobby_members = nil

	arg_4_0:_free_lobby()
	GarbageLeakDetector.register_object(arg_4_0, "Lobby Host")
end

function LobbyHost.update(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.lobby
	local var_5_1 = var_5_0:state()
	local var_5_2 = arg_5_0.state or 0

	if var_5_1 ~= var_5_2 then
		printf("[LobbyHost] Changed state from %s to %s", var_5_2, var_5_1)

		arg_5_0.state = var_5_1

		if var_5_1 == LobbyState.JOINED then
			if IS_PS4 then
				local var_5_3 = arg_5_0.lobby_data_table or {}

				var_5_3.network_hash = arg_5_0.network_hash

				var_5_0:set_data_table(var_5_3)
			else
				local var_5_4 = arg_5_0.lobby_data_table

				var_5_4.network_hash = arg_5_0.network_hash

				if var_5_4 then
					for iter_5_0, iter_5_1 in pairs(var_5_4) do
						var_5_0:set_data(iter_5_0, iter_5_1)
					end
				end
			end

			arg_5_0.lobby_members = arg_5_0.lobby_members or LobbyMembers:new(var_5_0)

			Managers.party:set_leader(var_5_0:lobby_host())
			Managers.account:update_presence()
		elseif var_5_2 == LobbyState.JOINED then
			Managers.party:set_leader(nil)

			if arg_5_0.lobby_members then
				arg_5_0.lobby_members:clear()
			end
		end
	end

	if arg_5_0.lobby_members then
		arg_5_0.lobby_members:update()
	end
end

function LobbyHost.ping_by_peer(arg_6_0, arg_6_1)
	return LobbyInternal.ping(arg_6_1)
end

function LobbyHost._update_debug(arg_7_0)
	local var_7_0 = arg_7_0.peer_id
	local var_7_1 = arg_7_0.lobby:members()
	local var_7_2 = #var_7_1

	if var_7_2 > 0 then
		Debug.text("Reliable Send Buffer Left (peer : bytes):")

		for iter_7_0 = 1, var_7_2 do
			local var_7_3 = var_7_1[iter_7_0]

			if var_7_3 ~= var_7_0 then
				arg_7_0._min_remaining_buffer = arg_7_0._min_remaining_buffer or {}

				local var_7_4 = Network.reliable_send_buffer_left(var_7_3)
				local var_7_5 = arg_7_0._min_remaining_buffer[var_7_3]

				if var_7_5 and var_7_4 < var_7_5 or var_7_5 == nil and var_7_4 > 0 then
					var_7_5 = var_7_4
					arg_7_0._min_remaining_buffer[var_7_3] = var_7_5
				end

				Debug.text("    %s : %d %s", var_7_3, var_7_4, var_7_5 and string.format("(min: %d)", var_7_5) or "")
			end
		end
	end
end

function LobbyHost.set_lobby_data(arg_8_0, arg_8_1)
	fassert(arg_8_1.Host == nil, "Tell Staffan about this!!")
	var_0_1("Set lobby begin:")

	arg_8_0.lobby_data_table = arg_8_1

	if arg_8_0.state == LobbyState.JOINED then
		local var_8_0 = arg_8_0.lobby

		if IS_PS4 then
			var_8_0:set_data_table(arg_8_1)
		else
			for iter_8_0, iter_8_1 in pairs(arg_8_1) do
				var_0_1("\tLobby data %s = %s", iter_8_0, tostring(iter_8_1))
				var_8_0:set_data(iter_8_0, iter_8_1)
			end
		end
	end

	var_0_1("Set lobby end.")
end

function LobbyHost.set_network_initialized(arg_9_0, arg_9_1)
	arg_9_0._network_initialized = arg_9_1
end

function LobbyHost.network_initialized(arg_10_0)
	return arg_10_0._network_initialized
end

function LobbyHost.get_stored_lobby_data(arg_11_0)
	return arg_11_0.lobby_data_table
end

function LobbyHost.attempting_reconnect(arg_12_0)
	return false
end

function LobbyHost.members(arg_13_0)
	return arg_13_0.lobby_members
end

function LobbyHost.lobby_data(arg_14_0, arg_14_1)
	return arg_14_0.lobby:data(arg_14_1)
end

function LobbyHost.invite_target(arg_15_0)
	return arg_15_0.lobby
end

function LobbyHost.is_dedicated_server(arg_16_0)
	return false
end

function LobbyHost.lobby_host(arg_17_0)
	return arg_17_0.lobby:lobby_host()
end

function LobbyHost.user_name(arg_18_0, arg_18_1)
	if HAS_STEAM then
		return string.gsub(Steam.user_name(), "%c", "")
	elseif IS_PS4 then
		return string.gsub(arg_18_0.lobby:user_name(arg_18_1), "%c", "")
	else
		return arg_18_1
	end
end

function LobbyHost.id(arg_19_0)
	return LobbyInternal.lobby_id and LobbyInternal.lobby_id(arg_19_0.lobby) or "no_id"
end

function LobbyHost.is_joined(arg_20_0)
	return arg_20_0.state == LobbyState.JOINED
end

function LobbyHost.get_network_hash(arg_21_0)
	return arg_21_0.network_hash
end

function LobbyHost.get_max_members(arg_22_0)
	return arg_22_0.max_members
end

function LobbyHost.set_max_members(arg_23_0, arg_23_1)
	arg_23_0.max_members = arg_23_1

	LobbyInternal.set_max_members(arg_23_0.lobby, arg_23_1)
end

function LobbyHost.set_lobby(arg_24_0, arg_24_1)
	print("leaving old lobby")
	arg_24_0:_free_lobby()

	arg_24_0.lobby = arg_24_1

	local var_24_0 = arg_24_0.lobby_data_table or {}

	arg_24_0:set_lobby_data(var_24_0)

	arg_24_0.lobby_members = LobbyMembers:new(arg_24_1)
end

function LobbyHost.steal_lobby(arg_25_0)
	local var_25_0 = arg_25_0.lobby

	arg_25_0.lobby = nil

	return var_25_0
end

function LobbyHost.failed(arg_26_0)
	return arg_26_0.state == LobbyState.FAILED
end

function LobbyHost._free_lobby(arg_27_0)
	if arg_27_0.lobby ~= nil then
		LobbyInternal.leave_lobby(arg_27_0.lobby)

		arg_27_0.lobby = nil
	end
end

function LobbyHost.lost_connection_to_lobby(arg_28_0)
	return LobbyInternal.is_orphaned(arg_28_0.lobby)
end

function LobbyHost.close_channel(arg_29_0, arg_29_1)
	LobbyInternal.close_channel(arg_29_0.lobby, arg_29_1)
end
