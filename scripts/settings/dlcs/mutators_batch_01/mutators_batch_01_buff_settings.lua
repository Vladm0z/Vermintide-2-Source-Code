-- chunkname: @scripts/settings/dlcs/mutators_batch_01/mutators_batch_01_buff_settings.lua

local var_0_0 = DLCSettings.mutators_batch_01

var_0_0.buff_templates = {
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
var_0_0.buff_function_templates = {
	apply_ticking_bomb = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		WwiseUtils.trigger_unit_event(arg_1_3, "Play_mutator_ticking_bomb_tick", arg_1_0, 0)

		local var_1_0 = Managers.player:local_player()

		if arg_1_0 == (var_1_0 and var_1_0.player_unit) then
			local var_1_1 = ScriptUnit.extension(arg_1_0, "first_person_system").first_person_unit
			local var_1_2 = World.create_particles(arg_1_3, "fx/ticking_bomb_1p_01", POSITION_LOOKUP[var_1_1])

			World.link_particles(arg_1_3, var_1_2, var_1_1, Unit.node(var_1_1, "root_point"), Matrix4x4.identity(), "stop")

			local var_1_3 = Managers.world:wwise_world(arg_1_3)

			WwiseWorld.trigger_event(var_1_3, "Play_mutator_ticking_bomb_start")
		else
			local var_1_4 = World.create_particles(arg_1_3, "fx/ticking_bomb_01", POSITION_LOOKUP[arg_1_0])

			World.link_particles(arg_1_3, var_1_4, arg_1_0, Unit.node(arg_1_0, "root_point"), Matrix4x4.identity(), "stop")
		end
	end,
	update_ticking_bomb = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		return
	end,
	remove_ticking_bomb = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if Managers.state.network.is_server then
			local var_3_0 = POSITION_LOOKUP[arg_3_0]
			local var_3_1 = "grenade_frag_01"
			local var_3_2 = ExplosionUtils.get_template("ticking_bomb_explosion")

			if var_3_0 then
				DamageUtils.create_explosion(arg_3_3, arg_3_0, var_3_0, Quaternion.identity(), var_3_2, 1, var_3_1, true, false, arg_3_0, false)

				local var_3_3 = Managers.state.unit_storage:go_id(arg_3_0)
				local var_3_4 = NetworkLookup.explosion_templates[var_3_2.name]
				local var_3_5 = NetworkLookup.damage_sources[var_3_1]

				Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_3_3, false, var_3_0, Quaternion.identity(), var_3_4, 1, var_3_5, 0, false, var_3_3)
			end
		end

		local var_3_6 = Managers.player:owner(arg_3_0)

		if var_3_6 and not var_3_6.remote then
			local var_3_7 = ScriptUnit.extension(arg_3_0, "first_person_system"):current_rotation()
			local var_3_8 = Quaternion.flat_no_roll(var_3_7)
			local var_3_9 = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.pi), var_3_8)
			local var_3_10 = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.random(-45, 45) * math.pi / 180), var_3_9)
			local var_3_11 = Quaternion.forward(var_3_10)
			local var_3_12 = 12
			local var_3_13 = 6
			local var_3_14 = Vector3.normalize(var_3_11) * var_3_12

			Vector3.set_z(var_3_14, var_3_13)
			StatusUtils.set_catapulted_network(arg_3_0, true, var_3_14)
		end

		WwiseUtils.trigger_unit_event(arg_3_3, "Stop_mutator_ticking_bomb_tick", arg_3_0, 0)
	end
}
