-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_templates.lua

ProjectileTemplates = {}

local var_0_0

local function var_0_1(arg_1_0, arg_1_1, arg_1_2)
	if not Managers.player:owner(arg_1_2) then
		return
	end

	local var_1_0 = POSITION_LOOKUP[arg_1_2]

	if not var_1_0 then
		return
	end

	local var_1_1 = Managers.state.side.side_by_unit[arg_1_2]

	if not var_1_1 then
		return
	end

	local var_1_2 = arg_1_1 * arg_1_1
	local var_1_3 = DialogueSettings.vs_globadier_missing_globe_vo_range_from_edge
	local var_1_4 = (arg_1_1 + var_1_3) * (arg_1_1 + var_1_3)
	local var_1_5 = true
	local var_1_6 = true
	local var_1_7 = 0
	local var_1_8 = var_1_1.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_1_0 = 1, #var_1_8 do
		local var_1_9 = var_1_8[iter_1_0]

		if ALIVE[var_1_9] then
			local var_1_10 = Vector3.distance_squared(Vector3.flat(POSITION_LOOKUP[var_1_9]), Vector3.flat(arg_1_0))

			if var_1_10 < var_1_4 then
				var_1_5 = false

				if var_1_10 < var_1_2 then
					var_1_7 = var_1_7 + 1

					if var_1_6 then
						local var_1_11 = ScriptUnit.extension(var_1_9, "status_system")

						if var_1_11 and not var_1_11:is_disabled() then
							var_1_6 = false
						end
					end
				end
			end
		end
	end

	local var_1_12 = DialogueSettings.default_hear_distance * DialogueSettings.default_hear_distance

	if var_1_7 == 0 then
		if var_1_5 then
			local var_1_13 = var_1_1.PLAYER_AND_BOT_UNITS

			for iter_1_1 = 1, #var_1_13 do
				local var_1_14 = var_1_13[iter_1_1]

				if ALIVE[var_1_14] and var_1_14 ~= arg_1_2 and var_1_12 > Vector3.distance_squared(POSITION_LOOKUP[var_1_14], var_1_0) then
					ScriptUnit.extension_input(var_1_14, "dialogue_system"):trigger_dialogue_event("vs_globadier_missing_globe")
				end
			end
		end
	else
		if var_1_7 >= DialogueSettings.vs_globadier_many_heroes_hit_num then
			local var_1_15 = var_1_1.PLAYER_AND_BOT_UNITS

			for iter_1_2 = 1, #var_1_15 do
				local var_1_16 = var_1_15[iter_1_2]

				if ALIVE[var_1_16] and var_1_12 > Vector3.distance_squared(POSITION_LOOKUP[var_1_16], var_1_0) then
					ScriptUnit.extension_input(var_1_16, "dialogue_system"):trigger_dialogue_event("vs_globadier_hitting_many")
				end
			end
		end

		if var_1_7 == 1 and var_1_6 then
			(ALIVE[arg_1_2] and ScriptUnit.extension_input(arg_1_2, "dialogue_system")):trigger_dialogue_event("vs_globe_on_disabled_hero")
		end
	end
end

