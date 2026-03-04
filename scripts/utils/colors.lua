-- chunkname: @scripts/utils/colors.lua

require("foundation/scripts/util/table")

Colors = Colors or {}
Colors.color_definitions = {
	maroon = {
		255,
		128,
		0,
		0
	},
	dark_red = {
		255,
		139,
		0,
		0
	},
	brown = {
		255,
		127,
		51,
		0
	},
	firebrick = {
		255,
		178,
		34,
		34
	},
	crimson = {
		255,
		220,
		20,
		60
	},
	red = {
		255,
		255,
		0,
		0
	},
	tomato = {
		255,
		255,
		99,
		71
	},
	coral = {
		255,
		255,
		127,
		80
	},
	indian_red = {
		255,
		205,
		92,
		92
	},
	light_coral = {
		255,
		240,
		128,
		128
	},
	dark_salmon = {
		255,
		233,
		150,
		122
	},
	salmon = {
		255,
		250,
		128,
		114
	},
	light_salmon = {
		255,
		255,
		160,
		122
	},
	cheeseburger = {
		255,
		255,
		168,
		0
	},
	orange_red = {
		255,
		255,
		69,
		0
	},
	dark_orange = {
		255,
		255,
		140,
		0
	},
	orange = {
		255,
		255,
		165,
		0
	},
	gold = {
		255,
		255,
		215,
		0
	},
	dark_golden_rod = {
		255,
		184,
		134,
		11
	},
	golden_rod = {
		255,
		218,
		165,
		32
	},
	pale_golden_rod = {
		255,
		238,
		232,
		170
	},
	dark_khaki = {
		255,
		189,
		183,
		107
	},
	khaki = {
		255,
		240,
		230,
		140
	},
	olive = {
		255,
		128,
		128,
		0
	},
	yellow = {
		255,
		255,
		255,
		0
	},
	yellow_green = {
		255,
		154,
		205,
		50
	},
	online_green = {
		255,
		145,
		226,
		42
	},
	dark_olive_green = {
		255,
		85,
		107,
		47
	},
	olive_drab = {
		255,
		107,
		142,
		35
	},
	lawn_green = {
		255,
		124,
		252,
		0
	},
	chart_reuse = {
		255,
		127,
		255,
		0
	},
	green_yellow = {
		255,
		173,
		255,
		47
	},
	dark_green = {
		255,
		0,
		100,
		0
	},
	green = {
		255,
		0,
		128,
		0
	},
	forest_green = {
		255,
		34,
		139,
		34
	},
	lime = {
		255,
		0,
		255,
		0
	},
	lime_green = {
		255,
		50,
		205,
		50
	},
	light_green = {
		255,
		144,
		238,
		144
	},
	pale_green = {
		255,
		152,
		251,
		152
	},
	dark_sea_green = {
		255,
		143,
		188,
		143
	},
	medium_spring_green = {
		255,
		0,
		250,
		154
	},
	spring_green = {
		255,
		0,
		255,
		127
	},
	sea_green = {
		255,
		46,
		139,
		87
	},
	medium_aqua_marine = {
		255,
		102,
		205,
		170
	},
	medium_sea_green = {
		255,
		60,
		179,
		113
	},
	light_sea_green = {
		255,
		32,
		178,
		170
	},
	dark_slate_gray = {
		255,
		47,
		79,
		79
	},
	teal = {
		255,
		0,
		128,
		128
	},
	dark_cyan = {
		255,
		0,
		139,
		139
	},
	aqua = {
		255,
		0,
		255,
		255
	},
	cyan = {
		255,
		0,
		255,
		255
	},
	light_cyan = {
		255,
		224,
		255,
		255
	},
	dark_turquoise = {
		255,
		0,
		206,
		209
	},
	turquoise = {
		255,
		64,
		224,
		208
	},
	medium_turquoise = {
		255,
		72,
		209,
		204
	},
	pale_turquoise = {
		255,
		175,
		238,
		238
	},
	aqua_marine = {
		255,
		127,
		255,
		212
	},
	powder_blue = {
		255,
		176,
		224,
		230
	},
	cadet_blue = {
		255,
		95,
		158,
		160
	},
	steel_blue = {
		255,
		70,
		130,
		180
	},
	corn_flower_blue = {
		255,
		100,
		149,
		237
	},
	deep_sky_blue = {
		255,
		0,
		191,
		255
	},
	dodger_blue = {
		255,
		30,
		144,
		255
	},
	light_blue = {
		255,
		173,
		216,
		230
	},
	sky_blue = {
		255,
		135,
		206,
		235
	},
	light_sky_blue = {
		255,
		135,
		206,
		250
	},
	midnight_blue = {
		255,
		25,
		25,
		112
	},
	navy = {
		255,
		0,
		0,
		128
	},
	dark_blue = {
		255,
		0,
		0,
		139
	},
	medium_blue = {
		255,
		0,
		0,
		205
	},
	blue = {
		255,
		0,
		0,
		255
	},
	royal_blue = {
		255,
		65,
		105,
		225
	},
	blue_violet = {
		255,
		138,
		43,
		226
	},
	indigo = {
		255,
		75,
		0,
		130
	},
	dark_slate_blue = {
		255,
		72,
		61,
		139
	},
	slate_blue = {
		255,
		106,
		90,
		205
	},
	medium_slate_blue = {
		255,
		123,
		104,
		238
	},
	medium_purple = {
		255,
		147,
		112,
		219
	},
	dark_magenta = {
		255,
		139,
		0,
		139
	},
	dark_violet = {
		255,
		148,
		0,
		211
	},
	dark_orchid = {
		255,
		153,
		50,
		204
	},
	medium_orchid = {
		255,
		186,
		85,
		211
	},
	purple = {
		255,
		128,
		0,
		128
	},
	thistle = {
		255,
		216,
		191,
		216
	},
	plum = {
		255,
		221,
		160,
		221
	},
	violet = {
		255,
		238,
		130,
		238
	},
	magenta = {
		255,
		255,
		0,
		255
	},
	orchid = {
		255,
		218,
		112,
		214
	},
	medium_violet_red = {
		255,
		199,
		21,
		133
	},
	pale_violet_red = {
		255,
		219,
		112,
		147
	},
	deep_pink = {
		255,
		255,
		20,
		147
	},
	hot_pink = {
		255,
		255,
		105,
		180
	},
	light_pink = {
		255,
		255,
		182,
		193
	},
	pink = {
		255,
		255,
		192,
		203
	},
	antique_white = {
		255,
		250,
		235,
		215
	},
	beige = {
		255,
		245,
		245,
		220
	},
	bisque = {
		255,
		255,
		228,
		196
	},
	blanched_almond = {
		255,
		255,
		235,
		205
	},
	wheat = {
		255,
		245,
		222,
		179
	},
	corn_silk = {
		255,
		255,
		248,
		220
	},
	lemon_chiffon = {
		255,
		255,
		250,
		205
	},
	light_golden_rod_yellow = {
		255,
		250,
		250,
		210
	},
	light_yellow = {
		255,
		255,
		255,
		224
	},
	saddle_brown = {
		255,
		139,
		69,
		19
	},
	sienna = {
		255,
		160,
		82,
		45
	},
	chocolate = {
		255,
		210,
		105,
		30
	},
	peru = {
		255,
		205,
		133,
		63
	},
	sandy_brown = {
		255,
		244,
		164,
		96
	},
	burly_wood = {
		255,
		222,
		184,
		135
	},
	tan = {
		255,
		210,
		180,
		140
	},
	rosy_brown = {
		255,
		188,
		143,
		143
	},
	moccasin = {
		255,
		255,
		228,
		181
	},
	navajo_white = {
		255,
		255,
		222,
		173
	},
	peach_puff = {
		255,
		255,
		218,
		185
	},
	misty_rose = {
		255,
		255,
		228,
		225
	},
	lavender_blush = {
		255,
		255,
		240,
		245
	},
	linen = {
		255,
		250,
		240,
		230
	},
	old_lace = {
		255,
		253,
		245,
		230
	},
	papaya_whip = {
		255,
		255,
		239,
		213
	},
	sea_shell = {
		255,
		255,
		245,
		238
	},
	mint_cream = {
		255,
		245,
		255,
		250
	},
	slate_gray = {
		255,
		112,
		128,
		144
	},
	light_slate_gray = {
		255,
		119,
		136,
		153
	},
	light_steel_blue = {
		255,
		176,
		196,
		222
	},
	lavender = {
		255,
		230,
		230,
		250
	},
	floral_white = {
		255,
		255,
		250,
		240
	},
	alice_blue = {
		255,
		240,
		248,
		255
	},
	ghost_white = {
		255,
		248,
		248,
		255
	},
	honeydew = {
		255,
		240,
		255,
		240
	},
	ivory = {
		255,
		255,
		255,
		240
	},
	azure = {
		255,
		240,
		255,
		255
	},
	snow = {
		255,
		255,
		250,
		250
	},
	black = {
		255,
		0,
		0,
		0
	},
	dim_gray = {
		255,
		105,
		105,
		105
	},
	gray = {
		255,
		128,
		128,
		128
	},
	dark_gray = {
		255,
		169,
		169,
		169
	},
	silver = {
		255,
		192,
		192,
		192
	},
	light_gray = {
		255,
		211,
		211,
		211
	},
	gainsboro = {
		255,
		220,
		220,
		220
	},
	white_smoke = {
		255,
		245,
		245,
		245
	},
	white = {
		255,
		255,
		255,
		255
	},
	default = {
		255,
		75,
		100,
		100
	},
	plentiful = {
		255,
		255,
		255,
		255
	},
	common = {
		255,
		41,
		138,
		15
	},
	rare = {
		255,
		33,
		88,
		169
	},
	exotic = {
		255,
		220,
		115,
		10
	},
	unique = {
		255,
		180,
		31,
		38
	},
	magic = {
		255,
		0,
		211,
		178
	},
	promo = {
		255,
		140,
		31,
		135
	},
	event = {
		255,
		140,
		31,
		135
	},
	card_plentiful = {
		255,
		255,
		255,
		255
	},
	card_common = {
		255,
		0,
		255,
		0
	},
	card_rare = {
		255,
		0,
		0,
		255
	},
	card_exotic = {
		255,
		255,
		25,
		0
	},
	card_unique = {
		255,
		255,
		0,
		0
	},
	card_promo = {
		255,
		255,
		0,
		255
	},
	iron_tokens = {
		255,
		255,
		255,
		255
	},
	bronze_tokens = {
		255,
		115,
		197,
		42
	},
	silver_tokens = {
		255,
		30,
		116,
		189
	},
	gold_tokens = {
		255,
		236,
		107,
		20
	},
	drag_same_slot = {
		255,
		255,
		168,
		0
	},
	drag_same_slot_hover = {
		255,
		0,
		255,
		0
	},
	drag_same_slot_disabled = {
		255,
		255,
		0,
		0
	},
	credits_title = {
		255,
		255,
		168,
		0
	},
	credits_header = {
		255,
		255,
		215,
		0
	},
	credits_normal = {
		255,
		255,
		255,
		255
	},
	loading_screen_stone = {
		255,
		23,
		22,
		20
	},
	font_default = {
		255,
		181,
		181,
		181
	},
	font_title = {
		255,
		193,
		91,
		36
	},
	font_button_normal = {
		255,
		160,
		146,
		101
	},
	button_normal = {
		255,
		230,
		40,
		73
	},
	button_green = {
		255,
		0,
		200,
		10
	},
	button_red = {
		255,
		255,
		0,
		0
	},
	hit_marker_normal = {
		255,
		255,
		255,
		255
	},
	hit_marker_critical = {
		255,
		255,
		161,
		53
	},
	hit_marker_armored = {
		255,
		70,
		130,
		180
	},
	hit_marker_friendly = {
		255,
		50,
		205,
		50
	},
	twitch = {
		255,
		100,
		65,
		164
	},
	very_dark_gray = {
		255,
		80,
		80,
		80
	},
	wh_captain = {
		255,
		153,
		184,
		193
	},
	wh_bountyhunter = {
		255,
		198,
		154,
		74
	},
	wh_zealot = {
		255,
		202,
		197,
		174
	},
	wh_priest = {
		255,
		230,
		184,
		71
	},
	dr_ranger = {
		255,
		187,
		235,
		30
	},
	dr_ironbreaker = {
		255,
		41,
		219,
		255
	},
	dr_slayer = {
		255,
		228,
		0,
		0
	},
	dr_engineer = {
		255,
		255,
		191,
		4
	},
	we_waywatcher = {
		255,
		55,
		123,
		44
	},
	we_maidenguard = {
		255,
		74,
		145,
		236
	},
	we_shade = {
		255,
		151,
		99,
		192
	},
	we_thornsister = {
		255,
		64,
		194,
		176
	},
	es_mercenary = {
		255,
		204,
		128,
		128
	},
	es_huntsman = {
		255,
		114,
		130,
		67
	},
	es_knight = {
		255,
		36,
		84,
		173
	},
	es_questingknight = {
		255,
		255,
		191,
		4
	},
	bw_adept = {
		255,
		255,
		93,
		0
	},
	bw_scholar = {
		255,
		173,
		28,
		8
	},
	bw_unchained = {
		255,
		150,
		50,
		100
	},
	bw_necromancer = {
		255,
		1,
		100,
		67
	},
	empire_soldier_tutorial = {
		255,
		36,
		84,
		173
	},
	vs_poison_wind_globadier = {
		255,
		153,
		184,
		193
	},
	vs_gutter_runner = {
		255,
		198,
		154,
		74
	},
	vs_packmaster = {
		255,
		202,
		197,
		174
	},
	vs_ratling_gunner = {
		255,
		228,
		0,
		0
	},
	vs_warpfire_thrower = {
		255,
		255,
		192,
		203
	},
	vs_chaos_troll = {
		255,
		55,
		123,
		44
	},
	vs_rat_ogre = {
		255,
		204,
		128,
		128
	},
	vs_undecided = {
		255,
		255,
		255,
		255
	},
	spectator = {
		255,
		128,
		128,
		128
	},
	console_menu_rect = {
		255,
		0,
		0,
		0
	},
	healthkit_first_aid_kit_01 = {
		255,
		53,
		204,
		53
	},
	wpn_side_objective_tome_01 = {
		255,
		216,
		133,
		0
	},
	potion_healing_draught_01 = {
		255,
		53,
		204,
		53
	},
	potion_damage_boost_01 = {
		255,
		216,
		174,
		69
	},
	potion_speed_boost_01 = {
		255,
		65,
		169,
		228
	},
	potion_cooldown_reduction_01 = {
		255,
		197,
		91,
		255
	},
	wpn_grimoire_01 = {
		255,
		100,
		65,
		164
	},
	grenade_engineer = {
		255,
		240,
		32,
		0
	},
	grenade_frag_01 = {
		255,
		240,
		32,
		0
	},
	grenade_frag_02 = {
		255,
		240,
		32,
		0
	},
	grenade_smoke_01 = {
		255,
		240,
		32,
		0
	},
	grenade_smoke_02 = {
		255,
		240,
		32,
		0
	},
	grenade_fire_01 = {
		255,
		240,
		32,
		0
	},
	grenade_fire_02 = {
		255,
		240,
		32,
		0
	},
	life = {
		255,
		50,
		205,
		50
	},
	metal = {
		255,
		255,
		255,
		0
	},
	death = {
		255,
		139,
		0,
		139
	},
	heavens = {
		255,
		0,
		191,
		255
	},
	light = {
		255,
		255,
		255,
		255
	},
	beasts = {
		255,
		139,
		69,
		19
	},
	fire = {
		255,
		220,
		20,
		60
	},
	shadow = {
		255,
		128,
		128,
		128
	},
	khorne = {
		255,
		254,
		52,
		31
	},
	tzeentch = {
		255,
		61,
		150,
		251
	},
	slaanesh = {
		255,
		236,
		109,
		251
	},
	nurgle = {
		255,
		200,
		230,
		81
	},
	belakor = {
		255,
		172,
		134,
		218
	},
	deus_potion = {
		255,
		155,
		17,
		30
	},
	local_player_team_lighter = {
		255,
		72,
		95,
		143
	},
	local_player_team = {
		255,
		72,
		95,
		143
	},
	local_player_team_darker = {
		255,
		5,
		43,
		94
	},
	local_scoreboard_entry = {
		20,
		157,
		180,
		222
	},
	local_scoreboard_entry_dark = {
		20,
		0,
		30,
		85
	},
	opponent_team_lighter = {
		255,
		164,
		55,
		53
	},
	opponent_team = {
		255,
		164,
		55,
		53
	},
	opponent_team_darkened = {
		255,
		63,
		12,
		0
	},
	opponent_scoreboard_entry = {
		20,
		233,
		139,
		141
	},
	opponent_scoreboard_entry_dark = {
		20,
		48,
		0,
		1
	},
	local_player_picking = {
		255,
		177,
		144,
		31
	},
	other_player_picking = {
		255,
		113,
		160,
		219
	},
	heroes_color = {
		255,
		141,
		69,
		0
	},
	pactsworn_color = {
		255,
		33,
		106,
		34
	},
	pactsworn_light_green = {
		100,
		144,
		238,
		144
	},
	pactsworn_green = {
		165,
		38,
		255,
		0
	},
	pactsworn_red = {
		255,
		255,
		0,
		0
	}
}
Colors.indexed_colors, Colors.num_colors = table.values(Colors.color_definitions)

