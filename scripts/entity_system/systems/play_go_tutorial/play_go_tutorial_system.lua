-- chunkname: @scripts/entity_system/systems/play_go_tutorial/play_go_tutorial_system.lua

require("scripts/entity_system/systems/play_go_tutorial/play_go_pause_templates")

local tbl = {
	"PlayGoTutorialExtension"
}

PlayGoTutorialSystem = class(PlayGoTutorialSystem, ExtensionSystemBase)

PlayGoTutorialSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	PlayGoTutorialSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self._profile_synchronizer = arg_1_1.profile_synchronizer
	self._tutorial_started = false
	self._tutorial_unit = nil
	self._last_slot_name = nil
	self._last_known_attack = nil
	self._spawned_ai_units = {}
	self._animation_hooks = {}
	self._active = false
	self._bot_loot_enabled = true
	self._bot_portraits_enabled = {}
end

PlayGoTutorialSystem.destroy = function (self)
	-- function 2
	if not self._unit_animation_event then
		Unit.animation_event = self._unit_animation_event
		self._unit_animation_event = nil
	end

	if not self._current_pause_event then
		self._current_pause_event.on_exit(self._current_pause_event)

		self._current_pause_event = nil
	end

	if not self._current_animation_hook and not self._current_animation_hook.activated then
		self._current_animation_hook.on_exit(self._current_animation_hook)

		self._current_animation_hook = nil
	end
end

PlayGoTutorialSystem.active = function (self)
	-- function 3
	return self._active
end

local tbl_2 = {}

PlayGoTutorialSystem.on_add_extension = function (self, arg_4_1, arg_4_2, arg_4_3, ...)
	-- function 4
	fassert(self._tutorial_unit == nil, "Multiple tutorial units spawned on level!")

	local tbl = {}

	self._tutorial_started = true
	self._tutorial_unit = arg_4_2
	self._world = arg_4_1
	self._num_bots_active = 1
	script_data.ai_bots_disabled = true
	script_data.info_slates_disabled = true

	local var_4_1 = local_require("scripts/ui/views/tutorial_tooltip_ui_definitions")

	self._active = true
	self._saved_position = var_4_1.scenegraph.tutorial_tooltip.position
	self._saved_definition = var_4_1.scenegraph.tutorial_tooltip
	self._saved_definition.position = {
		0,
		-440,
		1
	}
	self.player_ammo_refill = false
	self._profile_packages = {}

	local NAME = self.NAME

	ScriptUnit.set_extension(arg_4_2, NAME, tbl, tbl_2)

	return tbl
end

PlayGoTutorialSystem.trigger_pause_event = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._current_pause_event = nil

	fassert(not self._current_animation_hook, "[PlayGoTutorialSystem:trigger_pause_event] Trying to trigger pause event %q while an animation hook is active", arg_5_1.name)

	local fassert = fassert
	local flag = not self._current_pause_event
	local str = "[PlayGoTutorialSystem:trigger_pause_event] Trying to trigger pause event %q while another pause event %q is active"
	local name = arg_5_1.name
	local _current_pause_event = self._current_pause_event

	_current_pause_event = not _current_pause_event and self._current_pause_event.name

	fassert(flag, str, name, _current_pause_event)

	self._current_pause_event = arg_5_1

	local num = Managers.time:time("game") + arg_5_1.animation_delay

	num = num or 0
	arg_5_1.timer = num
	arg_5_1.world = self._world

	self._current_pause_event.on_enter(arg_5_1, nil, arg_5_2)
end

