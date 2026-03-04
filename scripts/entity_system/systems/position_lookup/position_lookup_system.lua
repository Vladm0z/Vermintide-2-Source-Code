-- chunkname: @scripts/entity_system/systems/position_lookup/position_lookup_system.lua

PositionLookupSystem = class(PositionLookupSystem, ExtensionSystemBase)

local var_0_0 = {
	"PositionLookupExtension"
}

PositionLookupSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	PositionLookupSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)
end

PositionLookupSystem.update = function (arg_2_0)
	return
end

PositionLookupSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	fassert(arg_3_0.extensions[arg_3_3], "[PositionLookupSystem] There is no known extension called %s", arg_3_3)

	POSITION_LOOKUP[arg_3_2] = Unit.world_position(arg_3_2, 0)

	local var_3_0 = {
		position = POSITION_LOOKUP[arg_3_2]
	}

	ScriptUnit.set_extension(arg_3_2, arg_3_0.NAME, var_3_0)

	return var_3_0
end

PositionLookupSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	fassert(arg_4_0.extensions[arg_4_2], "[PositionLookupSystem] There is no known extension called %s", arg_4_2)

	POSITION_LOOKUP[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, arg_4_0.NAME)
end

PositionLookupSystem.destroy = function (arg_5_0)
	return
end
