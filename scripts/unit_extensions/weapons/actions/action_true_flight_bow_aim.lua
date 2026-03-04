-- chunkname: @scripts/unit_extensions/weapons/actions/action_true_flight_bow_aim.lua

require("scripts/unit_extensions/weapons/projectiles/true_flight_templates")
require("scripts/unit_extensions/weapons/projectiles/true_flight_utility")

ActionTrueFlightBowAim = class(ActionTrueFlightBowAim, ActionBase)

local var_0_0 = Actor.unit
local var_0_1 = Actor.node
local var_0_2 = Unit.actor
local var_0_3 = Unit.has_node
local var_0_4 = Unit.node
local var_0_5 = Unit.get_data
local var_0_6 = Unit.world_position
local var_0_7 = Vector3.distance_squared
local var_0_8 = Vector3.length
local var_0_9 = Vector3.dot
local var_0_10 = 1
local var_0_11 = 2
local var_0_12 = 3
local var_0_13 = 4

ActionTrueFlightBowAim.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionTrueFlightBowAim.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_0.weapon_unit, "spread_system") then
		arg_1_0.spread_extension = ScriptUnit.extension(arg_1_0.weapon_unit, "spread_system")
	end

	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	arg_1_0._weapon_extension = ScriptUnit.extension(arg_1_0.weapon_unit, "weapon_system")
end

ActionTrueFlightBowAim.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	ActionTrueFlightBowAim.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3)

	arg_2_0._marked_target = {}
	arg_2_0.current_action = arg_2_1
	arg_2_0.aim_timer = 0
	arg_2_0.aim_sticky_timer = 0
	arg_2_0._is_sticky_target = false
	arg_2_0._current_target_priority = -1
	arg_2_0.target = arg_2_3 and arg_2_3.target or nil
	arg_2_0.targets = arg_2_3 and arg_2_3.targets or {}
	arg_2_0.aimed_target = arg_2_3 and arg_2_3.target or nil

	arg_2_0:_mark_target(arg_2_0.target)

	arg_2_0.time_to_shoot = arg_2_2

	local var_2_0 = arg_2_0.owner_unit

	arg_2_0.side = Managers.state.side.side_by_unit[var_2_0]
	arg_2_0.target_broadphase_categories = arg_2_0.side and arg_2_0.side.enemy_broadphase_categories

	local var_2_1 = ScriptUnit.extension(var_2_0, "buff_system")

	arg_2_0._ignored_breeds = arg_2_1.ignored_breeds or {}
	arg_2_0.charge_time = var_2_1:apply_buffs_to_value(arg_2_1.charge_time or 0, "reduced_ranged_charge_time")
	arg_2_0.overcharge_timer = 0
	arg_2_0.zoom_condition_function = arg_2_1.zoom_condition_function
	arg_2_0.prioritized_breeds = arg_2_1.prioritized_breeds
	arg_2_0.played_aim_sound = false
	arg_2_0.aim_sound_time = arg_2_2 + (arg_2_1.aim_sound_delay or 0)
	arg_2_0.aim_zoom_time = arg_2_2 + (arg_2_1.aim_zoom_delay or 0)

	local var_2_2 = arg_2_1.loaded_projectile_settings

	if var_2_2 then
		ScriptUnit.extension(arg_2_0.owner_unit, "inventory_system"):set_loaded_projectile_override(var_2_2)
	end

	arg_2_0.charge_ready_sound_event = arg_2_0.current_action.charge_ready_sound_event

	arg_2_0:_start_charge_sound()

	local var_2_3 = arg_2_1.spread_template_override

	if var_2_3 then
		arg_2_0.spread_extension:override_spread_template(var_2_3)
	end
end

ActionTrueFlightBowAim._start_charge_sound = function (arg_3_0)
	local var_3_0 = arg_3_0.current_action
	local var_3_1 = arg_3_0.owner_unit
	local var_3_2 = arg_3_0.owner_player
	local var_3_3 = var_3_2 and var_3_2.bot_player
	local var_3_4 = var_3_2 and not var_3_2.remote
	local var_3_5 = arg_3_0.wwise_world

	if var_3_4 and not var_3_3 then
		local var_3_6, var_3_7 = ActionUtils.start_charge_sound(var_3_5, arg_3_0.weapon_unit, var_3_1, var_3_0)

		arg_3_0.charging_sound_id = var_3_6
		arg_3_0.wwise_source_id = var_3_7
	end

	ActionUtils.play_husk_sound_event(var_3_5, var_3_0.charge_sound_husk_name, var_3_1, var_3_3)
end

