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

local tbl = {
	"GenericCameraExtension"
}
local tbl_2 = {
	"rpc_set_observer_camera"
}

CameraSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	CameraSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self.camera_units = {}
	self.unit_extension_data = {}
	self.input_manager = arg_1_1.input_manager

	local network_event_delegate = arg_1_1.network_event_delegate

	network_event_delegate:register(self, unpack(tbl_2))

	self.network_event_delegate = network_event_delegate
end

CameraSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

CameraSystem.idle_camera_dummy_spawned = function (self, arg_3_1)
	-- function 3
	local local_position = Unit.local_position(arg_3_1, 0)
	local local_rotation = Unit.local_rotation(arg_3_1, 0)

	for k, v in pairs(self.camera_units) do
		local var_3_2 = self.unit_extension_data[v]

		var_3_2:set_idle_position(local_position)
		var_3_2:set_idle_rotation(local_rotation)
	end
end

CameraSystem.external_state_change = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local var_4_0 = self.camera_units[arg_4_1]
	local var_4_1 = self.unit_extension_data[var_4_0]

	if not var_4_1 then
		var_4_1:set_external_state_change(arg_4_2, arg_4_3)
	end
end

CameraSystem.external_state_change_delayed = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local var_5_0 = self.camera_units[arg_5_1]
	local var_5_1 = self.unit_extension_data[var_5_0]

	if not var_5_1 then
		var_5_1:set_delayed_external_state_change(arg_5_2, arg_5_3, arg_5_4)
	end
end

CameraSystem.set_follow_unit = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = self.camera_units[arg_6_1]
	local var_6_1 = self.unit_extension_data[var_6_0]

	if not var_6_1 then
		local extension = ScriptUnit.extension(var_6_0, "camera_state_machine_system")

		var_6_1:set_follow_unit(arg_6_2, arg_6_3)

		local state_current = extension.state_machine.state_current

		if not state_current.refresh_follow_unit then
			local node

			if not arg_6_2 then
				node = Unit.node(arg_6_2, arg_6_3)

				if not node then
					-- Nothing
				end
			end

			node = nil

			::label_6_0::

			state_current:refresh_follow_unit(arg_6_2, node)
		end
	end
end

CameraSystem.get_follow_data = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self.camera_units[arg_7_1]
	local var_7_1 = self.unit_extension_data[var_7_0]

	if not var_7_1 then
		local get_follow_data, var_7_3 = var_7_1:get_follow_data()

		return get_follow_data, var_7_3
	end
end

CameraSystem.update_tunnel_camera_position = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = self.camera_units[arg_8_1]
	local has_extension = ScriptUnit.has_extension(var_8_0, "camera_state_machine_system")

	if not has_extension then
		local state_current = has_extension.state_machine.state_current

		if not state_current.update_tunnel_camera_position then
			state_current:update_tunnel_camera_position(arg_8_2)
		end
	end
end

CameraSystem.local_player_created = function (self, arg_9_1)
	-- function 9
	local camera = Managers.state.camera
	local viewport_name = arg_9_1.viewport_name

	self:_setup_viewport(viewport_name)
	self:_setup_camera(viewport_name)
	self:_setup_camera_unit(arg_9_1, viewport_name)
	camera:set_camera_node(viewport_name, "first_person", "first_person_node")

	local var_9_2 = self.camera_units[arg_9_1]

	arg_9_1:set_camera_follow_unit(var_9_2)
end

CameraSystem._setup_viewport = function (arg_10_0, arg_10_1)
	-- function 10
	Managers.state.camera:create_viewport(arg_10_1, Vector3.zero(), Quaternion.identity())
end

CameraSystem._setup_camera = function (self, arg_11_1)
	-- function 11
	local viewport = ScriptWorld.viewport(self.world, arg_11_1)
	local camera = ScriptViewport.camera(viewport)
	local camera_2 = Managers.state.camera

	camera_2:load_node_tree(arg_11_1, "default", "world")
	camera_2:load_node_tree(arg_11_1, "first_person", "first_person")
	camera_2:load_node_tree(arg_11_1, "player_dead", "player_dead")
	camera_2:load_node_tree(arg_11_1, "cutscene", "cutscene")
end

