-- chunkname: @scripts/unit_extensions/weapons/ai_weapon_unit_templates.lua

AiWeaponUnitTemplates = {}

local var_0_0
local var_0_1

AiWeaponUnitTemplates.templates = {
	ratling_gun = {
		shoot_start = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
			arg_1_2.shoot_time = arg_1_3
			arg_1_2.shoot_timer = arg_1_3

			local var_1_0 = true
			local var_1_1 = Unit.node(arg_1_1, "rp_ratlinggun")
			local var_1_2, var_1_3 = WwiseUtils.make_unit_auto_source(arg_1_0, arg_1_1, var_1_1)
			local var_1_4 = WwiseWorld.trigger_event(var_1_3, "Play_ratling_gunner_shooting_loop", var_1_0, var_1_2)

			WwiseWorld.set_source_parameter(var_1_3, var_1_2, "ratling_gun_shooting_loop_parameter", 0)

			arg_1_2.shoot_sound_source_id = var_1_2
		end,
		destroy = function(arg_2_0, arg_2_1, arg_2_2)
			if arg_2_2.shoot_sound_source_id then
				local var_2_0 = Managers.world:wwise_world(arg_2_0)

				WwiseWorld.trigger_event(var_2_0, "Stop_ratling_gunner_shooting_loop", arg_2_1)

				arg_2_2.shoot_sound_source_id = nil
				arg_2_2.shoot_timer = nil
				arg_2_2.shoot_time = nil
			end
		end,
		shoot = function(arg_3_0, arg_3_1, arg_3_2)
			return
		end,
		shoot_end = function(arg_4_0, arg_4_1, arg_4_2)
			local var_4_0 = Managers.world:wwise_world(arg_4_0)

			WwiseWorld.trigger_event(var_4_0, "Stop_ratling_gunner_shooting_loop", arg_4_1)

			arg_4_2.shoot_sound_source_id = nil
			arg_4_2.shoot_timer = nil
			arg_4_2.shoot_time = nil
		end,
		windup_start = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			arg_5_2.windup_time = arg_5_3
			arg_5_2.windup_timer = arg_5_3
		end,
		windup_end = function(arg_6_0, arg_6_1, arg_6_2)
			arg_6_2.windup_timer = nil
			arg_6_2.windup_time = nil
		end,
		update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
			if arg_7_2.shoot_timer then
				arg_7_2.shoot_timer = arg_7_2.shoot_timer - arg_7_4

				var_0_0(arg_7_0, arg_7_1, arg_7_2)
			end
		end
	},
	warpfire_gun = {
		shoot_start = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			arg_8_2.shoot_time = arg_8_3
			arg_8_2.shoot_timer = arg_8_3

			local var_8_0 = true
			local var_8_1 = Unit.node(arg_8_1, "rp_warpfiregun")
			local var_8_2, var_8_3 = WwiseUtils.make_unit_auto_source(arg_8_0, arg_8_1, var_8_1)
			local var_8_4 = WwiseWorld.trigger_event(var_8_3, "Play_ratling_gunner_shooting_loop", var_8_0, var_8_2)

			WwiseWorld.set_source_parameter(var_8_3, var_8_2, "ratling_gun_shooting_loop_parameter", 0)

			arg_8_2.shoot_sound_source_id = var_8_2
		end,
		destroy = function(arg_9_0, arg_9_1, arg_9_2)
			if arg_9_2.shoot_sound_source_id then
				local var_9_0 = Managers.world:wwise_world(arg_9_0)

				WwiseWorld.trigger_event(var_9_0, "Stop_ratling_gunner_shooting_loop", arg_9_1)

				arg_9_2.shoot_sound_source_id = nil
				arg_9_2.shoot_timer = nil
				arg_9_2.shoot_time = nil
			end
		end,
		shoot = function(arg_10_0, arg_10_1, arg_10_2)
			return
		end,
		shoot_end = function(arg_11_0, arg_11_1, arg_11_2)
			local var_11_0 = Managers.world:wwise_world(arg_11_0)

			WwiseWorld.trigger_event(var_11_0, "Stop_ratling_gunner_shooting_loop", arg_11_1)

			arg_11_2.shoot_sound_source_id = nil
			arg_11_2.shoot_timer = nil
			arg_11_2.shoot_time = nil
		end,
		windup_start = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			arg_12_2.windup_time = arg_12_3
			arg_12_2.windup_timer = arg_12_3
		end,
		windup_end = function(arg_13_0, arg_13_1, arg_13_2)
			arg_13_2.windup_timer = nil
			arg_13_2.windup_time = nil
		end,
		update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
			if arg_14_2.shoot_timer then
				arg_14_2.shoot_timer = arg_14_2.shoot_timer - arg_14_4

				var_0_0(arg_14_0, arg_14_1, arg_14_2)
			end
		end
	}
}

function var_0_0(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_2.shoot_sound_source_id

	if var_15_0 then
		local var_15_1 = (arg_15_2.shoot_time - arg_15_2.shoot_timer) / arg_15_2.shoot_timer
		local var_15_2 = Managers.world:wwise_world(arg_15_0)

		WwiseWorld.set_source_parameter(var_15_2, var_15_0, "ratling_gun_shooting_loop_parameter", var_15_1)
	end
end

function AiWeaponUnitTemplates.get_template(arg_16_0, arg_16_1)
	local var_16_0 = AiWeaponUnitTemplates.templates
	local var_16_1 = arg_16_1 == true and "husk" or arg_16_1 == false and "unit" or nil

	return var_16_1 and var_16_0[arg_16_0][var_16_1] or var_16_0[arg_16_0]
end
