-- Importing modules
local stickyRoundRobinSelector = require "selector.StickyRoundRobinSelector"
local connection = require "connection.Connection"
local Logger = require "Logger"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.selector.StickyRoundRobinSelectorTest"

-- Declaring local variables
local sRRS
local connections

-- Testing the constructor
function constructorTest()
  assert_function(stickyRoundRobinSelector.new)
  local o = stickyRoundRobinSelector:new()
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
    connections[i]:markAlive()
  end
  sRRS = stickyRoundRobinSelector:new()
end

-- Testing select function
function selectNextTest()
  local con
  for i = 1, 3 do
    con = sRRS:selectNext(connections)
    if con.id ~= 1 then
      assert_false(true, "Next connection returned instead of the earlier one")
    end
  end
  -- Making the connection dead
  con:markDead()
  con = sRRS:selectNext(connections)
  if con.id == 1 then
    assert_false(true, "Connection still returned after it died")
  end
  assert_true(true)
end
