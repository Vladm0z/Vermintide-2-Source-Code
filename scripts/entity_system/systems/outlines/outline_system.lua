-- chunkname: @scripts/entity_system/systems/outlines/outline_system.lua

require("scripts/settings/outline_settings")
require("scripts/unit_extensions/outline/outline_extension")

OutlineSystem = class(OutlineSystem, ExtensionSystemBase)
OutlineSystem.system_extensions = {
	"AIOutlineExtension",
	"PickupOutlineExtension",
	"PlayerHuskOutlineExtension",
	"PlayerOutlineExtension",
	"MinionOutlineExtension",
	"DoorOutlineExtension",
	"ObjectiveOutlineExtension",
	"ObjectiveLightOutlineExtension",
	"ObjectiveLargeOutlineExtension",
	"ElevatorOutlineExtension",
	"ConditionalInteractOutlineExtension",
	"ConditionalPickupOutlineExtension",
	"EnemyOutlineExtension",
	"GenericOutlineExtension",
	"SmallPickupOutlineExtension",
	"SmallDoorOutlineExtension"
}
OutlineSystem.system_extensions[#OutlineSystem.system_extensions + 1] = "DarkPactPlayerOutlineExtension"
OutlineSystem.system_extensions[#OutlineSystem.system_extensions + 1] = "DarkPactPlayerHuskOutlineExtension"

OutlineSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = OutlineSystem.system_extensions

	OutlineSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_1_0)

	arg_1_0.world = arg_1_1.world
	arg_1_0.physics_world = World.get_data(arg_1_0.world, "physics_world")
	arg_1_0.unit_extension_data = {}
	arg_1_0.frozen_unit_extension_data = {}
	arg_1_0.units = {}
	arg_1_0._initial_outline_data = {}
	arg_1_0.current_index = 0
	arg_1_0.darkness_system = Managers.state.entity:system("darkness_system")
	arg_1_0.cutscene_system = Managers.state.entity:system("cutscene_system")

	local var_1_1 = Managers.state.game_mode

	arg_1_0._game_mode = var_1_1 and var_1_1:game_mode()
	arg_1_0._pulsing_units = {}
	arg_1_0._event_manager = Managers.state.event

	arg_1_0._event_manager:register(arg_1_0, "on_player_joined_party", "on_player_joined_party")

	arg_1_0._dirty_units = {}
end

OutlineSystem.add_ext_functions = {
	PlayerOutlineExtension = function (arg_2_0)
		local var_2_0 = arg_2_0:add_outline({
			method = "never",
			outline_color = OutlineSettings.colors.ally,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		arg_2_0.apply_method = "unit_and_childs"
		arg_2_0.pinged_method = "never"

		return var_2_0
	end,
	PlayerHuskOutlineExtension = function (arg_3_0)
		local var_3_0 = arg_3_0:add_outline({
			method = "outside_distance_or_not_visible",
			outline_color = OutlineSettings.colors.ally,
			distance = OutlineSettings.ranges.player_husk,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		arg_3_0.apply_method = "unit_and_childs"
		arg_3_0.pinged_method = "always"

		arg_3_0.update_override_method_player_setting = function (arg_4_0)
			local var_4_0
			local var_4_1 = Application.user_setting("player_outlines")
			local var_4_2 = var_4_1 == "off" and "never" or var_4_1 == "always_on" and "always" or "outside_distance_or_not_visible"

			arg_3_0:update_outline({
				method = var_4_2
			}, 0)
		end

		arg_3_0:update_override_method_player_setting()

		return var_3_0
	end,
	MinionOutlineExtension = function (arg_5_0)
		local var_5_0 = arg_5_0:add_outline({
			method = "outside_distance_or_not_visible",
			outline_color = OutlineSettings.colors.necromancer_command,
			distance = OutlineSettings.ranges.player_husk,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		arg_5_0.apply_method = "unit_and_childs"
		arg_5_0.pinged_method = "always"

		arg_5_0.update_override_method_minion_setting = function (arg_6_0)
			local var_6_0
			local var_6_1 = Application.user_setting("minion_outlines")
			local var_6_2 = var_6_1 == "off" and "never" or var_6_1 == "always_on" and "always" or "outside_distance_or_not_visible"

			arg_5_0:update_outline({
				method = var_6_2
			}, 0)
		end

		arg_5_0:update_override_method_minion_setting()

		return var_5_0
	end,
	PickupOutlineExtension = function (arg_7_0)
		local var_7_0 = arg_7_0:add_outline({
			method = "within_distance_and_not_in_dark",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.pickup,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_7_0.apply_method = "unit"
		arg_7_0.pinged_method = "not_in_dark"

		return var_7_0
	end,
	AIOutlineExtension = function (arg_8_0)
		local var_8_0 = arg_8_0:add_outline({
			method = "never",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.player_husk,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		arg_8_0.apply_method = "unit"
		arg_8_0.pinged_method = "not_in_dark"

		return var_8_0
	end,
	DoorOutlineExtension = function (arg_9_0)
		local var_9_0 = arg_9_0:add_outline({
			method = "within_distance_and_not_in_dark",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.doors,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_9_0.apply_method = "unit"
		arg_9_0.pinged_method = "not_in_dark"

		return var_9_0
	end,
	SmallDoorOutlineExtension = function (arg_10_0)
		local var_10_0 = arg_10_0:add_outline({
			method = "within_distance_and_not_in_dark",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.small_doors,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_10_0.apply_method = "unit"
		arg_10_0.pinged_method = "not_in_dark"

		return var_10_0
	end,
	ObjectiveOutlineExtension = function (arg_11_0)
		local var_11_0 = arg_11_0:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.objective,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		arg_11_0.apply_method = "unit"
		arg_11_0.pinged_method = "always"

		return var_11_0
	end,
	ObjectiveLightOutlineExtension = function (arg_12_0)
		local var_12_0 = arg_12_0:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.objective_light,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_12_0.apply_method = "unit"
		arg_12_0.pinged_method = "always"

		return var_12_0
	end,
	ObjectiveLargeOutlineExtension = function (arg_13_0)
		local var_13_0 = arg_13_0:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.objective_large,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_13_0.apply_method = "unit"
		arg_13_0.pinged_method = "always"

		return var_13_0
	end,
	ElevatorOutlineExtension = function (arg_14_0)
		local var_14_0 = arg_14_0:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.elevators,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_14_0.apply_method = "unit"
		arg_14_0.pinged_method = "not_in_dark"

		return var_14_0
	end,
	ConditionalInteractOutlineExtension = function (arg_15_0)
		local var_15_0 = arg_15_0:add_outline({
			method = "conditional_within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.doors,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_15_0.apply_method = "unit"
		arg_15_0.pinged_method = "always"

		return var_15_0
	end,
	ConditionalPickupOutlineExtension = function (arg_16_0)
		local var_16_0 = arg_16_0:add_outline({
			method = "conditional_within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.pickup,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_16_0.apply_method = "unit"
		arg_16_0.pinged_method = "always"

		return var_16_0
	end,
	EnemyOutlineExtension = function (arg_17_0)
		local var_17_0 = arg_17_0:add_outline({
			method = "never",
			outline_color = OutlineSettings.colors.knocked_down,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		arg_17_0.apply_method = "unit_and_childs"
		arg_17_0.pinged_method = "not_in_dark"

		return var_17_0
	end,
	SmallPickupOutlineExtension = function (arg_18_0)
		local var_18_0 = arg_18_0:add_outline({
			method = "within_distance_and_not_in_dark",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.small_pickup,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_18_0.apply_method = "unit"
		arg_18_0.pinged_method = "not_in_dark"

		return var_18_0
	end,
	GenericOutlineExtension = function (arg_19_0)
		local var_19_0 = arg_19_0:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.interactable,
			flag = OutlineSettings.flags.wall_occluded
		})

		arg_19_0.apply_method = "unit"
		arg_19_0.pinged_method = "not_in_dark"

		return var_19_0
	end,
	DarkPactPlayerOutlineExtension = function (arg_20_0)
		local var_20_0 = arg_20_0:add_outline({
			method = "never",
			outline_color = OutlineSettingsVS.colors.ally,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		arg_20_0.apply_method = "unit_and_childs"
		arg_20_0.pinged_method = "show_versus_dark_pact_outline"

		return var_20_0
	end,
	DarkPactPlayerHuskOutlineExtension = function (arg_21_0)
		local var_21_0
		local var_21_1 = Managers.player:local_player()

		if var_21_1 then
			local var_21_2 = var_21_1:network_id()
			local var_21_3 = var_21_1:local_player_id()
			local var_21_4 = Managers.party:get_party_from_player_id(var_21_2, var_21_3)
			local var_21_5 = Managers.state.side.side_by_party[var_21_4]

			if var_21_5 and var_21_5:name() == "dark_pact" then
				var_21_0 = true
			end
		end

		local var_21_6 = arg_21_0:add_outline({
			method = "always_same_side",
			outline_color = var_21_0 and OutlineSettingsVS.colors.ally or OutlineSettings.colors.knocked_down,
			distance = OutlineSettings.ranges.player_husk,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		arg_21_0.apply_method = "unit_and_childs"
		arg_21_0.pinged_method = "show_versus_dark_pact_outline"

		return var_21_6
	end
}

OutlineSystem.on_add_extension = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = OutlineExtension:new(arg_22_0, arg_22_2)
	local var_22_1 = OutlineSystem.add_ext_functions[arg_22_3]
	local var_22_2 = var_22_1(var_22_0)

	arg_22_0._initial_outline_data[var_22_0] = {
		setup_func = var_22_1,
		id = var_22_2
	}

	ScriptUnit.set_extension(arg_22_2, "outline_system", var_22_0, {})

	arg_22_0.unit_extension_data[arg_22_2] = var_22_0
	arg_22_0.units[#arg_22_0.units + 1] = arg_22_2

	return var_22_0
end

OutlineSystem.on_remove_extension = function (arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.frozen_unit_extension_data[arg_23_1] = nil

	arg_23_0:_cleanup_extension(arg_23_1, arg_23_2)
	ScriptUnit.remove_extension(arg_23_1, arg_23_0.NAME)
end

OutlineSystem.on_player_joined_party = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if Managers.mechanism:current_mechanism_name() == "versus" then
		arg_24_0:_reinitialize_outlines(arg_24_1, arg_24_3)
	end
end

OutlineSystem._reinitialize_outlines = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = Managers.party:is_game_participating_party(arg_25_2)

	if arg_25_1 ~= Network.peer_id() or not var_25_0 then
		return
	end

	for iter_25_0, iter_25_1 in pairs(arg_25_0._initial_outline_data) do
		local var_25_1 = iter_25_1.setup_func(iter_25_0)

		iter_25_0:swap_delete_outline(var_25_1, iter_25_1.id)

		if iter_25_0.update_override_method_player_setting then
			iter_25_0.update_override_method_player_setting()
		end

		if iter_25_0.update_override_method_minion_setting then
			iter_25_0.update_override_method_minion_setting()
		end
	end
end

OutlineSystem.mark_outline_dirty = function (arg_26_0, arg_26_1)
	arg_26_0._dirty_units[arg_26_1] = true
end

OutlineSystem.on_freeze_extension = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0.unit_extension_data[arg_27_1]

	fassert(var_27_0, "Unit was already frozen.")

	arg_27_0.frozen_unit_extension_data[arg_27_1] = var_27_0

	arg_27_0:_cleanup_extension(arg_27_1, arg_27_2)
end

OutlineSystem._cleanup_extension = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0.unit_extension_data[arg_28_1]

	if var_28_0 == nil then
		return
	end

	arg_28_0._initial_outline_data[var_28_0] = nil
	arg_28_0.unit_extension_data[arg_28_1] = nil

	table.swap_delete(arg_28_0.units, table.index_of(arg_28_0.units, arg_28_1))
end

OutlineSystem.freeze = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_0.frozen_unit_extension_data

	if var_29_0[arg_29_1] then
		return
	end

	local var_29_1 = arg_29_0.unit_extension_data[arg_29_1]

	fassert(var_29_1, "Unit to freeze didn't have unfrozen extension")
	arg_29_0:_cleanup_extension(arg_29_1, arg_29_2)

	arg_29_0.unit_extension_data[arg_29_1] = nil
	var_29_0[arg_29_1] = var_29_1

	fassert(arg_29_2 == "EnemyOutlineExtension", "Only support for freezing enemy outline extensions")

	if var_29_1.outlined then
		local var_29_2 = var_29_1.outline_color
		local var_29_3 = var_29_2.color
		local var_29_4 = Color(var_29_3[1], var_29_3[2], var_29_3[3], var_29_3[4])

		arg_29_0:outline_unit(arg_29_1, var_29_1.flag, var_29_4, false, var_29_1.apply_method, var_29_2)

		var_29_1.outlined = false
	end

	var_29_1.method = "never"

	var_29_1:on_freeze()
end

OutlineSystem.unfreeze = function (arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.frozen_unit_extension_data[arg_30_1]

	fassert(var_30_0, "Unit to unfreeze didn't have frozen extension")

	arg_30_0.frozen_unit_extension_data[arg_30_1] = nil
	arg_30_0.unit_extension_data[arg_30_1] = var_30_0
	arg_30_0.units[#arg_30_0.units + 1] = arg_30_1

	var_30_0:on_unfreeze()
end

OutlineSystem.local_player_created = function (arg_31_0, arg_31_1)
	arg_31_0._local_player = arg_31_1
	arg_31_0.camera_unit = arg_31_1.camera_follow_unit
end

OutlineSystem._is_cutscene_active = function (arg_32_0)
	local var_32_0 = arg_32_0.cutscene_system

	if not var_32_0 then
		return false
	end

	return var_32_0.active_camera and not var_32_0.ingame_hud_enabled
end

OutlineSystem._is_photomode_active = function (arg_33_0)
	local var_33_0 = arg_33_0._game_mode

	return var_33_0 and var_33_0:photomode_enabled()
end

OutlineSystem.set_disabled = function (arg_34_0, arg_34_1)
	if arg_34_1 and not arg_34_0._disabled then
		local var_34_0 = arg_34_0.units
		local var_34_1 = arg_34_0.unit_extension_data

		for iter_34_0 = 1, #var_34_0 do
			local var_34_2 = var_34_0[iter_34_0]
			local var_34_3 = var_34_1[var_34_2]

			if var_34_3 and var_34_3.outlined then
				local var_34_4 = var_34_3.outline_color
				local var_34_5 = var_34_4.color
				local var_34_6 = Color(var_34_5[1], var_34_5[2], var_34_5[3], var_34_5[4])

				arg_34_0:outline_unit(var_34_2, var_34_3.flag, var_34_6, false, var_34_3.apply_method, var_34_4)

				var_34_3.outlined = false
			end
		end
	end

	arg_34_0._disabled = arg_34_1
end

OutlineSystem.update = function (arg_35_0, arg_35_1, arg_35_2)
	if arg_35_0._disabled or script_data.disable_outlines then
		return
	end

	if not arg_35_0.camera_unit then
		return
	end

	local var_35_0 = #arg_35_0.units

	if var_35_0 == 0 then
		return
	end

	local var_35_1 = arg_35_0:_is_cutscene_active() or arg_35_0:_is_photomode_active()
	local var_35_2 = arg_35_0._dirty_units

	for iter_35_0 in pairs(var_35_2) do
		arg_35_0:_update_unit_outline(iter_35_0, var_35_1)

		var_35_2[iter_35_0] = nil
	end

	local var_35_3 = arg_35_1.dt
	local var_35_4 = math.min(var_35_0, 20)
	local var_35_5 = arg_35_0.current_index
	local var_35_6 = arg_35_0.units

	for iter_35_1 = 1, var_35_4 do
		var_35_5 = var_35_5 % var_35_0 + 1

		local var_35_7 = var_35_6[var_35_5]

		if not arg_35_0:_update_unit_outline(var_35_7, var_35_1) then
			break
		end
	end

	arg_35_0.current_index = var_35_5

	arg_35_0:_update_pulsing(var_35_3, arg_35_2)
end

OutlineSystem._update_unit_outline = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0.unit_extension_data[arg_36_1]

	if var_36_0 then
		local var_36_1 = 3
		local var_36_2 = 0
		local var_36_3 = var_36_0.outline_color
		local var_36_4 = var_36_0.method

		if var_36_0.prev_flag and var_36_0.prev_flag ~= var_36_0.flag then
			arg_36_0:outline_unit(arg_36_1, var_36_0.prev_flag, Color(0, 0, 0, 0), false, var_36_0.apply_method, var_36_3)

			var_36_0.prev_flag = nil
		end

		local var_36_5 = false
		local var_36_6 = false

		if not arg_36_2 then
			var_36_5, var_36_6 = arg_36_0[var_36_4](arg_36_0, arg_36_1, var_36_0)
		end

		if var_36_0.outlined ~= var_36_5 or var_36_0.reapply then
			local var_36_7 = var_36_3.color
			local var_36_8 = Color(255, var_36_7[2], var_36_7[3], var_36_7[4])

			arg_36_0:outline_unit(arg_36_1, var_36_0.flag, var_36_8, var_36_5, var_36_0.apply_method, var_36_3)

			var_36_0.outlined = var_36_5
		end

		var_36_0.reapply = false

		if var_36_6 and var_36_1 <= var_36_2 + 1 then
			return false
		end
	end

	return true
end

local var_0_0 = {
	flash = function (arg_37_0)
		return math.round(arg_37_0 * 3 % 1)
	end,
	pulse = function (arg_38_0)
		return math.round(arg_38_0 * 3 % 1.5)
	end
}

OutlineSystem.set_pulsing = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	if arg_39_2 then
		arg_39_0._pulsing_units[arg_39_1] = var_0_0[arg_39_3]
	elseif arg_39_0._pulsing_units[arg_39_1] then
		arg_39_0._pulsing_units[arg_39_1] = nil

		local var_39_0 = arg_39_0.unit_extension_data[arg_39_1]

		if var_39_0 then
			var_39_0.reapply = true
		end
	end
end

OutlineSystem._update_pulsing = function (arg_40_0, arg_40_1, arg_40_2)
	for iter_40_0, iter_40_1 in pairs(arg_40_0._pulsing_units) do
		local var_40_0 = arg_40_0.unit_extension_data[iter_40_0]

		if var_40_0 then
			local var_40_1 = var_40_0.outline_color
			local var_40_2 = var_40_1.color
			local var_40_3 = iter_40_1(arg_40_2)
			local var_40_4 = Color(var_40_2[1] * var_40_3, var_40_2[2] * var_40_3, var_40_2[3] * var_40_3, var_40_2[4] * var_40_3)

			arg_40_0:outline_unit(iter_40_0, var_40_0.flag, var_40_4, true, var_40_0.apply_method, var_40_1)

			var_40_0.outlined = true
		else
			arg_40_0._pulsing_units[iter_40_0] = nil
		end
	end
end

OutlineSystem.outline_unit = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	if Unit.has_data(arg_41_1, "outlined_meshes") then
		local var_41_0 = 0

		while Unit.has_data(arg_41_1, "outlined_meshes", var_41_0) do
			local var_41_1 = Unit.get_data(arg_41_1, "outlined_meshes", var_41_0)
			local var_41_2 = Unit.mesh(arg_41_1, var_41_1)

			Mesh.set_shader_pass_flag(var_41_2, arg_41_2, arg_41_4)

			if arg_41_4 then
				local var_41_3 = Mesh.num_materials(var_41_2)

				for iter_41_0 = 0, var_41_3 - 1 do
					local var_41_4 = Mesh.material(var_41_2, iter_41_0)

					Material.set_color(var_41_4, "outline_color", arg_41_3)
					Material.set_scalar(var_41_4, "outline_pulse_multiplier", arg_41_6.pulsate and arg_41_6.pulse_multiplier or 0)
				end
			end

			var_41_0 = var_41_0 + 1
		end
	elseif arg_41_5 == "unit_and_childs" then
		Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(arg_41_1, arg_41_2, arg_41_4)
		Unit.set_color_for_materials_in_unit_and_childs(arg_41_1, "outline_color", arg_41_3)
		Unit.set_scalar_for_materials_in_unit_and_childs(arg_41_1, "outline_pulse_multiplier", arg_41_6.pulsate and arg_41_6.pulse_multiplier or 0)
	elseif arg_41_5 == "unit" then
		Unit.set_shader_pass_flag_for_meshes(arg_41_1, arg_41_2, arg_41_4)
		Unit.set_color_for_materials(arg_41_1, "outline_color", arg_41_3)
		Unit.set_scalar_for_materials(arg_41_1, "outline_pulse_multiplier", arg_41_6.pulsate and arg_41_6.pulse_multiplier or 0)
	else
		error(sprintf("Non-existant apply method %s", arg_41_5))
	end

	local var_41_5 = ScriptUnit.has_extension(arg_41_1, "locomotion_system")
	local var_41_6 = var_41_5 and var_41_5.bone_lod_extension_id

	if var_41_6 then
		EngineOptimized.bone_lod_set_ignore_umbra(var_41_6, arg_41_4)
	end
end

OutlineSystem.raycast_result = function (arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.physics_world
	local var_42_1 = Unit.local_position(arg_42_0.camera_unit, 0)
	local var_42_2 = Vector3.distance(var_42_1, arg_42_1)
	local var_42_3 = Vector3.normalize(arg_42_1 - var_42_1)
	local var_42_4, var_42_5 = PhysicsWorld.immediate_raycast(var_42_0, var_42_1, var_42_3, var_42_2, "all", "collision_filter", "filter_ai_line_of_sight_check")

	return var_42_4, var_42_5
end

OutlineSystem.distance_sq_to_unit = function (arg_43_0, arg_43_1)
	local var_43_0 = Unit.local_position(arg_43_0.camera_unit, 0)
	local var_43_1, var_43_2 = Unit.box(arg_43_1)
	local var_43_3 = Matrix4x4.translation(var_43_1)

	return (Vector3.distance_squared(var_43_0, var_43_3))
end

local var_0_1 = true

OutlineSystem.never = function (arg_44_0, arg_44_1, arg_44_2)
	return false
end

OutlineSystem.ai_alive = function (arg_45_0, arg_45_1, arg_45_2)
	return not not HEALTH_ALIVE[arg_45_1]
end

OutlineSystem.always = function (arg_46_0, arg_46_1, arg_46_2)
	return true
end

OutlineSystem.always_same_side = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_2.same_side

	if not var_47_0 then
		local var_47_1 = Managers.state.side.side_by_unit[arg_47_1]
		local var_47_2 = Managers.state.side.side_by_party[arg_47_0._local_player:get_party()]

		var_47_0 = not Managers.state.side:is_enemy_by_side(var_47_1, var_47_2)
		arg_47_2.same_side = var_47_0
	end

	return var_47_0
end

OutlineSystem.same_side_in_ghost_mode = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_2.status_extension

	if var_48_0 == nil then
		var_48_0 = ScriptUnit.has_extension(arg_48_1, "status_system")
		arg_48_2.status_extension = var_48_0 or false
	end

	return var_48_0 and var_48_0:get_in_ghost_mode() and arg_48_0:always_same_side(arg_48_1, arg_48_2)
end

OutlineSystem.visible = function (arg_49_0, arg_49_1, arg_49_2)
	local var_49_0, var_49_1 = Unit.box(arg_49_1)
	local var_49_2 = Matrix4x4.translation(var_49_0)

	return not arg_49_0.darkness_system:is_in_darkness(var_49_2) and not arg_49_0:raycast_result(var_49_2), var_0_1
end

OutlineSystem.not_in_dark = function (arg_50_0, arg_50_1, arg_50_2)
	local var_50_0, var_50_1 = Unit.box(arg_50_1)
	local var_50_2 = Matrix4x4.translation(var_50_0)

	return not arg_50_0.darkness_system:is_in_darkness(var_50_2)
end

OutlineSystem.not_visible = function (arg_51_0, arg_51_1, arg_51_2)
	return not arg_51_0:visible(arg_51_1, arg_51_2), var_0_1
end

OutlineSystem.within_distance_and_not_in_dark = function (arg_52_0, arg_52_1, arg_52_2)
	if not arg_52_0:within_distance(arg_52_1, arg_52_2) then
		return false
	end

	local var_52_0, var_52_1 = Unit.box(arg_52_1)
	local var_52_2 = Matrix4x4.translation(var_52_0)

	return not arg_52_0.darkness_system:is_in_darkness(var_52_2)
end

OutlineSystem.within_distance = function (arg_53_0, arg_53_1, arg_53_2)
	return arg_53_0:distance_sq_to_unit(arg_53_1) <= arg_53_2.distance * arg_53_2.distance
end

OutlineSystem.outside_distance = function (arg_54_0, arg_54_1, arg_54_2)
	return arg_54_0:distance_sq_to_unit(arg_54_1) > arg_54_2.distance * arg_54_2.distance
end

OutlineSystem.outside_distance_or_not_visible = function (arg_55_0, arg_55_1, arg_55_2)
	if arg_55_0:outside_distance(arg_55_1, arg_55_2) then
		return true
	end

	if arg_55_0:not_visible(arg_55_1, arg_55_2) then
		return true, var_0_1
	end

	return false, var_0_1
end

OutlineSystem.within_distance_and_visible = function (arg_56_0, arg_56_1, arg_56_2)
	if arg_56_0:within_distance(arg_56_1, arg_56_2) and arg_56_0:visible(arg_56_1, arg_56_2) then
		return true, var_0_1
	end

	return false
end

OutlineSystem.conditional_within_distance = function (arg_57_0, arg_57_1, arg_57_2)
	if arg_57_0:within_distance(arg_57_1, arg_57_2) then
		local var_57_0 = Unit.get_data(arg_57_1, "interaction_data", "interaction_type")
		local var_57_1 = InteractionDefinitions[var_57_0]
		local var_57_2 = Managers.player:local_player().player_unit
		local var_57_3 = false

		if var_57_2 then
			var_57_3 = var_57_1.client.can_interact(var_57_2, arg_57_1)
		end

		return var_57_3
	end

	return false
end

OutlineSystem.in_ghost_mode = function (arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = ScriptUnit.has_extension(arg_58_1, "ghost_mode_system")

	return var_58_0 and var_58_0:is_in_ghost_mode()
end

OutlineSystem.has_gutter_runner_invisible_buff = function (arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = ScriptUnit.extension(arg_59_1, "buff_system")

	return var_59_0 and var_59_0:has_buff_type("vs_gutter_runner_smoke_bomb_invisible")
end

OutlineSystem.show_versus_dark_pact_outline = function (arg_60_0, arg_60_1, arg_60_2)
	if not arg_60_0:within_distance_and_not_in_dark(arg_60_1, arg_60_2) then
		return false
	end

	if arg_60_0:in_ghost_mode(arg_60_1, arg_60_2) then
		return false
	end

	return not arg_60_0:has_gutter_runner_invisible_buff(arg_60_1, arg_60_2)
end

OutlineSystem.destroy = function (arg_61_0)
	arg_61_0._event_manager:unregister("on_player_joined_party", arg_61_0)
end
