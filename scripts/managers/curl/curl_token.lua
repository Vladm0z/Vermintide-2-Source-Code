-- chunkname: @scripts/managers/curl/curl_token.lua

CurlToken = class(CurlToken)

function CurlToken.init(arg_1_0, arg_1_1)
	arg_1_0._token = arg_1_1
	arg_1_0._info = {}

	if not arg_1_1 then
		arg_1_0._info.done = true
		arg_1_0._info.error = "Not a valid token"
	end
end

function CurlToken.info(arg_2_0)
	return arg_2_0._info
end

function CurlToken.update(arg_3_0)
	if arg_3_0._token then
		arg_3_0._info = Curl.progress(arg_3_0._token)
	end
end

function CurlToken.done(arg_4_0)
	return arg_4_0._info.done
end

function CurlToken.close(arg_5_0)
	if arg_5_0._token then
		Curl.close(arg_5_0._token)
	end
end
