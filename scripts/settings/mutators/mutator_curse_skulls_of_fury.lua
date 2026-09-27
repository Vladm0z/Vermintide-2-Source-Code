-- chunkname: @scripts/settings/mutators/mutator_curse_skulls_of_fury.lua

local str = "units/props/skull_of_fury"
local num = 2
local str_2 = "curse_skulls_of_fury"
local num_2 = 0
local tbl = {
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
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		arg_1_1.seed = Managers.mechanism:get_level_seed("mutator")
		arg_1_1.unit_extension_template = "buffed_timed_explosion_unit"
		arg_1_1.extension_init_data = {
			buff_system = {
				initial_buff_names = {
					str_2
				}
			},
			area_damage_system = {
				explosion_template_name = "curse_skulls_of_fury_explosion"
			}
		}
	end,
	server_ai_killed_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		local num_3 = 1
		local var_2_1

		arg_2_1.seed, var_2_1 = Math.next_random(arg_2_1.seed)

		local get_data = Unit.get_data(arg_2_2, "breed")
		local var_2_3

		if not get_data then
			var_2_3 = tbl[get_data.name]

			if not var_2_3 then
				-- Nothing
			end
		end

		var_2_3 = 0

		::label_2_0::

		if var_2_1 < num_2 + var_2_3 then
			local copy = Vector3.copy(POSITION_LOOKUP[arg_2_2])

			copy.z = copy.z + num

			local identity = Quaternion.identity()

			Managers.state.unit_spawner:spawn_network_unit(str, arg_2_1.unit_extension_template, arg_2_1.extension_init_data, copy, identity)

			local get_random_player = Managers.state.entity:system("dialogue_system"):get_random_player()

			if not get_random_player then
				local extension_input = ScriptUnit.extension_input(get_random_player, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				extension_input:trigger_dialogue_event("curse_danger_spotted", alloc_table)
			end
		end
	end,
	server_player_hit_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		if arg_3_4[2] == "skulls_of_fury" then
			local extension_input = ScriptUnit.extension_input(arg_3_2, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_dialogue_event("curse_damage_taken", alloc_table)
		end
	end
}
