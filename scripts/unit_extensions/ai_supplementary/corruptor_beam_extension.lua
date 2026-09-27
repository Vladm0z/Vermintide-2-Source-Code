-- chunkname: @scripts/unit_extensions/ai_supplementary/corruptor_beam_extension.lua

CorruptorBeamExtension = class(CorruptorBeamExtension)

local POSITION_LOOKUP = POSITION_LOOKUP

CorruptorBeamExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.is_server = Managers.player.is_server
	self.state = "no_state"
	self.projectile_speed = BreedActions.chaos_corruptor_sorcerer.grab_attack.projectile_speed
	self.projectile_unit_name = "units/hub_elements/empty"
	self.projectile_effect_name = "fx/chr_corruptor_projectile"
	self.beam_effect_name = "fx/chr_corruptor_beam"
	self.beam_effect_name_start = "fx/chr_corruptor_in"
	self.beam_effect_name_end = "fx/chr_corruptor_out"
	self.projectile_sound = "Play_enemy_corruptor_sorcerer_throw_magic"
	self.stop_projectile_sound = "Stop_enemy_corruptor_sorcerer_throw_magic"
	self.beam_start_sound = "Play_enemy_corruptor_sorcerer_sucking_magic"
	self.stop_beam_start_sound = "Stop_enemy_corruptor_sorcerer_sucking_magic"
	self.beam_end_sound = "Play_enemy_corruptor_sorcerer_pull_magic"
	self.stop_beam_end_sound = "Stop_enemy_corruptor_sorcerer_pull_magic"
	self.aimed_at_position = nil
end

CorruptorBeamExtension.destroy = function (self)
	-- function 2
	self:remove_vfx_and_sfx()
end

CorruptorBeamExtension.on_remove_extension = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:remove_vfx_and_sfx(arg_3_1)
end

CorruptorBeamExtension.remove_vfx_and_sfx = function (self, arg_4_1)
	-- function 4
	local world = self.world
	local target_unit = self.target_unit
	local flag

	flag = arg_4_1 or self.unit

	local wwise_world = Managers.world:wwise_world(world)

	if not self.beam_start_sound_id and not WwiseWorld.is_playing(wwise_world, self.beam_start_sound_id) then
		WwiseWorld.stop_event(wwise_world, self.beam_start_sound_id)

		self.beam_start_sound_id = nil
	end

	if not self.beam_end_sound_id and not WwiseWorld.is_playing(wwise_world, self.beam_end_sound_id) then
		WwiseWorld.stop_event(wwise_world, self.beam_end_sound_id)

		self.beam_end_sound_id = nil
	end

	if not self.projectile_unit then
		World.destroy_unit(world, self.projectile_unit)

		self.projectile_unit = nil
	end

	if not self.beam_effect then
		World.destroy_particles(world, self.beam_effect)

		self.target_unit = nil
		self.beam_effect = nil
	end

	if not self.beam_effect_start then
		World.stop_spawning_particles(world, self.beam_effect_start)
		World.stop_spawning_particles(world, self.beam_effect_end)

		self.beam_effect_start = nil
		self.beam_effect_end = nil
	end

	self.state = nil
	self.projectile_position = nil
	self.aimed_at_position = nil
end

