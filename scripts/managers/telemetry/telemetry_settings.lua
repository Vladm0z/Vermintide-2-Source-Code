-- chunkname: @scripts/managers/telemetry/telemetry_settings.lua

local scripts_settings_crashify_settings = require("scripts/settings/crashify_settings")
local tbl = {
	endpoint = "https://telemetry-utvxrq72na-ez.a.run.app/events",
	enabled = not Development.parameter("telemetry-disable")
}
local tbl_2 = {
	id = "honduras",
	platform = PLATFORM,
	environment = BUILD
}
local tbl_3 = {
	game = VersionSettings.version
}
local value_or_nil = string.value_or_nil
local build_identifier = script_data.build_identifier

build_identifier = build_identifier or Development.parameter("engine_revision")
tbl_3.engine_revision = value_or_nil(build_identifier)

local value_or_nil_2 = string.value_or_nil
local parameter

if script_data.settings.content_revision == "" then
	parameter = Development.parameter("content_revision")

	if not parameter then
		-- Nothing
	end
end

parameter = script_data.settings.content_revision

::label_0_0::

tbl_3.content_revision = value_or_nil_2(parameter)
tbl_2.version = tbl_3
tbl_2.data = {
	testify = string.value_or_nil(script_data.testify),
	steam_branch = string.value_or_nil(script_data.steam_branch),
	svn_branch = string.value_or_nil(script_data.svn_branch),
	title_id = GameSettingsDevelopment.backend_settings.title_id
}
tbl_2.crashify = {
	project_branch = string.value_or_nil(scripts_settings_crashify_settings.branch)
}
tbl.source = tbl_2
tbl.batch = {
	size = 2000,
	max_size = 16000,
	full_post_interval = 30,
	post_interval = 300
}
tbl.heartbeat = {
	interval = 300
}
tbl.blacklist = {}
tbl.collect_memory = BUILD == "release" or Development.parameter("telemetry-collect-memory")
tbl.use_session_survey = Development.parameter("use-session-survey")
TelemetrySettings = tbl
