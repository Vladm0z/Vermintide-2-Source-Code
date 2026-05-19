-- chunkname: @scripts/settings/mutators/mutator_shadow.lua

local var_0_0 = 5
local var_0_1 = 0
local var_0_2 = 0
local var_0_3 = {}

return {
	description = "weaves_shadow_mutator_desc",
	display_name = "weaves_shadow_mutator_name",
	icon = "mutator_icon_shadow_illusion",
	faded_units = {},
	linked_units = {},
	linked_units_visibility = {},
	buffed_units = {},
	buff_params = {
		external_optional_multiplier = -0.9
	},
	server_start_function = function(arg_1_0, arg_1_1)
		local var_1_0 = Managers.weave:get_wind_strength() or 1
		local var_1_1 = Managers.weave:get_active_wind_settings()
		local var_1_2 = Managers.state.difficulty:get_difficulty()

		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.hero_side = Managers.state.side:get_side_from_name("heroes")
		arg_1_1.lantern_spawned = false
		arg_1_1.light_radius = var_1_1 and var_1_1.light_radius[var_1_2][var_1_0]
	end,
	server_ai_killed_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		if arg_2_1.template.linked_units_visibility[arg_2_2] then
			local var_2_0 = BLACKBOARDS[arg_2_3]

			if var_2_0 and var_2_0.breed.is_player then
				arg_2_1.template.increment_challenge_stat(arg_2_3)
			end
		end
	end,
	increment_challenge_stat = function(arg_3_0)
		if ScorpionSeasonalSettings.current_season_id == 1 then
			local var_3_0 = "season_1"
			local var_3_1 = "weave_shadow_kill_no_shrouded"
			local var_3_2 = Managers.player:owner(arg_3_0)

			if var_3_2.local_player then
				local var_3_3 = Managers.player:statistics_db()
				local var_3_4 = Managers.player:local_player():stats_id()

				var_3_3:increment_stat(var_3_4, var_3_0, var_3_1)
			else
				local var_3_5 = NetworkLookup.statistics_group_name[var_3_0]
				local var_3_6 = NetworkLookup.statistics[var_3_1]
				local var_3_7 = var_3_2:network_id()

				Managers.state.network.network_transmit:send_rpc("rpc_increment_stat_group", var_3_7, var_3_5, var_3_6)
			end
		end
	end,
	server_update_function = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		local var_4_0 = arg_4_1.hero_side
		local var_4_1 = var_4_0:enemy_units()
		local var_4_2 = arg_4_1.template
		local var_4_3 = var_4_2.buffed_units
		local var_4_4 = var_4_2.buff_params
		local var_4_5 = var_4_0.PLAYER_UNITS

		for iter_4_0 = 1, var_0_0 do
			var_0_1 = var_0_1 + 1

			local var_4_6 = var_4_1[var_0_1]
			local var_4_7 = false

			if var_4_6 then
				for iter_4_1, iter_4_2 in pairs(var_4_5) do
					local var_4_8 = arg_4_1.light_radius
					local var_4_9 = POSITION_LOOKUP[iter_4_2]

					if ScriptUnit.has_extension(var_4_6, "buff_system") and HEALTH_ALIVE[var_4_6] then
						local var_4_10 = POSITION_LOOKUP[var_4_6]

						if Vector3.distance_squared(var_4_9, var_4_10) <= var_4_8 * var_4_8 then
							var_4_7 = true

							break
						end
					end
				end

				local var_4_11 = ScriptUnit.has_extension(var_4_6, "buff_system")

				if var_4_11 then
					local var_4_12 = var_4_11:has_buff_type("mutator_shadow_damage_reduction")

					if var_4_7 then
						if var_4_12 and var_4_3[var_4_6] then
							local var_4_13 = var_4_3[var_4_6]

							arg_4_1.buff_system:remove_server_controlled_buff(var_4_6, var_4_13)

							var_4_3[var_4_6] = nil
						end
					else
						local var_4_14 = ScriptUnit.has_extension(var_4_6, "ping_system")

						if var_4_14 and var_4_14:pinged() then
							Managers.state.entity:system("ping_system"):remove_ping_from_unit(var_4_6)
						end

						if not var_4_12 then
							var_4_3[var_4_6] = arg_4_1.buff_system:add_buff(var_4_6, "mutator_shadow_damage_reduction", var_4_6, true)
						end
					end
				end
			else
				var_0_1 = 0
			end
		end

		if #var_0_3 > 0 then
			table.clear(var_0_3)
		end

		for iter_4_3, iter_4_4 in pairs(var_4_3) do
			if not HEALTH_ALIVE[iter_4_3] then
				var_0_3[#var_0_3 + 1] = iter_4_3
			end
		end

		for iter_4_5 = 1, #var_0_3 do
			var_4_3[var_0_3[iter_4_5]] = nil
		end
	end,
	client_start_function = function(arg_5_0, arg_5_1)
		arg_5_1.hero_side = Managers.state.side:get_side_from_name("heroes")
		arg_5_1.light_spawned = false
	end,
	client_player_respawned_function = function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = Managers.player:local_player().player_unit

		if arg_6_2 == var_6_0 then
			local var_6_1 = Unit.local_position(var_6_0, 0)
			local var_6_2 = Unit.local_rotation(var_6_0, 0)
			local var_6_3 = World.spawn_unit(arg_6_0.world, "units/weapons/player/wpn_shadow_gargoyle_head/wpn_shadow_gargoyle_head", var_6_1, var_6_2)
			local var_6_4 = Unit.light(var_6_3, "light")

			Light.set_falloff_end(var_6_4, arg_6_1.light_radius)
			Light.set_falloff_start(var_6_4, arg_6_1.light_radius - 1)
			World.link_unit(arg_6_0.world, var_6_3, 0, var_6_0, 0)
		end
	end,
	client_update_function = function(arg_7_0, arg_7_1)
		local var_7_0 = Managers.weave:get_wind_strength() or 1
		local var_7_1 = Managers.weave:get_active_wind_settings()
		local var_7_2 = Managers.state.difficulty:get_difficulty()
		local var_7_3 = arg_7_1.hero_side:enemy_units()
		local var_7_4 = Managers.state.entity:system("fade_system")
		local var_7_5 = arg_7_1.template
		local var_7_6 = var_7_5.faded_units
		local var_7_7 = var_7_5.linked_units
		local var_7_8 = var_7_5.linked_units_visibility
		local var_7_9 = Managers.player
		local var_7_10 = var_7_9:local_player().player_unit

		arg_7_1.light_radius = var_7_1 and var_7_1.light_radius[var_7_2][var_7_0] or 6

		if var_7_10 and not arg_7_1.light_spawned then
			local var_7_11 = Unit.local_position(var_7_10, 0)
			local var_7_12 = Unit.local_rotation(var_7_10, 0)
			local var_7_13 = World.spawn_unit(arg_7_0.world, "units/weapons/player/wpn_shadow_gargoyle_head/wpn_shadow_gargoyle_head", var_7_11, var_7_12)
			local var_7_14 = Unit.light(var_7_13, "light")

			Light.set_falloff_end(var_7_14, arg_7_1.light_radius)
			Light.set_falloff_start(var_7_14, arg_7_1.light_radius - 1)
			World.link_unit(arg_7_0.world, var_7_13, 0, var_7_10, 0)

			arg_7_1.light_spawned = true
		end

		if not var_7_10 and not arg_7_1.light_spawned then
			return
		end

		local var_7_15 = var_7_9:local_player()
		local var_7_16 = var_7_15:observed_unit()

		if not ALIVE[var_7_16] then
			var_7_16 = var_7_15.player_unit
		end

		for iter_7_0 = 1, var_0_0 do
			var_0_2 = var_0_2 + 1

			local var_7_17 = var_7_3[var_0_2]

			if var_7_17 then
				local var_7_18 = POSITION_LOOKUP[var_7_17]
				local var_7_19 = 1

				if not var_7_6[var_7_17] and HEALTH_ALIVE[var_7_17] then
					var_7_4:set_min_fade(var_7_17, var_7_19)

					var_7_6[var_7_17] = var_7_19

					local var_7_20 = ScriptUnit.has_extension(var_7_17, "projectile_linker_system")

					if var_7_20 then
						local var_7_21 = arg_7_0.world
						local var_7_22 = World.spawn_unit(var_7_21, "units/fx/vfx_static_shadow_01", var_7_18)

						var_7_20:link_projectile(var_7_22, Vector3(0, 0, 0), Quaternion.identity(), 0)

						local var_7_23 = Unit.get_data(var_7_17, "breed")

						if var_7_23 and var_7_23.name == "skaven_warpfire_thrower" then
							Unit.flow_event(var_7_17, "disable_vfx")
						end

						var_7_7[var_7_17] = var_7_22
						var_7_8[var_7_17] = true
					end
				end

				local var_7_24 = arg_7_1.light_radius
				local var_7_25 = POSITION_LOOKUP[var_7_16]
				local var_7_26 = var_7_25 and Vector3.distance_squared(var_7_25, var_7_18) or var_7_24 * var_7_24
				local var_7_27 = var_7_7[var_7_17]
				local var_7_28 = var_7_8[var_7_17]

				if var_7_26 < var_7_24 * var_7_24 or not HEALTH_ALIVE[var_7_17] then
					var_7_19 = 0

					if var_7_27 and var_7_28 then
						local var_7_29 = Unit.get_data(var_7_17, "breed")

						if var_7_29 and var_7_29.name == "skaven_warpfire_thrower" and HEALTH_ALIVE[var_7_17] then
							Unit.flow_event(var_7_17, "enable_vfx")
						end

						if Unit.alive(var_7_27) then
							Unit.flow_event(var_7_27, "lua_shadow_effect_off")
						end

						if Unit.alive(var_7_17) then
							WwiseUtils.trigger_unit_event(arg_7_0.world, "Play_winds_shadow_reveal_enemy", var_7_17)
						end

						var_7_8[var_7_17] = false
					end
				elseif var_7_27 and not var_7_28 then
					local var_7_30 = Unit.get_data(var_7_17, "breed")

					if var_7_30 and var_7_30.name == "skaven_warpfire_thrower" then
						Unit.flow_event(var_7_17, "disable_vfx")
					end

					Unit.flow_event(var_7_27, "lua_shadow_effect_on")

					var_7_8[var_7_17] = true
				end

				if var_7_19 ~= var_7_6[var_7_17] then
					var_7_4:set_min_fade(var_7_17, var_7_19)

					var_7_6[var_7_17] = var_7_19
				end
			else
				var_0_2 = 0
			end
		end

		if #var_0_3 > 0 then
			table.clear(var_0_3)
		end

		for iter_7_1, iter_7_2 in pairs(var_7_6) do
			if not HEALTH_ALIVE[iter_7_1] then
				var_0_3[#var_0_3 + 1] = iter_7_1
			end
		end

		for iter_7_3 = 1, #var_0_3 do
			local var_7_31 = var_0_3[iter_7_3]

			var_7_6[var_7_31] = nil

			local var_7_32 = var_7_7[var_7_31]

			if Unit.alive(var_7_32) then
				World.destroy_unit(arg_7_0.world, var_7_32)
			end
		end
	end
}
