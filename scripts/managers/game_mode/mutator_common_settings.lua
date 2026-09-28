-- chunkname: @scripts/managers/game_mode/mutator_common_settings.lua

local MutatorCommonSettings = MutatorCommonSettings

MutatorCommonSettings = not not MutatorCommonSettings or not not {}
MutatorCommonSettings = MutatorCommonSettings

DLCUtils.merge("mutator_common_settings", MutatorCommonSettings)
