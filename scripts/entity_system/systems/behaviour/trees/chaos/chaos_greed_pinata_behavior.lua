-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_greed_pinata_behavior.lua

local var_0_0 = BreedActions.chaos_greed_pinata

BreedBehaviors.chaos_greed_pinata = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
	},
	{
		"BTSelector",
		{
			"BTTeleportAction",
			name = "teleport",
			condition = "at_teleport_smartobject",
			action_data = var_0_0.teleport
		},
		{
			"BTChaosSorcererTeleportAction",
			name = "climb_teleport",
			condition = "at_climb_smartobject",
			action_data = var_0_0.teleport
		},
		{
			"BTChaosSorcererTeleportAction",
			name = "jump_teleport",
			condition = "at_jump_smartobject",
			action_data = var_0_0.teleport
		},
		{
			"BTChaosSorcererTeleportAction",
			name = "door_teleport",
			condition = "at_door_smartobject",
			action_data = var_0_0.teleport
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTLootRatFleeAction",
		name = "flee",
		action_data = var_0_0.flee
	},
	{
		"BTIdleAction",
		name = "idle",
		action_data = var_0_0.idle
	},
	name = "horde"
}
