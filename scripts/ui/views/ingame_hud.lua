-- chunkname: @scripts/ui/views/ingame_hud.lua

require("foundation/scripts/util/local_require")
require("scripts/ui/hud_ui/hud_customizer")
local_require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure")
require("scripts/ui/ui_animator")
require("scripts/ui/ui_cleanui")
DLCUtils.dofile("hud_component_list_path")

IngameHud = class(IngameHud)

function IngameHud.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._peer_id = Network.peer_id()
	arg_1_0._player = Managers.player:local_player()
	arg_1_0._ingame_ui_context = arg_1_2

	arg_1_0:_setup_components()
end

function IngameHud._setup_components(arg_2_0)
	arg_2_0._currently_visible_components = {}
	arg_2_0._current_group_name = nil

	local var_2_0 = arg_2_0._ingame_ui_context
	local var_2_1 = Managers.mechanism:mechanism_setting("tobii_available")

	if rawget(_G, "Tobii") and var_2_1 then
		var_2_0.cleanui = UICleanUI.create(arg_2_0._peer_id)
		arg_2_0._clean_ui = var_2_0.cleanui
		arg_2_0._clean_ui.hud = arg_2_0

		local var_2_2 = Tobii.get_is_connected()
		local var_2_3 = Application.user_setting("tobii_eyetracking") and Application.user_setting("tobii_clean_ui")

		arg_2_0:enable_clean_ui(var_2_2 and var_2_3)
	else
		arg_2_0._clean_ui = nil
	end

	local var_2_4 = Managers.state.game_mode:settings().hud_component_list_path
	local var_2_5 = arg_2_0:_setup_component_definitions(var_2_4)

	arg_2_0._definitions = var_2_5
	arg_2_0._components_hud_scale_lookup = var_2_5.components_hud_scale_lookup

	arg_2_0:_compile_component_list(var_2_0, var_2_5.components)
	Managers.state.event:register(arg_2_0, "player_party_changed", "event_player_party_changed")
end

function IngameHud.reset_components(arg_3_0)
	arg_3_0:destroy()
	arg_3_0:_setup_components()
end

