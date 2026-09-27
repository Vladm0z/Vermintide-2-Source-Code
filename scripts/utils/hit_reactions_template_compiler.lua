-- chunkname: @scripts/utils/hit_reactions_template_compiler.lua

require("scripts/managers/status_effect/status_effect_templates")
dofile("scripts/settings/hit_effects/hit_effects_skaven_clan_rat")
dofile("scripts/settings/hit_effects/hit_effects_skaven_slave")
dofile("scripts/settings/hit_effects/hit_effects_skaven_clan_rat_shield")
dofile("scripts/settings/hit_effects/hit_effects_skaven_plague_monk")
dofile("scripts/settings/hit_effects/hit_effects_storm_vermin")
dofile("scripts/settings/hit_effects/hit_effects_storm_vermin_champion")
dofile("scripts/settings/hit_effects/hit_effects_gutter_runner")
dofile("scripts/settings/hit_effects/hit_effects_rat_ogre")
dofile("scripts/settings/hit_effects/hit_effects_stormfiend")
dofile("scripts/settings/hit_effects/hit_effects_grey_seer")
dofile("scripts/settings/hit_effects/hit_effects_grey_seer_mounted")
dofile("scripts/settings/hit_effects/hit_effects_poison_wind")
dofile("scripts/settings/hit_effects/hit_effects_ratling_gunner")
dofile("scripts/settings/hit_effects/hit_effects_critter_pig")
dofile("scripts/settings/hit_effects/hit_effects_critter_rat")
dofile("scripts/settings/hit_effects/hit_effects_chaos_troll")
dofile("scripts/settings/hit_effects/hit_effects_skaven_pack_master")
dofile("scripts/settings/hit_effects/hit_effects_skaven_loot_rat")
dofile("scripts/settings/hit_effects/hit_effects_chaos_marauder")
dofile("scripts/settings/hit_effects/hit_effects_chaos_berzerker")
dofile("scripts/settings/hit_effects/hit_effects_chaos_raider")
dofile("scripts/settings/hit_effects/hit_effects_chaos_marauder_shield")
dofile("scripts/settings/hit_effects/hit_effects_chaos_warrior")
dofile("scripts/settings/hit_effects/hit_effects_chaos_bulwark")
dofile("scripts/settings/hit_effects/hit_effects_chaos_exalted_champion")
dofile("scripts/settings/hit_effects/hit_effects_dummy_sorcerer")
dofile("scripts/settings/hit_effects/hit_effects_chaos_sorcerer")
dofile("scripts/settings/hit_effects/hit_effects_chaos_exalted_sorcerer")
dofile("scripts/settings/hit_effects/hit_effects_chaos_zombie")
dofile("scripts/settings/hit_effects/hit_effects_chaos_spawn")
dofile("scripts/settings/hit_effects/hit_effects_undead_ethereal_skeleton")
dofile("scripts/settings/hit_effects/hit_effects_training_dummy")
dofile("scripts/settings/breeds")
DLCUtils.dofile_list("hit_effects")

Dismemberments = {}
HitTemplates = {}
SoundEvents = {}
DismemberFlowEvents = {
	explode_head = true
}
AdditionalHitReactions = {
	"HitEffectsSkavenGreySeerMounted"
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	if not arg_1_1 then
		return
	end

	local tbl = {}

	for k, v in pairs(arg_1_1) do
		local str = "dismember_" .. k

		tbl[k] = str
		DismemberFlowEvents[str] = true
	end

	Dismemberments[arg_1_0] = tbl
end

local function fn_2(arg_2_0)
	-- function 2
	if not SoundEvents[arg_2_0] then
		local tbl = {
			["false"] = arg_2_0,
			["true"] = arg_2_0 .. "_husk"
		}

		SoundEvents[arg_2_0] = tbl
	end
end

local function fn_3(self, arg_3_1)
	-- function 3
	local str = ""

	for i = 1, #self do
		local var_3_1 = str
		local sprintf = sprintf
		local str_2 = "\t%q inherits from %q\n"
		local var_3_4 = self[i]
		local var_3_5 = self[i + 1]

		var_3_5 = var_3_5 or arg_3_1
		str = var_3_1 .. sprintf(str_2, var_3_4, var_3_5)
	end

	return str
end

local function fn_4(self, arg_4_1, arg_4_2)
	-- function 4
	local tbl = {}

	if not self.inherits then
		local inherits = self.inherits
		local var_4_2 = arg_4_1[inherits]

		assert(var_4_2, sprintf("Couldn't inherit from template %q; Template does not exist.", self.inherits))
		assert(table.contains(arg_4_2, inherits) == false, sprintf("Cyclic inheritence in %q:\n%s", arg_4_2[1], fn_3(arg_4_2, inherits)))

		arg_4_2[#arg_4_2 + 1] = inherits
		tbl = fn_4(var_4_2, arg_4_1, arg_4_2)
	end

	local conditions = tbl.conditions

	conditions = conditions or {}

	local num_conditions = tbl.num_conditions

	num_conditions = num_conditions or 0

	for k, v in pairs(self) do
		tbl[k] = v
	end

	if not self.extra_conditions then
		for k_2, v_2 in pairs(self.extra_conditions) do
			if not conditions[k_2] then
				num_conditions = num_conditions + 1
			end

			conditions[k_2] = v_2
		end

		tbl.extra_conditions = nil
	end

	tbl.conditions = conditions
	tbl.num_conditions = num_conditions

	return tbl
end

local function fn_5(self, arg_5_1)
	-- function 5
	local num_conditions = arg_5_1.num_conditions

	for i = #self + 1, 1, -1 do
		if not (i == 1 or not (num_conditions <= self[i - 1].num_conditions)) then
			self[i] = arg_5_1

			break
		else
			self[i] = self[i - 1]
		end
	end
end

local function fn_6(arg_6_0)
	-- function 6
	if not arg_6_0 and not HitTemplates[arg_6_0] then
		return
	end

	local tbl = {}
	local var_6_1 = rawget(_G, arg_6_0)

	for k, v in pairs(var_6_1) do
		local var_6_2 = fn_4(v, var_6_1, {
			k
		})

		var_6_2.template_name = k

		fn_5(tbl, var_6_2)

		if not v.sound_event then
			local sound_event = v.sound_event

			if type(sound_event) == "string" then
				fn_2(sound_event)
			else
				local count = #sound_event

				for k_2 = 1, count do
					fn_2(sound_event[k_2])
				end
			end
		end
	end

	HitTemplates[arg_6_0] = tbl
end

;(function ()
	-- function 7
	for k, v in pairs(Breeds) do
		fn(k, v.hit_zones)
		fn_6(v.hit_effect_template)
	end

	for k_2, v_2 in pairs(PlayerBreeds) do
		fn(k_2, v_2.hit_zones)
	end

	for k_3, v_3 in pairs(AdditionalHitReactions) do
		fn_6(v_3)
	end
end)()
