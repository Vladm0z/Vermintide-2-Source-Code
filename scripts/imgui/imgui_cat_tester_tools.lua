-- chunkname: @scripts/imgui/imgui_cat_tester_tools.lua

ImguiCatTesterTools = class(ImguiCatTesterTools)
ImguiCatTesterTools.curated_pickup_list = ImguiCatTesterTools.curated_pickup_list or {
	"all_ammo_small",
	"cooldown_reduction_potion",
	"damage_boost_potion",
	"deus_relic_01",
	"deus_soft_currency",
	"deus_weapon_chest",
	"explosive_barrel",
	"fire_grenade_t1",
	"first_aid_kit",
	"frag_grenade_t1",
	"engineer_grenade_t1",
	"grimoire",
	"healing_draught",
	"lamp_oil",
	"speed_boost_potion",
	"tome",
	"torch"
}
ImguiCatTesterTools.curated_breed_list = ImguiCatTesterTools.curated_breed_list or {
	"beastmen_bestigor",
	"beastmen_gor",
	"beastmen_minotaur",
	"beastmen_standard_bearer",
	"beastmen_ungor_archer",
	"beastmen_ungor",
	"chaos_berzerker",
	"chaos_corruptor_sorcerer",
	"chaos_fanatic",
	"chaos_marauder_with_shield",
	"chaos_marauder",
	"chaos_raider",
	"chaos_spawn",
	"chaos_troll",
	"chaos_troll_chief",
	"chaos_vortex_sorcerer",
	"chaos_warrior",
	"critter_pig",
	"skaven_clan_rat_with_shield",
	"skaven_clan_rat",
	"skaven_gutter_runner",
	"skaven_pack_master",
	"skaven_plague_monk",
	"skaven_poison_wind_globadier",
	"skaven_rat_ogre",
	"skaven_ratling_gunner",
	"skaven_slave",
	"skaven_storm_vermin_with_shield",
	"skaven_storm_vermin",
	"skaven_stormfiend",
	"skaven_warpfire_thrower"
}

local var_0_0 = {
	beastmen_ungor = "Ungor",
	_UNKNOWN = "Unknown",
	beastmen_bestigor = "Bestigor",
	critter_pig = "xdd",
	skaven_clan_rat_with_shield = "Clan Rat w/ Shield",
	beastmen_ungor_archer = "Ungor Archer",
	chaos_fanatic = "Fanatic",
	beastmen_gor = "Gor",
	skaven_storm_vermin_with_shield = "Stormvermin w/ Shield"
}

local function var_0_1(arg_1_0)
	local var_1_0 = var_0_0[arg_1_0]

	if not var_1_0 then
		var_1_0 = Localize(arg_1_0)
		var_0_0[arg_1_0] = var_1_0
	end

	return var_1_0
end

local function var_0_2(arg_2_0, arg_2_1)
	return var_0_1(arg_2_0) < var_0_1(arg_2_1)
end

ImguiCatTesterTools.init = function (arg_3_0)
	table.sort(ImguiCatTesterTools.curated_breed_list, var_0_2)

	arg_3_0._breed_index = 0
	arg_3_0._breed_filter_text = ""
	arg_3_0._breed_names = table.map(ImguiCatTesterTools.curated_breed_list, var_0_1)
	arg_3_0._breed_results = table.shallow_copy(arg_3_0._breed_names)

	table.sort(ImguiCatTesterTools.curated_pickup_list, var_0_2)

	arg_3_0._pickup_index = 0
	arg_3_0._pickup_filter_text = ""
	arg_3_0._pickup_names = table.map(ImguiCatTesterTools.curated_pickup_list, function (arg_4_0)
		local var_4_0 = AllPickups[arg_4_0]

		return var_0_1(var_4_0 and var_4_0.hud_description or "_UNKNOWN")
	end)
	arg_3_0._pickup_results = table.shallow_copy(arg_3_0._pickup_names)

	table.sort(arg_3_0._pickup_names)
end

ImguiCatTesterTools.update = function (arg_5_0)
	return
end

ImguiCatTesterTools.draw = function (arg_6_0)
	local var_6_0 = Imgui.begin_window("CAT Tester Tools")

	Imgui.begin_child_window("Pickups", 0, 150, false)

	arg_6_0._pickup_index, arg_6_0._pickup_results, arg_6_0._pickup_filter_text = ImguiX.combo_search(arg_6_0._pickup_index, arg_6_0._pickup_results, arg_6_0._pickup_filter_text, arg_6_0._pickup_names)

	local var_6_1 = ImguiCatTesterTools.curated_pickup_list[arg_6_0._pickup_index]

	if Imgui.button("Spawn Pickup", 100, 20) and var_6_1 then
		arg_6_0:_spawn_pickup(var_6_1)
	end

	Imgui.end_child_window()
	Imgui.begin_child_window("Breeds", 0, 150, false)

	arg_6_0._breed_index, arg_6_0._breed_results, arg_6_0._breed_filter_text = ImguiX.combo_search(arg_6_0._breed_index, arg_6_0._breed_results, arg_6_0._breed_filter_text, arg_6_0._breed_names)

	local var_6_2 = ImguiCatTesterTools.curated_breed_list[arg_6_0._breed_index]

	if Imgui.button("Spawn Breed", 100, 20) and var_6_2 then
		arg_6_0:_spawn_breed(var_6_2)
	end

	Imgui.end_child_window()
	Imgui.begin_child_window("Settings", 0, 150, true)

	script_data.disable_ai_perception = Imgui.checkbox("Disable AI Perception", script_data.disable_ai_perception or false)
	script_data.player_invincible = Imgui.checkbox("Player Invincible", script_data.player_invincible or false)
	script_data.infinite_ammo = Imgui.checkbox("Infinite Ammo", script_data.infinite_ammo or false)
	script_data.disable_overcharge = Imgui.checkbox("Disable Overcharge", script_data.disable_overcharge or false)
	script_data.short_ability_cooldowns = Imgui.checkbox("Short Ability Cooldowns", script_data.short_ability_cooldowns or false)

	if Imgui.radio_button("Normal crit", not script_data.no_critical_strikes and not script_data.always_critical_strikes) then
		script_data.no_critical_strikes = false
		script_data.always_critical_strikes = false
	elseif Imgui.radio_button("Never crit", not not script_data.no_critical_strikes) then
		script_data.no_critical_strikes = true
		script_data.always_critical_strikes = false
	elseif Imgui.radio_button("Always crit", not not script_data.always_critical_strikes) then
		script_data.no_critical_strikes = false
		script_data.always_critical_strikes = true
	end

	Imgui.end_child_window()
	Imgui.end_window()

	return var_6_0
end

ImguiCatTesterTools._spawn_pickup = function (arg_7_0, arg_7_1)
	local var_7_0 = Application.main_world()
	local var_7_1 = Managers.state.conflict:player_aim_raycast(var_7_0, false, "filter_ray_horde_spawn")

	if var_7_1 then
		Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", NetworkLookup.pickup_names[arg_7_1], var_7_1, Quaternion.identity(), NetworkLookup.pickup_spawn_types.dropped)
	end
end

ImguiCatTesterTools._spawn_breed = function (arg_8_0, arg_8_1)
	Managers.state.conflict:aim_spawning(Breeds[arg_8_1], true)
end

ImguiCatTesterTools.is_persistent = function (arg_9_0)
	return false
end
