-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_stormfiend_boss_behavior.lua

local var_0_0 = BreedActions.skaven_stormfiend_boss

BreedBehaviors.stormfiend_boss = {
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
			leave_hook = "stormfiend_boss_jump_down_leave",
			name = "climb",
			condition = "at_climb_smartobject",
			action_data = var_0_0.climb
		},
		{
			"BTJumpAcrossAction",
			condition = "at_jump_smartobject",
			name = "jump_across"
		},
		condition = "stormfiend_boss_intro_jump_down",
		name = "smartobject"
	},
	{
		"BTMountUnitAction",
		leave_hook = "stormfiend_boss_mount_leave",
		name = "mount_unit",
		condition = "should_mount_unit",
		action_data = var_0_0.mount_unit
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = var_0_0.pick_up_grey_seer
	},
	{
		"BTStormfiendDualShootAction",
		name = "dual_shoot_intro",
		leave_hook = "stormfiend_boss_rage_leave",
		condition = "stormfiend_boss_rage",
		enter_hook = "rage_on_enter",
		action_data = var_0_0.dual_shoot_intro
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
			"BTUtilityNode",
			{
				"BTBossFollowAction",
				name = "follow",
				action_data = var_0_0.follow
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "melee_shove",
				action_data = var_0_0.melee_shove
			},
			{
				"BTStormfiendShootAction",
				name = "shoot",
				action_data = var_0_0.shoot
			},
			{
				"BTMeleeOverlapAttackAction",
				enter_hook = "stormfiend_boss_charge_enter",
				name = "charge",
				action_data = var_0_0.charge
			},
			{
				"BTChampionAttackAction",
				name = "special_attack_aoe",
				action_data = var_0_0.special_attack_aoe
			},
			{
				"BTTargetUnreachableAction",
				name = "target_unreachable",
				action_data = var_0_0.target_unreachable
			},
			name = "in_combat"
		},
		condition = "can_see_player",
		name = "has_target"
	},
	{
		"BTIdleAction",
		name = "idle"
	},
	name = "stormfiend_boss"
}
