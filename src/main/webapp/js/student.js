document.addEventListener("DOMContentLoaded", () => {
    document.addEventListener("click", function (e) {
        const box = document.querySelector(".profile-dropdown");
        if (box) {
            if (box.contains(e.target)) {
                box.classList.toggle("open");
            } else {
                box.classList.remove("open");
            }
        }
    });
});
