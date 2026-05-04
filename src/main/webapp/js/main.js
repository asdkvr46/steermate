// SteerMate — Main JS (minimal, no frameworks)

// Fare preview calculator on the Book Driver page
function updateFarePreview(distanceKm) {
  var dist = parseFloat(distanceKm) || 0;
  if (dist <= 0) {
    document.getElementById('farePreview').style.display = 'none';
    return;
  }
  var baseFee     = 150;
  var distanceFee = Math.round(dist * 40 * 100) / 100;
  var timeFee     = Math.round((dist / 30 * 60) * 5 * 100) / 100;
  var subtotal    = baseFee + distanceFee + timeFee;
  var platformFee = Math.round(subtotal * 0.15 * 100) / 100;
  var totalFare   = Math.round((subtotal + platformFee) * 100) / 100;

  function fmt(n) { return 'Rs. ' + n.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }

  document.getElementById('distFeeVal').textContent    = fmt(distanceFee);
  document.getElementById('timeFeeVal').textContent    = fmt(timeFee);
  document.getElementById('platformFeeVal').textContent = fmt(platformFee);
  document.getElementById('totalFareVal').textContent  = fmt(totalFare);
  document.getElementById('farePreview').style.display = 'block';
}

// Role toggle on register page (called from inline onchange)
function toggleDriverFields(show) {
  var el = document.getElementById('driverFields');
  if (el) el.style.display = show ? 'block' : 'none';
}

// Auto-select role radio visual
document.addEventListener('DOMContentLoaded', function () {
  var radios = document.querySelectorAll('input[name="role"]');
  radios.forEach(function (r) {
    r.addEventListener('change', function () {
      document.querySelectorAll('.role-option').forEach(function (opt) {
        opt.classList.remove('selected');
      });
      r.closest('.role-option').classList.add('selected');
    });
  });
});
