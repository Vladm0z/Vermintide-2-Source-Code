-- chunkname: @scripts/settings/twitch_settings.lua

local TwitchSettings = TwitchSettings

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
TwitchSettings = TwitchSettings

local TwitchVoteTemplates = TwitchVoteTemplates

TwitchVoteTemplates = TwitchVoteTemplates or {}
TwitchVoteTemplates = TwitchVoteTemplates

require("scripts/settings/twitch_vote_templates_buffs")
require("scripts/settings/twitch_vote_templates_items")
require("scripts/settings/twitch_vote_templates_spawning")
require("scripts/settings/twitch_vote_templates_mutators")

for k, v in pairs(DLCSettings) do
	local twitch_settings = v.twitch_settings
	local flag = not twitch_settings and twitch_settings.vote_templates_file

	if not flag then
		require(flag)
	end
end

local tbl = {}
local huge = math.huge

for k_2, v_2 in pairs(TwitchVoteTemplates) do
	tbl[k_2] = k_2

	for k_3, v_3 in pairs(TwitchVoteTemplates) do
		if not tbl[k_3] then
			local abs = math.abs(v_3.cost + v_2.cost)

			if abs < huge then
				huge = abs
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

for k_4, v_4 in pairs(TwitchVoteTemplates) do
	v_4.name = k_4
	TwitchVoteTemplatesLookup[#TwitchVoteTemplatesLookup + 1] = k_4

	if not v_4.multiple_choice then
		TwitchMultipleChoiceVoteTemplatesLookup[#TwitchMultipleChoiceVoteTemplatesLookup + 1] = k_4
	else
		TwitchStandardVoteTemplatesLookup[#TwitchStandardVoteTemplatesLookup + 1] = k_4
	end

	if v_4.cost < 0 then
		TwitchPositiveVoteTemplatesLookup[#TwitchPositiveVoteTemplatesLookup + 1] = k_4
	else
		TwitchNegativeVoteTemplatesLookup[#TwitchNegativeVoteTemplatesLookup + 1] = k_4
	end

	if not v_4.breed_name then
		local var_0_7 = Breeds[v_4.breed_name]

		if not var_0_7.boss then
			v_4.boss = true
			TwitchBossesSpawnBreedNamesLookup[v_4.breed_name] = v_4
		elseif not var_0_7.special then
			v_4.special = true
			TwitchSpecialsSpawnBreedNamesLookup[v_4.breed_name] = v_4
		end
	end

	if not v_4.boss_equivalent then
		TwitchBossEquivalentSpawnTemplatesLookup[#TwitchBossEquivalentSpawnTemplatesLookup + 1] = k_4
	end
end

local TwitchVoteWhitelists = TwitchVoteWhitelists

TwitchVoteWhitelists = TwitchVoteWhitelists or {}
TwitchVoteWhitelists = TwitchVoteWhitelists

for k_5, v_5 in pairs(DLCSettings) do
	local twitch_settings_2 = v_5.twitch_settings

	if not twitch_settings_2 then
		local supported_game_modes = twitch_settings_2.supported_game_modes

		if not supported_game_modes then
			for k_6, v_6 in pairs(TwitchSettings.supported_game_modes) do
				table.merge(v_6, supported_game_modes)
			end
		end

		local vote_whitelists = twitch_settings_2.vote_whitelists

		if not vote_whitelists then
			for k_7, v_7 in pairs(vote_whitelists) do
				if not TwitchVoteWhitelists[k_7] then
					table.merge(TwitchVoteWhitelists[k_7], v_7)
				else
					TwitchVoteWhitelists[k_7] = v_7
				end
			end
		end
	end
end

fassert(huge <= TwitchSettings.max_diff, "[TwitchSettings] The minimum difference between vote templates exceeeds %s", TwitchSettings.max_diff)
