import * as ScanditSDK from "scandit-sdk";

const results = document.getElementById('results');

// const displayData = (data) => {
//   console.log(data);

//   const beer = `<div>
//     <li>Name: ${data.name}</li>
//     <li>Short desc: ${data.short_desc}</li>
//     <li>Long desc: ${data.long_desc}</li>
//     <li>Alcool %: ${data.alc_percent}</li>
//     <li>UPC: ${data.upc}</li>
//     <li></li>
//   </div>`;
//   results.insertAdjacentHTML('afterbegin', beer);
// };

// const displayNewBeerForm = (data) => {
//   console.log(data);
// };

const callController = (scanResult) => {
  const code = scanResult.barcodes[0].data;
  const csrfToken = document.querySelector("[name='csrf-token']").content;

  const url = window.location.href;
  const localhostRegex = /localhost/;
  const herokuRegex = /hopscan/;
  let fetchUrl;

  if (localhostRegex.test(url)) {
    fetchUrl = 'http://localhost:3000/beers/fetch_barcode';
  } else if (herokuRegex.test(url)) {
    fetchUrl = 'https://hopscan.herokuapp.com/beers/fetch_barcode';
  }
  
  fetch(fetchUrl,{
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'X-CSRF-Token': csrfToken
    },
    credentials: 'same-origin',
    body: JSON.stringify({ upc: code })
  })
    .then(response => response.json())
    .then((data) => {
      if (data.id) {
        if (localhostRegex.test(url)) {
          window.location.assign(`http://localhost:3000/beers/${data.id}`)
        } else if (herokuRegex.test(url)) {
          window.location.assign(`https://hopscan.herokuapp.com/beers/${data.id}`)
        }
      } else {
        if (localhostRegex.test(url)) {
          // window.location.assign(`http://localhost:3000/beers/new/${data.upc}`)
          window.location.assign(`http://localhost:3000/temp_beers/new/${data.upc}`)
        } else if (herokuRegex.test(url)) {
          // window.location.assign(`https://hopscan.herokuapp.com/beers/new/${data.upc}`)
          window.location.assign(`https://hopscan.herokuapp.com/temp_beers/new/${data.upc}`)
        }
      }
    });
};

const scanditTest = () => {
  const barcodeElement = document.getElementById("scandit-barcode-picker");

  if (barcodeElement) {
    ScanditSDK.configure(barcodeElement.dataset.scanditkey, {
      engineLocation: "https://cdn.jsdelivr.net/npm/scandit-sdk/build",
    })

      .then(() => {
        
        // ScanditSDK.BarcodePicker.create(barcodeElement), {
        ScanditSDK.BarcodePicker.create(document.getElementById("scandit-barcode-picker"), {
          playSoundOnScan: true,
          // vibrateOnScan: true,
        })

        .then(function (barcodePicker) {
        
          var scanSettings = new ScanditSDK.ScanSettings({
            enabledSymbologies: ["ean8", "ean13", "upca", "upce", "code128", "code39", "code93", "itf"],
            codeDuplicateFilter: 1000
          });

          barcodePicker.applyScanSettings(scanSettings);

          barcodePicker.on("scan", function (scanResult) {
            callController(scanResult);
            barcodePicker.destroy();
          })

          // alert(
          //   scanResult.barcodes.reduce(function (string, barcode) {
          //     return string + ScanditSDK.Barcode.Symbology.toHumanizedName(barcode.symbology) + ": " + barcode.data + "\n";
          //   }, "")
          // );

        })
      });
  // if closing
  }

};

export { scanditTest };

