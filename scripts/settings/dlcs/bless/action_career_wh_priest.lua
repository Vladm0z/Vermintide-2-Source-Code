-- chunkname: @scripts/settings/dlcs/bless/action_career_wh_priest.lua

require("scripts/settings/profiles/career_constants")

local var_0_0 = {}
local var_0_1 = {
	external_optional_duration = CareerConstants.wh_priest.talent_6_1_improved_ability_duration,
	mechanism_overrides = {
		versus = {
			external_optional_duration = CareerConstants.wh_priest.talent_6_1_improved_ability_duration_versus
		}
	}
}
local var_0_2 = {
	"victor_priest_activated_ability_invincibility",
	"victor_priest_activated_ability_nuke",
	"victor_priest_activated_noclip"
}

ActionCareerWHPriestUtility = {}

ActionCareerWHPriestUtility.cast_spell = function (arg_1_0, arg_1_1)
	ActionCareerWHPriestUtility._add_buffs_to_target(arg_1_0, arg_1_1)

	local var_1_0 = ScriptUnit.extension(arg_1_1, "talent_system")

	if var_1_0:has_talent("victor_priest_4_2_new") then
		ScriptUnit.extension(arg_1_1, "career_system"):get_passive_ability_by_name("wh_priest"):modify_resource_percent(CareerConstants.wh_priest.talent_4_2_fury_to_gain_percent)
	end

	if var_1_0:has_talent("victor_priest_6_2") then
		if arg_1_0 ~= arg_1_1 then
			ActionCareerWHPriestUtility._add_buffs_to_target(arg_1_1, arg_1_1)
		else
			local var_1_1 = Managers.state.side.side_by_unit[arg_1_1]

			if not var_1_1 then
				return
			end

			local var_1_2 = var_1_1.PLAYER_AND_BOT_UNITS
			local var_1_3 = #var_1_2
			local var_1_4 = math.huge
			local var_1_5
			local var_1_6 = POSITION_LOOKUP[arg_1_1]

			for iter_1_0 = 1, var_1_3 do
				local var_1_7 = var_1_2[iter_1_0]

				if ALIVE[var_1_7] and var_1_7 ~= arg_1_1 then
					local var_1_8 = POSITION_LOOKUP[var_1_7]
					local var_1_9 = Vector3.distance_squared(var_1_6, var_1_8)

					if var_1_9 < var_1_4 then
						var_1_4 = var_1_9
						var_1_5 = var_1_7
					end
				end
			end

			ActionCareerWHPriestUtility._add_buffs_to_target(var_1_5, arg_1_1)
		end
	end
end

ActionCareerWHPriestUtility._add_buffs_to_target = function (arg_2_0, arg_2_1)
	local var_2_0 = var_0_2
	local var_2_1 = var_0_0

	if ScriptUnit.extension(arg_2_1, "talent_system"):has_talent("victor_priest_6_1") then
		var_2_1 = MechanismOverrides.get(var_0_1)
		var_2_1.external_optional_duration = var_0_1.external_optional_duration

		local var_2_2 = Managers.mechanism:current_mechanism_name()

		if var_0_1.mechanism_overrides[var_2_2] then
			var_2_1.external_optional_duration = var_0_1.mechanism_overrides[var_2_2].external_optional_duration
		end
	end

	var_2_1.attacker_unit = arg_2_1

	if ALIVE[arg_2_0] then
		local var_2_3 = Managers.state.entity:system("buff_system")

		for iter_2_0 = 1, #var_2_0 do
			local var_2_4 = var_2_0[iter_2_0]

			var_2_3:add_buff_synced(arg_2_0, var_2_4, BuffSyncType.All, var_2_1)
		end
	end
end

ActionCareerWHPriest = class(ActionCareerWHPriest, ActionBase)

ActionCareerWHPriest.init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)
	ActionCareerWHPriest.super.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)

	arg_3_0.owner_unit = arg_3_4
	arg_3_0.career_extension = ScriptUnit.extension(arg_3_4, "career_system")
	arg_3_0.input_extension = ScriptUnit.extension(arg_3_4, "input_system")
	arg_3_0.inventory_extension = ScriptUnit.extension(arg_3_4, "inventory_system")
	arg_3_0.status_extension = ScriptUnit.extension(arg_3_4, "status_system")
	arg_3_0.first_person_extension = ScriptUnit.extension(arg_3_4, "first_person_system")
	arg_3_0.talent_extension = ScriptUnit.extension(arg_3_4, "talent_system")
	arg_3_0.world = arg_3_1
end

ActionCareerWHPriest.client_owner_start_action = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_5 = arg_4_5 or {}

	ActionCareerWHPriest.super.client_owner_start_action(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)

	local var_4_0 = arg_4_3 and arg_4_3.target

	if arg_4_1.target_self and not arg_4_0.is_bot then
		var_4_0 = arg_4_0.owner_unit
	end

	if ALIVE[var_4_0] then
		ActionCareerWHPriestUtility.cast_spell(var_4_0, arg_4_0.owner_unit)
		arg_4_0.career_extension:start_activated_ability_cooldown()
		CharacterStateHelper.play_animation_event(arg_4_0.owner_unit, "witch_hunter_active_ability")
		arg_4_0:_play_vo()
	end
end

ActionCareerWHPriest.client_owner_post_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	return
end

ActionCareerWHPriest.finish = function (arg_6_0, arg_6_1)
	ActionCareerWHPriest.super.finish(arg_6_0, arg_6_1)
	arg_6_0.inventory_extension:wield_previous_non_level_slot()
end

ActionCareerWHPriest._play_vo = function (arg_7_0)
	local var_7_0 = arg_7_0.owner_unit
	local var_7_1 = ScriptUnit.extension_input(var_7_0, "dialogue_system")
	local var_7_2 = FrameTable.alloc_table()

	var_7_1:trigger_networked_dialogue_event("activate_ability", var_7_2)

	local var_7_3 = arg_7_0.first_person_extension
	local var_7_4 = "career_ability_priest_cast_t3"

	var_7_3:play_hud_sound_event(var_7_4)
	var_7_3:play_remote_unit_sound_event(var_7_4, var_7_0, 0)
end
