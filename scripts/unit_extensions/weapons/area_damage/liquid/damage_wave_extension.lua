-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_extension.lua

local var_0_0 = require("scripts/utils/stagger_types")

DamageWaveExtension = class(DamageWaveExtension)

local var_0_1 = Unit.alive
local var_0_2 = POSITION_LOOKUP
local var_0_3 = {
	math.huge,
	math.huge,
	math.huge,
	math.huge,
	math.huge,
	math.huge
}
local var_0_4 = {}

DamageWaveExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world
	local var_1_1 = Managers.state.entity
	local var_1_2 = var_1_1:system("ai_system")

	arg_1_0.world = var_1_0
	arg_1_0.game = Managers.state.network:game()
	arg_1_0.unit = arg_1_2
	arg_1_0.source_unit = arg_1_3.source_unit
	arg_1_0._buff_params = {
		attacker_unit = arg_1_2,
		source_attacker_unit = arg_1_3.source_unit
	}
	arg_1_0._source_side = Managers.state.side.side_by_unit[arg_1_0.source_unit]
	arg_1_0.displaced_units = {}
	arg_1_0.nav_world = var_1_2:nav_world()
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.network_transmit = arg_1_0.network_manager.network_transmit
	arg_1_0.ai_system = var_1_2
	arg_1_0.ai_blob_index = 1
	arg_1_0.blobs = {}
	arg_1_0.rim_nodes = {}
	arg_1_0.fx_list = {}
	arg_1_0.ai_units_inside = {}
	arg_1_0.player_units_inside = arg_1_3.player_units_inside or {}
	arg_1_0.ai_hit_by_wavefront = arg_1_3.ai_hit_by_wavefront or {}
	arg_1_0.buff_system = var_1_1:system("buff_system")

	local var_1_3 = arg_1_3.damage_wave_template_name
	local var_1_4 = DamageWaveTemplates.templates[var_1_3]

	if var_1_4.is_transient then
		arg_1_0.is_transient = true
		arg_1_0.transient_name_override = var_1_4.transient_name_override
	end

	arg_1_0.template = var_1_4
	arg_1_0.damage_wave_template_name = var_1_3
	arg_1_0.immune_breeds = var_1_4.immune_breeds
	arg_1_0.buff_template_name = var_1_4.buff_template_name
	arg_1_0.buff_template_type = var_1_4.buff_template_type
	arg_1_0.leave_area_func = var_1_4.leave_area_func
	arg_1_0.add_buff_func = var_1_4.add_buff_func
	arg_1_0.buff_wave_impact_template_name = var_1_4.buff_wave_impact_name
	arg_1_0.buff_wave_impact_impact_type = var_1_4.buff_wave_impact_type
	arg_1_0.fx_name_filled = var_1_4.fx_name_filled
	arg_1_0.fx_name_running = var_1_4.fx_name_running
	arg_1_0.fx_name_impact = var_1_4.fx_name_impact
	arg_1_0.fx_name_arrived = var_1_4.fx_name_arrived

	if var_1_4.running_spawn_config then
		arg_1_0._running_spawn_configs = var_1_4.running_spawn_config
		arg_1_0._running_spawn_datas = {}

		local var_1_5 = Managers.time:time("game")

		for iter_1_0 = 1, #var_1_4.running_spawn_config do
			local var_1_6 = var_1_4.running_spawn_config[iter_1_0]

			arg_1_0._running_spawn_datas[iter_1_0] = {
				next_spawn_t = var_1_5 + (var_1_6.start_delay or 0),
				next_seed = math.random_seed()
			}
		end

		arg_1_0._local_units = {}
	end

	local var_1_7 = var_1_4.fx_name_init

	if var_1_7 then
		local var_1_8 = World.create_particles(var_1_0, var_1_7, var_0_2[arg_1_2], Unit.local_rotation(arg_1_2, 0))

		World.link_particles(var_1_0, var_1_8, arg_1_2, 0, Matrix4x4.identity(), var_1_4.particle_arrived_stop_mode)

		arg_1_0.init_effect_id = var_1_8
	end

	arg_1_0.blob_separation_dist = var_1_4.blob_separation_dist
	arg_1_0.fx_separation_dist = var_1_4.fx_separation_dist
	arg_1_0.max_height = var_1_4.max_height
	arg_1_0.overflow_dist = var_1_4.overflow_dist
	arg_1_0.launch_wave_sound = var_1_4.launch_wave_sound
	arg_1_0.running_wave_sound = var_1_4.running_wave_sound
	arg_1_0.stop_running_wave_sound = var_1_4.stop_running_wave_sound
	arg_1_0.impact_wave_sound = var_1_4.impact_wave_sound
	arg_1_0.start_speed = var_1_4.start_speed
	arg_1_0.acceleration = var_1_4.acceleration
	arg_1_0.max_speed = var_1_4.max_speed
	arg_1_0.player_query_distance = var_1_4.player_query_distance
	arg_1_0.ai_query_distance = var_1_4.ai_query_distance
	arg_1_0.travel_dist = 0
	arg_1_0.apply_buff_to_ai = var_1_4.apply_buff_to_ai
	arg_1_0.apply_buff_to_player = var_1_4.apply_buff_to_player
	arg_1_0.apply_buff_to_owner = var_1_4.apply_buff_to_owner
	arg_1_0.apply_impact_buff_to_player = var_1_4.apply_impact_buff_to_player
	arg_1_0.apply_impact_buff_to_ai = var_1_4.apply_impact_buff_to_ai
	arg_1_0.damage_friendly_ai = var_1_4.damage_friendly_ai
	arg_1_0.time_of_life = var_1_4.time_of_life
	arg_1_0.launch_animation = var_1_4.launch_animation
	arg_1_0._on_arrive_func = var_1_4.on_arrive_func
	arg_1_0._update_func = var_1_4.update_func

	local var_1_9 = var_1_4.init_func

	if var_1_9 then
		var_1_9(arg_1_0)
	end
