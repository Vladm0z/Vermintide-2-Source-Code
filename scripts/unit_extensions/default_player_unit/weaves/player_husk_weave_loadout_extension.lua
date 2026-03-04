-- chunkname: @scripts/unit_extensions/default_player_unit/weaves/player_husk_weave_loadout_extension.lua

PlayerHuskWeaveLoadoutExtension = class(PlayerHuskWeaveLoadoutExtension)

PlayerHuskWeaveLoadoutExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._synced_buff_params = nil
end

PlayerHuskWeaveLoadoutExtension.destroy = function (arg_2_0)
	arg_2_0._unit = nil
	arg_2_0._synced_buff_params = nil
end

PlayerHuskWeaveLoadoutExtension.add_buffs = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0._synced_buff_params = {
		arg_3_1,
		arg_3_2,
		arg_3_3,
		arg_3_4
	}

	local var_3_0 = BuffUtils.buffs_from_rpc_params(arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_0:_apply_buffs(var_3_0)
end

PlayerHuskWeaveLoadoutExtension._apply_buffs = function (arg_4_0, arg_4_1)
	local var_4_0 = ScriptUnit.extension(arg_4_0._unit, "buff_system")

	for iter_4_0, iter_4_1 in pairs(arg_4_1) do
		local var_4_1 = {}

		for iter_4_2, iter_4_3 in pairs(iter_4_1) do
			var_4_1[iter_4_2] = iter_4_3
		end

		var_4_0:add_buff(iter_4_0, var_4_1)
	end
end

PlayerHuskWeaveLoadoutExtension.hot_join_sync = function (arg_5_0, arg_5_1)
	if Managers.state.unit_spawner:is_marked_for_deletion(arg_5_0._unit) then
		return
	end

	local var_5_0 = arg_5_0._synced_buff_params

	if var_5_0 then
		local var_5_1 = Managers.state.unit_storage:go_id(arg_5_0._unit)
		local var_5_2 = PEER_ID_TO_CHANNEL[arg_5_1]

		RPC.rpc_add_weave_buffs(var_5_2, var_5_1, unpack(var_5_0))
	end
end
