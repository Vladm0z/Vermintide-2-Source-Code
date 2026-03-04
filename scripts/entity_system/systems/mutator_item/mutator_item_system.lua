-- chunkname: @scripts/entity_system/systems/mutator_item/mutator_item_system.lua

require("scripts/unit_extensions/mutator_items/mutator_item_spawner_extension")

MutatorItemSystem = class(MutatorItemSystem, ExtensionSystemBase)

local var_0_0 = {}
local var_0_1 = {
	"MutatorItemSpawnerExtension"
}

MutatorItemSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	MutatorItemSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0._spawners = {}
	arg_1_0._spawners_by_name = {}
end

MutatorItemSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
	if arg_2_3 == "MutatorItemSpawnerExtension" then
		local var_2_0 = arg_2_0._spawners

		var_2_0[#var_2_0 + 1] = arg_2_2

		local var_2_1 = Unit.get_data(arg_2_2, "mutator_item_spawner_id")

		arg_2_0._spawners_by_name[var_2_1] = arg_2_2
	end

	return MutatorItemSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
end

local var_0_2 = {}

MutatorItemSystem.spawn_mutator_items = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._spawners
	local var_3_1 = arg_3_0._spawners_by_name

	table.clear(var_0_2)

	if not arg_3_1 then
		return
	end

	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		local var_3_2 = var_3_1[iter_3_0]

		if var_3_2 then
			local var_3_3 = iter_3_1.unit_name
			local var_3_4 = iter_3_1.unit_extension_template
			local var_3_5 = iter_3_1.extension_init_data
			local var_3_6 = Unit.local_position(var_3_2, 0)
			local var_3_7 = Unit.local_rotation(var_3_2, 0)
			local var_3_8 = Managers.state.unit_spawner:spawn_network_unit(var_3_3, var_3_4, var_3_5, var_3_6, var_3_7)

			var_0_2[#var_0_2 + 1] = var_3_8
		end
	end

	return var_0_2
end

MutatorItemSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2, ...)
	return MutatorItemSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2, ...)
end

MutatorItemSystem.update = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0.is_server then
		-- Nothing
	end
end

MutatorItemSystem.destroy = function (arg_6_0)
	arg_6_0.network_event_delegate:unregister(arg_6_0)
end

MutatorItemSystem.hot_join_sync = function (arg_7_0, arg_7_1)
	return
end
