-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_explosive_loot_rat_behavior.lua

local skaven_explosive_loot_rat = BreedActions.skaven_explosive_loot_rat
local tbl = {
	"BTUtilityNode",
	action_data = skaven_explosive_loot_rat.utility_action,
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = skaven_explosive_loot_rat.follow
	},
	{
		"BTZombieExplodeAction",
		name = "explosion_attack",
		action_data = skaven_explosive_loot_rat.explosion_attack
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
		action_data = skaven_explosive_loot_rat.stagger
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
			action_data = skaven_explosive_loot_rat.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	tbl,
	{
		"BTIdleAction",
		name = "idle",
		condition = "no_target",
		action_data = skaven_explosive_loot_rat.idle
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "horde"
}
