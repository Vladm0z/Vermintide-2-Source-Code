-- chunkname: @scripts/settings/dlcs/carousel/carousel_badge_templates.lua

BadgeTemplates = BadgeTemplates or {
	server = {},
	client = {}
}

local function var_0_0(arg_1_0)
	if not arg_1_0 then
		return nil
	end

	local var_1_0 = arg_1_0:profile_index()
	local var_1_1 = arg_1_0:career_index()
	local var_1_2 = SPProfiles[var_1_0]
	local var_1_3 = var_1_2 and var_1_2.careers[var_1_1]

	return var_1_3 and var_1_3.breed or var_1_2 and var_1_2.breed
end

local var_0_1 = {
	server = {
		vs_kill_hero = {
			data = {},
			settings = {},
			events = {
				event_stat_incremented = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
					if not arg_2_3 or arg_2_4 ~= "kills_per_breed" then
						return false
					end

					local var_2_0 = PlayerBreeds[arg_2_5]

					if not var_2_0 or not var_2_0.is_hero then
						return false
					end

					return true
				end
			},
			complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, ...)
				local var_3_0 = Managers.player:player_from_unique_id(arg_3_3)

				if not var_3_0 then
					return false
				end

				local var_3_1 = var_3_0.peer_id
				local var_3_2 = NetworkLookup.badges.kill_hero

				return var_3_1, var_3_2
			end
		},
		vs_knock_down_hero = {
			data = {},
			settings = {},
			events = {
				event_stat_incremented = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, ...)
					if not arg_4_3 or arg_4_4 ~= "vs_badge_knocked_down_target_per_breed" then
						return false
					end

					local var_4_0 = Managers.player:player_from_unique_id(arg_4_3)
					local var_4_1 = var_0_0(var_4_0)

					if not arg_4_3 or not var_4_1 or var_4_1.is_hero then
						return false
					end

					return true
				end
			},
			complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, ...)
				local var_5_0 = Managers.player:player_from_unique_id(arg_5_3)

				if not var_5_0 then
					return false
				end

				local var_5_1 = var_5_0.peer_id
				local var_5_2 = NetworkLookup.badges.knock_down_hero

				return var_5_1, var_5_2
			end
		}
	}
}

table.merge(BadgeTemplates.server, var_0_1.server)
