document.addEventListener("DOMContentLoaded", () => {
    // Profile Dropdown Toggle
    document.addEventListener("click", function(e) {
        let box = document.querySelector(".admin-profile");
        let menu = document.querySelector(".admin-menu");
        if (box && box.contains(e.target)) {
            box.classList.toggle("open");
            menu.classList.toggle("open");
        } else if (menu) {
            menu.classList.remove("open");
            if (box) box.classList.remove("open");
        }
    });

    // Sidebar Dropdowns Toggle (Accordions)
    document.querySelectorAll(".dropdown-btn").forEach(btn => {
        btn.addEventListener("click", () => {
            let submenu = btn.nextElementSibling;
            if (submenu) {
                submenu.classList.toggle("open");
            }
            let icon = btn.querySelector(".drop-icon");
            if (icon) {
                icon.classList.toggle("rotate");
            }
        });
    });
});