CorruptorBeamExtension.set_state = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_2 then
		print("Corruptor beam tried to set state to nil target unit")
		self:remove_vfx_and_sfx()

		return
	end

	local num = POSITION_LOOKUP[self.unit] + Vector3.up()
	local world = self.world

	if arg_5_1 ~= "projectile" or not Unit.alive(arg_5_2) then
		self.beam_effect = World.create_particles(world, self.beam_effect_name, num)
		self.beam_effect_variable_id = World.find_particles_variable(world, self.beam_effect_name, "trail_length")

		local spawn_unit = World.spawn_unit(world, self.projectile_unit_name, num, Quaternion.identity())
		local identity = Matrix4x4.identity()

		self.projectile_effect = World.create_particles(world, self.projectile_effect_name, num)
		self.state = arg_5_1
		self.target_unit = arg_5_2

		World.link_particles(world, self.projectile_effect, spawn_unit, 0, identity, "stop")

		self.projectile_unit = spawn_unit

		WwiseUtils.trigger_unit_event(world, self.projectile_sound, spawn_unit, 0)
	elseif arg_5_1 ~= "start_beam" or not Unit.alive(arg_5_2) then
		self.beam_effect_start = World.create_particles(world, self.beam_effect_name_start, num)
		self.beam_effect_end = World.create_particles(world, self.beam_effect_name_end, num)
		self.target_unit = arg_5_2

		if not self.projectile_unit then
			WwiseUtils.trigger_unit_event(world, self.stop_projectile_sound, self.projectile_unit, 0)

			local trigger_unit_event, var_5_5 = WwiseUtils.trigger_unit_event(world, self.beam_start_sound, self.unit, Unit.node(self.unit, "a_voice"))

			self.beam_start_sound_id = trigger_unit_event

			local trigger_unit_event_2, var_5_7 = WwiseUtils.trigger_unit_event(world, self.beam_end_sound, arg_5_2, Unit.node(arg_5_2, "j_neck"))

			self.beam_end_sound_id = trigger_unit_event_2
		end

		self.state = arg_5_1
	elseif arg_5_1 == "stop_beam" then
		self:remove_vfx_and_sfx()

		self.state = arg_5_1
	end
end

CorruptorBeamExtension._get_positions = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not self.aimed_at_position then
		self.aimed_at_position = Vector3Box(arg_6_3 + 1 * Vector3.normalize(arg_6_3 - arg_6_2))
	end

	local unbox = self.aimed_at_position:unbox()
	local local_position = Unit.local_position(self.projectile_unit, 0)
	local num = local_position + Vector3.normalize(unbox - local_position) * self.projectile_speed * arg_6_1

	return unbox, num
end

CorruptorBeamExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local state = self.state
	local target_unit = self.target_unit
	local projectile_unit = self.projectile_unit

	if not Unit.alive(target_unit) then
		local world = self.world
		local world_position = Unit.world_position(arg_7_1, Unit.node(arg_7_1, "a_voice"))
		local world_position_2 = Unit.world_position(target_unit, Unit.node(target_unit, "j_neck"))
		local normalize = Vector3.normalize(world_position_2 - world_position)
		local distance = Vector3.distance(world_position, world_position_2)
		local look = Quaternion.look(normalize)
		local str = "beam"
		local str_2 = "uv_dynamic_scaling"

		if state ~= "projectile" or not self.beam_effect then
			local _get_positions, var_7_12 = self:_get_positions(arg_7_3, world_position, world_position_2)
			local distance_2 = Vector3.distance(world_position, var_7_12)
			local normalize_2 = Vector3.normalize(var_7_12 - world_position)
			local look_2 = Quaternion.look(normalize_2)

			Unit.set_local_position(projectile_unit, 0, var_7_12)
			World.move_particles(world, self.beam_effect, world_position, look_2)
			World.set_particles_variable(world, self.beam_effect, self.beam_effect_variable_id, Vector3(0.3, distance_2, 0))
			World.set_particles_material_scalar(world, self.beam_effect, str, str_2, distance_2 * 1)

			if not self.is_server then
				local var_7_16 = BLACKBOARDS[arg_7_1]

				if not var_7_16.projectile_position then
					var_7_16.projectile_position:store(var_7_12)
				end

				if not var_7_16.projectile_target_position then
					var_7_16.projectile_target_position = Vector3Box(_get_positions)
				else
					var_7_16.projectile_target_position:store(_get_positions)
				end
			end
		elseif (state ~= "start_beam" or not self.beam_effect) and not self.beam_effect_start and not self.beam_effect_end then
			if not projectile_unit then
				World.destroy_unit(world, projectile_unit)

				self.projectile_unit = nil
			end

			local look_3 = Quaternion.look(-normalize)

			World.move_particles(world, self.beam_effect, world_position, look)
			World.set_particles_variable(world, self.beam_effect, self.beam_effect_variable_id, Vector3(0.3, distance, 0))
			World.set_particles_material_scalar(world, self.beam_effect, str, str_2, distance * 1)
			World.move_particles(world, self.beam_effect_start, world_position, look)
			World.move_particles(world, self.beam_effect_end, world_position_2, look_3)
		end
	end
end
