-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_dummy_troll_behavior.lua

local chaos_dummy_troll = BreedActions.chaos_dummy_troll

BreedBehaviors.dummy_troll = {
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
			action_data = chaos_dummy_troll.climb
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
			action_data = chaos_dummy_troll.smash_door
		},
		condition = "ratogre_at_smartobject",
		name = "smartobject"
	},
	{
		"BTTrollDownedAction",
		name = "downed",
		condition = "troll_downed",
		action_data = chaos_dummy_troll.downed
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = chaos_dummy_troll.stagger
	},
	{
		"BTMoveToGoalAction",
		enter_hook = "crouch_or_upright_on_enter",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = chaos_dummy_troll.follow
	},
	{
		"BTIdleAction",
		enter_hook = "crouch_or_upright_on_enter",
		name = "idle"
	},
	name = "chaos_dummy_troll"
}
