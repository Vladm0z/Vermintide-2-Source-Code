-- chunkname: @scripts/unit_extensions/ai_supplementary/corruptor_beam_extension.lua

CorruptorBeamExtension = class(CorruptorBeamExtension)

local var_0_0 = POSITION_LOOKUP

function CorruptorBeamExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.state = "no_state"
	arg_1_0.projectile_speed = BreedActions.chaos_corruptor_sorcerer.grab_attack.projectile_speed
	arg_1_0.projectile_unit_name = "units/hub_elements/empty"
	arg_1_0.projectile_effect_name = "fx/chr_corruptor_projectile"
	arg_1_0.beam_effect_name = "fx/chr_corruptor_beam"
	arg_1_0.beam_effect_name_start = "fx/chr_corruptor_in"
	arg_1_0.beam_effect_name_end = "fx/chr_corruptor_out"
	arg_1_0.projectile_sound = "Play_enemy_corruptor_sorcerer_throw_magic"
	arg_1_0.stop_projectile_sound = "Stop_enemy_corruptor_sorcerer_throw_magic"
	arg_1_0.beam_start_sound = "Play_enemy_corruptor_sorcerer_sucking_magic"
	arg_1_0.stop_beam_start_sound = "Stop_enemy_corruptor_sorcerer_sucking_magic"
	arg_1_0.beam_end_sound = "Play_enemy_corruptor_sorcerer_pull_magic"
	arg_1_0.stop_beam_end_sound = "Stop_enemy_corruptor_sorcerer_pull_magic"
	arg_1_0.aimed_at_position = nil
end

function CorruptorBeamExtension.destroy(arg_2_0)
	arg_2_0:remove_vfx_and_sfx()
end

function CorruptorBeamExtension.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:remove_vfx_and_sfx(arg_3_1)
end

