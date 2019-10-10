---@class Player
Player = Class {}

PLAYZONE_WIDTH, PLAYZONE_HEIGHT = 266, 456
PREVIEW_FRAME_WIDTH, PREVIEW_FRAME_HEIGHT = 152, 152
CLEARED_BLOCK_SCORE = 10
BLOCK_MATRIX_ROW, BLOCK_MATRIX_COLUMN =
    (PLAYZONE_HEIGHT + (BLOCK_HEIGHT) * 4) / BLOCK_HEIGHT,
    PLAYZONE_WIDTH / BLOCK_WIDTH
BLOCK_SCORE = 10

local BLOCK_FLASHING_FRAME_DURATION = 0.3

local GENERATED_TETROMINOES_HISTORY = {}

function Player:init(playzoneX, playzoneY, keyConfigs)
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

    self._curTetrominoHistoryIndex = 0
    self._activeTetromino = self:getNewTetromino() ---@type Tetromino
    self._activeTetromino:toSpawn(self._PLAYZONE_X, self._PLAYZONE_Y)
    self._activeTetromino:getIndividualBlocks()
    self:updateActiveBlocksInMatrix()
    self._nextTetromino = self:getNewTetromino()
    self._nextTetromino:toPreview(self._PREVIEW_FRAME_X, self._PREVIEW_FRAME_Y)
    self._nextTetromino:getIndividualBlocks()

    self._score = 0
    self._isRemovingBlocks = false

    self._scoreIncreaseEffects = {}

    self._stencilFunc = function()
        love.graphics.rectangle(
            "fill",
            self._PLAYZONE_X,
            self._PLAYZONE_Y - BLOCK_HEIGHT * 4,
            PLAYZONE_WIDTH,
            BLOCK_HEIGHT * 4
        )
    end

    self._keyConfigs = keyConfigs
end

function Player:render()
    love.graphics.draw(gTextures["screenplay-border"], self._PLAYZONE_X - 4, self._PLAYZONE_Y - 4)

    love.graphics.stencil(self._stencilFunc, "replace", 1)
    love.graphics.setStencilTest("less", 1)
    for row = 1, BLOCK_MATRIX_ROW do
        for column = 1, BLOCK_MATRIX_COLUMN do
            if (self._blocks[row][column]) then
                self._blocks[row][column]:render()
            end
        end
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.setStencilTest()

    love.graphics.draw(gTextures["preview-border"], self._PREVIEW_FRAME_X, self._PREVIEW_FRAME_Y)
    self._nextTetromino:render()

    love.graphics.print(
        "Score: " .. self._score,
        self._PREVIEW_FRAME_X,
        self._PREVIEW_FRAME_Y + PREVIEW_FRAME_HEIGHT + 50
    )

    for i = 1, #self._scoreIncreaseEffects do
        love.graphics.setColor(0, 1, 0, self._scoreIncreaseEffects[i].opacity)
        love.graphics.printf(
            "+ " .. BLOCK_SCORE * BLOCK_MATRIX_COLUMN,
            love.graphics.newFont(18),
            self._scoreIncreaseEffects[i].renderX,
            self._scoreIncreaseEffects[i].renderY,
            100
        )
    end
end

function Player:update(dt)
    if (self._activeTetromino:isStopped() and not self._isRemovingBlocks) then
        self:rowClearanceUpdate()

        if (not self._isRemovingBlocks) then
            self._nextTetromino:toSpawn(self._PLAYZONE_X, self._PLAYZONE_Y)
            self._activeTetromino = self._nextTetromino
            self._activeTetromino:getIndividualBlocks()
            self:updateActiveBlocksInMatrix()
            self._nextTetromino = self:getNewTetromino()
            self._nextTetromino:toPreview(self._PREVIEW_FRAME_X, self._PREVIEW_FRAME_Y)
            self._nextTetromino:getIndividualBlocks()
        end
    end

    if (not self._isRemovingBlocks) then
        if (self._activeTetromino._accelerateTimer > 0) then
            self._activeTetromino._accelerateTimer = math.max(0, self._activeTetromino._accelerateTimer - dt)
        else
            self:activeTetroFallUpdate()
            self._activeTetromino._accelerateTimer = 1
            self:checkActiveForObstruction()
        end

        self:tetrominoMovementUpdate(dt)

        if (self._activeTetromino:reachedBottom(self._PLAYZONE_Y)) then
            self._activeTetromino:stop()
            return
        end
    end
end

