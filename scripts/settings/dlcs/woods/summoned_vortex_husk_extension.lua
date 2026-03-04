-- chunkname: @scripts/settings/dlcs/woods/summoned_vortex_husk_extension.lua

SummonedVortexHuskExtension = class(SummonedVortexHuskExtension)

function SummonedVortexHuskExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world
	local var_1_1 = Managers.state.network:game()

	arg_1_0.world = var_1_0
	arg_1_0.game = var_1_1
	arg_1_0.unit = arg_1_2

	local var_1_2 = arg_1_3.vortex_template_name
	local var_1_3 = VortexTemplates[var_1_2]

	arg_1_0.vortex_template_name = var_1_2
	arg_1_0.vortex_template = var_1_3

	local var_1_4 = var_1_3.inner_fx_name
	local var_1_5 = POSITION_LOOKUP[arg_1_2]
	local var_1_6 = World.create_particles(var_1_0, var_1_4, var_1_5)
	local var_1_7 = Unit.local_rotation(arg_1_2, 0)
	local var_1_8 = Matrix4x4.from_quaternion(var_1_7)
	local var_1_9 = var_1_3.full_inner_radius / var_1_3.full_fx_radius
	local var_1_10 = var_1_3.inner_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(var_1_8, Vector3(var_1_9, var_1_9, var_1_10))
	World.link_particles(var_1_0, var_1_6, arg_1_2, 0, var_1_8, "stop")

	arg_1_0._inner_fx_id = var_1_6

	local var_1_11 = var_1_3.outer_fx_name
	local var_1_12 = World.create_particles(var_1_0, var_1_11, var_1_5)
	local var_1_13 = Matrix4x4.from_quaternion(var_1_7)
	local var_1_14 = var_1_3.full_outer_radius / var_1_3.full_fx_radius
	local var_1_15 = var_1_3.outer_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(var_1_13, Vector3(var_1_14, var_1_14, var_1_15))
	World.link_particles(var_1_0, var_1_12, arg_1_2, 0, var_1_13, "stop")

	arg_1_0._outer_fx_id = var_1_12

	local var_1_16 = arg_1_3.inner_decal_unit

	if var_1_16 then
		World.link_unit(var_1_0, var_1_16, arg_1_2, 0)
		Unit.set_local_scale(var_1_16, 0, Vector3(var_1_9, var_1_9, 1))
		Unit.flow_event(var_1_16, "vortex_spawned")

		arg_1_0._inner_decal_unit = var_1_16
	end

	local var_1_17 = arg_1_3.outer_decal_unit

	if var_1_17 then
		World.link_unit(var_1_0, var_1_17, arg_1_2, 0)
		Unit.set_local_scale(var_1_17, 0, Vector3(var_1_14, var_1_14, 1))
		Unit.flow_event(var_1_17, "vortex_spawned")

		arg_1_0._outer_decal_unit = var_1_17
	end

	arg_1_0._owner_unit = arg_1_3.owner_unit or arg_1_2

	local var_1_18 = Managers.state.unit_storage:go_id(arg_1_2)

	arg_1_0.current_height_lerp = GameSession.game_object_field(var_1_1, var_1_18, "height_percentage")
end

function SummonedVortexHuskExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.vortex_template.start_sound_event_name or "Play_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(arg_2_1, var_2_0, arg_2_2)
end

function SummonedVortexHuskExtension.destroy(arg_3_0)
	local var_3_0 = arg_3_0.world
	local var_3_1 = arg_3_0.unit
	local var_3_2 = arg_3_0.vortex_template.stop_sound_event_name or "Stop_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(var_3_0, var_3_2, var_3_1)

	local var_3_3 = arg_3_0._inner_decal_unit

	if Unit.alive(var_3_3) then
		Unit.flow_event(var_3_3, "vortex_despawned")
	end

	local var_3_4 = arg_3_0._outer_decal_unit

	if Unit.alive(var_3_4) then
		Unit.flow_event(var_3_4, "vortex_despawned")
	end
end

local var_0_0 = 2

function SummonedVortexHuskExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.game
	local var_4_1 = Managers.state.unit_storage:go_id(arg_4_1)
	local var_4_2 = GameSession.game_object_field(var_4_0, var_4_1, "fx_radius_percentage")
	local var_4_3 = GameSession.game_object_field(var_4_0, var_4_1, "height_percentage")
	local var_4_4 = arg_4_0.current_height_lerp
	local var_4_5 = math.lerp(var_4_4, var_4_3, math.min(arg_4_3 * var_0_0, 1))

	arg_4_0.current_height_lerp = var_4_5

	local var_4_6 = arg_4_0.vortex_template
	local var_4_7 = var_4_2 * var_4_6.full_fx_radius
	local var_4_8 = var_4_5 * var_4_6.max_height

	Unit.set_local_scale(arg_4_1, 0, Vector3(var_4_7, var_4_7, var_4_8))
end

local var_0_1 = {}
local var_0_2 = 8
local var_0_3 = 10

function SummonedVortexHuskExtension.debug_render_vortex(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	arg_5_4 = arg_5_4 + math.sin(arg_5_1 * 1.7) * 0.4

	local var_5_0 = 2 * math.pi / 6
	local var_5_1 = math.floor(155 / var_0_2)
	local var_5_2 = arg_5_8 / var_0_2

	for iter_5_0 = 1, var_0_3 do
		local var_5_3 = iter_5_0 * 2 * math.pi / var_0_3

		for iter_5_1 = 1, var_0_2 do
			local var_5_4 = arg_5_4 + 0.5 * (iter_5_1 * iter_5_1) / var_0_2
			local var_5_5 = arg_5_1 * arg_5_7 + iter_5_1 * var_5_0 + var_5_3

			var_0_1[iter_5_1] = Vector3(math.sin(var_5_5) * var_5_4, math.cos(var_5_5) * var_5_4, (iter_5_1 - 1) * var_5_2)
		end

		local var_5_6 = arg_5_4 + math.sin(arg_5_1) * 0.2
		local var_5_7 = arg_5_1 * arg_5_7 + var_5_3 + 0 * var_5_0
		local var_5_8 = Vector3(math.sin(var_5_7) * var_5_6, math.cos(var_5_7) * var_5_6, 0)

		QuickDrawer:sphere(arg_5_3 + var_5_8, (math.sin(var_5_7 * 3) + 1) / 3, Color(155, 255, 155))

		for iter_5_2 = 1, var_0_2 do
			local var_5_9 = var_0_1[iter_5_2]
			local var_5_10 = Color(155 - var_5_1 * iter_5_2, 255 - var_5_1 * iter_5_2, 155 - var_5_1 * iter_5_2)

			QuickDrawer:line(arg_5_3 + var_5_8, arg_5_3 + var_5_9, var_5_10)

			var_5_8 = var_5_9
		end
	end

	QuickDrawer:circle(arg_5_3, arg_5_5, Vector3.up(), Colors.get("pink"))
	QuickDrawer:circle(arg_5_3, arg_5_6, Vector3.up(), Colors.get("lime_green"))
end
