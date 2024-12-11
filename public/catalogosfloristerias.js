document.addEventListener("DOMContentLoaded", function() {
    // Obtener el id_floristeria de la URL
    const params = new URLSearchParams(window.location.search);
    const id_floristeria = params.get('id_floristeria');

    if (!id_floristeria) {
        console.error('id_floristeria no está presente en la URL');
        return;
    }

    //actualizar url
    const formCatalogoLink = document.querySelector('.formCatalogo');
    formCatalogoLink.href = `FormCatalogoFloristeria.html?id_floristeria=${id_floristeria}`;

    
// Obtener los detalles de la floristeria
    fetch(`/Floristerias/${id_floristeria}`) 
    .then(response => { 
        if (!response.ok) { 
            throw new Error('Error en la respuesta del servidor'); 
        } 
        return response.json(); 
    }) 
    .then(data => { 
        console.log(data);
        if (data && data.nombre) { 
            const NombreFloristeria = document.querySelector('.NombreFloristerA');
            NombreFloristeria.style.display = 'block'; 
            NombreFloristeria.innerText = data.nombre; 
        } else { 
            console.error('El nombre de la floristeria no está disponible'); 
        } 
    }) 
    .catch(error => { 
        console.error('Error al obtener los detalles de la floristeria:', error); 
    });


    // Cargar y mostrar los catálogos de la floristeria
    fetch(`/CatalogosFloristerias?id_floristeria=${id_floristeria}`)
    .then(response => response.json())
    .then(data => {
        displayCatalogs(data);
    })
    .catch(error => {
        console.error('Error:', error);
    });

    function displayCatalogs(catalogos) {
        const rectangles = [
            document.querySelector('.Cuadrocatalogo1'),
            document.querySelector('.Cuadrocatalogo2'),
            document.querySelector('.Cuadrocatalogo3'),
            document.querySelector('.Cuadrocatalogo4')
        ];
        const flechaDer = document.querySelector('.FlechaDer');
        const flechaIzq = document.querySelector('.FlechaIzq');
    
        let currentIndex = 0;
    
        // Inicialmente oculta todos los cuadros y flechas
        rectangles.forEach(rect => rect.style.display = 'none');
        flechaDer.style.display = 'none';
        flechaIzq.style.display = 'none';
    
        // Ordenar los catálogos por promedio (de mayor a menor) y por nombre (alfabéticamente) en caso de empate
        catalogos.sort((a, b) => {
            if (b.promedio === a.promedio) {
                return a.nombre_catalogo.localeCompare(b.nombre_catalogo);
            }
            return b.promedio - a.promedio;
        });
    
        // Mostrar los cuadros con datos
        updateRectangles(catalogos, rectangles, currentIndex);
    
        // Mostrar flechas si hay más de 4 catálogos
        if (catalogos.length > 4) {
            flechaDer.style.display = 'block';
    
            flechaDer.addEventListener('click', () => {
                currentIndex += 4;
                if (currentIndex >= catalogos.length) {
                    currentIndex = catalogos.length - 4;
                }
                updateRectangles(catalogos, rectangles, currentIndex);
    
                // Mostrar u ocultar flechas según el índice actual
                if (currentIndex + 4 >= catalogos.length) {
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
                updateRectangles(catalogos, rectangles, currentIndex);
    
                // Mostrar u ocultar flechas según el índice actual
                if (currentIndex + 4 >= catalogos.length) {
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

    function updateCuadroCatalogo(cuadro, catalogo, index) {
        // Actualizar la información básica del catálogo
        let promedio;
        switch(index) {
            case 0:
                cuadro.querySelector('.Catalogo1').innerText = catalogo.nombre_catalogo;
                cuadro.querySelector('.Vbn1').innerText = `VBN no. ${catalogo.cod_vbn}`;
                cuadro.querySelector('.Descripcion1').innerText = catalogo.descripcion;
                // Obtener el promedio del catálogo y actualizar las estrellas
                
                fetch(`/PromedioCatalogo?id_floristeria=${id_floristeria}&cod_vbn=${catalogo.cod_vbn}`)
                        .then(response => response.json())
                        .then(data => {
                            promedio = data.promedio;
                            cuadro.querySelector('.Estrella1Valoracion1').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella2Valoracion1').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella3Valoracion1').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella4Valoracion1').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella5Valoracion1').src = 'images/star_fill.png';
                                switch(promedio) {
                                    case 0:
                                        cuadro.querySelector('.Estrella1Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella2Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella3Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion1').src = 'images/star_unfilled.png';
                                        break;
                                    case 1:
                                        cuadro.querySelector('.Estrella2Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella3Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion1').src = 'images/star_unfilled.png';
                                        break;
                                    case 2:
                                        cuadro.querySelector('.Estrella3Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion1').src = 'images/star_unfilled.png';
                                        break;
                                    case 3:
                                        cuadro.querySelector('.Estrella4Valoracion1').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion1').src = 'images/star_unfilled.png';
                                        break;
                                    case 4:
                                        cuadro.querySelector('.Estrella5Valoracion1').src = 'images/star_unfilled.png';
                                        break;
                                }
                        
                            
                        })
                        .catch(error => {
                            console.error('Error al obtener el promedio del catálogo:', error);
                        });
                break;
            case 1:
                cuadro.querySelector('.Catalogo2').innerText = catalogo.nombre_catalogo;
                cuadro.querySelector('.Vbn2').innerText = `VBN no. ${catalogo.cod_vbn}`;
                cuadro.querySelector('.Descripcion2').innerText = catalogo.descripcion;

                fetch(`/PromedioCatalogo?id_floristeria=${id_floristeria}&cod_vbn=${catalogo.cod_vbn}`)
                        .then(response => response.json())
                        .then(data => {
                            promedio = data.promedio;
                            
                            cuadro.querySelector('.Estrella1Valoracion2').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella2Valoracion2').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella3Valoracion2').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella4Valoracion2').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella5Valoracion2').src = 'images/star_fill.png';
                                switch(promedio) {
                                    case 0:
                                        cuadro.querySelector('.Estrella1Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella2Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella3Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion2').src = 'images/star_unfilled.png';
                                        break;
                                    case 1:
                                        cuadro.querySelector('.Estrella2Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella3Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion2').src = 'images/star_unfilled.png';
                                        break;
                                    case 2:
                                        cuadro.querySelector('.Estrella3Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion2').src = 'images/star_unfilled.png';
                                        break;
                                    case 3:
                                        cuadro.querySelector('.Estrella4Valoracion2').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion2').src = 'images/star_unfilled.png';
                                        break;
                                    case 4:
                                        cuadro.querySelector('.Estrella5Valoracion2').src = 'images/star_unfilled.png';
                                        break;
                                }
                            
                        })
                        .catch(error => {
                            console.error('Error al obtener el promedio del catálogo:', error);
                        });
                break;
            case 2:
                cuadro.querySelector('.Catalogo3').innerText = catalogo.nombre_catalogo;
                cuadro.querySelector('.Vbn3').innerText = `VBN no. ${catalogo.cod_vbn}`;
                cuadro.querySelector('.Descripcion3').innerText = catalogo.descripcion;

                fetch(`/PromedioCatalogo?id_floristeria=${id_floristeria}&cod_vbn=${catalogo.cod_vbn}`)
                        .then(response => response.json())
                        .then(data => {
                            promedio = data.promedio;
                            
                            cuadro.querySelector('.Estrella1Valoracion3').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella2Valoracion3').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella3Valoracion3').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella4Valoracion3').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella5Valoracion3').src = 'images/star_fill.png';
                                switch(promedio) {
                                    case 0:
                                        cuadro.querySelector('.Estrella1Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella2Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella3Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion3').src = 'images/star_unfilled.png';
                                        break;
                                    case 1:
                                        cuadro.querySelector('.Estrella2Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella3Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion3').src = 'images/star_unfilled.png';
                                        break;
                                    case 2:
                                        cuadro.querySelector('.Estrella3Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion3').src = 'images/star_unfilled.png';
                                        break;
                                    case 3:
                                        cuadro.querySelector('.Estrella4Valoracion3').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion3').src = 'images/star_unfilled.png';
                                        break;
                                    case 4:
                                        cuadro.querySelector('.Estrella5Valoracion3').src = 'images/star_unfilled.png';
                                        break;
                                }
                            
                        })
                        .catch(error => {
                            console.error('Error al obtener el promedio del catálogo:', error);
                        });
                break;
            case 3:
                cuadro.querySelector('.Catalogo4').innerText = catalogo.nombre_catalogo;
                cuadro.querySelector('.Vbn4').innerText = `VBN no. ${catalogo.cod_vbn}`;
                cuadro.querySelector('.Descripcion4').innerText = catalogo.descripcion;

                fetch(`/PromedioCatalogo?id_floristeria=${id_floristeria}&cod_vbn=${catalogo.cod_vbn}`)
                        .then(response => response.json())
                        .then(data => {
                            promedio = data.promedio;
                            
                            cuadro.querySelector('.Estrella1Valoracion4').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella2Valoracion4').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella3Valoracion4').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella4Valoracion4').src = 'images/star_fill.png';
                            cuadro.querySelector('.Estrella5Valoracion4').src = 'images/star_fill.png';
                                switch(promedio) {
                                    case 0:
                                        cuadro.querySelector('.Estrella1Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella2Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella3Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion4').src = 'images/star_unfilled.png';
                                        break;
                                    case 1:
                                        cuadro.querySelector('.Estrella2Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella3Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion4').src = 'images/star_unfilled.png';
                                        break;
                                    case 2:
                                        cuadro.querySelector('.Estrella3Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella4Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion4').src = 'images/star_unfilled.png';
                                        break;
                                    case 3:
                                        cuadro.querySelector('.Estrella4Valoracion4').src = 'images/star_unfilled.png';
                                        cuadro.querySelector('.Estrella5Valoracion4').src = 'images/star_unfilled.png';
                                        break;
                                    case 4:
                                        cuadro.querySelector('.Estrella5Valoracion4').src = 'images/star_unfilled.png';
                                        break;
                                }
                            
                        })
                        .catch(error => {
                            console.error('Error al obtener el promedio del catálogo:', error);
                        });
                break;
        }
    
        
    }
    


    // Función para actualizar la visualización de los cuadros
    function updateRectangles(catalogos, rectangles, startIndex) {
        // Ocultar todos los cuadros
        rectangles.forEach(rect => rect.style.display = 'none');
    
        // Mostrar los cuadros correspondientes
        for (let i = 0; i < rectangles.length; i++) {
            const catalogoIndex = startIndex + i;
            if (catalogoIndex < catalogos.length) {
                const catalogo = catalogos[catalogoIndex];
                const cuadro = rectangles[i];
                updateCuadroCatalogo(cuadro, catalogo, i);
                cuadro.style.display = 'block';
            }
        }
    }
});
