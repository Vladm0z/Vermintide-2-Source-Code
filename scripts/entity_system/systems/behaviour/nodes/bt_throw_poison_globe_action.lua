-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_throw_poison_globe_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTThrowPoisonGlobeAction = class(BTThrowPoisonGlobeAction, BTNode)

BTThrowPoisonGlobeAction.init = function (arg_1_0, ...)
	-- function 1
	BTThrowPoisonGlobeAction.super.init(arg_1_0, ...)
end

BTThrowPoisonGlobeAction.name = "BTThrowPoisonGlobeAction"

BTThrowPoisonGlobeAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.navigation_extension:set_enabled(false)

	arg_2_2.action = self._tree_node.action_data
	arg_2_2.anim_cb_spawn_projectile = false
	arg_2_2.anim_cb_throw = false

	local extension = ScriptUnit.extension(arg_2_1, "locomotion_system")

	extension:set_rotation_speed(5)
	extension:set_wanted_velocity(Vector3.zero())
end

BTThrowPoisonGlobeAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if arg_3_2.dummy_projectile_unit ~= nil then
		if not Unit.alive(arg_3_2.dummy_projectile_unit) then
			local world = arg_3_2.world

			World.unlink_unit(world, arg_3_2.dummy_projectile_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_3_2.dummy_projectile_unit)
		end

		arg_3_2.dummy_projectile_unit = nil
	end

	arg_3_2.action = nil

	local throw_target = arg_3_2.throw_target

	if not throw_target then
		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_3_1, throw_target, "poison_wind_globe")

		arg_3_2.throw_target = nil
	end

	arg_3_2.navigation_extension:set_enabled(true)
end

BTThrowPoisonGlobeAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not Unit.alive(arg_4_2.target_unit) then
		arg_4_2.target_unit = nil

		return "failed"
	end

	local action = arg_4_2.action
	local world = arg_4_2.world

	if not arg_4_2.anim_cb_spawn_projectile then
		arg_4_2.anim_cb_spawn_projectile = false

		self:spawn_dummy_projectile(arg_4_1, arg_4_2, world, action)
	elseif not arg_4_2.anim_cb_throw then
		arg_4_2.anim_cb_throw = false

		World.unlink_unit(world, arg_4_2.dummy_projectile_unit)
		Managers.state.unit_spawner:mark_for_deletion(arg_4_2.dummy_projectile_unit)

		arg_4_2.dummy_projectile_unit = nil

		local unbox = arg_4_2.throw_globe_data.throw_pos:unbox()
		local unbox_2 = arg_4_2.throw_globe_data.target_direction:unbox()
		local angle = arg_4_2.throw_globe_data.angle
		local speed = arg_4_2.throw_globe_data.speed

		self:launch_projectile(arg_4_2, action, unbox, unbox_2, angle, speed, arg_4_1)
		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_4_1, "enemy_attack", DialogueSettings.pounced_down_broadcast_range, "attack_tag", "pwg_projectile")

		local extension_input = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		alloc_table.attack_tag = "pwg_projectile"
		alloc_table.distance = math.floor(Vector3.distance(unbox, POSITION_LOOKUP[arg_4_1]))

		extension_input:trigger_networked_dialogue_event("enemy_attack", alloc_table)
	end

	if not (not arg_4_2.start_anim_locked_time and not (arg_4_3 > arg_4_2.start_anim_locked_time)) then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)

		arg_4_2.start_anim_locked_time = nil
	end

	local extension = ScriptUnit.extension(arg_4_1, "locomotion_system")

	if not (not arg_4_2.anim_locked and not (arg_4_3 < arg_4_2.anim_locked)) then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, arg_4_2.target_unit)

		extension:set_wanted_rotation(rotation_towards_unit_flat)
	elseif arg_4_2.move_state == "throwing" then
		return "done"
	else
		self:attack_throw(arg_4_1, arg_4_3, arg_4_4, arg_4_2, extension, action)
	end

	return "running"
end

BTThrowPoisonGlobeAction.attack_throw = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	if arg_5_4.move_state ~= "throwing" then
		local target_unit = arg_5_4.target_unit

		Managers.state.network:anim_event(arg_5_1, arg_5_6.attack_anim)

		arg_5_4.anim_locked = arg_5_2 + arg_5_6.attack_time
		arg_5_4.move_state = "throwing"

		local num_2

		if not arg_5_4.times_thrown then
			local num = arg_5_4.times_thrown + 1
			local barrage_count = arg_5_6.barrage_count

			barrage_count = barrage_count or 2
			num_2 = num % barrage_count

			if not num_2 then
				-- Nothing
			end
		end

		num_2 = 1

		::label_5_0::

		arg_5_4.times_thrown = num_2

		local action = arg_5_4.action
		local throw_globe_data = arg_5_4.throw_globe_data
		local var_5_6

		if arg_5_4.times_thrown == 0 then
			var_5_6 = action.time_between_throws[1]

			if not var_5_6 then
				-- Nothing
			end
		end

		var_5_6 = action.time_between_throws[2]

		::label_5_1::

		throw_globe_data.next_throw_at = arg_5_2 + var_5_6
		throw_globe_data.last_throw_at = arg_5_2

		local str = "poison_wind_globe"
		local throw_target = arg_5_4.throw_target

		if not throw_target then
			Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_5_1, throw_target, str)
		end

		arg_5_4.throw_target = target_unit

		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_5_1, target_unit, str)
	end

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_4.throw_target)

	arg_5_5:set_wanted_rotation(rotation_towards_unit_flat)
end

BTThrowPoisonGlobeAction.spawn_dummy_projectile = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local weapon_node_name = arg_6_4.weapon_node_name
	local node = Unit.node(arg_6_1, weapon_node_name)
	local world_position = Unit.world_position(arg_6_1, node)
	local str = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "prop_unit", nil, world_position)

	World.link_unit(arg_6_3, spawn_network_unit, 0, arg_6_1, node)

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(spawn_network_unit)
	local unit_game_object_id_2 = network:unit_game_object_id(arg_6_1)

	network.network_transmit:send_rpc_clients("rpc_link_unit", unit_game_object_id, 0, unit_game_object_id_2, node)

	arg_6_2.dummy_projectile_unit = spawn_network_unit
end

BTThrowPoisonGlobeAction.launch_projectile = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	-- function 7
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_7_1 = arg_7_2.aoe_dot_damage[get_difficulty_rank]

	var_7_1 = var_7_1 or arg_7_2.aoe_dot_damage[2]

	local calculate_damage = DamageUtils.calculate_damage(var_7_1)
	local var_7_3 = arg_7_2.aoe_init_damage[get_difficulty_rank]

	var_7_3 = var_7_3 or arg_7_2.aoe_init_damage[2]

	local calculate_damage_2 = DamageUtils.calculate_damage(var_7_3)
	local aoe_dot_damage_interval = arg_7_2.aoe_dot_damage_interval
	local radius = arg_7_2.radius
	local initial_radius = arg_7_2.initial_radius

	initial_radius = initial_radius or radius

	local duration = arg_7_2.duration
	local name = arg_7_1.breed.name
	local create_nav_tag_volume = arg_7_2.create_nav_tag_volume
	local flag = false

	Managers.state.entity:system("projectile_system"):spawn_globadier_globe(arg_7_3, arg_7_4, arg_7_5, arg_7_6, initial_radius, radius, duration, arg_7_7, name, calculate_damage, calculate_damage_2, aoe_dot_damage_interval, create_nav_tag_volume, flag)

	arg_7_1.has_thrown_first_globe = true
end
