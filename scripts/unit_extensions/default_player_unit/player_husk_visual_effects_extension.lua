-- chunkname: @scripts/unit_extensions/default_player_unit/player_husk_visual_effects_extension.lua

PlayerHuskVisualEffectsExtension = class(PlayerHuskVisualEffectsExtension)

local var_0_0 = Unit.set_flow_variable
local var_0_1 = Unit.flow_event

function PlayerHuskVisualEffectsExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.overcharge_threshold_changed = true
end

function PlayerHuskVisualEffectsExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.inventory_extension = ScriptUnit.extension(arg_2_2, "inventory_system")
	arg_2_0.overcharge_extension = ScriptUnit.extension(arg_2_2, "overcharge_system")

	local var_2_0 = ScriptUnit.extension(arg_2_2, "cosmetic_system")

	arg_2_0.cosmetic_extension = var_2_0
	arg_2_0.third_person_mesh_unit = var_2_0:get_third_person_mesh_unit()
end

function PlayerHuskVisualEffectsExtension.destroy(arg_3_0)
	return
end

function PlayerHuskVisualEffectsExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0:_update_overcharge_thresholds()
	arg_4_0:_set_overcharge_flow_values()
	arg_4_0:_set_weapons_energy_drainable()
end

function PlayerHuskVisualEffectsExtension._update_overcharge_thresholds(arg_5_0)
	local var_5_0, var_5_1, var_5_2 = arg_5_0.overcharge_extension:current_overcharge_status()

	if arg_5_0.above_overcharge_threshold and var_5_0 < var_5_1 then
		arg_5_0.above_overcharge_threshold = false
		arg_5_0.overcharge_threshold_changed = true
	elseif not arg_5_0.above_overcharge_threshold and var_5_1 <= var_5_0 then
		arg_5_0.above_overcharge_threshold = true
		arg_5_0.overcharge_threshold_changed = true
	else
		arg_5_0.overcharge_threshold_changed = false
	end
end

function PlayerHuskVisualEffectsExtension._set_overcharge_flow_values(arg_6_0)
	local var_6_0 = arg_6_0.overcharge_extension:get_anim_blend_overcharge()

	if arg_6_0._last_anim_blend_overcharge ~= var_6_0 then
		arg_6_0._last_anim_blend_overcharge = var_6_0

		arg_6_0:_set_character_overcharge(var_6_0)
		arg_6_0:_set_weapons_overcharge(var_6_0)
	end

	if arg_6_0.overcharge_threshold_changed then
		arg_6_0:_set_character_overcharge_threshold()
		arg_6_0:_set_weapons_overcharge_threshold()

		arg_6_0.overcharge_threshold_changed = false
	end
end

function PlayerHuskVisualEffectsExtension._set_character_overcharge(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.unit

	if var_7_0 and Unit.alive(var_7_0) then
		var_0_0(var_7_0, "current_overcharge", arg_7_1)
		var_0_1(var_7_0, "lua_update_overcharge")
	end

	local var_7_1 = arg_7_0.third_person_mesh_unit

	if var_7_1 and Unit.alive(var_7_1) then
		var_0_0(var_7_1, "current_overcharge", arg_7_1)
		var_0_1(var_7_1, "lua_update_overcharge")
	end
end

function PlayerHuskVisualEffectsExtension._set_weapons_energy_drainable(arg_8_0)
	local var_8_0 = arg_8_0.inventory_extension:equipment()
	local var_8_1 = arg_8_0.unit
	local var_8_2 = var_8_1 and ScriptUnit.has_extension(var_8_1, "energy_system")

	if var_8_0 and var_8_2 then
		local var_8_3 = var_8_2:is_drainable()
		local var_8_4 = var_8_0.left_hand_wielded_unit_3p
		local var_8_5 = var_8_0.left_hand_ammo_unit_3p
		local var_8_6 = var_8_0.right_hand_wielded_unit_3p
		local var_8_7 = var_8_0.right_hand_ammo_unit_3p

		if var_8_4 and Unit.alive(var_8_4) then
			var_0_0(var_8_4, "is_energy_drainable", var_8_3)
		end

		if var_8_5 and Unit.alive(var_8_5) then
			var_0_0(var_8_5, "is_energy_drainable", var_8_3)
		end

		if var_8_6 and Unit.alive(var_8_6) then
			var_0_0(var_8_6, "is_energy_drainable", var_8_3)
		end

		if var_8_7 and Unit.alive(var_8_7) then
			var_0_0(var_8_7, "is_energy_drainable", var_8_3)
		end
	end
end

function PlayerHuskVisualEffectsExtension._set_character_overcharge_threshold(arg_9_0)
	local var_9_0 = arg_9_0.unit
	local var_9_1 = arg_9_0.third_person_mesh_unit
	local var_9_2 = "below_overcharge_threshold"

	if arg_9_0.above_overcharge_threshold then
		var_9_2 = "above_overcharge_threshold"
	end

	if var_9_0 and Unit.alive(var_9_0) then
		var_0_1(var_9_0, var_9_2)
	end

	if var_9_1 and Unit.alive(var_9_1) then
		var_0_1(var_9_1, var_9_2)
	end
end

function PlayerHuskVisualEffectsExtension._set_weapons_overcharge(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.inventory_extension:equipment()

	if var_10_0 then
		local var_10_1 = var_10_0.left_hand_wielded_unit_3p
		local var_10_2 = var_10_0.right_hand_wielded_unit_3p

		if var_10_1 and Unit.alive(var_10_1) then
			var_0_0(var_10_1, "current_overcharge", arg_10_1)
			var_0_1(var_10_1, "lua_update_overcharge")
		end

		if var_10_2 and Unit.alive(var_10_2) then
			var_0_0(var_10_2, "current_overcharge", arg_10_1)
			var_0_1(var_10_2, "lua_update_overcharge")
		end
	end
end

function PlayerHuskVisualEffectsExtension._set_weapons_overcharge_threshold(arg_11_0)
	local var_11_0 = arg_11_0.inventory_extension:equipment()

	if var_11_0 then
		local var_11_1 = "below_overcharge_threshold"

		if arg_11_0.above_overcharge_threshold then
			var_11_1 = "above_overcharge_threshold"
		end

		local var_11_2 = var_11_0.left_hand_wielded_unit_3p
		local var_11_3 = var_11_0.right_hand_wielded_unit_3p

		if var_11_2 and Unit.alive(var_11_2) then
			var_0_1(var_11_2, var_11_1)
		end

		if var_11_3 and Unit.alive(var_11_3) then
			var_0_1(var_11_3, var_11_1)
		end
	end
end
