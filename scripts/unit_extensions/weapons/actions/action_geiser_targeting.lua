-- chunkname: @scripts/unit_extensions/weapons/actions/action_geiser_targeting.lua

ActionGeiserTargeting = class(ActionGeiserTargeting, ActionBase)

function ActionGeiserTargeting.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionGeiserTargeting.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.position = Vector3Box()
	arg_1_0.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
	arg_1_0._is_server = arg_1_3
end

function ActionGeiserTargeting.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionGeiserTargeting.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	local var_2_0 = arg_2_0.world
	local var_2_1 = arg_2_0.network_transmit
	local var_2_2 = arg_2_0.owner_unit

	arg_2_0.overcharge_timer = 0
	arg_2_0.current_action = arg_2_1
	arg_2_0.fully_charged_triggered = false

	local var_2_3 = arg_2_1.particle_effect
	local var_2_4 = NetworkLookup.effects[var_2_3]
	local var_2_5 = ScriptUnit.extension(var_2_2, "buff_system")

	arg_2_0.buff_extension = var_2_5

	if not arg_2_0._is_server then
		arg_2_0.targeting_effect_id = World.create_particles(var_2_0, var_2_3, Vector3.zero())
		arg_2_0.targeting_variable_id = World.find_particles_variable(var_2_0, var_2_3, "charge_radius")
	end

	arg_2_0.charge_time = var_2_5:apply_buffs_to_value(arg_2_1.charge_time, "reduced_ranged_charge_time")
	arg_2_0.angle = math.degrees_to_radians(arg_2_1.angle)
	arg_2_0.time_to_shoot = arg_2_2

	local var_2_6 = arg_2_0.unit_id

	var_2_1:send_rpc_server("rpc_start_geiser", var_2_6, var_2_4, arg_2_1.min_radius, arg_2_1.max_radius, arg_2_0.charge_time, arg_2_0.angle)

	arg_2_0.min_radius = arg_2_1.min_radius
	arg_2_0.max_radius = arg_2_1.max_radius
	arg_2_0.radius = arg_2_0.min_radius
	arg_2_0.charge_ready_sound_event = arg_2_0.current_action.charge_ready_sound_event
	arg_2_0.speed = arg_2_1.speed
	arg_2_0.gravity = arg_2_1.gravity
	arg_2_0.height = arg_2_1.height or 1
	arg_2_0.debug_draw = arg_2_1.debug_draw

	local var_2_7 = Managers.player:owner(var_2_2)

	if not (var_2_7 and var_2_7.bot_player) and arg_2_0.current_action.fire_at_gaze_setting and ScriptUnit.has_extension(var_2_2, "eyetracking_system") then
		local var_2_8 = ScriptUnit.extension(var_2_2, "eyetracking_system")

		if var_2_8:get_is_feature_enabled("tobii_fire_at_gaze") then
			local var_2_9 = Unit.world_rotation(arg_2_0.first_person_unit, 0)
			local var_2_10 = var_2_8:gaze_rotation()
			local var_2_11 = Quaternion.inverse(var_2_9)
			local var_2_12 = Quaternion.multiply(var_2_11, var_2_10)

			arg_2_0.fire_at_gaze_offset = QuaternionBox()

			QuaternionBox.store(arg_2_0.fire_at_gaze_offset, var_2_12)
		end
	end

	arg_2_0:_start_charge_sound()

	arg_2_0.charge_value = 0
end

