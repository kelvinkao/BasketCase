var dbRef = new Firebase('https://basketcase-3897e.firebaseio.com');
var fieldGoalStatsRef = dbRef.child("fieldGoalStats")

fieldGoalStatsRef.on("value", function(snap) {

	// throw away time and aggregate dates
	var statsByDate = createStatsByDate(snap.val());

	// calculate accumulations
	var accumulationsByDate = createAccumulationsByDate(statsByDate);

	// html table
	var tableHTML = htmlFromStatsAndAccumulation(statsByDate, accumulationsByDate);
	document.getElementById('statsTable').innerHTML = tableHTML;
});

function createStatsByDate(stats) {
	var result = {};

	for (var datetime in stats) {
		var dateOnly = datetime.substring(0, 10);
  		
  		var subResult = result[dateOnly];
  		if (subResult == null) {
  			subResult = { "made": 0, "attempted": 0 };
  		}

  		subResult["made"] = subResult["made"] + stats[datetime]["made"];
  		subResult["attempted"] = subResult["attempted"] + stats[datetime]["attempted"];

  		result[dateOnly] = subResult;
	}

	return result;
}

function createAccumulationsByDate(statsByDate) {
	var result = {};

	var madeSoFar = 0;
	var attemptedSoFar = 0;

	for (var date in statsByDate) {
		madeSoFar += statsByDate[date]["made"];
		attemptedSoFar += statsByDate[date]["attempted"];
		var subResult = { "made": madeSoFar, "attempted": attemptedSoFar };
		result[date] = subResult;
	}

	return result;
}

function htmlFromStatsAndAccumulation(statsByDate, accumulationsByDate) {
	var result = "<table>\n";

	result += "<col span='1' class='wide'>"

	result += "<tr>"
	result += "<th>Date</th>";
	result += "<th>Made</th>";
	result += "<th>Attempted</th>";
	result += "<th>Percentage</th>";
	result += "<th>Made (accumulated)</th>";
	result += "<th>Attempted (accumulated)</th>";
	result += "<th>Percentage (accumulated)</th>";
	result += "</tr>\n"

	// date, made, attempted, percentage, accumulated made, accumulated attempted, accumulated percentage
	for (var date in statsByDate) {
		var line = "<tr>";
		line += "<td>" + date + "</td>";
		line += "<td>" + statsByDate[date]["made"] + "</td>";
		line += "<td>" + statsByDate[date]["attempted"] + "</td>";
		line += "<td>" + (statsByDate[date]["made"]/statsByDate[date]["attempted"]).toFixed(3) + "</td>";
		line += "<td>" + accumulationsByDate[date]["made"] + "</td>";
		line += "<td>" + accumulationsByDate[date]["attempted"] + "</td>";
		line += "<td>" + (accumulationsByDate[date]["made"]/accumulationsByDate[date]["attempted"]).toFixed(3) + "</td>";
		line += "</tr>\n";
		result += line;
	}

	result += "</table>\n";

	return result;
}


