-- chunkname: @scripts/helpers/network_utils.lua

function mm_printf_force(arg_1_0, ...)
	-- function 1
	arg_1_0 = "[Matchmaking] " .. arg_1_0

	printf(arg_1_0, ...)
end

function mm_printf(arg_2_0, ...)
	-- function 2
	if not script_data.matchmaking_debug then
		arg_2_0 = "[Matchmaking] " .. arg_2_0

		printf(arg_2_0, ...)
	end
end

script_data.matchmaking_debug = true
NetworkUtils = {}

NetworkUtils.network_safe_position = function (self)
	-- function 3
	local min = NetworkConstants.position.min
	local max = NetworkConstants.position.max
	local x = self.x
	local y = self.y
	local z = self.z
	local flag = not (min <= x) or x <= max
	local flag_2 = not (min <= y) or y <= max
	local flag_3 = not (min <= z) or z <= max

	return not flag and not flag_2 and flag_3
end

NetworkUtils.get_network_safe_damage_hotjoin_sync = function (arg_4_0)
	-- function 4
	local min = NetworkConstants.damage_hotjoin_sync.min
	local max = NetworkConstants.damage_hotjoin_sync.max

	arg_4_0 = math.clamp(arg_4_0, min, max)

	return arg_4_0
end

NetworkUtils.network_clamp_position = function (arg_5_0)
	-- function 5
	local position = NetworkConstants.position
	local min = position.min
	local max = position.max

	return Vector3.clamp(arg_5_0, min, max)
end

NetworkUtils.announce_chat_peer_joined = function (arg_6_0, arg_6_1)
	-- function 6
	local player_name = PlayerUtils.player_name(arg_6_0, arg_6_1)
	local format = string.format(Localize("system_chat_player_joined_the_game"), player_name)
	local flag = true

	Managers.chat:add_local_system_message(1, format, flag)
end

local set = table.set({
	"MatchmakingStatePartyJoins",
	"MatchmakingStateJoinGame"
})

NetworkUtils.announce_chat_peer_left = function (arg_7_0, arg_7_1)
	-- function 7
	local matchmaking = Managers.matchmaking
	local flag = not matchmaking and matchmaking:state()
	local flag_2 = not flag and flag.NAME

	if not set[flag_2] then
		return
	end

	local player_name = PlayerUtils.player_name(arg_7_0, arg_7_1)
	local format = string.format(Localize("system_chat_player_left_the_game"), player_name)
	local flag_3 = true

	Managers.chat:add_local_system_message(1, format, flag_3)
end

local tbl = {}

NetworkUtils.split_ip_port = function (arg_8_0)
	-- function 8
	local split, var_8_1 = string.split(arg_8_0, ":", tbl)

	if not (not split and not (var_8_1 >= 2)) then
		return split[1], split[2]
	end

	return nil, nil
end

NetworkUtils.net_pack_flexmatch_ticket = function (arg_9_0)
	-- function 9
	local max_string_length = NetworkConstants.max_string_length
	local count = #arg_9_0
	local ceil = math.ceil(count / max_string_length)
	local max_size = Network.type_info("flexmatch_ticket").max_size

	fassert(ceil <= max_size, "Flexmatch ticket is too big (%s>%s)", count, max_size * max_string_length)

	local tbl = {}

	for i = 1, ceil do
		tbl[i] = string.sub(arg_9_0, (i - 1) * max_string_length + 1, math.min(i * max_string_length, count))
	end

	return tbl
end

NetworkUtils.unnet_pack_flexmatch_ticket = function (arg_10_0)
	-- function 10
	return table.concat(arg_10_0)
end
