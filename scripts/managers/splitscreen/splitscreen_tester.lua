-- chunkname: @scripts/managers/splitscreen/splitscreen_tester.lua

SPLITSCREEN_ENABLED = false

require("scripts/managers/input/input_manager")

SplitscreenTester = class(SplitscreenTester)

if not IS_WINDOWS then
	SplitScreenTesterKeymaps = {
		toggle_splitscreen = {
			input_mappings = {
				{
					"keyboard",
					"j",
					"pressed"
				}
			}
		}
	}
elseif not IS_XB1 then
	SplitScreenTesterKeymaps = {
		toggle_splitscreen = {
			combination_type = "and",
			input_mappings = {
				{
					"gamepad",
					"left_thumb",
					"held"
				},
				{
					"gamepad",
					"right_thumb",
					"pressed"
				}
			}
		}
	}
elseif not IS_PS4 then
	SplitScreenTesterKeymaps = {
		toggle_splitscreen = {
			combination_type = "and",
			input_mappings = {
				{
					"gamepad",
					"l3",
					"held"
				},
				{
					"gamepad",
					"r3",
					"pressed"
				}
			}
		}
	}
end

SPLITSCREEN_OFFSET_X = 0.1
SPLITSCREEN_OFFSET_Y = 0
SPLITSCREEN_WIDTH = 0.625
SPLITSCREEN_HEIGHT = 0.5
SPLITSCREEN_OTHER_OFFSET_X = 0.275
SPLITSCREEN_OTHER_OFFSET_Y = 0.5
SPLITSCREEN_OTHER_WIDTH = 0.625
SPLITSCREEN_OTHER_HEIGHT = 0.5
SPLITSCREEN_RES_X = 1920 * SPLITSCREEN_WIDTH
SPLITSCREEN_RES_Y = 1080 * SPLITSCREEN_HEIGHT

SplitscreenTester.init = function (self)
	-- function 1
	self:_setup_names()
	self:_setup_background()
	self:_setup_input()

	self._splitscreen_active = false
end

SplitscreenTester._setup_names = function (self)
	-- function 2
	self._world_name = "splitscreen_background"
	self._viewport_name = "splitscreen_viewport"
end

