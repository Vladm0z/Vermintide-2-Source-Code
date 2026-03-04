-- chunkname: @scripts/unit_extensions/weapons/actions/action_bullet_spray.lua

ActionBulletSpray = class(ActionBulletSpray, ActionBase)

local var_0_0 = -1
local var_0_1 = math.abs(var_0_0) + 5
local var_0_2 = 3.5
local var_0_3 = 2
local var_0_4 = 10
local var_0_5 = {
	"j_leftshoulder",
	"j_rightshoulder",
	"j_spine1"
}
local var_0_6 = #var_0_5

ActionBulletSpray.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionBulletSpray.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0.targets = {}
end

ActionBulletSpray.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionBulletSpray.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ActionUtils.is_critical_strike(var_2_0, arg_2_1, arg_2_2)

	arg_2_0.power_level = arg_2_4
	arg_2_0.current_action = arg_2_1
	arg_2_0._target_index = 1
	arg_2_0.state = "waiting_to_shoot"
	arg_2_0._check_buffs = true

	if arg_2_1.use_ammo_at_time then
		arg_2_0.use_ammo_time = arg_2_2 + arg_2_1.use_ammo_at_time
		arg_2_0.used_ammo = false
	end

	local var_2_2 = math.sqrt(var_0_1 * var_0_1 + var_0_2 * var_0_2)

	arg_2_0.CONE_COS_ALPHA = var_0_1 / var_2_2

	local var_2_3 = arg_2_1.overcharge_type

	if var_2_3 then
		local var_2_4 = PlayerUnitStatusSettings.overcharge_values[var_2_3]

		if var_2_1 and arg_2_0.buff_extension:has_buff_perk("no_overcharge_crit") then
			var_2_4 = 0
		end

		arg_2_0.overcharge_extension:add_charge(var_2_4)
	end

	local var_2_5 = ScriptUnit.has_extension(var_2_0, "hud_system")

	arg_2_0:_handle_critical_strike(var_2_1, arg_2_0.buff_extension, var_2_5, nil, "on_critical_shot", nil)

	arg_2_0._is_critical_strike = var_2_1
end

