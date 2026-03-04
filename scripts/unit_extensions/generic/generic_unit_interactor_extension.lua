-- chunkname: @scripts/unit_extensions/generic/generic_unit_interactor_extension.lua

require("scripts/helpers/interaction_helper")
require("scripts/unit_extensions/generic/interactions")

GenericUnitInteractorExtension = class(GenericUnitInteractorExtension)
INTERACT_RAY_DISTANCE = 2.5

local var_0_0 = {}

GenericUnitInteractorExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world
	local var_1_1 = arg_1_1.dice_keeper
	local var_1_2 = arg_1_1.statistics_db

	arg_1_0.world = var_1_0
	arg_1_0.unit = arg_1_2
	arg_1_0.state = "waiting_to_interact"
	arg_1_0.interaction_context = {
		data = {
			world = var_1_0,
			dice_keeper = var_1_1,
			statistics_db = var_1_2,
			interactor_data = {}
		}
	}

	local var_1_3 = Managers.player:owner(arg_1_2)

	arg_1_0.is_bot = var_1_3 and var_1_3.bot_player
	arg_1_0.physics_world = World.get_data(var_1_0, "physics_world")
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0._interactions_enabled = true
	arg_1_0.exclusive_interaction_unit = nil
	arg_1_0.units_in_range = {}
	arg_1_0.units_in_range_back_buffer = {}

	arg_1_0.interactable_unit_destroy_callback = function (arg_2_0)
		local var_2_0 = Managers.time:time("game")

		arg_1_0:_stop_interaction(arg_2_0, var_2_0)
	end
end

GenericUnitInteractorExtension.extensions_ready = function (arg_3_0)
	arg_3_0.status_extension = ScriptUnit.extension(arg_3_0.unit, "status_system")
	arg_3_0.health_extension = ScriptUnit.extension(arg_3_0.unit, "health_system")
	arg_3_0.buff_extension = ScriptUnit.extension(arg_3_0.unit, "buff_system")
end

GenericUnitInteractorExtension.set_exclusive_interaction_unit = function (arg_4_0, arg_4_1)
	fassert(arg_4_0.is_bot, "Trying to set exclusive interaction unit as player.")

	arg_4_0.exclusive_interaction_unit = arg_4_1
end

GenericUnitInteractorExtension.destroy = function (arg_5_0)
	arg_5_0:abort_interaction()

	local var_5_0 = arg_5_0.interaction_context.interactable_unit

	if Unit.alive(var_5_0) then
		Managers.state.unit_spawner:remove_destroy_listener(var_5_0, "interactable_unit")
	end
end

