-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_templates.lua

ProjectileTemplates = {}

local var_0_0

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
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

	local num = arg_1_1 * arg_1_1
	local vs_globadier_missing_globe_vo_range_from_edge = DialogueSettings.vs_globadier_missing_globe_vo_range_from_edge
	local num_2 = (arg_1_1 + vs_globadier_missing_globe_vo_range_from_edge) * (arg_1_1 + vs_globadier_missing_globe_vo_range_from_edge)
	local flag = true
	local flag_2 = true
	local num_3 = 0
	local ENEMY_PLAYER_AND_BOT_UNITS = var_1_1.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_1_9 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not ALIVE[var_1_9] then
			local distance_squared = Vector3.distance_squared(Vector3.flat(POSITION_LOOKUP[var_1_9]), Vector3.flat(arg_1_0))

			if distance_squared < num_2 then
				flag = false

				if distance_squared < num then
					num_3 = num_3 + 1

					if not flag_2 then
						local extension = ScriptUnit.extension(var_1_9, "status_system")

						if not (not extension and extension:is_disabled()) then
							flag_2 = false
						end
					end
				end
			end
		end
	end

	local num_4 = DialogueSettings.default_hear_distance * DialogueSettings.default_hear_distance

	if num_3 == 0 then
		if not flag then
			local PLAYER_AND_BOT_UNITS = var_1_1.PLAYER_AND_BOT_UNITS

			for j = 1, #PLAYER_AND_BOT_UNITS do
				local var_1_14 = PLAYER_AND_BOT_UNITS[j]

				if not (not ALIVE[var_1_14] and var_1_14 == arg_1_2 or not (num_4 > Vector3.distance_squared(POSITION_LOOKUP[var_1_14], var_1_0))) then
					ScriptUnit.extension_input(var_1_14, "dialogue_system"):trigger_dialogue_event("vs_globadier_missing_globe")
				end
			end
		end
	else
		if num_3 >= DialogueSettings.vs_globadier_many_heroes_hit_num then
			local PLAYER_AND_BOT_UNITS_2 = var_1_1.PLAYER_AND_BOT_UNITS

			for k = 1, #PLAYER_AND_BOT_UNITS_2 do
				local var_1_16 = PLAYER_AND_BOT_UNITS_2[k]

				if not (not ALIVE[var_1_16] and not (num_4 > Vector3.distance_squared(POSITION_LOOKUP[var_1_16], var_1_0))) then
					ScriptUnit.extension_input(var_1_16, "dialogue_system"):trigger_dialogue_event("vs_globadier_hitting_many")
				end
			end
		end

		if num_3 ~= 1 or not flag_2 then
			local var_1_17 = ALIVE[arg_1_2]

			var_1_17 = not var_1_17 and ScriptUnit.extension_input(arg_1_2, "dialogue_system")

			var_1_17:trigger_dialogue_event("vs_globe_on_disabled_hero")
		end
	end
end

