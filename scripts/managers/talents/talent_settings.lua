-- chunkname: @scripts/managers/talents/talent_settings.lua

local Talents = Talents

Talents = Talents or {}
Talents = Talents

require("scripts/managers/talents/talent_settings_bardin")
require("scripts/managers/talents/talent_settings_sienna")
require("scripts/managers/talents/talent_settings_kerillian")
require("scripts/managers/talents/talent_settings_markus")
require("scripts/managers/talents/talent_settings_victor")
DLCUtils.require_list("talent_settings")

MaxTalentPoints = 6
NumTalentRows = 6
NumTalentColumns = 3
TalentUnlockLevels = {
	talent_point_5 = 25,
	talent_point_1 = 5,
	talent_point_6 = 30,
	talent_point_4 = 20,
	talent_point_3 = 15,
	talent_point_2 = 10
}
TalentIDLookup = {}

for k, v in pairs(Talents) do
	for i, v_2 in ipairs(v) do
		local name = v_2.name

		if not name then
			table.dump(v_2, "talent_contents", 2)
		end

		fassert(not TalentIDLookup[name], "talent with unique name %s already exists", name)

		local tbl = {
			talent_id = i,
			hero_name = k
		}

		TalentIDLookup[name] = tbl
	end
end

for k_2, v_3 in pairs(TalentTrees) do
	for i_2, v_4 in ipairs(v_3) do
		for i_3, v_5 in ipairs(v_4) do
			for i_4, v_6 in ipairs(v_5) do
				if v_6 ~= "empty" then
					local var_0_3 = TalentIDLookup[v_6]

					fassert(var_0_3, "Talent %s is missing from the TalentIDLookup table", v_6)

					local var_0_4 = Talents[k_2][var_0_3.talent_id]

					var_0_4.tree = i_2
					var_0_4.row = i_3
					var_0_4.coulumn = i_4
					var_0_4.talent_id = var_0_3.talent_id
				end
			end
		end
	end
end
