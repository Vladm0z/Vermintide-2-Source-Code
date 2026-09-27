-- chunkname: @scripts/settings/mutators/mutator_curse_belakors_shadows.lua

local num = 5
local num_2 = 0
local num_3 = 0
local tbl = {}

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
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		local get_wind_strength = Managers.weave:get_wind_strength()

		get_wind_strength = get_wind_strength or 1

		local get_active_wind_settings = Managers.weave:get_active_wind_settings()
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_1_1.buff_system = Managers.state.entity:system("buff_system")
		arg_1_1.hero_side = Managers.state.side:get_side_from_name("heroes")
		arg_1_1.lantern_spawned = false
		arg_1_1.light_radius = not get_active_wind_settings and get_active_wind_settings.light_radius[get_difficulty][get_wind_strength]
	end,
	server_update_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local hero_side = arg_2_1.hero_side
		local enemy_units = hero_side:enemy_units()
		local template = arg_2_1.template
		local buffed_units = template.buffed_units
		local buff_params = template.buff_params
		local PLAYER_UNITS = hero_side.PLAYER_UNITS

		for i = 1, num do
			num_2 = num_2 + 1

			local var_2_6 = enemy_units[num_2]
			local flag = false

			if not var_2_6 then
				for k, v in pairs(PLAYER_UNITS) do
					local light_radius = arg_2_1.light_radius
					local var_2_9 = POSITION_LOOKUP[v]

					if not ScriptUnit.has_extension(var_2_6, "buff_system") and not HEALTH_ALIVE[var_2_6] then
						local var_2_10 = POSITION_LOOKUP[var_2_6]

						if Vector3.distance_squared(var_2_9, var_2_10) <= light_radius * light_radius then
							flag = true

							break
						end
					end
				end

				local has_extension = ScriptUnit.has_extension(var_2_6, "buff_system")

				if not has_extension then
					local has_buff_type = has_extension:has_buff_type("mutator_shadow_damage_reduction")

					if not flag then
						if not has_buff_type and not buffed_units[var_2_6] then
							local var_2_13 = buffed_units[var_2_6]

							arg_2_1.buff_system:remove_server_controlled_buff(var_2_6, var_2_13)

							buffed_units[var_2_6] = nil
						end
					else
						local has_extension_2 = ScriptUnit.has_extension(var_2_6, "ping_system")

						if not has_extension_2 and not has_extension_2:pinged() then
							Managers.state.entity:system("ping_system"):remove_ping_from_unit(var_2_6)
						end

						if not has_buff_type then
							buffed_units[var_2_6] = arg_2_1.buff_system:add_buff(var_2_6, "mutator_shadow_damage_reduction", var_2_6, true)
						end
					end
				end
			else
				num_2 = 0
			end
		end

		if #tbl > 0 then
			table.clear(tbl)
		end

		for k_2, v_2 in pairs(buffed_units) do
			if not HEALTH_ALIVE[k_2] then
				tbl[#tbl + 1] = k_2
			end
		end

		for i5 = 1, #tbl do
			buffed_units[tbl[i5]] = nil
		end
	end,
	client_start_function = function (arg_3_0, arg_3_1)
		-- function 3
		arg_3_1.hero_side = Managers.state.side:get_side_from_name("heroes")
		arg_3_1.light_spawned = false
	end,
	client_player_respawned_function = function (self, arg_4_1, arg_4_2)
		-- function 4
		local player_unit = Managers.player:local_player().player_unit

		if arg_4_2 == player_unit then
			local local_position = Unit.local_position(player_unit, 0)
			local local_rotation = Unit.local_rotation(player_unit, 0)
			local spawn_unit = World.spawn_unit(self.world, "units/weapons/player/wpn_shadow_gargoyle_head/wpn_shadow_gargoyle_head", local_position, local_rotation)
			local light = Unit.light(spawn_unit, "light")

			Light.set_falloff_end(light, arg_4_1.light_radius)
			Light.set_falloff_start(light, arg_4_1.light_radius - 1)
			World.link_unit(self.world, spawn_unit, 0, player_unit, 0)
		end
	end,
	client_update_function = function (self, arg_5_1)
		-- function 5
		local get_wind_strength = Managers.weave:get_wind_strength()

		get_wind_strength = get_wind_strength or 1

		local get_active_wind_settings = Managers.weave:get_active_wind_settings()
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local enemy_units = arg_5_1.hero_side:enemy_units()
		local system = Managers.state.entity:system("fade_system")
		local template = arg_5_1.template
		local faded_units = template.faded_units
		local linked_units = template.linked_units
		local linked_units_visibility = template.linked_units_visibility
		local player = Managers.player
		local player_unit = player:local_player().player_unit
		local var_5_11

		if not get_active_wind_settings then
			var_5_11 = get_active_wind_settings.light_radius[get_difficulty][get_wind_strength]

			if not var_5_11 then
				-- Nothing
			end
		end

		var_5_11 = 6

		::label_5_0::

		arg_5_1.light_radius = var_5_11

		if not (not player_unit and arg_5_1.light_spawned) then
			local local_position = Unit.local_position(player_unit, 0)
			local local_rotation = Unit.local_rotation(player_unit, 0)
			local spawn_unit = World.spawn_unit(self.world, "units/weapons/player/wpn_shadow_gargoyle_head/wpn_shadow_gargoyle_head", local_position, local_rotation)
			local light = Unit.light(spawn_unit, "light")

			Light.set_falloff_end(light, arg_5_1.light_radius)
			Light.set_falloff_start(light, arg_5_1.light_radius - 1)
			World.link_unit(self.world, spawn_unit, 0, player_unit, 0)

			arg_5_1.light_spawned = true
		end

		if not (player_unit or arg_5_1.light_spawned) then
			return
		end

		local local_player = player:local_player()
		local observed_unit = local_player:observed_unit()

		if not ALIVE[observed_unit] then
			observed_unit = local_player.player_unit
		end

		for i = 1, num do
			num_3 = num_3 + 1

			local var_5_18 = enemy_units[num_3]

			if not var_5_18 then
				local var_5_19 = POSITION_LOOKUP[var_5_18]
				local num_2 = 1

				if faded_units[var_5_18] or not HEALTH_ALIVE[var_5_18] then
					system:set_min_fade(var_5_18, num_2)

					faded_units[var_5_18] = num_2

					local has_extension = ScriptUnit.has_extension(var_5_18, "projectile_linker_system")

					if not has_extension then
						local world = self.world
						local spawn_unit_2 = World.spawn_unit(world, "units/fx/vfx_static_shadow_01", var_5_19)

						has_extension:link_projectile(spawn_unit_2, Vector3(0, 0, 0), Quaternion.identity(), 0)

						local get_data = Unit.get_data(var_5_18, "breed")

						if not (not get_data and get_data.name ~= "skaven_warpfire_thrower") then
							Unit.flow_event(var_5_18, "disable_vfx")
						end

						linked_units[var_5_18] = spawn_unit_2
						linked_units_visibility[var_5_18] = true
					end
				end

				local light_radius = arg_5_1.light_radius
				local var_5_26 = POSITION_LOOKUP[observed_unit]
				local distance_squared

				if not var_5_26 then
					distance_squared = Vector3.distance_squared(var_5_26, var_5_19)

					if not distance_squared then
						-- Nothing
					end
				end

				distance_squared = light_radius * light_radius

				::label_5_1::

				local var_5_28 = linked_units[var_5_18]
				local var_5_29 = linked_units_visibility[var_5_18]

				if not (distance_squared < light_radius * light_radius or HEALTH_ALIVE[var_5_18]) then
					num_2 = 0

					if not var_5_28 and not var_5_29 then
						local get_data_2 = Unit.get_data(var_5_18, "breed")

						if not get_data_2 and get_data_2.name ~= "skaven_warpfire_thrower" or not HEALTH_ALIVE[var_5_18] then
							Unit.flow_event(var_5_18, "enable_vfx")
						end

						if not Unit.alive(var_5_28) then
							Unit.flow_event(var_5_28, "lua_shadow_effect_off")
						end

						if not Unit.alive(var_5_18) then
							WwiseUtils.trigger_unit_event(self.world, "Play_winds_shadow_reveal_enemy", var_5_18)
						end

						linked_units_visibility[var_5_18] = false
					end
				elseif not (not var_5_28 and var_5_29) then
					local get_data_3 = Unit.get_data(var_5_18, "breed")

					if not (not get_data_3 and get_data_3.name ~= "skaven_warpfire_thrower") then
						Unit.flow_event(var_5_18, "disable_vfx")
					end

					Unit.flow_event(var_5_28, "lua_shadow_effect_on")

					linked_units_visibility[var_5_18] = true
				end

				if num_2 ~= faded_units[var_5_18] then
					system:set_min_fade(var_5_18, num_2)

					faded_units[var_5_18] = num_2
				end
			else
				num_3 = 0
			end
		end

		if #tbl > 0 then
			table.clear(tbl)
		end

		for k, v in pairs(faded_units) do
			if not HEALTH_ALIVE[k] then
				tbl[#tbl + 1] = k
			end
		end

		for l = 1, #tbl do
			local var_5_32 = tbl[l]

			faded_units[var_5_32] = nil

			local var_5_33 = linked_units[var_5_32]

			if not Unit.alive(var_5_33) then
				World.destroy_unit(self.world, var_5_33)
			end
		end
	end
}
