-- chunkname: @scripts/unit_extensions/weapons/area_damage/proximity_mine_extension.lua

ProximityMineExtension = class(ProximityMineExtension)

function ProximityMineExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.arm_time = arg_1_3.arm_time or 0
	arg_1_0.detonation_time = arg_1_3.detonation_time or 0
	arg_1_0.range = arg_1_3.range or 1
	arg_1_0.catapult_strength = arg_1_3.catapult_strength or 1
	arg_1_0.explosion_template = arg_1_3.explosion_template
	arg_1_0.owner_unit = arg_1_3.owner_unit
	arg_1_0.detonating_sound_event = arg_1_3.detonating_sound_event
	arg_1_0.armed_sound_event = arg_1_3.armed_sound_event
	arg_1_0.hero_side = Managers.state.side:get_side_from_name("heroes")
	arg_1_0.audio_system = Managers.state.entity:system("audio_system")
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._armed = false
	arg_1_0._detonating = false
	arg_1_0._unit = arg_1_2

	arg_1_0:enable(true)
end

function ProximityMineExtension.destroy(arg_2_0)
	return
end

function ProximityMineExtension.enable(arg_3_0, arg_3_1)
	arg_3_0._arm_timer = arg_3_0.arm_time
end

function ProximityMineExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if not arg_4_0._is_server or not HEALTH_ALIVE[arg_4_1] then
		return
	end

	local var_4_0 = arg_4_0._arm_timer

	if var_4_0 then
		local var_4_1 = var_4_0 - arg_4_3

		if var_4_1 <= 0 then
			if arg_4_0.armed_sound_event then
				arg_4_0.audio_system:play_audio_unit_event(arg_4_0.armed_sound_event, arg_4_1)
			end

			arg_4_0._arm_timer = nil
			arg_4_0._armed = true
		else
			arg_4_0._arm_timer = var_4_1
		end
	end

	if arg_4_0._armed then
		local var_4_2 = arg_4_0.hero_side.PLAYER_AND_BOT_UNITS
		local var_4_3 = Unit.local_position(arg_4_1, 0)

		for iter_4_0 = 1, #var_4_2 do
			local var_4_4 = var_4_2[iter_4_0]

			if ALIVE[var_4_4] then
				local var_4_5 = POSITION_LOOKUP[var_4_4]
				local var_4_6 = Vector3.distance_squared(var_4_3, var_4_5)
				local var_4_7 = arg_4_0.range

				if var_4_6 <= var_4_7 * var_4_7 then
					if arg_4_0.detonating_sound_event then
						arg_4_0.audio_system:play_audio_unit_event(arg_4_0.detonating_sound_event, arg_4_1)
					end

					arg_4_0._armed = false
					arg_4_0._detonating = true
					arg_4_0._detonation_timer = arg_4_0.detonation_time
				end
			end
		end
	end

	local var_4_8 = arg_4_0._detonation_timer

	if var_4_8 then
		local var_4_9 = var_4_8 - arg_4_3

		if var_4_9 <= 0 then
			local var_4_10 = Managers.state.entity:system("area_damage_system")
			local var_4_11 = Unit.local_position(arg_4_1, 0)
			local var_4_12 = 100

			var_4_10:create_explosion(arg_4_1, var_4_11, Quaternion.identity(), arg_4_0.explosion_template, 1, "undefined", var_4_12, false, arg_4_0.owner_unit)
			AiUtils.kill_unit(arg_4_1)

			arg_4_0._detonating = false
			arg_4_0._detonation_timer = nil
		else
			arg_4_0._detonation_timer = var_4_9
		end
	end
end

function ProximityMineExtension.hot_join_sync(arg_5_0, arg_5_1)
	return
end