end

DamageWaveExtension.set_update_func = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._update_func = arg_2_1

	if arg_2_2 then
		arg_2_2(arg_2_0, arg_2_3)
	end
end

DamageWaveExtension._calculate_oobb_collision = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_1 * 0.5
	local var_3_1 = arg_3_2 * 0.5
	local var_3_2 = arg_3_3 * 0.5
	local var_3_3 = Vector3(var_3_0, var_3_1, var_3_2)
	local var_3_4 = Quaternion.rotate(arg_3_7, Vector3.forward()) * (arg_3_4 + var_3_1)
	local var_3_5 = Vector3.up() * (arg_3_5 + var_3_2)

	return arg_3_6 + var_3_4 + var_3_5, arg_3_7, var_3_3
end

DamageWaveExtension.launch_wave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0.unit

	if not Unit.alive(var_4_0) then
		return
	end

	arg_4_0.optional_data = arg_4_3

	local var_4_1 = arg_4_2 or var_0_2[arg_4_1]
	local var_4_2 = arg_4_0.start_speed

	arg_4_0.target_unit = arg_4_1
	arg_4_0.target_pos = Vector3Box(var_4_1)
	arg_4_0.wave_speed = var_4_2

	local var_4_3 = var_0_2[var_4_0]
	local var_4_4 = var_4_1 - var_4_3
	local var_4_5 = Vector3.length(var_4_4)

	arg_4_0.initial_dist = var_4_5
	arg_4_0.original_pos_z = var_4_3.z

	local var_4_6 = Vector3.normalize(var_4_4)
	local var_4_7 = Quaternion.look(var_4_6)

	arg_4_0.wave_direction = Vector3Box(var_4_6)

	local var_4_8 = arg_4_0.template
	local var_4_9 = var_4_8.use_nav_cost_map_volumes

	if var_4_9 then
		local var_4_10 = var_4_8.nav_cost_map_cost_type
		local var_4_11 = arg_4_0.blob_separation_dist
		local var_4_12 = math.max(math.floor(var_4_5 / var_4_11), 1)

		arg_4_0._nav_cost_map_id = arg_4_0.ai_system:create_nav_cost_map(var_4_10, var_4_12)
	end

	arg_4_0.use_nav_cost_map_volumes = var_4_9

	if var_4_8.create_bot_aoe_threat then
		local var_4_13 = "DamageWaveExtension"
		local var_4_14 = var_4_2 > 0 and var_4_5 / var_4_2 or var_4_5
		local var_4_15 = arg_4_0.player_query_distance * 2
		local var_4_16 = var_4_5 + arg_4_0.overflow_dist
		local var_4_17 = arg_4_0.player_query_distance
		local var_4_18 = 0
		local var_4_19 = 0
		local var_4_20, var_4_21, var_4_22 = arg_4_0:_calculate_oobb_collision(var_4_15, var_4_16, var_4_17, var_4_18, var_4_19, var_4_3, var_4_7)

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_4_20, "oobb", var_4_22, var_4_21, var_4_14, var_4_13)
	end

	arg_4_0.last_dist = var_4_5
	arg_4_0.last_fx_dist = var_4_5
	arg_4_0.effect_id = World.create_particles(arg_4_0.world, arg_4_0.fx_name_running, var_4_3 + Vector3.up() * 5, var_4_7)

	World.link_particles(arg_4_0.world, arg_4_0.effect_id, arg_4_0.unit, 0, Matrix4x4.identity(), var_4_8.particle_arrived_stop_mode)

	local var_4_23 = arg_4_0.launch_wave_sound

	if var_4_23 then
		WwiseUtils.trigger_position_event(arg_4_0.world, var_4_23, var_4_3)
	end

	local var_4_24 = arg_4_0.running_wave_sound

	if var_4_24 then
		local var_4_25, var_4_26 = WwiseUtils.trigger_unit_event(arg_4_0.world, var_4_24, arg_4_0.unit)

		arg_4_0.running_source_id = var_4_26
	end

	arg_4_0.state = "running"

	local var_4_27 = arg_4_0.network_manager
	local var_4_28 = var_4_27:unit_game_object_id(var_4_0)

	if var_4_28 then
		arg_4_0.network_transmit:send_rpc_clients("rpc_damage_wave_set_state", var_4_28, NetworkLookup.damage_wave_states.running)
	end

	arg_4_0.unit_id = var_4_28

	local var_4_29 = arg_4_0.launch_animation

	if var_4_29 and Unit.has_animation_state_machine(var_4_0) then
		var_4_27:anim_event(var_4_0, var_4_29)
	end

	arg_4_0.is_launched = true
end

DamageWaveExtension.destroy = function (arg_5_0)
	local var_5_0 = arg_5_0.unit
	local var_5_1 = arg_5_0.player_units_inside
	local var_5_2 = arg_5_0.buff_system

	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		if var_0_1(iter_5_0) then
			if ScriptUnit.extension(iter_5_0, "status_system").in_liquid_unit == var_5_0 then
				StatusUtils.set_in_liquid_network(iter_5_0, false)
			end

			if arg_5_0.leave_area_func then
				arg_5_0.leave_area_func(iter_5_0)
			end
		end
	end

	local var_5_3 = arg_5_0.blobs
	local var_5_4 = #var_5_3
	local var_5_5 = arg_5_0.ai_system
	local var_5_6 = arg_5_0._nav_cost_map_id

	for iter_5_2 = 1, var_5_4 do
		local var_5_7 = var_5_3[iter_5_2][6]

		if var_5_7 then
			var_5_5:remove_nav_cost_map_volume(var_5_7, var_5_6)
		end
	end

	if arg_5_0.leave_area_func then
		for iter_5_3, iter_5_4 in pairs(arg_5_0.ai_units_inside) do
			arg_5_0.leave_area_func(iter_5_3)
		end
	end

	if var_5_6 then
		var_5_5:destroy_nav_cost_map(var_5_6)
	end

	local var_5_8 = arg_5_0.world
	local var_5_9 = arg_5_0.fx_list
	local var_5_10 = #var_5_9

	for iter_5_5 = 1, var_5_10 do
		local var_5_11 = var_5_9[iter_5_5].id

		World.stop_spawning_particles(var_5_8, var_5_11)
	end

	local var_5_12 = arg_5_0._local_units

	if var_5_12 then
		for iter_5_6 = 1, #var_5_12 do
			World.destroy_unit(var_5_8, var_5_12[iter_5_6])

			var_5_12[iter_5_6] = nil
		end
	end

	table.clear(var_0_4)
