-- chunkname: @scripts/unit_extensions/generic/generic_unit_interactor_extension.lua

require("scripts/helpers/interaction_helper")
require("scripts/unit_extensions/generic/interactions")

GenericUnitInteractorExtension = class(GenericUnitInteractorExtension)
INTERACT_RAY_DISTANCE = 2.5

local tbl = {}

GenericUnitInteractorExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world
	local dice_keeper = arg_1_1.dice_keeper
	local statistics_db = arg_1_1.statistics_db

	self.world = world
	self.unit = arg_1_2
	self.state = "waiting_to_interact"
	self.interaction_context = {
		data = {
			world = world,
			dice_keeper = dice_keeper,
			statistics_db = statistics_db,
			interactor_data = {}
		}
	}

	local owner = Managers.player:owner(arg_1_2)

	self.is_bot = not owner and owner.bot_player
	self.physics_world = World.get_data(world, "physics_world")
	self.is_server = Managers.player.is_server
	self._interactions_enabled = true
	self.exclusive_interaction_unit = nil
	self.units_in_range = {}
	self.units_in_range_back_buffer = {}

	self.interactable_unit_destroy_callback = function (arg_2_0)
		-- function 2
		local time = Managers.time:time("game")

		self:_stop_interaction(arg_2_0, time)
	end
end

GenericUnitInteractorExtension.extensions_ready = function (self)
	-- function 3
	self.status_extension = ScriptUnit.extension(self.unit, "status_system")
	self.health_extension = ScriptUnit.extension(self.unit, "health_system")
	self.buff_extension = ScriptUnit.extension(self.unit, "buff_system")
end

GenericUnitInteractorExtension.set_exclusive_interaction_unit = function (self, arg_4_1)
	-- function 4
	fassert(self.is_bot, "Trying to set exclusive interaction unit as player.")

	self.exclusive_interaction_unit = arg_4_1
end

GenericUnitInteractorExtension.destroy = function (self)
	-- function 5
	self:abort_interaction()

	local interactable_unit = self.interaction_context.interactable_unit

	if not Unit.alive(interactable_unit) then
		Managers.state.unit_spawner:remove_destroy_listener(interactable_unit, "interactable_unit")
	end
end

local tbl_2 = {
	buff_shared_medpack = true,
	buff_shared_medpack_temp_health = true,
	buff = true,
	arrow_poison_dot = true,
	volume_generic_dot = true,
	warpfire_ground = true,
	damage_over_time = true,
	life_tap = true,
	aoe_poison_dot = true,
	plague_ground = true,
	level = true,
	temporary_health_degen = true,
	health_degen = true,
	poison = true,
	vomit_ground = true,
	wounded_dot = true,
	gas = true,
	heal = true,
	burninating = true,
	life_drain = true
}

GenericUnitInteractorExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local world = self.world

	table.clear(tbl)

	if not (self.state == "waiting_to_interact" or Unit.alive(self.interaction_context.interactable_unit)) then
		InteractionHelper.printf("[GenericUnitInteractorExtension] not Unit.alive(self.interaction_context.interactable_unit)")
		self:abort_interaction()
	end

	if self.state == "waiting_to_interact" or self.status_extension:is_disabled() or not self.status_extension:is_catapulted() then
		self:abort_interaction()
	end

	if self.state ~= "waiting_to_interact" then
		local recent_damages, var_6_2 = self.health_extension:recent_damages()
		local flag = false

		for i = 1, var_6_2 / DamageDataIndex.STRIDE do
			local num = i - 1
			local var_6_5 = recent_damages[num * DamageDataIndex.STRIDE + DamageDataIndex.DAMAGE_AMOUNT]
			local var_6_6 = recent_damages[num * DamageDataIndex.STRIDE + DamageDataIndex.DAMAGE_TYPE]

			if not (not (var_6_5 > 0) or tbl_2[var_6_6]) then
				flag = true
			end
		end

		if not flag then
			local flag_2 = true
			local interaction_type = self.interaction_context.interaction_type
			local buff_extension = self.buff_extension

			if interaction_type == "heal" then
				flag_2 = not buff_extension:has_buff_type("no_interruption_bandage")
			end

			if not (not flag_2 and interaction_type ~= "revive") then
				flag_2 = not buff_extension:has_buff_perk("uninterruptible_revive")
			end

			if not flag_2 then
				self:abort_interaction()
			end
		end
	end

	if not (self.state ~= "waiting_to_interact" or self.status_extension:is_disabled()) then
		local interaction_context = self.interaction_context

		if not interaction_context.interactable_unit then
			interaction_context.interactable_unit = nil
			interaction_context.interaction_type = nil
		end

		if not self.is_bot then
			local exclusive_interaction_unit = self.exclusive_interaction_unit

			if not exclusive_interaction_unit then
				local has_extension = ScriptUnit.has_extension(exclusive_interaction_unit, "interactable_system")

				if not has_extension then
					interaction_context.interactable_unit = exclusive_interaction_unit
					interaction_context.interaction_type = has_extension:interaction_type()

					return
				end
			end
		else
			local res_w = RESOLUTION_LOOKUP.res_w
			local res_h = RESOLUTION_LOOKUP.res_h
			local num_2 = res_w * 0.5
			local num_3 = res_h * 0.5

			self.ray_casted = true

			local extension = ScriptUnit.extension(arg_6_1, "first_person_system")
			local current_position = extension:current_position()
			local current_rotation = extension:current_rotation()
			local forward = Quaternion.forward(current_rotation)
			local immediate_raycast, var_6_22 = self.physics_world:immediate_raycast(current_position, forward, INTERACT_RAY_DISTANCE, "all", "collision_filter", "filter_ray_interaction")
			local flag_3 = false
			local _get_player_camera = self:_get_player_camera()
			local huge = math.huge
			local var_6_26
			local var_6_27
			local units_in_range_back_buffer = self.units_in_range_back_buffer

			for j = 1, var_6_22 do
				local var_6_29 = immediate_raycast[j][4]

				if not var_6_29 then
					local unit = Actor.unit(var_6_29)

					if not (not unit and unit == self.unit) then
						if not ScriptUnit.has_extension(unit, "interactable_system") then
							local get_data = Unit.get_data(unit, "interaction_data", "interact_actor")

							if not (not get_data and Unit.actor(unit, get_data) ~= var_6_29) then
								local extension_2 = ScriptUnit.extension(unit, "interactable_system")

								if not extension_2:is_enabled() then
									local interaction_type_2 = extension_2:interaction_type()
									local can_interact, var_6_35, var_6_36 = self:can_interact(unit, interaction_type_2)
									local _check_if_interactable_in_chest = self:_check_if_interactable_in_chest(unit, current_position)

									if not ((can_interact or not var_6_35) and _check_if_interactable_in_chest) then
										local var_6_38 = InteractionDefinitions[var_6_36]
										local config = var_6_38.config

										config = config or var_6_38.get_config()

										local does_not_require_line_of_sight = config.does_not_require_line_of_sight
										local _claculate_interaction_distance_score = self:_claculate_interaction_distance_score(unit, current_position, num_2, num_3, _get_player_camera)
										local block_other_interactions = config.block_other_interactions

										if not (does_not_require_line_of_sight or flag_3) then
											if not block_other_interactions then
												interaction_context.interactable_unit = unit
												interaction_context.interaction_type = var_6_36

												return
											elseif _claculate_interaction_distance_score < huge then
												var_6_26 = unit
												var_6_27 = var_6_36
												huge = _claculate_interaction_distance_score
											end
										end

										if not can_interact then
											units_in_range_back_buffer[unit] = interaction_type_2

											if self.units_in_range[unit] == nil then
												self:in_range(unit, interaction_type_2, true)
											end
										end
									end
								end
							else
								flag_3 = true
							end
						else
							flag_3 = true
						end
					end
				end
			end

			for k, v in pairs(self.units_in_range) do
				if units_in_range_back_buffer[k] == nil then
					self:in_range(k, v, false)
				end
			end

			self.units_in_range, self.units_in_range_back_buffer = units_in_range_back_buffer, self.units_in_range

			table.clear(self.units_in_range_back_buffer)

			if not var_6_26 then
				interaction_context.interactable_unit = var_6_26
				interaction_context.interaction_type = var_6_27

				return
			end

			local var_6_43 = POSITION_LOOKUP[self.unit]
			local immediate_overlap, var_6_45 = PhysicsWorld.immediate_overlap(self.physics_world, "position", var_6_43, "shape", "sphere", "size", 0.3, "collision_filter", "filter_overlap_interaction")
			local var_6_46
			local huge_2 = math.huge

			for i4 = 1, var_6_45 do
				local var_6_48 = immediate_overlap[i4]

				if not var_6_48 then
					local unit_2 = Actor.unit(var_6_48)

					if not (not unit_2 and unit_2 == self.unit) then
						local _check_if_interactable_in_chest_2 = self:_check_if_interactable_in_chest(unit_2, current_position)
						local has_extension_2 = ScriptUnit.has_extension(unit_2, "interactable_system")

						if not has_extension_2 and _check_if_interactable_in_chest_2 or not has_extension_2:is_enabled() then
							local var_6_52 = POSITION_LOOKUP[unit_2]

							var_6_52 = var_6_52 or Unit.local_position(unit_2, 0)

							local distance_squared = Vector3.distance_squared(var_6_43, var_6_52)

							if distance_squared < huge_2 then
								huge_2 = distance_squared
								var_6_46 = unit_2
							end
						end
					end
				end
			end

			if not var_6_46 then
				local has_extension_3 = ScriptUnit.has_extension(var_6_46, "interactable_system")

				if not has_extension_3 then
					local interaction_type_3 = has_extension_3:interaction_type()
					local can_interact_2, var_6_57, var_6_58 = self:can_interact(var_6_46, interaction_type_3)

					if not can_interact_2 then
						interaction_context.interactable_unit = var_6_46
						interaction_context.interaction_type = var_6_58
					end
				end
			end
		end
	end

	local interaction_context_2 = self.interaction_context
	local interactable_unit = interaction_context_2.interactable_unit
	local data = interaction_context_2.data

	data.is_server = self.is_server

	local interaction_type_4 = interaction_context_2.interaction_type
	local var_6_63 = InteractionDefinitions[interaction_type_4]
	local config_2

	if not var_6_63 then
		config_2 = var_6_63.config

		if not config_2 then
			-- Nothing
		end

		config_2 = var_6_63.get_config()

		if not config_2 then
			-- Nothing
		end
	end

	config_2 = nil

	::label_6_0::

	local local_only = interaction_context_2.local_only

	if self.state == "starting_interaction" then
		var_6_63.client.start(world, arg_6_1, interactable_unit, data, config_2, arg_6_5)

		if not (not self.is_server and local_only) then
			var_6_63.server.start(world, arg_6_1, interactable_unit, data, config_2, arg_6_5)
		end

		self.state = "doing_interaction"
	end

	if self.state == "doing_interaction" then
		local update = var_6_63.client.update(world, arg_6_1, interactable_unit, data, config_2, arg_6_3, arg_6_5)

		update = not local_only and update and nil

		if not (not self.is_server and local_only) then
			update = var_6_63.server.update(world, arg_6_1, interactable_unit, data, config_2, arg_6_3, arg_6_5)
		end

		interaction_context_2.result = update

		if not (not update and update == InteractionResult.ONGOING) then
			InteractionHelper:complete_interaction(arg_6_1, interactable_unit, update)
		end
	end
