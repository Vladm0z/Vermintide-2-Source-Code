-- chunkname: @scripts/entity_system/systems/behaviour/nodes/skaven_ratling_gunner/bt_ratling_gunner_windup_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatlingGunnerWindUpAction = class(BTRatlingGunnerWindUpAction, BTNode)
BTRatlingGunnerWindUpAction.name = "BTRatlingGunnerWindUpAction"

function BTRatlingGunnerWindUpAction.init(arg_1_0, ...)
	BTRatlingGunnerWindUpAction.super.init(arg_1_0, ...)
end

function BTRatlingGunnerWindUpAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.attack_pattern_data or {}
	local var_2_2, var_2_3, var_2_4 = PerceptionUtils.pick_ratling_gun_target(arg_2_1, arg_2_2)

	if var_2_2 then
		var_2_1.target_unit = var_2_2
		var_2_1.target_node_name = var_2_3
		var_2_1.last_known_target_position = var_2_1.last_known_target_position or Vector3Box()
		var_2_1.last_known_unit_position = var_2_1.last_known_unit_position or Vector3Box()

		local var_2_5 = Unit.world_position(arg_2_1, Unit.node(arg_2_1, "c_spine"))
		local var_2_6 = Unit.world_position(var_2_2, Unit.node(var_2_2, var_2_3))

		var_2_1.last_known_target_position:store(var_2_6)
		var_2_1.last_known_unit_position:store(var_2_5)

		var_2_1.target_obscured = false
		var_2_1.target_check = arg_2_3 + 0.05 + Math.random() * 0.025
	else
		var_2_1.abort_windup = true
		arg_2_2.attack_pattern_data = var_2_1
		arg_2_2.action = var_2_0

		return
	end

	var_2_1.wind_up_timer = AiUtils.random(var_2_0.wind_up_time[1], var_2_0.wind_up_time[2])
	var_2_1.wind_up_time = var_2_1.wind_up_timer
	var_2_1.constraint_target = var_2_1.constraint_target or Unit.animation_find_constraint_target(arg_2_1, "aim_target")
	arg_2_2.attack_pattern_data = var_2_1
	arg_2_2.action = var_2_0

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.move_state = "attacking"

	AiUtils.anim_event(arg_2_1, var_2_1, "wind_up_start")

	if script_data.ai_ratling_gunner_debug then
		AiUtils.temp_anim_event(arg_2_1, "wind_up_start")
	end

	local var_2_7 = arg_2_2.breed.default_inventory_template

	var_2_1.ratling_gun_unit = ScriptUnit.extension(arg_2_1, "ai_inventory_system"):get_unit(var_2_7)

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.walk_speed)
end

function BTRatlingGunnerWindUpAction._update_target(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0, var_3_1, var_3_2 = PerceptionUtils.pick_ratling_gun_target(arg_3_1, arg_3_2)

	if var_3_0 then
		arg_3_3.target_unit = var_3_0
		arg_3_3.target_node_name = var_3_1

		local var_3_3 = Unit.world_position(arg_3_1, Unit.node(arg_3_1, "c_spine"))
		local var_3_4 = Unit.world_position(var_3_0, Unit.node(var_3_0, var_3_1))

		arg_3_3.last_known_target_position:store(var_3_4)
		arg_3_3.last_known_unit_position:store(var_3_3)

		arg_3_3.target_obscured = false
	elseif var_3_2 then
		local var_3_5 = arg_3_3.target_unit
		local var_3_6 = Unit.world_position(arg_3_1, Unit.node(arg_3_1, "c_spine"))
		local var_3_7 = Unit.world_position(var_3_5, Unit.node(var_3_5, var_3_1))

		arg_3_3.last_known_target_position:store(var_3_7)
		arg_3_3.last_known_unit_position:store(var_3_6)

		arg_3_3.target_obscured = false
	else
		arg_3_3.target_obscured = true
	end

	if arg_3_3.target_obscured then
		arg_3_3.target_check = arg_3_4 + 0.5 + Math.random() * 0.25
	else
		arg_3_3.target_check = arg_3_4 + 0.1 + Math.random() * 0.05
	end
end

function BTRatlingGunnerWindUpAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	AiUtils.clear_temp_anim_event(arg_4_1)

	arg_4_2.anim_cb_attack_windup_start_finished = nil

	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local var_4_1 = arg_4_2.navigation_extension

	var_4_1:set_enabled(true)
	var_4_1:set_max_speed(var_4_0)

	local var_4_2 = arg_4_2.attack_pattern_data or {}

	AiUtils.clear_anim_event(var_4_2)
end

function BTRatlingGunnerWindUpAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.attack_pattern_data

	if var_5_0.abort_windup then
		var_5_0.abort_windup = nil

		return "failed"
	end

	if not arg_5_2.first_shots_fired then
		arg_5_0:_update_target(arg_5_1, arg_5_2, var_5_0, arg_5_3)

		return "done"
	end

	var_5_0.wind_up_timer = var_5_0.wind_up_timer - arg_5_4

	if arg_5_3 > var_5_0.target_check then
		arg_5_0:_update_target(arg_5_1, arg_5_2, var_5_0, arg_5_3)
	end

	if not arg_5_2.anim_cb_attack_windup_start_finished then
		return "running"
	end

	AiUtils.anim_event(arg_5_1, var_5_0, "wind_up_loop")

	if script_data.ai_ratling_gunner_debug then
		AiUtils.temp_anim_event(arg_5_1, "wind_up_loop", var_5_0.wind_up_timer)
	end

	if var_5_0.wind_up_timer < 0 then
		return "done"
	end

	return "running"
end
