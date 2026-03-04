-- chunkname: @scripts/settings/mutators/mutator_darkness.lua

return {
	description = "description_mutator_darkness",
	display_name = "display_name_mutator_darkness",
	disable_environment_variations = true,
	icon = "mutator_icon_darkness",
	server_start_function = function(arg_1_0, arg_1_1)
		arg_1_1.tick_interval = 0.1
		arg_1_1.next_tick = 0
	end,
	server_update_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		if arg_2_3 < arg_2_1.next_tick then
			return
		else
			arg_2_1.next_tick = arg_2_3 + arg_2_1.tick_interval
		end

		local var_2_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
		local var_2_1 = #var_2_0

		if var_2_1 == 0 then
			return
		elseif not arg_2_1.players_spawned then
			arg_2_1.tick_interval = 5
			arg_2_1.players_spawned = true
		end

		local var_2_2 = Managers.state.entity:system("pickup_system"):get_pickups_by_type("mutator_torch")

		if not table.is_empty(var_2_2) then
			arg_2_1.should_spawn_torch = false

			return
		end

		for iter_2_0 = 1, var_2_1 do
			local var_2_3 = ScriptUnit.has_extension(var_2_0[iter_2_0], "inventory_system")

			if var_2_3 and var_2_3:has_inventory_item("slot_level_event", "mutator_torch") then
				arg_2_1.should_spawn_torch = false

				return
			end
		end

		if not arg_2_1.should_spawn_torch then
			arg_2_1.should_spawn_torch = true

			return
		end

		local var_2_4 = math.random(var_2_1)
		local var_2_5
		local var_2_6
		local var_2_7

		for iter_2_1 = 1, var_2_1 do
			var_2_6 = var_2_0[math.index_wrapper(var_2_4 + 47 * iter_2_1, var_2_1)]

			if not ScriptUnit.extension(var_2_6, "status_system"):is_disabled() then
				break
			end
		end

		local var_2_8 = Unit.world_position(var_2_6, 0) + Vector3.up()
		local var_2_9 = Quaternion.identity()
		local var_2_10 = AiAnimUtils.position_network_scale(var_2_8, true)
		local var_2_11 = AiAnimUtils.rotation_network_scale(var_2_9, true)
		local var_2_12 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_2_13 = var_2_12
		local var_2_14 = {
			pickup_system = {
				has_physics = true,
				pickup_name = "mutator_torch",
				spawn_type = "guaranteed"
			},
			projectile_locomotion_system = {
				network_position = var_2_10,
				network_rotation = var_2_11,
				network_velocity = var_2_12,
				network_angular_velocity = var_2_13
			}
		}
		local var_2_15 = "units/weapons/player/pup_torch/pup_torch"
		local var_2_16 = "pickup_torch_unit"

		Managers.state.unit_spawner:spawn_network_unit(var_2_15, var_2_16, var_2_14, var_2_8, var_2_9)

		arg_2_1.should_spawn_torch = false
	end,
	client_start_function = function(arg_3_0, arg_3_1)
		local var_3_0 = Managers.world:world("level_world")

		LevelHelper:flow_event(var_3_0, "mutator_darkness")

		local var_3_1 = Managers.state.entity:system("darkness_system")

		var_3_1:set_global_darkness(true)
		var_3_1:set_player_light_intensity(0.15)

		if not LevelHelper:current_level_settings().camera_backlight then
			local var_3_2 = Managers.player:local_player().camera_follow_unit
			local var_3_3 = Unit.light(var_3_2, "light")

			if var_3_3 then
				local var_3_4 = {
					intensity = 0.015,
					start_falloff = 0,
					end_falloff = 5,
					color = Vector3(0.9, 0.7, 0.6)
				}

				Light.set_color(var_3_3, var_3_4.color)
				Light.set_intensity(var_3_3, var_3_4.intensity)
				Light.set_falloff_start(var_3_3, var_3_4.start_falloff)
				Light.set_falloff_end(var_3_3, var_3_4.end_falloff)
			end
		end
	end,
	client_stop_function = function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = Managers.world:world("level_world")

		if not arg_4_2 then
			LevelHelper:flow_event(var_4_0, "disable_darkness")
			Managers.state.entity:system("darkness_system"):set_global_darkness(false)
		end
	end
}
