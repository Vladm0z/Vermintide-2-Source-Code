-- chunkname: @scripts/unit_extensions/generic/generic_trail_extension.lua

GenericTrailExtension = class(GenericTrailExtension)

GenericTrailExtension.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.unit = arg_1_2

	Unit.flow_event(arg_1_2, "lua_trail")
end
