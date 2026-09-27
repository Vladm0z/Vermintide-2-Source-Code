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

if not Development.parameter("debug_weapons") then
	script_data.debug_weapons = true
end

local tbl = {
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
	-- function 1
	for k, v in pairs(arg_1_0) do
		tbl[k] = _G[v]
	end
end)

local function fn(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	-- function 2
	return tbl[arg_2_1]:new(arg_2_2, arg_2_0, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
end

local function fn_2(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local damage_window_start = arg_3_1.damage_window_start
	local damage_window_end = arg_3_1.damage_window_end

	if not (damage_window_start or damage_window_end) then
		return false
	end

	local get_action_time_scale = ActionUtils.get_action_time_scale(arg_3_2, arg_3_1, false)
	local num = damage_window_start / get_action_time_scale

	damage_window_end = damage_window_end or arg_3_1.total_time or math.huge

	local num_2 = damage_window_end / get_action_time_scale
	local flag = num < arg_3_0
	local flag_2 = arg_3_0 < num_2

	return not flag and flag_2
end

local function fn_3(self, arg_4_1)
	-- function 4
	if not self then
		local lookup_data = arg_4_1.lookup_data
		local var_4_1 = self[lookup_data.action_name]

		return not var_4_1 and var_4_1[lookup_data.sub_action_name]
	end

	return nil
end

WeaponUnitExtension = class(WeaponUnitExtension)

WeaponUnitExtension.init = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	self.weapon_system = arg_5_3.weapon_system

	local world = arg_5_1.world

	self.world = world
	self.wwise_world = Managers.world:wwise_world(world)
	self.unit = arg_5_2

	local owner_unit = arg_5_3.owner_unit

	self.owner_unit = owner_unit
	self.item_name = arg_5_3.item_name

	local first_person_rig = arg_5_3.first_person_rig

	self.first_person_unit = first_person_rig

	local skin_name = arg_5_3.skin_name
	local var_5_4 = WeaponSkins.skins[skin_name]

	self.weapon_skin_anim_overrides = not var_5_4 and var_5_4.action_anim_overrides

	local spawn_unit = World.spawn_unit(world, "units/weapons/player/wpn_damage/wpn_damage")

	Unit.disable_physics(spawn_unit)
	Unit.set_unit_visibility(spawn_unit, false)

	if not first_person_rig then
		local source = arg_5_3.attach_nodes[1].source
		local num = 0
		local node

		if type(source) == "string" then
			node = Unit.node(first_person_rig, source)

			if not node then
				-- Nothing
			end
		end

		node = source

		do
			local node_2
		end

		::label_5_0::

		if type(num) == "string" then
			node_2 = Unit.node(spawn_unit, num)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = num

		::label_5_1::

		World.link_unit(world, spawn_unit, node_2, first_person_rig, node)
	end

	self.actual_damage_unit = spawn_unit
	self.actions = {}
	self.action_buff_data = {
		buff_start_times = {},
		buff_end_times = {},
		action_buffs_in_progress = {},
		buff_identifiers = {}
	}
	self.cooldown_timer = {}
	self.chain_action_sound_played = {}
	self.is_server = Managers.state.network.network_transmit.is_server

	local unit_owner = Managers.player:unit_owner(owner_unit)

	if not unit_owner and not unit_owner.bot_player then
		self.bot_attack_data = {
			request = {}
		}
	end

	self.looping_audio_events = {}
	self._current_weapon_buffs = {}
	self._custom_data = {}
	self._passive_update_actions = nil
	self._passive_update_actions_n = 0

	local var_5_11 = rawget(ItemMasterList, self.item_name)
	local flag = not var_5_11 and var_5_11.template

	if not flag then
		self._weapon_template_name = flag

		local get_weapon_template = WeaponUtils.get_weapon_template(flag)
		local custom_data = get_weapon_template.custom_data

		if not custom_data then
			for k, v in pairs(custom_data) do
				if type(v) == "table" then
					local _custom_data = self._custom_data
					local new_table = Script.new_table
					local array_size = v.array_size

					array_size = array_size or 0

					local map_size = v.map_size

					map_size = map_size or 0
					_custom_data[k] = new_table(array_size, map_size)
				else
					self._custom_data[k] = v
				end
			end
		end

		self._weapon_update = not get_weapon_template and get_weapon_template.update
		self._weapon_wield = not get_weapon_template and get_weapon_template.on_wield
		self._weapon_unwield = not get_weapon_template and get_weapon_template.on_unwield
		self._synced_weapon_state = nil
		self._synced_weapon_states = not get_weapon_template and get_weapon_template.synced_states

		if not self._synced_weapon_states then
			self._synced_weapon_state_data = {}
		end
	end

	Managers.state.event:register(self, "on_game_options_changed", "update_game_options")
	self:update_game_options()
end

WeaponUnitExtension.update_game_options = function (self)
	-- function 6
	local user_setting = Application.user_setting("weapon_trails")

	Unit.set_data(self.unit, "trails_enabled", user_setting ~= "none")
end

WeaponUnitExtension.cb_game_session_disconnect = function (self)
	-- function 7
	self.sync_data_game_object_id = nil
end

WeaponUnitExtension.extensions_ready = function (self, arg_8_1, arg_8_2)
	-- function 8
	self.ammo_extension = ScriptUnit.has_extension(arg_8_2, "ammo_system")

	local owner_unit = self.owner_unit

	self.first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self._buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	self._talent_extension = ScriptUnit.has_extension(owner_unit, "talent_system")
end

WeaponUnitExtension.unlink_damage_unit = function (self)
	-- function 9
	if not self.actual_damage_unit then
		World.unlink_unit(self.world, self.actual_damage_unit)
	end
end

WeaponUnitExtension.destroy = function (self)
	-- function 10
	Managers.state.event:unregister("on_game_options_changed", self)

	if not self._synced_weapon_state then
		local var_10_0 = self._synced_weapon_states[self._synced_weapon_state]

		if not var_10_0.leave then
			var_10_0:leave(self.owner_unit, self.unit, self._synced_weapon_state_data, self:_is_local_player(), self.world, nil, true)
		end
	end

	if not self.current_action_settings then
		local buff_data = self.current_action_settings.buff_data

		if not buff_data then
			ActionUtils.remove_action_buff_data(self.action_buff_data, buff_data, self.owner_unit)
		end

		local kind = self.current_action_settings.kind
		local var_10_3 = self.actions[kind]

		if not var_10_3.destroy then
			var_10_3:destroy()
		end
	end

	for k in pairs(self.looping_audio_events) do
		self:stop_looping_audio(k)
	end

	if not self.first_person_unit then
		World.unlink_unit(self.world, self.actual_damage_unit)
	end
end

WeaponUnitExtension.get_action = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	return arg_11_3[arg_11_1][arg_11_2]
end

local tbl_2 = {}

local function fn_4(self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not self then
		local anim_event_from_chain = arg_12_1.anim_event_from_chain

		if not anim_event_from_chain then
			local lookup_data = self.lookup_data
			local var_12_2 = anim_event_from_chain[lookup_data.action_name]

			if not var_12_2 then
				local var_12_3 = var_12_2[lookup_data.sub_action_name]

				if not var_12_3 and not var_12_3[arg_12_3] then
					return var_12_3[arg_12_3]
				end
			end
		end
	end

	local var_12_4

	if not arg_12_2 then
		var_12_4 = arg_12_2[arg_12_3]

		if not var_12_4 then
			-- Nothing
		end
	end

	var_12_4 = arg_12_1[arg_12_3]

	::label_12_0::

	return var_12_4
end

WeaponUnitExtension.start_action = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local has_extension = ScriptUnit.has_extension(owner_unit, "talent_system")
	local first_person_extension = self.first_person_extension
	local extension_2 = ScriptUnit.extension(owner_unit, "status_system")
	local current_action_settings = self.current_action_settings
	local var_13_6 = arg_13_1
	local var_13_7 = arg_13_2

	if not self.player then
		local unit_owner = Managers.player:unit_owner(owner_unit)

		self.is_bot = not unit_owner and not unit_owner:is_player_controlled()
		self.is_local = not unit_owner and not unit_owner.remote
		self.player = unit_owner
	end

	table.clear(tbl_2)

	if not var_13_6 then
		local get_action = self:get_action(var_13_6, var_13_7, arg_13_3)
		local resolve_action_selector, var_13_11, var_13_12 = ActionUtils.resolve_action_selector(get_action, has_extension, extension, self, owner_unit)

		var_13_7 = var_13_12
		var_13_6 = var_13_11

		local kind = resolve_action_selector.kind

		if not self.actions[kind] then
			local var_13_14 = fn(self.item_name, kind, self.world, self.is_server, owner_unit, self.actual_damage_unit, self.first_person_unit, self.unit, self.weapon_system)

			self.actions[kind] = var_13_14

			if not var_13_14.passive_update then
				if not self._passive_update_actions then
					self._passive_update_actions = {
						var_13_14
					}
					self._passive_update_actions_n = 1
				else
					local num = self._passive_update_actions_n + 1

					self._passive_update_actions[num] = var_13_14
					self._passive_update_actions_n = num
				end
			end
		end
	end

	local ammo_extension = self.ammo_extension

	if ammo_extension == nil or not var_13_6 then
		local get_action_2 = self:get_action(var_13_6, var_13_7, arg_13_3)
		local ammo_requirement = get_action_2.ammo_requirement

		if not ammo_requirement then
			ammo_requirement = get_action_2.ammo_usage
			ammo_requirement = ammo_requirement or 0
		end

		local ammo_count = ammo_extension:ammo_count()
		local flag

		flag = get_action_2.can_abort_reload ~= nil or not true or get_action_2.can_abort_reload

		if not ammo_extension:is_reloading() then
			if not (ammo_requirement <= ammo_count) or not flag then
				ammo_extension:abort_reload()
			else
				var_13_6 = nil
				var_13_7 = nil
			end
		elseif ammo_count < ammo_requirement then
			if not (ammo_extension:total_remaining_ammo() ~= 0 or not self.reload_failed_timer and not (arg_13_4 > self.reload_failed_timer) and not get_action_2.interaction_type or get_action_2.interaction_type == "heal" or get_action_2.no_out_of_ammo_vo) then
				local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				alloc_table.fail_reason = "out_of_ammo"
				alloc_table.item_name = "ranged_weapon"

				local str = "reload_failed"

				extension_input:trigger_networked_dialogue_event(str, alloc_table)

				self.reload_failed_timer = arg_13_4 + 5
			end

			var_13_6 = nil
			var_13_7 = nil
		end
	end

	local var_13_24
	local var_13_25

	if not var_13_6 and not current_action_settings then
		var_13_25 = current_action_settings
		tbl_2.new_action = var_13_6
		tbl_2.new_sub_action = var_13_7
		tbl_2.new_action_settings = self:get_action(var_13_6, var_13_7, arg_13_3)
		var_13_24 = self:_finish_action("new_interupting_action", tbl_2)
	end

	if not var_13_6 then
		local extension_3 = ScriptUnit.extension(owner_unit, "locomotion_system")

		if not extension_3:is_stood_still() then
			local current_rotation = first_person_extension:current_rotation()

			extension_3:set_stood_still_target_rotation(current_rotation)
		end

		local flag_2 = current_action_settings ~= nil
		local get_action_3 = self:get_action(var_13_6, var_13_7, arg_13_3)

		first_person_extension:set_weapon_sway_settings(get_action_3.weapon_sway_settings)

		if flag_2 or not get_action_3.aim_at_gaze_setting then
			ScriptUnit.extension(owner_unit, "status_system"):set_is_aiming(true)

			if not ScriptUnit.has_extension(owner_unit, "eyetracking_system") then
				local extension_4 = ScriptUnit.extension(owner_unit, "eyetracking_system")

				extension_4:set_is_aiming(true)

				if not extension_4:get_is_feature_enabled("tobii_aim_at_gaze") then
					local gaze_rotation = extension_4:gaze_rotation()

					first_person_extension:force_look_rotation(gaze_rotation, 1)
				end
			end
		end

		self.current_action_name = var_13_6
		self.current_sub_action_name = var_13_7
		self.current_action_settings = get_action_3

		local first_person_unit = self.first_person_unit

		if not get_action_3.looping_anim then
			local wield_blend_event = get_action_3.wield_blend_event

			wield_blend_event = wield_blend_event or "equip_interrupt"

			Unit.animation_event(first_person_unit, wield_blend_event)
		end

		table.clear(self.chain_action_sound_played)

		local count = #get_action_3.allowed_chain_actions

		for i = 1, count do
			self.chain_action_sound_played[i] = false
		end

		local kind_2 = get_action_3.kind
		local var_13_36 = self.actions[kind_2]
		local total_time = get_action_3.total_time
		local get_action_time_scale = ActionUtils.get_action_time_scale(owner_unit, get_action_3)
		local num_2 = total_time / get_action_time_scale
		local var_13_40 = fn_3(self.weapon_skin_anim_overrides, get_action_3)
		local var_13_41 = fn_4(var_13_25, get_action_3, var_13_40, "pre_action_anim_event")

		if not var_13_41 then
			local get_action_time_scale_2 = ActionUtils.get_action_time_scale(owner_unit, get_action_3, true)
			local clamp = math.clamp(get_action_time_scale_2, NetworkConstants.animation_variable_float.min, NetworkConstants.animation_variable_float.max)

			if type(var_13_41) == "table" then
				for j = 1, #var_13_41 do
					self:_play_3p_anim(var_13_41[j], var_13_41[j], owner_unit, nil, clamp)
					self:_play_1p_anim(var_13_41[j], var_13_41[j], first_person_unit, nil, clamp)
				end
			else
				self:_play_3p_anim(var_13_41, var_13_41, owner_unit, nil, clamp)
				self:_play_1p_anim(var_13_41, var_13_41, first_person_unit, nil, clamp)
			end
		end

		local var_13_44 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event")
		local var_13_45 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_1p")

		var_13_45 = var_13_45 or var_13_44

		local var_13_46 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_3p")

		var_13_46 = var_13_46 or var_13_44

		local var_13_47 = fn_4(var_13_25, get_action_3, var_13_40, "looping_anim")

		for k, v in pairs(self.action_buff_data) do
			table.clear(v)
		end

		local buff_data = get_action_3.buff_data

		if not buff_data then
			ActionUtils.init_action_buff_data(self.action_buff_data, buff_data, arg_13_4)

			self.buff_data = buff_data
		end

		extension_2._current_action = var_13_6

		var_13_36:client_owner_start_action(get_action_3, arg_13_4, var_13_24, arg_13_5, arg_13_6)

		local aim_assist_ramp_multiplier = get_action_3.aim_assist_ramp_multiplier

		if not aim_assist_ramp_multiplier then
			local aim_assist_max_ramp_multiplier = get_action_3.aim_assist_max_ramp_multiplier
			local aim_assist_ramp_decay_delay = get_action_3.aim_assist_ramp_decay_delay

			first_person_extension:increase_aim_assist_multiplier(aim_assist_ramp_multiplier, aim_assist_max_ramp_multiplier, aim_assist_ramp_decay_delay)
		end

		if not self.ammo_extension then
			if self.ammo_extension:total_remaining_ammo() == 0 then
				var_13_44 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_no_ammo_left") or var_13_44
				var_13_45 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_no_ammo_left_1p") or var_13_45 or var_13_44
				var_13_46 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_no_ammo_left_3p") or var_13_46 or var_13_44
			elseif self.ammo_extension:total_remaining_ammo() == 1 then
				var_13_44 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_last_ammo") or var_13_44
				var_13_45 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_last_ammo_1p") or var_13_45
				var_13_46 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_last_ammo_3p") or var_13_46
			end
		end

		if not extension and not extension:has_buff_perk("infinite_ammo") then
			var_13_44 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_infinite_ammo") or var_13_44
			var_13_45 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_infinite_ammo_1p") or var_13_45 or var_13_44
			var_13_46 = fn_4(var_13_25, get_action_3, var_13_40, "anim_event_infinite_ammo_3p") or var_13_46 or var_13_44
		end

		self.action_time_started = arg_13_4
		self.action_time_scale = get_action_time_scale
		self.action_time_done = arg_13_4 + num_2

		if not get_action_3.cooldown then
			local lookup_data = get_action_3.lookup_data

			self.cooldown_timer[lookup_data.action_name] = arg_13_4 + get_action_3.cooldown
		end

		if not get_action_3.enter_function then
			local get_scaled_min_hold_time = self:get_scaled_min_hold_time(get_action_3)
			local extension_5 = ScriptUnit.extension(owner_unit, "input_system")
			local num_3 = self.action_time_started + get_scaled_min_hold_time - arg_13_4

			get_action_3.enter_function(owner_unit, extension_5, num_3, self)
		end

		local get_action_time_scale_3 = ActionUtils.get_action_time_scale(owner_unit, get_action_3, true)
		local clamp_2 = math.clamp(get_action_time_scale_3, NetworkConstants.animation_variable_float.min, NetworkConstants.animation_variable_float.max)

		if not var_13_46 then
			if type(var_13_46) == "table" then
				for i4 = 1, #var_13_46 do
					self:_play_3p_anim(var_13_46[i4], (var_13_44 or var_13_46)[i4], owner_unit, var_13_47, clamp_2)
				end
			else
				self:_play_3p_anim(var_13_46, var_13_44 or var_13_46, owner_unit, var_13_47, clamp_2)
			end
		end

		if not var_13_45 then
			if type(var_13_45) == "table" then
				for i5 = 1, #var_13_45 do
					self:_play_1p_anim(var_13_45[i5], (var_13_44 or var_13_45)[i5], first_person_unit, var_13_47, clamp_2)
				end
			else
				self:_play_1p_anim(var_13_45, var_13_44 or var_13_45, first_person_unit, var_13_47, clamp_2)
			end
		end

		if var_13_46 or not var_13_45 or not get_action_3.apply_recoil then
			first_person_extension:apply_recoil()
			first_person_extension:play_camera_recoil(get_action_3.recoil_settings, arg_13_4)
		end
	end
end

WeaponUnitExtension._play_1p_anim = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	if not (IS_WINDOWS or IS_LINUX or arg_14_2 ~= "attack_shoot") then
		arg_14_5 = arg_14_5 * 1.2
	end

	self.first_person_extension:animation_set_variable("attack_speed", arg_14_5)

	if not (not arg_14_4 and not arg_14_4 and self._looping_anim_event_started) then
		Unit.animation_event(arg_14_3, arg_14_2)

		if not arg_14_4 then
			self._looping_anim_event_started = true
		end
	end
end

WeaponUnitExtension._play_3p_anim = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local go_id = Managers.state.unit_storage:go_id(arg_15_3)
	local var_15_1 = NetworkLookup.anims[arg_15_1]
	local attack_speed = NetworkLookup.anims.attack_speed

	if not LEVEL_EDITOR_TEST then
		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event_variable_float", var_15_1, go_id, attack_speed, arg_15_5)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event_variable_float", var_15_1, go_id, attack_speed, arg_15_5)
		end
	end

	if not (IS_WINDOWS or IS_LINUX or arg_15_2 ~= "attack_shoot") then
		arg_15_5 = arg_15_5 * 1.2
	end

	if not script_data.disable_third_person_weapon_animation_events then
		local var_15_3
		local animation_find_variable = Unit.animation_find_variable(arg_15_3, "attack_speed")

		Unit.animation_set_variable(arg_15_3, animation_find_variable, arg_15_5)

		if not (not arg_15_4 and not arg_15_4 and self._looping_anim_event_started) then
			Unit.animation_event(arg_15_3, arg_15_1)

			if not arg_15_4 then
				self._looping_anim_event_started = true
			end
		end
	end
end

WeaponUnitExtension.stop_action = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not (not self:has_current_action() and self._currently_stopping_action) then
		self._currently_stopping_action = true

		self:_finish_action(arg_16_1, arg_16_2)

		self._currently_stopping_action = false
	end
end

WeaponUnitExtension._finish_action = function (self, arg_17_1, arg_17_2)
	-- function 17
	local current_action_settings = self.current_action_settings
	local kind = current_action_settings.kind
	local var_17_2 = self.actions[kind]

	if not Application.user_setting("tobii_eyetracking") and not ScriptUnit.has_extension(self.owner_unit, "eyetracking_system") then
		local extension = ScriptUnit.extension(self.owner_unit, "eyetracking_system")

		if arg_17_1 == "hold_input_released" then
			extension:set_is_aiming(false)
			extension:set_aim_at_gaze_cancelled(false)
		end
	end

	if arg_17_1 == "hold_input_released" then
		ScriptUnit.has_extension(self.owner_unit, "status_system"):set_is_aiming(false)
	end

	local buff_data = current_action_settings.buff_data

	if not buff_data then
		ActionUtils.remove_action_buff_data(self.action_buff_data, buff_data, self.owner_unit)
	end

	for k, v in pairs(self.action_buff_data) do
		table.clear(v)
	end

	local finish = var_17_2:finish(arg_17_1, arg_17_2)

	self:anim_end_event(arg_17_1, current_action_settings)

	local flag = not arg_17_2 and arg_17_2.new_action_settings
	local flag_2 = not flag and flag.on_chain_keep_audio_loops

	if not flag_2 then
		for k_2 in pairs(self.looping_audio_events) do
			if not table.contains(flag_2, k_2) then
				self:stop_looping_audio(k_2)
			end
		end
	else
		for k_3 in pairs(self.looping_audio_events) do
			self:stop_looping_audio(k_3)
		end
	end

	if not current_action_settings.finish_function then
		current_action_settings.finish_function(self.owner_unit, arg_17_1, self)
	end

	local first_person_extension = self.first_person_extension

	if not first_person_extension then
		local _weapon_template = self:_weapon_template()
		local flag_3 = not _weapon_template and _weapon_template.weapon_sway_settings

		first_person_extension:set_weapon_sway_settings(flag_3)
	end

	if not self.bot_attack_data then
		self:clear_bot_attack_request()
	end

	self.current_action_settings = nil
	self.action_time_scale = nil

	return finish
end

WeaponUnitExtension._weapon_template = function (self)
	-- function 18
	return WeaponUtils.get_weapon_template(self._weapon_template_name)
end

WeaponUnitExtension.anim_end_event = function (self, arg_19_1, arg_19_2)
	-- function 19
	local anim_end_event_condition_func = arg_19_2.anim_end_event_condition_func
	local flag

	flag = anim_end_event_condition_func or not true or anim_end_event_condition_func(self.owner_unit, arg_19_1, self.ammo_extension)

	if not flag then
		local var_19_2 = fn_3(self.weapon_skin_anim_overrides, arg_19_2)
		local anim_end_event

		if not var_19_2 then
			anim_end_event = var_19_2.anim_end_event

			if not anim_end_event then
				-- Nothing
			end
		end

		anim_end_event = arg_19_2.anim_end_event

		do
			local anim_end_event_1p
		end

		::label_19_0::

		if not var_19_2 then
			anim_end_event_1p = var_19_2.anim_end_event_1p

			if not anim_end_event_1p then
				-- Nothing
			end
		end

		anim_end_event_1p = arg_19_2.anim_end_event_1p

		do
			local anim_end_event_3p
		end

		::label_19_1::

		if not var_19_2 then
			anim_end_event_3p = var_19_2.anim_end_event_3p

			if not anim_end_event_3p then
				-- Nothing
			end
		end

		anim_end_event_3p = arg_19_2.anim_end_event_3p

		::label_19_2::

		if not anim_end_event then
			if type(anim_end_event) == "table" then
				for i = 1, #anim_end_event do
					self:_play_end_event_1p(anim_end_event[i])
					self:_play_end_event_3p(anim_end_event[i])
				end
			else
				self:_play_end_event_1p(anim_end_event)
				self:_play_end_event_3p(anim_end_event)
			end
		end

		if not anim_end_event_1p then
			if type(anim_end_event_1p) == "table" then
				for j = 1, #anim_end_event_1p do
					self:_play_end_event_1p(anim_end_event_1p[j])
				end
			else
				self:_play_end_event_1p(anim_end_event_1p)
			end
		end

		if not anim_end_event_3p then
			if type(anim_end_event_3p) == "table" then
				for k = 1, #anim_end_event_3p do
					self:_play_end_event_3p(anim_end_event_3p[k])
				end
			else
				self:_play_end_event_3p(anim_end_event_3p)
			end
		end

		self._looping_anim_event_started = nil
	end
end

WeaponUnitExtension._play_end_event_3p = function (self, arg_20_1)
	-- function 20
	local var_20_0 = NetworkLookup.anims[arg_20_1]
	local go_id = Managers.state.unit_storage:go_id(self.owner_unit)

	if not LEVEL_EDITOR_TEST then
		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event", var_20_0, go_id)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event", var_20_0, go_id)
		end
	end

	if not script_data.disable_third_person_weapon_animation_events then
		Unit.animation_event(self.owner_unit, arg_20_1)
	end
end

WeaponUnitExtension._play_end_event_1p = function (self, arg_21_1)
	-- function 21
	Unit.animation_event(self.first_person_unit, arg_21_1)
end

WeaponUnitExtension.trigger_anim_event = function (self, arg_22_1)
	-- function 22
	if not arg_22_1 then
		local var_22_0 = NetworkLookup.anims[arg_22_1]

		if not LEVEL_EDITOR_TEST then
			local go_id = Managers.state.unit_storage:go_id(self.owner_unit)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event", var_22_0, go_id)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event", var_22_0, go_id)
			end
		end

		Unit.animation_event(self.first_person_unit, arg_22_1)

		if not script_data.disable_third_person_weapon_animation_events then
			Unit.animation_event(self.owner_unit, arg_22_1)
		end

		self._looping_anim_event_started = nil
	end
end

WeaponUnitExtension.update = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	local current_action_settings = self.current_action_settings

	if not current_action_settings then
		local owner_unit = self.owner_unit
		local wwise_world = Managers.world:wwise_world(self.world)
		local allowed_chain_actions = current_action_settings.allowed_chain_actions
		local count = #allowed_chain_actions

		for i = 1, count do
			local var_23_5 = allowed_chain_actions[i]
			local chain_ready_sound = var_23_5.chain_ready_sound

			if not chain_ready_sound then
				local sound_time_offset = var_23_5.sound_time_offset

				sound_time_offset = sound_time_offset or 0

				if not (not self:is_chain_action_available(var_23_5, arg_23_5, sound_time_offset) and self.chain_action_sound_played[i]) then
					WwiseWorld.trigger_event(wwise_world, chain_ready_sound)

					self.chain_action_sound_played[i] = true
				end
			end
		end

		if arg_23_5 > self.action_time_done then
			self:_finish_action("action_complete")
		else
			local num = arg_23_5 - self.action_time_started
			local var_23_9 = fn_2(num, self.current_action_settings, owner_unit)
			local kind = current_action_settings.kind
			local var_23_11 = self.actions[kind]
			local buff_data = current_action_settings.buff_data

			if not buff_data then
				ActionUtils.update_action_buff_data(self.action_buff_data, buff_data, owner_unit, arg_23_5)
			end

			var_23_11:client_owner_post_update(arg_23_3, arg_23_5, self.world, var_23_9, num)

			if not (not current_action_settings.cooldown and current_action_settings.cooldown_from_start) then
				local lookup_data = current_action_settings.lookup_data

				self.cooldown_timer[lookup_data.action_name] = arg_23_5 + current_action_settings.cooldown
			end
		end
	end

	local _passive_update_actions = self._passive_update_actions

	for j = 1, self._passive_update_actions_n do
		_passive_update_actions[j]:passive_update(arg_23_3, arg_23_5)
	end

	if not self._weapon_update then
		self._weapon_update(self, arg_23_3, arg_23_5)
	end

	if not self._synced_weapon_state then
		local var_23_15 = self._synced_weapon_states[self._synced_weapon_state]

		if not var_23_15.update then
			var_23_15:update(self.owner_unit, self.unit, self._synced_weapon_state_data, self:_is_local_player(), self.world, arg_23_3, self)
		end
	end
end

WeaponUnitExtension._is_local_player = function (self)
	-- function 24
	local owner = Managers.player:owner(self.owner_unit)

	return not owner and owner.local_player
end

WeaponUnitExtension.is_streak_action_available = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local current_action_settings = self.current_action_settings

	current_action_settings = current_action_settings or self.temporary_action_settings

	local var_25_1 = self.actions[current_action_settings.kind]
	local num = arg_25_2 - self.action_time_started

	if not var_25_1.streak_available and not var_25_1:streak_available(num, arg_25_1) and not self:is_chain_action_available(arg_25_1, arg_25_2, arg_25_3) then
		return true
	end

	return false
end

WeaponUnitExtension.is_chain_action_available = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local current_action_settings = self.current_action_settings

	current_action_settings = current_action_settings or self.temporary_action_settings

	local num = arg_26_2 - self.action_time_started
	local num_2 = current_action_settings.total_time + 2

	arg_26_3 = arg_26_3 or 0

	local action_time_scale = self.action_time_scale

	action_time_scale = action_time_scale or ActionUtils.get_action_time_scale(self.owner_unit, current_action_settings)

	if not arg_26_1.auto_chain then
		local num_3

		if not arg_26_1.start_time then
			num_3 = arg_26_1.start_time / action_time_scale

			if not num_3 then
				-- Nothing
			end
		end

		num_3 = num_2

		::label_26_0::

		return num >= num_3 + arg_26_3
	else
		local num_4

		if not arg_26_1.end_time then
			num_4 = arg_26_1.end_time / action_time_scale

			if not num_4 then
				-- Nothing
			end
		end

		num_4 = num_2

		::label_26_1::

		return not (num >= arg_26_1.start_time / action_time_scale + arg_26_3) or num <= num_4
	end
end

WeaponUnitExtension.time_to_next_chain_action = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	arg_27_4 = arg_27_4 or self.current_action_settings or self.temporary_action_settings

	local num

	if not self:has_current_action() then
		num = arg_27_2 - self.action_time_started

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_27_0::

	local num_2 = arg_27_4.total_time + 2

	arg_27_3 = arg_27_3 or 0

	local get_action_time_scale = ActionUtils.get_action_time_scale(self.owner_unit, arg_27_4)
	local num_3

	if not arg_27_1.start_time then
		num_3 = arg_27_1.start_time / get_action_time_scale

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = num_2

	::label_27_1::

	return num_3 + arg_27_3 - num
end

WeaponUnitExtension.get_scaled_min_hold_time = function (self, arg_28_1)
	-- function 28
	local minimum_hold_time = arg_28_1.minimum_hold_time

	if not minimum_hold_time then
		return 0
	end

	local extension = ScriptUnit.extension(self.owner_unit, "buff_system")
	local var_28_2 = minimum_hold_time

	if not extension then
		var_28_2 = extension:apply_buffs_to_value(var_28_2, "reload_speed")

		if var_28_2 > 0 then
			var_28_2 = var_28_2 / ActionUtils.get_action_time_scale(self.owner_unit, arg_28_1, false, 1)
		end
	end

	return var_28_2
end

WeaponUnitExtension.can_stop_hold_action = function (self, arg_29_1)
	-- function 29
	local num = arg_29_1 - self.action_time_started
	local current_action_settings = self.current_action_settings

	if not current_action_settings.minimum_hold_time then
		return true
	end

	return num > self:get_scaled_min_hold_time(current_action_settings)
end

WeaponUnitExtension.get_action_cooldown = function (self, arg_30_1)
	-- function 30
	return self.cooldown_timer[arg_30_1]
end

WeaponUnitExtension.get_current_action = function (self)
	-- function 31
	return self.actions[self.current_action_settings.kind]
end

WeaponUnitExtension.has_current_action = function (self)
	-- function 32
	return self.current_action_settings ~= nil
end

WeaponUnitExtension.get_current_action_settings = function (self)
	-- function 33
	return self.current_action_settings
end

WeaponUnitExtension.is_after_damage_window = function (self)
	-- function 34
	local current_action_settings = self.current_action_settings

	if not current_action_settings then
		return false
	end

	local damage_window_start = current_action_settings.damage_window_start
	local damage_window_end = current_action_settings.damage_window_end

	if not (damage_window_start or damage_window_end) then
		return false
	end

	local owner_unit = self.owner_unit
	local num = Managers.time:time("game") - self.action_time_started
	local get_action_time_scale = ActionUtils.get_action_time_scale(owner_unit, current_action_settings, false)

	damage_window_end = damage_window_end or current_action_settings.total_time or math.huge

	return num >= damage_window_end / get_action_time_scale
end

WeaponUnitExtension.bot_should_stop_attack_on_leave = function (self)
	-- function 35
	local current_action_settings = self.current_action_settings

	if not current_action_settings then
		return current_action_settings.stop_action_on_leave_for_bot
	end
end

WeaponUnitExtension._is_before_end_time = function (self, arg_36_1, arg_36_2)
	-- function 36
	local current_action_settings = self.current_action_settings

	current_action_settings = current_action_settings or self.temporary_action_settings

	local num = arg_36_2 - self.action_time_started
	local num_2 = current_action_settings.total_time + 2
	local get_action_time_scale = ActionUtils.get_action_time_scale(self.owner_unit, current_action_settings)
	local num_3

	if not arg_36_1.end_time then
		num_3 = arg_36_1.end_time / get_action_time_scale

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = num_2

	::label_36_0::

	return num < num_3
end

WeaponUnitExtension._find_chain_action = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	-- function 37
	local num = 0
	local count = #arg_37_2
	local var_37_2
	local var_37_3

	for i = 1, count do
		local var_37_4 = arg_37_2[i]

		if var_37_4.input == arg_37_4 then
			num = num + 1

			if num == arg_37_5 then
				var_37_2 = var_37_4

				break
			end
		end
	end

	if not var_37_2 then
		local action = var_37_2.action
		local sub_action = var_37_2.sub_action

		var_37_3 = arg_37_1[action][sub_action]

		local var_37_7, var_37_8

		var_37_3, var_37_7, var_37_8 = ActionUtils.resolve_action_selector(var_37_3, self._talent_extension, self._buff_extension, self, self.unit)

		if not (not self.current_action_settings and self:_is_before_end_time(var_37_2, arg_37_3)) then
			return nil
		end
	end

	return var_37_2, var_37_3
end

WeaponUnitExtension._get_attack_chain_data = function (self, arg_38_1, arg_38_2, arg_38_3)
	-- function 38
	local var_38_0
	local var_38_1
	local var_38_2
	local str = "hold_attack"
	local var_38_4
	local current_action_settings = self.current_action_settings

	if not current_action_settings then
		var_38_2 = current_action_settings
	else
		local start_action_name = arg_38_2.start_action_name
		local start_sub_action_name = arg_38_2.start_sub_action_name

		var_38_2 = arg_38_1[start_action_name][start_sub_action_name]
	end

	local lookup_data = var_38_2.lookup_data
	local action_name = lookup_data.action_name
	local sub_action_name = lookup_data.sub_action_name
	local var_38_11 = arg_38_2.transitions[action_name][sub_action_name]

	if var_38_11 == nil then
		return nil
	end

	local chain_action = var_38_11.chain_action

	if not (not current_action_settings and self:_is_before_end_time(chain_action, arg_38_3)) then
		return nil
	end

	local var_38_13 = arg_38_1[chain_action.action][chain_action.sub_action_name]

	str = var_38_11.bot_wait_input or str
	var_38_4 = var_38_11.bot_wanted_input or var_38_4

	return chain_action, var_38_13, var_38_2, str, var_38_4
end

WeaponUnitExtension._process_bot_attack_request = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	-- function 39
	if not arg_39_5 then
		return self:_get_attack_chain_data(arg_39_2, arg_39_5, arg_39_4)
	end

	local var_39_0
	local var_39_1
	local var_39_2
	local str = "action_one_release"
	local str_2 = "hold_attack"
	local var_39_5
	local flag

	flag = (arg_39_1 ~= "tap_attack" or not 1 or arg_39_1 ~= "hold_attack") and 2

	if not self.current_action_settings then
		var_39_2 = self.current_action_settings

		local allowed_chain_actions = var_39_2.allowed_chain_actions

		var_39_0, var_39_1 = self:_find_chain_action(arg_39_2, allowed_chain_actions, arg_39_4, str, flag)

		if not (var_39_0 ~= nil or var_39_2.kind == "block") then
			str_2 = nil
			var_39_5 = "tap_attack"
			var_39_0, var_39_1 = self:_find_chain_action(arg_39_2, allowed_chain_actions, arg_39_4, "action_one", 1)
		end
	else
		var_39_2 = ActionUtils.resolve_action_selector(arg_39_2.action_one.default)
		var_39_0, var_39_1 = self:_find_chain_action(arg_39_2, var_39_2.allowed_chain_actions, arg_39_4, str, flag)
	end

	return var_39_0, var_39_1, var_39_2, str_2, var_39_5
end

WeaponUnitExtension.update_bot_attack_request = function (self, arg_40_1)
	-- function 40
	local bot_attack_data = self.bot_attack_data
	local request = bot_attack_data.request

	if not request.attack_type then
		local _process_bot_attack_request, var_40_3, var_40_4, var_40_5, var_40_6 = self:_process_bot_attack_request(request.attack_type, request.actions, request.weapon_name, arg_40_1, request.attack_chain)

		if not _process_bot_attack_request then
			bot_attack_data.chain_action = _process_bot_attack_request
			bot_attack_data.chain_action_settings = var_40_3
			bot_attack_data.action_settings = var_40_4
			bot_attack_data.wait_input = var_40_5
			bot_attack_data.wanted_input = var_40_6
		end

		table.clear(request)
	end

	local chain_action = bot_attack_data.chain_action

	if chain_action == nil then
		return
	end

	local var_40_8

	if not self.current_action_settings and not self:is_chain_action_available(chain_action, arg_40_1) then
		var_40_8 = bot_attack_data.wanted_input

		self:clear_bot_attack_request()
	else
		var_40_8 = bot_attack_data.wait_input
	end

	if not var_40_8 then
		local owner_unit = self.owner_unit
		local extension = ScriptUnit.extension(owner_unit, "input_system")

		extension[var_40_8](extension)
	end
end

WeaponUnitExtension.request_bot_attack_action = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	local bot_attack_data = self.bot_attack_data
	local request = bot_attack_data.request

	if bot_attack_data.chain_action or not request.attack_type then
		return false
	else
		request.attack_type = arg_41_1
		request.actions = arg_41_2
		request.weapon_name = arg_41_3
		request.attack_chain = arg_41_4

		return true
	end
end

WeaponUnitExtension.clear_bot_attack_request = function (self)
	-- function 42
	local bot_attack_data = self.bot_attack_data
	local request = bot_attack_data.request

	table.clear(request)
	table.clear(bot_attack_data)

	bot_attack_data.request = request
end

WeaponUnitExtension.is_starting_attack = function (self)
	-- function 43
	local current_action_settings = self.current_action_settings

	return ActionUtils.is_melee_start_sub_action(current_action_settings)
end

WeaponUnitExtension.time_to_next_attack = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5)
	-- function 44
	local bot_attack_data = self.bot_attack_data
	local var_44_1
	local var_44_2
	local var_44_3

	if not bot_attack_data.chain_action then
		var_44_1 = bot_attack_data.chain_action
		var_44_3 = bot_attack_data.action_settings
	else
		local request = bot_attack_data.request
		local attack_type = request.attack_type

		attack_type = attack_type or arg_44_1

		local actions = request.actions

		actions = actions or arg_44_2

		local weapon_name = request.weapon_name

		weapon_name = weapon_name or arg_44_3
		arg_44_5 = request.attack_chain or arg_44_5

		local var_44_8

		var_44_1, var_44_8, var_44_3 = self:_process_bot_attack_request(attack_type, actions, weapon_name, arg_44_4, arg_44_5)
	end

	if not var_44_1 then
		return (self:time_to_next_chain_action(var_44_1, arg_44_4, nil, var_44_3))
	else
		return nil
	end
