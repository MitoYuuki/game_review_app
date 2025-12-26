document.addEventListener('turbolinks:load', function () {
  let elem = document.querySelector('.post_raty')
  if (!elem) return

  let hiddenFieldId = elem.dataset.targetRating
  let hiddenField = document.getElementById(hiddenFieldId)

  raty(elem, {
    number: 5,
    score: hiddenField.value || 0,
    // ★ ここが超重要
    path: '/assets/raty',

    half: true,
    hints: ['1', '2', '3', '4', '5'],

    click: function (score) {
      hiddenField.value = score
    }
  })
})