ActionTrueFlightBowAim._stop_charge_sound = function (arg_4_0)
	local var_4_0 = arg_4_0.current_action
	local var_4_1 = arg_4_0.owner_unit
	local var_4_2 = arg_4_0.owner_player
	local var_4_3 = var_4_2 and var_4_2.bot_player
	local var_4_4 = var_4_2 and not var_4_2.remote
	local var_4_5 = arg_4_0.wwise_world

	if var_4_4 and not var_4_3 then
		ActionUtils.stop_charge_sound(var_4_5, arg_4_0.charging_sound_id, arg_4_0.wwise_source_id, var_4_0)

		arg_4_0.charging_sound_id = nil
		arg_4_0.wwise_source_id = nil
	end

	ActionUtils.play_husk_sound_event(var_4_5, var_4_0.charge_sound_husk_stop_event, var_4_1, var_4_3)
end

local function var_0_14(arg_5_0)
	local var_5_0 = ScriptUnit.has_extension(arg_5_0, "status_system")

	return var_5_0 and var_5_0:is_invisible()
end

local var_0_15 = {}

ActionTrueFlightBowAim.client_owner_post_update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_0.current_action
	local var_6_1 = arg_6_0.owner_unit
	local var_6_2 = arg_6_0.time_to_shoot
	local var_6_3 = arg_6_0.target
	local var_6_4 = Managers.player:owner(var_6_1)
	local var_6_5 = var_6_4 and var_6_4.bot_player

	if var_6_0.overcharge_interval then
		arg_6_0.overcharge_timer = arg_6_0.overcharge_timer + arg_6_1

		if arg_6_0.overcharge_timer >= var_6_0.overcharge_interval then
			if arg_6_0.overcharge_extension then
				local var_6_6 = PlayerUnitStatusSettings.overcharge_values[var_6_0.overcharge_type]

				arg_6_0.overcharge_extension:add_charge(var_6_6)
			end

			arg_6_0.overcharge_timer = 0
		end
	end

	if not arg_6_0.zoom_condition_function or arg_6_0.zoom_condition_function() then
		local var_6_7 = ScriptUnit.extension(var_6_1, "status_system")
		local var_6_8 = ScriptUnit.extension(var_6_1, "input_system")
		local var_6_9 = ScriptUnit.extension(var_6_1, "buff_system")

		if not var_6_7:is_zooming() and arg_6_2 >= arg_6_0.aim_zoom_time then
			var_6_7:set_zooming(true, var_6_0.default_zoom)
		end

		if var_6_9:has_buff_type("increased_zoom") and var_6_7:is_zooming() and var_6_8:get("action_three") then
			var_6_7:switch_variable_zoom(var_6_0.buffed_zoom_thresholds)
		elseif var_6_0.zoom_thresholds and var_6_7:is_zooming() and var_6_8:get("action_three") then
			var_6_7:switch_variable_zoom(var_6_0.zoom_thresholds)
		end
	end

	if not arg_6_0.played_aim_sound and arg_6_2 >= arg_6_0.aim_sound_time and not var_6_5 then
		local var_6_10 = var_6_0.aim_sound_event

		if var_6_10 then
			local var_6_11 = arg_6_0.wwise_world

			WwiseWorld.trigger_event(var_6_11, var_6_10)
		end

		arg_6_0.played_aim_sound = true
	end

	if var_6_3 and (not HEALTH_ALIVE[var_6_3] or var_0_14(var_6_3)) then
		if not var_6_5 then
			arg_6_0:_mark_target(nil)
		end

		arg_6_0.target = nil
		arg_6_0.aimed_target = nil
		var_6_3 = nil
	end

	local var_6_12 = var_6_0.aim_time or 0.1
	local var_6_13 = var_6_0.aim_sticky_time or 0

	if var_6_12 <= arg_6_0.aim_timer and (not var_6_3 or var_6_13 <= arg_6_0.aim_sticky_timer) then
		local var_6_14 = World.get_data(arg_6_3, "physics_world")
		local var_6_15, var_6_16 = arg_6_0.first_person_extension:get_projectile_start_position_rotation()
		local var_6_17 = Vector3.normalize(Quaternion.forward(var_6_16))
		local var_6_18
		local var_6_19

		if var_6_0.aim_obstructed_by_walls then
			var_6_18, var_6_19 = PhysicsWorld.immediate_raycast_actors(var_6_14, var_6_15, var_6_17, "dynamic_collision_filter", "filter_ray_true_flight_ai_only", "dynamic_collision_filter", "filter_ray_true_flight_hitbox_only", "static_collision_filter", "filter_player_ray_projectile_static_only")
		else
			var_6_18, var_6_19 = PhysicsWorld.immediate_raycast_actors(var_6_14, var_6_15, var_6_17, "dynamic_collision_filter", "filter_ray_true_flight_ai_only", "dynamic_collision_filter", "filter_ray_true_flight_hitbox_only")
		end

		local var_6_20 = true

		if var_6_0.can_target_players then
			var_6_20 = var_6_0.can_target_players(arg_6_0.owner_unit)
		end

		local var_6_21 = arg_6_0._ignored_breeds
		local var_6_22 = Managers.state.side
		local var_6_23 = var_6_22.side_by_unit
		local var_6_24
		local var_6_25 = -1
		local var_6_26 = arg_6_0.side

		if var_6_19 > 0 then
			local var_6_27 = arg_6_0.prioritized_breeds or var_0_15
			local var_6_28 = var_6_0.ignore_bosses

			for iter_6_0 = 1, var_6_19 do
				repeat
					local var_6_29 = var_6_18[iter_6_0][var_0_13]

					if not var_6_29 then
						break
					end

					local var_6_30 = var_0_0(var_6_29)

					if not HEALTH_ALIVE[var_6_30] then
						break
					end

					local var_6_31 = var_6_23[var_6_30]

					if var_6_31 and not var_6_22:is_enemy_by_side(var_6_26, var_6_31) then
						break
					end

					local var_6_32 = var_0_1(var_6_29)
					local var_6_33 = AiUtils.unit_breed(var_6_30)

					if not var_6_33 or var_6_21[var_6_33.name] then
						break
					end

					if var_6_33.is_player and not var_6_20 then
						break
					end

					local var_6_34 = var_6_33.hit_zones_lookup[var_6_32]

					if not var_6_34 or var_6_34.name == "afro" then
						break
					end

					if var_6_33.no_autoaim or var_6_28 and var_6_33.boss then
						break
					end

					if var_0_14(var_6_30) then
						break
					end

					local var_6_35 = var_6_27[var_6_33.name] or -1

					if var_6_35 > 0 and var_6_25 < var_6_35 then
						var_6_24 = var_6_30
						var_6_25 = var_6_35

						break
					end

					var_6_24 = var_6_24 or var_6_30
				until true
			end
		end

		if var_6_0.aim_sticky_target_size and POSITION_LOOKUP[var_6_3] and arg_6_0._is_sticky_target and var_6_25 <= arg_6_0._current_target_priority and var_0_7(POSITION_LOOKUP[var_6_3], var_6_15) < (var_6_24 and var_0_7(POSITION_LOOKUP[var_6_24], var_6_15) or math.huge) then
			local var_6_36 = var_0_3(var_6_3, "j_spine1") and var_0_4(var_6_3, "j_spine1") or 0
			local var_6_37 = var_0_6(var_6_3, var_6_36) - var_6_15
			local var_6_38 = var_0_8(var_6_37)
			local var_6_39 = var_6_38 > 0 and var_6_37 / var_6_38 or 0
			local var_6_40 = var_6_0.aim_sticky_target_size

			if math.cos(math.atan2(var_6_40, var_6_38)) < var_0_9(var_6_17, var_6_39) then
				var_6_24 = var_6_3
			else
				arg_6_0._is_sticky_target = false
			end
		end

		if var_6_24 then
			if arg_6_0.aimed_target ~= var_6_24 then
				arg_6_0.aimed_target = var_6_24
				arg_6_0.aim_timer = 0

				if ALIVE[var_6_24] and var_6_3 ~= var_6_24 then
					arg_6_0.target = var_6_24

					arg_6_0:_mark_target(var_6_24)

					arg_6_0.aim_sticky_timer = 0
					arg_6_0._is_sticky_target = var_6_25 > 0
					arg_6_0._current_target_priority = var_6_25
				end
			end
		elseif var_6_0.target_break_size and var_6_3 then
			local var_6_41 = var_0_3(var_6_3, "j_spine1") and var_0_4(var_6_3, "j_spine1") or 0
			local var_6_42 = var_0_6(var_6_3, var_6_41)
			local var_6_43, var_6_44 = Vector3.direction_length(var_6_42 - var_6_15)
			local var_6_45 = var_6_0.target_break_size

			if math.cos(math.atan2(var_6_45, var_6_44)) > var_0_9(var_6_17, var_6_43) then
				arg_6_0:_mark_target(nil)

				arg_6_0.target = nil
				arg_6_0.aimed_target = nil
			end
		end
	end

	arg_6_0.charge_value = math.min(math.max(arg_6_2 - var_6_2, 0) / arg_6_0.charge_time, 1)

	if not var_6_5 then
		local var_6_46 = var_6_0.charge_sound_parameter_name

		if var_6_46 then
			local var_6_47 = arg_6_0.wwise_world
			local var_6_48 = arg_6_0.wwise_source_id

			WwiseWorld.set_source_parameter(var_6_47, var_6_48, var_6_46, arg_6_0.charge_value)
		end

		if arg_6_0.charge_ready_sound_event and arg_6_0.charge_value >= 1 then
			arg_6_0.first_person_extension:play_hud_sound_event(arg_6_0.charge_ready_sound_event)

			arg_6_0.charge_ready_sound_event = nil
		end
	end

	arg_6_0.aim_timer = arg_6_0.aim_timer + arg_6_1
	arg_6_0.aim_sticky_timer = arg_6_0.aim_sticky_timer + arg_6_1
