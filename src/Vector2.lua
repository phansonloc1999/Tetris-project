---@class Vector2
Vector2 = Class{}

function Vector2:init(x, y, dx, dy)
    self._x, self._y = x, y
    self._dx, self._dy = dx or 0, dy or 0
end

function Vector2:setPos(x, y)
    self._x, self._y = x, y
end

function Vector2:setVelocity(dx, dy)
    self._dx, self._dy = dx, dy
end

function Vector2:update(dt)
    if (self._dx ~= 0 or self._dy ~= 0) then
        self._x, self._y = self._x + self._dx * dt, self._y + self._dy * dt
    end
end