end

WeaponUnitExtension.set_mode = function (self, arg_45_1)
	-- function 45
	self.weapon_mode = arg_45_1
end

WeaponUnitExtension.get_mode = function (self)
	-- function 46
	return self.weapon_mode
end

WeaponUnitExtension.get_custom_data = function (self, arg_47_1)
	-- function 47
	fassert(self._custom_data[arg_47_1] ~= nil, "Custom data key '%s' does not exist, add it to the weapon template", arg_47_1)

	return self._custom_data[arg_47_1]
end

WeaponUnitExtension.set_custom_data = function (self, arg_48_1, arg_48_2)
	-- function 48
	fassert(self._custom_data[arg_48_1] ~= nil, "Custom data key '%s' does not exist, add it to the weapon template", arg_48_1)

	self._custom_data[arg_48_1] = arg_48_2
end

WeaponUnitExtension.set_weapon_buffs = function (self, arg_49_1)
	-- function 49
	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local _current_weapon_buffs = self._current_weapon_buffs

	for i = 1, #_current_weapon_buffs do
		extension:remove_buff(_current_weapon_buffs[i])
	end

	table.clear(_current_weapon_buffs)

	if not arg_49_1 then
		for j = 1, #arg_49_1 do
			local var_49_3 = arg_49_1[j]

			_current_weapon_buffs[j] = extension:add_buff(var_49_3)
		end
	end