function CorruptorBeamExtension.remove_vfx_and_sfx(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.world
	local var_4_1 = arg_4_0.target_unit
	local var_4_2

	var_4_2 = arg_4_1 or arg_4_0.unit

	local var_4_3 = Managers.world:wwise_world(var_4_0)

	if arg_4_0.beam_start_sound_id and WwiseWorld.is_playing(var_4_3, arg_4_0.beam_start_sound_id) then
		WwiseWorld.stop_event(var_4_3, arg_4_0.beam_start_sound_id)

		arg_4_0.beam_start_sound_id = nil
	end

	if arg_4_0.beam_end_sound_id and WwiseWorld.is_playing(var_4_3, arg_4_0.beam_end_sound_id) then
		WwiseWorld.stop_event(var_4_3, arg_4_0.beam_end_sound_id)

		arg_4_0.beam_end_sound_id = nil
	end

	if arg_4_0.projectile_unit then
		World.destroy_unit(var_4_0, arg_4_0.projectile_unit)

		arg_4_0.projectile_unit = nil
	end

	if arg_4_0.beam_effect then
		World.destroy_particles(var_4_0, arg_4_0.beam_effect)

		arg_4_0.target_unit = nil
		arg_4_0.beam_effect = nil
	end

	if arg_4_0.beam_effect_start then
		World.stop_spawning_particles(var_4_0, arg_4_0.beam_effect_start)
		World.stop_spawning_particles(var_4_0, arg_4_0.beam_effect_end)

		arg_4_0.beam_effect_start = nil
		arg_4_0.beam_effect_end = nil
	end

	arg_4_0.state = nil
	arg_4_0.projectile_position = nil
	arg_4_0.aimed_at_position = nil
end

function CorruptorBeamExtension.set_state(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_2 then
		print("Corruptor beam tried to set state to nil target unit")
		arg_5_0:remove_vfx_and_sfx()

		return
	end

	local var_5_0 = var_0_0[arg_5_0.unit] + Vector3.up()
	local var_5_1 = arg_5_0.world

	if arg_5_1 == "projectile" and Unit.alive(arg_5_2) then
		arg_5_0.beam_effect = World.create_particles(var_5_1, arg_5_0.beam_effect_name, var_5_0)
		arg_5_0.beam_effect_variable_id = World.find_particles_variable(var_5_1, arg_5_0.beam_effect_name, "trail_length")

		local var_5_2 = World.spawn_unit(var_5_1, arg_5_0.projectile_unit_name, var_5_0, Quaternion.identity())
		local var_5_3 = Matrix4x4.identity()

		arg_5_0.projectile_effect = World.create_particles(var_5_1, arg_5_0.projectile_effect_name, var_5_0)
		arg_5_0.state = arg_5_1
		arg_5_0.target_unit = arg_5_2

		World.link_particles(var_5_1, arg_5_0.projectile_effect, var_5_2, 0, var_5_3, "stop")

		arg_5_0.projectile_unit = var_5_2

		WwiseUtils.trigger_unit_event(var_5_1, arg_5_0.projectile_sound, var_5_2, 0)
	elseif arg_5_1 == "start_beam" and Unit.alive(arg_5_2) then
		arg_5_0.beam_effect_start = World.create_particles(var_5_1, arg_5_0.beam_effect_name_start, var_5_0)
		arg_5_0.beam_effect_end = World.create_particles(var_5_1, arg_5_0.beam_effect_name_end, var_5_0)
		arg_5_0.target_unit = arg_5_2

		if arg_5_0.projectile_unit then
			WwiseUtils.trigger_unit_event(var_5_1, arg_5_0.stop_projectile_sound, arg_5_0.projectile_unit, 0)

			local var_5_4, var_5_5 = WwiseUtils.trigger_unit_event(var_5_1, arg_5_0.beam_start_sound, arg_5_0.unit, Unit.node(arg_5_0.unit, "a_voice"))

			arg_5_0.beam_start_sound_id = var_5_4

			local var_5_6, var_5_7 = WwiseUtils.trigger_unit_event(var_5_1, arg_5_0.beam_end_sound, arg_5_2, Unit.node(arg_5_2, "j_neck"))

			arg_5_0.beam_end_sound_id = var_5_6
		end

		arg_5_0.state = arg_5_1
	elseif arg_5_1 == "stop_beam" then
		arg_5_0:remove_vfx_and_sfx()

		arg_5_0.state = arg_5_1
	end
end

function CorruptorBeamExtension._get_positions(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if not arg_6_0.aimed_at_position then
		arg_6_0.aimed_at_position = Vector3Box(arg_6_3 + 1 * Vector3.normalize(arg_6_3 - arg_6_2))
	end

	local var_6_0 = arg_6_0.aimed_at_position:unbox()
	local var_6_1 = Unit.local_position(arg_6_0.projectile_unit, 0)
	local var_6_2 = var_6_1 + Vector3.normalize(var_6_0 - var_6_1) * arg_6_0.projectile_speed * arg_6_1

	return var_6_0, var_6_2
end

function CorruptorBeamExtension.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_0.state
	local var_7_1 = arg_7_0.target_unit
	local var_7_2 = arg_7_0.projectile_unit

	if Unit.alive(var_7_1) then
		local var_7_3 = arg_7_0.world
		local var_7_4 = Unit.world_position(arg_7_1, Unit.node(arg_7_1, "a_voice"))
		local var_7_5 = Unit.world_position(var_7_1, Unit.node(var_7_1, "j_neck"))
		local var_7_6 = Vector3.normalize(var_7_5 - var_7_4)
		local var_7_7 = Vector3.distance(var_7_4, var_7_5)
		local var_7_8 = Quaternion.look(var_7_6)
		local var_7_9 = "beam"
		local var_7_10 = "uv_dynamic_scaling"

		if var_7_0 == "projectile" and arg_7_0.beam_effect then
			local var_7_11, var_7_12 = arg_7_0:_get_positions(arg_7_3, var_7_4, var_7_5)
			local var_7_13 = Vector3.distance(var_7_4, var_7_12)
			local var_7_14 = Vector3.normalize(var_7_12 - var_7_4)
			local var_7_15 = Quaternion.look(var_7_14)

			Unit.set_local_position(var_7_2, 0, var_7_12)
			World.move_particles(var_7_3, arg_7_0.beam_effect, var_7_4, var_7_15)
			World.set_particles_variable(var_7_3, arg_7_0.beam_effect, arg_7_0.beam_effect_variable_id, Vector3(0.3, var_7_13, 0))
			World.set_particles_material_scalar(var_7_3, arg_7_0.beam_effect, var_7_9, var_7_10, var_7_13 * 1)

			if arg_7_0.is_server then
				local var_7_16 = BLACKBOARDS[arg_7_1]

				if var_7_16.projectile_position then
					var_7_16.projectile_position:store(var_7_12)
				end

				if not var_7_16.projectile_target_position then
					var_7_16.projectile_target_position = Vector3Box(var_7_11)
				else
					var_7_16.projectile_target_position:store(var_7_11)
				end
			end
		elseif var_7_0 == "start_beam" and arg_7_0.beam_effect and arg_7_0.beam_effect_start and arg_7_0.beam_effect_end then
			if var_7_2 then
				World.destroy_unit(var_7_3, var_7_2)

				arg_7_0.projectile_unit = nil
			end

			local var_7_17 = Quaternion.look(-var_7_6)

			World.move_particles(var_7_3, arg_7_0.beam_effect, var_7_4, var_7_8)
			World.set_particles_variable(var_7_3, arg_7_0.beam_effect, arg_7_0.beam_effect_variable_id, Vector3(0.3, var_7_7, 0))
			World.set_particles_material_scalar(var_7_3, arg_7_0.beam_effect, var_7_9, var_7_10, var_7_7 * 1)
			World.move_particles(var_7_3, arg_7_0.beam_effect_start, var_7_4, var_7_8)
			World.move_particles(var_7_3, arg_7_0.beam_effect_end, var_7_5, var_7_17)
		end
	end
end
