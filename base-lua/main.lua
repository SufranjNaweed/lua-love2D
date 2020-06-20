message = "yo man"
number = 1
nbPairs = 0

-- increaseNumber take a number, increase that number & count number of pairs
function increaseNumber(nb)
  while nb < 10 do
    nb = nb + 1
    if nb % 2 == 0 then
      nbPairs = nbPairs + 1
    end
  end
  return nb
end

number = increaseNumber(number)


myCharacter = {}
randomBuffer = nil
myCharacter.name = "Kraken"
myCharacter.age = 26
myCharacter.stats = {}
myCharacter.stats.strenght = 16

function love.draw()
  love.graphics.setFont(love.graphics.newFont(50))
  love.graphics.print(number, 100, 100)
  love.graphics.print(nbPairs, 100, 200)

  if (myCharacter.stats.strenght >= 16) then
    love.graphics.print("You can use the berserk sword")
  else
    love.graphics.print("You Fools ! You cannot use the berserk sword")
  end
end
