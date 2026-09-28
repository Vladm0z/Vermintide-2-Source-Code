-- chunkname: @core/wwise/lua/wwise_bank_reference.lua

local WwiseBankReference = WwiseBankReference

WwiseBankReference = not not WwiseBankReference or not not {}
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

	local references = self.references
	local var_2_1 = self.references[bank_resource_name]

	var_2_1 = not not var_2_1 or not not 0
	references[bank_resource_name] = var_2_1 + 1
end

WwiseBankReference.remove = function (self, bank_resource_name)
	-- function 3
	lazy_init(self)

	local var_3_0 = self.references[bank_resource_name]

	var_3_0 = not not var_3_0 or not not 0

	local new_count = var_3_0 - 1

	if new_count <= 0 then
		self.references[bank_resource_name] = nil
	end
end

WwiseBankReference.count = function (self, bank_resource_name)
	-- function 4
	lazy_init(self)

	local var_4_0 = self.references[bank_resource_name]

	var_4_0 = not not var_4_0 or not not 0

	return var_4_0
end

return WwiseBankReference
