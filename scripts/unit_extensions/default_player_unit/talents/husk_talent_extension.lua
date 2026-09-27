-- chunkname: @scripts/unit_extensions/default_player_unit/talents/husk_talent_extension.lua

HuskTalentExtension = class(HuskTalentExtension)

HuskTalentExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self.world = arg_1_1.world
	self.is_server = Managers.player.is_server
	self.is_husk = arg_1_3.is_husk
	self.player = arg_1_3.player
	self._profile_index = arg_1_3.profile_index
	self._talent_buff_ids = {}
	self._talent_ids = {}
	self._initial_talent_sync_completed = false
end

HuskTalentExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	local extension = ScriptUnit.extension(arg_2_2, "career_system")

	self.buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	self.career_extension = extension

	local _profile_index = self._profile_index
	local display_name = SPProfiles[_profile_index].display_name

	self._career_name, self._hero_name = extension:career_name(), display_name
end

HuskTalentExtension.set_talent_ids = function (self, arg_3_1)
	-- function 3
	self._talent_ids = arg_3_1

	if not (self.is_server or self.is_husk) then
		if not self._initial_talent_sync_completed then
			self._initial_talent_sync_completed = true

			Managers.state.event:trigger("on_initial_talents_synced", self)
		end

		Managers.state.event:trigger("on_talents_changed", self._unit, self)
	end
end

local tbl = {}

HuskTalentExtension.apply_buffs_from_talents = function (self)
	-- function 4
	local _talent_ids = self._talent_ids
	local _hero_name = self._hero_name
	local buff_extension = self.buff_extension
	local player = self.player
	local _talent_buff_ids = self._talent_buff_ids
	local tbl = {}

	for i = 1, #_talent_buff_ids do
		local var_4_6 = _talent_buff_ids[i]
		local num_sub_buffs = buff_extension:num_sub_buffs(var_4_6)

		if num_sub_buffs > 0 then
			local get_buff_by_id = buff_extension:get_buff_by_id(var_4_6)

			tbl[get_buff_by_id.buff_type] = {
				num_buffs = num_sub_buffs,
				buff_name = get_buff_by_id.template.buff_to_add
			}
		end
	end

	self:_clear_buffs_from_talents()

	for j = 1, #_talent_ids do
		local var_4_9 = _talent_ids[j]
		local get_talent_by_id = TalentUtils.get_talent_by_id(_hero_name, var_4_9)

		if not get_talent_by_id then
			local buffs = get_talent_by_id.buffs
			local buffer = get_talent_by_id.buffer

			if not (not player.local_player and not buffer and buffer == "client" and (not self.is_server and buffer == "server" and self.is_server or not player.local_player and buffer == "both") or buffer ~= "all") then
				local count

				if not buffs then
					count = #buffs

					if not count then
						-- Nothing
					end
				end

				count = 0

				::label_4_0::

				if count > 0 then
					for k = 1, count do
						local var_4_14 = buffs[k]
						local add_buff = buff_extension:add_buff(var_4_14)
						local var_4_16 = tbl[var_4_14]

						if not var_4_16 then
							for l = 1, var_4_16.num_buffs do
								buff_extension:add_buff(var_4_16.buff_name, {
									attacker_unit = player.player_unit
								})
							end
						end

						_talent_buff_ids[#_talent_buff_ids + 1] = add_buff
					end
				end
			end

			if not player.local_player then
				local client_buffs = get_talent_by_id.client_buffs

				if not client_buffs then
					for i4 = 1, #client_buffs do
						local var_4_18 = client_buffs[i4]
						local add_buff_2 = buff_extension:add_buff(var_4_18)

						_talent_buff_ids[#_talent_buff_ids + 1] = add_buff_2
					end
				end
			end

			if not self.is_server then
				local server_buffs = get_talent_by_id.server_buffs

				if not server_buffs then
					for i5 = 1, #server_buffs do
						local var_4_21 = server_buffs[i5]
						local add_buff_3 = buff_extension:add_buff(var_4_21)

						_talent_buff_ids[#_talent_buff_ids + 1] = add_buff_3
					end
				end
			end
		end
	end
end

HuskTalentExtension._clear_buffs_from_talents = function (self)
	-- function 5
	local buff_extension = self.buff_extension
	local _talent_buff_ids = self._talent_buff_ids
	local count = #_talent_buff_ids

	for i = 1, count do
		local var_5_3 = _talent_buff_ids[i]

		buff_extension:remove_buff(var_5_3)
	end

	table.clear(self._talent_buff_ids)
end

HuskTalentExtension.has_talent = function (self, arg_6_1)
	-- function 6
	local _talent_ids = self._talent_ids
	local var_6_1 = TalentIDLookup[arg_6_1]

	if not var_6_1 then
		return false
	end

	if var_6_1.hero_name ~= self._hero_name then
		return false
	end

	local talent_id = var_6_1.talent_id

	for i = 1, #_talent_ids do
		if talent_id == _talent_ids[i] then
			return true
		end
	end

	return false
end

HuskTalentExtension.get_talent_ids = function (self)
	-- function 7
	return self._talent_ids
end

HuskTalentExtension.get_talent_names = function (self, arg_8_1)
	-- function 8
	local _talent_ids = self._talent_ids
	local _hero_name = self._hero_name

	arg_8_1 = arg_8_1 or {}

	for i = 1, #_talent_ids do
		local var_8_2 = _talent_ids[i]
		local get_talent_by_id = TalentUtils.get_talent_by_id(_hero_name, var_8_2)

		arg_8_1[#arg_8_1 + 1] = get_talent_by_id.name
	end

	return arg_8_1
end

HuskTalentExtension.destroy = function (arg_9_0)
	-- function 9
	return
end

HuskTalentExtension.initial_talent_synced = function (self)
	-- function 10
	return self._initial_talent_sync_completed
end
