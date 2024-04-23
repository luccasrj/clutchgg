let pvpModes = [
    {
        name: 'ZONA FUZIL',
        index: 'fuzil',
        icon: 'images/icon4.png',
    },

    {
        name: 'ZONA PISTOLA',
        index: 'pistol',
        icon: 'images/icon1.png',
    },

    {
        name: 'ZONA APPISTOL',
        index: 'appistol',
        icon: 'images/icon1.png',
    },
]

function renderModes(obj) {
    let container = document.querySelector('.modesUnits-container')
    container.innerHTML = ""
    for (let i in obj) {
        container.innerHTML += `
        <div class="item">
            <aside>
             <span>${obj[i].name}</span>
            </aside>
            <section>
            <img src="${obj[i].icon}">
            <footer>
                <div class="info">
                <small>descrição</small>
                <p>Divirta-se neste incrível modo de jogo</p>
                </div>
                <button data-index = '${obj[i].index}' onclick = 'playMode(event)'>jogar</button>
            </footer>
            </section>
        </div>
        `
    }
}

function playMode(event) {
    let element = event.currentTarget
    let index = element.dataset.index
    if (index == 'zonaspvp') {
        openPvpModes(pvpModes)
        return
    }
    let options = {
        method: 'POST',
        body: JSON.stringify({ index })
    }
    $('body').fadeOut(500);
    fetch('http://clutch-core/playMode', options)
}

function openPvpModes(obj) {
    let container = document.querySelector('.modesUnits-container')
    container.innerHTML = ''
    for (let i in obj) {
        container.innerHTML += `
        <div class="item">
            <aside>
             <span>${obj[i].name}</span>
            </aside>
            <section>
            <img src="${obj[i].icon}">
            <footer>
                <div class="info">
                <small>descrição</small>
                <p>Clique em jogar</p>
                </div>
                <button data-index = '${obj[i].index}' onclick = 'playMode(event)'>jogar</button>
            </footer>
            </section>
        </div>
        `
    }
}

document.querySelector('body').addEventListener('keydown', function (event) {
    if (event.keyCode == '27') {
        let options = {
            method: 'POST',
            body: JSON.stringify({})
        }
        $('body').fadeOut(500);
        fetch('http://clutch-core/closeModes', options)
    }
});

window.addEventListener('message', (event) => {
    if (event.data.showMenu) {
        $('body').fadeIn(500);
        renderModes(event.data.modes) // obj que deve ser mandado
    }

    if (event.data.death == true || event.data.show){
        $("#deathDiv").css("display","block");
    }

    if (event.data.text !== undefined) {
        $("#deathText").html(event.data.text);
    }

    if (event.data.death == false || event.data.show == false){
        $("#deathDiv").css("display","none");
        $("#deathText").html("");
    }

    if (event.data.deathtext !== undefined) {
        $("#deathText").html(event.data.deathtext);
    }
})