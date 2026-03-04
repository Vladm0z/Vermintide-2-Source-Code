-- chunkname: @scripts/unit_extensions/default_player_unit/talents/husk_talent_extension.lua

HuskTalentExtension = class(HuskTalentExtension)

function HuskTalentExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.is_husk = arg_1_3.is_husk
	arg_1_0.player = arg_1_3.player
	arg_1_0._profile_index = arg_1_3.profile_index
	arg_1_0._talent_buff_ids = {}
	arg_1_0._talent_ids = {}
	arg_1_0._initial_talent_sync_completed = false
end

function HuskTalentExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = ScriptUnit.extension(arg_2_2, "career_system")

	arg_2_0.buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0.career_extension = var_2_0

	local var_2_1 = arg_2_0._profile_index
	local var_2_2 = SPProfiles[var_2_1].display_name

	arg_2_0._career_name, arg_2_0._hero_name = var_2_0:career_name(), var_2_2
end

function HuskTalentExtension.set_talent_ids(arg_3_0, arg_3_1)
	arg_3_0._talent_ids = arg_3_1

	if arg_3_0.is_server or not arg_3_0.is_husk then
		if not arg_3_0._initial_talent_sync_completed then
			arg_3_0._initial_talent_sync_completed = true

			Managers.state.event:trigger("on_initial_talents_synced", arg_3_0)
		end

		Managers.state.event:trigger("on_talents_changed", arg_3_0._unit, arg_3_0)
	end
end

local var_0_0 = {}

function HuskTalentExtension.apply_buffs_from_talents(arg_4_0)
	local var_4_0 = arg_4_0._talent_ids
	local var_4_1 = arg_4_0._hero_name
	local var_4_2 = arg_4_0.buff_extension
	local var_4_3 = arg_4_0.player
	local var_4_4 = arg_4_0._talent_buff_ids
	local var_4_5 = {}

	for iter_4_0 = 1, #var_4_4 do
		local var_4_6 = var_4_4[iter_4_0]
		local var_4_7 = var_4_2:num_sub_buffs(var_4_6)

		if var_4_7 > 0 then
			local var_4_8 = var_4_2:get_buff_by_id(var_4_6)

			var_4_5[var_4_8.buff_type] = {
				num_buffs = var_4_7,
				buff_name = var_4_8.template.buff_to_add
			}
		end
	end

	arg_4_0:_clear_buffs_from_talents()

	for iter_4_1 = 1, #var_4_0 do
		local var_4_9 = var_4_0[iter_4_1]
		local var_4_10 = TalentUtils.get_talent_by_id(var_4_1, var_4_9)

		if var_4_10 then
			local var_4_11 = var_4_10.buffs
			local var_4_12 = var_4_10.buffer

			if var_4_3.local_player and (not var_4_12 or var_4_12 == "client") or arg_4_0.is_server and var_4_12 == "server" or (arg_4_0.is_server or var_4_3.local_player) and var_4_12 == "both" or var_4_12 == "all" then
				local var_4_13 = var_4_11 and #var_4_11 or 0

				if var_4_13 > 0 then
					for iter_4_2 = 1, var_4_13 do
						local var_4_14 = var_4_11[iter_4_2]
						local var_4_15 = var_4_2:add_buff(var_4_14)
						local var_4_16 = var_4_5[var_4_14]

						if var_4_16 then
							for iter_4_3 = 1, var_4_16.num_buffs do
								var_4_2:add_buff(var_4_16.buff_name, {
									attacker_unit = var_4_3.player_unit
								})
							end
						end

						var_4_4[#var_4_4 + 1] = var_4_15
					end
				end
			end

			if var_4_3.local_player then
				local var_4_17 = var_4_10.client_buffs

				if var_4_17 then
					for iter_4_4 = 1, #var_4_17 do
						local var_4_18 = var_4_17[iter_4_4]
						local var_4_19 = var_4_2:add_buff(var_4_18)

						var_4_4[#var_4_4 + 1] = var_4_19
					end
				end
			end

			if arg_4_0.is_server then
				local var_4_20 = var_4_10.server_buffs

				if var_4_20 then
					for iter_4_5 = 1, #var_4_20 do
						local var_4_21 = var_4_20[iter_4_5]
						local var_4_22 = var_4_2:add_buff(var_4_21)

						var_4_4[#var_4_4 + 1] = var_4_22
					end
				end
			end
		end
	end
end

function HuskTalentExtension._clear_buffs_from_talents(arg_5_0)
	local var_5_0 = arg_5_0.buff_extension
	local var_5_1 = arg_5_0._talent_buff_ids
	local var_5_2 = #var_5_1

	for iter_5_0 = 1, var_5_2 do
		local var_5_3 = var_5_1[iter_5_0]

		var_5_0:remove_buff(var_5_3)
	end

	table.clear(arg_5_0._talent_buff_ids)
end

function HuskTalentExtension.has_talent(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._talent_ids
	local var_6_1 = TalentIDLookup[arg_6_1]

	if not var_6_1 then
		return false
	end

	if var_6_1.hero_name ~= arg_6_0._hero_name then
		return false
	end

	local var_6_2 = var_6_1.talent_id

	for iter_6_0 = 1, #var_6_0 do
		if var_6_2 == var_6_0[iter_6_0] then
			return true
		end
	end

	return false
end

function HuskTalentExtension.get_talent_ids(arg_7_0)
	return arg_7_0._talent_ids
end

function HuskTalentExtension.get_talent_names(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._talent_ids
	local var_8_1 = arg_8_0._hero_name

	arg_8_1 = arg_8_1 or {}

	for iter_8_0 = 1, #var_8_0 do
		local var_8_2 = var_8_0[iter_8_0]
		local var_8_3 = TalentUtils.get_talent_by_id(var_8_1, var_8_2)

		arg_8_1[#arg_8_1 + 1] = var_8_3.name
	end

	return arg_8_1
end

function HuskTalentExtension.destroy(arg_9_0)
	return
end

function HuskTalentExtension.initial_talent_synced(arg_10_0)
	return arg_10_0._initial_talent_sync_completed
end
