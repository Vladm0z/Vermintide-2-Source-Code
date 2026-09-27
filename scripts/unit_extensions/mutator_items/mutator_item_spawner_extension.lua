-- chunkname: @scripts/unit_extensions/mutator_items/mutator_item_spawner_extension.lua

MutatorItemSpawnerExtension = class(MutatorItemSpawnerExtension)

MutatorItemSpawnerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.is_server = arg_1_4
end

MutatorItemSpawnerExtension.destroy = function (arg_2_0)
	-- function 2
	return
end