if not Colors.distinct_colors_lookup then
	local var_0_0 = 1
	local var_0_1 = 92 + 63 * (var_0_0 % 3)
	local var_0_2 = var_0_1 / 2

	Colors.distinct_colors_lookup = {
		{
			0,
			var_0_1,
			0
		},
		{
			0,
			0,
			var_0_1
		},
		{
			var_0_1,
			0,
			0
		},
		{
			var_0_1,
			var_0_1,
			0
		},
		{
			0,
			var_0_1,
			var_0_1
		},
		{
			var_0_1,
			0,
			var_0_1
		},
		{
			var_0_1,
			var_0_2,
			0
		},
		{
			var_0_1,
			0,
			var_0_2
		},
		{
			0,
			var_0_2,
			var_0_1
		},
		{
			var_0_2,
			0,
			var_0_1
		}
	}
end

function Colors.get_categorical_color(arg_1_0)
	local var_1_0 = arg_1_0 * 1.61803398875 % 1

	return {
		255,
		Colors.hsl2rgb(var_1_0, 0.4, 0.5)
	}
end

function Colors.get(arg_2_0)
	local var_2_0 = Colors.color_definitions[arg_2_0]

	return Color(var_2_0[1], var_2_0[2], var_2_0[3], var_2_0[4])
