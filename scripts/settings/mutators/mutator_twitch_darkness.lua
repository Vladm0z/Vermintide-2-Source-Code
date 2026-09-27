-- chunkname: @scripts/settings/mutators/mutator_twitch_darkness.lua

return {
	description = "description_mutator_darkness",
	display_name = "display_name_mutator_darkness",
	icon = "mutator_icon_darkness",
	server_update_function = function (arg_1_0, arg_1_1)
		-- function 1
		local network = Managers.state.network

		if not (not network and network:game()) then
			return
		end

		local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

		if not (not (#PLAYER_UNITS > 0) or arg_1_1.has_spawned_torches) then
			local var_1_2

			for i = 1, #PLAYER_UNITS do
				if not ScriptUnit.extension(PLAYER_UNITS[i], "status_system"):is_disabled() then
					var_1_2 = PLAYER_UNITS[i]

					break
				end
			end

			var_1_2 = var_1_2 or PLAYER_UNITS[1]

			local num = Unit.world_position(var_1_2, 0) + Vector3.up()
			local identity = Quaternion.identity()
			local position_network_scale = AiAnimUtils.position_network_scale(num, true)
			local rotation_network_scale = AiAnimUtils.rotation_network_scale(identity, true)
			local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
			local var_1_8 = velocity_network_scale
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
					network_angular_velocity = var_1_8
				}
			}
			local str = "units/weapons/player/pup_torch/pup_torch"
			local str_2 = "pickup_torch_unit"

			Managers.state.unit_spawner:spawn_network_unit(str, str_2, tbl, num, identity)

			arg_1_1.has_spawned_torches = true
		end
	end,
	client_start_function = function (arg_2_0, arg_2_1)
		-- function 2
		local world = Managers.world:world("level_world")

		LevelHelper:flow_event(world, "enable_twitch_darkness")

		local system = Managers.state.entity:system("darkness_system")

		system:set_global_darkness(true)
		system:set_player_light_intensity(0.15)
	end,
	client_stop_function = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		if not arg_3_2 then
			Managers.state.entity:system("darkness_system"):remove_mutator_torches()
		end

		local world = Managers.world:world("level_world")

		if not (not world and arg_3_2) then
			LevelHelper:flow_event(world, "disable_twitch_darkness")
			Managers.state.entity:system("darkness_system"):set_global_darkness(false)
		end
	end
}
