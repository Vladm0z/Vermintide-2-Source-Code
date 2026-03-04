-- chunkname: @scripts/managers/camera/mood_handler/mood_handler.lua

require("scripts/settings/mood_settings")

MoodHandler = class(MoodHandler)

function MoodHandler.init(arg_1_0, arg_1_1)
	arg_1_0.world = arg_1_1
	arg_1_0.playing_particles = {}
	arg_1_0.current_mood = "default"
	arg_1_0.mood_blends = nil
	arg_1_0.mood_weights = {}

	local var_1_0 = require("scripts/settings/lua_environments/moods")
	local var_1_1, var_1_2 = arg_1_0:parse_environment_settings(var_1_0)

	arg_1_0.environment_variables = var_1_1
	arg_1_0.environment_variables_type_map = var_1_2
	arg_1_0.environment_variables_to_set = {}
	arg_1_0.environment_weight_remainder = 1
	arg_1_0._local_moods = {}
	arg_1_0._mood_timers = {}

	for iter_1_0, iter_1_1 in pairs(MoodSettings) do
		arg_1_0._local_moods[iter_1_0] = {}
		arg_1_0._mood_timers[iter_1_0] = {}
	end
end

function MoodHandler.destroy(arg_2_0)
	local var_2_0 = arg_2_0.world
	local var_2_1 = arg_2_0.playing_particles

	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		if World.are_particles_playing(var_2_0, iter_2_1) then
			World.destroy_particles(var_2_0, iter_2_1)
		end
	end

	arg_2_0.playing_particles = nil
	arg_2_0.world = nil
	arg_2_0.environment_variables = nil
	arg_2_0.mood_blends = nil
	arg_2_0.environment_variables_to_set = nil
	arg_2_0.mood_weights = nil
end

