-- chunkname: @foundation/scripts/util/class.lua

local destroyed_mt = {}

destroyed_mt.__index = function ()
	-- function 1
	error("This object has been destroyed", 2)
end

local special_functions = {
	new = true,
	__index = true,
	super = true,
	delete = true
}

function class(class_table, ...)
	-- function 2
	local super = ...

	if select("#", ...) >= 1 and super == nil then
		ferror("Trying to inherit from nil")
	end

	if not class_table then
		class_table = {
			___is_class_metatable___ = true,
			super = super
		}
		class_table.__index = class_table

		class_table.new = function (self, ...)
			-- function 3
			local object = {}

			setmetatable(object, class_table)

			if object.init then
				object:init(...)
			end

			return object
		end

		class_table.delete = function (self, ...)
			-- function 4
			if self.destroy then
				self:destroy(...)
			end

			setmetatable(self, destroyed_mt)
		end
	end

	if super then
		for k, v in pairs(super) do
			if not special_functions[k] then
				class_table[k] = v
			end
		end
	end

	return class_table
end

function is_class_instance(object)
	-- function 5
	if type(object) ~= "table" then
		return false
	end

	local metatable = getmetatable(object)

	if metatable == nil then
		return false
	end

	return rawget(metatable, "___is_class_metatable___") == true
end