local var_0_1 = {
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

GenericUnitInteractorExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0.world

	table.clear(var_0_0)

	if arg_6_0.state ~= "waiting_to_interact" and not Unit.alive(arg_6_0.interaction_context.interactable_unit) then
		InteractionHelper.printf("[GenericUnitInteractorExtension] not Unit.alive(self.interaction_context.interactable_unit)")
		arg_6_0:abort_interaction()
	end

	if arg_6_0.state ~= "waiting_to_interact" and (arg_6_0.status_extension:is_disabled() or arg_6_0.status_extension:is_catapulted()) then
		arg_6_0:abort_interaction()
	end

	if arg_6_0.state ~= "waiting_to_interact" then
		local var_6_1, var_6_2 = arg_6_0.health_extension:recent_damages()
		local var_6_3 = false

		for iter_6_0 = 1, var_6_2 / DamageDataIndex.STRIDE do
			local var_6_4 = iter_6_0 - 1
			local var_6_5 = var_6_1[var_6_4 * DamageDataIndex.STRIDE + DamageDataIndex.DAMAGE_AMOUNT]
			local var_6_6 = var_6_1[var_6_4 * DamageDataIndex.STRIDE + DamageDataIndex.DAMAGE_TYPE]

			if var_6_5 > 0 and not var_0_1[var_6_6] then
				var_6_3 = true
			end
		end

		if var_6_3 then
			local var_6_7 = true
			local var_6_8 = arg_6_0.interaction_context.interaction_type
			local var_6_9 = arg_6_0.buff_extension

			if var_6_8 == "heal" then
				var_6_7 = not var_6_9:has_buff_type("no_interruption_bandage")
			end

			if var_6_7 and var_6_8 == "revive" then
				var_6_7 = not var_6_9:has_buff_perk("uninterruptible_revive")
			end

			if var_6_7 then
				arg_6_0:abort_interaction()
			end
		end
	end

	if arg_6_0.state == "waiting_to_interact" and not arg_6_0.status_extension:is_disabled() then
		local var_6_10 = arg_6_0.interaction_context

		if var_6_10.interactable_unit then
			var_6_10.interactable_unit = nil
			var_6_10.interaction_type = nil
		end

		if arg_6_0.is_bot then
			local var_6_11 = arg_6_0.exclusive_interaction_unit

			if var_6_11 then
				local var_6_12 = ScriptUnit.has_extension(var_6_11, "interactable_system")

				if var_6_12 then
					var_6_10.interactable_unit = var_6_11
					var_6_10.interaction_type = var_6_12:interaction_type()

					return
				end
			end
		else
			local var_6_13 = RESOLUTION_LOOKUP.res_w
			local var_6_14 = RESOLUTION_LOOKUP.res_h
			local var_6_15 = var_6_13 * 0.5
			local var_6_16 = var_6_14 * 0.5

			arg_6_0.ray_casted = true

			local var_6_17 = ScriptUnit.extension(arg_6_1, "first_person_system")
			local var_6_18 = var_6_17:current_position()
			local var_6_19 = var_6_17:current_rotation()
			local var_6_20 = Quaternion.forward(var_6_19)
			local var_6_21, var_6_22 = arg_6_0.physics_world:immediate_raycast(var_6_18, var_6_20, INTERACT_RAY_DISTANCE, "all", "collision_filter", "filter_ray_interaction")
			local var_6_23 = false
			local var_6_24 = arg_6_0:_get_player_camera()
			local var_6_25 = math.huge
			local var_6_26
			local var_6_27
			local var_6_28 = arg_6_0.units_in_range_back_buffer

			for iter_6_1 = 1, var_6_22 do
				local var_6_29 = var_6_21[iter_6_1][4]

				if var_6_29 then
					local var_6_30 = Actor.unit(var_6_29)

					if var_6_30 and var_6_30 ~= arg_6_0.unit then
						if ScriptUnit.has_extension(var_6_30, "interactable_system") then
							local var_6_31 = Unit.get_data(var_6_30, "interaction_data", "interact_actor")

							if not var_6_31 or Unit.actor(var_6_30, var_6_31) == var_6_29 then
								local var_6_32 = ScriptUnit.extension(var_6_30, "interactable_system")

								if var_6_32:is_enabled() then
									local var_6_33 = var_6_32:interaction_type()
									local var_6_34, var_6_35, var_6_36 = arg_6_0:can_interact(var_6_30, var_6_33)
									local var_6_37 = arg_6_0:_check_if_interactable_in_chest(var_6_30, var_6_18)

									if (var_6_34 or var_6_35) and not var_6_37 then
										local var_6_38 = InteractionDefinitions[var_6_36]
										local var_6_39 = var_6_38.config or var_6_38.get_config()
										local var_6_40 = var_6_39.does_not_require_line_of_sight
										local var_6_41 = arg_6_0:_claculate_interaction_distance_score(var_6_30, var_6_18, var_6_15, var_6_16, var_6_24)
										local var_6_42 = var_6_39.block_other_interactions

										if var_6_40 or not var_6_23 then
											if var_6_42 then
												var_6_10.interactable_unit = var_6_30
												var_6_10.interaction_type = var_6_36

												return
											elseif var_6_41 < var_6_25 then
												var_6_26 = var_6_30
												var_6_27 = var_6_36
												var_6_25 = var_6_41
											end
										end

										if var_6_34 then
											var_6_28[var_6_30] = var_6_33

											if arg_6_0.units_in_range[var_6_30] == nil then
												arg_6_0:in_range(var_6_30, var_6_33, true)
											end
										end
									end
								end
							else
								var_6_23 = true
							end
						else
							var_6_23 = true
						end
					end
				end
			end

			for iter_6_2, iter_6_3 in pairs(arg_6_0.units_in_range) do
				if var_6_28[iter_6_2] == nil then
					arg_6_0:in_range(iter_6_2, iter_6_3, false)
				end
			end

			arg_6_0.units_in_range, arg_6_0.units_in_range_back_buffer = var_6_28, arg_6_0.units_in_range

			table.clear(arg_6_0.units_in_range_back_buffer)

			if var_6_26 then
				var_6_10.interactable_unit = var_6_26
				var_6_10.interaction_type = var_6_27

				return
			end

			local var_6_43 = POSITION_LOOKUP[arg_6_0.unit]
			local var_6_44, var_6_45 = PhysicsWorld.immediate_overlap(arg_6_0.physics_world, "position", var_6_43, "shape", "sphere", "size", 0.3, "collision_filter", "filter_overlap_interaction")
			local var_6_46
			local var_6_47 = math.huge

			for iter_6_4 = 1, var_6_45 do
				local var_6_48 = var_6_44[iter_6_4]

				if var_6_48 then
					local var_6_49 = Actor.unit(var_6_48)

					if var_6_49 and var_6_49 ~= arg_6_0.unit then
						local var_6_50 = arg_6_0:_check_if_interactable_in_chest(var_6_49, var_6_18)
						local var_6_51 = ScriptUnit.has_extension(var_6_49, "interactable_system")

						if var_6_51 and not var_6_50 and var_6_51:is_enabled() then
							local var_6_52 = POSITION_LOOKUP[var_6_49] or Unit.local_position(var_6_49, 0)
							local var_6_53 = Vector3.distance_squared(var_6_43, var_6_52)

							if var_6_53 < var_6_47 then
								var_6_47 = var_6_53
								var_6_46 = var_6_49
							end
						end
					end
				end
			end

			if var_6_46 then
				local var_6_54 = ScriptUnit.has_extension(var_6_46, "interactable_system")

				if var_6_54 then
					local var_6_55 = var_6_54:interaction_type()
					local var_6_56, var_6_57, var_6_58 = arg_6_0:can_interact(var_6_46, var_6_55)

					if var_6_56 then
						var_6_10.interactable_unit = var_6_46
						var_6_10.interaction_type = var_6_58
					end
				end
			end
		end
	end

	local var_6_59 = arg_6_0.interaction_context
	local var_6_60 = var_6_59.interactable_unit
	local var_6_61 = var_6_59.data

	var_6_61.is_server = arg_6_0.is_server

	local var_6_62 = var_6_59.interaction_type
	local var_6_63 = InteractionDefinitions[var_6_62]
	local var_6_64 = var_6_63 and (var_6_63.config or var_6_63.get_config()) or nil
	local var_6_65 = var_6_59.local_only

	if arg_6_0.state == "starting_interaction" then
		var_6_63.client.start(var_6_0, arg_6_1, var_6_60, var_6_61, var_6_64, arg_6_5)

		if arg_6_0.is_server and not var_6_65 then
			var_6_63.server.start(var_6_0, arg_6_1, var_6_60, var_6_61, var_6_64, arg_6_5)
		end

		arg_6_0.state = "doing_interaction"
	end

	if arg_6_0.state == "doing_interaction" then
		local var_6_66 = var_6_63.client.update(var_6_0, arg_6_1, var_6_60, var_6_61, var_6_64, arg_6_3, arg_6_5)

		var_6_66 = var_6_65 and var_6_66 or nil

		if arg_6_0.is_server and not var_6_65 then
			var_6_66 = var_6_63.server.update(var_6_0, arg_6_1, var_6_60, var_6_61, var_6_64, arg_6_3, arg_6_5)
		end

		var_6_59.result = var_6_66

		if var_6_66 and var_6_66 ~= InteractionResult.ONGOING then
			InteractionHelper:complete_interaction(arg_6_1, var_6_60, var_6_66)
		end
	end
end

GenericUnitInteractorExtension._check_if_interactable_in_chest = function (arg_7_0, arg_7_1, arg_7_2)
	if var_0_0[arg_7_1] then
		return true
	end

	if not ScriptUnit.has_extension(arg_7_1, "pickup_system") then
		return false
	end

	local var_7_0, var_7_1 = Unit.box(arg_7_1)
	local var_7_2 = Matrix4x4.translation(var_7_0)
	local var_7_3, var_7_4 = Vector3.direction_length(var_7_2 - arg_7_2)

	if var_7_4 < math.epsilon then
		return true
	end

	local var_7_5, var_7_6, var_7_7, var_7_8, var_7_9 = PhysicsWorld.immediate_raycast(arg_7_0.physics_world, var_7_2, var_7_3, var_7_4, "closest", "types", "both", "collision_filter", "filter_interactable_in_chest")

	if var_7_5 then
		var_0_0[arg_7_1] = true

		return true
	end

	return false
end

GenericUnitInteractorExtension._claculate_interaction_distance_score = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = Unit.world_position(arg_8_1, 0)
	local var_8_1 = INTERACT_RAY_DISTANCE
	local var_8_2 = Vector3.distance_squared(var_8_0, arg_8_2) / (var_8_1 * var_8_1)
	local var_8_3 = Camera.world_to_screen(arg_8_5, var_8_0)
	local var_8_4 = Vector3(arg_8_3 - var_8_3.x, arg_8_4 - var_8_3.z, 0)

	return var_8_2 * (Vector3.length(var_8_4) / (arg_8_3 * 2))
end

GenericUnitInteractorExtension._get_player_camera = function (arg_9_0)
	local var_9_0 = Managers.player:owner(arg_9_0.unit).viewport_name
	local var_9_1 = ScriptWorld.viewport(arg_9_0.world, var_9_0)

	return (ScriptViewport.camera(var_9_1))
end

GenericUnitInteractorExtension._stop_interaction = function (arg_10_0, arg_10_1, arg_10_2)
	Managers.state.unit_spawner:remove_destroy_listener(arg_10_1, "interactable_unit")

	local var_10_0 = arg_10_0.world
	local var_10_1 = arg_10_0.unit
	local var_10_2 = arg_10_0.interaction_context
	local var_10_3 = var_10_2.data

	var_10_3.is_server = arg_10_0.is_server

	local var_10_4 = var_10_2.interaction_type
	local var_10_5 = InteractionDefinitions[var_10_4]
	local var_10_6 = var_10_5 and (var_10_5.config or var_10_5.get_config()) or nil
	local var_10_7 = var_10_2.local_only

	if not var_10_7 then
		local var_10_8, var_10_9 = Managers.state.network:game_object_or_level_id(arg_10_1)

		if not var_10_9 and var_10_8 == nil then
			InteractionHelper.printf("[GenericUnitInteractorExtension] game object doesnt exist, changing result from %s to %s", InteractionResult[var_10_2.result], InteractionResult[InteractionResult.FAILURE])

			var_10_2.result = InteractionResult.FAILURE
		end
	end

	local var_10_10 = var_10_2.result

	if var_10_10 == InteractionResult.ONGOING or var_10_10 == nil then
		var_10_10 = InteractionResult.FAILURE
		var_10_2.result = var_10_10
	end

	InteractionHelper.printf("[GenericUnitInteractorExtension] Stopping interaction %s with result %s", var_10_4, InteractionResult[var_10_10])
	var_10_5.client.stop(var_10_0, var_10_1, arg_10_1, var_10_3, var_10_6, arg_10_2, var_10_10)

	if arg_10_0.is_server and not var_10_7 then
		var_10_5.server.stop(var_10_0, var_10_1, arg_10_1, var_10_3, var_10_6, arg_10_2, var_10_10)
	end

	arg_10_0.state = "waiting_to_interact"
end

GenericUnitInteractorExtension.is_interacting = function (arg_11_0)
	local var_11_0 = arg_11_0.interaction_context.interaction_type

	return arg_11_0.state ~= "waiting_to_interact", var_11_0
end

GenericUnitInteractorExtension.is_stopping = function (arg_12_0)
	return arg_12_0.state == "stopping_interaction"
end

GenericUnitInteractorExtension.is_waiting_for_interaction_approval = function (arg_13_0)
	return arg_13_0.state == "waiting_for_confirmation"
end

GenericUnitInteractorExtension.is_aborting_interaction = function (arg_14_0)
	return arg_14_0.state == "waiting_for_abort"
end

GenericUnitInteractorExtension.is_looking_at_interactable = function (arg_15_0)
	return arg_15_0.interaction_context.interactable_unit ~= nil
end

GenericUnitInteractorExtension.in_range = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0.interaction_context
	local var_16_1 = arg_16_1 or var_16_0.interactable_unit

	arg_16_2 = arg_16_2 or var_16_0.interaction_type

	local var_16_2 = var_16_0.data
	local var_16_3 = InteractionDefinitions[arg_16_2]
	local var_16_4 = var_16_3.client.in_range

	if var_16_4 then
		var_16_4(arg_16_0.unit, var_16_1, var_16_2, var_16_3.config, arg_16_0.world, arg_16_3)
	end
end

GenericUnitInteractorExtension.enable_interactions = function (arg_17_0, arg_17_1)
	arg_17_0._interactions_enabled = arg_17_1
end

GenericUnitInteractorExtension.can_interact = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.interaction_context
	local var_18_1 = arg_18_1 or var_18_0.interactable_unit

	if arg_18_0.buff_extension:has_buff_perk("disable_interactions") then
		return false
	end

	if arg_18_0.state ~= "waiting_to_interact" then
		return false
	end

	if var_18_1 == nil then
		return false
	end

	if not Unit.alive(var_18_1) then
		return false
	end

	if arg_18_0.status_extension:is_disabled() then
		return false
	end

	if not arg_18_0._interactions_enabled then
		return false
	end

	arg_18_2 = arg_18_2 or var_18_0.interaction_type

	local var_18_2 = Managers.state.game_mode:game_mode()

	if var_18_2.allowed_interactions and not var_18_2:allowed_interactions(arg_18_0.unit, arg_18_2) then
		return false
	end

	local var_18_3 = var_18_0.data
	local var_18_4 = InteractionDefinitions[arg_18_2]

	if not var_18_4 then
		return false
	end

	local var_18_5 = var_18_4.client.can_interact

	if var_18_5 then
		local var_18_6, var_18_7, var_18_8 = var_18_5(arg_18_0.unit, var_18_1, var_18_3, var_18_4.config, arg_18_0.world)

		var_18_8 = var_18_8 or arg_18_2

		return var_18_6, var_18_7, var_18_8, var_18_1
	end

	return true, nil, arg_18_2, var_18_1
end

GenericUnitInteractorExtension.interaction_config = function (arg_19_0)
	local var_19_0 = arg_19_0.interaction_context.interaction_type
	local var_19_1 = InteractionDefinitions[var_19_0]

	return var_19_1 and (var_19_1.config or var_19_1.get_config()) or nil
end

GenericUnitInteractorExtension.interaction_description = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.interaction_context
	local var_20_1 = var_20_0.interactable_unit
	local var_20_2 = var_20_0.data
	local var_20_3 = var_20_0.interaction_type
	local var_20_4 = InteractionDefinitions[var_20_3]
	local var_20_5 = var_20_4.config

	return var_20_4.client.hud_description(var_20_1, var_20_2, var_20_5, arg_20_1, arg_20_0.unit)
end

GenericUnitInteractorExtension.interaction_hold_input = function (arg_21_0)
	return arg_21_0.interaction_context.hold_input
end

GenericUnitInteractorExtension.is_interacting_with_local_only_interact = function (arg_22_0)
	return arg_22_0.interaction_context.local_only
end

GenericUnitInteractorExtension.interaction_camera_node = function (arg_23_0)
	local var_23_0 = arg_23_0.interaction_context.interaction_type

	return InteractionDefinitions[var_23_0].client.camera_node(arg_23_0.unit, arg_23_0.interaction_context.interactable_unit)
end

GenericUnitInteractorExtension.interactable_unit = function (arg_24_0)
	return arg_24_0.interaction_context.interactable_unit
end

GenericUnitInteractorExtension.get_progress = function (arg_25_0, arg_25_1)
	fassert(arg_25_0:is_interacting(), "Attempted to get interaction progress when interactor unit wasn't interacting.")

	local var_25_0 = arg_25_0.interaction_context
	local var_25_1 = var_25_0.data
	local var_25_2 = var_25_0.interaction_type
	local var_25_3 = InteractionDefinitions[var_25_2]
	local var_25_4 = var_25_3 and var_25_3.config or nil

	return var_25_3.client.get_progress(var_25_1, var_25_4, arg_25_1)
end

GenericUnitInteractorExtension.start_interaction = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = arg_26_0.interaction_context

	arg_26_2 = arg_26_2 or var_26_0.interactable_unit
	arg_26_3 = arg_26_3 or var_26_0.interaction_type

	InteractionHelper.printf("[GenericUnitInteractorExtension] start_interaction(interactable_unit=%s, interaction_type=%s)", arg_26_2, arg_26_3)

	var_26_0.interactable_unit = arg_26_2
	var_26_0.interaction_type = arg_26_3
	var_26_0.hold_input = arg_26_1

	fassert(arg_26_4 or arg_26_0:can_interact(arg_26_2, arg_26_3), "Attempted to start interaction even though the interaction wasn't allowed.")

	arg_26_3 = InteractionHelper.player_modify_interaction_type(arg_26_0.unit, arg_26_2, arg_26_3)
	var_26_0.interaction_type = arg_26_3

	local var_26_1 = arg_26_0.unit
	local var_26_2 = ScriptUnit.has_extension(arg_26_2, "interactable_system")
	local var_26_3 = var_26_2 and var_26_2:local_only()

	var_26_0.local_only = var_26_3

	local var_26_4 = var_26_0.data.interactor_data
	local var_26_5 = InteractionDefinitions[arg_26_3].client

	table.clear(var_26_4)

	if var_26_5.set_interactor_data then
		var_26_5.set_interactor_data(var_26_1, arg_26_2, var_26_4)
	end

	arg_26_0.state = "waiting_for_confirmation"

	InteractionHelper:request(arg_26_3, var_26_1, arg_26_2, arg_26_0.is_server, var_26_3)
end

GenericUnitInteractorExtension.abort_interaction = function (arg_27_0)
	if arg_27_0:is_interacting() and arg_27_0.state ~= "waiting_for_abort" then
		arg_27_0.state = "waiting_for_abort"

		InteractionHelper.printf("[GenericUnitInteractorExtension] abort_interaction in state=%s", arg_27_0.state)
		InteractionHelper:abort(arg_27_0.unit, arg_27_0.is_server)
	end
end

GenericUnitInteractorExtension.interaction_approved = function (arg_28_0, arg_28_1, arg_28_2)
	InteractionHelper.printf("[GenericUnitInteractorExtension] interaction_approved during state %s type=%s on %s", arg_28_0.state, arg_28_1, tostring(arg_28_2))
	fassert(arg_28_1 == arg_28_0.interaction_context.interaction_type, "Got wrong type of interaction approved")
	fassert(arg_28_2 == arg_28_0.interaction_context.interactable_unit, "Got wrong interactable approved")
	Managers.state.unit_spawner:add_destroy_listener(arg_28_2, "interactable_unit", arg_28_0.interactable_unit_destroy_callback)

	local var_28_0 = arg_28_0.interaction_context.data

	var_28_0.duration = InteractionDefinitions[arg_28_1].config.duration
	var_28_0.start_time = Managers.time:time("game")
	arg_28_0.state = "starting_interaction"
end

GenericUnitInteractorExtension.interaction_denied = function (arg_29_0)
	InteractionHelper.printf("[GenericUnitInteractorExtension] interaction_denied")

	local var_29_0 = arg_29_0.state

	fassert(var_29_0 == "waiting_for_confirmation" or var_29_0 == "waiting_for_abort", "Was in wrong state when getting interaction denied.")

	arg_29_0.state = "waiting_to_interact"
end

GenericUnitInteractorExtension.interaction_completed = function (arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.state

	InteractionHelper.printf("[GenericUnitInteractorExtension] interaction_completed during state %s with result %s", var_30_0, InteractionResult[arg_30_1])
	fassert(var_30_0 ~= "waiting_to_interact", "Was in wrong state when getting interaction completed.")

	arg_30_0.interaction_context.result = arg_30_1

	local var_30_1 = arg_30_0.interaction_context.interactable_unit
	local var_30_2 = Managers.time:time("game")

	arg_30_0:_stop_interaction(var_30_1, var_30_2)
end

GenericUnitInteractorExtension.hot_join_sync = function (arg_31_0, arg_31_1)
	if not arg_31_0:is_interacting() then
		return
	end

	local var_31_0 = arg_31_0.interaction_context

	if var_31_0.local_only then
		return
	end

	local var_31_1 = Managers.state.network
	local var_31_2 = NetworkLookup.interaction_states[arg_31_0.state]
	local var_31_3 = NetworkLookup.interactions[var_31_0.interaction_type]
	local var_31_4, var_31_5 = var_31_1:game_object_or_level_id(var_31_0.interactable_unit)
	local var_31_6 = var_31_0.data
	local var_31_7 = var_31_6.start_time
	local var_31_8 = var_31_6.duration or 0
	local var_31_9 = var_31_1:unit_game_object_id(arg_31_0.unit)
	local var_31_10 = PEER_ID_TO_CHANNEL[arg_31_1]

	RPC.rpc_sync_interaction_state(var_31_10, var_31_9, var_31_2, var_31_3, var_31_4, var_31_7, var_31_8, var_31_5)
end

GenericUnitInteractorExtension.allow_movement_during_interaction = function (arg_32_0)
	local var_32_0 = arg_32_0.interaction_context.interactable_unit

	return Unit.alive(var_32_0) and (Unit.get_data(var_32_0, "interaction_data", "allow_movement") or arg_32_0:interaction_config().allow_movement)
end
