-- chunkname: @scripts/unit_extensions/default_player_unit/cosmetic/player_unit_cosmetic_extension.lua

require("scripts/helpers/cosmetic_utils")

PlayerUnitCosmeticExtension = class(PlayerUnitCosmeticExtension)

PlayerUnitCosmeticExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._unit = arg_1_2
	self._profile = arg_1_3.profile
	self._is_server = arg_1_3.is_server
	self._player = arg_1_3.player
	self._cosmetics = {}
	self._skin_material_changes = {}
	self._tp_mesh_visible = true
	self._player_afk_data = {
		tickrate = 1,
		triggered = false,
		last_tick = 0,
		trigger_event_dt = 120,
		last_player_move_t = 0,
		last_player_pos = Vector3Box()
	}

	local skin_name = arg_1_3.skin_name
	local frame_name = arg_1_3.frame_name
	local profile = arg_1_3.profile

	fassert(skin_name, "No skin name passed to CosmeticExtension, somthing went wrong!")

	local var_1_3 = Cosmetics[skin_name]

	self._cosmetics.skin = var_1_3

	CosmeticUtils.update_cosmetic_slot(self._player, "slot_skin", skin_name)

	local pose_name = arg_1_3.pose_name

	if not pose_name then
		local var_1_5 = ItemMasterList[pose_name]

		self._cosmetics.weapon_pose = var_1_5

		CosmeticUtils.update_cosmetic_slot(self._player, "slot_pose", pose_name)
	end

	if not frame_name then
		self:set_equipped_frame(frame_name)
	end

	local career_index

	if not self._player then
		career_index = self._player:career_index()

		if not career_index then
			-- Nothing
		end
	end

	career_index = 1

	::label_1_0::

	local var_1_7 = profile.careers[career_index]

	self:_init_mesh_attachment(self._world, arg_1_2, skin_name, profile, var_1_7)
end

PlayerUnitCosmeticExtension.destroy = function (self)
	-- function 2
	if not self._tp_unit_mesh then
		AttachmentUtils.unlink(self._world, self._tp_unit_mesh)
		Managers.state.unit_spawner:mark_for_deletion(self._tp_unit_mesh)

		self._tp_unit_mesh = nil
	end
end

PlayerUnitCosmeticExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	self._attachment_extension = ScriptUnit.extension(arg_3_2, "attachment_system")

	local display_name = self._profile.display_name
	local skin = self._cosmetics.skin
	local material_changes = skin.material_changes

	if not material_changes then
		self:change_skin_materials(material_changes)
	end

	local material_settings_name = skin.material_settings_name

	if not material_settings_name then
		self:change_skin_material_settings(material_settings_name)
	end

	local color_tint = skin.color_tint

	if not color_tint then
		local gradient_variation = color_tint.gradient_variation
		local gradient_value = color_tint.gradient_value

		CosmeticUtils.color_tint_unit(arg_3_2, display_name, gradient_variation, gradient_value)
	end
end

PlayerUnitCosmeticExtension.get_equipped_skin = function (self)
	-- function 4
	return self._cosmetics.skin
end

PlayerUnitCosmeticExtension.get_equipped_frame = function (self)
	-- function 5
	return self._cosmetics.frame
end

PlayerUnitCosmeticExtension.set_equipped_frame = function (self, arg_6_1)
	-- function 6
	self._cosmetics.frame = Cosmetics[arg_6_1]
	self._frame_name = arg_6_1

	CosmeticUtils.update_cosmetic_slot(self._player, "slot_frame", arg_6_1)
end

PlayerUnitCosmeticExtension.get_equipped_frame_name = function (self)
	-- function 7
	return self._frame_name
end

PlayerUnitCosmeticExtension.change_skin_materials = function (self, arg_8_1)
	-- function 8
	local _unit = self._unit
	local _tp_unit_mesh = self._tp_unit_mesh
	local third_person = arg_8_1.third_person

	for k, v in pairs(third_person) do
		Unit.set_material(_tp_unit_mesh, k, v)
	end

	local has_extension = ScriptUnit.has_extension(_unit, "first_person_system")

	if not has_extension then
		local first_person = arg_8_1.first_person

		if not first_person then
			local get_first_person_mesh_unit = has_extension:get_first_person_mesh_unit()

			for k_2, v_2 in pairs(first_person) do
				Unit.set_material(get_first_person_mesh_unit, k_2, v_2)
			end
		end
	end
end

PlayerUnitCosmeticExtension.change_skin_material_settings = function (self, arg_9_1)
	-- function 9
	local _unit = self._unit
	local _tp_unit_mesh = self._tp_unit_mesh

	CosmeticUtils.apply_material_settings(_tp_unit_mesh, arg_9_1)

	local has_extension = ScriptUnit.has_extension(_unit, "first_person_system")

	if not has_extension then
		local get_first_person_mesh_unit = has_extension:get_first_person_mesh_unit()

		CosmeticUtils.apply_material_settings(get_first_person_mesh_unit, arg_9_1)
	end
end

PlayerUnitCosmeticExtension.always_hide_attachment_slot = function (self, arg_10_1)
	-- function 10
	local skin = self._cosmetics.skin

	if not skin then
		return false
	end

	local always_hide_attachment_slots = skin.always_hide_attachment_slots

	if not always_hide_attachment_slots then
		return false
	end

	if not table.contains(always_hide_attachment_slots, arg_10_1) then
		return false
	end

	return true
end

