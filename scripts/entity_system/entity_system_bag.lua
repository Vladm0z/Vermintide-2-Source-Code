-- chunkname: @scripts/entity_system/entity_system_bag.lua

EntitySystemBag = class()

function EntitySystemBag.init(arg_1_0)
	arg_1_0.systems = {}
	arg_1_0.num_systems = 0
	arg_1_0.systems_update = {}
	arg_1_0.systems_unsafe_entity_update = {}
	arg_1_0.systems_pre_update = {}
	arg_1_0.systems_post_update = {}
	arg_1_0.systems_physics_async_update = {}
end

function EntitySystemBag.destroy(arg_2_0)
	local var_2_0 = arg_2_0.systems

	for iter_2_0 = 1, #var_2_0 do
		local var_2_1 = var_2_0[iter_2_0]

		var_2_1:destroy()
		table.clear(var_2_1)
	end

	arg_2_0.systems = nil
	arg_2_0.systems_update = nil
	arg_2_0.systems_unsafe_entity_update = nil
	arg_2_0.systems_pre_update = nil
	arg_2_0.systems_post_update = nil
	arg_2_0.systems_physics_async_update = nil
end

function EntitySystemBag.add_system(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.systems[#arg_3_0.systems + 1] = arg_3_1

	if arg_3_1.update then
		arg_3_0.systems_update[#arg_3_0.systems_update + 1] = arg_3_1
	end

	if arg_3_1.unsafe_entity_update then
		arg_3_0.systems_unsafe_entity_update[#arg_3_0.systems_unsafe_entity_update + 1] = arg_3_1
	end

	if arg_3_1.pre_update and not arg_3_2 then
		arg_3_0.systems_pre_update[#arg_3_0.systems_pre_update + 1] = arg_3_1
	end

	if arg_3_1.post_update and not arg_3_3 then
		arg_3_0.systems_post_update[#arg_3_0.systems_post_update + 1] = arg_3_1
	end

	if arg_3_1.physics_async_update then
		arg_3_0.systems_physics_async_update[#arg_3_0.systems_physics_async_update + 1] = arg_3_1
	end
end

local var_0_0 = {
	pre_update = "systems_pre_update",
	post_update = "systems_post_update",
	physics_async_update = "systems_physics_async_update",
	update = "systems_update",
	unsafe_entity_update = "systems_unsafe_entity_update"
}

function EntitySystemBag.update(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0[var_0_0[arg_4_2]]
	local var_4_1 = arg_4_1.t

	for iter_4_0 = 1, #var_4_0 do
		local var_4_2 = var_4_0[iter_4_0]

		var_4_2[arg_4_2](var_4_2, arg_4_1, var_4_1)
	end
end

function EntitySystemBag.hot_join_sync(arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in ipairs(arg_5_0.systems) do
		if iter_5_1.hot_join_sync then
			iter_5_1:hot_join_sync(arg_5_1)
		end
	end
end
