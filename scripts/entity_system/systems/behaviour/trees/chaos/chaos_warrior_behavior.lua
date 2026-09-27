-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_warrior_behavior.lua

local chaos_warrior = BreedActions.chaos_warrior
local tbl = {
	"BTUtilityNode",
	{
		"BTCombatStepAction",
		name = "combat_step",
		action_data = chaos_warrior.combat_step
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = chaos_warrior.follow
	},
	{
		"BTStormVerminAttackAction",
		name = "running_attack_right",
		condition = "ask_target_before_attacking",
		action_data = chaos_warrior.running_attack_right
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_cleave",
		condition = "ask_target_before_attacking",
		action_data = chaos_warrior.special_attack_cleave
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_sweep",
		condition = "ask_target_before_attacking",
		action_data = chaos_warrior.special_attack_sweep
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_launch",
		condition = "ask_target_before_attacking",
		action_data = chaos_warrior.special_attack_launch
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		condition = "ask_target_before_attacking",
		action_data = chaos_warrior.push_attack
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_quick",
		condition = "ask_target_before_attacking",
		action_data = chaos_warrior.special_attack_quick
	},
	condition = "confirmed_player_sighting",
	name = "in_combat"
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
		action_data = chaos_warrior.smash_door
	},
	condition = "at_smartobject",
	name = "smartobject"
}

BreedBehaviors.chaos_warrior = {
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
		action_data = chaos_warrior.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = chaos_warrior.blocked
	},
	tbl_2,
	tbl,
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = chaos_warrior.alerted
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = chaos_warrior.follow
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
