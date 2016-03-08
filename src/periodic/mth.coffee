_ = require 'lodash'

MovingWindow = (memorySize) ->
  contents = []
  this.push = (sample) ->
    length = contents.unshift sample
    while length > memorySize
      contents.pop()
      length = contents.length
  this.average = () ->
    _.sum(contents) / contents.length
  this

mapRange = _.curry (oldMin, oldMax, newMin, newMax, input) ->
  oldRange = oldMax - oldMin
  newRange = newMax - newMin
  (((input - oldMin) * newRange) / oldRange) + newMin

regularDistribution = (options) ->
  { samples, min, max, inclusive } = options
  inclusive = true if not inclusive?
  width = max - min

  addValue = (i) ->
    min + (width * (i / samples))
  range = if inclusive then [0..samples] else [1...samples]
  range.map addValue

random = (min, max) ->
  dist = max - min
  min + (Math.random() * dist)

clamp = (n, min, max) ->
  n = Math.max(n, min) if min?
  n = Math.min(n, max) if max?
  n

DrunkenWalk = (options) ->
  { startingValue, noiseAmplitude, clamp: { min, max } } = options
  noiseMax = noiseAmplitude / 2
  noiseMin = -noiseMax
  @previousValue = startingValue
  next: () =>
    currentValue = @previousValue + random noiseMin, noiseMax
    currentValue = clamp currentValue, min, max
    @previousValue = currentValue
    currentValue

line = (p1, p2) ->
  slope = (p2.y - p1.y) / (p2.x - p1.x)
  (x) -> slope * (x - p1.x) + p1.y

mix = (a, b, proportion) ->
  inverseProportion = 1 - proportion
  (a * proportion) + (b * inverseProportion)

module.exports =
  MovingWindow: MovingWindow
  mapRange: mapRange
  mix: mix
  line: line
  DrunkenWalk: DrunkenWalk
  clamp: clamp
  random: random
  regularDistribution: regularDistribution
