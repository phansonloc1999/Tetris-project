---@class Player
Player = Class {}

PLAYZONE_WIDTH, PLAYZONE_HEIGHT = 210, 390
PREVIEW_FRAME_WIDTH, PREVIEW_FRAME_HEIGHT = 120, 120
CLEARED_BLOCK_SCORE = 10
BLOCK_MATRIX_ROW, BLOCK_MATRIX_COLUMN = (PLAYZONE_HEIGHT + 120) / BLOCK_HEIGHT, PLAYZONE_WIDTH / BLOCK_WIDTH
BLOCK_SCORE = 10

function Player:init(playzoneX, playzoneY)
    --- Constants
    self._PLAYZONE_X, self._PLAYZONE_Y = playzoneX, playzoneY
    self._PREVIEW_FRAME_X, self._PREVIEW_FRAME_Y = self._PLAYZONE_X + PLAYZONE_WIDTH + 50, self._PLAYZONE_Y

    self._blocks = {} ---@type Block[][]
    for row = 1, BLOCK_MATRIX_ROW do
        self._blocks[row] = {}
        for column = 1, BLOCK_MATRIX_COLUMN do
            self._blocks[row][column] = nil
        end
    end

    self._activeTetromino = self:getNewTetromino() ---@type Tetromino
    self._activeTetromino:toSpawn(self._PLAYZONE_X, self._PLAYZONE_Y)
    self._activeTetromino:getIndividualBlocks()
    self:updateActiveBlocksInMatrix()
    self._nextTetromino = self:getNewTetromino()
    self._nextTetromino:toPreview(self._PREVIEW_FRAME_X, self._PREVIEW_FRAME_Y)

    self._score = 0
end

function Player:render()
    for row = 1, BLOCK_MATRIX_ROW do
        for column = 1, BLOCK_MATRIX_COLUMN do
            if (self._blocks[row][column]) then
                self._blocks[row][column]:render()
            end
        end
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
    if (self._activeTetromino:isStopped()) then
        self:rowClearanceUpdate()

        self._nextTetromino:toSpawn(self._PLAYZONE_X, self._PLAYZONE_Y)
        self._activeTetromino = self._nextTetromino
        self._activeTetromino:getIndividualBlocks()
        self:updateActiveBlocksInMatrix()
        self._nextTetromino = self:getNewTetromino()
        self._nextTetromino:toPreview(self._PREVIEW_FRAME_X, self._PREVIEW_FRAME_Y)
    end

    if (TETROMINO_FALL_TIMER > 0) then
        TETROMINO_FALL_TIMER = math.max(0, TETROMINO_FALL_TIMER - dt)
    else
        self:activeTetroFallUpdate()
        TETROMINO_FALL_TIMER = 1
        self:checkActiveForObstruction()
    end

    self:tetrominoMovementUpdate(dt)

    if (self._activeTetromino:reachedBottom(self._PLAYZONE_Y)) then
        self._activeTetromino:stop()
        return
    end
end

function Player:tetrominoMovementUpdate(dt)
    if (love.keyboard.wasPressed("space")) then
        self:removeActiveBlocksInMatrix()
        self._activeTetromino:rotateNext()
        self._activeTetromino:getIndividualBlocks()

        if (self:verifyMovement() == "invalid") then
            self._activeTetromino:rotatePrev()
            self._activeTetromino:getIndividualBlocks()
        end
        self:updateActiveBlocksInMatrix()
        self:checkActiveForObstruction()
    end
    if (love.keyboard.wasPressed("left")) then
        self:removeActiveBlocksInMatrix()
        self._activeTetromino:moveLeft()
        self._activeTetromino:getIndividualBlocks()

        if (self:verifyMovement() == "invalid") then
            self._activeTetromino:moveRight()
            self._activeTetromino:getIndividualBlocks()
        end
        self:updateActiveBlocksInMatrix()
        self:checkActiveForObstruction()
    elseif (love.keyboard.wasPressed("right")) then
        self:removeActiveBlocksInMatrix()
        self._activeTetromino:moveRight()
        self._activeTetromino:getIndividualBlocks()

        if (self:verifyMovement() == "invalid") then
            self._activeTetromino:moveLeft()
            self._activeTetromino:getIndividualBlocks()
        end
        self:updateActiveBlocksInMatrix()
        self:checkActiveForObstruction()
    end

    if (love.keyboard.isDown("down")) then
        self._activeTetromino:accelerate(dt)
    end
end

