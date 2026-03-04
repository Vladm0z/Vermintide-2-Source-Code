-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_stormfiend_behavior.lua

local var_0_0 = BreedActions.skaven_stormfiend

BreedBehaviors.stormfiend = {
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
			"BTTargetRageAction",
			enter_hook = "rage_on_enter",
			name = "target_rage",
			condition = "target_changed_and_distant",
			action_data = var_0_0.target_rage
		},
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
				"BTMeleeOverlapAttackAction",
				name = "charge",
				leave_hook = "reset_stormfiend_charge",
				action_data = var_0_0.charge
			},
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
	name = "stormfiend"
}
