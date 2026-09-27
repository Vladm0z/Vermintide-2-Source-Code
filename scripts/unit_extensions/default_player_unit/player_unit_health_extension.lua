-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_health_extension.lua

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

PlayerUnitHealthExtension = class(PlayerUnitHealthExtension, GenericHealthExtension)

PlayerUnitHealthExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	PlayerUnitHealthExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	local player = arg_1_3.player
	local local_player = player.local_player
	local flag = not player:is_player_controlled()

	self.player = player
	self.is_bot = flag
	self.is_local_player = local_player
	self.network_manager = Managers.state.network
	self.game = self.network_manager:game()
	self.unit_storage = arg_1_1.unit_storage
	self._profile_index = arg_1_3.profile_index
	self._career_index = arg_1_3.career_index
	self._shield_amount = 0
	self._shield_duration_left = 0
	self._end_reason = ""
	self.wounded_degen_timer = 0

	local remote = player.remote

	remote = remote or player.bot_player
	self._is_husk = remote

	self:update_options()

	if not (not self.is_server and local_player or flag) then
		self:create_health_game_object()
	end

	self._display_data = {}
	self._streak_debug_duration = -10
	self._streak_debug_damage = 0

	Managers.state.event:register(self, "on_game_options_changed", "update_options")
end

PlayerUnitHealthExtension.update_options = function (self)
	-- function 2
	local settings = Managers.state.game_mode:settings()
	local use_floating_damage_numbers = settings.use_floating_damage_numbers

	use_floating_damage_numbers = not use_floating_damage_numbers and not DEDICATED_SERVER
	self._use_floating_damage_numbers = use_floating_damage_numbers

	local user_setting = Application.user_setting("vs_floating_damage")

	self._show_floating_damage = user_setting == "floating" or user_setting == "both"
	self._show_floating_streak_damage = user_setting == "streak" or user_setting == "both"

	local min_streak_font_size = settings.min_streak_font_size

	min_streak_font_size = min_streak_font_size or 30
	self._min_streak_font_size = min_streak_font_size

	local max_streak_font_size = settings.max_streak_font_size

	max_streak_font_size = max_streak_font_size or 60
	self._max_streak_font_size = max_streak_font_size

	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()

	self._temp_hp_degen_delay_when_wounded = get_difficulty_settings.no_wound_dependent_temp_hp_degen

	local percent_health_on_revive = get_difficulty_settings.percent_health_on_revive

	percent_health_on_revive = percent_health_on_revive or 0
	self._percent_health_on_revive = percent_health_on_revive

	local percent_temp_health_on_revive = get_difficulty_settings.percent_temp_health_on_revive

	percent_temp_health_on_revive = percent_temp_health_on_revive or 0.5
	self._percent_temp_health_on_revive = percent_temp_health_on_revive
end

PlayerUnitHealthExtension.hot_join_sync = function (arg_3_0, arg_3_1)
	-- function 3
	return
end

PlayerUnitHealthExtension.cb_game_session_disconnect = function (self)
	-- function 4
	self.health_game_object_id = nil
end

PlayerUnitHealthExtension.set_health_game_object_id = function (self, arg_5_1)
	-- function 5
	self.health_game_object_id = arg_5_1
end

PlayerUnitHealthExtension.create_health_game_object = function (self)
	-- function 6
	fassert(self.is_server, "Trying to create health game object on a client")

	local unit = self.unit
	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
	local _get_base_max_health = self:_get_base_max_health()
	local unit_game_object_id = self.network_manager:unit_game_object_id(unit)
	local wounds = get_difficulty_settings.wounds
	local mechanism_try_call, var_6_6, var_6_7 = Managers.mechanism:mechanism_try_call("get_setting", "wounds_amount")

	if not mechanism_try_call and not var_6_7 then
		wounds = var_6_6 + 1
	end

	local tbl = {
		current_temporary_health = 0,
		go_type = NetworkLookup.go_types.player_unit_health,
		unit_game_object_id = unit_game_object_id,
		current_health = _get_base_max_health,
		max_health = _get_base_max_health,
		uncursed_max_health = _get_base_max_health,
		current_wounds = wounds,
		max_wounds = wounds
	}
	local var_6_9 = callback(self, "cb_game_session_disconnect")

	self.health_game_object_id = self.network_manager:create_game_object("player_unit_health", tbl, var_6_9)
	self.previous_max_health = _get_base_max_health
	self.previous_state = self.state
end

PlayerUnitHealthExtension.sync_health_state = function (self)
	-- function 7
	local player = self.player
	local game_mode_data = Managers.party:get_player_status(player:network_id(), player:local_player_id()).game_mode_data
	local health_state = game_mode_data.health_state
	local health_percentage = game_mode_data.health_percentage
	local temporary_health_percentage = game_mode_data.temporary_health_percentage
	local slot_melee = game_mode_data.ammo.slot_melee
	local slot_ranged = game_mode_data.ammo.slot_ranged

	if not script_data.network_debug then
		printf("PlayerUnitHealthExtension:sync_health_state() health_state (%s) health_percentage (%s) temporary_health_percentage (%s) melee slot ammo (%s) ranged slot ammo (%s)", health_state, tostring(health_percentage), tostring(temporary_health_percentage), tostring(slot_melee), tostring(slot_ranged))
	end

	if health_state == nil then
		print("[PlayerUnitHealthExtension] Spawn manager returned nil value for spawn state, killing character. player:", player)
		table.dump(player)
	else
		self.set_health_percentage = health_percentage
		self.set_temporary_health_percentage = temporary_health_percentage

		if health_state == "knocked_down" then
			self.set_knocked_down = true
		end
	end
end

PlayerUnitHealthExtension._get_base_max_health = function (self)
	-- function 8
	local _profile_index = self._profile_index
	local _career_index = self._career_index
	local var_8_2 = SPProfiles[_profile_index].careers[_career_index]
	local max_hp = var_8_2.attributes.max_hp
	local str = var_8_2.name .. "_hp"
	local mechanism_try_call, var_8_6, var_8_7 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", str)

	if not mechanism_try_call and not var_8_7 and not var_8_6 then
		return var_8_6
	end

	return max_hp
