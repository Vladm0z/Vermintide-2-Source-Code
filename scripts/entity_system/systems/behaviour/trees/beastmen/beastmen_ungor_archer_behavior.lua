-- chunkname: @scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_ungor_archer_behavior.lua

local beastmen_ungor_archer = BreedActions.beastmen_ungor_archer
local tbl = {
	"BTUtilityNode",
	{
		"BTFindRangedPositionAction",
		name = "find_ranged_position",
		action_data = beastmen_ungor_archer.find_ranged_position
	},
	{
		"BTMoveToRangedPositionAction",
		name = "move_to_ranged_position",
		action_data = beastmen_ungor_archer.move_to_ranged_position
	},
	{
		"BTFireProjectileAction",
		name = "fire_projectile",
		weight = 2,
		action_data = beastmen_ungor_archer.fire_projectile
	},
	condition = "confirmed_player_sighting",
	name = "in_combat"
}
local tbl_2 = {
	"BTUtilityNode",
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = beastmen_ungor_archer.follow
	},
	{
		"BTAttackAction",
		name = "running_attack",
		condition = "ask_target_before_attacking",
		action_data = beastmen_ungor_archer.running_attack
	},
	{
		"BTAttackAction",
		name = "normal_attack",
		condition = "ask_target_before_attacking",
		action_data = beastmen_ungor_archer.normal_attack
	},
	{
		"BTCombatShoutAction",
		name = "combat_shout",
		action_data = beastmen_ungor_archer.combat_shout
	},
	condition = "ungor_archer_enter_melee_combat",
	name = "in_combat"
}
local tbl_3 = {
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
		action_data = beastmen_ungor_archer.smash_door
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
		action_data = beastmen_ungor_archer.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = beastmen_ungor_archer.blocked
	},
	{
		"BTSwitchWeaponsAction",
		name = "switch_weapons",
		condition = "switch_to_melee_weapon",
		action_data = beastmen_ungor_archer.switch_weapons
	},
	tbl_3,
	tbl_2,
	tbl,
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = beastmen_ungor_archer.follow
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = beastmen_ungor_archer.alerted
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
