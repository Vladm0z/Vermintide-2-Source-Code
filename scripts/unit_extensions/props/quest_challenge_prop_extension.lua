-- chunkname: @scripts/unit_extensions/props/quest_challenge_prop_extension.lua

QuestChallengePropExtension = class(QuestChallengePropExtension)

local var_0_0 = 0.5
local var_0_1 = 2

function QuestChallengePropExtension.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._unit = arg_1_2

	arg_1_0:_highlight_off()

	arg_1_0._has_unclaimed_achievements = false
	arg_1_0._has_unclaimed_quests = false
	arg_1_0._next_unclaimed_achievement_check = 0
	arg_1_0._next_unclaimed_quest_check = 0
end

function QuestChallengePropExtension.update(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_0:_update_unclaimed_achievement_status(arg_2_3, arg_2_5)
	arg_2_0:_update_unclaimed_quests_status(arg_2_3, arg_2_5)
	arg_2_0:_evaluate_highlight_status()
end

function QuestChallengePropExtension._update_unclaimed_achievement_status(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_2 > arg_3_0._next_unclaimed_achievement_check then
		arg_3_0._has_unclaimed_achievements = Managers.state.achievement:has_any_unclaimed_achievement()
		arg_3_0._next_unclaimed_achievement_check = arg_3_2 + var_0_0
	end
end

function QuestChallengePropExtension._update_unclaimed_quests_status(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_2 > arg_4_0._next_unclaimed_quest_check then
		arg_4_0._has_unclaimed_quests = Managers.state.quest:has_any_unclaimed_quests()
		arg_4_0._next_unclaimed_quest_check = arg_4_2 + var_0_1
	end
end

function QuestChallengePropExtension._evaluate_highlight_status(arg_5_0)
	local var_5_0
	local var_5_1 = (arg_5_0._has_unclaimed_achievements or arg_5_0._has_unclaimed_quests) and true or false

	if var_5_1 ~= arg_5_0._highlighted then
		if var_5_1 then
			arg_5_0:_highlight_on()
		else
			arg_5_0:_highlight_off()
		end
	end
end

function QuestChallengePropExtension._highlight_on(arg_6_0)
	Unit.flow_event(arg_6_0._unit, "highlight_on")

	arg_6_0._highlighted = true
end

function QuestChallengePropExtension._highlight_off(arg_7_0)
	Unit.flow_event(arg_7_0._unit, "highlight_off")

	arg_7_0._highlighted = false
end
