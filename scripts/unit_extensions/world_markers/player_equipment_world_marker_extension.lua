-- chunkname: @scripts/unit_extensions/world_markers/player_equipment_world_marker_extension.lua

require("scripts/unit_extensions/world_markers/world_marker_extension")

PlayerEquipmentWorldMarkerExtension = class(PlayerEquipmentWorldMarkerExtension, WorldMarkerExtension)

PlayerEquipmentWorldMarkerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	PlayerEquipmentWorldMarkerExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._marker_type = "versus_hero_status"
	self._add_event_name = "add_world_marker_unit"
	self._remove_event_name = "remove_world_marker"
	self._status_extension = nil
	self._side = nil
	self._is_enemy = false
	self._local_player_side = nil
	self._local_player_is_dark_pact = false
	self._initialized = false
end

PlayerEquipmentWorldMarkerExtension._extensions_ready = function (self)
	-- function 2
	if not DEDICATED_SERVER then
		return
	end

	if not Managers.level_transition_handler:in_hub_level() then
		return
	end

	local _unit = self._unit

	self._status_extension = ScriptUnit.extension(_unit, "status_system")

	local unique_id = Managers.player:local_player():unique_id()
	local side = Managers.state.side
	local var_2_3 = side.side_by_unit[_unit]
	local get_side_from_player_unique_id = side:get_side_from_player_unique_id(unique_id)

	self._side = var_2_3
	self._is_enemy = side:is_enemy_by_side(var_2_3, get_side_from_player_unique_id)
	self._local_player_is_dark_pact = get_side_from_player_unique_id:name() == "dark_pact"
	self._initialized = true
end

PlayerEquipmentWorldMarkerExtension._add_marker = function (self, arg_3_1)
	-- function 3
	local _unit = self._unit
	local _add_event_name = self._add_event_name
	local _event_manager = self._event_manager
	local _marker_type = self._marker_type

	_event_manager:trigger(_add_event_name, _marker_type, _unit, arg_3_1)
end

PlayerEquipmentWorldMarkerExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not self._initialized then
		return
	end

	local side = Managers.state.side
	local unique_id = Managers.player:local_player():unique_id()
	local get_side_from_player_unique_id = side:get_side_from_player_unique_id(unique_id)

	self._local_player_is_dark_pact = get_side_from_player_unique_id:name() == "dark_pact"
	self._is_enemy = side:is_enemy_by_side(self._side, get_side_from_player_unique_id)

	if not (not self._local_player_is_dark_pact and self._is_enemy) then
		return
	end

	local _status_extension = self._status_extension
	local is_dead = _status_extension:is_dead()
	local is_invisible = _status_extension:is_invisible()

	if not self._id and is_dead and not is_invisible then
		self:remove_marker()
	elseif not (self._id or is_dead or is_invisible) then
		self:add_marker()
	end
end
