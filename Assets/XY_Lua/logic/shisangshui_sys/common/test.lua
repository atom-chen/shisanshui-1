require "debug_e"
require "extern"
local user = require "user"
log(vardump(user.getname()))
user.setname("ttt")
log(vardump(user.getname()))

local user2 = require "user"
log(vardump(user))


other = { foo = 3 }
t1 = setmetatable({}, { __index = other })
t1.foo = 2
t2 = setmetatable({}, { __index = other })
t2.foo = 2
log(vardump(t2.foo))
other.foo = 3
log(vardump(t2.foo))

local Player = require "player"
log(vardump(Player))
Player:Login()
log(Player:GetName())
log(vardump(Player:getname()))
