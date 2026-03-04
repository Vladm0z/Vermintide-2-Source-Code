-- chunkname: @foundation/scripts/util/class.lua

local var_0_0 = {
	__index = function ()
		error("This object has been destroyed")
	end
}
local var_0_1 = {
	new = true,
	__index = true,
	super = true,
	delete = true
}

function class(arg_2_0, ...)
	local var_2_0 = ...

	if select("#", ...) >= 1 and var_2_0 == nil then
		ferror("Trying to inherit from nil")
	end

	if not arg_2_0 then
		arg_2_0 = {
			___is_class_metatable___ = true,
			super = var_2_0
		}
		arg_2_0.__index = arg_2_0

		arg_2_0.new = function (arg_3_0, ...)
			local var_3_0 = {}

			setmetatable(var_3_0, arg_2_0)

			if var_3_0.init then
				var_3_0:init(...)
			end

			return var_3_0
		end

		arg_2_0.delete = function (arg_4_0, ...)
			if arg_4_0.destroy then
				arg_4_0:destroy(...)
			end

			setmetatable(arg_4_0, var_0_0)
		end
	end

	if var_2_0 then
		for iter_2_0, iter_2_1 in pairs(var_2_0) do
			if not var_0_1[iter_2_0] then
				arg_2_0[iter_2_0] = iter_2_1
			end
		end
	end

	return arg_2_0
end

function is_class_instance(arg_5_0)
	if type(arg_5_0) ~= "table" then
		return false
	end

	local var_5_0 = getmetatable(arg_5_0)

	if var_5_0 == nil then
		return false
	end

	return rawget(var_5_0, "___is_class_metatable___") == true
end
