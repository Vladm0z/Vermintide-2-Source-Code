-- chunkname: @scripts/settings/mutators/mutator_splitting_enemies.lua

return {
	description = "description_mutator_splitting_enemies",
	display_name = "display_name_mutator_splitting_enemies",
	icon = "mutator_icon_splitting_enemies",
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		arg_1_1.breed_tier_list = {
			beastmen_standard_bearer = "beastmen_bestigor",
			chaos_raider = "chaos_marauder",
			chaos_marauder_with_shield = "chaos_fanatic",
			beastmen_bestigor = "beastmen_gor",
			skaven_poison_wind_globadier = "skaven_plague_monk",
			skaven_clan_rat_with_shield = "skaven_slave",
			chaos_berzerker = "chaos_marauder",
			skaven_gutter_runner = "skaven_storm_vermin_commander",
			skaven_plague_monk = "skaven_clan_rat",
			beastmen_minotaur = "beastmen_standard_bearer",
			chaos_marauder = "chaos_fanatic",
			skaven_storm_vermin_warlord = "skaven_storm_vermin_with_shield",
			skaven_stormfiend_boss = "skaven_ratling_gunner",
			skaven_clan_rat = "skaven_slave",
			skaven_stormfiend = "skaven_warpfire_thrower",
			chaos_exalted_sorcerer = "chaos_vortex_sorcerer",
			skaven_rat_ogre = "skaven_pack_master",
			chaos_troll = "chaos_warrior",
			chaos_spawn = "chaos_warrior",
			chaos_corruptor_sorcerer = "chaos_raider",
			chaos_vortex_sorcerer = "chaos_berzerker",
			skaven_storm_vermin = "skaven_clan_rat",
			beastmen_gor = "beastmen_ungor",
			skaven_storm_vermin_with_shield = "skaven_clan_rat",
			chaos_exalted_champion_warcamp = "chaos_warrior",
			skaven_warpfire_thrower = "skaven_plague_monk",
			chaos_exalted_champion_norsca = "chaos_warrior",
			skaven_pack_master = "skaven_storm_vermin_commander",
			chaos_spawn_exalted_champion_norsca = "chaos_warrior",
			chaos_bulwark = "chaos_raider",
			skaven_grey_seer = "skaven_loot_rat",
			chaos_warrior = "chaos_raider",
			skaven_explosive_loot_rat = "skaven_clan_rat",
			skaven_storm_vermin_commander = "skaven_clan_rat",
			skaven_ratling_gunner = "skaven_storm_vermin_commander",
			skaven_loot_rat = {
				"skaven_clan_rat",
				"skaven_storm_vermin_commander",
				"skaven_warpfire_thrower",
				"skaven_rat_ogre",
				"skaven_rat_ogre"
			}
		}
		arg_1_1.breed_explosion_templates = {
			skaven_stormfiend = "generic_mutator_explosion_large",
			chaos_raider = "generic_mutator_explosion_medium",
			chaos_exalted_champion_warcamp = "generic_mutator_explosion_medium",
			beastmen_bestigor = "generic_mutator_explosion_medium",
			skaven_storm_vermin_warlord = "generic_mutator_explosion_medium",
			skaven_plague_monk = "generic_mutator_explosion_medium",
			skaven_stormfiend_boss = "generic_mutator_explosion_large",
			skaven_grey_seer = "generic_mutator_explosion_medium",
			chaos_exalted_champion_norsca = "generic_mutator_explosion_medium",
			beastmen_minotaur = "generic_mutator_explosion_large",
			chaos_spawn_exalted_champion_norsca = "generic_mutator_explosion_large",
			chaos_bulwark = "generic_mutator_explosion_medium",
			chaos_exalted_sorcerer = "generic_mutator_explosion_medium",
			chaos_warrior = "generic_mutator_explosion_medium",
			skaven_rat_ogre = "generic_mutator_explosion_large",
			chaos_troll = "generic_mutator_explosion_large",
			chaos_spawn = "generic_mutator_explosion_large",
			skaven_storm_vermin_commander = "generic_mutator_explosion_medium",
			skaven_storm_vermin = "generic_mutator_explosion_medium",
			skaven_storm_vermin_with_shield = "generic_mutator_explosion_medium"
		}

		arg_1_1.cb_enemy_spawned_function = function (arg_2_0, arg_2_1, arg_2_2)
			-- function 2
			local var_2_0 = BLACKBOARDS[arg_2_0]

			if not arg_2_1.special then
				var_2_0.spawn_type = "horde"
				var_2_0.spawning_finished = true
			end
		end

		arg_1_1.spawn_queue = {}
		arg_1_1.spawn_delay = 0.25
	end,
	server_update_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		local spawn_queue = arg_3_1.spawn_queue
		local var_3_1

		for i = 1, #spawn_queue do
			local var_3_2 = spawn_queue[i]

			if arg_3_3 > var_3_2.spawn_at_t then
				local breed = var_3_2.breed
				local position_box = var_3_2.position_box
				local rotation_box = var_3_2.rotation_box
				local str = "mutator"
				local tbl = {
					spawned_func = arg_3_1.cb_enemy_spawned_function
				}

				Managers.state.conflict:spawn_queued_unit(breed, position_box, rotation_box, str, nil, "terror_event", tbl)

				var_3_1 = i

				break
			end
		end

		if not var_3_1 then
			table.remove(spawn_queue, var_3_1)
		end
	end,
	on_split_enemy = function (arg_4_0)
		-- function 4
		return
	end,
	server_ai_killed_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
		-- function 5
		local var_5_0 = arg_5_5[DamageDataIndex.DAMAGE_TYPE]

		if not (arg_5_5[DamageDataIndex.DAMAGE_SOURCE_NAME] ~= "suicide" or var_5_0 == "volume_insta_kill" or var_5_0 ~= "forced") then
			return
		end

		local breed_tier_list = arg_5_1.breed_tier_list
		local breed_explosion_templates = arg_5_1.breed_explosion_templates
		local var_5_3 = BLACKBOARDS[arg_5_2]
		local breed = var_5_3.breed
		local name = breed.name
		local var_5_6 = breed_tier_list[name]

		if type(var_5_6) == "table" then
			var_5_6 = var_5_6[Managers.state.difficulty:get_difficulty_rank() - 1]
		end

		local var_5_7 = POSITION_LOOKUP[arg_5_2]
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local spawn_queue = arg_5_1.spawn_queue
		local conflict = Managers.state.conflict

		if not var_5_7 and not var_5_6 then
			local local_rotation = Unit.local_rotation(arg_5_2, 0)
			local num = Quaternion.right(local_rotation) * 0.5
			local num_2 = -num
			local var_5_14 = Breeds[var_5_6]
			local var_5_15 = breed_explosion_templates[name]

			var_5_15 = var_5_15 or "generic_mutator_explosion"

			AiUtils.generic_mutator_explosion(arg_5_2, var_5_3, var_5_15)

			local num_3 = var_5_7 + num
			local num_4 = var_5_7 + num_2
			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, num_3, 1, 1)

			if not pos_on_mesh then
				local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, num_3, 6, 6, 8, 0.5)

				if not inside_position_from_outside_position then
					pos_on_mesh = inside_position_from_outside_position
				end
			end

			local pos_on_mesh_2 = LocomotionUtils.pos_on_mesh(nav_world, num_4, 1, 1)

			if not pos_on_mesh_2 then
				local inside_position_from_outside_position_2 = GwNavQueries.inside_position_from_outside_position(nav_world, num_4, 6, 6, 8, 0.5)

				if not inside_position_from_outside_position_2 then
					pos_on_mesh_2 = inside_position_from_outside_position_2
				end
			end

			local num_5 = Managers.time:time("game") + arg_5_1.spawn_delay

			if not pos_on_mesh then
				local tbl = {
					breed = var_5_14,
					rotation_box = QuaternionBox(local_rotation),
					spawn_at_t = num_5,
					position_box = Vector3Box(pos_on_mesh)
				}

				spawn_queue[#spawn_queue + 1] = tbl
			end

			if not pos_on_mesh_2 then
				local tbl_2 = {
					breed = var_5_14,
					rotation_box = QuaternionBox(local_rotation),
					spawn_at_t = num_5,
					position_box = Vector3Box(pos_on_mesh_2)
				}

				spawn_queue[#spawn_queue + 1] = tbl_2
			end

			local unit_spawner = Managers.state.unit_spawner

			if not unit_spawner:is_marked_for_deletion(arg_5_2) then
				local breed_freezer = conflict.breed_freezer

				breed_freezer = not breed_freezer and conflict.breed_freezer:try_mark_unit_for_freeze(breed, arg_5_2)

				if not breed_freezer then
					unit_spawner:mark_for_deletion(arg_5_2)

					if not arg_5_4 then
						arg_5_4.remove = true
					end
				end
			end

			var_5_3.about_to_be_destroyed = true

			arg_5_1.template.on_split_enemy(arg_5_3)
		end
	end
}
