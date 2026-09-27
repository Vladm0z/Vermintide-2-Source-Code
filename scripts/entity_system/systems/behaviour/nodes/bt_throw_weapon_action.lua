-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_throw_weapon_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTThrowWeaponAction = class(BTThrowWeaponAction, BTNode)

BTThrowWeaponAction.init = function (arg_1_0, ...)
	-- function 1
	BTThrowWeaponAction.super.init(arg_1_0, ...)
end

BTThrowWeaponAction.name = "BTThrowWeaponAction"

BTThrowWeaponAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.active_node = BTThrowWeaponAction
	arg_2_2.move_state = "attacking"

	local throw_animation = action_data.throw_animation

	Managers.state.network:anim_event(arg_2_1, throw_animation)
	Unit.flow_event(arg_2_1, "throw_animation_started")

	arg_2_2.inventory_extension = ScriptUnit.extension(arg_2_1, "ai_inventory_system")

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.thrown_weapon_displaced_units = {}
	arg_2_2.pushed_position_override = Vector3Box()
	arg_2_2.hit_units = {}
	arg_2_2.rotation_timer = arg_2_3 + action_data.rotation_time

	if not action_data.close_attack_time then
		arg_2_2.close_attack_timer = arg_2_3 + action_data.close_attack_time
	end
end

BTThrowWeaponAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not arg_3_5 then
		arg_3_2.locomotion_extension:set_rotation_speed(nil)
	end

	arg_3_2.navigation_extension:set_enabled(true)

	if not arg_3_2.thrown_unit and not Unit.alive(arg_3_2.thrown_unit) then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_3_2.action.stop_sound_id, arg_3_2.thrown_unit)
		Managers.state.unit_spawner:mark_for_deletion(arg_3_2.thrown_unit)

		arg_3_2.thrown_unit = nil

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_3_1)

		network.network_transmit:send_rpc_all("rpc_ai_show_single_item", unit_game_object_id, 1, true)
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
	-- function 4
	local action = arg_4_2.action
	local local_rotation = Unit.local_rotation(arg_4_1, 0)
	local num = POSITION_LOOKUP[arg_4_1] + Vector3.up() * 2
	local forward = Quaternion.forward(local_rotation)
	local world = arg_4_2.world
	local physics_world = World.physics_world(world)
	local immediate_raycast, var_4_7, var_4_8 = PhysicsWorld.immediate_raycast(physics_world, num, forward, 40, "closest", "collision_filter", "filter_ai_line_of_sight_check")

	if not immediate_raycast then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_4_1)

		network.network_transmit:send_rpc_all("rpc_ai_show_single_item", unit_game_object_id, 1, false)

		arg_4_2.throw_weapon_goal_position = Vector3Box(var_4_7)

		local throw_unit_name = action.throw_unit_name
		local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(throw_unit_name, "thrown_weapon_unit", nil, num)

		arg_4_2.thrown_unit = spawn_network_unit
		arg_4_2.thrown_state = "moving_towards_target"

		Unit.flow_event(spawn_network_unit, "axe_thrown")

		arg_4_2.initial_throw_direction = Vector3Box(forward)

		Managers.state.entity:system("audio_system"):play_audio_unit_event(action.running_sound_id, arg_4_2.thrown_unit)

		local calculate_oobb, var_4_14, var_4_15 = AiUtils.calculate_oobb(var_4_8, POSITION_LOOKUP[arg_4_1], local_rotation, 2, action.radius * 1.2)
		local num_2 = var_4_8 * 0.25

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(calculate_oobb, "oobb", var_4_15, var_4_14, num_2, "Throw Weapon")
	else
		arg_4_2.throw_finished = true
	end
end

BTThrowWeaponAction.anim_cb_throw_finished = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	arg_5_2.throw_finished = true
end

