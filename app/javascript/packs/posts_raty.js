document.addEventListener('turbolinks:load', function() {
  // クラス指定で要素を取得
  let elem = document.querySelector('.post_raty');
  if (elem) {
    let hiddenFieldId = elem.dataset.targetRating; // data-target-ratingの値を取得
    let hiddenField = document.getElementById(hiddenFieldId);

    raty(elem, {
      number: 5,
      path: '/assets/raty',
      score: hiddenField.value || 0,
      click: function(score) {
        hiddenField.value = score;
      },
      half: true,   // ★ これが必要
      hints: ['1','2','3','4','5']
    });
  }
});