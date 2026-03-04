-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_husk_extension.lua

DamageWaveHuskExtension = class(DamageWaveHuskExtension)

local var_0_0 = POSITION_LOOKUP

DamageWaveHuskExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world
	local var_1_1 = Managers.state.entity

	arg_1_0.world = var_1_0
	arg_1_0.game = Managers.state.network:game()
	arg_1_0.unit = arg_1_2
	arg_1_0.nav_world = var_1_1:system("ai_system"):nav_world()
	arg_1_0.go_id = Managers.state.unit_storage:go_id(arg_1_2)
	arg_1_0.fx_list = {}
	arg_1_0.buff_system = var_1_1:system("buff_system")
	arg_1_0.source_unit = arg_1_3.source_unit

	local var_1_2 = arg_1_3.damage_wave_template_name
	local var_1_3 = DamageWaveTemplates.templates[var_1_2]

	arg_1_0.template = var_1_3
	arg_1_0.fx_name_filled = var_1_3.fx_name_filled
	arg_1_0.fx_name_running = var_1_3.fx_name_running
	arg_1_0.fx_name_impact = var_1_3.fx_name_impact
	arg_1_0.fx_name_arrived = var_1_3.fx_name_arrived

	if var_1_3.running_spawn_config then
		arg_1_0._running_spawn_configs = var_1_3.running_spawn_config
		arg_1_0._local_units = {}
	end

	local var_1_4 = var_1_3.fx_name_init

	if var_1_4 then
		local var_1_5 = Unit.local_rotation(arg_1_2, 0)
		local var_1_6 = World.create_particles(var_1_0, var_1_4, var_0_0[arg_1_2], var_1_5)

		World.link_particles(var_1_0, var_1_6, arg_1_2, 0, Matrix4x4.identity(), var_1_3.particle_arrived_stop_mode)

		arg_1_0.init_effect_id = var_1_6
	end

	arg_1_0.particle_arrived_stop_mode = var_1_3.particle_arrived_stop_mode
	arg_1_0.launch_wave_sound = var_1_3.launch_wave_sound
	arg_1_0.impact_wave_sound = var_1_3.impact_wave_sound
	arg_1_0.running_wave_sound = var_1_3.running_wave_sound
	arg_1_0.stop_running_wave_sound = var_1_3.stop_running_wave_sound
	arg_1_0.blob_separation_dist = var_1_3.blob_separation_dist
	arg_1_0.fx_separation_dist = var_1_3.fx_separation_dist
	arg_1_0.max_height = var_1_3.max_height
	arg_1_0.overflow_dist = var_1_3.overflow_dist
	arg_1_0._init_position = Vector3Box(var_0_0[arg_1_2])
	arg_1_0._init_wave_direction = true
	arg_1_0._update_func = var_1_3.update_func
end

DamageWaveHuskExtension.destroy = function (arg_2_0)
	local var_2_0 = arg_2_0.world
	local var_2_1 = arg_2_0.fx_list
	local var_2_2 = #var_2_1

	for iter_2_0 = 1, var_2_2 do
		local var_2_3 = var_2_1[iter_2_0].id

		World.stop_spawning_particles(var_2_0, var_2_3)
	end

	local var_2_4 = arg_2_0._local_units

	if var_2_4 then
		for iter_2_1 = 1, #var_2_4 do
			World.destroy_unit(var_2_0, var_2_4[iter_2_1])

			var_2_4[iter_2_1] = nil
		end
	end
end

DamageWaveHuskExtension.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = math.min(arg_3_3 * 10, 1)
	local var_3_1 = var_0_0[arg_3_1]
	local var_3_2 = GameSession.game_object_field(arg_3_0.game, arg_3_0.go_id, "position")
	local var_3_3 = Vector3.lerp(var_3_1, var_3_2, var_3_0)

	Unit.set_local_position(arg_3_1, 0, var_3_3)

	local var_3_4 = GameSession.game_object_field(arg_3_0.game, arg_3_0.go_id, "rotation")

	Unit.set_local_rotation(arg_3_1, 0, var_3_4)

	if arg_3_0.state == "running" then
		if arg_3_0._init_wave_direction and Vector3.distance_squared(var_3_2, arg_3_0._init_position:unbox()) >= 0.1 then
			arg_3_0._init_wave_direction = nil
			arg_3_0._init_position = nil
			arg_3_0.wave_direction = Vector3Box(Vector3.normalize(var_3_2 - var_3_1))
		end

		if arg_3_0._update_func then
			arg_3_0._update_func(arg_3_0, arg_3_1, var_3_3, arg_3_5, arg_3_3)
		end
	end
end

