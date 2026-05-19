-- chunkname: @scripts/managers/splitscreen/splitscreen_tester.lua

SPLITSCREEN_ENABLED = false

require("scripts/managers/input/input_manager")

SplitscreenTester = class(SplitscreenTester)

if IS_WINDOWS then
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
elseif IS_XB1 then
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
elseif IS_PS4 then
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

function SplitscreenTester.init(arg_1_0)
	arg_1_0:_setup_names()
	arg_1_0:_setup_background()
	arg_1_0:_setup_input()

	arg_1_0._splitscreen_active = false
end

function SplitscreenTester._setup_names(arg_2_0)
	arg_2_0._world_name = "splitscreen_background"
	arg_2_0._viewport_name = "splitscreen_viewport"
end

function SplitscreenTester._setup_background(arg_3_0)
	arg_3_0._world = Managers.world:create_world(arg_3_0._world_name, GameSettingsDevelopment.default_environment, nil, 0, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.deactivate(arg_3_0._world)

	arg_3_0._viewport = ScriptWorld.create_viewport(arg_3_0._world, arg_3_0._viewport_name, "overlay", 1, nil, nil, nil, true)

	ScriptWorld.deactivate_viewport(arg_3_0._world, arg_3_0._viewport)

	arg_3_0._gui = World.create_screen_gui(arg_3_0._world, "immediate")
end

function SplitscreenTester._setup_input(arg_4_0)
	arg_4_0.input_manager = InputManager:new()

	arg_4_0.input_manager:initialize_device("keyboard", 1)
	arg_4_0.input_manager:initialize_device("mouse", 1)
	arg_4_0.input_manager:initialize_device("gamepad")

	if not IS_CONSOLE then
		-- block empty
	end

	arg_4_0.input_manager:create_input_service("splitscreen_tester", "SplitScreenTesterKeymaps")
	arg_4_0.input_manager:map_device_to_service("splitscreen_tester", "keyboard")
	arg_4_0.input_manager:map_device_to_service("splitscreen_tester", "gamepad")
end

function SplitscreenTester.add_splitscreen_viewport(arg_5_0, arg_5_1)
	arg_5_0._splitscreen_viewport = ScriptWorld.create_viewport(arg_5_1, "splitscreen_viewport", "default", 2, Vector3.zero(), Quaternion.identity(), true)
	arg_5_0._splitscreen_world = arg_5_1

	Viewport.set_data(arg_5_0._splitscreen_viewport, "avoid_shading_callback", true)
	Viewport.set_data(arg_5_0._splitscreen_viewport, "no_scaling", true)
	Viewport.set_rect(arg_5_0._splitscreen_viewport, SPLITSCREEN_OTHER_OFFSET_X, SPLITSCREEN_OTHER_OFFSET_Y, SPLITSCREEN_OTHER_WIDTH, SPLITSCREEN_OTHER_HEIGHT)

	if not arg_5_0._splitscreen_active then
		ScriptWorld.deactivate_viewport(arg_5_1, arg_5_0._splitscreen_viewport)
		ScriptWorld.deactivate_viewport(arg_5_0._world, arg_5_0._viewport)
	end
end

function SplitscreenTester.remove_splitscreen_viewport(arg_6_0)
	arg_6_0._splitscreen_viewport = nil
	arg_6_0._splitscreen_world = nil
end

function SplitscreenTester.update(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:_update_input(arg_7_1, arg_7_2)

	if arg_7_0._splitscreen_active then
		arg_7_0:_fill_background(arg_7_1, arg_7_2)
		arg_7_0:_update_splitscreen_camera(arg_7_1, arg_7_2)
	elseif arg_7_0._splitscreen_viewport and arg_7_0._splitscreen_world then
		ScriptWorld.deactivate_viewport(arg_7_0._splitscreen_world, arg_7_0._splitscreen_viewport)
		ScriptWorld.deactivate_viewport(arg_7_0._world, arg_7_0._viewport)
	end
end

function SplitscreenTester._fill_background(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0, var_8_1 = Application.screen_resolution()

	Gui.rect(arg_8_0._gui, Vector3(0, 0, 0), Vector2(var_8_0, var_8_1), Color(0, 0, 0))
end

function SplitscreenTester._update_splitscreen_camera(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0._splitscreen_world and arg_9_0._splitscreen_viewport then
		local var_9_0 = Viewport.get_data(arg_9_0._splitscreen_viewport, "active")
		local var_9_1 = Managers.player:bots()[1]

		if var_9_1 then
			local var_9_2 = var_9_1.player_unit

			if Unit.alive(var_9_2) then
				if not var_9_0 then
					ScriptWorld.activate_viewport(arg_9_0._splitscreen_world, arg_9_0._splitscreen_viewport)
					ScriptWorld.activate_viewport(arg_9_0._world, arg_9_0._viewport)
				end

				local var_9_3 = var_9_1.player_unit
				local var_9_4 = Unit.node(var_9_3, "j_head")
				local var_9_5 = Vector3.flat(Quaternion.forward(Unit.world_rotation(var_9_3, var_9_4)))
				local var_9_6 = Quaternion.look(var_9_5, Vector3.up())
				local var_9_7 = Unit.world_position(var_9_3, var_9_4) + var_9_5 * 0.1
				local var_9_8 = ScriptViewport.camera(arg_9_0._splitscreen_viewport)

				ScriptCamera.set_local_position(var_9_8, var_9_7)
				ScriptCamera.set_local_rotation(var_9_8, var_9_6)

				local var_9_9 = Camera.get_data(var_9_8, "unit")

				World.update_unit(arg_9_0._splitscreen_world, var_9_9)
			end
		elseif var_9_0 then
			ScriptWorld.deactivate_viewport(arg_9_0._splitscreen_world, arg_9_0._splitscreen_viewport)
		end
	end
end

function SplitscreenTester._update_input(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.input_manager:update(arg_10_1, arg_10_2)

	local var_10_0 = arg_10_0.input_manager:get_service("splitscreen_tester")

	if var_10_0 and var_10_0:get("toggle_splitscreen") then
		arg_10_0._splitscreen_active = not arg_10_0._splitscreen_active

		arg_10_0:_resize_viewports()
	end
end

function SplitscreenTester._resize_viewports(arg_11_0)
	local var_11_0 = arg_11_0._splitscreen_active and SPLITSCREEN_WIDTH or 1 / SPLITSCREEN_WIDTH
	local var_11_1 = arg_11_0._splitscreen_active and SPLITSCREEN_HEIGHT or 1 / SPLITSCREEN_HEIGHT
	local var_11_2 = arg_11_0._splitscreen_active and SPLITSCREEN_OFFSET_X or 0

	if not arg_11_0._splitscreen_active or not SPLITSCREEN_OFFSET_Y then
		local var_11_3 = 0
	end

	local var_11_4 = Managers.world._worlds

	for iter_11_0, iter_11_1 in pairs(var_11_4) do
		local var_11_5 = World.get_data(iter_11_1, "viewports")

		for iter_11_2, iter_11_3 in pairs(var_11_5) do
			if not Viewport.get_data(iter_11_3, "no_scaling") then
				local var_11_6 = Viewport.get_data(iter_11_3, "rect")

				Viewport.set_rect(iter_11_3, var_11_6[1] * var_11_0, var_11_6[2] * var_11_1, var_11_6[3] * var_11_0, var_11_6[4] * var_11_1, var_11_2)
				print("Resizing: " .. Viewport.get_data(iter_11_3, "name"), var_11_6[1] * var_11_0, var_11_6[2] * var_11_1, var_11_6[3] * var_11_0, var_11_6[4] * var_11_1)
			end
		end
	end
end

function SplitscreenTester.active(arg_12_0)
	return arg_12_0._splitscreen_active
end

function SplitscreenTester.destroy(arg_13_0)
	Managers.world:destroy_world(arg_13_0._world_name)
end

viewport_set_rect = viewport_set_rect or Viewport.set_rect

function Viewport.set_rect(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	local var_14_0 = arg_14_5 or 0
	local var_14_1 = arg_14_6 or 0

	Viewport.set_data(arg_14_0, "rect", {
		arg_14_1,
		arg_14_2,
		arg_14_3,
		arg_14_4
	})
	viewport_set_rect(arg_14_0, arg_14_1 + var_14_0, arg_14_2 + var_14_1, arg_14_3, arg_14_4)
end

application_resolution = application_resolution or Application.resolution

function Application.resolution()
	local var_15_0 = Managers.splitscreen and Managers.splitscreen:active() or false
	local var_15_1 = var_15_0 and SPLITSCREEN_WIDTH or 1
	local var_15_2 = var_15_0 and SPLITSCREEN_HEIGHT or 1
	local var_15_3, var_15_4 = application_resolution()

	return var_15_3 * var_15_1, var_15_4 * var_15_2
end

gui_resolution = gui_resolution or Gui.resolution

function Gui.resolution()
	local var_16_0 = Managers.splitscreen and Managers.splitscreen:active() or false
	local var_16_1 = var_16_0 and SPLITSCREEN_WIDTH or 1
	local var_16_2 = var_16_0 and SPLITSCREEN_HEIGHT or 1
	local var_16_3, var_16_4 = gui_resolution()

	return var_16_3 * var_16_1, var_16_4 * var_16_2
end

function Application.screen_resolution()
	return application_resolution()
end

camera_world_to_screen = camera_world_to_screen or Camera.world_to_screen

function Camera.world_to_screen(...)
	local var_18_0 = camera_world_to_screen(...)

	if Managers.splitscreen and Managers.splitscreen:active() then
		var_18_0[1] = var_18_0[1] * SPLITSCREEN_WIDTH
	end

	return var_18_0
end
