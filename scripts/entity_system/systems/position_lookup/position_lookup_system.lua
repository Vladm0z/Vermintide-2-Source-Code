-- chunkname: @scripts/entity_system/systems/position_lookup/position_lookup_system.lua

PositionLookupSystem = class(PositionLookupSystem, ExtensionSystemBase)

local tbl = {
	"PositionLookupExtension"
}

PositionLookupSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	PositionLookupSystem.super.init(arg_1_0, arg_1_1, arg_1_2, tbl)
end

PositionLookupSystem.update = function (arg_2_0)
	-- function 2
	return
end

PositionLookupSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	fassert(self.extensions[arg_3_3], "[PositionLookupSystem] There is no known extension called %s", arg_3_3)

	POSITION_LOOKUP[arg_3_2] = Unit.world_position(arg_3_2, 0)

	local tbl = {
		position = POSITION_LOOKUP[arg_3_2]
	}

	ScriptUnit.set_extension(arg_3_2, self.NAME, tbl)

	return tbl
end

PositionLookupSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	fassert(self.extensions[arg_4_2], "[PositionLookupSystem] There is no known extension called %s", arg_4_2)

	POSITION_LOOKUP[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, self.NAME)
end

PositionLookupSystem.destroy = function (arg_5_0)
	-- function 5
	return
end
