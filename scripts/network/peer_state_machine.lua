-- chunkname: @scripts/network/peer_state_machine.lua

require("scripts/network/peer_states")

PeerStateMachine = {}

local function fn(arg_1_0, ...)
	-- function 1
	printf("[PeerSM] " .. arg_1_0, ...)
end

PeerStateMachine.create = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local tbl = {
		server = arg_2_0,
		peer_id = arg_2_1,
		is_remote = arg_2_1 ~= Network.peer_id()
	}
	local tbl_2 = {}
	local tbl_3 = {
		state_data = tbl,
		current_state = PeerStates.Connecting,
		function_memoize = tbl_2
	}

	tbl.change_state = function (arg_3_0, arg_3_1)
		-- function 3
		fn("%s :: on_exit %s", arg_2_1, tostring(tbl_3.current_state))
		tbl_3.current_state.on_exit(tbl, arg_3_1)

		local current_state = tbl_3.current_state

		tbl_3.current_state = arg_3_1

		fn("%s :: on_enter %s", arg_2_1, tostring(arg_3_1))
		arg_3_1.on_enter(tbl, current_state)
	end

	fn("%s :: on_enter %s", arg_2_1, tostring(tbl_3.current_state))
	tbl_3.current_state.on_enter(tbl)

	local tbl_4 = {
		__newindex = function (arg_4_0, arg_4_1, arg_4_2)
			-- function 4
			assert(false)
		end,
		__index = function (arg_5_0, arg_5_1)
			-- function 5
			local var_5_0 = PeerStateMachine[arg_5_1]

			if not var_5_0 then
				local var_5_1 = tbl_2[arg_5_1]

				if not var_5_1 then
					local function fn(...)
						-- function 6
						local var_6_0 = arg_5_0.current_state[arg_5_1]

						assert(not var_6_0 and type(var_6_0) == "function", "Could not find function %q in state %q", arg_5_1, tostring(arg_5_0.current_state))
						var_6_0(tbl, ...)
					end

					tbl_2[arg_5_1] = fn

					return fn
				else
					return var_5_1
				end
			else
				return var_5_0
			end
		end
	}

	setmetatable(tbl_3, tbl_4)

	return tbl_3
end

PeerStateMachine.has_function = function (self, arg_7_1)
	-- function 7
	return not not self.current_state[arg_7_1]
end

PeerStateMachine.update = function (self, arg_8_1)
	-- function 8
	local state_data = self.state_data

	if not script_data.debug_peers then
		Debug.text("Peer %s State %s", self.state_data.peer_id, tostring(self.current_state))
	end

	local update = self.current_state.update(state_data, arg_8_1)

	if not update then
		state_data:change_state(update)
	end
end
