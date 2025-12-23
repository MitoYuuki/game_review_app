import starOn from '../images/raty/star-on.png'
import starOff from '../images/raty/star-off.png'
import starHalf from '../images/raty/star-half.png'

document.addEventListener('turbolinks:load', function () {
  let elem = document.querySelector('.post_raty')
  if (!elem) return

  let hiddenFieldId = elem.dataset.targetRating
  let hiddenField = document.getElementById(hiddenFieldId)

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
