local BasePlugin = require "kong.plugins.base_plugin"

local ExternalAuthHandler = BasePlugin:extend()

local http = require "resty.http"
local kong = kong

ExternalAuthHandler.VERSION = "1.0.0"
ExternalAuthHandler.PRIORITY = 900

local function is_ignore_path(request_path, paths)
  for i, path in ipairs(paths) do
    local path_after_replace = path:gsub('*', '.*')
    local match_path = string.match(request_path, path_after_replace)
    if request_path == match_path then
      return true
    end
  end
  return false
end

function ExternalAuthHandler:new()
  ExternalAuthHandler.super.new(self, "external-auth")
end

function ExternalAuthHandler:access(conf)
  ExternalAuthHandler.super.access(self)

  local request_path = kong.request.get_path()

  if is_ignore_path(request_path, conf.no_verify_paths) == false then
    local request_headers = kong.request.get_headers()
    request_headers['X-Forwarded-Ssl'] = 'on'

    local client = http.new()
    client:set_timeouts(conf.connect_timeout, conf.send_timeout, conf.read_timeout)

    local res, err = client:request_uri(conf.auth_service_url, {
      method = "POST",
      path = conf.auth_service_path,
      headers = request_headers,
      ssl_verify = false,
    })

    print(res.body)

    if not res then
      return kong.response.exit(500, {message=err})
    end

    if res.status ~= 200 then
      return kong.response.exit(401, {message="Invalid authentication credentials"})
    end

    ngx.req.set_header('X-Forwarded-Erena-Credentials', res.body)
  end
end


return ExternalAuthHandler