function Player:verifyMovement()
    local currentBlock  ---@type Block
    local row, column
    for i = 1, #self._activeTetromino._def do
        for j = 1, #self._activeTetromino._def[i] do
            if (self._activeTetromino._blocks[i][j]) then
                currentBlock = self._activeTetromino._blocks[i][j]
                if
                    (currentBlock._pos._x < self._PLAYZONE_X or
                        currentBlock._pos._x > self._PLAYZONE_X + PLAYZONE_WIDTH - BLOCK_WIDTH)
                 then
                    return "invalid"
                end
                row, column = currentBlock:getPosInMatrix(self._PLAYZONE_X, self._PLAYZONE_Y)
                if (self._blocks[row][column]) then
                    return "invalid"
                end
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

function Player:activeTetroFallUpdate()
    self:removeActiveBlocksInMatrix()
    self._activeTetromino:fall()
    self:updateActiveBlocksInMatrix()
end

function Player:updateActiveBlocksInMatrix()
    for i = 1, #self._activeTetromino._def do
        for j = 1, #self._activeTetromino._def[i] do
            if (self._activeTetromino._blocks[i][j]) then
                local row, column =
                    self._activeTetromino._blocks[i][j]:getPosInMatrix(self._PLAYZONE_X, self._PLAYZONE_Y)
                self._blocks[row][column] = self._activeTetromino._blocks[i][j]
            end
        end
    end
end

function Player:removeActiveBlocksInMatrix()
    for i = 1, #self._activeTetromino._def do
        for j = 1, #self._activeTetromino._def[i] do
            if (self._activeTetromino._blocks[i][j]) then
                local row, column =
                    self._activeTetromino._blocks[i][j]:getPosInMatrix(self._PLAYZONE_X, self._PLAYZONE_Y)
                self._blocks[row][column] = nil
            end
        end
    end
end

function Player:rowClearanceUpdate()
    local rowsNewlyFilled = {}
    for i = 1, #self._activeTetromino._def do
        for j = 1, #self._activeTetromino._def[i] do
            if (self._activeTetromino._blocks[i][j]) then
                local row = self._activeTetromino._blocks[i][j]:getRowInMatrix(self._PLAYZONE_Y)
                table.insert(rowsNewlyFilled, row)
                break
            end
        end
    end
    local clearedRows = {}
    if (#rowsNewlyFilled > 0) then
        clearedRows = self:clearCompletedRows(rowsNewlyFilled)
    end
    for i = 1, #clearedRows do
        for row = clearedRows[i] - 1, 1, -1 do
            for column = 1, BLOCK_MATRIX_COLUMN do
                if (self._blocks[row][column]) then
                    self._blocks[row][column]:fall()
                    local newRow, newColumn =
                        self._blocks[row][column]:getPosInMatrix(self._PLAYZONE_X, self._PLAYZONE_Y)
                    self._blocks[newRow][newColumn] = self._blocks[row][column]
                    self._blocks[row][column] = nil
                end
            end
        end
    end
end

function Player:clearCompletedRows(rows)
    local clearedRows = {}
    for i = 1, #rows do
        local blocksCounter = 0
        for j = 1, BLOCK_MATRIX_COLUMN do
            if (self._blocks[rows[i]][j]) then
                blocksCounter = blocksCounter + 1
            end
        end
        if (blocksCounter == BLOCK_MATRIX_COLUMN) then
            table.insert(clearedRows, rows[i])
            for j = 1, BLOCK_MATRIX_COLUMN do
                self._blocks[rows[i]][j] = nil
            end
            self._score = self._score + BLOCK_SCORE * BLOCK_MATRIX_COLUMN
        end
    end
    return clearedRows
end

function Player:checkActiveForObstruction()
    --- If activeTetromino is obstructed, stop it
    for i = 1, #self._activeTetromino._def do
        for j = 1, #self._activeTetromino._def[i] do
            if (self._activeTetromino._blocks[i][j]) then
                local row, column =
                    self._activeTetromino._blocks[i][j]:getPosInMatrix(self._PLAYZONE_X, self._PLAYZONE_Y)
                if (row < BLOCK_MATRIX_ROW) then
                    if (self._blocks[row + 1][column]) then
                        if
                            (self._activeTetromino._blocks[i][j]:isObstructedBy(self._blocks[row + 1][column]) and
                                self._activeTetromino ~= self._blocks[row + 1][column]._parentTetromino)
                         then
                            self._activeTetromino:stop()
                            return
                        end
                    end
                end
            end
        end
    end
end