ProjectileTemplates.trajectory_templates = {
	straight_target_traversal = {
		unit = {
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
				-- function 2
				local current_target = arg_2_7.current_target
				local position = arg_2_7.position

				return Vector3.normalize(current_target - position) * arg_2_0 * arg_2_6 + position
			end
		},
		husk = {
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
				-- function 3
				local current_target = arg_3_7.current_target
				local position = arg_3_7.position

				return Vector3.normalize(current_target - position) * arg_3_0 * arg_3_6 + position
			end
		}
	},
	right_spinning_target_traversal = {
		unit = {
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
				-- function 4
				local num = 0.1
				local current_target = arg_4_7.current_target
				local position = arg_4_7.position
				local normalize = Vector3.normalize(current_target - arg_4_3)
				local closest_point_on_line = Geometry.closest_point_on_line(position, arg_4_3, current_target)
				local num_2 = 1 - Vector3.distance(closest_point_on_line, current_target) / Vector3.distance(arg_4_3, current_target)
				local lerp = Vector3.lerp(arg_4_3, current_target, num_2)
				local var_4_7 = num_2
				local var_4_8
				local num_3 = arg_4_0 * 2
				local var_4_10

				if var_4_7 < num then
					local clamp = math.clamp(var_4_7 / num, 0, 1)

					var_4_8 = math.easeInCubic(clamp)
				elseif var_4_7 < 1 then
					arg_4_0 = arg_4_0 / 5
					var_4_7 = var_4_7 / 1

					local clamp_2 = math.clamp((var_4_7 - num) / (1 - num), 0, 1)

					var_4_8 = 1 - math.easeOutCubic(clamp_2)

					local var_4_13 = var_4_8

					if var_4_8 < 0.3 then
						var_4_13 = 0.3
					end

					arg_4_0 = arg_4_0 * (1 + math.ease_out_quad(clamp_2)) / var_4_13
					num_3 = num_3 * var_4_8
				else
					var_4_8 = 0
				end

				local var_4_14 = Vector3(math.cos(arg_4_5 * num_3), 0, -math.sin(arg_4_5 * num_3))
				local num_4 = Quaternion.rotate(Quaternion.look(normalize, Vector3.up()), var_4_14) * var_4_8

				arg_4_0 = arg_4_0 * (1 + math.easeInCubic(var_4_7))

				local distance = Vector3.distance(current_target, position)

				return lerp + normalize * math.clamp(arg_4_0 * arg_4_6, 0, distance) + num_4
			end
		}
	},
	left_spinning_target_traversal = {
		unit = {
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
				-- function 5
				local num = 0.1
				local current_target = arg_5_7.current_target
				local position = arg_5_7.position
				local normalize = Vector3.normalize(current_target - arg_5_3)
				local closest_point_on_line = Geometry.closest_point_on_line(position, arg_5_3, current_target)
				local num_2 = 1 - Vector3.distance(closest_point_on_line, current_target) / Vector3.distance(arg_5_3, current_target)
				local lerp = Vector3.lerp(arg_5_3, current_target, num_2)
				local var_5_7 = num_2
				local var_5_8
				local num_3 = arg_5_0 * 2
				local var_5_10

				if var_5_7 < num then
					local clamp = math.clamp(var_5_7 / num, 0, 1)

					var_5_8 = math.easeInCubic(clamp)
				elseif var_5_7 < 1 then
					arg_5_0 = arg_5_0 / 5
					var_5_7 = var_5_7 / 1

					local clamp_2 = math.clamp((var_5_7 - num) / (1 - num), 0, 1)

					var_5_8 = 1 - math.easeOutCubic(clamp_2)

					local var_5_13 = var_5_8

					if var_5_8 < 0.3 then
						var_5_13 = 0.3
					end

					arg_5_0 = arg_5_0 * (1 + math.ease_out_quad(clamp_2)) / var_5_13
					num_3 = num_3 * var_5_8
				else
					var_5_8 = 0
				end

				local var_5_14 = Vector3(math.sin(arg_5_5 * num_3), 0, -math.cos(arg_5_5 * num_3))
				local num_4 = Quaternion.rotate(Quaternion.look(normalize, Vector3.up()), var_5_14) * var_5_8

				arg_5_0 = arg_5_0 * (1 + math.easeInCubic(var_5_7))

				local distance = Vector3.distance(current_target, position)

				return lerp + normalize * math.clamp(arg_5_0 * arg_5_6, 0, distance) + num_4
			end
		}
	},
	random_spinning_target_traversal = {
		unit = {
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
				-- function 6
				local num = 0.1
				local current_target = arg_6_7.current_target
				local position = arg_6_7.position
				local normalize = Vector3.normalize(current_target - arg_6_3)
				local closest_point_on_line = Geometry.closest_point_on_line(position, arg_6_3, current_target)
				local num_2 = 1 - Vector3.distance(closest_point_on_line, current_target) / Vector3.distance(arg_6_3, current_target)
				local lerp = Vector3.lerp(arg_6_3, current_target, num_2)
				local var_6_7 = num_2
				local var_6_8
				local num_3 = arg_6_0 * 2
				local var_6_10

				if var_6_7 < num then
					local clamp = math.clamp(var_6_7 / num, 0, 1)

					var_6_8 = math.easeInCubic(clamp)
				elseif var_6_7 < 1 then
					arg_6_0 = arg_6_0 / 5
					var_6_7 = var_6_7 / 1

					local clamp_2 = math.clamp((var_6_7 - num) / (1 - num), 0, 1)

					var_6_8 = 1 - math.easeOutCubic(clamp_2)

					local var_6_13 = var_6_8

					if var_6_8 < 0.3 then
						var_6_13 = 0.3
					end

					arg_6_0 = arg_6_0 * (1 + math.ease_out_quad(clamp_2)) / var_6_13
					num_3 = num_3 * var_6_8
				else
					var_6_8 = 0
				end

				local random_spin_dir = arg_6_7.random_spin_dir
				local var_6_15

				if random_spin_dir == 1 then
					var_6_15 = Vector3(-math.cos(arg_6_5 * num_3), 0, math.sin(arg_6_5 * num_3))
				else
					var_6_15 = Vector3(math.sin(arg_6_5 * num_3), 0, -math.cos(arg_6_5 * num_3))
				end

				local num_4 = Quaternion.rotate(Quaternion.look(normalize, Vector3.up()), var_6_15) * var_6_8

				arg_6_0 = arg_6_0 * (1 + math.easeInCubic(var_6_7))

				local distance = Vector3.distance(current_target, position)
				local num_5 = lerp + normalize * math.clamp(arg_6_0 * arg_6_6, 0, distance) + num_4

				QuickDrawer:sphere(num_5, 0.1, Color(255, 0, 0))

				return num_5
			end
		}
	},
	magic_missile_traversal = {
		unit = {
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
				-- function 7
				local num = 0.075
				local current_target = arg_7_7.current_target
				local position = arg_7_7.position
				local normalize = Vector3.normalize(current_target - arg_7_3)
				local closest_point_on_line = Geometry.closest_point_on_line(position + normalize * arg_7_0 * arg_7_6, arg_7_3, current_target)
				local random_x_axis = arg_7_7.random_x_axis
				local random_y_axis = arg_7_7.random_y_axis
				local distance = Vector3.distance(arg_7_3, closest_point_on_line)
				local distance_2 = Vector3.distance(arg_7_3, current_target)
				local clamp = math.clamp(math.inv_lerp(0, distance_2, distance), 0, 1)
				local var_7_10

				if clamp < num then
					local clamp_2 = math.clamp(clamp / num, 0, 1)

					var_7_10 = math.easeInCubic(clamp_2) * 0.75
					arg_7_0 = arg_7_0 * (1 + math.easeInCubic(clamp_2) / 2) * 0.75
				elseif clamp < 1 then
					local clamp_3 = math.clamp((clamp - num) / (1 - num), 0, 1)

					var_7_10 = 1 - math.easeOutCubic(clamp_3)
					arg_7_0 = arg_7_0 * (1 + math.easeOutCubic(clamp_3))
				else
					var_7_10 = 0
				end

				local num_2 = Vector3.right() * random_x_axis
				local num_3 = Vector3.up() * random_y_axis
				local normalize_2 = Vector3.normalize(num_2 + num_3)
				local rotate = Quaternion.rotate(Quaternion.look(normalize), normalize_2)
				local distance_3 = Vector3.distance(current_target, position)
				local clamp_4 = math.clamp(arg_7_0 * arg_7_6, 0, distance_3)
				local num_4 = closest_point_on_line + rotate * var_7_10

				return position + Vector3.normalize(num_4 - position) * clamp_4
			end
		}
	},
	straight_direction_traversal = {
		unit = {
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
				-- function 8
				return arg_8_4 * arg_8_0 * arg_8_6 + arg_8_7.position
			end
		},
		husk = {
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
				-- function 9
				return arg_9_4 * arg_9_0 * arg_9_6 + arg_9_7.position
			end
		}
	},
	throw_trajectory = {
		prediction_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
			-- function 10
			local num = 0
			local var_10_1
			local num_2 = 0.01
			local num_3 = 10

			assert(arg_10_1 > 0, "Can't solve for <=0 gravity, use different projectile template")

			local var_10_4 = arg_10_3

			for i = 1, num_3 do
				var_10_4 = arg_10_3 + num * arg_10_4

				local num_4 = var_10_4.z - arg_10_2.z
				local num_5 = arg_10_0^2
				local length = Vector3.length(Vector3.flat(var_10_4 - arg_10_2))

				if length < num_2 then
					return 0, var_10_4
				end

				local num_6 = num_5^2 - arg_10_1 * (arg_10_1 * length^2 + 2 * num_4 * num_5)

				if num_6 <= 0 then
					return nil, var_10_4
				end

				local sqrt = math.sqrt(num_6)
				local atan = math.atan((num_5 + sqrt) / (arg_10_1 * length))
				local atan_2 = math.atan((num_5 - sqrt) / (arg_10_1 * length))

				var_10_1 = math.min(atan, atan_2)
				num = Vector3.length(Vector3.flat(var_10_4 - arg_10_2)) / (arg_10_0 * math.cos(var_10_1))
			end

			return var_10_1, var_10_4
		end,
		unit = {
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
				-- function 11
				return (WeaponHelper:position_on_trajectory(arg_11_3, arg_11_4, arg_11_0, arg_11_1, arg_11_2, arg_11_5, arg_11_6))
			end
		},
		husk = {
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
				-- function 12
				return (WeaponHelper:position_on_trajectory(arg_12_3, arg_12_4, arg_12_0, arg_12_1, arg_12_2, arg_12_5, arg_12_6))
			end
		}
	}
}
ProjectileTemplates.impact_templates = {
	explosion_impact = {
		server = {
			execute = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
				-- function 13
				local unbox = Vector3Box.unbox(arg_13_3[ProjectileImpactDataIndex.POSITION])
				local go_id = Managers.state.unit_storage:go_id(arg_13_2)

				Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", go_id, unbox)

				if not Unit.alive(arg_13_5) then
					return true
				end

				Unit.set_local_position(arg_13_2, 0, unbox)

				local has_extension = ScriptUnit.has_extension(arg_13_5, "ai_system")

				if not has_extension then
					has_extension:blackboard().explosion_impact = true
				end

				if not HEALTH_ALIVE[arg_13_5] then
					local num = 0
					local var_13_4 = POSITION_LOOKUP[arg_13_2]

					for k, v in pairs(Managers.player:human_players()) do
						local player_unit = v.player_unit

						if player_unit ~= nil then
							local var_13_6 = POSITION_LOOKUP[player_unit]

							if not (Vector3.distance_squared(var_13_6, var_13_4) < 9) then
								num = num + 1
							end
						end
					end

					local has_extension_2 = ScriptUnit.has_extension(arg_13_5, "dialogue_system")

					if not has_extension_2 then
						local input = has_extension_2.input
						local alloc_table = FrameTable.alloc_table()

						alloc_table.num_units = num

						input:trigger_dialogue_event("pwg_projectile_hit", alloc_table)
					end
				end

				return true
			end
		},
		client = {
			execute = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
				-- function 14
				Unit.set_unit_visibility(arg_14_2, false)
				Unit.flow_event(arg_14_2, "lua_projectile_impact")

				return true
			end
		}
	},
	vs_globadier_impact = {
		server = {
			execute = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
				-- function 15
				local unbox = Vector3Box.unbox(arg_15_3[ProjectileImpactDataIndex.POSITION])

				Unit.set_local_position(arg_15_2, 0, unbox)

				local go_id = Managers.state.unit_storage:go_id(arg_15_2)

				Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", go_id, unbox)

				if not Unit.alive(arg_15_5) then
					return true
				end

				local num = 3
				local has_extension = ScriptUnit.has_extension(arg_15_2, "area_damage_system")

				num = not has_extension and has_extension.radius and num

				local has_extension_2 = ScriptUnit.has_extension(arg_15_5, "ai_system")

				if not has_extension_2 then
					has_extension_2:blackboard().explosion_impact = true
				end

				if not HEALTH_ALIVE[arg_15_5] then
					local num_2 = 0
					local var_15_6 = POSITION_LOOKUP[arg_15_2]

					for k, v in pairs(Managers.player:human_players()) do
						local player_unit = v.player_unit

						if player_unit ~= nil then
							local var_15_8 = POSITION_LOOKUP[player_unit]

							if not (Vector3.distance_squared(var_15_8, var_15_6) < num * num) then
								num_2 = num_2 + 1
							end
						end
					end

					local has_extension_3 = ScriptUnit.has_extension(arg_15_5, "dialogue_system")

					if not has_extension_3 then
						local input = has_extension_3.input
						local alloc_table = FrameTable.alloc_table()

						alloc_table.num_units = num_2

						input:trigger_dialogue_event("pwg_projectile_hit", alloc_table)
					end
				end

				fn(unbox, num, arg_15_5)

				return true
			end
		},
		client = {
			execute = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
				-- function 16
				local unbox = Vector3Box.unbox(arg_16_3[ProjectileImpactDataIndex.POSITION])

				Unit.set_local_position(arg_16_2, 0, unbox)

				if not DamageUtils.is_player_unit(arg_16_5) then
					local owner = Managers.player:owner(arg_16_5)

					if not (not (not owner and owner.local_player) and arg_16_7 > 1) then
						WwiseUtils.trigger_position_event(arg_16_0, "player_versus_globadier_fps_globe_impact", unbox)
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
			execute = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
				-- function 17
				if not Unit.alive(arg_17_5) then
					Managers.state.unit_spawner:mark_for_deletion(arg_17_2)

					return true
				end

				if not arg_17_6 then
					if not arg_17_6.explosion then
						local var_17_0 = BLACKBOARDS[arg_17_5]

						AiUtils.ai_explosion(arg_17_2, arg_17_5, var_17_0, arg_17_1, arg_17_6)
					end

					local var_17_1

					if not arg_17_6.aoe then
						var_17_1 = Vector3Box.unbox(arg_17_3[ProjectileImpactDataIndex.POSITION])

						DamageUtils.create_aoe(arg_17_0, arg_17_5, var_17_1, arg_17_1, arg_17_6)
					end

					if not arg_17_6.server_hit_func then
						var_17_1 = var_17_1 or Vector3Box.unbox(arg_17_3[ProjectileImpactDataIndex.POSITION])

						arg_17_6.server_hit_func(arg_17_2, arg_17_1, arg_17_5, var_17_1, arg_17_3, arg_17_6)
					end
				end

				return true
			end
		},
		client = {
			execute = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
				-- function 18
				Unit.set_unit_visibility(arg_18_2, false)
				Unit.flow_event(arg_18_2, "lua_projectile_impact")

				return true
			end
		}
	},
	no_owner_direct_impact = {
		server = {
			execute = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
				-- function 19
				if not arg_19_6 then
					if not arg_19_6.explosion then
						local var_19_0 = BLACKBOARDS[arg_19_5]

						AiUtils.ai_explosion(arg_19_2, arg_19_5, var_19_0, arg_19_1, arg_19_6)
					end

					local var_19_1

					if not arg_19_6.aoe then
						var_19_1 = Vector3Box.unbox(arg_19_3[ProjectileImpactDataIndex.POSITION])

						DamageUtils.create_aoe(arg_19_0, arg_19_5, var_19_1, arg_19_1, arg_19_6)
					end

					if not arg_19_6.server_hit_func then
						var_19_1 = var_19_1 or Vector3Box.unbox(arg_19_3[ProjectileImpactDataIndex.POSITION])

						arg_19_6.server_hit_func(arg_19_2, arg_19_1, arg_19_5, var_19_1, arg_19_3, arg_19_6)
					end
				end

				return true
			end
		},
		client = {
			execute = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
				-- function 20
				Unit.set_unit_visibility(arg_20_2, false)
				Unit.flow_event(arg_20_2, "lua_projectile_impact")

				return true
			end
		}
	},
	vfx_impact = {
		server = {
			execute = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
				-- function 21
				Unit.set_unit_visibility(arg_21_2, false)
				Unit.flow_event(arg_21_2, "lua_projectile_impact")

				return true
			end
		},
		client = {
			execute = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
				-- function 22
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
			execute = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
				-- function 23
				local var_23_0 = arg_23_3[ProjectileImpactDataIndex.UNIT]

				if not HEALTH_ALIVE[var_23_0] then
					return true
				end

				local network = Managers.state.network
				local unit_game_object_id = network:unit_game_object_id(var_23_0)

				if not unit_game_object_id then
					local unbox = arg_23_3[ProjectileImpactDataIndex.POSITION]:unbox()
					local unbox_2 = arg_23_3[ProjectileImpactDataIndex.DIRECTION]:unbox()
					local system = Managers.state.entity:system("weapon_system")
					local buff = NetworkLookup.damage_sources.buff
					local unit_game_object_id_2 = network:unit_game_object_id(arg_23_5)
					local str = "full"
					local var_23_9 = Breeds[var_23_0]

					if not var_23_9 then
						local var_23_10 = arg_23_3[ProjectileImpactDataIndex.ACTOR_INDEX]
						local actor = Unit.actor(var_23_0, var_23_10)
						local node = Actor.node(actor)

						str = var_23_9.hit_zones_lookup[node] or str
					end

					local var_23_13 = NetworkLookup.hit_zones[str]
					local trapped_soul = NetworkLookup.damage_profiles.trapped_soul
					local DefaultPowerLevel = DefaultPowerLevel
					local has_extension = ScriptUnit.has_extension(arg_23_5, "career_system")

					if not has_extension then
						DefaultPowerLevel = has_extension:get_career_power_level()
					end

					local has_extension_2 = ScriptUnit.has_extension(arg_23_5, "health_system")

					if not has_extension_2 then
						local necromancer_trapped_soul = ProjectileTemplates.impact_templates.necromancer_trapped_soul

						has_extension_2:add_heal(arg_23_5, necromancer_trapped_soul.owner_heal_amount, nil, necromancer_trapped_soul.owner_heal_type)
					end

					system:send_rpc_attack_hit(buff, unit_game_object_id_2, unit_game_object_id, var_23_13, unbox, unbox_2, trapped_soul, "power_level", DefaultPowerLevel)
				end

				return true
			end
		},
		client = {
			execute = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
				-- function 24
				local unbox = arg_24_3[ProjectileImpactDataIndex.POSITION]:unbox()

				World.create_particles(arg_24_0, "fx/necromancer_skeleton_hit", unbox)
				Unit.flow_event(arg_24_2, "lua_projectile_impact")

				return true
			end
		}
	}
}

