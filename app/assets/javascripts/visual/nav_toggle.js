$(document).ready(function(e){
  $('li.tab').click(function(e){
    $(this).siblings().removeClass('is-active');
    $(this).addClass('is-active');
  });
});