end

WeaponUnitExtension.add_looping_audio = function (self, arg_50_1, arg_50_2, arg_50_3, arg_50_4, arg_50_5, arg_50_6)
	-- function 50
	fassert(arg_50_2, "tried to add looping audio with no start event, id: %s", arg_50_1)
	fassert(arg_50_3, "tried to add looping audio with no end event, id: %s", arg_50_1)

	local var_50_0 = self.looping_audio_events[arg_50_1]

	if not var_50_0 and not var_50_0.is_playing then
		self:stop_looping_audio(arg_50_1)
	end

	local tbl = {
		is_playing = false,
		start_event_id = arg_50_2,
		end_event_id = arg_50_3,
		start_event_husk_id = arg_50_4,
		end_event_husk_id = arg_50_5
	}

	self.looping_audio_events[arg_50_1] = tbl

	if not arg_50_6 then
		self:start_looping_audio(arg_50_1)
	end
end

WeaponUnitExtension.start_looping_audio = function (self, arg_51_1)
	-- function 51
	local var_51_0 = self.looping_audio_events[arg_51_1]

	if not var_51_0 and not var_51_0.is_playing then
		return
	end

	if not (not self.is_local and self.is_bot or var_51_0.wwise_playing_id) then
		local make_auto_source = WwiseWorld.make_auto_source(self.wwise_world, self.unit)

		var_51_0.wwise_playing_id = WwiseWorld.trigger_event(self.wwise_world, var_51_0.start_event_id, make_auto_source)
	end

	ActionUtils.play_husk_sound_event(self.wwise_world, var_51_0.start_event_husk_id, self.owner_unit, self.is_bot)

	var_51_0.is_playing = true
