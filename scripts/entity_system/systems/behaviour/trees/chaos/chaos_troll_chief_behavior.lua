-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_troll_chief_behavior.lua

local chaos_troll_chief = BreedActions.chaos_troll_chief

BreedBehaviors.troll_chief = {
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
			action_data = chaos_troll_chief.climb
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
			action_data = chaos_troll_chief.smash_door
		},
		condition = "ratogre_at_smartobject",
		name = "smartobject"
	},
	{
		"BTSequence",
		{
			"BTSpawnAllies",
			enter_hook = "troll_chief_on_downed",
			name = "spawn_allies",
			action_data = chaos_troll_chief.spawn_allies_defensive
		},
		{
			"BTTrollDownedAction",
			name = "downed",
			action_data = chaos_troll_chief.downed
		},
		{
			"BTSpawnAllies",
			enter_hook = "troll_chief_on_downed",
			name = "spawn_allies",
			condition = "troll_chief_phase_success",
			action_data = chaos_troll_chief.spawn_allies_rage
		},
		condition = "troll_downed",
		name = "downed_sequence"
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = chaos_troll_chief.stagger
	},
	{
		"BTSelector",
		{
			"BTTargetRageAction",
			enter_hook = "rage_on_enter",
			name = "target_rage",
			condition = "target_changed",
			action_data = chaos_troll_chief.target_rage
		},
		{
			"BTUtilityNode",
			{
				"BTBossFollowAction",
				name = "follow",
				action_data = chaos_troll_chief.follow
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "melee_shove",
				action_data = chaos_troll_chief.melee_shove
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "melee_sweep",
				action_data = chaos_troll_chief.melee_sweep
			},
			{
				"BTVomitAction",
				name = "vomit",
				action_data = chaos_troll_chief.vomit
			},
			{
				"BTMeleeOverlapAttackAction",
				name = "attack_cleave",
				action_data = chaos_troll_chief.attack_cleave
			},
			name = "in_combat",
			condition = "ratogre_target_reachable",
			enter_hook = "upright_on_enter"
		},
		{
			"BTTargetUnreachableAction",
			name = "target_unreachable",
			action_data = chaos_troll_chief.target_unreachable
		},
		condition = "can_see_player",
		name = "has_target"
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = chaos_troll_chief.follow
	},
	{
		"BTIdleAction",
		enter_hook = "crouch_or_upright_on_enter",
		name = "idle"
	},
	name = "chaos_troll_chief"
}
