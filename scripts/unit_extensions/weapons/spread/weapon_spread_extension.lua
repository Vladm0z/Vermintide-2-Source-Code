-- chunkname: @scripts/unit_extensions/weapons/spread/weapon_spread_extension.lua

require("scripts/unit_extensions/weapons/spread/spread_templates")

WeaponSpreadExtension = class(WeaponSpreadExtension)

function WeaponSpreadExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.owner_unit = arg_1_3.owner_unit

	local var_1_0 = arg_1_3.item_name

	arg_1_0.item_name = var_1_0

	local var_1_1 = ItemMasterList[var_1_0]
	local var_1_2 = BackendUtils.get_item_template(var_1_1)

	arg_1_0.default_spread_template_name = var_1_2.default_spread_template
	arg_1_0.spread_lerp_speed_pitch = var_1_2.spread_lerp_speed_pitch or var_1_2.spread_lerp_speed or 4
	arg_1_0.spread_lerp_speed_yaw = var_1_2.spread_lerp_speed_yaw or var_1_2.spread_lerp_speed or 4
	arg_1_0.spread_lerp_speed_pitch_zoom = var_1_2.spread_lerp_speed_pitch_zoom or var_1_2.spread_lerp_speed_zoom or var_1_2.spread_lerp_speed or 4
	arg_1_0.spread_lerp_speed_yaw_zoom = var_1_2.spread_lerp_speed_yaw_zoom or var_1_2.spread_lerp_speed_zoom or var_1_2.spread_lerp_speed or 4
	arg_1_0.spread_settings = SpreadTemplates[arg_1_0.default_spread_template_name]
	arg_1_0.current_state = "still"
	arg_1_0.current_yaw = 0
	arg_1_0.current_pitch = 0
	arg_1_0.shooting = false
	arg_1_0.hit_aftermath = false
	arg_1_0.hit_timer = 0
end

function WeaponSpreadExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.owner_unit

	arg_2_0.owner_health_extension = ScriptUnit.extension(var_2_0, "health_system")
	arg_2_0.owner_status_extension = ScriptUnit.extension(var_2_0, "status_system")
	arg_2_0.owner_buff_extension = ScriptUnit.extension(var_2_0, "buff_system")
	arg_2_0.owner_locomotion_extension = ScriptUnit.extension(var_2_0, "locomotion_system")
end

function WeaponSpreadExtension.destroy(arg_3_0)
	return
end

local var_0_0 = {
	temporary_health_degen = true,
	buff_shared_medpack_temp_health = true,
	buff_shared_medpack = true,
	buff = true,
	warpfire_ground = true,
	life_tap = true,
	health_degen = true,
	vomit_ground = true,
	wounded_dot = true,
	heal = true,
	life_drain = true
}

function WeaponSpreadExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.current_pitch
	local var_4_1 = arg_4_0.current_yaw
	local var_4_2 = arg_4_0.current_state
	local var_4_3 = arg_4_0.spread_settings.continuous[var_4_2]
	local var_4_4 = arg_4_0.owner_buff_extension
	local var_4_5 = var_4_4:apply_buffs_to_value(var_4_3.max_pitch, "reduced_spread")
	local var_4_6 = var_4_4:apply_buffs_to_value(var_4_3.max_yaw, "reduced_spread")
	local var_4_7 = arg_4_0.owner_status_extension
	local var_4_8 = arg_4_0.owner_locomotion_extension
	local var_4_9 = CharacterStateHelper.is_moving(var_4_8)
	local var_4_10 = CharacterStateHelper.is_crouching(var_4_7)
	local var_4_11 = CharacterStateHelper.is_zooming(var_4_7)
	local var_4_12
	local var_4_13 = var_4_11 and arg_4_0.spread_lerp_speed_pitch_zoom or arg_4_0.spread_lerp_speed_pitch
	local var_4_14 = var_4_11 and arg_4_0.spread_lerp_speed_yaw_zoom or arg_4_0.spread_lerp_speed_yaw

	if arg_4_0.hit_aftermath then
		arg_4_0.hit_timer = arg_4_0.hit_timer - arg_4_3

		local var_4_15 = Math.random(0.5, 1)

		var_4_13 = var_4_15
		var_4_14 = var_4_15

		if arg_4_0.hit_timer <= 0 then
			arg_4_0.hit_aftermath = false
		end
	end

	local var_4_16 = var_4_9 and (var_4_10 and (var_4_11 and "zoomed_crouch_moving" or "crouch_moving") or var_4_11 and "zoomed_moving" or "moving") or var_4_10 and (var_4_11 and "zoomed_crouch_still" or "crouch_still") or var_4_11 and "zoomed_still" or "still"

	if var_4_9 then
		var_4_5 = var_4_4:apply_buffs_to_value(var_4_5, "reduced_spread_moving")
		var_4_6 = var_4_4:apply_buffs_to_value(var_4_6, "reduced_spread_moving")
	end

	local var_4_17 = math.lerp(var_4_0, var_4_5, arg_4_3 * var_4_13)
	local var_4_18 = math.lerp(var_4_1, var_4_6, arg_4_3 * var_4_14)

	if var_4_2 ~= var_4_16 then
		arg_4_0.current_state = var_4_16
	end

	local var_4_19 = arg_4_0.spread_settings.immediate
	local var_4_20 = 0
	local var_4_21 = 0
	local var_4_22 = arg_4_0.owner_health_extension:recently_damaged()

	if var_4_22 and not var_0_0[var_4_22] then
		local var_4_23 = var_4_19.being_hit

		var_4_20 = var_4_4:apply_buffs_to_value(var_4_23.immediate_pitch, "reduced_spread_hit")
		var_4_21 = var_4_4:apply_buffs_to_value(var_4_23.immediate_yaw, "reduced_spread_hit")
		arg_4_0.hit_aftermath = true
		arg_4_0.hit_timer = 1.5
	end

	if arg_4_0.shooting then
		local var_4_24 = var_4_19.shooting

		var_4_20 = var_4_4:apply_buffs_to_value(var_4_24.immediate_pitch, "reduced_spread_shot")
		var_4_21 = var_4_4:apply_buffs_to_value(var_4_24.immediate_yaw, "reduced_spread_shot")
		arg_4_0.shooting = false
	end

	local var_4_25 = var_4_17 + var_4_20
	local var_4_26 = var_4_18 + var_4_21

	arg_4_0.current_pitch = math.min(var_4_25, SpreadTemplates.maximum_pitch)
	arg_4_0.current_yaw = math.min(var_4_26, SpreadTemplates.maximum_yaw)
