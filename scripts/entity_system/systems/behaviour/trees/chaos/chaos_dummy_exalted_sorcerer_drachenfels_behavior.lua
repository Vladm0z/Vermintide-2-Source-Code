-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_dummy_exalted_sorcerer_drachenfels_behavior.lua

local chaos_dummy_exalted_sorcerer_drachenfels = BreedActions.chaos_dummy_exalted_sorcerer_drachenfels

BreedBehaviors.dummy_exalted_sorcerer_drachenfels = {
	"BTSelector",
	{
		"BTTentacleSpawnAction",
		name = "spawn",
		condition = "spawn",
		action_data = chaos_dummy_exalted_sorcerer_drachenfels.spawn
	},
	{
		"BTUtilityNode",
		{
			"BTCastMissileAction",
			name = "defensive_seeking_bomb",
			action_data = chaos_dummy_exalted_sorcerer_drachenfels.defensive_seeking_bomb
		},
		condition = "dummy_not_escaped",
		name = "cast_seeking_bomb"
	},
	{
		"BTDummyIdleAction",
		enter_hook = "sorcerer_dummy_idle",
		name = "idle",
		action_data = chaos_dummy_exalted_sorcerer_drachenfels.idle
	},
	name = "chaos_dummy_exalted_sorcerer_drachenfels"
}