end

GenericUnitInteractorExtension._check_if_interactable_in_chest = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not tbl[arg_7_1] then
		return true
	end

	if not ScriptUnit.has_extension(arg_7_1, "pickup_system") then
		return false
	end

	local box, var_7_1 = Unit.box(arg_7_1)
	local translation = Matrix4x4.translation(box)
	local direction_length, var_7_4 = Vector3.direction_length(translation - arg_7_2)

	if var_7_4 < math.epsilon then
		return true
	end

	local immediate_raycast, var_7_6, var_7_7, var_7_8, var_7_9 = PhysicsWorld.immediate_raycast(self.physics_world, translation, direction_length, var_7_4, "closest", "types", "both", "collision_filter", "filter_interactable_in_chest")

	if not immediate_raycast then
		tbl[arg_7_1] = true

		return true
	end

	return false
end

GenericUnitInteractorExtension._claculate_interaction_distance_score = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local world_position = Unit.world_position(arg_8_1, 0)
	local INTERACT_RAY_DISTANCE = INTERACT_RAY_DISTANCE
	local num = Vector3.distance_squared(world_position, arg_8_2) / (INTERACT_RAY_DISTANCE * INTERACT_RAY_DISTANCE)
	local world_to_screen = Camera.world_to_screen(arg_8_5, world_position)
	local var_8_4 = Vector3(arg_8_3 - world_to_screen.x, arg_8_4 - world_to_screen.z, 0)

	return num * (Vector3.length(var_8_4) / (arg_8_3 * 2))
