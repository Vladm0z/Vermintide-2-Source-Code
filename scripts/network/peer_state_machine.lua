-- chunkname: @scripts/network/peer_state_machine.lua

require("scripts/network/peer_states")

PeerStateMachine = {}

local function var_0_0(arg_1_0, ...)
	printf("[PeerSM] " .. arg_1_0, ...)
end

function PeerStateMachine.create(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = {
		server = arg_2_0,
		peer_id = arg_2_1,
		is_remote = arg_2_1 ~= Network.peer_id()
	}
	local var_2_1 = {}
	local var_2_2 = {
		state_data = var_2_0,
		current_state = PeerStates.Connecting,
		function_memoize = var_2_1
	}

	function var_2_0.change_state(arg_3_0, arg_3_1)
		var_0_0("%s :: on_exit %s", arg_2_1, tostring(var_2_2.current_state))
		var_2_2.current_state.on_exit(var_2_0, arg_3_1)

		local var_3_0 = var_2_2.current_state

		var_2_2.current_state = arg_3_1

		var_0_0("%s :: on_enter %s", arg_2_1, tostring(arg_3_1))
		arg_3_1.on_enter(var_2_0, var_3_0)
	end

	var_0_0("%s :: on_enter %s", arg_2_1, tostring(var_2_2.current_state))
	var_2_2.current_state.on_enter(var_2_0)

	local var_2_3 = {
		__newindex = function(arg_4_0, arg_4_1, arg_4_2)
			assert(false)
		end,
		__index = function(arg_5_0, arg_5_1)
			local var_5_0 = PeerStateMachine[arg_5_1]

			if not var_5_0 then
				local var_5_1 = var_2_1[arg_5_1]

				if not var_5_1 then
					local function var_5_2(...)
						local var_6_0 = arg_5_0.current_state[arg_5_1]

						assert(var_6_0 and type(var_6_0) == "function", "Could not find function %q in state %q", arg_5_1, tostring(arg_5_0.current_state))
						var_6_0(var_2_0, ...)
					end

					var_2_1[arg_5_1] = var_5_2

					return var_5_2
				else
					return var_5_1
				end
			else
				return var_5_0
			end
		end
	}

	setmetatable(var_2_2, var_2_3)

	return var_2_2
end

function PeerStateMachine.has_function(arg_7_0, arg_7_1)
	return not not arg_7_0.current_state[arg_7_1]
end

function PeerStateMachine.update(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.state_data

	if script_data.debug_peers then
		Debug.text("Peer %s State %s", arg_8_0.state_data.peer_id, tostring(arg_8_0.current_state))
	end

	local var_8_1 = arg_8_0.current_state.update(var_8_0, arg_8_1)

	if var_8_1 then
		var_8_0:change_state(var_8_1)
	end
end
