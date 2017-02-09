/*global $*/

$(document).on('turbolinks:load', function(){
  $('.alert').delay(1000).fadeOut(4000);
  
  $('.banner').unslider({
    speed: 500,               //  The speed to animate each slide (in milliseconds)
    delay: 5000,              //  The delay between slide animations (in milliseconds)
    complete: function() {},  //  A function that gets called after every slide animation
    keys: true,               //  Enable keyboard (left, right) arrow shortcuts
    dots: true,               //  Display dot navigation
    fluid: false,            //  Support responsive design. May break non-responsive designs
    autoplay: true
  });            

});
