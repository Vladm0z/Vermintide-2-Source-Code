-- chunkname: @foundation/scripts/util/api_verification.lua

require("foundation/scripts/util/error")

local ApiVerification = ApiVerification

ApiVerification = ApiVerification or {}
ApiVerification = ApiVerification

ApiVerification.ensure_public_api = function (arg_1_0, arg_1_1)
	-- function 1
	for k, v in pairs(arg_1_0) do
		if not (type(v) ~= "function" or string.sub(tostring(k), 1, 1) == "_") then
			fassert(arg_1_1[k] ~= nil, "Missing function %q in API", k)
		end
	end
end
