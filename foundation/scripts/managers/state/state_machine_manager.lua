-- chunkname: @foundation/scripts/managers/state/state_machine_manager.lua

StateMachineManager = class(StateMachineManager)
StateMachineManager.DEBUG = false
StateMachineManager.FONT = "foundation/fonts/debug"
StateMachineManager.FONT_MATERIAL = "debug"
StateMachineManager.FONT_SIZE = 14

StateMachineManager.init = function (arg_1_0)
	arg_1_0._state_machines = {}
	arg_1_0._world = nil
	arg_1_0._gui = nil
	arg_1_0._column1_width = 0
end

StateMachineManager.update = function (arg_2_0, arg_2_1)
	if StateMachineManager.DEBUG then
		if arg_2_0._world == nil then
			arg_2_0._world = Application.debug_world()

			if arg_2_0._world ~= nil then
				arg_2_0._gui = World.create_screen_gui(arg_2_0._world, "immediate", "material", StateMachineManager.FONT)
			end
		end

		if arg_2_0._gui then
			arg_2_0:_draw_panel()
		end
	end
end

StateMachineManager.destroy = function (arg_3_0)
	if StateMachineManager.DEBUG and arg_3_0._gui ~= nil then
		World.destroy_gui(arg_3_0._world, arg_3_0._gui)

		arg_3_0._gui = nil
	end
end

StateMachineManager._register_state_machine = function (arg_4_0, arg_4_1)
	arg_4_0._state_machines[#arg_4_0._state_machines + 1] = arg_4_1
end

StateMachineManager._unregister_state_machine = function (arg_5_0, arg_5_1)
	local var_5_0 = table.find(arg_5_0._state_machines, arg_5_1)

	assert(var_5_0, "unregister a state machine " .. arg_5_1._name .. " that was not registered")
	table.remove(arg_5_0._state_machines, var_5_0)
end

StateMachineManager._root_state_machines = function (arg_6_0)
	local var_6_0 = {}

	for iter_6_0, iter_6_1 in ipairs(arg_6_0._state_machines) do
		if iter_6_1._state_machine_stack[1] == iter_6_1 then
			var_6_0[#var_6_0 + 1] = iter_6_1
		end
	end

	return var_6_0
end

StateMachineManager._state_machines_column_width = function (arg_7_0, arg_7_1)
	local var_7_0 = 0

	for iter_7_0, iter_7_1 in ipairs(arg_7_1) do
		local var_7_1, var_7_2 = Gui.text_extents(arg_7_0._gui, iter_7_1._name, StateMachineManager.FONT, StateMachineManager.FONT_SIZE)
		local var_7_3 = var_7_2.x - var_7_1.x

		var_7_0 = math.max(var_7_3, var_7_0)
	end

	return var_7_0
end

StateMachineManager._draw_panel = function (arg_8_0)
	local var_8_0, var_8_1 = Gui.resolution()
	local var_8_2 = 16
	local var_8_3 = 4
	local var_8_4 = arg_8_0:_root_state_machines()
	local var_8_5 = arg_8_0:_state_machines_column_width(var_8_4) + 2 * var_8_3

	arg_8_0._column1_width = math.max(var_8_5, arg_8_0._column1_width)

	Gui.rect(arg_8_0._gui, Vector2(var_8_2, var_8_2), Vector2(arg_8_0._column1_width, var_8_1 - 2 * var_8_2), Color(64, 0, 0, 0))

	local var_8_6 = var_8_2
	local var_8_7 = var_8_1 - var_8_2

	for iter_8_0, iter_8_1 in ipairs(var_8_4) do
		Gui.text(arg_8_0._gui, iter_8_1._name, StateMachineManager.FONT, StateMachineManager.FONT_SIZE, StateMachineManager.FONT_MATERIAL, Vector3(var_8_6 + var_8_3, var_8_7 - StateMachineManager.FONT_SIZE, 0))

		var_8_7 = var_8_7 - StateMachineManager.FONT_SIZE
	end
end
