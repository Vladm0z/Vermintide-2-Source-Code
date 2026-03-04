-- chunkname: @scripts/settings/dlcs/bless/action_career_wh_priest_target.lua

ActionCareerWHPriestTarget = class(ActionCareerWHPriestTarget, ActionBase)

local var_0_0 = {
	target_self = "wh_priest_self",
	target_ally = "wh_priest_ally"
}

ActionCareerWHPriestTarget.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerWHPriestTarget.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0._outline_system = Managers.state.entity:system("outline_system")
	arg_1_0._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0._marked_target = {}
end

ActionCareerWHPriestTarget.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionCareerWHPriestTarget.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0.aim_timer = arg_2_1.target_sticky_time
	arg_2_0.aimed_target = arg_2_3 and arg_2_3.target

	arg_2_0._weapon_extension:set_mode(false)

	arg_2_0.played_aim_sound = false
	arg_2_0.aim_sound_time = arg_2_2 + (arg_2_1.aim_sound_delay or 0)
	arg_2_0._max_range = arg_2_1.max_range
	arg_2_0._cone_cos_angle = math.cos(math.rad(arg_2_1.target_cone_angle))

	arg_2_0:_start_charge_sound()
end

ActionCareerWHPriestTarget._start_charge_sound = function (arg_3_0)
	local var_3_0 = arg_3_0.current_action
	local var_3_1 = arg_3_0.owner_unit
	local var_3_2 = arg_3_0.wwise_world
	local var_3_3 = arg_3_0.is_bot

	if not var_3_3 then
		local var_3_4 = arg_3_0.owner_player

		if var_3_4 and not var_3_4.remote then
			local var_3_5, var_3_6 = ActionUtils.start_charge_sound(var_3_2, arg_3_0.weapon_unit, var_3_1, var_3_0)

			arg_3_0.charging_sound_id = var_3_5
			arg_3_0.wwise_source_id = var_3_6
		end
	end

	ActionUtils.play_husk_sound_event(var_3_2, var_3_0.charge_sound_husk_name, var_3_1, var_3_3)
end

ActionCareerWHPriestTarget._stop_charge_sound = function (arg_4_0)
	local var_4_0 = arg_4_0.current_action
	local var_4_1 = arg_4_0.owner_unit
	local var_4_2 = arg_4_0.wwise_world
	local var_4_3 = arg_4_0.is_bot

	if not var_4_3 then
		local var_4_4 = arg_4_0.owner_player

		if var_4_4 and not var_4_4.remote then
			ActionUtils.stop_charge_sound(var_4_2, arg_4_0.charging_sound_id, arg_4_0.wwise_source_id, var_4_0)

			arg_4_0.charging_sound_id = nil
			arg_4_0.wwise_source_id = nil
		end
	end

	ActionUtils.play_husk_sound_event(var_4_2, var_4_0.charge_sound_husk_stop_event, var_4_1, var_4_3)
end

ActionCareerWHPriestTarget.client_owner_post_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0.current_action
	local var_5_1 = arg_5_0.owner_unit
	local var_5_2 = arg_5_0.aimed_target
	local var_5_3 = arg_5_0.aimed_target
	local var_5_4 = arg_5_0.is_bot
	local var_5_5 = arg_5_0._outline_system

	if var_5_2 and not HEALTH_ALIVE[var_5_2] then
		arg_5_0:_mark_target(nil)

		var_5_2 = nil
	end

	if (var_5_0.target_sticky_time or 0) <= arg_5_0.aim_timer then
		local var_5_6 = arg_5_0:_target_ally_from_crosshair()

		if var_5_2 ~= var_5_6 then
			arg_5_0:_mark_target(var_5_6)

			arg_5_0.aim_timer = 0
		end
	end

	if not var_5_4 then
		if not arg_5_0.played_aim_sound and arg_5_2 >= arg_5_0.aim_sound_time then
			local var_5_7 = var_5_0.aim_sound_event

			if var_5_7 then
				local var_5_8 = arg_5_0.wwise_world

				WwiseWorld.trigger_event(var_5_8, var_5_7)
			end

			arg_5_0.played_aim_sound = true
		end
	else
		local var_5_9 = BLACKBOARDS[var_5_1]
		local var_5_10 = var_5_9 and var_5_9.activate_ability_data.target_unit or var_5_1

		arg_5_0._weapon_extension:set_mode(var_5_10 ~= var_5_1)
	end

	arg_5_0.aim_timer = arg_5_0.aim_timer + arg_5_1
end