end

DamageWaveExtension.abort = function (arg_6_0)
	if not var_0_1(arg_6_0.unit) then
		return
	end

	local var_6_0 = arg_6_0.unit
	local var_6_1 = var_0_2[var_6_0]
	local var_6_2 = Quaternion.identity()

	Managers.state.unit_spawner:mark_for_deletion(var_6_0)

	if arg_6_0.impact_wave_sound then
		WwiseUtils.trigger_unit_event(arg_6_0.world, arg_6_0.impact_wave_sound, var_6_0)
	end

	if arg_6_0.fx_name_arrived then
		local var_6_3 = arg_6_0.network_manager
		local var_6_4 = NetworkLookup.effects[arg_6_0.fx_name_arrived]
		local var_6_5 = 0

		var_6_3:rpc_play_particle_effect(nil, var_6_4, NetworkConstants.invalid_game_object_id, var_6_5, var_6_1, var_6_2, false)
	end
end

DamageWaveExtension.move_wave = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_0.acceleration
	local var_7_1 = arg_7_0.wave_speed

	if var_7_1 < arg_7_0.max_speed then
		var_7_1 = var_7_1 + var_7_0 * arg_7_3
		arg_7_0.wave_speed = var_7_1
	end

	local var_7_2 = var_0_2[arg_7_1]
	local var_7_3 = Unit.local_rotation(arg_7_1, 0)
	local var_7_4 = Vector3(var_7_2.x, var_7_2.y, arg_7_0.original_pos_z)
	local var_7_5 = arg_7_0.target_pos:unbox() - var_7_4
	local var_7_6 = Vector3.length(var_7_5)
	local var_7_7 = var_7_6 < 0.001 and Vector3.zero() or Vector3.divide(var_7_5, var_7_6)
	local var_7_8 = arg_7_0.wave_direction:unbox()
	local var_7_9 = math.min(var_7_1 * arg_7_3, var_7_6)

	arg_7_0.travel_dist = arg_7_0.travel_dist + var_7_9

	local var_7_10 = var_7_4 + var_7_8 * var_7_9

	arg_7_0.original_pos_z = var_7_10.z

	local var_7_11 = arg_7_0.nav_world
	local var_7_12 = 1.5
	local var_7_13 = arg_7_0.template.ignore_obstacles and 15 or 1.5
	local var_7_14, var_7_15, var_7_16, var_7_17, var_7_18 = GwNavQueries.triangle_from_position(var_7_11, var_7_10, var_7_12, var_7_13)

	if var_7_14 then
		var_7_10 = Vector3(var_7_10.x, var_7_10.y, var_7_15)
	end

	Unit.set_local_position(arg_7_1, 0, var_7_10)

	if arg_7_0.blob_separation_dist and arg_7_0.last_dist - var_7_6 >= arg_7_0.blob_separation_dist then
		arg_7_0:insert_blob(var_7_10, arg_7_0.ai_query_distance, var_7_3, var_7_11)

		arg_7_0.last_dist = var_7_6
	end

	if arg_7_0.fx_name_filled and arg_7_0.last_fx_dist - var_7_6 >= arg_7_0.fx_separation_dist then
		local var_7_19 = Quaternion.look(var_7_8, Vector3(0, 0, 1))

		arg_7_0:insert_fx(var_7_10, var_7_19, 0)

		arg_7_0.last_fx_dist = var_7_6
	end

	local var_7_20
	local var_7_21 = arg_7_4 > 0 and var_7_6 / arg_7_4 or 0

	if arg_7_5 then
		var_7_20 = math.clamp(var_7_21, 0, 1)
	else
		var_7_20 = math.clamp(1 - var_7_21, 0, 1)
	end

	GameSession.set_game_object_field(arg_7_0.game, arg_7_0.unit_id, "height_percentage", var_7_20)
	GameSession.set_game_object_field(arg_7_0.game, arg_7_0.unit_id, "position", var_7_10)
	GameSession.set_game_object_field(arg_7_0.game, arg_7_0.unit_id, "rotation", var_7_3)

	return var_7_7, var_7_6, var_7_14 or arg_7_0.template.ignore_obstacles
end

DamageWaveExtension.on_hit_by_wave = function (arg_8_0, arg_8_1, arg_8_2)
	if var_0_4[arg_8_0] then
		return
	end

	local var_8_0 = arg_8_2.world
	local var_8_1 = Quaternion.look(Vector3.forward(), Vector3.up())

	if arg_8_2.fx_name_impact then
		World.create_particles(var_8_0, arg_8_2.fx_name_impact, var_0_2[arg_8_1], var_8_1)
	end

	local var_8_2 = arg_8_2.impact_wave_sound

	if var_8_2 then
		WwiseUtils.trigger_unit_event(var_8_0, var_8_2, arg_8_1)
	end

	if DamageUtils.is_player_unit(arg_8_0) and arg_8_2.apply_impact_buff_to_player then
		local var_8_3 = Managers.state.entity:system("buff_system")

		if not ScriptUnit.extension(arg_8_0, "buff_system"):has_buff_type(arg_8_2.buff_wave_impact_impact_type) then
			var_8_3:add_buff(arg_8_0, arg_8_2.buff_wave_impact_template_name, arg_8_1)
		end

		if arg_8_2.template.trigger_dialogue_on_impact then
			local var_8_4 = ScriptUnit.extension_input(arg_8_0, "dialogue_system")
			local var_8_5 = FrameTable.alloc_table()

			var_8_5.distance = DialogueSettings.pounced_down_broadcast_range
			var_8_5.target = arg_8_0
			var_8_5.target_name = ScriptUnit.extension(arg_8_0, "dialogue_system").context.player_profile

			var_8_4:trigger_dialogue_event("on_plague_wave_hit", var_8_5)
		end
	end

	local var_8_6 = arg_8_2.unit_id

	if var_8_6 then
		arg_8_2.network_transmit:send_rpc_clients("rpc_damage_wave_set_state", var_8_6, NetworkLookup.damage_wave_states.impact)
	end

	var_0_4[arg_8_0] = true
