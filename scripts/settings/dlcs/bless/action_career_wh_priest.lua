-- chunkname: @scripts/settings/dlcs/bless/action_career_wh_priest.lua

require("scripts/settings/profiles/career_constants")

local tbl = {}
local tbl_2 = {
	external_optional_duration = CareerConstants.wh_priest.talent_6_1_improved_ability_duration,
	mechanism_overrides = {
		versus = {
			external_optional_duration = CareerConstants.wh_priest.talent_6_1_improved_ability_duration_versus
		}
	}
}
local tbl_3 = {
	"victor_priest_activated_ability_invincibility",
	"victor_priest_activated_ability_nuke",
	"victor_priest_activated_noclip"
}

ActionCareerWHPriestUtility = {}

ActionCareerWHPriestUtility.cast_spell = function (arg_1_0, arg_1_1)
	-- function 1
	ActionCareerWHPriestUtility._add_buffs_to_target(arg_1_0, arg_1_1)

	local extension = ScriptUnit.extension(arg_1_1, "talent_system")

	if not extension:has_talent("victor_priest_4_2_new") then
		ScriptUnit.extension(arg_1_1, "career_system"):get_passive_ability_by_name("wh_priest"):modify_resource_percent(CareerConstants.wh_priest.talent_4_2_fury_to_gain_percent)
	end

	if not extension:has_talent("victor_priest_6_2") then
		if arg_1_0 ~= arg_1_1 then
			ActionCareerWHPriestUtility._add_buffs_to_target(arg_1_1, arg_1_1)
		else
			local var_1_1 = Managers.state.side.side_by_unit[arg_1_1]

			if not var_1_1 then
				return
			end

			local PLAYER_AND_BOT_UNITS = var_1_1.PLAYER_AND_BOT_UNITS
			local count = #PLAYER_AND_BOT_UNITS
			local huge = math.huge
			local var_1_5
			local var_1_6 = POSITION_LOOKUP[arg_1_1]

			for i = 1, count do
				local var_1_7 = PLAYER_AND_BOT_UNITS[i]

				if not (not ALIVE[var_1_7] and var_1_7 == arg_1_1) then
					local var_1_8 = POSITION_LOOKUP[var_1_7]
					local distance_squared = Vector3.distance_squared(var_1_6, var_1_8)

					if distance_squared < huge then
						huge = distance_squared
						var_1_5 = var_1_7
					end
				end
			end

			ActionCareerWHPriestUtility._add_buffs_to_target(var_1_5, arg_1_1)
		end
	end
end

ActionCareerWHPriestUtility._add_buffs_to_target = function (arg_2_0, arg_2_1)
	-- function 2
	local var_2_0 = tbl_3
	local var_2_1 = tbl

	if not ScriptUnit.extension(arg_2_1, "talent_system"):has_talent("victor_priest_6_1") then
		var_2_1 = MechanismOverrides.get(tbl_2)
		var_2_1.external_optional_duration = tbl_2.external_optional_duration

		local current_mechanism_name = Managers.mechanism:current_mechanism_name()

		if not tbl_2.mechanism_overrides[current_mechanism_name] then
			var_2_1.external_optional_duration = tbl_2.mechanism_overrides[current_mechanism_name].external_optional_duration
		end
	end

	var_2_1.attacker_unit = arg_2_1

	if not ALIVE[arg_2_0] then
		local system = Managers.state.entity:system("buff_system")

		for i = 1, #var_2_0 do
			local var_2_4 = var_2_0[i]

			system:add_buff_synced(arg_2_0, var_2_4, BuffSyncType.All, var_2_1)
		end
	end
end

ActionCareerWHPriest = class(ActionCareerWHPriest, ActionBase)

ActionCareerWHPriest.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)
	-- function 3
	ActionCareerWHPriest.super.init(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)

	self.owner_unit = arg_3_4
	self.career_extension = ScriptUnit.extension(arg_3_4, "career_system")
	self.input_extension = ScriptUnit.extension(arg_3_4, "input_system")
	self.inventory_extension = ScriptUnit.extension(arg_3_4, "inventory_system")
	self.status_extension = ScriptUnit.extension(arg_3_4, "status_system")
	self.first_person_extension = ScriptUnit.extension(arg_3_4, "first_person_system")
	self.talent_extension = ScriptUnit.extension(arg_3_4, "talent_system")
	self.world = arg_3_1
end

ActionCareerWHPriest.client_owner_start_action = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_5 = arg_4_5 or {}

	ActionCareerWHPriest.super.client_owner_start_action(self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)

	local flag = not arg_4_3 and arg_4_3.target

	if not (not arg_4_1.target_self and self.is_bot) then
		flag = self.owner_unit
	end

	if not ALIVE[flag] then
		ActionCareerWHPriestUtility.cast_spell(flag, self.owner_unit)
		self.career_extension:start_activated_ability_cooldown()
		CharacterStateHelper.play_animation_event(self.owner_unit, "witch_hunter_active_ability")
		self:_play_vo()
	end
end

ActionCareerWHPriest.client_owner_post_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	return
end

ActionCareerWHPriest.finish = function (self, arg_6_1)
	-- function 6
	ActionCareerWHPriest.super.finish(self, arg_6_1)
	self.inventory_extension:wield_previous_non_level_slot()
end

ActionCareerWHPriest._play_vo = function (self)
	-- function 7
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)

	local first_person_extension = self.first_person_extension
	local str = "career_ability_priest_cast_t3"

	first_person_extension:play_hud_sound_event(str)
	first_person_extension:play_remote_unit_sound_event(str, owner_unit, 0)
end
