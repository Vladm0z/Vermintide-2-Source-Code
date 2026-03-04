-- chunkname: @scripts/helpers/steam_helper.lua

SteamHelper = SteamHelper or {}

local var_0_0 = {
	[0] = "offline",
	"online",
	"busy",
	"away",
	"snooze",
	"trading",
	"looking_to_play"
}

SteamHelper.debug_friends = function ()
	local var_1_0 = 5
	local var_1_1 = {}

	for iter_1_0 = 1, var_1_0 do
		var_1_1["id_" .. iter_1_0] = {
			playing_this_game = false,
			name = "debug_friend_" .. iter_1_0,
			playing_game = iter_1_0 % 2 == 1,
			status = math.random(1, 6)
		}
	end

	return var_1_1
end

SteamHelper.friends = function ()
	local var_2_0 = Friends.num_friends()
	local var_2_1 = {}
	local var_2_2 = Steam.app_id()

	for iter_2_0 = 1, var_2_0 do
		local var_2_3 = Friends.id(iter_2_0)
		local var_2_4 = Friends.playing_game(var_2_3)

		if var_2_4 and not var_2_4.lobby and not var_2_4.ip then
			local var_2_5 = Presence.presence(var_2_3, "connect")
			local var_2_6 = #"+connect "

			if var_2_5 and var_2_6 < #var_2_5 then
				local var_2_7 = string.sub(var_2_5, var_2_6 + 1, #var_2_5)
				local var_2_8, var_2_9 = NetworkUtils.split_ip_port(var_2_7)

				if var_2_8 then
					var_2_4.ip = var_2_8
					var_2_4.server_port = var_2_9
				end
			end
		end

		local var_2_10 = var_2_4 and var_2_4.app_id == var_2_2

		var_2_1[var_2_3] = {
			name = Friends.name(var_2_3),
			playing_game = var_2_4,
			playing_this_game = var_2_10,
			status = var_0_0[Friends.status(var_2_3)]
		}
	end

	return var_2_1
end

SteamHelper.is_dev = function ()
	if rawget(_G, "Clans") then
		return SteamHelper.is_in_clan("170000000a021fa")
	else
		return false
	end
end

SteamHelper.is_in_clan = function (arg_4_0)
	local var_4_0 = Clans.clan_count()

	for iter_4_0 = 0, var_4_0 - 1 do
		if Clans.clan_by_index(iter_4_0) == arg_4_0 then
			return true
		end
	end

	return false
end

SteamHelper.clans_short = function ()
	if rawget(_G, "Clans") then
		local var_5_0 = Clans.clan_count()
		local var_5_1 = {}

		for iter_5_0 = 0, var_5_0 - 1 do
			local var_5_2 = Clans.clan_by_index(iter_5_0)

			var_5_1[var_5_2] = Clans.clan_tag(var_5_2)
		end

		return var_5_1
	else
		return {}
	end
end

SteamHelper.clans = function ()
	local var_6_0 = Clans.clan_count()
	local var_6_1 = {}

	for iter_6_0 = 0, var_6_0 - 1 do
		local var_6_2 = Clans.clan_by_index(iter_6_0)

		var_6_1[var_6_2] = Clans.clan_name(var_6_2)
	end

	return var_6_1
end