CameraSystem._setup_camera_unit = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local backlit_camera = DefaultUnits.standard.backlit_camera
	local str = "camera_unit"
	local zero = Vector3.zero()
	local identity = Quaternion.identity()
	local tbl = {}
	local profile_index = arg_12_1:profile_index()

	profile_index = profile_index or 1

	local var_12_6 = SPProfiles[profile_index]
	local careers = var_12_6.careers
	local career_index = arg_12_1:career_index()

	career_index = career_index or 1

	local var_12_9 = var_12_6.careers[career_index]
	local tbl_2 = {}

	for i, v in ipairs(var_12_9.camera_state_list) do
		tbl_2[#tbl_2 + 1] = rawget(_G, v)
	end

	local tbl_3 = {
		camera_state_machine_system = {
			start_state = "idle",
			camera_state_class_list = tbl_2
		},
		camera_system = {
			player = arg_12_1
		}
	}
	local spawn_local_unit_with_extensions = Managers.state.unit_spawner:spawn_local_unit_with_extensions(backlit_camera, str, tbl_3, zero, identity)

	arg_12_0.camera_units[arg_12_1] = spawn_local_unit_with_extensions

	local extension = ScriptUnit.extension(spawn_local_unit_with_extensions, "camera_system")

	arg_12_0.unit_extension_data[spawn_local_unit_with_extensions] = extension

	extension:set_idle_position(zero)
	extension:set_idle_rotation(identity)
	Unit.set_data(spawn_local_unit_with_extensions, "camera", "settings_tree", "first_person")
	Unit.set_data(spawn_local_unit_with_extensions, "camera", "settings_node", "first_person_node")
	Managers.state.camera:set_node_tree_root_unit(arg_12_2, "first_person", spawn_local_unit_with_extensions, "rp_root", true)
	Managers.state.camera:set_node_tree_root_unit(arg_12_2, "player_dead", spawn_local_unit_with_extensions, "rp_root", true)
	Managers.state.camera:set_node_tree_root_unit(arg_12_2, "default", spawn_local_unit_with_extensions, "rp_root", true)

	if not script_data.disable_camera_backlight then
		local camera_backlight = LevelHelper:current_level_settings().camera_backlight

		if not camera_backlight then
			local light = Unit.light(spawn_local_unit_with_extensions, "light")

			if not light then
				Light.set_color(light, camera_backlight.color:unbox())
				Light.set_intensity(light, camera_backlight.intensity)
				Light.set_falloff_start(light, camera_backlight.start_falloff)
				Light.set_falloff_end(light, camera_backlight.end_falloff)
			end
		end
	end
end

CameraSystem.set_backlight_color = function (self, arg_13_1, arg_13_2)
	-- function 13
	for k, v in pairs(self.camera_units) do
		local light = Unit.light(v, "light")

		Light.set_color(light, arg_13_1)
		Light.set_intensity(light, arg_13_2)
	end
end

CameraSystem.set_backlight_falloff = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	for k, v in pairs(self.camera_units) do
		local light = Unit.light(v, "light")

		Light.set_falloff_start(light, arg_14_1)
		Light.set_falloff_end(light, arg_14_2)
	end
end

local tbl_3 = {}

CameraSystem.update = function (self, arg_15_1)
	-- function 15
	local dt = arg_15_1.dt
	local t = arg_15_1.t
	local camera = Managers.state.camera

	for k, v in pairs(self.camera_units) do
		local viewport_name = k.viewport_name
		local get_data = Unit.get_data(v, "camera", "settings_node")

		if get_data ~= camera:current_camera_node(viewport_name) then
			local get_data_2 = Unit.get_data(v, "camera", "settings_tree")

			camera:set_camera_node(viewport_name, get_data_2, get_data)
		end

		camera:update(dt, t, viewport_name)
		self.unit_extension_data[v]:update(v, tbl_3, dt, arg_15_1, t)
	end
end

CameraSystem.post_update = function (self, arg_16_1)
	-- function 16
	local dt = arg_16_1.dt
	local t = arg_16_1.t
	local camera = Managers.state.camera

	for k, v in pairs(self.camera_units) do
		local viewport_name = k.viewport_name

		camera:post_update(dt, t, viewport_name)
	end
end

CameraSystem.rpc_set_observer_camera = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local local_player = Managers.player:local_player(arg_17_2)

	CharacterStateHelper.change_camera_state(local_player, "observer")
end

CameraSystem.initialize_camera_states = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local camera_state_list = SPProfiles[arg_18_2].careers[arg_18_3].camera_state_list
	local tbl = {}

	for i, v in ipairs(camera_state_list) do
		tbl[#tbl + 1] = rawget(_G, v)
	end

	ScriptUnit.has_extension(arg_18_1.camera_follow_unit, "camera_state_machine_system"):reinitialize_camera_states(tbl, "idle")
end
