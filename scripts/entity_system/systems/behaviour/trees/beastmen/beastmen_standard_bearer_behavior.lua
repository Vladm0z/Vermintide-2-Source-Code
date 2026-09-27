-- chunkname: @scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_standard_bearer_behavior.lua

local beastmen_standard_bearer = BreedActions.beastmen_standard_bearer
local tbl = {
	"BTUtilityNode",
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = beastmen_standard_bearer.follow
	},
	{
		"BTRandom",
		action_data = beastmen_standard_bearer.running_attack,
		{
			"BTStormVerminAttackAction",
			name = "running_special_attack_sweep",
			weight = 1,
			action_data = beastmen_standard_bearer.special_attack_sweep
		},
		name = "running_attack"
	},
	{
		"BTRandom",
		action_data = beastmen_standard_bearer.special_attack,
		{
			"BTStormVerminAttackAction",
			name = "special_attack_cleave",
			weight = 1,
			action_data = beastmen_standard_bearer.special_attack_cleave
		},
		{
			"BTStormVerminAttackAction",
			name = "special_attack_sweep",
			weight = 1,
			action_data = beastmen_standard_bearer.special_attack_sweep
		},
		name = "special_attack"
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		action_data = beastmen_standard_bearer.push_attack
	},
	{
		"BTCombatShoutAction",
		name = "combat_shout",
		action_data = beastmen_standard_bearer.combat_shout
	},
	condition = "confirmed_player_sighting_standard_bearer",
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
		action_data = beastmen_standard_bearer.smash_door
	},
	condition = "at_smartobject",
	name = "smartobject"
}
local tbl_3 = {
	"BTSelector",
	{
		"BTMoveToGoalAction",
		enter_hook = "add_invincibility",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = beastmen_standard_bearer.follow
	},
	{
		"BTPlaceStandardAction",
		name = "place_standard_stagger_immune",
		leave_hook = "beastmen_standard_bearer_leave_move_and_plant_standard",
		action_data = beastmen_standard_bearer.place_standard_stagger_immune
	},
	condition = "beastmen_standard_bearer_move_and_place_standard",
	name = "move_and_place_standard"
}

BreedBehaviors.standard_bearer = {
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
		"BTSwitchWeaponsAction",
		name = "switch_weapons",
		condition = "switching_weapons",
		action_data = beastmen_standard_bearer.switch_weapons
	},
	tbl_2,
	tbl_3,
	{
		"BTPickupStandardAction",
		name = "pick_up_standard",
		condition = "beastmen_standard_bearer_pickup_standard",
		action_data = beastmen_standard_bearer.pick_up_standard
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = beastmen_standard_bearer.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = beastmen_standard_bearer.blocked
	},
	{
		"BTUtilityNode",
		{
			"BTClanRatFollowAction",
			name = "place_standard_follow",
			action_data = beastmen_standard_bearer.place_standard_follow
		},
		{
			"BTPlaceStandardAction",
			name = "place_standard",
			action_data = beastmen_standard_bearer.place_standard
		},
		condition = "beastmen_standard_bearer_place_standard",
		name = "enemy_spotted"
	},
	{
		"BTDefendStandardAction",
		condition = "standard_bearer_should_be_defensive",
		name = "defend_standard"
	},
	tbl,
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = beastmen_standard_bearer.follow
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = beastmen_standard_bearer.alerted
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
	name = "standard_bearer"
}
