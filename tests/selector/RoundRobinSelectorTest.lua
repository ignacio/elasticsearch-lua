-- Importing modules
local roundRobinSelector = require "selector.RoundRobinSelector"
local connection = require "connection.Connection"
local Logger = require "Logger"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.selector.RoundRobinSelectorTest"

-- Declaring local variables
local rRS
local connections

-- Testing the constructor
function constructorTest()
  assert_function(roundRobinSelector.new)
  local o = roundRobinSelector:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_function(mt.selectNext)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  connections = {}
  local logger = Logger:new()
  logger:setLogLevel("off")
  for i = 1, 5 do
    connections[i] = connection:new{
      protocol = "http",
      host = "localhost",
      port = 9200,
      pingTimeout = 1,
      logger = logger
    }
    -- For checking later on
    connections[i].id = i
  end
  rRS = roundRobinSelector:new()
end

-- Testing select function
function selectNextTest()
  for i = 1, 10 do
    local con = rRS:selectNext(connections)
    local j = i
    if j > 5 then
      j = j - 5
    end
    if con.id ~= j then
      assert_false(true, "RoundRobinSelector test fail")
    end
  end
  assert_true(true)
end