end

function Colors.get_color_with_alpha(arg_3_0, arg_3_1)
	local var_3_0 = Colors.color_definitions[arg_3_0]

	return Color(arg_3_1, var_3_0[2], var_3_0[3], var_3_0[4])
end

function Colors.get_table(arg_4_0)
	local var_4_0 = Colors.color_definitions[arg_4_0]

	return {
		var_4_0[1],
		var_4_0[2],
		var_4_0[3],
		var_4_0[4]
	}
end

function Colors.get_table_rgba(arg_5_0)
	local var_5_0 = Colors.color_definitions[arg_5_0]

	return {
		var_5_0[2],
		var_5_0[3],
		var_5_0[4],
		var_5_0[1]
	}
end

function Colors.get_color_table_with_alpha(arg_6_0, arg_6_1)
	local var_6_0 = Colors.color_definitions[arg_6_0]

	return {
		arg_6_1,
		var_6_0[2],
		var_6_0[3],
		var_6_0[4]
	}
end

function Colors.get_indexed(arg_7_0)
	local var_7_0 = Colors.indexed_colors[arg_7_0]

	return Color(var_7_0[1], var_7_0[2], var_7_0[3], var_7_0[4])
end

function Colors.copy_to(arg_8_0, arg_8_1)
	arg_8_0[1] = arg_8_1[1]
	arg_8_0[2] = arg_8_1[2]
	arg_8_0[3] = arg_8_1[3]
	arg_8_0[4] = arg_8_1[4]