end

GenericUnitInteractorExtension._get_player_camera = function (self)
	-- function 9
	local viewport_name = Managers.player:owner(self.unit).viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)

	return (ScriptViewport.camera(viewport))
end

GenericUnitInteractorExtension._stop_interaction = function (self, arg_10_1, arg_10_2)
	-- function 10
	Managers.state.unit_spawner:remove_destroy_listener(arg_10_1, "interactable_unit")

	local world = self.world
	local unit = self.unit
	local interaction_context = self.interaction_context
	local data = interaction_context.data

	data.is_server = self.is_server

	local interaction_type = interaction_context.interaction_type
	local var_10_5 = InteractionDefinitions[interaction_type]
	local config

	if not var_10_5 then
		config = var_10_5.config

		if not config then
			-- Nothing
		end

		config = var_10_5.get_config()

		if not config then
			-- Nothing
		end
	end

	config = nil

	::label_10_0::

	local local_only = interaction_context.local_only

	if not local_only then
		local game_object_or_level_id, var_10_9 = Managers.state.network:game_object_or_level_id(arg_10_1)

		if not (var_10_9 or game_object_or_level_id ~= nil) then
			InteractionHelper.printf("[GenericUnitInteractorExtension] game object doesnt exist, changing result from %s to %s", InteractionResult[interaction_context.result], InteractionResult[InteractionResult.FAILURE])

			interaction_context.result = InteractionResult.FAILURE
		end
	end

	local result = interaction_context.result

	if not (result == InteractionResult.ONGOING or result ~= nil) then
		result = InteractionResult.FAILURE
		interaction_context.result = result
	end

	InteractionHelper.printf("[GenericUnitInteractorExtension] Stopping interaction %s with result %s", interaction_type, InteractionResult[result])
	var_10_5.client.stop(world, unit, arg_10_1, data, config, arg_10_2, result)

	if not (not self.is_server and local_only) then
		var_10_5.server.stop(world, unit, arg_10_1, data, config, arg_10_2, result)
	end

	self.state = "waiting_to_interact"
end

GenericUnitInteractorExtension.is_interacting = function (self)
	-- function 11
	local interaction_type = self.interaction_context.interaction_type

	return self.state ~= "waiting_to_interact", interaction_type
end

GenericUnitInteractorExtension.is_stopping = function (self)
	-- function 12
	return self.state == "stopping_interaction"
end

GenericUnitInteractorExtension.is_waiting_for_interaction_approval = function (self)
	-- function 13
	return self.state == "waiting_for_confirmation"
end

GenericUnitInteractorExtension.is_aborting_interaction = function (self)
	-- function 14
	return self.state == "waiting_for_abort"
end

GenericUnitInteractorExtension.is_looking_at_interactable = function (self)
	-- function 15
	return self.interaction_context.interactable_unit ~= nil
end

GenericUnitInteractorExtension.in_range = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local interaction_context = self.interaction_context
	local flag = arg_16_1 or interaction_context.interactable_unit

	arg_16_2 = arg_16_2 or interaction_context.interaction_type

	local data = interaction_context.data
	local var_16_3 = InteractionDefinitions[arg_16_2]
	local in_range = var_16_3.client.in_range

	if not in_range then
		in_range(self.unit, flag, data, var_16_3.config, self.world, arg_16_3)
	end
end

GenericUnitInteractorExtension.enable_interactions = function (self, arg_17_1)
	-- function 17
	self._interactions_enabled = arg_17_1
end