end

WeaponUnitExtension.stop_looping_audio = function (self, arg_52_1)
	-- function 52
	local var_52_0 = self.looping_audio_events[arg_52_1]

	if not (not var_52_0 and var_52_0.is_playing) then
		return
	end

	if not (not self.is_local and self.is_bot) then
		if not var_52_0.wwise_playing_id and not WwiseWorld.is_playing(self.wwise_world, var_52_0.wwise_playing_id) then
			local make_auto_source = WwiseWorld.make_auto_source(self.wwise_world, self.unit)

			WwiseWorld.trigger_event(self.wwise_world, var_52_0.end_event_id, make_auto_source)
		end

		var_52_0.wwise_playing_id = nil
	end

	ActionUtils.play_husk_sound_event(self.wwise_world, var_52_0.end_event_husk_id, self.owner_unit, self.is_bot)

	var_52_0.is_playing = false
end

WeaponUnitExtension.is_playing_looping_audio = function (self, arg_53_1)
	-- function 53
	local var_53_0 = self.looping_audio_events[arg_53_1]

	if not var_53_0 then
		return var_53_0.is_playing
	end

	return false
end

WeaponUnitExtension.set_looping_audio_switch = function (self, arg_54_1, arg_54_2, arg_54_3)
	-- function 54
	if not (not self.looping_audio_events[arg_54_1] and not arg_54_2 and arg_54_3) then
		return
	end

	local make_auto_source = WwiseWorld.make_auto_source(self.wwise_world, self.unit)

	WwiseWorld.set_switch(self.wwise_world, arg_54_2, arg_54_3, make_auto_source)
