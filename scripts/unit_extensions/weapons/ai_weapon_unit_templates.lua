-- chunkname: @scripts/unit_extensions/weapons/ai_weapon_unit_templates.lua

AiWeaponUnitTemplates = {}

local update_shoot, update_windup

AiWeaponUnitTemplates.templates = {
	ratling_gun = {
		shoot_start = function (world, unit, data, shoot_time)
			-- function 1
			data.shoot_time = shoot_time
			data.shoot_timer = shoot_time

			local use_occlusion = true
			local node_id = Unit.node(unit, "rp_ratlinggun")
			local wwise_source_id, wwise_world = WwiseUtils.make_unit_auto_source(world, unit, node_id)
			local playing_id = WwiseWorld.trigger_event(wwise_world, "Play_ratling_gunner_shooting_loop", use_occlusion, wwise_source_id)

			WwiseWorld.set_source_parameter(wwise_world, wwise_source_id, "ratling_gun_shooting_loop_parameter", 0)

			data.shoot_sound_source_id = wwise_source_id
		end,
		destroy = function (world, unit, data)
			-- function 2
			if data.shoot_sound_source_id then
				local wwise_world = Managers.world:wwise_world(world)

				WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", unit)

				data.shoot_sound_source_id = nil
				data.shoot_timer = nil
				data.shoot_time = nil
			end
		end,
		shoot = function (world, unit, data)
			-- function 3
			return
		end,
		shoot_end = function (world, unit, data)
			-- function 4
			local wwise_world = Managers.world:wwise_world(world)

			WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", unit)

			data.shoot_sound_source_id = nil
			data.shoot_timer = nil
			data.shoot_time = nil
		end,
		windup_start = function (world, unit, data, windup_time)
			-- function 5
			data.windup_time = windup_time
			data.windup_timer = windup_time
		end,
		windup_end = function (world, unit, data)
			-- function 6
			data.windup_timer = nil
			data.windup_time = nil
		end,
		update = function (world, unit, data, t, dt)
			-- function 7
			if data.shoot_timer then
				data.shoot_timer = data.shoot_timer - dt

				update_shoot(world, unit, data)
			end
		end
	},
	warpfire_gun = {
		shoot_start = function (world, unit, data, shoot_time)
			-- function 8
			data.shoot_time = shoot_time
			data.shoot_timer = shoot_time

			local use_occlusion = true
			local node_id = Unit.node(unit, "rp_warpfiregun")
			local wwise_source_id, wwise_world = WwiseUtils.make_unit_auto_source(world, unit, node_id)
			local playing_id = WwiseWorld.trigger_event(wwise_world, "Play_ratling_gunner_shooting_loop", use_occlusion, wwise_source_id)

			WwiseWorld.set_source_parameter(wwise_world, wwise_source_id, "ratling_gun_shooting_loop_parameter", 0)

			data.shoot_sound_source_id = wwise_source_id
		end,
		destroy = function (world, unit, data)
			-- function 9
			if data.shoot_sound_source_id then
				local wwise_world = Managers.world:wwise_world(world)

				WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", unit)

				data.shoot_sound_source_id = nil
				data.shoot_timer = nil
				data.shoot_time = nil
			end
		end,
		shoot = function (world, unit, data)
			-- function 10
			return
		end,
		shoot_end = function (world, unit, data)
			-- function 11
			local wwise_world = Managers.world:wwise_world(world)

			WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", unit)

			data.shoot_sound_source_id = nil
			data.shoot_timer = nil
			data.shoot_time = nil
		end,
		windup_start = function (world, unit, data, windup_time)
			-- function 12
			data.windup_time = windup_time
			data.windup_timer = windup_time
		end,
		windup_end = function (world, unit, data)
			-- function 13
			data.windup_timer = nil
			data.windup_time = nil
		end,
		update = function (world, unit, data, t, dt)
			-- function 14
			if data.shoot_timer then
				data.shoot_timer = data.shoot_timer - dt

				update_shoot(world, unit, data)
			end
		end
	}
}

function update_shoot(world, unit, data)
	-- function 15
	local wwise_source_id = data.shoot_sound_source_id

	if wwise_source_id then
		local time_shooting = data.shoot_time - data.shoot_timer
		local time_shooting_percent = time_shooting / data.shoot_timer
		local wwise_world = Managers.world:wwise_world(world)

		WwiseWorld.set_source_parameter(wwise_world, wwise_source_id, "ratling_gun_shooting_loop_parameter", time_shooting_percent)
	end
end

AiWeaponUnitTemplates.get_template = function (projectile_template, is_husk)
	-- function 16
	local templates = AiWeaponUnitTemplates.templates
	local str

	if is_husk == true then
		str = "husk"

		goto label_16_0
	end

	if is_husk == false then
		str = "unit"

		goto label_16_0
	end

	str = nil

	local husk_key = str

	do
		local var_16_1
	end

	::label_16_0::

	if husk_key then
		var_16_1 = templates[projectile_template][husk_key]

		if not var_16_1 then
			-- Nothing
		end
	end

	var_16_1 = templates[projectile_template]

	local template = var_16_1

	::label_16_1::

	return template
end