GenericUnitInteractorExtension.can_interact = function (self, arg_18_1, arg_18_2)
	-- function 18
	local interaction_context = self.interaction_context
	local flag = arg_18_1 or interaction_context.interactable_unit

	if not self.buff_extension:has_buff_perk("disable_interactions") then
		return false
	end

	if self.state ~= "waiting_to_interact" then
		return false
	end

	if flag == nil then
		return false
	end

	if not Unit.alive(flag) then
		return false
	end

	if not self.status_extension:is_disabled() then
		return false
	end

	if not self._interactions_enabled then
		return false
	end

	arg_18_2 = arg_18_2 or interaction_context.interaction_type

	local game_mode = Managers.state.game_mode:game_mode()

	if not (not game_mode.allowed_interactions and game_mode:allowed_interactions(self.unit, arg_18_2)) then
		return false
	end

	local data = interaction_context.data
	local var_18_4 = InteractionDefinitions[arg_18_2]

	if not var_18_4 then
		return false
	end

	local can_interact = var_18_4.client.can_interact

	if not can_interact then
		local var_18_6, var_18_7, var_18_8 = can_interact(self.unit, flag, data, var_18_4.config, self.world)

		var_18_8 = var_18_8 or arg_18_2

		return var_18_6, var_18_7, var_18_8, flag
	end

	return true, nil, arg_18_2, flag
end

GenericUnitInteractorExtension.interaction_config = function (self)
	-- function 19
	local interaction_type = self.interaction_context.interaction_type
	local var_19_1 = InteractionDefinitions[interaction_type]
	local config

	if not var_19_1 then
		config = var_19_1.config

		if not config then
			-- Nothing
		end

		config = var_19_1.get_config()

		if not config then
			-- Nothing
		end
	end

	config = nil

	::label_19_0::

	return config
end

GenericUnitInteractorExtension.interaction_description = function (self, arg_20_1)
	-- function 20
	local interaction_context = self.interaction_context
	local interactable_unit = interaction_context.interactable_unit
	local data = interaction_context.data
	local interaction_type = interaction_context.interaction_type
	local var_20_4 = InteractionDefinitions[interaction_type]
	local config = var_20_4.config

	return var_20_4.client.hud_description(interactable_unit, data, config, arg_20_1, self.unit)
end

GenericUnitInteractorExtension.interaction_hold_input = function (self)
	-- function 21
	return self.interaction_context.hold_input
end

GenericUnitInteractorExtension.is_interacting_with_local_only_interact = function (self)
	-- function 22
	return self.interaction_context.local_only
end

GenericUnitInteractorExtension.interaction_camera_node = function (self)
	-- function 23
	local interaction_type = self.interaction_context.interaction_type

	return InteractionDefinitions[interaction_type].client.camera_node(self.unit, self.interaction_context.interactable_unit)
end

GenericUnitInteractorExtension.interactable_unit = function (self)
	-- function 24
	return self.interaction_context.interactable_unit
end

GenericUnitInteractorExtension.get_progress = function (self, arg_25_1)
	-- function 25
	fassert(self:is_interacting(), "Attempted to get interaction progress when interactor unit wasn't interacting.")

	local interaction_context = self.interaction_context
	local data = interaction_context.data
	local interaction_type = interaction_context.interaction_type
	local var_25_3 = InteractionDefinitions[interaction_type]
	local config

	if not var_25_3 then
		config = var_25_3.config

		if not config then
			-- Nothing
		end
	end

	config = nil

	::label_25_0::

	return var_25_3.client.get_progress(data, config, arg_25_1)
end

GenericUnitInteractorExtension.start_interaction = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	local interaction_context = self.interaction_context

	arg_26_2 = arg_26_2 or interaction_context.interactable_unit
	arg_26_3 = arg_26_3 or interaction_context.interaction_type

	InteractionHelper.printf("[GenericUnitInteractorExtension] start_interaction(interactable_unit=%s, interaction_type=%s)", arg_26_2, arg_26_3)

	interaction_context.interactable_unit = arg_26_2
	interaction_context.interaction_type = arg_26_3
	interaction_context.hold_input = arg_26_1

	fassert(arg_26_4 or self:can_interact(arg_26_2, arg_26_3), "Attempted to start interaction even though the interaction wasn't allowed.")

	arg_26_3 = InteractionHelper.player_modify_interaction_type(self.unit, arg_26_2, arg_26_3)
	interaction_context.interaction_type = arg_26_3

	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(arg_26_2, "interactable_system")
	local flag = not has_extension and has_extension:local_only()

	interaction_context.local_only = flag

	local interactor_data = interaction_context.data.interactor_data
	local client = InteractionDefinitions[arg_26_3].client

	table.clear(interactor_data)

	if not client.set_interactor_data then
		client.set_interactor_data(unit, arg_26_2, interactor_data)
	end

	self.state = "waiting_for_confirmation"

	InteractionHelper:request(arg_26_3, unit, arg_26_2, self.is_server, flag)
