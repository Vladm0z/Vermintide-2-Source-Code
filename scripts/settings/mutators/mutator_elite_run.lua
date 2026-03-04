-- chunkname: @scripts/settings/mutators/mutator_elite_run.lua

return {
	description = "description_mutator_elite_run",
	icon = "mutator_icon_elite_run",
	display_name = "display_name_mutator_elite_run",
	roamer_override_lookup = {
		chaos_marauder_with_shield = "chaos_berzerker",
		beastmen_gor = "beastmen_bestigor",
		chaos_fanatic = "chaos_marauder",
		beastmen_ungor = "beastmen_gor",
		skaven_clan_rat_with_shield = "skaven_storm_vermin",
		skaven_clan_rat = "skaven_storm_vermin",
		chaos_marauder = "chaos_raider"
	},
	server_start_function = function (arg_1_0, arg_1_1)
		local var_1_0 = arg_1_1.template.roamer_override_lookup

		Managers.state.entity:system("ai_interest_point_system"):set_breed_override_lookup(var_1_0)
		Managers.state.conflict:set_breed_override_lookup(var_1_0)

		for iter_1_0, iter_1_1 in pairs(var_1_0) do
			local var_1_1 = Breeds[iter_1_0].threat_value

			Managers.state.conflict:set_threat_value(iter_1_1, var_1_1)
		end
	end,
	server_stop_function = function (arg_2_0, arg_2_1)
		local var_2_0 = arg_2_1.template.roamer_override_lookup

		for iter_2_0, iter_2_1 in pairs(var_2_0) do
			local var_2_1 = Breeds[iter_2_1].threat_value

			Managers.state.conflict:set_threat_value(iter_2_1, var_2_1)
		end
	end
}