end

function Colors.copy_no_alpha_to(arg_9_0, arg_9_1)
	arg_9_0[2] = arg_9_1[2]
	arg_9_0[3] = arg_9_1[3]
	arg_9_0[4] = arg_9_1[4]
end

function Colors.set(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	arg_10_0[1] = arg_10_1
	arg_10_0[2] = arg_10_2
	arg_10_0[3] = arg_10_3
	arg_10_0[4] = arg_10_4
end

function Colors.lerp_color_tables(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_3 = arg_11_3 or {}

	local var_11_0 = 1 - arg_11_2

	arg_11_3[1] = arg_11_0[1] * var_11_0 + arg_11_1[1] * arg_11_2
	arg_11_3[2] = arg_11_0[2] * var_11_0 + arg_11_1[2] * arg_11_2
	arg_11_3[3] = arg_11_0[3] * var_11_0 + arg_11_1[3] * arg_11_2
	arg_11_3[4] = arg_11_0[4] * var_11_0 + arg_11_1[4] * arg_11_2

	return arg_11_3
end

function Colors.from_hex(arg_12_0)
	local var_12_0, var_12_1, var_12_2 = string.match(arg_12_0, "^#?(%x%x)(%x%x)(%x%x)$")

	return tonumber(var_12_0, 16), tonumber(var_12_1, 16), tonumber(var_12_2, 16)
end

local function var_0_3(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_2 < 0 then
		arg_13_2 = arg_13_2 + 1
	elseif arg_13_2 > 1 then
		arg_13_2 = arg_13_2 - 1
	end

	if arg_13_2 < 0.16666666666666666 then
		return arg_13_0 + (arg_13_1 - arg_13_0) * 6 * arg_13_2
	elseif arg_13_2 < 0.5 then
		return arg_13_1
	elseif arg_13_2 < 0.6666666666666666 then
		return arg_13_0 + (arg_13_1 - arg_13_0) * 6 * (0.6666666666666666 - arg_13_2)
	end

	return arg_13_0
end

function Colors.hsl2rgb(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0
	local var_14_1
	local var_14_2

	if arg_14_1 ~= 0 then
		local var_14_3 = arg_14_2 < 0.5 and arg_14_2 * (1 + arg_14_1) or arg_14_1 + arg_14_2 * (1 - arg_14_1)
		local var_14_4 = 2 * arg_14_2 - var_14_3

		var_14_0 = var_0_3(var_14_4, var_14_3, arg_14_0 + 0.3333333333333333)
		var_14_1 = var_0_3(var_14_4, var_14_3, arg_14_0)
		var_14_2 = var_0_3(var_14_4, var_14_3, arg_14_0 - 0.3333333333333333)
	else
		var_14_0, var_14_1, var_14_2 = arg_14_2, arg_14_2, arg_14_2
	end

	local var_14_5 = math.floor

	return var_14_5(var_14_0 * 255 + 0.5), var_14_5(var_14_1 * 255 + 0.5), var_14_5(var_14_2 * 255 + 0.5)
end

local var_0_4 = 0.7

function Colors.darker(arg_15_0, arg_15_1)
	arg_15_1 = var_0_4^(arg_15_1 or 1)
	arg_15_0[2], arg_15_0[3], arg_15_0[4] = arg_15_0[2] * arg_15_1, arg_15_0[3] * arg_15_1, arg_15_0[4] * arg_15_1
end

function Colors.brighter(arg_16_0, arg_16_1)
	return Colors.darker(arg_16_0, -arg_16_1)
end

function Colors.luminance(arg_17_0)
	return 0.2126 * arg_17_0[2] + 0.7152 * arg_17_0[3] + 0.0722 * arg_17_0[4]
end
