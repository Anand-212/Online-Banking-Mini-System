/**
 * EASYBANK ONLINE BANKING - JAVASCRIPT APP UTILITIES
 */

document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  initFormValidations();
});

// Theme Management
function initTheme() {
  const themeToggleBtn = document.getElementById('themeToggleBtn');
  const storedTheme = localStorage.getItem('apex_theme') || 'dark';

  document.documentElement.setAttribute('data-theme', storedTheme);
  updateThemeIcon(storedTheme);

  if (themeToggleBtn) {
    themeToggleBtn.addEventListener('click', () => {
      const currentTheme = document.documentElement.getAttribute('data-theme');
      const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', newTheme);
      localStorage.setItem('apex_theme', newTheme);
      updateThemeIcon(newTheme);
    });
  }
}

function updateThemeIcon(theme) {
  const themeIcon = document.getElementById('themeIcon');
  if (themeIcon) {
    themeIcon.className = theme === 'dark' ? 'ri-sun-line' : 'ri-moon-line';
  }
}

// Live Password Strength Meter
function checkPasswordStrength(password) {
  let score = 0;
  if (password.length >= 8) score++;
  if (/[A-Z]/.test(password)) score++;
  if (/[0-9]/.test(password)) score++;
  if (/[@#$%^&+=!]/.test(password)) score++;

  return score;
}

function initFormValidations() {
  const passInput = document.getElementById('passwordInput');
  const strengthMeter = document.getElementById('passwordStrengthMeter');

  if (passInput && strengthMeter) {
    passInput.addEventListener('input', (e) => {
      const score = checkPasswordStrength(e.target.value);
      const labels = ['Weak', 'Fair', 'Good', 'Strong'];
      const colors = ['#ef4444', '#f59e0b', '#3b82f6', '#10b981'];

      strengthMeter.textContent = e.target.value ? `Strength: ${labels[score - 1] || 'Weak'}` : '';
      strengthMeter.style.color = colors[score - 1] || '#ef4444';
    });
  }
}

// Financial Calculators
function calculateEMI() {
  const principal = parseFloat(document.getElementById('loanAmount').value);
  const annualRate = parseFloat(document.getElementById('interestRate').value);
  const tenureYears = parseFloat(document.getElementById('tenureYears').value);

  if (!principal || !annualRate || !tenureYears) {
    alert("Please fill in all fields.");
    return;
  }

  const monthlyRate = annualRate / 12 / 100;
  const tenureMonths = tenureYears * 12;

  const emi = (principal * monthlyRate * Math.pow(1 + monthlyRate, tenureMonths)) / (Math.pow(1 + monthlyRate, tenureMonths) - 1);
  const totalPayment = emi * tenureMonths;
  const totalInterest = totalPayment - principal;

  document.getElementById('monthlyEmiResult').textContent = "Rs. " + emi.toFixed(2);
  document.getElementById('totalInterestResult').textContent = "Rs. " + totalInterest.toFixed(2);
  document.getElementById('totalPaymentResult').textContent = "Rs. " + totalPayment.toFixed(2);
}

function convertCurrency() {
  const amount = parseFloat(document.getElementById('currAmount').value);
  const from = document.getElementById('fromCurr').value;
  const to = document.getElementById('toCurr').value;

  const rates = {
    USD: 1.0,
    EUR: 0.92,
    GBP: 0.78,
    INR: 83.20,
    JPY: 155.40
  };

  if (!amount) return;

  const inUSD = amount / rates[from];
  const converted = inUSD * rates[to];

  document.getElementById('currResult').textContent = `${amount} ${from} = ${converted.toFixed(2)} ${to}`;
}

// Toast Notification
function showToast(message, type = 'info') {
  const container = document.getElementById('toastContainer') || createToastContainer();
  const toast = document.createElement('div');
  toast.className = `alert alert-${type === 'error' ? 'danger' : 'success'}`;
  toast.style.boxShadow = '0 4px 12px rgba(0,0,0,0.3)';
  toast.innerHTML = `<span>${message}</span>`;

  container.appendChild(toast);
  setTimeout(() => toast.remove(), 4000);
}

function createToastContainer() {
  const div = document.createElement('div');
  div.id = 'toastContainer';
  div.style.position = 'fixed';
  div.style.top = '20px';
  div.style.right = '20px';
  div.style.zIndex = '9999';
  document.body.appendChild(div);
  return div;
}
