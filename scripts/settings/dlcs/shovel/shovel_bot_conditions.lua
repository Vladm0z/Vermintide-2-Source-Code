-- chunkname: @scripts/settings/dlcs/shovel/shovel_bot_conditions.lua

local BTConditions = BTConditions
local can_activate = BTConditions.can_activate

can_activate = can_activate or {}
BTConditions.can_activate = can_activate

local BTConditions_2 = BTConditions
local can_activate_non_combat = BTConditions.can_activate_non_combat

can_activate_non_combat = can_activate_non_combat or {}
BTConditions_2.can_activate_non_combat = can_activate_non_combat

table.merge_recursive(BTConditions.ability_check_categories, {
	activate_ability = {
		bw_necromancer = true
	}
})

BTConditions.can_activate.bw_necromancer = function (self)
	-- function 1
	if self.ai_slot_extension.num_occupied_slots >= 3 then
		return true
	end

	if not Managers.state.game_mode:is_round_started() then
		self._bt_conditions_first_ability = true

		return false
	elseif not self._bt_conditions_first_ability then
		local time = Managers.time:time("game")
		local _first_ability_t = self._first_ability_t

		_first_ability_t = _first_ability_t or time + Math.random(1, 4)
		self._first_ability_t = _first_ability_t

		if time < self._first_ability_t then
			return false
		end

		self._bt_conditions_first_ability = nil
		self._first_ability_t = nil
	end

	if self.ai_commander_extension:get_controlled_units_count() <= 4 then
		return true
	end

	return false
end
