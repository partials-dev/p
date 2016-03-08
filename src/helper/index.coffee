intervalIds = {}

unschedule = (key) ->
  clearInterval(id) for id in intervalIds[key] if intervalIds[key]?

schedule = (updatesPerSecond, key, func) ->
  millisecondsBetweenUpdates = 1000 / updatesPerSecond
  intervalIds[key] ?= []
  intervalIds[key].push setInterval func, millisecondsBetweenUpdates

scheduleOnce = (updatesPerSecond, key) ->
  unless intervalIds[key]
    schedule arguments...

module.exports =
  schedule: schedule
  scheduleOnce: scheduleOnce
  unschedule: unschedule
