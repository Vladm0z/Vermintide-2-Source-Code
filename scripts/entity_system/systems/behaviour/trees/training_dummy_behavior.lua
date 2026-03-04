-- chunkname: @scripts/entity_system/systems/behaviour/trees/training_dummy_behavior.lua

local var_0_0 = BreedActions.training_dummy

BreedBehaviors.training_dummy = {
	"BTSelector",
	{
		"BTDummyStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = var_0_0.stagger
	},
	{
		"BTNilAction",
		name = "do_nothing"
	},
	name = "training_dummy"
}
