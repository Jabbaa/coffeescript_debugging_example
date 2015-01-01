###
#       Copyright (C) 2014 Andre Leifeld - jabbaa.com
#       Author: Andre Leifeld
#       Website: http://wwww.jabbaaa.com
###

class Cat
    constructor: (@name) ->
    doMeow: ->
        console.debug "#{@name}: Meow meow meow"
    doPlay: (toy) ->
        console.debug "#{@name} is playing with a #{toy}"

cat = new Cat("Felix")
cat.doMeow()
cat.doPlay('ball of wool')