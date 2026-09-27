-- chunkname: @scripts/entity_system/systems/whereabouts/whereabouts_system.lua

WhereaboutsSystem = class(WhereaboutsSystem, ExtensionSystemBase)

local tbl = {
	"PlayerWhereaboutsExtension",
	"LureWhereaboutsExtension"
}

WhereaboutsSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	WhereaboutsSystem.super.init(arg_1_0, arg_1_1, arg_1_2, tbl)

	local world = arg_1_1.world
end

WhereaboutsSystem.destroy = function (arg_2_0)
	-- function 2
	return
end

WhereaboutsSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return (WhereaboutsSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4))
end

WhereaboutsSystem.extensions_ready = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	return
end

WhereaboutsSystem.hot_join_sync = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

WhereaboutsSystem.update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	WhereaboutsSystem.super.update(arg_6_0, arg_6_1, arg_6_2)
end