BTThrowWeaponAction.catch_weapon = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_6_1)

	network.network_transmit:send_rpc_all("rpc_ai_show_single_item", unit_game_object_id, 1, true)
	Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_6_2.action.stop_sound_id, arg_6_2.thrown_unit)

	local catch_animation = arg_6_2.action.catch_animation

	Managers.state.network:anim_event(arg_6_1, catch_animation)

	if not arg_6_2.thrown_unit then
		Managers.state.unit_spawner:mark_for_deletion(arg_6_2.thrown_unit)
	end

	arg_6_2.throw_weapon_goal_position = nil
	arg_6_2.thrown_unit = nil
	arg_6_2.thrown_weapon_direction = nil
	arg_6_2.catched_weapon = true
	arg_6_2.close_attack_target = nil
end

BTThrowWeaponAction.run = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if arg_7_3 < arg_7_2.rotation_timer then
		local target_unit = arg_7_2.target_unit

		if not target_unit then
			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, target_unit)

			arg_7_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
		end
	elseif not arg_7_2.close_attack_target then
		local rotation_towards_unit_flat_2 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_2.close_attack_target)

		arg_7_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat_2)
	elseif not (not arg_7_2.initial_throw_direction and arg_7_2.catched_weapon or not (arg_7_3 > arg_7_2.rotation_timer)) then
		local look = Quaternion.look(arg_7_2.initial_throw_direction:unbox())

		arg_7_2.locomotion_extension:set_wanted_rotation(look)
	end

	if not arg_7_2.throw_finished then
		return "done"
	else
		local var_7_4

		if not arg_7_2.throw_weapon_goal_position then
			var_7_4 = self:update_thrown_weapon(arg_7_1, arg_7_2, arg_7_4, arg_7_3)
		end

		if not var_7_4 and not arg_7_2.thrown_unit then
			self:catch_weapon(arg_7_1, arg_7_2)
		end

		return "running"
	end
end

BTThrowWeaponAction.update_thrown_weapon = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local thrown_unit = arg_8_2.thrown_unit

	if not (not thrown_unit and Unit.alive(thrown_unit)) then
		return
	end

	local thrown_state = arg_8_2.thrown_state
	local action = arg_8_2.action
	local throw_speed

	if thrown_state == "moving_towards_target" then
		throw_speed = action.throw_speed

		if not throw_speed then
			-- Nothing
		end
	end

	throw_speed = thrown_state ~= "returning_to_owner" or action.return_speed

	::label_8_0::

	local num = POSITION_LOOKUP[arg_8_1] + Vector3.up() * 2
	local unbox = arg_8_2.throw_weapon_goal_position:unbox()
	local local_position = Unit.local_position(thrown_unit, 0)
	local distance = Vector3.distance(unbox, local_position)
	local normalize = Vector3.normalize(unbox - local_position)

	if not arg_8_2.thrown_weapon_direction then
		arg_8_2.thrown_weapon_direction = Vector3Box(normalize)
		arg_8_2.thrown_weapon_angle = 1
	end

	if thrown_state == "lingering" then
		if arg_8_4 > arg_8_2.thrown_linger_timer then
			arg_8_2.thrown_state = "returning_to_owner"

			Managers.state.entity:system("audio_system"):play_audio_unit_event(action.pull_sound_id, arg_8_2.thrown_unit)
		end
	elseif distance < 1.5 then
		if thrown_state == "returning_to_owner" then
			if not action.hit_targets_on_return then
				arg_8_2.ignore_thrown_weapon_overlap = true
			end

			return true
		end

		local num_2 = local_position + normalize * throw_speed * arg_8_3

		Unit.set_local_position(thrown_unit, 0, num_2)
		arg_8_2.throw_weapon_goal_position:store(num)

		arg_8_2.thrown_state = "lingering"
		arg_8_2.thrown_linger_timer = arg_8_4 + action.arrival_linger_time

		Managers.state.entity:system("audio_system"):play_audio_unit_event(action.impact_sound_id, arg_8_2.thrown_unit)
	else
		local num_3 = local_position + normalize * throw_speed * arg_8_3

		Unit.set_local_position(thrown_unit, 0, num_3)
	end

	if thrown_state == "moving_towards_target" then
		arg_8_2.thrown_weapon_angle = arg_8_2.thrown_weapon_angle + arg_8_3 * action.rotation_speed

		local local_rotation = Unit.local_rotation(thrown_unit, 0)
		local make_axes = Vector3.make_axes(normalize)
		local look = Quaternion.look(normalize)
		local multiply = Quaternion.multiply(Quaternion.axis_angle(make_axes, arg_8_2.thrown_weapon_angle), look)

		Unit.set_local_rotation(thrown_unit, 0, multiply)
	else
		local make_axes_2 = Vector3.make_axes(-normalize)
		local look_2 = Quaternion.look(-normalize)
		local multiply_2 = Quaternion.multiply(Quaternion.axis_angle(make_axes_2, 45), look_2)

		Unit.set_local_rotation(thrown_unit, 0, multiply_2)
	end

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(thrown_unit)
	local game = network:game()
	local local_position_2 = Unit.local_position(thrown_unit, 0)

	GameSession.set_game_object_field(game, unit_game_object_id, "position", local_position_2)

	local local_rotation_2 = Unit.local_rotation(thrown_unit, 0)

	GameSession.set_game_object_field(game, unit_game_object_id, "rotation", local_rotation_2)

	local ENEMY_PLAYER_AND_BOT_UNITS = arg_8_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_8_24 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not (not Unit.alive(var_8_24) and arg_8_2.ignore_thrown_weapon_overlap) then
			self:check_overlap(action, arg_8_2.thrown_unit, arg_8_1, arg_8_2, var_8_24)
		end

		if not (not action.use_close_attack and not (arg_8_4 > arg_8_2.close_attack_timer)) then
			self:attack_close_units(action, arg_8_1, arg_8_2, var_8_24, arg_8_4)
		end
	end

	return false
