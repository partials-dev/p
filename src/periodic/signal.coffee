mth = require './mth'

# Signal functions are defined on the domain [0, 1).
# They don't have to be periodic. makeSignalConstructor
# uses the modulo function to *make* them periodic.

saw = (x) ->
  numerator = 2 * x
  numerator - 1

sawIntegral = (x) ->
  numerator = x - 1
  8 * x * (x - 1) + 1

sine = (x) ->
  Math.sin(2 * Math.PI * x)

movingAverage = (memorySize, func) ->
  movingWindow = new mth.MovingWindow(memorySize)
  (args...) ->
    result = func args...
    movingWindow.push result
    movingWindow.average()

CreepySaw = (memorySize) ->
  # Construct a function that returns the average
  # of the most recent values of saw.
  # This is filters out higher frequencies.
  # In theory. Seems to be doing something...
  # weirder right now.
  filtered = movingAverage memorySize, saw
  (x) -> filtered x

# Use signal functions above
# to define constructors for periodic
# signal generators.
makeSignalConstructor = (signal) ->
  SignalConstructor = (period, phaseOffset = 0, signalMin = -1, signalMax = 1) ->
    x = phaseOffset
    incrementAmount = 1 / period
    getNextX = () ->
      result = x % 1
      x += incrementAmount
      result
    # map x to new the range [signalMin, signalMax]
    mapOutput = mth.mapRange(-1, 1, signalMin, signalMax)

    next = () ->
      result = signal getNextX()
      # signal functions have a default output range of [-1, 1]
      if signalMin is -1 and signalMax is 1
        result
      else
        result = mapOutput result
      result
    next
  SignalConstructor

module.exports =
  Sine: makeSignalConstructor sine
  Saw: makeSignalConstructor saw
  SawIntegral: makeSignalConstructor sawIntegral
  CreepySaw: makeSignalConstructor new CreepySaw(15)
