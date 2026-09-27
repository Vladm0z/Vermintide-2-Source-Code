-- chunkname: @scripts/managers/world_interaction/world_interaction_manager.lua

require("scripts/managers/world_interaction/world_interaction_settings")

WorldInteractionManager = class(WorldInteractionManager)

local tbl = {}

WorldInteractionManager.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._water_timer = 0
	self._water_ripples = {}
	self._units = {}

	self:_setup_gui()
end

WorldInteractionManager._setup_gui = function (self)
	-- function 2
	self._gui = World.create_screen_gui(self._world, "material", "materials/world_interaction/world_interaction", "immediate")
end

WorldInteractionManager.add_world_interaction = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:remove_world_interaction(arg_3_2, arg_3_1)

	local _units = self._units
	local var_3_1 = self._units[arg_3_1]

	var_3_1 = var_3_1 or {}
	_units[arg_3_1] = var_3_1

	local var_3_2 = self._units[arg_3_1]
	local var_3_3 = self._units[arg_3_1][arg_3_2]

	var_3_3 = var_3_3 or Managers.time:time("game")
	var_3_2[arg_3_2] = var_3_3
end

WorldInteractionManager.remove_world_interaction = function (self, arg_4_1, arg_4_2)
	-- function 4
	for k, v in pairs(self._units) do
		if not (not arg_4_2 and arg_4_2 == k) then
			v[arg_4_1] = nil
		end
	end
end

WorldInteractionManager._add_water_ripple = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	-- function 5
	local water = WorldInteractionSettings.water
	local random_ripple_size_diff = water.random_ripple_size_diff

	arg_5_0._water_ripples[#arg_5_0._water_ripples + 1] = {
		timer = 0,
		pos = Vector3Box(arg_5_1),
		size_variable = 1 - random_ripple_size_diff * 0.5 + Math.random() * random_ripple_size_diff,
		angle = arg_5_2,
		material = arg_5_3 or water.default_ripple_material,
		stretch_multiplier = arg_5_5,
		ref_time = arg_5_6,
		default_size = arg_5_7,
		multiplier = arg_5_8
	}
end

WorldInteractionManager.add_simple_effect = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not Unit.alive(flag) then
		local var_6_2 = WorldInteractionSettings[arg_6_1]
		local num = math.clamp(var_6_2.window_size, 1, 100) * 0.5
		local var_6_4 = POSITION_LOOKUP[flag]

		if Vector3.distance_squared(var_6_4, arg_6_3) < num * num then
			self["_add_simple_" .. arg_6_1 .. "_effect"](self, arg_6_2, arg_6_3, arg_6_4)
		end
	end
end

WorldInteractionManager._add_simple_water_effect = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local water = WorldInteractionSettings.water
	local default_unit_water

	if not arg_7_3 then
		default_unit_water = water.default_unit_water

		if not default_unit_water then
			-- Nothing
		end
	end

	default_unit_water = water.default_water

	::label_7_0::

	local default_material = default_unit_water.default_material
	local clamp = math.clamp(water.window_size, 1, 100)
	local stretch_multiplier = default_unit_water.stretch_multiplier
	local multiplier = default_unit_water.multiplier
	local timer_ref = default_unit_water.timer_ref
	local random_size_diff = default_unit_water.random_size_diff
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not Unit.alive(flag) then
		local num = clamp * 0.5
		local var_7_11 = POSITION_LOOKUP[flag]
		local start_size = default_unit_water.start_size

		if Vector3.distance_squared(arg_7_2, var_7_11) < num * num then
			self:_add_water_ripple(arg_7_2, 0, default_material, random_size_diff, stretch_multiplier, timer_ref, start_size, multiplier)
		end
	end
end

WorldInteractionManager.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not Managers.state.network:game() then
		self:_update_water(arg_8_1, arg_8_2)
		self:_update_foliage(arg_8_1, arg_8_2)
	end
end