end

GenericUnitInteractorExtension.abort_interaction = function (self)
	-- function 27
	if not (not self:is_interacting() and self.state == "waiting_for_abort") then
		self.state = "waiting_for_abort"

		InteractionHelper.printf("[GenericUnitInteractorExtension] abort_interaction in state=%s", self.state)
		InteractionHelper:abort(self.unit, self.is_server)
	end
end

GenericUnitInteractorExtension.interaction_approved = function (self, arg_28_1, arg_28_2)
	-- function 28
	InteractionHelper.printf("[GenericUnitInteractorExtension] interaction_approved during state %s type=%s on %s", self.state, arg_28_1, tostring(arg_28_2))
	fassert(arg_28_1 == self.interaction_context.interaction_type, "Got wrong type of interaction approved")
	fassert(arg_28_2 == self.interaction_context.interactable_unit, "Got wrong interactable approved")
	Managers.state.unit_spawner:add_destroy_listener(arg_28_2, "interactable_unit", self.interactable_unit_destroy_callback)

	local data = self.interaction_context.data

	data.duration = InteractionDefinitions[arg_28_1].config.duration
	data.start_time = Managers.time:time("game")
	self.state = "starting_interaction"
end

GenericUnitInteractorExtension.interaction_denied = function (self)
	-- function 29
	InteractionHelper.printf("[GenericUnitInteractorExtension] interaction_denied")

	local state = self.state

	fassert(state == "waiting_for_confirmation" or state == "waiting_for_abort", "Was in wrong state when getting interaction denied.")

	self.state = "waiting_to_interact"
end

GenericUnitInteractorExtension.interaction_completed = function (self, arg_30_1)
	-- function 30
	local state = self.state

	InteractionHelper.printf("[GenericUnitInteractorExtension] interaction_completed during state %s with result %s", state, InteractionResult[arg_30_1])
	fassert(state ~= "waiting_to_interact", "Was in wrong state when getting interaction completed.")

	self.interaction_context.result = arg_30_1

	local interactable_unit = self.interaction_context.interactable_unit
	local time = Managers.time:time("game")

	self:_stop_interaction(interactable_unit, time)
end

GenericUnitInteractorExtension.hot_join_sync = function (self, arg_31_1)
	-- function 31
	if not self:is_interacting() then
		return
	end

	local interaction_context = self.interaction_context

	if not interaction_context.local_only then
		return
	end

	local network = Managers.state.network
	local var_31_2 = NetworkLookup.interaction_states[self.state]
	local var_31_3 = NetworkLookup.interactions[interaction_context.interaction_type]
	local game_object_or_level_id, var_31_5 = network:game_object_or_level_id(interaction_context.interactable_unit)
	local data = interaction_context.data
	local start_time = data.start_time
	local duration = data.duration

	duration = duration or 0

	local unit_game_object_id = network:unit_game_object_id(self.unit)
	local var_31_10 = PEER_ID_TO_CHANNEL[arg_31_1]

	RPC.rpc_sync_interaction_state(var_31_10, unit_game_object_id, var_31_2, var_31_3, game_object_or_level_id, start_time, duration, var_31_5)
end

GenericUnitInteractorExtension.allow_movement_during_interaction = function (self)
	-- function 32
	local interactable_unit = self.interaction_context.interactable_unit
	local alive = Unit.alive(interactable_unit)

	if not alive then
		alive = Unit.get_data(interactable_unit, "interaction_data", "allow_movement")
		alive = alive or self:interaction_config().allow_movement
	end

	return alive
end