end

WeaponUnitExtension.update_looping_audio_parameter = function (self, arg_55_1, arg_55_2, arg_55_3)
	-- function 55
	if not (not self.looping_audio_events[arg_55_1] and not arg_55_2 and arg_55_3) then
		return
	end

	local make_auto_source = WwiseWorld.make_auto_source(self.wwise_world, self.unit)

	WwiseWorld.set_source_parameter(self.wwise_world, make_auto_source, arg_55_2, arg_55_3)
end

WeaponUnitExtension.on_wield = function (self, arg_56_1)
	-- function 56
	local first_person_extension = self.first_person_extension

	if not first_person_extension then
		local _weapon_template = self:_weapon_template()
		local flag = not _weapon_template and _weapon_template.weapon_sway_settings

		first_person_extension:set_weapon_sway_settings(flag)
	end

	if not self._weapon_wield then
		self._weapon_wield(self, arg_56_1, self.owner_unit, self:_is_local_player())
	end
end

WeaponUnitExtension.on_unwield = function (self, arg_57_1)
	-- function 57
	if not self._weapon_unwield then
		self._weapon_unwield(self, arg_57_1)
	end

	if not self._synced_weapon_state then
		local var_57_0 = self._synced_weapon_states[self._synced_weapon_state]

		if not var_57_0.leave then
			var_57_0:leave(self.owner_unit, self.unit, self._synced_weapon_state_data, self:_is_local_player(), self.world, nil, false)
		end
	end