function IngameHud.event_player_party_changed(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not arg_4_2 then
		return
	end

	arg_4_0:reset_components()
end

function IngameHud._setup_component_definitions(arg_5_0, arg_5_1)
	local var_5_0 = local_require(arg_5_1)
	local var_5_1 = table.clone(var_5_0.components)
	local var_5_2 = var_5_0.visibility_groups
	local var_5_3 = {}

	for iter_5_0, iter_5_1 in ipairs(var_5_2) do
		var_5_3[iter_5_1.name] = iter_5_1
	end

	for iter_5_2, iter_5_3 in pairs(DLCSettings) do
		local var_5_4 = iter_5_3.ingame_hud_components

		if var_5_4 then
			for iter_5_4, iter_5_5 in pairs(var_5_4) do
				local var_5_5 = iter_5_5.class_name
				local var_5_6 = true

				for iter_5_6 = 1, #var_5_1 do
					if var_5_1[iter_5_6].class_name == var_5_5 then
						var_5_6 = false
					end
				end

				if var_5_6 then
					var_5_1[#var_5_1 + 1] = table.clone(iter_5_5)
				end
			end
		end
	end

	local function var_5_7(arg_6_0, arg_6_1)
		return arg_6_1.use_hud_scale and not arg_6_0.use_hud_scale
	end

	table.sort(var_5_1, var_5_7)

	local var_5_8 = {}
	local var_5_9 = {}

	for iter_5_7, iter_5_8 in ipairs(var_5_1) do
		local var_5_10 = iter_5_8.class_name

		var_5_8[var_5_10] = iter_5_8

		if iter_5_8.use_hud_scale then
			var_5_9[var_5_10] = true
		end
	end

	for iter_5_9, iter_5_10 in ipairs(var_5_1) do
		local var_5_11 = iter_5_10.class_name
		local var_5_12 = iter_5_10.visibility_groups

		for iter_5_11, iter_5_12 in ipairs(var_5_12) do
			local var_5_13 = var_5_3[iter_5_12]

			if var_5_13 then
				fassert(var_5_13, "Could not find the visibility group: (%s) for component: (%s)", iter_5_12, var_5_11)

				local var_5_14 = var_5_13.validation_function

				fassert(var_5_14, "Could not find any validation_function for visibility group: (%s)", iter_5_12)

				if not var_5_13.visible_components then
					var_5_13.visible_components = {}
				end

				var_5_13.visible_components[var_5_11] = true
			end
		end

		local var_5_15 = iter_5_10.filename

		require(var_5_15)
	end

	return {
		components = var_5_1,
		components_lookup = var_5_8,
		components_hud_scale_lookup = var_5_9,
		visibility_groups = var_5_2,
		visibility_groups_lookup = var_5_3
	}
end

function IngameHud._compile_component_list(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = {}
	local var_7_1 = {}
	local var_7_2 = {}
	local var_7_3 = {}

	for iter_7_0 = 1, #arg_7_2 do
		local var_7_4 = arg_7_2[iter_7_0]
		local var_7_5 = var_7_4.class_name

		fassert(var_7_0[var_7_5] == nil, "Duplicate entries of component (%s)", var_7_5)

		var_7_0[var_7_5] = var_7_4

		arg_7_0:_add_component(var_7_0, var_7_1, var_7_2, var_7_3, var_7_5)
	end

	arg_7_0._component_list = var_7_0
	arg_7_0._components = var_7_1
	arg_7_0._components_array = var_7_2
	arg_7_0._components_array_id_lookup = var_7_3
end

function IngameHud._add_component(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_1[arg_8_5]

	fassert(var_8_0, "No definition found for component (%s)", arg_8_5)

	if arg_8_2[arg_8_5] ~= nil then
		table.dump(arg_8_2, "Hud components:")
	end

	fassert(arg_8_2[arg_8_5] == nil, "Component (%s) is already added", arg_8_5)

	local var_8_1 = arg_8_0._ingame_ui_context
	local var_8_2 = var_8_0.validation_function

	if not var_8_2 or var_8_2(var_8_1, var_8_1.is_in_inn) then
		local var_8_3 = rawget(_G, arg_8_5):new(arg_8_0, var_8_1)

		var_8_3.name = arg_8_5
		arg_8_2[arg_8_5] = var_8_3

		local var_8_4 = #arg_8_3 + 1

		arg_8_3[var_8_4] = var_8_3
		arg_8_4[var_8_3] = var_8_4
	end
end

function IngameHud._remove_component(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_2[arg_9_5]

	if not var_9_0 then
		local var_9_1 = arg_9_1[arg_9_5]

		fassert(var_9_1.validation_function, "Component does not exist and doesn't have a validation_function, how did this happen?")

		local var_9_2 = arg_9_0._ingame_ui_context
		local var_9_3 = var_9_1.validation_function(var_9_2, var_9_2.is_in_inn)

		fassert(var_9_3 == false, "Validation functions returned true but component does not exist, somethings weird.")

		return
	end

	arg_9_0._currently_visible_components[var_9_0.name] = nil

	local var_9_4 = arg_9_4[var_9_0]
	local var_9_5 = #arg_9_3
	local var_9_6 = arg_9_3[var_9_5]

	arg_9_3[var_9_4] = var_9_6
	arg_9_4[var_9_6] = var_9_4

	if var_9_0.destroy then
		var_9_0:destroy()
	end

	arg_9_2[arg_9_5] = nil
	arg_9_3[var_9_5] = nil
	arg_9_4[var_9_0] = nil
end

function IngameHud.remove_components(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._component_list
	local var_10_1 = arg_10_0._components
	local var_10_2 = arg_10_0._components_array
	local var_10_3 = arg_10_0._components_array_id_lookup
	local var_10_4 = #arg_10_1

	for iter_10_0 = 1, var_10_4 do
		local var_10_5 = arg_10_1[iter_10_0]

		arg_10_0:_remove_component(var_10_0, var_10_1, var_10_2, var_10_3, var_10_5)
	end
end

function IngameHud.component(arg_11_0, arg_11_1)
	return arg_11_0._components[arg_11_1]
end

function IngameHud._update_components_post_visibility(arg_12_0)
	if arg_12_0._update_post_visibility then
		local var_12_0 = arg_12_0._definitions.visibility_groups_lookup[arg_12_0._current_group_name]
		local var_12_1 = arg_12_0._components_array
		local var_12_2 = var_12_0.visible_components

		for iter_12_0 = 1, #var_12_1 do
			local var_12_3 = var_12_1[iter_12_0]
			local var_12_4 = var_12_3.name
			local var_12_5 = var_12_2 and var_12_2[var_12_4] or false

			if var_12_3.post_visibility_changed then
				var_12_3:post_visibility_changed(var_12_5)
			end
		end

		arg_12_0._update_post_visibility = false
	end
end

function IngameHud._update_components_visibility(arg_13_0)
	local var_13_0 = arg_13_0._definitions.visibility_groups
	local var_13_1 = #var_13_0
	local var_13_2 = script_data.debug_hud_visibility_group
	local var_13_3 = var_13_2 and var_13_2 ~= "none"

	for iter_13_0 = 1, var_13_1 do
		local var_13_4 = var_13_0[iter_13_0]
		local var_13_5 = var_13_4.name
		local var_13_6 = var_13_4.validation_function
		local var_13_7 = false

		if var_13_3 then
			var_13_7 = var_13_5 == var_13_2
		else
			var_13_7 = var_13_6(arg_13_0)
		end

		if var_13_7 then
			if var_13_5 ~= arg_13_0._current_group_name then
				local var_13_8 = arg_13_0._components_array
				local var_13_9 = arg_13_0._currently_visible_components
				local var_13_10 = var_13_4.visible_components

				for iter_13_1 = 1, #var_13_8 do
					local var_13_11 = var_13_8[iter_13_1]
					local var_13_12 = var_13_11.name
					local var_13_13 = var_13_10 and var_13_10[var_13_12] or false

					if var_13_11.set_visible then
						var_13_11:set_visible(var_13_13)
					end

					var_13_9[var_13_12] = var_13_13
				end

				arg_13_0._current_group_name = var_13_5
				arg_13_0._update_post_visibility = true
			end

			break
		end
	end

	if var_13_3 then
		Debug.text("HUD visibility group: " .. tostring(arg_13_0._current_group_name or "none"))
	end
end

function IngameHud.get_hud_component(arg_14_0, arg_14_1)
	return arg_14_0._components[arg_14_1]
end

function IngameHud._update_hud_scale(arg_15_0)
	if not arg_15_0._resolution_modified then
		arg_15_0._resolution_modified = RESOLUTION_LOOKUP.modified
	end

	if not arg_15_0._scale_modified then
		local var_15_0 = UISettings.hud_scale * 0.01

		arg_15_0._scale_modified = arg_15_0._hud_scale_multiplier ~= var_15_0
		arg_15_0._hud_scale_multiplier = var_15_0
	end
end

function IngameHud._apply_hud_scale(arg_16_0)
	arg_16_0:_update_hud_scale()

	local var_16_0 = arg_16_0._scale_modified
	local var_16_1 = arg_16_0._resolution_modified
	local var_16_2 = var_16_0 or var_16_1
	local var_16_3 = arg_16_0._hud_scale_multiplier

	UPDATE_RESOLUTION_LOOKUP(var_16_2, var_16_3)
end

function IngameHud._abort_hud_scale(arg_17_0)
	local var_17_0 = arg_17_0._scale_modified
	local var_17_1 = arg_17_0._resolution_modified
	local var_17_2 = var_17_0 or var_17_1

	UPDATE_RESOLUTION_LOOKUP(var_17_2)
end

function IngameHud.update(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0:_reset_hud_frame_variables()
	arg_18_0:_update_components_visibility()

	local var_18_0 = arg_18_0._player
	local var_18_1 = arg_18_0._currently_visible_components
	local var_18_2 = arg_18_0._components_array
	local var_18_3 = UISettings.use_custom_hud_scale
	local var_18_4 = false
	local var_18_5 = RESOLUTION_LOOKUP.modified

	for iter_18_0 = 1, #var_18_2 do
		local var_18_6 = var_18_2[iter_18_0]
		local var_18_7 = var_18_6.name

		if var_18_3 and not var_18_4 and arg_18_0._components_hud_scale_lookup[var_18_7] then
			var_18_4 = true

			arg_18_0:_apply_hud_scale()
		end

		if var_18_5 and var_18_6.resolution_modified then
			var_18_6:resolution_modified()
		end

		if var_18_6.update and var_18_1[var_18_7] then
			var_18_6:update(arg_18_1, arg_18_2, var_18_0)
		end
	end

	arg_18_0:_update_clean_ui(arg_18_1, arg_18_2)

	if var_18_4 then
		arg_18_0:_abort_hud_scale()
	end

	HudCustomizer.reset_button(arg_18_0._ingame_ui_context.ui_renderer)
end

function IngameHud.post_update(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0:_reset_hud_frame_variables()
	arg_19_0:_update_components_post_visibility()

	local var_19_0 = arg_19_0._player
	local var_19_1 = arg_19_0._currently_visible_components
	local var_19_2 = arg_19_0._components_array
	local var_19_3 = UISettings.use_custom_hud_scale
	local var_19_4 = false

	for iter_19_0 = 1, #var_19_2 do
		local var_19_5 = var_19_2[iter_19_0]
		local var_19_6 = var_19_5.name

		if var_19_3 and not var_19_4 and arg_19_0._components_hud_scale_lookup[var_19_6] then
			var_19_4 = true

			arg_19_0:_apply_hud_scale()
		end

		if var_19_5.post_update and var_19_1[var_19_6] then
			var_19_5:post_update(arg_19_1, arg_19_2, var_19_0)
		end
	end

	if var_19_4 then
		arg_19_0:_abort_hud_scale()
	end

	arg_19_0._scale_modified = false
	arg_19_0._resolution_modified = false
end

function IngameHud.destroy(arg_20_0)
	Managers.state.event:unregister("player_party_changed", arg_20_0)

	local var_20_0 = arg_20_0._components_array

	for iter_20_0, iter_20_1 in ipairs(var_20_0) do
		if iter_20_1.destroy then
			iter_20_1:destroy()
		end
	end

	arg_20_0._components = nil
	arg_20_0._components_array = nil
end

function IngameHud.parent(arg_21_0)
	return arg_21_0._parent
end

function IngameHud.input_service(arg_22_0)
	return false
end

local function var_0_0(arg_23_0)
	local var_23_0 = arg_23_0 and arg_23_0.player_unit

	if not ALIVE[var_23_0] then
		return true
	end

	return ScriptUnit.extension(var_23_0, "status_system"):is_ready_for_assisted_respawn()
end

function IngameHud.is_in_inn(arg_24_0)
	return arg_24_0._ingame_ui_context.is_in_inn
end

function IngameHud._reset_hud_frame_variables(arg_25_0)
	arg_25_0._crosshair_position_x = false
	arg_25_0._crosshair_position_y = false
	arg_25_0._is_own_player_dead = var_0_0(arg_25_0._player)
end

function IngameHud.is_own_player_dead(arg_26_0)
	return arg_26_0._is_own_player_dead
end

function IngameHud.get_crosshair_position(arg_27_0)
	if not arg_27_0._crosshair_position_x or not arg_27_0._crosshair_position_y then
		local var_27_0 = RESOLUTION_LOOKUP.inv_scale
		local var_27_1 = RESOLUTION_LOOKUP.res_w * 0.5 * var_27_0
		local var_27_2 = RESOLUTION_LOOKUP.res_h * 0.5 * var_27_0
		local var_27_3 = arg_27_0._player
		local var_27_4 = var_27_3 and var_27_3.player_unit

		if ALIVE[var_27_4] then
			local var_27_5 = ScriptUnit.has_extension(var_27_4, "eyetracking_system")

			if var_27_5 and var_27_5:get_is_feature_enabled("tobii_extended_view") then
				local var_27_6 = var_27_5:get_forward_rayhit()

				if var_27_6 then
					local var_27_7 = var_27_3.viewport_name
					local var_27_8 = var_27_3.viewport_world_name
					local var_27_9 = Managers.world:world(var_27_8)
					local var_27_10 = ScriptWorld.viewport(var_27_9, var_27_7)
					local var_27_11 = ScriptViewport.camera(var_27_10)
					local var_27_12 = Camera.world_to_screen(var_27_11, var_27_6)

					var_27_1 = var_27_12.x * var_27_0
					var_27_2 = var_27_12.y * var_27_0
				end
			end
		end

		arg_27_0._crosshair_position_x = var_27_1
		arg_27_0._crosshair_position_y = var_27_2
	end

	return arg_27_0._crosshair_position_x, arg_27_0._crosshair_position_y
end

function IngameHud.enable_clean_ui(arg_28_0, arg_28_1)
	arg_28_0._tobii_clean_ui_is_enabled = arg_28_1
end

function IngameHud._update_clean_ui(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_0._clean_ui then
		return
	end

	local var_29_0 = arg_29_0._had_tobii or false
	local var_29_1 = rawget(_G, "Tobii") and Tobii.get_is_connected()

	if var_29_0 ~= var_29_1 then
		UICleanUI.update(arg_29_0._clean_ui, arg_29_1)
	end

	arg_29_0._had_tobii = var_29_1

	if not var_29_1 then
		return
	end

	if arg_29_0._tobii_clean_ui_was_enabled ~= arg_29_0._tobii_clean_ui_is_enabled then
		UICleanUI.update(arg_29_0._clean_ui, arg_29_1)
	end

	arg_29_0._tobii_clean_ui_was_enabled = arg_29_0._tobii_clean_ui_is_enabled

	if not arg_29_0._tobii_clean_ui_is_enabled then
		return
	end

	UICleanUI.update(arg_29_0._clean_ui, arg_29_1)
end
