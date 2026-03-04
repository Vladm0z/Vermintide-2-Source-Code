-- chunkname: @scripts/settings/terror_event_blueprints.lua

require("scripts/settings/terror_events/terror_event_utils")
require("scripts/settings/terror_events/terror_events_generic")

WeightedRandomTerrorEvents = {}
TerrorEventBlueprints = {}

local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1 or arg_1_0
	local var_1_1 = "scripts/settings/terror_events/terror_events_" .. var_1_0

	fassert(Application.can_get("lua", var_1_1), "Failed to load terror events for level %s with path %s NOTE: Make sure the terror events file is in scripts/settings/terror_events/ with the name terror_events_%s.", arg_1_0, var_1_1, var_1_0)

	local var_1_2, var_1_3 = unpack(local_require(var_1_1))

	TerrorEventBlueprints[arg_1_0] = var_1_2

	if var_1_3 then
		WeightedRandomTerrorEvents[arg_1_0] = var_1_3
	end
end

for iter_0_0, iter_0_1 in pairs(LevelSettings) do
	local var_0_1 = not iter_0_1.no_terror_events

	if type(iter_0_1) == "table" and var_0_1 then
		local var_0_2 = iter_0_1.override_file_ending

		var_0_0(iter_0_0, var_0_2)
	end
end

var_0_0("weaves")

for iter_0_2, iter_0_3 in pairs(WeightedRandomTerrorEvents) do
	for iter_0_4, iter_0_5 in pairs(iter_0_3) do
		for iter_0_6 = 1, #iter_0_5, 2 do
			local var_0_3 = iter_0_5[iter_0_6]

			fassert(TerrorEventBlueprints[iter_0_2][var_0_3], "TerrorEventChunk %s has a bad event: '%s'.", iter_0_4, tostring(var_0_3))
		end

		iter_0_5.loaded_probability_table = LoadedDice.create_from_mixed(iter_0_5)
	end
end
