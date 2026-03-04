-- chunkname: @scripts/unit_extensions/weapons/actions/action_throw.lua

ActionThrow = class(ActionThrow, ActionBase)

ActionThrow.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionThrow.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0.owner_inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
end

ActionThrow.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2)
	ActionThrow.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.current_action = arg_2_1
	arg_2_0.action_time_started = arg_2_2
	arg_2_0.thrown = nil
end

ActionThrow.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_0.thrown then
		return
	end

	local var_3_0 = arg_3_0.current_action

	if arg_3_2 >= arg_3_0.action_time_started + var_3_0.throw_time then
		arg_3_0:_throw()

		arg_3_0.thrown = true
	end
end

ActionThrow._throw = function (arg_4_0)
	local var_4_0 = arg_4_0.owner_unit
	local var_4_1 = arg_4_0.current_action
	local var_4_2 = var_4_1.projectile_info
	local var_4_3 = ScriptUnit.extension(var_4_0, "first_person_system"):get_first_person_unit()
	local var_4_4 = POSITION_LOOKUP[var_4_3]
	local var_4_5 = var_4_1.speed
	local var_4_6 = ScriptUnit.has_extension(var_4_0, "buff_system")

	if var_4_6 then
		var_4_5 = var_4_6:apply_buffs_to_value(var_4_5, "throw_speed_increase")
	end

	local var_4_7 = var_4_1.velocity_multiplier or 0.25
	local var_4_8 = Unit.local_pose(var_4_3, 0)
	local var_4_9 = Unit.local_rotation(var_4_3, 0)
	local var_4_10 = Vector3(0, 0, 0)

	if ScriptUnit.has_extension(var_4_0, "locomotion_system") then
		var_4_10 = ScriptUnit.extension(var_4_0, "locomotion_system"):current_velocity()
	end

	local var_4_11 = Quaternion.forward(var_4_9)
	local var_4_12 = var_4_1.throw_offset
	local var_4_13 = Vector3(var_4_12[1], var_4_12[2], var_4_12[3])
	local var_4_14 = var_4_4 + Matrix4x4.transform_without_translation(var_4_8, var_4_13)
	local var_4_15 = Unit.world_pose(arg_4_0.weapon_unit, 0)
	local var_4_16 = var_4_1.angular_velocity
	local var_4_17 = Vector3(var_4_16[1], var_4_16[2], var_4_16[3])
	local var_4_18 = Matrix4x4.transform_without_translation(var_4_15, var_4_17)
	local var_4_19 = Vector3.normalize(Quaternion.forward(var_4_9) + Vector3(0, 0, var_4_1.uppety or 0.6)) * var_4_5 + var_4_10 * var_4_7
	local var_4_20 = Unit.world_rotation(arg_4_0.weapon_unit, 0)

	if var_4_1.is_statue_and_needs_rotation_cause_reasons then
		local var_4_21 = Quaternion(Vector3.up(), -math.pi)

		var_4_20 = Quaternion.multiply(var_4_20, var_4_21)
	end

	if var_4_1.rotate_towards_owner_unit then
		var_4_20 = Quaternion.look(Vector3.normalize(Vector3.flat(POSITION_LOOKUP[var_4_0]) - Vector3.flat(var_4_14)))
	end

	local var_4_22 = var_4_4 + var_4_11 * 1.2 - var_4_4
	local var_4_23 = Vector3.length(var_4_22)
	local var_4_24 = Vector3.normalize(var_4_22)
	local var_4_25 = World.get_data(arg_4_0.world, "physics_world")

	if PhysicsWorld.immediate_raycast(var_4_25, var_4_4, var_4_24, var_4_23, "closest", "types", "both", "collision_filter", "filter_physics_projectile_large") then
		var_4_14 = var_4_4
	end

	local var_4_26 = "thrown"

	ActionUtils.spawn_pickup_projectile(arg_4_0.world, arg_4_0.weapon_unit, var_4_2.projectile_unit_name, var_4_2.projectile_unit_template_name, var_4_1, var_4_0, var_4_14, var_4_20, var_4_19, var_4_18, arg_4_0.item_name, var_4_26)
	Unit.set_unit_visibility(arg_4_0.weapon_unit, false)
	Unit.flow_event(arg_4_0.weapon_unit, "lua_unwield")

	local var_4_27 = false

	CharacterStateHelper.show_inventory_3p(var_4_0, false, var_4_27, arg_4_0.is_server, arg_4_0.owner_inventory_extension)

	if not var_4_2.disable_throwing_dialogue and var_4_2.pickup_name then
		local var_4_28 = ScriptUnit.extension_input(arg_4_0.owner_unit, "dialogue_system")
		local var_4_29 = FrameTable.alloc_table()

		var_4_29.item_type = var_4_2.pickup_name

		var_4_28:trigger_networked_dialogue_event("throwing_item", var_4_29)
	end

	if arg_4_0.ammo_extension then
		local var_4_30 = var_4_1.ammo_usage

		arg_4_0.ammo_extension:use_ammo(var_4_30)
	end
end

ActionThrow.finish = function (arg_5_0, arg_5_1)
	if arg_5_1 == "stunned" or arg_5_1 == "interacting" and not arg_5_0.thrown then
		arg_5_0:_throw()

		arg_5_0.thrown = true
	end
end
