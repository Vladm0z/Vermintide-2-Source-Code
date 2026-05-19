-- chunkname: @scripts/network/unit_storage.lua

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	fassert(arg_1_1 and arg_1_2, "bimap_add, nil arguments")
	fassert(not arg_1_0[arg_1_1] and not arg_1_0[arg_1_2], "bimap_add, already contained a and/or b")

	arg_1_0[arg_1_1], arg_1_0[arg_1_2] = arg_1_2, arg_1_1
end

local function var_0_1(arg_2_0, arg_2_1)
	fassert(arg_2_1, "bimap_add, nil argument")

	local var_2_0 = arg_2_0[arg_2_1]

	fassert(var_2_0, "bimap_remove, didn't contain item")

	arg_2_0[arg_2_1], arg_2_0[var_2_0] = nil
end

local var_0_2 = type

NetworkUnitStorage = class(NetworkUnitStorage)

function NetworkUnitStorage.init(arg_3_0)
	arg_3_0.bimap_goid_unit = {}
	arg_3_0.frozen_bimap_goid_unit = {}
	arg_3_0.map_goid_to_unit = {}
	arg_3_0.map_goid_to_gotype = {}
	arg_3_0.map_goid_to_owner = {}
	arg_3_0.owner_goid_array = {}
end

function NetworkUnitStorage.freeze(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.bimap_goid_unit[arg_4_1]

	var_0_0(arg_4_0.frozen_bimap_goid_unit, arg_4_1, var_4_0)
	var_0_1(arg_4_0.bimap_goid_unit, arg_4_1)
end

function NetworkUnitStorage.unfreeze(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.frozen_bimap_goid_unit[arg_5_1]

	var_0_1(arg_5_0.frozen_bimap_goid_unit, arg_5_1)
	var_0_0(arg_5_0.bimap_goid_unit, arg_5_1, var_5_0)
end

function NetworkUnitStorage.units(arg_6_0)
	return arg_6_0.map_goid_to_unit
end

function NetworkUnitStorage.go_id(arg_7_0, arg_7_1)
	fassert(var_0_2(arg_7_1) ~= "number", "Not allowed to pass in a go_id here anymore.")

	return arg_7_0.bimap_goid_unit[arg_7_1]
end

function NetworkUnitStorage.unit(arg_8_0, arg_8_1)
	fassert(var_0_2(arg_8_1) ~= "userdata", "Not allowed to pass in a unit here anymore.")

	return arg_8_0.bimap_goid_unit[arg_8_1]
end

function NetworkUnitStorage.remove(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:remove_owner(arg_9_1, arg_9_2)

	arg_9_0.map_goid_to_gotype[arg_9_2] = nil
	arg_9_0.map_goid_to_unit[arg_9_2] = nil

	if arg_9_0.frozen_bimap_goid_unit[arg_9_1] then
		var_0_1(arg_9_0.frozen_bimap_goid_unit, arg_9_1)
	else
		var_0_1(arg_9_0.bimap_goid_unit, arg_9_1)
	end

	NetworkUnit.reset_unit(arg_9_1)
end

function NetworkUnitStorage.remove_owner(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.map_goid_to_owner[arg_10_2]

	if var_10_0 then
		arg_10_0.owner_goid_array[var_10_0][arg_10_2] = nil
		arg_10_0.map_goid_to_owner[arg_10_2] = nil
	end

	NetworkUnit.set_owner_peer_id(arg_10_1, nil)
end

function NetworkUnitStorage.set_owner(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_0:remove_owner(arg_11_1, arg_11_2)

	local var_11_0 = arg_11_0.owner_goid_array[arg_11_3]

	if not var_11_0 then
		var_11_0 = {}
		arg_11_0.owner_goid_array[arg_11_3] = var_11_0
	end

	var_11_0[arg_11_2] = arg_11_1
	arg_11_0.map_goid_to_owner[arg_11_2] = arg_11_3

	NetworkUnit.set_owner_peer_id(arg_11_1, arg_11_3)
end

function NetworkUnitStorage.owner(arg_12_0, arg_12_1)
	return arg_12_0.map_goid_to_owner[arg_12_1]
end

function NetworkUnitStorage.add_unit(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	fassert(arg_13_2 ~= NetworkConstants.invalid_game_object_id, "invalid go_id")

	arg_13_0.map_goid_to_unit[arg_13_2] = arg_13_1

	var_0_0(arg_13_0.bimap_goid_unit, arg_13_1, arg_13_2)
	NetworkUnit.set_game_object_id(arg_13_1, arg_13_2)

	if arg_13_3 then
		arg_13_0:set_owner(arg_13_1, arg_13_2, arg_13_3)
	end
end

function NetworkUnitStorage.add_unit_info(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	arg_14_0.map_goid_to_gotype[arg_14_2] = arg_14_3

	NetworkUnit.set_game_object_type(arg_14_1, arg_14_3)
	arg_14_0:add_unit(arg_14_1, arg_14_2, arg_14_4)
end

function NetworkUnitStorage.go_type(arg_15_0, arg_15_1)
	return arg_15_0.map_goid_to_gotype[arg_15_1]
end

function NetworkUnitStorage.transfer_go_id(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.bimap_goid_unit
	local var_16_1 = var_16_0[arg_16_1]

	var_16_0[arg_16_2] = var_16_1
	var_16_0[var_16_1] = arg_16_2
	var_16_0[arg_16_1] = nil
	arg_16_0.map_goid_to_unit[var_16_1] = arg_16_2

	NetworkUnit.transfer_unit(arg_16_1, arg_16_2)
end
