-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_vomit_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVomitAction = class(BTVomitAction, BTNode)

function BTVomitAction.init(arg_1_0, ...)
	BTVomitAction.super.init(arg_1_0, ...)
end

BTVomitAction.name = "BTVomitAction"

local function var_0_0(...)
	if script_data.debug_chaos_troll then
		print(...)
	end
end

function BTVomitAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data
	local var_3_1 = arg_3_2.world

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTVomitAction
	arg_3_2.physics_world = arg_3_2.physics_world or World.get_data(var_3_1, "physics_world")
	arg_3_2.rotation_time = arg_3_3 + var_3_0.rotation_time
	arg_3_2.check_puke_time = nil

	if arg_3_0:init_attack(arg_3_1, arg_3_2, var_3_0, arg_3_3) then
		arg_3_2.anim_locked = arg_3_3 + var_3_0.attack_time
		arg_3_2.move_state = "attacking"
		arg_3_2.attack_aborted = false
		arg_3_2.keep_target = true

		Managers.state.conflict:freeze_intensity_decay(15)
	else
		arg_3_2.attack_aborted = true
	end

	arg_3_2.update_puke_pos_at_t = arg_3_3 + 0.2

	local var_3_2 = arg_3_2.target_unit

	AiUtils.add_attack_intensity(var_3_2, var_3_0, arg_3_2)
end

