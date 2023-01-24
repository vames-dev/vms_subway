var currentNumber = 0
var currentPrice = 0
var currentLabel = ''
var stationsItems;
var currentStation;
var intv = null;
var curTest = 30;

function switchStation(stNumber, stPrice, stName) {
	currentNumber = stNumber
	currentPrice = stPrice
	currentLabel = stName
	$("#currentStation").html(`${currentLabel}`)
	$("#currentPrice").html(`$${currentPrice}`)
}
$(document).ready(function() {
	window.addEventListener('message', function(event) {
		if (event.data.action == "open") {
			$(".metroPanel").fadeIn();
			currentStation = event.data.currentNumber
			for (const [key, value] of Object.entries(event.data.station)) {
				myElement = `
					<div class="stationBtn" onclick="switchStation(${value.stationNumber}, ${value.price}, \'${value.name}\')">
						<div class="ticketIcon">
							<i class="fas fa-ticket-alt"></i>
						</div>
						<div class="ticketDescription">
							<p class="stationBtnName">${value.stationNumber}. ${value.name}</p>
							<div class="oneLine">
								<p class="stationBtnPrice">`
					if (value.stationNumber == currentStation) {
						myElement = myElement + `<p class="priceBtn" style="margin-top: 5px;"><i class="fas fa-map-marker-alt"></i> Your current station</p>`
					} else {
						myElement = myElement + `Price: <p class="priceBtn">$${value.price}</p>`
					}
					myElement = myElement + `
								</div>
							</div>
						</div>
					</div>`
				$(".stationButtons").append(myElement)
			}
			$("#currentStation").html(`No Stop Selected`)
			$("#currentPrice").html(`$0`)
		} else if (event.data.action == "enter") {
			$(".timerPanel").fadeIn();
			if(intv) { clearInterval(intv);  }
           		intv = setInterval(() => {
           		    curTest = curTest - 1;
           		    $("#timer").html(`${curTest} seconds remaining...`);
           		}, 1000);
		} else if (event.data.action == "exit") {
			$(".timerPanel").fadeOut();
			clearInterval(intv)
			$.post('https://vms_subway/action', JSON.stringify({action: "close"}));
		}
	});

	document.onkeyup = function(data) {
		if (data.which == 27) {
			$(".metroPanel").fadeOut();
			$(".stationButtons").empty();
			$.post('https://vms_subway/action', JSON.stringify({action: "close"}));
		}
	};

	$(document).on('click', ".buyButton", function() {
		if (currentNumber != currentStation) {
			$(".metroPanel").fadeOut();
			$(".stationButtons").empty();
			$.post('https://vms_subway/action', JSON.stringify({action: "transport", station: currentNumber}));
		}
	});
});