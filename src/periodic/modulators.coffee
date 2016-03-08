# paper.js modulators
# these functions specify a way for a
# signal to modulate paper.js items

scaleBounds = (samplesPerPeriod, item, Signal, scaleRange) ->
  nextSignalValue = new Signal(samplesPerPeriod, 0, 0.5, 1.5)
  originalBounds = item.bounds
  () ->
    newBounds = originalBounds.scale nextSignalValue()
    item.bounds = newBounds

phaseSegments = (samplesPerPeriod, pathOrCompoundPath, Signal, swayDistance = 5) ->
  defineData = (segment, phaseOffset) ->
    segment.data ?= {}
    segment.data.signal ?= new Signal(samplesPerPeriod, phaseOffset)
    segment.data.originalPoint ?= segment.point.clone()
  swaySegment = (path, segment) ->
    offset = path.getOffsetOf segment.point
    defineData segment, offset
    normal = path.getNormalAt offset
    swayMagnitude = swayDistance * segment.data.signal()
    segment.point = segment.data.originalPoint.add normal.multiply swayMagnitude
  if pathOrCompoundPath instanceof paper.CompoundPath
    () ->
      pathOrCompoundPath.children.forEach (child) ->
        child.segments.forEach (segment) ->
          swaySegment child, segment
  else
    () ->
      pathOrCompoundPath.segments.forEach (segment) ->
        swaySegment pathOrCompoundPath, segment

 module.exports =
   scaleBounds: scaleBounds
   phaseSegments: phaseSegments
