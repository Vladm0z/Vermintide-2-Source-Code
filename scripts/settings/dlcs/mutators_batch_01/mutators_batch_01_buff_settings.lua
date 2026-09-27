-- chunkname: @scripts/settings/dlcs/mutators_batch_01/mutators_batch_01_buff_settings.lua

local mutators_batch_01 = DLCSettings.mutators_batch_01

mutators_batch_01.buff_templates = {
	mutator_ticking_bomb = {
		buffs = {
			{
				duration = 8,
				name = "mutator_ticking_bomb",
				remove_buff_func = "remove_ticking_bomb",
				icon = "buff_icon_mutator_ticking_bomb",
				max_stacks = 1,
				update_func = "update_ticking_bomb",
				apply_buff_func = "apply_ticking_bomb"
			}
		}
	},
	ticking_bomb_decrease_movement = {
		buffs = {
			{
				apply_buff_func = "apply_action_lerp_movement_buff",
				multiplier = 0.5,
				update_func = "update_action_lerp_movement_buff",
				name = "decrease_speed",
				remove_buff_func = "remove_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 2,
				max_stacks = 1,
				duration = 3,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	}
}
mutators_batch_01.buff_function_templates = {
	apply_ticking_bomb = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		WwiseUtils.trigger_unit_event(arg_1_3, "Play_mutator_ticking_bomb_tick", arg_1_0, 0)

		local local_player = Managers.player:local_player()

		if arg_1_0 == (not local_player and local_player.player_unit) then
			local first_person_unit = ScriptUnit.extension(arg_1_0, "first_person_system").first_person_unit
			local create_particles = World.create_particles(arg_1_3, "fx/ticking_bomb_1p_01", POSITION_LOOKUP[first_person_unit])

			World.link_particles(arg_1_3, create_particles, first_person_unit, Unit.node(first_person_unit, "root_point"), Matrix4x4.identity(), "stop")

			local wwise_world = Managers.world:wwise_world(arg_1_3)

			WwiseWorld.trigger_event(wwise_world, "Play_mutator_ticking_bomb_start")
		else
			local create_particles_2 = World.create_particles(arg_1_3, "fx/ticking_bomb_01", POSITION_LOOKUP[arg_1_0])

			World.link_particles(arg_1_3, create_particles_2, arg_1_0, Unit.node(arg_1_0, "root_point"), Matrix4x4.identity(), "stop")
		end
	end,
	update_ticking_bomb = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		return
	end,
	remove_ticking_bomb = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		if not Managers.state.network.is_server then
			local var_3_0 = POSITION_LOOKUP[arg_3_0]
			local str = "grenade_frag_01"
			local get_template = ExplosionUtils.get_template("ticking_bomb_explosion")

			if not var_3_0 then
				DamageUtils.create_explosion(arg_3_3, arg_3_0, var_3_0, Quaternion.identity(), get_template, 1, str, true, false, arg_3_0, false)

				local go_id = Managers.state.unit_storage:go_id(arg_3_0)
				local var_3_4 = NetworkLookup.explosion_templates[get_template.name]
				local var_3_5 = NetworkLookup.damage_sources[str]

				Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, var_3_0, Quaternion.identity(), var_3_4, 1, var_3_5, 0, false, go_id)
			end
		end

		local owner = Managers.player:owner(arg_3_0)

		if not (not owner and owner.remote) then
			local current_rotation = ScriptUnit.extension(arg_3_0, "first_person_system"):current_rotation()
			local flat_no_roll = Quaternion.flat_no_roll(current_rotation)
			local multiply = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.pi), flat_no_roll)
			local multiply_2 = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.random(-45, 45) * math.pi / 180), multiply)
			local forward = Quaternion.forward(multiply_2)
			local num = 12
			local num_2 = 6
			local num_3 = Vector3.normalize(forward) * num

			Vector3.set_z(num_3, num_2)
			StatusUtils.set_catapulted_network(arg_3_0, true, num_3)
		end

		WwiseUtils.trigger_unit_event(arg_3_3, "Stop_mutator_ticking_bomb_tick", arg_3_0, 0)
	end
}
