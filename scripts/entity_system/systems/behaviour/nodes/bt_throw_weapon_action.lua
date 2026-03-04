-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_throw_weapon_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTThrowWeaponAction = class(BTThrowWeaponAction, BTNode)

BTThrowWeaponAction.init = function (arg_1_0, ...)
	BTThrowWeaponAction.super.init(arg_1_0, ...)
end

BTThrowWeaponAction.name = "BTThrowWeaponAction"

BTThrowWeaponAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.active_node = BTThrowWeaponAction
	arg_2_2.move_state = "attacking"

	local var_2_1 = var_2_0.throw_animation

	Managers.state.network:anim_event(arg_2_1, var_2_1)
	Unit.flow_event(arg_2_1, "throw_animation_started")

	arg_2_2.inventory_extension = ScriptUnit.extension(arg_2_1, "ai_inventory_system")

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.thrown_weapon_displaced_units = {}
	arg_2_2.pushed_position_override = Vector3Box()
	arg_2_2.hit_units = {}
	arg_2_2.rotation_timer = arg_2_3 + var_2_0.rotation_time

	if var_2_0.close_attack_time then
		arg_2_2.close_attack_timer = arg_2_3 + var_2_0.close_attack_time
	end
end

BTThrowWeaponAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_5 then
		arg_3_2.locomotion_extension:set_rotation_speed(nil)
	end

	arg_3_2.navigation_extension:set_enabled(true)

	if arg_3_2.thrown_unit and Unit.alive(arg_3_2.thrown_unit) then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_3_2.action.stop_sound_id, arg_3_2.thrown_unit)
		Managers.state.unit_spawner:mark_for_deletion(arg_3_2.thrown_unit)

		arg_3_2.thrown_unit = nil

		local var_3_0 = Managers.state.network
		local var_3_1 = var_3_0:unit_game_object_id(arg_3_1)

		var_3_0.network_transmit:send_rpc_all("rpc_ai_show_single_item", var_3_1, 1, true)
	end

	arg_3_2.action = nil
	arg_3_2.active_node = nil
	arg_3_2.throw_finished = nil
	arg_3_2.inventory_extension = nil
	arg_3_2.pushed_position_override = nil
	arg_3_2.hit_units = nil
	arg_3_2.catched_weapon = nil
	arg_3_2.rotation_timer = nil
	arg_3_2.ignore_thrown_weapon_overlap = nil

	Managers.state.network:anim_event(arg_3_1, "move_fwd")
end

BTThrowWeaponAction.anim_cb_throw_weapon = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2.action
	local var_4_1 = Unit.local_rotation(arg_4_1, 0)
	local var_4_2 = POSITION_LOOKUP[arg_4_1] + Vector3.up() * 2
	local var_4_3 = Quaternion.forward(var_4_1)
	local var_4_4 = arg_4_2.world
	local var_4_5 = World.physics_world(var_4_4)
	local var_4_6, var_4_7, var_4_8 = PhysicsWorld.immediate_raycast(var_4_5, var_4_2, var_4_3, 40, "closest", "collision_filter", "filter_ai_line_of_sight_check")

	if var_4_6 then
		local var_4_9 = Managers.state.network
		local var_4_10 = var_4_9:unit_game_object_id(arg_4_1)

		var_4_9.network_transmit:send_rpc_all("rpc_ai_show_single_item", var_4_10, 1, false)

		arg_4_2.throw_weapon_goal_position = Vector3Box(var_4_7)

		local var_4_11 = var_4_0.throw_unit_name
		local var_4_12 = Managers.state.unit_spawner:spawn_network_unit(var_4_11, "thrown_weapon_unit", nil, var_4_2)

		arg_4_2.thrown_unit = var_4_12
		arg_4_2.thrown_state = "moving_towards_target"

		Unit.flow_event(var_4_12, "axe_thrown")

		arg_4_2.initial_throw_direction = Vector3Box(var_4_3)

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_4_0.running_sound_id, arg_4_2.thrown_unit)

		local var_4_13, var_4_14, var_4_15 = AiUtils.calculate_oobb(var_4_8, POSITION_LOOKUP[arg_4_1], var_4_1, 2, var_4_0.radius * 1.2)
		local var_4_16 = var_4_8 * 0.25

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_4_13, "oobb", var_4_15, var_4_14, var_4_16, "Throw Weapon")
	else
		arg_4_2.throw_finished = true
	end
end

BTThrowWeaponAction.anim_cb_throw_finished = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_2.throw_finished = true
end