end

BTThrowWeaponAction.check_overlap = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local radius = arg_9_1.radius
	local push_speed = arg_9_1.push_speed
	local push_speed_z = arg_9_1.push_speed_z
	local hit_units = arg_9_4.hit_units
	local var_9_4 = POSITION_LOOKUP[arg_9_5]
	local flat = Vector3.flat(Unit.local_position(arg_9_2, 0))
	local num = var_9_4 - Vector3(flat[1], flat[2], var_9_4[3])
	local length = Vector3.length(Vector3.flat(num))

	if not hit_units[arg_9_5] then
		local extension = ScriptUnit.extension(arg_9_5, "status_system")

		if not extension and not extension:get_is_dodging() then
			radius = arg_9_1.target_dodged_radius
		end

		if not ((not (length < radius) or not extension) and extension:is_invisible()) then
			local num_2 = push_speed * Vector3.normalize(num)

			if not push_speed_z then
				Vector3.set_z(num_2, push_speed_z)
			end

			if not arg_9_1.catapult_players then
				StatusUtils.set_catapulted_network(arg_9_5, true, num_2)
			else
				ScriptUnit.extension(arg_9_5, "locomotion_system"):add_external_velocity(num_2)
			end

			hit_units[arg_9_5] = true

			if not DamageUtils.check_block(arg_9_3, arg_9_5, arg_9_1.fatigue_type) then
				AiUtils.damage_target(arg_9_5, arg_9_3, arg_9_1, arg_9_1.damage)
			end
		end
	end
end

BTThrowWeaponAction.attack_close_units = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local attack_close_range = arg_10_1.attack_close_range
	local num = POSITION_LOOKUP[arg_10_4] - Vector3.flat(Unit.local_position(arg_10_2, 0))

	if attack_close_range > Vector3.length(Vector3.flat(num)) then
		Managers.state.network:anim_event(arg_10_2, arg_10_1.close_attack_animation)

		arg_10_3.close_attack_timer = arg_10_5 + 3
		arg_10_3.close_attack_target = arg_10_4
	end
end

BTThrowWeaponAction.anim_cb_damage = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	if not Unit.alive(arg_11_2.close_attack_target) then
		return
	end

	local num = POSITION_LOOKUP[arg_11_2.close_attack_target] - Vector3.flat(Unit.local_position(arg_11_1, 0))
	local num_2 = 10 * Vector3.normalize(num)

	ScriptUnit.extension(arg_11_2.close_attack_target, "locomotion_system"):add_external_velocity(num_2)
	AiUtils.damage_target(arg_11_2.close_attack_target, arg_11_1, arg_11_2.action, arg_11_2.action.close_attack_damage)
end
