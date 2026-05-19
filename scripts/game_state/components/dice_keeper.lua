-- chunkname: @scripts/game_state/components/dice_keeper.lua

DiceKeeper = class(DiceKeeper)

function DiceKeeper.init(arg_1_0, arg_1_1)
	arg_1_0._dice = {
		gold = 0,
		metal = 0,
		warpstone = 0,
		wood = arg_1_1
	}
	arg_1_0._new_dice = {}
end

function DiceKeeper.register_rpcs(arg_2_0, arg_2_1)
	arg_2_0._network_event_delegate = arg_2_1
end

function DiceKeeper.unregister_rpc(arg_3_0)
	arg_3_0._network_event_delegate = nil
end

function DiceKeeper.get_dice(arg_4_0)
	return arg_4_0._dice
end

function DiceKeeper.num_dices(arg_5_0, arg_5_1)
	return arg_5_0._dice[arg_5_1]
end

function DiceKeeper.num_new_dices(arg_6_0, arg_6_1)
	return arg_6_0._new_dice[arg_6_1] or 0
end

function DiceKeeper.add_die(arg_7_0, arg_7_1, arg_7_2)
	Managers.state.debug_text:output_screen_text(string.format("Awarded %d extra die/dice of type %s", arg_7_2, arg_7_1), 42, 5)

	arg_7_0._dice[arg_7_1] = arg_7_0._dice[arg_7_1] + arg_7_2
	arg_7_0._dice.wood = arg_7_0._dice.wood - arg_7_2
	arg_7_0._new_dice[arg_7_1] = (arg_7_0._new_dice[arg_7_1] or 0) + 1
end

function DiceKeeper.bonus_dice_spawned(arg_8_0)
	arg_8_0._bonus_dice_spawned = arg_8_0._bonus_dice_spawned and arg_8_0._bonus_dice_spawned + 1 or 1
end

function DiceKeeper.num_bonus_dice_spawned(arg_9_0)
	return arg_9_0._bonus_dice_spawned or 0
end

function DiceKeeper.chest_loot_dice_chance(arg_10_0)
	return arg_10_0._chest_loot_dice_chance or 0.05
end

function DiceKeeper.calculcate_loot_die_chance_on_remaining_chests(arg_11_0, arg_11_1)
	if arg_11_1 > 0 then
		arg_11_0._chest_loot_dice_chance = 0.05 * (1 / arg_11_1)
	end
end
