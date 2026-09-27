-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_shield_rat_behavior.lua

local skaven_clan_rat_with_shield = BreedActions.skaven_clan_rat_with_shield

BreedBehaviors.shield_rat = {
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
		action_data = skaven_clan_rat_with_shield.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = skaven_clan_rat_with_shield.blocked
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
			name = "climb",
			condition = "at_climb_smartobject",
			action_data = skaven_clan_rat_with_shield.climb
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
			action_data = skaven_clan_rat_with_shield.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTHesitateAction",
		name = "hesitate",
		condition = "is_alerted",
		action_data = skaven_clan_rat_with_shield.alerted
	},
	{
		"BTUtilityNode",
		action_data = skaven_clan_rat_with_shield.utility_action,
		{
			"BTClanRatFollowAction",
			name = "follow",
			action_data = skaven_clan_rat_with_shield.follow
		},
		{
			"BTAttackAction",
			name = "running_attack",
			condition = "ask_target_before_attacking",
			action_data = skaven_clan_rat_with_shield.running_attack
		},
		{
			"BTAttackAction",
			name = "normal_attack",
			condition = "ask_target_before_attacking",
			action_data = skaven_clan_rat_with_shield.normal_attack
		},
		{
			"BTCombatShoutAction",
			name = "combat_shout",
			action_data = skaven_clan_rat_with_shield.combat_shout
		},
		name = "in_combat",
		condition = "confirmed_player_sighting"
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = skaven_clan_rat_with_shield.alerted
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = skaven_clan_rat_with_shield.follow
	},
	{
		"BTSequence",
		{
			"BTInterestPointChooseAction",
			name = "interest_point_choose",
			action_data = skaven_clan_rat_with_shield.interest_point_choose
		},
		{
			"BTInterestPointApproachAction",
			name = "interest_point_approach"
		},
		{
			"BTInterestPointUseAction",
			name = "interest_point_use",
			action_data = skaven_clan_rat_with_shield.interest_point_choose
		},
		condition = "should_use_interest_point",
		name = "interest_point"
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
	name = "shield_rat"
}
