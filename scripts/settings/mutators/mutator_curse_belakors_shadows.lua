-- chunkname: @scripts/settings/mutators/mutator_curse_belakors_shadows.lua

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
	server_update_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = arg_2_1.hero_side
		local var_2_1 = var_2_0:enemy_units()
		local var_2_2 = arg_2_1.template
		local var_2_3 = var_2_2.buffed_units
		local var_2_4 = var_2_2.buff_params
		local var_2_5 = var_2_0.PLAYER_UNITS

		for iter_2_0 = 1, var_0_0 do
			var_0_1 = var_0_1 + 1

			local var_2_6 = var_2_1[var_0_1]
			local var_2_7 = false

			if var_2_6 then
				for iter_2_1, iter_2_2 in pairs(var_2_5) do
					local var_2_8 = arg_2_1.light_radius
					local var_2_9 = POSITION_LOOKUP[iter_2_2]

					if ScriptUnit.has_extension(var_2_6, "buff_system") and HEALTH_ALIVE[var_2_6] then
						local var_2_10 = POSITION_LOOKUP[var_2_6]

						if Vector3.distance_squared(var_2_9, var_2_10) <= var_2_8 * var_2_8 then
							var_2_7 = true

							break
						end
					end
				end

				local var_2_11 = ScriptUnit.has_extension(var_2_6, "buff_system")

				if var_2_11 then
					local var_2_12 = var_2_11:has_buff_type("mutator_shadow_damage_reduction")

					if var_2_7 then
						if var_2_12 and var_2_3[var_2_6] then
							local var_2_13 = var_2_3[var_2_6]

							arg_2_1.buff_system:remove_server_controlled_buff(var_2_6, var_2_13)

							var_2_3[var_2_6] = nil
						end
					else
						local var_2_14 = ScriptUnit.has_extension(var_2_6, "ping_system")

						if var_2_14 and var_2_14:pinged() then
							Managers.state.entity:system("ping_system"):remove_ping_from_unit(var_2_6)
						end

						if not var_2_12 then
							var_2_3[var_2_6] = arg_2_1.buff_system:add_buff(var_2_6, "mutator_shadow_damage_reduction", var_2_6, true)
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

		for iter_2_3, iter_2_4 in pairs(var_2_3) do
			if not HEALTH_ALIVE[iter_2_3] then
				var_0_3[#var_0_3 + 1] = iter_2_3
			end
		end

		for iter_2_5 = 1, #var_0_3 do
			var_2_3[var_0_3[iter_2_5]] = nil
		end
	end,
	client_start_function = function(arg_3_0, arg_3_1)
		arg_3_1.hero_side = Managers.state.side:get_side_from_name("heroes")
		arg_3_1.light_spawned = false
	end,
	client_player_respawned_function = function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = Managers.player:local_player().player_unit

		if arg_4_2 == var_4_0 then
			local var_4_1 = Unit.local_position(var_4_0, 0)
			local var_4_2 = Unit.local_rotation(var_4_0, 0)
			local var_4_3 = World.spawn_unit(arg_4_0.world, "units/weapons/player/wpn_shadow_gargoyle_head/wpn_shadow_gargoyle_head", var_4_1, var_4_2)
			local var_4_4 = Unit.light(var_4_3, "light")

			Light.set_falloff_end(var_4_4, arg_4_1.light_radius)
			Light.set_falloff_start(var_4_4, arg_4_1.light_radius - 1)
			World.link_unit(arg_4_0.world, var_4_3, 0, var_4_0, 0)
		end
	end,
	client_update_function = function(arg_5_0, arg_5_1)
		local var_5_0 = Managers.weave:get_wind_strength() or 1
		local var_5_1 = Managers.weave:get_active_wind_settings()
		local var_5_2 = Managers.state.difficulty:get_difficulty()
		local var_5_3 = arg_5_1.hero_side:enemy_units()
		local var_5_4 = Managers.state.entity:system("fade_system")
		local var_5_5 = arg_5_1.template
		local var_5_6 = var_5_5.faded_units
		local var_5_7 = var_5_5.linked_units
		local var_5_8 = var_5_5.linked_units_visibility
		local var_5_9 = Managers.player
		local var_5_10 = var_5_9:local_player().player_unit

		arg_5_1.light_radius = var_5_1 and var_5_1.light_radius[var_5_2][var_5_0] or 6

		if var_5_10 and not arg_5_1.light_spawned then
			local var_5_11 = Unit.local_position(var_5_10, 0)
			local var_5_12 = Unit.local_rotation(var_5_10, 0)
			local var_5_13 = World.spawn_unit(arg_5_0.world, "units/weapons/player/wpn_shadow_gargoyle_head/wpn_shadow_gargoyle_head", var_5_11, var_5_12)
			local var_5_14 = Unit.light(var_5_13, "light")

			Light.set_falloff_end(var_5_14, arg_5_1.light_radius)
			Light.set_falloff_start(var_5_14, arg_5_1.light_radius - 1)
			World.link_unit(arg_5_0.world, var_5_13, 0, var_5_10, 0)

			arg_5_1.light_spawned = true
		end

		if not var_5_10 and not arg_5_1.light_spawned then
			return
		end

		local var_5_15 = var_5_9:local_player()
		local var_5_16 = var_5_15:observed_unit()

		if not ALIVE[var_5_16] then
			var_5_16 = var_5_15.player_unit
		end

		for iter_5_0 = 1, var_0_0 do
			var_0_2 = var_0_2 + 1

			local var_5_17 = var_5_3[var_0_2]

			if var_5_17 then
				local var_5_18 = POSITION_LOOKUP[var_5_17]
				local var_5_19 = 1

				if not var_5_6[var_5_17] and HEALTH_ALIVE[var_5_17] then
					var_5_4:set_min_fade(var_5_17, var_5_19)

					var_5_6[var_5_17] = var_5_19

					local var_5_20 = ScriptUnit.has_extension(var_5_17, "projectile_linker_system")

					if var_5_20 then
						local var_5_21 = arg_5_0.world
						local var_5_22 = World.spawn_unit(var_5_21, "units/fx/vfx_static_shadow_01", var_5_18)

						var_5_20:link_projectile(var_5_22, Vector3(0, 0, 0), Quaternion.identity(), 0)

						local var_5_23 = Unit.get_data(var_5_17, "breed")

						if var_5_23 and var_5_23.name == "skaven_warpfire_thrower" then
							Unit.flow_event(var_5_17, "disable_vfx")
						end

						var_5_7[var_5_17] = var_5_22
						var_5_8[var_5_17] = true
					end
				end

				local var_5_24 = arg_5_1.light_radius
				local var_5_25 = POSITION_LOOKUP[var_5_16]
				local var_5_26 = var_5_25 and Vector3.distance_squared(var_5_25, var_5_18) or var_5_24 * var_5_24
				local var_5_27 = var_5_7[var_5_17]
				local var_5_28 = var_5_8[var_5_17]

				if var_5_26 < var_5_24 * var_5_24 or not HEALTH_ALIVE[var_5_17] then
					var_5_19 = 0

					if var_5_27 and var_5_28 then
						local var_5_29 = Unit.get_data(var_5_17, "breed")

						if var_5_29 and var_5_29.name == "skaven_warpfire_thrower" and HEALTH_ALIVE[var_5_17] then
							Unit.flow_event(var_5_17, "enable_vfx")
						end

						if Unit.alive(var_5_27) then
							Unit.flow_event(var_5_27, "lua_shadow_effect_off")
						end

						if Unit.alive(var_5_17) then
							WwiseUtils.trigger_unit_event(arg_5_0.world, "Play_winds_shadow_reveal_enemy", var_5_17)
						end

						var_5_8[var_5_17] = false
					end
				elseif var_5_27 and not var_5_28 then
					local var_5_30 = Unit.get_data(var_5_17, "breed")

					if var_5_30 and var_5_30.name == "skaven_warpfire_thrower" then
						Unit.flow_event(var_5_17, "disable_vfx")
					end

					Unit.flow_event(var_5_27, "lua_shadow_effect_on")

					var_5_8[var_5_17] = true
				end

				if var_5_19 ~= var_5_6[var_5_17] then
					var_5_4:set_min_fade(var_5_17, var_5_19)

					var_5_6[var_5_17] = var_5_19
				end
			else
				var_0_2 = 0
			end
		end

		if #var_0_3 > 0 then
			table.clear(var_0_3)
		end

		for iter_5_1, iter_5_2 in pairs(var_5_6) do
			if not HEALTH_ALIVE[iter_5_1] then
				var_0_3[#var_0_3 + 1] = iter_5_1
			end
		end

		for iter_5_3 = 1, #var_0_3 do
			local var_5_31 = var_0_3[iter_5_3]

			var_5_6[var_5_31] = nil

			local var_5_32 = var_5_7[var_5_31]

			if Unit.alive(var_5_32) then
				World.destroy_unit(arg_5_0.world, var_5_32)
			end
		end
	end
}
