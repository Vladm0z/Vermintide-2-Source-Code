-- chunkname: @scripts/entity_system/systems/aggro/aggro_system.lua

AggroSystem = class(AggroSystem, ExtensionSystemBase)

local var_0_0 = {
	"GenericAggroableExtension"
}

AggroSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	AggroSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0.aggroable_units = {
		[0] = {}
	}

	local var_1_0 = Managers.state.side:sides()

	for iter_1_0 = 1, #var_1_0 do
		arg_1_0.aggroable_units[iter_1_0] = {}
	end

	arg_1_0._reverse_lookup = {}
end

AggroSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = (arg_2_4.side or Managers.state.side:get_side_from_name("heroes")).side_id

	arg_2_0.aggroable_units[var_2_0][arg_2_2] = true
	arg_2_0._reverse_lookup[arg_2_2] = var_2_0

	local var_2_1, var_2_2 = Managers.state.network:game_object_or_level_id(arg_2_2)

	if var_2_2 then
		POSITION_LOOKUP[arg_2_2] = Unit.world_position(arg_2_2, 0)
	end

	return AggroSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
end

AggroSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	AggroSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)

	local var_3_0 = arg_3_0._reverse_lookup[arg_3_1]

	arg_3_0.aggroable_units[var_3_0][arg_3_1] = nil
	arg_3_0._reverse_lookup[arg_3_1] = nil

	Managers.state.side:remove_aggro_unit(var_3_0, arg_3_1)
end

AggroSystem.destroy = function (arg_4_0)
	AggroSystem.super.destroy(arg_4_0)

	arg_4_0.aggroable_units = nil
end
