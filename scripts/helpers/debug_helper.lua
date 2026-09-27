-- chunkname: @scripts/helpers/debug_helper.lua

local DebugHelper = DebugHelper

DebugHelper = DebugHelper or {}
DebugHelper = DebugHelper

DebugHelper.remove_debug_stuff = function ()
	-- function 1
	Commands.script = function ()
		-- function 2
		return
	end

	Commands.console = function ()
		-- function 3
		return
	end

	Commands.game_speed = function ()
		-- function 4
		return
	end

	Commands.fov = function ()
		-- function 5
		return
	end

	Commands.free_flight_settings = function ()
		-- function 6
		return
	end

	Commands.lag = function ()
		-- function 7
		return
	end

	Commands.location = function ()
		-- function 8
		return
	end

	Commands.next_level = function ()
		-- function 9
		return
	end
end

DebugHelper.enable_physics_dump = function ()
	-- function 10
	local tbl = {
		"PhysicsWorld",
		"Actor",
		"Mover"
	}

	for k, v in pairs(tbl) do
		local var_10_1 = _G[v]

		for k_2, v_2 in pairs(var_10_1) do
			if type(v_2) == "function" then
				var_10_1[k_2] = function (...)
					-- function 11
					local format = string.format("%s.%s() : ", v, k_2)

					print(format, select(2, ...))

					return v_2(...)
				end
			end
		end
	end
end
