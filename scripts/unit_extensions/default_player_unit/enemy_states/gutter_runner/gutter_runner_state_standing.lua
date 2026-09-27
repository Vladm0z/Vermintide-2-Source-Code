-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_standing.lua

GutterRunnerStateStanding = class(GutterRunnerStateStanding, EnemyCharacterStateStanding)

GutterRunnerStateStanding.init = function (self, arg_1_1)
	-- function 1
	GutterRunnerStateStanding.super.init(self, arg_1_1)

	self._pounce_ability_id = self._career_extension:ability_id("pounce")
	self._foff_ability_id = self._career_extension:ability_id("foff")
end

GutterRunnerStateStanding.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self:common_state_changes() then
		return
	end

	local _csm = self._csm
	local _career_extension = self._career_extension

	if not _career_extension:ability_was_triggered(self._pounce_ability_id) then
		_csm:change_state("gutter_runner_prowling")

		return
	end

	if not _career_extension:ability_was_triggered(self._foff_ability_id) then
		_csm:change_state("gutter_runner_foff")

		return
	end

	if not self._status_extension:is_invisible() then
		self:_update_taunt_dialogue(arg_2_5)
	end

	local common_movement = self:common_movement(arg_2_5)
end
