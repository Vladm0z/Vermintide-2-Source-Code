-- chunkname: @scripts/settings/mutators/mutator_curse_monophobia.lua

local scripts_settings_mutators_mutator_leash = require("scripts/settings/mutators/mutator_leash")
local clone = table.clone(scripts_settings_mutators_mutator_leash)

clone.display_name = "curse_monophobia_name"
clone.description = "curse_monophobia_desc"
clone.icon = "deus_curse_slaanesh_01"

return clone
