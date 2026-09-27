-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_stormfiend_demo_behavior.lua

local skaven_stormfiend_demo = BreedActions.skaven_stormfiend_demo

BreedBehaviors.stormfiend_demo = {
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
			action_data = skaven_stormfiend_demo.climb
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
			action_data = skaven_stormfiend_demo.smash_door
		},
		condition = "ratogre_at_smartobject",
		name = "smartobject"
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = skaven_stormfiend_demo.stagger
	},
	{
		"BTSelector",
		{
			"BTMeleeOverlapAttackAction",
			leave_hook = "reset_fling_skaven",
			name = "fling_skaven",
			condition = "fling_skaven",
			action_data = skaven_stormfiend_demo.fling_skaven
		},
		{
			"BTTargetRageAction",
			enter_hook = "rage_on_enter",
			name = "target_rage",
			condition = "target_changed_and_distant",
			action_data = skaven_stormfiend_demo.target_rage
		},
		{
			"BTUtilityNode",
			{
				"BTBossFollowAction",
				name = "follow",
				action_data = skaven_stormfiend_demo.follow
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "melee_shove",
				action_data = skaven_stormfiend_demo.melee_shove
			},
			{
				"BTStormfiendShootAction",
				name = "shoot",
				action_data = skaven_stormfiend_demo.shoot
			},
			{
				"BTTargetUnreachableAction",
				name = "target_unreachable",
				action_data = skaven_stormfiend_demo.target_unreachable
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
	name = "stormfiend_demo"
}
