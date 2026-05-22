// Cybersecurity Operations - Interactive Engine

document.addEventListener('DOMContentLoaded', () => {
  initNavbar();
  initTerminalSimulation();
  initThreatDashboard();
  initCipherSandbox();
  initThreatMap();
  initContactForm();
});

/* ==========================================
   1. Navbar & Navigation Interactivity
   ========================================== */
function initNavbar() {
  const header = document.querySelector('header');
  const menuToggle = document.getElementById('menu-toggle');
  const navMenu = document.querySelector('nav');
  const navLinks = document.querySelectorAll('.nav-link');
  
  // Header background transition on scroll
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
    highlightNavLink();
  });
  
  // Mobile menu toggle
  if (menuToggle && navMenu) {
    menuToggle.addEventListener('click', () => {
      navMenu.classList.toggle('active');
      const isExpanded = navMenu.classList.contains('active');
      menuToggle.innerHTML = isExpanded ? '&#x2715;' : '&#x2630;'; // X or Hamburger
    });
  }
  
  // Close menu on link click & handle active state
  navLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      // Smooth scroll behavior
      if (navMenu) navMenu.classList.remove('active');
      if (menuToggle) menuToggle.innerHTML = '&#x2630;';
    });
  });
  
  // Highlight active section on scroll
  function highlightNavLink() {
    let scrollPosition = window.scrollY + 100;
    
    document.querySelectorAll('section').forEach(section => {
      const top = section.offsetTop;
      const height = section.offsetHeight;
      const id = section.getAttribute('id');
      
      if (scrollPosition >= top && scrollPosition < top + height) {
        navLinks.forEach(link => {
          link.classList.remove('active');
          if (link.getAttribute('href') === `#${id}`) {
            link.classList.add('active');
          }
        });
      }
    });
  }
}

/* ==========================================
   2. Terminal Simulation (Hero Section)
   ========================================== */
const terminalLogsList = [
  { text: 'AegisCore Kernel v4.19.0-cyber-sec initialized...', type: 'sys' },
  { text: 'Establishing secure cryptographic handshake with satellite proxy...', type: 'sys' },
  { text: 'Loading zero-trust threat response vectors...', type: 'sys' },
  { text: 'SYSTEM INTEGRITY CHECK: 100% SECURE', type: 'cyan' },
  { text: 'Firewall Daemon Active. Monitoring ports 22, 80, 443, 8080...', type: 'sys' },
  { text: 'WARNING: Unusual ICMP packet burst detected from 192.0.2.112', type: 'red' },
  { text: 'Automated Response: Port-knocking sequences altered.', type: 'purple' },
  { text: 'Intrusion vector mitigated. IP added to temporary deny list.', type: 'cyan' },
  { text: 'Daily quantum-key distribution loop rotated successfully.', type: 'sys' },
  { text: 'Integrity Shield status: OPERATIONAL (100%)', type: 'cyan' },
  { text: 'Threat Intelligence feed synchronized (Database v94.12)', type: 'sys' },
  { text: 'ATTEMPTED SSH BRUTE FORCE on Node-03 blocked. Origin: 198.51.100.8', type: 'red' },
  { text: 'DDoS filter threshold increased to 50,000 req/sec.', type: 'purple' }
];

function initTerminalSimulation() {
  const terminalBody = document.getElementById('terminal-logs');
  if (!terminalBody) return;
  
  let logIndex = 0;
  
  // Print initial lines
  for (let i = 0; i < 6; i++) {
    printTerminalLine(terminalLogsList[logIndex]);
    logIndex++;
  }
  
  // Periodically add new log lines
  setInterval(() => {
    if (logIndex >= terminalLogsList.length) {
      logIndex = 0; // Loop logs
    }
    printTerminalLine(terminalLogsList[logIndex]);
    logIndex++;
    
    // Auto-scroll terminal
    terminalBody.scrollTop = terminalBody.scrollHeight;
  }, 4000);
}

