-- chunkname: @scripts/unit_extensions/pickups/pickup_spawner_extension.lua

PickupSpawnerExtension = class(PickupSpawnerExtension)

PickupSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.world = extension_init_context.world
	self.unit = unit
end

PickupSpawnerExtension.extensions_ready = function (self)
	-- function 2
	return
end

PickupSpawnerExtension.get_spawn_location_data = function (self)
	-- function 3
	local position = Unit.world_position(self.unit, 0)
	local rotation = Unit.world_rotation(self.unit, 0)

	return position, rotation, true
end
