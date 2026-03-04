-- chunkname: @scripts/helpers/debug_helper.lua

DebugHelper = DebugHelper or {}

DebugHelper.remove_debug_stuff = function ()
	Commands.script = function ()
		return
	end

	Commands.console = function ()
		return
	end

	Commands.game_speed = function ()
		return
	end

	Commands.fov = function ()
		return
	end

	Commands.free_flight_settings = function ()
		return
	end

	Commands.lag = function ()
		return
	end

	Commands.location = function ()
		return
	end

	Commands.next_level = function ()
		return
	end
end

DebugHelper.enable_physics_dump = function ()
	local var_10_0 = {
		"PhysicsWorld",
		"Actor",
		"Mover"
	}

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		local var_10_1 = _G[iter_10_1]

		for iter_10_2, iter_10_3 in pairs(var_10_1) do
			if type(iter_10_3) == "function" then
				var_10_1[iter_10_2] = function (...)
					local var_11_0 = string.format("%s.%s() : ", iter_10_1, iter_10_2)

					print(var_11_0, select(2, ...))

					return iter_10_3(...)
				end
			end
		end
	end
end
