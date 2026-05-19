-- chunkname: @scripts/unit_extensions/world_markers/player_equipment_world_marker_extension.lua

require("scripts/unit_extensions/world_markers/world_marker_extension")

PlayerEquipmentWorldMarkerExtension = class(PlayerEquipmentWorldMarkerExtension, WorldMarkerExtension)

function PlayerEquipmentWorldMarkerExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	PlayerEquipmentWorldMarkerExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._marker_type = "versus_hero_status"
	arg_1_0._add_event_name = "add_world_marker_unit"
	arg_1_0._remove_event_name = "remove_world_marker"
	arg_1_0._status_extension = nil
	arg_1_0._side = nil
	arg_1_0._is_enemy = false
	arg_1_0._local_player_side = nil
	arg_1_0._local_player_is_dark_pact = false
	arg_1_0._initialized = false
end

function PlayerEquipmentWorldMarkerExtension._extensions_ready(arg_2_0)
	if DEDICATED_SERVER then
		return
	end

	if Managers.level_transition_handler:in_hub_level() then
		return
	end

	local var_2_0 = arg_2_0._unit

	arg_2_0._status_extension = ScriptUnit.extension(var_2_0, "status_system")

	local var_2_1 = Managers.player:local_player():unique_id()
	local var_2_2 = Managers.state.side
	local var_2_3 = var_2_2.side_by_unit[var_2_0]
	local var_2_4 = var_2_2:get_side_from_player_unique_id(var_2_1)

	arg_2_0._side = var_2_3
	arg_2_0._is_enemy = var_2_2:is_enemy_by_side(var_2_3, var_2_4)
	arg_2_0._local_player_is_dark_pact = var_2_4:name() == "dark_pact"
	arg_2_0._initialized = true
end

function PlayerEquipmentWorldMarkerExtension._add_marker(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._unit
	local var_3_1 = arg_3_0._add_event_name
	local var_3_2 = arg_3_0._event_manager
	local var_3_3 = arg_3_0._marker_type

	var_3_2:trigger(var_3_1, var_3_3, var_3_0, arg_3_1)
end

function PlayerEquipmentWorldMarkerExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if not arg_4_0._initialized then
		return
	end

	local var_4_0 = Managers.state.side
	local var_4_1 = Managers.player:local_player():unique_id()
	local var_4_2 = var_4_0:get_side_from_player_unique_id(var_4_1)

	arg_4_0._local_player_is_dark_pact = var_4_2:name() == "dark_pact"
	arg_4_0._is_enemy = var_4_0:is_enemy_by_side(arg_4_0._side, var_4_2)

	if not arg_4_0._local_player_is_dark_pact or not arg_4_0._is_enemy then
		return
	end

	local var_4_3 = arg_4_0._status_extension
	local var_4_4 = var_4_3:is_dead()
	local var_4_5 = var_4_3:is_invisible()

	if arg_4_0._id and (var_4_4 or var_4_5) then
		arg_4_0:remove_marker()
	elseif not arg_4_0._id and not var_4_4 and not var_4_5 then
		arg_4_0:add_marker()
	end
end
