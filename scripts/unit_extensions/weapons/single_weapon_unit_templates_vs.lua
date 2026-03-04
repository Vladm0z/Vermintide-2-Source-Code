-- chunkname: @scripts/unit_extensions/weapons/single_weapon_unit_templates_vs.lua

local var_0_0

local function var_0_1(arg_1_0)
	if DEDICATED_SERVER then
		return false
	end

	local var_1_0 = Managers.player
	local var_1_1 = var_1_0:local_player()

	if var_1_0:unit_owner(arg_1_0) == var_1_1 then
		return true
	end

	return false
end

SingleWeaponUnitTemplates.templates = {
	ratlinggun = {
		shoot_start = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			local var_2_0 = 8

			arg_2_3.shoot_time = var_2_0
			arg_2_3.shoot_timer = var_2_0

			local var_2_1 = true
			local var_2_2 = 0
			local var_2_3, var_2_4 = WwiseUtils.make_unit_auto_source(arg_2_0, arg_2_1, var_2_2)

			if var_0_1(arg_2_2) then
				WwiseWorld.trigger_event(var_2_4, "Play_player_ratling_gunner_shooting_loop", var_2_1, var_2_3)
			else
				WwiseWorld.trigger_event(var_2_4, "Play_ratling_gunner_shooting_loop", var_2_1, var_2_3)
			end

			WwiseWorld.set_source_parameter(var_2_4, var_2_3, "ratling_gun_shooting_loop_parameter", 0)

			arg_2_3.shoot_sound_source_id = var_2_3
		end,
		destroy = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			if arg_3_3.shoot_sound_source_id then
				local var_3_0 = Managers.world:wwise_world(arg_3_0)

				if var_0_1(arg_3_2) then
					WwiseWorld.trigger_event(var_3_0, "Stop_player_ratling_gunner_shooting_loop", arg_3_1)
				else
					WwiseWorld.trigger_event(var_3_0, "Stop_ratling_gunner_shooting_loop", arg_3_1)
				end

				arg_3_3.shoot_sound_source_id = nil
				arg_3_3.shoot_timer = nil
				arg_3_3.shoot_time = nil
			end
		end,
		shoot = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			return
		end,
		shoot_end = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			if arg_5_3.shoot_sound_source_id then
				local var_5_0 = Managers.world:wwise_world(arg_5_0)

				if var_0_1(arg_5_2) then
					WwiseWorld.trigger_event(var_5_0, "Stop_player_ratling_gunner_shooting_loop", arg_5_1)
				else
					WwiseWorld.trigger_event(var_5_0, "Stop_ratling_gunner_shooting_loop", arg_5_1)
				end

				Unit.flow_event(arg_5_1, "wind_up_start")

				arg_5_3.shoot_sound_source_id = nil
				arg_5_3.shoot_timer = nil
				arg_5_3.shoot_time = nil
			end
		end,
		windup_start = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = Managers.world:wwise_world(arg_6_0)

			if var_0_1(arg_6_2) then
				WwiseWorld.trigger_event(var_6_0, "Play_player_ratling_gunner_weapon_ready", arg_6_1)
			end

			local var_6_1 = 1

			arg_6_3.windup_time = var_6_1
			arg_6_3.windup_timer = var_6_1
		end,
		windup_end = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			local var_7_0 = Managers.world:wwise_world(arg_7_0)

			if var_0_1(arg_7_2) then
				WwiseWorld.trigger_event(var_7_0, "Stop_player_ratling_gunner_weapon_ready", arg_7_1)
			end

			arg_7_3.windup_timer = nil
			arg_7_3.windup_time = nil
		end,
		update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
			if arg_8_3.shoot_timer then
				arg_8_3.shoot_timer = arg_8_3.shoot_timer - arg_8_5

				var_0_0(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			end
		end
	},
	warpfire_gun = {
		windup_start = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			local var_9_0 = true
			local var_9_1 = 0
			local var_9_2, var_9_3 = WwiseUtils.make_unit_auto_source(arg_9_0, arg_9_1, var_9_1)

			if var_0_1(arg_9_2) then
				WwiseWorld.trigger_event(var_9_3, "player_enemy_vce_warpfire_shoot_start_sequence", var_9_0, var_9_2)
			else
				WwiseWorld.trigger_event(var_9_3, "husk_vce_warpfire_shoot_start_sequence", var_9_0, var_9_2)
			end
		end,
		windup_end = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			return
		end,
		shoot_start = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
			arg_11_3.shoot_time = arg_11_4
			arg_11_3.shoot_timer = arg_11_4

			local var_11_0 = true
			local var_11_1 = 0
			local var_11_2, var_11_3 = WwiseUtils.make_unit_auto_source(arg_11_0, arg_11_1, var_11_1)

			if var_0_1(arg_11_2) then
				WwiseWorld.trigger_event(var_11_3, "player_enemy_warpfire_thrower_shoot_start", var_11_0, var_11_2)
			else
				WwiseWorld.trigger_event(var_11_3, "Play_enemy_warpfire_thrower_shoot", var_11_0, var_11_2)
			end

			WwiseWorld.set_source_parameter(var_11_3, var_11_2, "ratling_gun_shooting_loop_parameter", 0)

			arg_11_3.shoot_sound_source_id = var_11_2
		end,
		destroy = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			if arg_12_3.shoot_sound_source_id then
				local var_12_0 = Managers.world:wwise_world(arg_12_0)

				if var_0_1(arg_12_2) then
					WwiseWorld.trigger_event(var_12_0, "player_enemy_warpfire_thrower_shoot_end", arg_12_1)
				else
					WwiseWorld.trigger_event(var_12_0, "Stop_enemy_warpfire_thrower_shoot", arg_12_1)
				end

				arg_12_3.shoot_sound_source_id = nil
				arg_12_3.shoot_timer = nil
				arg_12_3.shoot_time = nil
			end
		end,
		shoot_end = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			local var_13_0 = Managers.world:wwise_world(arg_13_0)

			if var_0_1(arg_13_2) then
				WwiseWorld.trigger_event(var_13_0, "player_enemy_warpfire_thrower_shoot_end", arg_13_1)
			else
				WwiseWorld.trigger_event(var_13_0, "Stop_enemy_warpfire_thrower_shoot", arg_13_1)
			end

			Unit.flow_event(arg_13_1, "wind_up_start")

			arg_13_3.shoot_sound_source_id = nil
			arg_13_3.shoot_timer = nil
			arg_13_3.shoot_time = nil
		end,
		update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
			if arg_14_3.shoot_timer then
				arg_14_3.shoot_timer = arg_14_3.shoot_timer - arg_14_5

				var_0_0(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			end
		end
	}
}

function var_0_0(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_3.shoot_sound_source_id

	if var_15_0 then
		local var_15_1 = (arg_15_3.shoot_time - arg_15_3.shoot_timer) / arg_15_3.shoot_timer
		local var_15_2 = Managers.world:wwise_world(arg_15_0)

		WwiseWorld.set_source_parameter(var_15_2, var_15_0, "ratling_gun_shooting_loop_parameter", var_15_1)
	end
end
