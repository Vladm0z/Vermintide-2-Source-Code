-- chunkname: @scripts/entity_system/systems/play_go_tutorial/play_go_tutorial_system.lua

require("scripts/entity_system/systems/play_go_tutorial/play_go_pause_templates")

local var_0_0 = {
	"PlayGoTutorialExtension"
}

PlayGoTutorialSystem = class(PlayGoTutorialSystem, ExtensionSystemBase)

function PlayGoTutorialSystem.init(arg_1_0, arg_1_1, arg_1_2)
	PlayGoTutorialSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0._profile_synchronizer = arg_1_1.profile_synchronizer
	arg_1_0._tutorial_started = false
	arg_1_0._tutorial_unit = nil
	arg_1_0._last_slot_name = nil
	arg_1_0._last_known_attack = nil
	arg_1_0._spawned_ai_units = {}
	arg_1_0._animation_hooks = {}
	arg_1_0._active = false
	arg_1_0._bot_loot_enabled = true
	arg_1_0._bot_portraits_enabled = {}
end

function PlayGoTutorialSystem.destroy(arg_2_0)
	if arg_2_0._unit_animation_event then
		Unit.animation_event = arg_2_0._unit_animation_event
		arg_2_0._unit_animation_event = nil
	end

	if arg_2_0._current_pause_event then
		arg_2_0._current_pause_event.on_exit(arg_2_0._current_pause_event)

		arg_2_0._current_pause_event = nil
	end

	if arg_2_0._current_animation_hook and arg_2_0._current_animation_hook.activated then
		arg_2_0._current_animation_hook.on_exit(arg_2_0._current_animation_hook)

		arg_2_0._current_animation_hook = nil
	end
end

function PlayGoTutorialSystem.active(arg_3_0)
	return arg_3_0._active
end

local var_0_1 = {}

function PlayGoTutorialSystem.on_add_extension(arg_4_0, arg_4_1, arg_4_2, arg_4_3, ...)
	fassert(arg_4_0._tutorial_unit == nil, "Multiple tutorial units spawned on level!")

	local var_4_0 = {}

	arg_4_0._tutorial_started = true
	arg_4_0._tutorial_unit = arg_4_2
	arg_4_0._world = arg_4_1
	arg_4_0._num_bots_active = 1
	script_data.ai_bots_disabled = true
	script_data.info_slates_disabled = true

	local var_4_1 = local_require("scripts/ui/views/tutorial_tooltip_ui_definitions")

	arg_4_0._active = true
	arg_4_0._saved_position = var_4_1.scenegraph.tutorial_tooltip.position
	arg_4_0._saved_definition = var_4_1.scenegraph.tutorial_tooltip
	arg_4_0._saved_definition.position = {
		0,
		-440,
		1
	}
	arg_4_0.player_ammo_refill = false
	arg_4_0._profile_packages = {}

	local var_4_2 = arg_4_0.NAME

	ScriptUnit.set_extension(arg_4_2, var_4_2, var_4_0, var_0_1)

	return var_4_0
end

