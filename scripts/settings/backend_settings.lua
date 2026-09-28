-- chunkname: @scripts/settings/backend_settings.lua

local local_backend_available = false
local BackendSettings = BackendSettings

BackendSettings = not not BackendSettings or not not {}
BackendSettings = BackendSettings

local BackendSettings_2 = BackendSettings
local tbl = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "5107",
	is_prod = true
}
local var_0_3 = rawget(_G, "Backend")

var_0_3 = not not var_0_3 and not not Backend.ENV_STAGE
tbl.environment = var_0_3
BackendSettings_2.prod_steam_playfab = tbl

local BackendSettings_3 = BackendSettings
local tbl_2 = {
	enable_sessions = false,
	allow_tutorial = true,
	implementation = "playfab",
	title_id = "9928"
}
local var_0_6 = rawget(_G, "Backend")

var_0_6 = not not var_0_6 and not not Backend.ENV_STAGE
tbl_2.environment = var_0_6
tbl_2.allow_local = local_backend_available
BackendSettings_3.stage_steam_playfab = tbl_2

local BackendSettings_4 = BackendSettings
local tbl_3 = {
	enable_sessions = false,
	allow_tutorial = true,
	implementation = "playfab",
	title_id = "6599"
}
local var_0_9 = rawget(_G, "Backend")

var_0_9 = not not var_0_9 and not not Backend.ENV_STAGE
tbl_3.environment = var_0_9
tbl_3.allow_local = local_backend_available
BackendSettings_4.dev_steam_playfab = tbl_3

local BackendSettings_5 = BackendSettings
local tbl_4 = {
	enable_sessions = false,
	allow_tutorial = true,
	implementation = "playfab",
	title_id = "9C780"
}
local var_0_12 = rawget(_G, "Backend")

var_0_12 = not not var_0_12 and not not Backend.ENV_STAGE
tbl_4.environment = var_0_12
tbl_4.allow_local = local_backend_available
BackendSettings_5.morris_dev_steam_playfab = tbl_4

local BackendSettings_6 = BackendSettings
local tbl_5 = {
	enable_sessions = false,
	allow_tutorial = true,
	implementation = "playfab",
	title_id = "D537D"
}
local var_0_15 = rawget(_G, "Backend")

var_0_15 = not not var_0_15 and not not Backend.ENV_STAGE
tbl_5.environment = var_0_15
tbl_5.allow_local = local_backend_available
BackendSettings_6.carousel_steam_playfab = tbl_5

local BackendSettings_7 = BackendSettings
local tbl_6 = {
	enable_sessions = false,
	allow_tutorial = false,
	implementation = "playfab",
	title_id = "834AF"
}
local var_0_18 = rawget(_G, "Backend")

var_0_18 = not not var_0_18 and not not Backend.ENV_STAGE
tbl_6.environment = var_0_18
tbl_6.allow_local = local_backend_available
BackendSettings_7.morris_beta_steam_playfab = tbl_6

local BackendSettings_8 = BackendSettings
local tbl_7 = {
	enable_sessions = false,
	allow_tutorial = false,
	implementation = "playfab",
	title_id = "9D268"
}
local var_0_21 = rawget(_G, "Backend")

var_0_21 = not not var_0_21 and not not Backend.ENV_STAGE
tbl_7.environment = var_0_21
tbl_7.allow_local = local_backend_available
BackendSettings_8.morris_casual_steam_playfab = tbl_7

local BackendSettings_9 = BackendSettings
local tbl_8 = {
	enable_sessions = false,
	allow_tutorial = true,
	implementation = "playfab",
	title_id = "CF97B"
}
local var_0_24 = rawget(_G, "Backend")

var_0_24 = not not var_0_24 and not not Backend.ENV_STAGE
tbl_8.environment = var_0_24
tbl_8.allow_local = local_backend_available
BackendSettings_9.cat_steam_playfab = tbl_8

local BackendSettings_10 = BackendSettings
local tbl_9 = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "471E2"
}
local var_0_27 = rawget(_G, "Backend")

var_0_27 = not not var_0_27 and not not Backend.ENV_STAGE
tbl_9.environment = var_0_27
BackendSettings_10.beta_steam_playfab = tbl_9

local BackendSettings_11 = BackendSettings
local tbl_10 = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "66427"
}
local var_0_30 = rawget(_G, "Backend")

var_0_30 = not not var_0_30 and not not Backend.ENV_STAGE
tbl_10.environment = var_0_30
BackendSettings_11.stage_xbone_playfab = tbl_10

local BackendSettings_12 = BackendSettings
local tbl_11 = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "4d1e",
	is_prod = true
}
local var_0_33 = rawget(_G, "Backend")

var_0_33 = not not var_0_33 and not not Backend.ENV_STAGE
tbl_11.environment = var_0_33
BackendSettings_12.prod_xbone_playfab = tbl_11

local BackendSettings_13 = BackendSettings
local tbl_12 = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "f844"
}
local var_0_36 = rawget(_G, "Backend")

var_0_36 = not not var_0_36 and not not Backend.ENV_STAGE
tbl_12.environment = var_0_36
BackendSettings_13.dev_xbone_playfab = tbl_12

local BackendSettings_14 = BackendSettings
local tbl_13 = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "B8F9E"
}
local var_0_39 = rawget(_G, "Backend")

var_0_39 = not not var_0_39 and not not Backend.ENV_STAGE
tbl_13.environment = var_0_39
BackendSettings_14.morris_dev_xbone_playfab = tbl_13

local BackendSettings_15 = BackendSettings
local tbl_14 = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "9050"
}
local var_0_42 = rawget(_G, "Backend")

var_0_42 = not not var_0_42 and not not Backend.ENV_STAGE
tbl_14.environment = var_0_42
BackendSettings_15.dev_ps4_playfab = tbl_14

local BackendSettings_16 = BackendSettings
local tbl_15 = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "36F45"
}
local var_0_45 = rawget(_G, "Backend")

var_0_45 = not not var_0_45 and not not Backend.ENV_STAGE
tbl_15.environment = var_0_45
BackendSettings_16.stage_ps4_playfab = tbl_15

local BackendSettings_17 = BackendSettings
local tbl_16 = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "60f3",
	is_prod = true
}
local var_0_48 = rawget(_G, "Backend")

var_0_48 = not not var_0_48 and not not Backend.ENV_STAGE
tbl_16.environment = var_0_48
BackendSettings_17.prod_ps4_playfab = tbl_16

local BackendSettings_18 = BackendSettings
local tbl_17 = {
	enable_sessions = false,
	allow_tutorial = true,
	allow_local = false,
	implementation = "playfab",
	title_id = "D54E0"
}
local var_0_51 = rawget(_G, "Backend")

var_0_51 = not not var_0_51 and not not Backend.ENV_STAGE
tbl_17.environment = var_0_51
BackendSettings_18.morris_dev_ps4_playfab = tbl_17
