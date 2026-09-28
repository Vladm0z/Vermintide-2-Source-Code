-- chunkname: @scripts/helpers/network_utils.lua

function mm_printf_force(format_text, ...)
	-- function 1
	format_text = "[Matchmaking] " .. format_text

	printf(format_text, ...)
end

function mm_printf(format_text, ...)
	-- function 2
	if script_data.matchmaking_debug then
		format_text = "[Matchmaking] " .. format_text

		printf(format_text, ...)
	end
end

script_data.matchmaking_debug = true
NetworkUtils = {}

NetworkUtils.network_safe_position = function (pos)
	-- function 3
	local pos_min = NetworkConstants.position.min
	local pos_max = NetworkConstants.position.max
	local pos_x = pos.x
	local pos_y = pos.y
	local pos_z = pos.z
	local in_range_x = pos_min <= pos_x and pos_x <= pos_max
	local in_range_y = pos_min <= pos_y and pos_y <= pos_max
	local in_range_z = pos_min <= pos_z and pos_z <= pos_max
	local in_range = not not in_range_x and not not in_range_y and not not in_range_z

	return in_range
end

NetworkUtils.get_network_safe_damage_hotjoin_sync = function (damage)
	-- function 4
	local damage_min = NetworkConstants.damage_hotjoin_sync.min
	local damage_max = NetworkConstants.damage_hotjoin_sync.max

	damage = math.clamp(damage, damage_min, damage_max)

	return damage
end

NetworkUtils.network_clamp_position = function (pos)
	-- function 5
	local pos_constant = NetworkConstants.position
	local pos_min = pos_constant.min
	local pos_max = pos_constant.max

	return Vector3.clamp(pos, pos_min, pos_max)
end

NetworkUtils.announce_chat_peer_joined = function (peer_id, lobby)
	-- function 6
	local sender = PlayerUtils.player_name(peer_id, lobby)
	local message = string.format(Localize("system_chat_player_joined_the_game"), sender)
	local pop_chat = true

	Managers.chat:add_local_system_message(1, message, pop_chat)
end

local peer_left_ignored_states = table.set({
	"MatchmakingStatePartyJoins",
	"MatchmakingStateJoinGame"
})

NetworkUtils.announce_chat_peer_left = function (peer_id, lobby)
	-- function 7
	local matchmaking_manager = Managers.matchmaking
	local matchmaking_state = not not matchmaking_manager and not not matchmaking_manager:state()
	local matchmaking_state_name = not not matchmaking_state and not not matchmaking_state.NAME

	if peer_left_ignored_states[matchmaking_state_name] then
		return
	end

	local sender = PlayerUtils.player_name(peer_id, lobby)
	local message = string.format(Localize("system_chat_player_left_the_game"), sender)
	local pop_chat = true

	Managers.chat:add_local_system_message(1, message, pop_chat)
end

local cached_ip_port = {}

NetworkUtils.split_ip_port = function (ip_port)
	-- function 8
	local parts, n = string.split(ip_port, ":", cached_ip_port)

	if parts and n >= 2 then
		return parts[1], parts[2]
	end

	return nil, nil
end

NetworkUtils.net_pack_flexmatch_ticket = function (ticket)
	-- function 9
	local STRING_MAX = NetworkConstants.max_string_length
	local id_size = #ticket
	local parts = math.ceil(id_size / STRING_MAX)
	local max_size = Network.type_info("flexmatch_ticket").max_size

	fassert(parts <= max_size, "Flexmatch ticket is too big (%s>%s)", id_size, max_size * STRING_MAX)

	local networkified_ticket = {}

	for i = 1, parts do
		networkified_ticket[i] = string.sub(ticket, (i - 1) * STRING_MAX + 1, math.min(i * STRING_MAX, id_size))
	end

	return networkified_ticket
end

NetworkUtils.unnet_pack_flexmatch_ticket = function (packed_ticket)
	-- function 10
	return table.concat(packed_ticket)
end
