const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
      }
    });
  },
  { threshold: 0.2 }
);

document
  .querySelectorAll(".fade-in-up, .slide-left, .slide-right, .zoom-in")
  .forEach((el) => {
    observer.observe(el);
  });

window.addEventListener("scroll", () => {
  const nav = document.querySelector(".navbar");
  if (window.scrollY > 80) nav.classList.add("scrolled");
  else nav.classList.remove("scrolled");
});

window.addEventListener("load", () => {
  const imgs = document.querySelectorAll(".equal-img");
  if (imgs.length) {
    let maxH = 0;
    imgs.forEach((img) => {
      if (img.clientHeight > maxH) maxH = img.clientHeight;
    });
    imgs.forEach((img) => (img.style.height = maxH + "px"));
  }
});

window.addEventListener("scroll", () => {
  const btn = document.querySelector(".back-to-top");
  if (!btn) return;
  if (window.scrollY > 200) {
    btn.style.opacity = "1";
    btn.style.pointerEvents = "auto";
  } else {
    btn.style.opacity = "0";
    btn.style.pointerEvents = "none";
  }
});
