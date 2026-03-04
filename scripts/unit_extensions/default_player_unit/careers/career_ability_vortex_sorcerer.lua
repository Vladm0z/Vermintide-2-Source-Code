-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_vortex_sorcerer.lua

CareerAbilityVortexSorcerer = class(CareerAbilityVortexSorcerer)

local var_0_0 = require("scripts/entity_system/systems/ai/ai_slot_utils")

function CareerAbilityVortexSorcerer._ballistic_raycast(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	local var_1_0 = arg_1_3 / arg_1_2
	local var_1_1 = 0.85
	local var_1_2 = 10

	for iter_1_0 = 1, arg_1_2 do
		local var_1_3 = arg_1_4 + arg_1_5 * var_1_0
		local var_1_4 = PhysicsWorld.linear_sphere_sweep(arg_1_1, arg_1_4, var_1_3, var_1_1, var_1_2, "collision_filter", arg_1_7, "report_initial_overlap")

		if var_1_4 then
			local var_1_5 = #var_1_4

			for iter_1_1 = 1, var_1_5 do
				local var_1_6 = var_1_4[iter_1_1]
				local var_1_7 = var_1_6.actor
				local var_1_8 = var_1_6.position
				local var_1_9 = var_1_6.normal
				local var_1_10 = var_1_6.distance

				if Actor.unit(var_1_7) ~= arg_1_0.owner_unit then
					return true, var_1_8, var_1_10, var_1_9, var_1_7
				end
			end
		end

		arg_1_5 = arg_1_5 + arg_1_6 * var_1_0
		arg_1_4 = var_1_3
	end

	return false, arg_1_4
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2)
	return Vector3.distance(arg_2_1, arg_2_0) / arg_2_2
end

function CareerAbilityVortexSorcerer.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.owner_unit = arg_3_2
	arg_3_0.world = arg_3_1.world
	arg_3_0.wwise_world = Managers.world:wwise_world(arg_3_0.world)

	local var_3_0 = arg_3_3.player

	arg_3_0.player = var_3_0
	arg_3_0.is_server = var_3_0.is_server
	arg_3_0.local_player = var_3_0.local_player
	arg_3_0.bot_player = var_3_0.bot_player
	arg_3_0.network_manager = Managers.state.network
	arg_3_0.input_manager = Managers.input
	arg_3_0.effect_id = nil
	arg_3_0.effect_name = "fx/wpnfx_staff_geiser_charge"
	arg_3_0.effect_id_teleport_exit = nil
end

