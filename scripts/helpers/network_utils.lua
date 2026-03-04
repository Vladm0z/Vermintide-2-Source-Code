-- chunkname: @scripts/helpers/network_utils.lua

function mm_printf_force(arg_1_0, ...)
	arg_1_0 = "[Matchmaking] " .. arg_1_0

	printf(arg_1_0, ...)
end

function mm_printf(arg_2_0, ...)
	if script_data.matchmaking_debug then
		arg_2_0 = "[Matchmaking] " .. arg_2_0

		printf(arg_2_0, ...)
	end
end

script_data.matchmaking_debug = true
NetworkUtils = {}

NetworkUtils.network_safe_position = function (arg_3_0)
	local var_3_0 = NetworkConstants.position.min
	local var_3_1 = NetworkConstants.position.max
	local var_3_2 = arg_3_0.x
	local var_3_3 = arg_3_0.y
	local var_3_4 = arg_3_0.z
	local var_3_5 = var_3_0 <= var_3_2 and var_3_2 <= var_3_1
	local var_3_6 = var_3_0 <= var_3_3 and var_3_3 <= var_3_1
	local var_3_7 = var_3_0 <= var_3_4 and var_3_4 <= var_3_1

	return var_3_5 and var_3_6 and var_3_7
end

NetworkUtils.get_network_safe_damage_hotjoin_sync = function (arg_4_0)
	local var_4_0 = NetworkConstants.damage_hotjoin_sync.min
	local var_4_1 = NetworkConstants.damage_hotjoin_sync.max

	arg_4_0 = math.clamp(arg_4_0, var_4_0, var_4_1)

	return arg_4_0
end

NetworkUtils.network_clamp_position = function (arg_5_0)
	local var_5_0 = NetworkConstants.position
	local var_5_1 = var_5_0.min
	local var_5_2 = var_5_0.max

	return Vector3.clamp(arg_5_0, var_5_1, var_5_2)
end

NetworkUtils.announce_chat_peer_joined = function (arg_6_0, arg_6_1)
	local var_6_0 = PlayerUtils.player_name(arg_6_0, arg_6_1)
	local var_6_1 = string.format(Localize("system_chat_player_joined_the_game"), var_6_0)
	local var_6_2 = true

	Managers.chat:add_local_system_message(1, var_6_1, var_6_2)
end

local var_0_0 = table.set({
	"MatchmakingStatePartyJoins",
	"MatchmakingStateJoinGame"
})

NetworkUtils.announce_chat_peer_left = function (arg_7_0, arg_7_1)
	local var_7_0 = Managers.matchmaking
	local var_7_1 = var_7_0 and var_7_0:state()
	local var_7_2 = var_7_1 and var_7_1.NAME

	if var_0_0[var_7_2] then
		return
	end

	local var_7_3 = PlayerUtils.player_name(arg_7_0, arg_7_1)
	local var_7_4 = string.format(Localize("system_chat_player_left_the_game"), var_7_3)
	local var_7_5 = true

	Managers.chat:add_local_system_message(1, var_7_4, var_7_5)
end

local var_0_1 = {}

NetworkUtils.split_ip_port = function (arg_8_0)
	local var_8_0, var_8_1 = string.split(arg_8_0, ":", var_0_1)

	if var_8_0 and var_8_1 >= 2 then
		return var_8_0[1], var_8_0[2]
	end

	return nil, nil
end

NetworkUtils.net_pack_flexmatch_ticket = function (arg_9_0)
	local var_9_0 = 500
	local var_9_1 = #arg_9_0
	local var_9_2 = math.ceil(var_9_1 / var_9_0)
	local var_9_3 = Network.type_info("flexmatch_ticket").max_size

	fassert(var_9_2 <= var_9_3, "Flexmatch ticket is too big (%s>%s)", var_9_1, var_9_3 * var_9_0)

	local var_9_4 = {}

	for iter_9_0 = 1, var_9_2 do
		var_9_4[iter_9_0] = string.sub(arg_9_0, (iter_9_0 - 1) * var_9_0 + 1, math.min(iter_9_0 * var_9_0, var_9_1))
	end

	return var_9_4
end

NetworkUtils.unnet_pack_flexmatch_ticket = function (arg_10_0)
	return table.concat(arg_10_0)
end
