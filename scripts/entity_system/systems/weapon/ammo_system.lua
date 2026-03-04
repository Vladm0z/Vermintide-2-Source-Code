-- chunkname: @scripts/entity_system/systems/weapon/ammo_system.lua

AmmoSystem = class(AmmoSystem, ExtensionSystemBase)

local var_0_0 = {
	"ActiveReloadAmmoUserExtension",
	"GenericAmmoUserExtension"
}
local var_0_1 = {
	"rpc_give_ammo_fraction_to_owner"
}

AmmoSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	AmmoSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0._world = arg_1_1.world
	arg_1_0._network_event_delegate = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_1))

	arg_1_0._unit_extensions = {}
	arg_1_0._unit_extensions_by_owener = {}
end

AmmoSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = AmmoSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0._unit_extensions[arg_2_2] = var_2_0

	local var_2_1 = arg_2_0._unit_extensions_by_owener[var_2_0.owner_unit]

	if not var_2_1 then
		arg_2_0._unit_extensions_by_owener[var_2_0.owner_unit] = {
			var_2_0
		}
	else
		var_2_1[#var_2_1 + 1] = var_2_0
	end

	return var_2_0
end

AmmoSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._unit_extensions[arg_3_1]

	arg_3_0._unit_extensions[arg_3_1] = nil

	local var_3_1 = arg_3_0._unit_extensions_by_owener[var_3_0.owner_unit]

	if var_3_1 then
		local var_3_2 = table.index_of(var_3_1, var_3_0)

		if var_3_2 then
			table.swap_delete(var_3_1, var_3_2)
		end
	end

	AmmoSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)
end

AmmoSystem.destroy = function (arg_4_0)
	arg_4_0._network_event_delegate:unregister(arg_4_0)
end

AmmoSystem.give_ammo_fraction_to_owner = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = Managers.player:owner(arg_5_1)

	if var_5_0 then
		if var_5_0 and not var_5_0.remote then
			local var_5_1 = arg_5_0._unit_extensions_by_owener[arg_5_1]

			if not var_5_1 then
				return
			end

			for iter_5_0 = 1, #var_5_1 do
				local var_5_2 = var_5_1[iter_5_0]

				if var_5_2.slot_name == "slot_ranged" then
					local var_5_3 = math.max(math.round(var_5_2:max_ammo() * arg_5_2), 1)

					if arg_5_3 then
						var_5_2:add_ammo_to_reserve(var_5_3)
					else
						var_5_2:add_ammo(var_5_3)
					end
				end
			end
		else
			local var_5_4 = Managers.state.network.network_transmit
			local var_5_5 = var_5_0.peer_id
			local var_5_6 = Managers.state.unit_storage:go_id(arg_5_1)

			if arg_5_0.is_server then
				var_5_4:send_rpc("rpc_give_ammo_fraction_to_owner", var_5_5, var_5_6, arg_5_2, arg_5_3)
			else
				var_5_4:send_rpc_server("rpc_give_ammo_fraction_to_owner", var_5_6, arg_5_2, arg_5_3)
			end
		end
	end
end

AmmoSystem.rpc_give_ammo_fraction_to_owner = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = Managers.state.unit_storage:unit(arg_6_2)

	arg_6_0:give_ammo_fraction_to_owner(var_6_0, arg_6_3, arg_6_4)
end