end

PlayerUnitHealthExtension._calculate_buffed_max_health = function (self)
	-- function 9
	local buff_extension = self.buff_extension
	local state = self.state
	local var_9_2

	if state == "alive" then
		local _get_base_max_health = self:_get_base_max_health()

		var_9_2 = buff_extension:apply_buffs_to_value(_get_base_max_health, "max_health_alive")
	else
		local max_health_kd = Managers.state.game_mode:settings().max_health_kd

		var_9_2 = buff_extension:apply_buffs_to_value(max_health_kd, "max_health_kd")
	end

	return (buff_extension:apply_buffs_to_value(var_9_2, "max_health"))
end

PlayerUnitHealthExtension.get_buffed_max_health = function (self)
	-- function 10
	return (self:_calculate_buffed_max_health())
end

PlayerUnitHealthExtension._calculate_max_health = function (self)
	-- function 11
	local buff_extension = self.buff_extension
	local state = self.state
	local num = 1
	local num_buff_perk = buff_extension:num_buff_perk("skaven_grimoire")
	local apply_buffs_to_value = buff_extension:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
	local num_buff_perk_2 = buff_extension:num_buff_perk("twitch_grimoire")
	local apply_buffs_to_value_2 = buff_extension:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
	local num_buff_perk_3 = buff_extension:num_buff_perk("slayer_curse")
	local apply_buffs_to_value_3 = buff_extension:apply_buffs_to_value(PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF, "curse_protection")
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local num_buff_perk_4 = buff_extension:num_buff_perk("mutator_curse")
	local apply_buffs_to_value_4 = buff_extension:apply_buffs_to_value(WindSettings.light.curse_settings.value[get_difficulty], "curse_protection")
	local apply_buffs_to_value_5 = buff_extension:apply_buffs_to_value(0, "health_curse")
	local apply_buffs_to_value_6 = buff_extension:apply_buffs_to_value(apply_buffs_to_value_5, "curse_protection")

	if state == "knocked_down" then
		num_buff_perk_3 = 0
		apply_buffs_to_value_6 = 0
	end

	if num_buff_perk + num_buff_perk_2 + num_buff_perk_3 + num_buff_perk_4 + -apply_buffs_to_value_6 > 0 then
		num = 1 + num_buff_perk * apply_buffs_to_value + num_buff_perk_2 * apply_buffs_to_value_2 + num_buff_perk_3 * apply_buffs_to_value_3 + num_buff_perk_4 * apply_buffs_to_value_4 + apply_buffs_to_value_6
	end

	return self:_calculate_buffed_max_health() * math.max(num, 0.01)
end

PlayerUnitHealthExtension.extensions_ready = function (self, arg_12_1, arg_12_2)
	-- function 12
	self._world = arg_12_1
	self.status_extension = ScriptUnit.extension(arg_12_2, "status_system")
	self.buff_extension = ScriptUnit.extension(arg_12_2, "buff_system")

	if not DEDICATED_SERVER then
		self._outline_extension = ScriptUnit.extension(arg_12_2, "outline_system")
	end

	if not (not self.is_server and self.is_bot) then
		self:sync_health_state()
	end
end

PlayerUnitHealthExtension.knock_down = function (self, arg_13_1)
	-- function 13
	assert(self.is_server, "[PlayerUnitHealthExtension] 'knock_down' is a server only function")

	self.state = "knocked_down"

	StatusUtils.set_knocked_down_network(arg_13_1, true)
	StatusUtils.set_wounded_network(arg_13_1, false, "knocked_down")

	local recent_damages = self:recent_damages()
	local var_13_1 = recent_damages[DamageDataIndex.SOURCE_ATTACKER_UNIT]

	var_13_1 = var_13_1 or recent_damages[DamageDataIndex.ATTACKER]

	local owner = Managers.player:owner(var_13_1)

	if not (not owner and Managers.mechanism:current_mechanism_name() ~= "versus") then
		local stats_id = owner:stats_id()
		local statistics_db = Managers.player:statistics_db()

		Managers.state.entity:system("versus_horde_ability_system"):server_ability_recharge_boost(owner.peer_id, "hero_downed")

		local get_data = Unit.get_data(arg_13_1, "breed")

		statistics_db:increment_stat(stats_id, "vs_badge_knocked_down_target_per_breed", get_data.name)

		local side = Managers.state.side
		local versus_is_dark_pact = side:versus_is_dark_pact(var_13_1)
		local versus_is_hero = side:versus_is_hero(arg_13_1)

		if not versus_is_dark_pact and not versus_is_hero then
			local extension_input = ScriptUnit.extension_input(var_13_1, "dialogue_system")
			local var_13_10 = side.side_by_unit[arg_13_1]
			local num = 0
			local PLAYER_AND_BOT_UNITS = var_13_10.PLAYER_AND_BOT_UNITS

			for i = 1, #PLAYER_AND_BOT_UNITS do
				local has_extension = ScriptUnit.has_extension(PLAYER_AND_BOT_UNITS[i], "status_system")

				if not has_extension and not has_extension:is_knocked_down() then
					num = num + 1
				end
			end

			if num >= DialogueSettings.vs_many_heroes_incapacitated_num then
				extension_input:trigger_dialogue_event("vs_many_heroes_incapacitated")
			else
				extension_input:trigger_dialogue_event("vs_downed_hero")
			end
		end
	end
end

PlayerUnitHealthExtension._revive = function (self, arg_14_1, arg_14_2)
	-- function 14
	self.state = "alive"

	StatusUtils.set_knocked_down_network(arg_14_1, false)
	StatusUtils.set_wounded_network(arg_14_1, true, "revived", arg_14_2)
	StatusUtils.set_revived_network(arg_14_1, false)
end

