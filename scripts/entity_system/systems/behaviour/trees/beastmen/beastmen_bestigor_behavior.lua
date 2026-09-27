-- chunkname: @scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_bestigor_behavior.lua

local beastmen_bestigor = BreedActions.beastmen_bestigor
local tbl = {
	"BTUtilityNode",
	action_data = beastmen_bestigor.utility_action,
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = beastmen_bestigor.follow
	},
	{
		"BTCombatStepAction",
		name = "combat_step",
		action_data = beastmen_bestigor.combat_step
	},
	{
		"BTChargeAttackAction",
		name = "charge_attack",
		condition = "ask_target_before_attacking",
		action_data = beastmen_bestigor.charge_attack
	},
	{
		"BTRandom",
		action_data = beastmen_bestigor.running_attack,
		{
			"BTStormVerminAttackAction",
			name = "running_special_attack_sweep",
			weight = 1,
			action_data = beastmen_bestigor.special_attack_sweep
		},
		name = "running_attack"
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_cleave",
		condition = "ask_target_before_attacking",
		action_data = beastmen_bestigor.special_attack_cleave
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_sweep",
		condition = "ask_target_before_attacking",
		action_data = beastmen_bestigor.special_attack_sweep
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		action_data = beastmen_bestigor.push_attack
	},
	{
		"BTCombatShoutAction",
		name = "combat_shout",
		action_data = beastmen_bestigor.combat_shout
	},
	name = "in_combat",
	condition = "confirmed_player_sighting"
}
local tbl_2 = {
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
		action_data = beastmen_bestigor.smash_door
	},
	condition = "bestigor_at_smartobject",
	name = "smartobject"
}

BreedBehaviors.bestigor = {
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
		"BTInGravityWellAction",
		condition = "in_gravity_well",
		name = "in_gravity_well"
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
		action_data = beastmen_bestigor.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = beastmen_bestigor.blocked
	},
	tbl_2,
	tbl,
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = beastmen_bestigor.follow
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = beastmen_bestigor.alerted
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
	name = "bestigor"
}
