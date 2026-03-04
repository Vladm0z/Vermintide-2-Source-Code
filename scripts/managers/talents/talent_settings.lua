-- chunkname: @scripts/managers/talents/talent_settings.lua

Talents = Talents or {}

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

for iter_0_0, iter_0_1 in pairs(Talents) do
	for iter_0_2, iter_0_3 in ipairs(iter_0_1) do
		local var_0_0 = iter_0_3.name

		if not var_0_0 then
			table.dump(iter_0_3, "talent_contents", 2)
		end

		fassert(not TalentIDLookup[var_0_0], "talent with unique name %s already exists", var_0_0)

		local var_0_1 = {
			talent_id = iter_0_2,
			hero_name = iter_0_0
		}

		TalentIDLookup[var_0_0] = var_0_1
	end
end

for iter_0_4, iter_0_5 in pairs(TalentTrees) do
	for iter_0_6, iter_0_7 in ipairs(iter_0_5) do
		for iter_0_8, iter_0_9 in ipairs(iter_0_7) do
			for iter_0_10, iter_0_11 in ipairs(iter_0_9) do
				if iter_0_11 ~= "empty" then
					local var_0_2 = TalentIDLookup[iter_0_11]

					fassert(var_0_2, "Talent %s is missing from the TalentIDLookup table", iter_0_11)

					local var_0_3 = Talents[iter_0_4][var_0_2.talent_id]

					var_0_3.tree = iter_0_6
					var_0_3.row = iter_0_8
					var_0_3.coulumn = iter_0_10
					var_0_3.talent_id = var_0_2.talent_id
				end
			end
		end
	end
end
