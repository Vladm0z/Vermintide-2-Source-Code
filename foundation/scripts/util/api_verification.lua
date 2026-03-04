-- chunkname: @foundation/scripts/util/api_verification.lua

require("foundation/scripts/util/error")

ApiVerification = ApiVerification or {}

ApiVerification.ensure_public_api = function (arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		if type(iter_1_1) == "function" and string.sub(tostring(iter_1_0), 1, 1) ~= "_" then
			fassert(arg_1_1[iter_1_0] ~= nil, "Missing function %q in API", iter_1_0)
		end
	end
end