function Player:tetrominoMovementUpdate(dt)
    if (love.keyboard.wasPressed(self._keyConfigs.rotate)) then
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
    if (love.keyboard.wasPressed(self._keyConfigs.left)) then
        self:removeActiveBlocksInMatrix()
        self._activeTetromino:moveLeft()
        self._activeTetromino:getIndividualBlocks()

        if (self:verifyMovement() == "invalid") then
            self._activeTetromino:moveRight()
            self._activeTetromino:getIndividualBlocks()
        end
        self:updateActiveBlocksInMatrix()
        self:checkActiveForObstruction()
    elseif (love.keyboard.wasPressed(self._keyConfigs.right)) then
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

    if (love.keyboard.isDown(self._keyConfigs.accelerate)) then
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
    if (self._curTetrominoHistoryIndex + 1 > #GENERATED_TETROMINOES_HISTORY) then
        local shapes = {}
        for shape, def in pairs(TETROMINO_DEFS) do
            table.insert(shapes, shape)
        end
        local index = math.random(1, #shapes)
        table.insert(GENERATED_TETROMINOES_HISTORY, shapes[index])
    end
    self._curTetrominoHistoryIndex = self._curTetrominoHistoryIndex + 1
    return Tetromino(0, 0, GENERATED_TETROMINOES_HISTORY[self._curTetrominoHistoryIndex], "cat")
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
    if (#rowsNewlyFilled > 0) then
        self._clearedRows = self:clearCompletedRows(rowsNewlyFilled)
    end
end

function Player:clearCompletedRows(rowsNewlyFilled)
    local clearedRows = {}
    local blocksPosToClear = {}
    local clearBlockDefinitions, visibleBlockDefinitions = {}, {}
    local clearOpacity, visibleOpacity = {_opacity = 0}, {_opacity = 1}
    for i = 1, #rowsNewlyFilled do
        local blocksCounter = 0
        for j = 1, BLOCK_MATRIX_COLUMN do
            if (self._blocks[rowsNewlyFilled[i]][j]) then
                blocksCounter = blocksCounter + 1
            end
        end
        if (blocksCounter == BLOCK_MATRIX_COLUMN) then
            for j = 1, BLOCK_MATRIX_COLUMN do
                local currentBlock = self._blocks[rowsNewlyFilled[i]][j] ---@type Block
                table.insert(blocksPosToClear, {rowsNewlyFilled[i], j})
                table.merge(clearBlockDefinitions, {[currentBlock] = clearOpacity})
                table.merge(visibleBlockDefinitions, {[currentBlock] = visibleOpacity})
            end

            self._isRemovingBlocks = true

            --- Tween opacity of cleared blocks, clear blocks in matrix and above blocks fall update
            Chain(
                function(go, visibleBlockDefinitions, clearBlockDefinitions, blocksPosToClear, player)
                    Timer.tween(BLOCK_FLASHING_FRAME_DURATION, clearBlockDefinitions):finish(
                        function()
                            go(visibleBlockDefinitions, clearBlockDefinitions, blocksPosToClear, player)
                        end
                    )
                end,
                function(go, visibleBlockDefinitions, clearBlockDefinitions, blocksPosToClear, player)
                    Timer.tween(BLOCK_FLASHING_FRAME_DURATION, visibleBlockDefinitions):finish(
                        function()
                            go(visibleBlockDefinitions, clearBlockDefinitions, blocksPosToClear, player)
                        end
                    )
                end,
                function(go, visibleBlockDefinitions, clearBlockDefinitions, blocksPosToClear, player)
                    Timer.tween(BLOCK_FLASHING_FRAME_DURATION, clearBlockDefinitions):finish(
                        function()
                            go(visibleBlockDefinitions, clearBlockDefinitions, blocksPosToClear, player)
                        end
                    )
                end,
                function(go, visibleBlockDefinitions, clearBlockDefinitions, blocksPosToClear, player)
                    if (#player._clearedRows > 0) then
                        local row, column
                        for i = 1, #blocksPosToClear do
                            row, column = blocksPosToClear[i][1], blocksPosToClear[i][2]
                            player._blocks[row][column] = nil
                        end
                        player:fallAfterClearance()
                        player._isRemovingBlocks = false
                    end
                end
            )(nil, visibleBlockDefinitions, clearBlockDefinitions, blocksPosToClear, self)

            table.insert(clearedRows, rowsNewlyFilled[i])

            Timer.after(
                BLOCK_FLASHING_FRAME_DURATION * 3 - 0.1,
                function()
                    table.insert(
                        self._scoreIncreaseEffects,
                        1,
                        {
                            renderX = self._blocks[rowsNewlyFilled[i]][1]._pos._x + math.random(20, 10),
                            renderY = self._blocks[rowsNewlyFilled[i]][1]._pos._y,
                            opacity = 1
                        }
                    )

                    love.audio.play(gSounds.scoring)

                    Timer.tween(
                        2,
                        {
                            [self._scoreIncreaseEffects[1]] = {
                                renderY = self._scoreIncreaseEffects[1].renderY - 100,
                                opacity = 0
                            }
                        }
                    ):finish(
                        function()
                            self._score = self._score + BLOCK_SCORE * BLOCK_MATRIX_COLUMN
                            table.remove(self._scoreIncreaseEffects, #self._scoreIncreaseEffects)
                        end
                    )
                end
            )
        end
    end
    return clearedRows
end

function Player:fallAfterClearance()
    for i = 1, #self._clearedRows do
        for row = self._clearedRows[i] - 1, 1, -1 do
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
    self._clearedRows = {}
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
