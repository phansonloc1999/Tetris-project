---@class Block
Block = Class {}

BLOCK_WIDTH, BLOCK_HEIGHT = 38, 38

function Block:init(x, y, parentTetromino, texture)
    self._pos = Vector2(x, y)
    self._parentTetromino = parentTetromino ---@type Tetromino
    self._opacity = 1
    self._texture = texture
end

function Block:render()
    love.graphics.setColor(1, 1, 1, self._opacity)
    love.graphics.draw(self._texture, self._pos._x, self._pos._y)
end

function Block:fall()
    self._pos._y = self._pos._y + BLOCK_HEIGHT
end

function Block:isOutsidePlayzone()
    if (self._pos._x < 0 or self._pos._x > PLAYZONE_WIDTH - BLOCK_WIDTH) then
        return true
    end
    return false
end

function Block:collides(other)
    if (self._pos._x == other._pos._x and self._pos._y == other._pos._y) then
        return true
    end
    return false
end

function Block:getPosInMatrix(PLAYZONE_X, PLAYZONE_Y)
    return self:getRowInMatrix(PLAYZONE_Y), (self._pos._x - PLAYZONE_X) / BLOCK_WIDTH + 1
end

function Block:getRowInMatrix(PLAYZONE_Y)
    return (self._pos._y - (PLAYZONE_Y - (BLOCK_HEIGHT) * 4)) / BLOCK_HEIGHT + 1
end

function Block:isObstructedBy(other)
    if (self._pos._x == other._pos._x and self._pos._y + BLOCK_HEIGHT == other._pos._y) then
        return true
    end
    return false
end
