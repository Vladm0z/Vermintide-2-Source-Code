-- chunkname: @scripts/entity_system/systems/behaviour/trees/training_dummy_behavior.lua

local training_dummy = BreedActions.training_dummy

BreedBehaviors.training_dummy = {
	"BTSelector",
	{
		"BTDummyStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = training_dummy.stagger
	},
	{
		"BTNilAction",
		name = "do_nothing"
	},
	name = "training_dummy"
}
