-- chunkname: @scripts/unit_extensions/default_player_unit/talents/talent_extension.lua

TalentExtension = class(TalentExtension)

TalentExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self.world = arg_1_1.world
	self.is_server = Managers.player.is_server
	self.player = arg_1_3.player
	self._profile_index = arg_1_3.profile_index
	self._talent_buff_ids = {}
	self.talent_career_skill_index = 1
end

TalentExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	local extension = ScriptUnit.extension(arg_2_2, "career_system")
	local extension_2 = ScriptUnit.extension(arg_2_2, "inventory_system")

	self.buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	self.career_extension = extension
	self.inventory_extension = extension_2

	local _profile_index = self._profile_index
	local var_2_3 = SPProfiles[_profile_index]
	local career_name

	self._hero_affiliation, self._hero_name, career_name = var_2_3.affiliation, var_2_3.display_name, extension:career_name()
	self._career_name = career_name

	local get_talent_ids = self:get_talent_ids()

	self:_check_talent_package_dendencies(get_talent_ids, true)
	self:apply_buffs_from_talents(get_talent_ids)
	self:_update_talent_weapon_index(get_talent_ids)
	self:_broadcast_talents_changed()
	self:_check_resync()
end

TalentExtension.game_object_initialized = function (self, arg_3_1, arg_3_2)
	-- function 3
	local get_talent_ids = self:get_talent_ids()

	self:_send_rpc_sync_talents(get_talent_ids)
end

TalentExtension.talents_changed = function (self)
	-- function 4
	local get_talent_ids = self:get_talent_ids()

	self:_check_talent_package_dendencies(get_talent_ids)
	self:apply_buffs_from_talents(get_talent_ids)
	self:_update_talent_weapon_index(get_talent_ids)
	self.inventory_extension:update_career_skill_weapon_slot_safe()
	self:_check_resync()

	if not Managers.state.network:game() then
		self:_send_rpc_sync_talents(get_talent_ids)
	end

	self:_broadcast_talents_changed(false)
end

TalentExtension._send_rpc_sync_talents = function (self, arg_5_1)
	-- function 5
	local network_transmit = Managers.state.network.network_transmit
	local go_id = Managers.state.unit_storage:go_id(self._unit)

	printf("TalentExtension:_send_rpc_sync_talents %d", go_id)

	if not self.is_server then
		network_transmit:send_rpc_clients("rpc_sync_talents", go_id, arg_5_1)
	else
		network_transmit:send_rpc_server("rpc_sync_talents", go_id, arg_5_1)
	end
end

