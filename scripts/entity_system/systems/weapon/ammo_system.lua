-- chunkname: @scripts/entity_system/systems/weapon/ammo_system.lua

AmmoSystem = class(AmmoSystem, ExtensionSystemBase)

local tbl = {
	"ActiveReloadAmmoUserExtension",
	"GenericAmmoUserExtension"
}
local tbl_2 = {
	"rpc_give_ammo_fraction_to_owner"
}

AmmoSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AmmoSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self._world = arg_1_1.world
	self._network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl_2))

	self._unit_extensions = {}
	self._unit_extensions_by_owener = {}
end

AmmoSystem.on_add_extension = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local on_add_extension = AmmoSystem.super.on_add_extension(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self._unit_extensions[arg_2_2] = on_add_extension

	local var_2_1 = self._unit_extensions_by_owener[on_add_extension.owner_unit]

	if not var_2_1 then
		self._unit_extensions_by_owener[on_add_extension.owner_unit] = {
			on_add_extension
		}
	else
		var_2_1[#var_2_1 + 1] = on_add_extension
	end

	return on_add_extension
end

AmmoSystem.on_remove_extension = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = self._unit_extensions[arg_3_1]

	self._unit_extensions[arg_3_1] = nil

	local var_3_1 = self._unit_extensions_by_owener[var_3_0.owner_unit]

	if not var_3_1 then
		local index_of = table.index_of(var_3_1, var_3_0)

		if not index_of then
			table.swap_delete(var_3_1, index_of)
		end
	end

	AmmoSystem.super.on_remove_extension(self, arg_3_1, arg_3_2)
end

AmmoSystem.destroy = function (self)
	-- function 4
	self._network_event_delegate:unregister(self)
end

AmmoSystem.give_ammo_fraction_to_owner = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local owner = Managers.player:owner(arg_5_1)

	if not owner then
		if not (not owner and not owner.remote) then
			local var_5_1 = self._unit_extensions_by_owener[arg_5_1]

			if not var_5_1 then
				return
			end

			for i = 1, #var_5_1 do
				local var_5_2 = var_5_1[i]

				if var_5_2.slot_name == "slot_ranged" then
					local max = math.max(math.round(var_5_2:max_ammo() * arg_5_2), 1)

					if not arg_5_3 then
						var_5_2:add_ammo_to_reserve(max)
					else
						var_5_2:add_ammo(max)
					end
				end
			end
		else
			local network_transmit = Managers.state.network.network_transmit
			local peer_id = owner.peer_id
			local go_id = Managers.state.unit_storage:go_id(arg_5_1)

			if not self.is_server then
				network_transmit:send_rpc("rpc_give_ammo_fraction_to_owner", peer_id, go_id, arg_5_2, arg_5_3)
			else
				network_transmit:send_rpc_server("rpc_give_ammo_fraction_to_owner", go_id, arg_5_2, arg_5_3)
			end
		end
	end
end

AmmoSystem.rpc_give_ammo_fraction_to_owner = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local unit = Managers.state.unit_storage:unit(arg_6_2)

	self:give_ammo_fraction_to_owner(unit, arg_6_3, arg_6_4)
end
