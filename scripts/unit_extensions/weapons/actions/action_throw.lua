-- chunkname: @scripts/unit_extensions/weapons/actions/action_throw.lua

ActionThrow = class(ActionThrow, ActionBase)

ActionThrow.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionThrow.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.owner_inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
end

ActionThrow.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionThrow.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1
	self.action_time_started = arg_2_2
	self.thrown = nil
end

ActionThrow.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not self.thrown then
		return
	end

	local current_action = self.current_action

	if arg_3_2 >= self.action_time_started + current_action.throw_time then
		self:_throw()

		self.thrown = true
	end
end

ActionThrow._throw = function (self)
	-- function 4
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local projectile_info = current_action.projectile_info
	local get_first_person_unit = ScriptUnit.extension(owner_unit, "first_person_system"):get_first_person_unit()
	local var_4_4 = POSITION_LOOKUP[get_first_person_unit]
	local speed = current_action.speed
	local has_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

	if not has_extension then
		speed = has_extension:apply_buffs_to_value(speed, "throw_speed_increase")
	end

	local velocity_multiplier = current_action.velocity_multiplier

	velocity_multiplier = velocity_multiplier or 0.25

	local local_pose = Unit.local_pose(get_first_person_unit, 0)
	local local_rotation = Unit.local_rotation(get_first_person_unit, 0)
	local var_4_10 = Vector3(0, 0, 0)

	if not ScriptUnit.has_extension(owner_unit, "locomotion_system") then
		var_4_10 = ScriptUnit.extension(owner_unit, "locomotion_system"):current_velocity()
	end

	local forward = Quaternion.forward(local_rotation)
	local throw_offset = current_action.throw_offset
	local var_4_13 = Vector3(throw_offset[1], throw_offset[2], throw_offset[3])
	local num = var_4_4 + Matrix4x4.transform_without_translation(local_pose, var_4_13)
	local world_pose = Unit.world_pose(self.weapon_unit, 0)
	local angular_velocity = current_action.angular_velocity
	local var_4_17 = Vector3(angular_velocity[1], angular_velocity[2], angular_velocity[3])
	local transform_without_translation = Matrix4x4.transform_without_translation(world_pose, var_4_17)
	local normalize = Vector3.normalize
	local forward_2 = Quaternion.forward(local_rotation)
	local Vector3 = Vector3
	local num_2 = 0
	local num_3 = 0
	local uppety = current_action.uppety

	uppety = uppety or 0.6

	local num_4 = normalize(forward_2 + Vector3(num_2, num_3, uppety)) * speed + var_4_10 * velocity_multiplier
	local world_rotation = Unit.world_rotation(self.weapon_unit, 0)

	if not current_action.is_statue_and_needs_rotation_cause_reasons then
		local var_4_27 = Quaternion(Vector3.up(), -math.pi)

		world_rotation = Quaternion.multiply(world_rotation, var_4_27)
	end

	if not current_action.rotate_towards_owner_unit then
		world_rotation = Quaternion.look(Vector3.normalize(Vector3.flat(POSITION_LOOKUP[owner_unit]) - Vector3.flat(num)))
	end

	local num_5 = var_4_4 + forward * 1.2 - var_4_4
	local length = Vector3.length(num_5)
	local normalize_2 = Vector3.normalize(num_5)
	local get_data = World.get_data(self.world, "physics_world")

	if not PhysicsWorld.immediate_raycast(get_data, var_4_4, normalize_2, length, "closest", "types", "both", "collision_filter", "filter_physics_projectile_large") then
		num = var_4_4
	end

	local str = "thrown"

	ActionUtils.spawn_pickup_projectile(self.world, self.weapon_unit, projectile_info.projectile_unit_name, projectile_info.projectile_unit_template_name, current_action, owner_unit, num, world_rotation, num_4, transform_without_translation, self.item_name, str)
	Unit.set_unit_visibility(self.weapon_unit, false)
	Unit.flow_event(self.weapon_unit, "lua_unwield")

	local flag = false

	CharacterStateHelper.show_inventory_3p(owner_unit, false, flag, self.is_server, self.owner_inventory_extension)

	if projectile_info.disable_throwing_dialogue or not projectile_info.pickup_name then
		local extension_input = ScriptUnit.extension_input(self.owner_unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		alloc_table.item_type = projectile_info.pickup_name

		extension_input:trigger_networked_dialogue_event("throwing_item", alloc_table)
	end

	if not self.ammo_extension then
		local ammo_usage = current_action.ammo_usage

		self.ammo_extension:use_ammo(ammo_usage)
	end
end

ActionThrow.finish = function (self, arg_5_1)
	-- function 5
	if not (arg_5_1 == "stunned" or arg_5_1 ~= "interacting" or self.thrown) then
		self:_throw()

		self.thrown = true
	end
end
