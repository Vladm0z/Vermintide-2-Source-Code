-- chunkname: @scripts/unit_extensions/weapons/weapon_unit_extension.lua

require("scripts/unit_extensions/weapons/actions/action_base")
require("scripts/unit_extensions/weapons/actions/action_ranged_base")
require("scripts/unit_extensions/weapons/actions/action_minigun")
require("scripts/unit_extensions/weapons/actions/action_minigun_spin")
require("scripts/unit_extensions/weapons/actions/action_charge")
require("scripts/unit_extensions/weapons/actions/action_dummy")
require("scripts/unit_extensions/weapons/actions/action_inspect")
require("scripts/unit_extensions/weapons/actions/action_melee_start")
require("scripts/unit_extensions/weapons/actions/action_wield")
require("scripts/unit_extensions/weapons/actions/action_bounty_hunter_handgun")
require("scripts/unit_extensions/weapons/actions/action_handgun")
require("scripts/unit_extensions/weapons/actions/action_interaction")
require("scripts/unit_extensions/weapons/actions/action_self_interaction")
require("scripts/unit_extensions/weapons/actions/action_push_stagger")
require("scripts/unit_extensions/weapons/actions/action_sweep")
require("scripts/unit_extensions/weapons/actions/action_block")
require("scripts/unit_extensions/weapons/actions/action_throw")
require("scripts/unit_extensions/weapons/actions/action_instant_wield")
require("scripts/unit_extensions/weapons/actions/action_staff")
require("scripts/unit_extensions/weapons/actions/action_bow")
require("scripts/unit_extensions/weapons/actions/action_true_flight_bow")
require("scripts/unit_extensions/weapons/actions/action_true_flight_bow_aim")
require("scripts/unit_extensions/weapons/actions/action_bullet_spray")
require("scripts/unit_extensions/weapons/actions/action_flamethrower")
require("scripts/unit_extensions/weapons/actions/action_warpfire_thrower")
require("scripts/unit_extensions/weapons/actions/action_aim")
require("scripts/unit_extensions/weapons/actions/action_reload")
require("scripts/unit_extensions/weapons/actions/action_shotgun")
require("scripts/unit_extensions/weapons/actions/action_crossbow")
require("scripts/unit_extensions/weapons/actions/action_cancel")
require("scripts/unit_extensions/weapons/actions/action_potion")
require("scripts/unit_extensions/weapons/actions/action_shield_slam")
require("scripts/unit_extensions/weapons/actions/action_charged_projectile")
require("scripts/unit_extensions/weapons/actions/action_beam")
require("scripts/unit_extensions/weapons/actions/action_geiser")
require("scripts/unit_extensions/weapons/actions/action_geiser_targeting")
require("scripts/unit_extensions/weapons/actions/action_throw_grimoire")
require("scripts/unit_extensions/weapons/actions/action_healing_draught")
require("scripts/unit_extensions/weapons/actions/action_career_aim")
require("scripts/unit_extensions/weapons/actions/action_career_dummy")
require("scripts/unit_extensions/weapons/actions/action_career_true_flight_aim")
require("scripts/unit_extensions/weapons/actions/action_career_dr_ranger")
require("scripts/unit_extensions/weapons/actions/action_career_bw_scholar")
require("scripts/unit_extensions/weapons/actions/action_career_we_waywatcher")
require("scripts/unit_extensions/weapons/actions/action_career_we_waywatcher_piercing")
require("scripts/unit_extensions/weapons/actions/action_career_wh_bountyhunter")

if Development.parameter("debug_weapons") then
	script_data.debug_weapons = true
end

local var_0_0 = {
	career_aim = ActionCareerAim,
	career_dummy = ActionCareerDummy,
	career_true_flight_aim = ActionCareerTrueFlightAim,
	charge = ActionCharge,
	dummy = ActionDummy,
	inspect = ActionInspect,
	melee_start = ActionMeleeStart,
	wield = ActionWield,
	bounty_hunter_handgun = ActionBountyHunterHandgun,
	handgun = ActionHandgun,
	interaction = ActionInteraction,
	self_interaction = ActionSelfInteraction,
	push_stagger = ActionPushStagger,
	sweep = ActionSweep,
	block = ActionBlock,
	throw = ActionThrow,
	staff = ActionStaff,
	bow = ActionBow,
	true_flight_bow = ActionTrueFlightBow,
	true_flight_bow_aim = ActionTrueFlightBowAim,
	crossbow = ActionCrossbow,
	cancel = ActionCancel,
	buff = ActionPotion,
	bullet_spray = ActionBulletSpray,
	aim = ActionAim,
	reload = ActionReload,
	shotgun = ActionShotgun,
	shield_slam = ActionShieldSlam,
	charged_projectile = ActionChargedProjectile,
	beam = ActionBeam,
	geiser_targeting = ActionGeiserTargeting,
	geiser = ActionGeiser,
	instant_wield = ActionInstantWield,
	throw_grimoire = ActionThrowGrimoire,
	healing_draught = ActionHealingDraught,
	flamethrower = ActionFlamethrower,
	warpfire_thrower = ActionWarpfireThrower,
	minigun = ActionMinigun,
	minigun_spin = ActionMinigunSpin,
	career_dr_three = ActionCareerDRRanger,
	career_bw_one = ActionCareerBWScholar,
	career_we_three = ActionCareerWEWaywatcher,
	career_we_three_piercing = ActionCareerWEWaywatcherPiercing,
	career_wh_two = ActionCareerWHBountyhunter
}

DLCUtils.require_list("action_template_file_names")
DLCUtils.map("action_classes_lookup", function (arg_1_0)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		var_0_0[iter_1_0] = _G[iter_1_1]
	end
end)

