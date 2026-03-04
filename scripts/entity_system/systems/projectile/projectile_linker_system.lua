-- chunkname: @scripts/entity_system/systems/projectile/projectile_linker_system.lua

require("scripts/unit_extensions/weapons/projectiles/projectile_linker_extension")

ProjectileLinkerSystem = class(ProjectileLinkerSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_link_pickup",
	"rpc_spawn_and_link_units"
}
local var_0_1 = {
	"ProjectileLinkerExtension"
}
local var_0_2 = 30

ProjectileLinkerSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	ProjectileLinkerSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.linked_projectile_units = {}
	arg_1_0.owner_units_count = 0

	arg_1_0.cb_linked_projectile_owner_destroyed = function (arg_2_0)
		for iter_2_0, iter_2_1 in pairs(arg_1_0.linked_projectile_units) do
			if iter_2_0 == arg_2_0 then
				for iter_2_2, iter_2_3 in pairs(iter_2_1) do
					if arg_1_0:_has_reference(iter_2_2) then
						arg_1_0:_remove_linked_projectile_reference(iter_2_2)
					end

					if Unit.alive(iter_2_2) then
						Managers.state.unit_spawner:mark_for_deletion(iter_2_2)
					end
				end
			end
		end

		arg_1_0.linked_projectile_units[arg_2_0] = nil
		arg_1_0.owner_units_count = arg_1_0.owner_units_count - 1
	end

	arg_1_0.cb_linked_pickup_projectile_owner_destroyed = function (arg_3_0)
		for iter_3_0, iter_3_1 in pairs(arg_1_0.linked_projectile_units) do
			if iter_3_0 == arg_3_0 then
				for iter_3_2, iter_3_3 in pairs(iter_3_1) do
					if arg_1_0:_has_reference(iter_3_2) then
						arg_1_0:_remove_linked_projectile_reference(iter_3_2)
					end

					local var_3_0 = ScriptUnit.has_extension(iter_3_0, "projectile_linker_system")

					if var_3_0 then
						var_3_0:unlink_projectile(iter_3_2)
					end

					if Unit.alive(iter_3_2) then
						local var_3_1 = ScriptUnit.has_extension(iter_3_2, "pickup_system")

						if var_3_1 then
							var_3_1:set_physics_enabled(true)
						end
					end
				end
			end
		end

		arg_1_0.linked_projectile_units[arg_3_0] = nil
		arg_1_0.owner_units_count = arg_1_0.owner_units_count - 1
	end

	arg_1_0.cb_linked_projectile_timeout = function (arg_4_0, arg_4_1)
		if arg_1_0:_has_reference(arg_4_1) then
			arg_1_0:_remove_linked_projectile_reference(arg_4_1)
		end

		if Unit.alive(arg_4_1) then
			Managers.state.unit_spawner:mark_for_deletion(arg_4_1)
		end
	end

	arg_1_0.cb_linked_pickup_projectile_timeout = function (arg_5_0, arg_5_1)
		if arg_1_0:_has_reference(arg_5_1) then
			arg_1_0:_remove_linked_projectile_reference(arg_5_1)
		end

		local var_5_0 = ScriptUnit.has_extension(arg_5_0, "projectile_linker_system")

		if var_5_0 then
			var_5_0:unlink_projectile(arg_5_1)
		end

		if Unit.alive(arg_5_1) then
			local var_5_1 = ScriptUnit.has_extension(arg_5_1, "pickup_system")

			if var_5_1 then
				var_5_1:set_physics_enabled(true)
			end

			if Unit.find_actor(arg_5_1, "throw") then
				Unit.create_actor(arg_5_1, "throw")
			end
		end
	end
end

ProjectileLinkerSystem.on_remove_extension = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:clear_linked_projectiles(arg_6_1)

	return ProjectileLinkerSystem.super.on_remove_extension(arg_6_0, arg_6_1, arg_6_2)
end

ProjectileLinkerSystem.freeze = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0:clear_linked_projectiles(arg_7_1)
end

ProjectileLinkerSystem.clear_linked_projectiles = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.linked_projectile_units[arg_8_1]

	if not var_8_0 then
		return
	end

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		iter_8_1.cb_timeout(arg_8_1, iter_8_0)
	end
end

local var_0_3 = {}

ProjectileLinkerSystem.update = function (arg_9_0, arg_9_1, arg_9_2)
	ProjectileLinkerSystem.super.update(arg_9_0, arg_9_1, arg_9_2)

	local var_9_0 = arg_9_0.linked_projectile_units

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		for iter_9_2, iter_9_3 in pairs(iter_9_1) do
			if arg_9_2 >= iter_9_3.end_time then
				var_0_3[iter_9_2] = {
					cb_function = iter_9_3.cb_timeout,
					owner_unit = iter_9_0
				}
			end
		end
	end

	for iter_9_4, iter_9_5 in pairs(var_0_3) do
		iter_9_5.cb_function(iter_9_5.owner_unit, iter_9_4)
	end

	table.clear(var_0_3)