SplitscreenTester._setup_background = function (self)
	-- function 3
	self._world = Managers.world:create_world(self._world_name, GameSettingsDevelopment.default_environment, nil, 0, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.deactivate(self._world)

	self._viewport = ScriptWorld.create_viewport(self._world, self._viewport_name, "overlay", 1, nil, nil, nil, true)

	ScriptWorld.deactivate_viewport(self._world, self._viewport)

	self._gui = World.create_screen_gui(self._world, "immediate")
end

SplitscreenTester._setup_input = function (self)
	-- function 4
	self.input_manager = InputManager:new()

	self.input_manager:initialize_device("keyboard", 1)
	self.input_manager:initialize_device("mouse", 1)
	self.input_manager:initialize_device("gamepad")

	if not IS_CONSOLE then
		-- Nothing
	end

	self.input_manager:create_input_service("splitscreen_tester", "SplitScreenTesterKeymaps")
	self.input_manager:map_device_to_service("splitscreen_tester", "keyboard")
	self.input_manager:map_device_to_service("splitscreen_tester", "gamepad")
end

SplitscreenTester.add_splitscreen_viewport = function (self, arg_5_1)
	-- function 5
	self._splitscreen_viewport = ScriptWorld.create_viewport(arg_5_1, "splitscreen_viewport", "default", 2, Vector3.zero(), Quaternion.identity(), true)
	self._splitscreen_world = arg_5_1

	Viewport.set_data(self._splitscreen_viewport, "avoid_shading_callback", true)
	Viewport.set_data(self._splitscreen_viewport, "no_scaling", true)
	Viewport.set_rect(self._splitscreen_viewport, SPLITSCREEN_OTHER_OFFSET_X, SPLITSCREEN_OTHER_OFFSET_Y, SPLITSCREEN_OTHER_WIDTH, SPLITSCREEN_OTHER_HEIGHT)

	if not self._splitscreen_active then
		ScriptWorld.deactivate_viewport(arg_5_1, self._splitscreen_viewport)
		ScriptWorld.deactivate_viewport(self._world, self._viewport)
	end
end

SplitscreenTester.remove_splitscreen_viewport = function (self)
	-- function 6
	self._splitscreen_viewport = nil
	self._splitscreen_world = nil
end

SplitscreenTester.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:_update_input(arg_7_1, arg_7_2)

	if not self._splitscreen_active then
		self:_fill_background(arg_7_1, arg_7_2)
		self:_update_splitscreen_camera(arg_7_1, arg_7_2)
	elseif not self._splitscreen_viewport and not self._splitscreen_world then
		ScriptWorld.deactivate_viewport(self._splitscreen_world, self._splitscreen_viewport)
		ScriptWorld.deactivate_viewport(self._world, self._viewport)
	end
end

SplitscreenTester._fill_background = function (self, arg_8_1, arg_8_2)
	-- function 8
	local screen_resolution, var_8_1 = Application.screen_resolution()

	Gui.rect(self._gui, Vector3(0, 0, 0), Vector2(screen_resolution, var_8_1), Color(0, 0, 0))
end

SplitscreenTester._update_splitscreen_camera = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self._splitscreen_world and not self._splitscreen_viewport then
		local get_data = Viewport.get_data(self._splitscreen_viewport, "active")
		local var_9_1 = Managers.player:bots()[1]

		if not var_9_1 then
			local player_unit = var_9_1.player_unit

			if not Unit.alive(player_unit) then
				if not get_data then
					ScriptWorld.activate_viewport(self._splitscreen_world, self._splitscreen_viewport)
					ScriptWorld.activate_viewport(self._world, self._viewport)
				end

				local player_unit_2 = var_9_1.player_unit
				local node = Unit.node(player_unit_2, "j_head")
				local flat = Vector3.flat(Quaternion.forward(Unit.world_rotation(player_unit_2, node)))
				local look = Quaternion.look(flat, Vector3.up())
				local num = Unit.world_position(player_unit_2, node) + flat * 0.1
				local camera = ScriptViewport.camera(self._splitscreen_viewport)

				ScriptCamera.set_local_position(camera, num)
				ScriptCamera.set_local_rotation(camera, look)

				local get_data_2 = Camera.get_data(camera, "unit")

				World.update_unit(self._splitscreen_world, get_data_2)
			end
		elseif not get_data then
			ScriptWorld.deactivate_viewport(self._splitscreen_world, self._splitscreen_viewport)
		end
	end
end

SplitscreenTester._update_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	self.input_manager:update(arg_10_1, arg_10_2)

	local get_service = self.input_manager:get_service("splitscreen_tester")

	if not get_service and not get_service:get("toggle_splitscreen") then
		self._splitscreen_active = not self._splitscreen_active

		self:_resize_viewports()
	end
end

SplitscreenTester._resize_viewports = function (self)
	-- function 11
	local SPLITSCREEN_WIDTH

	if not self._splitscreen_active then
		SPLITSCREEN_WIDTH = SPLITSCREEN_WIDTH

		if not SPLITSCREEN_WIDTH then
			-- Nothing
		end
	end

	SPLITSCREEN_WIDTH = 1 / SPLITSCREEN_WIDTH

	do
		local SPLITSCREEN_HEIGHT
	end

	::label_11_0::

	if not self._splitscreen_active then
		SPLITSCREEN_HEIGHT = SPLITSCREEN_HEIGHT

		if not SPLITSCREEN_HEIGHT then
			-- Nothing
		end
	end

	SPLITSCREEN_HEIGHT = 1 / SPLITSCREEN_HEIGHT

	do
		local SPLITSCREEN_OFFSET_X
	end

	::label_11_1::

	if not self._splitscreen_active then
		SPLITSCREEN_OFFSET_X = SPLITSCREEN_OFFSET_X

		if not SPLITSCREEN_OFFSET_X then
			-- Nothing
		end
	end

	SPLITSCREEN_OFFSET_X = 0

	::label_11_2::

	if not (not self._splitscreen_active and SPLITSCREEN_OFFSET_Y) then
		local num = 0
	end

	local _worlds = Managers.world._worlds

	for k, v in pairs(_worlds) do
		local get_data = World.get_data(v, "viewports")

		for k_2, v_2 in pairs(get_data) do
			if not Viewport.get_data(v_2, "no_scaling") then
				local get_data_2 = Viewport.get_data(v_2, "rect")

				Viewport.set_rect(v_2, get_data_2[1] * SPLITSCREEN_WIDTH, get_data_2[2] * SPLITSCREEN_HEIGHT, get_data_2[3] * SPLITSCREEN_WIDTH, get_data_2[4] * SPLITSCREEN_HEIGHT, SPLITSCREEN_OFFSET_X)
				print("Resizing: " .. Viewport.get_data(v_2, "name"), get_data_2[1] * SPLITSCREEN_WIDTH, get_data_2[2] * SPLITSCREEN_HEIGHT, get_data_2[3] * SPLITSCREEN_WIDTH, get_data_2[4] * SPLITSCREEN_HEIGHT)
			end
		end
	end
end

SplitscreenTester.active = function (self)
	-- function 12
	return self._splitscreen_active
end

SplitscreenTester.destroy = function (self)
	-- function 13
	Managers.world:destroy_world(self._world_name)
end

local viewport_set_rect = viewport_set_rect

viewport_set_rect = viewport_set_rect or Viewport.set_rect
viewport_set_rect = viewport_set_rect

Viewport.set_rect = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	local flag = arg_14_5 or 0
	local flag_2 = arg_14_6 or 0

	Viewport.set_data(arg_14_0, "rect", {
		arg_14_1,
		arg_14_2,
		arg_14_3,
		arg_14_4
	})
	viewport_set_rect(arg_14_0, arg_14_1 + flag, arg_14_2 + flag_2, arg_14_3, arg_14_4)
end

local application_resolution = application_resolution

application_resolution = application_resolution or Application.resolution
application_resolution = application_resolution

Application.resolution = function ()
	-- function 15
	local active

	if not Managers.splitscreen then
		active = Managers.splitscreen:active()

		if not active then
			-- Nothing
		end
	end

	active = false

	do
		local SPLITSCREEN_WIDTH
	end

	::label_15_0::

	if not active then
		SPLITSCREEN_WIDTH = SPLITSCREEN_WIDTH

		if not SPLITSCREEN_WIDTH then
			-- Nothing
		end
	end

	SPLITSCREEN_WIDTH = 1

	do
		local SPLITSCREEN_HEIGHT
	end

	::label_15_1::

	if not active then
		SPLITSCREEN_HEIGHT = SPLITSCREEN_HEIGHT

		if not SPLITSCREEN_HEIGHT then
			-- Nothing
		end
	end

	SPLITSCREEN_HEIGHT = 1

	::label_15_2::

	local var_15_3, var_15_4 = application_resolution()

	return var_15_3 * SPLITSCREEN_WIDTH, var_15_4 * SPLITSCREEN_HEIGHT
end

local gui_resolution = gui_resolution

gui_resolution = gui_resolution or Gui.resolution
gui_resolution = gui_resolution

Gui.resolution = function ()
	-- function 16
	local active

	if not Managers.splitscreen then
		active = Managers.splitscreen:active()

		if not active then
			-- Nothing
		end
	end

	active = false

	do
		local SPLITSCREEN_WIDTH
	end

	::label_16_0::

	if not active then
		SPLITSCREEN_WIDTH = SPLITSCREEN_WIDTH

		if not SPLITSCREEN_WIDTH then
			-- Nothing
		end
	end

	SPLITSCREEN_WIDTH = 1

	do
		local SPLITSCREEN_HEIGHT
	end

	::label_16_1::

	if not active then
		SPLITSCREEN_HEIGHT = SPLITSCREEN_HEIGHT

		if not SPLITSCREEN_HEIGHT then
			-- Nothing
		end
	end

	SPLITSCREEN_HEIGHT = 1

	::label_16_2::

	local var_16_3, var_16_4 = gui_resolution()

	return var_16_3 * SPLITSCREEN_WIDTH, var_16_4 * SPLITSCREEN_HEIGHT
end

Application.screen_resolution = function ()
	-- function 17
	return application_resolution()
end

local camera_world_to_screen = camera_world_to_screen

camera_world_to_screen = camera_world_to_screen or Camera.world_to_screen
camera_world_to_screen = camera_world_to_screen

Camera.world_to_screen = function (...)
	-- function 18
	local var_18_0 = camera_world_to_screen(...)

	if not Managers.splitscreen and not Managers.splitscreen:active() then
		var_18_0[1] = var_18_0[1] * SPLITSCREEN_WIDTH
	end

	return var_18_0
end