end

local var_0_5 = 0.5

DamageWaveExtension.wave_arrived = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.state = "lingering"
	arg_9_0.linger_time = arg_9_1 + arg_9_0.time_of_life

	Unit.set_unit_visibility(arg_9_2, false)

	local var_9_0 = arg_9_0.world
	local var_9_1 = Managers.world:wwise_world(var_9_0)
	local var_9_2 = arg_9_0.running_source_id
	local var_9_3 = arg_9_0.stop_running_wave_sound

	if WwiseWorld.has_source(var_9_1, var_9_2) and var_9_3 then
		WwiseWorld.trigger_event(var_9_1, var_9_3, var_9_2)
	end

	arg_9_0.running_source_id = nil

	local var_9_4 = arg_9_0.impact_wave_sound

	if var_9_4 then
		WwiseUtils.trigger_unit_event(var_9_0, var_9_4, arg_9_2)
	end

	World.stop_spawning_particles(var_9_0, arg_9_0.effect_id)

	local var_9_5 = var_0_2[arg_9_2]
	local var_9_6 = Quaternion.look(arg_9_0.wave_direction:unbox())

	if arg_9_0.fx_name_arrived then
		World.create_particles(var_9_0, arg_9_0.fx_name_arrived, var_9_5, var_9_6)
	end

	local var_9_7 = arg_9_0.unit_id

	if var_9_7 then
		arg_9_0.network_transmit:send_rpc_clients("rpc_damage_wave_set_state", var_9_7, NetworkLookup.damage_wave_states.arrived)
	end

	if arg_9_0.init_effect_id then
		World.stop_spawning_particles(var_9_0, arg_9_0.init_effect_id)
	end

	local var_9_8 = arg_9_0.blobs
	local var_9_9 = #var_9_8

	if var_9_9 > 0 then
		local var_9_10 = Unit.local_rotation(arg_9_2, 0)
		local var_9_11 = Quaternion.forward(var_9_10)
		local var_9_12 = var_9_8[var_9_9]
		local var_9_13 = Vector3(var_9_12[1], var_9_12[2], var_9_12[3]) + var_9_11 * (var_9_12[4] + var_0_5)
		local var_9_14, var_9_15 = GwNavQueries.triangle_from_position(arg_9_0.nav_world, var_9_13, 1.5, 1.5)

		if var_9_14 then
			local var_9_16 = arg_9_0.rim_nodes

			var_9_13.z = var_9_15
			var_9_16[#var_9_16 + 1] = Vector3Box(var_9_13)
		end
	end

	if arg_9_0._on_arrive_func then
		arg_9_0._on_arrive_func(arg_9_0, var_9_5, var_9_6)
	end
end

DamageWaveExtension.wavefront_impact = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	if not arg_10_4 then
		return
	end

	local var_10_0 = BLACKBOARDS
	local var_10_1 = arg_10_0.ai_hit_by_wavefront
	local var_10_2 = arg_10_0.immune_breeds
	local var_10_3 = arg_10_4.stagger_impact
	local var_10_4 = arg_10_4.stagger_duration
	local var_10_5 = arg_10_4.stagger_distance
	local var_10_6 = arg_10_4.stagger_distance_table
	local var_10_7 = arg_10_4.push_along_wave_direction
	local var_10_8 = arg_10_0.apply_impact_buff_to_ai
	local var_10_9 = arg_10_4.stagger_refresh_time or var_0_3
	local var_10_10 = arg_10_4.drag_along_wave and arg_10_6 * arg_10_0.wave_speed
	local var_10_11 = arg_10_4.wave_drag_multiplier
	local var_10_12 = arg_10_4.wave_drag_multiplier_table
	local var_10_13 = arg_10_4.hit_half_extends
	local var_10_14 = Matrix4x4.from_quaternion_position(Quaternion.look(arg_10_6), arg_10_2)
	local var_10_15 = arg_10_0.buff_system
	local var_10_16 = arg_10_0.buff_wave_impact_impact_type
	local var_10_17 = arg_10_0.buff_wave_impact_template_name
	local var_10_18 = arg_10_0._source_side
	local var_10_19 = var_10_18 and not arg_10_0.damage_friendly_ai and var_10_18.enemy_broadphase_categories or nil
	local var_10_20 = FrameTable.alloc_table()
	local var_10_21 = AiUtils.broadphase_query(arg_10_2, arg_10_3, var_10_20, var_10_19)

	for iter_10_0 = 1, var_10_21 do
		local var_10_22 = var_10_20[iter_10_0]
		local var_10_23 = HEALTH_ALIVE[var_10_22]
		local var_10_24 = var_10_0[var_10_22]
		local var_10_25 = var_10_24.breed.name

		if (var_10_10 or arg_10_1 >= (var_10_1[var_10_22] or 0)) and var_10_23 and not var_10_2[var_10_25] then
			local var_10_26 = POSITION_LOOKUP[var_10_22]

			if not var_10_13 or math.point_is_inside_box(var_10_26, var_10_14, var_10_13) then
				local var_10_27 = var_10_24.breed
				local var_10_28 = var_10_27.stagger_armor_category or var_10_27.primary_armor_category or var_10_27.armor_category or 1

				if arg_10_1 >= (var_10_1[var_10_22] or 0) then
					local var_10_29, var_10_30 = DamageUtils.calculate_stagger(var_10_3, var_10_4, var_10_22, arg_10_5)

					if var_10_29 > var_0_0.none then
						local var_10_31 = var_0_2[var_10_22]
						local var_10_32 = var_10_7 and arg_10_6 or Vector3.normalize(var_10_31 - arg_10_2)
						local var_10_33 = var_10_6 and var_10_6[var_10_28] or var_10_5

						AiUtils.stagger(var_10_22, var_10_24, arg_10_5, var_10_32, var_10_33, var_10_29, var_10_30, nil, arg_10_1)
					end

					var_10_1[var_10_22] = arg_10_1 + var_10_9[var_10_28] * (math.random() / 2 + 0.5)

					if var_10_8 and not ScriptUnit.extension(var_10_22, "buff_system"):has_buff_type(var_10_16) then
						var_10_15:add_buff_synced(var_10_22, var_10_17, BuffSyncType.All, arg_10_0._buff_params)
					end
				end

				if var_10_10 then
					local var_10_34 = var_10_24.locomotion_extension

					if var_10_34 then
						local var_10_35 = var_10_12 and var_10_12[var_10_28] or var_10_11

						if var_10_35 > 0 then
							var_10_34:set_animation_external_velocity(var_10_10 * var_10_35)
						end
					end
				end
			end
		end
	end
end

DamageWaveExtension.check_overlap = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	local var_11_0 = arg_11_0.player_units_inside
	local var_11_1 = var_0_2[arg_11_2]
	local var_11_2 = Geometry.closest_point_on_line(var_11_1, arg_11_4, arg_11_5)
	local var_11_3 = Vector3.flat(var_11_1 - var_11_2)
	local var_11_4 = Vector3.length_squared(var_11_3)
	local var_11_5 = arg_11_3 * arg_11_3
	local var_11_6 = var_11_0[arg_11_2]
	local var_11_7 = ScriptUnit.extension(arg_11_2, "status_system")

	if var_11_6 then
		var_11_6[arg_11_0] = true

		if var_11_5 < var_11_4 then
			if var_11_7.in_liquid_unit == arg_11_1 then
				StatusUtils.set_in_liquid_network(arg_11_2, false)
			end

			var_11_6[arg_11_0] = nil

			if table.is_empty(var_11_6) then
				var_11_0[arg_11_2] = nil

				if arg_11_0.leave_area_func then
					arg_11_0.leave_area_func(arg_11_2)
				end
			end
		end
	elseif var_11_4 < var_11_5 then
		local var_11_8 = Vector3.distance(arg_11_4, var_11_2)
		local var_11_9 = math.floor(0.5 + var_11_8 / arg_11_0.initial_dist * arg_11_7) + 1
		local var_11_10 = math.clamp(var_11_9, 1, arg_11_7)
		local var_11_11 = arg_11_0.blobs[var_11_10][3]
		local var_11_12 = arg_11_0.buff_template_name
		local var_11_13 = arg_11_0.buff_template_type
		local var_11_14 = ScriptUnit.extension(arg_11_2, "buff_system")

		if arg_11_3 > math.abs(var_11_1.z - var_11_11) then
			if var_11_7.in_liquid_unit ~= arg_11_1 then
				StatusUtils.set_in_liquid_network(arg_11_2, true, arg_11_1)
			end

			if arg_11_0.add_buff_func then
				arg_11_0.add_buff_func(arg_11_0, arg_11_2, var_11_12, arg_11_1, arg_11_0.source_unit)
			else
				arg_11_6:add_buff(arg_11_2, var_11_12, arg_11_1, false, nil, arg_11_0.source_unit)
			end

			var_11_0[arg_11_2] = {}
			var_11_0[arg_11_2][arg_11_0] = true
		end
	end
end

DamageWaveExtension.update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if not HEALTH_ALIVE[arg_12_0.source_unit] and not arg_12_0.is_launched then
		arg_12_0:abort()
	end

	if not arg_12_0.is_launched then
		return
	end

	local var_12_0 = arg_12_0.state
	local var_12_1 = var_0_2[arg_12_1]
	local var_12_2 = arg_12_0.wave_direction:unbox()

	if var_12_0 == "running" then
		if arg_12_0._update_func then
			arg_12_0._update_func(arg_12_0, arg_12_1, var_12_1, arg_12_5, arg_12_3)
		end

		local var_12_3, var_12_4, var_12_5 = arg_12_0:move_wave(arg_12_1, arg_12_5, arg_12_3, arg_12_0.initial_dist, true)

		if Vector3.dot(var_12_3, var_12_2) < 0 or var_12_4 < 0.1 or not var_12_5 then
			local var_12_6 = arg_12_0.overflow_dist

			arg_12_0.target_pos:store(var_12_1 + var_12_2 * var_12_6)

			arg_12_0.last_dist = arg_12_0.last_dist + var_12_6
			arg_12_0.last_fx_dist = arg_12_0.last_fx_dist + var_12_6
			arg_12_0.state = "arrived"
		end

		if arg_12_0._running_spawn_configs then
			arg_12_0:_update_running_spawn_datas(arg_12_5)
		end

		local var_12_7 = arg_12_0.template.player_push_data

		if var_12_7 then
			AiUtils.push_intersecting_players(arg_12_1, arg_12_0.source_unit, arg_12_0.displaced_units, var_12_7, arg_12_5, arg_12_3, arg_12_0.on_hit_by_wave, arg_12_0)
		end

		arg_12_0:wavefront_impact(arg_12_5, var_12_1, arg_12_0.ai_query_distance, arg_12_0.template.ai_push_data, arg_12_0.unit, var_12_2)
	elseif var_12_0 == "arrived" then
		local var_12_8, var_12_9 = arg_12_0:move_wave(arg_12_1, arg_12_5, arg_12_3, arg_12_0.overflow_dist)

		if Vector3.dot(var_12_8, var_12_2) < 0 or var_12_9 < 0.1 then
			arg_12_0:wave_arrived(arg_12_5, arg_12_1)
		end

		local var_12_10 = arg_12_0.template.player_push_data

		if var_12_10 then
			AiUtils.push_intersecting_players(arg_12_1, arg_12_0.source_unit, arg_12_0.displaced_units, var_12_10, arg_12_5, arg_12_3, arg_12_0.on_hit_by_wave, arg_12_0)
		end
	elseif arg_12_5 > arg_12_0.linger_time then
		Managers.state.unit_spawner:mark_for_deletion(arg_12_1)
	end

	Unit.set_local_rotation(arg_12_1, 0, Quaternion.look(arg_12_0.wave_direction:unbox()))
	arg_12_0:update_blob_overlaps()
end

DamageWaveExtension.insert_blob = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0

	if arg_13_0.use_nav_cost_map_volumes then
		local var_13_1 = arg_13_0.ai_system
		local var_13_2 = arg_13_0._nav_cost_map_id

		var_13_0 = var_13_1:add_nav_cost_map_sphere_volume(arg_13_1, arg_13_2, var_13_2)
	end

	local var_13_3 = arg_13_0.blobs
	local var_13_4 = #var_13_3 + 1

	var_13_3[var_13_4] = {
		arg_13_1[1],
		arg_13_1[2],
		arg_13_1[3],
		arg_13_2,
		{},
		var_13_0,
		var_13_4
	}

	local var_13_5 = arg_13_0.rim_nodes
	local var_13_6 = arg_13_2 + var_0_5
	local var_13_7 = Quaternion.right(arg_13_3)
	local var_13_8 = arg_13_1 + var_13_7 * var_13_6
	local var_13_9, var_13_10 = GwNavQueries.triangle_from_position(arg_13_4, var_13_8, 1.5, 1.5)

	if var_13_9 then
		var_13_8.z = var_13_10
		var_13_5[#var_13_5 + 1] = Vector3Box(var_13_8)
	end

	local var_13_11 = arg_13_1 + -var_13_7 * var_13_6
	local var_13_12, var_13_13 = GwNavQueries.triangle_from_position(arg_13_4, var_13_11, 1.5, 1.5)

	if var_13_12 then
		var_13_11.z = var_13_13
		var_13_5[#var_13_5 + 1] = Vector3Box(var_13_11)
	end

	if var_13_4 == 1 then
		local var_13_14 = arg_13_1 + -Quaternion.forward(arg_13_3) * var_13_6
		local var_13_15, var_13_16 = GwNavQueries.triangle_from_position(arg_13_4, var_13_14, 1.5, 1.5)

		if var_13_15 then
			var_13_14.z = var_13_16
			var_13_5[#var_13_5 + 1] = Vector3Box(var_13_14)
		end
	end
end

DamageWaveExtension.insert_fx = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0
	local var_14_1
	local var_14_2

	if arg_14_3 == 0 then
		var_14_2 = 0
		var_14_1 = arg_14_0.fx_name_filled
	else
		var_14_0 = arg_14_0._running_spawn_configs[arg_14_3]

		local var_14_3 = arg_14_0._running_spawn_datas[arg_14_3]
		local var_14_4 = var_14_0.names

		var_14_3.next_seed, var_14_2 = Math.next_random(var_14_3.next_seed, 1, #var_14_4)
		var_14_1 = var_14_4[var_14_2]
	end

	local var_14_5

	if arg_14_3 == 0 or var_14_0.spawn_type == "effect" then
		var_14_5 = World.create_particles(arg_14_0.world, var_14_1, arg_14_1, arg_14_2, Vector3(0.1, 0.1, 0.1))

		local var_14_6 = arg_14_0.fx_list

		var_14_6[#var_14_6 + 1] = {
			id = var_14_5,
			position = Vector3Box(arg_14_1),
			rotation = QuaternionBox(arg_14_2),
			index = arg_14_3,
			name_index = var_14_2
		}
	elseif var_14_0.spawn_type == "unit" then
		var_14_5 = World.spawn_unit(arg_14_0.world, var_14_1, arg_14_1, arg_14_2)
		arg_14_0._local_units[#arg_14_0._local_units + 1] = var_14_5
	end

	if arg_14_3 > 0 and var_14_0.on_spawn then
		var_14_0.on_spawn(arg_14_0, var_14_0, var_14_1, var_14_5, arg_14_0.world)
	end

	local var_14_7 = arg_14_0.unit_id

	if var_14_7 then
		arg_14_0.network_transmit:send_rpc_clients("rpc_add_damage_wave_fx", var_14_7, arg_14_1, arg_14_2, arg_14_3, var_14_2)
	end
end

DamageWaveExtension.update_blob_overlaps = function (arg_15_0)
	local var_15_0 = arg_15_0.blobs
	local var_15_1 = #var_15_0

	if var_15_1 < 1 then
		return
	end

	local var_15_2 = arg_15_0.unit
	local var_15_3 = arg_15_0.source_unit
	local var_15_4 = arg_15_0.buff_system
	local var_15_5 = var_15_0[1]
	local var_15_6 = var_15_0[var_15_1]
	local var_15_7 = Vector3(var_15_5[1], var_15_5[2], var_15_5[3])
	local var_15_8 = Vector3(var_15_6[1], var_15_6[2], var_15_6[3])

	if arg_15_0.apply_buff_to_player then
		local var_15_9 = arg_15_0._source_side.ENEMY_PLAYER_AND_BOT_UNITS
		local var_15_10 = arg_15_0.player_query_distance

		for iter_15_0 = 1, #var_15_9 do
			local var_15_11 = var_15_9[iter_15_0]
			local var_15_12 = ScriptUnit.has_extension(var_15_11, "ghost_mode_system")

			if not var_15_12 or not var_15_12:is_in_ghost_mode() then
				arg_15_0:check_overlap(var_15_2, var_15_11, var_15_10, var_15_7, var_15_8, var_15_4, var_15_1)
			end
		end
	end

	if arg_15_0.apply_buff_to_owner and ALIVE[arg_15_0.source_unit] then
		local var_15_13 = arg_15_0.player_query_distance

		arg_15_0:check_overlap(var_15_2, arg_15_0.source_unit, var_15_13, var_15_7, var_15_8, var_15_4, var_15_1)
	end

	if not arg_15_0.apply_buff_to_ai then
		return
	end

	local var_15_14 = 1
	local var_15_15 = arg_15_0.ai_blob_index
	local var_15_16 = math.min(var_15_14, var_15_1)
	local var_15_17 = arg_15_0.buff_template_name
	local var_15_18 = arg_15_0.immune_breeds
	local var_15_19 = arg_15_0.ai_units_inside
	local var_15_20 = BLACKBOARDS
	local var_15_21 = arg_15_0._source_side
	local var_15_22 = var_15_21 and not arg_15_0.damage_friendly_ai and var_15_21.enemy_broadphase_categories or nil
	local var_15_23 = FrameTable.alloc_table()
	local var_15_24 = FrameTable.alloc_table()

	while var_15_16 > 0 do
		local var_15_25 = var_15_0[var_15_15]
		local var_15_26 = Vector3(var_15_25[1], var_15_25[2], var_15_25[3])
		local var_15_27 = var_15_25[4]
		local var_15_28 = var_15_25[5]
		local var_15_29 = AiUtils.broadphase_query(var_15_26, var_15_27, var_15_23, var_15_22)

		for iter_15_1 = 1, var_15_29 do
			local var_15_30 = var_15_23[iter_15_1]
			local var_15_31 = var_15_24[var_15_30] ~= nil
			local var_15_32 = var_15_19[var_15_30]

			if not var_15_31 and HEALTH_ALIVE[var_15_30] then
				local var_15_33 = var_0_2[var_15_30]
				local var_15_34 = Geometry.closest_point_on_line(var_15_33, var_15_7, var_15_8)

				if Vector3.distance_squared(var_15_33, var_15_34) < var_15_27 * var_15_27 then
					if not var_15_18[var_15_20[var_15_30].breed.name] then
						if var_15_17 and not var_15_32 then
							if arg_15_0.add_buff_func then
								arg_15_0.add_buff_func(arg_15_0, var_15_30, var_15_17, var_15_2, var_15_3)
							else
								var_15_4:add_buff(var_15_30, var_15_17, var_15_2, false, nil, var_15_3)
							end
						elseif var_15_32 and var_15_32 ~= var_15_25 then
							var_15_32[5][var_15_30] = nil
							var_15_28[var_15_30] = true
						end

						var_15_19[var_15_30] = var_15_25
						var_15_24[var_15_30] = true
					end
				elseif var_15_19[var_15_30] then
					if arg_15_0.leave_area_func then
						arg_15_0.leave_area_func(var_15_30)
					end

					var_15_24[var_15_30] = false
					var_15_19[var_15_30] = nil
					var_15_28[var_15_30] = nil
				end
			end
		end

		for iter_15_2, iter_15_3 in pairs(var_15_28) do
			if not HEALTH_ALIVE[iter_15_2] then
				var_15_28[iter_15_2] = nil
				var_15_19[iter_15_2] = nil
			elseif not var_15_24[iter_15_2] then
				local var_15_35 = var_0_2[iter_15_2]
				local var_15_36 = var_15_25[7]
				local var_15_37 = Geometry.closest_point_on_line(var_15_35, var_15_7, var_15_8)
				local var_15_38 = Vector3.distance_squared(var_15_35, var_15_37)
				local var_15_39 = Vector3.distance(var_15_7, var_15_37)
				local var_15_40 = math.floor(var_15_39 / arg_15_0.blob_separation_dist + 0.5) + 1
				local var_15_41 = math.clamp(var_15_40, 1, var_15_1)
				local var_15_42 = var_15_0[var_15_41]
				local var_15_43 = var_15_42[4]
				local var_15_44 = var_15_41 == var_15_36

				if var_15_38 > var_15_43 * var_15_43 then
					var_15_19[iter_15_2] = nil
					var_15_28[iter_15_2] = nil

					if arg_15_0.leave_area_func then
						arg_15_0.leave_area_func(iter_15_2)
					end
				elseif not var_15_44 then
					var_15_42[5][iter_15_2] = var_15_28[iter_15_2]
					var_15_19[iter_15_2] = var_15_42
					var_15_28[iter_15_2] = nil
				end
			end
		end

		var_15_15 = var_15_15 + 1

		if var_15_1 < var_15_15 then
			var_15_15 = 1
		end

		var_15_16 = var_15_16 - 1
	end

	arg_15_0.ai_blob_index = var_15_15
end

DamageWaveExtension.get_rim_nodes = function (arg_16_0)
	return arg_16_0.rim_nodes, true
end

DamageWaveExtension.is_position_inside = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0.blobs
	local var_17_1 = #var_17_0

	if var_17_1 == 0 then
		return false
	end

	local var_17_2 = arg_17_0.template.nav_cost_map_cost_type

	if var_17_2 == nil or arg_17_2 and arg_17_2[var_17_2] == 1 then
		return false
	end

	local var_17_3 = var_17_0[1]
	local var_17_4 = var_17_0[var_17_1]
	local var_17_5 = Vector3(var_17_3[1], var_17_3[2], var_17_3[3])
	local var_17_6 = Vector3(var_17_4[1], var_17_4[2], var_17_4[3])
	local var_17_7 = Geometry.closest_point_on_line(arg_17_1, var_17_5, var_17_6)
	local var_17_8 = Vector3.distance_squared(arg_17_1, var_17_7)
	local var_17_9 = arg_17_3 and arg_17_0.player_query_distance or arg_17_0.ai_query_distance

	return var_17_8 <= var_17_9 * var_17_9
end

DamageWaveExtension.is_position_inside_blob = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = Vector3(arg_18_2[1], arg_18_2[2], arg_18_2[3])
	local var_18_1 = Vector3.distance_squared(arg_18_1, var_18_0)
	local var_18_2 = arg_18_2[4]

	return var_18_1 < var_18_2 * var_18_2
end

DamageWaveExtension.hot_join_sync = function (arg_19_0, arg_19_1)
	if arg_19_0.is_launched then
		local var_19_0 = arg_19_0.network_transmit
		local var_19_1 = arg_19_0.unit_id
		local var_19_2 = arg_19_0.fx_list
		local var_19_3 = #var_19_2

		for iter_19_0 = 1, var_19_3 do
			local var_19_4 = var_19_2[iter_19_0]
			local var_19_5 = var_19_4.position:unbox()
			local var_19_6 = var_19_4.rotation:unbox()
			local var_19_7 = var_19_4.index
			local var_19_8 = var_19_4.name_index

			var_19_0:send_rpc("rpc_add_damage_wave_fx", arg_19_1, var_19_1, var_19_5, var_19_6, var_19_7, var_19_8)
		end

		if arg_19_0.state == "lingering" then
			var_19_0:send_rpc("rpc_damage_wave_set_state", arg_19_1, var_19_1, NetworkLookup.damage_wave_states.hide)
		else
			var_19_0:send_rpc("rpc_damage_wave_set_state", arg_19_1, var_19_1, NetworkLookup.damage_wave_states.running)
		end
	end
end

local var_0_6 = 20
local var_0_7 = var_0_6 / 2
local var_0_8 = 1

DamageWaveExtension.debug_render_wave = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = 0

	for iter_20_0 = -var_0_7, var_0_7 - 1 do
		local var_20_1 = math.sin(-math.pi + var_20_0 / var_0_6 * math.pi) * arg_20_0.max_height
		local var_20_2 = arg_20_3 + arg_20_4 * (iter_20_0 / var_0_6) * var_0_8 - var_20_1 * Vector3(0, 0, 1) - Vector3(0, 0, arg_20_5 * 2)

		QuickDrawer:circle(var_20_2, arg_20_0.max_height, arg_20_4, Colors.get("lime_green"))

		var_20_0 = var_20_0 + 1
	end
end

DamageWaveExtension.debug_render_blobs = function (arg_21_0)
	local var_21_0 = arg_21_0.blobs

	for iter_21_0 = 1, #var_21_0 do
		local var_21_1 = var_21_0[iter_21_0]
		local var_21_2 = Vector3(var_21_1[1], var_21_1[2], var_21_1[3])
		local var_21_3 = var_21_1[4]

		QuickDrawer:circle(var_21_2, var_21_3, Vector3(0, 0, 1), Color(255, 146, 60))

		local var_21_4 = var_21_1[5]

		for iter_21_1, iter_21_2 in pairs(var_21_4) do
			if ALIVE[iter_21_1] then
				local var_21_5 = var_0_2[iter_21_1]

				QuickDrawer:sphere(var_21_5, 0.5, Color(70, 146, 60))
				QuickDrawer:line(var_21_5, var_21_2, Color(70, 146, 60))
			end
		end
	end

	local var_21_6 = arg_21_0.rim_nodes

	for iter_21_3 = 1, #var_21_6 do
		local var_21_7 = var_21_6[iter_21_3]:unbox()

		QuickDrawer:sphere(var_21_7, 0.05)
	end

	local var_21_8 = arg_21_0.player_units_inside

	for iter_21_4, iter_21_5 in pairs(var_21_8) do
		if var_0_1(iter_21_4) then
			local var_21_9 = var_0_2[iter_21_4]

			QuickDrawer:sphere(var_21_9, 0.3, Color(255, 0, 60))
		end
	end
end

DamageWaveExtension._update_running_spawn_datas = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._running_spawn_configs
	local var_22_1 = arg_22_0._running_spawn_datas
	local var_22_2 = arg_22_0.unit
	local var_22_3 = var_0_2[var_22_2]
	local var_22_4 = Quaternion.look(arg_22_0.wave_direction:unbox())

	for iter_22_0 = 1, #var_22_0 do
		local var_22_5 = var_22_0[iter_22_0]
		local var_22_6 = var_22_1[iter_22_0]

		if arg_22_1 > var_22_6.next_spawn_t then
			var_22_6.next_seed = var_22_6.next_seed or Managers.state.unit_storage:go_id(var_22_2) + iter_22_0
			var_22_6.next_spawn_t = var_22_6.next_spawn_t + var_22_5.frequency

			local var_22_7 = var_22_4
			local var_22_8 = var_22_5.max_random_angle

			if var_22_8 and var_22_8 > 0 then
				local var_22_9 = Quaternion.up(var_22_4)

				var_22_7 = Quaternion.multiply(var_22_7, Quaternion.axis_angle(var_22_9, math.random(-var_22_8, var_22_8)))
			end

			local var_22_10

			if var_22_5.separation_type == "box" then
				local var_22_11 = var_22_5.bounds
				local var_22_12 = Matrix4x4.from_quaternion_position(var_22_4, var_22_3)

				var_22_6.next_seed, var_22_10 = math.get_random_point_inside_box_seeded(var_22_6.next_seed, var_22_12, var_22_11)

				local var_22_13 = var_22_5.offset

				var_22_10 = var_22_10 + Quaternion.rotate(var_22_4, Vector3(var_22_13[1], var_22_13[2], var_22_13[3]))
			end

			arg_22_0:insert_fx(var_22_10, var_22_7, iter_22_0)
		end
	end
end
