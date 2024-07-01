function toggleMenu() {
    const menu = document.querySelector(".menu-links");
    const icon = document.querySelector(".hamburger-icon");
    menu.classList.toggle("open")
    icon.classList.toggle("open")
}

function incrementVisitorCounter() {

    const requestOptions = {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title: 'TEST' })
    };

    fetch('https://u4baeh4ebh.execute-api.us-west-2.amazonaws.com/add', requestOptions)
    .then(response => response.json())
    .then((data) => {
        document.getElementById('visitor_counter').innerText = data.Count
    })
}