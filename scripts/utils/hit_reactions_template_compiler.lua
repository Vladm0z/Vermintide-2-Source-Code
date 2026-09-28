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

local function setup_dismemberment_table(breed_name, hit_zones)
	-- function 1
	if not hit_zones then
		return
	end

	local events = {}

	for hit_zone, _ in pairs(hit_zones) do
		local event_name = "dismember_" .. hit_zone

		events[hit_zone] = event_name
		DismemberFlowEvents[event_name] = true
	end

	Dismemberments[breed_name] = events
end

local function add_to_sound_events_table(sound_event)
	-- function 2
	if not SoundEvents[sound_event] then
		local events = {}

		events["false"] = sound_event
		events["true"] = sound_event .. "_husk"
		SoundEvents[sound_event] = events
	end
end

local function get_inheritence_list(template_list, last_template)
	-- function 3
	local s = ""

	for i = 1, #template_list do
		local var_3_0 = s
		local sprintf = sprintf
		local str = "\t%q inherits from %q\n"
		local var_3_3 = template_list[i]
		local var_3_4 = template_list[i + 1]

		var_3_4 = not not var_3_4 or not not last_template
		s = var_3_0 .. sprintf(str, var_3_3, var_3_4)
	end

	return s
end

local function compile_template_rule(template, all_templates, inherited_templates)
	-- function 4
	local new_template = {}

	if template.inherits then
		local parent_template_name = template.inherits
		local parent_template = all_templates[parent_template_name]

		assert(parent_template, sprintf("Couldn't inherit from template %q; Template does not exist.", template.inherits))
		assert(table.contains(inherited_templates, parent_template_name) == false, sprintf("Cyclic inheritence in %q:\n%s", inherited_templates[1], get_inheritence_list(inherited_templates, parent_template_name)))

		inherited_templates[#inherited_templates + 1] = parent_template_name
		new_template = compile_template_rule(parent_template, all_templates, inherited_templates)
	end

	local conditions_2 = new_template.conditions

	if not conditions_2 then
		-- Nothing
	end

	conditions_2 = {}

	local conditions = conditions_2

	::label_4_0::

	local num_conditions_2 = new_template.num_conditions

	if not num_conditions_2 then
		-- Nothing
	end

	num_conditions_2 = 0

	local num_conditions = num_conditions_2

	::label_4_1::

	for key, value in pairs(template) do
		new_template[key] = value
	end

	if template.extra_conditions then
		for key, value in pairs(template.extra_conditions) do
			if not conditions[key] then
				num_conditions = num_conditions + 1
			end

			conditions[key] = value
		end

		new_template.extra_conditions = nil
	end

	new_template.conditions = conditions
	new_template.num_conditions = num_conditions

	return new_template
end

local function insert_sorted(t, template_rule)
	-- function 5
	local num_conditions = template_rule.num_conditions

	for i = #t + 1, 1, -1 do
		if i == 1 or num_conditions <= t[i - 1].num_conditions then
			t[i] = template_rule

			break
		else
			t[i] = t[i - 1]
		end
	end
end

local function compile_effects_templates(template)
	-- function 6
	if not template or HitTemplates[template] then
		return
	end

	local new_templates = {}
	local templates = rawget(_G, template)

	for name, template_rule in pairs(templates) do
		local new_template_rule = compile_template_rule(template_rule, templates, {
			name
		})

		new_template_rule.template_name = name

		insert_sorted(new_templates, new_template_rule)

		if template_rule.sound_event then
			local sound_event = template_rule.sound_event

			if type(sound_event) == "string" then
				add_to_sound_events_table(sound_event)
			else
				local num_events = #sound_event

				for i = 1, num_events do
					add_to_sound_events_table(sound_event[i])
				end
			end
		end
	end

	HitTemplates[template] = new_templates
end

local function setup_hit_reactions()
	-- function 7
	for breed_name, breed_settings in pairs(Breeds) do
		setup_dismemberment_table(breed_name, breed_settings.hit_zones)
		compile_effects_templates(breed_settings.hit_effect_template)
	end

	for breed_name, breed_settings in pairs(PlayerBreeds) do
		setup_dismemberment_table(breed_name, breed_settings.hit_zones)
	end

	for _, hit_effect_template in pairs(AdditionalHitReactions) do
		compile_effects_templates(hit_effect_template)
	end
end

setup_hit_reactions()
