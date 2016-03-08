signals = require './signal'
modulators = require './modulators'
helper = require '../helper'

scheduleMotion = (motion, signal) ->
  startPeriodicMotion = (seconds, item, updatesPerSecond = 30, otherArguments...) ->
    samplesPerPeriod = seconds * updatesPerSecond
    move = motion(samplesPerPeriod, item, signal, otherArguments...)
    update = () ->
      move()
    helper.schedule updatesPerSecond, item.id, update
  startPeriodicMotion

module.exports =
  unschedule: helper.unschedule
  pulse: scheduleMotion modulators.scaleBounds, signals.SawIntegral
  sway: scheduleMotion modulators.phaseSegments, signals.Sine
