-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_vomit_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVomitAction = class(BTVomitAction, BTNode)

BTVomitAction.init = function (arg_1_0, ...)
	-- function 1
	BTVomitAction.super.init(arg_1_0, ...)
end

BTVomitAction.name = "BTVomitAction"

local function fn(...)
	-- function 2
	if not script_data.debug_chaos_troll then
		print(...)
	end
end

BTVomitAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data
	local world = arg_3_2.world

	arg_3_2.action = action_data
	arg_3_2.active_node = BTVomitAction

	local physics_world = arg_3_2.physics_world

	physics_world = physics_world or World.get_data(world, "physics_world")
	arg_3_2.physics_world = physics_world
	arg_3_2.rotation_time = arg_3_3 + action_data.rotation_time
	arg_3_2.check_puke_time = nil

	if not self:init_attack(arg_3_1, arg_3_2, action_data, arg_3_3) then
		arg_3_2.anim_locked = arg_3_3 + action_data.attack_time
		arg_3_2.move_state = "attacking"
		arg_3_2.attack_aborted = false
		arg_3_2.keep_target = true

		Managers.state.conflict:freeze_intensity_decay(15)
	else
		arg_3_2.attack_aborted = true
	end

	arg_3_2.update_puke_pos_at_t = arg_3_3 + 0.2

	local target_unit = arg_3_2.target_unit

	AiUtils.add_attack_intensity(target_unit, action_data, arg_3_2)
end

BTVomitAction._position_on_navmesh = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local nav_world = arg_4_2.nav_world
	local triangle_from_position, var_4_2 = GwNavQueries.triangle_from_position(nav_world, arg_4_1, 1, 1)

	if not triangle_from_position then
		arg_4_1 = Vector3.copy(arg_4_1)
		arg_4_1.z = var_4_2
	else
		arg_4_1 = GwNavQueries.inside_position_from_outside_position(nav_world, arg_4_1, 3, 3, 1, 1)
	end

	return arg_4_1
end

BTVomitAction._get_vomit_position = function (self, arg_5_1, arg_5_2)
	-- function 5
	local node = Unit.node(arg_5_1, "j_head")
	local world_position = Unit.world_position(arg_5_1, node)
	local var_5_2 = POSITION_LOOKUP[arg_5_2.target_unit]
	local num = var_5_2 - world_position
	local normalize = Vector3.normalize(num)
	local length = Vector3.length(num)
	local physics_world = arg_5_2.physics_world
	local var_5_7
	local var_5_8
	local var_5_9
	local immediate_raycast, var_5_11, var_5_12, var_5_13, var_5_14 = PhysicsWorld.immediate_raycast(physics_world, world_position, normalize, length, "closest", "collision_filter", "filter_enemy_ray_projectile")

	if not immediate_raycast then
		var_5_7 = var_5_11
	else
		var_5_7 = var_5_2
	end

	local _position_on_navmesh = self:_position_on_navmesh(var_5_7, arg_5_2)

	if not _position_on_navmesh then
		local num_2 = _position_on_navmesh - world_position

		var_5_8 = Vector3.length_squared(num_2)
		var_5_9 = Vector3.normalize(num_2)
	end

	return _position_on_navmesh, var_5_8, var_5_9
end

BTVomitAction.init_attack = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local _get_vomit_position, var_6_1, var_6_2 = self:_get_vomit_position(arg_6_1, arg_6_2)

	if not _get_vomit_position then
		return false
	end

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "enemy_attack", DialogueSettings.pounced_down_broadcast_range, "attack_tag", "before_puke")

	local var_6_3
	local attack_anims = arg_6_3.attack_anims

	arg_6_2.navigation_extension:stop()

	if not (not (Vector3.dot(var_6_2, Vector3.down()) >= 0.35) or not (var_6_1 < arg_6_3.near_vomit_distance) or not arg_6_2.needs_to_crouch) then
		var_6_3 = attack_anims.near_vomit
		arg_6_2.near_vomit = true
	else
		var_6_3 = attack_anims.ranged_vomit
	end

	Managers.state.network:anim_event(arg_6_1, var_6_3)

	arg_6_2.attack_started_at_t = arg_6_4
	arg_6_2.puke_position = Vector3Box(_get_vomit_position)
	arg_6_2.puke_direction = Vector3Box(var_6_2)

	local bot_threats = arg_6_3.bot_threats

	if not bot_threats then
		bot_threats = arg_6_3.bot_threats[var_6_3]

		if not bot_threats then
			bot_threats = arg_6_3.bot_threats[1]
			bot_threats = not bot_threats and arg_6_3.bot_threats
		end
	end

	if not bot_threats then
		local num = 1
		local var_6_7 = bot_threats[num]
		local calculate_bot_threat_time, var_6_9 = AiUtils.calculate_bot_threat_time(var_6_7)

		arg_6_2.create_bot_threat_at_t = arg_6_4 + calculate_bot_threat_time
		arg_6_2.current_bot_threat_index = num
		arg_6_2.bot_threat_duration = var_6_9
		arg_6_2.bot_threats_data = bot_threats
	end

	local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_6_1, _get_vomit_position)

	arg_6_2.attack_rotation = QuaternionBox(look_at_position_flat)

	arg_6_2.locomotion_extension:set_wanted_rotation(look_at_position_flat)

	return true
end

BTVomitAction.leave = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
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

BTVomitAction._calculate_oobb_collision = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local width = arg_8_1.width
	local range = arg_8_1.range
	local height = arg_8_1.height
	local offset_forward = arg_8_1.offset_forward
	local offset_up = arg_8_1.offset_up
	local num = width * 0.5
	local num_2 = range * 0.5
	local num_3 = height * 0.5
	local var_8_8 = Vector3(num, num_2, num_3)
	local num_4 = Quaternion.rotate(arg_8_3, Vector3.forward()) * (offset_forward + num_2)
	local num_5 = Vector3.up() * (offset_up + num_3)

	return arg_8_2 + num_4 + num_5, arg_8_3, var_8_8
