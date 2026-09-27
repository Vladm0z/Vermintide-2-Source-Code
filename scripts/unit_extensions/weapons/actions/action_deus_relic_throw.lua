-- chunkname: @scripts/unit_extensions/weapons/actions/action_deus_relic_throw.lua

ActionDeusRelicThrow = class(ActionDeusRelicThrow, ActionThrow)

ActionDeusRelicThrow._throw = function (self)
	-- function 1
	local weapon_unit = self.weapon_unit

	Unit.set_unit_visibility(weapon_unit, false)
	Unit.flow_event(weapon_unit, "lua_unwield")

	local owner_unit = self.owner_unit
	local flag = false

	CharacterStateHelper.show_inventory_3p(owner_unit, false, flag, self.is_server, self.owner_inventory_extension)

	local current_action = self.current_action
	local get_first_person_unit = ScriptUnit.extension(owner_unit, "first_person_system"):get_first_person_unit()
	local var_1_5 = POSITION_LOOKUP[get_first_person_unit]
	local local_pose = Unit.local_pose(get_first_person_unit, 0)
	local throw_offset = current_action.throw_offset
	local var_1_8 = Vector3(throw_offset[1], throw_offset[2], throw_offset[3])
	local num = var_1_5 + Matrix4x4.transform_without_translation(local_pose, var_1_8)
	local world_rotation = Unit.world_rotation(weapon_unit, 0)

	if not current_action.is_statue_and_needs_rotation_cause_reasons then
		local var_1_11 = Quaternion(Vector3.up(), -math.pi)

		world_rotation = Quaternion.multiply(world_rotation, var_1_11)
	end

	if not current_action.rotate_towards_owner_unit then
		world_rotation = Quaternion.look(Vector3.normalize(Vector3.flat(POSITION_LOOKUP[owner_unit]) - Vector3.flat(num)))
	end

	local projectile_info = current_action.projectile_info
	local str = "thrown"
	local speed = current_action.speed
	local has_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

	if not has_extension then
		speed = has_extension:apply_buffs_to_value(speed, "throw_speed_increase")
	end

	local velocity_multiplier = current_action.velocity_multiplier

	velocity_multiplier = velocity_multiplier or 0.25

	local local_rotation = Unit.local_rotation(get_first_person_unit, 0)
	local var_1_18 = Vector3(0, 0, 0)

	if not ScriptUnit.has_extension(owner_unit, "locomotion_system") then
		var_1_18 = ScriptUnit.extension(owner_unit, "locomotion_system"):current_velocity()
	end

	local world_pose = Unit.world_pose(self.weapon_unit, 0)
	local angular_velocity = current_action.angular_velocity
	local var_1_21 = Vector3(angular_velocity[1], angular_velocity[2], angular_velocity[3])
	local transform_without_translation = Matrix4x4.transform_without_translation(world_pose, var_1_21)
	local normalize = Vector3.normalize
	local forward = Quaternion.forward(local_rotation)
	local Vector3 = Vector3
	local num_2 = 0
	local num_3 = 0
	local uppety = current_action.uppety

	uppety = uppety or 0.6

	local num_4 = normalize(forward + Vector3(num_2, num_3, uppety)) * speed + var_1_18 * velocity_multiplier

	ActionUtils.spawn_pickup_projectile(self.world, weapon_unit, projectile_info.projectile_unit_name, projectile_info.projectile_unit_template_name, current_action, owner_unit, num, world_rotation, num_4, transform_without_translation, self.item_name, str)

	local has_extension_2 = ScriptUnit.has_extension(self.owner_unit, "status_system")

	self.owner_inventory_extension:destroy_slot("slot_level_event", false, true)

	if not (not has_extension_2 and CharacterStateHelper.pack_master_status(has_extension_2)) then
		self.owner_inventory_extension:wield_previous_weapon()
	end
end
