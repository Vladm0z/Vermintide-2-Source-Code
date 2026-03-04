-- chunkname: @scripts/helpers/debug_helper.lua

DebugHelper = DebugHelper or {}

function DebugHelper.remove_debug_stuff()
	function Commands.script()
		return
	end

	function Commands.console()
		return
	end

	function Commands.game_speed()
		return
	end

	function Commands.fov()
		return
	end

	function Commands.free_flight_settings()
		return
	end

	function Commands.lag()
		return
	end

	function Commands.location()
		return
	end

	function Commands.next_level()
		return
	end
end

function DebugHelper.enable_physics_dump()
	local var_10_0 = {
		"PhysicsWorld",
		"Actor",
		"Mover"
	}

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		local var_10_1 = _G[iter_10_1]

		for iter_10_2, iter_10_3 in pairs(var_10_1) do
			if type(iter_10_3) == "function" then
				var_10_1[iter_10_2] = function(...)
					local var_11_0 = string.format("%s.%s() : ", iter_10_1, iter_10_2)

					print(var_11_0, select(2, ...))

					return iter_10_3(...)
				end
			end
		end
	end
end
