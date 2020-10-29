$(function () {
  $('#search-form').on('submit', function (e) {
    e.stopPropagation()

    window.location.href = $(e.target).attr('action') + '#' + $(e.target).serialize()

    return false
  })
})