function BTVomitAction._position_on_navmesh(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2.nav_world
	local var_4_1, var_4_2 = GwNavQueries.triangle_from_position(var_4_0, arg_4_1, 1, 1)

	if var_4_1 then
		arg_4_1 = Vector3.copy(arg_4_1)
		arg_4_1.z = var_4_2
	else
		arg_4_1 = GwNavQueries.inside_position_from_outside_position(var_4_0, arg_4_1, 3, 3, 1, 1)
	end

	return arg_4_1
end

function BTVomitAction._get_vomit_position(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Unit.node(arg_5_1, "j_head")
	local var_5_1 = Unit.world_position(arg_5_1, var_5_0)
	local var_5_2 = POSITION_LOOKUP[arg_5_2.target_unit]
	local var_5_3 = var_5_2 - var_5_1
	local var_5_4 = Vector3.normalize(var_5_3)
	local var_5_5 = Vector3.length(var_5_3)
	local var_5_6 = arg_5_2.physics_world
	local var_5_7
	local var_5_8
	local var_5_9
	local var_5_10, var_5_11, var_5_12, var_5_13, var_5_14 = PhysicsWorld.immediate_raycast(var_5_6, var_5_1, var_5_4, var_5_5, "closest", "collision_filter", "filter_enemy_ray_projectile")

	if var_5_10 then
		var_5_7 = var_5_11
	else
		var_5_7 = var_5_2
	end

	local var_5_15 = arg_5_0:_position_on_navmesh(var_5_7, arg_5_2)

	if var_5_15 then
		local var_5_16 = var_5_15 - var_5_1

		var_5_8 = Vector3.length_squared(var_5_16)
		var_5_9 = Vector3.normalize(var_5_16)
	end

	return var_5_15, var_5_8, var_5_9
end

function BTVomitAction.init_attack(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0, var_6_1, var_6_2 = arg_6_0:_get_vomit_position(arg_6_1, arg_6_2)

	if not var_6_0 then
		return false
	end

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "enemy_attack", DialogueSettings.pounced_down_broadcast_range, "attack_tag", "before_puke")

	local var_6_3
	local var_6_4 = arg_6_3.attack_anims

	arg_6_2.navigation_extension:stop()

	if Vector3.dot(var_6_2, Vector3.down()) >= 0.35 and var_6_1 < arg_6_3.near_vomit_distance and not arg_6_2.needs_to_crouch then
		var_6_3 = var_6_4.near_vomit
		arg_6_2.near_vomit = true
	else
		var_6_3 = var_6_4.ranged_vomit
	end

	Managers.state.network:anim_event(arg_6_1, var_6_3)

	arg_6_2.attack_started_at_t = arg_6_4
	arg_6_2.puke_position = Vector3Box(var_6_0)
	arg_6_2.puke_direction = Vector3Box(var_6_2)

	local var_6_5 = arg_6_3.bot_threats and (arg_6_3.bot_threats[var_6_3] or arg_6_3.bot_threats[1] and arg_6_3.bot_threats)

	if var_6_5 then
		local var_6_6 = 1
		local var_6_7 = var_6_5[var_6_6]
		local var_6_8, var_6_9 = AiUtils.calculate_bot_threat_time(var_6_7)

		arg_6_2.create_bot_threat_at_t = arg_6_4 + var_6_8
		arg_6_2.current_bot_threat_index = var_6_6
		arg_6_2.bot_threat_duration = var_6_9
		arg_6_2.bot_threats_data = var_6_5
	end

	local var_6_10 = LocomotionUtils.look_at_position_flat(arg_6_1, var_6_0)

	arg_6_2.attack_rotation = QuaternionBox(var_6_10)

	arg_6_2.locomotion_extension:set_wanted_rotation(var_6_10)

	return true
end

function BTVomitAction.leave(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_2.action = nil
	arg_7_2.active_node = nil
	arg_7_2.attack_rotation = nil
	arg_7_2.attack_started_at_t = nil
	arg_7_2.keep_target = nil
	arg_7_2.puke_position = nil
	arg_7_2.puke_direction = nil
	arg_7_2.is_puking = nil
	arg_7_2.create_bot_threat_at_t = nil
	arg_7_2.current_bot_threat_index = nil
	arg_7_2.bot_threat_duration = nil
	arg_7_2.bot_threats_data = nil
	arg_7_2.attack_finished = nil
	arg_7_2.near_vomit = nil
	arg_7_2.update_puke_pos_at_t = nil
	arg_7_2.check_puke_time = nil
	arg_7_2.anim_locked = nil
end

function BTVomitAction._calculate_oobb_collision(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_1.width
	local var_8_1 = arg_8_1.range
	local var_8_2 = arg_8_1.height
	local var_8_3 = arg_8_1.offset_forward
	local var_8_4 = arg_8_1.offset_up
	local var_8_5 = var_8_0 * 0.5
	local var_8_6 = var_8_1 * 0.5
	local var_8_7 = var_8_2 * 0.5
	local var_8_8 = Vector3(var_8_5, var_8_6, var_8_7)
	local var_8_9 = Quaternion.rotate(arg_8_3, Vector3.forward()) * (var_8_3 + var_8_6)
	local var_8_10 = Vector3.up() * (var_8_4 + var_8_7)

	return arg_8_2 + var_8_9 + var_8_10, arg_8_3, var_8_8
end

function BTVomitAction.run(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if arg_9_2.attack_aborted then
		return "failed"
	end

	if arg_9_3 < arg_9_2.anim_locked then
		local var_9_0 = arg_9_2.target_unit
		local var_9_1 = ScriptUnit.has_extension(var_9_0, "status_system")

		if arg_9_2.is_puking then
			if not arg_9_2.check_puke_time then
				arg_9_2.check_puke_time = arg_9_3 + 0.2
			end

			if arg_9_3 > arg_9_2.check_puke_time then
				arg_9_0.player_vomit_hit_check(arg_9_1, arg_9_2.puke_position:unbox(), arg_9_2.physics_world, arg_9_2)
			end
		elseif arg_9_3 < arg_9_2.rotation_time and (not var_9_1 or not var_9_1:get_is_dodging() and not var_9_1:is_invisible()) and arg_9_3 > arg_9_2.update_puke_pos_at_t then
			local var_9_2, var_9_3, var_9_4 = arg_9_0:_get_vomit_position(arg_9_1, arg_9_2)

			if var_9_2 and var_9_4 then
				arg_9_2.puke_position:store(var_9_2)
				arg_9_2.puke_direction:store(var_9_4)
			end

			arg_9_2.update_puke_pos_at_t = arg_9_3 + 0.2
		end

		if arg_9_2.puke_direction then
			local var_9_5 = arg_9_2.puke_direction
			local var_9_6 = Vector3(var_9_5.x, var_9_5.y, 0)
			local var_9_7 = Quaternion.look(var_9_6)

			arg_9_2.locomotion_extension:set_wanted_rotation(var_9_7)
		end

		local var_9_8 = arg_9_2.create_bot_threat_at_t

		if var_9_8 and var_9_8 < arg_9_3 then
			local var_9_9 = arg_9_2.action
			local var_9_10 = arg_9_2.bot_threats_data
			local var_9_11 = arg_9_2.current_bot_threat_index
			local var_9_12 = var_9_10[var_9_11]
			local var_9_13 = arg_9_2.bot_threat_duration
			local var_9_14 = POSITION_LOOKUP[arg_9_1]
			local var_9_15 = arg_9_2.attack_rotation:unbox()
			local var_9_16, var_9_17, var_9_18 = arg_9_0:_calculate_oobb_collision(var_9_12, var_9_14, var_9_15)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_9_16, "oobb", var_9_18, var_9_17, var_9_13, "Vomit")

			local var_9_19 = var_9_11 + 1
			local var_9_20 = var_9_10[var_9_19]

			if var_9_20 then
				local var_9_21 = arg_9_2.attack_started_at_t
				local var_9_22, var_9_23 = AiUtils.calculate_bot_threat_time(var_9_20)

				arg_9_2.create_bot_threat_at_t = var_9_21 + var_9_22
				arg_9_2.bot_threat_duration = var_9_23
				arg_9_2.current_bot_threat_index = var_9_19
			else
				arg_9_2.create_bot_threat_at_t = nil
				arg_9_2.bot_threat_duration = nil
				arg_9_2.current_bot_threat_index = nil
			end
		end

		return "running"
	end

	return "done"
end

function BTVomitAction.player_vomit_hit_check(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = Unit.node(arg_10_0, "j_head")
	local var_10_1 = Unit.world_position(arg_10_0, var_10_0)
	local var_10_2 = arg_10_1 + (2 * Vector3.normalize(arg_10_1 - POSITION_LOOKUP[arg_10_0]) + Vector3(0, 0, 1)) - var_10_1
	local var_10_3 = Vector3.normalize(var_10_2)
	local var_10_4 = Vector3.length(var_10_2)
	local var_10_5 = PhysicsWorld.linear_sphere_sweep(arg_10_2, var_10_1, arg_10_1, 0.5, 10, "collision_filter", "filter_enemy_ray_projectile", "report_initial_overlap")

	if var_10_5 then
		local var_10_6 = #var_10_5
		local var_10_7 = Managers.state.entity:system("buff_system")

		for iter_10_0 = 1, var_10_6 do
			local var_10_8 = var_10_5[iter_10_0].actor
			local var_10_9 = Actor.unit(var_10_8)

			if DamageUtils.is_player_unit(var_10_9) and not ScriptUnit.extension(var_10_9, "buff_system"):has_buff_type("troll_bile_face") then
				var_10_7:add_buff(var_10_9, "bile_troll_vomit_face_base", arg_10_0)

				if arg_10_3 then
					arg_10_3.has_done_bile_damage = true
				end
			end
		end
	end
end

function BTVomitAction.create_aoe(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_2.puke_position:unbox()
	local var_11_1 = arg_11_0:_position_on_navmesh(var_11_0, arg_11_2)

	if var_11_1 then
		local var_11_2 = arg_11_2.puke_direction:unbox()
		local var_11_3 = {
			area_damage_system = {
				flow_dir = var_11_2,
				liquid_template = arg_11_2.near_vomit and (arg_11_2.breed.near_vomit or "bile_troll_vomit_near") or arg_11_2.breed.far_vomit or "bile_troll_vomit",
				source_unit = arg_11_1
			}
		}
		local var_11_4 = "units/hub_elements/empty"
		local var_11_5 = Managers.state.unit_spawner:spawn_network_unit(var_11_4, "liquid_aoe_unit", var_11_3, var_11_1)

		ScriptUnit.extension(var_11_5, "area_damage_system"):ready()
	end
end

function BTVomitAction.anim_cb_vomit(arg_12_0, arg_12_1, arg_12_2)
	if Managers.state.network:game() then
		arg_12_2.is_puking = true

		BTVomitAction:create_aoe(arg_12_1, arg_12_2, arg_12_2.action)
	end
end
