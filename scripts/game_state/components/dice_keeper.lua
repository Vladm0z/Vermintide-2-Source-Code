-- chunkname: @scripts/game_state/components/dice_keeper.lua

DiceKeeper = class(DiceKeeper)

DiceKeeper.init = function (arg_1_0, arg_1_1)
	arg_1_0._dice = {
		gold = 0,
		metal = 0,
		warpstone = 0,
		wood = arg_1_1
	}
	arg_1_0._new_dice = {}
end

DiceKeeper.register_rpcs = function (arg_2_0, arg_2_1)
	arg_2_0._network_event_delegate = arg_2_1
end

DiceKeeper.unregister_rpc = function (arg_3_0)
	arg_3_0._network_event_delegate = nil
end

DiceKeeper.get_dice = function (arg_4_0)
	return arg_4_0._dice
end

DiceKeeper.num_dices = function (arg_5_0, arg_5_1)
	return arg_5_0._dice[arg_5_1]
end

DiceKeeper.num_new_dices = function (arg_6_0, arg_6_1)
	return arg_6_0._new_dice[arg_6_1] or 0
end

DiceKeeper.add_die = function (arg_7_0, arg_7_1, arg_7_2)
	Managers.state.debug_text:output_screen_text(string.format("Awarded %d extra die/dice of type %s", arg_7_2, arg_7_1), 42, 5)

	arg_7_0._dice[arg_7_1] = arg_7_0._dice[arg_7_1] + arg_7_2
	arg_7_0._dice.wood = arg_7_0._dice.wood - arg_7_2
	arg_7_0._new_dice[arg_7_1] = (arg_7_0._new_dice[arg_7_1] or 0) + 1
end

DiceKeeper.bonus_dice_spawned = function (arg_8_0)
	arg_8_0._bonus_dice_spawned = arg_8_0._bonus_dice_spawned and arg_8_0._bonus_dice_spawned + 1 or 1
end

DiceKeeper.num_bonus_dice_spawned = function (arg_9_0)
	return arg_9_0._bonus_dice_spawned or 0
end

DiceKeeper.chest_loot_dice_chance = function (arg_10_0)
	return arg_10_0._chest_loot_dice_chance or 0.05
end

DiceKeeper.calculcate_loot_die_chance_on_remaining_chests = function (arg_11_0, arg_11_1)
	if arg_11_1 > 0 then
		arg_11_0._chest_loot_dice_chance = 0.05 * (1 / arg_11_1)
	end
end
