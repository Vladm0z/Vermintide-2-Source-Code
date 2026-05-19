-- chunkname: @scripts/unit_extensions/mutator_items/mutator_item_spawner_extension.lua

MutatorItemSpawnerExtension = class(MutatorItemSpawnerExtension)

function MutatorItemSpawnerExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = arg_1_4
end

function MutatorItemSpawnerExtension.destroy(arg_2_0)
	return
end
