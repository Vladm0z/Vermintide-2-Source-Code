-- chunkname: @scripts/settings/mutators/mutator_life.lua

return {
	description = "weaves_life_mutator_desc",
	display_name = "weaves_life_mutator_name",
	icon = "mutator_icon_life_thorns",
	add_to_spawn_queue = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		local var_1_0 = Vector3Box()
		local var_1_1 = QuaternionBox()

		Vector3Box.store(var_1_0, arg_1_1)
		QuaternionBox.store(var_1_1, arg_1_2)

		arg_1_0.spawn_queue[#arg_1_0.spawn_queue + 1] = {
			position = var_1_0,
			rotation = var_1_1
		}
	end,
	spawn_bush = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local str = "units/weave/life/life_thorn_bushes_mutator"

		if not (not Managers.state.network and Managers.state.network:game()) then
			return
		end

		if not GwNavQueries.triangle_from_position(arg_2_1.nav_world, arg_2_2) then
			arg_2_2 = GwNavQueries.inside_position_from_outside_position(arg_2_1.nav_world, arg_2_2, 6, 6, 8, 0.5)
		end

		if not arg_2_2 then
			local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "thorn_bush_unit", arg_2_1.extension_init_data, arg_2_2, arg_2_3)

			arg_2_1.audio_system:play_audio_unit_event("Play_winds_life_gameplay_thorn_grow", spawn_network_unit)
		end
	end,
	server_ai_hit_by_player_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		if not Unit.get_data(arg_3_2, "breed").boss then
			local unit_game_object_id = arg_3_1.network_manager:unit_game_object_id(arg_3_2)

			if not arg_3_1.boss_drop_timers[unit_game_object_id] then
				arg_3_1.boss_drop_timers[unit_game_object_id] = {
					timer = arg_3_1.boss_drop_cooldown
				}
			end

			if arg_3_1.boss_drop_timers[unit_game_object_id].timer >= arg_3_1.boss_drop_cooldown then
				local local_position = Unit.local_position(arg_3_2, 0)
				local local_rotation = Unit.local_rotation(arg_3_2, 0)

				arg_3_1.template.add_to_spawn_queue(arg_3_1, local_position, local_rotation)

				arg_3_1.boss_drop_timers[unit_game_object_id].timer = 0
			end
		end
	end,
	server_ai_killed_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		local local_position = Unit.local_position(arg_4_2, 0)
		local local_rotation = Unit.local_rotation(arg_4_2, 0)

		arg_4_1.template.add_to_spawn_queue(arg_4_1, local_position, local_rotation)
	end,
	server_start_function = function (arg_5_0, arg_5_1)
		-- function 5
		local life = WindSettings.life
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local get_wind_strength = Managers.weave:get_wind_strength()

		arg_5_1.nav_world = Managers.state.entity:system("ai_system"):nav_world()
		arg_5_1.player_units = {}
		arg_5_1.boss_drop_timers = {}
		arg_5_1.boss_drop_cooldown = 2
		arg_5_1.audio_system = Managers.state.entity:system("audio_system")
		arg_5_1.network_manager = Managers.state.network
		arg_5_1.spawn_queue = {}
		arg_5_1.extension_init_data = {
			area_damage_system = {
				area_damage_template = "mutator_life_poison",
				radius = 1,
				nav_tag_volume_layer = "fire_grenade",
				invisible_unit = false,
				player_screen_effect_name = "fx/screenspace_poison_globe_impact",
				create_nav_tag_volume = true,
				damage_source = "dot_debuff",
				aoe_dot_damage_interval = 0.25,
				damage_players = true,
				aoe_dot_damage = life.thorns_damage[get_difficulty][get_wind_strength],
				aoe_init_damage = life.thorns_damage[get_difficulty][get_wind_strength],
				life_time = life.thorns_life_time[get_difficulty][get_wind_strength]
			},
			props_system = {
				despawn_animation_time = 2,
				spawn_animation_time = 4
			}
		}
	end,
	server_update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		for k, v in pairs(arg_6_1.boss_drop_timers) do
			v.timer = v.timer + arg_6_2
		end

		local count = #arg_6_1.spawn_queue

		if count > 0 then
			local var_6_1 = arg_6_1.spawn_queue[count]
			local position = var_6_1.position
			local unbox = Vector3Box.unbox(position)
			local unbox_2 = QuaternionBox.unbox(var_6_1.rotation)

			arg_6_1.template.spawn_bush(arg_6_0, arg_6_1, unbox, unbox_2)

			arg_6_1.spawn_queue[count] = nil
		end
	end
}
