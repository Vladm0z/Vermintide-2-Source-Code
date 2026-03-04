-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_vortex_behavior.lua

local var_0_0 = BreedActions.chaos_vortex

BreedBehaviors.chaos_vortex = {
	"BTSelector",
	{
		"BTVortexSpawnAction",
		condition = "spawn",
		name = "spawn"
	},
	{
		"BTSelector",
		{
			"BTVortexFlyAction",
			condition = "vortex_at_climb_or_jump",
			name = "fly"
		},
		{
			"BTSmashDoorAction",
			name = "smash_door",
			condition = "at_door_smartobject",
			action_data = var_0_0.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTVortexWanderAction",
		name = "wander"
	},
	name = "chaos_vortex"
}
