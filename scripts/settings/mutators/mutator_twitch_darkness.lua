-- chunkname: @scripts/settings/mutators/mutator_twitch_darkness.lua

return {
	description = "description_mutator_darkness",
	display_name = "display_name_mutator_darkness",
	icon = "mutator_icon_darkness",
	server_update_function = function(arg_1_0, arg_1_1)
		local var_1_0 = Managers.state.network

		if not var_1_0 or not var_1_0:game() then
			return
		end

		local var_1_1 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

		if #var_1_1 > 0 and not arg_1_1.has_spawned_torches then
			local var_1_2

			for iter_1_0 = 1, #var_1_1 do
				if not ScriptUnit.extension(var_1_1[iter_1_0], "status_system"):is_disabled() then
					var_1_2 = var_1_1[iter_1_0]

					break
				end
			end

			var_1_2 = var_1_2 or var_1_1[1]

			local var_1_3 = Unit.world_position(var_1_2, 0) + Vector3.up()
			local var_1_4 = Quaternion.identity()
			local var_1_5 = AiAnimUtils.position_network_scale(var_1_3, true)
			local var_1_6 = AiAnimUtils.rotation_network_scale(var_1_4, true)
			local var_1_7 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
			local var_1_8 = var_1_7
			local var_1_9 = {
				pickup_system = {
					has_physics = true,
					pickup_name = "mutator_torch",
					spawn_type = "guaranteed"
				},
				projectile_locomotion_system = {
					network_position = var_1_5,
					network_rotation = var_1_6,
					network_velocity = var_1_7,
					network_angular_velocity = var_1_8
				}
			}
			local var_1_10 = "units/weapons/player/pup_torch/pup_torch"
			local var_1_11 = "pickup_torch_unit"

			Managers.state.unit_spawner:spawn_network_unit(var_1_10, var_1_11, var_1_9, var_1_3, var_1_4)

			arg_1_1.has_spawned_torches = true
		end
	end,
	client_start_function = function(arg_2_0, arg_2_1)
		local var_2_0 = Managers.world:world("level_world")

		LevelHelper:flow_event(var_2_0, "enable_twitch_darkness")

		local var_2_1 = Managers.state.entity:system("darkness_system")

		var_2_1:set_global_darkness(true)
		var_2_1:set_player_light_intensity(0.15)
	end,
	client_stop_function = function(arg_3_0, arg_3_1, arg_3_2)
		if not arg_3_2 then
			Managers.state.entity:system("darkness_system"):remove_mutator_torches()
		end

		local var_3_0 = Managers.world:world("level_world")

		if var_3_0 and not arg_3_2 then
			LevelHelper:flow_event(var_3_0, "disable_twitch_darkness")
			Managers.state.entity:system("darkness_system"):set_global_darkness(false)
		end
	end
}
