-- chunkname: @scripts/entity_system/entity_system_bag.lua

EntitySystemBag = class()

EntitySystemBag.init = function (self)
	-- function 1
	self.systems = {}
	self.num_systems = 0
	self.systems_update = {}
	self.systems_unsafe_entity_update = {}
	self.systems_pre_update = {}
	self.systems_post_update = {}
	self.systems_physics_async_update = {}
end

EntitySystemBag.destroy = function (self)
	-- function 2
	local systems = self.systems

	for i = 1, #systems do
		local var_2_1 = systems[i]

		var_2_1:destroy()
		table.clear(var_2_1)
	end

	self.systems = nil
	self.systems_update = nil
	self.systems_unsafe_entity_update = nil
	self.systems_pre_update = nil
	self.systems_post_update = nil
	self.systems_physics_async_update = nil
end

EntitySystemBag.add_system = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_0.systems[#arg_3_0.systems + 1] = arg_3_1

	if not arg_3_1.update then
		arg_3_0.systems_update[#arg_3_0.systems_update + 1] = arg_3_1
	end

	if not arg_3_1.unsafe_entity_update then
		arg_3_0.systems_unsafe_entity_update[#arg_3_0.systems_unsafe_entity_update + 1] = arg_3_1
	end

	if not (not arg_3_1.pre_update and arg_3_2) then
		arg_3_0.systems_pre_update[#arg_3_0.systems_pre_update + 1] = arg_3_1
	end

	if not (not arg_3_1.post_update and arg_3_3) then
		arg_3_0.systems_post_update[#arg_3_0.systems_post_update + 1] = arg_3_1
	end

	if not arg_3_1.physics_async_update then
		arg_3_0.systems_physics_async_update[#arg_3_0.systems_physics_async_update + 1] = arg_3_1
	end
end

local tbl = {
	pre_update = "systems_pre_update",
	post_update = "systems_post_update",
	physics_async_update = "systems_physics_async_update",
	update = "systems_update",
	unsafe_entity_update = "systems_unsafe_entity_update"
}

EntitySystemBag.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = self[tbl[arg_4_2]]
	local t = arg_4_1.t

	for i = 1, #var_4_0 do
		local var_4_2 = var_4_0[i]

		var_4_2[arg_4_2](var_4_2, arg_4_1, t)
	end
end

EntitySystemBag.hot_join_sync = function (self, arg_5_1)
	-- function 5
	for i, v in ipairs(self.systems) do
		if not v.hot_join_sync then
			v:hot_join_sync(arg_5_1)
		end
	end
end
