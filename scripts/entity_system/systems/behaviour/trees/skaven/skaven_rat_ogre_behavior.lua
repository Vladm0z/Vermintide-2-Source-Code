-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_rat_ogre_behavior.lua

local var_0_0 = BreedActions.skaven_rat_ogre

BreedBehaviors.ogre = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
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
			action_data = var_0_0.climb
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
		condition = "ratogre_at_smartobject",
		name = "smartobject"
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
			"BTMeleeOverlapAttackAction",
			leave_hook = "reset_fling_skaven",
			name = "fling_skaven",
			condition = "fling_skaven",
			action_data = var_0_0.fling_skaven
		},
		{
			"BTTargetRageAction",
			name = "target_rage",
			condition = "target_changed",
			action_data = var_0_0.target_rage
		},
		{
			"BTUtilityNode",
			{
				"BTBossFollowAction",
				name = "follow",
				action_data = var_0_0.follow
			},
			{
				"BTMeleeSlamAction",
				name = "melee_slam",
				action_data = var_0_0.melee_slam
			},
			{
				"BTMeleeSlamAction",
				name = "anti_ladder_melee_slam",
				action_data = var_0_0.anti_ladder_melee_slam
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "melee_shove",
				action_data = var_0_0.melee_shove
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "combo_attack",
				action_data = var_0_0.combo_attack
			},
			{
				"BTSequence",
				action_data = var_0_0.jump_slam,
				{
					"BTPrepareJumpSlamAction",
					name = "prepare_jump_slam"
				},
				{
					"BTJumpSlamAction",
					name = "attack_jump",
					action_data = var_0_0.jump_slam
				},
				{
					"BTJumpSlamImpactAction",
					name = "jump_slam_impact",
					action_data = var_0_0.jump_slam_impact
				},
				name = "jump_slam"
			},
			condition = "ratogre_target_reachable",
			name = "in_combat"
		},
		{
			"BTTargetUnreachableAction",
			name = "target_unreachable",
			action_data = var_0_0.target_unreachable
		},
		condition = "can_see_player",
		name = "has_target"
	},
	{
		"BTRatOgreWalkAction",
		name = "walking",
		condition = "ratogre_walking",
		action_data = var_0_0.walking
	},
	{
		"BTIdleAction",
		name = "idle"
	},
	name = "rat_ogre"
}
