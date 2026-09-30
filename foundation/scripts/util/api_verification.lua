-- chunkname: @foundation/scripts/util/api_verification.lua

require("foundation/scripts/util/error")

ApiVerification = ApiVerification

ApiVerification.ensure_public_api = function (interface_class, implementation_class)
	-- function 1
	for name, value in pairs(interface_class) do
		if type(value) == "function" and string.sub(tostring(name), 1, 1) ~= "_" then
			fassert(implementation_class[name] ~= nil, "Missing function %q in API", name)
		end
	end
end