PlayerUnitHealthExtension.update = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local status_extension = self.status_extension
	local unit = self.unit

	if self._shield_duration_left > 0 then
		self._shield_duration_left = self._shield_duration_left - arg_15_1
	elseif not self._end_reason then
		self:remove_assist_shield("timed_out")
	end

	if not self.is_server then
		if not self.set_knocked_down then
			if not status_extension:is_knocked_down() then
				self:knock_down(unit)
			end

			self.set_knocked_down = false
		elseif self.state == "alive" then
			if not (self:_is_alive() or status_extension:is_knocked_down()) then
				self:knock_down(unit)
			end
		elseif (self.state ~= "knocked_down" or not self:_is_alive()) and not status_extension:is_revived() then
			self:_revive(unit, arg_15_3)
		end

		local game = self.game
		local health_game_object_id = self.health_game_object_id

		if game or not health_game_object_id then
			local _calculate_max_health = self:_calculate_max_health()
			local networkify_health = DamageUtils.networkify_health(_calculate_max_health)
			local _calculate_buffed_max_health = self:_calculate_buffed_max_health()
			local networkify_health_2 = DamageUtils.networkify_health(_calculate_buffed_max_health)

			GameSession.set_game_object_field(game, health_game_object_id, "max_health", networkify_health)
			GameSession.set_game_object_field(game, health_game_object_id, "uncursed_max_health", networkify_health_2)

			local state = self.state
			local previous_state = self.previous_state
			local previous_max_health = self.previous_max_health
			local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")
			local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")

			if not (not previous_state and state == previous_state) then
				if state == "knocked_down" then
					game_object_field = 0
					game_object_field_2 = networkify_health
				elseif state == "alive" then
					local buff_extension = self.buff_extension
					local flag = not buff_extension and buff_extension:has_buff_perk("temp_to_permanent_health")

					game_object_field = self._percent_health_on_revive * networkify_health
					game_object_field_2 = self._percent_temp_health_on_revive * networkify_health

					if not flag then
						game_object_field = game_object_field + game_object_field_2
						game_object_field_2 = 0
					end

					if not buff_extension:has_buff_perk(scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.full_health_revive) then
						game_object_field = networkify_health
						game_object_field_2 = 0
					end
				end
			elseif networkify_health ~= previous_max_health then
				local var_15_15
				local var_15_16
				local num

				if previous_max_health == 0 then
					var_15_15 = 0
					num = 0
				else
					var_15_15 = game_object_field / previous_max_health
					num = game_object_field_2 / previous_max_health
				end

				game_object_field = networkify_health * var_15_15
				game_object_field_2 = networkify_health * num
			end

			local set_health_percentage = self.set_health_percentage

			if not set_health_percentage then
				game_object_field = networkify_health * set_health_percentage
				self.set_health_percentage = nil
			end

			local set_temporary_health_percentage = self.set_temporary_health_percentage

			if not set_temporary_health_percentage then
				game_object_field_2 = networkify_health * set_temporary_health_percentage
				self.set_temporary_health_percentage = nil
			end

			local networkify_health_3 = DamageUtils.networkify_health(game_object_field)
			local networkify_health_4 = DamageUtils.networkify_health(game_object_field_2)

			GameSession.set_game_object_field(game, health_game_object_id, "current_health", networkify_health_3)
			GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", networkify_health_4)

			if arg_15_3 >= self.wounded_degen_timer then
				local is_wounded = status_extension:is_wounded()
				local WOUNDED_DEGEN_AMOUNT = PlayerUnitStatusSettings.WOUNDED_DEGEN_AMOUNT
				local WOUNDED_DEGEN_DELAY = PlayerUnitStatusSettings.WOUNDED_DEGEN_DELAY

				if not is_wounded then
					WOUNDED_DEGEN_AMOUNT, WOUNDED_DEGEN_DELAY = self:health_degen_settings()
				end

				if not (not (networkify_health_4 > 0) or state ~= "alive") then
					if Managers.mechanism:current_mechanism_name() == "versus" then
						local tbl = {
							degen_delay = 0.8,
							degen_amount = 1.5
						}

						WOUNDED_DEGEN_AMOUNT = PlayerUnitStatusSettings.WOUNDED_DEGEN_AMOUNT * tbl.degen_amount
						WOUNDED_DEGEN_DELAY = PlayerUnitStatusSettings.WOUNDED_DEGEN_DELAY * tbl.degen_delay
					end

					local num_2 = networkify_health_4 - WOUNDED_DEGEN_AMOUNT
					local flag_2

					flag_2 = not (networkify_health_3 <= 0) or not 1 or 0

					local num_3 = networkify_health_4 - math.max(num_2, flag_2)

					if num_3 > 0 then
						DamageUtils.add_damage_network(unit, unit, num_3, "torso", "temporary_health_degen", nil, Vector3(1, 0, 0), "temporary_health_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
					end
				end

				self.wounded_degen_timer = arg_15_3 + WOUNDED_DEGEN_DELAY
			end

			self.previous_state = state
			self.previous_max_health = networkify_health

			if networkify_health <= 0 then
				Managers.state.entity:system("death_system"):forced_kill(unit, "forced")
			end
		end
	end
end

PlayerUnitHealthExtension._update_outline_color = function (self, arg_16_1, arg_16_2)
	-- function 16
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local network_id = local_player:network_id()
	local local_player_id = local_player:local_player_id()
	local var_16_3
	local _outline_extension = self._outline_extension
	local is_disabled = self.status_extension:is_disabled()
	local current_health_percent = self:current_health_percent()
	local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)

	if not get_party_from_player_id then
		return
	end

	local flag = Managers.state.side.side_by_party[get_party_from_player_id]:name() == "dark_pact"
	local var_16_9 = Managers.state.side.side_by_unit[self.unit]
	local flag_2 = var_16_9:name() == "heroes"

	if not (not flag and not var_16_9 and flag_2) then
		var_16_3 = nil
	elseif not is_disabled then
		var_16_3 = OutlineSettingsVS.colors.hero_dying
	elseif current_health_percent >= 0.66 then
		var_16_3 = OutlineSettingsVS.colors.hero_healthy
	elseif current_health_percent >= 0.33 then
		var_16_3 = OutlineSettingsVS.colors.hero_hurt
	else
		var_16_3 = OutlineSettingsVS.colors.hero_dying
	end

	if not var_16_3 then
		if not self._outline_id then
			_outline_extension:remove_outline(self._outline_id)

			self._outline_id = nil
		end
	elseif not self._outline_id then
		self._outline_id = _outline_extension:add_outline({
			priority = 2,
			method = "always",
			outline_color = var_16_3,
			flag = OutlineSettings.flags.non_wall_occluded
		})
	elseif self._current_outline_color ~= var_16_3 then
		_outline_extension:update_outline({
			outline_color = var_16_3
		}, self._outline_id)
	end

	self._current_outline_color = var_16_3
