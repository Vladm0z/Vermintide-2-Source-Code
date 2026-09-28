-- chunkname: @scripts/unit_extensions/mutator_items/mutator_item_spawner_extension.lua

MutatorItemSpawnerExtension = class(MutatorItemSpawnerExtension)

MutatorItemSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data, is_server)
	-- function 1
	self.world = extension_init_context.world
	self.unit = unit
	self.is_server = is_server
end

MutatorItemSpawnerExtension.destroy = function (self)
	-- function 2
	return
end
