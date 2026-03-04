-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_loot_rat_behavior.lua

local var_0_0 = BreedActions.skaven_loot_rat

BreedBehaviors.loot_rat = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
	},
	{
		"BTInVortexAction",
		condition = "in_vortex",
		name = "in_vortex"
	},
	{
		"BTFallAction",
		condition = "is_falling",
		name = "falling"
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "loot_rat_stagger",
		action_data = var_0_0.stagger
	},
	{
		"BTSelector",
		{
			"BTTeleportAction",
			condition = "at_teleport_smartobject",
			name = "teleport"
		},
		{
			"BTClimbAction",
			condition = "at_climb_smartobject",
			name = "climb"
		},
		{
			"BTJumpAcrossAction",
			condition = "at_jump_smartobject",
			name = "jump_across"
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
		"BTLootRatDodgeAction",
		name = "dodge",
		condition = "loot_rat_dodge",
		action_data = var_0_0.dodge
	},
	{
		"BTLootRatFleeAction",
		name = "flee",
		condition = "loot_rat_flee",
		action_data = var_0_0.flee
	},
	{
		"BTLootRatAlertedAction",
		condition = "can_see_player",
		name = "alerted"
	},
	{
		"BTIdleAction",
		name = "idle",
		action_data = var_0_0.idle
	},
	name = "horde"
}
