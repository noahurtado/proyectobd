document.addEventListener("DOMContentLoaded", function() {
    // Cargar y mostrar los productores existentes
    fetch('/Floristerias')
    .then(response => response.json())
    .then(data => {
        displayData(data);
    })
    .catch(error => {
        console.error('Error:', error);
    });

    function displayData(floristerias) {
        const rectangles = [
            document.querySelector('.Cuadrofloristeria1'),
            document.querySelector('.Cuadrofloristeria2'),
            document.querySelector('.Cuadrofloristeria3'),
            document.querySelector('.Cuadrofloristeria4')
        ];
        const flechaDer = document.querySelector('.FlechaDer');
        const flechaIzq = document.querySelector('.FlechaIzq');

        let currentIndex = 0;

        // Inicialmente oculta todos los cuadros y flechas
        rectangles.forEach(rect => rect.style.display = 'none');
        flechaDer.style.display = 'none';
        flechaIzq.style.display = 'none';

        // Mostrar los cuadros con datos
        updateRectangles(floristerias, rectangles, currentIndex);

        // Mostrar flechas si hay más de 4 productores
        if (floristerias.length > 4) {
            flechaDer.style.display = 'block';

            flechaDer.addEventListener('click', () => {
                currentIndex += 4;
                if (currentIndex >= floristerias.length) {
                    currentIndex = floristerias.length - 4;
                }
                updateRectangles(floristerias, rectangles, currentIndex);

                // Mostrar u ocultar flechas según el índice actual
                if (currentIndex + 4 >= floristerias.length) {
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
                updateRectangles(floristerias, rectangles, currentIndex);

                // Mostrar u ocultar flechas según el índice actual
                if (currentIndex + 4 >= floristerias.length) {
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
    function updateCuadroFloristeria(cuadro, floristerias, index) {
        switch(index) {
            case 0:
                cuadro.querySelector('.Paisflor1').innerText = floristerias.pais_nombre;
                cuadro.querySelector('.emailflor1').innerText = floristerias.email;
                cuadro.querySelector('.FLoristeria1').innerText = floristerias.nombre;
                cuadro.querySelector('a').href = `catalogosfloristerias.html?id_productor=${floristerias.id_floristeria}`;
                break;
            case 1:
                cuadro.querySelector('.Paisflor2').innerText = floristerias.pais_nombre;
                cuadro.querySelector('.emailflor2').innerText = floristerias.email;
                cuadro.querySelector('.FLoristeria2').innerText = floristerias.nombre;
                cuadro.querySelector('a').href = `catalogosfloristerias.html?id_productor=${floristerias.id_floristeria}`;
                break;
            case 2:
                cuadro.querySelector('.Paisflor3').innerText = floristerias.pais_nombre;
                cuadro.querySelector('.emailflor3').innerText = floristerias.email;
                cuadro.querySelector('.FLoristeria3').innerText = floristerias.nombre;
                cuadro.querySelector('a').href = `catalogosfloristerias.html?id_productor=${floristerias.id_floristeria}`;
                break;
            case 3:
                cuadro.querySelector('.Paisflor4').innerText = floristerias.pais_nombre;
                cuadro.querySelector('.emailflor4').innerText = floristerias.email;
                cuadro.querySelector('.FLoristeria4').innerText = floristerias.nombre;
                cuadro.querySelector('a').href = `catalogosfloristerias.html?id_productor=${floristerias.id_floristeria}`;
                break;
        }
    }

    // Función para actualizar la visualización de los cuadros
    function updateRectangles(floristerias, rectangles, startIndex) {
        rectangles.forEach(rect => rect.style.display = 'none');
        floristerias.slice(startIndex, startIndex + 4).forEach((floristerias, index) => {
            const rect = rectangles[index];
            if (rect) {
                rect.style.display = 'block';
                updateCuadroFloristeria(rect, floristerias, index);
            }
        });
    }
});
