---@class Tetromino
Tetromino = Class {}

TETROMINO_FALL_DISTANCE = BLOCK_HEIGHT
TETROMINO_FALL_TIMER = 1
TETROMINO_ACCELARATE_SPEED = 4

function Tetromino:init(x, y, type)
    self._pos = Vector2(x, y)
    self._isStopped = false

    self._type = type
    self._currentRotation = 1
    self._def = TETROMINO_DEFS[self._type][self._currentRotation]

    self._isDissolved = false
end

function Tetromino:render()
    love.graphics.setColor(0, 1, 0)
    for row = 1, #self._def do
        for column = 1, #self._def[1] do
            if (self._def[row][column] == 1) then
                love.graphics.rectangle(
                    "fill",
                    self._pos._x + (column - 1) * BLOCK_WIDTH,
                    self._pos._y + (row - 1) * BLOCK_HEIGHT,
                    BLOCK_HEIGHT,
                    BLOCK_HEIGHT
                )
            end
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function Tetromino:update(dt)
    if (TETROMINO_FALL_TIMER > 0) then
        TETROMINO_FALL_TIMER = math.max(0, TETROMINO_FALL_TIMER - dt)
    else
        self:fall()
        TETROMINO_FALL_TIMER = 1
    end
end

function Tetromino:isStopped()
    return self._isStopped
end

function Tetromino:stop()
    self._isStopped = true
end

function Tetromino:fall()
    self._pos._y = math.min(self._pos._y + TETROMINO_FALL_DISTANCE, WINDOW_HEIGHT - BLOCK_HEIGHT)
end

function Tetromino:reachedBottom(PLAYZONE_Y)
    for row = #self._def, 1, -1 do
        for column = 1, #self._def[1] do
            if (self._def[row][column] == 1) then
                if (self._pos._y + (row - 1) * BLOCK_HEIGHT >= PLAYZONE_Y + PLAYZONE_HEIGHT - BLOCK_HEIGHT) then
                    return true
                end
            end
        end
    end
    return false
end

function Tetromino:rotateNext()
    self._currentRotation = self._currentRotation + 1
    if (self._currentRotation > #TETROMINO_DEFS[self._type]) then
        self._currentRotation = 1
    end
    self._def = TETROMINO_DEFS[self._type][self._currentRotation]
end

function Tetromino:rotatePrev()
    self._currentRotation = self._currentRotation - 1
    if (self._currentRotation < 1) then
        self._currentRotation = #TETROMINO_DEFS[self._type]
    end
    self._def = TETROMINO_DEFS[self._type][self._currentRotation]
end

function Tetromino:moveLeft()
    self._pos._x = self._pos._x - BLOCK_WIDTH
end

function Tetromino:moveRight()
    self._pos._x = self._pos._x + BLOCK_WIDTH
end

function Tetromino:accelerate(dt)
    TETROMINO_FALL_TIMER = TETROMINO_FALL_TIMER - TETROMINO_ACCELARATE_SPEED * dt
end

---@param block Block
function Tetromino:isObstructedBy(block)
    for row = 1, #self._def do
        for column = 1, #self._def[1] do
            if (self._def[row][column] == 1) then
                if
                    (self._pos._x + (column - 1) * BLOCK_WIDTH == block._pos._x and
                        self._pos._y + (row - 1) * BLOCK_HEIGHT + BLOCK_HEIGHT == block._pos._y)
                 then
                    return true
                end
            end
        end
    end
    return false
end

function Tetromino:getIndividualBlocks()
    local currentDef = (TETROMINO_DEFS[self._type])[self._currentRotation]
    local Blocks = {}
    for row = 1, #currentDef do
        for column = 1, #currentDef[1] do
            if (currentDef[row][column] == 1) then
                table.insert(
                    Blocks,
                    Block(self._pos._x + (column - 1) * BLOCK_WIDTH, self._pos._y + (row - 1) * BLOCK_HEIGHT, self)
                )
            end
        end
    end
    return Blocks
end

function Tetromino:getWidth()
    return BLOCK_WIDTH * #self._def[1]
end

function Tetromino:getHeight()
    return BLOCK_HEIGHT * #self._def
end

function Tetromino:toSpawn(PLAYZONE_X, PLAYZONE_Y)
    self._pos._x, self._pos._y = PLAYZONE_X + 30, PLAYZONE_Y - self:getHeight()
end

function Tetromino:toPreview(PREVIEW_FRAME_X, PREVIEW_FRAME_Y)
    self._pos._x, self._pos._y =
        PREVIEW_FRAME_X + PREVIEW_FRAME_WIDTH / 2 - TETROMINO_DEFS[self._type].widthInPreview / 2,
        PREVIEW_FRAME_Y + PREVIEW_FRAME_HEIGHT / 2 - TETROMINO_DEFS[self._type].heightInPreview / 2
end
