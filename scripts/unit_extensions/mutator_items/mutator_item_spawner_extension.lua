-- chunkname: @scripts/unit_extensions/mutator_items/mutator_item_spawner_extension.lua

MutatorItemSpawnerExtension = class(MutatorItemSpawnerExtension)

MutatorItemSpawnerExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = arg_1_4
end

MutatorItemSpawnerExtension.destroy = function (arg_2_0)
	return
end