function printTerminalLine(logObj) {
  const terminalBody = document.getElementById('terminal-logs');
  if (!terminalBody) return;
  
  // Remove cursor element first
  const existingCursor = terminalBody.querySelector('.cursor');
  if (existingCursor) {
    existingCursor.remove();
  }
  
  const line = document.createElement('div');
  line.className = `terminal-line ${logObj.type}`;
  
  const timestamp = new Date().toLocaleTimeString();
  line.innerHTML = `<span style="color: #475569">[${timestamp}]</span> > ${logObj.text}`;
  
  terminalBody.appendChild(line);
  
  // Re-add cursor to the end
  const cursor = document.createElement('div');
  cursor.className = 'terminal-line cursor';
  terminalBody.appendChild(cursor);
}

/* ==========================================
   3. Interactive Security Dashboard
   ========================================== */
function initThreatDashboard() {
  const scanBtn = document.getElementById('btn-start-scan');
  const dial = document.getElementById('threat-dial');
  const dialVal = document.getElementById('dial-val');
  const consoleLogs = document.getElementById('console-terminal-body');
  const scanProgress = document.getElementById('scan-progress-bar');
  const statThreats = document.getElementById('stat-threats');
  const statUptime = document.getElementById('stat-uptime');
  
  if (!scanBtn || !dial || !dialVal) return;
  
  let isScanning = false;
  let scanInterval;
  
  scanBtn.addEventListener('click', () => {
    if (isScanning) return;
    
    isScanning = true;
    scanBtn.innerText = 'SCANNING NETWORK...';
    scanBtn.classList.add('active');
    dial.classList.add('scanning');
    
    // Reset scanner progress bar if we build one
    if (scanProgress) {
      scanProgress.style.width = '0%';
    }
    
    printConsoleLine('[INIT] Executing global security audit & vulnerability scan...', 'sys');
    
    let progress = 0;
    let threatsFound = 0;
    let initialThreatVal = parseInt(dialVal.innerText);
    
    scanInterval = setInterval(() => {
      progress += Math.floor(Math.random() * 8) + 4;
      if (progress >= 100) progress = 100;
      
      if (scanProgress) {
        scanProgress.style.width = `${progress}%`;
      }
      
      // Update Threat Level Dial periodically
      let mockThreatLevel = Math.floor(Math.random() * 40) + 10;
      dialVal.innerText = `${mockThreatLevel}%`;
      
      // Generate Scanner Logs
      const steps = [
        { threshold: 15, msg: 'Checking Firewall Integrity matrices...', type: 'sys' },
        { threshold: 30, msg: 'Scanning local subnets & Docker networks for open ports...', type: 'sys' },
        { threshold: 45, msg: 'Analyzing SSL/TLS handshake certificates expiration...', type: 'sys' },
        { threshold: 60, msg: 'WARNING: Outdated service patch found on host node-04', type: 'red' },
        { threshold: 75, msg: 'Testing intrusion prevention system rules validation...', type: 'purple' },
        { threshold: 90, msg: 'Rotating server authentication credentials...', type: 'cyan' }
      ];
      
      steps.forEach(step => {
        if (progress >= step.threshold && progress < step.threshold + 12 && !step.triggered) {
          printConsoleLine(`[SCAN] ${step.msg}`, step.type);
          step.triggered = true; // prevents printing multiple times
          if (step.type === 'red') {
            threatsFound++;
          }
        }
      });
      
      if (progress >= 100) {
        clearInterval(scanInterval);
        isScanning = false;
        scanBtn.innerText = 'START VULNERABILITY SCAN';
        scanBtn.classList.remove('active');
        dial.classList.remove('scanning');
        dialVal.innerText = '12%'; // Return to normal status
        
        printConsoleLine('[SUCCESS] Global Security Audit Completed.', 'cyan');
        printConsoleLine(`[REPORT] 0 Critical vulnerabilities, ${threatsFound} Patch warnings mitigated.`, 'cyan');
        
        // Update stats on dashboard
        if (statThreats) {
          let currentThreats = parseInt(statThreats.innerText);
          statThreats.innerText = currentThreats + threatsFound;
        }
      }
      
      if (consoleLogs) {
        consoleLogs.scrollTop = consoleLogs.scrollHeight;
      }
    }, 400);
  });
}