ActionBulletSpray.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.current_action

	if arg_3_0.use_ammo_time and not arg_3_0.used_ammo and arg_3_2 >= arg_3_0.use_ammo_time then
		arg_3_0.used_ammo = true

		local var_3_1 = arg_3_0.ammo_extension

		if var_3_1 then
			var_3_1:use_ammo(var_3_0.ammo_usage)
		end
	end

	if arg_3_0.state == "waiting_to_shoot" then
		arg_3_0:_select_targets(arg_3_3, true)

		if not Managers.player:owner(arg_3_0.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "handgun_fire"
			})
		end

		local var_3_2 = var_3_0.fire_sound_event

		if var_3_2 then
			local var_3_3 = var_3_0.fire_sound_on_husk

			ScriptUnit.extension(arg_3_0.owner_unit, "first_person_system"):play_hud_sound_event(var_3_2, nil, var_3_3)
		end

		arg_3_0.state = "shooting"
	end

	if arg_3_0.state == "shooting" then
		local var_3_4 = arg_3_0.first_person_unit
		local var_3_5 = POSITION_LOOKUP[var_3_4]
		local var_3_6 = arg_3_0.targets
		local var_3_7 = arg_3_0._target_index
		local var_3_8 = var_3_6[var_3_7]

		if Unit.alive(var_3_8) then
			local var_3_9 = Unit.get_data(var_3_8, "breed")
			local var_3_10 = "j_spine"

			if var_3_9 then
				local var_3_11 = math.random(1, var_0_6)

				for iter_3_0 = 1, var_0_6 do
					local var_3_12 = math.index_wrapper(var_3_11 + iter_3_0 - 1, var_0_6)
					local var_3_13 = var_0_5[var_3_12]

					if Unit.has_node(var_3_8, var_3_13) then
						var_3_10 = var_3_13

						break
					end
				end
			end

			local var_3_14 = Unit.world_position(var_3_8, Unit.node(var_3_8, var_3_10))
			local var_3_15 = Vector3.normalize(var_3_14 - var_3_5)
			local var_3_16 = arg_3_0:raycast_to_target(arg_3_3, var_3_5, var_3_15, var_3_8)
			local var_3_17

			if var_3_0.area_damage then
				var_3_17 = var_3_8
			end

			if var_3_16 then
				local var_3_18 = arg_3_0._check_buffs

				if DamageUtils.process_projectile_hit(arg_3_3, arg_3_0.item_name, arg_3_0.owner_unit, arg_3_0.is_server, var_3_16, var_3_0, var_3_15, var_3_18, var_3_17, nil, arg_3_0._is_critical_strike, arg_3_0.power_level).buffs_checked then
					var_3_18 = var_3_18 and false
				end

				arg_3_0._check_buffs = var_3_18
			end

			local var_3_19 = arg_3_0.weapon_unit
			local var_3_20 = var_3_16 and var_3_16[#var_3_16][1] or var_3_5 + var_3_15 * 100

			Unit.set_flow_variable(var_3_19, "hit_position", var_3_20)
			Unit.set_flow_variable(var_3_19, "trail_life", Vector3.length(var_3_20 - var_3_5) * 0.1)
			Unit.flow_event(var_3_19, "lua_bullet_trail")
			Unit.flow_event(var_3_19, "lua_bullet_trail_set")
		end

		arg_3_0._target_index = var_3_7 + 1

		if arg_3_0._target_index > #var_3_6 then
			arg_3_0:_proc_spell_used(arg_3_0.buff_extension)

			arg_3_0.state = "shot"
		end
	end
end

ActionBulletSpray.finish = function (arg_4_0, arg_4_1)
	arg_4_0:_clear_targets()

	local var_4_0 = arg_4_0.ammo_extension
	local var_4_1 = arg_4_0.current_action
	local var_4_2 = arg_4_0.owner_unit
	local var_4_3 = var_4_1.reload_when_out_of_ammo_condition_func
	local var_4_4 = not var_4_3 and true or var_4_3(var_4_2, arg_4_1)

	if var_4_0 and var_4_1.reload_when_out_of_ammo and var_4_4 and var_4_0:ammo_count() == 0 and var_4_0:can_reload() then
		local var_4_5 = true

		var_4_0:start_reload(var_4_5)
	end

	local var_4_6 = ScriptUnit.has_extension(var_4_2, "hud_system")

	if var_4_6 then
		var_4_6.show_critical_indication = false
	end

	if arg_4_0.state ~= "waiting_to_shoot" and arg_4_0.state ~= "shot" then
		arg_4_0:_proc_spell_used(arg_4_0.buff_extension)
	end
end

ActionBulletSpray._clear_targets = function (arg_5_0)
	table.clear(arg_5_0.targets)
end

local var_0_7 = Actor.unit
local var_0_8 = Vector3.distance_squared
local var_0_9 = Unit.local_position

ActionBulletSpray._select_targets = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = World.get_data(arg_6_1, "physics_world")
	local var_6_1 = arg_6_0.first_person_unit
	local var_6_2 = POSITION_LOOKUP[var_6_1]
	local var_6_3 = Unit.world_rotation(var_6_1, 0)
	local var_6_4 = Vector3.normalize(Quaternion.forward(var_6_3))
	local var_6_5 = not Managers.state.difficulty:get_difficulty_settings().friendly_fire_ranged

	if arg_6_0.current_action.fire_at_gaze_setting and ScriptUnit.has_extension(arg_6_0.owner_unit, "eyetracking_system") then
		local var_6_6 = ScriptUnit.extension(arg_6_0.owner_unit, "eyetracking_system")

		if var_6_6:get_is_feature_enabled("tobii_fire_at_gaze") then
			var_6_4 = var_6_6:gaze_forward()
		end
	end

	local var_6_7 = var_6_2 + var_6_4 * var_0_0 + var_6_4 * var_0_2
	local var_6_8 = var_6_2 + var_6_4 * var_0_0 + var_6_4 * (var_0_1 - var_0_2)

	PhysicsWorld.prepare_actors_for_overlap(var_6_0, var_6_7, var_0_1 * var_0_1)

	local var_6_9 = PhysicsWorld.linear_sphere_sweep(var_6_0, var_6_7, var_6_8, var_0_2, 100, "collision_filter", "filter_character_trigger", "report_initial_overlap")

	table.sort(var_6_9, function (arg_7_0, arg_7_1)
		local var_7_0 = var_0_7(arg_7_0.actor)
		local var_7_1 = var_0_7(arg_7_1.actor)
		local var_7_2 = var_0_9(var_7_0, 0)
		local var_7_3 = var_0_9(var_7_1, 0)

		return var_0_8(var_6_2, var_7_2) < var_0_8(var_6_2, var_7_3)
	end)

	if var_6_9 then
		local var_6_10 = Managers.state.side.side_by_unit[arg_6_0.owner_unit].PLAYER_AND_BOT_UNITS
		local var_6_11 = #var_6_9
		local var_6_12 = arg_6_0.targets
		local var_6_13, var_6_14, var_6_15 = Script.temp_count()
		local var_6_16 = {}
		local var_6_17 = 0

		for iter_6_0 = 1, var_6_11 do
			local var_6_18 = var_6_9[iter_6_0]
			local var_6_19 = var_6_18.actor
			local var_6_20 = Actor.unit(var_6_19)
			local var_6_21 = var_6_18.position

			if not var_6_16[var_6_20] then
				local var_6_22 = Unit.get_data(var_6_20, "breed")

				if table.contains(var_6_10, var_6_20) and not var_6_5 then
					if arg_6_0:_is_infront_player(var_6_2, var_6_4, var_6_21) and arg_6_0:_check_within_cone(var_6_2, var_6_4, var_6_20, true) then
						var_6_12[#var_6_12 + 1] = var_6_20
						var_6_16[var_6_20] = true
					end
				elseif var_6_22 and arg_6_0:_is_infront_player(var_6_2, var_6_4, var_6_21) and arg_6_0:_check_within_cone(var_6_2, var_6_4, var_6_20) then
					var_6_12[#var_6_12 + 1] = var_6_20
					var_6_16[var_6_20] = true

					if HEALTH_ALIVE[var_6_20] then
						var_6_17 = var_6_17 + 1
					end
				end

				if var_6_17 >= var_0_4 then
					break
				end
			end
		end

		Script.set_temp_count(var_6_13, var_6_14, var_6_15)
	end
end

ActionBulletSpray._check_within_cone = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_0.CONE_COS_ALPHA

	if arg_8_4 then
		local var_8_1 = math.sqrt(var_0_1 * var_0_1 + var_0_3 * var_0_3)

		var_8_0 = var_0_1 / var_8_1
	end

	local var_8_2 = Unit.world_position(arg_8_3, Unit.node(arg_8_3, "j_neck"))
	local var_8_3 = Vector3.normalize(var_8_2 - arg_8_1)

	if var_8_0 <= Vector3.dot(arg_8_2, var_8_3) then
		return true
	end

	return false
end

ActionBulletSpray._is_infront_player = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = Vector3.normalize(arg_9_3 - arg_9_1)

	if Vector3.dot(var_9_0, arg_9_2) > 0 then
		return true
	end
end

ActionBulletSpray.raycast_to_target = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = World.get_data(arg_10_1, "physics_world")
	local var_10_1 = "filter_player_ray_projectile"

	return (PhysicsWorld.immediate_raycast(var_10_0, arg_10_2, arg_10_3, "all", "collision_filter", var_10_1))
end