BTThrowWeaponAction.catch_weapon = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.state.network
	local var_6_1 = var_6_0:unit_game_object_id(arg_6_1)

	var_6_0.network_transmit:send_rpc_all("rpc_ai_show_single_item", var_6_1, 1, true)
	Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_6_2.action.stop_sound_id, arg_6_2.thrown_unit)

	local var_6_2 = arg_6_2.action.catch_animation

	Managers.state.network:anim_event(arg_6_1, var_6_2)

	if arg_6_2.thrown_unit then
		Managers.state.unit_spawner:mark_for_deletion(arg_6_2.thrown_unit)
	end

	arg_6_2.throw_weapon_goal_position = nil
	arg_6_2.thrown_unit = nil
	arg_6_2.thrown_weapon_direction = nil
	arg_6_2.catched_weapon = true
	arg_6_2.close_attack_target = nil
end

BTThrowWeaponAction.run = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_3 < arg_7_2.rotation_timer then
		local var_7_0 = arg_7_2.target_unit

		if var_7_0 then
			local var_7_1 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, var_7_0)

			arg_7_2.locomotion_extension:set_wanted_rotation(var_7_1)
		end
	elseif arg_7_2.close_attack_target then
		local var_7_2 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_2.close_attack_target)

		arg_7_2.locomotion_extension:set_wanted_rotation(var_7_2)
	elseif arg_7_2.initial_throw_direction and (arg_7_2.catched_weapon or arg_7_3 > arg_7_2.rotation_timer) then
		local var_7_3 = Quaternion.look(arg_7_2.initial_throw_direction:unbox())

		arg_7_2.locomotion_extension:set_wanted_rotation(var_7_3)
	end

	if arg_7_2.throw_finished then
		return "done"
	else
		local var_7_4

		if arg_7_2.throw_weapon_goal_position then
			var_7_4 = arg_7_0:update_thrown_weapon(arg_7_1, arg_7_2, arg_7_4, arg_7_3)
		end

		if var_7_4 and arg_7_2.thrown_unit then
			arg_7_0:catch_weapon(arg_7_1, arg_7_2)
		end

		return "running"
	end
end

BTThrowWeaponAction.update_thrown_weapon = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_2.thrown_unit

	if not var_8_0 or not Unit.alive(var_8_0) then
		return
	end

	local var_8_1 = arg_8_2.thrown_state
	local var_8_2 = arg_8_2.action
	local var_8_3 = var_8_1 == "moving_towards_target" and var_8_2.throw_speed or var_8_1 == "returning_to_owner" and var_8_2.return_speed
	local var_8_4 = POSITION_LOOKUP[arg_8_1] + Vector3.up() * 2
	local var_8_5 = arg_8_2.throw_weapon_goal_position:unbox()
	local var_8_6 = Unit.local_position(var_8_0, 0)
	local var_8_7 = Vector3.distance(var_8_5, var_8_6)
	local var_8_8 = Vector3.normalize(var_8_5 - var_8_6)

	if not arg_8_2.thrown_weapon_direction then
		arg_8_2.thrown_weapon_direction = Vector3Box(var_8_8)
		arg_8_2.thrown_weapon_angle = 1
	end

	if var_8_1 == "lingering" then
		if arg_8_4 > arg_8_2.thrown_linger_timer then
			arg_8_2.thrown_state = "returning_to_owner"

			Managers.state.entity:system("audio_system"):play_audio_unit_event(var_8_2.pull_sound_id, arg_8_2.thrown_unit)
		end
	elseif var_8_7 < 1.5 then
		if var_8_1 == "returning_to_owner" then
			if not var_8_2.hit_targets_on_return then
				arg_8_2.ignore_thrown_weapon_overlap = true
			end

			return true
		end

		local var_8_9 = var_8_6 + var_8_8 * var_8_3 * arg_8_3

		Unit.set_local_position(var_8_0, 0, var_8_9)
		arg_8_2.throw_weapon_goal_position:store(var_8_4)

		arg_8_2.thrown_state = "lingering"
		arg_8_2.thrown_linger_timer = arg_8_4 + var_8_2.arrival_linger_time

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_8_2.impact_sound_id, arg_8_2.thrown_unit)
	else
		local var_8_10 = var_8_6 + var_8_8 * var_8_3 * arg_8_3

		Unit.set_local_position(var_8_0, 0, var_8_10)
	end

	if var_8_1 == "moving_towards_target" then
		arg_8_2.thrown_weapon_angle = arg_8_2.thrown_weapon_angle + arg_8_3 * var_8_2.rotation_speed

		local var_8_11 = Unit.local_rotation(var_8_0, 0)
		local var_8_12 = Vector3.make_axes(var_8_8)
		local var_8_13 = Quaternion.look(var_8_8)
		local var_8_14 = Quaternion.multiply(Quaternion.axis_angle(var_8_12, arg_8_2.thrown_weapon_angle), var_8_13)

		Unit.set_local_rotation(var_8_0, 0, var_8_14)
	else
		local var_8_15 = Vector3.make_axes(-var_8_8)
		local var_8_16 = Quaternion.look(-var_8_8)
		local var_8_17 = Quaternion.multiply(Quaternion.axis_angle(var_8_15, 45), var_8_16)

		Unit.set_local_rotation(var_8_0, 0, var_8_17)
	end

	local var_8_18 = Managers.state.network
	local var_8_19 = var_8_18:unit_game_object_id(var_8_0)
	local var_8_20 = var_8_18:game()
	local var_8_21 = Unit.local_position(var_8_0, 0)

	GameSession.set_game_object_field(var_8_20, var_8_19, "position", var_8_21)

	local var_8_22 = Unit.local_rotation(var_8_0, 0)

	GameSession.set_game_object_field(var_8_20, var_8_19, "rotation", var_8_22)

	local var_8_23 = arg_8_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_8_0 = 1, #var_8_23 do
		local var_8_24 = var_8_23[iter_8_0]

		if Unit.alive(var_8_24) and not arg_8_2.ignore_thrown_weapon_overlap then
			arg_8_0:check_overlap(var_8_2, arg_8_2.thrown_unit, arg_8_1, arg_8_2, var_8_24)
		end

		if var_8_2.use_close_attack and arg_8_4 > arg_8_2.close_attack_timer then
			arg_8_0:attack_close_units(var_8_2, arg_8_1, arg_8_2, var_8_24, arg_8_4)
		end
	end

	return false
