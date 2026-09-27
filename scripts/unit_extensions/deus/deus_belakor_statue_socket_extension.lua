-- chunkname: @scripts/unit_extensions/deus/deus_belakor_statue_socket_extension.lua

DeusBelakorStatueSocketExtension = class(DeusBelakorStatueSocketExtension)

local function fn(arg_1_0, arg_1_1)
	-- function 1
	if arg_1_1.num_closed_sockets > 0 then
		return false
	else
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not flag then
			return false
		end

		local has_extension = ScriptUnit.has_extension(flag, "inventory_system")

		if not has_extension then
			return false
		end

		local get_wielded_slot_name = has_extension:get_wielded_slot_name()
		local get_slot_data = has_extension:get_slot_data(get_wielded_slot_name)

		if not get_slot_data then
			local item_data = get_slot_data.item_data

			return (not item_data and item_data.name) == "belakor_crystal"
		end
	end

	return false
end

DeusBelakorStatueSocketExtension.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self._world = arg_2_1.world
	self._unit = arg_2_2
end

DeusBelakorStatueSocketExtension.game_object_initialized = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	return
end

DeusBelakorStatueSocketExtension.destroy = function (arg_4_0)
	-- function 4
	return
end

DeusBelakorStatueSocketExtension.extensions_ready = function (self, arg_5_1, arg_5_2)
	-- function 5
	local extension = ScriptUnit.extension(arg_5_2, "tutorial_system")

	extension:set_active(false)

	extension.network_synced = false
	self._objective_extension = extension
	self._socket_extension = ScriptUnit.extension(arg_5_2, "objective_socket_system")
end

DeusBelakorStatueSocketExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local _objective_extension = self._objective_extension

	if not _objective_extension then
		return
	end

	local var_6_1 = fn(_objective_extension, self._socket_extension)

	if _objective_extension.active ~= var_6_1 then
		_objective_extension:set_active(var_6_1)
	end
end