end

BTVomitAction.run = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	if not arg_9_2.attack_aborted then
		return "failed"
	end

	if arg_9_3 < arg_9_2.anim_locked then
		local target_unit = arg_9_2.target_unit
		local has_extension = ScriptUnit.has_extension(target_unit, "status_system")

		if not arg_9_2.is_puking then
			if not arg_9_2.check_puke_time then
				arg_9_2.check_puke_time = arg_9_3 + 0.2
			end

			if arg_9_3 > arg_9_2.check_puke_time then
				self.player_vomit_hit_check(arg_9_1, arg_9_2.puke_position:unbox(), arg_9_2.physics_world, arg_9_2)
			end
		elseif not (not (arg_9_3 < arg_9_2.rotation_time) or not has_extension and has_extension:get_is_dodging() and has_extension:is_invisible() and not (arg_9_3 > arg_9_2.update_puke_pos_at_t)) then
			local _get_vomit_position, var_9_3, var_9_4 = self:_get_vomit_position(arg_9_1, arg_9_2)

			if not _get_vomit_position and not var_9_4 then
				arg_9_2.puke_position:store(_get_vomit_position)
				arg_9_2.puke_direction:store(var_9_4)
			end

			arg_9_2.update_puke_pos_at_t = arg_9_3 + 0.2
		end

		if not arg_9_2.puke_direction then
			local puke_direction = arg_9_2.puke_direction
			local var_9_6 = Vector3(puke_direction.x, puke_direction.y, 0)
			local look = Quaternion.look(var_9_6)

			arg_9_2.locomotion_extension:set_wanted_rotation(look)
		end

		local create_bot_threat_at_t = arg_9_2.create_bot_threat_at_t

		if not (not create_bot_threat_at_t and not (create_bot_threat_at_t < arg_9_3)) then
			local action = arg_9_2.action
			local bot_threats_data = arg_9_2.bot_threats_data
			local current_bot_threat_index = arg_9_2.current_bot_threat_index
			local var_9_12 = bot_threats_data[current_bot_threat_index]
			local bot_threat_duration = arg_9_2.bot_threat_duration
			local var_9_14 = POSITION_LOOKUP[arg_9_1]
			local unbox = arg_9_2.attack_rotation:unbox()
			local _calculate_oobb_collision, var_9_17, var_9_18 = self:_calculate_oobb_collision(var_9_12, var_9_14, unbox)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(_calculate_oobb_collision, "oobb", var_9_18, var_9_17, bot_threat_duration, "Vomit")

			local num = current_bot_threat_index + 1
			local var_9_20 = bot_threats_data[num]

			if not var_9_20 then
				local attack_started_at_t = arg_9_2.attack_started_at_t
				local calculate_bot_threat_time, var_9_23 = AiUtils.calculate_bot_threat_time(var_9_20)

				arg_9_2.create_bot_threat_at_t = attack_started_at_t + calculate_bot_threat_time
				arg_9_2.bot_threat_duration = var_9_23
				arg_9_2.current_bot_threat_index = num
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

BTVomitAction.player_vomit_hit_check = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local node = Unit.node(arg_10_0, "j_head")
	local world_position = Unit.world_position(arg_10_0, node)
	local num = arg_10_1 + (2 * Vector3.normalize(arg_10_1 - POSITION_LOOKUP[arg_10_0]) + Vector3(0, 0, 1)) - world_position
	local normalize = Vector3.normalize(num)
	local length = Vector3.length(num)
	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(arg_10_2, world_position, arg_10_1, 0.5, 10, "collision_filter", "filter_enemy_ray_projectile", "report_initial_overlap")

	if not linear_sphere_sweep then
		local count = #linear_sphere_sweep
		local system = Managers.state.entity:system("buff_system")

		for i = 1, count do
			local actor = linear_sphere_sweep[i].actor
			local unit = Actor.unit(actor)

			if not (not DamageUtils.is_player_unit(unit) and ScriptUnit.extension(unit, "buff_system"):has_buff_type("troll_bile_face")) then
				system:add_buff(unit, "bile_troll_vomit_face_base", arg_10_0)

				if not arg_10_3 then
					arg_10_3.has_done_bile_damage = true
				end
			end
		end
	end
end

BTVomitAction.create_aoe = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local unbox = arg_11_2.puke_position:unbox()
	local _position_on_navmesh = self:_position_on_navmesh(unbox, arg_11_2)

	if not _position_on_navmesh then
		local unbox_2 = arg_11_2.puke_direction:unbox()
		local tbl = {}
		local tbl_2 = {
			flow_dir = unbox_2
		}
		local near_vomit

		if not arg_11_2.near_vomit then
			near_vomit = arg_11_2.breed.near_vomit

			if not near_vomit then
				near_vomit = "bile_troll_vomit_near"
			end
		else
			near_vomit = arg_11_2.breed.far_vomit
			near_vomit = near_vomit or "bile_troll_vomit"
		end

		tbl_2.liquid_template = near_vomit
		tbl_2.source_unit = arg_11_1
		tbl.area_damage_system = tbl_2

		local str = "units/hub_elements/empty"
		local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, _position_on_navmesh)

		ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
	end
end

BTVomitAction.anim_cb_vomit = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	if not Managers.state.network:game() then
		arg_12_2.is_puking = true

		BTVomitAction:create_aoe(arg_12_1, arg_12_2, arg_12_2.action)
	end
end