end

local tbl = {
	death_explosion = true
}

PlayerUnitHealthExtension.apply_client_predicted_damage = function (arg_17_0, arg_17_1)
	-- function 17
	return
end

local flag = true
local num = 2.2

PlayerUnitHealthExtension.create_streak_damage = function (self, arg_18_1, arg_18_2)
	-- function 18
	local auto_lerp = math.auto_lerp(0, 30, self._min_streak_font_size, self._max_streak_font_size, arg_18_1)
	local var_18_1 = num
	local get_color_from_damage = DamageUtils.get_color_from_damage(arg_18_1)
	local z_onscreen_damage_offset = arg_18_2.z_onscreen_damage_offset
	local var_18_4 = Vector3(get_color_from_damage[2], get_color_from_damage[3], get_color_from_damage[4])
	local floor = math.floor(arg_18_1)
	local num_2 = arg_18_1 % 1 * 100
	local _display_data = self._display_data

	_display_data.floating_speed = 0
	_display_data.ref = true
	_display_data.using_bucket_damage = flag
	_display_data.damage = arg_18_1
	_display_data.variant_name = "streak_damage"

	local flag_2 = false
	local var_18_9

	if not (not flag and not (floor >= 1)) then
		var_18_9 = string.format("{#size(%s)}%s", auto_lerp, floor)
	else
		var_18_9 = string.format("{#size(%s)}%s{#size(%s)}%s", auto_lerp, floor, math.floor(auto_lerp / 2), num_2)
	end

	Managers.state.event:trigger("add_damage_number", var_18_9, auto_lerp, self.unit, var_18_1, var_18_4, flag_2, z_onscreen_damage_offset, _display_data)

	if type(_display_data.ref) == "table" then
		self._streak_ref = _display_data.ref
	end
end

