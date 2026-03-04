-- chunkname: @scripts/settings/mutators/mutator_leash.lua

return {
	beam_material_name = "cloud_1",
	min_damage_distance = 4,
	display_name = "display_name_mutator_leash",
	beam_material_min_intensity = 0.5,
	player_effect_name = "fx/leash_beam_player_01",
	beam_effect_name = "fx/leash_beam_01",
	damage_percentage_per_interval = 0.02,
	max_damage_interval = 0.15,
	center_sound_event = "Play_mutator_leash_center",
	max_damage_distance = 12,
	damage_type = "damage_over_time",
	icon = "mutator_icon_leash",
	min_damage_interval = 1,
	description = "description_mutator_leash",
	stop_damage_sound_event = "Stop_mutator_leash_loop",
	beam_material_max_intensity = 5,
	start_damage_sound_event = "Play_mutator_leash_loop",
	damage_sound_global_parameter = "leash_distance",
	center_effect_name = "fx/leash_beam_center_01",
	calculate_center_position = function (arg_1_0)
		local var_1_0 = 0
		local var_1_1 = Vector3.zero()
		local var_1_2 = arg_1_0.hero_side.PLAYER_UNITS

		for iter_1_0 = 1, #var_1_2 do
			local var_1_3 = var_1_2[iter_1_0]
			local var_1_4 = ScriptUnit.extension(var_1_3, "status_system")

			if HEALTH_ALIVE[var_1_3] and not var_1_4:is_knocked_down() then
				var_1_1 = var_1_1 + POSITION_LOOKUP[var_1_3]
				var_1_0 = var_1_0 + 1
			end
		end

		if var_1_0 > 0 then
			var_1_1 = var_1_1 / var_1_0
		end

		return var_1_1, var_1_0
	end,
	server_start_function = function (arg_2_0, arg_2_1)
		arg_2_1.player_damage_data = {}
		arg_2_1.hero_side = Managers.state.side:get_side_from_name("heroes")
	end,
	server_update_function = function (arg_3_0, arg_3_1)
		local var_3_0 = Managers.time:time("game")
		local var_3_1 = arg_3_1.template
		local var_3_2 = var_3_1.calculate_center_position(arg_3_1)
		local var_3_3 = arg_3_1.player_damage_data
		local var_3_4 = arg_3_1.hero_side.PLAYER_UNITS

		for iter_3_0 = 1, #var_3_4 do
			local var_3_5 = var_3_4[iter_3_0]

			if HEALTH_ALIVE[var_3_5] then
				if var_3_3[var_3_5] == nil then
					var_3_3[var_3_5] = {}
				end

				local var_3_6 = POSITION_LOOKUP[var_3_5]
				local var_3_7 = Vector3.distance(var_3_2, var_3_6)
				local var_3_8 = var_3_3[var_3_5]

				var_3_8.distance_to_center = var_3_7

				if var_3_7 >= var_3_1.min_damage_distance then
					if not var_3_8.do_damage then
						var_3_8.do_damage = true
						var_3_8.last_t = var_3_0
					end
				elseif var_3_8.do_damage then
					var_3_8.do_damage = false
				end
			end
		end

		local var_3_9 = var_3_1.damage_percentage_per_interval
		local var_3_10 = var_3_1.damage_type
		local var_3_11 = var_3_1.min_damage_interval
		local var_3_12 = var_3_1.max_damage_interval
		local var_3_13 = var_3_1.min_damage_distance
		local var_3_14 = var_3_1.max_damage_distance
		local var_3_15 = 1

		for iter_3_1, iter_3_2 in pairs(var_3_3) do
			if not HEALTH_ALIVE[iter_3_1] then
				var_3_3[iter_3_1] = nil
			elseif iter_3_2.do_damage then
				local var_3_16 = ScriptUnit.extension(iter_3_1, "status_system")
				local var_3_17 = (iter_3_2.distance_to_center - var_3_13) / (var_3_14 - var_3_13)
				local var_3_18 = math.lerp(var_3_11, var_3_12, var_3_17)
				local var_3_19 = math.max(var_3_12, var_3_18)

				if var_3_0 > iter_3_2.last_t + var_3_19 and not var_3_16:is_knocked_down() then
					local var_3_20 = ScriptUnit.extension(iter_3_1, "health_system"):get_max_health() * var_3_9
					local var_3_21 = POSITION_LOOKUP[iter_3_1]
					local var_3_22 = Vector3.normalize(var_3_21 - var_3_2)

					DamageUtils.add_damage_network(iter_3_1, iter_3_1, var_3_20, "torso", var_3_10, nil, var_3_22, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, var_3_15)

					var_3_15 = var_3_15 + 1
					iter_3_2.last_t = var_3_0
				end
			end
		end
	end,
	client_start_function = function (arg_4_0, arg_4_1)
		local var_4_0 = arg_4_1.template.beam_effect_name
		local var_4_1 = arg_4_0.world
		local var_4_2 = Managers.player
		local var_4_3

		arg_4_1.wwise_world, var_4_3 = Managers.world:wwise_world(var_4_1), Managers.state.side:get_side_from_name("heroes")
		arg_4_1.local_player = var_4_2:local_player()
		arg_4_1.beam_start_variable_id = World.find_particles_variable(var_4_1, var_4_0, "start")
		arg_4_1.beam_end_variable_id = World.find_particles_variable(var_4_1, var_4_0, "end")
		arg_4_1.center_effect_id = nil
		arg_4_1.center_sound = nil
		arg_4_1.beam_effects = {}
		arg_4_1.playing_sounds = {}
		arg_4_1.hero_side = var_4_3
	end,
	client_update_function = function (arg_5_0, arg_5_1)
		local var_5_0 = arg_5_0.world
		local var_5_1 = arg_5_1.wwise_world
		local var_5_2 = arg_5_1.template
		local var_5_3 = var_5_2.start_damage_sound_event
		local var_5_4 = var_5_2.stop_damage_sound_event
		local var_5_5, var_5_6 = arg_5_1.template.calculate_center_position(arg_5_1)
		local var_5_7 = arg_5_1.beam_effects
		local var_5_8 = arg_5_1.playing_sounds

		if var_5_6 > 1 then
			local var_5_9 = arg_5_1.local_player
			local var_5_10 = Managers.player
			local var_5_11 = var_5_2.center_effect_name
			local var_5_12 = var_5_2.center_sound_event
			local var_5_13 = var_5_2.player_effect_name
			local var_5_14 = var_5_2.beam_effect_name
			local var_5_15 = var_5_2.beam_material_name
			local var_5_16 = var_5_2.beam_material_min_intensity
			local var_5_17 = var_5_2.beam_material_max_intensity
			local var_5_18 = 0.5
			local var_5_19 = var_5_2.max_damage_distance
			local var_5_20 = arg_5_1.beam_start_variable_id
			local var_5_21 = arg_5_1.beam_end_variable_id
			local var_5_22 = var_5_2.min_damage_distance
			local var_5_23 = var_5_2.max_damage_distance

			if arg_5_1.center_effect_id == nil then
				arg_5_1.center_effect_id = World.create_particles(var_5_0, var_5_11, Vector3.zero(), Quaternion.identity())
			end

			local var_5_24 = arg_5_1.center_effect_id

			World.move_particles(var_5_0, var_5_24, var_5_5)

			if arg_5_1.center_sound == nil then
				local var_5_25, var_5_26, var_5_27 = WwiseUtils.trigger_position_event(var_5_0, var_5_12, var_5_5)

				arg_5_1.center_sound = {
					source_id = var_5_26,
					event_id = var_5_25
				}
			end

			WwiseWorld.set_source_position(var_5_1, arg_5_1.center_sound.source_id, var_5_5)

			local var_5_28 = arg_5_1.hero_side.PLAYER_UNITS

			for iter_5_0 = 1, #var_5_28 do
				local var_5_29 = var_5_28[iter_5_0]

				if HEALTH_ALIVE[var_5_29] then
					if not var_5_7[var_5_29] then
						local var_5_30 = World.create_particles(var_5_0, var_5_14, Vector3.zero(), Quaternion.identity())
						local var_5_31 = World.create_particles(var_5_0, var_5_13, Vector3.zero(), Quaternion.identity())

						var_5_7[var_5_29] = {
							beam_effect_id = var_5_30,
							player_effect_id = var_5_31
						}
					end

					local var_5_32
					local var_5_33 = var_5_10:unit_owner(var_5_29)

					if var_5_33 == var_5_9 then
						local var_5_34 = ScriptUnit.extension(var_5_29, "first_person_system").first_person_unit

						var_5_32 = Unit.world_position(var_5_34, Unit.node(var_5_34, "root_point")) - 0.5 * Vector3.up()
					else
						local var_5_35 = Unit.node(var_5_29, "j_spine")

						var_5_32 = Unit.world_position(var_5_29, var_5_35)
					end

					local var_5_36 = var_5_7[var_5_29].player_effect_id

					World.move_particles(var_5_0, var_5_36, var_5_32)

					local var_5_37 = var_5_7[var_5_29].beam_effect_id

					World.set_particles_variable(var_5_0, var_5_37, var_5_20, var_5_5 + Vector3.up() * 0.5)
					World.set_particles_variable(var_5_0, var_5_37, var_5_21, var_5_32)

					local var_5_38 = POSITION_LOOKUP[var_5_29]
					local var_5_39 = Vector3.distance(var_5_5, var_5_38)
					local var_5_40 = math.auto_lerp(var_5_18, var_5_19, var_5_16, var_5_17, var_5_39)
					local var_5_41 = math.clamp(var_5_40, var_5_16, var_5_17)

					World.set_particles_material_scalar(var_5_0, var_5_37, var_5_15, "intensity", var_5_41)

					local var_5_42 = (var_5_39 / var_5_22)^2
					local var_5_43 = math.min(var_5_42, 1)

					World.set_particles_material_scalar(var_5_0, var_5_37, var_5_15, "softness", var_5_43)

					if var_5_33 == var_5_9 then
						if var_5_8[var_5_29] == nil then
							var_5_8[var_5_29] = WwiseWorld.trigger_event(var_5_1, var_5_3)
						end

						local var_5_44

						if var_5_22 <= var_5_39 then
							var_5_44 = math.min(math.auto_lerp(var_5_22, var_5_23, 1, 2, var_5_39), 2)
						else
							var_5_44 = math.auto_lerp(0, var_5_22, 0, 1, var_5_39)
						end

						if var_5_2.damage_sound_global_parameter then
							Managers.state.entity:system("audio_system"):set_global_parameter(var_5_2.damage_sound_global_parameter, var_5_44)
						end
					end
				end
			end
		else
			if arg_5_1.center_effect_id then
				World.destroy_particles(var_5_0, arg_5_1.center_effect_id)

				arg_5_1.center_effect_id = nil
			end

			if arg_5_1.center_sound then
				local var_5_45 = arg_5_1.center_sound.event_id

				WwiseWorld.stop_event(var_5_1, var_5_45)

				arg_5_1.center_sound = nil
			end
		end

		for iter_5_1, iter_5_2 in pairs(var_5_7) do
			if not HEALTH_ALIVE[iter_5_1] or var_5_6 == 1 then
				for iter_5_3, iter_5_4 in pairs(iter_5_2) do
					World.destroy_particles(var_5_0, iter_5_4)
				end

				var_5_7[iter_5_1] = nil

				if var_5_8[iter_5_1] then
					WwiseWorld.trigger_event(var_5_1, var_5_4)

					var_5_8[iter_5_1] = nil
				end
			end
		end
	end,
	client_stop_function = function (arg_6_0, arg_6_1)
		local var_6_0 = arg_6_0.world
		local var_6_1 = arg_6_1.wwise_world
		local var_6_2 = arg_6_1.template

		if arg_6_1.center_effect_id then
			World.destroy_particles(var_6_0, arg_6_1.center_effect_id)

			arg_6_1.center_effect_id = nil
		end

		if arg_6_1.center_sound then
			local var_6_3 = arg_6_1.center_sound.event_id

			WwiseWorld.stop_event(var_6_1, var_6_3)

			arg_6_1.center_sound = nil
		end

		local var_6_4 = arg_6_1.beam_effects
		local var_6_5 = arg_6_1.playing_sounds

		for iter_6_0, iter_6_1 in pairs(var_6_4) do
			for iter_6_2, iter_6_3 in pairs(iter_6_1) do
				World.destroy_particles(var_6_0, iter_6_3)
			end

			var_6_4[iter_6_0] = nil

			if var_6_5[iter_6_0] then
				WwiseWorld.trigger_event(var_6_1, var_6_2.stop_damage_sound_event)

				var_6_5[iter_6_0] = nil
			end
		end
	end
}
