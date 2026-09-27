-- chunkname: @scripts/unit_extensions/pickups/pickup_spawner_extension.lua

PickupSpawnerExtension = class(PickupSpawnerExtension)

PickupSpawnerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
end

PickupSpawnerExtension.extensions_ready = function (arg_2_0)
	-- function 2
	return
end

PickupSpawnerExtension.get_spawn_location_data = function (self)
	-- function 3
	local world_position = Unit.world_position(self.unit, 0)
	local world_rotation = Unit.world_rotation(self.unit, 0)

	return world_position, world_rotation, true
end