end

ActionTrueFlightBowAim._get_visible_targets = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.first_person_extension
	local var_7_1 = 50
	local var_7_2 = math.pi * 0.2
	local var_7_3, var_7_4 = var_7_0:get_projectile_start_position_rotation()
	local var_7_5 = Quaternion.forward(var_7_4)
	local var_7_6 = math.cos(var_7_2)
	local var_7_7 = {}
	local var_7_8 = FrameTable.alloc_table()
	local var_7_9 = AiUtils.broadphase_query(var_7_3, var_7_1, var_7_8, arg_7_0.target_broadphase_categories)

	if var_7_9 > 0 then
		for iter_7_0 = 1, var_7_9 do
			local var_7_10 = var_7_8[iter_7_0]

			if HEALTH_ALIVE[var_7_10] then
				local var_7_11 = var_0_5(var_7_10, "breed")

				if var_7_11 and not var_7_11.no_autoaim then
					local var_7_12 = Vector3.normalize(POSITION_LOOKUP[var_7_10] - var_7_3)

					if var_7_6 < Vector3.dot(var_7_5, var_7_12) and var_7_10 ~= arg_7_1 and not var_0_14(var_7_10) then
						var_7_7[#var_7_7 + 1] = var_7_10
					end
				end
			end
		end
	else
		var_7_7 = arg_7_0.targets

		for iter_7_1 = #var_7_7, 1, -1 do
			if not ALIVE[var_7_7[iter_7_1]] or var_0_14(var_7_7[iter_7_1]) then
				table.remove(var_7_7, iter_7_1)
			end
		end
	end

	TrueFlightUtility.sort_prioritize_specials(var_7_7)

	if arg_7_1 and not var_0_14(arg_7_1) then
		table.insert(var_7_7, 1, arg_7_1)
	end

	return var_7_7
end

ActionTrueFlightBowAim.finish = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.current_action
	local var_8_1 = arg_8_0.owner_unit
	local var_8_2 = var_8_0.unzoom_condition_function

	if arg_8_0.spread_extension then
		arg_8_0.spread_extension:reset_spread_template()
	end

	if not var_8_2 or var_8_2(arg_8_1) then
		ScriptUnit.extension(var_8_1, "status_system"):set_zooming(false)
	end

	local var_8_3 = var_8_0.unaim_sound_event

	if var_8_3 then
		local var_8_4 = arg_8_0.wwise_world

		WwiseWorld.trigger_event(var_8_4, var_8_3)
	end

	local var_8_5 = {}

	if var_8_0.num_projectiles and var_8_0.num_projectiles > 1 then
		local var_8_6 = Managers.player:owner(var_8_1)
		local var_8_7 = var_8_6 and var_8_6.bot_player

		var_8_5.targets = arg_8_0:_get_visible_targets(arg_8_0.target, var_8_0.num_projectiles, var_8_7)
	end

	var_8_5.target = arg_8_0.target

	arg_8_0:_stop_charge_sound()
	arg_8_0:_mark_target(nil)

	arg_8_0.targets = nil
	arg_8_0.target = nil

	ScriptUnit.extension(var_8_1, "inventory_system"):set_loaded_projectile_override(nil)

	return var_8_5
end

ActionTrueFlightBowAim._mark_target = function (arg_9_0, arg_9_1)
	if arg_9_0.is_bot then
		return
	end

	if arg_9_0.current_action.weapon_mode_target_swap then
		if arg_9_1 then
			arg_9_0._weapon_extension:set_mode(true)
		else
			arg_9_0._weapon_extension:set_mode(false)
		end
	end

	local var_9_0 = arg_9_0._marked_target

	if var_9_0.outline_extension then
		var_9_0.outline_extension:remove_outline(var_9_0.outline_id)

		var_9_0.outline_extension = nil
		var_9_0.outline_id = nil
	end

	if arg_9_1 and ALIVE[arg_9_1] then
		local var_9_1 = ScriptUnit.has_extension(arg_9_0.target, "outline_system")

		if var_9_1 then
			var_9_0.outline_extension = var_9_1
			var_9_0.outline_id = var_9_1:add_outline(OutlineSettings.templates.target_enemy)
		end
	end
end
