// MARK: - Credentials
// Esta estructura simple representa las credenciales de un usuario, que contienen un nombre de usuario (`username`) y una contraseña (`password`).
// Se utiliza comúnmente en solicitudes de autenticación, como parte del cuerpo o las cabeceras de una solicitud HTTP.
struct Credentials {
    
    // El nombre de usuario proporcionado por el usuario.
    let username: String
    
    // La contraseña proporcionada por el usuario.
    let password: String
}
