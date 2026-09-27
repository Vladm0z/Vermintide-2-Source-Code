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
	calculate_center_position = function (self)
		-- function 1
		local num = 0
		local zero = Vector3.zero()
		local PLAYER_UNITS = self.hero_side.PLAYER_UNITS

		for i = 1, #PLAYER_UNITS do
			local var_1_3 = PLAYER_UNITS[i]
			local extension = ScriptUnit.extension(var_1_3, "status_system")

			if not (not HEALTH_ALIVE[var_1_3] and extension:is_knocked_down()) then
				zero = zero + POSITION_LOOKUP[var_1_3]
				num = num + 1
			end
		end

		if num > 0 then
			zero = zero / num
		end

		return zero, num
	end,
	server_start_function = function (arg_2_0, arg_2_1)
		-- function 2
		arg_2_1.player_damage_data = {}
		arg_2_1.hero_side = Managers.state.side:get_side_from_name("heroes")
	end,
	server_update_function = function (arg_3_0, arg_3_1)
		-- function 3
		local time = Managers.time:time("game")
		local template = arg_3_1.template
		local calculate_center_position = template.calculate_center_position(arg_3_1)
		local player_damage_data = arg_3_1.player_damage_data
		local PLAYER_UNITS = arg_3_1.hero_side.PLAYER_UNITS

		for i = 1, #PLAYER_UNITS do
			local var_3_5 = PLAYER_UNITS[i]

			if not HEALTH_ALIVE[var_3_5] then
				if player_damage_data[var_3_5] == nil then
					player_damage_data[var_3_5] = {}
				end

				local var_3_6 = POSITION_LOOKUP[var_3_5]
				local distance = Vector3.distance(calculate_center_position, var_3_6)
				local var_3_8 = player_damage_data[var_3_5]

				var_3_8.distance_to_center = distance

				if distance >= template.min_damage_distance then
					if not var_3_8.do_damage then
						var_3_8.do_damage = true
						var_3_8.last_t = time
					end
				elseif not var_3_8.do_damage then
					var_3_8.do_damage = false
				end
			end
		end

		local damage_percentage_per_interval = template.damage_percentage_per_interval
		local damage_type = template.damage_type
		local min_damage_interval = template.min_damage_interval
		local max_damage_interval = template.max_damage_interval
		local min_damage_distance = template.min_damage_distance
		local max_damage_distance = template.max_damage_distance
		local num = 1

		for k, v in pairs(player_damage_data) do
			if not HEALTH_ALIVE[k] then
				player_damage_data[k] = nil
			elseif not v.do_damage then
				local extension = ScriptUnit.extension(k, "status_system")
				local num_2 = (v.distance_to_center - min_damage_distance) / (max_damage_distance - min_damage_distance)
				local lerp = math.lerp(min_damage_interval, max_damage_interval, num_2)
				local max = math.max(max_damage_interval, lerp)

				if not (not (time > v.last_t + max) or extension:is_knocked_down()) then
					local num_3 = ScriptUnit.extension(k, "health_system"):get_max_health() * damage_percentage_per_interval
					local var_3_21 = POSITION_LOOKUP[k]
					local normalize = Vector3.normalize(var_3_21 - calculate_center_position)

					DamageUtils.add_damage_network(k, k, num_3, "torso", damage_type, nil, normalize, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, num)

					num = num + 1
					v.last_t = time
				end
			end
		end
	end,
	client_start_function = function (self, arg_4_1)
		-- function 4
		local beam_effect_name = arg_4_1.template.beam_effect_name
		local world = self.world
		local player = Managers.player
		local get_side_from_name

		arg_4_1.wwise_world, get_side_from_name = Managers.world:wwise_world(world), Managers.state.side:get_side_from_name("heroes")
		arg_4_1.local_player = player:local_player()
		arg_4_1.beam_start_variable_id = World.find_particles_variable(world, beam_effect_name, "start")
		arg_4_1.beam_end_variable_id = World.find_particles_variable(world, beam_effect_name, "end")
		arg_4_1.center_effect_id = nil
		arg_4_1.center_sound = nil
		arg_4_1.beam_effects = {}
		arg_4_1.playing_sounds = {}
		arg_4_1.hero_side = get_side_from_name
	end,
	client_update_function = function (self, arg_5_1)
		-- function 5
		local world = self.world
		local wwise_world = arg_5_1.wwise_world
		local template = arg_5_1.template
		local start_damage_sound_event = template.start_damage_sound_event
		local stop_damage_sound_event = template.stop_damage_sound_event
		local calculate_center_position, var_5_6 = arg_5_1.template.calculate_center_position(arg_5_1)
		local beam_effects = arg_5_1.beam_effects
		local playing_sounds = arg_5_1.playing_sounds

		if var_5_6 > 1 then
			local local_player = arg_5_1.local_player
			local player = Managers.player
			local center_effect_name = template.center_effect_name
			local center_sound_event = template.center_sound_event
			local player_effect_name = template.player_effect_name
			local beam_effect_name = template.beam_effect_name
			local beam_material_name = template.beam_material_name
			local beam_material_min_intensity = template.beam_material_min_intensity
			local beam_material_max_intensity = template.beam_material_max_intensity
			local num = 0.5
			local max_damage_distance = template.max_damage_distance
			local beam_start_variable_id = arg_5_1.beam_start_variable_id
			local beam_end_variable_id = arg_5_1.beam_end_variable_id
			local min_damage_distance = template.min_damage_distance
			local max_damage_distance_2 = template.max_damage_distance

			if arg_5_1.center_effect_id == nil then
				arg_5_1.center_effect_id = World.create_particles(world, center_effect_name, Vector3.zero(), Quaternion.identity())
			end

			local center_effect_id = arg_5_1.center_effect_id

			World.move_particles(world, center_effect_id, calculate_center_position)

			if arg_5_1.center_sound == nil then
				local trigger_position_event, var_5_26, var_5_27 = WwiseUtils.trigger_position_event(world, center_sound_event, calculate_center_position)

				arg_5_1.center_sound = {
					source_id = var_5_26,
					event_id = trigger_position_event
				}
			end

			WwiseWorld.set_source_position(wwise_world, arg_5_1.center_sound.source_id, calculate_center_position)

			local PLAYER_UNITS = arg_5_1.hero_side.PLAYER_UNITS

			for i = 1, #PLAYER_UNITS do
				local var_5_29 = PLAYER_UNITS[i]

				if not HEALTH_ALIVE[var_5_29] then
					if not beam_effects[var_5_29] then
						local create_particles = World.create_particles(world, beam_effect_name, Vector3.zero(), Quaternion.identity())
						local create_particles_2 = World.create_particles(world, player_effect_name, Vector3.zero(), Quaternion.identity())

						beam_effects[var_5_29] = {
							beam_effect_id = create_particles,
							player_effect_id = create_particles_2
						}
					end

					local var_5_32
					local unit_owner = player:unit_owner(var_5_29)

					if unit_owner == local_player then
						local first_person_unit = ScriptUnit.extension(var_5_29, "first_person_system").first_person_unit

						var_5_32 = Unit.world_position(first_person_unit, Unit.node(first_person_unit, "root_point")) - 0.5 * Vector3.up()
					else
						local node = Unit.node(var_5_29, "j_spine")

						var_5_32 = Unit.world_position(var_5_29, node)
					end

					local player_effect_id = beam_effects[var_5_29].player_effect_id

					World.move_particles(world, player_effect_id, var_5_32)

					local beam_effect_id = beam_effects[var_5_29].beam_effect_id

					World.set_particles_variable(world, beam_effect_id, beam_start_variable_id, calculate_center_position + Vector3.up() * 0.5)
					World.set_particles_variable(world, beam_effect_id, beam_end_variable_id, var_5_32)

					local var_5_38 = POSITION_LOOKUP[var_5_29]
					local distance = Vector3.distance(calculate_center_position, var_5_38)
					local auto_lerp = math.auto_lerp(num, max_damage_distance, beam_material_min_intensity, beam_material_max_intensity, distance)
					local clamp = math.clamp(auto_lerp, beam_material_min_intensity, beam_material_max_intensity)

					World.set_particles_material_scalar(world, beam_effect_id, beam_material_name, "intensity", clamp)

					local num_2 = (distance / min_damage_distance)^2
					local min = math.min(num_2, 1)

					World.set_particles_material_scalar(world, beam_effect_id, beam_material_name, "softness", min)

					if unit_owner == local_player then
						if playing_sounds[var_5_29] == nil then
							playing_sounds[var_5_29] = WwiseWorld.trigger_event(wwise_world, start_damage_sound_event)
						end

						local var_5_44

						if min_damage_distance <= distance then
							var_5_44 = math.min(math.auto_lerp(min_damage_distance, max_damage_distance_2, 1, 2, distance), 2)
						else
							var_5_44 = math.auto_lerp(0, min_damage_distance, 0, 1, distance)
						end

						if not template.damage_sound_global_parameter then
							Managers.state.entity:system("audio_system"):set_global_parameter(template.damage_sound_global_parameter, var_5_44)
						end
					end
				end
			end
		else
			if not arg_5_1.center_effect_id then
				World.destroy_particles(world, arg_5_1.center_effect_id)

				arg_5_1.center_effect_id = nil
			end

			if not arg_5_1.center_sound then
				local event_id = arg_5_1.center_sound.event_id

				WwiseWorld.stop_event(wwise_world, event_id)

				arg_5_1.center_sound = nil
			end
		end

		for k, v in pairs(beam_effects) do
			if not (not HEALTH_ALIVE[k] and var_5_6 ~= 1) then
				for k_2, v_2 in pairs(v) do
					World.destroy_particles(world, v_2)
				end

				beam_effects[k] = nil

				if not playing_sounds[k] then
					WwiseWorld.trigger_event(wwise_world, stop_damage_sound_event)

					playing_sounds[k] = nil
				end
			end
		end
	end,
	client_stop_function = function (self, arg_6_1)
		-- function 6
		local world = self.world
		local wwise_world = arg_6_1.wwise_world
		local template = arg_6_1.template

		if not arg_6_1.center_effect_id then
			World.destroy_particles(world, arg_6_1.center_effect_id)

			arg_6_1.center_effect_id = nil
		end

		if not arg_6_1.center_sound then
			local event_id = arg_6_1.center_sound.event_id

			WwiseWorld.stop_event(wwise_world, event_id)

			arg_6_1.center_sound = nil
		end

		local beam_effects = arg_6_1.beam_effects
		local playing_sounds = arg_6_1.playing_sounds

		for k, v in pairs(beam_effects) do
			for k_2, v_2 in pairs(v) do
				World.destroy_particles(world, v_2)
			end

			beam_effects[k] = nil

			if not playing_sounds[k] then
				WwiseWorld.trigger_event(wwise_world, template.stop_damage_sound_event)

				playing_sounds[k] = nil
			end
		end
	end
}
