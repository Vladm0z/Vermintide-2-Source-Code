-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_system.lua

LocomotionSystem = class(LocomotionSystem, ExtensionSystemBase)

require("scripts/unit_extensions/default_player_unit/player_unit_locomotion_extension")
require("scripts/unit_extensions/default_player_unit/player_husk_locomotion_extension")
require("scripts/entity_system/systems/locomotion/locomotion_templates_ai")
require("scripts/entity_system/systems/locomotion/locomotion_templates_ai_c")
require("scripts/entity_system/systems/locomotion/locomotion_templates_ai_husk")
require("scripts/entity_system/systems/locomotion/locomotion_templates_player")

local LocomotionTemplates = LocomotionTemplates
local tbl = {
	"rpc_set_animation_driven_script_movement",
	"rpc_set_script_driven",
	"rpc_set_animation_driven",
	"rpc_set_animation_translation_scale",
	"rpc_set_animation_rotation_scale",
	"rpc_disable_locomotion",
	"rpc_teleport_unit_to",
	"rpc_teleport_unit_with_yaw_rotation",
	"rpc_enable_linked_movement",
	"rpc_disable_linked_movement",
	"rpc_add_external_velocity",
	"rpc_add_external_velocity_with_upper_limit",
	"rpc_constrain_ai",
	"rpc_set_on_moving_platform",
	"rpc_hot_join_nail_to_wall_fix",
	"rpc_set_forced_velocity",
	"rpc_set_affected_by_gravity",
	"rpc_set_linked_transport_driven"
}
local tbl_2 = {
	"AiHuskLocomotionExtension",
	"AILocomotionExtension",
	"AILocomotionExtensionC",
	"PlayerHuskLocomotionExtension",
	"PlayerUnitLocomotionExtension"
}

LocomotionSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	LocomotionSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.world = arg_1_1.world
	self.animation_lod_units = {}
	self.player_units = {}
	self.template_data = {}

	for k, v in pairs(LocomotionTemplates) do
		if k ~= "AILocomotionExtensionC" then
			local tbl_3 = {}

			v.init(tbl_3, GLOBAL_AI_NAVWORLD)

			self.template_data[k] = tbl_3
		elseif k == "PlayerUnitLocomotionExtension" then
			local tbl_4 = {}

			v.init(tbl_4, GLOBAL_AI_NAVWORLD)

			self.template_data[k] = tbl_4
		end
	end

	EngineOptimizedExtensions.init_husk_extensions()

	if not GameSettingsDevelopment.use_engine_optimized_ai_locomotion then
		local get_data = World.get_data(self.world, "physics_world")
		local game = Managers.state.network:game()

		EngineOptimizedExtensions.init_extensions(get_data, GLOBAL_AI_NAVWORLD, game)
	end

	if not GameSettingsDevelopment.use_engine_optimized_ai_locomotion then
		tbl_2.AILocomotionExtensionC = nil
	end

	EngineOptimized.bone_lod_init(GameSettingsDevelopment.bone_lod_husks.lod_in_range_sq, GameSettingsDevelopment.bone_lod_husks.lod_out_range_sq, GameSettingsDevelopment.bone_lod_husks.lod_multiplier)
end

LocomotionSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
	EngineOptimized.bone_lod_destroy()
	EngineOptimizedExtensions.destroy_husk_extensions()

	if not GameSettingsDevelopment.use_engine_optimized_ai_locomotion then
		EngineOptimizedExtensions.destroy_extensions()
	end
end

LocomotionSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if arg_3_3 == "AILocomotionExtension" then
		local unit_game_object_id = network_manager:unit_game_object_id(selected_unit)
		local var_3_1 = BLACKBOARDS[arg_3_2]
		local _wanted_destination = var_3_1.navigation_extension._wanted_destination
		local num = 20
		local run_speed = var_3_1.breed.run_speed

		EngineOptimized.ai_locomotion_register_extension(arg_3_2, unit_game_object_id, _wanted_destination, num, run_speed, breed.sync_full_rotation)
	else
		arg_3_4.system_data = self.template_data[arg_3_3]

		return (LocomotionSystem.super.on_add_extension(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4))
	end
end

