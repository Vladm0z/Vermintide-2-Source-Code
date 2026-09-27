-- chunkname: @scripts/unit_extensions/props/quest_challenge_prop_extension.lua

QuestChallengePropExtension = class(QuestChallengePropExtension)

local num = 0.5
local num_2 = 2

QuestChallengePropExtension.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._unit = arg_1_2

	self:_highlight_off()

	self._has_unclaimed_achievements = false
	self._has_unclaimed_quests = false
	self._next_unclaimed_achievement_check = 0
	self._next_unclaimed_quest_check = 0
end

QuestChallengePropExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	self:_update_unclaimed_achievement_status(arg_2_3, arg_2_5)
	self:_update_unclaimed_quests_status(arg_2_3, arg_2_5)
	self:_evaluate_highlight_status()
end

QuestChallengePropExtension._update_unclaimed_achievement_status = function (self, arg_3_1, arg_3_2)
	-- function 3
	if arg_3_2 > self._next_unclaimed_achievement_check then
		self._has_unclaimed_achievements = Managers.state.achievement:has_any_unclaimed_achievement()
		self._next_unclaimed_achievement_check = arg_3_2 + num
	end
end

QuestChallengePropExtension._update_unclaimed_quests_status = function (self, arg_4_1, arg_4_2)
	-- function 4
	if arg_4_2 > self._next_unclaimed_quest_check then
		self._has_unclaimed_quests = Managers.state.quest:has_any_unclaimed_quests()
		self._next_unclaimed_quest_check = arg_4_2 + num_2
	end
end

QuestChallengePropExtension._evaluate_highlight_status = function (self)
	-- function 5
	local var_5_0
	local flag

	flag = self._has_unclaimed_achievements or not self._has_unclaimed_quests or true or false

	if not (flag ~= self._highlighted) then
		if not flag then
			self:_highlight_on()
		else
			self:_highlight_off()
		end
	end
end

QuestChallengePropExtension._highlight_on = function (self)
	-- function 6
	Unit.flow_event(self._unit, "highlight_on")

	self._highlighted = true
end

QuestChallengePropExtension._highlight_off = function (self)
	-- function 7
	Unit.flow_event(self._unit, "highlight_off")

	self._highlighted = false
end
