-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_throw_poison_globe_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTThrowPoisonGlobeAction = class(BTThrowPoisonGlobeAction, BTNode)

function BTThrowPoisonGlobeAction.init(arg_1_0, ...)
	BTThrowPoisonGlobeAction.super.init(arg_1_0, ...)
end

BTThrowPoisonGlobeAction.name = "BTThrowPoisonGlobeAction"

function BTThrowPoisonGlobeAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.navigation_extension:set_enabled(false)

	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.anim_cb_spawn_projectile = false
	arg_2_2.anim_cb_throw = false

	local var_2_0 = ScriptUnit.extension(arg_2_1, "locomotion_system")

	var_2_0:set_rotation_speed(5)
	var_2_0:set_wanted_velocity(Vector3.zero())
end

function BTThrowPoisonGlobeAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_2.dummy_projectile_unit ~= nil then
		if Unit.alive(arg_3_2.dummy_projectile_unit) then
			local var_3_0 = arg_3_2.world

			World.unlink_unit(var_3_0, arg_3_2.dummy_projectile_unit)
			Managers.state.unit_spawner:mark_for_deletion(arg_3_2.dummy_projectile_unit)
		end

		arg_3_2.dummy_projectile_unit = nil
	end

	arg_3_2.action = nil

	local var_3_1 = arg_3_2.throw_target

	if var_3_1 then
		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_3_1, var_3_1, "poison_wind_globe")

		arg_3_2.throw_target = nil
	end

	arg_3_2.navigation_extension:set_enabled(true)
end

function BTThrowPoisonGlobeAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not Unit.alive(arg_4_2.target_unit) then
		arg_4_2.target_unit = nil

		return "failed"
	end

	local var_4_0 = arg_4_2.action
	local var_4_1 = arg_4_2.world

	if arg_4_2.anim_cb_spawn_projectile then
		arg_4_2.anim_cb_spawn_projectile = false

		arg_4_0:spawn_dummy_projectile(arg_4_1, arg_4_2, var_4_1, var_4_0)
	elseif arg_4_2.anim_cb_throw then
		arg_4_2.anim_cb_throw = false

		World.unlink_unit(var_4_1, arg_4_2.dummy_projectile_unit)
		Managers.state.unit_spawner:mark_for_deletion(arg_4_2.dummy_projectile_unit)

		arg_4_2.dummy_projectile_unit = nil

		local var_4_2 = arg_4_2.throw_globe_data.throw_pos:unbox()
		local var_4_3 = arg_4_2.throw_globe_data.target_direction:unbox()
		local var_4_4 = arg_4_2.throw_globe_data.angle
		local var_4_5 = arg_4_2.throw_globe_data.speed

		arg_4_0:launch_projectile(arg_4_2, var_4_0, var_4_2, var_4_3, var_4_4, var_4_5, arg_4_1)
		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_4_1, "enemy_attack", DialogueSettings.pounced_down_broadcast_range, "attack_tag", "pwg_projectile")

		local var_4_6 = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
		local var_4_7 = FrameTable.alloc_table()

		var_4_7.attack_tag = "pwg_projectile"
		var_4_7.distance = math.floor(Vector3.distance(var_4_2, POSITION_LOOKUP[arg_4_1]))

		var_4_6:trigger_networked_dialogue_event("enemy_attack", var_4_7)
	end

	if arg_4_2.start_anim_locked_time and arg_4_3 > arg_4_2.start_anim_locked_time then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)

		arg_4_2.start_anim_locked_time = nil
	end

	local var_4_8 = ScriptUnit.extension(arg_4_1, "locomotion_system")

	if arg_4_2.anim_locked and arg_4_3 < arg_4_2.anim_locked then
		local var_4_9 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, arg_4_2.target_unit)

		var_4_8:set_wanted_rotation(var_4_9)
	elseif arg_4_2.move_state == "throwing" then
		return "done"
	else
		arg_4_0:attack_throw(arg_4_1, arg_4_3, arg_4_4, arg_4_2, var_4_8, var_4_0)
	end

	return "running"
end

function BTThrowPoisonGlobeAction.attack_throw(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	if arg_5_4.move_state ~= "throwing" then
		local var_5_0 = arg_5_4.target_unit

		Managers.state.network:anim_event(arg_5_1, arg_5_6.attack_anim)

		arg_5_4.anim_locked = arg_5_2 + arg_5_6.attack_time
		arg_5_4.move_state = "throwing"
		arg_5_4.times_thrown = arg_5_4.times_thrown and (arg_5_4.times_thrown + 1) % (arg_5_6.barrage_count or 2) or 1

		local var_5_1 = arg_5_4.action
		local var_5_2 = arg_5_4.throw_globe_data

		var_5_2.next_throw_at = arg_5_2 + (arg_5_4.times_thrown == 0 and var_5_1.time_between_throws[1] or var_5_1.time_between_throws[2])
		var_5_2.last_throw_at = arg_5_2

		local var_5_3 = "poison_wind_globe"
		local var_5_4 = arg_5_4.throw_target

		if var_5_4 then
			Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_5_1, var_5_4, var_5_3)
		end

		arg_5_4.throw_target = var_5_0

		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_5_1, var_5_0, var_5_3)
	end

	local var_5_5 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_4.throw_target)

	arg_5_5:set_wanted_rotation(var_5_5)
end

function BTThrowPoisonGlobeAction.spawn_dummy_projectile(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_4.weapon_node_name
	local var_6_1 = Unit.node(arg_6_1, var_6_0)
	local var_6_2 = Unit.world_position(arg_6_1, var_6_1)
	local var_6_3 = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"
	local var_6_4 = Managers.state.unit_spawner:spawn_network_unit(var_6_3, "prop_unit", nil, var_6_2)

	World.link_unit(arg_6_3, var_6_4, 0, arg_6_1, var_6_1)

	local var_6_5 = Managers.state.network
	local var_6_6 = var_6_5:unit_game_object_id(var_6_4)
	local var_6_7 = var_6_5:unit_game_object_id(arg_6_1)

	var_6_5.network_transmit:send_rpc_clients("rpc_link_unit", var_6_6, 0, var_6_7, var_6_1)

	arg_6_2.dummy_projectile_unit = var_6_4
end

function BTThrowPoisonGlobeAction.launch_projectile(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	local var_7_0 = Managers.state.difficulty:get_difficulty_rank()
	local var_7_1 = arg_7_2.aoe_dot_damage[var_7_0] or arg_7_2.aoe_dot_damage[2]
	local var_7_2 = DamageUtils.calculate_damage(var_7_1)
	local var_7_3 = arg_7_2.aoe_init_damage[var_7_0] or arg_7_2.aoe_init_damage[2]
	local var_7_4 = DamageUtils.calculate_damage(var_7_3)
	local var_7_5 = arg_7_2.aoe_dot_damage_interval
	local var_7_6 = arg_7_2.radius
	local var_7_7 = arg_7_2.initial_radius or var_7_6
	local var_7_8 = arg_7_2.duration
	local var_7_9 = arg_7_1.breed.name
	local var_7_10 = arg_7_2.create_nav_tag_volume
	local var_7_11 = false

	Managers.state.entity:system("projectile_system"):spawn_globadier_globe(arg_7_3, arg_7_4, arg_7_5, arg_7_6, var_7_7, var_7_6, var_7_8, arg_7_7, var_7_9, var_7_2, var_7_4, var_7_5, var_7_10, var_7_11)

	arg_7_1.has_thrown_first_globe = true
end