PlayerUnitHealthExtension.add_damage = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14, arg_19_15, arg_19_16, arg_19_17)
	-- function 19
	if not DamageUtils.is_in_inn then
		return
	end

	local status_extension = self.status_extension

	if not status_extension:is_ready_for_assisted_respawn() then
		return
	end

	local unit = self.unit
	local get_actual_attacker_player = AiUtils.get_actual_attacker_player(arg_19_1, unit, arg_19_7)

	if not arg_19_9 then
		if not get_actual_attacker_player and not ALIVE[get_actual_attacker_player.player_unit] then
			arg_19_9 = get_actual_attacker_player.player_unit
		end

		arg_19_9 = AiUtils.get_actual_attacker_unit(arg_19_9 or arg_19_1)

		if not arg_19_9 then
			local attacker_unit_id = self.last_damage_data.attacker_unit_id

			arg_19_9 = not attacker_unit_id and Managers.state.unit_storage:unit(attacker_unit_id)
		end
	end

	local var_19_4 = BLACKBOARDS[arg_19_9]
	local get_data

	if not ALIVE[arg_19_9] then
		get_data = Unit.get_data(arg_19_9, "breed")

		if not get_data then
			-- Nothing
		end
	end

	if not var_19_4 then
		get_data = var_19_4.breed

		if not get_data then
			-- Nothing
		end
	end

	get_data = ALIVE[arg_19_1]
	get_data = not get_data and Unit.get_data(arg_19_1, "breed")

	::label_19_0::

	local get_actual_attacker_breed = AiUtils.get_actual_attacker_breed(get_data, unit, arg_19_7, arg_19_1, get_actual_attacker_player)

	if not get_actual_attacker_player then
		local unique_id = get_actual_attacker_player:unique_id()

		if unique_id ~= Managers.player:owner(unit):unique_id() then
			local time = Managers.time:time("game")

			self:_register_attacker(unique_id, get_actual_attacker_breed, time)
		end
	end

	if not get_actual_attacker_breed then
		if not self._use_floating_damage_numbers then
			local user_setting = Application.user_setting("hud_damage_feedback_in_world")

			if not get_actual_attacker_player and not get_actual_attacker_player.local_player and not get_actual_attacker_breed.is_player and get_actual_attacker_breed.is_hero or not user_setting then
				local _streak_damage = self._streak_damage

				_streak_damage = _streak_damage or 0

				local _streak_damage_time = self._streak_damage_time

				_streak_damage_time = _streak_damage_time or 0

				local time_2 = Managers.time:time("game")

				if not (not (time_2 - _streak_damage_time > 1) or not (arg_19_2 > 0)) then
					_streak_damage = arg_19_2

					if not self._show_floating_streak_damage then
						self:create_streak_damage(_streak_damage, get_actual_attacker_breed)
					end
				else
					_streak_damage = _streak_damage + arg_19_2

					if not self._streak_ref then
						local floor = math.floor(_streak_damage)
						local auto_lerp = math.auto_lerp(0, 30, self._min_streak_font_size, self._max_streak_font_size, _streak_damage)
						local get_color_from_damage = DamageUtils.get_color_from_damage(_streak_damage)
						local var_19_16

						if not (not flag and not (_streak_damage >= 1)) then
							local format = string.format("{#size(%s)}%s", auto_lerp, floor)

							Managers.state.event:trigger("alter_damage_number", unit, self._streak_ref, {
								text = format,
								time = num,
								color = get_color_from_damage,
								damage = _streak_damage
							})
						else
							local num_2 = _streak_damage % 1 * 100
							local format_2 = string.format("{#size(%s)}%s{#size(%s)}%s", auto_lerp, floor, math.floor(auto_lerp / 2), num_2)

							Managers.state.event:trigger("alter_damage_number", unit, self._streak_ref, {
								text = format_2,
								time = num,
								color = get_color_from_damage,
								damage = _streak_damage
							})
						end
					end
				end

				self._streak_damage_time = time_2
				self._streak_damage = _streak_damage

				if not self._show_floating_damage then
					DamageUtils.add_unit_floating_damage_numbers(unit, arg_19_4, arg_19_2, arg_19_11, _streak_damage, get_actual_attacker_breed.z_onscreen_damage_offset, get_actual_attacker_breed.damage_numbers_font_override, {
						variant_name = "floating_damage",
						using_streak_damage = self._show_floating_streak_damage
					})
				end
			end
		end

		local get_attributes = Managers.state.entity:system("ai_system"):get_attributes(arg_19_1)

		if get_actual_attacker_breed.boss or not get_attributes.grudge_marked then
			local owner = Managers.player:owner(self.unit)

			if not owner then
				-- Nothing
			end

			::label_19_1::

			local local_player = owner.local_player

			local_player = not local_player and not owner.bot_player

			::label_19_2::

			if not (not owner and not get_actual_attacker_player and owner ~= get_actual_attacker_player) and not local_player then
				Managers.state.event:trigger("boss_health_bar_register_unit", arg_19_1, "damage_taken")
			end

			QuestSettings.handle_bastard_block(self.unit, arg_19_1, false)
		end
	end

	if not (arg_19_7 ~= "ground_impact" or get_actual_attacker_breed.is_hero) then
		return
	end

	fassert(arg_19_4, "No damage_type!")

	local _add_to_damage_history_buffer = self:_add_to_damage_history_buffer(unit, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_13, arg_19_14, arg_19_15, nil, arg_19_17)

	if not (arg_19_4 == "temporary_health_degen" or arg_19_4 == "knockdown_bleed") then
		StatisticsUtil.register_damage(unit, _add_to_damage_history_buffer, self.statistics_db)
	end

	self:save_kill_feed_data(arg_19_1, _add_to_damage_history_buffer, arg_19_3, arg_19_4, arg_19_7, arg_19_9)

	self._recent_damage_type = arg_19_4
	self._recent_hit_react_type = arg_19_10

	local controller_features = Managers.state.controller_features

	if not (not controller_features and not self.player.local_player and not (arg_19_2 > 0) or arg_19_4 == "temporary_health_degen") then
		controller_features:add_effect("hit_rumble", {
			damage_amount = arg_19_2,
			unit = unit
		})
	end

	if not (Script.type_name(arg_19_2) ~= "number" or not (arg_19_2 > 0) or arg_19_4 == "temporary_health_degen" or arg_19_7 == "temporary_health_degen") then
		local owner_2 = Managers.player:owner(unit)
		local var_19_26 = POSITION_LOOKUP[unit]

		Managers.telemetry_events:player_damaged(owner_2, arg_19_4, arg_19_7 or "n/a", arg_19_2, var_19_26)

		if DEDICATED_SERVER or not get_actual_attacker_player then
			local local_player_2 = Managers.player:local_player()

			if get_actual_attacker_player:unique_id() == local_player_2:unique_id() then
				local var_19_28 = POSITION_LOOKUP[arg_19_1]
				local get_data_2 = Unit.get_data(unit, "breed")

				Managers.telemetry_events:local_player_damaged_player(get_actual_attacker_player, get_data_2.name, arg_19_2, var_19_28, var_19_26)
			end
		end
	end

	local extension = ScriptUnit.extension(unit, "buff_system")

	if not (not (arg_19_2 > 0) or arg_19_7 == "temporary_health_degen") then
		extension:trigger_procs("on_damage_taken", arg_19_1, arg_19_2, arg_19_4)
	end

	local flag_2

	flag_2 = not extension:has_buff_perk("ignore_death") and 1 and 0

	if not (arg_19_7 == "dot_debuff" or arg_19_4 == "temporary_health_degen" or arg_19_4 == "overcharge") then
		local is_enemy = Managers.state.side:is_enemy(arg_19_9, unit)
		local flag_3 = not is_enemy and DamageUtils.is_player_unit(arg_19_9)

		if not flag_3 then
			EffectHelper.vs_play_hit_sound(self._world, unit, arg_19_15, arg_19_4, arg_19_7)
		end

		local has_extension = ScriptUnit.has_extension(arg_19_1, "ai_inventory_system")

		if not has_extension then
			has_extension:play_hit_sound(unit, arg_19_4)
		elseif not self._is_husk then
			if not flag_3 then
				local var_19_35 = SPProfiles[self._profile_index]

				if not HEALTH_ALIVE[unit] then
					local camera = Managers.state.camera

					if var_19_35.role == "boss" then
						camera:camera_effect_shake_event("damaged_boss", Managers.time:time("game"), 2)
					elseif var_19_35.role ~= "boss" then
						camera:camera_effect_shake_event("damaged", Managers.time:time("game"), 2)
					end
				end
			end

			if not is_enemy then
				EffectHelper.play_local_damage_taken_sound(self._world, unit, arg_19_7)
			end
		end

		if not self.player.local_player and extension:has_buff_type("bardin_ironbreaker_activated_ability") and not extension:has_buff_type("bardin_ironbreaker_activated_ability_taunt_range_and_duration") then
			ScriptUnit.extension(unit, "first_person_system"):play_hud_sound_event("Play_career_ability_bardin_ironbreaker_hit")
		end
	elseif arg_19_7 == "dot_debuff" then
		local is_enemy_2 = Managers.state.side:is_enemy(arg_19_9, unit)

		if not (not is_enemy_2 and DamageUtils.is_player_unit(arg_19_9)) then
			EffectHelper.vs_play_hit_sound(self._world, unit, arg_19_15, arg_19_4, arg_19_7)

			if not self._is_husk then
				local var_19_38 = SPProfiles[self._profile_index]

				if not HEALTH_ALIVE[unit] then
					local camera_2 = Managers.state.camera

					if var_19_38.role == "boss" then
						camera_2:camera_effect_shake_event("damaged_boss", Managers.time:time("game"), 2)
					elseif var_19_38.role ~= "boss" then
						camera_2:camera_effect_shake_event("damaged", Managers.time:time("game"), 2)
					end
				end
			end
		end

		if not (not is_enemy_2 and self._is_husk) then
			EffectHelper.play_local_damage_taken_sound(self._world, unit, arg_19_7)
		end
	end

	DamageUtils.handle_hit_indication(arg_19_1, unit, arg_19_2, arg_19_3, arg_19_12)

	local weave = Managers.weave

	if not (not weave:get_active_weave() and not self.is_server and not (arg_19_2 > 0)) then
		weave:player_damaged(arg_19_2)
	end

	if not (not self.is_server and self:get_is_invincible() or script_data.player_invincible) then
		local game = self.game
		local health_game_object_id = self.health_game_object_id

		if not game and not health_game_object_id then
			local var_19_43 = tbl[arg_19_4]
			local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")
			local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")
			local var_19_46
			local var_19_47
			local num_3 = game_object_field + game_object_field_2
			local num_4

			if num_3 <= arg_19_2 then
				num_4 = num_3 - flag_2

				if not num_4 then
					-- Nothing
				end
			end

			num_4 = arg_19_2

			::label_19_3::

			if not var_19_43 then
				var_19_46 = not (game_object_field < num_4) or not game_object_field or num_4
				var_19_47 = not (game_object_field < num_4) or not (num_4 - game_object_field) or 0
			else
				var_19_46 = not (game_object_field_2 < num_4) or not (num_4 - game_object_field_2) or 0
				var_19_47 = not (game_object_field_2 < num_4) or not game_object_field_2 or num_4
			end

			local flag_4

			flag_4 = not (game_object_field < var_19_46) or not 0 or game_object_field - var_19_46

			if not script_data.player_unkillable then
				flag_4 = math.max(flag_4, 1)
			end

			GameSession.set_game_object_field(game, health_game_object_id, "current_health", flag_4)

			local flag_5

			flag_5 = not (game_object_field_2 < var_19_47) or not 0 or game_object_field_2 - var_19_47

			GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", flag_5)

			local flag_6 = not (flag_4 + flag_5 <= 0) or self.state ~= "alive" or not status_extension:has_wounds_remaining()

			if not (not flag_6 and self.state == "dead") then
				Managers.state.entity:system("death_system"):kill_unit(unit, _add_to_damage_history_buffer)
			end

			local go_id = self.unit_storage:go_id(unit)
			local game_object_or_level_id, var_19_55 = self.network_manager:game_object_or_level_id(arg_19_1)
			local unit_game_object_id = self.network_manager:unit_game_object_id(arg_19_9)

			unit_game_object_id = unit_game_object_id or game_object_or_level_id

			local var_19_57 = NetworkLookup.hit_zones[arg_19_3]
			local var_19_58 = NetworkLookup.damage_types[arg_19_4]
			local var_19_59 = NetworkLookup.damage_sources[arg_19_7 or "n/a"]
			local var_19_60 = NetworkLookup.hit_ragdoll_actors[arg_19_8 or "n/a"]
			local var_19_61 = NetworkLookup.hit_react_types[arg_19_10 or "light"]
			local var_19_62 = NetworkLookup.buff_attack_types[arg_19_15 or "n/a"]

			arg_19_11 = arg_19_11 or false
			arg_19_12 = arg_19_12 or false
			arg_19_13 = arg_19_13 or false
			arg_19_14 = arg_19_14 or 1
			arg_19_16 = arg_19_16 or 1
			arg_19_17 = arg_19_17 or 1

			self.network_transmit:send_rpc_clients("rpc_add_damage", go_id, false, game_object_or_level_id, var_19_55, unit_game_object_id, arg_19_2, var_19_57, var_19_58, arg_19_5, arg_19_6, var_19_59, var_19_60, var_19_61, flag_6, arg_19_11, arg_19_12, arg_19_13, arg_19_14, var_19_62, arg_19_16, arg_19_17)
		end
	end