function printConsoleLine(msg, type) {
  const consoleLogs = document.getElementById('console-terminal-body');
  if (!consoleLogs) return;
  
  const timestamp = new Date().toLocaleTimeString();
  const line = document.createElement('div');
  line.className = `terminal-line ${type}`;
  line.innerHTML = `<span style="color: #475569">[${timestamp}]</span> ${msg}`;
  consoleLogs.appendChild(line);
}

/* ==========================================
   4. Interactive Cipher Sandbox
   ========================================== */
function initCipherSandbox() {
  const cipherInput = document.getElementById('cipher-input');
  const cipherKey = document.getElementById('cipher-key');
  const cipherType = document.getElementById('cipher-type');
  const textOutput = document.getElementById('cipher-text-val');
  const binaryOutput = document.getElementById('cipher-binary-val');
  
  if (!cipherInput || !textOutput || !binaryOutput) return;
  
  const handleCipher = () => {
    const text = cipherInput.value;
    const key = cipherKey ? cipherKey.value : 'AEGIS';
    const type = cipherType ? cipherType.value : 'xor';
    
    if (!text) {
      textOutput.innerText = 'Awaiting input text stream...';
      binaryOutput.innerText = 'Binary representation output...';
      return;
    }
    
    let encryptedText = '';
    
    if (type === 'xor') {
      encryptedText = xorCipher(text, key);
    } else if (type === 'base64') {
      try {
        encryptedText = btoa(text);
      } catch (e) {
        encryptedText = 'Encoding Error';
      }
    } else if (type === 'binary') {
      encryptedText = stringToBinary(text);
    }
    
    textOutput.innerText = encryptedText;
    binaryOutput.innerText = stringToBinary(encryptedText);
  };
  
  cipherInput.addEventListener('input', handleCipher);
  if (cipherKey) cipherKey.addEventListener('input', handleCipher);
  if (cipherType) cipherType.addEventListener('change', handleCipher);
  
  // Custom XOR Cipher Function
  function xorCipher(txt, keyStr) {
    let result = '';
    for (let i = 0; i < txt.length; i++) {
      const charCode = txt.charCodeAt(i);
      const keyCode = keyStr.charCodeAt(i % keyStr.length);
      const xorValue = charCode ^ keyCode;
      
      // Convert to hexadecimal with 2 digits
      let hex = xorValue.toString(16).toUpperCase();
      if (hex.length < 2) hex = '0' + hex;
      result += hex + ' ';
    }
    return result.trim();
  }
  
  // String to Binary Helper
  function stringToBinary(str) {
    return str
      .split('')
      .map(char => {
        const bin = char.charCodeAt(0).toString(2);
        return '0'.repeat(8 - bin.length) + bin;
      })
      .join(' ');
  }
}

/* ==========================================
   5. Dynamic Threat Map (SVG Mapping)
   ========================================== */
const threatLocations = [
  { city: 'Frankfurt', x: 505, y: 138, type: 'mitigated' },
  { city: 'New York', x: 275, y: 165, type: 'blocked' },
  { city: 'Tokyo', x: 818, y: 175, type: 'mitigated' },
  { city: 'London', x: 472, y: 125, type: 'blocked' },
  { city: 'Sydney', x: 855, y: 380, type: 'mitigated' },
  { city: 'São Paulo', x: 365, y: 310, type: 'blocked' },
  { city: 'Cape Town', x: 535, y: 340, type: 'mitigated' }
];