end

BTThrowWeaponAction.check_overlap = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_1.radius
	local var_9_1 = arg_9_1.push_speed
	local var_9_2 = arg_9_1.push_speed_z
	local var_9_3 = arg_9_4.hit_units
	local var_9_4 = POSITION_LOOKUP[arg_9_5]
	local var_9_5 = Vector3.flat(Unit.local_position(arg_9_2, 0))
	local var_9_6 = var_9_4 - Vector3(var_9_5[1], var_9_5[2], var_9_4[3])
	local var_9_7 = Vector3.length(Vector3.flat(var_9_6))

	if not var_9_3[arg_9_5] then
		local var_9_8 = ScriptUnit.extension(arg_9_5, "status_system")

		if var_9_8 and var_9_8:get_is_dodging() then
			var_9_0 = arg_9_1.target_dodged_radius
		end

		if var_9_7 < var_9_0 and var_9_8 and not var_9_8:is_invisible() then
			local var_9_9 = var_9_1 * Vector3.normalize(var_9_6)

			if var_9_2 then
				Vector3.set_z(var_9_9, var_9_2)
			end

			if arg_9_1.catapult_players then
				StatusUtils.set_catapulted_network(arg_9_5, true, var_9_9)
			else
				ScriptUnit.extension(arg_9_5, "locomotion_system"):add_external_velocity(var_9_9)
			end

			var_9_3[arg_9_5] = true

			if not DamageUtils.check_block(arg_9_3, arg_9_5, arg_9_1.fatigue_type) then
				AiUtils.damage_target(arg_9_5, arg_9_3, arg_9_1, arg_9_1.damage)
			end
		end
	end
end

BTThrowWeaponAction.attack_close_units = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = arg_10_1.attack_close_range
	local var_10_1 = POSITION_LOOKUP[arg_10_4] - Vector3.flat(Unit.local_position(arg_10_2, 0))

	if var_10_0 > Vector3.length(Vector3.flat(var_10_1)) then
		Managers.state.network:anim_event(arg_10_2, arg_10_1.close_attack_animation)

		arg_10_3.close_attack_timer = arg_10_5 + 3
		arg_10_3.close_attack_target = arg_10_4
	end
end

BTThrowWeaponAction.anim_cb_damage = function (arg_11_0, arg_11_1, arg_11_2)
	if not Unit.alive(arg_11_2.close_attack_target) then
		return
	end

	local var_11_0 = POSITION_LOOKUP[arg_11_2.close_attack_target] - Vector3.flat(Unit.local_position(arg_11_1, 0))
	local var_11_1 = 10 * Vector3.normalize(var_11_0)

	ScriptUnit.extension(arg_11_2.close_attack_target, "locomotion_system"):add_external_velocity(var_11_1)
	AiUtils.damage_target(arg_11_2.close_attack_target, arg_11_1, arg_11_2.action, arg_11_2.action.close_attack_damage)
end
