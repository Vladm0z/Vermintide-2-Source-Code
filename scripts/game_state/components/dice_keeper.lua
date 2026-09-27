-- chunkname: @scripts/game_state/components/dice_keeper.lua

DiceKeeper = class(DiceKeeper)

DiceKeeper.init = function (self, arg_1_1)
	-- function 1
	self._dice = {
		gold = 0,
		metal = 0,
		warpstone = 0,
		wood = arg_1_1
	}
	self._new_dice = {}
end

DiceKeeper.register_rpcs = function (self, arg_2_1)
	-- function 2
	self._network_event_delegate = arg_2_1
end

DiceKeeper.unregister_rpc = function (self)
	-- function 3
	self._network_event_delegate = nil
end

DiceKeeper.get_dice = function (self)
	-- function 4
	return self._dice
end

DiceKeeper.num_dices = function (self, arg_5_1)
	-- function 5
	return self._dice[arg_5_1]
end

DiceKeeper.num_new_dices = function (self, arg_6_1)
	-- function 6
	local var_6_0 = self._new_dice[arg_6_1]

	var_6_0 = var_6_0 or 0

	return var_6_0
end

DiceKeeper.add_die = function (self, arg_7_1, arg_7_2)
	-- function 7
	Managers.state.debug_text:output_screen_text(string.format("Awarded %d extra die/dice of type %s", arg_7_2, arg_7_1), 42, 5)

	self._dice[arg_7_1] = self._dice[arg_7_1] + arg_7_2
	self._dice.wood = self._dice.wood - arg_7_2

	local _new_dice = self._new_dice
	local var_7_1 = self._new_dice[arg_7_1]

	var_7_1 = var_7_1 or 0
	_new_dice[arg_7_1] = var_7_1 + 1
end

DiceKeeper.bonus_dice_spawned = function (self)
	-- function 8
	local num

	if not self._bonus_dice_spawned then
		num = self._bonus_dice_spawned + 1

		if not num then
			-- Nothing
		end
	end

	num = 1

	::label_8_0::

	self._bonus_dice_spawned = num
end

DiceKeeper.num_bonus_dice_spawned = function (self)
	-- function 9
	local _bonus_dice_spawned = self._bonus_dice_spawned

	_bonus_dice_spawned = _bonus_dice_spawned or 0

	return _bonus_dice_spawned
end

DiceKeeper.chest_loot_dice_chance = function (self)
	-- function 10
	local _chest_loot_dice_chance = self._chest_loot_dice_chance

	_chest_loot_dice_chance = _chest_loot_dice_chance or 0.05

	return _chest_loot_dice_chance
end

DiceKeeper.calculcate_loot_die_chance_on_remaining_chests = function (self, arg_11_1)
	-- function 11
	if arg_11_1 > 0 then
		self._chest_loot_dice_chance = 0.05 * (1 / arg_11_1)
	end
end
