-- chunkname: @scripts/unit_extensions/weapons/actions/action_true_flight_bow.lua

require("scripts/unit_extensions/weapons/projectiles/true_flight_templates")

ActionTrueFlightBow = class(ActionTrueFlightBow, ActionBase)

ActionTrueFlightBow.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionTrueFlightBow.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
end

ActionTrueFlightBow.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionTrueFlightBow.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0.current_action = arg_2_1
	arg_2_0.true_flight_template_id = TrueFlightTemplates[arg_2_1.true_flight_template].lookup_id

	assert(arg_2_0.true_flight_template_id)

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ScriptUnit.extension(var_2_0, "buff_system")
	local var_2_2 = ActionUtils.is_critical_strike(var_2_0, arg_2_1, arg_2_2)
	local var_2_3 = arg_2_0:_update_extra_shots(var_2_1) or 0

	arg_2_0.num_extra_shots = var_2_3

	arg_2_0:_update_extra_shots(var_2_1, var_2_3)

	arg_2_0.num_projectiles = (arg_2_1.num_projectiles or 1) + var_2_3

	if ScriptUnit.has_extension(var_2_0, "talent_system"):has_talent("kerillian_waywatcher_activated_ability_additional_projectile") then
		arg_2_0.num_projectiles = arg_2_0.num_projectiles + 1
	end

	arg_2_0.multi_projectile_spread = arg_2_1.multi_projectile_spread or 0.075
	arg_2_0.num_projectiles_shot = 1

	if arg_2_3 then
		arg_2_0.targets = arg_2_3.targets

		if not arg_2_0.targets then
			arg_2_0.targets = {
				arg_2_3.target
			}
		end
	end

	if arg_2_5 then
		arg_2_0.targets = arg_2_5.targets

		if not arg_2_0.targets then
			arg_2_0.targets = {
				arg_2_5.target
			}
		end
	end

	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + (arg_2_1.fire_time or 0)
	arg_2_0.power_level = arg_2_4
	arg_2_0.extra_buff_shot = false

	local var_2_4 = ScriptUnit.has_extension(var_2_0, "hud_system")

	arg_2_0:_handle_critical_strike(var_2_2, var_2_1, var_2_4, nil, "on_critical_shot", nil)

	arg_2_0._is_critical_strike = var_2_2
end

ActionTrueFlightBow.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.current_action

	if arg_3_0.state == "waiting_to_shoot" and arg_3_2 >= arg_3_0.time_to_shoot then
		arg_3_0.state = "shooting"
	end

	if arg_3_0.state == "shooting" then
		arg_3_0:fire(var_3_0)

		arg_3_0.state = "shot"

		local var_3_1 = arg_3_0.first_person_extension

		if arg_3_0.current_action.reset_aim_on_attack then
			var_3_1:reset_aim_assist_multiplier()
		end

		local var_3_2 = arg_3_0.current_action.fire_sound_event

		if var_3_2 then
			local var_3_3 = arg_3_0.current_action.fire_sound_on_husk

			var_3_1:play_hud_sound_event(var_3_2, nil, var_3_3)
		end

		if arg_3_0.current_action.extra_fire_sound_event then
			local var_3_4 = POSITION_LOOKUP[arg_3_0.owner_unit]

			WwiseUtils.trigger_position_event(arg_3_0.world, arg_3_0.current_action.extra_fire_sound_event, var_3_4)
		end
	end
end

ActionTrueFlightBow.finish = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = ScriptUnit.extension(arg_4_0.owner_unit, "status_system")

	if not arg_4_2 or arg_4_2.new_action ~= "action_two" or arg_4_2.new_sub_action ~= "default" then
		var_4_0:set_zooming(false)
	end
end

ActionTrueFlightBow.fire = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = arg_5_1.speed
	local var_5_2, var_5_3 = arg_5_0.first_person_extension:get_projectile_start_position_rotation()
	local var_5_4 = arg_5_0.spread_extension
	local var_5_5 = arg_5_0.num_projectiles
	local var_5_6 = var_5_5 - arg_5_0.num_extra_shots + 1

	for iter_5_0 = 1, var_5_5 do
		local var_5_7 = var_5_3
		local var_5_8 = var_5_6 <= iter_5_0

		if var_5_4 then
			if arg_5_0.num_projectiles_shot > 1 then
				local var_5_9 = math.pi * (arg_5_0.num_projectiles_shot % 2 + 0.5)
				local var_5_10 = arg_5_0.num_projectiles_shot == 1 and 0 or math.round((arg_5_0.num_projectiles_shot - 1) * 0.5, 0)
				local var_5_11 = arg_5_0.multi_projectile_spread * var_5_10

				var_5_7 = var_5_4:combine_spread_rotations(var_5_9, var_5_11, var_5_7)
			end

			if not var_5_8 then
				var_5_4:set_shooting()
			end
		end

		local var_5_12 = ActionUtils.pitch_from_rotation(var_5_7)
		local var_5_13 = Vector3.normalize(Quaternion.forward(var_5_7))

		if iter_5_0 > 1 then
			var_5_1 = var_5_1 * (1 - iter_5_0 * 0.05)
		end

		local var_5_14 = arg_5_0.targets and (arg_5_1.single_target and arg_5_0.targets[1] or arg_5_0.targets[iter_5_0])
		local var_5_15 = arg_5_1.lookup_data
		local var_5_16 = 1

		ActionUtils.spawn_true_flight_projectile(var_5_0, var_5_14, arg_5_0.true_flight_template_id, var_5_2, var_5_7, var_5_12, var_5_13, var_5_1, arg_5_0.item_name, var_5_15.item_template_name, var_5_15.action_name, var_5_15.sub_action_name, var_5_16, arg_5_0._is_critical_strike, arg_5_0.power_level)

		if arg_5_0.ammo_extension and not var_5_8 then
			local var_5_17 = arg_5_0.current_action.ammo_usage

			arg_5_0.ammo_extension:use_ammo(var_5_17)

			if arg_5_0.ammo_extension:can_reload() then
				local var_5_18 = false

				arg_5_0.ammo_extension:start_reload(var_5_18)
			end
		end

		arg_5_0.num_projectiles_shot = arg_5_0.num_projectiles_shot + 1

		local var_5_19 = arg_5_1.overcharge_type

		if var_5_19 and not var_5_8 then
			local var_5_20 = PlayerUnitStatusSettings.overcharge_values[var_5_19]

			if arg_5_1.scale_overcharge then
				arg_5_0.overcharge_extension:add_charge(var_5_20, arg_5_0.charge_level)
			else
				arg_5_0.overcharge_extension:add_charge(var_5_20)
			end
		end

		if arg_5_1.alert_sound_range_fire then
			Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_5_0, POSITION_LOOKUP[var_5_0], arg_5_1.alert_sound_range_fire)
		end
	end
end
