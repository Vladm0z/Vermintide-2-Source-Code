-- chunkname: @scripts/entity_system/systems/camera/camera_system.lua

require("scripts/unit_extensions/camera/generic_camera_extension")
require("scripts/unit_extensions/camera/states/camera_state_helper")
require("scripts/unit_extensions/camera/states/camera_state")
require("scripts/unit_extensions/camera/states/camera_state_idle")
require("scripts/unit_extensions/camera/states/camera_state_follow")
require("scripts/unit_extensions/camera/states/camera_state_follow_third_person")
require("scripts/unit_extensions/camera/states/camera_state_follow_third_person_ledge")
require("scripts/unit_extensions/camera/states/camera_state_follow_third_person_over_shoulder")
require("scripts/unit_extensions/camera/states/camera_state_follow_third_person_smart_climbing")
require("scripts/unit_extensions/camera/states/camera_state_follow_third_person_tunneling")
require("scripts/unit_extensions/camera/states/camera_state_follow_chaos_spawn_grabbed")
require("scripts/unit_extensions/camera/states/camera_state_observer")
require("scripts/unit_extensions/camera/states/camera_state_attract")
require("scripts/unit_extensions/camera/states/camera_state_interaction")
require("scripts/unit_extensions/camera/states/camera_state_observer_spectator")

CameraSystem = class(CameraSystem, ExtensionSystemBase)

local var_0_0 = {
	"GenericCameraExtension"
}
local var_0_1 = {
	"rpc_set_observer_camera"
}

CameraSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	CameraSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0.camera_units = {}
	arg_1_0.unit_extension_data = {}
	arg_1_0.input_manager = arg_1_1.input_manager

	local var_1_0 = arg_1_1.network_event_delegate

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0.network_event_delegate = var_1_0
end

CameraSystem.destroy = function (arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

CameraSystem.idle_camera_dummy_spawned = function (arg_3_0, arg_3_1)
	local var_3_0 = Unit.local_position(arg_3_1, 0)
	local var_3_1 = Unit.local_rotation(arg_3_1, 0)

	for iter_3_0, iter_3_1 in pairs(arg_3_0.camera_units) do
		local var_3_2 = arg_3_0.unit_extension_data[iter_3_1]

		var_3_2:set_idle_position(var_3_0)
		var_3_2:set_idle_rotation(var_3_1)
	end
end

CameraSystem.external_state_change = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0.camera_units[arg_4_1]
	local var_4_1 = arg_4_0.unit_extension_data[var_4_0]

	if var_4_1 then
		var_4_1:set_external_state_change(arg_4_2, arg_4_3)
	end
end

CameraSystem.external_state_change_delayed = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0.camera_units[arg_5_1]
	local var_5_1 = arg_5_0.unit_extension_data[var_5_0]

	if var_5_1 then
		var_5_1:set_delayed_external_state_change(arg_5_2, arg_5_3, arg_5_4)
	end
end

CameraSystem.set_follow_unit = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0.camera_units[arg_6_1]
	local var_6_1 = arg_6_0.unit_extension_data[var_6_0]

	if var_6_1 then
		local var_6_2 = ScriptUnit.extension(var_6_0, "camera_state_machine_system")

		var_6_1:set_follow_unit(arg_6_2, arg_6_3)

		local var_6_3 = var_6_2.state_machine.state_current

		if var_6_3.refresh_follow_unit then
			local var_6_4 = arg_6_2 and Unit.node(arg_6_2, arg_6_3) or nil

			var_6_3:refresh_follow_unit(arg_6_2, var_6_4)
		end
	end
end

CameraSystem.get_follow_data = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.camera_units[arg_7_1]
	local var_7_1 = arg_7_0.unit_extension_data[var_7_0]

	if var_7_1 then
		local var_7_2, var_7_3 = var_7_1:get_follow_data()

		return var_7_2, var_7_3
	end
end

CameraSystem.update_tunnel_camera_position = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.camera_units[arg_8_1]
	local var_8_1 = ScriptUnit.has_extension(var_8_0, "camera_state_machine_system")

	if var_8_1 then
		local var_8_2 = var_8_1.state_machine.state_current

		if var_8_2.update_tunnel_camera_position then
			var_8_2:update_tunnel_camera_position(arg_8_2)
		end
	end
end

CameraSystem.local_player_created = function (arg_9_0, arg_9_1)
	local var_9_0 = Managers.state.camera
	local var_9_1 = arg_9_1.viewport_name

	arg_9_0:_setup_viewport(var_9_1)
	arg_9_0:_setup_camera(var_9_1)
	arg_9_0:_setup_camera_unit(arg_9_1, var_9_1)
	var_9_0:set_camera_node(var_9_1, "first_person", "first_person_node")

	local var_9_2 = arg_9_0.camera_units[arg_9_1]

	arg_9_1:set_camera_follow_unit(var_9_2)
end

CameraSystem._setup_viewport = function (arg_10_0, arg_10_1)
	Managers.state.camera:create_viewport(arg_10_1, Vector3.zero(), Quaternion.identity())
end

CameraSystem._setup_camera = function (arg_11_0, arg_11_1)
	local var_11_0 = ScriptWorld.viewport(arg_11_0.world, arg_11_1)
	local var_11_1 = ScriptViewport.camera(var_11_0)
	local var_11_2 = Managers.state.camera

	var_11_2:load_node_tree(arg_11_1, "default", "world")
	var_11_2:load_node_tree(arg_11_1, "first_person", "first_person")
	var_11_2:load_node_tree(arg_11_1, "player_dead", "player_dead")
	var_11_2:load_node_tree(arg_11_1, "cutscene", "cutscene")
end

CameraSystem._setup_camera_unit = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = DefaultUnits.standard.backlit_camera
	local var_12_1 = "camera_unit"
	local var_12_2 = Vector3.zero()
	local var_12_3 = Quaternion.identity()
	local var_12_4 = {}
	local var_12_5 = arg_12_1:profile_index() or 1
	local var_12_6 = SPProfiles[var_12_5]
	local var_12_7 = var_12_6.careers
	local var_12_8 = arg_12_1:career_index() or 1
	local var_12_9 = var_12_6.careers[var_12_8]
	local var_12_10 = {}

	for iter_12_0, iter_12_1 in ipairs(var_12_9.camera_state_list) do
		var_12_10[#var_12_10 + 1] = rawget(_G, iter_12_1)
	end

	local var_12_11 = {
		camera_state_machine_system = {
			start_state = "idle",
			camera_state_class_list = var_12_10
		},
		camera_system = {
			player = arg_12_1
		}
	}
	local var_12_12 = Managers.state.unit_spawner:spawn_local_unit_with_extensions(var_12_0, var_12_1, var_12_11, var_12_2, var_12_3)

	arg_12_0.camera_units[arg_12_1] = var_12_12

	local var_12_13 = ScriptUnit.extension(var_12_12, "camera_system")

	arg_12_0.unit_extension_data[var_12_12] = var_12_13

	var_12_13:set_idle_position(var_12_2)
	var_12_13:set_idle_rotation(var_12_3)
	Unit.set_data(var_12_12, "camera", "settings_tree", "first_person")
	Unit.set_data(var_12_12, "camera", "settings_node", "first_person_node")
	Managers.state.camera:set_node_tree_root_unit(arg_12_2, "first_person", var_12_12, "rp_root", true)
	Managers.state.camera:set_node_tree_root_unit(arg_12_2, "player_dead", var_12_12, "rp_root", true)
	Managers.state.camera:set_node_tree_root_unit(arg_12_2, "default", var_12_12, "rp_root", true)

	if not script_data.disable_camera_backlight then
		local var_12_14 = LevelHelper:current_level_settings().camera_backlight

		if var_12_14 then
			local var_12_15 = Unit.light(var_12_12, "light")

			if var_12_15 then
				Light.set_color(var_12_15, var_12_14.color:unbox())
				Light.set_intensity(var_12_15, var_12_14.intensity)
				Light.set_falloff_start(var_12_15, var_12_14.start_falloff)
				Light.set_falloff_end(var_12_15, var_12_14.end_falloff)
			end
		end
	end
end

CameraSystem.set_backlight_color = function (arg_13_0, arg_13_1, arg_13_2)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.camera_units) do
		local var_13_0 = Unit.light(iter_13_1, "light")

		Light.set_color(var_13_0, arg_13_1)
		Light.set_intensity(var_13_0, arg_13_2)
	end
end

CameraSystem.set_backlight_falloff = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.camera_units) do
		local var_14_0 = Unit.light(iter_14_1, "light")

		Light.set_falloff_start(var_14_0, arg_14_1)
		Light.set_falloff_end(var_14_0, arg_14_2)
	end
