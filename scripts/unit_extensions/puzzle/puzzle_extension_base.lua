-- chunkname: @scripts/unit_extensions/puzzle/puzzle_extension_base.lua

PuzzleExtensionBase = class(PuzzleExtensionBase)

PuzzleExtensionBase.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._puzzle_group = Unit.get_data(arg_1_2, "puzzle_group")
	self._optional_order_id = tonumber(Unit.get_data(arg_1_2, "puzzle_order_id"))

	fassert(self._puzzle_group, "Unit '%s' is missing puzzle group", arg_1_2)
	fassert(self:puzzle_value(), "Unit '%s' does not expose 'puzzle_value' as an External Output or script_data", arg_1_2)
end

PuzzleExtensionBase.puzzle_group_id = function (self)
	-- function 2
	return self._puzzle_group
end

PuzzleExtensionBase.puzzle_value = function (self)
	-- function 3
	return tostring(Unit.get_data(self._unit, "puzzle_value"))
end

PuzzleExtensionBase.order_id = function (self)
	-- function 4
	return self._optional_order_id
end

PuzzleExtensionBase.on_puzzle_completed = function (self, arg_5_1)
	-- function 5
	Unit.set_flow_variable(self._unit, "completed_puzzle_name", arg_5_1)
	Unit.flow_event(self._unit, "on_puzzle_completed")
end

PuzzleExtensionBase.destroy = function (arg_6_0)
	-- function 6
	return
end
