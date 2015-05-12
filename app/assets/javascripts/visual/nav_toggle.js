$(document).always(function(){
  $('li.tab').each(function(){
    $(this).find('a').click(function(){
      $(this).closest('li.tab').siblings().removeClass('is-active');
      $(this).closest('li.tab').addClass('is-active');
    });
  });
});
