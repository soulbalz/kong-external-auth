package = "kong-plugin-external-auth"

version = "1.0.0"

source = {
  url = "https://github.com/soulbalz/kong-external-auth",
  tag = "1.0.0"
}


description = {
  summary = "Kong plugin to authenticate requests using http services.",
  license = "MIT",
  homepage = "https://github.com/soulbalz/kong-external-auth",
  detailed = [[
      Kong plugin to authenticate requests using http services.
  ]]
}

dependencies = {
  "lua >= 5.1"
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.external-auth.handler"] = "kong/plugins/external-auth/handler.lua",
    ["kong.plugins.external-auth.schema"] = "kong/plugins/external-auth/schema.lua",
  }
}
