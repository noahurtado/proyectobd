document.addEventListener("DOMContentLoaded", function() {
    // Cargar y mostrar los productores existentes
    fetch('/Productores')
    .then(response => response.json())
    .then(data => {
        displayData(data);
    })
    .catch(error => {
        console.error('Error:', error);
    });

    function displayData(productores) {
        console.log(productores);
        const rectangles = [
            document.querySelector('.Cuadroproductor1'),
            document.querySelector('.Cuadroproductor2'),
            document.querySelector('.Cuadroproductor3'),
            document.querySelector('.Cuadroproductor4')
        ];
        const flechaDer = document.querySelector('.FlechaDer');
        const flechaIzq = document.querySelector('.FlechaIzq');

        let currentIndex = 0;

        // Inicialmente oculta todos los cuadros y flechas
        rectangles.forEach(rect => rect.style.display = 'none');
        flechaDer.style.display = 'none';
        flechaIzq.style.display = 'none';

        // Mostrar los cuadros con datos
        updateRectangles(productores, rectangles, currentIndex);

        // Mostrar flechas si hay más de 4 productores
        if (productores.length > 4) {
            flechaDer.style.display = 'block';

            flechaDer.addEventListener('click', () => {
                currentIndex += 4;
                if (currentIndex >= productores.length) {
                    currentIndex = productores.length - 4;
                }
                updateRectangles(productores, rectangles, currentIndex);

                // Mostrar u ocultar flechas según el índice actual
                if (currentIndex + 4 >= productores.length) {
                    flechaDer.style.display = 'none';
                } else {
                    flechaDer.style.display = 'block';
                }

                if (currentIndex > 0) {
                    flechaIzq.style.display = 'block';
                } else {
                    flechaIzq.style.display = 'none';
                }
            });

            flechaIzq.addEventListener('click', () => {
                currentIndex -= 4;
                if (currentIndex < 0) {
                    currentIndex = 0;
                }
                updateRectangles(productores, rectangles, currentIndex);

                // Mostrar u ocultar flechas según el índice actual
                if (currentIndex + 4 >= productores.length) {
                    flechaDer.style.display = 'none';
                } else {
                    flechaDer.style.display = 'block';
                }

                if (currentIndex > 0) {
                    flechaIzq.style.display = 'block';
                } else {
                    flechaIzq.style.display = 'none';
                }
            });
        }
    }

    // Función para actualizar la información de un cuadro
    function updateCuadroProductor(cuadro, productor, index) {
        switch(index) {
            case 0:
                cuadro.querySelector('.Paisprod1').innerText = productor.pais_nombre;
                cuadro.querySelector('.Sitioprod1').innerText = productor.sitio_web;
                cuadro.querySelector('.Productor1').innerText = productor.nombre;
                cuadro.querySelector('a').href = `catalogos.html?id_productor=${productor.id_productor}`;
                break;
            case 1:
                cuadro.querySelector('.Paisprod2').innerText = productor.pais_nombre;
                cuadro.querySelector('.Sitioprod2').innerText = productor.sitio_web;
                cuadro.querySelector('.Productor2').innerText = productor.nombre;
                cuadro.querySelector('a').href = `catalogos.html?id_productor=${productor.id_productor}`;
                break;
            case 2:
                cuadro.querySelector('.Paisprod3').innerText = productor.pais_nombre;
                cuadro.querySelector('.Sitioprod3').innerText = productor.sitio_web;
                cuadro.querySelector('.Productor3').innerText = productor.nombre;
                cuadro.querySelector('a').href = `catalogos.html?id_productor=${productor.id_productor}`;
                break;
            case 3:
                cuadro.querySelector('.Paisprod4').innerText = productor.pais_nombre;
                cuadro.querySelector('.Sitioprod4').innerText = productor.sitio_web;
                cuadro.querySelector('.Productor4').innerText = productor.nombre;
                cuadro.querySelector('a').href = `catalogos.html?id_productor=${productor.id_productor}`;
                break;
        }
    }

    // Función para actualizar la visualización de los cuadros
    function updateRectangles(productores, rectangles, startIndex) {
        rectangles.forEach(rect => rect.style.display = 'none');
        productores.slice(startIndex, startIndex + 4).forEach((productor, index) => {
            const rect = rectangles[index];
            if (rect) {
                rect.style.display = 'block';
                updateCuadroProductor(rect, productor, index);
            }
        });
    }
});
