-- chunkname: @scripts/ui/views/pactsworn_video_transition_view_definitions.lua

local tbl = {
	{
		video_name = "video/pactsworn_tunnel_transition_1",
		sound_start = "Play_versus_sfx_tunnel_warp",
		scenegraph_id = "pactsworn_video",
		loop = false,
		material_name = "pactsworn_tunnel_transition_1",
		sound_stop = "Stop_versus_sfx_tunnel_warp"
	},
	{
		video_name = "video/pactsworn_tunnel_transition_2",
		sound_start = "Play_versus_sfx_tunnel_warp",
		scenegraph_id = "pactsworn_video",
		loop = false,
		material_name = "pactsworn_tunnel_transition_2",
		sound_stop = "Stop_versus_sfx_tunnel_warp"
	},
	{
		video_name = "video/pactsworn_tunnel_transition_3",
		sound_start = "Play_versus_sfx_tunnel_warp",
		scenegraph_id = "pactsworn_video",
		loop = false,
		material_name = "pactsworn_tunnel_transition_3",
		sound_stop = "Stop_versus_sfx_tunnel_warp"
	},
	{
		video_name = "video/pactsworn_tunnel_transition_4",
		sound_start = "Play_versus_sfx_tunnel_warp",
		scenegraph_id = "pactsworn_video",
		loop = false,
		material_name = "pactsworn_tunnel_transition_4",
		sound_stop = "Stop_versus_sfx_tunnel_warp"
	}
}
local tbl_2 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	background = {
		vertical_alignment = "center",
		scale = "fit",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			99
		}
	},
	pactsworn_video = {
		parent = "root",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			700
		}
	}
}
local str = "PACTSWORN_VIDEO_PLAYER"

return {
	scenegraph_definition = tbl_2,
	pactsworn_video_data = tbl,
	reference_name = str
}
