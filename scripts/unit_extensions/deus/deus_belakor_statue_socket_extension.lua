-- chunkname: @scripts/unit_extensions/deus/deus_belakor_statue_socket_extension.lua

DeusBelakorStatueSocketExtension = class(DeusBelakorStatueSocketExtension)

local function var_0_0(arg_1_0, arg_1_1)
	if arg_1_1.num_closed_sockets > 0 then
		return false
	else
		local var_1_0 = Managers.player:local_player()
		local var_1_1 = var_1_0 and var_1_0.player_unit

		if not var_1_1 then
			return false
		end

		local var_1_2 = ScriptUnit.has_extension(var_1_1, "inventory_system")

		if not var_1_2 then
			return false
		end

		local var_1_3 = var_1_2:get_wielded_slot_name()
		local var_1_4 = var_1_2:get_slot_data(var_1_3)

		if var_1_4 then
			local var_1_5 = var_1_4.item_data

			return (var_1_5 and var_1_5.name) == "belakor_crystal"
		end
	end

	return false
end

DeusBelakorStatueSocketExtension.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._world = arg_2_1.world
	arg_2_0._unit = arg_2_2
end

DeusBelakorStatueSocketExtension.game_object_initialized = function (arg_3_0, arg_3_1, arg_3_2)
	return
end

DeusBelakorStatueSocketExtension.destroy = function (arg_4_0)
	return
end

DeusBelakorStatueSocketExtension.extensions_ready = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = ScriptUnit.extension(arg_5_2, "tutorial_system")

	var_5_0:set_active(false)

	var_5_0.network_synced = false
	arg_5_0._objective_extension = var_5_0
	arg_5_0._socket_extension = ScriptUnit.extension(arg_5_2, "objective_socket_system")
end

DeusBelakorStatueSocketExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0._objective_extension

	if not var_6_0 then
		return
	end

	local var_6_1 = var_0_0(var_6_0, arg_6_0._socket_extension)

	if var_6_0.active ~= var_6_1 then
		var_6_0:set_active(var_6_1)
	end
end