ProjectileTemplates.trajectory_templates = {
	straight_target_traversal = {
		unit = {
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
				local var_2_0 = arg_2_7.current_target
				local var_2_1 = arg_2_7.position

				return Vector3.normalize(var_2_0 - var_2_1) * arg_2_0 * arg_2_6 + var_2_1
			end
		},
		husk = {
			update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
				local var_3_0 = arg_3_7.current_target
				local var_3_1 = arg_3_7.position

				return Vector3.normalize(var_3_0 - var_3_1) * arg_3_0 * arg_3_6 + var_3_1
			end
		}
	},
	right_spinning_target_traversal = {
		unit = {
			update = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
				local var_4_0 = 0.1
				local var_4_1 = arg_4_7.current_target
				local var_4_2 = arg_4_7.position
				local var_4_3 = Vector3.normalize(var_4_1 - arg_4_3)
				local var_4_4 = Geometry.closest_point_on_line(var_4_2, arg_4_3, var_4_1)
				local var_4_5 = 1 - Vector3.distance(var_4_4, var_4_1) / Vector3.distance(arg_4_3, var_4_1)
				local var_4_6 = Vector3.lerp(arg_4_3, var_4_1, var_4_5)
				local var_4_7 = var_4_5
				local var_4_8
				local var_4_9 = arg_4_0 * 2
				local var_4_10

				if var_4_7 < var_4_0 then
					local var_4_11 = math.clamp(var_4_7 / var_4_0, 0, 1)

					var_4_8 = math.easeInCubic(var_4_11)
				elseif var_4_7 < 1 then
					arg_4_0 = arg_4_0 / 5
					var_4_7 = var_4_7 / 1

					local var_4_12 = math.clamp((var_4_7 - var_4_0) / (1 - var_4_0), 0, 1)

					var_4_8 = 1 - math.easeOutCubic(var_4_12)

					local var_4_13 = var_4_8

					if var_4_8 < 0.3 then
						var_4_13 = 0.3
					end

					arg_4_0 = arg_4_0 * (1 + math.ease_out_quad(var_4_12)) / var_4_13
					var_4_9 = var_4_9 * var_4_8
				else
					var_4_8 = 0
				end

				local var_4_14 = Vector3(math.cos(arg_4_5 * var_4_9), 0, -math.sin(arg_4_5 * var_4_9))
				local var_4_15 = Quaternion.rotate(Quaternion.look(var_4_3, Vector3.up()), var_4_14) * var_4_8

				arg_4_0 = arg_4_0 * (1 + math.easeInCubic(var_4_7))

				local var_4_16 = Vector3.distance(var_4_1, var_4_2)

				return var_4_6 + var_4_3 * math.clamp(arg_4_0 * arg_4_6, 0, var_4_16) + var_4_15
			end
		}
	},
	left_spinning_target_traversal = {
		unit = {
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
				local var_5_0 = 0.1
				local var_5_1 = arg_5_7.current_target
				local var_5_2 = arg_5_7.position
				local var_5_3 = Vector3.normalize(var_5_1 - arg_5_3)
				local var_5_4 = Geometry.closest_point_on_line(var_5_2, arg_5_3, var_5_1)
				local var_5_5 = 1 - Vector3.distance(var_5_4, var_5_1) / Vector3.distance(arg_5_3, var_5_1)
				local var_5_6 = Vector3.lerp(arg_5_3, var_5_1, var_5_5)
				local var_5_7 = var_5_5
				local var_5_8
				local var_5_9 = arg_5_0 * 2
				local var_5_10

				if var_5_7 < var_5_0 then
					local var_5_11 = math.clamp(var_5_7 / var_5_0, 0, 1)

					var_5_8 = math.easeInCubic(var_5_11)
				elseif var_5_7 < 1 then
					arg_5_0 = arg_5_0 / 5
					var_5_7 = var_5_7 / 1

					local var_5_12 = math.clamp((var_5_7 - var_5_0) / (1 - var_5_0), 0, 1)

					var_5_8 = 1 - math.easeOutCubic(var_5_12)

					local var_5_13 = var_5_8

					if var_5_8 < 0.3 then
						var_5_13 = 0.3
					end

					arg_5_0 = arg_5_0 * (1 + math.ease_out_quad(var_5_12)) / var_5_13
					var_5_9 = var_5_9 * var_5_8
				else
					var_5_8 = 0
				end

				local var_5_14 = Vector3(math.sin(arg_5_5 * var_5_9), 0, -math.cos(arg_5_5 * var_5_9))
				local var_5_15 = Quaternion.rotate(Quaternion.look(var_5_3, Vector3.up()), var_5_14) * var_5_8

				arg_5_0 = arg_5_0 * (1 + math.easeInCubic(var_5_7))

				local var_5_16 = Vector3.distance(var_5_1, var_5_2)

				return var_5_6 + var_5_3 * math.clamp(arg_5_0 * arg_5_6, 0, var_5_16) + var_5_15
			end
		}
	},
	random_spinning_target_traversal = {
		unit = {
			update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
				local var_6_0 = 0.1
				local var_6_1 = arg_6_7.current_target
				local var_6_2 = arg_6_7.position
				local var_6_3 = Vector3.normalize(var_6_1 - arg_6_3)
				local var_6_4 = Geometry.closest_point_on_line(var_6_2, arg_6_3, var_6_1)
				local var_6_5 = 1 - Vector3.distance(var_6_4, var_6_1) / Vector3.distance(arg_6_3, var_6_1)
				local var_6_6 = Vector3.lerp(arg_6_3, var_6_1, var_6_5)
				local var_6_7 = var_6_5
				local var_6_8
				local var_6_9 = arg_6_0 * 2
				local var_6_10

				if var_6_7 < var_6_0 then
					local var_6_11 = math.clamp(var_6_7 / var_6_0, 0, 1)

					var_6_8 = math.easeInCubic(var_6_11)
				elseif var_6_7 < 1 then
					arg_6_0 = arg_6_0 / 5
					var_6_7 = var_6_7 / 1

					local var_6_12 = math.clamp((var_6_7 - var_6_0) / (1 - var_6_0), 0, 1)

					var_6_8 = 1 - math.easeOutCubic(var_6_12)

					local var_6_13 = var_6_8

					if var_6_8 < 0.3 then
						var_6_13 = 0.3
					end

					arg_6_0 = arg_6_0 * (1 + math.ease_out_quad(var_6_12)) / var_6_13
					var_6_9 = var_6_9 * var_6_8
				else
					var_6_8 = 0
				end

				local var_6_14 = arg_6_7.random_spin_dir
				local var_6_15

				if var_6_14 == 1 then
					var_6_15 = Vector3(-math.cos(arg_6_5 * var_6_9), 0, math.sin(arg_6_5 * var_6_9))
				else
					var_6_15 = Vector3(math.sin(arg_6_5 * var_6_9), 0, -math.cos(arg_6_5 * var_6_9))
				end

				local var_6_16 = Quaternion.rotate(Quaternion.look(var_6_3, Vector3.up()), var_6_15) * var_6_8

				arg_6_0 = arg_6_0 * (1 + math.easeInCubic(var_6_7))

				local var_6_17 = Vector3.distance(var_6_1, var_6_2)
				local var_6_18 = var_6_6 + var_6_3 * math.clamp(arg_6_0 * arg_6_6, 0, var_6_17) + var_6_16

				QuickDrawer:sphere(var_6_18, 0.1, Color(255, 0, 0))

				return var_6_18
			end
		}
	},
	magic_missile_traversal = {
		unit = {
			update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
				local var_7_0 = 0.075
				local var_7_1 = arg_7_7.current_target
				local var_7_2 = arg_7_7.position
				local var_7_3 = Vector3.normalize(var_7_1 - arg_7_3)
				local var_7_4 = Geometry.closest_point_on_line(var_7_2 + var_7_3 * arg_7_0 * arg_7_6, arg_7_3, var_7_1)
				local var_7_5 = arg_7_7.random_x_axis
				local var_7_6 = arg_7_7.random_y_axis
				local var_7_7 = Vector3.distance(arg_7_3, var_7_4)
				local var_7_8 = Vector3.distance(arg_7_3, var_7_1)
				local var_7_9 = math.clamp(math.inv_lerp(0, var_7_8, var_7_7), 0, 1)
				local var_7_10

				if var_7_9 < var_7_0 then
					local var_7_11 = math.clamp(var_7_9 / var_7_0, 0, 1)

					var_7_10 = math.easeInCubic(var_7_11) * 0.75
					arg_7_0 = arg_7_0 * (1 + math.easeInCubic(var_7_11) / 2) * 0.75
				elseif var_7_9 < 1 then
					local var_7_12 = math.clamp((var_7_9 - var_7_0) / (1 - var_7_0), 0, 1)

					var_7_10 = 1 - math.easeOutCubic(var_7_12)
					arg_7_0 = arg_7_0 * (1 + math.easeOutCubic(var_7_12))
				else
					var_7_10 = 0
				end

				local var_7_13 = Vector3.right() * var_7_5
				local var_7_14 = Vector3.up() * var_7_6
				local var_7_15 = Vector3.normalize(var_7_13 + var_7_14)
				local var_7_16 = Quaternion.rotate(Quaternion.look(var_7_3), var_7_15)
				local var_7_17 = Vector3.distance(var_7_1, var_7_2)
				local var_7_18 = math.clamp(arg_7_0 * arg_7_6, 0, var_7_17)
				local var_7_19 = var_7_4 + var_7_16 * var_7_10

				return var_7_2 + Vector3.normalize(var_7_19 - var_7_2) * var_7_18
			end
		}
	},
	straight_direction_traversal = {
		unit = {
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
				return arg_8_4 * arg_8_0 * arg_8_6 + arg_8_7.position
			end
		},
		husk = {
			update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
				return arg_9_4 * arg_9_0 * arg_9_6 + arg_9_7.position
			end
		}
	},
	throw_trajectory = {
		prediction_function = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
			local var_10_0 = 0
			local var_10_1
			local var_10_2 = 0.01
			local var_10_3 = 10

			assert(arg_10_1 > 0, "Can't solve for <=0 gravity, use different projectile template")

			local var_10_4 = arg_10_3

			for iter_10_0 = 1, var_10_3 do
				var_10_4 = arg_10_3 + var_10_0 * arg_10_4

				local var_10_5 = var_10_4.z - arg_10_2.z
				local var_10_6 = arg_10_0^2
				local var_10_7 = Vector3.length(Vector3.flat(var_10_4 - arg_10_2))

				if var_10_7 < var_10_2 then
					return 0, var_10_4
				end

				local var_10_8 = var_10_6^2 - arg_10_1 * (arg_10_1 * var_10_7^2 + 2 * var_10_5 * var_10_6)

				if var_10_8 <= 0 then
					return nil, var_10_4
				end

				local var_10_9 = math.sqrt(var_10_8)
				local var_10_10 = math.atan((var_10_6 + var_10_9) / (arg_10_1 * var_10_7))
				local var_10_11 = math.atan((var_10_6 - var_10_9) / (arg_10_1 * var_10_7))

				var_10_1 = math.min(var_10_10, var_10_11)
				var_10_0 = Vector3.length(Vector3.flat(var_10_4 - arg_10_2)) / (arg_10_0 * math.cos(var_10_1))
			end

			return var_10_1, var_10_4
		end,
		unit = {
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
				return (WeaponHelper:position_on_trajectory(arg_11_3, arg_11_4, arg_11_0, arg_11_1, arg_11_2, arg_11_5, arg_11_6))
			end
		},
		husk = {
			update = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
				return (WeaponHelper:position_on_trajectory(arg_12_3, arg_12_4, arg_12_0, arg_12_1, arg_12_2, arg_12_5, arg_12_6))
			end
		}
	}
}
ProjectileTemplates.impact_templates = {
	explosion_impact = {
		server = {
			execute = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
				local var_13_0 = Vector3Box.unbox(arg_13_3[ProjectileImpactDataIndex.POSITION])
				local var_13_1 = Managers.state.unit_storage:go_id(arg_13_2)

				Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", var_13_1, var_13_0)

				if not Unit.alive(arg_13_5) then
					return true
				end

				Unit.set_local_position(arg_13_2, 0, var_13_0)

				local var_13_2 = ScriptUnit.has_extension(arg_13_5, "ai_system")

				if var_13_2 then
					var_13_2:blackboard().explosion_impact = true
				end

				if HEALTH_ALIVE[arg_13_5] then
					local var_13_3 = 0
					local var_13_4 = POSITION_LOOKUP[arg_13_2]

					for iter_13_0, iter_13_1 in pairs(Managers.player:human_players()) do
						local var_13_5 = iter_13_1.player_unit

						if var_13_5 ~= nil then
							local var_13_6 = POSITION_LOOKUP[var_13_5]

							if Vector3.distance_squared(var_13_6, var_13_4) < 9 then
								var_13_3 = var_13_3 + 1
							end
						end
					end

					local var_13_7 = ScriptUnit.has_extension(arg_13_5, "dialogue_system")

					if var_13_7 then
						local var_13_8 = var_13_7.input
						local var_13_9 = FrameTable.alloc_table()

						var_13_9.num_units = var_13_3

						var_13_8:trigger_dialogue_event("pwg_projectile_hit", var_13_9)
					end
				end

				return true
			end
		},
		client = {
			execute = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
				Unit.set_unit_visibility(arg_14_2, false)
				Unit.flow_event(arg_14_2, "lua_projectile_impact")

				return true
			end
		}
	},
	vs_globadier_impact = {
		server = {
			execute = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
				local var_15_0 = Vector3Box.unbox(arg_15_3[ProjectileImpactDataIndex.POSITION])

				Unit.set_local_position(arg_15_2, 0, var_15_0)

				local var_15_1 = Managers.state.unit_storage:go_id(arg_15_2)

				Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", var_15_1, var_15_0)

				if not Unit.alive(arg_15_5) then
					return true
				end

				local var_15_2 = 3
				local var_15_3 = ScriptUnit.has_extension(arg_15_2, "area_damage_system")

				var_15_2 = var_15_3 and var_15_3.radius or var_15_2

				local var_15_4 = ScriptUnit.has_extension(arg_15_5, "ai_system")

				if var_15_4 then
					var_15_4:blackboard().explosion_impact = true
				end

				if HEALTH_ALIVE[arg_15_5] then
					local var_15_5 = 0
					local var_15_6 = POSITION_LOOKUP[arg_15_2]

					for iter_15_0, iter_15_1 in pairs(Managers.player:human_players()) do
						local var_15_7 = iter_15_1.player_unit

						if var_15_7 ~= nil then
							local var_15_8 = POSITION_LOOKUP[var_15_7]

							if Vector3.distance_squared(var_15_8, var_15_6) < var_15_2 * var_15_2 then
								var_15_5 = var_15_5 + 1
							end
						end
					end

					local var_15_9 = ScriptUnit.has_extension(arg_15_5, "dialogue_system")

					if var_15_9 then
						local var_15_10 = var_15_9.input
						local var_15_11 = FrameTable.alloc_table()

						var_15_11.num_units = var_15_5

						var_15_10:trigger_dialogue_event("pwg_projectile_hit", var_15_11)
					end
				end

				var_0_1(var_15_0, var_15_2, arg_15_5)

				return true
			end
		},
		client = {
			execute = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
				local var_16_0 = Vector3Box.unbox(arg_16_3[ProjectileImpactDataIndex.POSITION])

				Unit.set_local_position(arg_16_2, 0, var_16_0)

				if DamageUtils.is_player_unit(arg_16_5) then
					local var_16_1 = Managers.player:owner(arg_16_5)

					if var_16_1 and var_16_1.local_player and not (arg_16_7 > 1) then
						WwiseUtils.trigger_position_event(arg_16_0, "player_versus_globadier_fps_globe_impact", var_16_0)
					end
				end

				Unit.set_unit_visibility(arg_16_2, false)
				Unit.flow_event(arg_16_2, "lua_projectile_impact")

				return true
			end
		}
	},
	direct_impact = {
		server = {
			execute = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
				if not Unit.alive(arg_17_5) then
					Managers.state.unit_spawner:mark_for_deletion(arg_17_2)

					return true
				end

				if arg_17_6 then
					if arg_17_6.explosion then
						local var_17_0 = BLACKBOARDS[arg_17_5]

						AiUtils.ai_explosion(arg_17_2, arg_17_5, var_17_0, arg_17_1, arg_17_6)
					end

					local var_17_1

					if arg_17_6.aoe then
						var_17_1 = Vector3Box.unbox(arg_17_3[ProjectileImpactDataIndex.POSITION])

						DamageUtils.create_aoe(arg_17_0, arg_17_5, var_17_1, arg_17_1, arg_17_6)
					end

					if arg_17_6.server_hit_func then
						var_17_1 = var_17_1 or Vector3Box.unbox(arg_17_3[ProjectileImpactDataIndex.POSITION])

						arg_17_6.server_hit_func(arg_17_2, arg_17_1, arg_17_5, var_17_1, arg_17_3, arg_17_6)
					end
				end

				return true
			end
		},
		client = {
			execute = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
				Unit.set_unit_visibility(arg_18_2, false)
				Unit.flow_event(arg_18_2, "lua_projectile_impact")

				return true
			end
		}
	},
	no_owner_direct_impact = {
		server = {
			execute = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
				if arg_19_6 then
					if arg_19_6.explosion then
						local var_19_0 = BLACKBOARDS[arg_19_5]

						AiUtils.ai_explosion(arg_19_2, arg_19_5, var_19_0, arg_19_1, arg_19_6)
					end

					local var_19_1

					if arg_19_6.aoe then
						var_19_1 = Vector3Box.unbox(arg_19_3[ProjectileImpactDataIndex.POSITION])

						DamageUtils.create_aoe(arg_19_0, arg_19_5, var_19_1, arg_19_1, arg_19_6)
					end

					if arg_19_6.server_hit_func then
						var_19_1 = var_19_1 or Vector3Box.unbox(arg_19_3[ProjectileImpactDataIndex.POSITION])

						arg_19_6.server_hit_func(arg_19_2, arg_19_1, arg_19_5, var_19_1, arg_19_3, arg_19_6)
					end
				end

				return true
			end
		},
		client = {
			execute = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
				Unit.set_unit_visibility(arg_20_2, false)
				Unit.flow_event(arg_20_2, "lua_projectile_impact")

				return true
			end
		}
	},
	vfx_impact = {
		server = {
			execute = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
				Unit.set_unit_visibility(arg_21_2, false)
				Unit.flow_event(arg_21_2, "lua_projectile_impact")

				return true
			end
		},
		client = {
			execute = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
				Unit.set_unit_visibility(arg_22_2, false)
				Unit.flow_event(arg_22_2, "lua_projectile_impact")

				return true
			end
		}
	},
	necromancer_trapped_soul = {
		owner_heal_amount = 2,
		owner_heal_type = "heal_from_proc",
		server = {
			execute = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
				local var_23_0 = arg_23_3[ProjectileImpactDataIndex.UNIT]

				if not HEALTH_ALIVE[var_23_0] then
					return true
				end

				local var_23_1 = Managers.state.network
				local var_23_2 = var_23_1:unit_game_object_id(var_23_0)

				if var_23_2 then
					local var_23_3 = arg_23_3[ProjectileImpactDataIndex.POSITION]:unbox()
					local var_23_4 = arg_23_3[ProjectileImpactDataIndex.DIRECTION]:unbox()
					local var_23_5 = Managers.state.entity:system("weapon_system")
					local var_23_6 = NetworkLookup.damage_sources.buff
					local var_23_7 = var_23_1:unit_game_object_id(arg_23_5)
					local var_23_8 = "full"
					local var_23_9 = Breeds[var_23_0]

					if var_23_9 then
						local var_23_10 = arg_23_3[ProjectileImpactDataIndex.ACTOR_INDEX]
						local var_23_11 = Unit.actor(var_23_0, var_23_10)
						local var_23_12 = Actor.node(var_23_11)

						var_23_8 = var_23_9.hit_zones_lookup[var_23_12] or var_23_8
					end

					local var_23_13 = NetworkLookup.hit_zones[var_23_8]
					local var_23_14 = NetworkLookup.damage_profiles.trapped_soul
					local var_23_15 = DefaultPowerLevel
					local var_23_16 = ScriptUnit.has_extension(arg_23_5, "career_system")

					if var_23_16 then
						var_23_15 = var_23_16:get_career_power_level()
					end

					local var_23_17 = ScriptUnit.has_extension(arg_23_5, "health_system")

					if var_23_17 then
						local var_23_18 = ProjectileTemplates.impact_templates.necromancer_trapped_soul

						var_23_17:add_heal(arg_23_5, var_23_18.owner_heal_amount, nil, var_23_18.owner_heal_type)
					end

					var_23_5:send_rpc_attack_hit(var_23_6, var_23_7, var_23_2, var_23_13, var_23_3, var_23_4, var_23_14, "power_level", var_23_15)
				end

				return true
			end
		},
		client = {
			execute = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
				local var_24_0 = arg_24_3[ProjectileImpactDataIndex.POSITION]:unbox()

				World.create_particles(arg_24_0, "fx/necromancer_skeleton_hit", var_24_0)
				Unit.flow_event(arg_24_2, "lua_projectile_impact")

				return true
			end
		}
	}
}