function CareerAbilityVortexSorcerer.extensions_ready(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.first_person_extension = ScriptUnit.has_extension(arg_4_2, "first_person_system")
	arg_4_0.status_extension = ScriptUnit.extension(arg_4_2, "status_system")
	arg_4_0.career_extension = ScriptUnit.extension(arg_4_2, "career_system")
	arg_4_0.ghost_mode_extension = ScriptUnit.extension(arg_4_2, "ghost_mode_system")
	arg_4_0.buff_extension = ScriptUnit.extension(arg_4_2, "buff_system")
	arg_4_0.locomotion_extension = ScriptUnit.extension(arg_4_2, "locomotion_system")
	arg_4_0._input_extension = ScriptUnit.has_extension(arg_4_2, "input_system")
	arg_4_0._ability_input = arg_4_0.career_extension:get_activated_ability_data(1).input_action

	if arg_4_0.first_person_extension then
		arg_4_0.first_person_unit = arg_4_0.first_person_extension:get_first_person_unit()
	end
end

function CareerAbilityVortexSorcerer.destroy(arg_5_0)
	return
end

function CareerAbilityVortexSorcerer.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if not arg_6_0:_ability_available() then
		return
	end

	local var_6_0 = arg_6_0._input_extension

	if not var_6_0 then
		return
	end

	if not arg_6_0.is_priming then
		if var_6_0:get(arg_6_0._ability_input) then
			arg_6_0:_start_priming()
		end
	elseif arg_6_0.is_priming then
		arg_6_0:_update_priming(arg_6_3, arg_6_5)

		if var_6_0:get("reload") or var_6_0:get("action_two") then
			arg_6_0:_stop_priming()
		end

		if not var_6_0:get("action_one_hold") then
			local var_6_1 = arg_6_0.status_extension

			var_6_1._last_valid_position = arg_6_0._last_valid_position
			var_6_1.do_sorcerer_vortex = true

			if arg_6_0.effect_id then
				World.destroy_particles(arg_6_0.world, arg_6_0.effect_id)

				arg_6_0.effect_id = nil
			end

			arg_6_0.career_extension:start_activated_ability_cooldown()

			arg_6_0.is_priming = false

			return
		end
	end
end

function CareerAbilityVortexSorcerer.stop(arg_7_0, arg_7_1)
	if arg_7_0._is_priming then
		arg_7_0:_stop_priming()
	end
end

function CareerAbilityVortexSorcerer._ability_available(arg_8_0)
	local var_8_0 = arg_8_0.career_extension
	local var_8_1 = arg_8_0.status_extension
	local var_8_2 = arg_8_0.locomotion_extension
	local var_8_3 = arg_8_0.ghost_mode_extension:is_in_ghost_mode()

	return var_8_0:can_use_activated_ability() and not var_8_1:is_disabled() and var_8_2:is_on_ground() and not var_8_3
end

function CareerAbilityVortexSorcerer._start_priming(arg_9_0)
	if arg_9_0.local_player then
		local var_9_0 = arg_9_0.world
		local var_9_1 = arg_9_0.effect_name

		arg_9_0.effect_id = World.create_particles(var_9_0, var_9_1, Vector3.zero())
	end

	arg_9_0._last_valid_position = nil
	arg_9_0.is_priming = true
end

function CareerAbilityVortexSorcerer._landing_postion_valid(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = false
	local var_10_1 = arg_10_3.astar

	if var_10_1 then
		if GwNavAStar.processing_finished(var_10_1) then
			var_10_0 = GwNavAStar.path_found(var_10_1) and true or var_10_0

			GwNavAStar.destroy(var_10_1)

			arg_10_3.astar = nil
			arg_10_3.astar_timer = arg_10_4 + 0.01
		end
	elseif arg_10_4 > arg_10_3.astar_timer then
		local var_10_2 = Managers.state.entity:system("ai_system"):nav_world()
		local var_10_3 = GwNavAStar.create(var_10_2)
		local var_10_4 = arg_10_3.box_half_width
		local var_10_5 = Managers.state.bot_nav_transition:traverse_logic()

		GwNavAStar.start_with_propagation_box(var_10_3, var_10_2, arg_10_1, arg_10_2, var_10_4, var_10_5)

		arg_10_3.astar = var_10_3
		arg_10_3.astar_timer = arg_10_4 + 0.01
	end

	return var_10_0
end

function CareerAbilityVortexSorcerer._update_priming(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.effect_id
	local var_11_1 = arg_11_0.owner_unit
	local var_11_2 = arg_11_0.world
	local var_11_3 = Managers.state.network:game()
	local var_11_4 = Managers.state.network
	local var_11_5 = World.get_data(var_11_2, "physics_world")
	local var_11_6 = var_11_4:unit_game_object_id(var_11_1)
	local var_11_7 = Vector3(0, 0, 1)
	local var_11_8 = arg_11_0.first_person_extension
	local var_11_9 = var_11_8:current_position()
	local var_11_10 = var_11_8:current_rotation()
	local var_11_11 = 10
	local var_11_12 = 0.9
	local var_11_13 = 25
	local var_11_14 = 0
	local var_11_15 = Quaternion.forward(Quaternion.multiply(var_11_10, Quaternion(Vector3.right(), var_11_14))) * var_11_13
	local var_11_16 = Vector3(0, 0, -2)
	local var_11_17 = "filter_adept_teleport"
	local var_11_18, var_11_19, var_11_20, var_11_21 = arg_11_0:_ballistic_raycast(var_11_5, var_11_11, var_11_12, var_11_9, var_11_15, var_11_16, var_11_17, false)

	if var_11_18 and Vector3.dot(var_11_21, Vector3.up()) < 0.75 then
		local var_11_22 = var_11_19 - Vector3.normalize(var_11_19 - var_11_9) * 1.5
		local var_11_23, var_11_24, var_11_25, var_11_26 = PhysicsWorld.immediate_raycast(var_11_5, var_11_22, Vector3.down(), 10, "closest", "collision_filter", var_11_17)

		if var_11_23 then
			var_11_19 = var_11_24
		end
	end

	local var_11_27 = Managers.state.entity:system("ai_system"):nav_world()

	var_11_19 = var_0_0.get_target_pos_on_navmesh(var_11_19, var_11_27) or var_11_19

	local var_11_28 = arg_11_0._astar_data

	if not var_11_28 then
		var_11_28 = {
			astar_timer = 0,
			box_half_width = 20
		}
		arg_11_0._astar_data = var_11_28
	end

	if arg_11_0:_landing_postion_valid(var_11_9, var_11_19, var_11_28, arg_11_2) then
		if var_11_0 then
			World.move_particles(var_11_2, var_11_0, var_11_19)
		end

		if arg_11_0._last_valid_position then
			arg_11_0._last_valid_position:store(var_11_19)
		else
			arg_11_0._last_valid_position = Vector3Box(var_11_19)
		end
	end
end

function CareerAbilityVortexSorcerer._stop_priming(arg_12_0)
	if arg_12_0.effect_id then
		World.destroy_particles(arg_12_0.world, arg_12_0.effect_id)

		arg_12_0.effect_id = nil
	end

	if arg_12_0._astar_data then
		local var_12_0 = arg_12_0._astar_data.astar

		if var_12_0 then
			GwNavAStar.destroy(var_12_0)
		end

		arg_12_0._astar_data = nil
	end

	arg_12_0.is_priming = false
end
