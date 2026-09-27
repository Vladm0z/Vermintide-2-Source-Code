-- chunkname: @foundation/scripts/util/class.lua

local tbl = {
	__index = function ()
		-- function 1
		error("This object has been destroyed", 2)
	end
}
local tbl_2 = {
	new = true,
	__index = true,
	super = true,
	delete = true
}

function class(self, ...)
	-- function 2
	local args = ...

	if not (not (select("#", ...) >= 1) or args ~= nil) then
		ferror("Trying to inherit from nil")
	end

	if not self then
		self = {
			___is_class_metatable___ = true,
			super = args
		}
		self.__index = self

		self.new = function (arg_3_0, ...)
			-- function 3
			local tbl = {}

			setmetatable(tbl, self)

			if not tbl.init then
				tbl:init(...)
			end

			return tbl
		end

		self.delete = function (self, ...)
			-- function 4
			if not self.destroy then
				self:destroy(...)
			end

			setmetatable(self, tbl)
		end
	end

	if not args then
		for k, v in pairs(args) do
			if not tbl_2[k] then
				self[k] = v
			end
		end
	end

	return self
end

function is_class_instance(arg_5_0)
	-- function 5
	if type(arg_5_0) ~= "table" then
		return false
	end

	local var_5_0 = getmetatable(arg_5_0)

	if var_5_0 == nil then
		return false
	end

	return rawget(var_5_0, "___is_class_metatable___") == true
end
