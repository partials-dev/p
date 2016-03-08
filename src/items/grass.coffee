Grass = (bottom, height) ->
  radius = 5
  sharpness = 0.8

  bottomLeft = bottom.subtract [radius, 0]
  topLeft = bottomLeft.subtract [0, height * sharpness]

  bottomRight = bottom.add [radius, 0]
  topRight = bottomRight.subtract [0, height * sharpness]

  top = bottom.subtract [0, height]

  #right side of blade
  leftPath = new Path()
  leftPath.strokeColor = 'darkgreen'
  #leftPath.fillColor = 'darkgreen'
  leftPath.strokeWidth = 1
  leftPath.closed = true

  leftPath.add(bottomLeft)
  leftPath.add(topLeft)
  leftPath.add(top)
  leftPath.add(bottom)
  #leftPath.fullySelected = true
  leftPath.segments[2].handleIn = leftPath.segments[2].handleIn.add(-radius, radius)

  #left side of blade
  rightPath = new Path()
  rightPath.strokeColor = 'darkgreen'
  #rightPath.fillColor = 'green'
  rightPath.strokeWidth = 1
  rightPath.closed = true

  rightPath.add(bottomRight)
  rightPath.add(topRight)
  rightPath.add(top)
  rightPath.add(bottom)
  rightPath.segments[2].handleIn = rightPath.segments[2].handleIn.add(radius, radius)

  #blade = new Group([leftPath, rightPath])
  blade = new paper.CompoundPath(children: [leftPath, rightPath])

  isBlowing = false
  rotateIntervalId = null

  wind = () ->
    isBlowing = true
    rotate = () -> blade.rotate(5, bottom)
    rotateIntervalId = setInterval(rotate, 20)

  stopWind = () ->
    isBlowing = false
    clearInterval(rotateIntervalId)


  shrink = (amount) -> #
    shrinkSegment = (amount) ->
      for path in blade.children
        path.segments[1].point.y += amount
        path.segments[2].point.y += amount

    if amount > 0 # shrinking; makes sure the shoulder of the blade doesn't go below the bottom
      if blade.children[0].segments[1].point.y < blade.children[0].segments[0].point.y - amount
        shrinkSegment(amount)
    else # Growing
      shrinkSegment(amount)

  # Public Interface
  this.blade = blade
  this.wind = wind
  this.stopWind = stopWind
  this.shrink = shrink


#########################
  view.update()
  this

module.exports = Grass
