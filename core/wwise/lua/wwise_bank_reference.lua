-- chunkname: @core/wwise/lua/wwise_bank_reference.lua

local WwiseBankReference = WwiseBankReference

WwiseBankReference = WwiseBankReference or {}
WwiseBankReference = WwiseBankReference

local function fn(self)
	-- function 1
	if not self.references then
		self.references = {}
	end
end

WwiseBankReference.add = function (self, arg_2_1)
	-- function 2
	fn(self)

	local references = self.references
	local var_2_1 = self.references[arg_2_1]

	var_2_1 = var_2_1 or 0
	references[arg_2_1] = var_2_1 + 1
end

WwiseBankReference.remove = function (self, arg_3_1)
	-- function 3
	fn(self)

	local var_3_0 = self.references[arg_3_1]

	var_3_0 = var_3_0 or 0

	if var_3_0 - 1 <= 0 then
		self.references[arg_3_1] = nil
	end
end

WwiseBankReference.count = function (self, arg_4_1)
	-- function 4
	fn(self)

	local var_4_0 = self.references[arg_4_1]

	var_4_0 = var_4_0 or 0

	return var_4_0
end

return WwiseBankReference
