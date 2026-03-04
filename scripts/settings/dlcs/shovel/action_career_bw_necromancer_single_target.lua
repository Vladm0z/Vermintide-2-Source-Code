-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_single_target.lua

ActionCareerBWNecromancerSingleTarget = class(ActionCareerBWNecromancerSingleTarget, ActionBase)

function ActionCareerBWNecromancerSingleTarget.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerBWNecromancerSingleTarget.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0._owner_unit = arg_1_4
end

function ActionCareerBWNecromancerSingleTarget.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	ActionCareerBWNecromancerSingleTarget.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	if arg_2_3 then
		arg_2_0:_play_vo()

		arg_2_0.target = arg_2_3.target

		local var_2_0 = arg_2_0.target
		local var_2_1 = arg_2_0._owner_unit

		Managers.state.entity:system("buff_system"):add_buff(var_2_0, "sienna_necromancer_career_skill_on_hit_damage", var_2_1, false)

		if arg_2_0._talent_extension:has_talent("sienna_necromancer_5_1") then
			-- block empty
		end

		arg_2_0._career_extension:start_activated_ability_cooldown()
	end
end

function ActionCareerBWNecromancerSingleTarget.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

function ActionCareerBWNecromancerSingleTarget.finish(arg_4_0, arg_4_1)
	arg_4_0._inventory_extension:wield_previous_non_level_slot()
end

function ActionCareerBWNecromancerSingleTarget._play_vo(arg_5_0)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = ScriptUnit.extension_input(var_5_0, "dialogue_system")
	local var_5_2 = FrameTable.alloc_table()

	var_5_1:trigger_networked_dialogue_event("activate_ability", var_5_2)
end
