-- chunkname: @scripts/managers/world_interaction/world_interaction_manager.lua

require("scripts/managers/world_interaction/world_interaction_settings")

WorldInteractionManager = class(WorldInteractionManager)

local var_0_0 = {}

WorldInteractionManager.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._water_timer = 0
	arg_1_0._water_ripples = {}
	arg_1_0._units = {}

	arg_1_0:_setup_gui()
end

WorldInteractionManager._setup_gui = function (arg_2_0)
	arg_2_0._gui = World.create_screen_gui(arg_2_0._world, "material", "materials/world_interaction/world_interaction", "immediate")
end

WorldInteractionManager.add_world_interaction = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:remove_world_interaction(arg_3_2, arg_3_1)

	arg_3_0._units[arg_3_1] = arg_3_0._units[arg_3_1] or {}
	arg_3_0._units[arg_3_1][arg_3_2] = arg_3_0._units[arg_3_1][arg_3_2] or Managers.time:time("game")
end

WorldInteractionManager.remove_world_interaction = function (arg_4_0, arg_4_1, arg_4_2)
	for iter_4_0, iter_4_1 in pairs(arg_4_0._units) do
		if not arg_4_2 or arg_4_2 ~= iter_4_0 then
			iter_4_1[arg_4_1] = nil
		end
	end
end

WorldInteractionManager._add_water_ripple = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	local var_5_0 = WorldInteractionSettings.water
	local var_5_1 = var_5_0.random_ripple_size_diff

	arg_5_0._water_ripples[#arg_5_0._water_ripples + 1] = {
		timer = 0,
		pos = Vector3Box(arg_5_1),
		size_variable = 1 - var_5_1 * 0.5 + Math.random() * var_5_1,
		angle = arg_5_2,
		material = arg_5_3 or var_5_0.default_ripple_material,
		stretch_multiplier = arg_5_5,
		ref_time = arg_5_6,
		default_size = arg_5_7,
		multiplier = arg_5_8
	}
end

WorldInteractionManager.add_simple_effect = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = Managers.player:local_player()
	local var_6_1 = var_6_0 and var_6_0.player_unit

	if Unit.alive(var_6_1) then
		local var_6_2 = WorldInteractionSettings[arg_6_1]
		local var_6_3 = math.clamp(var_6_2.window_size, 1, 100) * 0.5
		local var_6_4 = POSITION_LOOKUP[var_6_1]

		if Vector3.distance_squared(var_6_4, arg_6_3) < var_6_3 * var_6_3 then
			arg_6_0["_add_simple_" .. arg_6_1 .. "_effect"](arg_6_0, arg_6_2, arg_6_3)
		end
	end
end

WorldInteractionManager._add_simple_water_effect = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = WorldInteractionSettings.water
	local var_7_1 = var_7_0.splash
	local var_7_2 = var_7_1.default_material
	local var_7_3 = math.clamp(var_7_0.window_size, 1, 100)
	local var_7_4 = var_7_1.stretch_multiplier
	local var_7_5 = var_7_1.multiplier
	local var_7_6 = var_7_1.timer_ref
	local var_7_7 = var_7_1.random_size_diff
	local var_7_8 = Managers.player:local_player()
	local var_7_9 = var_7_8 and var_7_8.player_unit

	if Unit.alive(var_7_9) then
		local var_7_10 = var_7_3 * 0.5
		local var_7_11 = POSITION_LOOKUP[var_7_9]
		local var_7_12 = var_7_1.start_size

		if Vector3.distance_squared(arg_7_2, var_7_11) < var_7_10 * var_7_10 then
			arg_7_0:_add_water_ripple(arg_7_2, 0, var_7_2, var_7_7, var_7_4, var_7_6, var_7_12, var_7_5)
		end
	end
end

WorldInteractionManager.update = function (arg_8_0, arg_8_1, arg_8_2)
	if Managers.state.network:game() then
		arg_8_0:_update_water(arg_8_1, arg_8_2)
		arg_8_0:_update_foliage(arg_8_1, arg_8_2)
	end
end

