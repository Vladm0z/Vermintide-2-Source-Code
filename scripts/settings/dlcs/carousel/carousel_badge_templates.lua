-- chunkname: @scripts/settings/dlcs/carousel/carousel_badge_templates.lua

local BadgeTemplates = BadgeTemplates

BadgeTemplates = BadgeTemplates or {
	server = {},
	client = {}
}
BadgeTemplates = BadgeTemplates

local function fn(self)
	-- function 1
	if not self then
		return nil
	end

	local profile_index = self:profile_index()
	local career_index = self:career_index()
	local var_1_2 = SPProfiles[profile_index]
	local flag = not var_1_2 and var_1_2.careers[career_index]
	local breed

	if not flag then
		breed = flag.breed

		if not breed then
			-- Nothing
		end
	end

	breed = not var_1_2 and var_1_2.breed

	::label_1_0::

	return breed
end

local tbl = {
	server = {
		vs_kill_hero = {
			data = {},
			settings = {},
			events = {
				event_stat_incremented = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
					-- function 2
					if not (not arg_2_3 and arg_2_4 == "kills_per_breed") then
						return false
					end

					local var_2_0 = PlayerBreeds[arg_2_5]

					if not (not var_2_0 and var_2_0.is_hero) then
						return false
					end

					return true
				end
			},
			complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, ...)
				-- function 3
				local player_from_unique_id = Managers.player:player_from_unique_id(arg_3_3)

				if not player_from_unique_id then
					return false
				end

				local peer_id = player_from_unique_id.peer_id
				local kill_hero = NetworkLookup.badges.kill_hero

				return peer_id, kill_hero
			end
		},
		vs_knock_down_hero = {
			data = {},
			settings = {},
			events = {
				event_stat_incremented = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, ...)
					-- function 4
					if not (not arg_4_3 and arg_4_4 == "vs_badge_knocked_down_target_per_breed") then
						return false
					end

					local player_from_unique_id = Managers.player:player_from_unique_id(arg_4_3)
					local var_4_1 = fn(player_from_unique_id)

					if not arg_4_3 and not var_4_1 and not var_4_1.is_hero then
						return false
					end

					return true
				end
			},
			complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, ...)
				-- function 5
				local player_from_unique_id = Managers.player:player_from_unique_id(arg_5_3)

				if not player_from_unique_id then
					return false
				end

				local peer_id = player_from_unique_id.peer_id
				local knock_down_hero = NetworkLookup.badges.knock_down_hero

				return peer_id, knock_down_hero
			end
		}
	}
}

table.merge(BadgeTemplates.server, tbl.server)
