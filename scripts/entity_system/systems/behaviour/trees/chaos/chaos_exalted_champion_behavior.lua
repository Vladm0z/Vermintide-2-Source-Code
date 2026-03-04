-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_exalted_champion_behavior.lua

local var_0_0 = BreedActions.chaos_exalted_champion
local var_0_1 = {
	"BTUtilityNode",
	{
		"BTSequence",
		action_data = var_0_0.spawn_sequence,
		{
			"BTChampionAttackAction",
			name = "special_attack_aoe",
			action_data = var_0_0.special_attack_aoe_defensive
		},
		{
			"BTSpawnAllies",
			name = "spawn_allies",
			action_data = var_0_0.spawn_allies
		},
		name = "spawn_sequence"
	},
	{
		"BTSequence",
		action_data = var_0_0.angry_charge_sequence,
		{
			"BTMeleeOverlapAttackAction",
			name = "angry_charge",
			action_data = var_0_0.angry_charge
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "angry_charge",
			action_data = var_0_0.angry_charge
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "angry_charge",
			action_data = var_0_0.angry_charge
		},
		name = "angry_charge_sequence"
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = var_0_0.follow
	},
	{
		"BTThrowWeaponAction",
		name = "throw_weapon",
		action_data = var_0_0.throw_weapon
	},
	{
		"BTMeleeOverlapAttackAction",
		name = "charge",
		action_data = var_0_0.charge
	},
	{
		"BTChampionAttackAction",
		name = "special_attack_aoe",
		action_data = var_0_0.special_attack_aoe
	},
	{
		"BTStormVerminAttackAction",
		enter_hook = "keep_target",
		name = "special_attack_cleave",
		leave_hook = "reset_keep_target",
		action_data = var_0_0.special_attack_cleave
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_sweep",
		action_data = var_0_0.special_attack_sweep
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_launch",
		action_data = var_0_0.special_attack_launch
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_kick",
		action_data = var_0_0.special_attack_kick
	},
	condition = "can_see_player",
	name = "in_combat"
}
local var_0_2 = {
	"BTUtilityNode",
	{
		"BTChampionAttackAction",
		name = "special_attack_aoe_defensive",
		action_data = var_0_0.special_attack_aoe_defensive
	},
	{
		"BTThrowWeaponAction",
		name = "throw_weapon",
		action_data = var_0_0.throw_weapon
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_launch_defensive",
		action_data = var_0_0.special_attack_launch_defensive
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_kick",
		action_data = var_0_0.special_attack_kick
	},
	condition = "should_be_defensive",
	name = "in_defensive"
}
local var_0_3 = {
	"BTUtilityNode",
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = var_0_0.follow
	},
	{
		"BTMeleeOverlapAttackAction",
		name = "norsca_charge",
		action_data = var_0_0.norsca_charge
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_cleave",
		action_data = var_0_0.special_attack_cleave
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_sweep",
		action_data = var_0_0.special_attack_sweep
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_launch",
		action_data = var_0_0.special_attack_launch
	},
	condition = "can_see_player",
	name = "in_combat"
}
local var_0_4 = {
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

BreedBehaviors.chaos_exalted_champion_warcamp = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
	},
	{
		"BTSelector",
		action_data = var_0_0.intro_sequence,
		{
			"BTMoveToGoalAction",
			name = "move_to_goal",
			condition = "has_goal_destination",
			action_data = var_0_0.follow
		},
		{
			"BTIdleAction",
			name = "intro_idle",
			action_data = var_0_0.intro_idle
		},
		name = "intro_sequence",
		leave_hook = "on_lord_intro_leave",
		condition = "lord_intro",
		enter_hook = "on_chaos_exalted_champion_intro_enter"
	},
	{
		"BTFallAction",
		condition = "is_falling",
		name = "falling"
	},
	var_0_4,
	{
		"BTChampionAttackAction",
		leave_hook = "reset_chain_stagger",
		name = "retaliation_aoe",
		condition = "warcamp_retaliation_aoe",
		action_data = var_0_0.special_attack_retaliation_aoe
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = var_0_0.stagger
	},
	var_0_2,
	var_0_1,
	{
		"BTIdleAction",
		name = "defensive_idle",
		action_data = var_0_0.defensive_idle
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
BreedBehaviors.chaos_exalted_champion_norsca = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
	},
	{
		"BTFallAction",
		condition = "is_falling",
		name = "falling"
	},
	{
		"BTTransformAction",
		name = "transform",
		condition = "boss_phase_two",
		action_data = var_0_0.transform
	},
	var_0_4,
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = var_0_0.stagger
	},
	var_0_3,
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