LocomotionSystem.extensions_ready = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local extension = ScriptUnit.extension(arg_4_2, "locomotion_system")

	if not (arg_4_3 == "AILocomotionExtensionC" or arg_4_3 == "AILocomotionExtension" or arg_4_3 ~= "AiHuskLocomotionExtension") then
		if not (not (extension.breed.bone_lod_level > 0) or script_data.bone_lod_disable) then
			extension.bone_lod_extension_id = EngineOptimized.bone_lod_register_extension(arg_4_2)
			arg_4_0.animation_lod_units[arg_4_2] = extension
		end
	else
		arg_4_0.player_units[arg_4_2] = extension
	end
end

LocomotionSystem.on_remove_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_cleanup_extension(arg_5_1, arg_5_2)
	LocomotionSystem.super.on_remove_extension(self, arg_5_1, arg_5_2)
end

LocomotionSystem.on_freeze_extension = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

LocomotionSystem._cleanup_extension = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not (arg_7_2 == "AILocomotionExtensionC" or arg_7_2 == "AILocomotionExtension" or arg_7_2 ~= "AiHuskLocomotionExtension") then
		local var_7_0 = self.animation_lod_units[arg_7_1]

		if not var_7_0 then
			EngineOptimized.bone_lod_unregister_extension(var_7_0.bone_lod_extension_id)

			var_7_0.bone_lod_extension_id = nil
			self.animation_lod_units[arg_7_1] = nil
		end
	end
end

LocomotionSystem.freeze = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	fassert(arg_8_2 == "AILocomotionExtensionC" or arg_8_2 == "AiHuskLocomotionExtension", "Unsupported freeze extension")
	self:_cleanup_extension(arg_8_1, arg_8_2)
	ScriptUnit.extension(arg_8_1, "locomotion_system"):freeze(arg_8_3)
end

LocomotionSystem.unfreeze = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local extension = ScriptUnit.extension(arg_9_1, "locomotion_system")

	extension:unfreeze(arg_9_1)

	if not ((arg_9_2 == "AILocomotionExtensionC" or arg_9_2 == "AILocomotionExtension" or arg_9_2 == "AiHuskLocomotionExtension") and not (extension.breed.bone_lod_level > 0) or script_data.bone_lod_disable) then
		extension.bone_lod_extension_id = EngineOptimized.bone_lod_register_extension(arg_9_1)
		arg_9_0.animation_lod_units[arg_9_1] = extension
	end
end

LocomotionSystem.post_update = function (self, arg_10_1, arg_10_2)
	-- function 10
	local dt = arg_10_1.dt

	self:post_update_extension("PlayerUnitLocomotionExtension", dt, arg_10_1, arg_10_2)
	LocomotionSystem.super.post_update(self, arg_10_1, arg_10_2)
end

LocomotionSystem.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	self:update_extensions(arg_11_1, arg_11_2)
	self:update_animation_lods()
	self:update_actor_proximity_shapes()
end

LocomotionSystem.update_extensions = function (self, arg_12_1, arg_12_2)
	-- function 12
	local dt = arg_12_1.dt

	self:update_extension("PlayerHuskLocomotionExtension", dt, arg_12_1, arg_12_2)
	self:update_extension("PlayerUnitLocomotionExtension", dt, arg_12_1, arg_12_2)

	if not GameSettingsDevelopment.use_engine_optimized_ai_locomotion then
		if not self.is_server then
			LocomotionTemplates.AILocomotionExtensionC.update(nil, arg_12_2, dt)
		else
			local AiHuskLocomotionExtension = self.template_data.AiHuskLocomotionExtension

			LocomotionTemplates.AiHuskLocomotionExtension.update(AiHuskLocomotionExtension, arg_12_2, dt)
		end

		local PlayerUnitLocomotionExtension = self.template_data.PlayerUnitLocomotionExtension

		LocomotionTemplates.PlayerUnitLocomotionExtension.update(PlayerUnitLocomotionExtension, arg_12_2, dt)
	else
		for k, v in pairs(self.template_data) do
			LocomotionTemplates[k].update(v, arg_12_2, dt)
		end
	end
end

LocomotionSystem.set_override_player = function (self, arg_13_1)
	-- function 13
	self._override_player = arg_13_1
end

LocomotionSystem.update_animation_lods = function (self)
	-- function 14
	if not DEDICATED_SERVER then
		return
	end

	local _override_player = self._override_player

	_override_player = _override_player or Managers.player:local_player()

	local viewport_name = _override_player.viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)
	local camera = ScriptViewport.camera(viewport)

	EngineOptimized.bone_lod_update(self.world, camera)
