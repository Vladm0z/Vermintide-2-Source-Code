-- chunkname: @scripts/entity_system/systems/behaviour/nodes/skaven_ratling_gunner/bt_ratling_gunner_windup_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatlingGunnerWindUpAction = class(BTRatlingGunnerWindUpAction, BTNode)
BTRatlingGunnerWindUpAction.name = "BTRatlingGunnerWindUpAction"

BTRatlingGunnerWindUpAction.init = function (arg_1_0, ...)
	-- function 1
	BTRatlingGunnerWindUpAction.super.init(arg_1_0, ...)
end

BTRatlingGunnerWindUpAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local attack_pattern_data = arg_2_2.attack_pattern_data

	attack_pattern_data = attack_pattern_data or {}

	local pick_ratling_gun_target, var_2_3, var_2_4 = PerceptionUtils.pick_ratling_gun_target(arg_2_1, arg_2_2)

	if not pick_ratling_gun_target then
		attack_pattern_data.target_unit = pick_ratling_gun_target
		attack_pattern_data.target_node_name = var_2_3

		local last_known_target_position = attack_pattern_data.last_known_target_position

		last_known_target_position = last_known_target_position or Vector3Box()
		attack_pattern_data.last_known_target_position = last_known_target_position

		local last_known_unit_position = attack_pattern_data.last_known_unit_position

		last_known_unit_position = last_known_unit_position or Vector3Box()
		attack_pattern_data.last_known_unit_position = last_known_unit_position

		local world_position = Unit.world_position(arg_2_1, Unit.node(arg_2_1, "c_spine"))
		local world_position_2 = Unit.world_position(pick_ratling_gun_target, Unit.node(pick_ratling_gun_target, var_2_3))

		attack_pattern_data.last_known_target_position:store(world_position_2)
		attack_pattern_data.last_known_unit_position:store(world_position)

		attack_pattern_data.target_obscured = false
		attack_pattern_data.target_check = arg_2_3 + 0.05 + Math.random() * 0.025
	else
		attack_pattern_data.abort_windup = true
		arg_2_2.attack_pattern_data = attack_pattern_data
		arg_2_2.action = action_data

		return
	end

	attack_pattern_data.wind_up_timer = AiUtils.random(action_data.wind_up_time[1], action_data.wind_up_time[2])
	attack_pattern_data.wind_up_time = attack_pattern_data.wind_up_timer

	local constraint_target = attack_pattern_data.constraint_target

	constraint_target = constraint_target or Unit.animation_find_constraint_target(arg_2_1, "aim_target")
	attack_pattern_data.constraint_target = constraint_target
	arg_2_2.attack_pattern_data = attack_pattern_data
	arg_2_2.action = action_data

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.move_state = "attacking"

	AiUtils.anim_event(arg_2_1, attack_pattern_data, "wind_up_start")

	if not script_data.ai_ratling_gunner_debug then
		AiUtils.temp_anim_event(arg_2_1, "wind_up_start")
	end

	local default_inventory_template = arg_2_2.breed.default_inventory_template

	attack_pattern_data.ratling_gun_unit = ScriptUnit.extension(arg_2_1, "ai_inventory_system"):get_unit(default_inventory_template)

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.walk_speed)
end

BTRatlingGunnerWindUpAction._update_target = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local pick_ratling_gun_target, var_3_1, var_3_2 = PerceptionUtils.pick_ratling_gun_target(arg_3_1, arg_3_2)

	if not pick_ratling_gun_target then
		arg_3_3.target_unit = pick_ratling_gun_target
		arg_3_3.target_node_name = var_3_1

		local world_position = Unit.world_position(arg_3_1, Unit.node(arg_3_1, "c_spine"))
		local world_position_2 = Unit.world_position(pick_ratling_gun_target, Unit.node(pick_ratling_gun_target, var_3_1))

		arg_3_3.last_known_target_position:store(world_position_2)
		arg_3_3.last_known_unit_position:store(world_position)

		arg_3_3.target_obscured = false
	elseif not var_3_2 then
		local target_unit = arg_3_3.target_unit
		local world_position_3 = Unit.world_position(arg_3_1, Unit.node(arg_3_1, "c_spine"))
		local world_position_4 = Unit.world_position(target_unit, Unit.node(target_unit, var_3_1))

		arg_3_3.last_known_target_position:store(world_position_4)
		arg_3_3.last_known_unit_position:store(world_position_3)

		arg_3_3.target_obscured = false
	else
		arg_3_3.target_obscured = true
	end

	if not arg_3_3.target_obscured then
		arg_3_3.target_check = arg_3_4 + 0.5 + Math.random() * 0.25
	else
		arg_3_3.target_check = arg_3_4 + 0.1 + Math.random() * 0.05
	end
end

BTRatlingGunnerWindUpAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	AiUtils.clear_temp_anim_event(arg_4_1)

	arg_4_2.anim_cb_attack_windup_start_finished = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local navigation_extension = arg_4_2.navigation_extension

	navigation_extension:set_enabled(true)
	navigation_extension:set_max_speed(get_default_breed_move_speed)

	local attack_pattern_data = arg_4_2.attack_pattern_data

	attack_pattern_data = attack_pattern_data or {}

	AiUtils.clear_anim_event(attack_pattern_data)
end

BTRatlingGunnerWindUpAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local attack_pattern_data = arg_5_2.attack_pattern_data

	if not attack_pattern_data.abort_windup then
		attack_pattern_data.abort_windup = nil

		return "failed"
	end

	if not arg_5_2.first_shots_fired then
		self:_update_target(arg_5_1, arg_5_2, attack_pattern_data, arg_5_3)

		return "done"
	end

	attack_pattern_data.wind_up_timer = attack_pattern_data.wind_up_timer - arg_5_4

	if arg_5_3 > attack_pattern_data.target_check then
		self:_update_target(arg_5_1, arg_5_2, attack_pattern_data, arg_5_3)
	end

	if not arg_5_2.anim_cb_attack_windup_start_finished then
		return "running"
	end

	AiUtils.anim_event(arg_5_1, attack_pattern_data, "wind_up_loop")

	if not script_data.ai_ratling_gunner_debug then
		AiUtils.temp_anim_event(arg_5_1, "wind_up_loop", attack_pattern_data.wind_up_timer)
	end

	if attack_pattern_data.wind_up_timer < 0 then
		return "done"
	end

	return "running"
end