local function var_0_1(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	return var_0_0[arg_2_1]:new(arg_2_2, arg_2_0, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
end

local function var_0_2(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1.damage_window_start
	local var_3_1 = arg_3_1.damage_window_end

	if not var_3_0 and not var_3_1 then
		return false
	end

	local var_3_2 = ActionUtils.get_action_time_scale(arg_3_2, arg_3_1, false)
	local var_3_3 = var_3_0 / var_3_2

	var_3_1 = var_3_1 or arg_3_1.total_time or math.huge

	local var_3_4 = var_3_1 / var_3_2
	local var_3_5 = var_3_3 < arg_3_0
	local var_3_6 = arg_3_0 < var_3_4

	return var_3_5 and var_3_6
end

local function var_0_3(arg_4_0, arg_4_1)
	if arg_4_0 then
		local var_4_0 = arg_4_1.lookup_data
		local var_4_1 = arg_4_0[var_4_0.action_name]

		return var_4_1 and var_4_1[var_4_0.sub_action_name]
	end

	return nil
end

WeaponUnitExtension = class(WeaponUnitExtension)

WeaponUnitExtension.init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0.weapon_system = arg_5_3.weapon_system

	local var_5_0 = arg_5_1.world

	arg_5_0.world = var_5_0
	arg_5_0.wwise_world = Managers.world:wwise_world(var_5_0)
	arg_5_0.unit = arg_5_2

	local var_5_1 = arg_5_3.owner_unit

	arg_5_0.owner_unit = var_5_1
	arg_5_0.item_name = arg_5_3.item_name

	local var_5_2 = arg_5_3.first_person_rig

	arg_5_0.first_person_unit = var_5_2

	local var_5_3 = arg_5_3.skin_name
	local var_5_4 = WeaponSkins.skins[var_5_3]

	arg_5_0.weapon_skin_anim_overrides = var_5_4 and var_5_4.action_anim_overrides

	local var_5_5 = World.spawn_unit(var_5_0, "units/weapons/player/wpn_damage/wpn_damage")

	Unit.disable_physics(var_5_5)
	Unit.set_unit_visibility(var_5_5, false)

	if var_5_2 then
		local var_5_6 = arg_5_3.attach_nodes[1].source
		local var_5_7 = 0
		local var_5_8 = type(var_5_6) == "string" and Unit.node(var_5_2, var_5_6) or var_5_6
		local var_5_9 = type(var_5_7) == "string" and Unit.node(var_5_5, var_5_7) or var_5_7

		World.link_unit(var_5_0, var_5_5, var_5_9, var_5_2, var_5_8)
	end

	arg_5_0.actual_damage_unit = var_5_5
	arg_5_0.actions = {}
	arg_5_0.action_buff_data = {
		buff_start_times = {},
		buff_end_times = {},
		action_buffs_in_progress = {},
		buff_identifiers = {}
	}
	arg_5_0.cooldown_timer = {}
	arg_5_0.chain_action_sound_played = {}
	arg_5_0.is_server = Managers.state.network.network_transmit.is_server

	local var_5_10 = Managers.player:unit_owner(var_5_1)

	if var_5_10 and var_5_10.bot_player then
		arg_5_0.bot_attack_data = {
			request = {}
		}
	end

	arg_5_0.looping_audio_events = {}
	arg_5_0._current_weapon_buffs = {}
	arg_5_0._custom_data = {}
	arg_5_0._passive_update_actions = nil
	arg_5_0._passive_update_actions_n = 0

	local var_5_11 = rawget(ItemMasterList, arg_5_0.item_name)
	local var_5_12 = var_5_11 and var_5_11.template

	if var_5_12 then
		arg_5_0._weapon_template_name = var_5_12

		local var_5_13 = WeaponUtils.get_weapon_template(var_5_12)
		local var_5_14 = var_5_13.custom_data

		if var_5_14 then
			for iter_5_0, iter_5_1 in pairs(var_5_14) do
				if type(iter_5_1) == "table" then
					arg_5_0._custom_data[iter_5_0] = Script.new_table(iter_5_1.array_size or 0, iter_5_1.map_size or 0)
				else
					arg_5_0._custom_data[iter_5_0] = iter_5_1
				end
			end
		end

		arg_5_0._weapon_update = var_5_13 and var_5_13.update
		arg_5_0._weapon_wield = var_5_13 and var_5_13.on_wield
		arg_5_0._weapon_unwield = var_5_13 and var_5_13.on_unwield
		arg_5_0._synced_weapon_state = nil
		arg_5_0._synced_weapon_states = var_5_13 and var_5_13.synced_states

		if arg_5_0._synced_weapon_states then
			arg_5_0._synced_weapon_state_data = {}
		end
	end

	Managers.state.event:register(arg_5_0, "on_game_options_changed", "update_game_options")
	arg_5_0:update_game_options()
end

WeaponUnitExtension.update_game_options = function (arg_6_0)
	local var_6_0 = Application.user_setting("weapon_trails")

	Unit.set_data(arg_6_0.unit, "trails_enabled", var_6_0 ~= "none")
end

WeaponUnitExtension.cb_game_session_disconnect = function (arg_7_0)
	arg_7_0.sync_data_game_object_id = nil
end

WeaponUnitExtension.extensions_ready = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.ammo_extension = ScriptUnit.has_extension(arg_8_2, "ammo_system")

	local var_8_0 = arg_8_0.owner_unit

	arg_8_0.first_person_extension = ScriptUnit.extension(var_8_0, "first_person_system")
	arg_8_0._buff_extension = ScriptUnit.extension(var_8_0, "buff_system")
	arg_8_0._talent_extension = ScriptUnit.has_extension(var_8_0, "talent_system")
end

WeaponUnitExtension.unlink_damage_unit = function (arg_9_0)
	if arg_9_0.actual_damage_unit then
		World.unlink_unit(arg_9_0.world, arg_9_0.actual_damage_unit)
	end
end

WeaponUnitExtension.destroy = function (arg_10_0)
	Managers.state.event:unregister("on_game_options_changed", arg_10_0)

	if arg_10_0._synced_weapon_state then
		local var_10_0 = arg_10_0._synced_weapon_states[arg_10_0._synced_weapon_state]

		if var_10_0.leave then
			var_10_0:leave(arg_10_0.owner_unit, arg_10_0.unit, arg_10_0._synced_weapon_state_data, arg_10_0:_is_local_player(), arg_10_0.world, nil, true)
		end
	end

	if arg_10_0.current_action_settings then
		local var_10_1 = arg_10_0.current_action_settings.buff_data

		if var_10_1 then
			ActionUtils.remove_action_buff_data(arg_10_0.action_buff_data, var_10_1, arg_10_0.owner_unit)
		end

		local var_10_2 = arg_10_0.current_action_settings.kind
		local var_10_3 = arg_10_0.actions[var_10_2]

		if var_10_3.destroy then
			var_10_3:destroy()
		end
	end

	for iter_10_0 in pairs(arg_10_0.looping_audio_events) do
		arg_10_0:stop_looping_audio(iter_10_0)
	end

	if arg_10_0.first_person_unit then
		World.unlink_unit(arg_10_0.world, arg_10_0.actual_damage_unit)
	end
end

WeaponUnitExtension.get_action = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	return arg_11_3[arg_11_1][arg_11_2]
end

local var_0_4 = {}

local function var_0_5(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if arg_12_0 then
		local var_12_0 = arg_12_1.anim_event_from_chain

		if var_12_0 then
			local var_12_1 = arg_12_0.lookup_data
			local var_12_2 = var_12_0[var_12_1.action_name]

			if var_12_2 then
				local var_12_3 = var_12_2[var_12_1.sub_action_name]

				if var_12_3 and var_12_3[arg_12_3] then
					return var_12_3[arg_12_3]
				end
			end
		end
	end

	return arg_12_2 and arg_12_2[arg_12_3] or arg_12_1[arg_12_3]
end

WeaponUnitExtension.start_action = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0 = arg_13_0.owner_unit
	local var_13_1 = ScriptUnit.extension(var_13_0, "buff_system")
	local var_13_2 = ScriptUnit.has_extension(var_13_0, "talent_system")
	local var_13_3 = arg_13_0.first_person_extension
	local var_13_4 = ScriptUnit.extension(var_13_0, "status_system")
	local var_13_5 = arg_13_0.current_action_settings
	local var_13_6 = arg_13_1
	local var_13_7 = arg_13_2

	if not arg_13_0.player then
		local var_13_8 = Managers.player:unit_owner(var_13_0)

		arg_13_0.is_bot = var_13_8 and not var_13_8:is_player_controlled()
		arg_13_0.is_local = var_13_8 and not var_13_8.remote
		arg_13_0.player = var_13_8
	end

	table.clear(var_0_4)

	if var_13_6 then
		local var_13_9 = arg_13_0:get_action(var_13_6, var_13_7, arg_13_3)
		local var_13_10, var_13_11, var_13_12 = ActionUtils.resolve_action_selector(var_13_9, var_13_2, var_13_1, arg_13_0, var_13_0)

		var_13_7 = var_13_12
		var_13_6 = var_13_11

		local var_13_13 = var_13_10.kind

		if not arg_13_0.actions[var_13_13] then
			local var_13_14 = var_0_1(arg_13_0.item_name, var_13_13, arg_13_0.world, arg_13_0.is_server, var_13_0, arg_13_0.actual_damage_unit, arg_13_0.first_person_unit, arg_13_0.unit, arg_13_0.weapon_system)

			arg_13_0.actions[var_13_13] = var_13_14

			if var_13_14.passive_update then
				if not arg_13_0._passive_update_actions then
					arg_13_0._passive_update_actions = {
						var_13_14
					}
					arg_13_0._passive_update_actions_n = 1
				else
					local var_13_15 = arg_13_0._passive_update_actions_n + 1

					arg_13_0._passive_update_actions[var_13_15] = var_13_14
					arg_13_0._passive_update_actions_n = var_13_15
				end
			end
		end
	end

	local var_13_16 = arg_13_0.ammo_extension

	if var_13_16 ~= nil and var_13_6 then
		local var_13_17 = arg_13_0:get_action(var_13_6, var_13_7, arg_13_3)
		local var_13_18 = var_13_17.ammo_requirement or var_13_17.ammo_usage or 0
		local var_13_19 = var_13_16:ammo_count()
		local var_13_20 = var_13_17.can_abort_reload == nil and true or var_13_17.can_abort_reload

		if var_13_16:is_reloading() then
			if var_13_18 <= var_13_19 and var_13_20 then
				var_13_16:abort_reload()
			else
				var_13_6 = nil
				var_13_7 = nil
			end
		elseif var_13_19 < var_13_18 then
			if var_13_16:total_remaining_ammo() == 0 and (not arg_13_0.reload_failed_timer or arg_13_4 > arg_13_0.reload_failed_timer) and (not var_13_17.interaction_type or var_13_17.interaction_type ~= "heal") and not var_13_17.no_out_of_ammo_vo then
				local var_13_21 = ScriptUnit.extension_input(var_13_0, "dialogue_system")
				local var_13_22 = FrameTable.alloc_table()

				var_13_22.fail_reason = "out_of_ammo"
				var_13_22.item_name = "ranged_weapon"

				local var_13_23 = "reload_failed"

				var_13_21:trigger_networked_dialogue_event(var_13_23, var_13_22)

				arg_13_0.reload_failed_timer = arg_13_4 + 5
			end

			var_13_6 = nil
			var_13_7 = nil
		end
	end

	local var_13_24
	local var_13_25

	if var_13_6 and var_13_5 then
		var_13_25 = var_13_5
		var_0_4.new_action = var_13_6
		var_0_4.new_sub_action = var_13_7
		var_0_4.new_action_settings = arg_13_0:get_action(var_13_6, var_13_7, arg_13_3)
		var_13_24 = arg_13_0:_finish_action("new_interupting_action", var_0_4)
	end

	if var_13_6 then
		local var_13_26 = ScriptUnit.extension(var_13_0, "locomotion_system")

		if var_13_26:is_stood_still() then
			local var_13_27 = var_13_3:current_rotation()

			var_13_26:set_stood_still_target_rotation(var_13_27)
		end

		local var_13_28 = var_13_5 ~= nil
		local var_13_29 = arg_13_0:get_action(var_13_6, var_13_7, arg_13_3)

		var_13_3:set_weapon_sway_settings(var_13_29.weapon_sway_settings)

		if not var_13_28 and var_13_29.aim_at_gaze_setting then
			ScriptUnit.extension(var_13_0, "status_system"):set_is_aiming(true)

			if ScriptUnit.has_extension(var_13_0, "eyetracking_system") then
				local var_13_30 = ScriptUnit.extension(var_13_0, "eyetracking_system")

				var_13_30:set_is_aiming(true)

				if var_13_30:get_is_feature_enabled("tobii_aim_at_gaze") then
					local var_13_31 = var_13_30:gaze_rotation()

					var_13_3:force_look_rotation(var_13_31, 1)
				end
			end
		end

		arg_13_0.current_action_name = var_13_6
		arg_13_0.current_sub_action_name = var_13_7
		arg_13_0.current_action_settings = var_13_29

		local var_13_32 = arg_13_0.first_person_unit

		if not var_13_29.looping_anim then
			local var_13_33 = var_13_29.wield_blend_event or "equip_interrupt"

			Unit.animation_event(var_13_32, var_13_33)
		end

		table.clear(arg_13_0.chain_action_sound_played)

		local var_13_34 = #var_13_29.allowed_chain_actions

		for iter_13_0 = 1, var_13_34 do
			arg_13_0.chain_action_sound_played[iter_13_0] = false
		end

		local var_13_35 = var_13_29.kind
		local var_13_36 = arg_13_0.actions[var_13_35]
		local var_13_37 = var_13_29.total_time
		local var_13_38 = ActionUtils.get_action_time_scale(var_13_0, var_13_29)
		local var_13_39 = var_13_37 / var_13_38
		local var_13_40 = var_0_3(arg_13_0.weapon_skin_anim_overrides, var_13_29)
		local var_13_41 = var_0_5(var_13_25, var_13_29, var_13_40, "pre_action_anim_event")

		if var_13_41 then
			local var_13_42 = ActionUtils.get_action_time_scale(var_13_0, var_13_29, true)
			local var_13_43 = math.clamp(var_13_42, NetworkConstants.animation_variable_float.min, NetworkConstants.animation_variable_float.max)

			if type(var_13_41) == "table" then
				for iter_13_1 = 1, #var_13_41 do
					arg_13_0:_play_3p_anim(var_13_41[iter_13_1], var_13_41[iter_13_1], var_13_0, nil, var_13_43)
					arg_13_0:_play_1p_anim(var_13_41[iter_13_1], var_13_41[iter_13_1], var_13_32, nil, var_13_43)
				end
			else
				arg_13_0:_play_3p_anim(var_13_41, var_13_41, var_13_0, nil, var_13_43)
				arg_13_0:_play_1p_anim(var_13_41, var_13_41, var_13_32, nil, var_13_43)
			end
		end

		local var_13_44 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event")
		local var_13_45 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_1p") or var_13_44
		local var_13_46 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_3p") or var_13_44
		local var_13_47 = var_0_5(var_13_25, var_13_29, var_13_40, "looping_anim")

		for iter_13_2, iter_13_3 in pairs(arg_13_0.action_buff_data) do
			table.clear(iter_13_3)
		end

		local var_13_48 = var_13_29.buff_data

		if var_13_48 then
			ActionUtils.init_action_buff_data(arg_13_0.action_buff_data, var_13_48, arg_13_4)

			arg_13_0.buff_data = var_13_48
		end

		var_13_4._current_action = var_13_6

		var_13_36:client_owner_start_action(var_13_29, arg_13_4, var_13_24, arg_13_5, arg_13_6)

		local var_13_49 = var_13_29.aim_assist_ramp_multiplier

		if var_13_49 then
			local var_13_50 = var_13_29.aim_assist_max_ramp_multiplier
			local var_13_51 = var_13_29.aim_assist_ramp_decay_delay

			var_13_3:increase_aim_assist_multiplier(var_13_49, var_13_50, var_13_51)
		end

		if arg_13_0.ammo_extension then
			if arg_13_0.ammo_extension:total_remaining_ammo() == 0 then
				var_13_44 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_no_ammo_left") or var_13_44
				var_13_45 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_no_ammo_left_1p") or var_13_45 or var_13_44
				var_13_46 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_no_ammo_left_3p") or var_13_46 or var_13_44
			elseif arg_13_0.ammo_extension:total_remaining_ammo() == 1 then
				var_13_44 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_last_ammo") or var_13_44
				var_13_45 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_last_ammo_1p") or var_13_45
				var_13_46 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_last_ammo_3p") or var_13_46
			end
		end

		if var_13_1 and var_13_1:has_buff_perk("infinite_ammo") then
			var_13_44 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_infinite_ammo") or var_13_44
			var_13_45 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_infinite_ammo_1p") or var_13_45 or var_13_44
			var_13_46 = var_0_5(var_13_25, var_13_29, var_13_40, "anim_event_infinite_ammo_3p") or var_13_46 or var_13_44
		end

		arg_13_0.action_time_started = arg_13_4
		arg_13_0.action_time_scale = var_13_38
		arg_13_0.action_time_done = arg_13_4 + var_13_39

		if var_13_29.cooldown then
			local var_13_52 = var_13_29.lookup_data

			arg_13_0.cooldown_timer[var_13_52.action_name] = arg_13_4 + var_13_29.cooldown
		end

		if var_13_29.enter_function then
			local var_13_53 = arg_13_0:get_scaled_min_hold_time(var_13_29)
			local var_13_54 = ScriptUnit.extension(var_13_0, "input_system")
			local var_13_55 = arg_13_0.action_time_started + var_13_53 - arg_13_4

			var_13_29.enter_function(var_13_0, var_13_54, var_13_55, arg_13_0)
		end

		local var_13_56 = ActionUtils.get_action_time_scale(var_13_0, var_13_29, true)
		local var_13_57 = math.clamp(var_13_56, NetworkConstants.animation_variable_float.min, NetworkConstants.animation_variable_float.max)

		if var_13_46 then
			if type(var_13_46) == "table" then
				for iter_13_4 = 1, #var_13_46 do
					arg_13_0:_play_3p_anim(var_13_46[iter_13_4], (var_13_44 or var_13_46)[iter_13_4], var_13_0, var_13_47, var_13_57)
				end
			else
				arg_13_0:_play_3p_anim(var_13_46, var_13_44 or var_13_46, var_13_0, var_13_47, var_13_57)
			end
		end

		if var_13_45 then
			if type(var_13_45) == "table" then
				for iter_13_5 = 1, #var_13_45 do
					arg_13_0:_play_1p_anim(var_13_45[iter_13_5], (var_13_44 or var_13_45)[iter_13_5], var_13_32, var_13_47, var_13_57)
				end
			else
				arg_13_0:_play_1p_anim(var_13_45, var_13_44 or var_13_45, var_13_32, var_13_47, var_13_57)
			end
		end

		if (var_13_46 or var_13_45) and var_13_29.apply_recoil then
			var_13_3:apply_recoil()
			var_13_3:play_camera_recoil(var_13_29.recoil_settings, arg_13_4)
		end
	end
end

WeaponUnitExtension._play_1p_anim = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	if not IS_WINDOWS and not IS_LINUX and arg_14_2 == "attack_shoot" then
		arg_14_5 = arg_14_5 * 1.2
	end

	arg_14_0.first_person_extension:animation_set_variable("attack_speed", arg_14_5)

	if not arg_14_4 or arg_14_4 and not arg_14_0._looping_anim_event_started then
		Unit.animation_event(arg_14_3, arg_14_2)

		if arg_14_4 then
			arg_14_0._looping_anim_event_started = true
		end
	end
end

WeaponUnitExtension._play_3p_anim = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = Managers.state.unit_storage:go_id(arg_15_3)
	local var_15_1 = NetworkLookup.anims[arg_15_1]
	local var_15_2 = NetworkLookup.anims.attack_speed

	if not LEVEL_EDITOR_TEST then
		if arg_15_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event_variable_float", var_15_1, var_15_0, var_15_2, arg_15_5)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event_variable_float", var_15_1, var_15_0, var_15_2, arg_15_5)
		end
	end

	if not IS_WINDOWS and not IS_LINUX and arg_15_2 == "attack_shoot" then
		arg_15_5 = arg_15_5 * 1.2
	end

	if not script_data.disable_third_person_weapon_animation_events then
		local var_15_3
		local var_15_4 = Unit.animation_find_variable(arg_15_3, "attack_speed")

		Unit.animation_set_variable(arg_15_3, var_15_4, arg_15_5)

		if not arg_15_4 or arg_15_4 and not arg_15_0._looping_anim_event_started then
			Unit.animation_event(arg_15_3, arg_15_1)

			if arg_15_4 then
				arg_15_0._looping_anim_event_started = true
			end
		end
	end
end

WeaponUnitExtension.stop_action = function (arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0:has_current_action() and not arg_16_0._currently_stopping_action then
		arg_16_0._currently_stopping_action = true

		arg_16_0:_finish_action(arg_16_1, arg_16_2)

		arg_16_0._currently_stopping_action = false
	end
end

WeaponUnitExtension._finish_action = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.current_action_settings
	local var_17_1 = var_17_0.kind
	local var_17_2 = arg_17_0.actions[var_17_1]

	if Application.user_setting("tobii_eyetracking") and ScriptUnit.has_extension(arg_17_0.owner_unit, "eyetracking_system") then
		local var_17_3 = ScriptUnit.extension(arg_17_0.owner_unit, "eyetracking_system")

		if arg_17_1 == "hold_input_released" then
			var_17_3:set_is_aiming(false)
			var_17_3:set_aim_at_gaze_cancelled(false)
		end
	end

	if arg_17_1 == "hold_input_released" then
		ScriptUnit.has_extension(arg_17_0.owner_unit, "status_system"):set_is_aiming(false)
	end

	local var_17_4 = var_17_0.buff_data

	if var_17_4 then
		ActionUtils.remove_action_buff_data(arg_17_0.action_buff_data, var_17_4, arg_17_0.owner_unit)
	end

	for iter_17_0, iter_17_1 in pairs(arg_17_0.action_buff_data) do
		table.clear(iter_17_1)
	end

	local var_17_5 = var_17_2:finish(arg_17_1, arg_17_2)

	arg_17_0:anim_end_event(arg_17_1, var_17_0)

	local var_17_6 = arg_17_2 and arg_17_2.new_action_settings
	local var_17_7 = var_17_6 and var_17_6.on_chain_keep_audio_loops

	if var_17_7 then
		for iter_17_2 in pairs(arg_17_0.looping_audio_events) do
			if not table.contains(var_17_7, iter_17_2) then
				arg_17_0:stop_looping_audio(iter_17_2)
			end
		end
	else
		for iter_17_3 in pairs(arg_17_0.looping_audio_events) do
			arg_17_0:stop_looping_audio(iter_17_3)
		end
	end

	if var_17_0.finish_function then
		var_17_0.finish_function(arg_17_0.owner_unit, arg_17_1, arg_17_0)
	end

	local var_17_8 = arg_17_0.first_person_extension

	if var_17_8 then
		local var_17_9 = arg_17_0:_weapon_template()
		local var_17_10 = var_17_9 and var_17_9.weapon_sway_settings

		var_17_8:set_weapon_sway_settings(var_17_10)
	end

	if arg_17_0.bot_attack_data then
		arg_17_0:clear_bot_attack_request()
	end

	arg_17_0.current_action_settings = nil
	arg_17_0.action_time_scale = nil

	return var_17_5
end

WeaponUnitExtension._weapon_template = function (arg_18_0)
	return WeaponUtils.get_weapon_template(arg_18_0._weapon_template_name)
end

WeaponUnitExtension.anim_end_event = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_2.anim_end_event_condition_func

	if not var_19_0 and true or var_19_0(arg_19_0.owner_unit, arg_19_1, arg_19_0.ammo_extension) then
		local var_19_1 = var_0_3(arg_19_0.weapon_skin_anim_overrides, arg_19_2)
		local var_19_2 = var_19_1 and var_19_1.anim_end_event or arg_19_2.anim_end_event
		local var_19_3 = var_19_1 and var_19_1.anim_end_event_1p or arg_19_2.anim_end_event_1p
		local var_19_4 = var_19_1 and var_19_1.anim_end_event_3p or arg_19_2.anim_end_event_3p

		if var_19_2 then
			if type(var_19_2) == "table" then
				for iter_19_0 = 1, #var_19_2 do
					arg_19_0:_play_end_event_1p(var_19_2[iter_19_0])
					arg_19_0:_play_end_event_3p(var_19_2[iter_19_0])
				end
			else
				arg_19_0:_play_end_event_1p(var_19_2)
				arg_19_0:_play_end_event_3p(var_19_2)
			end
		end

		if var_19_3 then
			if type(var_19_3) == "table" then
				for iter_19_1 = 1, #var_19_3 do
					arg_19_0:_play_end_event_1p(var_19_3[iter_19_1])
				end
			else
				arg_19_0:_play_end_event_1p(var_19_3)
			end
		end

		if var_19_4 then
			if type(var_19_4) == "table" then
				for iter_19_2 = 1, #var_19_4 do
					arg_19_0:_play_end_event_3p(var_19_4[iter_19_2])
				end
			else
				arg_19_0:_play_end_event_3p(var_19_4)
			end
		end

		arg_19_0._looping_anim_event_started = nil
	end
end

WeaponUnitExtension._play_end_event_3p = function (arg_20_0, arg_20_1)
	local var_20_0 = NetworkLookup.anims[arg_20_1]
	local var_20_1 = Managers.state.unit_storage:go_id(arg_20_0.owner_unit)

	if not LEVEL_EDITOR_TEST then
		if arg_20_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event", var_20_0, var_20_1)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event", var_20_0, var_20_1)
		end
	end

	if not script_data.disable_third_person_weapon_animation_events then
		Unit.animation_event(arg_20_0.owner_unit, arg_20_1)
	end
end

WeaponUnitExtension._play_end_event_1p = function (arg_21_0, arg_21_1)
	Unit.animation_event(arg_21_0.first_person_unit, arg_21_1)
end

WeaponUnitExtension.trigger_anim_event = function (arg_22_0, arg_22_1)
	if arg_22_1 then
		local var_22_0 = NetworkLookup.anims[arg_22_1]

		if not LEVEL_EDITOR_TEST then
			local var_22_1 = Managers.state.unit_storage:go_id(arg_22_0.owner_unit)

			if arg_22_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event", var_22_0, var_22_1)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event", var_22_0, var_22_1)
			end
		end

		Unit.animation_event(arg_22_0.first_person_unit, arg_22_1)

		if not script_data.disable_third_person_weapon_animation_events then
			Unit.animation_event(arg_22_0.owner_unit, arg_22_1)
		end

		arg_22_0._looping_anim_event_started = nil
	end
end

WeaponUnitExtension.update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	local var_23_0 = arg_23_0.current_action_settings

	if var_23_0 then
		local var_23_1 = arg_23_0.owner_unit
		local var_23_2 = Managers.world:wwise_world(arg_23_0.world)
		local var_23_3 = var_23_0.allowed_chain_actions
		local var_23_4 = #var_23_3

		for iter_23_0 = 1, var_23_4 do
			local var_23_5 = var_23_3[iter_23_0]
			local var_23_6 = var_23_5.chain_ready_sound

			if var_23_6 then
				local var_23_7 = var_23_5.sound_time_offset or 0

				if arg_23_0:is_chain_action_available(var_23_5, arg_23_5, var_23_7) and not arg_23_0.chain_action_sound_played[iter_23_0] then
					WwiseWorld.trigger_event(var_23_2, var_23_6)

					arg_23_0.chain_action_sound_played[iter_23_0] = true
				end
			end
		end

		if arg_23_5 > arg_23_0.action_time_done then
			arg_23_0:_finish_action("action_complete")
		else
			local var_23_8 = arg_23_5 - arg_23_0.action_time_started
			local var_23_9 = var_0_2(var_23_8, arg_23_0.current_action_settings, var_23_1)
			local var_23_10 = var_23_0.kind
			local var_23_11 = arg_23_0.actions[var_23_10]
			local var_23_12 = var_23_0.buff_data

			if var_23_12 then
				ActionUtils.update_action_buff_data(arg_23_0.action_buff_data, var_23_12, var_23_1, arg_23_5)
			end

			var_23_11:client_owner_post_update(arg_23_3, arg_23_5, arg_23_0.world, var_23_9, var_23_8)

			if var_23_0.cooldown and not var_23_0.cooldown_from_start then
				local var_23_13 = var_23_0.lookup_data

				arg_23_0.cooldown_timer[var_23_13.action_name] = arg_23_5 + var_23_0.cooldown
			end
		end
	end

	local var_23_14 = arg_23_0._passive_update_actions

	for iter_23_1 = 1, arg_23_0._passive_update_actions_n do
		var_23_14[iter_23_1]:passive_update(arg_23_3, arg_23_5)
	end

	if arg_23_0._weapon_update then
		arg_23_0._weapon_update(arg_23_0, arg_23_3, arg_23_5)
	end

	if arg_23_0._synced_weapon_state then
		local var_23_15 = arg_23_0._synced_weapon_states[arg_23_0._synced_weapon_state]

		if var_23_15.update then
			var_23_15:update(arg_23_0.owner_unit, arg_23_0.unit, arg_23_0._synced_weapon_state_data, arg_23_0:_is_local_player(), arg_23_0.world, arg_23_3, arg_23_0)
		end
	end
end

WeaponUnitExtension._is_local_player = function (arg_24_0)
	local var_24_0 = Managers.player:owner(arg_24_0.owner_unit)

	return var_24_0 and var_24_0.local_player
end

WeaponUnitExtension.is_streak_action_available = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_0.current_action_settings or arg_25_0.temporary_action_settings
	local var_25_1 = arg_25_0.actions[var_25_0.kind]
	local var_25_2 = arg_25_2 - arg_25_0.action_time_started

	if var_25_1.streak_available and var_25_1:streak_available(var_25_2, arg_25_1) and arg_25_0:is_chain_action_available(arg_25_1, arg_25_2, arg_25_3) then
		return true
	end

	return false
end

WeaponUnitExtension.is_chain_action_available = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = arg_26_0.current_action_settings or arg_26_0.temporary_action_settings
	local var_26_1 = arg_26_2 - arg_26_0.action_time_started
	local var_26_2 = var_26_0.total_time + 2

	arg_26_3 = arg_26_3 or 0

	local var_26_3 = arg_26_0.action_time_scale or ActionUtils.get_action_time_scale(arg_26_0.owner_unit, var_26_0)

	if arg_26_1.auto_chain then
		return var_26_1 >= (arg_26_1.start_time and arg_26_1.start_time / var_26_3 or var_26_2) + arg_26_3
	else
		local var_26_4 = arg_26_1.end_time and arg_26_1.end_time / var_26_3 or var_26_2

		return var_26_1 >= arg_26_1.start_time / var_26_3 + arg_26_3 and var_26_1 <= var_26_4
	end
end

WeaponUnitExtension.time_to_next_chain_action = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	arg_27_4 = arg_27_4 or arg_27_0.current_action_settings or arg_27_0.temporary_action_settings

	local var_27_0 = arg_27_0:has_current_action() and arg_27_2 - arg_27_0.action_time_started or 0
	local var_27_1 = arg_27_4.total_time + 2

	arg_27_3 = arg_27_3 or 0

	local var_27_2 = ActionUtils.get_action_time_scale(arg_27_0.owner_unit, arg_27_4)

	return (arg_27_1.start_time and arg_27_1.start_time / var_27_2 or var_27_1) + arg_27_3 - var_27_0
end

WeaponUnitExtension.get_scaled_min_hold_time = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_1.minimum_hold_time

	if not var_28_0 then
		return 0
	end

	local var_28_1 = ScriptUnit.extension(arg_28_0.owner_unit, "buff_system")
	local var_28_2 = var_28_0

	if var_28_1 then
		var_28_2 = var_28_1:apply_buffs_to_value(var_28_2, "reload_speed")

		if var_28_2 > 0 then
			var_28_2 = var_28_2 / ActionUtils.get_action_time_scale(arg_28_0.owner_unit, arg_28_1, false, 1)
		end
	end

	return var_28_2
end

WeaponUnitExtension.can_stop_hold_action = function (arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1 - arg_29_0.action_time_started
	local var_29_1 = arg_29_0.current_action_settings

	if not var_29_1.minimum_hold_time then
		return true
	end

	return var_29_0 > arg_29_0:get_scaled_min_hold_time(var_29_1)
end

WeaponUnitExtension.get_action_cooldown = function (arg_30_0, arg_30_1)
	return arg_30_0.cooldown_timer[arg_30_1]
end

WeaponUnitExtension.get_current_action = function (arg_31_0)
	return arg_31_0.actions[arg_31_0.current_action_settings.kind]
end

WeaponUnitExtension.has_current_action = function (arg_32_0)
	return arg_32_0.current_action_settings ~= nil
end

WeaponUnitExtension.get_current_action_settings = function (arg_33_0)
	return arg_33_0.current_action_settings
end

WeaponUnitExtension.is_after_damage_window = function (arg_34_0)
	local var_34_0 = arg_34_0.current_action_settings

	if not var_34_0 then
		return false
	end

	local var_34_1 = var_34_0.damage_window_start
	local var_34_2 = var_34_0.damage_window_end

	if not var_34_1 and not var_34_2 then
		return false
	end

	local var_34_3 = arg_34_0.owner_unit
	local var_34_4 = Managers.time:time("game") - arg_34_0.action_time_started
	local var_34_5 = ActionUtils.get_action_time_scale(var_34_3, var_34_0, false)

	var_34_2 = var_34_2 or var_34_0.total_time or math.huge

	return var_34_4 >= var_34_2 / var_34_5
end

WeaponUnitExtension.bot_should_stop_attack_on_leave = function (arg_35_0)
	local var_35_0 = arg_35_0.current_action_settings

	if var_35_0 then
		return var_35_0.stop_action_on_leave_for_bot
	end
end

WeaponUnitExtension._is_before_end_time = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0.current_action_settings or arg_36_0.temporary_action_settings
	local var_36_1 = arg_36_2 - arg_36_0.action_time_started
	local var_36_2 = var_36_0.total_time + 2
	local var_36_3 = ActionUtils.get_action_time_scale(arg_36_0.owner_unit, var_36_0)

	return var_36_1 < (arg_36_1.end_time and arg_36_1.end_time / var_36_3 or var_36_2)
end

WeaponUnitExtension._find_chain_action = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	local var_37_0 = 0
	local var_37_1 = #arg_37_2
	local var_37_2
	local var_37_3

	for iter_37_0 = 1, var_37_1 do
		local var_37_4 = arg_37_2[iter_37_0]

		if var_37_4.input == arg_37_4 then
			var_37_0 = var_37_0 + 1

			if var_37_0 == arg_37_5 then
				var_37_2 = var_37_4

				break
			end
		end
	end

	if var_37_2 then
		local var_37_5 = var_37_2.action
		local var_37_6 = var_37_2.sub_action

		var_37_3 = arg_37_1[var_37_5][var_37_6]

		local var_37_7, var_37_8

		var_37_3, var_37_7, var_37_8 = ActionUtils.resolve_action_selector(var_37_3, arg_37_0._talent_extension, arg_37_0._buff_extension, arg_37_0, arg_37_0.unit)

		if arg_37_0.current_action_settings and not arg_37_0:_is_before_end_time(var_37_2, arg_37_3) then
			return nil
		end
	end

	return var_37_2, var_37_3
end

WeaponUnitExtension._get_attack_chain_data = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0
	local var_38_1
	local var_38_2
	local var_38_3 = "hold_attack"
	local var_38_4
	local var_38_5 = arg_38_0.current_action_settings

	if var_38_5 then
		var_38_2 = var_38_5
	else
		local var_38_6 = arg_38_2.start_action_name
		local var_38_7 = arg_38_2.start_sub_action_name

		var_38_2 = arg_38_1[var_38_6][var_38_7]
	end

	local var_38_8 = var_38_2.lookup_data
	local var_38_9 = var_38_8.action_name
	local var_38_10 = var_38_8.sub_action_name
	local var_38_11 = arg_38_2.transitions[var_38_9][var_38_10]

	if var_38_11 == nil then
		return nil
	end

	local var_38_12 = var_38_11.chain_action

	if var_38_5 and not arg_38_0:_is_before_end_time(var_38_12, arg_38_3) then
		return nil
	end

	local var_38_13 = arg_38_1[var_38_12.action][var_38_12.sub_action_name]

	var_38_3 = var_38_11.bot_wait_input or var_38_3
	var_38_4 = var_38_11.bot_wanted_input or var_38_4

	return var_38_12, var_38_13, var_38_2, var_38_3, var_38_4
end

WeaponUnitExtension._process_bot_attack_request = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	if arg_39_5 then
		return arg_39_0:_get_attack_chain_data(arg_39_2, arg_39_5, arg_39_4)
	end

	local var_39_0
	local var_39_1
	local var_39_2
	local var_39_3 = "action_one_release"
	local var_39_4 = "hold_attack"
	local var_39_5
	local var_39_6 = arg_39_1 == "tap_attack" and 1 or arg_39_1 == "hold_attack" and 2

	if arg_39_0.current_action_settings then
		var_39_2 = arg_39_0.current_action_settings

		local var_39_7 = var_39_2.allowed_chain_actions

		var_39_0, var_39_1 = arg_39_0:_find_chain_action(arg_39_2, var_39_7, arg_39_4, var_39_3, var_39_6)

		if var_39_0 == nil and var_39_2.kind ~= "block" then
			var_39_4 = nil
			var_39_5 = "tap_attack"
			var_39_0, var_39_1 = arg_39_0:_find_chain_action(arg_39_2, var_39_7, arg_39_4, "action_one", 1)
		end
	else
		var_39_2 = ActionUtils.resolve_action_selector(arg_39_2.action_one.default)
		var_39_0, var_39_1 = arg_39_0:_find_chain_action(arg_39_2, var_39_2.allowed_chain_actions, arg_39_4, var_39_3, var_39_6)
	end

	return var_39_0, var_39_1, var_39_2, var_39_4, var_39_5
end

WeaponUnitExtension.update_bot_attack_request = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0.bot_attack_data
	local var_40_1 = var_40_0.request

	if var_40_1.attack_type then
		local var_40_2, var_40_3, var_40_4, var_40_5, var_40_6 = arg_40_0:_process_bot_attack_request(var_40_1.attack_type, var_40_1.actions, var_40_1.weapon_name, arg_40_1, var_40_1.attack_chain)

		if var_40_2 then
			var_40_0.chain_action = var_40_2
			var_40_0.chain_action_settings = var_40_3
			var_40_0.action_settings = var_40_4
			var_40_0.wait_input = var_40_5
			var_40_0.wanted_input = var_40_6
		end

		table.clear(var_40_1)
	end

	local var_40_7 = var_40_0.chain_action

	if var_40_7 == nil then
		return
	end

	local var_40_8

	if arg_40_0.current_action_settings and arg_40_0:is_chain_action_available(var_40_7, arg_40_1) then
		var_40_8 = var_40_0.wanted_input

		arg_40_0:clear_bot_attack_request()
	else
		var_40_8 = var_40_0.wait_input
	end

	if var_40_8 then
		local var_40_9 = arg_40_0.owner_unit
		local var_40_10 = ScriptUnit.extension(var_40_9, "input_system")

		var_40_10[var_40_8](var_40_10)
	end
end

WeaponUnitExtension.request_bot_attack_action = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	local var_41_0 = arg_41_0.bot_attack_data
	local var_41_1 = var_41_0.request

	if var_41_0.chain_action or var_41_1.attack_type then
		return false
	else
		var_41_1.attack_type = arg_41_1
		var_41_1.actions = arg_41_2
		var_41_1.weapon_name = arg_41_3
		var_41_1.attack_chain = arg_41_4

		return true
	end
end

WeaponUnitExtension.clear_bot_attack_request = function (arg_42_0)
	local var_42_0 = arg_42_0.bot_attack_data
	local var_42_1 = var_42_0.request

	table.clear(var_42_1)
	table.clear(var_42_0)

	var_42_0.request = var_42_1
end

WeaponUnitExtension.is_starting_attack = function (arg_43_0)
	local var_43_0 = arg_43_0.current_action_settings

	return ActionUtils.is_melee_start_sub_action(var_43_0)
end

WeaponUnitExtension.time_to_next_attack = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5)
	local var_44_0 = arg_44_0.bot_attack_data
	local var_44_1
	local var_44_2
	local var_44_3

	if var_44_0.chain_action then
		var_44_1 = var_44_0.chain_action
		var_44_3 = var_44_0.action_settings
	else
		local var_44_4 = var_44_0.request
		local var_44_5 = var_44_4.attack_type or arg_44_1
		local var_44_6 = var_44_4.actions or arg_44_2
		local var_44_7 = var_44_4.weapon_name or arg_44_3

		arg_44_5 = var_44_4.attack_chain or arg_44_5

		local var_44_8

		var_44_1, var_44_8, var_44_3 = arg_44_0:_process_bot_attack_request(var_44_5, var_44_6, var_44_7, arg_44_4, arg_44_5)
	end

	if var_44_1 then
		return (arg_44_0:time_to_next_chain_action(var_44_1, arg_44_4, nil, var_44_3))
	else
		return nil
	end
end

WeaponUnitExtension.set_mode = function (arg_45_0, arg_45_1)
	arg_45_0.weapon_mode = arg_45_1
end

WeaponUnitExtension.get_mode = function (arg_46_0)
	return arg_46_0.weapon_mode
end

WeaponUnitExtension.get_custom_data = function (arg_47_0, arg_47_1)
	fassert(arg_47_0._custom_data[arg_47_1] ~= nil, "Custom data key '%s' does not exist, add it to the weapon template", arg_47_1)

	return arg_47_0._custom_data[arg_47_1]
end

WeaponUnitExtension.set_custom_data = function (arg_48_0, arg_48_1, arg_48_2)
	fassert(arg_48_0._custom_data[arg_48_1] ~= nil, "Custom data key '%s' does not exist, add it to the weapon template", arg_48_1)

	arg_48_0._custom_data[arg_48_1] = arg_48_2
end

WeaponUnitExtension.set_weapon_buffs = function (arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0.owner_unit
	local var_49_1 = ScriptUnit.extension(var_49_0, "buff_system")
	local var_49_2 = arg_49_0._current_weapon_buffs

	for iter_49_0 = 1, #var_49_2 do
		var_49_1:remove_buff(var_49_2[iter_49_0])
	end

	table.clear(var_49_2)

	if arg_49_1 then
		for iter_49_1 = 1, #arg_49_1 do
			local var_49_3 = arg_49_1[iter_49_1]

			var_49_2[iter_49_1] = var_49_1:add_buff(var_49_3)
		end
	end
end

WeaponUnitExtension.add_looping_audio = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4, arg_50_5, arg_50_6)
	fassert(arg_50_2, "tried to add looping audio with no start event, id: %s", arg_50_1)
	fassert(arg_50_3, "tried to add looping audio with no end event, id: %s", arg_50_1)

	local var_50_0 = arg_50_0.looping_audio_events[arg_50_1]

	if var_50_0 and var_50_0.is_playing then
		arg_50_0:stop_looping_audio(arg_50_1)
	end

	local var_50_1 = {
		is_playing = false,
		start_event_id = arg_50_2,
		end_event_id = arg_50_3,
		start_event_husk_id = arg_50_4,
		end_event_husk_id = arg_50_5
	}

	arg_50_0.looping_audio_events[arg_50_1] = var_50_1

	if arg_50_6 then
		arg_50_0:start_looping_audio(arg_50_1)
	end
end

WeaponUnitExtension.start_looping_audio = function (arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0.looping_audio_events[arg_51_1]

	if not var_51_0 or var_51_0.is_playing then
		return
	end

	if arg_51_0.is_local and not arg_51_0.is_bot and not var_51_0.wwise_playing_id then
		local var_51_1 = WwiseWorld.make_auto_source(arg_51_0.wwise_world, arg_51_0.unit)

		var_51_0.wwise_playing_id = WwiseWorld.trigger_event(arg_51_0.wwise_world, var_51_0.start_event_id, var_51_1)
	end

	ActionUtils.play_husk_sound_event(arg_51_0.wwise_world, var_51_0.start_event_husk_id, arg_51_0.owner_unit, arg_51_0.is_bot)

	var_51_0.is_playing = true
end

WeaponUnitExtension.stop_looping_audio = function (arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.looping_audio_events[arg_52_1]

	if not var_52_0 or not var_52_0.is_playing then
		return
	end

	if arg_52_0.is_local and not arg_52_0.is_bot then
		if var_52_0.wwise_playing_id and WwiseWorld.is_playing(arg_52_0.wwise_world, var_52_0.wwise_playing_id) then
			local var_52_1 = WwiseWorld.make_auto_source(arg_52_0.wwise_world, arg_52_0.unit)

			WwiseWorld.trigger_event(arg_52_0.wwise_world, var_52_0.end_event_id, var_52_1)
		end

		var_52_0.wwise_playing_id = nil
	end

	ActionUtils.play_husk_sound_event(arg_52_0.wwise_world, var_52_0.end_event_husk_id, arg_52_0.owner_unit, arg_52_0.is_bot)

	var_52_0.is_playing = false
end

WeaponUnitExtension.is_playing_looping_audio = function (arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0.looping_audio_events[arg_53_1]

	if var_53_0 then
		return var_53_0.is_playing
	end

	return false
end

WeaponUnitExtension.set_looping_audio_switch = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	if not arg_54_0.looping_audio_events[arg_54_1] or not arg_54_2 or not arg_54_3 then
		return
	end

	local var_54_0 = WwiseWorld.make_auto_source(arg_54_0.wwise_world, arg_54_0.unit)

	WwiseWorld.set_switch(arg_54_0.wwise_world, arg_54_2, arg_54_3, var_54_0)
end

WeaponUnitExtension.update_looping_audio_parameter = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	if not arg_55_0.looping_audio_events[arg_55_1] or not arg_55_2 or not arg_55_3 then
		return
	end

	local var_55_0 = WwiseWorld.make_auto_source(arg_55_0.wwise_world, arg_55_0.unit)

	WwiseWorld.set_source_parameter(arg_55_0.wwise_world, var_55_0, arg_55_2, arg_55_3)
end

WeaponUnitExtension.on_wield = function (arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0.first_person_extension

	if var_56_0 then
		local var_56_1 = arg_56_0:_weapon_template()
		local var_56_2 = var_56_1 and var_56_1.weapon_sway_settings

		var_56_0:set_weapon_sway_settings(var_56_2)
	end

	if arg_56_0._weapon_wield then
		arg_56_0._weapon_wield(arg_56_0, arg_56_1, arg_56_0.owner_unit, arg_56_0:_is_local_player())
	end
end

WeaponUnitExtension.on_unwield = function (arg_57_0, arg_57_1)
	if arg_57_0._weapon_unwield then
		arg_57_0._weapon_unwield(arg_57_0, arg_57_1)
	end

	if arg_57_0._synced_weapon_state then
		local var_57_0 = arg_57_0._synced_weapon_states[arg_57_0._synced_weapon_state]

		if var_57_0.leave then
			var_57_0:leave(arg_57_0.owner_unit, arg_57_0.unit, arg_57_0._synced_weapon_state_data, arg_57_0:_is_local_player(), arg_57_0.world, nil, false)
		end
	end
end

WeaponUnitExtension.change_synced_state = function (arg_58_0, arg_58_1, arg_58_2)
	if arg_58_0._synced_weapon_state then
		local var_58_0 = arg_58_0._synced_weapon_states[arg_58_0._synced_weapon_state]

		if var_58_0.leave then
			var_58_0:leave(arg_58_0.owner_unit, arg_58_0.unit, arg_58_0._synced_weapon_state_data, arg_58_0:_is_local_player(), arg_58_0.world, arg_58_1, false)
		end
	end

	arg_58_0._synced_weapon_state = arg_58_1

	if arg_58_1 then
		local var_58_1 = arg_58_0._synced_weapon_states[arg_58_1]

		if var_58_1.clear_data_on_enter then
			table.clear(arg_58_0._synced_weapon_state_data)
		end

		if var_58_1.enter then
			var_58_1:enter(arg_58_0.owner_unit, arg_58_0.unit, arg_58_0._synced_weapon_state_data, arg_58_0:_is_local_player(), arg_58_0.world)
		end
	end

	if not arg_58_2 then
		local var_58_2 = Managers.state.network

		if var_58_2 then
			local var_58_3 = var_58_2.network_transmit
			local var_58_4 = Managers.state.unit_storage:go_id(arg_58_0.owner_unit)
			local var_58_5 = NetworkLookup.weapon_synced_states[arg_58_1 or "n/a"]

			if arg_58_0.is_server then
				var_58_3:send_rpc_clients("rpc_change_synced_weapon_state", var_58_4, var_58_5)
			else
				var_58_3:send_rpc_server("rpc_change_synced_weapon_state", var_58_4, var_58_5)
			end
		end
	end
end

WeaponUnitExtension.current_synced_state = function (arg_59_0)
	return arg_59_0._synced_weapon_state
end
