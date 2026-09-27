-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_troll_downed_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTrollDownedAction = class(BTTrollDownedAction, BTNode)
BTTrollDownedAction.name = "BTTrollDownedAction"

local script_data = script_data

BTTrollDownedAction.init = function (arg_1_0, ...)
	-- function 1
	BTTrollDownedAction.super.init(arg_1_0, ...)
end

BTTrollDownedAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	Managers.state.network:anim_event(arg_2_1, "downed_intro")
	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_2_1, "enemy_attack", DialogueSettings.troll_incapacitaded_broadcast_range, "attack_tag", "troll_incapacitaded")

	arg_2_2.downed_end_time = arg_2_3 + AiUtils.downed_duration(action_data)
	arg_2_2.minimum_downed_end_time = arg_2_3 + action_data.min_downed_duration

	local extension = ScriptUnit.extension(arg_2_1, "health_system")

	arg_2_2.downed_end_finished = false
	arg_2_2.downed_state = "downed"

	self:trigger_dialogue_event(arg_2_1, "chaos_troll_incapacitaded")
	self:effects_on_downed(arg_2_1, arg_2_2, arg_2_3)

	local num

	if not arg_2_2.num_regen then
		num = arg_2_2.num_regen + 1

		if not num then
			-- Nothing
		end
	end

	num = 1

	::label_2_0::

	arg_2_2.num_regen = num

	if not action_data.rage_buff_on_wounded and not action_data.remove_leaving_buff_on_enter then
		local extension_2 = ScriptUnit.extension(arg_2_1, "buff_system")
		local get_buff_type = extension_2:get_buff_type(action_data.rage_buff_on_wounded)

		if not get_buff_type then
			extension_2:remove_buff(get_buff_type.id)
		end
	end

	if not action_data.downed_buff then
		arg_2_2.downed_buff = Managers.state.entity:system("buff_system"):add_buff(arg_2_1, action_data.downed_buff, arg_2_1, true)
	end
end

BTTrollDownedAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	BTStaggerAction.clean_blackboard(nil, arg_3_2)
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.downed_end_finished = false
	arg_3_2.downed_state = false
	arg_3_2.waiting_for_rage_anim_cb = false
	arg_3_2.anim_cb_roar_begin = false
	arg_3_2.anim_cb_roar_end = false

	if not HEALTH_ALIVE[arg_3_1] and not arg_3_2.downed_buff then
		Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_3_1, arg_3_2.downed_buff)

		arg_3_2.downed_buff = nil
	end
end

BTTrollDownedAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local action = arg_4_2.action
	local extension = ScriptUnit.extension(arg_4_1, "health_system")

	if arg_4_2.downed_state == "downed" then
		if arg_4_3 > arg_4_2.downed_end_time then
			if not action.buff_during_stand_up then
				arg_4_2.buff_during_stand_up = ScriptUnit.extension(arg_4_1, "buff_system"):add_buff(action.buff_during_stand_up)
			end

			local network = Managers.state.network
			local var_4_3 = network
			local anim_event = network.anim_event
			local var_4_5 = arg_4_1
			local rise_anim = action.rise_anim

			rise_anim = rise_anim or "downed_end"

			anim_event(var_4_3, var_4_5, rise_anim)
			self:trigger_dialogue_event(arg_4_1, "chaos_troll_rising_regen")

			arg_4_2.downed_state = "standup"
		elseif not (arg_4_3 > arg_4_2.minimum_downed_end_time) or not extension:min_health_reached() then
			if not action.buff_during_stand_up then
				arg_4_2.buff_during_stand_up = ScriptUnit.extension(arg_4_1, "buff_system"):add_buff(action.buff_during_stand_up)
			end

			local network_2 = Managers.state.network
			local var_4_8 = network_2
			local anim_event_2 = network_2.anim_event
			local var_4_10 = arg_4_1
			local rise_anim_wounded = action.rise_anim_wounded

			rise_anim_wounded = rise_anim_wounded or "downed_end_wounded"

			anim_event_2(var_4_8, var_4_10, rise_anim_wounded)
			self:trigger_dialogue_event(arg_4_1, "chaos_troll_rising_interrupted")

			arg_4_2.downed_state = "standup"
		end
	else
		if not action.rage_buff_on_wounded and not arg_4_2.anim_cb_roar_begin then
			self:rage(arg_4_1, arg_4_2, arg_4_3)
		end

		if not arg_4_2.downed_end_finished then
			if not arg_4_2.waiting_for_rage_anim_cb then
				local rage_event = action.rage_event

				if not rage_event then
					arg_4_2.waiting_for_rage_anim_cb = true

					Managers.state.network:anim_event(arg_4_1, rage_event)
				end
			end

			if not arg_4_2.waiting_for_rage_anim_cb and not arg_4_2.rage_end_finished then
				if not arg_4_2.buff_during_stand_up then
					ScriptUnit.extension(arg_4_1, "buff_system"):remove_buff(arg_4_2.buff_during_stand_up)

					arg_4_2.buff_during_stand_up = nil
				end

				extension:set_downed_finished()

				return "done"
			end
		end
	end

	return "running"
end

BTTrollDownedAction.trigger_dialogue_event = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	ScriptUnit.extension_input(arg_5_1, "dialogue_system"):trigger_networked_dialogue_event(arg_5_2)
end

BTTrollDownedAction.effects_on_downed = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not arg_6_2.action.puke_on_downed then
		local local_position = Unit.local_position(arg_6_1, 0)
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local get_close_pos_below_on_mesh = LocomotionUtils.get_close_pos_below_on_mesh(nav_world, local_position)
		local local_rotation = Unit.local_rotation(arg_6_1, 0)
		local forward = Quaternion.forward(local_rotation)
		local flat = Vector3.flat(forward)

		if not get_close_pos_below_on_mesh then
			local tbl = {
				area_damage_system = {
					liquid_template = "bile_troll_chief_downed_vomit",
					flow_dir = flat,
					source_unit = arg_6_1
				}
			}
			local str = "units/hub_elements/empty"
			local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, get_close_pos_below_on_mesh)

			ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
		end
	end
end

BTTrollDownedAction.rage = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	arg_7_2.anim_cb_roar_begin = false

	local action = arg_7_2.action

	Managers.state.entity:system("buff_system"):add_buff_synced(arg_7_1, action.rage_buff_on_wounded, BuffSyncType.All)

	if not action.rage_explosion_template then
		local world = arg_7_2.world
		local num = Unit.local_position(arg_7_1, 0) + Vector3.up()
		local get_template = ExplosionUtils.get_template(action.rage_explosion_template)
		local num_2 = 1
		local name = arg_7_2.breed.name

		DamageUtils.create_explosion(world, arg_7_1, num, Quaternion.identity(), get_template, num_2, name, true, false, arg_7_1, 0, false)

		local go_id = Managers.state.unit_storage:go_id(arg_7_1)
		local var_7_7 = NetworkLookup.explosion_templates[get_template.name]
		local var_7_8 = NetworkLookup.damage_sources[name]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, num, Quaternion.identity(), var_7_7, 1, var_7_8, 0, false, go_id)
	end
end