end

LocomotionSystem.update_actor_proximity_shapes = function (self)
	-- function 15
	local POSITION_LOOKUP = POSITION_LOOKUP
	local player = Managers.player
	local get_data = World.get_data(self.world, "physics_world")
	local degrees_to_radians = math.degrees_to_radians(17)
	local forward = Quaternion.forward
	local human_and_bot_players = player:human_and_bot_players()

	for k, v in pairs(human_and_bot_players) do
		local player_unit = v.player_unit

		if not (not Unit.alive(player_unit) and v.remote) then
			local extension = ScriptUnit.extension(player_unit, "first_person_system")
			local extension_2 = ScriptUnit.extension(player_unit, "inventory_system")
			local current_position = extension:current_position()
			local var_15_10 = forward(extension:current_rotation())
			local var_15_11

			if extension_2:get_wielded_slot_name() == "slot_ranged" then
				local equipment = extension_2:equipment()
				local right_hand_wielded_unit = equipment.right_hand_wielded_unit

				right_hand_wielded_unit = right_hand_wielded_unit or equipment.left_hand_wielded_unit

				if not right_hand_wielded_unit and not ScriptUnit.has_extension(right_hand_wielded_unit, "spread_system") then
					local get_current_pitch_and_yaw, var_15_15 = ScriptUnit.extension(right_hand_wielded_unit, "spread_system"):get_current_pitch_and_yaw()

					var_15_11 = math.degrees_to_radians(math.max(get_current_pitch_and_yaw, var_15_15))
				end
			end

			PhysicsWorld.commit_actor_proximity_shape(get_data, current_position, var_15_10, 36, var_15_11, true)
		end
	end
end

LocomotionSystem.rpc_set_affected_by_gravity = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local unit = self.unit_storage:unit(arg_16_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_16_2)

		return
	end

	ScriptUnit.extension(unit, "locomotion_system"):set_affected_by_gravity(arg_16_3)
end

local num = 9

LocomotionSystem.rpc_set_animation_driven_movement = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	-- function 17
	local unit = self.unit_storage:unit(arg_17_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_17_2)

		return
	end

	local extension = ScriptUnit.extension(unit, "locomotion_system")

	extension:set_animation_driven(arg_17_3, arg_17_5, arg_17_4, arg_17_6)

	if not arg_17_3 then
		local local_position = Unit.local_position(unit, 0)
		local distance_squared = Vector3.distance_squared(local_position, arg_17_7)

		if distance_squared > num then
			local unit_breed = AiUtils.unit_breed(unit)
			local name

			if not unit_breed then
				name = unit_breed.name

				if not name then
					-- Nothing
				end
			end

			name = "n/a"

			::label_17_0::

			Managers.telemetry_events:breed_position_desync(local_position, arg_17_7, distance_squared, name)
		end

		extension:teleport_to(arg_17_7, arg_17_8, extension:current_velocity())
	end
end

LocomotionSystem.rpc_set_animation_driven_script_movement = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	self:rpc_set_animation_driven_movement(arg_18_1, arg_18_2, true, true, arg_18_5, false, arg_18_3, arg_18_4)
end

LocomotionSystem.rpc_set_animation_driven = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	self:rpc_set_animation_driven_movement(arg_19_1, arg_19_2, true, false, arg_19_5, false, arg_19_3, arg_19_4)
end

LocomotionSystem.rpc_set_script_driven = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	self:rpc_set_animation_driven_movement(arg_20_1, arg_20_2, false, true, arg_20_3, false)
end

LocomotionSystem.rpc_set_linked_transport_driven = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	self:rpc_set_animation_driven_movement(arg_21_1, arg_21_2, false, true, arg_21_3, true)
end

LocomotionSystem.rpc_set_animation_translation_scale = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local unit = self.unit_storage:unit(arg_22_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_22_2)

		return
	end

	ScriptUnit.extension(unit, "locomotion_system"):set_animation_translation_scale(arg_22_3)

	if not self.is_server then
		local var_22_1 = CHANNEL_TO_PEER_ID[arg_22_1]

		self.network_transmit:send_rpc_clients_except("rpc_set_animation_translation_scale", var_22_1, arg_22_2, arg_22_3)
	end
end

