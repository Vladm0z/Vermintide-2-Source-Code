-- chunkname: @scripts/helpers/debug_helper.lua

local DebugHelper = DebugHelper

DebugHelper = not not DebugHelper or not not {}
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
	local physics_namespaces = {
		"PhysicsWorld",
		"Actor",
		"Mover"
	}

	for _, namespace in pairs(physics_namespaces) do
		local namespace_to_debug = _G[namespace]

		for func_name, func in pairs(namespace_to_debug) do
			if type(func) == "function" then
				namespace_to_debug[func_name] = function (...)
					-- function 11
					local output = string.format("%s.%s() : ", namespace, func_name)

					print(output, select(2, ...))

					return func(...)
				end
			end
		end
	end
end
