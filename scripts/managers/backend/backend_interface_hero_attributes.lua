-- chunkname: @scripts/managers/backend/backend_interface_hero_attributes.lua

BackendInterfaceHeroAttributes = class(BackendInterfaceHeroAttributes)

local var_0_0 = "hero_attributes_"
local var_0_1 = "hero_attributes"
local var_0_2 = "hero_attribute_"

function BackendInterfaceHeroAttributes.init(arg_1_0)
	return
end

function BackendInterfaceHeroAttributes._refresh_attributes(arg_2_0)
	local var_2_0 = Backend.get_entities_with_attributes(var_0_1)
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		local var_2_2 = iter_2_1.entity_name
		local var_2_3 = iter_2_1.attributes

		var_2_3.entity_id = iter_2_0
		var_2_1[var_2_2] = var_2_3
	end

	arg_2_0._attributes = var_2_1
end

function BackendInterfaceHeroAttributes.on_authenticated(arg_3_0)
	arg_3_0:_refresh_attributes()
end

function BackendInterfaceHeroAttributes.get(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = var_0_0 .. arg_4_1
	local var_4_1 = var_0_2 .. arg_4_2
	local var_4_2 = arg_4_0._attributes[var_4_0]
	local var_4_3 = var_4_2 and var_4_2[var_4_1]

	if not var_4_3 then
		return
	end

	return (cjson.decode(var_4_3))
end

function BackendInterfaceHeroAttributes.set(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = var_0_0 .. arg_5_1
	local var_5_1 = var_0_2 .. arg_5_2
	local var_5_2 = arg_5_0._attributes[var_5_0]

	if not var_5_2 or not var_5_2[var_5_1] then
		return
	end

	if arg_5_3 == nil then
		return
	end

	local var_5_3 = var_5_2.entity_id
	local var_5_4 = cjson.encode(arg_5_3)
	local var_5_5 = Backend.set_entity_attribute(var_5_3, var_5_1, var_5_4)

	fassert(not var_5_5 or var_5_5 == Backend.RES_NO_CHANGE, "[BackendInterfaceHeroAttributes:set] BackendItem.set_entity_attribute() returned an unexpected result: %d", var_5_5)
	arg_5_0:_refresh_attributes()
end