function PlayGoTutorialSystem.trigger_pause_event(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._current_pause_event = nil

	fassert(not arg_5_0._current_animation_hook, "[PlayGoTutorialSystem:trigger_pause_event] Trying to trigger pause event %q while an animation hook is active", arg_5_1.name)
	fassert(not arg_5_0._current_pause_event, "[PlayGoTutorialSystem:trigger_pause_event] Trying to trigger pause event %q while another pause event %q is active", arg_5_1.name, arg_5_0._current_pause_event and arg_5_0._current_pause_event.name)

	arg_5_0._current_pause_event = arg_5_1
	arg_5_1.timer = Managers.time:time("game") + arg_5_1.animation_delay or 0
	arg_5_1.world = arg_5_0._world

	arg_5_0._current_pause_event.on_enter(arg_5_1, nil, arg_5_2)
end

function PlayGoTutorialSystem.add_animation_hook(arg_6_0, arg_6_1)
	arg_6_0._animation_hooks[#arg_6_0._animation_hooks + 1] = arg_6_1

	arg_6_0:_add_next_animation_hook()
end

function PlayGoTutorialSystem._add_next_animation_hook(arg_7_0)
	arg_7_0._unit_animation_event = arg_7_0._unit_animation_event or Unit.animation_event

	local var_7_0 = arg_7_0._animation_hooks[1]

	if var_7_0 then
		arg_7_0._current_animation_hook = var_7_0

		function Unit.animation_event(arg_8_0, arg_8_1)
			local var_8_0 = Unit.get_data(arg_8_0, "breed")

			if var_8_0 and var_8_0.name == var_7_0.breed and not var_7_0.activated and table.find(var_7_0.animations, arg_8_1) and var_7_0.check_prerequisites() then
				var_7_0.timer = Managers.time:time("game") + var_7_0.animation_delay or 0
				var_7_0.world = arg_7_0._world

				var_7_0.on_enter(var_7_0, arg_8_0)
			end

			return arg_7_0._unit_animation_event(arg_8_0, arg_8_1)
		end
	else
		Unit.animation_event = arg_7_0._unit_animation_event
		arg_7_0._unit_animation_event = nil

		print("Resetting Unit.animation_event")
	end
end

function PlayGoTutorialSystem.on_remove_extension(arg_9_0, arg_9_1, arg_9_2)
	ScriptUnit.remove_extension(arg_9_1, arg_9_0.NAME)
	arg_9_0:_unload_profile_packages()

	script_data.ai_bots_disabled = nil
	script_data.info_slates_disabled = nil
	arg_9_0._saved_definition.position = arg_9_0._saved_position
	arg_9_0._active = false
	arg_9_0._tutorial_started = false
	arg_9_0._tutorial_unit = nil
end

function PlayGoTutorialSystem.set_bot_ready_for_assisted_respawn(arg_10_0, arg_10_1, arg_10_2)
	ScriptUnit.extension(arg_10_1, "status_system"):set_ready_for_assisted_respawn(true, arg_10_2)
end

function PlayGoTutorialSystem.remove_player_ammo(arg_11_0)
	local var_11_0 = Managers.player:local_player()
	local var_11_1 = ScriptUnit.extension(var_11_0.player_unit, "inventory_system")
	local var_11_2, var_11_3 = var_11_1:current_ammo_status("slot_ranged")

	if var_11_2 and var_11_2 > 0 then
		local var_11_4 = var_11_1:get_slot_data("slot_ranged")
		local var_11_5 = var_11_4.left_unit_1p
		local var_11_6 = var_11_4.right_unit_1p
		local var_11_7 = ScriptUnit.has_extension(var_11_5, "ammo_system") and ScriptUnit.extension(var_11_5, "ammo_system") or ScriptUnit.has_extension(var_11_6, "ammo_system") and ScriptUnit.extension(var_11_6, "ammo_system")

		if var_11_7 then
			var_11_7:use_ammo(1)
			var_11_7:add_ammo_to_reserve(-(var_11_2 - 1))
		end
	end
end

function PlayGoTutorialSystem.check_player_ammo(arg_12_0)
	local var_12_0 = Managers.player:local_player()
	local var_12_1, var_12_2 = ScriptUnit.extension(var_12_0.player_unit, "inventory_system"):current_ammo_status("slot_ranged")

	if var_12_1 > 0 then
		return true
	end

	return false
end

function PlayGoTutorialSystem.enable_player_ammo_refill(arg_13_0)
	arg_13_0.player_ammo_refill = true
end

function PlayGoTutorialSystem.give_player_potion_from_bot(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = ScriptUnit.extension(arg_14_1, "inventory_system")
	local var_14_1 = "potion_speed_boost_01"
	local var_14_2 = ItemMasterList[var_14_1]

	var_14_0:add_equipment("slot_potion", var_14_2)

	local var_14_3 = Managers.player:unit_owner(arg_14_2)

	if var_14_3 then
		Managers.state.event:trigger("give_item_feedback", var_14_3:stats_id() .. var_14_1, var_14_3, var_14_1)
	end
end

function PlayGoTutorialSystem.update(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0._tutorial_started then
		return
	end

	local var_15_0 = Managers.player:local_player()

	if not Unit.alive(var_15_0.player_unit) then
		return
	end

	arg_15_0:_update_animation_hooks(var_15_0, arg_15_2)
	arg_15_0:_update_pause_events(arg_15_2)
	arg_15_0:_update_player_health(var_15_0)
	arg_15_0:_update_player_ammo(var_15_0)
	arg_15_0:_update_ai_units()
	arg_15_0:_capture_wield_switch(var_15_0)
	arg_15_0:_capture_attacks(var_15_0)
end

function PlayGoTutorialSystem._update_animation_hooks(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0._current_animation_hook and arg_16_0._current_animation_hook.activated and arg_16_0._current_animation_hook.update(arg_16_0._current_animation_hook, arg_16_2) then
		arg_16_0._current_animation_hook.on_exit(arg_16_0._current_animation_hook)
		table.remove(arg_16_0._animation_hooks, 1)

		arg_16_0._current_animation_hook = nil

		arg_16_0:_add_next_animation_hook()
	end
end

function PlayGoTutorialSystem._update_pause_events(arg_17_0, arg_17_1)
	if arg_17_0._current_pause_event and arg_17_0._current_pause_event.update(arg_17_0._current_pause_event, arg_17_1) then
		arg_17_0._current_pause_event.on_exit(arg_17_0._current_pause_event)

		arg_17_0._current_pause_event = nil
	end
end

function PlayGoTutorialSystem._update_player_health(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.player_unit
	local var_18_1 = ScriptUnit.extension(var_18_0, "health_system")

	if var_18_1:current_health_percent() < 0.2 then
		var_18_1:reset()
	end
end

function PlayGoTutorialSystem._capture_wield_switch(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.player_unit
	local var_19_1 = ScriptUnit.extension(var_19_0, "inventory_system")

	if var_19_1:get_wielded_slot_name() ~= arg_19_0._last_slot_name then
		arg_19_0._last_slot_name = var_19_1:get_wielded_slot_name()

		Unit.flow_event(arg_19_0._tutorial_unit, "lua_wield_switch")
	end
end

function PlayGoTutorialSystem._capture_attacks(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.player_unit
	local var_20_1 = ScriptUnit.extension(var_20_0, "inventory_system"):equipment()
	local var_20_2 = var_20_1.right_hand_wielded_unit or var_20_1.left_hand_wielded_unit

	if ALIVE[var_20_2] then
		local var_20_3 = ScriptUnit.extension(var_20_2, "weapon_system")

		if var_20_3:has_current_action() then
			local var_20_4 = var_20_3:get_current_action_settings()

			if var_20_4.charge_value ~= nil then
				arg_20_0._last_known_attack = var_20_4.charge_value
			end
		end
	end
end

function PlayGoTutorialSystem._update_player_ammo(arg_21_0, arg_21_1)
	if not arg_21_0.player_ammo_refill then
		return
	end

	local var_21_0 = ScriptUnit.extension(arg_21_1.player_unit, "inventory_system")
	local var_21_1, var_21_2 = var_21_0:current_ammo_status("slot_ranged")

	if var_21_1 == 0 then
		local var_21_3 = var_21_0:get_slot_data("slot_ranged").left_unit_1p
		local var_21_4 = ScriptUnit.has_extension(var_21_3, "ammo_system") and ScriptUnit.extension(var_21_3, "ammo_system")

		if var_21_4 then
			var_21_4:add_ammo(var_21_2)

			if var_21_0:get_wielded_slot_name() == "slot_ranged" and var_21_4:can_reload() then
				var_21_4:start_reload(true)
			end
		end
	end
end

function PlayGoTutorialSystem._update_ai_units(arg_22_0)
	for iter_22_0, iter_22_1 in pairs(arg_22_0._spawned_ai_units) do
		if not HEALTH_ALIVE[iter_22_1.ai_unit] then
			if iter_22_1.outline_id then
				ScriptUnit.extension(iter_22_1.ai_unit, "outline_system"):remove_outline(iter_22_1.outline_id)
			end

			Unit.flow_event(iter_22_1.spawner_unit, "lua_ai_death")

			arg_22_0._spawned_ai_units[iter_22_0] = nil

			break
		end
	end
end

function PlayGoTutorialSystem.clear_hooks(arg_23_0)
	if arg_23_0._unit_animation_event then
		Unit.animation_event = arg_23_0._unit_animation_event
		arg_23_0._unit_animation_event = nil
	end

	if arg_23_0._current_pause_event then
		arg_23_0._current_pause_event.on_exit(arg_23_0._current_pause_event)

		arg_23_0._current_pause_event = nil
	end

	if arg_23_0._current_animation_hook and arg_23_0._current_animation_hook.activated then
		arg_23_0._current_animation_hook.on_exit(arg_23_0._current_animation_hook)

		arg_23_0._current_animation_hook = nil
	end
end

function PlayGoTutorialSystem._load_profile_packages(arg_24_0)
	local var_24_0 = {
		3,
		4
	}
	local var_24_1 = 1
	local var_24_2 = {
		["4"] = true,
		["3"] = false
	}
	local var_24_3 = InventorySettings.slots
	local var_24_4 = #InventorySettings.slots
	local var_24_5 = arg_24_0._profile_packages

	for iter_24_0, iter_24_1 in ipairs(var_24_0) do
		local var_24_6 = SPProfiles[iter_24_1]
		local var_24_7 = var_24_6.careers[var_24_1].name

		for iter_24_2 = 1, var_24_4 do
			repeat
				local var_24_8 = var_24_3[iter_24_2]
				local var_24_9 = var_24_8.NAME
				local var_24_10 = var_24_8.category
				local var_24_11 = BackendUtils.get_loadout_item(var_24_7, var_24_9)

				if not var_24_11 then
					break
				end

				local var_24_12 = var_24_11.backend_id
				local var_24_13 = var_24_11.data
				local var_24_14 = BackendUtils.get_item_template(var_24_13, var_24_12)
				local var_24_15 = BackendUtils.get_item_units(var_24_13, var_24_12, nil, var_24_7)

				if var_24_10 == "weapon" then
					local var_24_16 = var_24_15.left_hand_unit

					if var_24_16 then
						if var_24_2[iter_24_1] then
							var_24_5[var_24_16] = true
						end

						var_24_5[var_24_16 .. "_3p"] = true
					end

					local var_24_17 = var_24_15.right_hand_unit

					if var_24_17 then
						if var_24_2[iter_24_1] then
							var_24_5[var_24_17] = true
						end

						var_24_5[var_24_17 .. "_3p"] = true
					end

					local var_24_18 = var_24_15.ammo_unit

					if var_24_18 then
						if var_24_2[iter_24_1] then
							var_24_5[var_24_18] = true
						end

						var_24_5[var_24_15.ammo_unit_3p or var_24_18 .. "_3p"] = true
					end

					local var_24_19 = var_24_14.actions

					for iter_24_3, iter_24_4 in pairs(var_24_19) do
						for iter_24_5, iter_24_6 in pairs(iter_24_4) do
							local var_24_20 = iter_24_6.projectile_info

							if var_24_20 then
								local var_24_21 = var_24_20.projectile_units_template
								local var_24_22 = ProjectileUnits[var_24_21]

								if var_24_22.projectile_unit_name then
									var_24_5[var_24_22.projectile_unit_name] = true
								end

								if var_24_22.dummy_linker_unit_name then
									var_24_5[var_24_22.dummy_linker_unit_name] = true
								end

								if var_24_22.dummy_linker_broken_units then
									for iter_24_7, iter_24_8 in pairs(var_24_22.dummy_linker_broken_units) do
										var_24_5[iter_24_8] = true
									end
								end
							end
						end
					end

					break
				end

				if var_24_10 == "attachment" then
					var_24_5[var_24_15.unit] = true

					break
				end

				error("InventoryPackageSynchronizerClient unknown slot_category: " .. var_24_10)
			until true
		end

		local var_24_23 = var_24_6.base_units

		if var_24_2[iter_24_1] then
			var_24_5[var_24_23.first_person] = true
			var_24_5[var_24_23.first_person_bot] = true
			var_24_5[var_24_23.third_person] = true
			var_24_5[var_24_23.third_person_bot] = true
		else
			var_24_5[var_24_23.third_person_husk] = true
		end

		local var_24_24 = var_24_6.first_person_attachment

		if var_24_2[iter_24_1] then
			var_24_5[var_24_24.unit] = true
		end

		var_24_5[var_24_6.third_person_attachment.unit] = true
	end

	for iter_24_9, iter_24_10 in pairs(var_24_5) do
		Managers.package:load(iter_24_9, "play_go_tutorial_system", nil, true)
	end

	print("[PlayGoTutorialSystem]:_load_profile_packages()")
end

function PlayGoTutorialSystem._unload_profile_packages(arg_25_0)
	local var_25_0 = arg_25_0._profile_packages

	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		Managers.package:unload(iter_25_0, "play_go_tutorial_system")

		var_25_0[iter_25_0] = nil
	end

	print("[PlayGoTutorialSystem]:_unload_profile_packages()")
end

function PlayGoTutorialSystem.register_dodge(arg_26_0, arg_26_1)
	if arg_26_0._tutorial_started then
		local var_26_0 = arg_26_0._tutorial_unit
		local var_26_1 = Vector3.x(arg_26_1)
		local var_26_2 = Vector3.y(arg_26_1)

		if math.abs(var_26_2) > math.abs(var_26_1) then
			Unit.flow_event(var_26_0, "lua_dodge_backward")
		elseif var_26_1 > 0 then
			Unit.flow_event(var_26_0, "lua_dodge_right")
		else
			Unit.flow_event(var_26_0, "lua_dodge_left")
		end
	end
end

function PlayGoTutorialSystem.register_push(arg_27_0, arg_27_1)
	if arg_27_0._tutorial_started and HEALTH_ALIVE[arg_27_1] then
		Unit.flow_event(arg_27_0._tutorial_unit, "lua_pushed_enemy")
	end
end

function PlayGoTutorialSystem.register_block(arg_28_0)
	if arg_28_0._tutorial_started then
		Unit.flow_event(arg_28_0._tutorial_unit, "lua_blocked_attack")
	end
end

function PlayGoTutorialSystem.register_killing_blow(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_0._tutorial_started and arg_29_2 == Managers.player:local_player().player_unit then
		local var_29_0 = arg_29_0._tutorial_unit
		local var_29_1 = arg_29_0._last_known_attack

		if arg_29_1 == "grenade" or arg_29_1 == "grenade_glance" then
			Unit.flow_event(var_29_0, "lua_grenade_attack")
		elseif var_29_1 == "light_attack" then
			Unit.flow_event(var_29_0, "lua_light_attack")
		elseif var_29_1 == "heavy_attack" then
			Unit.flow_event(var_29_0, "lua_heavy_attack")
		elseif var_29_1 == "arrow_hit" then
			Unit.flow_event(var_29_0, "lua_normal_ranged_attack")
		elseif var_29_1 == "zoomed_arrow_hit" then
			Unit.flow_event(var_29_0, "lua_alternative_ranged_attack")
		end
	end
end

function PlayGoTutorialSystem.register_unit(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	if not arg_30_0._tutorial_started then
		return
	end

	local var_30_0 = {}

	if Unit.get_data(arg_30_1, "Tutorial", "aggro_on_spawn") then
		local var_30_1 = Managers.player:local_player()

		ScriptUnit.extension(arg_30_2, "ai_system"):enemy_aggro(arg_30_2, var_30_1.player_unit)
	end

	Unit.set_flow_variable(arg_30_1, "lua_ai_spawned_unit_handle", arg_30_3)
	Unit.flow_event(arg_30_1, "lua_ai_spawned")

	if Unit.get_data(arg_30_1, "Tutorial", "highlight_on_spawn") then
		var_30_0.outline_id = ScriptUnit.extension(arg_30_2, "outline_system"):add_outline(OutlineSettings.templates.tutorial_highlight)
	end

	var_30_0.spawner_unit = arg_30_1
	var_30_0.ai_unit = arg_30_2

	table.insert(arg_30_0._spawned_ai_units, var_30_0)
end

function PlayGoTutorialSystem.teleport_unit(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	ScriptUnit.extension(arg_31_1, "locomotion_system"):teleport_to(arg_31_2, arg_31_3)

	if Unit.get_data(arg_31_1, "bot") then
		ScriptUnit.extension(arg_31_1, "ai_navigation_system"):teleport(arg_31_2)
	end
end

function PlayGoTutorialSystem.enable_bot_loot(arg_32_0, arg_32_1)
	arg_32_0._bot_loot_enabled = arg_32_1
end

function PlayGoTutorialSystem.bot_loot_enabled(arg_33_0)
	return arg_33_0._bot_loot_enabled
end

function PlayGoTutorialSystem.set_bot_portrait_enabled(arg_34_0, arg_34_1)
	arg_34_0._bot_portraits_enabled[arg_34_1] = true
end

function PlayGoTutorialSystem.bot_portrait_enabled(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_1.player_name

	return arg_35_0._bot_portraits_enabled[var_35_0]
end
