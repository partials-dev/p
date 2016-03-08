helper = require '../helper'
DrunkenWalk = require('../periodic/mth').DrunkenWalk
Feather = require '../items/feather'

itemCache = []
currentItems = []

randomOffset = new DrunkenWalk startingValue: 10, noiseAmplitude: 50, clamp: {min: -50, max: 50}
randomDeltaAngle = new DrunkenWalk startingValue: 5 , noiseAmplitude: 10, clamp: {min: 5, max: 20}

buildCache = () ->
  makeItem = (angle) ->
    ItemConstructor = Feather

    center = new paper.Point 0, 0
      
    offset = new paper.Point(
      length: randomOffset.next()
      angle: angle
    )
    speed = Math.random() * 50
    speed = Math.max(speed, 20)
    velocity = new paper.Point(
      length: speed
      angle: angle
    )

    drunkenCenter = center.add offset

    item = new ItemConstructor(drunkenCenter, angle)
    item.item.data.offset = offset
    item.item.data.velocity = velocity
    itemCache.unshift item
    item.item.visible = false

  angle = 0
  while angle < (360 * 15)
    angle += randomDeltaAngle.next()
    makeItem(angle)

getItem = (center) ->
  item = itemCache.pop()
  if item?
    item.item.position = center.add item.item.data.offset
    currentItems.unshift item
    item.item.visible = true

destroy = (item) ->
  index = currentItems.indexOf(item)
  currentItems.splice(index, 1)
  itemCache.unshift item
  item.item.visible = false

explode = (center, ItemConstructor) ->
  move = (item) ->
    return unless item?
    item.item.translate(item.item.data.velocity)
    unless view.bounds.intersects(item.item.bounds)
      destroy item

  moveItems = () ->
    move(item) for item in currentItems
  
  n = 0
  while n < 50
    getItem(center)
    n += 1
  helper.scheduleOnce 30, 'feathers', moveItems

module.exports =
  explode: explode
  buildCache: buildCache