WorldInteractionManager._update_water = function (self, arg_9_1, arg_9_2)
	-- function 9
	local water = self._units.water
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not Unit.alive(flag) and (#self._water_ripples > 0 or not water or not next(water)) then
		self:_cleanup_removed_units()
		self:_update_water_data(arg_9_1, arg_9_2)
		self:_update_water_ripples(arg_9_1, arg_9_2)
	end
end

local tbl_2 = {}

WorldInteractionManager._cleanup_removed_units = function (self)
	-- function 10
	local unit_death_watch_lookup = Managers.state.spawn.unit_spawner.unit_death_watch_lookup

	table.clear(tbl_2)

	for k, v in pairs(self._units) do
		for k_2, v_2 in pairs(v) do
			if not Unit.alive(k_2) and not unit_death_watch_lookup[k_2] then
				tbl_2[#tbl_2 + 1] = k_2
			end
		end
	end

	for k_3, v_3 in pairs(self._units) do
		for i, v_4 in ipairs(tbl_2) do
			v_3[v_4] = nil
		end
	end
end

local tbl_3 = {}

WorldInteractionManager._update_water_data = function (self, arg_11_1, arg_11_2)
	-- function 11
	local water = WorldInteractionSettings.water
	local clamp = math.clamp(water.window_size, 1, 100)
	local water_speed_limit = water.water_speed_limit
	local ripple_time_step = water.ripple_time_step
	local max_contributing_units = water.max_contributing_units
	local _water_timer = self._water_timer

	_water_timer = _water_timer or 0
	self._water_timer = _water_timer

	local num = 1

	if ripple_time_step <= self._water_timer then
		local water_2 = self._units.water
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local num_2 = clamp * 0.5
		local var_11_11 = POSITION_LOOKUP[flag]

		if not Unit.alive(flag) and not water_2 and not next(water_2) then
			local players = Managers.player:players()

			for k, v in pairs(players) do
				local player_unit = v.player_unit

				if not water_2[player_unit] then
					local var_11_14 = POSITION_LOOKUP[player_unit]

					if not (not var_11_14 and not (Vector3.distance_squared(var_11_14, var_11_11) < num_2 * num_2)) then
						tbl_3[num] = player_unit
						num = num + 1
					end
				end
			end

			local broadphase = Managers.state.entity:system("ai_system").broadphase
			local query = Broadphase.query(broadphase, var_11_11, clamp * 0.5, tbl)

			for k_2 = 1, query do
				local var_11_17 = tbl[k_2]

				if not water_2[var_11_17] then
					tbl_3[num] = var_11_17
					num = num + 1
				end
			end

			local var_11_18 = Vector3(0, 0, 0)
			local num_3 = water_speed_limit * water_speed_limit
			local num_4 = 0

			for l = 1, num - 1 do
				local var_11_21 = tbl_3[l]

				if not Unit.alive(var_11_21) then
					local has_extension = ScriptUnit.has_extension(var_11_21, "locomotion_system")

					if not has_extension then
						local current_velocity = has_extension.current_velocity

						current_velocity = not current_velocity and has_extension:current_velocity()

						if not (not current_velocity and not (num_3 < Vector3.distance_squared(Vector3.flat(current_velocity), var_11_18))) then
							local normalize = Vector3.normalize(Vector3(current_velocity[1], current_velocity[2], 0))
							local dot = Vector3.dot(normalize, Vector3(0, 1, 0))
							local clamp_2 = math.clamp(dot, -1, 1)
							local acos = math.acos(clamp_2)
							local flag_2

							flag_2 = not (normalize[1] < 0) or not 1 or -1

							local num_5 = acos * flag_2
							local var_11_30 = POSITION_LOOKUP[var_11_21]

							if num_5 == num_5 then
								self:_add_water_ripple(var_11_30, num_5)

								num_4 = num_4 + 1

								if max_contributing_units <= num_4 then
									break
								elseif arg_11_2 > water_2[var_11_21] then
									local make_position_auto_source, var_11_32 = WwiseUtils.make_position_auto_source(self._world, var_11_30)

									WwiseWorld.trigger_event(var_11_32, water.ripple_sound_event, make_position_auto_source)

									water_2[var_11_21] = Managers.time:time("game") + water.ripple_sound_event_delay
								end
							end
						end
					end
				end
			end

			self._water_timer = 0
		end
	end

	self._water_timer = self._water_timer + arg_11_1
end

local tbl_4 = {}

WorldInteractionManager._update_water_ripples = function (self, arg_12_1, arg_12_2)
	-- function 12
	table.clear(tbl_4)

	local water = WorldInteractionSettings.water
	local default_ripple_material = water.default_ripple_material
	local default_ripple_start_size = water.default_ripple_start_size
	local default_ripple_multiplier = water.default_ripple_multiplier
	local default_ripple_timer = water.default_ripple_timer
	local duplicate_edge_cases = water.duplicate_edge_cases
	local ripple_stretch_multiplier = water.ripple_stretch_multiplier
	local resolution, var_12_8 = Gui.resolution()
	local clamp = math.clamp(water.window_size, 1, 100)
	local num = 0
	local var_12_11
	local count = #self._water_ripples

	for i = 1, count do
		local var_12_13 = self._water_ripples[i]
		local ref_time = var_12_13.ref_time

		ref_time = ref_time or default_ripple_timer

		local unbox = var_12_13.pos:unbox()
		local stretch_multiplier = var_12_13.stretch_multiplier

		stretch_multiplier = stretch_multiplier or ripple_stretch_multiplier

		local multiplier = var_12_13.multiplier

		multiplier = multiplier or default_ripple_multiplier

		local default_size = var_12_13.default_size

		default_size = default_size or default_ripple_start_size

		local var_12_19 = default_size[1]
		local size_variable = var_12_13.size_variable

		size_variable = size_variable or 0

		local num_2 = var_12_19 * size_variable
		local easeOutCubic = math.easeOutCubic(var_12_13.timer / ref_time)
		local lerp = math.lerp(num_2, num_2 * multiplier, easeOutCubic)
		local var_12_24 = Vector2(unbox[1] % clamp, unbox[2] % clamp)
		local var_12_25 = Vector2(var_12_24[1] / clamp, var_12_24[2] / clamp)
		local var_12_26 = Vector3(var_12_25[1] * resolution, var_12_8 - var_12_25[2] * var_12_8, 0)
		local var_12_27 = Vector2(lerp * stretch_multiplier[1] / clamp * resolution, lerp * stretch_multiplier[2] / clamp * var_12_8)
		local num_3 = 50
		local angle = var_12_13.angle
		local num_4 = var_12_26 - var_12_27 * 0.5
		local var_12_31 = Rotation2D(Vector3(0, 0, 0), angle, num_4 + var_12_27 * 0.5)
		local num_5 = 1 - math.pow(var_12_13.timer / ref_time, 3)
		local num_6 = (1 - easeOutCubic) * 255

		Gui.bitmap_3d(self._gui, var_12_13.material, var_12_31, num_4, num_3, var_12_27, Color(num_6, 255, 255, 255))

		num = num + 1

		if not duplicate_edge_cases then
			if num_4.x < 0 then
				local num_7 = num_4 + Vector3(resolution, 0, 0)
				local var_12_35 = Rotation2D(Vector3(0, 0, 0), angle, num_7 + var_12_27 * 0.5)

				Gui.bitmap_3d(self._gui, var_12_13.material, var_12_35, num_7, num_3, var_12_27, Color(num_6, 255, 255, 255))

				num = num + 1
			elseif resolution < num_4.x + var_12_27.x then
				local num_8 = num_4 + Vector3(-resolution, 0, 0)
				local var_12_37 = Rotation2D(Vector3(0, 0, 0), angle, num_8 + var_12_27 * 0.5)

				Gui.bitmap_3d(self._gui, var_12_13.material, var_12_37, num_8, num_3, var_12_27, Color(num_6, 255, 255, 255))

				num = num + 1
			end

			if num_4.y < 0 then
				local num_9 = num_4 + Vector3(0, var_12_8, 0)
				local var_12_39 = Rotation2D(Vector3(0, 0, 0), angle, num_9 + var_12_27 * 0.5)

				Gui.bitmap_3d(self._gui, var_12_13.material, var_12_39, num_9, num_3, var_12_27, Color(num_6, 255, 255, 255))

				num = num + 1
			elseif var_12_8 < num_4.y + var_12_27.x then
				local num_10 = num_4 + Vector3(0, -var_12_8, 0)
				local var_12_41 = Rotation2D(Vector3(0, 0, 0), angle, num_10 + var_12_27 * 0.5)

				Gui.bitmap_3d(self._gui, var_12_13.material, var_12_41, num_10, num_3, var_12_27, Color(num_6, 255, 255, 255))

				num = num + 1
			end
		end

		var_12_13.timer = var_12_13.timer + arg_12_1

		if ref_time <= var_12_13.timer then
			tbl_4[#tbl_4 + 1] = i
		end
	end

	for j = #tbl_4, 1, -1 do
		local var_12_42 = tbl_4[j]

		table.remove(self._water_ripples, var_12_42)
	end
end

WorldInteractionManager._update_foliage = function (self, arg_13_1, arg_13_2)
	-- function 13
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not Unit.alive(flag) then
		self:_update_foliage_players(arg_13_1, arg_13_2)
		self:_update_foliage_ai(flag, arg_13_1, arg_13_2)
	end
end

local tbl_5 = {}

WorldInteractionManager._update_foliage_players = function (self, arg_14_1, arg_14_2)
	-- function 14
	local foliage = WorldInteractionSettings.foliage
	local default_foliage_material = foliage.default_foliage_material
	local clamp = math.clamp(foliage.window_size, 1, 100)
	local default_texture_world_size = foliage.default_texture_world_size
	local duplicate_edge_cases = foliage.duplicate_edge_cases
	local local_player_multiplier = foliage.local_player_multiplier
	local players = Managers.player:players()
	local resolution, var_14_8 = Gui.resolution()

	for k, v in pairs(players) do
		local player_unit = v.player_unit
		local var_14_10 = POSITION_LOOKUP[player_unit]

		if not var_14_10 then
			local mover = Unit.mover(player_unit)

			if not Mover.collides_down(mover) then
				local var_14_12

				if not v.local_player then
					tbl_5[1] = default_texture_world_size[1] * local_player_multiplier
					tbl_5[2] = default_texture_world_size[2] * local_player_multiplier
					var_14_12 = tbl_5
				else
					var_14_12 = default_texture_world_size
				end

				local var_14_13 = Vector2(var_14_10[1] % clamp, var_14_10[2] % clamp)
				local var_14_14 = Vector2(var_14_13[1] / clamp, var_14_13[2] / clamp)
				local var_14_15 = Vector3(var_14_14[1] * resolution, var_14_8 - var_14_14[2] * var_14_8, 0)
				local var_14_16 = Vector2(var_14_12[1] / clamp * resolution, var_14_12[2] / clamp * var_14_8)
				local num = var_14_15 - var_14_16 * 0.5

				Gui.bitmap(self._gui, default_foliage_material, num, var_14_16, Color(255, 255, 255, 255))

				if not duplicate_edge_cases then
					if num.x < 0 then
						local num_2 = num + Vector3(resolution, 0, 0)

						Gui.bitmap(self._gui, default_foliage_material, num_2, var_14_16, Color(255, 255, 255, 255))
					elseif resolution < num.x + var_14_16.x then
						local num_3 = num + Vector3(-resolution, 0, 0)

						Gui.bitmap(self._gui, default_foliage_material, num_3, var_14_16, Color(255, 255, 255, 255))
					end

					if num.y < 0 then
						local num_4 = num + Vector3(0, var_14_8, 0)

						Gui.bitmap(self._gui, default_foliage_material, num_4, var_14_16, Color(255, 255, 255, 255))
					elseif var_14_8 < num.y + var_14_16.x then
						local num_5 = num + Vector3(0, -var_14_8, 0)

						Gui.bitmap(self._gui, default_foliage_material, num_5, var_14_16, Color(255, 255, 255, 255))
					end
				end
			end
		end
	end
end

WorldInteractionManager._update_foliage_ai = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local foliage = WorldInteractionSettings.foliage
	local default_foliage_material = foliage.default_foliage_material
	local clamp = math.clamp(foliage.window_size, 1, 100)
	local default_texture_world_size = foliage.default_texture_world_size
	local duplicate_edge_cases = foliage.duplicate_edge_cases
	local resolution, var_15_6 = Gui.resolution()
	local local_position = Unit.local_position(arg_15_1, 0)
	local broadphase = Managers.state.entity:system("ai_system").broadphase
	local var_15_9
	local query = Broadphase.query(broadphase, local_position, clamp * 0.5, tbl)

	for i = 1, query do
		local var_15_11 = tbl[i]

		if not Unit.alive(var_15_11) then
			local var_15_12 = POSITION_LOOKUP[var_15_11]
			local var_15_13 = Vector2(var_15_12[1] % clamp, var_15_12[2] % clamp)
			local var_15_14 = Vector2(var_15_13[1] / clamp, var_15_13[2] / clamp)
			local var_15_15 = Vector3(var_15_14[1] * resolution, var_15_6 - var_15_14[2] * var_15_6, 0)
			local var_15_16 = Vector2(default_texture_world_size[1] / clamp * resolution, default_texture_world_size[2] / clamp * var_15_6)
			local num = var_15_15 - var_15_16 * 0.5

			Gui.bitmap(self._gui, default_foliage_material, num, var_15_16, Color(255, 255, 255, 255))

			if not duplicate_edge_cases then
				if num.x < 0 then
					local num_2 = num + Vector3(resolution, 0, 0)

					Gui.bitmap(self._gui, default_foliage_material, num_2, var_15_16, Color(255, 255, 255, 255))
				elseif resolution < num.x + var_15_16.x then
					local num_3 = num + Vector3(-resolution, 0, 0)

					Gui.bitmap(self._gui, default_foliage_material, num_3, var_15_16, Color(255, 255, 255, 255))
				end

				if num.y < 0 then
					local num_4 = num + Vector3(0, var_15_6, 0)

					Gui.bitmap(self._gui, default_foliage_material, num_4, var_15_16, Color(255, 255, 255, 255))
				elseif var_15_6 < num.y + var_15_16.x then
					local num_5 = num + Vector3(0, -var_15_6, 0)

					Gui.bitmap(self._gui, default_foliage_material, num_5, var_15_16, Color(255, 255, 255, 255))
				end
			end
		end
	end
end

WorldInteractionManager.destory = function (arg_16_0)
	-- function 16
	return
end
