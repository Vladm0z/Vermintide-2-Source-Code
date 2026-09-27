-- chunkname: @scripts/unit_extensions/weapons/area_damage/area_damage_templates.lua

AreaDamageTemplates = {}

local tbl = {}

AreaDamageTemplates.templates = {
	globadier_area_dot_damage = {
		server = {
			update = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10, arg_1_11)
				-- function 1
				if arg_1_4 < arg_1_5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_1_1)

					return false
				end

				local local_position = Unit.local_position(arg_1_1, 0)

				if not (not (arg_1_7 >= 0) or not (arg_1_7 < arg_1_6)) then
					return false
				end

				local tbl = {}

				if not arg_1_8 then
					for k, v in pairs(Managers.player:players()) do
						local player_unit = v.player_unit

						if not (player_unit == nil or not (BLACKBOARDS[player_unit].breed.poison_resistance < 100)) then
							local var_1_3 = POSITION_LOOKUP[player_unit]

							if not (arg_1_2 > Vector3.distance(var_1_3, local_position)) then
								local tbl_2 = {
									area_damage_template = "globadier_area_dot_damage",
									unit = player_unit,
									damage = arg_1_3,
									damage_source = arg_1_0
								}

								tbl[#tbl + 1] = tbl_2
							end
						end
					end
				end

				return true, tbl
			end,
			do_damage = function (self, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				local unit = self.unit
				local damage = self.damage
				local damage_source = self.damage_source
				local var_2_3

				DamageUtils.add_damage_network(unit, arg_2_1, damage, "torso", "damage_over_time", nil, Vector3(1, 0, 0), damage_source, var_2_3, arg_2_2, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				local has_extension = ScriptUnit.has_extension(unit, "status_system")

				if not (not has_extension and not (damage > 0)) then
					local parent = arg_2_3.parent

					has_extension:hit_by_globadier_poison(parent)
				end
			end
		},
		client = {
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
				-- function 3
				if Development.parameter("screen_space_player_camera_reactions") == false then
					return
				end

				for k, v in pairs(Managers.player:players()) do
					local player_unit = v.player_unit

					if not (not v.local_player and not Unit.alive(player_unit) and not arg_3_5 and arg_3_3 == nil or ScriptUnit.extension(player_unit, "buff_system"):has_buff_type("poison_screen_effect_immune")) then
						local var_3_1 = POSITION_LOOKUP[player_unit]
						local local_position = Unit.local_position(arg_3_2, 0)
						local flag = Vector3.distance_squared(var_3_1, local_position) < arg_3_1 * arg_3_1
						local time = Managers.time:time("game")

						if not (not flag and arg_3_4[player_unit]) then
							local create_particles = World.create_particles(arg_3_0, arg_3_3, Vector3(0, 0, 0))

							arg_3_4[player_unit] = {
								particle_id = create_particles,
								start_time = time
							}
						elseif not (not flag and not (time >= arg_3_4[player_unit].start_time + 5)) then
							local particle_id = arg_3_4[player_unit].particle_id

							World.stop_spawning_particles(arg_3_0, particle_id)

							arg_3_4[player_unit] = nil
						elseif not ((flag or not arg_3_4[player_unit]) and arg_3_4[player_unit].fade_time) then
							local particle_id_2 = arg_3_4[player_unit].particle_id

							World.stop_spawning_particles(arg_3_0, particle_id_2)

							local create_particles_2 = World.create_particles(arg_3_0, arg_3_3, Vector3(0, 0, 0))

							arg_3_4[player_unit].fade_time = time + 1.5
							arg_3_4[player_unit].particle_id = create_particles_2
						elseif not ((flag or not arg_3_4[player_unit]) and not (time >= arg_3_4[player_unit].fade_time)) then
							local particle_id_3 = arg_3_4[player_unit].particle_id

							World.stop_spawning_particles(arg_3_0, particle_id_3)

							arg_3_4[player_unit] = nil
						end
					end
				end
			end,
			spawn_effect = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				local local_position = Unit.local_position(arg_4_1, 0)
				local create_particles = World.create_particles(arg_4_0, arg_4_2, local_position)

				if arg_4_3 ~= nil then
					for k, v in pairs(arg_4_3) do
						local find_particles_variable = World.find_particles_variable(arg_4_0, arg_4_2, v.particle_variable)

						World.set_particles_variable(arg_4_0, create_particles, find_particles_variable, v.value)
					end
				end

				return create_particles
			end,
			destroy = function ()
				-- function 5
				return
			end
		}
	},
	sorcerer_area_dot_damage = {
		server = {
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
				-- function 6
				if arg_6_4 < arg_6_5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_6_1)

					return false
				end

				local local_position = Unit.local_position(arg_6_1, 0)

				if not (not (arg_6_7 >= 0) or not (arg_6_7 < arg_6_6)) then
					return false
				end

				local tbl = {}

				if not arg_6_8 then
					for k, v in pairs(Managers.player:players()) do
						local player_unit = v.player_unit

						if not (player_unit == nil or not (BLACKBOARDS[player_unit].breed.poison_resistance < 100)) then
							local var_6_3 = POSITION_LOOKUP[player_unit]

							if not (arg_6_2 > Vector3.distance(var_6_3, local_position)) then
								local tbl_2 = {
									area_damage_template = "sorcerer_area_dot_damage",
									unit = player_unit,
									damage = arg_6_3,
									damage_source = arg_6_0
								}

								tbl[#tbl + 1] = tbl_2
							end
						end
					end
				end

				return true, tbl
			end,
			do_damage = function (self, arg_7_1, arg_7_2)
				-- function 7
				local unit = self.unit
				local damage = self.damage
				local damage_source = self.damage_source
				local var_7_3

				DamageUtils.add_damage_network(unit, unit, damage, "torso", "damage_over_time", nil, Vector3(1, 0, 0), damage_source, var_7_3, arg_7_2, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		},
		client = {
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
				-- function 8
				if Development.parameter("screen_space_player_camera_reactions") == false then
					return
				end

				for k, v in pairs(Managers.player:players()) do
					local player_unit = v.player_unit

					if not (not v.local_player and not Unit.alive(player_unit) and not arg_8_5 and arg_8_3 == nil or ScriptUnit.extension(player_unit, "buff_system"):has_buff_type("poison_screen_effect_immune")) then
						local var_8_1 = POSITION_LOOKUP[player_unit]
						local local_position = Unit.local_position(arg_8_2, 0)
						local flag = Vector3.distance_squared(var_8_1, local_position) < arg_8_1 * arg_8_1
						local time = Managers.time:time("game")

						if not (not flag and arg_8_4[player_unit]) then
							local create_particles = World.create_particles(arg_8_0, arg_8_3, Vector3(0, 0, 0))

							arg_8_4[player_unit] = {
								particle_id = create_particles,
								start_time = time
							}
						elseif not (not flag and not (time >= arg_8_4[player_unit].start_time + 5)) then
							local particle_id = arg_8_4[player_unit].particle_id

							World.stop_spawning_particles(arg_8_0, particle_id)

							arg_8_4[player_unit] = nil
						elseif not ((flag or not arg_8_4[player_unit]) and arg_8_4[player_unit].fade_time) then
							local particle_id_2 = arg_8_4[player_unit].particle_id

							World.stop_spawning_particles(arg_8_0, particle_id_2)

							local create_particles_2 = World.create_particles(arg_8_0, arg_8_3, Vector3(0, 0, 0))

							arg_8_4[player_unit].fade_time = time + 1.5
							arg_8_4[player_unit].particle_id = create_particles_2
						elseif not ((flag or not arg_8_4[player_unit]) and not (time >= arg_8_4[player_unit].fade_time)) then
							local particle_id_3 = arg_8_4[player_unit].particle_id

							World.stop_spawning_particles(arg_8_0, particle_id_3)

							arg_8_4[player_unit] = nil
						end
					end
				end
			end,
			spawn_effect = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				local local_position = Unit.local_position(arg_9_1, 0)
				local create_particles = World.create_particles(arg_9_0, arg_9_2, local_position)

				if arg_9_3 ~= nil then
					for k, v in pairs(arg_9_3) do
						local find_particles_variable = World.find_particles_variable(arg_9_0, arg_9_2, v.particle_variable)

						World.set_particles_variable(arg_9_0, create_particles, find_particles_variable, v.value)
					end
				end

				return create_particles
			end,
			destroy = function ()
				-- function 10
				return
			end
		}
	},
	explosion_template_aoe = {
		server = {
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11)
				-- function 11
				if arg_11_4 < arg_11_5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_11_1)

					return false
				end

				local world_position = Unit.world_position(arg_11_1, 0)
				local get_template = ExplosionUtils.get_template(arg_11_9)
				local aoe = get_template.aoe

				if get_template.friendly_fire ~= nil then
					friendly_fire_data = get_template.friendly_fire
				end

				local attack_template = aoe.attack_template
				local gravity_well = aoe.gravity_well
				local var_11_5

				if not ((attack_template or not gravity_well) and arg_11_7 <= 0 or not (arg_11_6 <= arg_11_7)) then
					local enemy_broadphase_categories = arg_11_11.enemy_broadphase_categories

					var_11_5 = AiUtils.broadphase_query(world_position, arg_11_2, tbl, enemy_broadphase_categories)
				end

				if not gravity_well and not var_11_5 then
					local time = Managers.time:time("game")
					local num = arg_11_6 * 2
					local strength = gravity_well.strength
					local num_2 = world_position + Vector3(0, 0, gravity_well.z_offset)
					local BLACKBOARDS = BLACKBOARDS

					for i = 1, var_11_5 do
						local var_11_12 = BLACKBOARDS[tbl[i]]

						if not var_11_12.gravity_well_position then
							var_11_12.gravity_well_position:store(num_2)
						else
							var_11_12.gravity_well_position = Vector3Box(num_2)
						end

						var_11_12.gravity_well_strength = strength
						var_11_12.gravity_well_time = time + num
					end
				end

				if not attack_template and not var_11_5 then
					local tbl_2 = {}
					local str = "full"

					for j = 1, var_11_5 do
						local var_11_15 = tbl[j]
						local tbl_3 = {
							area_damage_template = "explosion_template_aoe",
							unit = var_11_15,
							damage_source = arg_11_0,
							hit_zone_name = str,
							aoe_data = aoe
						}

						tbl_2[#tbl_2 + 1] = tbl_3
					end

					if not arg_11_8 then
						local ENEMY_PLAYER_AND_BOT_UNITS = arg_11_11.ENEMY_PLAYER_AND_BOT_UNITS

						for i_2, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
							local var_11_18 = POSITION_LOOKUP[v]
							local flag = arg_11_2 > Vector3.distance(var_11_18, world_position)
							local has_extension = ScriptUnit.has_extension(v, "ghost_mode_system")
							local flag_2 = not has_extension and has_extension:is_in_ghost_mode()

							if not (not flag and flag_2) then
								local tbl_4 = {
									area_damage_template = "explosion_template_aoe",
									unit = v,
									damage_source = arg_11_0,
									hit_zone_name = str,
									aoe_data = aoe
								}

								tbl_2[#tbl_2 + 1] = tbl_4
							end
						end
					end

					return true, tbl_2
				end
			end,
			do_damage = function (self, arg_12_1, arg_12_2)
				-- function 12
				local unit = self.unit
				local var_12_1 = arg_12_1
				local hit_zone_name = self.hit_zone_name
				local damage_source = self.damage_source
				local aoe_data = self.aoe_data
				local alloc_table = FrameTable.alloc_table()

				alloc_table.dot_template_name = aoe_data.dot_template_name
				alloc_table.dot_balefire_variant = aoe_data.dot_balefire_variant

				local var_12_6
				local var_12_7
				local var_12_8
				local var_12_9
				local var_12_10

				DamageUtils.apply_dot(var_12_6, var_12_7, var_12_8, unit, var_12_1, hit_zone_name, damage_source, var_12_9, var_12_10, aoe_data, arg_12_2, alloc_table)
			end
		},
		client = {
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
				-- function 13
				return
			end,
			spawn_effect = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local flag = arg_14_4 or Unit.world_position(arg_14_1, 0)
				local create_particles = World.create_particles(arg_14_0, arg_14_2, flag)

				if arg_14_3 ~= nil then
					for k, v in pairs(arg_14_3) do
						local find_particles_variable = World.find_particles_variable(arg_14_0, arg_14_2, v.particle_variable)

						World.set_particles_variable(arg_14_0, create_particles, find_particles_variable, v.value)
					end
				end

				return create_particles
			end
		}
	},
	area_poison_ai_random_death = {
		server = {
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				if not (not (arg_15_4 > 0) or not (arg_15_4 < arg_15_3)) then
					return false
				end

				local world_position = Unit.world_position(arg_15_1, 0)
				local tbl_2 = {}
				local broadphase_query = AiUtils.broadphase_query(world_position, arg_15_2, tbl)

				for i = 1, broadphase_query do
					local var_15_3 = tbl[i]

					if not (not HEALTH_ALIVE[var_15_3] and not (math.random(1, 100) <= 100 - Unit.get_data(var_15_3, "breed").poison_resistance)) then
						local tbl_3 = {
							area_damage_template = "area_poison_ai_random_death",
							unit = var_15_3
						}

						tbl_2[#tbl_2 + 1] = tbl_3
					end
				end

				return true, tbl_2
			end,
			do_damage = function (self, arg_16_1, arg_16_2)
				-- function 16
				local network = Managers.state.network
				local unit = self.unit
				local MAX_POWER_LEVEL = MAX_POWER_LEVEL
				local world_position = Unit.world_position(arg_16_1, 0)
				local var_16_4 = POSITION_LOOKUP[unit]
				local normalize = Vector3.normalize(var_16_4 - world_position)
				local str = "skaven_poison_wind_globadier"
				local var_16_7 = NetworkLookup.damage_sources[str]
				local str_2 = "globadier_gas_cloud"
				local var_16_9 = NetworkLookup.damage_profiles[str_2]
				local unit_game_object_id = network:unit_game_object_id(unit)
				local str_3 = "full"
				local var_16_12 = NetworkLookup.hit_zones[str_3]

				Managers.state.entity:system("weapon_system"):send_rpc_attack_hit(var_16_7, unit_game_object_id, unit_game_object_id, var_16_12, world_position, normalize, var_16_9, "power_level", MAX_POWER_LEVEL, "hit_target_index", nil, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", 0, "is_critical_strike", false)

				if not (not DamageUtils.is_ai(unit) and HEALTH_ALIVE[unit]) then
					QuestSettings.check_num_enemies_killed_by_poison(unit, arg_16_1)
				end
			end
		}
	},
	mutator_life_poison = {
		server = {
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
				-- function 17
				if arg_17_4 < arg_17_5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_17_1)

					return false
				end

				local local_position = Unit.local_position(arg_17_1, 0)

				if not (not (arg_17_7 >= 0) or not (arg_17_7 < arg_17_6)) then
					return false
				end

				local tbl = {}

				if not arg_17_8 then
					for k, v in pairs(Managers.player:players()) do
						local player_unit = v.player_unit

						if not (player_unit == nil or not (BLACKBOARDS[player_unit].breed.poison_resistance < 100)) then
							local var_17_3 = POSITION_LOOKUP[player_unit]

							if not (arg_17_2 > Vector3.distance(var_17_3, local_position)) then
								local tbl_2 = {
									area_damage_template = "mutator_life_poison",
									unit = player_unit,
									damage = arg_17_3,
									damage_source = arg_17_0
								}

								tbl[#tbl + 1] = tbl_2
							end
						end
					end
				end

				return true, tbl
			end,
			do_damage = function (self, arg_18_1)
				-- function 18
				local unit = self.unit
				local damage = self.damage
				local damage_source = self.damage_source

				DamageUtils.add_damage_network(unit, arg_18_1, damage, "torso", "damage_over_time", nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		},
		client = {
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7)
				-- function 19
				if Development.parameter("screen_space_player_camera_reactions") == false then
					return
				end

				for k, v in pairs(Managers.player:players()) do
					local player_unit = v.player_unit

					if not (not v.local_player and not Unit.alive(player_unit) and not arg_19_5 and arg_19_3 == nil or ScriptUnit.extension(player_unit, "buff_system"):has_buff_type("poison_screen_effect_immune")) then
						local var_19_1 = POSITION_LOOKUP[player_unit]
						local local_position = Unit.local_position(arg_19_2, 0)
						local flag = Vector3.distance_squared(var_19_1, local_position) < arg_19_1 * arg_19_1
						local time = Managers.time:time("game")

						if ScorpionSeasonalSettings.current_season_id ~= 1 or not flag then
							local statistics_db = Managers.player:statistics_db()
							local stats_id = v:stats_id()
							local str = "weave_life_stepped_in_bush"

							statistics_db:increment_stat(stats_id, "season_1", str)
						end

						if not (not flag and arg_19_4[player_unit]) then
							local create_particles = World.create_particles(arg_19_0, arg_19_3, Vector3(0, 0, 0))

							arg_19_4[player_unit] = {
								particle_id = create_particles,
								start_time = time
							}
						elseif not (not flag and not (time >= arg_19_4[player_unit].start_time + 5)) then
							local particle_id = arg_19_4[player_unit].particle_id

							World.stop_spawning_particles(arg_19_0, particle_id)

							arg_19_4[player_unit] = nil
						elseif not ((flag or not arg_19_4[player_unit]) and arg_19_4[player_unit].fade_time) then
							local particle_id_2 = arg_19_4[player_unit].particle_id

							World.stop_spawning_particles(arg_19_0, particle_id_2)

							local create_particles_2 = World.create_particles(arg_19_0, arg_19_3, Vector3(0, 0, 0))

							arg_19_4[player_unit].fade_time = time + 1.5
							arg_19_4[player_unit].particle_id = create_particles_2
						elseif not ((flag or not arg_19_4[player_unit]) and not (time >= arg_19_4[player_unit].fade_time)) then
							local particle_id_3 = arg_19_4[player_unit].particle_id

							World.stop_spawning_particles(arg_19_0, particle_id_3)

							arg_19_4[player_unit] = nil
						end
					end
				end
			end,
			spawn_effect = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				local local_position = Unit.local_position(arg_20_1, 0)
				local create_particles = World.create_particles(arg_20_0, arg_20_2, local_position)

				if arg_20_3 ~= nil then
					for k, v in pairs(arg_20_3) do
						local find_particles_variable = World.find_particles_variable(arg_20_0, arg_20_2, v.particle_variable)

						World.set_particles_variable(arg_20_0, create_particles, find_particles_variable, v.value)
					end
				end

				return create_particles
			end,
			destroy = function ()
				-- function 21
				return
			end
		}
	}
}

AreaDamageTemplates.get_template = function (arg_22_0, arg_22_1)
	-- function 22
	local templates = AreaDamageTemplates.templates
	local flag

	flag = (arg_22_1 ~= true or not "husk" or arg_22_1 ~= false) and (not "unit" or nil)

	local var_22_2

	if not flag then
		var_22_2 = templates[arg_22_0][flag]

		if not var_22_2 then
			-- Nothing
		end
	end

	var_22_2 = templates[arg_22_0]

	::label_22_0::

	fassert(var_22_2, "no area_damage_template called %s", arg_22_0)

	return var_22_2
end

DLCUtils.merge("area_damage_templates", AreaDamageTemplates.templates)