end

function WeaponSpreadExtension.set_shooting(arg_5_0)
	arg_5_0.shooting = true
end

function WeaponSpreadExtension.combine_spread_rotations(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = Quaternion(Vector3.forward(), arg_6_1)
	local var_6_1 = Quaternion(Vector3.right(), arg_6_2)
	local var_6_2 = Quaternion.multiply(arg_6_3, var_6_0)

	return (Quaternion.multiply(var_6_2, var_6_1))
end

function WeaponSpreadExtension.get_max_pitch_rotation(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.current_pitch
	local var_7_1 = arg_7_0.current_yaw
	local var_7_2 = var_7_1 * math.cos(arg_7_1)
	local var_7_3 = var_7_0 * math.sin(arg_7_1)
	local var_7_4 = Vector3.length(Vector3(var_7_2, var_7_3, 0))

	if var_7_4 < 1e-05 then
		return 0
	end

	local var_7_5 = var_7_0 * var_7_1 / var_7_4

	return math.degrees_to_radians(var_7_5)
end

function WeaponSpreadExtension.get_current_pitch_and_yaw(arg_8_0)
	return arg_8_0.current_pitch, arg_8_0.current_yaw
end

function WeaponSpreadExtension.override_spread_template(arg_9_0, arg_9_1)
	arg_9_0.spread_settings = SpreadTemplates[arg_9_1]

	local var_9_0 = arg_9_0.current_state
	local var_9_1 = arg_9_0.spread_settings.continuous[var_9_0]

	arg_9_0.current_pitch = var_9_1.max_pitch
	arg_9_0.current_yaw = var_9_1.max_yaw
end

function WeaponSpreadExtension.reset_spread_template(arg_10_0)
	arg_10_0.spread_settings = SpreadTemplates[arg_10_0.default_spread_template_name]
end

function WeaponSpreadExtension.get_randomised_spread(arg_11_0, arg_11_1)
	local var_11_0 = math.random() * math.pi * 2
	local var_11_1 = math.random() * arg_11_0:get_max_pitch_rotation(var_11_0)

	return (arg_11_0:combine_spread_rotations(var_11_0, var_11_1, arg_11_1))
end

function WeaponSpreadExtension.get_target_style_spread(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	if arg_12_5 and arg_12_1 == 1 then
		return arg_12_3
	end

	local var_12_0 = arg_12_5 and arg_12_1 - 1 or arg_12_1
	local var_12_1 = arg_12_5 and arg_12_2 - 1 or arg_12_2
	local var_12_2 = arg_12_4 or 1
	local var_12_3 = var_12_2 * (var_12_0 / var_12_1)
	local var_12_4 = var_12_2 / var_12_1
	local var_12_5 = ((0.85 + 0.3 * math.random()) * var_12_4 * 2 + var_12_3 - var_12_4) * (math.pi * 2)
	local var_12_6 = arg_12_0:get_max_pitch_rotation(var_12_5)
	local var_12_7 = math.sqrt(0.25 + 0.5 * math.random())

	if var_12_2 == 2 and var_12_0 <= var_12_1 / var_12_2 then
		var_12_7 = var_12_7 * ((arg_12_6 or 0.8) / 2)
	else
		var_12_7 = var_12_7 * (arg_12_6 or 0.8)
	end

	local var_12_8 = var_12_7 * var_12_6

	return (arg_12_0:combine_spread_rotations(var_12_5, var_12_8, arg_12_3))
end
