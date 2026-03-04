-- chunkname: @scripts/entity_system/systems/whereabouts/whereabouts_system.lua

WhereaboutsSystem = class(WhereaboutsSystem, ExtensionSystemBase)

local var_0_0 = {
	"PlayerWhereaboutsExtension",
	"LureWhereaboutsExtension"
}

function WhereaboutsSystem.init(arg_1_0, arg_1_1, arg_1_2)
	WhereaboutsSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	local var_1_0 = arg_1_1.world
end

function WhereaboutsSystem.destroy(arg_2_0)
	return
end

function WhereaboutsSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return (WhereaboutsSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4))
end

function WhereaboutsSystem.extensions_ready(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	return
end

function WhereaboutsSystem.hot_join_sync(arg_5_0, arg_5_1, arg_5_2)
	return
end

function WhereaboutsSystem.update(arg_6_0, arg_6_1, arg_6_2)
	WhereaboutsSystem.super.update(arg_6_0, arg_6_1, arg_6_2)
end
