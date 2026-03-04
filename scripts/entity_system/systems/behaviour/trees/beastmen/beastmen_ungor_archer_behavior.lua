-- chunkname: @scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_ungor_archer_behavior.lua

local var_0_0 = BreedActions.beastmen_ungor_archer
local var_0_1 = {
	"BTUtilityNode",
	{
		"BTFindRangedPositionAction",
		name = "find_ranged_position",
		action_data = var_0_0.find_ranged_position
	},
	{
		"BTMoveToRangedPositionAction",
		name = "move_to_ranged_position",
		action_data = var_0_0.move_to_ranged_position
	},
	{
		"BTFireProjectileAction",
		name = "fire_projectile",
		weight = 2,
		action_data = var_0_0.fire_projectile
	},
	condition = "confirmed_player_sighting",
	name = "in_combat"
}
local var_0_2 = {
	"BTUtilityNode",
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = var_0_0.follow
	},
	{
		"BTAttackAction",
		name = "running_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.running_attack
	},
	{
		"BTAttackAction",
		name = "normal_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.normal_attack
	},
	{
		"BTCombatShoutAction",
		name = "combat_shout",
		action_data = var_0_0.combat_shout
	},
	condition = "ungor_archer_enter_melee_combat",
	name = "in_combat"
}
local var_0_3 = {
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
}

BreedBehaviors.ungor_archer = {
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
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = var_0_0.blocked
	},
	{
		"BTSwitchWeaponsAction",
		name = "switch_weapons",
		condition = "switch_to_melee_weapon",
		action_data = var_0_0.switch_weapons
	},
	var_0_3,
	var_0_2,
	var_0_1,
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = var_0_0.follow
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = var_0_0.alerted
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
	name = "ungor_archer"
}
