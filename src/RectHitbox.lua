---@class  RectHitbox
RectHitbox = Class {}

local DEBUG_RENDERING = true

function RectHitbox:init(x, y, width, height)
    self._pos = Vector2(x, y, 0, 0)
    self._width, self._height = width, height
end

function RectHitbox:render()
    if (DEBUG_RENDERING) then
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", self._pos._x, self._pos._y, self._width, self._height)
        love.graphics.setLineWidth(1)
    end
end

function RectHitbox:collides(other)
    return self._pos._x < other._pos._x + other._width and other._pos._x < self._pos._x + self._width and
        self._pos._y < other._pos._y + other._height and
        other._pos._y < self._pos._y + self._height
end
