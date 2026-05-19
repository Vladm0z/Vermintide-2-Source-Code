-- chunkname: @scripts/unit_extensions/weapons/actions/action_grenade_thrower.lua

ActionGrenadeThrower = class(ActionGrenadeThrower, ActionBase)

function ActionGrenadeThrower.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionGrenadeThrower.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
end

function ActionGrenadeThrower.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionGrenadeThrower.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ActionUtils.is_critical_strike(var_2_0, arg_2_1, arg_2_2)
	local var_2_2 = ScriptUnit.extension(var_2_0, "buff_system")

	arg_2_0.power_level = arg_2_4
	arg_2_0.owner_buff_extension = var_2_2
	arg_2_0.current_action = arg_2_1
	arg_2_0.extra_buff_shot = false
	arg_2_0.num_projectiles = arg_2_1.num_projectiles
	arg_2_0.multi_projectile_spread = arg_2_1.multi_projectile_spread or 0.075

	if arg_2_0.ammo_extension and arg_2_0.num_projectiles then
		arg_2_0.num_projectiles = math.min(arg_2_0.num_projectiles, arg_2_0.ammo_extension:current_ammo())
	end

	arg_2_0.num_projectiles_shot = 1
	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + (arg_2_1.fire_time or 0)
	arg_2_0.active_reload_time = arg_2_1.active_reload_time and arg_2_2 + arg_2_1.active_reload_time

	local var_2_3 = ScriptUnit.has_extension(var_2_0, "hud_system")

	arg_2_0:_handle_critical_strike(var_2_1, var_2_2, var_2_3, nil, "on_critical_shot", nil)

	arg_2_0._is_critical_strike = var_2_1
end

function ActionGrenadeThrower.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_0.state == "waiting_to_shoot" and arg_3_2 >= arg_3_0.time_to_shoot then
		arg_3_0.state = "shooting"
	end

	if arg_3_0.state == "shooting" then
		local var_3_0 = arg_3_0.owner_unit

		if not Managers.player:owner(arg_3_0.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "crossbow_fire"
			})
		end

		local var_3_1 = ScriptUnit.extension(var_3_0, "first_person_system")
		local var_3_2, var_3_3 = var_3_1:get_projectile_start_position_rotation()
		local var_3_4 = arg_3_0.spread_extension
		local var_3_5 = arg_3_0.current_action

		if var_3_4 then
			var_3_3 = var_3_4:get_randomised_spread(var_3_3)

			var_3_4:set_shooting()
		end

		local var_3_6 = ActionUtils.pitch_from_rotation(var_3_3)
		local var_3_7 = var_3_5.speed
		local var_3_8 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_3_3)))
		local var_3_9 = var_3_5.lookup_data

		ActionUtils.spawn_player_projectile(var_3_0, var_3_2, var_3_3, 0, var_3_6, var_3_8, var_3_7, arg_3_0.item_name, var_3_9.item_template_name, var_3_9.action_name, var_3_9.sub_action_name, arg_3_0._is_critical_strike, arg_3_0.power_level)

		local var_3_10 = arg_3_0.current_action.fire_sound_event

		if var_3_10 then
			var_3_1:play_hud_sound_event(var_3_10)
		end

		if arg_3_0.ammo_extension and not arg_3_0.extra_buff_shot then
			local var_3_11 = var_3_5.ammo_usage
			local var_3_12 = ItemMasterList[arg_3_0.item_name].item_type == "grenade"
			local var_3_13, var_3_14 = arg_3_0.owner_buff_extension:apply_buffs_to_value(0, "not_consume_grenade")

			if var_3_14 and var_3_12 then
				arg_3_0.ammo_extension:add_ammo_to_reserve(var_3_11)
			end

			arg_3_0.ammo_extension:use_ammo(var_3_11)
		end

		local var_3_15 = not arg_3_0.extra_buff_shot

		if arg_3_0:_update_extra_shots(arg_3_0.owner_buff_extension, 1) then
			arg_3_0.state = "waiting_to_shoot"
			arg_3_0.time_to_shoot = arg_3_2 + 0.1
			arg_3_0.extra_buff_shot = true
		else
			arg_3_0.state = "shot"
		end

		var_3_1:reset_aim_assist_multiplier()
	end

	if arg_3_0.state == "shot" and arg_3_0.active_reload_time then
		local var_3_16 = arg_3_0.owner_unit
		local var_3_17 = ScriptUnit.extension(var_3_16, "input_system")

		if arg_3_2 > arg_3_0.active_reload_time then
			local var_3_18 = arg_3_0.ammo_extension

			if (var_3_17:get("weapon_reload") or var_3_17:get_buffer("weapon_reload")) and var_3_18:can_reload() then
				ScriptUnit.extension(arg_3_0.owner_unit, "status_system"):set_zooming(false)
				ScriptUnit.extension(arg_3_0.weapon_unit, "weapon_system"):stop_action("reload")
			end
		elseif var_3_17:get("weapon_reload") then
			var_3_17:add_buffer("weapon_reload", 0)
		end
	end
end

function ActionGrenadeThrower.finish(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.ammo_extension
	local var_4_1 = arg_4_0.current_action
	local var_4_2 = arg_4_0.owner_unit

	if arg_4_1 ~= "new_interupting_action" then
		ScriptUnit.extension(var_4_2, "status_system"):set_zooming(false)

		local var_4_3 = var_4_1.reload_when_out_of_ammo_condition_func
		local var_4_4 = not var_4_3 and true or var_4_3(var_4_2, arg_4_1)

		if var_4_0 and var_4_1.reload_when_out_of_ammo and var_4_4 and var_4_0:ammo_count() == 0 and var_4_0:can_reload() then
			local var_4_5 = true

			var_4_0:start_reload(var_4_5)
		end
	end

	local var_4_6 = ScriptUnit.has_extension(var_4_2, "hud_system")

	if var_4_6 then
		var_4_6.show_critical_indication = false
	end
end
