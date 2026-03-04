-- chunkname: @scripts/unit_extensions/default_player_unit/talents/talent_extension.lua

TalentExtension = class(TalentExtension)

function TalentExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.player = arg_1_3.player
	arg_1_0._profile_index = arg_1_3.profile_index
	arg_1_0._talent_buff_ids = {}
	arg_1_0.talent_career_skill_index = 1
end

function TalentExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = ScriptUnit.extension(arg_2_2, "career_system")
	local var_2_1 = ScriptUnit.extension(arg_2_2, "inventory_system")

	arg_2_0.buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0.career_extension = var_2_0
	arg_2_0.inventory_extension = var_2_1

	local var_2_2 = arg_2_0._profile_index
	local var_2_3 = SPProfiles[var_2_2]
	local var_2_4

	arg_2_0._hero_affiliation, arg_2_0._hero_name, var_2_4 = var_2_3.affiliation, var_2_3.display_name, var_2_0:career_name()
	arg_2_0._career_name = var_2_4

	local var_2_5 = arg_2_0:get_talent_ids()

	arg_2_0:_check_talent_package_dendencies(var_2_5, true)
	arg_2_0:apply_buffs_from_talents(var_2_5)
	arg_2_0:_update_talent_weapon_index(var_2_5)
	arg_2_0:_broadcast_talents_changed()
	arg_2_0:_check_resync()
end