TalentExtension.apply_buffs_from_talents = function (self, arg_6_1)
	-- function 6
	local _hero_name = self._hero_name
	local buff_extension = self.buff_extension
	local player = self.player
	local _talent_buff_ids = self._talent_buff_ids
	local tbl = {}

	for i = 1, #_talent_buff_ids do
		local var_6_5 = _talent_buff_ids[i]
		local get_buff_by_id = buff_extension:get_buff_by_id(var_6_5)

		if not get_buff_by_id and not get_buff_by_id.template.restore_sub_buffs then
			local num_sub_buffs = buff_extension:num_sub_buffs(var_6_5)

			if num_sub_buffs > 0 then
				tbl[get_buff_by_id.buff_type] = {
					num_buffs = num_sub_buffs,
					buff_name = get_buff_by_id.template.buff_to_add
				}
			end
		end
	end

	self:_clear_buffs_from_talents()

	if not Managers.state.game_mode:has_activated_mutator("whiterun") then
		return
	end

	local is_server = self.is_server

	is_server = not is_server and player.bot_player

	for j = 1, #arg_6_1 do
		local var_6_9 = arg_6_1[j]
		local get_talent_by_id = TalentUtils.get_talent_by_id(_hero_name, var_6_9)

		if not get_talent_by_id then
			local buffs = get_talent_by_id.buffs
			local buffer = get_talent_by_id.buffer

			if not ((player.local_player or not is_server or not buffer) and buffer == "client" or not self.is_server or buffer == "server" or self.is_server or not player.local_player or buffer == "both" or buffer ~= "all") then
				local count

				if not buffs then
					count = #buffs

					if not count then
						-- Nothing
					end
				end

				count = 0

				::label_6_0::

				if count > 0 then
					for k = 1, count do
						local var_6_14 = buffs[k]
						local add_buff = buff_extension:add_buff(var_6_14)
						local var_6_16 = tbl[var_6_14]

						if not var_6_16 then
							for l = 1, var_6_16.num_buffs do
								buff_extension:add_buff(var_6_16.buff_name, {
									attacker_unit = player.player_unit
								})
							end
						end

						_talent_buff_ids[#_talent_buff_ids + 1] = add_buff
					end
				end
			end

			if player.local_player or not is_server then
				local client_buffs = get_talent_by_id.client_buffs

				if not client_buffs then
					for i4 = 1, #client_buffs do
						local var_6_18 = client_buffs[i4]
						local add_buff_2 = buff_extension:add_buff(var_6_18)

						_talent_buff_ids[#_talent_buff_ids + 1] = add_buff_2
					end
				end
			end

			if not self.is_server then
				local server_buffs = get_talent_by_id.server_buffs

				if not server_buffs then
					for i5 = 1, #server_buffs do
						local var_6_21 = server_buffs[i5]
						local add_buff_3 = buff_extension:add_buff(var_6_21)

						_talent_buff_ids[#_talent_buff_ids + 1] = add_buff_3
					end
				end
			end
		end
	end
end

TalentExtension._update_talent_weapon_index = function (self, arg_7_1)
	-- function 7
	local flag = not Managers.state.game_mode:has_activated_mutator("whiterun")
	local talent_career_weapon_index = self.talent_career_weapon_index

	self.talent_career_weapon_index = nil
	self.talent_career_skill_index = 1

	if not flag then
		local _hero_name = self._hero_name

		for i = 1, #arg_7_1 do
			local var_7_3 = arg_7_1[i]
			local get_talent_by_id = TalentUtils.get_talent_by_id(_hero_name, var_7_3)

			if not get_talent_by_id then
				if not get_talent_by_id.talent_career_skill_index then
					self.talent_career_skill_index = get_talent_by_id.talent_career_skill_index
				end

				if not get_talent_by_id.talent_career_weapon_index then
					self.talent_career_weapon_index = get_talent_by_id.talent_career_weapon_index
				end
			end
		end
	end

	if not (talent_career_weapon_index == self.talent_career_weapon_index or flag) then
		self._needs_loadout_resync = true
	end
end

TalentExtension.get_talent_career_skill_index = function (self)
	-- function 8
	return self.talent_career_skill_index
end

TalentExtension.get_talent_career_weapon_index = function (self)
	-- function 9
	return self.talent_career_weapon_index
end

TalentExtension._clear_buffs_from_talents = function (self)
	-- function 10
	local buff_extension = self.buff_extension
	local _talent_buff_ids = self._talent_buff_ids
	local count = #_talent_buff_ids

	for i = 1, count do
		local var_10_3 = _talent_buff_ids[i]

		buff_extension:remove_buff(var_10_3)
	end

	table.clear(self._talent_buff_ids)
end

TalentExtension.has_talent = function (self, arg_11_1)
	-- function 11
	if not Managers.state.game_mode:has_activated_mutator("whiterun") then
		return false
	end

	local get_talent_ids = self:get_talent_ids()
	local var_11_1 = TalentIDLookup[arg_11_1]

	if not var_11_1 then
		return false
	end

	if var_11_1.hero_name ~= self._hero_name then
		return false
	end

	local talent_id = var_11_1.talent_id

	for i = 1, #get_talent_ids do
		if talent_id == get_talent_ids[i] then
			return true
		end
	end

	return false
end

TalentExtension.get_talent_ids = function (self)
	-- function 12
	local get_talents_interface = Managers.backend:get_talents_interface()
	local _career_name = self._career_name
	local bot_player = self.player.bot_player

	return (get_talents_interface:get_talent_ids(_career_name, nil, bot_player))
end

TalentExtension.has_talent_perk = function (self, arg_13_1)
	-- function 13
	local _hero_name = self._hero_name

	if self._hero_affiliation == "tutorial" then
		return
	end

	local get_talent_ids = self:get_talent_ids()

	for i = 1, #get_talent_ids do
		local var_13_2 = get_talent_ids[i]
		local get_talent_by_id = TalentUtils.get_talent_by_id(_hero_name, var_13_2)

		if not get_talent_by_id then
			local perks = get_talent_by_id.perks

			if not perks then
				local count = #perks

				for j = 1, count do
					if perks[j] == arg_13_1 then
						return true
					end
				end
			end
		end
	end
end

TalentExtension.get_talent_names = function (self)
	-- function 14
	local get_talent_ids = self:get_talent_ids()
	local tbl = {}
	local _hero_name = self._hero_name

	for i, v in ipairs(get_talent_ids) do
		local get_talent_by_id = TalentUtils.get_talent_by_id(_hero_name, v)

		tbl[#tbl + 1] = get_talent_by_id.name
	end

	return tbl
end

TalentExtension._broadcast_talents_changed = function (self)
	-- function 15
	local event = Managers.state.event

	if not event then
		event:trigger("on_talents_changed", self._unit, self)
	end
end

TalentExtension.destroy = function (arg_16_0)
	-- function 16
	return
end

TalentExtension.initial_talent_synced = function (arg_17_0)
	-- function 17
	return true
end

TalentExtension._check_talent_package_dendencies = function (self, arg_18_1, arg_18_2)
	-- function 18
	local tbl = {}
	local num = 0
	local _hero_name = self._hero_name

	for i = 1, #arg_18_1 do
		local var_18_3 = arg_18_1[i]

		if not TalentUtils.get_talent_by_id(_hero_name, var_18_3).requires_packages then
			num = num + 1
			tbl[num] = var_18_3
		end
	end

	table.sort(tbl)

	if not arg_18_2 then
		self._talent_ids_with_dependencies = tbl
	else
		local _talent_ids_with_dependencies = self._talent_ids_with_dependencies

		if not (not _talent_ids_with_dependencies and #_talent_ids_with_dependencies == num) then
			self._needs_loadout_resync = true
		else
			for j = 1, num do
				if tbl[j] ~= _talent_ids_with_dependencies[j] then
					self._needs_loadout_resync = true

					break
				end
			end
		end
	end
end

TalentExtension._check_resync = function (self)
	-- function 19
	if not self._needs_loadout_resync then
		return
	end

	self._needs_loadout_resync = false

	local network_id = self.player:network_id()
	local local_player_id = self.player:local_player_id()
	local bot_player = self.player.bot_player
	local flag = true

	Managers.state.network.profile_synchronizer:resync_loadout(network_id, local_player_id, bot_player, flag)
end