end

ProjectileLinkerSystem.destroy = function (arg_10_0)
	arg_10_0.network_event_delegate:unregister(arg_10_0)
end

ProjectileLinkerSystem.add_linked_projectile_reference = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = Managers.time:time("game")

	if not arg_11_0.linked_projectile_units[arg_11_1] then
		arg_11_0.linked_projectile_units[arg_11_1] = {}
		arg_11_0.owner_units_count = arg_11_0.owner_units_count + 1

		if arg_11_5 then
			Managers.state.unit_spawner:add_destroy_listener(arg_11_1, "linked_projectile_owner_" .. arg_11_0.owner_units_count, arg_11_0[arg_11_3 or "cb_linked_projectile_owner_destroyed"])
		end
	end

	arg_11_0.linked_projectile_units[arg_11_1][arg_11_2] = {
		end_time = var_11_0 + var_0_2,
		cb_timeout = arg_11_0[arg_11_4 or "cb_linked_projectile_timeout"]
	}
end

ProjectileLinkerSystem._remove_linked_projectile_reference = function (arg_12_0, arg_12_1)
	for iter_12_0, iter_12_1 in pairs(arg_12_0.linked_projectile_units) do
		iter_12_1[arg_12_1] = nil
	end
end

ProjectileLinkerSystem._has_reference = function (arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.linked_projectile_units) do
		if iter_13_1[arg_13_1] then
			return true
		end
	end

	return false
end

ProjectileLinkerSystem.link_pickup = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	if Unit.actor(arg_14_1, "throw") then
		Unit.destroy_actor(arg_14_1, "throw")
	end

	if ScriptUnit.has_extension(arg_14_4, "projectile_linker_system") then
		local var_14_0 = Unit.world_rotation(arg_14_4, arg_14_5)
		local var_14_1 = arg_14_2 - Unit.world_position(arg_14_4, arg_14_5)
		local var_14_2 = Vector3(Vector3.dot(Quaternion.right(var_14_0), var_14_1), Vector3.dot(Quaternion.forward(var_14_0), var_14_1), Vector3.dot(Quaternion.up(var_14_0), var_14_1))

		ScriptUnit.extension(arg_14_4, "projectile_linker_system"):link_projectile(arg_14_1, var_14_2, arg_14_3, arg_14_5)
		arg_14_0:add_linked_projectile_reference(arg_14_4, arg_14_1, "cb_linked_pickup_projectile_owner_destroyed", "cb_linked_pickup_projectile_timeout", arg_14_0.is_server)
	else
		arg_14_0:add_linked_projectile_reference(arg_14_4, arg_14_1, "cb_linked_pickup_projectile_owner_destroyed", "cb_linked_pickup_projectile_timeout", arg_14_0.is_server)
	end
end

ProjectileLinkerSystem.rpc_link_pickup = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
	local var_15_0 = Managers.state.unit_storage:unit(arg_15_2)
	local var_15_1 = Managers.state.network:game_object_or_level_unit(arg_15_5, arg_15_7)

	if not Unit.alive(var_15_0) or not Unit.alive(var_15_1) then
		return
	end

	arg_15_0:link_pickup(var_15_0, arg_15_3, arg_15_4, var_15_1, arg_15_6)
end

ProjectileLinkerSystem.spawn_and_link_units = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	local var_16_0 = Managers.state.unit_spawner

	if ScriptUnit.has_extension(arg_16_4, "projectile_linker_system") then
		local var_16_1 = var_16_0:spawn_local_unit(arg_16_1, arg_16_2, arg_16_3)
		local var_16_2 = Unit.world_rotation(arg_16_4, arg_16_5)
		local var_16_3 = arg_16_2 - Unit.world_position(arg_16_4, arg_16_5)
		local var_16_4 = Vector3(Vector3.dot(Quaternion.right(var_16_2), var_16_3), Vector3.dot(Quaternion.forward(var_16_2), var_16_3), Vector3.dot(Quaternion.up(var_16_2), var_16_3))

		ScriptUnit.extension(arg_16_4, "projectile_linker_system"):link_projectile(var_16_1, var_16_4, arg_16_3, arg_16_5)
		arg_16_0:add_linked_projectile_reference(arg_16_4, var_16_1)
	else
		local var_16_5 = var_16_0:spawn_local_unit(arg_16_1, arg_16_2, arg_16_3)

		arg_16_0:add_linked_projectile_reference(arg_16_4, var_16_5)
	end
end

ProjectileLinkerSystem.rpc_spawn_and_link_units = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	local var_17_0 = Managers.state.network:game_object_or_level_unit(arg_17_5, arg_17_7)
	local var_17_1 = NetworkLookup.husks[arg_17_2]

	arg_17_0:spawn_and_link_units(var_17_1, arg_17_3, arg_17_4, var_17_0, arg_17_6)
end
