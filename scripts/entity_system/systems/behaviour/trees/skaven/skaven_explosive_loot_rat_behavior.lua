-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_explosive_loot_rat_behavior.lua

local var_0_0 = BreedActions.skaven_explosive_loot_rat
local var_0_1 = {
	"BTUtilityNode",
	action_data = var_0_0.utility_action,
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = var_0_0.follow
	},
	{
		"BTZombieExplodeAction",
		name = "explosion_attack",
		action_data = var_0_0.explosion_attack
	},
	name = "in_combat",
	condition = "can_see_player"
}

BreedBehaviors.explosive_loot_rat = {
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
		condition = "stagger",
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
	var_0_1,
	{
		"BTIdleAction",
		name = "idle",
		condition = "no_target",
		action_data = var_0_0.idle
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "horde"
}
