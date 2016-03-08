oscillate = require('./effects/motion').oscillate
helper = require('./helper')
mth = require('./periodic/mth')
Sine = require('./periodic/signal').Sine

# Set up paper.js
paper.install window
paper.setup 'canv'

project.currentStyle.strokeColor = 'black'
project.currentStyle.strokeWidth = 0.5
FRAME_RATE = 60

#oscLine = (left, right, period = 90, circleRadius = 5) ->
  #center = left.add x: (right.x - left.x) / 2, y: 0
  #circle = new Shape.Circle center, circleRadius
  #width = right.subtract left
  #axis = new paper.Point width, 0
  #oscillator = oscillate circle, axis, period
  #helper.schedule 60, 'oscLine', oscillator

clippingGroup = new Group()
oscLine = (left, right, period = 90) ->
  width = right.subtract(left).x
  thickness = 9
  line = new Shape.Rectangle left, new paper.Size(width, thickness)
  line.fillColor = 'black'
  clippingGroup.addChild line
  next = new Sine(period, 0, 0.1, 1)
  oscillate = ->
    nextWidth = next() * width
    line.bounds.width = nextWidth
  helper.schedule FRAME_RATE, 'oscLine', oscillate

hill = (x, y, deltaY, widths) ->
  getPeriod = (i) ->
    p = FRAME_RATE * (60 / (65 + i))
    p *= 2
    # transpose period up 8 octaves
    #p *= 1 / Math.pow(2, 8) unless slow
    p
  widths.forEach (width, i) ->
    left = new paper.Point x: x, y: y + (i * deltaY)
    right = left.add [width, 0]
    period = getPeriod i
    oscLine left, right, period

#background = new Shape.Rectangle [0, 0], view.bounds.width, view.bounds.height
#background.fillColor = 'red'
background = new Raster source: 'background'
background.bounds = new Rectangle(view.center, view.center.add([100, 150]))
console.log "Position: #{background.position}"
displayGroup = new Group(clippingGroup, background)
displayGroup.clipped = true

#
# p hole
#
pWidths = []

# top of p
ys = mth.regularDistribution samples: 10, min: -1, max: 1, inclusive: false
ys.forEach (y) ->
  x = Math.sqrt 1 - (y ** 2)
  x *= 40
  pWidths.push x

# bottom of p
pWidths.push 12 for n in [0..5]

pWidths = pWidths.map (n) -> n * 2
hill view.center.x, view.center.y, 10, pWidths

pHoleCenter = view.center.add x: 30, y: 39.9
pHoleRadius = 19.9
circlePoints = [
  pHoleCenter.add(x: 0, y: pHoleRadius),
  pHoleCenter.add(x: pHoleRadius, y: 0),
  pHoleCenter.add(x:0, y: -pHoleRadius)
]
pHole = new Path.Arc(
  from: circlePoints[0],
  through: circlePoints[1],
  to: circlePoints[2]
)
pHole.insert 0, circlePoints[0].add [-10, 0]
pHole.add circlePoints[2].add [-10, 0]
pHole.fillColor = 'white'
pHole.strokeColor = 'white'
pHole.closed = true
#pHole.strokeColor = 'white'
#pHole.fullySelected = true
#pHole.segments[1].selected = true
#pHole.removeSegment(0)

i = 0
view.onFrame = () ->
  skip = (i % 2) is 0
  i += 1
  return if skip
  view.update()
