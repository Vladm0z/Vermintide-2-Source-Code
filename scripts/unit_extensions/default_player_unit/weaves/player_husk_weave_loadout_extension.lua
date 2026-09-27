-- chunkname: @scripts/unit_extensions/default_player_unit/weaves/player_husk_weave_loadout_extension.lua

PlayerHuskWeaveLoadoutExtension = class(PlayerHuskWeaveLoadoutExtension)

PlayerHuskWeaveLoadoutExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._synced_buff_params = nil
end

PlayerHuskWeaveLoadoutExtension.destroy = function (self)
	-- function 2
	self._unit = nil
	self._synced_buff_params = nil
end

PlayerHuskWeaveLoadoutExtension.add_buffs = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self._synced_buff_params = {
		arg_3_1,
		arg_3_2,
		arg_3_3,
		arg_3_4
	}

	local buffs_from_rpc_params = BuffUtils.buffs_from_rpc_params(arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	self:_apply_buffs(buffs_from_rpc_params)
end

PlayerHuskWeaveLoadoutExtension._apply_buffs = function (self, arg_4_1)
	-- function 4
	local extension = ScriptUnit.extension(self._unit, "buff_system")

	for k, v in pairs(arg_4_1) do
		local tbl = {}

		for k_2, v_2 in pairs(v) do
			tbl[k_2] = v_2
		end

		extension:add_buff(k, tbl)
	end
end

PlayerHuskWeaveLoadoutExtension.hot_join_sync = function (self, arg_5_1)
	-- function 5
	if not Managers.state.unit_spawner:is_marked_for_deletion(self._unit) then
		return
	end

	local _synced_buff_params = self._synced_buff_params

	if not _synced_buff_params then
		local go_id = Managers.state.unit_storage:go_id(self._unit)
		local var_5_2 = PEER_ID_TO_CHANNEL[arg_5_1]

		RPC.rpc_add_weave_buffs(var_5_2, go_id, unpack(_synced_buff_params))
	end
end
