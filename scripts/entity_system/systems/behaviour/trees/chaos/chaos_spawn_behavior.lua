-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_spawn_behavior.lua

local chaos_spawn = BreedActions.chaos_spawn

BreedBehaviors.chaos_spawn = {
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
			action_data = chaos_spawn.climb
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
			action_data = chaos_spawn.smash_door
		},
		condition = "ratogre_at_smartobject",
		name = "smartobject"
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = chaos_spawn.stagger
	},
	{
		"BTSelector",
		{
			"BTUtilityNode",
			{
				"BTMeleeOverlapAttackAction",
				enter_hook = "attack_grabbed_smash",
				name = "attack_grabbed_smash",
				leave_hook = "leave_attack_grabbed",
				action_data = chaos_spawn.attack_grabbed_smash
			},
			{
				"BTChewAttackAction",
				name = "attack_grabbed_chew",
				leave_hook = "leave_attack_grabbed",
				action_data = chaos_spawn.attack_grabbed_chew
			},
			condition = "chaos_spawn_grabbed_combat",
			name = "in_grabbed_combat"
		},
		{
			"BTVictimGrabbedThrowAwayAction",
			condition = "chaos_spawn_grabbed_throw",
			name = "attack_grabbed_throw"
		},
		condition = "victim_grabbed",
		name = "victim_grabbed"
	},
	{
		"BTSelector",
		{
			"BTTargetRageAction",
			name = "target_rage",
			condition = "target_changed",
			action_data = chaos_spawn.target_rage
		},
		{
			"BTUtilityNode",
			{
				"BTErraticFollowAction",
				name = "erratic_follow",
				action_data = chaos_spawn.erratic_follow
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "combo_attack",
				action_data = chaos_spawn.combo_attack
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "melee_shove",
				action_data = chaos_spawn.melee_shove
			},
			{
				"BTMeleeSlamAction",
				name = "melee_slam",
				action_data = chaos_spawn.melee_slam
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "tentacle_grab",
				leave_hook = "check_if_victim_was_grabbed",
				action_data = chaos_spawn.tentacle_grab
			},
			condition = "ratogre_target_reachable",
			name = "in_combat"
		},
		{
			"BTTargetUnreachableAction",
			name = "target_unreachable",
			action_data = chaos_spawn.target_unreachable
		},
		condition = "can_see_player",
		name = "has_target"
	},
	{
		"BTIdleAction",
		name = "idle"
	},
	name = "chaos_spawn"
}
