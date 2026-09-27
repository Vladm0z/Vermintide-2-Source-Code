-- chunkname: @scripts/settings/dlcs/lake/passive_ability_questing_knight.lua

PassiveAbilityQuestingKnight = class(PassiveAbilityQuestingKnight)

local num = 2
local str = "questing_knight"

local function fn(arg_1_0)
	-- function 1
	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local flag = not get_current_level_keys and LevelSettings[get_current_level_keys]
	local flag_2 = not flag and flag.loot_objectives

	if not flag_2 then
		-- Nothing
	end

	::label_1_0::

	local var_1_3 = flag_2[arg_1_0]

	var_1_3 = not var_1_3 and flag_2[arg_1_0] > 0

	::label_1_1::

	return var_1_3
end

local function fn_2()
	-- function 2
	return not not Managers.state.game_mode:is_round_started() or fn("tome")
end

local function fn_3()
	-- function 3
	return not not Managers.state.game_mode:is_round_started() or fn("grimoire")
end

local tbl = {
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
				condition = fn_3
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
				condition = fn_2
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

for k, v in pairs(DLCSettings) do
	if not v.questing_knight_challenges then
		table.merge_recursive(tbl, v.questing_knight_challenges)
	end
end

PassiveAbilityQuestingKnight.init = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	self._owner_unit = arg_4_2
	self._player = arg_4_3.player
	self._is_server = arg_4_1.is_server
	self._player_unique_id = arg_4_3.player:unique_id()
	self._quest_seed = Managers.mechanism:get_level_seed()

	if Managers.mechanism:current_mechanism_name() == "versus" then
		local get_current_set = Managers.mechanism:game_mechanism():get_current_set()

		self._quest_seed = self._quest_seed + get_current_set
	end
end

PassiveAbilityQuestingKnight.extensions_ready = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._is_server then
		return
	end

	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local flag = not get_current_level_keys and LevelSettings[get_current_level_keys]
	local flag_2 = not flag and flag.hub_level

	if not flag_2 then
		return
	end

	self._is_hub_level = flag_2

	local get_difficulty = Managers.state.difficulty:get_difficulty()

	self._difficulty_rank = DifficultySettings[get_difficulty].rank
	self._buff_extension = ScriptUnit.extension(arg_5_2, "buff_system")
	self._talent_extension = ScriptUnit.extension(arg_5_2, "talent_system")

	self:_create_quests()
	self:_register_events()
end

PassiveAbilityQuestingKnight._create_quests = function (self)
	-- function 6
	if not self._talent_extension:initial_talent_synced() then
		self:_delay_quest_creation()

		return
	end

	local challenge = Managers.venture.challenge
	local _player_unique_id = self._player_unique_id

	if Managers.party:get_status_from_unique_id(_player_unique_id).game_mode_data.health_state == "respawning" or not self:_always_reset_quest_pool() then
		challenge:remove_filtered_challenges(str, _player_unique_id)
	end

	local get_challenges_filtered = challenge:get_challenges_filtered({}, str, _player_unique_id)
	local count = #get_challenges_filtered

	if count > 0 then
		for i = 1, count do
			get_challenges_filtered[i]:set_paused(false)
		end
	elseif #challenge:get_completed_challenges_filtered({}, str, _player_unique_id) == 0 then
		local _generate_quest_pool = self:_generate_quest_pool()

		self:_start_quest_from_pool(_generate_quest_pool, num)

		if not self._talent_extension:has_talent("markus_questing_knight_passive_additional_quest") then
			self:_start_quest_from_pool(_generate_quest_pool, 1)
		end

		if not self._talent_extension:has_talent("markus_questing_knight_passive_side_quest") then
			local _get_side_quest_challenge = self:_get_side_quest_challenge()

			challenge:add_challenge(_get_side_quest_challenge.type, true, str, _get_side_quest_challenge.reward, _player_unique_id, _get_side_quest_challenge.amount[self._difficulty_rank])
		end
	end
end

PassiveAbilityQuestingKnight._generate_quest_pool = function (self)
	-- function 7
	local clone = table.clone(self:_get_possible_challenges())

	table.shuffle(clone, self._quest_seed)

	return clone
end

PassiveAbilityQuestingKnight._get_possible_challenges = function (arg_8_0)
	-- function 8
	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local var_8_1 = tbl[game_mode_key]

	var_8_1 = var_8_1 or tbl.default

	local possible_challenges = var_8_1.possible_challenges

	fassert(possible_challenges, "[PassiveAbilityQuestingKnight] possible_challenges not defined for the current game mode")

	local tbl_2 = {}

	for i = 1, #possible_challenges do
		local var_8_4 = possible_challenges[i]

		if not var_8_4.condition and not var_8_4.condition() then
			tbl_2[#tbl_2 + 1] = var_8_4
		end
	end

	return tbl_2
end

PassiveAbilityQuestingKnight._get_side_quest_challenge = function (arg_9_0)
	-- function 9
	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local var_9_1 = tbl[game_mode_key]

	var_9_1 = var_9_1 or tbl.default

	local side_quest_challenge = var_9_1.side_quest_challenge

	fassert(side_quest_challenge, "[PassiveAbilityQuestingKnight] side_quest_challenge not defined for the current game mode")

	return side_quest_challenge
end

PassiveAbilityQuestingKnight._always_reset_quest_pool = function (arg_10_0)
	-- function 10
	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local var_10_1 = tbl[game_mode_key]

	var_10_1 = var_10_1 or tbl.default

	local always_reset_quest_pool = var_10_1.always_reset_quest_pool

	always_reset_quest_pool = always_reset_quest_pool or false

	return always_reset_quest_pool
end

PassiveAbilityQuestingKnight._start_quest_from_pool = function (self, arg_11_1, arg_11_2)
	-- function 11
	local challenge = Managers.venture.challenge
	local _difficulty_rank = self._difficulty_rank
	local count = #arg_11_1

	for i = 1, arg_11_2 do
		if count == 0 then
			print("PassiveAbilityQuestingKnight: Not enought challenges, requested", arg_11_2)

			break
		end

		local var_11_3 = arg_11_1[count]
		local reward = var_11_3.reward

		if not self._talent_extension:has_talent("markus_questing_knight_passive_improved_reward") then
			reward = reward .. "_improved"
		end

		challenge:add_challenge(var_11_3.type, false, "questing_knight", reward, self._player_unique_id, var_11_3.amount[_difficulty_rank])
		table.remove(arg_11_1, count)

		count = count - 1
	end
end

PassiveAbilityQuestingKnight._delay_quest_creation = function (arg_12_0)
	-- function 12
	Managers.state.event:register(arg_12_0, "on_initial_talents_synced", "on_initial_talents_synced")
end

PassiveAbilityQuestingKnight.on_initial_talents_synced = function (self, arg_13_1)
	-- function 13
	if self._talent_extension == arg_13_1 then
		if not self._is_server and not self._is_hub_level then
			return
		end

		Managers.state.event:unregister("on_initial_talents_synced", self)
		self:_create_quests()
	end
end

PassiveAbilityQuestingKnight.destroy = function (self)
	-- function 14
	self:_unregister_events()
end

PassiveAbilityQuestingKnight._register_events = function (arg_15_0)
	-- function 15
	if Managers.mechanism:current_mechanism_name() == "versus" then
		Managers.state.event:register(arg_15_0, "on_talents_changed", "on_talents_changed")
	end
end

PassiveAbilityQuestingKnight.on_talents_changed = function (self, arg_16_1, arg_16_2)
	-- function 16
	if self._talent_extension == arg_16_2 then
		self:_create_quests()
	end
end

PassiveAbilityQuestingKnight._unregister_events = function (arg_17_0)
	-- function 17
	if not Managers.state.event then
		Managers.state.event:unregister("on_talents_changed", arg_17_0)
		Managers.state.event:unregister("on_initial_talents_synced", arg_17_0)
	end
end