local function var_0_0(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_2 / arg_3_1

	for iter_3_0 = 1, arg_3_1 do
		local var_3_1 = arg_3_3 + arg_3_4 * var_3_0
		local var_3_2 = var_3_1 - arg_3_3
		local var_3_3 = Vector3.normalize(var_3_2)
		local var_3_4 = Vector3.length(var_3_2)
		local var_3_5, var_3_6, var_3_7, var_3_8, var_3_9 = PhysicsWorld.immediate_raycast(arg_3_0, arg_3_3, var_3_3, var_3_4, "closest", "collision_filter", arg_3_6)

		if var_3_6 then
			return var_3_5, var_3_6, var_3_7, var_3_8, var_3_9
		end

		arg_3_4 = arg_3_4 + arg_3_5 * var_3_0
		arg_3_3 = var_3_1
	end

	return false, arg_3_3
end

function ActionGeiserTargeting._start_charge_sound(arg_4_0)
	local var_4_0 = arg_4_0.current_action
	local var_4_1 = arg_4_0.owner_unit
	local var_4_2 = arg_4_0.owner_player
	local var_4_3 = var_4_2 and var_4_2.bot_player
	local var_4_4 = var_4_2 and not var_4_2.remote
	local var_4_5 = arg_4_0.wwise_world

	if var_4_4 and not var_4_3 then
		local var_4_6, var_4_7 = ActionUtils.start_charge_sound(var_4_5, arg_4_0.weapon_unit, var_4_1, var_4_0)

		arg_4_0.charging_sound_id = var_4_6
		arg_4_0.wwise_source_id = var_4_7
	end

	ActionUtils.play_husk_sound_event(var_4_5, var_4_0.charge_sound_husk_name, var_4_1, var_4_3)
end

function ActionGeiserTargeting._stop_charge_sound(arg_5_0)
	local var_5_0 = arg_5_0.current_action
	local var_5_1 = arg_5_0.owner_unit
	local var_5_2 = arg_5_0.owner_player
	local var_5_3 = var_5_2 and var_5_2.bot_player
	local var_5_4 = var_5_2 and not var_5_2.remote
	local var_5_5 = arg_5_0.wwise_world

	if var_5_4 and not var_5_3 then
		ActionUtils.stop_charge_sound(var_5_5, arg_5_0.charging_sound_id, arg_5_0.wwise_source_id, var_5_0)

		arg_5_0.charging_sound_id = nil
		arg_5_0.wwise_source_id = nil
	end

	ActionUtils.play_husk_sound_event(var_5_5, var_5_0.charge_sound_husk_stop_event, var_5_1, var_5_3)
end

function ActionGeiserTargeting.client_owner_post_update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_0.time_to_shoot
	local var_6_1 = arg_6_0.current_action

	if var_6_1.overcharge_interval then
		arg_6_0.overcharge_timer = arg_6_0.overcharge_timer + arg_6_1

		if arg_6_0.overcharge_timer >= var_6_1.overcharge_interval then
			if arg_6_0.overcharge_extension then
				local var_6_2 = PlayerUnitStatusSettings.overcharge_values[var_6_1.overcharge_type]

				arg_6_0.overcharge_extension:add_charge(var_6_2, nil, var_6_1.overcharge_type)
			end

			arg_6_0.overcharge_timer = 0
		end
	end

	local var_6_3 = POSITION_LOOKUP[arg_6_0.owner_unit]
	local var_6_4 = POSITION_LOOKUP[arg_6_0.first_person_unit]
	local var_6_5 = Unit.world_rotation(arg_6_0.first_person_unit, 0)

	if arg_6_0.fire_at_gaze_offset then
		var_6_5 = Quaternion.multiply(var_6_5, QuaternionBox.unbox(arg_6_0.fire_at_gaze_offset))
	end

	local var_6_6
	local var_6_7 = World.get_data(arg_6_3, "physics_world")
	local var_6_8 = 10
	local var_6_9 = 1.5
	local var_6_10 = arg_6_0.speed
	local var_6_11 = arg_6_0.angle
	local var_6_12 = Quaternion.forward(Quaternion.multiply(var_6_5, Quaternion(Vector3.right(), var_6_11))) * var_6_10
	local var_6_13 = Vector3(0, 0, arg_6_0.gravity)
	local var_6_14 = "filter_geiser_check"
	local var_6_15, var_6_16, var_6_17, var_6_18 = var_0_0(var_6_7, var_6_8, var_6_9, var_6_4, var_6_12, var_6_13, var_6_14, arg_6_0.debug_draw)
	local var_6_19 = var_6_16

	if var_6_15 then
		local var_6_20 = Vector3(0, 0, 1)

		if Vector3.dot(var_6_18, var_6_20) < 0.75 then
			local var_6_21 = var_6_19 - 1 * Vector3.normalize(var_6_19 - var_6_3)
			local var_6_22, var_6_23, var_6_24, var_6_25 = PhysicsWorld.immediate_raycast(var_6_7, var_6_21, Vector3(0, 0, -1), 5, "closest", "collision_filter", var_6_14)

			if var_6_23 then
				var_6_19 = var_6_23
			end
		end
	end

	arg_6_0.position:store(var_6_19)

	arg_6_0.charge_value = math.min(math.max(arg_6_2 - var_6_0, 0) / arg_6_0.charge_time, 1)

	if arg_6_0.charge_value >= 1 and not arg_6_0.fully_charged_triggered then
		arg_6_0.fully_charged_triggered = true

		arg_6_0.buff_extension:trigger_procs("on_full_charge")
	end

	local var_6_26 = arg_6_0.min_radius
	local var_6_27 = arg_6_0.max_radius
	local var_6_28 = math.min(var_6_27, (var_6_27 - var_6_26) * arg_6_0.charge_value + var_6_26)

	arg_6_0.radius = var_6_28

	if arg_6_0.targeting_effect_id then
		local var_6_29 = var_6_28 * 2

		World.move_particles(arg_6_3, arg_6_0.targeting_effect_id, var_6_19)
		World.set_particles_variable(arg_6_3, arg_6_0.targeting_effect_id, arg_6_0.targeting_variable_id, Vector3(var_6_29, var_6_29, 1))
	end

	local var_6_30 = arg_6_0.owner_unit
	local var_6_31 = Managers.player:owner(var_6_30)

	if not (var_6_31 and var_6_31.bot_player) then
		local var_6_32 = var_6_1.charge_sound_parameter_name

		if var_6_32 then
			local var_6_33 = arg_6_0.wwise_world
			local var_6_34 = arg_6_0.wwise_source_id

			WwiseWorld.set_source_parameter(var_6_33, var_6_34, var_6_32, arg_6_0.charge_value)
		end

		if arg_6_0.charge_ready_sound_event and arg_6_0.charge_value >= 1 then
			arg_6_0.first_person_extension:play_hud_sound_event(arg_6_0.charge_ready_sound_event)

			arg_6_0.charge_ready_sound_event = nil
		end
	end
end

function ActionGeiserTargeting.finish(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.world
	local var_7_1 = arg_7_0.network_transmit
	local var_7_2 = arg_7_0.unit_id

	var_7_1:send_rpc_server("rpc_end_geiser", var_7_2)

	local var_7_3 = {
		radius = arg_7_0.radius,
		range = arg_7_0.range,
		height = arg_7_0.height,
		charge_value = arg_7_0.charge_value,
		position = arg_7_0.position
	}

	if arg_7_0.targeting_effect_id then
		World.destroy_particles(var_7_0, arg_7_0.targeting_effect_id)

		arg_7_0.targeting_effect_id = nil
	end

	arg_7_0:_stop_charge_sound()
	arg_7_0.buff_extension:trigger_procs("on_charge_finished")

	return var_7_3
end

function ActionGeiserTargeting.destroy(arg_8_0)
	if arg_8_0.targeting_effect_id then
		World.destroy_particles(arg_8_0.world, arg_8_0.targeting_effect_id)

		arg_8_0.targeting_effect_id = nil
	end

	arg_8_0:_stop_charge_sound()
end
