-- chunkname: @scripts/unit_extensions/weapons/actions/action_deus_relic_throw.lua

ActionDeusRelicThrow = class(ActionDeusRelicThrow, ActionThrow)

ActionDeusRelicThrow._throw = function (arg_1_0)
	local var_1_0 = arg_1_0.weapon_unit

	Unit.set_unit_visibility(var_1_0, false)
	Unit.flow_event(var_1_0, "lua_unwield")

	local var_1_1 = arg_1_0.owner_unit
	local var_1_2 = false

	CharacterStateHelper.show_inventory_3p(var_1_1, false, var_1_2, arg_1_0.is_server, arg_1_0.owner_inventory_extension)

	local var_1_3 = arg_1_0.current_action
	local var_1_4 = ScriptUnit.extension(var_1_1, "first_person_system"):get_first_person_unit()
	local var_1_5 = POSITION_LOOKUP[var_1_4]
	local var_1_6 = Unit.local_pose(var_1_4, 0)
	local var_1_7 = var_1_3.throw_offset
	local var_1_8 = Vector3(var_1_7[1], var_1_7[2], var_1_7[3])
	local var_1_9 = var_1_5 + Matrix4x4.transform_without_translation(var_1_6, var_1_8)
	local var_1_10 = Unit.world_rotation(var_1_0, 0)

	if var_1_3.is_statue_and_needs_rotation_cause_reasons then
		local var_1_11 = Quaternion(Vector3.up(), -math.pi)

		var_1_10 = Quaternion.multiply(var_1_10, var_1_11)
	end

	if var_1_3.rotate_towards_owner_unit then
		var_1_10 = Quaternion.look(Vector3.normalize(Vector3.flat(POSITION_LOOKUP[var_1_1]) - Vector3.flat(var_1_9)))
	end

	local var_1_12 = var_1_3.projectile_info
	local var_1_13 = "thrown"
	local var_1_14 = var_1_3.speed
	local var_1_15 = ScriptUnit.has_extension(var_1_1, "buff_system")

	if var_1_15 then
		var_1_14 = var_1_15:apply_buffs_to_value(var_1_14, "throw_speed_increase")
	end

	local var_1_16 = var_1_3.velocity_multiplier or 0.25
	local var_1_17 = Unit.local_rotation(var_1_4, 0)
	local var_1_18 = Vector3(0, 0, 0)

	if ScriptUnit.has_extension(var_1_1, "locomotion_system") then
		var_1_18 = ScriptUnit.extension(var_1_1, "locomotion_system"):current_velocity()
	end

	local var_1_19 = Unit.world_pose(arg_1_0.weapon_unit, 0)
	local var_1_20 = var_1_3.angular_velocity
	local var_1_21 = Vector3(var_1_20[1], var_1_20[2], var_1_20[3])
	local var_1_22 = Matrix4x4.transform_without_translation(var_1_19, var_1_21)
	local var_1_23 = Vector3.normalize(Quaternion.forward(var_1_17) + Vector3(0, 0, var_1_3.uppety or 0.6)) * var_1_14 + var_1_18 * var_1_16

	ActionUtils.spawn_pickup_projectile(arg_1_0.world, var_1_0, var_1_12.projectile_unit_name, var_1_12.projectile_unit_template_name, var_1_3, var_1_1, var_1_9, var_1_10, var_1_23, var_1_22, arg_1_0.item_name, var_1_13)

	local var_1_24 = ScriptUnit.has_extension(arg_1_0.owner_unit, "status_system")

	arg_1_0.owner_inventory_extension:destroy_slot("slot_level_event", false, true)

	if not (var_1_24 and CharacterStateHelper.pack_master_status(var_1_24)) then
		arg_1_0.owner_inventory_extension:wield_previous_weapon()
	end
end