function ProjectileTemplates.get_trajectory_template(arg_25_0, arg_25_1)
	local var_25_0 = ProjectileTemplates.trajectory_templates
	local var_25_1 = arg_25_1 == true and "husk" or arg_25_1 == false and "unit"

	return var_25_0[arg_25_0][var_25_1]
end

function ProjectileTemplates.get_impact_template(arg_26_0)
	return ProjectileTemplates.impact_templates[arg_26_0]
end

local function var_0_2(arg_27_0, arg_27_1)
	local var_27_0
	local var_27_1
	local var_27_2
	local var_27_3
	local var_27_4 = true
	local var_27_5

	for iter_27_0 = 1, arg_27_1 / ProjectileImpactDataIndex.STRIDE do
		local var_27_6 = (iter_27_0 - 1) * ProjectileImpactDataIndex.STRIDE

		var_27_0 = arg_27_0[var_27_6 + ProjectileImpactDataIndex.UNIT]
		var_27_1 = arg_27_0[var_27_6 + ProjectileImpactDataIndex.ACTOR_INDEX]
		var_27_2 = Unit.actor(var_27_0, var_27_1)
		var_27_3 = Actor.node(var_27_2)

		local var_27_7 = Unit.get_data(var_27_0, "breed")

		if var_27_7 then
			if var_27_7.hit_zones_lookup[var_27_3].name ~= "afro" then
				var_27_4 = false
				var_27_5 = var_27_6

				break
			end
		else
			var_27_4 = false
			var_27_5 = var_27_6

			break
		end
	end

	return var_27_0, var_27_1, var_27_2, var_27_3, var_27_4, var_27_5
end