PlayGoTutorialSystem.add_animation_hook = function (self, arg_6_1)
	-- function 6
	self._animation_hooks[#self._animation_hooks + 1] = arg_6_1

	self:_add_next_animation_hook()
end

PlayGoTutorialSystem._add_next_animation_hook = function (self)
	-- function 7
	local _unit_animation_event = self._unit_animation_event

	_unit_animation_event = _unit_animation_event or Unit.animation_event
	self._unit_animation_event = _unit_animation_event

	local var_7_1 = self._animation_hooks[1]

	if not var_7_1 then
		self._current_animation_hook = var_7_1

		Unit.animation_event = function (arg_8_0, arg_8_1)
			-- function 8
			local get_data = Unit.get_data(arg_8_0, "breed")

			if not get_data and (get_data.name ~= var_7_1.breed or var_7_1.activated or not table.find(var_7_1.animations, arg_8_1)) and not var_7_1.check_prerequisites() then
				local var_8_1 = var_7_1
				local num = Managers.time:time("game") + var_7_1.animation_delay

				num = num or 0
				var_8_1.timer = num
				var_7_1.world = self._world

				var_7_1.on_enter(var_7_1, arg_8_0)
			end

			return self._unit_animation_event(arg_8_0, arg_8_1)
		end
	else
		Unit.animation_event = self._unit_animation_event
		self._unit_animation_event = nil

		print("Resetting Unit.animation_event")
	end
end

PlayGoTutorialSystem.on_remove_extension = function (self, arg_9_1, arg_9_2)
	-- function 9
	ScriptUnit.remove_extension(arg_9_1, self.NAME)
	self:_unload_profile_packages()

	script_data.ai_bots_disabled = nil
	script_data.info_slates_disabled = nil
	self._saved_definition.position = self._saved_position
	self._active = false
	self._tutorial_started = false
	self._tutorial_unit = nil
end

PlayGoTutorialSystem.set_bot_ready_for_assisted_respawn = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	ScriptUnit.extension(arg_10_1, "status_system"):set_ready_for_assisted_respawn(true, arg_10_2)
end

PlayGoTutorialSystem.remove_player_ammo = function (arg_11_0)
	-- function 11
	local local_player = Managers.player:local_player()
	local extension = ScriptUnit.extension(local_player.player_unit, "inventory_system")
	local current_ammo_status, var_11_3 = extension:current_ammo_status("slot_ranged")

	if not (not current_ammo_status and not (current_ammo_status > 0)) then
		local get_slot_data = extension:get_slot_data("slot_ranged")
		local left_unit_1p = get_slot_data.left_unit_1p
		local right_unit_1p = get_slot_data.right_unit_1p
		local extension_2

		if not ScriptUnit.has_extension(left_unit_1p, "ammo_system") then
			extension_2 = ScriptUnit.extension(left_unit_1p, "ammo_system")

			if not extension_2 then
				-- Nothing
			end
		end

		extension_2 = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
		extension_2 = not extension_2 and ScriptUnit.extension(right_unit_1p, "ammo_system")

		::label_11_0::

		if not extension_2 then
			extension_2:use_ammo(1)
			extension_2:add_ammo_to_reserve(-(current_ammo_status - 1))
		end
	end
end

PlayGoTutorialSystem.check_player_ammo = function (arg_12_0)
	-- function 12
	local local_player = Managers.player:local_player()
	local current_ammo_status, var_12_2 = ScriptUnit.extension(local_player.player_unit, "inventory_system"):current_ammo_status("slot_ranged")

	if current_ammo_status > 0 then
		return true
	end

	return false
end

PlayGoTutorialSystem.enable_player_ammo_refill = function (self)
	-- function 13
	self.player_ammo_refill = true
end

PlayGoTutorialSystem.give_player_potion_from_bot = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local extension = ScriptUnit.extension(arg_14_1, "inventory_system")
	local str = "potion_speed_boost_01"
	local var_14_2 = ItemMasterList[str]

	extension:add_equipment("slot_potion", var_14_2)

	local unit_owner = Managers.player:unit_owner(arg_14_2)

	if not unit_owner then
		Managers.state.event:trigger("give_item_feedback", unit_owner:stats_id() .. str, unit_owner, str)
	end
end

PlayGoTutorialSystem.update = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self._tutorial_started then
		return
	end

	local local_player = Managers.player:local_player()

	if not Unit.alive(local_player.player_unit) then
		return
	end

	self:_update_animation_hooks(local_player, arg_15_2)
	self:_update_pause_events(arg_15_2)
	self:_update_player_health(local_player)
	self:_update_player_ammo(local_player)
	self:_update_ai_units()
	self:_capture_wield_switch(local_player)
	self:_capture_attacks(local_player)
end

PlayGoTutorialSystem._update_animation_hooks = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not self._current_animation_hook and not self._current_animation_hook.activated and not self._current_animation_hook.update(self._current_animation_hook, arg_16_2) then
		self._current_animation_hook.on_exit(self._current_animation_hook)
		table.remove(self._animation_hooks, 1)

		self._current_animation_hook = nil

		self:_add_next_animation_hook()
	end
end

PlayGoTutorialSystem._update_pause_events = function (self, arg_17_1)
	-- function 17
	if not self._current_pause_event and not self._current_pause_event.update(self._current_pause_event, arg_17_1) then
		self._current_pause_event.on_exit(self._current_pause_event)

		self._current_pause_event = nil
	end
end

PlayGoTutorialSystem._update_player_health = function (arg_18_0, arg_18_1)
	-- function 18
	local player_unit = arg_18_1.player_unit
	local extension = ScriptUnit.extension(player_unit, "health_system")

	if extension:current_health_percent() < 0.2 then
		extension:reset()
	end
end

PlayGoTutorialSystem._capture_wield_switch = function (self, arg_19_1)
	-- function 19
	local player_unit = arg_19_1.player_unit
	local extension = ScriptUnit.extension(player_unit, "inventory_system")

	if extension:get_wielded_slot_name() ~= self._last_slot_name then
		self._last_slot_name = extension:get_wielded_slot_name()

		Unit.flow_event(self._tutorial_unit, "lua_wield_switch")
	end
end

PlayGoTutorialSystem._capture_attacks = function (self, arg_20_1)
	-- function 20
	local player_unit = arg_20_1.player_unit
	local equipment = ScriptUnit.extension(player_unit, "inventory_system"):equipment()
	local right_hand_wielded_unit = equipment.right_hand_wielded_unit

	right_hand_wielded_unit = right_hand_wielded_unit or equipment.left_hand_wielded_unit

	if not ALIVE[right_hand_wielded_unit] then
		local extension = ScriptUnit.extension(right_hand_wielded_unit, "weapon_system")

		if not extension:has_current_action() then
			local get_current_action_settings = extension:get_current_action_settings()

			if get_current_action_settings.charge_value ~= nil then
				self._last_known_attack = get_current_action_settings.charge_value
			end
		end
	end
end

PlayGoTutorialSystem._update_player_ammo = function (self, arg_21_1)
	-- function 21
	if not self.player_ammo_refill then
		return
	end

	local extension = ScriptUnit.extension(arg_21_1.player_unit, "inventory_system")
	local current_ammo_status, var_21_2 = extension:current_ammo_status("slot_ranged")

	if current_ammo_status == 0 then
		local left_unit_1p = extension:get_slot_data("slot_ranged").left_unit_1p
		local has_extension = ScriptUnit.has_extension(left_unit_1p, "ammo_system")

		has_extension = not has_extension and ScriptUnit.extension(left_unit_1p, "ammo_system")

		if not has_extension then
			has_extension:add_ammo(var_21_2)

			if extension:get_wielded_slot_name() ~= "slot_ranged" or not has_extension:can_reload() then
				has_extension:start_reload(true)
			end
		end
	end
end

PlayGoTutorialSystem._update_ai_units = function (self)
	-- function 22
	for k, v in pairs(self._spawned_ai_units) do
		if not HEALTH_ALIVE[v.ai_unit] then
			if not v.outline_id then
				ScriptUnit.extension(v.ai_unit, "outline_system"):remove_outline(v.outline_id)
			end

			Unit.flow_event(v.spawner_unit, "lua_ai_death")

			self._spawned_ai_units[k] = nil

			break
		end
	end
end

PlayGoTutorialSystem.clear_hooks = function (self)
	-- function 23
	if not self._unit_animation_event then
		Unit.animation_event = self._unit_animation_event
		self._unit_animation_event = nil
	end

	if not self._current_pause_event then
		self._current_pause_event.on_exit(self._current_pause_event)

		self._current_pause_event = nil
	end

	if not self._current_animation_hook and not self._current_animation_hook.activated then
		self._current_animation_hook.on_exit(self._current_animation_hook)

		self._current_animation_hook = nil
	end
end

PlayGoTutorialSystem._load_profile_packages = function (self)
	-- function 24
	local tbl = {
		3,
		4
	}
	local num = 1
	local tbl_2 = {
		["4"] = true,
		["3"] = false
	}
	local slots = InventorySettings.slots
	local count = #InventorySettings.slots
	local _profile_packages = self._profile_packages

	for i, v in ipairs(tbl) do
		local var_24_6 = SPProfiles[v]
		local name = var_24_6.careers[num].name

		for k = 1, count do
			repeat
				local var_24_8 = slots[k]
				local NAME = var_24_8.NAME
				local category = var_24_8.category
				local get_loadout_item = BackendUtils.get_loadout_item(name, NAME)

				if not get_loadout_item then
					break
				end

				local backend_id = get_loadout_item.backend_id
				local data = get_loadout_item.data
				local get_item_template = BackendUtils.get_item_template(data, backend_id)
				local get_item_units = BackendUtils.get_item_units(data, backend_id, nil, name)

				if category == "weapon" then
					local left_hand_unit = get_item_units.left_hand_unit

					if not left_hand_unit then
						if not tbl_2[v] then
							_profile_packages[left_hand_unit] = true
						end

						_profile_packages[left_hand_unit .. "_3p"] = true
					end

					local right_hand_unit = get_item_units.right_hand_unit

					if not right_hand_unit then
						if not tbl_2[v] then
							_profile_packages[right_hand_unit] = true
						end

						_profile_packages[right_hand_unit .. "_3p"] = true
					end

					local ammo_unit = get_item_units.ammo_unit

					if not ammo_unit then
						if not tbl_2[v] then
							_profile_packages[ammo_unit] = true
						end

						local ammo_unit_3p = get_item_units.ammo_unit_3p

						ammo_unit_3p = ammo_unit_3p or ammo_unit .. "_3p"
						_profile_packages[ammo_unit_3p] = true
					end

					local actions = get_item_template.actions

					for k_2, v_2 in pairs(actions) do
						for k_3, v_3 in pairs(v_2) do
							local projectile_info = v_3.projectile_info

							if not projectile_info then
								local projectile_units_template = projectile_info.projectile_units_template
								local var_24_23 = ProjectileUnits[projectile_units_template]

								if not var_24_23.projectile_unit_name then
									_profile_packages[var_24_23.projectile_unit_name] = true
								end

								if not var_24_23.dummy_linker_unit_name then
									_profile_packages[var_24_23.dummy_linker_unit_name] = true
								end

								if not var_24_23.dummy_linker_broken_units then
									for k_4, v_4 in pairs(var_24_23.dummy_linker_broken_units) do
										_profile_packages[v_4] = true
									end
								end
							end
						end
					end

					break
				end

				if category == "attachment" then
					_profile_packages[get_item_units.unit] = true

					break
				end

				error("InventoryPackageSynchronizerClient unknown slot_category: " .. category)
			until true
		end

		local base_units = var_24_6.base_units

		if not tbl_2[v] then
			_profile_packages[base_units.first_person] = true
			_profile_packages[base_units.first_person_bot] = true
			_profile_packages[base_units.third_person] = true
			_profile_packages[base_units.third_person_bot] = true
		else
			_profile_packages[base_units.third_person_husk] = true
		end

		local first_person_attachment = var_24_6.first_person_attachment

		if not tbl_2[v] then
			_profile_packages[first_person_attachment.unit] = true
		end

		_profile_packages[var_24_6.third_person_attachment.unit] = true
	end

	for k_5, v_5 in pairs(_profile_packages) do
		Managers.package:load(k_5, "play_go_tutorial_system", nil, true)
	end

	print("[PlayGoTutorialSystem]:_load_profile_packages()")
end

PlayGoTutorialSystem._unload_profile_packages = function (self)
	-- function 25
	local _profile_packages = self._profile_packages

	for k, v in pairs(_profile_packages) do
		Managers.package:unload(k, "play_go_tutorial_system")

		_profile_packages[k] = nil
	end

	print("[PlayGoTutorialSystem]:_unload_profile_packages()")
end

PlayGoTutorialSystem.register_dodge = function (self, arg_26_1)
	-- function 26
	if not self._tutorial_started then
		local _tutorial_unit = self._tutorial_unit
		local x = Vector3.x(arg_26_1)
		local y = Vector3.y(arg_26_1)

		if math.abs(y) > math.abs(x) then
			Unit.flow_event(_tutorial_unit, "lua_dodge_backward")
		elseif x > 0 then
			Unit.flow_event(_tutorial_unit, "lua_dodge_right")
		else
			Unit.flow_event(_tutorial_unit, "lua_dodge_left")
		end
	end
end

PlayGoTutorialSystem.register_push = function (self, arg_27_1)
	-- function 27
	if not self._tutorial_started and not HEALTH_ALIVE[arg_27_1] then
		Unit.flow_event(self._tutorial_unit, "lua_pushed_enemy")
	end
end

PlayGoTutorialSystem.register_block = function (self)
	-- function 28
	if not self._tutorial_started then
		Unit.flow_event(self._tutorial_unit, "lua_blocked_attack")
	end
end

PlayGoTutorialSystem.register_killing_blow = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not (not self._tutorial_started and arg_29_2 ~= Managers.player:local_player().player_unit) then
		local _tutorial_unit = self._tutorial_unit
		local _last_known_attack = self._last_known_attack

		if not (arg_29_1 == "grenade" or arg_29_1 ~= "grenade_glance") then
			Unit.flow_event(_tutorial_unit, "lua_grenade_attack")
		elseif _last_known_attack == "light_attack" then
			Unit.flow_event(_tutorial_unit, "lua_light_attack")
		elseif _last_known_attack == "heavy_attack" then
			Unit.flow_event(_tutorial_unit, "lua_heavy_attack")
		elseif _last_known_attack == "arrow_hit" then
			Unit.flow_event(_tutorial_unit, "lua_normal_ranged_attack")
		elseif _last_known_attack == "zoomed_arrow_hit" then
			Unit.flow_event(_tutorial_unit, "lua_alternative_ranged_attack")
		end
	end
end

PlayGoTutorialSystem.register_unit = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	if not self._tutorial_started then
		return
	end

	local tbl = {}

	if not Unit.get_data(arg_30_1, "Tutorial", "aggro_on_spawn") then
		local local_player = Managers.player:local_player()

		ScriptUnit.extension(arg_30_2, "ai_system"):enemy_aggro(arg_30_2, local_player.player_unit)
	end

	Unit.set_flow_variable(arg_30_1, "lua_ai_spawned_unit_handle", arg_30_3)
	Unit.flow_event(arg_30_1, "lua_ai_spawned")

	if not Unit.get_data(arg_30_1, "Tutorial", "highlight_on_spawn") then
		tbl.outline_id = ScriptUnit.extension(arg_30_2, "outline_system"):add_outline(OutlineSettings.templates.tutorial_highlight)
	end

	tbl.spawner_unit = arg_30_1
	tbl.ai_unit = arg_30_2

	table.insert(self._spawned_ai_units, tbl)
end

PlayGoTutorialSystem.teleport_unit = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	ScriptUnit.extension(arg_31_1, "locomotion_system"):teleport_to(arg_31_2, arg_31_3)

	if not Unit.get_data(arg_31_1, "bot") then
		ScriptUnit.extension(arg_31_1, "ai_navigation_system"):teleport(arg_31_2)
	end
end

PlayGoTutorialSystem.enable_bot_loot = function (self, arg_32_1)
	-- function 32
	self._bot_loot_enabled = arg_32_1
end

PlayGoTutorialSystem.bot_loot_enabled = function (self)
	-- function 33
	return self._bot_loot_enabled
end

PlayGoTutorialSystem.set_bot_portrait_enabled = function (arg_34_0, arg_34_1)
	-- function 34
	arg_34_0._bot_portraits_enabled[arg_34_1] = true
end

PlayGoTutorialSystem.bot_portrait_enabled = function (self, arg_35_1)
	-- function 35
	local player_name = arg_35_1.player_name

	return self._bot_portraits_enabled[player_name]
end
