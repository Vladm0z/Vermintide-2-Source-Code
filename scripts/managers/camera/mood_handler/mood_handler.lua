-- chunkname: @scripts/managers/camera/mood_handler/mood_handler.lua

require("scripts/settings/mood_settings")

MoodHandler = class(MoodHandler)

MoodHandler.init = function (self, arg_1_1)
	-- function 1
	self.world = arg_1_1
	self.playing_particles = {}
	self.current_mood = "default"
	self.mood_blends = nil
	self.mood_weights = {}

	local scripts_settings_lua_environments_moods = require("scripts/settings/lua_environments/moods")
	local parse_environment_settings, var_1_2 = self:parse_environment_settings(scripts_settings_lua_environments_moods)

	self.environment_variables = parse_environment_settings
	self.environment_variables_type_map = var_1_2
	self.environment_variables_to_set = {}
	self.environment_weight_remainder = 1
	self._local_moods = {}
	self._mood_timers = {}

	for k, v in pairs(MoodSettings) do
		self._local_moods[k] = {}
		self._mood_timers[k] = {}
	end
end

MoodHandler.destroy = function (self)
	-- function 2
	local world = self.world
	local playing_particles = self.playing_particles

	for k, v in pairs(playing_particles) do
		if not World.are_particles_playing(world, v) then
			World.destroy_particles(world, v)
		end
	end

	self.playing_particles = nil
	self.world = nil
	self.environment_variables = nil
	self.mood_blends = nil
	self.environment_variables_to_set = nil
	self.mood_weights = nil
end

MoodHandler.parse_environment_settings = function (arg_3_0, arg_3_1)
	-- function 3
	local settings = arg_3_1.settings
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(settings) do
		if k ~= "default" then
			tbl[k] = {}

			local num = 1

			for k_2, v_2 in pairs(v.variables) do
				if v.variable_weights[k_2] == 1 then
					local var_3_4

					if type(v_2) == "string" then
						var_3_4 = "texture"
					elseif type(v_2) == "number" then
						var_3_4 = "scalar"
					elseif type(v_2) == "table" then
						if #v_2 == 2 then
							var_3_4 = "vector2"
							v_2 = Vector3Box(v_2[1], v_2[2], 0)
						elseif #v_2 == 3 then
							var_3_4 = "vector3"
							v_2 = Vector3Box(v_2[1], v_2[2], v_2[3])
						elseif #v_2 == 4 then
							var_3_4 = "vector4"
						end
					end

					if not var_3_4 then
						tbl[k][num] = {
							name = k_2,
							value = v_2
						}

						local var_3_5 = tbl_2[k_2]

						var_3_5 = var_3_5 or var_3_4
						tbl_2[k_2] = var_3_5
						num = num + 1
					end
				end
			end
		end
	end

	return tbl, tbl_2
end

MoodHandler._set_active_mood = function (self, arg_4_1)
	-- function 4
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	fassert(not arg_4_1 and arg_4_1 == "default" or MoodSettings[arg_4_1], "Mood %q not defined in MoodSettings.lua", arg_4_1)

	local current_mood = self.current_mood

	if arg_4_1 == current_mood then
		return
	end

	self:add_mood_blend(current_mood, arg_4_1)
	self:handle_particles(current_mood, arg_4_1)

	self.current_mood = arg_4_1
end

MoodHandler.add_mood_blend = function (self, arg_5_1, arg_5_2)
	-- function 5
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	local var_5_0

	if arg_5_2 == "default" then
		var_5_0 = MoodSettings[arg_5_1].blend_out_time
	else
		var_5_0 = MoodSettings[arg_5_2].blend_in_time
	end

	if var_5_0 == 0 then
		self.mood_blends = nil
	else
		self.mood_blends = {
			value = 0,
			mood = arg_5_1,
			speed = 1 / var_5_0,
			blends = self.mood_blends
		}
	end
end

