# make table rows which have a link specified clickable
$(document).on 'click', 'table tr[data-link]', (row) ->
  link = $(row.currentTarget).data('link')
  location.href = link if link