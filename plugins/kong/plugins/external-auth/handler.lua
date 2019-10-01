local BasePlugin = require "kong.plugins.base_plugin"

local ExternalAuthHandler = BasePlugin:extend()

local http = require "resty.http"
local kong = kong

ExternalAuthHandler.VERSION = "1.0.0"
ExternalAuthHandler.PRIORITY = 900

function ExternalAuthHandler:new()
  ExternalAuthHandler.super.new(self, "external-auth")
end

function ExternalAuthHandler:access(conf)
  ExternalAuthHandler.super.access(self)

  local client = http.new()
  client:set_timeouts(conf.connect_timeout, send_timeout, read_timeout)

  local res, err = client:request_uri(conf.auth_service_url, {
    method = "GET",
    path = conf.path,
    headers = kong.request.get_headers(),
  })

  if not res then
    return kong.response.exit(500, {message=err})
  end

  if res.status ~= 200 then
    return kong.response.exit(401, {message="Invalid authentication credentials"})
  end
end


return ExternalAuthHandler