-- chunkname: @scripts/settings/dlcs/cog/action_career_dr_engineer_charge.lua

ActionCareerDREngineerCharge = class(ActionCareerDREngineerCharge, ActionBase)

function ActionCareerDREngineerCharge.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerDREngineerCharge.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0.owner_unit = arg_1_4
	arg_1_0.audio_loop_id = "engineer_weapon_charge"
	arg_1_0._buff_to_add = "bardin_engineer_pump_buff"
end

function ActionCareerDREngineerCharge.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionCareerDREngineerCharge.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.ability_charge_timer = -arg_2_1.initial_charge_delay

	arg_2_0:start_audio_loop()
end

function ActionCareerDREngineerCharge.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.buff_extension
	local var_3_1 = arg_3_0.current_action.ability_charge_interval
	local var_3_2 = arg_3_0.ability_charge_timer + arg_3_1

	if var_3_1 <= var_3_2 then
		local var_3_3 = math.floor(var_3_2 / var_3_1)

		var_3_2 = var_3_2 - var_3_3 * var_3_1

		local var_3_4 = arg_3_0.wwise_world
		local var_3_5 = arg_3_0._buff_to_add
		local var_3_6 = var_3_0:num_buff_type(var_3_5)
		local var_3_7 = var_3_0:get_buff_type(var_3_5)

		if var_3_7 then
			if not arg_3_0.last_pump_time then
				arg_3_0.last_pump_time = arg_3_2
			end

			local var_3_8 = var_3_7.template

			if arg_3_2 - arg_3_0.last_pump_time > 10 and var_3_6 >= var_3_8.max_stacks then
				Managers.state.achievement:trigger_event("clutch_pump", arg_3_0.owner_unit)
			end

			arg_3_0.last_pump_time = arg_3_2
		end

		WwiseWorld.set_global_parameter(var_3_4, "engineer_charge", var_3_6 + var_3_3)

		for iter_3_0 = 1, var_3_3 do
			var_3_0:add_buff(var_3_5)
		end
	end

	arg_3_0.ability_charge_timer = var_3_2
end

function ActionCareerDREngineerCharge.finish(arg_4_0, arg_4_1)
	return
end

function ActionCareerDREngineerCharge.start_audio_loop(arg_5_0)
	local var_5_0 = arg_5_0.current_action
	local var_5_1 = var_5_0.charge_sound_name
	local var_5_2 = var_5_0.charge_sound_stop_event

	if not var_5_1 or not var_5_2 then
		return
	end

	local var_5_3 = arg_5_0.weapon_extension
	local var_5_4 = var_5_0.charge_sound_husk_name
	local var_5_5 = var_5_0.charge_sound_husk_stop_event

	var_5_3:add_looping_audio(arg_5_0.audio_loop_id, var_5_1, var_5_2, var_5_4, var_5_5)
	var_5_3:start_looping_audio(arg_5_0.audio_loop_id)
end
