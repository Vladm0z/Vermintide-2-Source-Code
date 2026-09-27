-- chunkname: @scripts/unit_extensions/ai_supplementary/vortex_husk_extension.lua

VortexHuskExtension = class(VortexHuskExtension)

VortexHuskExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world
	local game = Managers.state.network:game()

	self.world = world
	self.game = game
	self.unit = arg_1_2

	local vortex_template_name = arg_1_3.vortex_template_name
	local var_1_3 = VortexTemplates[vortex_template_name]

	self.vortex_template_name = vortex_template_name
	self.vortex_template = var_1_3

	local inner_fx_name = var_1_3.inner_fx_name
	local var_1_5 = POSITION_LOOKUP[arg_1_2]
	local create_particles = World.create_particles(world, inner_fx_name, var_1_5)
	local local_rotation = Unit.local_rotation(arg_1_2, 0)
	local from_quaternion = Matrix4x4.from_quaternion(local_rotation)
	local num = var_1_3.full_inner_radius / var_1_3.full_fx_radius
	local inner_fx_z_scale_multiplier = var_1_3.inner_fx_z_scale_multiplier

	inner_fx_z_scale_multiplier = inner_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(from_quaternion, Vector3(num, num, inner_fx_z_scale_multiplier))
	World.link_particles(world, create_particles, arg_1_2, 0, from_quaternion, "stop")

	self._inner_fx_id = create_particles

	local outer_fx_name = var_1_3.outer_fx_name
	local create_particles_2 = World.create_particles(world, outer_fx_name, var_1_5)
	local from_quaternion_2 = Matrix4x4.from_quaternion(local_rotation)
	local num_2 = var_1_3.full_outer_radius / var_1_3.full_fx_radius
	local outer_fx_z_scale_multiplier = var_1_3.outer_fx_z_scale_multiplier

	outer_fx_z_scale_multiplier = outer_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(from_quaternion_2, Vector3(num_2, num_2, outer_fx_z_scale_multiplier))
	World.link_particles(world, create_particles_2, arg_1_2, 0, from_quaternion_2, "stop")

	self._outer_fx_id = create_particles_2

	local inner_decal_unit = arg_1_3.inner_decal_unit

	if not inner_decal_unit then
		World.link_unit(world, inner_decal_unit, arg_1_2, 0)
		Unit.set_local_scale(inner_decal_unit, 0, Vector3(num, num, 1))
		Unit.flow_event(inner_decal_unit, "vortex_spawned")

		self._inner_decal_unit = inner_decal_unit
	end

	local outer_decal_unit = arg_1_3.outer_decal_unit

	if not outer_decal_unit then
		World.link_unit(world, outer_decal_unit, arg_1_2, 0)
		Unit.set_local_scale(outer_decal_unit, 0, Vector3(num_2, num_2, 1))
		Unit.flow_event(outer_decal_unit, "vortex_spawned")

		self._outer_decal_unit = outer_decal_unit
	end

	local owner_unit = arg_1_3.owner_unit

	owner_unit = owner_unit or arg_1_2
	self._owner_unit = owner_unit

	local go_id = Managers.state.unit_storage:go_id(arg_1_2)

	self.current_height_lerp = GameSession.game_object_field(game, go_id, "height_percentage")
end

VortexHuskExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	local start_sound_event_name = self.vortex_template.start_sound_event_name

	start_sound_event_name = start_sound_event_name or "Play_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(arg_2_1, start_sound_event_name, arg_2_2)
end

VortexHuskExtension.destroy = function (self)
	-- function 3
	local world = self.world
	local unit = self.unit
	local stop_sound_event_name = self.vortex_template.stop_sound_event_name

	stop_sound_event_name = stop_sound_event_name or "Stop_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(world, stop_sound_event_name, unit)

	local _inner_decal_unit = self._inner_decal_unit

	if not Unit.alive(_inner_decal_unit) then
		Unit.flow_event(_inner_decal_unit, "vortex_despawned")
	end

	local _outer_decal_unit = self._outer_decal_unit

	if not Unit.alive(_outer_decal_unit) then
		Unit.flow_event(_outer_decal_unit, "vortex_despawned")
	end
end

local num = 2

VortexHuskExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local game = self.game
	local go_id = Managers.state.unit_storage:go_id(arg_4_1)
	local game_object_field = GameSession.game_object_field(game, go_id, "fx_radius_percentage")
	local game_object_field_2 = GameSession.game_object_field(game, go_id, "height_percentage")
	local current_height_lerp = self.current_height_lerp
	local lerp = math.lerp(current_height_lerp, game_object_field_2, math.min(arg_4_3 * num, 1))

	self.current_height_lerp = lerp

	local vortex_template = self.vortex_template
	local num_2 = game_object_field * vortex_template.full_fx_radius
	local num_3 = lerp * vortex_template.max_height

	Unit.set_local_scale(arg_4_1, 0, Vector3(num_2, num_2, num_3))
end

local tbl = {}
local num_2 = 8
local num_3 = 10

VortexHuskExtension.debug_render_vortex = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	-- function 5
	arg_5_4 = arg_5_4 + math.sin(arg_5_1 * 1.7) * 0.4

	local num = 2 * math.pi / 6
	local floor = math.floor(155 / num_2)
	local num_4 = arg_5_8 / num_2

	for i = 1, num_3 do
		local num_5 = i * 2 * math.pi / num_3

		for j = 1, num_2 do
			local num_6 = arg_5_4 + 0.5 * (j * j) / num_2
			local num_7 = arg_5_1 * arg_5_7 + j * num + num_5

			tbl[j] = Vector3(math.sin(num_7) * num_6, math.cos(num_7) * num_6, (j - 1) * num_4)
		end

		local num_8 = arg_5_4 + math.sin(arg_5_1) * 0.2
		local num_9 = arg_5_1 * arg_5_7 + num_5 + 0 * num
		local var_5_8 = Vector3(math.sin(num_9) * num_8, math.cos(num_9) * num_8, 0)

		QuickDrawer:sphere(arg_5_3 + var_5_8, (math.sin(num_9 * 3) + 1) / 3, Color(155, 255, 155))

		for k = 1, num_2 do
			local var_5_9 = tbl[k]
			local var_5_10 = Color(155 - floor * k, 255 - floor * k, 155 - floor * k)

			QuickDrawer:line(arg_5_3 + var_5_8, arg_5_3 + var_5_9, var_5_10)

			var_5_8 = var_5_9
		end
	end

	QuickDrawer:circle(arg_5_3, arg_5_5, Vector3.up(), Colors.get("pink"))
	QuickDrawer:circle(arg_5_3, arg_5_6, Vector3.up(), Colors.get("lime_green"))
end
