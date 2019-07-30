---@class Player
Player = Class {}

PLAYZONE_WIDTH, PLAYZONE_HEIGHT = 210, 390
PREVIEW_FRAME_WIDTH, PREVIEW_FRAME_HEIGHT = 120, 120
CLEARED_BLOCK_SCORE = 10

function Player:init(playzoneX, playzoneY)
    --- Constants
    self._PLAYZONE_X, self._PLAYZONE_Y = playzoneX, playzoneY
    self._PREVIEW_FRAME_X, self._PREVIEW_FRAME_Y = self._PLAYZONE_X + PLAYZONE_WIDTH + 50, self._PLAYZONE_Y

    self._activeTetromino = self:getNewTetromino() ---@type Tetromino
    self._activeTetromino:toSpawn(self._PLAYZONE_X, self._PLAYZONE_Y)
    self._nextTetromino = self:getNewTetromino()
    self._nextTetromino:toPreview(self._PREVIEW_FRAME_X, self._PREVIEW_FRAME_Y)

    self._inactiveTetrominoes = {} ---@type Tetromino[]
    self._inactiveBlocks = {} ---@type Block[]

    self._score = 0
end

function Player:render()
    self._activeTetromino:render()

    for i = 1, #self._inactiveTetrominoes do
        self._inactiveTetrominoes[i]:render()
    end

    love.graphics.rectangle("line", self._PLAYZONE_X, self._PLAYZONE_Y, PLAYZONE_WIDTH, PLAYZONE_HEIGHT)

    love.graphics.rectangle(
        "line",
        self._PREVIEW_FRAME_X,
        self._PREVIEW_FRAME_Y,
        PREVIEW_FRAME_WIDTH,
        PREVIEW_FRAME_HEIGHT
    )
    self._nextTetromino:render()

    love.graphics.print(
        "Score: " .. self._score,
        self._PREVIEW_FRAME_X,
        self._PREVIEW_FRAME_Y + PREVIEW_FRAME_HEIGHT + 50
    )
end

function Player:update(dt)
    for i = 1, #self._inactiveBlocks do
        if (self._inactiveBlocks[i]._pos._y < 0) then
            love.event.quit()
        end
    end

    if (self._activeTetromino:isStopped()) then
        self._nextTetromino:toSpawn(self._PLAYZONE_X, self._PLAYZONE_Y)
        self._activeTetromino = self._nextTetromino
        self._nextTetromino = self:getNewTetromino()
        self._nextTetromino:toPreview(self._PREVIEW_FRAME_X, self._PREVIEW_FRAME_Y)
    end

    self:tetrominoMovementUpdate(dt)

    self._activeTetromino:update(dt)
end

function Player:tetrominoMovementUpdate(dt)
    if (love.keyboard.wasPressed("space")) then
        self._activeTetromino:rotateNext()

        if (self:verifyMovement() == "invalid") then
            self._activeTetromino:rotatePrev()
        end
    end
    if (love.keyboard.wasPressed("left")) then
        self._activeTetromino:moveLeft()

        if (self:verifyMovement() == "invalid") then
            self._activeTetromino:moveRight()
        end
    elseif (love.keyboard.wasPressed("right")) then
        self._activeTetromino:moveRight()

        if (self:verifyMovement() == "invalid") then
            self._activeTetromino:moveLeft()
        end
    end

    if (love.keyboard.isDown("down")) then
        self._activeTetromino:accelerate(dt)
    end
end

function Player:verifyMovement(movement)
    local activeBlocks = self._activeTetromino:getIndividualBlocks()
    for i = 1, #activeBlocks do
        if (activeBlocks[i]:isOutsidePlayzone()) then
            return "invalid"
        end
        for j = 1, #self._inactiveBlocks do
            if (activeBlocks[i]:collides(self._inactiveBlocks[j])) then
                return "invalid"
            end
        end
    end
    return "valid"
end

function Player:getNewTetromino()
    local shapes = {}
    for shape, def in pairs(TETROMINO_DEFS) do
        table.insert(shapes, shape)
    end
    local index = math.random(1, #shapes)
    return Tetromino(0, 0, shapes[index])
end