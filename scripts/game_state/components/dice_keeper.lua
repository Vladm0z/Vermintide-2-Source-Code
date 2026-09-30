-- chunkname: @scripts/game_state/components/dice_keeper.lua

DiceKeeper = class(DiceKeeper)

DiceKeeper.init = function (self, num_normal)
	-- function 1
	self._dice = {
		gold = 0,
		metal = 0,
		warpstone = 0,
		wood = num_normal
	}
	self._new_dice = {}
end

DiceKeeper.register_rpcs = function (self, network_event_delegate)
	-- function 2
	self._network_event_delegate = network_event_delegate
end

DiceKeeper.unregister_rpc = function (self)
	-- function 3
	self._network_event_delegate = nil
end

DiceKeeper.get_dice = function (self)
	-- function 4
	return self._dice
end

DiceKeeper.num_dices = function (self, die_type)
	-- function 5
	return self._dice[die_type]
end

DiceKeeper.num_new_dices = function (self, die_type)
	-- function 6
	return self._new_dice[die_type]
end

DiceKeeper.add_die = function (self, die_type, amount)
	-- function 7
	Managers.state.debug_text:output_screen_text(string.format("Awarded %d extra die/dice of type %s", amount, die_type), 42, 5)

	self._dice[die_type] = self._dice[die_type] + amount
	self._dice.wood = self._dice.wood - amount
	self._new_dice[die_type] = self._new_dice[die_type] + 1
end

DiceKeeper.bonus_dice_spawned = function (self)
	-- function 8
	self._bonus_dice_spawned = self._bonus_dice_spawned and self._bonus_dice_spawned + 1 or not self._bonus_dice_spawned and 1
end

DiceKeeper.num_bonus_dice_spawned = function (self)
	-- function 9
	return self._bonus_dice_spawned
end

DiceKeeper.chest_loot_dice_chance = function (self)
	-- function 10
	return self._chest_loot_dice_chance
end

DiceKeeper.calculcate_loot_die_chance_on_remaining_chests = function (self, percentage_chests_left)
	-- function 11
	if percentage_chests_left > 0 then
		self._chest_loot_dice_chance = 0.05 * (1 / percentage_chests_left)
	end
end
