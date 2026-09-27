-- chunkname: @scripts/settings/dlcs/mutators_batch_02/mutators_batch_02_common_settings.lua

local mutators_batch_02 = DLCSettings.mutators_batch_02

mutators_batch_02.mutators = {
	"escort",
	"slayer_curse",
	"explosive_loot_rats",
	"leash",
	"bloodlust",
	"skulking_sorcerer"
}
mutators_batch_02.husk_lookup = {
	"units/weapons/player/pup_mutator_statue_01/pup_mutator_statue_01",
	"units/beings/enemies/skaven_mutator_slave_rat/chr_skaven_mutator_slave_rat",
	"units/beings/enemies/chaos_mutator_sorcerer/chr_chaos_mutator_sorcerer"
}
mutators_batch_02.dialogue_event_data_lookup = {
	"mutator_statue_01"
}