function TalentExtension.game_object_initialized(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0:get_talent_ids()

	arg_3_0:_send_rpc_sync_talents(var_3_0)
end

function TalentExtension.talents_changed(arg_4_0)
	local var_4_0 = arg_4_0:get_talent_ids()

	arg_4_0:_check_talent_package_dendencies(var_4_0)
	arg_4_0:apply_buffs_from_talents(var_4_0)
	arg_4_0:_update_talent_weapon_index(var_4_0)
	arg_4_0.inventory_extension:update_career_skill_weapon_slot_safe()
	arg_4_0:_check_resync()

	if Managers.state.network:game() then
		arg_4_0:_send_rpc_sync_talents(var_4_0)
	end

	arg_4_0:_broadcast_talents_changed(false)
end

function TalentExtension._send_rpc_sync_talents(arg_5_0, arg_5_1)
	local var_5_0 = Managers.state.network.network_transmit
	local var_5_1 = Managers.state.unit_storage:go_id(arg_5_0._unit)

	printf("TalentExtension:_send_rpc_sync_talents %d", var_5_1)

	if arg_5_0.is_server then
		var_5_0:send_rpc_clients("rpc_sync_talents", var_5_1, arg_5_1)
	else
		var_5_0:send_rpc_server("rpc_sync_talents", var_5_1, arg_5_1)
	end
end

function TalentExtension.apply_buffs_from_talents(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._hero_name
	local var_6_1 = arg_6_0.buff_extension
	local var_6_2 = arg_6_0.player
	local var_6_3 = arg_6_0._talent_buff_ids
	local var_6_4 = {}

	for iter_6_0 = 1, #var_6_3 do
		local var_6_5 = var_6_3[iter_6_0]
		local var_6_6 = var_6_1:get_buff_by_id(var_6_5)

		if var_6_6 and var_6_6.template.restore_sub_buffs then
			local var_6_7 = var_6_1:num_sub_buffs(var_6_5)

			if var_6_7 > 0 then
				var_6_4[var_6_6.buff_type] = {
					num_buffs = var_6_7,
					buff_name = var_6_6.template.buff_to_add
				}
			end
		end
	end

	arg_6_0:_clear_buffs_from_talents()

	if Managers.state.game_mode:has_activated_mutator("whiterun") then
		return
	end

	local var_6_8 = arg_6_0.is_server and var_6_2.bot_player

	for iter_6_1 = 1, #arg_6_1 do
		local var_6_9 = arg_6_1[iter_6_1]
		local var_6_10 = TalentUtils.get_talent_by_id(var_6_0, var_6_9)

		if var_6_10 then
			local var_6_11 = var_6_10.buffs
			local var_6_12 = var_6_10.buffer

			if (var_6_2.local_player or var_6_8) and (not var_6_12 or var_6_12 == "client") or arg_6_0.is_server and var_6_12 == "server" or (arg_6_0.is_server or var_6_2.local_player) and var_6_12 == "both" or var_6_12 == "all" then
				local var_6_13 = var_6_11 and #var_6_11 or 0

				if var_6_13 > 0 then
					for iter_6_2 = 1, var_6_13 do
						local var_6_14 = var_6_11[iter_6_2]
						local var_6_15 = var_6_1:add_buff(var_6_14)
						local var_6_16 = var_6_4[var_6_14]

						if var_6_16 then
							for iter_6_3 = 1, var_6_16.num_buffs do
								var_6_1:add_buff(var_6_16.buff_name, {
									attacker_unit = var_6_2.player_unit
								})
							end
						end

						var_6_3[#var_6_3 + 1] = var_6_15
					end
				end
			end

			if var_6_2.local_player or var_6_8 then
				local var_6_17 = var_6_10.client_buffs

				if var_6_17 then
					for iter_6_4 = 1, #var_6_17 do
						local var_6_18 = var_6_17[iter_6_4]
						local var_6_19 = var_6_1:add_buff(var_6_18)

						var_6_3[#var_6_3 + 1] = var_6_19
					end
				end
			end

			if arg_6_0.is_server then
				local var_6_20 = var_6_10.server_buffs

				if var_6_20 then
					for iter_6_5 = 1, #var_6_20 do
						local var_6_21 = var_6_20[iter_6_5]
						local var_6_22 = var_6_1:add_buff(var_6_21)

						var_6_3[#var_6_3 + 1] = var_6_22
					end
				end
			end
		end
	end
end

function TalentExtension._update_talent_weapon_index(arg_7_0, arg_7_1)
	local var_7_0 = not Managers.state.game_mode:has_activated_mutator("whiterun")
	local var_7_1 = arg_7_0.talent_career_weapon_index

	arg_7_0.talent_career_weapon_index = nil
	arg_7_0.talent_career_skill_index = 1

	if var_7_0 then
		local var_7_2 = arg_7_0._hero_name

		for iter_7_0 = 1, #arg_7_1 do
			local var_7_3 = arg_7_1[iter_7_0]
			local var_7_4 = TalentUtils.get_talent_by_id(var_7_2, var_7_3)

			if var_7_4 then
				if var_7_4.talent_career_skill_index then
					arg_7_0.talent_career_skill_index = var_7_4.talent_career_skill_index
				end

				if var_7_4.talent_career_weapon_index then
					arg_7_0.talent_career_weapon_index = var_7_4.talent_career_weapon_index
				end
			end
		end
	end

	if var_7_1 ~= arg_7_0.talent_career_weapon_index and not var_7_0 then
		arg_7_0._needs_loadout_resync = true
	end
end

function TalentExtension.get_talent_career_skill_index(arg_8_0)
	return arg_8_0.talent_career_skill_index
end

function TalentExtension.get_talent_career_weapon_index(arg_9_0)
	return arg_9_0.talent_career_weapon_index
end

function TalentExtension._clear_buffs_from_talents(arg_10_0)
	local var_10_0 = arg_10_0.buff_extension
	local var_10_1 = arg_10_0._talent_buff_ids
	local var_10_2 = #var_10_1

	for iter_10_0 = 1, var_10_2 do
		local var_10_3 = var_10_1[iter_10_0]

		var_10_0:remove_buff(var_10_3)
	end

	table.clear(arg_10_0._talent_buff_ids)
end

function TalentExtension.has_talent(arg_11_0, arg_11_1)
	if Managers.state.game_mode:has_activated_mutator("whiterun") then
		return false
	end

	local var_11_0 = arg_11_0:get_talent_ids()
	local var_11_1 = TalentIDLookup[arg_11_1]

	if not var_11_1 then
		return false
	end

	if var_11_1.hero_name ~= arg_11_0._hero_name then
		return false
	end

	local var_11_2 = var_11_1.talent_id

	for iter_11_0 = 1, #var_11_0 do
		if var_11_2 == var_11_0[iter_11_0] then
			return true
		end
	end

	return false
end

function TalentExtension.get_talent_ids(arg_12_0)
	local var_12_0 = Managers.backend:get_talents_interface()
	local var_12_1 = arg_12_0._career_name
	local var_12_2 = arg_12_0.player.bot_player

	return (var_12_0:get_talent_ids(var_12_1, nil, var_12_2))
end

function TalentExtension.has_talent_perk(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._hero_name

	if arg_13_0._hero_affiliation == "tutorial" then
		return
	end

	local var_13_1 = arg_13_0:get_talent_ids()

	for iter_13_0 = 1, #var_13_1 do
		local var_13_2 = var_13_1[iter_13_0]
		local var_13_3 = TalentUtils.get_talent_by_id(var_13_0, var_13_2)

		if var_13_3 then
			local var_13_4 = var_13_3.perks

			if var_13_4 then
				local var_13_5 = #var_13_4

				for iter_13_1 = 1, var_13_5 do
					if var_13_4[iter_13_1] == arg_13_1 then
						return true
					end
				end
			end
		end
	end
end

function TalentExtension.get_talent_names(arg_14_0)
	local var_14_0 = arg_14_0:get_talent_ids()
	local var_14_1 = {}
	local var_14_2 = arg_14_0._hero_name

	for iter_14_0, iter_14_1 in ipairs(var_14_0) do
		local var_14_3 = TalentUtils.get_talent_by_id(var_14_2, iter_14_1)

		var_14_1[#var_14_1 + 1] = var_14_3.name
	end

	return var_14_1
end

function TalentExtension._broadcast_talents_changed(arg_15_0)
	local var_15_0 = Managers.state.event

	if var_15_0 then
		var_15_0:trigger("on_talents_changed", arg_15_0._unit, arg_15_0)
	end
end

function TalentExtension.destroy(arg_16_0)
	return
end

function TalentExtension.initial_talent_synced(arg_17_0)
	return true
end

function TalentExtension._check_talent_package_dendencies(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = {}
	local var_18_1 = 0
	local var_18_2 = arg_18_0._hero_name

	for iter_18_0 = 1, #arg_18_1 do
		local var_18_3 = arg_18_1[iter_18_0]

		if TalentUtils.get_talent_by_id(var_18_2, var_18_3).requires_packages then
			var_18_1 = var_18_1 + 1
			var_18_0[var_18_1] = var_18_3
		end
	end

	table.sort(var_18_0)

	if arg_18_2 then
		arg_18_0._talent_ids_with_dependencies = var_18_0
	else
		local var_18_4 = arg_18_0._talent_ids_with_dependencies

		if not var_18_4 or #var_18_4 ~= var_18_1 then
			arg_18_0._needs_loadout_resync = true
		else
			for iter_18_1 = 1, var_18_1 do
				if var_18_0[iter_18_1] ~= var_18_4[iter_18_1] then
					arg_18_0._needs_loadout_resync = true

					break
				end
			end
		end
	end
end

function TalentExtension._check_resync(arg_19_0)
	if not arg_19_0._needs_loadout_resync then
		return
	end

	arg_19_0._needs_loadout_resync = false

	local var_19_0 = arg_19_0.player:network_id()
	local var_19_1 = arg_19_0.player:local_player_id()
	local var_19_2 = arg_19_0.player.bot_player
	local var_19_3 = true

	Managers.state.network.profile_synchronizer:resync_loadout(var_19_0, var_19_1, var_19_2, var_19_3)
end