end

PlayerUnitHealthExtension.add_heal = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	local unit = self.unit
	local status_extension = self.status_extension

	self:_add_to_damage_history_buffer(unit, arg_20_1, -arg_20_2, nil, "heal", nil, arg_20_3, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)

	if not status_extension and not status_extension:heal_can_remove_wounded(arg_20_4) then
		Managers.razer_chroma:play_animation("health_potion", false, RAZER_ADD_ANIMATION_TYPE.REPLACE)
	end

	Managers.state.achievement:trigger_event("register_heal", arg_20_1, unit, arg_20_2, arg_20_4)

	if not self.is_server then
		local game = self.game
		local health_game_object_id = self.health_game_object_id

		if not game and not health_game_object_id then
			local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")
			local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")
			local game_object_field_3 = GameSession.game_object_field(game, health_game_object_id, "max_health")

			if not (not status_extension:is_permanent_heal(arg_20_4) and status_extension:is_knocked_down()) then
				local flag

				flag = not (game_object_field_2 < arg_20_2) or not 0 or game_object_field_2 - arg_20_2

				GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", flag)

				local flag_2 = not (game_object_field_3 < game_object_field + flag + arg_20_2) or not game_object_field_3 or game_object_field + arg_20_2

				GameSession.set_game_object_field(game, health_game_object_id, "current_health", flag_2)
			else
				local num

				if game_object_field_3 < game_object_field + game_object_field_2 + arg_20_2 then
					num = game_object_field_3 - game_object_field

					if not num then
						-- Nothing
					end
				end

				num = game_object_field_2 + arg_20_2

				::label_20_0::

				GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", num)
			end

			if (arg_20_4 == "career_passive" or not status_extension:is_wounded()) and not self._temp_hp_degen_delay_when_wounded then
				local time = Managers.time:time("game")
				local health_degen_settings, var_20_12, var_20_13 = self:health_degen_settings()

				self.wounded_degen_timer = time + var_20_13
			end

			local go_id = self.unit_storage:go_id(unit)

			if not go_id then
				local network_transmit = self.network_transmit
				local game_object_or_level_id, var_20_17 = Managers.state.network:game_object_or_level_id(arg_20_1)
				local var_20_18 = NetworkLookup.heal_types[arg_20_4]

				network_transmit:send_rpc_clients("rpc_heal", go_id, false, game_object_or_level_id, var_20_17, arg_20_2, var_20_18)
			end
		end
	end
end

