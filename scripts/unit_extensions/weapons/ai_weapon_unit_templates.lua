-- chunkname: @scripts/unit_extensions/weapons/ai_weapon_unit_templates.lua

AiWeaponUnitTemplates = {}

local var_0_0
local var_0_1

AiWeaponUnitTemplates.templates = {
	ratling_gun = {
		shoot_start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
			-- function 1
			arg_1_2.shoot_time = arg_1_3
			arg_1_2.shoot_timer = arg_1_3

			local flag = true
			local node = Unit.node(arg_1_1, "rp_ratlinggun")
			local make_unit_auto_source, var_1_3 = WwiseUtils.make_unit_auto_source(arg_1_0, arg_1_1, node)
			local trigger_event = WwiseWorld.trigger_event(var_1_3, "Play_ratling_gunner_shooting_loop", flag, make_unit_auto_source)

			WwiseWorld.set_source_parameter(var_1_3, make_unit_auto_source, "ratling_gun_shooting_loop_parameter", 0)

			arg_1_2.shoot_sound_source_id = make_unit_auto_source
		end,
		destroy = function (arg_2_0, arg_2_1, arg_2_2)
			-- function 2
			if not arg_2_2.shoot_sound_source_id then
				local wwise_world = Managers.world:wwise_world(arg_2_0)

				WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", arg_2_1)

				arg_2_2.shoot_sound_source_id = nil
				arg_2_2.shoot_timer = nil
				arg_2_2.shoot_time = nil
			end
		end,
		shoot = function (arg_3_0, arg_3_1, arg_3_2)
			-- function 3
			return
		end,
		shoot_end = function (arg_4_0, arg_4_1, arg_4_2)
			-- function 4
			local wwise_world = Managers.world:wwise_world(arg_4_0)

			WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", arg_4_1)

			arg_4_2.shoot_sound_source_id = nil
			arg_4_2.shoot_timer = nil
			arg_4_2.shoot_time = nil
		end,
		windup_start = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			-- function 5
			arg_5_2.windup_time = arg_5_3
			arg_5_2.windup_timer = arg_5_3
		end,
		windup_end = function (arg_6_0, arg_6_1, arg_6_2)
			-- function 6
			arg_6_2.windup_timer = nil
			arg_6_2.windup_time = nil
		end,
		update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
			-- function 7
			if not arg_7_2.shoot_timer then
				arg_7_2.shoot_timer = arg_7_2.shoot_timer - arg_7_4

				var_0_0(arg_7_0, arg_7_1, arg_7_2)
			end
		end
	},
	warpfire_gun = {
		shoot_start = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			-- function 8
			arg_8_2.shoot_time = arg_8_3
			arg_8_2.shoot_timer = arg_8_3

			local flag = true
			local node = Unit.node(arg_8_1, "rp_warpfiregun")
			local make_unit_auto_source, var_8_3 = WwiseUtils.make_unit_auto_source(arg_8_0, arg_8_1, node)
			local trigger_event = WwiseWorld.trigger_event(var_8_3, "Play_ratling_gunner_shooting_loop", flag, make_unit_auto_source)

			WwiseWorld.set_source_parameter(var_8_3, make_unit_auto_source, "ratling_gun_shooting_loop_parameter", 0)

			arg_8_2.shoot_sound_source_id = make_unit_auto_source
		end,
		destroy = function (arg_9_0, arg_9_1, arg_9_2)
			-- function 9
			if not arg_9_2.shoot_sound_source_id then
				local wwise_world = Managers.world:wwise_world(arg_9_0)

				WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", arg_9_1)

				arg_9_2.shoot_sound_source_id = nil
				arg_9_2.shoot_timer = nil
				arg_9_2.shoot_time = nil
			end
		end,
		shoot = function (arg_10_0, arg_10_1, arg_10_2)
			-- function 10
			return
		end,
		shoot_end = function (arg_11_0, arg_11_1, arg_11_2)
			-- function 11
			local wwise_world = Managers.world:wwise_world(arg_11_0)

			WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", arg_11_1)

			arg_11_2.shoot_sound_source_id = nil
			arg_11_2.shoot_timer = nil
			arg_11_2.shoot_time = nil
		end,
		windup_start = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			-- function 12
			arg_12_2.windup_time = arg_12_3
			arg_12_2.windup_timer = arg_12_3
		end,
		windup_end = function (arg_13_0, arg_13_1, arg_13_2)
			-- function 13
			arg_13_2.windup_timer = nil
			arg_13_2.windup_time = nil
		end,
		update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
			-- function 14
			if not arg_14_2.shoot_timer then
				arg_14_2.shoot_timer = arg_14_2.shoot_timer - arg_14_4

				var_0_0(arg_14_0, arg_14_1, arg_14_2)
			end
		end
	}
}

function var_0_0(arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local shoot_sound_source_id = arg_15_2.shoot_sound_source_id

	if not shoot_sound_source_id then
		local num = (arg_15_2.shoot_time - arg_15_2.shoot_timer) / arg_15_2.shoot_timer
		local wwise_world = Managers.world:wwise_world(arg_15_0)

		WwiseWorld.set_source_parameter(wwise_world, shoot_sound_source_id, "ratling_gun_shooting_loop_parameter", num)
	end
end

AiWeaponUnitTemplates.get_template = function (arg_16_0, arg_16_1)
	-- function 16
	local templates = AiWeaponUnitTemplates.templates
	local flag

	flag = (arg_16_1 ~= true or not "husk" or arg_16_1 ~= false) and (not "unit" or nil)

	local var_16_2

	if not flag then
		var_16_2 = templates[arg_16_0][flag]

		if not var_16_2 then
			-- Nothing
		end
	end

	var_16_2 = templates[arg_16_0]

	::label_16_0::

	return var_16_2
end