PlayerUnitCosmeticExtension.trigger_equip_events = function (self, arg_11_1, arg_11_2)
	-- function 11
	if arg_11_1 == "slot_hat" then
		local equip_hat_event = self._cosmetics.skin.equip_hat_event

		equip_hat_event = equip_hat_event or "using_skin_default"

		if not equip_hat_event then
			Unit.flow_event(arg_11_2, equip_hat_event)
		end
	end
end

PlayerUnitCosmeticExtension.hot_join_sync = function (arg_12_0, arg_12_1)
	-- function 12
	return
end

PlayerUnitCosmeticExtension._init_mesh_attachment = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	local third_person_attachment = Cosmetics[arg_13_3].third_person_attachment

	third_person_attachment = third_person_attachment or arg_13_4.third_person_attachment

	local unit = third_person_attachment.unit
	local attachment_node_linking = third_person_attachment.attachment_node_linking
	local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(unit)

	self._tp_unit_mesh = spawn_local_unit

	Unit.set_flow_variable(arg_13_2, "lua_third_person_mesh_unit", spawn_local_unit)
	AttachmentUtils.link(arg_13_1, arg_13_2, spawn_local_unit, attachment_node_linking)
	Unit.set_flow_variable(arg_13_2, "character_vo", arg_13_4.character_vo)
	Unit.set_flow_variable(arg_13_2, "sound_character", arg_13_5.sound_character)
	Unit.flow_event(arg_13_2, "character_vo_set")

	local climate_type = LevelHelper:current_level_settings().climate_type

	climate_type = climate_type or "default"

	Unit.set_flow_variable(spawn_local_unit, "climate_type", climate_type)
	Unit.flow_event(spawn_local_unit, "climate_type_set")

	local equip_skin_event = Cosmetics[arg_13_3].equip_skin_event

	equip_skin_event = equip_skin_event or "using_skin_default"

	Unit.flow_event(arg_13_2, equip_skin_event)

	if not self._tp_mesh_visible then
		self._tp_mesh_visible = true

		Unit.set_unit_visibility(self._tp_unit_mesh, false)
	end

	if not Unit.has_animation_state_machine(self._tp_unit_mesh) and not Unit.has_animation_event(self._tp_unit_mesh, "enable") then
		Unit.animation_event(self._tp_unit_mesh, "enable")
	end
end

PlayerUnitCosmeticExtension.update = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	self._queue_3p_event_name = nil

	if not ALIVE[arg_14_1] then
		self:_update_player_standing_still_events(arg_14_5)
	end
end

PlayerUnitCosmeticExtension.get_third_person_mesh_unit = function (self)
	-- function 15
	return self._tp_unit_mesh
end

PlayerUnitCosmeticExtension.show_third_person_mesh = function (self, arg_16_1)
	-- function 16
	if self._tp_mesh_visible ~= arg_16_1 then
		self._tp_mesh_visible = arg_16_1

		if not self._tp_unit_mesh then
			Unit.set_unit_visibility(self._tp_unit_mesh, arg_16_1)

			if not arg_16_1 then
				Unit.flow_event(self._unit, "lua_enter_third_person_camera")
				Unit.flow_event(self._tp_unit_mesh, "lua_enter_third_person_camera")
			else
				Unit.flow_event(self._unit, "lua_exit_third_person_camera")
				Unit.flow_event(self._tp_unit_mesh, "lua_exit_third_person_camera")
			end
		end
	end
end

PlayerUnitCosmeticExtension.queue_3p_emote = function (self, arg_17_1, arg_17_2)
	-- function 17
	self._queue_3p_event_name = arg_17_1
	self._queue_3p_hide_weapons = arg_17_2
end

PlayerUnitCosmeticExtension.get_queued_3p_emote = function (self)
	-- function 18
	return self._queue_3p_event_name, self._queue_3p_hide_weapons
end

PlayerUnitCosmeticExtension.consume_queued_3p_emote = function (self)
	-- function 19
	self._queue_3p_event_name = nil
end

PlayerUnitCosmeticExtension.trigger_ability_activated_events = function (self)
	-- function 20
	local get_slot_data = self._attachment_extension:get_slot_data("slot_hat")

	if not get_slot_data then
		Unit.flow_event(get_slot_data.unit, "ability_activated")
	end
end

PlayerUnitCosmeticExtension._update_player_standing_still_events = function (self, arg_21_1)
	-- function 21
	local _unit = self._unit
	local _player_afk_data = self._player_afk_data

	if arg_21_1 > _player_afk_data.last_tick + _player_afk_data.tickrate then
		local unbox = _player_afk_data.last_player_pos:unbox()
		local local_position = Unit.local_position(_unit, 0)

		if Vector3.distance_squared(unbox, local_position) > 0.1 then
			_player_afk_data.last_player_move_t = arg_21_1

			_player_afk_data.last_player_pos:store(local_position)

			if not _player_afk_data.triggered then
				local get_slot_data = self._attachment_extension:get_slot_data("slot_hat")

				if not get_slot_data then
					Unit.flow_event(get_slot_data.unit, "player_break_prolonged_standing_still")
				end
			end

			_player_afk_data.triggered = false
		elseif not (_player_afk_data.triggered or not (arg_21_1 > _player_afk_data.last_player_move_t + _player_afk_data.trigger_event_dt) or self._status_extension:is_disabled()) then
			local get_slot_data_2 = self._attachment_extension:get_slot_data("slot_hat")

			if not get_slot_data_2 then
				Unit.flow_event(get_slot_data_2.unit, "player_prolonged_standing_still")
			end

			_player_afk_data.triggered = true
		end

		_player_afk_data.last_tick = arg_21_1
	end
end
