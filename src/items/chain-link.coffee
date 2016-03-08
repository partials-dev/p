_ = require 'lodash'

ChainLink = (center = view.center, radius = 100, width = 100) ->
  path = new Path.Circle(center, radius)
  path.visible = false
  segments = path.segments

  # duplicate top segment
  path.insert(1, segments[1].clone())

  # duplicate bottom segment
  path.insert(4, segments[4].clone())

  # stretch circle into chain link
  # move top, right, and bottom segments
  [2, 3, 4].forEach (i) ->
    segment = segments[i]
    segment.point = segment.point.add [width, 0]

  this.getPointAt = (offset) ->
    x = offset * path.length
    path.getPointAt(x)

  this.path = path

  view.update()
  this

window.ChainLink = ChainLink
module.exports = ChainLink
