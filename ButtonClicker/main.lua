-- Create
function love.load()
  -- game.state [1 => menu, 2 => gameplay, 3 => gameover]
  game = {}
  game.state = 1
  game.windowTitle = "Button Clicker !"
  game.title = "Button Clicker ! Click to start !"
  game.font = love.graphics.newFont(50)
  game.score = 0
  game.timeLeft = 30

  -- button = circle to click on
  button = {}
  button.x = love.graphics.getWidth() / 2
  button.y = love.graphics.getHeight() / 2
  button.size = 50

  love.window.setTitle(game.windowTitle)
end

-- Step
function love.update(dt)
  if (game.state == 2) then
    if(game.timeLeft > 0) then
      game.timeLeft = game.timeLeft - dt
    end
    if(game.timeLeft < 0) then
      game.timeLeft = 0
      game.state = 1
      game.score = 0
      game.timeLeft = 30
    end
  end
end

-- Draw
function love.draw()
  love.graphics.setFont(game.font) -- font size
  love.graphics.setColor(1, 1, 1) -- white
  if (game.state == 2) then
    love.graphics.print("Score : " .. game.score)
    -- +50 is an arbitrary margin
    love.graphics.print("Time Left : " .. math.ceil(game.timeLeft), love.graphics.getWidth() / 2 + 50, 0)
    -- love.graphics.rectangle(mode, x, y, width, height)
    love.graphics.setColor(0, 0, 255, 1)
    love.graphics.circle('fill', button.x, button.y, button.size)
  elseif (game.state == 1) then
    -- love.graphics.printf(text, x, y, limit, align)
    love.graphics.printf(game.title, 0, love.graphics.getHeight() / 2, love.graphics.getWidth() ,"center")
  end
end

-- event
function love.mousepressed(x, y, mouseLeftButton, isTouch)
  if(mouseLeftButton == 1 and game.state == 2) then
    if distanceBetweenPoint(button.x, button.y, love.mouse.getX(), love.mouse.getY()) <= button.size then
      game.score = game.score + 1
      randomNewSpawn()
    elseif distanceBetweenPoint(button.x, button.y, love.mouse.getX(), love.mouse.getY()) > button.size then
      game.score = game.score - 1
      randomNewSpawn()
    end
  end

  if (game.state == 1) then
    game.state = 2
  end
end

-- other functions
function distanceBetweenPoint(x1, y1, x2, y2)
  -- return lenght distanceBetween 2 point
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

function randomNewSpawn()
  button.x = math.random(0, love.graphics.getWidth() - button.size)
  button.y = math.random(0, love.graphics.getHeight() - button.size)
end
