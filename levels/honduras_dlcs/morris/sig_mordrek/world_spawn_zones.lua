-- chunkname: @levels/honduras_dlcs/morris/sig_mordrek/world_spawn_zones.lua

local tbl = {
	{
		kind = "good",
		main_path_index = 1,
		crossroads = "",
		marker_type = "normal",
		order = 10,
		pos = {
			-11.079999923706055,
			-4.130000114440918,
			7.150999069213867
		}
	},
	{
		kind = "good",
		main_path_index = 1,
		crossroads = "",
		marker_type = "normal",
		order = 20,
		pos = {
			-5.949999809265137,
			-3.0999999046325684,
			7.0920000076293945
		}
	}
}
local tbl_2 = {
	{
		path_length = 5.232734203338623,
		travel_dist = {
			[1] = 0,
			[2] = 5.232734203338623
		},
		nodes = {
			{
				-11.079999923706055,
				-4.130000114440918,
				7.229452610015869
			},
			{
				-5.949999809265137,
				-3.0999999046325684,
				7.168576240539551
			}
		}
	}
}
local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {}
local num = 0
local num_2 = 0
local num_3 = 5.2327342033386
local str = "1"

return {
	version = str,
	number_of_spawns = num,
	path_markers = tbl,
	zones = tbl_4,
	cover_points = tbl_5,
	num_main_zones = num_2,
	position_lookup = tbl_6,
	main_paths = tbl_2,
	crossroads = tbl_3,
	total_main_path_length = num_3
}
