-- chunkname: @scripts/settings/dlcs/woods/woods_spawn_unit_templates.lua

local var_0_0 = {
	default = "units/beings/player/way_watcher_thornsister/abilities/ww_thornsister_thorn_wall_01",
	bleed = "units/beings/player/way_watcher_thornsister/abilities/ww_thornsister_thorn_wall_01_bleed"
}
local var_0_1 = table.enum("default", "bleed")

SpawnUnitTemplates.thornsister_thorn_wall_unit = {
	spawn_func = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		local var_1_0 = var_0_0[var_0_1.default]
		local var_1_1 = "thornsister_thorn_wall_unit"
		local var_1_2 = arg_1_3
		local var_1_3 = "career_ability_kerillian_sister_wall_disappear"
		local var_1_4 = 6
		local var_1_5 = {
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
			life_time = var_1_4
		}
		local var_1_6 = {
			life_time = var_1_4,
			owner_unit = arg_1_0,
			despawn_sound_event = var_1_3,
			wall_index = var_1_2
		}
		local var_1_7 = {
			health = 20
		}
		local var_1_8
		local var_1_9 = ScriptUnit.has_extension(arg_1_0, "talent_system")

		if var_1_9 then
			if var_1_9:has_talent("kerillian_thorn_sister_tanky_wall") then
				local var_1_10 = 1
				local var_1_11 = 4.2

				var_1_5.life_time = var_1_5.life_time * var_1_10 + var_1_11
				var_1_6.life_time = var_1_6.life_time * var_1_10 + var_1_11
			elseif var_1_9:has_talent("kerillian_thorn_sister_debuff_wall") then
				local var_1_12 = 0.17
				local var_1_13 = 0

				var_1_5.create_nav_tag_volume = false
				var_1_5.life_time = var_1_5.life_time * var_1_12 + var_1_13
				var_1_6.life_time = var_1_6.life_time * var_1_12 + var_1_13
				var_1_0 = var_0_0[var_0_1.bleed]
			end
		end

		local var_1_14 = {
			area_damage_system = var_1_5,
			props_system = var_1_6,
			health_system = var_1_7,
			death_system = {
				death_reaction_template = "thorn_wall",
				is_husk = false
			},
			hit_reaction_system = {
				is_husk = false,
				hit_reaction_template = "level_object"
			}
		}
		local var_1_15, var_1_16 = Managers.state.unit_spawner:spawn_network_unit(var_1_0, var_1_1, var_1_14, arg_1_1, arg_1_2)
		local var_1_17 = Quaternion(Vector3.up(), math.random() * 2 * math.pi - math.pi)

		Unit.set_local_rotation(var_1_15, 0, var_1_17)

		local var_1_18 = ScriptUnit.has_extension(var_1_15, "buff_system")

		if var_1_18 and var_1_8 then
			for iter_1_0 = 1, #var_1_8 do
				var_1_18:add_buff(var_1_8[iter_1_0])
			end
		end

		local var_1_19 = ScriptUnit.has_extension(var_1_15, "props_system")

		if var_1_19 then
			var_1_19.group_spawn_index = arg_1_4
		end

		return var_1_15, var_1_16
	end
}
SpawnUnitTemplates.vortex_unit = {
	spawn_func = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = "units/weapons/enemy/wpn_chaos_plague_vortex/wpn_chaos_plague_vortex"
		local var_2_1 = "spirit_storm"
		local var_2_2 = VortexTemplates[var_2_1]
		local var_2_3
		local var_2_4
		local var_2_5 = 2
		local var_2_6 = math.min(var_2_5 / var_2_2.full_inner_radius, 1)
		local var_2_7

		if var_2_3 then
			local var_2_8 = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_2_1)
			local var_2_9 = math.max(var_2_2.full_inner_radius, var_2_6 * var_2_2.full_inner_radius)

			Matrix4x4.set_scale(var_2_8, Vector3(var_2_9, var_2_9, var_2_9))

			var_2_7 = Managers.state.unit_spawner:spawn_network_unit(var_2_3, "network_synched_dummy_unit", nil, var_2_8)
		end

		local var_2_10

		if var_2_4 then
			local var_2_11 = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_2_1)
			local var_2_12 = math.max(var_2_2.full_outer_radius, var_2_6 * var_2_2.full_outer_radius)

			Matrix4x4.set_scale(var_2_11, Vector3(var_2_12, var_2_12, var_2_12))

			var_2_10 = Managers.state.unit_spawner:spawn_network_unit(var_2_4, "network_synched_dummy_unit", nil, var_2_11)
		end

		local var_2_13 = Managers.state.side.side_by_unit[arg_2_0].side_id
		local var_2_14 = "vortex_unit"
		local var_2_15 = {
			area_damage_system = {
				vortex_template_name = var_2_1,
				inner_decal_unit = var_2_7,
				outer_decal_unit = var_2_10,
				owner_unit = arg_2_0,
				side_id = var_2_13,
				target_unit = target_unit
			}
		}

		return Managers.state.unit_spawner:spawn_network_unit(var_2_0, var_2_14, var_2_15, arg_2_1, arg_2_2)
	end
}
