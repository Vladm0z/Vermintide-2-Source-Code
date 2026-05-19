-- chunkname: @scripts/unit_extensions/generic/generic_trail_extension.lua

GenericTrailExtension = class(GenericTrailExtension)

function GenericTrailExtension.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.unit = arg_1_2

	Unit.flow_event(arg_1_2, "lua_trail")
end
