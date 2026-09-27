-- chunkname: @foundation/scripts/managers/state/state_machine_manager.lua

StateMachineManager = class(StateMachineManager)
StateMachineManager.DEBUG = false
StateMachineManager.FONT = "foundation/fonts/debug"
StateMachineManager.FONT_MATERIAL = "debug"
StateMachineManager.FONT_SIZE = 14

StateMachineManager.init = function (self)
	-- function 1
	self._state_machines = {}
	self._world = nil
	self._gui = nil
	self._column1_width = 0
end

StateMachineManager.update = function (self, arg_2_1)
	-- function 2
	if not StateMachineManager.DEBUG then
		if self._world == nil then
			self._world = Application.debug_world()

			if self._world ~= nil then
				self._gui = World.create_screen_gui(self._world, "immediate", "material", StateMachineManager.FONT)
			end
		end

		if not self._gui then
			self:_draw_panel()
		end
	end
end

StateMachineManager.destroy = function (self)
	-- function 3
	if not (not StateMachineManager.DEBUG and self._gui == nil) then
		World.destroy_gui(self._world, self._gui)

		self._gui = nil
	end
end

StateMachineManager._register_state_machine = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_0._state_machines[#arg_4_0._state_machines + 1] = arg_4_1
end

StateMachineManager._unregister_state_machine = function (self, arg_5_1)
	-- function 5
	local find = table.find(self._state_machines, arg_5_1)

	assert(find, "unregister a state machine " .. arg_5_1._name .. " that was not registered")
	table.remove(self._state_machines, find)
end

StateMachineManager._root_state_machines = function (self)
	-- function 6
	local tbl = {}

	for i, v in ipairs(self._state_machines) do
		if v._state_machine_stack[1] == v then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

StateMachineManager._state_machines_column_width = function (self, arg_7_1)
	-- function 7
	local num = 0

	for i, v in ipairs(arg_7_1) do
		local text_extents, var_7_2 = Gui.text_extents(self._gui, v._name, StateMachineManager.FONT, StateMachineManager.FONT_SIZE)
		local num_2 = var_7_2.x - text_extents.x

		num = math.max(num_2, num)
	end

	return num
end

StateMachineManager._draw_panel = function (self)
	-- function 8
	local resolution, var_8_1 = Gui.resolution()
	local num = 16
	local num_2 = 4
	local _root_state_machines = self:_root_state_machines()
	local num_3 = self:_state_machines_column_width(_root_state_machines) + 2 * num_2

	self._column1_width = math.max(num_3, self._column1_width)

	Gui.rect(self._gui, Vector2(num, num), Vector2(self._column1_width, var_8_1 - 2 * num), Color(64, 0, 0, 0))

	local var_8_6 = num
	local num_4 = var_8_1 - num

	for i, v in ipairs(_root_state_machines) do
		Gui.text(self._gui, v._name, StateMachineManager.FONT, StateMachineManager.FONT_SIZE, StateMachineManager.FONT_MATERIAL, Vector3(var_8_6 + num_2, num_4 - StateMachineManager.FONT_SIZE, 0))

		num_4 = num_4 - StateMachineManager.FONT_SIZE
	end
end
