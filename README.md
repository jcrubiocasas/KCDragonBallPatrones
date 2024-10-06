AppPatronesNombre - Proyecto Final de Patrones de Diseño MVVM

Autor: Juan Carlos Rubio Casas
Contacto: rubiocasasjuancarlos@gmail.com

Objetivo de la Práctica

El objetivo de esta práctica es desarrollar una aplicación llamada AppPatronesNombre utilizando la arquitectura MVVM (Model-View-ViewModel). La aplicación simula la estructura de un proyecto real de iOS que sigue buenas prácticas en la separación de responsabilidades y modularidad, asegurando que la lógica de negocio esté bien separada de la presentación.

Funcionalidades Principales

    •    Pantalla de Login: El usuario introduce sus credenciales para autenticarse en la aplicación.
    •    Pantalla Home: Muestra una lista de personajes (héroes) obtenidos de una API (se recomienda usar la API de Dragon Ball).
    •    Pantalla Detalle: Muestra información detallada de un héroe seleccionado.
    •    Pantalla de Transformaciones: Lista todas las transformaciones de un héroe.
    •    Pantalla Detalle de Transformación: Muestra los detalles de una transformación seleccionada.

Requisitos

Para completar la práctica, se debe implementar correctamente la arquitectura MVVM, asegurando la separación de responsabilidades entre los modelos de datos, la lógica de negocio y la presentación.

Requisitos Mínimos:

    •    Implementar los modelos de datos necesarios para mostrar la información de personajes y transformaciones.
    •    La aplicación debe cargar con datos por defecto al iniciarse.
    •    Deben implementarse tres pantallas principales: Login, Home (listado de personajes), y Detalle (detalles del personaje).
    •    Las pantallas deben estar correctamente enlazadas, y se debe implementar un flujo de navegación lógico.
    •    Se deben realizar pruebas unitarias que validen la lógica del proyecto.

Requisitos Adicionales:

    1.    Crear una pantalla adicional que muestre la lista de transformaciones de los héroes.
    2.    Crear otra pantalla que muestre los detalles específicos de una transformación.
    3.    Implementar todo el flujo desde la pantalla principal hasta las pantallas de detalle de transformaciones, utilizando casos de uso, ViewModel, y llamadas a la API.

Estructura del Proyecto

1. Modelo de Datos

    •    Hero: Representa a un héroe con atributos como nombre, descripción, imagen, y un indicador de favorito.
    •    Transformation: Representa una transformación de un héroe con atributos como nombre, descripción, e imagen.

2. Casos de Uso

    •    GetAllHeroesUseCase: Se encarga de obtener la lista de todos los héroes.
    •    GetHeroUseCase: Obtiene los detalles de un héroe específico.
    •    GetAllTransformationsUseCase: Obtiene todas las transformaciones de un héroe específico.
    •    LoginUseCase: Maneja la autenticación del usuario.

3. ViewModels

    •    LoginViewModel: Gestiona el estado de la pantalla de login, asegurando la autenticación del usuario.
    •    HeroesListViewModel: Controla el flujo de datos de la lista de héroes y se comunica con la vista para actualizarla cuando sea necesario.
    •    HeroDetailViewModel: Maneja los datos detallados de un héroe seleccionado, así como sus transformaciones.
    •    TransformationsListViewModel: Se encarga de gestionar los datos de la lista de transformaciones de un héroe.
    •    TransformationDetailViewModel: Controla los datos de la vista de detalle de una transformación.

4. Vistas (ViewControllers)

    •    LoginViewController: Muestra la pantalla de login y captura las credenciales del usuario.
    •    HeroesListViewController: Muestra la lista de héroes obtenidos y permite la selección de un héroe.
    •    HeroDetailViewController: Muestra los detalles de un héroe seleccionado y sus transformaciones.
    •    TransformationsViewController: Presenta una lista de transformaciones de un héroe.
    •    TransformationDetailViewController: Muestra información detallada sobre una transformación específica.

5. Celdas Personalizadas

    •    HeroTableViewCell: Muestra cada héroe en la lista de héroes.
    •    TransformationsTableViewCell: Muestra cada transformación en la lista de transformaciones.

6. Binding

    •    Se utiliza la clase Binding<State> para enlazar el estado de los ViewModels con las vistas, permitiendo una actualización reactiva de la interfaz de usuario.

Pasos Seguidos

    1.    Definición del Modelo de Datos: Se crearon las estructuras Hero y Transformation para representar los personajes y sus transformaciones, respectivamente. Estas estructuras se integran en el flujo de datos de la aplicación.
    2.    Implementación de la Lógica de Negocio: Se desarrollaron los casos de uso que gestionan las interacciones con los datos. Cada caso de uso sigue los principios de inyección de dependencias, lo que facilita las pruebas unitarias y la reutilización del código.
    3.    Diseño del MVVM: Se implementaron los ViewModels para cada pantalla, asegurando que la lógica de negocio esté separada de las vistas y que las vistas solo reaccionen a los cambios en los datos.
    4.    Construcción de las Vistas: Se desarrollaron las vistas utilizando UIViewControllers y celdas personalizadas. Las vistas interactúan con los ViewModels a través de bindings.
    5.    Navegación y Coordinación: Utilizando patrones de construcción como Builder, se implementaron las transiciones entre pantallas (Login, Home, Detalle de Héroe, Lista de Transformaciones, y Detalle de Transformación).
    6.    Pruebas Unitarias: Se implementaron pruebas unitarias para asegurar que los casos de uso y ViewModels funcionen correctamente. Estas pruebas validan tanto los flujos exitosos como los errores potenciales.
    7.    Interfaz de Usuario Reactiva: Se empleó la clase Binding<State> para actualizar las vistas de manera reactiva en función de los cambios en el estado del ViewModel.

Conclusión

La aplicación AppPatronesNombre sigue una arquitectura robusta basada en MVVM, que asegura la separación de responsabilidades y facilita tanto el mantenimiento del código como la ampliación de funcionalidades. Además, la integración de pruebas unitarias garantiza que la lógica de negocio sea fiable y funcione como se espera.

Para cualquier duda o consulta, no dudes en contactarme en:
Juan Carlos Rubio Casas
rubiocasasjuancarlos@gmail.com
