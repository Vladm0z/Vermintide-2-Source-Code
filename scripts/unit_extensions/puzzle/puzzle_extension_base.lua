-- chunkname: @scripts/unit_extensions/puzzle/puzzle_extension_base.lua

PuzzleExtensionBase = class(PuzzleExtensionBase)

function PuzzleExtensionBase.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._puzzle_group = Unit.get_data(arg_1_2, "puzzle_group")
	arg_1_0._optional_order_id = tonumber(Unit.get_data(arg_1_2, "puzzle_order_id"))

	fassert(arg_1_0._puzzle_group, "Unit '%s' is missing puzzle group", arg_1_2)
	fassert(arg_1_0:puzzle_value(), "Unit '%s' does not expose 'puzzle_value' as an External Output or script_data", arg_1_2)
end

function PuzzleExtensionBase.puzzle_group_id(arg_2_0)
	return arg_2_0._puzzle_group
end

function PuzzleExtensionBase.puzzle_value(arg_3_0)
	return tostring(Unit.get_data(arg_3_0._unit, "puzzle_value"))
end

function PuzzleExtensionBase.order_id(arg_4_0)
	return arg_4_0._optional_order_id
end

function PuzzleExtensionBase.on_puzzle_completed(arg_5_0, arg_5_1)
	Unit.set_flow_variable(arg_5_0._unit, "completed_puzzle_name", arg_5_1)
	Unit.flow_event(arg_5_0._unit, "on_puzzle_completed")
end

function PuzzleExtensionBase.destroy(arg_6_0)
	return
end