LocomotionSystem.rpc_set_animation_rotation_scale = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local unit = self.unit_storage:unit(arg_23_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_23_2)

		return
	end

	ScriptUnit.extension(unit, "locomotion_system"):set_animation_rotation_scale(arg_23_3)
end

LocomotionSystem.rpc_disable_locomotion = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local unit = self.unit_storage:unit(arg_24_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_24_2)

		return
	end

	local extension = ScriptUnit.extension(unit, "locomotion_system")
	local var_24_2 = LocomotionUtils[NetworkLookup.movement_funcs[arg_24_4]]

	extension:set_disabled(arg_24_3, var_24_2)

	if not self.is_server then
		local var_24_3 = CHANNEL_TO_PEER_ID[arg_24_1]

		self.network_transmit:send_rpc_clients_except("rpc_disable_locomotion", var_24_3, arg_24_2, arg_24_3, arg_24_4)
	end
end

LocomotionSystem.rpc_teleport_unit_to = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	local unit = self.unit_storage:unit(arg_25_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_25_2)

		return
	end

	ScriptUnit.extension(unit, "locomotion_system"):teleport_to(arg_25_3, arg_25_4)

	if not self.is_server then
		local var_25_1 = CHANNEL_TO_PEER_ID[arg_25_1]

		self.network_transmit:send_rpc_clients_except("rpc_teleport_unit_to", var_25_1, arg_25_2, arg_25_3, arg_25_4)
	end
end

LocomotionSystem.rpc_teleport_unit_with_yaw_rotation = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	local unit = self.unit_storage:unit(arg_26_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_26_2)

		return
	end

	local var_26_1 = Quaternion(Vector3.up(), arg_26_4)

	ScriptUnit.extension(unit, "locomotion_system"):teleport_to(arg_26_3, var_26_1)
end

LocomotionSystem.rpc_enable_linked_movement = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
	-- function 27
	local unit = self.unit_storage:unit(arg_27_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_27_2)

		return
	end

	local extension = ScriptUnit.extension(unit, "locomotion_system")
	local current_level = LevelHelper:current_level(self.world)
	local unit_by_index = Level.unit_by_index(current_level, arg_27_3)

	extension:enable_linked_movement(unit_by_index, arg_27_4, arg_27_5)
end

LocomotionSystem.rpc_disable_linked_movement = function (self, arg_28_1, arg_28_2)
	-- function 28
	local unit = self.unit_storage:unit(arg_28_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_28_2)

		return
	end

	ScriptUnit.extension(unit, "locomotion_system"):disable_linked_movement()
end

LocomotionSystem.rpc_add_external_velocity = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local unit = self.unit_storage:unit(arg_29_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_29_2)

		return
	end

	ScriptUnit.extension(unit, "locomotion_system"):add_external_velocity(arg_29_3)
end

LocomotionSystem.rpc_add_external_velocity_with_upper_limit = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	local unit = self.unit_storage:unit(arg_30_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_30_2)

		return
	end

	ScriptUnit.extension(unit, "locomotion_system"):add_external_velocity(arg_30_3, arg_30_4)
end

LocomotionSystem.rpc_set_forced_velocity = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local unit = self.unit_storage:unit(arg_31_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_31_2)

		return
	end

	ScriptUnit.extension(unit, "locomotion_system"):set_forced_velocity(arg_31_3)
end

LocomotionSystem.rpc_constrain_ai = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	local unit = self.unit_storage:unit(arg_32_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_32_2)

		return
	end

	local var_32_1 = arg_32_4[1]
	local var_32_2 = arg_32_4[2]

	ScriptUnit.extension(unit, "locomotion_system"):set_constrained(arg_32_3, var_32_1, var_32_2)
end

LocomotionSystem.rpc_set_on_moving_platform = function (self, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	local unit = self.unit_storage:unit(arg_33_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_33_2)

		return
	end

	local current_level = LevelHelper:current_level(self.world)
	local unit_by_index = Level.unit_by_index(current_level, arg_33_3)

	ScriptUnit.extension(unit, "locomotion_system"):set_on_moving_platform(unit_by_index)
end

LocomotionSystem.rpc_hot_join_nail_to_wall_fix = function (self, arg_34_1, arg_34_2)
	-- function 34
	local unit = self.unit_storage:unit(arg_34_2)

	if not Unit.has_animation_state_machine(unit) then
		Unit.animation_event(unit, "ragdoll")
	end
end
