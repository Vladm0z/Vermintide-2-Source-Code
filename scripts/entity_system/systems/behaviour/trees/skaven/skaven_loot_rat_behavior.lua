-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_loot_rat_behavior.lua

local skaven_loot_rat = BreedActions.skaven_loot_rat

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
		action_data = skaven_loot_rat.stagger
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
			action_data = skaven_loot_rat.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTLootRatDodgeAction",
		name = "dodge",
		condition = "loot_rat_dodge",
		action_data = skaven_loot_rat.dodge
	},
	{
		"BTLootRatFleeAction",
		name = "flee",
		condition = "loot_rat_flee",
		action_data = skaven_loot_rat.flee
	},
	{
		"BTLootRatAlertedAction",
		condition = "can_see_player",
		name = "alerted"
	},
	{
		"BTIdleAction",
		name = "idle",
		action_data = skaven_loot_rat.idle
	},
	name = "horde"
}
