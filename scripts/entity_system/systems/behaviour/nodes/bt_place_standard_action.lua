-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_place_standard_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPlaceStandardAction = class(BTPlaceStandardAction, BTNode)

function BTPlaceStandardAction.init(arg_1_0, ...)
	BTPlaceStandardAction.super.init(arg_1_0, ...)
end

BTPlaceStandardAction.name = "BTPlaceStandardAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTPlaceStandardAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_2.action = arg_3_0._tree_node.action_data
	arg_3_2.active_node = BTPlaceStandardAction

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

	arg_3_2.attacking_target = arg_3_2.target_unit
	arg_3_2.anim_cb_placed_standard = nil
	arg_3_2.anim_cb_place_standard = nil
	arg_3_2.attack_aborted = nil
end

function BTPlaceStandardAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local var_4_1 = arg_4_2.navigation_extension

	var_4_1:set_enabled(true)
	var_4_1:set_max_speed(var_4_0)

	arg_4_2.active_node = nil
	arg_4_2.action = nil
	arg_4_2.attacking_target = nil
	arg_4_2.attack_aborted = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	if arg_4_2.anim_cb_place_standard then
		arg_4_2.has_placed_standard = true
		arg_4_2.switching_weapons = 2
	end

	if arg_4_2.move_state ~= "idle" and HEALTH_ALIVE[arg_4_1] then
		arg_4_2.move_state = "idle"
	end

	arg_4_2.anim_cb_placed_standard = nil
	arg_4_2.anim_cb_place_standard = nil
end

function BTPlaceStandardAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_2.anim_cb_placed_standard or arg_5_2.attack_aborted then
		return "done"
	end

	if arg_5_2.move_state ~= "attacking" then
		Managers.state.network:anim_event(arg_5_1, var_0_0(arg_5_2.action.place_standard_animation))

		arg_5_2.move_state = "attacking"
	end

	return "running"
end

function BTPlaceStandardAction.anim_cb_place_standard(arg_6_0, arg_6_1, arg_6_2)
	if Managers.state.network:game() then
		local var_6_0 = POSITION_LOOKUP[arg_6_1]
		local var_6_1 = var_6_0 + Quaternion.forward(Unit.local_rotation(arg_6_1, 0))
		local var_6_2
		local var_6_3 = arg_6_2.nav_world
		local var_6_4 = 1
		local var_6_5 = 1
		local var_6_6, var_6_7 = GwNavQueries.triangle_from_position(var_6_3, var_6_1, var_6_4, var_6_5)

		if var_6_6 then
			var_6_2 = Vector3.copy(var_6_1)
			var_6_2.z = var_6_7
		else
			local var_6_8 = 1
			local var_6_9 = 0.05

			var_6_2 = GwNavQueries.inside_position_from_outside_position(var_6_3, var_6_1, var_6_4, var_6_5, var_6_8, var_6_9)
		end

		if var_6_2 then
			local var_6_10 = arg_6_2.action
			local var_6_11 = {
				health_system = {
					health = var_6_10.standard_health
				},
				death_system = {
					death_reaction_template = "standard"
				},
				ai_supplementary_system = {
					standard_template_name = var_6_10.standard_template_name,
					standard_bearer_unit = arg_6_1
				},
				ping_system = {
					always_pingable = true
				}
			}
			local var_6_12 = "units/weapons/enemy/wpn_bm_standard_01/wpn_bm_standard_01_placed"
			local var_6_13 = Managers.state.unit_spawner:spawn_network_unit(var_6_12, "standard_unit", var_6_11, var_6_2)

			arg_6_2.standard_unit = var_6_13

			local var_6_14 = arg_6_2.world
			local var_6_15 = Unit.local_position(var_6_13, 0)
			local var_6_16 = ExplosionUtils.get_template("standard_bearer_explosion")
			local var_6_17 = arg_6_2.breed.name
			local var_6_18 = arg_6_2.group_blackboard.broadphase
			local var_6_19 = var_6_16.explosion.radius
			local var_6_20 = FrameTable.alloc_table()
			local var_6_21 = FrameTable.alloc_table()
			local var_6_22 = Broadphase.query(var_6_18, var_6_0, var_6_19, var_6_20)

			for iter_6_0 = 1, var_6_22 do
				local var_6_23 = var_6_20[iter_6_0]

				if HEALTH_ALIVE[var_6_23] then
					local var_6_24 = BLACKBOARDS[var_6_23]

					if var_6_24.breed.race == "beastmen" then
						var_6_24.standard_bearer_stagger = true
						var_6_21[#var_6_21 + 1] = var_6_24
					end
				end
			end

			DamageUtils.create_explosion(var_6_14, arg_6_2.target_unit, var_6_15, Quaternion.identity(), var_6_16, 1, var_6_17, true, false, arg_6_1, false, nil, arg_6_1)

			for iter_6_1 = 1, #var_6_21 do
				local var_6_25 = var_6_21[iter_6_1]
			end

			local var_6_26 = Managers.state.unit_storage:go_id(arg_6_1)
			local var_6_27 = NetworkLookup.explosion_templates[var_6_16.name]
			local var_6_28 = NetworkLookup.damage_sources[var_6_17]

			Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_6_26, false, var_6_15, Quaternion.identity(), var_6_27, 1, var_6_28, 0, false, var_6_26)
		end

		arg_6_2.anim_cb_place_standard = true

		if arg_6_2.triggered_standard_chanting_sound then
			Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_6_2.action.stop_chanting_sound_event, arg_6_1)

			arg_6_2.triggered_standard_chanting_sound = nil
		end

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "has_planted_standard", DialogueSettings.special_proximity_distance_heard)
	end
end

function BTPlaceStandardAction.anim_cb_placed_standard(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2.anim_cb_placed_standard = true
end
