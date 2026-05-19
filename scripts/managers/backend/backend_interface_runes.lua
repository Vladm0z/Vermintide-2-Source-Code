-- chunkname: @scripts/managers/backend/backend_interface_runes.lua

BackendInterfaceRunes = class(BackendInterfaceRunes)

local var_0_0 = "runes_"
local var_0_1 = "runes"
local var_0_2 = "rune_"

function BackendInterfaceRunes.init(arg_1_0)
	return
end

function BackendInterfaceRunes._refresh_attributes(arg_2_0)
	local var_2_0 = Backend.get_entities_with_attributes(var_0_1)
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		local var_2_2 = iter_2_1.entity_name
		local var_2_3 = iter_2_1.runes

		var_2_3.entity_id = iter_2_0
		var_2_1[var_2_2] = var_2_3
	end

	arg_2_0._runes = var_2_1
end

function BackendInterfaceRunes.on_authenticated(arg_3_0)
	arg_3_0:_refresh_attributes()
end

function BackendInterfaceRunes.get(arg_4_0, arg_4_1)
	local var_4_0 = var_0_0 .. arg_4_1
	local var_4_1 = arg_4_0._runes[var_4_0]

	if not var_4_1 then
		Application.warning(string.format("[BackendInterfaceRunes:get] Tried to get undefined rune %q", var_4_0))

		return
	end

	return (cjson.decode(var_4_1))
end

function BackendInterfaceRunes.set(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = var_0_0 .. arg_5_1
	local var_5_1 = var_0_2 .. arg_5_2.rune_slot
	local var_5_2 = arg_5_0._runes[var_5_0]

	if arg_5_2 == nil then
		Application.warning(string.format("[BackendInterfaceRunes:set] Tried to set runes %q for entity %q to nil", var_5_1, var_5_0))

		return
	end

	local var_5_3 = var_5_2.entity_id
	local var_5_4 = cjson.encode(arg_5_2)
	local var_5_5 = Backend.set_entity_attribute(var_5_3, var_5_1, var_5_4)

	fassert(not var_5_5 or var_5_5 == Backend.RES_NO_CHANGE, "[BackendInterfaceRunes:set] BackendItem.set_entity_attribute() returned an unexpected result: %d", var_5_5)
	arg_5_0:_refresh_attributes()
end