DamageWaveHuskExtension.add_damage_wave_fx = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0
	local var_4_1

	if arg_4_3 == 0 then
		var_4_0 = arg_4_0.fx_name_filled
	else
		var_4_1 = arg_4_0._running_spawn_configs[arg_4_3]
		var_4_0 = var_4_1.names[arg_4_4]
	end

	local var_4_2

	if arg_4_3 == 0 or var_4_1.spawn_type == "effect" then
		var_4_2 = World.create_particles(arg_4_0.world, var_4_0, arg_4_1, arg_4_2)

		local var_4_3 = arg_4_0.fx_list

		var_4_3[#var_4_3 + 1] = {
			id = var_4_2,
			position = Vector3Box(arg_4_1),
			rotation = QuaternionBox(arg_4_2),
			index = arg_4_3
		}
	elseif var_4_1.spawn_type == "unit" then
		var_4_2 = World.spawn_unit(arg_4_0.world, var_4_0, arg_4_1, arg_4_2)
		arg_4_0._local_units[#arg_4_0._local_units + 1] = var_4_2
	end

	if arg_4_3 > 0 and var_4_1.on_spawn then
		var_4_1.on_spawn(arg_4_0, var_4_1, var_4_0, var_4_2, arg_4_0.world)
	end
end

DamageWaveHuskExtension.set_running_wave = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.world
	local var_5_1 = var_0_0[arg_5_1]
	local var_5_2 = Unit.local_rotation(arg_5_1, 0)
	local var_5_3 = World.create_particles(var_5_0, arg_5_0.fx_name_running, var_5_1, var_5_2)

	World.link_particles(var_5_0, var_5_3, arg_5_1, 0, Matrix4x4.identity(), arg_5_0.particle_arrived_stop_mode)

	arg_5_0.running_wave_fx_id = var_5_3

	local var_5_4 = arg_5_0.launch_wave_sound

	if var_5_4 then
		WwiseUtils.trigger_position_event(var_5_0, var_5_4, var_5_1)
	end

	local var_5_5
	local var_5_6
	local var_5_7 = arg_5_0.running_wave_sound

	if var_5_7 then
		local var_5_8, var_5_9 = WwiseUtils.trigger_unit_event(var_5_0, var_5_7, arg_5_1)

		arg_5_0.running_source_id = var_5_9
	end

	arg_5_0.state = "running"
end

DamageWaveHuskExtension.hide_wave = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.world

	Unit.set_unit_visibility(arg_6_1, false)

	if arg_6_0.init_effect_id then
		World.stop_spawning_particles(var_6_0, arg_6_0.init_effect_id)
	end

	arg_6_0.state = "hide"
end

DamageWaveHuskExtension.set_wave_arrived = function (arg_7_0, arg_7_1)
	arg_7_0:hide_wave(arg_7_1)

	local var_7_0 = arg_7_0.world
	local var_7_1 = Managers.world:wwise_world(var_7_0)
	local var_7_2 = arg_7_0.running_source_id
	local var_7_3 = arg_7_0.stop_running_wave_sound

	if WwiseWorld.has_source(var_7_1, var_7_2) and var_7_3 then
		WwiseWorld.trigger_event(var_7_1, var_7_3, var_7_2)
	end

	arg_7_0.running_source_id = nil

	local var_7_4 = arg_7_0.impact_wave_sound

	if var_7_4 then
		WwiseUtils.trigger_unit_event(var_7_0, var_7_4, arg_7_1)
	end

	if arg_7_0.running_wave_fx_id then
		World.stop_spawning_particles(var_7_0, arg_7_0.running_wave_fx_id)
	end

	if arg_7_0.fx_name_arrived then
		local var_7_5 = Unit.local_rotation(arg_7_1, 0)

		World.create_particles(var_7_0, arg_7_0.fx_name_arrived, var_0_0[arg_7_1], var_7_5)
	end

	arg_7_0.state = "arrived"
end

DamageWaveHuskExtension.on_wavefront_impact = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.world

	if arg_8_0.fx_name_impact then
		local var_8_1 = Quaternion.look(Vector3.forward(), Vector3.up())

		World.create_particles(var_8_0, arg_8_0.fx_name_impact, var_0_0[arg_8_1], var_8_1)
	end

	local var_8_2 = arg_8_0.impact_wave_sound

	if var_8_2 then
		WwiseUtils.trigger_unit_event(var_8_0, var_8_2, arg_8_1)
	end

	arg_8_0.state = "impact"
end

local var_0_1 = 20
local var_0_2 = var_0_1 / 2
local var_0_3 = 1

DamageWaveHuskExtension.debug_render_wave = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = 0

	for iter_9_0 = -var_0_2, var_0_2 - 1 do
		local var_9_1 = math.sin(-math.pi + var_9_0 / var_0_1 * math.pi) * arg_9_0.max_height
		local var_9_2 = arg_9_3 + arg_9_4 * (iter_9_0 / var_0_1) * var_0_3 - var_9_1 * Vector3(0, 0, 1) - Vector3(0, 0, arg_9_5 * 2)

		QuickDrawer:circle(var_9_2, arg_9_0.max_height, arg_9_4, Colors.get("lime_green"))

		var_9_0 = var_9_0 + 1
	end
end
