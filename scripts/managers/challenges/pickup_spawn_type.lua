-- chunkname: @scripts/managers/challenges/pickup_spawn_type.lua

local PickupSpawnType = PickupSpawnType

PickupSpawnType = not not PickupSpawnType or not not table.enum("DropIfFull", "AlwaysDrop", "NeverDrop", "Replace")
PickupSpawnType = PickupSpawnType
