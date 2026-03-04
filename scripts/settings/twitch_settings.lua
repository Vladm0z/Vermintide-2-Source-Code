-- chunkname: @scripts/settings/twitch_settings.lua

TwitchSettings = TwitchSettings or {
	initial_downtime = 60,
	cutoff_for_guaranteed_negative_vote = -300,
	starting_funds = 0,
	max_diff = 200,
	max_a_b_vote_cost_diff = 100,
	default_draw_vote = "twitch_vote_draw",
	cutoff_for_guaranteed_positive_vote = 300,
	standard_vote = {
		default_vote_a_str = "#a",
		default_vote_b_str = "#b"
	},
	multiple_choice = {
		default_vote_b_str = "#b",
		default_vote_c_str = "#c",
		default_vote_d_str = "#d",
		default_vote_a_str = "#a",
		default_vote_e_str = "#e"
	},
	supported_game_modes = {
		ps4 = {
			weave_quick_play = false,
			deed = false,
			deus_twitch = true,
			adventure_mode = false,
			event = false,
			deus_custom = false,
			deus_quickplay = false,
			custom = false,
			weave = false,
			versus_custom = false,
			adventure = true,
			versus_quickplay = false,
			twitch = true,
			versus = false
		},
		xb1 = {
			weave_quick_play = false,
			deed = false,
			deus_twitch = true,
			adventure_mode = false,
			event = false,
			deus_custom = false,
			deus_quickplay = false,
			custom = false,
			weave = false,
			versus_custom = false,
			adventure = true,
			versus_quickplay = false,
			twitch = true,
			versus = false
		},
		win32 = {
			weave_quick_play = true,
			deed = true,
			deus_twitch = true,
			adventure_mode = true,
			event = true,
			deus_custom = true,
			deus_quickplay = true,
			custom = true,
			weave = true,
			versus_custom = false,
			adventure = true,
			versus_quickplay = false,
			twitch = true,
			versus = true,
			deus_weekly = true
		}
	},
	positive_vote_options = table.enum("enable_positive_votes", "disable_giving_items", "disable_positive_votes")
}
TwitchVoteTemplates = TwitchVoteTemplates or {}

require("scripts/settings/twitch_vote_templates_buffs")
require("scripts/settings/twitch_vote_templates_items")
require("scripts/settings/twitch_vote_templates_spawning")
require("scripts/settings/twitch_vote_templates_mutators")

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_0 = iter_0_1.twitch_settings
	local var_0_1 = var_0_0 and var_0_0.vote_templates_file

	if var_0_1 then
		require(var_0_1)
	end
end

local var_0_2 = {}
local var_0_3 = math.huge

for iter_0_2, iter_0_3 in pairs(TwitchVoteTemplates) do
	var_0_2[iter_0_2] = iter_0_2

	for iter_0_4, iter_0_5 in pairs(TwitchVoteTemplates) do
		if not var_0_2[iter_0_4] then
			local var_0_4 = math.abs(iter_0_5.cost + iter_0_3.cost)

			if var_0_4 < var_0_3 then
				var_0_3 = var_0_4
			end
		end
	end
end

TwitchVoteTemplatesLookup = {}
TwitchMultipleChoiceVoteTemplatesLookup = {}
TwitchStandardVoteTemplatesLookup = {}
TwitchPositiveVoteTemplatesLookup = {}
TwitchNegativeVoteTemplatesLookup = {}
TwitchBossEquivalentSpawnTemplatesLookup = {}
TwitchBossesSpawnBreedNamesLookup = {}
TwitchSpecialsSpawnBreedNamesLookup = {}

for iter_0_6, iter_0_7 in pairs(TwitchVoteTemplates) do
	iter_0_7.name = iter_0_6
	TwitchVoteTemplatesLookup[#TwitchVoteTemplatesLookup + 1] = iter_0_6

	if iter_0_7.multiple_choice then
		TwitchMultipleChoiceVoteTemplatesLookup[#TwitchMultipleChoiceVoteTemplatesLookup + 1] = iter_0_6
	else
		TwitchStandardVoteTemplatesLookup[#TwitchStandardVoteTemplatesLookup + 1] = iter_0_6
	end

	if iter_0_7.cost < 0 then
		TwitchPositiveVoteTemplatesLookup[#TwitchPositiveVoteTemplatesLookup + 1] = iter_0_6
	else
		TwitchNegativeVoteTemplatesLookup[#TwitchNegativeVoteTemplatesLookup + 1] = iter_0_6
	end

	if iter_0_7.breed_name then
		local var_0_5 = Breeds[iter_0_7.breed_name]

		if var_0_5.boss then
			iter_0_7.boss = true
			TwitchBossesSpawnBreedNamesLookup[iter_0_7.breed_name] = iter_0_7
		elseif var_0_5.special then
			iter_0_7.special = true
			TwitchSpecialsSpawnBreedNamesLookup[iter_0_7.breed_name] = iter_0_7
		end
	end

	if iter_0_7.boss_equivalent then
		TwitchBossEquivalentSpawnTemplatesLookup[#TwitchBossEquivalentSpawnTemplatesLookup + 1] = iter_0_6
	end
end

TwitchVoteWhitelists = TwitchVoteWhitelists or {}

for iter_0_8, iter_0_9 in pairs(DLCSettings) do
	local var_0_6 = iter_0_9.twitch_settings

	if var_0_6 then
		local var_0_7 = var_0_6.supported_game_modes

		if var_0_7 then
			for iter_0_10, iter_0_11 in pairs(TwitchSettings.supported_game_modes) do
				table.merge(iter_0_11, var_0_7)
			end
		end

		local var_0_8 = var_0_6.vote_whitelists

		if var_0_8 then
			for iter_0_12, iter_0_13 in pairs(var_0_8) do
				if TwitchVoteWhitelists[iter_0_12] then
					table.merge(TwitchVoteWhitelists[iter_0_12], iter_0_13)
				else
					TwitchVoteWhitelists[iter_0_12] = iter_0_13
				end
			end
		end
	end
end

fassert(var_0_3 <= TwitchSettings.max_diff, "[TwitchSettings] The minimum difference between vote templates exceeeds %s", TwitchSettings.max_diff)
