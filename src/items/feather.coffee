Feather = (center, angle) ->

  item = new paper.Path.Ellipse(
    center: center
    radius: [9, 4]
    fillColor: 'black'
  )
  
  item.rotation = angle
  # item.selected = true
  
  offset = item.length / 2
  tangent = item.getTangentAt(offset).multiply(10)
  tangent = tangent.rotate -90, item.segments[2]
  item.segments[2].point = item.segments[2].point.add(tangent)

  @item = item
  this

module.exports = Feather
