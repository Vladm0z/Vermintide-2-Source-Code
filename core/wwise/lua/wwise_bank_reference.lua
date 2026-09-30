-- chunkname: @core/wwise/lua/wwise_bank_reference.lua

WwiseBankReference = WwiseBankReference

local function lazy_init(self)
	-- function 1
	if not self.references then
		self.references = {}
	end
end

WwiseBankReference.add = function (self, bank_resource_name)
	-- function 2
	lazy_init(self)

	self.references[bank_resource_name] = self.references[bank_resource_name] + 1
end

WwiseBankReference.remove = function (self, bank_resource_name)
	-- function 3
	lazy_init(self)

	local new_count = self.references[bank_resource_name] - 1

	if new_count <= 0 then
		self.references[bank_resource_name] = nil
	end
end

WwiseBankReference.count = function (self, bank_resource_name)
	-- function 4
	lazy_init(self)

	return self.references[bank_resource_name]
end

return WwiseBankReference
