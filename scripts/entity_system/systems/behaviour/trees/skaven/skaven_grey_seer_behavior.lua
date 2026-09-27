-- chunkname: @scripts/entity_system/systems/behaviour/trees/skaven/skaven_grey_seer_behavior.lua

local skaven_grey_seer = BreedActions.skaven_grey_seer

BreedBehaviors.grey_seer = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
	},
	{
		"BTSelector",
		action_data = skaven_grey_seer.intro_sequence,
		{
			"BTDummyIdleAction",
			enter_hook = "to_combat",
			name = "intro_idle",
			action_data = skaven_grey_seer.intro_idle
		},
		name = "intro_sequence",
		leave_hook = "on_grey_seer_intro_leave",
		condition = "lord_intro",
		enter_hook = "on_grey_seer_intro_enter"
	},
	{
		"BTMountUnitAction",
		name = "mount_unit",
		condition = "should_mount_unit",
		action_data = skaven_grey_seer.mount_unit
	},
	{
		"BTIdleAction",
		condition = "grey_seer_waiting_for_pickup",
		name = "waiting_for_pickup_idle"
	},
	{
		"BTGreySeerMountedAction",
		condition = "is_mounted",
		name = "mounted_combat"
	},
	{
		"BTDummyIdleAction",
		name = "wounded_idle",
		condition = "grey_seer_waiting_death",
		action_data = skaven_grey_seer.wounded_idle
	},
	{
		"BTSequence",
		action_data = skaven_grey_seer.grey_seer_death_sequence,
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_death_sequence_teleport",
			name = "quick_teleport",
			leave_hook = "on_grey_seer_death_sequence_leave",
			action_data = skaven_grey_seer.quick_teleport_death
		},
		name = "grey_seer_death_sequence",
		condition = "grey_seer_death"
	},
	{
		"BTSequence",
		{
			"BTQuickTeleportAction",
			enter_hook = "grey_seer_call_stormfiend_enter",
			name = "quick_teleport",
			action_data = skaven_grey_seer.quick_teleport
		},
		{
			"BTIdleAction",
			name = "defensive_idle",
			action_data = skaven_grey_seer.defensive_idle
		},
		condition = "grey_seer_call_stormfiend",
		name = "grey_seer_call_stormfiend"
	},
	{
		"BTStaggerAction",
		enter_hook = "grey_seer_stagger_enter",
		name = "stagger",
		condition = "grey_seer_stagger",
		action_data = skaven_grey_seer.stagger
	},
	{
		"BTSelector",
		{
			"BTQuickTeleportAction",
			name = "quick_teleport",
			condition = "grey_seer_teleport_spell",
			action_data = skaven_grey_seer.quick_teleport
		},
		{
			"BTChaosSorcererSummoningAction",
			name = "spawn_plague_wave",
			condition = "grey_seer_vermintide_spell",
			action_data = skaven_grey_seer.spawn_plague_wave
		},
		{
			"BTCastMissileAction",
			name = "cast_missile",
			condition = "grey_seer_warp_lightning_spell",
			action_data = skaven_grey_seer.cast_missile
		},
		condition = "ready_to_cast_spell",
		name = "spell_casting"
	},
	{
		"BTGreySeerGroundCombatAction",
		name = "ground_combat",
		condition = "knocked_off_mount",
		action_data = skaven_grey_seer.ground_combat
	},
	{
		"BTIdleAction",
		name = "defensive_idle",
		action_data = skaven_grey_seer.defensive_idle
	},
	{
		"BTIdleAction",
		name = "idle"
	},
	name = "grey_seer"
}
