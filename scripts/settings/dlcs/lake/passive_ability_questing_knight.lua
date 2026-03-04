-- chunkname: @scripts/settings/dlcs/lake/passive_ability_questing_knight.lua

PassiveAbilityQuestingKnight = class(PassiveAbilityQuestingKnight)

local var_0_0 = 2
local var_0_1 = "questing_knight"

local function var_0_2(arg_1_0)
	local var_1_0 = Managers.level_transition_handler:get_current_level_keys()
	local var_1_1 = var_1_0 and LevelSettings[var_1_0]
	local var_1_2 = var_1_1 and var_1_1.loot_objectives

	return var_1_2 and var_1_2[arg_1_0] and var_1_2[arg_1_0] > 0
end

local function var_0_3()
	return not Managers.state.game_mode:is_round_started() and var_0_2("tome")
end

local function var_0_4()
	return not Managers.state.game_mode:is_round_started() and var_0_2("grimoire")
end

local var_0_5 = {
	default = {
		possible_challenges = {
			{
				reward = "markus_questing_knight_passive_power_level",
				type = "kill_elites",
				amount = {
					1,
					15,
					15,
					20,
					20,
					30,
					30,
					30,
					10
				}
			},
			{
				reward = "markus_questing_knight_passive_attack_speed",
				type = "kill_specials",
				amount = {
					1,
					10,
					10,
					15,
					15,
					20,
					20,
					20,
					10
				}
			},
			{
				reward = "markus_questing_knight_passive_cooldown_reduction",
				type = "kill_monsters",
				amount = {
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1
				}
			},
			{
				reward = "markus_questing_knight_passive_health_regen",
				type = "find_grimoire",
				amount = {
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1
				},
				condition = var_0_4
			},
			{
				reward = "markus_questing_knight_passive_damage_taken",
				type = "find_tome",
				amount = {
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1
				},
				condition = var_0_3
			}
		},
		side_quest_challenge = {
			reward = "markus_questing_knight_passive_strength_potion",
			type = "kill_enemies",
			amount = {
				1,
				100,
				125,
				150,
				175,
				200,
				200,
				200
			}
		}
	},
	weave = {
		possible_challenges = {
			{
				reward = "markus_questing_knight_passive_power_level",
				type = "kill_elites",
				amount = {
					1,
					15,
					15,
					20,
					20,
					30,
					30,
					30,
					10
				}
			},
			{
				reward = "markus_questing_knight_passive_attack_speed",
				type = "kill_specials",
				amount = {
					1,
					10,
					10,
					15,
					15,
					20,
					20,
					20,
					10
				}
			},
			{
				reward = "markus_questing_knight_passive_cooldown_reduction",
				type = "kill_monsters",
				amount = {
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1
				}
			}
		},
		side_quest_challenge = {
			reward = "markus_questing_knight_passive_strength_potion",
			type = "kill_enemies",
			amount = {
				1,
				100,
				125,
				150,
				175,
				200,
				200,
				200
			}
		}
	},
	versus = {
		always_reset_quest_pool = true,
		possible_challenges = {
			{
				reward = "markus_questing_knight_passive_damage_taken",
				type = "kill_specials",
				amount = {
					14,
					16,
					18,
					20,
					22,
					24,
					26,
					28,
					30
				}
			},
			{
				reward = "markus_questing_knight_passive_power_level",
				type = "kill_elites",
				amount = {
					6,
					8,
					10,
					12,
					14,
					16,
					18,
					20,
					22
				}
			},
			{
				reward = "markus_questing_knight_passive_power_level",
				type = "kill_monsters",
				amount = {
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1,
					1
				}
			},
			{
				reward = "markus_questing_knight_passive_attack_speed",
				type = "kill_enemies",
				amount = {
					30,
					35,
					40,
					45,
					50,
					55,
					60,
					65,
					70
				}
			}
		},
		side_quest_challenge = {
			reward = "markus_questing_knight_passive_strength_potion",
			type = "kill_enemies",
			amount = {
				30,
				35,
				40,
				45,
				50,
				55,
				60,
				65,
				70
			}
		}
	}
}

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	if iter_0_1.questing_knight_challenges then
		table.merge_recursive(var_0_5, iter_0_1.questing_knight_challenges)
	end
end

