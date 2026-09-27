-- chunkname: @scripts/settings/dlcs/woods/woods_spawn_unit_templates.lua

local tbl = {
	default = "units/beings/player/way_watcher_thornsister/abilities/ww_thornsister_thorn_wall_01",
	bleed = "units/beings/player/way_watcher_thornsister/abilities/ww_thornsister_thorn_wall_01_bleed"
}
local enum = table.enum("default", "bleed")

SpawnUnitTemplates.thornsister_thorn_wall_unit = {
	spawn_func = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		-- function 1
		local var_1_0 = tbl[enum.default]
		local str = "thornsister_thorn_wall_unit"
		local var_1_2 = arg_1_3
		local str_2 = "career_ability_kerillian_sister_wall_disappear"
		local num = 6
		local tbl_2 = {
			aoe_dot_damage = 0,
			radius = 0.3,
			area_damage_template = "we_thornsister_thorn_wall",
			invisible_unit = false,
			nav_tag_volume_layer = "temporary_wall",
			create_nav_tag_volume = true,
			aoe_init_damage = 0,
			damage_source = "career_ability",
			aoe_dot_damage_interval = 0,
			damage_players = false,
			source_attacker_unit = arg_1_0,
			life_time = num
		}
		local tbl_3 = {
			life_time = num,
			owner_unit = arg_1_0,
			despawn_sound_event = str_2,
			wall_index = var_1_2
		}
		local tbl_4 = {
			health = 20
		}
		local var_1_8
		local has_extension = ScriptUnit.has_extension(arg_1_0, "talent_system")

		if not has_extension then
			if not has_extension:has_talent("kerillian_thorn_sister_tanky_wall") then
				local num_2 = 1
				local num_3 = 4.2

				tbl_2.life_time = tbl_2.life_time * num_2 + num_3
				tbl_3.life_time = tbl_3.life_time * num_2 + num_3
			elseif not has_extension:has_talent("kerillian_thorn_sister_debuff_wall") then
				local num_4 = 0.17
				local num_5 = 0

				tbl_2.create_nav_tag_volume = false
				tbl_2.life_time = tbl_2.life_time * num_4 + num_5
				tbl_3.life_time = tbl_3.life_time * num_4 + num_5
				var_1_0 = tbl[enum.bleed]
			end
		end

		local tbl_5 = {
			area_damage_system = tbl_2,
			props_system = tbl_3,
			health_system = tbl_4,
			death_system = {
				death_reaction_template = "thorn_wall",
				is_husk = false
			},
			hit_reaction_system = {
				is_husk = false,
				hit_reaction_template = "level_object"
			}
		}
		local spawn_network_unit, var_1_16 = Managers.state.unit_spawner:spawn_network_unit(var_1_0, str, tbl_5, arg_1_1, arg_1_2)
		local var_1_17 = Quaternion(Vector3.up(), math.random() * 2 * math.pi - math.pi)

		Unit.set_local_rotation(spawn_network_unit, 0, var_1_17)

		local has_extension_2 = ScriptUnit.has_extension(spawn_network_unit, "buff_system")

		if not has_extension_2 and not var_1_8 then
			for i = 1, #var_1_8 do
				has_extension_2:add_buff(var_1_8[i])
			end
		end

		local has_extension_3 = ScriptUnit.has_extension(spawn_network_unit, "props_system")

		if not has_extension_3 then
			has_extension_3.group_spawn_index = arg_1_4
		end

		return spawn_network_unit, var_1_16
	end
}
SpawnUnitTemplates.vortex_unit = {
	spawn_func = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local str = "units/weapons/enemy/wpn_chaos_plague_vortex/wpn_chaos_plague_vortex"
		local str_2 = "spirit_storm"
		local var_2_2 = VortexTemplates[str_2]
		local var_2_3
		local var_2_4
		local num = 2
		local min = math.min(num / var_2_2.full_inner_radius, 1)
		local var_2_7

		if not var_2_3 then
			local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_2_1)
			local max = math.max(var_2_2.full_inner_radius, min * var_2_2.full_inner_radius)

			Matrix4x4.set_scale(from_quaternion_position, Vector3(max, max, max))

			var_2_7 = Managers.state.unit_spawner:spawn_network_unit(var_2_3, "network_synched_dummy_unit", nil, from_quaternion_position)
		end

		local var_2_10

		if not var_2_4 then
			local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_2_1)
			local max_2 = math.max(var_2_2.full_outer_radius, min * var_2_2.full_outer_radius)

			Matrix4x4.set_scale(from_quaternion_position_2, Vector3(max_2, max_2, max_2))

			var_2_10 = Managers.state.unit_spawner:spawn_network_unit(var_2_4, "network_synched_dummy_unit", nil, from_quaternion_position_2)
		end

		local side_id = Managers.state.side.side_by_unit[arg_2_0].side_id
		local str_3 = "vortex_unit"
		local tbl = {
			area_damage_system = {
				vortex_template_name = str_2,
				inner_decal_unit = var_2_7,
				outer_decal_unit = var_2_10,
				owner_unit = arg_2_0,
				side_id = side_id,
				target_unit = target_unit
			}
		}

		return Managers.state.unit_spawner:spawn_network_unit(str, str_3, tbl, arg_2_1, arg_2_2)
	end
}
