-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_troll_downed_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTrollDownedAction = class(BTTrollDownedAction, BTNode)
BTTrollDownedAction.name = "BTTrollDownedAction"

local var_0_0 = script_data

function BTTrollDownedAction.init(arg_1_0, ...)
	BTTrollDownedAction.super.init(arg_1_0, ...)
end

function BTTrollDownedAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	Managers.state.network:anim_event(arg_2_1, "downed_intro")
	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_2_1, "enemy_attack", DialogueSettings.troll_incapacitaded_broadcast_range, "attack_tag", "troll_incapacitaded")

	arg_2_2.downed_end_time = arg_2_3 + AiUtils.downed_duration(var_2_0)
	arg_2_2.minimum_downed_end_time = arg_2_3 + var_2_0.min_downed_duration

	local var_2_1 = ScriptUnit.extension(arg_2_1, "health_system")

	arg_2_2.downed_end_finished = false
	arg_2_2.downed_state = "downed"

	arg_2_0:trigger_dialogue_event(arg_2_1, "chaos_troll_incapacitaded")
	arg_2_0:effects_on_downed(arg_2_1, arg_2_2, arg_2_3)

	arg_2_2.num_regen = arg_2_2.num_regen and arg_2_2.num_regen + 1 or 1

	if var_2_0.rage_buff_on_wounded and var_2_0.remove_leaving_buff_on_enter then
		local var_2_2 = ScriptUnit.extension(arg_2_1, "buff_system")
		local var_2_3 = var_2_2:get_buff_type(var_2_0.rage_buff_on_wounded)

		if var_2_3 then
			var_2_2:remove_buff(var_2_3.id)
		end
	end

	if var_2_0.downed_buff then
		arg_2_2.downed_buff = Managers.state.entity:system("buff_system"):add_buff(arg_2_1, var_2_0.downed_buff, arg_2_1, true)
	end
end

function BTTrollDownedAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	BTStaggerAction.clean_blackboard(nil, arg_3_2)
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.downed_end_finished = false
	arg_3_2.downed_state = false
	arg_3_2.waiting_for_rage_anim_cb = false
	arg_3_2.anim_cb_roar_begin = false
	arg_3_2.anim_cb_roar_end = false

	if HEALTH_ALIVE[arg_3_1] and arg_3_2.downed_buff then
		Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_3_1, arg_3_2.downed_buff)

		arg_3_2.downed_buff = nil
	end
end

function BTTrollDownedAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.action
	local var_4_1 = ScriptUnit.extension(arg_4_1, "health_system")

	if arg_4_2.downed_state == "downed" then
		if arg_4_3 > arg_4_2.downed_end_time then
			if var_4_0.buff_during_stand_up then
				arg_4_2.buff_during_stand_up = ScriptUnit.extension(arg_4_1, "buff_system"):add_buff(var_4_0.buff_during_stand_up)
			end

			Managers.state.network:anim_event(arg_4_1, var_4_0.rise_anim or "downed_end")
			arg_4_0:trigger_dialogue_event(arg_4_1, "chaos_troll_rising_regen")

			arg_4_2.downed_state = "standup"
		elseif arg_4_3 > arg_4_2.minimum_downed_end_time and var_4_1:min_health_reached() then
			if var_4_0.buff_during_stand_up then
				arg_4_2.buff_during_stand_up = ScriptUnit.extension(arg_4_1, "buff_system"):add_buff(var_4_0.buff_during_stand_up)
			end

			Managers.state.network:anim_event(arg_4_1, var_4_0.rise_anim_wounded or "downed_end_wounded")
			arg_4_0:trigger_dialogue_event(arg_4_1, "chaos_troll_rising_interrupted")

			arg_4_2.downed_state = "standup"
		end
	else
		if var_4_0.rage_buff_on_wounded and arg_4_2.anim_cb_roar_begin then
			arg_4_0:rage(arg_4_1, arg_4_2, arg_4_3)
		end

		if arg_4_2.downed_end_finished then
			if not arg_4_2.waiting_for_rage_anim_cb then
				local var_4_2 = var_4_0.rage_event

				if var_4_2 then
					arg_4_2.waiting_for_rage_anim_cb = true

					Managers.state.network:anim_event(arg_4_1, var_4_2)
				end
			end

			if not arg_4_2.waiting_for_rage_anim_cb or arg_4_2.rage_end_finished then
				if arg_4_2.buff_during_stand_up then
					ScriptUnit.extension(arg_4_1, "buff_system"):remove_buff(arg_4_2.buff_during_stand_up)

					arg_4_2.buff_during_stand_up = nil
				end

				var_4_1:set_downed_finished()

				return "done"
			end
		end
	end

	return "running"
end

function BTTrollDownedAction.trigger_dialogue_event(arg_5_0, arg_5_1, arg_5_2)
	ScriptUnit.extension_input(arg_5_1, "dialogue_system"):trigger_networked_dialogue_event(arg_5_2)
end

function BTTrollDownedAction.effects_on_downed(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_2.action.puke_on_downed then
		local var_6_0 = Unit.local_position(arg_6_1, 0)
		local var_6_1 = Managers.state.entity:system("ai_system"):nav_world()
		local var_6_2 = LocomotionUtils.get_close_pos_below_on_mesh(var_6_1, var_6_0)
		local var_6_3 = Unit.local_rotation(arg_6_1, 0)
		local var_6_4 = Quaternion.forward(var_6_3)
		local var_6_5 = Vector3.flat(var_6_4)

		if var_6_2 then
			local var_6_6 = {
				area_damage_system = {
					liquid_template = "bile_troll_chief_downed_vomit",
					flow_dir = var_6_5,
					source_unit = arg_6_1
				}
			}
			local var_6_7 = "units/hub_elements/empty"
			local var_6_8 = Managers.state.unit_spawner:spawn_network_unit(var_6_7, "liquid_aoe_unit", var_6_6, var_6_2)

			ScriptUnit.extension(var_6_8, "area_damage_system"):ready()
		end
	end
end

function BTTrollDownedAction.rage(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_2.anim_cb_roar_begin = false

	local var_7_0 = arg_7_2.action

	Managers.state.entity:system("buff_system"):add_buff_synced(arg_7_1, var_7_0.rage_buff_on_wounded, BuffSyncType.All)

	if var_7_0.rage_explosion_template then
		local var_7_1 = arg_7_2.world
		local var_7_2 = Unit.local_position(arg_7_1, 0) + Vector3.up()
		local var_7_3 = ExplosionUtils.get_template(var_7_0.rage_explosion_template)
		local var_7_4 = 1
		local var_7_5 = arg_7_2.breed.name

		DamageUtils.create_explosion(var_7_1, arg_7_1, var_7_2, Quaternion.identity(), var_7_3, var_7_4, var_7_5, true, false, arg_7_1, 0, false)

		local var_7_6 = Managers.state.unit_storage:go_id(arg_7_1)
		local var_7_7 = NetworkLookup.explosion_templates[var_7_3.name]
		local var_7_8 = NetworkLookup.damage_sources[var_7_5]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_7_6, false, var_7_2, Quaternion.identity(), var_7_7, 1, var_7_8, 0, false, var_7_6)
	end
end
