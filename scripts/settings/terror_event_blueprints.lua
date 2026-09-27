-- chunkname: @scripts/settings/terror_event_blueprints.lua

require("scripts/settings/terror_events/terror_event_utils")
require("scripts/settings/terror_events/terror_events_generic")

WeightedRandomTerrorEvents = {}
TerrorEventBlueprints = {}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local flag = arg_1_1 or arg_1_0
	local str = "scripts/settings/terror_events/terror_events_" .. flag

	fassert(Application.can_get("lua", str), "Failed to load terror events for level %s with path %s NOTE: Make sure the terror events file is in scripts/settings/terror_events/ with the name terror_events_%s.", arg_1_0, str, flag)

	local var_1_2, var_1_3 = unpack(local_require(str))

	TerrorEventBlueprints[arg_1_0] = var_1_2

	if not var_1_3 then
		WeightedRandomTerrorEvents[arg_1_0] = var_1_3
	end
end

for k, v in pairs(LevelSettings) do
	local flag = not v.no_terror_events

	if type(v) ~= "table" or not flag then
		local override_file_ending = v.override_file_ending

		fn(k, override_file_ending)
	end
end

fn("weaves")

for k_2, v_2 in pairs(WeightedRandomTerrorEvents) do
	for k_3, v_3 in pairs(v_2) do
		for i6 = 1, #v_3, 2 do
			local var_0_3 = v_3[i6]

			fassert(TerrorEventBlueprints[k_2][var_0_3], "TerrorEventChunk %s has a bad event: '%s'.", k_3, tostring(var_0_3))
		end

		v_3.loaded_probability_table = LoadedDice.create_from_mixed(v_3)
	end
end
