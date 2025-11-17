const confettiCanvas = document.createElement("canvas");
confettiCanvas.id = "confetti-canvas";
document.body.appendChild(confettiCanvas);
const ctx = confettiCanvas.getContext("2d");
confettiCanvas.width = window.innerWidth;
confettiCanvas.height = window.innerHeight;

const confettiPieces = [];
const colors = ["#80c600", "#ffcc00", "#00bcd4", "#ff4081", "#ffffff"];

function random(min, max) {
  return Math.random() * (max - min) + min;
}

for (let i = 0; i < 100; i++) {
  confettiPieces.push({
    x: random(0, confettiCanvas.width),
    y: random(-confettiCanvas.height, 0),
    r: random(4, 8),
    color: colors[Math.floor(Math.random() * colors.length)],
    speed: random(1, 3),
    tilt: random(-10, 10),
  });
}

function drawConfetti() {
  ctx.clearRect(0, 0, confettiCanvas.width, confettiCanvas.height);
  confettiPieces.forEach((p) => {
    const gradient = ctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, p.r * 2);
    gradient.addColorStop(0, "rgba(255,255,255,0.7)");
    gradient.addColorStop(1, p.color);
    ctx.beginPath();
    ctx.fillStyle = gradient;
    ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
    ctx.fill();
  });
}

function updateConfetti() {
  confettiPieces.forEach((p) => {
    p.y += p.speed;
    p.x += Math.sin(p.tilt / 10);
    p.tilt += 1;
  });
}

let frameCount = 0;
function animateConfetti() {
  drawConfetti();
  updateConfetti();
  frameCount++;

  if (frameCount < 500) {
    // ~4s
    requestAnimationFrame(animateConfetti);
  } else {
    fadeOutCanvas();
  }
}

function fadeOutCanvas() {
  let opacity = 1;
  const fade = setInterval(() => {
    opacity -= 0.04;
    ctx.globalAlpha = opacity;
    drawConfetti();
    if (opacity <= 0) {
      clearInterval(fade);
      ctx.clearRect(0, 0, confettiCanvas.width, confettiCanvas.height);
      confettiCanvas.remove();
    }
  }, 60);
}

animateConfetti();

document.addEventListener("DOMContentLoaded", () => {
  const audio = new Audio("/client/audio/success-tone.mp3");
  audio.volume = 0.3;
  audio.play().catch(() => {});
});

// Nút quay về trang chủ
const continueBtn = document.querySelector(".continue-btn");
if (continueBtn) {
  continueBtn.addEventListener("click", (event) => {
    const targetHref = continueBtn.getAttribute("href") || "/";
    if (continueBtn.tagName.toLowerCase() === "a") {
      event.preventDefault();
    }
    window.location.href = targetHref;
  });
}

// Tự resize canvas nếu thay đổi kích thước cửa sổ
window.addEventListener("resize", () => {
  confettiCanvas.width = window.innerWidth;
  confettiCanvas.height = window.innerHeight;
});