ProjectileTemplates.get_trajectory_template = function (arg_25_0, arg_25_1)
	-- function 25
	local trajectory_templates = ProjectileTemplates.trajectory_templates
	local flag

	flag = (arg_25_1 ~= true or not "husk" or arg_25_1 ~= false) and "unit"

	return trajectory_templates[arg_25_0][flag]
end

ProjectileTemplates.get_impact_template = function (arg_26_0)
	-- function 26
	return ProjectileTemplates.impact_templates[arg_26_0]
end

local function fn_2(self, arg_27_1)
	-- function 27
	local var_27_0
	local var_27_1
	local var_27_2
	local var_27_3
	local flag = true
	local var_27_5

	for i = 1, arg_27_1 / ProjectileImpactDataIndex.STRIDE do
		local num = (i - 1) * ProjectileImpactDataIndex.STRIDE

		var_27_0 = self[num + ProjectileImpactDataIndex.UNIT]
		var_27_1 = self[num + ProjectileImpactDataIndex.ACTOR_INDEX]
		var_27_2 = Unit.actor(var_27_0, var_27_1)
		var_27_3 = Actor.node(var_27_2)

		local get_data = Unit.get_data(var_27_0, "breed")

		if not get_data then
			if get_data.hit_zones_lookup[var_27_3].name ~= "afro" then
				flag = false
				var_27_5 = num

				break
			end
		else
			flag = false
			var_27_5 = num

			break
		end
	end

	return var_27_0, var_27_1, var_27_2, var_27_3, flag, var_27_5
end
