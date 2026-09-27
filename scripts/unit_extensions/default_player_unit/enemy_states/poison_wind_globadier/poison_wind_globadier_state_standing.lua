-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/poison_wind_globadier/poison_wind_globadier_state_standing.lua

PoisonWindGlobadierStateStanding = class(PoisonWindGlobadierStateStanding, EnemyCharacterStateStanding)

PoisonWindGlobadierStateStanding.init = function (self, arg_1_1)
	-- function 1
	PoisonWindGlobadierStateStanding.super.init(self, arg_1_1)

	self._gas_ability_id = self._career_extension:ability_id("gas")
end

PoisonWindGlobadierStateStanding.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self:common_state_changes() then
		return
	end

	local _csm = self._csm
	local _career_extension = self._career_extension

	if self._ghost_mode_extension:is_in_ghost_mode() or not _career_extension:ability_was_triggered(self._gas_ability_id) then
		_csm:change_state("globadier_throwing")

		return
	end

	self:_update_taunt_dialogue(arg_2_5)

	local common_movement = self:common_movement(arg_2_5)
end
