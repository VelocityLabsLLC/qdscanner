/*global $, navigator, Quagga*/
function order_by_occurrence(arr) {
  var counts = {};
  arr.forEach(function(value){
      if(!counts[value]) {
          counts[value] = 0;
      }
      counts[value]++;
  });

  return Object.keys(counts).sort(function(curKey,nextKey) {
      return counts[curKey] < counts[nextKey];
  });
}

function load_quagga(){
  if ($('#barcode-scanner').length > 0 && navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function') {

    var last_result = [];
    if (Quagga.initialized == undefined) {
      Quagga.onDetected(function(result) {
        var last_code = result.codeResult.code;
        last_result.push(last_code);
        if (last_result.length > 20) {
          code = order_by_occurrence(last_result)[0];
          last_result = [];
          Quagga.stop();
          $("#cage_number").val(code);
          // $.ajax({
          //   type: "POST",
          //   url: '/animals/get_barcode',
          //   data: { upc: code }
          // });
        }
      });
    }

    Quagga.init({
      inputStream : {
        name : "Live",
        type : "LiveStream",
        numOfWorkers: navigator.hardwareConcurrency,
        target: document.querySelector('#barcode-scanner')  
      },
      decoder: {
          readers : ['code_128_reader']
      }
    },function(err) {
        if (err) { console.log(err); return }
        Quagga.initialized = true;
        Quagga.start();
    });

  }
};
$(document).on('turbolinks:load', load_quagga);

// $(document).on('turbolinks:load', function() {
//   var Quagga = window.Quagga;
//   var App = {
//       _scanner: null,
//       init: function() {
//           this.attachListeners();
//       },
//       activateScanner: function() {
//           var scanner = this.configureScanner('.overlay__content'),
//               onDetected = function (result) {
//                   document.querySelector('input.isbn').value = result.codeResult.code;
//                   stop();
//               }.bind(this),
//               stop = function() {
//                   scanner.stop();  // should also clear all event-listeners?
//                   scanner.removeEventListener('detected', onDetected);
//                   this.hideOverlay();
//                   this.attachListeners();
//               }.bind(this);
  
//           this.showOverlay(stop);
//           scanner.addEventListener('detected', onDetected).start();
//       },
//       attachListeners: function() {
//           var self = this,
//               button = $('#button-scan');
          
//           button.click(function(event){
//             //prevent default submission behavior.
//             console.log('button pressed--------------------------');
//             event.preventDefault();
//             self.activateScanner();
//           });
//           // button.on("click", function (e) {
//           //     e.preventDefault();
//           //     button.off("click", button);
//           //     self.activateScanner();
//           // });
//       },
//       showOverlay: function(cancelCb) {
//           if (!this._overlay) {
//               var content = document.createElement('div'),
//                   closeButton = document.createElement('div');
  
//               closeButton.appendChild(document.createTextNode('X'));
//               content.className = 'overlay__content';
//               closeButton.className = 'overlay__close';
//               this._overlay = document.createElement('div');
//               this._overlay.className = 'overlay';
//               this._overlay.appendChild(content);
//               content.appendChild(closeButton);
//               closeButton.addEventListener('click', function closeClick() {
//                   closeButton.removeEventListener('click', closeClick);
//                   cancelCb();
//               });
//               document.body.appendChild(this._overlay);
//           } else {
//               var closeButton = document.querySelector('.overlay__close');
//               closeButton.addEventListener('click', function closeClick() {
//                   closeButton.removeEventListener('click', closeClick);
//                   cancelCb();
//               });
//           }
//           this._overlay.style.display = "block";
//       },
//       hideOverlay: function() {
//           if (this._overlay) {
//               this._overlay.style.display = "none";
//           }
//       },
//       configureScanner: function(selector) {
//           if (!this._scanner) {
//               this._scanner = Quagga
//                   .decoder({readers: ['ean_reader']})
//                   .locator({patchSize: 'medium'})
//                   .fromSource({
//                       target: selector,
//                       constraints: {
//                           width: 800,
//                           height: 600,
//                           facingMode: "environment"
//                       }
//                   });
//           }
//           return this._scanner;
//       }
//   };
//   App.init();
// });