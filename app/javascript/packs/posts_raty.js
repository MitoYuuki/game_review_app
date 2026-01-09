document.addEventListener('turbolinks:load', function () {
  const elems = document.querySelectorAll('.post_raty')

  elems.forEach(function(elem){
    let hiddenFieldId = elem.dataset.targetRating
    let hiddenField = hiddenFieldId ? document.getElementById(hiddenFieldId) : null

    raty(elem, {
      number: 5,
      readOnly: elem.dataset.readOnly === 'true',   // ←★ここで固定！
      score: hiddenField ? hiddenField.value || 0 : elem.dataset.score,
      starOn: elem.dataset.ratyStarOn,
      starOff: elem.dataset.ratyStarOff,
      starHalf: elem.dataset.ratyStarHalf,
      half: true,

      click: function (score) {
        if (hiddenField) hiddenField.value = score   // 編集のみ反映
      }
    })
  })
})
