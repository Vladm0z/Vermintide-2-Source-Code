-- chunkname: @scripts/settings/mutators/mutator_darkness.lua

return {
	description = "description_mutator_darkness",
	display_name = "display_name_mutator_darkness",
	disable_environment_variations = true,
	icon = "mutator_icon_darkness",
	server_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		arg_1_1.tick_interval = 0.1
		arg_1_1.next_tick = 0
	end,
	server_update_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		if arg_2_3 < arg_2_1.next_tick then
			return
		else
			arg_2_1.next_tick = arg_2_3 + arg_2_1.tick_interval
		end

		local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
		local count = #PLAYER_UNITS

		if count == 0 then
			return
		elseif not arg_2_1.players_spawned then
			arg_2_1.tick_interval = 5
			arg_2_1.players_spawned = true
		end

		local get_pickups_by_type = Managers.state.entity:system("pickup_system"):get_pickups_by_type("mutator_torch")

		if not table.is_empty(get_pickups_by_type) then
			arg_2_1.should_spawn_torch = false

			return
		end

		for i = 1, count do
			local has_extension = ScriptUnit.has_extension(PLAYER_UNITS[i], "inventory_system")

			if not (not has_extension and has_extension:has_inventory_item("slot_level_event", "mutator_torch")) then
				arg_2_1.should_spawn_torch = false

				return
			end
		end

		if not arg_2_1.should_spawn_torch then
			arg_2_1.should_spawn_torch = true

			return
		end

		local random = math.random(count)
		local var_2_5
		local var_2_6
		local var_2_7

		for j = 1, count do
			var_2_6 = PLAYER_UNITS[math.index_wrapper(random + 47 * j, count)]

			if not ScriptUnit.extension(var_2_6, "status_system"):is_disabled() then
				break
			end
		end

		local num = Unit.world_position(var_2_6, 0) + Vector3.up()
		local identity = Quaternion.identity()
		local position_network_scale = AiAnimUtils.position_network_scale(num, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(identity, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_2_13 = velocity_network_scale
		local tbl = {
			pickup_system = {
				has_physics = true,
				pickup_name = "mutator_torch",
				spawn_type = "guaranteed"
			},
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_2_13
			}
		}
		local str = "units/weapons/player/pup_torch/pup_torch"
		local str_2 = "pickup_torch_unit"

		Managers.state.unit_spawner:spawn_network_unit(str, str_2, tbl, num, identity)

		arg_2_1.should_spawn_torch = false
	end,
	client_start_function = function (arg_3_0, arg_3_1)
		-- function 3
		local world = Managers.world:world("level_world")

		LevelHelper:flow_event(world, "mutator_darkness")

		local system = Managers.state.entity:system("darkness_system")

		system:set_global_darkness(true)
		system:set_player_light_intensity(0.15)

		if not LevelHelper:current_level_settings().camera_backlight then
			local camera_follow_unit = Managers.player:local_player().camera_follow_unit
			local light = Unit.light(camera_follow_unit, "light")

			if not light then
				local tbl = {
					intensity = 0.015,
					start_falloff = 0,
					end_falloff = 5,
					color = Vector3(0.9, 0.7, 0.6)
				}

				Light.set_color(light, tbl.color)
				Light.set_intensity(light, tbl.intensity)
				Light.set_falloff_start(light, tbl.start_falloff)
				Light.set_falloff_end(light, tbl.end_falloff)
			end
		end
	end,
	client_stop_function = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		local world = Managers.world:world("level_world")

		if not arg_4_2 then
			LevelHelper:flow_event(world, "disable_darkness")
			Managers.state.entity:system("darkness_system"):set_global_darkness(false)
		end
	end
}
