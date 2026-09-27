-- chunkname: @scripts/network/unit_storage.lua

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	fassert(not arg_1_1 and arg_1_2, "bimap_add, nil arguments")
	fassert(not not self[arg_1_1] or not self[arg_1_2], "bimap_add, already contained a and/or b")

	self[arg_1_1], self[arg_1_2] = arg_1_2, arg_1_1
end

local function fn_2(self, arg_2_1)
	-- function 2
	fassert(arg_2_1, "bimap_add, nil argument")

	local var_2_0 = self[arg_2_1]

	fassert(var_2_0, "bimap_remove, didn't contain item")

	self[arg_2_1], self[var_2_0] = nil
end

local type = type

NetworkUnitStorage = class(NetworkUnitStorage)

NetworkUnitStorage.init = function (self)
	-- function 3
	self.bimap_goid_unit = {}
	self.frozen_bimap_goid_unit = {}
	self.map_goid_to_unit = {}
	self.map_goid_to_gotype = {}
	self.map_goid_to_owner = {}
	self.owner_goid_array = {}
end

NetworkUnitStorage.freeze = function (self, arg_4_1)
	-- function 4
	local var_4_0 = self.bimap_goid_unit[arg_4_1]

	fn(self.frozen_bimap_goid_unit, arg_4_1, var_4_0)
	fn_2(self.bimap_goid_unit, arg_4_1)
end

NetworkUnitStorage.unfreeze = function (self, arg_5_1)
	-- function 5
	local var_5_0 = self.frozen_bimap_goid_unit[arg_5_1]

	fn_2(self.frozen_bimap_goid_unit, arg_5_1)
	fn(self.bimap_goid_unit, arg_5_1, var_5_0)
end

NetworkUnitStorage.units = function (self)
	-- function 6
	return self.map_goid_to_unit
end

NetworkUnitStorage.go_id = function (self, arg_7_1)
	-- function 7
	fassert(type(arg_7_1) ~= "number", "Not allowed to pass in a go_id here anymore.")

	return self.bimap_goid_unit[arg_7_1]
end

NetworkUnitStorage.unit = function (self, arg_8_1)
	-- function 8
	fassert(type(arg_8_1) ~= "userdata", "Not allowed to pass in a unit here anymore.")

	return self.bimap_goid_unit[arg_8_1]
end

NetworkUnitStorage.remove = function (self, arg_9_1, arg_9_2)
	-- function 9
	self:remove_owner(arg_9_1, arg_9_2)

	self.map_goid_to_gotype[arg_9_2] = nil
	self.map_goid_to_unit[arg_9_2] = nil

	if not self.frozen_bimap_goid_unit[arg_9_1] then
		fn_2(self.frozen_bimap_goid_unit, arg_9_1)
	else
		fn_2(self.bimap_goid_unit, arg_9_1)
	end

	NetworkUnit.reset_unit(arg_9_1)
end

NetworkUnitStorage.remove_owner = function (self, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = self.map_goid_to_owner[arg_10_2]

	if not var_10_0 then
		self.owner_goid_array[var_10_0][arg_10_2] = nil
		self.map_goid_to_owner[arg_10_2] = nil
	end

	NetworkUnit.set_owner_peer_id(arg_10_1, nil)
end

NetworkUnitStorage.set_owner = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	self:remove_owner(arg_11_1, arg_11_2)

	local var_11_0 = self.owner_goid_array[arg_11_3]

	if not var_11_0 then
		var_11_0 = {}
		self.owner_goid_array[arg_11_3] = var_11_0
	end

	var_11_0[arg_11_2] = arg_11_1
	self.map_goid_to_owner[arg_11_2] = arg_11_3

	NetworkUnit.set_owner_peer_id(arg_11_1, arg_11_3)
end

NetworkUnitStorage.owner = function (self, arg_12_1)
	-- function 12
	return self.map_goid_to_owner[arg_12_1]
end

NetworkUnitStorage.add_unit = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	fassert(arg_13_2 ~= NetworkConstants.invalid_game_object_id, "invalid go_id")

	self.map_goid_to_unit[arg_13_2] = arg_13_1

	fn(self.bimap_goid_unit, arg_13_1, arg_13_2)
	NetworkUnit.set_game_object_id(arg_13_1, arg_13_2)

	if not arg_13_3 then
		self:set_owner(arg_13_1, arg_13_2, arg_13_3)
	end
end

NetworkUnitStorage.add_unit_info = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	self.map_goid_to_gotype[arg_14_2] = arg_14_3

	NetworkUnit.set_game_object_type(arg_14_1, arg_14_3)
	self:add_unit(arg_14_1, arg_14_2, arg_14_4)
end

NetworkUnitStorage.go_type = function (self, arg_15_1)
	-- function 15
	return self.map_goid_to_gotype[arg_15_1]
end

NetworkUnitStorage.transfer_go_id = function (self, arg_16_1, arg_16_2)
	-- function 16
	local bimap_goid_unit = self.bimap_goid_unit
	local var_16_1 = bimap_goid_unit[arg_16_1]

	bimap_goid_unit[arg_16_2] = var_16_1
	bimap_goid_unit[var_16_1] = arg_16_2
	bimap_goid_unit[arg_16_1] = nil
	self.map_goid_to_unit[var_16_1] = arg_16_2

	NetworkUnit.transfer_unit(arg_16_1, arg_16_2)
end