end

local var_0_2 = {}

CameraSystem.update = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.dt
	local var_15_1 = arg_15_1.t
	local var_15_2 = Managers.state.camera

	for iter_15_0, iter_15_1 in pairs(arg_15_0.camera_units) do
		local var_15_3 = iter_15_0.viewport_name
		local var_15_4 = Unit.get_data(iter_15_1, "camera", "settings_node")

		if var_15_4 ~= var_15_2:current_camera_node(var_15_3) then
			local var_15_5 = Unit.get_data(iter_15_1, "camera", "settings_tree")

			var_15_2:set_camera_node(var_15_3, var_15_5, var_15_4)
		end

		var_15_2:update(var_15_0, var_15_1, var_15_3)
		arg_15_0.unit_extension_data[iter_15_1]:update(iter_15_1, var_0_2, var_15_0, arg_15_1, var_15_1)
	end
end

CameraSystem.post_update = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.dt
	local var_16_1 = arg_16_1.t
	local var_16_2 = Managers.state.camera

	for iter_16_0, iter_16_1 in pairs(arg_16_0.camera_units) do
		local var_16_3 = iter_16_0.viewport_name

		var_16_2:post_update(var_16_0, var_16_1, var_16_3)
	end
end

CameraSystem.rpc_set_observer_camera = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = Managers.player:local_player(arg_17_2)

	CharacterStateHelper.change_camera_state(var_17_0, "observer")
end

CameraSystem.initialize_camera_states = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = SPProfiles[arg_18_2].careers[arg_18_3].camera_state_list
	local var_18_1 = {}

	for iter_18_0, iter_18_1 in ipairs(var_18_0) do
		var_18_1[#var_18_1 + 1] = rawget(_G, iter_18_1)
	end

	ScriptUnit.has_extension(arg_18_1.camera_follow_unit, "camera_state_machine_system"):reinitialize_camera_states(var_18_1, "idle")
end
