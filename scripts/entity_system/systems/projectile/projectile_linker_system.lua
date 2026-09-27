-- chunkname: @scripts/entity_system/systems/projectile/projectile_linker_system.lua

require("scripts/unit_extensions/weapons/projectiles/projectile_linker_extension")

ProjectileLinkerSystem = class(ProjectileLinkerSystem, ExtensionSystemBase)

local tbl = {
	"rpc_link_pickup",
	"rpc_spawn_and_link_units"
}
local tbl_2 = {
	"ProjectileLinkerExtension"
}
local num = 30

ProjectileLinkerSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	ProjectileLinkerSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.linked_projectile_units = {}
	self.owner_units_count = 0

	self.cb_linked_projectile_owner_destroyed = function (arg_2_0)
		-- function 2
		for k, v in pairs(self.linked_projectile_units) do
			if k == arg_2_0 then
				for k_2, v_2 in pairs(v) do
					if not self:_has_reference(k_2) then
						self:_remove_linked_projectile_reference(k_2)
					end

					if not Unit.alive(k_2) then
						Managers.state.unit_spawner:mark_for_deletion(k_2)
					end
				end
			end
		end

		self.linked_projectile_units[arg_2_0] = nil
		self.owner_units_count = self.owner_units_count - 1
	end

	self.cb_linked_pickup_projectile_owner_destroyed = function (arg_3_0)
		-- function 3
		for k, v in pairs(self.linked_projectile_units) do
			if k == arg_3_0 then
				for k_2, v_2 in pairs(v) do
					if not self:_has_reference(k_2) then
						self:_remove_linked_projectile_reference(k_2)
					end

					local has_extension = ScriptUnit.has_extension(k, "projectile_linker_system")

					if not has_extension then
						has_extension:unlink_projectile(k_2)
					end

					if not Unit.alive(k_2) then
						local has_extension_2 = ScriptUnit.has_extension(k_2, "pickup_system")

						if not has_extension_2 then
							has_extension_2:set_physics_enabled(true)
						end
					end
				end
			end
		end

		self.linked_projectile_units[arg_3_0] = nil
		self.owner_units_count = self.owner_units_count - 1
	end

	self.cb_linked_projectile_timeout = function (arg_4_0, arg_4_1)
		-- function 4
		if not self:_has_reference(arg_4_1) then
			self:_remove_linked_projectile_reference(arg_4_1)
		end

		if not Unit.alive(arg_4_1) then
			Managers.state.unit_spawner:mark_for_deletion(arg_4_1)
		end
	end

	self.cb_linked_pickup_projectile_timeout = function (arg_5_0, arg_5_1)
		-- function 5
		if not self:_has_reference(arg_5_1) then
			self:_remove_linked_projectile_reference(arg_5_1)
		end

		local has_extension = ScriptUnit.has_extension(arg_5_0, "projectile_linker_system")

		if not has_extension then
			has_extension:unlink_projectile(arg_5_1)
		end

		if not Unit.alive(arg_5_1) then
			local has_extension_2 = ScriptUnit.has_extension(arg_5_1, "pickup_system")

			if not has_extension_2 then
				has_extension_2:set_physics_enabled(true)
			end

			if not Unit.find_actor(arg_5_1, "throw") then
				Unit.create_actor(arg_5_1, "throw")
			end
		end
	end
end

ProjectileLinkerSystem.on_remove_extension = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:clear_linked_projectiles(arg_6_1)

	return ProjectileLinkerSystem.super.on_remove_extension(self, arg_6_1, arg_6_2)
end

ProjectileLinkerSystem.freeze = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	self:clear_linked_projectiles(arg_7_1)
end

ProjectileLinkerSystem.clear_linked_projectiles = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self.linked_projectile_units[arg_8_1]

	if not var_8_0 then
		return
	end

	for k, v in pairs(var_8_0) do
		v.cb_timeout(arg_8_1, k)
	end
end

local tbl_3 = {}

ProjectileLinkerSystem.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	ProjectileLinkerSystem.super.update(self, arg_9_1, arg_9_2)

	local linked_projectile_units = self.linked_projectile_units

	for k, v in pairs(linked_projectile_units) do
		for k_2, v_2 in pairs(v) do
			if arg_9_2 >= v_2.end_time then
				tbl_3[k_2] = {
					cb_function = v_2.cb_timeout,
					owner_unit = k
				}
			end
		end
	end

	for k_3, v_3 in pairs(tbl_3) do
		v_3.cb_function(v_3.owner_unit, k_3)
	end

	table.clear(tbl_3)
