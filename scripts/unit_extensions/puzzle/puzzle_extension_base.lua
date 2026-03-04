-- chunkname: @scripts/unit_extensions/puzzle/puzzle_extension_base.lua

PuzzleExtensionBase = class(PuzzleExtensionBase)

PuzzleExtensionBase.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._puzzle_group = Unit.get_data(arg_1_2, "puzzle_group")
	arg_1_0._optional_order_id = tonumber(Unit.get_data(arg_1_2, "puzzle_order_id"))

	fassert(arg_1_0._puzzle_group, "Unit '%s' is missing puzzle group", arg_1_2)
	fassert(arg_1_0:puzzle_value(), "Unit '%s' does not expose 'puzzle_value' as an External Output or script_data", arg_1_2)
end

PuzzleExtensionBase.puzzle_group_id = function (arg_2_0)
	return arg_2_0._puzzle_group
end

PuzzleExtensionBase.puzzle_value = function (arg_3_0)
	return tostring(Unit.get_data(arg_3_0._unit, "puzzle_value"))
end

PuzzleExtensionBase.order_id = function (arg_4_0)
	return arg_4_0._optional_order_id
end

PuzzleExtensionBase.on_puzzle_completed = function (arg_5_0, arg_5_1)
	Unit.set_flow_variable(arg_5_0._unit, "completed_puzzle_name", arg_5_1)
	Unit.flow_event(arg_5_0._unit, "on_puzzle_completed")
end

PuzzleExtensionBase.destroy = function (arg_6_0)
	return
end
