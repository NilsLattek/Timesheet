$ ->
  unsavedData = false

  $('.other-planned-hours').tooltip({ html: true, placement: 'bottom' })

  $('#month-select').on 'change', (e) ->
    if unsavedData && confirm("You have unsaved data, do you want to leave this page and discard your changes?")
      window.location = e.currentTarget.value

  $("input[name*='project[planned_hours]']").on 'focus', (e) ->
    $(e.currentTarget).data('last-value', e.currentTarget.value)

  $("input[name*='project[planned_hours]']").on 'keyup', (e) ->
    oldHours = parseFloat($(e.currentTarget).data('last-value')) || 0
    newHours = parseFloat(e.currentTarget.value) || 0
    if (oldHours != newHours)
      unsavedData = true

      span = $("span[name='" + e.currentTarget.name + "_utilization']")
      oldPlannedHours = parseFloat(span.data('plannedHours'))
      newPlannedHours = oldPlannedHours - oldHours + newHours
      newPlannedHours = Math.round(newPlannedHours * 100) / 100

      span.data 'plannedHours', newPlannedHours
      span.html newPlannedHours

      $('#planned-total').html( parseFloat($('#planned-total').html()) + newPlannedHours - oldPlannedHours)
      $(e.currentTarget).data('last-value', e.currentTarget.value)