WorldInteractionManager._update_water = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._units.water
	local var_9_1 = Managers.player:local_player()
	local var_9_2 = var_9_1 and var_9_1.player_unit

	if Unit.alive(var_9_2) and (#arg_9_0._water_ripples > 0 or var_9_0 and next(var_9_0)) then
		arg_9_0:_cleanup_removed_units()
		arg_9_0:_update_water_data(arg_9_1, arg_9_2)
		arg_9_0:_update_water_ripples(arg_9_1, arg_9_2)
	end
end

local var_0_1 = {}

WorldInteractionManager._cleanup_removed_units = function (arg_10_0)
	local var_10_0 = Managers.state.spawn.unit_spawner.unit_death_watch_lookup

	table.clear(var_0_1)

	for iter_10_0, iter_10_1 in pairs(arg_10_0._units) do
		for iter_10_2, iter_10_3 in pairs(iter_10_1) do
			if not Unit.alive(iter_10_2) or var_10_0[iter_10_2] then
				var_0_1[#var_0_1 + 1] = iter_10_2
			end
		end
	end

	for iter_10_4, iter_10_5 in pairs(arg_10_0._units) do
		for iter_10_6, iter_10_7 in ipairs(var_0_1) do
			iter_10_5[iter_10_7] = nil
		end
	end
end

local var_0_2 = {}

WorldInteractionManager._update_water_data = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = WorldInteractionSettings.water
	local var_11_1 = math.clamp(var_11_0.window_size, 1, 100)
	local var_11_2 = var_11_0.water_speed_limit
	local var_11_3 = var_11_0.ripple_time_step
	local var_11_4 = var_11_0.max_contributing_units

	arg_11_0._water_timer = arg_11_0._water_timer or 0

	local var_11_5 = 1

	if var_11_3 <= arg_11_0._water_timer then
		local var_11_6 = arg_11_0._units.water
		local var_11_7 = Managers.player:local_player()
		local var_11_8 = var_11_7 and var_11_7.player_unit
		local var_11_9 = var_11_1 * 0.5
		local var_11_10 = Vector3.flat(POSITION_LOOKUP[var_11_8])

		if Unit.alive(var_11_8) and var_11_6 and next(var_11_6) then
			local var_11_11 = Managers.player:players()

			for iter_11_0, iter_11_1 in pairs(var_11_11) do
				local var_11_12 = iter_11_1.player_unit

				if var_11_6[var_11_12] then
					local var_11_13 = Unit.local_position(var_11_12, 0)

					if Vector3.distance_squared(var_11_13, var_11_10) < var_11_9 * var_11_9 then
						var_0_2[var_11_5] = var_11_12
						var_11_5 = var_11_5 + 1
					end
				end
			end

			local var_11_14 = Managers.state.entity:system("ai_system").broadphase
			local var_11_15 = Broadphase.query(var_11_14, var_11_10, var_11_1 * 0.5, var_0_0)

			for iter_11_2 = 1, var_11_15 do
				local var_11_16 = var_0_0[iter_11_2]

				if var_11_6[var_11_16] then
					var_0_2[var_11_5] = var_11_16
					var_11_5 = var_11_5 + 1
				end
			end

			local var_11_17 = Vector3(0, 0, 0)
			local var_11_18 = var_11_2 * var_11_2
			local var_11_19 = 0

			for iter_11_3 = 1, var_11_5 - 1 do
				local var_11_20 = var_0_2[iter_11_3]

				if Unit.alive(var_11_20) then
					local var_11_21 = ScriptUnit.has_extension(var_11_20, "locomotion_system")

					if var_11_21 then
						local var_11_22 = var_11_21.current_velocity and var_11_21:current_velocity()

						if var_11_22 and var_11_18 < Vector3.distance_squared(Vector3.flat(var_11_22), var_11_17) then
							local var_11_23 = Vector3.normalize(Vector3(var_11_22[1], var_11_22[2], 0))
							local var_11_24 = Vector3.dot(var_11_23, Vector3(0, 1, 0))
							local var_11_25 = math.clamp(var_11_24, -1, 1)
							local var_11_26 = math.acos(var_11_25) * (var_11_23[1] < 0 and 1 or -1)
							local var_11_27 = POSITION_LOOKUP[var_11_20]

							if var_11_26 == var_11_26 then
								arg_11_0:_add_water_ripple(var_11_27, var_11_26)

								var_11_19 = var_11_19 + 1

								if var_11_4 <= var_11_19 then
									break
								elseif arg_11_2 > var_11_6[var_11_20] then
									local var_11_28, var_11_29 = WwiseUtils.make_position_auto_source(arg_11_0._world, var_11_27)

									WwiseWorld.trigger_event(var_11_29, var_11_0.ripple_sound_event, var_11_28)

									var_11_6[var_11_20] = Managers.time:time("game") + var_11_0.ripple_sound_event_delay
								end
							end
						end
					end
				end
			end

			arg_11_0._water_timer = 0
		end
	end

	arg_11_0._water_timer = arg_11_0._water_timer + arg_11_1
end

local var_0_3 = {}

WorldInteractionManager._update_water_ripples = function (arg_12_0, arg_12_1, arg_12_2)
	table.clear(var_0_3)

	local var_12_0 = WorldInteractionSettings.water
	local var_12_1 = var_12_0.default_ripple_material
	local var_12_2 = var_12_0.default_ripple_start_size
	local var_12_3 = var_12_0.default_ripple_multiplier
	local var_12_4 = var_12_0.default_ripple_timer
	local var_12_5 = var_12_0.duplicate_edge_cases
	local var_12_6 = var_12_0.ripple_stretch_multiplier
	local var_12_7, var_12_8 = Gui.resolution()
	local var_12_9 = math.clamp(var_12_0.window_size, 1, 100)
	local var_12_10 = 0
	local var_12_11
	local var_12_12 = #arg_12_0._water_ripples

	for iter_12_0 = 1, var_12_12 do
		local var_12_13 = arg_12_0._water_ripples[iter_12_0]
		local var_12_14 = var_12_13.ref_time or var_12_4
		local var_12_15 = var_12_13.pos:unbox()
		local var_12_16 = var_12_13.stretch_multiplier or var_12_6
		local var_12_17 = var_12_13.multiplier or var_12_3
		local var_12_18 = (var_12_13.default_size or var_12_2)[1] * (var_12_13.size_variable or 0)
		local var_12_19 = math.easeOutCubic(var_12_13.timer / var_12_14)
		local var_12_20 = math.lerp(var_12_18, var_12_18 * var_12_17, var_12_19)
		local var_12_21 = Vector2(var_12_15[1] % var_12_9, var_12_15[2] % var_12_9)
		local var_12_22 = Vector2(var_12_21[1] / var_12_9, var_12_21[2] / var_12_9)
		local var_12_23 = Vector3(var_12_22[1] * var_12_7, var_12_8 - var_12_22[2] * var_12_8, 0)
		local var_12_24 = Vector2(var_12_20 * var_12_16[1] / var_12_9 * var_12_7, var_12_20 * var_12_16[2] / var_12_9 * var_12_8)
		local var_12_25 = 50
		local var_12_26 = var_12_13.angle
		local var_12_27 = var_12_23 - var_12_24 * 0.5
		local var_12_28 = Rotation2D(Vector3(0, 0, 0), var_12_26, var_12_27 + var_12_24 * 0.5)
		local var_12_29 = 1 - math.pow(var_12_13.timer / var_12_14, 3)
		local var_12_30 = (1 - var_12_19) * 255

		Gui.bitmap_3d(arg_12_0._gui, var_12_13.material, var_12_28, var_12_27, var_12_25, var_12_24, Color(var_12_30, 255, 255, 255))

		var_12_10 = var_12_10 + 1

		if var_12_5 then
			if var_12_27.x < 0 then
				local var_12_31 = var_12_27 + Vector3(var_12_7, 0, 0)
				local var_12_32 = Rotation2D(Vector3(0, 0, 0), var_12_26, var_12_31 + var_12_24 * 0.5)

				Gui.bitmap_3d(arg_12_0._gui, var_12_13.material, var_12_32, var_12_31, var_12_25, var_12_24, Color(var_12_30, 255, 255, 255))

				var_12_10 = var_12_10 + 1
			elseif var_12_7 < var_12_27.x + var_12_24.x then
				local var_12_33 = var_12_27 + Vector3(-var_12_7, 0, 0)
				local var_12_34 = Rotation2D(Vector3(0, 0, 0), var_12_26, var_12_33 + var_12_24 * 0.5)

				Gui.bitmap_3d(arg_12_0._gui, var_12_13.material, var_12_34, var_12_33, var_12_25, var_12_24, Color(var_12_30, 255, 255, 255))

				var_12_10 = var_12_10 + 1
			end

			if var_12_27.y < 0 then
				local var_12_35 = var_12_27 + Vector3(0, var_12_8, 0)
				local var_12_36 = Rotation2D(Vector3(0, 0, 0), var_12_26, var_12_35 + var_12_24 * 0.5)

				Gui.bitmap_3d(arg_12_0._gui, var_12_13.material, var_12_36, var_12_35, var_12_25, var_12_24, Color(var_12_30, 255, 255, 255))

				var_12_10 = var_12_10 + 1
			elseif var_12_8 < var_12_27.y + var_12_24.x then
				local var_12_37 = var_12_27 + Vector3(0, -var_12_8, 0)
				local var_12_38 = Rotation2D(Vector3(0, 0, 0), var_12_26, var_12_37 + var_12_24 * 0.5)

				Gui.bitmap_3d(arg_12_0._gui, var_12_13.material, var_12_38, var_12_37, var_12_25, var_12_24, Color(var_12_30, 255, 255, 255))

				var_12_10 = var_12_10 + 1
			end
		end

		var_12_13.timer = var_12_13.timer + arg_12_1

		if var_12_14 <= var_12_13.timer then
			var_0_3[#var_0_3 + 1] = iter_12_0
		end
	end

	for iter_12_1 = #var_0_3, 1, -1 do
		local var_12_39 = var_0_3[iter_12_1]

		table.remove(arg_12_0._water_ripples, var_12_39)
	end
end

WorldInteractionManager._update_foliage = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = Managers.player:local_player()
	local var_13_1 = var_13_0 and var_13_0.player_unit

	if Unit.alive(var_13_1) then
		arg_13_0:_update_foliage_players(arg_13_1, arg_13_2)
		arg_13_0:_update_foliage_ai(var_13_1, arg_13_1, arg_13_2)
	end
end

local var_0_4 = {}

WorldInteractionManager._update_foliage_players = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = WorldInteractionSettings.foliage
	local var_14_1 = var_14_0.default_foliage_material
	local var_14_2 = math.clamp(var_14_0.window_size, 1, 100)
	local var_14_3 = var_14_0.default_texture_world_size
	local var_14_4 = var_14_0.duplicate_edge_cases
	local var_14_5 = var_14_0.local_player_multiplier
	local var_14_6 = Managers.player:players()
	local var_14_7, var_14_8 = Gui.resolution()

	for iter_14_0, iter_14_1 in pairs(var_14_6) do
		local var_14_9 = iter_14_1.player_unit
		local var_14_10 = POSITION_LOOKUP[var_14_9]

		if var_14_10 then
			local var_14_11 = Unit.mover(var_14_9)

			if Mover.collides_down(var_14_11) then
				local var_14_12

				if iter_14_1.local_player then
					var_0_4[1] = var_14_3[1] * var_14_5
					var_0_4[2] = var_14_3[2] * var_14_5
					var_14_12 = var_0_4
				else
					var_14_12 = var_14_3
				end

				local var_14_13 = Vector2(var_14_10[1] % var_14_2, var_14_10[2] % var_14_2)
				local var_14_14 = Vector2(var_14_13[1] / var_14_2, var_14_13[2] / var_14_2)
				local var_14_15 = Vector3(var_14_14[1] * var_14_7, var_14_8 - var_14_14[2] * var_14_8, 0)
				local var_14_16 = Vector2(var_14_12[1] / var_14_2 * var_14_7, var_14_12[2] / var_14_2 * var_14_8)
				local var_14_17 = var_14_15 - var_14_16 * 0.5

				Gui.bitmap(arg_14_0._gui, var_14_1, var_14_17, var_14_16, Color(255, 255, 255, 255))

				if var_14_4 then
					if var_14_17.x < 0 then
						local var_14_18 = var_14_17 + Vector3(var_14_7, 0, 0)

						Gui.bitmap(arg_14_0._gui, var_14_1, var_14_18, var_14_16, Color(255, 255, 255, 255))
					elseif var_14_7 < var_14_17.x + var_14_16.x then
						local var_14_19 = var_14_17 + Vector3(-var_14_7, 0, 0)

						Gui.bitmap(arg_14_0._gui, var_14_1, var_14_19, var_14_16, Color(255, 255, 255, 255))
					end

					if var_14_17.y < 0 then
						local var_14_20 = var_14_17 + Vector3(0, var_14_8, 0)

						Gui.bitmap(arg_14_0._gui, var_14_1, var_14_20, var_14_16, Color(255, 255, 255, 255))
					elseif var_14_8 < var_14_17.y + var_14_16.x then
						local var_14_21 = var_14_17 + Vector3(0, -var_14_8, 0)

						Gui.bitmap(arg_14_0._gui, var_14_1, var_14_21, var_14_16, Color(255, 255, 255, 255))
					end
				end
			end
		end
	end
end

WorldInteractionManager._update_foliage_ai = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = WorldInteractionSettings.foliage
	local var_15_1 = var_15_0.default_foliage_material
	local var_15_2 = math.clamp(var_15_0.window_size, 1, 100)
	local var_15_3 = var_15_0.default_texture_world_size
	local var_15_4 = var_15_0.duplicate_edge_cases
	local var_15_5, var_15_6 = Gui.resolution()
	local var_15_7 = Unit.local_position(arg_15_1, 0)
	local var_15_8 = Managers.state.entity:system("ai_system").broadphase
	local var_15_9
	local var_15_10 = Broadphase.query(var_15_8, var_15_7, var_15_2 * 0.5, var_0_0)

	for iter_15_0 = 1, var_15_10 do
		local var_15_11 = var_0_0[iter_15_0]

		if Unit.alive(var_15_11) then
			local var_15_12 = POSITION_LOOKUP[var_15_11]
			local var_15_13 = Vector2(var_15_12[1] % var_15_2, var_15_12[2] % var_15_2)
			local var_15_14 = Vector2(var_15_13[1] / var_15_2, var_15_13[2] / var_15_2)
			local var_15_15 = Vector3(var_15_14[1] * var_15_5, var_15_6 - var_15_14[2] * var_15_6, 0)
			local var_15_16 = Vector2(var_15_3[1] / var_15_2 * var_15_5, var_15_3[2] / var_15_2 * var_15_6)
			local var_15_17 = var_15_15 - var_15_16 * 0.5

			Gui.bitmap(arg_15_0._gui, var_15_1, var_15_17, var_15_16, Color(255, 255, 255, 255))

			if var_15_4 then
				if var_15_17.x < 0 then
					local var_15_18 = var_15_17 + Vector3(var_15_5, 0, 0)

					Gui.bitmap(arg_15_0._gui, var_15_1, var_15_18, var_15_16, Color(255, 255, 255, 255))
				elseif var_15_5 < var_15_17.x + var_15_16.x then
					local var_15_19 = var_15_17 + Vector3(-var_15_5, 0, 0)

					Gui.bitmap(arg_15_0._gui, var_15_1, var_15_19, var_15_16, Color(255, 255, 255, 255))
				end

				if var_15_17.y < 0 then
					local var_15_20 = var_15_17 + Vector3(0, var_15_6, 0)

					Gui.bitmap(arg_15_0._gui, var_15_1, var_15_20, var_15_16, Color(255, 255, 255, 255))
				elseif var_15_6 < var_15_17.y + var_15_16.x then
					local var_15_21 = var_15_17 + Vector3(0, -var_15_6, 0)

					Gui.bitmap(arg_15_0._gui, var_15_1, var_15_21, var_15_16, Color(255, 255, 255, 255))
				end
			end
		end
	end
end

WorldInteractionManager.destory = function (arg_16_0)
	return
end
