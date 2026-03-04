-- chunkname: @scripts/unit_extensions/smart_targeting/player_unit_smart_targeting_extension.lua

local var_0_0 = POSITION_LOOKUP
local var_0_1 = false
local var_0_2 = false
local var_0_3 = false
local var_0_4 = 0.1
local var_0_5 = 8
local var_0_6 = true

PlayerUnitSmartTargetingExtension = class(PlayerUnitSmartTargetingExtension)

function PlayerUnitSmartTargetingExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.conflict_manager = Managers.state.conflict
	arg_1_0.player = arg_1_3.player

	local var_1_0 = arg_1_3.side

	arg_1_0._target_broadphase_categories = var_1_0 and var_1_0.enemy_broadphase_categories
	arg_1_0.targeting_data = {}
	arg_1_0.move_time = 0
	arg_1_0.clicking = false
	arg_1_0.target_unit = nil
	arg_1_0._gui = World.create_screen_gui(arg_1_0.world, "immediate")
	arg_1_0.use_score_modifiers_1 = true
	arg_1_0.score_modifiers_1 = {}
	arg_1_0.score_modifiers_2 = {}
end

function PlayerUnitSmartTargetingExtension.extensions_ready(arg_2_0)
	local var_2_0 = arg_2_0.unit

	arg_2_0.first_person_extension = ScriptUnit.extension(var_2_0, "first_person_system")
	arg_2_0.status_extension = ScriptUnit.extension(var_2_0, "status_system")
	arg_2_0.inventory_extension = ScriptUnit.extension(var_2_0, "inventory_system")
	arg_2_0.input_extension = ScriptUnit.extension(var_2_0, "input_system")
end

local var_0_7 = {}
local var_0_8 = {}
local var_0_9 = {}