end

ProjectileLinkerSystem.destroy = function (self)
	-- function 10
	self.network_event_delegate:unregister(self)
end

ProjectileLinkerSystem.add_linked_projectile_reference = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local time = Managers.time:time("game")

	if not self.linked_projectile_units[arg_11_1] then
		self.linked_projectile_units[arg_11_1] = {}
		self.owner_units_count = self.owner_units_count + 1

		if not arg_11_5 then
			Managers.state.unit_spawner:add_destroy_listener(arg_11_1, "linked_projectile_owner_" .. self.owner_units_count, self[arg_11_3 or "cb_linked_projectile_owner_destroyed"])
		end
	end

	self.linked_projectile_units[arg_11_1][arg_11_2] = {
		end_time = time + num,
		cb_timeout = self[arg_11_4 or "cb_linked_projectile_timeout"]
	}
end

ProjectileLinkerSystem._remove_linked_projectile_reference = function (self, arg_12_1)
	-- function 12
	for k, v in pairs(self.linked_projectile_units) do
		v[arg_12_1] = nil
	end
end

ProjectileLinkerSystem._has_reference = function (self, arg_13_1)
	-- function 13
	for k, v in pairs(self.linked_projectile_units) do
		if not v[arg_13_1] then
			return true
		end
	end

	return false
end

ProjectileLinkerSystem.link_pickup = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	if not Unit.actor(arg_14_1, "throw") then
		Unit.destroy_actor(arg_14_1, "throw")
	end

	if not ScriptUnit.has_extension(arg_14_4, "projectile_linker_system") then
		local world_rotation = Unit.world_rotation(arg_14_4, arg_14_5)
		local num = arg_14_2 - Unit.world_position(arg_14_4, arg_14_5)
		local var_14_2 = Vector3(Vector3.dot(Quaternion.right(world_rotation), num), Vector3.dot(Quaternion.forward(world_rotation), num), Vector3.dot(Quaternion.up(world_rotation), num))

		ScriptUnit.extension(arg_14_4, "projectile_linker_system"):link_projectile(arg_14_1, var_14_2, arg_14_3, arg_14_5)
		self:add_linked_projectile_reference(arg_14_4, arg_14_1, "cb_linked_pickup_projectile_owner_destroyed", "cb_linked_pickup_projectile_timeout", self.is_server)
	else
		self:add_linked_projectile_reference(arg_14_4, arg_14_1, "cb_linked_pickup_projectile_owner_destroyed", "cb_linked_pickup_projectile_timeout", self.is_server)
	end
end

ProjectileLinkerSystem.rpc_link_pickup = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
	-- function 15
	local unit = Managers.state.unit_storage:unit(arg_15_2)
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_15_5, arg_15_7)

	if not (not Unit.alive(unit) and Unit.alive(game_object_or_level_unit)) then
		return
	end

	self:link_pickup(unit, arg_15_3, arg_15_4, game_object_or_level_unit, arg_15_6)
end

ProjectileLinkerSystem.spawn_and_link_units = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	local unit_spawner = Managers.state.unit_spawner

	if not ScriptUnit.has_extension(arg_16_4, "projectile_linker_system") then
		local spawn_local_unit = unit_spawner:spawn_local_unit(arg_16_1, arg_16_2, arg_16_3)
		local world_rotation = Unit.world_rotation(arg_16_4, arg_16_5)
		local num = arg_16_2 - Unit.world_position(arg_16_4, arg_16_5)
		local var_16_4 = Vector3(Vector3.dot(Quaternion.right(world_rotation), num), Vector3.dot(Quaternion.forward(world_rotation), num), Vector3.dot(Quaternion.up(world_rotation), num))

		ScriptUnit.extension(arg_16_4, "projectile_linker_system"):link_projectile(spawn_local_unit, var_16_4, arg_16_3, arg_16_5)
		self:add_linked_projectile_reference(arg_16_4, spawn_local_unit)
	else
		local spawn_local_unit_2 = unit_spawner:spawn_local_unit(arg_16_1, arg_16_2, arg_16_3)

		self:add_linked_projectile_reference(arg_16_4, spawn_local_unit_2)
	end
end

ProjectileLinkerSystem.rpc_spawn_and_link_units = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	-- function 17
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_17_5, arg_17_7)
	local var_17_1 = NetworkLookup.husks[arg_17_2]

	self:spawn_and_link_units(var_17_1, arg_17_3, arg_17_4, game_object_or_level_unit, arg_17_6)
end
