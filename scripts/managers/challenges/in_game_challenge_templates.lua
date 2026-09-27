-- chunkname: @scripts/managers/challenges/in_game_challenge_templates.lua

local InGameChallengeTemplates = InGameChallengeTemplates

InGameChallengeTemplates = InGameChallengeTemplates or {}
InGameChallengeTemplates = InGameChallengeTemplates
InGameChallengeTemplates.kill_enemies = {
	default_target = 3,
	description = "challenge_description_kill_enemies_01",
	events = {
		on_player_killed_enemy = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
			-- function 1
			return 1
		end
	}
}
InGameChallengeTemplates.kill_elites = {
	default_target = 20,
	description = "challenge_description_kill_elites_01",
	events = {
		on_player_killed_enemy = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
			-- function 2
			if not arg_2_3.elite then
				return 1
			end
		end
	}
}
InGameChallengeTemplates.kill_specials = {
	default_target = 10,
	description = "challenge_description_kill_specials_01",
	events = {
		on_player_killed_enemy = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
			-- function 3
			if not arg_3_3.special then
				return 1
			end
		end
	}
}
InGameChallengeTemplates.kill_monsters = {
	default_target = 1,
	description = "challenge_description_kill_monsters_01",
	events = {
		on_player_killed_enemy = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
			-- function 4
			if not arg_4_3.boss then
				return 1
			end
		end
	}
}
InGameChallengeTemplates.find_tome = {
	default_target = 1,
	description = "challenge_description_find_tome_01",
	events = {
		player_pickup_tome = function (arg_5_0, arg_5_1, arg_5_2)
			-- function 5
			return 1
		end
	}
}
InGameChallengeTemplates.find_grimoire = {
	default_target = 1,
	description = "challenge_description_find_grimoire_01",
	events = {
		player_pickup_grimoire = function (arg_6_0, arg_6_1, arg_6_2)
			-- function 6
			return 1
		end
	}
}
InGameChallengeTemplates.kill_roamers = {
	default_target = 1,
	description = "challenge_description_kill_roamers_01",
	events = {
		on_player_killed_enemy = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
			-- function 7
			if not (arg_7_3.boss or arg_7_3.special or arg_7_3.elite) then
				return 1
			end
		end
	}
}

for k, v in pairs(DLCSettings) do
	local ingame_challenge_templates = v.ingame_challenge_templates

	if not ingame_challenge_templates then
		table.merge(InGameChallengeTemplates, ingame_challenge_templates)
	end
end