function PlayerUnitSmartTargetingExtension.update_opt2(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if var_0_3 then
		return
	end

	table.clear(arg_3_0.targeting_data)

	local var_3_0 = Unit.get_data
	local var_3_1 = ScriptUnit.has_extension
	local var_3_2 = math.min
	local var_3_3 = RESOLUTION_LOOKUP.res_w
	local var_3_4 = RESOLUTION_LOOKUP.res_h
	local var_3_5 = var_3_3 / 2
	local var_3_6 = var_3_4 / 2
	local var_3_7 = 8 * (var_3_3 / 1280)
	local var_3_8 = arg_3_0.input_extension
	local var_3_9 = arg_3_0.first_person_extension
	local var_3_10 = arg_3_0.inventory_extension
	local var_3_11 = arg_3_0:_get_player_camera()
	local var_3_12 = var_3_9:current_position()
	local var_3_13 = var_3_9:current_rotation()
	local var_3_14 = Quaternion.forward(var_3_13)
	local var_3_15 = Quaternion.right(var_3_13)
	local var_3_16
	local var_3_17 = var_3_10:equipment()
	local var_3_18 = var_3_17.right_hand_wielded_unit or var_3_17.left_hand_wielded_unit

	if Unit.alive(var_3_18) then
		local var_3_19 = ScriptUnit.extension(var_3_18, "weapon_system")

		if var_3_19:has_current_action() then
			var_3_16 = var_3_19:get_current_action_settings()
		end
	end

	local var_3_20 = var_3_10:get_wielded_slot_item_template()
	local var_3_21

	if var_3_16 and var_3_16.aim_assist_settings then
		var_3_21 = var_3_16.aim_assist_settings
	else
		var_3_21 = var_3_20 and var_3_20.aim_assist_settings
	end

	local var_3_22 = var_3_10:get_loaded_projectile_settings()
	local var_3_23 = var_3_22 and var_3_22.speed or 0
	local var_3_24 = var_3_22 and var_3_22.drop_multiplier or 0
	local var_3_25 = var_0_1 and arg_3_0._gui or nil
	local var_3_26 = Managers.input:is_device_active("gamepad")
	local var_3_27 = not Application.user_setting("gamepad_auto_aim_enabled")

	if not var_3_21 or var_3_26 and var_3_27 then
		return
	end

	local var_3_28 = var_3_21.max_range
	local var_3_29 = var_3_21.effective_max_range
	local var_3_30 = Managers.state.entity:system("ai_system").broadphase

	table.clear(var_0_7)
	table.clear(var_0_8)
	table.clear(var_0_9)

	local var_3_31 = EngineOptimized.smart_targeting_query(var_3_30, var_3_12, var_3_14, 1.5, var_3_28, 0.1, 0.2, 0.8, 5, var_0_7, var_0_8, var_0_9, arg_3_0._target_broadphase_categories)
	local var_3_32 = 0
	local var_3_33
	local var_3_34 = 0
	local var_3_35
	local var_3_36

	if arg_3_0.use_score_modifiers_1 then
		var_3_35 = arg_3_0.score_modifiers_1
		var_3_36 = arg_3_0.score_modifiers_2
	else
		var_3_35 = arg_3_0.score_modifiers_2
		var_3_36 = arg_3_0.score_modifiers_1
	end

	local var_3_37 = false
	local var_3_38 = 0.8

	for iter_3_0 = 1, var_3_31 do
		repeat
			local var_3_39 = var_0_7[iter_3_0]

			if not HEALTH_ALIVE[var_3_39] then
				break
			end

			local var_3_40 = var_3_0(var_3_39, "breed")
			local var_3_41 = var_3_40.smart_targeting_width

			if var_3_40.no_autoaim or not var_3_41 then
				break
			end

			var_3_37 = true

			local var_3_42 = var_3_21.breed_scalars[var_3_40.name] or 1

			if var_3_42 == 0 then
				break
			end

			local var_3_43 = var_0_8[iter_3_0]
			local var_3_44 = var_0_9[iter_3_0]
			local var_3_45 = var_3_40.smart_targeting_outer_width or var_3_41 * 2
			local var_3_46 = var_3_40.smart_targeting_height_multiplier or 1
			local var_3_47 = var_3_1(var_3_39, "locomotion_system")
			local var_3_48 = var_3_47 and var_3_47:current_velocity() or Vector3(0, 0, 0)
			local var_3_49 = EngineOptimized.smart_targeting_optimized(var_3_11, var_3_43, var_3_15, var_3_44, var_3_29, var_3_38, var_3_28, var_3_7, var_3_5, var_3_6, var_3_41, var_3_45, var_3_46, (var_3_23 or 0) * 0.01, var_3_24, var_3_48, var_3_25)
			local var_3_50 = var_3_36[var_3_39] or 0.1
			local var_3_51 = var_3_42 * var_3_49 * var_3_50

			if var_3_32 < var_3_51 then
				var_3_32 = var_3_51
				var_3_33 = var_3_39
				var_3_34 = var_3_49
			end

			if var_3_51 > 0 then
				var_3_35[var_3_39] = var_3_2(var_3_50 + arg_3_3 * 2, 1)
			end
		until true
	end

	table.clear(var_3_36)

	arg_3_0.use_score_modifiers_1 = not arg_3_0.use_score_modifiers_1

	local var_3_52

	if var_3_33 then
		local var_3_53, var_3_54 = arg_3_0:get_target_visibility_and_aim_position(var_3_33, var_3_12, var_3_21)

		var_3_52 = var_3_54

		if not var_3_53 then
			var_3_33 = nil
			var_3_34 = nil
			var_3_52 = nil
		end
	end

	local var_3_55 = arg_3_0.targeting_data

	var_3_55.unit = var_3_33
	var_3_55.aim_score = var_3_34

	if var_3_52 then
		var_3_55.target_position = var_3_52
	end

	var_3_55.targets_within_range = var_3_37
end

function PlayerUnitSmartTargetingExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if var_0_6 then
		arg_4_0:update_opt2(arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)

		return
	end

	if var_0_3 then
		return
	end

	table.clear(arg_4_0.targeting_data)

	local var_4_0 = Unit.node
	local var_4_1 = Unit.world_position
	local var_4_2 = Camera.world_to_screen
	local var_4_3 = Unit.get_data
	local var_4_4 = Quaternion.right
	local var_4_5 = Quaternion.forward
	local var_4_6 = Vector3.length
	local var_4_7 = ScriptUnit.extension
	local var_4_8 = Vector3.flat
	local var_4_9 = Vector3.dot
	local var_4_10 = Vector3.normalize
	local var_4_11 = RESOLUTION_LOOKUP.res_w
	local var_4_12 = RESOLUTION_LOOKUP.res_h
	local var_4_13 = var_4_11 / 2
	local var_4_14 = var_4_12 / 2
	local var_4_15 = arg_4_0.input_extension
	local var_4_16 = arg_4_0.first_person_extension
	local var_4_17 = arg_4_0.inventory_extension
	local var_4_18 = arg_4_0:_get_player_camera()
	local var_4_19 = var_4_16:current_position()
	local var_4_20 = var_4_16:current_rotation()
	local var_4_21 = var_4_5(var_4_20)
	local var_4_22
	local var_4_23 = var_4_17:equipment()
	local var_4_24 = var_4_23.right_hand_wielded_unit or var_4_23.left_hand_wielded_unit

	if Unit.alive(var_4_24) then
		local var_4_25 = ScriptUnit.extension(var_4_24, "weapon_system")

		if var_4_25:has_current_action() then
			var_4_22 = var_4_25:get_current_action_settings()
		end
	end

	local var_4_26

	if var_4_22 and var_4_22.aim_assist_settings then
		var_4_26 = var_4_22.aim_assist_settings
	else
		var_4_26 = weapon_template and weapon_template.aim_assist_settings
	end

	local var_4_27 = var_4_17:get_wielded_slot_item_template()
	local var_4_28 = var_4_17:get_loaded_projectile_settings()
	local var_4_29 = Managers.input:is_device_active("gamepad")
	local var_4_30 = not Application.user_setting("gamepad_auto_aim_enabled")

	if not var_4_26 or var_4_29 and var_4_30 then
		return
	end

	local var_4_31 = var_4_26.max_range
	local var_4_32 = var_4_26.effective_max_range
	local var_4_33 = Managers.state.entity:system("ai_system").broadphase

	table.clear(var_0_7)

	local var_4_34 = Broadphase.query(var_4_33, var_4_19, var_4_31, var_0_7, arg_4_0._target_broadphase_categories)
	local var_4_35 = 0
	local var_4_36
	local var_4_37 = 0
	local var_4_38
	local var_4_39

	if arg_4_0.use_score_modifiers_1 then
		var_4_38 = arg_4_0.score_modifiers_1
		var_4_39 = arg_4_0.score_modifiers_2
	else
		var_4_38 = arg_4_0.score_modifiers_2
		var_4_39 = arg_4_0.score_modifiers_1
	end

	local var_4_40 = false

	for iter_4_0 = 1, var_4_34 do
		repeat
			local var_4_41 = var_0_7[iter_4_0]

			if not HEALTH_ALIVE[var_4_41] then
				break
			end

			local var_4_42 = var_4_3(var_4_41, "breed")
			local var_4_43 = var_4_42.smart_targeting_width

			if var_4_42.no_autoaim or not var_4_43 then
				break
			end

			var_4_40 = true

			local var_4_44 = var_4_26.breed_scalars[var_4_42.name] or 1

			if var_4_44 == 0 then
				break
			end

			local var_4_45 = var_4_0(var_4_41, "j_hips")
			local var_4_46 = var_4_1(var_4_41, var_4_45)
			local var_4_47 = var_4_46 - var_4_19

			if var_4_9(var_4_21, var_4_10(var_4_47)) < 0.5 then
				break
			end

			local var_4_48 = 1
			local var_4_49 = 0.8
			local var_4_50 = var_4_6(var_4_47)

			if var_4_50 < 1.5 then
				break
			elseif var_4_50 <= var_4_32 then
				var_4_48 = (1 - var_4_50 / var_4_32) * (1 - var_4_49) + var_4_49
			else
				var_4_48 = (1 - (var_4_50 - var_4_32) / (var_4_31 - var_4_32)) * var_4_49
			end

			local var_4_51 = var_4_42.smart_targeting_outer_width or var_4_43 * 2
			local var_4_52 = var_4_42.smart_targeting_height_multiplier or 1
			local var_4_53 = var_4_7(var_4_41, "locomotion_system")
			local var_4_54 = var_4_28 and var_4_28.speed
			local var_4_55 = Vector3.zero()

			if var_4_54 then
				local var_4_56 = var_4_53 and var_4_53:current_velocity() or Vector3(0, 0, 0)

				var_4_55 = var_4_8(var_4_56) * (var_4_50 / (var_4_54 * 0.01))
				var_4_55.z = var_4_55.z + var_4_50 * (var_4_28.drop_multiplier or 0)
			end

			local var_4_57 = var_4_46 + var_4_4(var_4_20) * var_4_43 + var_4_55
			local var_4_58 = var_4_46 + var_4_4(var_4_20) * var_4_51 + var_4_55
			local var_4_59 = var_4_2(var_4_18, var_4_46 + var_4_55)
			local var_4_60 = var_4_2(var_4_18, var_4_57)
			local var_4_61 = var_4_2(var_4_18, var_4_58)
			local var_4_62 = 8 * (var_4_11 / 1280)
			local var_4_63 = math.max(var_4_6(var_4_60 - var_4_59), var_4_62)
			local var_4_64 = math.max(var_4_6(var_4_61 - var_4_59), var_4_62 * (var_4_51 / var_4_43))
			local var_4_65 = var_4_63 * var_4_52
			local var_4_66 = math.abs(var_4_64 - var_4_63)
			local var_4_67 = var_4_59.x - var_4_63
			local var_4_68 = var_4_59.x + var_4_63
			local var_4_69 = var_4_59.y - var_4_65
			local var_4_70 = var_4_59.y + var_4_65
			local var_4_71 = var_4_67 - var_4_66
			local var_4_72 = var_4_68 + var_4_66
			local var_4_73 = var_4_69 - var_4_66
			local var_4_74 = var_4_70 + var_4_66

			if var_0_1 then
				Gui.rect(arg_4_0._gui, Vector3(var_4_67, var_4_69, 800), Vector2(var_4_63 * 2, var_4_65 * 2), Color(90, 0, 200, 200))
				Gui.rect(arg_4_0._gui, Vector3(var_4_71, var_4_73, 800), Vector2(var_4_72 - var_4_71, var_4_74 - var_4_73), Color(90, 200, 200, 0))
			end

			local var_4_75 = 0
			local var_4_76 = 0

			if var_4_71 < var_4_13 and var_4_13 < var_4_72 and var_4_73 < var_4_14 and var_4_14 < var_4_74 then
				if var_4_13 <= var_4_59.x then
					var_4_75 = math.min((var_4_13 - var_4_71) / var_4_66, 1)
				else
					var_4_75 = math.min((var_4_72 - var_4_13) / var_4_66, 1)
				end

				if var_4_14 <= var_4_59.y then
					var_4_76 = math.min((var_4_14 - var_4_73) / var_4_66, 1)
				else
					var_4_76 = math.min((var_4_74 - var_4_14) / var_4_66, 1)
				end
			end

			local var_4_77 = var_4_39[var_4_41] or 0.1
			local var_4_78 = var_4_75 * var_4_76
			local var_4_79 = var_4_44 * var_4_78 * var_4_48 * var_4_77

			if var_4_35 < var_4_79 then
				var_4_35 = var_4_79
				var_4_36 = var_4_41
				var_4_37 = var_4_78
			end

			if var_4_79 > 0 then
				var_4_38[var_4_41] = math.min(var_4_77 + arg_4_3 * 2, 1)
			end
		until true
	end

	table.clear(var_4_39)

	arg_4_0.use_score_modifiers_1 = not arg_4_0.use_score_modifiers_1

	local var_4_80

	if var_4_36 then
		local var_4_81, var_4_82 = arg_4_0:get_target_visibility_and_aim_position(var_4_36, var_4_19, var_4_26)

		var_4_80 = var_4_82

		if not var_4_81 then
			var_4_36 = nil
			var_4_37 = nil
			var_4_80 = nil
		end
	end

	local var_4_83 = arg_4_0.targeting_data

	var_4_83.unit = var_4_36
	var_4_83.aim_score = var_4_37
	var_4_83.target_position = var_4_80
	var_4_83.targets_within_range = var_4_40
end

function PlayerUnitSmartTargetingExtension._get_player_camera(arg_5_0)
	local var_5_0 = arg_5_0.player.viewport_name
	local var_5_1 = ScriptWorld.viewport(arg_5_0.world, var_5_0)

	return (ScriptViewport.camera(var_5_1))
end

function PlayerUnitSmartTargetingExtension.get_target_visibility_and_aim_position(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_3.target_node or "j_spine1"
	local var_6_1 = Unit.node(arg_6_1, var_6_0)
	local var_6_2 = Unit.world_position(arg_6_1, var_6_1)
	local var_6_3 = Unit.node(arg_6_1, "j_hips")
	local var_6_4 = Unit.world_position(arg_6_1, var_6_3)
	local var_6_5 = Vector3.normalize(var_6_2 - arg_6_2)
	local var_6_6 = Vector3.length(var_6_2 - arg_6_2)
	local var_6_7 = Vector3.normalize(var_6_4 - arg_6_2)
	local var_6_8 = Vector3.length(var_6_4 - arg_6_2)
	local var_6_9 = World.physics_world(arg_6_0.world)
	local var_6_10 = not PhysicsWorld.immediate_raycast(var_6_9, arg_6_2, var_6_5, var_6_6, "closest", "collision_filter", "filter_ray_aim_assist")
	local var_6_11 = var_6_2

	if not var_6_10 then
		var_6_10 = not PhysicsWorld.immediate_raycast(var_6_9, arg_6_2, var_6_7, var_6_8, "closest", "collision_filter", "filter_ray_aim_assist")
		var_6_11 = var_6_4
	end

	return var_6_10, var_6_11
end

function PlayerUnitSmartTargetingExtension.get_targeting_data(arg_7_0)
	return arg_7_0.targeting_data
end
