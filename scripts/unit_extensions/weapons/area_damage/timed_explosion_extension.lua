-- chunkname: @scripts/unit_extensions/weapons/area_damage/timed_explosion_extension.lua

TimedExplosionExtension = class(TimedExplosionExtension)

TimedExplosionExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._on_explode_callbacks = {}
	arg_1_0._area_damage_system = arg_1_1.entity_manager:system("area_damage_system")
	arg_1_0.explosion_template_name = arg_1_3.explosion_template_name

	local var_1_0 = ExplosionUtils.get_template(arg_1_3.explosion_template_name)
	local var_1_1 = Managers.state.difficulty:get_difficulty()
	local var_1_2 = Managers.weave:get_active_wind()

	if var_1_2 and WindSettings[var_1_2].timed_explosion_extension_settings then
		local var_1_3 = Managers.weave:get_active_wind_settings()
		local var_1_4 = Managers.weave:get_wind_strength()
		local var_1_5 = var_1_3.timed_explosion_extension_settings

		arg_1_0._time_to_explode = var_1_5.time_to_explode[var_1_1][var_1_4]
		arg_1_0._follow_time = var_1_5.follow_time and var_1_5.follow_time[var_1_1][var_1_4]
		arg_1_0._scale = var_1_3.radius and var_1_3.radius[var_1_1][var_1_4] or 1
		arg_1_0._power = var_1_3.power_level and var_1_3.power_level[var_1_1][var_1_4] or 0
		arg_1_0._buildup_effect_delay = arg_1_0._time_to_explode + arg_1_0._follow_time - (var_1_0.explosion.buildup_effect_time or 0)
	else
		arg_1_0._time_to_explode = var_1_0.time_to_explode or 0
		arg_1_0._scale = var_1_0.explosion.unit_scale or var_1_0.explosion.radius or 1
		arg_1_0._follow_time = var_1_0.follow_time or 0
		arg_1_0._power = var_1_0.explosion.power_level or 0
		arg_1_0._buildup_effect_delay = arg_1_0._time_to_explode + arg_1_0._follow_time - (var_1_0.explosion.buildup_effect_time or 0)
	end

	arg_1_0._buildup_effect_offset = var_1_0.explosion.buildup_effect_offset
	arg_1_0._buildup_effect = var_1_0.explosion.buildup_effect_name
	arg_1_0._use_effect = arg_1_0._buildup_effect ~= nil
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.follow_unit = arg_1_3.follow_unit
	arg_1_0.trigger_on_server_only = var_1_0.explosion.trigger_on_server_only

	if arg_1_0._scale then
		Unit.set_local_scale(arg_1_2, 0, Vector3(arg_1_0._scale * 1.25, arg_1_0._scale * 1.25, arg_1_0._scale * 1.25))
	end

	if arg_1_0.follow_unit then
		arg_1_0._state = "follow_unit"
	else
		arg_1_0._state = "waiting_to_explode"
	end

	arg_1_0._deletion_timer = var_1_0.explosion.deletion_timer or 1
end

TimedExplosionExtension.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_0._state

	if arg_2_0._buildup_effect then
		arg_2_0._buildup_effect_delay = math.max(arg_2_0._buildup_effect_delay - arg_2_3, 0)

		if arg_2_0._buildup_effect_delay <= 0 and arg_2_0._use_effect then
			arg_2_0._use_effect = false

			local var_2_1 = Vector3.copy(POSITION_LOOKUP[arg_2_1])

			if arg_2_0._buildup_effect_offset then
				local var_2_2 = Vector3(unpack(arg_2_0._buildup_effect_offset))

				var_2_1.x = var_2_1.x + var_2_2.x
				var_2_1.y = var_2_1.y + var_2_2.y
				var_2_1.z = var_2_1.z + var_2_2.z
			end

			arg_2_0._fx_id = World.create_particles(arg_2_4.world, arg_2_0._buildup_effect, var_2_1)
		end
	end

	if var_2_0 == "waiting_to_explode" then
		arg_2_0._time_to_explode = math.max(arg_2_0._time_to_explode - arg_2_3, 0)

		if arg_2_0._time_to_explode == 0 and (arg_2_0.is_server or not arg_2_0.trigger_on_server_only) then
			arg_2_0:_explode()
		end
	elseif var_2_0 == "follow_unit" then
		if Unit.alive(arg_2_0.follow_unit) then
			arg_2_0._follow_time = math.max(arg_2_0._follow_time - arg_2_3, 0)

			local var_2_3 = Unit.local_position(arg_2_0.follow_unit, 0)

			Unit.set_local_position(arg_2_1, 0, var_2_3)

			if arg_2_0._follow_time == 0 then
				Unit.flow_event(arg_2_1, "disable_rotation")

				arg_2_0._state = "waiting_to_explode"
			end
		else
			arg_2_0._state = "waiting_to_explode"
		end
	elseif var_2_0 == "exploded" then
		arg_2_0._deletion_timer = math.max(arg_2_0._deletion_timer - arg_2_3, 0)

		if arg_2_0._deletion_timer == 0 then
			Managers.state.side:remove_unit_from_side(arg_2_1)
			Managers.state.unit_spawner:mark_for_deletion(arg_2_1)

			if arg_2_0._buildup_effect and arg_2_0._fx_id then
				World.destroy_particles(arg_2_4.world, arg_2_0._fx_id)
			end

			arg_2_0._state = "waiting_for_deletion"
		end
	elseif var_2_0 == "waiting_for_deletion" then
		-- Nothing
	else
		ferror("Unknown state (%s)", var_2_0)
	end
end

TimedExplosionExtension._explode = function (arg_3_0)
	local var_3_0 = ExplosionUtils.get_template(arg_3_0.explosion_template_name)
	local var_3_1 = arg_3_0._unit
	local var_3_2 = Unit.world_position(var_3_1, 0)
	local var_3_3 = Unit.world_rotation(var_3_1, 0)
	local var_3_4 = arg_3_0.explosion_template_name
	local var_3_5 = 1
	local var_3_6 = var_3_0.damage_source or "undefined"
	local var_3_7 = arg_3_0._power

	arg_3_0._state = "exploded"

	arg_3_0._area_damage_system:create_explosion(var_3_1, var_3_2, var_3_3, var_3_4, var_3_5, var_3_6, var_3_7, false)
	arg_3_0:_invoke_on_explode_callbacks()
end

TimedExplosionExtension._invoke_on_explode_callbacks = function (arg_4_0)
	local var_4_0 = POSITION_LOOKUP[arg_4_0._unit]

	for iter_4_0, iter_4_1 in ipairs(arg_4_0._on_explode_callbacks) do
		iter_4_1(arg_4_0.explosion_template_name, var_4_0)
	end

	arg_4_0._on_explode_callbacks = nil
end

TimedExplosionExtension.add_on_explode_callback = function (arg_5_0, arg_5_1)
	if arg_5_1 ~= nil then
		table.insert(arg_5_0._on_explode_callbacks, arg_5_1)
	end
end
