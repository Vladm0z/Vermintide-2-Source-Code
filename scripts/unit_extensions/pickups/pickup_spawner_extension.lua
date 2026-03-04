-- chunkname: @scripts/unit_extensions/pickups/pickup_spawner_extension.lua

PickupSpawnerExtension = class(PickupSpawnerExtension)

function PickupSpawnerExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
end

function PickupSpawnerExtension.extensions_ready(arg_2_0)
	return
end

function PickupSpawnerExtension.get_spawn_location_data(arg_3_0)
	local var_3_0 = Unit.world_position(arg_3_0.unit, 0)
	local var_3_1 = Unit.world_rotation(arg_3_0.unit, 0)

	return var_3_0, var_3_1, true
end