const attackVectors = [
  'DDoS Ingress Wave',
  'SSH Brute Force Injection',
  'XSS Payload Injection',
  'Database Query Poisoning',
  'Zero-Day Vulnerability Exploit',
  'SSL Handshake Intercept'
];

function initThreatMap() {
  const mapSvg = document.getElementById('cyber-world-map');
  const alertList = document.getElementById('map-alert-logs');
  
  if (!mapSvg || !alertList) return;
  
  // Periodically trigger a cyber attack simulation
  setInterval(() => {
    // Pick a random city & attack vector
    const location = threatLocations[Math.floor(Math.random() * threatLocations.length)];
    const vector = attackVectors[Math.floor(Math.random() * attackVectors.length)];
    const isMitigated = Math.random() > 0.3;
    
    // Add visual ping to SVG map
    triggerMapPing(mapSvg, location.x, location.y, isMitigated ? 'cyan' : 'red');
    
    // Add text log to Alert panel
    addAlertLog(location.city, vector, isMitigated);
  }, 5000);
}

function triggerMapPing(svgElement, x, y, color) {
  // Create ping group
  const g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
  
  const ping = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
  ping.setAttribute('cx', x);
  ping.setAttribute('cy', y);
  ping.setAttribute('r', '4');
  ping.setAttribute('class', 'map-ping');
  if (color === 'cyan') {
    ping.style.fill = '#00f0ff';
  }
  
  const pulse = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
  pulse.setAttribute('cx', x);
  pulse.setAttribute('cy', y);
  pulse.setAttribute('r', '4');
  pulse.setAttribute('class', `map-ping-pulse ${color}`);
  
  g.appendChild(ping);
  g.appendChild(pulse);
  svgElement.appendChild(g);
  
  // Clean up element after animation is complete (2.5s)
  setTimeout(() => {
    g.remove();
  }, 2500);
}

function addAlertLog(city, vector, isMitigated) {
  const alertList = document.getElementById('map-alert-logs');
  if (!alertList) return;
  
  const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
  const statusText = isMitigated ? 'MITIGATED' : 'BLOCKED';
  const statusClass = isMitigated ? 'resolved' : 'threat';
  
  const item = document.createElement('div');
  item.className = 'map-log-item';
  item.innerHTML = `
    <span class="map-log-time">[${time}]</span>
    <span class="map-log-event"><strong>${city}</strong>: ${vector}</span>
    <span class="map-log-status ${statusClass}">${statusText}</span>
  `;
  
  alertList.insertBefore(item, alertList.firstChild);
  
  // Prune list to maximum 6 elements to keep clean UI
  if (alertList.children.length > 6) {
    alertList.removeChild(alertList.lastChild);
  }
}

/* ==========================================
   6. Contact Form Security Verification Simulation
   ========================================== */
function initContactForm() {
  const form = document.getElementById('cyber-contact-form');
  if (!form) return;
  
  form.addEventListener('submit', (e) => {
    e.preventDefault();
    
    // Simulated Transmission console message
    const submitBtn = form.querySelector('button[type="submit"]');
    const oldBtnText = submitBtn.innerText;
    
    submitBtn.disabled = true;
    submitBtn.innerText = 'UPLOADING DATA OVER HTTPS SECURE TUNNEL...';
    
    setTimeout(() => {
      submitBtn.innerText = 'TRANSMISSION COMPLETE. ENVELOPE SECURED.';
      submitBtn.style.background = '#39ff14';
      submitBtn.style.color = '#040814';
      submitBtn.style.borderColor = '#39ff14';
      submitBtn.style.boxShadow = '0 0 15px rgba(57, 255, 20, 0.4)';
      
      form.reset();
      
      setTimeout(() => {
        submitBtn.disabled = false;
        submitBtn.innerText = oldBtnText;
        submitBtn.style.background = '';
        submitBtn.style.color = '';
        submitBtn.style.borderColor = '';
        submitBtn.style.boxShadow = '';
      }, 3000);
    }, 2000);
  });
}
