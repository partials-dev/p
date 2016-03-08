_ = require 'lodash'

stepSize = 1 / 4
pointOnCircle = _.curry (center, offset) ->
  angle = offset * 360
  new paper.Point(angle: angle, length: 50).add center

# draws a closed figure that connects random points on originalPath
IrregularPolygon = (center, originalPath) ->
  offset = 0

  path = new Path()
  addSide = () ->
    return true if path.closed
    next = originalPath.getPointAt(offset)
    if offset > 1
      path.closed = true
    else
      path.add next
    offset += Math.random() * stepSize
    view.update()
    path.closed
  complete = () ->
    completed = false
    while(!completed)
      completed = addSide()
  addSide()
  this.addSide = addSide
  this.complete = complete
  this.path = path
  this

module.exports = IrregularPolygon
