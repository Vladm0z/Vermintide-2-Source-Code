-- chunkname: @scripts/unit_extensions/weapons/area_damage/area_damage_templates_vs.lua

local var_0_0 = DLCSettings.carousel
local var_0_1 = {}

var_0_0.area_damage_templates = {
	globadier_area_dot_damage_vs = {
		server = {
			update = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10, arg_1_11, arg_1_12)
				if arg_1_4 < arg_1_5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_1_1)

					return false
				end

				local var_1_0 = Unit.local_position(arg_1_1, 0)

				if arg_1_12 and not arg_1_12.baked_timer then
					arg_1_12.baked_timer = arg_1_6 / 2
				end

				if arg_1_12 and arg_1_12.baked_timer then
					if arg_1_7 >= 0 and arg_1_7 < arg_1_12.baked_timer then
						return false
					end
				elseif arg_1_7 >= 0 and arg_1_7 < arg_1_6 then
					return false
				end

				local var_1_1 = {}

				if arg_1_8 then
					for iter_1_0, iter_1_1 in pairs(Managers.player:players()) do
						local var_1_2 = iter_1_1.player_unit

						if var_1_2 ~= nil and BLACKBOARDS[var_1_2].breed.poison_resistance < 100 then
							local var_1_3 = POSITION_LOOKUP[var_1_2]

							if arg_1_2 > Vector3.distance(var_1_3, var_1_0) then
								local var_1_4 = {
									area_damage_template = "globadier_area_dot_damage_vs",
									unit = var_1_2,
									damage = arg_1_3,
									damage_source = arg_1_0
								}

								var_1_1[#var_1_1 + 1] = var_1_4
							end
						end
					end
				end

				return true, var_1_1
			end,
			do_damage = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				local var_2_0 = arg_2_0.unit
				local var_2_1 = arg_2_0.damage
				local var_2_2 = arg_2_0.damage_source
				local var_2_3

				if not arg_2_3.ramping_area_damage then
					arg_2_3.ramping_area_damage = {}
				end

				local var_2_4 = arg_2_3.ramping_area_damage

				if not var_2_4[var_2_0] then
					var_2_4[var_2_0] = 0.015
				else
					var_2_4[var_2_0] = var_2_4[var_2_0] * 2.5
				end

				if var_2_4[var_2_0] < 1 then
					var_2_1 = var_2_1 * var_2_4[var_2_0]
				end

				if DamageUtils.networkify_damage(var_2_1) > 0 then
					DamageUtils.add_damage_network(var_2_0, arg_2_1, var_2_1, "torso", "gas", nil, Vector3(1, 0, 0), var_2_2, var_2_3, arg_2_2, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end
		},
		client = {
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
				if Development.parameter("screen_space_player_camera_reactions") == false then
					return
				end

				for iter_3_0, iter_3_1 in pairs(Managers.player:players()) do
					local var_3_0 = iter_3_1.player_unit

					if iter_3_1.local_player and Unit.alive(var_3_0) and arg_3_5 and arg_3_3 ~= nil and not ScriptUnit.extension(var_3_0, "buff_system"):has_buff_type("poison_screen_effect_immune") then
						local var_3_1 = POSITION_LOOKUP[var_3_0]
						local var_3_2 = Unit.local_position(arg_3_2, 0)
						local var_3_3 = Vector3.distance_squared(var_3_1, var_3_2) < arg_3_1 * arg_3_1
						local var_3_4 = Managers.time:time("game")

						if var_3_3 and not arg_3_4[var_3_0] then
							local var_3_5 = World.create_particles(arg_3_0, arg_3_3, Vector3(0, 0, 0))

							arg_3_4[var_3_0] = {
								particle_id = var_3_5,
								start_time = var_3_4
							}
						elseif var_3_3 and var_3_4 >= arg_3_4[var_3_0].start_time + 5 then
							local var_3_6 = arg_3_4[var_3_0].particle_id

							World.stop_spawning_particles(arg_3_0, var_3_6)

							arg_3_4[var_3_0] = nil
						elseif not var_3_3 and arg_3_4[var_3_0] and not arg_3_4[var_3_0].fade_time then
							local var_3_7 = arg_3_4[var_3_0].particle_id

							World.stop_spawning_particles(arg_3_0, var_3_7)

							local var_3_8 = World.create_particles(arg_3_0, arg_3_3, Vector3(0, 0, 0))

							arg_3_4[var_3_0].fade_time = var_3_4 + 1.5
							arg_3_4[var_3_0].particle_id = var_3_8
						elseif not var_3_3 and arg_3_4[var_3_0] and var_3_4 >= arg_3_4[var_3_0].fade_time then
							local var_3_9 = arg_3_4[var_3_0].particle_id

							World.stop_spawning_particles(arg_3_0, var_3_9)

							arg_3_4[var_3_0] = nil
						end
					end
				end
			end,
			spawn_effect = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				local var_4_0 = Unit.local_position(arg_4_1, 0)
				local var_4_1 = World.create_particles(arg_4_0, arg_4_2, var_4_0)

				if arg_4_3 ~= nil then
					for iter_4_0, iter_4_1 in pairs(arg_4_3) do
						local var_4_2 = World.find_particles_variable(arg_4_0, arg_4_2, iter_4_1.particle_variable)

						World.set_particles_variable(arg_4_0, var_4_1, var_4_2, iter_4_1.value)
					end
				end

				return var_4_1
			end,
			destroy = function ()
				return
			end
		}
	},
	sorcerer_area_dot_damage_vs = {
		server = {
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
				if arg_6_4 < arg_6_5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_6_1)

					return false
				end

				local var_6_0 = Unit.local_position(arg_6_1, 0)

				if arg_6_7 >= 0 and arg_6_7 < arg_6_6 then
					return false
				end

				local var_6_1 = {}

				if arg_6_8 then
					for iter_6_0, iter_6_1 in pairs(Managers.player:players()) do
						local var_6_2 = iter_6_1.player_unit

						if var_6_2 ~= nil and BLACKBOARDS[var_6_2].breed.poison_resistance < 100 then
							local var_6_3 = POSITION_LOOKUP[var_6_2]

							if arg_6_2 > Vector3.distance(var_6_3, var_6_0) then
								local var_6_4 = {
									area_damage_template = "sorcerer_area_dot_damage",
									unit = var_6_2,
									damage = arg_6_3,
									damage_source = arg_6_0
								}

								var_6_1[#var_6_1 + 1] = var_6_4
							end
						end
					end
				end

				return true, var_6_1
			end,
			do_damage = function (arg_7_0, arg_7_1, arg_7_2)
				local var_7_0 = arg_7_0.unit
				local var_7_1 = arg_7_0.damage
				local var_7_2 = arg_7_0.damage_source
				local var_7_3

				DamageUtils.add_damage_network(var_7_0, arg_7_1, var_7_1, "torso", "damage_over_time", nil, Vector3(1, 0, 0), var_7_2, var_7_3, arg_7_2, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		},
		client = {
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
				if Development.parameter("screen_space_player_camera_reactions") == false then
					return
				end

				for iter_8_0, iter_8_1 in pairs(Managers.player:players()) do
					local var_8_0 = iter_8_1.player_unit

					if iter_8_1.local_player and Unit.alive(var_8_0) and arg_8_5 and arg_8_3 ~= nil and not ScriptUnit.extension(var_8_0, "buff_system"):has_buff_type("poison_screen_effect_immune") then
						local var_8_1 = POSITION_LOOKUP[var_8_0]
						local var_8_2 = Unit.local_position(arg_8_2, 0)
						local var_8_3 = Vector3.distance_squared(var_8_1, var_8_2) < arg_8_1 * arg_8_1
						local var_8_4 = Managers.time:time("game")

						if var_8_3 and not arg_8_4[var_8_0] then
							local var_8_5 = World.create_particles(arg_8_0, arg_8_3, Vector3(0, 0, 0))

							arg_8_4[var_8_0] = {
								particle_id = var_8_5,
								start_time = var_8_4
							}
						elseif var_8_3 and var_8_4 >= arg_8_4[var_8_0].start_time + 5 then
							local var_8_6 = arg_8_4[var_8_0].particle_id

							World.stop_spawning_particles(arg_8_0, var_8_6)

							arg_8_4[var_8_0] = nil
						elseif not var_8_3 and arg_8_4[var_8_0] and not arg_8_4[var_8_0].fade_time then
							local var_8_7 = arg_8_4[var_8_0].particle_id

							World.stop_spawning_particles(arg_8_0, var_8_7)

							local var_8_8 = World.create_particles(arg_8_0, arg_8_3, Vector3(0, 0, 0))

							arg_8_4[var_8_0].fade_time = var_8_4 + 1.5
							arg_8_4[var_8_0].particle_id = var_8_8
						elseif not var_8_3 and arg_8_4[var_8_0] and var_8_4 >= arg_8_4[var_8_0].fade_time then
							local var_8_9 = arg_8_4[var_8_0].particle_id

							World.stop_spawning_particles(arg_8_0, var_8_9)

							arg_8_4[var_8_0] = nil
						end
					end
				end
			end,
			spawn_effect = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				local var_9_0 = Unit.local_position(arg_9_1, 0)
				local var_9_1 = World.create_particles(arg_9_0, arg_9_2, var_9_0)

				if arg_9_3 ~= nil then
					for iter_9_0, iter_9_1 in pairs(arg_9_3) do
						local var_9_2 = World.find_particles_variable(arg_9_0, arg_9_2, iter_9_1.particle_variable)

						World.set_particles_variable(arg_9_0, var_9_1, var_9_2, iter_9_1.value)
					end
				end

				return var_9_1
			end,
			destroy = function ()
				return
			end
		}
	},
	explosion_template_aoe_vs = {
		server = {
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11)
				if arg_11_4 < arg_11_5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_11_1)

					return false
				end

				local var_11_0 = Unit.world_position(arg_11_1, 0)
				local var_11_1 = ExplosionUtils.get_template(arg_11_9)
				local var_11_2 = var_11_1.aoe

				if var_11_1.friendly_fire ~= nil then
					friendly_fire_data = var_11_1.friendly_fire
				end

				local var_11_3 = var_11_2.attack_template
				local var_11_4 = var_11_2.gravity_well
				local var_11_5

				if (var_11_3 or var_11_4) and (arg_11_7 <= 0 or arg_11_6 <= arg_11_7) then
					local var_11_6 = arg_11_11.enemy_broadphase_categories

					var_11_5 = AiUtils.broadphase_query(var_11_0, arg_11_2, var_0_1, var_11_6)
				end

				if var_11_4 and var_11_5 then
					local var_11_7 = Managers.time:time("game")
					local var_11_8 = arg_11_6 * 2
					local var_11_9 = var_11_4.strength
					local var_11_10 = var_11_0 + Vector3(0, 0, var_11_4.z_offset)
					local var_11_11 = BLACKBOARDS

					for iter_11_0 = 1, var_11_5 do
						local var_11_12 = var_11_11[var_0_1[iter_11_0]]

						if var_11_12.gravity_well_position then
							var_11_12.gravity_well_position:store(var_11_10)
						else
							var_11_12.gravity_well_position = Vector3Box(var_11_10)
						end

						var_11_12.gravity_well_strength = var_11_9
						var_11_12.gravity_well_time = var_11_7 + var_11_8
					end
				end

				if var_11_3 and var_11_5 then
					local var_11_13 = {}
					local var_11_14 = "full"

					for iter_11_1 = 1, var_11_5 do
						local var_11_15 = var_0_1[iter_11_1]
						local var_11_16 = {
							area_damage_template = "explosion_template_aoe",
							unit = var_11_15,
							damage_source = arg_11_0,
							hit_zone_name = var_11_14,
							aoe_data = var_11_2
						}

						var_11_13[#var_11_13 + 1] = var_11_16
					end

					if arg_11_8 then
						local var_11_17 = arg_11_11.ENEMY_PLAYER_AND_BOT_UNITS

						for iter_11_2, iter_11_3 in ipairs(var_11_17) do
							local var_11_18 = POSITION_LOOKUP[iter_11_3]
							local var_11_19 = arg_11_2 > Vector3.distance(var_11_18, var_11_0)
							local var_11_20 = ScriptUnit.has_extension(iter_11_3, "ghost_mode_system")
							local var_11_21 = var_11_20 and var_11_20:is_in_ghost_mode()

							if var_11_19 and not var_11_21 then
								local var_11_22 = {
									area_damage_template = "explosion_template_aoe",
									unit = iter_11_3,
									damage_source = arg_11_0,
									hit_zone_name = var_11_14,
									aoe_data = var_11_2
								}

								var_11_13[#var_11_13 + 1] = var_11_22
							end
						end
					end

					return true, var_11_13
				end
			end,
			do_damage = function (arg_12_0, arg_12_1, arg_12_2)
				local var_12_0 = arg_12_0.unit
				local var_12_1 = arg_12_1
				local var_12_2 = arg_12_0.hit_zone_name
				local var_12_3 = arg_12_0.damage_source
				local var_12_4 = arg_12_0.aoe_data
				local var_12_5 = FrameTable.alloc_table()

				var_12_5.dot_template_name = var_12_4.dot_template_name
				var_12_5.dot_balefire_variant = var_12_4.dot_balefire_variant

				local var_12_6
				local var_12_7
				local var_12_8
				local var_12_9
				local var_12_10

				DamageUtils.apply_dot(var_12_6, var_12_7, var_12_8, var_12_0, var_12_1, var_12_2, var_12_3, var_12_9, var_12_10, var_12_4, arg_12_2, var_12_5)
			end
		},
		client = {
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
				return
			end,
			spawn_effect = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = arg_14_4 or Unit.world_position(arg_14_1, 0)
				local var_14_1 = World.create_particles(arg_14_0, arg_14_2, var_14_0)

				if arg_14_3 ~= nil then
					for iter_14_0, iter_14_1 in pairs(arg_14_3) do
						local var_14_2 = World.find_particles_variable(arg_14_0, arg_14_2, iter_14_1.particle_variable)

						World.set_particles_variable(arg_14_0, var_14_1, var_14_2, iter_14_1.value)
					end
				end

				return var_14_1
			end
		}
	},
	area_poison_ai_random_death_vs = {
		server = {
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				if arg_15_4 > 0 and arg_15_4 < arg_15_3 then
					return false
				end

				local var_15_0 = Unit.world_position(arg_15_1, 0)
				local var_15_1 = {}
				local var_15_2 = AiUtils.broadphase_query(var_15_0, arg_15_2, var_0_1)

				for iter_15_0 = 1, var_15_2 do
					local var_15_3 = var_0_1[iter_15_0]

					if HEALTH_ALIVE[var_15_3] and math.random(1, 100) <= 100 - Unit.get_data(var_15_3, "breed").poison_resistance then
						local var_15_4 = {
							area_damage_template = "area_poison_ai_random_death",
							unit = var_15_3
						}

						var_15_1[#var_15_1 + 1] = var_15_4
					end
				end

				return true, var_15_1
			end,
			do_damage = function (arg_16_0, arg_16_1, arg_16_2)
				local var_16_0 = Managers.state.network
				local var_16_1 = arg_16_0.unit
				local var_16_2 = MAX_POWER_LEVEL
				local var_16_3 = Unit.world_position(arg_16_1, 0)
				local var_16_4 = POSITION_LOOKUP[var_16_1]
				local var_16_5 = Vector3.normalize(var_16_4 - var_16_3)
				local var_16_6 = "skaven_poison_wind_globadier"
				local var_16_7 = NetworkLookup.damage_sources[var_16_6]
				local var_16_8 = "globadier_gas_cloud"
				local var_16_9 = NetworkLookup.damage_profiles[var_16_8]
				local var_16_10 = var_16_0:unit_game_object_id(var_16_1)
				local var_16_11 = "full"
				local var_16_12 = NetworkLookup.hit_zones[var_16_11]

				Managers.state.entity:system("weapon_system"):send_rpc_attack_hit(var_16_7, var_16_10, var_16_10, var_16_12, var_16_3, var_16_5, var_16_9, "power_level", var_16_2, "hit_target_index", nil, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", 0, "is_critical_strike", false)

				if DamageUtils.is_ai(var_16_1) and not HEALTH_ALIVE[var_16_1] then
					QuestSettings.check_num_enemies_killed_by_poison(var_16_1, arg_16_1)
				end
			end
		}
	},
	mutator_life_poison_vs = {
		server = {
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
				if arg_17_4 < arg_17_5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_17_1)

					return false
				end

				local var_17_0 = Unit.local_position(arg_17_1, 0)

				if arg_17_7 >= 0 and arg_17_7 < arg_17_6 then
					return false
				end

				local var_17_1 = {}

				if arg_17_8 then
					for iter_17_0, iter_17_1 in pairs(Managers.player:players()) do
						local var_17_2 = iter_17_1.player_unit

						if var_17_2 ~= nil and BLACKBOARDS[var_17_2].breed.poison_resistance < 100 then
							local var_17_3 = POSITION_LOOKUP[var_17_2]

							if arg_17_2 > Vector3.distance(var_17_3, var_17_0) then
								local var_17_4 = {
									area_damage_template = "mutator_life_poison",
									unit = var_17_2,
									damage = arg_17_3,
									damage_source = arg_17_0
								}

								var_17_1[#var_17_1 + 1] = var_17_4
							end
						end
					end
				end

				return true, var_17_1
			end,
			do_damage = function (arg_18_0, arg_18_1)
				local var_18_0 = arg_18_0.unit
				local var_18_1 = arg_18_0.damage
				local var_18_2 = arg_18_0.damage_source

				DamageUtils.add_damage_network(var_18_0, arg_18_1, var_18_1, "torso", "damage_over_time", nil, Vector3(1, 0, 0), var_18_2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		},
		client = {
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7)
				if Development.parameter("screen_space_player_camera_reactions") == false then
					return
				end

				for iter_19_0, iter_19_1 in pairs(Managers.player:players()) do
					local var_19_0 = iter_19_1.player_unit

					if iter_19_1.local_player and Unit.alive(var_19_0) and arg_19_5 and arg_19_3 ~= nil and not ScriptUnit.extension(var_19_0, "buff_system"):has_buff_type("poison_screen_effect_immune") then
						local var_19_1 = POSITION_LOOKUP[var_19_0]
						local var_19_2 = Unit.local_position(arg_19_2, 0)
						local var_19_3 = Vector3.distance_squared(var_19_1, var_19_2) < arg_19_1 * arg_19_1
						local var_19_4 = Managers.time:time("game")

						if ScorpionSeasonalSettings.current_season_id == 1 and var_19_3 then
							local var_19_5 = Managers.player:statistics_db()
							local var_19_6 = iter_19_1:stats_id()
							local var_19_7 = "weave_life_stepped_in_bush"

							var_19_5:increment_stat(var_19_6, "season_1", var_19_7)
						end

						if var_19_3 and not arg_19_4[var_19_0] then
							local var_19_8 = World.create_particles(arg_19_0, arg_19_3, Vector3(0, 0, 0))

							arg_19_4[var_19_0] = {
								particle_id = var_19_8,
								start_time = var_19_4
							}
						elseif var_19_3 and var_19_4 >= arg_19_4[var_19_0].start_time + 5 then
							local var_19_9 = arg_19_4[var_19_0].particle_id

							World.stop_spawning_particles(arg_19_0, var_19_9)

							arg_19_4[var_19_0] = nil
						elseif not var_19_3 and arg_19_4[var_19_0] and not arg_19_4[var_19_0].fade_time then
							local var_19_10 = arg_19_4[var_19_0].particle_id

							World.stop_spawning_particles(arg_19_0, var_19_10)

							local var_19_11 = World.create_particles(arg_19_0, arg_19_3, Vector3(0, 0, 0))

							arg_19_4[var_19_0].fade_time = var_19_4 + 1.5
							arg_19_4[var_19_0].particle_id = var_19_11
						elseif not var_19_3 and arg_19_4[var_19_0] and var_19_4 >= arg_19_4[var_19_0].fade_time then
							local var_19_12 = arg_19_4[var_19_0].particle_id

							World.stop_spawning_particles(arg_19_0, var_19_12)

							arg_19_4[var_19_0] = nil
						end
					end
				end
			end,
			spawn_effect = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				local var_20_0 = Unit.local_position(arg_20_1, 0)
				local var_20_1 = World.create_particles(arg_20_0, arg_20_2, var_20_0)

				if arg_20_3 ~= nil then
					for iter_20_0, iter_20_1 in pairs(arg_20_3) do
						local var_20_2 = World.find_particles_variable(arg_20_0, arg_20_2, iter_20_1.particle_variable)

						World.set_particles_variable(arg_20_0, var_20_1, var_20_2, iter_20_1.value)
					end
				end

				return var_20_1
			end,
			destroy = function ()
				return
			end
		}
	}
}
