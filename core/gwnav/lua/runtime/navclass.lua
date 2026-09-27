-- chunkname: @core/gwnav/lua/runtime/navclass.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()

var_0_0.NavClass = function (self, arg_1_1)
	-- function 1
	self = self or {}

	if next(self) == nil then
		local tbl = {
			__call = function (arg_2_0, ...)
				-- function 2
				local tbl = {}

				setmetatable(tbl, self)

				if not tbl.init then
					tbl:init(...)
				end

				return tbl
			end
		}

		setmetatable(self, tbl)
	end

	if not arg_1_1 then
		for k, v in pairs(arg_1_1) do
			self[k] = v
		end
	end

	self.Super = arg_1_1
	self.__index = self

	return self
end

return var_0_0.NavClass
