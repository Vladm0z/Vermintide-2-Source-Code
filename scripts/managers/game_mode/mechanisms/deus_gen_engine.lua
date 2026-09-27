-- chunkname: @scripts/managers/game_mode/mechanisms/deus_gen_engine.lua

local function fn(self)
	-- function 1
	for i = #self, 1, -1 do
		local var_1_0 = self[i]

		if not var_1_0._next_action_generators then
			for k, v in pairs(var_1_0._next_actions) do
				if not v then
					local var_1_1 = var_1_0._next_action_generators[k]()

					var_1_1._parent = var_1_0
					var_1_0._next_actions[k] = var_1_1

					return var_1_1
				end
			end
		end
	end
end

local function fn_2(self)
	-- function 2
	if not self._parent then
		return
	end

	for k, v in pairs(self._parent._next_actions) do
		if v == self then
			self._parent._next_actions[k] = false
		end
	end
end

local function fn_3(self, arg_3_1)
	-- function 3
	self._next_action_generators = arg_3_1

	if not arg_3_1 then
		self._next_actions = {}

		for i, v in ipairs(arg_3_1) do
			self._next_actions[i] = false
		end
	end
end

DeusGenEngine = {
	get_generator = function (arg_4_0, arg_4_1)
		-- function 4
		local flag = false

		return function ()
			-- function 5
			if #arg_4_0 > 0 then
				local var_5_0 = arg_4_0[#arg_4_0]

				if not arg_4_1 then
					arg_4_1(arg_4_0, var_5_0)
				end

				local var_5_1
				local var_5_2

				if not flag then
					var_5_1, var_5_2 = var_5_0.run()
				else
					var_5_1, var_5_2 = var_5_0.retry()
				end

				if not var_5_1 then
					flag = false

					fn_3(var_5_0, var_5_2)

					local var_5_3 = fn(arg_4_0)

					if not var_5_3 then
						arg_4_0[#arg_4_0 + 1] = var_5_3
					else
						return true
					end
				else
					flag = true

					fn_2(var_5_0)

					arg_4_0[#arg_4_0] = nil
				end

				return false
			else
				return true, "Gen Failed"
			end
		end
	end
}
