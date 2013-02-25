# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

calculateHoursWorked = (startTime, endTime, lunchBreak) ->
  if (isNaN(startTime) || isNaN(endTime) || isNaN(lunchBreak))
    return 0

  minutesWorked = (endTime - startTime) / 1000 / 60 - lunchBreak
  hoursWorked = minutesWorked / 60
  Math.round(hoursWorked * 100) / 100

parseDate = (day, time) ->
  dayArr = day.split('-')
  timeArr = time.split(':')
  new Date(dayArr[0], dayArr[1]-1, dayArr[2], timeArr[0], timeArr[1], 0);

showHoursWorked = ->
  day = $('#timesheet_date').val()
  startTime = parseDate(day, $('#timesheet_start_time').val())
  endTime = parseDate(day, $('#timesheet_end_time').val())
  lunchBreak = $('#timesheet_lunch_break').val()

  hoursWorked = calculateHoursWorked(startTime, endTime, lunchBreak)
  $('#hours_worked').html hoursWorked

$(document).on 'change', '#timesheet_start_time, #timesheet_end_time, #timesheet_lunch_break', (event) ->
  showHoursWorked()
