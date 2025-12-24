import Quagga from './quagga.min.js';

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

function initQuagga(){
  if ($('#barcode-scanner').length > 0 && navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function') {

    var last_result = [];

// console.log(Quagga.initialized == undefined);
// console.log(navigator.mediaDevices);
// console.log(last_code);
// console.log(Quagga.initialized);

    // if (Quagga.initialized == undefined) {
    //   Quagga.onDetected(function(result) {
    //     var last_code = result.codeResult.code;
    //     last_result.push(last_code);
    //     if (last_result.length > 20) {
    //       code = order_by_occurrence(last_result)[0];
    //       last_result = [];
    //       Quagga.stop();
          
    //       $.ajax({
    //         type: "POST",
    //         url: '/beers/fetch_barcode',
    //         data: { upc: code }
    //       });
    //     }
    //   });
    // }

    Quagga.init({
      inputStream : {
        name : "Live",
        type : "LiveStream",
        numOfWorkers: navigator.hardwareConcurrency,
        target: document.querySelector('#barcode-scanner'),
        frequency: 10,
        locate: true 
      },
      decoder: {
        readers : [
          {
            format: "ean_reader",
            config: { supplements: ['ean_5_reader', 'ean_2_reader'] }
          },
          'ean_reader','ean_8_reader','code_39_reader','code_39_vin_reader','codabar_reader','upc_reader','upc_e_reader'],
        debug: {
            drawBoundingBox: true,
            showFrequency: true,
            drawScanline: true,
            showPattern: true
        },
        locator: {
          halfSample: true,
            patchSize: "medium", // x-small, small, medium, large, x-large
            debug: {
              showCanvas: false,
              showPatches: false,
              showFoundPatches: false,
              showSkeleton: false,
              showLabels: false,
              showPatchLabels: false,
              showRemainingPatchLabels: false,
              boxFromPatches: {
                showTransformed: false,
                showTransformedBox: false,
                showBB: false
              }
            }
        },
        multiple: false
      }
    },function(err) {
        if (err) { console.log(err); return }
        Quagga.initialized = true;
        Quagga.start();

    });

    Quagga.onDetected(function(data) { 
      var lastCode = data.codeResult.code;
      console.log(lastCode)
      Quagga.stop();

      const csrfToken = document.querySelector("[name='csrf-token']").content;

      fetch('http://localhost:3000//beers/fetch_barcode',{
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': csrfToken
        },
        credentials: 'same-origin',
        body: JSON.stringify({ upc: lastCode })
      })
        .then(response => response.json())
        .then(data => console.log(data))
      
      // $.ajax({
      //   type: "POST",
      //   url: '/beers/fetch_barcode',
      //   data: { upc: lastCode }
      // });
    });

  }
};

export { initQuagga };























// const initQuagga = () => {
//   // loadQuagga();

//   Quagga.init({
//       inputStream : {
//         name : "Live",
//         type : "LiveStream",
//         numOfWorkers: navigator.hardwareConcurrency,
//         target: document.querySelector('#barcode-scanner')
//       },
//       decoder : {
//         readers : ['ean_reader','ean_8_reader','code_39_reader','code_39_vin_reader','codabar_reader','upc_reader','upc_e_reader']
//       }
//     }, function(err) {
//         if (err) { console.log(err); return }
//         console.log("Initialization finished. Ready to start");
//         Quagga.initialized = true;
//         Quagga.start();
//     });
// };
