-- chunkname: @scripts/settings/mutators/mutator_curse_skulls_of_fury.lua

local var_0_0 = "units/props/skull_of_fury"
local var_0_1 = 2
local var_0_2 = "curse_skulls_of_fury"
local var_0_3 = 0
local var_0_4 = {
	skaven_plague_monk = 0.05,
	chaos_raider = 0.1,
	chaos_marauder = 0.05,
	beastmen_bestigor = 0.2,
	chaos_berzerker = 0.05,
	skaven_clan_rat_with_shield = 0.05,
	skaven_stormfiend = 0.5,
	chaos_marauder_with_shield = 0.05,
	beastmen_minotaur = 0.5,
	chaos_fanatic = 0.05,
	skaven_clan_rat = 0.05,
	beastmen_ungor = 0.05,
	chaos_warrior = 0.2,
	skaven_rat_ogre = 0.5,
	beastmen_ungor_archer = 0.05,
	chaos_troll = 0.5,
	chaos_spawn = 0.5,
	skaven_storm_vermin_commander = 0.1,
	skaven_storm_vermin = 0.05,
	beastmen_gor = 0.05,
	skaven_storm_vermin_with_shield = 0.1
}

return {
	description = "curse_skulls_of_fury_desc",
	display_name = "curse_skulls_of_fury_name",
	icon = "deus_curse_khorne_01",
	packages = {
		"resource_packages/mutators/mutator_curse_skulls_of_fury"
	},
	server_start_function = function(arg_1_0, arg_1_1)
		arg_1_1.seed = Managers.mechanism:get_level_seed("mutator")
		arg_1_1.unit_extension_template = "buffed_timed_explosion_unit"
		arg_1_1.extension_init_data = {
			buff_system = {
				initial_buff_names = {
					var_0_2
				}
			},
			area_damage_system = {
				explosion_template_name = "curse_skulls_of_fury_explosion"
			}
		}
	end,
	server_ai_killed_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		local var_2_0 = 1
		local var_2_1

		arg_2_1.seed, var_2_1 = Math.next_random(arg_2_1.seed)

		local var_2_2 = Unit.get_data(arg_2_2, "breed")
		local var_2_3 = var_2_2 and var_0_4[var_2_2.name] or 0

		if var_2_1 < var_0_3 + var_2_3 then
			local var_2_4 = Vector3.copy(POSITION_LOOKUP[arg_2_2])

			var_2_4.z = var_2_4.z + var_0_1

			local var_2_5 = Quaternion.identity()

			Managers.state.unit_spawner:spawn_network_unit(var_0_0, arg_2_1.unit_extension_template, arg_2_1.extension_init_data, var_2_4, var_2_5)

			local var_2_6 = Managers.state.entity:system("dialogue_system"):get_random_player()

			if var_2_6 then
				local var_2_7 = ScriptUnit.extension_input(var_2_6, "dialogue_system")
				local var_2_8 = FrameTable.alloc_table()

				var_2_7:trigger_dialogue_event("curse_danger_spotted", var_2_8)
			end
		end
	end,
	server_player_hit_function = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		if arg_3_4[2] == "skulls_of_fury" then
			local var_3_0 = ScriptUnit.extension_input(arg_3_2, "dialogue_system")
			local var_3_1 = FrameTable.alloc_table()

			var_3_0:trigger_dialogue_event("curse_damage_taken", var_3_1)
		end
	end
}
