-- chunkname: @scripts/helpers/steam_helper.lua

local SteamHelper = SteamHelper

SteamHelper = SteamHelper or {}
SteamHelper = SteamHelper

local tbl = {
	[0] = "offline",
	"online",
	"busy",
	"away",
	"snooze",
	"trading",
	"looking_to_play"
}

SteamHelper.debug_friends = function ()
	-- function 1
	local num = 5
	local tbl = {}

	for i = 1, num do
		tbl["id_" .. i] = {
			playing_this_game = false,
			name = "debug_friend_" .. i,
			playing_game = i % 2 == 1,
			status = math.random(1, 6)
		}
	end

	return tbl
end

SteamHelper.friends = function ()
	-- function 2
	local num_friends = Friends.num_friends()
	local tbl_2 = {}
	local app_id = Steam.app_id()

	for i = 1, num_friends do
		local id = Friends.id(i)
		local playing_game = Friends.playing_game(id)

		if not (not playing_game and playing_game.lobby or playing_game.ip) then
			local presence = Presence.presence(id, "connect")
			local count = #"+connect "

			if not (not presence and not (count < #presence)) then
				local sub = string.sub(presence, count + 1, #presence)
				local split_ip_port, var_2_9 = NetworkUtils.split_ip_port(sub)

				if not split_ip_port then
					playing_game.ip = split_ip_port
					playing_game.server_port = var_2_9
				end
			end
		end

		local flag = not playing_game and playing_game.app_id == app_id

		tbl_2[id] = {
			name = Friends.name(id),
			playing_game = playing_game,
			playing_this_game = flag,
			status = tbl[Friends.status(id)]
		}
	end

	return tbl_2
end

SteamHelper.is_dev = function ()
	-- function 3
	if not rawget(_G, "Clans") then
		return SteamHelper.is_in_clan("170000000a021fa")
	else
		return false
	end
end

SteamHelper.is_in_clan = function (arg_4_0)
	-- function 4
	local clan_count = Clans.clan_count()

	for i = 0, clan_count - 1 do
		if Clans.clan_by_index(i) == arg_4_0 then
			return true
		end
	end

	return false
end

SteamHelper.clans_short = function ()
	-- function 5
	if not rawget(_G, "Clans") then
		local clan_count = Clans.clan_count()
		local tbl = {}

		for i = 0, clan_count - 1 do
			local clan_by_index = Clans.clan_by_index(i)

			tbl[clan_by_index] = Clans.clan_tag(clan_by_index)
		end

		return tbl
	else
		return {}
	end
end

SteamHelper.clans = function ()
	-- function 6
	local clan_count = Clans.clan_count()
	local tbl = {}

	for i = 0, clan_count - 1 do
		local clan_by_index = Clans.clan_by_index(i)

		tbl[clan_by_index] = Clans.clan_name(clan_by_index)
	end

	return tbl
end