function MoodHandler.parse_environment_settings(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.settings
	local var_3_1 = {}
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		if iter_3_0 ~= "default" then
			var_3_1[iter_3_0] = {}

			local var_3_3 = 1

			for iter_3_2, iter_3_3 in pairs(iter_3_1.variables) do
				if iter_3_1.variable_weights[iter_3_2] == 1 then
					local var_3_4

					if type(iter_3_3) == "string" then
						var_3_4 = "texture"
					elseif type(iter_3_3) == "number" then
						var_3_4 = "scalar"
					elseif type(iter_3_3) == "table" then
						if #iter_3_3 == 2 then
							var_3_4 = "vector2"
							iter_3_3 = Vector3Box(iter_3_3[1], iter_3_3[2], 0)
						elseif #iter_3_3 == 3 then
							var_3_4 = "vector3"
							iter_3_3 = Vector3Box(iter_3_3[1], iter_3_3[2], iter_3_3[3])
						elseif #iter_3_3 == 4 then
							var_3_4 = "vector4"
						end
					end

					if var_3_4 then
						var_3_1[iter_3_0][var_3_3] = {
							name = iter_3_2,
							value = iter_3_3
						}
						var_3_2[iter_3_2] = var_3_2[iter_3_2] or var_3_4
						var_3_3 = var_3_3 + 1
					end
				end
			end
		end
	end

	return var_3_1, var_3_2
end

function MoodHandler._set_active_mood(arg_4_0, arg_4_1)
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	fassert(arg_4_1 and (arg_4_1 == "default" or MoodSettings[arg_4_1]), "Mood %q not defined in MoodSettings.lua", arg_4_1)

	local var_4_0 = arg_4_0.current_mood

	if arg_4_1 == var_4_0 then
		return
	end

	arg_4_0:add_mood_blend(var_4_0, arg_4_1)
	arg_4_0:handle_particles(var_4_0, arg_4_1)

	arg_4_0.current_mood = arg_4_1
end

function MoodHandler.add_mood_blend(arg_5_0, arg_5_1, arg_5_2)
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
		arg_5_0.mood_blends = nil
	else
		arg_5_0.mood_blends = {
			value = 0,
			mood = arg_5_1,
			speed = 1 / var_5_0,
			blends = arg_5_0.mood_blends
		}
	end
end

function MoodHandler.handle_particles(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.playing_particles
	local var_6_1 = arg_6_0.world

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if World.are_particles_playing(var_6_1, iter_6_1) then
			World.stop_spawning_particles(var_6_1, iter_6_1)
		end
	end

	table.clear(var_6_0)

	if arg_6_1 ~= "default" then
		local var_6_2 = MoodSettings[arg_6_1].particle_effects_on_exit

		if var_6_2 then
			for iter_6_2, iter_6_3 in pairs(var_6_2) do
				var_6_0[#var_6_0 + 1] = World.create_particles(var_6_1, iter_6_3, Vector3.zero())
			end
		end
	end

	if arg_6_2 ~= "default" then
		local var_6_3 = MoodSettings[arg_6_2]
		local var_6_4 = var_6_3.no_particles_on_enter_from

		if not var_6_4 or not table.find(var_6_4, arg_6_1) then
			local var_6_5 = var_6_3.particle_effects_on_enter

			if var_6_5 then
				local var_6_6 = arg_6_0.playing_particles
				local var_6_7 = arg_6_0.world

				for iter_6_4, iter_6_5 in pairs(var_6_5) do
					var_6_6[#var_6_6 + 1] = World.create_particles(var_6_7, iter_6_5, Vector3.zero())
				end
			end
		end
	end
end

function MoodHandler.update(arg_7_0, arg_7_1)
	arg_7_0:_update_mood_timers()
	arg_7_0:update_mood_blends(arg_7_1)
	arg_7_0:update_environment_variables()
end

function MoodHandler.update_mood_blends(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.mood_weights

	table.clear(var_8_0)

	var_8_0[1] = arg_8_0.current_mood

	arg_8_0:set_mood_weights(arg_8_1, arg_8_0.mood_blends, var_8_0, 1)
end

function MoodHandler.set_mood_weights(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if arg_9_2 then
		arg_9_2.value = arg_9_2.value + arg_9_2.speed * arg_9_1

		if arg_9_2.value >= 1 then
			arg_9_2.blends = nil
			arg_9_3[#arg_9_3 + 1] = arg_9_4
		else
			arg_9_3[#arg_9_3 + 1] = arg_9_2.value * arg_9_4
			arg_9_3[#arg_9_3 + 1] = arg_9_2.mood

			return arg_9_0:set_mood_weights(arg_9_1, arg_9_2.blends, arg_9_3, arg_9_4 * (1 - arg_9_2.value))
		end
	else
		arg_9_3[#arg_9_3 + 1] = arg_9_4
	end
end

function MoodHandler.update_environment_variables(arg_10_0)
	local var_10_0 = arg_10_0.environment_variables_to_set

	table.clear(var_10_0)

	local var_10_1 = arg_10_0.mood_weights
	local var_10_2 = arg_10_0.environment_variables
	local var_10_3 = arg_10_0.environment_variables_type_map
	local var_10_4 = 1

	for iter_10_0 = 1, #var_10_1, 2 do
		local var_10_5 = var_10_1[iter_10_0]

		if var_10_5 ~= "default" then
			local var_10_6 = var_10_2[MoodSettings[var_10_5].environment_setting]
			local var_10_7 = var_10_1[iter_10_0 + 1]

			for iter_10_1 = 1, #var_10_6 do
				local var_10_8 = var_10_6[iter_10_1]
				local var_10_9 = var_10_8.name
				local var_10_10 = var_10_8.value
				local var_10_11 = var_10_3[var_10_9]
				local var_10_12 = var_10_0[var_10_9]

				if var_10_11 == "texture" then
					var_10_12 = var_10_12 or var_10_10
				elseif var_10_11 == "scalar" then
					var_10_12 = var_10_12 or 0
					var_10_12 = var_10_12 + var_10_10 * var_10_7
				elseif var_10_11 == "vector2" or var_10_11 == "vector3" then
					var_10_12 = var_10_12 or Vector3(0, 0, 0)
					var_10_12 = var_10_12 + var_10_10:unbox() * var_10_7
				elseif var_10_11 == "vector4" then
					var_10_12 = var_10_12 or {
						0,
						0,
						0,
						0
					}
					var_10_12[1] = var_10_12[1] + var_10_10[1] * var_10_7
					var_10_12[2] = var_10_12[2] + var_10_10[2] * var_10_7
					var_10_12[3] = var_10_12[3] + var_10_10[3] * var_10_7
					var_10_12[4] = var_10_12[4] + var_10_10[4] * var_10_7
				end

				var_10_0[var_10_9] = var_10_12
			end

			var_10_4 = var_10_4 - var_10_7
		end
	end

	for iter_10_2, iter_10_3 in pairs(var_10_0) do
		local var_10_13 = var_10_3[iter_10_2]

		if var_10_13 == "vector2" or var_10_13 == "vector3" then
			var_10_0[iter_10_2] = Vector3Box(iter_10_3)
		end
	end

	arg_10_0.environment_weight_remainder = math.max(var_10_4, 0)
end

function MoodHandler.apply_environment_variables(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.environment_variables_type_map
	local var_11_1 = arg_11_0.environment_weight_remainder

	for iter_11_0, iter_11_1 in pairs(arg_11_0.environment_variables_to_set) do
		local var_11_2 = var_11_0[iter_11_0]

		if var_11_1 == 0 then
			if var_11_2 == "texture" then
				ShadingEnvironment.set_texture(arg_11_1, iter_11_0, iter_11_1)
			elseif var_11_2 == "scalar" then
				ShadingEnvironment.set_scalar(arg_11_1, iter_11_0, iter_11_1)
			elseif var_11_2 == "vector2" then
				ShadingEnvironment.set_vector2(arg_11_1, iter_11_0, iter_11_1:unbox())
			elseif var_11_2 == "vector3" then
				ShadingEnvironment.set_vector3(arg_11_1, iter_11_0, iter_11_1:unbox())
			elseif var_11_2 == "vector4" then
				ShadingEnvironment.set_vector4(arg_11_1, iter_11_0, iter_11_1[1], iter_11_1[2], iter_11_1[3], iter_11_1[4])
			end
		elseif var_11_2 == "texture" then
			ShadingEnvironment.set_texture(arg_11_1, iter_11_0, iter_11_1)
		elseif var_11_2 == "scalar" then
			local var_11_3 = iter_11_1 + ShadingEnvironment.scalar(arg_11_1, iter_11_0) * var_11_1

			ShadingEnvironment.set_scalar(arg_11_1, iter_11_0, var_11_3)
		elseif var_11_2 == "vector2" then
			local var_11_4 = ShadingEnvironment.vector2(arg_11_1, iter_11_0) * var_11_1
			local var_11_5 = iter_11_1:unbox() + var_11_4

			ShadingEnvironment.set_vector2(arg_11_1, iter_11_0, var_11_5)
		elseif var_11_2 == "vector3" then
			local var_11_6 = ShadingEnvironment.vector3(arg_11_1, iter_11_0) * var_11_1
			local var_11_7 = iter_11_1:unbox() + var_11_6

			ShadingEnvironment.set_vector3(arg_11_1, iter_11_0, var_11_7)
		elseif var_11_2 == "vector4" then
			local var_11_8, var_11_9, var_11_10, var_11_11 = Quaternion.to_elements(ShadingEnvironment.vector4(arg_11_1, iter_11_0))
			local var_11_12 = var_11_8 * var_11_1
			local var_11_13 = var_11_9 * var_11_1
			local var_11_14 = var_11_10 * var_11_1
			local var_11_15 = var_11_11 * var_11_1
			local var_11_16 = iter_11_1[1] + var_11_12
			local var_11_17 = iter_11_1[2] + var_11_13
			local var_11_18 = iter_11_1[3] + var_11_14
			local var_11_19 = iter_11_1[4] + var_11_15

			ShadingEnvironment.set_vector4(arg_11_1, iter_11_0, var_11_16, var_11_17, var_11_18, var_11_19)
		end
	end
end

function MoodHandler.set_mood(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0:has_mood(arg_12_1)

	if not arg_12_3 and not var_12_0 then
		return
	end

	arg_12_0:_set_mood_internal(arg_12_1, arg_12_2, arg_12_3)

	if arg_12_3 and var_12_0 then
		return
	end

	arg_12_0:_update_mood_priority()
end

function MoodHandler._set_mood_internal(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0._local_moods[arg_13_1][arg_13_2] = arg_13_3 or nil

	if arg_13_1 ~= "default" then
		local var_13_0 = MoodSettings[arg_13_1]

		if var_13_0.hold_time then
			if arg_13_3 then
				local var_13_1 = Managers.time:time("game")

				arg_13_0._mood_timers[arg_13_1][arg_13_2] = var_13_1 + var_13_0.hold_time
			else
				arg_13_0._mood_timers[arg_13_1][arg_13_2] = nil
			end
		end
	end
end

function MoodHandler.clear_mood(arg_14_0, arg_14_1)
	if not arg_14_0:has_mood(arg_14_1) then
		return
	end

	table.clear(arg_14_0._local_moods[arg_14_1])
	table.clear(arg_14_0._mood_timers[arg_14_1])
	arg_14_0:_update_mood_priority()
end

function MoodHandler.has_mood(arg_15_0, arg_15_1)
	return not table.is_empty(arg_15_0._local_moods[arg_15_1])
end

function MoodHandler._update_mood_timers(arg_16_0)
	local var_16_0 = false
	local var_16_1 = Managers.time:time("game")

	for iter_16_0, iter_16_1 in pairs(arg_16_0._mood_timers) do
		for iter_16_2, iter_16_3 in pairs(iter_16_1) do
			if iter_16_3 < var_16_1 then
				arg_16_0:set_mood(iter_16_0, iter_16_2, false)

				var_16_0 = var_16_0 or table.is_empty(iter_16_1)
			end
		end
	end

	if var_16_0 then
		arg_16_0:_update_mood_priority()
	end
end

function MoodHandler._update_mood_priority(arg_17_0)
	local var_17_0 = MoodPriority
	local var_17_1

	for iter_17_0 = 1, #var_17_0 do
		local var_17_2 = var_17_0[iter_17_0]

		if arg_17_0:has_mood(var_17_2) then
			var_17_1 = var_17_2

			break
		end
	end

	var_17_1 = var_17_1 or "default"

	if var_17_1 ~= arg_17_0.current_mood then
		arg_17_0:_set_active_mood(var_17_1)
	end
end
