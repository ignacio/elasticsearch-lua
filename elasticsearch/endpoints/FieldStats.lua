-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local FieldStats = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
FieldStats.allowedParams = {
  "fields",
  "level",
  "ignore_unavailable",
  "allow_no_indices",
  "expand_wildcards"
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function FieldStats:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function FieldStats:getUri()
  local uri = "/_field_stats"
  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of FieldStats class
-------------------------------------------------------------------------------
function FieldStats:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return FieldStats