end

WeaponUnitExtension.change_synced_state = function (self, arg_58_1, arg_58_2)
	-- function 58
	if not self._synced_weapon_state then
		local var_58_0 = self._synced_weapon_states[self._synced_weapon_state]

		if not var_58_0.leave then
			var_58_0:leave(self.owner_unit, self.unit, self._synced_weapon_state_data, self:_is_local_player(), self.world, arg_58_1, false)
		end
	end

	self._synced_weapon_state = arg_58_1

	if not arg_58_1 then
		local var_58_1 = self._synced_weapon_states[arg_58_1]

		if not var_58_1.clear_data_on_enter then
			table.clear(self._synced_weapon_state_data)
		end

		if not var_58_1.enter then
			var_58_1:enter(self.owner_unit, self.unit, self._synced_weapon_state_data, self:_is_local_player(), self.world)
		end
	end

	if not arg_58_2 then
		local network = Managers.state.network

		if not network then
			local network_transmit = network.network_transmit
			local go_id = Managers.state.unit_storage:go_id(self.owner_unit)
			local var_58_5 = NetworkLookup.weapon_synced_states[arg_58_1 or "n/a"]

			if not self.is_server then
				network_transmit:send_rpc_clients("rpc_change_synced_weapon_state", go_id, var_58_5)
			else
				network_transmit:send_rpc_server("rpc_change_synced_weapon_state", go_id, var_58_5)
			end
		end
	end
end

WeaponUnitExtension.current_synced_state = function (self)
	-- function 59
	return self._synced_weapon_state
end
