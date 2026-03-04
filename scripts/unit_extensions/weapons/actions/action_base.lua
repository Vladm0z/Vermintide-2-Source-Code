-- chunkname: @scripts/unit_extensions/weapons/actions/action_base.lua

ActionBase = class(ActionBase)

local var_0_0 = Unit.flow_event

ActionBase.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	arg_1_0.world = arg_1_1
	arg_1_0.physics_world = World.get_data(arg_1_1, "physics_world")
	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_1)
	arg_1_0.first_person_unit = arg_1_6
	arg_1_0.owner_unit = arg_1_4
	arg_1_0.owner = Managers.player:unit_owner(arg_1_4)
	arg_1_0.owner_player = Managers.player:owner(arg_1_4)
	arg_1_0.weapon_unit = arg_1_7
	arg_1_0.item_name = arg_1_2
	arg_1_0.weapon_system = arg_1_8

	local var_1_0 = Managers.state.network

	arg_1_0.network_manager = var_1_0
	arg_1_0.network_transmit = var_1_0.network_transmit
	arg_1_0.is_server = arg_1_3
	arg_1_0.is_bot = arg_1_0.owner_player and arg_1_0.owner_player.bot_player
	arg_1_0._is_critical_strike = false
	arg_1_0._fatigue_reset = true
	arg_1_0._extra_shots = 0
	arg_1_0._extra_shots_procced = false
end

ActionBase.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_0.current_action = arg_2_1

	ScriptUnit.has_extension(arg_2_0.owner_unit, "buff_system"):trigger_procs("on_start_action", arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0._fatigue_reset = true
	arg_2_0._extra_shots_procced = false
	arg_2_0.action_start_t = arg_2_2
end

ActionBase._handle_critical_strike = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	if arg_3_1 then
		arg_3_0:_do_critical_strike_fx(arg_3_3, arg_3_4, arg_3_6)
		arg_3_0:_do_critical_strike_procs(arg_3_2, arg_3_5)
	end
end

ActionBase._do_critical_strike_fx = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0.owner_unit
	local var_4_1 = arg_4_0.first_person_unit

	if Application.user_setting("weapon_trails") == "normal" then
		var_0_0(var_4_0, "vfx_critical_strike")
		var_0_0(var_4_1, "vfx_critical_strike")
	end

	if arg_4_1 then
		arg_4_1.show_critical_indication = true
	end

	if arg_4_2 and arg_4_3 then
		arg_4_2:play_hud_sound_event(arg_4_3, nil, false)
	end
end

ActionBase._do_critical_strike_procs = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 and arg_5_2 then
		arg_5_1:trigger_procs(arg_5_2)
	end
end

ActionBase._update_extra_shots = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0.current_action

	if var_6_0 and var_6_0.no_extra_shots then
		return nil
	end

	if not arg_6_0._extra_shots_procced or arg_6_3 then
		local var_6_1 = arg_6_1:apply_buffs_to_value(0, "extra_shot")

		arg_6_0._extra_shots = math.floor(var_6_1)
		arg_6_0._extra_shots_procced = true
	end

	if arg_6_0._extra_shots > 0 then
		if arg_6_2 then
			arg_6_0._extra_shots = arg_6_0._extra_shots - arg_6_2
		end

		return arg_6_0._extra_shots
	end
end

ActionBase._handle_fatigue = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0

	if arg_7_0._fatigue_reset then
		if arg_7_4 then
			var_7_0 = arg_7_1:has_buff_perk("no_push_fatigue_cost")
		end

		if not var_7_0 then
			local var_7_1 = "action_push"
			local var_7_2 = 1

			if arg_7_3.fatigue_cost then
				var_7_1 = arg_7_3.fatigue_cost
			end

			if arg_7_1:has_buff_perk("slayer_stamina") then
				var_7_2 = 0.5
			end

			arg_7_2:add_fatigue_points(var_7_1, nil, nil, var_7_2)
			arg_7_2:set_has_pushed(arg_7_3.fatigue_regen_delay)
		end

		arg_7_0._fatigue_reset = false
	end
end

ActionBase._proc_spell_used = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.current_action

	if arg_8_1 and var_8_0 and var_8_0.is_spell then
		arg_8_1:trigger_procs("on_spell_used", var_8_0)
	end
end

ActionBase._play_additional_animation = function (arg_9_0, arg_9_1)
	if arg_9_1 and arg_9_1.variable_name and arg_9_1.variable_value then
		if arg_9_1.third_person then
			local var_9_0 = arg_9_0.owner_unit

			if var_9_0 then
				if arg_9_1.anim_event then
					CharacterStateHelper.play_animation_event_with_variable_float(var_9_0, arg_9_1.anim_event, arg_9_1.variable_name, arg_9_1.variable_value)
				else
					CharacterStateHelper.set_animation_variable_float(var_9_0, arg_9_1.variable_name, arg_9_1.variable_value)
				end
			end
		end

		if arg_9_1.first_person then
			local var_9_1 = arg_9_0.first_person_unit

			if var_9_1 then
				local var_9_2 = Unit.animation_find_variable(var_9_1, arg_9_1.variable_name)

				Unit.animation_set_variable(var_9_1, var_9_2, arg_9_1.variable_value)

				if arg_9_1.anim_event then
					Unit.animation_event(var_9_1, arg_9_1.anim_event)
				end
			end
		end
	end
end

ActionBase.finish = function (arg_10_0, arg_10_1)
	return
end