PlayerUnitHealthExtension.die = function (self, arg_21_1)
	-- function 21
	if not self.is_server then
		return
	end

	arg_21_1 = arg_21_1 or "undefined"

	local unit = self.unit

	if not (not self.is_bot and arg_21_1 ~= "volume_insta_kill") then
		local var_21_1 = BLACKBOARDS[unit]
		local nav_world = var_21_1.nav_world
		local PLAYER_POSITIONS = Managers.state.side.side_by_unit[unit].PLAYER_POSITIONS
		local count = #PLAYER_POSITIONS

		for i = 1, count do
			local var_21_5 = PLAYER_POSITIONS[i]
			local new_random_goal_uniformly_distributed = LocomotionUtils.new_random_goal_uniformly_distributed(nav_world, nil, var_21_5, 2, 5, 5)

			if not new_random_goal_uniformly_distributed then
				var_21_1.locomotion_extension:teleport_to(new_random_goal_uniformly_distributed)
				var_21_1.navigation_extension:teleport(new_random_goal_uniformly_distributed)
				var_21_1.ai_extension:clear_failed_paths()

				return
			end
		end
	end

	if self.state ~= "dead" then
		local game = self.game
		local health_game_object_id = self.health_game_object_id

		if not game and not health_game_object_id then
			GameSession.set_game_object_field(game, health_game_object_id, "current_health", 0)
			GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", 0)
			Managers.state.entity:system("death_system"):forced_kill(unit, arg_21_1)
		end
	end
end

PlayerUnitHealthExtension.entered_kill_volume = function (self, arg_22_1)
	-- function 22
	if not self.is_local_player then
		local go_id = self.unit_storage:go_id(self.unit)

		if not go_id then
			local network_transmit = self.network_transmit
			local volume_insta_kill = NetworkLookup.damage_types.volume_insta_kill

			network_transmit:send_rpc_server("rpc_request_insta_kill", go_id, volume_insta_kill)
		end
	end
end

PlayerUnitHealthExtension.destroy = function (self)
	-- function 23
	if not self.is_server and not self.health_game_object_id then
		self.network_manager:destroy_game_object(self.health_game_object_id)
	end

	self.health_game_object_id = nil
end

PlayerUnitHealthExtension.reset = function (self)
	-- function 24
	if not self.is_server then
		self.state = "alive"

		local game = self.game
		local health_game_object_id = self.health_game_object_id

		if not game and not health_game_object_id then
			local game_object_field = GameSession.game_object_field(game, health_game_object_id, "max_health")

			GameSession.set_game_object_field(game, health_game_object_id, "current_health", game_object_field)
			GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", 0)
		end
	end
end

PlayerUnitHealthExtension.is_alive = function (self)
	-- function 25
	return self.state ~= "dead"
end

PlayerUnitHealthExtension._is_alive = function (self)
	-- function 26
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		return GameSession.game_object_field(game, health_game_object_id, "current_health") + GameSession.game_object_field(game, health_game_object_id, "current_temporary_health") > 0
	end

	return true
end

PlayerUnitHealthExtension.current_health_percent = function (self)
	-- function 27
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")
		local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")
		local game_object_field_3 = GameSession.game_object_field(game, health_game_object_id, "max_health")

		if game_object_field_3 == 0 then
			return 0
		else
			return (game_object_field + game_object_field_2) / game_object_field_3
		end
	end

	return 1
end

PlayerUnitHealthExtension.current_permanent_health_percent = function (self)
	-- function 28
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")
		local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "max_health")

		if game_object_field_2 == 0 then
			return 0
		else
			return game_object_field / game_object_field_2
		end
	end

	return 1
end

PlayerUnitHealthExtension.current_temporary_health_percent = function (self)
	-- function 29
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")
		local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "max_health")

		if game_object_field_2 == 0 then
			return 0
		else
			return game_object_field / game_object_field_2
		end
	end

	return 1
end

PlayerUnitHealthExtension.current_health = function (self)
	-- function 30
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		return GameSession.game_object_field(game, health_game_object_id, "current_health") + GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")
	end

	local _calculate_max_health = self:_calculate_max_health()

	return (DamageUtils.networkify_health(_calculate_max_health))
end

PlayerUnitHealthExtension.current_permanent_health = function (self)
	-- function 31
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		return (GameSession.game_object_field(game, health_game_object_id, "current_health"))
	end

	local _calculate_max_health = self:_calculate_max_health()

	return (DamageUtils.networkify_health(_calculate_max_health))
end

PlayerUnitHealthExtension.current_temporary_health = function (self)
	-- function 32
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		return (GameSession.game_object_field(game, health_game_object_id, "current_temporary_health"))
	end

	local _calculate_max_health = self:_calculate_max_health()

	return (DamageUtils.networkify_health(_calculate_max_health))
end

PlayerUnitHealthExtension.get_max_health = function (self)
	-- function 33
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		return (GameSession.game_object_field(game, health_game_object_id, "max_health"))
	end

	local _calculate_max_health = self:_calculate_max_health()

	return (DamageUtils.networkify_health(_calculate_max_health))
end

PlayerUnitHealthExtension.get_base_max_health = function (self)
	-- function 34
	return (self:_get_base_max_health())
end

PlayerUnitHealthExtension.get_uncursed_max_health = function (self)
	-- function 35
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		return (GameSession.game_object_field(game, health_game_object_id, "uncursed_max_health"))
	end

	local _calculate_max_health = self:_calculate_max_health()

	return (DamageUtils.networkify_health(_calculate_max_health))
end

PlayerUnitHealthExtension.get_damage_taken = function (self, arg_36_1)
	-- function 36
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")

		return GameSession.game_object_field(game, health_game_object_id, arg_36_1 or "max_health") - game_object_field
	end

	return 0
end

PlayerUnitHealthExtension.convert_permanent_to_temporary_health = function (self)
	-- function 37
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")
		local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")

		GameSession.set_game_object_field(game, health_game_object_id, "current_health", 0)
		GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", game_object_field + game_object_field_2)
	end
end

PlayerUnitHealthExtension.convert_temporary_to_permanent_health = function (self)
	-- function 38
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")
		local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")

		GameSession.set_game_object_field(game, health_game_object_id, "current_health", game_object_field + game_object_field_2)
		GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", 0)
	end
