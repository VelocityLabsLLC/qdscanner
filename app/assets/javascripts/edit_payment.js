/* global $, Stripe */
//Document ready.
$(document).on('turbolinks:load', function(){
  $('#payment-add-btn').click(function (){
    $('#payment-add-form').toggle();
  });
  
  // subscription_form identifies both premium and pro user forms
  var addCardForm = $('#add-card-form');
  
  var addCardBtn = $('#add-card-btn');
  //Set Stripe public key.
  Stripe.setPublishableKey( $('meta[name="stripe-key"]').attr('content') );
  //When user clicks form submit btn,
  addCardBtn.click(function(event){
    //prevent default submission behavior.
    event.preventDefault();
    addCardBtn.val("Processing").prop('disabled', true);
    //Collect the credit card fields.
    var ccNum = $('#card_number').val(),
        cvcNum = $('#card_code').val(),
        expMonth = $('#card_month').val(),
        expYear = $('#card_year').val();
    //Use Stripe JS library to check for card errors.
    var error = false;
    //Validate card number.
    if(!Stripe.card.validateCardNumber(ccNum)) {
      error = true;
      alert('The credit card number appears to be invalid');
    }
    //Validate CVC number.
    if(!Stripe.card.validateCVC(cvcNum)) {
      error = true;
      alert('The CVC number appears to be invalid');
    }
    //Validate expiration date.
    if(!Stripe.card.validateExpiry(expMonth, expYear)) {
      error = true;
      alert('The expiration date appears to be invalid');
    }
    if (error) {
      //If there are card errors, don't send to Stripe.
      addCardBtn.prop('disabled', false).val("Add and Use Card");
    } else {
      //Send the card info to Stripe.
      Stripe.createToken({
        number: ccNum,
        cvc: cvcNum,
        exp_month: expMonth,
        exp_year: expYear
      }, stripeResponseHandler);
    }
    return false;
  });
  //Stripe will return a card token.
  function stripeResponseHandler(status, response) {
    //Get the token from the response.
    var token = response.id;
    //Inject the card token in a hidden field.
    addCardForm.append( $('<input type="hidden" name="user[stripe_card_token]">').val(token) );
    //Submit form to our Rails app.
    addCardForm.get(0).submit();
  }
  
  var useExistingCardForm = $('#use-existing-card-form');
  
  var useExistingCardBtn = $('#use-existing-card-btn');
  
  useExistingCardBtn.click(function(event){
    //prevent default submission behavior.
    event.preventDefault();
    useExistingCardBtn.val("Processing").prop('disabled', true);
    useExistingCardForm.append( $('<input type="hidden" name="user[stripe_card_token]">').val("none") );
    useExistingCardForm.get(0).submit();
  });
});