function PassiveAbilityQuestingKnight.init(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0._owner_unit = arg_4_2
	arg_4_0._player = arg_4_3.player
	arg_4_0._is_server = arg_4_1.is_server
	arg_4_0._player_unique_id = arg_4_3.player:unique_id()
	arg_4_0._quest_seed = Managers.mechanism:get_level_seed()

	if Managers.mechanism:current_mechanism_name() == "versus" then
		local var_4_0 = Managers.mechanism:game_mechanism():get_current_set()

		arg_4_0._quest_seed = arg_4_0._quest_seed + var_4_0
	end
end

function PassiveAbilityQuestingKnight.extensions_ready(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0._is_server then
		return
	end

	local var_5_0 = Managers.level_transition_handler:get_current_level_keys()
	local var_5_1 = var_5_0 and LevelSettings[var_5_0]
	local var_5_2 = var_5_1 and var_5_1.hub_level

	if var_5_2 then
		return
	end

	arg_5_0._is_hub_level = var_5_2

	local var_5_3 = Managers.state.difficulty:get_difficulty()

	arg_5_0._difficulty_rank = DifficultySettings[var_5_3].rank
	arg_5_0._buff_extension = ScriptUnit.extension(arg_5_2, "buff_system")
	arg_5_0._talent_extension = ScriptUnit.extension(arg_5_2, "talent_system")

	arg_5_0:_create_quests()
	arg_5_0:_register_events()
end

function PassiveAbilityQuestingKnight._create_quests(arg_6_0)
	if not arg_6_0._talent_extension:initial_talent_synced() then
		arg_6_0:_delay_quest_creation()

		return
	end

	local var_6_0 = Managers.venture.challenge
	local var_6_1 = arg_6_0._player_unique_id

	if not (Managers.party:get_status_from_unique_id(var_6_1).game_mode_data.health_state == "respawning") and arg_6_0:_always_reset_quest_pool() then
		var_6_0:remove_filtered_challenges(var_0_1, var_6_1)
	end

	local var_6_2 = var_6_0:get_challenges_filtered({}, var_0_1, var_6_1)
	local var_6_3 = #var_6_2

	if var_6_3 > 0 then
		for iter_6_0 = 1, var_6_3 do
			var_6_2[iter_6_0]:set_paused(false)
		end
	elseif #var_6_0:get_completed_challenges_filtered({}, var_0_1, var_6_1) == 0 then
		local var_6_4 = arg_6_0:_generate_quest_pool()

		arg_6_0:_start_quest_from_pool(var_6_4, var_0_0)

		if arg_6_0._talent_extension:has_talent("markus_questing_knight_passive_additional_quest") then
			arg_6_0:_start_quest_from_pool(var_6_4, 1)
		end

		if arg_6_0._talent_extension:has_talent("markus_questing_knight_passive_side_quest") then
			local var_6_5 = arg_6_0:_get_side_quest_challenge()

			var_6_0:add_challenge(var_6_5.type, true, var_0_1, var_6_5.reward, var_6_1, var_6_5.amount[arg_6_0._difficulty_rank])
		end
	end
end

function PassiveAbilityQuestingKnight._generate_quest_pool(arg_7_0)
	local var_7_0 = table.clone(arg_7_0:_get_possible_challenges())

	table.shuffle(var_7_0, arg_7_0._quest_seed)

	return var_7_0
end

function PassiveAbilityQuestingKnight._get_possible_challenges(arg_8_0)
	local var_8_0 = Managers.state.game_mode:game_mode_key()
	local var_8_1 = (var_0_5[var_8_0] or var_0_5.default).possible_challenges

	fassert(var_8_1, "[PassiveAbilityQuestingKnight] possible_challenges not defined for the current game mode")

	local var_8_2 = {}

	for iter_8_0 = 1, #var_8_1 do
		local var_8_3 = var_8_1[iter_8_0]

		if not var_8_3.condition or var_8_3.condition() then
			var_8_2[#var_8_2 + 1] = var_8_3
		end
	end

	return var_8_2
end

function PassiveAbilityQuestingKnight._get_side_quest_challenge(arg_9_0)
	local var_9_0 = Managers.state.game_mode:game_mode_key()
	local var_9_1 = (var_0_5[var_9_0] or var_0_5.default).side_quest_challenge

	fassert(var_9_1, "[PassiveAbilityQuestingKnight] side_quest_challenge not defined for the current game mode")

	return var_9_1
end

function PassiveAbilityQuestingKnight._always_reset_quest_pool(arg_10_0)
	local var_10_0 = Managers.state.game_mode:game_mode_key()

	return (var_0_5[var_10_0] or var_0_5.default).always_reset_quest_pool or false
end

function PassiveAbilityQuestingKnight._start_quest_from_pool(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = Managers.venture.challenge
	local var_11_1 = arg_11_0._difficulty_rank
	local var_11_2 = #arg_11_1

	for iter_11_0 = 1, arg_11_2 do
		if var_11_2 == 0 then
			print("PassiveAbilityQuestingKnight: Not enought challenges, requested", arg_11_2)

			break
		end

		local var_11_3 = arg_11_1[var_11_2]
		local var_11_4 = var_11_3.reward

		if arg_11_0._talent_extension:has_talent("markus_questing_knight_passive_improved_reward") then
			var_11_4 = var_11_4 .. "_improved"
		end

		var_11_0:add_challenge(var_11_3.type, false, "questing_knight", var_11_4, arg_11_0._player_unique_id, var_11_3.amount[var_11_1])
		table.remove(arg_11_1, var_11_2)

		var_11_2 = var_11_2 - 1
	end
end

function PassiveAbilityQuestingKnight._delay_quest_creation(arg_12_0)
	Managers.state.event:register(arg_12_0, "on_initial_talents_synced", "on_initial_talents_synced")
end

function PassiveAbilityQuestingKnight.on_initial_talents_synced(arg_13_0, arg_13_1)
	if arg_13_0._talent_extension == arg_13_1 then
		if not arg_13_0._is_server or arg_13_0._is_hub_level then
			return
		end

		Managers.state.event:unregister("on_initial_talents_synced", arg_13_0)
		arg_13_0:_create_quests()
	end
end

function PassiveAbilityQuestingKnight.destroy(arg_14_0)
	arg_14_0:_unregister_events()
end

function PassiveAbilityQuestingKnight._register_events(arg_15_0)
	if Managers.mechanism:current_mechanism_name() == "versus" then
		Managers.state.event:register(arg_15_0, "on_talents_changed", "on_talents_changed")
	end
end

function PassiveAbilityQuestingKnight.on_talents_changed(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0._talent_extension == arg_16_2 then
		arg_16_0:_create_quests()
	end
end

function PassiveAbilityQuestingKnight._unregister_events(arg_17_0)
	if Managers.state.event then
		Managers.state.event:unregister("on_talents_changed", arg_17_0)
		Managers.state.event:unregister("on_initial_talents_synced", arg_17_0)
	end
end