MoodHandler.handle_particles = function (self, arg_6_1, arg_6_2)
	-- function 6
	local playing_particles = self.playing_particles
	local world = self.world

	for k, v in pairs(playing_particles) do
		if not World.are_particles_playing(world, v) then
			World.stop_spawning_particles(world, v)
		end
	end

	table.clear(playing_particles)

	if arg_6_1 ~= "default" then
		local particle_effects_on_exit = MoodSettings[arg_6_1].particle_effects_on_exit

		if not particle_effects_on_exit then
			for k_2, v_2 in pairs(particle_effects_on_exit) do
				playing_particles[#playing_particles + 1] = World.create_particles(world, v_2, Vector3.zero())
			end
		end
	end

	if arg_6_2 ~= "default" then
		local var_6_3 = MoodSettings[arg_6_2]
		local no_particles_on_enter_from = var_6_3.no_particles_on_enter_from

		if not (not no_particles_on_enter_from and not table.find(no_particles_on_enter_from, arg_6_1)) then
			local particle_effects_on_enter = var_6_3.particle_effects_on_enter

			if not particle_effects_on_enter then
				local playing_particles_2 = self.playing_particles
				local world_2 = self.world

				for k_3, v_3 in pairs(particle_effects_on_enter) do
					playing_particles_2[#playing_particles_2 + 1] = World.create_particles(world_2, v_3, Vector3.zero())
				end
			end
		end
	end
end

MoodHandler.update = function (self, arg_7_1)
	-- function 7
	self:_update_mood_timers()
	self:update_mood_blends(arg_7_1)
	self:update_environment_variables()
end

MoodHandler.update_mood_blends = function (self, arg_8_1)
	-- function 8
	local mood_weights = self.mood_weights

	table.clear(mood_weights)

	mood_weights[1] = self.current_mood

	self:set_mood_weights(arg_8_1, self.mood_blends, mood_weights, 1)
end

MoodHandler.set_mood_weights = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	if not arg_9_2 then
		arg_9_2.value = arg_9_2.value + arg_9_2.speed * arg_9_1

		if arg_9_2.value >= 1 then
			arg_9_2.blends = nil
			arg_9_3[#arg_9_3 + 1] = arg_9_4
		else
			arg_9_3[#arg_9_3 + 1] = arg_9_2.value * arg_9_4
			arg_9_3[#arg_9_3 + 1] = arg_9_2.mood

			return self:set_mood_weights(arg_9_1, arg_9_2.blends, arg_9_3, arg_9_4 * (1 - arg_9_2.value))
		end
	else
		arg_9_3[#arg_9_3 + 1] = arg_9_4
	end
end

MoodHandler.update_environment_variables = function (self)
	-- function 10
	local environment_variables_to_set = self.environment_variables_to_set

	table.clear(environment_variables_to_set)

	local mood_weights = self.mood_weights
	local environment_variables = self.environment_variables
	local environment_variables_type_map = self.environment_variables_type_map
	local num = 1

	for i = 1, #mood_weights, 2 do
		local var_10_5 = mood_weights[i]

		if var_10_5 ~= "default" then
			local var_10_6 = environment_variables[MoodSettings[var_10_5].environment_setting]
			local var_10_7 = mood_weights[i + 1]

			for j = 1, #var_10_6 do
				local var_10_8 = var_10_6[j]
				local name = var_10_8.name
				local value = var_10_8.value
				local var_10_11 = environment_variables_type_map[name]
				local var_10_12 = environment_variables_to_set[name]

				if var_10_11 == "texture" then
					var_10_12 = var_10_12 or value
				elseif var_10_11 == "scalar" then
					var_10_12 = var_10_12 or 0
					var_10_12 = var_10_12 + value * var_10_7
				elseif not (var_10_11 == "vector2" or var_10_11 ~= "vector3") then
					var_10_12 = var_10_12 or Vector3(0, 0, 0)
					var_10_12 = var_10_12 + value:unbox() * var_10_7
				elseif var_10_11 == "vector4" then
					var_10_12 = var_10_12 or {
						0,
						0,
						0,
						0
					}
					var_10_12[1] = var_10_12[1] + value[1] * var_10_7
					var_10_12[2] = var_10_12[2] + value[2] * var_10_7
					var_10_12[3] = var_10_12[3] + value[3] * var_10_7
					var_10_12[4] = var_10_12[4] + value[4] * var_10_7
				end

				environment_variables_to_set[name] = var_10_12
			end

			num = num - var_10_7
		end
	end

	for k, v in pairs(environment_variables_to_set) do
		local var_10_13 = environment_variables_type_map[k]

		if not (var_10_13 == "vector2" or var_10_13 ~= "vector3") then
			environment_variables_to_set[k] = Vector3Box(v)
		end
	end

	self.environment_weight_remainder = math.max(num, 0)
end

MoodHandler.apply_environment_variables = function (self, arg_11_1)
	-- function 11
	local environment_variables_type_map = self.environment_variables_type_map
	local environment_weight_remainder = self.environment_weight_remainder

	for k, v in pairs(self.environment_variables_to_set) do
		local var_11_2 = environment_variables_type_map[k]

		if environment_weight_remainder == 0 then
			if var_11_2 == "texture" then
				ShadingEnvironment.set_texture(arg_11_1, k, v)
			elseif var_11_2 == "scalar" then
				ShadingEnvironment.set_scalar(arg_11_1, k, v)
			elseif var_11_2 == "vector2" then
				ShadingEnvironment.set_vector2(arg_11_1, k, v:unbox())
			elseif var_11_2 == "vector3" then
				ShadingEnvironment.set_vector3(arg_11_1, k, v:unbox())
			elseif var_11_2 == "vector4" then
				ShadingEnvironment.set_vector4(arg_11_1, k, v[1], v[2], v[3], v[4])
			end
		elseif var_11_2 == "texture" then
			ShadingEnvironment.set_texture(arg_11_1, k, v)
		elseif var_11_2 == "scalar" then
			local num = v + ShadingEnvironment.scalar(arg_11_1, k) * environment_weight_remainder

			ShadingEnvironment.set_scalar(arg_11_1, k, num)
		elseif var_11_2 == "vector2" then
			local num_2 = ShadingEnvironment.vector2(arg_11_1, k) * environment_weight_remainder
			local num_3 = v:unbox() + num_2

			ShadingEnvironment.set_vector2(arg_11_1, k, num_3)
		elseif var_11_2 == "vector3" then
			local num_4 = ShadingEnvironment.vector3(arg_11_1, k) * environment_weight_remainder
			local num_5 = v:unbox() + num_4

			ShadingEnvironment.set_vector3(arg_11_1, k, num_5)
		elseif var_11_2 == "vector4" then
			local to_elements, var_11_9, var_11_10, var_11_11 = Quaternion.to_elements(ShadingEnvironment.vector4(arg_11_1, k))
			local num_6 = to_elements * environment_weight_remainder
			local num_7 = var_11_9 * environment_weight_remainder
			local num_8 = var_11_10 * environment_weight_remainder
			local num_9 = var_11_11 * environment_weight_remainder
			local num_10 = v[1] + num_6
			local num_11 = v[2] + num_7
			local num_12 = v[3] + num_8
			local num_13 = v[4] + num_9

			ShadingEnvironment.set_vector4(arg_11_1, k, num_10, num_11, num_12, num_13)
		end
	end
end

MoodHandler.set_mood = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local has_mood = self:has_mood(arg_12_1)

	if not (arg_12_3 or has_mood) then
		return
	end

	self:_set_mood_internal(arg_12_1, arg_12_2, arg_12_3)

	if not arg_12_3 and not has_mood then
		return
	end

	self:_update_mood_priority()
end

MoodHandler._set_mood_internal = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	arg_13_0._local_moods[arg_13_1][arg_13_2] = arg_13_3 or nil

	if arg_13_1 ~= "default" then
		local var_13_0 = MoodSettings[arg_13_1]

		if not var_13_0.hold_time then
			if not arg_13_3 then
				local time = Managers.time:time("game")

				arg_13_0._mood_timers[arg_13_1][arg_13_2] = time + var_13_0.hold_time
			else
				arg_13_0._mood_timers[arg_13_1][arg_13_2] = nil
			end
		end
	end
end

MoodHandler.clear_mood = function (self, arg_14_1)
	-- function 14
	if not self:has_mood(arg_14_1) then
		return
	end

	table.clear(self._local_moods[arg_14_1])
	table.clear(self._mood_timers[arg_14_1])
	self:_update_mood_priority()
end

MoodHandler.has_mood = function (self, arg_15_1)
	-- function 15
	return not table.is_empty(self._local_moods[arg_15_1])
end

MoodHandler._update_mood_timers = function (self)
	-- function 16
	local flag = false
	local time = Managers.time:time("game")

	for k, v in pairs(self._mood_timers) do
		for k_2, v_2 in pairs(v) do
			if v_2 < time then
				self:set_mood(k, k_2, false)

				flag = flag or table.is_empty(v)
			end
		end
	end

	if not flag then
		self:_update_mood_priority()
	end
end

MoodHandler._update_mood_priority = function (self)
	-- function 17
	local MoodPriority = MoodPriority
	local var_17_1

	for i = 1, #MoodPriority do
		local var_17_2 = MoodPriority[i]

		if not self:has_mood(var_17_2) then
			var_17_1 = var_17_2

			break
		end
	end

	var_17_1 = var_17_1 or "default"

	if var_17_1 ~= self.current_mood then
		self:_set_active_mood(var_17_1)
	end
end
