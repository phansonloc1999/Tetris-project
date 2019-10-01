---@class Tetromino
Tetromino = Class {}

TETROMINO_FALL_DISTANCE = BLOCK_HEIGHT
TETROMINO_FALL_TIMER = 1
TETROMINO_ACCELARATE_SPEED = 4

function Tetromino:init(x, y, type, animal)
    self._pos = Vector2(x, y)
    self._isStopped = false

    self._type = type
    self._currentRotation = 1
    self._def = TETROMINO_DEFS[self._type][self._currentRotation]
    self._blocks = {} ---@type Block[][]

    self._isDissolved = false
    self._accelerateTimer = TETROMINO_FALL_TIMER

    self._animal = animal
end

function Tetromino:render()
    for row = 1, #self._def do
        for column = 1, #self._def[1] do
            if (self._blocks[row][column]) then
                self._blocks[row][column]:render()
            end
        end
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

    for i = 1, #self._def do
        for j = 1, #self._def[i] do
            if (self._blocks[i][j]) then
                self._blocks[i][j]:fall()
            end
        end
    end
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

    for i = 1, #self._def do
        for j = 1, #self._def[i] do
            if (self._blocks[i][j]) then
                self._blocks[i][j]._pos._x = self._blocks[i][j]._pos._x - BLOCK_WIDTH
            end
        end
    end
end

function Tetromino:moveRight()
    self._pos._x = self._pos._x + BLOCK_WIDTH

    for i = 1, #self._def do
        for j = 1, #self._def[i] do
            if (self._blocks[i][j]) then
                self._blocks[i][j]._pos._x = self._blocks[i][j]._pos._x + BLOCK_WIDTH
            end
        end
    end
end

function Tetromino:accelerate(dt)
    self._accelerateTimer = self._accelerateTimer - TETROMINO_ACCELARATE_SPEED * dt
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
    self._blocks = {}

    local currentDef = (TETROMINO_DEFS[self._type])[self._currentRotation]
    for i = 1, #currentDef do
        self._blocks[i] = {}
        for j = 1, #currentDef[1] do
            self._blocks[i][j] = nil
        end
    end

    for row = 1, #currentDef do
        for column = 1, #currentDef[1] do
            if (currentDef[row][column] == 1) then
                self._blocks[row][column] =
                    Block(
                    self._pos._x + (column - 1) * BLOCK_WIDTH,
                    self._pos._y + (row - 1) * BLOCK_HEIGHT,
                    self,
                    (gTextures.blocks[self._animal])[self._type]
                )
            end
        end
    end
    return self._blocks
end

function Tetromino:getWidth()
    return BLOCK_WIDTH * #self._def[1]
end

function Tetromino:getHeight()
    return BLOCK_HEIGHT * #self._def
end

function Tetromino:toSpawn(PLAYZONE_X, PLAYZONE_Y)
    self._pos._x, self._pos._y = PLAYZONE_X + BLOCK_WIDTH, PLAYZONE_Y - (BLOCK_HEIGHT * 4)
end

function Tetromino:toPreview(PREVIEW_FRAME_X, PREVIEW_FRAME_Y)
    self._pos._x, self._pos._y =
        PREVIEW_FRAME_X + PREVIEW_FRAME_WIDTH / 2 - TETROMINO_DEFS[self._type].widthInPreview / 2,
        PREVIEW_FRAME_Y + PREVIEW_FRAME_HEIGHT / 2 - TETROMINO_DEFS[self._type].heightInPreview / 2
end
