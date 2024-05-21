function toggleMenu() {
    const menu = document.querySelector(".menu-links");
    const icon = document.querySelector(".hamburger-icon");
    menu.classList.toggle("open")
    icon.classList.toggle("open")
}

function incrementVisitorCounter() {
    fetch('https://bedvhlyplb.execute-api.us-west-2.amazonaws.com/add')
    .then(response => response.json())
    .then((data) => {
        document.getElementById('visitor_counter').innerText = data.Count
    })
}