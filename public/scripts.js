// scripts.js


/*
document.addEventListener("DOMContentLoaded", function() {
    const button = document.querySelector(".button");
    const form = document.getElementById("paisForm");

    button.addEventListener("click", function() {
        fetch('/Paises')
            .then(response => response.json())
            .then(data => {
                console.log('Datos recibidos:', data);
                displayData(data);
            })
            .catch(error => {
                console.error('Error:', error);
            });
    });

    form.addEventListener("submit", function(event) {
        event.preventDefault();

        const id_pais = document.getElementById("id_pais").value;
        const nombre_pais = document.getElementById("nombre_pais").value;

        fetch('/Paises', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id_pais, nombre_pais })
        })
        .then(response => {
            if (response.ok) {
                return response.text();
            } else {
                throw new Error('Error al guardar el país');
            }
        })
        .then(message => {
            console.log(message);
            alert('País añadido exitosamente');
            form.reset(); // Limpiar el formulario
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al guardar el país');
        });
    });

    function displayData(data) {
        const container = document.querySelector('.container');
        // Limpiar elementos previos
        while (container.firstChild) {
            container.removeChild(container.firstChild);
        }
        // Agregar lista de países
        const list = document.createElement('ul');

        data.forEach(item => {
            const listItem = document.createElement('li');
            listItem.textContent = `ID: ${item.id_pais}, Name: ${item.nombre_pais}`;
            list.appendChild(listItem);
        });

        container.appendChild(list);
    }
});

*/
document.addEventListener("DOMContentLoaded", function() {
    const botonAnadir = document.querySelector('.BotonaAdirflor');
    const botonRegistrar = document.getElementById('botonregistrar');
    const ventanaregistro = document.querySelector(".Ventanaregistro");

    fetch('/Flores')
    .then(response => response.json())
    .then(data => {
        displayData(data);
    }) .catch(error => {
        console.error('Error:', error);
    });
    


    fetch('/GenerosFlores')
    .then(response => response.json())
    .then(data => {
        populateComboBox(data);
    })
    .catch(error => {
        console.error('Error:', error);
    });
    
    function populateComboBox(generos) {
        const combobox = document.getElementById('genero-combobox1');
        generos.forEach(genero => {
            const option = document.createElement('option');
            option.value = genero.id_genero;
            option.textContent = genero.nombre_genero;
            combobox.appendChild(option);
        });
    }





    function displayData(flores) {
        flores.forEach((flor, index) => {
            switch (index) {
                case 0: updateCuadroFlor('CuadroFlor1', flor, 'Vbnflor1', 'Generoflor1', 'Textoflor1');
                        break;
                case 1: updateCuadroFlor('CuadroFlor2', flor, 'Vbnflor2', 'Generoflor2', 'Textoflor2');
                        break;
                case 2: updateCuadroFlor('CuadroFlor3', flor, 'Vbnflor3', 'Generoflor3', 'Textoflor3');
                        break;
                case 3: updateCuadroFlor('CuadroFlor4', flor, 'Vbnflor4', 'Generoflor4', 'Textoflor4');
                        break;
                case 4: updateCuadroFlor('CuadroFlor5', flor, 'Vbnflor5', 'Generoflor5', 'Textoflor5');
                        break;
                case 5: updateCuadroFlor('CuadroFlor6', flor, 'Vbnflor6', 'Generoflor6', 'Textoflor6');
                        break;
                default: console.warn(`No hay un cuadro definido para el índice: ${index}`);
            }
        });
    }
    
    
    function updateCuadroFlor(cuadroSelector, flor, vbnSelector, generoSelector, textoSelector) {
        const cuadroFlor = document.querySelector(`.${cuadroSelector}`);
        const vbnFlor = cuadroFlor.querySelector(`.${vbnSelector}`);
        const generoFlor = cuadroFlor.querySelector(`.${generoSelector}`);
        const textoFlor = cuadroFlor.querySelector(`.${textoSelector}`);

        cuadroFlor.style.visibility = 'visible';
        vbnFlor.style.visibility = 'visible';
        generoFlor.style.visibility = 'visible';
        textoFlor.style.visibility = 'visible';

        vbnFlor.textContent = `VBN no.${flor.vbn}`;
        generoFlor.textContent = flor.nombre_genero;
        textoFlor.textContent = flor.nombre_flor;
    }




    botonAnadir.addEventListener('click', function(){
        ventanaregistro.style.visibility = 'visible';
    });



    botonRegistrar.addEventListener('click', function(){
        const genero = document.getElementById("genero-combobox1").value;
        const idflor = document.getElementById("idflor").value;
        const nombreflor = document.getElementById("nombreflor").value;
        const vbn = document.getElementById("vbn").value;
        const temperatura = document.getElementById("temperatura").value;

        fetch('/Flores', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id_pais, nombre_pais })
        })
        .then(response => {
            if (response.ok) {
                return response.text();
            } else {
                throw new Error('Error al guardar el país');
            }
        })
        .then(message => {
            console.log(message);
            alert('País añadido exitosamente');
            form.reset(); // Limpiar el formulario
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al guardar el país');
        });
    });



    

});


