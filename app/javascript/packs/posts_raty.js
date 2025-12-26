document.addEventListener('turbolinks:load', function () {
  let elem = document.querySelector('.post_raty')
  if (!elem) return

  let hiddenFieldId = elem.dataset.targetRating
  let hiddenField = document.getElementById(hiddenFieldId)

  let starOn = elem.dataset.ratyStarOn
  let starOff = elem.dataset.ratyStarOff
  let starHalf = elem.dataset.ratyStarHalf

  raty(elem, {
    number: 5,
    score: hiddenField.value || 0,
    starOn: starOn,
    starOff: starOff,
    starHalf: starHalf,
    half: true,
    hints: ['1', '2', '3', '4', '5'],

    click: function (score) {
      hiddenField.value = score
    }
  })
})