end

PlayerUnitHealthExtension.convert_to_temp = function (self, arg_39_1)
	-- function 39
	arg_39_1 = DamageUtils.networkify_damage(arg_39_1)

	if not self.is_server then
		local game = self.game
		local health_game_object_id = self.health_game_object_id

		if not game and not health_game_object_id then
			local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")
			local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")
			local min = math.min(game_object_field, arg_39_1)

			GameSession.set_game_object_field(game, health_game_object_id, "current_health", game_object_field - min)
			GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", game_object_field_2 + min)
		end
	else
		local go_id = self.unit_storage:go_id(self.unit)

		if not go_id then
			self.network_transmit:send_rpc_server("rpc_request_convert_temp", go_id, arg_39_1)
		end
	end
end

PlayerUnitHealthExtension.switch_permanent_and_temporary_health = function (self)
	-- function 40
	local game = self.game
	local health_game_object_id = self.health_game_object_id

	if not game and not health_game_object_id then
		local game_object_field = GameSession.game_object_field(game, health_game_object_id, "current_health")
		local game_object_field_2 = GameSession.game_object_field(game, health_game_object_id, "current_temporary_health")

		GameSession.set_game_object_field(game, health_game_object_id, "current_health", game_object_field_2)
		GameSession.set_game_object_field(game, health_game_object_id, "current_temporary_health", game_object_field)
	end
end

PlayerUnitHealthExtension.shield = function (self, arg_41_1)
	-- function 41
	self._shield_amount = arg_41_1
	self._shield_duration_left = 10
	self._end_reason = nil

	if not script_data.damage_debug then
		printf("[PlayerUnitHealthExtension] shield %.1f to %s", arg_41_1, tostring(self.unit))
	end
end

PlayerUnitHealthExtension.has_assist_shield = function (self)
	-- function 42
	return not (self._shield_duration_left > 0) or self._shield_amount > 0, self._shield_amount
end

PlayerUnitHealthExtension.remove_assist_shield = function (self, arg_43_1)
	-- function 43
	self._shield_duration_left = 0
	self._shield_amount = 0
	self._end_reason = arg_43_1
end

PlayerUnitHealthExtension.previous_shield_end_reason = function (self)
	-- function 44
	return self._end_reason
end

PlayerUnitHealthExtension.set_dead = function (self)
	-- function 45
	self.state = "dead"

	self.status_extension:set_dead(true)

	local unit = self.unit

	HEALTH_ALIVE[unit] = nil

	if not ScriptUnit.has_extension(unit, "dialogue_system") then
		local death_discover_distance = DialogueSettings.death_discover_distance
		local player_profile = ScriptUnit.extension(unit, "dialogue_system").context.player_profile

		SurroundingAwareSystem.add_event(unit, "player_death", death_discover_distance, "target", unit, "target_name", player_profile)
	end

	local recent_damages = self:recent_damages()
	local stats_id = Managers.player:owner(unit):stats_id()

	Managers.state.event:trigger("on_player_death", stats_id, unit, recent_damages)
end

PlayerUnitHealthExtension.set_max_health = function (self, arg_46_1)
	-- function 46
	return self.health
end

PlayerUnitHealthExtension.set_current_damage = function (arg_47_0, arg_47_1)
	-- function 47
	return
end

PlayerUnitHealthExtension.health_degen_settings = function (self)
	-- function 48
	local buff_extension = self.buff_extension
	local NOT_WOUNDED_DEGEN_AMOUNT = PlayerUnitStatusSettings.NOT_WOUNDED_DEGEN_AMOUNT
	local NOT_WOUNDED_DEGEN_DELAY = PlayerUnitStatusSettings.NOT_WOUNDED_DEGEN_DELAY
	local NOT_WOUNDED_DEGEN_START = PlayerUnitStatusSettings.NOT_WOUNDED_DEGEN_START

	if not buff_extension then
		if not buff_extension:has_buff_perk("smiter_healing") then
			NOT_WOUNDED_DEGEN_AMOUNT = PlayerUnitStatusSettings.SMITER_DEGEN_AMOUNT
			NOT_WOUNDED_DEGEN_DELAY = PlayerUnitStatusSettings.SMITER_DEGEN_DELAY
			NOT_WOUNDED_DEGEN_START = PlayerUnitStatusSettings.SMITER_DEGEN_START
		elseif not buff_extension:has_buff_perk("linesman_healing") then
			NOT_WOUNDED_DEGEN_AMOUNT = PlayerUnitStatusSettings.LINESMAN_DEGEN_AMOUNT
			NOT_WOUNDED_DEGEN_DELAY = PlayerUnitStatusSettings.LINESMAN_DEGEN_DELAY
			NOT_WOUNDED_DEGEN_START = PlayerUnitStatusSettings.LINESMAN_DEGEN_START
		elseif not buff_extension:has_buff_perk("tank_healing") then
			NOT_WOUNDED_DEGEN_AMOUNT = PlayerUnitStatusSettings.TANK_DEGEN_AMOUNT
			NOT_WOUNDED_DEGEN_DELAY = PlayerUnitStatusSettings.TANK_DEGEN_DELAY
			NOT_WOUNDED_DEGEN_START = PlayerUnitStatusSettings.TANK_DEGEN_START
		elseif not buff_extension:has_buff_perk("ninja_healing") then
			NOT_WOUNDED_DEGEN_AMOUNT = PlayerUnitStatusSettings.NINJA_DEGEN_AMOUNT
			NOT_WOUNDED_DEGEN_DELAY = PlayerUnitStatusSettings.NINJA_DEGEN_DELAY
			NOT_WOUNDED_DEGEN_START = PlayerUnitStatusSettings.NINJA_DEGEN_START
		end
	end

	if Managers.weave:get_active_wind() == "death" then
		NOT_WOUNDED_DEGEN_AMOUNT = NOT_WOUNDED_DEGEN_AMOUNT * 2
		NOT_WOUNDED_DEGEN_START = 0
	end

	return NOT_WOUNDED_DEGEN_AMOUNT, NOT_WOUNDED_DEGEN_DELAY, NOT_WOUNDED_DEGEN_START
end
