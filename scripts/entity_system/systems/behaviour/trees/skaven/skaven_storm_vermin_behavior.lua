-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_storm_vermin_behavior.lua

local skaven_storm_vermin = BreedActions.skaven_storm_vermin
local skaven_storm_vermin_with_shield = BreedActions.skaven_storm_vermin_with_shield
local tbl = {
	"BTSelector",
	{
		"BTClanRatFollowAction",
		name = "move_to_destructible",
		action_data = skaven_storm_vermin.follow
	},
	{
		"BTStormVerminAttackAction",
		name = "cleave_destructible",
		action_data = skaven_storm_vermin.special_attack_cleave
	},
	condition = "has_destructible_as_target",
	name = "combat_destructible"
}
local tbl_2 = {
	"BTUtilityNode",
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = skaven_storm_vermin.follow
	},
	{
		"BTRandom",
		action_data = skaven_storm_vermin.running_attack,
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "running_special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = skaven_storm_vermin.special_attack_sweep
		},
		name = "running_attack"
	},
	{
		"BTRandom",
		action_data = skaven_storm_vermin.special_attack,
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "special_attack_cleave",
			condition = "ask_target_before_attacking",
			action_data = skaven_storm_vermin.special_attack_cleave
		},
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = skaven_storm_vermin.special_attack_sweep
		},
		name = "special_attack"
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		condition = "ask_target_before_attacking",
		action_data = skaven_storm_vermin.push_attack
	},
	{
		"BTCombatShoutAction",
		name = "combat_shout",
		action_data = skaven_storm_vermin.combat_shout
	},
	condition = "confirmed_player_sighting",
	name = "in_combat"
}
local tbl_3 = {
	"BTUtilityNode",
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = skaven_storm_vermin_with_shield.follow
	},
	{
		"BTRandom",
		action_data = skaven_storm_vermin_with_shield.special_attack,
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = skaven_storm_vermin_with_shield.special_attack_sweep
		},
		name = "special_attack"
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		condition = "ask_target_before_attacking",
		action_data = skaven_storm_vermin_with_shield.push_attack
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack_wake_up",
		condition = "ask_target_before_attacking",
		action_data = skaven_storm_vermin_with_shield.push_attack_wake_up
	},
	{
		"BTComboAttackAction",
		name = "frenzy_attack_ranged",
		condition = "ask_target_before_attacking",
		action_data = skaven_storm_vermin_with_shield.frenzy_attack_ranged
	},
	{
		"BTComboAttackAction",
		name = "frenzy_attack",
		condition = "ask_target_before_attacking",
		action_data = skaven_storm_vermin_with_shield.frenzy_attack
	},
	{
		"BTCombatShoutAction",
		name = "combat_shout",
		action_data = skaven_storm_vermin_with_shield.combat_shout
	},
	condition = "confirmed_player_sighting",
	name = "in_combat"
}
local tbl_4 = {
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
		action_data = skaven_storm_vermin.smash_door
	},
	condition = "at_smartobject",
	name = "smartobject"
}

BreedBehaviors.storm_vermin = {
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
		action_data = skaven_storm_vermin.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = skaven_storm_vermin.blocked
	},
	tbl_4,
	tbl_2,
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = skaven_storm_vermin.follow
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = skaven_storm_vermin.alerted
	},
	{
		"BTIdleAction",
		condition = "no_target",
		name = "idle"
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "storm_vermin"
}
BreedBehaviors.storm_vermin_commander = {
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
		action_data = skaven_storm_vermin.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = skaven_storm_vermin.blocked
	},
	tbl_4,
	tbl,
	tbl_2,
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = skaven_storm_vermin.follow
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = skaven_storm_vermin.alerted
	},
	{
		"BTIdleAction",
		condition = "no_target",
		name = "idle"
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "horde"
}
BreedBehaviors.horde_vermin = {
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
		action_data = skaven_storm_vermin.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = skaven_storm_vermin.blocked
	},
	tbl_4,
	tbl,
	tbl_2,
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = skaven_storm_vermin.follow
	},
	{
		"BTIdleAction",
		condition = "no_target",
		name = "idle"
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "horde"
}
BreedBehaviors.shield_vermin = {
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
		action_data = skaven_storm_vermin_with_shield.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = skaven_storm_vermin_with_shield.blocked
	},
	tbl_4,
	tbl_3,
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = skaven_storm_vermin_with_shield.follow
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = skaven_storm_vermin_with_shield.alerted
	},
	{
		"BTIdleAction",
		condition = "no_target",
		name = "idle"
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "shield_vermin"
}
