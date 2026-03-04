-- chunkname: @foundation/scripts/managers/token/token_manager.lua

TokenManager = class(TokenManager)

TokenManager.init = function (arg_1_0)
	arg_1_0._tokens = {}
end

TokenManager.register_token = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._tokens[#arg_2_0._tokens + 1] = {
		token = arg_2_1,
		callback = arg_2_2,
		timeout = arg_2_3 or math.huge
	}
end

TokenManager.update = function (arg_3_0, arg_3_1, arg_3_2)
	for iter_3_0, iter_3_1 in pairs(arg_3_0._tokens) do
		local var_3_0 = iter_3_1.token

		var_3_0:update()

		if var_3_0:done() or arg_3_2 >= iter_3_1.timeout then
			local var_3_1 = iter_3_1.callback

			if var_3_1 then
				local var_3_2 = var_3_0:info()

				var_3_1(var_3_2)
			end

			var_3_0:close()

			arg_3_0._tokens[iter_3_0] = nil
		end
	end
end

TokenManager.destroy = function (arg_4_0)
	for iter_4_0, iter_4_1 in pairs(arg_4_0._tokens) do
		iter_4_1.token:close()

		arg_4_0._tokens[iter_4_0] = nil
	end

	arg_4_0._tokens = nil
end
