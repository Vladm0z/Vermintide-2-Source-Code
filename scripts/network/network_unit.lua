-- chunkname: @scripts/network/network_unit.lua

NetworkUnit = NetworkUnit
NetworkUnitData = NetworkUnitData

local unit_network_data = NetworkUnitData

NetworkUnit.reset_unit_data = function ()
	-- function 1
	NetworkUnitData = {}
	unit_network_data = NetworkUnitData
end

NetworkUnit.add_unit = function (unit)
	-- function 2
	assert(unit_network_data[unit] == nil)

	unit_network_data[unit] = {}
end

NetworkUnit.remove_unit = function (unit)
	-- function 3
	assert(unit_network_data[unit] ~= nil)

	unit_network_data[unit] = nil
end

NetworkUnit.reset_unit = function (unit)
	-- function 4
	assert(unit_network_data[unit] ~= nil)

	local unit_data = unit_network_data[unit]

	unit_data.go_type = nil
	unit_data.go_id = nil
	unit_data.owner = nil
	unit_data.is_husk = nil
end

NetworkUnit.set_game_object_type = function (unit, go_type)
	-- function 5
	unit_network_data[unit].go_type = go_type
end

NetworkUnit.game_object_type = function (unit)
	-- function 6
	return unit_network_data[unit].go_type
end

NetworkUnit.game_object_type_level = function (unit)
	-- function 7
	return unit_network_data[unit].go_type .. "_level"
end

NetworkUnit.set_game_object_id = function (unit, go_id)
	-- function 8
	unit_network_data[unit].go_id = go_id
end

NetworkUnit.game_object_id = function (unit)
	-- function 9
	return unit_network_data[unit].go_id
end

NetworkUnit.set_owner_peer_id = function (unit, peer_id)
	-- function 10
	unit_network_data[unit].owner = peer_id
end

NetworkUnit.owner_peer_id = function (unit)
	-- function 11
	return unit_network_data[unit].peer_id
end

NetworkUnit.set_is_husk_unit = function (unit, is_husk)
	-- function 12
	unit_network_data[unit].is_husk = is_husk
end

NetworkUnit.is_husk_unit = function (unit)
	-- function 13
	return not not unit_network_data[unit].is_husk
end

NetworkUnit.is_network_unit = function (unit)
	-- function 14
	return unit_network_data[unit] ~= nil
end

NetworkUnit.on_extensions_registered = function (unit)
	-- function 15
	Unit.set_flow_variable(unit, "is_husk_unit", NetworkUnit.is_husk_unit(unit))
	Unit.flow_event(unit, "on_extensions_registered")
end

NetworkUnit.on_game_object_sync_done = function (unit)
	-- function 16
	Unit.set_flow_variable(unit, "is_husk_unit", NetworkUnit.is_husk_unit(unit))
	Unit.flow_event(unit, "on_game_object_sync_done")
end

NetworkUnit.transfer_unit = function (unit, unit_new)
	-- function 17
	unit_network_data[unit_new] = unit_network_data[unit]
	unit_network_data[unit] = nil
end