ActionCareerWHPriestTarget._mark_target = function (arg_6_0, arg_6_1)
	if arg_6_0.is_bot then
		return
	end

	local var_6_0 = arg_6_0._marked_target

	if var_6_0.outline_extension then
		var_6_0.outline_extension:remove_outline(var_6_0.outline_id)

		var_6_0.outline_extension = nil
		var_6_0.outline_id = nil
	end

	if arg_6_1 and ALIVE[arg_6_1] then
		local var_6_1 = ScriptUnit.has_extension(arg_6_1, "outline_system")

		if var_6_1 then
			var_6_0.outline_extension = var_6_1
			var_6_0.outline_id = var_6_1:add_outline(OutlineSettings.templates.tutorial_highlight)
		end
	end

	local var_6_2 = arg_6_0._weapon_extension
	local var_6_3 = arg_6_1 and arg_6_1 ~= arg_6_0.owner_unit

	var_6_2:set_mode(var_6_3)

	if var_6_3 then
		local var_6_4 = Managers.player:owner(arg_6_1)
		local var_6_5 = var_6_4:profile_index()
		local var_6_6 = var_6_4:career_index()
		local var_6_7 = UIUtils.get_portrait_image_by_profile_index(var_6_5, var_6_6)

		Managers.state.event:trigger("on_set_ability_target_name", "small_" .. var_6_7, var_0_0.target_ally)
	else
		Managers.state.event:trigger("on_set_ability_target_name", nil, var_0_0.target_self)
	end

	local var_6_8 = arg_6_0.current_action
	local var_6_9 = var_6_3 and var_6_8.target_other_anim_event or var_6_8.target_self_anim_event
	local var_6_10 = arg_6_0.first_person_extension:get_first_person_unit()

	if var_6_9 then
		Unit.animation_event(var_6_10, var_6_9)
	end

	arg_6_0.aimed_target = arg_6_1
end

ActionCareerWHPriestTarget._target_ally_from_crosshair = function (arg_7_0)
	local var_7_0 = arg_7_0._max_range
	local var_7_1 = var_7_0 * var_7_0
	local var_7_2 = arg_7_0._cone_cos_angle
	local var_7_3 = arg_7_0.owner_unit
	local var_7_4, var_7_5 = arg_7_0.first_person_extension:camera_position_rotation()
	local var_7_6 = Vector3.normalize(Quaternion.forward(var_7_5))
	local var_7_7 = Managers.state.side.side_by_unit[var_7_3]
	local var_7_8 = var_7_7 and var_7_7.PLAYER_AND_BOT_UNITS
	local var_7_9 = var_7_8 and #var_7_8 or 0
	local var_7_10
	local var_7_11 = 0
	local var_7_12 = 0

	for iter_7_0 = 1, var_7_9 do
		local var_7_13 = var_7_8[iter_7_0]

		if var_7_13 ~= arg_7_0.owner_unit and HEALTH_ALIVE[var_7_13] then
			local var_7_14, var_7_15, var_7_16 = arg_7_0:_check_cone_from_crosshair(var_7_4, var_7_6, var_7_13, var_7_1, var_7_2)

			if var_7_14 and var_7_12 <= var_7_15 then
				var_7_12 = var_7_15
				var_7_11 = var_7_16

				if var_7_16 < var_7_1 then
					var_7_10 = var_7_13
				else
					var_7_10 = nil
				end
			end
		end
	end

	return var_7_10, var_7_11
end

ActionCareerWHPriestTarget._check_cone_from_crosshair = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = Unit.world_position(arg_8_3, Unit.node(arg_8_3, "j_claw_attach")) - arg_8_1
	local var_8_1 = Vector3.length_squared(var_8_0)
	local var_8_2 = Vector3.normalize(var_8_0)
	local var_8_3 = Vector3.dot(arg_8_2, var_8_2)

	if arg_8_5 <= var_8_3 then
		return true, var_8_3, var_8_1
	end
end

ActionCareerWHPriestTarget.finish = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.is_bot
	local var_9_1 = arg_9_0.aimed_target or arg_9_0.owner_unit

	if var_9_0 then
		local var_9_2 = BLACKBOARDS[arg_9_0.owner_unit]

		var_9_1 = var_9_2 and var_9_2.activate_ability_data.target_unit or arg_9_0.owner_unit
	end

	local var_9_3 = {
		target = var_9_1
	}
	local var_9_4 = arg_9_0.current_action

	if not var_9_0 then
		local var_9_5 = var_9_4.unaim_sound_event

		if var_9_5 then
			local var_9_6 = arg_9_0.wwise_world

			WwiseWorld.trigger_event(var_9_6, var_9_5)
		end
	end

	if arg_9_1 ~= "new_interupting_action" then
		arg_9_0.inventory_extension:wield_previous_non_level_slot()
		arg_9_0.first_person_extension:play_hud_sound_event("priest_book_loop_stop")
	end

	arg_9_0:_stop_charge_sound()
	arg_9_0:_mark_target(nil)

	return var_9_3
end
