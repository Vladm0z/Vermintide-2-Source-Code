-- chunkname: @scripts/unit_extensions/weapons/single_weapon_unit_templates_vs.lua

local var_0_0

local function fn(arg_1_0)
	-- function 1
	if not DEDICATED_SERVER then
		return false
	end

	local player = Managers.player
	local local_player = player:local_player()

	if player:unit_owner(arg_1_0) == local_player then
		return true
	end

	return false
end

SingleWeaponUnitTemplates.templates = {
	ratlinggun = {
		shoot_start = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			-- function 2
			local num = 8

			arg_2_3.shoot_time = num
			arg_2_3.shoot_timer = num

			local flag = true
			local num_2 = 0
			local make_unit_auto_source, var_2_4 = WwiseUtils.make_unit_auto_source(arg_2_0, arg_2_1, num_2)

			if not fn(arg_2_2) then
				WwiseWorld.trigger_event(var_2_4, "Play_player_ratling_gunner_shooting_loop", flag, make_unit_auto_source)
			else
				WwiseWorld.trigger_event(var_2_4, "Play_ratling_gunner_shooting_loop", flag, make_unit_auto_source)
			end

			WwiseWorld.set_source_parameter(var_2_4, make_unit_auto_source, "ratling_gun_shooting_loop_parameter", 0)

			arg_2_3.shoot_sound_source_id = make_unit_auto_source
		end,
		destroy = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			if not arg_3_3.shoot_sound_source_id then
				local wwise_world = Managers.world:wwise_world(arg_3_0)

				if not fn(arg_3_2) then
					WwiseWorld.trigger_event(wwise_world, "Stop_player_ratling_gunner_shooting_loop", arg_3_1)
				else
					WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", arg_3_1)
				end

				arg_3_3.shoot_sound_source_id = nil
				arg_3_3.shoot_timer = nil
				arg_3_3.shoot_time = nil
			end
		end,
		shoot = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			-- function 4
			return
		end,
		shoot_end = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			-- function 5
			if not arg_5_3.shoot_sound_source_id then
				local wwise_world = Managers.world:wwise_world(arg_5_0)

				if not fn(arg_5_2) then
					WwiseWorld.trigger_event(wwise_world, "Stop_player_ratling_gunner_shooting_loop", arg_5_1)
				else
					WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", arg_5_1)
				end

				Unit.flow_event(arg_5_1, "wind_up_start")

				arg_5_3.shoot_sound_source_id = nil
				arg_5_3.shoot_timer = nil
				arg_5_3.shoot_time = nil
			end
		end,
		windup_start = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			local wwise_world = Managers.world:wwise_world(arg_6_0)

			if not fn(arg_6_2) then
				WwiseWorld.trigger_event(wwise_world, "Play_player_ratling_gunner_weapon_ready", arg_6_1)
			end

			local num = 1

			arg_6_3.windup_time = num
			arg_6_3.windup_timer = num
		end,
		windup_end = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			-- function 7
			local wwise_world = Managers.world:wwise_world(arg_7_0)

			if not fn(arg_7_2) then
				WwiseWorld.trigger_event(wwise_world, "Stop_player_ratling_gunner_weapon_ready", arg_7_1)
			end

			arg_7_3.windup_timer = nil
			arg_7_3.windup_time = nil
		end,
		update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
			-- function 8
			if not arg_8_3.shoot_timer then
				arg_8_3.shoot_timer = arg_8_3.shoot_timer - arg_8_5

				var_0_0(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			end
		end
	},
	warpfire_gun = {
		windup_start = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			-- function 9
			local flag = true
			local num = 0
			local make_unit_auto_source, var_9_3 = WwiseUtils.make_unit_auto_source(arg_9_0, arg_9_1, num)

			if not fn(arg_9_2) then
				WwiseWorld.trigger_event(var_9_3, "player_enemy_vce_warpfire_shoot_start_sequence", flag, make_unit_auto_source)
			else
				WwiseWorld.trigger_event(var_9_3, "husk_vce_warpfire_shoot_start_sequence", flag, make_unit_auto_source)
			end
		end,
		windup_end = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			-- function 10
			return
		end,
		shoot_start = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
			-- function 11
			arg_11_3.shoot_time = arg_11_4
			arg_11_3.shoot_timer = arg_11_4

			local flag = true
			local num = 0
			local make_unit_auto_source, var_11_3 = WwiseUtils.make_unit_auto_source(arg_11_0, arg_11_1, num)

			if not fn(arg_11_2) then
				WwiseWorld.trigger_event(var_11_3, "player_enemy_warpfire_thrower_shoot_start", flag, make_unit_auto_source)
			else
				WwiseWorld.trigger_event(var_11_3, "Play_enemy_warpfire_thrower_shoot", flag, make_unit_auto_source)
			end

			WwiseWorld.set_source_parameter(var_11_3, make_unit_auto_source, "ratling_gun_shooting_loop_parameter", 0)

			arg_11_3.shoot_sound_source_id = make_unit_auto_source
		end,
		destroy = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			-- function 12
			if not arg_12_3.shoot_sound_source_id then
				local wwise_world = Managers.world:wwise_world(arg_12_0)

				if not fn(arg_12_2) then
					WwiseWorld.trigger_event(wwise_world, "player_enemy_warpfire_thrower_shoot_end", arg_12_1)
				else
					WwiseWorld.trigger_event(wwise_world, "Stop_enemy_warpfire_thrower_shoot", arg_12_1)
				end

				arg_12_3.shoot_sound_source_id = nil
				arg_12_3.shoot_timer = nil
				arg_12_3.shoot_time = nil
			end
		end,
		shoot_end = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			-- function 13
			local wwise_world = Managers.world:wwise_world(arg_13_0)

			if not fn(arg_13_2) then
				WwiseWorld.trigger_event(wwise_world, "player_enemy_warpfire_thrower_shoot_end", arg_13_1)
			else
				WwiseWorld.trigger_event(wwise_world, "Stop_enemy_warpfire_thrower_shoot", arg_13_1)
			end

			Unit.flow_event(arg_13_1, "wind_up_start")

			arg_13_3.shoot_sound_source_id = nil
			arg_13_3.shoot_timer = nil
			arg_13_3.shoot_time = nil
		end,
		update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
			-- function 14
			if not arg_14_3.shoot_timer then
				arg_14_3.shoot_timer = arg_14_3.shoot_timer - arg_14_5

				var_0_0(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			end
		end
	}
}

function var_0_0(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local shoot_sound_source_id = arg_15_3.shoot_sound_source_id

	if not shoot_sound_source_id then
		local num = (arg_15_3.shoot_time - arg_15_3.shoot_timer) / arg_15_3.shoot_timer
		local wwise_world = Managers.world:wwise_world(arg_15_0)

		WwiseWorld.set_source_parameter(wwise_world, shoot_sound_source_id, "ratling_gun_shooting_loop_parameter", num)
	end
end
