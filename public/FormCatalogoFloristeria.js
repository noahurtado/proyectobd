document.addEventListener("DOMContentLoaded", function() {

    const params = new URLSearchParams(window.location.search);
    const id_floristeriaa = params.get('id_floristeria');
    
    const Botonanadir = document.getElementById('Botonanadir');

    const Nombrecat = document.getElementById('Nombrecat');
    const Codvbn = document.getElementById('Codvbn');
    const elegirFlor = document.getElementById('Fondofield3');
    const elegirColor = document.getElementById('Fondofield10');
    const Descripcion = document.getElementById('Descripcion');
    const colorpicker = document.getElementById('colorpicker');
    const textoNombrecat = Nombrecat.textContent;
    const textoCodvbn = Codvbn.textContent;
    const textoDescripcion = Descripcion.textContent;


    const Anadirflortrue = document.querySelector('.Anadirflortrue');
    const Nombreflor = document.getElementById('Nombreflor');
    const Etimologia = document.getElementById('Etimologia');
    const Genero = document.getElementById('Genero');
    const Colores = document.getElementById('Colores');
    const Temperatura = document.getElementById('Temperatura');
    const Fieldflorlocked = document.querySelector('.Fieldflorlocked');
    const FieldAnadirColor = document.getElementById('FieldAnadirColor');
    FieldAnadirColor.style.visibility = 'hidden';
    const NombreColor = document.getElementById('NombreColor');
    const colorpicker2 = document.querySelector('.AnadirColorPicker');
    const FieldDescripcioncolor = document.querySelector('.FieldDescripcioncolor');
    const descripcioncolor = document.getElementById('Descripcioncolor');
    const textoNombreflor = Nombreflor.textContent;
    const textoEtimologia = Etimologia.textContent;
    const textoGenero = Genero.textContent;
    const textoColores = Colores.textContent;
    const textoTemperatura = Temperatura.textContent;
    const textoNombreColor = NombreColor.textContent;
    const textoDescripcioncolor = Descripcioncolor.textContent;


    const toggleFlor = document.querySelector('.Toggleflor');
    const rectangulo = document.querySelector('.Rectangulo');
    const circulo = document.querySelector('.Circulo');

    const toggleColor = document.querySelector('.Togglecolor');
    const rectangulo2 = document.querySelector('.Rectangulo2');
    const circulo2 = document.querySelector('.Circulo2');

    // Cargar y poblar el combo box con las flores
    fetch('/Flores')
    .then(response => response.json())
    .then(data => {
        populateComboBox1(data);
    })
    .catch(error => {
        console.error('Error:', error);
    });

    function populateComboBox1(flores) {
        flores.forEach(flor => {
            const option = document.createElement("option");
            option.value = flor.id_flor_corte;
            option.textContent = flor.nombre_comun;
            elegirFlor.appendChild(option);
        });
    }



        // Cargar y poblar el combo box con las flores
        fetch('/Colores')
        .then(response => response.json())
        .then(data => {
            populateComboBox2(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });

        function populateComboBox2(colores) {
        colores.forEach(color => {
            if (color.cod_hex && color.nombre) { // Verificar que ambos valores existan
                const option = document.createElement("option");
                option.value = color.cod_hex;
                option.textContent = color.nombre;
                elegirColor.appendChild(option);
            }
        });
        }


        elegirColor.addEventListener('change', function() {
            const selectedColor = elegirColor.value;
            colorpicker.style.backgroundColor = `#${selectedColor}`;
        });


    Nombrecat.addEventListener('focus', () => {
        Nombrecat.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    Nombrecat.addEventListener('blur', () => {
        if (Nombrecat.textContent.trim() === '') {
            Nombrecat.textContent = textoNombrecat; // Restaura el texto original si está vacío
        }
    });
    
    Codvbn.addEventListener('focus', () => {
        Codvbn.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    Codvbn.addEventListener('blur', () => {
        if (Codvbn.textContent.trim() === '') {
            Codvbn.textContent = textoCodvbn; // Restaura el texto original si está vacío
        }
    });
    
    Descripcion.addEventListener('focus', () => {
        Descripcion.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    Descripcion.addEventListener('blur', () => {
        if (Descripcion.textContent.trim() === '') {
            Descripcion.textContent = textoDescripcion; // Restaura el texto original si está vacío
        }
    });

    Nombreflor.addEventListener('focus', () => {
        Nombreflor.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    Nombreflor.addEventListener('blur', () => {
        if (Nombreflor.textContent.trim() === '') {
            Nombreflor.textContent = textoNombreflor; // Restaura el texto original si está vacío
        }
    });

    Etimologia.addEventListener('focus', () => {
        Etimologia.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    Etimologia.addEventListener('blur', () => {
        if (Etimologia.textContent.trim() === '') {
            Etimologia.textContent = textoEtimologia; // Restaura el texto original si está vacío
        }
    });

    Genero.addEventListener('focus', () => {
        Genero.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    Genero.addEventListener('blur', () => {
        if (Genero.textContent.trim() === '') {
            Genero.textContent = textoGenero; // Restaura el texto original si está vacío
        }
    });

    Colores.addEventListener('focus', () => {
        Colores.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    Colores.addEventListener('blur', () => {
        if (Colores.textContent.trim() === '') {
            Colores.textContent = textoColores; // Restaura el texto original si está vacío
        }
    });

    Temperatura.addEventListener('focus', () => {
        Temperatura.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    Temperatura.addEventListener('blur', () => {
        if (Temperatura.textContent.trim() === '') {
            Temperatura.textContent = textoTemperatura; // Restaura el texto original si está vacío
        }
    });

    NombreColor.addEventListener('focus', () => {
        NombreColor.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    NombreColor.addEventListener('blur', () => {
        if (NombreColor.textContent.trim() === '') {
            NombreColor.textContent = textoNombreColor; // Restaura el texto original si está vacío
        }
    });


    Descripcioncolor.addEventListener('focus', () => {
        Descripcioncolor.textContent = ''; // Elimina el texto al hacer clic y enfocar
    });

    Descripcioncolor.addEventListener('blur', () => {
        if (Descripcioncolor.textContent.trim() === '') {
            Descripcioncolor.textContent = textoDescripcioncolor; // Restaura el texto original si está vacío
        }
    });






    toggleFlor.addEventListener('click', () => {
        if (Anadirflortrue.style.visibility === 'hidden' || Anadirflortrue.style.visibility === '') {
            Anadirflortrue.style.visibility = 'visible';
            Fieldflorlocked.style.visibility = 'visible';
            rectangulo.style.backgroundColor = 'rgba(248, 191, 218, 0.42)';
            circulo.style.backgroundColor = 'rgba(248, 191, 218, 1)';
            circulo.style.left = '36.40px';
        } else {
            Anadirflortrue.style.visibility = 'hidden';
            Fieldflorlocked.style.visibility = 'hidden';
            rectangulo.style.backgroundColor = 'rgba(85, 112, 241, 0.12)';
            circulo.style.backgroundColor = 'rgba(187, 197, 203, 1)';
            circulo.style.left = '3.40px';
        }
    });


    toggleColor.addEventListener('click', () => {
        if (FieldAnadirColor.style.visibility === 'hidden') {
            FieldAnadirColor.style.visibility = 'visible';
            FieldDescripcioncolor.style.visibility = 'visible';
            rectangulo2.style.backgroundColor = 'rgba(248, 191, 218, 0.42)';
            circulo2.style.backgroundColor = 'rgba(248, 191, 218, 1)';
            circulo2.style.left = '36.40px';
        } else {
            FieldAnadirColor.style.visibility = 'hidden';
            FieldDescripcioncolor.style.visibility = 'hidden';
            rectangulo2.style.backgroundColor = 'rgba(85, 112, 241, 0.12)';
            circulo2.style.backgroundColor = 'rgba(187, 197, 203, 1)';
            circulo2.style.left = '3.40px';
        }
    });


    if (colorpicker2) {
        // Establecer el valor inicial del colorpicker como blanco
        colorpicker2.value = '#FFFFFF';
    colorpicker.addEventListener('input', function() {
        let colorValue = this.value;
    
        // Asegurarse de que el valor sea un código hexadecimal válido
        if (/^#[0-9A-F]{6}$/i.test(colorValue)) {
            alert('a');
            this.value = colorValue.toUpperCase(); // Convertir a mayúsculas
        } else {
            // Si el valor no es válido, restablecer al valor anterior
            this.value = '#FF0000';
        }
    });
} else {
    console.error('Elemento con ID "colorPicker" no encontrado');
}



    
if (Botonanadir) {

    Botonanadir.addEventListener('click', () => {
        // Oculta todos los mensajes de error inicialmente
        const mensajesError = document.querySelectorAll('.Mensajeerror1, .Mensajeerror2, .Mensajeerror3, .Mensajeerror4, .Mensajeerror5, .Mensajeerror6, .Mensajeerror7, .Mensajeerror8, .Mensajeerror9, .Mensajeerror10, .Mensajeerror11');
        const errores = document.querySelectorAll('.Error1, .Error2, .Error3, .Error4, .Error5, .Error6, .Error7, .Error8, .Error9, .Error10, .Error11');
    
        mensajesError.forEach(mensaje => mensaje.style.visibility = 'hidden');
        errores.forEach(error => error.style.visibility = 'hidden');
    
        let esValido = true; // Variable para controlar la validez de los campos
        let id_flor_corte = document.getElementById('Fondofield3').value; // Obtener el valor del select
        let nombre_color = document.getElementById('Fondofield10').value; // Obtener el valor del select
    
        // Verifica campos si Anadirflortrue está oculto
        if (Anadirflortrue.style.visibility === 'hidden') {
            if (FieldAnadirColor.style.visibility === 'hidden') {
            if (Nombrecat.textContent.trim() === textoNombrecat.trim()) {
                document.querySelector('.Mensajeerror1').style.visibility = 'visible';
                document.querySelector('.Error1').style.visibility = 'visible';
                esValido = false;
            }
            if (Codvbn.textContent.trim() === textoCodvbn.trim()) {
                document.querySelector('.Mensajeerror2').style.visibility = 'visible';
                document.querySelector('.Error2').style.visibility = 'visible';
                esValido = false;
            }
            if (!id_flor_corte) { // Verifica el select
                document.querySelector('.Mensajeerror3').style.visibility = 'visible';
                document.querySelector('.Error3').style.visibility = 'visible';
                esValido = false;
            }
            if (!nombre_color) { // Verifica el select
                document.querySelector('.Mensajeerror9').style.visibility = 'visible';
                document.querySelector('.Error9').style.visibility = 'visible';
                esValido = false;
            }
            }
        } 
        
        if (FieldAnadirColor.style.visibility === 'visible') {
            if (Nombrecat.textContent.trim() === textoNombrecat.trim()) {
                document.querySelector('.Mensajeerror1').style.visibility = 'visible';
                document.querySelector('.Error1').style.visibility = 'visible';
                esValido = false;
            }
            if (Codvbn.textContent.trim() === textoCodvbn.trim()) {
                document.querySelector('.Mensajeerror2').style.visibility = 'visible';
                document.querySelector('.Error2').style.visibility = 'visible';
                esValido = false;
            }
            //adicional
            if (NombreColor.textContent.trim() === textoNombreColor.trim()) {
                document.querySelector('.Mensajeerror10').style.visibility = 'visible';
                document.querySelector('.Error10').style.visibility = 'visible';
                esValido = false;
            }
            if (Descripcioncolor.textContent.trim() === textoDescripcioncolor.trim()) {
                document.querySelector('.Mensajeerror11').style.visibility = 'visible';
                document.querySelector('.Error11').style.visibility = 'visible';
                esValido = false;
            }
            if (Anadirflortrue.style.visibility === 'visible') {
                
                if (Nombreflor.textContent.trim() === textoNombreflor.trim()) {
                    document.querySelector('.Mensajeerror4').style.visibility = 'visible';
                    document.querySelector('.Error4').style.visibility = 'visible';
                    esValido = false;
                }
                if (Etimologia.textContent.trim() === textoEtimologia.trim()) {
                    document.querySelector('.Mensajeerror5').style.visibility = 'visible';
                    document.querySelector('.Error5').style.visibility = 'visible';
                    esValido = false;
                }
                if (Genero.textContent.trim() === textoGenero.trim()) {
                    document.querySelector('.Mensajeerror6').style.visibility = 'visible';
                    document.querySelector('.Error6').style.visibility = 'visible';
                    esValido = false;
                }
                if (Colores.textContent.trim() === textoColores.trim()) {
                    document.querySelector('.Mensajeerror7').style.visibility = 'visible';
                    document.querySelector('.Error7').style.visibility = 'visible';
                    esValido = false;
                }
                if (Temperatura.textContent.trim() === textoTemperatura.trim()) {
                    document.querySelector('.Mensajeerror8').style.visibility = 'visible';
                    document.querySelector('.Error8').style.visibility = 'visible';
                    esValido = false;
                }
            } else {
                if (!id_flor_corte) { // Verifica el select
                    document.querySelector('.Mensajeerror3').style.visibility = 'visible';
                    document.querySelector('.Error3').style.visibility = 'visible';
                    esValido = false;
                }
            }

        }
        
        
        if (Anadirflortrue.style.visibility === 'visible') { 
            if (FieldAnadirColor.style.visibility === 'hidden') {
                if (Nombrecat.textContent.trim() === textoNombrecat.trim()) {
                    document.querySelector('.Mensajeerror1').style.visibility = 'visible';
                    document.querySelector('.Error1').style.visibility = 'visible';
                    esValido = false;
                }
                if (Codvbn.textContent.trim() === textoCodvbn.trim()) {
                    document.querySelector('.Mensajeerror2').style.visibility = 'visible';
                    document.querySelector('.Error2').style.visibility = 'visible';
                    esValido = false;
                }
                if (!nombre_color) { // Verifica el select
                    document.querySelector('.Mensajeerror9').style.visibility = 'visible';
                    document.querySelector('.Error9').style.visibility = 'visible';
                    esValido = false;
                }

                //adicionales
                if (Nombreflor.textContent.trim() === textoNombreflor.trim()) {
                    document.querySelector('.Mensajeerror4').style.visibility = 'visible';
                    document.querySelector('.Error4').style.visibility = 'visible';
                    esValido = false;
                }
                if (Etimologia.textContent.trim() === textoEtimologia.trim()) {
                    document.querySelector('.Mensajeerror5').style.visibility = 'visible';
                    document.querySelector('.Error5').style.visibility = 'visible';
                    esValido = false;
                }
                if (Genero.textContent.trim() === textoGenero.trim()) {
                    document.querySelector('.Mensajeerror6').style.visibility = 'visible';
                    document.querySelector('.Error6').style.visibility = 'visible';
                    esValido = false;
                }
                if (Colores.textContent.trim() === textoColores.trim()) {
                    document.querySelector('.Mensajeerror7').style.visibility = 'visible';
                    document.querySelector('.Error7').style.visibility = 'visible';
                    esValido = false;
                }
                if (Temperatura.textContent.trim() === textoTemperatura.trim()) {
                    document.querySelector('.Mensajeerror8').style.visibility = 'visible';
                    document.querySelector('.Error8').style.visibility = 'visible';
                    esValido = false;
                }
            }
        }
    
        // Si todos los campos son válidos, enviar datos al servidor
        if (esValido) {
            // Añadir catálogo o flor
            if (Descripcion.textContent.trim() === textoDescripcion.trim()) {
                Descripcion.textContent = '';
            }
    
            




            
            
               
            
                
                    if (Anadirflortrue.style.visibility === 'hidden') {
                        if (FieldAnadirColor.style.visibility === 'hidden') {
                            const catalogoData = {
                                id_floristeria: id_floristeriaa,
                                nombre: Nombrecat.textContent.trim(),
                                cod_vbn: parseInt(Codvbn.textContent.trim(), 10),
                                cod_hex: String(elegirColor.value),
                                id_flor_corte: elegirFlor.value,
                                descripcion: Descripcion.textContent.trim()
                            };
                            fetch('/CatalogosFloristerias', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(catalogoData)
                            })
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('Error al añadir el catálogo');
                                }
                                return response.json();
                            })
                            .then(result => {
                                alert('Catálogo añadido exitosamente');
                                window.location.href = `catalogosfloristerias.html?id_floristeria=${id_floristeriaa}`;
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert(error.message);
                            });
                        } else {
                            const colorData = {
                                cod_hex: String(elegirColor.value),
                                nombre: document.getElementById('NombreColor').textContent.trim(),
                                descripcion: descripcioncolor.textContent.trim()
                            };
                    
                            fetch('/Colores', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(colorData)
                            })
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('Error al añadir el color');
                                }
                                return response.json();
                            })
                            .then(color => {
                                if (Anadirflortrue.style.visibility === 'visible') {
                                    const florData = {
                                        nombre_comun: Nombreflor.textContent.trim(),
                                        etimologia: Etimologia.textContent.trim(),
                                        genero_especie: Genero.textContent.trim(),
                                        colores: Colores.textContent.trim(),
                                        temperatura: parseFloat(Temperatura.textContent.trim())
                                    };
                            
                                    fetch('/Flores', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json'
                                        },
                                        body: JSON.stringify(florData)
                                    })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error('Error al añadir la flor');
                                        }
                                        return response.json();
                                    })
                                    .then(flor => {
                                        const catalogoData = {
                                            id_floristeria: id_floristeriaa,
                                            nombre: Nombrecat.textContent.trim(),
                                            cod_vbn: parseInt(Codvbn.textContent.trim(), 10),
                                            cod_hex: String(color.cod_hex),
                                            id_flor_corte: flor.id_flor_corte,
                                            descripcion: Descripcion.textContent.trim()
                                        };
                                        fetch('/CatalogosFloristerias', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/json'
                                            },
                                            body: JSON.stringify(catalogoData)
                                        })
                                        .then(response => {
                                            if (!response.ok) {
                                                throw new Error('Error al añadir el catálogo');
                                            }
                                            return response.json();
                                        })
                                        .then(result => {
                                            alert('Catálogo añadido exitosamente');
                                            window.location.href = `catalogosfloristerias.html?id_floristeria=${id_floristeriaa}`;
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            alert(error.message);
                                        });
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert(error.message);
                                    });
                                } else {
                                    const catalogoData = {
                                        id_floristeria: id_floristeriaa,
                                        nombre: Nombrecat.textContent.trim(),
                                        cod_vbn: parseInt(Codvbn.textContent.trim(), 10),
                                        cod_hex: String(color.cod_hex),
                                        id_flor_corte: elegirFlor.value,
                                        descripcion: Descripcion.textContent.trim()
                                    };
                                    fetch('/CatalogosFloristerias', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json'
                                        },
                                        body: JSON.stringify(catalogoData)
                                    })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error('Error al añadir el catálogo');
                                        }
                                        return response.json();
                                    })
                                    .then(result => {
                                        alert('Catálogo añadido exitosamente');
                                        window.location.href = `catalogosfloristerias.html?id_floristeria=${id_floristeriaa}`;
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert(error.message);
                                    });
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert(error.message);
                            });
                        }
                    } else {
                        if (FieldAnadirColor.style.visibility === 'hidden') {
                            const florData = {
                                nombre_comun: Nombreflor.textContent.trim(),
                                etimologia: Etimologia.textContent.trim(),
                                genero_especie: Genero.textContent.trim(),
                                colores: Colores.textContent.trim(),
                                temperatura: parseFloat(Temperatura.textContent.trim())
                            };
                    
                            fetch('/Flores', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(florData)
                            })
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('Error al añadir la flor');
                                }
                                return response.json();
                            })
                            .then(flor => {
                                const catalogoData = {
                                    id_floristeria: id_floristeriaa,
                                    nombre: Nombrecat.textContent.trim(),
                                    cod_vbn: parseInt(Codvbn.textContent.trim(), 10),
                                    cod_hex: String(elegirColor.value),
                                    id_flor_corte: flor.id_flor_corte,
                                    descripcion: Descripcion.textContent.trim()
                                };
                                fetch('/CatalogosFloristerias', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    body: JSON.stringify(catalogoData)
                                })
                                .then(response => {
                                    if (!response.ok) {
                                        throw new Error('Error al añadir el catálogo');
                                    }
                                    return response.json();
                                })
                                .then(result => {
                                    alert('Catálogo añadido exitosamente');
                                    window.location.href = `catalogosfloristerias.html?id_floristeria=${id_floristeriaa}`;
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    alert(error.message);
                                });
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert(error.message);
                            });
                        } else {
                            const colorData = {
                                cod_hex: String(elegirColor.value),
                                nombre: document.getElementById('NombreColor').textContent.trim(),
                                descripcion: descripcioncolor.textContent.trim()
                            };
                    
                            fetch('/Colores', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(colorData)
                            })
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('Error al añadir el color');
                                }
                                return response.json();
                            })
                            .then(color => {
                                if (Anadirflortrue.style.visibility === 'visible') {
                                    const florData = {
                                        nombre_comun: Nombreflor.textContent.trim(),
                                        etimologia: Etimologia.textContent.trim(),
                                        genero_especie: Genero.textContent.trim(),
                                        colores: Colores.textContent.trim(),
                                        temperatura: parseFloat(Temperatura.textContent.trim())
                                    };
                            
                                    fetch('/Flores', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json'
                                        },
                                        body: JSON.stringify(florData)
                                    })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error('Error al añadir la flor');
                                        }
                                        return response.json();
                                    })
                                    .then(flor => {
                                        const catalogoData = {
                                            id_floristeria: id_floristeriaa,
                                            nombre: Nombrecat.textContent.trim(),
                                            cod_vbn: parseInt(Codvbn.textContent.trim(), 10),
                                            cod_hex: String(color.cod_hex),
                                            id_flor_corte: flor.id_flor_corte,
                                            descripcion: Descripcion.textContent.trim()
                                        };
                                        fetch('/CatalogosFloristerias', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/json'
                                            },
                                            body: JSON.stringify(catalogoData)
                                        })
                                        .then(response => {
                                            if (!response.ok) {
                                                throw new Error('Error al añadir el catálogo');
                                            }
                                            return response.json();
                                        })
                                        .then(result => {
                                            alert('Catálogo añadido exitosamente');
                                            window.location.href = `catalogosfloristerias.html?id_floristeria=${id_floristeriaa}`;
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            alert(error.message);
                                        });
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert(error.message);
                                    });
                                } else {
                                    const catalogoData = {
                                        id_floristeria: id_floristeriaa,
                                        nombre: Nombrecat.textContent.trim(),
                                        cod_vbn: parseInt(Codvbn.textContent.trim(), 10),
                                        cod_hex: String(color.cod_hex),
                                        id_flor_corte: elegirFlor.value,
                                        descripcion: Descripcion.textContent.trim()
                                    };
                                    fetch('/CatalogosFloristerias', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json'
                                        },
                                        body: JSON.stringify(catalogoData)
                                    })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error('Error al añadir el catálogo');
                                        }
                                        return response.json();
                                    })
                                    .then(result => {
                                        alert('Catálogo añadido exitosamente');
                                        window.location.href = `catalogosfloristerias.html?id_floristeria=${id_floristeriaa}`;
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert(error.message);
                                    });
                                
                        }
                    });






                }







            Descripcion.textContent == textoDescripcion.trim();
        }

    }

    
});

} else {
    console.error('Elemento con ID "Botonanadir" no encontrado');
}


});
